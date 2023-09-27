
-- MERGE: ���̺� ����

/*
UPDATE�� INSERT�� �� �濡 ó�� ����.

�� ���̺� �ش��ϴ� �����Ͱ� �ִٸ� UPDATE��,
������ INSERT�� ó���ض�. -> MERGE��� Ű����� ����� ���� �� ����
*/

CREATE TABLE emps_it AS (SELECT * FROM employees WHERE 1 = 2);

INSERT INTO emps_it
    (employee_id, first_name, last_name, email, hire_date, job_id)
VALUES
    (105, '���', '��', 'chunbae', sysdate, 'IT_PROG');
-- 2���� �����͸� emps_it�� �־���

SELECT * FROM emps_it;

SELECT * FROM employees
WHERE job_id = 'IT_PROG'; -- �� ������ 5���� emps_it�� �־��ַ��� ��ȸ ��.
-- �ٵ� employees�� ��ȸ�ϴ� 105��, 106�� �ߺ��Ǵ� ���� �� �� ����
-- �׷��� �̹� �����ϴ� �����ʹ� update�� �ǰ�, ���� �����ʹ� insert�� ������ ���ھ� -> MERGE

MERGE INTO emps_it a -- (������ �� Ÿ�� ���̺�)�� ��Ī a
    USING -- ���ս�ų ������
        (SELECT * FROM employees
         WHERE job_id = 'IT_PROG') b -- �����ϰ��� �ϴ� �����͸� ���������� ǥ��, ���̺� �̸��� ���͵� �ȴ�.
    ON -- ���ս�ų �������� ���� ����
        (a.employee_id = b.employee_id) -- ����. ������ ��쿡
WHEN MATCHED THEN -- ON������ ��ġ�ϴ� ��쿡�� Ÿ�� ���̺� �̷��� �����϶�. �� ������ �ؿ� �����ش�.
    UPDATE SET -- ������ ���� SET
        a.phone_number = b.phone_number,
        a.hire_date = b.hire_date,
        a.salary = b.salary,
        a.commission_pct = b.commission_pct,
        a.manager_id = b.manager_id,
        a.department_id = b.department_id
WHEN NOT MATCHED THEN
    INSERT /*�Ӽ�(�÷�)�� ��*/ VALUES
    (b.employee_id, b.first_name, b.last_name,
    b.email, b.phone_number, b.hire_date, b.job_id,
    b.salary, b.commission_pct, b.manager_id, b.department_id);

-- merge �� ���
/*
�ǹ�����,
������ ����� ��û�� �����ϴ� ���̺��� �ְ�, �̰��� ��� ���̺���� ����.
�ð��� ������ ��� ���̺��� �ǽð����̺��� ������ �� ����Ѵ�.
*/

--------------------------------------------------------------------------

-- ���� ������
INSERT INTO emps_it
    (employee_id, first_name, last_name, email, hire_date, job_id)
VALUES(102, '����', '��', 'LEXPARK', '01/04/06', 'AD_VP');
INSERT INTO emps_it
    (employee_id, first_name, last_name, email, hire_date, job_id)
VALUES(101, '�ϳ�', '��', 'NINA', '20/04/06', 'AD_VP');
INSERT INTO emps_it
    (employee_id, first_name, last_name, email, hire_date, job_id)
VALUES(103, '���', '��', 'HMSON', '20/04/06', 'AD_VP');

SELECT * FROM emps_it;

/*
employees ���̺��� �Ź� ����ϰ� �����Ǵ� ���̺��̶�� ��������.
������ �����ʹ� email, phone, salary, comm_pct, man_id, dept_id��
������Ʈ �ϵ��� ó��
���� ���Ե� �����ʹ� �״�� �߰�.
*/

MERGE INTO emps_it a
    USING
        (SELECT * FROM employees) b
    ON
        (a.employee_id = b.employee_id)
WHEN MATCHED THEN
    UPDATE SET
        a.email = b.email,
        a.phone_number = b.phone_number,
        a.salary = b.salary,
        a.commission_pct = b.commission_pct,
        a.manager_id = b.manager_id,
        a.department_id = b.department_id
WHEN NOT MATCHED THEN
    INSERT VALUES
    (b.employee_id, b.first_name, b.last_name,
    b.email, b.phone_number, b.hire_date, b.job_id,
    b.salary, b.commission_pct, b.manager_id, b.department_id); -- ������ �����ʹ� ���� �������� �����ʹ� �߰��ȴ�.

SELECT * FROM emps_it
ORDER BY employee_id ASC;

ROLLBACK;

-- �׷� DELETE�� ���ֳ���?
MERGE INTO emps_it a
    USING
        (SELECT * FROM employees
         WHERE job_id = 'IT_PROG') b
    ON 
        (a.employee_id = b.employee_id)
WHEN MATCHED THEN
    UPDATE SET
        a.phone_number = b.phone_number,
        a.hire_date = b.hire_date,
        a.salary = b.salary,
        a.commission_pct = b.commission_pct,
        a.manager_id = b.manager_id,
        a.department_id = b.department_id
        
         /*
        DELETE�� �ܵ����� �� ���� �����ϴ�.
        UPDATE ���Ŀ� DELETE �ۼ��� �����մϴ�.
        UPDATE �� ����� DELETE �ϵ��� ����Ǿ� �ֱ� ������
        ������ ��� �÷����� ������ ������ �ϴ� UPDATE�� �����ϰ�
        DELETE�� WHERE���� �Ʊ� ������ ������ ���� �����ؼ� �����մϴ�.
        */
    DELETE
        WHERE a.employee_id = b.employee_id
        
WHEN NOT MATCHED THEN
    INSERT /*�Ӽ�(�÷�)�� ��*/ VALUES
    (b.employee_id, b.first_name, b.last_name,
    b.email, b.phone_number, b.hire_date, b.job_id,
    b.salary, b.commission_pct, b.manager_id, b.department_id);

-- 1��
CREATE TABLE DEPTS AS (SELECT * FROM departments);

SELECT * FROM DEPTS;

INSERT INTO DEPTS -- ���⿡ �÷� �߰��ؼ� ���ϴ� �÷����� ���� �� �� ����.
    VALUES(320, '����', 303, 1700); -- ���� �ٲ㼭 �� 5�� �߰�����.

-- 2��

-- 2-1��
UPDATE DEPTS
SET department_name = 'IT bank'
WHERE department_name = 'IT Support';

-- 2-2��
UPDATE DEPTS
SET manager_id = 301
WHERE department_id = 290;

-- 2-3��
UPDATE DEPTS
SET department_name = 'IT Help', manager_id = 303, location_id = 1800
WHERE department_name = 'IT Helpdesk';

-- 2-4��
UPDATE DEPTS
SET manager_id = 301
WHERE department_id >= 290;
-- OR�����ڸ� �̿��ؼ� WHERE���� �� ���� �� ���� ������!
-- department_id IN (290, 300, 310, 320); ���� �ۼ� ����!

-- 3��

-- 3-1��
-- ������ ������ �׻� PRIMARY_KEY�� �մϴ�.
DELETE FROM DEPTS
WHERE department_id = 320;
/*
�ٵ� ���� department_id�� �𸥴ٴ� ���� -> ���� ���� ���
DELETE FROM DEPTS
WHERE department_id = (SELECT department_id FROM DEPTS
                        WHERE department_name = '����');
*/

SELECT * FROM DEPTS;

-- 3-2��
DELETE FROM DEPTS
WHERE department_id = 220;

-- 4��
-- ���� �纻 ���̺� ����� -> ���⼭ DEPTS ���̺��� �ѹ��ϰ� �纻 ���̺��� ����������.
-- �׷��� MERGE�� ��, ON���ǿ��� department_id�� ���ٰ� �� �� �־����Ф�
CREATE TABLE DEPTSCOPY AS (SELECT * FROM DEPTS);

SELECT * FROM DEPTSCOPY;

-- 4-1��
DELETE FROM DEPTSCOPY
WHERE department_id > 200;

-- 4-2��
UPDATE DEPTSCOPY
SET manager_id = 100
WHERE manager_id IS NOT NULL;

-- 4-3��
UPDATE DEPTSCOPY
SET department_id = 110
WHERE department_name = 'Accounting';

SELECT * FROM DEPTSCOPY;

-- 4-4��
MERGE INTO DEPTS d -- (������ �� Ÿ�� ���̺�)�� ��Ī a
    USING -- ���ս�ų ������
        (SELECT * FROM departments) dp -- �����ϰ��� �ϴ� �����͸� ���������� ǥ��, ���̺� �̸��� ���͵� �ȴ�.
    ON -- ���ս�ų �������� ���� ����
        (d.department_id = dp.department_id) -- ����, ������ ��쿡
WHEN MATCHED THEN -- ON������ ��ġ�ϴ� ��쿡�� Ÿ�� ���̺� �̷��� �����϶�. �� ������ �ؿ� �����ش�.
    UPDATE SET -- ������ ���� SET
        d.department_name = dp.department_name,
        d.manager_id = dp.manager_id,
        d.location_id = dp.location_id
WHEN NOT MATCHED THEN
    INSERT /*�÷��� �����ϱ� ���Ѵٸ�: �Ӽ�(�÷�)�� ��*/
    VALUES
    (dp.department_id, dp.department_name, dp.manager_id, dp.location_id); -- departments�� ��� �÷�

SELECT * FROM DEPTS;

-- 5�� ����

-- 5-1��
CREATE TABLE jobs_it AS (SELECT * FROM JOBS WHERE min_salary > 6000);
-- �� WHERE�� ����� ���� ��ȿ

SELECT * FROM jobs_it;

-- 5-2��
INSERT INTO jobs_it
    VALUES('SEC_DEV', '���Ȱ�����', 6000, 19000); -- VALUES�� ���� �ٲ㼭 3���� �� INSERT��

-- 5-3 + 5-4��
MERGE INTO (SELECT * FROM jobs_it) ji
    USING
        (SELECT * FROM jobs WHERE min_salary > 5000) j
    ON
        (ji.job_id = j.job_id) -- 
WHEN MATCHED THEN
    UPDATE SET
        ji.min_salary = j.min_salary,
        ji.max_salary = j.max_salary
WHEN NOT MATCHED THEN
    INSERT VALUES
        (j.job_id, j.job_title, j.min_salary, j.max_salary);

-- ����� ��!
-- DEPTS�� �ѹ��� ���س��� ON���ǿ��� (d.department_id = dp.department_id)�� ������ �ȵȴٰ� ������






