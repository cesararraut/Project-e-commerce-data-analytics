CREATE OR REPLACE TABLE marts.fct_orders AS
WITH pay AS (
  SELECT
    order_id,
    COUNTIF(payment_status = 'failed')       AS failed_payment_attempts,
    LOGICAL_OR(payment_status = 'captured')    AS payment_captured,
    MAX(IF(payment_status = 'captured', payment_method, NULL)) AS payment_method
  FROM staging.stg_payments
  GROUP BY order_id
),
lines AS (
  SELECT order_id, COUNT(*) AS line_count, SUM(quantity) AS units,
         SUM(line_total) AS items_subtotal
  FROM staging.stg_order_items
  GROUP BY order_id
),
first_order AS (
  SELECT customer_id, MIN(order_ts) AS first_order_ts
  FROM staging.stg_orders
  WHERE customer_id IS NOT NULL
  GROUP BY customer_id
)
SELECT
  o.order_id,
  o.customer_id,
  o.customer_id IS NULL AS is_guest,
  DATE(o.order_ts) AS order_date,
  o.order_ts,
  EXTRACT(HOUR FROM o.order_ts) AS order_hour,
  o.order_status, o.channel, o.shipping_state,
  o.subtotal, o.discount_amount, o.shipping_fee, o.tax_amount, o.order_total,
  -- What is the revenue
  o.order_status IN ('completed', 'shipped') AS is_revenue,
  o.order_status = 'cancelled' AS is_cancelled,
  o.order_status = 'refunded' AS is_refunded,
  COALESCE(l.line_count, 0) AS line_count,
  COALESCE(l.units, 0) AS units,
  l.items_subtotal,
  COALESCE(p.failed_payment_attempts, 0) AS failed_payment_attempts,
  COALESCE(p.payment_captured, FALSE) AS payment_captured,
  p.payment_method,
  o.customer_id IS NOT NULL AND o.order_ts = f.first_order_ts AS is_first_order
FROM staging.stg_orders o
LEFT JOIN lines       l USING (order_id)
LEFT JOIN pay         p USING (order_id)
LEFT JOIN first_order f ON f.customer_id = o.customer_id;
