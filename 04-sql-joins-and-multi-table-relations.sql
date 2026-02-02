/* ================================================================================
LESSON 04: THE COMPLETE JOINS GUIDE
Topic: Relational Data - Combining Customers, Orders, Products, and Employees
================================================================================
*/

--------------------------------------------------------------------------------
-- SECTION 1: INNER JOINS (Strict Matches)
--------------------------------------------------------------------------------

-- TASK 1.1: Retrieve all data from customers and orders in two different results
-- Useful for initial data exploration before joining.
SELECT * FROM customers;
SELECT * FROM orders;
GO

-- TASK 1.2: Get all customers along with their orders, but only for customers who have placed an order
-- Note: id and customer_id must match exactly.
SELECT * FROM customers
INNER JOIN orders ON id = customer_id;
GO

-- TASK 1.3: Get all customers and orders (Specific Columns)
-- Best practice: Prefixing column names with table names to avoid ambiguity.
SELECT
    customers.id,
    customers.first_name,
    orders.order_id,
    orders.sales
FROM customers
INNER JOIN orders ON customers.id = orders.customer_id;
GO

-- TASK 1.4: Get all customers and orders using ALIASES (AS)
-- TIP: Using 'c' and 'o' makes your code much shorter and faster to write.
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers AS c
INNER JOIN orders AS o ON c.id = o.customer_id;
GO


--------------------------------------------------------------------------------
-- SECTION 2: OUTER JOINS (Handling Missing Data)
--------------------------------------------------------------------------------

-- TASK 2.1: Get all customers along with their orders, including those WITHOUT orders
-- A LEFT JOIN ensures no customer is left behind, even if they haven't bought anything.
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers AS c
LEFT JOIN orders AS o ON c.id = o.customer_id;
GO

-- TASK 2.2: Get all customers and orders, including orders without matching customers (RIGHT JOIN)
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers AS c
RIGHT JOIN orders AS o ON c.id = o.customer_id;
GO

-- TASK 2.3: Get all customers and orders, including orders without matching customers (using LEFT JOIN)
-- PRO-TIP: You can achieve a "Right Join" result by simply swapping the table order in a Left Join.
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM orders AS o
LEFT JOIN customers AS c ON c.id = o.customer_id;
GO

-- TASK 2.4: Get all customers along with their orders, even if there's no match (FULL JOIN)
-- This combines the results of both Left and Right joins.
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers AS c
FULL JOIN orders AS o ON c.id = o.customer_id;
GO



--------------------------------------------------------------------------------
-- SECTION 3: FILTERING FOR NULLS (Gap Analysis)
--------------------------------------------------------------------------------

-- TASK 3.1: Get all customers who have NOT placed any orders
-- Filters for rows where the 'Right' side of the join is empty.
SELECT *
FROM customers AS c
LEFT JOIN orders AS o ON c.id = o.customer_id
WHERE o.customer_id IS NULL; 
GO

-- TASK 3.2: Get all orders without matching customers
SELECT * FROM customers AS c
RIGHT JOIN orders AS o ON c.id = o.customer_id
WHERE c.id IS NULL;
GO

-- TASK 3.3: Find customers without orders AND orders without customers
SELECT *
FROM customers AS c
FULL JOIN orders AS o ON c.id = o.customer_id
WHERE c.id IS NULL OR o.customer_id IS NULL;
GO

-- TASK 3.4: Get customers who placed orders (Simulating INNER JOIN using LEFT JOIN)
SELECT *
FROM customers AS c
LEFT JOIN orders AS o ON c.id = o.customer_id
WHERE o.customer_id IS NOT NULL;
GO


--------------------------------------------------------------------------------
-- SECTION 4: CROSS JOINS & MULTI-TABLE COMPLEXITY
--------------------------------------------------------------------------------

-- TASK 4.1: Generate all possible combinations of customers and orders (CROSS JOIN)
-- Warning: This results in (Total Customers x Total Orders) number of rows.
SELECT * FROM customers
CROSS JOIN orders;
GO

-- TASK 4.2: Real-World Multi-Table Join (SalesDB)
/* Retrieve a list of all orders, along with the related customer, product and employee details. 
   Display: Order ID, Customer name, Product name, Sales, Price, and Sales person name. */
USE SalesDB;
GO

SELECT 
    o.OrderID, 
    c.FirstName AS CustomerFirstName, 
    c.LastName AS CustomerLastName, 
    p.Product, 
    o.sales, 
    p.price, 
    e.FirstName AS EmployeeFirstName, 
    e.LastName AS EmployeeLastName
FROM Sales.Orders AS o
LEFT JOIN Sales.Customers AS c ON o.CustomerID = c.CustomerID 
LEFT JOIN Sales.Products AS p ON o.productID = p.productID
LEFT JOIN Sales.Employees AS e ON o.SalesPersonID = e.EmployeeID;
GO