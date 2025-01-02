-- In this file you define the User commands, i.t how the user will interact with your plugin.
local stickies = require'stickies'

-- Expose <Plug> keymaps for the user to configure their own maps to call.
-- These might be unnecessary due to exposing the user command (stickies).
vim.keymap.set({ "n", "v" }, "<Plug>(StickiesShow)", function()
  stickies.open_stickies()
end, { noremap = true })

vim.keymap.set({ "n", "v" }, "<Plug>(StickiesHide)", function()
  stickies.close_stickies()
end, { noremap = true })

-- vim.keymap.set({ "n", "v" }, "<Plug>(ScratchProject)", function()
--   main_cmd({ args = "project"})
-- end, { noremap = true })
--
-- vim.keymap.set({ "n", "v" }, "<Plug>(ScratchSticky)", function()
--   main_cmd({ args = ""})
-- end, { noremap = true })

-- An example keymap using one of the above:
-- vim.keymap.set("n", "<Leader>Sg", "<Plug>(ScratchGlobal)")

-- RESOURCES:
--  - :help lua-guide-commands-create
--  - https://github.com/nvim-neorocks/nvim-best-practices?tab=readme-ov-file#speaking_head-user-commands
