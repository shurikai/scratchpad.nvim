--- This package passes calls through to the appropriate submodule. This allows for the submodules
--- to be lazy loaded, since they will not be required until the user calls one of the functions here,
--- causing load of the next submodule.
---@class Stickies
local Stickies = {}

-- Pass the open_stickies function through to the command module.
---@param location stickies.WindowPosition
Stickies.open_stickies = function(location)
  require("scratchpad.command").open_stickies(location)
end

return Stickies
