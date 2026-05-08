TRIGGERS

BEFORE AND AFTER INSERT TRIGGERS

SQL> select article_no,article_type from article;

ARTICLE_NO ARTICLE_TYPE
---------- --------------------
      4001 Official Letter
      4002 Registered Parcel
      4003 Speed Post
      4004 Confidential Letter
      4005 Letter
      4006 Letter
      4007 parcel
      4008 Speed Post

8 rows selected.

SQL> insert into article(article_no,article_type) values(4009,null);

1 row created.

SQL> select article_no,article_type from article;

ARTICLE_NO ARTICLE_TYPE
---------- --------------------
      4001 Official Letter
      4002 Registered Parcel
      4003 Speed Post
      4004 Confidential Letter
      4005 Letter
      4006 Letter
      4007 parcel
      4008 Speed Post
      4009

9 rows selected.

SQL> CREATE OR REPLACE TRIGGER before_insert_article
  2  BEFORE INSERT ON article
  3  FOR EACH ROW
  4  BEGIN
  5    IF :NEW.article_type IS NULL OR :NEW.article_type='' THEN
  6      RAISE_APPLICATION_ERROR(-20001,'Article type cannot be null.');
  7    END IF;
  8  END;
  9  /

Trigger created.

SQL> insert into article(article_no,article_type) values(4010,null);
insert into article(article_no,article_type) values(4010,null)
            *
ERROR at line 1:
ORA-20001: Article type cannot be null.
ORA-06512: at "SYSTEM.BEFORE_INSERT_ARTICLE", line 3
ORA-04088: error during execution of trigger 'SYSTEM.BEFORE_INSERT_ARTICLE'

SQL> CREATE OR REPLACE TRIGGER after_insert_booking
  2  AFTER INSERT ON booking_info
  3  FOR EACH ROW
  4  BEGIN
  5    DBMS_OUTPUT.PUT_LINE('New booking: Receipt '||:NEW.receipt_no||
  6      ' | Article '||:NEW.article_no||' | Rs.'||:NEW.charges);
  7  END;
  8  /

Trigger created.

SQL> insert into booking_info(receipt_no,booking_officecode,booking_empno,article_no,charges) values(6005,5001,3003,4008,420);
New booking: Receipt 6005 | Article 4008 | Rs.420

1 row created.

BEFORE AND AFTER UPDATE TRIGGERS

SQL> CREATE OR REPLACE TRIGGER before_update_charges
  2  BEFORE UPDATE ON booking_info
  3  FOR EACH ROW
  4  BEGIN
  5    IF :NEW.charges < 0 THEN
  6      RAISE_APPLICATION_ERROR(-20002,'Charges cannot be negative.');
  7    END IF;
  8  END;
  9  /

Trigger created.

SQL> update booking_info set charges = -100 where receipt_no = 6005;
update booking_info set charges = -100 where receipt_no = 6005
       *
ERROR at line 1:
ORA-20002: Charges cannot be negative.
ORA-06512: at "SYSTEM.BEFORE_UPDATE_CHARGES", line 3
ORA-04088: error during execution of trigger 'SYSTEM.BEFORE_UPDATE_CHARGES'

SQL> select article_no,current_status from article;

ARTICLE_NO CURRENT_STATUS
---------- ---------------
      4001 in-transit
      4002 delivered
      4003 Booked
      4004 delivered
      4005 Not yet
      4006 booked
      4007 booked
      4008 Booked
      4009

9 rows selected.

SQL> CREATE OR REPLACE TRIGGER after_update_article
  2  AFTER UPDATE OF current_status ON article
  3  FOR EACH ROW
  4  BEGIN
  5    DBMS_OUTPUT.PUT_LINE('Article '||:OLD.article_no||
  6      ' changed ['||:OLD.current_status||'] -> ['||:NEW.current_status||']');
  7  END;
  8  /

Trigger created.

SQL> update article set current_status = 'in-transit' where article_no = 4008;
Article 4008 changed [Booked] -> [in-transit]

1 row updated.

SQL> select article_no,current_status from article;

ARTICLE_NO CURRENT_STATUS
---------- ---------------
      4001 in-transit
      4002 delivered
      4003 Booked
      4004 delivered
      4005 Not yet
      4006 booked
      4007 booked
      4008 in-transit
      4009

9 rows selected.

BEFORE AND AFTER DELETE TRIGGERS

SQL> CREATE OR REPLACE TRIGGER before_delete_employee
  2  BEFORE DELETE ON employee
  3  FOR EACH ROW
  4  BEGIN
  5    IF lower(:OLD.status) = 'active' THEN
  6      RAISE_APPLICATION_ERROR(-20003,
  7        'Cannot delete active employee: '||:OLD.employee_no);
  8    END IF;
  9  END;
 10  /

Trigger created.

SQL> select employee_no,status from employee;

EMPLOYEE_NO STATUS
----------- --------------------
       3001 Active
       3002 Active
       3003 Active
       3004 Unavailable

SQL> delete from employee where employee_no = 3002;
delete from employee where employee_no = 3002
            *
ERROR at line 1:
ORA-20003: Cannot delete active employee: 3002
ORA-06512: at "SYSTEM.BEFORE_DELETE_EMPLOYEE", line 3
ORA-04088: error during execution of trigger 'SYSTEM.BEFORE_DELETE_EMPLOYEE'


SQL> delete from employee where employee_no = 3004;

1 row deleted.

SQL> insert into postoffice(office_code,office_name) values(9999,'MEPCO POST OFFICE');

1 row created.

SQL> select office_code,office_name from postoffice;

OFFICE_CODE OFFICE_NAME
----------- ------------------------------
       1001 Sivakasi Head Post Office
       1002 Virudhunagar Sub Office
       1003 Madurai Central Office
       1004 Sivakasi Branch Office
       1005 Tenkasi Head Post Office
       5001 THIRUTHANGAL SUB PO
       9999 MEPCO POST OFFICE

7 rows selected.

SQL> CREATE OR REPLACE TRIGGER after_delete_postoffice
  2  AFTER DELETE ON postoffice
  3  FOR EACH ROW
  4  BEGIN
  5    DBMS_OUTPUT.PUT_LINE('Deleted: '||:OLD.office_code||' ('||:OLD.office_name||')');
  6  END;
  7  /

Trigger created.

SQL> delete from postoffice where office_code = 9999;
Deleted: 9999 (MEPCO POST OFFICE)

1 row deleted.

COMPOUND TRIGGERS

SQL> select receipt_no,article_no,charges from booking_info;

RECEIPT_NO ARTICLE_NO    CHARGES
---------- ---------- ----------
      6001       4001         55
      6002       4002        165
      6003       4003        220
      6004       4004        330

SQL> select article_no,current_status from article;

ARTICLE_NO CURRENT_STATUS
---------- ---------------
      4001 in-transit
      4002 delivered
      4003 Booked
      4004 delivered
      4005 Not yet
      4006 booked
      4007 booked
      4008 in-transit
      4009

9 rows selected.

SQL> create or replace trigger compound_trigger_booking
  2  for insert or delete on booking_info
  3  compound trigger
  4  before each row
  5  is
  6  begin
  7      if inserting then
  8          update article set current_status = 'booked' where article_no = :new.article_no;
  9      end if;
 10  end before each row;
 11  after each row
 12  is
 13  begin
 14      if deleting then
 15          update article set current_status = 'delivered' where article_no = :old.article_no;
 16      end if;
 17  end after each row;
 18  end compound_trigger_booking;
 19  /

Trigger created.

SQL> insert into booking_info(receipt_no,article_no,charges) values(6005,4009,420);
Article 4009 changed [] -> [booked]
New booking: Receipt 6005 | Article 4009 | Rs.420

1 row created.

SQL> delete from booking_info where receipt_no = 6005;
Article 4009 changed [booked] -> [delivered]

1 row deleted.

STATEMENT TRIGGERS

SQL> select article_no,current_status from article;

ARTICLE_NO CURRENT_STATUS
---------- ---------------
      4001 in-transit
      4002 delivered
      4003 Booked
      4004 delivered
      4005 Not yet
      4006 booked
      4007 booked
      4008 in-transit
      4009 delivered

9 rows selected.

SQL> CREATE OR REPLACE TRIGGER stmt_before_del_art
  2  BEFORE INSERT OR DELETE ON article
  3  DECLARE
  4    v_cnt NUMBER;
  5  BEGIN
  6    SELECT COUNT(*) INTO v_cnt FROM article;
  7    DBMS_OUTPUT.PUT_LINE('Total '||v_cnt||' articles.');
  8  END;
  9  /

Trigger created.

SQL> insert into article(article_no,article_type,current_status) values(4010,'Speed Post','booked');
Total 8 articles.

1 row created.

SQL> delete from article where article_no = 4010;
Total 9 articles.

1 row deleted.

INSERT QUERY WITHIN TRIGGERS

SQL> CREATE OR REPLACE TRIGGER trg_auto_tracking
  2  AFTER INSERT ON deliveryassignment
  3  FOR EACH ROW
  4  BEGIN
  5    INSERT INTO deliverytracking(attempt_sequence_no,assignment_no,attempt_date,attempt_time,attempt_status)
  6    VALUES(:NEW.assignment_no*100+1,:NEW.assignment_no,SYSDATE,TO_CHAR(SYSDATE,'HH24:MI'),'Not delivered');
  7    DBMS_OUTPUT.PUT_LINE('Tracking created for assignment '||:NEW.assignment_no);
  8  END;
  9  /

Trigger created.

SQL> insert into deliveryassignment(assignment_no,employee_no,article_no,delivery_status) values(8005,3001,4009,'in-progress');

1 row created.

SQL> select attempt_sequence_no,assignment_no,attempt_status from deliverytracking;

ATTEMPT_SEQUENCE_NO ASSIGNMENT_NO ATTEMPT_STATUS
------------------- ------------- --------------------
                  1          8001 Unavailable
                  2          8001 Delivered
                  3          8002 Address Incorrect
                  4          8003 Delivered
             800501          8005 Not delivered

UPDATE QUERY WITHIN TRIGGERS

SQL> create or replace trigger trg_article
  2  after delete on article
  3  for each row
  4  begin
  5      update deliveryassignment set delivery_status = 'canceled' where article_no = :old.article_no and delivery_status = 'in-progress';
  6  end;
  7  /

Trigger created.

SQL> insert into deliveryassignment(assignment_no,employee_no,article_no,delivery_status) values(8004,3001,4008,'in-progress');

1 row created.

SQL> select assignment_no,employee_no,article_no,delivery_status from deliveryassignment;

ASSIGNMENT_NO EMPLOYEE_NO ARTICLE_NO DELIVERY_STATUS
------------- ----------- ---------- ---------------
         8001        3003       4001 Pending
         8002        3003       4002 Pending
         8003        3003       4003 In-Progress
         8004        3001       4008 in-progress

SQL> delete from article where article_no = 4008;

1 row deleted.

SQL> select assignment_no,employee_no,article_no,delivery_status from deliveryassignment;

ASSIGNMENT_NO EMPLOYEE_NO ARTICLE_NO DELIVERY_STATUS
------------- ----------- ---------- ---------------
         8001        3003       4001 Pending
         8002        3003       4002 Pending
         8003        3003       4003 In-Progress
         8004        3001       4008 canceled
SELF I A,

SQL> CREATE OR REPLACE TRIGGER last_modified_trg
  2  BEFORE UPDATE ON emp
  3  FOR EACH ROW
  4  BEGIN
  5      :NEW.last_modified := SYSDATE;
  6  END;
  7  /

Trigger created.

SQL> select empno,empname,last_modified from emp;

     EMPNO EMPNAME                        LAST_MODI
---------- ------------------------------ ---------
       101 Arun
       102 Ajay
       103 Anitha
       104 Bala
       105 Akash
       110 Ramesh

6 rows selected.

SQL> update emp set salary = salary + 5000 where empno = 101;

1 row updated.

SQL> update emp set salary = salary + 5000 where empno = 102;

1 row updated.

SQL> select empno,empname,last_modified from emp;

     EMPNO EMPNAME                        LAST_MODI
---------- ------------------------------ ---------
       101 Arun                           22-MAR-26
       102 Ajay                           22-MAR-26
       103 Anitha
       104 Bala
       105 Akash
       110 Ramesh

6 rows selected.

SELF I B,

SQL> CREATE OR REPLACE TRIGGER restrict_update_time
  2  BEFORE UPDATE OF salary ON emp
  3  FOR EACH ROW
  4  BEGIN
  5      IF TO_CHAR(SYSDATE, 'HH24') NOT BETWEEN 9 AND 18 THEN
  6          RAISE_APPLICATION_ERROR(-20001,
  7          'Updates not allowed outside working hours (9 AM - 6 PM)');
  8      END IF;
  9  END;
 10  /

Trigger created.

SQL> select current_timestamp from dual;

CURRENT_TIMESTAMP
---------------------------------------------------------------------------
22-MAR-26 08.54.56.305000 AM +05:30

SQL> update emp set salary = salary + 5000 where empno = 103;
update emp set salary = salary + 5000 where empno = 103
       *
ERROR at line 1:
ORA-20001: Updates not allowed outside working hours (9 AM - 6 PM)
ORA-06512: at "SYSTEM.RESTRICT_UPDATE_TIME", line 3
ORA-04088: error during execution of trigger 'SYSTEM.RESTRICT_UPDATE_TIME'

SQL> select current_timestamp from dual;

CURRENT_TIMESTAMP
---------------------------------------------------------------------------
22-MAR-26 09.05.59.902000 AM +05:30

SQL> update emp set salary = salary + 5000 where empno = 103;

1 row updated.

SELF II A,

SQL> select deptno,deptname from department;

    DEPTNO DEPTNAME
---------- --------------------------------------------------
        10 CSE
        20 ECE
        30 AIDS
        40 EEE

SQL> select empno,deptno from emp;

     EMPNO     DEPTNO
---------- ----------
       101         10
       102         10
       103         20
       104         20
       105         30
       110         20

6 rows selected.

SQL> CREATE OR REPLACE TRIGGER prevent_parent_delete
  2  BEFORE DELETE ON department
  3  FOR EACH ROW
  4  DECLARE
  5      v_count NUMBER;
  6  BEGIN
  7      SELECT COUNT(*) INTO v_count
  8      FROM emp
  9      WHERE deptno = :OLD.deptno;
 10
 11      IF v_count > 0 THEN
 12          RAISE_APPLICATION_ERROR(-20002,
 13          'Cannot delete department: child records exist');
 14      END IF;
 15  END;
 16  /

Trigger created.

SQL> delete department where deptno = 10;
delete department where deptno = 10
       *
ERROR at line 1:
ORA-20002: Cannot delete department: child records exist
ORA-06512: at "SYSTEM.PREVENT_PARENT_DELETE", line 9
ORA-04088: error during execution of trigger 'SYSTEM.PREVENT_PARENT_DELETE'

SQL> delete department where deptno = 40;

1 row deleted.

SELF II B,

SQL> CREATE OR REPLACE TRIGGER no_duplicate_name
  2  BEFORE INSERT OR UPDATE ON emp
  3  FOR EACH ROW
  4  DECLARE
  5      v_count NUMBER;
  6  BEGIN
  7      SELECT COUNT(*) INTO v_count
  8      FROM emp
  9      WHERE empname = :NEW.empname;
 10
 11      IF v_count > 0 THEN
 12          RAISE_APPLICATION_ERROR(-20003,
 13          'Duplicate employee name not allowed');
 14      END IF;
 15  END;
 16  /

Trigger created.

SQL> select empno,empname from emp;

     EMPNO EMPNAME
---------- ------------------------------
       101 Arun
       102 Ajay
       103 Anitha
       104 Bala
       105 Akash
       110 Ramesh

6 rows selected.

SQL> insert into emp(empno,empname) values(106,'Akash');
insert into emp(empno,empname) values(106,'Akash')
            *
ERROR at line 1:
ORA-20003: Duplicate employee name not allowed
ORA-06512: at "SYSTEM.NO_DUPLICATE_NAME", line 9
ORA-04088: error during execution of trigger 'SYSTEM.NO_DUPLICATE_NAME'

SQL> insert into emp(empno,empname) values(106,'Nandish');

1 row created.

SELF III A,

SQL> select item_id,item_name,stock from items;

   ITEM_ID ITEM_NAME                                               STOCK
---------- -------------------------------------------------- ----------
         1 Laptop                                                     10
         2 Mouse                                                      50
         3 Keyboard                                                   20

SQL> CREATE OR REPLACE TRIGGER trg_check_stock
  2  BEFORE INSERT ON orders
  3  FOR EACH ROW
  4  DECLARE
  5      v_stock NUMBER;
  6      v_pending NUMBER;
  7  BEGIN
  8      -- Get available stock
  9      SELECT stock INTO v_stock
 10      FROM items
 11      WHERE item_id = :NEW.item_id;
 12
 13      -- Get pending orders
 14      SELECT NVL(SUM(quantity),0) INTO v_pending
 15      FROM orders
 16      WHERE item_id = :NEW.item_id
 17      AND status = 'PENDING';
 18
 19      IF (:NEW.quantity + v_pending) > v_stock THEN
 20          RAISE_APPLICATION_ERROR(-20004,
 21          'Insufficient stock considering pending orders');
 22      END IF;
 23  END;
 24  /

Trigger created.

SQL> select order_id,item_id,quantity,status from orders;

  ORDER_ID    ITEM_ID   QUANTITY STATUS
---------- ---------- ---------- --------------------
       101          1          3 PENDING
       103          1          2 COMPLETED
       104          2         10 PENDING
       102          1          2 PENDING
       105          1          3 PENDING

SQL> INSERT INTO orders VALUES (106, 1, 6, 'PENDING');
INSERT INTO orders VALUES (106, 1, 6, 'PENDING')
            *
ERROR at line 1:
ORA-20004: Insufficient stock considering pending orders
ORA-06512: at "SYSTEM.TRG_CHECK_STOCK", line 17
ORA-04088: error during execution of trigger 'SYSTEM.TRG_CHECK_STOCK'

QUESTION PAPER 

7A,
SQL> select * from student;

STUDENT_ID STUDENT_NAME              CITY
---------- ------------------------- -------------------------
         1 Ravi                      Chennai
         2 Priya                     Madurai
         3 Kumar                     Trichy
         4 Meena                     Chennai
         5 Arun                      Coimbatore

SQL> select * from course;

 COURSE_ID COURSE_NAME               DEPARTMENT
---------- ------------------------- -------------------------
       101 DBMS                      CSE
       102 OS                        CSE
       103 Networks                  ECE

SQL> select * from enroll;

STUDENT_ID  COURSE_ID      MARKS
---------- ---------- ----------
         1        101         85
         1        102         90
         2        101         78
         3        102         92
         4        101         88
         5        103         76

6 rows selected.

SQL> select * from teaches;

INSTRUCTOR_NAME            COURSE_ID
------------------------- ----------
Dr. Kumar                        101
Dr. Kumar                        102
Dr. Raj                          103

A,
SQL> UPDATE Enroll SET marks = marks * 1.10 WHERE course_id IN (SELECT course_id FROM Teaches WHERE instructor_name = 'Dr. Kumar');

5 rows updated.

SQL> select * from enroll;

STUDENT_ID  COURSE_ID      MARKS
---------- ---------- ----------
         1        101         94
         1        102         99
         2        101         86
         3        102        100
         4        101         97
         5        103         76

6 rows selected.

B,
SQL> select student_name,marks from student natural join enroll where marks < (select max(marks) from enroll) order by marks desc fetch first 1 row only;

STUDENT_NAME                   MARKS
------------------------- ----------
Ravi                              99

C,
SQL> select distinct course_name from course natural join enroll where marks > (select avg(marks) from enroll);

COURSE_NAME
-------------------------
DBMS
OS

D,
SQL> select student_name,city from student natural join enroll where marks = (select max(marks) from enroll);

STUDENT_NAME              CITY
------------------------- -------------------------
Kumar                     Trichy

E,
SQL> create or replace function enroll_max return varchar2 is
  2  cname varchar2(20);
  3  begin
  4  select course_name into cname from course where course_id = (select course_id from enroll group by course_id order by count(*) desc fetch first 1 row only);
  5  return cname;
  6  end;
  7  /

Function created.

SQL> select enroll_max from dual;

ENROLL_MAX
--------------------------------------------------------------------------------
DBMS

7B,
SQL> select * from members;

 MEMBER_ID MEMBER_NAME               DEPT
---------- ------------------------- -------------------------
ADDRESS                                            PHONE
-------------------------------------------------- ---------------
         1 Ravi                      CSE
Chennai                                            9876541230
         2 Priya                     ECE
Madurai                                            9876541231
         3 Kumar                     IT
Trichy                                             9876541232
         4 Meena                     CSE
Chennai                                            9876541233


SQL> select * from books;

   BOOK_ID BOOK_TITLE
---------- --------------------------------------------------
AUTHOR                    CATEGORY                       PRICE
------------------------- ------------------------- ----------
         1 Database Concepts
Navathe                   Database                         450
         2 Data Mining Basics
Han                       Data Mining                      500
         3 Operating Systems
Galvin                    OS                               400
         4 Advanced DBMS
Ramez                     Database                         600


SQL> select * from borrow;

 MEMBER_ID    BOOK_ID ISSUE_DAT RETURN_DA
---------- ---------- --------- ---------
         1          1 10-JAN-24 20-JAN-24
         2          2 01-FEB-24 15-FEB-24
         3          3 05-MAR-24 20-MAR-24
         4          4 01-APR-24 10-APR-24

SQL> select * from staff;

  STAFF_ID STAFF_NAME                BLOCK      BUILDING
---------- ------------------------- ---------- ----------
         1 Anna                      A          Main
         2 Bala                      C          Main
         3 Chitra                    B          Annex
         4 David                     A          Main

SQL> select * from fine;

 MEMBER_ID     AMOUNT STATUS
---------- ---------- ---------------
         1        600 Paid
         2        200 Unpaid
         3          0 Paid

A,
SQL> SELECT staff_name FROM Staff WHERE UPPER(block) IN ('A', 'C');

STAFF_NAME
-------------------------
Anna
Bala
David

E,
SQL>  CREATE INDEX idx_member_name ON members(member_name);

Index created.

D,
SQL> CREATE VIEW MemberBorrowedBooks AS
  2  SELECT m.member_id, m.member_name, b.book_title
  3  FROM Members m
  4  JOIN Borrow br ON m.member_id = br.member_id
  5  JOIN Books  b  ON br.book_id  = b.book_id;

View created.

SQL> select * from memberborrowedbooks;

 MEMBER_ID MEMBER_NAME       BOOK_TITLE
---------- ----------------- --------------------------
         1 Ravi              Database Concepts
         2 Priya             Data Mining Basics
         3 Kumar             Operating Systems
         4 Meena             Advanced DBMS
C,
SQL>  CREATE OR REPLACE PROCEDURE add_book(
  2         id INT,
  3         title VARCHAR2,
  4         author VARCHAR2,
  5          cat VARCHAR2,
  6          price FLOAT
  7      )
  8      IS
  9     BEGIN
 10         INSERT INTO books
 11         VALUES (id, title, author, cat, price);
 12     END;
 13     /

Procedure created.

SQL>  BEGIN
  2         add_book(10,'Python book','Guido','Programming',500);
  3   END;
  4   /

PL/SQL procedure successfully completed.

SQL> select * from books;

   BOOK_ID BOOK_TITLE
---------- --------------------------------------------------
AUTHOR                    CATEGORY                       PRICE
------------------------- ------------------------- ----------
         1 Database Concepts
Navathe                   Database                         450

         2 Data Mining Basics
Han                       Data Mining                      500

         3 Operating Systems
Galvin                    OS                               400

         4 Advanced DBMS
Ramez                     Database                         600

        10 Python book
Guido                     Programming                      500

B,
SQL> select book_title,amount from books natural join borrow natural join fine where UPPER(category) IN ('DATABASE', 'DATA MINING') and amount > 500;

BOOK_TITLE                                             AMOUNT
-------------------------------------------------- ----------
Database Concepts                                         600
