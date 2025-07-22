#!/usr/bin/env bash
set -euo pipefail

sudo pacman -S --needed --noconfirm base-devel

command -v yay >/dev/null 2>&1 || (
  cd /tmp && rm -rf yay && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm
)

packages=(
  # Networking and diagnostics
  traceroute        # Trace network hops
  dnsutils          # dig, nslookup
  nmap              # Port scanner
  nftables          # Netfilter packet filtering
  tcpdump           # Packet capture
  mtr               # Real-time network diagnostics
  openssh           # SSH client/server
  wireguard-tools   # VPN tunneling

  # Modern terminal tools
  ripgrep           # Fast grep replacement
  zoxide            # Smarter cd
  fzf               # Fuzzy file finder
  bat               # Modern cat
  zathura           # Lightweight document viewer
  zathura-pdf-mupdf # Fast PDF backend
  fastfetch         # System info display
  btop              # TUI system monitor
  wl-clipboard      # Wayland clipboard integration
  wl-clip-persist   # Clipboard persistence (Wayland fix)
  less              # Pager
  man               # Manual pages
  tldr              # Simplified help pages

  # Editors and dev tools
  neovim            # Modern vim
  vim               # Classic editor
  mise              # Universal env manager
  sqlite            # Lightweight SQL DB

  # Security
  fail2ban          # Brute-force protection
  gnupg             # GPG encryption/signing

  # Terminal emulators and helpers
  alacritty         # GPU-accelerated terminal
  bash-completion   # Tab completion support
  tree              # Directory tree view

  # GUI utilities
  nautilus          # File manager
  sushi             # Nautilus previewer (Spacebar preview)

  # Media + viewers
  mpv               # Video/audio player
  imv               # Lightweight image viewer

  # Browser
  chromium          # Wayland-capable browser

  # Audio stack
  pamixer           # CLI audio control
  playerctl         # Media key support
  pavucontrol       # GUI audio control
  wireplumber       # PipeWire session manager (auto-pulls pipewire + pulse)

  # Bluetooth
  blueberry         # Bluetooth GUI manager
)



yay -S --noconfirm --needed "${packages[@]}"


sudo systemctl enable --now sshd.service
sudo systemctl enable --now nftables.service
sudo systemctl enable --now iwd.service
sudo systemctl enable --now fail2ban.service
sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now pipewire.socket pipewire-pulse.socket wireplumber.service
