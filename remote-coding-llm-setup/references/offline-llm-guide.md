# Offline LLM Guide

Complete setup for running local AI models on your MacBook Air M3 (16GB) for chat, coding, data analysis, and report writing — no internet required.

## Architecture

```
MacBook Air M3 (16GB, 256GB SSD)
├── Ollama (model runtime, Metal GPU acceleration)
│   ├── qwen2.5:14b         (all-purpose: code, analysis, writing)
│   └── phi3:mini            (fast chat)
├── Open WebUI (ChatGPT-like browser interface)
│   └── http://localhost:3000
├── Open Interpreter (offline Claude Code — runs code, analyzes data, writes reports)
│   └── interpreter --model ollama/qwen2.5:14b
└── Continue.dev (VS Code extension for AI coding)
    └── Connects to Ollama API at localhost:11434
```

## 1. Ollama

Ollama is the simplest way to run LLMs locally. One command to install, one command to run a model. M3 Metal acceleration works automatically.

### Install

```bash
brew install ollama

ollama --version
```

### Start Ollama

```bash
# Start the server (runs in background)
ollama serve

# Or just run a model — it auto-starts the server
ollama run phi3:mini
```

### Pull Recommended Models

```bash
# Best all-purpose model for 16GB — coding, analysis, writing
ollama pull qwen2.5:14b

# Fast lightweight model for quick questions
ollama pull phi3:mini
```

### Model Selection Guide

**For 16GB M3 MacBook Air — 14B models run comfortably:**

| Model | Best For | Disk | RAM | Speed | Quality |
|-------|----------|------|-----|-------|---------|
| `qwen2.5:14b` | All-purpose: code, analysis, writing, chat | 9 GB | ~10 GB | ~15 tok/s | Excellent |
| `qwen2.5-coder:14b` | Dedicated coding, debugging, refactoring | 9 GB | ~10 GB | ~15 tok/s | Best coding at size |
| `phi3:mini` | Quick chat, summaries, Q&A | 2.3 GB | ~3 GB | ~35 tok/s | Good, very fast |
| `qwen2.5-coder:7b` | Lightweight coding tasks | 4.4 GB | ~5 GB | ~25 tok/s | Good for coding |
| `llama3.1:8b` | General conversation, analysis | 4.7 GB | ~5 GB | ~25 tok/s | Good general 8B |
| `gemma2:2b` | Ultra-light, basic tasks | 1.6 GB | ~2 GB | ~45 tok/s | Basic but very fast |

**Recommended combo:** `qwen2.5:14b` + `phi3:mini` = **~11 GB disk**

**Why 14B is the sweet spot for 16GB:** 14B models fit comfortably in 16GB unified memory with room for the OS and other apps. 32B+ models would require heavy swapping and become painfully slow.

### Memory Management

Ollama is smart about memory:
- Only **one model loads at a time** (by default)
- Models **auto-unload after 5 minutes** of inactivity
- You can adjust: `OLLAMA_KEEP_ALIVE=10m` (keep loaded for 10 minutes)
- To free memory immediately: `ollama stop <model>`

### Using Ollama from CLI

```bash
# Interactive chat
ollama run qwen2.5:14b

# One-shot question
echo "Explain async/await in JavaScript" | ollama run phi3:mini

# Process a file
cat myfile.py | ollama run qwen2.5:14b "Review this code for bugs"

# Generate code
ollama run qwen2.5:14b "Write a Python function to parse CSV files"
```

### Ollama API

Ollama exposes a REST API at `http://localhost:11434`:

```bash
curl http://localhost:11434/api/chat -d '{
  "model": "qwen2.5:14b",
  "messages": [{"role": "user", "content": "Hello!"}]
}'
```

## 2. Open Interpreter (Offline Claude Code)

Open Interpreter is the closest thing to Claude Code that runs fully offline. It's a terminal-based AI agent that can:
- **Execute Python/shell code** to solve problems
- **Analyze data** — feed it CSVs, it writes and runs pandas/matplotlib code
- **Write reports** — generates markdown or text files with analysis results
- **Debug code** — reads your files, finds bugs, suggests and applies fixes
- **Process files** — batch rename, convert, extract info from documents

### Install

```bash
python3 -m venv ~/.venvs/open-interpreter
source ~/.venvs/open-interpreter/bin/activate
pip install open-interpreter
```

### Configure for Ollama

```bash
# Run with your local Ollama model
interpreter --model ollama/qwen2.5:14b

# Or set it as default in your shell profile (~/.zshrc):
alias oi='interpreter --model ollama/qwen2.5:14b'
```

### Usage Examples

#### Debug Code
```bash
oi
# Then type:
> Read app.py and find any bugs. Fix them and explain what was wrong.
```

#### Analyze Data
```bash
oi
# Then type:
> Load sales_data.csv, show me summary statistics, plot monthly revenue trends, and save the chart as revenue.png
```
Open Interpreter will write and execute Python (pandas + matplotlib) to analyze your data and create charts — all locally.

#### Write Reports
```bash
oi
# Then type:
> Read all the CSV files in ./data/, analyze the key trends, and write a summary report to report.md with charts
```

#### Process Files
```bash
oi
# Then type:
> Find all .jpg files in ~/Photos, resize them to 800px wide, and save to ./resized/
```

### Tips for Open Interpreter

- **Auto-approve mode**: `interpreter --auto_run --model ollama/qwen2.5:14b` skips confirmation prompts (use with caution)
- **Safe mode**: By default, it asks before executing each code block — good for learning
- **Context**: It can read files you reference, but keep prompts focused for best results with 14B models
- **Speed**: First response takes a moment as the model loads; subsequent responses are faster

### Open Interpreter vs Claude Code

| | Open Interpreter (offline) | Claude Code (online) |
|--|---------------------------|---------------------|
| Model quality | Good (14B local) | Frontier (Claude Opus/Sonnet) |
| Internet | Not needed | Required |
| Cost | Free | API credits |
| Data privacy | 100% local | Sent to Anthropic |
| Speed | ~15 tok/s | ~80 tok/s |
| Best for | Quick tasks, data analysis, privacy-sensitive work | Complex coding, large refactors, hard problems |

**Use Open Interpreter for:** everyday tasks, quick data analysis, file processing, working offline, privacy-sensitive code.
**Use Claude Code for:** complex multi-file refactors, hard debugging, tasks requiring frontier intelligence.

## 3. Open WebUI (ChatGPT-like Interface)

Open WebUI gives you a beautiful chat interface for your local models — conversation history, multiple chats, file uploads.

### Install via Docker

```bash
brew install --cask docker

# Start Docker Desktop, then:
docker run -d \
  --name open-webui \
  -p 3000:8080 \
  -v open-webui:/app/backend/data \
  --add-host=host.docker.internal:host-gateway \
  -e OLLAMA_BASE_URL=http://host.docker.internal:11434 \
  --restart always \
  ghcr.io/open-webui/open-webui:main
```

### Or Use Docker Compose

```bash
cd templates/
docker compose up -d
```

### Access

- **Locally:** `http://localhost:3000`
- **From iPad (via Tailscale):** `http://<tailscale-ip>:3000`

First visit: Create an admin account (local only, no external service).

### Alternative: No Docker

If you don't want Docker:
- **Enchanted** (free Mac App Store app for Ollama) — native macOS chat interface
- **Msty** (free desktop app) — clean chat UI for local models

## 4. Continue.dev (AI Coding in VS Code)

Continue is a VS Code extension that connects to your local Ollama models for inline code assistance.

### Install in code-server

1. Open code-server in your browser
2. Go to Extensions (Cmd+Shift+X)
3. Search for "Continue" and install it

### Configure

Continue's config lives at `~/.continue/config.json`:

```json
{
  "models": [
    {
      "title": "Qwen 2.5 14B",
      "provider": "ollama",
      "model": "qwen2.5:14b",
      "apiBase": "http://localhost:11434"
    },
    {
      "title": "Phi-3 Mini (Fast)",
      "provider": "ollama",
      "model": "phi3:mini",
      "apiBase": "http://localhost:11434"
    }
  ],
  "tabAutocompleteModel": {
    "title": "Qwen 2.5 14B (Autocomplete)",
    "provider": "ollama",
    "model": "qwen2.5:14b",
    "apiBase": "http://localhost:11434"
  }
}
```

### Usage

- **Chat**: Open the Continue sidebar (Cmd+L) to ask coding questions
- **Tab completion**: Start typing and Continue suggests completions
- **Inline edit**: Select code, press Cmd+I, describe the change
- **Explain code**: Select code, right-click > Continue > Explain

## 5. Running Ollama as a Service

### Auto-Start via launchd

```bash
mkdir -p ~/Library/LaunchAgents

cat > ~/Library/LaunchAgents/com.ollama.serve.plist << 'EOF'
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

launchctl load ~/Library/LaunchAgents/com.ollama.serve.plist
```

**Note:** `OLLAMA_HOST=0.0.0.0` makes Ollama accessible on all interfaces (needed for Docker and Tailscale). Safe behind Tailscale.

### If Using Ollama.app Instead of Homebrew

```bash
launchctl setenv OLLAMA_HOST "0.0.0.0"
# Then restart Ollama.app
```

## 6. Performance Tuning for M3 16GB

### Quantization

All Ollama models default to Q4_K_M quantization — the sweet spot for quality vs. size on Apple Silicon.

### Context Window

With 16GB, you have more headroom:
- Default context (2048 tokens) works fine
- Up to 8192 tokens is comfortable for 14B models
- 16384 tokens is possible but may slow down

```bash
ollama run qwen2.5:14b --num-ctx 8192
```

### Monitor Performance

```bash
memory_pressure
top -pid $(pgrep ollama)
curl http://localhost:11434/api/tags
```

### Disk Space Management

```bash
ollama list
ollama rm <unused-model>
du -sh ~/.ollama/models/
```

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Model too slow | Use a smaller model (`phi3:mini`). Close memory-hungry apps. Check `memory_pressure`. |
| Ollama not responding | Check `ollama serve` is running. Check logs at `/tmp/ollama.log`. |
| Open WebUI can't find Ollama | Ensure `OLLAMA_HOST=0.0.0.0`. Use `host.docker.internal` not `localhost` in Docker. |
| Continue.dev not connecting | Verify Ollama is running: `curl http://localhost:11434/api/tags`. Check Continue config. |
| Open Interpreter errors | Ensure Ollama is running. Try `interpreter --model ollama/phi3:mini` for a lighter model. |
| Model quality too low | 14B models have limits. For complex tasks, use Claude Code (online) instead. |
| Disk space low | Run `ollama list` to see models. Remove unused ones with `ollama rm <model>`. |
