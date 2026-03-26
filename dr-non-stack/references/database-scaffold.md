# Database Scaffold Guide

> CRITICAL: Every project gets a database from day one. No exceptions. Dr. Non has lost visitor data in past projects because this was skipped.

## Decision Tree

| Project Type | Database | Reason |
|-------------|----------|--------|
| Web service, dashboard, dynamic data | **Supabase** (PostgreSQL) | Scalable, free tier generous, real-time subscriptions, auth built-in |
| Static site, lightweight, edge-deployed | **SQLite** (better-sqlite3 or D1) | Zero config, file-based, no external dependency |
| Any project | **+ Google Sheets** | Parallel analytics layer for easy visualization and sharing |

## Supabase Setup

### 1. Create Project
1. Go to [supabase.com](https://supabase.com) → New Project
2. Name: match the GitHub repo name
3. Region: closest to primary audience (Singapore for Thailand projects)
4. Save the project URL and anon key

### 2. Environment Variables
```env
# .env.local (never committed)
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ...   # Server-side only, never expose
```

```env
# .env.example (committed)
NEXT_PUBLIC_SUPABASE_URL=your-supabase-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

### 3. Install
```bash
npm install @supabase/supabase-js
```

### 4. Apply Base Schema
Use the schema in [templates/supabase-schema.sql](../templates/supabase-schema.sql). Every project gets:
- `pageviews` table — visitor analytics
- `content_cache` table — for dashboards storing scraped data

### 5. Client Setup
```typescript
// lib/supabase.ts
import { createClient } from '@supabase/supabase-js'

export const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
)
```

### Pro Plan Resources
- 8 GB database storage (expandable)
- 250 GB bandwidth per month
- 100,000 monthly active users (auth)
- 100 GB file storage
- 2 million edge function invocations (expandable)
- Daily automatic backups
- No project pausing — always-on

## SQLite Alternative

For static or lightweight projects where Supabase is overkill.

```bash
npm install better-sqlite3
```

```typescript
// lib/db.ts
import Database from 'better-sqlite3'
const db = new Database('data.db')

// Same schema concept as Supabase
db.exec(`
  CREATE TABLE IF NOT EXISTS pageviews (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    path TEXT NOT NULL,
    referrer TEXT,
    country TEXT,
    language TEXT,
    user_agent TEXT,
    created_at TEXT DEFAULT (datetime('now'))
  );
  CREATE INDEX IF NOT EXISTS idx_pageviews_created ON pageviews(created_at);
  CREATE INDEX IF NOT EXISTS idx_pageviews_path ON pageviews(path);
`)
```

## Pageview Tracking Endpoint

### Next.js (App Router)
```typescript
// app/api/pageview/route.ts
import { supabase } from '@/lib/supabase'
import { NextRequest, NextResponse } from 'next/server'

export async function POST(req: NextRequest) {
  const { path, referrer } = await req.json()

  const country = req.headers.get('cf-ipcountry')
    || req.geo?.country
    || 'unknown'
  const language = req.headers.get('accept-language')?.split(',')[0] || 'unknown'
  const userAgent = req.headers.get('user-agent') || 'unknown'

  await supabase.from('pageviews').insert({
    path,
    referrer,
    country,
    language,
    user_agent: userAgent,
  })

  return NextResponse.json({ ok: true })
}
```

### Client-Side Tracker
```typescript
// lib/track.ts
export function trackPageview() {
  if (typeof window === 'undefined') return
  fetch('/api/pageview', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      path: window.location.pathname,
      referrer: document.referrer || null,
    }),
  }).catch(() => {}) // Fire and forget
}
```

## Google Sheets Backup Layer

### Purpose
- Easy visualization: charts, pivot tables, graphs
- Easy sharing: stakeholders can view without DB access
- Quick insights: geography heatmaps, language distribution, referrer analysis

### Setup
1. Create a Google Sheet (e.g., "ProjectName — Analytics")
2. Create a Google Cloud service account with Sheets API access
3. Share the sheet with the service account email
4. Store credentials in environment variables

### Sync Pattern
```typescript
// scripts/sync-to-sheets.ts
// Run via cron (daily) or on-demand
// 1. Query Supabase for recent pageviews
// 2. Append rows to Google Sheet
// 3. Columns: date, path, referrer, country, language, count
```

### What to Track in Sheets
- **Daily visitors**: date, unique visitors, total pageviews
- **Geography**: country, count (use for deciding which languages to add)
- **Referrers**: source, count (understand where traffic comes from)
- **Languages**: browser language, count (prioritize translations)
- **Top pages**: path, views (understand what content works)

## Dashboard-Specific: Content Cache

For dashboards that scrape news, data, or metrics:

```sql
CREATE TABLE content_cache (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  source TEXT NOT NULL,          -- e.g., 'phuket_express', 'bangkok_post'
  title TEXT NOT NULL,
  summary TEXT,
  url TEXT,
  category TEXT,                 -- e.g., 'safety', 'tourism', 'infrastructure'
  fetched_at TIMESTAMPTZ DEFAULT now(),
  metadata JSONB DEFAULT '{}'    -- flexible field for source-specific data
);
```

This enables:
- **Longitudinal trend analysis**: How stories about a topic evolve over weeks/months
- **Scale and magnitude understanding**: How frequently certain issues appear
- **Category distribution**: What types of content dominate over time
