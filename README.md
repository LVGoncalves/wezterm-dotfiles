# WezTerm dotfiles

Catppuccin Mocha WezTerm setup with transparency, a bottom tab bar with a status line, and tmux-style `Ctrl+a` leader keys. One `wezterm.lua` works on Windows, Linux and macOS.

## Install

Each command installs WezTerm (if missing), the JetBrainsMono Nerd Font, and the config at `~/.config/wezterm/wezterm.lua`. Re-run it any time to update. If your existing config is different, it's kept beside the new one as a `.backup-<date>` file. An old `~/.wezterm.lua` is moved aside the same way.

**Windows** (PowerShell):

```powershell
irm https://raw.githubusercontent.com/LVGoncalves/wezterm-dotfiles/main/install.ps1 | iex
```

**Ubuntu / Debian**:

```sh
curl -fsSL https://raw.githubusercontent.com/LVGoncalves/wezterm-dotfiles/main/install.sh | sh
```

From a clone, run `powershell -ExecutionPolicy Bypass -File .\install.ps1` or `sh ./install.sh` instead. To try the config without installing it, run `wezterm --config-file ./wezterm.lua start`.

On Windows the default shell is PowerShell 7, or Windows PowerShell 5 if 7 isn't installed. `Leader Space` opens a menu with the other shells, including WSL.

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
| `Leader Space` | Launch menu (other shells) |
| `Leader y` | Copy mode |
| `Leader f` | Quick-select URLs, hashes and paths |
| `Leader o` | Toggle transparency |
| `Leader Up` / `Leader Down` | More / less opaque |
| `Ctrl+Shift+P` | Command palette |
| `Ctrl+Shift+C` / `Ctrl+Shift+V` | Copy / paste |
| `Ctrl+Shift+R` | Reload configuration |
| `Leader Ctrl+a` | Send a literal `Ctrl+a` to the shell |

Run `wezterm show-keys` to see every active binding.

## Personalise

Edit `wezterm.lua` and re-run the installer, or edit `~/.config/wezterm/wezterm.lua` directly. WezTerm reloads it automatically.

- `config.color_scheme`: list schemes with `wezterm ls-colors`
- `config.font` / `font_size`
- `window_background_opacity` (`0.0`–`1.0`)

Reference: [wezterm.org/config](https://wezterm.org/config/files.html)
