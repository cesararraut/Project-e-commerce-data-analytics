CREATE OR REPLACE TABLE staging.stg_products AS
SELECT
  p.product_id,
  UPPER(TRIM(p.sku)) AS sku,
  TRIM(p.product_name) AS product_name,
  INITCAP(TRIM(p.brand)) AS brand,
  c.category AS category,
  SAFE_CAST(p.list_price AS NUMERIC) AS list_price,
  SAFE_CAST(p.unit_cost  AS NUMERIC)  AS unit_cost,
  SAFE_CAST(p.is_active  AS INT64) = 1  AS is_active
FROM raw.products p
LEFT JOIN staging.seed_categories c
  ON UPPER(TRIM(p.category)) = c.category_upper;
