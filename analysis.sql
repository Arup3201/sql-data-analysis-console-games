USE console_games_project;

DROP PROCEDURE IF EXISTS show_games;
DELIMITER $$
CREATE PROCEDURE show_games()
BEGIN
	SELECT 
		*
	FROM
		console_games;
END$$
DELIMITER ;

call show_games();

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
ORDER BY `Game_Created_Count` DESC;

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

-- How many games were released for each platform?
SELECT 
    Platform, COUNT(`Name`) AS Game_Count
FROM
    console_games
GROUP BY Platform
ORDER BY Game_Count DESC;

-- What is the total sales for each genre in North America?
SELECT 
    Genre, ROUND(SUM(NA_Sales), 2) AS Sales
FROM
    console_games
GROUP BY Genre
ORDER BY Sales DESC;

-- What is the average sales for each publisher in Europe?
SELECT 
    Publisher, ROUND(AVG(EU_Sales), 2) AS Avg_Sales
FROM
    console_games
GROUP BY Publisher
ORDER BY Avg_Sales DESC;


-- How many games were released for each platform in each year?
SELECT 
    `Year`, Platform, COUNT(`Name`) AS Game_Count
FROM
    console_games
GROUP BY `Year`, Platform
ORDER BY `Year`;

-- List the games with sales above the average sales in North America.
SELECT 
    `Name`, NA_Sales
FROM
    console_games
WHERE
    NA_Sales > (SELECT 
            AVG(NA_Sales) AS Avg_NA_Sales
        FROM
            console_games);

-- List the games with sales above the average sales for their respective genres.
SELECT 
    A.*, B.Avg_Sales
FROM
    (SELECT 
        `Name`,
            `Genre`,
            ROUND(`NA_Sales` + `EU_Sales` + `JP_Sales` + `Other_Sales`, 2) AS `Sales`
    FROM
        console_games) AS A
        JOIN
    (SELECT 
        `Genre`,
            ROUND(AVG(`NA_Sales` + `EU_Sales` + `JP_Sales` + `Other_Sales`), 2) AS `Avg_Sales`
    FROM
        console_games
    GROUP BY `Genre`
    ORDER BY `Genre`) AS B ON A.Genre = B.Genre
WHERE
    A.Sales > B.Avg_Sales
ORDER BY A.`Name`;

-- Find the games with sales above 3.0 in all regions combined.
SELECT 
    `Rank`, `Name`,
    ROUND(`NA_Sales` + `EU_Sales` + `JP_Sales` + `Other_Sales`,
            2) AS `Sales`
FROM
    console_games
HAVING
    `Sales` > 3.0
ORDER BY `Sales` DESC;


-- Convert the sales columns (NA_Sales, EU_Sales, JP_Sales, Other_Sales) to a consistent currency format.
SELECT 
    `Rank`,
    `Name`,
    CONCAT('$', FORMAT(`NA_Sales`, 2, 'en_US')) AS NA_Sales,
    CONCAT('$', FORMAT(`EU_Sales`, 2, 'en_US')) AS EU_Sales,
    CONCAT('$', FORMAT(`JP_Sales`, 2, 'en_US')) AS JP_Sales,
    CONCAT('$', FORMAT(`Other_Sales`, 2, 'en_US')) AS Other_Sales
FROM
    console_games;


-- Handle missing values if any.
call show_games();

DROP PROCEDURE IF EXISTS show_nulls;
DELIMITER $$
CREATE PROCEDURE show_nulls(IN p_column VARCHAR(20))
BEGIN
SET @s = CONCAT('SELECT COUNT(*) AS Null_Count_',p_column ,' FROM  console_games WHERE ', p_column, ' IS NULL;');
    PREPARE stm1 FROM @s;
    EXECUTE stm1;
    DEALLOCATE PREPARE stm1;
END$$
DELIMITER ;

call show_nulls('Name'); -- 3
call show_nulls('Platform'); -- 5
call show_nulls('Year'); -- 6
call show_nulls('Genre'); -- 0
call show_nulls('Publisher'); -- 0
call show_nulls('NA_Sales'); -- 0
call show_nulls('EU_Sales'); -- 0
call show_nulls('JP_Sales'); -- 1
call show_nulls('Other_Sales'); -- 0

CREATE TABLE console_games_cleaned AS
SELECT * FROM console_games;

UPDATE console_games_cleaned 
SET 
    `JP_Sales` = COALESCE(`JP_Sales`, 0);

UPDATE console_games_cleaned 
SET 
    `Name` = COALESCE(`Name`, 'NA');

UPDATE console_games_cleaned 
SET 
    `Platform` = COALESCE(`Platform`, 'NA');

DELETE FROM console_games_cleaned WHERE `Year` IS NULL;

-- Normalize sales data by dividing by the maximum sales value to bring them to a common scale.
CREATE TABLE console_games_norm AS SELECT `Rank`,
    `Name`,
    `Platform`,
    `Year`,
    `Genre`,
    `Publisher`,
    `NA_Sales` / max_na_sales AS `NA_Sales_norm`,
    `EU_Sales` / max_eu_sales AS `EU_Sales_norm`,
    `JP_Sales` / max_jp_sales AS `JP_Sales_norm`,
    `Other_Sales` / max_other_sales AS `Other_Sales_norm` FROM
    console_games,
    (SELECT 
        MAX(NA_Sales) AS max_na_sales,
            MAX(EU_Sales) AS max_eu_sales,
            MAX(JP_Sales) AS max_jp_sales,
            MAX(Other_Sales) AS max_other_sales
    FROM
        console_games) AS max_sales_table;


SELECT * FROM console_games_norm;