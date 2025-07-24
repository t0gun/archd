#!/usr/bin/env bash
set -euo pipefail

hyprland_packages=(
  hyprland                 # Wayland compositor (Hyprland core)
  hyprshot                 # Screenshot tool for Hyprland
  hyprpicker               # Eyedropper / color picker for Hyprland
  hyprlock                 # Lock screen for Hyprland
  hypridle                 # Idle daemon (for screen dimming, locking)
   wl-clipboard      # Wayland clipboard integration
    wl-clip-persist   # Clipboard persistence (Wayland fix)

  # Integration + system services
  polkit-gnome             # GUI auth agent (required for privileged actions)
  hyprland-qtutils         # QT theming support for Hyprland

  # UI tools
  wofi                     # Launcher (dmenu/rofi-style for Wayland)
  waybar                   # Status bar (supports Hyprland modules)
  mako                     # Notification daemon for Wayland
  swaybg                   # Wallpaper setter for Wayland
   nautilus          # File manager
    sushi             # Nautilus previewer (Spacebar preview)
     mpv               # Video/audio player
      imv               # Lightweight image viewer

  # XDG portals for file pickers, screen share, Flatpak
  xdg-desktop-portal-hyprland
  xdg-desktop-portal-gtk
)

yay -S --noconfirm --needed "${hyprland_packages[@]}"