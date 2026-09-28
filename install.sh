#!/bin/sh
set -eu

source_file="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/wezterm.lua"
config_dir="${XDG_CONFIG_HOME:-"$HOME/.config"}/wezterm"
destination="$config_dir/wezterm.lua"

mkdir -p "$config_dir"

if [ -f "$destination" ]; then
  cp "$destination" "$destination.backup-$(date +%Y%m%d-%H%M%S)"
fi

cp "$source_file" "$destination"
printf 'Installed WezTerm config at %s\n' "$destination"
