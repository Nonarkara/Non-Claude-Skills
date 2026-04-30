#!/bin/bash
# =============================================================================
# Open Interpreter Setup for macOS
# Installs Open Interpreter with Ollama backend for offline AI agent usage.
# Like Claude Code but fully offline — runs code, analyzes data, writes reports.
# =============================================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }

echo ""
echo "================================================"
echo "  Open Interpreter Setup (Offline Claude Code)"
echo "================================================"
echo ""

# --- Python 3 ---
if ! command -v python3 &> /dev/null; then
    warn "Installing Python 3 via Homebrew..."
    brew install python
    info "Python 3 installed"
else
    info "Python 3 already installed ($(python3 --version))"
fi

# --- Virtual environment ---
VENV_DIR="$HOME/.venvs/open-interpreter"
if [ ! -d "$VENV_DIR" ]; then
    warn "Creating virtual environment at ${VENV_DIR}..."
    mkdir -p "$HOME/.venvs"
    python3 -m venv "$VENV_DIR"
    info "Virtual environment created"
else
    info "Virtual environment already exists"
fi

# --- Install Open Interpreter ---
source "$VENV_DIR/bin/activate"
warn "Installing Open Interpreter..."
pip install --upgrade pip > /dev/null 2>&1
pip install open-interpreter > /dev/null 2>&1
info "Open Interpreter installed"

# --- Shell alias ---
SHELL_RC="$HOME/.zshrc"
if [ -f "$HOME/.bashrc" ] && [ ! -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.bashrc"
fi

ALIAS_LINE="alias oi='source $VENV_DIR/bin/activate && interpreter --model ollama/qwen2.5:14b'"
if ! grep -q "alias oi=" "$SHELL_RC" 2>/dev/null; then
    echo "" >> "$SHELL_RC"
    echo "# Open Interpreter — offline AI agent (like Claude Code)" >> "$SHELL_RC"
    echo "$ALIAS_LINE" >> "$SHELL_RC"
    info "Added 'oi' alias to ${SHELL_RC}"
else
    info "'oi' alias already exists in ${SHELL_RC}"
fi

# --- Verify Ollama is running ---
if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
    info "Ollama is running"
else
    warn "Ollama is not running. Start it with: ollama serve"
fi

# --- Summary ---
echo ""
echo "================================================"
echo "  Open Interpreter Ready!"
echo "================================================"
echo ""
echo "  Quick start (after restarting terminal or running: source ${SHELL_RC}):"
echo ""
echo "    oi                          # Start interactive session"
echo ""
echo "  Or run directly:"
echo ""
echo "    source $VENV_DIR/bin/activate"
echo "    interpreter --model ollama/qwen2.5:14b"
echo ""
echo "  Example prompts:"
echo "    > Read app.py and find bugs"
echo "    > Load data.csv and plot monthly trends"
echo "    > Write a summary report of all .txt files in ./docs/"
echo "    > Resize all images in ./photos/ to 800px wide"
echo ""
