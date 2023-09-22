
-- 집합 연산자
-- 서로 다른 쿼리 결과의 행들을 하나로 결합, 비교, 차이를 구할 수 있게 해 주는 연산자
-- UNION(합집합 중복X), UNION ALL(합집합 중복 O), INTERSECT(교집합), MINUS(차집합)
-- 위 아래 column 개수와 데이터 타입이 정확히 일치해야 합니다.

-- UNION(합집합 중복X)
SELECT
    employee_id, first_name
FROM employees
WHERE hire_date LIKE '04%'
UNION -- 위 아래의 조건을 합친다.
SELECT
    employee_id, first_name
FROM employees
WHERE department_id = 20;

-- UNION ALL(합집합 중복 O)
SELECT
    employee_id, first_name
FROM employees
WHERE hire_date LIKE '04%'
UNION ALL
SELECT
    employee_id, first_name
FROM employees
WHERE department_id = 20;

-- INTERSECT(교집합)
SELECT
    employee_id, first_name
FROM employees
WHERE hire_date LIKE '04%'
INTERSECT
SELECT
    employee_id, first_name
FROM employees
WHERE department_id = 20;

-- MINUS(차집합): A - B
SELECT -- A
    employee_id, first_name
FROM employees
WHERE hire_date LIKE '04%'
MINUS
SELECT -- B
    employee_id, first_name
FROM employees
WHERE department_id = 20;

-- MINUS(차집합): B - A
SELECT -- B
    employee_id, first_name
FROM employees
WHERE department_id = 20
MINUS
SELECT -- A
    employee_id, first_name
FROM employees
WHERE hire_date LIKE '04%'
-- MINUS는 SELECT조건이 일치해야 한다.
