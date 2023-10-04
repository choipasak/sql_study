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

EXEC depts_proc(300,'������','U');

SELECT * FROM depts;
/*
employee_id�� �Է¹޾� employees�� �����ϸ�,
�ټӳ���� out�ϴ� ���ν����� �ۼ��ϼ���. (�͸��Ͽ��� ���ν����� ����)
���ٸ� exceptionó���ϼ���
*/


/*
���ν����� - new_emp_proc
employees ���̺��� ���� ���̺� emps�� �����մϴ�.
employee_id, last_name, email, hire_date, job_id�� �Է¹޾�
�����ϸ� �̸�, �̸���, �Ի���, ������ update, 
���ٸ� insert�ϴ� merge���� �ۼ��ϼ���

������ �� Ÿ�� ���̺� -> emps
���ս�ų ������ -> ���ν����� ���޹��� employee_id�� dual�� select ������ ��.
���ν����� ���޹޾ƾ� �� ��: ���, last_name, email, hire_date, job_id
*/