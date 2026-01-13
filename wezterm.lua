local wezterm = require 'wezterm'
local act = wezterm.action

local config = wezterm.config_builder()

config.leader = {
  key = 'k',
  mods = 'ALT',
  timeout_milliseconds = 1000,
}

config.font = wezterm.font "Cica"
config.font_size = 16
config.default_prog = {
  'C:\\Program Files\\Git\\bin\\bash.exe',
  '-l',
  '-i',
}

local function pane_cwd_as_path(pane)
  local url = pane:get_current_working_dir()
  if not url then
    return nil
  end

  -- get_current_working_dir() of new version returns url, but old version returns string
  if type(url) == 'string' then
    url = wezterm.url.parse(url)
  end

  if not url or url.scheme ~= 'file' or not url.file_path then
    return nil
  end

  local path = url.file_path
  if wezterm.target_triple:find('windows') then
    path = path:gsub('^/([A-Za-z]:)', '%1')
  end
  return path
end

local function win_path(path)
  if not path or path == '' then return nil end
  return path:gsub('/', '\\')
end

local function spawn_tab_in_current_cwd(window, pane)
  local cwd_path = win_path(pane_cwd_as_path(pane))

  window:perform_action(
    act.SpawnCommandInNewTab {
      domain = 'CurrentPaneDomain',
      cwd = cwd_path,
    },
    pane
    )
end

config.key_tables = {
  resize_pane = {
    { key = "h", mods = "SHIFT", action = act.AdjustPaneSize({ "Left", 3 }) },
    { key = "j", mods = "SHIFT", action = act.AdjustPaneSize({ "Down", 3 }) },
    { key = "k", mods = "SHIFT", action = act.AdjustPaneSize({ "Up", 3 }) },
    { key = "l", mods = "SHIFT", action = act.AdjustPaneSize({ "Right", 3 }) },
    { key = "Escape", action = act.PopKeyTable },
  },
}

config.keys = {
  -- window
  { key = 'x', mods = 'ALT', action = wezterm.action_callback(function(window, pane) window:maximize() end) },
  { key = 'r', mods = 'ALT', action = wezterm.action_callback(function(window, pane) window:restore() end) },

  -- split panes
  {
    key = '|',
    mods = 'LEADER|SHIFT',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '\\',
    mods = 'LEADER',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '-',
    mods = 'LEADER',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },

  -- pane navigation
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },

  -- pane resize
  { key = 'h', mods = 'LEADER|SHIFT',
    action = act.Multiple({
        act.AdjustPaneSize({ "Left", 3 }),
        act.ActivateKeyTable({ name = 'resize_pane', one_shot = false, until_unknown = true }),
      }),
  },
  { key = 'j', mods = 'LEADER|SHIFT',
    action = act.Multiple({
        act.AdjustPaneSize({ "Down", 3 }),
        act.ActivateKeyTable({ name = 'resize_pane', one_shot = false, until_unknown = true }),
      }),
  },
  { key = 'k', mods = 'LEADER|SHIFT',
    action = act.Multiple({
        act.AdjustPaneSize({ "Up", 3 }),
        act.ActivateKeyTable({ name = 'resize_pane', one_shot = false, until_unknown = true }),
      }),
  },
  { key = 'l', mods = 'LEADER|SHIFT',
    action = act.Multiple({
        act.AdjustPaneSize({ "Right", 3 }),
        act.ActivateKeyTable({ name = 'resize_pane', one_shot = false, until_unknown = true }),
      }),
  },

  -- new tab
  {
    key = 'c',
    mods = 'LEADER',
    --action = act.SpawnCommandInNewTab { cwd = wezterm.home_dir },
    action = wezterm.action_callback(spawn_tab_in_current_cwd),
  },

  -- tab navigation
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },

  -- numeric tab navigation
  { key = '1', mods = 'LEADER', action = act.ActivateTab(0) },
  { key = '2', mods = 'LEADER', action = act.ActivateTab(1) },
  { key = '3', mods = 'LEADER', action = act.ActivateTab(2) },
  { key = '4', mods = 'LEADER', action = act.ActivateTab(3) },
  { key = '5', mods = 'LEADER', action = act.ActivateTab(4) },
  { key = '6', mods = 'LEADER', action = act.ActivateTab(5) },
  { key = '7', mods = 'LEADER', action = act.ActivateTab(6) },
  { key = '8', mods = 'LEADER', action = act.ActivateTab(7) },
  { key = '9', mods = 'LEADER', action = act.ActivateTab(8) },

  -- rename tab
  { key = ',',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = 'rename tab',
      action = wezterm.action_callback(function(window, pane, line)
        if line ~= nil then
          window:active_tab():set_title(line)
        end
      end),
    },
  },

  -- paste
  { key = 'v', mods = 'CTRL|ALT', action = act.PasteFrom 'Clipboard' },

  -- kill
  { key = 'w', mods = 'CTRL|SHIFT', action = act.CloseCurrentPane { confirm = true } },
}

config.color_schemes = config.color_schemes or {}
config.color_schemes['my-monokai'] = {
  foreground = '#f1ebeb',
  background = '#272822',

  cursor_bg = '#f1ebeb',
  cursor_fg = '#272822',
  cursor_border = '#f1ebeb',

  selection_bg = '#49483e',
  selection_fg = '#f1ebeb',

  ansi = {
    '#48483e', -- black
    '#dc2566', -- red
    '#8fc029', -- green
    '#d4c96e', -- yellow
    '#55bcce', -- blue
    '#9358fe', -- magenta
    '#56b7a5', -- cyan
    '#acada1', -- white
  },
  brights = {
    '#76715e', -- bright black
    '#fa2772', -- bright red
    '#a7e22e', -- bright green
    '#e7db75', -- bright yellow
    '#66d9ee', -- bright blue
    '#ae82ff', -- bright magenta
    '#66efd5', -- bright cyan
    '#cfd0c2', -- bright white
  },
}
config.color_scheme = 'my-monokai'

-- tab
config.colors = config.colors or {}
config.colors.tab_bar = {
  background = '#272822',

  active_tab = {
    bg_color = '#272822',
    fg_color = '#f1ebeb',
    intensity = 'Bold',
  },
  inactive_tab = {
    bg_color = '#3a3a36',
    fg_color = '#acada1',
  },
  inactive_tab_hover = {
    bg_color = '#32322c',
    fg_color = '#f1ebeb',
  },
  new_tab = {
    bg_color = '#3a3a36',
    fg_color = '#acada1',
  },
  new_tab_hover = {
    bg_color = '#32322c',
    fg_color = '#f1ebeb',
  },
}
config.use_fancy_tab_bar = false

return config
