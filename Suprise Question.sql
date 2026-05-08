SUPRISE QUESTIONS...

--LIMIT - ORACLE DOESNOT HAVE LIMIT INSTEAD FETCH FIRST N ROWS ONLY

SQL> SELECT receipt_no, charges
  2  FROM booking_info
  3  ORDER BY charges DESC
  4  FETCH FIRST 5 ROWS ONLY;

RECEIPT_NO    CHARGES
---------- ----------
      6004        330
      6003        220
      6002        165
      6001         55

--ROW_NUMBER() - assign a sequential number to each row returned by a query

SQL> select row_number() over(order by transport_no) as rownumber,bagnumber,transport_no,orgin_code from mailbag;

 ROWNUMBER  BAGNUMBER TRANSPORT_NO ORGIN_CODE
---------- ---------- ------------ ----------
         1       7001         5001       1001
         2       7002         5002       1003
         3       7003         5003       1001

SQL> SELECT *
  2  FROM article
  3  WHERE ROWNUM <= 3;

ARTICLE_NO  SENDER_NO RECEIVER_NO ARTICLE_TYPE         CURRENT_STATUS
---------- ---------- ----------- -------------------- ---------------
OFFICE_CODE URGENCY_CODE SIZE_CATEGORY            WEIGHT
----------- ------------ -------------------- ----------
      4001       2001        2002 Official Letter      in-transit
       1001          101 Small                        10

      4002       2001        2003 Registered Parcel    Booked
       1001          102 Medium                      150

      4003       2002        2001 Speed Post           Booked
       1003          103 Small                        15

--CASE WHEN - to implement IF-THEN-ELSE logic

--SELECT USING CASE WHEN:

SQL> SELECT article_no,
  2         weight,
  3         CASE
  4             WHEN weight > 149 THEN 'HEAVY'
  5             WHEN weight BETWEEN 99 AND 150 THEN 'MEDIUM'
  6             ELSE 'LIGHT'
  7         END AS weight_category
  8  FROM article;

ARTICLE_NO     WEIGHT WEIGHT
---------- ---------- ------
      4001         10 LIGHT
      4002        150 HEAVY
      4003         15 LIGHT
      4004         10 LIGHT
      4005          5 LIGHT
      4006        100 MEDIUM
      4007        100 MEDIUM

--INSERT USING CASE WHEN

SQL> select * from urgencylevel;

URGENCYCODE URGENCY_TYPE           PRIORITY CAUTION
----------- -------------------- ---------- --------------------
DELIVERYTIMEFRAME    HANDLINGINSTRUCTION
-------------------- ------------------------------
        101 Ordinary                      1 Low
7-10 days            Normal handling sufficient

        102 Registered                    2 Medium
5-7 days             Track carefully

        103 Speed Post                    3 High
1-2 days             Expedite delivery

        104 Confidential                  4 Very High
2-3 days             Seal must not be broken


SQL> select * from article;

ARTICLE_NO  SENDER_NO RECEIVER_NO ARTICLE_TYPE         CURRENT_STATUS
---------- ---------- ----------- -------------------- ---------------
OFFICE_CODE URGENCY_CODE SIZE_CATEGORY            WEIGHT
----------- ------------ -------------------- ----------
      4001       2001        2002 Official Letter      in-transit
       1001          101 Small                        10

      4002       2001        2003 Registered Parcel    Booked
       1001          102 large                       150

      4003       2002        2001 Speed Post           Booked
       1003          103 Small                        15

      4004       2003        2002 Confidential Letter  delivered
       1002          104 Small                        10

      4005       2003        2002 Letter               Not yet
       1002          101 Small                         5

      4006                        Letter               booked
                         Medium                      100

      4007                        parcel               booked
       1003              Medium                      100

SQL> INSERT INTO article(article_no, sender_no, receiver_no, article_type,
  2         current_status, office_code, size_category, weight, urgency_code)
  3  SELECT 4008,2002,2006,'Speed Post','Booked',1003,'Small',50,
  4         CASE 'Speed Post'
  5              WHEN 'Speed Post' THEN 103
  6              WHEN 'Registered' THEN 102
  7              WHEN 'Confidential' THEN 104
  8              ELSE 101
  9         END
 10  FROM dual;

1 row created.

SQL> select * from article;

ARTICLE_NO  SENDER_NO RECEIVER_NO ARTICLE_TYPE         CURRENT_STATUS
---------- ---------- ----------- -------------------- ---------------
OFFICE_CODE URGENCY_CODE SIZE_CATEGORY            WEIGHT
----------- ------------ -------------------- ----------
      4001       2001        2002 Official Letter      in-transit
       1001          101 Small                        10

      4002       2001        2003 Registered Parcel    Booked
       1001          102 large                       150

      4003       2002        2001 Speed Post           Booked
       1003          103 Small                        15

      4004       2003        2002 Confidential Letter  delivered
       1002          104 Small                        10

      4005       2003        2002 Letter               Not yet
       1002          101 Small                         5

      4006                        Letter               booked
                         Medium                      100

      4007                        parcel               booked
       1003              Medium                      100

      4008       2002        2006 Speed Post           Booked
       1003          103 Small                        50

--UPDATE USING CASE WHEN

SQL> select * from article;

ARTICLE_NO  SENDER_NO RECEIVER_NO ARTICLE_TYPE         CURRENT_STATUS
---------- ---------- ----------- -------------------- ---------------
OFFICE_CODE URGENCY_CODE SIZE_CATEGORY            WEIGHT
----------- ------------ -------------------- ----------
      4001       2001        2002 Official Letter      in-transit
       1001          101 Small                        10

      4002       2001        2003 Registered Parcel    Booked
       1001          102 Medium                      150

      4003       2002        2001 Speed Post           Booked
       1003          103 Small                        15

      4004       2003        2002 Confidential Letter  delivered
       1002          104 Small                        10

      4005       2003        2002 Letter               Not yet
       1002          101 Small                         5

      4006                        Letter               booked
                                                     100
      4007                        parcel               booked
       1003                                          100


7 rows selected.

SQL> update article set size_category = case
  2  when weight > 100 then 'large'
  3  when weight > 50 and weight <= 100 then 'Medium'
  4  else 'Small'
  5  end;

7 rows updated.

SQL> select * from article;

ARTICLE_NO  SENDER_NO RECEIVER_NO ARTICLE_TYPE         CURRENT_STATUS
---------- ---------- ----------- -------------------- ---------------
OFFICE_CODE URGENCY_CODE SIZE_CATEGORY            WEIGHT
----------- ------------ -------------------- ----------
      4001       2001        2002 Official Letter      in-transit
       1001          101 Small                        10

      4002       2001        2003 Registered Parcel    Booked
       1001          102 large                       150

      4003       2002        2001 Speed Post           Booked
       1003          103 Small                        15

      4004       2003        2002 Confidential Letter  delivered
       1002          104 Small                        10

      4005       2003        2002 Letter               Not yet
       1002          101 Small                         5

      4006                        Letter               booked
                         Medium                      100
      4007                        parcel               booked
       1003              Medium                      100


7 rows selected.

--DELETE USING CASE WHEN

SQL> select * from employee;

EMPLOYEE_NO EMPLOYEE_TYPE        EMPLOYEE_CATEGORY    EMPLOYEE_DESIGNATION
----------- -------------------- -------------------- --------------------
SHIFT_DETAILS        POSTING_OFFICE_CODE DATE_OF_J EXPERIENCE SUPERVISORID
-------------------- ------------------- --------- ---------- ------------
STATUS               EMPLOYEE_NAME
-------------------- --------------------
       3001 Permanent            Operationl Staff     Postal Assistant
Morning                             1001 01-JAN-15         11
Active               Rajesh Kumar

       3002 Permanent            Operational Staff    Postal Assistant
Morning                             1001 23-DEC-17          8         3001
Active               Rajesh Kumar

       3003 Permanent            Operational Staff    Postal Assistant
Evening                             1001 15-MAR-18          7         3001
Active               Arun Pandian

       3004 Temporary            Field Staff          Postman
Evening                             1002 20-JUN-20          5         3001
Active               Guruprasad


SQL> delete from employee where
  2  case
  3  when employee_type = 'Temporary' then 1
  4  else 0
  5  end =1;

1 row deleted.

SQL> select * from employee;

EMPLOYEE_NO EMPLOYEE_TYPE        EMPLOYEE_CATEGORY    EMPLOYEE_DESIGNATION
----------- -------------------- -------------------- --------------------
SHIFT_DETAILS        POSTING_OFFICE_CODE DATE_OF_J EXPERIENCE SUPERVISORID
-------------------- ------------------- --------- ---------- ------------
STATUS               EMPLOYEE_NAME
-------------------- --------------------
       3001 Permanent            Operationl Staff     Postal Assistant
Morning                             1001 01-JAN-15         11
Active               Rajesh Kumar

       3002 Permanent            Operational Staff    Postal Assistant
Morning                             1001 23-DEC-17          8         3001
Active               Rajesh Kumar

       3003 Permanent            Operational Staff    Postal Assistant
Evening                             1001 15-MAR-18          7         3001
Active               Arun Pandian
