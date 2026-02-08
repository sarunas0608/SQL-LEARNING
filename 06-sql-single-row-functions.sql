/* ================================================================================
LESSON 06: SQL SINGLE-ROW FUNCTIONS
Topic: String, NUMERIC, DATE & TIME FUNCTIONS
================================================================================
*/

--------------------------------------------------------------------------------
-- SECTION 1: STRING FUNCTIONS. MANIPULATION (Data Cleaning & Formatting)
--------------------------------------------------------------------------------

-- TASK 1.1: Combining Columns & Case Standardization
SELECT 
    first_name,
    country,
    CONCAT(first_name, ' ', country) AS name_country, -- Merging strings
    LOWER(first_name) AS low_name,                   -- Case normalization
    UPPER(first_name) AS up_name 
FROM customers;

-- TASK 1.2: Data Hygiene - Detecting Hidden Spaces
-- Logic: Compare character length before and after trimming to find "dirty" data.
SELECT 
    first_name,
    LEN(first_name) AS original_len,
    LEN(TRIM(first_name)) AS clean_len,
    LEN(first_name) - LEN(TRIM(first_name)) AS space_flag
FROM customers
WHERE LEN(first_name) != LEN(TRIM(first_name));

-- TASK 1.3: Search and Replace (Cleaning Phone Numbers & Extensions)
SELECT
    '123-456-7890' AS raw_input,
    REPLACE('123-456-7890', '-', '') AS clean_phone,
    REPLACE('report.txt', '.txt', '.csv') AS converted_extension;

-- TASK 1.4: Dynamic Slicing (LEFT, RIGHT, SUBSTRING)
SELECT
    first_name,
    LEFT(TRIM(first_name), 2) AS first_2,
    RIGHT(first_name, 2) AS last_2,
    SUBSTRING(TRIM(first_name), 2, LEN(first_name)) AS name_clipped -- Removes 1st char
FROM customers;



--------------------------------------------------------------------------------
-- SECTION 2: NUMERIC FUNCTIONS
--------------------------------------------------------------------------------

-- TASK 2.1: Precision Rounding & Absolute Values
-- Note: Negative precision (e.g., -1) rounds to the nearest ten.
SELECT 
    3.516 AS raw_val,
    ROUND(3.516, 2) AS round_2,
    ROUND(3.516, 0) AS round_0,
    ROUND(3516, -1) AS round_to_tens,
    ABS(-10) AS absolute_value; -- Returns 10


--------------------------------------------------------------------------------
-- SECTION 3: DATE & TIME FUNCTIONS (Temporal Analysis)
--------------------------------------------------------------------------------

-- TASK 3.1: Extracting Date Parts & Truncation
SELECT
    OrderID,
    CreationTime,
    GETDATE() AS system_time,
    DATEPART(year, CreationTime) AS year_num,
    DATENAME(month, CreationTime) AS month_name,    -- Returns STRING (e.g., 'August')
    DATETRUNC(month, CreationTime) AS month_start,  -- Rounds to 1st of month
    EOMONTH(CreationTime) AS end_of_month           -- Last day of month
FROM Sales.Orders;

-- TASK 3.2: Grouping Data by Time Intervals
-- Calculating orders per year/month.
SELECT 
    YEAR(OrderDate) AS OrderYear,
    COUNT(*) AS NrOfOrders
FROM Sales.Orders
GROUP BY YEAR(OrderDate);

-- TASK 3.3: Date Arithmetic & Age Calculation
SELECT
    BirthDate,
    DATEDIFF(year, BirthDate, GETDATE()) AS age_in_years,
    DATEADD(day, -10, GETDATE()) AS ten_days_ago,
    ISDATE('2025-08-20') AS is_valid_check -- Returns 1 (True)
FROM Sales.Employees;



--------------------------------------------------------------------------------
-- SECTION 4: CASTING & ADVANCED FORMATTING
--------------------------------------------------------------------------------

-- TASK 4.1: CAST vs CONVERT (The "Standard" vs the "Specialist")
SELECT
    CAST('123' AS INT) AS basic_cast,
    CONVERT(INT, '123') AS basic_convert,
    CONVERT(VARCHAR, GETDATE(), 34) AS european_style, -- Style 34 = dd.mm.yyyy
    CAST(GETDATE() AS DATE) AS date_only
FROM Sales.Orders;

-- TASK 4.2: FORMAT for Localized Presentation
-- High flexibility for UI/Reporting (Note: slower than CONVERT for massive datasets).
SELECT 
    OrderID,
    FORMAT(CreationTime, 'MM-dd-yyyy') AS USA_Format,
    'Day ' + FORMAT(CreationTime, 'ddd MMM') + 
    ' Q' + DATENAME(quarter, CreationTime) + ' ' +
    FORMAT(CreationTime, 'yyyy hh:mm:ss tt') AS business_report_format
FROM Sales.Orders;


--------------------------------------------------------------------------------
-- SECTION 5: ANALYTICAL USE CASES (Gap Analysis & Durations)
--------------------------------------------------------------------------------

-- USE CASE: Shipping Duration Analysis
SELECT 
    MONTH(OrderDate) AS month_num,
    AVG(DATEDIFF(day, OrderDate, ShipDate)) as avg_shipping_days
FROM Sales.Orders
GROUP BY MONTH(OrderDate);

-- USE CASE: Time Gap Analysis (Detecting Intervals between Orders)
-- Using the LAG window function to compare current row with the previous one.
SELECT 
    OrderID,
    OrderDate AS CurrentOrderDate,
    LAG(OrderDate) OVER (ORDER BY OrderDate) AS PreviousOrderDate,
    DATEDIFF(Day, LAG(OrderDate) OVER (ORDER BY OrderDate), OrderDate) AS DaysSinceLastOrder
FROM Sales.Orders;

/* ?? FINAL BEST PRACTICES:
1. USE CAST for simple type changes (standard across SQL dialects).
2. USE CONVERT for date styling specifically in T-SQL.
3. USE FORMAT for localized reports where performance is less critical than readability.
4. USE DATETRUNC/EOMONTH for bucketed financial and inventory reporting.
*/