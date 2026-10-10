-- Issue 9: orphans, counted in both directions (without order_id)
SELECT
  (SELECT COUNT(*) FROM raw.order_items i
     LEFT JOIN raw.orders o USING (order_id) 
     WHERE o.order_id IS NULL) AS orphan_items,
  (SELECT COUNT(*) FROM raw.payments p
     LEFT JOIN raw.orders o USING (order_id) 
     WHERE o.order_id IS NULL) AS orphan_payments;
