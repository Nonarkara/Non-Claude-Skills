<p align="center">
  <img src="docs/hero-banner.png" alt="Workshop illustration for Non-Claude-Skills: a mentor and a student compose reusable agent recipes at a wooden desk. Glowing HUD tiles are artwork, not a product interface." width="100%">
</p>

<p align="center"><em>The floating HUD in this banner is illustration only. It is not a live interface, and those tiles are not the skills in this repository.</em></p>

# Non-Claude-Skills

A public studio library of agent skills for civic dashboards, city operations tools, and the craft of shipping them.

Built by [Dr. Non Arkaraprasertkul](https://github.com/Nonarkara) from work on real deployments across ASEAN — not from a generic prompt pack.

---

## What this is

This repository is a set of reusable **skills**: folders with a `SKILL.md` plus the references and templates that skill needs. An agent (Claude Code, Cursor, or any tool that loads the same format) reads those files and applies the recipe.

It is **not** a hosted product, an agent runtime, a command center HUD, or a bundle of live credentials. The manga banner is atmosphere. The work lives in the skill folders.

| Skill | What it is for |
| --- | --- |
| [`dr-non-stack`](./dr-non-stack/) | Project scaffold and design system: stack choices, visual hierarchy, SEO, database, deployment, and a catalog of free public data sources. |
| [`dr-non-golden-rules`](./dr-non-golden-rules/) | Fourteen production principles from 45-minute dashboard builds and city-scale work. The closing rule: the best stack is the one that ships. |
| [`karpathy-guidelines`](./karpathy-guidelines/) | Behavioral rules that reduce common LLM coding mistakes: think first, keep it simple, change only what you must, verify the goal. Derived from [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills). |
| [`bangkok-ioc-dashboard`](./bangkok-ioc-dashboard/) | Pattern for a dark, data-dense city operations display: adapters, KPI strip, map layers, Thai government and open feeds. |
| [`non-app-pattern`](./non-app-pattern/) | Phone-first personal dashboard that doubles as a business card and offline PWA, with a 3D room behind one toggle. |
| [`remote-coding-llm-setup`](./remote-coding-llm-setup/) | iPad + MacBook remote coding (Tailscale, code-server) and local LLM setup (Ollama, Open WebUI, Open Interpreter). |

Each skill is a recipe you copy, adapt, and run in **your** environment. Nothing here stands up a city's systems by itself.

---

## Philosophy

A studio is a place for careful work and honest observation. These skills assume that civic software should make public work more visible and more usable — not more mysterious.

- **People before stack.** Talk to a real user before writing a line. A mayor, a duty officer, a resident on a phone: name them.
- **Show the number.** If it is not in the data, it is not a civic fact. Ugly truth beats a beautiful chart that lies.
- **Use what is already public.** Prefer free, documented APIs and official open feeds over paid platforms you do not need.
- **Ship a small working thing.** A dashboard in 45 minutes that a human can judge beats a perfect architecture that never leaves the laptop.
- **Keep pieces modular.** One skill, one job. Compose recipes; do not build a monolith because the illustration showed five glowing tiles.
- **Open by default.** If it is not secret, it can be public. The value is the knowledge, not a hidden credential.
- **Humans decide.** Agents gather, draft, and scaffold. People remain accountable for what goes in front of a city.

---

## Ethical use

These skills exist to help public-interest work: operations centers, environmental monitors, resident-facing dashboards, and the engineering habits that keep those tools honest.

Use them that way.

- **Do not invent secrets.** This repository does not contain live API keys, passwords, tokens, or government credentials. Do not fabricate any. Put real credentials in environment variables or a secret store that is not committed to git.
- **Examples are examples.** Skill files may mention placeholder env vars (for example `DATABASE_URL`) or a vendor's public `demo` token. Those are documented stand-ins. Register your own production access where a provider requires it.
- **Stay inside published access.** Prefer official open endpoints and documented free tiers. Respect rate limits, terms of use, and data licenses. Do not treat these skills as permission to bypass authentication or scrape systems you are not allowed to use.
- **Do not build covert surveillance.** City monitoring patterns here are for accountable operations and public information — duty rooms, published feeds, resident reports — not hidden tracking of people.
- **Do not launder generated numbers as official.** Cite the source. If a feed is down, say so. Mock data in a skill is for local development, not for a press briefing.
- **Keep a human in the loop** for decisions that affect residents, staff, or public communications.

If a task would require unauthorized access, invented credentials, or presenting fiction as government data, stop.

---

## How to install or use skills

Skills are ordinary directories. Installation means putting those directories where your agent already looks for `SKILL.md` files.

### 1. Clone

```bash
git clone https://github.com/Nonarkara/Non-Claude-Skills.git
cd Non-Claude-Skills
```

### 2. Install into Claude Code (global)

```bash
mkdir -p ~/.claude/skills
cp -r dr-non-stack dr-non-golden-rules karpathy-guidelines \
      bangkok-ioc-dashboard non-app-pattern remote-coding-llm-setup \
      ~/.claude/skills/
```

For a single project, copy the same folders into that project's `.claude/skills/` directory instead.

### 3. Install into Cursor

```bash
mkdir -p ~/.cursor/skills
cp -r dr-non-stack dr-non-golden-rules karpathy-guidelines \
      bangkok-ioc-dashboard non-app-pattern remote-coding-llm-setup \
      ~/.cursor/skills/
```

For one repo, copy into `.cursor/skills/` at the project root.

### 4. Point a project at them

In Claude Code, you can also name skills from this library in the project's `CLAUDE.md` so the agent knows they are in play:

```text
Skills: dr-non-stack, dr-non-golden-rules, karpathy-guidelines,
bangkok-ioc-dashboard, non-app-pattern, remote-coding-llm-setup
```

### 5. Optional: remote coding scripts

The `remote-coding-llm-setup` skill includes shell templates. Read the skill first, then run only what matches your machine:

```bash
bash remote-coding-llm-setup/templates/macbook-setup.sh
```

Those scripts configure **your** laptop. They do not embed cloud secrets.

After copying, start a new agent session (or restart the IDE) so the skills load. Open a skill's `SKILL.md` to see triggers, checklists, and linked references.

---

## License

[MIT](./LICENSE) © 2026 Non Arkaraprasertkul.

`karpathy-guidelines` is MIT-licensed here and attributed to [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills).
