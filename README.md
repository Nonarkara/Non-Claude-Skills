# Non-Claude-Skills

A curated set of Claude Code skills for building data dashboards, smart city tools, and civic tech — extracted from real deployments across ASEAN.

Built by Dr. Non Arkaraprasertkul (Harvard PhD, MIT Architect, Senior Expert at Thailand's depa).

---

## Skills

### [`dr-non-stack`](./dr-non-stack/)

Dr. Non's complete project scaffold and design system. Covers tech stack decisions, visual hierarchy, Don Norman principles, behavioral economics, SEO, database setup, deployment, and a catalog of 60+ free data APIs.

**Triggers on:** new project, scaffold, dashboard, landing page, design decisions, typography, color, deployment.

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
cp -r dr-non-golden-rules/ ~/.claude/skills/dr-non-golden-rules/
cp -r karpathy-guidelines/ ~/.claude/skills/karpathy-guidelines/
```

### Option 2 — Clone the whole repo

```bash
git clone https://github.com/nonarkara/Non-Claude-Skills.git
cd Non-Claude-Skills

# Copy all skills at once
cp -r dr-non-stack dr-non-golden-rules karpathy-guidelines ~/.claude/skills/
```

### Option 3 — Reference from project CLAUDE.md

Add to your project's `CLAUDE.md`:

```
Skills: dr-non-stack, dr-non-golden-rules, karpathy-guidelines
```

---

## License

MIT
