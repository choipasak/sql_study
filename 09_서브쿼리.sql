
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

-- WHERE���� SUB QUERY��
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
-- ERROR: ������ �������� ������ ������ �Ѱ��� ����ϴµ� ���� �������� 1�� �̻��� �����Ͱ� �����Ǿ��ٴ� ����(job_id = 'IT_PROG' ��ȸ -> 5��)
-- ����: ���� ������ ���������� �����ϴ� ���� ���� ���� ������ �����ڸ� ����� �� �����ϴ�.
-- ���� �� ������: �ַ� �� ������ (=, >, <, >=, <=, <>)�� ����ϴ� ��� �ϳ��� �ุ ��ȯ�ؾ� �մϴ�.
--> ���������� �տ� job_id = �� ����߱� ������ 1���� �����͸� �Ծ�� �ߴ�.
-- �̷� ��쿡�� ������ �����ڸ� ����ؾ� �մϴ�.

-- ���� �� ������: (IN, ANY, ALL)
-- 1. IN: ��ȸ�� ����� � ���� ���� ���� Ȯ���մϴ�.
SELECT job_id FROM employees
WHERE job_id IN (SELECT job_id FROM employees
                 WHERE job_id = 'IT_PROG');

-- first_name�� David�� ������� �޿�(4800, 9500, 6800)�� ���� �޿��� �޴� ������� ��ȸ.
SELECT first_name, salary FROM employees
WHERE salary IN (SELECT salary FROM employees
                 WHERE first_name = 'David');

-- ANY, SOME: ���� ���������� ���� ���ϵ� ������ ���� ���մϴ�.
-- �ϳ��� �����ϸ� �˴ϴ�.
SELECT first_name, salary FROM employees
WHERE salary > ANY (SELECT salary FROM employees
                 WHERE first_name = 'David');

SELECT first_name, salary FROM employees
WHERE salary > SOME (SELECT salary FROM employees
                 WHERE first_name = 'David');


-- ALL: ���� ���������� ���� ���ϵ� ������ ���� ��� ���ؼ�
-- ��� �����ؾ� �մϴ�.
SELECT first_name, salary FROM employees
WHERE salary > ALL (SELECT salary FROM employees
                 WHERE first_name = 'David');
                 -- ���: ���� �������� ����� 4800, 9500, 6800 �߿� 9500���� salary�� ū �����͸� ��ȸ!


-- EXISTS: ���������� �ϳ� �̻��� ���� ��ȯ�ϸ� ������ ����.
-- job_history���� employee_id�� ���� ��ȸ�� �����غ���!
SELECT * FROM employees e
WHERE EXISTS (SELECT 1 FROM job_history jh
              WHERE e.employee_id = jh.employee_id); -- �̰� JOINó�� ������������ �ٹ� ��
-- 1�� ���� ������ ���� ���뿡�� ����(EXIST)�Ѵٸ� employees e���� ã�Ƽ� ��ȸ�϶�!
-- 1�� ã�°��� �׳� ��¡���� �ǹ� -> �����ʹ� �ñ����� �ʰ� �׳� ���縸 �ϴ����� ��ȸ�ϴ� ���̴�.
--> �÷��� ���� ��Ī�Ұ� ���� ��, ��¡������ 1�� �����ϸ� �������� ������ŭ ��ȸ�ȴ�!
--> ���� �������� ����: job_history�ȿ� �����Ͱ� �����ϸ�
--> ��ü �ؼ�: employees�� ��� �÷��� �� ��ȸ�ϰڴ�!
-- ����: job_history�� �����ϴ� ������ employees���� �����Ѵٸ� ��ȸ�� ����

-- EXIST ����
SELECT * FROM employees
WHERE EXISTS (SELECT 1 FROM departments
              WHERE department_id = 80); -- �̰� �׳� ���� �������� ���� ���� ���� �������� ����
-- ���� ���������� ���� ���� -> ���� ������ ����
-- ���� �������� ���� �������� �����ϴ� ��, ������ ������ �ȴ�.

--------------------------------------------------------------------------

-- SELECT ���� ���� ������ ���̱�!
-- SELECT �������� �÷��� �����Ѵ�.
SELECT
    e.first_name,
    d.department_name
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id
ORDER BY first_name ASC;
-- ���ڱ� LEFT JOIN �������� �ۼ��� ����
-- LEFT JOIN�� ����� SELECT �������� �������� ����� ����� ���� ����ϴ�.

-- SELECT���� ���� ���� ���
-- ��Į�� �������� ��� Ī�մϴ�.
-- ��Į�� ��������: ���� ����� ���� ���� ��ȯ�ϴ� ��������. �ַ� SELECT���̳�, WHERE������ ����.
-- ��κ� SELECT���� ���� ���������� ��Į�� ��� ��: ���� ��(�ϳ����� ���) �� �����ϱ� ������
-- �Խ��ǿ��� �����. �Խñ� ��Ͽ��� �Խñ� ���� �����ʿ� ��� �������� �� �������ݾ� -> ��Į�� �������� ���
SELECT
    e.first_name,
    (
    SELECT
        department_name
    FROM departments d
    WHERE  d.department_id = e.department_id -- �� �������� ��ġ�ϴ� �����͸� �������ڴ�
    ) AS department_name -- FROM�� departments ���̺��� ��� �̷��� �ۼ�!
FROM employees e
ORDER BY first_name ASC;
/*
�������: FROM�� 
-> {e.first_name -> �� ��� �ѹ��� ���� �������� ����ȴ�(Kimberely�� NULL���� ������ ����: LEFT JOIN)}: �� �྿ �ݺ�
first_name�� employees���� ��ȸ�� ���̰�, ���������� ���缭 ��� �ݺ� ����� ���̴�.
*/

/*
- ��Į�� ���������� ���κ��� ���� ���
: �Լ�ó�� �� ���ڵ�� ��Ȯ�� �ϳ��� ������ ������ ��.
ex) �ش� ���� ����� ����, ��ȸ��.

- ������ ��Į�� ������������ ���� ���
: ��ȸ�� �÷��̳� �����Ͱ� ��뷮�� ���, �ش� �����Ͱ�
����, ���� ���� ����� ���(sql �������� ������ �� �� �پ�ϴ�..)
�ƿ� ���̺��� ���ļ� ���� �� �����Ͱ� ���� -> LEFT JOIN
���� �� �����Ͱ� �������� JOIN�� ������ �� ����..!
*/

-- �� �μ��� �Ŵ��� �̸� ��ȸ
-- 1. LEFT JOIN
SELECT
    d.*,
    e.first_name
FROM departments d -- departments�� ��������
LEFT JOIN employees e
ON d.manager_id = e.employee_id
ORDER BY d.manager_id ASC;
-- null: �Ŵ��� ���̵� ����X -> �翬�� �Ŵ��� �̸��� e.first_name�� ����X

-- 2. SELECT�� �������� (��Į��)
SELECT
    d.*,
    (
        SELECT
            first_name
        FROM employees e -- employees�� ����
        WHERE e.employee_id = d.manager_id -- d.manager_id�� ���� null�� �� -> manager_id�� null
    ) AS manager_name -- ��Į�� �������� ���
FROM departments d
ORDER BY d.manager_id ASC;

-- 2-1. �� �μ��� ��� �� �̱�
SELECT
    d.*,
    (
        SELECT
            COUNT(*) -- ���� department_id�� ����
        FROM employees e -- ����
        WHERE e.department_id = d.department_id -- department_id�� ������!
        GROUP BY department_id -- COUNT�� ����
    ) AS �����
FROM departments d;
-- LEFT JOIN���ε� �ۼ� ����!

----------------------------------------------------------------------------

-- FROM���� ���̴� ��������
-- �ζ��� �� (FROM ������ ���������� ���� ��.)
-- Ư�� ���̺� ��ü! �� �ƴ϶�, SELECT�� ���� �Ϻ� �����͸� ��ȸ�� ���� ���� ���̺�� ����ϰ� ���� ��.
-- �����ϴ� ���̺��� ���� ���ϴ� �����͸� �̾Ƽ� ���̺�� ���� �ʹ� -> �ζ��� ��(���� ���̺�)
-- ���: ������ ���س��� ��ȸ �ڷḦ ������ �����ؼ� ������ ���� ���.

-- salary�� ������ �����ؼ� ������ ����!
-- �ٵ� ������ ���� -> ��ȣ�� �˾ƾ� �� -> ��ȣ�� �ٿ��ִ� ROWNUM
SELECT
    ROWNUM AS rn, employee_id, first_name, salary
FROM employees
ORDER BY salary DESC;
-- ���: ROWNUM�� ������ ����.

-- salary�� ������ �����ϸ鼭 �ٷ� ROWNUM�� ���̸�
-- ROWNUM�� ������ ���� �ʴ� ��Ȳ�� �߻��մϴ�.
-- ����: ROWNUM�� ���� �ٰ� ������ ����Ǳ� ����. ORDER BY�� �׻� �������� ����.
-- �ذ�: ������ �̸� ����� �ڷῡ ROWNUM�� �ٿ��� �ٽ� ��ȸ�ϴ� ���� ���� �� ���ƿ�.
SELECT
    ROWNUM AS rn, employee_id, first_name, salary
FROM employees
ORDER BY salary DESC;

SELECT ROWNUM AS rn, tb.*
FROM
    (
        SELECT
            employee_id, first_name, salary
        FROM employees
        ORDER BY salary DESC
    ) tb
WHERE rn > 0 AND rn <= 10; -- ���� ���ϴ� error: sql�� ���� ���� ����. rn�� ���縦 WHERE������ �𸥴�.
-- �ذ�: ������ ��ü�� �ٽ� ���������� �����.
-- ����!
-- ROWNUM�� ���̰� ���� ������ �����ؼ� ��ȸ�Ϸ��� �ϴµ�,
-- ���� ������ �Ұ����ϰ�, ������ �� ���� ������ �߻��ϴ���.
-- ����: WHERE������ ���� �����ϰ� ���� ROWNUM�� SELECT �Ǳ� ������.
-- �ذ�: ROWNUM���� �ٿ� ���� �ٽ� �� �� �ڷḦ SELECT �ؼ� ������ �����ؾ� �ǰڱ���.

SELECT ROWNUM AS rn, tb.*
FROM
    (
        SELECT
            employee_id, first_name, salary
        FROM employees
        ORDER BY salary DESC
    ) tb
WHERE rn > 0 AND rn <= 10;

-- 3�� ���� ������
SELECT *
FROM
    (
        SELECT ROWNUM AS rn, tb.*
        FROM
            (
                SELECT
                    employee_id, first_name, salary
                FROM employees
                ORDER BY salary DESC -- 1������ ����: RN�� �ް� ���� �ϼ� ����
            ) tb -- 2������ ����: FROM���� FROM��+��Į�� -> ERROR -> �ٽ� �ѹ� ��Į��ȭ
    )
WHERE rn > 20 AND rn <= 30; -- 3������ ����: FROM���� {RN�� ���� �������� ��Į��ȭ ��Ų��} �ۼ�.
-- ����!
/*
���� ���� SELECT ������ �ʿ��� ���̺� ����(�ζ��� ��)�� ����.
�ٱ��� SELECT ������ ROWNUM�� �ٿ��� �ٽ� ��ȸ
���� �ٱ��� SELECT �������� �̹� �پ��ִ� ROWNUM�� ������ �����ؼ� ��ȸ.

** SQL�� ���� ����(���)
FROM -> (JOIN) -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY
*/
--> ���� Ȱ��: ����¡. ��ȣ�� �ȴ޸� �Խñ��� ����. �� �������� �Խñ��� � �����ٰ��� �� ��� ����














