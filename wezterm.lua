-- ~/.config/wezterm/wezterm.lua  (Windows: %USERPROFILE%\.config\wezterm\wezterm.lua)
-- Catppuccin Mocha + transparency/blur, tmux-style leader keys, status bar.

local wezterm = require('wezterm')
local act = wezterm.action
local config = wezterm.config_builder()

local triple = wezterm.target_triple
local is_windows = triple:find('windows') ~= nil
local is_mac = triple:find('darwin') ~= nil

-----------------------------------------------------------------------
-- Look & feel
-----------------------------------------------------------------------
config.color_scheme = 'Catppuccin Mocha'

config.font = wezterm.font_with_fallback({
  { family = 'JetBrainsMono Nerd Font', weight = 'Medium' },
  'Symbols Nerd Font Mono',
  'Noto Color Emoji',
})
config.font_size = is_mac and 14 or 11.5
config.line_height = 1.1

-- Transparency + blur (each OS uses its own mechanism)
-- Lower = more see-through (0.0 to 1.0). LEADER o toggles fully opaque.
config.window_background_opacity = 0.75
config.text_background_opacity = 1.0
if is_mac then
  config.macos_window_background_blur = 30
elseif is_windows then
  -- Plain see-through glass. The 'Acrylic' blur makes the window solid grey
  -- on many PCs, so it stays off. OpenGL is the renderer that handles
  -- transparency most reliably on Windows.
  config.win32_system_backdrop = 'Disable'
  config.front_end = 'OpenGL'
else
  -- KDE Plasma only; pcall because the 20240203 stable release rejects the field.
  pcall(function() config.kde_window_background_blur = true end)
end

-- No separate title bar: minimize / maximize / close sit in the tab bar
-- (at the bottom). Drag the empty part of the tab bar to move the window.
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.integrated_title_button_style = 'Windows'
config.integrated_title_button_alignment = 'Right'
config.window_padding = { left = 12, right = 12, top = 10, bottom = 6 }
config.initial_cols = 130
config.initial_rows = 34

-- Dim panes that don't have focus
config.inactive_pane_hsb = { saturation = 0.8, brightness = 0.65 }

-- Tab bar
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 32
config.show_new_tab_button_in_tab_bar = false

-- Cursor
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 600
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'

-- Behaviour
config.scrollback_lines = 20000
config.audible_bell = 'Disabled'
config.max_fps = 120
config.window_close_confirmation = 'NeverPrompt'
config.adjust_window_size_when_changing_font_size = false

-- Default shell: PowerShell 7 on Windows. LEADER + Space opens a menu
-- with the other shells.
if is_windows then
  -- Fall back to Windows PowerShell 5 on machines without PowerShell 7.
  -- glob, not io.open: the Microsoft Store's pwsh.exe alias can't be opened.
  local has_pwsh = #wezterm.glob('C:/Program Files/PowerShell/7/pwsh.exe') > 0
    or #wezterm.glob((os.getenv('LOCALAPPDATA') or '') .. '/Microsoft/WindowsApps/pwsh.exe') > 0
  config.default_prog = { has_pwsh and 'pwsh.exe' or 'powershell.exe', '-NoLogo' }
  config.launch_menu = {
    { label = 'PowerShell 7', args = { 'pwsh.exe', '-NoLogo' } },
    { label = 'Windows PowerShell 5', args = { 'powershell.exe', '-NoLogo' } },
    { label = 'Command Prompt', args = { 'cmd.exe' } },
    { label = 'WSL', args = { 'wsl.exe', '~' } },
  }
end

-----------------------------------------------------------------------
-- Toggle transparency on/off (LEADER o)
-----------------------------------------------------------------------
wezterm.on('toggle-opacity', function(window, _)
  local overrides = window:get_config_overrides() or {}
  if overrides.window_background_opacity == 1.0 then
    overrides.window_background_opacity = nil
  else
    overrides.window_background_opacity = 1.0
  end
  window:set_config_overrides(overrides)
end)

-- LEADER + Up/Down: make the window more / less see-through
local base_opacity = config.window_background_opacity
local function adjust_opacity(delta)
  return wezterm.action_callback(function(window, _)
    local overrides = window:get_config_overrides() or {}
    local current = overrides.window_background_opacity or base_opacity
    overrides.window_background_opacity = math.max(0.1, math.min(1.0, current + delta))
    window:set_config_overrides(overrides)
  end)
end

-----------------------------------------------------------------------
-- Right status: leader indicator, workspace, clock
-----------------------------------------------------------------------
wezterm.on('update-status', function(window, _)
  local leader = ''
  if window:leader_is_active() then
    leader = ' \u{f11c}  LEADER '
  end
  window:set_right_status(wezterm.format({
    { Foreground = { Color = '#1e1e2e' } },
    { Background = { Color = '#f38ba8' } },
    { Text = leader },
    'ResetAttributes',
    { Foreground = { Color = '#89b4fa' } },
    { Text = '  \u{f489}  ' .. window:active_workspace() .. '  ' },
    { Foreground = { Color = '#a6adc8' } },
    { Text = '\u{f017}  ' .. wezterm.strftime('%H:%M') .. '  ' },
  }))
end)

-----------------------------------------------------------------------
-- Keys: CTRL+a is the leader (like tmux). Letters only, so it works on
-- any keyboard layout (incl. Portuguese).
-----------------------------------------------------------------------
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1200 }

config.keys = {
  -- Basic shortcuts, no leader needed
  --   ALT+E         split side by side      ALT+O         split top / bottom
  --   CTRL+SHIFT+W  close the current pane  ALT+Arrows    move between panes
  --   ALT+SHIFT+Arrows  resize the current pane
  { key = 'e', mods = 'ALT', action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
  { key = 'o', mods = 'ALT', action = act.SplitVertical({ domain = 'CurrentPaneDomain' }) },
  { key = 'W', mods = 'CTRL|SHIFT', action = act.CloseCurrentPane({ confirm = true }) },
  { key = 'LeftArrow', mods = 'ALT', action = act.ActivatePaneDirection('Left') },
  { key = 'RightArrow', mods = 'ALT', action = act.ActivatePaneDirection('Right') },
  { key = 'UpArrow', mods = 'ALT', action = act.ActivatePaneDirection('Up') },
  { key = 'DownArrow', mods = 'ALT', action = act.ActivatePaneDirection('Down') },
  { key = 'LeftArrow', mods = 'ALT|SHIFT', action = act.AdjustPaneSize({ 'Left', 3 }) },
  { key = 'RightArrow', mods = 'ALT|SHIFT', action = act.AdjustPaneSize({ 'Right', 3 }) },
  { key = 'UpArrow', mods = 'ALT|SHIFT', action = act.AdjustPaneSize({ 'Up', 2 }) },
  { key = 'DownArrow', mods = 'ALT|SHIFT', action = act.AdjustPaneSize({ 'Down', 2 }) },

  -- send a real CTRL+a by pressing it twice
  { key = 'a', mods = 'LEADER|CTRL', action = act.SendKey({ key = 'a', mods = 'CTRL' }) },

  -- splits
  { key = 'v', mods = 'LEADER', action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
  { key = 's', mods = 'LEADER', action = act.SplitVertical({ domain = 'CurrentPaneDomain' }) },
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane({ confirm = true }) },
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },

  -- move between panes (vim keys)
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection('Left') },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection('Down') },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection('Up') },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection('Right') },

  -- resize mode: LEADER r, then h/j/k/l, Esc to leave
  { key = 'r', mods = 'LEADER', action = act.ActivateKeyTable({ name = 'resize_pane', one_shot = false }) },

  -- tabs
  { key = 'c', mods = 'LEADER', action = act.SpawnTab('CurrentPaneDomain') },
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  {
    key = 't', mods = 'LEADER',
    action = act.PromptInputLine({
      description = 'Rename tab',
      action = wezterm.action_callback(function(window, _, line)
        if line then window:active_tab():set_title(line) end
      end),
    }),
  },

  -- workspaces (like tmux sessions)
  { key = 'w', mods = 'LEADER', action = act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }) },

  -- pick a shell (PowerShell 7 / 5 / cmd / WSL) for a new tab
  { key = 'Space', mods = 'LEADER', action = act.ShowLauncherArgs({ flags = 'FUZZY|LAUNCH_MENU_ITEMS' }) },

  -- utilities
  { key = 'y', mods = 'LEADER', action = act.ActivateCopyMode },
  { key = 'f', mods = 'LEADER', action = act.QuickSelect },     -- grab URLs, hashes, paths
  { key = 'o', mods = 'LEADER', action = act.EmitEvent('toggle-opacity') },
  { key = 'UpArrow', mods = 'LEADER', action = adjust_opacity(0.05) },
  { key = 'DownArrow', mods = 'LEADER', action = adjust_opacity(-0.05) },
  { key = 'P', mods = 'CTRL|SHIFT', action = act.ActivateCommandPalette },
}

-- LEADER 1..9 jumps to that tab
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i), mods = 'LEADER', action = act.ActivateTab(i - 1),
  })
end

config.key_tables = {
  resize_pane = {
    { key = 'h', action = act.AdjustPaneSize({ 'Left', 3 }) },
    { key = 'j', action = act.AdjustPaneSize({ 'Down', 3 }) },
    { key = 'k', action = act.AdjustPaneSize({ 'Up', 3 }) },
    { key = 'l', action = act.AdjustPaneSize({ 'Right', 3 }) },
    { key = 'Escape', action = 'PopKeyTable' },
    { key = 'Enter', action = 'PopKeyTable' },
  },
}

return config
