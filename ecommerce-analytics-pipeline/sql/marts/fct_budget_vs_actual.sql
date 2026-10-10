CREATE OR REPLACE TABLE marts.fct_budget_vs_actual AS
WITH actual AS (
  SELECT
    DATE_TRUNC(order_date, MONTH) AS month,
    channel,
    SUM(orders) AS orders,
    SUM(revenue_orders) AS revenue_orders,
    SUM(revenue) AS revenue,
    SUM(cancelled_orders) AS cancelled_orders,
    SUM(new_customers) AS new_customers
  FROM marts.agg_daily_sales
  GROUP BY 1, 2
)
SELECT
  COALESCE(a.month, b.budget_month) AS month,
  COALESCE(a.channel, b.channel) AS channel,
  b.plan_version,
  a.revenue,          b.revenue_target,
  a.revenue_orders,   b.revenue_orders_target,
  a.orders,           b.orders_target,
  a.cancelled_orders, b.cancelled_orders_target,
  a.new_customers,    b.new_customers_target,
  a.month IS NOT NULL AS has_actuals
FROM actual a
FULL OUTER JOIN staging.stg_budget b
  ON a.month = b.budget_month
 AND a.channel = b.channel;
