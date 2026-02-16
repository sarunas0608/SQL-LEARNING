/* ================================================================================
LESSON 07: STRING & WINDOW FUNCTIONS, CASE WHEN
Topic: STRING FUNCTIONS, NULL LOGIC, WINDOW FUNCTIONS AND CASE WHEN
================================================================================
*/

--------------------------------------------------------------------------------
-- SECTION 1: DATA CLEANING & NULL HYGIENE
--------------------------------------------------------------------------------

-- TASK 1.1: Handling Nulls in Scores & Name Formatting
-- Logic: Use COALESCE to ensure math works even if data is missing.
SELECT 
    CustomerID,
    FirstName + ' ' + COALESCE(LastName, '') AS FullName,
    Score,
    COALESCE(Score, 0) AS Score_Clean,
    COALESCE(Score, 0) + 10 AS Score_With_Bonus,
    AVG(Score) OVER () AS Raw_Avg,
    AVG(COALESCE(Score, 0)) OVER() AS Normalized_Avg
FROM Sales.Customers;

-- TASK 1.2: Precision Logic - Preventing "Division by Zero"
-- Logic: NULLIF turns 0 into NULL, making the result NULL instead of an error.
SELECT 
    OrderID,
    Sales,
    Quantity,
    Sales / NULLIF(Quantity, 0) AS Price_Per_Unit
FROM Sales.Orders;

-- TASK 1.3: Advanced String Cleaning (The "Clean Policy" Stack)
-- Logic: TRIM spaces -> NULLIF empty strings -> COALESCE final NULLs.
WITH CategoryData AS (
    SELECT 1 AS ID, 'A' AS Cat UNION SELECT 2, NULL UNION
    SELECT 3, '' UNION SELECT 4, ' '
)
SELECT *,
    TRIM(Cat) AS Policy_1,
    NULLIF(TRIM(Cat), '') AS Policy_2,
    COALESCE(NULLIF(TRIM(Cat), ''), 'unknown') AS Final_Clean_Category
FROM CategoryData;


--------------------------------------------------------------------------------
-- SECTION 2: CONDITIONAL LOGIC & REPORTING (CASE WHEN)
--------------------------------------------------------------------------------

-- TASK 2.1: Sales Performance Segmentation (Derived Table)
SELECT
    Sales_Bucket,
    SUM(Sales) AS Total_Bucket_Value
FROM (
    SELECT Sales,
        CASE
            WHEN Sales > 50 THEN 'HIGH'
            WHEN Sales > 20 THEN 'MEDIUM'
            ELSE 'LOW'
        END AS Sales_Bucket
    FROM Sales.Orders
) AS t
GROUP BY Sales_Bucket
ORDER BY Total_Bucket_Value DESC;

-- TASK 2.2: Data Normalization (Country & Gender Codes)
SELECT 
    CustomerID,
    Country,
    CASE
        WHEN Country = 'Germany' THEN 'DE'
        WHEN Country = 'USA' THEN 'US'
        ELSE 'n/a'
    END AS Country_Code,
    CASE
        WHEN Gender = 'M' THEN 'Male'
        WHEN Gender = 'F' THEN 'Female'
        ELSE 'Not available'
    END AS Gender_Full
FROM Sales.Customers;


--------------------------------------------------------------------------------
-- SECTION 3: WINDOW FUNCTIONS (Advanced Analytics)
--------------------------------------------------------------------------------

-- TASK 3.1: Global vs Partitioned Totals
-- Logic: Compare individual order against product category totals in one row.
SELECT
    OrderID,
    ProductID,
    Sales,
    SUM(Sales) OVER () AS Company_Total,
    SUM(Sales) OVER (PARTITION BY ProductID) AS Product_Category_Total,
    SUM(Sales) OVER (PARTITION BY ProductID, OrderStatus) AS Category_Status_Total
FROM Sales.Orders;

-- TASK 3.2: Ranking & Sequencing
SELECT
    OrderID,
    CustomerID,
    Sales,
    RANK() OVER (ORDER BY Sales DESC) AS Sales_Rank,
    ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS Customer_Order_Seq
FROM Sales.Orders;

-- TASK 3.3: Window Framing (Moving Windows)
-- Logic: Calculate sum including current row and the next two rows.
SELECT
    OrderID,
    Sales,
    SUM(Sales) OVER (
        PARTITION BY OrderStatus 
        ORDER BY OrderDate
        ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
    ) AS Moving_Sum_Window
FROM Sales.Orders;


--------------------------------------------------------------------------------
-- SECTION 4: DATA INTEGRITY & AUDITING
--------------------------------------------------------------------------------

-- TASK 4.1: Duplicate Detection Logic (Primary Key Audit)
-- Logic: Any result > 1 indicates a duplicate ID violation.
SELECT
    OrderID,
    COUNT(*) OVER (PARTITION BY OrderID) AS PK_Check_Count
FROM Sales.Orders;

-- TASK 4.2: Anti-Join Logic (Finding Ghost Records)
-- Logic: Find customers who exist in the database but have 0 orders.
SELECT c.CustomerID, c.FirstName, o.OrderID
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;

-- TASK 4.3: Custom Sort Order (NULLS Last Technique)
SELECT CustomerID, Score
FROM Sales.Customers
ORDER BY (CASE WHEN Score IS NULL THEN 1 ELSE 0 END) ASC, Score ASC;


--------------------------------------------------------------------------------
-- SECTION 5: MODERN SQL ARCHITECTURE (CTEs)
--------------------------------------------------------------------------------

-- TASK 5.1: Multi-Step Analysis Pipeline
WITH Customer_Sales AS (
    SELECT CustomerID, SUM(Sales) AS Total_Spent
    FROM Sales.Orders
    GROUP BY CustomerID
)
SELECT 
    cs.*, 
    RANK() OVER (ORDER BY Total_Spent DESC) AS Spend_Rank
FROM Customer_Sales cs;

/* ✅ FINAL BEST PRACTICES:
1. Always use NULLIF(col, 0) for divisions to prevent script crashes.
2. Use CTEs (WITH) instead of nested subqueries for complex logic.
3. COALESCE should be used in every string concatenation to avoid NULL results.
4. Window Functions are 10x more efficient than Self-Joins for running totals.
*/