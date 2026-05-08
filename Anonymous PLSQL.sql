PL/SQL ANONYMOUS 

1)COUNT NO. OF EMPLOYEES
SQL> SELECT COUNT(*) FROM employee;

  COUNT(*)
----------
         3

SQL> DECLARE
  2    counts NUMBER;
  3  BEGIN
  4    SELECT COUNT(*) INTO counts FROM employee;
  5    DBMS_OUTPUT.PUT_LINE('Total Employees: ' || counts);
  6  END;
  7  /
Total Employees: 3

PL/SQL procedure successfully completed.

SQL> select article_no,current_status from article;

ARTICLE_NO CURRENT_STATUS
---------- ---------------
      4001 in-transit
      4002 Booked
      4003 Booked
      4004 delivered
      4005 Not yet
      4006 booked
      4007 booked
      4008 Booked

8 rows selected.

2)UPDATE
SQL> DECLARE
  2    artno  article.article_no%TYPE;
  3    status article.current_status%TYPE;
  4  BEGIN
  5    artno := &artno;
  6    status := &status;
  7    UPDATE article SET current_status = status WHERE article_no = artno;
  8    DBMS_OUTPUT.PUT_LINE('Article '||artno||' status updated to: '||status);
  9    COMMIT;
 10  END;
 11  /
Enter value for artno: 4002
old   5:   artno := &artno;
new   5:   artno := 4002;
Enter value for status: 'delivered'
old   6:   status := &status;
new   6:   status := 'delivered';
Article 4002 status updated to: delivered

PL/SQL procedure successfully completed.

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

8 rows selected.

3)INSERT
SQL> select office_code,office_code,address_city from postoffice;

OFFICE_CODE OFFICE_CODE ADDRESS_CITY
----------- ----------- ------------------------------
       1001        1001 Sivakasi
       1002        1002 Virudhunagar
       1003        1003 Madurai
       1004        1004 Sivakasi
       1005        1005 Tenkasi

SQL> DECLARE
  2    code postoffice.office_code%TYPE;
  3    name postoffice.office_name%TYPE;
  4  BEGIN
  5    code := &code;
  6    name := &name;
  7    INSERT INTO postoffice(office_code, office_name, office_category,
  8      address_building_no, address_street, address_city,
  9      address_district, pincode, branch)
 10    VALUES(code, name, 'Head Post Office',
 11      '1', 'Main Road', 'Thiruthangal', 'Virudhunagar', 626123, 'SOUTH');
 12    COMMIT;
 13    DBMS_OUTPUT.PUT_LINE('Post Office inserted: ' || name);
 14  END;
 15  /
Enter value for code: 5001
old   5:   code := &code;
new   5:   code := 5001;
Enter value for name: 'THIRUTHANGAL SUB PO'
old   6:   name := &name;
new   6:   name := 'THIRUTHANGAL SUB PO';
Post Office inserted: THIRUTHANGAL SUB PO

PL/SQL procedure successfully completed.

SQL> select office_code,office_code,address_city from postoffice;

OFFICE_CODE OFFICE_CODE ADDRESS_CITY
----------- ----------- ------------------------------
       1001        1001 Sivakasi
       1002        1002 Virudhunagar
       1003        1003 Madurai
       1004        1004 Sivakasi
       1005        1005 Tenkasi
       5001        5001 Thiruthangal

6 rows selected.

4)%ROWTYPE
SQL> select employee_no,employee_category,employee_designation,posting_office_code,status from employee;

EMPLOYEE_NO EMPLOYEE_CATEGORY    EMPLOYEE_DESIGNATION POSTING_OFFICE_CODE
----------- -------------------- -------------------- -------------------
STATUS
--------------------
       3001 Operationl Staff     Postal Assistant                    1001
Active

       3002 Operational Staff    Postal Assistant                    1001
Active

       3003 Operational Staff    Postal Assistant                    1001
Active

SQL> DECLARE
  2    emp employee%ROWTYPE;
  3    empno number;
  4  BEGIN
  5    empno := &empno;
  6    SELECT * INTO emp FROM employee WHERE employee_no = empno;
  7    DBMS_OUTPUT.PUT_LINE('Designation : ' || emp.employee_designation);
  8    DBMS_OUTPUT.PUT_LINE('Category    : ' || emp.employee_category);
  9    DBMS_OUTPUT.PUT_LINE('Office Code : ' || emp.posting_office_code);
 10    DBMS_OUTPUT.PUT_LINE('Status      : ' || emp.status);
 11  END;
 12  /
Enter value for empno: 3001
old   5:   empno := &empno;
new   5:   empno := 3001;
Designation : Postal Assistant
Category    : Operationl Staff
Office Code : 1001
Status      : Active

PL/SQL procedure successfully completed.

5)TYPE,RECORD
SQL> select article_no,article_type,current_status from article;

ARTICLE_NO ARTICLE_TYPE         CURRENT_STATUS
---------- -------------------- ---------------
      4001 Official Letter      in-transit
      4002 Registered Parcel    delivered
      4003 Speed Post           Booked
      4004 Confidential Letter  delivered
      4005 Letter               Not yet
      4006 Letter               booked
      4007 parcel               booked
      4008 Speed Post           Booked

8 rows selected.

SQL> DECLARE
  2    TYPE article_rec IS RECORD (
  3      art_no     article.article_no%TYPE,
  4      art_type   article.article_type%TYPE,
  5      art_status article.current_status%TYPE
  6    );
  7    artno number;
  8    art article_rec;
  9  BEGIN
 10    artno := &artno;
 11    SELECT article_no, article_type, current_status
 12    INTO   art.art_no, art.art_type, art.art_status
 13    FROM   article WHERE article_no = artno;
 14    DBMS_OUTPUT.PUT_LINE('Art No : ' || art.art_no);
 15    DBMS_OUTPUT.PUT_LINE('Type   : ' || art.art_type);
 16    DBMS_OUTPUT.PUT_LINE('Status : ' || art.art_status);
 17  END;
 18  /
Enter value for artno: 4004
old  10:   artno := &artno;
new  10:   artno := 4004;
Art No : 4004
Type   : Confidential Letter
Status : delivered

PL/SQL procedure successfully completed.

6)EXPLICIT CURSOR
SQL> SELECT a.article_no, weight, charges FROM article a join booking_info b on a.article_no = b.article_no fetch first 1 row only;

ARTICLE_NO     WEIGHT    CHARGES
---------- ---------- ----------
      4001         10         55

SQL> DECLARE
  2    CURSOR art_cursor IS
  3      SELECT a.article_no, weight, charges FROM article a join booking_info b on a.article_no = b.article_no;
  4    artno article.article_no%TYPE;
  5    v_weight article.weight%TYPE;
  6    amt  booking_info.charges%TYPE;
  7  BEGIN
  8    OPEN art_cursor;
  9    FETCH art_cursor INTO artno,v_weight, amt;
 10    DBMS_OUTPUT.PUT_LINE(artno||' | '||v_weight||' | '||amt);
 11    CLOSE art_cursor;
 12  END;
 13  /
4001 | 10 | 55

PL/SQL procedure successfully completed.

7)IMPLICIT CURSOR
SQL> DECLARE
  2    artno article.article_no%TYPE;
  3    v_weight article.weight%TYPE;
  4    amt  booking_info.charges%TYPE;
  5  BEGIN
  6    SELECT a.article_no, weight, charges into artno,v_weight,amt FROM article a join booking_info b on a.article_no = b.article_no fetch first 1 row only;
  7    DBMS_OUTPUT.PUT_LINE(artno||' | '||v_weight||' | '||amt);
  8  END;
  9  /
4001 | 10 | 55

PL/SQL procedure successfully completed.

8)CURSOR ATTRIBUTES
SQL> SELECT a.article_no, weight, charges FROM article a join booking_info b on a.article_no = b.article_no;

ARTICLE_NO     WEIGHT    CHARGES
---------- ---------- ----------
      4001         10         55
      4002        150        165
      4003         15        220
      4004         10        330

SQL> DECLARE
  2    artno article.article_no%TYPE;
  3    v_weight article.weight%TYPE;
  4    amt  booking_info.charges%TYPE;
  5    CURSOR art_cursor IS
  6      SELECT a.article_no, weight, charges FROM article a join booking_info b on a.article_no = b.article_no;
  7  BEGIN
  8    OPEN art_cursor;
  9    FETCH art_cursor INTO artno, v_weight, amt;
 10    IF art_cursor%FOUND THEN
 11      DBMS_OUTPUT.PUT_LINE('First row fetched - Article_no: ' || artno || ', Weight: ' || v_weight||', Charge: ' || amt);
 12    ELSE
 13      DBMS_OUTPUT.PUT_LINE('No rows found');
 14    END IF;
 15    FETCH art_cursor INTO artno, v_weight, amt;
 16    IF art_cursor%FOUND THEN
 17      DBMS_OUTPUT.PUT_LINE('Second row fetched - Article_no: ' || artno || ', Weight: ' || v_weight || ', Charge: ' || amt);
 18    ELSE
 19      DBMS_OUTPUT.PUT_LINE('No rows found');
 20    END IF;
 21    DBMS_OUTPUT.PUT_LINE('Number of rows fetched so far: ' || art_cursor%ROWCOUNT);
 22    IF art_cursor%ISOPEN THEN
 23      DBMS_OUTPUT.PUT_LINE('Cursor is still open');
 24    ELSE
 25      DBMS_OUTPUT.PUT_LINE('Cursor is closed');
 26    END IF;
 27    CLOSE art_cursor;
 28  END;
 29  /
First row fetched - Article_no: 4001, Weight: 10, Charge: 55
Second row fetched - Article_no: 4002, Weight: 150, Charge: 165
Number of rows fetched so far: 2
Cursor is still open

PL/SQL procedure successfully completed.

9)IF-ELSE LOGIC
SQL> SELECT urgencycode,urgency_type FROM urgencylevel;

URGENCYCODE URGENCY_TYPE
----------- --------------------
        101 Ordinary
        102 Registered
        103 Speed Post
        104 Confidential

SQL> select article_no,urgency_code from article;

ARTICLE_NO URGENCY_CODE
---------- ------------
      4001          101
      4002          102
      4003          103
      4004          104
      4005          101
      4006
      4007
      4008          103

8 rows selected.

SQL> DECLARE
  2    urgency article.urgency_code%TYPE;
  3    artno    article.article_no%TYPE;
  4    label    VARCHAR2(20);
  5  BEGIN
  6    artno := &artno;
  7    SELECT urgency_code INTO urgency FROM article WHERE article_no = artno;
  8    IF    urgency = 104 THEN label := 'Confidential';
  9    ELSIF urgency = 102 THEN label := 'Registered';
 10    ELSIF urgency = 103 THEN label := 'Speed Post';
 11    ELSE  label := 'Normal';
 12    END IF;
 13    DBMS_OUTPUT.PUT_LINE('Priority Label: ' || label);
 14  END;
 15  /
Enter value for artno: 4001
old   6:   artno := &artno;
new   6:   artno := 4001;
Priority Label: Normal

PL/SQL procedure successfully completed.

Enter value for artno: 4002
old   6:   artno := &artno;
new   6:   artno := 4002;
Priority Label: Registered

PL/SQL procedure successfully completed.

Enter value for artno: 4003
old   6:   artno := &artno;
new   6:   artno := 4003;
Priority Label: Speed Post

PL/SQL procedure successfully completed.

Enter value for artno: 4004
old   6:   artno := &artno;
new   6:   artno := 4004;
Priority Label: Confidential

PL/SQL procedure successfully completed.

10)BASIC LOOP
SQL> DECLARE
  2      num NUMBER;
  3  BEGIN
  4      num := &num;
  5      LOOP
  6          DBMS_OUTPUT.PUT_LINE('Number: ' || num);
  7          num := num - 1;
  8          EXIT WHEN num < 0;
  9      END LOOP;
 10  END;
 11  /
Enter value for num: 5
old   4:     num := &num;
new   4:     num := 5;
Number: 5
Number: 4
Number: 3
Number: 2
Number: 1
Number: 0

PL/SQL procedure successfully completed.

11)FOR LOOP
SQL> DECLARE
  2      n NUMBER;
  3  BEGIN
  4      n := &n;
  5
  6      FOR i IN 1..n LOOP
  7          DBMS_OUTPUT.PUT_LINE('Number: ' || i);
  8      END LOOP;
  9  END;
 10  /
Enter value for n: 5
old   4:     n := &n;
new   4:     n := 5;
Number: 1
Number: 2
Number: 3
Number: 4
Number: 5

PL/SQL procedure successfully completed.

12)FOR LOOP USING BY
SQL> DECLARE
  2      n NUMBER;
  3  BEGIN
  4      n := &n;
  5      FOR i IN 1..n BY 2 LOOP
  6         DBMS_OUTPUT.PUT_LINE('Value of i: ' || i);
  7      END LOOP;
  8  END;
  9  /
Enter value for n: 5
old   4:     n := &n;
new   4:     n := 5;
Value of i: 1
Value of i: 3
Value of i: 5

PL/SQL procedure successfully completed.

13)WHILE LOOP
SQL> DECLARE
  2       num NUMBER;
  3       i number := 0;
  4  BEGIN
  5       num := &num;
  6       WHILE i <= num LOOP
  7           DBMS_OUTPUT.PUT_LINE('Number: ' || i);
  8           i := i + 1;
  9       END LOOP;
 10  END;
 11  /
Enter value for num: 5
old   5:      num := &num;
new   5:      num := 5;
Number: 0
Number: 1
Number: 2
Number: 3
Number: 4
Number: 5

PL/SQL procedure successfully completed.

14)FOR IN EXPLICIT CURSOR
SQL> SELECT assignment_no, employee_no, delivery_status FROM   deliveryassignment ;

ASSIGNMENT_NO EMPLOYEE_NO DELIVERY_STATUS
------------- ----------- ---------------
         8001        3003 Pending
         8002        3003 Pending
         8003        3003 In-Progress

SQL> DECLARE
  2    CURSOR da_cur IS
  3      SELECT assignment_no, employee_no, delivery_status
  4      FROM   deliveryassignment ;
  5  BEGIN
  6    FOR rec IN da_cur LOOP
  7      DBMS_OUTPUT.PUT_LINE('Assign: '||rec.assignment_no||
  8        '  Emp: '||rec.employee_no||'  Status: '||rec.delivery_status);
  9    END LOOP;
 10  END;
 11  /
Assign: 8001  Emp: 3003  Status: Pending
Assign: 8002  Emp: 3003  Status: Pending
Assign: 8003  Emp: 3003  Status: In-Progress

PL/SQL procedure successfully completed.

15)FOR IN IMPLICIT CURSOR
SQL> SELECT bagnumber, orgin_code, destination_code FROM mailbag;

 BAGNUMBER ORGIN_CODE DESTINATION_CODE
---------- ---------- ----------------
      7001       1001             1003
      7002       1003             1001
      7003       1001             1002

SQL> BEGIN
  2    FOR mb IN (SELECT bagnumber, orgin_code, destination_code FROM mailbag) LOOP
  3      DBMS_OUTPUT.PUT_LINE('Bag: '||mb.bagnumber||
  4        '  From: '||mb.orgin_code||'  To: '||mb.destination_code);
  5    END LOOP;
  6  END;
  7  /
Bag: 7001  From: 1001  To: 1003
Bag: 7002  From: 1003  To: 1001
Bag: 7003  From: 1001  To: 1002

PL/SQL procedure successfully completed.

16)CONTINUE,EXIT IN LOOPS
SQL> DECLARE
  2        num NUMBER;
  3  BEGIN
  4       num := &num;
  5       FOR i IN 1..num LOOP
  6           IF i = 5 THEN
  7               CONTINUE;
  8           END IF;
  9           DBMS_OUTPUT.PUT_LINE('Number: ' || i);
 10           IF i = 8 THEN
 11                EXIT;
 12           END IF;
 13       END LOOP;
 14  END;
 15  /
Enter value for num: 10
old   4:      num := &num;
new   4:      num := 10;
Number: 1
Number: 2
Number: 3
Number: 4
Number: 6
Number: 7
Number: 8

PL/SQL procedure successfully completed.

17)NO DATA EXCEPTION
SQL> DECLARE
  2    artno number;
  3    v_status article.current_status%TYPE;
  4  BEGIN
  5    artno := &artno;
  6    SELECT current_status INTO v_status FROM article WHERE article_no = artno;
  7    DBMS_OUTPUT.PUT_LINE('Status: ' || v_status);
  8  EXCEPTION
  9    WHEN NO_DATA_FOUND THEN
 10      DBMS_OUTPUT.PUT_LINE('Error: No article found with this number.');
 11  END;
 12  /
Enter value for artno: 4001
old   5:   artno := &artno;
new   5:   artno := 4001;
Status: in-transit

PL/SQL procedure successfully completed.

Enter value for artno: 9999
old   5:   artno := &artno;
new   5:   artno := 9999;
Error: No article found with this number.

PL/SQL procedure successfully completed.

18)TOO MANY ROWS EXCEPTION
SQL> SELECT employee_no FROM employee WHERE posting_office_code = 1001;

EMPLOYEE_NO
-----------
       3001
       3002
       3003

SQL> DECLARE
  2    code number;
  3    v_empno employee.employee_no%TYPE;
  4  BEGIN
  5    code := &code;
  6    SELECT employee_no INTO v_empno FROM employee WHERE posting_office_code = code;
  7  EXCEPTION
  8    WHEN TOO_MANY_ROWS THEN
  9      DBMS_OUTPUT.PUT_LINE('Error: Multiple employees found at this office.');
 10  END;
 11  /
Enter value for code: 1001
old   5:   code := &code;
new   5:   code := 1001;
Error: Multiple employees found at this office.

PL/SQL procedure successfully completed.

19)ZERO DIVIDE EXCEPTION
SQL> DECLARE
  2    v_total NUMBER;
  3    v_count NUMBER;
  4    v_avg NUMBER;
  5  BEGIN
  6    v_count := &v_count;
  7    select sum(charges) into v_total from booking_info;
  8    v_avg := v_total / v_count;
  9    DBMS_OUTPUT.PUT_LINE('Average: ' || v_avg);
 10  EXCEPTION
 11    WHEN ZERO_DIVIDE THEN
 12      DBMS_OUTPUT.PUT_LINE('Error: Booking count is zero – cannot compute average.');
 13  END;
 14  /
Enter value for v_count: 0
old   6:   v_count := &v_count;
new   6:   v_count := 0;
Error: Booking count is zero - cannot compute average.

PL/SQL procedure successfully completed.

20)VALUE ERROR EXCEPTION
SQL> DECLARE
  2    v_str VARCHAR2(10);
  3    v_pin NUMBER;
  4  BEGIN
  5    v_str := &v_str;
  6    v_pin := TO_NUMBER(v_str);
  7    DBMS_OUTPUT.PUT_LINE('Pincode: ' || v_pin);
  8  EXCEPTION
  9    WHEN VALUE_ERROR THEN
 10      DBMS_OUTPUT.PUT_LINE('Error: Invalid pincode – must be numeric.');
 11  END;
 12  /
Enter value for v_str: 'Gopesh'
old   5:   v_str := &v_str;
new   5:   v_str := 'Gopesh';
Error: Invalid pincode - must be numeric.

PL/SQL procedure successfully completed.

21)OTHER EXCEPTIONS
SQL> DECLARE
  2    artno number;
  3    v_status article.current_status%TYPE;
  4  BEGIN
  5    artno := &artno;
  6    SELECT current_status INTO v_status FROM article WHERE article_no = artno;
  7    DBMS_OUTPUT.PUT_LINE('Status: ' || v_status);
  8  EXCEPTION
  9    WHEN NO_DATA_FOUND THEN
 10      DBMS_OUTPUT.PUT_LINE('Error: No article found with this number.');
 11    WHEN OTHERS THEN
 12      DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
 13  END;
 14  /
Enter value for artno: 9999
old   5:   artno := &artno;
new   5:   artno := 9999;
Error: No article found with this number.

PL/SQL procedure successfully completed.

22)USER DEFINE EXCEPTION
SQL> select transport_no,transport_capacity, acutal_count from transport;

TRANSPORT_NO TRANSPORT_CAPACITY ACUTAL_COUNT
------------ ------------------ ------------
        5001                500            0
        5002               1000            0
        5003                300          350

SQL> DECLARE
  2    artno number;
  3    e_overloaded EXCEPTION;
  4    v_cap transport.transport_capacity%TYPE;
  5    v_act transport.acutal_count%TYPE;
  6  BEGIN
  7    artno := &artno;
  8    SELECT transport_capacity, acutal_count INTO v_cap, v_act
  9    FROM transport WHERE transport_no = artno;
 10    IF v_act > v_cap THEN RAISE e_overloaded; END IF;
 11    DBMS_OUTPUT.PUT_LINE('Transport is within capacity.');
 12  EXCEPTION
 13    WHEN e_overloaded THEN
 14      DBMS_OUTPUT.PUT_LINE('Error: Overloaded! Capacity='||v_cap||' Actual='||v_act);
 15  END;
 16  /
Enter value for artno: 5003
old   7:   artno := &artno;
new   7:   artno := 5003;
Error: Overloaded! Capacity=300 Actual=350

PL/SQL procedure successfully completed.

Enter value for artno: 5001
old   7:   artno := &artno;
new   7:   artno := 5001;
Transport is within capacity.

PL/SQL procedure successfully completed.

23)SELF Ia
SQL> DECLARE
  2     num number;
  3     a number := 0;
  4     b number := 1;
  5     c number := 0;
  6  BEGIN
  7     num := &num;
  8     DBMS_OUTPUT.PUT_LINE(a);
  9     DBMS_OUTPUT.PUT_LINE(b);
 10     for i in 3..num loop
 11             c := a + b;
 12             DBMS_OUTPUT.PUT_LINE(c);
 13             a := b;
 14             b := c;
 15     end loop;
 16  END;
 17  /
Enter value for num: 5
old   7:        num := &num;
new   7:        num := 5;
0
1
1
2
3

PL/SQL procedure successfully completed.

24)SELF Ib
SQL> DECLARE
  2     num number;
  3     counts number := 0;
  4     arm number := 0;
  5     digit number := 0;
  6     temp number := 0;
  7     flag number := 0;
  8  BEGIN
  9     num := &num;
 10     if num > 0 then DBMS_OUTPUT.PUT_LINE('positive');
 11     elsif num = 0 then DBMS_OUTPUT.PUT_LINE('zero');
 12     else DBMS_OUTPUT.PUT_LINE('negative');
 13     end if;
 14     if mod(num,2) = 0 then DBMS_OUTPUT.PUT_LINE('Even');
 15     else DBMS_OUTPUT.PUT_LINE('odd');
 16     end if;
 17     for i in 2..trunc(sqrt(num)) loop
 18             if mod(num,i) = 0 then flag := 1;
 19             end if;
 20     end loop;
 21     if flag = 1 then DBMS_OUTPUT.PUT_LINE('not prime');
 22     else DBMS_OUTPUT.PUT_LINE('prime');
 23     end if;
 24     counts := length(to_char(num));
 25     temp := num;
 26     while temp > 0 loop
 27             digit := mod(temp,10);
 28             arm := arm + power(digit,counts);
 29             temp := trunc(temp/10);
 30     end loop;
 31     if num = arm then DBMS_OUTPUT.PUT_LINE('armstrong');
 32     else DBMS_OUTPUT.PUT_LINE('not armstrong');
 33     end if;
 34  END;
 35  /
Enter value for num: 153
old   9:        num := &num;
new   9:        num := 153;
positive
odd
not prime
armstrong

PL/SQL procedure successfully completed.

Enter value for num: 5
old   9:        num := &num;
new   9:        num := 5;
positive
odd
prime
armstrong

PL/SQL procedure successfully completed.

Enter value for num: 45
old   9:        num := &num;
new   9:        num := 45;
positive
odd
not prime
not armstrong

PL/SQL procedure successfully completed.

Enter value for num: 1634
old   9:        num := &num;
new   9:        num := 1634;
positive
Even
not prime
armstrong

PL/SQL procedure successfully completed.

25)SELF II
SQL> SELECT empno, empname, salary FROM emp WHERE LOWER(empname) LIKE 'a%';

     EMPNO EMPNAME                            SALARY
---------- ------------------------------ ----------
       101 Arun                                55000
       102 Ajay                                25000
       103 Anitha                              48000
       105 Akash                               36000

SQL> DECLARE
  2      CURSOR emp_cur IS
  3          SELECT empno, empname, salary FROM emp WHERE LOWER(empname) LIKE 'a%';
  4      v_empno  emp.empno%TYPE;
  5      v_name   emp.empname%TYPE;
  6      v_sal    emp.salary%TYPE;
  7  BEGIN
  8      OPEN emp_cur;
  9      LOOP
 10          FETCH emp_cur INTO v_empno, v_name, v_sal;
 11
 12          EXIT WHEN emp_cur%NOTFOUND;
 13
 14          DBMS_OUTPUT.PUT_LINE('Emp No: ' || v_empno ||' Name: ' || v_name ||' Salary: ' || v_sal);
 15      END LOOP;
 16      DBMS_OUTPUT.PUT_LINE('Total Rows Fetched = ' || emp_cur%ROWCOUNT);
 17      IF emp_cur%ISOPEN THEN
 18          DBMS_OUTPUT.PUT_LINE('Cursor is open');
 19      ELSE
 20          DBMS_OUTPUT.PUT_LINE('Cursor is closed');
 21      END IF;
 22
 23      CLOSE emp_cur;
 24  END;
 25  /
Emp No: 101 Name: Arun Salary: 55000
Emp No: 102 Name: Ajay Salary: 25000
Emp No: 103 Name: Anitha Salary: 48000
Emp No: 105 Name: Akash Salary: 36000
Total Rows Fetched = 4
Cursor is open

PL/SQL procedure successfully completed.

26)SELF III
SQL > SELECT empno, empname, salary FROM emp e WHERE city = 'Sivakasi' AND salary > (SELECT AVG(salary) FROM emp WHERE deptno = e.deptno);

     EMPNO EMPNAME                            SALARY
---------- ------------------------------ ----------
       101 Arun                                55000
       103 Anitha                              48000

SQL> DECLARE
  2      CURSOR emp_cur IS
  3          SELECT empno, empname, salary FROM emp e WHERE city = 'Sivakasi' AND salary > (SELECT AVG(salary) FROM emp WHERE deptno = e.deptno);
  4      v_empno emp.empno%TYPE;
  5      v_name  emp.empname%TYPE;
  6      v_sal   emp.salary%TYPE;
  7      v_count NUMBER := 0;
  8
  9  BEGIN
 10      OPEN emp_cur;
 11      LOOP
 12          FETCH emp_cur INTO v_empno, v_name, v_sal;
 13          EXIT WHEN emp_cur%NOTFOUND;
 14          v_count := v_count + 1;
 15          DBMS_OUTPUT.PUT_LINE('Employee No: ' || v_empno ||' Name: ' || v_name ||' Salary: ' || v_sal);
 16      END LOOP;
 17      DBMS_OUTPUT.PUT_LINE('Total Employees satisfying condition = ' || v_count);
 18      CLOSE emp_cur;
 19
 20  EXCEPTION
 21      WHEN NO_DATA_FOUND THEN
 22          DBMS_OUTPUT.PUT_LINE('No employee found matching the condition');
 23      WHEN TOO_MANY_ROWS THEN
 24          DBMS_OUTPUT.PUT_LINE('Query returned too many rows');
 25      WHEN OTHERS THEN
 26          DBMS_OUTPUT.PUT_LINE('Unexpected Error: ' || SQLERRM);
 27  END;
 28  /
Employee No: 101 Name: Arun Salary: 55000
Employee No: 103 Name: Anitha Salary: 48000
Total Employees satisfying condition = 2

PL/SQL procedure successfully completed.

