
SELECT * FROM employees;

-- WHERE�� �� (������ ���� ��/�ҹ��ڸ� �����մϴ�.)
SELECT first_name, last_name, job_id
FROM employees
WHERE job_id = 'IT_PROG'; -- job_id �� 'IT PROG'�� ����� �˻��ϴ� ����

SELECT * FROM employees -- 2���� ������, ��� �÷� ���
WHERE last_name = 'King';

SELECT *
FROM employees
WHERE department_id = 90;

SELECT *
FROM employees
WHERE salary >= 15000
AND salary < 20000;

SELECT * FROM employees
WHERE hire_date = '04/01/30';

-- ������ �� ����
SELECT * FROM employees
WHERE salary BETWEEN 15000 AND 20000;

SELECT * FROM employees
WHERE hire_date BETWEEN '03/01/01' AND '03/12/31';

-- IN ������ ��� (Ư�� ����� ���� �� ���)
SELECT * FROM employees
WHERE manager_id IN (100,101,102); -- ()�ȿ� �ش��ϸ� �� ������!


SELECT * FROM employees
WHERE job_id IN ('IT_PROG', 'AD_VP'); -- ()�ȿ� �ش��ϸ� �� ������!

-- LIKE ������
-- %�� ��� ���ڵ�, _�� �������� �ڸ�(��ġ)�� ã�Ƴ� ��
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date LIKE '03%'; -- hire_date�� '03%'�� ���ٸ�(03%: 03���� �����ϴ� ���� ����), 

SELECT first_name, hire_date
FROM employees
WHERE hire_date LIKE '%15'; -- '%15': �տ� ���� ������ �������� 15��� �� �ҷ��Ͷ�

SELECT first_name, hire_date
FROM employees
WHERE hire_date LIKE '%05%'; -- 05�� �� �ڿ� ���ڰ� ���� �ȿ��� 05�� ���ڿ��� ������(��ġ ���X) ����Ͷ�!

-- ���� �ڸ��� ���� ã�� ���ڿ��� ���ԵǾ� �ִ���
SELECT first_name, hire_date
FROM employees
WHERE hire_date LIKE '___05%'; -- _�� 3�� �ٿ��� /���� 3�ڸ� ���Ŀ�(= ���� 05��) 05�� �����͸� ��ȸ�ϰ� �ʹ�

-- AND, OR
-- AND�� OR���� ���� ������ ����.
SELECT * FROM employees
WHERE (job_id = 'IT_PROG'
OR job_id = 'FI_MGR')
AND salary >= 6000; -- �� ������ ��ȸ�ϰ� Ȯ�� ���ֱ�!

-- �������� ���� (SELECT ������ ���� �������� ��ġ�˴ϴ�.)
-- ASC: ascending ��������
-- DESC: descending ��������
SELECT * FROM employees
ORDER BY hire_date ASC; -- hire_date�� ���� ������ ū������ ������� �����ؼ� �����ּ���

SELECT * FROM employees
ORDER BY hire_date DESC;

SELECT * FROM employees
ORDER BY hire_date;

SELECT * FROM employees
WHERE job_id = 'IT_PROG'-- ��ȸ�ϰ� ����
ORDER BY first_name ASC;-- �������� �����Ѵ�.

SELECT * FROM employees
WHERE salary >= 5000
ORDER BY employee_id DESC;

SELECT
    first_name,
    salary*12 AS pay
FROM employees
ORDER BY pay ASC;




