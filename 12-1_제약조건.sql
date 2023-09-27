
-- 제약 조건을 걸어줘야함: 중복값방지, NULL값방지 등등

-- 테이블 생성과 제약조건(CONSTRAINT)
-- : 테이블의 부적절한 데이터가 입력되는 것을 방지하기 위해 규칙을 설정하는 것.

-- 테이블 열레벨 제약조건 (PRIMARY KEY, UNIQUE, NOT NULL, FOREIGN KEY, CHECK)
-- PRIMARY KEY: 테이블의 고유 식별 컬럼입니다. (주요 키), (UNIQUE+NOT NULL)
-- UNIQUE: 유일한 값을 갖게 하는 컬럼 (중복값 방지)
-- NOT NULL: null을 허용하지 않음.
-- FOREIGN KEY: 참조하는 테이블의 PRIMARY KEY를 저장하는 컬럼
-- CHECK: 정의된 형식만 저장되도록 허용.

-- 테이블을 세팅할 때 많이 제약 조건을 건다.

-- 먼저 테이블 생성

-- 1. 컬럼 레벨 제약 조건(컬럼 선언마다 제약조건 지정)
/*
기록용
CREATE TABLE dept2 (
    dept_no NUMBER(2) CONSTRAINT dept2_deptno_pk PRIMARY KEY, --> dept2_deptno_pk: 나중에 제약조건을 지목할 때 사용
    dept_name VARCHAR(14) NOT NULL CONSTRAINT dept2_deptname_uk UNIQUE, -- NULL값 허용X -> 필수 값이라는 의미
    loca NUMBER(4) CONSTRAINT dept2_loca_locid_fk REFERENCES locations(location_id), -- FOREIGN KEY의 제약조건을 거는 것
    -- ㄴ> 해석: locations테이블의 location_id로 존재하지 않는 데이터는 dept2테이블에 loca컬럼에 저장될 수 없다. -> 관계형DB의 안정성을 위한 조건제약
    dept_bonus NUMBER(10) CONSTRAINT dept2_bonus_ck CHECK(dept_bonus > 0), -- CHECK라는 제약조건을 통해 0초과의 값만 받을 수 있다.
    dept_gender VARCHAR(1) CONSTRAINT dept2_gender_ck CHECK(dept_gender_ IN('M', 'F'))
);
*/
-- 컬럼 레벨 제약 조건 (컬럼 선언마다 제약조건 지정)
CREATE TABLE dept2 (
    dept_no NUMBER(2) CONSTRAINT dept2_deptno_pk PRIMARY KEY,
    dept_name VARCHAR2(14) NOT NULL CONSTRAINT dept2_deptname_uk UNIQUE,
    loca NUMBER(4) CONSTRAINT dept2_loca_locid_fk REFERENCES locations(location_id),
    dept_bonus NUMBER(10) CONSTRAINT dept2_bonus_ck CHECK(dept_bonus > 0),
    dept_gender VARCHAR2(1) CONSTRAINT dept2_gender_ck CHECK(dept_gender IN('M', 'F'))
);
-- 이렇게 거는 방법이 있고 다른 방법도 있다.

DROP TABLE dept2;

-- 테이블 레벨 제약 조건 (모든 열 선언 후 제약 조건을 취하는 방식)
ROLLBACK;
CREATE TABLE dept2 (
    dept_no NUMBER(2),
    dept_name VARCHAR(14) NOT NULL, -- 이렇게 따로 선언해 주는 것이 좋다.
    loca NUMBER(4),
    dept_bonus NUMBER(10),
    dept_gender VARCHAR2(1),
    
    CONSTRAINT dept2_deptno_pk PRIMARY KEY(dept_no),
    CONSTRAINT dept2_deptname_uk UNIQUE(dept_name),
    CONSTRAINT dept2_loca_locid_fk FOREIGN KEY(loca) REFERENCES locations(location_id),
    CONSTRAINT dept2_bonus_ck CHECK(dept_bonus > 0),
    CONSTRAINT dept2_gender_ck CHECK(dept_gender IN('M', 'F'))
);
-- CHECK는 이미 조건에 컬럼명을 제시해 줬기 때문에 따로 작성하지 않아도O

-- 설정한 제약 조건이 잘 지켜지는지 확인
-- 외래 키(foreign key)가 부모 테이블(참조 테이블)에 없다면 INSERT가 불가능
INSERT INTO dept2
VALUES (10, 'GG', 3000, 100000, 'M'); -- error: 4000이 외래 키 제약조건 위반 / 수정: 4000 -> 3000

INSERT INTO dept2
VALUES (20, 'hh', 1900, 100000, 'M'); -- error: 위와 똑같은 pk / 수정: 10 -> 20

UPDATE dept2
SET loca = 4000
WHERE dept_no = 10; -- error: parent key not found(외래 키 제약조건 위반)

-- 제약 조건을 변경
-- 제약 조건은 추가, 삭제만 가능합니다. 변경은 안됩니다.
-- 변경하려면 삭제하고 새로운 내용으로 추가하셔야 합니다.

CREATE TABLE dept2 (
    dept_no NUMBER(2),
    dept_name VARCHAR(14) NOT NULL,
    loca NUMBER(4),
    dept_bonus NUMBER(10),
    dept_gender VARCHAR2(1)
);

-- pk 추가
ALTER TABLE dept2 ADD CONSTRAINT dept_no_pk PRIMARY KEY(dept_no); -- 제약조건 추가는 수정하는 범위에 포함된다.
-- fk 추가
ALTER TABLE dept2 ADD CONSTRAINT dept2_loca_locid_fk
FOREIGN KEY(loca) REFERENCES locations(location_id);
-- check 추가
ALTER TABLE dept2 ADD CONSTRAINT dept2_bonus_ck CHECK(dept_bonus > 0);
-- unique 추가
ALTER TABLE dept2 ADD CONSTRAINT dept2_deptname_uk UNIQUE(dept_name);
-- NOT NULL은 열 수정형태로 변경합니다.
ALTER TABLE dept2 MODIFY dept_bonus NUMBER(10) NOT NULL;

-- 제약 조건 확인
SELECT * FROM user_constraints
WHERE table_name = 'DEPT2';

-- 제약 조건 삭제 (제약 조건 이름으로 삭제하면 된다)
-- 제약 조건이 삭제되는 것도 테이블이 변경되는 것이기 때문에 alter
ALTER TABLE DEPT2 DROP CONSTRAINT dept_no_pk;

COMMIT;

-- 1번 문제
CREATE TABLE MEMBERS(
    m_name VARCHAR2(3) NOT NULL,
    m_num NUMBER(1),
    reg_date DATE,
    gender VARCHAR2(1),
    loca NUMBER(4),
    
    CONSTRAINT mem_memnum_pk PRIMARY KEY(m_num),
    CONSTRAINT mem_regdate_uk UNIQUE(reg_date),
    CONSTRAINT mem_gender_ck CHECK(gender IN('M', 'F')),
    CONSTRAINT mem_loca_loc_locid_fk FOREIGN KEY(loca) REFERENCES locations(location_id)
);

SELECT * FROM user_constraints
WHERE table_name = 'MEMBERS';

INSERT INTO MEMBERS
VALUES ('DDD', 4, sysdate, 'M', 2000);

ALTER TABLE MEMBERS MODIFY reg_date DATE NOT NULL;

-- 2번 문제
SELECT
    m.m_name, m.m_num,
    l.street_address, l.location_id
FROM MEMBERS m JOIN locations l
ON m.loca = l.location_id
ORDER BY m_num;














