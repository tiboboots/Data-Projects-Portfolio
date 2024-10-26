USE Household_Income;

SELECT *
FROM USHI;

SELECT *
FROM STATS;

-- Searching for and deleting duplicate records

SELECT row_id
FROM(
SELECT row_id, id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) dups
FROM USHI) derived
WHERE dups > 1;

DELETE FROM USHI
WHERE row_id IN(
    SELECT row_id
FROM(
SELECT row_id, id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) dups
FROM USHI) derived
WHERE dups > 1
);

--Standardizing Columns

SELECT *
FROM USHI
WHERE Place IS NULL;

SELECT *
FROM USHI
WHERE State_Name = 'Alabama' AND County = 'Autauga County' ;

UPDATE USHI
SET Place = 'Autaugaville'
WHERE Place IS NULL AND County = 'Autauga County';

--

SELECT `Primary`, CONCAT(UPPER(LEFT(`Primary`, 1)), SUBSTRING(`Primary`, 2, LENGTH(`Primary`)))
FROM USHI;

UPDATE USHI
SET `Primary` = CONCAT(UPPER(LEFT(`Primary`, 1)), SUBSTRING(`Primary`, 2, LENGTH(`Primary`)));

--

SELECT *
FROM USHI
WHERE City = 'Pasadena' AND State_ab = 'TX' AND Area_Code != 713;

UPDATE USHI
SET Area_Code = 713
WHERE Area_Code IN(832, 'M')
AND Place = 'Elkhart'
AND City = 'Pasadena'
AND County = 'Anderson County'
AND State_Name = 'Texas';

--

SELECT DISTINCT(State_Name)
FROM USHI;

UPDATE USHI
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

--

SELECT DISTINCT(Type)
FROM USHI;

UPDATE USHI
SET Type = 'Borough'
WHERE Type = 'Boroughs'

--Removing Records of states with no statistical data in the STATS table

SELECT *
FROM STATS
WHERE Median = 0 OR Mean = 0;

DELETE FROM STATS
WHERE id IN(
SELECT id
FROM(
SELECT *
FROM STATS
WHERE Median = 0 OR Mean = 0) derived
);
