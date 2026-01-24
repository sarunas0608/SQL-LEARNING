/* ================================================================================
LESSON 01: SQL SELECT QUERIES
Topic: Basic Querying, Filtering, and Aggregations
Target Tables: customers, orders
================================================================================
*/

--------------------------------------------------------------------------------
-- SECTION 1: BASIC SELECTION(SELECT) & FILTERING(WHERE)
--------------------------------------------------------------------------------

-- TASK 1.1: Retrieve all customer data
-- Use '*' to grab every column in the table.
SELECT * FROM customers;
GO

-- TASK 1.2: Retrieve specific columns
-- Best practice: Only pull necessary columns to save memory and performance.
SELECT 
    first_name, 
    country, 
    score 
FROM customers;
GO

-- TASK 1.3: Retrieve customers with a score not equal to 0
-- Filters rows where the score is strictly not zero.
SELECT * FROM customers
WHERE score != 0;
GO

-- TASK 1.4: Retrieve customers from Germany
-- String values (text) must be wrapped in single quotes.
SELECT
    first_name,
    country
FROM customers
WHERE country = 'Germany';
GO


--------------------------------------------------------------------------------
-- SECTION 2: SORTING (ORDER BY)
--------------------------------------------------------------------------------

-- TASK 2.1: Retrieve all customers and sort results by the highest score first
SELECT * FROM customers
ORDER BY score DESC;
GO

-- TASK 2.2: Retrieve all customers and sort results by the country and then by the highest score
-- Sorts by Country (A-Z) first, then Score (Highest to Lowest) within each country.
SELECT * FROM customers
ORDER BY
    country ASC,
    score DESC;
GO


--------------------------------------------------------------------------------
-- SECTION 3: AGGREGATIONS & GROUPING
--------------------------------------------------------------------------------

-- TASK 3.1: Find the total score for each country
-- When using SUM, the non-aggregated column (country) must be in GROUP BY.
SELECT 
    country,
    SUM(score) AS total_score
FROM customers
GROUP BY country;
GO

-- TASK 3.2: Find the total score and total number of customers for each country
SELECT 
    country, 
    SUM(score) AS total_score, 
    COUNT(id) AS total_customers
FROM customers
GROUP BY country;
GO

-- TASK 3.3: Find the average score for each country considering only customers with a score not equal to 0
-- and return only those countries with an average score greater than 430.
SELECT 
    country, 
    AVG(score) AS avg_score
FROM customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 430;
GO



--------------------------------------------------------------------------------
-- SECTION 4: UNIQUE LISTS & TOP RECORDS
--------------------------------------------------------------------------------

-- TASK 4.1: Return unique list of all countries
SELECT DISTINCT country
FROM customers;
GO

-- TASK 4.2: Retrieve top 3 customers with the highest scores
SELECT TOP 3 * FROM customers
ORDER BY score DESC;
GO

-- TASK 4.3: Retrieve the lowest 2 customers based on the score
-- Using ASC (default) gets the lowest numbers at the top.
SELECT TOP 2 *
FROM customers
ORDER BY score ASC;
GO

-- TASK 4.4: Get the 2 most recent orders
-- Sorting by date descending puts the newest records first.
SELECT TOP 2 *
FROM orders
ORDER BY order_date DESC;
GO