////////////////add by Deepika 16/may/2013 sent by Sushil Sir

                                             
CREATE TABLE CIR_INTEREST_BILL_DETAIL
( COMP_CODE     VARCHAR2(20),
  BRAN_CODE     VARCHAR2(20),
  AGCD          VARCHAR2(20),
  DPCD          VARCHAR2(20),
  BILLNO        VARCHAR2(50),
  BILLDT        DATE,
  BILL_OSAMT    NUMBER(18,2),
  BILL_ASON     DATE,
  INTT_RATE     NUMBER(7,2),
  INTT_AMT      NUMBER(18,2),
  POST_FLAG     VARCHAR2(1 BYTE)                DEFAULT 'N',
  CREATED_BY    VARCHAR2(50 BYTE),
  CREATED_DT    DATE            DEFAULT SYSDATE,
  INTT_DAYS     NUMBER(10),
  CREDIT_DAYS   NUMBER(10),
  OVERDUE_DAYS  NUMBER(10),
  INT_DATE      DATE,
  INT_DOC_TYPE  VARCHAR2(25),
  INT_DOC_NO    VARCHAR2(50),
  CONSTRAINT PK_CIR_INTEREST_BILL_DETAIL PRIMARY KEY (COMP_CODE,BILLDT,BILLNO))

//////////////////////////end////////////////////////////////

////////////////////////////////////Add By Deepika 20-may-2013 ///////////////

alter table ad_rcpthdr  add VAT_FLAG_IN_CN VARCHAR2(1) DEFAULT 'N'

alter table ad_rcpthdr  add VAT_CODE VARCHAR2(10)

alter table ad_rcpthdr  add VAT_CDP VARCHAR2(10)

alter table ad_rcpthdr  add VAT_BASE_AMT NUMERIC(10,2)

alter table ad_rcpthdr  add VAT_AMT NUMERIC(10,2)


/////////////////////////////////////////////end//////////////////////////////


alter table cir_rcphdr add SCH_OPT varchar2(6),R_ID varchar2(15)
alter table cir_rcpdet add SCH_OPT varchar2(6),R_ID varchar2(15)
alter table cir_outmast add SCH_OPT varchar2(6),R_ID varchar2(15)


alter table cir_rcphdr_temp add SCH_OPT varchar2(6),R_ID varchar2(15)
alter table cir_rcpdet_temp add SCH_OPT varchar2(6),R_ID varchar2(15)
alter table cir_outmast_temp add SCH_OPT varchar2(6),R_ID varchar2(15)


//////////////////////////////add by Deepika 10/06/2013//////////////////////////////

alter table CIR_RCPHDR ADD VAT_FLAG_IN_CN varchar2(1)
alter table CIR_RCPHDR ADD VAT_CODE       varchar2(10)
alter table CIR_RCPHDR ADD VAT_CDP        varchar2(10)
alter table CIR_RCPHDR ADD VAT_BASE_AMT   number(10, 2)
alter table CIR_RCPHDR ADD VAT_AMT        number(10, 2)
alter table CIR_RCPHDR ADD VAT_PER        number(10, 2)

////////////////////////end///////////////////////////