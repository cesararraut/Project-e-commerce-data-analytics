CREATE OR REPLACE TABLE marts.fct_order_items AS
SELECT
  i.order_item_id, i.order_id, i.product_id, i.sku,
  i.quantity, i.unit_price, i.line_total,
  i.line_total - (i.quantity * p.unit_cost)  AS line_margin,
  o.order_date, o.order_status, o.channel, o.shipping_state,
  o.customer_id, o.is_revenue,
  p.product_name, p.brand, p.category
FROM staging.stg_order_items i
JOIN marts.fct_orders o USING (order_id)         
LEFT JOIN staging.stg_products p USING (product_id);
