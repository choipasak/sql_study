
-- ���� ������ �ɾ������: �ߺ�������, NULL������ ���

-- ���̺� ������ ��������(CONSTRAINT)
-- : ���̺��� �������� �����Ͱ� �ԷµǴ� ���� �����ϱ� ���� ��Ģ�� �����ϴ� ��.

-- ���̺� ������ �������� (PRIMARY KEY, UNIQUE, NOT NULL, FOREIGN KEY, CHECK)
-- PRIMARY KEY: ���̺��� ���� �ĺ� �÷��Դϴ�. (�ֿ� Ű), (UNIQUE+NOT NULL)
-- UNIQUE: ������ ���� ���� �ϴ� �÷� (�ߺ��� ����)
-- NOT NULL: null�� ������� ����.
-- FOREIGN KEY: �����ϴ� ���̺��� PRIMARY KEY�� �����ϴ� �÷�
-- CHECK: ���ǵ� ���ĸ� ����ǵ��� ���.

-- ���̺��� ������ �� ���� ���� ������ �Ǵ�.

-- ���� ���̺� ����

-- 1. �÷� ���� ���� ����(�÷� ���𸶴� �������� ����)
/*
��Ͽ�
CREATE TABLE dept2 (
    dept_no NUMBER(2) CONSTRAINT dept2_deptno_pk PRIMARY KEY, --> dept2_deptno_pk: ���߿� ���������� ������ �� ���
    dept_name VARCHAR(14) NOT NULL CONSTRAINT dept2_deptname_uk UNIQUE, -- NULL�� ���X -> �ʼ� ���̶�� �ǹ�
    loca NUMBER(4) CONSTRAINT dept2_loca_locid_fk REFERENCES locations(location_id), -- FOREIGN KEY�� ���������� �Ŵ� ��
    -- ��> �ؼ�: locations���̺��� location_id�� �������� �ʴ� �����ʹ� dept2���̺� loca�÷��� ����� �� ����. -> ������DB�� �������� ���� ��������
    dept_bonus NUMBER(10) CONSTRAINT dept2_bonus_ck CHECK(dept_bonus > 0), -- CHECK��� ���������� ���� 0�ʰ��� ���� ���� �� �ִ�.
    dept_gender VARCHAR(1) CONSTRAINT dept2_gender_ck CHECK(dept_gender_ IN('M', 'F'))
);
*/
-- �÷� ���� ���� ���� (�÷� ���𸶴� �������� ����)
CREATE TABLE dept2 (
    dept_no NUMBER(2) CONSTRAINT dept2_deptno_pk PRIMARY KEY,
    dept_name VARCHAR2(14) NOT NULL CONSTRAINT dept2_deptname_uk UNIQUE,
    loca NUMBER(4) CONSTRAINT dept2_loca_locid_fk REFERENCES locations(location_id),
    dept_bonus NUMBER(10) CONSTRAINT dept2_bonus_ck CHECK(dept_bonus > 0),
    dept_gender VARCHAR2(1) CONSTRAINT dept2_gender_ck CHECK(dept_gender IN('M', 'F'))
);
-- �̷��� �Ŵ� ����� �ְ� �ٸ� ����� �ִ�.

DROP TABLE dept2;

-- ���̺� ���� ���� ���� (��� �� ���� �� ���� ������ ���ϴ� ���)
ROLLBACK;
CREATE TABLE dept2 (
    dept_no NUMBER(2),
    dept_name VARCHAR(14) NOT NULL, -- �̷��� ���� ������ �ִ� ���� ����.
    loca NUMBER(4),
    dept_bonus NUMBER(10),
    dept_gender VARCHAR2(1),
    
    CONSTRAINT dept2_deptno_pk PRIMARY KEY(dept_no),
    CONSTRAINT dept2_deptname_uk UNIQUE(dept_name),
    CONSTRAINT dept2_loca_locid_fk FOREIGN KEY(loca) REFERENCES locations(location_id),
    CONSTRAINT dept2_bonus_ck CHECK(dept_bonus > 0),
    CONSTRAINT dept2_gender_ck CHECK(dept_gender IN('M', 'F'))
);
-- CHECK�� �̹� ���ǿ� �÷����� ������ ��� ������ ���� �ۼ����� �ʾƵ�O

-- ������ ���� ������ �� ���������� Ȯ��
-- �ܷ� Ű(foreign key)�� �θ� ���̺�(���� ���̺�)�� ���ٸ� INSERT�� �Ұ���
INSERT INTO dept2
VALUES (10, 'GG', 3000, 100000, 'M'); -- error: 4000�� �ܷ� Ű �������� ���� / ����: 4000 -> 3000

INSERT INTO dept2
VALUES (20, 'hh', 1900, 100000, 'M'); -- error: ���� �Ȱ��� pk / ����: 10 -> 20

UPDATE dept2
SET loca = 4000
WHERE dept_no = 10; -- error: parent key not found(�ܷ� Ű �������� ����)

-- ���� ������ ����
-- ���� ������ �߰�, ������ �����մϴ�. ������ �ȵ˴ϴ�.
-- �����Ϸ��� �����ϰ� ���ο� �������� �߰��ϼž� �մϴ�.

CREATE TABLE dept2 (
    dept_no NUMBER(2),
    dept_name VARCHAR(14) NOT NULL,
    loca NUMBER(4),
    dept_bonus NUMBER(10),
    dept_gender VARCHAR2(1)
);

-- pk �߰�
ALTER TABLE dept2 ADD CONSTRAINT dept_no_pk PRIMARY KEY(dept_no); -- �������� �߰��� �����ϴ� ������ ���Եȴ�.
-- fk �߰�
ALTER TABLE dept2 ADD CONSTRAINT dept2_loca_locid_fk
FOREIGN KEY(loca) REFERENCES locations(location_id);
-- check �߰�
ALTER TABLE dept2 ADD CONSTRAINT dept2_bonus_ck CHECK(dept_bonus > 0);
-- unique �߰�
ALTER TABLE dept2 ADD CONSTRAINT dept2_deptname_uk UNIQUE(dept_name);
-- NOT NULL�� �� �������·� �����մϴ�.
ALTER TABLE dept2 MODIFY dept_bonus NUMBER(10) NOT NULL;

-- ���� ���� Ȯ��
SELECT * FROM user_constraints
WHERE table_name = 'DEPT2';

-- ���� ���� ���� (���� ���� �̸����� �����ϸ� �ȴ�)
-- ���� ������ �����Ǵ� �͵� ���̺��� ����Ǵ� ���̱� ������ alter
ALTER TABLE DEPT2 DROP CONSTRAINT dept_no_pk;

COMMIT;

-- 1�� ����
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

-- 2�� ����
SELECT
    m.m_name, m.m_num,
    l.street_address, l.location_id
FROM MEMBERS m JOIN locations l
ON m.loca = l.location_id
ORDER BY m_num;














