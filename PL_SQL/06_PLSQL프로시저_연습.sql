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

EXEC depts_proc(300,'영업부','U');

SELECT * FROM depts;
/*
employee_id를 입력받아 employees에 존재하면,
근속년수를 out하는 프로시저를 작성하세요. (익명블록에서 프로시저를 실행)
없다면 exception처리하세요
*/


/*
프로시저명 - new_emp_proc
employees 테이블의 복사 테이블 emps를 생성합니다.
employee_id, last_name, email, hire_date, job_id를 입력받아
존재하면 이름, 이메일, 입사일, 직업을 update, 
없다면 insert하는 merge문을 작성하세요

머지를 할 타겟 테이블 -> emps
병합시킬 데이터 -> 프로시저로 전달받은 employee_id를 dual에 select 때려서 비교.
프로시저가 전달받아야 할 값: 사번, last_name, email, hire_date, job_id
*/