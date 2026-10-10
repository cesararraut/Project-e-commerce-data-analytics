CREATE OR REPLACE TABLE marts.agg_daily_sales AS
SELECT
  order_date, channel, shipping_state,
  COUNT(*) AS orders,
  COUNTIF(is_revenue) AS revenue_orders,
  SUM(IF(is_revenue, order_total, 0)) AS revenue,
  SUM(IF(is_revenue, units, 0)) AS units,
  COUNTIF(is_cancelled) AS cancelled_orders,
  COUNTIF(is_first_order AND is_revenue) AS new_customers,
  SUM(IF(is_revenue, discount_amount, 0)) AS discounts
FROM marts.fct_orders
GROUP BY 1, 2, 3;