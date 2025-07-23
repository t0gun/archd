#!/usr/bin/env bash
set -euo pipefail

# Install asdcontrol for controlling brightness on Apple Displays
if ! command -v asdcontrol &>/dev/null; then
  git clone https://github.com/nikosdion/asdcontrol.git /tmp/asdcontrol
  cd /tmp/asdcontrol
  make
  sudo make install
  cd -
  rm -rf /tmp/asdcontrol

  # Setup passwordless access
  echo "$USER ALL=(ALL) NOPASSWD: /usr/local/bin/asdcontrol" | sudo tee /etc/sudoers.d/asdcontrol > /dev/null
  sudo chmod 440 /etc/sudoers.d/asdcontrol
fi

