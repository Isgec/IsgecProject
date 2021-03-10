//////////////////////issue no 7424/////////////////

ALTER TABLE PREFERRENCES ADD @P_GEN_RCT_NO VARCHAR(5);


//////////////////////////////////end of issue no 7424////////////////


/////////////////////ADD BY deepika 15/05/2012 for issue no. 7525///////////////

ALTER TABLE login ADD HR_CODE varchar(6)
ALTER TABLE login ADD ACC_CODE varchar(10)

/////////////////////////////////////////////////////////////////////////////

/*************************prachi 14-may 6589****************************/
alter table cir_branch_return_hdr add PACKET_SIZE numeric(5,0)
/*************************prachi 14-may 6589****************************/

/**************************prachi 15-may 7402*****************************************************/

alter table CIR_BANK_GUARANTEE add BG_ATTACH VARCHAR(200)
alter table CIR_BANK_GUARANTEE_DIS add BG_ATTACH VARCHAR(200)
alter table  CIR_WASTE_CATG_MAST add STATUS varchar(1)
alter table cir_supply add WASTE_CATG_CODE varchar(10)
/**************************prachi 15-may 7402*****************************************************/
/////////////////add by vivek issue no 4821  22/05/2012//////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[CIR_INSTALLMENT_DET](
	[COMP_CODE] [varchar](10) NOT NULL,
	[UNIT_CODE] [varchar](10) NOT NULL,
	[INST_CODE] [varchar](10) NOT NULL,
	[AGCD] [varchar](10) NOT NULL,
	[DPCD] [varchar](10) NOT NULL,
	[INST_NO] [numeric](5, 0) NOT NULL,
	[INST_DUEDT] [datetime] NOT NULL,
	[INST_AMT] [numeric](15, 2) NOT NULL,
	[INST_CHQNO] [varchar](30) NULL,
	[INST_CHQDT] [datetime] NULL,
	[INST_CHQAMT] [numeric](15, 2) NULL,
	[INST_ENDDT] [datetime] NULL,
	[INST_STATUS] [varchar](1) NULL,
	[CREATED_BY] [varchar](30) NULL,
	[CREATED_DT] [datetime] NULL,
	[UPDATED_BY] [varchar](30) NULL,
	[UPDATED_DT] [datetime] NULL,
 CONSTRAINT [CIR_INSTALLMENT_DET_PK] PRIMARY KEY CLUSTERED 
(
	[COMP_CODE] ASC,
	[INST_CODE] ASC,
	[INST_NO] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_INSTALLMENT_DET] ADD  DEFAULT ((1)) FOR [INST_NO]
GO

ALTER TABLE [dbo].[CIR_INSTALLMENT_DET] ADD  DEFAULT (getdate()) FOR [CREATED_DT]
GO

////////////////////////////////////////////End//////////////////////////////////////////////////////////////////

/////////////////////////////add by vivek issue no 4821  22/05/2012///////////////////////////////////////////////

CREATE TABLE [dbo].[CIR_INST_BILL_DET](
	[COMP_CODE] [varchar](10) NOT NULL,
	[UNIT_CODE] [varchar](10) NOT NULL,
	[INST_CODE] [varchar](10) NOT NULL,
	[AGCD] [varchar](10) NOT NULL,
	[DPCD] [varchar](10) NOT NULL,
	[INST_NO] [numeric](5, 0) NOT NULL,
	[INST_BILLNO] [varchar](30) NOT NULL,
	[INST_BILLDT] [datetime] NULL,
	[INST_DUE_AMT] [numeric](15, 2) NULL,
	[PUBL_CODE] [varchar](10) NULL,
	[CREATED_BY] [varchar](30) NULL,
	[CREATED_DT] [datetime] NULL,
	[UPDATED_BY] [varchar](30) NULL,
	[UPDATED_DT] [datetime] NULL,
	[DOCTYPE] [varchar](3) NULL,
	[RECPTNO] [varchar](20) NULL,
	[RECPTDT] [datetime] NULL,
 CONSTRAINT [CIR_INST_BILL_DET_PK] PRIMARY KEY CLUSTERED 
(
	[COMP_CODE] ASC,
	[INST_CODE] ASC,
	[INST_NO] ASC,
	[INST_BILLNO] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_INST_BILL_DET]  WITH CHECK ADD  CONSTRAINT [CIR_INST_BILL_DET_FK] FOREIGN KEY([COMP_CODE], [INST_CODE], [INST_NO])
REFERENCES [dbo].[CIR_INSTALLMENT_DET] ([COMP_CODE], [INST_CODE], [INST_NO])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[CIR_INST_BILL_DET] CHECK CONSTRAINT [CIR_INST_BILL_DET_FK]
GO

ALTER TABLE [dbo].[CIR_INST_BILL_DET] ADD  DEFAULT ((1)) FOR [INST_NO]
GO

ALTER TABLE [dbo].[CIR_INST_BILL_DET] ADD  DEFAULT (getdate()) FOR [CREATED_DT]
GO


/////////////////////////////end by vivek///////////////////////////////////////////////////////////

/////////////////////////////send by sumit dhama issue nom-4111///////////////////////////////////////////////////////////

CREATE TABLE CIR_RR_DETAIL
( COMP_CODE VARCHAR(8) NOT NULL,
UNIT_CODE VARCHAR(8) NOT NULL,
EDTN_CODE VARCHAR(3) NOT NULL,
AGCD VARCHAR(8) NOT NULL,
DPCD VARCHAR(8) NOT NULL,
SUPDATE DATETIME NOT NULL,
RR_NO VARCHAR(8),
RR_DATE DATETIME,
RR_AMT NUMERIC(12,2),
CREATED_BY VARCHAR(30),
CREATED_DT DATETIME DEFAULT GETDATE(),
UPDATED_BY VARCHAR(30),
UPDATED_DT DATETIME,
CONSTRAINT CIR_RR_DETAIL_PK
PRIMARY KEY (COMP_CODE, UNIT_CODE, EDTN_CODE, AGCD, DPCD, SUPDATE))

/////////////////////////////end issue nom-4111///////////////////////////////////////////////////////////




//===========================add by deepika  Issue no. 7535, 6821, 7005////////////////////////////////////////

CREATE TABLE [dbo].[CIR_OUTMAST_PROV](
	[COMP_CODE] [varchar](8) NULL,
	[UNIT_CODE] [varchar](8) NOT NULL,
	[AGCD] [varchar](8) NOT NULL,
	[DPCD] [varchar](8) NULL,
	[DOCTYP] [varchar](3) NOT NULL,
	[BILLNO] [varchar](20) NULL,
	[BILLDT] [datetime] NULL,
	[RECPTNO] [varchar](20) NULL,
	[RECPTDT] [datetime] NULL,
	[ACHD] [varchar](4) NULL,
	[PUBL] [varchar](3) NULL,
	[CHNO] [varchar](30) NULL,
	[CHBNK] [varchar](40) NULL,
	[CHDT] [datetime] NULL,
	[AMOUNT] [numeric](14, 2) NULL,
	[REASON] [varchar](200) NULL,
	[REMARK] [varchar](300) NULL,
	[VOUCHERNO] [varchar](20) NOT NULL,
	[VOUCHERDT] [datetime] NULL,
	[BALANCE] [numeric](14, 2) NULL,
	[TDS] [numeric](14, 2) NULL,
	[STAX] [numeric](14, 2) NULL,
	[STATUS] [varchar](1) NULL,
	[CANCEL_USERID] [varchar](30) NULL,
	[CANCEL_DT] [datetime] NULL,
	[CANCEL_REMARK] [varchar](200) NULL,
	[USRID] [varchar](10) NULL,
	[CREATION_DATE] [datetime] NULL,
	[BILL_SEC_AMT] [numeric](10, 2) NULL,
	[BRANCH_CODE] [varchar](8) NULL,
	[bkup_sno] [int] NULL,
	[temp_id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[DISPUTE_FLAG] [varchar](1) NULL,
	[DISPUTE_USER_CODE] [varchar](30) NULL,
	[DISPUTE_DT] [datetime] NULL,
	[DISPUTE_RMRK] [varchar](100) NULL
) ON [PRIMARY]



ALTER TABLE [dbo].[CIR_OUTMAST_PROV]  WITH CHECK ADD  CONSTRAINT [CIR_RCPHDR_PROV_OUTMAST_FK] 
FOREIGN KEY([COMP_CODE], [UNIT_CODE], [DOCTYP], [RECPTNO])
REFERENCES [dbo].[CIR_RCPHDR_PROV] ([COMP_CODE], [UNIT_CODE], [DOCTYPE], [RECPTNO])
ON DELETE CASCADE


ALTER TABLE [dbo].[CIR_OUTMAST_PROV] CHECK CONSTRAINT [CIR_RCPHDR_PROV_OUTMAST_FK]


ALTER TABLE [dbo].[CIR_OUTMAST_PROV] ADD  DEFAULT ('NM') FOR [ACHD]


ALTER TABLE [dbo].[CIR_OUTMAST_PROV] ADD  DEFAULT ((0)) FOR [AMOUNT]

ALTER TABLE [dbo].[CIR_OUTMAST_PROV] ADD  DEFAULT ((0)) FOR [BALANCE]


ALTER TABLE [dbo].[CIR_OUTMAST_PROV] ADD  DEFAULT ((0)) FOR [TDS]


ALTER TABLE [dbo].[CIR_OUTMAST_PROV] ADD  DEFAULT (getdate()) FOR [CREATION_DATE]


alter table CIR_RCPHDR_PROV add MANNUALRECPTNO  varchar(200)
alter table CIR_RCPHDR_PROV add REMARK_OTH  varchar(200)
alter table CIR_RCPHDR add MANNUALRECPTNO  varchar(200)
alter table CIR_RCPHDR_TEMP add MANNUALRECPTNO  varchar(200)

alter table CIR_RCPHDR_DIS add MANNUALRECPTNO  varchar(200)
alter table CIR_RCPHDR_DIS_TEMP add MANNUALRECPTNO  varchar(200)

 alter table cir_rcphdr_prov add FLAG VARCHAR(200)
