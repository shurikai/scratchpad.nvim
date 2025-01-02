--- This package passes calls through to the appropriate submodule. This allows for the submodules
--- to be lazy loaded, since they will not be required until the user calls one of the functions here,
--- causing load of the next submodule.
---@class Stickies
local Stickies = {}

---@alias stickies.Anchor "NW" | "NE" | "SE" | "SW"

---@class stickies.UserConfig
---@field anchor? stickies.Anchor The corner of the window to open the sticky window in.
---@field height? number The window height, either a character count or a percentage.
---@field width? number The window width, either a character count or a percentage.

---@type stickies.UserConfig | nil
vim.g.stickies = vim.g.stickies

-- Pass the open_stickies function through to the command module.
---@param location? stickies.Anchor
Stickies.open_stickies = function(location)
  require("stickies.command").open_stickies(location)
end

-- Pass the close_stickies function through to the command module.
Stickies.close_stickies = function()
  require("stickies.command").close_stickies()
end

return Stickies
