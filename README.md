# WezTerm dotfiles

A small, practical WezTerm setup with PowerShell on Windows, sensible font fallbacks elsewhere, Catppuccin Mocha, panes, tabs, workspaces, search, and quick-select. No plugins or extra runtime dependencies.

## Install

Install [WezTerm](https://wezterm.org/install/index.html), clone this repository, then run:

```powershell
pwsh -File ./install.ps1
```

The installer copies `wezterm.lua` to `~/.config/wezterm/wezterm.lua`. If a config already exists, it is preserved beside it as a timestamped backup. WezTerm reloads config changes automatically; `Ctrl+Shift+R` forces a reload.

To try the config without installing it:

```powershell
wezterm --config-file ./wezterm.lua start
```

## Cheat sheet

`Leader` means press `Ctrl+a`, release it, then press the next key.

| Keys | Action |
|---|---|
| `Leader t` | New tab |
| `Leader n` / `Leader b` | Next / previous tab |
| `Leader v` | Split pane right |
| `Leader s` | Split pane down |
| `Leader x` | Close pane with confirmation |
| `Leader z` | Zoom / restore pane |
| `Leader p` | Select a pane by label |
| `Alt+Arrow` | Focus pane in that direction |
| `Leader Arrow` | Resize pane in that direction |
| `Leader w` | Workspace picker |
| `Ctrl+Shift+P` | Command palette |
| `Ctrl+Shift+F` | Search scrollback |
| `Ctrl+Shift+Space` | Quick-select URLs and paths |
| `Alt+Enter` | Toggle fullscreen |
| `Ctrl+Shift+C` / `Ctrl+Shift+V` | Copy / paste (WezTerm defaults) |
| `Ctrl+Shift+R` | Reload configuration (WezTerm default) |
| `Ctrl+Shift++` / `Ctrl+-` / `Ctrl+0` | Font larger / smaller / reset (WezTerm defaults) |
| `Leader Ctrl+a` | Send a literal `Ctrl+a` to the shell |

Run `wezterm show-keys` to inspect every active binding, including WezTerm's defaults.

## Personalise

Edit `wezterm.lua`, then rerun `install.ps1` if this clone is not already at `~/.config/wezterm`.

- Change `config.color_scheme`; list installed schemes with `wezterm ls-colors`.
- Change the font list from top to bottom in `wezterm.font_with_fallback`.
- Adjust `font_size`, `window_background_opacity`, or the padding values.

Configuration reference: [wezterm.org/config](https://wezterm.org/config/files.html)
