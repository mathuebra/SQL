CREATE TABLE DONO (
    NOME VARCHAR(50),
    CPF VARCHAR(11) PRIMARY KEY,
    NUM_TEL VARCHAR(20)
);

CREATE TABLE ANIMAL (
    NOME VARCHAR(50),
    ESPECIE VARCHAR(40),
    DONO_ID VARCHAR(11),
    ID_ANIMAL INT PRIMARY KEY
);

ALTER TABLE ANIMAL ADD CONSTRAINT FK_DONO_CPF 
FOREIGN KEY (DONO_ID) REFERENCES DONO(CPF);

-- A propriedade I do ACID diz respeito ao ISOLAMENTO, isto é,
-- a capadidade do banco de dados de conseguir lidar com múltiplos
-- acessos simultâneos e mudança de vários dados sem que as informações
-- conflitem e/ou atrapalhem umas as outras.

-- Já a propriedade D diz respeito a DURABILIDADE. Isso significa que 
-- transações e processos efetuados no banco de dados quando executadas
-- de maneira final serão preservadas no sistema, implicando que falhas elétricas,
-- mecânicas, ou quaisquer tipos de ocorrência não atrapalham a existência desses 
-- dados.

GRANT ALL ON DONO TO PUBLIC; -- Tornando a tabela Dono pública
GRANT ALL ON ANIMAL TO PUBLIC; -- Tornando a tabela Animal pública

-- Adicionando elementos na tabela

INSERT INTO DONO (NOME, CPF, NUM_TEL)
VALUES ('Matheus', '11111111111', '21');

INSERT INTO DONO (NOME, CPF, NUM_TEL)
VALUES ('Letícia', '22222222222', '31');

INSERT INTO ANIMAL (NOME, ESPECIE, DONO_ID, ID_ANIMAL)
VALUES ('Crystal', 'Cachorro', '11111111111', '1');

INSERT INTO ANIMAL (NOME, ESPECIE, DONO_ID, ID_ANIMAL)
VALUES ('Biscoito', 'Hamster', '22222222222', '2');

select * from dono;

