CREATE OR REPLACE TABLE staging.stg_payments AS
WITH deduped AS (
  SELECT *
  FROM raw.payments
  QUALIFY ROW_NUMBER() OVER (
    PARTITION BY payment_id
    ORDER BY _ingested_at DESC, CAST(_row_id AS INT64) DESC
  ) = 1
)
SELECT
  payment_id, order_id,
  COALESCE(
    SAFE.PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%S', payment_ts),
    SAFE.PARSE_TIMESTAMP('%m/%d/%Y %H:%M:%S', payment_ts),
    SAFE.PARSE_TIMESTAMP('%Y-%m-%d',          payment_ts),
    SAFE.PARSE_TIMESTAMP('%m/%d/%Y',          payment_ts))   AS payment_ts,
  LOWER(TRIM(payment_method))         AS payment_method,
  LOWER(TRIM(payment_status))         AS payment_status,
  SAFE_CAST(REPLACE(REPLACE(amount, '$',''),',','') AS NUMERIC) AS amount
FROM deduped;
