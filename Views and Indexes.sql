SIMPLE VIEW
-----------
1.CREATE A SIMPLE VIEW THAT SHOWS ARTICLE NUMBER ,TYPE AND CURRENT STATUS

SQL> create view article_status_view as select article_no,article_type,current_status from article;

View created.

SQL> select * from article_status_view;

ARTICLE_NO ARTICLE_TYPE         CURRENT_STATUS
---------- -------------------- ---------------
      4001 Official Letter      Booked
      4002 Registered Parcel    Booked
      4003 Speed Post           Booked
      4004 Confidential Letter  Booked
      4005 Letter               Not yet

2.CREATE A SIMPLE VIEW THAT SHOWS POSTOFFICE NAME ,CITY AND PINCODE

SQL> create view postoffice_info_view as select office_code,office_name,address_city,pincode from postoffice;

View created.

SQL> select * from postoffice_info_view;

OFFICE_CODE OFFICE_NAME                    ADDRESS_CITY
----------- ------------------------------ ------------------------------
   PINCODE
----------
       1001 Sivakasi Head Post Office      Sivakasi
    626123

       1002 Virudhunagar Sub Office        Virudhunagar
    626001

       1003 Madurai Central Office         Madurai
    625001

       1004 Sivakasi Branch Office         Sivakasi
    626124

       1005 Tenkasi Head Post Office       Tenkasi
    627811

VIEWS WITH JOINS
----------------
3.CREATE A VIEW THAT SHOWS ONLY ARTICLES THAT AS CURRENTLY 'IN-TRANSIT'

SQL> create view intransit_articles as select article_no,article_type,current_status,office_code from article where current_status = 'in-transit';

View created.

SQL> select * from intransit_articles;

no rows selected

SQL> update article set current_status = 'in-transit' where article_no = 4001;

1 row updated.

SQL> update article set current_status = 'in-transit' where article_no = 4004;

1 row updated.

SQL> select * from intransit_articles;

ARTICLE_NO ARTICLE_TYPE         CURRENT_STATUS  OFFICE_CODE
---------- -------------------- --------------- -----------
      4001 Official Letter      in-transit             1001
      4004 Confidential Letter  in-transit             1002

VIEWS WITH JOINS
----------------
4.CREATE A VIEW THAT EMPLOYEE WITH DESIGNATION AND THEIR POSTING OFFICE,CITY

SQL> create view employee_office_view as select e.employee_no,e.employee_name,e.employee_designation,p.office_name,p.address_city from employee e join postoffice p on p.office_code = e.posting_office_code;

View created.

SQL> select * from employee_office_view;

EMPLOYEE_NO EMPLOYEE_NAME        EMPLOYEE_DESIGNATION
----------- -------------------- --------------------
OFFICE_NAME                    ADDRESS_CITY
------------------------------ ------------------------------
       3001 Rajesh Kumar         Postal Assistant
Sivakasi Head Post Office      Sivakasi

       3002 Rajesh Kumar         Postal Assistant
Sivakasi Head Post Office      Sivakasi

       3003 Arun Pandian         Postal Assistant
Sivakasi Head Post Office      Sivakasi

       3004 Guruprasad           Postman
Virudhunagar Sub Office        Virudhunagar

5.CREATE A VIEW THAT SHOWS FULL DELIVERY TRACKING DETAILS

SQL>create view delivery_tracking_view as select a.article_no,a.article_type,da.assignment_no,da.assigned_date,dt.attempt_sequence_no,dt.attempt_date,dt.attempt_status,e.employee_no,e.employee_name,e.employee_designation from article a join deliveryassignment da on a.article_no = da.article_no join deliverytracking dt on da.assignment_no = dt.assignment_no join employee e on da.employee_no = e.employee_no;

View created.

SQL> select * from delivery_tracking_view;

ARTICLE_NO ARTICLE_TYPE         ASSIGNMENT_NO ASSIGNED_ ATTEMPT_SEQUENCE_NO
---------- -------------------- ------------- --------- -------------------
ATTEMPT_D ATTEMPT_STATUS       EMPLOYEE_NO EMPLOYEE_NAME
--------- -------------------- ----------- --------------------
EMPLOYEE_DESIGNATION
--------------------
      4001 Official Letter               8001 10-FEB-26                   1
11-FEB-26 Unavailable                 3003 Arun Pandian
Postal Assistant

      4001 Official Letter               8001 10-FEB-26                   2
12-FEB-26 Delivered                   3003 Arun Pandian
Postal Assistant

      4002 Registered Parcel             8002 10-FEB-26                   3
11-FEB-26 Address Incorrect           3003 Arun Pandian
Postal Assistant

      4003 Speed Post                    8003 09-FEB-26                   4
09-FEB-26 Delivered                   3003 Arun Pandian
Postal Assistant

VIEWS WITH AGGREGATION
----------------------
6.CREATE A VIEW THAT CALCULATES TOTAL CHARGES COLLECTED PER OFFICE

SQL> create view office_total_charges as select p.office_name,p.address_city,sum(b.charges) as total_charges,count(b.receipt_no) as total_bookings from booking_info b join postoffice p on b.booking_officecode = p.office_code group by p.office_name,p.address_city;

View created.

SQL> select * from office_total_charges;

OFFICE_NAME                    ADDRESS_CITY                   TOTAL_CHARGES
------------------------------ ------------------------------ -------------
TOTAL_BOOKINGS
--------------
Sivakasi Head Post Office      Sivakasi                                 220
             2

Virudhunagar Sub Office        Virudhunagar                             330
             1

Madurai Central Office         Madurai                                  220

NESTED VIEWS
------------
7.CREATE A VIEW THAT SHOWS ONLY OFFICE WITH TOTAL CHARGES > 100

SQL> create view high_revenue_office as select office_name,address_city,total_charges from office_total_charges where total_charges > 300;

View created.

SQL> select * from high_revenue_office;

OFFICE_NAME                    ADDRESS_CITY                   TOTAL_CHARGES
------------------------------ ------------------------------ -------------
Virudhunagar Sub Office        Virudhunagar                             330

MODIFYING VIEWS
---------------
8.INSERT A NEW ARTICLE THROUGH ARTICLE_STATUS_VIEW

SQL> insert into article_status_view(article_no,article_type,current_status) values (4006,'letter','booked');

1 row created.

SQL> select * from article_status_view;

ARTICLE_NO ARTICLE_TYPE         CURRENT_STATUS
---------- -------------------- ---------------
      4001 Official Letter      in-transit
      4002 Registered Parcel    Booked
      4003 Speed Post           Booked
      4004 Confidential Letter  in-transit
      4005 Letter               Not yet
      4006 letter               booked

6 rows selected.

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

      4004       2003        2002 Confidential Letter  in-transit
       1002          104 Small                        10

      4005       2003        2002 Letter               Not yet
       1002          101 Small                         5

      4006                        letter               booked



6 rows selected.

9.INSERT A ARTICLE THROUGH IN-TRANSIT_ARTICLES VIEW

SQL> insert into intransit_articles(article_no,article_type,current_status,office_code) values(4007,'parcel','booked',1003);

1 row created.

SQL> select * from intransit_articles;

ARTICLE_NO ARTICLE_TYPE         CURRENT_STATUS  OFFICE_CODE
---------- -------------------- --------------- -----------
      4001 Official Letter      in-transit             1001
      4004 Confidential Letter  in-transit             1002

10.UPDATE THE STATUS OF ARTICLE THROUGH IN-TRANSIT_ARTICLES VIEW

SQL> select article_no,article_type,current_status,office_code from article where article_no = 4004;

ARTICLE_NO ARTICLE_TYPE         CURRENT_STATUS  OFFICE_CODE
---------- -------------------- --------------- -----------
      4004 Confidential Letter  in-transit             1002

SQL> update intransit_articles set current_status = 'delivered' where article_no = 4004;

1 row updated.

SQL> select * from intransit_articles;

ARTICLE_NO ARTICLE_TYPE         CURRENT_STATUS  OFFICE_CODE
---------- -------------------- --------------- -----------
      4001 Official Letter      in-transit             1001

SQL> select article_no,article_type,current_status,office_code from article where article_no = 4004;

ARTICLE_NO ARTICLE_TYPE         CURRENT_STATUS  OFFICE_CODE
---------- -------------------- --------------- -----------
      4004 Confidential Letter  delivered              1002

SQL> update intransit_articles set current_status = 'in-transit' where article_no = 4007;

0 rows updated.

SQL> select * from intransit_articles;

ARTICLE_NO ARTICLE_TYPE         CURRENT_STATUS  OFFICE_CODE
---------- -------------------- --------------- -----------
      4001 Official Letter      in-transit             1001

SQL> insert into employee_office_view(employee_no,employee_name,employee_designation,office_name,address_city) values(3005,'Gopesh Rathinam','Post Master','Sivakasi Head Postoffice','Sivakasi');
insert into employee_office_view(employee_no,employee_name,employee_designation,office_name,address_city) values(3005,'Gopesh Rathinam','Post Master','Sivakasi Head Postoffice','Sivakasi')
                                                                                *
ERROR at line 1:
ORA-01776: cannot modify more than one base table through a join view

SQL> update office_total_charges set address_city = 'Madurai' where office_name = 'Virudhunagar Sub Office';
update office_total_charges set address_city = 'Madurai' where office_name = 'Virudhunagar Sub Office'
       *
ERROR at line 1:
ORA-01732: data manipulation operation not legal on this view

DELETION IN VIEWS
-----------------
11.TO SHOWCASE DELETION THROUGH VIEW

SQL> select * from employee_backup;

EMPLOYEE_NO EMPLOYEE_TYPE        EMPLOYEE_CATEGORY    EMPLOYEE_DESIGNATION
----------- -------------------- -------------------- --------------------
SHIFT_DETAILS        POSTING_OFFICE_CODE DATE_OF_J EXPERIENCE SUPERVISORID
-------------------- ------------------- --------- ---------- ------------
STATUS               EMPLOYEE_NAME
-------------------- --------------------
       3007 Permanent            Field Staff          Postman
Morning                             1001 01-JAN-15
Active               Varun Karthick

       3008 Permanent            IPos                 Postmaster
Evening                             1001 15-MAR-18
Active               Preetish

       3002 Permanent            Operational Staff    Postal Assistant
Morning                             1001 23-DEC-17          8         3001
Active

       3003 Permanent            Operational Staff    Postal Assistant
Evening                             1001 15-MAR-18          7         3001
Active

       3004 Temporary            Field Staff          Postman
Evening                             1002 20-JUN-20          5         3001
Active

       3001 Permanent            Operationl Staff     Postal Assistant
Morning                             1001 01-JAN-15         11
Active


6 rows selected.

SQL> create view employee_backup_view as select employee_no,employee_name,employee_designation from employee_backup;

View created.

SQL> select * from employee_backup_view;

EMPLOYEE_NO EMPLOYEE_NAME        EMPLOYEE_DESIGNATION
----------- -------------------- --------------------
       3007 Varun Karthick       Postman
       3008 Preetish             Postmaster
       3002                      Postal Assistant
       3003                      Postal Assistant
       3004                      Postman
       3001                      Postal Assistant

6 rows selected.

SQL> delete from employee_backup_view;

6 rows deleted.

SQL> select * from employee_backup_view;

no rows selected

SQL> select * from employee_backup;

no rows selected

SQL> delete from office_total_charges;
delete from office_total_charges
            *
ERROR at line 1:
ORA-01732: data manipulation operation not legal on this view

12.DROP A VIEW

SQL> drop view article_status_view;

View dropped.

INDEX
-----
B-TREE
------
13.CREATE A INDEX ON ARTICLE_TYPE OF ARTICLE

SQL> create index idx_article_type on article(article_type);

Index created.

UNIQUE INDEX
------------
14.CREATE A UNIQUE INDEX ON EMAIL OF USERS

SQL> create unique index idx_user_email on userx(email);

Index created.

BITMAP INDEX
------------
15.CREATE A BITMAP INDEX ON EMPLOYEE_TYPE OF EMPLOYEE

SQL> create bitmap index idx_employee_type on employee(employee_type);

Index created.

COMPOSITE INDEX
---------------
16.CREATE A COMPOSITE INDEX ON ARTICLE_TYPE AND CURRENT_STATUS OF ARTICLE

SQL> create index idx_article_status on article(article_type,current_status);

Index created.

PRIMARY INDEX
-------------

SQL> create index idx_primary_key on booking_info(receipt_no);
create index idx_primary_key on booking_info(receipt_no)
                                             *
ERROR at line 1:
ORA-01408: such column list already indexed

SECONDARY INDEX
---------------
17.CREATE A SECONDARY INDEX ON BOOKING_EMPLOYEE OF BOOKIN_INFO

SQL> create index idx_booking_employee on booking_info(booking_empno);

Index created.

DROP INDEX
----------

SQL> drop index idx_article_type;

Index dropped.

SQL> set timing on;
SQL> select article_type from article;

ARTICLE_TYPE
--------------------
Official Letter
Registered Parcel
Speed Post
Confidential Letter
Letter
Letter
parcel

7 rows selected.

Elapsed: 00:00:00.00

SQL> create index idx_article_type on article(article_type);

Index created.

Elapsed: 00:00:00.01

SQL> select article_type from article;

ARTICLE_TYPE
--------------------
Official Letter
Registered Parcel
Speed Post
Confidential Letter
Letter
Letter
parcel

7 rows selected.

Elapsed: 00:00:00.00

SQL> select article_type,count(*) from article group by article_type;

ARTICLE_TYPE           COUNT(*)
-------------------- ----------
Official Letter               1
Registered Parcel             1
Speed Post                    1
Confidential Letter           1
Letter                        2
parcel                        1

6 rows selected.

Elapsed: 00:00:00.00

SQL> select article_type from article where article_type = 'Letter';

ARTICLE_TYPE
--------------------
Letter
Letter

Elapsed: 00:00:00.00
