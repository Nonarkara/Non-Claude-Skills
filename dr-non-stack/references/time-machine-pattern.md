# Time Machine Pattern

A version switcher that lets users browse between different design eras or deployment versions of the same product. First implemented in Axiom, now adopted across Dr. Non's projects.

## Two Approaches

### 1. CSS Theme Switcher (same deployment)

Best when all versions live in the same codebase and differ only in visual treatment.

**Architecture:**
- Multiple CSS theme files loaded in `<head>` (e.g., `theme-v2.css`, `theme-v25.css`)
- `data-theme` attribute on `<html>` controls which theme is active
- Each theme file overrides CSS variables under `[data-theme="v2"]`, etc.
- Selection persists in `localStorage`

**Implementation:**

```html
<!-- Early in <head> to prevent flash -->
<script>
  document.documentElement.setAttribute(
    'data-theme',
    localStorage.getItem('app-theme') || 'v2'
  );
</script>

<!-- Theme CSS files -->
<link rel="stylesheet" href="/theme-v2.css" />
<link rel="stylesheet" href="/theme-v25.css" />
```

```js
// Theme switcher logic
function setTheme(version) {
  document.documentElement.setAttribute('data-theme', version);
  localStorage.setItem('app-theme', version);
  // Optional: dispatch event for components that need to react
  window.dispatchEvent(new CustomEvent('theme-change', { detail: { theme: version } }));
}
```

```css
/* theme-v2.css */
[data-theme="v2"] {
  --bg: #fafafa;
  --text: #18181b;
  --accent: #2563eb;
  /* ... full palette override */
}

/* theme-v25.css */
[data-theme="v2.5"] {
  --bg: #0a0a0f;
  --text: #e2e8f0;
  --accent: #17c9cb;
  --font-heading: 'JetBrains Mono', monospace;
  /* ... full palette override */
}
```

**UI Component:**
- Fixed button (bottom-right or in nav) labeled "Time Machine"
- Dropdown shows available versions with color swatches + description
- Current version highlighted
- Each option has: name, design inspiration, 1-line description

**Used in:** Axiom (3 themes: v1 Command Center, v2 Ive/Rams, v2.5 Asimov/Kubrick)

### 2. Cross-Deployment Links (separate deployments)

Best when versions are truly different codebases on different hosts.

**Architecture:**
- Each version is its own deployment (e.g., Render for V2, Vercel for V2.5)
- A "Time Machine" link in the nav/footer points to the other deployment
- Styled as a special nav item (accent border, icon)

**Implementation:**

```tsx
// In masthead nav
<a
  href="https://other-version.onrender.com"
  target="_blank"
  rel="noopener noreferrer"
  className="masthead-nav-link time-machine-link"
>
  <span className="time-machine-icon" aria-hidden="true">clock</span>
  Time Machine (V2)
</a>
```

```css
.time-machine-link {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  border: 1px solid rgba(23, 201, 203, 0.2);
  background: rgba(23, 201, 203, 0.06);
  color: var(--accent-cyan);
  transition: background 0.15s, border-color 0.15s;
}

.time-machine-link:hover {
  background: rgba(23, 201, 203, 0.12);
  border-color: rgba(23, 201, 203, 0.35);
}
```

**Used in:** SLIC Index (V2 on Render <-> V2.5 on Vercel)

## Design Guidelines

- Always label clearly which version the user is currently on
- Include a brief tagline for each version (design era or purpose)
- Persist the user's preference where possible
- For cross-deployment: open in new tab (`target="_blank"`)
- For same-deployment: smooth CSS transition, no reload needed
- The time machine should feel like a feature, not just a link — give it its own visual identity (accent color, icon, special border treatment)

## Localization

Support multi-language labels:

```ts
const timeMachineLabels = {
  en: "Time Machine",
  th: "ไทม์แมชชีน",
  zh: "时光机",
};
```
