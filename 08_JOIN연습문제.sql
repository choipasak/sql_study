
/*
���� 1.
-EMPLOYEES ���̺��, DEPARTMENTS ���̺��� DEPARTMENT_ID�� ����Ǿ� �ֽ��ϴ�.
-EMPLOYEES, DEPARTMENTS ���̺��� ������� �̿��ؼ�
���� INNER , LEFT OUTER, RIGHT OUTER, FULL OUTER ���� �ϼ���. (�޶����� ���� ���� Ȯ�� �ּ����� �ۼ�)
*/
-- INNER
SELECT
    e.department_id,
    d.department_id
FROM employees e JOIN departments d
ON e.department_id = d.department_id; -- 106

-- LEFT OUTER
SELECT
    e.department_id,
    d.department_id
FROM employees e LEFT JOIN departments d
ON e.department_id = d.department_id; -- 107

-- RIGHT OUTER
SELECT
    e.department_id,
    d.department_id
FROM employees e RIGHT JOIN departments d
ON e.department_id = d.department_id; -- 122

-- FULL OUTER
SELECT
    e.department_id,
    d.department_id
FROM employees e FULL JOIN departments d
ON e.department_id = d.department_id; -- 123


/*
���� 2.
-EMPLOYEES, DEPARTMENTS ���̺��� INNER JOIN�ϼ���
����)employee_id�� 200�� ����� �̸�, department_id�� ����ϼ���
����)�̸� �÷��� first_name�� last_name�� ���ļ� ����մϴ�
*/
SELECT
    CONCAT(e.first_name, ' ' || e.last_name) AS name,
    d.department_name
FROM employees e JOIN departments d
ON e.department_id = d.department_id
AND e.employee_id = 200;

/*
���� 3.
-EMPLOYEES, JOBS���̺��� INNER JOIN�ϼ���
����) ��� ����� �̸��� �������̵�, ���� Ÿ��Ʋ�� ����ϰ�, �̸� �������� �������� ����
HINT) � �÷����� ���� ����Ǿ� �ִ��� Ȯ��
*/
SELECT
    e.first_name,
    e.job_id,
    j.job_title
FROM employees e JOIN jobs j 
ON e.job_id = j.job_id
ORDER BY e.first_name ASC;



/*
���� 4.
--JOBS���̺�� JOB_HISTORY���̺��� LEFT_OUTER JOIN �ϼ���.
*/
SELECT
    *
FROM jobs j LEFT JOIN job_history jh
ON j.job_id = jh.job_id;

/*
���� 5.
--Steven King�� �μ����� ����ϼ���.
*/
SELECT
    e.first_name || ' ' || e.last_name AS full_name,
    d.department_name
FROM employees e LEFT JOIN departments d
ON e.department_id = d.department_id -- e.employee_id�� ���Ϸ��� LEFT JOIN�� �������: INNER JOIN�� �ϸ� ���ǿ� �ش���� ������ ������� ������ �ʱ� ����
WHERE e.first_name || ' ' || e.last_name = 'Steven King';
-- PK ���� �÷��� ã�Ƽ� JOIN���ֱ�!


/*
���� 6.
--EMPLOYEES ���̺�� DEPARTMENTS ���̺��� Cartesian Product(Cross join)ó���ϼ���
*/
SELECT
    *
FROM employees e CROSS JOIN departments d; -- 2889���� �� ��µ�

/*
���� 7.
--EMPLOYEES ���̺�� DEPARTMENTS ���̺��� �μ���ȣ�� �����ϰ� SA_MAN ������� �����ȣ, �̸�, 
�޿�, �μ���, �ٹ����� ����ϼ���. (Alias�� ���)
*/
SELECT
    e.employee_id,
    e.first_name,
    e.salary,
    d.department_name,
    loc.city
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations loc ON d.location_id = loc.location_id
WHERE e.job_id = 'SA_MAN';


/*
���� 8.
-- employees, jobs ���̺��� ���� �����ϰ� job_title�� 'Stock Manager', 'Stock Clerk'�� 
���� ������ ����ϼ���.
*/
SELECT
    *
FROM employees e JOIN jobs j
ON e.job_id = j.job_id
WHERE j.job_title IN('Stock Manager','Stock Clerk'); -- IN�� �ᵵ �ȴ�.
/*
WHERE j.job_title = 'Stock Manager'
OR j.job_title = 'Stock Clerk';
*/


/*
���� 9.
-- departments ���̺��� ������ ���� �μ��� ã�� ����ϼ���. LEFT OUTER JOIN ���
*/
SELECT
    d.department_name,
    e.employee_id
FROM departments d LEFT JOIN employees e
ON e.department_id = d.department_id
WHERE e.employee_id IS NULL; -- �ش� �μ��� ������ ���ٴ� ���� ��� ��ȣ�� null�� ��.(����: departments)


/*
���� 10. 
-join�� �̿��ؼ� ����� �̸��� �� ����� �Ŵ��� �̸��� ����ϼ���
��Ʈ) EMPLOYEES ���̺�� EMPLOYEES ���̺��� �����ϼ���.
*/
SELECT
    e1.first_name,
    e2.first_name AS manager_name
FROM employees e1 JOIN employees e2
ON e1.employee_id = e2.manager_id;

/*
���� 11. 
-- EMPLOYEES ���̺��� left join�Ͽ� ������(�Ŵ���)id��, �Ŵ����� �̸�, �Ŵ����� �޿� ���� ����ϼ���
--�Ŵ��� ���̵� ���� ����� �����ϰ� �޿��� �������� ����ϼ���
*/
SELECT
    e2.manager_id AS manager_nums,
    e1.first_name AS manager_name,
    e1.salary
FROM employees e2 LEFT JOIN employees e1
ON e2.manager_id = e1.employee_id
WHERE e2.manager_id IS NOT NULL
ORDER BY e1.salary DESC;




























