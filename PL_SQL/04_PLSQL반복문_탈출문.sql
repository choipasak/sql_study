
-- WHERE절
DECLARE
    v_num NUMBER := 3;
    v_count NUMBER := 1; -- begin
BEGIN
    WHILE v_count <= 10 -- end
    LOOP
        dbms_output.put_line(v_num);
        v_count := v_count + 1; -- step: v_count += 1 과 같음
        v_num := v_num + 1; -- v_num += 1 과 같음
    END LOOP;
        
END;

-- 누적 합을 v_num에 대입해보기
DECLARE
    v_num NUMBER := 0;
    v_count NUMBER := 1; -- begin
BEGIN
    WHILE v_count <= 10 -- end
    LOOP
        v_num := v_num + v_count; -- step
        v_count := v_count + 1; -- v_count += 1 과 같음
    END LOOP;
    
    dbms_output.put_line(v_num);
        
END;

-- 탈출문
DECLARE
    v_num NUMBER := 0;
    v_count NUMBER := 1; -- begin
BEGIN
    WHILE v_count <= 10 -- end
    LOOP
        EXIT WHEN v_count = 5; -- break; 와 똑같음
    
        v_num := v_num + v_count; -- step
        v_count := v_count + 1; -- v_count += 1 과 같음
    END LOOP;
    
    dbms_output.put_line(v_num);
        
END; -- 1 2 3 4 까지만 더해진 것

-- FOR문(향상for문과 비슷함)
-- 구구단을 출력해보자!
DECLARE
    v_num NUMBER := 4; -- 4단으로 고정
BEGIN
    
    FOR i IN 1..9 -- i의 범위 지정(.을 두 개 작성해서 범위를 표현)
    LOOP
        dbms_output.put_line(v_num || ' x ' || i || ' = ' || v_num*i);
    END LOOP;
    
END;

-- CONTINUE문
DECLARE
    v_num NUMBER := 3; -- 4단으로 고정
BEGIN
    
    FOR i IN 1..9 -- i의 범위 지정(.을 두 개 작성해서 범위를 표현)
    LOOP
        CONTINUE WHEN  i = 5; -- continue문: i가 5일때는 건너 뛰겠다는 의미
        dbms_output.put_line(v_num || ' x ' || i || ' = ' || v_num*i);
    END LOOP;
    
END; -- WHILE문에서도 가능함 -> continue를 만나면 조건식으로 돌아감(자바와 똑같음)

-- 연습 문제
-- 1. 모든 구구단을 출력하는 익명 블록을 만드세요. (2 ~ 9단)
-- 짝수단만 출력해 주세요. (2, 4, 6, 8)
-- 참고로 오라클 연산자 중에는 나머지를 알아내는 연산자가 없어요. (% 없음~)
-- 나ver
DECLARE
    v_dan NUMBER := 1;
    v_hang NUMBER := 1;
BEGIN
    v_dan := v_dan + 1;
    IF MOD(v_dan, 2) = 0 THEN
        FOR i IN 1..9 LOOP
            EXIT WHEN v_dan < 10;
            dbms_output.put_line(v_dan || ' x ' || i || ' = ' || v_dan*i);
        END LOOP;
    END IF;
END;

-- 선생님ver
DECLARE
BEGIN
    FOR dan IN 1..9 LOOP -- DECLARE에서 굳이 선언X -> FOR문에서 변수를 말하니까
        IF MOD(dan, 2) = 0 THEN -- 오라클에서 나머지(%)연산자 -> MOD(나눌 값, 몫)
        dbms_output.put_line(' 구구단 ' || dan || ' 단 ');
            FOR hang IN 1..9 LOOP
                dbms_output.put_line(dan || ' x ' || hang || ' = ' || dan*hang);
            END LOOP;
        END IF;
    END LOOP;
END;



-- 2. INSERT를 300번 실행하는 익명 블록을 처리하세요.
-- board라는 이름의 테이블을 만드세요. (bno, writer, title 컬럼이 존재합니다.)
-- bno는 SEQUENCE로 올려 주시고, writer와 title에 번호를 붙여서 INSERT 진행해 주세요.
-- ex) 1, test1, title1 -> 2 test2 title2 -> 3 test3 title3 ....
CREATE TABLE board (
    bno NUMBER PRIMARY KEY,
    writer VARCHAR2(30),
    title VARCHAR2(30)
);

CREATE SEQUENCE bno_seq
    START WITH 1 -- 시작값 (작성안할 수도 있음. 기본값은 증가할 때 최소값, 감소할 때 최대값)
    INCREMENT BY 1 -- 증가값 (양수면 증가, 음수면 감소, 기본값 1)
    MAXVALUE 1000-- 최대값 (기본값: 증가일 때 1027, 감소일 때 -1)
    NOCACHE -- 캐시메모리 사용 여부 (기본값: CACHE): 시퀀스한테 지정된 값만큼을 미리 얻어와준다. 한 1~40정도를 빼와서 캐시메모리에 저장해 놓는다 -> 호출될 때마다 얻어왔던 번호를 붙여줌. 근데 개발과정에서는 잘 사용하지 않음. ERROR날때마다 얻어온 캐시가 다 날라감.
    NOCYCLE;

DECLARE
    v_num NUMBER := 1;
BEGIN
    WHILE v_num <= 300
    LOOP
        INSERT INTO board
        VALUES(bno_seq.NEXTVAL, 'test' || v_num, 'title' || v_num); -- 시퀀스는 호출될 때마다 수가 추가되기 때문에 v_num대신 bno_seq를 작성했다면 대입되는 결과가 (1, test2, title3)이 되었을 것이다.
        v_num := v_num + 1;
    END LOOP;
    COMMIT;
END;





-- 나ver
CREATE SEQUENCE bno_seq
    START WITH 1 -- 시작값 (작성안할 수도 있음. 기본값은 증가할 때 최소값, 감소할 때 최대값)
    INCREMENT BY 1 -- 증가값 (양수면 증가, 음수면 감소, 기본값 1)
    MAXVALUE 1000-- 최대값 (기본값: 증가일 때 1027, 감소일 때 -1)
    NOCACHE -- 캐시메모리 사용 여부 (기본값: CACHE): 시퀀스한테 지정된 값만큼을 미리 얻어와준다. 한 1~40정도를 빼와서 캐시메모리에 저장해 놓는다 -> 호출될 때마다 얻어왔던 번호를 붙여줌. 근데 개발과정에서는 잘 사용하지 않음. ERROR날때마다 얻어온 캐시가 다 날라감.
    NOCYCLE;

DECLARE
BEGIN
    FOR i IN 1..300 LOOP
        CREATE TABLE board
            (bno, writer, title)
        VALUES
            (bno_seq, 'test' || bno_seq, 'title' || bno_seq)
    END LOOP;
END;

SELECT * FROM board
ORDER BY bno DESC;

























