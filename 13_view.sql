
/*
view�� �������� �ڷḸ ���� ���� ����ϴ� ���� ���̺��� �����Դϴ�.
��� �⺻ ���̺�� ������ ���� ���̺��̱� ������
�ʿ��� �÷��� ������ �θ� ������ ������ ���ϴ�.
��� �������̺�� ���� �����Ͱ� ���������� ����� ���´� �ƴմϴ�.
�並 ���ؼ� �����Ϳ� �����ϸ� ���� �����ʹ� �����ϰ� ��ȣ�� �� �ֽ��ϴ�.
*/

/*
DB�� ���� -> �ϵ��ũ�� table_space��� ���·� ���������� ������
�ٵ� ��� �ƴ�. ���� ���� ���·� ������� ����.
table���� �� �ٸ���
*/

-- �並 ������� ������ �־����
SELECT * FROM user_sys_privs; -- ���⿡ CREATE VIEW�� �־����!

-- ���� ����: �ܼ���, ���պ�
-- �ܼ� ��: �ϳ��� ���̺��� �̿��Ͽ� ������ ��
-- ���� �÷� �̸��� �Լ� ȣ�⹮, ����� �� ���� ���� ǥ�����̸� �ȵ˴ϴ�. �ݵ�� ��Ī�� �ٿ���� �մϴ�.
-- ���ϴ� �÷��� �̾Ƴ�����!
SELECT 
    employee_id,
    first_name || ' ' || last_name,
    job_id,
    salary
FROM employees
WHERE department_id = 60;
-- ��׸� �ʿ��ѵ�, �ʿ��� ������ �ۼ��ؼ� ����� �� ������ ���� �������� ���� ���̺�� ������!
CREATE VIEW view_emp AS (
SELECT 
    employee_id,
    first_name || ' ' || last_name AS full_name,
    job_id,
    salary
FROM employees
WHERE department_id = 60
); -- error: must name this expression with a column alias -> SELECT�� 2��° ���ǿ� ��Ī �޾ƶ�

SELECT * FROM view_emp
WHERE salary >= 6000;

-- ���� ��
-- ���� ���̺��� �����Ͽ� �ʿ��� �����͸� �����ϰ� ���� Ȯ���� ���� ���.
-- ���� ����ϴ� ������ ����� ��� �������!
CREATE VIEW view_dept_jobs AS (
    SELECT
        e.employee_id,
        e.first_name || ' ' || e.last_name AS full_name,
        d.department_name,
        j.job_title
    FROM employees e
    LEFT JOIN departments d
    ON e.department_id = d.department_id
    LEFT JOIN jobs j
    ON e.job_id = j.job_id
)
ORDER BY employee_id;

SELECT * FROM view_dept_jobs;

-- ����, �÷� �ϳ��� ���� -> �� ����
-- ���� ���� (CREATE OR REPLACE VIEW ����)
-- : ���� �̸����� �ش� ������ ����ϸ� �����Ͱ� ����Ǹ鼭 ���Ӱ� �����˴ϴ�.
-- CREATE VIEW view_dept_jobs AS -> CREATE OR REPLACE VIEW view_dept_jobs AS�� �ٲ㼭 �Ȱ��� �ۼ��Ͽ� �����ϸ� �ȴ�!
CREATE OR REPLACE VIEW view_dept_jobs AS (
    SELECT
        e.employee_id,
        e.first_name || ' ' || e.last_name AS full_name,
        d.department_name,
        j.job_title,
        e.salary -- �߰� �� �÷�
    FROM employees e
    LEFT JOIN departments d
    ON e.department_id = d.department_id
    LEFT JOIN jobs j
    ON e.job_id = j.job_id
)
ORDER BY employee_id;

SELECT
    job_title,
    AVG(salary) AS avg
FROM view_dept_jobs
GROUP BY job_title
ORDER BY AVG(salary) DESC; -- SQL ������ Ȯ���� ª����.

-- �� ����
DROP VIEW view_emp;

-- �׳� ���̺� ���� �ȵǳ���
-- ��� �������̺���. ������ ������ ������ ���� ���� ���̺��� ���������� ����.
-- ���̺��� ��ȸ�ϴ� �͵� ����
-- �ٸ� ������� �����ϸ� �ȵǴ� ���̺��� ��� ���� �� �� �ִ� ������ ���� ������ �� ���� ����
-- �׸��� ��� �б��������ε� ������ ������.
/*
VIEW�� INSERT�� �Ͼ�� ���, ���� ���̺��� �ݿ��� �˴ϴ�.
�׷��� VIEW�� INSERT, UPDATE, DELET�� ���� ���� ������ �����ϴ�.
���� ���̺��� NOT NULL�� ��� VIEW�� INSERT�� �Ұ����մϴ�.
VIEW���� ����ϴ� �÷��� ���� ���� ��쿡�� �ȵ˴ϴ�.
*/

INSERT INTO view_dept_jobs
VALUES(300, 'test', 'test', 'test', 10000); -- error: virtual column not allowed here
-- view_dept_jobs���� SELECT���� 2��° ������ ���� ����.(��Ī)
-- full_name�� ����(virtual column)�̱� ������ INSERT �Ұ�

-- �׷� ���� ���� INSERT �õ�
INSERT INTO view_dept_jobs
(employee_id, department_name, job_title, salary)
VALUES(300, 'test', 'test', 'test', 10000); -- error:
-- �������� ���ε� ���� ��� INSERT�� ���� ��ٷο�
-- ����: JOIN�� ���� ��� �� ���� ������ �� �� �����ϴ�.

-- JOIN�� ���� ����� �����ϱ� ���� �䵵 ����
-- ���� ���̺��� null�� ������� �ʴ� �÷� ������ �� �� �����ϴ�.
INSERT INTO view_emp
(employee_id, job_id, salary)
VALUES(300, 'test', 10000); -- error: cannot insert NULL into ("HR"."EMPLOYEES"."LAST_NAME")
-- error: LAST_NAME�÷����� �� �� �ִ�?
-- �׷��� ���Ϻ䰡 ���պ亸�ٴ� ����, ����, ������ �� ���� ���̴�.
DELETE FROM view_emp
WHERE employee_id = 103; -- error: child record found -> employee_id = 103�� ���� �����ϰ� �־ �Ұ���

-- �ٸ� id�� �õ�
-- ����, ����, ���� ���� �� ���� ���̺� �ݿ��˴ϴ�.
DELETE FROM view_emp
WHERE employee_id = 107; -- ����

SELECT * FROM view_emp; -- ���������� 107�� ����
SELECT * FROM employees; -- �ٵ� ���� ���̺��� employees������ 107���� ����
ROLLBACK;

-- view�� ����: �ΰ��� ������ �������� ����, ���ٿ� �����ϰ�, �������� ������ �� �ִ�!

-- view�� �ɼ�
-- WITH CHECK OPTION -> ���� ���� �÷�
-- : �並 ������ �� ����� ���� �÷��� �並 ���ؼ� ������ �� ���� ���ִ� Ű����
CREATE VIEW view_emp_test AS (
    SELECT 
        employee_id,
        first_name,
        last_name,
        email,
        hire_date,
        job_id,
        department_id
    FROM employees
    WHERE department_id = 60
);

UPDATE view_emp_test
SET department_id = 100
WHERE employee_id = 107; -- �� �����Ҷ��� WHERE���� �ٲ�

SELECT * FROM view_emp_test; -- ����

ROLLBACK;

-- ������ ���� WHERE���� �ٲ��� ���ϰ� �ϰ� �ʹ�.
CREATE OR REPLACE VIEW view_emp_test AS (
    SELECT 
        employee_id,
        first_name,
        last_name,
        email,
        hire_date,
        job_id,
        department_id
    FROM employees
    WHERE department_id = 60
)
WITH CHECK OPTION CONSTRAINT view_emp_test_ck;
-- WHERE�� ���� ���� �ٽ� UPDATE
UPDATE view_emp_test
SET department_id = 100
WHERE employee_id = 107; -- error

-- �׷� �ٸ� �÷� ������ ����?
UPDATE view_emp_test
SET job_id = 'AD_VP'
WHERE employee_id = 107; -- ����~

-- �並 �б� �������� ����� -> WITH READ ONLY (DML ������ ���� -> SELECT�� ���)
CREATE OR REPLACE VIEW view_emp_test AS (
    SELECT 
        employee_id,
        first_name,
        last_name,
        email,
        hire_date,
        job_id,
        department_id
    FROM employees
    WHERE department_id = 60
)
WITH READ ONLY; -- ���: ��� �÷� ���� ����




