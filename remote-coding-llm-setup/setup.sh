#!/bin/bash
# MacBook Air M3 (16GB) — Remote Coding & Offline LLM Setup
# One script. No prompts. Safe to re-run.
set -e

G='\033[0;32m' Y='\033[1;33m' R='\033[0;31m' N='\033[0m'
ok()   { echo -e "${G}[✓]${N} $1"; }
warn() { echo -e "${Y}[!]${N} $1"; }
err()  { echo -e "${R}[✗]${N} $1"; }
has()  { command -v "$1" &>/dev/null; }

echo ""
echo "══════════════════════════════════════════"
echo "  Remote Coding & Offline LLM Setup"
echo "  MacBook Air M3 · 16GB · 256GB"
echo "══════════════════════════════════════════"
echo ""

# ── Homebrew ──
if ! has brew; then
    warn "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
ok "Homebrew"

# ── Tailscale ──
if ! has tailscale; then
    warn "Installing Tailscale..."
    brew install --cask tailscale
    warn "Open Tailscale app and sign in"
fi
ok "Tailscale"

# ── code-server ──
if ! has code-server; then
    warn "Installing code-server..."
    brew install code-server
fi

mkdir -p ~/.config/code-server
if [ ! -f ~/.config/code-server/config.yaml ] || ! grep -q "0.0.0.0" ~/.config/code-server/config.yaml; then
    CS_PASSWORD=$(openssl rand -hex 12)
    cat > ~/.config/code-server/config.yaml << EOF
bind-addr: 0.0.0.0:8080
auth: password
password: ${CS_PASSWORD}
cert: false
EOF
    ok "code-server configured (password: ${CS_PASSWORD})"
    echo -e "  ${Y}Save this password — you need it to log in from iPad${N}"
else
    ok "code-server (already configured)"
fi

# ── Launchd: code-server ──
PLIST_DIR="$HOME/Library/LaunchAgents"
mkdir -p "$PLIST_DIR"

CS_PLIST="${PLIST_DIR}/com.coder.code-server.plist"
if [ ! -f "$CS_PLIST" ]; then
    cat > "$CS_PLIST" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
    <key>Label</key><string>com.coder.code-server</string>
    <key>ProgramArguments</key><array><string>/opt/homebrew/bin/code-server</string></array>
    <key>RunAtLoad</key><true/>
    <key>KeepAlive</key><true/>
    <key>StandardOutPath</key><string>/tmp/code-server.log</string>
    <key>StandardErrorPath</key><string>/tmp/code-server-error.log</string>
</dict></plist>
PLIST
    launchctl load "$CS_PLIST"
fi
ok "code-server auto-start"

# ── mosh ──
has mosh || brew install mosh
ok "mosh"

# ── SSH authorized_keys ──
mkdir -p ~/.ssh && chmod 700 ~/.ssh
[ -f ~/.ssh/authorized_keys ] || touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
ok "SSH ready"

# ── Ollama ──
if ! has ollama; then
    warn "Installing Ollama..."
    brew install ollama
fi

OLLAMA_PLIST="${PLIST_DIR}/com.ollama.serve.plist"
if [ ! -f "$OLLAMA_PLIST" ]; then
    cat > "$OLLAMA_PLIST" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
    <key>Label</key><string>com.ollama.serve</string>
    <key>ProgramArguments</key><array>
        <string>/opt/homebrew/bin/ollama</string><string>serve</string>
    </array>
    <key>EnvironmentVariables</key><dict>
        <key>OLLAMA_HOST</key><string>0.0.0.0</string>
    </dict>
    <key>RunAtLoad</key><true/>
    <key>KeepAlive</key><true/>
    <key>StandardOutPath</key><string>/tmp/ollama.log</string>
    <key>StandardErrorPath</key><string>/tmp/ollama-error.log</string>
</dict></plist>
PLIST
    launchctl load "$OLLAMA_PLIST"
fi
ok "Ollama auto-start (0.0.0.0:11434)"

# Wait for Ollama to be ready
for i in 1 2 3 4 5; do
    curl -s http://localhost:11434/api/tags &>/dev/null && break
    sleep 2
done

warn "Pulling models (first run downloads ~11 GB)..."
ollama pull qwen2.5:14b && ok "qwen2.5:14b" || err "Failed: qwen2.5:14b"
ollama pull phi3:mini && ok "phi3:mini" || err "Failed: phi3:mini"

# ── Python + Open Interpreter ──
has python3 || brew install python

VENV="$HOME/.venvs/open-interpreter"
if [ ! -d "$VENV" ]; then
    mkdir -p "$HOME/.venvs"
    python3 -m venv "$VENV"
fi
"$VENV/bin/pip" install --upgrade pip open-interpreter open-webui &>/dev/null
ok "Open Interpreter + Open WebUI"

# ── Shell aliases ──
SHELL_RC="$HOME/.zshrc"
add_line() {
    grep -qF "$1" "$SHELL_RC" 2>/dev/null || echo "$1" >> "$SHELL_RC"
}
add_line "# Remote Coding & Offline LLM"
add_line "alias oi='source $VENV/bin/activate && interpreter --model ollama/qwen2.5:14b'"
add_line "alias webui='source $VENV/bin/activate && open-webui serve'"
ok "Shell aliases: oi, webui"

# ── Launchd: Open WebUI ──
WEBUI_PLIST="${PLIST_DIR}/com.openwebui.serve.plist"
if [ ! -f "$WEBUI_PLIST" ]; then
    cat > "$WEBUI_PLIST" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
    <key>Label</key><string>com.openwebui.serve</string>
    <key>ProgramArguments</key><array>
        <string>${VENV}/bin/open-webui</string><string>serve</string>
    </array>
    <key>EnvironmentVariables</key><dict>
        <key>OLLAMA_BASE_URL</key><string>http://localhost:11434</string>
    </dict>
    <key>RunAtLoad</key><true/>
    <key>KeepAlive</key><true/>
    <key>StandardOutPath</key><string>/tmp/open-webui.log</string>
    <key>StandardErrorPath</key><string>/tmp/open-webui-error.log</string>
</dict></plist>
PLIST
    launchctl load "$WEBUI_PLIST"
fi
ok "Open WebUI auto-start (:3000)"

# ── Summary ──
echo ""
echo "══════════════════════════════════════════"
echo "  Done."
echo "══════════════════════════════════════════"
TS_IP=$(tailscale ip -4 2>/dev/null || echo "<sign into Tailscale first>")
CS_PW=$(grep password ~/.config/code-server/config.yaml 2>/dev/null | awk '{print $2}')
echo ""
echo "  Tailscale IP:      ${TS_IP}"
[ -n "$CS_PW" ] && echo "  code-server pass:  ${CS_PW}"
echo ""
echo "  From iPad:"
echo "    VS Code     http://${TS_IP}:8080"
echo "    AI Chat     http://${TS_IP}:3000"
echo "    SSH         ssh $(whoami)@${TS_IP}"
echo ""
echo "  From MacBook terminal:"
echo "    oi           → Open Interpreter (offline Claude Code)"
echo "    ollama run qwen2.5:14b → direct chat"
echo ""
echo "  iPad setup (manual, one-time):"
echo "    1. Tailscale app → sign in (same account)"
echo "    2. Blink Shell → generate key → copy pubkey to ~/.ssh/authorized_keys"
echo "    3. Safari → bookmark URLs above → Add to Home Screen"
echo ""
