
-- 프로시저(procedure) -> void 메서드 유사
-- 특정한 로직을 처리하고 결과값을 반환하지 않는 코드 덩어리 (쿼리)
-- 하지만 프로시저를 통해서 값을 리턴하는 방법도 있습니다.
-- 익명함수가 아님 -> 함수를 만들고 필요할 때마다 호출하는 방법
CREATE PROCEDURE guguproc -- PROCEDURE을 호출할 수 있는 이름
    (p_dan IN NUMBER) -- 매개변수(p_dan에 NUMBER타입이 IN(들어온다))
IS -- 선언부
    -- 간단 구구단이여서 선언할 것이 없음
BEGIN -- 실행부
    dbms_output.put_line(p_dan || '단');
    FOR i IN 1..9
    LOOP
        dbms_output.put_line(p_dan || 'x' || i || '=' || p_dan*i);
    END LOOP;
END; -- 종료부

-- 프로시저 호출
EXEC guguproc(14);

-- 매개값(인수) 없는 프로시저
CREATE PROCEDURE p_test
IS -- 선언부
    v_msg VARCHAR2(30) := 'Hello Procedure!';
BEGIN -- 실행부
    dbms_output.put_line(v_msg);
END; -- 종료부

EXEC p_test; -- 프로시저 호출문

-- IN 입력값을 여러개 전달받는 프로시저
CREATE PROCEDURE my_new_job_proc
    (p_job_id IN jobs.job_id%TYPE,
    p_job_title IN jobs.job_title%TYPE,
    p_min_sal IN jobs.min_salary%TYPE,
    p_max_sal IN jobs.max_salary%TYPE
    )
IS
    -- 프로시저 호출할 때, 값 전달 받아서 INSERT할 것이기 때문에 딱히 선언할 것X
BEGIN
    INSERT INTO jobs
    VALUES (p_job_id, p_job_title, p_min_sal, p_max_sal);
    COMMIT;
END;

EXEC my_new_job_proc('JOB1','test job1',10000,20000);
-- 값을 하나라도 덜 주거나, 더 주면 INSERT INTO가 되지 않는다! (= 매개값이 필요한 메서드와 같은 원리)

SELECT * FROM jobs;

-- 이미 존재하는 프로시저를 수정하는 법
-- job_id를 확인해서 이미 존재하는 데이터 -> 수정
-- 없다 -> 새롭게 추가(job_id가 PK이기 때문!)
CREATE OR REPLACE PROCEDURE my_new_job_proc -- 기존 프로시저 구조를 수정하겠다!
    (p_job_id IN jobs.job_id%TYPE,
    p_job_title IN jobs.job_title%TYPE,
    p_min_sal IN jobs.min_salary%TYPE,
    p_max_sal IN jobs.max_salary%TYPE
    )
IS
    v_cnt NUMBER := 0; -- 선언 이유: job_id 입력값을 받아서 jobs테이블에서 조회하기 위한 변수(select사용)
    
BEGIN
    
    -- 동일한 job_id가 있는지부터 체크
    -- 이미 존재: COUNT가 1, 존재X: COUNT가 0 -> v_cnt에 저장
    SELECT
        COUNT(*)
    INTO
        v_cnt
    FROM jobs
    WHERE job_id = p_job_id;

    IF v_cnt = 0 THEN --> 조회 결과가 없었다면(v_cnt = 0) INSERT
        INSERT INTO jobs
        VALUES (p_job_id, p_job_title, p_min_sal, p_max_sal);
    ELSE -- 있다면(v_cnt = 1) UPDATE
        UPDATE jobs
        SET
            job_title = p_job_title,
            min_salary = p_min_sal,
            max_salary = p_max_sal
        WHERE job_id = p_job_id;
    END IF;
    COMMIT;
END;

EXEC my_new_job_proc('JOB2','test job2',10000,20000);
SELECT * FROM jobs;

-- 예를 들어서, 4개가 다 전달이 안되면 프로시저가 호출이X -> min_sal, max_sal을 안주면 기본 값을 설정해겠다.
CREATE OR REPLACE PROCEDURE my_new_job_proc -- 기존 프로시저 구조를 수정하겠다!
    (p_job_id IN jobs.job_id%TYPE,
    p_job_title IN jobs.job_title%TYPE,
    p_min_sal IN jobs.min_salary%TYPE := 0,
    p_max_sal IN jobs.max_salary%TYPE := 1000
    )
IS
    v_cnt NUMBER := 0; -- 선언 이유: job_id 입력값을 받아서 jobs테이블에서 조회하기 위한 변수(select사용)
    
BEGIN
    
    -- 동일한 job_id가 있는지부터 체크
    -- 이미 존재: COUNT가 1, 존재X: COUNT가 0 -> v_cnt에 저장
    SELECT
        COUNT(*)
    INTO
        v_cnt
    FROM jobs
    WHERE job_id = p_job_id;

    IF v_cnt = 0 THEN --> 조회 결과가 없었다면(v_cnt = 0) INSERT
        INSERT INTO jobs
        VALUES (p_job_id, p_job_title, p_min_sal, p_max_sal);
    ELSE -- 있다면(v_cnt = 1) UPDATE
        UPDATE jobs
        SET
            job_title = p_job_title,
            min_salary = p_min_sal,
            max_salary = p_max_sal
        WHERE job_id = p_job_id;
    END IF;
    COMMIT;
END;

EXEC my_new_job_proc('JOB4','test job4');
SELECT * FROM jobs;

-------------------------------------------------------------------------------------------------------

-- OUT, IN OUT 매개변수 사용
-- OUT 변수를 사용하면 프로시저 바깥쪽으로 값을 보냅니다.
-- OUT을 이용해서 보낸 값은 바깥 익명 블록에서 실행해야 합니다. -> OUT한 값을 받아주기 위해서 변수를 선언해야하기 때문 -> 변수 선언은 익명블록에서 할 수 있음 -> 그래서 익명블록에서 실행해야 한다는 것
-- return과 비슷하게 만들어 줄 수 있음.

-- OUT
CREATE OR REPLACE PROCEDURE my_new_job_proc
    (p_job_id IN jobs.job_id%TYPE,
    p_job_title IN jobs.job_title%TYPE,
    p_min_sal IN jobs.min_salary%TYPE := 0,
    p_max_sal IN jobs.max_salary%TYPE := 1000, -- 여기까지 다 IN임. 호출할 때 값이 들어와야하는 변수들
    p_result OUT VARCHAR2 -- 바깥쪽에서 출력을 하기 위한 변수, 밖으로 나가는 용도
    )
IS
    v_cnt NUMBER := 0;
    v_result VARCHAR2(100) := '존재하지 않는 값이라 INSERT처리 되었습니다.';
BEGIN
    
    -- 동일한 job_id가 있는지부터 체크
    -- 이미 존재: COUNT가 1, 존재X: COUNT가 0 -> v_cnt에 저장
    SELECT
        COUNT(*)
    INTO
        v_cnt
    FROM jobs
    WHERE job_id = p_job_id;

    IF v_cnt = 0 THEN --> 조회 결과가 없었다면(v_cnt = 0) INSERT
        INSERT INTO jobs
        VALUES (p_job_id, p_job_title, p_min_sal, p_max_sal);
    ELSE -- 있다면(v_cnt = 1) 조회된 결과를 추출하겠다!
        SELECT
            p_job_id || '의 최대 연봉: ' || max_salary || ', 최소 연봉: ' || min_salary
        INTO v_result -- 위의 조회 결과를 변수에 대입
        FROM jobs
        WHERE job_id = p_job_id;
    END IF;
    
    -- OUT 매개변수에 조회 결과를 할당.
    p_result := v_result; -- 프로시저를 호출하면 p_result값이 호출한 곳으로 return되어야함
    -- 왜 굳이 v_result를 선언해서 대입까지 해줘야 하냐: OUT은 프로시저가 END;를 해야 값을 할당받음
    -- p_result만을 가지고 할 수 있는 것도 없고, 값을 준다고 해도 error가 날꺼임
    COMMIT;
END;

-- 메서드의 return -> 값이 그냥 옴
-- 프로시저의 OUT -> 익명함수에서 선언한 변수를 프로시저에게 보내줘야함
-- 그럼 프로시저가 변수를 받아서 OUT의 결과를 담아서 보내줌
DECLARE
    msg VARCHAR2(100); -- return값 받을 변수
BEGIN
    -- 프로시저 호출할 때 필요한 EXEC은 익명함수에선 필요X
    my_new_job_proc('JOB2', 'test_job2', 2000, 8000, msg);
    dbms_output.put_line(msg);
    
END;

-- 결과: JOB2의 최대 연봉: 20000, 최소 연봉: 10000

DECLARE
    msg VARCHAR2(100); -- return값 받을 변수
BEGIN
    -- 프로시저 호출할 때 필요한 EXEC은 익명함수에선 필요X
    my_new_job_proc('JOB2', 'test_job2', 2000, 8000, msg);
    dbms_output.put_line(msg);
    
    my_new_job_proc('CEO', 'test_ceo', 20000, 80000, msg); -- msg 안쓴 이유: 어차피 v_cnt가 0이여서 INSERT될 거니까!
    dbms_output.put_line(msg);
END; -- error: msg값을 안줘서 에러남
-- 해결: msg를 넣어주긴 해야함. 익명블록에서 v_result를 IS에서 선언해 줬을 때 기본 값을 줬다

SELECT * FROM jobs;
-- 결과: 존재하지 않는 값이라 INSERT처리 되었습니다, jobs테이블에 CEO가 추가 됨

-------------------------------------------------------------------------------------------------------------------------

-- IN OUT + OUT과 IN OUT의 차이점!
-- IN, OUT 동시에 처리
-- 목적: 값 다 보내고 출력 -> 그랬을 때, OUT도 받아지는지 + IN OUT은 어떻게 반응하는지
CREATE OR REPLACE PROCEDURE my_parameter_test_proc
    (
    -- IN: 반환 불가. 받는 용도로만 활용
    p_var1 IN VARCHAR2, -- IN은 값의 할당이 불가함.
    -- OUT: 받는 용도로 활용 불가능.
    -- OUT이 되는 시점은 프로시저가 끝날 때(END;). 그 전까지는 값의 할당이 안됨.
    p_var2 OUT VARCHAR2,
    -- IN OUT: IN과 OUT 둘 다 가능함
    p_var3 IN OUT VARCHAR2
    )
IS
BEGIN
    dbms_output.put_line('p_var1: ' || p_var1);
    dbms_output.put_line('p_var2: ' || p_var2);
    dbms_output.put_line('p_var3: ' || p_var3);
    
    -- p_var1 := '결과1'; IN 변수는 값 할당 자체가 불가능. assignment target으로 잡히지 않음
    p_var2 := '결과2';
    p_var3 := '결과3';
END;

-- 익명블록
DECLARE
    v_var1 VARCHAR2(10) := 'value1'; -- IN: 당연히 출력됨
    v_var2 VARCHAR2(10) := 'value2'; -- OUT: 값이 전달되지 않음
    v_var3 VARCHAR2(10) := 'value3'; -- IN OUT: IN의 성질을 가지고 있구나~
BEGIN
    my_parameter_test_proc(v_var1, v_var2, v_var3);
END;

-- 출력한 후, 값을 대입
DECLARE
    v_var1 VARCHAR2(10) := 'value1'; -- IN: 당연히 출력됨
    v_var2 VARCHAR2(10) := 'value2'; -- OUT: 값이 전달되지 않음
    v_var3 VARCHAR2(10) := 'value3'; -- IN OUT: IN의 성질을 가지고 있구나~
    
    
BEGIN
    my_parameter_test_proc(v_var1, v_var2, v_var3);
    
    dbms_output.put_line('v_var1: ' || v_var1); -- IN: OUT 불가능
    dbms_output.put_line('v_var2: ' || v_var2); -- OUT: 프로시저 밖으로 결과를 뽑아올 수 있음
    dbms_output.put_line('v_var3: ' || v_var3); -- IN OUT: OUT의 기능도 가능
END;

-- 결과: 이미지

-- RETURN
-- : 자바에서 void메서드를 끝낼 때 return을 쓰듯이
-- 오라클에서도 프로시저를 강제로 종료하기 위한 return이 있다.
CREATE OR REPLACE PROCEDURE my_new_job_proc
    (p_job_id IN jobs.job_id%TYPE,
    p_result OUT VARCHAR2 
    )
IS
    v_cnt NUMBER := 0;
    v_result VARCHAR2(100) := '존재하지 않는 값이라 INSERT처리 되었습니다.';
BEGIN

    SELECT
        COUNT(*)
    INTO
        v_cnt
    FROM jobs
    WHERE job_id = p_job_id;

    IF v_cnt = 0 THEN
        dbms_output.put_line(p_job_id || '는 테이블에 존재하지 않습니다.');
        return; -- 밑의 SELECT문을 실행하게 하지 않게 하기 위해 프로시저 강제 종료
    END IF;
        SELECT
            p_job_id || '의 최대 연봉: ' || max_salary || ', 최소 연봉: ' || min_salary
        INTO v_result -- 위의 조회 결과를 변수에 대입
        FROM jobs
        WHERE job_id = p_job_id;
    
    p_result := v_result;
    COMMIT;
END;

DECLARE
    msg VARCHAR2(100);
BEGIN
    my_new_job_proc('merong', msg);
    dbms_output.put_line(msg);
END;

------------------------------------------------------------------------------

-- 예외 처리
-- :
-- 강제로 error를 내보겠다
DECLARE
    v_num NUMBER := 0;
BEGIN

    v_num := 10 / 0; -- error: divisor is equal to zero
    
    /*
    OTHERS 자리에 예외의 타입을 작성해 줍니다.
    ACCESS_INTO_NULL -> 객체 초기화가 되어 있지 않은 상태에서 사용.
    NO_DATA_FOUND -> SELECT INTO 시 데이터가 한 건도 없을 때
    ZERO_DIVIDE -> 0으로 나눌 때
    VALUE_ERROR -> 수치 또는 값 오류
    INVALID_NUMBER -> 문자를 숫자로 변환할 때 실패한 경우
    */
    EXCEPTION -- 맨 마지막에 세팅하면 된다.
        WHEN ZERO_DIVIDE THEN
            dbms_output.put_line('0으로 나누시면 안돼요!');
            dbms_output.put_line('SQL ERROR CODE: ' || SQLCODE);
            dbms_output.put_line('SQL ERROR: ' || SQLERRM); -- SQLERRM: 오라클에 제공하는 에러코드+에러메세지 말해주는 명령어
        WHEN OTHERS THEN
            -- WHEN으로 설정한 예외가 아닌(OTHERS 자리에) 다른 예외가 발생 시 OTHERS 실행.
            dbms_output.put_line('알 수 없는 예외 발생!');
END;

























