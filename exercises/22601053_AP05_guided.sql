/*
  Lesson 05 - DDL BASE
  Student:João Victor Franco da Costa   
  Date:06/10/2026 noite 7:30 - 9:30
*/

USE ULHT_DB26;

DROP TABLE IF EXISTS HR.learning_project;

--A1
CREATE TABLE HR.learning_project(
    project_id int not NULL,
    title NVARCHAR(80) not NULL,
    budget DECIMAL(10,2) not NULL,
    due_date DATE NULL
);

--A2
ALTER TABLE HR.learning_project ADD
    status_code VARCHAR(12)

ALTER TABLE HR.learning_project ALTER COLUMN status_code VARCHAR(20)

SELECT 
    TABLE_NAME,
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'HR' AND TABLE_NAME = 'learning_project'
  
--A3
GO
CREATE VIEW HR.vw_department_headcount AS
    SELECT 
        DEPARTMENT_ID,
        COUNT(EMPLOYEE_ID) AS total_funcionarios
    FROM HR.EMPLOYEES
    GROUP BY DEPARTMENT_ID;
GO

SELECT
    DEPARTMENT_ID,
    total_funcionarios
FROM HR.vw_department_headcount
WHERE total_funcionarios >= 3

SELECT 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    VIEW_DEFINITION 
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'HR' 

-- e para rodar esta query agora basta rodar o que ficou salvo nos schemas.views
-- posso até apagar este bloco de texto acima e usar:
SELECT * FROM HR.vw_department_headcount
WHERE total_funcionarios >= 3;
GO

--A4 

CREATE NONCLUSTERED INDEX IX_learning_project_due_date 
ON HR.learning_project (due_date);

SELECT name, type_desc, is_disabled 
FROM sys.indexes 
WHERE object_id = OBJECT_ID('HR.learning_project') 
  AND name = 'IX_learning_project_due_date';

ALTER INDEX IX_learning_project_due_date ON HR.learning_project DISABLE;

SELECT name, type_desc, is_disabled 
FROM sys.indexes 
WHERE object_id = OBJECT_ID('HR.learning_project') 
  AND name = 'IX_learning_project_due_date';

ALTER INDEX IX_learning_project_due_date ON HR.learning_project REBUILD;

SELECT name, type_desc, is_disabled 
FROM sys.indexes 
WHERE object_id = OBJECT_ID('HR.learning_project') 
  AND name = 'IX_learning_project_due_date';

-- 
SELECT 
    OBJECT_NAME(object_id),
    name
FROM SYS.columns

SELECT 
    OBJECT_NAME(object_id) AS nome_da_tabela,
    name AS nome_da_coluna
FROM sys.columns
ORDER BY nome_da_tabela, nome_da_coluna;

SELECT 
    t.name AS nome_da_tabela,
    c.name AS nome_da_coluna
FROM sys.columns AS c
INNER JOIN sys.tables AS t 
    ON c.object_id = t.object_id
ORDER BY t.name, c.name;

SELECT 
    employee_id, 
    last_name, 
    commission_pct
INTO HR.commission_employee_copy
FROM HR.employees
WHERE commission_pct != 0;

SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'HR' 
  AND TABLE_NAME = 'commission_employee_copy';

SELECT COUNT(*) AS contagem_origem 
FROM HR.employees 
WHERE commission_pct != 0;

SELECT COUNT(*) AS contagem_destino 
FROM HR.commission_employee_copy;

CREATE TABLE HR.high_salary_copy (
    employee_id int not null,
    full_name VARCHAR not null,
    salary DECIMAL(10,2)
) 

ALTER TABLE HR.high_salary_copy ALTER COLUMN full_name VARCHAR(100)

select *
from hr.high_salary_copy

INSERT INTO HR.high_salary_copy (EMPLOYEE_ID, full_name, salary)
    SELECT
    EMPLOYEE_ID,
    first_name + ' ' + last_name AS full_name,
    salary
    from HR.EMPLOYEES
    WHERE SALARY>12000

SELECT COUNT(*) AS total_linhas 
FROM HR.high_salary_copy;

DROP TABLE HR.learning_project;
DROP VIEW HR.vw_department_headcount;
DROP TABLE HR.commission_employee_copy;
DROP TABLE HR.high_salary_copy;