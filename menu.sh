#!/usr/bin/env bash
set -euo pipefail

# Simple installer runner.  Provide a script name as an argument to run it
# and all of its prerequisites.  With no argument, every script runs in order.

SCRIPT_DIR="$(dirname "$(realpath "$0")")/scripts"

# Installation order.  Add or reorder entries here if new scripts appear.
SCRIPTS=(
  base.sh
  fonts.sh
  iwd.sh
  docker.sh
  plymouth.sh
  setup-firewall.sh
  hyprland.sh
  theme.sh
  autologin.sh
  mimes.sh
  asdcontrol.sh
  appl-fn-keys.sh
)

target=${1:-}
if [[ -n $target && ! " ${SCRIPTS[*]} " =~ " $target " ]]; then
  echo "Unknown script: $target" >&2
  exit 1
fi

run_all=true
[[ -n $target ]] && run_all=false

# Run each script in sequence, stopping when the requested target finishes.
for s in "${SCRIPTS[@]}"; do
  echo "=== Running $s ==="
  "$SCRIPT_DIR/$s"
  [[ $run_all == false && $s == "$target" ]] && break
done
