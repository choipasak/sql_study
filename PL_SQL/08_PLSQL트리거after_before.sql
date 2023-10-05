
/*
AFTER 트리거 - INSERT, UPDATE, DELETE 작업 이후에 동작하는 트리거를 의미합니다.
BEFORE 트리거 - INSERT, UPDATE, DELETE 작업 이전에 동작하는 트리거를 의미합니다.

:OLD = 참조 전 열의 값[기본 값] (INSERT: 입력 전 자료, UPDATE: 수정 전 자료, DELETE: 삭제될 값)
:NEW = 참조 후 열의 값 (INSERT: 입력 할 자료, UPDATE: 수정 된 자료)

테이블에 UPDATE나 DELETE를 시도하면 수정, 또는 삭제된 데이터를
별도의 테이블에 보관해 놓는 형식으로 트리거를 많이 사용합니다.
*/

CREATE TABLE tbl_user(
    id VARCHAR2(20) PRIMARY KEY,
    name VARCHAR2(20),
    address VARCHAR2(30)
);

CREATE TABLE tbl_user_backup(
    id VARCHAR2(20) PRIMARY KEY,
    name VARCHAR2(20),
    address VARCHAR2(30),
    update_date DATE DEFAULT sysdate, -- 정보 변경 시간 (기본값: INSERT 되는 시간)
    m_type VARCHAR2(10), -- 변경 타입
    m_user VARCHAR2(20) -- 변경한 사용자
);

-- user가 많으면 관리자가 일일이 관리를 해줄 수 없어짐
-- 알아서 UPDATE, DELETE의 정보의 기록을 알아서 작성되게 해보자! -> TRIGGER를 붙이자!
-- tbl_user에 TRIGGER를 붙여서 감지한 정보 변동을 tbl_user_backup에 저장되게 함

-- AFTER TRIGGER 생성
CREATE OR REPLACE TRIGGER trg_user_backup
    AFTER UPDATE OR DELETE
    ON tbl_user
    FOR EACH ROW
DECLARE
    v_type VARCHAR2(10);
BEGIN
    -- 현재 트리거가 발동된 상황이 UPDATE인지, DELETE인지 파악하는 조건문
    IF UPDATING THEN -- UPDATING: 시스템(오라클) 자체에서 상태에 대한 내용을 지원하는 빌트인 구문
        v_type := '수정';
    ELSIF DELETING THEN
        v_type := '삭제';
    END IF;
    
    -- 본격적인 실행 구문 작성
    -- (backup테이블에 값을 INSERT
    --> 원본 테이블에서 UPDATE or DELETE된 사용자 정보 및 기타 정보)
    INSERT INTO tbl_user_backup 
    VALUES (:OLD.id, :OLD.name, :OLD.address, sysdate, v_type, USER()); --> (OLD.): 기존의 수정되기 전 테이블의 값 / USER(): 현재 로그인 중인 계정의 정보를 가져오는 함수 
    
END;

INSERT INTO tbl_user VALUES('test01', 'kim', '서울');
INSERT INTO tbl_user VALUES('test02', 'lee', '부산');
INSERT INTO tbl_user VALUES('test03', 'park', '경기');

SELECT * FROM tbl_user;
SELECT * FROM tbl_user_backup;

UPDATE tbl_user SET address = '인천' WHERE id = 'test01';
-- 결과: 트리거 작동 + 이미지, 변경이 되기 전의 데이터가 저장된다(왜: :OLD.address)
DELETE tbl_user WHERE id = 'test02';
-- 결과: 트리거 작동 + 이미지, 이것도 변경 전 정보들이 저장되어 있음 (왜: :OLD 때문)
-- 이렇게 삭제를 해도 backup테이블에 정보+삭제의 기록이 남기 때문에 탈퇴철회도 가능(물론 기간 내에)

-- BEFORE TRIGGIER
-- 보안을 위해 사용자 이름을 첫 문자 빼고 *처리 해보자! -> BEFORE
CREATE OR REPLACE TRIGGER trg_user_insert
    BEFORE INSERT -- 사용자가 정보 등록할 때니까!
    ON tbl_user
    FOR EACH ROW
-- DECLARE
BEGIN
    :NEW.name := SUBSTR(:NEW.name, 1, 1) || '***'; -- 이름 입력값에 첫번째 첫문자만 살리고 나머지는 *처리
END;

INSERT INTO tbl_user VALUES('test04', '튀소', '대전');
INSERT INTO tbl_user VALUES('test05', '김오라클', '광주');

SELECT * FROM tbl_user; -- 결과: 이미지로 대체

----------------------------------------------------------------

-- 주문 history를 저장하는 테이블, 상품을 사고팔때마다 변동사항을 저장해 주는 형식의 트리거를 생성해보자!

-- 주문 history(팔리는 것)
CREATE TABLE order_history(
    history_no NUMBER(5) PRIMARY KEY,
    order_no NUMBER(5),
    product_no NUMBER(5),
    total NUMBER(10),
    price NUMBER(10)
);

-- 상품을 저장하는 테이블(상품이 팔릴때마다 깎여야 함)
CREATE TABLE product(
    product_no NUMBER(5) PRIMARY KEY,
    product_name VARCHAR2(20),
    total NUMBER(5),
    price NUMBER(5)
);

CREATE SEQUENCE order_history_seq NOCYCLE NOCACHE;
CREATE SEQUENCE product_seq NOCYCLE NOCACHE;

INSERT INTO product VALUES (product_seq.NEXTVAL, '햄버거', 100, 10000);
INSERT INTO product VALUES (product_seq.NEXTVAL, '피자', 10, 30000);
INSERT INTO product VALUES (product_seq.NEXTVAL, '치킨', 100, 20000);

SELECT * FROM product;

-- 주문 history에 데이터가 들어오면 실행하는 트리거(product테이블의 total이 줄어든다)
CREATE OR REPLACE TRIGGER trg_order_history
    BEFORE INSERT
    ON order_history
    FOR EACH ROW 
DECLARE
    v_total NUMBER;
    v_product_no NUMBER; -- :NEW, :OLD를 계속 쓰면 가독성이 좋지 않기 때문에 담을 변수 선언
BEGIN
    dbms_output.put_line('트리거 실행!');
    
    SELECT
        :NEW.total
    INTO v_total
    FROM dual;

    v_product_no := :NEW.product_no;
    
    UPDATE product SET total = total - v_total
    WHERE product_no = v_product_no;
    
END;

INSERT INTO order_history VALUES(order_history_seq.NEXTVAL, 200, 1, 5 , 50000); -- 200: 주문 번호
INSERT INTO order_history VALUES(order_history_seq.NEXTVAL, 200, 2, 1 , 30000);
INSERT INTO order_history VALUES(order_history_seq.NEXTVAL, 200, 3, 5 , 100000);

SELECT * FROM order_history; -- 결과: 이미지

-- 주문한 만큼 product의 total의 값이 깎였을까?
SELECT * FROM product; -- 결과: 이미지

-- 만약 동시에 주문을 2명이 최대 total값으로 주문을 했을 때,
-- 한명은 product의 total이 0인 상태에서 주문을 하게 된다.
-- 주문이 그대로 들어가게 하지 않기 위해서 IF문 + 예외 를 발생시키겠다.
CREATE OR REPLACE TRIGGER trg_order_history
    BEFORE INSERT
    ON order_history
    FOR EACH ROW
DECLARE
    v_total NUMBER;
    v_product_no NUMBER; -- :NEW, :OLD를 계속 쓰면 가독성이 좋지 않기 때문에 담을 변수 선언
    v_product_total NUMBER;
    -- 예외 생성을 위한 변수
    quatity_shortage_exception EXCEPTION; -- 예외 변수 선언(IF)
    zero_total_exception EXCEPTION; -- ELSIF조건 예외 변수
BEGIN
    dbms_output.put_line('트리거 실행!');
    v_total := :NEW.total;
    v_product_no := :NEW.product_no;
    
    SELECT
        total
    INTO v_product_total
    FROM product
    WHERE product_no = v_product_no;
    
    -- 주문하려는 수량과 현재 재고 수량 비교
    IF v_total > v_product_total THEN -- 재고가 없을 때
        -- 여기에 error일부러 발생시킨다
        RAISE quatity_shortage_exception;
    ELSIF v_product_total <= 0 THEN -- 아예 재고가 없던 경우   
        RAISE zero_total_exception;
    END IF;
            
    
    UPDATE product SET total = total - v_total
    WHERE product_no = v_product_no;

    EXCEPTION
        WHEN quatity_shortage_exception THEN
            -- RAISE_APPLICAION_ERROR() -> 사실상 예외 발생하는 위치
            -- 오라클에서 제공하는 사용자 정의 예외를 발생시키는 함수
            -- 첫번째 매개 값: 에러 코드 (사용자 정의 예외 코드 범위: -20000 ~ -20999까지)
            -- 두번째 매개 값: 에러 메세지
            RAISE_APPLICATION_ERROR(-20001, '주문하신 수량보다 재고가 적어서 주문이 불가합니다');
        WHEN zero_total_exception THEN
            RAISE_APPLICATION_ERROR(-20002, '주문하신 상품의 재고가 없어 주문할 수 없습니다.');
        
END;

-- 트리거 내에서 예외가 발생하면 수행 중인 INSERT 작업은 중단되며 ROLLBACK이 진행됩니다.
INSERT INTO order_history VALUES (order_history_seq.nextval, 201, 2, 4, 150000);

SELECT * FROM order_history; -- 결과: 이미지

SELECT * FROM product; -- 결과: 이미지





