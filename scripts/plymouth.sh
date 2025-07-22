#!/usr/bin/env bash
set -euo pipefail

if ! command -v plymouth &>/dev/null; then
  yay -S --noconfirm --needed plymouth plymouth-theme-arch-logo

  # Backup mkinitcpio.conf
  timestamp=$(date +"%Y%m%d%H%M%S")
  sudo cp /etc/mkinitcpio.conf "/etc/mkinitcpio.conf.bak.$timestamp"

  # Add plymouth to HOOKS after base systemd or base udev
  if grep "^HOOKS=" /etc/mkinitcpio.conf | grep -q "base systemd"; then
    sudo sed -i '/^HOOKS=/s/base systemd/base systemd plymouth/' /etc/mkinitcpio.conf
  elif grep "^HOOKS=" /etc/mkinitcpio.conf | grep -q "base udev"; then
    sudo sed -i '/^HOOKS=/s/base udev/base udev plymouth/' /etc/mkinitcpio.conf
  else
    echo "Could not detect a valid base hook in mkinitcpio.conf"
    exit 1
  fi

  # Regenerate initramfs
  sudo mkinitcpio -P

  # Set the theme
  sudo plymouth-set-default-theme -R arch-logo

  # Append splash and quiet to kernel parameters
  if [ -d "/boot/loader/entries" ]; then
    echo "Detected systemd-boot"
    for entry in /boot/loader/entries/*.conf; do
      [[ "$entry" == *fallback* ]] && continue
      if ! grep -q splash "$entry"; then
        sudo sed -i '/^options/ s/$/ splash quiet/' "$entry"
      fi
    done

  elif [ -f "/etc/default/grub" ]; then
    echo "Detected GRUB"
    sudo cp /etc/default/grub "/etc/default/grub.bak.$timestamp"

    if ! grep -q splash /etc/default/grub; then
      current=$(grep "^GRUB_CMDLINE_LINUX_DEFAULT=" /etc/default/grub | cut -d'"' -f2)
      new=$(echo "$current splash quiet" | xargs)
      sudo sed -i "s/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT=\"$new\"/" /etc/default/grub
      sudo grub-mkconfig -o /boot/grub/grub.cfg
    fi

  elif [ -f "/etc/kernel/cmdline" ]; then
    echo "Detected UKI with /etc/kernel/cmdline"
    sudo cp /etc/kernel/cmdline "/etc/kernel/cmdline.bak.$timestamp"
    current=$(cat /etc/kernel/cmdline)
    new=$(echo "$current splash quiet" | xargs)
    echo "$new" | sudo tee /etc/kernel/cmdline

  elif [ -d "/etc/cmdline.d" ]; then
    echo "Detected UKI with /etc/cmdline.d"
    echo "splash" | sudo tee -a /etc/cmdline.d/plymouth.conf
    echo "quiet" | sudo tee -a /etc/cmdline.d/plymouth.conf

  else
    echo ""
    echo "Bootloader not detected. Please manually add 'splash quiet' to your kernel command line."
    echo ""
  fi
fi
