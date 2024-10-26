USE WorldLifeProject;

SELECT *
FROM WLE;

/* Countries with the Highest average life expectancy.
Most are developed countries while the countries with lower average life expectancies are mostly developing countries.
Chile and Costa Rica have the highest average life expectancies among developing countries, both at an avg of 79,
While Japan and Sweden have the highest life expectancies overall. */

SELECT Country, Status, ROUND(AVG(Lifeexpectancy)) AS avg_life
FROM WLE
WHERE Lifeexpectancy > 0
GROUP BY Country, Status
ORDER BY avg_life DESC;

/* Countries with the biggest increase in life expectancy.
African Countries have greatly increased their life expectancy over the years, 
but still rank low in terms of average life expectancy vs other countries. */

SELECT Country, Status,
MIN(Lifeexpectancy) lowest_life_exp,
MAX(Lifeexpectancy) highest_life_exp,
MAX(Lifeexpectancy) - MIN(Lifeexpectancy) AS life_increase,
ROUND(AVG(Lifeexpectancy)) AS avg_life
FROM WLE
WHERE Lifeexpectancy > 0
GROUP BY Country, Status
ORDER BY life_increase DESC;

/* Average Life Expectancy for all countries over the years.
We can see a steady increase over time, 
meaning that the average life expectancy for most countries is trending upwards as time goes on. */

SELECT Year,
ROUND(AVG(Lifeexpectancy)) avg_life_exp
FROM WLE
WHERE Lifeexpectancy > 0
GROUP BY Year
ORDER BY avg_life_exp DESC;

/* Countries with the highest total amount of adult and infant deaths, along with their average life expectancy.
Most are Developing Countries, with the exception of the USA being ranked quite high for a developed country.
Africa and Asia are the 2 continents with the most countries ranking high up.

A noticable trend is that countries with lower life expectancies have more total deaths in both categories,
with Amercia being an outlier, as they have a rather abnormal amount of infant deaths compared to other developed countries */

SELECT Country, Status, ROUND(AVG(Lifeexpectancy)) avg_life_exp,
SUM(infantdeaths) AS total_infant_deaths,
SUM(AdultMortality) AS total_adult_deaths
FROM WLE
GROUP BY Country, Status
HAVING total_infant_deaths > 0
AND total_adult_deaths > 0
ORDER BY avg_life_exp DESC;


/* Countries with the most cases of Polio, Diptheria, and Measles.
There doesn't seem to be any correlation between each country's status and the total amount of cases, 
as there are a mix of Developed and Developing Countries who rank quite high.
Countries with high cases of Polio also have high cases of diptheria, but not Measles. */

SELECT Country, Status, SUM(Polio) total_polio,
SUM(Diphtheria) total_diptheria,
SUM(Measles) AS total_measles
FROM WLE
GROUP BY Country, Status
ORDER BY total_polio DESC;


/* Average Life Expectancy Per Country vs Overall Average for Developing Countries.
Developing Countries above average appear to be mostly from South America, The Carribean, and Asia.
Developing Countries below average appear to mostly be from Africa.

Countries with an above average life expectancy also have higher GDP's than countries below average, 
which can lead us to believe that developing countries with stronger economies tend to have higher life expectancies.

Another noticable trend is that Developing Countries with have an above average life expectancy tend to have a higher average BMI,
compared to Developing Countries with a below average life expectancy, which have lower average BMI's.

This is most likely due to there being a lack of food for many citizens in the developing countries with a below average life expectancy,
while developing countries with an above average life expectancy have more food for their citizens due to their higher GDP and better economy,
which is why they also have a higher average BMI.

Developing Countries with higher average BMI's also have higher average GDP's,
which means that the worser the state of the country's economy, the lower the BMI, and the lower the average life expectancy is. */

WITH CTE1 AS(
SELECT Status, COUNT(DISTINCT Country) count_countries, ROUND(AVG(Lifeexpectancy)) AS overall_avg
FROM WLE
GROUP BY Status
ORDER BY overall_avg DESC)


SELECT W1.Country, W1.Status, ROUND(AVG(W1.Lifeexpectancy)) AS avg_life,
CTE1.overall_avg,
CASE WHEN ROUND(AVG(W1.Lifeexpectancy)) > 66 THEN 'Higher than Average'
WHEN ROUND(AVG(W1.Lifeexpectancy)) < 66 THEN 'Lower than Average'
ELSE 'Average'
END AS Life_Expectancy_Status,
ROUND(AVG(GDP)) AS avg_gdp,
ROUND(AVG(BMI)) AS avg_bmi
FROM WLE AS W1
JOIN CTE1 ON W1.Status = CTE1.Status
WHERE W1.Status = 'Developing'
GROUP BY W1.Country, W1.Status, CTE1.overall_avg
HAVING avg_life > 0 AND avg_gdp > 0
ORDER BY avg_life DESC;

/* Overall Average Life Expectancy for Developed Countries vs Average Life Expectancy Per Developed Country.
Developed Countries above average have higher average GDP's vs Countries below average,
which can lead us to believe that these Countries with stronger economies tend have higher life expectancies,
much like what we saw with developing countries above.

Japan seems to an outlier in terms of the correlation between their average life expectancy and their average BMI,
as most other developed countries that have high life expectancies also have higher average BMI's,
but Japan has a significantly lower average BMI while having the highest average life expectancy, which is interesting.

We could look into this more if we had more data, 
but one can assume that the reason why Japan has a lower average BMI compared to other developed countries is
that they have a very different diet of food compared to other countries. 
Most of the other developed countries on the list are western countries, which are known to eat more than East Asian countries like Japan. */

WITH CTE1 AS(
SELECT Status, ROUND(AVG(Lifeexpectancy)) AS overall_avg
FROM WLE
GROUP BY Status
ORDER BY overall_avg DESC)


SELECT W1.Country, W1.Status, ROUND(AVG(W1.Lifeexpectancy)) AS avg_life,
CTE1.overall_avg,
CASE WHEN ROUND(AVG(W1.Lifeexpectancy)) > 80 THEN 'Higher than Average'
WHEN ROUND(AVG(W1.Lifeexpectancy)) < 80 THEN 'Lower than Average'
ELSE 'Average'
END AS Life_Expectancy_Status,
ROUND(AVG(GDP)) AS avg_gdp,
ROUND(AVG(BMI)) AS avg_bmi
FROM WLE AS W1
JOIN CTE1 ON W1.Status = CTE1.Status
WHERE W1.Status = 'Developed'
GROUP BY W1.Country, W1.Status, CTE1.overall_avg
HAVING avg_gdp > 0
ORDER BY avg_life DESC;


