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

## 📊 Sample Metrics Produced

The dimensional model powers downstream reporting metrics, answering business questions such as:
1. **Geographic Density:** Which US states contain the highest ratio of microbreweries vs. brewpubs?
2. **Digital Presence Rate:** What percentage of operating breweries maintain an active web URL per region?

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