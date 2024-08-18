-- CEFET-MG
-- Eng. de Computacao - Campus Nova Gameleira
-- Aula Pratica de LBDI - 26/07/24 
-- Assunto: Processamento e otimização de Consultas
-- criacao da tabela CUSTOMERS a partir de SH.CUSTOMERS;
drop table customers; -- remocao caso jah exista
create table customers as select * from sh.customers;

-- contagem de linhas
select count(*) from customers;
-- verificacao das colunas na tabela customer
desc customers;

-- consulta01
select * from customers where cust_id=4090;  -- gerar somente o plano, sem rodar a consulta
                                             -- para isso, colocar o cursor em cima da consulta e apertar no icone explain plan ou digitar F10

-- obtendo o rowid de uma tupla
-- rowid é o endereço do bloco físico da linha
select rowid,c.cust_id, c.cust_first_name, c.cust_last_name
from   customers c where cust_id=4090;


-- consulta à linha da cust_id=4090, obitida pelo rowid
select rowid,c.cust_id, c.cust_first_name, c.cust_last_name
from   customers c where rowid='AAAibTAAAAAAXG8AMn';

-- consulta nos indices em CUSTOMERS
select index_name, index_type, blevel, leaf_blocks, table_name 
from user_indexes where table_name='CUSTOMERS';

-- criaca da PK em CUSTOMERS, cujo indice B+-Tree eh criado para garantir a unicidade
alter table CUSTOMERS add constraint CUSTOMERS_CUST_ID_PK primary key (cust_id);
select index_name, index_type, blevel, leaf_blocks, table_name from user_indexes where table_name='CUSTOMERS';

-- consulta 02
select * from customers where cust_id=4090;         -- gerar e analisar o plano: consulta com igualdade
-- consulta 03
select * from customers where cust_id>4090;         -- gerar e analisar o plano: consulta com desigualdace: +90% da linhas
select * from customers where cust_id<4090;         -- gerar e analisar o plano: consulta com desiguidade: -10% das linhas
-- consulta 04
select cust_id from customers where cust_id=4090;   -- gerar e analisar o plano 
-- consulta 05
select cust_id from customers where cust_id<4090;   -- gerar e analisar o plano
select cust_id from customers where cust_id>4090;   -- gerar e analisar o plano
-- consulta 06
select count(*) from customers where cust_id>4090;  -- gerar e analisar o plano

alter table customers drop primary key;
select index_name, index_type, blevel, leaf_blocks, table_name from user_indexes where table_name='CUSTOMERS';

-- consulta 07
select * from customers where cust_id=4090;         -- gerar e analisar o plano: consulta com igualdade
-- consulta 08
select * from customers where cust_id>4090;         -- gerar e analisar o plano: consulta com desigualdace: +90% da linhas
select * from customers where cust_id<4090;         -- gerar e analisar o plano: consulta com desiguidade: -10% das linhas

-- consulta 09
select cust_id from customers where cust_id=4090;   -- gerar e analisar o plano 
-- consulta 10
select cust_id from customers where cust_id<4090;   -- gerar e analisar o plano

select cust_id from customers where cust_id>4090;   -- gerar e analisar o plano
select count(*) from customers where cust_id>4090;  -- gerar e analisar o plano

-- criacao de indice em CUSTOMERS.CUST_CITY
drop index customers_cust_city_idx;

select index_name, index_type, blevel, leaf_blocks, table_name from user_indexes where table_name='CUSTOMERS';

-- consulta 11
select * from CUSTOMERS where CUST_CITY='Tokyo'; -- gerar e analisar o plano
create index customers_cust_city_idx on customers(cust_city); -- gerar e analisar o plano
select index_name, index_type, blevel, leaf_blocks, table_name from user_indexes where table_name='CUSTOMERS';

-- consulta 12
select * from CUSTOMERS where CUST_CITY='Tokyo'; --- gerar e analisar o plano

-- geracao de estatisticas para a coluna cust_city
ANALYZE table customers compute statistics for COLUMNS cust_city;
-- consulta 13
select * from CUSTOMERS where CUST_CITY='Tokyo'; -- gerar e analisar o plano

-- geracao de estatisticas para o indice customers_cust_city_idx
-- e uso da seletividade para escolha dos planos
ANALYZE index customers_cust_city_idx compute statistics for COLUMNS cust_city;

-- consulta 13
select * from CUSTOMERS where CUST_CITY='Tokyo';-- gerar e analisar o plano: seletiva 
-- cardinalidade s, s=16
select count(*) from customers;
-- quantidade de linhas r=55500
-- seletividade sl, sl=s/r, 16/55500=0,00288%
select * from CUSTOMERS where cust_city='Tokyo';  -- gerar e analisr o plno

-- Selectividade para select * from customers where cust_city = 'Los Angeles';
select count(*) from customers where cust_city = 'Los Angeles'; 
-- cardinalidade s, s=932
select count(*) from customers;
-- quantidade de linhas r=55500
select * from CUSTOMERS where cust_city='Los Angeles';

select count(*) from customers where cust_city >= 'Los Angeles'; 
-- cardinalidade s, s=25304
select count(*) from customers;
-- quantidade de linhas r=55500
-- seletividade da consulta - sl=25304/55500, aprox 50%
select * from CUSTOMERS where cust_city>='Los Angeles';

-- criacao da table countries para uso de juncao e indices
drop table countries;

-- consulta 14
create table countries as select * from sh.countries; 
select cs.cust_id, cs.cust_first_name, cs.cust_last_name, cs.cust_city, ct.country_name 
from customers cs join countries ct on ct.country_id=cs.country_id; -- gerar e analisar o plano de execucao

-- criacao de indices em country_id em customers e em countries
create index customers_country_id_idx on customers(country_id);
-- criacao de chave primaria que cria o indice implicitamente do tipo B+Tree
alter table countries add constraint countries_country_id_pk primary key (country_id);
select index_name, index_type, table_name, blevel, leaf_blocks 
from user_indexes where table_name in ('CUSTOMERS','COUNTRIES');

select cs.cust_id, cs.cust_first_name, cs.cust_last_name, cs.cust_city, ct.country_name 
from customers cs join countries ct on ct.country_id=cs.country_id;

-- consulta 15
select cs.cust_id, cs.cust_first_name, cs.cust_last_name, cs.cust_city , ct.country_name
from customers cs join countries ct on ct.country_id=cs.country_id
where ct.country_name='Canada';

drop index countries_country_name_idx;
create index countries_country_name_idx on countries(country_name);

-- consulta 16
select cs.cust_id, cs.cust_first_name, cs.cust_last_name, cs.cust_city , ct.country_name
from customers cs join countries ct on ct.country_id=cs.country_id
where ct.country_name='Canada';

select cs.cust_id, cs.cust_first_name, cs.cust_last_name, cs.cust_city , ct.country_name
from customers cs join countries ct on ct.country_id=cs.country_id
where ct.country_name='Canada' and cs.cust_city='Killarney';

ANALYZE table customers compute statistics for COLUMNS cust_city;

select cs.cust_id, cs.cust_first_name, cs.cust_last_name, cs.cust_city , ct.country_name
from customers cs join countries ct on ct.country_id=cs.country_id
where ct.country_name='Canada' and cs.cust_city='Killarney';

select cs.cust_id, cs.cust_first_name, cs.cust_last_name, cs.cust_city , ct.country_name
from customers cs join countries ct on ct.country_id=cs.country_id
where cs.cust_city='Killarney';

