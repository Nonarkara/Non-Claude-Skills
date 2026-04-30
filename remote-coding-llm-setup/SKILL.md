---
name: remote-coding-llm-setup
description: >-
  Remote coding from iPad + offline LLM setup. Use when the user says "remote
  coding", "iPad", "work from anywhere", "offline LLM", "local AI", "Tailscale",
  "code-server", "Ollama", "Open Interpreter", or "portable setup".
---

# Remote Coding & Offline LLM Setup

MacBook = server. iPad = thin client. One script sets up everything.

```
iPad (anywhere)  ──── Tailscale VPN ────  MacBook (home/office)
  ├─ Safari → code-server :8080           ├─ Ollama (qwen2.5:14b, phi3:mini)
  ├─ Safari → Open WebUI  :3000           ├─ Open Interpreter (offline Claude Code)
  └─ Blink Shell → SSH    :22             └─ Continue.dev (AI in VS Code)
```

## Setup

### MacBook — one command

```bash
curl -fsSL https://raw.githubusercontent.com/nonarkara/Non-Claude-Skills/main/remote-coding-llm-setup/setup.sh | bash
```

Or if you already cloned the repo: `bash remote-coding-llm-setup/setup.sh`

The script installs Tailscale, code-server, Ollama, models, Open Interpreter, and Open WebUI. No prompts. Idempotent — safe to run again.

### iPad — 5 minutes, manual

1. **Tailscale** — App Store, sign in with same account as MacBook
2. **Blink Shell** — App Store, generate SSH key, copy pubkey to MacBook's `~/.ssh/authorized_keys`
3. **Safari** — bookmark `http://<tailscale-ip>:8080` → Add to Home Screen (full-screen VS Code)
4. **Safari** — bookmark `http://<tailscale-ip>:3000` (AI chat)

Get your Tailscale IP: run `tailscale ip -4` on MacBook.

## Models (16GB M3)

| Model | Use | Disk | Speed |
|-------|-----|------|-------|
| `qwen2.5:14b` | Everything: code, analysis, writing | 9 GB | ~15 tok/s |
| `phi3:mini` | Quick questions | 2.3 GB | ~35 tok/s |

Only one loads at a time. Auto-unloads after 5 min idle.

## Daily Use

| Task | Command / URL |
|------|--------------|
| Code from iPad | `http://<tailscale-ip>:8080` in Safari |
| AI chat from iPad | `http://<tailscale-ip>:3000` in Safari |
| SSH from iPad | Type `macbook` in Blink Shell |
| Offline Claude Code | `oi` in terminal |
| Direct model chat | `ollama run qwen2.5:14b` |
| Claude Code (online) | `claude.ai/code` in Safari |

## Reference

Full details: [setup-guide.md](setup-guide.md) — Tailscale config, code-server tuning, SSH hardening, model selection, Open Interpreter examples, troubleshooting.
