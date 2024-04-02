-- Exercício de Banco de Dados

--Alunos: Matheus Monteiro Huebra Perdigão
--        Letícia de Oliveira Soares

SELECT FIRST_NAME, LAST_NAME,
TO_CHAR(HIRE_DATE, 'DD-Month-YYYY') HIRE_MONTH,
TO_CHAR(HIRE_DATE, 'Month') HIRE_DATE
FROM EMPLOYEES
WHERE SUBSTR(LAST_NAME, 1, 1) = 'R';

SELECT CONCAT (E.FIRST_NAME, CONCAT(' ', E.LAST_NAME)), UPPER(D.DEPARTMENT_NAME) 
FROM EMPLOYEES E 
JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE SUBSTR(LOWER(D.DEPARTMENT_NAME), 1, 9) = 'executive';

SELECT 
    CONCAT(FIRST_NAME, CONCAT(' ', LAST_NAME)) AS FULL_NAME,
    TO_CHAR(HIRE_DATE, 'DD-Month-YYYY') AS HIRE_DATE
FROM EMPLOYEES
WHERE TO_CHAR(HIRE_DATE, 'YYYY') = '1999';

SELECT 
    CONCAT (FIRST_NAME, CONCAT(' ', LAST_NAME)) AS FULL_NAME,
    ROUND(SALARY/30) AS DAILY_SALARY,
    SALARY*12 AS ANUAL_SALARY
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT NULL;

SELECT 
    CONCAT (FIRST_NAME, CONCAT(' ', LAST_NAME)) AS FULL_NAME,
    SALARY AS MONTHLY_SALARY,
    SALARY + NVL((COMMISSION_PCT * SALARY), 0) AS COMISSION_SALARY
FROM EMPLOYEES;

SELECT 
    CONCAT(SUBSTR(E.FIRST_NAME, 1, 1), 
    CONCAT(' ', SUBSTR(E.LAST_NAME, 1, 1))) AS INICIAIS, 
    D.DEPARTMENT_NAME
FROM EMPLOYEES E 
JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE E.MANAGER_ID = D.MANAGER_ID AND E.MANAGER_ID IS NOT NULL;

SELECT 
    CONCAT(FIRST_NAME, CONCAT(' ', LAST_NAME)) AS FULL_NAME,
    ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)/12) AS YEARS_HIRED,
    ROUND(MOD(MONTHS_BETWEEN(SYSDATE, HIRE_DATE), 12)) AS MONTHS_HIRED
FROM EMPLOYEES;

SELECT 
    ROUND(AVG(E.SALARY)) AS AVERAGE_SALARY,
    MAX(E.SALARY) AS MAXIMUM_SALARY,
    MIN(E.SALARY) AS MINIMUM_SALARY,
    D.DEPARTMENT_NAME AS DEPARTMENT
FROM EMPLOYEES E
JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY DEPARTMENT_NAME;   

SELECT 
    COUNT(E.DEPARTMENT_ID) AS EMPLOYEE_NUMBER,
    D.DEPARTMENT_NAME AS DEPARTMENT
FROM EMPLOYEES E
JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE SUBSTR(JOB_ID, 4, 5) = 'CLERK'
GROUP BY DEPARTMENT_NAME;   