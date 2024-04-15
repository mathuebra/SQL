-- Aula sobre Gatilhos de Banco de Dados
-- Laboratório de Banco de Dados I - Eng. Comp.
-- Prof. Evandrino G. Barros

-- remoção de tabelas que serão criadas
drop table PROJETO_COPIA cascade constraints;
drop table FUNCIONARIO_COPIA cascade constraints;
drop table DEPARTAMENTO_COPIA cascade constraints;

--  com criar uma tabela a partir de outra
-- somente as regras de not null são copiadas, ou seja, não veem com PK ou FKs
create table PROJETO_COPIA
as select * from ALUNO.PROJETO where 1=2;

desc projeto_copia;
select * from projeto_copia;
-- como incluir dados em uma tabela a partir de um select em outra, 
-- com a mesma estrutura
insert into projeto_copia  select * from aluno.projeto;

select *  from PROJETO_COPIA ;

CREATE OR REPLACE TRIGGER proibido_novo_projeto
BEFORE INSERT ON PROJETO_COPIA
BEGIN
	   RAISE_APPLICATION_ERROR (-20001,'A empresa não está aceitando novos projetos.');
END;  -- faixa de erro é de 20001 a 20999 (negativos)
/

insert into PROJETO_COPIA values ('Proj NoSQL',200,'Contagem',4);

drop trigger proibido_novo_projeto;

insert into PROJETO_COPIA values ('Proj NoSQL',200,'Contagem',4);

select * from PROJETO_COPIA;

rollback;

select * from PROJETO_COPIA;

-- criando uma tabela e já inserido dados
create table FUNCIONARIO_COPIA as select * from aluno.FUNCIONARIO WHERE 1 = 2;

select * from FUNCIONARIO_COPIA;

CREATE OR REPLACE TRIGGER  atu_salario_funcionario
BEFORE UPDATE ON Funcionario_copia
BEGIN
	   IF UPDATING ('Salario') THEN
   		     Raise_Application_Error ( -20001, 'A empresa não está permitindo alteração de salário.'); 
             -- faixa: -20.000 a -20.999
	   END IF;
END;
/

INSERT INTO FUNCIONARIO_COPIA 
SELECT * FROM ALUNO.FUNCIONARIO;

SELECT * FROM FUNCIONARIO_COPIA;

select cpf, salario 
from funcionario_copia 
where  CPF='12345678966';

update funcionario_copia set salario=salario*1.51
where  CPF='12345678966';

select cpf, salario from funcionario_copia where  CPF='12345678966';
-- disabilitando um trigger
alter trigger atu_salario_funcionario disable;


select cpf, salario from funcionario_copia where  CPF='12345678966';
update funcionario_copia set salario=salario*1.51
where  CPF='12345678966';

select cpf, salario from funcionario_copia where  CPF='12345678966';

rollback;

select cpf, salario from funcionario_copia where  CPF='12345678966';

select to_char(sysdate,'HH24') hora_do_dia_do_bd_em_cloud from sys.dual;
select cpf, salario from funcionario_copia where  CPF='12345678966';
select sysdate from sys.dual;
CREATE OR REPLACE TRIGGER seguranca_funcionario
BEFORE INSERT OR DELETE OR UPDATE ON Funcionario_Copia
BEGIN
    IF (To_Char (Sysdate, 'DY') in ('SAB','DOM')) or
          (To_Char (Sysdate, 'HH24') not between 8 and 20)  THEN
           IF DELETING THEN
                 Raise_Application_Error (-20001, 'Não é permitido excluir funcionários fora do horário comercial');
           ELSIF INSERTING THEN
                 Raise_Application_Error (-20002, 'Não é permitido inserir funcionários fora do horário comercial');
           ELSE
                 Raise_Application_Error (-20003, 'Não é permitido alterar funcionários fora do horário comercial');
           END IF;
    END IF;
END;
/

insert into funcionario_copia(primeiro_nome, nome_meio, ultimo_nome, cpf, data_nascimento, endereco, sexo, salario, numero_departamento)
values  ('João', 'B', 'Silva', '1000000000', '09-01-1965', 'Rua das Flores, 751, São Paulo, SP', 'M', 30000, 5);

select * from funcionario_copia;

CREATE OR REPLACE TRIGGER seguranca_funcionario
BEFORE INSERT OR DELETE OR UPDATE ON Funcionario_Copia 
BEGIN
    IF (To_Char (Sysdate, 'DY') in ('SEX','DOM')) or
          (To_Char (Sysdate, 'HH24') not between 8 and 16)  THEN
           IF DELETING THEN
                 Raise_Application_Error (-20001, 'Não é permitido excluir funcionários fora do horário comercial');
           ELSIF INSERTING THEN
                 Raise_Application_Error (-20002, 'Não é permitido inserir funcionários fora do horário comercial');
           ELSE
                 Raise_Application_Error (-20003, 'Não é permitido alterar funcionários fora do horário comercial');
           END IF;
    END IF;
END;
/

insert into funcionario_copia(primeiro_nome, nome_meio, ultimo_nome, cpf, data_nascimento, endereco, sexo, salario, numero_departamento)
values  ('João', 'B', 'Silva', '99999999999', '09-01-1965', 'Rua das Flores, 751, São Paulo, SP', 'M', 30000, 5);
select * from funcionario_copia;

drop trigger seguranca_funcionario;

-- Triger que não permite a redução de salário, mas permite
-- aumento de no máximo de 50% em relação ao salario atual
CREATE OR REPLACE TRIGGER  reajusta_salario
AFTER UPDATE OF Salario ON Funcionario_copia FOR EACH ROW
BEGIN
    IF :NEW.salario < :OLD.salario THEN
           Raise_Application_Error ( -20001, 'O salário do funcionário não pode ser diminuído.');
    ELSIF :NEW.salario > (:OLD.salario * 1.5)  THEN
           Raise_Application_Error ( -20002,'O salário do funcionário não pode ser reajustado em mais de 50%.');
    END IF;
END;
/

-- as triggers anteriores são triggers de senteça, ou seja, executam uma única vez,
-- independentemente do número de linhas que poderão ser afetadas pela sentença
-- de disparo do gatilho

-- só uma linha é alterada a seguir, mas a alteração não é aceita, 
-- pois o funcinoario em questão ganha 30.000 e alteramos para 50.000
-- ou seja, mais do que 50% de alteração
update funcionario_copia set salario=50000 where CPF='12345678966';
select * from funcionario_copia;

-- Jah para toda a tabela, há empregados que podem ter salários alterados para 40.000
-- e outros não, como, por exemplo, o de CPF 999.887.777-67. Nesse caso, a trigger
-- podeira passar por alguns empregados, e outros não (como esse). 
-- por isso, a trigger aborta todo o update, incluindo as linhas que passaram pelo trigger
update funcionario_copia set salario=40000;
select * from funcionario_copia;

select * from funcionario_copia where CPF='12345678966';
-- altera todos os salarios para 50.000, pelo menos o funcionario 123... não pode ter o aumento
update FUNCIONARIO_COPIA set salario=50000; 
select * from funcionario_copia;

update funcionario_copia set salario=salario*1.51
where  CPF='12345678966';

update funcionario_copia set salario=salario*0.50
where  CPF='12345678966';

select * from funcionario_copia where CPF='12345678966';

update FUNCIONARIO_COPIA set salario=salario*1.66 where CPF='12345678966';

select * from funcionario_copia where CPF='12345678966';

rollback;

select * from funcionario_copia where CPF='12345678966';

select *
from   funcionario_copia
where  CPF='12345678966';

create table departamento_copia as select * from departamento;

drop trigger  reajusta_salario;

-- Exemplo de trigger sobre "Tabela em mutação!".
CREATE OR REPLACE TRIGGER verifica_gerente
BEFORE INSERT OR UPDATE OF Cpf_Gerente
ON Departamento_Copia FOR EACH ROW
DECLARE
    v_cpf_gerente  Departamento_Copia.CPF_Gerente%TYPE;
BEGIN
    SELECT Cpf_Gerente  INTO v_cpf_gerente
    FROM Departamento_Copia
    WHERE Cpf_Gerente = :NEW.Cpf_Gerente; -- ERRO: tabela Departamento não pode ser referenciada
    RAISE TOO_MANY_ROWS;  -- funcionário já é gerente de algum departamento
EXCEPTION
  WHEN NO_DATA_FOUND THEN  -- OK, funcionário não é gerente de nenhum departamento
     v_cpf_gerente := 0;  -- não faz nada!
  WHEN TOO_MANY_ROWS THEN
     Raise_Application_Error ( -20010, 'Não é permitido que um funcionário gerencie mais de um Departamento');
END;
/

select * from departamento_copia;
select * from funcionario_copia;
update departamento_copia set cpf_gerente='1000000000'
where numero_departamento=1;


