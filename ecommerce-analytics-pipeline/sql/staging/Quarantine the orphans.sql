CREATE OR REPLACE TABLE staging.quarantine_order_items AS
SELECT i.*, 'order_id not found in stg_orders' AS dq_reason, CURRENT_TIMESTAMP() AS quarantined_at
FROM staging.stg_order_items i
LEFT JOIN staging.stg_orders o USING (order_id)
WHERE o.order_id IS NULL;


CREATE OR REPLACE TABLE staging.quarantine_payments AS
SELECT p.*, 'order_id not found in stg_orders' AS dq_reason, CURRENT_TIMESTAMP() AS quarantined_at
FROM staging.stg_payments p
LEFT JOIN staging.stg_orders o USING (order_id)
WHERE o.order_id IS NULL;
