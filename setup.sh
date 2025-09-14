#!/bin/bash
set -e

echo "=============================="
echo "  Debian Minimal GUI Setup"
echo "=============================="

echo "[1/6] Updating system..."
sudo apt update && sudo apt upgrade -y

echo "[2/6] Installing Chromium..."
sudo apt install -y chromium

echo "[3/6] Installing XRDP + Openbox..."
sudo apt install -y xrdp openbox xterm

# Detect login user (not root) for RDP sessions
TARGET_USER=$(logname)
echo "[*] Configuring Openbox session for user: $TARGET_USER"
echo "openbox-session" | sudo tee /home/$TARGET_USER/.xsession
sudo chown $TARGET_USER:$TARGET_USER /home/$TARGET_USER/.xsession

echo "[4/6] Enabling XRDP base services..."
sudo systemctl enable xrdp
sudo systemctl enable xrdp-sesman

echo "[5/6] Creating 2GB swap file (persistent, active after reboot)..."
if [ ! -f /swapfile ]; then
  sudo fallocate -l 2G /swapfile
  sudo chmod 600 /swapfile
  sudo mkswap /swapfile
  echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
  echo "[*] Swapfile created. You must reboot before continuing."
else
  echo "[*] Swapfile already exists, skipping..."
fi

echo "[6/6] Creating systemd GUI wrapper service..."
SERVICE_FILE=/etc/systemd/system/gui.service
sudo bash -c "cat > $SERVICE_FILE" << 'EOF'
[Unit]
Description=Minimal GUI with RDP
After=network.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/bin/systemctl start xrdp xrdp-sesman
ExecStop=/bin/systemctl stop xrdp xrdp-sesman

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl disable gui

echo "=============================="
echo "  Setup Complete!"
echo "=============================="
echo "👉 IMPORTANT: A reboot is required before using GUI/RDP,"
echo "   because the new 2GB swap file only activates after reboot."
echo
echo "After reboot, check swap with:"
echo "   swapon --show"
echo "   free -h"
echo
echo "Then you can use:"
echo "   sudo systemctl start gui   # enable RDP"
echo "   sudo systemctl stop gui    # disable RDP"
echo "   sudo systemctl status gui  # check status"