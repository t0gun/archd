#!/usr/bin/env bash
set -euo pipefail

log() { printf '[+] %s\n' "$*"; }
if ! command -v iwctl &>/dev/null; then
  sudo pacman -S --noconfirm --needed iwd
fi

sudo systemctl enable --now iwd.service
sudo systemctl enable --now systemd-networkd.service systemd-resolved.service

log "Override systemd‑networkd‑wait‑online to exit on first link"
sudo mkdir -p /etc/systemd/system/systemd-networkd-wait-online.service.d
sudo install -Dm644 <(cat <<'EOF'
[Service]
ExecStart=
ExecStart=/usr/lib/systemd/systemd-networkd-wait-online --any
EOF
) /etc/systemd/system/systemd-networkd-wait-online.service.d/10-wait-any.conf

log "Done. Reboot, then run: networkctl status && iwctl station list"