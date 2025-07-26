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

services=(
  pipewire.service pipewire-pulse.service sshd.service nftables.service fail2ban.service bluetooth.service
  wireplumber.service cups.service
)

for svc in "${services[@]}"; do
  if ! sudo systemctl enable --now "$svc"; then
    echo " Failed to start: $svc"
  else
    echo " Started: $svc"
  fi
done

# first all files in the config folder must be replaced with the actual ones in the home dir.

# SDDM SET UP it must be after .config from git has been copied to home.
./sddm.sh