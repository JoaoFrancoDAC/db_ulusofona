/*
  Lesson 06 - CONSTRAINTS guided
  Student:João Victor Franco da Costa   
  Date:25/10/2026 noite 7:30 - 9:30
*/

USE ULHT_DB26

--G1

IF OBJECT_ID('HR.employee_certification') IS NULL
BEGIN
    CREATE TABLE HR.employee_certification (
        certification_id INT NOT NULL,
        employee_id INT NOT NULL,
        certificate_code VARCHAR(20) NOT NULL,
        issue_date DATE NULL,
        expiry_date DATE NULL,
        score DECIMAL(10,2) NULL
    );
END



--G2

-- verificar se há algum valor NULL na coluna que iremos transformar em primary key
SELECT * 
FROM HR.employee_certification 
WHERE certification_id IS NULL;

--verificar se há duplicatas
SELECT certification_id, COUNT(*) AS repeticoes
FROM HR.employee_certification
GROUP BY certification_id
HAVING COUNT(*) > 1;


ALTER TABLE HR.employee_certification
ADD CONSTRAINT PK_employee_certification PRIMARY KEY (certification_id);

-- Inspecionar o "backing index" (Índice de apoio)
SELECT 
    name,
    type_desc,
    is_unique
FROM SYS.indexes
WHERE object_id = OBJECT_ID('HR.employee_certification')

--G3
SELECT 
    employee_id, 
    certificate_code, 
    COUNT(*) AS repeticoes
FROM HR.employee_certification
GROUP BY employee_id, certificate_code
HAVING COUNT(*) > 1;

ALTER TABLE HR.employee_certification
ADD CONSTRAINT UQ_employee_certification_pair UNIQUE (employee_id, certificate_code);


SELECT 
    OBJECT_NAME(i.object_id) AS nome_da_tabela, -- minha solucao, meio ruim
    i.name AS nome_do_indice
FROM sys.indexes AS i
WHERE i.object_id = OBJECT_ID('HR.employee_certification')


-- completa sem usar JOIN
SELECT 
    'UQ_employee_certification_pair' AS nome_da_constraint,
    COL_NAME(object_id, column_id) AS nome_da_coluna,
    key_ordinal AS posicao_na_chave
FROM sys.index_columns
WHERE object_id = OBJECT_ID('HR.employee_certification')
  AND index_id = (
      -- A SUBCONSULTA: Descobre o número do índice sem precisar de JOIN
      SELECT index_id 
      FROM sys.indexes 
      WHERE object_id = OBJECT_ID('HR.employee_certification') 
        AND name = 'UQ_employee_certification_pair'
  );

-- com join, que ainda não foi ensinado
SELECT 
    i.name AS nome_da_constraint,
    COL_NAME(ic.object_id, ic.column_id) AS nome_da_coluna, -- Substitui o JOIN com sys.columns
    ic.key_ordinal AS posicao_na_chave
FROM sys.indexes AS i
INNER JOIN sys.index_columns AS ic 
    ON i.object_id = ic.object_id AND i.index_id = ic.index_id
WHERE i.object_id = OBJECT_ID('HR.employee_certification')
  AND i.name = 'UQ_employee_certification_pair';

--G4

SELECT 
    certification_id, 
    score 
FROM HR.employee_certification
;

ALTER TABLE HR.EMPLOYEE_CERTIFICATION
ADD CONSTRAINT CK_employee_certification_score CHECK (score>=0 and score<= 100 );

SELECT*
FROM HR.employee_certification

INSERT INTO HR.employee_certification(certification_id, employee_id, certificate_code, score)
VALUES( 
    1,
    100,
    'SQL',
    95.00
);

INSERT INTO HR.employee_certification (certification_id, employee_id, certificate_code, score)
VALUES (2, 101, 'SQL-102', 150.00);

-- A5

--Duas datas nulas ou apenas 1 delas nulas são aceitas pelo fato de NULL não ser um valor, e sim a ausência de valor
--Isso é possível graças à logica de 3 valores, True, False e unknown. Ao comparar algo com NULL não obtemos falso
--E sim "desconhecido" e acaba sendo permitido entrar valores negativos em ambas as colunas já que ambas são colunas nullable

ALTER TABLE HR.employee_certification
ADD CONSTRAINT CK_employee_certification_dates CHECK (issue_date <= expiry_date)


--A6

ALTER TABLE HR.employee_certification
NOCHECK CONSTRAINT CK_employee_certification_score;

SELECT 
    name,
    is_disabled,
    is_not_trusted
FROM sys.check_constraints
WHERE name = 'CK_employee_certification_score';

ALTER TABLE HR.employee_certification
WITH CHECK CHECK CONSTRAINT CK_employee_certification_score;

DROP TABLE HR.employee_certification;