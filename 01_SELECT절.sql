
-- 오라클의 한 줄 주석입니다.

/*
여러 줄 주석입니다.
호뵤
*/

-- SELECT [컬럼명(여러 개 가능)] FROM [테이블 이름]
SELECT * FROM employees; -- *: employees에서 모든 컬럼 다 보여줘

SELECT employee_id, first_name, last_name
FROM employees;

SELECT email, phone_number, hire_date
FROM employees;

-- 컬럼을 조회하는 위치에서 * / + - 연산이 가능합니다.
SELECT 
    employee_id,
    first_name,
    last_name,
    salary,
    salary + salary*0.1 AS 성과금
FROM employees;

-- NULL값의 확인 (숫자 0이나 공백이랑은 다른 존재입니다.)
SELECT department_id, commission_pct
FROM employees;
-- null이 들어있으면 연산 불가능
-- 값이 존재하지 않는 것이다.

-- alias, as(alias의 줄임말) (컬럼명, 테이블명의 이름을 변경해서 조회합니다.)
SELECT
    first_name AS 이름,
    last_name AS 성,
    salary AS 급여
FROM employees;

/*
    오라클은 홑따옴표로 문자를 표현하고, 문자열 안에 홑따옴표를
    표현하고 싶다면 ''를 두 번 연속으로 쓰시면 됩니다.
    문장을 연결하고 싶다면 || 를 사용합니다.
*/
--오라클은 문자열의 덧셈연산을 지원하지 않는다. -> || 사용

SELECT
    -- first_name + ' ' + last_name과 같음
    first_name || ' ' || last_name || '''s salary is $' || salary
    AS 급여내역
FROM employees;

SELECT department_id FROM employees;

-- 조회 결과에 중복을 제거해서 조회해주고 싶다
-- DISTINCT (중복 행 제거)
SELECT DISTINCT department_id FROM employees;

-- ROWNUM, ROWID
-- (**로우넘: 쿼리에 의해 반환되는 행 번호를 출력. 조회된 결과의 번호를 붙임. 행 번호와는 다르다.)
-- (**로우아이디: 데이터베이스 내의 행의 주소를 반환. 저장되어 있는 메모리의 주소 값)
-- 실제로 눈에 보이진 않지만 조회해서 볼 수 있음
-- 조회된 결과의 번호를 붙이기 때문에 중간의 ROWNUM이 삭제가 되어도 
-- 번호와 ROW의 수가 맞지 않게 되는 결과를 막을 수 있다.
SELECT ROWNUM, ROWID, employee_id
FROM employees;


















