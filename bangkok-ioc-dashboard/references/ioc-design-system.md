# IOC Design System — Dark War Room Theme

## Color Palette

```css
:root, [data-theme="ops"] {
  --bg: #0a0e14;           /* Deep navy-black background */
  --panel: #111720;        /* Card/panel background */
  --panel-strong: #161d28; /* Elevated surface */
  --panel-soft: #0d1219;   /* Recessed surface */
  --line: rgba(255, 255, 255, 0.08);   /* Subtle borders */
  --line-strong: rgba(255, 255, 255, 0.14);
  --ink: #e8edf3;          /* Primary text */
  --muted: #6b7a8d;        /* Secondary/caption text */
  --blue: #38bdf8;         /* Primary accent — interactive elements */
  --green: #34d399;        /* Positive — resolved, live, ok */
  --amber: #fbbf24;        /* Warning — watch, delayed */
  --red: #f87171;          /* Alert — critical, failed */
  --focus: rgba(56, 189, 248, 0.2); /* Focus ring */
  --glow-blue: rgba(56, 189, 248, 0.08);
  --glow-green: rgba(52, 211, 153, 0.08);
}
```

## Typography

| Role | Font | Weight | Size |
|------|------|--------|------|
| KPI numbers | Manrope | 700 | 1.4rem |
| Headings | Manrope | 700-800 | 0.78-0.92rem |
| Eyebrow labels | Inter | 600 | 0.5-0.6rem |
| Body text | Inter | 400-500 | 0.6-0.7rem |
| Captions | Inter | 300-400 | 0.45-0.55rem |
| Data values | SF Mono | 600 | 0.65-0.75rem |

Global: `font-feature-settings: "tnum" 1; font-variant-numeric: tabular-nums;`

## Card Patterns

### Standard Panel
```css
.overview-card {
  background: var(--panel);
  border: none;
  border-radius: 8px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.4);
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.overview-card:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.3);
}
```

### Glassmorphism (Governor KPI strip)
```css
background: linear-gradient(165deg, rgba(56, 189, 248, 0.08), rgba(17, 23, 32, 0.95));
border: 1px solid rgba(56, 189, 248, 0.2);
/* Top accent line: */
&::before { background: linear-gradient(90deg, transparent, rgba(56, 189, 248, 0.5), transparent); height: 2px; }
```

### KPI Item
```css
background: rgba(255, 255, 255, 0.04);
border: 1px solid rgba(255, 255, 255, 0.08);
/* Hover: cyan glow */
/* Alert: red pulse animation */
/* Data change: cyan flash */
```

## Animation Catalog

| Keyframe | Duration | Purpose |
|----------|----------|---------|
| `count-pop` | 0.5s | KPI number scales up on data change |
| `data-refresh` | 0.6s | Cyan border flash on value update |
| `kpi-pulse` | 2s infinite | Red glow for alert thresholds |
| `sparkline-draw` | 1.2s | Stroke draws in from left |
| `shimmer` | 1.8s infinite | Loading placeholder gradient |
| `card-slide-in` | 0.25s | Feature card slides in from right |
| `bar-shine` | 2s infinite | Traffy bar highlight sweep |
| `pulse-dot` | 2s infinite | Clock status dot blink |

## Layout (72" IOC @ 1920px+)

```
.dashboard-stage: grid 2.2fr / 1fr (map / sidebar)
.overview-shell: 3-column grid, 0.3rem gap
.governor-kpi-grid: 6-column grid
.system-status-grid: 6-column grid
.bottomstrip-row.metrics: 12-column grid
```

At 3200px+ (4K): overview-shell becomes 4-column, bottomstrip 16-column.

## Accessibility

- All interactive elements: `button:focus-visible { outline: 2px solid var(--blue); outline-offset: 2px; }`
- Live clock: `role="status" aria-live="polite"`
- KPI items: `aria-label` with human-readable value descriptions
- Measure tool: `aria-pressed` state
- Contrast: All text meets WCAG AA 4.5:1 ratio on dark backgrounds
