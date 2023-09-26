
/*
���� 1.
-EMPLOYEES ���̺��� ��� ������� ��ձ޿����� ���� ������� �����͸� ��� �ϼ��� 
(AVG(�÷�) ���)
-EMPLOYEES ���̺��� ��� ������� ��ձ޿����� ���� ������� ���� ����ϼ���
-EMPLOYEES ���̺��� job_id�� IT_PROG�� ������� ��ձ޿����� ���� ������� 
�����͸� ����ϼ���
WHERE�� ����
*/
-- 1��
SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees); -- �׷�ȭ�� ���� ������ ���̺��� �׷��� �ȴ�.

-- 2��
SELECT COUNT(*) FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- 3��
SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees
                WHERE job_id = 'IT_PROG');

/*
���� 2.
-DEPARTMENTS���̺��� manager_id�� 100�� �μ��� �����ִ� �������
��� ������ ����ϼ���.
*/
SELECT * FROM employees
WHERE department_id = (SELECT department_id FROM departments 
                       WHERE manager_id = 100);
-- �μ��� �����ִ� ����� -> employees
-- employees�� departments�� department_id�� ���ٰ� ����

/*
���� 3.
-EMPLOYEES���̺��� ��Pat���� manager_id���� ���� manager_id�� ���� ��� ����� �����͸� 
����ϼ���
-EMPLOYEES���̺��� ��James��(2��)���� manager_id�� ���� ��� ����� �����͸� ����ϼ���.
*/
-- 1��
SELECT * FROM employees
WHERE manager_id > (SELECT manager_id FROM employees
                    WHERE first_name = 'Pat');
                    
-- 2��                    
SELECT * FROM employees
WHERE manager_id IN (SELECT manager_id FROM employees
                        WHERE first_name = 'James');
-- ANY�� ��ȣ�� �ʿ�!
                    
                    
/*
���� 4.
-EMPLOYEES���̺� ���� first_name�������� �������� �����ϰ�, 41~50��° �������� 
�� ��ȣ, �̸��� ����ϼ���
*/
SELECT * FROM
    (
    SELECT ROWNUM AS rn, tb.first_name
        FROM
        (
            SELECT *
            FROM employees 
            ORDER BY first_name DESC -- 1�� ����
        ) tb
    )
WHERE rn > 40 AND rn <= 50;

/*
���� 5.
-EMPLOYEES���̺��� hire_date�������� �������� �����ϰ�, 31~40��° �������� 
�� ��ȣ, ���id, �̸�, ��ȣ, �Ի����� ����ϼ���.
*/
SELECT * FROM
    (
    SELECT ROWNUM AS rn, tb.*
        FROM
        (
            SELECT
                employee_id, first_name, phone_number, hire_date
            FROM employees 
            ORDER BY hire_date ASC -- 1�� ����
        ) tb
    )
WHERE rn > 30 AND rn <= 40;

/*
���� 6.
employees���̺� departments���̺��� left �����ϼ���
����) �������̵�, �̸�(��, �̸�), �μ����̵�, �μ��� �� ����մϴ�.
����) �������̵� ���� �������� ����
*/
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ' || e.last_name) AS name,
    e.department_id,
    d.department_name
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id
ORDER BY employee_id ASC;

/*
���� 7.
���� 6�� ����� (��Į�� ����)�� �����ϰ� ��ȸ�ϼ���
*/
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ' || e.last_name) AS name,
    e.department_id,
    (
    SELECT department_name FROM departments d
    WHERE d.department_id = e.department_id -- ���⼭�� ������ departments�� �Ǳ� ������ ���� ���°͵� d.department_id�̴�.
    ) AS department_name -- �� ������������ �ϳ��� �÷��� �Ǹ鼭 �������� �ϳ��� ���� ���� ��� ��ȸ���ش�.��
FROM employees e
ORDER BY e.employee_id ASC;
-- ���⼭ ���������� ���������� ���̺��� �ٲٸ� employees�� department_id�� �ߺ��Ǵ� ���� �������̱� ������
-- ���������� ���� �� �����̱� ������ ��� ���̺��� employees�� �ȴٸ� ���ϰ��� ���� ���� �����ϰ� �ȴ� -> ERROR
--> ���̻� ��Į�� ������ �ƴϰ� �ȴ�!
/*
���� 8.
departments���̺� locations���̺��� left �����ϼ���
����) �μ����̵�, �μ��̸�, �Ŵ������̵�, �����̼Ǿ��̵�, ��Ʈ��_��巹��, ����Ʈ �ڵ�, ��Ƽ �� ����մϴ�
����) �μ����̵� ���� �������� ����
*/
SELECT
    d.department_id, d.department_name, d.manager_id, d.location_id,
    lc.street_address, lc.postal_code, lc.city
FROM departments d
LEFT JOIN locations lc
ON d.location_id = lc.location_id -- ���� ����
ORDER BY department_id ASC;

/*
���� 9.
���� 8�� ����� (��Į�� ����)�� �����ϰ� ��ȸ�ϼ���
*/
SELECT
    department_id, department_name, d.manager_id, d.location_id,
    (
    SELECT street_address FROM locations lc
    WHERE lc.location_id = d.location_id
    ) AS street_address,
    (
    SELECT postal_code FROM locations lc
    WHERE lc.location_id = d.location_id
    ) AS postal_code,
    (
    SELECT city FROM locations lc
    WHERE lc.location_id = d.location_id
    ) AS city
FROM departments d
ORDER BY department_id ASC; -- �̷� ��쿡�� Ȯ���� JOIN������ ����ϴ� ���� ����!
/*
���� 10.
locations���̺� countries ���̺��� left �����ϼ���
����) �����̼Ǿ��̵�, �ּ�, ��Ƽ, country_id, country_name �� ����մϴ�
����) country_name���� �������� ����
*/
SELECT
    lc.location_id,
    lc.street_address,
    lc.city,
    c.country_id,
    c.country_name
FROM locations lc LEFT JOIN countries c
ON lc.country_id = c.country_id
ORDER BY country_name ASC;
/*
���� 11.
���� 10�� ����� (��Į�� ����)�� �����ϰ� ��ȸ�ϼ���
*/
SELECT
    lc.location_id, lc.street_address, lc.country_id,
    (
    SELECT c.country_name FROM countries c
    WHERE c.country_id = lc.country_id
    ) AS country_name
FROM locations lc
ORDER BY country_name ASC; -- country_name�� ������ ��Ī���� ���� ��������� ORDER BY�������� ����� ����������!


