/*
  Lesson 04 - GROUP FUNCTIONS AND SET OPERATORS
  Student:João Victor Franco da Costa   
  Date:26/10/2026 noite 20:16
*/

USE ULHT_DB26

--A1. Overall commission coverage
--Return the employee row count, populated commission count, and average populated commission. 
--Explain why the two counts differ. Verify by listing employees whose commission is NULL.

SELECT 
    COUNT(*) AS employee_row_count, 
    COUNT(NULLIF(COMMISSION_PCT, 0)) AS populated_commission_count, 
    AVG(NULLIF(COMMISSION_PCT, 0)) AS average_populated_commission
FROM HR.EMPLOYEES;

SELECT
    COUNT(*) as employee_row_count,
    COUNT(COMMISSION_PCT) as populated_commission_count,
    AVG(COMMISSION_PCT) as average_populated_commission
FROM HR.EMPLOYEES;

--A2. Salary totals by job
--For jobs beginning with IT or FI, report job code, employee count, total salary, and average salary.
-- Return one row per job, ordered by job code. Verify one group with a detail query.

SELECT
    JOB_ID,
    COUNT(JOB_ID) as employee_count,
    AVG(SALARY) as average_salary,
    SUM(SALARY) as total_salary
FROM HR.EMPLOYEES
WHERE JOB_ID LIKE 'IT%' OR JOB_ID LIKE 'FI%'
GROUP BY JOB_ID
ORDER BY JOB_ID


--A3. Hire cohorts
--Use CASE to label hires before 2005 as Earlier and all others as 2005 or later.
-- Report the count and minimum salary for each cohort. Repeat the complete CASE expression in GROUP BY.

SELECT
    COUNT(*) as employee_count,
    MIN(SALARY) as minimum_salary,
    CASE 
        WHEN HIRE_DATE < '2005-01-01' THEN 'Earlier'
        ELSE '2005 or later'
    end as hired_label
FROM HR.EMPLOYEES
GROUP BY 
    CASE 
        WHEN HIRE_DATE < '2005-01-01' THEN 'Earlier'
        ELSE '2005 or later'
    end

--A4. Distinct manager measures
--In one row, show the number of non-null manager assignments and the number of different managers.
-- State which expression needs aggregate DISTINCT.

SELECT
    COUNT(DISTINCT MANAGER_ID) AS different_managers,
    COUNT(MANAGER_ID) AS non_null
FROM HR.EMPLOYEES
