
-- 그룹 함수 AVG, MAX, MIN, SUM, COUNT
-- 그룹화가 되어 있어야 사용할 수 있는 함수들

SELECT -- Q. 쿼리문
    AVG(salary),
    MAX(salary),
    MIN(salary),
    SUM(salary),
    COUNT(salary)
FROM employees;
-- 그룹화를 따로 하지 않으면 테이블의 전체 데이터가 그룹이 된다.

-- COUNT: 개수를 알고 싶을 때 사용한다.
-- employees에 있는 데이터의 개수가 궁금하다!
SELECT COUNT(*) FROM employees; -- 총 행 데이터의 수
-- 결과: 107

SELECT COUNT(first_name) FROM employees;
-- 결과: 107 -> first_name이 없는 사람은 없구나 를 알 수 있음!

SELECT COUNT(commission_pct) FROM employees; -- null이 아닌 행의 수
-- 결과: 35 -> null은 세지 않는다.
-- 그래서 총 데이터의 개수를 알고 싶다면 그냥 *을 써주는게 좋다!

SELECT COUNT(manager_id) FROM employees;
-- 결과: 106 -> null 제외

-- 그룹화
-- 부서 별로 그룹화, 그룹함수의 사용

-- 그룹별 salary의 평균을 내보자!
SELECT
    department_id,
    AVG(salary)
FROM employees
GROUP BY department_id; -- 그룹을 department_id로 지었다.

-- 주의할 점
-- 그룹 함수는 일반 컬럼과 동시에 그냥 출력할 수 는 없습니다.
SELECT
    department_id,
    AVG(salary)
FROM employees; -- error
-- error: AVG()하나만 있었다면 employees 테이블을 그룹으로 잡아서 출력 가능
-- 하지만 department_id컬럼이 추가되면서 AVG(salary)가 그룹으로 어디를 잡아야 할지 몰라서 에러가 난다.

-- GROUP BY절을 사용할 때 GROUP절에 묶이지 않으면 다른 컬럼을 조회할 수 없습니다.
SELECT
    job_id, -- error
    department_id,
    AVG(salary)
FROM employees
GROUP BY department_id;
-- error: job_id는 그룹화가 되지 않았다.
-- 내가 조회하고자 하는 컬럼이 그룹화가 되지 않으면 ERROR가 난다.

-- 해결: GROUP BY절 2개 이상 사용
SELECT
    job_id, -- error
    department_id,
    AVG(salary)
FROM employees
GROUP BY department_id, job_id
ORDER BY department_id; -- 정렬
-- job_id가 1개 이상이어서 department_id가 중복으로 나온다.
-- 이유: AVG(salary)가 다르기 때문

-- GROUP BY에서의 조건화.
-- GROUP BY를 통해 그룹화 할 때 조건을 걸 경우 HAVING을 사용.
SELECT
    department_id,
    AVG(salary)
FROM employees
GROUP BY department_id
HAVING SUM(salary) > 100000;
-- SUM(salary) > 100000: 부서별 salary 총 합이 100000이 넘는 부서라면

SELECT
    job_id,
    COUNT(*) -- Q. *이
FROM employees
GROUP BY job_id
HAVING COUNT(*) >= 5;
-- job_id(직무)로 그룹화를 할건데 job_id에 해당하는 사람이 5명 이상이어야 조회 할거야

-- 부서 아이디가 50 이상인 것들을 그룹화 시키고, 그룹 월급 평균이 5000 이상만 조회
-- 1. 부서 아이디가 50 이상인 것들을 그룹화 시키고, -> 일반 조건(WHERE)
-- 2. 그룹 월급 평균이 5000 이상만 조회 -> 그룹화 조건(HAVING)
SELECT
    department_id,
    AVG(salary) AS 평균
FROM employees
WHERE department_id >= 50 -- 부서 아이디가 50 이상인 것들을 그룹화 시키고,
GROUP BY job_id, department_id
HAVING AVG(salary) >= 5000 -- 그룹 월급 평균이 5000 이상만 조회
ORDER BY department_id DESC;

/*
문제 1.
1-1. 사원 테이블에서 JOB_ID별 사원 수를 구하세요.
1-2. 사원 테이블에서 JOB_ID별 월급의 평균을 구하세요. 월급의 평균 순으로 내림차순 정렬하세요.
*/
SELECT
    job_id,
    COUNT(*) AS 사원수
FROM employees
GROUP BY job_id;

SELECT
    job_id,
    AVG(salary) AS 부서별평균급여
FROM employees
GROUP BY job_id
ORDER BY 부서별평균급여 DESC;

/*
문제 2.
사원 테이블에서 입사 년도 별 사원 수를 구하세요.
(TO_CHAR() 함수를 사용해서 연도만 변환합니다. 그리고 그것을 그룹화 합니다.)
*/
SELECT
    TO_CHAR(hire_date, 'YYYY') AS 입사년도,
    COUNT(TO_CHAR(hire_date, 'YYYY')) AS 인원
FROM employees
GROUP BY TO_CHAR(hire_date, 'YYYY')
ORDER BY 입사년도;

/*
문제 3.
급여가 5000 이상인 사원들의 부서별 평균 급여를 출력하세요. 
단 부서 평균 급여가 7000이상인 부서만 출력하세요.
*/
SELECT
    department_id,
    TRUNC(AVG(salary), 2) AS 평균급여
FROM employees
WHERE salary >= 5000
GROUP BY department_id
HAVING AVG(salary) >= 7000;


/*
문제 4.
사원 테이블에서 commission_pct(커미션) 컬럼이 null이 아닌 사람들의
department_id(부서별) salary(월급)의 평균, 합계, count를 구합니다.
조건 1) 월급의 평균은 커미션을 적용시킨 월급입니다.
조건 2) 평균은 소수 2째 자리에서 절삭 하세요.
*/
SELECT
    department_id,
    TRUNC(AVG(salary + (salary*commission_pct)), 2) AS 부서별월급평균,
    SUM(salary + (salary*commission_pct)) AS 월급총합계,
    COUNT(*) AS 인원수
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY department_id;







