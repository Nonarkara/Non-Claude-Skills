/**
 * Dr-Non-Stack: Reusable SEO Head Component
 *
 * Usage (Next.js App Router — layout.tsx or page.tsx):
 *
 *   export const metadata = generateMetadata({
 *     title: 'Page Title',
 *     description: 'Page description for search engines.',
 *     path: '/about',
 *   })
 *
 * Usage (Vite + React — with react-helmet-async):
 *
 *   <SEOHead
 *     title="Page Title"
 *     description="Page description."
 *     path="/about"
 *   />
 */

// ============================================
// NEXT.JS APP ROUTER VERSION
// ============================================

import type { Metadata } from 'next'

interface SEOConfig {
  title: string
  description: string
  path?: string
  image?: string
  type?: 'website' | 'article'
  locale?: string
  noIndex?: boolean
}

// Update these per project
const SITE_CONFIG = {
  name: 'Project Name',
  url: 'https://your-domain.com',
  defaultImage: '/og-image.png', // 1200x630px
  defaultLocale: 'en',
  twitterHandle: '@nonarkara',
}

export function generateMetadata({
  title,
  description,
  path = '',
  image,
  type = 'website',
  locale = SITE_CONFIG.defaultLocale,
  noIndex = false,
}: SEOConfig): Metadata {
  const url = `${SITE_CONFIG.url}${path}`
  const ogImage = image || SITE_CONFIG.defaultImage

  return {
    title: `${title} | ${SITE_CONFIG.name}`,
    description,
    metadataBase: new URL(SITE_CONFIG.url),
    alternates: {
      canonical: url,
    },
    openGraph: {
      title,
      description,
      url,
      siteName: SITE_CONFIG.name,
      images: [
        {
          url: ogImage,
          width: 1200,
          height: 630,
          alt: title,
        },
      ],
      locale,
      type,
    },
    twitter: {
      card: 'summary_large_image',
      title,
      description,
      images: [ogImage],
      creator: SITE_CONFIG.twitterHandle,
    },
    robots: noIndex
      ? { index: false, follow: false }
      : { index: true, follow: true },
  }
}

// ============================================
// JSON-LD STRUCTURED DATA COMPONENT
// ============================================

interface JsonLdProps {
  type: 'WebSite' | 'Organization' | 'Article' | 'FAQPage' | 'BreadcrumbList'
  data: Record<string, unknown>
}

export function JsonLd({ type, data }: JsonLdProps) {
  const jsonLd = {
    '@context': 'https://schema.org',
    '@type': type,
    ...data,
  }

  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
    />
  )
}

// ============================================
// DEFAULT JSON-LD FOR EVERY PROJECT
// ============================================

export function DefaultJsonLd() {
  return (
    <>
      <JsonLd
        type="WebSite"
        data={{
          '@id': `${SITE_CONFIG.url}/#website`,
          name: SITE_CONFIG.name,
          url: SITE_CONFIG.url,
        }}
      />
      <JsonLd
        type="Organization"
        data={{
          '@id': `${SITE_CONFIG.url}/#organization`,
          name: SITE_CONFIG.name,
          url: SITE_CONFIG.url,
          logo: `${SITE_CONFIG.url}/logo.png`,
        }}
      />
    </>
  )
}

// ============================================
// VITE + REACT VERSION (react-helmet-async)
// ============================================

/*
import { Helmet } from 'react-helmet-async'

interface SEOHeadProps {
  title: string
  description: string
  path?: string
  image?: string
  type?: string
}

export function SEOHead({
  title,
  description,
  path = '',
  image = SITE_CONFIG.defaultImage,
  type = 'website',
}: SEOHeadProps) {
  const url = `${SITE_CONFIG.url}${path}`

  return (
    <Helmet>
      <title>{`${title} | ${SITE_CONFIG.name}`}</title>
      <meta name="description" content={description} />
      <link rel="canonical" href={url} />

      <meta property="og:title" content={title} />
      <meta property="og:description" content={description} />
      <meta property="og:image" content={image} />
      <meta property="og:url" content={url} />
      <meta property="og:type" content={type} />
      <meta property="og:site_name" content={SITE_CONFIG.name} />

      <meta name="twitter:card" content="summary_large_image" />
      <meta name="twitter:title" content={title} />
      <meta name="twitter:description" content={description} />
      <meta name="twitter:image" content={image} />
    </Helmet>
  )
}
*/
