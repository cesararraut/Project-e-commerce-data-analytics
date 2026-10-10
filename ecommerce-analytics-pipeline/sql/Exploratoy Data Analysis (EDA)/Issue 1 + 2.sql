-- how many id are repeated, and how much is the inflation
SELECT
 COUNT(*) AS raw_rows,
 COUNT(DISTINCT order_id) AS distinct_orders,
 COUNT(*) - COUNT(DISTINCT order_id) AS surplus_rows,
 ROUND(100*(COUNT(*)/COUNT(DISTINCT order_id)-1), 2) AS ptc_inflation
FROM `raw.orders` 
