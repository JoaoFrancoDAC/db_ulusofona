USE ULHT_DB26;
GO

CREATE SCHEMA ALUNOEU;
GO

--1criar tabelas
CREATE TABLE ALUNOEU.alunos (
    aluno_id INT PRIMARY KEY NOT NULL,
    aluno_nome VARCHAR(15) NOT NULL
);

CREATE TABLE ALUNOEU.estagios(
    estagio_id INT PRIMARY KEY NOT NULL,
    estagio_nome VARCHAR(15) NOT NULL,
    empresa VARCHAR(15) NOT NULL,
    aluno_id int NOT NULL,
    data_inicio DATE not NULL
);
--1
ALTER TABLE ALUNOEU.estagios
ADD CONSTRAINT UQ_aluno_data_inicio UNIQUE (aluno_id, data_inicio);

ALTER TABLE ALUNOEU.estagios
ADD CONSTRAINT FK_aluno_id FOREIGN KEY (aluno_id) REFERENCES ALUNOEU.alunos (aluno_id);


SELECT NAME
FROM SYS.key_constraints
WHERE NAME = 'UQ_aluno_data_inicio';

--1checar que foram criadas
select 
    table_name
from INFORMATION_SCHEMA.TABLES
where TABLE_SCHEMA = 'ALUNOEU';


--2 Inserir valores na tabela alunos
INSERT INTO ALUNOEU.alunos (aluno_id,aluno_nome) 
    VALUES 
    (1,'Joao'),
    (2,'Maria'),
    (3,'Pedro');

Select *
FROM ALUNOEU.alunos;

-- 2Inserir valores na tabela de estagios
INSERT INTO ALUNOEU.estagios (estagio_id,estagio_nome,empresa, aluno_id,data_inicio)
    VALUES (
        1,'DEV','amazon',1,'2025-01-01'
    ),
    (   
        2, 'ADM', 'google',2,'2025-02-01' 
    ),
    (
        3,'DEV', 'google',2,'2026-01-01'
    );

--2Listar dados inseridos
SELECT *
FROM ALUNOEU.estagios;

SELECT 
    a.aluno_nome,
    e.estagio_nome,
    e.empresa,
    e.data_inicio
FROM ALUNOEU.alunos as a
LEFT JOIN ALUNOEU.estagios as e
    ON a.aluno_id = e.aluno_id;

--3
--Crio a coluna
ALTER TABLE ALUNOEU.estagios
ADD data_conclusao DATE NULL;

--3confiro
SELECT *
FROM ALUNOEU.estagios;

--3adiciono a check constraitn
ALTER TABLE ALUNOEU.estagios
ADD CONSTRAINT CK_data_conclusao_duracao_minima CHECK (data_conclusao>=(DATEADD(month,1,data_inicio)));

SELECT *
FROM sys.check_constraints
where name = 'CK_DATA_CONCLUSAO_DURACAO_MINIMA';


--3adiciono uma data de conclusao
UPDATE ALUNOEU.estagios
SET data_conclusao = '2025-02-01'
WHERE estagio_id = 1;

--3Mostrar tudo
SELECT*
FROM ALUNOEU.estagios;

--3mostro estagios concluidos
SELECT *
FROM ALUNOEU.estagios
where data_conclusao is not null;

--4 update do id do aluno
ALTER TABLE ALUNOEU.estagios
DROP CONSTRAINT FK_aluno_id;

ALTER TABLE ALUNOEU.estagios
ADD CONSTRAINT FK_aluno_id FOREIGN KEY (aluno_id) REFERENCES ALUNOEU.alunos (aluno_id)
ON UPDATE CASCADE;

SELECT *
FROM SYS.foreign_keys
WHERE NAME = 'FK_aluno_id';

UPDATE ALUNOEU.alunos
SET aluno_id = 10
where aluno_id = 1;

--listar o conteudo inteiro dele
SELECT * 
FROM ALUNOEU.alunos
where aluno_id=10;


--5 apagar um estagio existente
DELETE FROM ALUNOEU.estagios
WHERE ESTAGIO_ID = 2;

SELECT *
FROM ALUNOEU.estagios
WHERE ESTAGIO_ID = 2;

--6 DELETAR TODOS OS DADOS

DELETE  FROM ALUNOEU.estagios;
DELETE  FROM ALUNOEU.alunos;

SELECT * FROM ALUNOEU.estagios;
SELECT * FROM ALUNOEU.alunos;


--7APAGAR AS TABELAS E O SCHEMA
DROP TABLE ALUNOEU.estagios;
DROP TABLE ALUNOEU.alunos;

SELECT  
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'estagios' or TABLE_NAME ='alunos';

DROP SCHEMA ALUNOEU;





