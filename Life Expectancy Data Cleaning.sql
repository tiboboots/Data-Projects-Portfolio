USE WorldLifeProject; 

-- Original Table with uncleaned data
SELECT *
FROM WLE_ORIGINAL;

-- Searching for and deleting duplicate records
SELECT *
FROM(
SELECT Row_ID, Country, Year, ROW_NUMBER() OVER(PARTITION BY Country, Year) row_count
FROM WLE) AS derived
WHERE row_count > 1;

DELETE FROM WLE
WHERE Row_ID IN(
SELECT Row_ID
FROM(
SELECT Row_ID, Country, Year, ROW_NUMBER() OVER(PARTITION BY Country, Year) row_count
FROM WLE) AS derived
WHERE row_count > 1 
);


-- Replacing blank values with NULL in Lifeexpectancy column, to prevent potential skewed results when performing aggregations  
UPDATE WLE
SET Lifeexpectancy = NULL
WHERE Lifeexpectancy = '';

-- Replacing NULL values in Lifeexpectancy column with approximate average Lifeexpectancy per country, using CTE
WITH CTE1 AS(
SELECT Country,
ROUND(AVG(Lifeexpectancy)) AS avg_life
FROM WLE
WHERE Country IN(
    SELECT Country
    FROM WLE
    WHERE Lifeexpectancy IS NULL
)
GROUP BY Country)

UPDATE WLE AS W1
JOIN CTE1 ON W1.Country = CTE1.Country
SET W1.Lifeexpectancy = CTE1.avg_life
WHERE W1.Lifeexpectancy IS NULL;

SELECT Country, Year, Lifeexpectancy
FROM WLE
WHERE Year = 2018 AND Country IN('Afghanistan', 'Albania');

-- Updating the Lifeexpectancy column values to have rounded format instead of decimal values
UPDATE WLE
SET Lifeexpectancy = ROUND(Lifeexpectancy);

-- Replacing NULL values in Status column with non null values from the same Country
UPDATE WLE
SET Status = NULL
WHERE Status = '';

UPDATE WLE AS w1
JOIN WLE AS w2 ON w1.Country = w2.Country
SET w1.Status = w2.Status
WHERE w1.Status IS NULL
AND w2.Status IS NOT NULL;










