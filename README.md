# Snow Leo Data — MCP servers

Five remote MCP servers that give an AI agent **21 web-data tools**: local business
leads, job listings, marketplace catalogues, compliance records and public media
feeds. Every tool is a published Apify Actor, exposed over the Model Context
Protocol by Apify's own hosted gateway at `mcp.apify.com`.

- **Transport:** Streamable HTTP. No install, no npm package, no local process.
- **Auth:** OAuth with your own Apify account (or a Bearer token).
- **Billing:** you pay Apify directly, per result. Prices are listed below.

The servers are split by subject on purpose. An agent handed twenty-one tools at
once picks badly; an agent handed four tools that all answer one kind of question
picks well. Connect only the server you need.

---

## The five servers

| Server | Tools | What it answers | URL |
|---|---|---|---|
| **Leads & Contacts** | 5 | "Who are the businesses here, and how do I reach them?" | [`leads/server.json`](leads/server.json) |
| **Jobs & Hiring** | 4 | "What roles are open right now, and where?" | [`jobs/server.json`](jobs/server.json) |
| **Marketplaces & Prices** | 6 | "What is listed, and what does it cost today?" | [`marketplaces/server.json`](marketplaces/server.json) |
| **Risk & Compliance** | 4 | "Is this name, domain, product or contract a problem?" | [`risk/server.json`](risk/server.json) |
| **News & Social** | 2 | "What is being said publicly, and when was it said?" | [`media/server.json`](media/server.json) |

---

### 1. Leads & Contacts

```
https://mcp.apify.com/?actors=snow_leo_data/google-maps-places-scraper-leads-emails,snow_leo_data/yellow-pages-scraper-bbb-europages-business-directory-leads,snow_leo_data/duckduckgo-scraper-local-business-maps-leads,snow_leo_data/no-website-local-business-leads-openstreetmap,snow_leo_data/contact-scraper-website-emails-phones-socials-extractor
```

Five different indexes of the same world — Google's, Yelp/Apple's, the printed
directories, the open map, and the company's own website — so an agent that
comes up short in one can try another.

| Actor | What it returns | Measured |
|---|---|---|
| `snow_leo_data/google-maps-places-scraper-leads-emails` | Places from Google Maps, 56 columns, emails read from the business website | Google Maps stops near 150 places per search view; adaptive grid returned **766 places against 160** for `coffee` in Austin, 4.79x, in 42 s / 168 requests (12 Sep 2026) |
| `snow_leo_data/yellow-pages-scraper-bbb-europages-business-directory-leads` | Seven directories — Yellow Pages US/CA, BBB, Gelbe Seiten, PagineGialle, Europages, Hotfrog — in 38 shared columns | Every page a human can click on BBB gives **175 unique businesses**; bucketed queries returned **524** (runs `kt2dccRUXf2Itm2BL` = 175, `rKU71p8Dxq62dCgQ0` = 524) |
| `snow_leo_data/duckduckgo-scraper-local-business-maps-leads` | Local businesses from DuckDuckGo's index (Yelp + Apple Maps data), 44 fields, up to 5 review excerpts with text | Measured 16 Sep 2026 on 10 category+city pairs, with Google Maps swept to its own ceiling on each: of **164 businesses returned, 82 (50%) were not in Google Maps at all**. The `website` field was filled for **97.9%** of rows here against 79.7% in a Google Maps sample of 300 taken the same day |
| `snow_leo_data/no-website-local-business-leads-openstreetmap` | Businesses that have **no website**, from OpenStreetMap, 59 fields | Austin: **7,673 named businesses, 3,932 with no website at all**, one Overpass query, 80.5 s. Manchester UK: 5,905 / 4,261 in 13.4 s |
| `snow_leo_data/contact-scraper-website-emails-phones-socials-extractor` | One row per website: emails, phones in E.164, socials across 31 platforms, address, hours | On 135 live business sites, home page only found an email on **31** sites; home page plus contact pages found one on **57** |

### 2. Jobs & Hiring

```
https://mcp.apify.com/?actors=snow_leo_data/greenhouse-workday-lever-ashby-ats-jobs-scraper,snow_leo_data/seek-scraper-jobstreet-jobsdb-australia-jobs-salaries,snow_leo_data/jobs-ch-scraper-swiss-switzerland-jobs,snow_leo_data/the-muse-scraper-remote-company-jobs-board
```

One tool for jobs straight from the employer's own ATS, and three for the job
boards that dominate a region. All four return the same kind of row, so an agent
can compare a Swiss board against a US careers page without reshaping anything.

| Actor | What it returns | Measured |
|---|---|---|
| `snow_leo_data/greenhouse-workday-lever-ashby-ats-jobs-scraper` | Jobs read live from 20 applicant tracking systems — Greenhouse, Workday, Lever, Ashby, SmartRecruiters, Oracle Cloud, BrassRing, UKG and twelve more | **59,185 jobs in one run**; **1,045 company boards built in**, so an empty input still works. $0.99 per 1,000 where others in the niche charge $1.30, $2.50 and $4.00 |
| `snow_leo_data/seek-scraper-jobstreet-jobsdb-australia-jobs-salaries` | SEEK AU/NZ, JobStreet MY/SG/PH/ID, JobsDB HK/TH — 8 markets, 41 fields | The public API stops at **500 jobs per query** (page 6 at 100 rows returns an empty list); this Actor returned **1,500 unique jobs in 120 s**, zero duplicates |
| `snow_leo_data/jobs-ch-scraper-swiss-switzerland-jobs` | jobs.ch, 38 fields, full advert text, direct apply URL, Swiss workload percentage, coordinates | **46,121 jobs live on jobs.ch**; page 101 returns HTTP 422, so one query caps at **2,000**. Measured **2,400 unique jobs in 64 s**, zero duplicates |
| `snow_leo_data/the-muse-scraper-remote-company-jobs-board` | The Muse, 27 fields, the entire advert body inline | **411,813 jobs** on the source; page 100 returns HTTP 400 so one query caps at **1,980**. Measured **2,060 unique jobs in 176 s**, zero duplicates |

### 3. Marketplaces & Prices

```
https://mcp.apify.com/?actors=snow_leo_data/amazon-product-scraper-prices-asin-bestsellers,snow_leo_data/shopify-scraper-products-inventory-variants-sku-prices,snow_leo_data/apple-app-store-scraper-reviews-ratings-aso-ios-apps,snow_leo_data/google-play-store-scraper-apps-reviews-charts,snow_leo_data/airbnb-scraper-listings-prices-calendar-reviews-occupancy,snow_leo_data/redfin-scraper-property-listings-rentals-prices-sold
```

Every tool here returns a priced listing out of somebody's catalogue — products,
apps, stays, homes — and every one of them is built around getting past that
catalogue's own result ceiling.

| Actor | What it returns | Measured |
|---|---|---|
| `snow_leo_data/amazon-product-scraper-prices-asin-bestsellers` | amazon.com search, product pages and Best Sellers: prices, list price, discount, rating, stock, seller, specs, BSR, ASIN | **One Amazon search stops at 306 products** for `wireless earbuds` while Amazon's own header claimed over 20,000. Six price bands returned 96 products, **96 unique, zero overlap** |
| `snow_leo_data/shopify-scraper-products-inventory-variants-sku-prices` | Any Shopify storefront: 42 fields per product, every variant, price, compare-at, SKU, barcode, stock, collection | On 47 live storefronts, 14 refuse `/products.json` on their own domain; reading the shop's Shopify origin recovered **10 of those 14** — **43 stores readable instead of 33** |
| `snow_leo_data/apple-app-store-scraper-reviews-ratings-aso-ios-apps` | App Store reviews and the full store card, per storefront, across 59 Apple storefronts | Apple caps at **500 reviews per storefront per sort order** (page 11 returns HTTP 400). Opening both sort windows gave **937 unique reviews** on one app, only 63 shared. Notion on 12 Sep 2026: 90,067 ratings in USD in the US storefront, 50,062 in JPY in the Japanese one |
| `snow_leo_data/google-play-store-scraper-apps-reviews-charts` | Google Play reviews, app details, keyword search, top charts, developer listings, similar apps — 6 modes | Play keeps reviews **per language, and the piles do not overlap**. `com.spotify.music`, 13 Sep 2026: 18 languages x 600 = **10,800 distinct review IDs, 0 duplicates between languages** |
| `snow_leo_data/airbnb-scraper-listings-prices-calendar-reviews-occupancy` | Airbnb listings, details, the day-by-day availability calendar with occupancy rates, and reviews | Airbnb search hands out at most **270 rows per query** which contain **227 distinct listings**. Paris, 13 Sep 2026: flat pagination 257 listings from 7 queries; adaptive map grid **1,916 from 63 queries — 7.46x**, in 117 s |
| `snow_leo_data/redfin-scraper-property-listings-rentals-prices-sold` | Redfin by city, county, neighborhood or ZIP: price, beds, baths, area, year, DOM, MLS number and description, agent, coordinates; property card adds parcel, tax rate, schools, climate risk, permits, zoning | Redfin's search endpoint **has no pagination** — `page_number=2` returns page 1 byte for byte. Redfin's own "Download All" CSV export stops at **350** listings |

### 4. Risk & Compliance

```
https://mcp.apify.com/?actors=snow_leo_data/ofac-sdn-eu-un-sanctions-list-screening,snow_leo_data/cve-scraper-nvd-kev-epss-vulnerability-database,snow_leo_data/dns-records-mx-whois-lookup-dmarc-spf-domain-monitor,snow_leo_data/government-tenders-scraper-ted-sam-gov-procurement
```

Four checks an agent runs before it recommends doing business with someone: is
the name sanctioned, is the software exploitable, is the domain real and able to
receive mail, and is there a public contract behind it.

| Actor | What it returns | Measured |
|---|---|---|
| `snow_leo_data/ofac-sdn-eu-un-sanctions-list-screening` | US Treasury OFAC SDN, the EU consolidated list and the UN Security Council consolidated list, joined, with which authorities list each name | **26,633 records** against the 19,388 in OFAC alone — 37% more. OFAC 19,388, EU 6,234, UN 1,011. **4,370 listed by two or more authorities, 1,693 by all three.** No API key, no registration, no proxy |
| `snow_leo_data/cve-scraper-nvd-kev-epss-vulnerability-database` | Every CVE from the NIST National Vulnerability Database, joined with CISA KEV and EPSS | **389,995 CVEs** — the whole NVD catalogue, read live |
| `snow_leo_data/dns-records-mx-whois-lookup-dmarc-spf-domain-monitor` | One row per domain with **80 fields**: A, AAAA, MX, NS, TXT, SOA, CAA, CNAME chain, DNSSEC, SPF/DKIM/DMARC posture checked against the standards, registration record, TLS certificate. Monitor mode returns only domains whose records moved, with what changed | Public sources over HTTPS, DNS-over-HTTPS and WHOIS on port 43. No API key, no proxy, no browser, no paid feed |
| `snow_leo_data/government-tenders-scraper-ted-sam-gov-procurement` | Four official procurement feeds in one row shape: EU TED, UK Find a Tender, UK Contracts Finder, US SAM.gov | **48 buyer countries in a single measured window** — 47 in one 7-day slice of TED (4–11 Sep 2026, **19,795 notices**) plus the United States from SAM.gov |

### 5. News & Social

```
https://mcp.apify.com/?actors=snow_leo_data/google-news-articles-media-monitoring-brand-mentions-tracker,snow_leo_data/telegram-channel-scraper
```

Two public feeds an agent can read without an account, a bot token or an API key.

| Actor | What it returns | Measured |
|---|---|---|
| `snow_leo_data/google-news-articles-media-monitoring-brand-mentions-tracker` | News articles by keyword, topic, city or edition, across 80 Google News editions, each with the **publisher's own URL** rather than the `news.google.com/rss/articles/…` redirect | A Google News feed returns about **99 items and never says so** — no cursor, no page two, no error. Measured 12 Sep 2026: `tesla` plain feed **99 articles from 1 request**; the same query split into 30 one-day windows returned **2,070 from 31 requests** |
| `snow_leo_data/telegram-channel-scraper` | Any public Telegram channel through `t.me/s/…`: **68 fields per message** — reactions counted per emoji, channel numeric id, author signature, poll results, forwards, replies, inline buttons, direct CDN links to attachments. Also in-channel keyword search and handle-to-profile-card | Measured against live Telegram on 13 Sep 2026. No account, no bot token, no MTProto API |

---

## How to connect

### Claude Desktop and claude.ai

These are remote servers, so they install as **custom connectors**, not as a
config file entry.

1. Open Settings (Desktop: `Ctrl+,` / menu → File → Settings. Browser: `⌘⇧,`).
2. Click **Connectors** in the sidebar, then **Add** → **Add custom connector**.
3. Paste one of the five URLs above and click **Add**.
4. Claude will send you to Apify to sign in. Approve it.
5. The tools appear under the connector. You can switch individual tools off in
   the connector's settings.

### Cursor

Put this in `~/.cursor/mcp.json` (global) or `.cursor/mcp.json` (one project).
Add only the servers you want:

```json
{
  "mcpServers": {
    "snowleo-leads": {
      "url": "https://mcp.apify.com/?actors=snow_leo_data/google-maps-places-scraper-leads-emails,snow_leo_data/yellow-pages-scraper-bbb-europages-business-directory-leads,snow_leo_data/duckduckgo-scraper-local-business-maps-leads,snow_leo_data/no-website-local-business-leads-openstreetmap,snow_leo_data/contact-scraper-website-emails-phones-socials-extractor"
    },
    "snowleo-jobs": {
      "url": "https://mcp.apify.com/?actors=snow_leo_data/greenhouse-workday-lever-ashby-ats-jobs-scraper,snow_leo_data/seek-scraper-jobstreet-jobsdb-australia-jobs-salaries,snow_leo_data/jobs-ch-scraper-swiss-switzerland-jobs,snow_leo_data/the-muse-scraper-remote-company-jobs-board"
    },
    "snowleo-marketplaces": {
      "url": "https://mcp.apify.com/?actors=snow_leo_data/amazon-product-scraper-prices-asin-bestsellers,snow_leo_data/shopify-scraper-products-inventory-variants-sku-prices,snow_leo_data/apple-app-store-scraper-reviews-ratings-aso-ios-apps,snow_leo_data/google-play-store-scraper-apps-reviews-charts,snow_leo_data/airbnb-scraper-listings-prices-calendar-reviews-occupancy,snow_leo_data/redfin-scraper-property-listings-rentals-prices-sold"
    },
    "snowleo-risk": {
      "url": "https://mcp.apify.com/?actors=snow_leo_data/ofac-sdn-eu-un-sanctions-list-screening,snow_leo_data/cve-scraper-nvd-kev-epss-vulnerability-database,snow_leo_data/dns-records-mx-whois-lookup-dmarc-spf-domain-monitor,snow_leo_data/government-tenders-scraper-ted-sam-gov-procurement"
    },
    "snowleo-media": {
      "url": "https://mcp.apify.com/?actors=snow_leo_data/google-news-articles-media-monitoring-brand-mentions-tracker,snow_leo_data/telegram-channel-scraper"
    }
  }
}
```

Cursor will run the OAuth flow the first time the server is used. If you prefer a
token to a browser sign-in, add a header instead:

```json
{
  "mcpServers": {
    "snowleo-leads": {
      "url": "https://mcp.apify.com/?actors=snow_leo_data/google-maps-places-scraper-leads-emails",
      "headers": { "Authorization": "Bearer YOUR_APIFY_API_TOKEN" }
    }
  }
}
```

### Any client that only speaks stdio

Bridge the HTTP endpoint with `mcp-remote`:

```json
{
  "mcpServers": {
    "snowleo-leads": {
      "command": "npx",
      "args": [
        "-y",
        "mcp-remote",
        "https://mcp.apify.com/?actors=snow_leo_data/google-maps-places-scraper-leads-emails"
      ]
    }
  }
}
```

### Checking it by hand

```bash
curl -sS -X POST \
  "https://mcp.apify.com/?actors=snow_leo_data/telegram-channel-scraper" \
  -H "Authorization: Bearer $APIFY_TOKEN" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/list"}'
```

Without a token the same request answers **HTTP 401** with
`{"error":"invalid_token", ...}`. That is expected — the server is gated, not broken.

The gateway publishes OAuth discovery metadata at
`https://mcp.apify.com/.well-known/oauth-protected-resource`, pointing at Apify
Console as the authorization server, and that server offers dynamic client
registration. Clients that support OAuth therefore need no manual app setup — the
sign-in dialog is all there is.

---

## Tool names

Apify's gateway exposes each Actor as a tool named `snow_leo_data--<actor-slug>`.
Names longer than 64 characters are truncated and given a short hash suffix, so a
few of the longer Actors appear under a shortened name. The rule lives in
[`actor_tool_naming.ts`](https://github.com/apify/actors-mcp-server/blob/master/src/tools/actor_tool_naming.ts)
in Apify's open-source gateway.

Alongside our tools, the gateway adds its own helpers — `get-actor-run`,
`get-dataset-items`, `get-key-value-store-record`, `abort-actor-run` — for
reading back a run that is already finished.

---

## Who pays, and how much

**You do, to Apify, with your own account.** There is no key to buy from us and
nothing to subscribe to. When you connect, you sign in to Apify; your Apify
account is billed for the runs your agent starts. Apify's free tier includes
monthly platform credit, so small runs often cost nothing out of pocket.

All 21 Actors are cleared by Apify for agentic payments, so an agent can pay for a
run on its own without a human in the loop (checked against Apify's public store
API on 17 September 2026: 21 of 21).

Every Actor here is priced **per result**, not per hour or per page. Rows your
filters removed, duplicates, and rows already delivered unchanged in monitor mode
are not charged. Prices below are the free-plan rate read from Apify's public
store API on 17 September 2026; paid Apify plans pay less.

| Actor | Price |
|---|---|
| `duckduckgo-scraper-local-business-maps-leads` | $0.30 / 1,000 businesses |
| `shopify-scraper-products-inventory-variants-sku-prices` | $0.40 / 1,000 products |
| `redfin-scraper-property-listings-rentals-prices-sold` | $0.45 / 1,000 listings + $0.002 per run start |
| `apple-app-store-scraper-reviews-ratings-aso-ios-apps` | $0.05 / 1,000 rows |
| `google-play-store-scraper-apps-reviews-charts` | $0.05 / 1,000 rows |
| `no-website-local-business-leads-openstreetmap` | $0.50 / 1,000 businesses |
| `telegram-channel-scraper` | $0.50 / 1,000 messages |
| `amazon-product-scraper-prices-asin-bestsellers` | $0.49 / 1,000 products |
| `airbnb-scraper-listings-prices-calendar-reviews-occupancy` | $0.49 / 1,000 listings |
| `cve-scraper-nvd-kev-epss-vulnerability-database` | $0.49 / 1,000 records |
| `ofac-sdn-eu-un-sanctions-list-screening` | $0.49 / 1,000 records |
| `the-muse-scraper-remote-company-jobs-board` | $0.49 / 1,000 jobs |
| `yellow-pages-scraper-bbb-europages-business-directory-leads` | $0.60 / 1,000 businesses |
| `google-maps-places-scraper-leads-emails` | $1.50 / 1,000 places, everything included — detail card, filters and website emails are not billed separately |
| `contact-scraper-website-emails-phones-socials-extractor` | $0.99 / 1,000 websites |
| `google-news-articles-media-monitoring-brand-mentions-tracker` | $0.99 / 1,000 articles |
| `greenhouse-workday-lever-ashby-ats-jobs-scraper` | $0.99 / 1,000 jobs |
| `jobs-ch-scraper-swiss-switzerland-jobs` | $0.99 / 1,000 jobs |
| `seek-scraper-jobstreet-jobsdb-australia-jobs-salaries` | $0.99 / 1,000 jobs |
| `government-tenders-scraper-ted-sam-gov-procurement` | $0.99 / 1,000 notices |
| `dns-records-mx-whois-lookup-dmarc-spf-domain-monitor` | $2.00 / 1,000 domains + $0.002 per run start |

---

## What these tools do not do

Read this before you point an agent at them.

- **They read public pages only.** Nothing here logs in, buys an account, or
  passes a paywall. If a source requires a session to show data, that data is not
  in the output.
- **They do not write anything.** Every tool is read-only. No posting, no
  applying to a job, no placing an order, no bidding on a tender.
- **They are not instant.** A tool call starts an Actor run on Apify. Small runs
  finish in seconds; a wide job or map sweep takes one to three minutes. An agent
  with a short tool timeout should ask for fewer results, or read the run back
  later with `get-dataset-items`.
- **They do not beat the source's own ceiling by magic.** Where a ceiling was
  broken, the number is in the table above and the method is described in the
  Actor's own page on Apify. Where it was not — Redfin's export cap, Amazon's
  306-product window, BBB's 175 — the ceiling is stated, not hidden. A directory
  is never emptied; it is sampled much more deeply than a plain search allows.
- **They do not enrich or guess.** A missing website in the OpenStreetMap tool is
  a missing tag in the data, not a model's inference. Salary in the ATS tool comes
  from the source field or is absent.
- **They are not a database snapshot.** Every run reads the source at the moment
  you run it. Ask the same question twice on a reshuffling source such as Amazon
  and the two answers will differ.
- **No legal advice.** The sanctions tool returns what three governments publish.
  Deciding what that means for a transaction is your compliance team's job, not a
  language model's.

---

## An honest note about this listing

We publish these servers to MCP directories because agents increasingly find
tools there rather than in a marketplace's own search.

**We have no measurement that MCP directories bring buyers.** Not one. This is a
bet on a distribution channel, not a proven channel, and it is described that way
on purpose. If it turns out to be empty, this repository will say so.

**The condition we set for calling it dead:** if, two weeks after the last
directory listing goes live, not one of the 21 Actors has gained a single unique
user we cannot trace to ourselves, the channel produced nothing and we stop
spending time on it.

---

## What is in this repository

```
README.md               this file
LICENSE                 MIT
set-github-user.sh      fills the GitHub namespace placeholder into every server.json
INSTRUCTIONS-RU.md      internal publishing notes for the maintainer (Russian)
leads/server.json       ─┐
jobs/server.json          │  one MCP registry manifest per server,
marketplaces/server.json  │  schema 2025-12-11, remote / streamable-http
risk/server.json          │
media/server.json       ─┘
```

Each `server.json` follows the
[official registry schema](https://static.modelcontextprotocol.io/schemas/2025-12-11/server.schema.json)
and all five validate against `registry.modelcontextprotocol.io/v0/validate`.
They ship with `YOUR-GITHUB-USERNAME` in the `name`, `repository.url` and
`websiteUrl` fields; `./set-github-user.sh <login>` replaces it before publishing.

---

## License

MIT. See [LICENSE](LICENSE).
