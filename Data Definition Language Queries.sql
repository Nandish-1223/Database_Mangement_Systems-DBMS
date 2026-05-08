SQL> create table postoffice(
  2  office_code int primary key,
  3  office_name varchar(30),
  4  office_category varchar(20),
  5  address_building_no varchar(30),
  6  address_street varchar(30),
  7  address_city varchar(30),
  8  address_district varchar(30),
  9  pincode int,
 10  branch varchar(20));

Table created.

SQL> desc postoffice
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 OFFICE_CODE                               NOT NULL NUMBER(38)
 OFFICE_NAME                                        VARCHAR2(30)
 OFFICE_CATEGORY                                    VARCHAR2(20)
 ADDRESS_BUILDING_NO                                VARCHAR2(30)
 ADDRESS_STREET                                     VARCHAR2(30)
 ADDRESS_CITY                                       VARCHAR2(30)
 ADDRESS_DISTRICT                                   VARCHAR2(30)
 PINCODE                                            NUMBER(38)
 BRANCH                                             VARCHAR2(20)

SQL> create table postoffice_contactno(
  2  office_code int,
  3  contact_no int,
  4  constraint fk_c1 foreign key(office_code) references postoffice(office_code),
  5  primary key(office_code,contact_no));

Table created.

SQL> desc postoffice_contactno
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 OFFICE_CODE                               NOT NULL NUMBER(38)
 CONTACT_NO				   NOT NULL NUMBER(38)

SQL> create table employee(
  2  employee_no int primary key,
  3  employee_type varchar(20),
  4  employee_category varchar(20),
  5  employee_designation varchar(20),
  6  shift_details varchar(20),
  7  posting_office_code int,
  8  date_of_join date,
  9  experience float,
 10  supervisorid int,
 11  status varchar(20),
 12  constraint fk_c2 foreign key(posting_office_code) references postoffice(office_code));

Table created.

SQL> desc employee;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 EMPLOYEE_NO                               NOT NULL NUMBER(38)
 EMPLOYEE_TYPE                                      VARCHAR2(20)
 EMPLOYEE_CATEGORY                                  VARCHAR2(20)
 EMPLOYEE_DESIGNATION                               VARCHAR2(20)
 SHIFT_DETAILS                                      VARCHAR2(20)
 POSTING_OFFICE_CODE                                NUMBER(38)
 DATE_OF_JOIN                                       DATE
 EXPERIENCE                                         FLOAT(126)
 SUPERVISORID                                       NUMBER(38)
 STATUS                                             VARCHAR2(20)

SQL> create table transport(
  2  transport_no int,
  3  transport_type varchar(20),
  4  operator_id int,
  5  start_place int,
  6  end_place int,
  7  start_time varchar(10),
  8  end_time varchar(10),
  9  transport_capacity int,
 10  acutal_count int,
 11  transport_status varchar(20),
 12  check(transport_status in('in-transit','scheduled','completed')));

Table created.

SQL> desc transport;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 TRANSPORT_NO                                       NUMBER(38)
 TRANSPORT_TYPE                                     VARCHAR2(20)
 OPERATOR_ID                                        NUMBER(38)
 START_PLACE                                        NUMBER(38)
 END_PLACE                                          NUMBER(38)
 START_TIME                                         VARCHAR2(10)
 END_TIME                                           VARCHAR2(10)
 TRANSPORT_CAPACITY                                 NUMBER(38)
 ACUTAL_COUNT                                       NUMBER(38)
 TRANSPORT_STATUS                                   VARCHAR2(20)

SQL> alter table transport add primary key(transport_no);

Table altered.

SQL> alter table transport add constraint fk_c3 foreign key(start_place) references postoffice(office_code);

Table altered.

SQL> alter table transport add constraint fk_c4 foreign key(end_place) references postoffice(office_code);

Table altered.

SQL> desc transport;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 TRANSPORT_NO                              NOT NULL NUMBER(38)
 TRANSPORT_TYPE                                     VARCHAR2(20)
 OPERATOR_ID                                        NUMBER(38)
 START_PLACE                                        NUMBER(38)
 END_PLACE                                          NUMBER(38)
 START_TIME                                         VARCHAR2(10)
 END_TIME                                           VARCHAR2(10)
 TRANSPORT_CAPACITY                                 NUMBER(38)
 ACUTAL_COUNT                                       NUMBER(38)
 TRANSPORT_STATUS                                   VARCHAR2(20)

SQL> create table deliveryassignment(
  2  assignment_no int primary key,
  3  employee_no int,
  4  article_no int,
  5  assigned_date date,
  6  expect_delivery_date date,
  7  delivery_status varchar(20),
  8  constraint fk_c5 foreign key(employee_no) references employee(employee_no));

Table created.

SQL> desc deliveryassignment;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 ASSIGNMENT_NO                             NOT NULL NUMBER(38)
 EMPLOYEE_NO                                        NUMBER(38)
 ARTICLE_NO                                         NUMBER(38)
 ASSIGNED_DATE                                      DATE
 EXPECT_DELIVERY_DATE                               DATE
 DELIVERY_STATUS                                    VARCHAR2(20)

SQL> alter table deliveryassignment add acutal_delivery_date date;

Table altered.

SQL> alter table deliveryassignment rename column expect_delivery_date to expected_delivery_date;

Table altered.

SQL> alter table deliveryassignment modify delivery_status varchar(15);

Table altered.

SQL> desc deliveryassignment;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 ASSIGNMENT_NO                             NOT NULL NUMBER(38)
 EMPLOYEE_NO                                        NUMBER(38)
 ARTICLE_NO                                         NUMBER(38)
 ASSIGNED_DATE                                      DATE
 EXPECTED_DELIVERY_DATE                             DATE
 DELIVERY_STATUS                                    VARCHAR2(15)
 ACUTAL_DELIVERY_DATE                               DATE

SQL> create table deliverytrack(
  2  attempt_sequence_no int unique,
  3  assignment_no int,
  4  attempt_date date,
  5  attempt_time varchar(20),
  6  attempt_status varchar(20),
  7  constraint fk_c6 foreign key(assignment_no) references deliveryassignment(assignment_no));

Table created.

SQL> desc deliverytrack
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 ATTEMPT_SEQUENCE_NO                                NUMBER(38)
 ASSIGNMENT_NO                                      NUMBER(38)
 ATTEMPT_DATE                                       DATE
 ATTEMPT_TIME                                       VARCHAR2(20)
 ATTEMPT_STATUS                                     VARCHAR2(20)

SQL> alter table deliverytrack add constraint p1 primary key(attempt_sequence_no,assignment_no);

Table altered.

SQL> rename deliverytrack to deliverytracking;

Table renamed.

SQL> desc deliverytrack;
ERROR:
ORA-04043: object deliverytrack does not exist


SQL> desc deliverytracking;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 ATTEMPT_SEQUENCE_NO                       NOT NULL NUMBER(38)
 ASSIGNMENT_NO                             NOT NULL NUMBER(38)
 ATTEMPT_DATE                                       DATE
 ATTEMPT_TIME                                       VARCHAR2(20)
 ATTEMPT_STATUS                                     VARCHAR2(20)

SQL> alter table deliverytracking drop constraint p1;

Table altered.

SQL> desc deliverytracking;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 ATTEMPT_SEQUENCE_NO                                NUMBER(38)
 ASSIGNMENT_NO                                      NUMBER(38)
 ATTEMPT_DATE                                       DATE
 ATTEMPT_TIME                                       VARCHAR2(20)
 ATTEMPT_STATUS                                     VARCHAR2(20)

SQL> create table copy as select * from deliverytracking;

Table created.

SQL> desc copy
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 ATTEMPT_SEQUENCE_NO                                NUMBER(38)
 ASSIGNMENT_NO                                      NUMBER(38)
 ATTEMPT_DATE                                       DATE
 ATTEMPT_TIME                                       VARCHAR2(20)
 ATTEMPT_STATUS                                     VARCHAR2(20)

SQL> create table copy1 as select * from deliverytracking where 1=0;

Table created.

SQL> desc copy1
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 ATTEMPT_SEQUENCE_NO                                NUMBER(38)
 ASSIGNMENT_NO                                      NUMBER(38)
 ATTEMPT_DATE                                       DATE
 ATTEMPT_TIME                                       VARCHAR2(20)
 ATTEMPT_STATUS                                     VARCHAR2(20)

SQL> alter table copy1 drop column attempt_time;

Table altered.

SQL> desc copy1
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 ATTEMPT_SEQUENCE_NO                                NUMBER(38)
 ASSIGNMENT_NO                                      NUMBER(38)
 ATTEMPT_DATE                                       DATE
 ATTEMPT_STATUS                                     VARCHAR2(20)

SQL> drop table copy1;

Table dropped.

SQL> desc copy1;
ERROR:
ORA-04043: object copy1 does not exist

SQL> truncate table copy;

Table truncated.

SQL> desc copy;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 ATTEMPT_SEQUENCE_NO                                NUMBER(38)
 ASSIGNMENT_NO                                      NUMBER(38)
 ATTEMPT_DATE                                       DATE
 ATTEMPT_TIME                                       VARCHAR2(20)
 ATTEMPT_STATUS                                     VARCHAR2(20)

SQL> drop table copy;

Table dropped.

SQL> desc copy;
ERROR:
ORA-04043: object copy does not exist

SQL> create table mailbag(
  2  bagnumber int primary key,
  3  transport_no int,
  4  dispatch_time varchar(20),
  5  orgin_code int,
  6  destination_code int,
  7  constraint fk_c7 foreign key(transport_no) references transport(transport_no),
  8  constraint fk_c8 foreign key(orgin_code) references postoffice(office_code),
  9  constraint fk_c9 foreign key(destination_code) references postoffice(office_code));

Table created.

SQL> desc mailbag;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 BAGNUMBER                                 NOT NULL NUMBER(38)
 TRANSPORT_NO                                       NUMBER(38)
 DISPATCH_TIME                                      VARCHAR2(20)
 ORGIN_CODE                                         NUMBER(38)
 DESTINATION_CODE

SQL> create table employee_contactno(
  2  employee_no int,
  3  contact_no int,
  4  constraint fk_c10 foreign key(employee_no) references employee(employee_no),
  5  primary key(employee_no,contact_no));

Table created.

SQL> desc employee_contactno
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 EMPLOYEE_NO                               NOT NULL NUMBER(38)
 CONTACT_NO                                NOT NULL NUMBER(38)
