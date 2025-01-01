-- In this file you define the User commands, i.t how the user will interact with your plugin.
local scratchpad = require'scratchpad'

local sub_cmd_keys = {
  top_left = true,
  top_right = true,
  lower_right = true,
  lower_left = true,
  center = true,
}
-- TODO: Change this to something smarter.
local function main_cmd(opts)
  -- vim.print(vim.inspect(opts))
  scratchpad.open_stickies(opts.fargs[1])
end

vim.api.nvim_create_user_command("Scratchpad", main_cmd, {
  nargs = "?",
  desc = "Open Scratchpad - scratch buffer, global note, or project note.",
  complete = function(arg_lead, _, _)
    return vim.iter(sub_cmd_keys):filter(function(sub_cmd)
      return sub_cmd:find(arg_lead) ~= nil
    end)
  end,
})

-- Expose <Plug> keymaps for the user to configure their own maps to call.
-- These might be unnecessary due to exposing the user command (Scratchpad).
vim.keymap.set({ "n", "v" }, "<Plug>(ScratchBuffer)", function()
  main_cmd({ args = "buffer"})
end, { noremap = true })

vim.keymap.set({ "n", "v" }, "<Plug>(ScratchGlobal)", function()
  main_cmd({ args = "global"})
end, { noremap = true })

vim.keymap.set({ "n", "v" }, "<Plug>(ScratchProject)", function()
  main_cmd({ args = "project"})
end, { noremap = true })

vim.keymap.set({ "n", "v" }, "<Plug>(ScratchSticky)", function()
  main_cmd({ args = ""})
end, { noremap = true })

-- An example keymap using one of the above:
-- vim.keymap.set("n", "<Leader>Sg", "<Plug>(ScratchGlobal)")

-- RESOURCES:
--  - :help lua-guide-commands-create
--  - https://github.com/nvim-neorocks/nvim-best-practices?tab=readme-ov-file#speaking_head-user-commands
