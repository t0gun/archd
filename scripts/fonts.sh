#!/usr/bin/env bash
set -euo pipefail

font_packages=(
  ttf-font-awesome     # Icon font used in GUIs, status bars, etc.
  noto-fonts           # Basic UI font (Latin + symbols)
  noto-fonts-emoji     # Emoji rendering support
  noto-fonts-extra     # Extended glyphs and rare scripts
)

yay -Sy --noconfirm --needed "${font_packages[@]}"

# Ensure user font directory exists
mkdir -p ~/.local/share/fonts

# Check and install JetBrainsMono Nerd Font only if missing
if ! fc-list | grep -qi "JetBrainsMono Nerd Font"; then
  pushd /tmp >/dev/null
  wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
  unzip JetBrainsMono.zip -d JetBrainsMono
  cp JetBrainsMono/*.ttf ~/.local/share/fonts/
  rm -rf JetBrainsMono.zip JetBrainsMono
  fc-cache -f
  popd >/dev/null
else
  echo "JetBrainsMono Nerd Font already installed"
fi
