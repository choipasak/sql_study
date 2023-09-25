
/*
서브란?
- 하위의 개념

서브쿼리 요약
- 어디에나 들어갈 수 있음(WHERE, SELECT(COLUMN), TABLE)
- 쿼리문을 작성하기 위해 필요한 정보검색 쿼리문을 WHERE절에 그냥 같이 조건으로 달고 싶다.
- 조회된 결과를 바탕으로 쿼리문을 작성할고 싶을 때
- 조회된 결과가 어디에 필요한지에 따라 작성하는 위치가 다름

-------------------------------------------------------

! 결론 !

# 서브쿼리 
: SQL 문장 안에 또 다른 SQL을 포함하는 방식.
여러 개의 질의를 동시에 처리할 수 있습니다.
WHERE, SELECT, FROM 절에 작성이 가능합니다.

- 서브쿼리의 사용방법은 () 안에 명시함.
 서브쿼리절의 리턴행이 1줄 이하여야 합니다.
- 서브쿼리 절에는 비교할 대상이 하나 반드시 들어가야 합니다.
- 해석할 때는 서브쿼리절 부터 먼저 해석하면 됩니다.
*/

SELECT salary FROM employees
WHERE first_name = 'Nancy';

SELECT first_name FROM employees
WHERE salary > '12008';
-- 'Nancy'의 급여보다 급여가 많은 사람을 검색하는 문장.

SELECT first_name FROM employees
WHERE salary > (SELECT salary FROM employees
                WHERE first_name = 'Nancy');

-- employee_id가 103번인 사람의 job_id와 동일한 job_id를 가진 사람을 조회.
SELECT * FROM employees
WHERE job_id = (SELECT job_id FROM employees
                WHERE employee_id = 103);
-- 서브쿼리문은 안쪽의 쿼리문이 먼저 완성이 된다.
-- 작성 방법도 서브쿼리문작성 -> 자르기 -> 외부조건쿼리문 -> WHERE절에 서브쿼리문 복붙.

SELECT * FROM employees
WHERE job_id = (SELECT job_id FROM employees
                WHERE job_id = 'IT_PROG'); -- ERROR: single-row subquery returns more than one row
-- ERROR: 단일행 서브쿼리 문장은 데이터 한개만 줘야하는데 1개 이상의 데이터가 제공되었다는 에러(job_id = 'IT_PROG' 조회 -> 5명)
-- 정리: 다음 문장은 서브쿼리가 리턴하는 행이 여러 개라서 단일행 연산자를 사용할 수 없습니다.
-- 단일 행 연산자: 주로 비교 연산자 (=, >, <, >=, <=, <>)를 사용하는 경우 하나의 행만 반환해야 합니다.
--> 서브쿼리문 앞에 job_id = 를 사용했기 때문에 1개의 데이터만 왔어야 했다.
-- 이런 경우에는 다중행 연산자를 사용해야 합니다.

-- 다중 행 연산자: (IN, ANY, ALL)
-- 1. IN: 조회된 목록의 어떤 값과 같은 지를 확인합니다.
SELECT * FROM employees
WHERE job_id IN (SELECT job_id FROM employees
                 WHERE job_id = 'IT_PROG');

-- first_name이 David인 사람들의 급여(4800, 9500, 6800)와 같은 급여를 받는 사람들을 조회.
SELECT * FROM employees
WHERE salary IN (SELECT salary FROM employees
                 WHERE first_name = 'David');



























