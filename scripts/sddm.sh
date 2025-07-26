#!/usr/bin/env bash
set -euo pipefail


systemctl enable sddm.service # need on restart
USERNAME="apprentice"
SESSION="hyprland-uwsm.desktop"
BG_IMAGE="$HOME/.config/bg/wp.jpg"
THEME_NAME="elarun"

sudo bash -c "cat > /etc/sddm.conf" <<EOF
[Autologin]
User=$USERNAME
Session=$SESSION

[Theme]
Current=$THEME_NAME
EOF

THEME_DIR="/usr/share/sddm/themes/$THEME_NAME"
BG_TARGET="$THEME_DIR/background.jpg"
sudo cp "$BG_IMAGE" "$BG_TARGET"
THEME_CONF="$THEME_DIR/theme.conf"
 sudo sed -i "s|^background=.*|background=background.jpg|" "$THEME_CONF"