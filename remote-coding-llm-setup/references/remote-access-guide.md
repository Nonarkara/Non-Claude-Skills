# Remote Access Guide

Complete setup for accessing your MacBook from an iPad over the internet.

## Architecture

```
iPad (anywhere)  ──── Tailscale VPN ────  MacBook (home/office)
  ├─ Safari          (encrypted tunnel)     ├─ code-server :8080
  ├─ Blink Shell     (WireGuard, free)      ├─ Open WebUI  :3000
  └─ Tailscale app                          ├─ Ollama API  :11434
                                            └─ SSH         :22
```

## 1. Tailscale (Mesh VPN)

Tailscale creates a private network between your devices using WireGuard. No port forwarding, no dynamic DNS, no firewall rules. It just works.

### MacBook Setup

```bash
# Install via Homebrew
brew install --cask tailscale

# Or download from https://tailscale.com/download/mac
```

After installing:
1. Open Tailscale from Applications
2. Click "Log in" — sign in with Google, GitHub, or Apple
3. Tailscale runs in the menu bar

Get your Tailscale IP:
```bash
# In terminal
tailscale ip -4
# Returns something like 100.64.0.1
```

### iPad Setup

1. Download **Tailscale** from the App Store (free)
2. Open and log in with the **same account** as your MacBook
3. Both devices now see each other on the Tailscale network

### MagicDNS (Optional but Recommended)

Enable MagicDNS in the Tailscale admin console (https://login.tailscale.com/admin/dns) to use friendly hostnames instead of IPs:

```bash
# Instead of:
ssh user@100.64.0.1

# You can use:
ssh user@macbook-air
```

### Verify Connection

From iPad, open Safari and go to `http://<tailscale-ip>:8080` — if code-server is running, you'll see VS Code.

## 2. code-server (VS Code in Browser)

code-server runs VS Code as a web server on your MacBook. You access it from iPad Safari — full VS Code with extensions, terminal, and all.

### Install

```bash
brew install code-server
```

### Configure

Edit the config file:
```bash
# Config lives at:
# ~/.config/code-server/config.yaml

cat > ~/.config/code-server/config.yaml << 'EOF'
bind-addr: 0.0.0.0:8080
auth: password
password: your-secure-password-here
cert: false
EOF
```

**Important:** Bind to `0.0.0.0` so it's accessible from Tailscale. This is safe because Tailscale traffic is encrypted and only your devices can reach it.

### Start on Boot (launchd)

Create a launchd plist so code-server starts automatically:

```bash
mkdir -p ~/Library/LaunchAgents

cat > ~/Library/LaunchAgents/com.coder.code-server.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.coder.code-server</string>
    <key>ProgramArguments</key>
    <array>
        <string>/opt/homebrew/bin/code-server</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/code-server.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/code-server-error.log</string>
</dict>
</plist>
EOF

# Load it
launchctl load ~/Library/LaunchAgents/com.coder.code-server.plist
```

### Verify

```bash
# Check it's running
launchctl list | grep code-server

# Or open in browser
open http://localhost:8080
```

### iPad Access

1. Open Safari on iPad
2. Go to `http://<tailscale-ip>:8080`
3. Enter your password
4. **Add to Home Screen** (Share > Add to Home Screen) for PWA full-screen mode — no Safari chrome, feels like a native app

### iPad Tips for code-server

- **External keyboard** is essential for serious coding (Magic Keyboard, etc.)
- **Split View**: Run Safari (code-server) and Blink Shell side by side
- **PWA mode**: Adding to Home Screen removes the address bar — more screen space
- **Pinch to zoom**: Works for adjusting font size temporarily
- **Settings > Text Size**: Adjust editor font size in VS Code settings for iPad readability

## 3. SSH via Blink Shell

Blink Shell is the best terminal app on iPad. Native SSH, mosh support, and great keyboard handling.

### Install mosh on MacBook (Recommended)

mosh (mobile shell) handles network changes gracefully — perfect for iPad switching between Wi-Fi and cellular:

```bash
brew install mosh
```

### iPad: Blink Shell Setup

1. Install **Blink Shell** from the App Store
2. Open Blink and generate an SSH key:
   ```
   config > Keys > + > Generate
   ```
3. Copy the public key (tap the key > Copy Public Key)

### MacBook: Add iPad's Public Key

```bash
# Paste the public key from Blink into authorized_keys
echo "PASTE_YOUR_PUBLIC_KEY_HERE" >> ~/.ssh/authorized_keys

# Ensure correct permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

### Enable Remote Login on MacBook

1. System Settings > General > Sharing
2. Enable **Remote Login**
3. Set to "Only these users" and add your user account

### Connect from Blink

```bash
# SSH (works everywhere)
ssh user@<tailscale-ip>

# mosh (better for unstable connections)
mosh user@<tailscale-ip>
```

### Configure a Host in Blink

In Blink Shell, go to Config > Hosts and add:
- **Host**: macbook
- **Hostname**: your Tailscale IP or MagicDNS name
- **User**: your macOS username
- **Key**: select the key you generated
- **Port**: 22
- **Mosh**: enabled

Now you can just type `macbook` in Blink to connect.

## 4. Claude Code from iPad

Claude Code is available as a web app at **claude.ai/code**. Open it in Safari on your iPad and you have a full AI coding assistant that can connect to your remote machine.

This is complementary to the local LLM setup — use Claude Code when you have internet and need frontier-level AI, use local Ollama models when offline.

## 5. Security Hardening

### Disable Password SSH Authentication

```bash
# Edit SSH config on MacBook
sudo nano /etc/ssh/sshd_config

# Set these:
# PasswordAuthentication no
# PubkeyAuthentication yes
# ChallengeResponseAuthentication no
```

### Tailscale-Only Access

Since all services bind to `0.0.0.0`, they're technically accessible on any interface. To restrict to Tailscale only, bind services to your Tailscale IP:

```yaml
# code-server config — bind to Tailscale IP only
bind-addr: 100.64.0.1:8080
```

Or use macOS firewall to block non-Tailscale access to these ports.

### Tailscale ACLs

In the Tailscale admin console, you can set Access Control Lists to restrict which devices can reach which services. For a personal setup this is optional, but good practice.

## 6. Keeping MacBook Awake

For the MacBook to be accessible remotely, it needs to stay awake:

### Prevent Sleep When Lid is Closed (with Power)

```bash
# Install a tool to prevent sleep on lid close (when on power)
# Option 1: Amphetamine from the Mac App Store (free, GUI)
# Option 2: Use pmset
sudo pmset -c sleep 0          # Never sleep on power adapter
sudo pmset -c disablesleep 1   # Prevent sleep even with lid closed
```

### Wake on Network Access

```bash
# Enable Wake on LAN (works with Tailscale)
sudo pmset -a womp 1
```

**Note:** For truly reliable always-on access, keep the MacBook plugged in with the lid open (or use a clamshell setup with an external display). Lid-closed operation can be unreliable on some macOS versions.

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Can't reach MacBook from iPad | Check both devices are signed into Tailscale. Run `tailscale status` on MacBook. |
| code-server not loading | Check `launchctl list | grep code-server`. Check logs at `/tmp/code-server.log`. |
| SSH connection refused | Ensure Remote Login is enabled in System Settings. Check `sudo systemsetup -getremotelogin`. |
| mosh not connecting | Ensure mosh is installed on MacBook (`brew install mosh`). Mosh uses UDP ports 60000-61000. |
| Slow connection | Use mosh instead of SSH. For code-server, reduce VS Code extensions to essentials. |
| MacBook went to sleep | Check `pmset -g` settings. Use Amphetamine app for reliable sleep prevention. |
