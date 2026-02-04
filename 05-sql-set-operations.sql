/* ================================================================================
LESSON 05: SQL SET OPERATORS
Topic: Vertical Data Merging, Delta Detection, and Quality Assurance
Target Tables: sales.Employees, sales.Customers, sales.Orders, sales.OrdersArchive
================================================================================
*/

--------------------------------------------------------------------------------
-- 🛡️ THE 6 GOLDEN RULES OF SET OPERATORS (Reference Checklist)
--------------------------------------------------------------------------------
/* #1 RULE | ORDER BY can be used only once (must be the very last statement).
   #2 RULE | Same Number of Columns in every SELECT statement.
   #3 RULE | Matching Data Types for corresponding columns.
   #4 RULE | Same Order of Columns in each SELECT block.
   #5 RULE | First Query Controls Aliases (final column names).
   #6 RULE | Mapping Correct Columns (Logic check: match names with names, IDs with IDs).
*/

--------------------------------------------------------------------------------
-- USE CASE 1: COMBINE INFORMATION (Stacking Datasets)
-- Scenario: Creating a unified contact list for marketing or logistics.
--------------------------------------------------------------------------------

-- TASK 1.1: Combine all names from employees and customers into one list
-- UNION: Automatically removes duplicate names.
SELECT FirstName, LastName FROM sales.Employees
UNION
SELECT FirstName, LastName FROM sales.Customers;
GO

-- TASK 1.2: Unified report with Source Identification
-- BEST PRACTICE: Add a literal string to track the origin of each row.
SELECT FirstName, LastName, 'Employee' AS Category FROM sales.Employees
UNION ALL
SELECT FirstName, LastName, 'Customer' AS Category FROM sales.Customers;
GO


--------------------------------------------------------------------------------
-- USE CASE 2: DELTA DETECTION (Identifying Changes)
-- Scenario: Finding new data that was added after a backup or archive.
--------------------------------------------------------------------------------

-- TASK 2.1: Find employees who are NOT customers (The "Difference")
-- EXCEPT is perfect for finding records that exist in List A but not in List B.
SELECT FirstName, LastName FROM sales.Employees
EXCEPT
SELECT FirstName, LastName FROM sales.Customers;
GO

-- TASK 2.2: Identify "New" orders not yet present in the Archive
-- This is how you find data that needs to be synchronized or backed up.
SELECT OrderID FROM Sales.Orders
EXCEPT
SELECT OrderID FROM Sales.OrdersArchive;
GO


--------------------------------------------------------------------------------
-- USE CASE 3: DATA COMPLETENESS CHECK (QA & Integrity)
-- Scenario: Checking if data is synchronized and consistent across tables.
--------------------------------------------------------------------------------

-- TASK 3.1: Find common entities (INTERSECT)
-- Used to verify that "Shared" data actually exists in both places.
SELECT FirstName, LastName FROM sales.Employees
INTERSECT
SELECT FirstName, LastName FROM sales.Customers;
GO

-- TASK 3.2: Verify full synchronization between Orders and Archive
-- A combination of UNION and EXCEPT helps identify ANY mismatch in IDs.
SELECT [OrderID], [ProductID], [CustomerID], [SalesPersonID], [OrderDate], [Sales]
FROM Sales.Orders
UNION
SELECT [OrderID], [ProductID], [CustomerID], [SalesPersonID], [OrderDate], [Sales]
FROM Sales.OrdersArchive
ORDER BY OrderID; -- Applying Rule #1
GO



--------------------------------------------------------------------------------
-- 💡 FINAL NOTES & BEST PRACTICES
--------------------------------------------------------------------------------
/* - PERFORMANCE: Use UNION ALL by default. UNION is significantly slower because 
     the server must sort the data to find and remove duplicates.
   
   - COLUMN ALIASING: Remember Rule #5. If you rename a column in the second query, 
     SQL will ignore it and use the name from the first query.
   
   - DATA INTEGRITY: Use INTERSECT to quickly check if two lists share the same keys 
     before performing complex JOINs.
*/