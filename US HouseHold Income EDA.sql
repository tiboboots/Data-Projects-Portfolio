USE Household_Income;

SELECT *
FROM USHI;

--Cities with the highest average household incomes per year.
--San Jose and San Francisco have the highest average incomes per year.
--This makes sense, as the cost of living in California tends to be very high,
--and both San Jose and San Francisco are home to massive tech companies that have high earning employees,
--such as Google, Apple, and Amazon.

--New York and Seattle also have very high average incomes, for similar reasons as listed above.
--Due to there being high revenue companies in these cities with high earning employees,
--the average income is naturally higher. The cost of living is also much higher than in other states,
--so only high earners can afford to live in these areas.

SELECT u.State_Name, City,
COUNT(City) AS count_,
ROUND(AVG(Mean)) avg_income
FROM USHI u
JOIN STATS s ON u.id = s.id
GROUP BY City, u.State_Name
HAVING count_ > 50
ORDER BY avg_income DESC;

/* Top 10 States with the highest average household incomes. 
The District of Columbia leads all states with an average household income of around 91.000 USD per year.
All 10 states earn above the overall average household income, which is 67.356 USD. */

SELECT u.State_Name,
COUNT(u.State_Name) count_,
ROUND(AVG(s.Mean)) highest_income,
67356 AS overall_avg_income
FROM USHI AS u
JOIN STATS AS s ON u.id = s.id
GROUP BY u.State_Name
ORDER BY highest_income DESC
LIMIT 10;

-- Bottom 10 states with the lowest average household income. 
-- Mississipi is the lowest earning state, at around 49.000 USD per household per year.
-- This is most likely due to the lower cost of living in Mississipi and other low ranking states compared to states with higher average incomes,
-- as the cost of living tends to increase for the states with higher average incomes, due to having more wealthy people in their areas and bigger companies.
-- All of the bottom 10 states earn less than the overall average household income of 67.356 USD.

SELECT u.State_Name,
COUNT(u.State_Name) count_,
ROUND(AVG(s.Mean)) lowest_income,
67356 AS overall_avg_income
FROM USHI AS u
JOIN STATS AS s ON u.id = s.id
GROUP BY u.State_Name
ORDER BY lowest_income ASC
LIMIT 10;