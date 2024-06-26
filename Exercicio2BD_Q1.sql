CREATE TABLE FUNCIONARIO (
    PRIMEIRO_NOME VARCHAR(50),
    NOME_MEIO VARCHAR(50),
    ULTIMO_NOME VARCHAR(50),
    CPF VARCHAR(11) PRIMARY KEY,
    DATA_NASCIMENTO DATE,
    ENDERECO VARCHAR(100),
    SEXO CHAR(1) NOT NULL, -- Para testar tentativa de violação não nula
    SALARIO DECIMAL(10, 2),
    CPF_SUPERVISOR VARCHAR(11),
    NUMERO_DEPARTAMENTO INT
);

CREATE TABLE DEPARTAMENTO (
    NOME_DEPARTAMENTO VARCHAR(50),
    NUMERO_DEPARTAMENTO INT PRIMARY KEY,
    CPF_GERENTE VARCHAR(11) UNIQUE,
    DATA_INICIO_GERENTE DATE
);

CREATE TABLE LOCALIZACOES_DEPARTAMENTO (
    NUMERO_DEPARTAMENTO INT,
    LOCAL_ VARCHAR(50),
    PRIMARY KEY(NUMERO_DEPARTAMENTO, LOCAL_)
);

CREATE TABLE PROJETO (
    NOME_PROJETO VARCHAR(50),
    NUMERO_PROJETO INT PRIMARY KEY,
    LOCAL_PROJETO VARCHAR(50),
    NUMERO_DEPARTAMENTO INT
);

CREATE TABLE TRABALHA_EM (
    CPF_FUNCIONARIO VARCHAR(11),
    NUMERO_PROJETO INT,
    HORAS INT,
    PRIMARY KEY(CPF_FUNCIONARIO, NUMERO_PROJETO)
);

CREATE TABLE DEPENDENTE (
    CPF_FUNCIONARIO VARCHAR(11),
    NOME_DEPENDENTE VARCHAR(50),
    SEXO CHAR(1),
    DATA_NASCIMENTO DATE,
    PARENTESCO VARCHAR(50),
    PRIMARY KEY(CPF_FUNCIONARIO, NOME_DEPENDENTE)
);

ALTER TABLE FUNCIONARIO ADD CONSTRAINT FK_FUNCIONARIO_SUPERVISOR FOREIGN KEY (CPF_SUPERVISOR) REFERENCES FUNCIONARIO(CPF);
ALTER TABLE FUNCIONARIO ADD CONSTRAINT FK_FUNCIONARIO_DEPARTAMENTO FOREIGN KEY (NUMERO_DEPARTAMENTO) REFERENCES DEPARTAMENTO(NUMERO_DEPARTAMENTO);

ALTER TABLE DEPARTAMENTO ADD CONSTRAINT FK_DEPARTAMENTO_GERENTE FOREIGN KEY (CPF_GERENTE) REFERENCES FUNCIONARIO(CPF) ON DELETE SET NULL;

ALTER TABLE LOCALIZACOES_DEPARTAMENTO ADD CONSTRAINT FK_DEPARTAMENTO_LOCALIZACOES FOREIGN KEY (NUMERO_DEPARTAMENTO) REFERENCES DEPARTAMENTO(NUMERO_DEPARTAMENTO) ON DELETE CASCADE;

ALTER TABLE PROJETO ADD CONSTRAINT FK_PROJETO_DEPARTAMENTO FOREIGN KEY (NUMERO_DEPARTAMENTO) REFERENCES DEPARTAMENTO(NUMERO_DEPARTAMENTO);

ALTER TABLE TRABALHA_EM ADD CONSTRAINT FK_TRABALHA_EM_FUNCIONARIO FOREIGN KEY (CPF_FUNCIONARIO) REFERENCES FUNCIONARIO(CPF) ON DELETE CASCADE;
ALTER TABLE TRABALHA_EM ADD CONSTRAINT FK_TRABALHA_EM_PROJETO FOREIGN KEY (NUMERO_PROJETO) REFERENCES PROJETO(NUMERO_PROJETO) ON DELETE CASCADE;

ALTER TABLE DEPENDENTE ADD CONSTRAINT FK_DEPENDENTE_FUNCIONARIO FOREIGN KEY (CPF_FUNCIONARIO) REFERENCES FUNCIONARIO(CPF) ON DELETE CASCADE;
