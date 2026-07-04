# Non-Claude-Skills

A curated set of Claude Code skills for building data dashboards, smart city tools, and civic tech — extracted from real deployments across ASEAN.

Built by Dr. Non Arkaraprasertkul (Harvard PhD, MIT Architect, Senior Expert at Thailand's depa).

---

## Skills

### [`dr-non-stack`](./dr-non-stack/)

Dr. Non's complete project scaffold and design system. Covers tech stack decisions, visual hierarchy, Don Norman principles, behavioral economics, SEO, database setup, deployment, and a catalog of 60+ free data APIs.

```
dr-non-stack/
├── SKILL.md                          # Main skill — design philosophy, tech stack, checklists
├── references/
│   ├── design-system.md              # Colors, spacing, shadows, Don Norman, behavioral economics
│   ├── seo-checklist.md              # Meta tags, OG, JSON-LD, multi-language, Core Web Vitals
│   ├── database-scaffold.md          # Supabase/SQLite setup, Google Sheets backup, schemas
│   ├── deployment-guide.md           # Render + GitHub Pages configs, health checks
│   ├── free-data-sources.md          # 60+ free APIs (weather, conflict, finance, mapping, news)
│   ├── satellite-data-guide.md       # STAC/COG, Sentinel Hub, Planetary Computer, GEE, providers
│   └── news-pipeline-guide.md        # RSS-first news fetching, Supabase Edge Functions, Realtime
└── templates/
    ├── supabase-schema.sql           # Pageviews + content cache tables with indexes and RLS
    └── seo-head.tsx                  # Reusable SEO component for Next.js and Vite
```

**Triggers on:** new project, scaffold, dashboard, landing page, design decisions, typography, color, deployment.

---

### [`remote-coding-llm-setup`](./remote-coding-llm-setup/)

Remote coding setup (iPad + MacBook via Tailscale + code-server) and offline LLM configuration (Ollama + Open WebUI + Open Interpreter). Code from anywhere, run AI locally.

```
remote-coding-llm-setup/
├── SKILL.md                          # Main skill — stack overview, quick setup checklist
├── references/
│   ├── remote-access-guide.md        # Tailscale, code-server, SSH, Blink Shell, iPad tips
│   └── offline-llm-guide.md          # Ollama, Open WebUI, Open Interpreter, model selection, Continue.dev
└── templates/
    ├── macbook-setup.sh              # All-in-one macOS setup script (16GB M3 optimized)
    ├── code-server-setup.sh          # code-server install + launchd auto-start
    ├── ollama-models.sh              # Ollama + recommended models for M3 16GB
    ├── open-interpreter-setup.sh     # Open Interpreter (offline Claude Code alternative)
    └── docker-compose.yml            # Open WebUI container config
```

**Triggers on:** remote coding, iPad development, offline LLM, Ollama setup, code-server.

---

### [`dr-non-golden-rules`](./dr-non-golden-rules/)

14 engineering principles proven in production — extracted from real 45-minute dashboard builds, open-source deployments, and city-scale work across ASEAN. Not best practices from a book. Rules that actually worked.

Includes: Ship First, Use What You Have, Kill What Doesn't Work, Open Source by Default, and the Golden Rule: **the best stack is the one that ships**.

**Triggers on:** architecture decisions, tool selection, "should I build this", "is this worth keeping", build vs buy tradeoffs.

---

### [`karpathy-guidelines`](./karpathy-guidelines/)

Behavioral guidelines to reduce common LLM coding mistakes. Derived from Andrej Karpathy's observations on AI coding pitfalls.

4 rules: Think Before Coding, Simplicity First, Surgical Changes, Goal-Driven Execution.

**Triggers on:** all coding tasks. Always active.

Source: [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills)

---

## Installation

### Option 1 — Copy skills to global Claude Code directory

```bash
cp -r dr-non-stack/ ~/.claude/skills/dr-non-stack/
cp -r remote-coding-llm-setup/ ~/.claude/skills/remote-coding-llm-setup/
cp -r dr-non-golden-rules/ ~/.claude/skills/dr-non-golden-rules/
cp -r karpathy-guidelines/ ~/.claude/skills/karpathy-guidelines/
```

To run the MacBook setup:

```bash
bash remote-coding-llm-setup/templates/macbook-setup.sh
```

### Option 2 — Clone the whole repo

```bash
git clone https://github.com/nonarkara/Non-Claude-Skills.git
cd Non-Claude-Skills

# Copy all skills at once
cp -r dr-non-stack remote-coding-llm-setup dr-non-golden-rules karpathy-guidelines ~/.claude/skills/
```

### Option 3 — Reference from project CLAUDE.md

Add to your project's `CLAUDE.md`:

```
Skills: dr-non-stack, remote-coding-llm-setup, dr-non-golden-rules, karpathy-guidelines
```

---

## License

MIT
