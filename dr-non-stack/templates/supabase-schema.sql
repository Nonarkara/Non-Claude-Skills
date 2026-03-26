-- Dr-Non-Stack: Base Supabase Schema
-- Apply this to every new Supabase project

-- ============================================
-- PAGEVIEWS — Visitor analytics (ALWAYS required)
-- ============================================
CREATE TABLE IF NOT EXISTS pageviews (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  path TEXT NOT NULL,
  referrer TEXT,
  country TEXT,
  language TEXT,
  user_agent TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Indexes for common queries
CREATE INDEX IF NOT EXISTS idx_pageviews_created_at ON pageviews(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_pageviews_path ON pageviews(path);
CREATE INDEX IF NOT EXISTS idx_pageviews_country ON pageviews(country);
CREATE INDEX IF NOT EXISTS idx_pageviews_language ON pageviews(language);

-- Row Level Security
ALTER TABLE pageviews ENABLE ROW LEVEL SECURITY;

-- Allow inserts from anonymous users (for tracking)
CREATE POLICY "Allow anonymous inserts" ON pageviews
  FOR INSERT TO anon
  WITH CHECK (true);

-- Allow reads only for authenticated/service role (for dashboards)
CREATE POLICY "Allow authenticated reads" ON pageviews
  FOR SELECT TO authenticated
  USING (true);

-- ============================================
-- CONTENT_CACHE — For dashboards storing scraped data
-- ============================================
CREATE TABLE IF NOT EXISTS content_cache (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  source TEXT NOT NULL,
  title TEXT NOT NULL,
  summary TEXT,
  url TEXT,
  category TEXT,
  fetched_at TIMESTAMPTZ DEFAULT now(),
  metadata JSONB DEFAULT '{}'
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_content_source ON content_cache(source);
CREATE INDEX IF NOT EXISTS idx_content_category ON content_cache(category);
CREATE INDEX IF NOT EXISTS idx_content_fetched ON content_cache(fetched_at DESC);

-- Row Level Security
ALTER TABLE content_cache ENABLE ROW LEVEL SECURITY;

-- Allow service role full access
CREATE POLICY "Service role full access" ON content_cache
  FOR ALL TO service_role
  USING (true)
  WITH CHECK (true);

-- Allow anonymous/authenticated reads
CREATE POLICY "Public reads" ON content_cache
  FOR SELECT TO anon, authenticated
  USING (true);

-- ============================================
-- USEFUL VIEWS — Pre-built analytics queries
-- ============================================

-- Daily visitor summary
CREATE OR REPLACE VIEW daily_visitors AS
SELECT
  DATE(created_at) AS date,
  COUNT(*) AS total_views,
  COUNT(DISTINCT user_agent) AS approx_unique_visitors,
  COUNT(DISTINCT path) AS unique_pages
FROM pageviews
GROUP BY DATE(created_at)
ORDER BY date DESC;

-- Country breakdown
CREATE OR REPLACE VIEW visitors_by_country AS
SELECT
  country,
  COUNT(*) AS views,
  COUNT(DISTINCT user_agent) AS approx_visitors
FROM pageviews
WHERE country IS NOT NULL
GROUP BY country
ORDER BY views DESC;

-- Language breakdown (for deciding which translations to add)
CREATE OR REPLACE VIEW visitors_by_language AS
SELECT
  language,
  COUNT(*) AS views,
  COUNT(DISTINCT user_agent) AS approx_visitors
FROM pageviews
WHERE language IS NOT NULL
GROUP BY language
ORDER BY views DESC;

-- Top referrers
CREATE OR REPLACE VIEW top_referrers AS
SELECT
  referrer,
  COUNT(*) AS views
FROM pageviews
WHERE referrer IS NOT NULL AND referrer != ''
GROUP BY referrer
ORDER BY views DESC
LIMIT 50;

-- Top pages
CREATE OR REPLACE VIEW top_pages AS
SELECT
  path,
  COUNT(*) AS views
FROM pageviews
GROUP BY path
ORDER BY views DESC;
