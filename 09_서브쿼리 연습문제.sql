
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

/*
문제 12. 
employees테이블, departments테이블을 left조인
hire_date를 오름차순 기준으로 1-10번째 데이터만 출력합니다.
조건) rownum을 적용하여 번호, 직원아이디, 이름, 전화번호, 입사일, 
부서아이디, 부서이름 을 출력합니다.
조건) hire_date를 기준으로 오름차순 정렬 되어야 합니다. rownum이 틀어지면 안됩니다.
*/
SELECT * FROM(
    SELECT ROWNUM AS rn, tb.* FROM
    (
        SELECT
            e.employee_id, e.first_name, e.phone_number, e.hire_date,
            d.department_id, d.department_name
        FROM employees e LEFT JOIN departments d
        ON e.department_id = d.department_id
        ORDER BY hire_date --> 여기서 e.hire_date라고 해도 되고, 그냥 hire_date라고 해도 된다: hire_date가 employees테이블에만 있기 때문에
    ) tb
)
WHERE rn BETWEEN 1 AND 10;


/*
문제 13. 
--EMPLOYEES 와 DEPARTMENTS 테이블에서
JOB_ID가 SA_MAN 사원의 정보의 LAST_NAME, JOB_ID, 
DEPARTMENT_ID,DEPARTMENT_NAME을 출력하세요.
*/
-- join
SELECT
    e.last_name, e.job_id,
    d.department_id, d.department_name
FROM employees e JOIN departments d
ON e.department_id = d.department_id
WHERE job_id = 'SA_MAN';

-- 서브쿼리
SELECT
    e.last_name, e.job_id,
    (
    SELECT d.department_id FROM departments d
    WHERE d.department_id = e.department_id
    ) AS department_id,
    (
    SELECT d.department_name FROM departments d
    WHERE d.department_id = e.department_id
    ) AS department_name
FROM employees e
WHERE job_id = 'SA_MAN';

-- 선생님 (from절 서브쿼리 - 인라인뷰 사용)
SELECT
    tb.*, d.department_name
FROM
    (
    SELECT
        last_name, job_id, department_id
    FROM employees
    WHERE job_id = 'SA_MAN'
    ) tb
JOIN departments d
ON tb.department_id = d.department_id;
/*
문제 14
-- DEPARTMENT테이블에서 각 부서의 ID, NAME, MANAGER_ID와 부서에 속한 인원수를 출력하세요.
-- 인원수 기준 내림차순 정렬하세요.
-- 사람이 없는 부서는 출력하지 뽑지 않습니다.
*/
-- 나: 스칼라 서브쿼리로 작성
SELECT tb.* FROM
    (
        SELECT
            d.department_id, d.department_name, d.manager_id,
            (
                SELECT
                    COUNT(*)
                FROM employees e
                WHERE e.department_id = d.department_id
                GROUP BY e.department_id
            ) AS 인원수
        FROM departments d
    ) tb
WHERE 인원수 IS NOT NULL
ORDER BY 인원수 DESC; --> 이렇게 쿼리문으로 한번 더 감쌀 필요 그냥 별칭으로 작성해 주면 됬었다!ㄴ

-- 선생님 -> JOIN하는 테이블로 인라인뷰
SELECT
    d.department_id, d.department_name, d.manager_id,
    a.total
FROM departments d
JOIN
    (
    SELECT
        department_id, COUNT(*) AS total
    FROM employees
    GROUP BY department_id
    ) a
ON d.department_id = a.department_id
ORDER BY a.total DESC;
-- '사람이 없는 부서는 출력하지 뽑지 않습니다' 의 조건 -> INNER JOIN으로 해결 가능, 사람이 없으면 조회가 안되니까!

/*
SELECT
    COUNT(*),
    (
    SELECT d.department_id FROM departments d
    WHERE d.department_id = e.department_id
    ) AS department_id,
    (
    SELECT d.department_name FROM departments d
    WHERE d.department_id = e.department_id
    ) AS department_name,
    (
    SELECT d.manager_id FROM departments d
    WHERE d.department_id = e.department_id
    ) AS manager_id
FROM employees e
WHERE e.department_id = d.department_id
GROUP BY e.department_id;
*/




/*
문제 15
--부서에 대한 정보 전부와, 주소, 우편번호, 부서별 평균 연봉을 구해서 출력하세요.
--부서별 평균이 없으면 0으로 출력하세요.
*/
-- 내가 한 버전
SELECT
    d.*,
    l.street_address, l.postal_code,
    NVL(e.급여, 0) AS 부서별평균급여
FROM departments d 
JOIN
    (
        SELECT
            e.department_id, AVG(e.salary) AS 급여
        FROM employees e
        GROUP BY e.department_id
    ) e
ON e.department_id = d.department_id
JOIN locations l ON l.location_id = d.location_id;

-- 선생님
-- 1. 먼저 부서 별 평균 연봉을 구해준다. -> employees테이블에서 조회
SELECT
    department_id,
    TRUNC(AVG(salary), 2) AS result -- result에 소수점 자르기
FROM employees
GROUP BY department_id;

-- 2. 1번을 인라인 뷰로 사용
SELECT
    d.*,
    lc.street_address, lc.postal_code,
    NVL(tb.result, 0) AS 부서별평균급여
FROM departments d
JOIN locations lc
ON d.location_id = lc.location_id
LEFT JOIN -- 부서별 평균이 없으면 출력되지 않는 조건에 맞게 LEFT JOIN을 사용해준다.
    (
    SELECT
        department_id,
        TRUNC(AVG(salary), 2) AS result -- result에 소수점 자르기
    FROM employees
    GROUP BY department_id
    ) tb
ON d.department_id = tb.department_id;

-- 스칼라 사용 버전
SELECT
    d.*,
    lc.street_address, lc.postal_code,
    NVL(
        (
        SELECT TRUNC(AVG(e.salary), 0)
        FROM employees e
        WHERE
        )
        )
FROM locations loc




/*
SELECT
    tb.*
FROM
    (
        SELECT
            AVG(e.salary) AS 부서별평균연봉
        FROM departments d JOIN emplemployees e
        WHERE d.department_id = e.department_id
        GROUP BY e.department_id
        WHERE
    ) tb
    */
    
/*
SELECT
        e.*,
        AVG(salary) AS 부서별평균연봉,
        tb.*
FROM
    employees e,
    (
        SELECT
            l.street_address, l.postal_code
        FROM locations l JOIN departments d
        WHERE l.location_id = d.location_id
    ) tb
GROUP BY e.department_id;
*/


/*
문제 16
-문제 15 결과에 대해 DEPARTMENT_ID기준으로 내림차순 정렬해서 
ROWNUM을 붙여 1-10 데이터 까지만 출력하세요.
*/

SELECT
    *
FROM
    (
        SELECT
        ROWNUM AS rn, tb.*
        FROM
            (
                SELECT
                    d.*,
                    l.street_address, l.postal_code,
                    NVL(e.급여, 0) AS 부서별평균급여
                FROM departments d 
                JOIN
                    (
                        SELECT
                            e.department_id, AVG(e.salary) AS 급여
                        FROM employees e
                        GROUP BY e.department_id
                    ) e
                ON e.department_id = d.department_id
                JOIN locations l ON l.location_id = d.location_id
                ORDER BY e.department_id DESC
            ) tb
    )
WHERE rn BETWEEN 1 AND 10;

-- 선생님 버전
SELECT * FROM
    (
    SELECT ROWNUM AS rn, tbl2.*
        FROM
        (
        SELECT
            d.*,
            loc.street_address, loc.postal_code,
            NVL(tbl.result, 0) AS 부서별평균급여
        FROM departments d
        JOIN locations loc
        ON d.location_id = loc.location_id
        LEFT JOIN
            (
            SELECT
                department_id,
                TRUNC(AVG(salary), 0) AS result
            FROM employees
            GROUP BY department_id
            ) tbl
        ON d.department_id = tbl.department_id
        ORDER BY d.department_id DESC
        ) tbl2
    )
WHERE rn > 0 AND rn <= 10;






















