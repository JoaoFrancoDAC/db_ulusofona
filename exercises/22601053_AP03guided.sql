/*
  Lesson 03 - Filters, Patterns and Conditional Expressions
  Student:João Victor Franco da Costa   
  Date:25/10/2026 noite 23:06
*/

--Guided HR exercises for filters, patterns, CASE, and IIF.

--Work in exercises/<StudentNumber>_AP03.sql. Use the HR schema in ULHT_DB26; do not use BikeStores.
--Label every exercise with a SQL comment. 
--These exercises are read-only, so verification means retaining or separately selecting the source columns.

--Part A - WHERE and logic
--A1. Later hires
--Predict whether 1 January 2007 is included. Return the identifier, last name, and hire date for employees hired on or after that date, earliest first.

SELECT 
    EMPLOYEE_ID,
    LAST_NAME,
    HIRE_DATE
FROM HR.EMPLOYEES
WHERE HIRE_DATE >= '2007-01-01'
ORDER BY HIRE_DATE ASC

--A2. One department with a salary ceiling
--Return employees in department 60 whose salary is below 7000. Show both tested columns.

SELECT
    EMPLOYEE_ID,
    DEPARTMENT_ID,
    SALARY
FROM HR.EMPLOYEES
WHERE DEPARTMENT_id = 60 AND SALARY < 7000;

--A3. Group alternatives safely
--Return employees in department 30 or 100 who earn at least 7000. Use parentheses to communicate the intended grouping.

SELECT  
    EMPLOYEE_ID,
    DEPARTMENT_ID,
    SALARY
FROM HR.EMPLOYEES
WHERE (DEPARTMENT_ID = 30 OR DEPARTMENT_ID = 100) AND SALARY >=7000;

--Part B - Special predicates
--B1. Exclude a pay interval
--Return identifiers and salaries outside the inclusive 5000-to-10000 interval. Sort by salary.

SELECT
    EMPLOYEE_ID,
    SALARY

FROM HR.EMPLOYEES
WHERE SALARY NOT BETWEEN 5000 AND 10000
ORDER BY SALARY;

--B2. Select three jobs
--Return identifiers and job IDs for IT_PROG, FI_ACCOUNT, or PU_CLERK without repeating the column comparison three times.

SELECT
    EMPLOYEE_ID,
    JOB_ID
FROM HR.EMPLOYEES
WHERE JOB_ID IN ('IT_PROG', 'FI_ACCOUNT', 'PU_CLERK');

--B3. Find a surname shape
--Find last names whose second character is a. Return the identifier and original last name.

SELECT
    EMPLOYEE_ID,
    LAST_NAME
FROM HR.EMPLOYEES
WHERE LAST_NAME LIKE '_a%';

--B4. Find assigned departments
--Return identifiers and department IDs only for employees with an assigned department and a missing commission rate.

SELECT 
    EMPLOYEE_ID,
    DEPARTMENT_ID
FROM HR.EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL AND COMMISSION_PCT IS NULL; 

--Part C - Patterns and conditionals
--C1. Inspect a permitted initial range
--Return last names beginning with a letter from A through D. Explain in a comment why collation may affect character matching.
SELECT 
    LAST_NAME
FROM HR.EMPLOYEES
WHERE LAST_NAME LIKE '[A-D]%';

--C2. Classify tenure eras
--Use a searched conditional expression to label hires before 2003 as Early, hires before 2006 as Middle, and all later hires as Recent. Display the hire date.

SELECT
    EMPLOYEE_ID,
    CASE 
        WHEN YEAR(HIRE_DATE) < 2003 THEN 'Early'
        WHEN YEAR(HIRE_DATE) < 2006 THEN 'Middle'
        ELSE 'Recent'
    END AS hire_label,
    HIRE_DATE
FROM HR.EMPLOYEES;

--C3. Name selected departments
--Use a simple conditional expression to label department 50 as Shipping, 80 as Sales, and every other or missing department as Other.

SELECT
    EMPLOYEE_ID,
    DEPARTMENT_ID,
    CASE DEPARTMENT_ID
        WHEN 50 THEN 'Shipping'
        WHEN 80 THEN 'Sales'
        ELSE 'Other'
    end as department_labeL
FROM HR.EMPLOYEES

--C4. Make a two-result contact label
--Use the SQL Server two-result conditional function to label a row Phone available or No phone from PHONE_NUMBER.

SELECT
    EMPLOYEE_ID,
    IIF(PHONE_NUMBER IS NULL, 'No  phone', 'Phone available') as has_contact,
    PHONE_NUMBER
FROM HR.EMPLOYEES

--C5. Combine the lesson
--Return sales representatives (JOB_ID = 'SA_REP') whose commission is present and at least 0.25. 
--Add a conditional label of Senior band for salary at least 10000 and Core band otherwise. Verify using job, commission, and salary in the result.
--
--COM CASE
SELECT
    EMPLOYEE_ID,
    JOB_ID,
    COMMISSION_PCT,
    SALARY,
    CASE 
        WHEN SALARY >= 10000 THEN 'Senior band'
        ELSE 'Core band'
    end as salary_label

FROM HR.EMPLOYEES
WHERE JOB_ID='SA_REP' AND COMMISSION_PCT>=0.25

--COM IIF
SELECT
    EMPLOYEE_ID,
    JOB_ID,
    COMMISSION_PCT,
    SALARY,
    IIF(SALARY >= 10000, 'Senior band', 'Core band') AS salary_label
FROM HR.EMPLOYEES
WHERE JOB_ID = 'SA_REP' AND COMMISSION_PCT >= 0.25;

