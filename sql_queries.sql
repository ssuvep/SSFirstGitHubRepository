-- @9:24 AM here is my 2nd change without committing earlier changes 

-- My changes were discarded from GITHUB
-- Let me insert changes here now - 7/31/16 9:22 AM EST
CREATE COLUMN TABLE "HANA_TRAINING"."T_ORDER_DETAILS" ("OID" BIGINT CS_FIXED,
	 "PID" BIGINT CS_FIXED,
	 "CUSTID" VARCHAR(5),
	 "QTY" SMALLINT CS_INT,
	 PRIMARY KEY ("OID")) 
	 
select * from CSC_STAGING.CG1_OE_ORDER_LINES_EXT

select * from m_tables where table_name like ('CG1_OE_ORDER%');
create schema HANA_TRAINING owned by SYSTEM;


-------------------------------------------------------------------------------------------------------------------------------------------------
set schema csc_landing

CREATE PROCEDURE P_SAMPLE_DAY1(AGE INT IN,ELIGIBLE VARCHAR(20) OUT)
AS
LANGUAGE SQL SCRIPT
SECURITY INVOKER
READS SQL DATA

OTS_OUTPUT_DATA

select length(party_name) from ots_output_data where length(party_name) > 100
-------------------------------------------------------------------------------------------------------------------------------------------------
						                      TRAINING
-------------------------------------------------------------------------------------------------------------------------------------------------

CREATE COLUMN TABLE HANA_TRAinING."T_CUST_DETAILS" ("CUSTID" VARCHAR(5),
	 "CNAME" VARCHAR(20),
	 "COUNTRY" VARCHAR(10),
	 PRIMARY KEY ("CUSTID"));
	 
CREATE COLUMN TABLE "HANA_TRAINING"."T_ORDER_DETAILS" ("OID" BIGINT CS_FIXED,
	 "PID" BIGINT CS_FIXED,
	 "CUSTID" VARCHAR(5),
	 "QTY" SMALLINT CS_INT,
	 PRIMARY KEY ("OID"))	;
	 
CREATE COLUMN TABLE "HANA_TRAINING"."T_PRODUCT_DETAILS" ("PID" INTEGER ,
	 "NAME" VARCHAR(30),
	 "DESCRIPTION" VARCHAR(40),
	 "PRICE" INTEGER CS_INT,
	 PRIMARY KEY ("PID"))	  ;
	
	SELECT * FROM HANA_TRAINING.T_ORDER_DETAILS;
	
	
	INSERT INTO HANA_TRAINING.T_CUST_DETAILS VALUES('C001','SRIVATSAN','INDIA') ;
	INSERT INTO HANA_TRAINING.T_CUST_DETAILS VALUES('C002','VIGNESH','U.S') ;
	INSERT INTO HANA_TRAINING.T_CUST_DETAILS VALUES('C003','PRASAD','GERMANY'); 
			
	INSERT INTO HANA_TRAINING.T_ORDER_DETAILS VALUES(1001,3001,'C001',10) ;
	INSERT INTO HANA_TRAINING.T_ORDER_DETAILS VALUES(1002,3002,'C002',5) ;
	
	INSERT INTO HANA_TRAINING.T_PRODUCT_DETAILS VALUES(3001,'MOUSE','INPUT',300) ;
	INSERT INTO HANA_TRAINING.T_PRODUCT_DETAILS VALUES(3002,'MOTOG','MOBILE',12000) ;
		
				

NAME MARKS ADDRESS AGE
X     23    ABC     23
y     33    abc     23
z     32    XYZ     43

rOW sTORE:
x 23 abc 23
y 33 abc 23
n  22 ee  33
z 32 xyz 43

Column store:
x y z  n
23 33 32 22
abc abc xyz ee 
23 23 43 33

READ / WRITE : 
DELTA MERGE ..

selec a,b from table1;

SELECT 999 ,'AB'  FROM DUMMY;

------------------------------------------------------------------------------------------------------------------------------------------------------
            --                            TABLE TYPE  
------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TYPE TT_PRODUCTS AS TABLE ( PRODUCT_ID BIGINT , PRODUCT_NAME VARCHAR(40));
DROP TYPE HANA_TRAINING.TT_PRODUCTS;

CREATE PROCEDURE HANA_TRAINING.ABC (OUT X "HANA_TRAINING"."TT_PRODUCTS")
AS
BEGIN

X = SELECT 999 AS PRODUCT_ID,'AB' AS PRODUCT_NAME FROM DUMMY;

END;

CALL ABC(X => ?) --Named parameter call
CALL ABC(?);

---------------------------------------------------------------
drop type mytab_t;

create type mytab_t as table (column1 int);

drop table mytab;
create table mytab (column1 int);
insert into mytab values (0);
insert into mytab values (1);
insert into mytab values (2);

SELECT * FROM MYTAB;
select column1 from :intab where column1 > :i;
SELECT COLUMN1 FROM MYTAB WHERE COLUMN1 > 0;

drop procedure myproc;
create procedure myproc (in intab mytab_t,in i int, out outtab mytab_t) as
begin
outtab = select column1 from :intab where column1 > :i;
end;

call myproc(intab=>mytab, i=>1, outtab =>?);


create schema HANA_TRAINING owned by SYSTEM;

------------------------------------------------------------------------------------------------------------------------------------------------------
  --                                         RESULT VIEW
------------------------------------------------------------------------------------------------------------------------------------------------------


Create type TT_CUSTOMER as table 
("CUSTID" VARCHAR(5),
	 "CNAME" VARCHAR(20),
	 "COUNTRY" VARCHAR(10));
	 

DROP PROCEDURE CUSTPROCVIEW_1
CREATE PROCEDURE CUSTPROCVIEW_1 (IN id VARCHAR(5), OUT o1 TT_CUSTOMER) 
LANGUAGE SQLSCRIPT READS SQL DATA WITH RESULT VIEW CUSTPROCVIEW
AS BEGIN 
o1 = SELECT * FROM T_CUST_DETAILS WHERE CUSTID = :id;
 END;
 
 SELECT * FROM T_CUST_DETAILS
 
CALL CUSTPROCVIEW_1 ('C001',?)
--You call this procedure from an SQL statement as follows.
SELECT * FROM CUSTPROCVIEW (PLACEHOLDER."$$id$$"=>'C001');


------------------------------------------------------------------------------------------------------------------------------------------------------
            --                           WITH OVERVIEW (direct the result set to a table)
------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM MYTAB
        
create table mytab1  as (select * from mytab where 1=2)  ;
select * from mytab1  ;
delete from mytab1  
                                             
call myproc(intab=>mytab, i=>1, outtab => mytab1) with overview;


IF <COND> THEN
<BODY_true>
ELSE
<body_false>
END IF;

SELECT * FROM MYTAB;
CREATE PROCEDURE CASE_EXAMPLE
AS
BEGIN
SELECT COLUMN1,
		 (CASE WHEN COLUMN1 > 0 THEN
		 		'CATEGORYA'
		 		ELSE
		 		 'CATEGORYB'
		 		 END) AS CASE_COLUMN
		 FROM MYTAB;
END;

CALL CASE_EXAMPLE

------------------------------------------------------------------------------------------------------------------------------------------------------
  --                                         User defined function
------------------------------------------------------------------------------------------------------------------------------------------------------

DROP FUNCTION SCALE
CREATE FUNCTION scale (val INT) 
RETURNS TABLE (a INT, b INT) 
LANGUAGE SQLSCRIPT
AS BEGIN 
RETURN SELECT 10 AS A, :val * 10 AS b FROM DUMMY; 
END;

--Calling the UDF:

SELECT * FROM scale(10);

SELECT * FROM MYTAB;

------------------------------------------------------------------------------------------------------------------------------------------------------
  --                                         CURSOR
------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM T_CUST_DETAILS;

DROP PROCEDURE CURSOR_PROC;

CREATE PROCEDURE cursor_proc 
LANGUAGE SQLSCRIPT 
AS BEGIN 
DECLARE V_CUSTID VARCHAR(6); 
DECLARE V_COUNTRY VARCHAR(10);
DECLARE V_NAME VARCHAR(20);

DECLARE CURSOR c_cursor1 (V_CID VARCHAR(6)) 
FOR SELECT CUSTID,CNAME,COUNTRY FROM T_CUST_DETAILS 
WHERE CUSTID = :V_CID 
ORDER BY CUSTID;

OPEN c_cursor1('C001'); 

IF c_cursor1::ISCLOSED 
THEN 
SELECT 'WRONG: cursor not open' FROM DUMMY; 
ELSE 
SELECT 'OK: cursor open' FROM DUMMY;
END IF; 

FETCH c_cursor1 INTO V_CUSTID,V_NAME,V_COUNTRY; 

IF c_cursor1::NOTFOUND 
THEN 
SELECT 'WRONG: cursor contains no valid data' FROM DUMMY;
ELSE 
SELECT V_CUSTID,V_NAME,V_COUNTRY FROM DUMMY;
END IF; 

CLOSE c_cursor1;
END;

CALL CURSOR_PROC;	


-- Looping over RESULTSET:

DROP PROCEDURE CURSOR_PROC_LOOP;
CREATE PROCEDURE cursor_proc_loop
LANGUAGE SQLSCRIPT 
AS BEGIN 
--DECLARE V_CUSTID VARCHAR(6); 
/*DECLARE V_COUNTRY VARCHAR(10);
DECLARE V_NAME VARCHAR(20);
*/
DECLARE CURSOR c_cursor1 (V_CID VARCHAR(6)) 
FOR SELECT CUSTID,CNAME,COUNTRY FROM T_CUST_DETAILS 
WHERE CUSTID = :V_CID 
ORDER BY CUSTID;
FOR cur_row as c_cursor1('C001') 
   DO 
      SELECT cur_row.CNAME AS CUSTOMER_NAME from dummy; 
END FOR; 
END;

CALL CURSOR_PROC_LOOP;

------------------------------------------------------------------------------------------------------------------------------------------------------
  --                                         EXEC
------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE TABLE MESSAGE_BOX (MESSAGE VARCHAR(10));

SELECT * FROM MESSAGE_BOX;

DELETE FROM MESSAGE_BOX
DROP PROCEDURE EXEC_SAMPLE;

CREATE PROCEDURE EXEC_SAMPLE()
AS
BEGIN

DECLARE DEL_ID VARCHAR(5);
DEL_ID := 'HELLO';
EXEC 'INSERT INTO message_box VALUES (''' || :DEL_ID || ''')';
END;

CALL EXEC_SAMPLE();

------------------------------------------------------------------------------------------------------------------------------------------------------
  --                                         APPLY_FILTER
------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM SYS.PROCEDURES

CREATE PROCEDURE GET_PROCEDURE_NAME
 (IN filter NVARCHAR(100)) 
AS BEGIN

temp_procedures = APPLY_FILTER(SYS.PROCEDURES,:filter);
SELECT SCHEMA_NAME, PROCEDURE_NAME FROM :temp_procedures;
END;

CALL GET_PROCEDURE_NAME(' SCHEMA_NAME = ''HANA_TRAINING''');


------------------------------------------------------------------------------------------------------------------------------------------------------
  --                                         ARRAYS
------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE ReturnElement (OUT output INT) 
AS BEGIN
 DECLARE id INTEGER ARRAY := ARRAY(1, 2, 3); 
DECLARE n INTEGER := 1; 
output := :id[:n];
END;

call ReturnElement(?) ;

------------------------------------------------------------------------------------------------------------------------------------------------------
  --                                         EXCEPTION HANDLING
------------------------------------------------------------------------------------------------------------------------------------------------------
drop table mytab;
CREATE TABLE MYTAB (I INTEGER PRIMARY KEY); 
drop procedure myproc_ex;
CREATE PROCEDURE MYPROC_ex 
AS 
A INTEGER := 9;
BEGIN 
DECLARE EXIT HANDLER FOR SQL_ERROR_CODE 301 
SELECT ::SQL_ERROR_CODE, ::SQL_ERROR_MESSAGE FROM DUMMY;
 A := A/0;
 INSERT INTO MYTAB VALUES (1); 
INSERT INTO MYTAB VALUES (1); -- expected unique violation error: 301 
-- will not be reached 
END; 

CALL MYPROC_ex; 

--SIGNAL

CREATE TABLE MYTAB (I INTEGER PRIMARY KEY);

CREATE PROCEDURE MYPROC_signal 
AS BEGIN 
DECLARE MYCOND CONDITION FOR SQL_ERROR_CODE 10001;
 DECLARE EXIT HANDLER FOR MYCOND
 SELECT ::SQL_ERROR_CODE, ::SQL_ERROR_MESSAGE FROM DUMMY; 
 
--INSERT INTO MYTAB VALUES (1); 
SIGNAL MYCOND SET MESSAGE_TEXT = 'my error'; 
-- will not be reached
END;

CALL MYPROC_signal; 

--RESIGNAL

DELETE FROM MYTAB;
CREATE TABLE MYTAB (I INTEGER PRIMARY KEY);

CREATE PROCEDURE MYPROC_RESIGNAL
AS BEGIN 
DECLARE MYCOND CONDITION FOR SQL_ERROR_CODE 10001; 
DECLARE EXIT HANDLER FOR MYCOND RESIGNAL; 
INSERT INTO MYTAB VALUES (1); 
SIGNAL MYCOND SET MESSAGE_TEXT = 'my error'; 
-- will not be reached
END;

CALL MYPROC_RESIGNAL;

--RESIGNAL 2
DROP PROCEDURE EXCEP_HAND;

CREATE PROCEDURE EXCEP_HAND
AS
BEGIN

DECLARE A INTEGER := 3;
DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL 
SET MESSAGE_TEXT = '<HANA__EXCEP>'||::SQL_ERROR_MESSAGE||'</HANA__EXCEP>';
A := A/0;
INSERT INTO MYTAB VALUES (1); 
END;

CALL EXCEP_HAND;


------------------------------------------------------------------------------------------------------------------------------------------------------
  --                                         JOINS
------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM T_CUST_DETAILS  ;-- CUSTID , CNAME, COUNTRY
SELECT * FROM T_PRODUCT_DETAILS ; -- PID, NAME , DESCRIPTION, PRICE
SELECT * FROM T_ORDER_DETAILS ; OID,PID,CUSTID,QTY
INSERT INTO T_CUST_DETAILS VALUES ('C009','BHARATH','JAPAN');

-- Inner Join
DROP PROCEDURE P_PRODUCT_JOIN;
CREATE PROCEDURE P_PRODUCT_JOIN
AS
BEGIN

EXPR_1 =    select C.CUSTID AS CUSTOMER_ID,
				   C.CUSTID ||' '|| C.CNAME AS CUSTOMER_CODE,
				   P.NAME AS PRODUCT_NAME,
				   O.QTY AS QUANTITY
			FROM T_CUST_DETAILS C,
				 T_PRODUCT_DETAILS P,
				 T_ORDER_DETAILS O
			WHERE C.CUSTID = O.CUSTID
			AND	  P.PID = O.PID	;  

SELECT * , 'SAMPLE COLUMN' AS ON_THE_FLY
	FROM :EXPR_1;				 

END;
 
CALL P_PRODUCT_JOIN;


--Left outer Join


EXPLAIN PLAN SET STATEMENT_NAME = 'TEST' FOR
select C.CUSTID AS CUSTOMER_ID,
	   C.CUSTID || C.CNAME AS CUSTOMER_CODE,
	   P.NAME AS PRODUCT_NAME,
	   O.QTY AS QUANTITY
FROM T_CUST_DETAILS C 
     LEFT OUTER JOIN
     T_ORDER_DETAILS O ON C.CUSTID = O.CUSTID
     LEFT OUTER JOIN
	 T_PRODUCT_DETAILS P
ON    P.PID = O.PID	;  


SELECT *
 FROM explain_plan_table
 WHERE statement_name = 'TEST';


--
CREATE PROCEDURE SSURVEPA.GENERATE_ORDERS ()
LANGUAGE SQLSCRIPT SQL SECURITY INVOKER
AS
BEGIN
	DECLARE LV_CURRENT_ORDER BIGINT;
	declare lv_i integer;
	DECLARE LT_ORDER_NUMBER TABLE (ORDER_NUMBER int); 
	
	SELECT MAX("Order_Number") into lv_current_order from ssurvepa.orders;


	FOR lv_i IN 1..10  DO
	 lv_current_order := :lv_current_order + 1;
	 --1 
		LT_ORDER_NUMBER = SELECT :LV_CURRENT_ORDER AS ORDER_NUMBER FROM DUMMY ;

--		INSERT INTO :LT_ORDER_NUMBER VALUES (:lv_current_order);

	END FOR;

end;
----
create procedure 
"SSURVEPA"."ODATA_CREATE_METHOD" 
(IN new SSURVEPA.TAB1, OUT error SSURVEPA.TAB2) 
language sqlscript sql security invoker as 
col1 varchar(2);
begin
 select "col1" into col1 from :new; 
	if :col1 <> 'A' then 
		error = select '99' as "col2", 'ER' "col3" from dummy;
	else insert into ssurvepa.tab1 values (:col1, '');
	end if;
 end;
 
 





