# Adapter Pattern — Adding a New Data Source

## Overview

Every external API in the IOC dashboard follows the same adapter pattern. An adapter is a single TypeScript file that fetches data, transforms it, and returns a standardized `AdapterSyncResult`.

## Step-by-Step

### 1. Create the adapter file

`apps/api/src/adapters/mySourceAdapter.ts`

```typescript
import type { GeoFeatureRecord, MapFeatureCollection } from "@smart-city/shared";
import { buildResult, fetchJsonOrNull } from "./common.js";
import { config } from "../config.js";

const SOURCE_ID = "my-source";
const SOURCE_URL = "https://example.com";

interface MyApiResponse {
  items?: { id: string; name: string; lat: number; lon: number; value: number }[];
}

export async function syncMySource() {
  const payload = await fetchJsonOrNull<MyApiResponse>(config.mySourceEndpoint);
  const items = payload?.items ?? [];

  if (items.length === 0) {
    return buildResult({
      sourceId: SOURCE_ID,
      status: "stale",
      message: "No data from source. Retaining cache.",
      sourceUrl: SOURCE_URL
    });
  }

  const fetchedAt = new Date().toISOString();
  const sourceMeta = {
    sourceName: "My Source",
    sourceUrl: SOURCE_URL,
    fetchedAt,
    publishedAt: fetchedAt,
    freshnessStatus: "live" as const,
    confidence: 0.85,
    fallbackMode: "live" as const
  };

  const features: GeoFeatureRecord[] = items.map((item) => ({
    id: `my-source-${item.id}`,
    layerId: "my-layer",
    geometryType: "Point",
    coordinates: [item.lon, item.lat],
    title: item.name,
    description: `Value: ${item.value}`,
    properties: { value: item.value, citySlug: "bangkok" },
    source: sourceMeta
  }));

  const mapCollection: MapFeatureCollection = {
    layerId: "my-layer",
    updatedAt: fetchedAt,
    features,
    source: sourceMeta
  };

  return buildResult({
    sourceId: SOURCE_ID,
    status: "live",
    message: `${items.length} items synced.`,
    sourceUrl: SOURCE_URL,
    mapFeatureCollections: [mapCollection]
  });
}
```

### 2. Add config entry

`apps/api/src/config.ts`:
```typescript
mySourceEndpoint: process.env.MY_SOURCE_ENDPOINT ?? "https://api.example.com/data",
```

### 3. Register in sync loop

`apps/api/src/services/sync.ts`:
```typescript
import { syncMySource } from "../adapters/mySourceAdapter.js";

// Add to Promise.allSettled array:
syncMySource(),

// Add to fallbackIds array:
"my-source",
```

### 4. Add types (if new state field needed)

`packages/shared/src/types.ts` — add interface
`apps/api/src/adapters/common.ts` — add optional patch field to `AdapterSyncResult`
`apps/api/src/data/store.ts` — add to `StoreState`, handle in `applySyncResults()`

### 5. Add API route (if new endpoint needed)

`apps/api/src/server.ts`:
```typescript
app.get("/api/my-data", async () => store.getMyData());
```

### 6. Add mock data

`packages/shared/src/mockData.ts` — seed data + map layer config + source record

### 7. Add frontend query

`apps/web/src/App.tsx`:
```typescript
const myQuery = useQuery({
  queryKey: ["my-data"],
  queryFn: () => fetchFromApi<MyType>("/api/my-data", fallback, validator),
  refetchInterval: LIVE_POLL_INTERVAL_MS,
});
```

## Key Utilities

- `fetchJsonOrNull<T>(url, init?)` — Returns parsed JSON or null (never throws)
- `fetchTextOrNull(url, init?)` — Returns text or null (for XML/RSS)
- `buildResult(input)` — Creates standardized `AdapterSyncResult`
- `buildSyncRecord(result)` — Creates `SyncHealthRecord` for status tracking
