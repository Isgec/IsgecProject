//===========================add by deepika for Issue no. 7535, 6821, 7005////////////////////////////////////////

CREATE TABLE CIR_OUTMAST_PROV
(
  COMP_CODE          VARCHAR2(8 BYTE),
  UNIT_CODE          VARCHAR2(8 BYTE)           NOT NULL,
  AGCD               VARCHAR2(8 BYTE)           NOT NULL,
  DPCD               VARCHAR2(8 BYTE),
  DOCTYP             VARCHAR2(3 BYTE)           NOT NULL,
  BILLNO             VARCHAR2(20 BYTE),
  BILLDT             DATE,
  RECPTNO            VARCHAR2(20 BYTE),
  RECPTDT            DATE,
  ACHD               VARCHAR2(4 BYTE)           DEFAULT 'NM',
  PUBL               VARCHAR2(3 BYTE),
  CHNO               VARCHAR2(30 BYTE),
  CHBNK              VARCHAR2(40 BYTE),
  CHDT               DATE,
  AMOUNT             NUMBER(14,2)               DEFAULT 0,
  REASON             VARCHAR2(200 BYTE),
  REMARK             VARCHAR2(300 BYTE),
  VOUCHERNO          VARCHAR2(20 BYTE)          NOT NULL,
  VOUCHERDT          DATE,
  BALANCE            NUMBER(14,2)               DEFAULT 0,
  TDS                NUMBER(14,2)               DEFAULT 0,
  STAX               NUMBER(14,2),
  STATUS             VARCHAR2(1 BYTE),
  CANCEL_USERID      VARCHAR2(30 BYTE),
  CANCEL_DT          DATE,
  CANCEL_REMARK      VARCHAR2(200 BYTE),
  USRID              VARCHAR2(10 BYTE),
  CREATION_DATE      DATE                       DEFAULT SYSDATE,
  BILL_SEC_AMT       NUMBER(10,2),
  BRANCH_CODE        VARCHAR2(8 BYTE),
  BKUP_SNO           NUMBER(30),
  DISPUTE_FLAG       VARCHAR2(1 BYTE),
  DISPUTE_USER_CODE  VARCHAR2(30 BYTE),
  DISPUTE_DT         DATE,
  DISPUTE_RMRK       VARCHAR2(100 BYTE)
)



///////////////

ALTER TABLE CIR_OUTMAST_PROV ADD (
  CONSTRAINT CIR_RCPHDR_PROV_OUTMAST_FK 
 FOREIGN KEY (COMP_CODE, UNIT_CODE, DOCTYP, RECPTNO) 
 
 REFERENCES CIR_RCPHDR_PROV (COMP_CODE,UNIT_CODE,DOCTYPE,RECPTNO)
    ON DELETE CASCADE);





/////////////////////


 alter table cir_rcphdr_prov add FLAG VARCHAR2(200)

alter table CIR_RCPHDR_PROV add MANNUALRECPTNO  varchar2(200)

alter table CIR_RCPHDR_PROV add REMARK_OTH  varchar2(200)

alter table CIR_RCPHDR add MANNUALRECPTNO  varchar2(200)

alter table CIR_RCPHDR_TEMP add MANNUALRECPTNO  varchar2(200)

alter table CIR_RCPHDR_DIS add MANNUALRECPTNO  varchar2(200)

alter table CIR_RCPHDR_DIS_TEMP add MANNUALRECPTNO  varchar2(200)


//////////////////////////////////////////end/////////////////////////////////////////////////////////////////////


////////////////add by Deepika 07/06/2012 sent by Ashok sahani sir///////////////////////


alter table CIR_SUSPEND_TYPE_MAST add block_reason varchar2 (1)

alter table pub_cent_mast add cir_lable_print varchar2 (1)

///////////////////////////////////end/////////////////////////////////////

************************* rikkee garg cir_tax_mast***************************
CREATE TABLE CIR_TAX_MAST
(COMP_CODE      VARCHAR2(8) NOT NULL,
 TAX_TYPE_ID    NUMBER(3)   NOT NULL,
 TAX_ID         NUMBER(5)   NOT NULL,
 VALID_FROM     DATE        NOT NULL,
 TAX_CALC_TYPE  VARCHAR2(1) DEFAULT 'P',
 TAX_RATE       NUMBER(12,3) NOT NULL,
 TAX_STATUS     VARCHAR2(1) DEFAULT 'Y',
 CREATED_BY     VARCHAR2(30),
 CREATED_DT     DATE    DEFAULT SYSDATE,
 UPDATED_BY     VARCHAR2(30),
 UPDATED_DT     DATE,
 CONSTRAINT CIR_TAX_MAST_PK PRIMARY KEY (TAX_ID))
 
ALTER TABLE PREFERRENCES ADD CIR_VAT_ALLOW VARCHAR2(1) DEFAULT 'N'

ALTER TABLE CIR_BILL ADD (TAX_RATE   NUMBER(12,4) DEFAULT 0,TAX_AMT  NUMBER(12,2) DEFAULT 0,ACCAGCD    VARCHAR2(8),    ACCDPCD    VARCHAR2(8))

ALTER TABLE CIR_BILL_DET ADD (ACCAGCD    VARCHAR2(8),ACCDPCD	VARCHAR2(8))

*************************************end*********************************************
*********************rikkee garg***************************************

ALTER TABLE CIR_BILL ADD TAX_CALC_TYPE VARCHAR(1)

ALTER TABLE CIR_BILL ADD TAX_AMT numeric(12, 2)

ALTER TABLE CIR_BILL ADD ACCAGCD varchar(8)

ALTER TABLE CIR_BILL ADD ACCDPCD varchar(8)

ALTER TABLE CIR_BILL ADD ACCDPCD varchar(8)
**************************end********************************************

/////////////////////////////add by Deepika 13/06/2012 sent by Ashok Sahani sir////////////////////////////

alter table fa_acc_mast add DEFAULT_BRANCH varchar2(8)

alter table CIR_PUBL_MAST add IMP_DAYS number(18, 0)


///////////////////////////////////////////////end/////////////////////////////////////////



//////////////////////////////add by Deepik 29/06/2012///////////////



alter table preferrences add CIR_SUP_ORDER_DEC_LIMIT int 


ALTER TABLE preferrences ADD CIR_SUP_ALT_ROUTE varchar2(1) DEFAULT 'Y'

ALTER TABLE preferrences ADD SHOW_REC_ALL_AGENCY varchar2(1) DEFAULT 'Y'



////////////////////////////////end//////////////////////////////





