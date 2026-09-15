/*
  Lesson 01 - Metadata,Read, add, and remove rows
  Student:João Victor Franco da Costa   
  Date:15/09/2026 noite 7:30 - 9:30
*/

USE ULHT_DB26;
GO



SELECT DB_NAME() AS database_name; 

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'HR';
    
SELECT 
    FIRST_NAME,
    LAST_NAME,
    EMPLOYEE_ID
FROM HR.EMPLOYEES
WHERE LAST_NAME = 'SMITH';

