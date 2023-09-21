
-- lower(�ҹ���), initcap(�ձ��ڸ� �빮��), upper(�빮��)
SELECT * FROM dual;

/*
dual�̶�� ���̺��� sys(�ֻ��� ������)�� �����ϴ� ����Ŭ�� ǥ�� ���̺�μ�,
���� �� �࿡ �� �÷��� ��� �ִ� dummy ���̺� �Դϴ�.
�Ͻ����� ��� �����̳� ��¥ ���� � �ַ� ����մϴ�.
��� ����ڰ� ������ �� �ֽ��ϴ�.
���� ���̺��̴�. = �׽�Ʈ�� ���̺��̴�.
������ ������ �� �ִ� ���̺��̴�!
������ �ϰ� ���� �ʰ�, ����� ȭ�鿡 ���� ���� �� ����Ѵ�!
*/

SELECT
    'abcDEF', lower('abcDEF'), upper('abcDEF')
FROM
    dual;
    
SELECT
    last_name,
    LOWER(last_name),
    INITCAP(last_name),
    UPPER(last_name)
FROM employees;

-- ��Ȯ�� ���� �� ��, �ƿ� LOWER�� ������Ѽ� ���縵�� �¾Ƶ� ��ȸ�� �����ϰ� �����.
SELECT last_name FROM employees
WHERE LOWER(last_name) = 'austin';
    
-- length(����), instr(���� ã��, ������ 0�� ��ȯ, ������ �ε��� ��) -> ù��° �ε����� 1��.
SELECT
    'abcDEF', LENGTH('abcDEF'), INSTR('abcDEF', 'a')
FROM dual;
    
SELECT
    first_name, LENGTH(first_name), INSTR(first_name, 'a')
FROM employees;

-- SUBSTR(�ڸ� ���ڿ�, ���� �ε���, ����(���� �ε������� �����)): ���ڿ� �κ� ����
-- SUBSTR(�ڸ� ���ڿ�, ���� �ε���) -> ���ڿ� ������
-- CONCAT(): ���� ����
-- �ε��� 1���� ����.
SELECT
    'abcdef' AS ex,
    SUBSTR('abcdef', 1, 4), -- 
    CONCAT('abc', 'def') -- �Ű� ���� 2���� �޴´�.
FROM dual;

SELECT
    first_name,
    SUBSTR(first_name, 1, 3), -- �ε��� 1�̻����, �ε��� 3���� ����
    CONCAT(first_name, last_name)
FROM employees;
    
-- LPAD, RPAD (�� ������ ������ ���ڿ��� ä���)
SELECT
    LPAD('abc', 10, '*'),
    RPAD('abc', 10, '*') -- ���ڿ� ���� 10���ڸ� *�� ä���
FROM dual;
-- ����) ���̵� ã���ϸ� ���� 3���� ���� *�� ��Ÿ���ش�.

-- LTRIM(), RTRIM(), TRIM() ��� ���� ����
-- LTRIM(param1, param2): param2�� ���� param1���� ã�Ƽ�(Ž��) ����. (���ʺ���)
-- RTRIM(param1, param2): param2�� ���� param1���� ã�Ƽ�(Ž��) ����. (�����ʺ���)
SELECT LTRIM('javascript_java', 'java') FROM dual;
SELECT RTRIM('javascript_java', 'java') FROM dual;
SELECT TRIM('         java          ') FROM dual;

-- replace()
SELECT
    REPLACE('My dream is president', 'president', 'programmer')
FROM dual;

-- REPLACE() ��ø ����
SELECT
    REPLACE(REPLACE('My dream is president', 'president', 'programmer'), ' ', '')
FROM dual;
-- ���� ���� �ִ� �Լ��� �ٸ� �Լ��� �Ű� ������ �����ϴ�(IN �ڹ�)��� ���� SQL������ �����ߴ�!

SELECT
    REPLACE(CONCAT('HELLO', ' WORLD!'), '!', '?')
FROM dual;

/*
���� 1.
EMPLOYEES ���̺��� �̸�, �Ի����� �÷����� �����ؼ� �̸������� �������� ��� �մϴ�.
���� 1) �̸� �÷��� first_name, last_name�� �ٿ��� ����մϴ�.
���� 2) �Ի����� �÷��� xx/xx/xx�� ����Ǿ� �ֽ��ϴ�. xxxxxx���·� �����ؼ� ����մϴ�.
*/
SELECT
    CONCAT(first_name, ' ' || last_name) AS �̸�,
    REPLACE(hire_date, '/', '') AS �Ի�����
FROM employees
ORDER BY first_name;


/*
���� 2.
EMPLOYEES ���̺��� phone_number�÷��� ###.###.####���·� ����Ǿ� �ִ�
���⼭ ó�� �� �ڸ� ���� ��� ���� ������ȣ (02)�� �ٿ� 
��ȭ ��ȣ�� ����ϵ��� ������ �ۼ��ϼ���. (CONCAT, SUBSTR ���)
*/
SELECT
    CONCAT('(02)', SUBSTR(phone_number, 4, 12)) AS phone_number
FROM employees;

/*
���� 3. 
EMPLOYEES ���̺��� JOB_ID�� it_prog�� ����� �̸�(first_name)�� �޿�(salary)�� ����ϼ���.
���� 1) ���ϱ� ���� ���� �ҹ��ڷ� ���ؾ� �մϴ�.(��Ʈ : lower �̿�)
���� 2) �̸��� �� 3���ڱ��� ����ϰ� �������� *�� ����մϴ�. 
�� ���� �� ��Ī�� name�Դϴ�.(��Ʈ : rpad�� substr �Ǵ� substr �׸��� length �̿�)
���� 3) �޿��� ��ü 10�ڸ��� ����ϵ� ������ �ڸ��� *�� ����մϴ�. 
�� ���� �� ��Ī�� salary�Դϴ�.(��Ʈ : lpad �̿�)
*/
SELECT
    RPAD(SUBSTR(job_id, 1, 3), LENGTH(job_id), '*') AS name,
    LPAD(salary, 10 , '*') AS salary
FROM employees
WHERE LOWER(job_id) = 'it_prog';


