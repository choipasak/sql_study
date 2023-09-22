
-- �����Լ�
-- ROUND(�ݿø�)
-- ���ϴ� �ݿø� ��ġ�� �Ű������� ����. ������ �ִ°͵� ����
SELECT
    ROUND(3.1415, 3), ROUND(45.923, 0), ROUND(49.984, 0)
FROM dual;

-- TRUNC(����)
-- ������ �Ҽ��� �ڸ������� �߶���ϴ�.
SELECT
    TRUNC(3.1415, 3), TRUNC(45.923, 0), TRUNC(49.984, -1)
FROM dual;

-- ABS (���밪)
SELECT ABS(-34) FROM dual;

-- CEIL(�Ǽ�): �����η� �ø�, FLOOR(�Ǽ�): �����η� ����
SELECT CEIL(3.14), FLOOR(3.14)
FROM dual;

-- MOD(�Ǽ�, ����_��) : ������
SELECT 10/4, MOD(10, 4)
FROM dual;

--------------------------------------------------------------

-- ��¥ �Լ�
-- sysdate: ��ǻ���� ���� ��¥ ������ �����ͼ� �����ϴ� �Լ�. ��� ��
-- systimestamp: ���� ��¥�� �ð��� �����ʱ��� ����.
SELECT sysdate FROM dual; 
SELECT systimestamp FROM dual;

-- ��¥�� ������ �����մϴ�.
SELECT sysdate + 1 FROM dual; -- ���� ��¥�� +1 �� �ؼ� ��ȸ�ϰڴ�.

-- ��¥Ÿ�԰� ��¥Ÿ���� ���� ������ �����մϴ�.
-- ������ ������� �ʽ��ϴ�.
SELECT first_name, sysdate - hire_date
FROM employees; -- �ϼ�

SELECT first_name, hire_date,
(sysdate - hire_date) / 7 AS week
FROM employees; -- �ּ�

SELECT first_name, hire_date,
(sysdate - hire_date) / 365 AS week
FROM employees; -- ���

SELECT first_name, hire_date,
(sysdate - hire_date) / 365 AS week -- ��¥�� ��¥�� +������ �Ұ���
FROM employees; -- ���

-- ��¥ �ݿø�, ����
SELECT ROUND(sysdate) FROM dual; -- ������ ���� �Ŀ� ��ȸ�ϸ� ���� ��¥�� ������
SELECT ROUND(sysdate, 'year') FROM dual; -- ����: ����, ���� �Ǵ�
SELECT ROUND(sysdate, 'month') FROM dual; -- ����: ��, �Ϸ� �Ǵ�
-- ����: ��
-- �� �ָ� �������� ���� �Ѿ���� ���� ���� ù��° ��(��������� �Ͽ���)�� ������.
-- ������ �������� ���̸� ��������, �ĸ� �ݿø��Ǽ� ������ �Ͽ����� ������.
SELECT ROUND(sysdate, 'day') FROM dual;

SELECT TRUNC(sysdate) FROM dual; -- TRUNC: ����
SELECT TRUNC(sysdate, 'year') FROM dual; -- �� �������� ����
SELECT TRUNC(sysdate, 'month') FROM dual; -- �� �������� ����
SELECT TRUNC(sysdate, 'day') FROM dual; -- �� �������� ����






