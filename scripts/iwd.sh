#!/usr/bin/env bash
set -euo pipefail

log() { printf '[+] %s\n' "$*"; }

log "Enabling required services"
sudo systemctl enable --now iwd.service
sudo systemctl enable --now systemd-networkd.service systemd-resolved.service

log "Configuring networkd to wait for any interface"
sudo mkdir -p /etc/systemd/system/systemd-networkd-wait-online.service.d

cat <<'EOF' | sudo tee /etc/systemd/system/systemd-networkd-wait-online.service.d/10-wait-any.conf > /dev/null
[Service]
ExecStart=
ExecStart=/usr/lib/systemd/systemd-networkd-wait-online --any
EOF

log "Done. Reboot, then run:"
log "    networkctl status"
log "    iwctl station list"
