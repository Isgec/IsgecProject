////////////////////add by Deepika 07/06/2012 sent by Ashok Sahani sir///////

alter table CIR_SUSPEND_TYPE_MAST add block_reason varchar (1)

alter table pub_cent_mast add cir_lable_print varchar (1)

////////////////////////////////end///////////////////////////////

****************************** Rikkee Garg 9/6/12 **********************

ALTER TABLE CIR_BILL ADD TAX_CALC_TYPE VARCHAR(1)

ALTER TABLE CIR_BILL ADD TAX_AMT numeric(12, 2)

ALTER TABLE CIR_BILL ADD ACCAGCD varchar(8)

ALTER TABLE CIR_BILL ADD ACCDPCD varchar(8)

ALTER TABLE CIR_BILL ADD ACCDPCD varchar(8)


********************end****************************************************

*************************** rikkee garg cir_tax_mast******************************

CREATE TABLE CIR_TAX_MAST
(COMP_CODE      VARCHAR(8)	NOT NULL,
 TAX_TYPE_ID    NUMERIC(3)   NOT NULL,
 TAX_ID         NUMERIC(5)   NOT NULL,
 VALID_FROM     DATETIME        NOT NULL,
 TAX_CALC_TYPE  VARCHAR(1) DEFAULT 'P',
 TAX_RATE       NUMERIC(12,3) NOT NULL,
 TAX_STATUS     VARCHAR(1) DEFAULT 'Y',
 CREATED_BY     VARCHAR(30),
 CREATED_DT     DATETIME    DEFAULT GETDATE(),
 UPDATED_BY     VARCHAR(30),
 UPDATED_DT     DATETIME,
 CONSTRAINT CIR_TAX_MAST_PK PRIMARY KEY (TAX_ID))
 
ALTER TABLE PREFERRENCES ADD CIR_VAT_ALLOW VARCHAR(1) DEFAULT 'N'

ALTER TABLE CIR_BILL ADD TAX_RATE   NUMERIC(12,4) DEFAULT 0,TAX_AMT  NUMERIC(12,2) DEFAULT 0,ACCAGCD    VARCHAR(8),ACCDPCD	VARCHAR(8)

ALTER TABLE CIR_BILL_DET ADD ACCAGCD    VARCHAR(8),ACCDPCD	VARCHAR(8)
*****************************end***********************************



/////////////////////////////add by Deepika 13/06/2012 sent by Ashok Sahani sir////////////////////////////


alter table CIR_PUBL_MAST add IMP_DAYS numeric(18, 0)
alter table fa_acc_mast add DEFAULT_BRANCH varchar(8)


///////////////////////////////////////////////////////end/////////////////////////////
********************Rikkee Garg issue 7425 --27/6/12********************

alter table cir_bill add TAX_RATE numeric(12, 4)

alter table preferrences add CIR_VAT_ALLOW varchar(1)

alter table cir_bill add TAX_AMT numeric(12, 4)

alter table cir_bill add ACCAGCD varchar(8)

alter table cir_bill add ACCDPCD varchar(8)

alter table cir_bill add TAX_CALC_TYPE varchar(1)

*********************end of issue 7425************************************



////////////////////////////Deepika 27/06/2012////////////////////////////

ALTER TABLE preferrences ADD CIR_SUP_ALT_ROUTE varchar(1) DEFAULT 'Y'

ALTER TABLE preferrences ADD SHOW_REC_ALL_AGENCY varchar(1) DEFAULT 'Y'

UPDATE  preferrences SET CIR_SUP_ALT_ROUTE ='Y'

UPDATE  preferrences SET SHOW_REC_ALL_AGENCY ='Y'

alter table preferrences add CIR_SUP_ORDER_DEC_LIMIT int

///////////////////end/////////////////////////////////////////////////