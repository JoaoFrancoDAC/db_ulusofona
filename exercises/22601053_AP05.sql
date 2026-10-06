/*
  Lesson 05 - DDL BASE
  Student:João Victor Franco da Costa   
  Date:06/10/2026 noite 7:30 - 9:30
*/

USE BikeStore;
GO

/*
IF OBJECT_ID('HR.employee_training_2', 'U') IS NULL
    CREATE TABLE employee_training_2  (
    employee_id INT NOT NULL,
    course_code VARCHAR(12) NOT NULL,
    completed_on DATE NULL,
    score DECIMAL(5, 2) NULL
);

-- Verify TABLE 'employee_training' was created.
SELECT * FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'employee_training_2';
-- Verify all columns were created on TABLE 'employee_training'.
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'HR' AND TABLE_NAME = 'employee_training';

IF OBJECT_ID('HR.department_note', 'U') IS NULL
    CREATE TABLE HR.department_note (
        department_id INT NOT NULL,
        note_text NVARCHAR(200) NULL
    )
    ELSE
    SELECT 'Já existe';

SELECT * FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'HR' AND TABLE_NAME = 'department_note';
-- Verify all columns were created on TABLE 'department_note'.
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'HR' AND TABLE_NAME = 'department_note';



IF OBJECT_ID('HR.learning_project', 'U') IS NULL
CREATE TABLE HR.learning_project (
    project_id INT NOT NULL,
    title NVARCHAR(80) NOT NULL,
    budget DECIMAL(12, 2) NULL,
    due_date DATE NULL
) ELSE PRINT 'Já existe';
*/

select * from INFORMATION_SCHEMA.TABLES;

select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_SCHEMA = 'production';

--A1
IF OBJECT_ID('production.review_queue', 'U') IS NULL
    CREATE TABLE production.review_queue (
        product_id INT NOT NULL,
        unicode_review NVARCHAR(200) NULL,
        score DECIMAL(10, 2) NULL,
        review_date date NULL
    ) ELSE PRINT 'Já existe';