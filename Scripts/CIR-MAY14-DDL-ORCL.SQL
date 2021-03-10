/*************************prachi 14-may 6589****************************/
alter table cir_branch_return_hdr add PACKET_SIZE  NUMBER(5)
/*************************prachi 14-may 6589****************************/


/**************************prachi 15-may 7402*****************************************************/

alter table CIR_BANK_GUARANTEE add BG_ATTACH VARCHAR2(200)
alter table CIR_BANK_GUARANTEE_DIS add BG_ATTACH VARCHAR2(200)
alter table  CIR_WASTE_CATG_MAST add STATUS varchar2(1)
alter table cir_supply add WASTE_CATG_CODE varchar2(10)
/**************************prachi 15-may 7402*****************************************************/

/////////////////////ADD BY deepika 15/05/2012 for issue no. 7525///////////////

ALTER TABLE login ADD ACC_CODE varchar2(10)
ALTER TABLE login ADD HR_CODE varchar2(6)

////////////////////////////////////////////////end////////////////////////////




//***************************Add By Meenakshi  23/05/2012 for issue no. 7573 **********//

alter table preferrences add PRODUCT_BRAND_REQ  varchar2(1 BYTE) DEFAULT 'N'

alter table preferrences add GEN_RCT_TYP varchar2(5 BYTE)

//***************************End Script******************************************//


//***************************Add By Meenakshi  28/05/2012 for issue no. 5304 **********//

alter table CIR_BILL add BILL_COUNT number(38)

//***************************End Script******************************************//

**************************send sumit dhama issue num:-4111****************



CREATE TABLE CIR_RR_DETAIL
(
  COMP_CODE   VARCHAR2(8 BYTE)                  NOT NULL,
  UNIT_CODE   VARCHAR2(8 BYTE)                  NOT NULL,
  EDTN_CODE   VARCHAR2(3 BYTE)                  NOT NULL,
  AGCD        VARCHAR2(8 BYTE)                  NOT NULL,
  DPCD        VARCHAR2(8 BYTE)                  NOT NULL,
  SUPDATE     DATE                              NOT NULL,
  RR_NO       VARCHAR2(8 BYTE),
  RR_DATE     DATE,
  RR_AMT      NUMBER(12,2),
  CREATED_BY  VARCHAR2(30 BYTE),
  CREATED_DT  DATE                              DEFAULT SYSDATE,
  UPDATED_BY  VARCHAR2(30 BYTE),
  UPDATED_DT  DATE
)



CREATE UNIQUE INDEX CIR_RR_DETAIL_PK ON CIR_RR_DETAIL
(COMP_CODE, UNIT_CODE, EDTN_CODE, AGCD, DPCD, 
SUPDATE)
LOGGING
TABLESPACE PATRIKA
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE CIR_RR_DETAIL ADD (
  CONSTRAINT CIR_RR_DETAIL_PK
 PRIMARY KEY
 (COMP_CODE, UNIT_CODE, EDTN_CODE, AGCD, DPCD, SUPDATE)
    USING INDEX 
    TABLESPACE PATRIKA
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

***********************end issu 41111*****************************************





