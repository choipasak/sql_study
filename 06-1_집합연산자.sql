
-- ���� ������
-- ���� �ٸ� ���� ����� ����� �ϳ��� ����, ��, ���̸� ���� �� �ְ� �� �ִ� ������
-- UNION(������ �ߺ�X), UNION ALL(������ �ߺ� O), INTERSECT(������), MINUS(������)
-- �� �Ʒ� column ������ ������ Ÿ���� ��Ȯ�� ��ġ�ؾ� �մϴ�.

-- UNION(������ �ߺ�X)
SELECT
    employee_id, first_name
FROM employees
WHERE hire_date LIKE '04%'
UNION -- �� �Ʒ��� ������ ��ģ��.
SELECT
    employee_id, first_name
FROM employees
WHERE department_id = 20;

-- UNION ALL(������ �ߺ� O)
SELECT
    employee_id, first_name
FROM employees
WHERE hire_date LIKE '04%'
UNION ALL
SELECT
    employee_id, first_name
FROM employees
WHERE department_id = 20;

-- INTERSECT(������)
SELECT
    employee_id, first_name
FROM employees
WHERE hire_date LIKE '04%'
INTERSECT
SELECT
    employee_id, first_name
FROM employees
WHERE department_id = 20;

-- MINUS(������): A - B
SELECT -- A
    employee_id, first_name
FROM employees
WHERE hire_date LIKE '04%'
MINUS
SELECT -- B
    employee_id, first_name
FROM employees
WHERE department_id = 20;

-- MINUS(������): B - A
SELECT -- B
    employee_id, first_name
FROM employees
WHERE department_id = 20
MINUS
SELECT -- A
    employee_id, first_name
FROM employees
WHERE hire_date LIKE '04%'
-- MINUS�� SELECT������ ��ġ�ؾ� �Ѵ�.
