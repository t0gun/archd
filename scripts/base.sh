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
  # Go toolchain
  gopls delve go-tools golangci-lint


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

   # Printing
   cups              # CUPS printing system
   cups-filters      # Filter drivers for CUPS
   cups-pdf          # Print to PDF
   system-config-printer # Printer setup GUI

   # Extras
   obsidian  # second brain
   xournalpp  # sign pdfs

)



yay -S --noconfirm --needed "${packages[@]}"


services=(
  sshd.service nftables.service fail2ban.service bluetooth.service pipewire.socket pipewire-pulse.socket
  wireplumber.service cups.service
)

for svc in "${services[@]}"; do
  if ! sudo systemctl enable --now "$svc"; then
    echo " Failed to start: $svc"
  else
    echo " Started: $svc"
  fi
done
