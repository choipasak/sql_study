
-- 계정 생성
-- 계정 생성을 위해 먼저 사용자 계정 확인을 해보자!
SELECT * FROM all_users;

-- 계정 생성 명령
-- ID: user1, PW: user1 인 계정을 생성해보자!
CREATE USER user1 IDENTIFIED BY user1; -- ERROR: insufficient privileges
-- ERROR -> 현재 내 계정: hr -> hr계정은 계정을 생성할 권한이 없다는 소리
-- system 계정으로 접속! -> user1 계정 생성

/*
DCL[DATA CONTROLL LANGUAGE]
: GRANT(권한 부여), REVOKE(권한 회수)

CREATE USER -> 데이터베이스 유저 생성 권한
CREATE SESSION -> 데이터베이스 접속 권한
CREATE TABLE -> 테이블 생성 권한
CREATE VIEW -> 뷰 생성 권한
CREATE SEQUENCE -> 시퀀스 생성 권한
ALTER ANY TABLE -> 어떠한 테이블도 수정할 수 있는 권한
INSERT ANY TABLE -> 어떠한 테이블에도 데이터를 삽입하는 권한.
SELECT ANY TABLE...

SELECT ON [테이블 이름] TO [유저 이름] -> 특정 테이블만 조회할 수 있는 권한.
INSERT ON....
UPDATE ON....

- 관리자에 준하는 권한을 부여하는 구문.
RESOURCE, CONNECT, DBA TO [유저 이름]
*/
-- 계정 user1에게 DB접속 권한 부여
GRANT CREATE SESSION TO user1;

SELECT * FROM hr.departments; -- 여긴 system계정이여서 모든 권한을 다 가지고 있음.
-- cmd의 user1계정은 DB접속 권한 밖에 없음
-- 그럼 user1에 hr계정이 가지고 있는 departments테이블의 조회 권한을 부여 하겠다!
GRANT SELECT ON hr.departments TO user1;

-- user1에게 hr.department에 INSERT할 권한 부여
GRANT INSERT ON hr.departments TO user1;

-- user1에게 테이블 생성 권한 부여
GRANT CREATE TABLE TO user1;
-- 테이블이 생성되면 users라는 tablespace라는 공간에 저장이 되는데
-- 접근하려면 권한 필요
ALTER USER user1
DEFAULT TABLESPACE users
QUOTA UNLIMITED ON users;

-- 어떠한 테이블이든 다 조회 가능 권한 부여
GRANT SELECT ANY TABLE TO user1;

-- 그냥 한번에 관리자 권한 부여
GRANT RESOURCE, CONNECT, DBA TO user1; -- system과 거의 동급 권한

-- 권한 회수
REVOKE RESOURCE, CONNECT, DBA FROM user1;

-- 사용자 계정 삭제
DROP USER user1;
-- error1: cannot drop a user that is currently connected -> 현재 접속중이여서 DROP불가
-- error2: CASCADE must be specified to drop '%s' -> 그 계정이 객체를 가지고 있으면 함부러 삭제 안해줌
-- 진짜 지우려면 CASCADE를 붙여서 지워라.

-- 사용자 계정 삭제
-- DROP USER [유저이름] CASCADE;
-- CASCADE 없을 시 -> 테이블 or 시퀀스 등 객체가 존재한다면 계정 삭제 안됨.
DROP USER user1 CASCADE; -- 성공

/*
TABLESPACE
테이블 스페이스는 데이터베이스 객체 내 실제 데이터가 저장되는 공간입니다.
테이블 스페이스를 생성하면 지정된 경로에 실제 파일로 정의한 용량만큼의
파일이 생성이 되고, 데이터가 물리적으로 저장됩니다.
당연히 테이블 스페이스의 용량을 초과한다면 프로그램이 비정상적으로 동작합니다.
C드라이브에 실제 파일 형태로 존재!(물리적)
*/
SELECT * FROM dba_tablespaces; -- 현재 존재하는 테이블을 보여줌

CREATE USER test1 IDENTIFIED BY test1;
GRANT CREATE SESSION TO test1;
GRANT CONNECT, RESOURCE TO test1;
-- test1이 만든 테이블은 만든 USER_TABLESPACE에 저장되게 하겠다
--> 정리: user_tablespace 테이블 스페이스를 기본 사용 공간으로 지정하고 사용량 제한.
ALTER USER test1 DEFAULT TABLESPACE user_tablespace
QUOTA 10M ON user_tablespace; -- test1계정은 user_tablespace에서 최대 10 메가바이트 쓸 수 있게 하겠다!
-- or
ALTER USER test1 DEFAULT TABLESPACE user_tablespace
QUOTA UNLIMITED ON user_tablespace; -- 사용용량 제한하지 X

-- 테이블 스페이스 내의 객체를 전체 삭제(물리적 공간은 남음)
DROP TABLESPACE user_tablespace INCLUDING CONTENTS;

-- 물리적 파일까지 한 번에 삭제하는 법
DROP TABLESPACE user_tablespace INCLUDING CONTENTS AND DATAFILES;











