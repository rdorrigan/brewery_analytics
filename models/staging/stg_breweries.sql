SELECT
    id AS brewery_id,
    name AS brewery_name,
    brewery_type,
    address_1 AS street,
    city,
    state_province AS state,
    postal_code,
    country,
    CAST(longitude AS DOUBLE) AS longitude,
    CAST(latitude AS DOUBLE) AS latitude,
    phone,
    website_url,
    -- Standardize country names or handle missing fields
    COALESCE(country, 'United States') AS normalized_country
FROM {{ source('raw', 'raw_breweries') }}