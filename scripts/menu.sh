#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SCRIPTS=(
  base.sh fonts.sh iwd.sh docker.sh setup-firewall.sh hyprland.sh asdcontrol.sh appl-fn-keys.sh
)

for script in "${SCRIPTS[@]}"; do
  echo " Running $script"
  bash "$SCRIPT_DIR/$script"
  done

user_services=(pipewire.service pipewire-pulse.service wireplumber.service)
services=(
  sshd.service nftables.service fail2ban.service bluetooth.service
  wireplumber.service cups.service
)

  for svc in "${user_services[@]}"; do
    if systemctl --user enable --now "$svc"; then
      echo "Started (user): $svc"
    else
      echo " Failed to start (user): $svc"
    fi
  done

for svc in "${services[@]}"; do
  if ! sudo systemctl enable --now "$svc"; then
    echo " Failed to start: $svc"
  else
    echo " Started: $svc"
  fi
done

# first all files in the config folder must be replaced with the actual ones in the home dir.
CONFIG_SRC="$SCRIPT_DIR/../config" # go one directory up
mkdir -p "$HOME/.config"
for item in "$CONFIG_SRC"/*; do
  target="$HOME/.config/$(basename "$item")"
  mkdir -p "$target"
  cp -rT "$item" "$target"  #replaces recursively without nesting -rT
done

# SDDM SET UP it must be after .config from git has been copied to home.
bash "$SCRIPT_DIR/sddm.sh"