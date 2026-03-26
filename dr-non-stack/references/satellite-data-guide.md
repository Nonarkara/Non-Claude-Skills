# Satellite Data API Best Practices (2026)

Modern satellite data workflows use **STAC (SpatioTemporal Asset Catalog) + COG (Cloud Optimized GeoTIFF)** — no more downloading full archives.

---

## Core Standards (Non-Negotiable)

### STAC — Discovery
Universal catalog standard. Structure: **Collections** (datasets) → **Items** (scenes with GeoJSON geometry) → **Assets** (files/bands).

**Query best practices:**
- Use `/search` with `bbox`, `datetime`, `collections`, `limit`
- Filter: `{"eo:cloud_cover": {"lt": 20}}`
- Prefer POST for complex filters, always paginate
- Query catalog FIRST to confirm data exists before requesting assets

### COG — Access
Cloud Optimized GeoTIFF enables HTTP range requests — read only the pixels/bands you need directly from cloud storage. No full file downloads.

**Asset rules:**
- Media type: `image/tiff; application=geotiff; profile=cloud-optimized`
- Assign roles: `data`, `thumbnail`, `overview`, `visual`
- Thumbnails ≤ 600x600 px (PNG/JPEG)

---

## Providers

### NASA Earthdata (CMR / CMR-STAC)
- **Auth**: Earthdata Login (EDL) Bearer token
- **Search**: CMR API or CMR-STAC — filter by concept_id, temporal, bbox
- **Access**: Nearly all data cloud-hosted — use Python libs for in-cloud access
- **Signup**: https://urs.earthdata.nasa.gov
- **STAC**: https://cmr.earthdata.nasa.gov/stac

### Sentinel Hub (Copernicus / ESA)
- **Auth**: OAuth Client ID/Secret → access token (1-hour expiry)
- **Workflow**: Use Requests Builder UI to prototype → Catalog API for availability → Processing API for on-demand imagery
- **Processing API**: Specify AOI, time range, `maxCloudCoverage`, mosaicking (`leastCC`), custom `evalscript` (band math, NDVI, rendering). Returns PNG/JPEG/GeoTIFF in seconds
- **Batch Processing**: For large areas
- **Signup**: https://www.sentinel-hub.com
- **Docs**: https://docs.sentinel-hub.com

### Microsoft Planetary Computer
- **Easiest signed STAC access**
- **Auth**: Auto-signed SAS tokens via `planetary_computer.sign_inplace`
- **STAC**: https://planetarycomputer.microsoft.com/api/stac/v1
- **Docs**: https://planetarycomputer.microsoft.com/docs

### USGS Landsat
- **Dedicated STAC API + COGs**
- **STAC**: https://landsatlook.usgs.gov/stac-server
- **Signup**: https://ers.cr.usgs.gov/register

### Google Earth Engine (GEE)
- **Planetary-scale analysis** — JS/Python API on analysis-ready catalogs (Landsat, Sentinel, etc.)
- **No storage/compute management** — runs on Google infrastructure
- **Signup**: https://earthengine.google.com
- **Best for**: Large-scale time-series analysis, mosaicking, classification

### Commercial Providers

| Provider | Key Features | Resolution | Cost Model | Signup |
|----------|-------------|------------|------------|--------|
| **Planet** | Daily global coverage, NDVI/LAI analytics | 3-5m | Paid, limited free | https://developers.planet.com |
| **Maxar SecureWatch** | Ultra-high res for defense/urban | 30-50cm | Enterprise paid | https://www.maxar.com |
| **Capella Space** | SAR open data + tasking | 25cm SAR | Free open + paid | https://docs.capellaspace.com |
| **Umbra/ICEYE** | SAR open data, tasking | 25cm SAR | Free open + paid | https://umbra.space |
| **EOSDA API Connect** | Archive search, indices, band combos | Varies | Paid | https://doc.eos.com |

### Aggregator Platforms (Multi-Source Access)

| Platform | What It Does | Signup |
|----------|-------------|--------|
| **UP42** | Query multiple providers via one API | https://up42.com |
| **SkyWatch** | Unified search across satellite catalogs | https://skywatch.com |
| **AWS Open Data** | Free access to Sentinel, Landsat, NAIP COGs on S3 | https://registry.opendata.aws |
| **search-satellite-imagery** (GitHub) | Open-source multi-source search tool | https://github.com/satellite-image-deep-learning/search-satellite-imagery |

---

## Python Workflow

### Install
```bash
pip install pystac-client rioxarray stackstac planetary-computer odc-stac
```

### Query + Load (Planetary Computer Example)
```python
import pystac_client
import planetary_computer
import rioxarray

# Connect to catalog
catalog = pystac_client.Client.open(
    "https://planetarycomputer.microsoft.com/api/stac/v1",
    modifier=planetary_computer.sign_inplace
)

# Search — Sentinel-2 L2A, low cloud cover
search = catalog.search(
    collections=["sentinel-2-l2a"],
    bbox=[98.2, 7.7, 98.5, 8.0],  # Phuket
    datetime="2026-01-01/2026-03-01",
    query={"eo:cloud_cover": {"lt": 20}}
)

items = search.get_all_items()

# Pick least cloudy scene
item = min(items, key=lambda i: i.properties["eo:cloud_cover"])

# Load a single band (COG partial read — no full download)
ds = rioxarray.open_rasterio(item.assets["B04"].href)

# Or load multi-item datacube with stackstac
import stackstac
stack = stackstac.stack(items, assets=["B04", "B03", "B02"])
```

### Sentinel Hub Processing API
```python
import requests

token_url = "https://services.sentinel-hub.com/oauth/token"
token_resp = requests.post(token_url, data={
    "grant_type": "client_credentials",
    "client_id": CLIENT_ID,
    "client_secret": CLIENT_SECRET,
})
access_token = token_resp.json()["access_token"]

# Request NDVI for an area
process_url = "https://services.sentinel-hub.com/api/v1/process"
evalscript = """
//VERSION=3
function setup() { return { input: ["B04", "B08"], output: { bands: 1 } }; }
function evaluatePixel(s) {
  let ndvi = (s.B08 - s.B04) / (s.B08 + s.B04);
  return [ndvi];
}
"""

resp = requests.post(process_url, json={
    "input": {
        "bounds": {"bbox": [98.2, 7.7, 98.5, 8.0], "properties": {"crs": "http://www.opengis.net/def/crs/EPSG/0/4326"}},
        "data": [{"type": "sentinel-2-l2a", "dataFilter": {"timeRange": {"from": "2026-01-01T00:00:00Z", "to": "2026-03-01T00:00:00Z"}, "maxCloudCoverage": 20}, "mosaickingOrder": "leastCC"}]
    },
    "output": {"width": 512, "height": 512, "responses": [{"identifier": "default", "format": {"type": "image/tiff"}}]},
    "evalscript": evalscript
}, headers={"Authorization": f"Bearer {access_token}"})
```

---

## Analysis Ready Data (ARD)

Prioritize CEOS-ARD / CARD4L compliant data:
- Standardized radiometric/geometric corrections
- Per-pixel metadata (cloud masks, QA bands)
- Interoperability across sensors

**Processing to ARD:**
- Border noise removal
- Speckle filtering (SAR)
- Atmospheric correction (optical)
- Terrain normalization
- Reprojection to common grid

---

## Scaling

| Approach | When to Use |
|----------|-------------|
| **Google Earth Engine** | Planetary-scale analysis, no infra management |
| **Planetary Computer + Dask** | Custom workflows on Azure-hosted data |
| **Pangeo stack** (xarray + Dask + STAC) | Self-hosted cloud (AWS where Sentinel-2 lives) |
| **Sentinel Hub Batch** | Large-area commercial processing |

**Best practices:**
- Filter early (cloud cover, QA bands)
- Parallelize with Dask for time-series/mosaics
- Pin collection versions for reproducibility
- Log all queries for audit trail

---

## Visualization & Integration

| Tool | Purpose |
|------|---------|
| **TiTiler** | Dynamic tiling from COG/STAC for web maps |
| **QGIS STAC Browser** | Desktop exploration |
| **Sentinel Hub WMS/WCS** | OGC standard tile layers for Mapbox/Leaflet/deck.gl |
| **STAC Browser** | Web-based catalog exploration |

---

## Seamless Multi-Provider Integration

### Abstraction Layer Pattern
Build a single endpoint that maps standard requests (AOI, date, resolution) to vendor-specific formats. Avoid provider-specific code scattered through your app.

```
Client Request (AOI + date + resolution)
    ↓
Abstraction Layer (your unified API)
    ↓ routes to
┌──────────────┬───────────────┬────────────────┐
│ Sentinel Hub │ Planet API    │ Planetary Comp. │
│ (free 10m)   │ (paid 3-5m)  │ (free STAC)    │
└──────────────┴───────────────┴────────────────┘
```

### Authentication & Security
- Store credentials in env vars, never in code
- Use a secure vault or proxy to rotate keys without app changes
- Most providers require per-provider credentials
- Sentinel Hub: OAuth (1-hour expiry, auto-refresh)
- NASA: EDL Bearer token
- Planet: API key in header

### Rate Limiting & Reliability
- Implement client-side throttling with exponential backoff on 429 errors
- Monitor response headers for reset times
- Queue jobs asynchronously for batch processing
- Use libraries like `tenacity` (Python) for retry logic

### Caching & Performance
- Cache tiles/metadata at edge CDN with TTLs (24-48h for static imagery, shorter for dynamic)
- Use WMTS tile services for web apps
- Local storage for frequent AOIs — cuts latency by ~90%
- COG overview levels for fast low-res previews

### Error Handling
- Retry transient errors with backoff; log specifics (`quotaExceeded`, `invalidRequest`)
- Process on-server where possible (Sentinel Hub evalscripts, Planet indices) to reduce bandwidth
- Validate AOI polygons upfront
- Fallback to alternative provider if cloud cover exceeds threshold

---

## Smart City Applications

### Urban Planning Workflows
- **Change detection**: Planet daily + Sentinel SAR for all-weather monitoring
- **Green space**: NDVI from Sentinel-2 for vegetation health tracking
- **Urban heat islands**: Thermal bands (Landsat 8/9 TIRS, Sentinel-3)
- **Construction monitoring**: High-res change detection (Planet/Maxar)
- **Flood risk**: SAR-based water extent mapping (Sentinel-1, Capella)

### Dashboard Integration
Feed satellite data into web dashboards via:
1. Sentinel Hub WMS/WMTS → Leaflet/Mapbox/deck.gl tile layers
2. TiTiler → Dynamic COG tiling for custom visualizations
3. Pre-computed indices stored in Supabase for time-series charts
4. Automated pipelines: STAC search → process → cache → serve

---

## Common Pitfalls

- Downloading full archives instead of COG partial reads
- Ignoring cloud cover / QA bands
- Hardcoding URLs instead of using STAC links
- Using non-COG formats (slow, expensive)
- Not checking data availability before processing requests
- Skipping atmospheric correction on optical data

---

## .env.example Block

```env
# === Satellite Data Providers ===
EARTHDATA_TOKEN=                     # https://urs.earthdata.nasa.gov
SENTINEL_HUB_CLIENT_ID=             # https://www.sentinel-hub.com
SENTINEL_HUB_CLIENT_SECRET=
PLANET_API_KEY=                      # https://developers.planet.com
MAXAR_API_KEY=                       # https://www.maxar.com
EOSDA_API_KEY=                       # https://doc.eos.com
UP42_PROJECT_ID=                     # https://up42.com
UP42_PROJECT_API_KEY=
# Planetary Computer: no key needed (use pystac_client + modifier)
# GEE: authenticate via `earthengine authenticate` CLI
# USGS: https://ers.cr.usgs.gov/register
# AWS Open Data: no key for public Sentinel/Landsat COGs on S3
```

---

## Dr. Non's Satellite Toolkit Integration

Dr. Non built the **DrNon Global Satellite Toolkit** (https://github.com/Nonarkara/DrNon-Global-Satellite-Toolkit) with a resilience-first basemap fallback chain: Mapbox → OSM → LongDo → ESRI → CartoDB → Stadia → Gradient. When building geospatial projects, integrate this fallback system so the map ALWAYS renders imagery even when individual tile providers fail.
