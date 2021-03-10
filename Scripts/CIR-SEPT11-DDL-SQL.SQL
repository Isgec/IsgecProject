
/*************  Code sent by Laxman sir on 8/9/2011  issue no.5011,4868,4691,5389********************************/

exec add_col_in_table 'CIR_AGMAST_DIS', 'UPDATED_BY', 'VARCHAR(50)', null
exec add_col_in_table 'cir_bill_print', 'REC_AMT', 'numeric(15,2)', null

exec add_table 'CIR_BILL_RETURN_PRINT','CREATE TABLE CIR_BILL_RETURN_PRINT ( COMP_CODE      VARCHAR(200),  UNIT_CODE      VARCHAR(200),  BRANCH_CODE    VARCHAR(200),  BILLNO         VARCHAR(200),  BILLDT         DATETIME,  PUBL_CODE      VARCHAR(200),  EDTN_CODE      VARCHAR(200),  AGCD           VARCHAR(200),  DPCD           VARCHAR(200),  RECEIPT_DATE   DATETIME,  RETURN_COPY    NUMERIC(10),  SUPPLY_RATE    NUMERIC(10,2),  COMM_RATE      NUMERIC(12,2),  SUR_RATE       NUMERIC(10,2),  GROSS_AMT      NUMERIC(15,2)                   DEFAULT 0,  COMM_AMT       NUMERIC(15,5)                   DEFAULT 0,  SUR_AMT        NUMERIC(15,2)                   DEFAULT 0,  CUR_SESSIONID  NUMERIC(20),  TEMP_ID		 NUMERIC(20) IDENTITY(1,1)) '


exec add_index 'CIR_BILL_RETURN_PRINT_IDX','CREATE INDEX CIR_BILL_RETURN_PRINT_IDX ON CIR_BILL_RETURN_PRINT (CUR_SESSIONID, COMP_CODE, UNIT_CODE, RECEIPT_DATE, AGCD, DPCD)' 


exec add_view 'cir_dbksup_view',
'CREATE VIEW cir_dbksup_view (publ,edt,agcd,dpcd,ag_name,supdate,sup_type_code,sup_ty_name,sup_copy)
AS
   SELECT a.publ, a.edtn, a.agcd, a.dpcd, b.ag_name, a.supdate,
          a.sup_type_code, c.sup_ty_name, a.sup_copy
     FROM cir_dbksup a, cir_agmast b, cir_supply_type_mast c
    WHERE a.comp_code = b.comp_code
      AND a.unit_code = b.unit
      AND a.agcd = b.agcd
      AND a.dpcd = b.dpcd
      AND a.comp_code = c.comp_code
      AND a.sup_type_code = c.sup_ty_code'
      
exec add_table 'CIR_RCPHDR_TEMP',
'CREATE TABLE CIR_RCPHDR_TEMP(
COMP_CODE		varchar(8)  NOT NULL,
UNIT_CODE		varchar(8)	NOT NULL,
DOCTYPE			varchar(3)	NOT NULL,
AGCD			varchar(8)  NULL,
DPCD			varchar(8)  NULL,
RECPTNO			varchar(20) NOT NULL,
RECPTDT			datetime	NOT NULL,
CHNO			varchar(30) NULL,
CHDT			datetime	NULL,
CHBANK			varchar(30) NULL,
AMOUNT			numeric(14, 2) NULL DEFAULT ((0)),
OTH_AMOUNT		numeric(14, 2) NULL,
CCDP			varchar(14) NULL,
CCDS			varchar(10) NULL,
RCDP			varchar(14) NULL,
RCDS			varchar(10) NULL,
OCDP			varchar(14) NULL,
OCDS			varchar(10) NULL,
REASON			varchar(200)NULL,
REMARK			varchar(200)NULL,
ACHD			varchar(3)  NULL DEFAULT (''NM''),
VOUCHERNO		varchar(20) NULL,
VOUCHERDT		datetime	NULL,
VCHTYPE			varchar(8)  NULL,
PUBL			varchar(5)	NULL,
RECEIVED_FROM	varchar(100) NULL,
TDSRATE			numeric(14, 2)	NULL,
TDSAMT			numeric(14, 2)	NULL,
STAXRATE		numeric(14, 2) NULL,
STAXAMT			numeric(14, 2)	NULL,
STATUS			varchar(1)		NULL,
REF_RECPTNO		varchar(20)		NULL,
REF_RECPTDT		datetime		NULL,
REF_AMOUNT		numeric(14, 2)	NULL,
REF_DOCTYPE		varchar(3)		NULL,
CANCEL_USER		varchar(20)		NULL,
CANCEL_DATE		datetime		NULL,
CANCEL_REMARK	varchar(150)	NULL,
USERID			varchar(10)		NULL,
CREATION_DATE	datetime		NULL DEFAULT  getdate(),
BRANCH_CODE		varchar(8)		NULL,
PROV_REC_NO		varchar(50)		NULL,
PROV_REC_DT		datetime		NULL,
bkup_sno		int				NULL,
REMARK_OTH		varchar(200)	NULL,
 CONSTRAINT CIR_RCPHDR_TEMP_PK PRIMARY KEY(COMP_CODE,UNIT_CODE,DOCTYPE,RECPTNO,RECPTDT)
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]'


exec add_table 'CIR_RCPDET_TEMP',
'CREATE TABLE CIR_RCPDET_TEMP(
COMP_CODE	varchar(8)	NULL,
UNIT_CODE	varchar(8)	NOT NULL,
AGCD		varchar(8)	NOT NULL,
DPCD		varchar(8)	NULL,
DOCTYP		varchar(3)	NOT NULL,
BILLNO		varchar(20)	NULL,
BILLDT		datetime	NULL,
RECPTNO		varchar(20) NULL,
RECPTDT		datetime	NULL,
PAYFOR		varchar(10) NULL,
ACHD		varchar(4)	NULL DEFAULT (''NM''),
PUBL		varchar(3)	NULL,
CHNO		varchar(30) NULL,
CHBNK		varchar(40) NULL,
CHDT		datetime	NULL,
AMOUNT		numeric(14, 2)	NULL  DEFAULT 0,
REASON		varchar(200)	NULL,
REMARK		varchar(200)	NULL,
VOUCHERNO	varchar(20)		NOT NULL,
VOUCHERDT	datetime		NULL,
TDS			numeric(14, 2)	NULL DEFAULT 0,
STAX		numeric(14, 2)	NULL DEFAULT 0,
STATUS		varchar(1)		NULL,
USRID		varchar(10)		NULL,
CREATION_DATE	datetime	NULL	DEFAULT getdate(),
BRANCH_CODE		varchar(8)	NULL,
bkup_sno		int			NULL,
temp_id			numeric(18, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]'

exec add_table 'CIR_RCPHDR_DIS_TEMP',
'CREATE TABLE CIR_RCPHDR_DIS_TEMP(
COMP_CODE		varchar(8)  NOT NULL,
UNIT_CODE		varchar(8)	NOT NULL,
DOCTYPE			varchar(3)	NOT NULL,
AGCD			varchar(8)  NULL,
DPCD			varchar(8)  NULL,
RECPTNO			varchar(20) NOT NULL,
RECPTDT			datetime	NOT NULL,
CHNO			varchar(30) NULL,
CHDT			datetime	NULL,
CHBANK			varchar(30) NULL,
AMOUNT			numeric(14, 2) NULL DEFAULT ((0)),
OTH_AMOUNT		numeric(14, 2) NULL,
CCDP			varchar(14) NULL,
CCDS			varchar(10) NULL,
RCDP			varchar(14) NULL,
RCDS			varchar(10) NULL,
OCDP			varchar(14) NULL,
OCDS			varchar(10) NULL,
REASON			varchar(200)NULL,
REMARK			varchar(200)NULL,
ACHD			varchar(3)  NULL DEFAULT (''NM''),
VOUCHERNO		varchar(20) NULL,
VOUCHERDT		datetime	NULL,
VCHTYPE			varchar(8)  NULL,
PUBL			varchar(5)	NULL,
RECEIVED_FROM	varchar(100) NULL,
TDSRATE			numeric(14, 2)	NULL,
TDSAMT			numeric(14, 2)	NULL,
STAXRATE		numeric(14, 2) NULL,
STAXAMT			numeric(14, 2)	NULL,
STATUS			varchar(1)		NULL,
REF_RECPTNO		varchar(20)		NULL,
REF_RECPTDT		datetime		NULL,
REF_AMOUNT		numeric(14, 2)	NULL,
REF_DOCTYPE		varchar(3)		NULL,
CANCEL_USER		varchar(20)		NULL,
CANCEL_DATE		datetime		NULL,
CANCEL_REMARK	varchar(150)	NULL,
USERID			varchar(10)		NULL,
CREATION_DATE	datetime		NULL DEFAULT  getdate(),
BRANCH_CODE		varchar(8)		NULL,
PROV_REC_NO		varchar(50)		NULL,
PROV_REC_DT		datetime		NULL,
bkup_sno		int				NULL,
REMARK_OTH		varchar(200)	NULL,
 CONSTRAINT CIR_RCPHDR_DIS_TEMP_PK PRIMARY KEY(COMP_CODE,UNIT_CODE,DOCTYPE,RECPTNO,RECPTDT)
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]'




exec add_col_in_table 'cir_rcphdr', 'TRF_NOTE_TYPE', 'varchar(1)', 'C'

exec add_col_in_table 'cir_rcphdr_dis', 'REMARK_OTH', 'varchar(200)', null
exec add_col_in_table 'cir_rcphdr_dis', 'TRF_NOTE_TYPE', 'varchar(1)', 'C'
exec add_col_in_table 'cir_rcphdr_temp', 'TRF_NOTE_TYPE', 'varchar(1)', 'C'
exec add_col_in_table 'cir_rcphdr_dis_temp', 'TRF_NOTE_TYPE', 'varchar(1)', 'C'

exec add_table 'CIR_RCPDET_DIS_TEMP',
'CREATE TABLE CIR_RCPDET_DIS_TEMP(
COMP_CODE	varchar(8)	NULL,
UNIT_CODE	varchar(8)	NOT NULL,
AGCD		varchar(8)	NOT NULL,
DPCD		varchar(8)	NULL,
DOCTYP		varchar(3)	NOT NULL,
BILLNO		varchar(20)	NULL,
BILLDT		datetime	NULL,
RECPTNO		varchar(20) NULL,
RECPTDT		datetime	NULL,
PAYFOR		varchar(10) NULL,
ACHD		varchar(4)	NULL DEFAULT (''NM''),
PUBL		varchar(3)	NULL,
CHNO		varchar(30) NULL,
CHBNK		varchar(40) NULL,
CHDT		datetime	NULL,
AMOUNT		numeric(14, 2)	NULL  DEFAULT 0,
REASON		varchar(200)	NULL,
REMARK		varchar(200)	NULL,
VOUCHERNO	varchar(20)		NOT NULL,
VOUCHERDT	datetime		NULL,
TDS			numeric(14, 2)	NULL DEFAULT 0,
STAX		numeric(14, 2)	NULL DEFAULT 0,
STATUS		varchar(1)		NULL,
USRID		varchar(10)		NULL,
CREATION_DATE	datetime	NULL	DEFAULT getdate(),
BRANCH_CODE		varchar(8)	NULL,
bkup_sno		int			NULL,
temp_id			numeric(18, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]'

exec add_table 'CIR_OUTMAST_TEMP',
'CREATE TABLE CIR_OUTMAST_TEMP(
COMP_CODE	varchar(8)	NULL,
UNIT_CODE	varchar(8)	NOT NULL,
AGCD		varchar(8)	NOT NULL,
DPCD		varchar(8)	NULL,
DOCTYP		varchar(3)	NOT NULL,
BILLNO		varchar(20) NULL,
BILLDT		datetime	NULL,
RECPTNO		varchar(20) NULL,
RECPTDT		datetime	NULL,
ACHD		varchar(4)	DEFAULT ''NM'',
PUBL		varchar(3)	NULL,
CHNO		varchar(30) NULL,
CHBNK		varchar(40) NULL,
CHDT		datetime	NULL,
AMOUNT		numeric(14, 2)	NULL DEFAULT 0,
REASON		varchar(200)	NULL,
REMARK		varchar(300)	NULL,
VOUCHERNO	varchar(20)		NOT NULL,
VOUCHERDT	datetime		NULL,
BALANCE		numeric(14, 2)	NULL DEFAULT 0,
TDS			numeric(14, 2)	NULL DEFAULT 0,
STAX		numeric(14, 2)	NULL,
STATUS		varchar(1)		NULL,
CANCEL_USERID varchar(30)	NULL,
CANCEL_DT		datetime	NULL,
CANCEL_REMARK	varchar(200)NULL,
USRID			varchar(10) NULL,
CREATION_DATE	datetime NULL	DEFAULT getdate(),
BILL_SEC_AMT	numeric(10, 2) NULL,
BRANCH_CODE		varchar(8)	NULL,
bkup_sno		int			NULL,
temp_id			numeric(18, 0) IDENTITY(1,1) NOT NULL) ON [PRIMARY]'


exec add_table 'CIR_OUTMAST_DIS_TEMP',
'CREATE TABLE CIR_OUTMAST_DIS_TEMP(
COMP_CODE	varchar(8)	NULL,
UNIT_CODE	varchar(8)	NOT NULL,
AGCD		varchar(8)	NOT NULL,
DPCD		varchar(8)	NULL,
DOCTYP		varchar(3)	NOT NULL,
BILLNO		varchar(20) NULL,
BILLDT		datetime	NULL,
RECPTNO		varchar(20) NULL,
RECPTDT		datetime	NULL,
ACHD		varchar(4)	DEFAULT ''NM'',
PUBL		varchar(3)	NULL,
CHNO		varchar(30) NULL,
CHBNK		varchar(40) NULL,
CHDT		datetime	NULL,
AMOUNT		numeric(14, 2)	NULL DEFAULT 0,
REASON		varchar(200)	NULL,
REMARK		varchar(300)	NULL,
VOUCHERNO	varchar(20)		NOT NULL,
VOUCHERDT	datetime		NULL,
BALANCE		numeric(14, 2)	NULL DEFAULT 0,
TDS			numeric(14, 2)	NULL DEFAULT 0,
STAX		numeric(14, 2)	NULL,
STATUS		varchar(1)		NULL,
CANCEL_USERID varchar(30)	NULL,
CANCEL_DT		datetime	NULL,
CANCEL_REMARK	varchar(200)NULL,
USRID			varchar(10) NULL,
CREATION_DATE	datetime NULL	DEFAULT getdate(),
BILL_SEC_AMT	numeric(10, 2) NULL,
BRANCH_CODE		varchar(8)	NULL,
bkup_sno		int			NULL,
temp_id			numeric(18, 0) IDENTITY(1,1) NOT NULL) ON [PRIMARY]'

/*************  Code sent by Laxman on 8/9/2011 ********************************/
/*********prachi 4848 19/09/2011********/
exec add_table 'CIR_AGENCY_PAYMODE',
'CREATE TABLE CIR_AGENCY_PAYMODE(
	COMP_CODE varchar(10)  NOT NULL,
	UNIT_CODE varchar(10)  NOT NULL,
	AGCD varchar(10)  NOT NULL,
	DPCD varchar(10)  NOT NULL,
	PAYMODE varchar(10)  NOT NULL,
	PAYMODE_ACTIVE varchar(1)  NULL DEFAULT ('Y'),
	CREATED_BY varchar(30)  NULL,
	CREATED_DT datetime NULL DEFAULT (getdate()),
	UPDATED_BY varchar(30)  NULL,
	UPDATED_DT datetime NULL,
	BKUP_SNO numeric(30, 0) NULL,
 CONSTRAINT CIR_AGENCY_PAYMODE_PK PRIMARY KEY CLUSTERED 
(
	COMP_CODE ASC,
	UNIT_CODE ASC,
	AGCD ASC,
	DPCD ASC,
	PAYMODE ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]'

/**********************************prachi 4848 19/09/2011********************/


/************************************issue no 4653 21/9/11***************************/
set ANSI_PADDING on
alter table preferrences add OUTSTANDING_AMT_CRITERIA varchar(5)



/************************************issue no 4653 21/9/11***************************/
/*********prachi 4840****************/

                                                                 
                                             
ALTER PROCEDURE [dbo].[cir_billing_agency_bind_p]
	@pcompcode			VARCHAR(20) ,
	@punit				VARCHAR(20) ,
	@pdateformat		VARCHAR(20) ,
	@pextra1			VARCHAR(4000) ,
	@pextra2			VARCHAR(4000) 
AS 
	If UPPER(@pextra2)='D' Begin
		SELECT cir_agmast_dis.*,
			 DBO.cir_get_area(cir_agmast_dis.comp_code, cir_agmast_dis.area_code) "AREA_NAME",
			 DBO.cir_get_city(cir_agmast_dis.comp_code, cir_agmast_dis.city_code) "CITY_NAME"
		FROM cir_agmast_dis
		WHERE comp_code  = @pcompcode AND	unit  = @punit AND 
			(ag_name  like CAST(@pextra1 AS VARCHAR) + '%' OR @pextra1  is null)
		ORDER BY cir_agmast_dis.ag_name 
	End
	Else Begin
		SELECT cir_agmast.*,
			 DBO.cir_get_area(cir_agmast.comp_code, cir_agmast.area_code) "AREA_NAME",
			 DBO.cir_get_city(cir_agmast.comp_code, cir_agmast.city_code) "CITY_NAME"
		FROM cir_agmast
		WHERE comp_code  = @pcompcode AND	unit  = @punit AND 
			(ag_name  like CAST(@pextra1 AS VARCHAR) + '%' OR @pextra1  is null)
		ORDER BY cir_agmast.ag_name 
end


/***********prachi 4840******************/

/***************prachi 4992 27-sept***************/
alter table CIR_SUPPLY ALTER COLUMN LBL_PRINTNO DECIMAL(10,2)
/************prachi 4992 27-sept *****************/
/*************prachi       5106     30-sept***************/

sp_RENAME 'CIR_GIFT_SUPPLY_MAST.AGECNY_TYPE', 'AGENCY_TYPE' , 'COLUMN' 
/*************prachi       5106     30-sept***************/

/**********************5118***************************
sp_RENAME 'cir_reason_mst.USER_ID1', 'USER_ID' , 'COLUMN' 


exec add_col_in_table 'cir_supply_appr_hdr', 'APPR_FLAG', 'VARCHAR(1)', null

exec add_col_in_table 'cir_supply_appr_hdr', 'BRAN_CODE', 'VARCHAR(1)', null
/**********************5118***************************


/*********prachi for supply subagency flag in agency master  18-oct****************/
ALTER TABLE CIR_AGMAST_DIS ADD SUPPLY_SUBAGENCY VARCHAR(1) DEFAULT 'N'

ALTER TABLE CIR_AGMAST ADD SUPPLY_SUBAGENCY VARCHAR(1) DEFAULT 'N'

alter table cir_agmast_dis add SUSPEND_DATE datetime
alter table cir_agmast_dis add ALert_valid_date datetime
alter table cir_agmast_dis add SUPPLY_SUBAGENCY varchar(1) default 'N'

/*********prachi for supply subagency flag in agency master****************/
****************mimoh 18/oct/2011******start**********0005354******************
USE [abhi]
GO
/****** Object:  Table [dbo].[CIR_RACE_MAST]    Script Date: 10/18/2011 11:55:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CIR_RACE_MAST](
	[RACE_CODE] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RACE_DESC] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CREATED_BY] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CREATED_DT] [datetime] NULL DEFAULT (getdate()),
	[UPDATED_BY] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UPDATED_DT] [datetime] NULL,
 CONSTRAINT [CIR_RACE_MAST_PK] PRIMARY KEY CLUSTERED 
(
	[RACE_CODE] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

****************mimoh 18/oct/2011**********end*******0005354*****************

////////////*************ISSUE NO 0005363 *************************////////////////

USE [abhi]
GO

/****** Object:  Table [dbo].[CIR_HOLIDAY_MAST]    Script Date: 10/20/2011 13:53:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CIR_HOLIDAY_MAST](
	[COMP_CODE] [varchar](8) NOT NULL,
	[UNIT] [varchar](8) NOT NULL,
	[H_PUBL] [varchar](3) NOT NULL,
	[H_NAME] [varchar](100) NULL,
	[H_DATE] [datetime] NOT NULL,
	[USERID] [varchar](10) NULL,
	[CREATION_DATE] [datetime] NULL,
	[FREEZE_FLAG] [varchar](1) NULL,
	[H_MAIN_EDTN] [varchar](3) NULL,
	[H_EDTN] [varchar](3) NULL,
	[DIST_CODE] [varchar](8) NULL,
	[STATE_CODE] [varchar](8) NULL,
 CONSTRAINT [PK_CIR_HOLIDAY_MAST] PRIMARY KEY CLUSTERED 
(
	[COMP_CODE] ASC,
	[UNIT] ASC,
	[H_PUBL] ASC,
	[H_DATE] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_HOLIDAY_MAST] ADD  DEFAULT (getdate()) FOR [CREATION_DATE]
GO

ALTER TABLE [dbo].[CIR_HOLIDAY_MAST] ADD  DEFAULT ('N') FOR [FREEZE_FLAG]
GO

///////************************** END 0005363***************************//////////////////


//////////////////*************ISSUE NO. 0005358 ***********************///////////////////

USE [abhi]
GO

/****** Object:  Table [dbo].[CIR_EXECUTIVE_MAST]    Script Date: 10/20/2011 14:48:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CIR_EXECUTIVE_MAST](
	[COMP_CODE] [varchar](8) NOT NULL,
	[EXECUTIVE_CODE] [varchar](8) NOT NULL,
	[EXECUTIVE_DESC] [varchar](100) NOT NULL,
	[EXEC_DESIGNATION] [varchar](50) NULL,
	[EXEC_ADDR1] [varchar](100) NULL,
	[EXEC_ADDR2] [varchar](100) NULL,
	[AREA_CODE] [varchar](8) NULL,
	[PIN_CODE] [varchar](6) NULL,
	[PHONE_NO1] [varchar](20) NULL,
	[PHONE_NO2] [varchar](20) NULL,
	[MOBILE_NO] [varchar](20) NULL,
	[FAX_NO] [varchar](20) NULL,
	[EMAIL_ID] [varchar](100) NULL,
	[HR_CODE] [varchar](10) NULL,
	[CREATION_DATE] [datetime] NULL,
	[FREEZE_FLAG] [varchar](1) NULL,
	[UNIT_CODE] [varchar](8) NULL,
	[CITY_CODE] [varchar](8) NULL,
	[DIST_CODE] [varchar](8) NULL,
	[STATE_CODE] [varchar](8) NULL,
	[COUNTRY_CODE] [varchar](8) NULL,
	[USERID] [varchar](10) NULL,
	[EXEC_ONAME] [varchar](100) NULL,
	[TALU_CODE] [varchar](8) NULL,
	[DEPT_NAME] [varchar](30) NULL,
 CONSTRAINT [PK_CIR_EXECUTIVE_MAST] PRIMARY KEY CLUSTERED 
(
	[COMP_CODE] ASC,
	[EXECUTIVE_CODE] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_EXECUTIVE_MAST] ADD  DEFAULT (getdate()) FOR [CREATION_DATE]
GO

ALTER TABLE [dbo].[CIR_EXECUTIVE_MAST] ADD  DEFAULT ('N') FOR [FREEZE_FLAG]
GO



//////////////////******************END***/////////////////////////////////////

////////////////////*************ISSUE NO. 0005359 ***********///////////////////////

USE [abhi]
GO

/****** Object:  Table [dbo].[CIR_TRANSPORTER_MAST]    Script Date: 10/20/2011 15:00:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CIR_TRANSPORTER_MAST](
	[COMP_CODE] [varchar](8) NOT NULL,
	[TRANSPORTER_CODE] [varchar](8) NOT NULL,
	[TRANSPORTER_NAME] [varchar](50) NOT NULL,
	[TRANSPORTER_OTH_NAME] [varchar](60) NULL,
	[ADDR1] [varchar](35) NULL,
	[ADDR2] [varchar](35) NULL,
	[CITY_CODE] [varchar](8) NULL,
	[DISTRICT_CODE] [varchar](8) NULL,
	[STATE_CODE] [varchar](8) NULL,
	[PHONE_NO] [varchar](20) NULL,
	[MOBILE_NO] [varchar](20) NULL,
	[FREEZZE_FLAG] [varchar](1) NULL,
	[CREATION_DATE] [datetime] NULL,
	[USERID] [varchar](10) NULL,
	[PINCODE] [int] NULL,
	[PHONE_NO2] [varchar](20) NULL,
	[FAX_NO1] [varchar](20) NULL,
	[FAX_NO2] [varchar](20) NULL,
	[NEW_IC_NO] [varchar](20) NULL,
	[OLD_IC_NO] [varchar](20) NULL,
 CONSTRAINT [PK_CIR_TRANSPORTER_MAST] PRIMARY KEY CLUSTERED 
(
	[COMP_CODE] ASC,
	[TRANSPORTER_CODE] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_TRANSPORTER_MAST] ADD  DEFAULT ('N') FOR [FREEZZE_FLAG]
GO

ALTER TABLE [dbo].[CIR_TRANSPORTER_MAST] ADD  DEFAULT (getdate()) FOR [CREATION_DATE]
GO

///////////////////********************END******************//////////////////

////////////////issue number 4969////////
ALTER TABLE CIR_ROUTE_TAXI_MAST ALTER COLUMN ACT_DIST NUMERIC(5)
///////////////////////////////end/////////////

********************mimoh 24oct2011 **************5364******************start********
USE [abhi]
GO
/****** Object:  Table [dbo].[CIR_OVERDUE_MAST]    Script Date: 10/24/2011 10:22:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CIR_OVERDUE_MAST](
	[COMP_CODE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BILL_CYCLE] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PUBL_CODE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CREDIT_DAYS] [numeric](8, 0) NOT NULL,
	[CREDIT_LIMIT] [numeric](12, 0) NOT NULL,
	[CREATED_BY] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CREATED_DT] [datetime] NULL DEFAULT (getdate()),
	[UPDATED_BY] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UPDATED_DT] [datetime] NULL,
	[BKUP_SNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL,
 CONSTRAINT [CIR_OVERDUE_MAST_PK] PRIMARY KEY CLUSTERED 
(
	[COMP_CODE] ASC,
	[BILL_CYCLE] ASC,
	[PUBL_CODE] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [CIR_OVERDUE_MAST_UK] UNIQUE NONCLUSTERED 
(
	[BKUP_SNO] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

********************mimoh 24oct2011 **************5364******************end***************************************************************

/////////////////////issue no-4676//////////////////
USE [abhi]
GO
/****** Object:  Table [dbo].[CIR_INSTALLMENT_MAST]    Script Date: 10/24/2011 11:19:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CIR_INSTALLMENT_MAST](
	[COMP_CODE] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UNIT_CODE] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[INST_CODE] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[INST_DATE] [datetime] NOT NULL,
	[AGCD] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DPCD] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[INST_STDT] [datetime] NOT NULL,
	[NO_OF_INST] [int] NOT NULL,
	[INST_AMT] [numeric](15, 2) NOT NULL,
	[TOT_INSTAMT] [numeric](15, 2) NOT NULL,
	[INST_FREQ] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PAYMODE] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ACHD] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CREATED_BY] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CREATED_DT] [datetime] NULL DEFAULT (getdate()),
	[UPDATED_BY] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UPDATED_DT] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

//////////////////end issue no- 4676////////////////////////////////////////////////////////////////////////