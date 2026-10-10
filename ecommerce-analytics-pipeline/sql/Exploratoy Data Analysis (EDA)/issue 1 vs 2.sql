-- is the duplicate identical or a updated version?
WITH order_payloads AS (
  SELECT
  order_id,
  COUNT(DISTINCT FORMAT('%T',(order_status,
  subtotal,
  order_total,
  discount_amount,
  updated_at))) AS distinct_payloads
  FROM `raw.orders`
  GROUP BY order_id
  HAVING COUNT(*) > 1
)

SELECT
 COUNT(*) AS keys_appearing_twice,
 COUNTIF(distinct_payloads =1) AS exact_duplicates,
 COUNTIF(distinct_payloads >1) AS updated_versions
FROM order_payloads