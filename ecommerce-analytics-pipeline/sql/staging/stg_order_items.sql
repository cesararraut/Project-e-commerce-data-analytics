CREATE OR REPLACE TABLE staging.stg_order_items AS
SELECT
  order_item_id, order_id, product_id,
  UPPER(TRIM(sku)) AS sku,
  SAFE_CAST(quantity AS INT64) AS quantity,
  SAFE_CAST(REPLACE(REPLACE(unit_price, '$',''),',','') AS NUMERIC) AS unit_price,
  SAFE_CAST(REPLACE(REPLACE(line_total,'$',''),',','') AS NUMERIC) AS line_total
FROM raw.order_items;
