# Offline LLM Guide

Complete setup for running local AI models on your MacBook Air M3 for chat, coding, and file processing — no internet required.

## Architecture

```
MacBook Air M3 (8GB, 256GB SSD)
├── Ollama (model runtime, Metal GPU acceleration)
│   ├── qwen2.5-coder:7b    (coding)
│   └── phi3:mini            (fast chat)
├── Open WebUI (ChatGPT-like browser interface)
│   └── http://localhost:3000
└── Continue.dev (VS Code extension for AI coding)
    └── Connects to Ollama API at localhost:11434
```

## 1. Ollama

Ollama is the simplest way to run LLMs locally. One command to install, one command to run a model. M3 Metal acceleration works automatically.

### Install

```bash
# Via Homebrew (recommended)
brew install ollama

# Verify
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
# Best coding model at 7B size — ideal for M3 8GB
ollama pull qwen2.5-coder:7b

# Fast lightweight model for quick questions
ollama pull phi3:mini

# Optional: good general-purpose model
ollama pull llama3.1:8b
```

### Model Selection Guide

**For 8GB M3 MacBook Air — pick 2-3 to stay within disk budget:**

| Model | Best For | Disk | RAM | Speed | Quality |
|-------|----------|------|-----|-------|---------|
| `qwen2.5-coder:7b` | Code generation, debugging, refactoring | 4.4 GB | ~5 GB | ~20 tok/s | Excellent for coding |
| `phi3:mini` | Quick chat, summaries, Q&A | 2.3 GB | ~3 GB | ~35 tok/s | Good, very fast |
| `llama3.1:8b` | General conversation, analysis | 4.7 GB | ~5 GB | ~20 tok/s | Best general 8B |
| `qwen2.5:7b` | All-purpose (chat + some code) | 4.4 GB | ~5 GB | ~20 tok/s | Good all-rounder |
| `gemma2:2b` | Ultra-light, basic tasks | 1.6 GB | ~2 GB | ~45 tok/s | Basic but very fast |

**Recommended combo:** `qwen2.5-coder:7b` + `phi3:mini` = **6.7 GB disk**

**Why not bigger models?** 14B+ models require more RAM than you have. They'll work but swap heavily, making them painfully slow. Stick to 7B and below for a smooth experience on 8GB.

### Memory Management

Ollama is smart about memory:
- Only **one model loads at a time** (by default)
- Models **auto-unload after 5 minutes** of inactivity
- You can adjust: `OLLAMA_KEEP_ALIVE=10m` (keep loaded for 10 minutes)
- To free memory immediately: `ollama stop <model>`

### Using Ollama from CLI

```bash
# Interactive chat
ollama run qwen2.5-coder:7b

# One-shot question
echo "Explain async/await in JavaScript" | ollama run phi3:mini

# Process a file
cat myfile.py | ollama run qwen2.5-coder:7b "Review this code for bugs"

# Generate code
ollama run qwen2.5-coder:7b "Write a Python function to parse CSV files"
```

### Ollama API

Ollama exposes a REST API at `http://localhost:11434` — compatible with many tools:

```bash
# Chat completion
curl http://localhost:11434/api/chat -d '{
  "model": "qwen2.5-coder:7b",
  "messages": [{"role": "user", "content": "Hello!"}]
}'

# Generate
curl http://localhost:11434/api/generate -d '{
  "model": "phi3:mini",
  "prompt": "Why is the sky blue?"
}'
```

## 2. Open WebUI (ChatGPT-like Interface)

Open WebUI gives you a beautiful, full-featured chat interface for your local models — conversation history, multiple chats, file uploads, and more.

### Install via Docker

```bash
# Install Docker Desktop first (if not installed)
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

Save the `templates/docker-compose.yml` file and run:

```bash
cd templates/
docker compose up -d
```

### Access

- **Locally:** `http://localhost:3000`
- **From iPad (via Tailscale):** `http://<tailscale-ip>:3000`

First visit: Create an admin account (local only, no external service).

### Features

- Multiple conversation threads with history
- Switch between Ollama models in the UI
- Upload files for analysis (PDFs, images, code files)
- System prompts and model presets
- Search through conversation history
- Markdown rendering with code highlighting

### Alternative: No Docker

If you don't want Docker, you can use **Ollama's built-in chat** via the CLI, or try:
- **Enchanted** (free Mac App Store app for Ollama) — native macOS chat interface
- **Msty** (free desktop app) — clean chat UI for local models

## 3. Continue.dev (AI Coding in VS Code)

Continue is a VS Code extension that connects to your local Ollama models for inline code assistance — tab completion, chat, and code actions.

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
      "title": "Qwen 2.5 Coder 7B",
      "provider": "ollama",
      "model": "qwen2.5-coder:7b",
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
    "title": "Qwen Coder (Autocomplete)",
    "provider": "ollama",
    "model": "qwen2.5-coder:7b",
    "apiBase": "http://localhost:11434"
  }
}
```

### Usage

- **Chat**: Open the Continue sidebar (Cmd+L) to ask coding questions
- **Tab completion**: Start typing and Continue suggests completions
- **Inline edit**: Select code, press Cmd+I, describe the change
- **Explain code**: Select code, right-click > Continue > Explain

## 4. Running Ollama as a Service

To make Ollama start automatically and be accessible from the network (for Open WebUI and iPad):

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

**Note:** Setting `OLLAMA_HOST=0.0.0.0` makes Ollama accessible on all interfaces (needed for Docker and Tailscale access). This is safe behind Tailscale.

### If Using Ollama.app Instead of Homebrew

If you installed Ollama via the macOS app (ollama.com), it already runs as a service. To make it listen on all interfaces:

```bash
launchctl setenv OLLAMA_HOST "0.0.0.0"
# Then restart Ollama.app
```

## 5. Performance Tuning for M3 8GB

### Quantization

All Ollama models default to Q4_K_M quantization — the sweet spot for quality vs. size on Apple Silicon. No need to change this.

### Context Window

Larger context windows use more RAM. For 8GB:
- Default context (2048 tokens) works fine
- Up to 4096 tokens is comfortable
- 8192+ tokens will cause slowdowns due to memory pressure

```bash
# Set context window per request
ollama run qwen2.5-coder:7b --num-ctx 4096
```

### Monitor Performance

```bash
# Check memory usage
memory_pressure

# Watch Ollama resource usage
top -pid $(pgrep ollama)

# Check which model is loaded
curl http://localhost:11434/api/tags
```

### Disk Space Management

```bash
# See all downloaded models and their sizes
ollama list

# Remove a model you're not using
ollama rm llama3.1:8b

# Models are stored at ~/.ollama/models/
du -sh ~/.ollama/models/
```

## 6. Offline Workflow Examples

### Chat (No Internet)

```bash
# Quick question from terminal
ollama run phi3:mini "Summarize the key points of the GDPR"

# Or use Open WebUI in browser for a ChatGPT-like experience
# http://localhost:3000
```

### Code Review

```bash
# Review a file
cat app.py | ollama run qwen2.5-coder:7b "Review this code. Focus on bugs, security issues, and performance."
```

### Process Documents

```bash
# Summarize a text file
cat report.txt | ollama run phi3:mini "Summarize this document in 5 bullet points"

# Extract key information
cat meeting-notes.txt | ollama run phi3:mini "Extract all action items from these meeting notes"
```

### Generate Code

```bash
# Generate from description
ollama run qwen2.5-coder:7b "Write a Python FastAPI endpoint that accepts a CSV file upload and returns JSON"

# Fix/improve existing code
cat broken.py | ollama run qwen2.5-coder:7b "Fix the bugs in this code and explain what was wrong"
```

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Model too slow | Use a smaller model (`phi3:mini`). Close memory-hungry apps. Check `memory_pressure`. |
| "Out of memory" | Only load one model at a time. Reduce context window. Use Q4 quantization (default). |
| Ollama not responding | Check `ollama serve` is running. Check logs at `/tmp/ollama.log`. |
| Open WebUI can't find Ollama | Ensure `OLLAMA_HOST=0.0.0.0`. Use `host.docker.internal` not `localhost` in Docker. |
| Continue.dev not connecting | Verify Ollama is running: `curl http://localhost:11434/api/tags`. Check Continue config. |
| Model quality too low | 7B models have limits. For complex tasks, use Claude Code (online) instead. |
| Disk space low | Run `ollama list` to see models. Remove unused ones with `ollama rm <model>`. |
