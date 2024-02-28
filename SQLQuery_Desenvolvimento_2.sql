CREATE DATABASE VENDAS

USE VENDAS

CREATE TABLE tabela_saldos(
produto VARCHAR(10),
saldo_inicial NUMERIC(10),
saldo_final NUMERIC(10),
data_ult_movt DATETIME
);

INSERT INTO tabela_saldos(produto, saldo_inicial, saldo_final, data_ult_movt)
VALUES ('Notebook', 0, 100, GETDATE());


CREATE TABLE tabela_vendas(
id_vendas INT,
produto VARCHAR(10),
quantidade INT,
data DATETIME
);

CREATE SEQUENCE seq_tabela_vendas
AS NUMERIC
START WITH 1
INCREMENT BY 1;

CREATE TABLE historico_vendas(
produto VARCHAR(10),
quantidade INT,
data_venda DATETIME
);


CREATE TRIGGER trg_ajustaSaldo
ON tabela_vendas
FOR INSERT
AS
BEGIN
    DECLARE @QUANTIDADE   INT,
	        @DATA         DATETIME,  
			@PRODUTO     VARCHAR(10)

    SELECT @data = DATA, @QUANTIDADE = quantidade, @PRODUTO = produto FROM INSERTED

	UPDATE tabela_saldos
	   SET saldo_final = saldo_final - @QUANTIDADE, 
	       data_ult_movt = @DATA 
	WHERE produto = @PRODUTO;

	INSERT INTO historico_vendas (produto, quantidade, data_venda)
	VALUES (@produto, @quantidade, @data);

END 

INSERT INTO tabela_vendas (id_vendas, produto, quantidade, data)
     VALUES (NEXT VALUE FOR seq_tabela_vendas, 'Notebook', 10, getdate());

SELECT * FROM tabela_vendas
SELECT * FROM tabela_saldos
SELECT * FROM historico_vendas

