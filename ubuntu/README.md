# WezTerm dotfiles for Ubuntu

A dependency-free WezTerm setup for Ubuntu with the current login shell, Linux font fallbacks, Catppuccin Mocha, panes, tabs, workspaces, search, and quick-select.

## Install

Clone this repository, open a terminal in its `ubuntu` folder, and run one command:

```sh
sh ./install.sh
```

The script installs WezTerm from its official APT repository when needed, then copies `wezterm.lua` to `${XDG_CONFIG_HOME:-~/.config}/wezterm/wezterm.lua`. An existing config is preserved beside it as a timestamped backup. It supports Ubuntu and Debian.

Try it without installing:

```sh
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
| `Alt+Shift+Arrow` | Resize pane in that direction |
| `Leader w` | Workspace picker |
| `Ctrl+Shift+P` | Command palette |
| `Ctrl+Shift+F` | Search scrollback |
| `Ctrl+Shift+Space` | Quick-select URLs and paths |
| `Alt+Enter` | Toggle fullscreen |
| `Ctrl+Shift+C` / `Ctrl+Shift+V` | Copy / paste |
| `Ctrl+Shift+R` | Reload configuration |
| `Ctrl+Shift++` / `Ctrl+-` / `Ctrl+0` | Font larger / smaller / reset |
| `Leader Ctrl+a` | Send a literal `Ctrl+a` to the shell |

Run `wezterm show-keys` to inspect every active binding.

Official references: [Linux installation](https://wezterm.org/install/linux.html) and [configuration files](https://wezterm.org/config/files.html).
