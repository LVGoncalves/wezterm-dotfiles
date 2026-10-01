# WezTerm dotfiles

Catppuccin Mocha WezTerm config for Windows, Linux and macOS.

## Install

Windows (PowerShell):

```powershell
irm https://raw.githubusercontent.com/LVGoncalves/wezterm-dotfiles/main/install.ps1 | iex
```

Ubuntu / Debian:

```sh
curl -fsSL https://raw.githubusercontent.com/LVGoncalves/wezterm-dotfiles/main/install.sh | sh
```

Installs WezTerm, JetBrainsMono Nerd Font and the config at `~/.config/wezterm/wezterm.lua`. An existing config is kept as a `.backup-<date>` file. Re-run to update.

## Keys

`Leader` is `Ctrl+a`, then the next key.

| Keys | Action |
|---|---|
| `Leader c` | New tab |
| `Leader n` / `Leader p` | Next / previous tab |
| `Leader 1`–`9` | Go to tab |
| `Leader t` | Rename tab |
| `Alt+e` / `Alt+o` | Split right / down |
| `Ctrl+Shift+W` | Close pane |
| `Leader z` | Zoom pane |
| `Alt+Arrow` | Focus pane |
| `Alt+Shift+Arrow` | Resize pane |
| `Leader w` | Workspaces |
| `Leader Space` | Other shells |
| `Leader y` | Copy mode |
| `Leader f` | Quick-select |
| `Leader o` | Toggle transparency |
| `Leader Up` / `Leader Down` | More / less opaque |
| `Ctrl+Shift+P` | Command palette |
| `Leader Ctrl+a` | Send `Ctrl+a` |
