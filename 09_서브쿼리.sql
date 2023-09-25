
/*
�����?
- ������ ����

�������� ���
- ��𿡳� �� �� ����(WHERE, SELECT(COLUMN), TABLE)
- �������� �ۼ��ϱ� ���� �ʿ��� �����˻� �������� WHERE���� �׳� ���� �������� �ް� �ʹ�.
- ��ȸ�� ����� �������� �������� �ۼ��Ұ� ���� ��
- ��ȸ�� ����� ��� �ʿ������� ���� �ۼ��ϴ� ��ġ�� �ٸ�

-------------------------------------------------------

! ��� !

# �������� 
: SQL ���� �ȿ� �� �ٸ� SQL�� �����ϴ� ���.
���� ���� ���Ǹ� ���ÿ� ó���� �� �ֽ��ϴ�.
WHERE, SELECT, FROM ���� �ۼ��� �����մϴ�.

- ���������� ������� () �ȿ� �����.
 ������������ �������� 1�� ���Ͽ��� �մϴ�.
- �������� ������ ���� ����� �ϳ� �ݵ�� ���� �մϴ�.
- �ؼ��� ���� ���������� ���� ���� �ؼ��ϸ� �˴ϴ�.
*/

SELECT salary FROM employees
WHERE first_name = 'Nancy';

SELECT first_name FROM employees
WHERE salary > '12008';
-- 'Nancy'�� �޿����� �޿��� ���� ����� �˻��ϴ� ����.

SELECT first_name FROM employees
WHERE salary > (SELECT salary FROM employees
                WHERE first_name = 'Nancy');

-- employee_id�� 103���� ����� job_id�� ������ job_id�� ���� ����� ��ȸ.
SELECT * FROM employees
WHERE job_id = (SELECT job_id FROM employees
                WHERE employee_id = 103);
-- ������������ ������ �������� ���� �ϼ��� �ȴ�.
-- �ۼ� ����� �����������ۼ� -> �ڸ��� -> �ܺ����������� -> WHERE���� ���������� ����.

SELECT * FROM employees
WHERE job_id = (SELECT job_id FROM employees
                WHERE job_id = 'IT_PROG'); -- ERROR: single-row subquery returns more than one row
-- ERROR: ������ �������� ������ ������ �Ѱ��� ����ϴµ� 1�� �̻��� �����Ͱ� �����Ǿ��ٴ� ����(job_id = 'IT_PROG' ��ȸ -> 5��)
-- ����: ���� ������ ���������� �����ϴ� ���� ���� ���� ������ �����ڸ� ����� �� �����ϴ�.
-- ���� �� ������: �ַ� �� ������ (=, >, <, >=, <=, <>)�� ����ϴ� ��� �ϳ��� �ุ ��ȯ�ؾ� �մϴ�.
--> ���������� �տ� job_id = �� ����߱� ������ 1���� �����͸� �Ծ�� �ߴ�.
-- �̷� ��쿡�� ������ �����ڸ� ����ؾ� �մϴ�.

-- ���� �� ������: (IN, ANY, ALL)
-- 1. IN: ��ȸ�� ����� � ���� ���� ���� Ȯ���մϴ�.
SELECT * FROM employees
WHERE job_id IN (SELECT job_id FROM employees
                 WHERE job_id = 'IT_PROG');

-- first_name�� David�� ������� �޿�(4800, 9500, 6800)�� ���� �޿��� �޴� ������� ��ȸ.
SELECT * FROM employees
WHERE salary IN (SELECT salary FROM employees
                 WHERE first_name = 'David');



























