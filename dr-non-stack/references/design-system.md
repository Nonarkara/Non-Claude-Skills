# Dr-Non-Stack Design System

## Core Principle
Clarity, simplicity, elegance, modernity, and information communication. Users should know how to use the system naturally — or make an intelligent guess because the design behaviorally works with their cognition.

## Color System

### Philosophy
Muted backgrounds, bold accents. Dark-mode-ready from the start. Never garish.

### Palette Structure
Every project defines these CSS variables:

```css
:root {
  /* Backgrounds */
  --bg-primary: #fafafa;        /* Main background */
  --bg-secondary: #f4f4f5;      /* Section grouping */
  --bg-elevated: #ffffff;        /* Cards, modals */

  /* Text */
  --text-primary: #18181b;       /* Headings, primary content */
  --text-secondary: #52525b;     /* Body text */
  --text-tertiary: #a1a1aa;      /* Captions, metadata */

  /* Accent — project-specific, always one dominant accent */
  --accent-primary: #2563eb;     /* Primary actions */
  --accent-muted: #93c5fd;       /* Secondary elements */

  /* Semantic */
  --success: #16a34a;
  --warning: #d97706;
  --error: #dc2626;

  /* Borders & Shadows */
  --border: #e4e4e7;
  --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
  --shadow-md: 0 4px 6px -1px rgba(0,0,0,0.07);
  --shadow-lg: 0 10px 15px -3px rgba(0,0,0,0.08);
  --shadow-xl: 0 20px 25px -5px rgba(0,0,0,0.1);
}

/* Dark mode */
[data-theme="dark"] {
  --bg-primary: #09090b;
  --bg-secondary: #18181b;
  --bg-elevated: #27272a;
  --text-primary: #fafafa;
  --text-secondary: #a1a1aa;
  --text-tertiary: #71717a;
  --border: #3f3f46;
}
```

### Color Usage Rules
- **Primary actions** (buttons, links, CTAs): Full saturation accent color
- **Secondary actions**: Muted accent or outlined
- **Tertiary/disabled**: Gray scale only
- **Backgrounds**: Never pure white (#fff) for large surfaces — use #fafafa or similar
- **One accent per project**: Pick one dominant color. Consistency > variety.

## Spacing System

**Base unit: 4px (0.25rem)**

| Token | Value | Use |
|-------|-------|-----|
| space-1 | 4px | Tight inline spacing |
| space-2 | 8px | Between related items |
| space-3 | 12px | Input padding, small gaps |
| space-4 | 16px | Standard component padding |
| space-6 | 24px | Between components |
| space-8 | 32px | Section padding |
| space-12 | 48px | Between major sections |
| space-16 | 64px | Page-level spacing |

**Rules:**
- Generous gaps BETWEEN sections, tight WITHIN — whitespace IS hierarchy
- Cards: `p-6` (24px) internal padding
- Page container: `max-w-7xl mx-auto px-4 sm:px-6 lg:px-8`

## Border Radius

| Element | Radius |
|---------|--------|
| Buttons | `rounded-lg` (8px) |
| Cards | `rounded-xl` (12px) |
| Modals | `rounded-2xl` (16px) |
| Badges/pills | `rounded-full` |
| Inputs | `rounded-lg` (8px) |

Consistency: pick one radius family and stick to it across the project.

## Shadow & Elevation

Interactive elements need depth — static elements stay flat.

- **Resting card**: `shadow-sm` → hover: `shadow-md` (transition 150ms)
- **Active modal/dropdown**: `shadow-lg`
- **Toast/notification**: `shadow-xl`
- **No shadow**: static text, labels, dividers

## Animation

- **Duration**: 150ms for micro-interactions, 200ms for transitions, 300ms for reveals
- **Easing**: `ease-out` for entrances, `ease-in` for exits, `ease-in-out` for state changes
- **Purpose**: Every animation must communicate something (state change, attention, feedback). Never decorative.
- **Hover states**: Scale 1.02 or shadow elevation change, not color alone

## Don Norman Principles — Applied

### Affordances
- Buttons look raised/tappable (subtle gradient or shadow)
- Links are colored and underlined on hover
- Drag handles have grip dots or texture
- Toggles look like physical switches
- Cards with hover elevation signal clickability

### Signifiers
- Chevrons (›) on expandable items
- Arrow icons on navigation links
- Color accent at the point of action
- Placeholder text showing expected format
- Active/selected states visually distinct (not just color — also weight, border, or fill)

### Feedback
- Button press: scale(0.98) + darker shade for 150ms
- Form submission: loading spinner → success checkmark
- Error: red border + shake animation + inline message
- Hover: always responds (cursor change + visual shift)

### Mapping
- Important → top, secondary → below
- Time → left to right
- Navigation → left sidebar or top bar (never bottom for desktop)
- Actions → right-aligned in cards/rows
- Progress → left to right, filled bar

### Constraints
- Disable impossible actions (grayed out + `cursor-not-allowed`)
- Show max 5-7 items at a time (Miller's Law)
- Group related controls visually (shared background, border)
- Progressive disclosure: advanced options behind an expander, not cluttering the default view

## Behavioral Economics in UI

### Anchoring
Show the most important number/metric FIRST and LARGEST. Everything else is perceived relative to it.
- Dashboard: hero metric at top (giant number), supporting metrics below (smaller)
- Pricing: show the expensive plan first to anchor perception

### Default Effect
Pre-select the best option. Users overwhelmingly accept defaults.
- Language selector: auto-detect from browser, pre-selected
- Sort order: most relevant first
- Time range: sensible default (last 7 days, not "all time")

### Social Proof
When available, show how many others have engaged.
- "2,847 visitors this month"
- "Used by 120+ cities"
- Map showing visitor geography dots

### Loss Aversion
Frame as what they'll lose, not what they'll gain.
- "Don't miss the latest data" not "See new data"
- Countdown for time-sensitive content
- "You have 3 unread insights"

### Decoy Effect
When presenting options, include a middle option that makes the target clearly superior.

### Progressive Disclosure
The most important pattern for complex systems:
- Default view: 3-4 high-level presets (e.g., "Weather Risk", "Safety View")
- Expanded view: granular controls for power users
- Never show 15 toggles when 4 presets serve 90% of users

## Component Conventions

### Cards
- White/elevated background, `rounded-xl`, `shadow-sm`, hover `shadow-md`
- Internal padding: `p-6`
- Title in SemiBold (600), body in Regular (400)
- Action at bottom-right or as full-card click

### Data Tables
- Alternating row backgrounds (bg-primary / bg-secondary)
- Sticky header
- Sortable columns with arrow indicators
- Compact padding: `px-4 py-3`
- Row hover highlight

### Navigation
- Desktop: Left sidebar (collapsible) or top horizontal bar
- Mobile: Bottom tab bar (max 5 items) or hamburger menu
- Active state: accent color + bold weight + background highlight
- Never hide primary navigation behind a menu on desktop

### Dashboard Grids
- CSS Grid with responsive columns: 1 (mobile) → 2 (tablet) → 3-4 (desktop)
- Hero metric: spans full width at top
- Charts and data cards fill the grid below
- Consistent card heights within each row

### Map Containers (Geospatial)
- Full-bleed or contained with rounded corners
- Controls overlay in top-right (zoom, layers)
- Legend in bottom-left
- Attribution in bottom-right (Mapbox requirement)
- Layer selector: max 4-5 preset views, advanced layers behind expander

## Responsive Breakpoints

| Breakpoint | Width | Target |
|------------|-------|--------|
| sm | 640px | Large phones |
| md | 768px | Tablets |
| lg | 1024px | Small laptops |
| xl | 1280px | Desktops |
| 2xl | 1536px | Large screens |

**Mobile-first**: Write base styles for mobile, add complexity with min-width breakpoints.
