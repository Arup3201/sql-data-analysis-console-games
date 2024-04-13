# Data Analysis using SQL - Console Games Dataset

This project focuses on analysing console games dataset using sql queries. Here we are finding the answers of some questions asked by our user about the dataset using SQL.

## Questions

1. **Basic Data Retrieval:**
   
   - How many records are there in the dataset?
   - What are the distinct platforms available in the dataset?
   - What are the distinct genres available in the dataset?
   - What are the distinct publishers available in the dataset?

2. **Aggregation and Summary Statistics:**
   
   - What is the total number of games released each year?
   - What is the total global sales (sum of NA_Sales, EU_Sales, JP_Sales, Other_Sales) for each year?
   - What is the average sales (NA_Sales, EU_Sales, JP_Sales, Other_Sales) for each genre?
   - What is the total sales for each platform?
   - What is the top-selling genre in terms of global sales?

3. **Filtering and Sorting:**
   
   - Which game has the highest NA_Sales?
   - Which game has the highest JP_Sales?
   - List the top 10 games with the highest global sales.
   - List the games released after a certain year.
   - List the games released between a range of years.

4. **Grouping and Aggregating:**
   
   - How many games were released for each platform?
   - What is the total sales for each genre in North America?
   - What is the average sales for each publisher in Europe?
   - How many games were released for each platform in each year?

5. **Joining Tables (if you have additional tables):**
   
   - If you have another table with information about the developers of the games, you could join it with this table to answer questions like "What is the total sales for games developed by each developer?"

6. **Subqueries and Advanced Filtering:**
   
   - List the games with sales above the average sales in North America.
   - List the games with sales above the average sales for their respective genres.
   - Find the games with sales above a certain threshold in all regions combined.

7. **Data Cleaning and Transformation:**
   
   - Convert the sales columns (NA_Sales, EU_Sales, JP_Sales, Other_Sales) to a consistent currency format.
   - Handle missing values if any.
   - Normalize sales data by dividing by the maximum sales value to bring them to a common scale.

## Answers

1.1. 

```
SELECT 
COUNT(*) AS Total_Records
FROM
 console_games;
```

Total number of records in the table `15793`.

1.2. 

```
SELECT DISTINCT
 Platform
FROM
 console_games;
```

There are total `32` Platforms that has released console games.

![](D:\Projects\sql-data-analysis-console-games\outputs\1.2.png)

1.3.

```
SELECT DISTINCT
    Genre
FROM
    console_games;
```

There are `12` different genres available in the dataset.

![](D:\Projects\sql-data-analysis-console-games\outputs\1.3.png)

2.1.

```
SELECT DISTINCT
    Publisher
FROM
    console_games;
```

There are total `565` publishers who has published console games.

![](D:\Projects\sql-data-analysis-console-games\outputs\2.1.png)

2.2.

```
SELECT 
    `Year`, COUNT(`Rank`) AS Game_Created_Count
FROM
    console_games
GROUP BY `Year`
ORDER BY `Game_Created_Count` DESC;
```

![](D:\Projects\sql-data-analysis-console-games\outputs\2.2.png)

2.3.

```
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
```

![](D:\Projects\sql-data-analysis-console-games\outputs\2.3.png)

2.4.

```
SELECT 
    Platform,
    ROUND(SUM(NA_Sales) + SUM(EU_Sales) + SUM(JP_Sales) + SUM(Other_Sales), 2) AS Total_Sales
FROM
    console_games
GROUP BY Platform
ORDER BY Total_Sales DESC;
```

![](D:\Projects\sql-data-analysis-console-games\outputs\2.4.png)

2.5.

```
SELECT 
    Genre,
    ROUND(SUM(NA_Sales) + SUM(EU_Sales) + SUM(JP_Sales) + SUM(Other_Sales),
            2) AS Total_Sales
FROM
    console_games
GROUP BY Genre
ORDER BY Total_Sales DESC
LIMIT 1;
```

![](D:\Projects\sql-data-analysis-console-games\outputs\2.5.png)

3.1.

```
SELECT 
    `Name`, `NA_Sales`
FROM
    console_games
ORDER BY `NA_Sales` DESC
LIMIT 1;
```

![](D:\Projects\sql-data-analysis-console-games\outputs\3.1.png)

3.2.

```
SELECT 
    `Name`, `JP_Sales`
FROM
    console_games
ORDER BY `JP_Sales` DESC
LIMIT 1;
```

![](D:\Projects\sql-data-analysis-console-games\outputs\3.2.png)

3.3.

```
SELECT 
    `Name`,
    ROUND(NA_Sales + EU_Sales + JP_Sales + Other_Sales,
            2) AS Total_Sales
FROM
    console_games
ORDER BY Total_Sales DESC
LIMIT 10;
```

![](D:\Projects\sql-data-analysis-console-games\outputs\3.3.png)

3.4.

```
SELECT 
    `Name`, `Year`
FROM
    console_games
WHERE
    `Year` > 2002
ORDER BY `Year`;
```

![](D:\Projects\sql-data-analysis-console-games\outputs\3.4.png)

3.5.

```
SELECT 
    `Name`, `Year`
FROM
    console_games
WHERE
    `Year` BETWEEN 2002 AND 2004
ORDER BY `Year`;
```

![](D:\Projects\sql-data-analysis-console-games\outputs\3.5.png)

4.1.

```
SELECT 
    Platform, COUNT(`Name`) AS Game_Count
FROM
    console_games
GROUP BY Platform
ORDER BY Game_Count DESC;
```

![](D:\Projects\sql-data-analysis-console-games\outputs\4.1.png)

4.2.

```
SELECT 
    Genre, ROUND(SUM(NA_Sales), 2) AS Sales
FROM
    console_games
GROUP BY Genre
ORDER BY Sales DESC;
```

![](D:\Projects\sql-data-analysis-console-games\outputs\4.2.png)

4.3.

```
SELECT 
    Publisher, ROUND(AVG(EU_Sales), 2) AS Avg_Sales
FROM
    console_games
GROUP BY Publisher
ORDER BY Avg_Sales DESC;
```

![](D:\Projects\sql-data-analysis-console-games\outputs\4.3.png)

4.4.

```
SELECT 
    `Year`, Platform, COUNT(`Name`) AS Game_Count
FROM
    console_games
GROUP BY `Year`, Platform
ORDER BY `Year`;
```

![](D:\Projects\sql-data-analysis-console-games\outputs\4.3.png)

6.1.

```
SELECT 
    `Name`, NA_Sales
FROM
    console_games
WHERE
    NA_Sales > (SELECT 
            AVG(NA_Sales) AS Avg_NA_Sales
        FROM
            console_games);
```

![](D:\Projects\sql-data-analysis-console-games\outputs\4.4.png)

6.2.

```
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
```

![](D:\Projects\sql-data-analysis-console-games\outputs\6.2.png)

6.3.

```
SELECT 
    `Rank`, `Name`,
    ROUND(`NA_Sales` + `EU_Sales` + `JP_Sales` + `Other_Sales`,
            2) AS `Sales`
FROM
    console_games
HAVING
    `Sales` > 3.0
ORDER BY `Sales` DESC;
```

![](D:\Projects\sql-data-analysis-console-games\outputs\6.3.png)

7.1.

```
SELECT 
    `Rank`,
    `Name`,
    CONCAT('$', FORMAT(`NA_Sales`, 2, 'en_US')) AS NA_Sales,
    CONCAT('$', FORMAT(`EU_Sales`, 2, 'en_US')) AS EU_Sales,
    CONCAT('$', FORMAT(`JP_Sales`, 2, 'en_US')) AS JP_Sales,
    CONCAT('$', FORMAT(`Other_Sales`, 2, 'en_US')) AS Other_Sales
FROM
    console_games;
```

![](D:\Projects\sql-data-analysis-console-games\outputs\7.1.png)

7.2.

```
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
```

7.3.

```
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
```
