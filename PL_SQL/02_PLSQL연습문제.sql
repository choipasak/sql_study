
-- 1. employees 테이블에서 201번 사원의 이름과 이메일 주소를 출력하는
-- 익명블록을 만들어 보자. (변수에 담아서 출력하세요.)
DECLARE
    v_emp_name employees.first_name%TYPE;
    v_emp_email employees.email%TYPE;
BEGIN
    SELECT
        e.first_name, e.email
    INTO
        v_emp_name, v_emp_email -- 조회 결과를 변수에 대입 가능
    FROM employees e
    WHERE employee_id = 201;
    
    DBMS_OUTPUT.put_line(v_emp_name || ' - ' || v_emp_email);
    
END;

-- 2. employees 테이블에서 사원번호가 제일 큰 사원을 찾아낸 뒤 (MAX 함수 사용)
-- 이 번호 + 1번으로 아래의 사원을 emps 테이블에
-- employee_id, last_name, email, hire_date, job_id를 신규 삽입하는 익명 블록을 만드세요.
-- SELECT절 이후에 INSERT문 사용이 가능합니다.
/*
<사원명>: steven
<이메일>: stevenjobs
<입사일자>: 오늘날짜
<JOB_ID>: CEO
*/
DECLARE
    max_emp_id employees.employee_id%TYPE;
BEGIN
    SELECT
        MAX(employee_id)+1 AS employee_id
    INTO max_emp_id
    FROM employees;
    
    INSERT INTO emps
    VALUES(max_emp_id, 'steven', 'stevenjobs', sysdate, 'CEO');
    
END;

































