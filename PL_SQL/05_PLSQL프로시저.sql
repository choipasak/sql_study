
-- ���ν���(procedure) -> void �޼��� ����
-- Ư���� ������ ó���ϰ� ������� ��ȯ���� �ʴ� �ڵ� ��� (����)
-- ������ ���ν����� ���ؼ� ���� �����ϴ� ����� �ֽ��ϴ�.
-- �͸��Լ��� �ƴ� -> �Լ��� ����� �ʿ��� ������ ȣ���ϴ� ���
CREATE PROCEDURE guguproc -- PROCEDURE�� ȣ���� �� �ִ� �̸�
    (p_dan IN NUMBER) -- �Ű�����(p_dan�� NUMBERŸ���� IN(���´�))
IS -- �����
    -- ���� �������̿��� ������ ���� ����
BEGIN -- �����
    dbms_output.put_line(p_dan || '��');
    FOR i IN 1..9
    LOOP
        dbms_output.put_line(p_dan || 'x' || i || '=' || p_dan*i);
    END LOOP;
END; -- �����

-- ���ν��� ȣ��
EXEC guguproc(14);

-- �Ű���(�μ�) ���� ���ν���
CREATE PROCEDURE p_test
IS -- �����
    v_msg VARCHAR2(30) := 'Hello Procedure!';
BEGIN -- �����
    dbms_output.put_line(v_msg);
END; -- �����

EXEC p_test; -- ���ν��� ȣ�⹮

-- IN �Է°��� ������ ���޹޴� ���ν���
CREATE PROCEDURE my_new_job_proc
    (p_job_id IN jobs.job_id%TYPE,
    p_job_title IN jobs.job_title%TYPE,
    p_min_sal IN jobs.min_salary%TYPE,
    p_max_sal IN jobs.max_salary%TYPE
    )
IS
    -- ���ν��� ȣ���� ��, �� ���� �޾Ƽ� INSERT�� ���̱� ������ ���� ������ ��X
BEGIN
    INSERT INTO jobs
    VALUES (p_job_id, p_job_title, p_min_sal, p_max_sal);
    COMMIT;
END;

EXEC my_new_job_proc('JOB1','test job1',10000,20000);
-- ���� �ϳ��� �� �ְų�, �� �ָ� INSERT INTO�� ���� �ʴ´�! (= �Ű����� �ʿ��� �޼���� ���� ����)

SELECT * FROM jobs;

-- �̹� �����ϴ� ���ν����� �����ϴ� ��
-- job_id�� Ȯ���ؼ� �̹� �����ϴ� ������ -> ����
-- ���� -> ���Ӱ� �߰�(job_id�� PK�̱� ����!)
CREATE OR REPLACE PROCEDURE my_new_job_proc -- ���� ���ν��� ������ �����ϰڴ�!
    (p_job_id IN jobs.job_id%TYPE,
    p_job_title IN jobs.job_title%TYPE,
    p_min_sal IN jobs.min_salary%TYPE,
    p_max_sal IN jobs.max_salary%TYPE
    )
IS
    v_cnt NUMBER := 0; -- ���� ����: job_id �Է°��� �޾Ƽ� jobs���̺��� ��ȸ�ϱ� ���� ����(select���)
    
BEGIN
    
    -- ������ job_id�� �ִ������� üũ
    -- �̹� ����: COUNT�� 1, ����X: COUNT�� 0 -> v_cnt�� ����
    SELECT
        COUNT(*)
    INTO
        v_cnt
    FROM jobs
    WHERE job_id = p_job_id;

    IF v_cnt = 0 THEN --> ��ȸ ����� �����ٸ�(v_cnt = 0) INSERT
        INSERT INTO jobs
        VALUES (p_job_id, p_job_title, p_min_sal, p_max_sal);
    ELSE -- �ִٸ�(v_cnt = 1) UPDATE
        UPDATE jobs
        SET
            job_title = p_job_title,
            min_salary = p_min_sal,
            max_salary = p_max_sal
        WHERE job_id = p_job_id;
    END IF;
    COMMIT;
END;

EXEC my_new_job_proc('JOB2','test job2',10000,20000);
SELECT * FROM jobs;

-- ���� ��, 4���� �� ������ �ȵǸ� ���ν����� ȣ����X -> min_sal, max_sal�� ���ָ� �⺻ ���� �����ذڴ�.
CREATE OR REPLACE PROCEDURE my_new_job_proc -- ���� ���ν��� ������ �����ϰڴ�!
    (p_job_id IN jobs.job_id%TYPE,
    p_job_title IN jobs.job_title%TYPE,
    p_min_sal IN jobs.min_salary%TYPE := 0,
    p_max_sal IN jobs.max_salary%TYPE := 1000
    )
IS
    v_cnt NUMBER := 0; -- ���� ����: job_id �Է°��� �޾Ƽ� jobs���̺��� ��ȸ�ϱ� ���� ����(select���)
    
BEGIN
    
    -- ������ job_id�� �ִ������� üũ
    -- �̹� ����: COUNT�� 1, ����X: COUNT�� 0 -> v_cnt�� ����
    SELECT
        COUNT(*)
    INTO
        v_cnt
    FROM jobs
    WHERE job_id = p_job_id;

    IF v_cnt = 0 THEN --> ��ȸ ����� �����ٸ�(v_cnt = 0) INSERT
        INSERT INTO jobs
        VALUES (p_job_id, p_job_title, p_min_sal, p_max_sal);
    ELSE -- �ִٸ�(v_cnt = 1) UPDATE
        UPDATE jobs
        SET
            job_title = p_job_title,
            min_salary = p_min_sal,
            max_salary = p_max_sal
        WHERE job_id = p_job_id;
    END IF;
    COMMIT;
END;

EXEC my_new_job_proc('JOB4','test job4');
SELECT * FROM jobs;

-------------------------------------------------------------------------------------------------------

-- OUT, IN OUT �Ű����� ���
-- OUT ������ ����ϸ� ���ν��� �ٱ������� ���� �����ϴ�.
-- OUT�� �̿��ؼ� ���� ���� �ٱ� �͸� ��Ͽ��� �����ؾ� �մϴ�. -> OUT�� ���� �޾��ֱ� ���ؼ� ������ �����ؾ��ϱ� ���� -> ���� ������ �͸��Ͽ��� �� �� ���� -> �׷��� �͸��Ͽ��� �����ؾ� �Ѵٴ� ��
-- return�� ����ϰ� ����� �� �� ����.

-- OUT
CREATE OR REPLACE PROCEDURE my_new_job_proc
    (p_job_id IN jobs.job_id%TYPE,
    p_job_title IN jobs.job_title%TYPE,
    p_min_sal IN jobs.min_salary%TYPE := 0,
    p_max_sal IN jobs.max_salary%TYPE := 1000, -- ������� �� IN��. ȣ���� �� ���� ���;��ϴ� ������
    p_result OUT VARCHAR2 -- �ٱ��ʿ��� ����� �ϱ� ���� ����, ������ ������ �뵵
    )
IS
    v_cnt NUMBER := 0;
    v_result VARCHAR2(100) := '�������� �ʴ� ���̶� INSERTó�� �Ǿ����ϴ�.';
BEGIN
    
    -- ������ job_id�� �ִ������� üũ
    -- �̹� ����: COUNT�� 1, ����X: COUNT�� 0 -> v_cnt�� ����
    SELECT
        COUNT(*)
    INTO
        v_cnt
    FROM jobs
    WHERE job_id = p_job_id;

    IF v_cnt = 0 THEN --> ��ȸ ����� �����ٸ�(v_cnt = 0) INSERT
        INSERT INTO jobs
        VALUES (p_job_id, p_job_title, p_min_sal, p_max_sal);
    ELSE -- �ִٸ�(v_cnt = 1) ��ȸ�� ����� �����ϰڴ�!
        SELECT
            p_job_id || '�� �ִ� ����: ' || max_salary || ', �ּ� ����: ' || min_salary
        INTO v_result -- ���� ��ȸ ����� ������ ����
        FROM jobs
        WHERE job_id = p_job_id;
    END IF;
    
    -- OUT �Ű������� ��ȸ ����� �Ҵ�.
    p_result := v_result; -- ���ν����� ȣ���ϸ� p_result���� ȣ���� ������ return�Ǿ����
    -- �� ���� v_result�� �����ؼ� ���Ա��� ����� �ϳ�: OUT�� ���ν����� END;�� �ؾ� ���� �Ҵ����
    -- p_result���� ������ �� �� �ִ� �͵� ����, ���� �شٰ� �ص� error�� ������
    COMMIT;
END;

-- �޼����� return -> ���� �׳� ��
-- ���ν����� OUT -> �͸��Լ����� ������ ������ ���ν������� ���������
-- �׷� ���ν����� ������ �޾Ƽ� OUT�� ����� ��Ƽ� ������
DECLARE
    msg VARCHAR2(100); -- return�� ���� ����
BEGIN
    -- ���ν��� ȣ���� �� �ʿ��� EXEC�� �͸��Լ����� �ʿ�X
    my_new_job_proc('JOB2', 'test_job2', 2000, 8000, msg);
    dbms_output.put_line(msg);
    
END;

-- ���: JOB2�� �ִ� ����: 20000, �ּ� ����: 10000

DECLARE
    msg VARCHAR2(100); -- return�� ���� ����
BEGIN
    -- ���ν��� ȣ���� �� �ʿ��� EXEC�� �͸��Լ����� �ʿ�X
    my_new_job_proc('JOB2', 'test_job2', 2000, 8000, msg);
    dbms_output.put_line(msg);
    
    my_new_job_proc('CEO', 'test_ceo', 20000, 80000, msg); -- msg �Ⱦ� ����: ������ v_cnt�� 0�̿��� INSERT�� �Ŵϱ�!
    dbms_output.put_line(msg);
END; -- error: msg���� ���༭ ������
-- �ذ�: msg�� �־��ֱ� �ؾ���. �͸��Ͽ��� v_result�� IS���� ������ ���� �� �⺻ ���� ���

SELECT * FROM jobs;
-- ���: �������� �ʴ� ���̶� INSERTó�� �Ǿ����ϴ�, jobs���̺� CEO�� �߰� ��

-------------------------------------------------------------------------------------------------------------------------

-- IN OUT + OUT�� IN OUT�� ������!
-- IN, OUT ���ÿ� ó��
-- ����: �� �� ������ ��� -> �׷��� ��, OUT�� �޾������� + IN OUT�� ��� �����ϴ���
CREATE OR REPLACE PROCEDURE my_parameter_test_proc
    (
    -- IN: ��ȯ �Ұ�. �޴� �뵵�θ� Ȱ��
    p_var1 IN VARCHAR2, -- IN�� ���� �Ҵ��� �Ұ���.
    -- OUT: �޴� �뵵�� Ȱ�� �Ұ���.
    -- OUT�� �Ǵ� ������ ���ν����� ���� ��(END;). �� �������� ���� �Ҵ��� �ȵ�.
    p_var2 OUT VARCHAR2,
    -- IN OUT: IN�� OUT �� �� ������
    p_var3 IN OUT VARCHAR2
    )
IS
BEGIN
    dbms_output.put_line('p_var1: ' || p_var1);
    dbms_output.put_line('p_var2: ' || p_var2);
    dbms_output.put_line('p_var3: ' || p_var3);
    
    -- p_var1 := '���1'; IN ������ �� �Ҵ� ��ü�� �Ұ���. assignment target���� ������ ����
    p_var2 := '���2';
    p_var3 := '���3';
END;

-- �͸���
DECLARE
    v_var1 VARCHAR2(10) := 'value1'; -- IN: �翬�� ��µ�
    v_var2 VARCHAR2(10) := 'value2'; -- OUT: ���� ���޵��� ����
    v_var3 VARCHAR2(10) := 'value3'; -- IN OUT: IN�� ������ ������ �ֱ���~
BEGIN
    my_parameter_test_proc(v_var1, v_var2, v_var3);
END;

-- ����� ��, ���� ����
DECLARE
    v_var1 VARCHAR2(10) := 'value1'; -- IN: �翬�� ��µ�
    v_var2 VARCHAR2(10) := 'value2'; -- OUT: ���� ���޵��� ����
    v_var3 VARCHAR2(10) := 'value3'; -- IN OUT: IN�� ������ ������ �ֱ���~
    
    
BEGIN
    my_parameter_test_proc(v_var1, v_var2, v_var3);
    
    dbms_output.put_line('v_var1: ' || v_var1); -- IN: OUT �Ұ���
    dbms_output.put_line('v_var2: ' || v_var2); -- OUT: ���ν��� ������ ����� �̾ƿ� �� ����
    dbms_output.put_line('v_var3: ' || v_var3); -- IN OUT: OUT�� ��ɵ� ����
END;

-- ���: �̹���

-- RETURN
-- : �ڹٿ��� void�޼��带 ���� �� return�� ������
-- ����Ŭ������ ���ν����� ������ �����ϱ� ���� return�� �ִ�.
CREATE OR REPLACE PROCEDURE my_new_job_proc
    (p_job_id IN jobs.job_id%TYPE,
    p_result OUT VARCHAR2 
    )
IS
    v_cnt NUMBER := 0;
    v_result VARCHAR2(100) := '�������� �ʴ� ���̶� INSERTó�� �Ǿ����ϴ�.';
BEGIN

    SELECT
        COUNT(*)
    INTO
        v_cnt
    FROM jobs
    WHERE job_id = p_job_id;

    IF v_cnt = 0 THEN
        dbms_output.put_line(p_job_id || '�� ���̺� �������� �ʽ��ϴ�.');
        return; -- ���� SELECT���� �����ϰ� ���� �ʰ� �ϱ� ���� ���ν��� ���� ����
    END IF;
        SELECT
            p_job_id || '�� �ִ� ����: ' || max_salary || ', �ּ� ����: ' || min_salary
        INTO v_result -- ���� ��ȸ ����� ������ ����
        FROM jobs
        WHERE job_id = p_job_id;
    
    p_result := v_result;
    COMMIT;
END;

DECLARE
    msg VARCHAR2(100);
BEGIN
    my_new_job_proc('merong', msg);
    dbms_output.put_line(msg);
END;

------------------------------------------------------------------------------

-- ���� ó��
-- :
-- ������ error�� �����ڴ�
DECLARE
    v_num NUMBER := 0;
BEGIN

    v_num := 10 / 0; -- error: divisor is equal to zero
    
    /*
    OTHERS �ڸ��� ������ Ÿ���� �ۼ��� �ݴϴ�.
    ACCESS_INTO_NULL -> ��ü �ʱ�ȭ�� �Ǿ� ���� ���� ���¿��� ���.
    NO_DATA_FOUND -> SELECT INTO �� �����Ͱ� �� �ǵ� ���� ��
    ZERO_DIVIDE -> 0���� ���� ��
    VALUE_ERROR -> ��ġ �Ǵ� �� ����
    INVALID_NUMBER -> ���ڸ� ���ڷ� ��ȯ�� �� ������ ���
    */
    EXCEPTION -- �� �������� �����ϸ� �ȴ�.
        WHEN ZERO_DIVIDE THEN
            dbms_output.put_line('0���� �����ø� �ȵſ�!');
            dbms_output.put_line('SQL ERROR CODE: ' || SQLCODE);
            dbms_output.put_line('SQL ERROR: ' || SQLERRM); -- SQLERRM: ����Ŭ�� �����ϴ� �����ڵ�+�����޼��� �����ִ� ��ɾ�
        WHEN OTHERS THEN
            -- WHEN���� ������ ���ܰ� �ƴ�(OTHERS �ڸ���) �ٸ� ���ܰ� �߻� �� OTHERS ����.
            dbms_output.put_line('�� �� ���� ���� �߻�!');
END;

























