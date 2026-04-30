# Setup Guide

Complete reference for the iPad + MacBook remote coding and offline LLM system.

## 1. Tailscale (Networking)

Tailscale creates a private WireGuard mesh between your devices. No port forwarding, no firewall rules.

**MacBook:** `brew install --cask tailscale` → open app → sign in
**iPad:** App Store → Tailscale → sign in with same account

```bash
tailscale ip -4          # Your Tailscale IP (100.x.x.x)
tailscale status         # See connected devices
```

**MagicDNS:** Enable at https://login.tailscale.com/admin/dns for friendly hostnames (`macbook-air` instead of `100.x.x.x`).

## 2. code-server (VS Code in Browser)

```bash
brew install code-server
```

Config at `~/.config/code-server/config.yaml`:
```yaml
bind-addr: 0.0.0.0:8080
auth: password
password: <generated-by-setup-script>
cert: false
```

Bind to `0.0.0.0` so iPad can reach it via Tailscale. Safe — Tailscale encrypts everything and only your devices connect.

**Auto-start:** The setup script creates a launchd plist at `~/Library/LaunchAgents/com.coder.code-server.plist`.

**iPad:** Open `http://<tailscale-ip>:8080` in Safari → Share → Add to Home Screen for full-screen PWA mode.

**Tips:** Use Magic Keyboard. Use Split View (Safari + Blink side by side). Adjust font size in VS Code settings.

## 3. SSH + Blink Shell

**MacBook:** System Settings → General → Sharing → Enable Remote Login. Install mosh: `brew install mosh`.

**iPad (Blink Shell):**
1. Config → Keys → Generate a key
2. Copy public key → paste into MacBook's `~/.ssh/authorized_keys`
3. Config → Hosts → add: hostname=`<tailscale-ip>`, user=`<your-username>`, mosh=on
4. Type `macbook` to connect

**Harden SSH** (optional):
```bash
# /etc/ssh/sshd_config
PasswordAuthentication no
PubkeyAuthentication yes
```

## 4. Ollama (Local LLM Runtime)

```bash
brew install ollama
ollama pull qwen2.5:14b      # All-purpose: code, analysis, writing (9 GB)
ollama pull phi3:mini          # Fast chat (2.3 GB)
```

**Auto-start:** The setup script creates a launchd plist with `OLLAMA_HOST=0.0.0.0` so Open WebUI and iPad can reach it.

### Model Guide (16GB M3)

| Model | Best for | Disk | Speed |
|-------|----------|------|-------|
| `qwen2.5:14b` | Everything | 9 GB | ~15 tok/s |
| `qwen2.5-coder:14b` | Dedicated coding | 9 GB | ~15 tok/s |
| `phi3:mini` | Quick chat | 2.3 GB | ~35 tok/s |
| `gemma2:2b` | Ultra-light | 1.6 GB | ~45 tok/s |

14B is the sweet spot for 16GB. 32B+ models swap to disk and become unusable. One model loads at a time; auto-unloads after 5 min.

### CLI Usage

```bash
ollama run qwen2.5:14b                                    # Chat
echo "explain this" | ollama run phi3:mini                 # One-shot
cat app.py | ollama run qwen2.5:14b "find bugs"           # File review
ollama run qwen2.5:14b --num-ctx 8192                     # Bigger context
```

### Disk management

```bash
ollama list                  # See models + sizes
ollama rm <model>            # Delete a model
du -sh ~/.ollama/models/     # Total disk usage
```

## 5. Open Interpreter (Offline Claude Code)

Terminal AI agent that executes code, analyzes data, writes reports — all locally.

```bash
oi                           # Alias created by setup script
```

### Examples

```
> Load sales.csv, plot monthly trends, save as chart.png
> Read app.py, find bugs, fix them
> Summarize all PDFs in ./docs/ into report.md
> Resize all images in ./photos/ to 800px wide
```

**Auto-run mode:** `interpreter --auto_run --model ollama/qwen2.5:14b` (skips confirmation — use carefully).

### When to use what

| Task | Tool |
|------|------|
| Quick data analysis, file processing, offline work | Open Interpreter (`oi`) |
| Complex multi-file refactors, hard debugging | Claude Code (`claude.ai/code`) |
| Inline code completion in VS Code | Continue.dev |
| Casual chat, Q&A | Open WebUI or `ollama run` |

## 6. Open WebUI (Chat Interface)

Installed via pip (no Docker needed):

```bash
open-webui serve             # Starts at http://localhost:3000
```

**Auto-start:** The setup script creates a launchd plist.

Access from iPad: `http://<tailscale-ip>:3000`. First visit creates a local admin account.

Features: conversation history, multiple chats, file uploads, model switching, markdown rendering.

## 7. Continue.dev (AI in VS Code)

Install the Continue extension in code-server. Config at `~/.continue/config.json`:

```json
{
  "models": [
    {
      "title": "Qwen 2.5 14B",
      "provider": "ollama",
      "model": "qwen2.5:14b",
      "apiBase": "http://localhost:11434"
    }
  ],
  "tabAutocompleteModel": {
    "title": "Qwen Autocomplete",
    "provider": "ollama",
    "model": "qwen2.5:14b",
    "apiBase": "http://localhost:11434"
  }
}
```

Cmd+L = chat. Cmd+I = inline edit. Tab = autocomplete.

## 8. Keeping MacBook Awake

```bash
sudo pmset -c sleep 0           # Never sleep on power
sudo pmset -c disablesleep 1    # Stay awake with lid closed
sudo pmset -a womp 1            # Wake on network
```

Or install **Amphetamine** (free, Mac App Store) for a GUI toggle.

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Can't reach MacBook | `tailscale status` on both devices. Ensure same account. |
| code-server won't load | `launchctl list | grep code-server`. Logs: `/tmp/code-server.log` |
| SSH refused | System Settings → Sharing → Remote Login must be ON |
| Ollama not responding | `curl http://localhost:11434/api/tags`. Logs: `/tmp/ollama.log` |
| Model too slow | Use `phi3:mini`. Close heavy apps. Run `memory_pressure`. |
| Open WebUI can't find Ollama | Check `OLLAMA_HOST=0.0.0.0` in launchd plist. |
| Disk space | `ollama list` → `ollama rm <model>` to free space |
