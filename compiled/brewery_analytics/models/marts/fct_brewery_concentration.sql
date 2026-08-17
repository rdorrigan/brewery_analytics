SELECT
    state,
    brewery_type,
    COUNT(brewery_id) AS total_breweries,
    COUNT(CASE WHEN website_url IS NOT NULL THEN 1 END) AS breweries_with_websites
FROM "brewery"."main"."dim_breweries"
WHERE state IS NOT NULL
GROUP BY 1, 2