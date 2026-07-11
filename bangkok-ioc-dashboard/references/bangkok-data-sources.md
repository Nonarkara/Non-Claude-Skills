# Bangkok Data Sources — API Reference

## Free Sources (No API Key Required)

### Traffy Fondue — Citizen Reports
- **Endpoint:** `GET https://publicapi.traffy.in.th/ud/search?limit=200`
- **Auth:** None
- **Rate limit:** Unknown, poll every 30s safely
- **Response:** Array of report objects with `ticket_id`, `type`, `state`, `latitude`, `longitude`, `district`, `photo_url`, `timestamp`, `description`
- **Status mapping:** `เสร็จสิ้น` = resolved, `ดำเนินการ` = in-progress, else = received
- **Category mapping:** `ถนน` = Road damage, `น้ำท่วม` = Flooding, `ขยะ` = Waste, `ไฟ` = Lighting, `ทางเท้า` = Sidewalk, `ระบายน้ำ` = Drainage, `ต้นไม้` = Trees
- **Bangkok bounds filter:** lat 13.45-13.95, lon 100.35-100.85

### Air4Thai (PCD) — Official AQI Stations
- **Endpoint:** `GET http://air4thai.pcd.go.th/services/getNewAQI_JSON.php`
- **Auth:** None
- **Response:** `{ stations: [{ stationID, nameTH, nameEN, lat, long, AQILast: { AQI: { aqi } }, PM25: { value }, PM10: { value } }] }`
- **Filter:** Only stations within Bangkok bounds

### WAQI — AQI Map Bounds
- **Endpoint:** `GET https://api.waqi.info/v2/map/bounds?latlng=13.45,100.35,13.95,100.85&networks=all&token=demo`
- **Auth:** Free `demo` token (rate-limited), register at aqicn.org for production token
- **Response:** `{ data: [{ uid, aqi, lat, lon, station: { name } }] }`

### TMD — Thai Meteorological Department
- **RSS:** `GET https://www.tmd.go.th/api/xml/region-daily-forecast?regionid=7` (Central Thailand)
- **Auth:** None
- **Format:** XML RSS, parse with `fast-xml-parser`
- **Data:** Daily forecasts, warnings, temperature ranges

### BMA GIS — ArcGIS FeatureServer
- **Base:** `https://bmagis.bangkok.go.th/arcgis/rest/services`
- **Auth:** None (public layers)
- **Query pattern:** `/{service}/FeatureServer/0/query?where=1%3D1&outFields=*&f=geojson&resultRecordCount=500`
- **Key services:**
  - `BMA/FLOODGATE` — Flood gate locations
  - `BMA/PublicHealthCenter` — Health centers
  - `BMA/District` — District boundaries (polygons)
- **Response:** Standard GeoJSON FeatureCollection

### Open-Meteo — Weather + Air Quality
- **Weather:** `GET https://api.open-meteo.com/v1/forecast?latitude=13.7563&longitude=100.5018&current=temperature_2m,relative_humidity_2m,wind_speed_10m&timezone=Asia/Bangkok`
- **Air Quality:** `GET https://air-quality-api.open-meteo.com/v1/air-quality?latitude=...&longitude=...&current=pm10,pm2_5,us_aqi&timezone=Asia/Bangkok`
- **Auth:** None, generous free tier

### BMA Flood — Flood Status
- **Primary:** `GET https://dds.bangkok.go.th/api/flood_status` (may not have public API)
- **Fallback:** Use Open-Meteo precipitation as proxy — fetch 24h hourly data, sum for total rainfall, classify: >100mm=critical, >60mm=warning, >30mm=watch

## Paid/Registered Sources

### OpenAQ — Air Quality Stations
- **Endpoint:** `GET https://api.openaq.org/v3/locations?country=TH&limit=6`
- **Auth:** Optional API key (`OPENAQ_API_KEY`)

### NewsAPI — News Coverage
- **Endpoint:** `GET https://newsapi.org/v2/everything?q=Bangkok&apiKey=KEY`
- **Auth:** Required (`NEWS_API_KEY`)

### Copernicus/Sentinel Hub — Satellite Imagery
- **Auth:** OAuth2 (`COPERNICUS_CLIENT_ID`, `COPERNICUS_CLIENT_SECRET`)
- **Token URL:** `https://identity.dataspace.copernicus.eu/auth/realms/CDSE/protocol/openid-connect/token`
- **Process API:** `https://sh.dataspace.copernicus.eu/api/v1/process`

## NASA GIBS — Earth Observation Tiles (Free)

Tile URL pattern:
```
https://gibs.earthdata.nasa.gov/wmts/epsg3857/best/{layer}/default/{date}/{tileMatrix}/{z}/{y}/{x}.png
```

Key layers for Bangkok:
- `MODIS_Combined_Value_Added_AOD` — Aerosol (haze/dust)
- `IMERG_Precipitation_Rate` — Rainfall
- `MODIS_Terra_NDVI_8Day` — Vegetation
- `MODIS_Aqua_Brightness_Temp_Band31_Day` — Thermal (use cautiously, washes out urban areas)
