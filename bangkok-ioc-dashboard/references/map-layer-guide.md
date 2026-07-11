# Map Layer Guide — Adding Layers to the IOC Map

## Architecture

The map uses Leaflet 1.9 with SVG renderer. Layers are controlled by the `layers: string[]` prop passed from `App.tsx` to `InteractiveMap.tsx`.

## Adding a New Operational Layer

### 1. Add to `LayerId` type

`apps/web/src/InteractiveMap.tsx`:
```typescript
type LayerId =
  | "smart-city-thailand"
  | "my-new-layer"  // Add here
  // ...
```

### 2. Add color

```typescript
const layerColors: Record<LayerId, string> = {
  "my-new-layer": "#a855f7",  // Choose a distinct color
  // ...
};
```

### 3. Add to toggle list

`apps/web/src/App.tsx`:
```typescript
const operationalLayerToggleIds = [
  "my-new-layer",  // Add here
  // ...
] as const;
```

### 4. Add map layer config seed

`packages/shared/src/mockData.ts`:
```typescript
{
  id: "my-new-layer",
  label: { th: "ชั้นข้อมูลใหม่", en: "My Layer" },
  active: false,
  color: "#a855f7",
  kind: "signal",
  defaultViews: ["bangkok"],
  sourceId: "my-source",
  legendLabel: "My Data",
  zIndex: 45
}
```

### 5. Add to Bangkok defaults (optional)

`apps/web/src/App.tsx` → `getDefaultLayers()`:
```typescript
if (citySlug === "bangkok") {
  return ["my-new-layer", ...otherLayers];
}
```

## Rendering Behavior

### Points → `L.circleMarker`
- Radius: 4-8px depending on layer
- `fillOpacity`: 0.4-0.7
- Click handler → populates `SelectedFeatureInfo` for detail card
- Properties shown in popup (max 5, sorted by priority)

### Polygons → `L.polygon`
- `fillOpacity`: 0.06-0.14 (very subtle)
- `weight`: 1.5-2
- BMA districts use 0.06 opacity

### Lines → `L.polyline`
- `weight`: 4-5
- `opacity`: 0.82
- Disaster lines: `dashArray: "10 6"`

## Feature Detail Card

When a point is clicked, the `map-feature-card` component shows:
- Layer badge (color-coded border)
- Title + description
- Properties grid (2 columns, max 6 properties)
- Coordinates + source name
- Close button

Properties are auto-humanized via `humanizePropertyKey()` (camelCase → Title Case).

Hidden keys: `citySlug`, `sampleKind`, `sampleLabel`, `sampleRank`, `cityCenter`

## Popup Priority Keys

Properties are sorted by priority for popup display:
```typescript
const popupPriorityKeys = [
  "city", "region", "status", "aqi", "pm25", "pm10",
  "temperature", "humidity", "severity", "category"
];
```

## Satellite/EO Layers

EO layers use NASA GIBS WMTS tiles and are managed separately from operational layers. They render as tile overlays with blend modes (multiply, screen, overlay).

Configuration in `apps/web/src/eoTiles.ts`.
