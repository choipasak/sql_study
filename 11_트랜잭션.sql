
/*
트랜잭션이란?
데이터 베이스의 상태에 변화가 생길 때 그 상태변화의 과정을 하나로 저장한 것.
하나의 작업의 단위를 트랜잭션이라고 한다. + 작업 안에는 여러가지 종류의 쿼리문이 해당
지금까진 DML의 SELECT, INSERT, UPDATE, DELETE를 각각 한번씩만 사용했음
근데 하나씩만 사용하지 않음
예시
1. 은행의 계좌이체
[송금] 나 -> 친구 : 은행(요청받) -> DB: 나의 계좌에서 금액 차감(UPDATE), 친구의 계좌에 금액 추가(UPDATE)
실패: 내 계좌-금액 -> 친구계좌(반응x) -> 송금 전으로 롤백 해줘야 함.
성공: 송금이 성공하면 성공한 과정을 기록을 남기기 위해 DB가 커밋! 해줘야 함
EX) 글 등록 -> 글 등록하면 끝임 -> 트랜잭션의 대상이X
2. 회원 가입
회원가입(요청 1개) -> 테이블(정보마다 있는 테이블: N개)에 INSERT -> INSERT 한개가 오류 -> 모든 INSERT 취소 필요 -> 트랜잭션 필요
* 커밋과 롤백을 주로 사용한다!
*/

-- 오토커밋 여부 확인 -> 기본적으로 AUTOCOMMIT가 꺼져있음 -> 키는 것은 권장X: 트랜잭션을 안한다는 의미와 동일
SHOW AUTOCOMMIT;
-- 오토커밋 온
SET AUTOCOMMIT ON;
-- 오토커밋 오프
SET AUTOCOMMIT OFF;

SELECT * FROM emps;

INSERT INTO emps
    (employee_id, last_name, email, hire_date, job_id)
VALUES
    (305, 'park', 'park1234@gmail.com', sysdate, 1800); -- 결과: 행 107개

-- 보류중인 모든 데이터 변경사항을 취소(폐기)
-- 직전 커밋 단계로 회귀(돌아가기) 및 트랜잭션 종료.
ROLLBACK; -- 결과: 행 106개
-- 커밋 전으로 보내줌

-- SAVE POINT(ORACLE 문법)
-- 롤백할 포인트를 직접 이름을 붙여서 지정.
-- ANSI 표준 문법이 아니기 때문에 그렇게 권장하지는 않음.
SAVEPOINT insert_park; -- 커밋이 된 것이 아니고 그냥 저장 시점이다.

INSERT INTO emps
    (employee_id, last_name, email, hire_date, job_id)
VALUES
    (306, 'kim', 'kim1234@gmail.com', sysdate, 1800);
    
ROLLBACK TO SAVEPOINT insert_park;

-- 이제 진짜로 롤백 할 일이 없다 -> 커밋
COMMIT;

DELETE FROM emps
WHERE employee_id = 306;

ROLLBACK; -- DELETE 취소 -> emps테이블 다시 확인 해보면 107개 행 출력

-- 보류중인 모든 데이터 변경사항을 영구적으로 적용하면서 트랜잭션 종료
-- 커밋 후에는 어떠한 방법을 사용하더라도 되돌릴 수 없습니다.
-- 신중 또 신중!
COMMIT;


















