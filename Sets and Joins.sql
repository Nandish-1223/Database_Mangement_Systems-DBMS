UNION
-----
1.FIND CITIES WHERE POSTOFFICE AND USERS EXISTS

SQL> select address_city from postoffice;

ADDRESS_CITY
------------------------------
Sivakasi
Virudhunagar
Madurai
Sivakasi

SQL> select address_city from userx;

ADDRESS_CITY
--------------------
Sivakasi
Madurai
Virudhunagar
Nagercoil

SQL> select address_city from postoffice union select address_city from usex;

ADDRESS_CITY
------------------------------
Sivakasi
Virudhunagar
Madurai
Nagercoil

SQL> select address_city from postoffice union all select address_city from userx;

ADDRESS_CITY
------------------------------
Sivakasi
Virudhunagar
Madurai
Sivakasi
Sivakasi
Madurai
Virudhunagar
Nagercoil

8 rows selected.

INTERSECT
---------
2.FIND CITIES THAT HAVE BOTH POSTOFFICE AND USERS

SQL> select address_city from postoffice intersect select address_city from userx;

ADDRESS_CITY
------------------------------
Sivakasi
Virudhunagar
Madurai

SQL> select address_city from postoffice intersect all select address_city from userx;

ADDRESS_CITY
------------------------------
Sivakasi
Virudhunagar
Madurai

MINUS AND EXCEPT
----------------
3.FIND THE ARTICLES THAT HAVE NO ENTRIES IN BOOKING_INFO
SQL> select article_no from article;

ARTICLE_NO
----------
      4001
      4002
      4003
      4004
      4005

SQL> select article_no from booking_info;

ARTICLE_NO
----------
      4001
      4002
      4003
      4004

SQL> select article_no from article minus select article_no from booking_info;

ARTICLE_NO
----------
      4005

SQL> select article_no from article except select article_no from booking_info;

ARTICLE_NO
----------
      4005
JOINS : CARTESIAN PRODUCT
-------------------------
COMMA OPERATOR

4.DISPLAY THE ARTICLES PARIED WITH EVERY POSTOFFICE

SQL> select article_no,article_type,office_code from article;

ARTICLE_NO ARTICLE_TYPE         OFFICE_CODE
---------- -------------------- -----------
      4001 Official Letter             1001
      4002 Registered Parcel           1001
      4003 Speed Post                  1003
      4004 Confidential Letter         1002
      4005 Letter                      1002

SQL> select office_code,office_name from postoffice;

OFFICE_CODE OFFICE_NAME
----------- ------------------------------
       1001 Sivakasi Head Post Office
       1002 Virudhunagar Sub Office
       1003 Madurai Central Office
       1004 Sivakasi Branch Office

SQL> select a.article_no,a.article_type,a.office_code,p.office_code,p.office_name from article a,postoffice p;

ARTICLE_NO ARTICLE_TYPE         OFFICE_CODE OFFICE_CODE
---------- -------------------- ----------- -----------
OFFICE_NAME
------------------------------
      4001 Official Letter             1001        1001
Sivakasi Head Post Office

      4001 Official Letter             1001        1002
Virudhunagar Sub Office

      4001 Official Letter             1001        1003
Madurai Central Office

      4001 Official Letter             1001        1004
Sivakasi Branch Office

      4002 Registered Parcel           1001        1001
Sivakasi Head Post Office

      4002 Registered Parcel           1001        1002
Virudhunagar Sub Office

      4002 Registered Parcel           1001        1003
Madurai Central Office

      4002 Registered Parcel           1001        1004
Sivakasi Branch Office

      4003 Speed Post                  1003        1001
Sivakasi Head Post Office

      4003 Speed Post                  1003        1002
Virudhunagar Sub Office

      4003 Speed Post                  1003        1003
Madurai Central Office

      4003 Speed Post                  1003        1004
Sivakasi Branch Office

      4004 Confidential Letter         1002        1001
Sivakasi Head Post Office

      4004 Confidential Letter         1002        1002
Virudhunagar Sub Office

      4004 Confidential Letter         1002        1003
Madurai Central Office

      4004 Confidential Letter         1002        1004
Sivakasi Branch Office

      4005 Letter                      1002        1001
Sivakasi Head Post Office

      4005 Letter                      1002        1002
Virudhunagar Sub Office

      4005 Letter                      1002        1003
Madurai Central Office

      4005 Letter                      1002        1004
Sivakasi Branch Office


20 rows selected.

USING 'CROSS JOIN' KEYWORD
--------------------------

5.DISPLAY THE MAILBAG PARIED WITH EVERY TRANSPORT DETAILS

SQL> select bagnumber,transport_no from mailbag;

 BAGNUMBER TRANSPORT_NO
---------- ------------
      7001         5001
      7002         5002
      7003         5003

SQL> select transport_no,transport_type from transport;

TRANSPORT_NO TRANSPORT_TYPE
------------ --------------------
        5001 Road Vehicle
        5002 Rail
        5003 Road Vehicle

SQL> select m.bagnumber,m.transport_no,t.transport_no,t.transport_type from mailbag m cross join transport t;

 BAGNUMBER TRANSPORT_NO TRANSPORT_NO TRANSPORT_TYPE
---------- ------------ ------------ --------------------
      7001         5001         5001 Road Vehicle
      7001         5001         5002 Rail
      7001         5001         5003 Road Vehicle
      7002         5002         5001 Road Vehicle
      7002         5002         5002 Rail
      7002         5002         5003 Road Vehicle
      7003         5003         5001 Road Vehicle
      7003         5003         5002 Rail
      7003         5003         5003 Road Vehicle

9 rows selected.

CARTESIAN PRODUCT WITH CONDITION
--------------------------------

SQL> select m.bagnumber,m.transport_no,t.transport_no,t.transport_type from mailbag m,transport t where m.transport_no = t.transport_no;

 BAGNUMBER TRANSPORT_NO TRANSPORT_NO TRANSPORT_TYPE
---------- ------------ ------------ --------------------
      7001         5001         5001 Road Vehicle
      7002         5002         5002 Rail
      7003         5003         5003 Road Vehicle

SQL> select receipt_no,article_no,charges from booking_info;

RECEIPT_NO ARTICLE_NO    CHARGES
---------- ---------- ----------
      6001       4001         55
      6002       4002        165
      6003       4003        220
      6004       4004        330

SQL> select employee_no,employee_designation from employee;

EMPLOYEE_NO EMPLOYEE_DESIGNATION
----------- --------------------
       3001 Postal Assistant
       3002 Postal Assistant
       3003 Postal Assistant
       3004 Postman

USING 'INNER JOIN' KEYWORD
--------------------------

SQL> select receipt_no,article_no,charges,employee_no,employee_designation from booking_info inner join employee on booking_empno = employee_no;

RECEIPT_NO ARTICLE_NO    CHARGES EMPLOYEE_NO EMPLOYEE_DESIGNATION
---------- ---------- ---------- ----------- --------------------
      6001       4001         55        3001 Postal Assistant
      6002       4002        165        3001 Postal Assistant
      6003       4003        220        3001 Postal Assistant
      6004       4004        330        3001 Postal Assistant

USING 'JOIN' KEYWORD
--------------------

SQL> select receipt_no,article_no,charges,employee_no,employee_designation from booking_info join employee on booking_empno = employee_no;

RECEIPT_NO ARTICLE_NO    CHARGES EMPLOYEE_NO EMPLOYEE_DESIGNATION
---------- ---------- ---------- ----------- --------------------
      6001       4001         55        3001 Postal Assistant
      6002       4002        165        3001 Postal Assistant
      6003       4003        220        3001 Postal Assistant
      6004       4004        330        3001 Postal Assistant

NATURAL JOIN
------------
7.DISPLAY THE MAILBAG WITH THEIR TRANSPORT DETAILS

SQL> select bagnumber,transport_no,transport_type from mailbag natural join transport;

 BAGNUMBER TRANSPORT_NO TRANSPORT_TYPE
---------- ------------ --------------------
      7001         5001 Road Vehicle
      7002         5002 Rail
      7003         5003 Road Vehicle

LEFT OUTER JOIN
---------------
8.DISPLAY ALL ARTICLES AND THEIR DELIVERY ASSIGNMENT

SQL> select article_no,article_type,current_status from article;

ARTICLE_NO ARTICLE_TYPE         CURRENT_STATUS
---------- -------------------- ---------------
      4001 Official Letter      Booked
      4002 Registered Parcel    Booked
      4003 Speed Post           Booked
      4004 Confidential Letter  Booked
      4005 Letter               Not yet

SQL> select assignment_no,expected_delivery_date,delivery_status from deliveryassignment;

ASSIGNMENT_NO EXPECTED_ DELIVERY_STATUS
------------- --------- ---------------
         8001 15-FEB-26 Pending
         8002 14-FEB-26 Pending
         8003 10-FEB-26 In-Progress

SQL> select a.article_no,a.article_type,a.current_status,d.assignment_no,d.expected_delivery_date,d.delivery_status from article a left outer join deliveryassignment d on a.article_no = d.article_no;

ARTICLE_NO ARTICLE_TYPE         CURRENT_STATUS  ASSIGNMENT_NO EXPECTED_
---------- -------------------- --------------- ------------- ---------
DELIVERY_STATUS
---------------
      4001 Official Letter      Booked                   8001 15-FEB-26
Pending

      4002 Registered Parcel    Booked                   8002 14-FEB-26
Pending

      4003 Speed Post           Booked                   8003 10-FEB-26
In-Progress

      4004 Confidential Letter  Booked


      4005 Letter               Not yet

RIGHT OUTER JOIN
----------------
8.DISPLAY DELIVERYASSIGNMENT WITH ITS ARTICLES.

SQL> select d.assignment_no,d.expected_delivery_date,d.delivery_status,a.article_no,a.article_type,a.current_status from deliveryassignment d right outer join article a on a.article_no = d.article_no;

ASSIGNMENT_NO EXPECTED_ DELIVERY_STATUS ARTICLE_NO ARTICLE_TYPE
------------- --------- --------------- ---------- --------------------
CURRENT_STATUS
---------------
         8001 15-FEB-26 Pending               4001 Official Letter
Booked

         8002 14-FEB-26 Pending               4002 Registered Parcel
Booked

         8003 10-FEB-26 In-Progress           4003 Speed Post
Booked

                                              4004 Confidential Letter
Booked

                                              4005 Letter

FULL OUTER JOIN
---------------
9.DISPLAY ALL USERS AND ALL POSTOFFICE MATCHED BY THEIR CITY

SQL> select user_name,u.address_city as usercity,office_name,p.address_city as officecity from userx u full outer join postoffice p on u.address_city = p.address_city;

USER_NAME                 USERCITY             OFFICE_NAME
------------------------- -------------------- ------------------------------
OFFICECITY
------------------------------
Rajesh Kumar              Sivakasi             Sivakasi Head Post Office
Sivakasi

Arun Pandian              Virudhunagar         Virudhunagar Sub Office
Virudhunagar

Priya Sharma              Madurai              Madurai Central Office
Madurai

Rajesh Kumar              Sivakasi             Sivakasi Branch Office
Sivakasi

                                               Tenkasi Head Post Office
Tenkasi

Shree Nandish             Nagercoil

SELF JOIN
---------
10.DISPLAY THE EMPLOYEE WITH THEIR SUPERVISOR

SQL> select e1.employee_no as empno,e1.employee_name as empname,e2.employee_no as supervisorid,e2.employee_name as supname from employee e1 join employee e2 on e1.supervisorid = e2.employee_no;

     EMPNO EMPNAME              SUPERVISORID SUPNAME
---------- -------------------- ------------ --------------------
      3002 Rajesh Kumar                 3001 Rajesh Kumar
      3003 Arun Pandian                 3001 Rajesh Kumar
      3004 Guruprasad                   3001 Rajesh Kumar

MULTI TABLE JOINS
-----------------
11.DISPLAY THE ARTICLES WITH THEIR BOOKING DETAILS AND POSTOFFICE DETAILS

SQL> select a.article_no,a.article_type,b.receipt_no,b.charges,p.office_name from article a join booking_info b on a.article_no = b.article_no join postoffice p on b.booking_officecode = p.office_code;

ARTICLE_NO ARTICLE_TYPE         RECEIPT_NO    CHARGES
---------- -------------------- ---------- ----------
OFFICE_NAME
------------------------------
      4001 Official Letter            6001         55
Sivakasi Head Post Office

      4002 Registered Parcel          6002        165
Sivakasi Head Post Office

      4004 Confidential Letter        6004        330
Virudhunagar Sub Office

      4003 Speed Post                 6003        220
Madurai Central Office

12.DISPLAY THE ARTICLE WITH THEIR ASSIGNMENT AND TRACKING DETAILS ALSO WITH EMPLOYEE DETAILS

SQL> select a.article_no,a.article_type,da.assignment_no,da.assigned_date,dt.attempt_date,dt.attempt_status,e.employee_no,e.employee_name from article a join deliveryassignment da on a.article_no = da.article_no join deliverytracking dt on da.assignment_no = dt.assignment_no join employee e on da.employee_no = e.employee_no;

ARTICLE_NO ARTICLE_TYPE         ASSIGNMENT_NO ASSIGNED_ ATTEMPT_D
---------- -------------------- ------------- --------- ---------
ATTEMPT_STATUS       EMPLOYEE_NO EMPLOYEE_NAME
-------------------- ----------- --------------------
      4001 Official Letter               8001 10-FEB-26 11-FEB-26
Unavailable                 3003 Arun Pandian

      4001 Official Letter               8001 10-FEB-26 12-FEB-26
Delivered                   3003 Arun Pandian

      4002 Registered Parcel             8002 10-FEB-26 11-FEB-26
Address Incorrect           3003 Arun Pandian

      4003 Speed Post                    8003 09-FEB-26 09-FEB-26
Delivered                   3003 Arun Pandian

'USING' KEYWORD
---------------
13.DISPLAY THE ARTICLES WTH THEIR POSTOFFICE NAME AND ITS CITY

SQL> select article_no,article_type,current_status,office_name,address_city from article join postoffice using (office_code);

ARTICLE_NO ARTICLE_TYPE         CURRENT_STATUS  OFFICE_NAME
---------- -------------------- --------------- ------------------------------
ADDRESS_CITY
------------------------------
      4001 Official Letter      Booked          Sivakasi Head Post Office
Sivakasi

      4002 Registered Parcel    Booked          Sivakasi Head Post Office
Sivakasi

      4004 Confidential Letter  Booked          Virudhunagar Sub Office
Virudhunagar

      4005 Letter               Not yet         Virudhunagar Sub Office
Virudhunagar

      4003 Speed Post           Booked          Madurai Central Office
Madurai

EQU JOIN
--------

SQL> select employee_no,employee_name from employee join booking_info on employee_no = booking_empno;

EMPLOYEE_NO EMPLOYEE_NAME
----------- --------------------
       3001 Rajesh Kumar
       3001 Rajesh Kumar
       3001 Rajesh Kumar
       3001 Rajesh Kumar

NON EQU JOIN
------------
14.FIND EMPLOYEES NOT WORKING IN BOOKING15:03 02-03-2026

SQL> select employee_no,employee_name from employee join booking_info on employee_no <> booking_empno;

EMPLOYEE_NO EMPLOYEE_NAME
----------- --------------------
       3002 Rajesh Kumar
       3002 Rajesh Kumar
       3002 Rajesh Kumar
       3002 Rajesh Kumar
       3003 Arun Pandian
       3003 Arun Pandian
       3003 Arun Pandian
       3003 Arun Pandian
       3004 Guruprasad
       3004 Guruprasad
       3004 Guruprasad
       3004 Guruprasad

12 rows selected.




