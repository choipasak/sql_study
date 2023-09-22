
-- �� ��ȯ �Լ� TO_CHAR, TO_NUMBER, TO_DATE

-- ��¥�� ���ڷ� TO_CAHR(��, ����)
SELECT TO_CHAR(sysdate) FROM dual; -- ����� ������ �ٸ��� ����(��¥Ÿ�� -> ����)
-- ���: (���� Ÿ��)23/09/22

-- TO_CHAR ��� ���: ���ϴ� ��¥�� ���·� ������ ��������
SELECT TO_CHAR(sysdate, 'YYYY-MM-DD DY PM HH:MI:SS') FROM dual;
-- ���: (���� Ÿ��)2023-09-22 �� ���� 10:54:53

SELECT TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS') FROM dual;
-- HH24: 00�ú��� 24�ñ����� ǥ�� �ϰڴ�.
-- ���: (���� Ÿ��)2023-09-22 10:56:58

-- ���� ���ڿ� �Բ� ����ϰ� ���� ���ڸ� ""�� ���� �����մϴ�.
SELECT
    first_name,
    --TO_CHAR(hire_date, 'YYYY�� MM�� DD��') -- �̷��� �ϸ� ������(��: �ѱ��� ������ ���ڰ� �ƴ϶�)
    TO_CHAR(hire_date, 'YYYY"��" MM"��" DD"��"') -- �ذ�: �ѱ��� ""�� �����ش�.
FROM employees;

-- ���ڸ� ���ڷ� TO_CHAR(��, ����)
-- ���Ŀ��� ����ϴ� '9'�� ���� ���� 9�� �ƴ϶� �ڸ����� ǥ���ϱ� ���� ��ȣ�Դϴ�.
SELECT TO_CHAR(20000, '99999') FROM dual;
-- ���:  (���� Ÿ��)20000
-- '99999': ���� ���ڰ��ƴ϶� ��ȣ�̴� -> �ڸ����� ǥ���ϴ� ��ȣ
-- �ؼ�: 20000�̶�� ���ڸ� 5�ڸ��� ǥ���� ��!

SELECT TO_CHAR(20000, '9999') FROM dual;
-- �ؼ�: 20000��� ���ڸ� 4�ڸ��� ǥ���غ���
-- ���: (���� Ÿ��)##### -> �־��� �ڸ����� ���ڸ� ��� ǥ���� �� ��� ��� #���� ǥ�� �˴ϴ�.

SELECT TO_CHAR(20000.29, '99999.9') FROM dual;
-- ���:  (���� Ÿ��)20000.3
-- �˾Ƽ� �ݿø��� ���ش�.

-- ����, 20000�� ���̶��?
SELECT TO_CHAR(20000, '99,999') FROM dual;
-- ���:  (���� Ÿ��)20,000

SELECT
    TO_CHAR(salary, 'L99,999') AS salary
FROM employees; -- �ξ� ���� ������ ���� Ÿ���� �� salary
-- ���� Ÿ������ ��ȯ�߱� ������ ������ �Ұ���
-- ���Ĺ��ڿ� L�� ������ָ� ��ȭ������ȣ(��)�� �ۼ��ȴ�.

-- ���ڸ� ���ڷ� TO_NUMBER(��, ����)
-- �ڹٿ����� �׳� �������ִµ� ���� � ����� ���ñ�?
SELECT '2000' + 2000 FROM dual;
-- ���: 4000
-- �ڵ� �� ��ȯ (���� -> ����)

SELECT TO_NUMBER('2000') + 2000 FROM dual; -- ����� �� ��ȯ
-- ���: 4000

SELECT '$3,300' + 2000 FROM dual; -- ����
-- �ذ�: ��ȣ+���ڰ� � �������� ������ �ָ� �ȴ�.
SELECT TO_NUMBER('$3,300', '$9,999') + 2000 FROM dual;
-- ���: 5300

-- ���ڸ� ��¥�� ��ȯ�ϴ� �Լ� TO_DATE(��, ����)
SELECT TO_DATE('2023-04-13') FROM dual;
-- ���ϴ� ��¥�� �Է��ؼ� ���� ��¥ Ÿ������ ��ȯ�� ��!
-- ���: 23/04/13

SELECT sysdate - '2021-03-26' FROM dual; -- error! ��¥Ÿ�� - ����Ÿ��: ���� �Ұ���
-- ���� -> ��¥ ��ȯ �Ŀ�, ����
SELECT sysdate - TO_DATE('2021-03-26') FROM dual;
SELECT TO_DATE('2020/12/25', 'YY-MM-DD') FROM dual; -- ������ �������

-- �־��� ���ڿ��� ��� ��ȯ�ؾ� �մϴ�.
SELECT TO_DATE('2021-03-31 12:23:50', 'YY-MM-DD') FROM dual; -- error: ���� �������� ���¸� �� �ۼ��� �����(HH:MI:SS �߰�)

-- xxxx�� xx�� xx�� ���ڿ� �������� ��ȯ�� ������.
-- ��ȸ �÷����� dateInfo ��� �ϰڽ��ϴ�.
-- ''20050102'��
-- 1. ���ڿ��� ��¥�� �ٲ������
-- 2. ���ڿ��� �ٲ��ָ鼭 ���� ������ �ٲ�����Ѵ�.
SELECT
    TO_CHAR(
        TO_DATE('20050102', 'YYYYMMDD'),-- Q
        'YYYY"��" MM"��" DD"��"'
    )AS dateInfo
FROM dual;

-- NULL�� ���¸� ��ȯ�ϴ� �Լ� NVL(�÷�, ��ȯ�� Ÿ�� ��)
SELECT NULL FROM dual; -- �׳� null�� ��� ������ �� Ȯ�ο�
SELECT NVL(NULL, 0) FROM dual;
-- ���: 0

SELECT
    first_name,
    NVL(commission_pct, 0) AS comm_pct -- ������ 0�� �ƴ϶� null�� ������.
FROM employees;

-- NULL ��ȯ �Լ� NVL2(�÷�, null�� �ƴ� ����� ��, null�� ����� ��)
-- NULL�ƴ� ��
SELECT
    NVL2('abc', '�ξƴ�', '����') AS comm_pct
FROM dual; -- ���: �ξƴ�

-- NULL�� ��
SELECT
    NVL2(NULL, '�ξƴ�', '����') AS comm_pct
FROM dual; -- ���: ����

SELECT
    first_name,
    NVL2(commission_pct, 'true', 'false') AS comm_pct
FROM employees; -- ���: null�� ������� false�� ������, �޴� ������� true�� ����
-- �̷��� �ۼ��ϸ� ���� ��: �÷��� Ÿ���� ������� �ʰ� ���ڷ� ��� ��츦 ������ �� �� ����!

-- 
SELECT
    first_name,
    commission_pct,
    salary,
    NVL2(
        commission_pct,
        salary + (salary * commission_pct), -- (salary * commission_pct)�� NVL2()�� ������� ������, �׳� null������ ��µȴ�.
        salary
    )AS real_salary
FROM employees;

-- DECODE(�÷� Ȥ�� ǥ����, �׸�1, ���1, �׸�2, ���2 ... default)
-- switch-case�� ����� ��
SELECT
    DECODE('C', 'A', 'A�Դϴ�.', 'B', 'B�Դϴ�.', 'C', 'C�Դϴ�.', '���� �װ�?')
FROM dual;
-- ���: C�Դϴ�.

SELECT
    job_id,
    salary,
    DECODE(
        job_id, -- ����
        'IT_PROG', salary*1.1,
        'FI_MGR', salary*1.2,
        'AD_VP', salary*1.3,
        salary
    ) AS result
FROM employees;

-- CASE WHEN THEN END


SELECT
    first_name,
    job_id,
    salary,
    (CASE job_id
        WHEN 'IT_PROG' THEN salary*1.1
        WHEN 'FI_MGR' THEN salary*1.2
        WHEN 'AD_VP' THEN salary*1.3
        WHEN 'FI_ACCOUNT' THEN salary*1.4
        ELSE salary
    END) AS result
FROM employees;

/*
���� 1.
�������ڸ� �������� employees���̺��� �Ի�����(hire_date)�� �����ؼ� �ټӳ���� 17�� �̻���
����� ������ ���� ������ ����� ����ϵ��� ������ �ۼ��� ������. 
���� 1) �ټӳ���� ���� ��� ������� ����� �������� �մϴ�
*/
SELECT
    employee_id AS �����ȣ,
    CONCAT(first_name, ' ' || last_name) AS �̸�,
    hire_date AS �Ի�����,
    TRUNC(TO_CHAR(sysdate - hire_date) / 365, 0) AS �ټӳ�� -- 0�� ��������(�⺻��)
FROM employees
WHERE (sysdate - hire_date) / 365 >= 17
ORDER BY �ټӳ�� DESC;
-- �� WHERE������ �ټӳ���� �������� �ϸ� �ȵǳ�
/*
SQL ��������
FROM���� ���� ���� ����ǰ�, ������ ���� ������ ���� ������
�ټӳ���� ������ �� �� ����.(���� �� �� ���� ������/SELECT���� ��ȸ�� �ؾ� �� �� �־���)
���� ����: FROM -> WHERE -> SELECT -> ORDER BY
*/

/*
���� 2.
EMPLOYEES ���̺��� manager_id�÷��� Ȯ���Ͽ� first_name, manager_id, ������ ����մϴ�.
100�̶�� �������, 
120�̶�� �����ӡ�
121�̶�� ���븮��
122��� �����塯
�������� ���ӿ��� ���� ����մϴ�.
���� 1) department_id�� 50�� ������� ������θ� ��ȸ�մϴ�
*/
SELECT
    first_name,
    manager_id,
    DECODE(
        manager_id,
        100, '���',
        120, '����',
        121, '�븮',
        122, '����',
        '�ӿ�'
    )AS ����
FROM employees
WHERE department_id = 50;




