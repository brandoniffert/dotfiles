local WIDTH = 0.33

-- Edge leaf of a subtree: the block touching the border on the given side
local function edge_block(node, side)
  while node.split do
    node = node.split.direction == "horizontal" and node.split[side] or node.split.before
  end
  return node.block_id
end

-- Deepest left/right split on the path to the rightmost pane
local function rightmost_split(node)
  local found
  while node.split do
    if node.split.direction == "horizontal" then
      found = node
      node = node.split.after
    else
      node = node.split.before
    end
  end
  return found
end

-- tmux `resize-pane -t Right -x 33%`: rightmost pane gets a third of the window
rex.action({
  name = "right_pane_third",
  title = "Right Pane to One Third",
  run = function()
    local view, err = rex.session.view({})
    if not view then
      rex.log("error", "right_pane_third: " .. err)
      return
    end
    for _, win in ipairs(view.windows) do
      if win.window_id == view.active_window_id then
        for _, layer in ipairs(win.layers) do
          local node = layer.kind == "tiled" and rightmost_split(layer.layout)
          -- rect is a fraction of the window, so convert the target width to this split's share
          local width = node and node.rect[3]
          if width and width > WIDTH then
            local _, rerr = rex.session.resize_pane({
              direction = "horizontal",
              before_block_id = edge_block(node.split.before, "after"),
              after_block_id = edge_block(node.split.after, "before"),
              ratio = 1 - WIDTH / width,
            })
            if rerr then
              rex.log("error", "right_pane_third: " .. rerr)
            end
          end
        end
      end
    end
  end,
})
