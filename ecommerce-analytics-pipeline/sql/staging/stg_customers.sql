CREATE OR REPLACE TABLE staging.stg_customers AS
WITH deduped AS (
  SELECT *
  FROM raw.customers
  -- removing duplicates, only the lastest row is kept
  QUALIFY ROW_NUMBER() OVER (
    PARTITION BY customer_id
    ORDER BY _ingested_at DESC, CAST(_row_id AS INT64) DESC
  ) = 1
)
SELECT
-- cleaning capital letter, spaces
  d.customer_id,
  LOWER(TRIM(d.email)) AS email,
  INITCAP(TRIM(d.first_name))  AS first_name,
  INITCAP(TRIM(d.last_name))  AS last_name,
  -- handling nulls
  NULLIF(TRIM(d.phone), '') AS phone,
  NULLIF(INITCAP(TRIM(d.city)), '') AS city,
  COALESCE(s.state_code, NULLIF(TRIM(d.state), '')) AS state,
  NULLIF(TRIM(d.zip_code), '') AS zip_code,
  'US'              AS country,
-- standarizing date format  
  DATE(COALESCE(
    SAFE.PARSE_TIMESTAMP('%Y-%m-%d', d.signup_date),
    SAFE.PARSE_TIMESTAMP('%m/%d/%Y', d.signup_date)))   AS signup_date,
  COALESCE(
    SAFE.PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%S', d.updated_at),
    SAFE.PARSE_TIMESTAMP('%m/%d/%Y %H:%M:%S', d.updated_at),
    SAFE.PARSE_TIMESTAMP('%Y-%m-%d',          d.updated_at),
    SAFE.PARSE_TIMESTAMP('%m/%d/%Y',          d.updated_at)) AS updated_at
FROM deduped d
LEFT JOIN staging.seed_states s
  ON LOWER(TRIM(d.state)) = LOWER(s.state_name);
