CREATE OR REPLACE TABLE marts.dim_customers AS
SELECT
  c.*,
  s.first_order_date, s.last_order_date,
  COALESCE(s.lifetime_orders, 0) AS lifetime_orders,
  COALESCE(s.lifetime_revenue, 0) AS lifetime_revenue,
  s.first_order_date IS NOT NULL AS has_ordered
FROM staging.stg_customers c
LEFT JOIN (
  SELECT customer_id,
         MIN(order_date) AS first_order_date,
         MAX(order_date) AS last_order_date,
         COUNT(*) AS lifetime_orders,
         SUM(IF(is_revenue, order_total, 0)) AS lifetime_revenue
  FROM marts.fct_orders
  WHERE customer_id IS NOT NULL
  GROUP BY customer_id
) s USING (customer_id);