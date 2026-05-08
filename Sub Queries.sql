1.FIND THE ARTICLE WITH HIGHEST BOOKING CHRAGE.

SQL> select max(charges) from booking_info;

MAX(CHARGES)
------------
         330

SQL> select receipt_no,article_no,charges from booking_info where charges = (select max(charges) from booking_info);

RECEIPT_NO ARTICLE_NO    CHARGES
---------- ---------- ----------
      6004       4004        330

2.FIND THE ARTICLES WHOSE WEIGHT MORE THAN AVERAGE WEIGHT OF ARTICLES.

SQL> select avg(weight) from article;

AVG(WEIGHT)
-----------
         38

SQL> select article_no,article_type,weight from article where weight > (select avg(weight) from article);

ARTICLE_NO ARTICLE_TYPE             WEIGHT
---------- -------------------- ----------
      4002 Registered Parcel           150

3.FIND EMPLOYEES WHO ARE WORKING IN THE SAME OFFICE AS EMPLOYEE 3001

SQL> select posting_office_code from employee where employee_no = 3001;

POSTING_OFFICE_CODE
-------------------
               1001

SQL> select employee_no,employee_name,employee_designation from employee where posting_office_code = (select posting_office_code from employee where employee_no = 3001);

EMPLOYEE_NO EMPLOYEE_NAME        EMPLOYEE_DESIGNATION
----------- -------------------- --------------------
       3001 Rajesh Kumar         Postal Assistant
       3002 Rajesh Kumar         Postal Assistant
       3003 Arun Pandian         Postal Assistant

IN
--
4.FIND ARTICLES BOOKED IN OFFICES LOCATED IN SIVAKASI

SQL> select article_no,booking_officecode from booking_info;

ARTICLE_NO BOOKING_OFFICECODE
---------- ------------------
      4001               1001
      4002               1001
      4003               1003
      4004               1002

SQL> select office_code from postoffice where address_city = 'Sivakasi';

OFFICE_CODE
-----------
       1001
       1004

SQL> select article_no from booking_info where booking_officecode in (select office_code from postoffice where address_city = 'Sivakasi');

ARTICLE_NO
----------
      4001
      4002

ANY
---
5.FIND ARTICLES HEAVIER THAN ANY ARTICLES WHICH WEIGHTS MORE THAN 10 g

SQL> select weight from article where weight > 10;

    WEIGHT
----------
       150
        15

SQL> select article_no,weight from article where weight > any(select weight from article where weight > 10);

ARTICLE_NO     WEIGHT
---------- ----------
      4002        150

ALL
---
6.FIND THE ARTICLES LIGHTER THAN ALL ARTICLES WHICH WEIGHTS MORE THAN 10 g

SQL> select article_no,weight from article where weight < all(select weight from article where weight > 10);

ARTICLE_NO     WEIGHT
---------- ----------
      4004         10
      4001         10
      4005          5

MULTI COLUMN SUBQUERY
---------------------
7.FIND EMPLOYEES WORKING IN SAME OFFICE AND DESIGNATION AS EMPLOYEE 3001

SQL> select posting_office_code,employee_designation from employee;

POSTING_OFFICE_CODE EMPLOYEE_DESIGNATION
------------------- --------------------
               1001 Postal Assistant
               1001 Postal Assistant
               1001 Postal Assistant
               1002 Postman

SQL> select posting_office_code,employee_designation from employee where employee_no = 3001;

POSTING_OFFICE_CODE EMPLOYEE_DESIGNATION
------------------- --------------------
               1001 Postal Assistant

SQL> select employee_no,employee_designation from employee where (posting_office_code,employee_designation) in (select posting_office_code,employee_designation from employee where employee_no = 3001);

EMPLOYEE_NO EMPLOYEE_DESIGNATION
----------- --------------------
       3001 Postal Assistant
       3002 Postal Assistant
       3003 Postal Assistant

CORELATED SUB-QUERY
-------------------
8.FIND ARTICLES WHOSE WEIGHT IS GREATER THAN AVERAGE WEIGHT OF SAME URGENCY

SQL> select a1.article_no,a1.weight from article a1 where a1.weight > (select avg(weight) from article a2 where a2.urgency_code = a1.urgency_code);

ARTICLE_NO     WEIGHT
---------- ----------
      4001         10

9.FIND ARTICLES WHOSE BOOKING CHARGE IS MORE THAN AVERAGE CHARGE AT THEIR BOOKING CHARGE

SQL> select b1.receipt_no,b1.article_no,b1.booking_officecode,b1.charges from booking_info b1 where b1.charges > (select avg(b2.charges) from booking_info b2 where b2.booking_officecode = b1.booking_officecode);

RECEIPT_NO ARTICLE_NO BOOKING_OFFICECODE    CHARGES
---------- ---------- ------------------ ----------
      6002       4002               1001        165

SUBQUERY IN FROM CLAUSE
-----------------------
10.COUNT TOTAL ARTICLES PER URGENCY LEVEL

SQL> select urgency_code from article;

URGENCY_CODE
------------
         101
         102
         103
         104
         101

SQL> select urgency_code,count(*) as total_articles from (select urgency_code from article) u group by urgency_code;

URGENCY_CODE TOTAL_ARTICLES
------------ --------------
         101              2
         102              1
         103              1
         104              1

11.COUNT TOTAL BOOKINGS PER OFFICE

SQL> select booking_officecode from booking_info;

BOOKING_OFFICECODE
------------------
              1001
              1001
              1003
              1002

SQL> select booking_officecode,count(*) as total_bookings from (select booking_officecode from booking_info) b group by booking_officecode;

BOOKING_OFFICECODE TOTAL_BOOKINGS
------------------ --------------
              1001              2
              1003              1
              1002              1

SUBQUERY IN SELECT CLAUSE
-------------------------
12.DISPLAY ARTICLE AND THEIR AVERAGE CHARGE OF ITS BOOKING OFFICE

SQL> select b1.article_no,b1.booking_officecode,b1.charges,(select avg(b2.charges) from booking_info b2 where b2.booking_officecode = b1.booking_officecode) as avg_office_charge from booking_info b1;

ARTICLE_NO BOOKING_OFFICECODE    CHARGES AVG_OFFICE_CHARGE
---------- ------------------ ---------- -----------------
      4001               1001         55               110
      4002               1001        165               110
      4003               1003        220               220
      4004               1002        330               330

SUBQUERY IN HAVING CLAUSE
-------------------------
13.FIND OFFICES WHERE AVERAGE BOOKING CHARGE IS ABOVE OVERALL AVERAGE

SQL> select booking_officecode,avg(charges) from booking_info group by booking_officecode having avg(charges) > (select avg(charges) from booking_info);

BOOKING_OFFICECODE AVG(CHARGES)
------------------ ------------
              1003          220
              1002          330

SUBQUERY WITH EXISTS
--------------------
14.FIND EMPLOYEES WHO HAVE DELIVERY ASSIGNMENTS

SQL> select employee_no,employee_name from employee e where exists(select 1 from deliveryassignment d where d.employee_no = e.employee_no);

EMPLOYEE_NO EMPLOYEE_NAME
----------- --------------------
       3003 Arun Pandian

15.FIND POSTOFFICE THAT HAVE ATLEAST ONE ACTIVE EMPLOYEE

SQL> select office_code,office_name,address_city from postoffice where exists(select 1 from employee where posting_office_code = office_code and status = 'Active');

OFFICE_CODE OFFICE_NAME                    ADDRESS_CITY
----------- ------------------------------ ------------------------------
       1001 Sivakasi Head Post Office      Sivakasi
       1002 Virudhunagar Sub Office        Virudhunagar

SUBQUERY WITH 'NOT EXISTS'
--------------------------
16.FIND THE ARTICLE THAT HAVE NOT BEEN ASSIGNED FOR DELIVERY

SQL> select article_no,article_type,current_status from article a where not exists(select 1 from deliveryassignment d where d.article_no = a.article_no);

ARTICLE_NO ARTICLE_TYPE         CURRENT_STATUS
---------- -------------------- ---------------
      4004 Confidential Letter  Booked
      4005 Letter               Not yet

WITH CLAUSE
-----------
17.FIND THE AVERAGE OF CHARGES AND THEN FIND ARTICLES WHOSE BOOKING CHARGES IS ABOVE THE OVERALL AVERAGE

SQL> with Avg_charge as (select avg(charges) as avg_charge from booking_info) select receipt_no,article_no,charges from booking_info where charges > (select avg_charge from Avg_charge);

RECEIPT_NO ARTICLE_NO    CHARGES
---------- ---------- ----------
      6003       4003        220
      6004       4004        330

MULTIPLE WITH CLAUSE
--------------------
18.FIND OFFICES HAVING ATLEAST ONE BOOKINGS AND ABOVE AVERAGE CHARGE

SQL> with Avg_charge as (select avg(charges) as avg_charge from booking_info),Officecount as (select booking_officecode,count(*) as total_bookings from booking_info group by booking_officecode) select o.booking_officecode,o.total_bookings from Officecount o join booking_info b on o.booking_officecode = b.booking_officecode where o.total_bookings >= 1 and b.charges > (select avg_charge from Avg_charge);

BOOKING_OFFICECODE TOTAL_BOOKINGS
------------------ --------------
              1003              1
              1002              1

SCALAR SUBQUERY IN SELECT
-------------------------
19.DISPLAY EACH ARTICLE NUMBER AND THEN URGENCY TYPE OF THAT ARTICLE

SQL> select a.article_no,(select u.urgency_type from urgencylevel u where u.urgencycode = a.urgency_code) as urgencytype from article a;

ARTICLE_NO URGENCYTYPE
---------- --------------------
      4001 Ordinary
      4002 Registered
      4003 Speed Post
      4004 Confidential
      4005 Regular

SCALAR SUBQUERY IN WHERE
------------------------
20.FIND ARTICLE WHOSE WEIGHT IS GREATER THAN THE AVERAGE WEIGHT OF ALL ARTICLE

SQL> select article_no,weight from article where weight > (select avg(weight) from article);

ARTICLE_NO     WEIGHT
---------- ----------
      4002        150
