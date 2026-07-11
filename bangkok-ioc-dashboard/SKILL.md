---
name: bangkok-ioc-dashboard
description: >-
  Bangkok Governor's Integrated Operations Center (IOC) dashboard system.
  Use when building a city monitoring dashboard, creating an IOC, setting up
  a governor's dashboard, building a smart city war room display, creating
  a real-time city operations center, or when the user says "IOC", "operations
  center", "war room", "city monitor", "Bangkok dashboard", "governor dashboard",
  "smart city dashboard", or "situation room". Also use when integrating Thai
  government data sources (Traffy Fondue, Air4Thai, TMD, BMA GIS), building
  map-based dashboards with Leaflet, or creating dark-themed data-dense displays
  for large screens.
---

# Bangkok Governor's IOC Dashboard

Real-time city monitoring for 72" war room displays. Dark theme, satellite basemap, 23 data adapters, 30-second polling.

## Architecture

Monorepo with 3 workspaces:

```
apps/web/     → React 18 + Vite + Leaflet (dark IOC theme)
apps/api/     → Fastify 5 (adapter-based data aggregation)
packages/shared/ → TypeScript types + mock data
```

No database — in-memory store with JSON persistence. All external APIs proxied through Fastify adapters.

## Dark IOC Theme

```css
--bg: #0a0e14;        /* Deep navy-black */
--panel: #111720;     /* Card background */
--ink: #e8edf3;       /* Primary text */
--muted: #6b7a8d;     /* Secondary text */
--blue: #38bdf8;      /* Primary accent (interactive, links) */
--green: #34d399;     /* Positive state */
--amber: #fbbf24;     /* Warning state */
--red: #f87171;       /* Alert/critical state */
```

Typography: **Manrope** headings (700/800), **Inter** body (400/500), **SF Mono** data values. Font-feature-settings: `"tnum" 1` for tabular numbers globally.

Glassmorphism on cards: `background: rgba(17, 23, 32, 0.92)` + `backdrop-filter: blur(12px)`.

## KPI Strip Pattern

6-metric grid with sparklines and alert thresholds:

```
┌─────┬─────────┬──────────┬──────┬───────┬─────────┐
│ AQI │ Reports │ Resolved │ Temp │ Flood │ Rain24h │
│ 68  │   347   │   72%    │ 31°C │   0   │  0mm    │
│ ─── │  ────   │  ────    │ ──── │  ──── │  ────   │ ← sparklines
└─────┴─────────┴──────────┴──────┴───────┴─────────┘
```

Alert thresholds that trigger pulse animation:
- AQI > 150 → red pulse
- Reports > 500 → red pulse
- Flood level != "normal" → red pulse
- Rain > 50mm → red pulse

Data-change animation: cyan flash when values update (distinct from red alert).

## Adapter Pattern

Every external data source follows the same pattern:

1. **Create adapter** in `apps/api/src/adapters/myAdapter.ts`
2. **Define response interface** (raw API shape)
3. **Use `fetchJsonOrNull(url)`** for fault-tolerant fetching
4. **Transform** raw data into `GeoFeatureRecord[]` for map + domain patches
5. **Return `buildResult()`** with `sourceId`, `status`, `mapFeatureCollections`, patches
6. **Register** in `apps/api/src/services/sync.ts` → `Promise.allSettled([...])`
7. **Add store field** if needed (e.g., `traffyFonduePatch`)
8. **Add API route** in `apps/api/src/server.ts`

> See [references/adapter-pattern.md](references/adapter-pattern.md) for template code.

## Map Layer Integration

Each layer needs:
1. Add to `LayerId` union type in `InteractiveMap.tsx`
2. Add color to `layerColors` record
3. Add to `operationalLayerToggleIds` array in `App.tsx`
4. Add `MapLayerConfig` seed in `mockData.ts`
5. Adapter returns `mapFeatureCollections` with matching `layerId`

Point features render as `L.circleMarker`. Polygons as `L.polygon`. Click → feature detail card with structured properties.

> See [references/map-layer-guide.md](references/map-layer-guide.md) for details.

## Bangkok Data Sources (Free, No API Key)

| Source | Endpoint | Data |
|--------|----------|------|
| Traffy Fondue | `GET publicapi.traffy.in.th/ud/search` | Citizen reports with GPS |
| Air4Thai (PCD) | `GET air4thai.pcd.go.th/services/getNewAQI_JSON.php` | Official AQI stations |
| WAQI | `GET api.waqi.info/v2/map/bounds?token=demo` | AQI station network |
| TMD Weather | `GET tmd.go.th/api/xml/region-daily-forecast?regionid=7` | Forecasts + warnings |
| BMA GIS | `GET bmagis.bangkok.go.th/arcgis/rest/services/BMA/*/FeatureServer/0/query?f=geojson` | Flood gates, health centers |
| Open-Meteo | `GET api.open-meteo.com/v1/forecast` | Weather + AQI mesh |

> See [references/bangkok-data-sources.md](references/bangkok-data-sources.md) for full details.

## Real-Time Features

- **Polling**: 30s for Traffy/Flood, 3min for other sources
- **Auto-rotate**: Cycles Flood Watch → Haze Watch → Green Cover presets every 60s
- **Sitrep export**: One-click markdown daily brief to clipboard
- **Live clock**: BKK time with pulse dot in header
- **Satellite basemap**: Esri World Imagery as default

## Micro-Interactions (Red Dot Level)

- `@keyframes count-pop` — KPI numbers scale+brighten on data change
- `@keyframes data-refresh` — cyan border flash on value update
- `@keyframes sparkline-draw` — stroke-dashoffset animation on sparkline render
- `@keyframes shimmer` — gradient sweep for loading placeholders
- `@keyframes kpi-pulse` — red glow for alert threshold breach
- Panel hover: `translateY(-1px)` + shadow increase
- Map points: `transition: opacity 0.3s ease` for fade-in
- Feature card: `card-slide-in` with cubic-bezier easing
- Focus-visible: 2px cyan outline on all interactive elements

## Deployment

Render.yaml blueprint: static web (Vite build) + Fastify API (Node 20).

```
ALLOW_LIVE_FETCH=true
VITE_DEFAULT_CITY=bangkok
VITE_DEFAULT_BASEMAP=satellite
VITE_SITE_TITLE=Bangkok Governor's IOC
```

> See [references/ioc-design-system.md](references/ioc-design-system.md) for full design system reference.
