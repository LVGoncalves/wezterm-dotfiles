local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

config:set_strict_mode(true)

config.font = wezterm.font_with_fallback {
  'JetBrains Mono',
  'Ubuntu Mono',
  'DejaVu Sans Mono',
}
config.font_size = 11.5
config.line_height = 1.1

config.color_scheme = 'Catppuccin Mocha'
config.window_background_opacity = 0.96
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.window_padding = { left = 12, right = 12, top = 10, bottom = 8 }
config.initial_cols = 120
config.initial_rows = 32
config.inactive_pane_hsb = { saturation = 0.85, brightness = 0.65 }
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 500
config.audible_bell = 'Disabled'
config.scrollback_lines = 10000

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 32
config.colors = {
  tab_bar = {
    background = '#181825',
    active_tab = { bg_color = '#cba6f7', fg_color = '#1e1e2e', intensity = 'Bold' },
    inactive_tab = { bg_color = '#313244', fg_color = '#a6adc8' },
    inactive_tab_hover = { bg_color = '#45475a', fg_color = '#cdd6f4' },
    new_tab = { bg_color = '#181825', fg_color = '#a6adc8' },
    new_tab_hover = { bg_color = '#45475a', fg_color = '#cdd6f4' },
  },
}

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1500 }
config.keys = {
  { key = 'a', mods = 'LEADER|CTRL', action = act.SendKey { key = 'a', mods = 'CTRL' } },
  { key = 't', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
  { key = 'v', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 's', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
  { key = 'p', mods = 'LEADER', action = act.PaneSelect },
  { key = 'w', mods = 'LEADER', action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' } },
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 'b', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  { key = 'LeftArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Left' },
  { key = 'DownArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Down' },
  { key = 'UpArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Up' },
  { key = 'RightArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Right' },
  { key = 'LeftArrow', mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Left', 3 } },
  { key = 'DownArrow', mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Down', 3 } },
  { key = 'UpArrow', mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Up', 3 } },
  { key = 'RightArrow', mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Right', 3 } },
  { key = 'f', mods = 'CTRL|SHIFT', action = act.Search 'CurrentSelectionOrEmptyString' },
  { key = 'Space', mods = 'CTRL|SHIFT', action = act.QuickSelect },
  { key = 'p', mods = 'CTRL|SHIFT', action = act.ActivateCommandPalette },
  { key = 'Enter', mods = 'ALT', action = act.ToggleFullScreen },
}

return config
