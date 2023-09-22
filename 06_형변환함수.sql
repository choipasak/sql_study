
-- 형 변환 함수 TO_CHAR, TO_NUMBER, TO_DATE

-- 날짜를 문자로 TO_CAHR(값, 형식)
SELECT TO_CHAR(sysdate) FROM dual; -- 결과는 원래와 다를게 없음(날짜타입 -> 문자)
-- 결과: (문자 타입)23/09/22

-- TO_CHAR 사용 결과: 원하는 날짜의 형태로 변경이 가능해짐
SELECT TO_CHAR(sysdate, 'YYYY-MM-DD DY PM HH:MI:SS') FROM dual;
-- 결과: (문자 타입)2023-09-22 금 오전 10:54:53

SELECT TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS') FROM dual;
-- HH24: 00시부터 24시까지로 표현 하겠다.
-- 결과: (문자 타입)2023-09-22 10:56:58

-- 서식 문자와 함께 사용하고 싶은 문자를 ""로 묶어 전달합니다.
SELECT
    first_name,
    --TO_CHAR(hire_date, 'YYYY년 MM월 DD일') -- 이렇게 하면 오류남(왜: 한글이 포맷팅 문자가 아니라서)
    TO_CHAR(hire_date, 'YYYY"년" MM"월" DD"일"') -- 해결: 한글을 ""로 감싸준다.
FROM employees;

-- 숫자를 문자로 TO_CHAR(값, 형식)
-- 형식에서 사용하는 '9'는 실제 숫자 9가 아니라 자릿수를 표현하기 위한 기호입니다.
SELECT TO_CHAR(20000, '99999') FROM dual;
-- 결과:  (문자 타입)20000
-- '99999': 실제 숫자가아니라 기호이다 -> 자릿수를 표현하는 기호
-- 해석: 20000이라는 숫자를 5자리로 표현해 줘!

SELECT TO_CHAR(20000, '9999') FROM dual;
-- 해석: 20000라는 숫자를 4자리로 표현해봐라
-- 결과: (문자 타입)##### -> 주어진 자릿수에 숫자를 모두 표기할 수 없어서 모두 #으로 표기 됩니다.

SELECT TO_CHAR(20000.29, '99999.9') FROM dual;
-- 결과:  (문자 타입)20000.3
-- 알아서 반올림도 해준다.

-- 만약, 20000이 돈이라면?
SELECT TO_CHAR(20000, '99,999') FROM dual;
-- 결과:  (문자 타입)20,000

SELECT
    TO_CHAR(salary, 'L99,999') AS salary
FROM employees; -- 훨씬 보기 편해진 문자 타입이 된 salary
-- 문자 타입으로 변환했기 때문에 연산은 불가능
-- 서식문자에 L을 사용해주면 원화단위기호(￦)가 작성된다.

-- 문자를 숫자로 TO_NUMBER(값, 형식)
-- 자바에서는 그냥 연결해주는데 과연 어떤 결과가 나올까?
SELECT '2000' + 2000 FROM dual;
-- 결과: 4000
-- 자동 형 변환 (문자 -> 숫자)

SELECT TO_NUMBER('2000') + 2000 FROM dual; -- 명시적 형 변환
-- 결과: 4000

SELECT '$3,300' + 2000 FROM dual; -- 에러
-- 해결: 기호+숫자가 어떤 형식인지 설명해 주면 된다.
SELECT TO_NUMBER('$3,300', '$9,999') + 2000 FROM dual;
-- 결과: 5300

-- 문자를 날짜로 변환하는 함수 TO_DATE(값, 형식)
SELECT TO_DATE('2023-04-13') FROM dual;
-- 원하는 날짜를 입력해서 실제 날짜 타입으로 변환해 줘!
-- 결과: 23/04/13

SELECT sysdate - '2021-03-26' FROM dual; -- error! 날짜타입 - 문자타입: 연산 불가능
-- 문자 -> 날짜 변환 후에, 연산
SELECT sysdate - TO_DATE('2021-03-26') FROM dual;
SELECT TO_DATE('2020/12/25', 'YY-MM-DD') FROM dual; -- 형식을 정해줬다

-- 주어진 문자열을 모두 변환해야 합니다.
SELECT TO_DATE('2021-03-31 12:23:50', 'YY-MM-DD') FROM dual; -- error: 문자 생긴대로의 형태를 다 작성해 줘야함(HH:MI:SS 추가)

-- xxxx년 xx월 xx일 문자열 형식으로 변환해 보세요.
-- 조회 컬럼명은 dateInfo 라고 하겠습니다.
-- ''20050102'를
-- 1. 문자열을 날짜로 바꿔줘야함
-- 2. 문자열로 바꿔주면서 위의 형식을 바꿔줘야한다.
SELECT
    TO_CHAR(
        TO_DATE('20050102', 'YYYYMMDD'),-- Q
        'YYYY"년" MM"월" DD"일"'
    )AS dateInfo
FROM dual;

-- NULL의 형태를 변환하는 함수 NVL(컬럼, 변환할 타겟 값)
SELECT NULL FROM dual; -- 그냥 null이 어떻게 나오는 지 확인용
SELECT NVL(NULL, 0) FROM dual;
-- 결과: 0

SELECT
    first_name,
    NVL(commission_pct, 0) AS comm_pct -- 원래는 0이 아니라 null이 찍혔음.
FROM employees;

-- NULL 변환 함수 NVL2(컬럼, null이 아닐 경우의 값, null일 경우의 값)
-- NULL아닐 때
SELECT
    NVL2('abc', '널아님', '널임') AS comm_pct
FROM dual; -- 결과: 널아님

-- NULL일 때
SELECT
    NVL2(NULL, '널아님', '널임') AS comm_pct
FROM dual; -- 결과: 널임

SELECT
    first_name,
    NVL2(commission_pct, 'true', 'false') AS comm_pct
FROM employees; -- 결과: null인 사람들은 false가 찍히고, 받는 사람들은 true가 찍힘
-- 이렇게 작성하면 좋은 점: 컬럼의 타입을 상관하지 않고 문자로 모든 경우를 관리해 줄 수 있음!

-- 
SELECT
    first_name,
    commission_pct,
    salary,
    NVL2(
        commission_pct,
        salary + (salary * commission_pct), -- (salary * commission_pct)를 NVL2()로 계산하지 않으면, 그냥 null값으로 출력된다.
        salary
    )AS real_salary
FROM employees;

-- DECODE(컬럼 혹은 표현식, 항목1, 결과1, 항목2, 결과2 ... default)
-- switch-case와 비슷한 듯
SELECT
    DECODE('C', 'A', 'A입니다.', 'B', 'B입니다.', 'C', 'C입니다.', '뭔데 그게?')
FROM dual;
-- 결과: C입니다.

SELECT
    job_id,
    salary,
    DECODE(
        job_id, -- 기준
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
문제 1.
현재일자를 기준으로 employees테이블의 입사일자(hire_date)를 참조해서 근속년수가 17년 이상인
사원을 다음과 같은 형태의 결과를 출력하도록 쿼리를 작성해 보세요. 
조건 1) 근속년수가 높은 사원 순서대로 결과가 나오도록 합니다
*/
SELECT
    employee_id AS 사원번호,
    CONCAT(first_name, ' ' || last_name) AS 이름,
    hire_date AS 입사일자,
    TRUNC(TO_CHAR(sysdate - hire_date) / 365, 0) AS 근속년수 -- 0은 생략가능(기본값)
FROM employees
WHERE (sysdate - hire_date) / 365 >= 17
ORDER BY 근속년수 DESC;
-- 왜 WHERE절에서 근속년수를 조건으로 하면 안되냐
/*
SQL 순서때문
FROM절이 가장 먼저 실행되고, 조건을 보는 순서로 가기 때문에
근속년수가 조건이 될 수 없다.(아직 알 수 없기 때문에/SELECT절을 조회를 해야 알 수 있어짐)
실행 순서: FROM -> WHERE -> SELECT -> ORDER BY
*/

/*
문제 2.
EMPLOYEES 테이블의 manager_id컬럼을 확인하여 first_name, manager_id, 직급을 출력합니다.
100이라면 ‘사원’, 
120이라면 ‘주임’
121이라면 ‘대리’
122라면 ‘과장’
나머지는 ‘임원’ 으로 출력합니다.
조건 1) department_id가 50인 사람들을 대상으로만 조회합니다
*/
SELECT
    first_name,
    manager_id,
    DECODE(
        manager_id,
        100, '사원',
        120, '주임',
        121, '대리',
        122, '과장',
        '임원'
    )AS 직급
FROM employees
WHERE department_id = 50;




