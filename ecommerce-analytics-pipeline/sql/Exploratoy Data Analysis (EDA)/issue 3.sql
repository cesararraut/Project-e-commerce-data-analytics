-- Issue 3: how many rows are in each date format?
SELECT
  COUNTIF(REGEXP_CONTAINS(order_ts, r'^\d{4}-\d{2}-\d{2} '))  AS iso_with_time,
  COUNTIF(REGEXP_CONTAINS(order_ts, r'^\d{4}-\d{2}-\d{2}$'))  AS iso_date_only,
  COUNTIF(REGEXP_CONTAINS(order_ts, r'^\d{2}/\d{2}/\d{4} '))  AS us_with_time,
  COUNTIF(REGEXP_CONTAINS(order_ts, r'^\d{2}/\d{2}/\d{4}$'))  AS us_date_only
FROM raw.orders;
-- 78,375 | 8,720 | 13,879 | 1,567   (sums to all 102,541 rows - if yours
-- does not, there is a format you have not accounted for yet)