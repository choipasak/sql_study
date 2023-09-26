
/*
문제 1.
-EMPLOYEES 테이블에서 모든 사원들의 평균급여보다 높은 사원들의 데이터를 출력 하세요 
(AVG(컬럼) 사용)
-EMPLOYEES 테이블에서 모든 사원들의 평균급여보다 높은 사원들의 수를 출력하세요
-EMPLOYEES 테이블에서 job_id가 IT_PROG인 사원들의 평균급여보다 높은 사원들의 
데이터를 출력하세요
WHERE절 섭쿼
*/
-- 1번
SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees); -- 그룹화를 하지 않으면 테이블이 그룹이 된다.

-- 2번
SELECT COUNT(*) FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- 3번
SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees
                WHERE job_id = 'IT_PROG');

/*
문제 2.
-DEPARTMENTS테이블에서 manager_id가 100인 부서에 속해있는 사람들의
모든 정보를 출력하세요.
*/
SELECT * FROM employees
WHERE department_id = (SELECT department_id FROM departments 
                       WHERE manager_id = 100);
-- 부서에 속해있는 사람들 -> employees
-- employees와 departments를 department_id가 같다고 연결

/*
문제 3.
-EMPLOYEES테이블에서 “Pat”의 manager_id보다 높은 manager_id를 갖는 모든 사원의 데이터를 
출력하세요
-EMPLOYEES테이블에서 “James”(2명)들의 manager_id를 갖는 모든 사원의 데이터를 출력하세요.
*/
-- 1번
SELECT * FROM employees
WHERE manager_id > (SELECT manager_id FROM employees
                    WHERE first_name = 'Pat');
                    
-- 2번                    
SELECT * FROM employees
WHERE manager_id IN (SELECT manager_id FROM employees
                        WHERE first_name = 'James');
-- ANY는 부호가 필요!
                    
                    
/*
문제 4.
-EMPLOYEES테이블 에서 first_name기준으로 내림차순 정렬하고, 41~50번째 데이터의 
행 번호, 이름을 출력하세요
*/
SELECT * FROM
    (
    SELECT ROWNUM AS rn, tb.first_name
        FROM
        (
            SELECT *
            FROM employees 
            ORDER BY first_name DESC -- 1번 실행
        ) tb
    )
WHERE rn > 40 AND rn <= 50;

/*
문제 5.
-EMPLOYEES테이블에서 hire_date기준으로 오름차순 정렬하고, 31~40번째 데이터의 
행 번호, 사원id, 이름, 번호, 입사일을 출력하세요.
*/
SELECT * FROM
    (
    SELECT ROWNUM AS rn, tb.*
        FROM
        (
            SELECT
                employee_id, first_name, phone_number, hire_date
            FROM employees 
            ORDER BY hire_date ASC -- 1번 실행
        ) tb
    )
WHERE rn > 30 AND rn <= 40;

/*
문제 6.
employees테이블 departments테이블을 left 조인하세요
조건) 직원아이디, 이름(성, 이름), 부서아이디, 부서명 만 출력합니다.
조건) 직원아이디 기준 오름차순 정렬
*/
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ' || e.last_name) AS name,
    e.department_id,
    d.department_name
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id
ORDER BY employee_id ASC;

/*
문제 7.
문제 6의 결과를 (스칼라 쿼리)로 동일하게 조회하세요
*/
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ' || e.last_name) AS name,
    e.department_id,
    (
    SELECT department_name FROM departments d
    WHERE d.department_id = e.department_id -- 여기서는 기준이 departments가 되기 때문에 먼저 쓰는것도 d.department_id이다.
    ) AS department_name -- 이 서브쿼리문이 하나의 컬럼이 되면서 돌때마다 하나의 단일 행을 계속 조회해준다.ㄴ
FROM employees e
ORDER BY e.employee_id ASC;
-- 여기서 서브쿼리와 메인쿼리의 테이블을 바꾸면 employees는 department_id가 중복되는 값이 여러개이기 때문에
-- 서브쿼리는 단일 행 리턴이기 때문에 출력 테이블이 employees가 된다면 리턴값이 여러 행을 리턴하게 된다 -> ERROR
--> 더이상 스칼라 쿼리가 아니게 된다!
/*
문제 8.
departments테이블 locations테이블을 left 조인하세요
조건) 부서아이디, 부서이름, 매니저아이디, 로케이션아이디, 스트릿_어드레스, 포스트 코드, 시티 만 출력합니다
조건) 부서아이디 기준 오름차순 정렬
*/
SELECT
    d.department_id, d.department_name, d.manager_id, d.location_id,
    lc.street_address, lc.postal_code, lc.city
FROM departments d
LEFT JOIN locations lc
ON d.location_id = lc.location_id -- 연결 조건
ORDER BY department_id ASC;

/*
문제 9.
문제 8의 결과를 (스칼라 쿼리)로 동일하게 조회하세요
*/
SELECT
    department_id, department_name, d.manager_id, d.location_id,
    (
    SELECT street_address FROM locations lc
    WHERE lc.location_id = d.location_id
    ) AS street_address,
    (
    SELECT postal_code FROM locations lc
    WHERE lc.location_id = d.location_id
    ) AS postal_code,
    (
    SELECT city FROM locations lc
    WHERE lc.location_id = d.location_id
    ) AS city
FROM departments d
ORDER BY department_id ASC; -- 이런 경우에는 확실히 JOIN문법을 사용하는 것이 좋다!
/*
문제 10.
locations테이블 countries 테이블을 left 조인하세요
조건) 로케이션아이디, 주소, 시티, country_id, country_name 만 출력합니다
조건) country_name기준 오름차순 정렬
*/
SELECT
    lc.location_id,
    lc.street_address,
    lc.city,
    c.country_id,
    c.country_name
FROM locations lc LEFT JOIN countries c
ON lc.country_id = c.country_id
ORDER BY country_name ASC;
/*
문제 11.
문제 10의 결과를 (스칼라 쿼리)로 동일하게 조회하세요
*/
SELECT
    lc.location_id, lc.street_address, lc.country_id,
    (
    SELECT c.country_name FROM countries c
    WHERE c.country_id = lc.country_id
    ) AS country_name
FROM locations lc
ORDER BY country_name ASC; -- country_name를 위에서 별칭으로 따로 지정해줘야 ORDER BY절에서도 사용이 가능해진다!


