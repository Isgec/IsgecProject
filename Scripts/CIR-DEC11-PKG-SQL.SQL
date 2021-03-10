/***********************mimoh 7dec 2011*********************************0005889****************/

/*********new********************************************/
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER procedure [dbo].[cir_agency_unblock_approval]
    @pcomp_code         as varchar(200),
    @punit_code         as varchar(200),
    @pbran_code         as varchar(200),
    @pstatus            as varchar(200),
    @pfrdt              as datetime,
    @ptodt              as datetime,
    @pagcd              as varchar(200),
    @pdpcd              as varchar(200),
    @psuspty            as varchar(200),
    @puserid            as varchar(200) 
    as
Begin
	If @punit_code='' Begin
		set @punit_code=null
	End	
	If @pbran_code='' Begin
		set @pbran_code=null
	End	
	If @pstatus='' Begin
		set @pstatus=null
	End	
	If @pagcd='' Begin
		set @pagcd=null
	End					
	If @pdpcd='' Begin
		set @pdpcd=null
	End	
	If @psuspty='' Begin
		set @psuspty=null
	End		
	If @puserid='' Begin
		set @puserid=null
	End	

select s.comp_code as "COMP_CODE",s.unit as "UNIT",s.agcd as "AGCD",s.dpcd as "DPCD",m.ag_name as "AGENCY_NAME",s.start_date as "BLOCK_UNBLOCK_DATE",'' as "BLOCK_UNBLOCK_TIME",
         (SELECT SUSPEND_DESC FROM CIR_SUSPEND_TYPE_MAST WHERE COMP_CODE=s.COMP_CODE AND SUSPEND_TYPE_CODE=s.suspty) as "BLOCK_REASON",s.suspty as "SUSPTY",
         (SELECT max("username") from login where com_code = s.comp_code  and "userid"=s.userid) as "UNBLOCK_BY",s.suspty as "SUSPEND_TYPE",
         s.agency_unblock_approval as "AGENCY_UNBLOCK_APPROVAL",s.userid as "USERID",isnull(s.trn_date,convert(varchar(20),creation_date,103)) as "TRN_DATE" 
         from cir_suspend_tran s,cir_agmast m
      where s.comp_code = m.comp_code and s.comp_code = @pcomp_code
        and s.unit=m.unit and s.unit      = isnull(@punit_code,s.unit)
        and s.susp      = @pstatus
        and s.trn_date between @pfrdt and @ptodt
        and s.agcd=m.agcd and s.agcd    = isnull(@pagcd,s.agcd)
        and s.dpcd=m.dpcd and s.dpcd    = isnull(@pdpcd,s.dpcd)
        and s.userid  = isnull(@puserid,s.userid)
        and isnull(s.agency_unblock_approval,'N')='N'    
  
End 






/*****************************************************************************************************/
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER PROCEDURE  [dbo].[cir_suspend_type_bind]

  	@pcomp_code as varchar(200),
    @pdateformat as	varchar(200),
    @pextra1 as	varchar(200),
    @pextra2 as varchar(200)

 AS
   
    select * from cir_suspend_type_mast where comp_code=@pcomp_code and ISNULL(freeze_flag,'N')='N'
    
    
    
    
    
    
    /***************************************************************************************/
    
    set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER  PROCEDURE [dbo].[cir_user_bind_for_bl_unblk] (
   @pcomp_code          VARCHAR,
   @punit_code          VARCHAR,
   @pextra1             VARCHAR,
   @pextra2             VARCHAR,
   @pextra3             VARCHAR,
   @pextra4             VARCHAR,
   @pextra5             VARCHAR
)
AS
BEGIN
  SELECT "username" AS username, "userid" AS userid
    FROM login
   WHERE com_code = @pcomp_code
     AND "userid" IN (
            SELECT DISTINCT userid
                       FROM cir_suspend_tran
                      WHERE comp_code = @pcomp_code
                        AND ((unit = @punit_code) OR (@punit_code IS NULL) OR (@punit_code = '')));
END


/***********************mimoh 7dec 2011*********************************0005889****************/



/***********************ajay*************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[Cir_Dynamic_DML_variable_insert_stmt]
	@ptable_name                              VARCHAR(4000) ,
	@pcolname                                 VARCHAR(4000) ,
	@pcolvalue                                VARCHAR(4000) ,
	@pdelimiter                               VARCHAR(4000) ,
	@pdateformat                              VARCHAR(4000) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS
    	DECLARE @pstmt_str                                VARCHAR(4000) 
		DECLARE @v_sess_id                                FLOAT 
		DECLARE @rec_stmt								  VARCHAR(4000)		
		DECLARE @vlength                                  NUMERIC(5) 
		DECLARE @vcolval                                  VARCHAR(4000) 
		DECLARE @vrunval                                  VARCHAR(1) 
		DECLARE @vcol_name                                VARCHAR(4000) 
		DECLARE @vno                                      NUMERIC(5) 
		DECLARE @vrec                                     VARCHAR(4000) 
		DECLARE @vrec_upd                                 VARCHAR(4000) 
		DECLARE @vformat                                  VARCHAR(20) 
		DECLARE @v_col_exists                             NUMERIC(5) 
        DECLARE	 @COL_DATA_TYPE1						  VARCHAR(4000) 
        DECLARE	 @COL_VALUE1							  VARCHAR(4000) 
		declare @ss numeric(8)
		declare @vrec_val varchar(4000)
		declare @abj numeric(8)
		declare @col_val varchar(4000)
		declare @col_val1 varchar(4000)
	    declare @user_date varchar(4000)
		declare @item varchar(4000)
		declare @day varchar(4000)
		declare @month varchar(4000)
		declare @year varchar(4000)

		set @v_sess_id = (select @@spid)
		DELETE FROM   temp_col_ins   WHERE  session_id  = (select @@spid)
		SET @vlength  = null 
		SET @vcolval  = null 
		SET @vrunval  = null 
		SET @vcol_name  = null 
		SET @vno  = null 
		SET @vcolval  = REPLACE(@pcolname, @pdelimiter, ',')
		print(@vcolval)
		SET @vlength  = LEN(@vcolval)
		SET @vno  = 1 
		SET  @ss  = 1
		set @vrec_val =null

        DECLARE @i INT

		SET  @i  = 1 

		WHILE @i <= @vlength 
		  BEGIN			
			SET @vrunval  = SUBSTRING(@vcolval, @i, 1)
			IF @vrunval != ',' 
			  BEGIN 
				SET @vcol_name  =  RTRIM(LTRIM(COALESCE(@vcol_name,space(0)) +  COALESCE(@vrunval,space(0))))
			  END
			ELSE
			 BEGIN				

				INSERT INTO  temp_col_ins  ( sqno , col_name , session_id )  
				 VALUES ( @vno , LTRIM(RTRIM(@vcol_name)) , @v_sess_id )  				
				SET @vno  = @vno + 1 
				SET @vcol_name  = '' 
			END
			SET @i = @i + 1
		END 
		SELECT @v_col_exists  =  COUNT(*) FROM  temp_col_ins WHERE	 session_id  = @v_sess_id AND	col_name  = LTRIM(RTRIM(@vcol_name))
		IF ISNULL(@v_col_exists, 0)= 0 
		BEGIN 
			INSERT INTO  temp_col_ins   ( sqno , col_name , session_id )   VALUES ( @vno ,	rtrim(ltrim(@vcol_name)) , @v_sess_id )			
		END
		SET @vlength  = null 
		SET @vcolval  = null 
		SET @vrunval  = null 
		SET @vcol_name  = null 
		SET @vno  = null 
		IF CHARINDEX(',', @pcolvalue)> 0 or CHARINDEX('''', @pcolvalue)> 0 
    		BEGIN 
	    		SET @vcolval  = REPLACE(@pcolvalue, ',', '~~~')
		END
		ELSE
		 BEGIN 
			SET @vcolval  = @pcolvalue 
		END
   
		SET @vcolval  = REPLACE(@vcolval, @pdelimiter, ',')
		SET @vlength  = LEN(@vcolval)
		SET @vno  = 1 
        SET @i = 1 
		print (@vlength)
		WHILE @i <= @vlength 
		BEGIN
		SET @vrunval  = SUBSTRING(@vcolval, @i, 1)
			IF @vrunval != ',' 
			BEGIN 
				SELECT @vcol_name  = COALESCE(@vcol_name,space(0)) + COALESCE(@vrunval,space(0))
			END
			ELSE
			BEGIN 
				SELECT @vcol_name  = REPLACE(@vcol_name, '~~~', ',')
				UPDATE  temp_col_ins   
				SET	col_value = COALESCE(@vcol_name,space(0))
				WHERE  sqno  = @vno
				 AND	session_id  = @v_sess_id 
				
				SET @vno  = @vno + 1 
				SET @vcol_name  = '' 
print 'update'
			END

			SET @i = @i + 1
print (@i)
		END

		IF @vcol_name is not null 
		BEGIN 
			UPDATE  temp_col_ins   
			SET	col_value = COALESCE(@vcol_name,space(0))
			WHERE  sqno  = @vno
			 AND	session_id  = @v_sess_id 
		END
   
		UPDATE  temp_col_ins   
		SET	col_data_type = (SELECT DATA_TYPE
			FROM  INFORMATION_SCHEMA.COLUMNS
			WHERE	 TABLE_NAME  = LTRIM(RTRIM(@ptable_name))
			 AND	column_name  = LTRIM(RTRIM(temp_col_ins.col_name))
		) 
		WHERE  session_id  = @v_sess_id 

		SET @vrec  = 'insert into ' + @ptable_name + '(' + REPLACE(@pcolname, @pdelimiter, ',')+ ') values (' 
print('rinki')			
print(@vrec)	
		SET @vformat  = @pdateformat 

		DECLARE cur_stmt cursor  FOR 
		SELECT COL_DATA_TYPE,COL_VALUE  FROM  temp_col_ins WHERE	 session_id  = @v_sess_id ORDER BY sqno 


    OPEN cur_stmt 
		fetch NEXT FROM cur_stmt INTO @COL_DATA_TYPE1,@COL_VALUE1
         while(@@FETCH_STATUS = 0)
			BEGIN  
		print(@COL_DATA_TYPE1)
print(@COL_VALUE1)
				IF  ( @COL_DATA_TYPE1 = 'datetime') 
					BEGIN 
						declare @finaldate varchar(4000)
						declare @count_dat int
						set @count_dat=0
						print 'aa'
						print @COL_VALUE1
						if @COL_VALUE1!='' or @COL_VALUE1 !=null or @COL_VALUE1 !='null'
						begin
							print '1ankur_test'
print('datetime') print(@COL_VALUE1)print(@pdateformat)print (@finaldate)
							set @finaldate=dbo.convert_user_date('/',@COL_VALUE1,@pdateformat)
							print '21ankur_test'
							print @finaldate
print 'ankur_testrr'
end
						if @finaldate='/'
begin
					set @finaldate=''''
end
						set @finaldate=''''+replace(@finaldate,'''','')+''''
			SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + '' + COALESCE(@finaldate + '', SPACE(0))
			print @col_val
					END;
				else if(@COL_DATA_TYPE1 = 'numeric') OR (@COL_DATA_TYPE1 = 'decimal')
					begin						
							SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + '' + 'convert( float,' + COALESCE(@COL_VALUE1 + '', SPACE(0))+')'
					end
				ELSE
					BEGIN
						SET @vrec = @vrec
						SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + '' + COALESCE(@COL_VALUE1 + '', SPACE(0))
						END;
				fetch NEXT FROM cur_stmt INTO @COL_DATA_TYPE1,@COL_VALUE1
			END 
print'asdf'
			SET @col_val =COALESCE(substring(@col_val,1,len(@col_val)),SPACE(0))
			SET @vrec=  COALESCE(@vrec,SPACE(0)) + COALESCE(@col_val,SPACE(0)) + ')'
			SET @vlength  = null 
			SET @vcolval  = null 
			SET @vrunval  = null 
			SET @vcol_name  = null 
			SET @vno  = null 
		
		UPDATE   temp_col_ins   
		SET	upd_str = @vrec 
		WHERE  session_id  = @v_sess_id
             
        print(@vrec)
		EXEC (@vrec)
 DEALLOCATE cur_stmt 


/*******************5868********************/




//=================================ISSUE NO. 4488==============================================================




set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[cir_rep_unsold_supply_cir_monthly_net_paid_sale]
	@pcomp_code         as varchar(20),
	@punit_code         as varchar(20),
	@ppubl              as varchar(20),
	@pmainedtn          as varchar(20),
	@pedtn              as varchar(20),
	@pfromdate          as datetime,
	@ptilldate          as datetime,
	@pagency_type       as varchar(20),
	@pagency_class      as varchar(20),
	@pstatecode         as varchar(20),
	@pdistcode          as varchar(20),
	@ptaluka            as varchar(20),
	@pbranch            as varchar(20),
	@pagcd              as varchar(20),
	@pdpcd              as varchar(20),
	@preptype           as int,		   --1 for Agency Wise,2 for Main Edition wise,3 for District Taluka wise
	@pbreak_on          as varchar(20),--Region R/State S/District D/Branch B
	@preturn_based      as varchar(20),--it is use for return date or supply date(R/S)
	@plangtype          as varchar(20),
	@pdateformat        as varchar(20),
	@pextra1            as varchar(50),
	@pextra2            as varchar(50),
	@pextra3            as varchar(50),
	@pextra4            as varchar(50),
	@pextra5            as varchar(50)
AS 
		
	DECLARE @v_hdays	AS	NUMERIC(5) 
	DECLARE @v_avg_sale AS  NUMERIC(10) 
	DECLARE @v_reg_code AS  varchar(200)

	DECLARE @v1_comp_code	as varchar(50)
	DECLARE @v1_unit_code			as varchar(50)
    DECLARE @v1_branch_code			as varchar(50)
    DECLARE @v1_branch_name			as varchar(100)
    DECLARE @v1_publ				as varchar(50)
    DECLARE @v1_publ_name			as varchar(100)
    DECLARE @v1_main_edtn			as varchar(50)
    DECLARE @v1_main_edtn_name		as varchar(100)
    DECLARE @v1_edtn				as varchar(50)
    DECLARE @v1_edtn_name			as varchar(100)
    DECLARE @v1_copy_rate			as numeric(12,2)
    DECLARE @v1_agcd				as varchar(50)
    DECLARE @v1_dpcd				as varchar(50)
    DECLARE @v1_agname				as varchar(500)
    DECLARE @v1_agname_oth_lang		as varchar(500)
    DECLARE @v1_state_code			as varchar(50)
    DECLARE @v1_state_name			as varchar(500)
    DECLARE @v1_dist_code			as varchar(50)
    DECLARE @v1_dist_name			as varchar(100)
    DECLARE @v1_city_code			as varchar(50)
    DECLARE @v1_city_name			as varchar(150)
    DECLARE @v1_tehsil_taluka		as varchar(50)
    DECLARE @v1_taluka_name			as varchar(150)
    DECLARE @v1_supply_copy			as int
    DECLARE @v1_return_copy			as int
    DECLARE @v1_net_sale_copy		as int
    DECLARE @v1_no_of_days			as int

	
	DECLARE c1 cursor LOCAL FOR 
	select u.comp_code,u.unit_code,
    u.branch_code branch_code,(select distinct "Branch_Name" from branch_mst where "Branch_Code"=u.branch_code) branch_name,
    u.publ,u.publ_name,u.main_edtn,
    dbo.cir_get_edtn_name(u.comp_code,u.main_edtn) main_edtn_name,u.edtn edtn,u.edtn_name,u.copy_rate,
    u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,
    u.state_code,dbo.cir_get_state(u.comp_code,u.country_code,u.state_code) state_name,
    u.dist_code ,dbo.cir_get_name_cir_district(u.comp_code,u.dist_code,@plangtype,null,null,null) dist_name,
    u.city_code city_code,dbo.cir_get_name_cir_city(u.comp_code,u.city_code,@plangtype,null,null,null) city_name,
    u.tehsil_taluka,dbo.cir_get_name_cir_taluka(u.comp_code,u.tehsil_taluka,@plangtype,null,null,null) taluka_name,
    sum(supply_copy) supply_copy,sum(return_copy) return_copy,
    sum(supply_copy)-sum(return_copy) net_sale_copy,sum(no_of_days) no_of_days
    from (
    select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate copy_rate,
    b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
    a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka, 
    sum(isnull(b.sup_copy,0)) supply_copy,0 return_copy, count(distinct supdate) no_of_days
    from cir_agmast a,cir_dbksup b,cir_edtn_mast e,cir_publ_mast p
    where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and 
    b.comp_code =@pcomp_code and 
    b.unit_code=a.unit and b.unit_code=@punit_code and 
    b.publ=p.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and b.edtn=e.edtn and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn='') and
    a.agcd=b.agcd and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') and a.dpcd=b.dpcd and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='') and
    b.supdate >= @pfromdate and b.supdate <=@ptilldate and 
    (a.ag_type=@pagency_type or @pagency_type is null or @pagency_type='') and(a.ag_class=@pagency_class or @pagency_class is null or @pagency_class='') and
    (a.branch_code=@pbranch or @pbranch is null or @pbranch='') and (a.state_code=@pstatecode or @pstatecode is null or @pstatecode='') and
    (a.dist_code=@pdistcode or @pdistcode is null or @pdistcode='') and (a.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka='') and
    (e.main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')
    group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate,
    b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
    a.country_code,a.tehsil_taluka
    union all
    select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
    b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
    a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka, 
    0 supply_copy,sum(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0)) return_copy,0 no_of_days
    from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e,cir_publ_mast p
    where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and b.comp_code =@pcomp_code and 
    b.unit_code=a.unit and b.unit_code=@punit_code and 
    b.doctype='UCN' and b.recptdt >= @pfromdate and b.recptdt <=@ptilldate and 
    b.publ=e.publ and b.publ=p.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and b.edtn=e.edtn and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn='') and 
    a.agcd=b.agcd and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') and a.dpcd=b.dpcd and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='') and
    (a.ag_type=@pagency_type or @pagency_type is null or @pagency_type='') and(a.ag_class=@pagency_class or @pagency_class is null or @pagency_class='') and
    (a.branch_code=@pbranch or @pbranch is null or @pbranch='') and (a.state_code=@pstatecode or @pstatecode is null or @pstatecode='') and
    (a.dist_code=@pdistcode or @pdistcode is null or @pdistcode='') and (a.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka='') and
    (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and
    (e.main_edtn=@pmainedtn or @pmainedtn is null)
    group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
    b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
    a.country_code,a.tehsil_taluka) u
    where (u.supply_copy+u.return_copy)>0
    group by u.comp_code,u.unit_code,u.branch_code,u.publ,u.publ_name,u.main_edtn,u.edtn,u.edtn_name,u.copy_rate,
    u.agcd,u.dpcd,u.agname,u.agname_oth_lang,u.state_code,u.dist_code ,u.city_code,u.tehsil_taluka,u.country_code; 

		
	CREATE TABLE #CIR_TEMP_BILL_COLLECTION
	( COMP_CODE        VARCHAR(100),
	  UNIT_CODE        VARCHAR(100),
	  BILLNO           VARCHAR(200),
	  BILLDT           DATETIME,
	  PUBL_CODE        VARCHAR(100),
	  AGCD             VARCHAR(100),
	  DPCD             VARCHAR(100),
	  SUPPLY_COPY      NUMERIC(10)                   DEFAULT 0,
	  GROSS_AMT        NUMERIC(15,2)                 DEFAULT 0,
	  COMM_AMT         NUMERIC(15,2)                 DEFAULT 0,
	  SUR_AMT          NUMERIC(15,2)                 DEFAULT 0,
	  RETURN_COPY      NUMERIC(10)                   DEFAULT 0,
	  RETURN_AMT       NUMERIC(15,2)                 DEFAULT 0,
	  DN_AMT           NUMERIC(15,2)                 DEFAULT 0,
	  CN_AMT           NUMERIC(15,2)                 DEFAULT 0,
	  REC_AMT          NUMERIC(15,2)                 DEFAULT 0,
	  PREV_BAL         NUMERIC(15,2)                 DEFAULT 0,
	  CUR_SESSIONID    NUMERIC,
	  AGNAME           VARCHAR(200),
	  AGNAME_OTH_LANG  VARCHAR(250),
	  CITY_CODE        VARCHAR(200),
	  TALUKA_CODE      VARCHAR(200),
	  DIST_CODE        VARCHAR(200),
	  STATE_CODE       VARCHAR(200),
	  REMARKS          VARCHAR(500),
	  RET_COMM_AMT     NUMERIC(15,2),
	  BILL_SEC_AMT     NUMERIC(15,2),
	  SEC_OPBAL        NUMERIC(15,2))
		
		
		OPEN c1 
        fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code, @v1_branch_code, @v1_branch_name,@v1_publ, @v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,@v1_edtn,@v1_edtn_name,@v1_copy_rate, @v1_agcd, @v1_dpcd,@v1_agname,@v1_agname_oth_lang,@v1_state_code,@v1_state_name,@v1_dist_code,@v1_dist_name,@v1_city_code,@v1_city_name, @v1_tehsil_taluka,@v1_taluka_name,@v1_supply_copy,@v1_return_copy,@v1_net_sale_copy, @v1_no_of_days
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN 
   
			If isnull(@v1_no_of_days,0)>0 Begin
                set @v_avg_sale=round(isnull(@v1_net_sale_copy,0)/(isnull(@v1_no_of_days,0)),0)
            End    
            Else Begin
                set @v_avg_sale=isnull(@v1_net_sale_copy,0)
            End

            select distinct @v_reg_code=region_code from cir_city_mast where comp_code=@v1_comp_code and city_code=@v1_city_code
            
            set @v_reg_code=dbo.cir_get_region_name(@v1_comp_code,@v_reg_code)
            
            insert into #cir_temp_bill_collection
				(comp_code, unit_code, billno, publ_code, agcd, dpcd,agname,agname_oth_lang, city_code, 
				taluka_code, dist_code, state_code, remarks,supply_copy, return_copy ,comm_amt,gross_amt)
            values(@v1_comp_code,@v1_unit_code,@v1_branch_name,@v1_publ_name,@v1_main_edtn_name,@v1_edtn_name,@v1_agname,@v1_agname_oth_lang,@v1_city_name,
				@v1_taluka_name,@v1_dist_name,@v1_state_name,@v_reg_code,@v1_supply_copy,@v1_return_copy,@v1_copy_rate,@v1_no_of_days)
            
		    fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code, @v1_branch_code, @v1_branch_name,@v1_publ, @v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,@v1_edtn,@v1_edtn_name,@v1_copy_rate, @v1_agcd, @v1_dpcd,@v1_agname,@v1_agname_oth_lang,@v1_state_code,@v1_state_name,@v1_dist_code,@v1_dist_name,@v1_city_code,@v1_city_name, @v1_tehsil_taluka,@v1_taluka_name,@v1_supply_copy,@v1_return_copy,@v1_net_sale_copy, @v1_no_of_days
		
		END 
		close c1
		DEALLOCATE c1
		
        if @preptype=1 Begin
            if @pbreak_on='R' Begin
                select comp_code AS "COMP_CODE", unit_code AS "UNIT",agname AS "AGNAME",agname_oth_lang AS "AGNAME_OTH_LANG",city_code as "CITY_NAME", 
                remarks AS "REGION_NAME",comm_amt as "COPY_RATE",supply_copy AS "SUPPLY_COPY", return_copy AS "RETURN_COPY" ,(supply_copy-return_copy) AS "NET_SALE",
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as "NET_PER",
                gross_amt AS "NO_OF_DAYS",case when isnull(gross_amt,0)>0 then round((supply_copy-return_copy)/gross_amt,0) else 0 end AS "AVG_NET_SALE" 
                from #cir_temp_bill_collection order by remarks,agname,city_name,copy_rate

                select comp_code AS "COMP_CODE",  
                remarks AS "REGION_NAME",sum(supply_copy) AS "SUPPLY_COPY", sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as "NET_PER",
                0 AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from #cir_temp_bill_collection
                group by comp_code,remarks order by region_name
			End       
            else if @pbreak_on='S' Begin
                select comp_code AS "COMP_CODE", unit_code AS "UNIT",agname AS "AGNAME",agname_oth_lang AS "AGNAME_OTH_LANG",city_code as "CITY_NAME", 
                state_code AS "STATE_NAME",comm_amt as "COPY_RATE",supply_copy AS "SUPPLY_COPY", return_copy AS "RETURN_COPY" ,(supply_copy-return_copy) AS "NET_SALE",
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as "NET_PER",
                gross_amt AS "NO_OF_DAYS",case when isnull(gross_amt,0)>0 then round((supply_copy-return_copy)/gross_amt,0) else 0 end AS "AVG_NET_SALE" 
                from #cir_temp_bill_collection
                order by state_name,agname,city_name,comm_amt;

                select comp_code AS "COMP_CODE",  
                state_code AS "STATE_NAME",sum(supply_copy) AS "SUPPLY_COPY", sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as "NET_PER",
                0 AS "NO_OF_DAYS",0 AS "AVG_NET_SALE"
                from #cir_temp_bill_collection 
                group by comp_code,state_code order by state_name
            End    
            Else if @pbreak_on='D' Begin
                select comp_code AS "COMP_CODE", unit_code AS "UNIT",agname AS "AGNAME",agname_oth_lang AS "AGNAME_OTH_LANG",city_code as "CITY_NAME", 
                state_code AS "STATE_NAME",dist_code AS "DIST_NAME",comm_amt as "COPY_RATE",supply_copy AS "SUPPLY_COPY", return_copy AS "RETURN_COPY" ,(supply_copy-return_copy) AS "NET_SALE",
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as "NET_PER",
                gross_amt AS "NO_OF_DAYS",case when isnull(gross_amt,0)>0 then round((supply_copy-return_copy)/gross_amt,0) else 0 end AS "AVG_NET_SALE"
                from #cir_temp_bill_collection order by state_name,dist_name,agname,city_name,comm_amt;

                select comp_code AS "COMP_CODE",  
                state_code AS "STATE_NAME",dist_code AS "DIST_NAME",sum(supply_copy) AS "SUPPLY_COPY", sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as "NET_PER", 
                0 AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from #cir_temp_bill_collection 
                group by comp_code,state_code,dist_code order by state_name,dist_name;
            End    
            else if @pbreak_on='B' Begin

                select comp_code AS "COMP_CODE", unit_code AS "UNIT",agname AS "AGNAME",agname_oth_lang AS "AGNAME_OTH_LANG",city_code as "CITY_NAME", 
                billno AS "BRANCH_NAME",comm_amt as "COPY_RATE",supply_copy AS "SUPPLY_COPY", return_copy AS "RETURN_COPY" ,(supply_copy-return_copy) AS "NET_SALE",
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as "NET_PER",
                gross_amt AS "NO_OF_DAYS",case when isnull(gross_amt,0)>0 then round((supply_copy-return_copy)/gross_amt,0) else 0 end AS "AVG_NET_SALE"
                from #cir_temp_bill_collection order by branch_name,agname,city_name,comm_amt;

                select comp_code AS "COMP_CODE",  
                billno AS "BRANCH_NAME",sum(supply_copy) AS "SUPPLY_COPY", sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as "NET_PER",
                0 AS "NO_OF_DAYS", 0 AS "AVG_NET_SALE"
                from #cir_temp_bill_collection
                group by comp_code,billno order by branch_name;   
             End   
            End
        Else if @preptype=2 Begin--for edition wise

                select comp_code AS "COMP_CODE",  publ_code AS "PUBL_NAME",agcd AS "MAIN_EDTN_NAME",dpcd AS "EDTN_NAME",comm_amt as "COPY_RATE", sum(supply_copy) AS "SUPPLY_COPY", 
                sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as "NET_PER",
                max(gross_amt) AS "NO_OF_DAYS",case when isnull(max(gross_amt),0)>0 then round(sum(supply_copy-return_copy)/max(gross_amt),0) else 0 end AS "AVG_NET_SALE"
                from #cir_temp_bill_collection group by comp_code,publ_code,agcd,dpcd,comm_amt order by publ_name,main_edtn_name,edtn_name,copy_rate;

                select comp_code AS "COMP_CODE",  publ_code AS "PUBL_NAME",agcd AS "MAIN_EDTN_NAME",sum(supply_copy) AS "SUPPLY_COPY", 
                sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as "NET_PER",
                max(gross_amt) AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from #cir_temp_bill_collection group by comp_code,publ_code,agcd order by publ_name,main_edtn_name;
		End                
        Else Begin

                select comp_code AS "COMP_CODE", 
                state_code AS "STATE_NAME",dist_code AS "DIST_NAME",taluka_code AS "TALUKA_NAME",
                comm_amt as "COPY_RATE",sum(supply_copy) AS "SUPPLY_COPY", sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as "NET_PER",
                max(gross_amt) AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from #cir_temp_bill_collection 
                group by comp_code,state_code,dist_code,taluka_code,comm_amt order by state_name,dist_name,taluka_name,comm_amt;

                select comp_code AS "COMP_CODE", 
                state_code AS "STATE_NAME",dist_code AS "DIST_NAME",
                sum(supply_copy) AS "SUPPLY_COPY", sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as "NET_PER",
                max(gross_amt) AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from #cir_temp_bill_collection 
                group by comp_code,state_code,dist_code order by state_name,dist_name;
        End
        
        select getdate() as "CUR_DATE"
        select getdate() as "CUR_DATE"
   drop table #cir_temp_bill_collection

 

////////////////////////////////////////////////////////END////////////////////////////////////////////////////

/////////////////////////////////////////START ISSUE NO 5718///////////////////////////////////////


USE [abhi]
GO
/****** Object:  StoredProcedure [dbo].[cir_rep_agency_ledger_cir_agency_ledger_p]    Script Date: 12/05/2011 17:45:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[cir_rep_agency_ledger_cir_agency_ledger_p]
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @pactype         as varchar(20),
    @pbranchcode     as varchar(20),
    @pagency_type    as varchar(20),
    @pagcd           as varchar(20),
    @pdpcd           as varchar(20),
    @pstatecode      as varchar(20),
    @pdistcode       as varchar(20),
    @pcitycode       as varchar(20),
    @ptalukacode     as varchar(20),
    @pfrom_date      as datetime,
    @ptill_date      as datetime,
    @pbilladj_flag   as varchar(20),
    @psortedby       as varchar(20),
    @puserid         as varchar(20),
    @prowbreak       as varchar(20),
    @pdateformat     as varchar(20),
    @pextra1         as varchar(200),--it is use for agency class
    @pextra2         as varchar(200)
As
    declare @v_frdt          datetime;
    declare @v_todt          datetime;
    declare @v_opdate        datetime;
   
    declare @v_opbal         decimal(15,2)
    declare @v_opbal_sec     decimal(15,2)
    declare @v_amt           decimal(15,2)
    declare @v_clbal         decimal(15,2)
    declare @v_runbal        decimal(15,2)
    declare @v_billamt       decimal(15,2)
    declare @v_dbcramt       decimal(15,2)
    declare @v_cramt         decimal(15,2)
    declare @v_dbamt         decimal(15,2)
    declare @v_rec_seqno     int
    declare @v_remark_len    int
    declare @v_divident      int
    declare @v_narration     varchar(1000)
    declare @v_runbal_txt    varchar(20)
        declare c1 cursor for
            select distinct comp_code,unit,agcd,dpcd,ag_name,ag_name_oth_lang,city_code,tehsil_taluka,dist_code,state_code,
            country_code,branch_code from cir_agmast 
                where comp_code = @pcompcode and (unit=@punitcode or @punitcode is null) and 
                            (ag_type=@pagency_type or @pagency_type is null) and agcd+dpcd in(select distinct agcd+dpcd from cir_outmast 
                            where comp_code = @pcompcode and (unit_code=@punitcode or @punitcode is null) and achd=@pactype) and 
                            (agcd=@pagcd or @pagcd is null) and (dpcd=@pdpcd or @pdpcd is null) and (branch_code=@pbranchcode or @pbranchcode is null) and
                            (state_code=@pstatecode or @pstatecode is null) and (dist_code=@pdistcode or @pdistcode is null) and 
                            (tehsil_taluka=@ptalukacode or @ptalukacode is null) and (ag_class=@pextra1 or @pextra1 is null)
                            order by branch_code,city_code,ag_name;
	declare @v1_comp_code		varchar(20)
	declare @v1_unit			varchar(20)
	declare @v1_agcd			varchar(20) 
	declare @v1_dpcd			varchar(20) 
	declare @v1_ag_name			varchar(200) 
	declare @v1_ag_name_oth_lang varchar(200)
	declare @v1_city_code		varchar(20)
	declare @v1_tehsil_taluka	varchar(20)
	declare @v1_dist_code		varchar(20)
	declare @v1_state_code		varchar(20)
    declare @v1_country_code	varchar(20)	
	declare @v1_branch_code		varchar(20)
       


	declare @v2_comp_code		varchar(20)	
	declare @v2_unit_code		varchar(20)
	declare @v2_agcd			varchar(20)
	declare @v2_dpcd			varchar(20)
	declare @v2_doctype			varchar(20)	
	declare @v2_recptno			varchar(20)
	declare @v2_recptdt			datetime
	declare @v2_amount			decimal(15,2)
	declare @v2_chno			varchar(20)
	declare @v2_chdt			datetime
	declare @v2_chbank			varchar(200)
	declare @v2_reason			varchar(200)
	declare @v2_narration		varchar(2000)
	declare @v2_received_from	varchar(200)
        
    Begin
        set @v_opdate    =dbo.cir_get_finandt(@pcompcode,@pfrom_date,@pdateformat,null,null)--for financial date
        
        set @v_frdt      =@pfrom_date
        set @v_todt      =@ptill_date
        set @v_divident  =isnull(@prowbreak,35)

	CREATE TABLE #CIR_LEDGER_REPORT
	( COMP_CODE      VARCHAR(10),
	  UNIT_CODE      VARCHAR(10),
	  BRANCH_CODE    VARCHAR(10),
	  DOCTYPE        VARCHAR(10),
	  AGCD           VARCHAR(50),
	  DPCD           VARCHAR(50),
	  RECPTNO        VARCHAR(50),
	  RECPTDT        DATETIME,
	  AMOUNT         decimal(14,2),
	  CHQNO          VARCHAR(50),
	  CHQDT          DATETIME,
	  CHQ_BANK       VARCHAR(100),
	  EXEC_CODE      VARCHAR(20),
	  REMARKS        VARCHAR(500),
	  REASON         VARCHAR(30),
	  BILLNO         VARCHAR(50),
	  BILLDT         DATETIME,
	  BILLAMT        DECIMAL(14,2),
	  ADJAMT         DECIMAL(14,2),
	  LEFTAMT        DECIMAL(14,2),
	  DEBIT_HEAD     VARCHAR(200),
	  CREDIT_HEAD    VARCHAR(200),
	  REC_SEQNO      INT,
	  RECOVARY_DAYS  INT,
	  AGNAME         VARCHAR(500),
	  OPBAL_SEC      DECIMAL(14,2),
	  NARR_LINE      INT)

        open c1
            fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit,@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_name_oth_lang,@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,
                @v1_country_code,@v1_branch_code
            WHILE (@@FETCH_STATUS = 0)  
			begin
            set @v_opbal        =dbo.cir_accounts_cir_agency_opbal(@pcompcode, @punitcode,null,@v1_agcd, @v1_dpcd, @v_opdate, @pactype,@pdateformat,null,null)
            
	    ----for secutiry outstanding---
			if @pactype='NM' Begin
				set @v_opbal_sec	=dbo.cir_accounts_cir_agency_opbal(@pcompcode, @punitcode,null,@v1_agcd,@v1_dpcd,@v_opdate,'SC',@pdateformat,null,null)

				select @v_dbcramt	=sum(amount) from cir_rcphdr
				where comp_code = @pcompcode and unit_code= @punitcode and 
				agcd=@v1_agcd and dpcd=@v1_dpcd and recptdt>= @v_opdate and recptdt<=@v_todt and achd='SC'

				set @v_opbal_sec=isnull(@v_opbal_sec,0)+isnull(@v_dbcramt,0)
			End
			else
			Begin
				set @v_opbal_sec =0
			End

            ----for secutiry outstanding---
            set @v_dbcramt=0
            
	           select @v_billamt=sum(amount) from cir_outmast
                where comp_code = @pcompcode and unit_code=@punitcode and 
                            agcd=@v1_agcd and dpcd=@v1_dpcd and billdt >= @v_opdate and billdt<@v_frdt and 
                            achd=@pactype and recptno is null

	           select @v_dbcramt=sum(amount) from cir_rcpdet
                where comp_code=@pcompcode and unit_code=@punitcode and 
                            agcd=@v1_agcd and dpcd=@v1_dpcd and recptdt>= @v_opdate and recptdt<@v_frdt and 
                            achd=@pactype and billno is null
            
              set @v_opbal=isnull(@v_opbal,0)+isnull(@v_billamt,0)+isnull(@v_dbcramt,0)
            
               set @v_rec_seqno=isnull(@v_rec_seqno,0)+1

              insert into #cir_ledger_report
                  (comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
                  exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
                  billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line)
              values(@v1_comp_code,@v1_unit,@v1_branch_code,@v1_agcd,@v1_dpcd,null,null,@v_frdt,@v_opbal_sec,
                     null,'Security Balance',null,null,null,null,null,null,
                     null,null,null,null,null,@v1_ag_name,@v_rec_seqno,1)

	    set @v_rec_seqno = isnull(@v_rec_seqno,0)+1
            set @v_runbal = @v_opbal
            if @v_runbal>=0 Begin
                set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), @v_runbal ))+' Dr.'
		    End
            else
            Begin
		      set @v_runbal_txt=CONVERT(VARCHAR, CONVERT( numeric(14, 2), ABS(@v_runbal) ))+' Cr.'
	        End
            
            
              insert into #cir_ledger_report
                  (comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
                  exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
                  billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line)
              values(@v1_comp_code,@v1_unit,@v1_branch_code,@v1_agcd,@v1_dpcd,null,null,@v_frdt,@v_opbal,
                     null,'Opening Balance',null,null,null,null,null,null,
                     null,null,null,null,null,@v1_ag_name,@v_rec_seqno,2)
            
	declare c2 cursor for
        select u.comp_code comp_code,u.unit_code unit_code,u.agcd agcd,u.dpcd dpcd,u.doctype doctype,u.recptno recptno,u.recptdt recptdt,u.amount amount,u.chno chno,u.chdt chdt,u.chbank chbank,u.reason reason,
		u.narration narration,u.received_from received_from from 
        (select comp_code,unit_code,agcd,dpcd,doctype,recptno,recptdt,amount,chno,chdt,chbank,reason,remark narration,received_from from cir_rcphdr
            where comp_code=@v1_comp_code and unit_code=@v1_unit and agcd=@v1_agcd and dpcd=@v1_dpcd and recptdt 
                between @v_frdt and @v_todt and isnull(achd,'NM')=@pactype
        union
        select comp_code,unit_code,agcd,dpcd,'BIL' doctype,billno recptno,billdt recptdt,sum(bill_amount) amount,null chno,null chdt,null chbnk,'BILL' reason,
        'Bill Copy '+ cast(sum(bill_copy) as VARCHAR)+' Comm. Amount '+cast(sum(comm_amount) as VARCHAR) narration,null received_from from cir_bill
            where comp_code=@v1_comp_code and unit_code=@v1_unit and agcd=@v1_agcd and dpcd=@v1_dpcd and 
                billdt between @v_frdt and @v_todt and @pactype='NM'
                group by comp_code,unit_code,agcd,dpcd,billno,billdt)u
        order by recptdt,doctype,recptno        


    --------daily transactions------------
                open c2
				fetch NEXT FROM c2 INTO @v2_comp_code,@v2_unit_code,@v2_agcd,@v2_dpcd,@v2_doctype,@v2_recptno,@v2_recptdt,@v2_amount,@v2_chno,@v2_chdt,@v2_chbank,@v2_reason,
				@v2_narration,@v2_received_from
				WHILE (@@FETCH_STATUS = 0) 
				if isnull(@v2_amount,0)<>0 
				Begin
							set @v_rec_seqno=isnull(@v_rec_seqno,0)+1
							set @v_narration=null


							if @v2_doctype='BIL' Begin
										set @v_narration=@v2_narration
							End
							else
							Begin
										if @v2_narration is not null 
										Begin
										set @v_narration=@v2_narration
										
												if @v2_chno is not null 
												Begin
												set @v_narration=@v_narration+' CHNO# '+@v2_chno
												end
												if @v2_chdt is not null 
												Begin
												set @v_narration=@v_narration+' CHDT '+@v2_chdt
												end

												if @v2_chbank is not null Begin
												set @v_narration=@v_narration+' CHBNK '+@v2_chbank
												end
										End
									
											else
										    Begin
													if @v2_chno is not null Begin
													set @v_narration='CHNO# '+@v2_chno
													end

													if @v2_chdt is not null Begin
													set @v_narration =@v_narration+' CHDT '+ DBO.convert_user_date('/',@v2_chdt,@pdateformat)  
													end

													if @v2_chbank is not null Begin
													set @v_narration=@v_narration+' CHBANK '+@v2_chbank
													end
													if @v2_reason='CASH' and @v2_doctype='RCR' Begin
													set @v_narration='By Cash '+@v_narration
													end
											  end
						       end
								set @v_remark_len = LEN(ISNULL(LTRIM(RTRIM(@v_narration)), '-'))
								set @v_amt=isnull(@v_amt,0)+isnull(@v2_amount,0)
			                    


                  --------------------------

								set @v_runbal = @v_runbal+isnull(@v2_amount,0)

								if @v_runbal>=0 Begin
								set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), @v_runbal ))+' Dr.'
								End
								else
								Begin
								set @v_runbal_txt=CONVERT(VARCHAR, CONVERT( numeric(14, 2), abs(@v_runbal) ))+' Cr.'
								end
			                                        
								
                                if isnull(@v2_amount,0)>=0 Begin
									set @v_dbamt=isnull(@v_dbamt,0)+isnull(@v2_amount,0)
						        End
								else if isnull(@v2_amount,0)<0 Begin
									set @v_cramt=isnull(@v_cramt,0)+abs(isnull(@v2_amount,0))
								end
							  insert into #cir_ledger_report
								  (comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
								  exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
								  billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line)
							  values(@v1_comp_code, @v1_unit, @v1_branch_code, @v1_agcd, @v1_dpcd, @v2_doctype, @v2_recptno, @v2_recptdt, @v2_amount,
									 @v2_received_from,isnull(ltrim(rtrim(@v_narration)),'-'), @v2_chno, @v2_chdt, @v2_chbank, @v2_reason,null, @v_runbal_txt,
									 null, null, null, null, @v_runbal, @v1_ag_name, @v_rec_seqno, dbo.mod_function(@v_remark_len, @v_divident))
							---end
			fetch NEXT FROM c2 INTO @v2_comp_code,@v2_unit_code,@v2_agcd,@v2_dpcd,@v2_doctype,@v2_recptno,@v2_recptdt,@v2_amount,@v2_chno,@v2_chdt,@v2_chbank,@v2_reason,
			@v2_narration,@v2_received_from
			end

            close c2
			deallocate c2
            --------daily transactions------------
            
            set @v_clbal =isnull(@v_opbal,0)+isnull(@v_amt,0)

            set @v_rec_seqno=isnull(@v_rec_seqno,0)+1
			if @v_runbal>=0 Begin
			set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), @v_runbal ))+' Dr.'
			End
			else
			Begin
			set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), abs(@v_runbal) ))+' Cr.'
			End

			insert into #cir_ledger_report
			(comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
			exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
			billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line)
			values(@v1_comp_code, @v1_unit, @v1_branch_code, @v1_agcd, @v1_dpcd, null, null, @v_todt,isnull(@v_clbal,0),
			null,'Closing Balance',null,null,null,null,null,null,
			null,null,null,null,null, @v1_ag_name, @v_rec_seqno,1)

        if isnull(@v_opbal_sec,0)=0 and isnull(@v_opbal,0)=0 and @v_cramt=0 and @v_dbamt=0 Begin
           delete from #cir_ledger_report where comp_code = @v1_comp_code and unit_code = @v1_unit and
            agcd = @v1_agcd and dpcd = @v1_dpcd
        end

        set @v_billamt=0 set @v_dbcramt=0 set @v_opbal=0 set @v_clbal=0 set @v_amt=0 set @v_runbal=0 set @v_cramt=0 set @v_dbamt=0 set @v_runbal_txt=null
        
		fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit,@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_name_oth_lang,@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,
            @v1_country_code,@v1_branch_code     
        end

        close c1
 DEALLOCATE c1
  SELECT
			 (SELECT Comp_Name FROM  comp_mst 
			WHERE Comp_Code  = a.comp_code) 
	as "CNAME",
			 comp_code,
			 unit_code,
			 branch_code,
			 agcd,
			 dpcd,
			 agname,
			 doctype,
			 recptno,
			 recptdt,
			 
			CASE a.debit 
				WHEN 'D' THEN a.amount 
			END as debit,
			 
			CASE a.credit 
				WHEN 'C' THEN a.amount 
			END as credit,
			 exec_code,
			 remarks,
			 chqno,
			 chqdt,
			 chq_bank,
			 reason,
			 debit_head,
			 credit_head,
			 billno,
			 billdt,
			 billamt,
			 adjamt,
			 leftamt,
			 rec_seqno,
			 narr_line,
		    [dbo].[cir_get_agency_city](comp_code,unit_code,agcd,dpcd) AS CITY_NAME
	FROM (	SELECT
				 comp_code,
				 unit_code,
				 branch_code,
				 agcd,
				 dpcd,
				 agname,
				 doctype,
				 recptno,
				 recptdt,
				 
			CASE sign(amount) 
				WHEN 1 THEN 'D' 
			END as debit,
				 
			CASE sign(amount) 
				WHEN - 1 THEN 'C' 
			END as credit,
				 ABS(amount) as amount,
				 exec_code,
				 remarks,
				 chqno,
				 chqdt,
				 chq_bank,
				 reason,
				 debit_head,
				 credit_head,
				 billno,
				 billdt,
				 billamt,
				 adjamt,
				 leftamt,
				 rec_seqno,
				 ISNULL(narr_line, 1) as narr_line
		FROM  #cir_ledger_report 
		WHERE	 comp_code  = @pcompcode
		 AND	unit_code  = @punitcode
	) a 
	ORDER BY rec_seqno 
	

   SELECT 
			(SELECT Comp_Name FROM  comp_mst 
			WHERE Comp_Code  = a.comp_code) as "CNAME",
			 comp_code,
			 agcd,
			 dpcd,
			 agname,
			 (SELECT COUNT(*) FROM ( SELECT     comp_code,     unit_code,     branch_code,     agcd,     dpcd,     agname,     doctype,     recptno,     recptdt,        
CASE sign(amount)     WHEN 1 THEN 'D'    END as debit,        CASE sign(amount)     WHEN - 1 THEN 'C'    END as credit,     ABS(amount) as amount,     rec_seqno,     narr_line  
FROM  #cir_ledger_report   WHERE  comp_code  = @pcompcode   AND unit_code  = @punitcode ) adv_alias_1  
WHERE  adv_alias_1.comp_code  = a.comp_code  AND adv_alias_1.agcd  = a.agcd  AND adv_alias_1.dpcd  = a.dpcd  AND adv_alias_1.agname  = a.agname ) adv_count_value,
			 ISNULL(SUM(CONVERT(FLOAT, narr_line)), 0) sum_narr
	FROM (	SELECT
				 comp_code,
				 unit_code,
				 branch_code,
				 agcd,
				 dpcd,
				 agname,
				 doctype,
				 recptno,
				 recptdt,
				 
			CASE sign(amount) 
				WHEN 1 THEN 'D' 
			END as debit,
				 
			CASE sign(amount) 
				WHEN - 1 THEN 'C' 
			END as credit,
				 ABS(amount) as amount,
				 rec_seqno,
				 narr_line
		FROM  #cir_ledger_report 
		WHERE	 comp_code  = @pcompcode
		 AND	unit_code  = @punitcode
	) a group by a.comp_code,
			 a.agcd,
			 a.dpcd,
			 a.agname
	ORDER BY comp_code,
		 agcd,
		 dpcd,
		 agname 
	



	drop table #cir_ledger_report


END



/
/**********************************************/
/* Change By Sushil Kumar Tyagi */
/****** Object:  StoredProcedure [dbo].[cir_dynamic_update_stmt]    Script Date: 12/08/2011 09:57:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[cir_dynamic_update_stmt] 
   @ptable_name  varchar(2000),
   @pcolname  varchar(2000),
   @pcolvalue  varchar(2000),
   @pcond_colname  varchar(2000),
   @pdelimiter  varchar(2000),
   @pdateformat  varchar(2000),
   @pextra1  varchar(2000),
   @pextra2  varchar(2000)

as 
--	rec_stmt cur_stmt%rowtype;

--	rec_upd_stmt cur_upd_stmt%rowtype;

	DECLARE @vcol_name                            VARCHAR(100) 
	DECLARE @v_sess_id                            FLOAT 
	declare @pstmt_str							  varchar(4000);
	declare @vlength 							  int;
	declare @vcolval 							  varchar(4000);
	declare @vrunval 							  varchar(1);	
	declare @vno 								  int;
	declare @vrec 							      varchar(4000);
	declare @vrec_upd 							  varchar(4000);
	declare @vpextra1 							  varchar(4000);
	declare @vformat 							  varchar(20);
	DECLARE	 @COL_DATA_TYPE1					  VARCHAR(200);
    DECLARE	 @COL_VALUE1						  VARCHAR(2000);
	DECLARE	 @COL_NAME							  VARCHAR(2000);
	declare @col_val							  varchar(4000);
	declare @upd_col_val						  varchar(4000);
	DECLARE	 @UPD_COL_NAME						  VARCHAR(2000);
	DECLARE	 @UPD_COL_DATA_TYPE1				  VARCHAR(200);
    DECLARE	 @UPD_COL_VALUE1					  VARCHAR(2000);
	DECLARE @i									  INT

		SET  @i  = 1 
Begin
set @v_sess_id = (select @@spid)
SET @vcol_name  = null 
delete from test1
	insert into test1(vstring) values (@vrec+@vrec_upd+@ptable_name+','+@pcolname+','+
                                       @pcolvalue+','+@pcond_colname+','+@pdelimiter+','+
                                       @pdateformat+','+@pextra1+','+@pextra2);
	Begin
		delete from temp_col_ins where session_id=@@spid;

	set	@vlength=null;	set @vcolval=null; set	@vrunval=null;	set @vcol_name=null;	set @vno=null;

		set @vcolval=replace(@pcolname,@pdelimiter,',');	set @vlength=len(@vcolval);	set @vno=1;
		WHILE @i <= @vlength 
		  BEGIN			
			SET @vrunval  = SUBSTRING(@vcolval, @i, 1)
			IF @vrunval != ',' 
			  BEGIN 
				SET @vcol_name  =  RTRIM(LTRIM(COALESCE(@vcol_name,space(0)) +  COALESCE(@vrunval,space(0))))
			  END
			ELSE
			 BEGIN
				INSERT INTO  temp_col_ins  ( sqno , col_name , session_id )  
				 VALUES ( @vno , LTRIM(RTRIM(@vcol_name)) , @v_sess_id )  				
				SET @vno  = @vno + 1 
				SET @vcol_name  = '' 
			END
			SET @i = @i + 1
		END

		set @vlength=null;	set @vcolval=null;	set @vrunval=null;	set @vcol_name=null;	set @vno=null;
		
		set @vcolval=replace(@pcolvalue,',','~~~');

		set @vcolval=replace(@vcolval,@pdelimiter,',');	
		set @vlength=len(@vcolval);	
		set @vno =1;
		set @i=1;
		

set @i=1
		while @i<=@vlength
		  begin

			set @vrunval=substring(@vcolval,@i,1);
			 if @vrunval!=','

				begin

					set @vcol_name= COALESCE(@vcol_name + '', SPACE(0))+COALESCE(@vrunval + '', SPACE(0));
				end
			 else
				begin
					set @vcol_name=replace(@vcol_name,'~~~',',');

				   update temp_col_ins set col_value=@vcol_name where sqno=@vno and session_id=@@spid;
		  		   set @vno=@vno+1;
				   set @vcol_name='';
				end
			SET @i = @i + 1
		  end
		
		
/*Start New Change For Old and New Concept */
		if @pextra1='' or @pextra1 is null
			begin			 
              
         --   print('1')
			set @vpextra1=@pcolvalue;
			end
		else
			begin
           --   print('2')
           ---     print(@pextra1)
              --    print('2243')
			 set @vpextra1=@pextra1;
			end
		
		set @vlength=null;	
        set @vcolval=null;	
        set @vrunval=null;	
        set @vcol_name=null;	
        set @vno=null;

		print(@vpextra1)
		set @vcolval=replace(@vpextra1,',','~~~');
		
	print(@pdelimiter)
		set @vcolval=replace(@vcolval,@pdelimiter,',');	
	print(@vcolval)
		set @vlength=len(@vcolval);	
		set @vno=1;
set @i=1;
		while @i <=@vlength
			begin
              set @vrunval = substring(@vcolval,@i,1);
            
			if @vrunval!=','
				begin

                 
  
					set @vcol_name=COALESCE(@vcol_name + '', SPACE(0))+COALESCE(@vrunval + '', SPACE(0));
                     
                 
				end
		  		 
				else	
				 begin

                  
					set @vcol_name=replace(@vcol_name,'~~~',',');
              
					update temp_col_ins set col_value_old=@vcol_name where sqno=@vno and session_id=@@spid;
		  			set @vno=@vno+1;
					set @vcol_name='';
				 end
SET @i = @i + 1
			end
		
		/*End New Change For Old and New Concept */
		update temp_col_ins set col_data_type=(select DATA_TYPE from INFORMATION_SCHEMA.COLUMNS
		 where TABLE_NAME = upper(ltrim(rtrim(@ptable_name))) and column_name = upper(ltrim(rtrim(temp_col_ins.col_name))))
			where session_id=@@spid;
declare  cur_stmt cursor for  select COL_NAME,COL_VALUE,COL_DATA_TYPE from temp_col_ins  where session_id=@@spid order by sqno;
		
		set @vrec='update '+@ptable_name+' set ';
		--select "date_format" into vformat from preferrences;
          set @vformat=@pdateformat;
		OPEN cur_stmt 
		fetch NEXT FROM cur_stmt INTO @COL_NAME,@COL_VALUE1,@COL_DATA_TYPE1
         while(@@FETCH_STATUS = 0)
			BEGIN  
				
				IF  ( @COL_DATA_TYPE1 = 'datetime') 
					BEGIN 
						declare @finaldate varchar(4000)
						declare @count_dat int
						set @count_dat=0
				
						if @COL_VALUE1!=''
						begin
							set @finaldate=(select dbo.convert_user_date('/',@COL_VALUE1,@pdateformat))
				
						 end
						if @finaldate='/'
						 begin
					      set @finaldate=''''
						end
						set @finaldate=''''+replace(@finaldate,'''','')+''''
						
					SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + ''+ @COL_NAME+'='+ COALESCE(@finaldate + '', SPACE(0))
					
print('asada')
print(@finaldate)
					END;
				else if(@COL_DATA_TYPE1 = 'numeric')
					begin	
                            declare @len112 int
                            set @len112 = len(@COL_VALUE1)	
                            if(@len112 > 9)

                            begin 
                             
                                 SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + ''+ @COL_NAME+'=' + 'cast( ' + COALESCE(@COL_VALUE1 + '', SPACE(0))+' as varchar )'
                            end

                            else

                            begin		
                                
							    SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + ''+ @COL_NAME+'=' + 'convert( float,' + COALESCE(@COL_VALUE1 + '', SPACE(0))+')'
                            end
							
					end
				ELSE
					BEGIN						
						SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + '' + @COL_NAME+'='+ COALESCE(@COL_VALUE1 + '', SPACE(0))
						

						END;   
				fetch NEXT FROM cur_stmt INTO @COL_NAME,@COL_VALUE1,@COL_DATA_TYPE1
			END 
		  --set @vrec=substring(@vrec,1,len(@vrec)-1);
		  set @vlength=null;	set @vcolval=null;	set @vrunval=null;	set @vcol_name=null;	set @vno=null;

		set @vcolval=replace(@pcond_colname,@pdelimiter,',');	
		
set @vlength=len(@vcolval);
	set @i=1
		while @i<= @vlength
			begin
		set @vrunval=substring(@vcolval,@i,1);
				if @vrunval!=','
					begin		
						set @vcol_name=COALESCE(@vcol_name + '', SPACE(0))+COALESCE(@vrunval + '', SPACE(0));						
					end
				else
					begin
						
						update temp_col_ins set upd_flag='U' where col_name=@vcol_name and session_id=@@spid;
						set @vcol_name='';
					end
				SET @i = @i + 1
			end
		
	  close cur_stmt;

		if @pcond_colname is not null

			begin
		 		set @vrec_upd=' where ';
			end
		else
			begin
		 	set @vrec_upd='';
		end
	declare cur_upd_stmt cursor for   select COL_NAME,COL_VALUE_OLD,COL_DATA_TYPE from temp_col_ins  where isnull(upd_flag,'N')='U' and session_id=@@spid;
		open cur_upd_stmt	
		  fetch Next from cur_upd_stmt into @UPD_COL_NAME,@UPD_COL_VALUE1,@UPD_COL_DATA_TYPE1
		while(@@FETCH_STATUS = 0)
			BEGIN  
				IF(@UPD_COL_DATA_TYPE1 = 'datetime') 
					BEGIN						
						set @count_dat=0		
						
						if @UPD_COL_VALUE1!=''
						begin
							set @finaldate=(select dbo.convert_user_date('/',@UPD_COL_VALUE1,@pdateformat))
						 end
						if @finaldate='/'
						 begin
					      set @finaldate=''''
						end
						set @finaldate=''''+replace(@finaldate,'''','')+''''
						SET @upd_col_val = COALESCE(@upd_col_val + ' ', SPACE(0)) + ' ' + @UPD_COL_NAME+'='+ COALESCE(@finaldate + ' ', SPACE(0)) +' and'
						
					END;
				else if(@UPD_COL_DATA_TYPE1 = 'numeric')
					begin
                           
							SET @upd_col_val = COALESCE(@upd_col_val + ' ', SPACE(0)) + ' '+ @UPD_COL_NAME+'=' + 'convert( int,' + COALESCE(@UPD_COL_VALUE1 +  '', SPACE(0))+')'+' and'
							
					end
				ELSE
					BEGIN
						
						SET @upd_col_val = COALESCE(@upd_col_val + ' ', SPACE(0)) + ' ' + @UPD_COL_NAME+'='+ COALESCE(@UPD_COL_VALUE1 + ' ', SPACE(0))+ ' and'
						
						END;   
				fetch NEXT FROM cur_upd_stmt INTO @UPD_COL_NAME,@UPD_COL_VALUE1,@UPD_COL_DATA_TYPE1
			END 
		 close cur_upd_stmt;
		 set @upd_col_val=substring(@upd_col_val,1,len(@upd_col_val)-4);
		set @upd_col_val=COALESCE(@vrec_upd + '', SPACE(0))+ COALESCE(@upd_col_val + '', SPACE(0))
    declare @query1 varchar(2000)
set @query1 =COALESCE(@vrec + '', SPACE(0))+COALESCE(@col_val+ '', SPACE(0))+COALESCE(@upd_col_val+ '', SPACE(0));

	 update temp_col_ins set upd_str=COALESCE(@vrec + '', SPACE(0))+COALESCE(@col_val+ '', SPACE(0))+COALESCE(@upd_col_val+ '', SPACE(0)) where session_id=@@spid --and rownum<2;
		 
	End;
	 insert into test1(vstring) values (COALESCE(@vrec + '', SPACE(0))+COALESCE(@col_val+ '', SPACE(0))+COALESCE(@upd_col_val+ '', SPACE(0)));     
	   
print (@query1)
exec (@query1)
DEALLOCATE cur_stmt
DEALLOCATE cur_UPD_stmt
End 
/**********************************************/
/* Change By Sushil Kumar Tyagi */


/////////////////////////////////////////END/////////////////////////////////////////////////





/**************************************** For Login 8 dec 2011 **************************/
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go









ALTER  PROCEDURE [dbo].[websp_loginemployee]
@username varchar(50),
@password varchar(10),
@qbc varchar(8)=null

AS
declare @query as varchar(900)
declare @count as varchar(100)
declare @query1 as varchar(900)
declare @query2 as varchar(1000)
declare @userid varchar(100)

if(@qbc=null or @qbc='')
begin
set @query='select username,password,userid,date_format,com_code,autogenerate,curr_code  ,comp_name, datediff(dd,creation_datetime,getdate()) as diff,DISCOUNT,FILTER,ROLEID,retainer_code AS RETAINER          from login where userid='''+@username+''' and password='''+@password+''' and STATUS ! = ''I'''

select @count=com_code from login where userid=@username and password=@password
/*new change ankur for agency*/
set @query1='SELECT rate_gr_code,autogenerated,currency_code,date_format,solo,No_of_Decimal,
        breakup,blackwhitecode,uom_code,rostatus,Tfn,Insert_breakup,Premium_type,Deal_type     ,
        prefix,suffix,financestatus,voucherst,Ad_category,Ro_datetime,Space_area,Vat,Booking_status,Cio_id,Receipt_no,Bgcolor_publication, chkfor_valid_pubdates,Agency_ratecode,audit,copy_booking,RATE_COMPANY_AGENCY,SUBEDITIONRATE,ADDITIONAL_AGENCY_COMM,AGENCY_RETAINER_COMM,

        invoice_no,rate_audit,CLS_BILLTYPE,DIS_BILLTYPE,BILLING_FORMAT, RATE_CHECK, ALL_PACKAGE,DAYRATE,SCHEME_TYPE,DISP_CLSBILL,RECEIPT_FORMAT,CASH_RECEIPT_BILL, BILL_ORDERWSLAST, FLOOR_CHK,ROKEYCHECK,
		DISP_CASHBILL, CLA_CASHBILL,RATE_AUDIT_PREF,FA_LEDGER_ALLOW,CLEARANCE_TYPE_ALLOW,DISP_AUDITBKG,CIR_AUTO_PHYSICAL_UNSOLD

  from preferrences where comp_code= '''+@count+'''' 
select @userid=userid from login where username=@username and  password=@password  and com_code=@count

set @query2='select company_user,Admin from login where userid='''+@username+''''

end
else
begin
set @query='select username,password,userid,date_format,com_code,autogenerate,curr_code  ,comp_name  , datediff(dd,creation_datetime,getdate()) as diff,DISCOUNT,FILTER ,ROLEID ,retainer_code   AS RETAINER     from login where userid='''+@username+''' and password='''+@password+''' and retainer_code='''+@qbc+''' and STATUS ! = ''I'''

select @count=com_code from login where userid=@username and password=@password and retainer_code=@qbc

/*new change ankur for agency*/
set @query1='SELECT rate_gr_code,autogenerated,currency_code,date_format,solo,No_of_Decimal,
        breakup,blackwhitecode,uom_code,rostatus,Tfn,Insert_breakup,Premium_type,Deal_type     ,
        prefix,suffix,financestatus,voucherst,Ad_category,Ro_datetime,Space_area,Vat,Booking_status,Cio_id,Receipt_no,Bgcolor_publication, chkfor_valid_pubdates,Agency_ratecode,audit,copy_booking,RATE_COMPANY_AGENCY,SUBEDITIONRATE,ADDITIONAL_AGENCY_COMM,AGENCY_RETAINER_COMM,

        invoice_no,rate_audit,CLS_BILLTYPE,DIS_BILLTYPE,BILLING_FORMAT, RATE_CHECK, ALL_PACKAGE,DAYRATE,SCHEME_TYPE,DISP_CLSBILL,RECEIPT_FORMAT,CASH_RECEIPT_BILL, BILL_ORDERWSLAST, FLOOR_CHK,ROKEYCHECK,
		DISP_CASHBILL, CLA_CASHBILL,RATE_AUDIT_PREF,FA_LEDGER_ALLOW,CLEARANCE_TYPE_ALLOW,DISP_AUDITBKG,CIR_AUTO_PHYSICAL_UNSOLD from preferrences where comp_code= '''+@count+''''

select @userid=userid from login where username=@username and  password=@password  and com_code=@count

set @query2='select company_user,Admin from login where userid='''+@username+''''
end


print(@query)
exec(@query)

print(@query1)
exec(@query1)


print(@query2)
exec(@query2)











/*****************************************END ***************************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[cir_rep_supply_detail_p]
    @pcomp_code      as varchar(200),
    @punit_code      as varchar(200),
    @ppubl           as varchar(200),
    @pdateformat     as varchar(200),
    @puserid         as varchar(200),
    @pextra1         as varchar(200),
    @pextra2         as varchar(200),
    @pextra3         as varchar(200),
    @pextra4         as varchar(200),
    @pextra5         as varchar(200),
    @pextra6         as varchar(200),
    @pextra7         as varchar(200),
    @pextra8         as varchar(200),
    @pextra9         as varchar(200),
    @pextra10        as varchar(200)
As
Begin
    
select m.comp_code as "COMP_CODE", m.unit as "UNIT", m.agcd as "AGCD", m.dpcd as "DPCD",m.ag_name as "AG_NAME",
    m.station_code as "DROP_POINT",dbo.cir_get_drop_point_name(m.comp_code,m.unit,m.station_code,1) as "DROP_POINT_NAME", 
    m.city_code as "CITY_CODE", dbo.cir_get_city(m.comp_code,m.city_code) as "CITY_NAME", s.publ as "PUBL",p.publ_name as "PUBL_NAME", 
    e.main_edtn as "MAIN_EDTN",dbo.cir_get_edtn_name(m.comp_code,e.main_edtn) as "MAIN_EDTN_NAME", 
    s.edtn as "EDTN",e.edtn_name as "EDTN_NAME", 
    s.supply_flag as "SUPPLY_FLAG", s.supply_type_code as "SUPPLY_TYPE_CODE",t.sup_ty_name as "SUP_TY_NAME", 
    s.base_supply as "BASE_SUPPLY", s.supply_sun as "SUPPLY_SUN", s.supply_mon as "SUPPLY_MON", s.supply_tue as "SUPPLY_TUE", s.supply_wed as "SUPPLY_WED",
    s.supply_thu as "SUPPLY_THU", s.supply_fri as "SUPPLY_FRI", s.supply_sat as "SUPPLY_SAT", s.supply_spl1 as "SUPPLY_SPL1", s.supply_spl2 as "SUPPLY_SPL2",
    m.SUSPEND_DATE as"SUSPEND_DATE"  
    from cir_supply s,cir_agmast m,cir_publ_mast p,cir_edtn_mast e,cir_supply_type_mast t
    where m.comp_code=s.comp_code and m.comp_code=p.comp_code and m.comp_code=e.comp_code and m.comp_code=t.comp_code and m.comp_code=isnull(@pcomp_code,m.comp_code) 
and    m.unit=s.unit 
and m.unit=isnull(@punit_code,m.unit) 
and m.agcd=s.agcd and  m.dpcd=s.dpcd and s.publ=p.publ 
and s.publ=isnull(@ppubl,s.publ) 
and 
   s.edtn=e.edtn 
and s.supply_type_code=t.sup_ty_code 
and isnull(m.freeze_flag,'N') ='N' and isnull(m.suspend,'N')='Y'
    order by comp_code,unit,city_name,drop_point_name,ag_name,publ_name,main_edtn_name,edtn_name,sup_ty_name;    
End


//////////////////////
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[cir_supply_alteration_p]
      @pcomp_code        as varchar(20),
      @punit_code        as varchar(20),
      @ppubl_code        as varchar(20),
      @pmedtn_code       as varchar(20),
      @pedtn_code        as varchar(20),
      @psup_type         as varchar(20),
      @pstate            as varchar(20),
      @pdistcode         as varchar(20),
      @ptaluka           as varchar(20),
      @pcitycode         as varchar(20),
      @pbrancode         as varchar(20),
      @proutecode        as varchar(20),
      @pagcd_code        as varchar(20),
      @pdpcd_code        as varchar(20),
      @psorted_by        as varchar(20),---1 for  edition route wise,2 for edition district wise
      @pdateformat       as varchar(20),
      @puserid			 as varchar(20),
      @pextra1           as varchar(200),--agency type
      @pextra2           as varchar(200),--for agency--A and distribution--D
      @pextra3           as varchar(200),--agency class
      @pextra4           as varchar(200),
      @pextra5           as varchar(200),
      @pextra6           as varchar(200),--for suspend Y/N
      @pextra7           as varchar(200),--for commition category
      @pextra8           as varchar(200),
      @pextra9           as varchar(200),
      @pextra10          as varchar(200)
 As
	
 Begin
  if upper(@pextra2)='D' Begin
      if @psorted_by='2' Begin---for edition district and agency wise
            SELECT A.COMP_CODE COMP_CODE,A.UNIT UNIT,A.AGCD AGCD,A.DPCD DPCD,A.AG_NAME AGENCY_NAME,A.AG_NAME_OTH_LANG AGENCY_NAME_OTHER_LANG,A.CITY_CODE CITY_CODE,
            DBO.CIR_GET_CITY(A.COMP_CODE,A.CITY_CODE) CITY_NAME,A.STATION_CODE DROP_POINT_CODE,DBO.CIR_GET_DROP_POINT_NAME(A.COMP_CODE,A.UNIT,A.STATION_CODE,'1') DROP_POINT_NAME,
            ISNULL(C.BASE_SUPPLY,0) BASE_SUPPLY,ISNULL(C.SUPPLY_SUN,0) SUPPLY_SUN,ISNULL(C.SUPPLY_MON,0) SUPPLY_MON,ISNULL(C.SUPPLY_TUE,0) SUPPLY_TUE,ISNULL(C.SUPPLY_WED,0) SUPPLY_WED,
            ISNULL(C.SUPPLY_THU,0) SUPPLY_THU,ISNULL(C.SUPPLY_FRI,0) SUPPLY_FRI,ISNULL(C.SUPPLY_SAT,0) SUPPLY_SAT,ISNULL(C.SUPPLY_SPL1,0) SUPPLY_SPL1,ISNULL(C.SUPPLY_SPL2,0) SUPPLY_SPL2,
            C.LBL_PRINTNO SUPPLY_SEQ,DBO.CIR_GET_ROUTE_SEQNO(C.COMP_CODE,C.UNIT,C.ROUTE_CODE) ROUTE_SEQ,
            C.ROUTE_CODE,DBO.CIR_GET_NAME_CIR_ROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,1,@PDATEFORMAT,'','') ROUTE_NAME, 
            C.SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,C.SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBROUTE_NAME,
            C.SUB_SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBSUBROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,C.SUBROUTE_CODE,C.SUB_SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBSUBROUTE_NAME,
            D.DIST_NAME DIST_NAME,ISNULL(P.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,C.SUPPLY_TYPE_CODE SUPPLY_TYPE_CODE,B.SUP_TY_NAME SUPPLY_TYPE_NAME,
			C.EDTN EDTN,E.EDTN_NAME EDTN_NAME,B.SUP_SEQ_NO SUP_SEQ_NO,
			A.SUSPEND SUSPEND,C.PUBL PUBL,DB0.CIR_GET_PUBL_NAME(A.COMP_CODE,C.PUBL) PUBL_NAME
            from cir_agmast_dis a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code= @pcomp_code and p.comp_code= @pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit= @punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ 
and (c.publ= @ppubl_code or @ppubl_code is null)
 and c.edtn=e.edtn and (c.edtn = isnull(@pedtn_code,c.edtn) or @pedtn_code='') and (e.main_edtn = isnull(@pmedtn_code,e.main_edtn) or @pmedtn_code='') and 
            a.agcd=c.agcd and (a.bill_agcd=isnull(@pagcd_code,a.bill_agcd) or @pagcd_code='') and a.dpcd=c.dpcd and (a.bill_dpcd=isnull(@pdpcd_code,a.bill_dpcd) or @pdpcd_code='') and (c.supply_type_code= @psup_type or @psup_type is null or @psup_type='') and 
			(a.state_code=@pstate or @pstate is null or @pstate='') and
            (a.dist_code=@pdistcode or @pdistcode is null  or @pdistcode='') and (a.tehsil_taluka = @ptaluka or @ptaluka is null or @ptaluka='') and
            (a.city_code=@pcitycode or @pcitycode is null) and (a.branch_code = @pbrancode or @pbrancode is null or @pbrancode='') and
            (c.route_code=@proutecode or @proutecode is null) and isnull(c.supply_flag,'N') ='Y' and 
            ((isnull(a.suspend,'N')=isnull(@pextra6,'N')) or (@pextra6 is null) or (@pextra6='')) and
            a.freeze_flag='N' and
            ((c.comm_code = @pextra7) or (@pextra7 is null) or (@pextra7 = '')) and 
            (a.ag_type=@pextra1 or @pextra1 is null or @pextra1='') and 
			(a.ag_class=@pextra3 or @pextra3 is null or @pextra3='')
            order by dist_name,agency_name,edtn_name,sup_seq_no,supply_type_name,supply_seq
		End
      else Begin
          SELECT A.COMP_CODE COMP_CODE,A.UNIT UNIT,A.AGCD AGCD,A.DPCD DPCD,A.AG_NAME AGENCY_NAME,A.AG_NAME_OTH_LANG AGENCY_NAME_OTHER_LANG,A.CITY_CODE CITY_CODE,
            DBO.CIR_GET_CITY(A.COMP_CODE,A.CITY_CODE) CITY_NAME,A.STATION_CODE DROP_POINT_CODE,DBO.CIR_GET_DROP_POINT_NAME(A.COMP_CODE,A.UNIT,A.STATION_CODE,'1') DROP_POINT_NAME,
            ISNULL(C.BASE_SUPPLY,0) BASE_SUPPLY,ISNULL(C.SUPPLY_SUN,0) SUPPLY_SUN,ISNULL(C.SUPPLY_MON,0) SUPPLY_MON,ISNULL(C.SUPPLY_TUE,0) SUPPLY_TUE,ISNULL(C.SUPPLY_WED,0) SUPPLY_WED,
            ISNULL(C.SUPPLY_THU,0) SUPPLY_THU,ISNULL(C.SUPPLY_FRI,0) SUPPLY_FRI,ISNULL(C.SUPPLY_SAT,0) SUPPLY_SAT,ISNULL(C.SUPPLY_SPL1,0) SUPPLY_SPL1,ISNULL(C.SUPPLY_SPL2,0) SUPPLY_SPL2,
            C.LBL_PRINTNO SUPPLY_SEQ,DBO.CIR_GET_ROUTE_SEQNO(C.COMP_CODE,C.UNIT,C.ROUTE_CODE) ROUTE_SEQ,
            C.ROUTE_CODE,DBO.CIR_GET_NAME_CIR_ROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,1,@PDATEFORMAT,'','') ROUTE_NAME, 
            C.SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,C.SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBROUTE_NAME,
            C.SUB_SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBSUBROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,C.SUBROUTE_CODE,C.SUB_SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBSUBROUTE_NAME,
            D.DIST_NAME DIST_NAME,ISNULL(P.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,C.SUPPLY_TYPE_CODE SUPPLY_TYPE_CODE,B.SUP_TY_NAME SUPPLY_TYPE_NAME,
			C.EDTN EDTN,E.EDTN_NAME EDTN_NAME,B.SUP_SEQ_NO SUP_SEQ_NO,
			A.SUSPEND SUSPEND,C.PUBL PUBL,DB0.CIR_GET_PUBL_NAME(A.COMP_CODE,C.PUBL) PUBL_NAME
            from cir_agmast_dis a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code= @pcomp_code and p.comp_code= @pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit= @punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ 
and (c.publ= @ppubl_code  or @ppubl_code is null)
and c.edtn=e.edtn and (c.edtn = isnull(@pedtn_code,c.edtn) or @pedtn_code='') and (e.main_edtn = isnull(@pmedtn_code,e.main_edtn) or @pmedtn_code='') and 
            a.agcd=c.agcd and (a.bill_agcd=isnull(@pagcd_code,a.bill_agcd) or @pagcd_code='') and a.dpcd=c.dpcd and (a.bill_dpcd=isnull(@pdpcd_code,a.bill_dpcd) or @pdpcd_code='') and (c.supply_type_code= @psup_type or @psup_type is null or @psup_type='') and 
			(a.state_code=@pstate or @pstate is null or @pstate='') and
            (a.dist_code=@pdistcode or @pdistcode is null  or @pdistcode='') and (a.tehsil_taluka = @ptaluka or @ptaluka is null or @ptaluka='') and
            (a.city_code=@pcitycode or @pcitycode is null) and (a.branch_code = @pbrancode or @pbrancode is null or @pbrancode='') and
            (c.route_code=@proutecode or @proutecode is null) and isnull(c.supply_flag,'N') ='Y' and 
            ((isnull(a.suspend,'N')=isnull(@pextra6,'N')) or (@pextra6 is null) or (@pextra6='')) and
            a.freeze_flag='N' and
            ((c.comm_code = @pextra7) or (@pextra7 is null) or (@pextra7 = '')) and 
            (a.ag_type=@pextra1 or @pextra1 is null or @pextra1='') and 
            (a.ag_class=@pextra3 or @pextra3 is null or @pextra3='')
             order by route_seq,supply_seq,agency_name,edtn_name,sup_seq_no,supply_type_name
	End
	end
  else	Begin
      if @psorted_by='2' Begin---for edition district and agency wise
            SELECT A.COMP_CODE COMP_CODE,A.UNIT UNIT,A.AGCD AGCD,A.DPCD DPCD,A.AG_NAME AGENCY_NAME,A.AG_NAME_OTH_LANG AGENCY_NAME_OTHER_LANG,A.CITY_CODE CITY_CODE,
            DBO.CIR_GET_CITY(A.COMP_CODE,A.CITY_CODE) CITY_NAME,A.STATION_CODE DROP_POINT_CODE,DBO.CIR_GET_DROP_POINT_NAME(A.COMP_CODE,A.UNIT,A.STATION_CODE,'1') DROP_POINT_NAME,
            ISNULL(C.BASE_SUPPLY,0) BASE_SUPPLY,ISNULL(C.SUPPLY_SUN,0) SUPPLY_SUN,ISNULL(C.SUPPLY_MON,0) SUPPLY_MON,ISNULL(C.SUPPLY_TUE,0) SUPPLY_TUE,ISNULL(C.SUPPLY_WED,0) SUPPLY_WED,
            ISNULL(C.SUPPLY_THU,0) SUPPLY_THU,ISNULL(C.SUPPLY_FRI,0) SUPPLY_FRI,ISNULL(C.SUPPLY_SAT,0) SUPPLY_SAT,ISNULL(C.SUPPLY_SPL1,0) SUPPLY_SPL1,ISNULL(C.SUPPLY_SPL2,0) SUPPLY_SPL2,
            C.LBL_PRINTNO SUPPLY_SEQ,DBO.CIR_GET_ROUTE_SEQNO(C.COMP_CODE,C.UNIT,C.ROUTE_CODE) ROUTE_SEQ,
            C.ROUTE_CODE,DBO.CIR_GET_NAME_CIR_ROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,1,@PDATEFORMAT,'','') ROUTE_NAME, 
            C.SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,C.SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBROUTE_NAME,
            C.SUB_SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBSUBROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,C.SUBROUTE_CODE,C.SUB_SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBSUBROUTE_NAME,
            D.DIST_NAME DIST_NAME,ISNULL(P.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,C.SUPPLY_TYPE_CODE SUPPLY_TYPE_CODE,B.SUP_TY_NAME SUPPLY_TYPE_NAME,
			C.EDTN EDTN,E.EDTN_NAME EDTN_NAME,B.SUP_SEQ_NO SUP_SEQ_NO,
			A.SUSPEND SUSPEND,C.PUBL PUBL,DB0.CIR_GET_PUBL_NAME(A.COMP_CODE,C.PUBL) PUBL_NAME
            from cir_agmast a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,
            cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code= @pcomp_code and p.comp_code= @pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit= @punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ 
and (c.publ= @ppubl_code  or @ppubl_code is null)
and c.edtn=e.edtn and (c.edtn = isnull(@pedtn_code,c.edtn) or @pedtn_code='') and (e.main_edtn = isnull(@pmedtn_code,e.main_edtn) or @pmedtn_code='') and 
            a.agcd=c.agcd and (a.bill_agcd=isnull(@pagcd_code,a.bill_agcd) or @pagcd_code='') and a.dpcd=c.dpcd and (a.bill_dpcd=isnull(@pdpcd_code,a.bill_dpcd) or @pdpcd_code='') and (c.supply_type_code= @psup_type or @psup_type is null or @psup_type='') and 
			(a.state_code=@pstate or @pstate is null or @pstate='') and
            (a.dist_code=@pdistcode or @pdistcode is null  or @pdistcode='') and (a.tehsil_taluka = @ptaluka or @ptaluka is null or @ptaluka='') and
            (a.city_code=@pcitycode or @pcitycode is null) and (a.branch_code = @pbrancode or @pbrancode is null or @pbrancode='') and
            (c.route_code=@proutecode or @proutecode is null) and isnull(c.supply_flag,'N') ='Y' and 
            ((isnull(a.suspend,'N')=isnull(@pextra6,'N')) or (@pextra6 is null) or (@pextra6='')) and
            a.freeze_flag='N' and
            ((c.comm_code = @pextra7) or (@pextra7 is null) or (@pextra7 = '')) and 
            (a.ag_type=@pextra1 or @pextra1 is null or @pextra1='') and (a.ag_class=@pextra3 or @pextra3 is null or @pextra3='')
            order by dist_name,agency_name,edtn_name,sup_seq_no,supply_type_name,supply_seq
	End
      else	Begin
          SELECT A.COMP_CODE COMP_CODE,A.UNIT UNIT,A.AGCD AGCD,A.DPCD DPCD,A.AG_NAME AGENCY_NAME,A.AG_NAME_OTH_LANG AGENCY_NAME_OTHER_LANG,A.CITY_CODE CITY_CODE,
            DBO.CIR_GET_CITY(A.COMP_CODE,A.CITY_CODE) CITY_NAME,A.STATION_CODE DROP_POINT_CODE,DBO.CIR_GET_DROP_POINT_NAME(A.COMP_CODE,A.UNIT,A.STATION_CODE,'1') DROP_POINT_NAME,
            ISNULL(C.BASE_SUPPLY,0) BASE_SUPPLY,ISNULL(C.SUPPLY_SUN,0) SUPPLY_SUN,ISNULL(C.SUPPLY_MON,0) SUPPLY_MON,ISNULL(C.SUPPLY_TUE,0) SUPPLY_TUE,ISNULL(C.SUPPLY_WED,0) SUPPLY_WED,
            ISNULL(C.SUPPLY_THU,0) SUPPLY_THU,ISNULL(C.SUPPLY_FRI,0) SUPPLY_FRI,ISNULL(C.SUPPLY_SAT,0) SUPPLY_SAT,ISNULL(C.SUPPLY_SPL1,0) SUPPLY_SPL1,ISNULL(C.SUPPLY_SPL2,0) SUPPLY_SPL2,
            C.LBL_PRINTNO SUPPLY_SEQ,DBO.CIR_GET_ROUTE_SEQNO(C.COMP_CODE,C.UNIT,C.ROUTE_CODE) ROUTE_SEQ,
            C.ROUTE_CODE,DBO.CIR_GET_NAME_CIR_ROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,1,@PDATEFORMAT,'','') ROUTE_NAME, 
            C.SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,C.SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBROUTE_NAME,
            C.SUB_SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBSUBROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,C.SUBROUTE_CODE,C.SUB_SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBSUBROUTE_NAME,
            D.DIST_NAME DIST_NAME,ISNULL(P.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,C.SUPPLY_TYPE_CODE SUPPLY_TYPE_CODE,B.SUP_TY_NAME SUPPLY_TYPE_NAME,
			C.EDTN EDTN,E.EDTN_NAME EDTN_NAME,B.SUP_SEQ_NO SUP_SEQ_NO,
			A.SUSPEND SUSPEND,C.PUBL PUBL,DB0.CIR_GET_PUBL_NAME(A.COMP_CODE,C.PUBL) PUBL_NAME
            from cir_agmast a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
			where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code= @pcomp_code and p.comp_code= @pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit= @punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ 
and (c.publ= @ppubl_code or @ppubl_code is null)
and c.edtn=e.edtn and (c.edtn = isnull(@pedtn_code,c.edtn) or @pedtn_code='') and (e.main_edtn = isnull(@pmedtn_code,e.main_edtn) or @pmedtn_code='') and 
            a.agcd=c.agcd and (a.bill_agcd=isnull(@pagcd_code,a.bill_agcd) or @pagcd_code='') and a.dpcd=c.dpcd and (a.bill_dpcd=isnull(@pdpcd_code,a.bill_dpcd) or @pdpcd_code='') and (c.supply_type_code= @psup_type or @psup_type is null or @psup_type='') and 
			(a.state_code=@pstate or @pstate is null or @pstate='') and
            (a.dist_code=@pdistcode or @pdistcode is null  or @pdistcode='') and (a.tehsil_taluka = @ptaluka or @ptaluka is null or @ptaluka='') and
            (a.city_code=@pcitycode or @pcitycode is null) and (a.branch_code = @pbrancode or @pbrancode is null or @pbrancode='') and
            (c.route_code=@proutecode or @proutecode is null) and isnull(c.supply_flag,'N') ='Y' and 
            ((isnull(a.suspend,'N')=isnull(@pextra6,'N')) or (@pextra6 is null) or (@pextra6='')) and
            a.freeze_flag='N' and
            ((c.comm_code = @pextra7) or (@pextra7 is null) or (@pextra7 = '')) and 
            (a.ag_type=@pextra1 or @pextra1 is null or @pextra1='') and 
			(a.ag_class=@pextra3 or @pextra3 is null or @pextra3='')
             order by route_seq,supply_seq,agency_name,edtn_name,sup_seq_no,supply_type_name
	End
End
End



//====================================issue no. 5808.5809 09/12/2011==================================================

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[cir_rep_billing_cir_billing_outstanding_p]
	@pcomp_code			as	varchar(20),
    @punit_code			as	varchar(20),
    @repty				as	varchar(20),
    @pbill_freq			as	varchar(20),
    @pfrom_billdt		as	datetime,
    @ptill_billdt		as	datetime,
    @ppubl				as	varchar(20),
    @pbillagcd			as	varchar(20),
    @pbilldpcd			as	varchar(20),
    @pdateformat		as	varchar(20),
    @pbrancode			as	varchar(20),
    @pdistcode			as	varchar(20),
    @pagclass			as	varchar(20),
    @pextra1			as	varchar(200),--for executive code
    @pextra2			as	varchar(200) 
AS 
	If @pcomp_code ='' Begin
		set @pcomp_code=null
	End
	If @punit_code ='' Begin
		set @punit_code=null
	End
	If @repty ='' Begin
		set @repty=null
	End
	If @pbill_freq ='' Begin
		set @pbill_freq=null
	End
	If @ppubl ='' Begin
		set @ppubl=null
	End
	If @pbillagcd ='' Begin
		set @pbillagcd=null
	End
	If @pbilldpcd ='' Begin
		set @pbilldpcd=null
	End

	If @pbrancode ='' Begin
		set @pbrancode=null
	End
	If @pdistcode ='' Begin
		set @pdistcode=null
	End
	If @pagclass ='' Begin
		set @pagclass=null
	End
	If @pextra1 ='' Begin
		set @pextra1=null
	End
	If @pextra2 ='' Begin
		set @pextra2=null
	End	

	DECLARE @v_dt           DATETIME 
	DECLARE @v_statecode	varchar(200)
    DECLARE @v_distcode		varchar(200)
    DECLARE @v_citycode		varchar(200)
    DECLARE @v_taluka		varchar(200)

	DECLARE @v1_comp_code		varchar(20)
	DECLARE @v1_unit_code		varchar(20)
	DECLARE @v1_publ			varchar(20)
	DECLARE @v1_agcd			varchar(20)
	DECLARE @v1_dpcd			varchar(20)
	DECLARE @v1_ag_name			varchar(200)
	DECLARE @v1_ag_name_oth_lang	varchar(200)
    DECLARE @v1_city_code		varchar(200)
    DECLARE @v1_country_code	varchar(200)
    DECLARE @v1_state_code		varchar(200)
    DECLARE @v1_dist_code		varchar(200)
    DECLARE @v1_taluka_code		varchar(200)
    DECLARE @v1_billno			varchar(200)
    DECLARE @v1_billdt			datetime
    DECLARE @v1_supply_copy		numeric(8)
    DECLARE @v1_gross_amount	numeric(12,2)
    DECLARE @v1_sur_amount		numeric(12,2) 
    DECLARE @v1_comm_amount		numeric(12,2)
    DECLARE @v1_bill_sec_amt	numeric(12,2) 
    DECLARE @v1_drop_point		varchar(200)

		DECLARE cur_bill cursor FOR 
		select distinct a.comp_code comp_code, a.unit_code unit_code, /*a.publ publ,*/a.agcd agcd, a.dpcd dpcd,
		                b.ag_name ag_name, b.ag_name_oth_lang ag_name_oth_lang, b.city_code city_code, b.country_code country_code, b.state_code state_code,
		                b.dist_code dist_code, b.tehsil_taluka taluka_code,/*a.billno billno,a.billdt billdt,*/sum(a.bill_copy) supply_copy, 
		                sum(a.gross_amount) gross_amount, sum(a.sur_amt) sur_amount,sum(a.comm_amt) comm_amount, c.bill_sec_amt bill_sec_amt, b.station_code drop_point
        from cir_bill_det a,cir_agmast b,cir_bill c
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=@pcomp_code and
                  a.unit_code=b.unit and a.unit_code=c.unit_code and
                  a.unit_code=isnull(@punit_code,a.unit_code) and
                  a.billdt=c.billdt and a.billdt >= @pfrom_billdt and a.billdt<=@ptill_billdt and a.billno=c.billno and
                  (a.bill_flag=@pbill_freq or @pbill_freq is null) and a.publ=isnull(@ppubl,a.publ) and a.agcd=b.agcd and a.dpcd=b.dpcd and
                  a.agcd=c.agcd and a.dpcd=c.dpcd and a.agcd=isnull(@pbillagcd,a.agcd) and a.dpcd=isnull(@pbilldpcd,a.dpcd) and
                  (b.ag_class=@pagclass or @pagclass is null) and
                  (b.state_code=@v_statecode or @v_statecode is null) and (b.dist_code=@v_distcode or @v_distcode is null) and
                  (b.tehsil_taluka=@v_taluka or @v_taluka is null) and (b.branch_code=@pbrancode or @pbrancode is null) and
                  (b.city_code=@v_citycode or @v_citycode is null) and (b.executive_code = @pextra1 or @pextra1 is null)
                  group by a.comp_code,a.unit_code,/*a.publ,*/a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,
                  b.city_code,b.country_code,b.state_code,b.dist_code,b.tehsil_taluka,c.bill_sec_amt,b.station_code /*,a.billno,a.billdt*/
                  order by a.comp_code,a.unit_code,/*a.billdt,a.billno,*/a.agcd,a.dpcd/*,a.publ*/;

		declare @v2_doctyp	varchar(20)
		declare @v2_amount	numeric(15,2)
		declare @v_dsign           numeric(2)
		declare @v_ret_gross       numeric(15,2)
        declare @v_ret_comm        numeric(15,2)
        declare @v_ret_copy        numeric(15)
        declare @v_dn_amt          numeric(15,2)
        declare @v_cn_amt          numeric(15,2)
        declare @v_rec_amt         numeric(15,2)
        declare @v_prev_bal        numeric(15,2)
        declare @v_sec_bal         numeric(15,2)
        declare @v_opdate          datetime
        declare @v_state_name      varchar(200)
        declare @v_dist_name       varchar(200)
        declare @v_taluka_name     varchar(200)
        declare @v_city_name       varchar(200)
        declare @v_drop_point_name varchar(200)
        		
		

CREATE TABLE #CIR_TEMP_BILL_COLLECTION
( COMP_CODE        VARCHAR(100),
  UNIT_CODE        VARCHAR(100),
  BILLNO           VARCHAR(200),
  BILLDT           DATETIME,
  PUBL_CODE        VARCHAR(100),
  AGCD             VARCHAR(100),
  DPCD             VARCHAR(100),
  SUPPLY_COPY      NUMERIC(10)                   DEFAULT 0,
  GROSS_AMT        NUMERIC(15,2)                 DEFAULT 0,
  COMM_AMT         NUMERIC(15,2)                 DEFAULT 0,
  SUR_AMT          NUMERIC(15,2)                 DEFAULT 0,
  RETURN_COPY      NUMERIC(10)                   DEFAULT 0,
  RETURN_AMT       NUMERIC(15,2)                 DEFAULT 0,
  DN_AMT           NUMERIC(15,2)                 DEFAULT 0,
  CN_AMT           NUMERIC(15,2)                 DEFAULT 0,
  REC_AMT          NUMERIC(15,2)                 DEFAULT 0,
  PREV_BAL         NUMERIC(15,2)                 DEFAULT 0,
  CUR_SESSIONID    NUMERIC,
  AGNAME           VARCHAR(200),
  AGNAME_OTH_LANG  VARCHAR(250),
  CITY_CODE        VARCHAR(200),
  TALUKA_CODE      VARCHAR(200),
  DIST_CODE        VARCHAR(200),
  STATE_CODE       VARCHAR(200),
  REMARKS          VARCHAR(500),
  RET_COMM_AMT     NUMERIC(15,2),
  BILL_SEC_AMT     NUMERIC(15,2),
  SEC_OPBAL        NUMERIC(15,2))
            
		OPEN cur_bill ---main cursor bill

		fetch NEXT FROM cur_bill INTO @v1_comp_code, @v1_unit_code, /*@v1_publ,*/ @v1_agcd, @v1_dpcd,
		                              @v1_ag_name, @v1_ag_name_oth_lang, @v1_city_code, @v1_country_code, @v1_state_code,
		                              @v1_dist_code, @v1_taluka_code, /*@v1_billno, @v1_billdt,*/ @v1_supply_copy, 
		                              @v1_gross_amount, @v1_sur_amount, @v1_comm_amount, @v1_bill_sec_amt, @v1_drop_point

		WHILE (@@FETCH_STATUS = 0) BEGIN 
		SELECT @v_ret_copy  =  SUM(ISNULL(apr_short_recpt, 0) + ISNULL(apr_late_recpt, 0) + ISNULL(apr_bnr, 0) + ISNULL(apr_unsold, 0)),
				@v_ret_gross  =  SUM(ISNULL(copy_amt, 0) + ISNULL(waste_amt, 0)),
				@v_ret_comm  =  ISNULL(SUM(comm_amt), 0)
			FROM  cir_unsold_dtl 
			WHERE comp_code  = @v1_comp_code AND unit_code  = @v1_unit_code
			 AND doctype  = 'UCN' AND app_dt  >= @pfrom_billdt AND app_dt  <= @ptill_billdt
			 AND agcd  = @v1_agcd AND dpcd  = @v1_dpcd /*and publ=@v1_publ*/

			SET @v_prev_bal		= DBO.cir_accounts_cir_agency_opbal(@v1_comp_code, @v1_unit_code, '', @v1_agcd, @v1_dpcd, @v_opdate, 'NM', @pdateformat, @pextra1, @pextra2)
			SET @v_sec_bal		= DBO.cir_accounts_cir_agency_opbal(@v1_comp_code, @v1_unit_code, '', @v1_agcd,@v1_dpcd, @v_opdate, 'SC', @pdateformat, @pextra1, @pextra2)

			SELECT @v_rec_amt  =  SUM(x.amount)
			FROM (SELECT SUM(amount) amount
				FROM  cir_outmast 
				WHERE comp_code  = @v1_comp_code AND unit_code  = @v1_unit_code AND achd  = 'NM'
				 AND doctyp  = 'BIL' AND billdt  >= @v_opdate AND billdt  < @pfrom_billdt
				 AND agcd  = @v1_agcd AND dpcd  = @v1_dpcd
				UNION ALL
			 	SELECT SUM(amount) amount
				FROM  cir_outmast 
				WHERE comp_code  = @v1_comp_code AND unit_code  =@v1_unit_code AND achd  = 'NM'
				 AND doctyp  <> 'BIL' AND recptdt  >= @v_opdate AND recptdt  <= @pfrom_billdt
				 AND agcd  = @v1_agcd AND dpcd  = @v1_dpcd) x

			SET @v_prev_bal	= ISNULL(@v_prev_bal, 0)+ ISNULL(@v_rec_amt, 0)
			SET @v_rec_amt  = isnull(@v_rec_amt,0) 
			SET @v_rec_amt  = 0

			SELECT @v_rec_amt  =  SUM(amount) FROM  cir_rcphdr 
			WHERE comp_code  = @v1_comp_code AND unit_code  = @v1_unit_code AND achd  = 'SC'
			 AND recptdt  >= @v_opdate AND recptdt  <= @ptill_billdt
			 AND agcd  = @v1_agcd AND dpcd  = @v1_dpcd
			
			SET @v_sec_bal  = ISNULL(@v_sec_bal, 0)+ ISNULL(@v_rec_amt, 0)
			SET @v_rec_amt  = isnull(@v_rec_amt,0)  
			SET @v_rec_amt  = 0
													
			DECLARE cur_type cursor FOR
        select doctyp,sum(amount) amount from cir_outmast
            where comp_code=@v1_comp_code and unit_code=@v1_unit_code and
                achd='NM' and doctyp not in('BIL','UCN') and recptdt>=@pfrom_billdt and recptdt<=@ptill_billdt and
                agcd=@v1_agcd and dpcd=@v1_dpcd
            group by doctyp;
			
			OPEN cur_type 
				
			fetch NEXT FROM cur_type INTO @v2_doctyp,@v2_amount

			WHILE (@@FETCH_STATUS = 0) BEGIN 

				SELECT @v_dsign  =  dsign FROM  cir_docmst 
				WHERE comp_code  = @v1_comp_code AND doc_type  = @v2_doctyp
					
				SET @v_dsign  = 1 

				IF @v_dsign > 0 BEGIN 
					SET @v_dn_amt  = ISNULL(@v_dn_amt, 0)+ ISNULL(@v2_amount, 0)
				END
				ELSE BEGIN 
					IF @v2_doctyp = 'RCR' BEGIN 
						SET @v_rec_amt  = ISNULL(@v_rec_amt, 0)+ ISNULL(@v2_amount, 0)
					END
					ELSE BEGIN 
						SET @v_cn_amt  = ISNULL(@v_cn_amt, 0)+ ISNULL(@v2_amount, 0)
					END
				END
   			fetch NEXT FROM cur_type INTO @v2_doctyp,@v2_amount
   			END
			close cur_type
			deallocate cur_type

			insert into #cir_temp_bill_collection (comp_code, unit_code, billno, billdt, publ_code,
			                                       agcd, dpcd, supply_copy, gross_amt, comm_amt, 
			                                       sur_amt, return_copy, return_amt, ret_comm_amt, dn_amt, 
			                                       rec_amt, prev_bal, cn_amt, agname, agname_oth_lang,
			                                       city_code, taluka_code, dist_code, state_code, remarks,
			                                       bill_sec_amt,sec_opbal)
                                           values (@v1_comp_code, @v1_unit_code, null, null, null,
                                                   @v1_agcd, @v1_dpcd, @v1_supply_copy, @v1_gross_amount, isnull(@v1_comm_amount,0),
                                                   @v1_sur_amount, @v_ret_copy, @v_ret_gross, @v_ret_comm, @v_dn_amt,
                                                   @v_rec_amt, @v_prev_bal, @v_cn_amt, @v1_ag_name, @v1_ag_name_oth_lang,
                                                   @v_city_name, @v_taluka_name, @v_dist_name, @v_state_name, @v_drop_point_name,
                                                   @v1_bill_sec_amt, @v_sec_bal);

			fetch NEXT FROM cur_bill INTO @v1_comp_code, @v1_unit_code, /*@v1_publ,*/ @v1_agcd, @v1_dpcd,
										  @v1_ag_name, @v1_ag_name_oth_lang, @v1_city_code, @v1_country_code, @v1_state_code,
										  @v1_dist_code, @v1_taluka_code, /*@v1_billno, @v1_billdt,*/ @v1_supply_copy, 
										  @v1_gross_amount, @v1_sur_amount, @v1_comm_amount, @v1_bill_sec_amt, @v1_drop_point

			
			set @v_dsign	= isnull(@v_dsign,0)	
			set @v_dsign	= 0
			set @v_ret_gross= isnull(@v_ret_gross,0)	
			set @v_ret_gross= 0
			set @v_ret_comm	= isnull(@v_ret_comm,0) 	
			set @v_ret_comm	= 0
			set @v_ret_copy = isnull(@v_ret_copy,0) 
			set @v_ret_copy = 0
			set @v_dn_amt	= isnull(@v_dn_amt,0)	
			set @v_dn_amt	= 0
			set @v_cn_amt	= isnull(@v_cn_amt,0)	
			set @v_cn_amt	= 0
			set @v_rec_amt	= isnull(@v_rec_amt,0)  
			set @v_rec_amt	= 0
			set @v_prev_bal = isnull(@v_prev_bal,0) 
			set @v_prev_bal = 0
			set @v_sec_bal	= isnull(@v_sec_bal,0)
			set @v_sec_bal	= 0
            set @v_state_name=null 
            set @v_dist_name=null 
            set @v_taluka_name=null 
            set @v_city_name=null
		END 
		Close cur_bill

        If @repty='S' Begin
            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,A.AGNAME AG_NAME,A.AGNAME_OTH_LANG AG_NAME_OTH_LANG,
            A.STATE_CODE STATE_NAME,
            FLOOR(ROUND((SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0))),0)) BILL_AMT,
            FLOOR(ROUND((SUM(A.COMM_AMT)),0)) COMM_AMT,
            FLOOR(ROUND((SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0)))),0)) NET_BILL,
            FLOOR(ROUND((SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(RET_COMM_AMT,0))),0)) RETURN_AMT,
            FLOOR(ROUND((SUM(ISNULL(A.RETURN_AMT,0))),0)) NET_RETURN_AMT,
            FLOOR(ROUND((SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0))),0)) TOTAL_BILL,
            FLOOR(ROUND((ABS(SUM(ISNULL(A.BILL_SEC_AMT,0)))),0)) DEP_ADJ,
            FLOOR(ROUND((SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0))),0)) TOTAL_NET,
            FLOOR(ROUND((SUM(A.PREV_BAL)),0)) PREV_BAL, 
            FLOOR(ROUND((ABS(SUM(A.REC_AMT))),0)) REC_AMT,
            FLOOR(ROUND((SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))),0)) DN_AMT, 
            FLOOR(ROUND((SUM(A.CN_AMT)),0)) CN_AMT,
            FLOOR(ROUND((SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))),0)) DR_CR_AMT,
            FLOOR(ROUND((SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)))),0)) NET_BAL,
            FLOOR(ROUND((ABS(SUM(ISNULL(A.SEC_OPBAL,0)))),0)) DEPOSIT_BALANCE,
            A.REMARKS DROP_POINT
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.state_code,a.remarks
            order by comp_code,unit_code,state_name,ag_name;

            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.STATE_CODE STATE_NAME,
            FLOOR(ROUND((SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0))),0)) BILL_AMT,
            FLOOR(ROUND((SUM(A.COMM_AMT)),0)) COMM_AMT,
            FLOOR(ROUND((SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0)))),0)) NET_BILL,
            FLOOR(ROUND((SUM(A.RETURN_COPY)),0)) RETURN_COPY,
            FLOOR(ROUND((SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(RET_COMM_AMT,0))),0)) RETURN_AMT,
            FLOOR(ROUND((SUM(ISNULL(A.RETURN_AMT,0))),0))  NET_RETURN_AMT,
            FLOOR(ROUND((SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0))),0)) TOTAL_BILL,
            FLOOR(ROUND((ABS(SUM(ISNULL(A.BILL_SEC_AMT,0)))),0)) DEP_ADJ,
            FLOOR(ROUND((SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0))),0)) TOTAL_NET,
            FLOOR(ROUND((SUM(A.PREV_BAL)),0)) PREV_BAL, 
            FLOOR(ROUND((ABS(SUM(A.REC_AMT))),0)) REC_AMT,
            FLOOR(ROUND((SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))),0)) DN_AMT, 
            FLOOR(ROUND((SUM(A.CN_AMT)),0)) CN_AMT,
            FLOOR(ROUND((SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))),0)) DR_CR_AMT,
            FLOOR(ROUND((SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)))),0)) NET_BAL,
            FLOOR(ROUND((ABS(SUM(ISNULL(A.SEC_OPBAL,0)))),0)) DEPOSIT_BALANCE
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.state_code
            order by comp_code,unit_code,state_name;
        End    
        If @repty='D' Begin

            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,A.AGNAME AG_NAME,A.AGNAME_OTH_LANG AG_NAME_OTH_LANG,
            A.STATE_CODE STATE_NAME,A.DIST_CODE DISTRICT_NAME,
            FLOOR(ROUND((SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0))),0)) BILL_AMT,
            FLOOR(ROUND((SUM(A.COMM_AMT)),0)) COMM_AMT,
            FLOOR(ROUND((SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0)))),0)) NET_BILL,
            FLOOR(ROUND((SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(A.RET_COMM_AMT,0))),0)) RETURN_AMT,
            FLOOR(ROUND((SUM(A.RETURN_AMT)),0)) NET_RETURN_AMT,
            FLOOR(ROUND((SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0))),0)) TOTAL_BILL,
            FLOOR(ROUND((ABS(SUM(ISNULL(A.BILL_SEC_AMT,0)))),0)) DEP_ADJ,
            FLOOR(ROUND((SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0))),0)) TOTAL_NET,
            FLOOR(ROUND((SUM(A.PREV_BAL)),0)) PREV_BAL, 
            FLOOR(ROUND((ABS(SUM(A.REC_AMT))),0)) REC_AMT,
            FLOOR(ROUND((SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))),0)) DN_AMT, 
            FLOOR(ROUND((SUM(A.CN_AMT)),0)) CN_AMT,
            FLOOR(ROUND((SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))),0)) DR_CR_AMT,
            FLOOR(ROUND((SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)))),0)) NET_BAL,
            FLOOR(ROUND((ABS(SUM(ISNULL(A.SEC_OPBAL,0)))),0)) DEPOSIT_BALANCE,
            A.REMARKS DROP_POINT
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.state_code,a.dist_code,a.remarks
            order by comp_code,unit_code,state_name,district_name,ag_name;

            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.DIST_CODE DISTRICT_NAME,
            A.STATE_CODE STATE_NAME,
            FLOOR(ROUND((SUM(A.SUPPLY_COPY)),0)) SUPPLY_CODE,
            FLOOR(ROUND((SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0))),0)) BILL_AMT,
            FLOOR(ROUND((SUM(A.COMM_AMT)),0)) COMM_AMT,
            FLOOR(ROUND((SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))),0)) NET_BILL,
            FLOOR(ROUND((SUM(A.RETURN_COPY)),0)) RETURN_COPY,
            FLOOR(ROUND((SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(A.RET_COMM_AMT,0))),0)) RETURN_AMT,
            FLOOR(ROUND((SUM(A.RETURN_AMT)),0)) NET_RETURN_AMT,
            FLOOR(ROUND((SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0))),0)) TOTAL_BILL,
            FLOOR(ROUND((ABS(SUM(ISNULL(A.BILL_SEC_AMT,0)))),0)) DEP_ADJ,
            FLOOR(ROUND((SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0))),0)) TOTAL_NET,
            FLOOR(ROUND((SUM(A.PREV_BAL)),0)) PREV_BAL, 
            FLOOR(ROUND((ABS(SUM(A.REC_AMT))),0)) REC_AMT,
            FLOOR(ROUND((SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))),0)) DN_AMT, 
            FLOOR(ROUND((SUM(A.CN_AMT)),0)) CN_AMT,
            FLOOR(ROUND((SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))),0)) DR_CR_AMT,
            FLOOR(ROUND((SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)))),0)) NET_BAL,
            FLOOR(ROUND((ABS(SUM(ISNULL(A.SEC_OPBAL,0)))),0)) DEPOSIT_BALANCE
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.state_code,a.dist_code
            order by comp_code,unit_code,state_name,district_name
		End
        If @repty='C' Begin

            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,A.AGNAME AG_NAME,A.AGNAME_OTH_LANG AG_NAME_OTH_LANG,
            A.STATE_CODE STATE_NAME,A.DIST_CODE DISTRICT_NAME,A.CITY_CODE CITY_NAME,
            FLOOR(ROUND((SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0))),0)) BILL_AMT,
            FLOOR(ROUND((SUM(A.COMM_AMT)),0)) COMM_AMT,
            FLOOR(ROUND((SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0)))),0)) NET_BILL,
            FLOOR(ROUND((SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(RET_COMM_AMT,0))),0)) RETURN_AMT,
            FLOOR(ROUND((SUM(A.RETURN_AMT)),0)) NET_RETURN_AMT,
            FLOOR(ROUND((SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0))),0)) TOTAL_BILL,
            FLOOR(ROUND((ABS(SUM(ISNULL(A.BILL_SEC_AMT,0)))),0)) DEP_ADJ,
            FLOOR(ROUND((SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0))),0)) TOTAL_NET,
            FLOOR(ROUND((SUM(A.PREV_BAL)),0)) PREV_BAL, 
            FLOOR(ROUND((ABS(SUM(A.REC_AMT))),0)) REC_AMT,
            FLOOR(ROUND((SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))),0)) DN_AMT, 
            FLOOR(ROUND((SUM(A.CN_AMT)),0)) CN_AMT,
            FLOOR(ROUND((SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))),0)) DR_CR_AMT,
            FLOOR(ROUND((SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)))),0)) NET_BAL,
            FLOOR(ROUND((ABS(SUM(ISNULL(A.SEC_OPBAL,0)))),0)) DEPOSIT_BALANCE,
            A.REMARKS DROP_POINT
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.state_code,a.dist_code,a.city_code,a.remarks
            order by comp_code,unit_code,state_name,district_name,city_name,ag_name;

            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.CITY_CODE CITY_NAME,
            A.DIST_CODE DISTRICT_NAME,A.STATE_CODE STATE_NAME,
            FLOOR(ROUND((SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0))),0)) BILL_AMT,
            FLOOR(ROUND((A.COMM_AMT),0)) COMM_AMT,
            FLOOR(ROUND(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))),0)) NET_BILL,
            FLOOR(ROUND((SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(RET_COMM_AMT,0))),0)) RETURN_AMT,
            FLOOR(ROUND((SUM(A.RETURN_AMT)),0)) NET_RETURN_AMT,
            FLOOR(ROUND((SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0))),0)) TOTAL_BILL,
            FLOOR(ROUND((ABS(SUM(ISNULL(A.BILL_SEC_AMT,0)))),0)) DEP_ADJ,
            FLOOR(ROUND((SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0))),0)) TOTAL_NET,
            FLOOR(ROUND((SUM(A.PREV_BAL)),0)) PREV_BAL, 
            FLOOR(ROUND((ABS(SUM(A.REC_AMT))),0)) REC_AMT,
            FLOOR(ROUND((SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))),0)) DN_AMT, 
            FLOOR(ROUND((SUM(A.CN_AMT)),0)) CN_AMT,
            FLOOR(ROUND((SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))),0)) DR_CR_AMT,
            FLOOR(ROUND((SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)))),0)) NET_BAL,
            FLOOR(ROUND((ABS(SUM(ISNULL(A.SEC_OPBAL,0)))),0)) DEPOSIT_BALANCE
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.city_code,a.dist_code,a.state_code
            order by comp_code,unit_code,state_name,district_name,city_name;
		End            
        If @repty='T' Begin
            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,A.AGNAME AG_NAME,A.AGNAME_OTH_LANG AG_NAME_OTH_LANG,
            A.STATE_CODE STATE_NAME,A.DIST_CODE DISTRICT_NAME,
            A.TALUKA_CODE+'('+A.DIST_CODE+')' TALUKA_NAME,
            FLOOR(ROUND((SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0))),0)) BILL_AMT,
            FLOOR(ROUND((SUM(A.COMM_AMT)),0)) COMM_AMT,
            FLOOR(ROUND((SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0)))),0)) NET_BILL,
            FLOOR(ROUND((SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(A.RET_COMM_AMT,0))),0)) RETURN_AMT,
            FLOOR(ROUND((SUM(A.RETURN_AMT)),0)) NET_RETURN_AMT,
            FLOOR(ROUND((SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0))),0)) TOTAL_BILL,
            FLOOR(ROUND((ABS(SUM(ISNULL(A.BILL_SEC_AMT,0)))),0)) DEP_ADJ,
            FLOOR(ROUND((SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0))),0)) TOTAL_NET,
            FLOOR(ROUND((SUM(A.PREV_BAL)),0)) PREV_BAL, 
            FLOOR(ROUND((ABS(SUM(A.REC_AMT))),0)) REC_AMT,
            FLOOR(ROUND((SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))),0)) DN_AMT, 
            FLOOR(ROUND((SUM(A.CN_AMT)),0)) CN_AMT,
            FLOOR(ROUND((SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))),0)) DR_CR_AMT,
            FLOOR(ROUND((SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)))),0)) NET_BAL,
            FLOOR(ROUND((ABS(SUM(ISNULL(A.SEC_OPBAL,0)))),0)) DEPOSIT_BALANCE,
            A.REMARKS DROP_POINT
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.taluka_code,a.dist_code,a.remarks,a.state_code
            order by comp_code,unit_code,state_name,district_name,taluka_name,ag_name;

            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.STATE_CODE STATE_NAME,A.DIST_CODE DISTRICT_NAME,
            A.TALUKA_CODE+'('+A.DIST_CODE+')' TALUKA_NAME,
            FLOOR(ROUND((SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0))),0)) BILL_AMT,
            FLOOR(ROUND((SUM(A.COMM_AMT)),0)) COMM_AMT,
            FLOOR(ROUND((SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0)))),0)) NET_BILL,
            FLOOR(ROUND((SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(RET_COMM_AMT,0))),0)) RETURN_AMT,
            FLOOR(ROUND((SUM(A.RETURN_AMT)),0)) NET_RETURN_AMT,
            FLOOR(ROUND((SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0))),0)) TOTAL_BILL,
            FLOOR(ROUND((ABS(SUM(ISNULL(A.BILL_SEC_AMT,0)))),0)) DEP_ADJ,
            FLOOR(ROUND((SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0))),0)) TOTAL_NET,
            FLOOR(ROUND((SUM(A.PREV_BAL)),0)) PREV_BAL, 
            FLOOR(ROUND((ABS(SUM(A.REC_AMT))),0)) REC_AMT,
            FLOOR(ROUND((SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))),0)) DN_AMT, 
            FLOOR(ROUND((SUM(A.CN_AMT)),0)) CN_AMT,
            FLOOR(ROUND((SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))),0)) DR_CR_AMT,
            FLOOR(ROUND((SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)))),0)) NET_BAL,
            FLOOR(ROUND((ABS(SUM(ISNULL(A.SEC_OPBAL,0)))),0)) DEPOSIT_BALANCE
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.taluka_code,a.dist_code,a.state_code
            order by comp_code,unit_code,state_name,district_name,taluka_name;
        End	

		
 DEALLOCATE cur_bill

///////////////////////////////////////////end/////////////////////////////////////////////////////////////////////////
/*************************Laxman 13-dec-2011*************/
CREATE FUNCTION cir_get_subroute_seqno(
	@pcompcode	as	varchar(20),
	@punitcode  as	varchar(20),
	@proute		as	varchar(20),
	@psubrt		as	varchar(20)) RETURNS numeric(6) aS

BEGIN
	declare @v_seqno numeric(6)
	
	select distinct @v_seqno=subrt_seq from cir_sub_route_mast
            where comp_code=@pcompcode and unit=@punitcode and route_code=@proute and subrt_code=@psubrt
    return isnull(@v_seqno,1)
END

CREATE FUNCTION cir_get_subsubroute_seqno(
@pcompcode	as varchar(20),
@punitcode	as varchar(20),
@proute		as varchar(20),
@psubrt		as varchar(20),
@psubsubrt  as varchar(20)) RETURNS numeric(6) as

BEGIN
declare @v_seqno numeric(6)

select distinct @v_seqno=sub_subrt_seq from cir_sub_subroute_mast
    where comp_code=@pcompcode and unit=@punitcode and route_code=@proute and 
    subrt_code=@psubrt and sub_subrt_code=@psubsubrt

    return isnull(@v_seqno,1)
END
/*************************Laxman 13-dec-2011*************/

////////////////////////////////////////start by 13 dec
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[cir_fetch_incentive_rate]
    @pcompcode       as varchar(50),
    @punitcode       as varchar(50),
    @ppublcode       as varchar(50),
    @psupply_type    as varchar(50),
    @pagency_type    as varchar(50),
    @pinct_type      as varchar(50),
    @pfreg_type      as varchar(50),   
    @pchkdate        as datetime, 
    @puserid         as varchar(50), 
    @pdateformate    as varchar(50), 
    @pextra1         as varchar(50), 
    @pextra2         as varchar(50), 
    @pextra3         as varchar(50), 
    @pextra4         as varchar(50), 
    @pextra5         as varchar(50), 
    @pextra6         as varchar(50), 
    @pextra7         as varchar(50), 
    @pextra8         as varchar(50), 
    @pextra9         as varchar(50), 
    @pextra10        as varchar(50)
as

	IF @punitcode='' Begin
		set @punitcode=null
	End
	IF @ppublcode='' Begin
		set @ppublcode=null
	End
	IF @psupply_type='' Begin
		set @psupply_type=null
	End
	
	IF @pagency_type='' Begin
		set @pagency_type=null
	End
	
	IF @pinct_type='' Begin
		set @pinct_type=null
	End
	
	IF @pfreg_type='' Begin
		set @pfreg_type=null
	End
	
	IF @pextra1='' Begin
		set @pextra1=null
	End						
	IF @pextra2='' Begin
		set @pextra2=null
	End	
	IF @pextra3='' Begin
		set @pextra3=null
	End	
	
	IF @pextra4='' Begin
		set @pextra4=null
	End	
	
	IF @pextra5='' Begin
		set @pextra5=null
	End	
	
	IF @pextra6='' Begin
		set @pextra6=null
	End					  
	
	IF @pextra7='' Begin
		set @pextra7=null
	End					 
	IF @pextra8='' Begin
		set @pextra8=null
	End					 
		IF @pextra9='' Begin
		set @pextra9=null
	End	 		

	IF @pextra10='' Begin
		set @pextra10=null
	End					 

    declare @v_recno			int
    declare @v1_comp_code		varchar(50)
    declare @v1_unit_code		varchar(50)
    declare @v1_publ_code		varchar(50)
    declare @v1_publ_name		varchar(100)
    declare @v1_main_edtn		varchar(50)
    declare @v1_main_edtn_name	varchar(100)
    declare @v1_edtn			varchar(50)
    declare @v1_edtn_name		varchar(100)
    declare @v1_supply_type		varchar(50)
    declare @v1_sup_ty_name		varchar(100)	
    declare @v1_calc_type		varchar(50)
    declare @v1_supply_from		numeric(10)
    declare @v1_supply_till		numeric(10)
    declare @v1_valid_from		datetime
    declare @v1_inct_amt		numeric(14,2)
    declare @v1_branch_code		varchar(50)
    declare @v1_agency_type		varchar(50)
    declare @v1_reason			varchar(50)
    
    declare c1 cursor for
    select d.comp_code comp_code,d.unit_code unit_code,d.publ_code publ_code,p.publ_name publ_name,
    e.main_edtn main_edtn,dbo.cir_get_edtn_name(d.comp_code,e.main_edtn) main_edtn_name,d.edtn_code edtn,e.edtn_name edtn_name,
    d.supply_type supply_type,s.sup_ty_name sup_ty_name,d.calc_type calc_type,
    d.supply_from supply_from,d.supply_till supply_till,
    max(d.eff_date) valid_from,d.inct_amt inct_amt,d.branch_code branch_code, d.agency_type agency_type,d.reason reason 
    from cir_publ_mast p,cir_edtn_mast e,cir_inct_slab_det d,cir_supply_type_mast s
    where p.comp_code=e.comp_code and p.comp_code=d.comp_code and p.comp_code=s.comp_code and p.comp_code=@pcompcode and
    p.publ=e.publ and p.publ=d.publ_code and p.publ=isnull(@ppublcode,p.publ)
    and  d.unit_code=isnull(@punitcode,d.unit_code) 
    and e.edtn=d.edtn_code 
    and d.supply_type=s.sup_ty_code and d.supply_type=s.sup_ty_code and d.supply_type=isnull(@psupply_type,d.supply_type) 
    and (d.agency_type=@pagency_type or @pagency_type is null)
    group by d.comp_code,d.unit_code,d.publ_code,p.publ_name,e.main_edtn,edtn_code,e.edtn_name,d.supply_type,
    s.sup_ty_name,d.calc_type,d.supply_from,d.supply_till,d.inct_amt,d.branch_code,d.agency_type,d.reason;

    declare @v_process_id    numeric(30)

    exec cir_generate_processid @pcompcode,@puserid,@pdateformate,null,null,null,null,null,@v_process_id OUTPUT
    
	CREATE TABLE #CIR_TEMP_BILL_COLLECTION
	(COMP_CODE       VARCHAR(100),
	UNIT_CODE        VARCHAR(100),
	BILLNO           VARCHAR(200),
	BILLDT           DATETIME,
	PUBL_CODE        VARCHAR(100),
	AGCD             VARCHAR(100),
	DPCD             VARCHAR(100),
	SUPPLY_COPY      NUMERIC(10)                   DEFAULT 0,
	GROSS_AMT        NUMERIC(15,2)                 DEFAULT 0,
	COMM_AMT         NUMERIC(15,2)                 DEFAULT 0,
	SUR_AMT          NUMERIC(15,2)                 DEFAULT 0,
	RETURN_COPY      NUMERIC(10)                   DEFAULT 0,
	RETURN_AMT       NUMERIC(15,2)                 DEFAULT 0,
	DN_AMT           NUMERIC(15,2)                 DEFAULT 0,
	CN_AMT           NUMERIC(15,2)                 DEFAULT 0,
	REC_AMT          NUMERIC(15,2)                 DEFAULT 0,
	PREV_BAL         NUMERIC(15,2)                 DEFAULT 0,
	CUR_SESSIONID    NUMERIC,
	AGNAME           VARCHAR(200),
	AGNAME_OTH_LANG  VARCHAR(250),
	CITY_CODE        VARCHAR(200),
	TALUKA_CODE      VARCHAR(200),
	DIST_CODE        VARCHAR(200),
	STATE_CODE       VARCHAR(200),
	REMARKS          VARCHAR(500),
	RET_COMM_AMT     NUMERIC(15,2),
	BILL_SEC_AMT     NUMERIC(15,2),
	SEC_OPBAL        NUMERIC(15,2),
	REASON			 VARCHAR(200))
    
    
    open c1
        fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_publ_code, @v1_publ_name, @v1_main_edtn, @v1_main_edtn_name, @v1_edtn,@v1_edtn_name, @v1_supply_type, @v1_sup_ty_name, @v1_calc_type, @v1_supply_from,@v1_supply_till, @v1_valid_from, @v1_inct_amt, @v1_branch_code, @v1_agency_type ,@v1_reason
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
        insert into #cir_temp_bill_collection
            (comp_code, unit_code, billno,publ_code, agcd, dpcd,agname,agname_oth_lang, 
            city_code, state_code,taluka_code,dist_code,
            billdt,supply_copy,return_copy,comm_amt,remarks,cur_sessionid,REASON)
        values(@v1_comp_code,@v1_unit_code,@v1_publ_code,@v1_publ_name,@v1_main_edtn,@v1_edtn,@v1_main_edtn_name,@v1_edtn_name,
            @v1_supply_type,@v1_sup_ty_name,@v1_branch_code,@v1_agency_type,
            @pchkdate,@v1_supply_from,@v1_supply_till,@v1_inct_amt,@v1_calc_type,@v_process_id,@v1_reason)
		
		fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_publ_code, @v1_publ_name, @v1_main_edtn, @v1_main_edtn_name, @v1_edtn,@v1_edtn_name, @v1_supply_type, @v1_sup_ty_name, @v1_calc_type, @v1_supply_from,@v1_supply_till, @v1_valid_from, @v1_inct_amt, @v1_branch_code, @v1_agency_type ,@v1_reason
		End 
    close c1
    deallocate c1
    
    select comp_code AS "COMP_CODE", unit_code AS "UNIT_CODE", billno as "PUBL_CODE",publ_code AS "PUBL_NAME", agcd AS "MAIN_EDTN", dpcd AS "EDTN",
    agname AS "MAIN_EDTN_NAME",agname_oth_lang AS "EDTN_NAME", city_code AS "SUPPLY_TYPE", STATE_code AS "SUPPLY_TYPE_NAME",
    taluka_code as "BRANCH_CODE",dist_code AS "AGENCY_TYPE", 
    billdt AS "SUPDATE" ,comm_amt AS "INCT_AMT" ,REMARKS AS "CALC_TYPE",cur_sessionid as "PROCESSNO",
    supply_copy as "SUPPLY_FROM",return_copy as "SUPPLY_TILL",reason as "REASON"
    from #cir_temp_bill_collection
    
    select getdate() as "CUR_DATE"
    
    drop table #cir_temp_bill_collection
    

////////////////////////////////////




create procedure [dbo].[cir_fetch_incentive_data_p]
    @pcompcode       AS varchar(20),
    @punitcode       AS varchar(20),
    @pagtype         AS varchar(20),
    @pagclass        AS varchar(20),
    @psup_type       AS varchar(20),
    @pagcode         AS varchar(20),
    @pdepocode       AS varchar(20),
    @pcode           AS varchar(2000),
    @pprocesstype    AS varchar(20),--process by Zone.Region,Branch,District,Route
    @pdatefrom       AS datetime,
    @pdatetill       AS datetime,
    @pinct_type      AS varchar(20),--for supply or growth
    @pprocess_type   AS varchar(20),--for daily,weekly or monthly
    @psupply_days    AS numeric(5),
    @pprocessid      AS numeric(30),
    @pdelimiter      AS varchar(20),
    @puserid         AS varchar(20),
    @pdateformat     AS varchar(20),
    @pextra1         AS varchar(200),
    @pextra2         AS varchar(200),
    @pextra3         AS varchar(200),
    @pextra4         AS varchar(200),
    @pextra5         AS varchar(200)
  As
	If @punitcode='' Begin
		set @punitcode=null
	End	
	If @pagtype='' Begin
		set @pagtype=null
	End
	If @pagclass='' Begin
		set @pagclass=null
	End
	If @psup_type='' Begin
		set @psup_type=null
	End
	If @pagcode='' Begin
		set @pagcode=null
	End
	If @pdepocode='' Begin
		set @pdepocode=null
	End
	If @pcode='' Begin
		set @pcode=null
	End
	If @pprocesstype='' Begin
		set @pprocesstype=null
	End
	If @pinct_type='' Begin
		set @pinct_type=null
	End
	If @pprocess_type='' Begin
		set @pprocess_type=null
	End
	If @pextra1='' Begin
		set @pextra1=null
	End									
	If @pextra2='' Begin
		set @pextra2=null
	End
	If @pextra3='' Begin
		set @pextra3=null
	End									
	If @pextra4='' Begin
		set @pextra4=null
	End
	If @pextra5='' Begin
		set @pextra5=null
	End

	CREATE TABLE #CIR_LEDGER_REPORT
	( COMP_CODE			VARCHAR(100),
	  UNIT_CODE			VARCHAR(100),
	  DEBIT_HEAD		VARCHAR(100),
	  REC_SEQNO			INT)

	declare @vlength		numeric(7);
	declare @vrunval		varchar(4000);
	declare @v_val			varchar(800);
	declare @v_name			varchar(8000);
	declare @v_sname		varchar(4000);
	declare @vno			numeric(10)
	declare @v_doctype		varchar(10)
	set @v_doctype='CN'
	declare @v_recptdt		datetime
	declare @v_dt			datetime
	declare @v1_comp_code	varchar(20)
	declare @v1_unit_code	varchar(20)
	declare @v1_publ		varchar(20)
	declare @v1_edtn		varchar(20)
	declare @v1_sup_type_code	varchar(20)
	declare @v1_supdate		datetime
	declare @v1_agcd		varchar(20)
	declare @v1_dpcd		varchar(20)
	declare @v1_billagcd	varchar(20)
	declare @v1_billdpcd	varchar(20)
	declare @v1_ag_type		varchar(20)
	declare @v1_branch_code	varchar(20)
	declare @v1_sup_copy	numeric(10)
	declare	@i				int
    
    declare c1 cursor for
        select distinct a.comp_code comp_code,a.unit_code unit_code,a.publ publ,a.edtn edtn,a.sup_type_code sup_type_code,
        a.supdate supdate,a.agcd agcd,a.dpcd dpcd,a.billagcd billagcd,a.billdpcd billdpcd,d.ag_type ag_type,d.branch_code branch_code, 
        sum(a.sup_copy) sup_copy
        from cir_dbksup a,cir_supply_type_mast c,cir_agmast d
        where a.comp_code = @pcompcode and a.comp_code = c.comp_code and a.comp_code = d.comp_code and 
              a.unit_code=isnull(@punitcode,a.unit_code) and a.unit_code=d.unit and  
              a.supdate >= @pdatefrom and a.supdate <=@pdatetill and a.sup_type_code =c.sup_ty_code and
              a.sup_type_code=isnull(@psup_type,a.sup_type_code) and  
              a.agcd = d.agcd and a.dpcd = d.dpcd and d.agcd = ISNULL(@pagcode,d.agcd) and d.dpcd = ISNULL(@pdepocode,d.dpcd) and 
              (d.ag_type =@pagtype or @pagtype is null) and (d.ag_class =@pagclass or @pagclass is null) and 
              ((d.dist_code in(select debit_head from #CIR_LEDGER_REPORT)) or @pcode is null) and 
              (a.billagcd is not null or a.billagcd<>'')
              group by a.comp_code,a.unit_code,a.publ,a.edtn,a.sup_type_code,a.supdate,a.agcd,a.dpcd,a.billagcd,a.billdpcd,d.ag_type,d.branch_code              
              order by a.comp_code,a.unit_code,a.supdate,a.publ,a.edtn,a.sup_type_code;
    
    declare @v_amt			numeric(15,2);
    declare @v_remark		varchar(500);
    declare @v_recptno		varchar(50);
    declare @v_dsign		numeric(5);
    
    declare @v_bran_code	varchar(20);
    declare @v_rec_no		numeric(10);  
    declare @v_unsold_copy	numeric(10);
    declare @vdistcode		varchar(4000);

    set @v_recptdt =  @pdatetill
    declare @v2_calc_type	varchar(20)
    declare @v2_inct_amt	numeric(15,2)
    declare @v2_supply_from	numeric(10)
    declare @v2_supply_till numeric(10)
    /*if @pcode is not null Begin
        set @vdistcode=@pcode+','

        vlength :=null; v_val :=null; v_name:=null;vrunval :=null; vno:=null;
        v_val   :=replace(vdistcode,',',',');
        vlength :=length(v_val);vno:=1;

        for i in 1.. vlength loop
            vrunval:=substr(v_val,i,1);
            if vrunval!=',' then
                v_name:=v_name||vrunval;
            else
                insert into #CIR_LEDGER_REPORT(comp_code ,unit_code ,debit_head,credit_head,rec_seqno,sess_id)
                        values (pcompcode,punitcode,v_name,null,vno,userenv('sessionid'));
                vno:=vno+1;
                v_name:='';
            end if;
        end loop;
    end if;*/
	/*If @pcode is not null Begin 
		print('1')print(@pcode)
		set @vdistcode	= @pcode+@pdelimiter
		set @v_name		= null set @vrunval	= null set @vno		= 1
		set @v_val		= replace(@vdistcode,@pdelimiter,',')
		set @vlength	= len(@v_val) set @i = 1 
		print('2')
		WHILE @i <= @vlength Begin
			set @vrunval  = substring(@v_val, @i, 1)
			If @vrunval != ',' Begin
				set @v_name  = @v_name + @vrunval 
			End
			Else Begin 
				INSERT INTO #cir_ledger_report(comp_code,unit_code,debit_head,rec_seqno)  
				VALUES(@pcompcode,@punitcode,@v_name,@vno)  
				
				set @vno  = @vno + 1 
				set @v_name  = '' 
			End

			set @i = @i + 1
		End
	End*/
    open c1;
    fetch NEXT FROM c1 INTO @v1_comp_code, @v1_unit_code,@v1_publ,@v1_edtn,@v1_sup_type_code,@v1_supdate,@v1_agcd,@v1_dpcd,@v1_billagcd,@v1_billdpcd,@v1_ag_type,@v1_branch_code, @v1_sup_copy
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN

PRINT('FIRST')	
			select @v2_calc_type=calc_type,@v2_inct_amt=inct_amt,@v2_supply_from=supply_from,@v2_supply_till=supply_till
			from cir_inct_slab_temp where process_id=@pprocessid and comp_code=@v1_comp_code and unit_code=@v1_unit_code 
				--and publ_code=@v1_publ and edtn_code=@v1_edtn
				and supply_type=@v1_sup_type_code and agency_type=@v1_ag_type -- and eff_date<=v1.supdate 
				and process_type=@pprocess_type and inct_type=@pinct_type 
				and ((branch_code is null or branch_code='' ) or (branch_code=@v1_branch_code))
				--and @v1_sup_copy between supply_from and supply_till
       
        If isnull(@v2_calc_type,'F')='P' Begin
			set @v_amt=(isnull(@v1_sup_copy,0)-isnull(@v_unsold_copy,0))*(isnull(@v2_inct_amt,0)/100)
        End    
        Else Begin
            set @v_amt=(isnull(@v1_sup_copy,0)-isnull(@v_unsold_copy,0))*isnull(@v2_inct_amt,0)
        End
        
        If isnull(@v_amt,0)<>0 Begin 
            insert into cir_inct_process_det_temp(comp_code,unit_code,publ_code,edtn_code,sup_type_code,from_pdate,till_pdate,
                            agcd,dpcd,tot_supply,from_supply,till_supply,inct_rate,calc_type,amount,
                            doctype,recptdt,recptno,bilagcd,bildpcd,created_by,tran_type)
                    values(@v1_comp_code,@v1_unit_code,@v1_publ,@v1_edtn,@v1_sup_type_code,@pdatefrom,@pdatetill,
                            @v1_agcd,@v1_dpcd,isnull(@v1_sup_copy,0),@v2_supply_from,@v2_supply_till,@v2_inct_amt,@v2_calc_type,@v_amt,
                            @v_doctype,@v_recptdt,@pprocessid,@v1_billagcd,@v1_billdpcd,@puserid,'INC')
        End
		fetch NEXT FROM c1 INTO @v1_comp_code, @v1_unit_code,@v1_publ,@v1_edtn,@v1_sup_type_code,@v1_supdate,@v1_agcd,@v1_dpcd,@v1_billagcd,@v1_billdpcd,@v1_ag_type,@v1_branch_code, @v1_sup_copy
	End
	close c1
	deallocate c1
	set @v_amt=0

    select s.comp_code as "COMP_CODE",s.unit_code AS "UNIT_CODE",s.recptno as "RECPTNO",s.recptdt as "RECPTDT", s.bilagcd AS "AGCD",s.bildpcd AS "DPCD",m.ag_name AS "AG_NAME",
    dbo.cir_get_drop_point_name(s.comp_code,s.unit_code,m.station_code,1) as "DROP_POINT_NAME",dbo.cir_get_city(s.comp_code,m.city_code) as "CITY_NAME",
    s.doctype as "DOCTYPE",sum(s.tot_supply) as "SUPPLY",s.from_supply as "FROM_SUPPLY",s.till_supply AS "TILL_SUPPLY",
    s.publ_code as "PUBL_CODE" ,dbo.cir_get_publ_name(s.comp_Code,s.publ_code) as "PUBL_NAME",
    e.main_edtn AS "MAIN_EDTN", dbo.cir_get_edtn_name(s.comp_code,e.main_edtn) as "MAIN_EDTN_NAME",
    s.inct_rate AS "INCT_RATE",s.calc_type as "CALC_TYPE",sum(s.amount) as "AMOUNT",
    s.sup_type_code as "SUP_TYPE_CODE",dbo.cir_get_supply_name(s.comp_code,s.sup_type_code) as "SUP_TYPE_NAME"
    from cir_inct_process_det_temp s,cir_agmast m,cir_edtn_mast e
    where s.comp_code=m.comp_code and s.comp_code=e.comp_code and s.edtn_code=e.edtn and 
    s.unit_code=m.unit and s.bilagcd=m.agcd and s.bildpcd=m.dpcd and s.recptno=@pprocessid and tran_type='INC'
    group by s.comp_code,s.unit_code,s.recptno,s.recptdt,s.doctype,s.inct_rate,s.calc_type,s.from_supply,s.till_supply,
    e.main_edtn,s.bilagcd,s.bildpcd,m.station_code,m.city_code,m.ag_name,s.sup_type_code,s.publ_code
    having sum(amount)>0
    order by comp_code,unit_code,bilagcd,bildpcd,publ_name,main_edtn_name,sup_type_name
      
	drop table #cir_ledger_report

///////////////////////

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[cir_generate_processid]
    @pcomp_code 	 as  varchar(20),
    @puserid         as  varchar(20),
    @pdateformat     as  varchar(20),
    @pextra1         as  varchar(20),
    @pextra2         as  varchar(20),
    @pextra3         as  varchar(20),
    @pextra4         as  varchar(20),
    @pextra5         as  varchar(20),
    @v_id			 as  int  output
    AS
Begin
	declare @v_cnt  int
	
	select @v_cnt =count(*) from cir_process_id;
    
    If isnull(@v_cnt,0)=0 Begin
        insert into cir_process_id(process_id) values(1)
	End
    else Begin
        update cir_process_id set process_id=isnull(process_id,0)+1
    End
    
    select @v_id =isnull(max(process_id),0) from cir_process_id
	
	select @v_id as "PROCESS_ID"

End

/////////////////////////////////end by 13 dec

/////////////////////////13 dec

ALTER procedure [dbo].[cir_incentive_cn_process_p]
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @ppublcode       as varchar(20),       
    @pedtncode       as varchar(20),
    @pagcode         as varchar(20),
    @pdepocode       as varchar(20),
    @pdatefrom       as datetime,
    @pdatetill       as datetime,
    @pdoctype        as varchar(20),
    @precptdt        as datetime,
    @precptno        as varchar(50),
    @preason         as varchar(50),
    @pinct_rate      as numeric(15,2),
    @pinct_type      as varchar(20),
    @pfreg_type      as varchar(20),   
    @premark         as varchar(500),
    @puserid         as varchar(20),
    @pdateformat     as varchar(20),
    @pextra1         as varchar(50),
    @pextra2         as varchar(50),
    @pextra3         as varchar(50),
    @pextra4         as varchar(50),
    @pextra5         as varchar(50)
  As
    declare @v_doctype		varchar(10)
    declare @v2_comp_code	varchar(50)
    declare @v2_unit_code	varchar(50)
    declare @v2_doctype		varchar(50)
    declare @v2_tot_supply  numeric(10)
    declare @v2_recptdt		datetime
    declare @v2_recptno		varchar(50)
    declare @v2_amount		numeric(15,2)
    declare @v2_bilagcd		varchar(50)
    declare @v2_bildpcd		varchar(50)
    declare c2 cursor for
        select s.comp_code,s.unit_code,s.doctype,sum(s.tot_supply) tot_supply,s.recptdt,s.recptno,sum(s.amount) amount,s.bilagcd,s.bildpcd 
        from cir_inct_process_det s,cir_agmast m  ,cir_edtn_mast e
        where s.comp_code=m.comp_code and s.comp_code=e.comp_code and s.comp_code=@pcompcode and s.unit_code=m.unit and s.unit_code=@punitcode and 
        s.bilagcd=m.agcd and s.bilagcd=@pagcode and s.bildpcd=m.dpcd and s.bildpcd= @pdepocode and
        s.recptno=@precptno and s.recptdt=@precptdt and s.publ_code=@ppublcode and s.publ_code=e.publ and s.edtn_code=e.edtn and 
        e.main_edtn=@pedtncode
        group by s.comp_code,s.unit_code,s.doctype,s.recptdt,s.recptno,s.bilagcd,s.bildpcd
        having sum(s.amount)>0
        order by s.comp_code,s.unit_code,s.bilagcd,s.bildpcd
    
    declare @v_amt			numeric(15,2)
    declare @v_remark		varchar(500);
    declare @v_recptno		varchar(50);
    declare @v_dsign		numeric(5);
    
    declare @v_bran_code	varchar(20);
    declare @v_rec_no		numeric(10);  
    declare @v_unsold_copy	numeric(10);
  Begin
    insert into cir_inct_process_det
        (comp_code, unit_code, publ_code, edtn_code, sup_type_code, from_pdate, till_pdate, agcd, dpcd, tot_supply, from_supply, till_supply, inct_rate, calc_type, amount, doctype, recptdt, recptno, bilagcd, bildpcd,
        created_by, created_date, updated_by, updated_date,tran_type)
        select s.comp_code, s.unit_code, s.publ_code, s.edtn_code, s.sup_type_code, s.from_pdate, s.till_pdate, s.agcd, s.dpcd, s.tot_supply, s.from_supply, s.till_supply, ISNULL(@pinct_rate, s.inct_rate), 
        s.calc_type, case when s.calc_type='P' then round(s.tot_supply*(isnull(@pinct_rate, s.inct_rate)/100),2) else round(s.tot_supply*ISNULL(@pinct_rate, s.inct_rate),2) end amount, s.doctype, s.recptdt, s.recptno, s.bilagcd, s.bildpcd,
                created_by, created_date, updated_by, updated_date,tran_type 
        from cir_inct_process_det_temp s,cir_edtn_mast e 
        where s.comp_code=@pcompcode and s.comp_code=e.comp_code and s.unit_code=@punitcode and 
            s.bilagcd=@pagcode and s.bildpcd= @pdepocode and s.recptno=@precptno and s.recptdt=@precptdt and 
            s.publ_code=e.publ and s.edtn_code=e.edtn and e.main_edtn=@pedtncode and s.tran_type='INC';
            
    If @pdoctype is null or @pdoctype='' Begin
        set @v_doctype='CN'
    End    
    Else Begin
        set @v_doctype=@pdoctype
    End
        
   set @v_amt=0

   open c2
		fetch NEXT FROM c2 INTO @v2_comp_code,@v2_unit_code,@v2_doctype,@v2_tot_supply,@v2_recptdt,@v2_recptno,@v2_amount,@v2_bilagcd,@v2_bildpcd 
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
        select @v_bran_code=branch_code from cir_agmast 
            where comp_code=@v2_comp_code and unit=@v2_unit_code and agcd=@v2_bilagcd and dpcd=@v2_bildpcd;
        
        select @v_dsign=Dsign from cir_docmst where Comp_code=@pcompcode AND doc_type=@v_doctype

        If(@v_dsign=-1) Begin
            set @v_amt=@v2_amount*@v_dsign
        End    
        Else Begin
            set @v_amt=@v2_amount*@v_dsign
        End
        
        If @premark is null or @premark='' Begin
            set @v_remark='Being amount auto credited against incentive charges'
        End    
        Else Begin
            set @v_remark=@premark
        End

		SELECT @v_rec_no  =  CAST( MAX(SUBSTRING(recptno, 5, 8))AS NUMERIC) + 1
		FROM  cir_rcphdr 
		WHERE comp_code  = @pcompcode AND doctype  = @pdoctype
		AND CONVERT(VARCHAR(23), recptdt) = CONVERT(VARCHAR(23), @v2_recptdt) AND branch_code  = @v_bran_code
		
		IF ISNULL(@v_rec_no, 0)= 0 BEGIN 
			SET @v_recptno  = @v_bran_code + '-' + REPLACE(CONVERT(VARCHAR(5), GETDATE(), 2), '.', '')+ '0001' 
		END
		ELSE BEGIN 
			SET @v_recptno  = @v_bran_code + '-' + dbo.fnPadLeft('0',8,@v_rec_no) 
		END
    
          insert into cir_rcphdr(comp_code,unit_code,agcd,dpcd,doctype,
                                 recptno,recptdt,amount,reason,remark,
                                 achd,voucherno,voucherdt,userid,creation_date,branch_code)
                          values(@v2_comp_code, @v2_unit_code,@v2_bilagcd, @v2_bildpcd,@v2_doctype,
                                 @v_recptno,@v2_recptdt,@v_amt,isnull(@preason,'INCENTIVE CHARGES'),@v_remark,
                                 'NM',@v_recptno,@v2_recptdt,@puserid,getdate(),@v_bran_code)
          insert into cir_rcpdet(comp_code,unit_code,agcd,dpcd,doctyp,publ,
                                 recptno,recptdt,payfor,achd,amount,
                                 reason,remark,voucherno,voucherdt,usrid,
                                 creation_date,branch_code)
                          values(@v2_comp_code, @v2_unit_code,@v2_bilagcd, @v2_bildpcd,@v2_doctype,@ppublcode,
                                 @v_recptno,@v2_recptdt,@v2_unit_code,'NM',@v_amt,
                                 isnull(@preason,'INCENTIVE CHARGES'),@v_remark,@v_recptno,@v2_recptdt,@puserid,
                                 getdate(),@v_bran_code);
          insert into cir_outmast(comp_code,unit_code,agcd,dpcd,doctyp,publ,
                                  recptno,recptdt,achd,amount,reason,
                                  remark,voucherno,voucherdt,usrid,creation_date,branch_code)
                           values(@v2_comp_code, @v2_unit_code,@v2_bilagcd, @v2_bildpcd,@v2_doctype,@ppublcode,
                                  @v_recptno,@v2_recptdt,'NM',@v_amt,isnull(@preason,'INCENTIVE CHARGES'),
                                  @v_remark,@v_recptno,@v2_recptdt,@puserid,getdate(),@v_bran_code)                               
        
          update cir_inct_process_det set recptno=@v_recptno
            where comp_code=@v2_comp_code and unit_code=@v2_unit_code and doctype=@v2_doctype and recptno=@precptno and 
                  recptdt=@v2_recptdt and from_pdate >= @pdatefrom and till_pdate <= @pdatetill and bilagcd = @v2_bilagcd and bildpcd = @v2_bildpcd
                   and publ_code=@ppublcode and tran_type='INC'
                  
       fetch NEXT FROM c2 INTO @v2_comp_code,@v2_unit_code,@v2_doctype,@v2_tot_supply,@v2_recptdt,@v2_recptno,@v2_amount,@v2_bilagcd,@v2_bildpcd       
   End
   close c2;
	deallocate c2

	delete from cir_inct_process_det_temp where comp_code=@pcompcode and unit_code=@punitcode and 
            bilagcd=@pagcode and bildpcd= @pdepocode and recptno=@precptno and recptdt=@precptdt  and 
            publ_code=@ppublcode and tran_type='INC';
            
   select getdate() as "CUR_DATE" 
   
End




/***********************mimoh 14dec 2011*********************************billing****************/

ALTER PROCEDURE [dbo].[cir_publ_bind_cir_publ_bind_p1]
	@pcomp_code                               VARCHAR(40) ,
	@ppubl_code                               VARCHAR(40) ,
	@pdateformat                              VARCHAR(40) ,
	@pextra1                                  VARCHAR(400) ,
	@pextra2                                  VARCHAR(40) --for publication type
AS 
	select cir_publ_mast.*,dbo.cir_get_publ_type(cir_publ_mast.comp_code,cir_publ_mast.publ,null,null) as "PUBL_TYPE_NAME" 
	from cir_publ_mast 
	WHERE comp_code  = @pcomp_code AND 
	(publ  = @ppubl_code OR	@ppubl_code  is null OR	@ppubl_code='')
	AND ((UPPER(publ_name)  like UPPER(@pextra1) + '%') OR	(@pextra1  is null) OR	(@pextra1='')) 
	AND (upper(pro_type)=@pextra2 or @pextra2 is null or @pextra2='')
order by publ_name

/***********************mimoh 14-dec-2011*********************************billing****************/
/**********************Laxman 14-dec-2011***********************/
CREATE FUNCTION cir_get_agency_opening(
    @pcomp_code  as  varchar(20),
    @punit_code  as  varchar(20),
    @ppubl_code  as  varchar(20),
    @pagcd       as  varchar(20),
    @pdpcd       as  varchar(20),
    @pason_date  as  datetime,
    @pac_type    as  varchar(20),
    @pdateformat as  varchar(20),
    @puserid     as  varchar(20),
    @pextra1     as  varchar(200),
    @pextra2     as  varchar(200)) returns numeric(15,2) as


Begin
    declare @v_findt     datetime
    declare @v_ason      datetime
    declare @v_opbal     numeric(15,2)
    declare @v_amt       numeric(15,2)
    
    set @v_ason      =@pason_date       
    set @v_findt     =dbo.cir_get_finandt(@pcomp_code,@pason_date,@pdateformat,'','');--for financial date
    
    set @v_opbal     =dbo.cir_accounts_cir_agency_opbal(@pcomp_code,@punit_code,@ppubl_code,@pagcd,@pdpcd,@v_findt,@pac_type,@pdateformat,null,null);
    
    set @v_amt       =dbo.cir_accounts_cir_agency_ytodt(@pcomp_code,@punit_code,@ppubl_code,@pagcd,@pdpcd,@v_findt,@v_ason,@pac_type,@pdateformat,null,null);
    
    return isnull(@v_opbal,0)+isnull(@v_amt,0)
End


ALTER PROCEDURE cir_execute_unsoldapr_per_P(
    @loginid            as varchar(50)) as
begin    
  
    select distinct a.user_id user_id,b."username" as "USERNAME" 
    from cir_unsold_apr_permission a,login b 
    where a.user_id=b."userid" and (a.USER_ID=@loginid OR @loginid IS NULL or @loginid='') 

End 
/**********************Laxman 14-dec-2011***********************/
///////////////////////////garima 14 -dec-2011////////////////
create procedure cir_websp_permission
(
@pcomp_code as varchar(50),
@puser_id as varchar(50),
@pform_name as  varchar(50),
@pextra1 as varchar(50),
@pextra2 as varchar(50)

)

as 

select * from userpermission where COMM_CODE=@pcomp_code and USERID=@puser_id
AND PERMISSION_DESC=@pform_name

////////////////////////////////////////////////////end by Garima



/***********************mimoh 14-dec-2011*********************************5933****************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



















ALTER PROCEDURE [dbo].[currbindpreferpgld]
@compcode as varchar(8)

AS

/*select date_format,autogenerated,currency_code,rate_gr_code,solo,breakup,blackwhitecode,rostatus,File_name,Tfn,Insert_breakup  , prefix,suffix,financestatus,voucherst,Ad_category,Ro_datetime,Vat,Booking_status,Cio_id,Receipt_no,uom_code,Bgcolor_publication,chkfor_valid_pubdates,
Agency_ratecode,audit,book_insert_date,agencycomm,rate_audit,bill_audit,billtype,Premium_type,copy_booking,RATE_COMPANY_AGENCY,ADDITIONAL_AGENCY_COMM,AGENCY_RETAINER_COMM,SUBEDITIONRATE,CLS_BILLTYPE,DIS_BILLTYPE,BILLING_FORMAT,RATE_CHECK,ALL_PACKAGE,DAYRATE,SCHEME_TYPE,DISP_CLSBILL, RECEIPT_FORMAT ,CASH_RECEIPT_BILL, BILL_ORDERWSLAST, FLOOR_CHK,DISP_CASHBILL, CLA_CASHBILL,RATE_AUDIT_PREF ,  FMG_BILL_DIS,BARCODING_ALLOWED,BILL_DISP_CASHBILL,BILL_CLA_CASHBILL ,BACKDATERECEIPT,ROWISE_CASHBOOKING from preferrences where comp_code=@compcode
*/

  SELECT date_format, autogenerated, currency_code,
                rate_gr_code, solo, breakup, blackwhitecode,
                rostatus, File_name, Tfn, Insert_breakup, prefix,
                suffix, financestatus, voucherst, Ad_category,
                Ro_datetime, Vat, Booking_status, Cio_id,
                Receipt_no,uom_code,Bgcolor_publication,chkfor_valid_pubdates,Agency_ratecode,audit,book_insert_date,agencycomm,
                rate_audit,bill_audit,billtype,Premium_type,copy_booking,RATE_COMPANY_AGENCY,ADDITIONAL_AGENCY_COMM,AGENCY_RETAINER_COMM,SUBEDITIONRATE,CLS_BILLTYPE,DIS_BILLTYPE,
				BILLING_FORMAT,RATE_CHECK,ALL_PACKAGE,dayrate,SCHEME_TYPE,DISP_CLSBILL,RECEIPT_FORMAT,CASH_RECEIPT_BILL, BILL_ORDERWSLAST, FLOOR_CHK,
                ROKEYCHECK, AGENCYCOMM_SEQ_COM, CREDIT_RECIPT,  DISP_CASHBILL, CLA_CASHBILL,
				RATE_AUDIT_PREF,BARCODING_ALLOWED, FMG_BILL_DIS,BILL_DISP_CASHBILL, BILL_CLA_CASHBILL,BACKDATERECEIPT,ROWISE_CASHBOOKING,CUTOFFTIME,DOCKIT_BOOKING,APPROVAL,back_days as BACK_DAYS,CASH_DISCOUNT,CASH_DISCOUNTTYPE,Allowed_old_date,SEPRATE_CASHIER,
                CIR_MANY_TIME_POSTING, CIR_BACKDAYS_POSTING, CIR_MAX_RETURN_ALLOW, CIR_RETURN_LIMIT_ALLOW, CIR_NO_OF_CHQBOUNCE, CIR_DAYS_CHQBOUNCE, CIR_RETURN_DAYS, CIR_SUP_ORDER_LIMIT, DISP_BILLING_CRITERIA, CLSD_BILLING_CRITERIA,MAX_PUBLISHDAYS,BILLNO_PERIODICITY, SPECIALDISC_TRANS_EDIT, SHARING_TRANS, MULTIPACKAGE_SEL_TRANS,SCHEME_MINWORD, TRADE_SPLCHARGE,RATE_AUTHORIZATION,F2_RECORD,PUBLISHAD_EDIT_RATEAUDIT,BINDREVENUE_CENTER, FA_LEDGER_ALLOW,CLEARANCE_TYPE_ALLOW,REPEAT_DAY_TYPE,PREMIUM_EDIT,
BILL_GENERATION_PRIOR,PUBLICATION_HO,SPLDISC_ALLOWPREM,BILL_SCHEME,
ALLOWED_PDC_DAYS_RECEIPT,AD_TYPE_MANUL_BILL, OUTSTANDING_AMT_CRITERIA as RO_OUTSTAND,GENRATE_CIR_AGCD,DISP_AUDITBKG,CIR_DIS_AUTO_POSTING,RELAUTHREQON,
CIR_AUTO_APPROVAL_UNSOLD, CIR_AUTO_PHYSICAL_UNSOLD, CIR_UNSOLD_INCLUDE_INCT, CIR_UNSOLD_INCLUDE_INSFEE, CIR_UNSOLD_ON_RECEIVED_DT,AGENCY_UNBLOCK_APPROVAL,UNBLOCK_APPROVAL_OUTSIDE_LIMIT,CIR_BILL_PUBLWISE
           FROM PREFERRENCES
          WHERE comp_code = @compcode




























/**************************************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go





ALTER PROCEDURE   [dbo].[wesp_updatedate1]

@compcode as varchar(15),
@userid as varchar(15),
@dateformat as varchar(15),
@code as varchar(4),
@curr as varchar(8),
@ratecode as varchar(8),
@solo as varchar(15),
@breakup as varchar(2),
@bwcode as varchar(8),
@rostatus as varchar(2),
@filename as varchar(2),
@tfn as VARCHAR(4),
@insertbreak as varchar(2),
@prem as varchar(8),
@dealtype as varchar(2),
@pre as varchar(5),
@suff as varchar(5),
@financestatus as  char(2),
@voucherst as varchar(30),
@adcode as varchar(100),
@rodatetime as varchar(8),
@spacearea as varchar(8),
@vat as varchar(50),
@bookstat as varchar(25),
@cio_id as varchar(8),
@receipt_no as varchar(50),
@uom as varchar(8),
@bgcolor as varchar(10),
@validdate as varchar(10),
@agencyratecode as varchar(10),
@audit as varchar(8),
@book_insert_date as varchar(8),
@agencycomm as varchar(8),
@rateaudit as varchar(8),
@billaudit as varchar(8),
@billtype as varchar(8),
@invoice_no as varchar(50),
@copybooking as varchar(8),
@ratecompany as varchar(50),
@addagenycomm as varchar(50),
@agencycommlinkretainer as varchar(50),
@subeditionr as varchar(50),
@displaybilltype as varchar(50),
@classifiedbilltype as varchar(50),
@billformat as varchar(50),
@ratechk as varchar(50),
@allpkg as varchar(50),
@dayrate1 as varchar(50),
@schemetype as varchar(50),
@PIncludeclassi as varchar(50),
@receiptformat as varchar(50),
@cash_receipt as varchar(50),
@bill_orderwiselast as varchar(50),
@floor_chk as varchar(50),
@Unsoldflag as varchar(1),
@Supplystopper as varchar(10),
@drpRokeychk as varchar(1),
@Agencycomm_seq as varchar(1),
@creditreciept as varchar(1),
@cashindisplay as varchar(8),
@cashinclassified as varchar(8),
@rate_audit_pref as varchar(25),
@v_barcoding_allow as varchar(25),
@v_fmgbills AS VARCHAR(25),
@v_billed_cashdis as varchar(25),
@v_billed_cashcls as varchar(25),
@v_drpbackdate as varchar(25),
@dockitbooking as varchar(1),
@allowprevbooking as varchar(1),
@ro_wisecashbill as varchar(50),
@chkval as varchar(5),
@approval1 as varchar(50),
@pckstatus as varchar(3),
@cash_disc as varchar(1),
@cash_amt as varchar(10),
@seperate_cashier1 as varchar(10),
@disp_bill as varchar(1),
@clas_bill as varchar(1),
@mantimepost as varchar(1),
@bkdaypost as int,
@maxterutn as int,
@cir_return as varchar(1),
@noofchkbounc as int,
@noofdaychkrec as int,
@retday as int,
@chngsuppord as int,
@max_publishday as int,
@p_billno_period as varchar(15),
@spl_trans_edit as varchar(5),
@spl_dis_trans_editable as varchar(5),
@mul_pac_sel_trans as varchar(5),
@shmon_minword	as varchar(1),
@tradon_spcrg	as varchar(1),
@rateauth       as varchar(1),
@f2day as int,
@rateauditmodify as varchar(1),
@bindrevenuecenter as varchar(1),
@p_led_allow as varchar(2),
@p_clear_allow as varchar(2),
@repeatday as varchar(2),
@premiumedit as varchar(2),
@P_BILL_GENERATION as varchar(20),
@P_PUBLICATION_CENTER as varchar(50),
@P_allow_discount_prem as varchar(1),
@P_SCHEME_BILLING as varchar(50),
@P_ALLOW_PDC as varchar(50),
@PAD_TYPE_FOR_MANUL_BILL AS VARCHAR(20),
@RO_OUTSTAND_P AS VARCHAR(5),
@genrate_agency_code AS VARCHAR(5),
@p_dispauditbk AS VARCHAR(5),
@p_aotosupply  AS VARCHAR(5),
@p_Authorization as VARCHAR(1),
@p_CIR_AUTO_APPROVAL_UNSOLD AS VARCHAR(5),
@p_CIR_AUTO_PHYSICAL_UNSOLD AS VARCHAR(5),
@p_CIR_UNSOLD_INCLUDE_INCT AS VARCHAR(5),
@p_CIR_UNSOLD_INCLUDE_INSFEE AS VARCHAR(5),
@p_CIR_UNSOLD_ON_RECEIVED_DT AS VARCHAR(5),
@p_AGENCY_UNBLOCK_APPROVAL AS VARCHAR(5),
@p_UNBLOCK_APPROVAL_OUTSIDE_LIMIT AS VARCHAR(5),
@p_CIR_BILL_PUBLWISE AS VARCHAR(5)


AS
declare @query as varchar(8000)
declare @query1 as varchar(8000)
/*
set @query='update login set date_format='''+@dateformat+''' , Autogenerate='''+@code+''',curr_code='''+@curr+''' where com_code='''+@compcode+'''   '
exec(@query)

set @query1='update preferrences set RATE_COMPANY_AGENCY='''+@ratecompany+''',ADDITIONAL_AGENCY_COMM='''+@addagenycomm+''',
AGENCY_RETAINER_COMM='''+@agencycommlinkretainer+''',SUBEDITIONRATE='''+@subeditionr+''',DIS_BILLTYPE='''+@displaybilltype+''',
CLS_BILLTYPE='''+@classifiedbilltype+''',autogenerated='''+@code+''',currency_code='''+@curr+''' ,rate_gr_code='''+@ratecode+''' , 
date_format='''+@dateformat+''',solo='''+@solo+''',breakup='''+@breakup+''' ,blackwhitecode='''+@bwcode+''',  rostatus='''+@rostatus+''',
File_name='''+@filename+''',Tfn='''+@tfn+''',Insert_breakup='''+@insertbreak+''',Premium_type='''+@prem+''',Deal_type='''+@dealtype+'''  ,    
prefix='''+@pre+''', suffix='''+@suff+'''  ,     financestatus='''+ @financestatus+''' , voucherst='''+@voucherst+''',Ad_category='''+@adcode+''' ,
Ro_datetime='''+@rodatetime+''' ,Space_area='''+@spacearea+''',Vat='''+@vat+''' ,Booking_status='''+@bookstat+''' ,Cio_id='''+@cio_id+''',
Receipt_no='''+@receipt_no+''' ,uom_code='''+@uom+''',Bgcolor_publication='''+@bgcolor+''' ,chkfor_valid_pubdates='''+@validdate+''', 
Agency_ratecode='''+@agencyratecode+''',   audit='''+@audit+''', book_insert_date='''+@book_insert_date+''',agencycomm='''+@agencycomm+''',
rate_audit='''+@rateaudit+''',bill_audit='''+@billaudit+''', billtype='''+@billtype+''', invoice_no='''+@invoice_no+''' , 
copy_booking='''+@copybooking+''', BILLING_FORMAT='''+@billformat+''' , RATE_CHECK='''+@ratechk+''', ALL_PACKAGE='''+@allpkg+''',
DAYRATE='''+@dayrate1+''' ,SCHEME_TYPE='''+@schemetype+'''    ,DISP_CLSBILL='''+@PIncludeclassi+ '''  , RECEIPT_FORMAT ='''+@receiptformat+''',
CASH_RECEIPT_BILL='''+@cash_receipt+''', BILL_ORDERWSLAST='''+@bill_orderwiselast+''',FLOOR_CHK='''+@floor_chk+''' ,
Unsold_Entry_Flag='''+@Unsoldflag+''' ,Supply_Stop_Percentage='''+@Supplystopper+''',ROKEYCHECK='''+@drpRokeychk+''',
AGENCYCOMM_SEQ_COM='''+@Agencycomm_seq+''' ,CREDIT_RECIPT='''+@creditreciept+''',DISP_CASHBILL='''+@cashindisplay+''',
CLA_CASHBILL='''+@cashinclassified+''',RATE_AUDIT_PREF='''+@rate_audit_pref+''',BARCODING_ALLOWED='''+@v_barcoding_allow+''', 
FMG_BILL_DIS='''+@v_fmgbills+''',BILL_DISP_CASHBILL='''+@v_billed_cashdis +''',BILL_CLA_CASHBILL ='''+@v_billed_cashcls+''',
BACKDATERECEIPT='''+@v_drpbackdate+''',DOCKIT_BOOKING='''+@dockitbooking+''',Allowed_old_date='''+@allowprevbooking+''',
ROWISE_CASHBOOKING='''+@ro_wisecashbill+''' where    comp_code='''+@compcode+'''   ' 
*/
/*********************************************************************************************************/
UPDATE LOGIN SET date_format=@dateformat, Autogenerate=@code,curr_code=@curr WHERE COM_CODE=@compcode

UPDATE PREFERRENCES SET  autogenerated=@code,
currency_code=@curr ,
rate_gr_code=@ratecode,
date_format=@dateformat,solo=@solo,breakup=@breakup,
blackwhitecode=@bwcode,rostatus=@rostatus,File_name=@filename,Tfn=@tfn,
Insert_breakup=@insertbreak,Premium_type=@prem,Deal_type=@dealtype  ,
 prefix=@pre, suffix=@suff, financestatus=@financestatus , voucherst=@voucherst,
 Ad_category=@adcode ,Ro_datetime=@rodatetime ,Space_area=@spacearea,Vat=@vat,
 Booking_status=@bookstat,Cio_id=@cio_id,Receipt_no=@receipt_no,uom_code=@uom,
 Bgcolor_publication=@bgcolor ,chkfor_valid_pubdates=@validdate, Agency_ratecode=@agencyratecode,
  audit=@AUDIT,book_insert_date=@book_insert_date,agencycomm=@agencycomm,
  rate_audit=@rateaudit,bill_audit=@billaudit,billtype=@billtype,invoice_no=@invoice_no,
  copy_booking=@copybooking,RATE_COMPANY_AGENCY=@ratecompany, ADDITIONAL_AGENCY_COMM=@addagenycomm ,
  AGENCY_RETAINER_COMM=@agencycommlinkretainer,SUBEDITIONRATE=@subeditionr,
  CLS_BILLTYPE=@classifiedbilltype,DIS_BILLTYPE=@displaybilltype,BILLING_FORMAT=@billformat,
  RATE_CHECK=@ratechk,ALL_PACKAGE=@allpkg,dayrate=@dayrate1,SCHEME_TYPE=@schemetype,DISP_CLSBILL=@PIncludeclassi   ,
  CASH_RECEIPT_BILL=@cash_receipt, BILL_ORDERWSLAST=@bill_orderwiselast, FLOOR_CHK=@floor_chk ,
  Unsold_Entry_Flag=@Unsoldflag ,Supply_Stop_Percentage=@Supplystopper,ROKEYCHECK=@drpRokeychk ,
  AGENCYCOMM_SEQ_COM=@Agencycomm_seq ,CREDIT_RECIPT=@creditreciept,DISP_CASHBILL=@cashindisplay,
  CLA_CASHBILL=@cashinclassified,RATE_AUDIT_PREF=@rate_audit_pref,BARCODING_ALLOWED=@v_barcoding_allow,
  FMG_BILL_DIS =@v_fmgbills, BILL_DISP_CASHBILL=@v_billed_cashdis , BILL_CLA_CASHBILL=@v_billed_cashcls,BACKDATERECEIPT=@v_drpbackdate,DOCKIT_BOOKING=@dockitbooking,Allowed_old_date=@allowprevbooking,ROWISE_CASHBOOKING=@ro_wisecashbill,CUTOFFTIME=@chkval,APPROVAL=@approval1,back_days=@pckstatus,CASH_DISCOUNT=@cash_amt,CASH_DISCOUNTTYPE=@cash_disc,SEPRATE_CASHIER=@seperate_cashier1,
 CIR_MANY_TIME_POSTING=@mantimepost, CIR_BACKDAYS_POSTING=@bkdaypost, CIR_MAX_RETURN_ALLOW=@maxterutn, CIR_RETURN_LIMIT_ALLOW=@cir_return, CIR_NO_OF_CHQBOUNCE=@noofchkbounc, CIR_DAYS_CHQBOUNCE=@noofdaychkrec, CIR_RETURN_DAYS=@retday, CIR_SUP_ORDER_LIMIT=@chngsuppord, DISP_BILLING_CRITERIA=@disp_bill, CLSD_BILLING_CRITERIA=@clas_bill,MAX_PUBLISHDAYS=@max_publishday,
 BILLNO_PERIODICITY=@p_billno_period,SPECIALDISC_TRANS_EDIT=@spl_trans_edit, SHARING_TRANS=@spl_dis_trans_editable, MULTIPACKAGE_SEL_TRANS=@mul_pac_sel_trans,SCHEME_MINWORD=@shmon_minword, TRADE_SPLCHARGE=@tradon_spcrg,RATE_AUTHORIZATION=@rateauth
  ,F2_RECORD=@f2day,PUBLISHAD_EDIT_RATEAUDIT=@rateauditmodify,BINDREVENUE_CENTER=@bindrevenuecenter,
FA_LEDGER_ALLOW=@p_led_allow,CLEARANCE_TYPE_ALLOW=@p_clear_allow,REPEAT_DAY_TYPE=@repeatday,PREMIUM_EDIT=@premiumedit,

BILL_GENERATION_PRIOR=@P_BILL_GENERATION,PUBLICATION_HO=@P_PUBLICATION_CENTER,

SPLDISC_ALLOWPREM=@P_allow_discount_prem,BILL_SCHEME=@P_SCHEME_BILLING,

ALLOWED_PDC_DAYS_RECEIPT=@P_ALLOW_PDC,AD_TYPE_MANUL_BILL=@PAD_TYPE_FOR_MANUL_BILL,OUTSTANDING_AMT_CRITERIA=@RO_OUTSTAND_P,GENRATE_CIR_AGCD=@genrate_agency_code,DISP_AUDITBKG=@p_dispauditbk,CIR_DIS_AUTO_POSTING=@p_aotosupply,RELAUTHREQON=@p_Authorization,
CIR_AUTO_APPROVAL_UNSOLD=@p_CIR_AUTO_APPROVAL_UNSOLD,CIR_AUTO_PHYSICAL_UNSOLD=@p_CIR_AUTO_PHYSICAL_UNSOLD,CIR_UNSOLD_INCLUDE_INCT=@p_CIR_UNSOLD_INCLUDE_INCT,
CIR_UNSOLD_INCLUDE_INSFEE=@p_CIR_UNSOLD_INCLUDE_INSFEE,CIR_UNSOLD_ON_RECEIVED_DT=@p_CIR_UNSOLD_ON_RECEIVED_DT,AGENCY_UNBLOCK_APPROVAL=@p_AGENCY_UNBLOCK_APPROVAL,UNBLOCK_APPROVAL_OUTSIDE_LIMIT=@p_UNBLOCK_APPROVAL_OUTSIDE_LIMIT,CIR_BILL_PUBLWISE=@p_CIR_BILL_PUBLWISE
 WHERE comp_code=@compcode




/* ,
',Unsold_Entry_Flag='''+@Unsoldflag+''',Supply_Stop_Percentage='''+@Supplystopper+'''

,ROKEYCHECK='''+@drpRokeychk+''',AGENCYCOMM_SEQ_COM='''+@Agencycomm_seq+''' ,CREDIT_RECIPT='''+@creditreciept+''' where    comp_code='''+@compcode+'''   ' 



--,DISP_CASHBILL='''+@cashindisplay+''',CLA_CASHBILL='''+@cashinclassified+'''
*/

print(@query1)
exec(@query1)











/***********************mimoh 14-dec-2011*********************************5933****************/

/***********************mimoh 15-dec-2011*********************************0005948****************/
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[Cir_Gen_Code_race_code_p]
	@pcompcode                                VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
	DECLARE @vno          INT 
	DECLARE @v_no         varchar(20) 

	SELECT @vno  =  isnull(MAX(substring(race_code,3,6)),0) + 1 FROM  cir_race_mast 
	SET @v_no=RIGHT('0000' + CONVERT(VARCHAR,@vno), 3)
	SELECT 'RC'+@v_no AS "VAR_CODE"



/***********************mimoh 15-dec-2011*******************************0005948****************/

/*************************** 5886 ritu*************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[cir_exe_unsold_apr_grid_P](
@loginid            as varchar(50)) as
begin    
SELECT * FROM cir_unsold_apr_permission 
	WHERE (user_id = @loginid OR @loginid IS NULL OR @loginid='');

SELECT "Branch_Code", "Branch_Name" FROM branch_mst
ORDER BY "Branch_Name"

SELECT "Comp_Code", "Comp_Name" FROM comp_mst
ORDER BY "Comp_Name"

SELECT "doc_type", "doc_Name" FROM fa_docmst 
	WHERE "doc_type" IN ('RCR', 'DN', 'CN') ORDER BY "doc_Name"

SELECT MAX (insert_id) AS "INSERT_ID" FROM cir_unsold_apr_permission
	WHERE (user_id = @loginid OR @loginid IS NULL OR @loginid='')

End 



/******************************************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER  procedure [dbo].[cir_unit_doc_com_bind](
@pcompcode as varchar(50)
)  AS
  Begin
    
                select  "Branch_Code","Branch_Name" from branch_mst order by  "Branch_Name";

            
                select  "Comp_Code","Comp_Name" from comp_mst order by "Comp_Name";
                
                select  DOC_TYPE "doc_type",DOC_NAME "doc_Name" from cir_docmst where DOC_TYPE in ('RCR','DN','CN') order by DOC_NAME;
             
  end

/*******************************************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[cir_execute_unsoldapr_per_P](
    @loginid            as varchar(50)) as
begin    
  
    select distinct a.user_id as "USER_ID",b."username" as "USERNAME" 
    from cir_unsold_apr_permission a,login b 
    where a.user_id=b."userid" and (a.USER_ID=@loginid OR @loginid IS NULL or @loginid='') 

End 


/****************************************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[cir_login_bind_p]
	@plogin_code                              VARCHAR(4000) ,
	@pdateformat                              VARCHAR(4000) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
	
		SELECT *
		FROM  login 
		WHERE	 (userid  = @plogin_code
		 OR	@plogin_code  is null  OR	@plogin_code = '')
		ORDER BY username 
		


/*******************************************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[websp_pubcenter_newnew] 
@pextra1 as varchar(4000)

 AS
select Pub_cent_Code,pub_cent_name + '(' +city_name + ')' as center from 
pub_cent_mast,city_mst where city_mst.city_code=pub_cent_mast.city_code and 
 isnull(PUB_CENT_MAST.PRINT_CENT,'Y') != 'N' and 
(pub_cent_name like @pextra1+'%' or @pextra1 is null )
ORDER BY "center"

select agency_name,code_subcode from agency_mast  ORDER BY Agency_Name;




select * from login





//************************** 5886 for region **************//

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[cir_zone_region_bind]
    @pcompcode       as varchar(20),
    @pzonecode       as varchar(20),
    @preg_code       as varchar(20),
    @pdateformat     as varchar(20),
    @puserid         as varchar(20),
    @pextra1         as varchar(20),
    @pextra2         as varchar(20)
as

begin
	declare @v_str		varchar(4000)
    declare @v_zonecode varchar(1000)
    print(@pzonecode)
    If @pzonecode is not null or @pzonecode<>'' Begin
        set @v_zonecode=''''+replace(@pzonecode,',',''',''')+''''
    End
    
    If @pzonecode is null or @pzonecode='' Begin
		set @v_str='select cir_region_mast.*,dbo.cir_get_zone_name(cir_region_mast.comp_code,cir_region_mast.zone_code) zone_name 
		from cir_region_mast 
		where comp_code='+''''+@pcompcode+''''+' and  
        (cir_region_mast.reg_code ='+''''+@preg_code+''''+' or '+''''+@preg_code+''''+' is null)            
		order by zone_name,cir_region_mast.reg_code'
	End	
    Else Begin
print ('rinki')
print (@preg_code)
		set @v_str='select cir_region_mast.*,dbo.cir_get_zone_name(cir_region_mast.comp_code,cir_region_mast.zone_code) zone_name 
		from cir_region_mast 
		where comp_code='+''''+@pcompcode+''''+' and zone_code in ('+@v_zonecode+')
        order by zone_name,cir_region_mast.reg_code'

/* (cir_region_mast.reg_code ='+''''+@preg_code+''''+' or '+''''+@preg_code+''''+' is NULL ) */         
        print (@v_str)
   End            
print(@v_str)
exec (@v_str)
End


select * from cir_region_mast 

/****************************************3/01/12*********************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION  [dbo].[cir_get_edtn_name] (@pcomp_code as varchar(100),@pedtn as varchar(100))  returns varchar(200)

AS  

BEGIN 
DECLARE @vedtn_name VARCHAR(4000)
select @vedtn_name=edtn_name from cir_edtn_mast where comp_code=@pcomp_code and edtn=@pedtn
	   
RETURN isnull(@vedtn_name,'')
END


/**************************************************************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION  [dbo].[cir_get_publ_name] (@pcomp_code as varchar(100),@ppubl as varchar(100))  returns varchar(200) 

AS  

BEGIN 
DECLARE @vpubl_name VARCHAR(4000)
select @vpubl_name=publ_name from cir_publ_mast where comp_code=@pcomp_code and publ=@ppubl
	   
RETURN isnull(@vpubl_name,'')
END

/*************************************************************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION  [dbo].[cir_get_zone_name](@pcomp_code  varchar(100),@pzone_code  varchar(100)) RETURNs char(400) 
AS
	Begin

        DECLARE @vzone_name VARCHAR(400)
        select @vzone_name=zone_desc  from cir_zone_mast 
      	where comp_code=@pcomp_code and zone_code=@pzone_code;
 
	
  return isnull(@vzone_name,'')
END

/**************************************************************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[cir_get_region_name](@pcomp_code AS varchar(20),@pregion_code AS varchar(20)) RETURNs varchar(200) AS

BEGIN
DECLARE @vreg_name VARCHAR(200)

select @vreg_name=reg_desc from cir_region_mast where comp_code=@pcomp_code and reg_code=@pregion_code

	return ISNULL(@vreg_name,'NA')
END

/*******************************************************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION  [dbo].[cir_get_edtn_name] (@pcomp_code as varchar(100),@pedtn as varchar(100))  returns varchar(200)

AS  

BEGIN 
DECLARE @vedtn_name VARCHAR(4000)
select @vedtn_name=edtn_name from cir_edtn_mast where comp_code=@pcomp_code and edtn=@pedtn
	   
RETURN isnull(@vedtn_name,'')
END

/*************************************************************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[cir_branch_detail_p]
     @pcompcode          VARCHAR(40) ,
     @pbrancode          VARCHAR(40) ,
     @plangtype          VARCHAR(40) ,---1 for enlish and 2 for other language
     @pdateformat        VARCHAR(40) ,
     @pextra1            VARCHAR(400) ,
     @pextra2            VARCHAR(400) 


  As


  
        select branch_mst.*,(select distinct City_Name from city_mst where City_Code=branch_mst.City_Code) CITY_NAME,
        (SELECT distinct Country_Name FROM count_mst where Country_Code=branch_mst.Country_Code) COUNTRY_NAME from branch_mst 
        where (Branch_Code=@pbrancode or @pbrancode is null or @pbrancode = '')
        order by Comp_Code,Branch_Name;

  
/****************************************************************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
 ALTER Procedure [dbo].[cir_pcenter_detail_p]
     @pcompcode           VARCHAR(20),
     @ppcenter           VARCHAR(20),
     @plangtype           VARCHAR(20),  ---1 for enlish and 2 for other language
     @pdateformat         VARCHAR(20),
     @pextra1             VARCHAR(200),
     @pextra2            VARCHAR(200)


  As
  
       
        select TOP 1 * from pub_cent_mast where /*"Comp_Code"=pcompcode  and*/
        (Pub_cent_Code=@ppcenter or @ppcenter is null or @ppcenter = '') 
        order by "Comp_Code";

 
/****************************************end************************************/


/*************************************************/
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER procedure [dbo].[cir_fetch_incentive_data_p]
    @pcompcode       AS varchar(20),
    @punitcode       AS varchar(20),
    @pagtype         AS varchar(20),
    @pagclass        AS varchar(20),
    @psup_type       AS varchar(20),
    @pagcode         AS varchar(20),
    @pdepocode       AS varchar(20),
    @pcode           AS varchar(2000),
    @pprocesstype    AS varchar(20),--process by Zone.Region,Branch,District,Route
    @pdatefrom       AS datetime,
    @pdatetill       AS datetime,
    @pinct_type      AS varchar(20),--for supply or growth
    @pprocess_type   AS varchar(20),--for daily,weekly or monthly
    @psupply_days    AS numeric(5),--for auto or manual
    @pprocessid      AS numeric(30),
    @pdelimiter      AS varchar(20),
    @puserid         AS varchar(20),
    @pdateformat     AS varchar(20),
    @pextra1         AS varchar(200),
    @pextra2         AS varchar(200),
    @pextra3         AS varchar(200),
    @pextra4         AS varchar(200),
    @pextra5         AS varchar(200)
  As
	If @punitcode='' Begin
		set @punitcode=null
	End	
	If @pagtype='' Begin
		set @pagtype=null
	End
	If @pagclass='' Begin
		set @pagclass=null
	End
	If @psup_type='' Begin
		set @psup_type=null
	End
	If @pagcode='' Begin
		set @pagcode=null
	End
	If @pdepocode='' Begin
		set @pdepocode=null
	End
	If @pcode='' Begin
		set @pcode=null
	End
	If @pprocesstype='' Begin
		set @pprocesstype=null
	End
	If @pinct_type='' Begin
		set @pinct_type=null
	End
	If @pprocess_type='' Begin
		set @pprocess_type=null
	End
	If @pextra1='' Begin
		set @pextra1=null
	End									
	If @pextra2='' Begin
		set @pextra2=null
	End
	If @pextra3='' Begin
		set @pextra3=null
	End									
	If @pextra4='' Begin
		set @pextra4=null
	End
	If @pextra5='' Begin
		set @pextra5=null
	End

	CREATE TABLE #CIR_LEDGER_REPORT
	( COMP_CODE			VARCHAR(100),
	  UNIT_CODE			VARCHAR(100),
	  DEBIT_HEAD		VARCHAR(100),
	  REC_SEQNO			INT)

	declare @vlength		numeric(7);
	declare @vrunval		varchar(4000);
	declare @v_val			varchar(800);
	declare @v_name			varchar(8000);
	declare @v_sname		varchar(4000);
	declare @vno			numeric(10)
	declare @v_doctype		varchar(10)
	set @v_doctype='CN'
	declare @v_recptdt		datetime
	declare @v_dt			datetime
	declare @v1_comp_code	varchar(20)
	declare @v1_unit_code	varchar(20)
	declare @v1_publ		varchar(20)
	declare @v1_edtn		varchar(20)
	declare @v1_sup_type_code	varchar(20)
	declare @v1_supdate		datetime
	declare @v1_agcd		varchar(20)
	declare @v1_dpcd		varchar(20)
	declare @v1_billagcd	varchar(20)
	declare @v1_billdpcd	varchar(20)
	declare @v1_ag_type		varchar(20)
	declare @v1_branch_code	varchar(20)
	declare @v1_sup_copy	numeric(10)
	declare	@i				int
	declare @v_sup_on_calc  numeric(8)
    declare @v_days         numeric(5)
    declare @v1_no_of_days	numeric(5)
    declare c1 cursor for
        select distinct a.comp_code comp_code,a.unit_code unit_code,a.publ publ,a.edtn edtn,a.sup_type_code sup_type_code,
        a.supdate supdate,a.agcd agcd,a.dpcd dpcd,a.billagcd billagcd,a.billdpcd billdpcd,d.ag_type ag_type,d.branch_code branch_code, 
        sum(a.sup_copy) sup_copy,count(distinct a.supdate) no_of_days
        from cir_dbksup a,cir_supply_type_mast c,cir_agmast d
        where a.comp_code = @pcompcode and a.comp_code = c.comp_code and a.comp_code = d.comp_code and 
              a.unit_code=isnull(@punitcode,a.unit_code) and a.unit_code=d.unit and  
              a.supdate >= @pdatefrom and a.supdate <=@pdatetill and a.sup_type_code =c.sup_ty_code and
              a.sup_type_code=isnull(@psup_type,a.sup_type_code) and  
              a.agcd = d.agcd and a.dpcd = d.dpcd and d.agcd = ISNULL(@pagcode,d.agcd) and d.dpcd = ISNULL(@pdepocode,d.dpcd) and 
              (d.ag_type =@pagtype or @pagtype is null) and (d.ag_class =@pagclass or @pagclass is null) and 
              ((d.dist_code in(select debit_head from #CIR_LEDGER_REPORT)) or @pcode is null) and 
              (a.billagcd is not null or a.billagcd<>'')
              group by a.comp_code,a.unit_code,a.publ,a.edtn,a.sup_type_code,a.supdate,a.agcd,a.dpcd,a.billagcd,a.billdpcd,d.ag_type,d.branch_code              
              order by a.comp_code,a.unit_code,a.supdate,a.publ,a.edtn,a.sup_type_code;
    
    declare @v_amt			numeric(15,2);
    declare @v_remark		varchar(500);
    declare @v_recptno		varchar(50);
    declare @v_dsign		numeric(5);
    
    declare @v_bran_code	varchar(20);
    declare @v_rec_no		numeric(10);  
    declare @v_unsold_copy	numeric(10);
    declare @vdistcode		varchar(4000);

    set @v_recptdt =  @pdatetill
    declare @v2_calc_type	varchar(20)
    declare @v2_inct_amt	numeric(15,2)
    declare @v2_supply_from	numeric(10)
    declare @v2_supply_till numeric(10)
    
    set @v_days=DATEDIFF(day,@pdatetill,@pdatefrom)
    
    set @v_days=@v_days+1
    /*if @pcode is not null Begin
        set @vdistcode=@pcode+','

        vlength :=null; v_val :=null; v_name:=null;vrunval :=null; vno:=null;
        v_val   :=replace(vdistcode,',',',');
        vlength :=length(v_val);vno:=1;

        for i in 1.. vlength loop
            vrunval:=substr(v_val,i,1);
            if vrunval!=',' then
                v_name:=v_name||vrunval;
            else
                insert into #CIR_LEDGER_REPORT(comp_code ,unit_code ,debit_head,credit_head,rec_seqno,sess_id)
                        values (pcompcode,punitcode,v_name,null,vno,userenv('sessionid'));
                vno:=vno+1;
                v_name:='';
            end if;
        end loop;
    end if;*/
	/*If @pcode is not null Begin 
		print('1')print(@pcode)
		set @vdistcode	= @pcode+@pdelimiter
		set @v_name		= null set @vrunval	= null set @vno		= 1
		set @v_val		= replace(@vdistcode,@pdelimiter,',')
		set @vlength	= len(@v_val) set @i = 1 
		print('2')
		WHILE @i <= @vlength Begin
			set @vrunval  = substring(@v_val, @i, 1)
			If @vrunval != ',' Begin
				set @v_name  = @v_name + @vrunval 
			End
			Else Begin 
				INSERT INTO #cir_ledger_report(comp_code,unit_code,debit_head,rec_seqno)  
				VALUES(@pcompcode,@punitcode,@v_name,@vno)  
				
				set @vno  = @vno + 1 
				set @v_name  = '' 
			End

			set @i = @i + 1
		End
	End*/
    open c1;
    fetch NEXT FROM c1 INTO @v1_comp_code, @v1_unit_code,@v1_publ,@v1_edtn,@v1_sup_type_code,@v1_supdate,@v1_agcd,@v1_dpcd,@v1_billagcd,@v1_billdpcd,@v1_ag_type,@v1_branch_code, @v1_sup_copy,@v1_no_of_days
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN

PRINT('FIRST')	
			If @psupply_days>0 Begin
				set @v_sup_on_calc=round((@v1_sup_copy/@v1_no_of_days),0)*@v_days
			End    
			else Begin
				set @v_sup_on_calc=@v1_sup_copy
			End
        
			select @v2_calc_type=calc_type,@v2_inct_amt=inct_amt,@v2_supply_from=supply_from,@v2_supply_till=supply_till
			from cir_inct_slab_temp where process_id=@pprocessid and comp_code=@v1_comp_code and unit_code=@v1_unit_code 
				and publ_code=@v1_publ and edtn_code=@v1_edtn
				and supply_type=@v1_sup_type_code and agency_type=@v1_ag_type -- and eff_date<=v1.supdate 
				and process_type=@pprocess_type and inct_type=@pinct_type 
				and ((branch_code is null or branch_code='' ) or (branch_code=@v1_branch_code))
				and @v_sup_on_calc between supply_from and supply_till


       
        If isnull(@v2_calc_type,'F')='P' Begin
			set @v_amt=(isnull(@v1_sup_copy,0)-isnull(@v_unsold_copy,0))*(isnull(@v2_inct_amt,0)/100)
        End    
        Else Begin
            set @v_amt=(isnull(@v1_sup_copy,0)-isnull(@v_unsold_copy,0))*isnull(@v2_inct_amt,0)
        End
        
        If isnull(@v_amt,0)<>0 and @v2_calc_type is not null Begin 
            insert into cir_inct_process_det_temp(comp_code,unit_code,publ_code,edtn_code,sup_type_code,from_pdate,till_pdate,
                            agcd,dpcd,tot_supply,from_supply,till_supply,inct_rate,calc_type,amount,
                            doctype,recptdt,recptno,bilagcd,bildpcd,created_by,tran_type,supply_on_calc,no_of_days)
                    values(@v1_comp_code,@v1_unit_code,@v1_publ,@v1_edtn,@v1_sup_type_code,@pdatefrom,@pdatetill,
                            @v1_agcd,@v1_dpcd,isnull(@v1_sup_copy,0),@v2_supply_from,@v2_supply_till,@v2_inct_amt,@v2_calc_type,@v_amt,
                            @v_doctype,@v_recptdt,@pprocessid,@v1_billagcd,@v1_billdpcd,@puserid,'INC',@v_sup_on_calc,@v1_no_of_days)
        End
        set @v_amt=0 set @v2_calc_type=null set @v2_inct_amt=0
		fetch NEXT FROM c1 INTO @v1_comp_code, @v1_unit_code,@v1_publ,@v1_edtn,@v1_sup_type_code,@v1_supdate,@v1_agcd,@v1_dpcd,@v1_billagcd,@v1_billdpcd,@v1_ag_type,@v1_branch_code, @v1_sup_copy,@v1_no_of_days
	End
	close c1
	deallocate c1
	

    select s.comp_code as "COMP_CODE",s.unit_code AS "UNIT_CODE",s.recptno as "RECPTNO",s.recptdt as "RECPTDT", s.bilagcd AS "AGCD",s.bildpcd AS "DPCD",m.ag_name AS "AG_NAME",
    dbo.cir_get_drop_point_name(s.comp_code,s.unit_code,m.station_code,1) as "DROP_POINT_NAME",dbo.cir_get_city(s.comp_code,m.city_code) as "CITY_NAME",
    s.doctype as "DOCTYPE",sum(s.tot_supply) as "SUPPLY",s.from_supply as "FROM_SUPPLY",s.till_supply AS "TILL_SUPPLY",
    s.publ_code as "PUBL_CODE" ,dbo.cir_get_publ_name(s.comp_Code,s.publ_code) as "PUBL_NAME",
    e.main_edtn AS "MAIN_EDTN", dbo.cir_get_edtn_name(s.comp_code,e.main_edtn) as "MAIN_EDTN_NAME",
    s.inct_rate AS "INCT_RATE",s.calc_type as "CALC_TYPE",sum(s.amount) as "AMOUNT",
    s.sup_type_code as "SUP_TYPE_CODE",dbo.cir_get_supply_name(s.comp_code,s.sup_type_code) as "SUP_TYPE_NAME",
    s.supply_on_calc as "SUPPLY_ON_CALC",s.no_of_days as "NO_OF_DAYS"
    from cir_inct_process_det_temp s,cir_agmast m,cir_edtn_mast e
    where s.comp_code=m.comp_code and s.comp_code=e.comp_code and s.edtn_code=e.edtn and 
    s.unit_code=m.unit and s.bilagcd=m.agcd and s.bildpcd=m.dpcd and s.recptno=@pprocessid and tran_type='INC'
    group by s.comp_code,s.unit_code,s.recptno,s.recptdt,s.doctype,s.inct_rate,s.calc_type,s.from_supply,s.till_supply,
    e.main_edtn,s.bilagcd,s.bildpcd,m.station_code,m.city_code,m.ag_name,s.sup_type_code,s.publ_code,
    s.supply_on_calc ,s.no_of_days
    having sum(amount)>0
    order by comp_code,unit_code,bilagcd,bildpcd,publ_name,main_edtn_name,sup_type_name
	
	delete from cir_inct_slab_temp where process_id=@pprocessid;      
	drop table #cir_ledger_report



////////////////////////////////////////////
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER procedure [dbo].[cir_fetch_incentive_rate]
    @pcompcode       as varchar(50),
    @punitcode       as varchar(50),
    @ppublcode       as varchar(50),
    @psupply_type    as varchar(50),
    @pagency_type    as varchar(50),
    @pinct_type      as varchar(50),
    @pfreg_type      as varchar(50),   
    @pchkdate        as datetime, 
    @puserid         as varchar(50), 
    @pdateformate    as varchar(50), 
    @pextra1         as varchar(50), 
    @pextra2         as varchar(50), 
    @pextra3         as varchar(50), 
    @pextra4         as varchar(50), 
    @pextra5         as varchar(50), 
    @pextra6         as varchar(50), 
    @pextra7         as varchar(50), 
    @pextra8         as varchar(50), 
    @pextra9         as varchar(50), 
    @pextra10        as varchar(50)
as

	IF @punitcode='' Begin
		set @punitcode=null
	End
	IF @ppublcode='' Begin
		set @ppublcode=null
	End
	IF @psupply_type='' Begin
		set @psupply_type=null
	End
	
	IF @pagency_type='' Begin
		set @pagency_type=null
	End
	
	IF @pinct_type='' Begin
		set @pinct_type=null
	End
	
	IF @pfreg_type='' Begin
		set @pfreg_type=null
	End
	
	IF @pextra1='' Begin
		set @pextra1=null
	End						
	IF @pextra2='' Begin
		set @pextra2=null
	End	
	IF @pextra3='' Begin
		set @pextra3=null
	End	
	
	IF @pextra4='' Begin
		set @pextra4=null
	End	
	
	IF @pextra5='' Begin
		set @pextra5=null
	End	
	
	IF @pextra6='' Begin
		set @pextra6=null
	End					  
	
	IF @pextra7='' Begin
		set @pextra7=null
	End					 
	IF @pextra8='' Begin
		set @pextra8=null
	End					 
		IF @pextra9='' Begin
		set @pextra9=null
	End	 		

	IF @pextra10='' Begin
		set @pextra10=null
	End					 

    declare @v_recno			int
    declare @v1_comp_code		varchar(50)
    declare @v1_unit_code		varchar(50)
    declare @v1_publ_code		varchar(50)
    declare @v1_publ_name		varchar(100)
    declare @v1_main_edtn		varchar(50)
    declare @v1_main_edtn_name	varchar(100)
    declare @v1_edtn			varchar(50)
    declare @v1_edtn_name		varchar(100)
    declare @v1_supply_type		varchar(50)
    declare @v1_sup_ty_name		varchar(100)	
    declare @v1_calc_type		varchar(50)
    declare @v1_supply_from		numeric(10)
    declare @v1_supply_till		numeric(10)
    declare @v1_valid_from		datetime
    declare @v1_inct_amt		numeric(14,2)
    declare @v1_branch_code		varchar(50)
    declare @v1_agency_type		varchar(50)
    declare @v1_reason			varchar(50)
    
    declare c1 cursor for
    select d.comp_code comp_code,d.unit_code unit_code,d.publ_code publ_code,p.publ_name publ_name,
    e.main_edtn main_edtn,dbo.cir_get_edtn_name(d.comp_code,e.main_edtn) main_edtn_name,d.edtn_code edtn,e.edtn_name edtn_name,
    d.supply_type supply_type,s.sup_ty_name sup_ty_name,d.calc_type calc_type,
    d.supply_from supply_from,d.supply_till supply_till,
    max(d.eff_date) valid_from,d.inct_amt inct_amt,d.branch_code branch_code, d.agency_type agency_type,d.reason reason 
    from cir_publ_mast p,cir_edtn_mast e,cir_inct_slab_det d,cir_supply_type_mast s
    where p.comp_code=e.comp_code and p.comp_code=d.comp_code and p.comp_code=s.comp_code and p.comp_code=@pcompcode and
    p.publ=e.publ and p.publ=d.publ_code and p.publ=isnull(@ppublcode,p.publ)
    and  d.unit_code=isnull(@punitcode,d.unit_code) 
    and e.edtn=d.edtn_code 
    and d.supply_type=s.sup_ty_code and d.supply_type=s.sup_ty_code and d.supply_type=isnull(@psupply_type,d.supply_type) 
    and (d.agency_type=@pagency_type or @pagency_type is null)
    group by d.comp_code,d.unit_code,d.publ_code,p.publ_name,e.main_edtn,edtn_code,e.edtn_name,d.supply_type,
    s.sup_ty_name,d.calc_type,d.supply_from,d.supply_till,d.inct_amt,d.branch_code,d.agency_type,d.reason;

    declare @v_process_id    numeric(30)

    exec cir_generate_processid @pcompcode,@puserid,@pdateformate,null,null,null,null,null,@v_process_id OUTPUT
    
	CREATE TABLE #CIR_TEMP_BILL_COLLECTION
	(COMP_CODE       VARCHAR(100),
	UNIT_CODE        VARCHAR(100),
	BILLNO           VARCHAR(200),
	BILLDT           DATETIME,
	PUBL_CODE        VARCHAR(100),
	AGCD             VARCHAR(100),
	DPCD             VARCHAR(100),
	SUPPLY_COPY      NUMERIC(10)                   DEFAULT 0,
	GROSS_AMT        NUMERIC(15,2)                 DEFAULT 0,
	COMM_AMT         NUMERIC(15,2)                 DEFAULT 0,
	SUR_AMT          NUMERIC(15,2)                 DEFAULT 0,
	RETURN_COPY      NUMERIC(10)                   DEFAULT 0,
	RETURN_AMT       NUMERIC(15,2)                 DEFAULT 0,
	DN_AMT           NUMERIC(15,2)                 DEFAULT 0,
	CN_AMT           NUMERIC(15,2)                 DEFAULT 0,
	REC_AMT          NUMERIC(15,2)                 DEFAULT 0,
	PREV_BAL         NUMERIC(15,2)                 DEFAULT 0,
	CUR_SESSIONID    NUMERIC,
	AGNAME           VARCHAR(200),
	AGNAME_OTH_LANG  VARCHAR(250),
	CITY_CODE        VARCHAR(200),
	TALUKA_CODE      VARCHAR(200),
	DIST_CODE        VARCHAR(200),
	STATE_CODE       VARCHAR(200),
	REMARKS          VARCHAR(500),
	RET_COMM_AMT     NUMERIC(15,2),
	BILL_SEC_AMT     NUMERIC(15,2),
	SEC_OPBAL        NUMERIC(15,2),
	REASON			 VARCHAR(200))
    
    
    open c1
        fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_publ_code, @v1_publ_name, @v1_main_edtn, @v1_main_edtn_name, @v1_edtn,@v1_edtn_name, @v1_supply_type, @v1_sup_ty_name, @v1_calc_type, @v1_supply_from,@v1_supply_till, @v1_valid_from, @v1_inct_amt, @v1_branch_code, @v1_agency_type ,@v1_reason
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
        insert into #cir_temp_bill_collection
            (comp_code, unit_code, billno,publ_code, agcd, dpcd,agname,agname_oth_lang, 
            city_code, state_code,taluka_code,dist_code,
            billdt,supply_copy,return_copy,comm_amt,remarks,cur_sessionid,REASON)
        values(@v1_comp_code,@v1_unit_code,@v1_publ_code,@v1_publ_name,@v1_main_edtn,@v1_edtn,@v1_main_edtn_name,@v1_edtn_name,
            @v1_supply_type,@v1_sup_ty_name,@v1_branch_code,@v1_agency_type,
            @pchkdate,@v1_supply_from,@v1_supply_till,@v1_inct_amt,@v1_calc_type,@v_process_id,@v1_reason)
		
		fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_publ_code, @v1_publ_name, @v1_main_edtn, @v1_main_edtn_name, @v1_edtn,@v1_edtn_name, @v1_supply_type, @v1_sup_ty_name, @v1_calc_type, @v1_supply_from,@v1_supply_till, @v1_valid_from, @v1_inct_amt, @v1_branch_code, @v1_agency_type ,@v1_reason
		End 
    close c1
    deallocate c1
    
    select comp_code AS "COMP_CODE", unit_code AS "UNIT_CODE", billno as "PUBL_CODE",publ_code AS "PUBL_NAME", agcd AS "MAIN_EDTN", dpcd AS "EDTN",
    agname AS "MAIN_EDTN_NAME",agname_oth_lang AS "EDTN_NAME", city_code AS "SUPPLY_TYPE", STATE_code AS "SUPPLY_TYPE_NAME",
    taluka_code as "BRANCH_CODE",dist_code AS "AGENCY_TYPE", 
    billdt AS "SUPDATE" ,comm_amt AS "INCT_AMT" ,REMARKS AS "CALC_TYPE",cur_sessionid as "PROCESSNO",
    supply_copy as "SUPPLY_FROM",return_copy as "SUPPLY_TILL",reason as "REASON"
    from #cir_temp_bill_collection
    
    select getdate() as "CUR_DATE"
    
    drop table #cir_temp_bill_collection
    



//////////////////////////
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[cir_incentive_cn_process_p]
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @ppublcode       as varchar(20),       
    @pedtncode       as varchar(20),
    @pagcode         as varchar(20),
    @pdepocode       as varchar(20),
    @pdatefrom       as datetime,
    @pdatetill       as datetime,
    @pdoctype        as varchar(20),
    @precptdt        as datetime,
    @precptno        as varchar(50),
    @preason         as varchar(50),
    @pinct_rate      as numeric(15,2),
    @pinct_type      as varchar(20),
    @pfreg_type      as varchar(20),   
    @premark         as varchar(500),
    @puserid         as varchar(20),
    @pdateformat     as varchar(20),
    @pextra1         as varchar(50),
    @pextra2         as varchar(50),
    @pextra3         as varchar(50),
    @pextra4         as varchar(50),
    @pextra5         as varchar(50)
  As
    declare @v_doctype		varchar(10)
    declare @v2_comp_code	varchar(50)
    declare @v2_unit_code	varchar(50)
    declare @v2_doctype		varchar(50)
    declare @v2_tot_supply  numeric(10)
    declare @v2_recptdt		datetime
    declare @v2_recptno		varchar(50)
    declare @v2_amount		numeric(15,2)
    declare @v2_bilagcd		varchar(50)
    declare @v2_bildpcd		varchar(50)
    declare c2 cursor for
        select s.comp_code,s.unit_code,s.doctype,sum(s.tot_supply) tot_supply,s.recptdt,s.recptno,sum(s.amount) amount,s.bilagcd,s.bildpcd 
        from cir_inct_process_det s,cir_agmast m  ,cir_edtn_mast e
        where s.comp_code=m.comp_code and s.comp_code=e.comp_code and s.comp_code=@pcompcode and s.unit_code=m.unit and s.unit_code=@punitcode and 
        s.bilagcd=m.agcd and s.bilagcd=@pagcode and s.bildpcd=m.dpcd and s.bildpcd= @pdepocode and
        s.recptno=@precptno and s.recptdt=@precptdt and s.publ_code=@ppublcode and s.publ_code=e.publ and s.edtn_code=e.edtn and 
        e.main_edtn=@pedtncode
        group by s.comp_code,s.unit_code,s.doctype,s.recptdt,s.recptno,s.bilagcd,s.bildpcd
        having sum(s.amount)>0
        order by s.comp_code,s.unit_code,s.bilagcd,s.bildpcd
    
    declare @v_amt			numeric(15,2)
    declare @v_remark		varchar(500);
    declare @v_recptno		varchar(50);
    declare @v_dsign		numeric(5);
    
    declare @v_bran_code	varchar(20);
    declare @v_rec_no		numeric(10);  
    declare @v_unsold_copy	numeric(10);
  Begin
    insert into cir_inct_process_det
        (comp_code, unit_code, publ_code, edtn_code, sup_type_code, from_pdate, till_pdate, agcd, dpcd, tot_supply, from_supply, till_supply, inct_rate, calc_type, amount, doctype, recptdt, recptno, bilagcd, bildpcd,
        created_by, created_date, updated_by, updated_date,tran_type)
        select s.comp_code, s.unit_code, s.publ_code, s.edtn_code, s.sup_type_code, s.from_pdate, s.till_pdate, s.agcd, s.dpcd, s.tot_supply, s.from_supply, s.till_supply, ISNULL(@pinct_rate, s.inct_rate), 
        s.calc_type, case when s.calc_type='P' then round(s.tot_supply*(isnull(@pinct_rate, s.inct_rate)/100),2) else round(s.tot_supply*ISNULL(@pinct_rate, s.inct_rate),2) end amount, s.doctype, s.recptdt, s.recptno, s.bilagcd, s.bildpcd,
                created_by, created_date, updated_by, updated_date,tran_type 
        from cir_inct_process_det_temp s,cir_edtn_mast e 
        where s.comp_code=@pcompcode and s.comp_code=e.comp_code and s.unit_code=@punitcode and 
            s.bilagcd=@pagcode and s.bildpcd= @pdepocode and s.recptno=@precptno and s.recptdt=@precptdt and 
            s.publ_code=e.publ and s.edtn_code=e.edtn and e.main_edtn=@pedtncode and s.tran_type='INC';
            
    If @pdoctype is null or @pdoctype='' Begin
        set @v_doctype='CN'
    End    
    Else Begin
        set @v_doctype=@pdoctype
    End
        
   set @v_amt=0

   open c2
print('check')
		fetch NEXT FROM c2 INTO @v2_comp_code,@v2_unit_code,@v2_doctype,@v2_tot_supply,@v2_recptdt,@v2_recptno,@v2_amount,@v2_bilagcd,@v2_bildpcd 
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN

        select @v_bran_code=branch_code from cir_agmast 
            where comp_code=@v2_comp_code and unit=@v2_unit_code and agcd=@v2_bilagcd and dpcd=@v2_bildpcd;
        
        select @v_dsign=Dsign from cir_docmst where Comp_code=@pcompcode AND doc_type=@v_doctype
print('asdfsf')
		print(@v2_amount)
		If @v2_amount>0 Begin
			If(@v_dsign=-1) Begin
				set @v_amt=@v2_amount*@v_dsign
			End    
			Else Begin
				set @v_amt=@v2_amount*@v_dsign
			End
	        
			If @premark is null or @premark='' Begin
				set @v_remark='Being amount auto credited against incentive charges'
			End    
			Else Begin
				set @v_remark=@premark
			End

			SELECT @v_rec_no  =  CAST( MAX(SUBSTRING(recptno, 5, 8))AS NUMERIC) + 1
			FROM  cir_rcphdr 
			WHERE comp_code  = @pcompcode AND doctype  = @pdoctype
			AND CONVERT(VARCHAR(23), recptdt) = CONVERT(VARCHAR(23), @v2_recptdt) AND branch_code  = @v_bran_code
			
			IF ISNULL(@v_rec_no, 0)= 0 BEGIN 
				SET @v_recptno  = @v_bran_code + '-' + REPLACE(CONVERT(VARCHAR(5), GETDATE(), 2), '.', '')+ '0001' 
			END
			ELSE BEGIN 
				SET @v_recptno  = @v_bran_code + '-' + dbo.fnPadLeft('0',8,@v_rec_no) 
			END
	    
			  insert into cir_rcphdr(comp_code,unit_code,agcd,dpcd,doctype,
									 recptno,recptdt,amount,reason,remark,
									 achd,voucherno,voucherdt,userid,creation_date,branch_code)
							  values(@v2_comp_code, @v2_unit_code,@v2_bilagcd, @v2_bildpcd,@v2_doctype,
									 @v_recptno,@v2_recptdt,@v_amt,isnull(@preason,'INCENTIVE CHARGES'),@v_remark,
									 'NM',@v_recptno,@v2_recptdt,@puserid,getdate(),@v_bran_code)
			  insert into cir_rcpdet(comp_code,unit_code,agcd,dpcd,doctyp,publ,
									 recptno,recptdt,payfor,achd,amount,
									 reason,remark,voucherno,voucherdt,usrid,
									 creation_date,branch_code)
							  values(@v2_comp_code, @v2_unit_code,@v2_bilagcd, @v2_bildpcd,@v2_doctype,@ppublcode,
									 @v_recptno,@v2_recptdt,@v2_unit_code,'NM',@v_amt,
									 isnull(@preason,'INCENTIVE CHARGES'),@v_remark,@v_recptno,@v2_recptdt,@puserid,
									 getdate(),@v_bran_code);
			  insert into cir_outmast(comp_code,unit_code,agcd,dpcd,doctyp,publ,
									  recptno,recptdt,achd,amount,reason,
									  remark,voucherno,voucherdt,usrid,creation_date,branch_code)
							   values(@v2_comp_code, @v2_unit_code,@v2_bilagcd, @v2_bildpcd,@v2_doctype,@ppublcode,
									  @v_recptno,@v2_recptdt,'NM',@v_amt,isnull(@preason,'INCENTIVE CHARGES'),
									  @v_remark,@v_recptno,@v2_recptdt,@puserid,getdate(),@v_bran_code)                               
        
				update cir_inct_process_det set recptno=@v_recptno
					where comp_code=@v2_comp_code and unit_code=@v2_unit_code and doctype=@v2_doctype and recptno=@precptno and 
						recptdt=@v2_recptdt and from_pdate >= @pdatefrom and till_pdate <= @pdatetill and bilagcd = @v2_bilagcd and bildpcd = @v2_bildpcd
						and publ_code=@ppublcode and tran_type='INC'
        End         
		fetch NEXT FROM c2 INTO @v2_comp_code,@v2_unit_code,@v2_doctype,@v2_tot_supply,@v2_recptdt,@v2_recptno,@v2_amount,@v2_bilagcd,@v2_bildpcd       
   End
   close c2;
	deallocate c2

	delete from cir_inct_process_det_temp where comp_code=@pcompcode and unit_code=@punitcode and 
            bilagcd=@pagcode and bildpcd= @pdepocode and recptno=@precptno and recptdt=@precptdt  and 
            publ_code=@ppublcode and tran_type='INC';
            
   select getdate() as "CUR_DATE" 
   
End


//////////////////////////////////////////////////////
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER procedure [dbo].[cir_incentive_edtnwise_p]
    @pcompcode       AS varchar(20),
    @punitcode       AS varchar(20),
    @ppublcode       AS varchar(20),       
    @pedtncode       AS varchar(20),
    @pagcode         AS varchar(20),
    @pdepocode       AS varchar(20),
    @pdatefrom       AS DATETIME,
    @pdatetill       AS DATETIME,
    @pdoctype        AS varchar(20),
    @precptdt        AS DATETIME,
    @precptno        AS varchar(20),
    @preason         AS varchar(20),
    @pinct_rate      AS numeric(12,2),
    @pinct_type       AS varchar(20),
    @pfreg_type		 AS varchar(20),   
    @premark         AS varchar(20),
    @puserid         AS varchar(20),
    @pdateformat     AS varchar(20),
    @pextra1         AS varchar(200),
    @pextra2         AS varchar(200),
    @pextra3         AS varchar(200),
    @pextra4         AS varchar(200),
    @pextra5         AS varchar(200)
  As
    declare @v_doctype   varchar(10)

    declare c1 cursor for
        select distinct s.edtn_code,s.calc_type  
        from cir_inct_process_det_temp s,cir_agmast m ,cir_edtn_mast e
        where s.comp_code=m.comp_code and s.comp_code=e.comp_code and s.comp_code=@pcompcode and s.unit_code=m.unit and s.unit_code=@punitcode and 
        s.bilagcd=m.agcd and s.bilagcd=@pagcode and s.bildpcd=m.dpcd and s.bildpcd= @pdepocode and
        s.recptno=@precptno and s.recptdt=@precptdt and s.publ_code=@ppublcode and s.publ_code=e.publ and s.edtn_code=e.edtn and 
        e.main_edtn=@pedtncode and s.tran_type='INC'
        order by s.edtn_code
    declare @v_edtn_code varchar(50)
    declare @v_calc_type varchar(50)        

    open c1
        fetch NEXT FROM c1 INTO @v_edtn_code,@v_calc_type
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
        If @v_calc_type='P' Begin
            update cir_inct_process_det_temp set amount= round(isnull(tot_supply,0)*(isnull(inct_rate,0)/100),2),final_process='Y' 
                where comp_code=@pcompcode and unit_code=@punitcode and 
                    bilagcd=@pagcode and bildpcd= @pdepocode and recptno=@precptno and recptdt=@precptdt  and 
                    publ_code=@ppublcode and edtn_code=@v_edtn_code and tran_type='INC' and calc_type='P'   
		End                    
		Else Begin
			update cir_inct_process_det_temp set amount= round(isnull(tot_supply,0)*isnull(inct_rate,0),2) ,final_process='Y'
				where comp_code=@pcompcode and unit_code=@punitcode and 
                bilagcd=@pagcode and bildpcd= @pdepocode and recptno=@precptno and recptdt=@precptdt  and 
                publ_code=@ppublcode and edtn_code=@v_edtn_code and tran_type='INC' and calc_type='F'
		End
		fetch NEXT FROM c1 INTO @v_edtn_code,@v_calc_type
    End
    close c1
	deallocate c1    
    select getdate() as "CUR_DATE"
   
*****************************Neha***19-dec-2011****************************

create PROCEDURE [dbo].[cir_fetch_suppliment_data_p]
	@pcompcode                                VARCHAR(40) ,
	@punitcode                                VARCHAR(40) ,
	@pagtype                                  VARCHAR(40) ,
	@pagclass                                 VARCHAR(40) ,
	@psup_type                                VARCHAR(40) ,
	@pagcode                                  VARCHAR(40) ,
	@pdepocode                                VARCHAR(40) ,
	@pcode                                    VARCHAR(4000) ,
	@pprocesstype                             VARCHAR(4000) ,---process by Zone.Region,Branch,District,Route
	@pdatefrom                                datetime ,
	@pdatetill                                datetime ,
	@pedtncode_val                            VARCHAR(4000) ,--for edition code
	@psupdate_val                             VARCHAR(4000) ,--for supply date
	@pinc_rate_val                            VARCHAR(4000) ,--for insertion rate
	@psupl_no_val                             VARCHAR(4000) ,--for no. of insertion
	@psupl_name_val                           VARCHAR(4000) ,--for suppliment name
	@pdelimiter                               VARCHAR(4000) ,
	@puserid                                  VARCHAR(40) ,
	@pdateformat                              VARCHAR(40) ,
	@pextra1                                  VARCHAR(400) ,
	@pextra2                                  VARCHAR(400) ,
	@pextra3                                  VARCHAR(400) ,
	@pextra4                                  VARCHAR(400) ,
	@pextra5                                  VARCHAR(400)
AS 
BEGIN
	DECLARE @vlength                                  NUMERIC(7) 
	DECLARE @vrunval                                  VARCHAR(8000) 
	DECLARE @v_val                                    VARCHAR(800) 
	DECLARE @v_name                                   VARCHAR(8000) 
	DECLARE @v_sname                                  VARCHAR(8000) 
	DECLARE @vno                                      FLOAT                           
	SET @vno = 0 
	DECLARE @v_frdt                                   DATETIME 
	DECLARE @v_todt                                   DATETIME 
	DECLARE @v_doctype                                VARCHAR(10)                     
	SET @v_doctype = 'CN' 
	DECLARE @v_recptdt                                DATETIME 
	DECLARE @v_dt                                     DATETIME 
	DECLARE @v_sess_id                                VARCHAR(30) 

		
	DECLARE @v1                                       VARCHAR(200) 
	DECLARE @v_amt                                    NUMERIC(15,2) 
	DECLARE @v_remark                                 VARCHAR(500) 
	DECLARE @v_recptno                                VARCHAR(50) 
	DECLARE @v_dsign                                  NUMERIC(5) 
	DECLARE @v_bran_code                              VARCHAR(20) 
	DECLARE @v_rec_no                                 NUMERIC(10) 
	DECLARE @v_unsold_copy                            NUMERIC(10) 
	DECLARE @vdistcode                                VARCHAR(4000) 
	DECLARE @vtalukacode                              VARCHAR(4000) 
	
	SET @v_recptdt  = CONVERT(DATETIME, @pdatetill)
	CREATE TABLE #CIR_LEDGER_REPORT
	(COMP_CODE		VARCHAR(100),
	 UNIT_CODE		VARCHAR(100),
	 DEBIT_HEAD		VARCHAR(100),
	 REC_SEQNO		INT)

CREATE TABLE #CIR_TEMP_SUPPLIMENT
( COMP_CODE     VARCHAR(10),
  UNIT_CODE     VARCHAR(10),
  SEQ_NO        NUMERIC(5),
  EDITION_CODE  VARCHAR(10),
  SUP_DATE      DATETIME,
  INC_RATE      NUMERIC(10,2),
  NOOF_SUPL     NUMERIC(3),
  SUPL_NAME     VARCHAR(100))

	If @pagtype='' Begin
		set @pagtype=null
	End
	If @pagclass='' Begin
		set @pagclass=null
	End
	If @psup_type='' Begin
		set @psup_type=null
	End
	If @pagcode='' Begin
		set @pagcode=null
	End
	If @pdepocode='' Begin
		set @pdepocode=null
	End
	If @pcode='' Begin
		set @pcode=null
	End
	If @pprocesstype='' Begin
		set @pprocesstype=null
	End

	If @pextra1='' Begin
		set @pextra1=null
	End									
	If @pextra2='' Begin
		set @pextra2=null
	End
	If @pextra3='' Begin
		set @pextra3=null
	End									
	If @pextra4='' Begin
		set @pextra4=null
	End
	If @pextra5='' Begin
		set @pextra5=null
	End
	  	  
	DELETE FROM   cir_supl_process_det_temp WHERE  recptno  = '''' + @@SPID + '''' 


		SET @v_sess_id  =  @@SPID
		
		/* for  Edition Code */
		
		SET @vlength  = null SET @vrunval  = null 
		SET @v_val  = REPLACE(@pedtncode_val, @pdelimiter, ',')
		SET @vlength  = LEN(@v_val)SET @vno  = 1
		
		DECLARE	@i	INT
		SET @i  = 1

		WHILE @i <= @vlength BEGIN
			SET @vrunval  = SUBSTRING(@v_val, @i, 1)
			IF @vrunval != ',' BEGIN 
				SET @v_name  = @v_name + @vrunval 
			END
			ELSE BEGIN 
				INSERT INTO  #cir_temp_suppliment( comp_code , unit_code , seq_no , edition_code)  
				 VALUES ( @pcompcode , @punitcode , @vno , @v_name)  
				
				SET @vno  = @vno + 1 
				SET @v_name  = '' 
			END
			SET @i = @i + 1
		END
		
		/* for Supply Date */
	
		SET @vrunval	= null 
		SET @v_name		= null SET @v_sname  = null 
		SET @v_val		= REPLACE(@psupdate_val, @pdelimiter, ',')
		SET @vlength	= LEN(@v_val)
		SET @vno  = 1 SET @i = 1 

		WHILE @i <= @vlength BEGIN
		
			SET @vrunval  = SUBSTRING(@v_val, @i, 1)
			IF @vrunval != ',' BEGIN 
				SET @v_name  = @v_name + @vrunval 
			END
			ELSE BEGIN 
				SET @v_dt  = CONVERT(DATETIME, @v_name)
				UPDATE  #cir_temp_suppliment SET	sup_date = @v_dt WHERE seq_no  = @vno

				SET @vno  = @vno + 1 
				SET @v_name  = '' 
			END
			SET @i = @i + 1
		END
		/* for Incanctive Per Copy Rate */
		
		SET @vrunval  = null 
		SET @v_name  = null 
		SET @v_sname  = null 
		SET @v_val  = REPLACE(@pinc_rate_val, @pdelimiter, ',')
		SET @vlength  = LEN(@v_val)
		SET @vno  = 1 SELECT @i = 1 

		WHILE @i <= @vlength BEGIN
			SET @vrunval  = SUBSTRING(@v_val, @i, 1)
			IF @vrunval != ',' BEGIN 
				SET @v_name  = @v_name + @vrunval 
			END
			ELSE BEGIN 
				UPDATE  #cir_temp_suppliment SET	inc_rate = (@v_name) WHERE  seq_no  = @vno
				
				SET @vno  = @vno + 1 
				SET @v_name  = '' 
			END
			SET @i = @i + 1
		END
	
		/* for No of Supl */
		
		SET @vrunval  = null 
		SET @v_name  = null 
		SET @v_sname	= null 
		SET @v_val		= REPLACE(@psupl_no_val, @pdelimiter, ',')
		SET @vlength	= LEN(@v_val) SET @vno  = 1 SET @i = 1 
		
		WHILE @i <= @vlength BEGIN
			SET @vrunval  = SUBSTRING(@v_val, @i, 1)
			IF @vrunval != ',' 
			BEGIN 
				SET @v_name  = @v_name + @vrunval 
			END
			ELSE BEGIN 
				UPDATE  #cir_temp_suppliment  SET	noof_supl = (@v_name) WHERE  seq_no  = @vno
				
				SET @vno  = @vno + 1 
				SET @v_name  = '' 
			END
			SET @i = @i + 1
		END
		
		/* for Supl Name*/
		
		SET @v_val  = null SET @vrunval  = null 
		SET @v_name = null SET @v_sname  = null 
		SET @v_val  = REPLACE(@psupl_name_val, @pdelimiter, ',')
		SET @vlength= LEN(@v_val)
		SET @vno	= 1 SET @i = 1 

		WHILE @i <= @vlength BEGIN
			SET @vrunval  = SUBSTRING(@v_val, @i, 1)
			IF @vrunval != ',' BEGIN 
				SET @v_sname  = @v_sname + @vrunval 
			END
			ELSE BEGIN 
				UPDATE  #cir_temp_suppliment  SET	supl_name = (@v_sname) WHERE  seq_no  = @vno
				
				SET @vno  = @vno + 1 
				SET @v_name  = '' 
			END
			SET @i = @i + 1
		END

		IF @pcode IS NOT NULL or @pcode<>'' BEGIN 
			SET @vdistcode  = @pcode  + ''',''' 
			SET @v_name  = null 
			SET @vrunval  = null 
			SET @v_val  = REPLACE(@vdistcode, ',', ',')
			SET @vlength  = LEN(@v_val)
			SET @vno  = 1 
			SET @i = 1 

			WHILE @i <= @vlength BEGIN
				SET @vrunval  = SUBSTRING(@v_val, @i, 1)
				IF @vrunval != ',' BEGIN 
					SET @v_name  = @v_name + @vrunval 
				END
				ELSE BEGIN 
					INSERT INTO  #cir_ledger_report   
							( comp_code , unit_code , debit_head, rec_seqno)  
					 VALUES ( @pcompcode , @punitcode , @v_name , @vno)  
					
					SET @vno  = @vno + 1 
					SET @v_name  = '' 
				END
				SET @i = @i + 1
			END
		END
		
		
	DECLARE @c1_comp_code	VARCHAR(40)
	DECLARE @c1_unit_code	VARCHAR(40) 
	DECLARE @c1_publ		VARCHAR(40) 
	DECLARE @c1_edtn		VARCHAR(40) 
	DECLARE @c1_supdate		DATETIME 
	DECLARE @c1_agcd		VARCHAR(40) 
	DECLARE @c1_dpcd		VARCHAR(40) 
	DECLARE @c1_billagcd	VARCHAR(40) 
	DECLARE @c1_billdpcd	VARCHAR(40) 
	DECLARE @c1_inc_rate	NUMERIC(15,2)
	DECLARE @c1_no_of_supl  INT
	DECLARE @c1_supl_name	VARCHAR(400) 
	DECLARE @c1_sup_copy	INT
   
	DECLARE c1 CURSOR LOCAL FOR 
	SELECT DISTINCT	 a.comp_code comp_code,	 a.unit_code unit_code, a.publ publ,
			 a.edtn edtn, a.supdate supdate, a.agcd agcd, a.dpcd dpcd, a.billagcd billagcd,
			 a.billdpcd billdpcd, b.inc_rate inc_rate, b.noof_supl no_of_supl,b.supl_name supl_name,
			 SUM(a.sup_copy) sup_copy
	FROM  cir_dbksup a, cir_temp_suppliment b,cir_supply_type_mast c,cir_agmast d 
	WHERE a.comp_code  = @pcompcode AND a.comp_code  = b.comp_code AND a.comp_code  = c.comp_code AND a.comp_code  = d.comp_code
	 AND a.unit_code  = ISNULL(@punitcode, a.unit_code) AND a.unit_code  = d.unit
	 AND a.edtn  = b.edition_code
	 AND a.supdate  >= @pdatefrom AND a.supdate  <= @pdatetill
	 AND a.sup_type_code  = c.sup_ty_code
	 AND a.sup_type_code  = ISNULL(@psup_type, a.sup_type_code)
	 AND a.agcd  = d.agcd AND a.dpcd  = d.dpcd
	 AND d.agcd  = ISNULL(@pagcode, d.agcd) AND d.dpcd  = ISNULL(@pdepocode, d.dpcd)
	 AND (d.ag_type  = @pagtype OR	@pagtype IS NULL)
	 AND (d.ag_class  = @pagclass OR @pagclass  IS NULL)
	 AND (d.dist_code  IN(SELECT debit_head	FROM  #cir_ledger_report) OR pcode  IS NULL)
	 AND b.sess_id  = @@SPID
	 AND a.supdate  = b.sup_date
	 AND a.billagcd  IS NOT NULL
	GROUP BY a.comp_code, a.unit_code, a.publ, a.edtn, a.supdate, a.agcd,a.dpcd,a.billagcd,
		 a.billdpcd,b.inc_rate, b.noof_supl, b.supl_name 
		 ORDER BY a.comp_code,a.unit_code,a.supdate,a.publ,a.edtn 

		
		OPEN c1 
		FETCH NEXT FROM c1 INTO @c1_comp_code,@c1_unit_code,@c1_publ,@c1_edtn,@c1_supdate,@c1_agcd,@c1_dpcd,@c1_billagcd,@c1_billdpcd,
		@c1_inc_rate,@c1_no_of_supl,@c1_supl_name,
			@c1_sup_copy
			
			
			WHILE(@@FETCH_STATUS =0) 
			BEGIN 

			SET @v_amt  = ( ISNULL( @c1_sup_copy, 0)- ISNULL(@v_unsold_copy, 0)) * ISNULL(@c1_inc_rate, 0)* ISNULL(@c1_no_of_supl, 0)
			
			IF ISNULL(@v_amt, 0)<> 0 BEGIN 
				INSERT INTO  cir_supl_process_det_temp   
						( comp_code , unit_code , publ_code , edtn_code , supdate , agcd , 
						dpcd , tot_supply , per_copy_rate , no_of_supl , recptdt , recptno , amount , 
						bilagcd , bildpcd , created_by , doctype , supl_name)  
				 VALUES ( @c1_comp_code , @c1_unit_code , @c1_publ , @c1_edtn , @c1_supdate , @c1_agcd , @c1_dpcd , 
						ISNULL(@c1_sup_copy, 0) - ISNULL(@v_unsold_copy, 0) , 
						@c1_inc_rate , @c1_no_of_supl , @v_recptdt , @@SPID , @v_amt , @c1_billagcd , 
						@c1_billdpcd , @puserid , @v_doctype , @c1_supl_name )  
				
 			END
		FETCH NEXT FROM c1 INTO @c1_comp_code,@c1_unit_code,@c1_publ,@c1_edtn,@c1_supdate,@c1_agcd,@c1_dpcd,@c1_billagcd,@c1_billdpcd,
		@c1_inc_rate,@c1_no_of_supl,@c1_supl_name,
			@c1_sup_copy
			
		END
		CLOSE c1		
		SET @v_amt  = 0 
	
		SELECT s.comp_code AS "COMP_CODE",s.unit_code AS "UNIT_CODE",s.recptno AS "RECPTNO",s.recptdt AS "RECPTDT",
				 s.bilagcd AS "AGCD",s.bildpcd AS "DPCD",m.ag_name AS "AG_NAME",
				 DBO.cir_get_drop_point_name(s.comp_code, s.unit_code, m.station_code, 1) AS "DROP_POINT_NAME",
				 DBO.cir_get_city(s.comp_code, m.city_code) AS "CITY_NAME",
				 s.doctype AS "DOCTYPE",SUM(s.tot_supply) AS "SUPPLY",COUNT(s.no_of_supl) AS "NO_OF_INSERTION",SUM(s.amount) AS "AMOUNT"
		FROM  cir_supl_process_det_temp s, cir_agmast m 
		WHERE s.comp_code  = m.comp_code
		 AND s.unit_code  = m.unit
		 AND s.bilagcd  = m.agcd
		 AND s.bildpcd  = m.dpcd
		 AND s.recptno  = @v_sess_id
		GROUP BY s.comp_code,s.unit_code,s.recptno,s.recptdt,s.doctype,s.bilagcd,s.bildpcd,m.station_code,m.city_code,m.ag_name 
		HAVING SUM(CONVERT(FLOAT, amount))  > 0  
		ORDER BY comp_code,unit_code,bilagcd,bildpcd 
	DEALLOCATE c1
	DROP TABLE #cir_ledger_report;
	DROP TABLE #cir_temp_suppliment;

END



////////////////////garima


ALTER PROCEDURE  [dbo].[cir_one_day_supply_change_p]
	@pcomp_code		as varchar(200),
	@punit_code     as varchar(200),
	@ppubl_code     as varchar(200),
	@pedtn_code     as varchar(200),
	@psup_type      as varchar(200),
	@psup_date      as datetime,
	@pagcd_code     as varchar(200),
	@pdpcd_code     as varchar(200),
	@pzone_code     as varchar(200),--for zone filter added new 09122011 by Sushil
	@pregion_code   as varchar(200),--for region filter added new 09122011 by Sushil
	@pcomm_category as varchar(200),--for commition category added new 09122011 by Sushil
	@pstate_code    as varchar(200),--for state filter added new 09122011 by Sushil
	@pdist_code     as varchar(200),--for district filter added new 09122011 by Sushil
	@ptaluka_code   as varchar(200),--for taluka filter added new 09122011 by Sushil
	@pcity_code     as varchar(200),--for city filter added new 09122011 by Sushil
	@proute_code    as varchar(200),--for route filter added new 09122011 by Sushil
	@pbran_code     as varchar(200),--for branch filter added new 09122011 by Sushil
	@pagency_type   as varchar(200),--for agency type filter added new 09122011 by Sushil
	@pagency_class  as varchar(200),--for agency class filter added new 09122011 by Sushil
	@pdateformat    as varchar(200),
	@pextra1        as varchar(200),--1 for  edition route wise,2 for edition district wise
	@pextra2        as varchar(200),--D for distribution agency
	@pextra3        as varchar(200),
	@pextra4        as varchar(200),
	@pextra5        as varchar(200),
	@pextra6        as varchar(200),
	@pextra7        as varchar(200),
	@pextra8        as varchar(200),
	@pextra9        as varchar(200),
	@pextra10       as varchar(200)
AS 
	If @punit_code='' Begin
		set @punit_code=null
	End
	If @ppubl_code='' Begin
		set @ppubl_code=null
	End
	If @pedtn_code='' Begin
		set @pedtn_code=null
	End
	If @psup_type='' Begin
		set @psup_type=null
	End
	If @pagcd_code='' Begin
		set @pagcd_code=null
	End
	If @pdpcd_code='' Begin
		set @pdpcd_code=null
	End
	If @pzone_code='' Begin
		set @pzone_code=null
	End
	If @pregion_code='' Begin
		set @pregion_code=null
	End
	If @pcomm_category='' Begin
		set @pcomm_category=null
	End
	If @pstate_code='' Begin
		set @pstate_code=null
	End
	
	If @pdist_code='' Begin
		set @pdist_code=null
	End
	If @ptaluka_code='' Begin
		set @ptaluka_code=null
	End
	If @pcity_code='' Begin
		set @pcity_code=null
	End
	If @proute_code='' Begin
		set @proute_code=null
	End
	If @pbran_code='' Begin
		set @pbran_code=null
	End
	If @pagency_type='' Begin
		set @pagency_type=null
	End
	If @pagency_class='' Begin
		set @pagency_class=null
	End
	If @proute_code='' Begin
		set @proute_code=null
	End		

  if upper(@pextra2)='D' Begin
      select a.agcd agcd,a.dpcd dpcd,a.ag_name agency_name,a.ag_name_oth_lang agency_name_other_lang,a.city_code city_code,
      dbo.cir_get_city(a.comp_code,a.city_code) city_name,a.station_code drop_point_code,dbo.cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,'1') drop_point_name,
            c.sup_copy sup_copy,dbo.cir_get_route_seqno(c.comp_code,c.unit_code,c.route_code) route_seq,
            dbo.cir_get_supply_seqno(c.comp_code,c.unit_code,c.publ,c.edtn,c.agcd,c.dpcd) supply_seq,
            (select sum(c.sup_copy) sup_copy from cir_agmast_dis a,cir_supply_type_mast b,cir_dbksup_dis c
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=@pcomp_code and
                  a.unit=c.unit_code and a.unit=isnull(@punit_code,a.unit) and b.sup_ty_code=c.sup_type_code and
                  c.publ=isnull(@ppubl_code,c.publ) and c.edtn = isnull(@pedtn_code,c.edtn) and c.supdate=@psup_date and 
                  a.agcd=c.agcd and a.dpcd=c.dpcd and
                  a.agcd=isnull(@pagcd_code,a.agcd) and a.dpcd=isnull(@pdpcd_code,a.dpcd) and c.sup_type_code=@psup_type) total_supply,
                  c.final_supply_flag final_supply_flag
      from cir_agmast_dis a,cir_supply_type_mast b,cir_dbksup_dis c
      where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=@pcomp_code and
         a.unit=c.unit_code and a.unit=isnull(@punit_code,a.unit) and b.sup_ty_code=c.sup_type_code and
         c.publ=isnull(@ppubl_code,c.publ) and c.edtn = isnull(@pedtn_code,c.edtn) and 
         c.supdate=@psup_date and a.agcd=c.agcd and a.dpcd=c.dpcd and
         a.agcd=isnull(@pagcd_code,a.agcd) and a.dpcd=isnull(@pdpcd_code,a.dpcd) and c.sup_type_code=@psup_type and
         (c.agency_ty_code = @pagency_type or @pagency_type is null) and
         (c.comm_code = @pcomm_category or @pcomm_category is null) and
         (c.route_code = @proute_code or @proute_code is null) and
         (a.state_code = @pstate_code or @pstate_code is null) and
         (a.dist_code = @pdist_code or @pdist_code is null) and
         (a.tehsil_taluka = @ptaluka_code or @ptaluka_code is null) and
         (a.branch_code = @pbran_code or @pbran_code is null) and
         a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcity_code,city_code) and 
         (zone_code = @pzone_code or @pzone_code is null) and (region_code = @pregion_code or @pregion_code is null))
         order by route_seq,supply_seq,agency_name;
  End       
  else Begin
      if @pextra1=2 Begin---for edition district and agency wise
          select a.agcd agcd,a.dpcd dpcd,a.ag_name agency_name,a.ag_name_oth_lang agency_name_other_lang,a.city_code city_code,
          dbo.cir_get_city(a.comp_code,a.city_code) city_name,a.station_code drop_point_code,dbo.cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,'1') drop_point_name,
                c.sup_copy sup_copy,dbo.cir_get_route_seqno(c.comp_code,c.unit_code,c.route_code) route_seq,
                dbo.cir_get_supply_seqno(c.comp_code,c.unit_code,c.publ,c.edtn,c.agcd,c.dpcd) supply_seq,
                (select sum(c.sup_copy) sup_copy from cir_agmast a,cir_supply_type_mast b,cir_dbksup c
                where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=@pcomp_code and
                      a.unit=c.unit_code and a.unit=isnull(@punit_code,a.unit) and b.sup_ty_code=c.sup_type_code and
                      c.publ=isnull(@ppubl_code,c.publ) and c.edtn = isnull(@pedtn_code,c.edtn) and c.supdate=@psup_date and 
                      a.agcd=c.agcd and a.dpcd=c.dpcd and
                      a.agcd=isnull(@pagcd_code,a.agcd) and a.dpcd=isnull(@pdpcd_code,a.dpcd) and c.sup_type_code=@psup_type) total_supply,d.dist_name dist_name
          from cir_agmast a,cir_supply_type_mast b,cir_dbksup c,cir_dist_mast d
          where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=d.comp_code and a.comp_code=@pcomp_code and
             a.unit=c.unit_code and a.unit=isnull(@punit_code,a.unit) and b.sup_ty_code=c.sup_type_code and
             c.publ=isnull(@ppubl_code,c.publ) and c.edtn = isnull(@pedtn_code,c.edtn)
             and c.supdate=@psup_date and a.agcd=c.agcd and a.dpcd=c.dpcd and
             a.agcd=isnull(@pagcd_code,a.agcd) and a.dpcd=isnull(@pdpcd_code,a.dpcd) and c.sup_type_code=@psup_type and
             a.dist_code=d.dist_code and
             (c.agency_ty_code = @pagency_type or @pagency_type is null) and
            (c.comm_code = @pcomm_category or @pcomm_category is null) and
            (c.route_code = @proute_code or @proute_code is null) and
            (a.state_code = @pstate_code or @pstate_code is null) and
            (a.dist_code = @pdist_code or @pdist_code is null) and
            (a.tehsil_taluka = @ptaluka_code or @ptaluka_code is null) and
            (a.branch_code = @pbran_code or @pbran_code is null) and
            a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcity_code,city_code) and 
            (zone_code = @pzone_code or @pzone_code is null) and (region_code = @pregion_code or @pregion_code is null)) 
            order by dist_name,agency_name,supply_seq;
   End         
      else Begin
          select a.agcd agcd,a.dpcd dpcd,a.ag_name agency_name,a.ag_name_oth_lang agency_name_other_lang,a.city_code city_code,
			dbo.cir_get_city(a.comp_code,a.city_code) city_name,a.station_code drop_point_code,dbo.cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,'1') drop_point_name,
            c.sup_copy sup_copy,dbo.cir_get_route_seqno(c.comp_code,c.unit_code,c.route_code) route_seq,
            dbo.cir_get_supply_seqno(c.comp_code,c.unit_code,c.publ,c.edtn,c.agcd,c.dpcd) supply_seq,
            (select sum(c.sup_copy) sup_copy from cir_agmast a,cir_supply_type_mast b,cir_dbksup c
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=@pcomp_code and
                  a.unit=c.unit_code and a.unit=isnull(@punit_code,a.unit) and b.sup_ty_code=c.sup_type_code and
                  c.publ=isnull(@ppubl_code,c.publ) and c.edtn = isnull(@pedtn_code,c.edtn) and c.supdate=@psup_date and 
                  a.agcd=c.agcd and a.dpcd=c.dpcd and
                  a.agcd=isnull(@pagcd_code,a.agcd) and a.dpcd=isnull(@pdpcd_code,a.dpcd) and c.sup_type_code=@psup_type) total_supply,
                  c.final_supply_flag final_supply_flag
      from cir_agmast a,cir_supply_type_mast b,cir_dbksup c
      where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=@pcomp_code and
         a.unit=c.unit_code and a.unit=isnull(@punit_code,a.unit) and b.sup_ty_code=c.sup_type_code and
         c.publ=isnull(@ppubl_code,c.publ) and c.edtn = isnull(@pedtn_code,c.edtn) and 
         c.supdate=@psup_date and a.agcd=c.agcd and a.dpcd=c.dpcd and
         a.agcd=isnull(@pagcd_code,a.agcd) and a.dpcd=isnull(@pdpcd_code,a.dpcd) and c.sup_type_code=@psup_type and
         (c.agency_ty_code = @pagency_type or @pagency_type is null) and
         (c.comm_code = @pcomm_category or @pcomm_category is null) and
         (c.route_code = @proute_code or @proute_code is null) and
         (a.state_code = @pstate_code or @pstate_code is null) and
         (a.dist_code = @pdist_code or @pdist_code is null) and
         (a.tehsil_taluka = @ptaluka_code or @ptaluka_code is null) and
         (a.branch_code = @pbran_code or @pbran_code is null) and
         a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcity_code,city_code) and 
         (zone_code = @pzone_code or @pzone_code is null) and (region_code = @pregion_code or @pregion_code is null))
         order by route_seq,supply_seq,agency_name;
	End
End   
/*****************************************19-dec-2011 Laxman transfer out for malesiya*********************/
CREATE function cir_get_pubcenter (
@pcomp_code      as  varchar(20),
@pubcent_code    as  varchar(20),
@puserid         as  varchar(20),
@pdateformat     as  varchar(20),
@pextra1         as  varchar(20),
@pextra2         as  varchar(20))
returns varchar(200) as
begin
	declare @vcentname varchar(200)

	select @vcentname="Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=@pubcent_code

	return isnull(@vcentname,'')
end

create procedure cir_unsold_supply_for_transfer
    @pcomp_code         as varchar(20),
    @punit_code         as varchar(20),
    @pbran_code         as varchar(20),
    @pfromdate          as datetime,
    @ptilldate          as datetime,
    @puserid            as varchar(20),   
    @pdateformat        as varchar(20),
    @pextra1            as varchar(200),
    @pextra2            as varchar(200),
    @pextra3            as varchar(200),
    @pextra4            as varchar(200),
    @pextra5            as varchar(200),
    @pextra6            as varchar(200),
    @pextra7            as varchar(200),
    @pextra8            as varchar(200),               
    @pextra9            as varchar(200),
    @pextra10           as varchar(200)
As
Begin
	
    declare @v_process_id    numeric(30)

    exec cir_generate_processid @pcomp_code,@puserid,@pdateformat,null,null,null,null,null,@v_process_id OUTPUT
    
    select distinct d.comp_code as "COMP_CODE",d.unit_code as "UNIT_CODE",d.branch_code as "BRANCH_CODE",d.doctype as "DOCTYPE",
    d.recptno as "RECPTNO",d.recptdt as "RECPTDT",d.sup_agcd as "SUP_AGCD" ,d.sup_dpcd as "SUP_DPCD",m.ag_name as "SUPPLY_AGENCY",
    dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) drop_point_name, dbo.cir_get_city(d.comp_code,m.city_code) city_name,
    dbo.cir_get_agency(d.comp_code,d.unit_code,d.agcd,d.dpcd) as "BILLING_AGENCY",
    sum(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)+isnull(apr_damage,0)) as "TOTAL_UNSOLD",
    @v_process_id as "PROCESS_IDNO" 
    from cir_unsold_hdr h,cir_unsold_dtl d,cir_agmast m
    where h.comp_code=d.comp_code and h.comp_code=m.comp_code and h.comp_code=@pcomp_code and h.unit_code=d.unit_code and h.unit_code=m.unit and h.unit_code=@punit_code and 
    h.doctype=d.doctype and h.doctype='UCN' and h.recptno=d.recptno and h.recptdt=d.recptdt and h.recptdt between @pfromdate and @ptilldate and 
    h.agcd=isnull(d.sup_agcd,d.agcd) and h.agcd=m.agcd and h.dpcd=isnull(d.sup_dpcd,d.dpcd) and h.dpcd=m.dpcd and 
    d.branch_code=isnull(@pbran_code,d.branch_code) and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)+isnull(apr_damage,0))>0 and
    (h.branch_trfno is null or h.branch_trfno='')
    group by d.comp_code,d.unit_code,d.branch_code,d.doctype,d.recptno,d.recptdt,d.sup_agcd,d.sup_dpcd,m.ag_name,m.station_code, m.city_code,d.agcd,d.dpcd
    order by comp_code,unit_code,recptdt,recptno;
	
        
End


CREATE procedure cir_unsold_transfer_selected
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @pbrancode       as varchar(20),
    @precptno        as varchar(20),
    @precptdt        as datetime,
    @pprocess_idno   as numeric(20),
    @puserid         as varchar(20), 
    @pdateformat     as varchar(20),
    @pextra1         as varchar(20),
    @pextra2         as varchar(20),
    @pextra3         as varchar(20),
    @pextra4         as varchar(20),
    @pextra5         as varchar(20),
    @pextra6         as varchar(20),
    @pextra7         as varchar(20),
    @pextra8         as varchar(20),
    @pextra9         as varchar(20),
    @pextra10        as varchar(20)
as
begin
   
    insert into cir_bill_return_print(comp_code,unit_code,branch_code,billno,billdt,return_copy)
    values(@pcompcode,@punitcode,@pbrancode,@precptno,@precptdt,@pprocess_idno)
    
    select getdate() as "CUR_DATE"
    
End

CREATE procedure cir_fetch_for_unsold_transfer
    @pcomp_code      as varchar(20),
    @punit_code      as varchar(20),
    @pbran_code      as varchar(20),
    @pprocess_idno   as numeric(20),
    @ppacket_szie    as int,
    @puserid         as varchar(20), 
    @pdateformat     as varchar(20),
    @pextra1         as varchar(20),
    @pextra2         as varchar(20),
    @pextra3         as varchar(20),
    @pextra4         as varchar(20),
    @pextra5         as varchar(20),
    @pextra6         as varchar(20),
    @pextra7         as varchar(20),
    @pextra8         as varchar(20),
    @pextra9         as varchar(20),
    @pextra10        as varchar(20)
as
begin

    select distinct x.comp_code as "COMP_CODE",x.unit_code as "UNIT_CODE",x.branch_code as "BRANCH_CODE",x.doctype as "DOCTYPE",
    x.publ as "PUBL",x.publ_name as"PUBL_NAME", x.main_edtn as "MAIN_EDTN",x.main_edtn_name as "MAIN_EDTN_NAME",
    x.edtn as "EDTN",x.edtn_name as "EDTN_NAME",x.copy_rate as "COPY_RATE",x.total_unsold as "TOTAL_UNSOLD",
    ceiling(cast(x.total_unsold as numeric)/@ppacket_szie) pkt 
    from(
    select distinct d.comp_code,d.unit_code,d.branch_code,d.doctype,
    d.publ,p.publ_name, e.main_edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) main_edtn_name,
    d.edtn,e.edtn_name,d.copy_rate,sum(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)+isnull(apr_damage,0)) as TOTAL_UNSOLD
    from cir_unsold_hdr h,cir_unsold_dtl d,cir_agmast m,cir_publ_mast p,cir_edtn_mast e,cir_bill_return_print b
    where h.comp_code=d.comp_code and h.comp_code=m.comp_code and h.comp_code=p.comp_code and h.comp_code=e.comp_code and h.comp_code=b.comp_code and h.comp_code=@pcomp_code and 
    h.unit_code=d.unit_code and h.unit_code=m.unit and h.unit_code=b.unit_code and h.unit_code=@punit_code and 
    h.doctype=d.doctype and h.doctype='UCN' and h.recptno=d.recptno and h.recptno=b.billno and h.recptdt=d.recptdt and h.recptdt=b.billdt and
    h.agcd=isnull(d.sup_agcd,d.agcd) and h.agcd=m.agcd and h.dpcd=isnull(d.sup_dpcd,d.dpcd) and h.dpcd=m.dpcd and d.publ=p.publ and d.publ=e.publ and d.edtn=e.edtn and  
    d.branch_code=@pbran_code and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)+isnull(apr_damage,0))>0 and b.return_copy=@pprocess_idno
    group by d.comp_code,d.unit_code,d.branch_code,d.doctype,d.publ,p.publ_name,e.main_edtn,d.edtn,e.edtn_name,d.copy_rate) x
    order by comp_code,unit_code,publ_name,main_edtn_name,edtn_name,copy_rate;
    
    select getdate() as "CUR_DATE"
    
    delete from cir_bill_return_print where return_copy=@pprocess_idno
    
End

ALTER PROCEDURE cir_branch_received_p1
	@pcompcode       as	varchar(20),
	@punitcode       as	varchar(20),
	@pbranchcode     as	varchar(20),
	@pfrombranch     as	varchar(20),
	@pdoctypeout     as	varchar(20),
	@pdoctypein      as	varchar(20),
	@pfromdate       as	datetime,
	@ptilldate       as	datetime,
	@pdateformat     as	varchar(20),
	@pextra1         as	varchar(20),
	@pextra2         as	varchar(20), 
	@pextra3         as	varchar(20),
	@pextra4         as	varchar(20), 
	@pextra5         as	varchar(20),
	@pextra6         as	varchar(20), 
	@pextra7         as	varchar(20),
	@pextra8         as	varchar(20), 
	@pextra9         as	varchar(20),
	@pextra10        as	varchar(20) 				
AS 
	If @pfrombranch='' Begin
		set @pfrombranch=null
	End
	
    select distinct h.comp_code as "COMP_CODE",h.unit_code as "UNIT_CODE",d.branch_code as "BRANCH_CODE",(select "Branch_Name" from branch_mst where "Branch_Code"=d.branch_code) as "BRANCH_NAME",
    d.oth_branch_code as "OTH_BRANCH",(select "Branch_Name" from branch_mst where "Branch_Code"=d.oth_branch_code) as "OTH_BRANCH_NAME",
    d.recptno as "REF_RECPTNO" ,d.recptdt as "REF_RECPTDT",h.taxi_route_name as "TAXI_ROUTE_NAME", h.taxi_no as "TAXI_NO"
    from cir_branch_return_det d,cir_branch_return_hdr h 
    where h.comp_code=@pcompcode and h.comp_code=d.comp_code and h.unit_code=@punitcode and h.unit_code=d.unit_code and 
    h.doctype=d.doctype and ((h.recptdt between @pfromdate and @ptilldate) or (@pfromdate is null)) and h.recptno=d.recptno and d.branch_code=isnull(@pfrombranch,d.branch_code) and 
    d.oth_branch_code=isnull(@pbranchcode,d.oth_branch_code) and d.doctype=@pdoctypeout and d.recptno+CAST(d.recptdt AS VARCHAR) not in(select branch_refno+CAST(branch_refdt AS VARCHAR) from cir_branch_return_hdr 
    where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctypein)
    order by comp_code,unit_code,ref_recptdt,ref_recptno;


/*****************************************19-dec-2011 Laxman transfer out for malesiya*********************/////////////////////////

//////////////////////updated by garima

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[cir_supply_populate_p]
    @pcomp_code                               VARCHAR(20) ,
    @punit                                    VARCHAR(20) ,
    @pagcd                                    VARCHAR(20) ,
    @pdpcd                                    VARCHAR(20) ,
    @ppubl                                    VARCHAR(20) ,
    @pedtn                                    VARCHAR(20) ,
    @pdateformat                              VARCHAR(20) ,
    @pextra1                                  VARCHAR(4000) ,
    @pextra2                                  VARCHAR(4000) 
AS 
Begin
	if upper(@pextra2)='D' Begin
         select SUPPLY_TYPE_CODE,DBO.CIR_GET_SUPPLY_NAME(COMP_CODE,SUPPLY_TYPE_CODE) SUPPLY_TYPE_NAME,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,
                SUPPLY_WED,SUPPLY_THU,SUPPLY_FRI,SUPPLY_SAT,SUPPLY_SPL1,SUPPLY_SPL2,SUPPLY_FLAG,BASE_SUPPLY,PACKET_SIZE,COMM_CODE,COMM_FLAG,
                LBL_PRINTNO SUPPLY_SEQ,ROUTE_CODE,DBO.CIR_GET_NAME_CIR_ROUTE(COMP_CODE,UNIT,ROUTE_CODE,1,@PDATEFORMAT,'','') ROUTE_NAME, 
                SUBROUTE_CODE ,DBO.CIR_GET_NAME_CIR_SUBROUTE(COMP_CODE,UNIT,ROUTE_CODE,SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBROUTE_NAME,
                SUB_SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBSUBROUTE(COMP_CODE,UNIT,ROUTE_CODE,SUBROUTE_CODE,SUB_SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBSUBROUTE_NAME,
                (select isnull(CIR_SUP_ORDER_LIMIT,0) from preferrences where "comp_code"=@pcomp_code) as "CIR_SUP_ORDER_LIMIT"
                from cir_supply_dis
              where comp_code=@pcomp_code and unit=@punit and agcd=@pagcd and dpcd=@pdpcd and publ=@ppubl and edtn=@pedtn
              order by supply_type_name
		End
    else Begin
         select SUPPLY_TYPE_CODE,DBO.CIR_GET_SUPPLY_NAME(COMP_CODE,SUPPLY_TYPE_CODE) SUPPLY_TYPE_NAME,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,
                SUPPLY_WED,SUPPLY_THU,SUPPLY_FRI,SUPPLY_SAT,SUPPLY_SPL1,SUPPLY_SPL2,SUPPLY_FLAG,BASE_SUPPLY,PACKET_SIZE,COMM_CODE,COMM_FLAG,
                LBL_PRINTNO SUPPLY_SEQ,ROUTE_CODE,DBO.CIR_GET_NAME_CIR_ROUTE(COMP_CODE,UNIT,ROUTE_CODE,1,@PDATEFORMAT,'','') ROUTE_NAME, 
                SUBROUTE_CODE ,DBO.CIR_GET_NAME_CIR_SUBROUTE(COMP_CODE,UNIT,ROUTE_CODE,SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBROUTE_NAME,
                SUB_SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBSUBROUTE(COMP_CODE,UNIT,ROUTE_CODE,SUBROUTE_CODE,SUB_SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBSUBROUTE_NAME,
                (select isnull(CIR_SUP_ORDER_LIMIT,0) from preferrences where "comp_code"=@pcomp_code) as "CIR_SUP_ORDER_LIMIT"
                from cir_supply
              where comp_code=@pcomp_code and unit=@punit and agcd=@pagcd and dpcd=@pdpcd and publ=@ppubl and edtn=@pedtn
              order by supply_type_name
	End
End




*************************************************************end issue*****************************************









*************************************************issue 5717*****************************************************************



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[cir_rep_billing_cir_bill_register_p]
	@pcomp_code			VARCHAR(20) ,
	@punit_code         VARCHAR(20) ,
	@ppubl              VARCHAR(20) ,
	@repty              VARCHAR(20) ,
	@pbill_freq         VARCHAR(20) ,
	@pfrom_billdt       VARCHAR(20) ,
	@ptill_billdt       VARCHAR(20) ,
	@pbillagcd          VARCHAR(20) ,
	@pbilldpcd          VARCHAR(20) ,
	@pdateformat        VARCHAR(20) ,
	@pextra1            VARCHAR(400) ,
	@pextra2            VARCHAR(400) 
AS 
/*select getdate()*/

	DECLARE @vfrdt			DATETIME 
	DECLARE @vtodt			DATETIME 
	declare @v_statecode	VARCHAR(20)
	declare @v_distcode		VARCHAR(20)
	declare @v_citycode		VARCHAR(20)
	declare @v_taluka		VARCHAR(20)

	SET @vfrdt  = dbo.convert_user_date('/', @pfrom_billdt,@pdateformat)
	SET @vtodt  = dbo.convert_user_date('/', @ptill_billdt,@pdateformat)
	If @repty='1' Begin--State
        set @v_statecode=@pextra1
	End
    Else if @repty='2' Begin    --District
        set @v_distcode=@pextra1
    End
    Else if @repty='3' Begin    --Taluka
        set @v_taluka=@pextra1
    End
    Else Begin--City
        set @v_citycode=@pextra1
	End
   
	IF ISNULL(@repty, 'N')= '1' BEGIN --FOR STATE
		select b.comp_code AS "COMP_CODE", b.unit_code AS "UNIT_CODE", b.billno AS "BILLNO", b.billdt AS "BILLDT", b.agcd AS "AGCD", b.dpcd AS "DPCD", 
		min(b.publ) AS "PUBL", sum(b.bill_copy) AS "BILL_COPY", sum(b.gross_amount) AS "GROSS_AMOUNT", sum(b.sur_amt) AS "SUR_AMOUNT", sum(b.comm_amt) AS "COMM_AMOUNT",
		sum(b.bill_amount) AS "BILL_AMOUNT",max(b.bill_flag) AS "BILL_FLAG",null as  "BILL_REMARK", max(b.userid) AS "USERID", max(b.creation_date) AS "CREATION_DATE", 
		b.branch_code AS "BRANCH_CODE",m.ag_name AS "AGENCY_NAME",DBO.cir_get_city(b.comp_code,m.city_code) as "CITY NAME" ,
		DBO.cir_get_state(b.comp_code, m.country_code, m.state_code) as "STATE_NAME"
		from cir_bill_det b,cir_agmast m
		where b.comp_code = @pcomp_code and m.comp_code=b.comp_code and (b.unit_code = isnull(@punit_code,b.unit_code) OR @punit_code='') and 
		m.unit=b.unit_code and (b.agcd = isnull(@pbillagcd,b.agcd) OR @pbillagcd='') and m.agcd=b.agcd and (b.dpcd = isnull(@pbilldpcd,b.dpcd) OR @pbilldpcd='') and  
		m.dpcd=b.dpcd and b.billdt >= @vfrdt and billdt <=@vtodt and (b.bill_flag = isnull(@pbill_freq,b.bill_flag) OR @pbill_freq='') and 
		(b.publ = isnull(@ppubl,b.publ) OR @ppubl='') and (m.state_code=@v_statecode or @v_statecode is null OR @v_statecode='') and (m.dist_code=@v_distcode or @v_distcode is null OR @v_distcode='') and 
		(m.tehsil_taluka=@v_taluka or @v_taluka is null or @v_taluka='') and (m.city_code=@v_citycode or @v_citycode is null or @v_citycode='')
		group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code
		order by comp_code, state_name,agency_name,billdt,billno
	END	
    IF ISNULL(@repty, 'N')= '2'  BEGIN--FOR DISTRICT
		select b.comp_code AS "COMP_CODE", b.unit_code AS "UNIT_CODE", b.billno AS "BILLNO", b.billdt AS "BILLDT", b.agcd AS "AGCD", b.dpcd AS "DPCD", 
		min(b.publ) AS "PUBL", sum(b.bill_copy) AS "BILL_COPY", sum(b.gross_amount) AS "GROSS_AMOUNT", sum(b.sur_amt) AS "SUR_AMOUNT", sum(b.comm_amt) AS "COMM_AMOUNT",
		sum(b.bill_amount) AS "BILL_AMOUNT",max(b.bill_flag) AS "BILL_FLAG",null as  "BILL_REMARK", max(b.userid) AS "USERID", max(b.creation_date) AS "CREATION_DATE", 
		b.branch_code AS "BRANCH_CODE",m.ag_name AS "AGENCY_NAME",DBO.cir_get_city(b.comp_code,m.city_code) as "CITY NAME" ,
		DBO.cir_get_state(b.comp_code, m.country_code, m.state_code) as "STATE_NAME",
		DBO.cir_get_dist(b.comp_code, m.state_code, m.dist_code) as "DIST_NAME"
		from cir_bill_det b,cir_agmast m
		where b.comp_code = @pcomp_code and m.comp_code=b.comp_code and (b.unit_code = isnull(@punit_code,b.unit_code) OR @punit_code='') and 
		m.unit=b.unit_code and (b.agcd = isnull(@pbillagcd,b.agcd) OR @pbillagcd='') and m.agcd=b.agcd and (b.dpcd = isnull(@pbilldpcd,b.dpcd) OR @pbilldpcd='') and  
		m.dpcd=b.dpcd and b.billdt >= @vfrdt and billdt <=@vtodt and (b.bill_flag = isnull(@pbill_freq,b.bill_flag) OR @pbill_freq='') and 
		(b.publ = isnull(@ppubl,b.publ) OR @ppubl='') and (m.state_code=@v_statecode or @v_statecode is null OR @v_statecode='') and (m.dist_code=@v_distcode or @v_distcode is null OR @v_distcode='') and 
		(m.tehsil_taluka=@v_taluka or @v_taluka is null or @v_taluka='') and (m.city_code=@v_citycode or @v_citycode is null or @v_citycode='')
		group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code,m.dist_code
		order by comp_code, state_name,dist_name,agency_name,billdt,billno
	END
	IF ISNULL(@repty, 'N')= '3' BEGIN 		
		select b.comp_code AS "COMP_CODE", b.unit_code AS "UNIT_CODE", b.billno AS "BILLNO", b.billdt AS "BILLDT", b.agcd AS "AGCD", b.dpcd AS "DPCD", 
		min(b.publ) AS "PUBL", sum(b.bill_copy) AS "BILL_COPY", sum(b.gross_amount) AS "GROSS_AMOUNT", sum(b.sur_amt) AS "SUR_AMOUNT", sum(b.comm_amt) AS "COMM_AMOUNT",
		sum(b.bill_amount) AS "BILL_AMOUNT",max(b.bill_flag) AS "BILL_FLAG",null as  "BILL_REMARK", max(b.userid) AS "USERID", max(b.creation_date) AS "CREATION_DATE", 
		b.branch_code AS "BRANCH_CODE",m.ag_name AS "AGENCY_NAME",DBO.cir_get_city(b.comp_code,m.city_code) as "CITY NAME" ,
		DBO.cir_get_state(b.comp_code, m.country_code, m.state_code) as "STATE_NAME",
		DBO.cir_get_taluka(b.comp_code, m.tehsil_taluka) as "TALUKA_NAME"
		from cir_bill_det b,cir_agmast m
		where b.comp_code = @pcomp_code and m.comp_code=b.comp_code and (b.unit_code = isnull(@punit_code,b.unit_code) OR @punit_code='') and 
		m.unit=b.unit_code and (b.agcd = isnull(@pbillagcd,b.agcd) OR @pbillagcd='') and m.agcd=b.agcd and (b.dpcd = isnull(@pbilldpcd,b.dpcd) OR @pbilldpcd='') and  
		m.dpcd=b.dpcd and b.billdt >= @vfrdt and billdt <=@vtodt and (b.bill_flag = isnull(@pbill_freq,b.bill_flag) OR @pbill_freq='') and 
		(b.publ = isnull(@ppubl,b.publ) OR @ppubl='') and (m.state_code=@v_statecode or @v_statecode is null OR @v_statecode='') and (m.dist_code=@v_distcode or @v_distcode is null OR @v_distcode='') and 
		(m.tehsil_taluka=@v_taluka or @v_taluka is null or @v_taluka='') and (m.city_code=@v_citycode or @v_citycode is null or @v_citycode='')
		group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code,m.tehsil_taluka
		order by comp_code, state_name,taluka_name,agency_name,billdt,billno
	END	
	ELSE BEGIN
		select b.comp_code AS "COMP_CODE", b.unit_code AS "UNIT_CODE", b.billno AS "BILLNO", b.billdt AS "BILLDT", b.agcd AS "AGCD", b.dpcd AS "DPCD", 
		min(b.publ) AS "PUBL", sum(b.bill_copy) AS "BILL_COPY", sum(b.gross_amount) AS "GROSS_AMOUNT", sum(b.sur_amt) AS "SUR_AMOUNT", sum(b.comm_amt) AS "COMM_AMOUNT",
		sum(b.bill_amount) AS "BILL_AMOUNT",max(b.bill_flag) AS "BILL_FLAG",null as  "BILL_REMARK", max(b.userid) AS "USERID", max(b.creation_date) AS "CREATION_DATE", 
		b.branch_code AS "BRANCH_CODE",m.ag_name AS "AGENCY_NAME",DBO.cir_get_city(b.comp_code,m.city_code) as "CITY NAME" ,
		DBO.cir_get_state(b.comp_code, m.country_code, m.state_code) as "STATE_NAME"
		from cir_bill_det b,cir_agmast m
		where b.comp_code = @pcomp_code and m.comp_code=b.comp_code and (b.unit_code = isnull(@punit_code,b.unit_code) OR @punit_code='') and 
		m.unit=b.unit_code and (b.agcd = isnull(@pbillagcd,b.agcd) OR @pbillagcd='') and m.agcd=b.agcd and (b.dpcd = isnull(@pbilldpcd,b.dpcd) OR @pbilldpcd='') and  
		m.dpcd=b.dpcd and b.billdt >= @vfrdt and billdt <=@vtodt and (b.bill_flag = isnull(@pbill_freq,b.bill_flag) OR @pbill_freq='') and 
		(b.publ = isnull(@ppubl,b.publ) OR @ppubl='') and (m.state_code=@v_statecode or @v_statecode is null OR @v_statecode='') and (m.dist_code=@v_distcode or @v_distcode is null OR @v_distcode='') and 
		(m.tehsil_taluka=@v_taluka or @v_taluka is null or @v_taluka='') and (m.city_code=@v_citycode or @v_citycode is null or @v_citycode='')
		group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code
		order by comp_code, state_name,"CITY NAME",agency_name,billdt,billno	
	END	




**************************************************************************end isssue*******************************************************


ALTER PROCEDURE [dbo].[cir_publ_bind_cir_publ_bind_p]
	@pcomp_code                               VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
	
AS 
	
		SELECT *
		FROM  cir_publ_mast 
		WHERE	 comp_code  = @pcomp_code
		 AND	((UPPER(publ_name)  like UPPER(@pextra1) + '%')
		 OR	(@pextra1  is null)) 
and (publ =@pextra2  or @pextra2  ='')
order by publ_name;

/***********************************************************************/


ALTER PROCEDURE [dbo].[cir_edtion_bind_cir_mian_edtion_pick_bind_p]
	@pcomp_code                               VARCHAR(20) ,
	@ppubl_code                               VARCHAR(20) ,
	@pedtn_code                               VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 


AS 

		SELECT *
		FROM  cir_edtn_mast 
		WHERE	 comp_code  = @pcomp_code
		 AND	publ  = @ppubl_code
		 AND	edtn  in
			(SELECT main_edtn FROM  cir_edtn_mast 
			WHERE	 comp_code  = @pcomp_code
			 AND	publ  = @ppubl_code
			 AND	edtn  <> ISNULL(main_edtn, '/')
			 AND	edtn  = @pedtn_code)
		 AND	ISNULL(freeze_flag, 'N')  = 'N' and (unit_code=@pextra2 or @pextra2 is null or @pextra2='')
		ORDER BY EDTN_SEQ_NO 



/**********************************************************************************/


ALTER PROCEDURE cir_agency_bind_cir_agency_bind_p
	@pcompcode			VARCHAR(20) ,
	@punit              VARCHAR(20) ,
	@pdateformat        VARCHAR(20) ,
	@pextra1            VARCHAR(4000) ,
	@pextra2            VARCHAR(4000) 
AS 
BEGIN
	If UPPER(@pextra2)='D' Begin
			
		SELECT cir_agmast_dis.*,dbo.cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.agcd,cir_agmast_dis.dpcd) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.agcd,cir_agmast_dis.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.station_code,1) as "DROP_POINT_NAME"
		FROM  cir_agmast_dis 
		WHERE comp_code  = @pcompcode AND unit  = @punit
		 AND ((UPPER(ag_name)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
		 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/
		union
		SELECT cir_agmast_dis.*,dbo.cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.agcd,cir_agmast_dis.dpcd) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.agcd,cir_agmast_dis.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.station_code,1) as "DROP_POINT_NAME"
		FROM  cir_agmast_dis 
		WHERE comp_code  = @pcompcode AND unit  = @punit
		 AND ((UPPER(agcd)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
		 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/
		ORDER BY 5
	End
	Else Begin
		SELECT cir_agmast.*,dbo.cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.station_code,1) as "DROP_POINT_NAME"
			FROM  cir_agmast 
			WHERE comp_code  = @pcompcode AND unit  = @punit
			 AND ((UPPER(ag_name)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
			 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/
		union
		SELECT cir_agmast.*,dbo.cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.station_code,1) as "DROP_POINT_NAME"
			FROM  cir_agmast 
			WHERE comp_code  = @pcompcode AND unit  = @punit
			 AND ((UPPER(agcd)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
			 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/			 
			ORDER BY 5
	End
END

/************************************************************************/



ALTER PROCEDURE [dbo].[cir_edtion_bind_cir_sub_edtion_bind_p]
	@pcomp_code                               VARCHAR(20) ,
	@ppubl_code                               VARCHAR(20) ,
	@pedtn_code                               VARCHAR(20) ,
	@psubedtn_code                            VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
BEGIN

select * from cir_edtn_mast
where comp_code = @pcomp_code 
and publ = @ppubl_code 
and (edtn=@psubedtn_code or @psubedtn_code is null OR @psubedtn_code = '' ) 
and (main_edtn=@pedtn_code or @pedtn_code is null OR  @pedtn_code = '')
and edtn<>main_edtn and ISNULL(freeze_flag,'N')='N'   
and (unit_code=@pextra2 or @pextra2 is null or  @pextra2 = '')
order by edtn_name;

END

/**************************************************************************/



ALTER PROCEDURE  [dbo].[cir_agency_type_bind]

 @pcomp_code as varchar(200),
 @pdateformat as varchar(200),
 @pextra1 as varchar(200),
 @pextra2 as varchar(200)

 AS
  select * from cir_agency_typ_mast 
                             where comp_code=@pcomp_code and
                                    	ISNULL(freeze_flag,'N')='N'
                             order by agency_type_code




/***********************************************************************************/

ALTER procedure [dbo].[cir_agency_class_bind_p] 
 
     @pcomp_code as varchar(200),
     @pdateformat as varchar(200),
     @pextra1 as varchar(200),
     @pextra2 as varchar(200)
  as   
 Begin
 
            select * from cir_agency_class_mast
                  where comp_code=@pcomp_code 
                  order by class_code;

END


/*******************************************************************************/




ALTER PROCEDURE [dbo].[Cir_Supply_Type_Bind_p]
	@pcomp_code                               VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
	
		SELECT *
		FROM  cir_supply_type_mast 
		WHERE	 comp_code  = @pcomp_code
		ORDER BY sup_seq_no,
			 sup_ty_name 
		
/*************************************************************************************/


ALTER PROCEDURE [dbo].[cir_edtion_bind_cir_sub_edtion_bind_p]
	@pcomp_code                               VARCHAR(20) ,
	@ppubl_code                               VARCHAR(20) ,
	@pedtn_code                               VARCHAR(20) ,
	@psubedtn_code                            VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
BEGIN

select * from cir_edtn_mast
where comp_code = @pcomp_code 
and publ = @ppubl_code 
and (edtn=@psubedtn_code or @psubedtn_code is null OR @psubedtn_code = '' ) 
and (main_edtn=@pedtn_code or @pedtn_code is null OR  @pedtn_code = '')
and edtn<>main_edtn and ISNULL(freeze_flag,'N')='N'   
and (unit_code=@pextra2 or @pextra2 is null or  @pextra2 = '')
order by edtn_name;

END


/*****************************************************************************/

/*****************************Laxman 21-dec-2011************************/

ALTER PROCEDURE  [dbo].[cir_one_day_supply_change_p]
	@pcomp_code		as varchar(200),
	@punit_code     as varchar(200),
	@ppubl_code     as varchar(200),
	@pedtn_code     as varchar(200),
	@psup_type      as varchar(200),
	@psup_date      as datetime,
	@pagcd_code     as varchar(200),
	@pdpcd_code     as varchar(200),
	@pzone_code     as varchar(200),--for zone
	@pregion_code   as varchar(200),--for region
	@pcomm_category as varchar(200),--for commition category
	@pstate_code    as varchar(200),--for state
	@pdist_code     as varchar(200),--for district
	@ptaluka_code   as varchar(200),--for taluka
	@pcity_code     as varchar(200),--for city
	@proute_code    as varchar(200),--for route
	@pbran_code     as varchar(200),--for branch
	@pagency_type   as varchar(200),--for agency type
	@pagency_class  as varchar(200),--for agency class
	@pdateformat    as varchar(200),
	@pextra1        as varchar(200),--1 for  edition route wise,2 for edition district wise
	@pextra2        as varchar(200),--D for distribution agency
	@pextra3        as varchar(200),
	@pextra4        as varchar(200),
	@pextra5        as varchar(200),
	@pextra6        as varchar(200),
	@pextra7        as varchar(200),
	@pextra8        as varchar(200),
	@pextra9        as varchar(200),
	@pextra10       as varchar(200)
AS 
	If @punit_code='' Begin
		set @punit_code=null
	End
	If @ppubl_code='' Begin
		set @ppubl_code=null
	End
	If @pedtn_code='' Begin
		set @pedtn_code=null
	End
	If @psup_type='' Begin
		set @psup_type=null
	End
	If @pagcd_code='' Begin
		set @pagcd_code=null
	End
	If @pdpcd_code='' Begin
		set @pdpcd_code=null
	End
	If @pzone_code='' Begin
		set @pzone_code=null
	End
	If @pregion_code='' Begin
		set @pregion_code=null
	End
	If @pcomm_category='' Begin
		set @pcomm_category=null
	End
	If @pstate_code='' Begin
		set @pstate_code=null
	End
	
	If @pdist_code='' Begin
		set @pdist_code=null
	End
	If @ptaluka_code='' Begin
		set @ptaluka_code=null
	End
	If @pcity_code='' Begin
		set @pcity_code=null
	End
	If @proute_code='' Begin
		set @proute_code=null
	End
	If @pbran_code='' Begin
		set @pbran_code=null
	End
	If @pagency_type='' Begin
		set @pagency_type=null
	End
	If @pagency_class='' Begin
		set @pagency_class=null
	End
	If @proute_code='' Begin
		set @proute_code=null
	End		

  if upper(@pextra2)='D' Begin
      select c.comp_code as "COMP_CODE",c.unit_code as "UNIT_CODE",a.agcd as "AGCD",a.dpcd as "DPCD",a.ag_name as "AGENCY_NAME",
      a.ag_name_oth_lang as "AGENCY_NAME_OTHER_LANG",a.city_code as "CITY_CODE",
        dbo.cir_get_city(a.comp_code,a.city_code) as "CITY_NAME",a.station_code as "DROP_POINT_CODE",
        dbo.cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,'1') as "DROP_POINT_NAME",
        c.sup_copy as "SUP_COPY",dbo.cir_get_route_seqno(c.comp_code,c.unit_code,c.route_code) as "ROUTE_SEQ",
        dbo.cir_get_supply_seqno(c.comp_code,c.unit_code,c.publ,c.edtn,c.agcd,c.dpcd) as "SUPPLY_SEQ",
        c.publ as "PUBL",p.publ_name as "PUBL_NAME",e.main_edtn as "MAIN_EDTN",dbo.cir_get_edtn_name(c.comp_code,e.main_edtn) as "MAIN_EDTN_NAME",
        c.edtn as "EDTN",e.edtn_name as "EDTN_NAME",c.sup_type_code as "SUP_TYPE_CODE", b.sup_ty_name as "SUP_TY_NAME",
        s.base_supply as "BASE_SUPPLY", s.supply_sun as "SUPPLY_SUN", s.supply_mon as "SUPPLY_MON", s.supply_tue as "SUPPLY_TUE", 
        s.supply_wed as "SUPPLY_WED", s.supply_thu as "SUPPLY_THU", s.supply_fri as "SUPPLY_FRI", s.supply_sat as "SUPPLY_SAT",upper(CONVERT(VARCHAR(20),DATENAME(WEEKDAY, c.supdate),20)) as "SUPDAY", 
        (select sum(c.sup_copy) sup_copy from cir_agmast_dis a,cir_supply_type_mast b,cir_dbksup_dis c
        where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=@pcomp_code and
              a.unit=c.unit_code and a.unit=isnull(@punit_code,a.unit) and b.sup_ty_code=c.sup_type_code and
              c.publ=isnull(@ppubl_code,c.publ) and c.edtn = isnull(@pedtn_code,c.edtn) and c.supdate=@psup_date and 
              a.agcd=c.agcd and a.dpcd=c.dpcd and a.agcd=isnull(@pagcd_code,a.agcd) and a.dpcd=isnull(@pdpcd_code,a.dpcd) and c.sup_type_code=isnull(@psup_type,c.sup_type_code)) as "TOTAL_SUPPLY",
         c.final_supply_flag as "FINAL_SUPPLY_FLAG"
      from cir_agmast_dis a,cir_supply_type_mast b,cir_dbksup_dis c,cir_publ_mast p,cir_edtn_mast e,cir_supply_dis s
      where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=p.comp_code and a.comp_code=e.comp_code and a.comp_code=s.comp_code and a.comp_code=@pcomp_code and
         a.unit=c.unit_code and a.unit=s.unit and a.unit=isnull(@punit_code,a.unit) and b.sup_ty_code=c.sup_type_code and
         c.publ=p.publ and c.publ=e.publ and c.publ=s.publ and c.publ=isnull(@ppubl_code,c.publ) and c.edtn=e.edtn and c.edtn=s.edtn and c.edtn = isnull(@pedtn_code,c.edtn) and 
         c.supdate=@psup_date and a.agcd=c.agcd and a.dpcd=c.dpcd and
         a.agcd=s.agcd and a.agcd=isnull(@pagcd_code,a.agcd) and a.dpcd=s.dpcd and a.dpcd=isnull(@pdpcd_code,a.dpcd) and c.sup_type_code=s.supply_type_code and c.sup_type_code=isnull(@psup_type,c.sup_type_code) and
         (c.agency_ty_code = @pagency_type or @pagency_type is null) and
         (c.comm_code = @pcomm_category or @pcomm_category is null) and
         (c.route_code = @proute_code or @proute_code is null) and
         (a.state_code = @pstate_code or @pstate_code is null) and
         (a.dist_code = @pdist_code or @pdist_code is null) and
         (a.tehsil_taluka = @ptaluka_code or @ptaluka_code is null) and
         (a.branch_code = @pbran_code or @pbran_code is null) and
         a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcity_code,city_code) and 
         (zone_code = @pzone_code or @pzone_code is null) and (region_code = @pregion_code or @pregion_code is null))
         order by route_seq,supply_seq,agency_name
  End       
  else Begin
      if @pextra1=2 Begin---for edition district and agency wise
          select c.comp_code as "COMP_CODE",c.unit_code as "UNIT_CODE",a.agcd as "AGCD",a.dpcd as "DPCD",a.ag_name as "AGENCY_NAME",a.ag_name_oth_lang as "AGENCY_NAME_OTHER_LANG",a.city_code as "CITY_CODE",
                dbo.cir_get_city(a.comp_code,a.city_code) as "CITY_NAME",a.station_code as "DROP_POINT_CODE",dbo.cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,'1') as "DROP_POINT_NAME",
                c.sup_copy as "SUP_COPY",dbo.cir_get_route_seqno(c.comp_code,c.unit_code,c.route_code) as "ROUTE_SEQ",
                dbo.cir_get_supply_seqno(c.comp_code,c.unit_code,c.publ,c.edtn,c.agcd,c.dpcd) as "SUPPLY_SEQ",
                c.publ as "PUBL",p.publ_name as "PUBL_NAME",e.main_edtn as "MAIN_EDTN",dbo.cir_get_edtn_name(c.comp_code,e.main_edtn) as "MAIN_EDTN_NAME",
                c.edtn as "EDTN",e.edtn_name as "EDTN_NAME",c.sup_type_code as "SUP_TYPE_CODE", b.sup_ty_name as "SUP_TY_NAME",
                s.base_supply as "BASE_SUPPLY", s.supply_sun as "SUPPLY_SUN", s.supply_mon as "SUPPLY_MON", s.supply_tue as "SUPPLY_TUE", 
                s.supply_wed as "SUPPLY_WED", s.supply_thu as "SUPPLY_THU", s.supply_fri as "SUPPLY_FRI", s.supply_sat as "SUPPLY_SAT",upper(CONVERT(VARCHAR(20),DATENAME(WEEKDAY, c.supdate),20)) as "SUPDAY",
                (select sum(c.sup_copy) sup_copy from cir_agmast a,cir_supply_type_mast b,cir_dbksup c
        where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=@pcomp_code and
              a.unit=c.unit_code and a.unit=isnull(@punit_code,a.unit) and b.sup_ty_code=c.sup_type_code and
              c.publ=isnull(@ppubl_code,c.publ) and c.edtn = isnull(@pedtn_code,c.edtn) and c.supdate=@psup_date and 
              a.agcd=c.agcd and a.dpcd=c.dpcd and a.agcd=isnull(@pagcd_code,a.agcd) and a.dpcd=isnull(@pdpcd_code,a.dpcd) and 
              c.sup_type_code=isnull(@psup_type,c.sup_type_code)) as "TOTAL_SUPPLY",c.final_supply_flag as "FINAL_SUPPLY_FLAG",
              d.dist_name as "DIST_NAME"
          from cir_agmast a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,
               cir_supply_type_mast b,cir_dbksup c,cir_publ_mast p,cir_edtn_mast e,cir_supply s
          where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=p.comp_code and a.comp_code=e.comp_code and a.comp_code=s.comp_code and a.comp_code=@pcomp_code and
         a.unit=c.unit_code and a.unit=s.unit and a.unit=isnull(@punit_code,a.unit) and b.sup_ty_code=c.sup_type_code and
         c.publ=p.publ and c.publ=e.publ and c.publ=s.publ and c.publ=isnull(@ppubl_code,c.publ) and c.edtn=e.edtn and c.edtn=s.edtn and c.edtn = isnull(@pedtn_code,c.edtn) and 
         c.supdate=@psup_date and a.agcd=c.agcd and a.dpcd=c.dpcd and
         a.agcd=s.agcd and a.agcd=isnull(@pagcd_code,a.agcd) and a.dpcd=s.dpcd and a.dpcd=isnull(@pdpcd_code,a.dpcd) and c.sup_type_code=s.supply_type_code and c.sup_type_code=isnull(@psup_type,c.sup_type_code) and
         (c.agency_ty_code = @pagency_type or @pagency_type is null) and
         (c.comm_code = @pcomm_category or @pcomm_category is null) and
         (c.route_code = @proute_code or @proute_code is null) and
         (a.state_code = @pstate_code or @pstate_code is null) and
         (a.dist_code = @pdist_code or @pdist_code is null) and
         (a.tehsil_taluka = @ptaluka_code or @ptaluka_code is null) and
         (a.branch_code = @pbran_code or @pbran_code is null) and
         a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcity_code,city_code) and 
         (zone_code = @pzone_code or @pzone_code is null) and (region_code = @pregion_code or @pregion_code is null))
         order by dist_name,agency_name,supply_seq
          
   End         
      else Begin
		select c.comp_code as "COMP_CODE",c.unit_code as "UNIT_CODE",a.agcd as "AGCD",a.dpcd as "DPCD",a.ag_name as "AGENCY_NAME",
		  a.ag_name_oth_lang as "AGENCY_NAME_OTHER_LANG",a.city_code as "CITY_CODE",
			dbo.cir_get_city(a.comp_code,a.city_code) as "CITY_NAME",a.station_code as "DROP_POINT_CODE",
			dbo.cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,'1') as "DROP_POINT_NAME",
			c.sup_copy as "SUP_COPY",dbo.cir_get_route_seqno(c.comp_code,c.unit_code,c.route_code) as "ROUTE_SEQ",
			dbo.cir_get_supply_seqno(c.comp_code,c.unit_code,c.publ,c.edtn,c.agcd,c.dpcd) as "SUPPLY_SEQ",
			c.publ as "PUBL",p.publ_name as "PUBL_NAME",e.main_edtn as "MAIN_EDTN",dbo.cir_get_edtn_name(c.comp_code,e.main_edtn) as "MAIN_EDTN_NAME",
			c.edtn as "EDTN",e.edtn_name as "EDTN_NAME",c.sup_type_code as "SUP_TYPE_CODE", b.sup_ty_name as "SUP_TY_NAME",
			s.base_supply as "BASE_SUPPLY", s.supply_sun as "SUPPLY_SUN", s.supply_mon as "SUPPLY_MON", s.supply_tue as "SUPPLY_TUE", 
			s.supply_wed as "SUPPLY_WED", s.supply_thu as "SUPPLY_THU", s.supply_fri as "SUPPLY_FRI", s.supply_sat as "SUPPLY_SAT",upper(CONVERT(VARCHAR(20),DATENAME(WEEKDAY, c.supdate),20)) as "SUPDAY", 
			(select sum(c.sup_copy) sup_copy from cir_agmast a,cir_supply_type_mast b,cir_dbksup c
			where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=@pcomp_code and
				  a.unit=c.unit_code and a.unit=isnull(@punit_code,a.unit) and b.sup_ty_code=c.sup_type_code and
				  c.publ=isnull(@ppubl_code,c.publ) and c.edtn = isnull(@pedtn_code,c.edtn) and c.supdate=@psup_date and 
				  a.agcd=c.agcd and a.dpcd=c.dpcd and
				  a.agcd=isnull(@pagcd_code,a.agcd) and a.dpcd=isnull(@pdpcd_code,a.dpcd) and c.sup_type_code=isnull(@psup_type,c.sup_type_code)) as "TOTAL_SUPPLY",
			 c.final_supply_flag as "FINAL_SUPPLY_FLAG"
		  from cir_agmast a,cir_supply_type_mast b,cir_dbksup c,cir_publ_mast p,cir_edtn_mast e,cir_supply s
		  where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=p.comp_code and a.comp_code=e.comp_code and a.comp_code=s.comp_code and a.comp_code=@pcomp_code and
			 a.unit=c.unit_code and a.unit=s.unit and a.unit=isnull(@punit_code,a.unit) and b.sup_ty_code=c.sup_type_code and
			 c.publ=p.publ and c.publ=e.publ and c.publ=s.publ and c.publ=isnull(@ppubl_code,c.publ) and c.edtn=e.edtn and c.edtn=s.edtn and c.edtn = isnull(@pedtn_code,c.edtn) and 
			 c.supdate=@psup_date and a.agcd=c.agcd and a.dpcd=c.dpcd and
			 a.agcd=s.agcd and a.agcd=isnull(@pagcd_code,a.agcd) and a.dpcd=s.dpcd and a.dpcd=isnull(@pdpcd_code,a.dpcd) and c.sup_type_code=s.supply_type_code and c.sup_type_code=isnull(@psup_type,c.sup_type_code) and
			 (c.agency_ty_code = @pagency_type or @pagency_type is null) and
			 (c.comm_code = @pcomm_category or @pcomm_category is null) and
			 (c.route_code = @proute_code or @proute_code is null) and
			 (a.state_code = @pstate_code or @pstate_code is null) and
			 (a.dist_code = @pdist_code or @pdist_code is null) and
			 (a.tehsil_taluka = @ptaluka_code or @ptaluka_code is null) and
			 (a.branch_code = @pbran_code or @pbran_code is null) and
			 a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcity_code,city_code) and 
			 (zone_code = @pzone_code or @pzone_code is null) and (region_code = @pregion_code or @pregion_code is null))
			 order by route_seq,supply_seq,agency_name
	End
End   
/******************laxman 21-dec-2011*******************************/

/********************************22-dec-2011*********************/
ALTER  procedure [dbo].[cir_fetch_expenses_data_p]
    @pcompcode       as varchar(20),
    @pagtype         as varchar(20),
    @pagclass        as varchar(20),
    @ppublcode       as varchar(20),
    @pmedtncode      as varchar(20),
    @pedtncode       as varchar(20),
    @psup_type       as varchar(20),
    @pagcd           as varchar(20),
    @pdpcd           as varchar(20),
    @pexptype        as varchar(20),
    @pcode           as varchar(4000),--for related code string 
    @pprocesstype    as varchar(20),--for process by Zone.Region,Branch,District,Route
    @pfreqtype       as varchar(20),--for frequency type (daily/weekly/monthly)
    @pdatefrom       as datetime,
    @pdatetill       as datetime,
    @pdelimiter      as varchar(20),
    @puserid         as varchar(20),
    @pdateformat     as varchar(20),
    @pextra1         as varchar(200),
    @pextra2         as varchar(200),
    @pextra3         as varchar(200),
    @pextra4         as varchar(200),
    @pextra5         as varchar(200)
  As
    declare @vlength     numeric(7);
    declare @vrunval     varchar(8000);
    declare @v_val       varchar(800);
    declare @v_name      varchar(8000);
    declare @v_sname     varchar(8000);
    declare @vno         int
    declare @v_doctype   varchar(10)
    set @v_doctype='CN'
    declare @v_recptdt		as datetime

	If @pagtype='' Begin
		set @pagtype=null
	End
	If @pagclass='' Begin
		set @pagclass=null
	End
	If @psup_type='' Begin
		set @psup_type=null
	End
	If @pagcd='' Begin
		set @pagcd=null
	End
	If @pdpcd='' Begin
		set @pdpcd=null
	End
	If @pcode='' Begin
		set @pcode=null
	End
	If @pprocesstype='' Begin
		set @pprocesstype=null
	End
	If @pfreqtype='' Begin
		set @pfreqtype=null
	End
	If @pextra1='' Begin
		set @pextra1=null
	End									
	If @pextra2='' Begin
		set @pextra2=null
	End
	If @pextra3='' Begin
		set @pextra3=null
	End									
	If @pextra4='' Begin
		set @pextra4=null
	End
	If @pextra5='' Begin
		set @pextra5=null
	End

	CREATE TABLE #CIR_LEDGER_REPORT
	( COMP_CODE			VARCHAR(100),
	  UNIT_CODE			VARCHAR(100),
	  DEBIT_HEAD		VARCHAR(100),
	  REC_SEQNO			INT)
	  	
	declare @v1_comp_code		as varchar(20)
	declare @v1_unit_code		as varchar(20)
	declare @v1_agcd			as varchar(20)
	declare @v1_dpcd			as varchar(20)
	declare @v1_agency_name		as varchar(200)
	declare @v1_station_code	as varchar(20)
	declare @v1_city_code		as varchar(20)
	declare @v1_exp_type_code	as varchar(20)
	declare @v1_exp_type_desc	as varchar(20)
	
    declare @v1_exp_type_mode	as varchar(20)
    declare @v1_exp_calc_type	as varchar(20)
    declare @v1_exp_amount		as numeric(15,2)
    declare @v1_cn_through		as varchar(20)
    declare @v1_valid_days		as int
    declare @v1_sup_copy		as numeric(10)
    declare @v1_publ			as varchar(20)
    declare @v1_edtn			as varchar(20)
    declare @v1_sup_type_code	as varchar(20)
    declare @v1_exp_reason		as varchar(20)
    declare @v1_billagcd		as varchar(20)
    declare @v1_billdpcd		as varchar(20)
    
    DECLARE c1 cursor FOR
        select m.comp_code,d.unit_code,m.agcd,m.dpcd,m.ag_name agency_name,m.station_code,m.city_code,e.exp_type_code,t.exp_type_desc,
        e.exp_type_mode,case when e.exp_type_mode='F' then 'Fix' else e.exp_type_mode end exp_calc_type,e.exp_amount exp_amount,
        e.cn_through,e.valid_days,sum(d.sup_copy) sup_copy, d.publ publ,d.edtn edtn ,d.sup_type_code sup_type_code,t.exp_reason exp_reason,d.billagcd billagcd,
        d.billdpcd billdpcd
        from cir_agmast m,cir_expenses_detail e,cir_expenses_type_mast t,cir_dbksup d,cir_edtn_mast c
        where m.comp_code=e.comp_code and m.comp_code=t.comp_code and m.comp_code=d.comp_code and m.comp_code=c.comp_code and m.comp_code=@pcompcode and 
        m.unit=e.unit and m.unit=d.unit_code and m.agcd=e.agcd and m.agcd=d.agcd and m.dpcd=e.dpcd and m.dpcd=d.dpcd and 
        e.exp_type_code=t.exp_type_code and e.publ_code=d.publ and e.publ_code=c.publ and e.publ_code=isnull(@ppublcode,e.publ_code) and 
        e.edtn_code=d.edtn and e.edtn_code=c.edtn and e.edtn_code=isnull(@pedtncode,e.edtn_code) and c.main_edtn=isnull(@pmedtncode,c.main_edtn) and
        e.supply_type=d.sup_type_code and e.supply_type=isnull(@psup_type,e.supply_type) and e.exp_frequency=isnull(@pfreqtype,e.exp_frequency)
        and d.supdate between @pdatefrom and @pdatetill and isnull(e.freeze_flag,'N')='N'
        group by m.comp_code,d.unit_code,m.agcd,m.dpcd,m.ag_name,m.station_code,m.city_code,e.exp_type_code,t.exp_type_desc,
        e.exp_type_mode,e.exp_type_mode,e.exp_amount,e.cn_through,e.valid_days,d.publ,d.edtn,t.exp_reason,d.sup_type_code,d.billagcd,d.billdpcd
        order by agency_name,exp_type_desc,publ,edtn,sup_type_code;

    declare @v_amt           numeric(15,2)
    declare @v_remark        varchar(500)
    declare @v_recptno       varchar(50)
    declare @v_dsign         numeric(5)
    
    declare @v_bran_code     varchar(20)
    declare @v_rec_no        numeric(10)  
    declare @v_unsold_copy   numeric(10)
    declare @vdistcode       varchar(4000)
    declare @v_process_id    numeric(30)

    set @v_recptdt   =@pdatetill
  
    /*if @pcode is not null Begin
        set @vdistcode=@pcode+',';

        set @vlength =null set @v_val =null set @v_name=null set @vrunval =null set @vno=null
        set @v_val   =replace(@vdistcode,',',',')
        set @vlength =length(@v_val)
        set @vno=1

        for i in 1.. vlength loop
            set @vrunval=substring(@v_val,i,1)
            If @vrunval!=',' Begin
                set @v_name:=@v_name+@vrunval
            End    
            Else Begin
                insert into CIR_LEDGER_REPORT(comp_code ,unit_code ,debit_head,credit_head,rec_seqno,sess_id)
                        values (pcompcode,null,v_name,null,vno,userenv('sessionid'));
                set @vno=@vno+1
                set @v_name=''
            End
        End
    End*/
    
    exec cir_generate_processid @pcompcode,@puserid,@pdateformat,null,null,null,null,null,@v_process_id OUTPUT
    
    open c1
        fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_agcd,@v1_dpcd,@v1_agency_name,@v1_station_code,@v1_city_code,@v1_exp_type_code,@v1_exp_type_desc,
			@v1_exp_type_mode,@v1_exp_calc_type,@v1_exp_amount,@v1_cn_through,@v1_valid_days,@v1_sup_copy, @v1_publ,@v1_edtn ,@v1_sup_type_code,@v1_exp_reason,@v1_billagcd,@v1_billdpcd
        WHILE (@@FETCH_STATUS = 0) BEGIN 
			If @v1_exp_type_mode='P' Begin
				set @v_amt=round(isnull(@v1_sup_copy,0)*(isnull(@v1_exp_amount,0)/100),2)
			End	
			Else Begin
				set @v_amt=round(isnull(@v1_sup_copy,0)*isnull(@v1_exp_amount,0),2)
			End
			If isnull(@v_amt,0)<>0 Begin
				insert into cir_inct_process_det_temp(comp_code,unit_code,publ_code,edtn_code,sup_type_code,from_pdate,till_pdate,
								agcd,dpcd,tot_supply,from_supply,till_supply,inct_rate,calc_type,amount,
								doctype,recptdt,recptno,bilagcd,bildpcd,created_by,tran_type,reason,exp_type_code)
						values(@v1_comp_code,@v1_unit_code,@v1_publ,@v1_edtn,@v1_sup_type_code,@pdatefrom,@pdatetill,
								@v1_agcd,@v1_dpcd,isnull(@v1_sup_copy,0),0,0,@v1_exp_amount,@v1_exp_type_mode,@v_amt,
								@v_doctype,@v_recptdt,@v_process_id,@v1_billagcd,@v1_billdpcd,@puserid,'EXP',@v1_exp_reason,@v1_exp_type_code);
			End
		fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_agcd,@v1_dpcd,@v1_agency_name,@v1_station_code,@v1_city_code,@v1_exp_type_code,@v1_exp_type_desc,
			@v1_exp_type_mode,@v1_exp_calc_type,@v1_exp_amount,@v1_cn_through,@v1_valid_days,@v1_sup_copy, @v1_publ,@v1_edtn ,@v1_sup_type_code,@v1_exp_reason,@v1_billagcd,@v1_billdpcd
		End
   close c1
   deallocate c1

   set @v_amt=0

    select s.comp_code as "COMP_CODE",s.unit_code AS "UNIT_CODE",s.recptno as "RECPTNO",s.recptdt as "RECPTDT",s.doctype as "DOCTYPE", 
    s.bilagcd AS "AGCD",s.bildpcd AS "DPCD",m.ag_name AS "AG_NAME",
    dbo.cir_get_drop_point_name(s.comp_code,s.unit_code,m.station_code,1) as "DROP_POINT_NAME",
    dbo.cir_get_city(s.comp_code,m.city_code) as "CITY_NAME",
    sum(s.tot_supply) as "SUPPLY",
    s.publ_code as "PUBL_CODE" ,dbo.cir_get_publ_name(s.comp_Code,s.publ_code) as "PUBL_NAME",
    s.inct_rate AS "EXP_RATE",s.calc_type as "CALC_TYPE",sum(s.amount) as "AMOUNT"
    from cir_inct_process_det_temp s,cir_agmast m,cir_edtn_mast e
    where s.comp_code=m.comp_code and s.comp_code=e.comp_code and s.edtn_code=e.edtn and 
    s.unit_code=m.unit and s.bilagcd=m.agcd and s.bildpcd=m.dpcd and s.recptno=@v_process_id and tran_type='EXP'
    group by s.comp_code,s.unit_code,s.recptno,s.recptdt,s.doctype,s.inct_rate,s.calc_type,
    s.bilagcd,s.bildpcd,m.station_code,m.city_code,m.ag_name,s.publ_code
    having sum(amount)>0
    order by comp_code,unit_code,bilagcd,bildpcd,publ_name
   
   
   select getdate() as "CUR_DATE"
   
   drop table #cir_ledger_report;



///===========================================issue no.6016 22/12/2011=======================================================

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[cir_get_pubcenter] (
@pcomp_code      as  varchar(20),
@pubcent_code    as  varchar(20),
@puserid         as  varchar(20),
@pdateformat     as  varchar(20),
@pextra1         as  varchar(20),
@pextra2         as  varchar(20))
returns varchar(200) as
begin
	declare @vcentname varchar(200)

	select @vcentname="Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=@pubcent_code

	return isnull(@vcentname,'')
end
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/**********************Laxman 22-dec-2011******************************/
create procedure cir_prov_receipt_id
    @pcompcode		as	VARCHAR(40) ,
    @pbranchcode    as	VARCHAR(40) ,
    @pdoctype       as	VARCHAR(40) ,
    @precptdt       as	VARCHAR(40) ,
    @pdateformat    as	VARCHAR(40) ,
    @pextra1        as	VARCHAR(40) ,
    @pextra2        as	VARCHAR(40),
    @pextra3        as	varchar(40),
    @pextra4        as	varchar(40),
    @pextra5        as	varchar(40) 
AS 
        DECLARE @vno			NUMERIC(20) 
        DECLARE @vrecptno       VARCHAR(15) 
        DECLARE @v_dt           DATETIME 

        SET @v_dt  =   dbo.convert_user_date('/', @precptdt,@pdateformat) 

		SELECT @vno  =  CAST( MAX(SUBSTRING(recptno, 5, 8))AS NUMERIC) + 1
		FROM  cir_rcphdr_prov 
		WHERE comp_code  = @pcompcode AND doctype  = @pdoctype
		AND  CONVERT(VARCHAR(23), recptdt)  = CONVERT(VARCHAR(23), @v_dt)
		AND  branch_code  = @pbranchcode
        
        IF ISNULL(@vno, 0)= 0 
			BEGIN 
				SET @vrecptno  = @pbranchcode + '-' + REPLACE(CONVERT(VARCHAR(5), GETDATE(), 2), '.', '')+ '0001' 
			END
        ELSE
			BEGIN 
				SET @vrecptno  = @pbranchcode + '-' + dbo.fnPadLeft('0',8,@vno) 
			END
   
        SELECT @vrecptno as VAR_CODE

/**********************Laxman 22-dec-2011******************************/
/************************** Laxman 24_dec-2011*******************/

alter procedure cir_receipt_for_chqbounce
    @pcompcode			as varchar(20),
    @punitcode			as varchar(20),
    @pdoctype			as varchar(20),
    @pagcd				as varchar(20),
    @pdpcd				as varchar(20),
    @precptno			as varchar(200),
    @prpt_fromdt		as datetime,
    @prpt_tilldt		as datetime,
    @pchqno				as varchar(200),
    @pchq_fromdt		as datetime,
    @pchq_tilldt		as datetime,
    @pchqbnk_code		as varchar(20),
    @puserid			as varchar(20),
    @pdateformat		as varchar(20),
    @pextra1			as varchar(200),
    @pextra2			as varchar(200),
    @pextra3			as varchar(200),
    @pextra4			as varchar(200),
    @pextra5			as varchar(200),
    @pextra6			as varchar(200),
    @pextra7			as varchar(200),
    @pextra8			as varchar(200),
    @pextra9			as varchar(200),
    @pextra10			as varchar(200)
as

begin
    If	@punitcode='' Begin
		set @punitcode=null
	End	
    If	@precptno='' Begin
		set @precptno=null
	End	
    If	@pchqno='' Begin
		set @pchqno=null
	End	
    If	@pchq_fromdt='' Begin
		set @pchq_fromdt=null
	End	
    If	@pchq_tilldt='' Begin
		set @pchq_tilldt=null
	End	
    If	@pchqbnk_code='' Begin
		set @pchqbnk_code=null
	End					
    If	@pchq_tilldt='' Begin
		set @pchq_tilldt=null
	End	
    If	@pchqbnk_code='' Begin
		set @pchqbnk_code=null
	End

    select h.comp_code as "COMP_CODE",h.unit_code as "UNIT_CODE",h.agcd as "AGCD",h.dpcd as "DPCD",m.ag_name as "AG_NAME",dbo.cir_get_city(h.comp_code,m.city_code) as "CITY_NAME",
    h.doctype as "DOCTYPE",h.recptno as "RECPTNO",h.recptdt as "RECPTDT",abs(h.amount) AS "AMOUNT",h.chno as "CHNO",h.chdt as "CHDT",h.chbank as "CHBANK",
    (select bankname from cir_bank_mast where comp_code=h.comp_code and bankcode=h.chbank) as "CHQBANK_NMAE",
    h.reason as "REASON",h.prov_rec_no as "PROV_REC_NO",h.prov_rec_dt as "PROV_REC_DT",h.received_from as "RECEIVED_FROM",h.achd as "ACHD",
    h.ccdp as "DEBIT_HEAD",(select acc_name from fa_acc_mast where comp_code=h.comp_code and cdp=h.ccdp) as "CREDIT_HEAD_NAME",
    h.rcdp as "CREDIT_HEAD",(select acc_name from fa_acc_mast where comp_code=h.comp_code and cdp=h.rcdp) as "DEBIT_HEAD_NAME"
    from cir_rcphdr h,cir_agmast m
    where h.comp_code=m.comp_code and h.comp_code=@pcompcode and h.unit_code=m.unit and h.unit_code=isnull(@punitcode,h.unit_code) and 
    h.doctype=@pdoctype and h.recptno=isnull(@precptno,h.recptno) and h.recptdt>=@prpt_fromdt and h.recptdt<=@prpt_tilldt and 
    h.agcd=m.agcd and h.agcd=@pagcd and h.dpcd=m.dpcd and h.dpcd=@pdpcd and 
    (h.chno=@pchqno or @pchqno is null) and 
    ((h.chdt between @pchq_fromdt and @pchq_tilldt) or @pchq_fromdt is null or @pchq_tilldt is null) and
    (h.chbank=@pchqbnk_code or @pchqbnk_code is null) and h.reason='CH0'
    order by recptdt desc,recptno
    
End

/************************** Laxman 24_dec-2011*******************/


/**************************** start of issue 0005030 *****************************/



ALTER PROCEDURE [dbo].[cir_rep_supply_cir_taluka_wise_supply]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@proute                                   VARCHAR(20) ,
	@pfrom_supdate                            DATETIME ,
	@ptill_supdate                            DATETIME,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(200) ,--for login user id
	@pextra2                                  VARCHAR(200) 

AS 
if(@ppubl = '') begin
  set @ppubl = null
end
if(@pmainedtn = '') begin
  set @pmainedtn = null
end
if(@pedtn = '') begin
  set @pedtn = null
end
if(@proute = '') begin
  set @proute = null
end
if(@pextra1 = '') begin
  set @pextra1 = null
end
if(@pextra2 = '') begin
  set @pextra2 = null
end
		
	select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
	m.tehsil_taluka AS "TEHSIL_TALUKA",dbo.cir_get_taluka(d.comp_code,m.tehsil_taluka) AS "TALUKA_NAME",
	d.agcd AS "AGCD",d.dpcd AS "DPCD",m.ag_name AS "AG_NAME",m.ag_name_oth_lang AS "AG_NAME_OTH_LANG",sum(d.sup_copy) AS "SUP_COPY",
	dbo.cir_get_name_cir_taluka(d.comp_code,m.tehsil_taluka,2,null,null,null) as "TALUKA_OTH_NAME", 
	dbo.cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",
	dbo.cir_get_name_cir_city(d.comp_code,m.city_code,2,null,null,null) as "CITY_ONAME",
	dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME",
	dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) as "DROP_POINT_ONAME"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and d.comp_code    = @pcomp_code and
		 d.unit_code    = m.unit and d.unit_code    = @punit_code and
		 d.agcd         = m.agcd and d.dpcd         = m.dpcd and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (m.tehsil_taluka = @proute or @proute is null) and d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
	  group by d.comp_code,d.unit_code,m.tehsil_taluka,
			   d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code
	  order by comp_code,unit_code,taluka_name,ag_name,agcd,dpcd;
		
	
	select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
	m.tehsil_taluka AS "TEHSIL_TALUKA",dbo.cir_get_taluka(d.comp_code,m.tehsil_taluka) AS "TALUKA_NAME",
	sum(d.sup_copy) AS "SUP_COPY",
	dbo.cir_get_name_cir_taluka(d.comp_code,m.tehsil_taluka,2,null,null,null) as "TALUKA_OTH_NAME"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and d.comp_code    = @pcomp_code and
		 d.unit_code    = m.unit and d.unit_code    = @punit_code and
		 d.agcd         = m.agcd and d.dpcd         = m.dpcd and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (m.tehsil_taluka = @proute or @proute is null) and d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
	  group by d.comp_code,d.unit_code,m.tehsil_taluka
	  order by comp_code,unit_code,taluka_name;
		
	select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",sum(d.sup_copy) AS "SUP_COPY"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and d.comp_code    = @pcomp_code and
		 d.unit_code    = m.unit and d.unit_code    = @punit_code and
		 d.agcd         = m.agcd and d.dpcd         = m.dpcd and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (m.tehsil_taluka = @proute or @proute is null) and d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
	  group by d.comp_code,d.unit_code
	  order by comp_code,unit_code
		

	select d.comp_code as "COMP_CODE",sum(d.sup_copy) AS "SUP_COPY",max(sup_rate) as  "COPY_RATE"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and d.comp_code    = @pcomp_code and
		 d.unit_code    = m.unit and d.unit_code    = @punit_code and
		 d.agcd         = m.agcd and d.dpcd         = m.dpcd and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (m.tehsil_taluka = @proute or @proute is null) and d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
	  group by d.comp_code
	  order by comp_code


/******************************* end of issue 0005030 *************************/



//=========================================issue no. 6085 26/12/2011=================================================================

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION  [dbo].[cir_get_publ_name] (@pcomp_code as varchar(100),@ppubl as varchar(100))  returns varchar(200) 

AS  

BEGIN 
DECLARE @vpubl_name VARCHAR(4000)
select @vpubl_name=publ_name from cir_publ_mast where comp_code=@pcomp_code and publ=@ppubl
	   
RETURN isnull(@vpubl_name,'')
END


=========================================================================================================================

/*****************************6138 26-dec-2011************************/


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[cir_agency_bind_cir_agency_bind_p]
	@pcompcode			VARCHAR(20) ,
	@punit              VARCHAR(20) ,
	@pdateformat        VARCHAR(20) ,
	@pextra1            VARCHAR(4000) ,
	@pextra2            VARCHAR(4000) 
AS 
BEGIN
	If UPPER(@pextra2)='D' Begin
			
		SELECT cir_agmast_dis.*,dbo.cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.agcd,cir_agmast_dis.dpcd) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.agcd,cir_agmast_dis.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.station_code,1) as "DROP_POINT_NAME"
		FROM  cir_agmast_dis 
		WHERE comp_code  = @pcompcode AND unit  = @punit
		 AND ((UPPER(ag_name)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
		 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/
		union
		SELECT cir_agmast_dis.*,dbo.cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.agcd,cir_agmast_dis.dpcd) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.agcd,cir_agmast_dis.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.station_code,1) as "DROP_POINT_NAME"
		FROM  cir_agmast_dis 
		WHERE comp_code  = @pcompcode AND unit  = @punit
		 AND ((UPPER(agcd)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
		 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/
		ORDER BY 5
	End
	Else Begin
		SELECT cir_agmast.*,dbo.cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.station_code,1) as "DROP_POINT_NAME"
			FROM  cir_agmast 
			WHERE comp_code  = @pcompcode AND unit  = @punit
			 AND ((UPPER(ag_name)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
			 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/
		union
		SELECT cir_agmast.*,dbo.cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.station_code,1) as "DROP_POINT_NAME"
			FROM  cir_agmast 
			WHERE comp_code  = @pcompcode AND unit  = @punit
			 AND ((UPPER(agcd)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
			 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/			 
			ORDER BY 5
	End
END


/***************************for bank**************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[cir_bankbind_bankbind_p]
	@pcompcode                                VARCHAR(20) ,
	@pextra1                                  VARCHAR(200) ,
	@pextra2                                  VARCHAR(200) 
AS 

		SELECT
				 bankcode  "bankcode",
				 bankname  "bankname",
				 city_code,
				 (		SELECT city_name
				FROM  cir_city_mast 
				WHERE	 comp_code  = @pcompcode
				 AND	city_code  = cir_bank_mast.city_code
		) city_name
		FROM  cir_bank_mast 
		WHERE	 comp_code  = @pcompcode
		 AND	((UPPER(bankname)  like UPPER(@pextra1) + '%')
		 OR	(@pextra1  is null) OR	(@pextra1  = ''))
		ORDER BY bankname 
		
/**************************for paymode****************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE [dbo].[cir_paymode_bind_p]
	@pcomp_code                               VARCHAR(20) ,
	@pdoc_type                                VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
		DECLARE @vflagforreceiptentry                     VARCHAR(600) 
		IF ( @pdoc_type != 'RCR' ) 
		BEGIN 
			
			SELECT
					 reason_code REASON_CODE,
					 reason_name REASON_NAME,
					 'N' MODE_TYPE
			FROM  cir_reason_mst 
			WHERE	 comp_code  = @pcomp_code
			 AND	((UPPER(reason_name)  like UPPER(@pextra1) + '%') OR	(@pextra1  is null) OR (@pextra1 =''))
			ORDER BY reason_name 
		END
		ELSE
		BEGIN 
			SELECT
					 Pay_Mode_Code Pay_Mode_Code,
					 Payment_Mode_Name Payment_Mode_Name,
					 payment_mode_type MODE_TYPE
			FROM  Payment_Mode_Mast 
			WHERE	 Comp_Code  = @pcomp_code
			 AND	((UPPER(Payment_Mode_Name)  like UPPER(@pextra1) + '%') OR	(@pextra1  is null) OR (@pextra1 =''))
			ORDER BY Payment_Mode_Name 
END

/*****************************for executive************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE  [dbo].[cir_executive_bind]

 @pcompcode as varchar(200),
 @pdateformat as varchar(200),
 @pextra1 as varchar(200),
 @pextra2 as varchar(200)

 AS
   select * from cir_executive_mast
                    where comp_code=@pcompcode and
                           	ISNULL(freeze_flag,'N')='N'
                    order by executive_desc


/*****************************generate code***************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[cir_prov_receipt_id]
    @pcompcode		as	VARCHAR(40) ,
    @pbranchcode    as	VARCHAR(40) ,
    @pdoctype       as	VARCHAR(40) ,
    @precptdt       as	VARCHAR(40) ,
    @pdateformat    as	VARCHAR(40) ,
    @pextra1        as	VARCHAR(40) ,
    @pextra2        as	VARCHAR(40),
    @pextra3        as	varchar(40),
    @pextra4        as	varchar(40),
    @pextra5        as	varchar(40) 
AS 
        DECLARE @vno			NUMERIC(20) 
        DECLARE @vrecptno       VARCHAR(15) 
        DECLARE @v_dt           DATETIME 

        SET @v_dt  =   dbo.convert_user_date('/', @precptdt,@pdateformat) 

		SELECT @vno  =  CAST( MAX(SUBSTRING(recptno, 5, 8))AS NUMERIC) + 1
		FROM  cir_rcphdr_prov 
		WHERE comp_code  = @pcompcode AND doctype  = @pdoctype
		AND  CONVERT(VARCHAR(23), recptdt)  = CONVERT(VARCHAR(23), @v_dt)
		AND  branch_code  = @pbranchcode
        
        IF ISNULL(@vno, 0)= 0 
			BEGIN 
				SET @vrecptno  = @pbranchcode + '-' + REPLACE(CONVERT(VARCHAR(5), GETDATE(), 2), '.', '')+ '0001' 
			END
        ELSE
			BEGIN 
				SET @vrecptno  = @pbranchcode + '-' + dbo.fnPadLeft('0',8,@vno) 
			END
   
        SELECT @vrecptno as VAR_CODE



/***************************************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION  [dbo].[cir_get_agency](
@pcomp_code		as varchar(100),
@punit_code		as varchar(100),
@pagcd			as varchar(100),
@pdpcd			as varchar(100))  
returns varchar(1000) 
AS  
BEGIN 
DECLARE @vag_name VARCHAR(4000)

select @vag_name=x.ag_name from
(select ag_name 
from cir_agmast 
         where comp_code=@pcomp_code and
               unit=@punit_code and
               agcd=@pagcd and
               dpcd=@pdpcd
union
select ag_name 
from cir_agmast_dis
         where comp_code=@pcomp_code and
               unit=@punit_code and
               agcd=@pagcd and
               dpcd=@pdpcd) x
	   
RETURN isnull(@vag_name,'')
END

/*****************************************************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
                                                              
                                             
ALTER FUNCTION [dbo].[cir_get_payreason](
    @pcomp_code  as varchar(20),
    @pdoc_type   as varchar(20),
    @ppayreason  as varchar(20),
    @pdateformat as varchar(20),
    @pextra1     as varchar(200),
    @pextra2     as varchar(200),
    @pextra3     as varchar(200),
    @pextra4     as varchar(200),
    @pextra5     as varchar(200))  returns varchar(100) as
   
Begin
	 DECLARE @v_desc   AS	varchar(100)
    if(@pdoc_type !='RCR') Begin
        select @v_desc=reason_name from cir_reason_mst 
            where comp_code = @pcomp_code and upper(reason_code) =@ppayreason
		End
    else
		Begin
        select distinct @v_desc="Payment_Mode_Name" from Payment_Mode_Mast 
            where /*"Comp_Code"=@pcomp_code and*/ upper("Pay_Mode_Code") =@ppayreason
		End
    return ISNULL(@v_desc,@ppayreason)
END

/*******************************************************************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE  [dbo].[cir_executive_bind1]

 @pcompcode as varchar(200),
 @pexecode as varchar(200),
 @pdateformat as varchar(200),
 @pextra1 as varchar(200),
 @pextra2 as varchar(200)

 AS
   select * from cir_executive_mast
                    where comp_code=@pcompcode and 
                          (executive_code=@pexecode or @pexecode is null) and
                          	ISNULL(freeze_flag,'N')='N'
                    order by executive_desc





/****************************************************************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CIR_bankbind_p]
	@pcompcode                                VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 

		
		SELECT
				 bankcode  bankcode,
				 bankname  bankname
		FROM  cir_bank_mast 
		WHERE	 comp_code  = @pcompcode
		 AND	((UPPER(bankname)  like UPPER(@pextra1) + '%')
		 OR	(@pextra1  is null))
		ORDER BY bankname 


/*************************************get company**************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
 ALTER Procedure [dbo].[cir_company_detail_p]


     @pcompcode           VARCHAR(20) ,
     @plangtype           VARCHAR(20) ,---1 for enlish and 2 for other language
     @pdateformat         VARCHAR(20) ,
     @pextra1             VARCHAR(200) ,
     @pextra2             VARCHAR(200) 


  As
 


        select comp_mst.*,(select distinct "City_Name" from city_mst where City_Code=comp_mst."City_Code")  CITY_NAME,
        (SELECT distinct "Country_Name" FROM count_mst where "Country_Code"=comp_mst."Country_Code") COUNTRY_NAME from comp_mst 
        where ("Comp_Code"=@pcompcode or @pcompcode is null or @pcompcode = '')
        order by "Comp_Code";


/********************************function*****************************************/

ALTER FUNCTION [dbo].[cir_get_provreceipt_exist]
    (@pcomp_code     as varchar(200),
     @punit_code     as varchar(200),
	 @pbran_code     AS varchar(200),
     @precptno       as varchar(200),
     @pdoctype       as varchar(20),
     @pagcd          as varchar(20),
     @pdpcd          as varchar(20),
     @pextra1        as varchar(200),
     @pextra2        as varchar(200),
     @pextra3        as varchar(200),
     @pextra4        as varchar(200),
     @pextra5        as varchar(200)) RETURNS int AS
	
BEGIN
declare @v_rec_exist int
set @v_rec_exist=0
	if upper(@pextra2)='D' Begin
		select @v_rec_exist = count(*) from cir_rcphdr_prov where comp_code=@pcomp_code and unit_code=@punit_code and 
		doctype=@pdoctype and recptno=@precptno and agcd=@pagcd and dpcd=@pdpcd and branch_code=@pbran_code
	End	
	else Begin
	select @v_rec_exist = count(*) from cir_rcphdr_prov where comp_code=@pcomp_code and unit_code=@punit_code and 
		doctype=@pdoctype and recptno=@precptno and agcd=@pagcd and dpcd=@pdpcd and branch_code=@pbran_code	
	End     
  return @v_rec_exist;
END

		

/********************************end of 6138******************************/


/***********************mimoh 26dec 2011*********************************0006137****************/
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go







ALTER PROCEDURE   [dbo].[wesp_updatedate1]

@compcode as varchar(15),
@userid as varchar(15),
@dateformat as varchar(15),
@code as varchar(4),
@curr as varchar(8),
@ratecode as varchar(8),
@solo as varchar(15),
@breakup as varchar(2),
@bwcode as varchar(8),
@rostatus as varchar(2),
@filename as varchar(2),
@tfn as VARCHAR(4),
@insertbreak as varchar(2),
@prem as varchar(8),
@dealtype as varchar(2),
@pre as varchar(5),
@suff as varchar(5),
@financestatus as  char(2),
@voucherst as varchar(30),
@adcode as varchar(100),
@rodatetime as varchar(8),
@spacearea as varchar(8),
@vat as varchar(50),
@bookstat as varchar(25),
@cio_id as varchar(8),
@receipt_no as varchar(50),
@uom as varchar(8),
@bgcolor as varchar(10),
@validdate as varchar(10),
@agencyratecode as varchar(10),
@audit as varchar(8),
@book_insert_date as varchar(8),
@agencycomm as varchar(8),
@rateaudit as varchar(8),
@billaudit as varchar(8),
@billtype as varchar(8),
@invoice_no as varchar(50),
@copybooking as varchar(8),
@ratecompany as varchar(50),
@addagenycomm as varchar(50),
@agencycommlinkretainer as varchar(50),
@subeditionr as varchar(50),
@displaybilltype as varchar(50),
@classifiedbilltype as varchar(50),
@billformat as varchar(50),
@ratechk as varchar(50),
@allpkg as varchar(50),
@dayrate1 as varchar(50),
@schemetype as varchar(50),
@PIncludeclassi as varchar(50),
@receiptformat as varchar(50),
@cash_receipt as varchar(50),
@bill_orderwiselast as varchar(50),
@floor_chk as varchar(50),
@Unsoldflag as varchar(1),
@Supplystopper as varchar(10),
@drpRokeychk as varchar(1),
@Agencycomm_seq as varchar(1),
@creditreciept as varchar(1),
@cashindisplay as varchar(8),
@cashinclassified as varchar(8),
@rate_audit_pref as varchar(25),
@v_barcoding_allow as varchar(25),
@v_fmgbills AS VARCHAR(25),
@v_billed_cashdis as varchar(25),
@v_billed_cashcls as varchar(25),
@v_drpbackdate as varchar(25),
@dockitbooking as varchar(1),
@allowprevbooking as varchar(1),
@ro_wisecashbill as varchar(50),
@chkval as varchar(5),
@approval1 as varchar(50),
@pckstatus as varchar(3),
@cash_disc as varchar(1),
@cash_amt as varchar(10),
@seperate_cashier1 as varchar(10),
@disp_bill as varchar(1),
@clas_bill as varchar(1),
@mantimepost as varchar(1),
@bkdaypost as int,
@maxterutn as int,
@cir_return as varchar(1),
@noofchkbounc as int,
@noofdaychkrec as int,
@retday as int,
@chngsuppord as int,
@max_publishday as int,
@p_billno_period as varchar(15),
@spl_trans_edit as varchar(5),
@spl_dis_trans_editable as varchar(5),
@mul_pac_sel_trans as varchar(5),
@shmon_minword	as varchar(1),
@tradon_spcrg	as varchar(1),
@rateauth       as varchar(1),
@f2day as int,
@rateauditmodify as varchar(1),
@bindrevenuecenter as varchar(1),
@p_led_allow as varchar(2),
@p_clear_allow as varchar(2),
@repeatday as varchar(2),
@premiumedit as varchar(2),
@P_BILL_GENERATION as varchar(20),
@P_PUBLICATION_CENTER as varchar(50),
@P_allow_discount_prem as varchar(1),
@P_SCHEME_BILLING as varchar(50),
@P_ALLOW_PDC as varchar(50),
@PAD_TYPE_FOR_MANUL_BILL AS VARCHAR(20),
@RO_OUTSTAND_P AS VARCHAR(5),
@genrate_agency_code AS VARCHAR(5),
@p_dispauditbk AS VARCHAR(5),
@p_aotosupply  AS VARCHAR(5),
@p_Authorization as VARCHAR(1),
@p_CIR_AUTO_APPROVAL_UNSOLD AS VARCHAR(5),
@p_CIR_AUTO_PHYSICAL_UNSOLD AS VARCHAR(5),
@p_CIR_UNSOLD_INCLUDE_INCT AS VARCHAR(5),
@p_CIR_UNSOLD_INCLUDE_INSFEE AS VARCHAR(5),
@p_CIR_UNSOLD_ON_RECEIVED_DT AS VARCHAR(5),
@p_AGENCY_UNBLOCK_APPROVAL AS VARCHAR(5),
@p_UNBLOCK_APPROVAL_OUTSIDE_LIMIT AS VARCHAR(5),
@p_CIR_BILL_PUBLWISE AS VARCHAR(5),
@paging         AS VARCHAR(4000) ,
@print          AS VARCHAR(4000) ,
@allowpage      AS VARCHAR(4000) ,
@agency_req     AS VARCHAR(4000) ,
@region_req     AS VARCHAR(4000) ,
@p_ALLOW_FOLLOW_DT_BOOOK as varchar(1),
@p_CRM_SUPPLY_TYPE_PAID   as varchar(10),
@p_CRM_SUPPLY_TYPE_FREE   as varchar(10)


AS
declare @query as varchar(8000)
declare @query1 as varchar(8000)
/*
set @query='update login set date_format='''+@dateformat+''' , Autogenerate='''+@code+''',curr_code='''+@curr+''' where com_code='''+@compcode+'''   '
exec(@query)

set @query1='update preferrences set RATE_COMPANY_AGENCY='''+@ratecompany+''',ADDITIONAL_AGENCY_COMM='''+@addagenycomm+''',
AGENCY_RETAINER_COMM='''+@agencycommlinkretainer+''',SUBEDITIONRATE='''+@subeditionr+''',DIS_BILLTYPE='''+@displaybilltype+''',
CLS_BILLTYPE='''+@classifiedbilltype+''',autogenerated='''+@code+''',currency_code='''+@curr+''' ,rate_gr_code='''+@ratecode+''' , 
date_format='''+@dateformat+''',solo='''+@solo+''',breakup='''+@breakup+''' ,blackwhitecode='''+@bwcode+''',  rostatus='''+@rostatus+''',
File_name='''+@filename+''',Tfn='''+@tfn+''',Insert_breakup='''+@insertbreak+''',Premium_type='''+@prem+''',Deal_type='''+@dealtype+'''  ,    
prefix='''+@pre+''', suffix='''+@suff+'''  ,     financestatus='''+ @financestatus+''' , voucherst='''+@voucherst+''',Ad_category='''+@adcode+''' ,
Ro_datetime='''+@rodatetime+''' ,Space_area='''+@spacearea+''',Vat='''+@vat+''' ,Booking_status='''+@bookstat+''' ,Cio_id='''+@cio_id+''',
Receipt_no='''+@receipt_no+''' ,uom_code='''+@uom+''',Bgcolor_publication='''+@bgcolor+''' ,chkfor_valid_pubdates='''+@validdate+''', 
Agency_ratecode='''+@agencyratecode+''',   audit='''+@audit+''', book_insert_date='''+@book_insert_date+''',agencycomm='''+@agencycomm+''',
rate_audit='''+@rateaudit+''',bill_audit='''+@billaudit+''', billtype='''+@billtype+''', invoice_no='''+@invoice_no+''' , 
copy_booking='''+@copybooking+''', BILLING_FORMAT='''+@billformat+''' , RATE_CHECK='''+@ratechk+''', ALL_PACKAGE='''+@allpkg+''',
DAYRATE='''+@dayrate1+''' ,SCHEME_TYPE='''+@schemetype+'''    ,DISP_CLSBILL='''+@PIncludeclassi+ '''  , RECEIPT_FORMAT ='''+@receiptformat+''',
CASH_RECEIPT_BILL='''+@cash_receipt+''', BILL_ORDERWSLAST='''+@bill_orderwiselast+''',FLOOR_CHK='''+@floor_chk+''' ,
Unsold_Entry_Flag='''+@Unsoldflag+''' ,Supply_Stop_Percentage='''+@Supplystopper+''',ROKEYCHECK='''+@drpRokeychk+''',
AGENCYCOMM_SEQ_COM='''+@Agencycomm_seq+''' ,CREDIT_RECIPT='''+@creditreciept+''',DISP_CASHBILL='''+@cashindisplay+''',
CLA_CASHBILL='''+@cashinclassified+''',RATE_AUDIT_PREF='''+@rate_audit_pref+''',BARCODING_ALLOWED='''+@v_barcoding_allow+''', 
FMG_BILL_DIS='''+@v_fmgbills+''',BILL_DISP_CASHBILL='''+@v_billed_cashdis +''',BILL_CLA_CASHBILL ='''+@v_billed_cashcls+''',
BACKDATERECEIPT='''+@v_drpbackdate+''',DOCKIT_BOOKING='''+@dockitbooking+''',Allowed_old_date='''+@allowprevbooking+''',
ROWISE_CASHBOOKING='''+@ro_wisecashbill+''' where    comp_code='''+@compcode+'''   ' 
*/
/*********************************************************************************************************/
UPDATE LOGIN SET date_format=@dateformat, Autogenerate=@code,curr_code=@curr WHERE COM_CODE=@compcode

UPDATE PREFERRENCES SET  autogenerated=@code,
currency_code=@curr ,
rate_gr_code=@ratecode,
date_format=@dateformat,solo=@solo,breakup=@breakup,
blackwhitecode=@bwcode,rostatus=@rostatus,File_name=@filename,Tfn=@tfn,
Insert_breakup=@insertbreak,Premium_type=@prem,Deal_type=@dealtype  ,
 prefix=@pre, suffix=@suff, financestatus=@financestatus , voucherst=@voucherst,
 Ad_category=@adcode ,Ro_datetime=@rodatetime ,Space_area=@spacearea,Vat=@vat,
 Booking_status=@bookstat,Cio_id=@cio_id,Receipt_no=@receipt_no,uom_code=@uom,
 Bgcolor_publication=@bgcolor ,chkfor_valid_pubdates=@validdate, Agency_ratecode=@agencyratecode,
  audit=@AUDIT,book_insert_date=@book_insert_date,agencycomm=@agencycomm,
  rate_audit=@rateaudit,bill_audit=@billaudit,billtype=@billtype,invoice_no=@invoice_no,
  copy_booking=@copybooking,RATE_COMPANY_AGENCY=@ratecompany, ADDITIONAL_AGENCY_COMM=@addagenycomm ,
  AGENCY_RETAINER_COMM=@agencycommlinkretainer,SUBEDITIONRATE=@subeditionr,
  CLS_BILLTYPE=@classifiedbilltype,DIS_BILLTYPE=@displaybilltype,BILLING_FORMAT=@billformat,
  RATE_CHECK=@ratechk,ALL_PACKAGE=@allpkg,dayrate=@dayrate1,SCHEME_TYPE=@schemetype,DISP_CLSBILL=@PIncludeclassi   ,
  CASH_RECEIPT_BILL=@cash_receipt, BILL_ORDERWSLAST=@bill_orderwiselast, FLOOR_CHK=@floor_chk ,
  Unsold_Entry_Flag=@Unsoldflag ,Supply_Stop_Percentage=@Supplystopper,ROKEYCHECK=@drpRokeychk ,
  AGENCYCOMM_SEQ_COM=@Agencycomm_seq ,CREDIT_RECIPT=@creditreciept,DISP_CASHBILL=@cashindisplay,
  CLA_CASHBILL=@cashinclassified,RATE_AUDIT_PREF=@rate_audit_pref,BARCODING_ALLOWED=@v_barcoding_allow,
  FMG_BILL_DIS =@v_fmgbills, BILL_DISP_CASHBILL=@v_billed_cashdis , BILL_CLA_CASHBILL=@v_billed_cashcls,BACKDATERECEIPT=@v_drpbackdate,DOCKIT_BOOKING=@dockitbooking,Allowed_old_date=@allowprevbooking,ROWISE_CASHBOOKING=@ro_wisecashbill,CUTOFFTIME=@chkval,APPROVAL=@approval1,back_days=@pckstatus,CASH_DISCOUNT=@cash_amt,CASH_DISCOUNTTYPE=@cash_disc,SEPRATE_CASHIER=@seperate_cashier1,
 CIR_MANY_TIME_POSTING=@mantimepost, CIR_BACKDAYS_POSTING=@bkdaypost, CIR_MAX_RETURN_ALLOW=@maxterutn, CIR_RETURN_LIMIT_ALLOW=@cir_return, CIR_NO_OF_CHQBOUNCE=@noofchkbounc, CIR_DAYS_CHQBOUNCE=@noofdaychkrec, CIR_RETURN_DAYS=@retday, CIR_SUP_ORDER_LIMIT=@chngsuppord, DISP_BILLING_CRITERIA=@disp_bill, CLSD_BILLING_CRITERIA=@clas_bill,MAX_PUBLISHDAYS=@max_publishday,
 BILLNO_PERIODICITY=@p_billno_period,SPECIALDISC_TRANS_EDIT=@spl_trans_edit, SHARING_TRANS=@spl_dis_trans_editable, MULTIPACKAGE_SEL_TRANS=@mul_pac_sel_trans,SCHEME_MINWORD=@shmon_minword, TRADE_SPLCHARGE=@tradon_spcrg,RATE_AUTHORIZATION=@rateauth
  ,F2_RECORD=@f2day,PUBLISHAD_EDIT_RATEAUDIT=@rateauditmodify,BINDREVENUE_CENTER=@bindrevenuecenter,
FA_LEDGER_ALLOW=@p_led_allow,CLEARANCE_TYPE_ALLOW=@p_clear_allow,REPEAT_DAY_TYPE=@repeatday,PREMIUM_EDIT=@premiumedit,

BILL_GENERATION_PRIOR=@P_BILL_GENERATION,PUBLICATION_HO=@P_PUBLICATION_CENTER,

SPLDISC_ALLOWPREM=@P_allow_discount_prem,BILL_SCHEME=@P_SCHEME_BILLING,

ALLOWED_PDC_DAYS_RECEIPT=@P_ALLOW_PDC,AD_TYPE_MANUL_BILL=@PAD_TYPE_FOR_MANUL_BILL,OUTSTANDING_AMT_CRITERIA=@RO_OUTSTAND_P,GENRATE_CIR_AGCD=@genrate_agency_code,DISP_AUDITBKG=@p_dispauditbk,CIR_DIS_AUTO_POSTING=@p_aotosupply,RELAUTHREQON=@p_Authorization,
CIR_AUTO_APPROVAL_UNSOLD=@p_CIR_AUTO_APPROVAL_UNSOLD,CIR_AUTO_PHYSICAL_UNSOLD=@p_CIR_AUTO_PHYSICAL_UNSOLD,CIR_UNSOLD_INCLUDE_INCT=@p_CIR_UNSOLD_INCLUDE_INCT,
CIR_UNSOLD_INCLUDE_INSFEE=@p_CIR_UNSOLD_INCLUDE_INSFEE,CIR_UNSOLD_ON_RECEIVED_DT=@p_CIR_UNSOLD_ON_RECEIVED_DT,AGENCY_UNBLOCK_APPROVAL=@p_AGENCY_UNBLOCK_APPROVAL,UNBLOCK_APPROVAL_OUTSIDE_LIMIT=@p_UNBLOCK_APPROVAL_OUTSIDE_LIMIT,CIR_BILL_PUBLWISE=@p_CIR_BILL_PUBLWISE,
RECORDS_ON_PAGE = @paging,RECORDS_ON_PRINT = @print,HEADER_ON_PAGE = @allowpage,AGENCY_REQUIRED = @agency_req,REGION_REQUIRED = @region_req,ALLOW_FOLLOW_DT_BOOOK=@p_ALLOW_FOLLOW_DT_BOOOK,CRM_SUPPLY_TYPE_PAID=@p_CRM_SUPPLY_TYPE_PAID,CRM_SUPPLY_TYPE_FREE=@p_CRM_SUPPLY_TYPE_FREE
 WHERE comp_code=@compcode




/* ,
',Unsold_Entry_Flag='''+@Unsoldflag+''',Supply_Stop_Percentage='''+@Supplystopper+'''

,ROKEYCHECK='''+@drpRokeychk+''',AGENCYCOMM_SEQ_COM='''+@Agencycomm_seq+''' ,CREDIT_RECIPT='''+@creditreciept+''' where    comp_code='''+@compcode+'''   ' 



--,DISP_CASHBILL='''+@cashindisplay+''',CLA_CASHBILL='''+@cashinclassified+'''
*/

print(@query1)
exec(@query1)







































/********************/




set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go





















ALTER PROCEDURE [dbo].[currbindpreferpgld]
@compcode as varchar(8)

AS

/*select date_format,autogenerated,currency_code,rate_gr_code,solo,breakup,blackwhitecode,rostatus,File_name,Tfn,Insert_breakup  , prefix,suffix,financestatus,voucherst,Ad_category,Ro_datetime,Vat,Booking_status,Cio_id,Receipt_no,uom_code,Bgcolor_publication,chkfor_valid_pubdates,
Agency_ratecode,audit,book_insert_date,agencycomm,rate_audit,bill_audit,billtype,Premium_type,copy_booking,RATE_COMPANY_AGENCY,ADDITIONAL_AGENCY_COMM,AGENCY_RETAINER_COMM,SUBEDITIONRATE,CLS_BILLTYPE,DIS_BILLTYPE,BILLING_FORMAT,RATE_CHECK,ALL_PACKAGE,DAYRATE,SCHEME_TYPE,DISP_CLSBILL, RECEIPT_FORMAT ,CASH_RECEIPT_BILL, BILL_ORDERWSLAST, FLOOR_CHK,DISP_CASHBILL, CLA_CASHBILL,RATE_AUDIT_PREF ,  FMG_BILL_DIS,BARCODING_ALLOWED,BILL_DISP_CASHBILL,BILL_CLA_CASHBILL ,BACKDATERECEIPT,ROWISE_CASHBOOKING from preferrences where comp_code=@compcode
*/

  SELECT date_format, autogenerated, currency_code,
                rate_gr_code, solo, breakup, blackwhitecode,
                rostatus, File_name, Tfn, Insert_breakup, prefix,
                suffix, financestatus, voucherst, Ad_category,
                Ro_datetime, Vat, Booking_status, Cio_id,
                Receipt_no,uom_code,Bgcolor_publication,chkfor_valid_pubdates,Agency_ratecode,audit,book_insert_date,agencycomm,
                rate_audit,bill_audit,billtype,Premium_type,copy_booking,RATE_COMPANY_AGENCY,ADDITIONAL_AGENCY_COMM,AGENCY_RETAINER_COMM,SUBEDITIONRATE,CLS_BILLTYPE,DIS_BILLTYPE,
				BILLING_FORMAT,RATE_CHECK,ALL_PACKAGE,dayrate,SCHEME_TYPE,DISP_CLSBILL,RECEIPT_FORMAT,CASH_RECEIPT_BILL, BILL_ORDERWSLAST, FLOOR_CHK,
                ROKEYCHECK, AGENCYCOMM_SEQ_COM, CREDIT_RECIPT,  DISP_CASHBILL, CLA_CASHBILL,
				RATE_AUDIT_PREF,BARCODING_ALLOWED, FMG_BILL_DIS,BILL_DISP_CASHBILL, BILL_CLA_CASHBILL,BACKDATERECEIPT,ROWISE_CASHBOOKING,CUTOFFTIME,DOCKIT_BOOKING,APPROVAL,back_days as BACK_DAYS,CASH_DISCOUNT,CASH_DISCOUNTTYPE,Allowed_old_date,SEPRATE_CASHIER,
                CIR_MANY_TIME_POSTING, CIR_BACKDAYS_POSTING, CIR_MAX_RETURN_ALLOW, CIR_RETURN_LIMIT_ALLOW, CIR_NO_OF_CHQBOUNCE, CIR_DAYS_CHQBOUNCE, CIR_RETURN_DAYS, CIR_SUP_ORDER_LIMIT, DISP_BILLING_CRITERIA, CLSD_BILLING_CRITERIA,MAX_PUBLISHDAYS,BILLNO_PERIODICITY, SPECIALDISC_TRANS_EDIT, SHARING_TRANS, MULTIPACKAGE_SEL_TRANS,SCHEME_MINWORD, TRADE_SPLCHARGE,RATE_AUTHORIZATION,F2_RECORD,PUBLISHAD_EDIT_RATEAUDIT,BINDREVENUE_CENTER, FA_LEDGER_ALLOW,CLEARANCE_TYPE_ALLOW,REPEAT_DAY_TYPE,PREMIUM_EDIT,
BILL_GENERATION_PRIOR,PUBLICATION_HO,SPLDISC_ALLOWPREM,BILL_SCHEME,
ALLOWED_PDC_DAYS_RECEIPT,AD_TYPE_MANUL_BILL, OUTSTANDING_AMT_CRITERIA as RO_OUTSTAND,GENRATE_CIR_AGCD,DISP_AUDITBKG,CIR_DIS_AUTO_POSTING,RELAUTHREQON,
CIR_AUTO_APPROVAL_UNSOLD, CIR_AUTO_PHYSICAL_UNSOLD, CIR_UNSOLD_INCLUDE_INCT, CIR_UNSOLD_INCLUDE_INSFEE, CIR_UNSOLD_ON_RECEIVED_DT,AGENCY_UNBLOCK_APPROVAL,UNBLOCK_APPROVAL_OUTSIDE_LIMIT,CIR_BILL_PUBLWISE,RECORDS_ON_PAGE,RECORDS_ON_PRINT,HEADER_ON_PAGE,AGENCY_REQUIRED,REGION_REQUIRED,ALLOW_FOLLOW_DT_BOOOK,CRM_SUPPLY_TYPE_PAID,CRM_SUPPLY_TYPE_FREE
           FROM PREFERRENCES
          WHERE comp_code = @compcode























/************************************/
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[Cir_Supply_Type_Bind_p]
	@pcomp_code			VARCHAR(20) ,
	@pdateformat        VARCHAR(20) ,
	@pextra1            VARCHAR(40) ,--for billing pay Y/N
	@pextra2            VARCHAR(400) 
AS 
	
	SELECT * FROM  cir_supply_type_mast 
	WHERE comp_code  = @pcomp_code and (bill_pay=@pextra1 or @pextra1 is null or @pextra1 ='')
	ORDER BY sup_seq_no,sup_ty_name 










/***********************mimoh 26dec 2011*********************************0006137****************/



/*************************** start of issue 0004566 , 0004698 3-jan-2012 *****************/

*********** for State ****************




ALTER PROCEDURE [dbo].[CIR_REP_SUPPLY_cir_rep_daybook]
	@pcomp_code      varchar(20),
	@punit_code      varchar(20),
	@ppubl           varchar(20),
	@pedtn           varchar(20),
	@pcitycd         varchar(20),
	@pstatecd        varchar(20),
	@pmonth          varchar(20),
	@pyear           varchar(20),
	@pdateformat     varchar(20),
	@pbranch         varchar(20),
	@pdistcode       varchar(20),
	@ptaluka         varchar(20),
	@pagtype         varchar(20),
	@pagclass        varchar(20),
	@pagcode         varchar(20),
	@pdpcode         varchar(20),
	@pextra1         varchar(200),--it is used for supply type
	@pextra2         varchar(200),
	@pextra3         varchar(200),
	@pextra4         varchar(200),
	@pextra5         varchar(200)
AS
BEGIN
	DECLARE @vfrdt         VARCHAR(20)
	DECLARE @vtodt         VARCHAR(20)
	DECLARE @vtodt1         VARCHAR(20)
	DECLAre @pquery         varchar(8000)
	DECLAre @pquery1         varchar(8000)
	DECLAre @pquery2         varchar(8000)

PRINT('2')

if(@pmonth = 'jan')
begin
   set  @pmonth = '01'
end  
else if(@pmonth = 'feb')
begin
   set  @pmonth = '02'
end  
else if(@pmonth = 'mar')
begin
   set  @pmonth = '03'
end  
else if(@pmonth = 'apr')
begin
   set  @pmonth = '04'
end  
else if(@pmonth = 'may')
begin
   set  @pmonth = '05'
end  
else if(@pmonth = 'jun')
begin
   set  @pmonth = '06'
end  
else if(@pmonth = 'jul')
begin
   set  @pmonth = '07'
end  
else if(@pmonth = 'aug')
begin
   set  @pmonth = '08'
end  
else if(@pmonth = 'sep')
begin
   set  @pmonth = '09'
end  
else if(@pmonth = 'oct')
begin
   set  @pmonth = '10'
end 
else if(@pmonth = 'nov')
begin
   set  @pmonth = '11'
end 
else if(@pmonth = 'dec')
begin
   set  @pmonth = '12'
end  
else 
begin
   set  @pmonth = '00'
end   

SET @vfrdt=(@pmonth+'/'+'01/'+@pyear) 
PRINT( @vfrdt) 
SET @vtodt1=([dbo].[GetLastDayOfMonth](@vfrdt))
PRINT('2') 
set @vtodt=SUBSTRING(@vtodt1,5,2)
print @vtodt1
SET @vtodt=(@pmonth+'/'+@vtodt+'/'+@pyear) 
PRINT @vtodt
		

	set @pquery='SELECT COMP_CODE,UNIT_CODE,AGCD "AGENCY CODE",DPCD "AGENCY SUBCODE",substrING(dbo.cir_get_name_cir_agname(comp_code,unit_code,agcd,dpcd,1,'''','''',''''),1,50) "AGENCY NAME",
       substring(dbo.cir_get_name_cir_agname(comp_code,unit_code,agcd,dpcd,2,'''','''',''''),1,50) "AGENCY ONAME",
       d.EDTN,dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION NAME",dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION ONAME",
       CITY_CODE "CITY CODE",dbo.cir_get_city(COMP_CODE,CITY_CODE) "CITY NAME",
       dbo.cir_get_name_cir_city(COMP_CODE,CITY_CODE,2,'''','''','''') "CITY ONAME",
       isnull(STATE_CODE,''NA'') "STATE CODE",isnull(dbo.CIR_GET_STATE(COMP_CODE,COUNTRY_CODE,STATE_CODE),''NA'') "STATE NAME",COUNTRY_CODE,
	   SUM(p01) as  "01",SUM(p02) AS "02",SUM(p03) AS "03",SUM(p04) AS "04",SUM(p05) AS "05",
       SUM(p06) AS "06",SUM(p07) AS "07",SUM(p08) AS "08",SUM(p09) AS "09",SUM(p10) AS "10",
       SUM(p11) AS "11",SUM(p12) AS "12",SUM(p13) AS "13",SUM(p14) AS "14",SUM(p15) AS "15",
       SUM(p16) AS "16",SUM(p17) AS "17",SUM(p18) AS "18",SUM(p19) AS "19",SUM(p20) AS "20",
       SUM(p21) AS "21",SUM(p22) AS "22",SUM(p23) AS "23",SUM(p24) AS "24",SUM(p25) AS "25",
       SUM(p26) AS "26",SUM(p27) AS "27",SUM(p28) AS "28",SUM(p29) AS "29",SUM(p30) AS "30",
		SUM(p31) AS "31",
       SUM(isnull(p01,0)+isnull(p02,0)+isnull(p03,0)+isnull(p04,0)+isnull(p05,0)+isnull(p06,0)+isnull(p07,0)+isnull(p08,0)+isnull(p09,0)+isnull(p10,0)+
            isnull(p11,0)+isnull(p12,0)+isnull(p13,0)+isnull(p14,0)+isnull(p15,0)+isnull(p16,0)+isnull(p17,0)+isnull(p18,0)+isnull(p19,0)+isnull(p20,0)+
            isnull(p21,0)+isnull(p22,0)+isnull(p23,0)+isnull(p24,0)+isnull(p25,0)+isnull(p26,0)+isnull(p27,0)+isnull(p28,0)+isnull(p29,0)+isnull(p30,0)+isnull(p31,0)) AS "TOTAL"
        FROM (SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,null EDTN,B.CITY_CODE,B.STATE_CODE STATE_CODE,B.COUNTRY_CODE COUNTRY_CODE,
        case (select(day(A.SUPDATE))) when  ''1'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p01,
		case (select(day(A.SUPDATE))) when  ''02'' then SUM(isnull(A.SUP_COPY,0))else 0 end as p02,
        case (select(day(A.SUPDATE))) when  ''03'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p03,
		case (select(day(A.SUPDATE))) when  ''04'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p04,
        case (select(day(A.SUPDATE))) when  ''05'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p05,
        case (select(day(A.SUPDATE))) when  ''06'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p06,
        case (select(day(A.SUPDATE))) when  ''07'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p07,
        case (select(day(A.SUPDATE))) when  ''08'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p08,
        case (select(day(A.SUPDATE))) when  ''09'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p09,
        case (select(day(A.SUPDATE))) when  ''10'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p10,
        case (select(day(A.SUPDATE))) when  ''11'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p11,
        case (select(day(A.SUPDATE))) when  ''12'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p12,
        case (select(day(A.SUPDATE))) when  ''13'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p13,
        case (select(day(A.SUPDATE))) when  ''14'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p14,
        case (select(day(A.SUPDATE))) when  ''15'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p15,
        case (select(day(A.SUPDATE))) when  ''16'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p16,
        case (select(day(A.SUPDATE))) when  ''17'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p17,
        case (select(day(A.SUPDATE))) when  ''18'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p18,
		case (select(day(A.SUPDATE))) when  ''19'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p19,
		case (select(day(A.SUPDATE))) when  ''20'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p20,
		case (select(day(A.SUPDATE))) when  ''21'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p21,
		case (select(day(A.SUPDATE))) when  ''22'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p22,
		case (select(day(A.SUPDATE))) when  ''23'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p23,
		case (select(day(A.SUPDATE))) when  ''24'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p24,
		case (select(day(A.SUPDATE))) when  ''25'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p25,
		case (select(day(A.SUPDATE))) when  ''26'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p26,
		case (select(day(A.SUPDATE))) when  ''27'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p27,
		case (select(day(A.SUPDATE))) when  ''28'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p28,
		case (select(day(A.SUPDATE))) when  ''29'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p29,
		case (select(day(A.SUPDATE))) when  ''30'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p30,
		case (select(day(A.SUPDATE))) when  ''31'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p31
        FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''+@PCOMP_CODE+''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE='''+@PUNIT_CODE+''' AND
        A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND 
		A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND A.PUBL='''+@PPUBL+''' AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') AND
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL or '''+@PSTATECD+''' ='''') AND 
        (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND 
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND 
        A.SUPDATE BETWEEN '''+@VFRDT+''' AND '''+@VTODT+'''    AND A.SUP_COPY>0
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.AGCD,A.DPCD,A.SUPDATE,B.CITY_CODE,B.STATE_CODE,B.COUNTRY_CODE) d
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.AGCD,d.DPCD,d.EDTN,d.CITY_CODE,d.STATE_CODE,d.COUNTRY_CODE
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.CITY_CODE,d.EDTN,d.AGCD,d.DPCD;'
--print @pquery	


	set @pquery1='SELECT COMP_CODE,UNIT_CODE,isnull(STATE_CODE,''NA'') "STATE CODE",isnull(dbo.CIR_GET_STATE(COMP_CODE,COUNTRY_CODE,STATE_CODE),''NA'') "STATE NAME",COUNTRY_CODE,
        SUM(p01) AS "01",SUM(p02) AS "02",SUM(p03) AS "03",SUM(p04) AS "04",SUM(p05) AS "05",
        SUM(p06) AS "06",SUM(p07) AS "07",SUM(p08) AS "08",SUM(p09) AS "09",SUM(p10) AS "10",
        SUM(p11) AS "11",SUM(p12) AS "12",SUM(p13) AS "13",SUM(p14) AS "14",SUM(p15) AS "15",
        SUM(p16) AS "16",SUM(p17) AS "17",SUM(p18) AS "18",SUM(p19) AS "19",SUM(p20) AS "20",
        SUM(p21) AS "21",SUM(p22) AS "22",SUM(p23) AS "23",SUM(p24) AS "24",SUM(p25) AS "25",
        SUM(p26) AS "26",SUM(p27) AS "27",SUM(p28) AS "28",SUM(p29) AS "29",SUM(p30) AS "30",SUM(p31) AS "31",
        SUM(isnull(p01,0)+isnull(p02,0)+isnull(p03,0)+isnull(p04,0)+isnull(p05,0)+isnull(p06,0)+isnull(p07,0)+isnull(p08,0)+isnull(p09,0)+isnull(p10,0)+
        isnull(p11,0)+isnull(p12,0)+isnull(p13,0)+isnull(p14,0)+isnull(p15,0)+isnull(p16,0)+isnull(p17,0)+isnull(p18,0)+isnull(p19,0)+isnull(p20,0)+
        isnull(p21,0)+isnull(p22,0)+isnull(p23,0)+isnull(p24,0)+isnull(p25,0)+isnull(p26,0)+isnull(p27,0)+isnull(p28,0)+isnull(p29,0)+isnull(p30,0)+isnull(p31,0)) AS "TOTAL"
        FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,B.STATE_CODE STATE_CODE,B.COUNTRY_CODE COUNTRY_CODE,
		case (select(day(A.SUPDATE))) when  ''1'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p01,
		case (select(day(A.SUPDATE))) when  ''02'' then SUM(isnull(A.SUP_COPY,0))else 0 end as p02,
        case (select(day(A.SUPDATE))) when  ''03'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p03,
		case (select(day(A.SUPDATE))) when  ''04'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p04,
        case (select(day(A.SUPDATE))) when  ''05'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p05,
        case (select(day(A.SUPDATE))) when  ''06'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p06,
        case (select(day(A.SUPDATE))) when  ''07'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p07,
        case (select(day(A.SUPDATE))) when  ''08'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p08,
        case (select(day(A.SUPDATE))) when  ''09'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p09,
        case (select(day(A.SUPDATE))) when  ''10'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p10,
        case (select(day(A.SUPDATE))) when  ''11'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p11,
        case (select(day(A.SUPDATE))) when  ''12'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p12,
        case (select(day(A.SUPDATE))) when  ''13'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p13,
        case (select(day(A.SUPDATE))) when  ''14'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p14,
        case (select(day(A.SUPDATE))) when  ''15'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p15,
        case (select(day(A.SUPDATE))) when  ''16'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p16,
        case (select(day(A.SUPDATE))) when  ''17'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p17,
        case (select(day(A.SUPDATE))) when  ''18'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p18,
		case (select(day(A.SUPDATE))) when  ''19'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p19,
		case (select(day(A.SUPDATE))) when  ''20'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p20,
		case (select(day(A.SUPDATE))) when  ''21'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p21,
		case (select(day(A.SUPDATE))) when  ''22'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p22,
		case (select(day(A.SUPDATE))) when  ''23'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p23,
		case (select(day(A.SUPDATE))) when  ''24'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p24,
		case (select(day(A.SUPDATE))) when  ''25'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p25,
		case (select(day(A.SUPDATE))) when  ''26'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p26,
		case (select(day(A.SUPDATE))) when  ''27'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p27,
		case (select(day(A.SUPDATE))) when  ''28'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p28,
		case (select(day(A.SUPDATE))) when  ''29'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p29,
		case (select(day(A.SUPDATE))) when  ''30'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p30,
		case (select(day(A.SUPDATE))) when  ''31'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p31       
        FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''+@PCOMP_CODE+''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE='''+@PUNIT_CODE+''' AND
        A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND 
		A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND A.PUBL='''+@PPUBL+''' AND (A.EDTN='''+@PEDTN+''' OR '''+@PEDTN+''' IS NULL or '''+@PEDTN+'''='''') AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+'''='''') AND
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL or '''+@PSTATECD+'''='''') AND 
        (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND 
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND 
        A.SUPDATE BETWEEN '''+@VFRDT+''' AND '''+@VTODT+'''    AND isnull(A.SUP_COPY,0)>0
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE,B.STATE_CODE,B.COUNTRY_CODE) d
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.COUNTRY_CODE
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE;'

set @pquery2='SELECT COMP_CODE,UNIT_CODE,SUM(p01) AS "01",SUM(p02) AS "02",SUM(p03) AS "03",SUM(p04) AS "04",SUM(p05) AS "05",
        SUM(p06) AS "06",SUM(p07) AS "07",SUM(p08) AS "08",SUM(p09) AS "09",SUM(p10) AS "10",
        SUM(p11) AS "11",SUM(p12) AS "12",SUM(p13) AS "13",SUM(p14) AS "14",SUM(p15) AS "15",
        SUM(p16) AS "16",SUM(p17) AS "17",SUM(p18) AS "18",SUM(p19) AS "19",SUM(p20) AS "20",
        SUM(p21) AS "21",SUM(p22) AS "22",SUM(p23) AS "23",SUM(p24) AS "24",SUM(p25) AS "25",
        SUM(p26) AS "26",SUM(p27) AS "27",SUM(p28) AS "28",SUM(p29) AS "29",SUM(p30) AS "30",SUM(p31) AS "31",
        SUM(isnull(p01,0)+isnull(p02,0)+isnull(p03,0)+isnull(p04,0)+isnull(p05,0)+isnull(p06,0)+isnull(p07,0)+isnull(p08,0)+isnull(p09,0)+isnull(p10,0)+
        isnull(p11,0)+isnull(p12,0)+isnull(p13,0)+isnull(p14,0)+isnull(p15,0)+isnull(p16,0)+isnull(p17,0)+isnull(p18,0)+isnull(p19,0)+isnull(p20,0)+
        isnull(p21,0)+isnull(p22,0)+isnull(p23,0)+isnull(p24,0)+isnull(p25,0)+isnull(p26,0)+isnull(p27,0)+isnull(p28,0)+isnull(p29,0)+isnull(p30,0)+isnull(p31,0)) AS "TOTAL"
        FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,
		case (select(day(A.SUPDATE))) when  ''1'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p01,
		case (select(day(A.SUPDATE))) when  ''02'' then SUM(isnull(A.SUP_COPY,0))else 0 end as p02,
        case (select(day(A.SUPDATE))) when  ''03'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p03,
		case (select(day(A.SUPDATE))) when  ''04'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p04,
        case (select(day(A.SUPDATE))) when  ''05'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p05,
        case (select(day(A.SUPDATE))) when  ''06'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p06,
        case (select(day(A.SUPDATE))) when  ''07'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p07,
        case (select(day(A.SUPDATE))) when  ''08'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p08,
        case (select(day(A.SUPDATE))) when  ''09'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p09,
        case (select(day(A.SUPDATE))) when  ''10'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p10,
        case (select(day(A.SUPDATE))) when  ''11'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p11,
        case (select(day(A.SUPDATE))) when  ''12'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p12,
        case (select(day(A.SUPDATE))) when  ''13'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p13,
        case (select(day(A.SUPDATE))) when  ''14'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p14,
        case (select(day(A.SUPDATE))) when  ''15'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p15,
        case (select(day(A.SUPDATE))) when  ''16'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p16,
        case (select(day(A.SUPDATE))) when  ''17'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p17,
        case (select(day(A.SUPDATE))) when  ''18'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p18,
		case (select(day(A.SUPDATE))) when  ''19'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p19,
		case (select(day(A.SUPDATE))) when  ''20'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p20,
		case (select(day(A.SUPDATE))) when  ''21'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p21,
		case (select(day(A.SUPDATE))) when  ''22'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p22,
		case (select(day(A.SUPDATE))) when  ''23'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p23,
		case (select(day(A.SUPDATE))) when  ''24'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p24,
		case (select(day(A.SUPDATE))) when  ''25'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p25,
		case (select(day(A.SUPDATE))) when  ''26'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p26,
		case (select(day(A.SUPDATE))) when  ''27'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p27,
		case (select(day(A.SUPDATE))) when  ''28'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p28,
		case (select(day(A.SUPDATE))) when  ''29'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p29,
		case (select(day(A.SUPDATE))) when  ''30'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p30,
		case (select(day(A.SUPDATE))) when  ''31'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p31
        FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''+@PCOMP_CODE+''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE='''+@PUNIT_CODE+''' AND
        A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND 
		A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND A.PUBL='''+@PPUBL+''' AND (A.EDTN='''+@PEDTN+''' OR '''+@PEDTN+''' IS NULL or '''+@PEDTN+'''='''') AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+'''='''') AND
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL OR '''+@PSTATECD+'''='''') AND 
        (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND 
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND 
        A.SUPDATE BETWEEN '''+@VFRDT+''' AND '''+@VTODT+''' AND isnull(A.SUP_COPY,0)>0
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE) d
        GROUP BY d.COMP_CODE,d.UNIT_CODE
        ORDER BY d.COMP_CODE,d.UNIT_CODE;'

	PRINT @pquery
	PRINT @pquery1
	PRINT @pquery2

	exec(@pquery)
	exec(@pquery1)
	exec(@pquery2)
	
END





*********** for dist ****************




ALTER PROCEDURE [dbo].[cir_rep_supply_cir_rep_dist_daybook]
	@pcomp_code		VARCHAR(20) ,
	@punit_code     VARCHAR(20) ,
	@ppubl          VARCHAR(20) ,
	@pedtn          VARCHAR(20) ,
	@pcitycd        VARCHAR(20) ,
	@pstatecd       VARCHAR(20) ,
	@pmonth         VARCHAR(20) ,
	@pyear          VARCHAR(20) ,
	@pdateformat    VARCHAR(20) ,
	@pbranch        varchar(20),
	@pdistcode      varchar(20),
	@ptaluka        varchar(20),
	@pagtype        varchar(20),
	@pagclass       varchar(20),
	@pagcode        varchar(20),
	@pdpcode        varchar(20),
	@pextra1        varchar(200),
	@pextra2        varchar(200),
	@pextra3        varchar(200),
	@pextra4        varchar(200),
	@pextra5        varchar(200)
AS 
	DECLARE @vfrdt         VARCHAR(20)
	DECLARE @vtodt         VARCHAR(20)
	DECLARE @vtodt1         VARCHAR(20)
	DECLAre @pquery         varchar(8000)
	DECLAre @pquery1         varchar(8000)
	DECLAre @pquery2         varchar(8000)
	PRINT('2')


if(@pmonth = 'jan') begin
   set  @pmonth = '01'
end  
else if(@pmonth = 'feb') begin
   set  @pmonth = '02'
end  
else if(@pmonth = 'mar') begin
   set  @pmonth = '03'
end  
else if(@pmonth = 'apr') begin
   set  @pmonth = '04'
end  
else if(@pmonth = 'may') begin
   set  @pmonth = '05'
end  
else if(@pmonth = 'jun') begin
   set  @pmonth = '06'
end  
else if(@pmonth = 'jul') begin
   set  @pmonth = '07'
end  
else if(@pmonth = 'aug') begin
   set  @pmonth = '08'
end  
else if(@pmonth = 'sep') begin
   set  @pmonth = '09'
end  
else if(@pmonth = 'oct') begin
   set  @pmonth = '10'
end 
else if(@pmonth = 'nov') begin
   set  @pmonth = '11'
end 
else if(@pmonth = 'dec') begin
   set  @pmonth = '12'
end  
else begin
   set	@pmonth = '00'
end   



	SET @vfrdt=(@pmonth+'/'+'01/'+@pyear) 
	PRINT( @vfrdt) 
	SET @vtodt1=([dbo].[GetLastDayOfMonth](@vfrdt))
	PRINT('2') 
	set @vtodt=SUBSTRING(@vtodt1,5,2)
	print @vtodt1
	SET @vtodt=(@pmonth+'/'+@vtodt+'/'+@pyear) 
	PRINT @vtodt
	print '3'

	set @pquery='SELECT COMP_CODE, UNIT_CODE, AGCD "AGENCY CODE", DPCD "AGENCY SUBCODE", substrING(dbo.cir_get_name_cir_agname(comp_code,unit_code,agcd,dpcd,1,'''','''',''''),1,50) "AGENCY NAME",
	substring(dbo.cir_get_name_cir_agname(comp_code,unit_code,agcd,dpcd,2,'''','''',''''),1,50) "AGENCY ONAME",
    EDTN,dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION NAME",dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION ONAME",
	CITY_CODE "CITY CODE",dbo.cir_get_city(COMP_CODE,CITY_CODE) "CITY NAME",dbo.cir_get_name_cir_city(COMP_CODE,CITY_CODE,2,'''','''','''') "CITY ONAME",
    isnull(DIST_CODE,''NA'') "DIST CODE",isnull(dbo.cir_get_dist(COMP_CODE,STATE_CODE, DIST_CODE),''NA'') "DISTRICT NAME",
    isnull( dbo.cir_get_name_cir_district(COMP_CODE,DIST_CODE,2,'''','''',''''),''NA'') "DISTRICT ONAME",
    STATE_CODE,
	SUM(p01) AS "01", SUM(p02) AS "02", SUM(p03) AS "03", SUM(p04) AS "04", SUM(p05) AS "05", SUM(p06) AS "06", SUM(p07) AS "07",
	SUM(p08) AS "08", SUM(p09) AS "09", SUM(p10) AS "10", SUM(p11) AS "11", SUM(p12) AS "12", SUM(p13) AS "13", SUM(p14) AS "14",
    SUM(p15) AS "15", SUM(p16) AS "16", SUM(p17) AS "17", SUM(p18) AS "18", SUM(p19) AS "19", SUM(p20) AS "20", SUM(p21) AS "21",
	SUM(p22) AS "22", SUM(p23) AS "23", SUM(p24) AS "24", SUM(p25) AS "25", SUM(p26) AS "26", SUM(p27) AS "27", SUM(p28) AS "28",
	SUM(p29) AS "29", SUM(p30) AS "30", SUM(p31) AS "31",
	SUM(ISNULL(p01, 0) + ISNULL(p02, 0) + ISNULL(p03, 0) + ISNULL(p04, 0) + ISNULL(p05, 0) + ISNULL(p06, 0) + ISNULL(p07, 0) + ISNULL(p08, 0) + 
    ISNULL(p09, 0) + ISNULL(p10, 0) + ISNULL(p11, 0) + ISNULL(p12, 0) + ISNULL(p13, 0) + ISNULL(p14, 0) + ISNULL(p15, 0) + ISNULL(p16, 0) + ISNULL(p17, 0) +
    ISNULL(p18, 0) + ISNULL(p19, 0) + ISNULL(p20, 0) + ISNULL(p21, 0) + ISNULL(p22, 0) + ISNULL(p23, 0) + ISNULL(p24, 0) + ISNULL(p25, 0) + ISNULL(p26, 0) + 
    ISNULL(p27, 0) + ISNULL(p28, 0) + ISNULL(p29, 0) + ISNULL(p30, 0) + ISNULL(p31, 0)) AS "TOTAL"
	FROM (	SELECT A.COMP_CODE COMP_CODE,	 A.UNIT_CODE UNIT_CODE,	 A.AGCD AGCD, A.DPCD DPCD, A.EDTN EDTN, B.CITY_CODE,
	B.DIST_CODE DIST_CODE, B.STATE_CODE STATE_CODE,
	    case (select(day(A.SUPDATE))) when  ''1'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p01,
		case (select(day(A.SUPDATE))) when  ''02'' then SUM(isnull(A.SUP_COPY,0))else 0 end as p02,
        case (select(day(A.SUPDATE))) when  ''03'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p03,
		case (select(day(A.SUPDATE))) when  ''04'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p04,
        case (select(day(A.SUPDATE))) when  ''05'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p05,
        case (select(day(A.SUPDATE))) when  ''06'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p06,
        case (select(day(A.SUPDATE))) when  ''07'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p07,
        case (select(day(A.SUPDATE))) when  ''08'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p08,
        case (select(day(A.SUPDATE))) when  ''09'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p09,
        case (select(day(A.SUPDATE))) when  ''10'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p10,
        case (select(day(A.SUPDATE))) when  ''11'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p11,
        case (select(day(A.SUPDATE))) when  ''12'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p12,
        case (select(day(A.SUPDATE))) when  ''13'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p13,
        case (select(day(A.SUPDATE))) when  ''14'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p14,
        case (select(day(A.SUPDATE))) when  ''15'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p15,
        case (select(day(A.SUPDATE))) when  ''16'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p16,
        case (select(day(A.SUPDATE))) when  ''17'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p17,
        case (select(day(A.SUPDATE))) when  ''18'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p18,
		case (select(day(A.SUPDATE))) when  ''19'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p19,
		case (select(day(A.SUPDATE))) when  ''20'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p20,
		case (select(day(A.SUPDATE))) when  ''21'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p21,
		case (select(day(A.SUPDATE))) when  ''22'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p22,
		case (select(day(A.SUPDATE))) when  ''23'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p23,
		case (select(day(A.SUPDATE))) when  ''24'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p24,
		case (select(day(A.SUPDATE))) when  ''25'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p25,
		case (select(day(A.SUPDATE))) when  ''26'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p26,
		case (select(day(A.SUPDATE))) when  ''27'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p27,
		case (select(day(A.SUPDATE))) when  ''28'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p28,
		case (select(day(A.SUPDATE))) when  ''29'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p29,
		case (select(day(A.SUPDATE))) when  ''30'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p30,
		case (select(day(A.SUPDATE))) when  ''31'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p31
		FROM  CIR_DBKSUP A, CIR_AGMAST B, CIR_SUPPLY_TYPE_MAST C 
		WHERE A.COMP_CODE  = B.COMP_CODE AND	A.COMP_CODE  = C.COMP_CODE AND	A.COMP_CODE  = '''+@PCOMP_CODE+'''
		AND	A.UNIT_CODE  = B.UNIT AND A.UNIT_CODE  = '''+@PUNIT_CODE+''' AND	A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND 
		A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND A.PUBL  = '''+@PPUBL+''' 
        AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') 
        AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') AND
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL OR '''+@PSTATECD+'''='''') AND 
        (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND 
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND A.SUPDATE  BETWEEN '''+@VFRDT+'''  AND  '''+@VTODT+''' AND	ISNULL(A.SUP_COPY, 0)  > 0
		GROUP BY  A.COMP_CODE,A.UNIT_CODE,A.AGCD,A.DPCD,A.SUPDATE,A.EDTN,B.CITY_CODE,B.DIST_CODE,B.STATE_CODE) d
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.AGCD,d.DPCD,d.EDTN,d.CITY_CODE,d.DIST_CODE,d.STATE_CODE
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.DIST_CODE,d.CITY_CODE,d.EDTN,d.AGCD,d.DPCD;'
		
	print @pquery	
	
		set @pquery1='SELECT COMP_CODE, UNIT_CODE, ISNULL(DIST_CODE, ''NA'') DIST_CODE,
		isnull(dbo.cir_get_dist(COMP_CODE,STATE_CODE, DIST_CODE),''NA'') "DISTRICT NAME",
		isnull( dbo.cir_get_name_cir_district(COMP_CODE,DIST_CODE,2,'''','''',''''),''NA'') "DISTRICT ONAME",
	    STATE_CODE,
		  SUM(p01) AS "01",SUM(p02) AS "02",SUM(p03) AS "03",SUM(p04) AS "04",SUM(p05) AS "05",
        SUM(p06) AS "06",SUM(p07) AS "07",SUM(p08) AS "08",SUM(p09) AS "09",SUM(p10) AS "10",
        SUM(p11) AS "11",SUM(p12) AS "12",SUM(p13) AS "13",SUM(p14) AS "14",SUM(p15) AS "15",
        SUM(p16) AS "16",SUM(p17) AS "17",SUM(p18) AS "18",SUM(p19) AS "19",SUM(p20) AS "20",
        SUM(p21) AS "21",SUM(p22) AS "22",SUM(p23) AS "23",SUM(p24) AS "24",SUM(p25) AS "25",
        SUM(p26) AS "26",SUM(p27) AS "27",SUM(p28) AS "28",SUM(p29) AS "29",SUM(p30) AS "30",SUM(p31) AS "31",
		SUM(ISNULL(p01, 0) + ISNULL(p02, 0) + ISNULL(p03, 0) + ISNULL(p04, 0) + ISNULL(p05, 0) + ISNULL(p06, 0) + ISNULL(p07, 0) + ISNULL(p08, 0) + 
		ISNULL(p09, 0) + ISNULL(p10, 0) + ISNULL(p11, 0) + ISNULL(p12, 0) + ISNULL(p13, 0) + ISNULL(p14, 0) + ISNULL(p15, 0) + ISNULL(p16, 0) + ISNULL(p17, 0) +
		ISNULL(p18, 0) + ISNULL(p19, 0) + ISNULL(p20, 0) + ISNULL(p21, 0) + ISNULL(p22, 0) + ISNULL(p23, 0) + ISNULL(p24, 0) + ISNULL(p25, 0) + ISNULL(p26, 0) + 
		ISNULL(p27, 0) + ISNULL(p28, 0) + ISNULL(p29, 0) + ISNULL(p30, 0) + ISNULL(p31, 0)) AS "TOTAL"
		FROM (	SELECT A.COMP_CODE COMP_CODE, A.UNIT_CODE UNIT_CODE, B.DIST_CODE DIST_CODE, B.STATE_CODE STATE_CODE,
		   case (select(day(A.SUPDATE))) when  ''1'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p01,
		case (select(day(A.SUPDATE))) when  ''02'' then SUM(isnull(A.SUP_COPY,0))else 0 end as p02,
        case (select(day(A.SUPDATE))) when  ''03'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p03,
		case (select(day(A.SUPDATE))) when  ''04'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p04,
        case (select(day(A.SUPDATE))) when  ''05'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p05,
        case (select(day(A.SUPDATE))) when  ''06'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p06,
        case (select(day(A.SUPDATE))) when  ''07'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p07,
        case (select(day(A.SUPDATE))) when  ''08'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p08,
        case (select(day(A.SUPDATE))) when  ''09'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p09,
        case (select(day(A.SUPDATE))) when  ''10'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p10,
        case (select(day(A.SUPDATE))) when  ''11'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p11,
        case (select(day(A.SUPDATE))) when  ''12'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p12,
        case (select(day(A.SUPDATE))) when  ''13'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p13,
        case (select(day(A.SUPDATE))) when  ''14'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p14,
        case (select(day(A.SUPDATE))) when  ''15'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p15,
        case (select(day(A.SUPDATE))) when  ''16'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p16,
        case (select(day(A.SUPDATE))) when  ''17'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p17,
        case (select(day(A.SUPDATE))) when  ''18'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p18,
		case (select(day(A.SUPDATE))) when  ''19'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p19,
		case (select(day(A.SUPDATE))) when  ''20'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p20,
		case (select(day(A.SUPDATE))) when  ''21'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p21,
		case (select(day(A.SUPDATE))) when  ''22'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p22,
		case (select(day(A.SUPDATE))) when  ''23'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p23,
		case (select(day(A.SUPDATE))) when  ''24'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p24,
		case (select(day(A.SUPDATE))) when  ''25'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p25,
		case (select(day(A.SUPDATE))) when  ''26'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p26,
		case (select(day(A.SUPDATE))) when  ''27'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p27,
		case (select(day(A.SUPDATE))) when  ''28'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p28,
		case (select(day(A.SUPDATE))) when  ''29'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p29,
		case (select(day(A.SUPDATE))) when  ''30'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p30,
		case (select(day(A.SUPDATE))) when  ''31'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p31
		FROM  CIR_DBKSUP A, CIR_AGMAST B, CIR_SUPPLY_TYPE_MAST C 
		WHERE	 A.COMP_CODE  = B.COMP_CODE AND	A.COMP_CODE  = C.COMP_CODE AND	A.COMP_CODE  = '''+@PCOMP_CODE+'''
		AND	A.UNIT_CODE  = B.UNIT AND A.UNIT_CODE  = '''+@PUNIT_CODE+'''
		AND	A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''')
		AND	A.PUBL  = '''+@PPUBL+''' AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') 
		AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') and
		(B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL OR '''+@PSTATECD+'''='''') AND 
		(B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND 
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') 
			 AND A.SUPDATE  BETWEEN '''+@VFRDT +''' AND  '''+@VTODT+'''
			 AND ISNULL(A.SUP_COPY, 0)  > 0
			  GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE,B.DIST_CODE,B.STATE_CODE) d
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.DIST_CODE,d.STATE_CODE
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.DIST_CODE'

	print (@pquery1)
		
		set @pquery2='SELECT COMP_CODE, UNIT_CODE,
		  SUM(p01) AS "01",SUM(p02) AS "02",SUM(p03) AS "03",SUM(p04) AS "04",SUM(p05) AS "05",
        SUM(p06) AS "06",SUM(p07) AS "07",SUM(p08) AS "08",SUM(p09) AS "09",SUM(p10) AS "10",
        SUM(p11) AS "11",SUM(p12) AS "12",SUM(p13) AS "13",SUM(p14) AS "14",SUM(p15) AS "15",
        SUM(p16) AS "16",SUM(p17) AS "17",SUM(p18) AS "18",SUM(p19) AS "19",SUM(p20) AS "20",
        SUM(p21) AS "21",SUM(p22) AS "22",SUM(p23) AS "23",SUM(p24) AS "24",SUM(p25) AS "25",
        SUM(p26) AS "26",SUM(p27) AS "27",SUM(p28) AS "28",SUM(p29) AS "29",SUM(p30) AS "30",SUM(p31) AS "31",
		SUM(ISNULL(p01, 0) + ISNULL(p02, 0) + ISNULL(p03, 0) + ISNULL(p04, 0) + ISNULL(p05, 0) + ISNULL(p06, 0) + ISNULL(p07, 0) + ISNULL(p08, 0) + 
		ISNULL(p09, 0) + ISNULL(p10, 0) + ISNULL(p11, 0) + ISNULL(p12, 0) + ISNULL(p13, 0) + ISNULL(p14, 0) + ISNULL(p15, 0) + ISNULL(p16, 0) + ISNULL(p17, 0) +
		ISNULL(p18, 0) + ISNULL(p19, 0) + ISNULL(p20, 0) + ISNULL(p21, 0) + ISNULL(p22, 0) + ISNULL(p23, 0) + ISNULL(p24, 0) + ISNULL(p25, 0) + ISNULL(p26, 0) + 
		ISNULL(p27, 0) + ISNULL(p28, 0) + ISNULL(p29, 0) + ISNULL(p30, 0) + ISNULL(p31, 0)) AS "TOTAL"
		FROM (	SELECT A.COMP_CODE COMP_CODE, A.UNIT_CODE UNIT_CODE,
		   case (select(day(A.SUPDATE))) when  ''1'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p01,
		case (select(day(A.SUPDATE))) when  ''02'' then SUM(isnull(A.SUP_COPY,0))else 0 end as p02,
        case (select(day(A.SUPDATE))) when  ''03'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p03,
		case (select(day(A.SUPDATE))) when  ''04'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p04,
        case (select(day(A.SUPDATE))) when  ''05'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p05,
        case (select(day(A.SUPDATE))) when  ''06'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p06,
        case (select(day(A.SUPDATE))) when  ''07'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p07,
        case (select(day(A.SUPDATE))) when  ''08'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p08,
        case (select(day(A.SUPDATE))) when  ''09'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p09,
        case (select(day(A.SUPDATE))) when  ''10'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p10,
        case (select(day(A.SUPDATE))) when  ''11'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p11,
        case (select(day(A.SUPDATE))) when  ''12'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p12,
        case (select(day(A.SUPDATE))) when  ''13'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p13,
        case (select(day(A.SUPDATE))) when  ''14'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p14,
        case (select(day(A.SUPDATE))) when  ''15'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p15,
        case (select(day(A.SUPDATE))) when  ''16'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p16,
        case (select(day(A.SUPDATE))) when  ''17'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p17,
        case (select(day(A.SUPDATE))) when  ''18'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p18,
		case (select(day(A.SUPDATE))) when  ''19'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p19,
		case (select(day(A.SUPDATE))) when  ''20'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p20,
		case (select(day(A.SUPDATE))) when  ''21'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p21,
		case (select(day(A.SUPDATE))) when  ''22'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p22,
		case (select(day(A.SUPDATE))) when  ''23'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p23,
		case (select(day(A.SUPDATE))) when  ''24'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p24,
		case (select(day(A.SUPDATE))) when  ''25'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p25,
		case (select(day(A.SUPDATE))) when  ''26'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p26,
		case (select(day(A.SUPDATE))) when  ''27'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p27,
		case (select(day(A.SUPDATE))) when  ''28'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p28,
		case (select(day(A.SUPDATE))) when  ''29'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p29,
		case (select(day(A.SUPDATE))) when  ''30'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p30,
		case (select(day(A.SUPDATE))) when  ''31'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p31
		FROM  CIR_DBKSUP A, CIR_AGMAST B, CIR_SUPPLY_TYPE_MAST C 
		WHERE	 A.COMP_CODE  = B.COMP_CODE AND	A.COMP_CODE  = C.COMP_CODE AND	A.COMP_CODE  = '''+@PCOMP_CODE+'''
		AND	A.UNIT_CODE  = B.UNIT AND	A.UNIT_CODE  = '''+@PUNIT_CODE+'''
		AND	A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''')
		AND	A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''')
		AND	A.PUBL  = '''+@PPUBL+''' AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') 
		AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') AND
		(B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL OR '''+@PSTATECD+'''='''') AND 
		(B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND 
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''')  
		AND	A.SUP_TYPE_CODE  = C.SUP_TY_CODE AND	A.SUPDATE  BETWEEN '''+@VFRDT+'''  AND  '''+@VTODT+'''
		AND	ISNULL(A.SUP_COPY, 0)  > 0
		GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE) d
        GROUP BY d.COMP_CODE, d.UNIT_CODE
        ORDER BY  d.COMP_CODE, d.UNIT_CODE;'
		print (@pquery2)
	exec(@pquery)
	exec(@pquery1)
	exec(@pquery2)
	



*********** for taluka ****************




ALTER PROCEDURE [dbo].[cir_rep_supply_cir_rep_taluka_daybook]
	@pcomp_code		VARCHAR(20) ,
	@punit_code     VARCHAR(20) ,
	@ppubl          VARCHAR(20) ,
	@pedtn          VARCHAR(20) ,
	@pcitycd        VARCHAR(20) ,
	@pstatecd       VARCHAR(20) ,
	@pmonth         VARCHAR(20) ,
	@pyear          VARCHAR(20) ,
	@pdateformat    VARCHAR(20) ,
	@pbranch        varchar(20),
    @pdistcode      varchar(20),
    @ptaluka        varchar(20),
    @pagtype        varchar(20),
    @pagclass       varchar(20),
    @pagcode        varchar(20),
    @pdpcode        varchar(20),
    @pextra1        varchar(200),--it is used for supply type
    @pextra2        varchar(200),
    @pextra3        varchar(200),
    @pextra4        varchar(200),
    @pextra5        varchar(200)
	
AS 
	
		
	DECLARE @vfrdt         VARCHAR(20)
	DECLARE @vtodt         VARCHAR(20)
	DECLARE @vtodt1         VARCHAR(20)
	DECLAre @pquery         varchar(8000)
	DECLAre @pquery1         varchar(8000)
	DECLAre @pquery2         varchar(8000)
    PRINT('2')

if(@pmonth = 'jan')
begin
   set  @pmonth = '01'
end  
else if(@pmonth = 'feb')
begin
   set  @pmonth = '02'
end  
else if(@pmonth = 'mar')
begin
   set  @pmonth = '03'
end  
else if(@pmonth = 'apr')
begin
   set  @pmonth = '04'
end  
else if(@pmonth = 'may')
begin
   set  @pmonth = '05'
end  
else if(@pmonth = 'jun')
begin
   set  @pmonth = '06'
end  
else if(@pmonth = 'jul')
begin
   set  @pmonth = '07'
end  
else if(@pmonth = 'aug')
begin
   set  @pmonth = '08'
end  
else if(@pmonth = 'sep')
begin
   set  @pmonth = '09'
end  
else if(@pmonth = 'oct')
begin
   set  @pmonth = '10'
end 
else if(@pmonth = 'nov')
begin
   set  @pmonth = '11'
end 
else if(@pmonth = 'dec')
begin
   set  @pmonth = '12'
end  
else 
begin
   set  @pmonth = '00'
end   


        SET @vfrdt=(@pmonth+'/'+'01/'+@pyear) 
		PRINT( @vfrdt) 
		SET @vtodt1=([dbo].[GetLastDayOfMonth](@vfrdt))
        PRINT('2') 
		set @vtodt=SUBSTRING(@vtodt1,5,2)
		print @vtodt1
	    SET @vtodt=(@pmonth+'/'+@vtodt+'/'+@pyear) 
		PRINT @vtodt





		set @pquery='SELECT COMP_CODE, UNIT_CODE, AGCD "AGENCY CODE", DPCD "AGENCY SUBCODE",
		substrING(dbo.cir_get_name_cir_agname(comp_code,unit_code,agcd,dpcd,1,'''','''',''''),1,50) "AGENCY NAME",
		 substring(dbo.cir_get_name_cir_agname(comp_code,unit_code,agcd,dpcd,2,'''','''',''''),1,50) "AGENCY ONAME",
		d.EDTN,dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION NAME",
        dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION ONAME",
		CITY_CODE "CITY CODE",dbo.cir_get_city(COMP_CODE,CITY_CODE) "CITY NAME",
        dbo.cir_get_name_cir_city(COMP_CODE,CITY_CODE,2,'''','''','''') "CITY ONAME",
        isnull(TEHSIL_TALUKA,''NA'') "TALUKA CODE",
	    isnull(dbo.cir_get_taluka(COMP_CODE, TEHSIL_TALUKA),''NA'') "TALUKA NAME",
		isnull( dbo.cir_get_name_cir_taluka(COMP_CODE,TEHSIL_TALUKA,2,'''','''',''''),''NA'') "TALUKA ONAME",
		STATE_CODE "STATE CODE",
		   SUM(p01) as  "01",SUM(p02) AS "02",SUM(p03) AS "03",SUM(p04) AS "04",SUM(p05) AS "05",
       SUM(p06) AS "06",SUM(p07) AS "07",SUM(p08) AS "08",SUM(p09) AS "09",SUM(p10) AS "10",
       SUM(p11) AS "11",SUM(p12) AS "12",SUM(p13) AS "13",SUM(p14) AS "14",SUM(p15) AS "15",
       SUM(p16) AS "16",SUM(p17) AS "17",SUM(p18) AS "18",SUM(p19) AS "19",SUM(p20) AS "20",
       SUM(p21) AS "21",SUM(p22) AS "22",SUM(p23) AS "23",SUM(p24) AS "24",SUM(p25) AS "25",
       SUM(p26) AS "26",SUM(p27) AS "27",SUM(p28) AS "28",SUM(p29) AS "29",SUM(p30) AS "30",
		SUM(p31) AS "31",
		 SUM(isnull(p01,0)+isnull(p02,0)+isnull(p03,0)+isnull(p04,0)+isnull(p05,0)+isnull(p06,0)+isnull(p07,0)+isnull(p08,0)+isnull(p09,0)+isnull(p10,0)+
            isnull(p11,0)+isnull(p12,0)+isnull(p13,0)+isnull(p14,0)+isnull(p15,0)+isnull(p16,0)+isnull(p17,0)+isnull(p18,0)+isnull(p19,0)+isnull(p20,0)+
            isnull(p21,0)+isnull(p22,0)+isnull(p23,0)+isnull(p24,0)+isnull(p25,0)+isnull(p26,0)+isnull(p27,0)+isnull(p28,0)+isnull(p29,0)+isnull(p30,0)+isnull(p31,0)) AS "TOTAL"
		FROM (	SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,A.EDTN EDTN,B.CITY_CODE,B.TEHSIL_TALUKA TEHSIL_TALUKA,B.STATE_CODE STATE_CODE,
	   case (select(day(A.SUPDATE))) when  ''1'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p01,
		case (select(day(A.SUPDATE))) when  ''02'' then SUM(isnull(A.SUP_COPY,0))else 0 end as p02,
        case (select(day(A.SUPDATE))) when  ''03'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p03,
		case (select(day(A.SUPDATE))) when  ''04'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p04,
        case (select(day(A.SUPDATE))) when  ''05'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p05,
        case (select(day(A.SUPDATE))) when  ''06'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p06,
        case (select(day(A.SUPDATE))) when  ''07'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p07,
        case (select(day(A.SUPDATE))) when  ''08'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p08,
        case (select(day(A.SUPDATE))) when  ''09'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p09,
        case (select(day(A.SUPDATE))) when  ''10'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p10,
        case (select(day(A.SUPDATE))) when  ''11'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p11,
        case (select(day(A.SUPDATE))) when  ''12'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p12,
        case (select(day(A.SUPDATE))) when  ''13'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p13,
        case (select(day(A.SUPDATE))) when  ''14'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p14,
        case (select(day(A.SUPDATE))) when  ''15'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p15,
        case (select(day(A.SUPDATE))) when  ''16'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p16,
        case (select(day(A.SUPDATE))) when  ''17'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p17,
        case (select(day(A.SUPDATE))) when  ''18'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p18,
		case (select(day(A.SUPDATE))) when  ''19'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p19,
		case (select(day(A.SUPDATE))) when  ''20'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p20,
		case (select(day(A.SUPDATE))) when  ''21'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p21,
		case (select(day(A.SUPDATE))) when  ''22'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p22,
		case (select(day(A.SUPDATE))) when  ''23'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p23,
		case (select(day(A.SUPDATE))) when  ''24'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p24,
		case (select(day(A.SUPDATE))) when  ''25'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p25,
		case (select(day(A.SUPDATE))) when  ''26'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p26,
		case (select(day(A.SUPDATE))) when  ''27'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p27,
		case (select(day(A.SUPDATE))) when  ''28'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p28,
		case (select(day(A.SUPDATE))) when  ''29'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p29,
		case (select(day(A.SUPDATE))) when  ''30'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p30,
		case (select(day(A.SUPDATE))) when  ''31'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p31
			FROM  CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C 
			WHERE A.COMP_CODE  = B.COMP_CODE AND	A.COMP_CODE  = C.COMP_CODE AND	A.COMP_CODE  = '''+@PCOMP_CODE+'''
			 AND A.UNIT_CODE  = B.UNIT AND	A.UNIT_CODE  = '''+@PUNIT_CODE+'''
			 AND A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND 
			A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND A.PUBL  = '''+@ppubl+'''
			 AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') 
             AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') and
			(B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL OR '''+@PSTATECD+'''='''') AND 
			(B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND 
			(B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND
			A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''')  
			AND A.SUPDATE  BETWEEN '''+@VFRDT+'''  AND  '''+@VTODT+''' AND ISNULL(A.SUP_COPY, 0)  > 0
		  GROUP BY A.COMP_CODE,A.UNIT_CODE,A.AGCD,A.DPCD,A.SUPDATE,A.EDTN,B.CITY_CODE,B.TEHSIL_TALUKA,B.STATE_CODE) d
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.AGCD,d.DPCD,d.EDTN,d.CITY_CODE,d.TEHSIL_TALUKA,d.STATE_CODE
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.TEHSIL_TALUKA,d.CITY_CODE,d.EDTN,d.AGCD,d.DPCD;'

		
		
	
			set @pquery1='SELECT COMP_CODE, UNIT_CODE,isnull(TEHSIL_TALUKA,''NA'') "TALUKA CODE",
    isnull(dbo.cir_get_taluka(COMP_CODE, TEHSIL_TALUKA),''NA'') "TALUKA NAME",
    isnull( dbo.cir_get_name_cir_taluka(COMP_CODE,TEHSIL_TALUKA,2,'''','''',''''),''NA'') "TALUKA ONAME",STATE_CODE "STATE CODE",
			   SUM(p01) as  "01",SUM(p02) AS "02",SUM(p03) AS "03",SUM(p04) AS "04",SUM(p05) AS "05",
       SUM(p06) AS "06",SUM(p07) AS "07",SUM(p08) AS "08",SUM(p09) AS "09",SUM(p10) AS "10",
       SUM(p11) AS "11",SUM(p12) AS "12",SUM(p13) AS "13",SUM(p14) AS "14",SUM(p15) AS "15",
       SUM(p16) AS "16",SUM(p17) AS "17",SUM(p18) AS "18",SUM(p19) AS "19",SUM(p20) AS "20",
       SUM(p21) AS "21",SUM(p22) AS "22",SUM(p23) AS "23",SUM(p24) AS "24",SUM(p25) AS "25",
       SUM(p26) AS "26",SUM(p27) AS "27",SUM(p28) AS "28",SUM(p29) AS "29",SUM(p30) AS "30",
	   SUM(p31) AS "31",
	   SUM(isnull(p01,0)+isnull(p02,0)+isnull(p03,0)+isnull(p04,0)+isnull(p05,0)+isnull(p06,0)+isnull(p07,0)+isnull(p08,0)+isnull(p09,0)+isnull(p10,0)+
       isnull(p11,0)+isnull(p12,0)+isnull(p13,0)+isnull(p14,0)+isnull(p15,0)+isnull(p16,0)+isnull(p17,0)+isnull(p18,0)+isnull(p19,0)+isnull(p20,0)+
       isnull(p21,0)+isnull(p22,0)+isnull(p23,0)+isnull(p24,0)+isnull(p25,0)+isnull(p26,0)+isnull(p27,0)+isnull(p28,0)+isnull(p29,0)+isnull(p30,0)+isnull(p31,0)) AS "TOTAL"
		FROM (	SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,B.TEHSIL_TALUKA TEHSIL_TALUKA,B.STATE_CODE STATE_CODE,
		 case (select(day(A.SUPDATE))) when  ''1'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p01,
		case (select(day(A.SUPDATE))) when  ''02'' then SUM(isnull(A.SUP_COPY,0))else 0 end as p02,
        case (select(day(A.SUPDATE))) when  ''03'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p03,
		case (select(day(A.SUPDATE))) when  ''04'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p04,
        case (select(day(A.SUPDATE))) when  ''05'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p05,
        case (select(day(A.SUPDATE))) when  ''06'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p06,
        case (select(day(A.SUPDATE))) when  ''07'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p07,
        case (select(day(A.SUPDATE))) when  ''08'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p08,
        case (select(day(A.SUPDATE))) when  ''09'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p09,
        case (select(day(A.SUPDATE))) when  ''10'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p10,
        case (select(day(A.SUPDATE))) when  ''11'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p11,
        case (select(day(A.SUPDATE))) when  ''12'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p12,
        case (select(day(A.SUPDATE))) when  ''13'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p13,
        case (select(day(A.SUPDATE))) when  ''14'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p14,
        case (select(day(A.SUPDATE))) when  ''15'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p15,
        case (select(day(A.SUPDATE))) when  ''16'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p16,
        case (select(day(A.SUPDATE))) when  ''17'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p17,
        case (select(day(A.SUPDATE))) when  ''18'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p18,
		case (select(day(A.SUPDATE))) when  ''19'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p19,
		case (select(day(A.SUPDATE))) when  ''20'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p20,
		case (select(day(A.SUPDATE))) when  ''21'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p21,
		case (select(day(A.SUPDATE))) when  ''22'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p22,
		case (select(day(A.SUPDATE))) when  ''23'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p23,
		case (select(day(A.SUPDATE))) when  ''24'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p24,
		case (select(day(A.SUPDATE))) when  ''25'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p25,
		case (select(day(A.SUPDATE))) when  ''26'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p26,
		case (select(day(A.SUPDATE))) when  ''27'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p27,
		case (select(day(A.SUPDATE))) when  ''28'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p28,
		case (select(day(A.SUPDATE))) when  ''29'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p29,
		case (select(day(A.SUPDATE))) when  ''30'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p30,
		case (select(day(A.SUPDATE))) when  ''31'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p31
			FROM  CIR_DBKSUP A, CIR_AGMAST B, CIR_SUPPLY_TYPE_MAST C 
			WHERE A.COMP_CODE  = B.COMP_CODE AND A.COMP_CODE  = C.COMP_CODE AND A.COMP_CODE  = '''+@PCOMP_CODE+'''
			 AND A.UNIT_CODE  = B.UNIT AND A.UNIT_CODE  = '''+@PUNIT_CODE+'''
			 AND A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND 
		A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND A.PUBL  = '''+@PPUBL+'''
	     	 AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') 
             AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') and
			(B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL OR '''+@PSTATECD+'''='''') AND 
			(B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND 
			(B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND
			A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND  A.SUPDATE  BETWEEN '''+@VFRDT+'''  AND  '''+@VTODT+'''
			AND ISNULL(A.SUP_COPY, 0)  > 0 
			GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE,B.TEHSIL_TALUKA,B.STATE_CODE) d
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.TEHSIL_TALUKA,d.STATE_CODE
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.TEHSIL_TALUKA;'


		set @pquery2='SELECT COMP_CODE, UNIT_CODE,
		SUM(p01) as  "01",SUM(p02) AS "02",SUM(p03) AS "03",SUM(p04) AS "04",SUM(p05) AS "05",
       SUM(p06) AS "06",SUM(p07) AS "07",SUM(p08) AS "08",SUM(p09) AS "09",SUM(p10) AS "10",
       SUM(p11) AS "11",SUM(p12) AS "12",SUM(p13) AS "13",SUM(p14) AS "14",SUM(p15) AS "15",
       SUM(p16) AS "16",SUM(p17) AS "17",SUM(p18) AS "18",SUM(p19) AS "19",SUM(p20) AS "20",
       SUM(p21) AS "21",SUM(p22) AS "22",SUM(p23) AS "23",SUM(p24) AS "24",SUM(p25) AS "25",
       SUM(p26) AS "26",SUM(p27) AS "27",SUM(p28) AS "28",SUM(p29) AS "29",SUM(p30) AS "30",
	   SUM(p31) AS "31",
		  SUM(isnull(p01,0)+isnull(p02,0)+isnull(p03,0)+isnull(p04,0)+isnull(p05,0)+isnull(p06,0)+isnull(p07,0)+isnull(p08,0)+isnull(p09,0)+isnull(p10,0)+
       isnull(p11,0)+isnull(p12,0)+isnull(p13,0)+isnull(p14,0)+isnull(p15,0)+isnull(p16,0)+isnull(p17,0)+isnull(p18,0)+isnull(p19,0)+isnull(p20,0)+
       isnull(p21,0)+isnull(p22,0)+isnull(p23,0)+isnull(p24,0)+isnull(p25,0)+isnull(p26,0)+isnull(p27,0)+isnull(p28,0)+isnull(p29,0)+isnull(p30,0)+isnull(p31,0)) AS "TOTAL"
		FROM (	SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,
		 case (select(day(A.SUPDATE))) when  ''1'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p01,
		case (select(day(A.SUPDATE))) when  ''02'' then SUM(isnull(A.SUP_COPY,0))else 0 end as p02,
        case (select(day(A.SUPDATE))) when  ''03'' then SUM(isnull(A.SUP_COPY,0))  else 0 end as p03,
		case (select(day(A.SUPDATE))) when  ''04'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p04,
        case (select(day(A.SUPDATE))) when  ''05'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p05,
        case (select(day(A.SUPDATE))) when  ''06'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p06,
        case (select(day(A.SUPDATE))) when  ''07'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p07,
        case (select(day(A.SUPDATE))) when  ''08'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p08,
        case (select(day(A.SUPDATE))) when  ''09'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p09,
        case (select(day(A.SUPDATE))) when  ''10'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p10,
        case (select(day(A.SUPDATE))) when  ''11'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p11,
        case (select(day(A.SUPDATE))) when  ''12'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p12,
        case (select(day(A.SUPDATE))) when  ''13'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p13,
        case (select(day(A.SUPDATE))) when  ''14'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p14,
        case (select(day(A.SUPDATE))) when  ''15'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p15,
        case (select(day(A.SUPDATE))) when  ''16'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p16,
        case (select(day(A.SUPDATE))) when  ''17'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p17,
        case (select(day(A.SUPDATE))) when  ''18'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p18,
		case (select(day(A.SUPDATE))) when  ''19'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p19,
		case (select(day(A.SUPDATE))) when  ''20'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p20,
		case (select(day(A.SUPDATE))) when  ''21'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p21,
		case (select(day(A.SUPDATE))) when  ''22'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p22,
		case (select(day(A.SUPDATE))) when  ''23'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p23,
		case (select(day(A.SUPDATE))) when  ''24'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p24,
		case (select(day(A.SUPDATE))) when  ''25'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p25,
		case (select(day(A.SUPDATE))) when  ''26'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p26,
		case (select(day(A.SUPDATE))) when  ''27'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p27,
		case (select(day(A.SUPDATE))) when  ''28'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p28,
		case (select(day(A.SUPDATE))) when  ''29'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p29,
		case (select(day(A.SUPDATE))) when  ''30'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p30,
		case (select(day(A.SUPDATE))) when  ''31'' then SUM(isnull(A.SUP_COPY,0)) else 0 end as p31
			FROM  CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C 
			WHERE A.COMP_CODE  = B.COMP_CODE AND A.COMP_CODE  = C.COMP_CODE AND A.COMP_CODE  = '''+@PCOMP_CODE+'''
			 AND A.UNIT_CODE  = B.UNIT AND A.UNIT_CODE  = '''+@PUNIT_CODE+'''
			 AND A.AGCD  = B.AGCD AND (A.AGCD='+''''+@PAGCODE+''''+' OR '+''''+@PAGCODE+'''='''') AND 
			A.DPCD  = B.DPCD AND (A.DPCD='+''''+@PDPCODE+''''+' OR '+''''+@PDPCODE+'''='''') AND A.PUBL  = '''+@PPUBL+'''
			AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') 
             AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') AND
			(B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL OR '''+@PSTATECD+'''='''') AND 
			(B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND 
			(B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND
			A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND 
			A.SUPDATE  BETWEEN '''+@VFRDT+'''  AND  '''+@VTODT+''' AND	ISNULL(A.SUP_COPY, 0)  > 0
		  GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE)  d
        GROUP BY d.COMP_CODE,d.UNIT_CODE
        ORDER BY d.COMP_CODE,d.UNIT_CODE;'
		
PRINT @pquery
exec(@pquery)
	exec(@pquery1)
	exec(@pquery2)




***************** for function ********************



create FUNCTION  [dbo].[cir_get_agency_city](
@pcomp_code		as varchar(100),
@punit_code		as varchar(100),
@pagcd			as varchar(100),
@pdpcd			as varchar(100))  
returns varchar(1000) 
AS  
BEGIN 
DECLARE @v_city_name  VARCHAR(4000)

select @v_city_name =x.city_name from
(select dbo.cir_get_city(comp_code,city_code) city_name
from cir_agmast 
         where comp_code=@pcomp_code and
               unit=@punit_code and
               agcd=@pagcd and
               dpcd=@pdpcd
union
select dbo.cir_get_city(comp_code,city_code) city_name
from cir_agmast_dis
         where comp_code=@pcomp_code and
               unit=@punit_code and
               agcd=@pagcd and
               dpcd=@pdpcd) x
	   
RETURN isnull(@v_city_name ,'')
END




/******************************* end of issue 0004566 , 0004698 3-jan-2012 *****************************/




/*******************************  issue 5717*****************************/



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[cir_demographic_cir_dist_bind]
	@pcomp_code                               VARCHAR(20) ,
	@pstate_code                              VARCHAR(20) ,
	@pdist_code                               VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(400) ,
	@pextra2                                  VARCHAR(400) 
AS 
	If @pstate_code='' Begin
		set @pstate_code=null
	End
	If @pdist_code='' Begin
		set @pdist_code=null
	End	
	If @pextra1='' Begin
		set @pextra1=null
	End		

	SELECT * FROM  cir_dist_mast 
	WHERE comp_code  = @pcomp_code
	 AND (state_Code  = @pstate_code OR	@pstate_code  is null)
	 AND ((dist_code  = @pdist_code) OR	(@pdist_code  is null))
	 AND ((UPPER(dist_name)  like UPPER(@pextra1) + '%') OR	(@pextra1  is null))
	ORDER BY dist_name 
		






/******************************* end of issue 5717 *****************************/





/***********************mimoh 28dec 2011*********6162****************************************/
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go







ALTER PROCEDURE   [dbo].[wesp_updatedate1]

@compcode as varchar(15),
@userid as varchar(15),
@dateformat as varchar(15),
@code as varchar(4),
@curr as varchar(8),
@ratecode as varchar(8),
@solo as varchar(15),
@breakup as varchar(2),
@bwcode as varchar(8),
@rostatus as varchar(2),
@filename as varchar(2),
@tfn as VARCHAR(4),
@insertbreak as varchar(2),
@prem as varchar(8),
@dealtype as varchar(2),
@pre as varchar(5),
@suff as varchar(5),
@financestatus as  char(2),
@voucherst as varchar(30),
@adcode as varchar(100),
@rodatetime as varchar(8),
@spacearea as varchar(8),
@vat as varchar(50),
@bookstat as varchar(25),
@cio_id as varchar(8),
@receipt_no as varchar(50),
@uom as varchar(8),
@bgcolor as varchar(10),
@validdate as varchar(10),
@agencyratecode as varchar(10),
@audit as varchar(8),
@book_insert_date as varchar(8),
@agencycomm as varchar(8),
@rateaudit as varchar(8),
@billaudit as varchar(8),
@billtype as varchar(8),
@invoice_no as varchar(50),
@copybooking as varchar(8),
@ratecompany as varchar(50),
@addagenycomm as varchar(50),
@agencycommlinkretainer as varchar(50),
@subeditionr as varchar(50),
@displaybilltype as varchar(50),
@classifiedbilltype as varchar(50),
@billformat as varchar(50),
@ratechk as varchar(50),
@allpkg as varchar(50),
@dayrate1 as varchar(50),
@schemetype as varchar(50),
@PIncludeclassi as varchar(50),
@receiptformat as varchar(50),
@cash_receipt as varchar(50),
@bill_orderwiselast as varchar(50),
@floor_chk as varchar(50),
@Unsoldflag as varchar(1),
@Supplystopper as varchar(10),
@drpRokeychk as varchar(1),
@Agencycomm_seq as varchar(1),
@creditreciept as varchar(1),
@cashindisplay as varchar(8),
@cashinclassified as varchar(8),
@rate_audit_pref as varchar(25),
@v_barcoding_allow as varchar(25),
@v_fmgbills AS VARCHAR(25),
@v_billed_cashdis as varchar(25),
@v_billed_cashcls as varchar(25),
@v_drpbackdate as varchar(25),
@dockitbooking as varchar(1),
@allowprevbooking as varchar(1),
@ro_wisecashbill as varchar(50),
@chkval as varchar(5),
@approval1 as varchar(50),
@pckstatus as varchar(3),
@cash_disc as varchar(1),
@cash_amt as varchar(10),
@seperate_cashier1 as varchar(10),
@disp_bill as varchar(1),
@clas_bill as varchar(1),
@mantimepost as varchar(1),
@bkdaypost as int,
@maxterutn as int,
@cir_return as varchar(1),
@noofchkbounc as int,
@noofdaychkrec as int,
@retday as int,
@chngsuppord as int,
@max_publishday as int,
@p_billno_period as varchar(15),
@spl_trans_edit as varchar(5),
@spl_dis_trans_editable as varchar(5),
@mul_pac_sel_trans as varchar(5),
@shmon_minword	as varchar(1),
@tradon_spcrg	as varchar(1),
@rateauth       as varchar(1),
@f2day as int,
@rateauditmodify as varchar(1),
@bindrevenuecenter as varchar(1),
@p_led_allow as varchar(2),
@p_clear_allow as varchar(2),
@repeatday as varchar(2),
@premiumedit as varchar(2),
@P_BILL_GENERATION as varchar(20),
@P_PUBLICATION_CENTER as varchar(50),
@P_allow_discount_prem as varchar(1),
@P_SCHEME_BILLING as varchar(50),
@P_ALLOW_PDC as varchar(50),
@PAD_TYPE_FOR_MANUL_BILL AS VARCHAR(20),
@RO_OUTSTAND_P AS VARCHAR(5),
@genrate_agency_code AS VARCHAR(5),
@p_dispauditbk AS VARCHAR(5),
@p_aotosupply  AS VARCHAR(5),
@p_Authorization as VARCHAR(1),
@p_CIR_AUTO_APPROVAL_UNSOLD AS VARCHAR(5),
@p_CIR_AUTO_PHYSICAL_UNSOLD AS VARCHAR(5),
@p_CIR_UNSOLD_INCLUDE_INCT AS VARCHAR(5),
@p_CIR_UNSOLD_INCLUDE_INSFEE AS VARCHAR(5),
@p_CIR_UNSOLD_ON_RECEIVED_DT AS VARCHAR(5),
@p_AGENCY_UNBLOCK_APPROVAL AS VARCHAR(5),
@p_UNBLOCK_APPROVAL_OUTSIDE_LIMIT AS VARCHAR(5),
@p_CIR_BILL_PUBLWISE AS VARCHAR(5),
@paging         AS VARCHAR(4000) ,
@print          AS VARCHAR(4000) ,
@allowpage      AS VARCHAR(4000) ,
@agency_req     AS VARCHAR(4000) ,
@region_req     AS VARCHAR(4000) ,
@p_ALLOW_FOLLOW_DT_BOOOK as varchar(1),
@p_CRM_SUPPLY_TYPE_PAID   as varchar(10),
@p_CRM_SUPPLY_TYPE_FREE   as varchar(10),
@p_CURRENCY_MEASUREMENT   as varchar(5)


AS
declare @query as varchar(8000)
declare @query1 as varchar(8000)
/*
set @query='update login set date_format='''+@dateformat+''' , Autogenerate='''+@code+''',curr_code='''+@curr+''' where com_code='''+@compcode+'''   '
exec(@query)

set @query1='update preferrences set RATE_COMPANY_AGENCY='''+@ratecompany+''',ADDITIONAL_AGENCY_COMM='''+@addagenycomm+''',
AGENCY_RETAINER_COMM='''+@agencycommlinkretainer+''',SUBEDITIONRATE='''+@subeditionr+''',DIS_BILLTYPE='''+@displaybilltype+''',
CLS_BILLTYPE='''+@classifiedbilltype+''',autogenerated='''+@code+''',currency_code='''+@curr+''' ,rate_gr_code='''+@ratecode+''' , 
date_format='''+@dateformat+''',solo='''+@solo+''',breakup='''+@breakup+''' ,blackwhitecode='''+@bwcode+''',  rostatus='''+@rostatus+''',
File_name='''+@filename+''',Tfn='''+@tfn+''',Insert_breakup='''+@insertbreak+''',Premium_type='''+@prem+''',Deal_type='''+@dealtype+'''  ,    
prefix='''+@pre+''', suffix='''+@suff+'''  ,     financestatus='''+ @financestatus+''' , voucherst='''+@voucherst+''',Ad_category='''+@adcode+''' ,
Ro_datetime='''+@rodatetime+''' ,Space_area='''+@spacearea+''',Vat='''+@vat+''' ,Booking_status='''+@bookstat+''' ,Cio_id='''+@cio_id+''',
Receipt_no='''+@receipt_no+''' ,uom_code='''+@uom+''',Bgcolor_publication='''+@bgcolor+''' ,chkfor_valid_pubdates='''+@validdate+''', 
Agency_ratecode='''+@agencyratecode+''',   audit='''+@audit+''', book_insert_date='''+@book_insert_date+''',agencycomm='''+@agencycomm+''',
rate_audit='''+@rateaudit+''',bill_audit='''+@billaudit+''', billtype='''+@billtype+''', invoice_no='''+@invoice_no+''' , 
copy_booking='''+@copybooking+''', BILLING_FORMAT='''+@billformat+''' , RATE_CHECK='''+@ratechk+''', ALL_PACKAGE='''+@allpkg+''',
DAYRATE='''+@dayrate1+''' ,SCHEME_TYPE='''+@schemetype+'''    ,DISP_CLSBILL='''+@PIncludeclassi+ '''  , RECEIPT_FORMAT ='''+@receiptformat+''',
CASH_RECEIPT_BILL='''+@cash_receipt+''', BILL_ORDERWSLAST='''+@bill_orderwiselast+''',FLOOR_CHK='''+@floor_chk+''' ,
Unsold_Entry_Flag='''+@Unsoldflag+''' ,Supply_Stop_Percentage='''+@Supplystopper+''',ROKEYCHECK='''+@drpRokeychk+''',
AGENCYCOMM_SEQ_COM='''+@Agencycomm_seq+''' ,CREDIT_RECIPT='''+@creditreciept+''',DISP_CASHBILL='''+@cashindisplay+''',
CLA_CASHBILL='''+@cashinclassified+''',RATE_AUDIT_PREF='''+@rate_audit_pref+''',BARCODING_ALLOWED='''+@v_barcoding_allow+''', 
FMG_BILL_DIS='''+@v_fmgbills+''',BILL_DISP_CASHBILL='''+@v_billed_cashdis +''',BILL_CLA_CASHBILL ='''+@v_billed_cashcls+''',
BACKDATERECEIPT='''+@v_drpbackdate+''',DOCKIT_BOOKING='''+@dockitbooking+''',Allowed_old_date='''+@allowprevbooking+''',
ROWISE_CASHBOOKING='''+@ro_wisecashbill+''' where    comp_code='''+@compcode+'''   ' 
*/
/*********************************************************************************************************/
UPDATE LOGIN SET date_format=@dateformat, Autogenerate=@code,curr_code=@curr WHERE COM_CODE=@compcode

UPDATE PREFERRENCES SET  autogenerated=@code,
currency_code=@curr ,
rate_gr_code=@ratecode,
date_format=@dateformat,solo=@solo,breakup=@breakup,
blackwhitecode=@bwcode,rostatus=@rostatus,File_name=@filename,Tfn=@tfn,
Insert_breakup=@insertbreak,Premium_type=@prem,Deal_type=@dealtype  ,
 prefix=@pre, suffix=@suff, financestatus=@financestatus , voucherst=@voucherst,
 Ad_category=@adcode ,Ro_datetime=@rodatetime ,Space_area=@spacearea,Vat=@vat,
 Booking_status=@bookstat,Cio_id=@cio_id,Receipt_no=@receipt_no,uom_code=@uom,
 Bgcolor_publication=@bgcolor ,chkfor_valid_pubdates=@validdate, Agency_ratecode=@agencyratecode,
  audit=@AUDIT,book_insert_date=@book_insert_date,agencycomm=@agencycomm,
  rate_audit=@rateaudit,bill_audit=@billaudit,billtype=@billtype,invoice_no=@invoice_no,
  copy_booking=@copybooking,RATE_COMPANY_AGENCY=@ratecompany, ADDITIONAL_AGENCY_COMM=@addagenycomm ,
  AGENCY_RETAINER_COMM=@agencycommlinkretainer,SUBEDITIONRATE=@subeditionr,
  CLS_BILLTYPE=@classifiedbilltype,DIS_BILLTYPE=@displaybilltype,BILLING_FORMAT=@billformat,
  RATE_CHECK=@ratechk,ALL_PACKAGE=@allpkg,dayrate=@dayrate1,SCHEME_TYPE=@schemetype,DISP_CLSBILL=@PIncludeclassi   ,
  CASH_RECEIPT_BILL=@cash_receipt, BILL_ORDERWSLAST=@bill_orderwiselast, FLOOR_CHK=@floor_chk ,
  Unsold_Entry_Flag=@Unsoldflag ,Supply_Stop_Percentage=@Supplystopper,ROKEYCHECK=@drpRokeychk ,
  AGENCYCOMM_SEQ_COM=@Agencycomm_seq ,CREDIT_RECIPT=@creditreciept,DISP_CASHBILL=@cashindisplay,
  CLA_CASHBILL=@cashinclassified,RATE_AUDIT_PREF=@rate_audit_pref,BARCODING_ALLOWED=@v_barcoding_allow,
  FMG_BILL_DIS =@v_fmgbills, BILL_DISP_CASHBILL=@v_billed_cashdis , BILL_CLA_CASHBILL=@v_billed_cashcls,BACKDATERECEIPT=@v_drpbackdate,DOCKIT_BOOKING=@dockitbooking,Allowed_old_date=@allowprevbooking,ROWISE_CASHBOOKING=@ro_wisecashbill,CUTOFFTIME=@chkval,APPROVAL=@approval1,back_days=@pckstatus,CASH_DISCOUNT=@cash_amt,CASH_DISCOUNTTYPE=@cash_disc,SEPRATE_CASHIER=@seperate_cashier1,
 CIR_MANY_TIME_POSTING=@mantimepost, CIR_BACKDAYS_POSTING=@bkdaypost, CIR_MAX_RETURN_ALLOW=@maxterutn, CIR_RETURN_LIMIT_ALLOW=@cir_return, CIR_NO_OF_CHQBOUNCE=@noofchkbounc, CIR_DAYS_CHQBOUNCE=@noofdaychkrec, CIR_RETURN_DAYS=@retday, CIR_SUP_ORDER_LIMIT=@chngsuppord, DISP_BILLING_CRITERIA=@disp_bill, CLSD_BILLING_CRITERIA=@clas_bill,MAX_PUBLISHDAYS=@max_publishday,
 BILLNO_PERIODICITY=@p_billno_period,SPECIALDISC_TRANS_EDIT=@spl_trans_edit, SHARING_TRANS=@spl_dis_trans_editable, MULTIPACKAGE_SEL_TRANS=@mul_pac_sel_trans,SCHEME_MINWORD=@shmon_minword, TRADE_SPLCHARGE=@tradon_spcrg,RATE_AUTHORIZATION=@rateauth
  ,F2_RECORD=@f2day,PUBLISHAD_EDIT_RATEAUDIT=@rateauditmodify,BINDREVENUE_CENTER=@bindrevenuecenter,
FA_LEDGER_ALLOW=@p_led_allow,CLEARANCE_TYPE_ALLOW=@p_clear_allow,REPEAT_DAY_TYPE=@repeatday,PREMIUM_EDIT=@premiumedit,

BILL_GENERATION_PRIOR=@P_BILL_GENERATION,PUBLICATION_HO=@P_PUBLICATION_CENTER,

SPLDISC_ALLOWPREM=@P_allow_discount_prem,BILL_SCHEME=@P_SCHEME_BILLING,

ALLOWED_PDC_DAYS_RECEIPT=@P_ALLOW_PDC,AD_TYPE_MANUL_BILL=@PAD_TYPE_FOR_MANUL_BILL,OUTSTANDING_AMT_CRITERIA=@RO_OUTSTAND_P,GENRATE_CIR_AGCD=@genrate_agency_code,DISP_AUDITBKG=@p_dispauditbk,CIR_DIS_AUTO_POSTING=@p_aotosupply,RELAUTHREQON=@p_Authorization,
CIR_AUTO_APPROVAL_UNSOLD=@p_CIR_AUTO_APPROVAL_UNSOLD,CIR_AUTO_PHYSICAL_UNSOLD=@p_CIR_AUTO_PHYSICAL_UNSOLD,CIR_UNSOLD_INCLUDE_INCT=@p_CIR_UNSOLD_INCLUDE_INCT,
CIR_UNSOLD_INCLUDE_INSFEE=@p_CIR_UNSOLD_INCLUDE_INSFEE,CIR_UNSOLD_ON_RECEIVED_DT=@p_CIR_UNSOLD_ON_RECEIVED_DT,AGENCY_UNBLOCK_APPROVAL=@p_AGENCY_UNBLOCK_APPROVAL,UNBLOCK_APPROVAL_OUTSIDE_LIMIT=@p_UNBLOCK_APPROVAL_OUTSIDE_LIMIT,CIR_BILL_PUBLWISE=@p_CIR_BILL_PUBLWISE,
RECORDS_ON_PAGE = @paging,RECORDS_ON_PRINT = @print,HEADER_ON_PAGE = @allowpage,AGENCY_REQUIRED = @agency_req,REGION_REQUIRED = @region_req,ALLOW_FOLLOW_DT_BOOOK=@p_ALLOW_FOLLOW_DT_BOOOK,CRM_SUPPLY_TYPE_PAID=@p_CRM_SUPPLY_TYPE_PAID,CRM_SUPPLY_TYPE_FREE=@p_CRM_SUPPLY_TYPE_FREE,CURRENCY_MEASUREMENT=@p_CURRENCY_MEASUREMENT
 WHERE comp_code=@compcode




/* ,
',Unsold_Entry_Flag='''+@Unsoldflag+''',Supply_Stop_Percentage='''+@Supplystopper+'''

,ROKEYCHECK='''+@drpRokeychk+''',AGENCYCOMM_SEQ_COM='''+@Agencycomm_seq+''' ,CREDIT_RECIPT='''+@creditreciept+''' where    comp_code='''+@compcode+'''   ' 



--,DISP_CASHBILL='''+@cashindisplay+''',CLA_CASHBILL='''+@cashinclassified+'''
*/

print(@query1)
exec(@query1)







































/**************/


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go





















ALTER PROCEDURE [dbo].[currbindpreferpgld]
@compcode as varchar(8)

AS

/*select date_format,autogenerated,currency_code,rate_gr_code,solo,breakup,blackwhitecode,rostatus,File_name,Tfn,Insert_breakup  , prefix,suffix,financestatus,voucherst,Ad_category,Ro_datetime,Vat,Booking_status,Cio_id,Receipt_no,uom_code,Bgcolor_publication,chkfor_valid_pubdates,
Agency_ratecode,audit,book_insert_date,agencycomm,rate_audit,bill_audit,billtype,Premium_type,copy_booking,RATE_COMPANY_AGENCY,ADDITIONAL_AGENCY_COMM,AGENCY_RETAINER_COMM,SUBEDITIONRATE,CLS_BILLTYPE,DIS_BILLTYPE,BILLING_FORMAT,RATE_CHECK,ALL_PACKAGE,DAYRATE,SCHEME_TYPE,DISP_CLSBILL, RECEIPT_FORMAT ,CASH_RECEIPT_BILL, BILL_ORDERWSLAST, FLOOR_CHK,DISP_CASHBILL, CLA_CASHBILL,RATE_AUDIT_PREF ,  FMG_BILL_DIS,BARCODING_ALLOWED,BILL_DISP_CASHBILL,BILL_CLA_CASHBILL ,BACKDATERECEIPT,ROWISE_CASHBOOKING from preferrences where comp_code=@compcode
*/

  SELECT date_format, autogenerated, currency_code,
                rate_gr_code, solo, breakup, blackwhitecode,
                rostatus, File_name, Tfn, Insert_breakup, prefix,
                suffix, financestatus, voucherst, Ad_category,
                Ro_datetime, Vat, Booking_status, Cio_id,
                Receipt_no,uom_code,Bgcolor_publication,chkfor_valid_pubdates,Agency_ratecode,audit,book_insert_date,agencycomm,
                rate_audit,bill_audit,billtype,Premium_type,copy_booking,RATE_COMPANY_AGENCY,ADDITIONAL_AGENCY_COMM,AGENCY_RETAINER_COMM,SUBEDITIONRATE,CLS_BILLTYPE,DIS_BILLTYPE,
				BILLING_FORMAT,RATE_CHECK,ALL_PACKAGE,dayrate,SCHEME_TYPE,DISP_CLSBILL,RECEIPT_FORMAT,CASH_RECEIPT_BILL, BILL_ORDERWSLAST, FLOOR_CHK,
                ROKEYCHECK, AGENCYCOMM_SEQ_COM, CREDIT_RECIPT,  DISP_CASHBILL, CLA_CASHBILL,
				RATE_AUDIT_PREF,BARCODING_ALLOWED, FMG_BILL_DIS,BILL_DISP_CASHBILL, BILL_CLA_CASHBILL,BACKDATERECEIPT,ROWISE_CASHBOOKING,CUTOFFTIME,DOCKIT_BOOKING,APPROVAL,back_days as BACK_DAYS,CASH_DISCOUNT,CASH_DISCOUNTTYPE,Allowed_old_date,SEPRATE_CASHIER,
                CIR_MANY_TIME_POSTING, CIR_BACKDAYS_POSTING, CIR_MAX_RETURN_ALLOW, CIR_RETURN_LIMIT_ALLOW, CIR_NO_OF_CHQBOUNCE, CIR_DAYS_CHQBOUNCE, CIR_RETURN_DAYS, CIR_SUP_ORDER_LIMIT, DISP_BILLING_CRITERIA, CLSD_BILLING_CRITERIA,MAX_PUBLISHDAYS,BILLNO_PERIODICITY, SPECIALDISC_TRANS_EDIT, SHARING_TRANS, MULTIPACKAGE_SEL_TRANS,SCHEME_MINWORD, TRADE_SPLCHARGE,RATE_AUTHORIZATION,F2_RECORD,PUBLISHAD_EDIT_RATEAUDIT,BINDREVENUE_CENTER, FA_LEDGER_ALLOW,CLEARANCE_TYPE_ALLOW,REPEAT_DAY_TYPE,PREMIUM_EDIT,
BILL_GENERATION_PRIOR,PUBLICATION_HO,SPLDISC_ALLOWPREM,BILL_SCHEME,
ALLOWED_PDC_DAYS_RECEIPT,AD_TYPE_MANUL_BILL, OUTSTANDING_AMT_CRITERIA as RO_OUTSTAND,GENRATE_CIR_AGCD,DISP_AUDITBKG,CIR_DIS_AUTO_POSTING,RELAUTHREQON,
CIR_AUTO_APPROVAL_UNSOLD, CIR_AUTO_PHYSICAL_UNSOLD, CIR_UNSOLD_INCLUDE_INCT, CIR_UNSOLD_INCLUDE_INSFEE, CIR_UNSOLD_ON_RECEIVED_DT,AGENCY_UNBLOCK_APPROVAL,UNBLOCK_APPROVAL_OUTSIDE_LIMIT,CIR_BILL_PUBLWISE,RECORDS_ON_PAGE,RECORDS_ON_PRINT,HEADER_ON_PAGE,AGENCY_REQUIRED,REGION_REQUIRED,ALLOW_FOLLOW_DT_BOOOK,CRM_SUPPLY_TYPE_PAID,CRM_SUPPLY_TYPE_FREE,CURRENCY_MEASUREMENT
           FROM PREFERRENCES
          WHERE comp_code = @compcode































/***********************mimoh 28dec 2011*********6162****************************************/
//////////////////////////garima/////////////////////////////

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[cir_rep_inct_slab]
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @ppublcode       as varchar(20),
    @pagency_type    as varchar(20),
    @psupply_type    as varchar(20),    
    @pchkdate        as datetime, 
    @puserid         as varchar(20), 
    @pdateformate    as varchar(20),
    @pextra1         as varchar(20),
    @pextra2         as varchar(20),
    @pextra3         as varchar(20),
    @pextra4         as varchar(20),
    @pextra5         as varchar(20),
    @pextra6         as varchar(20),
    @pextra7         as varchar(20),
    @pextra8         as varchar(20),
    @pextra9         as varchar(20),
    @pextra10        as varchar(200)
as

begin
	If @punitcode='' Begin
		set @punitcode=null
	End
	If @ppublcode='' Begin
		set @ppublcode=null
	End
	If @pagency_type='' Begin
		set @pagency_type=null
	End
	If @psupply_type='' Begin
		set @psupply_type=null
	End			
   
    select d.comp_code as "COMP_CODE",d.inct_slab_id as "INCT_SLAB_ID", case when d.inct_base='S' then 'SUPPLY' else 'GROWTH' end as "INCT_BASE",



case 
  when  d.inct_type ='SW' THEN 'Weekly' 
    when d.inct_type ='SM' THEN 'Monthly' 
    when d.inct_type ='SQ' THEN 'Querterly' 
     when  d.inct_type ='SY' THEN 'Yearly'  end as "INCT_TYPE",


  
d.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=d.unit_code) as "UNIT_NAME",
    d.publ_code as "PUBL_CODE",p.publ_name as "PUBL_NAME",
    e.main_edtn as "MAIN_EDTN",dbo.cir_get_edtn_name(d.comp_code,e.main_edtn) as "MAIN_EDTN_NAME",d.edtn_code as "EDTN",e.edtn_name as "EDTN_NAME",
    d.supply_type as "SUPPLY_TYPE",s.sup_ty_name as "SUP_TY_NAME",d.calc_type as "CALC_TYPE",
    d.supply_from as "SUPPLY_FROM",d.supply_till as "SUPPLY_TILL",
    d.inct_amt as "INCT_AMT",d.branch_code as "BRANCH_CODE", (select "Branch_Name" from branch_mst where "Branch_Code"=d.branch_code) as "BRANCH_NAME",
    d.agency_type as "AGENCY_TYPE",(select agency_type_desc from cir_agency_typ_mast where comp_code=d.comp_code and agency_type_code=d.agency_type) as "AGENCY_TYPE_NAME",


case @pdateformate 
when 'mm/dd/yyyy' then convert(varchar(10),d.eff_date,101) 
when 'dd/mm/yyyy' then convert(varchar(10),d.eff_date,103) 
when 'yyyy/mm/dd' then convert(varchar(10),d.eff_date,111)  end as "EFFECTIVE_FROM",

 (select rmrk from cir_inct_slab_hdr where comp_code=d.comp_code and unit_code=d.unit_code and inct_slab_id=d.inct_slab_id) as "REMARKS"



  




    from cir_publ_mast p,cir_edtn_mast e,cir_inct_slab_det d,cir_supply_type_mast s 
    where p.comp_code=e.comp_code and p.comp_code=d.comp_code and p.comp_code=s.comp_code and p.comp_code=@pcompcode and
    p.publ=e.publ and p.publ=d.publ_code and p.publ=isnull(@ppublcode,p.publ)
    and d.unit_code=isnull(@punitcode,d.unit_code) and e.edtn=d.edtn_code 
    and d.supply_type=s.sup_ty_code and d.supply_type=s.sup_ty_code 
    and d.supply_type=isnull(@psupply_type,d.supply_type) 
    and (d.agency_type=@pagency_type or @pagency_type is null)
    order by unit_name,branch_name,inct_slab_id,inct_slabid_det
    
    select d.comp_code as "COMP_CODE",d.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=d.unit_code) as "UNIT_NAME",
    d.branch_code as "BRANCH_CODE", (select "Branch_Name" from branch_mst where "Branch_Code"=d.branch_code) as "BRANCH_NAME"
    from cir_publ_mast p,cir_edtn_mast e,cir_inct_slab_det d,cir_supply_type_mast s 
    where p.comp_code=e.comp_code and p.comp_code=d.comp_code and p.comp_code=s.comp_code and p.comp_code=@pcompcode and
    p.publ=e.publ and p.publ=d.publ_code and p.publ=isnull(@ppublcode,p.publ)
    and d.unit_code=isnull(@punitcode,d.unit_code) and e.edtn=d.edtn_code 
    and d.supply_type=s.sup_ty_code and d.supply_type=s.sup_ty_code 
    and d.supply_type=isnull(@psupply_type,d.supply_type) 
    and (d.agency_type=@pagency_type or @pagency_type is null)
    order by unit_name,branch_name
    
    select d.comp_code as "COMP_CODE",d.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=d.unit_code) as "UNIT_NAME"
    from cir_publ_mast p,cir_edtn_mast e,cir_inct_slab_det d,cir_supply_type_mast s 
    where p.comp_code=e.comp_code and p.comp_code=d.comp_code and p.comp_code=s.comp_code and p.comp_code=@pcompcode and
    p.publ=e.publ and p.publ=d.publ_code and p.publ=isnull(@ppublcode,p.publ)
    and d.unit_code=isnull(@punitcode,d.unit_code) and e.edtn=d.edtn_code 
    and d.supply_type=s.sup_ty_code and d.supply_type=s.sup_ty_code 
    and d.supply_type=isnull(@psupply_type,d.supply_type) 
    and (d.agency_type=@pagency_type or @pagency_type is null)
    order by unit_name
    
End    
////////////////////////////////////garima

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[cir_region_bind_p]
	@pcomp_code                               VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
	
		SELECT cir_region_mast.*,
				 dbo.cir_get_zone_name(cir_region_mast.comp_code, cir_region_mast.zone_code) as ZONE_NAME 
		FROM  cir_region_mast 
		WHERE	 comp_code  = @pcomp_code 
and ((upper(REG_DESC) like upper('%'+@pextra1+'%')) or (@pextra1 is null))


		ORDER BY cir_region_mast.reg_desc 
		

////////////////////////
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[cir_dist_bind_cir_dist_bind_p]
	@pcomp_code                               VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
	
	SELECT
                 cir_dist_mast.comp_code COMP_CODE,
                 cir_dist_mast.dist_code DIST_CODE,
                 cir_dist_mast.dist_name DIST_NAME,
                 cir_dist_mast.dist_alias DIST_ALIAS,
                 cir_dist_mast.userid USERID,
                 cir_dist_mast.creation_date CREATION_DATE,
                 cir_dist_mast.freeze_flag FREEZE_FLAG,
                 cir_dist_mast.state_code STATE_CODE,
                 cir_dist_mast.country_code COUNTRY_CODE,
                 cir_dist_mast.dist_oname DIST_ONAME,
                 count_mst.Country_Name COUNTRY_NAME,
                 state_mst.State_Name STATE_NAME
		FROM  cir_dist_mast,count_mst,state_mst where  cir_dist_mast.comp_code  = count_mst.Comp_Code
			 AND	cir_dist_mast.country_code  = count_mst.Country_Code  AND cir_dist_mast.comp_code  = state_mst.Comp_Code
			 and cir_dist_mast.comp_code=@pcomp_code
             AND	cir_dist_mast.country_code  = state_mst.Country_Code
			 AND	cir_dist_mast.state_code  = state_mst.State_Code 
	





and ((upper(DIST_NAME) like upper('%'+@pextra1+'%')) or (@pextra1 is null))
		ORDER BY dist_name 
		



///////////////////////////////////////////garima

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[cir_branch_bind_p1]
	@pcompcode                                VARCHAR(20) ,
	@pbranchcode                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(400)
AS 

		select "Branch_Code" , "Branch_Name" from branch_mst 
		where --("Comp_Code"=pcompcode or pcompcode is null) and  
       ( Branch_Code = @pbranchcode or @pbranchcode is null or @pbranchcode='')



and ((upper(Branch_Name) like upper('%'+@pextra1+'%')) or (@pextra1 is null))
	


//////////////////////
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE  [dbo].[Cir_Route_Bind]
  	@pcompcode as varchar(200),
   	@punitcode as varchar(200),
    @pdateformat as	varchar(200),
    @pextra1 as	varchar(200),
    @pextra2 as varchar(200)
 AS
   select * from cir_route_mast
   	         where comp_code=@pcompcode and 
                   unit=@punitcode and
                    ISNULL(freeze_flag,'N')='N'


and ((upper(ROUTE_NAME) like upper('%'+@pextra1+'%')) or (@pextra1 = ''))
   	         order by route_code




/**************************************6176***mimoh 29-dec-2011*******************/
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER procedure [dbo].[cir_agency_unblock_approval]
   @pcomp_code         as varchar(200),
   @punit_code         as varchar(200),
   @pbran_code         as varchar(200),
   @pstatus            as varchar(200),
   @pfrdt              as datetime,
   @ptodt              as datetime,
   @pagcd              as varchar(200),
   @pdpcd              as varchar(200),
   @psuspty            as varchar(200),
   @puserid            as varchar(200)
   as
Begin
       If @punit_code='' Begin
               set @punit_code=null
       End
       If @pbran_code='' Begin
               set @pbran_code=null
       End
       If @pstatus='' Begin
               set @pstatus=null
       End
       If @pagcd='' Begin
               set @pagcd=null
       End
       If @pdpcd='' Begin
               set @pdpcd=null
       End
       If @psuspty='' Begin
               set @psuspty=null
       End
       If @puserid='' Begin
               set @puserid=null
       End

select s.comp_code as "COMP_CODE",s.unit as "UNIT",s.agcd as
"AGCD",s.dpcd as "DPCD",m.ag_name as "AGENCY_NAME",
dbo.cir_get_drop_point_name(s.comp_code,s.unit,m.station_code,1) as
"DROP_POINT_NAME",dbo.cir_get_city(s.comp_code,m.city_code) as
"CITY_NAME",
s.start_date as "BLOCK_UNBLOCK_DATE",'' as "BLOCK_UNBLOCK_TIME",
        (SELECT SUSPEND_DESC FROM CIR_SUSPEND_TYPE_MAST WHERE
COMP_CODE=s.COMP_CODE AND SUSPEND_TYPE_CODE=s.suspty) as
"BLOCK_REASON",s.suspty as "SUSPTY",
        (SELECT max("username") from login where com_code =
s.comp_code  and "userid"=s.userid) as "UNBLOCK_BY",s.suspty as
"SUSPEND_TYPE",
        s.agency_unblock_approval as
"AGENCY_UNBLOCK_APPROVAL",s.userid as
"USERID",isnull(s.trn_date,convert(varchar(20),creation_date,103)) as
"TRN_DATE"
        from cir_suspend_tran s,cir_agmast m
     where s.comp_code = m.comp_code and s.comp_code = @pcomp_code
       and s.unit=m.unit and s.unit      = isnull(@punit_code,s.unit)
       and s.susp      = @pstatus
       and s.trn_date between @pfrdt and @ptodt
       and s.agcd=m.agcd and s.agcd    = isnull(@pagcd,s.agcd)
       and s.dpcd=m.dpcd and s.dpcd    = isnull(@pdpcd,s.dpcd)
       and s.userid  = isnull(@puserid,s.userid)
       and isnull(s.agency_unblock_approval,'N')='N'

End
/**************************************6176***mimoh 29-dec-2011*******************/




/////////////////////////////////////////////////Issue No. 6175 02/01/2012///////////////////////////////////////////////////
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[cir_bank_guarantee_bind]
   @pcomp_code     as       VARCHAR(200),
   @pagcd          as       VARCHAR(200),
   @pdpcd          as       VARCHAR(200),
   @pexpiry_date   as       datetime,
   @pexpiry_days   as       int,
   @pinstrument_ty as       VARCHAR(200),
   @pdateformat    as       VARCHAR(200),
   @pextra         as       VARCHAR(200),
   @pextra1        as       VARCHAR(200),
   @pextra2        as       VARCHAR(200)

aS
	declare @v_dt datetime
BEGIN

	If @pagcd='' Begin
		set @pagcd=null
	End

	If @pdpcd='' Begin
		set @pdpcd=null
	End

	If @pinstrument_ty='' Begin
		set @pinstrument_ty=null
	End

   set @v_dt    = @pexpiry_date + isnull(@pexpiry_days,0)
	print(@v_dt)
      SELECT b.COMP_CODE, b.UNIT_CODE, b.AGCD, b.DPCD,m.ag_name AG_NAME,DBO.CIR_GET_DROP_POINT_NAME(B.COMP_CODE,B.UNIT_CODE,M.STATION_CODE,1) DROP_POINT_NAME,
    DBO.CIR_GET_CITY(B.COMP_CODE,M.CITY_CODE) CITY_NAME, 
    b.BG_NO, b.BG_AMT, b.BG_DATE, b.BG_VALID, b.BANK_DESC, 
    b.CREATED_BY, b.CREATED_DT, b.UPDATED_BY, b.UPDATED_DT, b.BG_TYPE
    FROM cir_bank_guarantee b,cir_agmast m
    where m.comp_code =b.comp_code and m.comp_code = @pcomp_code and b.unit_code=m.unit  
    and b.agcd=m.agcd and b.agcd    = ISNULL(@pagcd,b.agcd) 
    and b.dpcd=m.dpcd and b.dpcd    = ISNULL(@pdpcd,b.dpcd)
    and ((b.bg_type = @pinstrument_ty) or (@pinstrument_ty is null))
    and b.bg_valid<=@v_dt ORDER BY AG_NAME
END
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////Issue No. 6161 02/01/2012////////////////////////////////////////////////////


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
 ALTER Procedure [dbo].[cir_pcenter_detail_p]
     @pcompcode           VARCHAR(20),
     @ppcenter           VARCHAR(20),
     @plangtype           VARCHAR(20),  ---1 for enlish and 2 for other language
     @pdateformat         VARCHAR(20),
     @pextra1             VARCHAR(200),
     @pextra2            VARCHAR(200)


  As
  
       
        select TOP 1 * from pub_cent_mast where /*"Comp_Code"=pcompcode  and*/
        (Pub_cent_Code=@ppcenter or @ppcenter is null or @ppcenter = '') 
        order by "Comp_Code";

 //*********by nand on 3rd jan 2012 *************************************************************
 set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[cir_unsold_supply_for_transfer]
    @pcomp_code         as varchar(20),
    @punit_code         as varchar(20),
    @pbran_code         as varchar(20),
    @pfromdate          as varchar(20),
    @ptilldate          as varchar(20),
    @puserid            as varchar(20),   
    @pdateformat        as varchar(20),
    @pextra1            as varchar(200),
    @pextra2            as varchar(200),
    @pextra3            as varchar(200),
    @pextra4            as varchar(200),
    @pextra5            as varchar(200),
    @pextra6            as varchar(200),
    @pextra7            as varchar(200),
    @pextra8            as varchar(200),               
    @pextra9            as varchar(200),
    @pextra10           as varchar(200)
As
Begin
	
    declare @v_process_id    numeric(30)
	DECLARE @v_frdt  DATETIME
	DECLARE @v_todt  DATETIME

	SET @v_frdt  =  DBO.convert_user_date('/', @pfromdate,@pdateformat)
	SET @v_todt   =  DBO.convert_user_date('/', @ptilldate,@pdateformat)

    exec cir_generate_processid @pcomp_code,@puserid,@pdateformat,null,null,null,null,null,@v_process_id OUTPUT
    
    select distinct d.comp_code as "COMP_CODE",d.unit_code as "UNIT_CODE",d.branch_code as "BRANCH_CODE",d.doctype as "DOCTYPE",
    d.recptno as "RECPTNO",d.recptdt as "RECPTDT",d.sup_agcd as "SUP_AGCD" ,d.sup_dpcd as "SUP_DPCD",m.ag_name as "SUPPLY_AGENCY",
    dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) drop_point_name, dbo.cir_get_city(d.comp_code,m.city_code) city_name,
    dbo.cir_get_agency(d.comp_code,d.unit_code,d.agcd,d.dpcd) as "BILLING_AGENCY",
    sum(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)+isnull(apr_damage,0)) as "TOTAL_UNSOLD",
    @v_process_id as "PROCESS_IDNO" 
    from cir_unsold_hdr h,cir_unsold_dtl d,cir_agmast m
    where h.comp_code=d.comp_code and h.comp_code=m.comp_code and h.comp_code=@pcomp_code and h.unit_code=d.unit_code and h.unit_code=m.unit and h.unit_code=@punit_code and 
    h.doctype=d.doctype and h.doctype='UCN' and h.recptno=d.recptno and h.recptdt=d.recptdt and h.recptdt between @v_frdt and @v_todt and --@pfromdate and @ptilldate and 
    h.agcd=isnull(d.sup_agcd,d.agcd) and h.agcd=m.agcd and h.dpcd=isnull(d.sup_dpcd,d.dpcd) and h.dpcd=m.dpcd and 
    d.branch_code=isnull(@pbran_code,d.branch_code) and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)+isnull(apr_damage,0))>0 and
    (h.branch_trfno is null or h.branch_trfno='')
    group by d.comp_code,d.unit_code,d.branch_code,d.doctype,d.recptno,d.recptdt,d.sup_agcd,d.sup_dpcd,m.ag_name,m.station_code, m.city_code,d.agcd,d.dpcd
    order by comp_code,unit_code,recptdt,recptno;
	
        
End


//***************************************************
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[cir_unsold_transfer_selected]
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @pbrancode       as varchar(20),
    @precptno        as varchar(20),
    @precptdt        as varchar(20),
    @pprocess_idno   as numeric(20),
    @puserid         as varchar(20), 
    @pdateformat     as varchar(20),
    @pextra1         as varchar(20),
    @pextra2         as varchar(20),
    @pextra3         as varchar(20),
    @pextra4         as varchar(20),
    @pextra5         as varchar(20),
    @pextra6         as varchar(20),
    @pextra7         as varchar(20),
    @pextra8         as varchar(20),
    @pextra9         as varchar(20),
    @pextra10        as varchar(20)
as
	DECLARE @v_dt  DATETIME
	SET @v_dt  =  DBO.convert_user_date('/', @precptdt,@pdateformat)
begin
   
    insert into cir_bill_return_print(comp_code,unit_code,branch_code,billno,billdt,return_copy)
    values(@pcompcode,@punitcode,@pbrancode,@precptno,@v_dt,@pprocess_idno)
    
    select getdate() as "CUR_DATE"
    
End


//*********************************************
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER procedure [dbo].[cir_fetch_for_unsold_transfer]
    @pcomp_code      as varchar(20),
    @punit_code      as varchar(20),
    @pbran_code      as varchar(20),
    @pprocess_idno   as numeric(20),
    @ppacket_szie    as int,
    @puserid         as varchar(20), 
    @pdateformat     as varchar(20),
    @pextra1         as varchar(20),
    @pextra2         as varchar(20),
    @pextra3         as varchar(20),
    @pextra4         as varchar(20),
    @pextra5         as varchar(20),
    @pextra6         as varchar(20),
    @pextra7         as varchar(20),
    @pextra8         as varchar(20),
    @pextra9         as varchar(20),
    @pextra10        as varchar(20)
as
begin

    select distinct x.comp_code as "COMP_CODE",x.unit_code as "UNIT_CODE",x.branch_code as "BRANCH_CODE",x.doctype as "DOCTYPE",
    x.publ as "PUBL",x.publ_name as"PUBL_NAME", x.main_edtn as "MAIN_EDTN",x.main_edtn_name as "MAIN_EDTN_NAME",
    x.edtn as "EDTN",x.edtn_name as "EDTN_NAME",x.copy_rate as "COPY_RATE",x.total_unsold as "TOTAL_UNSOLD",
    ceiling(cast(x.total_unsold as numeric)/@ppacket_szie) AS "PKT"
    from(
    select distinct d.comp_code,d.unit_code,d.branch_code,d.doctype,
    d.publ,p.publ_name, e.main_edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) main_edtn_name,
    d.edtn,e.edtn_name,d.copy_rate,sum(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)+isnull(apr_damage,0)) as TOTAL_UNSOLD
    from cir_unsold_hdr h,cir_unsold_dtl d,cir_agmast m,cir_publ_mast p,cir_edtn_mast e,cir_bill_return_print b
    where h.comp_code=d.comp_code and h.comp_code=m.comp_code and h.comp_code=p.comp_code and h.comp_code=e.comp_code and h.comp_code=b.comp_code and h.comp_code=@pcomp_code and 
    h.unit_code=d.unit_code and h.unit_code=m.unit and h.unit_code=b.unit_code and h.unit_code=@punit_code and 
    h.doctype=d.doctype and h.doctype='UCN' and h.recptno=d.recptno and h.recptno=b.billno and h.recptdt=d.recptdt and h.recptdt=b.billdt and
    h.agcd=isnull(d.sup_agcd,d.agcd) and h.agcd=m.agcd and h.dpcd=isnull(d.sup_dpcd,d.dpcd) and h.dpcd=m.dpcd and d.publ=p.publ and d.publ=e.publ and d.edtn=e.edtn and  
    d.branch_code=@pbran_code and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)+isnull(apr_damage,0))>0 and b.return_copy=@pprocess_idno
    group by d.comp_code,d.unit_code,d.branch_code,d.doctype,d.publ,p.publ_name,e.main_edtn,d.edtn,e.edtn_name,d.copy_rate) x
    order by comp_code,unit_code,publ_name,main_edtn_name,edtn_name,copy_rate;
    
    select getdate() as "CUR_DATE"
    
    delete from cir_bill_return_print where return_copy=@pprocess_idno
    
End

//******************************************************************
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[cir_edition_bind_cir_sub_edition_bind_p]
	@pcomp_code                               VARCHAR(20) ,
	@ppubl_code                               VARCHAR(20) ,
	@pedtn_code                               VARCHAR(20) ,
	@psubedtn_code                            VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
BEGIN

select * from cir_edtn_mast where comp_code = @pcomp_code 
--and publ = @ppubl_code and (edtn=@psubedtn_code or @psubedtn_code is null OR @psubedtn_code = '' ) 
--and (main_edtn=@pedtn_code or @pedtn_code is null OR  @pedtn_code = '')
and edtn<>main_edtn and ISNULL(freeze_flag,'N')='N'   
and (unit_code=@pextra2 or @pextra2 is null or  @pextra2 = '')
order by edtn_name;

END

//****************************************************
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[cir_edition_bind_cir_main_edition_bind_p]

	@pcomp_code                               VARCHAR(20) ,
	@ppubl_code                               VARCHAR(20) ,
	@pedtn_code                               VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
	
		SELECT *
		FROM  cir_edtn_mast 
		WHERE	 comp_code  = @pcomp_code
         and (unit_code=@pextra1 or @pextra1 is null or @pextra1 = '')
		 --AND	publ  = @ppubl_code
		 AND	(edtn  = @pedtn_code
		 OR	@pedtn_code  is null  OR	@pedtn_code = '')
		 AND	edtn  = main_edtn
         AND ( edtn_name like @pextra2+'%' or @pextra2 is null)
		 AND	ISNULL(freeze_flag, 'N')  = 'N'
		ORDER BY edtn_name 
//*************************************************************************

/////////////////////////////by nand on 3rd jan 2012//////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////by Garima 3 jan//////////////////
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER procedure [dbo].[cir_websp_permission]
(
@pcomp_code as varchar(50),
@puser_id as varchar(50),
@pform_name as  varchar(50),
@pextra1 as varchar(50),
@pextra2 as varchar(50)

)

as 

select * from userpermission where COMM_CODE=@pcomp_code and USERID=@puser_id
AND PERMISSION_DESC=@pform_name


///////////////////////////////////////////////////Garima


 alter  PROCEDURE [dbo].[cir_voucher](
      @pcompcode         as varchar(50),
      @punitcode         as varchar(50),
      @pbrancode         as varchar(50),
      @ppublcode         as varchar(50),
      @pagcd             as varchar(50),
      @pdpcd             as varchar(50),
      @pagtype           as varchar(50),
      @pstate_code       as varchar(50),
      @pdist_code        as varchar(50),
      @pcity_code        as varchar(50),
      @pfrom_dt          as datetime,
      @ptill_dt          as datetime,
      @pbreakon          as varchar(50),--1 for Agency Type,2 for Agency Name
      @preptype          as varchar(50),--D for Detail ,M Monthly Summary,S for Summary
      @pdateformat       as varchar(50),
      @puserid           as varchar(50),
      @pextra1           as varchar(50),
      @pextra2           as varchar(50),
      @pextra3           as varchar(50),
      @pextra4           as varchar(50),
      @pextra5           as varchar(50)   
      
      
      )
    As

   declare @v_frdt   as       datetime;
   declare @v_todt  as        datetime;

/*
   
  Begin
        v_frdt    :=to_date(pfrom_dt,''''||pdateformat||'''');
        v_todt    :=to_date(ptill_dt,''''||pdateformat||'''');
        
   */     
            

     set    @v_frdt    =@pfrom_dt;
     set    @v_todt    =@ptill_dt;





select d.comp_code as "COMP_CODE", d.unit_code as "UNIT_CODE", 
case @pdateformat
when 'mm/dd/yyyy' then convert(varchar(10),d.recptdt,101) 
when 'dd/mm/yyyy' then convert(varchar(10),d.recptdt,103) 
when 'yyyy/mm/dd' then convert(varchar(10),d.recptdt,111)  end as "RECPTDT",

 d.recptno as "RECPTNO",
                    d.publ_code as "PUBL_CODE",dbo.cir_get_publ_name(d.comp_code,d.publ_code) as "PUBL_NAME", d.bilagcd as "AGCD", d.bildpcd as "DPCD",
                    m.ag_name as "AG_NAME",dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME", 
                    dbo.cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",dbo.cir_get_state(d.comp_code,m.country_code, m.state_code) as "STATE_NAME",
                    dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) as "DIST_NAME",
                    m.ag_type as "AG_TYPE",(select agency_type_desc from cir_agency_typ_mast where comp_code=d.comp_code and agency_type_code=m.ag_type) as "AGENCY_TYPE_NAME",
                    sum(d.tot_supply) as "TOT_SUPPLY", 
                    sum(d.amount) as "AMOUNT",  sum(d.no_of_days) as "NO_OF_DAYS"
                    from cir_inct_process_det d,cir_agmast m
                    where d.comp_code=m.comp_code and d.comp_code=@pcompcode and d.unit_code=m.unit and  d.unit_code=isnull(@punitcode,d.unit_code) and 
                    d.bilagcd=m.agcd and d.bilagcd=isnull(@pagcd,d.bilagcd) and d.bildpcd=m.dpcd and d.bildpcd=isnull(@pdpcd,d.bildpcd) and 
                    d.doctype='CN' 
                    and d.recptdt between @v_frdt and @v_todt 
                    and d.publ_code=isnull(@ppublcode,d.publ_code) and d.tran_type='INC' and 
                    (m.branch_code=@pbrancode or @pbrancode is null) and (m.state_code=@pstate_code or @pstate_code is null) and 
                    (m.dist_code=@pdist_code or @pdist_code is null) and (m.city_code=@pcity_code or @pcity_code is null) and 
                    (m.state_code=@pstate_code or @pstate_code is null)
                    group by d.comp_code , d.unit_code , d.recptdt, d.recptno,d.publ_code, d.bilagcd, d.bildpcd,m.ag_name,m.station_code, 
                    m.city_code,m.country_code, m.state_code,m.dist_code,m.ag_type
                    order by comp_code,unit_code,ag_name,recptdt,recptno

///////////////////////////////////////////////////////////
//////////////////////updateby garima


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER  PROCEDURE [dbo].[cir_rep_inct_detail](
      @pcompcode         as varchar(50),
      @punitcode         as varchar(50),
      @pbrancode         as varchar(50),
      @ppublcode         as varchar(50),
      @pagcd             as varchar(50),
      @pdpcd             as varchar(50),
      @pagtype           as varchar(50),
      @pstate_code       as varchar(50),
      @pdist_code        as varchar(50),
      @pcity_code        as varchar(50),
      @pfrom_dt          as datetime,
      @ptill_dt          as datetime,
      @pbreakon          as varchar(50),--1 for Agency Type,2 for Agency Name
      @preptype          as varchar(50),--D for Detail ,M Monthly Summary,S for Summary
      @pdateformat       as varchar(50),
      @puserid           as varchar(50),
      @pextra1           as varchar(50),
      @pextra2           as varchar(50),
      @pextra3           as varchar(50),
      @pextra4           as varchar(50),
      @pextra5           as varchar(50)   
      
      
      )
    As

   declare @v_frdt   as       datetime;
   declare @v_todt  as        datetime;

/*
   
  Begin
        v_frdt    :=to_date(pfrom_dt,''''||pdateformat||'''');
        v_todt    :=to_date(ptill_dt,''''||pdateformat||'''');
        
   */     
            

     set    @v_frdt    =@pfrom_dt;
     set    @v_todt    =@ptill_dt;



            If (@pbreakon='1') begin--for agency type wise
                if (@preptype='D') begin--details                   
                   
                    select d.comp_code as "COMP_CODE", d.unit_code as "UNIT_CODE", 


case @pdateformat
when 'mm/dd/yyyy' then convert(varchar(10),d.recptdt,101) 
when 'dd/mm/yyyy' then convert(varchar(10),d.recptdt,103) 
when 'yyyy/mm/dd' then convert(varchar(10),d.recptdt,111)  end as "RECPTDT",

 d.recptno as "RECPTNO",
                    d.publ_code as "PUBL_CODE", dbo.cir_get_publ_name(d.comp_code,d.publ_code) as "PUBL_NAME", d.bilagcd as "AGCD", d.bildpcd as "DPCD",
                    m.ag_name as "AG_NAME",dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME", 
                    dbo.cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",dbo.cir_get_state(d.comp_code,m.country_code, m.state_code) as "STATE_NAME",
                    dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) as "DIST_NAME",
                    m.ag_type as "AG_TYPE",(select agency_type_desc from cir_agency_typ_mast where comp_code=d.comp_code and agency_type_code=m.ag_type) as "AGENCY_TYPE_NAME",
                    sum(d.tot_supply) as "TOT_SUPPLY", 
                    sum(d.amount) as "AMOUNT",  sum(d.no_of_days) as "NO_OF_DAYS"
                    from cir_inct_process_det d,cir_agmast m
                    where d.comp_code=m.comp_code and d.comp_code=@pcompcode and d.unit_code=m.unit and  d.unit_code=isnull(@punitcode,d.unit_code) and 
                    d.bilagcd=m.agcd and d.bilagcd=isnull(@pagcd,d.bilagcd) 
                    and d.bildpcd=m.dpcd 
                    and d.bildpcd=isnull(@pdpcd,d.bildpcd) 
                    and                    d.doctype='CN' and d.recptdt between @v_frdt and @v_todt and d.publ_code=isnull(@ppublcode,d.publ_code) and d.tran_type='INC' and 
                    (m.branch_code=@pbrancode or @pbrancode is null) and (m.state_code=@pstate_code or @pstate_code is null) and 
                    (m.dist_code=@pdist_code or @pdist_code is null) and (m.city_code=@pcity_code or @pcity_code is null) and 
                    (m.state_code=@pstate_code or @pstate_code is null)
                    group by d.comp_code , d.unit_code , d.recptdt, d.recptno,d.publ_code, d.bilagcd, d.bildpcd,m.ag_name,m.station_code, 
                    m.city_code,m.country_code, m.state_code,m.dist_code,m.ag_type
                    order by comp_code,unit_code,agency_type_name,recptdt,recptno;
                    
                    
                    select d.comp_code as "COMP_CODE", d.unit_code as "UNIT_CODE", m.ag_type as "AG_TYPE",(select agency_type_desc from cir_agency_typ_mast where comp_code=d.comp_code and agency_type_code=m.ag_type) as "AGENCY_TYPE_NAME",
                    sum(d.tot_supply) as "TOT_SUPPLY", sum(d.amount) as "AMOUNT",  sum(d.no_of_days) as "NO_OF_DAYS"
                    from cir_inct_process_det d,cir_agmast m
                    where d.comp_code=m.comp_code and d.comp_code=@pcompcode and d.unit_code=m.unit and  d.unit_code=isnull(@punitcode,d.unit_code) and 
                    d.bilagcd=m.agcd and d.bilagcd=isnull(@pagcd,d.bilagcd) and d.bildpcd=m.dpcd and d.bildpcd=isnull(@pdpcd,d.bildpcd) and 
                    d.doctype='CN' and d.recptdt between @v_frdt and @v_todt and d.publ_code=isnull(@ppublcode,d.publ_code) and d.tran_type='INC' and 
                    (m.branch_code=@pbrancode or @pbrancode is null) and (m.state_code=@pstate_code or @pstate_code is null) and 
                    (m.dist_code=@pdist_code or @pdist_code is null) and (m.city_code=@pcity_code or @pcity_code is null) and 
                    (m.state_code=@pstate_code or @pstate_code is null)
                    group by d.comp_code , d.unit_code , d.recptdt, d.recptno,d.publ_code, d.bilagcd, d.bildpcd,m.ag_name,m.station_code, 
                    m.city_code,m.country_code, m.state_code,m.dist_code,m.ag_type
                    order by comp_code,unit_code,agency_type_name;
                 
				end   
                 else if(@preptype='S')
                  begin--summary
                    
                   
                    select d.comp_code as "COMP_CODE", d.unit_code as "UNIT_CODE", 
                    m.ag_type as "AG_TYPE",(select agency_type_desc from cir_agency_typ_mast where comp_code=d.comp_code and agency_type_code=m.ag_type) as "AGENCY_TYPE_NAME",
                    sum(d.tot_supply) as "TOT_SUPPLY", sum(d.amount) as "AMOUNT",  sum(d.no_of_days) as "NO_OF_DAYS"
                    from cir_inct_process_det d,cir_agmast m
                    where d.comp_code=m.comp_code and d.comp_code=@pcompcode and d.unit_code=m.unit and  d.unit_code=isnull(@punitcode,d.unit_code) and 
                    d.bilagcd=m.agcd and d.bilagcd=isnull(@pagcd,d.bilagcd) and d.bildpcd=m.dpcd and d.bildpcd=isnull(@pdpcd,d.bildpcd) and 
                    d.doctype='CN' and d.recptdt between @v_frdt and @v_todt and d.publ_code=isnull(@ppublcode,d.publ_code) and d.tran_type='INC' and 
                    (m.branch_code=@pbrancode or @pbrancode is null) and (m.state_code=@pstate_code or @pstate_code is null) and 
                    (m.dist_code=@pdist_code or @pdist_code is null) and (m.city_code=@pcity_code or @pcity_code is null) and 
                    (m.state_code=@pstate_code or @pstate_code is null)
                    group by d.comp_code , d.unit_code , m.ag_type
                    order by comp_code,unit_code,agency_type_name;
                    
                   
                    select d.comp_code as "COMP_CODE", d.unit_code as "UNIT_CODE", 
                    sum(d.tot_supply) as "TOT_SUPPLY", sum(d.amount) as "AMOUNT",  sum(d.no_of_days) as "NO_OF_DAYS"
                    from cir_inct_process_det d,cir_agmast m
                    where d.comp_code=m.comp_code and d.comp_code=@pcompcode and d.unit_code=m.unit and  d.unit_code=isnull(@punitcode,d.unit_code) and 
                    d.bilagcd=m.agcd and d.bilagcd=isnull(@pagcd,d.bilagcd) and d.bildpcd=m.dpcd and d.bildpcd=isnull(@pdpcd,d.bildpcd) and 
                    d.doctype='CN' and d.recptdt between @v_frdt and @v_todt and d.publ_code=isnull(@ppublcode,d.publ_code) and d.tran_type='INC' and 
                    (m.branch_code=@pbrancode or @pbrancode is null) and (m.state_code=@pstate_code or @pstate_code is null) and 
                    (m.dist_code=@pdist_code or @pdist_code is null) and (m.city_code=@pcity_code or @pcity_code is null) and 
                    (m.state_code=@pstate_code or @pstate_code is null)
                    group by d.comp_code , d.unit_code , d.recptdt, d.recptno,d.publ_code, d.bilagcd, d.bildpcd,m.ag_name,m.station_code, 
                    m.city_code,m.country_code, m.state_code,m.dist_code,m.ag_type
                    order by comp_code,unit_code;

                 end

                      
                else--for Monthly summary
                  begin  
                   
                    select d.comp_code as "COMP_CODE", d.unit_code as "UNIT_CODE"					,
					(d.recptdt) as "MONTH_YEAR",
                    m.ag_type as "AG_TYPE",(select agency_type_desc from cir_agency_typ_mast where comp_code=d.comp_code and agency_type_code=m.ag_type) as "AGENCY_TYPE_NAME",
                    sum(d.tot_supply) as "TOT_SUPPLY", sum(d.amount) as "AMOUNT",  sum(d.no_of_days) as "NO_OF_DAYS"
                    from cir_inct_process_det d,cir_agmast m
                    where d.comp_code=m.comp_code and d.comp_code=@pcompcode and d.unit_code=m.unit and  d.unit_code=isnull(@punitcode,d.unit_code) and 
                    d.bilagcd=m.agcd and d.bilagcd=isnull(@pagcd,d.bilagcd) and d.bildpcd=m.dpcd and d.bildpcd=isnull(@pdpcd,d.bildpcd) and 
                    d.doctype='CN' and d.recptdt between @v_frdt and @v_todt and d.publ_code=isnull(@ppublcode,d.publ_code) and d.tran_type='INC' and 
                    (m.branch_code=@pbrancode or @pbrancode is null) and (m.state_code=@pstate_code or @pstate_code is null) and 
                    (m.dist_code=@pdist_code or @pdist_code is null) and (m.city_code=@pcity_code or @pcity_code is null) and 
                    (m.state_code=@pstate_code or @pstate_code is null)
                    group by d.comp_code,d.unit_code,m.ag_type,d.recptdt,d.recptno
                    order by comp_code,unit_code,agency_type_name,recptdt,recptno;
                    
                   
                    select d.comp_code as "COMP_CODE", d.unit_code as "UNIT_CODE", 
                    sum(d.tot_supply) as "TOT_SUPPLY", sum(d.amount) as "AMOUNT",  sum(d.no_of_days) as "NO_OF_DAYS"
                    from cir_inct_process_det d,cir_agmast m
                    where d.comp_code=m.comp_code and d.comp_code=@pcompcode and d.unit_code=m.unit and  d.unit_code=isnull(@punitcode,d.unit_code) and 
                    d.bilagcd=m.agcd and d.bilagcd=isnull(@pagcd,d.bilagcd) and d.bildpcd=m.dpcd and d.bildpcd=isnull(@pdpcd,d.bildpcd) and 
                    d.doctype='CN' and d.recptdt between @v_frdt and @v_todt and d.publ_code=isnull(@ppublcode,d.publ_code) and d.tran_type='INC' and 
                    (m.branch_code=@pbrancode or @pbrancode is null) and (m.state_code=@pstate_code or @pstate_code is null) and 
                    (m.dist_code=@pdist_code or @pdist_code is null) and (m.city_code=@pcity_code or @pcity_code is null) and 
                    (m.state_code=@pstate_code or @pstate_code is null)
                    group by d.comp_code , d.unit_code,d.bilagcd , d.bildpcd,m.ag_name
                    order by comp_code,unit_code;
                                    
                end  

        end           
           else--for agency wise
                if (@preptype='D') begin--details
                   
print('garima')
                    select d.comp_code as "COMP_CODE", d.unit_code as "UNIT_CODE", 
case @pdateformat
when 'mm/dd/yyyy' then convert(varchar(10),d.recptdt,101) 
when 'dd/mm/yyyy' then convert(varchar(10),d.recptdt,103) 
when 'yyyy/mm/dd' then convert(varchar(10),d.recptdt,111)  end as "RECPTDT",

 d.recptno as "RECPTNO",
                    d.publ_code as "PUBL_CODE",dbo.cir_get_publ_name(d.comp_code,d.publ_code) as "PUBL_NAME", d.bilagcd as "AGCD", d.bildpcd as "DPCD",
                    m.ag_name as "AG_NAME",dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME", 
                    dbo.cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",dbo.cir_get_state(d.comp_code,m.country_code, m.state_code) as "STATE_NAME",
                    dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) as "DIST_NAME",
                    m.ag_type as "AG_TYPE",(select agency_type_desc from cir_agency_typ_mast where comp_code=d.comp_code and agency_type_code=m.ag_type) as "AGENCY_TYPE_NAME",
                    sum(d.tot_supply) as "TOT_SUPPLY", 
                    sum(d.amount) as "AMOUNT",  sum(d.no_of_days) as "NO_OF_DAYS"
                    from cir_inct_process_det d,cir_agmast m
                    where d.comp_code=m.comp_code and d.comp_code=@pcompcode and d.unit_code=m.unit and  d.unit_code=isnull(@punitcode,d.unit_code) and 
                    d.bilagcd=m.agcd and d.bilagcd=isnull(@pagcd,d.bilagcd) and d.bildpcd=m.dpcd and d.bildpcd=isnull(@pdpcd,d.bildpcd) and 
                    d.doctype='CN' 
                    and d.recptdt between @v_frdt and @v_todt 
                    and d.publ_code=isnull(@ppublcode,d.publ_code) and d.tran_type='INC' and 
                    (m.branch_code=@pbrancode or @pbrancode is null) and (m.state_code=@pstate_code or @pstate_code is null) and 
                    (m.dist_code=@pdist_code or @pdist_code is null) and (m.city_code=@pcity_code or @pcity_code is null) and 
                    (m.state_code=@pstate_code or @pstate_code is null)
                    group by d.comp_code , d.unit_code , d.recptdt, d.recptno,d.publ_code, d.bilagcd, d.bildpcd,m.ag_name,m.station_code, 
                    m.city_code,m.country_code, m.state_code,m.dist_code,m.ag_type
                    order by comp_code,unit_code,ag_name,recptdt,recptno;
                    
                 
                    select d.comp_code as "COMP_CODE", d.unit_code as "UNIT_CODE", d.bilagcd as "AGCD", d.bildpcd as "DPCD",
                    m.ag_name as "AG_NAME",
                    sum(d.tot_supply) as "TOT_SUPPLY", sum(d.amount) as "AMOUNT",  sum(d.no_of_days) as "NO_OF_DAYS"
                    from cir_inct_process_det d,cir_agmast m
                    where d.comp_code=m.comp_code and d.comp_code=@pcompcode and d.unit_code=m.unit and  d.unit_code=isnull(@punitcode,d.unit_code) and 
                    d.bilagcd=m.agcd and d.bilagcd=isnull(@pagcd,d.bilagcd) and d.bildpcd=m.dpcd and d.bildpcd=isnull(@pdpcd,d.bildpcd) and 
                    d.doctype='CN' and d.recptdt between @v_frdt and @v_todt and d.publ_code=isnull(@ppublcode,d.publ_code) and d.tran_type='INC' and 
                    (m.branch_code=@pbrancode or @pbrancode is null) and (m.state_code=@pstate_code or @pstate_code is null) and 
                    (m.dist_code=@pdist_code or @pdist_code is null) and (m.city_code=@pcity_code or @pcity_code is null) and 
                    (m.state_code=@pstate_code or @pstate_code is null)
                    group by d.comp_code , d.unit_code ,d.bilagcd , d.bildpcd,m.ag_name
                    order by comp_code,unit_code,ag_name;    
                   end 


                else if(@preptype='S')
                 begin--summary
                  
                    select d.comp_code as "COMP_CODE", d.unit_code as "UNIT_CODE", d.bilagcd as "AGCD", d.bildpcd as "DPCD",
                    m.ag_name as "AG_NAME",dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME", 
                    dbo.cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",dbo.cir_get_state(d.comp_code,m.country_code, m.state_code) as "STATE_NAME",
                    dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) as "DIST_NAME",
                    m.ag_type as "AG_TYPE",(select agency_type_desc from cir_agency_typ_mast where comp_code=d.comp_code and agency_type_code=m.ag_type) as "AGENCY_TYPE_NAME",
                    sum(d.tot_supply) as "TOT_SUPPLY", sum(d.amount) as "AMOUNT",  sum(d.no_of_days) as "NO_OF_DAYS"
                    from cir_inct_process_det d,cir_agmast m
                    where d.comp_code=m.comp_code and d.comp_code=@pcompcode and d.unit_code=m.unit and  d.unit_code=isnull(@punitcode,d.unit_code) and 
                    d.bilagcd=m.agcd and d.bilagcd=isnull(@pagcd,d.bilagcd) and d.bildpcd=m.dpcd and d.bildpcd=isnull(@pdpcd,d.bildpcd) and 
                    d.doctype='CN' and d.recptdt between @v_frdt and @v_todt and d.publ_code=isnull(@ppublcode,d.publ_code) and d.tran_type='INC' and 
                    (m.branch_code=@pbrancode or @pbrancode is null) and (m.state_code=@pstate_code or @pstate_code is null) and 
                    (m.dist_code=@pdist_code or @pdist_code is null) and (m.city_code=@pcity_code or @pcity_code is null) and 
                    (m.state_code=@pstate_code or @pstate_code is null)
                    group by d.comp_code , d.unit_code , d.bilagcd, d.bildpcd,m.ag_name,m.station_code, 
                    m.city_code,m.country_code, m.state_code,m.dist_code,m.ag_type
                    order by comp_code,unit_code,ag_name;
                    
                   
                    select d.comp_code as "COMP_CODE", d.unit_code as "UNIT_CODE", 
                    sum(d.tot_supply) as "TOT_SUPPLY", sum(d.amount) as "AMOUNT",  sum(d.no_of_days) as "NO_OF_DAYS"
                    from cir_inct_process_det d,cir_agmast m
                    where d.comp_code=m.comp_code and d.comp_code=@pcompcode and d.unit_code=m.unit and  d.unit_code=isnull(@punitcode,d.unit_code) and 
                    d.bilagcd=m.agcd and d.bilagcd=isnull(@pagcd,d.bilagcd) and d.bildpcd=m.dpcd and d.bildpcd=isnull(@pdpcd,d.bildpcd) and 
                    d.doctype='CN' and d.recptdt between @v_frdt and @v_todt and d.publ_code=isnull(@ppublcode,d.publ_code) and d.tran_type='INC' and 
                    (m.branch_code=@pbrancode or @pbrancode is null) and (m.state_code=@pstate_code or @pstate_code is null) and 
                    (m.dist_code=@pdist_code or @pdist_code is null) and (m.city_code=@pcity_code or @pcity_code is null) and 
                    (m.state_code=@pstate_code or @pstate_code is null)
                    group by d.comp_code , d.unit_code 
                    order by comp_code,unit_code;                
                  end  
               

 else --for Monthly summary
                    begin                           
                
                    select d.comp_code as "COMP_CODE", d.unit_code as "UNIT_CODE",
(d.recptdt) as "MONTH_YEAR",
                    d.bilagcd as "AGCD", d.bildpcd as "DPCD",
                    m.ag_name as "AG_NAME",dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME", 
                    dbo.cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",dbo.cir_get_state(d.comp_code,m.country_code, m.state_code) as "STATE_NAME",
                    dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) as "DIST_NAME",
                    m.ag_type as "AG_TYPE",(select agency_type_desc from cir_agency_typ_mast where comp_code=d.comp_code and agency_type_code=m.ag_type) as "AGENCY_TYPE_NAME",
                    sum(d.tot_supply) as "TOT_SUPPLY", sum(d.amount) as "AMOUNT",  sum(d.no_of_days) as "NO_OF_DAYS"
                    from cir_inct_process_det d,cir_agmast m
                    where d.comp_code=m.comp_code and d.comp_code=@pcompcode and d.unit_code=m.unit and  d.unit_code=isnull(@punitcode,d.unit_code) and 
                    d.bilagcd=m.agcd and d.bilagcd=isnull(@pagcd,d.bilagcd) and d.bildpcd=m.dpcd and d.bildpcd=isnull(@pdpcd,d.bildpcd) and 
                    d.doctype='CN' and d.recptdt between @v_frdt and @v_todt and d.publ_code=isnull(@ppublcode,d.publ_code) and d.tran_type='INC' and 
                    (m.branch_code=@pbrancode or @pbrancode is null) and (m.state_code=@pstate_code or @pstate_code is null) and 
                    (m.dist_code=@pdist_code or @pdist_code is null) and (m.city_code=@pcity_code or @pcity_code is null) and 
                    (m.state_code=@pstate_code or @pstate_code is null)
                    group by d.comp_code , d.unit_code ,
d.recptdt,
                    d.bilagcd, d.bildpcd,m.ag_name,m.station_code, m.city_code,m.country_code, m.state_code,m.dist_code,m.ag_type
                    order by comp_code,unit_code,agency_type_name;
                    --,recptdt,recptno;
                    
                  
                    select d.comp_code as "COMP_CODE", d.unit_code as "UNIT_CODE", 
                    sum(d.tot_supply) as "TOT_SUPPLY", sum(d.amount) as "AMOUNT",  sum(d.no_of_days) as "NO_OF_DAYS"
                    from cir_inct_process_det d,cir_agmast m
                    where d.comp_code=m.comp_code and d.comp_code=@pcompcode and d.unit_code=m.unit and  d.unit_code=isnull(@punitcode,d.unit_code) and 
                    d.bilagcd=m.agcd and d.bilagcd=isnull(@pagcd,d.bilagcd) and d.bildpcd=m.dpcd and d.bildpcd=isnull(@pdpcd,d.bildpcd) and 
                    d.doctype='CN' and d.recptdt between @v_frdt and @v_todt and d.publ_code=isnull(@ppublcode,d.publ_code) and d.tran_type='INC' and 
                    (m.branch_code=@pbrancode or @pbrancode is null) and (m.state_code=@pstate_code or @pstate_code is null) and 
                    (m.dist_code=@pdist_code or @pdist_code is null) and (m.city_code=@pcity_code or @pcity_code is null) and 
                    (m.state_code=@pstate_code or @pstate_code is null)
                    group by d.comp_code , d.unit_code
                    order by comp_code,unit_code;
                                    
                End 

        




/




/////////////////////////////////////////////////////Bank Guaranee 04/01/2012//////////////////////////////////////////////
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[cir_bank_guarantee_bind]
   @pcomp_code     as       VARCHAR(200),
   @pagcd          as       VARCHAR(200),
   @pdpcd          as       VARCHAR(200),
   @pexpiry_date   as       datetime,
   @pexpiry_days   as       int,
   @pinstrument_ty as       VARCHAR(200),
   @pdateformat    as       VARCHAR(200),
   @pextra         as       VARCHAR(200),
   @pextra1        as       VARCHAR(200),
   @pextra2        as       VARCHAR(200)

aS
	declare @v_dt datetime
BEGIN
	If @pagcd='' Begin
		set @pagcd=null
	End
	If @pdpcd='' Begin
		set @pdpcd=null
	End		
	If @pinstrument_ty='' Begin
		set @pinstrument_ty=null
	End		

   set @v_dt    = @pexpiry_date + isnull(@pexpiry_days,0)
	print('a')
	print(@v_dt)
      SELECT b.COMP_CODE, b.UNIT_CODE, b.AGCD, b.DPCD,m.ag_name AG_NAME,DBO.CIR_GET_DROP_POINT_NAME(B.COMP_CODE,B.UNIT_CODE,M.STATION_CODE,1) DROP_POINT_NAME,
    DBO.CIR_GET_CITY(B.COMP_CODE,M.CITY_CODE) CITY_NAME, 
    b.BG_NO, b.BG_AMT, b.BG_DATE, b.BG_VALID, b.BANK_DESC, 
    b.CREATED_BY, b.CREATED_DT, b.UPDATED_BY, b.UPDATED_DT, b.BG_TYPE
    FROM cir_bank_guarantee b,cir_agmast m
    where m.comp_code =b.comp_code and m.comp_code = @pcomp_code and b.unit_code=m.unit  
    and b.agcd=m.agcd and b.agcd    = ISNULL(@pagcd,b.agcd) 
    and b.dpcd=m.dpcd and b.dpcd    = ISNULL(@pdpcd,b.dpcd)
    and ((b.bg_type = @pinstrument_ty) or (@pinstrument_ty is null))
    and b.bg_valid between convert(varchar(20),@pexpiry_date,101) and convert(varchar(20),@v_dt,101) 
    ORDER BY AG_NAME
END


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//********************10th Jan 2012 by nand for unsold approval*****************************
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER procedure [dbo].[cir_pending_unsold_supply]
    @pcompcode       as varchar(200),
    @punitcode       as varchar(200),
    @pbrancode       as varchar(200),
    @pagcd           as varchar(200),
    @pdpcd           as varchar(200),
    @pfromdate       as varchar(200), 
    @ptilldate       as varchar(200),
    @puserid         as varchar(200), 
    @pdateformate    as varchar(200),
    @precptno		 as varchar(200),--for Receipt No.
    @pdroppoint		 as varchar(200),--for drop point
    @pentry_fromdt	 as varchar(200),--for date of from entry	
    @pentry_tilldt	 as varchar(200),--for date of till entry
    @pextra1         as varchar(200),
    @pextra2         as varchar(200),--it is used for agency or distribution
    @pextra3         as varchar(200),
    @pextra4         as varchar(200),
    @pextra5         as varchar(200)
    
as
    declare @v_from_date     datetime
    declare @v_till_date     datetime
    declare @v_efrom_date     datetime
    declare @v_etill_date     datetime    
begin
-- lata
    If @pfromdate is not null or @pfromdate<>'' or @ptilldate is not null or @ptilldate<>'' Begin
		set @v_from_date=DBO.CONVERT_USER_DATE('/', @pfromdate,@pdateformate)
		set @v_till_date=DBO.CONVERT_USER_DATE('/', @ptilldate,@pdateformate)
	End	
    If @pentry_fromdt is not null or @pentry_fromdt<>''  or @pentry_tilldt is not null or @pentry_tilldt<>'' Begin
		set @v_efrom_date=DBO.CONVERT_USER_DATE('/', @pentry_fromdt,@pdateformate)
		set @v_etill_date=DBO.CONVERT_USER_DATE('/', @pentry_tilldt,@pdateformate)    
	End	
    If @precptno='' Begin
		set @precptno=null
    End
     if upper(isnull(@pextra2,'/'))='D' Begin
        select h.comp_code as "COMP_CODE",h.unit_code as "UNIT_CODE",h.agcd as "AGCD",h.dpcd as "DPCD",m.ag_name as "AGENCY_NAME",m.city_code as "CITY_CODE",
            dbo.cir_get_city(h.comp_code,m.city_code) as "CITY_NAME",h.doctype as "DOCTYPE",h.recptno as "RECPTNO",h.recptdt as "RECPTDT",
            m.station_code as "DROP_POINT",dbo.cir_get_drop_point_name(h.comp_code,h.unit_code,m.station_code,'1') as "DROP_POINT_NAME",
            sum(d.copy_amt) as "NET_AMT",sum(isnull(d.short_recpt,0)+isnull(d.late_recpt,0)+isnull(d.bnr,0)+isnull(d.unsold,0)+isnull(d.damage,0)) as "NET_UNSOLD"
            from cir_unsold_hdr_dis h,cir_unsold_dtl_dis d,cir_agmast_dis m
            where h.comp_code=d.comp_code and h.comp_code=m.comp_code and h.comp_code=@pcompcode and 
                h.unit_code=d.unit_code and h.unit_code=m.unit and h.unit_code=@punitcode and h.doctype=d.doctype and h.agcd=d.agcd and h.agcd=m.agcd and 
                h.dpcd=d.dpcd and h.dpcd=m.dpcd and (h.agcd=@pagcd or @pagcd is null or @pagcd='') and (h.dpcd=@pdpcd or @pdpcd is null or @pdpcd='') and
                h.recptdt=d.recptdt and 
                ((h.recptdt>=@v_from_date and h.recptdt<=@v_till_date) or @pfromdate is null or @pfromdate='') and 
                h.recptno=d.recptno and h.recptno=isnull(@precptno,h.recptno) and (d.branch_code=@pbrancode or @pbrancode is null or @pbrancode='') and
                (d.app_userid is null or d.app_userid='') and (isnull(d.apr_short_recpt,0)+isnull(d.apr_late_recpt,0)+isnull(d.apr_bnr,0)+isnull(d.apr_unsold,0)+isnull(d.apr_damage,0))=0 and
                ((h.entrydt>=@v_efrom_date and h.entrydt<=@v_etill_date) or @pentry_fromdt is null or @pentry_fromdt='') and
                (m.station_code=@pdroppoint or @pdroppoint is null or @pdroppoint='')
            group by h.comp_code,h.unit_code,h.agcd,h.dpcd,m.ag_name,m.city_code,h.doctype,h.recptno,h.recptdt,m.station_code
            order by recptdt,recptno,agency_name
    End
    Else Begin
        select h.comp_code as "COMP_CODE",h.unit_code "UNIT_CODE",h.agcd as "AGCD",h.dpcd as "DPCD",m.ag_name as "AGENCY_NAME",m.city_code as "CITY_CODE",
            dbo.cir_get_city(h.comp_code,m.city_code) as "CITY_NAME",h.doctype as "DOCTYPE",h.recptno as "RECPTNO",h.recptdt as "RECPTDT",
            m.station_code as "DROP_POINT",dbo.cir_get_drop_point_name(h.comp_code,h.unit_code,m.station_code,'1') as "DROP_POINT_NAME",
            sum(d.copy_amt) as "NET_AMT",sum(isnull(d.short_recpt,0)+isnull(d.late_recpt,0)+isnull(d.bnr,0)+isnull(d.unsold,0)+isnull(d.damage,0)) as "NET_UNSOLD"
            from cir_unsold_hdr h,cir_unsold_dtl d,cir_agmast m
            where h.comp_code=d.comp_code and h.comp_code=m.comp_code and h.comp_code=@pcompcode and 
                h.unit_code=d.unit_code and h.unit_code=m.unit and h.unit_code=@punitcode and h.doctype=d.doctype and h.agcd=d.agcd and h.agcd=m.agcd and 
                h.dpcd=d.dpcd and h.dpcd=m.dpcd and (h.agcd=@pagcd or @pagcd is null or @pagcd='') and (h.dpcd=@pdpcd or @pdpcd is null or @pdpcd='') and
                h.recptdt=d.recptdt and 
                ((h.recptdt>=@v_from_date and h.recptdt<=@v_till_date) or @pfromdate is null or @pfromdate='') and 
                h.recptno=d.recptno and h.recptno=isnull(@precptno,h.recptno) and (d.branch_code=@pbrancode or @pbrancode is null or @pbrancode='') and
                (d.app_userid is null or d.app_userid='') and (isnull(d.apr_short_recpt,0)+isnull(d.apr_late_recpt,0)+isnull(d.apr_bnr,0)+isnull(d.apr_unsold,0)+isnull(d.apr_damage,0))=0 and
                ((h.entrydt>=@v_efrom_date and h.entrydt<=@v_etill_date) or @pentry_fromdt is null or @pentry_fromdt='') and
                (m.station_code=@pdroppoint or @pdroppoint is null or @pdroppoint='')
            group by h.comp_code,h.unit_code,h.agcd,h.dpcd,m.ag_name,m.city_code,h.doctype,h.recptno,h.recptdt,m.station_code
            order by recptdt,recptno,agency_name
    End
End
//*******************************************

