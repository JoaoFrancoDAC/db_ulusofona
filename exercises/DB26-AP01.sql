/*
  Lesson 01 - Metadata,Read, add, and remove rows
  Student:
  Date:
*/

USE ULHT_DB26;
GO

-- list databases in the current SQL Server instance
/*
SELECT
    name,
    database_id,
    state_desc,
    recovery_model_desc
FROM sys.databases
ORDER BY name;

SELECT
    CATALOG_NAME,
    SCHEMA_NAME,
    SCHEMA_OWNER
FROM INFORMATION_SCHEMA.SCHEMATA
ORDER BY SCHEMA_NAME;
*/

--SELECT EMPNO, ENAME, JOB, SAL
--FROM Scott.EMP;

/*SELECT* 
    
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Scott'
  AND TABLE_NAME = 'EMP'
ORDER BY ORDINAL_POSITION;
*/



