
-------------------------naman----------------------
alter table cir_edtn_mast add PERIOD numeric(5, 0)







CREATE TABLE [dbo].[Cir_Edition_Issue_Date](
	[COMP_CODE] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Pub_code] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Edition_code] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Frequency_code] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[First_Issue] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Second_Issue] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Create_UserId] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Creation_Datetime] [datetime] NULL DEFAULT (getdate()),
	[Update_Userid] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Update_Datetime] [datetime] NULL
) ON [PRIMARY]



----------------------------------------------------



--------------start------------07/03/2012---------anurag--------------------

USE [abhi]
GO
/****** Object:  StoredProcedure [dbo].[cir_rep_outstanding_cir_rep_outstanding_summ_p]    Script Date: 03/07/2012 12:11:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[cir_rep_outstanding_cir_rep_outstanding_summ_p]
	@pcompcode                                VARCHAR(20) ,
	@punitcode                                VARCHAR(20) ,
	@ppublcode                                VARCHAR(20) ,
	@pactype                                  VARCHAR(20) ,
	@pagency_type                             VARCHAR(20) ,
	@pagcd                                    VARCHAR(20) ,
	@pdpcd                                    VARCHAR(20) ,
	@prep_type                                VARCHAR(20) ,--statewise or districtwise or talukawise or branchwise
	@pcode                                    VARCHAR(20) ,
	@pfromdate                                VARCHAR(20) ,
	@pasondate                                VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000),--it is used for executive
	@pextra2                                  VARCHAR(4000) 
AS 
	
	DECLARE @v_frdt                           DATETIME 
	DECLARE @v_todt                           DATETIME 
	DECLARE @v_opdate                         DATETIME 
	DECLARE @v_opbal                          NUMERIC(15,2)                   
	SET @v_opbal = 0 
	DECLARE @v_clbal                          NUMERIC(15,2)
	SET @v_clbal = 0 
	DECLARE @v_billamt                        NUMERIC(15,2)                           
	SET @v_billamt = 0 
	DECLARE @v_dbcramt                        NUMERIC(15,2)                           
	SET @v_dbcramt = 0 
	DECLARE @v_recamt                         NUMERIC(15,2)                           
	SET @v_recamt = 0 
	DECLARE @v_othdbamt                       NUMERIC(15,2)                           
	SET @v_othdbamt = 0 
	DECLARE @v_othcramt                       NUMERIC(15,2)                           
	SET @v_othcramt = 0 


	DECLARE @v_comp_code1                             varchar(10)
	DECLARE @v_unit1                                  varchar(10)
	DECLARE @v_agcd1                                  varchar(10)
	DECLARE @v_dpcd1                                  varchar(10)
	DECLARE @v_ag_name1                               varchar(50)
	DECLARE @v_ag_name_oth_lang1                      varchar(200)
	DECLARE @v_city_code1                             varchar(200)
	DECLARE @v_tehsil_taluka1                         varchar(200)
	DECLARE @v_dist_code1                             varchar(200)
	DECLARE @v_state_code1                            varchar(200)
	DECLARE @v_country_code1                          varchar(200)

if @ppublcode='' begin
	set @ppublcode=null
end
if @pagency_type=''
begin
	set @pagency_type=null
end
if @pagcd=''
begin
	set @pagcd=null
end
if @pdpcd=''
begin
	set @pdpcd=null
end
if	@pcode=''
begin
	set @pcode=null
end
if	@pextra1=''
begin
	set @pextra1=null
end
if	@pextra2=''
begin
	set @pextra2=null
end
print('0')


	DECLARE c1 cursor LOCAL FOR 
		SELECT DISTINCT comp_code, unit, agcd, dpcd, ag_name, ag_name_oth_lang, city_code, tehsil_taluka, dist_code,
		state_code, country_code,branch_code
		FROM  cir_agmast 
		WHERE comp_code  = @pcompcode AND unit  = @punitcode 
		AND	(ag_type  = @pagency_type OR	@pagency_type  is null or @pagency_type='')
		AND	(EXECUTIVE_CODE  = @pextra1 OR	@pextra1  is null or @pextra1='')
		/*AND	agcd + dpcd  in
			(SELECT DISTINCT CAST(agcd AS VARCHAR) + CAST(dpcd AS VARCHAR)
			FROM  cir_outmast 
			WHERE comp_code  = @pcompcode AND	unit_code  = @punitcode	AND	achd  = @pactype
			AND	(publ  = @ppublcode OR	@ppublcode  is null OR	@ppublcode = '')) */
			and agcd=isnull(@pagcd,agcd) and dpcd=isnull(@pdpcd,dpcd) and
			(((state_code=@pcode or @pcode is null) and @prep_type='1') or
			((dist_code=@pcode or @pcode is null) and @prep_type='2') or
			((tehsil_taluka=@pcode or @pcode is null) and @prep_type='3')or
			((branch_code=@pcode or @pcode is null) and @prep_type='4'));
Begin
CREATE TABLE #CIR_TEMP_OUTSTANDING
( COMP_CODE        VARCHAR(100),
  UNIT_CODE        VARCHAR(100),
  DT               DATETIME,
  PUBL_CODE        VARCHAR(100),
  AGCD             VARCHAR(100),
  DPCD             VARCHAR(100),
  BILL_AMT         NUMERIC(15,2)	DEFAULT 0,
  RETURN_AMT       NUMERIC(15,2)	DEFAULT 0,
  DN_AMT           NUMERIC(15,2)	DEFAULT 0,
  CN_AMT           NUMERIC(15,2)	DEFAULT 0,
  REC_AMT          NUMERIC(15,2)	DEFAULT 0,
  AGNAME           VARCHAR(200),
  AGNAME_OTH_LANG  VARCHAR(250),
  CITY_CODE        VARCHAR(200),
  TALUKA_CODE      VARCHAR(200),
  DIST_CODE        VARCHAR(200),
  STATE_CODE       VARCHAR(200),
  COUNTRY_CODE     VARCHAR(200),
  OP_AMT           NUMERIC(15,2),
  BRANCH_CODE      VARCHAR(8)
);
declare @v_branch_code varchar(8)
	SET @v_opdate  = DBO.cir_get_finandt(@pcompcode, dbo.convert_user_date('/', @pfromdate , @pdateformat), @pdateformat, '', '')

	SET @v_frdt  = dbo.convert_user_date('/', @pfromdate, @pdateformat)
	SET @v_todt  = dbo.convert_user_date('/', @pasondate, @pdateformat)
		
	OPEN c1 
	fetch NEXT FROM c1 INTO @v_comp_code1 ,@v_unit1, @v_agcd1,@v_dpcd1 ,@v_ag_name1,@v_ag_name_oth_lang1,@v_city_code1,
            @v_tehsil_taluka1, @v_dist_code1, @v_state_code1,@v_country_code1,@v_branch_code

	WHILE (@@FETCH_STATUS = 0) 
	BEGIN 
		SET @v_opbal  = DBO.cir_accounts_cir_agency_opbal(@pcompcode, @punitcode, @ppublcode, @v_agcd1, @v_dpcd1, @v_opdate, @pactype, @pdateformat, @pextra1, @pextra2)
			select @v_billamt =sum(amount) from cir_outmast
                where comp_code=@pcompcode and unit_code=@punitcode and 
                    agcd=@v_agcd1 and dpcd=@v_dpcd1 and billdt >= @v_opdate and billdt<@v_frdt and 
                    achd=@pactype and (publ=@ppublcode or @ppublcode is null OR @ppublcode = '') and recptno is null
                                
            select @v_dbcramt=sum(amount) from cir_rcphdr
                where comp_code=@pcompcode and unit_code=@punitcode  and 
                    agcd=@v_agcd1 and dpcd=@v_dpcd1 and recptdt>= @v_opdate and recptdt<@v_frdt and 
                    achd=@pactype and (publ=@ppublcode or @ppublcode is null OR	@ppublcode = '')
            
			
			select @v_billamt=sum(amount)  from cir_outmast
                where comp_code=@pcompcode and unit_code=@punitcode and 
					agcd=@v_agcd1 and dpcd=@v_dpcd1 and billdt >= @v_frdt and billdt<=@v_todt and 
					achd=@pactype and (publ=@ppublcode or @ppublcode is null OR @ppublcode = '') and recptno is null
            
            select @v_othdbamt=sum(amount) from cir_rcphdr
                where comp_code=@pcompcode and unit_code=@punitcode and 
                            agcd=@v_agcd1 and dpcd=@v_dpcd1 and recptdt>= @v_frdt and recptdt<=@v_todt and 
                            achd=@pactype and (publ=@ppublcode or @ppublcode is null OR @ppublcode = '') and isnull(amount,0)>0;

            select @v_recamt =sum(amount) from cir_rcphdr
                where comp_code=@pcompcode and unit_code=@punitcode and 
                            agcd=@v_agcd1 and dpcd=@v_dpcd1 and recptdt>= @v_frdt and recptdt<=@v_todt and doctype='RCR' and 
                            achd=@pactype and (publ=@ppublcode or @ppublcode is null OR @ppublcode = '') and isnull(amount,0)<0

            select  @v_othcramt=sum(amount) from cir_rcphdr
                where comp_code=@pcompcode and unit_code=@punitcode and 
                            agcd=@v_agcd1 and dpcd=@v_dpcd1 and recptdt>= @v_frdt and recptdt<=@v_todt and doctype<>'RCR' and 
                            achd=@pactype and (publ=@ppublcode or @ppublcode is null OR @ppublcode = '') and isnull(amount,0)<0
			
			set @v_clbal=isnull(@v_opbal,0)+isnull(@v_billamt,0)+isnull(@v_othdbamt,0)+isnull(@v_recamt,0)+isnull(@v_othcramt,0)
			
			if (@v_clbal<>0  or @v_opbal<>0 or @v_billamt<>0 or @v_othdbamt<>0 or @v_recamt<>0 or @v_othcramt<>0)
			BEGIN 
				INSERT INTO  #cir_temp_outstanding (comp_code ,unit_code , dt , publ_code , agcd , dpcd , op_amt , 
				bill_amt , dn_amt , rec_amt , cn_amt , agname , agname_oth_lang , city_code , taluka_code , dist_code , 
				state_code , country_code,BRANCH_CODE )  
				VALUES 	( @v_comp_code1 , @v_unit1 , @v_frdt , @ppublcode , @v_agcd1 , @v_dpcd1 , isnull(@v_opbal, 0) , 
				isnull(@v_billamt, 0) , isnull(@v_othdbamt, 0) , isnull(@v_recamt, 0) , isnull(@v_othcramt, 0) , @v_ag_name1 , 
				@v_ag_name_oth_lang1 , @v_city_code1 , @v_tehsil_taluka1 , @v_dist_code1 , @v_state_code1 , @v_country_code1,@v_branch_code )  
				

			END
   
			SET @v_billamt  = 0 
			SET @v_dbcramt  = 0 
			SET @v_opbal  = 0 
			SET @v_clbal  = 0 
			SET @v_recamt  = 0 
			SET @v_othdbamt  = 0 
			SET @v_othcramt  = 0 
			
            fetch NEXT FROM c1 INTO @v_comp_code1 ,@v_unit1, @v_agcd1,@v_dpcd1 ,@v_ag_name1,@v_ag_name_oth_lang1,@v_city_code1,
            @v_tehsil_taluka1, @v_dist_code1, @v_state_code1,@v_country_code1,@v_branch_code

		END 
		close c1
		
		print('1')
		IF @prep_type = '1' --for statewise group
		BEGIN 
			print('2')
			select a.comp_code comp_code,a.unit_code unit_code,a.state_code rep_type_code,substring(dbo.cir_get_state(a.comp_code,a.country_code,a.state_code),1,30) rep_type_name,
                    a.agcd agcd,a.dpcd dpcd,a.op_amt op_amt,a.bill_amt billamt,a.dn_amt other_dbamt,a.rec_amt recamt,a.cn_amt other_cramt,
                    isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0) cl_amt,
                    a.agname agname,a.agname_oth_lang agname_oth_lang,
                    a.city_code city_code,substring(dbo.cir_get_city(a.comp_code,a.city_code),1,30) city_name
                    from #cir_temp_outstanding a
            order by a.comp_code,a.unit_code,rep_type_name,a.agname
			
			select x.comp_code comp_code,x.unit_code unit_code,x.state_code rep_type_code,x.state_name rep_type_name,sum(x.op_amt) op_amt,sum(x.bill_amt) billamt,sum(x.dn_amt) other_dbamt,
                    sum(x.rec_amt) recamt,sum(x.cn_amt) other_cramt,
                    sum(isnull(x.op_amt,0)+isnull(x.bill_amt,0)+isnull(x.dn_amt,0)+isnull(x.rec_amt,0)+isnull(x.cn_amt,0)) cl_amt from
        (select a.comp_code comp_code,a.unit_code unit_code,a.state_code state_code,substring(dbo.cir_get_state(a.comp_code,a.country_code,a.state_code),1,30) state_name,
                    sum(a.op_amt) op_amt,sum(a.bill_amt) bill_amt,sum(a.dn_amt) dn_amt,sum(a.rec_amt) rec_amt,sum(a.cn_amt) cn_amt,
                    sum(isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0)) cl_amt
                    from #cir_temp_outstanding a
                    group by a.comp_code,a.unit_code,a.state_code,a.country_code) x
                    group by x.comp_code,x.unit_code,x.state_code,x.state_name
            order by comp_code,unit_code,rep_type_name
		END
		else IF @prep_type = '2' 
		BEGIN 
		print('3')
			--for district wise group
			select a.comp_code comp_code,a.unit_code unit_code,a.dist_code rep_type_code,substring(dbo.cir_get_dist(a.comp_code,a.state_code,a.dist_code),1,30) rep_type_name,
                    a.agcd agcd,a.dpcd dpcd,a.op_amt op_amt,a.bill_amt billamt,a.dn_amt other_dbamt,a.rec_amt recamt,a.cn_amt other_cramt,
                    isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0) cl_amt,
                    a.agname agname,a.agname_oth_lang agname_oth_lang,
                    a.city_code city_code,substring(dbo.cir_get_city(a.comp_code,a.city_code),1,30) city_name
                    from #cir_temp_outstanding a
            order by a.comp_code,a.unit_code,rep_type_name,a.agname
		
			select x.comp_code comp_code, x.unit_code unit_code,x.dist_code rep_type_code,x.dist_name rep_type_name,sum(x.op_amt) op_amt,sum(x.bill_amt) billamt,sum(x.dn_amt) other_dbamt,
                    sum(x.rec_amt) recamt,sum(x.cn_amt) other_cramt,
                    sum(isnull(x.op_amt,0)+isnull(x.bill_amt,0)+isnull(x.dn_amt,0)+isnull(x.rec_amt,0)+isnull(x.cn_amt,0)) cl_amt from(
        select a.comp_code comp_code,a.unit_code unit_code,a.dist_code dist_code,substring(dbo.cir_get_dist(a.comp_code,a.state_code,a.dist_code),1,30) dist_name,
                    sum(a.op_amt) op_amt,sum(a.bill_amt) bill_amt,sum(a.dn_amt) dn_amt,sum(a.rec_amt) rec_amt,sum(a.cn_amt) cn_amt,
                    sum(isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0)) cl_amt
                    from #cir_temp_outstanding a
                    group by a.comp_code,a.unit_code,a.state_code,a.dist_code) x
                    group by x.comp_code,x.unit_code,x.dist_code,x.dist_name
            order by comp_code,unit_code,rep_type_name
		
		END
		else IF @prep_type = '3' 
		BEGIN 
			--for talukawise group
			print('4')
			select a.comp_code comp_code,a.unit_code unit_code,a.taluka_code rep_type_code,substring(dbo.cir_get_taluka(a.comp_code,a.taluka_code),1,30) rep_type_name,
                    a.agcd agcd,a.dpcd dpcd,a.op_amt op_amt,a.bill_amt billamt,a.dn_amt other_dbamt,a.rec_amt recamt,a.cn_amt other_cramt,
                    isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0) cl_amt,a.agname agname,a.agname_oth_lang agname_oth_lang,
                    a.city_code city_code,substring(dbo.cir_get_city(a.comp_code,a.city_code),1,30) city_name
                    from #cir_temp_outstanding a
	           order by a.comp_code,a.unit_code,rep_type_name,a.agname
			
			select x.comp_code comp_code,x.unit_code unit_code,x.taluka_code rep_type_code,x.taluka_name rep_type_name,
			sum(x.op_amt) op_amt,sum(x.bill_amt) billamt,sum(x.dn_amt) other_dbamt,sum(x.rec_amt) recamt,sum(x.cn_amt) other_cramt,
                    sum(isnull(x.op_amt,0)+isnull(x.bill_amt,0)+isnull(x.dn_amt,0)+isnull(x.rec_amt,0)+isnull(x.cn_amt,0)) cl_amt from
        (select a.comp_code comp_code,a.unit_code unit_code,a.taluka_code taluka_code,substring(dbo.cir_get_taluka(a.comp_code,a.taluka_code),1,30) taluka_name,
                    sum(a.op_amt) op_amt,sum(a.bill_amt) bill_amt,sum(a.dn_amt) dn_amt,sum(a.rec_amt) rec_amt,sum(a.cn_amt) cn_amt,
                    sum(isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0)) cl_amt
                    from #cir_temp_outstanding a
                    group by a.comp_code,a.unit_code,a.taluka_code)x
                    group by x.comp_code,x.unit_code,x.taluka_code,x.taluka_name
            order by comp_code,unit_code,rep_type_name;
			
		END
		else 
		begin
		print('8')

			select a.comp_code comp_code,a.unit_code unit_code,a.branch_code branch_code,dbo.AD_GET_BRANCHNAME (a.comp_code,a.branch_code) rep_type_name,
			a.agcd agcd,a.dpcd dpcd,a.op_amt op_amt,a.bill_amt billamt,a.dn_amt other_dbamt,a.rec_amt recamt,a.cn_amt other_cramt,
			isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0) cl_amt,
			a.agname agname,a.agname_oth_lang agname_oth_lang,
			a.city_code city_code,substring(dbo.cir_get_city(a.comp_code,a.city_code),1,30) city_name
			from #cir_temp_outstanding a
			order by a.comp_code,a.unit_code,a.branch_code,a.agname;

			select x.comp_code comp_code,x.unit_code unit_code,x.branch_code rep_type_code,x.branch_Name rep_type_name,
			sum(x.op_amt) op_amt,sum(x.bill_amt) billamt,sum(x.dn_amt) other_dbamt,
			sum(x.rec_amt) recamt,sum(x.cn_amt) other_cramt,
			sum(isnull(x.op_amt,0)+isnull(x.bill_amt,0)+isnull(x.dn_amt,0)+isnull(x.rec_amt,0)+isnull(x.cn_amt,0)) cl_amt from
			(select a.comp_code comp_code,a.unit_code unit_code,a.branch_code branch_code,dbo.AD_GET_BRANCHNAME (a.comp_code,a.branch_code) branch_name,
			sum(a.op_amt) op_amt,sum(a.bill_amt) bill_amt,sum(a.dn_amt) dn_amt,sum(a.rec_amt) rec_amt,sum(a.cn_amt) cn_amt,
			sum(isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0)) cl_amt
			from #cir_temp_outstanding a
			group by a.comp_code,a.unit_code,a.country_code,a.branch_code) x
			group by x.comp_code,x.unit_code ,x.branch_code ,x.branch_Name 
			order by comp_code,unit_code,rep_type_name;

		end



 DEALLOCATE c1
	drop table #cir_temp_outstanding;
End

-----------------------end------anurag----------------------------------------

//--------------------------------------start-------------------------//


SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CIR_RCPT_DOCUMENT_TEMP](
	[COMP_CODE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UNIT_CODE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DOCTYPE] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RECPTNO] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RECPTDT] [datetime] NOT NULL,
	[FILENAME] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CREATED_BY] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CREATED_DT] [datetime] NULL DEFAULT (getdate()),
	[UPDATED_BY] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UPDATED_DT] [datetime] NULL,
	[BKUP_SNO] [numeric](30, 0) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

//---------------------------------------end---------------------//

//-----------------------------start---------------------------//

SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CIR_RCP_UNADJ_TEMP](
	[COMP_CODE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UNIT_CODE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AGCD] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DPCD] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DOCTYP] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RECPTNO] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RECPTDT] [datetime] NOT NULL,
	[PUBL] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AMOUNT] [numeric](14, 2) NULL DEFAULT ((0)),
	[CREATED_BY] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CREATED_DATE] [datetime] NULL DEFAULT (getdate()),
	[UPDATED_BY] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UPDATED_DATE] [datetime] NULL
) ON [PRIMARY]

//---------------------------------------------end-------------------//

//------------------------------------------start---------------------------//

USE [abhi]
GO
/****** Object:  Table [dbo].[CIR_RCP_UNADJ]    Script Date: 03/14/2012 16:08:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CIR_RCP_UNADJ](
	[COMP_CODE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UNIT_CODE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AGCD] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DPCD] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DOCTYP] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RECPTNO] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RECPTDT] [datetime] NOT NULL,
	[PUBL] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AMOUNT] [numeric](14, 2) NULL DEFAULT ((0)),
	[CREATED_BY] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CREATED_DATE] [datetime] NULL DEFAULT (getdate()),
	[UPDATED_BY] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UPDATED_DATE] [datetime] NULL,
 CONSTRAINT [CIR_RCP_UNADJ_PK] PRIMARY KEY CLUSTERED 
(
	[COMP_CODE] ASC,
	[UNIT_CODE] ASC,
	[DOCTYP] ASC,
	[RECPTNO] ASC,
	[RECPTDT] ASC,
	[PUBL] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[CIR_RCP_UNADJ]  WITH CHECK ADD  CONSTRAINT [CIR_RCPHDR_UNADJ_FK] FOREIGN KEY([COMP_CODE], [UNIT_CODE], [DOCTYP], [RECPTNO], [RECPTDT])
REFERENCES [dbo].[CIR_RCPHDR] ([COMP_CODE], [UNIT_CODE], [DOCTYPE], [RECPTNO], [RECPTDT])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CIR_RCP_UNADJ] CHECK CONSTRAINT [CIR_RCPHDR_UNADJ_FK]

//----------------------------------------end----------------------//



//////////////////////////////////////deepika sent by sahani sir 13/03/2012////////////////////////////////
ALTER
TABLE CIR_AGMAST ADD PAN_NO VARCHAR(25)

ALTER
TABLE CIR_AGMAST ADD TAN_NO VARCHAR(25)

ALTER
TABLE CIR_AGMAST ADD SER_TAX_NO VARCHAR(25)


//////////////////////////////////////////////////////////////////////////////////////////////////////////

//-------------------------------------Ritu 21 mar-------------------//

CREATE TABLE CIR_TAXI_DP_TRANS
( COMP_CODE           VARCHAR(8),
  UNIT_CODE           VARCHAR(8),
  TAXI_ID             VARCHAR(5),
  ROUTE_CODE          VARCHAR(8),
  SUB_ROUTECODE       VARCHAR(10),
  SUB_SUBROUTE_CODE   VARCHAR(10),
  DROP_POINT_CODE     VARCHAR(10),  
  EXP_ARR_TIME        VARCHAR(50),
  EXP_DEP_TIME        VARCHAR(50),
  ARR_TIME            VARCHAR(5),
  DEP_TIME            VARCHAR(5),
  ARR_DATE            DATETIME,
  STOPAGE_TIME        VARCHAR(5),
  CREATED_DATE        DATETIME      DEFAULT GETDATE(),
  CREATED_BY          VARCHAR(8),
  LAST_UPDATED_BY     VARCHAR(8),
  LAST_UPDATED_DATE   DATETIME,
  CONSTRAINT CIR_TAXI_DP_TRANS_PK PRIMARY KEY
 (COMP_CODE, UNIT_CODE,ROUTE_CODE, TAXI_ID,DROP_POINT_CODE,ARR_DATE));

//-----------------------------------------end----------------------//

//----------------------------------start----------------------//
ALTER TABLE  PREFERRENCES add TAXI_ENTRY_TYPE VARCHAR(1)

ALTER TABLE CIR_TAXI_ROUTE add STATUS VARCHAR(1)

//--------------------------------------Add by Ritu------------------------//

//////////////////////////// isssue number 0006824 //////////update by Garima

alter table cir_inct_process_det_temp add CN_THROUGH varchar(50),EXP_TYPE_DESC varchar(200) 
//////////////////////////////////////////////////////////////////////



//--0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0- Updated by Nitish -0-0-0-0-0-0-0-0-0-0-0-0--//

alter table preferrences add CIR_BARCODE  varchar(10)

/////////////////////////////////////


===============7178===avinash==11apr2012==============start===========
alter table cir_edtn_mast add seg_code varchar(10)


===============7178===avinash==11apr2012==============end===========










