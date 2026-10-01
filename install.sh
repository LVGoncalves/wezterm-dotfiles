#!/bin/sh
# Installs WezTerm, JetBrainsMono Nerd Font and this repo's wezterm.lua on Ubuntu/Debian.
# From a clone:  sh ./install.sh
# From GitHub:   curl -fsSL https://raw.githubusercontent.com/LVGoncalves/wezterm-dotfiles/main/install.sh | sh
set -eu

repo='https://raw.githubusercontent.com/LVGoncalves/wezterm-dotfiles/main'

as_root() {
  if [ "$(id -u)" -eq 0 ]; then "$@"; else sudo "$@"; fi
}

# Everything runs inside main so `curl | sh` reads the whole script before any
# command (like apt-get) can consume the rest of stdin.
main() {
  command -v apt-get >/dev/null 2>&1 || { printf 'This installer requires Ubuntu or Debian.\n' >&2; exit 1; }
  if [ "$(id -u)" -ne 0 ] && ! command -v sudo >/dev/null 2>&1; then
    printf 'sudo is required to install packages.\n' >&2
    exit 1
  fi

  # --- WezTerm + tools -------------------------------------------------------
  missing=''
  for tool in curl gpg xz fc-cache; do
    command -v "$tool" >/dev/null 2>&1 || missing=1
  done
  if [ -n "$missing" ] || ! command -v wezterm >/dev/null 2>&1; then
    as_root apt-get update
    as_root apt-get install -y curl gpg xz-utils fontconfig
  fi

  if ! command -v wezterm >/dev/null 2>&1; then
    printf 'Installing WezTerm...\n'
    curl -fsSL https://apt.fury.io/wez/gpg.key | as_root gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
    printf '%s\n' 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | as_root tee /etc/apt/sources.list.d/wezterm.list >/dev/null
    as_root chmod 644 /usr/share/keyrings/wezterm-fury.gpg
    as_root apt-get update
    as_root apt-get install -y wezterm
  fi

  # --- Font (per-user) -------------------------------------------------------
  font_dir="${XDG_DATA_HOME:-"$HOME/.local/share"}/fonts/JetBrainsMonoNerdFont"
  if [ -z "$(fc-list 'JetBrainsMono Nerd Font')" ]; then
    printf 'Installing JetBrainsMono Nerd Font...\n'
    mkdir -p "$font_dir"
    curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz \
      | tar -xJ -C "$font_dir" --wildcards 'JetBrainsMonoNerdFont-*.ttf'
    fc-cache -f "$font_dir"
  fi

  # --- Config ----------------------------------------------------------------
  config_dir="${XDG_CONFIG_HOME:-"$HOME/.config"}/wezterm"
  destination="$config_dir/wezterm.lua"
  mkdir -p "$config_dir"

  new="$(mktemp)"
  script_dir="$(dirname -- "$0")"
  if [ -f "$0" ] && [ -f "$script_dir/wezterm.lua" ]; then
    cp "$script_dir/wezterm.lua" "$new"
  else
    curl -fsSL "$repo/wezterm.lua" -o "$new"
  fi

  stamp="$(date +%Y%m%d-%H%M%S)"
  if [ -f "$destination" ] && ! cmp -s "$destination" "$new"; then
    cp "$destination" "$destination.backup-$stamp"
  fi
  mv "$new" "$destination"
  chmod 644 "$destination"

  # A leftover ~/.wezterm.lua is ignored by WezTerm and only causes confusion.
  if [ -f "$HOME/.wezterm.lua" ]; then
    mv "$HOME/.wezterm.lua" "$HOME/.wezterm.lua.backup-$stamp"
    printf 'Moved old ~/.wezterm.lua to ~/.wezterm.lua.backup-%s\n' "$stamp"
  fi

  printf 'WezTerm is ready with config at %s\n' "$destination"
}

main "$@"
