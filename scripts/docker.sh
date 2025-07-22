#!/usr/bin/env bash
set -euo pipefail

yay -S --noconfirm --needed docker docker-compose docker-buildx

# Start Docker automatically
sudo systemctl enable  docker

# Give this user privileged Docker access
sudo usermod -aG docker ${USER}

# Prevent Docker from preventing boot for network-online.target
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo tee /etc/systemd/system/docker.service.d/no-block-boot.conf <<'EOF'
[Unit]
DefaultDependencies=no
EOF

sudo systemctl daemon-reload