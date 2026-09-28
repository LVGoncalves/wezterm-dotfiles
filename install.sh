#!/bin/sh
set -eu

as_root() {
  if [ "$(id -u)" -eq 0 ]; then "$@"; else sudo "$@"; fi
}

if ! command -v wezterm >/dev/null 2>&1; then
  command -v apt-get >/dev/null 2>&1 || { printf 'This installer requires Ubuntu or Debian.\n' >&2; exit 1; }
  if [ "$(id -u)" -ne 0 ] && ! command -v sudo >/dev/null 2>&1; then
    printf 'sudo is required to install WezTerm.\n' >&2
    exit 1
  fi

  as_root apt-get update
  as_root apt-get install -y curl gpg
  curl -fsSL https://apt.fury.io/wez/gpg.key | as_root gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
  printf '%s\n' 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | as_root tee /etc/apt/sources.list.d/wezterm.list >/dev/null
  as_root chmod 644 /usr/share/keyrings/wezterm-fury.gpg
  as_root apt-get update
  as_root apt-get install -y wezterm
fi

source_file="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/wezterm.lua"
config_dir="${XDG_CONFIG_HOME:-"$HOME/.config"}/wezterm"
destination="$config_dir/wezterm.lua"

mkdir -p "$config_dir"

if [ -f "$destination" ]; then
  cp "$destination" "$destination.backup-$(date +%Y%m%d-%H%M%S)"
fi

cp "$source_file" "$destination"
printf 'WezTerm is ready with config at %s\n' "$destination"
