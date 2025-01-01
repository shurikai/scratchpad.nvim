---@meta
--- This is a simple "definition file" (https://luals.github.io/wiki/definition-files/),
--- the @meta tag at the top is its hallmark.

-- lua/scratchpad/config.lua -----------------------------------------------------

---The overall configurat of a Window object. The values here are a subset of those
---used by the nvim_open_win function.
---@class stickies.WindowConfig
---@field position stickies.WindowPosition Where to put the window.
---@field width? number Width of the window. This replaces the default. Can be absolute or %.
---@field height? number Height of the window. This replaces the default. Can be absolute or %.

---The relative position of a window - The amount of offset and the size of the
---window can be controlled with other values. This simply sticks the window to a
---position in the parent.
--- ╔══════════════════════╗
--- ║ [NW]            [NE] ║
--- ║                      ║
--- ║                      ║
--- ║       [CENTER]       ║
--- ║                      ║
--- ║                      ║
--- ║ [SW]            [SE] ║
--- ╚══════════════════════╝
---@alias stickies.WindowPosition "NW" | "NE" | "SE" | "SW" | "CENTER"

---@class stickies.NoteConfig The configuration of a single sticky note.
---@field root_path string The filesystem root where the note can be read or written.
---@field filename string The filename used for the sticky note.
---@field body? string[] The body text of the given note, as individual lines.

-- lua/scratchpad/config.lua -----------------------------------------------------

---@class stickies.UserOptions
---@field window stickies.WindowConfig The configuration for the sticky window.


---@class ScratchConfig
---@field scratchpad Window.Config
---@field globalwin Window.Config
---@field localwin Window.Config
---@field notes_dir? string: Path where notes are stored.
---

---@class StickyConfig
---@field height number The height of the note - a % is realtive, int is absolute
---@field width number The width of the note - a % is relativve, int is absolute
---@field col number The number of columns to offset the edge of the note
---@field row number The number of rows to offset the edge of the note
---@field anchor "NW"|"NE"|"SE"|"SW" The corner of the window to use as anchor point

---The configuration of a given scratch window - derived from :h nvim_open_win arguments.
---@class Window.Config
---@field relative? "editor"|"win"|"cursor"|"mouse"
---@field win? integer The window to split or show relative to. Will get current if left nil.
---@field anchor? "NW"|"NE"|"SE"|"SW" The corner of the window to use as anchor point, for float windows.
---@field width? number Width of the window. Use <1 for relative width. 0 means full width. (default: 0.9)
---@field height? number Height of the window. Use <1 for relative height. 0 means full height. (default: 0.9)
---@field col? number The Column to pin the anchor corner to in the parent window.
---@field row? number The Row to pin the anchor corner to in the parent window.
---@field zindex? number The relative Z index of the window. (default: 201)
---@field style? string Defaults to '', can be 'minimal'
---@field border? 'none'|'rounded'|'single'|'double'|'solid'|'shadow' The window boerder style.
---@field title? string The title of the new window.
---@field title_pos 'left'|'center'|'right' Where to anchor the title text.
---@field footer? string The string to place in the window footer.
---@field footer_pos 'left'|'center'|'right' Where to anchor the footer text.
---@field hide? boolean Show or hide the window immediately (default: false)
---@field vertical? boolean Split vertically if true, horizontally otherwise.
---@field split? 'left'|'right'|'above'|'below' Direction to split the window.

---@class File.Config
---@field buf? number If set, use this buffer instead of creating a new one
---@field file? string If set, use this file instead of creating a new buffer
---@field enter? boolean Enter the window after opening (default: false)
---@field backdrop? number|false Opacity of the backdrop (default: 60)
---@field wo? vim.wo window options
---@field bo? vim.bo buffer options
---@field ft? string filetype to use for treesitter/syntax highlighting. Won't override existing filetype
--[[
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

--]]

-- These are from the base.nvim template and can be reused or replaced.
---@class Config
---@field defaults Options: default options
---@field options Options: user options
---@field setup function: setup the plugin

---@class UserOptions
---@field notes_dir? string: Path where notes are stored.

---@class DefaultOptions
---@field notes_dir string|string[]: Path where notes are stored.

---@class Options
---@field notes_dir? string: Path where notes are stored.
---

--[[
Configuration Construction:
 - Scratchpad
   - init function
   - ScratchConfig
      - Scratchpad - SWinCfg
        - { width, height }
        - "float" | "split" | "vsplit"
        - border style - "none" | "single" | "double" | "rounded" | "solid" | "shadow"
      - Global Win - SWinCfg
      - Local win  - SWinCfg
      - notes_dir  - string (path)
--]]
