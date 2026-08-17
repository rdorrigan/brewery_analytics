Markdown
# Open Brewery Analytics Engineering Pipeline

![dbt Core](https://img.shields.io/badge/dbt--core-1.8+-orange?logo=dbt)
![DuckDB](https://img.shields.io/badge/DuckDB-In--Memory--OLAP-yellow?logo=duckdb)
![Data Modeling](https://img.shields.io/badge/Architecture-Medallion-blue)
![CI/CD](https://img.shields.io/badge/Docs-GitHub%20Pages-green)

An end-to-end ELT Analytics Engineering pipeline that ingests, models, tests, and documents global brewery distribution data using Python, DuckDB, and dbt Core.

🔗 **[View Live Interactive dbt Docs & Lineage DAG Graph](https://rdorrigan.github.io/brewery_analytics/)**

---

## 🏗 Architecture & Data Flow

Raw JSON payloads are ingested from the Open Brewery DB API into a local DuckDB OLAP database and transformed through a three-layer Medallion Architecture using dbt Core.

```text
[ Open Brewery API ]
│
(Python Script)
▼
[ DuckDB (raw.raw_breweries) ]
│
(dbt Staging)
▼
[ stg_breweries ] ── Clean schema, cast datatypes, normalize NULLs
│
(dbt Marts)
├──► [ dim_breweries ] ────── Dimensional table with surrogate keys
└──► [ fct_brewery_density ] ── Analytical aggregates by city & type
```

---

## 🛠 Key Features & Engineering Practices

* **ELT Ingestion:** Python ingestion script storing raw JSON objects in a native DuckDB warehouse (`brewery.duckdb`).
* **Modular Modeling:** Clean separation of concerns across Staging, Intermediate, and Marts layers.
* **Data Quality & Testing:** Automated constraints (`not_null`, `unique`, foreign key relationships) configured in `schema.yml`.
* **Package Integration:** Leveraged `dbt_utils` for surrogate key generation (`md5` hashing).
* **Automated CI/CD:** Continuous Deployment pipeline using GitHub Actions to automatically trigger documentation generation and deploy static lineage graphs to GitHub Pages upon every commit to `main`.

---

## 📊 Sample Metrics & Analytical Use Cases

The dimensional model powers business intelligence reporting, operational diagnostics, and geographic market analysis. Below are two core analytical frameworks implemented in `fct_brewery_density`:

### 1. Market Penetration & Geographic Density Analysis
* **Business Objective:** Evaluate state-level market saturation and identify key structural shifts in brewery distribution (e.g., craft microbreweries vs. full-service brewpubs).
* **Analytical Logic:** Computes the ratio of localized production facilities (`micro`) against hospitality-first venues (`brewpub`) per state, filtering out non-traditional entities (`closed`, `planning`).
* **Core Output Metric:**
  $$\text{Microbrewery Ratio} = \frac{\sum \text{Microbreweries}}{\sum \text{Brewpubs}}$$
* **Key Finding Example:** Highlights regions where market expansion is heavily driven by direct-to-consumer taprooms versus wholesale contract manufacturing.

---

### 2. Digital Presence & Contactability Coverage
* **Business Objective:** Measure the digital maturity and reachability of regional brewery networks to target B2B marketing campaigns and sales ops outreach.
* **Analytical Logic:** Aggregates valid, non-null `website_url` and `phone` attributes across state and national groupings to produce a normalized coverage score.
* **Core Output Metric:**
  $$\text{Digital Presence Rate (\%)} = \left( \frac{\text{Count of Breweries with Valid URL}}{\text{Total Active Breweries}} \right) \times 100$$
* **Key Finding Example:** Quantifies digital contactability gaps across urban vs. rural markets, providing actionable lead-scoring data for regional distributors.

---

### 💻 Sample Downstream Query

```sql
-- Querying fct_brewery_density for top 5 states by microbrewery ratio
SELECT
    state,
    total_breweries,
    micro_count,
    brewpub_count,
    ROUND(micro_count::FLOAT / NULLIF(brewpub_count, 0), 2) AS micro_to_brewpub_ratio,
    ROUND(pct_with_website, 1) AS digital_presence_pct
FROM {{ ref('fct_brewery_density') }}
WHERE total_breweries >= 10
ORDER BY micro_to_brewpub_ratio DESC
LIMIT 5;
```

---

## 🚀 How to Run Locally

### Prerequisites
* Python 3.9+
* Git

### Quickstart
```bash
# 1. Clone repo
git clone [https://github.com/rdorrigan/brewery_analytics.git](https://github.com/rdorrigan/brewery_analytics.git)
cd brewery_analytics

# 2. Install dependencies
pip install -r requirements.txt

# 3. Execute raw data ingestion
python ingest.py

# 4. Install dbt packages
dbt deps

# 5. Run dbt transformation pipeline & test suite
dbt run
dbt test

# 6. Serve dbt documentation locally
dbt docs generate
dbt docs serve