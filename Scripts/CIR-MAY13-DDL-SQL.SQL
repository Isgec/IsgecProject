////////////////add by Deepika 16/may/2013 sent by Sushil Sir

CREATE TABLE [dbo].[CIR_INTEREST_BILL_DETAIL](
    [COMP_CODE] [varchar](20) NOT NULL,
    [UNIT_CODE] [varchar](20) NULL,
    [BRAN_CODE] [varchar](20) NULL,
    [AGCD] [varchar](20) NULL,
    [DPCD] [varchar](20) NULL,
    [BILLNO] [varchar](50) NOT NULL,
    [BILLDT] [datetime] NOT NULL,
    [BILL_OSAMT] [numeric](18, 2) NULL,
    [BILL_ASON] [datetime] NULL,
    [INTT_RATE] [numeric](7, 2) NULL,
    [INTT_AMT] [numeric](18, 2) NULL,
    [INTT_DAYS] [int] NULL,
    [CREDIT_DAYS] [int] NULL,
    [OVERDUE_DAYS] [int] NULL,
    [POST_FLAG] [varchar](1) NULL,
    [CREATED_BY] [varchar](50) NULL,
    [CREATED_DT] [date] NULL,
    [INT_DATE] [date] NULL,
    [INT_DOC_TYPE] [varchar](25) NULL,
    [INT_DOC_NO] [varchar](50) NULL,
 CONSTRAINT [PK_CIR_INTEREST_BILL_DETAIL] PRIMARY KEY CLUSTERED
(
    [COMP_CODE] ASC,
    [BILLDT] ASC,
    [BILLNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]



ALTER TABLE [dbo].[CIR_INTEREST_BILL_DETAIL] ADD  DEFAULT ('N') FOR [POST_FLAG]


ALTER TABLE [dbo].[CIR_INTEREST_BILL_DETAIL] ADD  DEFAULT (getdate()) FOR [CREATED_DT]


//////////////////////////////end////////////////////////////////



////////////////////////////////////Add By Deepika 20-may-2013 sent by Sushil sir///////////////


alter table ad_rcpthdr  add VAT_FLAG_IN_CN VARCHAR(1) DEFAULT 'N'

alter table ad_rcpthdr  add VAT_CODE VARCHAR(10)

alter table ad_rcpthdr  add VAT_CDP VARCHAR(10)

alter table ad_rcpthdr  add VAT_BASE_AMT NUMERIC(10,2)

alter table ad_rcpthdr  add VAT_AMT NUMERIC(10,2)


/////////////////////////////////////end//////////////////////////////////////////////////

alter table cir_rcphdr add SCH_OPT varchar(6),R_ID varchar(15)
alter table cir_rcpdet add SCH_OPT varchar(6),R_ID varchar(15)
alter table cir_outmast add SCH_OPT varchar(6),R_ID varchar(15)


alter table cir_rcphdr_temp add SCH_OPT varchar(6),R_ID varchar(15)
alter table cir_rcpdet_temp add SCH_OPT varchar(6),R_ID varchar(15)
alter table cir_outmast_temp add SCH_OPT varchar(6),R_ID varchar(15)


//////////////////////////////add by Deepika 10/06/2013//////////////////////////////


alter table CIR_RCPHDR ADD VAT_FLAG_IN_CN varchar(1) 
alter table CIR_RCPHDR ADD VAT_CODE       varchar(10)
alter table CIR_RCPHDR ADD VAT_CDP        varchar(10)
alter table CIR_RCPHDR ADD VAT_BASE_AMT   numeric(10, 2)
alter table CIR_RCPHDR ADD VAT_AMT        numeric(10, 2)
alter table CIR_RCPHDR ADD VAT_PER        numeric(10, 2)

////////////////////////end///////////////////////////

