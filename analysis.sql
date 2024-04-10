USE console_games_project;

SELECT 
    *
FROM
    console_games;
    
-- How many records are there in the dataset?
SELECT 
    COUNT(*) AS Total_Records
FROM
    console_games;

-- What are the distinct platforms available in the dataset?
SELECT DISTINCT
    Platform
FROM
    console_games;

-- What are the distinct genres available in the dataset?
SELECT DISTINCT
    Genre
FROM
    console_games;
    
-- What are the distinct publishers available in the dataset?
SELECT DISTINCT
    Publisher
FROM
    console_games;
    
-- What is the total number of games released each year?
SELECT 
    `Year`, COUNT(`Rank`) AS Game_Created_Count
FROM
    console_games
GROUP BY `Year`
ORDER BY `Year`;

-- What is the total global sales (sum of NA_Sales, EU_Sales, JP_Sales, Other_Sales) for each year?
SELECT 
    `Year`,
    ROUND(SUM(NA_Sales), 2) AS Sum_NA_Sales,
    ROUND(SUM(EU_Sales), 2) AS Sum_EU_Sales,
    ROUND(SUM(JP_Sales), 2) AS Sum_JP_Sales,
    ROUND(SUM(Other_Sales), 2) AS Sum_Other_Sales
FROM
    console_games
GROUP BY `Year`
ORDER BY `Year`;

-- What is the average sales (NA_Sales, EU_Sales, JP_Sales, Other_Sales) for each genre?
SELECT 
    `Genre`,
    ROUND(AVG(NA_Sales), 2) AS Avg_NA_Sales,
    ROUND(AVG(EU_Sales), 2) AS Avg_EU_Sales,
    ROUND(AVG(JP_Sales), 2) AS Avg_JP_Sales,
    ROUND(AVG(Other_Sales), 2) AS Avg_Other_Sales
FROM
    console_games
GROUP BY `Genre`
ORDER BY `Genre`;

-- What is the total sales for each platform?
SELECT 
    Platform,
    ROUND(SUM(NA_Sales) + SUM(EU_Sales) + SUM(JP_Sales) + SUM(Other_Sales), 2) AS Total_Sales
FROM
    console_games
GROUP BY Platform
ORDER BY Total_Sales DESC;

-- What is the top-selling genre in terms of global sales?
SELECT 
    Genre,
    ROUND(SUM(NA_Sales) + SUM(EU_Sales) + SUM(JP_Sales) + SUM(Other_Sales),
            2) AS Total_Sales
FROM
    console_games
GROUP BY Genre
ORDER BY Total_Sales DESC
LIMIT 1;

-- Which game has the highest NA_Sales?
SELECT 
    `Name`, `NA_Sales`
FROM
    console_games
ORDER BY `NA_Sales` DESC
LIMIT 1;

-- Which game has the highest JP_Sales?
SELECT 
    `Name`, `JP_Sales`
FROM
    console_games
ORDER BY `JP_Sales` DESC
LIMIT 1;

-- List the top 10 games with the highest global sales.
SELECT 
    `Name`,
    ROUND(NA_Sales + EU_Sales + JP_Sales + Other_Sales,
            2) AS Total_Sales
FROM
    console_games
ORDER BY Total_Sales DESC
LIMIT 10;

-- List the games released after a certain year.
SELECT 
    `Name`, `Year`
FROM
    console_games
WHERE
    `Year` > 2002
ORDER BY `Year`;

-- List the games released between a range of years.
SELECT 
    `Name`, `Year`
FROM
    console_games
WHERE
    `Year` BETWEEN 2002 AND 2004
ORDER BY `Year`;