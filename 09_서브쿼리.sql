
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

-- WHERE절에 SUB QUERY문
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
-- ERROR: 단일행 서브쿼리 문장은 데이터 한개만 줘야하는데 서브 쿼리문이 1개 이상의 데이터가 제공되었다는 에러(job_id = 'IT_PROG' 조회 -> 5명)
-- 정리: 다음 문장은 서브쿼리가 리턴하는 행이 여러 개라서 단일행 연산자를 사용할 수 없습니다.
-- 단일 행 연산자: 주로 비교 연산자 (=, >, <, >=, <=, <>)를 사용하는 경우 하나의 행만 반환해야 합니다.
--> 서브쿼리문 앞에 job_id = 를 사용했기 때문에 1개의 데이터만 왔어야 했다.
-- 이런 경우에는 다중행 연산자를 사용해야 합니다.

-- 다중 행 연산자: (IN, ANY, ALL)
-- 1. IN: 조회된 목록의 어떤 값과 같은 지를 확인합니다.
SELECT job_id FROM employees
WHERE job_id IN (SELECT job_id FROM employees
                 WHERE job_id = 'IT_PROG');

-- first_name이 David인 사람들의 급여(4800, 9500, 6800)와 같은 급여를 받는 사람들을 조회.
SELECT first_name, salary FROM employees
WHERE salary IN (SELECT salary FROM employees
                 WHERE first_name = 'David');

-- ANY, SOME: 값을 서브쿼리에 의해 리턴된 각각의 값과 비교합니다.
-- 하나라도 만족하면 됩니다.
SELECT first_name, salary FROM employees
WHERE salary > ANY (SELECT salary FROM employees
                 WHERE first_name = 'David');

SELECT first_name, salary FROM employees
WHERE salary > SOME (SELECT salary FROM employees
                 WHERE first_name = 'David');


-- ALL: 값을 서브쿼리에 의해 리턴된 각각의 값과 모두 비교해서
-- 모두 만족해야 합니다.
SELECT first_name, salary FROM employees
WHERE salary > ALL (SELECT salary FROM employees
                 WHERE first_name = 'David');
                 -- 결과: 서브 쿼리문의 결과인 4800, 9500, 6800 중에 9500보다 salary가 큰 데이터만 조회!


-- EXISTS: 서브쿼리가 하나 이상의 행을 반환하면 참으로 간주.
-- job_history에서 employee_id를 통해 조회를 진행해보자!
SELECT * FROM employees e
WHERE EXISTS (SELECT 1 FROM job_history jh
              WHERE e.employee_id = jh.employee_id); -- 이건 JOIN처럼 서브쿼리문을 꾸민 것
-- 1이 서브 쿼리문 안의 내용에서 존재(EXIST)한다면 employees e에서 찾아서 조회하라!
-- 1을 찾는것은 그냥 상징적인 의미 -> 데이터는 궁금하지 않고 그냥 존재만 하는지를 조회하는 것이다.
--> 컬럼을 딱히 지칭할게 없을 때, 상징적으로 1을 지목하면 데이터의 개수만큼 조회된다!
--> 서브 쿼리문의 내용: job_history안에 데이터가 존재하면
--> 전체 해석: employees의 모든 컬럼을 다 조회하겠다!
-- 정리: job_history에 존재하는 직원이 employees에도 존재한다면 조회에 포함

-- EXIST 예시
SELECT * FROM employees
WHERE EXISTS (SELECT 1 FROM departments
              WHERE department_id = 80); -- 이건 그냥 서브 쿼리문의 리턴 값에 메인 쿼리문을 실행
-- 서브 쿼리문에서 참을 리턴 -> 메인 쿼리문 실행
-- 서브 쿼리문이 메인 쿼리문을 실행하는 참, 거짓의 조건이 된다.

--------------------------------------------------------------------------

-- SELECT 절에 서브 쿼리를 붙이기!
-- SELECT 문에서는 컬럼을 지목한다.
SELECT
    e.first_name,
    d.department_name
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id
ORDER BY first_name ASC;
-- 갑자기 LEFT JOIN 쿼리문을 작성한 이유
-- LEFT JOIN의 결과와 SELECT 절에서의 서브쿼리 사용의 결과가 많이 비슷하다.

-- SELECT절에 서브 쿼리 사용
-- 스칼라 서브쿼리 라고도 칭합니다.
-- 스칼라 서브쿼리: 실행 결과가 단일 값을 반환하는 서브쿼리. 주로 SELECT절이나, WHERE절에서 사용됨.
-- 대부분 SELECT절에 들어가는 서브쿼리를 스칼라 라고 함: 단일 행(하나만의 결과) 을 리턴하기 때문에
-- 게시판에서 사용함. 게시글 목록에서 게시글 제목 오른쪽에 댓글 개수같은 거 적혀있잖아 -> 스칼라 서브쿼리 사용
SELECT
    e.first_name,
    (
    SELECT
        department_name
    FROM departments d
    WHERE  d.department_id = e.department_id -- 이 조건으로 일치하는 데이터만 가져오겠다
    ) AS department_name -- FROM에 departments 테이블이 없어서 이렇게 작성!
FROM employees e
ORDER BY first_name ASC;
/*
실행순서: FROM절 
-> {e.first_name -> 한 행당 한번씩 서브 쿼리문이 실행된다(Kimberely가 NULL값을 가지고 있음: LEFT JOIN)}: 한 행씩 반복
first_name은 employees에서 조회된 것이고, 서브쿼리는 맞춰서 계속 반복 실행된 것이다.
*/

/*
- 스칼라 서브쿼리가 조인보다 좋은 경우
: 함수처럼 한 레코드당 정확히 하나의 값만을 리턴할 때.
ex) 해당 글의 댓글의 개수, 조회수.

- 조인이 스칼라 서브쿼리보다 좋은 경우
: 조회할 컬럼이나 데이터가 대용량인 경우, 해당 데이터가
수정, 삭제 등이 빈번한 경우(sql 가독성이 조인이 좀 더 뛰어납니다..)
아예 테이블을 합쳐서 끌고 올 데이터가 많다 -> LEFT JOIN
끌고 올 데이터가 많아지면 JOIN이 성능이 더 좋다..!
*/

-- 각 부서의 매니저 이름 조회
-- 1. LEFT JOIN
SELECT
    d.*,
    e.first_name
FROM departments d -- departments를 기준으로
LEFT JOIN employees e
ON d.manager_id = e.employee_id
ORDER BY d.manager_id ASC;
-- null: 매니저 아이디가 존재X -> 당연히 매니저 이름인 e.first_name도 존재X

-- 2. SELECT절 서브쿼리 (스칼라)
SELECT
    d.*,
    (
        SELECT
            first_name
        FROM employees e -- employees가 기준
        WHERE e.employee_id = d.manager_id -- d.manager_id의 값이 null인 값 -> manager_id도 null
    ) AS manager_name -- 스칼라 서브쿼리 사용
FROM departments d
ORDER BY d.manager_id ASC;

-- 2-1. 각 부서별 사원 수 뽑기
SELECT
    d.*,
    (
        SELECT
            COUNT(*) -- 같은 department_id의 개수
        FROM employees e -- 기준
        WHERE e.department_id = d.department_id -- department_id가 같으면!
        GROUP BY department_id -- COUNT의 기준
    ) AS 사원수
FROM departments d;
-- LEFT JOIN으로도 작성 가능!

----------------------------------------------------------------------------

-- FROM절에 붙이는 서브쿼리
-- 인라인 뷰 (FROM 구문에 서브쿼리가 오는 것.)
-- 특정 테이블 전체! 가 아니라, SELECT를 통해 일부 데이터를 조회한 것을 가상 테이블로 사용하고 싶을 때.
-- 실존하는 테이블에서 내가 원하는 데이터만 뽑아서 테이블로 쓰고 싶다 -> 인라인 뷰(가상 테이블)
-- 사용: 순번을 정해놓은 조회 자료를 범위를 지정해서 가지고 오는 경우.

-- salary를 범위를 지정해서 가져와 보자!
-- 근데 범위를 지정 -> 번호를 알아야 함 -> 번호를 붙여주는 ROWNUM
SELECT
    ROWNUM AS rn, employee_id, first_name, salary
FROM employees
ORDER BY salary DESC;
-- 결과: ROWNUM의 순서가 섞임.

-- salary로 정렬을 진행하면서 바로 ROWNUM을 붙이면
-- ROWNUM이 정렬이 되지 않는 상황이 발생합니다.
-- 이유: ROWNUM이 먼저 붙고 정렬이 진행되기 때문. ORDER BY는 항상 마지막에 진행.
-- 해결: 정렬이 미리 진행된 자료에 ROWNUM을 붙여서 다시 조회하는 것이 좋을 것 같아요.
SELECT
    ROWNUM AS rn, employee_id, first_name, salary
FROM employees
ORDER BY salary DESC;

SELECT ROWNUM AS rn, tb.*
FROM
    (
        SELECT
            employee_id, first_name, salary
        FROM employees
        ORDER BY salary DESC
    ) tb
WHERE rn > 0 AND rn <= 10; -- 범위 정하니 error: sql의 실행 순서 때문. rn의 존재를 WHERE에서는 모른다.
-- 해결: 쿼리문 전체를 다시 서브쿼리로 만든다.
-- 정리!
-- ROWNUM을 붙이고 나서 범위를 지정해서 조회하려고 하는데,
-- 범위 지정도 불가능하고, 지목할 수 없는 문제가 발생하더라.
-- 이유: WHERE절부터 먼저 실행하고 나서 ROWNUM이 SELECT 되기 때문에.
-- 해결: ROWNUM까지 붙여 놓고 다시 한 번 자료를 SELECT 해서 범위를 지정해야 되겠구나.

SELECT ROWNUM AS rn, tb.*
FROM
    (
        SELECT
            employee_id, first_name, salary
        FROM employees
        ORDER BY salary DESC
    ) tb
WHERE rn > 0 AND rn <= 10;

-- 3단 서브 쿼리문
SELECT *
FROM
    (
        SELECT ROWNUM AS rn, tb.*
        FROM
            (
                SELECT
                    employee_id, first_name, salary
                FROM employees
                ORDER BY salary DESC -- 1번으로 진행: RN을 달고 싶은 완성 내용
            ) tb -- 2번으로 진행: FROM절에 FROM절+스칼라 -> ERROR -> 다시 한번 스칼라화
    )
WHERE rn > 20 AND rn <= 30; -- 3번으로 진행: FROM절에 {RN을 달은 쿼리문을 스칼라화 시킨것} 작성.
-- 정리!
/*
가장 안쪽 SELECT 절에서 필요한 테이블 형식(인라인 뷰)을 생성.
바깥쪽 SELECT 절에서 ROWNUM을 붙여서 다시 조회
가장 바깥쪽 SELECT 절에서는 이미 붙어있는 ROWNUM의 범위를 지정해서 조회.

** SQL의 실행 순서(기억)
FROM -> (JOIN) -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY
*/
--> 언제 활용: 페이징. 번호가 안달린 게시글은 없음. 한 페이지에 게시글을 몇개 보여줄건지 에 사용 가능















