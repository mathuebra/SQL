



-- t1: saque total na 1
select * from eclbdit100.conta;
update eclbdit100.conta 
set saldo=0 where num=1;
select * from conta where num=1;


-- t3: rollback
rollback;




-- t5:
update eclbdit100.conta set saldo=0 where num=2;
select * from eclbdit100.conta where num=2;



-- t7:
select * from eclbdit100.conta where num=1;
update eclbdit100.conta set saldo=0 where num=1;
select * from eclbdit100.conta where num=2;
select * from eclbdit100.conta;
rollback;



