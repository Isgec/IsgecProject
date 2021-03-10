
////////////////////////ADD BY DEEPIKA 08/10/2012 SENT BY AMIT SIR//////////////////////////

CREATE TABLE [dbo].[CIR_BILL_STATEMENT_NO](
	[COMP_CODE] [varchar](10) NOT NULL,
	[UNIT_CODE] [varchar](10) NOT NULL,
	[BRANCH_CODE] [varchar](10) NOT NULL,
	[AGCD] [varchar](20) NOT NULL,
	[DPCD] [varchar](10) NOT NULL,
	[PROCESS_DT] [varchar](20) NOT NULL,
	[FREQ] [varchar](2) NOT NULL,
	[U_NO] [varchar](20) NOT NULL
) ON [PRIMARY]
/////////////////////////
alter table preferrences add  online_pay_no varchar(20)

//////////////////////////////////////END///////////////////////////////////

////add by deepika 06/11/2012 sent by gaurav sir////

alter table CIR_BILL_STATEMENT_NO alter column process_dt datetime not null

///////////////////////end/////////////////////////////////