-- NULL VS '' they are not the same thing.


SELECT
  COUNTIF(phone IS NULL) AS Null_Output,
  COUNTIF(phone = '')    AS empty_strings,
  COUNTIF(phone IS NULL OR phone = '') AS total_missing
FROM raw.customers;
