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
    {{ dbt_utils.generate_surrogate_key(['brewery_id']) }} AS brewery_sk
FROM {{ ref('stg_breweries') }}