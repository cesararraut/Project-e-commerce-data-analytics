CREATE OR REPLACE TABLE staging.seed_categories AS
SELECT * FROM UNNEST([
  STRUCT('SMARTPHONES' AS category_upper, 'Smartphones' AS category),
  STRUCT('LAPTOPS', 'Laptops'),
  STRUCT('AUDIO', 'Audio'),
  STRUCT('WEARABLES', 'Wearables'),
  STRUCT('TV & HOME THEATER', 'TV & Home Theater'),
  STRUCT('GAMING', 'Gaming'),
  STRUCT('SMART HOME', 'Smart Home'),
  STRUCT('ACCESSORIES', 'Accessories')
]);