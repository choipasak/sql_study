/*
# ������ (�߿�)
- �Ϸ��� �������� �����Ǿ� �ִ�!
- ������ (���������� �����ϴ� ���� ����� �ִ� ��ü) -> ����) ����Ʈ
���� ������� �ʾƵ� �ȴ�.
�������� �˾Ƽ� �ߺ����� ������ �������� ��ȣ�� �ٿ��ش�.
�������� ��ü�̱� ������ CREATE�� ����ؾ� �Ѵ�.
���������� �����ϰ� ���� ���� ���� -> INCREMENT�� ������ ������ �ָ� �ȴ�.
*/

-- �����ϸ� ���� �� ������ ����!
-- ������ ���� MINVALUE��� X, ������ ���� MAXVALUE��� X �ϴ� ���� �ִ�!
CREATE SEQUENCE dept2_seq
    START WITH 1 -- ���۰� (�ۼ����� ���� ����. �⺻���� ������ �� �ּҰ�, ������ �� �ִ밪)
    INCREMENT BY 1 -- ������ (����� ����, ������ ����, �⺻�� 1)
    MAXVALUE 10 -- �ִ밪 (�⺻��: ������ �� 1027, ������ �� -1)
    MINVALUE 1 -- �ּҰ� (�⺻��: ������ �� 1, ������ �� -1028)
    NOCACHE -- ĳ�ø޸� ��� ���� (�⺻��: CACHE): ���������� ������ ����ŭ�� �̸� �����ش�. �� 1~40������ ���ͼ� ĳ�ø޸𸮿� ������ ���´� -> ȣ��� ������ ���Դ� ��ȣ�� �ٿ���. �ٵ� ���߰��������� �� ������� ����. ERROR�������� ���� ĳ�ð� �� ����.
    NOCYCLE; -- ��ȯ ���� (NOCYCLE�� �⺻, ��ȯ��Ű���� CYCLE)

/*
NOCACHE
ĳ�ø޸� ��� ���� (�⺻��: CACHE)
���������� ������ ����ŭ�� �̸� �����ش�. �׷��� ������ ����
�� 1~40������ ���ͼ� ĳ�ø޸𸮿� ������ ���´� -> ȣ��� ������ ���Դ� ��ȣ�� �ٿ���.
�ٵ� ���߰��������� �� ������� ����.
��: ERROR�������� ���� ĳ�ð� �� ���� �׸��� ���ο� ĳ��(�� 40�� ����)�� �޾ƿ�.
�׷� �������� �� ���� ���� ĳ���� ����+1 �� ��ȣ���� ������
*/

DROP TABLE dept2;

CREATE TABLE dept2(
    dept_no NUMBER(2) PRIMARY KEY, -- ���������� �÷��޶�� �غ���!
    dept_name VARCHAR2(14),
    loca VARCHAR2(13),
    dept_date DATE
);

-- ������ ����ϱ�! (NEXTVAL(������), CURRVAL)
INSERT INTO dept2
VALUES(dept2_seq.NEXTVAL, 'test', 'test', sysdate);
-- ������ ������ ERROR: sequence DEPT2_SEQ.NEXTVAL exceeds MAXVALUE and cannot be instantiated
-- MAXVALUE�� �������� �ʰ� + dept2_seq�� �Ӽ��� NOCYCLE�̶�� �����ؼ� �������� �����ٴ� �ǹ�
-- PRIMARY KEY�� �����ϴ� �������� �ߺ��� ����ϸ� �ȵǱ� ������ �ݵ�� NOCYCLE�� ������ ��� �Ѵ�!

SELECT * FROM dept2;

SELECT dept2_seq.CURRVAL FROM dual; -- ���� �������� ������� �ö󰬴��� �˷���

-- ������ ���� (���� ���� ����)
-- START WITH(���۰�)�� ������ �Ұ����մϴ�.
ALTER SEQUENCE dept2_seq MAXVALUE 9999; -- �������� �ִ� ���� ��������
-- ������ ����
ALTER SEQUENCE dept2_seq INCREMENT BY -1;
-- �ּҰ� ����
ALTER SEQUENCE dept2_seq MINVALUE 0;
-- �ٽ� INSERT �׽�Ʈ

-- ������ ���� �ٽ� ó������ ������ ���
-- ������ ������ ����ŭ ���� �����ش�.
ALTER SEQUENCE dept2_seq INCREMENT BY -121;
SELECT dept2_seq.NEXTVAL FROM dual;
ALTER SEQUENCE dept2_seq INCREMENT BY 1; -- �ٽ� 1���� ����

-- �ٵ� �������� �ʱ�ȭ ��Ű�� �ʹ� -> �׳� �ʱ�ȭ. ������ ���� �� �����
DROP SEQUENCE dept2_seq;

----------------------------------------------------------------------------

/*
- index
index�� primary key, unique ���� ���ǿ��� �ڵ����� �����ǰ�,
��ȸ�� ������ �� �ִ� hint ������ �մϴ�.
index�� ��ȸ�� ������ ������, �������ϰ� ���� �ε����� �����ؼ�
����ϸ� ������ ���� ���ϸ� ����ų �� �ֽ��ϴ�.
���� �ʿ��� ���� index�� ����ϴ� ���� �ٶ����մϴ�.
�׷��� PRIMARY KEY�� ���ؼ� ��ȸ�ϴ� ���̴�.
*/
-- ��Ƽ�������� �ε����� ����ϸ� ��� �����ϴ��� �� �� ����(F10)
SELECT * FROM employees WHERE salary = 12008;

-- �ε��� ����
-- emp_salary_id�� employees�� salary�� ���̰ڴ�!
CREATE INDEX emp_salary_idx ON employees(salary);
-- �ε����� ����ϸ� salary�� ���ȣ�� ����
-- �Ȱ��� ��ȸ���� �������� ��, ���̺��� Ǯ ��ĵ�ؼ� ���ǿ� �´� �����͸� ��ȸ�ϴ°� �ƴ϶�
-- �ٷ� salary�� ���� ���� �ε����� Ž���ؼ� ��ȸ�ؿ´�.
/*
 !����
���̺� ��ȸ �� �ε����� ���� �÷��� �������� ����Ѵٸ�
���̺� ��ü ��ȸ�� �ƴ�, �÷��� ���� �ε����� �̿��ؼ� ��ȸ�� �����մϴ�.
�ε����� �����ϰ� �Ǹ� ������ �÷��� ROWID�� ���� �ε����� �غ�ǰ�,
��ȸ�� ������ �� �ش� �ε����� ROWID�� ���� ���� ��ĵ�� �����ϰ� �մϴ�.
*/

-- �ε��� ����
DROP INDEX emp_salary_idx;

-- �������� �ε����� ����ϴ� hint���
CREATE SEQUENCE board_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE; -- ������ ����

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
WHERE bno = 32; -- F10�� ���: �ε����� ���� ������ �����丮�� ����.

COMMIT;

-- �ε��� �̸� ���� (: �� �� ���� �����ϱ� ���ؼ�)
ALTER INDEX emp_board_idx
RENAME TO tbl_board_idx;

-- �ε��� ���X
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
-- ������ �ε����� ������ ���Բ� ����.
-- INDEX ASC, DESC�� �߰��ؼ� ������, ������ ������ ���Բ� ���� ����.
-- ����Ŭ ����


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
~�ּ��� ����~
1. ��Ƽ���������� tbl_board_idx�� ����ؼ� �ε����� ���� ��ȸ�϶�� ���� ���
2. INDEX_DESC�� ���� primary key�� bno�� �������������� ���� �Ѵ�. -> ORDER BY���� �ʿ����
3. �� ���������� ������� ROWNUM�� �ٿ��޶�! ��� ������
�̷��� �ۼ��ϸ� 3�� �������������� �ۼ����� �ʾƵ� �ȴٴ� ������ �ִ�!
*/
/*
�ε����� primary key�� �ۼ��ϴ� ���� ������
*/
/*
- �ε����� ����Ǵ� ��� 
1. �÷��� WHERE �Ǵ� �������ǿ��� ���� ���Ǵ� ��� (= �ε����� ����ϴ� ����)
2. ���� �������� ���� �����ϴ� ��줩
3. ���̺��� ������ ���
4. Ÿ�� �÷��� ���� ���� null���� �����ϴ� ���. -> �ε����� �ΰ��� �����͸� �� �����ϰ� ��ȸ�ϱ� ������
5. ���̺��� ���� �����ǰ�(= �ε����� ���� �����ȴٴ� �ǹ�)
   �̹� �ϳ� �̻��� �ε����� ������ �ִ� ��쿡��
   �������� �ʽ��ϴ�.
*/





-- 