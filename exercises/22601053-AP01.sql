/*
  Lesson 01 - Metadata,Read, add, and remove rows
  Student:João Victor Franco da Costa   
  Date:15/09/2026 noite 7:30 - 9:30
*/

USE ULHT_DB26;
GO

--A1. Inspect the current database
--Return the current database name in a column called
SELECT DB_NAME() AS database_name; 

--A2. Explore the schema
--List all tables in the HR schema.
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'HR';
    
--A3. Explore a relation
--Return 1 employee named 'SMITH'.
SELECT TOP 1 * FROM HR.EMPLOYEES
WHERE LAST_NAME = 'SMITH';

--Return employee number, first name, and last name for 1 employee with your name. ( Joao Victor Franco da Costa )
SELECT top(1)
    FIRST_NAME,
    LAST_NAME,
    EMPLOYEE_ID
FROM HR.EMPLOYEES
WHERE LAST_NAME = 'Costa'AND FIRST_NAME = 'Joao'; 

--A4. Filter rows
--Return employee number, first name, last name, salary and department for employees with salary over 10,000 that are not in department 80.
Select 
    EMPLOYEE_ID,
    FIRST_NAME,
    LAST_NAME,
    SALARY,
    DEPARTMENT_ID
FROM HR.EMPLOYEES
WHERE SALARY > 10000 AND DEPARTMENT_ID<>80;

--A5. Work with missing values
--Find out who's the boss (list only first and last name).
SELECT *
FROM HR.JOBS; -- I've used this query to find out all the possible names that the column JOB_ID could have

SELECT
FIRST_NAME,
LAST_NAME
FROM HR.EMPLOYEES
WHERE JOB_ID = 'AD_PRES';

--A6. Related data
--Find IT department number
SELECT 
DEPARTMENT_ID,
DEPARTMENT_NAME,
MANAGER_ID,
LOCATION_ID
FROM HR.DEPARTMENTS WHERE DEPARTMENT_NAME = 'IT';

--List all employees in that department.
SELECT *
FROM HR.EMPLOYEES WHERE DEPARTMENT_ID = 60;

--Part B - Add and verify
--B1. Check the identifier
--Use the last 3 numbers of your student number to check if the employee number is already present. If that employee number is already present, use the 4th digit of your student number instead. Repeat as necessary until you find an unused employee number.
SELECT *
FROM HR.EMPLOYEES WHERE EMPLOYEE_ID = 053;

--B2. Verify nullable columns
--Use INFORMATION_SCHEMA to check nullable columns in the HR.EMPLOYEES table.
SELECT 
COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'HR' AND TABLE_NAME = 'EMPLOYEES' AND IS_NULLABLE = 'NO';

--B3. Insert a row
--Use an INSERT statement with an explicit column list to add you as an employee. You must ensure that the following data is provided correctly: employee number, first name, last name, hire date is set insertion time, salary and the department is set to IT.

-- This "if not exists" code i honestly searched on the internet before running the program again. 
-- I was afraid of running it twice for the following exercises mainly because i was not 100% sure if it would add a dupe or if the employee_id column already has some kind
-- of prevention against trying to add duplicates on it's background, if it would automatically filter my insertion attempt or not.
IF NOT EXISTS (SELECT 1 FROM HR.EMPLOYEES WHERE EMPLOYEE_ID = 053)
BEGIN
 INSERT INTO HR.EMPLOYEES (
    EMPLOYEE_ID, 
    FIRST_NAME, 
    LAST_NAME, 
    PHONE_NUMBER, 
    HIRE_DATE, 
    JOB_ID, 
    SALARY, 
    DEPARTMENT_ID
) VALUES (
  053,
  'João',
  'Costa',
  '931938655',
  GETDATE(),
  'IT_PROG',
  10000,
  60
);
END;

--B3. Verify
--Return the inserted row by its key. Confirm all required data is correct. 

-- AND

----Part C - Remove and verify
--Run the five-rule check before delete
SELECT * 
FROM HR.EMPLOYEES 
WHERE EMPLOYEE_ID = 053;

--C2. Delete
--Turn the verified predicate into a targeted DELETE.
DELETE FROM HR.EMPLOYEES 
WHERE EMPLOYEE_ID = 053;

--C3. Verify
--Run the preview query again. It must return zero rows.
SELECT * 
FROM HR.EMPLOYEES 
WHERE EMPLOYEE_ID = 053;