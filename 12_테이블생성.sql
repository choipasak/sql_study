
-- ���̺� ���� (�÷��� �÷�Ÿ��)
/*
# �÷� Ÿ�� ����
- NUMBER(2) -> ������ 2�ڸ����� ������ �� �ִ� ������ Ÿ��.(���� �Ǽ� ����X)
- NUMBER(5, 2) -> ������, �Ǽ��θ� ��ģ �� �ڸ��� 5�ڸ�(�Ҽ��� ����), �Ҽ��� 2�ڸ����� �޴´�
- NUMBER -> ��ȣ�� ������ �� (38, 0)���� �ڵ� �����˴ϴ�.
- VARCHAR2(byte) -> ��ȣ �ȿ� ���� ���ڿ��� �ִ� ���̸� ����. (4000byte���� �ޱ� ����), ������(���ڱ��̿� ���缭 ũ�Ⱑ ������)�̾ �����
- CLOB -> ��뷮 �ؽ�Ʈ ������ Ÿ�� (�ִ� 4Gbyte) - ���ڿ� ����
- BLOB -> ������ ��뷮 ��ü (�̹���, ���� ���� �� ���) - ����Ʈ ������ ���� -> ����X: DB�뷮�� ��μ� ��η� ��ü�ؼ� ����
- DATE -> BC 4712�� 1�� 1�� ~ AD 9999�� 12�� 31�ϱ��� ���� ����
- ��, ��, �� ���� ����.
*/
ROLLBACK;
CREATE TABLE dept2 (
    dept_no NUMBER(2),
    dept_name VARCHAR(14),
    loca VARCHAR(15),
    dept_date DATE,
    dept_bonus NUMBER(10) -- ���ϴ��÷��� �ش��÷���Ÿ��(�÷��� ��������)
);
-- DDL - CREATE, ALTER, DROP, TRUNCATE���� ������ ���Ǿ�� Ʈ������� ������ ���� �ʴ´�.
-- ���� ��: CREATE�� �ѹ��� ����X -> �ѹ��ص� ���̺��� ������� �ʴ´�.
-- �׷��� DROP�̶�� ��ɾ ���� -> ����.�����Ұ�
-- DDL�� ��� ��ɾ�� �����ϴ� ���ÿ� �ڵ� Ŀ���� ����!

-- TABLE ����!
-- DML -> CRUD
-- DDL -> CREATE, ALTER(= UPDATE, CREATE�� ���� ���� ALTER�� �����Ѵ�.), DROP(= DELETE)
-- Ʈ����� TCL -> COMMIT, ROLLBACK, SAVEPOINT(����Ŭ ����)


DESC dept2; -- ���̺� ��ũ��Ʈ�� ����
SELECT * FROM dept2;

-- NUMBER�� VARCHAR2 Ÿ���� ���̸� Ȯ��.
INSERT INTO dept2
VALUES (30, '�濵����', '���', sysdate, 2000000);

-- �÷��߰�
ALTER TABLE dept2
ADD (dept2_count NUMBER(3));

-- �÷� �̸� ����
ALTER TABLE dept2
RENAME COLUMN dept2_count TO emp_count;

-- �÷� �Ӽ� ����(����)
-- ���� �����ϰ��� �ϴ� �÷��� �����Ͱ� �̹� �����Ѵٸ� �׿� �´� Ÿ������
-- ������ �ּž� �մϴ�. ���� �ʴ� Ÿ�����δ� ������ �Ұ����մϴ�.
ALTER TABLE dept2
MODIFY (dept_name VARCHAR2(100)); -- ������ ���� ���� ����

SELECT * FROM dept3;
DESC dept2;

-- �÷� ����
ALTER TABLE dept2
DROP COLUMN dept_bonus;

-- �÷� ���� ���̺� �̸� ����
ALTER TABLE dept2
RENAME TO dept3;
-- �����ϰ�
SELECT * FROM dept3; -- �� ��ȸ�ؾ� ���̺��� ��ȸ�� ������.

-- ���̺� ����(������ ���ܵΰ� ���� �����͸� ��� ����)
TRUNCATE TABLE DEPT3;

-- ���̺���� ����
DROP TABLE DEPT3;
ROLLBACK; -- �Ұ�
















