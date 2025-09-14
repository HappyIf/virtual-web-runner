# Debian Minimal GUI with XRDP (Google Cloud VM)

This repository provides a lightweight way to run **Chromium Browser** inside a Debian Google Cloud VM (e2-micro, 1 GB RAM). It installs **Openbox (minimal window manager)**, **XRDP (for Remote Desktop access)**, and sets up a **2 GB swapfile** so Chromium can run smoothly even on small machines.

---

## 📦 Contents
- `setup.sh` → One-time setup script (install Chromium, Openbox, XRDP, create swap, and add a systemd wrapper service).
- `README.md` → This guide.

---

## 🚀 Installation

1. Clone this repo or copy the `setup.sh` script into your VM.

   ```bash
   git clone https://github.com/<your-repo>/debian-rdp-setup.git
   cd debian-rdp-setup
   chmod +x setup.sh
   ```

2. Run the setup script:

   ```bash
   ./setup.sh
   ```

3. **Reboot the VM** to activate the swapfile:

   ```bash
   sudo reboot
   ```

   Or reboot from Google Cloud Console → **Compute Engine → VM instances → Stop → Start**.

4. After reboot, verify swap is active:

   ```bash
   swapon --show
   free -h
   ```

   You should see ~2.0G swap.

---

## 🖥️ Usage

Once setup and reboot are done, you can manage the GUI via systemd.

- **Start GUI + RDP**
  ```bash
  sudo systemctl start gui
  ```

- **Stop GUI + RDP**
  ```bash
  sudo systemctl stop gui
  ```

- **Check Status**
  ```bash
  sudo systemctl status gui
  ```

Then connect using any **Remote Desktop Client** (Windows, macOS, Linux):
- Address: your VM’s **external IP**
- Username: your Linux VM username
- Password: your user password (set with `passwd` if needed)

Once connected, you’ll land in an **Openbox session** where you can launch **Chromium**.

---

## ⚡ Notes
- The GUI does **not auto-start on boot** — you must manually start it with `systemctl start gui` when needed, to save RAM.
- The swap file ensures Chromium doesn’t run out of memory on small VMs.
- If you want Chromium to **auto-launch** when you connect via RDP, you can add a startup script to Openbox.

---

## ✅ Example Workflow

```bash
# First-time setup
./setup.sh
sudo reboot

# After reboot, confirm swap
swapon --show

# Enable GUI + RDP
sudo systemctl start gui

# Connect with Remote Desktop (using external IP)
# ... use Chromium ...

# When finished, disable GUI to free resources
sudo systemctl stop gui
```

---

Enjoy a lightweight GUI on your 1 GB Debian Google Cloud VM 🚀

