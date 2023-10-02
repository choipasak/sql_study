
/*
# PL/SQL
- ����Ŭ���� �����ϴ� SQL ���α׷��� ����̴�.
- �Ϲ����� ���α׷��ְ��� ���̰� ������, ����Ŭ ���ο��� ������ ó���� ����
 ������ �� �� �ִ� ����������(����: �� -> �Ʒ�) �ڵ� �ۼ� ����Դϴ�.
- �������� �������� ��� ������ �ϰ� ó���ϱ� ���� �뵵�� ����մϴ�.
*/

-- �͸� ���

SET SERVEROUTPUT ON; -- ��¹� Ȱ��ȭ�� ���� ON������� �Ѵ�.

DECLARE -- ������ �����ϴ� ���� (�����)
    
    emp_num NUMBER; -- ����+Ÿ�� ����
    
BEGIN -- �ڵ带 �����ϴ� ���� ���� (�����)

    emp_num := 10; -- oracle�� ���Կ�����(:=)
    DBMS_OUTPUT.put_line(emp_num); -- �ڹ��� sop ���� ��.
    DBMS_OUTPUT.put_line('Hello pl/sql-!');
    
END; -- PL/SQL�� ������ ���� (�����)

-- ������
-- �Ϲ� SQL���� ��� �������� ����� �����ϰ�,
-- **�� ������ �ǹ��մϴ�.
DECLARE
    A NUMBER := 2**2*3**2;
BEGIN
    DBMS_OUTPUT.put_line('A: '|| TO_CHAR(A));
END; -- ��� A: 36

/*
- DML��
DDL���� ����� �Ұ����ϰ�, �Ϲ������� SQL���� SELECT ���� ����ϴµ�, 
Ư���� ���� SELECT�� �Ʒ��� INTO���� ����ؼ� ������ �Ҵ��� �� �ֽ��ϴ�.
*/

-- ����
DECLARE
    v_emp_name VARCHAR2(50); -- ����� ���� (���ڿ� ������ ���� ���� �ʿ�)
    v_dep_name VARCHAR2(50); -- �μ��� ����
BEGIN
    SELECT
        e.first_name,
        d.department_name
    INTO
        v_emp_name, v_dep_name -- ��ȸ ����� ������ ���� ����
    FROM employees e
    LEFT JOIN departments d
    ON e.department_id = d.department_id
    WHERE employee_id = 100;
    
    DBMS_OUTPUT.put_line(v_emp_name || '-' || v_dep_name);
    
END; -- ���: Steven-Executive
-- QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ. �ٵ� system����

-- �ش� ���̺�� ���� Ÿ���� �÷� ������ �����Ϸ���
-- ���̺��.�÷���%TYPE�� ��������ν� Ÿ���� ������ Ȯ���ؾ� �ϴ� ���ŷο��� ������ �� �ִ�.
DECLARE
    v_emp_name employees.first_name%TYPE; -- employees���̺��� first_name�÷��� Ÿ�԰� �Ȱ��� Ÿ���� ����
    v_dep_name employees.department_name%TYPE; -- ���̺� ã�ư��� Ÿ���� �˾� �� �ʿ䰡 ������!
BEGIN
    SELECT
        e.first_name,
        d.department_name
    INTO
        v_emp_name, v_dep_name -- ��ȸ ����� ������ ���� ����
    FROM employees e
    LEFT JOIN departments d
    ON e.department_id = d.department_id
    WHERE employee_id = 100;
    
    DBMS_OUTPUT.put_line(v_emp_name || '-' || v_dep_name);
    
END;






































