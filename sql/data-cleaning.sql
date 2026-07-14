-- First I ran a query to check the total missing counts
SELECT
  COUNT(*) AS total_rows,
  COUNT(*) - COUNT(Category) AS missing_category,
  COUNT(*) - COUNT(Price) AS missing_price,
  COUNT(*) - COUNT(Rating) AS missing_rating,
  COUNT(*) - COUNT(Stock) AS missing_stock,
  COUNT(*) - COUNT(Discount) AS missing_discount
FROM synthetic_dataset;

-- Next I am going to create a completely new table, so that the raw data is preserved
-- This new table will return the same amount of rows as the original. However, null 
-- values in the Category and Stock columns are replaced with "Unknown", and Price nulls
-- are replaced with the average price, discount nulls are replaced with 0. Rating nulls were
-- left untouched

CREATE TABLE synthetic_dataset_clean AS
SELECT
  CASE WHEN Category IS NULL THEN 'Unknown' ELSE Category END AS Category,
  CASE WHEN Price IS NULL 
       THEN (SELECT AVG(Price) FROM synthetic_dataset WHERE Price IS NOT NULL)
       ELSE Price 
  END AS Price,
  Rating,
  CASE WHEN Stock IS NULL THEN 'Unknown' ELSE Stock END AS Stock,
  CASE WHEN Discount IS NULL THEN 0 ELSE Discount END AS Discount
FROM synthetic_dataset;

-- This query checks that the row counts match the original dataset. This is an
-- important diagnostic step before we go further

SELECT
  (SELECT COUNT(*) FROM synthetic_dataset) AS original_rows,
  (SELECT COUNT(*) FROM synthetic_dataset_clean) AS clean_rows;

-- This query confirms that the nulls are gone. As expected, the only
-- column with null values is missing_rating (2050), since I left that column untouched

SELECT
  COUNT(*) - COUNT(Category) AS missing_category,
  COUNT(*) - COUNT(Price) AS missing_price,
  COUNT(*) - COUNT(Stock) AS missing_stock,
  COUNT(*) - COUNT(Discount) AS missing_discount,
  COUNT(*) - COUNT(Rating) AS missing_rating 
FROM synthetic_dataset_clean;






