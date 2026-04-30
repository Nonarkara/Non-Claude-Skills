# Non-Claude-Skills

A collection of Claude Code skills encoding Dr. Non's workflows, tools, and setup guides.

## Skills

### dr-non-stack

Complete project scaffold, design system, database strategy, SEO pipeline, deployment workflow, and data source catalog. Auto-triggers on every new project.

### remote-coding-llm-setup

Remote coding setup (iPad + MacBook via Tailscale + code-server) and offline LLM configuration (Ollama + Open WebUI + Open Interpreter). Code from anywhere, run AI locally.

## What's Inside

### dr-non-stack

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

### remote-coding-llm-setup

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

## Design Philosophy

- **Jony Ive meets Dieter Rams** — clarity, simplicity, elegance, modernity
- **Don Norman** — affordances, signifiers, feedback, mapping, constraints
- **Behavioral Economics** — anchoring, default effect, social proof, loss aversion, progressive disclosure
- **Typography** — Inter (body) + Manrope (headings), Helvetica-inspired clean aesthetic

## Core Principles

1. Every project has a database from day one (Supabase Pro)
2. SEO and analytics are never optional
3. Google Sheets as parallel analytics layer for easy visualization
4. Design methodology is consistent across ALL projects
5. Only the live deployed URL counts — localhost is never a deliverable

## Tech Stack

- **Frontend**: Next.js + TypeScript + Tailwind CSS (or Vite + React for lighter projects)
- **Database**: Supabase (PostgreSQL, Pro plan)
- **Deployment**: Render (web services) / GitHub Pages (static)
- **Geospatial**: Deck.gl + Mapbox GL
- **AI**: Claude API (Opus 4.6)

## Installation

Copy skills to `~/.claude/skills/` to make them available across all Claude Code projects:

```bash
# Project scaffold & design system
cp -r dr-non-stack/ ~/.claude/skills/dr-non-stack/

# Remote coding & offline LLM setup
cp -r remote-coding-llm-setup/ ~/.claude/skills/remote-coding-llm-setup/
```

To run the MacBook setup:

```bash
bash remote-coding-llm-setup/templates/macbook-setup.sh
```

## Author

Dr. Non Arkaraprasertkul — Harvard PhD, MIT Architect, Smart City Expert at Thailand's depa
