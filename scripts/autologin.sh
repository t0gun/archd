#!/usr/bin/env bash
set -euo pipefail

# Install uwsm if not installed
yay -S --noconfirm --needed uwsm

# Compile seamless login helper
cat <<'CCODE' >/tmp/seamless-login.c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <linux/kd.h>
#include <linux/vt.h>
#include <sys/wait.h>
#include <string.h>

int main(int argc, char *argv[]) {
    int vt_fd;
    int vt_num = 1; // TTY1
    char vt_path[32];

    if (argc < 2) {
        fprintf(stderr, "Usage: %s <session_command>\n", argv[0]);
        return 1;
    }

    snprintf(vt_path, sizeof(vt_path), "/dev/tty%d", vt_num);
    vt_fd = open(vt_path, O_RDWR);
    if (vt_fd < 0) {
        perror("Failed to open VT");
        return 1;
    }

    if (ioctl(vt_fd, VT_ACTIVATE, vt_num) < 0 ||
        ioctl(vt_fd, VT_WAITACTIVE, vt_num) < 0 ||
        ioctl(vt_fd, KDSETMODE, KD_GRAPHICS) < 0) {
        perror("VT setup failed");
        close(vt_fd);
        return 1;
    }

    const char *clear_seq = "\33[H\33[2J";
    write(vt_fd, clear_seq, strlen(clear_seq));
    close(vt_fd);

    const char *home = getenv("HOME");
    if (home) chdir(home);

    execvp(argv[1], &argv[1]);
    perror("Failed to exec session");
    return 1;
}
CCODE

# Install it
gcc -o /tmp/seamless-login /tmp/seamless-login.c
sudo mv /tmp/seamless-login /usr/local/bin/seamless-login
sudo chmod +x /usr/local/bin/seamless-login
rm /tmp/seamless-login.c

# Create systemd service unit
cat <<EOF | sudo tee /etc/systemd/system/seamless-hyprland-login.service
[Unit]
Description=Seamless Auto-Login to Hyprland
Conflicts=getty@tty1.service
After=systemd-user-sessions.service getty@tty1.service plymouth-quit.service systemd-logind.service
PartOf=graphical.target

[Service]
Type=simple
ExecStart=/usr/local/bin/seamless-login uwsm start -- hyprland.desktop
Restart=always
RestartSec=2
User=$USER
TTYPath=/dev/tty1
TTYReset=yes
TTYVHangup=yes
TTYVTDisallocate=yes
StandardInput=tty
StandardOutput=journal
StandardError=journal+console
PAMName=login

[Install]
WantedBy=graphical.target
EOF

# Hold Plymouth until GUI is up
sudo mkdir -p /etc/systemd/system/plymouth-quit.service.d
sudo tee /etc/systemd/system/plymouth-quit.service.d/wait-for-graphical.conf >/dev/null <<'EOF'
[Unit]
After=multi-user.target
EOF

# Disable service that waits unnecessarily
sudo systemctl mask plymouth-quit-wait.service

# Apply systemd changes
sudo systemctl daemon-reload

# Enable seamless login and disable conflicting TTY login
sudo systemctl enable seamless-hyprland-login.service
sudo systemctl disable getty@tty1.service
