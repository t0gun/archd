#!/usr/bin/env bash
set -euo pipefail

sudo pacman -S --noconfirm kvantum-qt5 gnome-themes-extra

gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

THEMES_DIR="$(dirname "$(realpath "$0")")/../themes"
THEME_NAME="matte-black"
THEME_PATH="$THEMES_DIR/$THEME_NAME"

if [[ ! -d "$THEME_PATH" ]]; then
  echo " Theme not found: $THEME_NAME"
  exit 1
fi

echo " Installing theme: $THEME_NAME"

mkdir -p ~/.config/nvim/lua/plugins
cp "$THEME_PATH/neovim.lua" ~/.config/nvim/lua/plugins/theme.lua


mkdir -p ~/.local/share/backgrounds
cp "$THEME_PATH/backgrounds/"* ~/.local/share/backgrounds/
WALLPAPER=$(basename "$THEME_PATH"/backgrounds/*.jpg)
swww img ~/.local/share/backgrounds/"$WALLPAPER" 2>/dev/null || echo "Install swww to set wallpaper"

echo " Theme '$THEME_NAME' installed and activated."
