local cfg = require 'scratchpad.config'

---@class stickies.Window
---@field config? vim.api.keyset.win_config
---@field buf number|nil The buffer to be displayed in this window.
---@field win number|nil The window handle that is to be controlled by this instance.
local Window = {}

---@type vim.api.keyset.win_config
Window.config = cfg.get_window_config()
Window.buf = nil
Window.win = nil

-- For now, accept a table (potentially non-empty) to make into a Window instance.
-- Possible future change would be to accept an options table and set those options
-- on a new table. This would at least guarantee a new object and not something that
-- could be operated on elsewhere (with side effects).
function Window:new(obj)
  self.__index = self

  local object = setmetatable({}, self)
  local config = vim.deepcopy(obj or {})
  object.config = vim.tbl_deep_extend('force', object.config, config)
  return object
end

---Open a window with the given configuration.
---@param filename string The file to edit in the new window.
---@param override? vim.api.keyset.win_config Override values for the window configuration.
function Window:open(filename, override)
  -- make sure that we don't open an extra window if it is already open.
  if self.win and vim.api.nvim_win_is_valid(self.win) then
    return
  end

  -- Merge the override configuration with the current configuration.
  if override ~= nil then
    self.config = vim.tbl_deep_extend('force', self.config, override)
  end

  -- Check the buffer and create one if it isn't valid.
  if not self.buf or not vim.api.nvim_buf_is_valid(self.buf) then
    self.buf = vim.api.nvim_create_buf(true, false)
  end

  print("the window config: " .. vim.inspect(self.config))
  self.win = vim.api.nvim_open_win(self.buf, true, self.config)
  vim.api.nvim_set_current_buf(self.buf)

  vim.cmd("edit " .. filename)
  vim.bo[self.buf].filetype = "markdown"
end

---@param del boolean If del is true, delete the associated buffer.
function Window:close(del)
  local win = self.win
  local buf = self.buf

  vim.schedule(function()
    if win and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end

    if del and buf and vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
      self.buf = nil
    end
  end)
end

--[[ Test code. ]]--

-- local buffer = vim.fn.bufadd('./.editorconfig')
-- vim.api.nvim_set_option_value('bufhidden', 'hide', { buf = buffer })
-- -- print('buffer created: ' .. buffer)
--
-- local window = Window:new({})
-- window:open(cfg.window_defaults['lower_right'], buffer)
-- vim.defer_fn(function()
--   window:close(true)
-- end, 9000)

return Window
