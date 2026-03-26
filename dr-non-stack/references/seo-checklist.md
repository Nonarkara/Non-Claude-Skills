# SEO & Analytics Checklist

## Meta Tags — Every Page

- [ ] `<title>` — 50-60 characters, keyword-first, unique per page
- [ ] `<meta name="description">` — 150-160 characters, written for humans, unique per page
- [ ] `<meta charset="UTF-8">`
- [ ] `<meta name="viewport" content="width=device-width, initial-scale=1">`
- [ ] `<link rel="canonical" href="...">` — self-referencing on every page

## Open Graph — Every Page

- [ ] `og:title` — mirrors or refines `<title>`
- [ ] `og:description` — mirrors or refines meta description
- [ ] `og:image` — **1200x630px minimum**, absolute HTTPS URL
- [ ] `og:url` — canonical URL of the page
- [ ] `og:type` — "website" for homepages, "article" for content pages
- [ ] `og:site_name` — project/brand name

## Twitter Cards

- [ ] `twitter:card` — use `summary_large_image` for most pages
- [ ] `twitter:title`, `twitter:description`, `twitter:image` — can mirror OG values
- [ ] (Twitter falls back to OG tags, so `twitter:card` is the only strictly required addition)

## JSON-LD Structured Data

Place in `<script type="application/ld+json">` in `<head>`.

### Always Include
- [ ] **WebSite** schema — with `@id`, `name`, `url`
- [ ] **Organization** schema — with `name`, `url`, `logo`, `sameAs` (social profiles)

### When Applicable
- [ ] **Article** / **BlogPosting** — headline, author, datePublished, dateModified, image
- [ ] **FAQPage** with Question/Answer pairs
- [ ] **BreadcrumbList** — for multi-level navigation
- [ ] **LocalBusiness** — with address, geo, opening hours (for place-based projects)

Validate with [Google Rich Results Test](https://search.google.com/test/rich-results).

## Technical SEO

### Files
- [ ] `sitemap.xml` at domain root — auto-generated, only indexable pages, includes `<lastmod>`
- [ ] `robots.txt` at domain root — allow Googlebot, Bingbot; reference sitemap
- [ ] `.env.example` committed (never `.env` itself)

### HTML Structure
- [ ] One `<h1>` per page matching the page's primary topic
- [ ] Logical heading hierarchy: h1 → h2 → h3 (never skip levels)
- [ ] Semantic elements: `<article>`, `<nav>`, `<main>`, `<header>`, `<footer>`, `<aside>`
- [ ] All `<img>` have descriptive `alt` text
- [ ] All `<img>` have explicit `width` and `height` attributes
- [ ] All `<a>` have descriptive anchor text (not "click here")
- [ ] HTTPS everywhere, redirect HTTP → HTTPS
- [ ] Consistent trailing-slash policy (pick one, 301 the other)

### Search Console
- [ ] Verify ownership in Google Search Console
- [ ] Submit sitemap
- [ ] Monitor Core Web Vitals report
- [ ] Check Index Coverage report periodically

## Multi-Language SEO

### URL Structure
Use **subdirectory** pattern (consolidates link equity under one domain):
- `/en/` — English (default)
- `/th/` — Thai
- `/zh/` — Chinese
- Add more based on visitor language data

### hreflang Tags
- [ ] Every language variant declares hreflang tags pointing to ALL other variants + itself
- [ ] Bidirectional: if `/en/` → `/th/`, then `/th/` → `/en/`
- [ ] Include `x-default` pointing to English (or language selector page)
- [ ] Use ISO 639-1 language codes (`en`, `th`, `zh`)
- [ ] Each localized page's canonical tag points to ITSELF (not the English version)

### Content
- [ ] Language switcher UI visible and accessible
- [ ] Collect visitor language data to prioritize which languages to add next
- [ ] Localize, don't just machine-translate (40% higher conversion for localized content)

## Core Web Vitals

### LCP (Largest Contentful Paint) — Target: ≤ 2.5s
- [ ] Identify the LCP element (usually hero image or `<h1>`)
- [ ] Do NOT lazy-load the LCP image
- [ ] Add `<link rel="preload" as="image">` for LCP image
- [ ] Convert images to WebP or AVIF
- [ ] Serve correct dimensions (no oversized images scaled in CSS)
- [ ] Use CDN for static assets

### INP (Interaction to Next Paint) — Target: ≤ 200ms
- [ ] Code-split JavaScript, defer non-critical scripts
- [ ] Avoid long tasks (> 50ms) on the main thread
- [ ] Minimize unnecessary re-renders (React.memo, useMemo where appropriate)

### CLS (Cumulative Layout Shift) — Target: ≤ 0.1
- [ ] Explicit `width` and `height` on all `<img>` and `<video>`
- [ ] Reserve space for ads, embeds, iframes before they load
- [ ] Use `font-display: swap` + `size-adjust` for custom fonts
- [ ] Never insert content above existing content after page load

## Analytics Setup

### Option A: Umami (Recommended for simplicity)
- ~2KB script, no cookies, GDPR/CCPA compliant
- Cloud free tier: 100k events/month, 6-month retention
- Self-hosted: unlimited (needs Postgres — can use Supabase)
- Tracks: pageviews, unique visitors, bounce rate, referrers, OS, browser, country, language

### Option B: Custom Supabase Pageviews
- Create `/api/pageview` endpoint
- Insert row on each page load: path, referrer, country (from IP), language (from Accept-Language), user_agent, timestamp
- Create materialized views for aggregated dashboards
- Sync to Google Sheets for easy visualization

### Google Sheets Analytics Layer
- Always set up alongside primary analytics
- Periodic sync (daily cron or on-demand export)
- Use for: visitor geography charts, referrer pie charts, language distribution, trend lines
- Easy to share with stakeholders without granting DB access
