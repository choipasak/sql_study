
-- WHERE��
DECLARE
    v_num NUMBER := 3;
    v_count NUMBER := 1; -- begin
BEGIN
    WHILE v_count <= 10 -- end
    LOOP
        dbms_output.put_line(v_num);
        v_count := v_count + 1; -- step: v_count += 1 �� ����
        v_num := v_num + 1; -- v_num += 1 �� ����
    END LOOP;
        
END;

-- ���� ���� v_num�� �����غ���
DECLARE
    v_num NUMBER := 0;
    v_count NUMBER := 1; -- begin
BEGIN
    WHILE v_count <= 10 -- end
    LOOP
        v_num := v_num + v_count; -- step
        v_count := v_count + 1; -- v_count += 1 �� ����
    END LOOP;
    
    dbms_output.put_line(v_num);
        
END;

-- Ż�⹮
DECLARE
    v_num NUMBER := 0;
    v_count NUMBER := 1; -- begin
BEGIN
    WHILE v_count <= 10 -- end
    LOOP
        EXIT WHEN v_count = 5; -- break; �� �Ȱ���
    
        v_num := v_num + v_count; -- step
        v_count := v_count + 1; -- v_count += 1 �� ����
    END LOOP;
    
    dbms_output.put_line(v_num);
        
END; -- 1 2 3 4 ������ ������ ��

-- FOR��(���for���� �����)
-- �������� ����غ���!
DECLARE
    v_num NUMBER := 4; -- 4������ ����
BEGIN
    
    FOR i IN 1..9 -- i�� ���� ����(.�� �� �� �ۼ��ؼ� ������ ǥ��)
    LOOP
        dbms_output.put_line(v_num || ' x ' || i || ' = ' || v_num*i);
    END LOOP;
    
END;

-- CONTINUE��
DECLARE
    v_num NUMBER := 3; -- 4������ ����
BEGIN
    
    FOR i IN 1..9 -- i�� ���� ����(.�� �� �� �ۼ��ؼ� ������ ǥ��)
    LOOP
        CONTINUE WHEN  i = 5; -- continue��: i�� 5�϶��� �ǳ� �ٰڴٴ� �ǹ�
        dbms_output.put_line(v_num || ' x ' || i || ' = ' || v_num*i);
    END LOOP;
    
END; -- WHILE�������� ������ -> continue�� ������ ���ǽ����� ���ư�(�ڹٿ� �Ȱ���)

-- ���� ����
-- 1. ��� �������� ����ϴ� �͸� ����� ���弼��. (2 ~ 9��)
-- ¦���ܸ� ����� �ּ���. (2, 4, 6, 8)
-- ����� ����Ŭ ������ �߿��� �������� �˾Ƴ��� �����ڰ� �����. (% ����~)
-- ��ver
DECLARE
    v_dan NUMBER := 1;
    v_hang NUMBER := 1;
BEGIN
    v_dan := v_dan + 1;
    IF MOD(v_dan, 2) = 0 THEN
        FOR i IN 1..9 LOOP
            EXIT WHEN v_dan < 10;
            dbms_output.put_line(v_dan || ' x ' || i || ' = ' || v_dan*i);
        END LOOP;
    END IF;
END;

-- ������ver
DECLARE
BEGIN
    FOR dan IN 1..9 LOOP -- DECLARE���� ���� ����X -> FOR������ ������ ���ϴϱ�
        IF MOD(dan, 2) = 0 THEN -- ����Ŭ���� ������(%)������ -> MOD(���� ��, ��)
        dbms_output.put_line(' ������ ' || dan || ' �� ');
            FOR hang IN 1..9 LOOP
                dbms_output.put_line(dan || ' x ' || hang || ' = ' || dan*hang);
            END LOOP;
        END IF;
    END LOOP;
END;



-- 2. INSERT�� 300�� �����ϴ� �͸� ����� ó���ϼ���.
-- board��� �̸��� ���̺��� ���弼��. (bno, writer, title �÷��� �����մϴ�.)
-- bno�� SEQUENCE�� �÷� �ֽð�, writer�� title�� ��ȣ�� �ٿ��� INSERT ������ �ּ���.
-- ex) 1, test1, title1 -> 2 test2 title2 -> 3 test3 title3 ....
CREATE TABLE board (
    bno NUMBER PRIMARY KEY,
    writer VARCHAR2(30),
    title VARCHAR2(30)
);

CREATE SEQUENCE bno_seq
    START WITH 1 -- ���۰� (�ۼ����� ���� ����. �⺻���� ������ �� �ּҰ�, ������ �� �ִ밪)
    INCREMENT BY 1 -- ������ (����� ����, ������ ����, �⺻�� 1)
    MAXVALUE 1000-- �ִ밪 (�⺻��: ������ �� 1027, ������ �� -1)
    NOCACHE -- ĳ�ø޸� ��� ���� (�⺻��: CACHE): ���������� ������ ����ŭ�� �̸� �����ش�. �� 1~40������ ���ͼ� ĳ�ø޸𸮿� ������ ���´� -> ȣ��� ������ ���Դ� ��ȣ�� �ٿ���. �ٵ� ���߰��������� �� ������� ����. ERROR�������� ���� ĳ�ð� �� ����.
    NOCYCLE;

DECLARE
    v_num NUMBER := 1;
BEGIN
    WHILE v_num <= 300
    LOOP
        INSERT INTO board
        VALUES(bno_seq.NEXTVAL, 'test' || v_num, 'title' || v_num); -- �������� ȣ��� ������ ���� �߰��Ǳ� ������ v_num��� bno_seq�� �ۼ��ߴٸ� ���ԵǴ� ����� (1, test2, title3)�� �Ǿ��� ���̴�.
        v_num := v_num + 1;
    END LOOP;
    COMMIT;
END;





-- ��ver
CREATE SEQUENCE bno_seq
    START WITH 1 -- ���۰� (�ۼ����� ���� ����. �⺻���� ������ �� �ּҰ�, ������ �� �ִ밪)
    INCREMENT BY 1 -- ������ (����� ����, ������ ����, �⺻�� 1)
    MAXVALUE 1000-- �ִ밪 (�⺻��: ������ �� 1027, ������ �� -1)
    NOCACHE -- ĳ�ø޸� ��� ���� (�⺻��: CACHE): ���������� ������ ����ŭ�� �̸� �����ش�. �� 1~40������ ���ͼ� ĳ�ø޸𸮿� ������ ���´� -> ȣ��� ������ ���Դ� ��ȣ�� �ٿ���. �ٵ� ���߰��������� �� ������� ����. ERROR�������� ���� ĳ�ð� �� ����.
    NOCYCLE;

DECLARE
BEGIN
    FOR i IN 1..300 LOOP
        CREATE TABLE board
            (bno, writer, title)
        VALUES
            (bno_seq, 'test' || bno_seq, 'title' || bno_seq)
    END LOOP;
END;

SELECT * FROM board
ORDER BY bno DESC;

























