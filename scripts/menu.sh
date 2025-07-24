#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SCRIPTS=(
  base.sh fonts.sh iwd.sh docker.sh setup-firewall.sh hyprland.sh asdcontrol.sh appl-fn-keys.sh
)

for script in "${SCRIPTS[@]}}"; do
  echo " Running $script"
  bash "$SCRIPT_DIR/$script"
  done
