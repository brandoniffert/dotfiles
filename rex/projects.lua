-- Server env may not have the shell's PROJECTS_HOME
local root = os.getenv("PROJECTS_HOME") or (os.getenv("HOME") .. "/Projects")
-- Actions always run on the home server, so other hosts' roots can't come from their env
local remote_roots = { dev = "~/projects" }

local TERMINAL = "com.superlogical.terminal"

local function session_name(project)
  return project:match("[^/]+$"):gsub("%.", "-")
end

local function sessions_by_label(sessions)
  local by_label = {}
  for _, s in ipairs(sessions) do
    by_label[s.label] = s.session_id
  end
  return by_label
end

local function local_host()
  return {
    call = rex.call,
    root = root,
    open = sessions_by_label((rex.call("session.list", {}) or {}).sessions or {}),
    projects = function()
      local r = rex.exec({ "find", root, "-mindepth", "2", "-maxdepth", "2", "-type", "d" })
      if not r or not r.ok then
        return nil
      end
      local projects = {}
      for path in r.stdout:gmatch("[^\n]+") do
        table.insert(projects, path:sub(#root + 2))
      end
      return projects
    end,
    is_dir = function(path)
      return rex.exec({ "test", "-d", path }).ok
    end,
  }
end

-- rex.exec only runs on the home server; list_dir reads the host's filesystem but needs
-- one of its terminals, in a session this connection is attached to
local function remote_lister(srv, sessions)
  for _, s in ipairs(sessions) do
    local scope = { session_id = s.session_id }
    if srv.call("session.attach", scope) then
      local function detach()
        srv.call("session.detach", scope)
      end
      local res = srv.call("session.list_blocks", scope) or {}
      for _, b in ipairs(res.blocks or {}) do
        if b.creator_name == TERMINAL then
          return function(path)
            return srv.block.call(TERMINAL, "list_dir", {
              session_id = s.session_id,
              block_id = b.block_id,
              path = path,
            }) or {}
          end, detach
        end
      end
      detach()
    end
  end
end

local function remote_host(label)
  local srv = rex.server(label)
  local sessions = (srv.call("session.list", {}) or {}).sessions or {}
  local list, close = remote_lister(srv, sessions)
  local base = list and list(remote_roots[label])
  if not base or base.status ~= "ok" then
    if close then
      close()
    end
    return nil
  end
  return {
    label = label,
    call = srv.call,
    close = close,
    root = base.path,
    open = sessions_by_label(sessions),
    projects = function()
      local projects = {}
      for _, group in ipairs(base.entries or {}) do
        for _, entry in ipairs(list(base.path .. "/" .. group.name).entries or {}) do
          table.insert(projects, group.name .. "/" .. entry.name)
        end
      end
      return projects
    end,
    is_dir = function(path)
      return list(path).status == "ok"
    end,
  }
end

local function hosts()
  local all = { local_host() }
  for _, label in ipairs(rex.servers()) do
    if remote_roots[label] then
      local host = remote_host(label)
      if host then
        table.insert(all, host)
      else
        rex.log("warn", "project_sessions: cannot list " .. label)
      end
    end
  end
  return all
end

local function project_items(all)
  local items = {}
  for _, host in ipairs(all) do
    local projects = host.projects()
    if not projects then
      return nil
    end
    table.sort(projects)
    for _, project in ipairs(projects) do
      local group, name = project:match("^(.-)/([^/]+)$")
      table.insert(items, {
        id = host.label and (host.label .. ":" .. project) or project,
        title = name,
        subtitle = host.label and (host.label .. " · " .. group) or group,
        icon = host.label and "server" or "folder",
        detail = host.open[session_name(project)] and "open" or nil,
      })
    end
  end
  return items
end

local function open_project(all, id)
  if not id then
    local items = project_items(all)
    if not items then
      rex.log("error", "project_sessions: cannot list " .. root)
      return
    end
    id = rex.ui.pick({ title = "Projects", placeholder = "Filter projects", items = items })
    if not id then
      return
    end
  end

  local label, project = id:match("^([^:/]+):(.+)$")
  project = project or id
  local host
  for _, h in ipairs(all) do
    if h.label == label then
      host = h
    end
  end
  if not host then
    rex.log("error", "project_sessions: no host " .. label)
    return
  end

  local name = session_name(project)
  local session_id = host.open[name]
  if not session_id then
    local path = host.root .. "/" .. project
    -- Convention for docker based projects
    local cwd = host.is_dir(path .. "/site") and path .. "/site" or path
    local res, err = host.call("session.create", {
      label = name,
      initial_windows = {
        { layout = rex.layout.block({ flavor = "com.superlogical.terminal.shell", options = { cwd = cwd } }) },
      },
    })
    if not res then
      rex.log("error", "project_sessions: " .. err)
      return
    end
    session_id = res.session_id
  end

  -- session.select only finds sessions on the home server; switch to others by hand
  if not host.label then
    rex.client.queue("session.select", { session_id = session_id })
  end
end

-- Switch to the project's session, creating it if needed
rex.action({
  name = "project_sessions",
  title = "Project Sessions",
  -- project: "group/name", or "host:group/name" for another host
  args = { project = "string?" },
  run = function(_, args)
    local all = hosts()
    open_project(all, args.project)
    for _, host in ipairs(all) do
      if host.close then
        host.close()
      end
    end
  end,
})
