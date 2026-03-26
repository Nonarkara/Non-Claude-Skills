# Dr-Non-Stack

A comprehensive Claude Code skill encoding Dr. Non's complete project scaffold, design system, database strategy, SEO pipeline, deployment workflow, and data source catalog.

## What This Is

A reusable skill that auto-triggers on every new project, ensuring consistency across all of Dr. Non's work — dashboards, indices, landing pages, AI tools, and city monitoring systems.

## What's Inside

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

Copy `dr-non-stack/` to `~/.claude/skills/` to make it available across all Claude Code projects:

```bash
cp -r dr-non-stack/ ~/.claude/skills/dr-non-stack/
```

## Author

Dr. Non Arkaraprasertkul — Harvard PhD, MIT Architect, Smart City Expert at Thailand's depa
