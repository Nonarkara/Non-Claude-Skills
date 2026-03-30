#!/bin/bash
# =============================================================================
# Ollama + Recommended Models for M3 MacBook Air (8GB / 256GB)
# Installs Ollama and pulls models optimized for this hardware.
# =============================================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info() { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; }

# Install Ollama
if ! command -v ollama &> /dev/null; then
    warn "Installing Ollama via Homebrew..."
    brew install ollama
    info "Ollama installed"
else
    info "Ollama already installed ($(ollama --version))"
fi

# Ensure Ollama is running
if ! curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
    warn "Starting Ollama server..."
    ollama serve &
    sleep 2
fi

# Pull recommended models
echo ""
echo "Pulling recommended models for M3 8GB..."
echo "  qwen2.5-coder:7b  (~4.4 GB)  — coding"
echo "  phi3:mini          (~2.3 GB)  — fast chat"
echo "  Total: ~6.7 GB"
echo ""

ollama pull qwen2.5-coder:7b && info "qwen2.5-coder:7b ready" || err "Failed to pull qwen2.5-coder:7b"
ollama pull phi3:mini && info "phi3:mini ready" || err "Failed to pull phi3:mini"

# Configure Ollama to listen on all interfaces (for Tailscale + Open WebUI)
PLIST_DIR="$HOME/Library/LaunchAgents"
OLLAMA_PLIST="${PLIST_DIR}/com.ollama.serve.plist"
mkdir -p "$PLIST_DIR"

if [ ! -f "$OLLAMA_PLIST" ]; then
    warn "Setting up Ollama to start on boot (listening on 0.0.0.0)..."

    # Stop the background serve we started
    pkill -f "ollama serve" 2>/dev/null || true

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
    info "Ollama service configured (auto-start, network accessible)"
else
    info "Ollama launchd plist already exists"
fi

# Summary
echo ""
echo "================================================"
echo "  Ollama Setup Complete"
echo "================================================"
echo ""
echo "  Installed models:"
ollama list 2>/dev/null || echo "  (run 'ollama list' to see models)"
echo ""
echo "  Usage:"
echo "    ollama run qwen2.5-coder:7b     # Coding tasks"
echo "    ollama run phi3:mini             # Quick chat"
echo ""
echo "  API: http://localhost:11434"
echo "  From iPad: http://<tailscale-ip>:11434"
echo ""
echo "  Optional extra models (if you have disk space):"
echo "    ollama pull llama3.1:8b          # General purpose (+4.7 GB)"
echo "    ollama pull gemma2:2b            # Ultra-light (+1.6 GB)"
echo ""
