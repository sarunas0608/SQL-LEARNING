/* ================================================================================
LESSON 03: SQL WHERE CONDITIONS
Topic: Filtering Data with Logical Operators, Ranges, and Pattern Matching
Target Tables: customers
================================================================================
*/

--------------------------------------------------------------------------------
-- SECTION 1: BASIC COMPARISON OPERATORS
--------------------------------------------------------------------------------

-- TASK 1.1: Retrieve all customers from Germany
-- Use '=' for exact matches.
SELECT * FROM customers
WHERE country = 'Germany';
GO

-- TASK 1.2: Retrieve all customers who are not from Germany
-- TIP: both '!=' and '<>' are accepted in MS SQL Server for "Not Equal".
SELECT * FROM customers
WHERE country != 'Germany';
GO

-- TASK 1.3: Retrieve all the customers where the score is less or equal than 500
SELECT * FROM customers
WHERE score <= 500;
GO


--------------------------------------------------------------------------------
-- SECTION 2: LOGICAL OPERATORS (AND, OR, NOT)
--------------------------------------------------------------------------------

-- TASK 2.1: Retrieve all customers from USA AND have a score greater than 500
-- Both conditions must be true.
SELECT * FROM customers
WHERE country = 'USA' AND score > 500;
GO

-- TASK 2.2: Retrieve all customers from USA OR have a score greater than 500
-- At least one condition must be true.
SELECT * FROM customers
WHERE country = 'USA' OR score > 500;
GO

-- TASK 2.3: Retrieve all customers with score NOT less than 500
-- TIP: 'NOT score < 500' is logically the same as 'score >= 500'.
SELECT * FROM customers
WHERE NOT score < 500;
GO


--------------------------------------------------------------------------------
-- SECTION 3: RANGES AND SETS (BETWEEN, IN)
--------------------------------------------------------------------------------

-- TASK 3.1: Retrieve customers with score between 100 and 500
-- KEY TO REMEMBER: 'BETWEEN' is inclusive (includes 100 and 500).
SELECT * FROM customers
WHERE score BETWEEN 100 AND 500;
GO

-- TASK 3.2: Retrieve customers from either Germany or USA
-- Use 'IN' for cleaner code when checking against a list of values.
SELECT * FROM customers
WHERE country IN ('Germany', 'USA');
GO

-- TASK 3.3: Retrieve all customers NOT from Germany or USA
SELECT * FROM customers
WHERE country NOT IN ('Germany', 'USA');
GO


--------------------------------------------------------------------------------
-- SECTION 4: PATTERN MATCHING (LIKE & WILDCARDS)
--------------------------------------------------------------------------------

-- TASK 4.1: Find all customers whose first name starts with 'M'
-- '%' matches any number of characters.
SELECT * FROM customers
WHERE first_name LIKE 'M%';
GO

-- TASK 4.2: Find all customers whose first name ends with 'n'
SELECT * FROM customers
WHERE first_name LIKE '%n';
GO

-- TASK 4.3: Find all customers whose first name contains 'r'
SELECT * FROM customers
WHERE first_name LIKE '%r%';
GO

-- TASK 4.4: Find all customers whose first name has 'r' in the 3rd position
-- '_' matches exactly one character.
SELECT * FROM customers
WHERE first_name LIKE '__r%';
GO
