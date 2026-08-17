SELECT
    brewery_id,
    brewery_name,
    brewery_type,
    street,
    city,
    state,
    postal_code,
    normalized_country,
    latitude,
    longitude,
    website_url,
    -- Add a surrogate key if desired
    md5(cast(coalesce(cast(brewery_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS brewery_sk
FROM "brewery"."main"."stg_breweries"