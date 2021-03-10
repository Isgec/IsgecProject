
///////////////ISSUE NUMNER 6824///////UPDATE BY Garima
USE [abhi]
GO
/****** Object:  Table [dbo].[CIR_INCT_PROCESS_DET_TEMP]    Script Date: 04/05/2012 16:57:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CIR_INCT_PROCESS_DET_TEMP](
	[COMP_CODE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UNIT_CODE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PUBL_CODE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EDTN_CODE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SUP_TYPE_CODE] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FROM_PDATE] [datetime] NULL,
	[TILL_PDATE] [datetime] NULL,
	[AGCD] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DPCD] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TOT_SUPPLY] [numeric](7, 0) NULL CONSTRAINT [DF__CIR_INCT___TOT_S__38A78509]  DEFAULT ((0)),
	[FROM_SUPPLY] [numeric](7, 0) NULL CONSTRAINT [DF__CIR_INCT___FROM___399BA942]  DEFAULT ((0)),
	[TILL_SUPPLY] [numeric](7, 0) NULL CONSTRAINT [DF__CIR_INCT___TILL___3A8FCD7B]  DEFAULT ((0)),
	[INCT_RATE] [numeric](10, 2) NULL CONSTRAINT [DF__CIR_INCT___INCT___3B83F1B4]  DEFAULT ((0)),
	[CALC_TYPE] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__CIR_INCT___CALC___3C7815ED]  DEFAULT ('P'),
	[AMOUNT] [numeric](12, 2) NOT NULL,
	[DOCTYPE] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RECPTDT] [datetime] NOT NULL,
	[RECPTNO] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BILAGCD] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BILDPCD] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CREATED_BY] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CREATED_DATE] [datetime] NULL CONSTRAINT [DF__CIR_INCT___CREAT__3D6C3A26]  DEFAULT (getdate()),
	[UPDATED_BY] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UPDATED_DATE] [dbo].[Date] NULL,
	[TRAN_TYPE] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__CIR_INCT___TRAN___3E605E5F]  DEFAULT ('EXP'),
	[REASON] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EXP_TYPE_CODE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FINAL_PROCESS] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__CIR_INCT___FINAL__46F5A460]  DEFAULT ('N'),
	[SUPPLY_ON_CALC] [numeric](7, 0) NULL,
	[NO_OF_DAYS] [numeric](5, 0) NULL,
	[CN_THROUGH] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sess_id] [numeric](15, 0) NULL,
	[EXP_TYPE_DESC] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[DateOnlyRule]', @objname=N'[dbo].[CIR_INCT_PROCESS_DET_TEMP].[UPDATED_DATE]' , @futureonly='futureonly'///////////////////////////////////////////


------------------------- updated by Nitish-----------------------------

ALTER TABLE PREFERRENCES ADD CIR_WIEGHT_CALC_REQ    VARCHAR(1) 


-----------------/////---------------------------------------------------
///////////////////////////////update by Garima for ///add filter for weight
ALTER TABLE PREFERRENCES ADD CIR_WIEGHT_CALC_REQ    VARCHAR(1) DEFAULT 'N'
ALTER TABLE CIR_DBKSUP ADD PER_COPY_WEIGHT  NUMERIC(15,3)
ALTER TABLE CIR_DBKSUP_DIS ADD PER_COPY_WEIGHT  NUMERIC(15,3)
ALTER TABLE CIR_LBLMAST ADD PER_COPY_WEIGHT  NUMERIC(15,3),PKT_WEIGHT  NUMERIC(15,3)
ALTER TABLE CIR_UNSOLD_DTL ADD PER_COPY_WT  NUMERIC(15,3),UNSOLD_WT  NUMERIC(15,3)

----------------------for Waste wise Category
CREATE TABLE CIR_WASTE_CATG_MAST
(COMP_CODE      VARCHAR(8) ,
 CATG_CODE      INT,
 CATEG_DESC     VARCHAR(20),
 CREATED_BY     VARCHAR(20),
 CREATED_DT     DATETIME    DEFAULT GETDATE(),
 UPDATED_BY     VARCHAR(20),
 UPDATED_DT     DATETIME,
 CONSTRAINT CIR_WASTE_CATG_PK
 PRIMARY KEY (COMP_CODE, CATG_CODE))
 
ALTER TABLE    CIR_SUPPLY  ADD WASTE_CATG_CODE INT
ALTER TABLE    CIR_SUPPLY_dis  ADD WASTE_CATG_CODE INT
ALTER TABLE    CIR_WASTE_RATE_MAST  ADD WASTE_CATG_CODE INT

//------------------------------start 10/04/2012-------------------------------//

create table auto_process_log
(
process_name varchar(500),
frequency varchar(1),
process_dt datetime,
tasq_time varchar(20)
)
--select * from auto_process_parameters
create table auto_process_parameters
(
process_name varchar(500),
comp_code varchar(8),
unit_code varchar(20),
pub_code varchar(20),
edtn_code varchar(20),
pdateformat varchar(10),
creation_dt datetime default getdate()
)

alter table auto_process_parameters add pub_type varchar(20)


//--------------------------------------end---------------------------//

/////start update by garima//////////////////////
///////////////////////////////////////////issue no - 7180 & 7178:
alter table  retainermaster add  cdp varchar(8)
        alter table  retainermaster add  cds varchar(8)
        alter table  cir_edtn_mast add  seg_code varchar(10)


///////////////////////////////////////////////////////end/////////////////////

/////////////////////neha////17-04-2012//////////////////////

alter table cir_reason_mst add DR_CDP VARCHAR(20)
alter table cir_reason_mst add CR_CDP VARCHAR(20)

alter table cir_expenses_type_mast add CR_CDP VARCHAR(20)

exec sp_rename 'cir_expenses_type_mast.exp_acc_cdp'  ,  'DR_CDP'  ,  'COLUMN'
alter table cir_expenses_type_mast drop column exp_acc_cds




////////////////////////////////////Deepika 18/04/2012 sent by Laxman Sir/////////////////////////////////////

ALTER TABLE CIR_DBKSUP ADD WASTE_CATG_CODE NUMERIC(5)

ALTER TABLE CIR_DBKSUP_DIS ADD WASTE_CATG_CODE NUMERIC(5)

ALTER TABLE CIR_DBKSUP_RESALE ADD WASTE_CATG_CODE NUMERIC(5)

alter table CIR_WASTE_CATG_MAST add STATUS varchar(1)


ALTER TABLE CIR_WASTE_RATE_MAST drop CONSTRAINT CIR_WASTE_RATE_PK
DROP INDEX CIR_WASTE_RATE_PK on cir_waste_rate_mast
ALTER TABLE CIR_WASTE_RATE_MAST ADD CONSTRAINT CIR_WASTE_RATE_UK UNIQUE (COMP_CODE, UNIT_CODE, PUBL, EDTN,WASTE_CATG_CODE)


//////////////////////////////////////////////////////end/////////////////////////////////////////////////////////////////

//---------------start 19/04/2012------------------------------------------//

alter table preferrences add  EDITABLE_AGENCY_COMM varchar(1)


alter table preferrences add  EDITABLE_AGENCY_COMM varchar(1)

alter table preferrences add CANCELLATION_CHARGE varchar(1)

alter table preferrences add APPROVAL_WITH varchar(1)

alter table preferrences add TDS_AUTO_CN varchar(1)

alter table preferrences add TDS_AUTO_REASON varchar(10)

alter table preferrences add TDS_DB_CDP varchar(10)

alter table preferrences add TDS_CR_CDP varchar(10)

alter table preferrences add SER_TAX_AUTO_CN varchar(1)

alter table preferrences add SER_TAX_AUTO_REASON varchar(10)

alter table preferrences add SER_TAX_DB_CDP varchar(10)

alter table preferrences add SER_TAX_CR_CDP varchar(10)

alter table preferrences add PKK_AUTO_CN varchar(1)

alter table preferrences add PKK_AUTO_REASON varchar(10)

alter table preferrences add PKK_DB_CDP varchar(10)

alter table preferrences add PKK_CR_CDP varchar(10)

alter table preferrences add BANK_CHG_AUTO_CN varchar(1)

alter table preferrences add BANK_CHG_AUTO_REASON varchar(10)

alter table preferrences add BANK_CHG_DB_CDP varchar(10)


alter table preferrences add BANK_CHG_CR_CDP varchar(10)

//-----------------------------end------------------------------------//

//----------------------------19/04/2012-------start--------------------------//

alter table cir_taxi_dp_trans add exp_stop_time varchar(50)

alter table cir_taxi_dp_trans add dep_date datetime

//-----------------------------------end--------------------------------//


///////////add deepika 21/04/2012 changed by amit dhama sir/////////////////////////////////////////////////

ALTER TABLE CIR_REASON_MST ADD PRIMARY KEY(COMP_CODE,REASON_CODE)


///////////////////////////////////////end/////////////////////////////////////////////////////
************************** issue no. 6377 ******************************
table name-(CIR_PUBL_MAST)
  PUBL[VARCHAR(10)]

******************* END OF ISSUE  6377 **********************

/////////////////////issue number 7332/////////////////////
alter table cir_supply alter column WASTE_CATG_CODE varchar(10)
////////////////////////////////////////////////////////////

////////////////////////////////////////////add by deepika 04/05/2012 sent by Laxman sir////////////////////////

ALTER TABLE dbo.CIR_DBKSUP ADD CONSTRAINT
CIR_DBKSUP_FINAL_SUPPLY_FLAG_DF DEFAULT 'N' FOR FINAL_SUPPLY_FLAG


///////////////////////////////////////////////end//////////////////////////////////////////////////////////



/////////////////////////////////////add by deepika 08/05/2012 sent by amit tomer sir///////////////

alter
table CIR_UNSOLD_RETURN_CONTROL add AG_TYPE varchar(8),AG_CLASS varchar(10)

//////////////////////////////////////////////end////////////////////////////////////////////////////////////////




*********************************************************issue no.-8342 *************************************************

CREATE TABLE [dbo].[cir_taxi_bill_test](
	[comp_code] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[unit_code] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[trans_code] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[taxi_id] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[billno] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[billdt] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[rate_type] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[rate_freq] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[rate_amt] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[created_by] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[tds_rate] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[tds_amt] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bill_amt] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[tot_distance] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[tot_days] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[gross_amt] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[temp_id] [numeric](18, 0) NULL
) ON [PRIMARY]


alter table cir_taxi_bill add BILL_CYCLE varchar(1)

alter table cir_route_taxi_mast add BILL_CYCLE varchar(1)


**********************************************************end************************************************************




***********************naman**************************************************
alter table cir_rate_mast add CURR_CODE VARCHAR(20)
********************NAMAN*******************************************************

