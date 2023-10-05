
/*
trigger는 테이블에 부착된 형태로써, INSERT, UPDATE, DELETE 작업이 수행될 때
특정 코드가 작동되도록 하는 구문입니다.
VIEW에는 부착이 불가능합니다.
trigger도 객체이다 -> 생성(create)

트리거를 만들 때 범위 지정하고 F5버튼으로 부분 실행해야 합니다.
그렇지 않으면 하나의 구문으로 인식되어 정상 동작하지 않습니다.

특정 작업을 자동화 할 때 상용한다.
예시) INSERT하기 전에 ~해줘, A테이블에 UPDATE되면 B테이블도 같이 UPDATE해줘 등등
*/

CREATE TABLE tbl_test(
    id NUMBER(10),
    text VARCHAR2(20)
);

-- trigger 생성
CREATE OR REPLACE TRIGGER trg_test
    AFTER DELETE OR UPDATE -- 트리거의 발생 시점. (삭제 혹은 수정 이후에 동작해라)
    ON tbl_test -- 트리거를 부착할 테이블 지정
    FOR EACH ROW -- '각 행의 모두 적용하겠다' 라는 의미. (생략 가능, 생략 시 한 번만 실행)
DECLARE -- 선언부 (내용X -> 생략 가능)
    
BEGIN -- 실행부
    dbms_output.put_line('트리거가 동작함!'); -- 실행하고자 하는 코드를 begin ~ end 에 넣음.
END; -- 종료부

-- 트리거는 호출하는 것이 아님.
-- 트리거의 조건으로 걸어준 이벤트를 실행해야 함
INSERT INTO tbl_test VALUES (1, '김춘식');

SELECT * FROM tbl_test;

UPDATE tbl_test
SET test = '마루'
WHERE id = 1; -- 결과: 1 행 이(가) 업데이트되었습니다. 트리거가 동작함!

DELETE FROM tbl_test WHERE id = 1; -- 결과: 1 행 이(가) 삭제되었습니다. 트리거가 동작함! 




















