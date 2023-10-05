
/*
trigger�� ���̺� ������ ���·ν�, INSERT, UPDATE, DELETE �۾��� ����� ��
Ư�� �ڵ尡 �۵��ǵ��� �ϴ� �����Դϴ�.
VIEW���� ������ �Ұ����մϴ�.
trigger�� ��ü�̴� -> ����(create)

Ʈ���Ÿ� ���� �� ���� �����ϰ� F5��ư���� �κ� �����ؾ� �մϴ�.
�׷��� ������ �ϳ��� �������� �νĵǾ� ���� �������� �ʽ��ϴ�.

Ư�� �۾��� �ڵ�ȭ �� �� ����Ѵ�.
����) INSERT�ϱ� ���� ~����, A���̺� UPDATE�Ǹ� B���̺� ���� UPDATE���� ���
*/

CREATE TABLE tbl_test(
    id NUMBER(10),
    text VARCHAR2(20)
);

-- trigger ����
CREATE OR REPLACE TRIGGER trg_test
    AFTER DELETE OR UPDATE -- Ʈ������ �߻� ����. (���� Ȥ�� ���� ���Ŀ� �����ض�)
    ON tbl_test -- Ʈ���Ÿ� ������ ���̺� ����
    FOR EACH ROW -- '�� ���� ��� �����ϰڴ�' ��� �ǹ�. (���� ����, ���� �� �� ���� ����)
DECLARE -- ����� (����X -> ���� ����)
    
BEGIN -- �����
    dbms_output.put_line('Ʈ���Ű� ������!'); -- �����ϰ��� �ϴ� �ڵ带 begin ~ end �� ����.
END; -- �����

-- Ʈ���Ŵ� ȣ���ϴ� ���� �ƴ�.
-- Ʈ������ �������� �ɾ��� �̺�Ʈ�� �����ؾ� ��
INSERT INTO tbl_test VALUES (1, '�����');

SELECT * FROM tbl_test;

UPDATE tbl_test
SET test = '����'
WHERE id = 1; -- ���: 1 �� ��(��) ������Ʈ�Ǿ����ϴ�. Ʈ���Ű� ������!

DELETE FROM tbl_test WHERE id = 1; -- ���: 1 �� ��(��) �����Ǿ����ϴ�. Ʈ���Ű� ������! 




















