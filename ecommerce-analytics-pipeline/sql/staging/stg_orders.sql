CREATE OR REPLACE TABLE staging.stg_orders AS
WITH deduped AS (
  SELECT *
  FROM raw.orders
  QUALIFY ROW_NUMBER() OVER (
    PARTITION BY order_id
    ORDER BY _ingested_at DESC, CAST(_row_id AS INT64) DESC
  ) = 1
)
SELECT
  d.order_id,
  NULLIF(TRIM(d.customer_id), '')              AS customer_id, 
  COALESCE(
    SAFE.PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%S', d.order_ts),
    SAFE.PARSE_TIMESTAMP('%m/%d/%Y %H:%M:%S', d.order_ts),
    SAFE.PARSE_TIMESTAMP('%Y-%m-%d',          d.order_ts),
    SAFE.PARSE_TIMESTAMP('%m/%d/%Y',          d.order_ts))       AS order_ts,
  LOWER(TRIM(d.order_status))                  AS order_status,
  LOWER(TRIM(d.channel))                       AS channel,
  --remove "$" sign and comma
  SAFE_CAST(REPLACE(REPLACE(d.subtotal,        '$',''),',','') AS NUMERIC) AS subtotal,
  SAFE_CAST(REPLACE(REPLACE(d.discount_amount, '$',''),',','') AS NUMERIC) AS discount_amount,
  SAFE_CAST(REPLACE(REPLACE(d.shipping_fee,    '$',''),',','') AS NUMERIC) AS shipping_fee,
  SAFE_CAST(REPLACE(REPLACE(d.tax_amount,      '$',''),',','') AS NUMERIC) AS tax_amount,
  SAFE_CAST(REPLACE(REPLACE(d.order_total,     '$',''),',','') AS NUMERIC) AS order_total,
  UPPER(TRIM(d.currency))                      AS currency,
  COALESCE(s.state_code, NULLIF(TRIM(d.shipping_state), '')) AS shipping_state,
  COALESCE(
    SAFE.PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%S', d.updated_at),
    SAFE.PARSE_TIMESTAMP('%m/%d/%Y %H:%M:%S', d.updated_at),
    SAFE.PARSE_TIMESTAMP('%Y-%m-%d',          d.updated_at),
    SAFE.PARSE_TIMESTAMP('%m/%d/%Y',          d.updated_at))     AS updated_at
FROM deduped d
LEFT JOIN staging.seed_states s
  ON LOWER(TRIM(d.shipping_state)) = LOWER(s.state_name);
