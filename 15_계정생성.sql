
-- ���� ����
-- ���� ������ ���� ���� ����� ���� Ȯ���� �غ���!
SELECT * FROM all_users;

-- ���� ���� ���
-- ID: user1, PW: user1 �� ������ �����غ���!
CREATE USER user1 IDENTIFIED BY user1; -- ERROR: insufficient privileges
-- ERROR -> ���� �� ����: hr -> hr������ ������ ������ ������ ���ٴ� �Ҹ�
-- system �������� ����! -> user1 ���� ����

/*
DCL[DATA CONTROLL LANGUAGE]
: GRANT(���� �ο�), REVOKE(���� ȸ��)

CREATE USER -> �����ͺ��̽� ���� ���� ����
CREATE SESSION -> �����ͺ��̽� ���� ����
CREATE TABLE -> ���̺� ���� ����
CREATE VIEW -> �� ���� ����
CREATE SEQUENCE -> ������ ���� ����
ALTER ANY TABLE -> ��� ���̺� ������ �� �ִ� ����
INSERT ANY TABLE -> ��� ���̺��� �����͸� �����ϴ� ����.
SELECT ANY TABLE...

SELECT ON [���̺� �̸�] TO [���� �̸�] -> Ư�� ���̺� ��ȸ�� �� �ִ� ����.
INSERT ON....
UPDATE ON....

- �����ڿ� ���ϴ� ������ �ο��ϴ� ����.
RESOURCE, CONNECT, DBA TO [���� �̸�]
*/
-- ���� user1���� DB���� ���� �ο�
GRANT CREATE SESSION TO user1;

SELECT * FROM hr.departments; -- ���� system�����̿��� ��� ������ �� ������ ����.
-- cmd�� user1������ DB���� ���� �ۿ� ����
-- �׷� user1�� hr������ ������ �ִ� departments���̺��� ��ȸ ������ �ο� �ϰڴ�!
GRANT SELECT ON hr.departments TO user1;

-- user1���� hr.department�� INSERT�� ���� �ο�
GRANT INSERT ON hr.departments TO user1;

-- user1���� ���̺� ���� ���� �ο�
GRANT CREATE TABLE TO user1;
-- ���̺��� �����Ǹ� users��� tablespace��� ������ ������ �Ǵµ�
-- �����Ϸ��� ���� �ʿ�
ALTER USER user1
DEFAULT TABLESPACE users
QUOTA UNLIMITED ON users;

-- ��� ���̺��̵� �� ��ȸ ���� ���� �ο�
GRANT SELECT ANY TABLE TO user1;

-- �׳� �ѹ��� ������ ���� �ο�
GRANT RESOURCE, CONNECT, DBA TO user1; -- system�� ���� ���� ����

-- ���� ȸ��
REVOKE RESOURCE, CONNECT, DBA FROM user1;

-- ����� ���� ����
DROP USER user1;
-- error1: cannot drop a user that is currently connected -> ���� �������̿��� DROP�Ұ�
-- error2: CASCADE must be specified to drop '%s' -> �� ������ ��ü�� ������ ������ �Ժη� ���� ������
-- ��¥ ������� CASCADE�� �ٿ��� ������.

-- ����� ���� ����
-- DROP USER [�����̸�] CASCADE;
-- CASCADE ���� �� -> ���̺� or ������ �� ��ü�� �����Ѵٸ� ���� ���� �ȵ�.
DROP USER user1 CASCADE; -- ����

/*
TABLESPACE
���̺� �����̽��� �����ͺ��̽� ��ü �� ���� �����Ͱ� ����Ǵ� �����Դϴ�.
���̺� �����̽��� �����ϸ� ������ ��ο� ���� ���Ϸ� ������ �뷮��ŭ��
������ ������ �ǰ�, �����Ͱ� ���������� ����˴ϴ�.
�翬�� ���̺� �����̽��� �뷮�� �ʰ��Ѵٸ� ���α׷��� ������������ �����մϴ�.
C����̺꿡 ���� ���� ���·� ����!(������)
*/
SELECT * FROM dba_tablespaces; -- ���� �����ϴ� ���̺��� ������

CREATE USER test1 IDENTIFIED BY test1;
GRANT CREATE SESSION TO test1;
GRANT CONNECT, RESOURCE TO test1;
-- test1�� ���� ���̺��� ���� USER_TABLESPACE�� ����ǰ� �ϰڴ�
--> ����: user_tablespace ���̺� �����̽��� �⺻ ��� �������� �����ϰ� ��뷮 ����.
ALTER USER test1 DEFAULT TABLESPACE user_tablespace
QUOTA 10M ON user_tablespace; -- test1������ user_tablespace���� �ִ� 10 �ް�����Ʈ �� �� �ְ� �ϰڴ�!
-- or
ALTER USER test1 DEFAULT TABLESPACE user_tablespace
QUOTA UNLIMITED ON user_tablespace; -- ���뷮 �������� X

-- ���̺� �����̽� ���� ��ü�� ��ü ����(������ ������ ����)
DROP TABLESPACE user_tablespace INCLUDING CONTENTS;

-- ������ ���ϱ��� �� ���� �����ϴ� ��
DROP TABLESPACE user_tablespace INCLUDING CONTENTS AND DATAFILES;











