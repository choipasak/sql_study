
-- insert
-- ���̺� ���� Ȯ�� (��� sql delveloper�� ����ϰ� �ֱ� ������ �ʿ� ������)
DESC departments;
-- ��? = nullable
-- �׳� ���̺� Ŭ���ؼ� ���� ���� ���� �� ����

-- INSERT�� ù��° ���
-- : ��� �÷� �����͸� �� ���� ���� ����
INSERT INTO departments
VALUES(300, '���ߺ�',null,null); -- ������ �÷� ������� ���Ѽ� �� ����

SELECT * FROM departments;
ROLLBACK; -- INSERT�Ѱ� �� ��ҵȴ�(Ŀ�� ��) / ���� ������ �ٽ� Ŀ�� ������ �ǵ����� Ű����

-- INSERT�� �ι�° ��� (���� �÷��� �����ϰ� ����, NOT NULL �� Ȯ���ϼ���!)
INSERT INTO departments
    (department_id, department_name, location_id)
VALUES
    (290, '�ѹ���', 1700);
-- ���⼭ NOT NULL�� �÷��� ���������� �ʴ´ٸ� ERROR


-- �纻 ���̺� ����(CREATE TABLE AS - CTAS)
-- �纻 ���̺��� ������ �� �׳� �����ϸ� -> ��ȸ�� �����ͱ��� ��� ����
CREATE TABLE emps AS
(SELECT employee_id, first_name, job_id, hire_date
FROM employees); -- ��ȣ ���� ������ �纻 ���̺�(emps)�� ������!

SELECT * FROM emps;
DROP TABLE emps; -- ���� �������̺� ����

-- �����ʹ� �ȹް� �Ͱ�, ������ �� �����ϰ� �ʹ�.
-- WHERE���� false�� (1 = 2) �����ϸ� -> ���̺��� ������ ����ǰ� �����ʹ� ���� X
CREATE TABLE emps AS
(SELECT employee_id, first_name, job_id, hire_date
FROM employees WHERE 1 = 2); -- WHERE 1 = 2: false�� ����. ����Ŭ�� boolean�� ��� ���� ������ ǥ���� ��� ��.
-- WHERE���� false���� �ָ� ������ ���´�!


-- INSERT (���� ���� ���): �� ��� X
INSERT INTO emps
(SELECT employee_id, first_name, job_id, hire_date
FROM employees WHERE department_id = 50); -- ������ �ִ� emps�� employees�� ��� ������ �ֱ�

----------------------------------------------------------------------------------------------

-- UPDATE
CREATE TABLE emps AS
(SELECT * FROM employees);

-- UPDATE�� ������ ���� ������ ������ �� �� �����ؾ� �մϴ�.
-- �׷��� ������ ���� ����� ���̺� ��ü�� ����˴ϴ�.
UPDATE emps SET salary = 30000; -- ������ �÷��� ����
ROLLBACK;

-- ��� ������ ���
UPDATE emps SET salary = 30000
WHERE employee_id = 100; -- ������ �����Ұ���
-- ���� ������ �������� �������� �ʴ´ٸ�(WHERE) ��� salary�� �� �ٲ��.

SELECT * FROM emps;

-- ������ ���� �÷������ε� �����ϴ�.
UPDATE emps SET salary = salary + salary * 0.1
WHERE employee_id = 100;

-- ������ �� 2�� ����
UPDATE emps
SET phone_number = '010.4742.8917', manager_id = 102 -- �� �ִٸ� , �ϰ� �� �ۼ��ϸ� �ȴ�.
WHERE employee_id = 100;

-- UPDATE (���� ���� ���)
-- ��ȸ�� �������� �����ϰڴ�!(����)
UPDATE emps
    SET (job_id, salary, manager_id) =
    (
        SELECT job_id, salary, manager_id
        FROM emps
        WHERE employee_id = 100
    ) -- employee_id = 100�� ����� SELECT�� ������ ��ȸ�ؼ�
WHERE employee_id = 101; -- employee_id = 101�� ������� �����͸� SET�ϰڴ�.

----------------------------------------------------------------------------------

-- DELETE
DELETE FROM emps; --> ������ ��� �� ������.
ROLLBACK;

DELETE FROM emps
WHERE employee_id = 103;

SELECT * FROM emps;

-- ���� �Ǽ� ���� �ϴ� ����
DELETE * FROM emps
WHERE employee_id = 103; -- �÷��� ������ �ʿ䰡 ����: �� ���� �� ����� ����

-- DELETE (���� ���� ���)
DELETE FROM emps
WHERE department_id = (SELECT department_id FROM departments
                       WHERE department_id = 'IT');






