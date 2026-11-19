-- Server env may not have the shell's PROJECTS_HOME
local root = os.getenv("PROJECTS_HOME") or (os.getenv("HOME") .. "/Projects")

local function session_name(project)
  return project:match("[^/]+$"):gsub("%.", "-")
end

local function sessions_by_label()
  local res = rex.call("session.list", {}) or {}
  local by_label = {}
  for _, s in ipairs(res.sessions or {}) do
    by_label[s.label] = s.session_id
  end
  return by_label
end

local function project_items(open)
  local r = rex.exec({ "find", root, "-mindepth", "2", "-maxdepth", "2", "-type", "d" })
  if not r or not r.ok then
    return nil
  end
  local projects = {}
  for path in r.stdout:gmatch("[^\n]+") do
    table.insert(projects, path:sub(#root + 2))
  end
  table.sort(projects)

  local items = {}
  for _, project in ipairs(projects) do
    local group, name = project:match("^(.-)/([^/]+)$")
    table.insert(items, {
      id = project,
      title = name,
      subtitle = group,
      icon = "folder",
      detail = open[session_name(project)] and "open" or nil,
    })
  end
  return items
end

-- Switch to the project's session, creating it if needed
rex.action({
  name = "project_sessions",
  title = "Project Sessions",
  args = { project = "string?" },
  run = function(_, args)
    local open = sessions_by_label()
    local project = args.project
    if not project then
      local items = project_items(open)
      if not items then
        rex.log("error", "project_sessions: cannot list " .. root)
        return
      end
      project = rex.ui.pick({ title = "Projects", placeholder = "Filter projects", items = items })
      if not project then
        return
      end
    end

    local name = session_name(project)
    local session_id = open[name]
    if not session_id then
      local path = root .. "/" .. project
      -- Convention for docker based projects
      local cwd = rex.exec({ "test", "-d", path .. "/site" }).ok and path .. "/site" or path
      local res, err = rex.call("session.create", {
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

    rex.client.queue("session.select", { session_id = session_id })
  end,
})
