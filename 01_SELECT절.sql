
-- ����Ŭ�� �� �� �ּ��Դϴ�.

/*
���� �� �ּ��Դϴ�.
ȣ��
*/

-- SELECT [�÷���(���� �� ����)] FROM [���̺� �̸�]
SELECT * FROM employees; -- *: employees���� ��� �÷� �� ������

SELECT employee_id, first_name, last_name
FROM employees;

SELECT email, phone_number, hire_date
FROM employees;

-- �÷��� ��ȸ�ϴ� ��ġ���� * / + - ������ �����մϴ�.
SELECT 
    employee_id,
    first_name,
    last_name,
    salary,
    salary + salary*0.1 AS ������
FROM employees;

-- NULL���� Ȯ�� (���� 0�̳� �����̶��� �ٸ� �����Դϴ�.)
SELECT department_id, commission_pct
FROM employees;
-- null�� ��������� ���� �Ұ���
-- ���� �������� �ʴ� ���̴�.

-- alias, as(alias�� ���Ӹ�) (�÷���, ���̺���� �̸��� �����ؼ� ��ȸ�մϴ�.)
SELECT
    first_name AS �̸�,
    last_name AS ��,
    salary AS �޿�
FROM employees;

/*
    ����Ŭ�� Ȭ����ǥ�� ���ڸ� ǥ���ϰ�, ���ڿ� �ȿ� Ȭ����ǥ��
    ǥ���ϰ� �ʹٸ� ''�� �� �� �������� ���ø� �˴ϴ�.
    ������ �����ϰ� �ʹٸ� || �� ����մϴ�.
*/
--����Ŭ�� ���ڿ��� ���������� �������� �ʴ´�. -> || ���

SELECT
    -- first_name + ' ' + last_name�� ����
    first_name || ' ' || last_name || '''s salary is $' || salary
    AS �޿�����
FROM employees;

SELECT department_id FROM employees;

-- ��ȸ ����� �ߺ��� �����ؼ� ��ȸ���ְ� �ʹ�
-- DISTINCT (�ߺ� �� ����)
SELECT DISTINCT department_id FROM employees;

-- ROWNUM, ROWID
-- (**�ο��: ������ ���� ��ȯ�Ǵ� �� ��ȣ�� ���. ��ȸ�� ����� ��ȣ�� ����. �� ��ȣ�ʹ� �ٸ���.)
-- (**�ο���̵�: �����ͺ��̽� ���� ���� �ּҸ� ��ȯ. ����Ǿ� �ִ� �޸��� �ּ� ��)
-- ������ ���� ������ ������ ��ȸ�ؼ� �� �� ����
-- ��ȸ�� ����� ��ȣ�� ���̱� ������ �߰��� ROWNUM�� ������ �Ǿ 
-- ��ȣ�� ROW�� ���� ���� �ʰ� �Ǵ� ����� ���� �� �ִ�.
SELECT ROWNUM, ROWID, employee_id
FROM employees;


















