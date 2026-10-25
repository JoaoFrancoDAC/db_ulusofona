/*
  Lesson 01 - Metadata,Read, add, and remove rows
  Student:João Victor Franco da Costa   
  Date:25/10/2026 noite 20:53
*/

USE ULHT_DB26;

--Part A - Read
--A1. Inspect the current database
--Return the current database name in a column called current_database.

SELECT DB_NAME() AS curret_database;

--A2. Explore a relation
--Return at most five rows from Scott.EMP, initially using *.

SELECT top (5) * 
from Scott.EMP;

--A3. Choose columns
--Return EMPNO, ENAME, JOB, and SAL from Scott.EMP.

SELECT
    EMPNO,
    ENAME,
    JOB,
    SAL
from scott.emp;

--A4. Filter rows
--Return EMPNO, ENAME, and SAL only for employees whose salary is below 1,000.

SELECT 
    EMPNO,
    ENAME,
    SAL
FROM SCOTT.EMP
WHERE SAL < 1000;

--A5. Work with missing values
--Return the employee number, name, and commission only for rows where commission is absent.

SELECT
    EMPNO,
    ENAME,
    COMM
FROM SCOTT.EMP
WHERE COMM IS NULL

--A6. Sort a result set
--Return employee number, name, and salary. Sort from highest to lowest salary, then by employee number. Predict how the second sort item affects tied salaries.

SELECT
    EMPNO,
    ENAME,
    SAL
FROM SCOTT.EMP
ORDER BY SAL DESC, EMPNO; 

--Part B - Add and verify
--B1. Check the identifier
--Use SELECT to prove that the chosen employee number is not already present.

SELECT 
    EMPNO
FROM SCOTT.EMP
WHERE  EMPNO=22601053

--B2. Insert a row
--Insert one employee with:
--EMPNO: <Your student number>;
--ENAME: <Your name>;
--HIREDATE: the current server date and time;
--SAL: <Set your own salary>.
--Use an explicit column list. Permit the remaining optional columns to use their defined value.

INSERT INTO SCOTT.EMP (
    EMPNO,
    ENAME,
    HIREDATE,
    SAL
) VALUES (
    1053,
    'Joao Costa',
    GETDATE(),
    1500
)

--B3. Verify
--Return the inserted row by its key. Confirm the name, date, and salary.

SELECT *
FROM SCOTT.EMP
WHERE EMPNO=1053;

--Part C - Change and verify
--C1. Preview the update

SELECT 
    EMPNO,
    JOB,
    SAL
FROM SCOTT.EMP
WHERE EMPNO=1053;

--C2. Update the job
--Change the inserted employee's job to CLERK. Use a targeted UPDATE statement.
 
UPDATE SCOTT.EMP
    SET JOB = 'CLERK'
WHERE EMPNO = 1053

--C3. Update the salary
--Change the same employee's salary to 1500 with a second targeted UPDATE statement.

UPDATE SCOTT.EMP
SET SAL = 1500
WHERE EMPNO = 1053;

--Part D - Remove and verify
--D1. Preview
--Write a SELECT whose predicate identifies only the row inserted in Part B.

SELECT 
    *
FROM SCOTT.EMP
WHERE EMPNO=1053;

--D2. DELETE

DELETE FROM SCOTT.EMP
WHERE EMPNO=1053;

--D3. CHECK IF THE DELETION REALLY TARGETED THE CORRECT EMPLOYEE

SELECT 
    *
FROM SCOTT.EMP
WHERE EMPNO=1053;