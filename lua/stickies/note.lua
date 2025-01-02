local cfg = require 'stickies.config'

local Note = {}

local config = cfg.note_defaults.sticky
local base_filename = "note_"
local notes = nil
Note.default_config = cfg.note_defaults.sticky
Note.buf = nil

local check_cache_dir = function()
  local root_path = vim.fn.stdpath('data')
  if type(root_path) == 'table' then
    root_path = root_path[1]
  end

  config.root_path = vim.fn.fnamemodify(root_path, ":p")
end

---Get the list of note files in a given path.
---@return string[] The list of files with complete paths.
local get_note_files = function()
  local files = {}
  if check_cache_dir() then
    ---@diagnostic disable-next-line: param-type-mismatch
    for name, type in vim.fs.dir(config.root_path) do
        if type == "file" then
            table.insert(files, name)
        end
    end
  end

  return files
end

Note.get_first_note = function()
end

Note.get_last_note = function()
  if notes == nil then
    check_cache_dir()
    notes = get_note_files()
  end

  if #notes == 0 then
    notes[1] = config.root_path .. base_filename .. (#notes + 1) .. ".md"
  end

  return notes[#notes]
end

function Note:new(obj)
  self.__index = self

  local object = setmetatable({}, self)
  object.options = vim.deepcopy(obj or Note.default_config)

  return object
end

function Note:open()
  -- self.buf = vim.fn.bufadd(self.options.root_path .. '/' .. self.options.filename)
  -- vim.api.nvim_set_option_value('bufhidden', 'hide', { buf = self.buf })
  local file_path = self.options.root_path .. self.options.filename
  file_path = vim.fn.fnamemodify(file_path, ":p")
  local inputfile = io.open(file_path, "r+")
  self.body = self.body or {}

  print('file path: ' .. file_path)
  print(vim.inspect(inputfile))

  if not inputfile then
    return
  end

  for line in inputfile:lines() do
    table.insert(self.contents, line)
  end

  inputfile:close()
end

function Note:save()
end

--[[ Test code. ]]

-- local note = Note:new({ root_path = '~/', filename = 'sticky.text' })
-- note:open()
--
-- print(vim.inspect(note))

return Note
