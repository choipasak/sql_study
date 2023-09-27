
-- insert
-- 테이블 구조 확인 (사실 sql delveloper를 사용하고 있기 때문에 필요 없지만)
DESC departments;
-- 널? = nullable
-- 그냥 테이블 클릭해서 보고 오는 것이 더 좋음

-- INSERT의 첫번째 방법
-- : 모든 컬럼 데이터를 한 번에 지정 가능
INSERT INTO departments
VALUES(300, '개발부',null,null); -- 원래의 컬럼 순서대로 지켜서 값 주입

SELECT * FROM departments;
ROLLBACK; -- INSERT한거 다 취소된다(커밋 전) / 실행 시점을 다시 커밋 전으로 되돌리는 키워드

-- INSERT의 두번째 방법 (직접 컬럼을 지정하고 저장, NOT NULL 꼭 확인하세요!)
INSERT INTO departments
    (department_id, department_name, location_id)
VALUES
    (290, '총무부', 1700);
-- 여기서 NOT NULL인 컬럼을 지정해주지 않는다면 ERROR


-- 사본 테이블 생성(CREATE TABLE AS - CTAS)
-- 사본 테이블을 생성할 때 그냥 생성하면 -> 조회된 데이터까지 모두 복사
CREATE TABLE emps AS
(SELECT employee_id, first_name, job_id, hire_date
FROM employees); -- 괄호 안의 내용대로 사본 테이블(emps)를 만들자!

SELECT * FROM emps;
DROP TABLE emps; -- 만든 가상테이블 삭제

-- 데이터는 안받고 싶고, 구조만 좀 따라하고 싶다.
-- WHERE절에 false값 (1 = 2) 지정하면 -> 테이블의 구조만 복사되고 데이터는 복사 X
CREATE TABLE emps AS
(SELECT employee_id, first_name, job_id, hire_date
FROM employees WHERE 1 = 2); -- WHERE 1 = 2: false를 뜻함. 오라클은 boolean이 없어서 저런 관용적 표현을 사용 함.
-- WHERE절에 false값을 주면 구조만 따온다!


-- INSERT (서브 쿼리 사용): 잘 사용 X
INSERT INTO emps
(SELECT employee_id, first_name, job_id, hire_date
FROM employees WHERE department_id = 50); -- 구조만 있는 emps에 employees의 모든 데이터 넣기

----------------------------------------------------------------------------------------------

-- UPDATE
CREATE TABLE emps AS
(SELECT * FROM employees);

-- UPDATE를 진행할 때는 누구를 수정할 지 잘 지목해야 합니다.
-- 그렇지 않으면 수정 대상이 테이블 전체로 지목됩니다.
UPDATE emps SET salary = 30000; -- 수정할 컬럼의 조건
ROLLBACK;

-- 대상 지정한 경우
UPDATE emps SET salary = 30000
WHERE employee_id = 100; -- 누구를 수정할건지
-- 만약 누구를 수정할지 지정하지 않는다면(WHERE) 모든 salary가 다 바뀐다.

SELECT * FROM emps;

-- 수정할 값을 컬럼명으로도 가능하다.
UPDATE emps SET salary = salary + salary * 0.1
WHERE employee_id = 100;

-- 수정할 값 2개 지정
UPDATE emps
SET phone_number = '010.4742.8917', manager_id = 102 -- 더 있다면 , 하고 더 작성하면 된다.
WHERE employee_id = 100;

-- UPDATE (서브 쿼리 사용)
-- 조회한 내용으로 수정하겠다!(유용)
UPDATE emps
    SET (job_id, salary, manager_id) =
    (
        SELECT job_id, salary, manager_id
        FROM emps
        WHERE employee_id = 100
    ) -- employee_id = 100인 사람의 SELECT절 조건을 조회해서
WHERE employee_id = 101; -- employee_id = 101인 사람에게 데이터를 SET하겠다.

----------------------------------------------------------------------------------

-- DELETE
DELETE FROM emps; --> 조건이 없어서 다 지워짐.
ROLLBACK;

DELETE FROM emps
WHERE employee_id = 103;

SELECT * FROM emps;

-- 가장 실수 많이 하는 형태
DELETE * FROM emps
WHERE employee_id = 103; -- 컬럼을 지정할 필요가 없음: 한 행을 다 지우기 때문

-- DELETE (서브 쿼리 사용)
DELETE FROM emps
WHERE department_id = (SELECT department_id FROM departments
                       WHERE department_name = 'IT');






