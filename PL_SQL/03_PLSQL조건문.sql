
SET SERVEROUTPUT ON; -- 출력문 활성화

-- IF문 (기본형)
DECLARE
    v_num1 NUMBER := 10;
    v_num2 NUMBER := 15;
BEGIN
    IF
        v_num1 > v_num2 -- IF의 조건
    THEN -- IF문의 내용(참)
        dbms_output.put_line(v_num1 || '이(가) 큰 수');
    ELSE -- (거짓)
        dbms_output.put_line(v_num2 || '이(가) 큰 수');
    END IF; -- IF문의 종료 선언
    
END;

-- ELSIF문 (ELSEIF라고 쓰지 않음 ELSIF로 표기함)
DECLARE
    v_salary NUMBER := 0;
    v_department_id NUMBER := 0;
BEGIN
    -- v_department_id에 난수 대입
    v_department_id := ROUND(DBMS_RANDOM.VALUE(10, 120), -1); -- DB에서 난수 생성: DBMS_RANDOM.VALUE(범위 시작 숫자[이상], 범위 끝 숫자[미만]) / ROUND의 의미: 난수를 10, 20, 30.. 처럼 10의 단위로 끊어서 출력되게 하기 위해서 올림함수 안에서 난수 생성 + 1의자리에서 올림하기(-1)
    
    SELECT
        salary
    INTO
        v_salary
    FROM employees
    WHERE department_id = v_department_id -- department_id가 난수로 지정된 값일 때,
    AND ROWNUM = 1; -- 첫번째 값만 구해서 변수에 저장할 예정
    
    dbms_output.put_line('조회된 급여: ' || v_salary);
    
    IF
        v_salary <= 5000
    THEN
        dbms_output.put_line('급여가 좀 낮음');
    ELSIF
        v_salary <= 9000
    THEN
        dbms_output.put_line('급여가 중간임');
    ELSE
        dbms_output.put_line('급여가 높음');
    END IF;
    
END;

-- switch-case문 -> case문 이라고 함
DECLARE
    v_salary NUMBER := 0;
    v_department_id NUMBER := 0;
BEGIN
    -- v_department_id에 난수 대입
    v_department_id := ROUND(DBMS_RANDOM.VALUE(10, 120), -1);

    SELECT
        salary
    INTO
        v_salary
    FROM employees
    WHERE department_id = v_department_id -- department_id가 난수로 지정된 값일 때,
    AND ROWNUM = 1; -- 첫번째 값만 구해서 변수에 저장할 예정
    
    dbms_output.put_line('조회된 급여: ' || v_salary);
    
    -- CASE문
    CASE
        WHEN v_salary <= 5000 THEN
            dbms_output.put_line('급여가 좀 낮음');
        WHEN v_salary <= 9000 THEN
            dbms_output.put_line('급여가 중간임');
        ELSE
            dbms_output.put_line('급여가 높음');
    END CASE;

END;

-- 중첩 IF문
DECLARE
    v_salary NUMBER := 0;
    v_department_id NUMBER := 0;
    v_commission_pct NUMBER := 0;
BEGIN
    -- v_department_id에 난수 대입
    v_department_id := ROUND(DBMS_RANDOM.VALUE(10, 110), -1);
    
    SELECT
        salary, commission_pct
    INTO
        v_salary, v_commission_pct
    FROM employees
    WHERE department_id = v_department_id
    AND ROWNUM = 1; -- department_id가 같은 애들중에 첫번째 사람만 조회.
    
    dbms_output.put_line('조회된 급여: ' || v_salary);
    
    IF v_commission_pct > 0 THEN
        IF v_commission_pct > 0.15 THEN
            dbms_output.put_line('커미션이 0.15이상임!');
            dbms_output.put_line(v_salary * v_commission_pct);
        END IF; -- 안쪽의 IF문을 종료하고,
    ELSE
        dbms_output.put_line('커미션이 0.15이하임!');
    END IF; -- 바깥쪽 IF문도 종료해 준다.
    
END;




































