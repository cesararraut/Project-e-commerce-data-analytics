-- variables with differents whitespace or case
SELECT category, COUNT(*) n, FORMAT('[%s]', category) AS category_with_delimiter
FROM `raw.products` GROUP BY 1 ORDER BY 1;