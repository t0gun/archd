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

if ! fc-list | grep -qi "CaskaydiaMono Nerd Font"; then
  cd /tmp
  wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.zip
  unzip CascadiaMono.zip -d CascadiaFont
  cp CascadiaFont/CaskaydiaMonoNerdFont-Regular.ttf ~/.local/share/fonts
  cp CascadiaFont/CaskaydiaMonoNerdFont-Bold.ttf ~/.local/share/fonts
  cp CascadiaFont/CaskaydiaMonoNerdFont-Italic.ttf ~/.local/share/fonts
  cp CascadiaFont/CaskaydiaMonoNerdFont-BoldItalic.ttf ~/.local/share/fonts
  cp CascadiaFont/CaskaydiaMonoNerdFontPropo-Regular.ttf ~/.local/share/fonts
  cp CascadiaFont/CaskaydiaMonoNerdFontPropo-Bold.ttf ~/.local/share/fonts
  cp CascadiaFont/CaskaydiaMonoNerdFontPropo-Italic.ttf ~/.local/share/fonts
  cp CascadiaFont/CaskaydiaMonoNerdFontPropo-BoldItalic.ttf ~/.local/share/fonts
  rm -rf CascadiaMono.zip CascadiaFont
  fc-cache
  cd -
fi

if ! fc-list | grep -qi "iA Writer Mono S"; then
  cd /tmp
  wget -O iafonts.zip https://github.com/iaolo/iA-Fonts/archive/refs/heads/master.zip
  unzip iafonts.zip -d iaFonts
  cp iaFonts/iA-Fonts-master/iA\ Writer\ Mono/Static/iAWriterMonoS-*.ttf ~/.local/share/fonts
  rm -rf iafonts.zip iaFonts
  fc-cache
  cd -
  fi