

CREATE TABLE [dbo].[CIR_WASTE_RATE_MAST_LOG](
	[COMP_CODE] [varchar](8) NOT NULL,
	[UNIT_CODE] [varchar](8) NOT NULL,
	[PUBL] [varchar](3) NOT NULL,
	[EDTN] [varchar](3) NOT NULL,
	[MON_RATE] [numeric](10, 4) NULL,
	[TUE_RATE] [numeric](10, 4) NULL,
	[WED_RATE] [numeric](10, 4) NULL,
	[THU_RATE] [numeric](10, 4) NULL,
	[FRI_RATE] [numeric](10, 4) NULL,
	[SAT_RATE] [numeric](10, 4) NULL,
	[SUN_RATE] [numeric](10, 4) NULL,
	[VALID_FROM] [datetime] NULL,
	[FREEZE_FLAG] [varchar](1) NULL,
	[CREATIED_BY] [varchar](10) NULL,
	[CREATIED_DATE] [datetime] NULL,
	[CHANGED_BY] [varchar](10) NULL,
	[CHANGED_DATE] [datetime] NULL,
	[WASTE_CATG_CODE] [int] NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_WASTE_RATE_MAST_LOG] ADD  DEFAULT (getdate()) FOR [CREATIED_DATE]
GO



///////


CREATE TABLE [dbo].[CIR_WASTE_CATG_MAST_log](
	[COMP_CODE] [varchar](8) NOT NULL,
	[CATG_CODE] [int] NOT NULL,
	[CATEG_DESC] [varchar](20) NULL,
	[CREATED_BY] [varchar](20) NULL,
	[CREATED_DT] [datetime] NULL,
	[UPDATED_BY] [varchar](20) NULL,
	[UPDATED_DT] [datetime] NULL,
	[STATUS] [varchar](1) NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_WASTE_CATG_MAST_log] ADD  DEFAULT (getdate()) FOR [CREATED_DT]
GO



///


CREATE TABLE [dbo].[CIR_UNSOLD_HDR_LOG](
	[COMP_CODE] [varchar](8) NOT NULL,
	[UNIT_CODE] [varchar](8) NOT NULL,
	[DOCTYPE] [varchar](8) NOT NULL,
	[RECPTNO] [varchar](20) NOT NULL,
	[RECPTDT] [datetime] NULL,
	[ENTRYDT] [datetime] NULL,
	[AGCD] [varchar](8) NULL,
	[DPCD] [varchar](8) NULL,
	[FRDT] [datetime] NULL,
	[TODT] [datetime] NULL,
	[USERID] [varchar](10) NULL,
	[CREATION_DATE] [datetime] NULL,
	[APP_USERID] [varchar](10) NULL,
	[APP_DT] [datetime] NULL,
	[PUBL] [varchar](3) NULL,
	[EDTN] [varchar](3) NULL,
	[PROCESS_CRNO] [varchar](20) NULL,
	[PROCESS_CRDT] [datetime] NULL,
	[VAR_USERID] [varchar](10) NULL,
	[VAR_DT] [datetime] NULL,
	[SUP_AGCD] [varchar](8) NULL,
	[SUP_DPCD] [varchar](8) NULL,
	[UPDATE_BY] [varchar](30) NULL,
	[UPDATE_DT] [datetime] NULL,
	[BRANCH_TRFNO] [varchar](20) NULL,
	[BRANCH_TRFDT] [datetime] NULL,
	[BRANCH_TRF_USERID] [varchar](20) NULL,
	[REF_DOCTYPE] [varchar](8) NULL,
	[REF_RECPTNO] [varchar](20) NULL,
	[REF_RECPTDT] [datetime] NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



///


CREATE TABLE [dbo].[CIR_UNSOLD_DTL_log](
	[COMP_CODE] [varchar](8) NULL,
	[UNIT_CODE] [varchar](8) NULL,
	[DOCTYPE] [varchar](8) NULL,
	[RECPTNO] [varchar](20) NULL,
	[RECPTDT] [datetime] NULL,
	[ENTRYDT] [datetime] NULL,
	[AGCD] [varchar](8) NULL,
	[DPCD] [varchar](8) NULL,
	[SUPDATE] [datetime] NULL,
	[SHORT_RECPT] [numeric](8, 0) NULL,
	[LATE_RECPT] [numeric](8, 0) NULL,
	[BNR] [numeric](8, 0) NULL,
	[UNSOLD] [numeric](8, 0) NULL,
	[APR_SHORT_RECPT] [numeric](8, 0) NULL,
	[APR_LATE_RECPT] [numeric](8, 0) NULL,
	[APR_BNR] [numeric](8, 0) NULL,
	[APR_UNSOLD] [numeric](8, 0) NULL,
	[USERID] [varchar](10) NULL,
	[CREATION_DATE] [datetime] NULL,
	[COPY_RATE] [numeric](8, 4) NULL,
	[COMM_RATE] [numeric](8, 4) NULL,
	[WASTE_ALW] [varchar](1) NULL,
	[WASTE_RATE] [numeric](8, 4) NULL,
	[COPY_AMT] [decimal](12, 4) NULL,
	[COMM_AMT] [decimal](12, 4) NULL,
	[WASTE_AMT] [numeric](8, 4) NULL,
	[APP_USERID] [varchar](10) NULL,
	[APP_DT] [datetime] NULL,
	[PUBL] [varchar](3) NULL,
	[EDTN] [varchar](3) NULL,
	[SUPPLY_COPY] [numeric](8, 0) NULL,
	[RATE_SUPPLY] [numeric](10, 0) NULL,
	[BRANCH_CODE] [varchar](50) NULL,
	[COMM_CATG_TYPE] [varchar](1) NULL,
	[PROCESS_CRNO] [varchar](20) NULL,
	[PROCESS_CRDT] [datetime] NULL,
	[temp_id] [numeric](18, 0) NULL,
	[RETURN_PER] [numeric](5, 0) NULL,
	[DAMAGE] [numeric](8, 0) NULL,
	[APR_DAMAGE] [numeric](8, 0) NULL,
	[VAR_SHORT_RECPT] [numeric](8, 0) NULL,
	[VAR_LATE_RECPT] [numeric](8, 0) NULL,
	[VAR_BNR] [numeric](8, 0) NULL,
	[VAR_UNSOLD] [numeric](8, 0) NULL,
	[VAR_DAMAGE] [numeric](8, 0) NULL,
	[VAR_USERID] [varchar](10) NULL,
	[VAR_DT] [datetime] NULL,
	[SUP_AGCD] [varchar](8) NULL,
	[SUP_DPCD] [varchar](8) NULL,
	[UPDATE_BY] [varchar](30) NULL,
	[UPDATE_DT] [datetime] NULL,
	[NO_OF_PACKET] [numeric](5, 0) NULL,
	[REF_DOCTYPE] [varchar](8) NULL,
	[REF_RECPTNO] [varchar](20) NULL,
	[REF_RECPTDT] [datetime] NULL,
	[PER_COPY_WT] [numeric](15, 3) NULL,
	[UNSOLD_WT] [numeric](15, 3) NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_UNSOLD_DTL_log] ADD  DEFAULT (getdate()) FOR [CREATION_DATE]
GO

ALTER TABLE [dbo].[CIR_UNSOLD_DTL_log] ADD  DEFAULT ('N') FOR [WASTE_ALW]
GO



///


CREATE TABLE [dbo].[CIR_SUSPEND_TYPE_MAST_LOG](
	[SUSPEND_TYPE_CODE] [varchar](5) NOT NULL,
	[SUSPEND_DESC] [varchar](50) NOT NULL,
	[USERID] [varchar](10) NULL,
	[CREATION_DATE] [datetime] NULL,
	[FREEZE_FLAG] [varchar](1) NULL,
	[COMP_CODE] [varchar](8) NOT NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_SUSPEND_TYPE_MAST_LOG] ADD  DEFAULT (getdate()) FOR [CREATION_DATE]
GO

ALTER TABLE [dbo].[CIR_SUSPEND_TYPE_MAST_LOG] ADD  DEFAULT ('N') FOR [FREEZE_FLAG]
GO



//

CREATE TABLE [dbo].[CIR_SUSPEND_TRAN_LOG](
	[COMP_CODE] [varchar](8) NULL,
	[UNIT] [varchar](8) NULL,
	[AGCD] [varchar](8) NULL,
	[DPCD] [varchar](8) NULL,
	[TRN_DATE] [datetime] NULL,
	[SUSP] [varchar](1) NULL,
	[SUSPTY] [varchar](8) NULL,
	[SUSP_DATE] [datetime] NULL,
	[START_DATE] [datetime] NULL,
	[USERID] [varchar](10) NULL,
	[CREATION_DATE] [datetime] NULL,
	[FREEZE_FLAG] [varchar](1) NULL,
	[temp_id] [numeric](18, 0) NULL,
	[AGENCY_UNBLOCK_TYPE] [varchar](50) NULL,
	[AGENCY_UNBLOCK_APPROVAL] [varchar](1) NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_SUSPEND_TRAN_LOG] ADD  DEFAULT (getdate()) FOR [CREATION_DATE]
GO

ALTER TABLE [dbo].[CIR_SUSPEND_TRAN_LOG] ADD  DEFAULT ('N') FOR [FREEZE_FLAG]
GO



////


CREATE TABLE [dbo].[CIR_SUPPLY_TYPE_MAST_LOG](
	[COMP_CODE] [varchar](8) NOT NULL,
	[SUP_TY_CODE] [varchar](5) NOT NULL,
	[SUP_TY_NAME] [varchar](25) NULL,
	[BILL_PAY] [varchar](1) NULL,
	[COMM_PAY] [varchar](1) NULL,
	[HANDLING_PAY] [varchar](1) NULL,
	[FREEZE_FLAG] [varchar](1) NULL,
	[USERID] [varchar](10) NULL,
	[CREATEN_DATE] [datetime] NULL,
	[SUP_SEQ_NO] [numeric](5, 0) NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_SUPPLY_TYPE_MAST_LOG] ADD  DEFAULT ('N') FOR [FREEZE_FLAG]
GO

ALTER TABLE [dbo].[CIR_SUPPLY_TYPE_MAST_LOG] ADD  DEFAULT (getdate()) FOR [CREATEN_DATE]
GO



////


CREATE TABLE [dbo].[CIR_SUPPLY_LOG](
	[COMP_CODE] [varchar](8) NOT NULL,
	[UNIT] [varchar](8) NOT NULL,
	[AGCD] [varchar](8) NOT NULL,
	[DPCD] [varchar](8) NOT NULL,
	[PUBL] [varchar](3) NOT NULL,
	[EDTN] [varchar](3) NOT NULL,
	[SUPPLY_FLAG] [varchar](1) NULL,
	[SUPPLY_TYPE_CODE] [varchar](5) NOT NULL,
	[BASE_SUPPLY] [numeric](7, 0) NULL,
	[SUPPLY_SUN] [numeric](7, 0) NULL,
	[SUPPLY_MON] [numeric](7, 0) NULL,
	[SUPPLY_TUE] [numeric](7, 0) NULL,
	[SUPPLY_WED] [numeric](7, 0) NULL,
	[SUPPLY_THU] [numeric](7, 0) NULL,
	[SUPPLY_FRI] [numeric](7, 0) NULL,
	[SUPPLY_SAT] [numeric](7, 0) NULL,
	[DEVATION_SUPPLY] [numeric](7, 0) NULL,
	[COMM_FLAG] [varchar](1) NULL,
	[COMM_CODE] [varchar](8) NULL,
	[PACKET_SIZE] [numeric](7, 0) NULL,
	[ROUTE_CODE] [varchar](5) NULL,
	[SUBROUTE_CODE] [varchar](5) NULL,
	[SUB_SUBROUTE_CODE] [varchar](5) NULL,
	[USERID] [varchar](10) NULL,
	[CREATION_DATE] [datetime] NULL,
	[SUPPLY_SPL1] [numeric](7, 0) NULL,
	[SUPPLY_SPL2] [numeric](7, 0) NULL,
	[SURCH_CD] [varchar](5) NULL,
	[SUB_EDTN] [varchar](3) NULL,
	[LBL_PRINTNO] [decimal](10, 2) NULL,
	[UPDATED_BY] [varchar](50) NULL,
	[UPDATED_DT] [datetime] NULL,
	[BILLING_CYCLE] [varchar](1) NULL,
	[INSERTION_FEE] [varchar](1) NULL,
	[WASTE_CATG_CODE] [varchar](10) NULL,
	[SP_SUPPLY_MON1] [numeric](7, 0) NULL,
	[SP_SUPPLY_TUE1] [numeric](7, 0) NULL,
	[SP_SUPPLY_WED1] [numeric](7, 0) NULL,
	[SP_SUPPLY_THU1] [numeric](7, 0) NULL,
	[SP_SUPPLY_FRI1] [numeric](7, 0) NULL,
	[SP_SUPPLY_SAT1] [numeric](7, 0) NULL,
	[SP_SUPPLY_SUN1] [numeric](7, 0) NULL,
	[SP_SUPPLY_MON2] [numeric](7, 0) NULL,
	[SP_SUPPLY_TUE2] [numeric](7, 0) NULL,
	[SP_SUPPLY_WED2] [numeric](7, 0) NULL,
	[SP_SUPPLY_THU2] [numeric](7, 0) NULL,
	[SP_SUPPLY_FRI2] [numeric](7, 0) NULL,
	[SP_SUPPLY_SAT2] [numeric](7, 0) NULL,
	[SP_SUPPLY_SUN2] [numeric](7, 0) NULL,
	[LATE_FEE] [varchar](1) NULL,
	[INCENTIVE] [varchar](1) NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_SUPPLY_LOG] ADD  DEFAULT (getdate()) FOR [CREATION_DATE]
GO

ALTER TABLE [dbo].[CIR_SUPPLY_LOG] ADD  DEFAULT ('M') FOR [BILLING_CYCLE]
GO

ALTER TABLE [dbo].[CIR_SUPPLY_LOG] ADD  DEFAULT ('N') FOR [INSERTION_FEE]
GO



////


CREATE TABLE [dbo].[CIR_ROLE_MAST_LOG](
	[COMP_CODE] [varchar](8) NOT NULL,
	[UNIT_CODE] [varchar](8) NOT NULL,
	[ROLE_CODE] [varchar](8) NOT NULL,
	[ROLE_DESC] [varchar](40) NOT NULL,
	[LEVEL_CODE] [varchar](8) NOT NULL,
	[FREEZE_FLAG] [varchar](1) NULL,
	[CREATION_DATE] [datetime] NULL,
	[USER_ID] [varchar](50) NOT NULL,
	[temp_id] [numeric](18, 0) NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_ROLE_MAST_LOG] ADD  DEFAULT ('N') FOR [FREEZE_FLAG]
GO

ALTER TABLE [dbo].[CIR_ROLE_MAST_LOG] ADD  DEFAULT (getdate()) FOR [CREATION_DATE]
GO



///


CREATE TABLE [dbo].[CIR_RCPHDR_LOG](
	[COMP_CODE] [varchar](8) NOT NULL,
	[UNIT_CODE] [varchar](8) NOT NULL,
	[DOCTYPE] [varchar](3) NOT NULL,
	[AGCD] [varchar](8) NULL,
	[DPCD] [varchar](8) NULL,
	[RECPTNO] [varchar](20) NOT NULL,
	[RECPTDT] [datetime] NOT NULL,
	[CHNO] [varchar](30) NULL,
	[CHDT] [datetime] NULL,
	[CHBANK] [varchar](30) NULL,
	[AMOUNT] [numeric](14, 2) NULL,
	[OTH_AMOUNT] [numeric](14, 2) NULL,
	[CCDP] [varchar](14) NULL,
	[CCDS] [varchar](10) NULL,
	[RCDP] [varchar](14) NULL,
	[RCDS] [varchar](10) NULL,
	[OCDP] [varchar](14) NULL,
	[OCDS] [varchar](10) NULL,
	[REASON] [varchar](200) NULL,
	[REMARK] [varchar](200) NULL,
	[ACHD] [varchar](3) NULL,
	[VOUCHERNO] [varchar](20) NULL,
	[VOUCHERDT] [datetime] NULL,
	[VCHTYPE] [varchar](8) NULL,
	[PUBL] [varchar](5) NULL,
	[RECEIVED_FROM] [varchar](100) NULL,
	[TDSRATE] [numeric](14, 2) NULL,
	[TDSAMT] [numeric](14, 2) NULL,
	[STAXRATE] [numeric](14, 2) NULL,
	[STAXAMT] [numeric](14, 2) NULL,
	[STATUS] [varchar](1) NULL,
	[REF_RECPTNO] [varchar](20) NULL,
	[REF_RECPTDT] [datetime] NULL,
	[REF_AMOUNT] [numeric](14, 2) NULL,
	[REF_DOCTYPE] [varchar](3) NULL,
	[CANCEL_USER] [varchar](20) NULL,
	[CANCEL_DATE] [datetime] NULL,
	[CANCEL_REMARK] [varchar](150) NULL,
	[USERID] [varchar](10) NULL,
	[CREATION_DATE] [datetime] NULL,
	[BRANCH_CODE] [varchar](8) NULL,
	[PROV_REC_NO] [varchar](50) NULL,
	[PROV_REC_DT] [datetime] NULL,
	[bkup_sno] [int] NULL,
	[REMARK_OTH] [varchar](200) NULL,
	[TRF_NOTE_TYPE] [varchar](1) NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



////

CREATE TABLE [dbo].[CIR_RCPDET_LOG](
	[COMP_CODE] [varchar](8) NULL,
	[UNIT_CODE] [varchar](8) NOT NULL,
	[AGCD] [varchar](8) NOT NULL,
	[DPCD] [varchar](8) NULL,
	[DOCTYP] [varchar](3) NOT NULL,
	[BILLNO] [varchar](20) NULL,
	[BILLDT] [datetime] NULL,
	[RECPTNO] [varchar](20) NULL,
	[RECPTDT] [datetime] NULL,
	[PAYFOR] [varchar](10) NULL,
	[ACHD] [varchar](4) NULL,
	[PUBL] [varchar](3) NULL,
	[CHNO] [varchar](30) NULL,
	[CHBNK] [varchar](40) NULL,
	[CHDT] [datetime] NULL,
	[AMOUNT] [numeric](14, 2) NULL,
	[REASON] [varchar](200) NULL,
	[REMARK] [varchar](200) NULL,
	[VOUCHERNO] [varchar](20) NOT NULL,
	[VOUCHERDT] [datetime] NULL,
	[TDS] [numeric](14, 2) NULL,
	[STAX] [numeric](14, 2) NULL,
	[STATUS] [varchar](1) NULL,
	[USRID] [varchar](10) NULL,
	[CREATION_DATE] [datetime] NULL,
	[BRANCH_CODE] [varchar](8) NULL,
	[bkup_sno] [int] NULL,
	[temp_id] [numeric](18, 0) NOT NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



//


CREATE TABLE [dbo].[CIR_RACE_MAST_LOG](
	[RACE_CODE] [varchar](10) NOT NULL,
	[RACE_DESC] [varchar](30) NOT NULL,
	[CREATED_BY] [varchar](30) NULL,
	[CREATED_DT] [datetime] NULL,
	[UPDATED_BY] [varchar](30) NULL,
	[UPDATED_DT] [datetime] NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_RACE_MAST_LOG] ADD  DEFAULT (getdate()) FOR [CREATED_DT]
GO



///


CREATE TABLE [dbo].[CIR_PUBL_MAST_LOG](
	[COMP_CODE] [varchar](8) NOT NULL,
	[PUBL] [varchar](10) NOT NULL,
	[PUBL_NAME] [varchar](50) NOT NULL,
	[PUBL_NAME_OTH_LANG] [varchar](100) NULL,
	[PNICK] [varchar](8) NULL,
	[PERIOD] [numeric](5, 0) NULL,
	[PRO_TYPE] [varchar](3) NULL,
	[DOB] [datetime] NULL,
	[USERID] [varchar](10) NULL,
	[CREATION_DATE] [datetime] NULL,
	[FREEZE_FLAG] [varchar](1) NULL,
	[PUBL_ALERT] [varchar](50) NULL,
	[ACC_CODE] [varchar](20) NULL,
	[PUBL_SEQNO] [numeric](3, 0) NULL,
	[PUBLISHER] [varchar](50) NULL,
	[IMP_DAYS] [numeric](18, 0) NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_PUBL_MAST_LOG] ADD  DEFAULT (getdate()) FOR [CREATION_DATE]
GO

ALTER TABLE [dbo].[CIR_PUBL_MAST_LOG] ADD  DEFAULT ('N') FOR [FREEZE_FLAG]
GO



///


CREATE TABLE [dbo].[CIR_OUTMAST_LOG](
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
	[temp_id] [numeric](18, 0) NULL,
	[DISPUTE_FLAG] [varchar](1) NULL,
	[DISPUTE_USER_CODE] [varchar](30) NULL,
	[DISPUTE_DT] [datetime] NULL,
	[DISPUTE_RMRK] [varchar](100) NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_OUTMAST_LOG] ADD  DEFAULT ('NM') FOR [ACHD]
GO

ALTER TABLE [dbo].[CIR_OUTMAST_LOG] ADD  DEFAULT ((0)) FOR [AMOUNT]
GO

ALTER TABLE [dbo].[CIR_OUTMAST_LOG] ADD  DEFAULT ((0)) FOR [BALANCE]
GO

ALTER TABLE [dbo].[CIR_OUTMAST_LOG] ADD  DEFAULT ((0)) FOR [TDS]
GO

ALTER TABLE [dbo].[CIR_OUTMAST_LOG] ADD  DEFAULT (getdate()) FOR [CREATION_DATE]
GO



///


CREATE TABLE [dbo].[CIR_FESTIVAL_MAST_LOG](
	[FEST_CODE] [numeric](5, 0) NOT NULL,
	[FEST_NAME] [varchar](50) NOT NULL,
	[CREATED_BY] [varchar](30) NULL,
	[CREATED_DT] [datetime] NULL,
	[UPDATED_BY] [varchar](30) NULL,
	[UPDATED_DT] [datetime] NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_FESTIVAL_MAST_LOG] ADD  DEFAULT (getdate()) FOR [CREATED_DT]
GO



///


CREATE TABLE [dbo].[CIR_EXPENSES_TYPE_MAST_LOG](
	[COMP_CODE] [varchar](8) NOT NULL,
	[EXP_TYPE_CODE] [varchar](8) NOT NULL,
	[EXP_TYPE_DESC] [varchar](50) NOT NULL,
	[EXP_TYPE_SIGN] [numeric](2, 0) NULL,
	[EXP_TYPE_MODE] [varchar](1) NULL,
	[EXP_TYPE_CALC_BASE] [varchar](1) NULL,
	[EXP_TYPE_CALC_DATE] [datetime] NULL,
	[DR_CDP] [varchar](50) NULL,
	[USERID] [varchar](10) NULL,
	[FREEZE_FLAG] [varchar](1) NULL,
	[CREATION_DATE] [datetime] NULL,
	[EXP_TYPE_COPY_TYPE] [varchar](1) NULL,
	[EXP_REASON] [varchar](200) NULL,
	[CR_CDP] [varchar](20) NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_EXPENSES_TYPE_MAST_LOG] ADD  DEFAULT ('M') FOR [EXP_TYPE_MODE]
GO

ALTER TABLE [dbo].[CIR_EXPENSES_TYPE_MAST_LOG] ADD  DEFAULT ('N') FOR [FREEZE_FLAG]
GO

ALTER TABLE [dbo].[CIR_EXPENSES_TYPE_MAST_LOG] ADD  DEFAULT (getdate()) FOR [CREATION_DATE]
GO



////


CREATE TABLE [dbo].[CIR_EXECUTIVE_MAST_LOG](
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
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_EXECUTIVE_MAST_LOG] ADD  DEFAULT (getdate()) FOR [CREATION_DATE]
GO

ALTER TABLE [dbo].[CIR_EXECUTIVE_MAST_LOG] ADD  DEFAULT ('N') FOR [FREEZE_FLAG]
GO



///


CREATE TABLE [dbo].[CIR_EDTN_SUPL_MAST_LOG](
	[COMP_CODE] [varchar](8) NOT NULL,
	[UNIT_CODE] [varchar](8) NOT NULL,
	[PUBL_CODE] [varchar](8) NOT NULL,
	[MAIN_EDTN] [varchar](8) NOT NULL,
	[EDTN_CODE] [varchar](8) NOT NULL,
	[SUPL_NAME_SUN] [varchar](100) NOT NULL,
	[SUPL_NAME_MON] [varchar](100) NULL,
	[SUPL_NAME_TUE] [varchar](100) NULL,
	[SUPL_NAME_WED] [varchar](100) NULL,
	[SUPL_NAME_THU] [varchar](100) NULL,
	[SUPL_NAME_FRI] [varchar](100) NULL,
	[SUPL_NAME_SAT] [varchar](100) NULL,
	[VALID_FROM] [datetime] NOT NULL,
	[CREATED_BY] [varchar](30) NULL,
	[CREATED_DATE] [datetime] NULL,
	[UPDATED_BY] [varchar](30) NULL,
	[UPDATED_DATE] [datetime] NULL,
	[BKUP_SNO] [numeric](30, 0) NULL,
	[VALID_TILL] [datetime] NOT NULL,
	[SHOW_ON_PO] [varchar](1) NULL,
	[INSERTION_FEE] [numeric](12, 2) NULL,
	[SUN_ALLOW] [varchar](1) NULL,
	[MON_ALLOW] [varchar](1) NULL,
	[TUE_ALLOW] [varchar](1) NULL,
	[WED_ALLOW] [varchar](1) NULL,
	[THU_ALLOW] [varchar](1) NULL,
	[FRI_ALLOW] [varchar](1) NULL,
	[SAT_ALLOW] [varchar](1) NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_EDTN_SUPL_MAST_LOG] ADD  DEFAULT (getdate()) FOR [CREATED_DATE]
GO

ALTER TABLE [dbo].[CIR_EDTN_SUPL_MAST_LOG] ADD  DEFAULT ('N') FOR [SHOW_ON_PO]
GO

ALTER TABLE [dbo].[CIR_EDTN_SUPL_MAST_LOG] ADD  DEFAULT ('N') FOR [SUN_ALLOW]
GO

ALTER TABLE [dbo].[CIR_EDTN_SUPL_MAST_LOG] ADD  DEFAULT ('N') FOR [MON_ALLOW]
GO

ALTER TABLE [dbo].[CIR_EDTN_SUPL_MAST_LOG] ADD  DEFAULT ('N') FOR [TUE_ALLOW]
GO

ALTER TABLE [dbo].[CIR_EDTN_SUPL_MAST_LOG] ADD  DEFAULT ('N') FOR [WED_ALLOW]
GO

ALTER TABLE [dbo].[CIR_EDTN_SUPL_MAST_LOG] ADD  DEFAULT ('N') FOR [THU_ALLOW]
GO

ALTER TABLE [dbo].[CIR_EDTN_SUPL_MAST_LOG] ADD  DEFAULT ('N') FOR [FRI_ALLOW]
GO

ALTER TABLE [dbo].[CIR_EDTN_SUPL_MAST_LOG] ADD  DEFAULT ('N') FOR [SAT_ALLOW]
GO



///

CREATE TABLE [dbo].[CIR_EDTN_MAST_LOG](
	[COMP_CODE] [varchar](8) NOT NULL,
	[PUBL] [varchar](10) NOT NULL,
	[EDTN] [varchar](3) NOT NULL,
	[EDTN_NAME] [varchar](50) NOT NULL,
	[EDTN_NAME_OTH_LANG] [varchar](100) NULL,
	[EDITION_NICK] [varchar](20) NULL,
	[DOB] [datetime] NULL,
	[PAGE_WT_SUN] [numeric](18, 0) NULL,
	[PAGE_WT_MON] [numeric](18, 0) NULL,
	[PAGE_WT_TUE] [numeric](18, 0) NULL,
	[PAGE_WT_WED] [numeric](18, 0) NULL,
	[PAGE_WT_THU] [numeric](18, 0) NULL,
	[PAGE_WT_FRI] [numeric](18, 0) NULL,
	[PAGE_WT_SAT] [numeric](18, 0) NULL,
	[MAIN_ISSUE_PGNO_SUN] [numeric](18, 0) NULL,
	[MAIN_ISSUE_PGNO_MON] [numeric](18, 0) NULL,
	[MAIN_ISSUE_PGNO_TUE] [numeric](18, 0) NULL,
	[MAIN_ISSUE_PGNO_WED] [numeric](18, 0) NULL,
	[MAIN_ISSUE_PGNO_THU] [numeric](18, 0) NULL,
	[MAIN_ISSUE_PGNO_FRI] [numeric](18, 0) NULL,
	[MAIN_ISSUE_PGNO_SAT] [numeric](18, 0) NULL,
	[MAIN_ISSUE_NAME_SUN] [varchar](50) NULL,
	[MAIN_ISSUE_NAME_MON] [varchar](50) NULL,
	[MAIN_ISSUE_NAME_TUE] [varchar](50) NULL,
	[MAIN_ISSUE_NAME_WED] [varchar](50) NULL,
	[MAIN_ISSUE_NAME_THU] [varchar](50) NULL,
	[MAIN_ISSUE_NAME_FRI] [varchar](50) NULL,
	[MAIN_ISSUE_NAME_SAT] [varchar](50) NULL,
	[PULLOUT_PGNO_SUN] [numeric](18, 0) NULL,
	[PULLOUT_PGNO_MON] [numeric](18, 0) NULL,
	[PULLOUT_PGNO_TUE] [numeric](18, 0) NULL,
	[PULLOUT_PGNO_WED] [numeric](18, 0) NULL,
	[PULLOUT_PGNO_THU] [numeric](18, 0) NULL,
	[PULLOUT_PGNO_FRI] [numeric](18, 0) NULL,
	[PULLOUT_PGNO_SAT] [numeric](18, 0) NULL,
	[USERID] [varchar](10) NULL,
	[CREATION_datetime] [datetime] NULL,
	[FREEZE_FLAG] [varchar](1) NULL,
	[PGNO_SUN] [numeric](18, 0) NULL,
	[PGNO_MON] [numeric](18, 0) NULL,
	[PGNO_TUE] [numeric](18, 0) NULL,
	[PGNO_WED] [numeric](18, 0) NULL,
	[PGNO_THU] [numeric](18, 0) NULL,
	[PGNO_FRI] [numeric](18, 0) NULL,
	[PGNO_SAT] [numeric](18, 0) NULL,
	[EDTN_SEQ_NO] [numeric](18, 0) NULL,
	[EDTN_TY] [varchar](3) NULL,
	[MAIN_EDTN] [varchar](3) NULL,
	[UNIT_CODE] [varchar](8) NULL,
	[PURBILL_COMM_TY] [varchar](8) NULL,
	[PURBILL_COMM] [numeric](12, 2) NULL,
	[DIS_AGCD] [varchar](8) NULL,
	[DIS_DPCD] [varchar](8) NULL,
	[REG_NO] [varchar](20) NULL,
	[PERIOD] [numeric](5, 0) NULL,
	[SEG_CODE] [varchar](10) NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_EDTN_MAST_LOG] ADD  DEFAULT (getdate()) FOR [CREATION_datetime]
GO

ALTER TABLE [dbo].[CIR_EDTN_MAST_LOG] ADD  DEFAULT ('N') FOR [FREEZE_FLAG]
GO



//


CREATE TABLE [dbo].[CIR_DBKSUP_LOG](
	[COMP_CODE] [varchar](8) NOT NULL,
	[UNIT_CODE] [varchar](8) NOT NULL,
	[PUBL] [varchar](3) NOT NULL,
	[EDTN] [varchar](3) NOT NULL,
	[AGCD] [varchar](8) NOT NULL,
	[DPCD] [varchar](8) NOT NULL,
	[SUPDATE] [datetime] NOT NULL,
	[SUP_TYPE_CODE] [varchar](5) NOT NULL,
	[SUP_COPY] [numeric](10, 0) NULL,
	[AGENCY_TY_CODE] [varchar](8) NULL,
	[AGENCY_PKT_SIZE] [numeric](7, 0) NULL,
	[COMM_CODE] [varchar](6) NULL,
	[COMM_FIX_AUTO_SPL] [varchar](1) NULL,
	[SUP_RATE] [numeric](10, 4) NULL,
	[BILLAGCD] [varchar](8) NULL,
	[BILLDPCD] [varchar](8) NULL,
	[ROUTE_CODE] [varchar](5) NULL,
	[SUBROUTE_CODE] [varchar](5) NULL,
	[SUBSUBROUTE_CODE] [varchar](5) NULL,
	[USERID] [varchar](10) NULL,
	[CREATION_DATE] [datetime] NULL,
	[SURCH_CD] [varchar](5) NULL,
	[ISSUE_DATE] [datetime] NULL,
	[RETURN_COPY_SALE] [varchar](1) NULL,
	[FINAL_SUPPLY_FLAG] [varchar](1) NULL,
	[UPDATED_BY] [varchar](30) NULL,
	[UPDATED_DT] [datetime] NULL,
	[PER_COPY_WEIGHT] [numeric](15, 3) NULL,
	[WASTE_CATG_CODE] [varchar](50) NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_DBKSUP_LOG] ADD  DEFAULT (getdate()) FOR [CREATION_DATE]
GO

ALTER TABLE [dbo].[CIR_DBKSUP_LOG] ADD  DEFAULT ('N') FOR [RETURN_COPY_SALE]
GO

ALTER TABLE [dbo].[CIR_DBKSUP_LOG] ADD  DEFAULT ('N') FOR [FINAL_SUPPLY_FLAG]
GO



///


CREATE TABLE [dbo].[CIR_BILL_LOG](
	[COMP_CODE] [varchar](8) NOT NULL,
	[UNIT_CODE] [varchar](8) NOT NULL,
	[BILLNO] [varchar](20) NOT NULL,
	[BILLDT] [datetime] NOT NULL,
	[AGCD] [varchar](8) NOT NULL,
	[DPCD] [varchar](8) NOT NULL,
	[PUBL] [varchar](3) NOT NULL,
	[BILL_COPY] [int] NULL,
	[GROSS_AMOUNT] [decimal](14, 2) NULL,
	[SUR_AMOUNT] [decimal](14, 2) NULL,
	[COMM_AMOUNT] [decimal](14, 2) NULL,
	[BILL_AMOUNT] [decimal](14, 2) NULL,
	[BILL_FRDT] [datetime] NOT NULL,
	[BILL_TODT] [datetime] NOT NULL,
	[BILL_FLAG] [varchar](1) NULL,
	[BILL_REMARK] [varchar](40) NULL,
	[USERID] [varchar](10) NULL,
	[CREATION_DATE] [datetime] NULL,
	[BILL_SEC_AMT] [decimal](10, 2) NULL,
	[EXCOMM_RECPTNO] [varchar](20) NULL,
	[EXCOMM_RECPTDT] [datetime] NULL,
	[EXCOMM_AMT] [decimal](12, 2) NULL,
	[BRANCH_CODE] [varchar](8) NOT NULL,
	[SEC_PER_RATE] [numeric](12, 2) NULL,
	[ROUTE_CODE] [varchar](20) NULL,
	[BILL_COUNT] [numeric](38, 2) NULL,
	[CN_COMM_COPY] [int] NULL,
	[TAX_RATE] [numeric](12, 4) NULL,
	[TAX_AMT] [numeric](12, 2) NULL,
	[ACCAGCD] [varchar](8) NULL,
	[ACCDPCD] [varchar](8) NULL,
	[TAX_CALC_TYPE] [varchar](1) NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_BILL_LOG] ADD  DEFAULT (getdate()) FOR [CREATION_DATE]
GO

ALTER TABLE [dbo].[CIR_BILL_LOG] ADD  DEFAULT ((0)) FOR [TAX_RATE]
GO

ALTER TABLE [dbo].[CIR_BILL_LOG] ADD  DEFAULT ((0)) FOR [TAX_AMT]
GO



//


CREATE TABLE [dbo].[CIR_BILL_DET_LOG](
	[COMP_CODE] [varchar](8) NOT NULL,
	[UNIT_CODE] [varchar](8) NOT NULL,
	[BILLNO] [varchar](20) NOT NULL,
	[BILLDT] [datetime] NOT NULL,
	[AGCD] [varchar](8) NOT NULL,
	[DPCD] [varchar](8) NOT NULL,
	[PUBL] [varchar](3) NOT NULL,
	[EDTN] [varchar](3) NOT NULL,
	[BILL_COPY] [int] NULL,
	[COPY_RATE] [decimal](10, 4) NULL,
	[COMM_FLAG] [varchar](1) NULL,
	[COMM_RATE] [decimal](10, 4) NULL,
	[SUR_RATE] [decimal](10, 4) NULL,
	[GROSS_AMOUNT] [decimal](14, 2) NULL,
	[BILL_AMOUNT] [decimal](14, 2) NULL,
	[FROMDT] [datetime] NULL,
	[TODT] [datetime] NULL,
	[COAG] [varchar](8) NOT NULL,
	[CODP] [varchar](8) NOT NULL,
	[REMARKS] [varchar](40) NULL,
	[USERID] [varchar](10) NULL,
	[CREATION_DATE] [datetime] NULL,
	[COMM_AMT] [decimal](10, 2) NULL,
	[SUR_AMT] [decimal](10, 2) NULL,
	[BILL_FLAG] [varchar](1) NULL,
	[BRANCH_CODE] [varchar](8) NULL,
	[COMM_TYPE] [varchar](1) NULL,
	[temp_id] [numeric](18, 0) NULL,
	[ACCAGCD] [varchar](8) NULL,
	[ACCDPCD] [varchar](8) NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_BILL_DET_LOG] ADD  DEFAULT (getdate()) FOR [CREATION_DATE]
GO



///


CREATE TABLE [dbo].[CIR_BANK_MAST_LOG](
	[COMP_CODE] [varchar](8) NOT NULL,
	[BANKCODE] [varchar](8) NOT NULL,
	[BANKNAME] [varchar](50) NOT NULL,
	[CITY_CODE] [varchar](8) NOT NULL,
	[USERID] [varchar](8) NOT NULL,
	[CREATION_DATETIME] [datetime] NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_BANK_MAST_LOG] ADD  DEFAULT (getdate()) FOR [CREATION_DATETIME]
GO



////


CREATE TABLE [dbo].[CIR_BANK_GUARANTEE_LOG](
	[COMP_CODE] [varchar](8) NOT NULL,
	[UNIT_CODE] [varchar](8) NOT NULL,
	[AGCD] [varchar](8) NOT NULL,
	[DPCD] [varchar](8) NOT NULL,
	[BG_NO] [numeric](8, 0) NOT NULL,
	[BG_AMT] [numeric](12, 2) NULL,
	[BG_DATE] [datetime] NOT NULL,
	[BG_VALID] [datetime] NOT NULL,
	[BANK_DESC] [varchar](50) NOT NULL,
	[CREATED_BY] [varchar](30) NULL,
	[CREATED_DT] [dbo].[Date] NULL,
	[UPDATED_BY] [varchar](30) NULL,
	[UPDATED_DT] [dbo].[Date] NULL,
	[BKUP_SNO] [numeric](30, 0) NULL,
	[BG_TYPE] [varchar](2) NULL,
	[BG_ATTACH] [varchar](200) NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_BANK_GUARANTEE_LOG] ADD  DEFAULT (getdate()) FOR [CREATED_DT]
GO

ALTER TABLE [dbo].[CIR_BANK_GUARANTEE_LOG] ADD  DEFAULT ('BG') FOR [BG_TYPE]
GO



///


CREATE TABLE [dbo].[CIR_AGMAST_LOG](
	[COMP_CODE] [varchar](8) NOT NULL,
	[UNIT] [varchar](8) NOT NULL,
	[AGCD] [varchar](8) NOT NULL,
	[DPCD] [varchar](8) NOT NULL,
	[AG_NAME] [varchar](50) NULL,
	[AG_NAME_OTH_LANG] [varchar](100) NULL,
	[AG_TYPE] [varchar](8) NULL,
	[AG_CLASS] [varchar](10) NULL,
	[EXECUTIVE_CODE] [varchar](8) NULL,
	[SUPPLY_START_DT] [datetime] NULL,
	[ADDR1] [varchar](50) NULL,
	[ADDR2] [varchar](50) NULL,
	[ADDR3] [varchar](50) NULL,
	[CITY_CODE] [varchar](8) NULL,
	[DIST_CODE] [varchar](8) NULL,
	[STATE_CODE] [varchar](8) NULL,
	[COUNTRY_CODE] [varchar](8) NULL,
	[TEHSIL_TALUKA] [varchar](8) NULL,
	[STATION_CODE] [varchar](8) NULL,
	[AREA_CODE] [varchar](8) NULL,
	[PHONE_NO1] [varchar](25) NULL,
	[PHONE_NO2] [varchar](25) NULL,
	[MOBILE_NO1] [numeric](18, 0) NULL,
	[MOBILE_NO2] [numeric](18, 0) NULL,
	[EMAIL_ID] [varchar](50) NULL,
	[SUSPEND] [varchar](1) NULL,
	[SUSPEND_TYPE] [varchar](8) NULL,
	[SUSPEND_DATE] [datetime] NULL,
	[TO_BILL] [varchar](1) NULL,
	[BILL_AGCD] [varchar](8) NULL,
	[BILL_DPCD] [varchar](8) NULL,
	[PAYMODE] [varchar](8) NULL,
	[CREDIT_DAYS] [numeric](7, 0) NULL,
	[PRINT_LABEL] [varchar](1) NULL,
	[PIN_PACKET] [varchar](1) NULL,
	[PIN_AGCD] [varchar](8) NULL,
	[PIN_DPCD] [varchar](8) NULL,
	[PIN_OPEN_INSIDE] [varchar](1) NULL,
	[LBL_LN1] [varchar](35) NULL,
	[LBL_LN2] [varchar](35) NULL,
	[LBL_LN3] [varchar](35) NULL,
	[LBL_LN4] [varchar](35) NULL,
	[LBL_LN5] [varchar](35) NULL,
	[LBL_LN6] [varchar](35) NULL,
	[LBL_LN7] [varchar](35) NULL,
	[LBL_LN8] [varchar](35) NULL,
	[LBL_ATR1] [varchar](35) NULL,
	[LBL_ATR2] [varchar](35) NULL,
	[LBL_ATR3] [varchar](35) NULL,
	[LBL_ATR4] [varchar](35) NULL,
	[LBL_ATR5] [varchar](35) NULL,
	[LBL_ATR6] [varchar](35) NULL,
	[LBL_ATR7] [varchar](35) NULL,
	[LBL_ATR8] [varchar](35) NULL,
	[ALERT_TEXT] [varchar](60) NULL,
	[USERID] [varchar](10) NULL,
	[CREATION_datetime] [datetime] NULL,
	[NAME_ON_LABEL] [varchar](75) NULL,
	[PRINT_SEQ] [numeric](18, 0) NULL,
	[ALERT_VALID_DATE] [datetime] NULL,
	[PIN_CODE] [numeric](18, 0) NULL,
	[FREEZE_FLAG] [varchar](1) NULL,
	[FAX_NO] [varchar](25) NULL,
	[BRANCH_CODE] [varchar](8) NULL,
	[UNSOLD_VALID_FLAG] [varchar](1) NULL,
	[SECURITY_PER] [numeric](5, 2) NULL,
	[SEC_AMT_LIMT] [numeric](12, 2) NULL,
	[SUPPLY_STOP_FLAG] [varchar](1) NULL,
	[SUPPLY_STOP_PER] [numeric](5, 2) NULL,
	[ABC_CITYCODE] [varchar](8) NULL,
	[UPDATED_BY] [varchar](50) NULL,
	[UPDATED_DT] [datetime] NULL,
	[SUPPLY_SUBAGENCY] [varchar](1) NULL,
	[AGEING_TYPE] [varchar](1) NULL,
	[LABEL_TYPE] [varchar](1) NULL,
	[H_ADDR1] [varchar](50) NULL,
	[H_ADDR2] [varchar](50) NULL,
	[H_ADDR3] [varchar](50) NULL,
	[H_CITY_CODE] [varchar](8) NULL,
	[H_TEHSIL_TALUKA] [varchar](8) NULL,
	[H_DIST_CODE] [varchar](8) NULL,
	[H_STATE_CODE] [varchar](8) NULL,
	[H_COUNTRY_CODE] [varchar](8) NULL,
	[H_PIN_CODE] [varchar](8) NULL,
	[H_PHONE_NO1] [varchar](25) NULL,
	[H_PHONE_NO2] [varchar](25) NULL,
	[H_MOBILE_NO1] [numeric](10, 0) NULL,
	[H_MOBILE_NO2] [numeric](10, 0) NULL,
	[H_EMAIL_ID] [varchar](50) NULL,
	[BILL_REMARK] [varchar](150) NULL,
	[SUP_BRANCH_CODE] [varchar](8) NULL,
	[SUP_STATE_CODE] [varchar](8) NULL,
	[ACCOUNT_AGCD] [varchar](8) NULL,
	[ACCOUNT_DPCD] [varchar](8) NULL,
	[ROC_NO] [varchar](20) NULL,
	[PAN_NO] [varchar](25) NULL,
	[TAN_NO] [varchar](25) NULL,
	[SER_TAX_NO] [varchar](25) NULL,
	[CLOSE_AGENCY_REASON] [varchar](5) NULL,
	[OLD_AGENCY] [varchar](25) NULL,
	[SAP_ID] [varchar](10) NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_AGMAST_LOG] ADD  DEFAULT (getdate()) FOR [CREATION_datetime]
GO

ALTER TABLE [dbo].[CIR_AGMAST_LOG] ADD  DEFAULT ('N') FOR [FREEZE_FLAG]
GO

ALTER TABLE [dbo].[CIR_AGMAST_LOG] ADD  DEFAULT ('N') FOR [SUPPLY_SUBAGENCY]
GO

ALTER TABLE [dbo].[CIR_AGMAST_LOG] ADD  DEFAULT ('I') FOR [LABEL_TYPE]
GO



///


CREATE TABLE [dbo].[CIR_AGENCY_TYP_MAST_LOG](
	[AGENCY_TYPE_CODE] [varchar](8) NOT NULL,
	[AGENCY_TYPE_DESC] [varchar](50) NOT NULL,
	[USERID] [varchar](10) NULL,
	[CREATION_DATE] [datetime] NOT NULL,
	[AGENCY_TYPE_ALIAS] [varchar](50) NOT NULL,
	[FREEZE_FLAG] [varchar](1) NULL,
	[COMP_CODE] [varchar](8) NOT NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_AGENCY_TYP_MAST_LOG] ADD  DEFAULT (getdate()) FOR [CREATION_DATE]
GO

ALTER TABLE [dbo].[CIR_AGENCY_TYP_MAST_LOG] ADD  DEFAULT ('N') FOR [FREEZE_FLAG]
GO



///


CREATE TABLE [dbo].[CIR_AGENCY_CLASS_MAST_LOG](
	[CLASS_CODE] [varchar](10) NOT NULL,
	[CLASS_DESC] [varchar](50) NOT NULL,
	[USERID] [varchar](10) NULL,
	[CREATION_DATE] [datetime] NOT NULL,
	[CLASS_ALIAS] [varchar](50) NOT NULL,
	[FREEZE_FLAG] [varchar](1) NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_AGENCY_CLASS_MAST_LOG] ADD  DEFAULT (getdate()) FOR [CREATION_DATE]
GO

ALTER TABLE [dbo].[CIR_AGENCY_CLASS_MAST_LOG] ADD  DEFAULT ('N') FOR [FREEZE_FLAG]
GO



///


CREATE TABLE [dbo].[CIR_AG_CLOSE_REASON_LOG](
	[COMP_CODE] [varchar](8) NULL,
	[REASON_CODE] [varchar](5) NOT NULL,
	[REASON_DESC] [varchar](50) NOT NULL,
	[USERID] [varchar](10) NULL,
	[CREATION_DATE] [datetime] NULL,
	[FREEZE_FLAG] [varchar](1) NULL,
	[LOG_USER] [varchar](50) NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_MACHINE] [varchar](200) NULL,
	[LOG_TYPE] [varchar](10) NULL,
	[LOG_SEQNO] [numeric](30, 0) IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CIR_AG_CLOSE_REASON_LOG] ADD  DEFAULT (getdate()) FOR [CREATION_DATE]
GO

ALTER TABLE [dbo].[CIR_AG_CLOSE_REASON_LOG] ADD  DEFAULT ('N') FOR [FREEZE_FLAG]
GO





ALTER TRIGGER [dbo].[CIR_RCPHDR_RECORD_LOG] ON [dbo].[CIR_RCPHDR] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;

IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'
	
	INSERT INTO CIR_RCPHDR_LOG(comp_code, unit_code, doctype, agcd, dpcd,recptno, recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,staxamt,status,ref_recptno,ref_recptdt,ref_amount,ref_doctype,cancel_user,cancel_date,cancel_remark,userid,creation_date,branch_code,prov_rec_no,prov_rec_dt,bkup_sno,remark_oth,trf_note_type,log_user,log_date,log_machine,log_type)
	select comp_code, unit_code, doctype, agcd, dpcd,recptno, recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,staxamt,status,ref_recptno,ref_recptdt,ref_amount,ref_doctype,cancel_user,cancel_date,cancel_remark,userid,creation_date,branch_code,prov_rec_no,prov_rec_dt,bkup_sno,remark_oth,trf_note_type,userid,getdate(),host_name()+'/'+@ip,'INSERT'
	from inserted
end
 
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'
	
	INSERT INTO CIR_RCPHDR_LOG(comp_code, unit_code, doctype, agcd, dpcd,recptno, recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,staxamt,status,ref_recptno,ref_recptdt,ref_amount,ref_doctype,cancel_user,cancel_date,cancel_remark,userid,creation_date,branch_code,prov_rec_no,prov_rec_dt,bkup_sno,remark_oth,trf_note_type,log_user,log_date,log_machine,log_type)
	select comp_code, unit_code, doctype, agcd, dpcd,recptno, recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,staxamt,status,ref_recptno,ref_recptdt,ref_amount,ref_doctype,cancel_user,cancel_date,cancel_remark,userid,creation_date,branch_code,prov_rec_no,prov_rec_dt,bkup_sno,remark_oth,trf_note_type,userid,getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_RCPHDR_LOG(comp_code, unit_code, doctype, agcd, dpcd,recptno, recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,staxamt,status,ref_recptno,ref_recptdt,ref_amount,ref_doctype,cancel_user,cancel_date,cancel_remark,userid,creation_date,branch_code,prov_rec_no,prov_rec_dt,bkup_sno,remark_oth,trf_note_type,log_user,log_date,log_machine,log_type)
	select comp_code, unit_code, doctype, agcd, dpcd,recptno, recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,staxamt,status,ref_recptno,ref_recptdt,ref_amount,ref_doctype,cancel_user,cancel_date,cancel_remark,userid,creation_date,branch_code,prov_rec_no,prov_rec_dt,bkup_sno,remark_oth,trf_note_type,userid,getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'
	INSERT INTO CIR_RCPHDR_LOG(comp_code, unit_code, doctype, agcd, dpcd,recptno, recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,staxamt,status,ref_recptno,ref_recptdt,ref_amount,ref_doctype,cancel_user,cancel_date,cancel_remark,userid,creation_date,branch_code,prov_rec_no,prov_rec_dt,bkup_sno,remark_oth,trf_note_type,log_user,log_date,log_machine,log_type)
	select comp_code, unit_code, doctype, agcd, dpcd, recptno,recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,staxamt,status,ref_recptno,ref_recptdt,ref_amount,ref_doctype,cancel_user,cancel_date,cancel_remark,userid,creation_date,branch_code,prov_rec_no,prov_rec_dt,bkup_sno,remark_oth,trf_note_type,userid,getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end

//////

ALTER TRIGGER [dbo].[CIR_RCPDET_RECORD_LOG] ON [dbo].[CIR_RCPDET] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;

IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'
	INSERT INTO CIR_RCPDET_LOG(COMP_CODE,  UNIT_CODE,  AGCD,  DPCD,  DOCTYP,  BILLNO,  BILLDT,  RECPTNO,  RECPTDT,  PAYFOR,  ACHD,  PUBL,  CHNO,  CHBNK,  CHDT,  AMOUNT,  REASON,  REMARK,  VOUCHERNO,  VOUCHERDT,  TDS,  STAX,  STATUS,  USRID,  CREATION_DATE,  BRANCH_CODE,  BKUP_SNO,temp_id,log_user,log_date,log_machine,log_type)
	select COMP_CODE,  UNIT_CODE,  AGCD,  DPCD,  DOCTYP,  BILLNO,  BILLDT,  RECPTNO,  RECPTDT,  PAYFOR,  ACHD,  PUBL,  CHNO,  CHBNK,  CHDT,  AMOUNT,  REASON,  REMARK,  VOUCHERNO,  VOUCHERDT,  TDS,  STAX,  STATUS,  USRID,  CREATION_DATE,  BRANCH_CODE,  BKUP_SNO,temp_id,USRID,getdate(),host_name()+'/'+@ip,'INSERT'
	from inserted
end
 
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'

	INSERT INTO CIR_RCPDET_LOG(COMP_CODE,  UNIT_CODE,  AGCD,  DPCD,  DOCTYP,  BILLNO,  BILLDT,  RECPTNO,  RECPTDT,  PAYFOR,  ACHD,  PUBL,  CHNO,  CHBNK,  CHDT,  AMOUNT,  REASON,  REMARK,  VOUCHERNO,  VOUCHERDT,  TDS,  STAX,  STATUS,  USRID,  CREATION_DATE,  BRANCH_CODE,  BKUP_SNO,temp_id,log_user,log_date,log_machine,log_type)
	select COMP_CODE,  UNIT_CODE,  AGCD,  DPCD,  DOCTYP,  BILLNO,  BILLDT,  RECPTNO,  RECPTDT,  PAYFOR,  ACHD,  PUBL,  CHNO,  CHBNK,  CHDT,  AMOUNT,  REASON,  REMARK,  VOUCHERNO,  VOUCHERDT,  TDS,  STAX,  STATUS,  USRID,  CREATION_DATE,  BRANCH_CODE,  BKUP_SNO,temp_id,USRID,getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_RCPDET_LOG(COMP_CODE,  UNIT_CODE,  AGCD,  DPCD,  DOCTYP,  BILLNO,  BILLDT,  RECPTNO,  RECPTDT,  PAYFOR,  ACHD,  PUBL,  CHNO,  CHBNK,  CHDT,  AMOUNT,  REASON,  REMARK,  VOUCHERNO,  VOUCHERDT,  TDS,  STAX,  STATUS,  USRID,  CREATION_DATE,  BRANCH_CODE,  BKUP_SNO,temp_id,log_user,log_date,log_machine,log_type)
	select COMP_CODE,  UNIT_CODE,  AGCD,  DPCD,  DOCTYP,  BILLNO,  BILLDT,  RECPTNO,  RECPTDT,  PAYFOR,  ACHD,  PUBL,  CHNO,  CHBNK,  CHDT,  AMOUNT,  REASON,  REMARK,  VOUCHERNO,  VOUCHERDT,  TDS,  STAX,  STATUS,  USRID,  CREATION_DATE,  BRANCH_CODE,  BKUP_SNO,temp_id,USRID,getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'

	INSERT INTO CIR_RCPDET_LOG(COMP_CODE,  UNIT_CODE,  AGCD,  DPCD,  DOCTYP,  BILLNO,  BILLDT,  RECPTNO,  RECPTDT,  PAYFOR,  ACHD,  PUBL,  CHNO,  CHBNK,  CHDT,  AMOUNT,  REASON,  REMARK,  VOUCHERNO,  VOUCHERDT,  TDS,  STAX,  STATUS,  USRID,  CREATION_DATE,  BRANCH_CODE,  BKUP_SNO,temp_id,log_user,log_date,log_machine,log_type)
	select COMP_CODE,  UNIT_CODE,  AGCD,  DPCD,  DOCTYP,  BILLNO,  BILLDT,  RECPTNO,  RECPTDT,  PAYFOR,  ACHD,  PUBL,  CHNO,  CHBNK,  CHDT,  AMOUNT,  REASON,  REMARK,  VOUCHERNO,  VOUCHERDT,  TDS,  STAX,  STATUS,  USRID,  CREATION_DATE,  BRANCH_CODE,  BKUP_SNO,temp_id,USRID,getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end

///////


ALTER TRIGGER [dbo].[CIR_OUTMAST_RECORD_LOG] ON [dbo].[CIR_OUTMAST] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;

IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'
	INSERT INTO CIR_outmast_LOG(COMP_CODE,UNIT_CODE,AGCD,DPCD,DOCTYP,BILLNO,BILLDT,RECPTNO,RECPTDT,ACHD,PUBL,CHNO,CHBNK,CHDT,AMOUNT,REASON,REMARK,VOUCHERNO,VOUCHERDT,
BALANCE,TDS,STAX,STATUS,CANCEL_USERID,CANCEL_DT,CANCEL_REMARK,USRID,CREATION_DATE,BILL_SEC_AMT,BRANCH_CODE,bkup_sno,temp_id,DISPUTE_FLAG,
DISPUTE_USER_CODE,DISPUTE_DT,DISPUTE_RMRK,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select 
COMP_CODE,UNIT_CODE,AGCD,DPCD,DOCTYP,BILLNO,BILLDT,RECPTNO,RECPTDT,ACHD,PUBL,CHNO,CHBNK,CHDT,AMOUNT,REASON,REMARK,VOUCHERNO,VOUCHERDT,
BALANCE,TDS,STAX,STATUS,CANCEL_USERID,CANCEL_DT,CANCEL_REMARK,USRID,CREATION_DATE,BILL_SEC_AMT,BRANCH_CODE,bkup_sno,temp_id,DISPUTE_FLAG,
DISPUTE_USER_CODE,DISPUTE_DT,DISPUTE_RMRK,USRID,getdate(),host_name()+'/'+@ip,'INSERT'
	from inserted
end
 
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'
	
	INSERT INTO CIR_outmast_LOG(COMP_CODE,UNIT_CODE,AGCD,DPCD,DOCTYP,BILLNO,BILLDT,RECPTNO,RECPTDT,ACHD,PUBL,CHNO,CHBNK,CHDT,AMOUNT,REASON,REMARK,VOUCHERNO,VOUCHERDT,
BALANCE,TDS,STAX,STATUS,CANCEL_USERID,CANCEL_DT,CANCEL_REMARK,USRID,CREATION_DATE,BILL_SEC_AMT,BRANCH_CODE,bkup_sno,temp_id,DISPUTE_FLAG,
DISPUTE_USER_CODE,DISPUTE_DT,DISPUTE_RMRK,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select 
COMP_CODE,UNIT_CODE,AGCD,DPCD,DOCTYP,BILLNO,BILLDT,RECPTNO,RECPTDT,ACHD,PUBL,CHNO,CHBNK,CHDT,AMOUNT,REASON,REMARK,VOUCHERNO,VOUCHERDT,
BALANCE,TDS,STAX,STATUS,CANCEL_USERID,CANCEL_DT,CANCEL_REMARK,USRID,CREATION_DATE,BILL_SEC_AMT,BRANCH_CODE,bkup_sno,temp_id,DISPUTE_FLAG,
DISPUTE_USER_CODE,DISPUTE_DT,DISPUTE_RMRK,USRID,getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
		INSERT INTO CIR_outmast_LOG(COMP_CODE,UNIT_CODE,AGCD,DPCD,DOCTYP,BILLNO,BILLDT,RECPTNO,RECPTDT,ACHD,PUBL,CHNO,CHBNK,CHDT,AMOUNT,REASON,REMARK,VOUCHERNO,VOUCHERDT,
BALANCE,TDS,STAX,STATUS,CANCEL_USERID,CANCEL_DT,CANCEL_REMARK,USRID,CREATION_DATE,BILL_SEC_AMT,BRANCH_CODE,bkup_sno,temp_id,DISPUTE_FLAG,
DISPUTE_USER_CODE,DISPUTE_DT,DISPUTE_RMRK,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select 
COMP_CODE,UNIT_CODE,AGCD,DPCD,DOCTYP,BILLNO,BILLDT,RECPTNO,RECPTDT,ACHD,PUBL,CHNO,CHBNK,CHDT,AMOUNT,REASON,REMARK,VOUCHERNO,VOUCHERDT,
BALANCE,TDS,STAX,STATUS,CANCEL_USERID,CANCEL_DT,CANCEL_REMARK,USRID,CREATION_DATE,BILL_SEC_AMT,BRANCH_CODE,bkup_sno,temp_id,DISPUTE_FLAG,
DISPUTE_USER_CODE,DISPUTE_DT,DISPUTE_RMRK,USRID,getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'
		INSERT INTO CIR_outmast_LOG(COMP_CODE,UNIT_CODE,AGCD,DPCD,DOCTYP,BILLNO,BILLDT,RECPTNO,RECPTDT,ACHD,PUBL,CHNO,CHBNK,CHDT,AMOUNT,REASON,REMARK,VOUCHERNO,VOUCHERDT,
BALANCE,TDS,STAX,STATUS,CANCEL_USERID,CANCEL_DT,CANCEL_REMARK,USRID,CREATION_DATE,BILL_SEC_AMT,BRANCH_CODE,bkup_sno,temp_id,DISPUTE_FLAG,
DISPUTE_USER_CODE,DISPUTE_DT,DISPUTE_RMRK,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select 
COMP_CODE,UNIT_CODE,AGCD,DPCD,DOCTYP,BILLNO,BILLDT,RECPTNO,RECPTDT,ACHD,PUBL,CHNO,CHBNK,CHDT,AMOUNT,REASON,REMARK,VOUCHERNO,VOUCHERDT,
BALANCE,TDS,STAX,STATUS,CANCEL_USERID,CANCEL_DT,CANCEL_REMARK,USRID,CREATION_DATE,BILL_SEC_AMT,BRANCH_CODE,bkup_sno,temp_id,DISPUTE_FLAG,
DISPUTE_USER_CODE,DISPUTE_DT,DISPUTE_RMRK,USRID,getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end





////

ALTER TRIGGER [dbo].[CIR_AGMAST_LOG_RECORD_LOG] ON [dbo].[CIR_AGMAST] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;

IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'
	INSERT INTO CIR_AGMAST_LOG(COMP_CODE,UNIT,AGCD,DPCD,AG_NAME,AG_NAME_OTH_LANG,AG_TYPE,AG_CLASS,EXECUTIVE_CODE,SUPPLY_START_DT,ADDR1,ADDR2,ADDR3,CITY_CODE,DIST_CODE,
STATE_CODE,COUNTRY_CODE,TEHSIL_TALUKA,STATION_CODE,AREA_CODE,PHONE_NO1,PHONE_NO2,MOBILE_NO1,MOBILE_NO2,EMAIL_ID,SUSPEND,SUSPEND_TYPE,
SUSPEND_DATE,TO_BILL,BILL_AGCD,BILL_DPCD,PAYMODE,CREDIT_DAYS,PRINT_LABEL,PIN_PACKET,PIN_AGCD,PIN_DPCD,PIN_OPEN_INSIDE,LBL_LN1,LBL_LN2,
LBL_LN3,LBL_LN4,LBL_LN5,LBL_LN6,LBL_LN7,LBL_LN8,LBL_ATR1,LBL_ATR2,LBL_ATR3,LBL_ATR4,LBL_ATR5,LBL_ATR6,LBL_ATR7,LBL_ATR8,ALERT_TEXT,USERID,
CREATION_datetime,NAME_ON_LABEL,PRINT_SEQ,ALERT_VALID_DATE,PIN_CODE,FREEZE_FLAG,FAX_NO,BRANCH_CODE,UNSOLD_VALID_FLAG,SECURITY_PER,
SEC_AMT_LIMT,SUPPLY_STOP_FLAG,SUPPLY_STOP_PER,ABC_CITYCODE,UPDATED_BY,UPDATED_DT,SUPPLY_SUBAGENCY,AGEING_TYPE,LABEL_TYPE,H_ADDR1,H_ADDR2,
H_ADDR3,H_CITY_CODE,H_TEHSIL_TALUKA,H_DIST_CODE,H_STATE_CODE,H_COUNTRY_CODE,H_PIN_CODE,H_PHONE_NO1,H_PHONE_NO2,H_MOBILE_NO1,H_MOBILE_NO2,
H_EMAIL_ID,BILL_REMARK,SUP_BRANCH_CODE,SUP_STATE_CODE,ACCOUNT_AGCD,ACCOUNT_DPCD,ROC_NO,PAN_NO,TAN_NO,SER_TAX_NO,CLOSE_AGENCY_REASON,OLD_AGENCY,
SAP_ID,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT,AGCD,DPCD,AG_NAME,AG_NAME_OTH_LANG,AG_TYPE,AG_CLASS,EXECUTIVE_CODE,SUPPLY_START_DT,ADDR1,ADDR2,ADDR3,CITY_CODE,DIST_CODE,
STATE_CODE,COUNTRY_CODE,TEHSIL_TALUKA,STATION_CODE,AREA_CODE,PHONE_NO1,PHONE_NO2,MOBILE_NO1,MOBILE_NO2,EMAIL_ID,SUSPEND,SUSPEND_TYPE,
SUSPEND_DATE,TO_BILL,BILL_AGCD,BILL_DPCD,PAYMODE,CREDIT_DAYS,PRINT_LABEL,PIN_PACKET,PIN_AGCD,PIN_DPCD,PIN_OPEN_INSIDE,LBL_LN1,LBL_LN2,
LBL_LN3,LBL_LN4,LBL_LN5,LBL_LN6,LBL_LN7,LBL_LN8,LBL_ATR1,LBL_ATR2,LBL_ATR3,LBL_ATR4,LBL_ATR5,LBL_ATR6,LBL_ATR7,LBL_ATR8,ALERT_TEXT,USERID,
CREATION_datetime,NAME_ON_LABEL,PRINT_SEQ,ALERT_VALID_DATE,PIN_CODE,FREEZE_FLAG,FAX_NO,BRANCH_CODE,UNSOLD_VALID_FLAG,SECURITY_PER,
SEC_AMT_LIMT,SUPPLY_STOP_FLAG,SUPPLY_STOP_PER,ABC_CITYCODE,UPDATED_BY,UPDATED_DT,SUPPLY_SUBAGENCY,AGEING_TYPE,LABEL_TYPE,H_ADDR1,H_ADDR2,
H_ADDR3,H_CITY_CODE,H_TEHSIL_TALUKA,H_DIST_CODE,H_STATE_CODE,H_COUNTRY_CODE,H_PIN_CODE,H_PHONE_NO1,H_PHONE_NO2,H_MOBILE_NO1,H_MOBILE_NO2,
H_EMAIL_ID,BILL_REMARK,SUP_BRANCH_CODE,SUP_STATE_CODE,ACCOUNT_AGCD,ACCOUNT_DPCD,ROC_NO,PAN_NO,TAN_NO,SER_TAX_NO,CLOSE_AGENCY_REASON,OLD_AGENCY,
SAP_ID,isnull(UPDATED_BY,userid),getdate(),host_name()+'/'+@ip,'INSERT'
	from inserted
end
 
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'
	
	INSERT INTO CIR_AGMAST_LOG(COMP_CODE,UNIT,AGCD,DPCD,AG_NAME,AG_NAME_OTH_LANG,AG_TYPE,AG_CLASS,EXECUTIVE_CODE,SUPPLY_START_DT,ADDR1,ADDR2,ADDR3,CITY_CODE,DIST_CODE,
STATE_CODE,COUNTRY_CODE,TEHSIL_TALUKA,STATION_CODE,AREA_CODE,PHONE_NO1,PHONE_NO2,MOBILE_NO1,MOBILE_NO2,EMAIL_ID,SUSPEND,SUSPEND_TYPE,
SUSPEND_DATE,TO_BILL,BILL_AGCD,BILL_DPCD,PAYMODE,CREDIT_DAYS,PRINT_LABEL,PIN_PACKET,PIN_AGCD,PIN_DPCD,PIN_OPEN_INSIDE,LBL_LN1,LBL_LN2,
LBL_LN3,LBL_LN4,LBL_LN5,LBL_LN6,LBL_LN7,LBL_LN8,LBL_ATR1,LBL_ATR2,LBL_ATR3,LBL_ATR4,LBL_ATR5,LBL_ATR6,LBL_ATR7,LBL_ATR8,ALERT_TEXT,USERID,
CREATION_datetime,NAME_ON_LABEL,PRINT_SEQ,ALERT_VALID_DATE,PIN_CODE,FREEZE_FLAG,FAX_NO,BRANCH_CODE,UNSOLD_VALID_FLAG,SECURITY_PER,
SEC_AMT_LIMT,SUPPLY_STOP_FLAG,SUPPLY_STOP_PER,ABC_CITYCODE,UPDATED_BY,UPDATED_DT,SUPPLY_SUBAGENCY,AGEING_TYPE,LABEL_TYPE,H_ADDR1,H_ADDR2,
H_ADDR3,H_CITY_CODE,H_TEHSIL_TALUKA,H_DIST_CODE,H_STATE_CODE,H_COUNTRY_CODE,H_PIN_CODE,H_PHONE_NO1,H_PHONE_NO2,H_MOBILE_NO1,H_MOBILE_NO2,
H_EMAIL_ID,BILL_REMARK,SUP_BRANCH_CODE,SUP_STATE_CODE,ACCOUNT_AGCD,ACCOUNT_DPCD,ROC_NO,PAN_NO,TAN_NO,SER_TAX_NO,CLOSE_AGENCY_REASON,OLD_AGENCY,
SAP_ID,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT,AGCD,DPCD,AG_NAME,AG_NAME_OTH_LANG,AG_TYPE,AG_CLASS,EXECUTIVE_CODE,SUPPLY_START_DT,ADDR1,ADDR2,ADDR3,CITY_CODE,DIST_CODE,
STATE_CODE,COUNTRY_CODE,TEHSIL_TALUKA,STATION_CODE,AREA_CODE,PHONE_NO1,PHONE_NO2,MOBILE_NO1,MOBILE_NO2,EMAIL_ID,SUSPEND,SUSPEND_TYPE,
SUSPEND_DATE,TO_BILL,BILL_AGCD,BILL_DPCD,PAYMODE,CREDIT_DAYS,PRINT_LABEL,PIN_PACKET,PIN_AGCD,PIN_DPCD,PIN_OPEN_INSIDE,LBL_LN1,LBL_LN2,
LBL_LN3,LBL_LN4,LBL_LN5,LBL_LN6,LBL_LN7,LBL_LN8,LBL_ATR1,LBL_ATR2,LBL_ATR3,LBL_ATR4,LBL_ATR5,LBL_ATR6,LBL_ATR7,LBL_ATR8,ALERT_TEXT,USERID,
CREATION_datetime,NAME_ON_LABEL,PRINT_SEQ,ALERT_VALID_DATE,PIN_CODE,FREEZE_FLAG,FAX_NO,BRANCH_CODE,UNSOLD_VALID_FLAG,SECURITY_PER,
SEC_AMT_LIMT,SUPPLY_STOP_FLAG,SUPPLY_STOP_PER,ABC_CITYCODE,UPDATED_BY,UPDATED_DT,SUPPLY_SUBAGENCY,AGEING_TYPE,LABEL_TYPE,H_ADDR1,H_ADDR2,
H_ADDR3,H_CITY_CODE,H_TEHSIL_TALUKA,H_DIST_CODE,H_STATE_CODE,H_COUNTRY_CODE,H_PIN_CODE,H_PHONE_NO1,H_PHONE_NO2,H_MOBILE_NO1,H_MOBILE_NO2,
H_EMAIL_ID,BILL_REMARK,SUP_BRANCH_CODE,SUP_STATE_CODE,ACCOUNT_AGCD,ACCOUNT_DPCD,ROC_NO,PAN_NO,TAN_NO,SER_TAX_NO,CLOSE_AGENCY_REASON,OLD_AGENCY,
SAP_ID,isnull(UPDATED_BY,userid),getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_AGMAST_LOG(COMP_CODE,UNIT,AGCD,DPCD,AG_NAME,AG_NAME_OTH_LANG,AG_TYPE,AG_CLASS,EXECUTIVE_CODE,SUPPLY_START_DT,ADDR1,ADDR2,ADDR3,CITY_CODE,DIST_CODE,
STATE_CODE,COUNTRY_CODE,TEHSIL_TALUKA,STATION_CODE,AREA_CODE,PHONE_NO1,PHONE_NO2,MOBILE_NO1,MOBILE_NO2,EMAIL_ID,SUSPEND,SUSPEND_TYPE,
SUSPEND_DATE,TO_BILL,BILL_AGCD,BILL_DPCD,PAYMODE,CREDIT_DAYS,PRINT_LABEL,PIN_PACKET,PIN_AGCD,PIN_DPCD,PIN_OPEN_INSIDE,LBL_LN1,LBL_LN2,
LBL_LN3,LBL_LN4,LBL_LN5,LBL_LN6,LBL_LN7,LBL_LN8,LBL_ATR1,LBL_ATR2,LBL_ATR3,LBL_ATR4,LBL_ATR5,LBL_ATR6,LBL_ATR7,LBL_ATR8,ALERT_TEXT,USERID,
CREATION_datetime,NAME_ON_LABEL,PRINT_SEQ,ALERT_VALID_DATE,PIN_CODE,FREEZE_FLAG,FAX_NO,BRANCH_CODE,UNSOLD_VALID_FLAG,SECURITY_PER,
SEC_AMT_LIMT,SUPPLY_STOP_FLAG,SUPPLY_STOP_PER,ABC_CITYCODE,UPDATED_BY,UPDATED_DT,SUPPLY_SUBAGENCY,AGEING_TYPE,LABEL_TYPE,H_ADDR1,H_ADDR2,
H_ADDR3,H_CITY_CODE,H_TEHSIL_TALUKA,H_DIST_CODE,H_STATE_CODE,H_COUNTRY_CODE,H_PIN_CODE,H_PHONE_NO1,H_PHONE_NO2,H_MOBILE_NO1,H_MOBILE_NO2,
H_EMAIL_ID,BILL_REMARK,SUP_BRANCH_CODE,SUP_STATE_CODE,ACCOUNT_AGCD,ACCOUNT_DPCD,ROC_NO,PAN_NO,TAN_NO,SER_TAX_NO,CLOSE_AGENCY_REASON,OLD_AGENCY,
SAP_ID,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT,AGCD,DPCD,AG_NAME,AG_NAME_OTH_LANG,AG_TYPE,AG_CLASS,EXECUTIVE_CODE,SUPPLY_START_DT,ADDR1,ADDR2,ADDR3,CITY_CODE,DIST_CODE,
STATE_CODE,COUNTRY_CODE,TEHSIL_TALUKA,STATION_CODE,AREA_CODE,PHONE_NO1,PHONE_NO2,MOBILE_NO1,MOBILE_NO2,EMAIL_ID,SUSPEND,SUSPEND_TYPE,
SUSPEND_DATE,TO_BILL,BILL_AGCD,BILL_DPCD,PAYMODE,CREDIT_DAYS,PRINT_LABEL,PIN_PACKET,PIN_AGCD,PIN_DPCD,PIN_OPEN_INSIDE,LBL_LN1,LBL_LN2,
LBL_LN3,LBL_LN4,LBL_LN5,LBL_LN6,LBL_LN7,LBL_LN8,LBL_ATR1,LBL_ATR2,LBL_ATR3,LBL_ATR4,LBL_ATR5,LBL_ATR6,LBL_ATR7,LBL_ATR8,ALERT_TEXT,USERID,
CREATION_datetime,NAME_ON_LABEL,PRINT_SEQ,ALERT_VALID_DATE,PIN_CODE,FREEZE_FLAG,FAX_NO,BRANCH_CODE,UNSOLD_VALID_FLAG,SECURITY_PER,
SEC_AMT_LIMT,SUPPLY_STOP_FLAG,SUPPLY_STOP_PER,ABC_CITYCODE,UPDATED_BY,UPDATED_DT,SUPPLY_SUBAGENCY,AGEING_TYPE,LABEL_TYPE,H_ADDR1,H_ADDR2,
H_ADDR3,H_CITY_CODE,H_TEHSIL_TALUKA,H_DIST_CODE,H_STATE_CODE,H_COUNTRY_CODE,H_PIN_CODE,H_PHONE_NO1,H_PHONE_NO2,H_MOBILE_NO1,H_MOBILE_NO2,
H_EMAIL_ID,BILL_REMARK,SUP_BRANCH_CODE,SUP_STATE_CODE,ACCOUNT_AGCD,ACCOUNT_DPCD,ROC_NO,PAN_NO,TAN_NO,SER_TAX_NO,CLOSE_AGENCY_REASON,OLD_AGENCY,
SAP_ID,isnull(UPDATED_BY,userid),getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'
	INSERT INTO CIR_AGMAST_LOG(COMP_CODE,UNIT,AGCD,DPCD,AG_NAME,AG_NAME_OTH_LANG,AG_TYPE,AG_CLASS,EXECUTIVE_CODE,SUPPLY_START_DT,ADDR1,ADDR2,ADDR3,CITY_CODE,DIST_CODE,
STATE_CODE,COUNTRY_CODE,TEHSIL_TALUKA,STATION_CODE,AREA_CODE,PHONE_NO1,PHONE_NO2,MOBILE_NO1,MOBILE_NO2,EMAIL_ID,SUSPEND,SUSPEND_TYPE,
SUSPEND_DATE,TO_BILL,BILL_AGCD,BILL_DPCD,PAYMODE,CREDIT_DAYS,PRINT_LABEL,PIN_PACKET,PIN_AGCD,PIN_DPCD,PIN_OPEN_INSIDE,LBL_LN1,LBL_LN2,
LBL_LN3,LBL_LN4,LBL_LN5,LBL_LN6,LBL_LN7,LBL_LN8,LBL_ATR1,LBL_ATR2,LBL_ATR3,LBL_ATR4,LBL_ATR5,LBL_ATR6,LBL_ATR7,LBL_ATR8,ALERT_TEXT,USERID,
CREATION_datetime,NAME_ON_LABEL,PRINT_SEQ,ALERT_VALID_DATE,PIN_CODE,FREEZE_FLAG,FAX_NO,BRANCH_CODE,UNSOLD_VALID_FLAG,SECURITY_PER,
SEC_AMT_LIMT,SUPPLY_STOP_FLAG,SUPPLY_STOP_PER,ABC_CITYCODE,UPDATED_BY,UPDATED_DT,SUPPLY_SUBAGENCY,AGEING_TYPE,LABEL_TYPE,H_ADDR1,H_ADDR2,
H_ADDR3,H_CITY_CODE,H_TEHSIL_TALUKA,H_DIST_CODE,H_STATE_CODE,H_COUNTRY_CODE,H_PIN_CODE,H_PHONE_NO1,H_PHONE_NO2,H_MOBILE_NO1,H_MOBILE_NO2,
H_EMAIL_ID,BILL_REMARK,SUP_BRANCH_CODE,SUP_STATE_CODE,ACCOUNT_AGCD,ACCOUNT_DPCD,ROC_NO,PAN_NO,TAN_NO,SER_TAX_NO,CLOSE_AGENCY_REASON,OLD_AGENCY,
SAP_ID,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT,AGCD,DPCD,AG_NAME,AG_NAME_OTH_LANG,AG_TYPE,AG_CLASS,EXECUTIVE_CODE,SUPPLY_START_DT,ADDR1,ADDR2,ADDR3,CITY_CODE,DIST_CODE,
STATE_CODE,COUNTRY_CODE,TEHSIL_TALUKA,STATION_CODE,AREA_CODE,PHONE_NO1,PHONE_NO2,MOBILE_NO1,MOBILE_NO2,EMAIL_ID,SUSPEND,SUSPEND_TYPE,
SUSPEND_DATE,TO_BILL,BILL_AGCD,BILL_DPCD,PAYMODE,CREDIT_DAYS,PRINT_LABEL,PIN_PACKET,PIN_AGCD,PIN_DPCD,PIN_OPEN_INSIDE,LBL_LN1,LBL_LN2,
LBL_LN3,LBL_LN4,LBL_LN5,LBL_LN6,LBL_LN7,LBL_LN8,LBL_ATR1,LBL_ATR2,LBL_ATR3,LBL_ATR4,LBL_ATR5,LBL_ATR6,LBL_ATR7,LBL_ATR8,ALERT_TEXT,USERID,
CREATION_datetime,NAME_ON_LABEL,PRINT_SEQ,ALERT_VALID_DATE,PIN_CODE,FREEZE_FLAG,FAX_NO,BRANCH_CODE,UNSOLD_VALID_FLAG,SECURITY_PER,
SEC_AMT_LIMT,SUPPLY_STOP_FLAG,SUPPLY_STOP_PER,ABC_CITYCODE,UPDATED_BY,UPDATED_DT,SUPPLY_SUBAGENCY,AGEING_TYPE,LABEL_TYPE,H_ADDR1,H_ADDR2,
H_ADDR3,H_CITY_CODE,H_TEHSIL_TALUKA,H_DIST_CODE,H_STATE_CODE,H_COUNTRY_CODE,H_PIN_CODE,H_PHONE_NO1,H_PHONE_NO2,H_MOBILE_NO1,H_MOBILE_NO2,
H_EMAIL_ID,BILL_REMARK,SUP_BRANCH_CODE,SUP_STATE_CODE,ACCOUNT_AGCD,ACCOUNT_DPCD,ROC_NO,PAN_NO,TAN_NO,SER_TAX_NO,CLOSE_AGENCY_REASON,OLD_AGENCY,
SAP_ID,isnull(UPDATED_BY,userid),getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end















///////////////

ALTER TRIGGER [dbo].[CIR_BILL_RECORD_LOG] ON [dbo].[CIR_BILL] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;


IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'
	INSERT INTO CIR_BILL_LOG(COMP_CODE,UNIT_CODE,BILLNO,BILLDT,AGCD,DPCD,PUBL,BILL_COPY,GROSS_AMOUNT,SUR_AMOUNT,COMM_AMOUNT,BILL_AMOUNT,BILL_FRDT,BILL_TODT,BILL_FLAG,
BILL_REMARK,USERID,CREATION_DATE,BILL_SEC_AMT,EXCOMM_RECPTNO,EXCOMM_RECPTDT,EXCOMM_AMT,BRANCH_CODE,SEC_PER_RATE,ROUTE_CODE,BILL_COUNT,
CN_COMM_COPY,TAX_RATE,TAX_AMT,ACCAGCD,ACCDPCD,TAX_CALC_TYPE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select 
COMP_CODE,UNIT_CODE,BILLNO,BILLDT,AGCD,DPCD,PUBL,BILL_COPY,GROSS_AMOUNT,SUR_AMOUNT,COMM_AMOUNT,BILL_AMOUNT,BILL_FRDT,BILL_TODT,BILL_FLAG,
BILL_REMARK,USERID,CREATION_DATE,BILL_SEC_AMT,EXCOMM_RECPTNO,EXCOMM_RECPTDT,EXCOMM_AMT,BRANCH_CODE,SEC_PER_RATE,ROUTE_CODE,BILL_COUNT,
CN_COMM_COPY,TAX_RATE,TAX_AMT,ACCAGCD,ACCDPCD,TAX_CALC_TYPE,USERID,getdate(),host_name()+'/'+@ip,'INSERT'
	from inserted
end
 
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'
	
	INSERT INTO CIR_BILL_LOG(COMP_CODE,UNIT_CODE,BILLNO,BILLDT,AGCD,DPCD,PUBL,BILL_COPY,GROSS_AMOUNT,SUR_AMOUNT,COMM_AMOUNT,BILL_AMOUNT,BILL_FRDT,BILL_TODT,BILL_FLAG,
BILL_REMARK,USERID,CREATION_DATE,BILL_SEC_AMT,EXCOMM_RECPTNO,EXCOMM_RECPTDT,EXCOMM_AMT,BRANCH_CODE,SEC_PER_RATE,ROUTE_CODE,BILL_COUNT,
CN_COMM_COPY,TAX_RATE,TAX_AMT,ACCAGCD,ACCDPCD,TAX_CALC_TYPE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select 
COMP_CODE,UNIT_CODE,BILLNO,BILLDT,AGCD,DPCD,PUBL,BILL_COPY,GROSS_AMOUNT,SUR_AMOUNT,COMM_AMOUNT,BILL_AMOUNT,BILL_FRDT,BILL_TODT,BILL_FLAG,
BILL_REMARK,USERID,CREATION_DATE,BILL_SEC_AMT,EXCOMM_RECPTNO,EXCOMM_RECPTDT,EXCOMM_AMT,BRANCH_CODE,SEC_PER_RATE,ROUTE_CODE,BILL_COUNT,
CN_COMM_COPY,TAX_RATE,TAX_AMT,ACCAGCD,ACCDPCD,TAX_CALC_TYPE,USERID,getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
		INSERT INTO CIR_BILL_LOG(COMP_CODE,UNIT_CODE,BILLNO,BILLDT,AGCD,DPCD,PUBL,BILL_COPY,GROSS_AMOUNT,SUR_AMOUNT,COMM_AMOUNT,BILL_AMOUNT,BILL_FRDT,BILL_TODT,BILL_FLAG,
BILL_REMARK,USERID,CREATION_DATE,BILL_SEC_AMT,EXCOMM_RECPTNO,EXCOMM_RECPTDT,EXCOMM_AMT,BRANCH_CODE,SEC_PER_RATE,ROUTE_CODE,BILL_COUNT,
CN_COMM_COPY,TAX_RATE,TAX_AMT,ACCAGCD,ACCDPCD,TAX_CALC_TYPE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select 
COMP_CODE,UNIT_CODE,BILLNO,BILLDT,AGCD,DPCD,PUBL,BILL_COPY,GROSS_AMOUNT,SUR_AMOUNT,COMM_AMOUNT,BILL_AMOUNT,BILL_FRDT,BILL_TODT,BILL_FLAG,
BILL_REMARK,USERID,CREATION_DATE,BILL_SEC_AMT,EXCOMM_RECPTNO,EXCOMM_RECPTDT,EXCOMM_AMT,BRANCH_CODE,SEC_PER_RATE,ROUTE_CODE,BILL_COUNT,
CN_COMM_COPY,TAX_RATE,TAX_AMT,ACCAGCD,ACCDPCD,TAX_CALC_TYPE,USERID,getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'
		INSERT INTO CIR_BILL_LOG(COMP_CODE,UNIT_CODE,BILLNO,BILLDT,AGCD,DPCD,PUBL,BILL_COPY,GROSS_AMOUNT,SUR_AMOUNT,COMM_AMOUNT,BILL_AMOUNT,BILL_FRDT,BILL_TODT,BILL_FLAG,
BILL_REMARK,USERID,CREATION_DATE,BILL_SEC_AMT,EXCOMM_RECPTNO,EXCOMM_RECPTDT,EXCOMM_AMT,BRANCH_CODE,SEC_PER_RATE,ROUTE_CODE,BILL_COUNT,
CN_COMM_COPY,TAX_RATE,TAX_AMT,ACCAGCD,ACCDPCD,TAX_CALC_TYPE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select 
COMP_CODE,UNIT_CODE,BILLNO,BILLDT,AGCD,DPCD,PUBL,BILL_COPY,GROSS_AMOUNT,SUR_AMOUNT,COMM_AMOUNT,BILL_AMOUNT,BILL_FRDT,BILL_TODT,BILL_FLAG,
BILL_REMARK,USERID,CREATION_DATE,BILL_SEC_AMT,EXCOMM_RECPTNO,EXCOMM_RECPTDT,EXCOMM_AMT,BRANCH_CODE,SEC_PER_RATE,ROUTE_CODE,BILL_COUNT,
CN_COMM_COPY,TAX_RATE,TAX_AMT,ACCAGCD,ACCDPCD,TAX_CALC_TYPE,USERID,getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end





////

ALTER TRIGGER [dbo].[CIR_BILL_DET_RECORD_LOG] ON [dbo].[CIR_BILL_DET] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;



IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'
INSERT INTO CIR_BILL_DET_LOG(COMP_CODE,UNIT_CODE,BILLNO,BILLDT,AGCD,DPCD,PUBL,EDTN,BILL_COPY,COPY_RATE,COMM_FLAG,COMM_RATE,SUR_RATE,GROSS_AMOUNT,
BILL_AMOUNT,FROMDT,TODT,COAG,CODP,REMARKS,USERID,CREATION_DATE,COMM_AMT,SUR_AMT,BILL_FLAG,BRANCH_CODE,COMM_TYPE,
temp_id,ACCAGCD,ACCDPCD,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select 
COMP_CODE,UNIT_CODE,BILLNO,BILLDT,AGCD,DPCD,PUBL,EDTN,BILL_COPY,COPY_RATE,COMM_FLAG,COMM_RATE,SUR_RATE,GROSS_AMOUNT,
BILL_AMOUNT,FROMDT,TODT,COAG,CODP,REMARKS,USERID,CREATION_DATE,COMM_AMT,SUR_AMT,BILL_FLAG,BRANCH_CODE,COMM_TYPE,
temp_id,ACCAGCD,ACCDPCD,USERID,getdate(),host_name()+'/'+@ip,'INSERT'
	from inserted
end
 
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'
	
	INSERT INTO CIR_BILL_DET_LOG(COMP_CODE,UNIT_CODE,BILLNO,BILLDT,AGCD,DPCD,PUBL,EDTN,BILL_COPY,COPY_RATE,COMM_FLAG,COMM_RATE,SUR_RATE,GROSS_AMOUNT,
BILL_AMOUNT,FROMDT,TODT,COAG,CODP,REMARKS,USERID,CREATION_DATE,COMM_AMT,SUR_AMT,BILL_FLAG,BRANCH_CODE,COMM_TYPE,
temp_id,ACCAGCD,ACCDPCD,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select 
COMP_CODE,UNIT_CODE,BILLNO,BILLDT,AGCD,DPCD,PUBL,EDTN,BILL_COPY,COPY_RATE,COMM_FLAG,COMM_RATE,SUR_RATE,GROSS_AMOUNT,
BILL_AMOUNT,FROMDT,TODT,COAG,CODP,REMARKS,USERID,CREATION_DATE,COMM_AMT,SUR_AMT,BILL_FLAG,BRANCH_CODE,COMM_TYPE,
temp_id,ACCAGCD,ACCDPCD,USERID,getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
		INSERT INTO CIR_BILL_DET_LOG(COMP_CODE,UNIT_CODE,BILLNO,BILLDT,AGCD,DPCD,PUBL,EDTN,BILL_COPY,COPY_RATE,COMM_FLAG,COMM_RATE,SUR_RATE,GROSS_AMOUNT,
BILL_AMOUNT,FROMDT,TODT,COAG,CODP,REMARKS,USERID,CREATION_DATE,COMM_AMT,SUR_AMT,BILL_FLAG,BRANCH_CODE,COMM_TYPE,
temp_id,ACCAGCD,ACCDPCD,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select 
COMP_CODE,UNIT_CODE,BILLNO,BILLDT,AGCD,DPCD,PUBL,EDTN,BILL_COPY,COPY_RATE,COMM_FLAG,COMM_RATE,SUR_RATE,GROSS_AMOUNT,
BILL_AMOUNT,FROMDT,TODT,COAG,CODP,REMARKS,USERID,CREATION_DATE,COMM_AMT,SUR_AMT,BILL_FLAG,BRANCH_CODE,COMM_TYPE,
temp_id,ACCAGCD,ACCDPCD,USERID,getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'
		INSERT INTO CIR_BILL_DET_LOG(COMP_CODE,UNIT_CODE,BILLNO,BILLDT,AGCD,DPCD,PUBL,EDTN,BILL_COPY,COPY_RATE,COMM_FLAG,COMM_RATE,SUR_RATE,GROSS_AMOUNT,
BILL_AMOUNT,FROMDT,TODT,COAG,CODP,REMARKS,USERID,CREATION_DATE,COMM_AMT,SUR_AMT,BILL_FLAG,BRANCH_CODE,COMM_TYPE,
temp_id,ACCAGCD,ACCDPCD,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select 
COMP_CODE,UNIT_CODE,BILLNO,BILLDT,AGCD,DPCD,PUBL,EDTN,BILL_COPY,COPY_RATE,COMM_FLAG,COMM_RATE,SUR_RATE,GROSS_AMOUNT,
BILL_AMOUNT,FROMDT,TODT,COAG,CODP,REMARKS,USERID,CREATION_DATE,COMM_AMT,SUR_AMT,BILL_FLAG,BRANCH_CODE,COMM_TYPE,
temp_id,ACCAGCD,ACCDPCD,USERID,getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end








////


ALTER TRIGGER [dbo].[CIR_UNSOLD_HDR_RECORD_LOG] ON [dbo].[CIR_UNSOLD_HDR] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;


IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'

	INSERT INTO CIR_UNSOLD_HDR_LOG(COMP_CODE,UNIT_CODE,DOCTYPE,RECPTNO,RECPTDT,ENTRYDT,AGCD,DPCD,FRDT,TODT,USERID,CREATION_DATE,APP_USERID,APP_DT,
PUBL,EDTN,PROCESS_CRNO,PROCESS_CRDT,VAR_USERID,VAR_DT,SUP_AGCD,SUP_DPCD,UPDATE_BY,UPDATE_DT,BRANCH_TRFNO,BRANCH_TRFDT,
BRANCH_TRF_USERID,REF_DOCTYPE,REF_RECPTNO,REF_RECPTDT,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT_CODE,DOCTYPE,RECPTNO,RECPTDT,ENTRYDT,AGCD,DPCD,FRDT,TODT,USERID,CREATION_DATE,APP_USERID,APP_DT,
PUBL,EDTN,PROCESS_CRNO,PROCESS_CRDT,VAR_USERID,VAR_DT,SUP_AGCD,SUP_DPCD,UPDATE_BY,UPDATE_DT,BRANCH_TRFNO,BRANCH_TRFDT,
BRANCH_TRF_USERID,REF_DOCTYPE,REF_RECPTNO,REF_RECPTDT,isnull(UPDATE_BY,userid),getdate(),host_name()+'/'+@ip,'INSERT'
	from inserted
end


IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'
	
	INSERT INTO CIR_UNSOLD_HDR_LOG(COMP_CODE,UNIT_CODE,DOCTYPE,RECPTNO,RECPTDT,ENTRYDT,AGCD,DPCD,FRDT,TODT,USERID,CREATION_DATE,APP_USERID,APP_DT,
PUBL,EDTN,PROCESS_CRNO,PROCESS_CRDT,VAR_USERID,VAR_DT,SUP_AGCD,SUP_DPCD,UPDATE_BY,UPDATE_DT,BRANCH_TRFNO,BRANCH_TRFDT,
BRANCH_TRF_USERID,REF_DOCTYPE,REF_RECPTNO,REF_RECPTDT,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT_CODE,DOCTYPE,RECPTNO,RECPTDT,ENTRYDT,AGCD,DPCD,FRDT,TODT,USERID,CREATION_DATE,APP_USERID,APP_DT,
PUBL,EDTN,PROCESS_CRNO,PROCESS_CRDT,VAR_USERID,VAR_DT,SUP_AGCD,SUP_DPCD,UPDATE_BY,UPDATE_DT,BRANCH_TRFNO,BRANCH_TRFDT,
BRANCH_TRF_USERID,REF_DOCTYPE,REF_RECPTNO,REF_RECPTDT,isnull(UPDATE_BY,userid),getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_UNSOLD_HDR_LOG(COMP_CODE,UNIT_CODE,DOCTYPE,RECPTNO,RECPTDT,ENTRYDT,AGCD,DPCD,FRDT,TODT,USERID,CREATION_DATE,APP_USERID,APP_DT,
PUBL,EDTN,PROCESS_CRNO,PROCESS_CRDT,VAR_USERID,VAR_DT,SUP_AGCD,SUP_DPCD,UPDATE_BY,UPDATE_DT,BRANCH_TRFNO,BRANCH_TRFDT,
BRANCH_TRF_USERID,REF_DOCTYPE,REF_RECPTNO,REF_RECPTDT,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT_CODE,DOCTYPE,RECPTNO,RECPTDT,ENTRYDT,AGCD,DPCD,FRDT,TODT,USERID,CREATION_DATE,APP_USERID,APP_DT,
PUBL,EDTN,PROCESS_CRNO,PROCESS_CRDT,VAR_USERID,VAR_DT,SUP_AGCD,SUP_DPCD,UPDATE_BY,UPDATE_DT,BRANCH_TRFNO,BRANCH_TRFDT,
BRANCH_TRF_USERID,REF_DOCTYPE,REF_RECPTNO,REF_RECPTDT,isnull(UPDATE_BY,userid),getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'
	INSERT INTO CIR_UNSOLD_HDR_LOG(COMP_CODE,UNIT_CODE,DOCTYPE,RECPTNO,RECPTDT,ENTRYDT,AGCD,DPCD,FRDT,TODT,USERID,CREATION_DATE,APP_USERID,APP_DT,
PUBL,EDTN,PROCESS_CRNO,PROCESS_CRDT,VAR_USERID,VAR_DT,SUP_AGCD,SUP_DPCD,UPDATE_BY,UPDATE_DT,BRANCH_TRFNO,BRANCH_TRFDT,
BRANCH_TRF_USERID,REF_DOCTYPE,REF_RECPTNO,REF_RECPTDT,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT_CODE,DOCTYPE,RECPTNO,RECPTDT,ENTRYDT,AGCD,DPCD,FRDT,TODT,USERID,CREATION_DATE,APP_USERID,APP_DT,
PUBL,EDTN,PROCESS_CRNO,PROCESS_CRDT,VAR_USERID,VAR_DT,SUP_AGCD,SUP_DPCD,UPDATE_BY,UPDATE_DT,BRANCH_TRFNO,BRANCH_TRFDT,
BRANCH_TRF_USERID,REF_DOCTYPE,REF_RECPTNO,REF_RECPTDT,isnull(UPDATE_BY,userid),getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end








////////////////


ALTER TRIGGER [dbo].[CIR_UNSOLD_DTL_RECORD_LOG] ON [dbo].[CIR_UNSOLD_DTL] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;

 
IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'

	INSERT INTO CIR_UNSOLD_DTL_LOG(COMP_CODE,UNIT_CODE,DOCTYPE,RECPTNO,RECPTDT,ENTRYDT,AGCD,DPCD,SUPDATE,SHORT_RECPT,LATE_RECPT,BNR,UNSOLD,
APR_SHORT_RECPT,APR_LATE_RECPT,APR_BNR,APR_UNSOLD,USERID,CREATION_DATE,COPY_RATE,COMM_RATE,WASTE_ALW,WASTE_RATE,COPY_AMT,COMM_AMT,
WASTE_AMT,APP_USERID,APP_DT,PUBL,EDTN,SUPPLY_COPY,RATE_SUPPLY,BRANCH_CODE,COMM_CATG_TYPE,PROCESS_CRNO,PROCESS_CRDT,
temp_id,RETURN_PER,DAMAGE,APR_DAMAGE,VAR_SHORT_RECPT,VAR_LATE_RECPT,VAR_BNR,VAR_UNSOLD,VAR_DAMAGE,VAR_USERID,
VAR_DT,SUP_AGCD,SUP_DPCD,UPDATE_BY,UPDATE_DT,NO_OF_PACKET,REF_DOCTYPE,REF_RECPTNO,REF_RECPTDT,PER_COPY_WT,UNSOLD_WT,
LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT_CODE,DOCTYPE,RECPTNO,RECPTDT,ENTRYDT,AGCD,DPCD,SUPDATE,SHORT_RECPT,LATE_RECPT,BNR,UNSOLD,APR_SHORT_RECPT,
APR_LATE_RECPT,APR_BNR,APR_UNSOLD,USERID,CREATION_DATE,COPY_RATE,COMM_RATE,WASTE_ALW,WASTE_RATE,COPY_AMT,COMM_AMT,
WASTE_AMT,APP_USERID,APP_DT,PUBL,EDTN,SUPPLY_COPY,RATE_SUPPLY,BRANCH_CODE,COMM_CATG_TYPE,PROCESS_CRNO,PROCESS_CRDT,
temp_id,RETURN_PER,DAMAGE,APR_DAMAGE,VAR_SHORT_RECPT,VAR_LATE_RECPT,VAR_BNR,VAR_UNSOLD,VAR_DAMAGE,VAR_USERID,
VAR_DT,SUP_AGCD,SUP_DPCD,UPDATE_BY,UPDATE_DT,NO_OF_PACKET,REF_DOCTYPE,REF_RECPTNO,REF_RECPTDT,PER_COPY_WT,UNSOLD_WT,isnull(UPDATE_BY,userid),
getdate(),host_name()+'/'+@ip,'INSERT'
	from inserted
end
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'
	
	INSERT INTO CIR_UNSOLD_DTL_LOG(COMP_CODE,UNIT_CODE,DOCTYPE,RECPTNO,RECPTDT,ENTRYDT,AGCD,DPCD,SUPDATE,SHORT_RECPT,LATE_RECPT,BNR,UNSOLD,
APR_SHORT_RECPT,APR_LATE_RECPT,APR_BNR,APR_UNSOLD,USERID,CREATION_DATE,COPY_RATE,COMM_RATE,WASTE_ALW,WASTE_RATE,COPY_AMT,COMM_AMT,
WASTE_AMT,APP_USERID,APP_DT,PUBL,EDTN,SUPPLY_COPY,RATE_SUPPLY,BRANCH_CODE,COMM_CATG_TYPE,PROCESS_CRNO,PROCESS_CRDT,
temp_id,RETURN_PER,DAMAGE,APR_DAMAGE,VAR_SHORT_RECPT,VAR_LATE_RECPT,VAR_BNR,VAR_UNSOLD,VAR_DAMAGE,VAR_USERID,
VAR_DT,SUP_AGCD,SUP_DPCD,UPDATE_BY,UPDATE_DT,NO_OF_PACKET,REF_DOCTYPE,REF_RECPTNO,REF_RECPTDT,PER_COPY_WT,UNSOLD_WT,
LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT_CODE,DOCTYPE,RECPTNO,RECPTDT,ENTRYDT,AGCD,DPCD,SUPDATE,SHORT_RECPT,LATE_RECPT,BNR,UNSOLD,APR_SHORT_RECPT,
APR_LATE_RECPT,APR_BNR,APR_UNSOLD,USERID,CREATION_DATE,COPY_RATE,COMM_RATE,WASTE_ALW,WASTE_RATE,COPY_AMT,COMM_AMT,
WASTE_AMT,APP_USERID,APP_DT,PUBL,EDTN,SUPPLY_COPY,RATE_SUPPLY,BRANCH_CODE,COMM_CATG_TYPE,PROCESS_CRNO,PROCESS_CRDT,
temp_id,RETURN_PER,DAMAGE,APR_DAMAGE,VAR_SHORT_RECPT,VAR_LATE_RECPT,VAR_BNR,VAR_UNSOLD,VAR_DAMAGE,VAR_USERID,
VAR_DT,SUP_AGCD,SUP_DPCD,UPDATE_BY,UPDATE_DT,NO_OF_PACKET,REF_DOCTYPE,REF_RECPTNO,REF_RECPTDT,PER_COPY_WT,UNSOLD_WT,isnull(UPDATE_BY,userid),
getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_UNSOLD_DTL_LOG(COMP_CODE,UNIT_CODE,DOCTYPE,RECPTNO,RECPTDT,ENTRYDT,AGCD,DPCD,SUPDATE,SHORT_RECPT,LATE_RECPT,BNR,UNSOLD,APR_SHORT_RECPT,
APR_LATE_RECPT,APR_BNR,APR_UNSOLD,USERID,CREATION_DATE,COPY_RATE,COMM_RATE,WASTE_ALW,WASTE_RATE,COPY_AMT,COMM_AMT,
WASTE_AMT,APP_USERID,APP_DT,PUBL,EDTN,SUPPLY_COPY,RATE_SUPPLY,BRANCH_CODE,COMM_CATG_TYPE,PROCESS_CRNO,PROCESS_CRDT,
temp_id,RETURN_PER,DAMAGE,APR_DAMAGE,VAR_SHORT_RECPT,VAR_LATE_RECPT,VAR_BNR,VAR_UNSOLD,VAR_DAMAGE,VAR_USERID,
VAR_DT,SUP_AGCD,SUP_DPCD,UPDATE_BY,UPDATE_DT,NO_OF_PACKET,REF_DOCTYPE,REF_RECPTNO,REF_RECPTDT,PER_COPY_WT,UNSOLD_WT,
LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT_CODE,DOCTYPE,RECPTNO,RECPTDT,ENTRYDT,AGCD,DPCD,SUPDATE,SHORT_RECPT,LATE_RECPT,BNR,UNSOLD,APR_SHORT_RECPT,
APR_LATE_RECPT,APR_BNR,APR_UNSOLD,USERID,CREATION_DATE,COPY_RATE,COMM_RATE,WASTE_ALW,WASTE_RATE,COPY_AMT,COMM_AMT,
WASTE_AMT,APP_USERID,APP_DT,PUBL,EDTN,SUPPLY_COPY,RATE_SUPPLY,BRANCH_CODE,COMM_CATG_TYPE,PROCESS_CRNO,PROCESS_CRDT,
temp_id,RETURN_PER,DAMAGE,APR_DAMAGE,VAR_SHORT_RECPT,VAR_LATE_RECPT,VAR_BNR,VAR_UNSOLD,VAR_DAMAGE,VAR_USERID,
VAR_DT,SUP_AGCD,SUP_DPCD,UPDATE_BY,UPDATE_DT,NO_OF_PACKET,REF_DOCTYPE,REF_RECPTNO,REF_RECPTDT,PER_COPY_WT,UNSOLD_WT,isnull(UPDATE_BY,userid),
getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'
	INSERT INTO CIR_UNSOLD_DTL_LOG(COMP_CODE,UNIT_CODE,DOCTYPE,RECPTNO,RECPTDT,ENTRYDT,AGCD,DPCD,SUPDATE,SHORT_RECPT,LATE_RECPT,BNR,UNSOLD,APR_SHORT_RECPT,
APR_LATE_RECPT,APR_BNR,APR_UNSOLD,USERID,CREATION_DATE,COPY_RATE,COMM_RATE,WASTE_ALW,WASTE_RATE,COPY_AMT,COMM_AMT,
WASTE_AMT,APP_USERID,APP_DT,PUBL,EDTN,SUPPLY_COPY,RATE_SUPPLY,BRANCH_CODE,COMM_CATG_TYPE,PROCESS_CRNO,PROCESS_CRDT,
temp_id,RETURN_PER,DAMAGE,APR_DAMAGE,VAR_SHORT_RECPT,VAR_LATE_RECPT,VAR_BNR,VAR_UNSOLD,VAR_DAMAGE,VAR_USERID,
VAR_DT,SUP_AGCD,SUP_DPCD,UPDATE_BY,UPDATE_DT,NO_OF_PACKET,REF_DOCTYPE,REF_RECPTNO,REF_RECPTDT,PER_COPY_WT,UNSOLD_WT,
LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT_CODE,DOCTYPE,RECPTNO,RECPTDT,ENTRYDT,AGCD,DPCD,SUPDATE,SHORT_RECPT,LATE_RECPT,BNR,UNSOLD,APR_SHORT_RECPT,
APR_LATE_RECPT,APR_BNR,APR_UNSOLD,USERID,CREATION_DATE,COPY_RATE,COMM_RATE,WASTE_ALW,WASTE_RATE,COPY_AMT,COMM_AMT,
WASTE_AMT,APP_USERID,APP_DT,PUBL,EDTN,SUPPLY_COPY,RATE_SUPPLY,BRANCH_CODE,COMM_CATG_TYPE,PROCESS_CRNO,PROCESS_CRDT,
temp_id,RETURN_PER,DAMAGE,APR_DAMAGE,VAR_SHORT_RECPT,VAR_LATE_RECPT,VAR_BNR,VAR_UNSOLD,VAR_DAMAGE,VAR_USERID,
VAR_DT,SUP_AGCD,SUP_DPCD,UPDATE_BY,UPDATE_DT,NO_OF_PACKET,REF_DOCTYPE,REF_RECPTNO,REF_RECPTDT,PER_COPY_WT,UNSOLD_WT,isnull(UPDATE_BY,userid),
getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end













//////


ALTER TRIGGER [dbo].[CIR_SUPPLY_LOG_RECORD_LOG] ON [dbo].[CIR_SUPPLY] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;

IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'


	INSERT INTO CIR_SUPPLY_LOG(COMP_CODE,UNIT,AGCD,DPCD,PUBL,EDTN,SUPPLY_FLAG,SUPPLY_TYPE_CODE,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,SUPPLY_WED,SUPPLY_THU,
SUPPLY_FRI,SUPPLY_SAT,DEVATION_SUPPLY,COMM_FLAG,COMM_CODE,PACKET_SIZE,ROUTE_CODE,SUBROUTE_CODE,SUB_SUBROUTE_CODE,USERID,CREATION_DATE,
SUPPLY_SPL1,SUPPLY_SPL2,SURCH_CD,SUB_EDTN,LBL_PRINTNO,UPDATED_BY,UPDATED_DT,BILLING_CYCLE,INSERTION_FEE,WASTE_CATG_CODE,SP_SUPPLY_MON1,
SP_SUPPLY_TUE1,SP_SUPPLY_WED1,SP_SUPPLY_THU1,SP_SUPPLY_FRI1,SP_SUPPLY_SAT1,SP_SUPPLY_SUN1,SP_SUPPLY_MON2,SP_SUPPLY_TUE2,SP_SUPPLY_WED2,
SP_SUPPLY_THU2,SP_SUPPLY_FRI2,SP_SUPPLY_SAT2,SP_SUPPLY_SUN2,LATE_FEE,INCENTIVE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT,AGCD,DPCD,PUBL,EDTN,SUPPLY_FLAG,SUPPLY_TYPE_CODE,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,SUPPLY_WED,SUPPLY_THU,
SUPPLY_FRI,SUPPLY_SAT,DEVATION_SUPPLY,COMM_FLAG,COMM_CODE,PACKET_SIZE,ROUTE_CODE,SUBROUTE_CODE,SUB_SUBROUTE_CODE,USERID,CREATION_DATE,
SUPPLY_SPL1,SUPPLY_SPL2,SURCH_CD,SUB_EDTN,LBL_PRINTNO,UPDATED_BY,UPDATED_DT,BILLING_CYCLE,INSERTION_FEE,WASTE_CATG_CODE,SP_SUPPLY_MON1,
SP_SUPPLY_TUE1,SP_SUPPLY_WED1,SP_SUPPLY_THU1,SP_SUPPLY_FRI1,SP_SUPPLY_SAT1,SP_SUPPLY_SUN1,SP_SUPPLY_MON2,SP_SUPPLY_TUE2,SP_SUPPLY_WED2,
SP_SUPPLY_THU2,SP_SUPPLY_FRI2,SP_SUPPLY_SAT2,SP_SUPPLY_SUN2,LATE_FEE,INCENTIVE,isnull(UPDATED_BY,userid),getdate(),host_name()+'/'+@ip,'INSERT'
	from inserted
	
end
 
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'
	
	INSERT INTO CIR_SUPPLY_LOG(COMP_CODE,UNIT,AGCD,DPCD,PUBL,EDTN,SUPPLY_FLAG,SUPPLY_TYPE_CODE,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,SUPPLY_WED,SUPPLY_THU,
SUPPLY_FRI,SUPPLY_SAT,DEVATION_SUPPLY,COMM_FLAG,COMM_CODE,PACKET_SIZE,ROUTE_CODE,SUBROUTE_CODE,SUB_SUBROUTE_CODE,USERID,CREATION_DATE,
SUPPLY_SPL1,SUPPLY_SPL2,SURCH_CD,SUB_EDTN,LBL_PRINTNO,UPDATED_BY,UPDATED_DT,BILLING_CYCLE,INSERTION_FEE,WASTE_CATG_CODE,SP_SUPPLY_MON1,
SP_SUPPLY_TUE1,SP_SUPPLY_WED1,SP_SUPPLY_THU1,SP_SUPPLY_FRI1,SP_SUPPLY_SAT1,SP_SUPPLY_SUN1,SP_SUPPLY_MON2,SP_SUPPLY_TUE2,SP_SUPPLY_WED2,
SP_SUPPLY_THU2,SP_SUPPLY_FRI2,SP_SUPPLY_SAT2,SP_SUPPLY_SUN2,LATE_FEE,INCENTIVE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT,AGCD,DPCD,PUBL,EDTN,SUPPLY_FLAG,SUPPLY_TYPE_CODE,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,SUPPLY_WED,SUPPLY_THU,
SUPPLY_FRI,SUPPLY_SAT,DEVATION_SUPPLY,COMM_FLAG,COMM_CODE,PACKET_SIZE,ROUTE_CODE,SUBROUTE_CODE,SUB_SUBROUTE_CODE,USERID,CREATION_DATE,
SUPPLY_SPL1,SUPPLY_SPL2,SURCH_CD,SUB_EDTN,LBL_PRINTNO,UPDATED_BY,UPDATED_DT,BILLING_CYCLE,INSERTION_FEE,WASTE_CATG_CODE,SP_SUPPLY_MON1,
SP_SUPPLY_TUE1,SP_SUPPLY_WED1,SP_SUPPLY_THU1,SP_SUPPLY_FRI1,SP_SUPPLY_SAT1,SP_SUPPLY_SUN1,SP_SUPPLY_MON2,SP_SUPPLY_TUE2,SP_SUPPLY_WED2,
SP_SUPPLY_THU2,SP_SUPPLY_FRI2,SP_SUPPLY_SAT2,SP_SUPPLY_SUN2,LATE_FEE,INCENTIVE,isnull(UPDATED_BY,userid),getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_SUPPLY_LOG(COMP_CODE,UNIT,AGCD,DPCD,PUBL,EDTN,SUPPLY_FLAG,SUPPLY_TYPE_CODE,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,SUPPLY_WED,SUPPLY_THU,
SUPPLY_FRI,SUPPLY_SAT,DEVATION_SUPPLY,COMM_FLAG,COMM_CODE,PACKET_SIZE,ROUTE_CODE,SUBROUTE_CODE,SUB_SUBROUTE_CODE,USERID,CREATION_DATE,
SUPPLY_SPL1,SUPPLY_SPL2,SURCH_CD,SUB_EDTN,LBL_PRINTNO,UPDATED_BY,UPDATED_DT,BILLING_CYCLE,INSERTION_FEE,WASTE_CATG_CODE,SP_SUPPLY_MON1,
SP_SUPPLY_TUE1,SP_SUPPLY_WED1,SP_SUPPLY_THU1,SP_SUPPLY_FRI1,SP_SUPPLY_SAT1,SP_SUPPLY_SUN1,SP_SUPPLY_MON2,SP_SUPPLY_TUE2,SP_SUPPLY_WED2,
SP_SUPPLY_THU2,SP_SUPPLY_FRI2,SP_SUPPLY_SAT2,SP_SUPPLY_SUN2,LATE_FEE,INCENTIVE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT,AGCD,DPCD,PUBL,EDTN,SUPPLY_FLAG,SUPPLY_TYPE_CODE,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,SUPPLY_WED,SUPPLY_THU,
SUPPLY_FRI,SUPPLY_SAT,DEVATION_SUPPLY,COMM_FLAG,COMM_CODE,PACKET_SIZE,ROUTE_CODE,SUBROUTE_CODE,SUB_SUBROUTE_CODE,USERID,CREATION_DATE,
SUPPLY_SPL1,SUPPLY_SPL2,SURCH_CD,SUB_EDTN,LBL_PRINTNO,UPDATED_BY,UPDATED_DT,BILLING_CYCLE,INSERTION_FEE,WASTE_CATG_CODE,SP_SUPPLY_MON1,
SP_SUPPLY_TUE1,SP_SUPPLY_WED1,SP_SUPPLY_THU1,SP_SUPPLY_FRI1,SP_SUPPLY_SAT1,SP_SUPPLY_SUN1,SP_SUPPLY_MON2,SP_SUPPLY_TUE2,SP_SUPPLY_WED2,
SP_SUPPLY_THU2,SP_SUPPLY_FRI2,SP_SUPPLY_SAT2,SP_SUPPLY_SUN2,LATE_FEE,INCENTIVE,isnull(UPDATED_BY,userid),getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'
	INSERT INTO CIR_SUPPLY_LOG(COMP_CODE,UNIT,AGCD,DPCD,PUBL,EDTN,SUPPLY_FLAG,SUPPLY_TYPE_CODE,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,SUPPLY_WED,SUPPLY_THU,
SUPPLY_FRI,SUPPLY_SAT,DEVATION_SUPPLY,COMM_FLAG,COMM_CODE,PACKET_SIZE,ROUTE_CODE,SUBROUTE_CODE,SUB_SUBROUTE_CODE,USERID,CREATION_DATE,
SUPPLY_SPL1,SUPPLY_SPL2,SURCH_CD,SUB_EDTN,LBL_PRINTNO,UPDATED_BY,UPDATED_DT,BILLING_CYCLE,INSERTION_FEE,WASTE_CATG_CODE,SP_SUPPLY_MON1,
SP_SUPPLY_TUE1,SP_SUPPLY_WED1,SP_SUPPLY_THU1,SP_SUPPLY_FRI1,SP_SUPPLY_SAT1,SP_SUPPLY_SUN1,SP_SUPPLY_MON2,SP_SUPPLY_TUE2,SP_SUPPLY_WED2,
SP_SUPPLY_THU2,SP_SUPPLY_FRI2,SP_SUPPLY_SAT2,SP_SUPPLY_SUN2,LATE_FEE,INCENTIVE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT,AGCD,DPCD,PUBL,EDTN,SUPPLY_FLAG,SUPPLY_TYPE_CODE,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,SUPPLY_WED,SUPPLY_THU,
SUPPLY_FRI,SUPPLY_SAT,DEVATION_SUPPLY,COMM_FLAG,COMM_CODE,PACKET_SIZE,ROUTE_CODE,SUBROUTE_CODE,SUB_SUBROUTE_CODE,USERID,CREATION_DATE,
SUPPLY_SPL1,SUPPLY_SPL2,SURCH_CD,SUB_EDTN,LBL_PRINTNO,UPDATED_BY,UPDATED_DT,BILLING_CYCLE,INSERTION_FEE,WASTE_CATG_CODE,SP_SUPPLY_MON1,
SP_SUPPLY_TUE1,SP_SUPPLY_WED1,SP_SUPPLY_THU1,SP_SUPPLY_FRI1,SP_SUPPLY_SAT1,SP_SUPPLY_SUN1,SP_SUPPLY_MON2,SP_SUPPLY_TUE2,SP_SUPPLY_WED2,
SP_SUPPLY_THU2,SP_SUPPLY_FRI2,SP_SUPPLY_SAT2,SP_SUPPLY_SUN2,LATE_FEE,INCENTIVE,isnull(UPDATED_BY,userid),getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end
















//////////////////


ALTER TRIGGER [dbo].[CIR_DBKSUP_LOG_RECORD_LOG] ON [dbo].[CIR_DBKSUP] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;


IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'
INSERT INTO CIR_DBKSUP_LOG(COMP_CODE,UNIT_CODE,PUBL,EDTN,AGCD,DPCD,SUPDATE,SUP_TYPE_CODE,SUP_COPY,AGENCY_TY_CODE,AGENCY_PKT_SIZE,COMM_CODE,
COMM_FIX_AUTO_SPL,SUP_RATE,BILLAGCD,BILLDPCD,ROUTE_CODE,SUBROUTE_CODE,SUBSUBROUTE_CODE,USERID,CREATION_DATE,SURCH_CD,
ISSUE_DATE,RETURN_COPY_SALE,FINAL_SUPPLY_FLAG,UPDATED_BY,UPDATED_DT,PER_COPY_WEIGHT,WASTE_CATG_CODE,LOG_USER,
LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT_CODE,PUBL,EDTN,AGCD,DPCD,SUPDATE,SUP_TYPE_CODE,SUP_COPY,AGENCY_TY_CODE,AGENCY_PKT_SIZE,COMM_CODE,
COMM_FIX_AUTO_SPL,SUP_RATE,BILLAGCD,BILLDPCD,ROUTE_CODE,SUBROUTE_CODE,SUBSUBROUTE_CODE,USERID,CREATION_DATE,SURCH_CD,
ISSUE_DATE,RETURN_COPY_SALE,FINAL_SUPPLY_FLAG,UPDATED_BY,UPDATED_DT,PER_COPY_WEIGHT,WASTE_CATG_CODE,isnull(UPDATED_BY,userid),getdate(),host_name()+'/'+@ip,'INSERT'
	from inserted
end
 
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'
	
	INSERT INTO CIR_DBKSUP_LOG(COMP_CODE,UNIT_CODE,PUBL,EDTN,AGCD,DPCD,SUPDATE,SUP_TYPE_CODE,SUP_COPY,AGENCY_TY_CODE,AGENCY_PKT_SIZE,COMM_CODE,
COMM_FIX_AUTO_SPL,SUP_RATE,BILLAGCD,BILLDPCD,ROUTE_CODE,SUBROUTE_CODE,SUBSUBROUTE_CODE,USERID,CREATION_DATE,SURCH_CD,
ISSUE_DATE,RETURN_COPY_SALE,FINAL_SUPPLY_FLAG,UPDATED_BY,UPDATED_DT,PER_COPY_WEIGHT,WASTE_CATG_CODE,LOG_USER,
LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT_CODE,PUBL,EDTN,AGCD,DPCD,SUPDATE,SUP_TYPE_CODE,SUP_COPY,AGENCY_TY_CODE,AGENCY_PKT_SIZE,COMM_CODE,
COMM_FIX_AUTO_SPL,SUP_RATE,BILLAGCD,BILLDPCD,ROUTE_CODE,SUBROUTE_CODE,SUBSUBROUTE_CODE,USERID,CREATION_DATE,SURCH_CD,
ISSUE_DATE,RETURN_COPY_SALE,FINAL_SUPPLY_FLAG,UPDATED_BY,UPDATED_DT,PER_COPY_WEIGHT,WASTE_CATG_CODE,isnull(UPDATED_BY,userid),getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_DBKSUP_LOG(COMP_CODE,UNIT_CODE,PUBL,EDTN,AGCD,DPCD,SUPDATE,SUP_TYPE_CODE,SUP_COPY,AGENCY_TY_CODE,AGENCY_PKT_SIZE,COMM_CODE,
COMM_FIX_AUTO_SPL,SUP_RATE,BILLAGCD,BILLDPCD,ROUTE_CODE,SUBROUTE_CODE,SUBSUBROUTE_CODE,USERID,CREATION_DATE,SURCH_CD,
ISSUE_DATE,RETURN_COPY_SALE,FINAL_SUPPLY_FLAG,UPDATED_BY,UPDATED_DT,PER_COPY_WEIGHT,WASTE_CATG_CODE,LOG_USER,
LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT_CODE,PUBL,EDTN,AGCD,DPCD,SUPDATE,SUP_TYPE_CODE,SUP_COPY,AGENCY_TY_CODE,AGENCY_PKT_SIZE,COMM_CODE,
COMM_FIX_AUTO_SPL,SUP_RATE,BILLAGCD,BILLDPCD,ROUTE_CODE,SUBROUTE_CODE,SUBSUBROUTE_CODE,USERID,CREATION_DATE,SURCH_CD,
ISSUE_DATE,RETURN_COPY_SALE,FINAL_SUPPLY_FLAG,UPDATED_BY,UPDATED_DT,PER_COPY_WEIGHT,WASTE_CATG_CODE,isnull(UPDATED_BY,userid),getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'
	INSERT INTO CIR_DBKSUP_LOG(COMP_CODE,UNIT_CODE,PUBL,EDTN,AGCD,DPCD,SUPDATE,SUP_TYPE_CODE,SUP_COPY,AGENCY_TY_CODE,AGENCY_PKT_SIZE,COMM_CODE,
COMM_FIX_AUTO_SPL,SUP_RATE,BILLAGCD,BILLDPCD,ROUTE_CODE,SUBROUTE_CODE,SUBSUBROUTE_CODE,USERID,CREATION_DATE,SURCH_CD,
ISSUE_DATE,RETURN_COPY_SALE,FINAL_SUPPLY_FLAG,UPDATED_BY,UPDATED_DT,PER_COPY_WEIGHT,WASTE_CATG_CODE,LOG_USER,
LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT_CODE,PUBL,EDTN,AGCD,DPCD,SUPDATE,SUP_TYPE_CODE,SUP_COPY,AGENCY_TY_CODE,AGENCY_PKT_SIZE,COMM_CODE,
COMM_FIX_AUTO_SPL,SUP_RATE,BILLAGCD,BILLDPCD,ROUTE_CODE,SUBROUTE_CODE,SUBSUBROUTE_CODE,USERID,CREATION_DATE,SURCH_CD,
ISSUE_DATE,RETURN_COPY_SALE,FINAL_SUPPLY_FLAG,UPDATED_BY,UPDATED_DT,PER_COPY_WEIGHT,WASTE_CATG_CODE,isnull(UPDATED_BY,userid),getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end























///////////////////////

ALTER TRIGGER [dbo].[CIR_WASTE_CATG_MAST_LOG_RECORD_LOG] ON [dbo].[CIR_WASTE_CATG_MAST] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;

 IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'
	INSERT INTO CIR_WASTE_CATG_MAST_LOG(COMP_CODE,CATG_CODE,CATEG_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,STATUS,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,CATG_CODE,CATEG_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,STATUS,isnull(UPDATED_BY,CREATED_BY),getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_WASTE_CATG_MAST_LOG(COMP_CODE,CATG_CODE,CATEG_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,STATUS,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,CATG_CODE,CATEG_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,STATUS,isnull(UPDATED_BY,CREATED_BY),getdate(),host_name()+'/'+@ip,'INSERT'
	from deleted
end
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'
	
	INSERT INTO CIR_WASTE_CATG_MAST_LOG(COMP_CODE,CATG_CODE,CATEG_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,STATUS,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,CATG_CODE,CATEG_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,STATUS,isnull(UPDATED_BY,CREATED_BY),getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_WASTE_CATG_MAST_LOG(COMP_CODE,CATG_CODE,CATEG_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,STATUS,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,CATG_CODE,CATEG_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,STATUS,isnull(UPDATED_BY,CREATED_BY),getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'
	INSERT INTO CIR_WASTE_CATG_MAST_LOG(COMP_CODE,CATG_CODE,CATEG_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,STATUS,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,CATG_CODE,CATEG_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,STATUS,isnull(UPDATED_BY,CREATED_BY),getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end



//////////


ALTER TRIGGER [dbo].[CIR_WASTE_RATE_MAST_LOG_RECORD_LOG] ON [dbo].[CIR_WASTE_RATE_MAST] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;

 IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'
INSERT INTO CIR_WASTE_RATE_MAST_LOG(COMP_CODE,UNIT_CODE,PUBL,EDTN,MON_RATE,TUE_RATE,WED_RATE,THU_RATE,FRI_RATE,SAT_RATE,SUN_RATE,VALID_FROM,FREEZE_FLAG,CREATIED_BY,
CREATIED_DATE,CHANGED_BY,CHANGED_DATE,WASTE_CATG_CODE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT_CODE,PUBL,EDTN,MON_RATE,TUE_RATE,WED_RATE,THU_RATE,FRI_RATE,SAT_RATE,SUN_RATE,VALID_FROM,FREEZE_FLAG,CREATIED_BY,
CREATIED_DATE,CHANGED_BY,CHANGED_DATE,WASTE_CATG_CODE,isnull(CHANGED_BY,CREATIED_BY),getdate(),host_name()+'/'+@ip,'INSERT'
	from inserted
end
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'
	
	INSERT INTO CIR_WASTE_RATE_MAST_LOG(COMP_CODE,UNIT_CODE,PUBL,EDTN,MON_RATE,TUE_RATE,WED_RATE,THU_RATE,FRI_RATE,SAT_RATE,SUN_RATE,VALID_FROM,FREEZE_FLAG,CREATIED_BY,
CREATIED_DATE,CHANGED_BY,CHANGED_DATE,WASTE_CATG_CODE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT_CODE,PUBL,EDTN,MON_RATE,TUE_RATE,WED_RATE,THU_RATE,FRI_RATE,SAT_RATE,SUN_RATE,VALID_FROM,FREEZE_FLAG,CREATIED_BY,
CREATIED_DATE,CHANGED_BY,CHANGED_DATE,WASTE_CATG_CODE,isnull(CHANGED_BY,CREATIED_BY),getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_WASTE_RATE_MAST_LOG(COMP_CODE,UNIT_CODE,PUBL,EDTN,MON_RATE,TUE_RATE,WED_RATE,THU_RATE,FRI_RATE,SAT_RATE,SUN_RATE,VALID_FROM,FREEZE_FLAG,CREATIED_BY,
CREATIED_DATE,CHANGED_BY,CHANGED_DATE,WASTE_CATG_CODE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT_CODE,PUBL,EDTN,MON_RATE,TUE_RATE,WED_RATE,THU_RATE,FRI_RATE,SAT_RATE,SUN_RATE,VALID_FROM,FREEZE_FLAG,CREATIED_BY,
CREATIED_DATE,CHANGED_BY,CHANGED_DATE,WASTE_CATG_CODE,isnull(CHANGED_BY,CREATIED_BY),getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'
	INSERT INTO CIR_WASTE_RATE_MAST_LOG(COMP_CODE,UNIT_CODE,PUBL,EDTN,MON_RATE,TUE_RATE,WED_RATE,THU_RATE,FRI_RATE,SAT_RATE,SUN_RATE,VALID_FROM,FREEZE_FLAG,CREATIED_BY,
CREATIED_DATE,CHANGED_BY,CHANGED_DATE,WASTE_CATG_CODE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT_CODE,PUBL,EDTN,MON_RATE,TUE_RATE,WED_RATE,THU_RATE,FRI_RATE,SAT_RATE,SUN_RATE,VALID_FROM,FREEZE_FLAG,CREATIED_BY,
CREATIED_DATE,CHANGED_BY,CHANGED_DATE,WASTE_CATG_CODE,isnull(CHANGED_BY,CREATIED_BY),getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end
////////////////////

ALTER TRIGGER [dbo].[CIR_WASTE_CATG_MAST_LOG_RECORD_LOG] ON [dbo].[CIR_WASTE_CATG_MAST] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;

 IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'
	INSERT INTO CIR_WASTE_CATG_MAST_LOG(COMP_CODE,CATG_CODE,CATEG_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,STATUS,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,CATG_CODE,CATEG_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,STATUS,isnull(UPDATED_BY,CREATED_BY),getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_WASTE_CATG_MAST_LOG(COMP_CODE,CATG_CODE,CATEG_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,STATUS,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,CATG_CODE,CATEG_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,STATUS,isnull(UPDATED_BY,CREATED_BY),getdate(),host_name()+'/'+@ip,'INSERT'
	from deleted
end
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'
	
	INSERT INTO CIR_WASTE_CATG_MAST_LOG(COMP_CODE,CATG_CODE,CATEG_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,STATUS,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,CATG_CODE,CATEG_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,STATUS,isnull(UPDATED_BY,CREATED_BY),getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_WASTE_CATG_MAST_LOG(COMP_CODE,CATG_CODE,CATEG_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,STATUS,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,CATG_CODE,CATEG_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,STATUS,isnull(UPDATED_BY,CREATED_BY),getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'
	INSERT INTO CIR_WASTE_CATG_MAST_LOG(COMP_CODE,CATG_CODE,CATEG_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,STATUS,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,CATG_CODE,CATEG_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,STATUS,isnull(UPDATED_BY,CREATED_BY),getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end



///////////////////


ALTER TRIGGER [dbo].[CIR_WASTE_RATE_MAST_LOG_RECORD_LOG] ON [dbo].[CIR_WASTE_RATE_MAST] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;

 IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'
INSERT INTO CIR_WASTE_RATE_MAST_LOG(COMP_CODE,UNIT_CODE,PUBL,EDTN,MON_RATE,TUE_RATE,WED_RATE,THU_RATE,FRI_RATE,SAT_RATE,SUN_RATE,VALID_FROM,FREEZE_FLAG,CREATIED_BY,
CREATIED_DATE,CHANGED_BY,CHANGED_DATE,WASTE_CATG_CODE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT_CODE,PUBL,EDTN,MON_RATE,TUE_RATE,WED_RATE,THU_RATE,FRI_RATE,SAT_RATE,SUN_RATE,VALID_FROM,FREEZE_FLAG,CREATIED_BY,
CREATIED_DATE,CHANGED_BY,CHANGED_DATE,WASTE_CATG_CODE,isnull(CHANGED_BY,CREATIED_BY),getdate(),host_name()+'/'+@ip,'INSERT'
	from inserted
end
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'
	
	INSERT INTO CIR_WASTE_RATE_MAST_LOG(COMP_CODE,UNIT_CODE,PUBL,EDTN,MON_RATE,TUE_RATE,WED_RATE,THU_RATE,FRI_RATE,SAT_RATE,SUN_RATE,VALID_FROM,FREEZE_FLAG,CREATIED_BY,
CREATIED_DATE,CHANGED_BY,CHANGED_DATE,WASTE_CATG_CODE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT_CODE,PUBL,EDTN,MON_RATE,TUE_RATE,WED_RATE,THU_RATE,FRI_RATE,SAT_RATE,SUN_RATE,VALID_FROM,FREEZE_FLAG,CREATIED_BY,
CREATIED_DATE,CHANGED_BY,CHANGED_DATE,WASTE_CATG_CODE,isnull(CHANGED_BY,CREATIED_BY),getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_WASTE_RATE_MAST_LOG(COMP_CODE,UNIT_CODE,PUBL,EDTN,MON_RATE,TUE_RATE,WED_RATE,THU_RATE,FRI_RATE,SAT_RATE,SUN_RATE,VALID_FROM,FREEZE_FLAG,CREATIED_BY,
CREATIED_DATE,CHANGED_BY,CHANGED_DATE,WASTE_CATG_CODE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT_CODE,PUBL,EDTN,MON_RATE,TUE_RATE,WED_RATE,THU_RATE,FRI_RATE,SAT_RATE,SUN_RATE,VALID_FROM,FREEZE_FLAG,CREATIED_BY,
CREATIED_DATE,CHANGED_BY,CHANGED_DATE,WASTE_CATG_CODE,isnull(CHANGED_BY,CREATIED_BY),getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'
	INSERT INTO CIR_WASTE_RATE_MAST_LOG(COMP_CODE,UNIT_CODE,PUBL,EDTN,MON_RATE,TUE_RATE,WED_RATE,THU_RATE,FRI_RATE,SAT_RATE,SUN_RATE,VALID_FROM,FREEZE_FLAG,CREATIED_BY,
CREATIED_DATE,CHANGED_BY,CHANGED_DATE,WASTE_CATG_CODE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT_CODE,PUBL,EDTN,MON_RATE,TUE_RATE,WED_RATE,THU_RATE,FRI_RATE,SAT_RATE,SUN_RATE,VALID_FROM,FREEZE_FLAG,CREATIED_BY,
CREATIED_DATE,CHANGED_BY,CHANGED_DATE,WASTE_CATG_CODE,isnull(CHANGED_BY,CREATIED_BY),getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end
//////////////

ALTER TRIGGER [dbo].[CIR_BANK_GUARANTEE_LOG_RECORD_LOG] ON [dbo].[CIR_BANK_GUARANTEE] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;


 
 IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'
INSERT INTO CIR_BANK_GUARANTEE_LOG(COMP_CODE,UNIT_CODE,AGCD,DPCD,BG_NO,BG_AMT,BG_DATE,BG_VALID,BANK_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,
BKUP_SNO,BG_TYPE,BG_ATTACH,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT_CODE,AGCD,DPCD,BG_NO,BG_AMT,BG_DATE,BG_VALID,BANK_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,
BKUP_SNO,BG_TYPE,BG_ATTACH,ISNULL(UPDATED_BY,CREATED_BY),getdate(),host_name()+'/'+@ip,'INSERT'
	from inserted
end
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'

	INSERT INTO CIR_BANK_GUARANTEE_LOG(COMP_CODE,UNIT_CODE,AGCD,DPCD,BG_NO,BG_AMT,BG_DATE,BG_VALID,BANK_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,
BKUP_SNO,BG_TYPE,BG_ATTACH,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT_CODE,AGCD,DPCD,BG_NO,BG_AMT,BG_DATE,BG_VALID,BANK_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,
BKUP_SNO,BG_TYPE,BG_ATTACH,ISNULL(UPDATED_BY,CREATED_BY),getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_BANK_GUARANTEE_LOG(COMP_CODE,UNIT_CODE,AGCD,DPCD,BG_NO,BG_AMT,BG_DATE,BG_VALID,BANK_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,
BKUP_SNO,BG_TYPE,BG_ATTACH,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT_CODE,AGCD,DPCD,BG_NO,BG_AMT,BG_DATE,BG_VALID,BANK_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,
BKUP_SNO,BG_TYPE,BG_ATTACH,ISNULL(UPDATED_BY,CREATED_BY),getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'

	INSERT INTO CIR_BANK_GUARANTEE_LOG(COMP_CODE,UNIT_CODE,AGCD,DPCD,BG_NO,BG_AMT,BG_DATE,BG_VALID,BANK_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,
BKUP_SNO,BG_TYPE,BG_ATTACH,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT_CODE,AGCD,DPCD,BG_NO,BG_AMT,BG_DATE,BG_VALID,BANK_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,
BKUP_SNO,BG_TYPE,BG_ATTACH,ISNULL(UPDATED_BY,CREATED_BY),getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end





///////////////


ALTER TRIGGER [dbo].[CIR_BANK_MAST_LOG_RECORD_LOG] ON [dbo].[CIR_BANK_MAST] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;


 
 IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'
INSERT INTO CIR_BANK_MAST_LOG(COMP_CODE,BANKCODE,BANKNAME,CITY_CODE,USERID,CREATION_DATETIME,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,BANKCODE,BANKNAME,CITY_CODE,USERID,CREATION_DATETIME,USERID,getdate(),host_name()+'/'+@ip,'INSERT'
	from inserted
end
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'

	INSERT INTO CIR_BANK_MAST_LOG(COMP_CODE,BANKCODE,BANKNAME,CITY_CODE,USERID,CREATION_DATETIME,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,BANKCODE,BANKNAME,CITY_CODE,USERID,CREATION_DATETIME,USERID,getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_BANK_MAST_LOG(COMP_CODE,BANKCODE,BANKNAME,CITY_CODE,USERID,CREATION_DATETIME,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,BANKCODE,BANKNAME,CITY_CODE,USERID,CREATION_DATETIME,USERID,getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'

	INSERT INTO CIR_BANK_MAST_LOG(COMP_CODE,BANKCODE,BANKNAME,CITY_CODE,USERID,CREATION_DATETIME,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,BANKCODE,BANKNAME,CITY_CODE,USERID,CREATION_DATETIME,USERID,getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end






///////////

ALTER TRIGGER [dbo].[CIR_SUSPEND_TRAN_LOG_RECORD_LOG] ON [dbo].[CIR_SUSPEND_TRAN] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;


 IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'
INSERT INTO CIR_SUSPEND_TRAN_LOG(COMP_CODE,UNIT,AGCD,DPCD,TRN_DATE,SUSP,SUSPTY,SUSP_DATE,START_DATE,USERID,CREATION_DATE,FREEZE_FLAG,temp_id,AGENCY_UNBLOCK_TYPE,AGENCY_UNBLOCK_APPROVAL,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT,AGCD,DPCD,TRN_DATE,SUSP,SUSPTY,SUSP_DATE,START_DATE,USERID,CREATION_DATE,FREEZE_FLAG,temp_id,
	AGENCY_UNBLOCK_TYPE,AGENCY_UNBLOCK_APPROVAL,USERID,getdate(),host_name()+'/'+@ip,'INSERT'
	from inserted
	
end
 
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'

	INSERT INTO CIR_SUSPEND_TRAN_LOG(COMP_CODE,UNIT,AGCD,DPCD,TRN_DATE,SUSP,SUSPTY,SUSP_DATE,START_DATE,USERID,CREATION_DATE,FREEZE_FLAG,temp_id,AGENCY_UNBLOCK_TYPE,AGENCY_UNBLOCK_APPROVAL,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT,AGCD,DPCD,TRN_DATE,SUSP,SUSPTY,SUSP_DATE,START_DATE,USERID,CREATION_DATE,FREEZE_FLAG,temp_id,AGENCY_UNBLOCK_TYPE,AGENCY_UNBLOCK_APPROVAL,USERID,getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_SUSPEND_TRAN_LOG(COMP_CODE,UNIT,AGCD,DPCD,TRN_DATE,SUSP,SUSPTY,SUSP_DATE,START_DATE,USERID,CREATION_DATE,FREEZE_FLAG,temp_id,AGENCY_UNBLOCK_TYPE,AGENCY_UNBLOCK_APPROVAL,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT,AGCD,DPCD,TRN_DATE,SUSP,SUSPTY,SUSP_DATE,START_DATE,USERID,CREATION_DATE,FREEZE_FLAG,temp_id,AGENCY_UNBLOCK_TYPE,AGENCY_UNBLOCK_APPROVAL,USERID,getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'

	INSERT INTO CIR_SUSPEND_TRAN_LOG(COMP_CODE,UNIT,AGCD,DPCD,TRN_DATE,SUSP,SUSPTY,SUSP_DATE,START_DATE,USERID,CREATION_DATE,FREEZE_FLAG,temp_id,AGENCY_UNBLOCK_TYPE,AGENCY_UNBLOCK_APPROVAL,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,UNIT,AGCD,DPCD,TRN_DATE,SUSP,SUSPTY,SUSP_DATE,START_DATE,USERID,CREATION_DATE,FREEZE_FLAG,temp_id,AGENCY_UNBLOCK_TYPE,AGENCY_UNBLOCK_APPROVAL,USERID,getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end







////////


ALTER TRIGGER [dbo].[CIR_EXECUTIVE_MAST_RECORD_LOG] ON [dbo].[CIR_EXECUTIVE_MAST] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;


  IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'
INSERT INTO CIR_EXECUTIVE_MAST_LOG(
COMP_CODE,EXECUTIVE_CODE,EXECUTIVE_DESC,EXEC_DESIGNATION,EXEC_ADDR1,EXEC_ADDR2,AREA_CODE,PIN_CODE,PHONE_NO1,PHONE_NO2,
MOBILE_NO,FAX_NO,EMAIL_ID,HR_CODE,CREATION_DATE,FREEZE_FLAG,UNIT_CODE,CITY_CODE,DIST_CODE,STATE_CODE,COUNTRY_CODE,
USERID,EXEC_ONAME,TALU_CODE,DEPT_NAME,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,EXECUTIVE_CODE,EXECUTIVE_DESC,EXEC_DESIGNATION,EXEC_ADDR1,EXEC_ADDR2,AREA_CODE,PIN_CODE,PHONE_NO1,PHONE_NO2,
MOBILE_NO,FAX_NO,EMAIL_ID,HR_CODE,CREATION_DATE,FREEZE_FLAG,UNIT_CODE,CITY_CODE,DIST_CODE,STATE_CODE,COUNTRY_CODE,
USERID,EXEC_ONAME,TALU_CODE,DEPT_NAME,USERID,getdate(),host_name()+'/'+@ip,'INSERT'
	from inserted
	
end
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'

	INSERT INTO CIR_EXECUTIVE_MAST_LOG(
COMP_CODE,EXECUTIVE_CODE,EXECUTIVE_DESC,EXEC_DESIGNATION,EXEC_ADDR1,EXEC_ADDR2,AREA_CODE,PIN_CODE,PHONE_NO1,PHONE_NO2,
MOBILE_NO,FAX_NO,EMAIL_ID,HR_CODE,CREATION_DATE,FREEZE_FLAG,UNIT_CODE,CITY_CODE,DIST_CODE,STATE_CODE,COUNTRY_CODE,
USERID,EXEC_ONAME,TALU_CODE,DEPT_NAME,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,EXECUTIVE_CODE,EXECUTIVE_DESC,EXEC_DESIGNATION,EXEC_ADDR1,EXEC_ADDR2,AREA_CODE,PIN_CODE,PHONE_NO1,PHONE_NO2,
MOBILE_NO,FAX_NO,EMAIL_ID,HR_CODE,CREATION_DATE,FREEZE_FLAG,UNIT_CODE,CITY_CODE,DIST_CODE,STATE_CODE,COUNTRY_CODE,
USERID,EXEC_ONAME,TALU_CODE,DEPT_NAME,USERID,getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_EXECUTIVE_MAST_LOG(
COMP_CODE,EXECUTIVE_CODE,EXECUTIVE_DESC,EXEC_DESIGNATION,EXEC_ADDR1,EXEC_ADDR2,AREA_CODE,PIN_CODE,PHONE_NO1,PHONE_NO2,
MOBILE_NO,FAX_NO,EMAIL_ID,HR_CODE,CREATION_DATE,FREEZE_FLAG,UNIT_CODE,CITY_CODE,DIST_CODE,STATE_CODE,COUNTRY_CODE,
USERID,EXEC_ONAME,TALU_CODE,DEPT_NAME,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,EXECUTIVE_CODE,EXECUTIVE_DESC,EXEC_DESIGNATION,EXEC_ADDR1,EXEC_ADDR2,AREA_CODE,PIN_CODE,PHONE_NO1,PHONE_NO2,
MOBILE_NO,FAX_NO,EMAIL_ID,HR_CODE,CREATION_DATE,FREEZE_FLAG,UNIT_CODE,CITY_CODE,DIST_CODE,STATE_CODE,COUNTRY_CODE,
USERID,EXEC_ONAME,TALU_CODE,DEPT_NAME,USERID,getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'

	INSERT INTO CIR_EXECUTIVE_MAST_LOG(
COMP_CODE,EXECUTIVE_CODE,EXECUTIVE_DESC,EXEC_DESIGNATION,EXEC_ADDR1,EXEC_ADDR2,AREA_CODE,PIN_CODE,PHONE_NO1,PHONE_NO2,
MOBILE_NO,FAX_NO,EMAIL_ID,HR_CODE,CREATION_DATE,FREEZE_FLAG,UNIT_CODE,CITY_CODE,DIST_CODE,STATE_CODE,COUNTRY_CODE,
USERID,EXEC_ONAME,TALU_CODE,DEPT_NAME,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,EXECUTIVE_CODE,EXECUTIVE_DESC,EXEC_DESIGNATION,EXEC_ADDR1,EXEC_ADDR2,AREA_CODE,PIN_CODE,PHONE_NO1,PHONE_NO2,
MOBILE_NO,FAX_NO,EMAIL_ID,HR_CODE,CREATION_DATE,FREEZE_FLAG,UNIT_CODE,CITY_CODE,DIST_CODE,STATE_CODE,COUNTRY_CODE,
USERID,EXEC_ONAME,TALU_CODE,DEPT_NAME,USERID,getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end

/////////


ALTER TRIGGER [dbo].[CIR_AGENCY_TYP_MAST_RECORD_LOG] ON [dbo].[CIR_AGENCY_TYP_MAST] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;


  IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'
	INSERT INTO CIR_AGENCY_TYP_MAST_LOG(
AGENCY_TYPE_CODE,AGENCY_TYPE_DESC,USERID,CREATION_DATE,AGENCY_TYPE_ALIAS,FREEZE_FLAG,COMP_CODE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select AGENCY_TYPE_CODE,AGENCY_TYPE_DESC,USERID,CREATION_DATE,AGENCY_TYPE_ALIAS,FREEZE_FLAG,COMP_CODE,USERID,
	getdate(),host_name()+'/'+@ip,'INSERT'
	from inserted
	
end
 
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'

	INSERT INTO CIR_AGENCY_TYP_MAST_LOG(
AGENCY_TYPE_CODE,AGENCY_TYPE_DESC,USERID,CREATION_DATE,AGENCY_TYPE_ALIAS,FREEZE_FLAG,COMP_CODE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select AGENCY_TYPE_CODE,AGENCY_TYPE_DESC,USERID,CREATION_DATE,AGENCY_TYPE_ALIAS,FREEZE_FLAG,COMP_CODE,USERID,getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_AGENCY_TYP_MAST_LOG(
AGENCY_TYPE_CODE,AGENCY_TYPE_DESC,USERID,CREATION_DATE,AGENCY_TYPE_ALIAS,FREEZE_FLAG,COMP_CODE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select AGENCY_TYPE_CODE,AGENCY_TYPE_DESC,USERID,CREATION_DATE,AGENCY_TYPE_ALIAS,FREEZE_FLAG,COMP_CODE,USERID,getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'

	INSERT INTO CIR_AGENCY_TYP_MAST_LOG(
AGENCY_TYPE_CODE,AGENCY_TYPE_DESC,USERID,CREATION_DATE,AGENCY_TYPE_ALIAS,FREEZE_FLAG,COMP_CODE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select AGENCY_TYPE_CODE,AGENCY_TYPE_DESC,USERID,CREATION_DATE,AGENCY_TYPE_ALIAS,FREEZE_FLAG,COMP_CODE,USERID,getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end



//////////////

ALTER TRIGGER [dbo].[CIR_AGENCY_CLASS_MAST_RECORD_LOG] ON [dbo].[CIR_AGENCY_CLASS_MAST] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;


  IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'
INSERT INTO CIR_AGENCY_CLASS_MAST_LOG(
CLASS_CODE,CLASS_DESC,USERID,CREATION_DATE,CLASS_ALIAS,FREEZE_FLAG,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select CLASS_CODE,CLASS_DESC,USERID,CREATION_DATE,CLASS_ALIAS,FREEZE_FLAG,USERID,getdate(),
	host_name()+'/'+@ip,'INSERT'
	from inserted
	
end
 
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'

	INSERT INTO CIR_AGENCY_CLASS_MAST_LOG(
CLASS_CODE,CLASS_DESC,USERID,CREATION_DATE,CLASS_ALIAS,FREEZE_FLAG,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select CLASS_CODE,CLASS_DESC,USERID,CREATION_DATE,CLASS_ALIAS,FREEZE_FLAG,USERID,getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_AGENCY_CLASS_MAST_LOG(
CLASS_CODE,CLASS_DESC,USERID,CREATION_DATE,CLASS_ALIAS,FREEZE_FLAG,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select CLASS_CODE,CLASS_DESC,USERID,CREATION_DATE,CLASS_ALIAS,FREEZE_FLAG,USERID,getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'

	INSERT INTO CIR_AGENCY_CLASS_MAST_LOG(
CLASS_CODE,CLASS_DESC,USERID,CREATION_DATE,CLASS_ALIAS,FREEZE_FLAG,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select CLASS_CODE,CLASS_DESC,USERID,CREATION_DATE,CLASS_ALIAS,FREEZE_FLAG,USERID,getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end





////////

ALTER TRIGGER [dbo].[CIR_SUSPEND_TYPE_MAST_RECORD_LOG] ON [dbo].[CIR_SUSPEND_TYPE_MAST] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;


  IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'
INSERT INTO CIR_SUSPEND_TYPE_MAST_LOG(
SUSPEND_TYPE_CODE,SUSPEND_DESC,USERID,CREATION_DATE,FREEZE_FLAG,COMP_CODE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select SUSPEND_TYPE_CODE,SUSPEND_DESC,USERID,CREATION_DATE,FREEZE_FLAG,COMP_CODE,USERID,getdate(),
	host_name()+'/'+@ip,'INSERT'
	from inserted
	
end
 
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'

	INSERT INTO CIR_SUSPEND_TYPE_MAST_LOG(
SUSPEND_TYPE_CODE,SUSPEND_DESC,USERID,CREATION_DATE,FREEZE_FLAG,COMP_CODE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select SUSPEND_TYPE_CODE,SUSPEND_DESC,USERID,CREATION_DATE,FREEZE_FLAG,COMP_CODE,USERID,getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_SUSPEND_TYPE_MAST_LOG(
SUSPEND_TYPE_CODE,SUSPEND_DESC,USERID,CREATION_DATE,FREEZE_FLAG,COMP_CODE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select SUSPEND_TYPE_CODE,SUSPEND_DESC,USERID,CREATION_DATE,FREEZE_FLAG,COMP_CODE,USERID,getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'

	INSERT INTO CIR_SUSPEND_TYPE_MAST_LOG(
SUSPEND_TYPE_CODE,SUSPEND_DESC,USERID,CREATION_DATE,FREEZE_FLAG,COMP_CODE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select SUSPEND_TYPE_CODE,SUSPEND_DESC,USERID,CREATION_DATE,FREEZE_FLAG,COMP_CODE,USERID,getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end







/////////


ALTER TRIGGER [dbo].[CIR_AG_CLOSE_REASON_RECORD_LOG] ON [dbo].[CIR_AG_CLOSE_REASON] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;


  IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'
INSERT INTO CIR_AG_CLOSE_REASON_LOG(
COMP_CODE,REASON_CODE,REASON_DESC,USERID,CREATION_DATE,FREEZE_FLAG,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,REASON_CODE,REASON_DESC,USERID,CREATION_DATE,FREEZE_FLAG,USERID,getdate(),
	host_name()+'/'+@ip,'INSERT'
	from inserted
	
end
 
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'

	INSERT INTO CIR_AG_CLOSE_REASON_LOG(
COMP_CODE,REASON_CODE,REASON_DESC,USERID,CREATION_DATE,FREEZE_FLAG,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,REASON_CODE,REASON_DESC,USERID,CREATION_DATE,FREEZE_FLAG,USERID,getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_AG_CLOSE_REASON_LOG(
COMP_CODE,REASON_CODE,REASON_DESC,USERID,CREATION_DATE,FREEZE_FLAG,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,REASON_CODE,REASON_DESC,USERID,CREATION_DATE,FREEZE_FLAG,USERID,getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'

	INSERT INTO CIR_AG_CLOSE_REASON_LOG(
COMP_CODE,REASON_CODE,REASON_DESC,USERID,CREATION_DATE,FREEZE_FLAG,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
	select COMP_CODE,REASON_CODE,REASON_DESC,USERID,CREATION_DATE,FREEZE_FLAG,USERID,getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end









/////////////

ALTER TRIGGER [dbo].[CIR_ROLE_MAST_RECORD_LOG] ON [dbo].[CIR_ROLE_MAST] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;


  IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'
INSERT INTO CIR_ROLE_MAST_LOG(
COMP_CODE,UNIT_CODE,ROLE_CODE,ROLE_DESC,LEVEL_CODE,FREEZE_FLAG,CREATION_DATE,USER_ID,temp_id,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT	COMP_CODE,UNIT_CODE,ROLE_CODE,ROLE_DESC,LEVEL_CODE,FREEZE_FLAG,CREATION_DATE,USER_ID,temp_id,
USER_ID,getdate(),host_name()+'/'+@ip,'INSERT'
	from inserted
	
end
 
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'

	INSERT INTO CIR_ROLE_MAST_LOG(
COMP_CODE,UNIT_CODE,ROLE_CODE,ROLE_DESC,LEVEL_CODE,FREEZE_FLAG,CREATION_DATE,USER_ID,temp_id,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT	COMP_CODE,UNIT_CODE,ROLE_CODE,ROLE_DESC,LEVEL_CODE,FREEZE_FLAG,CREATION_DATE,USER_ID,temp_id,USER_ID,getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_ROLE_MAST_LOG(
COMP_CODE,UNIT_CODE,ROLE_CODE,ROLE_DESC,LEVEL_CODE,FREEZE_FLAG,CREATION_DATE,USER_ID,temp_id,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT	COMP_CODE,UNIT_CODE,ROLE_CODE,ROLE_DESC,LEVEL_CODE,FREEZE_FLAG,CREATION_DATE,USER_ID,temp_id,USER_ID,getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'

	INSERT INTO CIR_ROLE_MAST_LOG(
COMP_CODE,UNIT_CODE,ROLE_CODE,ROLE_DESC,LEVEL_CODE,FREEZE_FLAG,CREATION_DATE,USER_ID,temp_id,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT	COMP_CODE,UNIT_CODE,ROLE_CODE,ROLE_DESC,LEVEL_CODE,FREEZE_FLAG,CREATION_DATE,USER_ID,temp_id,USER_ID,getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end










////////

ALTER TRIGGER [dbo].[CIR_FESTIVAL_MAST_RECORD_LOG] ON [dbo].[CIR_FESTIVAL_MAST] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;



  IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'

	INSERT INTO CIR_FESTIVAL_MAST_LOG(
FEST_CODE,FEST_NAME,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT	FEST_CODE,FEST_NAME,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,ISNULL(UPDATED_BY,CREATED_DT),
getdate(),host_name()+'/'+@ip,'INSERT'
	from inserted
	
end
 
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'

	INSERT INTO CIR_FESTIVAL_MAST_LOG(
FEST_CODE,FEST_NAME,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT	FEST_CODE,FEST_NAME,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,ISNULL(UPDATED_BY,CREATED_DT),getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_FESTIVAL_MAST_LOG(
FEST_CODE,FEST_NAME,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT	FEST_CODE,FEST_NAME,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,ISNULL(UPDATED_BY,CREATED_DT),getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'

	INSERT INTO CIR_FESTIVAL_MAST_LOG(
FEST_CODE,FEST_NAME,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT	FEST_CODE,FEST_NAME,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,ISNULL(UPDATED_BY,CREATED_DT),getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end












///////////

ALTER TRIGGER [dbo].[CIR_RACE_MAST_RECORD_LOG] ON [dbo].[CIR_RACE_MAST] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;


   IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'


	INSERT INTO CIR_RACE_MAST_LOG(
RACE_CODE,RACE_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT	RACE_CODE,RACE_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,ISNULL(UPDATED_BY,CREATED_DT),
getdate(),host_name()+'/'+@ip,'INSERT'
	from inserted
	
end
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'

	INSERT INTO CIR_RACE_MAST_LOG(
RACE_CODE,RACE_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT	RACE_CODE,RACE_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,ISNULL(UPDATED_BY,CREATED_DT),getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_RACE_MAST_LOG(
RACE_CODE,RACE_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT	RACE_CODE,RACE_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,ISNULL(UPDATED_BY,CREATED_DT),getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'

	INSERT INTO CIR_RACE_MAST_LOG(
RACE_CODE,RACE_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT	RACE_CODE,RACE_DESC,CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,ISNULL(UPDATED_BY,CREATED_DT),getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end














///////

ALTER TRIGGER [dbo].[CIR_PUBL_MAST_RECORD_LOG] ON [dbo].[CIR_PUBL_MAST] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;

 IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'

INSERT INTO CIR_PUBL_MAST_LOG(
COMP_CODE,PUBL,PUBL_NAME,PUBL_NAME_OTH_LANG,PNICK,PERIOD,PRO_TYPE,DOB,USERID,CREATION_DATE,FREEZE_FLAG,PUBL_ALERT,ACC_CODE,PUBL_SEQNO,PUBLISHER,IMP_DAYS,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT COMP_CODE,PUBL,PUBL_NAME,PUBL_NAME_OTH_LANG,PNICK,PERIOD,PRO_TYPE,DOB,USERID,CREATION_DATE,FREEZE_FLAG,
PUBL_ALERT,ACC_CODE,PUBL_SEQNO,PUBLISHER,IMP_DAYS,USERID,getdate(),host_name()+'/'+@ip,'INSERT'
	from inserted
	
end
 
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'

	INSERT INTO CIR_PUBL_MAST_LOG(
COMP_CODE,PUBL,PUBL_NAME,PUBL_NAME_OTH_LANG,PNICK,PERIOD,PRO_TYPE,DOB,USERID,CREATION_DATE,FREEZE_FLAG,PUBL_ALERT,ACC_CODE,PUBL_SEQNO,PUBLISHER,IMP_DAYS,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT COMP_CODE,PUBL,PUBL_NAME,PUBL_NAME_OTH_LANG,PNICK,PERIOD,PRO_TYPE,DOB,USERID,CREATION_DATE,FREEZE_FLAG,PUBL_ALERT,ACC_CODE,PUBL_SEQNO,PUBLISHER,IMP_DAYS,USERID,getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_PUBL_MAST_LOG(
COMP_CODE,PUBL,PUBL_NAME,PUBL_NAME_OTH_LANG,PNICK,PERIOD,PRO_TYPE,DOB,USERID,CREATION_DATE,FREEZE_FLAG,PUBL_ALERT,ACC_CODE,PUBL_SEQNO,PUBLISHER,IMP_DAYS,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT COMP_CODE,PUBL,PUBL_NAME,PUBL_NAME_OTH_LANG,PNICK,PERIOD,PRO_TYPE,DOB,USERID,CREATION_DATE,FREEZE_FLAG,PUBL_ALERT,ACC_CODE,PUBL_SEQNO,PUBLISHER,IMP_DAYS,USERID,getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'

	INSERT INTO CIR_PUBL_MAST_LOG(
COMP_CODE,PUBL,PUBL_NAME,PUBL_NAME_OTH_LANG,PNICK,PERIOD,PRO_TYPE,DOB,USERID,CREATION_DATE,FREEZE_FLAG,PUBL_ALERT,ACC_CODE,PUBL_SEQNO,PUBLISHER,IMP_DAYS,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT COMP_CODE,PUBL,PUBL_NAME,PUBL_NAME_OTH_LANG,PNICK,PERIOD,PRO_TYPE,DOB,USERID,CREATION_DATE,FREEZE_FLAG,PUBL_ALERT,ACC_CODE,PUBL_SEQNO,PUBLISHER,IMP_DAYS,USERID,getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end















////////////

ALTER TRIGGER [dbo].[CIR_EDTN_MAST_RECORD_LOG] ON [dbo].[CIR_EDTN_MAST] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;


 
 IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'

INSERT INTO CIR_EDTN_MAST_LOG(
COMP_CODE,PUBL,EDTN,EDTN_NAME,EDTN_NAME_OTH_LANG,EDITION_NICK,DOB,PAGE_WT_SUN,PAGE_WT_MON,PAGE_WT_TUE,PAGE_WT_WED,PAGE_WT_THU,PAGE_WT_FRI,
PAGE_WT_SAT,MAIN_ISSUE_PGNO_SUN,MAIN_ISSUE_PGNO_MON,MAIN_ISSUE_PGNO_TUE,MAIN_ISSUE_PGNO_WED,MAIN_ISSUE_PGNO_THU,MAIN_ISSUE_PGNO_FRI,
MAIN_ISSUE_PGNO_SAT,MAIN_ISSUE_NAME_SUN,MAIN_ISSUE_NAME_MON,MAIN_ISSUE_NAME_TUE,MAIN_ISSUE_NAME_WED,MAIN_ISSUE_NAME_THU,MAIN_ISSUE_NAME_FRI,
MAIN_ISSUE_NAME_SAT,PULLOUT_PGNO_SUN,PULLOUT_PGNO_MON,PULLOUT_PGNO_TUE,PULLOUT_PGNO_WED,PULLOUT_PGNO_THU,PULLOUT_PGNO_FRI,PULLOUT_PGNO_SAT,
USERID,CREATION_datetime,FREEZE_FLAG,PGNO_SUN,PGNO_MON,PGNO_TUE,PGNO_WED,PGNO_THU,PGNO_FRI,PGNO_SAT,EDTN_SEQ_NO,EDTN_TY,MAIN_EDTN,UNIT_CODE,
PURBILL_COMM_TY,PURBILL_COMM,DIS_AGCD,DIS_DPCD,REG_NO,PERIOD,SEG_CODE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT COMP_CODE,PUBL,EDTN,EDTN_NAME,EDTN_NAME_OTH_LANG,EDITION_NICK,DOB,PAGE_WT_SUN,PAGE_WT_MON,PAGE_WT_TUE,PAGE_WT_WED,PAGE_WT_THU,PAGE_WT_FRI,
PAGE_WT_SAT,MAIN_ISSUE_PGNO_SUN,MAIN_ISSUE_PGNO_MON,MAIN_ISSUE_PGNO_TUE,MAIN_ISSUE_PGNO_WED,MAIN_ISSUE_PGNO_THU,MAIN_ISSUE_PGNO_FRI,
MAIN_ISSUE_PGNO_SAT,MAIN_ISSUE_NAME_SUN,MAIN_ISSUE_NAME_MON,MAIN_ISSUE_NAME_TUE,MAIN_ISSUE_NAME_WED,MAIN_ISSUE_NAME_THU,MAIN_ISSUE_NAME_FRI,
MAIN_ISSUE_NAME_SAT,PULLOUT_PGNO_SUN,PULLOUT_PGNO_MON,PULLOUT_PGNO_TUE,PULLOUT_PGNO_WED,PULLOUT_PGNO_THU,PULLOUT_PGNO_FRI,PULLOUT_PGNO_SAT,
USERID,CREATION_datetime,FREEZE_FLAG,PGNO_SUN,PGNO_MON,PGNO_TUE,PGNO_WED,PGNO_THU,PGNO_FRI,PGNO_SAT,EDTN_SEQ_NO,EDTN_TY,MAIN_EDTN,UNIT_CODE,
PURBILL_COMM_TY,PURBILL_COMM,DIS_AGCD,DIS_DPCD,REG_NO,PERIOD,SEG_CODE,USERID,getdate(),host_name()+'/'+@ip,'INSERT'
	from inserted
	
end
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'

	INSERT INTO CIR_EDTN_MAST_LOG(
COMP_CODE,PUBL,EDTN,EDTN_NAME,EDTN_NAME_OTH_LANG,EDITION_NICK,DOB,PAGE_WT_SUN,PAGE_WT_MON,PAGE_WT_TUE,PAGE_WT_WED,PAGE_WT_THU,PAGE_WT_FRI,
PAGE_WT_SAT,MAIN_ISSUE_PGNO_SUN,MAIN_ISSUE_PGNO_MON,MAIN_ISSUE_PGNO_TUE,MAIN_ISSUE_PGNO_WED,MAIN_ISSUE_PGNO_THU,MAIN_ISSUE_PGNO_FRI,
MAIN_ISSUE_PGNO_SAT,MAIN_ISSUE_NAME_SUN,MAIN_ISSUE_NAME_MON,MAIN_ISSUE_NAME_TUE,MAIN_ISSUE_NAME_WED,MAIN_ISSUE_NAME_THU,MAIN_ISSUE_NAME_FRI,
MAIN_ISSUE_NAME_SAT,PULLOUT_PGNO_SUN,PULLOUT_PGNO_MON,PULLOUT_PGNO_TUE,PULLOUT_PGNO_WED,PULLOUT_PGNO_THU,PULLOUT_PGNO_FRI,PULLOUT_PGNO_SAT,
USERID,CREATION_datetime,FREEZE_FLAG,PGNO_SUN,PGNO_MON,PGNO_TUE,PGNO_WED,PGNO_THU,PGNO_FRI,PGNO_SAT,EDTN_SEQ_NO,EDTN_TY,MAIN_EDTN,UNIT_CODE,
PURBILL_COMM_TY,PURBILL_COMM,DIS_AGCD,DIS_DPCD,REG_NO,PERIOD,SEG_CODE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT COMP_CODE,PUBL,EDTN,EDTN_NAME,EDTN_NAME_OTH_LANG,EDITION_NICK,DOB,PAGE_WT_SUN,PAGE_WT_MON,PAGE_WT_TUE,PAGE_WT_WED,PAGE_WT_THU,PAGE_WT_FRI,
PAGE_WT_SAT,MAIN_ISSUE_PGNO_SUN,MAIN_ISSUE_PGNO_MON,MAIN_ISSUE_PGNO_TUE,MAIN_ISSUE_PGNO_WED,MAIN_ISSUE_PGNO_THU,MAIN_ISSUE_PGNO_FRI,
MAIN_ISSUE_PGNO_SAT,MAIN_ISSUE_NAME_SUN,MAIN_ISSUE_NAME_MON,MAIN_ISSUE_NAME_TUE,MAIN_ISSUE_NAME_WED,MAIN_ISSUE_NAME_THU,MAIN_ISSUE_NAME_FRI,
MAIN_ISSUE_NAME_SAT,PULLOUT_PGNO_SUN,PULLOUT_PGNO_MON,PULLOUT_PGNO_TUE,PULLOUT_PGNO_WED,PULLOUT_PGNO_THU,PULLOUT_PGNO_FRI,PULLOUT_PGNO_SAT,
USERID,CREATION_datetime,FREEZE_FLAG,PGNO_SUN,PGNO_MON,PGNO_TUE,PGNO_WED,PGNO_THU,PGNO_FRI,PGNO_SAT,EDTN_SEQ_NO,EDTN_TY,MAIN_EDTN,UNIT_CODE,
PURBILL_COMM_TY,PURBILL_COMM,DIS_AGCD,DIS_DPCD,REG_NO,PERIOD,SEG_CODE,USERID,getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_EDTN_MAST_LOG(
COMP_CODE,PUBL,EDTN,EDTN_NAME,EDTN_NAME_OTH_LANG,EDITION_NICK,DOB,PAGE_WT_SUN,PAGE_WT_MON,PAGE_WT_TUE,PAGE_WT_WED,PAGE_WT_THU,PAGE_WT_FRI,
PAGE_WT_SAT,MAIN_ISSUE_PGNO_SUN,MAIN_ISSUE_PGNO_MON,MAIN_ISSUE_PGNO_TUE,MAIN_ISSUE_PGNO_WED,MAIN_ISSUE_PGNO_THU,MAIN_ISSUE_PGNO_FRI,
MAIN_ISSUE_PGNO_SAT,MAIN_ISSUE_NAME_SUN,MAIN_ISSUE_NAME_MON,MAIN_ISSUE_NAME_TUE,MAIN_ISSUE_NAME_WED,MAIN_ISSUE_NAME_THU,MAIN_ISSUE_NAME_FRI,
MAIN_ISSUE_NAME_SAT,PULLOUT_PGNO_SUN,PULLOUT_PGNO_MON,PULLOUT_PGNO_TUE,PULLOUT_PGNO_WED,PULLOUT_PGNO_THU,PULLOUT_PGNO_FRI,PULLOUT_PGNO_SAT,
USERID,CREATION_datetime,FREEZE_FLAG,PGNO_SUN,PGNO_MON,PGNO_TUE,PGNO_WED,PGNO_THU,PGNO_FRI,PGNO_SAT,EDTN_SEQ_NO,EDTN_TY,MAIN_EDTN,UNIT_CODE,
PURBILL_COMM_TY,PURBILL_COMM,DIS_AGCD,DIS_DPCD,REG_NO,PERIOD,SEG_CODE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT COMP_CODE,PUBL,EDTN,EDTN_NAME,EDTN_NAME_OTH_LANG,EDITION_NICK,DOB,PAGE_WT_SUN,PAGE_WT_MON,PAGE_WT_TUE,PAGE_WT_WED,PAGE_WT_THU,PAGE_WT_FRI,
PAGE_WT_SAT,MAIN_ISSUE_PGNO_SUN,MAIN_ISSUE_PGNO_MON,MAIN_ISSUE_PGNO_TUE,MAIN_ISSUE_PGNO_WED,MAIN_ISSUE_PGNO_THU,MAIN_ISSUE_PGNO_FRI,
MAIN_ISSUE_PGNO_SAT,MAIN_ISSUE_NAME_SUN,MAIN_ISSUE_NAME_MON,MAIN_ISSUE_NAME_TUE,MAIN_ISSUE_NAME_WED,MAIN_ISSUE_NAME_THU,MAIN_ISSUE_NAME_FRI,
MAIN_ISSUE_NAME_SAT,PULLOUT_PGNO_SUN,PULLOUT_PGNO_MON,PULLOUT_PGNO_TUE,PULLOUT_PGNO_WED,PULLOUT_PGNO_THU,PULLOUT_PGNO_FRI,PULLOUT_PGNO_SAT,
USERID,CREATION_datetime,FREEZE_FLAG,PGNO_SUN,PGNO_MON,PGNO_TUE,PGNO_WED,PGNO_THU,PGNO_FRI,PGNO_SAT,EDTN_SEQ_NO,EDTN_TY,MAIN_EDTN,UNIT_CODE,
PURBILL_COMM_TY,PURBILL_COMM,DIS_AGCD,DIS_DPCD,REG_NO,PERIOD,SEG_CODE,USERID,getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'

	INSERT INTO CIR_EDTN_MAST_LOG(
COMP_CODE,PUBL,EDTN,EDTN_NAME,EDTN_NAME_OTH_LANG,EDITION_NICK,DOB,PAGE_WT_SUN,PAGE_WT_MON,PAGE_WT_TUE,PAGE_WT_WED,PAGE_WT_THU,PAGE_WT_FRI,
PAGE_WT_SAT,MAIN_ISSUE_PGNO_SUN,MAIN_ISSUE_PGNO_MON,MAIN_ISSUE_PGNO_TUE,MAIN_ISSUE_PGNO_WED,MAIN_ISSUE_PGNO_THU,MAIN_ISSUE_PGNO_FRI,
MAIN_ISSUE_PGNO_SAT,MAIN_ISSUE_NAME_SUN,MAIN_ISSUE_NAME_MON,MAIN_ISSUE_NAME_TUE,MAIN_ISSUE_NAME_WED,MAIN_ISSUE_NAME_THU,MAIN_ISSUE_NAME_FRI,
MAIN_ISSUE_NAME_SAT,PULLOUT_PGNO_SUN,PULLOUT_PGNO_MON,PULLOUT_PGNO_TUE,PULLOUT_PGNO_WED,PULLOUT_PGNO_THU,PULLOUT_PGNO_FRI,PULLOUT_PGNO_SAT,
USERID,CREATION_datetime,FREEZE_FLAG,PGNO_SUN,PGNO_MON,PGNO_TUE,PGNO_WED,PGNO_THU,PGNO_FRI,PGNO_SAT,EDTN_SEQ_NO,EDTN_TY,MAIN_EDTN,UNIT_CODE,
PURBILL_COMM_TY,PURBILL_COMM,DIS_AGCD,DIS_DPCD,REG_NO,PERIOD,SEG_CODE,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT COMP_CODE,PUBL,EDTN,EDTN_NAME,EDTN_NAME_OTH_LANG,EDITION_NICK,DOB,PAGE_WT_SUN,PAGE_WT_MON,PAGE_WT_TUE,PAGE_WT_WED,PAGE_WT_THU,PAGE_WT_FRI,
PAGE_WT_SAT,MAIN_ISSUE_PGNO_SUN,MAIN_ISSUE_PGNO_MON,MAIN_ISSUE_PGNO_TUE,MAIN_ISSUE_PGNO_WED,MAIN_ISSUE_PGNO_THU,MAIN_ISSUE_PGNO_FRI,
MAIN_ISSUE_PGNO_SAT,MAIN_ISSUE_NAME_SUN,MAIN_ISSUE_NAME_MON,MAIN_ISSUE_NAME_TUE,MAIN_ISSUE_NAME_WED,MAIN_ISSUE_NAME_THU,MAIN_ISSUE_NAME_FRI,
MAIN_ISSUE_NAME_SAT,PULLOUT_PGNO_SUN,PULLOUT_PGNO_MON,PULLOUT_PGNO_TUE,PULLOUT_PGNO_WED,PULLOUT_PGNO_THU,PULLOUT_PGNO_FRI,PULLOUT_PGNO_SAT,
USERID,CREATION_datetime,FREEZE_FLAG,PGNO_SUN,PGNO_MON,PGNO_TUE,PGNO_WED,PGNO_THU,PGNO_FRI,PGNO_SAT,EDTN_SEQ_NO,EDTN_TY,MAIN_EDTN,UNIT_CODE,
PURBILL_COMM_TY,PURBILL_COMM,DIS_AGCD,DIS_DPCD,REG_NO,PERIOD,SEG_CODE,USERID,getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end

















//////////////

ALTER TRIGGER [dbo].[CIR_EDTN_SUPL_MAST_RECORD_LOG] ON [dbo].[CIR_EDTN_SUPL_MAST] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;


 
 IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'

	INSERT INTO CIR_EDTN_SUPL_MAST_LOG(
COMP_CODE,UNIT_CODE,PUBL_CODE,MAIN_EDTN,EDTN_CODE,SUPL_NAME_SUN,SUPL_NAME_MON,SUPL_NAME_TUE,SUPL_NAME_WED,SUPL_NAME_THU,
SUPL_NAME_FRI,SUPL_NAME_SAT,VALID_FROM,CREATED_BY,CREATED_DATE,UPDATED_BY,UPDATED_DATE,BKUP_SNO,VALID_TILL,SHOW_ON_PO,
INSERTION_FEE,SUN_ALLOW,MON_ALLOW,TUE_ALLOW,WED_ALLOW,THU_ALLOW,FRI_ALLOW,SAT_ALLOW,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT COMP_CODE,UNIT_CODE,PUBL_CODE,MAIN_EDTN,EDTN_CODE,SUPL_NAME_SUN,SUPL_NAME_MON,SUPL_NAME_TUE,SUPL_NAME_WED,SUPL_NAME_THU,
SUPL_NAME_FRI,SUPL_NAME_SAT,VALID_FROM,CREATED_BY,CREATED_DATE,UPDATED_BY,UPDATED_DATE,BKUP_SNO,VALID_TILL,SHOW_ON_PO,
INSERTION_FEE,SUN_ALLOW,MON_ALLOW,TUE_ALLOW,WED_ALLOW,THU_ALLOW,FRI_ALLOW,SAT_ALLOW,isnull(updated_by,created_by),
getdate(),host_name()+'/'+@ip,'INSERT'
	from inserted
	
end
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'

	INSERT INTO CIR_EDTN_SUPL_MAST_LOG(
COMP_CODE,UNIT_CODE,PUBL_CODE,MAIN_EDTN,EDTN_CODE,SUPL_NAME_SUN,SUPL_NAME_MON,SUPL_NAME_TUE,SUPL_NAME_WED,SUPL_NAME_THU,
SUPL_NAME_FRI,SUPL_NAME_SAT,VALID_FROM,CREATED_BY,CREATED_DATE,UPDATED_BY,UPDATED_DATE,BKUP_SNO,VALID_TILL,SHOW_ON_PO,
INSERTION_FEE,SUN_ALLOW,MON_ALLOW,TUE_ALLOW,WED_ALLOW,THU_ALLOW,FRI_ALLOW,SAT_ALLOW,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT COMP_CODE,UNIT_CODE,PUBL_CODE,MAIN_EDTN,EDTN_CODE,SUPL_NAME_SUN,SUPL_NAME_MON,SUPL_NAME_TUE,SUPL_NAME_WED,SUPL_NAME_THU,
SUPL_NAME_FRI,SUPL_NAME_SAT,VALID_FROM,CREATED_BY,CREATED_DATE,UPDATED_BY,UPDATED_DATE,BKUP_SNO,VALID_TILL,SHOW_ON_PO,
INSERTION_FEE,SUN_ALLOW,MON_ALLOW,TUE_ALLOW,WED_ALLOW,THU_ALLOW,FRI_ALLOW,SAT_ALLOW,isnull(updated_by,created_by),getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_EDTN_SUPL_MAST_LOG(
COMP_CODE,UNIT_CODE,PUBL_CODE,MAIN_EDTN,EDTN_CODE,SUPL_NAME_SUN,SUPL_NAME_MON,SUPL_NAME_TUE,SUPL_NAME_WED,SUPL_NAME_THU,
SUPL_NAME_FRI,SUPL_NAME_SAT,VALID_FROM,CREATED_BY,CREATED_DATE,UPDATED_BY,UPDATED_DATE,BKUP_SNO,VALID_TILL,SHOW_ON_PO,
INSERTION_FEE,SUN_ALLOW,MON_ALLOW,TUE_ALLOW,WED_ALLOW,THU_ALLOW,FRI_ALLOW,SAT_ALLOW,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT COMP_CODE,UNIT_CODE,PUBL_CODE,MAIN_EDTN,EDTN_CODE,SUPL_NAME_SUN,SUPL_NAME_MON,SUPL_NAME_TUE,SUPL_NAME_WED,SUPL_NAME_THU,
SUPL_NAME_FRI,SUPL_NAME_SAT,VALID_FROM,CREATED_BY,CREATED_DATE,UPDATED_BY,UPDATED_DATE,BKUP_SNO,VALID_TILL,SHOW_ON_PO,
INSERTION_FEE,SUN_ALLOW,MON_ALLOW,TUE_ALLOW,WED_ALLOW,THU_ALLOW,FRI_ALLOW,SAT_ALLOW,isnull(updated_by,created_by),getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'

	INSERT INTO CIR_EDTN_SUPL_MAST_LOG(
COMP_CODE,UNIT_CODE,PUBL_CODE,MAIN_EDTN,EDTN_CODE,SUPL_NAME_SUN,SUPL_NAME_MON,SUPL_NAME_TUE,SUPL_NAME_WED,SUPL_NAME_THU,
SUPL_NAME_FRI,SUPL_NAME_SAT,VALID_FROM,CREATED_BY,CREATED_DATE,UPDATED_BY,UPDATED_DATE,BKUP_SNO,VALID_TILL,SHOW_ON_PO,
INSERTION_FEE,SUN_ALLOW,MON_ALLOW,TUE_ALLOW,WED_ALLOW,THU_ALLOW,FRI_ALLOW,SAT_ALLOW,LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT COMP_CODE,UNIT_CODE,PUBL_CODE,MAIN_EDTN,EDTN_CODE,SUPL_NAME_SUN,SUPL_NAME_MON,SUPL_NAME_TUE,SUPL_NAME_WED,SUPL_NAME_THU,
SUPL_NAME_FRI,SUPL_NAME_SAT,VALID_FROM,CREATED_BY,CREATED_DATE,UPDATED_BY,UPDATED_DATE,BKUP_SNO,VALID_TILL,SHOW_ON_PO,
INSERTION_FEE,SUN_ALLOW,MON_ALLOW,TUE_ALLOW,WED_ALLOW,THU_ALLOW,FRI_ALLOW,SAT_ALLOW,isnull(updated_by,created_by),getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end



















//////////

ALTER TRIGGER [dbo].[CIR_SUPPLY_TYPE_MAST_RECORD_LOG] ON [dbo].[CIR_SUPPLY_TYPE_MAST] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;


 
 IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'

INSERT INTO CIR_SUPPLY_TYPE_MAST_LOG(
COMP_CODE,SUP_TY_CODE,SUP_TY_NAME,BILL_PAY,COMM_PAY,HANDLING_PAY,FREEZE_FLAG,USERID,CREATEN_DATE,SUP_SEQ_NO,
LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT COMP_CODE,SUP_TY_CODE,SUP_TY_NAME,BILL_PAY,COMM_PAY,HANDLING_PAY,FREEZE_FLAG,USERID,
CREATEN_DATE,SUP_SEQ_NO,userid,getdate(),host_name()+'/'+@ip,'INSERT'
	from inserted
	
end
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'

	INSERT INTO CIR_SUPPLY_TYPE_MAST_LOG(
COMP_CODE,SUP_TY_CODE,SUP_TY_NAME,BILL_PAY,COMM_PAY,HANDLING_PAY,FREEZE_FLAG,USERID,CREATEN_DATE,SUP_SEQ_NO,
LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT COMP_CODE,SUP_TY_CODE,SUP_TY_NAME,BILL_PAY,COMM_PAY,HANDLING_PAY,FREEZE_FLAG,USERID,CREATEN_DATE,SUP_SEQ_NO,userid,getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_SUPPLY_TYPE_MAST_LOG(
COMP_CODE,SUP_TY_CODE,SUP_TY_NAME,BILL_PAY,COMM_PAY,HANDLING_PAY,FREEZE_FLAG,USERID,CREATEN_DATE,SUP_SEQ_NO,
LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT  COMP_CODE,SUP_TY_CODE,SUP_TY_NAME,BILL_PAY,COMM_PAY,HANDLING_PAY,FREEZE_FLAG,USERID,CREATEN_DATE,SUP_SEQ_NO,userid,getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'

	INSERT INTO CIR_SUPPLY_TYPE_MAST_LOG(
COMP_CODE,SUP_TY_CODE,SUP_TY_NAME,BILL_PAY,COMM_PAY,HANDLING_PAY,FREEZE_FLAG,USERID,CREATEN_DATE,SUP_SEQ_NO,
LOG_USER,LOG_DATE,LOG_MACHINE,LOG_TYPE)
SELECT COMP_CODE,SUP_TY_CODE,SUP_TY_NAME,BILL_PAY,COMM_PAY,HANDLING_PAY,FREEZE_FLAG,USERID,CREATEN_DATE,SUP_SEQ_NO,userid,getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end





















////////

ALTER TRIGGER [dbo].[CIR_EXPENSES_TYPE_MAST_RECORD_LOG] ON [dbo].[CIR_EXPENSES_TYPE_MAST] FOR INSERT,UPDATE, DELETE AS

declare @ip varchar(50)

SELECT @ip=client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID;


 
 IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) Begin 
	print 'insert'

INSERT INTO CIR_EXPENSES_TYPE_MAST_LOG(
COMP_CODE,EXP_TYPE_CODE,EXP_TYPE_DESC,EXP_TYPE_SIGN,EXP_TYPE_MODE,EXP_TYPE_CALC_BASE,EXP_TYPE_CALC_DATE,
DR_CDP,USERID,FREEZE_FLAG,CREATION_DATE,EXP_TYPE_COPY_TYPE,EXP_REASON,CR_CDP,LOG_USER,LOG_DATE,
LOG_MACHINE,LOG_TYPE)
SELECT COMP_CODE,EXP_TYPE_CODE,EXP_TYPE_DESC,EXP_TYPE_SIGN,EXP_TYPE_MODE,EXP_TYPE_CALC_BASE,EXP_TYPE_CALC_DATE,
DR_CDP,USERID,FREEZE_FLAG,CREATION_DATE,EXP_TYPE_COPY_TYPE,EXP_REASON,CR_CDP,userid,getdate(),host_name()+'/'+@ip,
'INSERT'
	from inserted
	
end
 
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'update'

	INSERT INTO CIR_EXPENSES_TYPE_MAST_LOG(
COMP_CODE,EXP_TYPE_CODE,EXP_TYPE_DESC,EXP_TYPE_SIGN,EXP_TYPE_MODE,EXP_TYPE_CALC_BASE,EXP_TYPE_CALC_DATE,
DR_CDP,USERID,FREEZE_FLAG,CREATION_DATE,EXP_TYPE_COPY_TYPE,EXP_REASON,CR_CDP,LOG_USER,LOG_DATE,
LOG_MACHINE,LOG_TYPE)
SELECT COMP_CODE,EXP_TYPE_CODE,EXP_TYPE_DESC,EXP_TYPE_SIGN,EXP_TYPE_MODE,EXP_TYPE_CALC_BASE,EXP_TYPE_CALC_DATE,
DR_CDP,USERID,FREEZE_FLAG,CREATION_DATE,EXP_TYPE_COPY_TYPE,EXP_REASON,CR_CDP,userid,getdate(),host_name()+'/'+@ip,'N#UPDATE'
	from inserted
	
	INSERT INTO CIR_EXPENSES_TYPE_MAST_LOG(
COMP_CODE,EXP_TYPE_CODE,EXP_TYPE_DESC,EXP_TYPE_SIGN,EXP_TYPE_MODE,EXP_TYPE_CALC_BASE,EXP_TYPE_CALC_DATE,
DR_CDP,USERID,FREEZE_FLAG,CREATION_DATE,EXP_TYPE_COPY_TYPE,EXP_REASON,CR_CDP,LOG_USER,LOG_DATE,
LOG_MACHINE,LOG_TYPE)
SELECT  COMP_CODE,EXP_TYPE_CODE,EXP_TYPE_DESC,EXP_TYPE_SIGN,EXP_TYPE_MODE,EXP_TYPE_CALC_BASE,EXP_TYPE_CALC_DATE,
DR_CDP,USERID,FREEZE_FLAG,CREATION_DATE,EXP_TYPE_COPY_TYPE,EXP_REASON,CR_CDP,userid,getdate(),host_name()+'/'+@ip,'O#UPDATE'
	from deleted
end
 
IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) Begin 
	print 'delete'

	INSERT INTO CIR_EXPENSES_TYPE_MAST_LOG(
COMP_CODE,EXP_TYPE_CODE,EXP_TYPE_DESC,EXP_TYPE_SIGN,EXP_TYPE_MODE,EXP_TYPE_CALC_BASE,EXP_TYPE_CALC_DATE,
DR_CDP,USERID,FREEZE_FLAG,CREATION_DATE,EXP_TYPE_COPY_TYPE,EXP_REASON,CR_CDP,LOG_USER,LOG_DATE,
LOG_MACHINE,LOG_TYPE)
SELECT COMP_CODE,EXP_TYPE_CODE,EXP_TYPE_DESC,EXP_TYPE_SIGN,EXP_TYPE_MODE,EXP_TYPE_CALC_BASE,EXP_TYPE_CALC_DATE,
DR_CDP,USERID,FREEZE_FLAG,CREATION_DATE,EXP_TYPE_COPY_TYPE,EXP_REASON,CR_CDP,userid,getdate(),host_name()+'/'+@ip,'DELETE'
	from deleted
end

























