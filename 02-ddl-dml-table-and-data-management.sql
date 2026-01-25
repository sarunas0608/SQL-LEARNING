/* ================================================================================
LESSON 02: DDL & DML OPERATIONS
Topic: Data Definition (Structure) and Data Manipulation (Content)
Target Tables: persons, customers, personas
================================================================================
*/

--------------------------------------------------------------------------------
-- SECTION 1: DATA DEFINITION LANGUAGE (DDL) - Table Structure
--------------------------------------------------------------------------------

-- TASK 1.1: Create a new table called persons
/* KEY TO REMEMBER: Primary Key Placement
   - In-line (id INT PRIMARY KEY): Best for quick scripts and single columns.
   - Table-level (Bottom of code): BEST PRACTICE for professional work. 
     It allows you to NAME the constraint (pk_persons) and is REQUIRED for 
     Composite Keys (keys using 2+ columns).
*/
CREATE TABLE persons (
    id INT NOT NULL,
    person_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    phone VARCHAR(15) NOT NULL,
    CONSTRAINT pk_persons PRIMARY KEY(id) -- Table-level (Recommended)
);
GO

-- TASK 1.2: Add a new column called email
-- TIP: When adding NOT NULL columns to an existing table with data, 
-- you usually need to provide a DEFAULT value.
ALTER TABLE persons
ADD email VARCHAR(50) NOT NULL;
GO

-- TASK 1.3: Remove the column phone
-- NOTE: Dropping a column is permanent. Always backup data if it's important!
ALTER TABLE persons
DROP COLUMN phone;
GO

-- TASK 1.4: Delete the table persons
-- BEST PRACTICE: Use 'DROP TABLE IF EXISTS' to prevent errors in scripts.
-- DROP TABLE persons; 
GO


--------------------------------------------------------------------------------
-- SECTION 2: DATA MANIPULATION LANGUAGE (DML) - Inserting Data
--------------------------------------------------------------------------------

-- TASK 2.1: Insert new customer records
-- TIP: Always list the columns (id, name, etc.) explicitly. 
-- It prevents errors if the table structure changes later.
INSERT INTO customers (id, first_name, country, score)
VALUES 
    (6, 'Jonas', 'Lithuania', NULL),
    (7, 'Anna', NULL, 100);
GO

-- TASK 2.2: Copy data from 'customers' into 'personas'
-- PRO-TIP: This is called 'INSERT INTO...SELECT'. 
-- Match the data types in the same order as the target table.
INSERT INTO personas (id, person_name, birth_date, phone)
SELECT 
    id,
    first_name,
    NULL, 
    'Unknown'
FROM customers;
GO


--------------------------------------------------------------------------------
-- SECTION 3: DATA MANIPULATION LANGUAGE (DML) - Updating Data
--------------------------------------------------------------------------------

-- TASK 3.1: Change the score of customer with ID 6 to 0
-- BEST PRACTICE: Run a SELECT first with the same WHERE clause 
-- to make sure you are targeting the right person!
UPDATE customers
SET score = 0
WHERE id = 6;
GO

-- TASK 3.2: Update multiple columns for customer ID 7
UPDATE customers
SET country = 'UK',
    score = 0
WHERE id = 7;
GO

-- TASK 3.3: Update all customers with a NULL score
-- KEY TO REMEMBER: You cannot use '= NULL'. You must use 'IS NULL'.
UPDATE customers
SET score = 0
WHERE score IS NULL;
GO


--------------------------------------------------------------------------------
-- SECTION 4: DATA MANIPULATION LANGUAGE (DML) - Deleting Data
--------------------------------------------------------------------------------

-- TASK 4.1: Delete customers with an ID greater than 5
-- WARNING: Always use a WHERE clause. Forgetting it will delete EVERYONE.
DELETE FROM customers
WHERE id > 5;
GO

-- TASK 4.2: Delete all data vs. Truncate table
/* TRUNCATE vs DELETE:
   - DELETE: Slower, logs every row, keeps the ID counter (Identity) as is.
   - TRUNCATE: Much faster, resets the ID counter back to 1.
*/
DELETE FROM personas;
-- TRUNCATE TABLE personas;
GO