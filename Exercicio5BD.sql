-- Nome: Matheus Monteiro Huebra Perdigão
--       Letícia de Oliveira Soares

-- Questão 1

SELECT C.NAME AS NOME, SUM(O.TOTAL) AS TOTAL_PEDIDOS
FROM CUSTOMER C 
JOIN ORD O ON C.CUSTID = O.CUSTID
GROUP BY C.NAME;

/*
1   'JOCKSPORTS', 5280.9
2   'VOLLYRITE', 27775.5
3   'JUST TENNIS', 764
4   'TKB SPORT SHOP', 101.4
5   'NORTH WOODS HEALTH AND FITNESS SUPPLY CENTER', 6400
6   'SHAPE UP', 9024.4
7   'EVERY MOUNTAIN', 7160.8
8   'WOMENS SPORTS', 710
9   'K + T SPORTS', 46370
*/


-- Questão 2

SELECT P.DESCRIP AS PRODUTO_DESCRICAO, SUM(I.QTY) AS QUANTIDADE_PEDIDA
FROM PRODUCT P
JOIN ITEM I ON P.PRODID = I.PRODID
GROUP BY P.DESCRIP;

/*
1   'ACE TENNIS NET', 512
2   'ACE TENNIS BALLS-3 PACK', 2288
3   'SP JUNIOR RACKET', 450
4   'SP TENNIS RACKET', 351
5   'SB VITA SNACK-6 PACK', 550
6   'ACE TENNIS RACKET I', 642
7   'ACE TENNIS RACKET II', 298
8   'SB ENERGY BAR-6 PACK', 1511
9   'RH: GUIDE TO TENNIS', 721
10  'ACE TENNIS BALLS-6 PACK', 1803
*/

-- Questão 3

SELECT P.DESCRIP AS PRODUTO_DESCRICAO, SUM(I.QTY) AS QUANTIDADE_PEDIDA
FROM PRODUCT P
JOIN ITEM I ON P.PRODID = I.PRODID
GROUP BY P.DESCRIP
ORDER BY QUANTIDADE_PEDIDA DESC;

/*
1   'ACE TENNIS BALLS-3 PACK', 2288
2   'ACE TENNIS BALLS-6 PACK', 1803
3   'SB ENERGY BAR-6 PACK', 1511
4   'RH: GUIDE TO TENNIS', 721
5   'ACE TENNIS RACKET I', 642
6   'SB VITA SNACK-6 PACK', 550
7   'ACE TENNIS NET', 512
8   'SP JUNIOR RACKET', 450
9   'SP TENNIS RACKET', 351
10  'ACE TENNIS RACKET II', 298
*/

-- Questão 4

SELECT E.ENAME AS NOME_VENDEDOR, SUM(O.TOTAL) AS TOTAL_PEDIDOS
FROM EMP E
JOIN CUSTOMER C ON E.EMPNO = C.REPID
JOIN ORD O ON C.CUSTID = O.CUSTID
GROUP BY E.ENAME
ORDER BY TOTAL_PEDIDOS DESC;

/*
1   'TURNER', 58050.9
2   'MARTIN', 27775.5
3   'WARD', 9889.8
4   'ALLEN', 7870.8
*/

-- Questão 5

SELECT C.CITY AS CIDADE, SUM(O.TOTAL) AS TOTAL_PEDIDOS, ROUND(AVG(O.TOTAL))
FROM CUSTOMER C
JOIN ORD O ON C.CUSTID = O.CUSTID
GROUP BY C.CITY;

/*
1   'PALO ALTO', 9024.4, 3008.133333333333333333333333333333333333
2   'SANTA CLARA', 46370, 46370
3   'HIBBING', 6400, 6400
4   'CUPERTINO', 7160.8, 1790.2
5   'REDWOOD CITY', 101.4, 101.4
6   'BURLINGAME', 28539.5, 4756.583333333333333333333333333333333333
7   'SUNNYVALE', 710, 710
8   'BELMONT', 5280.9, 1320.225
*/

-- Questão 6

SELECT MGR.ENAME AS GERENTE, SUM(O.TOTAL) AS TOTAL_PEDIDOS
FROM EMP E
JOIN CUSTOMER C ON E.EMPNO = C.REPID
JOIN ORD O ON C.CUSTID = O.CUSTID
JOIN EMP MGR ON E.MGR = MGR.EMPNO
GROUP BY MGR.ENAME;

/*
'BLAKE', 103587
*/
