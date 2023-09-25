/*
# �����̶�?
- ���� �ٸ� ���̺��� ������ ���谡 �����Ͽ�
 1�� �̻�(���� ���� ����)�� ���̺��� �����͸� ��ȸ�ϱ� ���ؼ� ����մϴ�.
- SELECT �÷�����Ʈ FROM ���δ���� �Ǵ� ���̺� (1�� �̻�)
  WHERE ���� ���� (����Ŭ ���� ����) -> ORACLE JOIN ����
*/

-- employees ���̺��� �μ� id�� ��ġ�ϴ� departments ���̺��� �μ� id��
-- ã�Ƽ� SELECT ���Ͽ� �ִ� �÷����� ����ϴ� ������.
SELECT
    e.first_name,
    d.department_name
FROM employees e, departments d -- ������ ���� �ޱ� ���ؼ� ���̺� �̸��� ��Ī�� �����ش�
WHERE e.department_id = d.department_id;  -- join�� �� ���� �׻� ������ ��� �Ѵ�.(����Ŭ ���� ����)

SELECT
    e.first_name, e.last_name, e.hire_date,
    e.salary, e.job_id, d.department_name
FROM employees e INNER JOIN departments d
ON e.department_id = d.department_id; -- ANSI ǥ�� ���� ����(�� �� ��� ����)

/*
������ ���̺� ���������� �����ϴ� �÷��� ��쿡��
���̺� �̸��� �����ص� �����մϴ�. �׷���, �ؼ��� ��Ȯ���� ����
���̺� �̸��� �ۼ��ϼż� �Ҽ��� ǥ���� �ִ� ���� �ٶ����մϴ�.
���̺� �̸��� �ʹ� �� �ÿ��� ALIAS(��Ī)�� �ۼ��Ͽ� Ī�մϴ�.
�� ���̺� ��� ������ �ִ� �÷��� ��� �ݵ�� ����� �ּž� �մϴ�.
*/

-- 3���� ���̺��� �̿��� ���� ����(INNER JOIN)
-- ���� ����: ���� ���ǿ� ��ġ�ϴ� �ุ ��ȯ�ϴ� ����.
-- ���� ���ǰ� ��ġ���� �ʴ� �����ʹ� ��ȸ ��󿡼� ����.
-- ����, ����Ŭ ���� ����
SELECT 
    e.first_name, e.last_name, e.department_id,
    d.department_name,
    e.job_id, j.job_title
FROM employees e, departments d, jobs j
WHERE e.department_id = d.department_id -- ���� e�� d�� �����ְ�(1��),
AND e.job_id = j. job_id; -- jobs�� �����ش�

-- �Ϲ����ǵ� ���ؼ� �غ���!
SELECT
    e.first_name, e.last_name, e.department_id,
    d.department_name,
    e.job_id, j.job_title,
    loc.city
FROM
    employees e,
    departments d,
    jobs j,
    locations loc
WHERE e.department_id = d.department_id
AND e.job_id = j.job_id -- 3, 4
AND d.location_id = loc.location_id -- 2
AND loc.state_province = 'California'; -- 1
-- ��> ���� �ɰ� �;��� �Ϲ����� -> JOIN�� ���ǰ� �Ϲ� ������ ������ �ȵ�
-- �׷��� ����Ŭ ������ ���� �ʴ�!
-- ����: FROM -> WHERE -> AND����(JOIN���ǰ� �Ϲ�����) -> (X) �̷��� �帣�� ����.
/*
1. loc ���̺��� loc.state_province = 'California' ���ǿ� �´� ���� �������
2. location_id ���� ���� ���� ������ �����͸� departments���� ã�Ƽ� ����
3. ���� ������ ����� ������ department_id�� ���� employees ���̺��� �����͸� ã�� ����
4. ���� ����� jobs ���̺��� ���Ͽ� �����ϰ� ���� ����� ���.
=> 3, 4���� ���� ���ÿ� ����ȴٰ� ���� �ȴ�.
   JOIN ������ ���̺��� �����;� ������ �� �ֱ� ������, �Ϲ� ���Ǻ��� ���� �ȴ�.(�������� �������ִ� ��Ƽ�������� �̷��� ������: �޸𸮸� �� ���ϱ�)
*/

-- �ܺ� ����
/*
��ȣ ���̺� ���� ��ġ�Ǵ� ������ ����Ǵ� ���� ���ΰ��� �ٸ���
��� �� ���̺� ���� ���� ������ �ش� row���� ��ȸ �����
��� ���ԵǴ� ������ ���մϴ�.
*/

-- ����Ŭ ����
SELECT
    e.first_name,
    d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id(+); -- > ���ǿ� ���� �ʴ� �����ͱ��� ǥ���ϰڴ�.
-- ���: �� 107���� ����, (+) �����Խ�: ��� 106��
-- ���������� ǥ���� ���� ��� NULL ���� ���� �������� ����. ex)���� �ۼ��� ����� ����ʹ�! ���� ���
-- �ܺ������� e.department_id�� �������� d.department_id(+)�� �پ ��µȴ�.
-- �׷��� department_id�� �ִ� Kimberely�� department_name�� ������ �ܺ� ������ �ϸ� d.department_id�� null���� ������ �ٴ´�.
-- (+)��ȣ������ �ܺ� ������ ���� ǥ�� �Ѵ�.


SELECT
    e.first_name,
    d.department_name,
    loc.location_id
FROM employees e, departments d, locations loc
WHERE e.department_id = d.department_id(+)
AND d.location_id = loc.location_id; -- ����: (+)�� �پ� �����ϱ� �ܺ� �������� 107���� ������
-- ���: 106��
-- ����: 
/*
employees ���̺��� �����ϰ�, departments ���̺��� �������� �ʾƵ�
(+)�� ���� ���� ���̺��� �������� �Ͽ� departments ���̺��� ���ο�
�����϶�� �ǹ̸� �ο��ϱ� ���� ��ȣ�� ���Դϴ�.
�ܺ� ������ ����ߴ���, ���Ŀ� ���� ������ ����ϸ�
���� ������ �켱������ �ν��մϴ�.
*/

SELECT
    e.employee_id, e.first_name,
    e.department_id,
    j.start_date, j.end_date, j.job_id
FROM
    employees e,
    job_history j
WHERE e.employee_id = j.employee_id; -- ���� ����

-- employees�� �������� job_history�� �ٿ��� �ܺ� ����
-- �ܺ� ���� ���� �� ��� ���ǿ� (+)�� �ٿ��� �ϸ�
-- �Ϲ� ���ǿ��� (+)�� ������ ������ �����Ͱ� �����Ǵ� ������ �߻�
SELECT
    e.employee_id, e.first_name,
    e.department_id,
    j.start_date, j.end_date, j.job_id
FROM
    employees e,
    job_history j
WHERE e.employee_id = j.employee_id(+);
AND j.department_id(+) = 80;







