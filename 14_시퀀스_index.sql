/*
# 시퀀스 (중요)
- 일련의 연속적인 나열되어 있는!
- 시퀀스 (순차적으로 증가하는 값을 만들어 주는 객체) -> 예시) 리스트
내가 기억하지 않아도 된다.
시퀀스가 알아서 중복되지 않으며 순차적인 번호를 붙여준다.
시퀀스도 객체이기 때문에 CREATE를 사용해야 한다.
순차적으로 감소하게 만들 수도 있음 -> INCREMENT를 음수로 지정해 주면 된다.
*/

-- 웬만하면 값을 다 지정해 주자!
-- 증가할 때는 MINVALUE사용 X, 감소할 때는 MAXVALUE사용 X 하는 경우는 있다!
CREATE SEQUENCE dept2_seq
    START WITH 1 -- 시작값 (작성안할 수도 있음. 기본값은 증가할 때 최소값, 감소할 때 최대값)
    INCREMENT BY 1 -- 증가값 (양수면 증가, 음수면 감소, 기본값 1)
    MAXVALUE 10 -- 최대값 (기본값: 증가일 때 1027, 감소일 때 -1)
    MINVALUE 1 -- 최소값 (기본값: 증가일 때 1, 감소할 때 -1028)
    NOCACHE -- 캐시메모리 사용 여부 (기본값: CACHE): 시퀀스한테 지정된 값만큼을 미리 얻어와준다. 한 1~40정도를 빼와서 캐시메모리에 저장해 놓는다 -> 호출될 때마다 얻어왔던 번호를 붙여줌. 근데 개발과정에서는 잘 사용하지 않음. ERROR날때마다 얻어온 캐시가 다 날라감.
    NOCYCLE; -- 순환 여부 (NOCYCLE이 기본, 순환시키려면 CYCLE)

/*
NOCACHE
캐시메모리 사용 여부 (기본값: CACHE)
시퀀스한테 지정된 값만큼을 미리 얻어와준다. 그래서 성능은 좋음
한 1~40정도를 빼와서 캐시메모리에 저장해 놓는다 -> 호출될 때마다 얻어왔던 번호를 붙여줌.
근데 개발과정에서는 잘 사용하지 않음.
왜: ERROR날때마다 얻어온 캐시가 다 날라감 그리고 새로운 캐시(약 40개 정도)를 받아옴.
그럼 시퀀스는 그 전에 얻어온 캐시의 개수+1 의 번호부터 시작함
*/

DROP TABLE dept2;

CREATE TABLE dept2(
    dept_no NUMBER(2) PRIMARY KEY, -- 시퀀스한테 올려달라고 해보자!
    dept_name VARCHAR2(14),
    loca VARCHAR2(13),
    dept_date DATE
);

-- 시퀀스 사용하기! (NEXTVAL(다음값), CURRVAL)
INSERT INTO dept2
VALUES(dept2_seq.NEXTVAL, 'test', 'test', sysdate);
-- 여러번 누르니 ERROR: sequence DEPT2_SEQ.NEXTVAL exceeds MAXVALUE and cannot be instantiated
-- MAXVALUE를 시퀀스가 초과 + dept2_seq의 속성에 NOCYCLE이라고 지정해서 시퀀스가 끝났다는 의미
-- PRIMARY KEY를 지정하는 시퀀스는 중복을 허용하면 안되기 때문에 반드시 NOCYCLE로 지정해 줘야 한다!

SELECT * FROM dept2;

SELECT dept2_seq.CURRVAL FROM dual; -- 지금 시퀀스가 몇번까지 올라갔는지 알려줌

-- 시퀀스 수정 (직접 수정 가능)
-- START WITH(시작값)은 수정이 불가능합니다.
ALTER SEQUENCE dept2_seq MAXVALUE 9999; -- 시퀀스의 최대 값을 수정해줌
-- 증가값 수정
ALTER SEQUENCE dept2_seq INCREMENT BY -1;
-- 최소값 변경
ALTER SEQUENCE dept2_seq MINVALUE 0;
-- 다시 INSERT 테스트

-- 시퀀스 값을 다시 처음으로 돌리는 방법
-- 증가한 시퀀스 값만큼 증감 시켜준다.
ALTER SEQUENCE dept2_seq INCREMENT BY -121;
SELECT dept2_seq.NEXTVAL FROM dual;
ALTER SEQUENCE dept2_seq INCREMENT BY 1; -- 다시 1부터 시작

-- 근데 시퀀스를 초기화 시키고 싶다 -> 그냥 초기화. 시퀀스 삭제 후 재생성
DROP SEQUENCE dept2_seq;

----------------------------------------------------------------------------

/*
- index
index는 primary key, unique 제약 조건에서 자동으로 생성되고,
조회를 빠르게 해 주는 hint 역할을 합니다.
index는 조회를 빠르게 하지만, 무작위하게 많은 인덱스를 생성해서
사용하면 오히려 성능 부하를 일으킬 수 있습니다.
정말 필요할 때만 index를 사용하는 것이 바람직합니다.
그래서 PRIMARY KEY를 통해서 조회하는 것이다.
*/
-- 옵티마이저가 인덱스를 사용하면 어떻게 실행하는지 알 수 있음(F10)
SELECT * FROM employees WHERE salary = 12008;

-- 인덱스 생성
-- emp_salary_id를 employees의 salary에 붙이겠다!
CREATE INDEX emp_salary_idx ON employees(salary);
-- 인덱스를 사용하면 salary에 행번호를 붙임
-- 똑같은 조회문을 실행했을 때, 테이블을 풀 스캔해서 조건에 맞는 데이터를 조회하는게 아니라
-- 바로 salary로 가서 붙인 인덱스를 탐색해서 조회해온다.
/*
 !정리
테이블 조회 시 인덱스가 붙은 컬럼을 조건절로 사용한다면
테이블 전체 조회가 아닌, 컬럼에 붙은 인덱스를 이용해서 조회를 진행합니다.
인덱스를 생성하게 되면 지정한 컬럼에 ROWID를 붙인 인덱스가 준비되고,
조회를 진행할 시 해당 인덱스의 ROWID를 통해 빠른 스캔을 가능하게 합니다.
*/

-- 인덱스 삭제
DROP INDEX emp_salary_idx;

-- 시퀀스와 인덱스를 사용하는 hint방법
CREATE SEQUENCE board_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE; -- 시퀀스 생성

CREATE TABLE tbl_board(
    bno NUMBER(10) PRIMARY KEY,
    writer VARCHAR2(20)
);

INSERT INTO tbl_board
VALUES (board_seq.nextval, 'test');

INSERT INTO tbl_board
VALUES (board_seq.nextval, 'kim');

INSERT INTO tbl_board
VALUES (board_seq.nextval, 'hong');

INSERT INTO tbl_board
VALUES (board_seq.nextval, 'admin');

INSERT INTO tbl_board
VALUES (board_seq.nextval, 'test');

INSERT INTO tbl_board
VALUES (board_seq.nextval, 'kim');

INSERT INTO tbl_board
VALUES (board_seq.nextval, 'hong');

INSERT INTO tbl_board
VALUES (board_seq.nextval, 'admin');

INSERT INTO tbl_board
VALUES (board_seq.nextval, 'test');

INSERT INTO tbl_board
VALUES (board_seq.nextval, 'kim');

INSERT INTO tbl_board
VALUES (board_seq.nextval, 'hong');

INSERT INTO tbl_board
VALUES (board_seq.nextval, 'admin');

SELECT * FROM tbl_board
WHERE bno = 32; -- F10의 결과: 인덱스를 통한 접근의 히스토리가 있음.

COMMIT;

-- 인덱스 이름 변경 (: 좀 더 쉽게 지목하기 위해서)
ALTER INDEX emp_board_idx
RENAME TO tbl_board_idx;

-- 인덱스 사용X
SELECT * FROM
    (
    SELECT ROWNUM AS rn, a.*
        FROM
        (
        SELECT *
        FROM tbl_board
        ORDER BY bno DESC
        ) a
    )
WHERE rn > 10 AND rn <= 20; 

-- /*+ INDEX(table_name index_name) */
-- 지정된 인덱스를 강제로 쓰게끔 지정.
-- INDEX ASC, DESC를 추가해서 내림차, 오름차 순으로 쓰게끔 지정 가능.
-- 오라클 문법


SELECT * FROM
    (
    SELECT /*+ INDEX_DESC(tbl_board tbl_board_idx) */
        ROWNUM AS rn,
        bno,
        writer
    FROM tbl_board
    )
WHERE rn > 10 AND rn <= 20;
/*
~주석을 통해~
1. 옵티마이저한테 tbl_board_idx를 사용해서 인덱스를 통해 조회하라고 강제 명령
2. INDEX_DESC를 통해 primary key인 bno를 내림차순정렬을 먼저 한다. -> ORDER BY절이 필요없음
3. 그 내림차순의 순서대로 ROWNUM을 붙여달라! 라는 쿼리문
이렇게 작성하면 3단 서브쿼리문까지 작성하지 않아도 된다는 이점이 있다!
*/
/*
인덱스는 primary key로 작성하는 순간 생겼음
*/
/*
- 인덱스가 권장되는 경우 
1. 컬럼이 WHERE 또는 조인조건에서 자주 사용되는 경우 (= 인덱스를 사용하는 이유)
2. 열이 광범위한 값을 포함하는 경우ㄹ
3. 테이블이 대형인 경우
4. 타겟 컬럼이 많은 수의 null값을 포함하는 경우. -> 인덱스가 널값인 데이터를 다 제거하고 조회하기 때문에
5. 테이블이 자주 수정되고(= 인덱스도 자주 수정된다는 의미)
   이미 하나 이상의 인덱스를 가지고 있는 경우에는
   권장하지 않습니다.
*/





-- 