---------------------------------------naman-------------------------------
ALTER TABLE cir_edtn_mast ADD PERIOD NUMBER(5)

-------------------------------------naman----------------------------------------








DROP TABLE HT18JULY.CIR_EDITION_ISSUE_DATE CASCADE CONSTRAINTS;

CREATE TABLE HT18JULY.CIR_EDITION_ISSUE_DATE
(
  COMP_CODE          VARCHAR2(8 BYTE),
  PUB_CODE           VARCHAR2(8 BYTE),
  EDITION_CODE       VARCHAR2(8 BYTE),
  FREQUENCY_CODE     VARCHAR2(8 BYTE),
  FIRST_ISSUE        VARCHAR2(8 BYTE),
  SECOND_ISSUE       VARCHAR2(8 BYTE),
  CREATE_USERID      VARCHAR2(8 BYTE),
  CREATION_DATETIME  DATE,
  UPDATE_USERID      VARCHAR2(8 BYTE),
  UPDATE_DATETIME    DATE
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;



-----------------------------------naman----------------------------------------------------




////////////////////////////////deepika send by sahani sir 13/03/2012/////////////////////////////////////////


ALTER
TABLE CIR_AGMAST ADD PAN_NO VARCHAR2 (25)

ALTER
TABLE CIR_AGMAST ADD TAN_NO VARCHAR2 (25)

ALTER
TABLE CIR_AGMAST ADD SER_TAX_NO VARCHAR2 (25) 

////////////////////////////////////////////////////////////////////////////////////////////////////////

//-------------------------------------------Ritu 21 mar----------------//

CREATE TABLE CIR_TAXI_DP_TRANS
( COMP_CODE           VARCHAR2(8),
  UNIT_CODE           VARCHAR2(8),
  TAXI_ID             VARCHAR2(5),
  ROUTE_CODE          VARCHAR2(8),
  SUB_ROUTECODE       VARCHAR2(10),
  SUB_SUBROUTE_CODE   VARCHAR2(10),
  DROP_POINT_CODE     VARCHAR2(10),  
  EXP_ARR_TIME        VARCHAR2(50),
  EXP_DEP_TIME        VARCHAR2(50),
  ARR_TIME            VARCHAR2(5),
  DEP_TIME            VARCHAR2(5),
  ARR_DATE            DATE,
  STOPAGE_TIME        VARCHAR2(5),
  CREATED_DATE        DATE                 DEFAULT SYSDATE,
  CREATED_BY          VARCHAR2(8),
  LAST_UPDATED_BY     VARCHAR2(8),
  LAST_UPDATED_DATE   DATE,
  CONSTRAINT CIR_TAXI_DP_TRANS_PK PRIMARY KEY
 (COMP_CODE, UNIT_CODE,ROUTE_CODE, TAXI_ID,DROP_POINT_CODE,ARR_DATE)) 

//----------------------------------------------------------------//

//-------------------------start------------------------------------//

ALTER TABLE  PREFERRENCES ADD(TAXI_ENTRY_TYPE VARCHAR2(1))

ALTER TABLE  CIR_TAXI_ROUTE ADD(STATUS VARCHAR2(1))

//---------------Add by Ritu------------end----------------------------------//







/////////////////////////issue number6824 update by Garima
        ALTER TABLE
  cir_inct_process_det_temp
MODIFY
   (
   CN_THROUGH varchar2(100) 
   
   )
////////////////////////////////////// update by meenakshi
///////////////////////////////incentive slab master

alter table CIR_INCT_SLAB_HDR
add (RMRK varchar2(200))


////////////////////


///////////////////// UPDATE BY NITISH ///////////////

alter table PREFERRENCES add CIR_BARCODE  VARCHAR2(5)

/////////////////////


===============7178===avinash==11apr2012==============start===========
alter table cir_edtn_mast add(seg_code varchar2(10 ))


===============7178===avinash==11apr2012==============end===========












