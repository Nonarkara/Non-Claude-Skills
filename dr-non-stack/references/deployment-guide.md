# Deployment Guide

## Render — Web Services

### When to Use
Any project with API routes, server-side rendering, dynamic data, or a backend.

### render.yaml Template (Next.js)

```yaml
services:
  - type: web
    runtime: node
    name: project-name
    repo: https://github.com/Nonarkara/project-name
    branch: main
    plan: free
    region: oregon
    buildCommand: npm ci && npm run build
    startCommand: npm start -- --hostname 0.0.0.0 --port $PORT
    healthCheckPath: /api/status
    autoDeploy: true
    envVars:
      - key: NODE_ENV
        value: production
      - key: NEXT_PUBLIC_SUPABASE_URL
        sync: false
      - key: NEXT_PUBLIC_SUPABASE_ANON_KEY
        sync: false
      - key: SUPABASE_SERVICE_ROLE_KEY
        sync: false
```

### render.yaml Template (Vite Static)

```yaml
services:
  - type: web
    runtime: static
    name: project-name
    repo: https://github.com/Nonarkara/project-name
    branch: main
    plan: free
    region: oregon
    buildCommand: npm ci && npm run build
    staticPublishPath: ./dist
    autoDeploy: true
    routes:
      - type: rewrite
        source: /*
        destination: /index.html
    headers:
      - path: /assets/*
        name: Cache-Control
        value: public, max-age=31536000, immutable
```

### Health Check Endpoint

```typescript
// app/api/status/route.ts (Next.js App Router)
import { NextResponse } from 'next/server'

export async function GET() {
  return NextResponse.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    version: process.env.npm_package_version || '1.0.0',
  })
}
```

### Environment Variables on Render
1. Go to Render dashboard → Service → Environment
2. Add each secret key manually (these are the `sync: false` vars)
3. Never commit actual values — only `.env.example` with placeholders

### Render Free Tier Notes
- Spins down after 15 minutes of inactivity
- First request after spin-down takes ~30-60 seconds (cold start)
- 750 hours/month of free usage
- For production: consider upgrading to Starter ($7/month) to avoid cold starts

## GitHub Pages — Static Sites

### When to Use
Static sites where Dr. Non wants the GitHub domain (looks techy and technical).

### GitHub Actions Workflow

```yaml
# .github/workflows/deploy.yml
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: pages
  cancel-in-progress: true

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
      - run: npm ci
      - run: npm run build
      - uses: actions/upload-pages-artifact@v3
        with:
          path: ./dist  # or ./out for Next.js static export

  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - id: deployment
        uses: actions/deploy-pages@v4
```

### GitHub Pages Setup
1. Go to repo Settings → Pages
2. Source: GitHub Actions
3. The workflow handles the rest
4. URL will be: `https://nonarkara.github.io/project-name/`

### Vite Config for GitHub Pages

```typescript
// vite.config.ts
export default defineConfig({
  base: '/project-name/',  // Must match repo name
  // ... other config
})
```

## Common Patterns

### .env.example (Always Committed)
```env
# Database
NEXT_PUBLIC_SUPABASE_URL=your-supabase-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

# Analytics (if using Umami)
NEXT_PUBLIC_UMAMI_WEBSITE_ID=your-umami-id

# API Keys
ANTHROPIC_API_KEY=your-claude-api-key

# Google Sheets (if using sheets backup)
GOOGLE_SHEETS_ID=your-sheet-id
GOOGLE_SERVICE_ACCOUNT_EMAIL=your-sa-email
GOOGLE_PRIVATE_KEY=your-private-key
```

### .gitignore Essentials
```
node_modules/
.env
.env.local
.env.production
dist/
.next/
*.db
```

### CLAUDE.md Template
Every project should have a CLAUDE.md at the root:

```markdown
# Project Name

## Build & Run
- `npm install` — install dependencies
- `npm run dev` — start development server
- `npm run build` — production build
- `npm start` — start production server

## Architecture
- Framework: Next.js / Vite + React
- Database: Supabase (PostgreSQL)
- Deployment: Render / GitHub Pages
- Analytics: Supabase pageviews + Google Sheets

## Key Files
- `app/` or `src/` — main application code
- `lib/supabase.ts` — database client
- `lib/track.ts` — pageview tracking
- `app/api/pageview/route.ts` — analytics endpoint
- `render.yaml` — deployment config

## Conventions
- TypeScript strict mode
- Tailwind CSS for styling
- Inter (body) + Manrope (headings)
- Mobile-first responsive design
```
