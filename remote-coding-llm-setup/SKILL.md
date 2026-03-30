---
name: remote-coding-llm-setup
description: >-
  Remote coding setup for iPad + MacBook workflow and offline LLM configuration.
  Use when setting up remote access, configuring Tailscale, installing code-server,
  setting up Ollama, or when the user says "remote coding", "code from iPad",
  "work from anywhere", "offline LLM", "local AI", "Tailscale", "code-server",
  "Ollama", "Open WebUI", or "portable setup". Covers both the server (MacBook)
  and client (iPad) sides of the configuration.
---

# Remote Coding & Offline LLM Setup

One MacBook as a powerhouse. One iPad as a thin client. Code from anywhere with internet. Run AI models offline when you don't have it.

## Philosophy

Your MacBook Air M3 is a capable machine — Apple Silicon, all-day battery, silent operation. But it's not always with you. Your iPad is. This setup turns your MacBook into an always-on development server and AI inference engine, accessible from your iPad anywhere in the world.

**Two capabilities, one laptop:**
1. **Remote coding** — Full VS Code + terminal from iPad Safari
2. **Offline AI** — Chat, code, and process files with local LLMs

## The Stack

| Layer | Tool | Why |
|-------|------|-----|
| Networking | **Tailscale** | Mesh VPN, zero-config, works through NAT/firewalls, free |
| Code Editor | **code-server** | VS Code in the browser, perfect for iPad Safari PWA |
| Terminal | **Blink Shell** (iPad) | Native SSH + mosh client, best terminal on iPad |
| AI Chat | **Ollama + Open WebUI** | ChatGPT-like interface, runs locally, no internet needed |
| AI Coding | **Continue.dev** | VS Code extension, connects to local Ollama models |
| Cloud AI | **claude.ai/code** | Claude Code from iPad browser for remote AI sessions |

## Quick Setup Checklist

### MacBook (Server Side)

- [ ] Install Homebrew (if not installed)
- [ ] Install and start Tailscale — `brew install --cask tailscale`
- [ ] Note your Tailscale IP (100.x.x.x) or MagicDNS hostname
- [ ] Install code-server — `brew install code-server`
- [ ] Configure code-server to start on boot (launchd)
- [ ] Enable Remote Login (SSH) in System Settings > General > Sharing
- [ ] Install Ollama — `brew install ollama`
- [ ] Pull models — `ollama pull qwen2.5-coder:7b && ollama pull phi3:mini`
- [ ] Install Docker Desktop (for Open WebUI)
- [ ] Run Open WebUI — `docker compose up -d`
- [ ] Install Continue.dev extension in code-server

### iPad (Client Side)

- [ ] Install Tailscale from App Store, log in with same account
- [ ] Install Blink Shell from App Store
- [ ] Configure SSH key (generate in Blink, copy pubkey to MacBook)
- [ ] Bookmark `http://<tailscale-ip>:8080` in Safari (code-server)
- [ ] Add to Home Screen for PWA full-screen mode
- [ ] Bookmark `http://<tailscale-ip>:3000` in Safari (Open WebUI)
- [ ] Test SSH via Blink: `ssh user@<tailscale-ip>`

## Model Recommendations (8GB M3 MacBook Air)

Storage is limited (256GB SSD) — pick 2-3 models, budget ~8GB for LLMs.

| Use Case | Model | Disk Size | RAM Usage | Speed on M3 |
|----------|-------|-----------|-----------|--------------|
| Coding | `qwen2.5-coder:7b` | ~4.4 GB | ~5 GB | ~20 tok/s |
| Quick chat | `phi3:mini` | ~2.3 GB | ~3 GB | ~35 tok/s |
| General | `llama3.1:8b` | ~4.7 GB | ~5 GB | ~20 tok/s |
| All-rounder | `qwen2.5:7b` | ~4.4 GB | ~5 GB | ~20 tok/s |

**Recommended combo:** `qwen2.5-coder:7b` + `phi3:mini` = ~6.7 GB disk

> **Tip:** Only one model loads into RAM at a time. Ollama auto-unloads after 5 minutes of inactivity.

## Accessing Everything from iPad

Once Tailscale is connected on both devices:

| Service | URL from iPad | Port |
|---------|---------------|------|
| code-server (VS Code) | `http://<tailscale-ip>:8080` | 8080 |
| Open WebUI (AI Chat) | `http://<tailscale-ip>:3000` | 3000 |
| Ollama API | `http://<tailscale-ip>:11434` | 11434 |
| SSH | `ssh user@<tailscale-ip>` | 22 |

## One-Line Setup

Run the all-in-one script on your MacBook:

```bash
bash templates/macbook-setup.sh
```

Or run individual components:

```bash
bash templates/code-server-setup.sh   # Just code-server
bash templates/ollama-models.sh       # Just Ollama + models
```

## Security Notes

- All traffic goes through Tailscale's encrypted WireGuard tunnel
- code-server and Open WebUI are **only accessible via Tailscale** — not exposed to the public internet
- SSH should use key authentication only (disable password auth)
- Tailscale ACLs can restrict which devices can connect

## Reference Guides

- [Remote Access Setup](references/remote-access-guide.md) — Tailscale, code-server, SSH, Blink Shell, iPad tips
- [Offline LLM Setup](references/offline-llm-guide.md) — Ollama, Open WebUI, model selection, Continue.dev, performance tuning
