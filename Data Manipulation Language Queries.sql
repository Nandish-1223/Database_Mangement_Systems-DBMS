--English Query :Add a new Post Office to the system

SQL> insert into postoffice values(101,'NagercoilPO','HO','23','nagarajakovilst','nagercoil','kannayakumari',629001,'nagercoil');

1 row created.

SQL> select  * from postoffice;

OFFICE _CODE OFFICE _NAME                    OFFICE _CATEGORY
------------ ------------------------------- -----------------------------
ADDRESS _BUILDING _NO            ADDRESS _STREET
-------------------------------- -----------------------------------------
ADDRESS _CITY                   ADDRESS _DISTRICT                  PINCODE
------------------------------- ---------------------------------- -------
BRANCH
------
        101 NagercoilPO                    HO
23                             nagarajakovilst
nagercoil                      kannayakumari                      629001
Nagercoil

--English Query :Add multiple Post Offices at once

SQL> insert all
  2  into postoffice values(102,'NagercoilPO','HO','23','nagarajakovilst','nagercoil','kannayakumari',629001,'nagercoil')
  3  into postoffice values(103,'ThuckalaiPO','HO','23','nagarajakovilst','nagercoil','kannayakumari',629001,'nagercoil')
  4  select  * from dual;

2 rows created.

SQL> select  * from postoffice;

OFFICE _CODE OFFICE _NAME                    OFFICE _CATEGORY
------------ ------------------------------- -----------------------------
ADDRESS _BUILDING _NO            ADDRESS _STREET
-------------------------------- -----------------------------------------
ADDRESS _CITY                   ADDRESS _DISTRICT                  PINCODE
------------------------------- ---------------------------------- -------
BRANCH
------
        101 NagercoilPO                    HO
23                             nagarajakovilst
nagercoil                      kannayakumari                      629001
nagercoil
        102 NagercoilPO                    HO
23                             nagarajakovilst
nagercoil                      kannayakumari                      629001
nagercoil
        103 ThuckalaiPO                    HO
23                             nagarajakovilst
nagercoil                      kannayakumari                      629001
Nagercoil

--English Query : Try to add a post office with existing office code

SQL> insert into postoffice values(101,'NagercoilPO','HO','23','nagarajakovilst','nagercoil','kannayakumari',629001,'nagercoil');

insert into postoffice values(101,'NagercoilPO','HO','23','nagarajakovilst','nagercoil','kannayakumari',629001,'nagercoil')
 *
ERROR at line 1:

ORA-00001: unique constraint (SYSTEM.SYS _C008568) violated

--English Query: Try to add contact number of postoffice with non-existent office code

SQL> insert into postoffice _contactno values(101,9443722108);

insert into postoffice _contactno values(101,9443722108)
 *
ERROR at line 1:

ORA-02291: integrity constraint (SYSTEM.FK _C1) violated - parent key not found

SQL> insert into postoffice _contactno values(102,9443722108);

1 row created.

SQL> insert into postoffice _contactno values(102,6374600572);

1 row created.

SQL> select  * from postoffice _contactno;

OFFICE _CODE CONTACT _NO
------------ -----------
        102 9443722108
        102 6374600572

--English Query: Attempt to insert invalid transport status

SQL> insert into transport(transport _no,operator _id,start _place,end _place,transport _status) values(0853,01,102,103,'not yet');

insert into transport(transport _no,operator _id,start _place,end _place,transport _status) values(0853,01,102,103,'not yet')
 *
ERROR at line 1:

ORA-02290: check constraint (SYSTEM.SYS _C008573) violated

SQL> insert into transport(transport _no,operator _id,start _place,end _place,transport _status) values(0853,01,102,103,'in-transit');

1 row created.

SQL> select  * from transport;

TRANSPORT _NO TRANSPORT _TYPE       OPERATOR _ID START _PLACE  END _PLACE START _TIME
------------- --------------------- ------------ ------------- ---------- -----------
END _TIME   TRANSPORT _CAPACITY ACUTAL _COUNT TRANSPORT _STATUS
----------- ------------------- ------------- -----------------
         853                                1         102        103
                                           in-transit

--English Query :Delete postoffice record whose office code = 102.

SQL> delete from postoffice where office _code = 102;

1 row deleted.
 
SQL> select  * from postoffice;

OFFICE _CODE OFFICE _NAME                    OFFICE _CATEGORY
------------ ------------------------------- -----------------------------
ADDRESS _BUILDING _NO            ADDRESS _STREET
-------------------------------- -----------------------------------------
ADDRESS _CITY                   ADDRESS _DISTRICT                  PINCODE
------------------------------- ---------------------------------- -------
BRANCH
------
        101 NagercoilPO                    HO
23                             nagarajakovilst
nagercoil                      kannayakumari                      629001
nagercoil
        103 ThuckalaiPO                    HO
23                             nagarajakovilst
nagercoil                      kannayakumari                      629001
Nagercoil

--English Query :Delete transport records.

SQL> delete from transport;

1 row deleted.

SQL> select  * from transport;

no rows selected

-- English Query: Increase all booking charges by 10%

SQL> select  * from booking _info;

RECEIPT _NO BOOKING _OFFICECODE BOOKING _EMPNO ARTICLE _NO    CHARGES
----------- ------------------- -------------- -------------- -------
      6001               1001          3001       4001         50
      6002               1001          3001       4002        150
      6003               1003          3001       4003        200
      6004               1002          3001       4004        300

SQL> update booking _info set charges = charges  * 1.10;

4 rows updated.

SQL> select  * from booking _info;

RECEIPT _NO BOOKING _OFFICECODE BOOKING _EMPNO ARTICLE _NO    CHARGES
----------- ------------------- -------------- -------------- -------
      6001               1001          3001       4001         55
      6002               1001          3001       4002        165
      6003               1003          3001       4003        220
      6004               1002          3001       4004        330

--English Query: Display records without duplicate entries.

SQL> select distinct office _category from postoffice;

OFFICE _CATEGORY
----------------
Head Post Office
Sub Post Office
Branch Post Office

SQL> select office _category from postoffice;

OFFICE _CATEGORY
----------------
Head Post Office
Sub Post Office
Head Post Office
Branch Post Office

--English Query:Order the urgency code levels based on highest priority

SQL> SELECT  * FROM urgencylevel ORDER BY priority desc;

URGENCYCODE URGENCY _TYPE           PRIORITY CAUTION
----------------------------------- ------------------------
DELIVERYTIMEFRAME    HANDLINGINSTRUCTION
-------------------- ---------------------------------------
        104 Confidential                  4 Very High
2-3 days             Seal must not be broken
        103 Speed Post                    3 High
1-2 days             Expedite delivery
        102 Registered                    2 Medium
5-7 days             Track carefully
        101 Ordinary                      1 Low
7-10 days            Normal handling sufficient

--STRING FUNCTIONS--

--English Query: Display office name of postoffice on uppercase, lowercase, capitalized.

SQL> select lower(office _name),upper(office _name),initcap(office _name) from postoffice;

LOWER(OFFICE _NAME)	       UPPER(OFFICE _NAME)	      INITCAP(OFFICE _NAME)
------------------------------ ------------------------------ --------------------------
nagercoilpo		       NAGERCOILPO		      Nagercoilpo
thuckalaipo		       THUCKALAIPO		      Thuckalaipo

--English Query: Display the transport Number of vehicle with 'TN'.

SQL> select concat('TN',transport _no) from transport;

CONCAT('TN',TRANSPORT _NO)
--------------------------
TN853

SQL> select 'TN'||'-'||transport _no from transport;

'TN'||'-'||TRANSPORT _NO
------------------------
TN-853

--English Query: Display the substring from the string

SQL> select substr('letter tracking system',8,8) from dual;

SUBSTR('
--------
tracking

--English Query: Display length of the string

SQL> select length(office _name) from postoffice;

LENGTH(OFFICE _NAME)
--------------------
                 11
                 11

--English Query: Display whether the substring is present in string or not.

SQL> select instr('letter tracking system','tracking') from dual;

INSTR('LETTERTRACKINGSYSTEM','TRACKING')
----------------------------------------
                                       8

SQL> select instr('letter tracking system','postoffice') from dual;

INSTR('LETTERTRACKINGSYSTEM','POSTOFFICE')
------------------------------------------
                                         0

SQL> select instr('letter tracking system','letter') from dual;

INSTR('LETTERTRACKINGSYSTEM','LETTER')
--------------------------------------
                                     1

--English Query: Format office name with padding

SQL> select lpad(office _name,20,' *') from postoffice;

LPAD(OFFICE _NAME,20,' *')
-----------------------------
 * * * * * * * * *NagercoilPO
 * * * * * * * * *ThuckalaiPO

SQL> select rpad(office _name,20,' *') from postoffice;

RPAD(OFFICE _NAME,20,' *')
-----------------------------
NagercoilPO * * * * * * * * *
ThuckalaiPO * * * * * * * * *

--English Query: Trim the leading spaces in the string

SQL> select ltrim('          letter         ') from dual;

LTRIM('LETTER')
---------------
letter

--English Query: Trim the trialing spaces in the string

SQL> select rtrim('          letter         ') from dual;

RTRIM('LETTER')
---------------
          letter

--English Query: Trim the leading and trialing spaces in the string

SQL> select trim('          letter         ') from dual;

TRIM('
------
letter

--English Query: Replace the character in the string

SQL> select replace('jim','j','t') from dual;

REP
---

tim

--English Query: Return the ascii value of first character of string.

SQL> select ascii(office_name) from postoffice;

ASCII(OFFICE_NAME)
------------------
                78
                84

--NUMBER FUNCTIONS--

--English Query : Round off to closest greatest number.

SQL> select round(148.89) from dual;

ROUND(148.89)
-------------
          149

--English Query : Round off to closest least number.

SQL> select trunc(148.89) from dual;

TRUNC(148.89)
-------------
          148

--English Query : Round off to closest greatest 10s number.

SQL> select round(148.89,-1) from dual;

ROUND(148.89,-1)
----------------
             150

--English Query : Round off to closest least 10s number.

SQL> select trunc(148.89,-1) from dual;

TRUNC(148.89,-1)
----------------
             140

--English Query: Find the remainder(modulus) of the number.

SQL> select mod(23,17) from dual;

MOD(23,17)
----------
         6

--English Query: Find the absolute value of a number.

SQL> select abs(23) from dual;

   ABS(23)
----------
        23

SQL> select abs(-23) from dual;

  ABS(-23)
----------
        23

--English Query: Find the ceil of a number.

SQL> select ceil(23.6) from dual;

CEIL(23.6)
----------
        24

--English Query: Find the floor of a number.

SQL> select floor(23.6) from dual;

FLOOR(23.6)
-----------
         23

--English Query: Find the power of a number.

SQL> select power(16,2) from dual;

POWER(16,2)
-----------
        256

--English Query: Find the Square root of a number.

SQL> select sqrt(4) from dual;

   SQRT(4)
----------
         2

--English Query: Find the Sign of a number.

SQL> select sign(23) from dual;

  SIGN(23)
----------
         1

SQL> select sign(-23) from dual;

 SIGN(-23)
----------
        -1

SQL> select sign(0) from dual;

   SIGN(0)
----------
         0

--English Query: Find the Natural log of a number.

SQL> select ln(10) from dual;

    LN(10)
----------
2.30258509

--English Query: Find the log with base of a number.

SQL> select log(10,10) from dual;

LOG(10,10)
----------
         1

--English Query: Find the Exponential of a number.

SQL> select exp(1) from dual;

    EXP(1)
----------
2.71828183

--English Query: Find the Greatest and least among numbers(row function).

SQL> select greatest(1,2,3) from dual;

GREATEST(1,2,3)
---------------
              3

SQL> select least(1,2,3) from dual;

LEAST(1,2,3)
------------
           1

SQL> select charges,greatest(charges),least(charges) from booking _info;

   CHARGES GREATEST(CHARGES) LEAST(CHARGES)
---------- ----------------- --------------
        55                55             55
       165               165            165
       220               220            220
       330               330            330

--English Query: Generate a Random number.

SQL> select dbms _random.value from dual;

     VALUE
----------
.030750649

SQL> select dbms _random.value from dual;

     VALUE
----------
.516553255

--DATE FUNCTIONS--

--English Query: Display the System date from system.

SQL> select sysdate from dual;

SYSDATE
---------
04-FEB-26

--English Query: Display the Current date from system.

SQL> select current _date from dual;

CURRENT _D
----------

04-FEB-26

--English Query: Display the Current time from system.

SQL> select current _timestamp from dual;

CURRENT _TIMESTAMP
-----------------------------------

04-FEB-26 02.31.22.966000 AM +05:30

--DATE ARITHMETIC--

--English Query: Display after six days date from current date.

SQL> select sysdate+6 from dual;

SYSDATE+6
---------
10-FEB-26

--English Query: Display before three days date from current date.

SQL> select sysdate-3 from dual;

SYSDATE-3
---------
01-FEB-26

SQL> select sysdate - to _date('23-01-26','dd-mm-yy') from dual;

SYSDATE-TO _DATE('23-01-26','DD-MM-YY')
---------------------------------------
                            12.1064699

SQL> select trunc(sysdate - to _date('23-01-26','dd-mm-yy')) from dual;

TRUNC(SYSDATE-TO _DATE('23-01-26','DD-MM-YY'))
----------------------------------------------
                                           12

--English Query: Convert Date Format into String Format.

SQL> select to _char(sysdate,'dd-mm-yyyy hh24:mi:ss') from dual;

TO _CHAR(SYSDATE,'DD
--------------------
04-02-2026 02:35:15

--English Query: Add Months to the Current Date.

SQL> select add _months(sysdate,11) from dual;

ADD _MONTH
----------
04-JAN-27

--English Query: Calculate Number of Months between Date to Date.

SQL> select months _between(sysdate,'23-DEC-2026') from dual;

MONTHS _BETWEEN(SYSDATE,'23-DEC-2026')
--------------------------------------
                           -10.609303

--English Query: Display the date of the specified next day from the given date.

SQL> select next _day(sysdate,'saturday') from dual;

NEXT _DAY(
----------
07-FEB-26

--English Query: Display the last date of month from the given date.

SQL> select last _day(sysdate) from dual;

LAST _DAY(
----------
28-FEB-26

--English Query: Display the day from the given date.

SQL> select extract(day from sysdate) from dual;

EXTRACT(DAYFROMSYSDATE)
-----------------------
                      4

--English Query: Display the month from the given date.

SQL> select extract(month from sysdate) from dual;

EXTRACT(MONTHFROMSYSDATE)
-------------------------
                        2

--English Query: Display the year from the given date.

SQL> select extract(year from sysdate) from dual;

EXTRACT(YEARFROMSYSDATE)
------------------------
                    2026

--English Query: Display the hour from the given time.

SQL> select extract(hour from current _timestamp) from dual;

EXTRACT(HOURFROMCURRENT _TIMESTAMP)
-----------------------------------
                                21

--English Query: Display the minute from the given time.

SQL> select extract(minute from current _timestamp) from dual;

EXTRACT(MINUTEFROMCURRENT _TIMESTAMP)
-------------------------------------
                                  15

--English Query: Display the second from the given time.

SQL> select extract(second from current _timestamp) from dual;

EXTRACT(SECONDFROMCURRENT _TIMESTAMP)
-------------------------------------
                               6.484

--English Query: Convert String Format into number Format.

SQL> select to _number('1234') from dual;

TO _NUMBER('1234')
------------------
             1234

--English Query: Display the year in Characters.

SQL> select to _char(sysdate,'year') from dual;

TO _CHAR(SYSDATE,'YEAR')
------------------------
twenty twenty-six

--Aggregate Functions--

--English Query: Find the total Number of Bookings.

SQL> select count(receipt _no) from booking _info;

COUNT(RECEIPT _NO)
------------------

                4

--English Query: Find the sum of charges from bookings.

SQL> select sum(charges) from booking _info;

SUM(CHARGES)
------------
         770

--English Query: Find the average of charges from bookings.

SQL> select avg(charges) from booking _info;

AVG(CHARGES)
------------
       192.5

--English Query: Find the maximum charges from bookings.

SQL> select max(charges) from booking _info;

MAX(CHARGES)
------------
         330

--English Query: Find the minimum charges from bookings.

SQL> select min(charges) from booking _info;

MIN(CHARGES)
------------
          55

--English Query: Find the standard deviation of charges from bookings.

SQL> select stddev(charges) from booking _info;

STDDEV(CHARGES)
---------------
      114.49163

--English Query: Find the median value of charges from bookings.

SQL> select median(charges) from booking _info;

MEDIAN(CHARGES)
---------------
         192.5

--English Query: Find the variance of charges from bookings.

SQL> select variance(charges) from booking _info;

VARIANCE(CHARGES)
-----------------
      13108.3333

--English Query: Find all active employees

SQL> select employee_no,employee_name,employee_designation from employee where lower(status) = 'active';

EMPLOYEE _NO EMPLOYEE _NAME        EMPLOYEE _DESIGNATION
------------ -------------------- --------------------
      3001   Gokul                Postal Assistant
      3002   Vishnu               Postal Assistant

--English Query: Find the Total Revenue collects by each post office.

SQL> select booking_officecode,sum(charges) as office _revenue from booking _info group by booking _officecode;

BOOKING _OFFICECODE OFFICE _REVENUE
------------------- ---------------
               1001            220
               1003            220
               1002            330

--English Query: Find the post office whose revenue exceeds 250.

SQL> select booking _officecode,sum(charges) as office _revenue from booking _info group by booking _officecode having sum(charges) > 250;

BOOKING _OFFICECODE OFFICE _REVENUE
------------------- ---------------
               1002            330

--English Query: Count the number of employees in each post office. 

SQL> select posting _office _code,count(distinct employee _no) as employee _count from employee group by posting _office _code;

POSTING _OFFICE _CODE EMPLOYEE _COUNT
--------------------- ---------------
                 1001              2

--English Query: Find employees who joined between Jan 2015 to Dec 2015.

SQL> select employee _no,employee _designation,date _of _join from employee where date _of _join between date '2015-01-01'and date '2015-12-31';

EMPLOYEE _NO EMPLOYEE _DESIGNATION DATE _OF _J
------------ --------------------- -----------
        3001 Postal Assistant      01-JAN-15

--English Query: Find employees who not join between 2015 to 2017.

SQL> select employee _no,employee _designation,date _of _join from employee where date _of _join not between date '2015-01-01'and date '2017-12-31';

EMPLOYEE _NO EMPLOYEE _DESIGNATION DATE _OF _J
------------ --------------------- -----------
        3002 Postal Assistant      15-MAR-18

--English Query: Find the articles with Specified status values.

SQL> select article_no,current_status from article where lower(current _status) in ('booked','in-transit','delivered');

ARTICLE _NO CURRENT _STATUS
----------- ---------------
       4001 Booked
       4002 Booked
       4003 Booked
       4004 Booked

----English Query: Find the articles that are not yet delivered or returned.

SQL> select article _no,current _status from article where lower(current _status) not in ('in-transit','delivered');

ARTICLE _NO CURRENT _STATUS
----------- ---------------
       4001 Booked
       4002 Booked
       4003 Booked
       4004 Booked

--English Query: Find the post offices whose name starts with 'S'.

SQL> select office _code,office _name from postoffice where office _name like 'S%';

OFFICE _CODE OFFICE _NAME
------------ ------------------------------
        1001 Sivakasi Head Post Office
        1004 Sivakasi Branch Office

--English Query: Find the post offices whose name ends with 'office'.

SQL> select office_code,office_name from postoffice where office_name like '%Office';

OFFICE _CODE OFFICE _NAME
------------ ------------------------------
        1001 Sivakasi Head Post Office
        1002 Virudhunagar Sub Office
        1003 Madurai Central Office
        1004 Sivakasi Branch Office

--English Query: Find the post offices whose name contains 'Central'.

SQL> select office_code,office_name from postoffice where office_name like '%Central%';

OFFICE _CODE OFFICE _NAME
------------ ------------------------------
        1003 Madurai Central Office

SQL> select address _city from postoffice;

ADDRESS _CITY
------------------------------
Sivakasi
Virudhunagar
Madurai
Sivakasi

--English Query: Find the cities with exactly 7 characters.

SQL> select distinct address_city from postoffice where address_city like ' ________';

ADDRESS _CITY
------------------------------
Sivakasi

--English Query: Find the cities with second letter is 'a'.

SQL> select distinct address _city from postoffice where address _city like ' _a%';

ADDRESS _CITY
------------------------------
Madurai

--English Query: Find the post offices whose name starts with 'm' and end with 'i'.

SQL> select distinct address_city from postoffice where lower(address _city) like 'm%i';

ADDRESS _CITY
------------------------------
Madurai

--English Query: Find the post offices whose name starts not with 'S'.

SQL> select office_code,office_name from postoffice where office_name not like 'S%';

OFFICE _CODE OFFICE _NAME
------------ ------------------------------
        1002 Virudhunagar Sub Office
        1003 Madurai Central Office

--English Query: Find the employees who have a supervisor

SQL> select employee _no,supervisorid from employee where supervisorid is not null;

EMPLOYEE _NO SUPERVISORID
------------ ------------
        3002         3001

--English Query: Find the employees who doesn't have a supervisor

SQL> select employee _no,supervisorid from employee where supervisorid is null;

EMPLOYEE _NO SUPERVISORID
------------ ------------
        3001

--English Query: Decode the cities of the post office.

SQL> select address _city,decode(address _city,'Nagercoil','NGL','Virudhunagar','VNR','Madurai','MDU','TN') from postoffice;

ADDRESS _CITY                   DEC
------------------------------ -----
Sivakasi                       TN
Virudhunagar                   VNR
Madurai                        MDU
Sivakasi                       TN

--English Query: Order the urgency code level on lowest priority. 

SQL> select  * from urgencylevel order by priority asc;

URGENCYCODE URGENCY _TYPE           PRIORITY CAUTION
----------- ----------------------- -------- --------------------
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

--English Query: Group number of users by their district, city, and street. 

ADDRESS_DISTRICT     ADDRESS_CITY         ADDRESS_STREET       COUNT(USER _ID)
------------------- --------------------- -------------------- --------------
Virudhunagar         Sivakasi             Temple Street                     1
Madurai              Madurai              Market Road                       1
Virudhunagar         Virudhunagar         Station Road                      1

--English Query: Order the employee details based on name, experience in alphabetical order.

SQL> select employee_name,experience from employee order by employee_name,experience asc;

EMPLOYEE_NAME        EXPERIENCE
-------------------- ----------
Arun Pandian                  7
Guruprasad                    5
Rajesh Kumar                  8
Rajesh Kumar                 11

--English Query: Order the employee details based on name, experience in reverse order.

SQL> select employee_name,experience from employee order by employee_name,experience desc;

EMPLOYEE_NAME        EXPERIENCE
-------------------- ----------
Arun Pandian                  7
Guruprasad                    5
Rajesh Kumar                 11
Rajesh Kumar                  8

--English Query: Count the employees based on their type.

SQL> select count(employee_type) as no_of_employee from employee;

NO_OF_EMPLOYEE
--------------
             4

SQL> select count(distinct employee_type) as no_of_employee from employee;

NO_OF_EMPLOYEE
--------------
             2



