/*
  Lesson 04 - GROUP FUNCTIONS AND SET OPERATORS
  Student:João Victor Franco da Costa   
  Date:19/10/2026 noite 7:30 - 9:30
*/

USE ULHT_DB26

SELECT
    DEPARTMENT_ID,
    MIN(SALARY) AS minimum_salary,
    MAX(SALARY) AS maximum_salary,
    MAX(SALARY) - MIN(SALARY) AS salary_range
FROM HR.EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL
GROUP BY DEPARTMENT_ID
ORDER BY salary_range desc;

-- A2. Commission categories
SELECT 
    COMMISSION_PCT
FROM HR.EMPLOYEES

SELECT 
    CASE 
        WHEN COMMISSION_PCT IS NULL OR COMMISSION_PCT = 0 THEN 'No commission'
        ELSE 'Commission'
    END AS commission_category,
    COUNT(EMPLOYEE_ID) AS employee_count,
    AVG(SALARY) AS average_salary
FROM HR.EMPLOYEES
GROUP BY 
    CASE 
        WHEN COMMISSION_PCT IS NULL OR COMMISSION_PCT = 0 THEN 'No commission'
        ELSE 'Commission'
    END;

--A3 Surname initials
SELECT
    SUBSTRING(LAST_NAME, 1, 1) AS last_name_initial,
    COUNT(EMPLOYEE_ID) AS employee_count
FROM HR.EMPLOYEES
GROUP BY SUBSTRING(LAST_NAME, 1, 1)
HAVING COUNT(EMPLOYEE_ID) > 4
ORDER BY employee_count DESC;

--A4 Hiring-year threshold
SELECT 
YEAR(HIRE_DATE) AS hire_year,
COUNT(EMPLOYEE_ID) AS employee_count
FROM HR.EMPLOYEES
GROUP BY YEAR(HIRE_DATE)
HAVING COUNT(EMPLOYEE_ID) >= 10
ORDER BY hire_year asc;

--A5. Department commission diversity
SELECT
DEPARTMENT_ID,
COUNT(DISTINCT(COMMISSION_PCT)) as different_commission_rates
FROM HR.EMPLOYEES
WHERE COMMISSION_PCT > 0 
GROUP BY DEPARTMENT_ID
HAVING COUNT(DISTINCT(COMMISSION_PCT))>1;

--A6
SELECT 
MANAGER_ID,
COUNT(MANAGER_ID) as direct_reports,
MAX(salary) as maximum_salary
FROM HR.EMPLOYEES
GROUP BY MANAGER_ID
HAVING COUNT(MANAGER_ID) >= 3 AND MAX(SALARY)>9000;

--A7
SELECT
JOB_ID
FROM HR.EMPLOYEES
WHERE DEPARTMENT_ID = 50

INTERSECT

SELECT 
JOB_ID
FROM HR.EMPLOYEES
WHERE DEPARTMENT_ID = 80

--A8 Salary-band difference
--Return job codes represented among employees earning from 5000 through 9999, 
--excluding every job code also represented among employees earning 10000 or more.

SELECT JOB_ID
FROM HR.EMPLOYEES
WHERE SALARY >= 5000 AND SALARY <= 9999

except 

SELECT JOB_ID
FROM HR.EMPLOYEES
WHERE SALary > 10000

USE BikeStores

--B1 Product catalogue by model year
SELECT 
    model_year,
    COUNT(product_id) as product_count,
    MIN(list_price) as minimum_price,
    MAX(list_price) as maximum_price

FROM PRODUCTION.products
GROUP BY model_year
ORDER BY model_year asc;

--B2 
SELECT 
    category_id,
    COUNT(product_id) as product_count,
    AVG(list_price) as average_price
FROM PRODUCTION.products
GROUP BY category_id
HAVING AVG(list_price) > 1500
ORDER BY average_price desc

--B3
SELECT 
    product_name,
    COUNT(product_id) as occurrence_count
FROM PRODUCTION.products
GROUP BY product_name
HAVING COUNT(product_id) > 1
ORDER BY occurrence_count desc;

--B4
SELECT * 
FROM PRODUCTION.products

SELECT
    brand_id,
    model_year,
    COUNT(product_id) as product_count
FROM PRODUCTION.PRODUCTS
WHERE model_year BETWEEN 2017 AND 2018
GROUP BY brand_id, model_year 
HAVING COUNT(product_id) >=5
ORDER BY brand_id asc

--B5
select 
category_id,
count(distinct list_price)
from production.products
group by category_id
having count(distinct list_price) > 20

SELECT -- PREÇOS IGUAIS
    category_id,
    list_price,
    COUNT(product_id) AS quantidade_produtos_com_este_preco
FROM production.products
GROUP BY category_id, list_price
HAVING COUNT(product_id) > 1;

--B6
SELECT 
--product_id,
category_id
FROM production.products
WHERE model_year = 2016

union 

SELECT 
--product_id,
category_id
FROM production.products
WHERE model_year = 2018;

SELECT category_id
FROM production.products
WHERE model_year = 2016

UNION ALL

SELECT category_id
FROM production.products
WHERE model_year = 2018;

-- B7

SELECT
CATEGORY_ID
FROM production.products
where model_year = 2017

EXCEPT

SELECT
CATEGORY_ID
FROM PRODUCTION.products
WHERE MODEL_YEAR = 2016




