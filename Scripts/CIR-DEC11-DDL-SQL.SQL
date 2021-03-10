/***********************mimoh 7dec 2011*********************************0005889****************/
ALTER TABLE CIR_SUSPEND_TRAN ADD AGENCY_UNBLOCK_TYPE VARCHAR(50)
ALTER TABLE CIR_SUSPEND_TRAN ADD AGENCY_UNBLOCK_APPROVAL VARCHAR(1)
/***********************mimoh 7dec 2011*********************************0005889****************/
/********************* Sushil 09-12-2011***********************/

alter table cir_dbksup add FINAL_SUPPLY_FLAG varchar(1)

alter table cir_dbksup_dis add FINAL_SUPPLY_FLAG varchar(1)

/********************* Sushil 09-12-2011***********************/
/***********************Laxman 12-dec-2011**************************/
CREATE TABLE CIR_SPONS_HDR
(COMP_CODE      VARCHAR(8) NOT NULL,
 SPONS_ID       NUMERIC(6) NOT NULL,     
 UNIT_CODE      VARCHAR(8) NOT NULL,
 BRAN_CODE      VARCHAR(8),
 SPONS_AGCD     VARCHAR(8) NOT NULL,
 SPONS_DPCD     VARCHAR(8) NOT NULL,
 SPONS_ST_DATE  DATETIME   NOT NULL,
 SPONS_END_DATE DATETIME   NOT NULL,
 CREATED_BY     VARCHAR(30),
 CREATED_DT     DATE DEFAULT GETDATE(),
 UPDATED_BY     VARCHAR(30),
 UPDATED_DT     DATETIME,
 CONSTRAINT CIR_SPONS_HDR_PK PRIMARY KEY(COMP_CODE, SPONS_ID))
 
 CREATE TABLE CIR_SPONS_DET
(COMP_CODE          VARCHAR(8) NOT NULL,
 SPONS_ID           NUMERIC(6) NOT NULL,     
 UNIT_CODE          VARCHAR(8) NOT NULL,
 BRAN_CODE          VARCHAR(8),
 SPONS_AGCD         VARCHAR(8) NOT NULL,
 SPONS_DPCD         VARCHAR(8) NOT NULL,
 SPONS_ST_DATE      DATETIME   NOT NULL,
 SPONS_END_DATE     DATETIME   NOT NULL,
 PUBL               VARCHAR(8) NOT NULL,
 EDTN               VARCHAR(8) NOT NULL,
 SUP_TY_CODE        VARCHAR(8) NOT NULL,
 SPONS_COPY         NUMERIC(5)   NOT NULL,
 SPONS_COPY_RATE    NUMERIC(12,2)NOT NULL,
 SPONS_LIMIT_AMT    NUMERIC(15,2)NOT NULL,
 SUP_AGCD           VARCHAR(8) NOT NULL,
 SUP_DPCD           VARCHAR(8) NOT NULL,
 CREATED_BY         VARCHAR(30),
 CREATED_DT         DATETIME   DEFAULT GETDATE(),
 UPDATED_BY         VARCHAR(30),
 UPDATED_DT         DATETIME,
 CONSTRAINT CIR_SPONS_DET_PK PRIMARY KEY(COMP_CODE,SPONS_ID,PUBL,EDTN,SUP_TY_CODE,SUP_AGCD,SUP_DPCD),
 CONSTRAINT CIR_SPONS_DET_FK FOREIGN KEY (COMP_CODE,SPONS_ID) REFERENCES CIR_SPONS_HDR(COMP_CODE,SPONS_ID)
 ON DELETE CASCADE)


/***********************Laxman 12-dec-2011**************************/
//////////////////13-dec

/****** Object:  Table [dbo].[CIR_INCT_PROCESS_DET_TEMP]    Script Date: 12/13/2011 13:04:49 ******/
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
	[TOT_SUPPLY] [numeric](7, 0) NULL DEFAULT ((0)),
	[FROM_SUPPLY] [numeric](7, 0) NULL DEFAULT ((0)),
	[TILL_SUPPLY] [numeric](7, 0) NULL DEFAULT ((0)),
	[INCT_RATE] [numeric](10, 2) NULL DEFAULT ((0)),
	[CALC_TYPE] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL DEFAULT ('P'),
	[AMOUNT] [numeric](12, 2) NOT NULL,
	[DOCTYPE] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RECPTDT] [datetime] NOT NULL,
	[RECPTNO] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BILAGCD] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BILDPCD] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CREATED_BY] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CREATED_DATE] [datetime] NULL DEFAULT (getdate()),
	[UPDATED_BY] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UPDATED_DATE] [dbo].[Date] NULL,
	[TRAN_TYPE] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL DEFAULT ('EXP'),
	[REASON] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EXP_TYPE_CODE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FINAL_PROCESS] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL DEFAULT ('N')
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[DateOnlyRule]', @objname=N'[dbo].[CIR_INCT_PROCESS_DET_TEMP].[UPDATED_DATE]' , @futureonly='futureonly'
///////////////////////////13-dec

CREATE TABLE [dbo].[CIR_INCT_PROCESS_DET](
	[COMP_CODE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UNIT_CODE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PUBL_CODE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EDTN_CODE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SUP_TYPE_CODE] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FROM_PDATE] [datetime] NULL,
	[TILL_PDATE] [datetime] NULL,
	[AGCD] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DPCD] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TOT_SUPPLY] [numeric](7, 0) NULL DEFAULT ((0)),
	[FROM_SUPPLY] [numeric](7, 0) NULL DEFAULT ((0)),
	[TILL_SUPPLY] [numeric](7, 0) NULL DEFAULT ((0)),
	[INCT_RATE] [numeric](10, 2) NULL DEFAULT ((0)),
	[CALC_TYPE] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL DEFAULT ('P'),
	[AMOUNT] [numeric](12, 2) NOT NULL,
	[DOCTYPE] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RECPTDT] [datetime] NOT NULL,
	[RECPTNO] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BILAGCD] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BILDPCD] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CREATED_BY] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CREATED_DATE] [datetime] NULL DEFAULT (getdate()),
	[UPDATED_BY] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UPDATED_DATE] [dbo].[Date] NULL,
	[TRAN_TYPE] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL DEFAULT ('EXP'),
	[REASON] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EXP_TYPE_CODE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
/************************* 14-dec-2011 Laxman ******************/
ALTER TABLE PREFERRENCES  ADD CIR_BILL_PUBLWISE VARCHAR(1) DEFAULT 'N'

ALTER TABLE CIR_INCT_PROCESS_DET_TEMP ADD SUPPLY_ON_CALC   NUMERIC(7),NO_OF_DAYS NUMERIC(5)

ALTER TABLE CIR_INCT_PROCESS_DET ADD SUPPLY_ON_CALC   NUMERIC(7),NO_OF_DAYS NUMERIC(5)

ALTER TABLE CIR_UNSOLD_HDR ADD BRANCH_TRFNO    VARCHAR(20),BRANCH_TRFDT    DATETIME,BRANCH_TRF_USERID VARCHAR(20)

ALTER TABLE CIR_UNSOLD_DTL ADD NO_OF_PACKET NUMERIC(5)
/************************* 14-dec-2011 Laxman ******************/

/***********************Neha*********************************/


CREATE TABLE [dbo].[CIR_SUPL_PROCESS_DET_temp](
	[COMP_CODE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UNIT_CODE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PUBL_CODE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EDTN_CODE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SUPDATE] [datetime] NOT NULL,
	[AGCD] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DPCD] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TOT_SUPPLY] [numeric](7, 0) NULL CONSTRAINT [DF__CIR_SUPL___TOT_S__70CA4BED1]  DEFAULT ((0)),
	[PER_COPY_RATE] [numeric](7, 2) NULL CONSTRAINT [DF__CIR_SUPL___PER_C__71BE70261]  DEFAULT ((0)),
	[NO_OF_SUPL] [numeric](3, 0) NULL CONSTRAINT [DF__CIR_SUPL___NO_OF__72B2945F1]  DEFAULT ((1)),
	[DOCTYPE] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RECPTDT] [datetime] NOT NULL,
	[RECPTNO] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AMOUNT] [numeric](12, 2) NOT NULL,
	[BILAGCD] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BILDPCD] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CREATED_BY] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CREATED_DATE] [datetime] NULL CONSTRAINT [DF__CIR_SUPL___CREAT__73A6B8981]  DEFAULT (getdate()),
	[UPDATED_BY] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UPDATED_DATE] [datetime] NULL,
	[SUPL_NAME] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [CIR_SUPL_PROCESS_DET_temp_PK] PRIMARY KEY CLUSTERED 
(
	[COMP_CODE] ASC,
	[UNIT_CODE] ASC,
	[PUBL_CODE] ASC,
	[EDTN_CODE] ASC,
	[SUPDATE] ASC,
	[AGCD] ASC,
	[DPCD] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
/****************************19-dec-2011*******************/
ALTER TABLE CIR_UNSOLD_APR_PERMISSION ADD PRINTING_CENTER  VARCHAR(20),REGION VARCHAR(20),ZONE  VARCHAR(20),PUBL  VARCHAR(20),EDTN   VARCHAR(20),SUB_EDTN  VARCHAR(20),FREQUENCY   VARCHAR(20),UNS_APR_DAYS  NUMERIC(10)

ALTER TABLE CIR_LATE_FEE_MAST ADD RATE_TYPE VARCHAR(1) DEFAULT 'F'

/****************************19-dec-2011*******************/
/*******************************Laxman 21-dec-2011*************/
CREATE TABLE CIR_RCPHDR_PROV
( COMP_CODE      VARCHAR(8)    NOT NULL,
  UNIT_CODE      VARCHAR(8)    NOT NULL,
  DOCTYPE        VARCHAR(3)    NOT NULL,
  AGCD           VARCHAR(8)    NOT NULL,
  DPCD           VARCHAR(8)    NOT NULL,
  RECPTNO        VARCHAR(20)   NOT NULL,
  RECPTDT        DATETIME      NOT NULL,
  CHNO           VARCHAR(30),
  CHDT           DATETIME,
  CHBANK         VARCHAR(30),
  AMOUNT         NUMERIC(14,2) DEFAULT 0,
  OTH_AMOUNT     NUMERIC(14,2),
  CCDP           VARCHAR(14),
  CCDS           VARCHAR(10),
  RCDP           VARCHAR(14),
  RCDS           VARCHAR(10),
  OCDP           VARCHAR(14),
  OCDS           VARCHAR(10),
  REASON         VARCHAR(200),
  REMARK         VARCHAR(200),
  ACHD           VARCHAR(3)    DEFAULT 'NM',
  PUBL           VARCHAR(5),
  RECEIVED_FROM  VARCHAR(100),
  STATUS         VARCHAR(1),
  REF_RECPTNO    VARCHAR(20),
  REF_RECPTDT    DATETIME,
  REF_DOCTYPE    VARCHAR(3),
  USERID         VARCHAR(10),
  CREATION_DATE  DATETIME      DEFAULT GETDATE(),
  BRANCH_CODE    VARCHAR(8),
  BKUP_SNO       NUMERIC(30),
  UPDATED_BY     VARCHAR(20),
  UPDATED_DT     DATETIME,      
  CONSTRAINT CIR_RCPHDR_PROV_PK PRIMARY KEY (COMP_CODE, UNIT_CODE, DOCTYPE, RECPTNO))

  CREATE TABLE AD_RCPTHDR_SEC
( UNIT               VARCHAR(10)          NOT NULL,
  AGCODE             VARCHAR(18)          NOT NULL,
  DOCTYPE            VARCHAR(20)          NOT NULL,
  ROIDNUM            VARCHAR(12),
  RECPTNO            VARCHAR(20)          NOT NULL,
  RECPTDT            DATETIME             NOT NULL,
  CHNO               VARCHAR(30),
  CHDT               DATETIME,
  BANK               VARCHAR(30),
  AMOUNT             NUMERIC(15,2),
  OTH_AMOUNT         NUMERIC(15,2),
  REASON             VARCHAR(10),
  VOUCHERNO          VARCHAR(20),
  CASHBANK           VARCHAR(8),
  REVENUE            VARCHAR(8),
  REPCODE            VARCHAR(8),
  STATION            VARCHAR(30),
  REMARK             VARCHAR(200),
  REF_RECPTNO        VARCHAR(20),
  REF_RECPTDT        DATETIME,
  REF_AMOUNT         NUMERIC(15,2),
  REF_DOCTYPE        VARCHAR(3),
  USERID             VARCHAR(8)           NOT NULL,
  USERDATE           DATETIME,
  USERIP             VARCHAR(16),
  COMP_CODE          VARCHAR(8)           NOT NULL,
  CREATION_DATETIME  DATETIME             DEFAULT GETDATE(),
  RECEIVED_REGION    VARCHAR(8)           NOT NULL,
  VOUCHERDATE        DATETIME,
  AG_MAIN_CODE       VARCHAR(8),
  AG_SUB_CODE        VARCHAR(8),
  FLAG               VARCHAR(10),
  UPDATED_BY         VARCHAR(30),
  UPDATED_DT         DATETIME,
  BKUP_SNO           NUMERIC(30),
  CONSTRAINT AD_RCPTHDR_SEC_PK PRIMARY KEY (COMP_CODE, UNIT, DOCTYPE, RECPTNO))

ALTER TABLE CIR_INCT_PROCESS_DET_TEMP ADD CN_THROUGH VARCHAR(1);
ALTER TABLE CIR_INCT_PROCESS_DET ADD CN_THROUGH VARCHAR(1);
/*******************************Laxman 21-dec-2011*************/
/*******************************Laxman 23-dec-2011*************/
ALTER TABLE CIR_AGENCY_REMARK ADD EFFECTIVE_TILL DATETIME
/*******************************Laxman 23-dec-2011*************/
/*******************************Laxman 26-dec-2011 issue no. 6137*************/
ALTER TABLE CRM_SCH_PUBL_EXPIRY ADD (EDITION_CODE VARCHAR(3),AGCD VARCHAR(8),DPCD VARCHAR(8),SUP_TY_CODE VARCHAR(5))

ALTER TABLE PREFERRENCES ADD (CRM_SUPPLY_TYPE_PAID VARCHAR(5),CRM_SUPPLY_TYPE_FREE VARCHAR(5))
/*******************************Laxman 26-dec-2011 issue no. 6137*************/
/*******************************Laxman 27-dec-2011*************/
ALTER TABLE CIR_INCT_SLAB_HDR ADD RMRK VARCHAR(200)

/*******************************Laxman 27-dec-2011*************/

/***********************mimoh 28dec 2011*********6162****************************************/
alter table PREFERRENCES add CURRENCY_MEASUREMENT varchar(5)
/***********************mimoh 28dec 2011*********6162****************************************/







/************************************rahul 3 jan 2012**************************************************************/
ALTER PROCEDURE  [dbo].[Cir_Route_Bind1]

  	@pcompcode as varchar(200),
   	@punitcode as varchar(200),
    @prtcode as varchar(200),
    @pdateformat as	varchar(200),
    @pextra1 as	varchar(200),
    @pextra2 as varchar(200)

 AS
   
 select * from cir_route_mast
   	         where comp_code=@pcompcode and 
                   unit=@punitcode and 
                   (route_code=@prtcode or replace(@prtcode,null,'0')='0' or  @prtcode = '')

and (route_name like @pextra1+'%' or @pextra1 is null or @pextra1='')
 and
                    ISNULL(freeze_flag,'N')='N'
   	         order by route_code







/*************/

ALTER PROCEDURE  [dbo].[Cir_SubRoute_Bind1]
  	@pcompcode		as	varchar(200),
    @punitcode		as	varchar(200),
    @proutecode		as	varchar(200),
    @psubrtcode		as	varchar(200),
    @pdateformat	as	varchar(200),
    @pextra1		as	varchar(200),
    @pextra2		as	varchar(200)
 AS
   select a.comp_code COMP_CODE,a.unit UNIT,a.route_code ROUTE_CODE,dbo.cir_get_route_name(a.comp_code,a.unit,a.route_code) ROUTE_NAME,a.subrt_code SUBRT_CODE,
           a.subrt_name SUBRT_NAME,a.subrt_name_oth_lang SUBRT_NAME_OTH_LANG,a.subrt_mode SUBRT_MODE,
           (select b.mode_desc from cir_route_mode_mast b where b.comp_code=a.comp_code and b.mode_code=a.subrt_mode) as MODE_NAME,
           a.start_point START_POINT,a.end_point END_POINT,a.subrt_dist SUBRT_DIST,a.subrt_seq SUBRT_SEQ,
           (select c.drop_point_name from cir_drop_point_mast c	where a.comp_code=c.comp_code and a.unit=c.unit_code and a.start_point=c.drop_point) START_DROP_POINT_NAME,
           (select d.drop_point_name from cir_drop_point_mast d	where a.comp_code=d.comp_code and a.unit=d.unit_code and a.end_point=d.drop_point) END_DROP_POINT_NAME
       from cir_sub_route_mast a
       where a.comp_code=@pcompcode and
             a.unit=@punitcode and
             (a.route_code=@proutecode or isnull(@proutecode,'0')='0' or @proutecode='') and
             (a.subrt_code=@psubrtcode or isnull(@psubrtcode,'0')='0' or @psubrtcode='')
              and ((upper(subrt_name) like upper(@pextra1)+'%') or (@pextra1 is null) or (@pextra1=''))
              and (a.subrt_mode=@pextra2 or @pextra2 is null or @pextra2='')
             --and nvl(a.freeze_flag,'N')='N'
       order by route_name,subrt_name;

/*****************************/



ALTER PROCEDURE  [dbo].[Cir_SubSubRoute_Bind1]
  	@pcompcode as varchar(200),
    @punitcode as varchar(200),
    @proutecode as varchar(200),
    @psubrtcode as varchar(200),
    @psubsubrtcode as varchar(200),
    @pdateformat as	varchar(200),
    @pextra1 as	varchar(200),
    @pextra2 as varchar(200)

 AS

 select cir_sub_subroute_mast.*,dbo.cir_get_route_name(cir_sub_subroute_mast.comp_code,cir_sub_subroute_mast.unit,cir_sub_subroute_mast.route_code) "ROUTE NAME",
  	    dbo.cir_get_subroute_name(cir_sub_subroute_mast.comp_code,cir_sub_subroute_mast.unit,cir_sub_subroute_mast.route_code,cir_sub_subroute_mast.subrt_code) "SUBROUTE NAME",
  	    dbo.cir_get_drop_point_name(cir_sub_subroute_mast.comp_code,cir_sub_subroute_mast.unit,cir_sub_subroute_mast.start_point,1) START_DROP_POINT_NAME,
   	    dbo.cir_get_drop_point_name(cir_sub_subroute_mast.comp_code,cir_sub_subroute_mast.unit,cir_sub_subroute_mast.end_point,1) END_DROP_POINT_NAME,
   	    sub_subrt_mode SUB_SUBRT_MODE, (select b.mode_desc from cir_route_mode_mast b where b.comp_code=cir_sub_subroute_mast.comp_code and b.mode_code=cir_sub_subroute_mast.sub_subrt_mode) as MODE_NAME
  	    from cir_sub_subroute_mast
              where comp_code=@pcompcode and
                    unit=@punitcode and
  	                (route_code=@proutecode OR @proutecode is null or @proutecode='') and
                    (subrt_code=@psubrtcode or @psubrtcode is null or @psubrtcode='') and
                    (sub_subrt_code=@psubsubrtcode or isnull(@psubsubrtcode,'0')='0' or @psubsubrtcode='') 
                    and (sub_subrt_mode=@pextra2 or @pextra2 is null or @pextra2='')
                    /*and
                    nvl(freeze_flag,'N')='N'*/
  	          order by route_code,subrt_code,sub_subrt_code;



/******************************************/


ALTER PROCEDURE [dbo].[cir_transporter_bind_cir_transporter_bind_p]
	@pcomp_code                               VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(400) ,
	@pextra2                                  VARCHAR(400) 
AS 

	SELECT * FROM  cir_transporter_mast 
	WHERE comp_code  = @pcomp_code and (transporter_name like @pextra1+'%' or @pextra1 is null or @pextra1='')
	ORDER BY transporter_code 
	
	
	
	
	/***************************************end of rahul 3 jan 2012******************************/

/**************************sponsership master laxman ***********************/
ALTER TABLE CIR_SPONS_DET ADD SPONS_AMT NUMERIC(15,2)
/**************************sponsership master laxman ***********************/
