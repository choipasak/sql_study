
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

/*
���� 12. 
employees���̺�, departments���̺��� left����
hire_date�� �������� �������� 1-10��° �����͸� ����մϴ�.
����) rownum�� �����Ͽ� ��ȣ, �������̵�, �̸�, ��ȭ��ȣ, �Ի���, 
�μ����̵�, �μ��̸� �� ����մϴ�.
����) hire_date�� �������� �������� ���� �Ǿ�� �մϴ�. rownum�� Ʋ������ �ȵ˴ϴ�.
*/
SELECT * FROM(
    SELECT ROWNUM AS rn, tb.* FROM
    (
        SELECT
            e.employee_id, e.first_name, e.phone_number, e.hire_date,
            d.department_id, d.department_name
        FROM employees e LEFT JOIN departments d
        ON e.department_id = d.department_id
        ORDER BY hire_date --> ���⼭ e.hire_date��� �ص� �ǰ�, �׳� hire_date��� �ص� �ȴ�: hire_date�� employees���̺��� �ֱ� ������
    ) tb
)
WHERE rn BETWEEN 1 AND 10;


/*
���� 13. 
--EMPLOYEES �� DEPARTMENTS ���̺���
JOB_ID�� SA_MAN ����� ������ LAST_NAME, JOB_ID, 
DEPARTMENT_ID,DEPARTMENT_NAME�� ����ϼ���.
*/
-- join
SELECT
    e.last_name, e.job_id,
    d.department_id, d.department_name
FROM employees e JOIN departments d
ON e.department_id = d.department_id
WHERE job_id = 'SA_MAN';

-- ��������
SELECT
    e.last_name, e.job_id,
    (
    SELECT d.department_id FROM departments d
    WHERE d.department_id = e.department_id
    ) AS department_id,
    (
    SELECT d.department_name FROM departments d
    WHERE d.department_id = e.department_id
    ) AS department_name
FROM employees e
WHERE job_id = 'SA_MAN';

-- ������ (from�� �������� - �ζ��κ� ���)
SELECT
    tb.*, d.department_name
FROM
    (
    SELECT
        last_name, job_id, department_id
    FROM employees
    WHERE job_id = 'SA_MAN'
    ) tb
JOIN departments d
ON tb.department_id = d.department_id;
/*
���� 14
-- DEPARTMENT���̺��� �� �μ��� ID, NAME, MANAGER_ID�� �μ��� ���� �ο����� ����ϼ���.
-- �ο��� ���� �������� �����ϼ���.
-- ����� ���� �μ��� ������� ���� �ʽ��ϴ�.
*/
-- ��: ��Į�� ���������� �ۼ�
SELECT tb.* FROM
    (
        SELECT
            d.department_id, d.department_name, d.manager_id,
            (
                SELECT
                    COUNT(*)
                FROM employees e
                WHERE e.department_id = d.department_id
                GROUP BY e.department_id
            ) AS �ο���
        FROM departments d
    ) tb
WHERE �ο��� IS NOT NULL
ORDER BY �ο��� DESC; --> �̷��� ���������� �ѹ� �� ���� �ʿ� �׳� ��Ī���� �ۼ��� �ָ� �����!��

-- ������ -> JOIN�ϴ� ���̺�� �ζ��κ�
SELECT
    d.department_id, d.department_name, d.manager_id,
    a.total
FROM departments d
JOIN
    (
    SELECT
        department_id, COUNT(*) AS total
    FROM employees
    GROUP BY department_id
    ) a
ON d.department_id = a.department_id
ORDER BY a.total DESC;
-- '����� ���� �μ��� ������� ���� �ʽ��ϴ�' �� ���� -> INNER JOIN���� �ذ� ����, ����� ������ ��ȸ�� �ȵǴϱ�!

/*
SELECT
    COUNT(*),
    (
    SELECT d.department_id FROM departments d
    WHERE d.department_id = e.department_id
    ) AS department_id,
    (
    SELECT d.department_name FROM departments d
    WHERE d.department_id = e.department_id
    ) AS department_name,
    (
    SELECT d.manager_id FROM departments d
    WHERE d.department_id = e.department_id
    ) AS manager_id
FROM employees e
WHERE e.department_id = d.department_id
GROUP BY e.department_id;
*/




/*
���� 15
--�μ��� ���� ���� ���ο�, �ּ�, �����ȣ, �μ��� ��� ������ ���ؼ� ����ϼ���.
--�μ��� ����� ������ 0���� ����ϼ���.
*/
-- ���� �� ����
SELECT
    d.*,
    l.street_address, l.postal_code,
    NVL(e.�޿�, 0) AS �μ�����ձ޿�
FROM departments d 
JOIN
    (
        SELECT
            e.department_id, AVG(e.salary) AS �޿�
        FROM employees e
        GROUP BY e.department_id
    ) e
ON e.department_id = d.department_id
JOIN locations l ON l.location_id = d.location_id;

-- ������
-- 1. ���� �μ� �� ��� ������ �����ش�. -> employees���̺��� ��ȸ
SELECT
    department_id,
    TRUNC(AVG(salary), 2) AS result -- result�� �Ҽ��� �ڸ���
FROM employees
GROUP BY department_id;

-- 2. 1���� �ζ��� ��� ���
SELECT
    d.*,
    lc.street_address, lc.postal_code,
    NVL(tb.result, 0) AS �μ�����ձ޿�
FROM departments d
JOIN locations lc
ON d.location_id = lc.location_id
LEFT JOIN -- �μ��� ����� ������ ��µ��� �ʴ� ���ǿ� �°� LEFT JOIN�� ������ش�.
    (
    SELECT
        department_id,
        TRUNC(AVG(salary), 2) AS result -- result�� �Ҽ��� �ڸ���
    FROM employees
    GROUP BY department_id
    ) tb
ON d.department_id = tb.department_id;

-- ��Į�� ��� ����
SELECT
    d.*,
    lc.street_address, lc.postal_code,
    NVL(
        (
        SELECT TRUNC(AVG(e.salary), 0)
        FROM employees e
        WHERE
        )
        )
FROM locations loc




/*
SELECT
    tb.*
FROM
    (
        SELECT
            AVG(e.salary) AS �μ�����տ���
        FROM departments d JOIN emplemployees e
        WHERE d.department_id = e.department_id
        GROUP BY e.department_id
        WHERE
    ) tb
    */
    
/*
SELECT
        e.*,
        AVG(salary) AS �μ�����տ���,
        tb.*
FROM
    employees e,
    (
        SELECT
            l.street_address, l.postal_code
        FROM locations l JOIN departments d
        WHERE l.location_id = d.location_id
    ) tb
GROUP BY e.department_id;
*/


/*
���� 16
-���� 15 ����� ���� DEPARTMENT_ID�������� �������� �����ؼ� 
ROWNUM�� �ٿ� 1-10 ������ ������ ����ϼ���.
*/

SELECT
    *
FROM
    (
        SELECT
        ROWNUM AS rn, tb.*
        FROM
            (
                SELECT
                    d.*,
                    l.street_address, l.postal_code,
                    NVL(e.�޿�, 0) AS �μ�����ձ޿�
                FROM departments d 
                JOIN
                    (
                        SELECT
                            e.department_id, AVG(e.salary) AS �޿�
                        FROM employees e
                        GROUP BY e.department_id
                    ) e
                ON e.department_id = d.department_id
                JOIN locations l ON l.location_id = d.location_id
                ORDER BY e.department_id DESC
            ) tb
    )
WHERE rn BETWEEN 1 AND 10;

-- ������ ����
SELECT * FROM
    (
    SELECT ROWNUM AS rn, tbl2.*
        FROM
        (
        SELECT
            d.*,
            loc.street_address, loc.postal_code,
            NVL(tbl.result, 0) AS �μ�����ձ޿�
        FROM departments d
        JOIN locations loc
        ON d.location_id = loc.location_id
        LEFT JOIN
            (
            SELECT
                department_id,
                TRUNC(AVG(salary), 0) AS result
            FROM employees
            GROUP BY department_id
            ) tbl
        ON d.department_id = tbl.department_id
        ORDER BY d.department_id DESC
        ) tbl2
    )
WHERE rn > 0 AND rn <= 10;






















