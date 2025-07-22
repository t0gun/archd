#!/usr/bin/env bash
set -euo pipefail

# Rebuild desktop database for local apps
update-desktop-database ~/.local/share/applications

xdg-mime default imv.desktop image/png
xdg-mime default imv.desktop image/jpeg
xdg-mime default imv.desktop image/gif
xdg-mime default imv.desktop image/webp
xdg-mime default imv.desktop image/bmp
xdg-mime default imv.desktop image/tiff

xdg-mime default zathura.desktop application/pdf

video_types=(
  video/mp4
  video/x-msvideo
  video/x-matroska
  video/x-flv
  video/x-ms-wmv
  video/mpeg
  video/ogg
  video/webm
  video/quicktime
  video/3gpp
  video/3gpp2
  video/x-ms-asf
  video/x-ogm+ogg
  video/x-theora+ogg
  application/ogg
)

for type in "${video_types[@]}"; do
  xdg-mime default mpv.desktop "$type"
done

xdg-settings set default-web-browser chromium.desktop
xdg-mime default chromium.desktop x-scheme-handler/http
xdg-mime default chromium.desktop x-scheme-handler/https
