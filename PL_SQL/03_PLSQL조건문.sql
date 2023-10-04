
SET SERVEROUTPUT ON; -- ��¹� Ȱ��ȭ

-- IF�� (�⺻��)
DECLARE
    v_num1 NUMBER := 10;
    v_num2 NUMBER := 15;
BEGIN
    IF
        v_num1 > v_num2 -- IF�� ����
    THEN -- IF���� ����(��)
        dbms_output.put_line(v_num1 || '��(��) ū ��');
    ELSE -- (����)
        dbms_output.put_line(v_num2 || '��(��) ū ��');
    END IF; -- IF���� ���� ����
    
END;

-- ELSIF�� (ELSEIF��� ���� ���� ELSIF�� ǥ����)
DECLARE
    v_salary NUMBER := 0;
    v_department_id NUMBER := 0;
BEGIN
    -- v_department_id�� ���� ����
    v_department_id := ROUND(DBMS_RANDOM.VALUE(10, 120), -1); -- DB���� ���� ����: DBMS_RANDOM.VALUE(���� ���� ����[�̻�], ���� �� ����[�̸�]) / ROUND�� �ǹ�: ������ 10, 20, 30.. ó�� 10�� ������ ��� ��µǰ� �ϱ� ���ؼ� �ø��Լ� �ȿ��� ���� ���� + 1���ڸ����� �ø��ϱ�(-1)
    
    SELECT
        salary
    INTO
        v_salary
    FROM employees
    WHERE department_id = v_department_id -- department_id�� ������ ������ ���� ��,
    AND ROWNUM = 1; -- ù��° ���� ���ؼ� ������ ������ ����
    
    dbms_output.put_line('��ȸ�� �޿�: ' || v_salary);
    
    IF
        v_salary <= 5000
    THEN
        dbms_output.put_line('�޿��� �� ����');
    ELSIF
        v_salary <= 9000
    THEN
        dbms_output.put_line('�޿��� �߰���');
    ELSE
        dbms_output.put_line('�޿��� ����');
    END IF;
    
END;

-- switch-case�� -> case�� �̶�� ��
DECLARE
    v_salary NUMBER := 0;
    v_department_id NUMBER := 0;
BEGIN
    -- v_department_id�� ���� ����
    v_department_id := ROUND(DBMS_RANDOM.VALUE(10, 120), -1);

    SELECT
        salary
    INTO
        v_salary
    FROM employees
    WHERE department_id = v_department_id -- department_id�� ������ ������ ���� ��,
    AND ROWNUM = 1; -- ù��° ���� ���ؼ� ������ ������ ����
    
    dbms_output.put_line('��ȸ�� �޿�: ' || v_salary);
    
    -- CASE��
    CASE
        WHEN v_salary <= 5000 THEN
            dbms_output.put_line('�޿��� �� ����');
        WHEN v_salary <= 9000 THEN
            dbms_output.put_line('�޿��� �߰���');
        ELSE
            dbms_output.put_line('�޿��� ����');
    END CASE;

END;

-- ��ø IF��
DECLARE
    v_salary NUMBER := 0;
    v_department_id NUMBER := 0;
    v_commission_pct NUMBER := 0;
BEGIN
    -- v_department_id�� ���� ����
    v_department_id := ROUND(DBMS_RANDOM.VALUE(10, 110), -1);
    
    SELECT
        salary, commission_pct
    INTO
        v_salary, v_commission_pct
    FROM employees
    WHERE department_id = v_department_id
    AND ROWNUM = 1;
    
    dbms_output.put_line('��ȸ�� �޿�: ' || v_salary);
    
    IF v_commission_pct > 0 THEN
        IF v_commission_pct > 0.15 THEN
            dbms_output.put_line('Ŀ�̼��� 0.15�̻���!');
            dbms_output.put_line(v_salary * v_commission_pct);
        END IF; -- ������ IF���� �����ϰ�,
    ELSE
        dbms_output.put_line('Ŀ�̼��� 0.15������!');
    END IF; -- �ٱ��� IF���� ������ �ش�.
    
END; --QQQQQQQQQQQQQQQQQQQQ




































