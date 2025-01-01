---@class Config
local Config = {}

local DEFAULT_WIN_PERCENT = 0.8
local ui = vim.api.nvim_list_uis()[1] -- Used for calculating location and dimensions of window

--[[
Sample configuration:
{
  global_path = vim.env.getwhatevertogetcachedir(),
  global_win = {
    type = 'float',
    size = { x, y },
    pos = 'SE',
    title = 'my awesome note',
    border = 'rounded',
  },
  project_win = {
    ...,
  },
  scratch_win = {
   ...,
  }
}
--]]

---@class StickyConfig[]
Config.sticky_configs = {
  ["NW"] = function()
    return {
      col = 1,
      row = 1,
      anchor = "NW",
    }
  end,
  ["NE"] = function()
    return {
      col = vim.o.columns - 1,
      row = 1,
      anchor = "NE",
    }
  end,
  ["SW"] = function()
    return {
      col = 1,
      row = vim.o.lines - 1,
      anchor = "SW",
    }
  end,
  ["SE"] = function()
    return {
      col = vim.o.columns - 1,
      row = vim.o.lines - 1,
      anchor = "SE",
    }
  end,
}

---@class DefaultOptions
Config.defaults = {
  global_path = vim.fn.stdpath('data') .. '/scratchpad',
  global_note = "global_note.md",
  local_path = ".",
  local_note = "scratchpad_notes.md",
  sticky_note = "stickies.md",
  global_win = {},
  project_win = {},
  scratch_win = {},
  sticky_win = {},
}

--- Check that the environment is available and configured: can read and write from
--- global data directory, the project directory is configured, etc.
local _check_environment = function()
  -- Check the global data directory as configured.
  --
  return true -- temporary short-circuit
end

local _configure_scratchpad = function()
  if type(vim.g._scratchpad_init) == 'boolean' then
    if vim.g._scratchpad_init then
      -- already initialized
      return
    end
  end

  -- The module hasn't been initialized yet.
  local user_config = vim.g.scratchpad.user_config or {}
  print(user_config)
  print(Config.defaults)
  vim.g.scratchpad.config = vim.tbl_deep_extend('force', Config.defaults, user_config)

  if _check_environment() then
    vim.g._scratchpad_init = true
  else
    -- Environment failed validation, so mark this as module as failed.
    vim.g._scratchpad_init = false
  end
end

local get_center_pos = function(dimension)
  local dim = math.floor((ui[dimension] * DEFAULT_WIN_PERCENT) + 0.5)
  return (ui[dimension] - dim) / 2
end

---@type vim.api.keyset.win_config
local default_window_config = {
  relative = 'editor',
  width = math.floor((ui.width * DEFAULT_WIN_PERCENT) + 0.5),
  height = math.floor((ui.height * DEFAULT_WIN_PERCENT) + 0.5),
  zindex = 201, -- Just above message scrollback, but below cmdline completion popup.
  border = 'rounded',
  title = 'Scratchpad',
  title_pos = 'left',
  footer = '... scratchpad ...',
  footer_pos = 'right',
}

Config.get_window_configuration = function()
  -- Get window config, using anchor, width, and height from user settings or defaults,
  -- then calculating the other values from local values.
  local config = vim.tbl_deep_extend('force', {}, default_window_config)

  return config
end

---@type vim.api.keyset.win_config[]
Config.window_defaults = {}

Config.window_defaults['testwin'] = {
}

Config.window_defaults['centered'] = {
  relative = 'editor',
  anchor = 'NW',
  width = math.floor((ui.width * DEFAULT_WIN_PERCENT) + 0.5),
  height = math.floor((ui.height * DEFAULT_WIN_PERCENT) + 0.5),
  col = get_center_pos('width'),
  row = get_center_pos('height'),
  zindex = 201, -- Just above message scrollback, but below cmdline completion popup.
  border = 'rounded',
  title = 'Scratchpad',
  title_pos = 'left',
  footer = '... scratchpad ...',
  footer_pos = 'right',
}

Config.window_defaults['lower_right'] = {
  relative = 'editor',
  anchor = 'SE',
  width = math.floor((ui.width * 0.25) + 0.5),
  height = math.floor((ui.height * 0.4) + 0.5),
  col = ui.width - 1,
  row = ui.height - 1,
  zindex = 201, -- Just above message scrollback, but below cmdline completion popup.
  border = 'rounded',
  title = 'Scratchpad',
  title_pos = 'left',
  footer = '... scratchpad ...',
  footer_pos = 'right',
}

---@type stickies.NoteConfig[]
Config.note_defaults = {}
Config.note_defaults['global'] = {
  root_path = vim.fn.stdpath('data'),
  filename = 'scratchpad_global.md',
}
Config.note_defaults['project'] = {}
Config.note_defaults['scratch'] = {}
Config.note_defaults['sticky'] = {
  root_path = vim.fn.stdpath('data'),
  filename = 'stickynote.md',
}

---Extend the defaults options table with the user options
---@param opts UserOptions: plugin options
Config.initialize = function(opts)
  Config.options = vim.tbl_deep_extend("force", {}, Config.defaults, opts or {})
end

-- Initialize and configure the module when first required.
_configure_scratchpad()

Config.get_global_note_path = function()
  local file_path = vim.g.scratchpad.config.global_dir or './'
  return file_path
end

Config.get_sticky_filename = function()
  local filename = vim.g.scratchpad.config.sticky_note or 'stickynote.md'
  return filename
end

Config.is_initialized = function()
  return vim.g._scratchpad_init
end

Config.get_note_config = function()
  return Config.note_defaults.sticky
end

---Calculate window size and location, based on current neovim geometry and user configuration.
---@param config? string|stickies.WindowConfig At a minimum, the corner of the window to stick the note to.
---@return vim.api.keyset.win_config
Config.get_window_config = function(config)
  local cfg = nil

  if config == nil then
    cfg = Config.sticky_configs["SE"]()
  else

    print('finding window config: ' .. vim.inspect(config))

    if type(config) == 'string' then
      if vim.is_callable(Config.sticky_configs[config]) then
        cfg = Config.sticky_configs[config]()
      else
        cfg = Config.sticky_configs["SE"]() -- Pick a default. I like bottom-right corner.
      end
    else
      if type(config) == 'table' then
        if config.position ~= nil then
          cfg = Config.sticky_configs[config.position]()
          cfg.height = config.height or cfg.height
          cfg.width = config.width or cfg.width
        end
      end
    end
  end

  local width = vim.o.columns
  local height = vim.o.lines
  local window_cfg = default_window_config
  print("Starting from default config: " .. vim.inspect(window_cfg))
  print("  Adding this: " .. vim.inspect(cfg))
  window_cfg = vim.tbl_deep_extend('force', window_cfg, cfg)
  if type(window_cfg.width) == 'number' and window_cfg.width % 1 ~= 0 then
    window_cfg.width = math.floor((width * window_cfg.width) + 0.5)
  end
  if type(window_cfg.height) == 'number' and window_cfg.height % 1 ~= 0 then
    window_cfg.height = math.floor((height * window_cfg.height) + 0.5)
  end
  print("Working with complete config: " .. vim.inspect(window_cfg))

  return window_cfg
end

return Config
