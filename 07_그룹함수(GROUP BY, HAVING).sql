
-- �׷� �Լ� AVG, MAX, MIN, SUM, COUNT
-- �׷�ȭ�� �Ǿ� �־�� ����� �� �ִ� �Լ���

SELECT -- Q. ������
    AVG(salary),
    MAX(salary),
    MIN(salary),
    SUM(salary),
    COUNT(salary)
FROM employees;
-- �׷�ȭ�� ���� ���� ������ ���̺��� ��ü �����Ͱ� �׷��� �ȴ�.

-- COUNT: ������ �˰� ���� �� ����Ѵ�.
-- employees�� �ִ� �������� ������ �ñ��ϴ�!
SELECT COUNT(*) FROM employees; -- �� �� �������� ��
-- ���: 107

SELECT COUNT(first_name) FROM employees;
-- ���: 107 -> first_name�� ���� ����� ������ �� �� �� ����!

SELECT COUNT(commission_pct) FROM employees; -- null�� �ƴ� ���� ��
-- ���: 35 -> null�� ���� �ʴ´�.
-- �׷��� �� �������� ������ �˰� �ʹٸ� �׳� *�� ���ִ°� ����!

SELECT COUNT(manager_id) FROM employees;
-- ���: 106 -> null ����

-- �׷�ȭ
-- �μ� ���� �׷�ȭ, �׷��Լ��� ���

-- �׷캰 salary�� ����� ������!
SELECT
    department_id,
    AVG(salary)
FROM employees
GROUP BY department_id; -- �׷��� department_id�� ������.

-- ������ ��
-- �׷� �Լ��� �Ϲ� �÷��� ���ÿ� �׳� ����� �� �� �����ϴ�.
SELECT
    department_id,
    AVG(salary)
FROM employees; -- error
-- error: AVG()�ϳ��� �־��ٸ� employees ���̺��� �׷����� ��Ƽ� ��� ����
-- ������ department_id�÷��� �߰��Ǹ鼭 AVG(salary)�� �׷����� ��� ��ƾ� ���� ���� ������ ����.

-- GROUP BY���� ����� �� GROUP���� ������ ������ �ٸ� �÷��� ��ȸ�� �� �����ϴ�.
SELECT
    job_id, -- error
    department_id,
    AVG(salary)
FROM employees
GROUP BY department_id;
-- error: job_id�� �׷�ȭ�� ���� �ʾҴ�.
-- ���� ��ȸ�ϰ��� �ϴ� �÷��� �׷�ȭ�� ���� ������ ERROR�� ����.

-- �ذ�: GROUP BY�� 2�� �̻� ���
SELECT
    job_id, -- error
    department_id,
    AVG(salary)
FROM employees
GROUP BY department_id, job_id
ORDER BY department_id; -- ����
-- job_id�� 1�� �̻��̾ department_id�� �ߺ����� ���´�.
-- ����: AVG(salary)�� �ٸ��� ����

-- GROUP BY������ ����ȭ.
-- GROUP BY�� ���� �׷�ȭ �� �� ������ �� ��� HAVING�� ���.
SELECT
    department_id,
    AVG(salary)
FROM employees
GROUP BY department_id
HAVING SUM(salary) > 100000;
-- SUM(salary) > 100000: �μ��� salary �� ���� 100000�� �Ѵ� �μ����

SELECT
    job_id,
    COUNT(*) -- Q. *��
FROM employees
GROUP BY job_id
HAVING COUNT(*) >= 5;
-- job_id(����)�� �׷�ȭ�� �Ұǵ� job_id�� �ش��ϴ� ����� 5�� �̻��̾�� ��ȸ �Ұž�

-- �μ� ���̵� 50 �̻��� �͵��� �׷�ȭ ��Ű��, �׷� ���� ����� 5000 �̻� ��ȸ
-- 1. �μ� ���̵� 50 �̻��� �͵��� �׷�ȭ ��Ű��, -> �Ϲ� ����(WHERE)
-- 2. �׷� ���� ����� 5000 �̻� ��ȸ -> �׷�ȭ ����(HAVING)
SELECT
    department_id,
    AVG(salary) AS ���
FROM employees
WHERE department_id >= 50
GROUP BY job_id, department_id
HAVING AVG(salary) >= 5000
ORDER BY department_id DESC;

/*
���� 1.
1-1. ��� ���̺��� JOB_ID�� ��� ���� ���ϼ���.
1-2. ��� ���̺��� JOB_ID�� ������ ����� ���ϼ���. ������ ��� ������ �������� �����ϼ���.
*/
SELECT
    job_id,
    COUNT(*) AS �����
FROM employees
GROUP BY job_id;

SELECT
    job_id,
    AVG(salary) AS �μ�����ձ޿�
FROM employees
GROUP BY job_id
ORDER BY �μ�����ձ޿� DESC;

/*
���� 2.
��� ���̺��� �Ի� �⵵ �� ��� ���� ���ϼ���.
(TO_CHAR() �Լ��� ����ؼ� ������ ��ȯ�մϴ�. �׸��� �װ��� �׷�ȭ �մϴ�.)
*/
SELECT
    TO_CHAR(hire_date, 'YYYY') AS �Ի�⵵,
    COUNT(TO_CHAR(hire_date, 'YYYY')) AS �ο�
FROM employees
GROUP BY TO_CHAR(hire_date, 'YYYY')
ORDER BY �Ի�⵵;

/*
���� 3.
�޿��� 5000 �̻��� ������� �μ��� ��� �޿��� ����ϼ���. 
�� �μ� ��� �޿��� 7000�̻��� �μ��� ����ϼ���.
*/
SELECT
    department_id,
    TRUNC(AVG(salary), 2) AS ��ձ޿�
FROM employees
WHERE salary >= 5000
GROUP BY department_id
HAVING AVG(salary) >= 7000;


/*
���� 4.
��� ���̺��� commission_pct(Ŀ�̼�) �÷��� null�� �ƴ� �������
department_id(�μ���) salary(����)�� ���, �հ�, count�� ���մϴ�.
���� 1) ������ ����� Ŀ�̼��� �����Ų �����Դϴ�.
���� 2) ����� �Ҽ� 2° �ڸ����� ���� �ϼ���.
*/
SELECT
    department_id,
    TRUNC(AVG(salary + (salary*commission_pct)), 2) AS �μ����������,
    SUM(salary + (salary*commission_pct)) AS �������հ�,
    COUNT(*) AS �ο���
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY department_id;







