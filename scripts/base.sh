#!/usr/bin/env bash
set -euo pipefail

sudo pacman -S --needed --noconfirm base-devel

command -v yay >/dev/null 2>&1 || (
  cd /tmp && rm -rf yay && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm
)

packages=(
  openssh   wireguard-tools curl wget unzip iwd tcpdump nmap dnsutils traceroute mtr nftables bat zathura   fastfetch
  btop   less    man  neovim      vim mise    sqlite  fail2ban   gnupg tree alacritty  gopls delve go-tools golangci-lint
  pamixer  playerctl  pavucontrol    wireplumber pipewire pipewire-pulse pipewire-alsa pipewire-jack blueberry   cups cups-filters cups-pdf system-config-printer xournalpp
  localsend-bin zathura-pdf-mupdf chromium libreoffice-fresh
)

# Force-switch JACK provider to PipeWire
sudo pacman -Rdd --noconfirm jack2 || true
yay -S --noconfirm --needed "${packages[@]}"


