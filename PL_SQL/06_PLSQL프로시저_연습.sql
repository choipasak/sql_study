/*
���ν����� divisor_proc
���� �ϳ��� ���޹޾� �ش� ���� ����� ������ ����ϴ� ���ν����� �����մϴ�.
*/
CREATE OR REPLACE PROCEDURE divisor_proc
    (p_num IN NUMBER)
IS
    n_divisors NUMBER := 0;
BEGIN
    FOR i IN 1..p_num
    LOOP
        IF MOD(p_num, i) = 0 THEN
            n_divisors := n_divisors + 1;
        END IF;
    END LOOP;
    
    dbms_output.put_line(p_num || '�� ����� ����: ' || n_divisors);
    
END;

EXEC divisor_proc(64565);


/*
�μ���ȣ, �μ���, �۾� flag(I: insert, U:update, D:delete)�� �Ű������� �޾� 
depts ���̺� 
���� INSERT, UPDATE, DELETE �ϴ� depts_proc �� �̸��� ���ν����� ������.
�׸��� ���������� commit, ���ܶ�� �ѹ� ó���ϵ��� ó���ϼ���.
*/
CREATE OR REPLACE PROCEDURE depts_proc
    (
    p_department_id IN depts.department_id%TYPE,
    p_department_name IN depts.department_name%TYPE,
    flag IN VARCHAR2
    )
IS
    v_cnt NUMBER := 0; -- department_id�� �����ϴ����� ���� ���ؼ� + ����ó���� ����
BEGIN
    
    SELECT
        COUNT(*)
    INTO v_cnt
    FROM depts
    WHERE department_id = p_department_id;
    
    IF flag = 'I' THEN
        INSERT INTO depts (department_id, department_name)
        VALUES (p_department_id, p_department_name);
    ELSIF flag = 'U' THEN
        UPDATE depts
        SET department_id = p_department_id, department_name = p_department_name
        WHERE department_id = p_department_id;
    ELSIF flag = 'D' THEN
        -- �μ���ȣ�� ���´µ� �μ��� ���� ��쿣 v_cnt�� �Ǵ��� �μ��� ���ٰ� ������� ��
        IF v_cnt = 0 THEN
            dbms_output.put_line('�����ϰ��� �ϴ� �μ��� �������� �ʽ��ϴ�.');
            return;
        END IF;
        
        DELETE FROM depts
        WHERE p_department_id = department_id;
    ELSE -- flag�� I, U, D ���� �ٸ� ���ڸ� �Է����� ��
        dbms_output.put_line('�ش� flag�� ���� ������ �غ���� �ʾҽ��ϴ�.');
    END IF;
    
    COMMIT;
    
    EXCEPTION
        WHEN OTHERS THEN -- ��� ���� �ޱ�
            dbms_output.put_line('���ܰ� �߻��߽��ϴ�.');
            dbms_output.put_line('ERROR MSG: ' || SQLERRM);
            ROLLBACK; -- ERROR�� �ѹ�
        
END;

EXEC depts_proc(700,'������','D');

SELECT * FROM depts;
/*
employee_id�� �Է¹޾� employees�� �����ϸ�,
�ټӳ���� out�ϴ� ���ν����� �ۼ��ϼ���. (�͸��Ͽ��� ���ν����� ����)
���ٸ� exceptionó���ϼ��� -- select�� 2���ϸ� ���ܰ� �ȳ�, 
*/
CREATE OR REPLACE PROCEDURE hiring_proc
    (
    p_employee_id IN employees.employee_id%TYPE,
    p_hiring OUT NUMBER
    )
IS
    v_hiring_msg VARCHAR2(100);
    v_cnt NUMBER;
    v_hire_date DATE;
BEGIN
    SELECT
        COUNT(*)
    INTO v_cnt
    FROM employees
    WHERE p_employee_id = employee_id;
    
    SELECT
        hire_date
    INTO v_hire_date
    FROM employees
    WHERE p_employee_id = employee_id;
    
    IF v_cnt = 0 THEN
        dbms_output.put_line('�������� �ʴ� �����ȣ �Դϴ�.');
        return;
    ELSE
        p_hiring := TRUNC((sysdate - v_hire_date) / 365, 0);
    END IF;
    
    /*
    ���� ȣ��ο��� employees���̺� ���� ����� ȣ���ϸ� error: no data found
    ������ ������.
    �׷��� �̷� ��Ȳ�� ����ؼ� exeptionó���� �ض�!
    ���� ����� ȣ������ ��츦 ���� ó��
    */
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(p_employee_id || '�� �������� �ʴ� �����ȣ �Դϴ�!');
            dbms_output.put_line('���ܰ� �߻��߽��ϴ�.');
            dbms_output.put_line('ERROR MSG: ' || SQLERRM);
            ROLLBACK; -- ERROR�� �ѹ�
    
END;

DECLARE
    v_hiring NUMBER;
BEGIN
    hiring_proc(6486, v_hiring);
    dbms_output.put_line('�ټӳ���� ' || v_hiring || '�� �Դϴ�!');
END;

-- ������ver
CREATE OR REPLACE PROCEDURE hiring_proc
    (
    p_employee_id IN employees.employee_id%TYPE,
    p_year OUT NUMBER
    )
IS
    v_hire_date employees.hire_date%TYPE;
BEGIN
    SELECT
        hire_date
    INTO v_hire_date
    FROM employees
    WHERE p_employee_id = employee_id;
    
    p_year := TRUNC((sysdate - v_hire_date) / 365); -- TRUNC( , 0)���⼭ ', 0'��������: �⺻ ��
    
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(p_employee_id || '�� �������� �ʴ� �����ȣ �Դϴ�!');
        ROLLBACK; -- ERROR�� �ѹ�
        
END;

-- ȣ��
DECLARE
    v_year NUMBER;
BEGIN
    hiring_proc(576, v_year);
    dbms_output.put_line(v_year || '��');
    
END; -- ���⼭ ���� ����� ȣ���ϸ� error: no data found
-- �׷��� �̷� ��Ȳ�� ����ؼ� exeptionó���� �ض�!
-- ���� ����� ȣ������ ��츦 ���� ó��

/*
���ν����� - new_emp_proc
employees ���̺��� ���� ���̺� emps�� �����մϴ�.
employee_id, last_name, email, hire_date, job_id�� �Է¹޾�
�����ϸ� �̸�, �̸���, �Ի���, ������ update, 
���ٸ� insert�ϴ� merge���� �ۼ��ϼ���

������ �� Ÿ�� ���̺� -> emps : emps�� �����ϰų� INSERT�ϰų� �϶�� �ǹ�
���ս�ų ������ -> ���ν����� ���޹��� employee_id�� dual�� select ������ ��.
���ν����� ���޹޾ƾ� �� ��: ���, last_name, email, hire_date, job_id
*/
-- ���� ���̺� ���� ������
-- ������ 2���� ���̺��� �����ϴ� ��츸 �߾��µ�, �̹��� �ϳ��� ���� ���̺��� �����ϴ� ����̿���.
-- �׷��� �ϳ��� ��. �� ������ ���̺��� �翬�� dual���̺��� ����ϴ� ����
-- ������ �ؾ��� �Ϳ� ���� ������� �־���!

CREATE OR REPLACE PROCEDURE new_emp_proc
    (
    p_employee_id IN employees.employee_id%TYPE,
    p_last_name IN employees.last_name%TYPE,
    p_email IN employees.email%TYPE,
    p_hire_date IN employees.hire_date%TYPE,
    p_job_id IN employees.job_id%TYPE
    )
IS
    -- v_cnt NUMBER;
BEGIN
    
    MERGE INTO emps a -- (������ �� Ÿ�� ���̺�)�� ��Ī a
    USING -- ���ս�ų ������
        /*
        �� Merge���� ���� ���ν��� �ȿ� ����
        �ٵ� Merge���� Ÿ�� ���̺� ���ս�ų ���̺��� �ʿ���
        �׷��� ���ν����� �Ѿ�� �����͸� ���̺�ȭ �����ִ� ���� -> dual�̿�
        => SELECT p_employee_id AS employee_id FROM dual
        : ���ν����� ���� ���� ������ p_employee_id�� dual�� SELECT�� �̿��� �־��ְڴ�!
        dual�� ����? �� �˻��ؼ� ���� �ۼ����ֱ�
        */
        (SELECT p_employee_id AS employee_id FROM dual) b -- �����ϰ��� �ϴ� �����͸� ���������� ǥ��, ���̺� �̸��� ���͵� �ȴ�.
    ON -- ���ս�ų �������� ���� ����
        (a.employee_id = b.employee_id) -- �� ������ ���� COUTN�� �̿��ؼ� �ۼ��ߴ� IF���� �ʿ䰡 ������. �� ������ true�� �߸� UPDATE, false�� �߸� INSERT�� ����ȴ�.(= MERGE���� ����� ����)
        -- ���޹��� ����� emps�� �����ϴ� ���� ���� �������� ���
    WHEN MATCHED THEN -- ON������ ��ġ�ϴ� ��쿡�� Ÿ�� ���̺� �̷��� �����϶�. �� ������ �ؿ� �����ش�.
        UPDATE SET -- ������ ���� SET
            a.last_name = p_last_name,
            a.email = p_email,
            a.hire_date = p_hire_date,
            a.job_id = p_job_id
    WHEN NOT MATCHED THEN
        INSERT 
        (employee_id, last_name, email, hire_date, job_id)
        VALUES
        (p_employee_id, p_last_name, p_email, p_hire_date, p_job_id);
    
    /*
    
    SELECT
        COUNT(*)
    INTO v_cnt
    FROM emps
    WHERE employee_id = p_employee_id;
    
    IF v_cnt = 1 THEN -- �̷��� IF���� ������� �ʱ� ���ؼ� Merge���� ����ϴ� ��!!
        UPDATE emps
        SET
            last_name = p_last_name,
            email = p_email,
            hire_date = p_hire_date,
            job_id = p_job_id
        WHERE p_employee_id = employee_id;
    ELSE
        INSERT INTO 
    */
    
    
    
END;


EXEC new_emp_proc(100, 'merong', 'merong', sysdate, 'merong');


SELECT * FROM emps;

    
SELECT 120 AS employee_id FROM dual;
 
SELECT 7 FROM dual; -- dual���̺��� Ư¡�� ���� ���� �׽�Ʈ
    
    
    
    
    
    
    
    
    
    