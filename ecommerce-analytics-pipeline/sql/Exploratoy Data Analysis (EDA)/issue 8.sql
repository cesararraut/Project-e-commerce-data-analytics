-- money that will not cast
SELECT order_id, order_total
FROM raw.orders
WHERE REGEXP_CONTAINS(order_total, r'[$,]')
ORDER BY order_id
LIMIT 3;

