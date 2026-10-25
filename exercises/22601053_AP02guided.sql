/*
  Lesson 02 - Expressions, NULL, conversion, and formatting
  Student:João Victor Franco da Costa   
  Date:25/10/2026 noite 22:22
*/

--Work in exercises/<StudentNumber>_AP02.sql. Use the HR schema in the ULHT_DB26 database; do not use BikeStores. Label every exercise with a SQL comment.

--These exercises are read-only. Keep the source columns beside derived columns so that every result can be verified.

--Part A - Inline operations
--A1. Build a display name
--Before running the query, predict the punctuation and case. Return EMPLOYEE_ID and one full_name column in the form LAST_NAME, FIRST_NAME for every employee.

USE ULHT_DB26;

SELECT
    EMPLOYEE_ID,
    CONCAT(LAST_NAME,', ',FIRST_NAME) as full_name
FROM HR.EMPLOYEES;

--A2. Build a login candidate
--Return the identifier and a lowercase login_name made from the first initial, a full stop, and the last name. Try different operators and check the results.

SELECT
    EMPLOYEE_ID,
    CONCAT(LOWER(SUBSTRING(FIRST_NAME,1,1)),'.',LOWER(LAST_NAME)) as login_name
FROM HR.EMPLOYEES;

-- OU 

SELECT 
    EMPLOYEE_ID,
    LOWER(LEFT(FIRST_NAME, 1)) + '.' + LOWER(LAST_NAME) AS login_name
FROM HR.EMPLOYEES;

--A3. Calculate annual salary
--Return EMPLOYEE_ID, SALARY, and monthly salary multiplied by 12 as annual_salary. Verify that the source and calculated values agree for employee 100.

SELECT 
    EMPLOYEE_ID,
    SALARY,
    (SALARY*12) AS annual_salary
FROM HR.EMPLOYEES
WHERE EMPLOYEE_ID=100;

--A4. Apply a hypothetical raise
--Without changing data, show each salary and a salary_after_raise that is 5% higher. Use parentheses to make the calculation clear.

SELECT
    EMPLOYEE_ID,
    SALARY,
    (SALARY * 1.05) AS salary_after_raise
FROM HR.EMPLOYEES;

--A5. Work with dates
--Return each hire date and its first anniversary. Add one year with a date function rather than assuming a fixed number of days.

SELECT
    EMPLOYEE_ID,
    HIRE_DATE,
    DATEADD(YEAR,1,HIRE_DATE) as first_anniversary
FROM HR.EMPLOYEES;

--Part B - NULL and nullity
--B1. Find absent commissions
--Predict why COMMISSION_PCT = NULL would not work. Return identifiers and commission rates only where the rate is absent.


-- Não vai funcionar pois comission_pct não aceita valor nulo
SELECT
    EMPLOYEE_ID,
    COMMISSION_PCT
FROM HR.EMPLOYEES
WHERE COMMISSION_PCT IS NULL;

--B2. Calculate total pay
--Return salary, commission rate, and total_pay. Treat an absent rate as zero and verify that such an employee's total equals the salary.

SELECT
    EMPLOYEE_ID,
    SALARY,
    COMMISSION_PCT,
    (SALARY*12) + ((SALARY*12)* isnull(COMMISSION_PCT,0)) as total_pay

FROM HR.EMPLOYEES;

--B3. Select the first contact
--Create contact from the first non-null value among phone number, email, and the literal No contact.

SELECT 
    EMPLOYEE_ID,
    COALESCE(PHONE_NUMBER,EMAIL,'No contact') as contact
FROM HR.EMPLOYEES

--Part C - Conversion
--C1. Build a typed employee code
--Return employee_code in the form EMP-100. Explicitly convert the numeric identifier to VARCHAR(10) before joining the components.

SELECT
    EMPLOYEE_ID,
    CONCAT('EMP-', CONVERT(VARCHAR(10),EMPLOYEE_ID)) AS EMPLOYEE_CODE
FROM HR.EMPLOYEES
ORDER BY EMPLOYEE_ID;

--C2. Produce stable date text
--Return hire dates as ten-character yyyy-mm-dd text by using conversion style 23.

SELECT
    EMPLOYEE_ID,
    CONVERT(VARCHAR(10), HIRE_DATE,23) AS hire_date_text
FROM HR.EMPLOYEES;

--C3. Test uncertain text
--Use safe conversion to test the strings 2703 and 27O3 as integers. Predict which result is null and explain why in a SQL comment.

SELECT 
    TRY_CONVERT(INT, '2703') AS teste_com_zero,
    TRY_CONVERT(INT, '27O3') AS teste_com_letra;

--Part D - Formatting
--D1. Format and sort salary
--Return the five highest salaries with EMPLOYEE_ID, numeric SALARY, and an en-GB currency display. Sort by the numeric value, not the display text.

SELECT TOP (5)
    EMPLOYEE_ID,
    SALARY AS numery_SALARY,
    FORMAT(SALARY,'C','en-GB') AS text_salary_gb 
FROM HR.EMPLOYEES
ORDER BY SALARY DESC;

--D2. Pad an identifier
--Display employee identifiers in a six-character field padded with leading zeroes. Verify that employee 100 displays as 000100.

SELECT 
    EMPLOYEE_ID,
    FORMAT(EMPLOYEE_ID, '000000') AS padded_id
FROM HR.EMPLOYEES;
