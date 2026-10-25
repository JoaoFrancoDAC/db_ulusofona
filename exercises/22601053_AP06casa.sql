/*
  Lesson 06 - CONSTRAINTS casa
  Student:João Victor Franco da Costa   
  Date:25/10/2026 noite 7:30 - 9:30
*/

--A1. Prepare a service-request table
--Create sales.service_request with required integer request number, required request_code VARCHAR(18), 
--nullable customer ID, opened and closed dates, nullable status text, and nullable priority number. Add no constraints during creation.

--Expected state: one seven-column base table and no table constraints.

USE BikeStores;

IF OBJECT_ID('sales.service_request') IS NULL
BEGIN
CREATE TABLE sales.service_request (
  request_number INT NOT NULL,
  request_code VARCHAR(18) NOT NULL,
  customer_id INT NULL,
  opened_date DATE NULL,
  closed_date DATE NULL,
  status_text VARCHAR(10) NULL,
  priority_number INT NULL
)END;

--A2. Primary identity
--Demonstrate that request number has neither duplicates nor nulls, then make it the named primary key.

--Expected state: metadata reports one PK and its unique index.

SELECT request_number 
FROM sales.service_request 
WHERE request_number IS NULL;

SELECT
  request_number,
  COUNT(request_number) as repeticoes
FROM SALES.service_request
GROUP BY request_number

ALTER TABLE SALES.service_request
ADD CONSTRAINT PK_request_number PRIMARY KEY (request_number);

SELECT 
  name,
  unique_index_id
FROM sys.key_constraints
WHERE parent_object_id = object_id('SALES.service_request')

SELECT
  name,
  type_desc,
  is_unique
FROM sys.indexes
where object_id = OBJECT_ID('SALES.service_request') and name = 'PK_request_number'

--A3. Alternate identity
--Make request code an alternate key after an appropriate duplicate preview.

--Expected state: one named UNIQUE constraint whose index is not the primary-key index.

SELECT 
  request_code,
  count(request_code) as duplicatas
FROM SALES.service_request

WHERE request_code is not null 
GROUP BY request_code
HAVING count(request_code) >1

ALTER TABLE SALES.service_request
ADD CONSTRAINT UQ_request_code UNIQUE(request_code)

SELECT
  name,
  type_desc,
  unique_index_id
FROM sys.key_constraints
WHERE parent_object_id = OBJECT_ID('sales.service_request');

--A4. Priority domain
--Require priority, when present, to be an integer from 1 through 5. Demonstrate one accepted boundary value and document one rejected value.

--Expected state: catalogue definition contains both bounds; valid test data remains.

ALTER TABLE SALES.service_request
ADD CONSTRAINT CK_priority_number CHECK (priority_number >= 1 and priority_number <= 5)

INSERT INTO sales.service_request (request_number, request_code, priority_number)
VALUES (101, 'REQ-001', 5);

--INSERT INTO sales.service_request (request_number, request_code, priority_number)
--VALUES (101, 'REQ-001', 6);


--A5. Lifecycle order
--Require closed date to be on or after opened date. Your explanation must state how a missing closed date behaves.

--Expected state: an open request with null closed date is permitted; reversed dates are rejected.

--EXPLICAÇÃO: Datas nulas não são passíveis de validação lógica comparativa pois null é uma ausência de valor. Ao se comparar qualquer valor à um null obtemos "unknown"
-- E unknown é diferente de falso
ALTER TABLE SALES.service_request
ADD CONSTRAINT CK_close_and_opened_date_logic CHECK (opened_date <= closed_date)

--A6. Controlled status vocabulary
--Permit only OPEN, WAITING, or CLOSED, while still permitting null. Use a named check and verify its definition.

--Expected state: the three literals appear in metadata and no solution relies on a separate lookup table.

ALTER TABLE SALES.service_request
ADD CONSTRAINT CK_status_text_limits CHECK (status_text='OPEN' OR status_text ='WAITING' or status_text='CLOSED')
-- PODERIA SER USADO TAMBÉM (status_text IN ('OPEN', 'WAITING', 'CLOSED')

SELECT
  name,
  definition
FROM sys.check_constraints
WHERE parent_object_id = object_id('SALES.service_request') and 
name = 'CK_status_text_limits'

--A7. Required status through CHECK
--Enforce non-null status with an additional named CHECK, rather than changing the column specification. Explain one operational advantage and one complexity cost.

--Expected state: two separate status-related checks exist.

ALTER TABLE sales.service_request
ADD CONSTRAINT CK_status_text_not_null CHECK (status_text IS NOT NULL);

SELECT *
FROM sales.service_request
UPDATE sales.service_request
SET status_text = 'OPEN'
WHERE status_text is null

SELECT
  name,
  definition
FROM sys.check_constraints
WHERE parent_object_id = object_id('SALES.service_request')
AND definition LIKE '%status_text%';


--A8. Disable and restore trust
--Disable only the priority constraint, verify its state, then re-enable it while validating all stored rows.

--Expected state: the final catalogue row reports enabled and trusted.

SELECT 
  name,
  is_disabled,
  is_not_trusted
FROM Sys.check_constraints
WHERE parent_object_id = object_id('SALES.service_request');

ALTER TABLE sales.service_request
NOCHECK CONSTRAINT CK_priority_number;

SELECT *
FROM sales.service_request

UPDATE sales.service_request
SET priority_number = 6
WHERE request_number = 101;

ALTER TABLE sales.service_request
WITH CHECK CHECK CONSTRAINT CK_priority_number;

DROP TABLE sales.service_request;
GO



