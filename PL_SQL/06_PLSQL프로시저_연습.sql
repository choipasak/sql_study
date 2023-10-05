/*
프로시저명 divisor_proc
숫자 하나를 전달받아 해당 값의 약수의 개수를 출력하는 프로시저를 선언합니다.
*/
CREATE OR REPLACE PROCEDURE divisor_proc
    (p_num IN NUMBER)
IS
    n_divisors NUMBER := 0;
BEGIN
    FOR i IN 1..p_num
    LOOP
        IF MOD(p_num, i) = 0 THEN
            n_divisors := n_divisors + 1;
        END IF;
    END LOOP;
    
    dbms_output.put_line(p_num || '의 약수의 개수: ' || n_divisors);
    
END;

EXEC divisor_proc(64565);


/*
부서번호, 부서명, 작업 flag(I: insert, U:update, D:delete)을 매개변수로 받아 
depts 테이블에 
각각 INSERT, UPDATE, DELETE 하는 depts_proc 란 이름의 프로시저를 만들어보자.
그리고 정상종료라면 commit, 예외라면 롤백 처리하도록 처리하세요.
*/
CREATE OR REPLACE PROCEDURE depts_proc
    (
    p_department_id IN depts.department_id%TYPE,
    p_department_name IN depts.department_name%TYPE,
    flag IN VARCHAR2
    )
IS
    v_cnt NUMBER := 0; -- department_id가 존재하는지를 보기 위해서 + 예외처리를 위해
BEGIN
    
    SELECT
        COUNT(*)
    INTO v_cnt
    FROM depts
    WHERE department_id = p_department_id;
    
    IF flag = 'I' THEN
        INSERT INTO depts (department_id, department_name)
        VALUES (p_department_id, p_department_name);
    ELSIF flag = 'U' THEN
        UPDATE depts
        SET department_id = p_department_id, department_name = p_department_name
        WHERE department_id = p_department_id;
    ELSIF flag = 'D' THEN
        -- 부서번호를 보냈는데 부서가 없을 경우엔 v_cnt로 판단해 부서가 없다고 말해줘야 함
        IF v_cnt = 0 THEN
            dbms_output.put_line('삭제하고자 하는 부서가 존재하지 않습니다.');
            return;
        END IF;
        
        DELETE FROM depts
        WHERE p_department_id = department_id;
    ELSE -- flag를 I, U, D 말고 다른 문자를 입력했을 때
        dbms_output.put_line('해당 flag에 대한 동작이 준비되지 않았습니다.');
    END IF;
    
    COMMIT;
    
    EXCEPTION
        WHEN OTHERS THEN -- 모든 에러 받기
            dbms_output.put_line('예외가 발생했습니다.');
            dbms_output.put_line('ERROR MSG: ' || SQLERRM);
            ROLLBACK; -- ERROR시 롤백
        
END;

EXEC depts_proc(700,'영업부','D');

SELECT * FROM depts;
/*
employee_id를 입력받아 employees에 존재하면,
근속년수를 out하는 프로시저를 작성하세요. (익명블록에서 프로시저를 실행)
없다면 exception처리하세요 -- select를 2번하면 예외가 안남, 
*/
CREATE OR REPLACE PROCEDURE hiring_proc
    (
    p_employee_id IN employees.employee_id%TYPE,
    p_hiring OUT NUMBER
    )
IS
    v_hiring_msg VARCHAR2(100);
    v_cnt NUMBER;
    v_hire_date DATE;
BEGIN
    SELECT
        COUNT(*)
    INTO v_cnt
    FROM employees
    WHERE p_employee_id = employee_id;
    
    SELECT
        hire_date
    INTO v_hire_date
    FROM employees
    WHERE p_employee_id = employee_id;
    
    IF v_cnt = 0 THEN
        dbms_output.put_line('존재하지 않는 사원번호 입니다.');
        return;
    ELSE
        p_hiring := TRUNC((sysdate - v_hire_date) / 365, 0);
    END IF;
    
    /*
    만약 호출부에서 employees테이블에 없는 사번을 호출하면 error: no data found
    에러가 터진다.
    그래서 이런 상황을 대비해서 exeption처리를 해라!
    없는 사번을 호출했을 경우를 예외 처리
    */
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(p_employee_id || '는 존재하지 않는 사원번호 입니다!');
            dbms_output.put_line('예외가 발생했습니다.');
            dbms_output.put_line('ERROR MSG: ' || SQLERRM);
            ROLLBACK; -- ERROR시 롤백
    
END;

DECLARE
    v_hiring NUMBER;
BEGIN
    hiring_proc(6486, v_hiring);
    dbms_output.put_line('근속년수는 ' || v_hiring || '년 입니다!');
END;

-- 선생님ver
CREATE OR REPLACE PROCEDURE hiring_proc
    (
    p_employee_id IN employees.employee_id%TYPE,
    p_year OUT NUMBER
    )
IS
    v_hire_date employees.hire_date%TYPE;
BEGIN
    SELECT
        hire_date
    INTO v_hire_date
    FROM employees
    WHERE p_employee_id = employee_id;
    
    p_year := TRUNC((sysdate - v_hire_date) / 365); -- TRUNC( , 0)여기서 ', 0'생략가능: 기본 값
    
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(p_employee_id || '는 존재하지 않는 사원번호 입니다!');
        ROLLBACK; -- ERROR시 롤백
        
END;

-- 호출
DECLARE
    v_year NUMBER;
BEGIN
    hiring_proc(576, v_year);
    dbms_output.put_line(v_year || '년');
    
END; -- 여기서 없는 사번을 호출하면 error: no data found
-- 그래서 이런 상황을 대비해서 exeption처리를 해라!
-- 없는 사번을 호출했을 경우를 예외 처리

/*
프로시저명 - new_emp_proc
employees 테이블의 복사 테이블 emps를 생성합니다.
employee_id, last_name, email, hire_date, job_id를 입력받아
존재하면 이름, 이메일, 입사일, 직업을 update, 
없다면 insert하는 merge문을 작성하세요

머지를 할 타겟 테이블 -> emps : emps에 수정하거나 INSERT하거나 하라는 의미
병합시킬 데이터 -> 프로시저로 전달받은 employee_id를 dual에 select 때려서 비교.
프로시저가 전달받아야 할 값: 사번, last_name, email, hire_date, job_id
*/
-- 단일 테이블 머지 문제임
-- 원래는 2개의 테이블을 머지하는 경우만 했었는데, 이번은 하나의 값과 테이블을 머지하는 방식이였다.
-- 그래서 하나의 값. 을 가지는 테이블을 당연히 dual테이블을 사용하는 것임
-- 병합을 해야할 것에 대한 어려움이 있었다!

CREATE OR REPLACE PROCEDURE new_emp_proc
    (
    p_employee_id IN employees.employee_id%TYPE,
    p_last_name IN employees.last_name%TYPE,
    p_email IN employees.email%TYPE,
    p_hire_date IN employees.hire_date%TYPE,
    p_job_id IN employees.job_id%TYPE
    )
IS
    -- v_cnt NUMBER;
BEGIN
    
    MERGE INTO emps a -- (머지를 할 타겟 테이블)의 별칭 a
    USING -- 병합시킬 데이터
        /*
        이 Merge문은 지금 프로시저 안에 있음
        근데 Merge문은 타겟 테이블에 병합시킬 테이블이 필요함
        그래서 프로시저로 넘어온 데이터를 테이블화 시켜주는 것임 -> dual이용
        => SELECT p_employee_id AS employee_id FROM dual
        : 프로시저를 통해 받은 데이터 p_employee_id를 dual에 SELECT를 이용해 넣어주겠다!
        dual의 정의? 도 검색해서 같이 작성해주기
        */
        (SELECT p_employee_id AS employee_id FROM dual) b -- 병합하고자 하는 데이터를 서브쿼리로 표현, 테이블 이름이 들어와도 된다.
    ON -- 병합시킬 데이터의 연결 조건
        (a.employee_id = b.employee_id) -- 이 조건을 통해 COUTN를 이용해서 작성했던 IF문이 필요가 없어짐. 이 조건이 true가 뜨면 UPDATE, false가 뜨면 INSERT가 진행된다.(= MERGE문을 사용한 이유)
        -- 전달받은 사번이 emps에 존재하는 지를 병합 조건으로 물어봄
    WHEN MATCHED THEN -- ON조건이 일치하는 경우에는 타겟 테이블에 이렇게 실행하라. 의 내용을 밑에 적어준다.
        UPDATE SET -- 수정할 값을 SET
            a.last_name = p_last_name,
            a.email = p_email,
            a.hire_date = p_hire_date,
            a.job_id = p_job_id
    WHEN NOT MATCHED THEN
        INSERT 
        (employee_id, last_name, email, hire_date, job_id)
        VALUES
        (p_employee_id, p_last_name, p_email, p_hire_date, p_job_id);
    
    /*
    
    SELECT
        COUNT(*)
    INTO v_cnt
    FROM emps
    WHERE employee_id = p_employee_id;
    
    IF v_cnt = 1 THEN -- 이렇게 IF문을 사용하지 않기 위해서 Merge문을 사용하는 것!!
        UPDATE emps
        SET
            last_name = p_last_name,
            email = p_email,
            hire_date = p_hire_date,
            job_id = p_job_id
        WHERE p_employee_id = employee_id;
    ELSE
        INSERT INTO 
    */
    
    
    
END;


EXEC new_emp_proc(100, 'merong', 'merong', sysdate, 'merong');


SELECT * FROM emps;

    
SELECT 120 AS employee_id FROM dual;
 
SELECT 7 FROM dual; -- dual테이블의 특징을 보기 위한 테스트
    
    
    
    
    
    
    
    
    
    