local config = require "scratchpad.config"
local notes = require "scratchpad.note"
local win = require "scratchpad.window"

local M = {}

local window = {}
local note = {}

---Configure the Scratchpad plugin - this function accepts, validates, and stores
---the configuration options for the plugin. If the configuration is invalid, the
---information will be logged and the plugin will be unavailable for use.
---@param opts UserOptions: plugin options
M.configure = function(opts)
  require("scratchpad.config").setup(opts)
end

---Open the sticky note window in the requested location and size,
---@param configuration? stickies.WindowConfig
function M.open_stickies(configuration)
  -- note = notes:new(config.get_note_config())
  -- note:open()

  local cfg = config.get_window_config(configuration or "SE")
  window = win:new(cfg)

  -- window:open(note:get_filename())
  window:open(notes.get_last_note())
end

function M.hide_stickies()
  window:close(true)
end

vim.keymap.set({ "n", "v" }, "<Leader>q", function()
  M.open_stickies({ position = "SE", height = 0.5, width = 0.5 })
end, { noremap = true })
vim.keymap.set({ "n", "v" }, "<Leader>z", function()
  M.hide_stickies()
end, { noremap = true })

return M
