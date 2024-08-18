-- Nome: Matheus Monteiro Huebra Perdigão
--       Letícia de Oliveira Soares


-- Questão 1

-- Matheus será usuário 1
-- Letícia será usuário 2

-- Questão 2

CREATE TABLE MEMBRO (
    MAT VARCHAR(12) PRIMARY KEY,
    NOME VARCHAR2(40) NOT NULL, 
    CPF VARCHAR2(11) NOT NULL,
    ENDE VARCHAR2(40) NOT NULL, 
    DATA_NASC DATE NOT NULL 
);


-- Questão 3

INSERT INTO MEMBRO
VALUES (111, 'Matheus Huebra', '11111111111', 'Rua PUC', '09/06/2003');


-- Questão 4

SELECT * FROM ECLBDIT207.MEMBRO;
-- Deu erro: ORA-00942, não conseguimos acessar a tabela
-- pois não temos as autorizações necessárias


-- Questão 5

GRANT SELECT ON MEMBRO TO ECLBDIT207;
SELECT * FROM ECLBDIT207.MEMBRO;
-- Funcionou


-- Questão 6

INSERT INTO MEMBRO
VALUES (222, 'Evandrino', '33333333333', 'Rua DECOM', '02/08/1990');
INSERT INTO MEMBRO
VALUES (333, 'João', '44444444444', 'Rua Niterói', '12/06/2012');

SELECT * FROM ECLBDIT207.MEMBRO;
-- Só aparece 1 linha, não as 2 recém adicionadas, porque não foi 
-- dado nenhum commit, somente a adição "local"


-- Questão 7

COMMIT;

SELECT * FROM ECLBDIT207.MEMBRO;
-- Agora aparecem as 3 linhas corretamente, já que o commit
-- confirma as mudanças a nível de banco de dados público


-- Questão 8

INSERT INTO MEMBRO 
VALUES (444, 'Mateus', '44444444444', 'Rua Contria', '19/01/2003');
INSERT INTO MEMBRO
VALUES (555, 'Leila', '55555555555', 'Rua Lourdes', '12/03/1976');

SELECT * FROM MEMBRO;
-- Aparecem as 5 linhas, sendo as 3 primeiras os registros adicionados
-- nas questões anteriores, e os dois últimos relacionados a última transação

SELECT * FROM ECLBDIT207.MEMBRO;
-- Aparecem somente 3 linhas, pois as últimas 2 ainda não foram "commitadas"


-- Questão 9

ROLLBACK;
SELECT * FROM MEMBRO;
-- Somente apareceram 3 linhas, justamente as 3 que já foram "commitadas"
-- o ROLLBACK cancelou a anexação das linhas criadas à tabela pois não 
-- concluiu a transação


-- Questão 10

UPDATE ECLBDIT207.MEMBRO 
SET NOME = 'José'
WHERE MAT = 111;
-- Deu erro, ORA-01031, erro esse assossiado a falta de privilégio para 
-- uma ação, nesse caso a de alteração de uma tabela


-- Questão 11

GRANT UPDATE ON MEMBRO TO ECLBDIT207;


-- Questão 12

UPDATE ECLBDIT207.MEMBRO 
SET NOME = 'José'
WHERE MAT = 111;

SELECT * FROM ECLBDIT207.MEMBRO;
-- Consulta a tabela do outro usuário para procurar o José.
-- Na nossa visualização, a matrícula 222 já está como José,
-- porém no segundo usuário, não aparece, aparece o nome original (matheus)

SELECT * FROM MEMBRO;
-- A nossa tabela não foi alterada, análogamente ao caso acima,
-- pois não foi emitido commit, por parte do outro usuário (nem nossa)


-- Questão 13

COMMIT;
SELECT * FROM ECLBDIT207.MEMBRO;
-- Ao fazer o SELECT podemos ver nossa alteração, e quando
-- o outro usuário faz SELECT na própria tabela (igual faremos abaixo)
-- já é possível ver a alteração feita na tabela, isto porque o 
-- COMMIT foi feito, portanto a mudança persiste no banco de dados

SELECT * FROM MEMBRO;
-- Nossa tabela foi também alterada conforme explicação acima


-- Questão 14

-- Atualizaremos a nossa própria tabela (do usuário ECLBDIT210)
UPDATE MEMBRO
SET NOME = 'Andrei'
WHERE MAT = 333;
-- O comando foi usado ao mesmo tempo e o usuário 2 está "travado"
-- pois o comando está na "fila" para execução


-- Questão 15

COMMIT;
-- Assim que o COMMIT foi finalizado, o outro usuário teve a tabela
-- alterada, só que localmente, uma vez que por parte dele não houve COMMIT
-- e/ou ROLLBACK



-- Questão 16

-- a)
UPDATE ECLBDIT207.MEMBRO
SET NOME = 'Andrei'
WHERE MAT = 111;

-- b)
UPDATE MEMBRO
SET NOME = 'Matheus'
WHERE MAT = 111;

ROLLBACK;

-- Nas situações acima, houve de fato o deadlock e o usuário 2
-- ficou esperando. A solução do problema foi usar um ROLLBACK
-- para destravar o usuário travado


-- Questão 17

REVOKE SELECT, UPDATE ON MEMBRO FROM ECLBDIT207;

SELECT * FROM ECLBDIT207.MEMBRO;
-- Como esperado, o SELECT não funcionou, visto que o REVOKE 
-- removeu a "autoridade" nossa de realizar consultas e mudanças
-- nas tabelas 

