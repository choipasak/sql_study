
/*
view는 제한적인 자료만 보기 위해 사용하는 가상 테이블의 개념입니다.
뷰는 기본 테이블로 유도된 가상 테이블이기 때문에
필요한 컬럼만 저장해 두면 관리가 용이해 집니다.
뷰는 가상테이블로 실제 데이터가 물리적으로 저장된 형태는 아닙니다.
뷰를 통해서 데이터에 접근하면 원본 데이터는 안전하게 보호될 수 있습니다.
*/

/*
DB에 저장 -> 하드디스크에 table_space라는 형태로 물리적으로 저장함
근데 뷰는 아님. 따로 파일 형태로 저장되진 않음.
table과는 좀 다르다
*/

-- 뷰를 만드려면 권한이 있어야함
SELECT * FROM user_sys_privs; -- 여기에 CREATE VIEW가 있어야함!

-- 뷰의 종류: 단순뷰, 복합뷰
-- 단순 뷰: 하나의 테이블을 이용하여 생성한 뷰
-- 뷰의 컬럼 이름은 함수 호출문, 연산식 등 같은 가상 표현식이면 안됩니다. 반드시 별칭을 붙여줘야 합니다.
-- 원하는 컬럼만 뽑아내보자!
SELECT 
    employee_id,
    first_name || ' ' || last_name,
    job_id,
    salary
FROM employees
WHERE department_id = 60;
-- 얘네만 필요한데, 필요할 때마다 작성해서 사용할 순 없으니 위의 쿼리문을 가상 테이블로 만들자!
CREATE VIEW view_emp AS (
SELECT 
    employee_id,
    first_name || ' ' || last_name AS full_name,
    job_id,
    salary
FROM employees
WHERE department_id = 60
); -- error: must name this expression with a column alias -> SELECT절 2번째 조건에 별칭 달아라

SELECT * FROM view_emp
WHERE salary >= 6000;

-- 복합 뷰
-- 여러 테이블을 조인하여 필요한 데이터만 저장하고 빠른 확인을 위해 사용.
-- 자주 사용하는 조인의 결과를 뷰로 만든거임!
CREATE VIEW view_dept_jobs AS (
    SELECT
        e.employee_id,
        e.first_name || ' ' || e.last_name AS full_name,
        d.department_name,
        j.job_title
    FROM employees e
    LEFT JOIN departments d
    ON e.department_id = d.department_id
    LEFT JOIN jobs j
    ON e.job_id = j.job_id
)
ORDER BY employee_id;

SELECT * FROM view_dept_jobs;

-- 만약, 컬럼 하나를 빼먹 -> 뷰 수정
-- 뷰의 수정 (CREATE OR REPLACE VIEW 구문)
-- : 동일 이름으로 해당 구문을 사용하면 데이터가 변경되면서 새롭게 생성됩니다.
-- CREATE VIEW view_dept_jobs AS -> CREATE OR REPLACE VIEW view_dept_jobs AS로 바꿔서 똑같이 작성하여 실행하면 된다!
CREATE OR REPLACE VIEW view_dept_jobs AS (
    SELECT
        e.employee_id,
        e.first_name || ' ' || e.last_name AS full_name,
        d.department_name,
        j.job_title,
        e.salary -- 추가 된 컬럼
    FROM employees e
    LEFT JOIN departments d
    ON e.department_id = d.department_id
    LEFT JOIN jobs j
    ON e.job_id = j.job_id
)
ORDER BY employee_id;

SELECT
    job_title,
    AVG(salary) AS avg
FROM view_dept_jobs
GROUP BY job_title
ORDER BY AVG(salary) DESC; -- SQL 구문이 확실히 짧아짐.

-- 뷰 삭제
DROP VIEW view_emp;

-- 그냥 테이블 쓰면 안되나요
-- 뷰는 가상테이블임. 수정도 삭제도 생성도 쉽고 실제 테이블보다 엄격하지가 않음.
-- 테이블은 조회하는 것도 빡셈
-- 다른 사람에게 노출하면 안되는 테이블을 뷰로 보여 줄 수 있는 정보만 빼서 전달해 줄 수도 있음
-- 그리고 뷰는 읽기전용으로도 설정이 가능함.
/*
VIEW의 INSERT가 일어나는 경우, 실제 테이블에도 반영이 됩니다.
그래서 VIEW의 INSERT, UPDATE, DELET는 많은 제약 사항이 따릅니다.
원본 테이블이 NOT NULL인 경우 VIEW에 INSERT가 불가능합니다.
VIEW에서 사용하는 컬럼이 가상 열인 경우에도 안됩니다.
*/

INSERT INTO view_dept_jobs
VALUES(300, 'test', 'test', 'test', 10000); -- error: virtual column not allowed here
-- view_dept_jobs에서 SELECT절의 2번째 조건이 가상 열임.(별칭)
-- full_name이 가상열(virtual column)이기 때문에 INSERT 불가

-- 그럼 가상열 빼고 INSERT 시도
INSERT INTO view_dept_jobs
(employee_id, department_name, job_title, salary)
VALUES(300, 'test', 'test', 'test', 10000); -- error:
-- 여러개가 조인된 복합 뷰는 INSERT가 정말 까다로움
-- 정리: JOIN된 뷰의 경우 한 번에 수정을 할 수 없습니다.

-- JOIN된 뷰의 경우라고 했으니까 단일 뷰도 포함
-- 원본 테이블의 null을 허용하지 않는 컬럼 때문에 들어갈 수 없습니다.
INSERT INTO view_emp
(employee_id, job_id, salary)
VALUES(300, 'test', 10000); -- error: cannot insert NULL into ("HR"."EMPLOYEES"."LAST_NAME")
-- error: LAST_NAME컬럼에는 값 안 넣니?
-- 그래도 단일뷰가 복합뷰보다는 삽입, 수정, 삭제가 더 편한 편이다.
DELETE FROM view_emp
WHERE employee_id = 103; -- error: child record found -> employee_id = 103을 누가 참조하고 있어서 불가능

-- 다른 id로 시도
-- 삽입, 수정, 삭제 성공 시 원본 테이블도 반영됩니다.
DELETE FROM view_emp
WHERE employee_id = 107; -- 성공

SELECT * FROM view_emp; -- 성공적으로 107번 날라감
SELECT * FROM employees; -- 근데 원본 테이블인 employees에서도 107번이 날라감
ROLLBACK;

-- view의 장점: 민감한 정보와 데이터의 보안, 접근에 안전하고, 쿼리문도 단축할 수 있다!

-- view의 옵션
-- WITH CHECK OPTION -> 조건 제약 컬럼
-- : 뷰를 생성할 때 사용한 조건 컬럼은 뷰를 통해서 변경할 수 없게 해주는 키워드
CREATE VIEW view_emp_test AS (
    SELECT 
        employee_id,
        first_name,
        last_name,
        email,
        hire_date,
        job_id,
        department_id
    FROM employees
    WHERE department_id = 60
);

UPDATE view_emp_test
SET department_id = 100
WHERE employee_id = 107; -- 뷰 생성할때의 WHERE절을 바꿈

SELECT * FROM view_emp_test; -- 성공

ROLLBACK;

-- 기존의 뷰의 WHERE절을 바꾸지 못하게 하고 싶다.
CREATE OR REPLACE VIEW view_emp_test AS (
    SELECT 
        employee_id,
        first_name,
        last_name,
        email,
        hire_date,
        job_id,
        department_id
    FROM employees
    WHERE department_id = 60
)
WITH CHECK OPTION CONSTRAINT view_emp_test_ck;
-- WHERE절 변경 막고 다시 UPDATE
UPDATE view_emp_test
SET department_id = 100
WHERE employee_id = 107; -- error

-- 그럼 다른 컬럼 변경은 가능?
UPDATE view_emp_test
SET job_id = 'AD_VP'
WHERE employee_id = 107; -- 성공~

-- 뷰를 읽기 전용으로 만들기 -> WITH READ ONLY (DML 연산을 막음 -> SELECT만 허용)
CREATE OR REPLACE VIEW view_emp_test AS (
    SELECT 
        employee_id,
        first_name,
        last_name,
        email,
        hire_date,
        job_id,
        department_id
    FROM employees
    WHERE department_id = 60
)
WITH READ ONLY; -- 결과: 모든 컬럼 수정 막힘




