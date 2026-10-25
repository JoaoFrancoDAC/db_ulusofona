/*
  Lesson 03 - Filters, Patterns and Conditional Expressions
  Student:João Victor Franco da Costa   
  Date:19/10/2026 noite 7:30 - 9:30
*/

USE ULHT_DB26

-- A1. Historical high earners
SELECT TOP 5
EMPLOYEE_ID,
FIRST_NAME,
LAST_NAME,
HIRE_DATE,
SALARY
FROM HR.EMPLOYEES
WHERE SALARY > 11000 AND HIRE_DATE < '2005-01-01'
ORDER BY HIRE_DATE DESC;

-- A2. Two departments, one exclusion
SELECT 
EMPLOYEE_ID,
DEPARTMENT_ID, 
JOB_ID
FROM HR.EMPLOYEES
WHERE (DEPARTMENT_ID = 20 OR DEPARTMENT_ID = 90)
  AND JOB_ID <> 'AD_VP';

-- A3. Middle employee identifiers
SELECT
EMPLOYEE_ID,
LAST_NAME
FROM HR.EMPLOYEES
WHERE 130<= EMPLOYEE_ID AND EMPLOYEE_ID <= 145 AND EMPLOYEE_ID NOT IN (141, 138, 135);

--A4 Commission without sales management
SELECT
EMPLOYEE_ID,
JOB_ID,
COMMISSION_PCT
FROM HR.EMPLOYEES
WHERE JOB_ID <> 'SA_MAN' AND COMMISSION_PCT > 0;

-- B1. Ending pattern
SELECT EMPLOYEE_ID, LAST_NAME
FROM HR.EMPLOYEES
WHERE LAST_NAME LIKE '%son';

-- B2. Exact character positions
SELECT EMPLOYEE_ID, JOB_ID
FROM HR.EMPLOYEES
WHERE JOB_ID LIKE 'ST_C%';

-- B3. Initial outside a range
SELECT 
    EMPLOYEE_ID,
    UPPER(SUBSTRING(LAST_NAME, 1, 1)) + LOWER(SUBSTRING(LAST_NAME, 2, LEN(LAST_NAME)))
FROM HR.EMPLOYEES
WHERE SUBSTRING(LAST_NAME, 1, 1) NOT BETWEEN 'A' AND 'M' AND LAST_NAME IS NOT NULL;

--B4. Missing organisational assignment
SELECT
EMPLOYEE_ID,
DEPARTMENT_ID,
MANAGER_ID,
CASE 
  WHEN MANAGER_ID IS NULL THEN 'No Manager'
  ELSE 'Reports to Manager'
  END AS MANAGER_STATUS
FROM HR.EMPLOYEES;

--C1. Four salary levels
SELECT
EMPLOYEE_ID,
SALARY,
CASE WHEN SALARY < 3000 THEN 'Entry'
      WHEN 3000<= SALARY AND SALARY < 6000 THEN 'Developing'
      WHEN 6000<= SALARY AND SALARY < 10000 THEN 'Estabilished'
      WHEN 10000<= SALARY THEN 'High'
      END AS salary_level
FROM HR.EMPLOYEES;

--C2. Filter the salary levels
SELECT
EMPLOYEE_ID,
DEPARTMENT_ID,
SALARY,
CASE WHEN SALARY < 3000 THEN 'Entry'
      WHEN 3000<= SALARY AND SALARY < 6000 THEN 'Developing'
      WHEN 6000<= SALARY AND SALARY < 10000 THEN 'Estabilished'
      WHEN 10000<= SALARY THEN 'High'
      END AS salary_level
FROM HR.EMPLOYEES WHERE DEPARTMENT_ID IN (50, 80); 

-- C3. Explain first-match behaviour
-- First true branch: A conditional expression returns the result of its first true branch.
-- Branch order: A broad lower band placed first would capture higher salaries incorrectly.


--C4. Region labels from department numbers
SELECT
EMPLOYEE_ID,
DEPARTMENT_ID,
CASE WHEN DEPARTMENT_ID IN (10, 20, 30) THEN 'Group A'
      WHEN DEPARTMENT_ID IN (40, 50, 60) THEN 'Group B'
      ELSE 'Other'
      END AS department_cluster
FROM HR.EMPLOYEES;

--C5. Commission display
SELECT
EMPLOYEE_ID,
COMMISSION_PCT,
CASE WHEN COMMISSION_PCT IS NULL OR COMMISSION_PCT = 0 THEN 'Missing'
      ELSE 'Recorded'
      END AS commission_status
FROM HR.EMPLOYEES;

-- D1. Contact audit
SELECT
    EMPLOYEE_ID,
    PHONE_NUMBER,
    CASE 
        WHEN PHONE_NUMBER IS NULL THEN 'Missing'
        WHEN PHONE_NUMBER NOT LIKE '[1-6]%' THEN 'Outside expected prefix'
    END AS phone_issue
FROM HR.EMPLOYEES;

-- D2. Focus the contact audit
SELECT
    EMPLOYEE_ID,
    HIRE_DATE,
    PHONE_NUMBER,
    CASE 
        WHEN PHONE_NUMBER IS NULL THEN 'Missing'
        WHEN PHONE_NUMBER NOT LIKE '[1-6]%' THEN 'Outside expected prefix'
    END AS phone_issue
FROM HR.EMPLOYEES WHERE HIRE_DATE BETWEEN '2004-01-01' AND '2007-12-31';

--D3. Email-style candidate audit (NÃO ENTENDI NADA)
SELECT 
    EMPLOYEE_ID,
    LAST_NAME,
    LOWER(SUBSTRING(FIRST_NAME, 1, 1) + '.' + LAST_NAME) AS email_candidate,
    CASE 
        -- Lógica para identificar qual caractere aparece primeiro
        WHEN CHARINDEX('''', LOWER(SUBSTRING(FIRST_NAME, 1, 1) + '.' + LAST_NAME)) > 0 
         AND (CHARINDEX('-', LOWER(SUBSTRING(FIRST_NAME, 1, 1) + '.' + LAST_NAME)) = 0 
              OR CHARINDEX('''', LOWER(SUBSTRING(FIRST_NAME, 1, 1) + '.' + LAST_NAME)) < CHARINDEX('-', LOWER(SUBSTRING(FIRST_NAME, 1, 1) + '.' + LAST_NAME))) 
        THEN 'Apostrophe' -- ou o rótulo correspondente ao caractere
        ELSE 'Hyphen'
    END AS special_character
FROM HR.EMPLOYEES
WHERE LOWER(SUBSTRING(FIRST_NAME, 1, 1) + '.' + LAST_NAME) LIKE '%[%-]%';

-- D4. Explain portability
-- B3 pattern: A sintaxe de colchetes do LIKE no SQL Server faz correspondência de 
--padrões (pattern matching), e não uma expressão regular completa (regex).  

-- C5 portability: A função IIF do T-SQL não é suportada por todos os SGBDs (DBMS).

-- Portable choice: O CASE padrão é a alternativa preferida e mais portável.