
-- 숫자함수
-- ROUND(반올림)
-- 원하는 반올림 위치를 매개값으로 지정. 음수를 주는것도 가능
SELECT
    ROUND(3.1415, 3), ROUND(45.923, 0), ROUND(49.984, 0)
FROM dual;

-- TRUNC(절사)
-- 정해진 소수점 자리수까지 잘라냅니다.
SELECT
    TRUNC(3.1415, 3), TRUNC(45.923, 0), TRUNC(49.984, -1)
FROM dual;

-- ABS (절대값)
SELECT ABS(-34) FROM dual;

-- CEIL(실수): 정수부로 올림, FLOOR(실수): 정수부로 내림
SELECT CEIL(3.14), FLOOR(3.14)
FROM dual;

-- MOD(실수, 나눌_값) : 나머지
SELECT 10/4, MOD(10, 4)
FROM dual;

--------------------------------------------------------------

-- 날짜 함수
-- sysdate: 컴퓨터의 현재 날짜 정보를 가져와서 제공하는 함수. 사용 多
-- systimestamp: 현재 날짜와 시간에 나노초까지 제공.
SELECT sysdate FROM dual; 
SELECT systimestamp FROM dual;

-- 날짜도 연산이 가능합니다.
SELECT sysdate + 1 FROM dual; -- 현재 날짜에 +1 을 해서 조회하겠다.

-- 날짜타입과 날짜타입은 뺄셈 연산을 지원합니다.
-- 덧셈은 허용하지 않습니다.
SELECT first_name, sysdate - hire_date
FROM employees; -- 일수

SELECT first_name, hire_date,
(sysdate - hire_date) / 7 AS week
FROM employees; -- 주수

SELECT first_name, hire_date,
(sysdate - hire_date) / 365 AS week
FROM employees; -- 년수

SELECT first_name, hire_date,
(sysdate - hire_date) / 365 AS week -- 날짜와 날짜에 +연산은 불가능
FROM employees; -- 년수

-- 날짜 반올림, 절사
SELECT ROUND(sysdate) FROM dual; -- 정오가 지난 후에 조회하면 내일 날짜로 찍힌다
SELECT ROUND(sysdate, 'year') FROM dual; -- 기준: 연도, 월로 판단
SELECT ROUND(sysdate, 'month') FROM dual; -- 기준: 월, 일로 판단
-- 기준: 일
-- 한 주를 기준으로 반이 넘어갔으면 다음 주의 첫번째 날(서양기준인 일요일)로 찍힌다.
-- 수요일 기준으로 전이면 내려지고, 후면 반올림되서 다음주 일요일이 찍힌다.
SELECT ROUND(sysdate, 'day') FROM dual;

SELECT TRUNC(sysdate) FROM dual; -- TRUNC: 내림
SELECT TRUNC(sysdate, 'year') FROM dual; -- 년 기준으로 절사
SELECT TRUNC(sysdate, 'month') FROM dual; -- 월 기준으로 절사
SELECT TRUNC(sysdate, 'day') FROM dual; -- 일 기준으로 절사






