#!/usr/bin/env bash
set -euo pipefail

hyprland_packages=(
  hyprland hyprshot hyprpicker hyprlock hypridle wl-clipboard wl-clip-persist  polkit-gnome  hyprland-qtutils wofi
  waybar mako  swaybg nautilus sushi  mpv imv  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk  xorg-xwayland
  xdg-desktop-portal grim slurp libnotify gvfs uwsm libnewt sddm swayosd
)

yay -S --noconfirm --needed "${hyprland_packages[@]}"