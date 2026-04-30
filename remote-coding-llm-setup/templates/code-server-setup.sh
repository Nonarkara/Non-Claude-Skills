#!/bin/bash
# =============================================================================
# code-server Setup for macOS
# Installs code-server and configures it to start on boot via launchd.
# =============================================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }

# Install
if ! command -v code-server &> /dev/null; then
    warn "Installing code-server via Homebrew..."
    brew install code-server
    info "code-server installed"
else
    info "code-server already installed"
fi

# Configure
mkdir -p ~/.config/code-server
CS_PASSWORD=$(openssl rand -hex 12)

cat > ~/.config/code-server/config.yaml << EOF
bind-addr: 0.0.0.0:8080
auth: password
password: ${CS_PASSWORD}
cert: false
EOF
info "Configured code-server (bound to 0.0.0.0:8080)"

# launchd plist
PLIST_DIR="$HOME/Library/LaunchAgents"
CS_PLIST="${PLIST_DIR}/com.coder.code-server.plist"
mkdir -p "$PLIST_DIR"

launchctl unload "$CS_PLIST" 2>/dev/null || true

cat > "$CS_PLIST" << 'EOF'
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

launchctl load "$CS_PLIST"
info "code-server started and set to launch on boot"

echo ""
echo "  Access: http://localhost:8080"
echo "  Password: ${CS_PASSWORD}"
echo ""
echo "  From iPad (via Tailscale): http://<tailscale-ip>:8080"
echo "  Tip: Add to Home Screen in Safari for full-screen PWA mode"
echo ""
