# Free APIs & Data Sources

Ready-to-use APIs for dashboards, intelligence systems, and smart city projects. Every entry includes the signup URL, free tier limits, and whether a key is needed — so you never have to go hunting.

---

## AI & Summarization

| Service | Free Tier | Key? | Signup |
|---------|-----------|------|--------|
| **Groq** | 14,400 req/day | Yes | https://console.groq.com |
| **OpenRouter** | 50 req/day (fallback) | Yes | https://openrouter.ai |
| **Ollama** | Unlimited (local) | No | https://ollama.ai |
| **Transformers.js** | Unlimited (browser-side ML: embeddings, sentiment, NER, summarization) | No | https://huggingface.co/docs/transformers.js |

```env
GROQ_API_KEY=
OPENROUTER_API_KEY=
```

---

## Weather & Climate

| Service | What It Provides | Free Tier | Key? | Signup |
|---------|-----------------|-----------|------|--------|
| **Open-Meteo** | Forecasts, historical climate (ERA5), air quality, marine | Unlimited (non-commercial) | No | https://open-meteo.com |
| **OpenWeatherMap** | Current weather, forecasts, AQI | 1,000 calls/day | Yes | https://openweathermap.org/api |
| **NOAA CDO** | US historical weather stations, normals, extremes | 1,000/day | Yes | https://www.ncdc.noaa.gov/cdo-web/webservices |
| **Copernicus CDS** | ERA5 reanalysis, seasonal forecasts (EU/ECMWF) | Unlimited | Yes | https://cds.climate.copernicus.eu |

```
# No key needed:
https://api.open-meteo.com/v1/forecast?latitude=7.88&longitude=98.38&current_weather=true

# With key:
https://api.openweathermap.org/data/2.5/weather?q=Phuket&appid={KEY}
```

---

## Air Quality

| Service | What It Provides | Free Tier | Key? | Signup |
|---------|-----------------|-----------|------|--------|
| **OpenAQ** | 10,000+ government monitoring stations globally | 10,000 req/day | Yes | https://docs.openaq.org |
| **IQAir AirVisual** | Real-time AQI, PM2.5, PM10 by city | 10,000/month | Yes | https://www.iqair.com/air-pollution-data-api |
| **PurpleAir** | Hyperlocal crowdsourced air sensors | Point-based | Yes | https://api.purpleair.com |

---

## Natural Disasters & Earth Observation

| Service | What It Provides | Free Tier | Key? | Signup |
|---------|-----------------|-----------|------|--------|
| **USGS Earthquakes** | Global earthquakes, near real-time | Unlimited | No | https://earthquake.usgs.gov/fdsnws/event/1 |
| **NASA EONET** | Active wildfires, storms, volcanoes, floods | Unlimited | No | https://eonet.gsfc.nasa.gov/docs/v3 |
| **NASA FIRMS** | Satellite fire/thermal detection (MODIS, VIIRS) | Unlimited | Yes | https://firms.modaps.eosdis.nasa.gov |
| **NASA EarthData/CMR** | MODIS, Landsat, ASTER satellite data search | Unlimited | Yes (login) | https://cmr.earthdata.nasa.gov |

```
# No key:
https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=2026-01-01&minmagnitude=5
https://eonet.gsfc.nasa.gov/api/v3/events?status=open&category=wildfires
```

---

## Conflict & Geopolitics

| Service | What It Provides | Free Tier | Key? | Signup |
|---------|-----------------|-----------|------|--------|
| **GDELT** | Global news events, tone analysis, entity extraction | Unlimited | No | https://www.gdeltproject.org/api.html |
| **ACLED** | Geocoded conflict events, protests, violence | Full access (researchers) | Yes | https://acleddata.com |
| **UCDP** | Organized violence events, battle deaths (1946–present) | Unlimited | Yes | https://ucdp.uu.se/apidocs |
| **OpenSanctions** | Sanctions lists, PEPs from 100+ sources (UN, EU, OFAC) | Free (non-commercial) | Yes | https://www.opensanctions.org/api |
| **ReliefWeb** | Humanitarian crises, disasters, UN OCHA reports | Unlimited | No | https://reliefweb.int/help/api |

```
# No key:
https://api.gdeltproject.org/api/v2/doc/doc?query=Thailand&mode=ArtList&maxrecords=25&format=json
https://api.reliefweb.int/v1/reports?appname=myapp&filter[field]=country.name&filter[value]=Thailand

# With key:
https://api.acleddata.com/acled/read/?key={KEY}&email={EMAIL}&country=Thailand&limit=100
```

---

## Economics & Finance

| Service | What It Provides | Free Tier | Key? | Signup |
|---------|-----------------|-----------|------|--------|
| **World Bank** | GDP, inflation, trade, poverty for 200+ countries | Unlimited | No | https://datahelpdesk.worldbank.org |
| **IMF Data** | Balance of payments, exchange rates, outlook | Unlimited | No | https://datahelp.imf.org |
| **FRED** | 800,000+ US/intl economic time series | 120 req/min | Yes | https://fred.stlouisfed.org/docs/api |
| **Frankfurter** | ECB currency exchange rates | Unlimited | No | https://www.frankfurter.app |
| **Twelve Data** | Stock, forex, crypto, ETF data | 800 calls/day | Yes | https://twelvedata.com |
| **CoinGecko** | Crypto prices, market cap, 10,000+ coins | 30 calls/min | Yes | https://www.coingecko.com/en/api |
| **Finnhub** | Stock quotes, company data | Free tier | Yes | https://finnhub.io |
| **Alpha Vantage** | Stock OHLCV, forex, crypto, indicators | 25 req/day | Yes | https://www.alphavantage.co |
| **UN Comtrade** | Global import/export trade statistics | 500/hour | Yes | https://comtradeplus.un.org |

```
# No key:
https://api.worldbank.org/v2/country/THA/indicator/NY.GDP.MKTP.CD?format=json&mrv=10
https://api.frankfurter.app/latest?from=THB&to=USD,EUR,JPY,CNY

# With key:
https://api.stlouisfed.org/fred/series/observations?series_id=UNRATE&api_key={KEY}&file_type=json
```

---

## Demographics & Population

| Service | What It Provides | Free Tier | Key? | Signup |
|---------|-----------------|-----------|------|--------|
| **World Bank Population** | Population, fertility, urbanization by country | Unlimited | No | https://data.worldbank.org |
| **UN DESA** | Official population estimates & projections (1950–2100) | Unlimited | No | https://population.un.org/dataportalapi |
| **UNHCR** | Refugees, asylum seekers, IDPs, stateless persons | Unlimited | No | https://api.unhcr.org |
| **OECD Data** | Employment, education, health for OECD countries | Unlimited | No | https://data.oecd.org |
| **Eurostat** | EU demographic, economic, social statistics | Unlimited | No | https://ec.europa.eu/eurostat |
| **UNDP HDR** | Human Development Index by country | Unlimited | No | https://hdr.undp.org |

```
# All no-key:
https://api.worldbank.org/v2/country/all/indicator/SP.POP.TOTL?format=json&mrv=5
https://population.un.org/dataportalapi/api/v1/indicators/?format=json
https://api.unhcr.org/population/v1/population/?year=2023&coo=SYR
```

---

## Aviation & Maritime

| Service | What It Provides | Free Tier | Key? | Signup |
|---------|-----------------|-----------|------|--------|
| **OpenSky Network** | Live ADS-B flight tracking (position, altitude, speed) | 4,000 credits/day (registered) | Optional | https://opensky-network.org |
| **AviationStack** | Flight status, airline routes, airports | 100 req/month | Yes | https://aviationstack.com |
| **AISStream** | Live AIS vessel positions (WebSocket) | Free tier | Yes | https://aisstream.io |
| **BarentsWatch** | Norwegian coastal AIS tracking | Unlimited | Yes | https://www.barentswatch.no/en/developer |

```
# No key:
https://opensky-network.org/api/states/all?lamin=7.5&lomin=98.0&lamax=8.2&lomax=98.5
```

---

## News & Media

| Service | What It Provides | Free Tier | Key? | Signup |
|---------|-----------------|-----------|------|--------|
| **GDELT Doc API** | Global news index, entity extraction, sentiment | Unlimited | No | https://api.gdeltproject.org |
| **The Guardian** | Full-text articles, section browsing | 500/day | Yes | https://open-platform.theguardian.com |
| **New York Times** | Article search, Top Stories, Most Popular | 500/day | Yes | https://developer.nytimes.com |
| **NewsAPI** | 150,000+ sources aggregated | 100/day (dev only) | Yes | https://newsapi.org |
| **Currents API** | Latest news in 30+ languages | 600/day | Yes | https://currentsapi.services |
| **RSS Feeds** | Any publisher's syndicated headlines | Unlimited | No | See list below |

### Key RSS Feeds (No Key Needed)

**Wire Services:**
- Reuters: `https://feeds.reuters.com/reuters/topNews`
- AP News: `https://rsshub.app/apnews/topics/apf-topnews`

**Global:**
- BBC World: `http://feeds.bbci.co.uk/news/world/rss.xml`
- Al Jazeera: `https://www.aljazeera.com/xml/rss/all.xml`
- France 24: `https://www.france24.com/en/rss`
- DW News: `https://rss.dw.com/rdf/rss-en-all`

**Asia-Pacific:**
- Bangkok Post: `https://www.bangkokpost.com/rss/data/topstories.xml`
- Phuket Express: RSS via scraper
- Nikkei Asia: `https://asia.nikkei.com/rss`
- Channel News Asia: `https://www.channelnewsasia.com/api/v1/rss-outbound-feed?_format=xml`
- SCMP: `https://www.scmp.com/rss/91/feed`

**Institutional:**
- UN News: `https://news.un.org/feed/subscribe/en/news/all/rss.xml`
- WHO: `https://www.who.int/rss-feeds/news-english.xml`
- World Bank: `https://blogs.worldbank.org/feed`

---

## Mapping & Geospatial

| Service | What It Provides | Free Tier | Key? | Signup |
|---------|-----------------|-----------|------|--------|
| **Nominatim** | Forward/reverse geocoding (OSM) | 1 req/sec | No | https://nominatim.openstreetmap.org |
| **Photon** | Fast geocoding + autocomplete (OSM) | Fair use | No | https://photon.komoot.io |
| **Overpass API** | Query any OSM feature (roads, buildings, POIs) | Fair use | No | https://overpass-api.de |
| **Mapbox** | Tiles, geocoding, directions, satellite | 50K loads/month | Yes | https://www.mapbox.com |
| **MapTiler** | Vector tiles, satellite, terrain | 100K tiles/month | Yes | https://www.maptiler.com |
| **Stadia Maps** | Stamen styles (terrain, watercolor) | 200K tiles/month | Yes | https://stadiamaps.com |
| **HERE** | Geocoding, traffic, routing | 250K/month | Yes | https://developer.here.com |
| **OpenRouteService** | Routing, isochrones, distance matrix (OSM) | 2,000 req/day | Yes | https://openrouteservice.org |
| **OpenTopoData** | Elevation/terrain from SRTM, ETOPO1 | 100/day | No | https://www.opentopodata.org |
| **ESRI Basemaps** | World Imagery, Topo, Street tiles | Public | No | https://livingatlas.arcgis.com |

```
# No key:
https://nominatim.openstreetmap.org/search?q=Phuket&format=json
https://overpass-api.de/api/interpreter?data=[out:json];node["amenity"="hospital"](7.8,98.2,8.0,98.5);out;
https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}
```

---

## Transit & Transport

| Service | What It Provides | Free Tier | Key? | Signup |
|---------|-----------------|-----------|------|--------|
| **Transitland** | Aggregated GTFS from 1000s of transit agencies | 1,000/day | Yes | https://www.transit.land/api |
| **HERE Traffic** | Real-time traffic flow, incidents | 250K/month | Yes | https://developer.here.com |
| **TomTom Traffic** | Traffic flow, incidents, speed | 2,500/day | Yes | https://developer.tomtom.com |
| **GTFS-RT Feeds** | Real-time transit (per agency) | Varies | Varies | https://gtfs.org/realtime |

---

## Caching & Infrastructure

| Service | What It Provides | Free Tier | Key? | Signup |
|---------|-----------------|-----------|------|--------|
| **Upstash Redis** | Serverless Redis (caching, rate limiting) | 10K commands/day | Yes | https://upstash.com |
| **Cloudflare** | CDN, Workers, R2 storage, Radar API | Generous free tier | Yes | https://cloudflare.com |
| **Convex** | Real-time database, serverless functions | Free tier | Yes | https://www.convex.dev |

---

## Energy

| Service | What It Provides | Free Tier | Key? | Signup |
|---------|-----------------|-----------|------|--------|
| **EIA** | US oil prices, production, inventory | Unlimited | Yes | https://www.eia.gov/opendata |

---

## Quick Copy: .env.example Block

```env
# === AI ===
GROQ_API_KEY=
OPENROUTER_API_KEY=
ANTHROPIC_API_KEY=

# === Data Sources (Free Tier) ===
OPENWEATHERMAP_API_KEY=          # https://openweathermap.org/api
FINNHUB_API_KEY=                 # https://finnhub.io
FRED_API_KEY=                    # https://fred.stlouisfed.org/docs/api
EIA_API_KEY=                     # https://www.eia.gov/opendata
NASA_FIRMS_API_KEY=              # https://firms.modaps.eosdis.nasa.gov
ACLED_EMAIL=                     # https://acleddata.com
ACLED_PASSWORD=
AVIATIONSTACK_API_KEY=           # https://aviationstack.com
AISSTREAM_API_KEY=               # https://aisstream.io
NEWSAPI_KEY=                     # https://newsapi.org
GUARDIAN_API_KEY=                 # https://open-platform.theguardian.com
NYT_API_KEY=                     # https://developer.nytimes.com
TWELVEDATA_API_KEY=              # https://twelvedata.com
COINGECKO_API_KEY=               # https://www.coingecko.com/en/api
OPENAQ_API_KEY=                  # https://docs.openaq.org
CLOUDFLARE_API_TOKEN=            # https://cloudflare.com
UPSTASH_REDIS_REST_URL=          # https://upstash.com
UPSTASH_REDIS_REST_TOKEN=

# === Mapping ===
MAPBOX_ACCESS_TOKEN=             # https://www.mapbox.com
MAPTILER_API_KEY=                # https://www.maptiler.com
HERE_API_KEY=                    # https://developer.here.com

# === No Key Needed (just use these URLs directly) ===
# Open-Meteo:   https://api.open-meteo.com
# World Bank:   https://api.worldbank.org
# GDELT:        https://api.gdeltproject.org
# USGS Quakes:  https://earthquake.usgs.gov
# NASA EONET:   https://eonet.gsfc.nasa.gov
# Frankfurter:  https://api.frankfurter.app
# Nominatim:    https://nominatim.openstreetmap.org
# Overpass:     https://overpass-api.de
# ReliefWeb:    https://api.reliefweb.int
# UN Data:      https://population.un.org/dataportalapi
# UNHCR:        https://api.unhcr.org
# IMF:          https://www.imf.org/external/datamapper/api
```
