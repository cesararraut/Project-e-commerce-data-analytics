-- every viriant, with its frequency
-- (4) order status from orders
SELECT order_status, COUNT(*) AS n FROM `raw.orders` GROUP BY 1 ORDER BY 2 DESC;

--currency from orders
SELECT currency, COUNT(*) AS n FROM `raw.orders` GROUP BY 1 ORDER BY 2 DESC;

-- (5)
--country from customers
SELECT country, COUNT(*) AS n FROM `raw.customers` GROUP BY 1 ORDER BY 2 DESC;