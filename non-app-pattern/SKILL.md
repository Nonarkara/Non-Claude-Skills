---
name: non-app-pattern
description: Build a phone-first dashboard that doubles as a business card and an offline-capable PWA, with a 3D showcase mode hidden behind a single toggle. Apply when Dr Non asks for a portfolio site, a personal hub, a client-facing dashboard, or anything that lives at a domain root and needs to look professional in 5 seconds on someone's phone. The blueprint is what's running at nonarkara.org as of 2026-05-09.
---

# The NON App Pattern

> "I'm just creating something for myself. I need to monitor these things and I need to be able to get some information about these things. It's like I'm designing my own dashboard to the point that I feel like this dashboard itself could actually be an OS by itself."
> — Dr Non, 2026-05-09

The shape of a personal dashboard that became a portfolio that became an app prototype, in one HTML file. Use when:

- Dr Non shares a link in WhatsApp/LINE/Telegram and the recipient opens it on a phone first.
- The site needs to function as a business card: name, role, contact, demonstrable work — all in one tap.
- There's a 3D, immersive, or "fun" version of the experience that he finds **hard to use on a phone himself**.
- The fleet of dashboards behind the front door needs to be browsable and monitorable.

This is **not** the pattern for: marketing sites, single-feature SaaS, blog-style content sites, or anything where the primary surface is desktop.

## The seven layers

Every NON-app build has these layers. Skip none of them; their combination is what creates the "OS-feel" that Dr Non named.

### 1. Plan view as default · Room as opt-in

The 2D dashboard is the front door. The 3D scene (Three.js, MapLibre, whatever) sits behind a single ENTER ROOM button.

```js
function chooseDefaultView() {
  const saved = lsGet('domain.view');                // localStorage, wrapped
  if (saved === 'plan' || saved === 'room') return saved;
  try { return matchMedia('(max-width: 768px)').matches ? 'plan' : 'room'; }
  catch (_) { return 'room' }
}
```

- Phone (≤ 768 px, no preference) → plan.
- Desktop → room.
- Choice persisted; toggle from either side.

Both views share the same data structures, the same modal openers, the same status fetcher. The plan is not a "fallback" — it's the canonical surface.

### 2. PWA shell · viewport-fit=cover · safe-area on every overlay

```html
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no, viewport-fit=cover">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta name="theme-color" id="theme-color-meta" content="#000000">
<link rel="manifest" href="manifest.webmanifest">
<link rel="apple-touch-icon" href="apple-touch-icon.png">
```

```css
:root {
  --sat: env(safe-area-inset-top, 0px);
  --sab: env(safe-area-inset-bottom, 0px);
  /* etc. */
}
html, body { height: 100dvh; overscroll-behavior: none; }
.brand { top: calc(28px + var(--sat)); left: calc(32px + var(--sal)); }
.menu  { right: calc(18px + var(--sar)); bottom: calc(18px + var(--sab)); }
```

When `theme-color` is updated by JS on theme toggle, the iOS status bar tints with the room. That single behaviour is what turns the page into something that **feels like an app**, not a website.

### 3. Service worker · offline-first · controllerchange auto-reload (with guard)

After the first visit, the page must work with no network. The room loads, the music plays, the dashboards show last-known status. The dots go dim only for the live-status fetch.

```js
const CACHE_VERSION = 'project-YYYY-MM-DD-NN';
const PRECACHE = [...SHELL, ...HEAVY_ASSETS, ...CDN_URLS];

self.addEventListener('install', (e) => {
  e.waitUntil((async () => {
    const cache = await caches.open(CACHE_VERSION);
    await Promise.all(PRECACHE.map(url => fetch(new Request(url, {
      mode: url.startsWith('http') ? 'no-cors' : 'same-origin'
    })).then(r => cache.put(url, r.clone())).catch(() => {})));
    self.skipWaiting();
  })());
});
self.addEventListener('activate', (e) => {
  e.waitUntil((async () => {
    const keys = await caches.keys();
    await Promise.all(keys.filter(k => k !== CACHE_VERSION).map(k => caches.delete(k)));
    await self.clients.claim();
  })());
});
```

**Critical guard** on the page side — only attach the auto-reload listener if the page is already controlled. Otherwise first-visit infinite loop, frozen tab, black screen:

```js
if (navigator.serviceWorker.controller) {
  let __refreshing = false;
  navigator.serviceWorker.addEventListener('controllerchange', () => {
    if (__refreshing) return;
    __refreshing = true;
    location.reload();
  });
}
```

Bump CACHE_VERSION on every deploy that touches a precached file. Don't precache HTML if you want live revalidation; do precache it if you want offline launch.

### 4. Phone-first sheet modals (no boxed dialogs)

On `(max-width: 600px)`, every modal becomes a full-bleed sheet. Edge-to-edge, animates up from the bottom with iOS easing. Same behaviour for QR/contact, music player, city detail, anything.

```css
@media (max-width: 600px) {
  .modal { padding: 0; }
  .modal-card {
    max-width: 100vw; width: 100vw; height: 100dvh;
    padding: calc(56px + var(--sat)) 22px calc(28px + var(--sab));
    border: 0;
    animation: sheetUp 0.35s cubic-bezier(0.2, 0.8, 0.2, 1);
  }
}
```

### 5. Three text sizes, hard rule (§11.7 of workspace CLAUDE.md)

Display (32px), body (14px), micro (11px). Tokens, not magic numbers. Mono numerics in `JetBrains Mono`. Latin in `system-ui`. Thai in `IBM Plex Sans Thai` (non-looped, NEVER looped). Chinese in `Noto Sans SC`.

### 6. The Philosophy Strip

Every NON-app site has a quiet strip near the bottom that explains how Dr Non works. Not marketing copy. His voice (§12 of workspace CLAUDE.md): mundane → philosophy, no conclusion, open question, dry humour permitted.

The canonical version on nonarkara.org:

> Most of the dashboards above refresh on a five-minute cron. To a person looking at one, that is indistinguishable from real-time, and it costs roughly nothing to run.
>
> The ones that **charge for true real-time** charge for what real-time costs — cloud CPU, instrumented pipelines, on-call engineering. The space between the two tiers is where most engineering wastes itself.
>
> If you want to talk about a city, a region, or a question, the contact card is in the personal section above. Tap it.

This is the business model surfaced as content. People who read it understand the tier. People who don't get the same site.

### 7. Live fleet status (cron worker · KV · plan dots)

A Cloudflare Worker on a 5-minute cron pings every domain in the fleet, stores results in KV, exposes `/status` as JSON. The page polls once a minute, paints amber dots for OK, red for fail, dim for unknown.

Cache the **latest snapshot in localStorage** so the next page load paints dots instantly, before the network round-trip. Stale data beats grey dots.

```js
// On boot:
const cached = localStorage.getItem('site.status.snapshot');
if (cached) paintPlanStatus(JSON.parse(cached));

// In refreshStatus:
localStorage.setItem('site.status.snapshot', JSON.stringify(data));
```

GitHub Actions does the same job on a 30-minute cron as a fallback, committing `health/latest.json`. The page tries Worker first, falls back to JSON.

## OG image (the share preview)

Same visual language as the apple-touch-icon: black background, NON wordmark in `Josefin Sans 700`, the **O is rendered as a hollow amber circle**, name + role in mono caps below, URL in amber bottom-left, tagline bottom-right.

1200 × 630 PNG. Source SVG committed alongside. Reproducible.

## What this pattern explicitly rejects

- Round-corner cards. Hairlines + true rectangles only. The icon's amber circle is the only circle.
- Gradient fills, drop shadows, glassmorphism. Inset borders and `:focus-visible` rings only.
- Stock photography, Lorem Ipsum, AI-generated imagery, motivational copy.
- Roboto, Inter, Poppins, Montserrat, Open Sans, Lato. Josefin Sans (display) + JetBrains Mono (data) + system-ui (body) + IBM Plex Sans Thai non-looped + Noto Sans SC.
- "Welcome to my portfolio" / "Get in touch" / "I help X do Y" template copy.
- Loading spinners that wait on the network. Cache and paint stale.

## Reference implementation

`Projects/nonarkara-org/` as of commit `5c9341c` (2026-05-09). The whole site is one HTML file plus a service worker plus a Cloudflare Worker plus an icon set. Fork that as the starting template; replace the PROJECTS array, the philosophy strip, and the OG image; ship.

## When the pattern doesn't fit

- Marketing landing pages with a conversion funnel (a NON-app site has no funnel; the contact is one tap from anywhere, equally available, no urgency).
- Multi-user products (no auth here; the site is the persona of one human).
- Product walkthroughs (no narrative; the grid IS the narrative).

For those, reach for a different template.
