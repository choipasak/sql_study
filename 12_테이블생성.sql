
-- 테이블 생성 (컬럼과 컬럼타입)
/*
# 컬럼 타입 종류
- NUMBER(2) -> 정수를 2자리까지 저장할 수 있는 숫자형 타입.(정수 실수 구분X)
- NUMBER(5, 2) -> 정수부, 실수부를 합친 총 자리수 5자리(소수점 제외), 소수점 2자리까지 받는다
- NUMBER -> 괄호를 생략할 시 (38, 0)으로 자동 지정됩니다.
- VARCHAR2(byte) -> 괄호 안에 들어올 문자열의 최대 길이를 지정. (4000byte까지 받기 가능), 가변형(문자길이에 맞춰서 크기가 맞춰짐)이어서 多사용
- CLOB -> 대용량 텍스트 데이터 타입 (최대 4Gbyte) - 문자열 저장
- BLOB -> 이진형 대용량 객체 (이미지, 파일 저장 시 사용) - 바이트 단위로 저장 -> 권장X: DB용량이 비싸서 경로로 대체해서 저장
- DATE -> BC 4712년 1월 1일 ~ AD 9999년 12월 31일까지 지정 가능
- 시, 분, 초 지원 가능.
*/
ROLLBACK;
CREATE TABLE dept2 (
    dept_no NUMBER(2),
    dept_name VARCHAR(14),
    loca VARCHAR(15),
    dept_date DATE,
    dept_bonus NUMBER(10) -- 원하는컬럼명 해당컬럼의타입(컬럼의 길이제한)
);
-- DDL - CREATE, ALTER, DROP, TRUNCATE같은 데이터 정의어는 트랜잭션의 영향을 받지 않는다.
-- 무슨 말: CREATE는 롤백이 먹지X -> 롤백해도 테이블이 사라지지 않는다.
-- 그래서 DROP이라는 명령어가 무섭 -> 절대.복구불가
-- DDL의 모든 명령어는 실행하는 동시에 자동 커밋이 들어간다!

-- TABLE 생성!
-- DML -> CRUD
-- DDL -> CREATE, ALTER(= UPDATE, CREATE로 만든 것은 ALTER로 수정한다.), DROP(= DELETE)
-- 트랜잭션 TCL -> COMMIT, ROLLBACK, SAVEPOINT(오라클 문법)


DESC dept2; -- 테이블 스크립트로 보기
SELECT * FROM dept2;

-- NUMBER와 VARCHAR2 타입의 길이를 확인.
INSERT INTO dept2
VALUES (30, '경영지원', '경기', sysdate, 2000000);

-- 컬럼추가
ALTER TABLE dept2
ADD (dept2_count NUMBER(3));

-- 컬럼 이름 변경
ALTER TABLE dept2
RENAME COLUMN dept2_count TO emp_count;

-- 컬럼 속성 수정(변경)
-- 만약 변경하고자 하는 컬럼에 데이터가 이미 존재한다면 그에 맞는 타입으로
-- 변경해 주셔야 합니다. 맞지 않는 타입으로는 변경이 불가능합니다.
ALTER TABLE dept2
MODIFY (dept_name VARCHAR2(100)); -- 데이터 길이 제한 변경

SELECT * FROM dept3;
DESC dept2;

-- 컬럼 삭제
ALTER TABLE dept2
DROP COLUMN dept_bonus;

-- 컬럼 말고 테이블 이름 변경
ALTER TABLE dept2
RENAME TO dept3;
-- 변경하고
SELECT * FROM dept3; -- 로 조회해야 테이블이 조회가 가능함.

-- 테이블 삭제(구조는 남겨두고 내부 데이터만 모두 삭제)
TRUNCATE TABLE DEPT3;

-- 테이블까지 삭제
DROP TABLE DEPT3;
ROLLBACK; -- 불가
















