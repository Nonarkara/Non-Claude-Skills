#!/bin/bash
# =============================================================================
# MacBook Air M3 — Complete Remote Coding & Offline LLM Setup
# Run this on your MacBook to set up everything at once.
# Optimized for 16GB unified memory / 256GB SSD.
# =============================================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
err()   { echo -e "${RED}[✗]${NC} $1"; }

echo ""
echo "================================================"
echo "  Remote Coding & Offline LLM Setup for macOS"
echo "  Optimized for MacBook Air M3 (16GB / 256GB)"
echo "================================================"
echo ""

# --- Homebrew ---
if ! command -v brew &> /dev/null; then
    warn "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    info "Homebrew installed"
else
    info "Homebrew already installed"
fi

# --- Tailscale ---
if ! command -v tailscale &> /dev/null; then
    warn "Installing Tailscale..."
    brew install --cask tailscale
    info "Tailscale installed — open the app and sign in"
else
    info "Tailscale already installed"
fi

# --- code-server ---
if ! command -v code-server &> /dev/null; then
    warn "Installing code-server..."
    brew install code-server
    info "code-server installed"
else
    info "code-server already installed"
fi

# Configure code-server
mkdir -p ~/.config/code-server
if [ ! -f ~/.config/code-server/config.yaml ] || ! grep -q "0.0.0.0" ~/.config/code-server/config.yaml; then
    warn "Configuring code-server..."
    CS_PASSWORD=$(openssl rand -hex 12)
    cat > ~/.config/code-server/config.yaml << EOF
bind-addr: 0.0.0.0:8080
auth: password
password: ${CS_PASSWORD}
cert: false
EOF
    info "code-server configured (password: ${CS_PASSWORD})"
    warn "Save this password! You'll need it to access VS Code from iPad."
else
    info "code-server already configured"
fi

# code-server launchd
PLIST_DIR="$HOME/Library/LaunchAgents"
CS_PLIST="${PLIST_DIR}/com.coder.code-server.plist"
mkdir -p "$PLIST_DIR"
if [ ! -f "$CS_PLIST" ]; then
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
    info "code-server set to start on boot"
else
    info "code-server launchd plist already exists"
fi

# --- mosh ---
if ! command -v mosh &> /dev/null; then
    warn "Installing mosh (better SSH for mobile)..."
    brew install mosh
    info "mosh installed"
else
    info "mosh already installed"
fi

# --- SSH key auth ---
if [ ! -f ~/.ssh/authorized_keys ]; then
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    touch ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
    warn "Created ~/.ssh/authorized_keys — paste your iPad's public key there"
else
    info "SSH authorized_keys exists"
fi

# --- Ollama ---
if ! command -v ollama &> /dev/null; then
    warn "Installing Ollama..."
    brew install ollama
    info "Ollama installed"
else
    info "Ollama already installed"
fi

# Ollama launchd (with network binding)
OLLAMA_PLIST="${PLIST_DIR}/com.ollama.serve.plist"
if [ ! -f "$OLLAMA_PLIST" ]; then
    cat > "$OLLAMA_PLIST" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.ollama.serve</string>
    <key>ProgramArguments</key>
    <array>
        <string>/opt/homebrew/bin/ollama</string>
        <string>serve</string>
    </array>
    <key>EnvironmentVariables</key>
    <dict>
        <key>OLLAMA_HOST</key>
        <string>0.0.0.0</string>
    </dict>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/ollama.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/ollama-error.log</string>
</dict>
</plist>
EOF
    launchctl load "$OLLAMA_PLIST"
    info "Ollama set to start on boot (listening on 0.0.0.0:11434)"
else
    info "Ollama launchd plist already exists"
fi

# Pull recommended models for 16GB
echo ""
warn "Pulling recommended models (this may take a while on first run)..."
ollama pull qwen2.5:14b && info "qwen2.5:14b pulled" || err "Failed to pull qwen2.5:14b"
ollama pull phi3:mini && info "phi3:mini pulled" || err "Failed to pull phi3:mini"

# --- Open Interpreter ---
echo ""
warn "Setting up Open Interpreter (offline Claude Code)..."
if ! command -v python3 &> /dev/null; then
    brew install python
fi

VENV_DIR="$HOME/.venvs/open-interpreter"
if [ ! -d "$VENV_DIR" ]; then
    mkdir -p "$HOME/.venvs"
    python3 -m venv "$VENV_DIR"
fi

source "$VENV_DIR/bin/activate"
pip install --upgrade pip > /dev/null 2>&1
pip install open-interpreter > /dev/null 2>&1
deactivate
info "Open Interpreter installed"

SHELL_RC="$HOME/.zshrc"
ALIAS_LINE="alias oi='source $VENV_DIR/bin/activate && interpreter --model ollama/qwen2.5:14b'"
if ! grep -q "alias oi=" "$SHELL_RC" 2>/dev/null; then
    echo "" >> "$SHELL_RC"
    echo "# Open Interpreter — offline AI agent (like Claude Code)" >> "$SHELL_RC"
    echo "$ALIAS_LINE" >> "$SHELL_RC"
    info "Added 'oi' alias to ~/.zshrc"
fi

# --- Docker + Open WebUI (optional) ---
echo ""
read -p "Install Docker Desktop + Open WebUI? (ChatGPT-like interface) [y/N] " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if ! command -v docker &> /dev/null; then
        warn "Installing Docker Desktop..."
        brew install --cask docker
        info "Docker Desktop installed — open the app to finish setup"
        warn "After Docker Desktop is running, re-run this script or run:"
        echo "  docker run -d --name open-webui -p 3000:8080 -v open-webui:/app/backend/data --add-host=host.docker.internal:host-gateway -e OLLAMA_BASE_URL=http://host.docker.internal:11434 --restart always ghcr.io/open-webui/open-webui:main"
    else
        info "Docker already installed"
        warn "Starting Open WebUI..."
        docker run -d \
            --name open-webui \
            -p 3000:8080 \
            -v open-webui:/app/backend/data \
            --add-host=host.docker.internal:host-gateway \
            -e OLLAMA_BASE_URL=http://host.docker.internal:11434 \
            --restart always \
            ghcr.io/open-webui/open-webui:main \
            && info "Open WebUI running at http://localhost:3000" \
            || warn "Open WebUI may already be running"
    fi
else
    info "Skipping Docker + Open WebUI"
fi

# --- Summary ---
echo ""
echo "================================================"
echo "  Setup Complete!"
echo "================================================"
echo ""
TAILSCALE_IP=$(tailscale ip -4 2>/dev/null || echo "<run 'tailscale ip -4' after signing in>")
echo "  Tailscale IP:  ${TAILSCALE_IP}"
echo ""
echo "  From your iPad (after Tailscale is connected):"
echo "  ─────────────────────────────────────────────"
echo "  VS Code:    http://${TAILSCALE_IP}:8080"
echo "  Open WebUI: http://${TAILSCALE_IP}:3000"
echo "  SSH:        ssh $(whoami)@${TAILSCALE_IP}"
echo "  mosh:       mosh $(whoami)@${TAILSCALE_IP}"
echo ""
echo "  Offline AI (on MacBook terminal):"
echo "  ─────────────────────────────────"
echo "  oi                                    # Open Interpreter (like Claude Code)"
echo "  ollama run qwen2.5:14b                # Direct chat with model"
echo ""
echo "  iPad setup:"
echo "  1. Install Tailscale from App Store, sign in"
echo "  2. Install Blink Shell from App Store"
echo "  3. In Safari, bookmark the URLs above"
echo "  4. Add code-server to Home Screen for PWA mode"
echo ""
CS_PW=$(grep password ~/.config/code-server/config.yaml 2>/dev/null | awk '{print $2}')
if [ -n "$CS_PW" ]; then
    echo "  code-server password: ${CS_PW}"
fi
echo ""
