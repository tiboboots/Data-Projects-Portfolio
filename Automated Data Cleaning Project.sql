USE Household_Income;

DELIMITER $$

CREATE PROCEDURE auto_clean()
BEGIN

DROP TABLE IF EXISTS USHI_copy;

CREATE TABLE IF NOT EXISTS `USHI_copy` (
  `row_id` int NOT NULL,
  `id` int NOT NULL,
  `State_Code` int NOT NULL,
  `State_Name` varchar(20) NOT NULL,
  `State_ab` varchar(2) NOT NULL,
  `County` varchar(33) NOT NULL,
  `City` varchar(22) NOT NULL,
  `Place` varchar(36) DEFAULT NULL,
  `Type` varchar(12) NOT NULL,
  `Primary` varchar(5) NOT NULL,
  `Zip_Code` int NOT NULL,
  `Area_Code` varchar(3) NOT NULL,
  `ALand` bigint NOT NULL,
  `AWater` bigint NOT NULL,
  `Lat` decimal(10,7) NOT NULL,
  `Lon` decimal(12,7) NOT NULL,
  `TimeStamp` TIMESTAMP NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO USHI_copy
SELECT *, CURRENT_TIMESTAMP
FROM USHI_Original;

DELETE FROM `USHI_copy`
WHERE row_id IN(
    SELECT row_id
FROM(
SELECT row_id, id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) dups
FROM `USHI_copy`) derived
WHERE dups > 1);

UPDATE `USHI_copy`
SET Place = 'Autaugaville'
WHERE Place IS NULL AND County = 'Autauga County';

UPDATE `USHI_copy`
SET `Primary` = CONCAT(UPPER(LEFT(`Primary`, 1)), SUBSTRING(`Primary`, 2, LENGTH(`Primary`)));

UPDATE `USHI_copy`
SET Area_Code = 713
WHERE Area_Code IN(832, 'M')
AND Place = 'Elkhart'
AND City = 'Pasadena'
AND County = 'Anderson County'
AND State_Name = 'Texas';

UPDATE `USHI_copy`
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

UPDATE `USHI_copy`
SET Type = 'Borough'
WHERE Type = 'Boroughs';

END $$

DELIMITER ;

CREATE EVENT auto_procedure_clean
ON SCHEDULE EVERY 30 DAY
DO CALL auto_clean();