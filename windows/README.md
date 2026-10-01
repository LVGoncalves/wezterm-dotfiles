# WezTerm dotfiles

A small, practical WezTerm setup with Windows PowerShell, sensible font fallbacks, Catppuccin Mocha, panes, tabs, workspaces, search, and quick-select. No plugins or extra runtime dependencies.

## Install

Clone this repository, open PowerShell in its `windows` folder, and run one command:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

The script installs WezTerm with `winget` when available, otherwise with the current official Windows installer, then copies `wezterm.lua` to `~/.config/wezterm/wezterm.lua`. If a config already exists, it is preserved beside it as a timestamped backup. WezTerm reloads config changes automatically; `Ctrl+Shift+R` forces a reload.

To try the config without installing it:

```powershell
wezterm --config-file ./wezterm.lua start
```

## Cheat sheet

`Leader` means press `Ctrl+a`, release it, then press the next key.

| Keys | Action |
|---|---|
| `Leader c` | New tab |
| `Leader n` / `Leader p` | Next / previous tab |
| `Leader 1`–`9` | Jump to tab |
| `Leader t` | Rename tab |
| `Leader v` / `Alt+e` | Split pane right |
| `Leader s` / `Alt+o` | Split pane down |
| `Leader x` / `Ctrl+Shift+W` | Close pane with confirmation |
| `Leader z` | Zoom / restore pane |
| `Leader h/j/k/l` / `Alt+Arrow` | Focus pane in that direction |
| `Leader r`, then `h/j/k/l` | Resize mode (`Esc` / `Enter` to exit) |
| `Alt+Shift+Arrow` | Resize pane in that direction |
| `Leader w` | Workspace picker |
| `Leader Space` | Launch menu |
| `Leader y` | Copy mode |
| `Leader f` | Quick-select URLs, hashes and paths |
| `Leader o` | Toggle transparency |
| `Leader Up` / `Leader Down` | More / less opaque |
| `Ctrl+Shift+P` | Command palette |
| `Ctrl+Shift+C` / `Ctrl+Shift+V` | Copy / paste (WezTerm defaults) |
| `Ctrl+Shift+R` | Reload configuration (WezTerm default) |
| `Leader Ctrl+a` | Send a literal `Ctrl+a` to the shell |

Run `wezterm show-keys` to inspect every active binding, including WezTerm's defaults.

## Personalise

Edit `wezterm.lua`, then rerun `install.ps1` if this clone is not already at `~/.config/wezterm`.

- Change `config.color_scheme`; list installed schemes with `wezterm ls-colors`.
- Change the font list from top to bottom in `wezterm.font_with_fallback`.
- Adjust `font_size`, `window_background_opacity`, or the padding values.

Configuration reference: [wezterm.org/config](https://wezterm.org/config/files.html)
