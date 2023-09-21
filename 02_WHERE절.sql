
SELECT * FROM employees;

-- WHERE절 비교 (데이터 값은 대/소문자를 구분합니다.)
SELECT first_name, last_name, job_id
FROM employees
WHERE job_id = 'IT_PROG'; -- job_id 가 'IT PROG'인 사람만 검색하는 조건

SELECT * FROM employees -- 2개의 데이터, 모든 컬럼 출력
WHERE last_name = 'King';

SELECT *
FROM employees
WHERE department_id = 90;

SELECT *
FROM employees
WHERE salary >= 15000
AND salary < 20000;

SELECT * FROM employees
WHERE hire_date = '04/01/30';

-- 데이터 행 제한
SELECT * FROM employees
WHERE salary BETWEEN 15000 AND 20000;

SELECT * FROM employees
WHERE hire_date BETWEEN '03/01/01' AND '03/12/31';

-- IN 연산자 사용 (특정 값들과 비교할 때 사용)
SELECT * FROM employees
WHERE manager_id IN (100,101,102); -- ()안에 해당하면 다 가져와!


SELECT * FROM employees
WHERE job_id IN ('IT_PROG', 'AD_VP'); -- ()안에 해당하면 다 가져와!

-- LIKE 연산자
-- %는 어떠한 문자든, _는 데이터의 자리(위치)를 찾아낼 때
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date LIKE '03%'; -- hire_date가 '03%'와 같다면(03%: 03으로 시작하는 문자 전부), 

SELECT first_name, hire_date
FROM employees
WHERE hire_date LIKE '%15'; -- '%15': 앞에 뭐가 들어오든 마지막이 15라면 다 불러와라

SELECT first_name, hire_date
FROM employees
WHERE hire_date LIKE '%05%'; -- 05의 앞 뒤에 문자가 오든 안오든 05가 문자열에 있으면(위치 상관X) 끌고와라!

-- 월의 자리에 내가 찾는 문자열이 포함되어 있는지
SELECT first_name, hire_date
FROM employees
WHERE hire_date LIKE '___05%'; -- _을 3개 붙여서 /포함 3자리 이후에(= 월이 05인) 05인 데이터를 조회하고 싶다

-- AND, OR
-- AND가 OR보다 연산 순서가 빠름.
SELECT * FROM employees
WHERE (job_id = 'IT_PROG'
OR job_id = 'FI_MGR')
AND salary >= 6000; -- 꼭 데이터 조회하고 확인 해주기!

-- 데이터의 정렬 (SELECT 구문의 가장 마지막에 배치됩니다.)
-- ASC: ascending 오름차순
-- DESC: descending 내림차순
SELECT * FROM employees
ORDER BY hire_date ASC; -- hire_date를 작은 값부터 큰값까지 순서대로 정렬해서 보여주세요

SELECT * FROM employees
ORDER BY hire_date DESC;

SELECT * FROM employees
ORDER BY hire_date;

SELECT * FROM employees
WHERE job_id = 'IT_PROG'-- 조회하고 나서
ORDER BY first_name ASC;-- 오름차순 정렬한다.

SELECT * FROM employees
WHERE salary >= 5000
ORDER BY employee_id DESC;

SELECT
    first_name,
    salary*12 AS pay
FROM employees
ORDER BY pay ASC;




