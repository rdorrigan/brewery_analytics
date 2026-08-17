import duckdb
import pandas as pd
import requests

# 1. Fetch raw data
url = "https://api.openbrewerydb.org/v1/breweries?per_page=200"
response = requests.get(url)
breweries_data = response.json()  # This is a list of dicts

# 2. Convert Python list -> Pandas DataFrame
df_breweries = pd.DataFrame(breweries_data)

# 3. Connect to DuckDB
con = duckdb.connect("brewery.duckdb")
con.execute("CREATE SCHEMA IF NOT EXISTS raw;")
con.execute("DROP TABLE IF EXISTS raw.raw_breweries;")

# 4. DuckDB will seamlessly scan the 'df_breweries' DataFrame
con.execute("CREATE TABLE raw.raw_breweries AS SELECT * FROM df_breweries;")

print(
    f"Successfully loaded {len(df_breweries)} raw breweries into"
    " DuckDB!"
)
con.close()