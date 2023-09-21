
-- lower(소문자), initcap(앞글자만 대문자), upper(대문자)
SELECT * FROM dual;

/*
dual이라는 테이블은 sys(최상위 관리자)가 소유하는 오라클의 표준 테이블로서,
오직 한 행에 한 컬럼만 담고 있는 dummy 테이블 입니다.
일시적인 산술 연산이나 날짜 연산 등에 주로 사용합니다.
모든 사용자가 접근할 수 있습니다.
더미 테이블이다. = 테스트용 테이블이다.
누구나 접근할 수 있는 테이블이다!
저장은 하고 싶지 않고, 결과는 화면에 띄우고 싶을 때 사용한다!
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

-- 정확한 값을 모를 때, 아예 LOWER를 적용시켜서 스펠링만 맞아도 조회가 가능하게 만든다.
SELECT last_name FROM employees
WHERE LOWER(last_name) = 'austin';
    
-- length(길이), instr(문자 찾기, 없으면 0을 반환, 있으면 인덱스 값) -> 첫번째 인덱스가 1임.
SELECT
    'abcDEF', LENGTH('abcDEF'), INSTR('abcDEF', 'a')
FROM dual;
    
SELECT
    first_name, LENGTH(first_name), INSTR(first_name, 'a')
FROM employees;

-- SUBSTR(자를 문자열, 시작 인덱스, 길이(시작 인덱스부터 몇개인지)): 문자열 부분 추출
-- SUBSTR(자를 문자열, 시작 인덱스) -> 문자열 끝까지
-- CONCAT(): 문자 연결
-- 인덱스 1부터 시작.
SELECT
    'abcdef' AS ex,
    SUBSTR('abcdef', 1, 4), -- 
    CONCAT('abc', 'def') -- 매개 값을 2개만 받는다.
FROM dual;

SELECT
    first_name,
    SUBSTR(first_name, 1, 3), -- 인덱스 1이상부터, 인덱스 3이하 까지
    CONCAT(first_name, last_name)
FROM employees;
    
-- LPAD, RPAD (좌 우측을 지정한 문자열로 채우기)
SELECT
    LPAD('abc', 10, '*'),
    RPAD('abc', 10, '*') -- 문자열 포함 10글자를 *로 채운다
FROM dual;
-- 예시) 아이디 찾기하면 앞의 3글자 빼고 *로 나타내준다.

-- LTRIM(), RTRIM(), TRIM() 모두 공백 제거
-- LTRIM(param1, param2): param2의 값을 param1에서 찾아서(탐색) 제거. (왼쪽부터)
-- RTRIM(param1, param2): param2의 값을 param1에서 찾아서(탐색) 제거. (오른쪽부터)
SELECT LTRIM('javascript_java', 'java') FROM dual;
SELECT RTRIM('javascript_java', 'java') FROM dual;
SELECT TRIM('         java          ') FROM dual;

-- replace()
SELECT
    REPLACE('My dream is president', 'president', 'programmer')
FROM dual;

-- REPLACE() 중첩 가능
SELECT
    REPLACE(REPLACE('My dream is president', 'president', 'programmer'), ' ', '')
FROM dual;
-- 리턴 값이 있는 함수는 다른 함수의 매개 값으로 가능하다(IN 자바)라는 말이 SQL에서도 가능했다!

SELECT
    REPLACE(CONCAT('HELLO', ' WORLD!'), '!', '?')
FROM dual;

/*
문제 1.
EMPLOYEES 테이블에서 이름, 입사일자 컬럼으로 변경해서 이름순으로 오름차순 출력 합니다.
조건 1) 이름 컬럼은 first_name, last_name을 붙여서 출력합니다.
조건 2) 입사일자 컬럼은 xx/xx/xx로 저장되어 있습니다. xxxxxx형태로 변경해서 출력합니다.
*/
SELECT
    CONCAT(first_name, ' ' || last_name) AS 이름,
    REPLACE(hire_date, '/', '') AS 입사일자
FROM employees
ORDER BY first_name;


/*
문제 2.
EMPLOYEES 테이블에서 phone_number컬럼은 ###.###.####형태로 저장되어 있다
여기서 처음 세 자리 숫자 대신 서울 지역변호 (02)를 붙여 
전화 번호를 출력하도록 쿼리를 작성하세요. (CONCAT, SUBSTR 사용)
*/
SELECT
    CONCAT('(02)', SUBSTR(phone_number, 4, 12)) AS phone_number
FROM employees;

/*
문제 3. 
EMPLOYEES 테이블에서 JOB_ID가 it_prog인 사원의 이름(first_name)과 급여(salary)를 출력하세요.
조건 1) 비교하기 위한 값은 소문자로 비교해야 합니다.(힌트 : lower 이용)
조건 2) 이름은 앞 3문자까지 출력하고 나머지는 *로 출력합니다. 
이 열의 열 별칭은 name입니다.(힌트 : rpad와 substr 또는 substr 그리고 length 이용)
조건 3) 급여는 전체 10자리로 출력하되 나머지 자리는 *로 출력합니다. 
이 열의 열 별칭은 salary입니다.(힌트 : lpad 이용)
*/
SELECT
    RPAD(SUBSTR(job_id, 1, 3), LENGTH(job_id), '*') AS name,
    LPAD(salary, 10 , '*') AS salary
FROM employees
WHERE LOWER(job_id) = 'it_prog';


