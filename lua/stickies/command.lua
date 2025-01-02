local config = require "stickies.config"
local notes = require "stickies.note"
local win = require "stickies.window"

local M = {}

local window = {}

---Configure the stickies plugin - this function accepts, validates, and stores
---the configuration options for the plugin. If the configuration is invalid, the
---information will be logged and the plugin will be unavailable for use.
---@param opts UserOptions: plugin options
M.configure = function(opts)
  require("stickies.config").setup(opts)
end

---Open the sticky note window in the requested location and size,
---@param anchor? stickies.Anchor
function M.open_stickies(anchor)
  local cfg = config.get_window_config(anchor or "SE")
  window = win:new(cfg)

  window:open(notes.get_last_note())
end

function M.close_stickies()
  window:close(true)
end

-- vim.keymap.set({ "n", "v" }, "<Leader>q", function()
--   M.open_stickies({ position = "SE", height = 0.5, width = 0.5 })
-- end, { noremap = true })
-- vim.keymap.set({ "n", "v" }, "<Leader>z", function()
--   M.hide_stickies()
-- end, { noremap = true })

return M
