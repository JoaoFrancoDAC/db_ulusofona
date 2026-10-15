/*
  Lesson 07 - Referential integrity and foreign keys
  Student:João Victor Franco da Costa   a22601053
  Date:13/10/2026 noite 7:30 - 9:30
*/

USE BikeStores;
GO



-- A1 Add the customer relationship
CREATE TABLE sales.warranty_claim (
    claim_id INT NOT NULL,
    customer_id INT NOT NULL,
    staff_id INT NULL,
    product_code VARCHAR(20) NOT NULL,
    opened_on DATE NOT NULL,
    
    CONSTRAINT PK_warranty_claim PRIMARY KEY (claim_id)
);

SELECT * 
FROM sales.warranty_claim AS w
WHERE NOT EXISTS (
    SELECT * 
    FROM sales.customers AS c 
    WHERE c.customer_id = w.customer_id
);

ALTER TABLE sales.warranty_claim
ADD CONSTRAINT FK_warranty_claim_customers 
FOREIGN KEY (customer_id) 
REFERENCES sales.customers (customer_id);

/*
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'sales' 
  AND TABLE_NAME = 'warranty_claim';

SELECT 
    name AS constraint_name,
    type_desc,
    is_disabled,
    is_not_trusted
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID('sales.warranty_claim');

SELECT 
    fk.name AS nome_constraint,
    OBJECT_NAME(fk.parent_object_id) AS tabela_origem,
    col_origem.name AS coluna_origem,
    OBJECT_NAME(fk.referenced_object_id) AS tabela_destino,
    col_destino.name AS coluna_destino
FROM sys.foreign_keys AS fk
INNER JOIN sys.foreign_key_columns AS fkc 
    ON fk.object_id = fkc.constraint_object_id
INNER JOIN sys.columns AS col_origem 
    ON fkc.parent_object_id = col_origem.object_id 
    AND fkc.parent_column_id = col_origem.column_id
INNER JOIN sys.columns AS col_destino 
    ON fkc.referenced_object_id = col_destino.object_id 
    AND fkc.referenced_column_id = col_destino.column_id
WHERE OBJECT_NAME(fk.parent_object_id) = 'warranty_claim';
*/




--A2 Add the staff relationship
SELECT * 
FROM sales.warranty_claim AS w
WHERE w.staff_id IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 
      FROM sales.staffs AS s 
      WHERE s.staff_id = w.staff_id
  );

ALTER TABLE sales.warranty_claim
ADD CONSTRAINT FK_warranty_claim_staffs 
FOREIGN KEY (staff_id) 
REFERENCES sales.staffs (staff_id);


SELECT 
    name AS constraint_name,
    type_desc,
    OBJECT_NAME(parent_object_id) AS table_name_slave,
    OBJECT_NAME(referenced_object_id) AS referenced_table_name_ou_master,
    is_disabled,
    is_not_trusted
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID('sales.warranty_claim');





--A3 Insert with active foreign keys

INSERT INTO sales.warranty_claim (claim_id, customer_id, staff_id, product_code, opened_on)
VALUES (
    1, -- ID da reclamação
    (SELECT TOP 1 customer_id FROM sales.customers), -- Consulta escalar para pegar um cliente válido
    (SELECT TOP 1 staff_id FROM sales.staffs),       -- Consulta escalar para pegar um funcionário válido
    'BIKE-PROD-99', -- Código do produto                              
    '2026-10-14'                                     
);

INSERT INTO sales.warranty_claim (claim_id, customer_id, staff_id, product_code, opened_on)
VALUES (
    2,
    99999, 
    (SELECT TOP 1 staff_id FROM sales.staffs),
    'BIKE-PROD-98',
    '2026-10-14'
);

-- Este erro 547 acontece pois ao tentarmos adicionar algum id na coluna da tabela slave,
-- o sgbd(acredito eu) checa para ver se este id de fato existe na tabela referenciada (master)
-- e ao ver que este ID não existe lá, não permite a inserção





--A4 Insert and update with active foreign keys

INSERT INTO sales.warranty_claim (claim_id, customer_id, staff_id, product_code, opened_on)
VALUES (
    2,
    -- Pega o segundo cliente da tabela para garantir que seja diferente do primeiro
    (SELECT TOP 1 customer_id FROM sales.customers WHERE customer_id NOT IN (SELECT customer_id FROM sales.warranty_claim)),
    NULL,           
    'BIKE-PROD-97',
    '2026-10-14'
);

UPDATE sales.warranty_claim
SET staff_id = (SELECT TOP 1 staff_id FROM sales.staffs)
WHERE claim_id = 2;
GO


--Este seguinte da exatamente o mesmo erro que o anterior
--E justamente pelo mesmo motivo, o sgbd não encontra o id 9999 na tabela sales.staffs e por isso não permite a atualização
-- em relação a nulabilidade, eu nao entendi a questão, ele pode ser null, mas isso não significa
-- que ele pode ser qualquer coisa. (eu estou maluco aqui?)
UPDATE sales.warranty_claim
SET staff_id = 999999
WHERE claim_id = 2;
GO





--A5 Delete under NO ACTION
--Crio a que será a master
CREATE TABLE sales.claim_category (
    category_code VARCHAR(12) PRIMARY KEY
);

-- adiciono uma coluna qualquer na slave, que virá a se tornar a foreign key
ALTER TABLE sales.warranty_claim
ADD category_code VARCHAR(12) NULL;
GO

-- vinculo a coluna da slave com a master
ALTER TABLE sales.warranty_claim
ADD CONSTRAINT FK_warranty_claim_category 
FOREIGN KEY (category_code) 
REFERENCES sales.claim_category (category_code);

INSERT INTO sales.claim_category (category_code)
VALUES ('ELECTRICAL');

UPDATE sales.warranty_claim
SET category_code = 'ELECTRICAL'
WHERE claim_id = 1;

SELECT * FROM sales.claim_category;
SELECT 
    *
FROM sales.warranty_claim;

--Mesmo código de erro que antes, mas desta vez está acontecendo porque estou tentando
--deletar um registro que está sendo referenciado por alguma table slave, e como a foreign key
--on delete é sempre setada como NO ACTION por padrão, o sgbd não permite a deleção do registro da tabela master
DELETE FROM sales.claim_category 
WHERE category_code = 'ELECTRICAL';

-- Aqui simplesmente retiro o registro da tabela slave, ou seja, a tabela master não está mais com nenhum registro referenciando ela
-- apesar de que em essencia ela ainda é uma foreign key(column) de alguém (a warranty_claim), mas como ela não tem mais nenhum dependente
-- o sgbd permite deletar tranquilamente
UPDATE sales.warranty_claim
SET category_code = NULL
WHERE claim_id = 1;

--Aqui deleta bonito, agora
DELETE FROM sales.claim_category 
WHERE category_code = 'ELECTRICAL';





--A6: Compare a cascading deletion
ALTER TABLE sales.warranty_claim
DROP CONSTRAINT FK_warranty_claim_category;

ALTER TABLE sales.warranty_claim
ADD CONSTRAINT FK_warranty_claim_category 
FOREIGN KEY (category_code) 
REFERENCES sales.claim_category (category_code)
ON DELETE CASCADE;

INSERT INTO sales.claim_category (category_code)
VALUES ('MECHANICAL');

SELECT * FROM sales.claim_category;
SELECT * FROM sales.warranty_claim;
SELECT * FROM sales.customers;

INSERT INTO sales.warranty_claim (claim_id, customer_id, staff_id, category_code, product_code, opened_on)
VALUES 
    (3, (SELECT TOP 1 customer_id FROM sales.customers), NULL, 'MECHANICAL', 'BIKE-PROD-95', '2026-10-14'),
    
    (4, (SELECT TOP 1 customer_id FROM sales.customers WHERE customer_id NOT IN (SELECT customer_id FROM sales.warranty_claim)), NULL, 'MECHANICAL', 'BIKE-PROD-94', '2026-10-14');

DELETE FROM sales.claim_category 
WHERE category_code = 'MECHANICAL';






--A7 Remove foreign keys

SELECT 
    name AS constraint_name,
    OBJECT_NAME(parent_object_id) AS table_name_slave,
    OBJECT_NAME(referenced_object_id) AS referenced_table_name_ou_master
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID('sales.warranty_claim');

ALTER TABLE sales.warranty_claim
DROP CONSTRAINT FK_warranty_claim_category, FK_warranty_claim_customers,
FK_warranty_claim_staffs;

SELECT * FROM sales.warranty_claim;






-- A8 Restore and trust one relationship

ALTER TABLE sales.warranty_claim
ADD CONSTRAINT FK_warranty_claim_customers
FOREIGN KEY (customer_id) 
REFERENCES sales.customers (customer_id);

ALTER TABLE sales.warranty_claim
CHECK CONSTRAINT FK_warranty_claim_customers;

INSERT INTO sales.warranty_claim (claim_id, customer_id, staff_id, category_code, product_code, opened_on)
VALUES (5, 99999, NULL, NULL, 'BIKE-PROD-88', '2026-10-15');

ALTER TABLE sales.warranty_claim
NOCHECK CONSTRAINT FK_warranty_claim_customers;

INSERT INTO sales.warranty_claim (claim_id, customer_id, staff_id, category_code, product_code, opened_on)
VALUES (5, 99999, NULL, NULL, 'BIKE-PROD-88', '2026-10-15');

SELECT claim_id, customer_id, product_code
FROM sales.warranty_claim
WHERE customer_id NOT IN (SELECT customer_id FROM sales.customers); -- customer_id de warranty_claim que não existe na customers

SELECT 
    name AS constraint_name,
    OBJECT_NAME(parent_object_id) AS table_name_slave,
    OBJECT_NAME(referenced_object_id) AS referenced_table_name_ou_master,
    is_disabled, -- ta 1 os 2 is_disabled e is_not_trusted
    is_not_trusted
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID('sales.warranty_claim')
  AND name = 'FK_warranty_claim_customers';

DELETE FROM sales.warranty_claim
WHERE claim_id = 5; -- continuou 1, achei que voltaria a ser 0 já que eu removi a incongruência entre a slave e a master

ALTER TABLE sales.warranty_claim
CHECK CONSTRAINT FK_warranty_claim_customers; -- bom, o is_disabled voltou a 0, isto faz sentido, mas o is_not_trusted continuou a 1
-- não entendi

SELECT claim_id, customer_id, product_code
FROM sales.warranty_claim
WHERE customer_id NOT IN (SELECT customer_id FROM sales.customers);

ALTER TABLE sales.warranty_claim WITH CHECK CHECK CONSTRAINT FK_warranty_claim_customers; -- funcionou agora
DROP TABLE sales.warranty_claim;





-- A9 Design a three-table dependency chain

-- MASTER
CREATE TABLE sales.service_plan (
    plan_id INT PRIMARY KEY,
    plan_name VARCHAR(20) NOT NULL,
    subscriber_count INT NOT NULL
);

--Slave de service_plan e master de visit_note
CREATE TABLE sales.service_visit (
    visit_id INT PRIMARY KEY,
    plan_id INT NOT NULL,
    visit_type VARCHAR(50) NOT NULL, 
    CONSTRAINT FK_visit_service_plan FOREIGN KEY (plan_id) 
        REFERENCES sales.service_plan (plan_id)
);

-- Slave de service_visit
CREATE TABLE sales.visit_note (
    note_id INT PRIMARY KEY,
    visit_id INT NOT NULL,
    note_text VARCHAR(255) NOT NULL,
    CONSTRAINT FK_note_service_visit FOREIGN KEY (visit_id) 
        REFERENCES sales.service_visit (visit_id)
);

SELECT 
    name AS constraint_name,
    OBJECT_NAME(parent_object_id) AS table_name_slave,
    OBJECT_NAME(referenced_object_id) AS referenced_table_name_ou_master
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID('sales.service_visit') OR parent_object_id = OBJECT_ID('sales.visit_note');

INSERT INTO sales.service_plan (plan_id, plan_name, subscriber_count)
VALUES (1, 'Plano Premium', 150);

INSERT INTO sales.service_visit (visit_id, plan_id, visit_type)
VALUES (100, 1, 'Consulta de Rotina e raio x'); -- se for 2 no segundo valor da o erro 547

INSERT INTO sales.visit_note (note_id, visit_id, note_text)
VALUES (1000, 100, 'Paciente com cancer de pele, precisa de acompanhamento semanal');

SELECT * FROM sales.service_plan, sales.service_visit, sales.visit_note;

DELETE FROM sales.visit_note WHERE note_id = 1000; -- deleta do slave para liberar a master de ser deletada
DELETE FROM sales.service_visit WHERE visit_id = 100; -- deleta a master que está no "meio"
DELETE FROM sales.service_plan WHERE plan_id = 1; -- deleta a primeira (perguntar ao professor o que aconteceria em um ciclo)

SELECT 
    name AS constraint_name,
    OBJECT_NAME(parent_object_id) AS table_name_slave,
    OBJECT_NAME(referenced_object_id) AS referenced_table_name_ou_master
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID('sales.service_visit') OR parent_object_id = OBJECT_ID('sales.visit_note');

DROP TABLE sales.visit_note; -- pode dropar diretamente na ordem reversa ou remover as declarações de referências entre elas
--ALTER TABLE sales.visit_note  
--DROP CONSTRAINT FK_note_service_visit; << isso me parece ser mais "correto", mas talvez mais inútil  
DROP TABLE sales.service_visit;
--ALTER TABLE sales.service_visit 
--DROP CONSTRAINT FK_visit_service_plan;
DROP TABLE sales.service_plan;

