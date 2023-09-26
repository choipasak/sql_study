
-- MERGE: 테이블 병합

/*
UPDATE와 INSERT를 한 방에 처리 가능.

한 테이블에 해당하는 데이터가 있다면 UPDATE를,
없으면 INSERT로 처리해라. -> MERGE라는 키워드로 명령을 내릴 수 있음
*/

CREATE TABLE emps_it AS (SELECT * FROM employees WHERE 1 = 2);

INSERT INTO emps_it
    (employee_id, first_name, last_name, email, hire_date, job_id)
VALUES
    (105, '춘배', '김', 'chunbae', sysdate, 'IT_PROG');
-- 2개의 데이터를 emps_it를 넣었음

SELECT * FROM emps_it;

SELECT * FROM employees
WHERE job_id = 'IT_PROG'; -- 의 데이터 5개를 emps_it에 넣어주려고 조회 함.
-- 근데 employees를 조회하니 105번, 106이 중복되는 것을 볼 수 있음
-- 그래서 이미 존재하는 데이터는 update가 되고, 없는 데이터는 insert가 됬으면 좋겠어 -> MERGE

MERGE INTO emps_it a -- (머지를 할 타겟 테이블)의 별칭 a
    USING -- 병합시킬 데이터
        (SELECT * FROM employees
         WHERE job_id = 'IT_PROG') b -- 병합하고자 하는 데이터를 서브쿼리로 표현, 테이블 이름이 들어와도 된다.
    ON -- 병합시킬 데이터의 연결 조건
        (a.employee_id = b.employee_id) -- 조건. 조건일 경우에
WHEN MATCHED THEN -- ON조건이 일치하는 경우에는 타겟 테이블에 이렇게 실행하라. 의 내용을 밑에 적어준다.
    UPDATE SET -- 수정할 값을 SET
        a.phone_number = b.phone_number,
        a.hire_date = b.hire_date,
        a.salary = b.salary,
        a.commission_pct = b.commission_pct,
        a.manager_id = b.manager_id,
        a.department_id = b.department_id
WHEN NOT MATCHED THEN
    INSERT /*속성(컬럼)이 들어감*/ VALUES
    (b.employee_id, b.first_name, b.last_name,
    b.email, b.phone_number, b.hire_date, b.job_id,
    b.salary, b.commission_pct, b.manager_id, b.department_id);

-- merge 왜 써요
/*
실무에선,
실제로 사용자 요청에 반응하는 테이블이 있고, 이거의 백업 테이블들이 있음.
시간이 지나서 백업 테이블들과 실시간테이블을 맞춰줄 때 사용한다.
*/

--------------------------------------------------------------------------

-- 더미 데이터
INSERT INTO emps_it
    (employee_id, first_name, last_name, email, hire_date, job_id)
VALUES(102, '렉스', '박', 'LEXPARK', '01/04/06', 'AD_VP');
INSERT INTO emps_it
    (employee_id, first_name, last_name, email, hire_date, job_id)
VALUES(101, '니나', '최', 'NINA', '20/04/06', 'AD_VP');
INSERT INTO emps_it
    (employee_id, first_name, last_name, email, hire_date, job_id)
VALUES(103, '흥민', '손', 'HMSON', '20/04/06', 'AD_VP');

SELECT * FROM emps_it;

/*
employees 테이블을 매번 빈번하게 수정되는 테이블이라고 가정하자.
기존의 데이터는 email, phone, salary, comm_pct, man_id, dept_id을
업데이트 하도록 처리
새로 유입된 데이터는 그대로 추가.
*/

MERGE INTO emps_it a
    USING
        (SELECT * FROM employees) b
    ON
        (a.employee_id = b.employee_id)
WHEN MATCHED THEN
    UPDATE SET
        a.email = b.email,
        a.phone_number = b.phone_number,
        a.salary = b.salary,
        a.commission_pct = b.commission_pct,
        a.manager_id = b.manager_id,
        a.department_id = b.department_id
WHEN NOT MATCHED THEN
    INSERT VALUES
    (b.employee_id, b.first_name, b.last_name,
    b.email, b.phone_number, b.hire_date, b.job_id,
    b.salary, b.commission_pct, b.manager_id, b.department_id); -- 기존의 데이터는 남고 나머지의 데이터는 추가된다.

SELECT * FROM emps_it
ORDER BY employee_id ASC;

ROLLBACK;

-- 그럼 DELETE도 껴주나요?
MERGE INTO emps_it a
    USING
        (SELECT * FROM employees
         WHERE job_id = 'IT_PROG') b
    ON 
        (a.employee_id = b.employee_id)
WHEN MATCHED THEN
    UPDATE SET
        a.phone_number = b.phone_number,
        a.hire_date = b.hire_date,
        a.salary = b.salary,
        a.commission_pct = b.commission_pct,
        a.manager_id = b.manager_id,
        a.department_id = b.department_id
        
         /*
        DELETE만 단독으로 쓸 수는 없습니다.
        UPDATE 이후에 DELETE 작성이 가능합니다.
        UPDATE 된 대상을 DELETE 하도록 설계되어 있기 때문에
        삭제할 대상 컬럼들을 동일한 값으로 일단 UPDATE를 진행하고
        DELETE의 WHERE절에 아까 지정한 동일한 값을 지정해서 삭제합니다.
        */
    DELETE
        WHERE a.employee_id = b.employee_id
        
WHEN NOT MATCHED THEN
    INSERT /*속성(컬럼)이 들어감*/ VALUES
    (b.employee_id, b.first_name, b.last_name,
    b.email, b.phone_number, b.hire_date, b.job_id,
    b.salary, b.commission_pct, b.manager_id, b.department_id);

CREATE TABLE DEPTS AS (SELECT * FROM departments);

SELECT * FROM DEPTS;

INSERT INTO DEPTS
    VALUES(320, '영업', 303, 1700);

-- 2번
UPDATE DEPTS
SET department_name = 'IT bank'
WHERE department_name = 'IT Support';

UPDATE DEPTS
SET manager_id = 301
WHERE department_id = 290;

UPDATE DEPTS
SET department_name = 'IT Help', manager_id = 303, location_id = 1800
WHERE department_name = 'IT Helpdesk';

UPDATE DEPTS
SET manager_id = 301
WHERE department_id >= 290;

-- 3번
DELETE FROM DEPTS
WHERE department_id = 320;

SELECT * FROM DEPTS;

DELETE FROM DEPTS
WHERE department_id = 220;

-- 4번
-- 먼저 사본 테이블 만들기
CREATE TABLE DEPTSCOPY AS (SELECT * FROM DEPTS);

SELECT * FROM DEPTSCOPY;

DELETE FROM DEPTSCOPY
WHERE department_id > 200;

UPDATE DEPTSCOPY
SET manager_id = 100
WHERE manager_id IS NOT NULL;

UPDATE DEPTSCOPY
SET department_id = 110
WHERE department_name = 'Accounting';

SELECT * FROM DEPTSCOPY;

MERGE INTO DEPTS d -- (머지를 할 타겟 테이블)의 별칭 a
    USING -- 병합시킬 데이터
        (SELECT * FROM departments) dp -- 병합하고자 하는 데이터를 서브쿼리로 표현, 테이블 이름이 들어와도 된다.
    ON -- 병합시킬 데이터의 연결 조건
        (d.department_id = dp.department_id) -- 조건, 조건일 경우에
WHEN MATCHED THEN -- ON조건이 일치하는 경우에는 타겟 테이블에 이렇게 실행하라. 의 내용을 밑에 적어준다.
    UPDATE SET -- 수정할 값을 SET
        d.department_name = dp.department_name,
        d.manager_id = dp.manager_id,
        d.location_id = dp.location_id
WHEN NOT MATCHED THEN
    INSERT /*속성(컬럼)이 들어감*/ VALUES
    (dp.department_id, dp.department_name, dp.manager_id, dp.location_id);

SELECT * FROM DEPTS;

CREATE TABLE jobs_it AS (SELECT * FROM JOBS);

SELECT * FROM jobs_it;

INSERT INTO jobs_it
    VALUES('SEC_DEV', '보안개발팀', 6000, 19000);

MERGE INTO jobs_it ji
    USING
        (SELECT * FROM jobs) j
    ON
        (j.min_salary > 0)
WHEN MATCHED THEN
    ji.min_salary = j.min_salary,
    ji.max_salary = j.max_salary






