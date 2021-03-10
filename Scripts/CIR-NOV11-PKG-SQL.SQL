//////////***************ISSUE NO. 0004767 ******************///*******1/11/2011****//////

USE [abhi]
GO
/****** Object:  StoredProcedure [dbo].[cir_comm_mast_bind_p]    Script Date: 11/01/2011 12:15:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[cir_comm_mast_bind_p]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@porderby                                 VARCHAR(200) 
AS 
declare @v_str varchar(4000)	
		set @v_str='SELECT a.*,DBO.cir_get_publ_name(a.comp_code, a.publ) PUBL_NAME ,
				 DBO.cir_get_edtn_name(a.comp_code, a.edtn) EDTN_NAME 
		FROM  cir_comm_mast a 
		WHERE a.comp_code  = '+''''+@pcomp_code+''''+' AND	a.unit_code  = '+''''+@punit_code+''''+' order by '+@porderby

print(@v_str)
exec(@v_str)

//////////*************** END*****ISSUE NO. 0004767 ******************///*******1/11/2011****//////


//////////*************** START*****ISSUE NO. 0004826 ******************///*******1/11/2011****//////
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[cir_agency_bind_cir_agency_listing_p]
	@pcompcode			VARCHAR(20) ,
	@punit              VARCHAR(20) ,
	@pagty              VARCHAR(20) ,
	@pdateformat        VARCHAR(20) ,
	@pextra1            VARCHAR(4000) ,
	@pextra2            VARCHAR(4000) 
AS
/*SELECT cir_agmast.*,
		  DBO.cir_get_city(cir_agmast.comp_code, cir_agmast.city_code) "CITY NAME",
		  DBO.cir_get_agency_type(cir_agmast.comp_code, cir_agmast.ag_type) "AGENCY TYPE NAME"
	FROM  cir_agmast 
	WHERE comp_code  = @pcompcode AND unit  = @punit
	 AND ((ag_type  = @pagty) OR @pagty  is null or @pagty='')
	ORDER BY cir_agmast.ag_type,cir_agmast.ag_name */
	
	select A.COMP_CODE,A.UNIT,A.BRANCH_CODE,C."Branch_Name" BRANCH_NAME, A.AGCD,A.DPCD,A.AG_NAME,A.AG_NAME_OTH_LANG,
        A.AG_CLASS,(SELECT CLASS_DESC FROM CIR_AGENCY_CLASS_MAST WHERE CIR_AGENCY_CLASS_MAST.COMP_CODE=A.COMP_CODE AND CIR_AGENCY_CLASS_MAST.CLASS_CODE=A.AG_CLASS) AG_CLASS_NAME,
        A.AG_TYPE,DBO.CIR_GET_AGENCY_TYPE(A.COMP_CODE,A.AG_TYPE) AG_TYPE_NAME, A.SUPPLY_START_DT,
        A.ADDR1, A.ADDR2, A.ADDR3,A.PIN_CODE, A.CITY_CODE,DBO.CIR_GET_CITY(A.COMP_CODE,A.CITY_CODE) CITY_NAME, A.DIST_CODE,DBO.CIR_GET_DIST(A.COMP_CODE,A.STATE_CODE,A.DIST_CODE) DIST_NAME,
        A.STATE_CODE,DBO.CIR_GET_STATE(A.COMP_CODE,A.COUNTRY_CODE,A.STATE_CODE) STATE_NAME, A.TEHSIL_TALUKA TALUKA_CODE,DBO.CIR_GET_TALUKA(A.COMP_CODE,A.TEHSIL_TALUKA) TALUKA_NAME, 
        A.STATION_CODE,DBO.CIR_GET_DROP_POINT_NAME(A.COMP_CODE,A.UNIT,A.STATION_CODE,1) DROP_POINT_NAME,
        A.AREA_CODE,DBO.CIR_GET_AREA(A.COMP_CODE,A.AREA_CODE) AREA_NAME, A.PHONE_NO1, A.PHONE_NO2, A.MOBILE_NO1, A.MOBILE_NO2,A.FAX_NO, A.EMAIL_ID, A.SUSPEND, A.SUSPEND_TYPE, A.SUSPEND_DATE, 
        A.TO_BILL, A.BILL_AGCD, A.BILL_DPCD,DBO.CIR_GET_AGENCY(A.COMP_CODE,A.UNIT,A.BILL_AGCD,A.BILL_DPCD) BILL_AGENCY, A.PAYMODE, A.CREDIT_DAYS, A.PRINT_LABEL, A.PIN_PACKET, 
        A.PIN_AGCD, A.PIN_DPCD,DBO.CIR_GET_AGENCY(A.COMP_CODE,A.UNIT,A.PIN_AGCD,A.PIN_DPCD) PIN_AGENCY, A.PIN_OPEN_INSIDE,
        A.NAME_ON_LABEL, A.PRINT_SEQ,CASE WHEN A.UNSOLD_VALID_FLAG='D' THEN 'Daily' WHEN A.UNSOLD_VALID_FLAG='W' THEN 'Weekly' ELSE 'Monthly' END BILL_CYCLE, 
        A.SECURITY_PER, A.SEC_AMT_LIMT, A.SUPPLY_STOP_FLAG, A.SUPPLY_STOP_PER, A.ABC_CITYCODE,DBO.CIR_GET_CITY(A.COMP_CODE,A.ABC_CITYCODE) ABC_CITY_NAME,
        B.NAME CON_PER_NAME,B.DESIG CON_PER_DESIG,B.PER_ROLE CON_PER_PER_ROLE,B.DATE_OF_BIRTH DATE_OF_BIRTH, B.PHONE_NO1 CON_PER_PHONE_NO1, B.PHONE_NO2 CON_PER_PHONE_NO2, 
        B.MOBILE_NO1 CON_PER_MOBILE_NO1, B.MOBILE_NO2 CON_PER_MOBILE_NO2, B.FAX_NO CON_PER_FAX_NO, B.EMAIL_ID CON_PER_EMAIL_ID
    from cir_agmast a,cir_ag_con_per b,branch_mst c
        where a.comp_code=b.comp_code and a.comp_code = @pcompcode and a.unit=b.unit and (a.unit = @punit or @punit is null or @punit='') and 
        a.agcd=b.agcd and a.dpcd=b.dpcd and a.branch_code=c."Branch_Code" and (ag_type = @pagty or @pagty is null or @pagty='')
    order by a.comp_code,a.unit,a.ag_name, b.name
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

//////////*************** END*****ISSUE NO. 0004826 ******************///*******1/11/2011****//////

//////////*************** START*****ISSUE NO. 0004811 ******************///*******2/11/2011****//////
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[cir_extra_rate_bind_p]
    @pcomp_code             as varchar(200),
    @punit_code             as varchar(200),
    @ppubl                     as varchar(200),
    @pedtn                     as varchar(200),
    @pdateformat         as varchar(200),
    @porderby                 as varchar(200),
    @pextra1                 as varchar(200),
    @pextra2                 as varchar(200)
    As
Begin
	declare @vquery        varchar(4000)
    set @vquery=' select cir_extra_rate_mast.*,
                    dbo.cir_get_publ_name(cir_extra_rate_mast.comp_code,cir_extra_rate_mast.publ) PUBL_NAME,
                    dbo.cir_get_edtn_name(cir_extra_rate_mast.comp_code,cir_extra_rate_mast.edtn) EDTN_NAME
        from cir_extra_rate_mast
           where comp_code='+''''+@pcomp_code+''''+' and
                 unit='+''''+@punit_code+''''+' and
                ((publ='+''''+@ppubl+''''+') or ('+''''+@ppubl+''''+' is null) or ('+''''+@ppubl+''''+' ='+''''+''''+')) and
                ((edtn='+''''+@pedtn+''''+') or ('+''''+@pedtn+''''+' is null) or ('+''''+@pedtn+''''+' ='+''''+''''+'))
                 order by '+@porderby;
	print(@vquery)
	exec(@vquery)
     
End
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
//////////*************** END*****ISSUE NO. 0004811 ******************///*******2/11/2011****//////



//////////*************** START*****ISSUE NO. 0005466 ******************///*******2/11/2011****//////


////cir_rep_supply_cir_route_wise_supply--->Start--->


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[cir_rep_supply_cir_route_wise_supply]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@proute                                   VARCHAR(20) ,
	@pfrom_supdate                            DATETIME ,
	@ptill_supdate                            DATETIME ,
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
	d.route_code AS "ROUTE_CODE",dbo.cir_get_route_name(d.comp_code,d.unit_code,d.route_code) AS "ROUTE_NAME",
	d.agcd AS "AGCD",d.dpcd AS "DPCD",m.ag_name AS "AG_NAME",m.ag_name_oth_lang AS "AG_NAME_OTH_LANG",sum(d.sup_copy) AS "SUP_COPY",
	dbo.cir_get_route_seqno(d.comp_code,d.unit_code,d.route_code) AS "ROUTE_SEQNO",
	dbo.cir_get_supply_seqno(d.comp_code,d.unit_code,@ppubl,@pedtn,d.agcd,d.dpcd) AS "SUPPLY_SEQNO",
	dbo.cir_get_name_cir_route(d.comp_code,d.unit_code,d.route_code,2,null,null,null) AS "ROUTE_OTH_NAME",
	dbo.cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",
	dbo.cir_get_name_cir_city(d.comp_code,m.city_code,2,null,null,null) as "CITY_ONAME",
	dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME",
	dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) as "DROP_POINT_ONAME"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
		 d.unit_code    = m.unit and
		 d.agcd         = m.agcd and
		 d.dpcd         = m.dpcd and
		 d.comp_code    = @pcomp_code and
		 d.unit_code    = @punit_code and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (d.route_code = @proute or @proute is null) and
		 d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
	  group by d.comp_code,d.unit_code,d.route_code,
			   d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code
	  order by d.comp_code,d.unit_code,route_seqno,d.route_code,supply_seqno ,d.agcd,d.dpcd
        
		select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
		d.route_code AS "ROUTE_CODE",dbo.cir_get_route_name(d.comp_code,d.unit_code,d.route_code) AS "ROUTE_NAME",
		sum(d.sup_copy) AS "SUP_COPY",
		dbo.cir_get_route_seqno(d.comp_code,d.unit_code,d.route_code) AS "ROUTE_SEQNO",
		dbo.cir_get_name_cir_route(d.comp_code,d.unit_code,d.route_code,2,null,null,null) AS "ROUTE_OTH_NAME"
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e
		where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
			 d.unit_code    = m.unit and
			 d.agcd         = m.agcd and
			 d.dpcd         = m.dpcd and
			 d.comp_code    = @pcomp_code and
			 d.unit_code    = @punit_code and
			 d.publ         = e.publ and d.publ         = @ppubl and
			 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
			 (d.route_code = @proute or @proute is null) and
			 d.supdate between @pfrom_supdate and @ptill_supdate and
			 (e.main_edtn=@pmainedtn or @pmainedtn is null)
		  group by d.comp_code,d.unit_code,d.route_code
		  order by d.comp_code,d.unit_code,route_seqno,d.route_code
		
		select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",sum(d.sup_copy) AS "SUP_COPY"
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e
			where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
				 d.unit_code    = m.unit and
				 d.agcd         = m.agcd and
				 d.dpcd         = m.dpcd and
				 d.comp_code    = @pcomp_code and
				 d.unit_code    = @punit_code and
				 d.publ         = e.publ and d.publ         = @ppubl and
				 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
				 (d.route_code = @proute or @proute is null) and
				 d.supdate between @pfrom_supdate and @ptill_supdate and
				 (e.main_edtn=@pmainedtn or @pmainedtn is null)
			  group by d.comp_code,d.unit_code
			  order by d.comp_code,d.unit_code
		
		select d.comp_code as "COMP_CODE",sum(d.sup_copy) AS "SUP_COPY",max(sup_rate) as "COPY_RATE"
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e
			where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
				 d.unit_code    = m.unit and
				 d.agcd         = m.agcd and
				 d.dpcd         = m.dpcd and
				 d.comp_code    = @pcomp_code and
				 d.unit_code    = @punit_code and
				 d.publ         = e.publ and d.publ         = @ppubl and
				 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
				 (d.route_code = @proute or @proute is null) and
				 d.supdate between @pfrom_supdate and @ptill_supdate and
				 (e.main_edtn=@pmainedtn or @pmainedtn is null)
			  group by d.comp_code
			  order by d.comp_code
		

cir_rep_supply_cir_route_wise_supply--->End---////




////cir_rep_supply_cir_dist_wise_supply--->Start--->


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[cir_rep_supply_cir_dist_wise_supply]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@proute                                   VARCHAR(20) ,
	@pfrom_supdate                            DATETIME,
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
	m.dist_code AS "DIST_CODE",dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) AS "DIST_NAME",
	d.agcd AS "AGCD",d.dpcd AS "DPCD",m.ag_name AS "AG_NAME",m.ag_name_oth_lang AS "AG_NAME_OTH_LANG",sum(d.sup_copy) AS "SUP_COPY",
	dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,2,null,null,null) AS "DIST_OTH_NAME", 
	dbo.cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",
	dbo.cir_get_name_cir_city(d.comp_code,m.city_code,2,null,null,null) as "CITY_ONAME",
	dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME",
	dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) as "DROP_POINT_ONAME"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
		 d.unit_code    = m.unit and
		 d.agcd         = m.agcd and
		 d.dpcd         = m.dpcd and
		 d.comp_code    = @pcomp_code and
		 d.unit_code    = @punit_code and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (m.dist_code = @proute or @proute is null) and
		 d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
	  group by d.comp_code,d.unit_code,m.dist_code,m.state_code,
			   d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code
	  order by comp_code,unit_code,dist_name,ag_name,agcd,dpcd;
		
	select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
		m.dist_code AS "DIST_CODE",dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) AS "DIST_NAME",
		sum(d.sup_copy) AS "SUP_COPY",
		dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,2,null,null,null) AS "DIST_OTH_NAME"
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e
		where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
			 d.unit_code    = m.unit and
			 d.agcd         = m.agcd and
			 d.dpcd         = m.dpcd and
			 d.comp_code    = @pcomp_code and
			 d.unit_code    = @punit_code and
			 d.publ         = e.publ and d.publ         = @ppubl and
			 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
			 (m.dist_code = @proute or @proute is null) and
			 d.supdate between @pfrom_supdate and @ptill_supdate and
			 (e.main_edtn=@pmainedtn or @pmainedtn is null)
		  group by d.comp_code,d.unit_code,m.dist_code,m.state_code
		  order by comp_code,unit_code,dist_name;
	
	select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",sum(d.sup_copy) AS "SUP_COPY"
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e
		where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
			 d.unit_code    = m.unit and
			 d.agcd         = m.agcd and
			 d.dpcd         = m.dpcd and
			 d.comp_code    = @pcomp_code and
			 d.unit_code    = @punit_code and
			 d.publ         = e.publ and d.publ         = @ppubl and
			 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
			 (m.dist_code = @proute or @proute is null) and
			 d.supdate between @pfrom_supdate and @ptill_supdate and
			 (e.main_edtn=@pmainedtn or @pmainedtn is null)
		  group by d.comp_code,d.unit_code
		  order by comp_code,unit_code;
		
	select d.comp_code as "COMP_CODE",sum(d.sup_copy) AS "SUP_COPY",max(sup_rate) as "COPY_RATE"
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e
		where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
			 d.unit_code    = m.unit and
			 d.agcd         = m.agcd and
			 d.dpcd         = m.dpcd and
			 d.comp_code    = @pcomp_code and
			 d.unit_code    = @punit_code and
			 d.publ         = e.publ and d.publ         = @ppubl and
			 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
			 (m.dist_code = @proute or @proute is null) and
			 d.supdate between @pfrom_supdate and @ptill_supdate and
			 (e.main_edtn=@pmainedtn or @pmainedtn is null)
		  group by d.comp_code
		  order by comp_code;
		


////cir_rep_supply_cir_dist_wise_supply--->End---////




////cir_rep_supply_cir_taluka_wise_supply--->Start--->



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

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
	dbo.cir_get_name.cir_taluka(d.comp_code,m.tehsil_taluka,2,null,null,null) as "TALUKA_OTH_NAME", 
	dbo.cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",
	dbo.cir_get_name.cir_city(d.comp_code,m.city_code,2,null,null,null) as "CITY_ONAME",
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
	dbo.cir_get_name.cir_taluka(d.comp_code,m.tehsil_taluka,2,null,null,null) as "TALUKA_OTH_NAME"
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



////cir_rep_supply_cir_taluka_wise_supply--->End---////




////cir_rep_supply_cir_dist_taluka_wise_sup--->Start--->



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[cir_rep_supply_cir_dist_taluka_wise_sup]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@proute                                   VARCHAR(20) ,
	@pfrom_supdate                            DATETIME ,
	@ptill_supdate                            DATETIME,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(200) ,
	@pextra2                                  VARCHAR(200) 
AS 
if(@ppubl = '') begin
  set @ppubl = null
end
if(@pmainedtn = '')begin
  set @pmainedtn = null
end
if(@pedtn = '')begin
  set @pedtn = null
end
if(@proute = '')begin
  set @proute = null
end
if(@pextra1 = '')begin
  set @pextra1 = null
end
if(@pextra2 = '')begin
  set @pextra2 = null
end
		

	select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
	m.dist_code AS "DIST_CODE",dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) AS "DIST_NAME",
	m.tehsil_taluka AS "TEHSIL_TALUKA",dbo.cir_get_taluka(d.comp_code,m.tehsil_taluka) AS "TALUKA_NAME",
	d.agcd AS "AGCD",d.dpcd AS "DPCD",m.ag_name AS "AG_NAME",m.ag_name_oth_lang AS "AG_NAME_OTH_LANG",sum(d.sup_copy) AS "SUP_COPY",
	dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,2,null,null,null) AS "DIST_OTH_NAME",
	dbo.cir_get_name_cir_taluka(d.comp_code,m.tehsil_taluka,2,null,null,null) as "TALUKA_OTH_NAME", 
	dbo.cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",
	dbo.cir_get_name_cir_city(d.comp_code,m.city_code,2,null,null,null) as "CITY_ONAME",
	dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME",
	dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) as "DROP_POINT_ONAME"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
		 d.unit_code    = m.unit and
		 d.agcd         = m.agcd and
		 d.dpcd         = m.dpcd and
		 d.comp_code    = @pcomp_code and
		 d.unit_code    = @punit_code and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (m.tehsil_taluka = @proute or @proute is null) and
		 d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
	  group by d.comp_code,d.unit_code,m.dist_code,m.state_code,m.tehsil_taluka,
			   d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code
	  order by comp_code,unit_code,dist_name,taluka_name,ag_name,agcd,dpcd		
		
	
	select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
	m.dist_code AS "DIST_CODE",dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) AS "DIST_NAME",
	m.tehsil_taluka AS "TEHSIL_TALUKA",dbo.cir_get_taluka(d.comp_code,m.tehsil_taluka) AS "TALUKA_NAME",
	sum(d.sup_copy) AS "SUP_COPY",
	dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,2,null,null,null) AS "DIST_OTH_NAME",
	dbo.cir_get_name_cir_taluka(d.comp_code,m.tehsil_taluka,2,null,null,null) as "TALUKA_OTH_NAME"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
		 d.unit_code    = m.unit and
		 d.agcd         = m.agcd and
		 d.dpcd         = m.dpcd and
		 d.comp_code    = @pcomp_code and
		 d.unit_code    = @punit_code and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (m.tehsil_taluka = @proute or @proute is null) and
		 d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
	  group by d.comp_code,d.unit_code,m.dist_code,m.state_code,m.tehsil_taluka
	  order by comp_code,unit_code,dist_name,taluka_name
		
		
	select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
	m.dist_code AS "DIST_CODE",dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) AS "DIST_NAME",
	sum(d.sup_copy) AS "SUP_COPY",
	dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,2,null,null,null) AS "DIST_OTH_NAME"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
		 d.unit_code    = m.unit and
		 d.agcd         = m.agcd and
		 d.dpcd         = m.dpcd and
		 d.comp_code    = @pcomp_code and
		 d.unit_code    = @punit_code and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (m.tehsil_taluka = @proute or @proute is null) and
		 d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
	  group by d.comp_code,d.unit_code,m.dist_code,m.state_code
	  order by comp_code,unit_code,dist_name	
		
	select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",sum(d.sup_copy) AS "SUP_COPY"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
		 d.unit_code    = m.unit and
		 d.agcd         = m.agcd and
		 d.dpcd         = m.dpcd and
		 d.comp_code    = @pcomp_code and
		 d.unit_code    = @punit_code and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (m.tehsil_taluka = @proute or @proute is null) and
		 d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
	  group by d.comp_code,d.unit_code
	  order by comp_code,unit_code

	select d.comp_code as "COMP_CODE",sum(d.sup_copy) AS "SUP_COPY",max(sup_rate) as "COPY_RATE"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
		 d.unit_code    = m.unit and
		 d.agcd         = m.agcd and
		 d.dpcd         = m.dpcd and
		 d.comp_code    = @pcomp_code and
		 d.unit_code    = @punit_code and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (m.tehsil_taluka = @proute or @proute is null) and
		 d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
	  group by d.comp_code
	  order by comp_code


////cir_rep_supply_cir_dist_taluka_wise_sup--->End---////


//////////*************** END*****ISSUE NO. 0005466 ******************///*******2/11/2011****//////



/////////////////////////////issue no-4818//////////////////////////////////
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER procedure [dbo].[cir_rep_unsold_supply_cir_publ_unsold_supply]
	@pcomp_code         varchar(30),
	@punit_code         varchar(30),
	@pdoc_type          varchar(30),
	@ppubl              varchar(30),
	@pmainedtn          varchar(30),
	@pedtn              varchar(30),
	@pagcode            varchar(30),
	@pdepocode          varchar(30),
	@pfromdate          varchar(30),
	@ptilldate          varchar(30),
	@papproved_flag     varchar(30),
	@ptaluka            varchar(30),
	@pstatecode         varchar(30),
    @pdistcode          varchar(30),
    @pbranchcode        varchar(30),
	@pdateformat        varchar(30),
	@pextra1            varchar(30),
	@pextra2            varchar(30)
as 
begin
	PRINT('1')
	declare       @v_frdt    varchar(30)
	declare       @v_todt    varchar(30)
	declare       @v_query1  varchar(8000)
	declare       @v_query2  varchar(8000)
	declare       @v_query3  varchar(8000)
	declare       @v_query4  varchar(8000)

	declare       @vvar       varchar(4000)
	declare       @vvar1      varchar(4000)
	declare       @vtot_publ  varchar(2000)
	declare       @v_cnt      int
	declare       @publ_code varchar(4000)
	declare       @publ_name varchar(4000)
	PRINT('2')
	if (@ppubl is null ) begin
		set @ppubl = ''
	end

	if (@pmainedtn is null)begin
		set @pmainedtn = ''
	end

	if (@pedtn is null) begin
		set @pedtn = ''
	end

	if (@pagcode is null) begin
		set @pagcode = ''
	end

	if (@pdepocode is null) begin
		set @pdepocode = ''
	end

	if (@papproved_flag is null) begin
		set @papproved_flag = ''
	end

	if (@ptaluka is null)begin
		set @ptaluka = ''
	end

	if (@pextra1 is null) begin
		set @pextra1 = ''
	end

	if (@pextra2 is null)begin
		set @pextra2 = ''
	end
	PRINT('3')
	set @v_frdt=dbo.convert_user_date('/', @pfromdate,@pdateformat)
	set @v_todt=dbo.convert_user_date('/',@ptilldate,@pdateformat)
	PRINT('4')PRINT(@v_frdt)PRINT(@v_todt)
	
	declare cur_publ cursor  for 
      select distinct u.publ publ,u.publ_name publ_name from 
      (select distinct p.publ publ,p.publ_name publ_name from cir_publ_mast p,cir_agmast a,cir_unsold_dtl b
       where b.comp_code    =a.comp_code and b.comp_code    =p.comp_code and b.comp_code = @pcomp_code and 
            b.unit_code=a.unit and (b.unit_code=@punit_code OR @punit_code IS NULL OR @punit_code='') and 
           b.doctype=@pdoc_type and b.recptdt between @v_frdt and @v_todt and 
           b.publ=p.publ and (b.publ=@ppubl OR @ppubl IS NULL OR @ppubl='') and 
           a.agcd=b.agcd and (b.agcd=@pagcode OR @pagcode IS NULL OR @pagcode='') and a.dpcd=b.dpcd and (b.dpcd=@pdepocode OR @pdepocode IS NULL OR @pdepocode='') and 
           (a.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka='') and
           (a.state_code=@pstatecode or @pstatecode is null or @pstatecode='') and (a.dist_code=@pdistcode or @pdistcode is null or @pdistcode='') and
           (a.branch_code=@pbranchcode or @pbranchcode is null or @pbranchcode='') and
           (upper(isnull(@papproved_flag,'N'))='Y' and (isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0))>0)
       UNION
       select distinct p.publ publ,p.publ_name publ_name from cir_publ_mast p,cir_agmast a,cir_unsold_dtl b
       where b.comp_code    =a.comp_code and b.comp_code    =p.comp_code and b.comp_code = @pcomp_code and 
            b.unit_code=a.unit and (b.unit_code=@punit_code OR @punit_code IS NULL OR @punit_code='') and 
           b.doctype=@pdoc_type and b.recptdt between @v_frdt and @v_todt and 
           b.publ=p.publ and (b.publ=@ppubl OR @ppubl IS NULL OR @ppubl='') and 
           a.agcd=b.agcd and (b.agcd=@pagcode OR @pagcode IS NULL OR @pagcode='') and a.dpcd=b.dpcd and (b.dpcd=@pdepocode OR @pdepocode IS NULL OR @pdepocode='') and 
           (a.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka='') and
           (a.state_code=@pstatecode or @pstatecode is null or @pstatecode='') and (a.dist_code=@pdistcode or @pdistcode is null or @pdistcode='') and
           (a.branch_code=@pbranchcode or @pbranchcode is null or @pbranchcode='') and
           (upper(isnull(@papproved_flag,'N'))='N' and (isnull(b.short_recpt,0)+isnull(b.late_recpt,0)+isnull(b.bnr,0)+isnull(b.unsold,0))>0))u
           order by publ
		PRINT('5')    
	open cur_publ
	fetch NEXT from cur_publ into @publ_code,@publ_name
		while(@@fetch_status=0) Begin
			set  @v_cnt =isnull(@v_cnt,0)+1
			if @vvar is null begin

				set @vvar        ='case u.publ when '+''''+@publ_code+''''+' then '+''''+@publ_name+''''+' end as "'+@publ_name+'",case u.publ when '+''''+@publ_code+''''+' then sum(u.supply_copy) end as "'+@publ_code+'_SUPPLY"'
				set @vvar        = COALESCE(@vvar+'', SPACE(0)) +  COALESCE(',case u.publ when '+''''+@publ_code+''''+' then sum(u.return_copy) end as "'+@publ_code+'_RETURN"'+ '', SPACE(0))
				set @vvar        =COALESCE(@vvar+'', SPACE(0)) + COALESCE(',round((case u.publ when '+''''+@publ_code+''''+' then sum(u.return_copy) end *100)/case u.publ when '+''''+@publ_code+''''+' then sum(u.supply_copy) end ,2) as "'+@publ_code+'_RETURN_PER"'+ '', SPACE(0))
				set @vvar1       ='sum("'+@publ_code+'_SUPPLY") "'+@publ_code+'_SUPPLY",sum("'+@publ_code+'_RETURN") "'+@publ_code+'_RETURN",sum("'+@publ_code+'_RETURN_PER") "'+@publ_code+'_RETURN_PER"'
				set @vtot_publ = @publ_name;
			 end
			else
			 begin
				set @vvar        =COALESCE(@vvar+'', SPACE(0)) + COALESCE('case u.publ when '+''''+@publ_code+''''+' then '+''''+@publ_name+''''+' end as "'+@publ_name+'",case u.publ when '+''''+@publ_code+''''+' then sum(u.supply_copy) end as "'+@publ_code+'_SUPPLY"' + '', SPACE(0))
				set @vvar        = COALESCE(@vvar+'', SPACE(0)) + COALESCE(',case u.publ when '+''''+@publ_code+''''+' then sum(u.return_copy) end as "'+@publ_code+'_RETURN"' + '', SPACE(0))
				set @vvar        =COALESCE(@vvar+'', SPACE(0)) + COALESCE(',round((case u.publ when '+''''+@publ_code+''''+' then sum(u.return_copy) end *100)/case u.publ when '+''''+@publ_code+''''+' then sum(u.supply_copy) end ,2) as "'+@publ_code+'_RETURN_PER"' + '', SPACE(0))
				set @vvar1       =COALESCE(@vvar1+'', SPACE(0)) + COALESCE('sum("'+@publ_code+'_SUPPLY") "'+@publ_code+'_SUPPLY",sum("'+@publ_code+'_RETURN") "'+@publ_code+'_RETURN",sum("'+@publ_code+'_RETURN_PER") "'+@publ_code+'_RETURN_PER"' + '', SPACE(0))
				set @vtot_publ =  COALESCE(@vtot_publ+'', SPACE(0)) + COALESCE(@publ_name+'', SPACE(0)) ;
			 end
		fetch NEXT from cur_publ into @publ_code,@publ_name
	end 
	close cur_publ
	PRINT('6')
	print (@vvar)
	print('shachi')
	print (@vvar1)

	if @vvar is not null and @vvar1 is not null 
		begin
           If upper(isnull(@papproved_flag,'N'))='Y' 
			begin  
                    print('shachi1234')
					set @v_query1='select j.comp_code,j.unit_code,j.agcd,j.dpcd,j.agname,j.agname_oth_lang,j.city_name,j.taluka_name,'+@vvar1 +' from (select u.comp_code comp_code,u.unit_code unit_code,
					u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,isnull(dbo.cir_get_city_name(u.comp_code,u.city_code),''NA'') 
					city_name,isnull(dbo.cir_get_taluka(u.comp_code,u.taluka_code),''NA'') taluka_name,u.publ publ,dbo.cir_get_publ_name(comp_code,publ) 
					publ_name,'+@vvar+ ' from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.agcd agcd,b.dpcd dpcd,a.ag_name agname,	a.ag_name_oth_lang agname_oth_lang,a.city_code city_code,a.tehsil_taluka taluka_code,(select sum(sup_copy) from cir_dbksup 
					where comp_code=b.comp_code and unit_code=b.unit_code and agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
					isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0) return_copy from cir_agmast a,cir_unsold_dtl b
					where b.comp_code    =a.comp_code and b.comp_code    ='+''''+@pcomp_code+''''+' and b.unit_code=a.unit and b.unit_code='+''''+@punit_code+''''+' and 
					b.doctype='+''''+@pdoc_type+''''+' and b.recptdt between '+''''+@v_frdt+''''+' and '+''''+@v_todt+''''+' and (b.publ='''+@ppubl+''' or '''+@ppubl+''' is null or '''+@ppubl+'''='''') and
					a.agcd=b.agcd and a.dpcd=b.dpcd and (b.agcd='''+@pagcode+''' or '''+@pagcode+''' is null or '''+@pagcode+''' ='''') and (b.dpcd='''+@pdepocode+''' or '''+@pdepocode+''' is null or '''+@pdepocode+''' ='''')
					and (a.tehsil_taluka='''+@ptaluka+''' or '''+@ptaluka+''' is null or '''+@ptaluka+'''='''') and (a.state_code='''+@pstatecode+''' or '''+@pstatecode+''' is null or '''+@pstatecode+'''='''') and 
					(a.dist_code='''+@pdistcode+''' or '''+@pdistcode+''' is null or '''+@pdistcode+'''='''') and (a.branch_code='''+@pbranchcode+''' or '''+@pbranchcode+''' is null or '''+@pbranchcode+'''='''') and 
					(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and
					b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='+''''+@pcomp_code+''''+' and (edtn = '+''''+@pedtn+''' or '''+@pedtn+''''+' is null or '''+@pedtn+'''='''') and 
					(main_edtn='+''''+@pmainedtn+''' or '''+@pmainedtn+''' is null or '''+@pmainedtn+''' =''''))) u	where u.supply_copy>0 
					group by u.comp_code,u.unit_code,u.publ,u.agcd,u.dpcd,u.agname
					,u.agname_oth_lang
					,isnull(dbo.cir_get_city_name(u.comp_code,u.city_code),''NA'') 
					,isnull(dbo.cir_get_taluka(u.comp_code,u.taluka_code),''NA'')
					,dbo.cir_get_publ_name(comp_code,publ) ) j
					group by j.comp_code,j.unit_code,j.agcd,j.dpcd,j.agname,j.agname_oth_lang,j.city_name,j.taluka_name 
					order by j.comp_code,j.unit_code,j.taluka_name,j.agname';
print('67')
print(@v_query1)
             set  @v_query2='select j.comp_code,j.unit_code,j.taluka_name,'+@vvar1 +' from (select u.comp_code comp_code,u.unit_code unit_code,
						u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,isnull(dbo.cir_get_city_name(u.comp_code,u.city_code),''NA'') 
						city_name,isnull(dbo.cir_get_taluka(u.comp_code,u.taluka_code),''NA'') taluka_name,u.publ publ,dbo.cir_get_publ_name(comp_code,publ) 
						publ_name,'+@vvar+'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.agcd agcd,b.dpcd dpcd,a.ag_name agname,
						a.ag_name_oth_lang agname_oth_lang,a.city_code city_code,a.tehsil_taluka taluka_code,(select sum(sup_copy) from cir_dbksup 
						where comp_code=b.comp_code and unit_code=b.unit_code and agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
						isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0) return_copy from cir_agmast a,cir_unsold_dtl b
						where b.comp_code    =a.comp_code and b.comp_code    ='+''''+@pcomp_code+''''+' and b.unit_code=a.unit and b.unit_code='+''''+@punit_code+''''+' and 
						b.doctype='+''''+@pdoc_type+''''+' and b.recptdt between '+''''+@v_frdt+''''+' and '+''''+@v_todt+''''+' and (b.publ='''+@ppubl+''' or '''+@ppubl+''' is null or '''+@ppubl+'''='''') and 
						a.agcd=b.agcd and a.dpcd=b.dpcd and (b.agcd='''+@pagcode+''' or '''+@pagcode+''' is null or '''+@pagcode+''' ='''') and (b.dpcd='''+@pdepocode+''' or '''+@pdepocode+''' is null or '''+@pdepocode+''' ='''') 
						and (a.tehsil_taluka='''+@ptaluka+''' or '''+@ptaluka+''' is null or '''+@ptaluka+'''='''') and 
						(a.state_code='''+@pstatecode+''' or '''+@pstatecode+''' is null or '''+@pstatecode+'''='''') and 
						(a.dist_code='''+@pdistcode+''' or '''+@pdistcode+''' is null or '''+@pdistcode+'''='''') and (a.branch_code='''+@pbranchcode+''' or '''+@pbranchcode+''' is null or '''+@pbranchcode+'''='''') and 
						(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and
						b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='+''''+@pcomp_code+''''+' and (edtn = '+''''+@pedtn+''' or '''+@pedtn+''''+' is null or '''+@pedtn+'''='''') and 
						(main_edtn='+''''+@pmainedtn+''' or '''+@pmainedtn+''' is null or '''+@pmainedtn+''' =''''))) u	where u.supply_copy>0 
                               group by u.comp_code,u.unit_code,u.publ,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,u.city_code,isnull(dbo.cir_get_taluka(u.comp_code,u.taluka_code),''NA'')) j
                               group by j.comp_code,j.unit_code,j.taluka_name
                               order by j.comp_code,j.unit_code,j.taluka_name';

					set @v_query3='select j.comp_code,j.unit_code,'+@vvar1 +' from (select u.comp_code comp_code,u.unit_code unit_code,
						u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,isnull(dbo.cir_get_city_name(u.comp_code,u.city_code),''NA'') 
						city_name,isnull(dbo.cir_get_taluka(u.comp_code,u.taluka_code),''NA'') taluka_name,u.publ publ,dbo.cir_get_publ_name(comp_code,publ) 
						publ_name,'+@vvar+'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.agcd agcd,b.dpcd dpcd,a.ag_name agname,
						a.ag_name_oth_lang agname_oth_lang,a.city_code city_code,a.tehsil_taluka taluka_code,(select sum(sup_copy) from cir_dbksup 
						where comp_code=b.comp_code and unit_code=b.unit_code and agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
						isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0) return_copy from cir_agmast a,cir_unsold_dtl b
						where b.comp_code    =a.comp_code and b.comp_code    ='+''''+@pcomp_code+''''+' and b.unit_code=a.unit and b.unit_code='+''''+@punit_code+''''+' and 
						b.doctype='+''''+@pdoc_type+''''+' and b.recptdt between '+''''+@v_frdt+''''+' and '+''''+@v_todt+''''+' and (b.publ='''+@ppubl+''' or '''+@ppubl+''' is null or '''+@ppubl+'''='''') and 
						a.agcd=b.agcd and a.dpcd=b.dpcd and (b.agcd='''+@pagcode+''' or '''+@pagcode+''' is null or '''+@pagcode+''' ='''') and (b.dpcd='''+@pdepocode+''' or '''+@pdepocode+''' is null or '''+@pdepocode+''' ='''') 
						and (a.tehsil_taluka='''+@ptaluka+''' or '''+@ptaluka+''' is null or '''+@ptaluka+'''='''') and 
						(a.state_code='''+@pstatecode+''' or '''+@pstatecode+''' is null or '''+@pstatecode+'''='''') and 
						(a.dist_code='''+@pdistcode+''' or '''+@pdistcode+''' is null or '''+@pdistcode+'''='''') and (a.branch_code='''+@pbranchcode+''' or '''+@pbranchcode+''' is null or '''+@pbranchcode+'''='''') and 
						(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and
						b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='+''''+@pcomp_code+''''+' and (edtn = '+''''+@pedtn+''' or '''+@pedtn+''''+' is null or '''+@pedtn+'''='''') and 
						(main_edtn='+''''+@pmainedtn+''' or '''+@pmainedtn+''' is null or '''+@pmainedtn+''' =''''))) u	where u.supply_copy>0 
                               group by u.comp_code,u.unit_code,u.publ,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,u.city_code,u.taluka_code) j
                               group by j.comp_code,j.unit_code 
                               order by j.comp_code,j.unit_code';


				end
				else
					begin
						if @vvar1 is not null begin

				set @v_query1='select j.comp_code,j.unit_code,j.agcd,j.dpcd,j.agname,j.agname_oth_lang,j.city_name,j.taluka_name,'+@vvar1 +' from (select u.comp_code comp_code,u.unit_code unit_code,
						u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,isnull(dbo.cir_get_city_name(u.comp_code,u.city_code),''NA'') 
						city_name,isnull(dbo.cir_get_taluka(u.comp_code,u.taluka_code),''NA'') taluka_name,u.publ publ,dbo.cir_get_publ_name(comp_code,publ) 
						publ_name,'+@vvar+'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.agcd agcd,b.dpcd dpcd,a.ag_name agname,
						a.ag_name_oth_lang agname_oth_lang,a.city_code city_code,a.tehsil_taluka taluka_code,(select sum(sup_copy) from cir_dbksup 
						where comp_code=b.comp_code and unit_code=b.unit_code and agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
						isnull(b.short_recpt,0)+isnull(b.late_recpt,0)+isnull(b.bnr,0)+isnull(b.unsold,0) return_copy from cir_agmast a,cir_unsold_dtl b
						where b.comp_code    =a.comp_code and b.comp_code    ='+''''+@pcomp_code+''''+' and b.unit_code=a.unit and b.unit_code='+''''+@punit_code+''''+' and 
						b.doctype='+''''+@pdoc_type+''''+' and b.recptdt between '+''''+@v_frdt+''''+' and '+''''+@v_todt+''''+' and (b.publ='''+@ppubl+''' or '''+@ppubl+''' is null or '''+@ppubl+'''='''') and 
						a.agcd=b.agcd and a.dpcd=b.dpcd and (b.agcd='''+@pagcode+''' or '''+@pagcode+''' is null or '''+@pagcode+''' ='''') and (b.dpcd='''+@pdepocode+''' or '''+@pdepocode+''' is null or '''+@pdepocode+''' ='''') 
						and (a.tehsil_taluka='''+@ptaluka+''' or '''+@ptaluka+''' is null or '''+@ptaluka+'''='''') and 
						(a.state_code='''+@pstatecode+''' or '''+@pstatecode+''' is null or '''+@pstatecode+'''='''') and 
						(a.dist_code='''+@pdistcode+''' or '''+@pdistcode+''' is null or '''+@pdistcode+'''='''') and (a.branch_code='''+@pbranchcode+''' or '''+@pbranchcode+''' is null or '''+@pbranchcode+'''='''') and 
						(isnull(short_recpt,0)+isnull(late_recpt,0)+isnull(bnr,0)+isnull(unsold,0))>0 and
						b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='+''''+@pcomp_code+''''+' and (edtn = '+''''+@pedtn+''' or '''+@pedtn+''''+' is null or '''+@pedtn+'''='''') and 
						(main_edtn='+''''+@pmainedtn+''' or '''+@pmainedtn+''' is null or '''+@pmainedtn+''' =''''))) u	where u.supply_copy>0 
						group by u.comp_code,u.unit_code,u.publ,u.agcd,u.dpcd,u.agname
						,u.agname_oth_lang
						,isnull(dbo.cir_get_city_name(u.comp_code,u.city_code),''NA'') 
						,isnull(dbo.cir_get_taluka(u.comp_code,u.taluka_code),''NA'')
						,dbo.cir_get_publ_name(comp_code,publ) ) j
						group by j.comp_code,j.unit_code,j.agcd,j.dpcd,j.agname,j.agname_oth_lang,j.city_name,j.taluka_name 
						order by j.comp_code,j.unit_code,j.taluka_name,j.agname';

             set  @v_query2='select j.comp_code,j.unit_code,j.taluka_name,'+@vvar1 +' from (select u.comp_code comp_code,u.unit_code unit_code,
						u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,isnull(dbo.cir_get_city_name(u.comp_code,u.city_code),''NA'') 
						city_name,isnull(dbo.cir_get_taluka(u.comp_code,u.taluka_code),''NA'') taluka_name,u.publ publ,dbo.cir_get_publ_name(comp_code,publ) 
						publ_name,'+@vvar+'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.agcd agcd,b.dpcd dpcd,a.ag_name agname,
						a.ag_name_oth_lang agname_oth_lang,a.city_code city_code,a.tehsil_taluka taluka_code,(select sum(sup_copy) from cir_dbksup 
						where comp_code=b.comp_code and unit_code=b.unit_code and agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
						isnull(b.short_recpt,0)+isnull(b.late_recpt,0)+isnull(b.bnr,0)+isnull(b.unsold,0) return_copy from cir_agmast a,cir_unsold_dtl b
						where b.comp_code    =a.comp_code and b.comp_code    ='+''''+@pcomp_code+''''+' and b.unit_code=a.unit and b.unit_code='+''''+@punit_code+''''+' and 
						b.doctype='+''''+@pdoc_type+''''+' and b.recptdt between '+''''+@v_frdt+''''+' and '+''''+@v_todt+''''+' and (b.publ='''+@ppubl+''' or '''+@ppubl+''' is null or '''+@ppubl+'''='''') and 
						a.agcd=b.agcd and a.dpcd=b.dpcd and (b.agcd='''+@pagcode+''' or '''+@pagcode+''' is null or '''+@pagcode+''' ='''') and (b.dpcd='''+@pdepocode+''' or '''+@pdepocode+''' is null or '''+@pdepocode+''' ='''') 
						and (a.tehsil_taluka='''+@ptaluka+''' or '''+@ptaluka+''' is null or '''+@ptaluka+'''='''') and 
						(a.state_code='''+@pstatecode+''' or '''+@pstatecode+''' is null or '''+@pstatecode+'''='''') and 
						(a.dist_code='''+@pdistcode+''' or '''+@pdistcode+''' is null or '''+@pdistcode+'''='''') and (a.branch_code='''+@pbranchcode+''' or '''+@pbranchcode+''' is null or '''+@pbranchcode+'''='''') and 
						(isnull(short_recpt,0)+isnull(late_recpt,0)+isnull(bnr,0)+isnull(unsold,0))>0 and
						b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='+''''+@pcomp_code+''''+' and (edtn = '+''''+@pedtn+''' or '''+@pedtn+''''+' is null or '''+@pedtn+'''='''') and 
						(main_edtn='+''''+@pmainedtn+''' or '''+@pmainedtn+''' is null or '''+@pmainedtn+''' =''''))) u	where u.supply_copy>0 
                               group by u.comp_code,u.unit_code,u.publ,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,u.city_code,isnull(dbo.cir_get_taluka(u.comp_code,u.taluka_code),''NA'')) j
                               group by j.comp_code,j.unit_code,j.taluka_name
                               order by j.comp_code,j.unit_code,j.taluka_name';

					set @v_query3='select j.comp_code,j.unit_code,'+@vvar1 +' from (select u.comp_code comp_code,u.unit_code unit_code,
						u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,isnull(dbo.cir_get_city_name(u.comp_code,u.city_code),''NA'') 
						city_name,isnull(dbo.cir_get_taluka(u.comp_code,u.taluka_code),''NA'') taluka_name,u.publ publ,dbo.cir_get_publ_name(comp_code,publ) 
						publ_name,'+@vvar+'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.agcd agcd,b.dpcd dpcd,a.ag_name agname,
						a.ag_name_oth_lang agname_oth_lang,a.city_code city_code,a.tehsil_taluka taluka_code,(select sum(sup_copy) from cir_dbksup 
						where comp_code=b.comp_code and unit_code=b.unit_code and agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
						isnull(b.short_recpt,0)+isnull(b.late_recpt,0)+isnull(b.bnr,0)+isnull(b.unsold,0) return_copy from cir_agmast a,cir_unsold_dtl b
						where b.comp_code    =a.comp_code and b.comp_code    ='+''''+@pcomp_code+''''+' and b.unit_code=a.unit and b.unit_code='+''''+@punit_code+''''+' and 
						b.doctype='+''''+@pdoc_type+''''+' and b.recptdt between '+''''+@v_frdt+''''+' and '+''''+@v_todt+''''+' and (b.publ='''+@ppubl+''' or '''+@ppubl+''' is null or '''+@ppubl+'''='''') and 
						a.agcd=b.agcd and a.dpcd=b.dpcd and (b.agcd='''+@pagcode+''' or '''+@pagcode+''' is null or '''+@pagcode+''' ='''') and (b.dpcd='''+@pdepocode+''' or '''+@pdepocode+''' is null or '''+@pdepocode+''' ='''') 
						and (a.tehsil_taluka='''+@ptaluka+''' or '''+@ptaluka+''' is null or '''+@ptaluka+'''='''') and 
						(a.state_code='''+@pstatecode+''' or '''+@pstatecode+''' is null or '''+@pstatecode+'''='''') and 
						(a.dist_code='''+@pdistcode+''' or '''+@pdistcode+''' is null or '''+@pdistcode+'''='''') and (a.branch_code='''+@pbranchcode+''' or '''+@pbranchcode+''' is null or '''+@pbranchcode+'''='''') and 
						(isnull(short_recpt,0)+isnull(late_recpt,0)+isnull(bnr,0)+isnull(unsold,0))>0 and
						b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='+''''+@pcomp_code+''''+' and (edtn = '+''''+@pedtn+''' or '''+@pedtn+''''+' is null or '''+@pedtn+'''='''') and 
						(main_edtn='+''''+@pmainedtn+''' or '''+@pmainedtn+''' is null or '''+@pmainedtn+''' =''''))) u	where u.supply_copy>0 
                               group by u.comp_code,u.unit_code,u.publ,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,u.city_code,u.taluka_code) j
                               group by j.comp_code,j.unit_code 
                               order by j.comp_code,j.unit_code';

					
				 end
				end
			set @v_query4='select '+''''+@vtot_publ+'''';
			end

	print('451111')
	print(@v_query1)

--print (@v_query2)
--print (@v_query3)
--print (@v_query4)


			exec (@v_query1)

exec (@v_query2)
exec (@v_query3)
exec (@v_query4)
deallocate cur_publ
end




///////////////////////////////////////end of issue/////////////////////////////////////////////


//////////////////issue no - 5397/////////////////////////////////////////////
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER PROCEDURE [dbo].[Cir_Gen_Code_receipt_p]
    @pcompcode                                VARCHAR(4000) ,
    @pbranchcode                              VARCHAR(4000) ,
    @pdoctype                                 VARCHAR(4000) ,
    @precptdt                                 VARCHAR(4000) ,
    @pdateformat                              VARCHAR(4000) ,
    @pextra1                                  VARCHAR(4000) ,
    @pextra2                                  VARCHAR(4000) 
AS 
        DECLARE @vno                                      NUMERIC(20) 
        DECLARE @vrecptno                                 VARCHAR(15) 
        DECLARE @v_dt                                     DATETIME 
        DECLARE @v_sess_id                                NUMERIC(20) 

        set @v_sess_id=(SELECT top 1 session_id  FROM sys.dm_exec_requests where sql_handle is not null);
        
        SET @v_dt  =   dbo.convert_user_date('/', @precptdt,@pdateformat) 
        if UPPER(@pextra2)='D'
			begin
				SELECT @vno  =  CONVERT(NUMERIC(8, 2), MAX(SUBSTRING(recptno, 5, 8))) + 1
				FROM  cir_rcphdr_dis 
				WHERE     comp_code  = @pcompcode
				 AND    doctype  = @pdoctype
				 AND    CONVERT(VARCHAR(23), recptdt)  = CONVERT(VARCHAR(23), @v_dt)
				 AND    branch_code  = @pbranchcode
			end
        else
			begin
				SELECT @vno  =  CAST( MAX(SUBSTRING(recptno, 5, 8))AS NUMERIC) + 1--CONVERT(NUMERIC(8, 2), MAX(SUBSTRING(recptno, 5, 8))) + 1
				FROM  cir_rcphdr 
				WHERE comp_code  = @pcompcode
				AND doctype  = @pdoctype
				AND  CONVERT(VARCHAR(23), recptdt)  = CONVERT(VARCHAR(23), @v_dt)
				AND  branch_code  = @pbranchcode
			end
        
        IF ISNULL(@vno, 0)= 0 
			BEGIN 
				SET @vrecptno  = @pbranchcode + '-' + REPLACE(CONVERT(VARCHAR(5), GETDATE(), 2), '.', '')+ '0001' 
			END
        ELSE
			BEGIN 
				SET @vrecptno  = @pbranchcode + '-' + dbo.fnPadLeft('0',8,@vno) 
			END
   
        SELECT @vrecptno as VAR_CODE


/////////////////////////////////////end of issue////////////////////////////////////////////




//=============================================03/11/2011 issue no.5011,4868,4691,5389********************************/


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER PROCEDURE [dbo].[Cir_Gen_Code_receipt_p]
    @pcompcode                                VARCHAR(4000) ,
    @pbranchcode                              VARCHAR(4000) ,
    @pdoctype                                 VARCHAR(4000) ,
    @precptdt                                 VARCHAR(4000) ,
    @pdateformat                              VARCHAR(4000) ,
    @pextra1                                  VARCHAR(4000) ,
    @pextra2                                  VARCHAR(4000) 
AS 
        DECLARE @vno                                      NUMERIC(20) 
        DECLARE @vrecptno                                 VARCHAR(15) 
        DECLARE @v_dt                                     DATETIME 
        DECLARE @v_sess_id                                NUMERIC(20) 

        set @v_sess_id=(SELECT top 1 session_id  FROM sys.dm_exec_requests where sql_handle is not null);
        
        SET @v_dt  =   dbo.convert_user_date('/', @precptdt,@pdateformat) 
        if UPPER(@pextra2)='D'
			begin
				SELECT @vno  =  CONVERT(NUMERIC(8, 2), MAX(SUBSTRING(recptno, 5, 8))) + 1
				FROM  cir_rcphdr_dis 
				WHERE     comp_code  = @pcompcode
				 AND    doctype  = @pdoctype
				 AND    CONVERT(VARCHAR(23), recptdt)  = CONVERT(VARCHAR(23), @v_dt)
				 AND    branch_code  = @pbranchcode
			end
        else
			begin
				SELECT @vno  =  CAST( MAX(SUBSTRING(recptno, 5, 8))AS NUMERIC) + 1--CONVERT(NUMERIC(8, 2), MAX(SUBSTRING(recptno, 5, 8))) + 1
				FROM  cir_rcphdr 
				WHERE comp_code  = @pcompcode
				AND doctype  = @pdoctype
				AND  CONVERT(VARCHAR(23), recptdt)  = CONVERT(VARCHAR(23), @v_dt)
				AND  branch_code  = @pbranchcode
			end
        
        IF ISNULL(@vno, 0)= 0 
			BEGIN 
				SET @vrecptno  = @pbranchcode + '-' + REPLACE(CONVERT(VARCHAR(5), GETDATE(), 2), '.', '')+ '0001' 
			END
        ELSE
			BEGIN 
				SET @vrecptno  = @pbranchcode + '-' + dbo.fnPadLeft('0',8,@vno) 
			END
   
        SELECT @vrecptno as VAR_CODE


//============================================= end of issue no.5011,4868,4691,5389********************************/





//////////*************** START OF ISSUE NO. 0005380  SQL PRO ******************///****************//////




set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[cir_rep_lbl_prn_cir_rep_lbl_prn_bhaskar_p]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@proute                                   VARCHAR(20) ,
	@pagcd                                    VARCHAR(20) ,
	@pdpcd                                    VARCHAR(20) ,
	@plbldt                                   VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
		DECLARE @vdate      DATETIME 
     	SET @vdate  =  dbo.convert_user_date('/',@plbldt,@pdateformat)

		/*SELECT
				 cir_lblmast.*,
				 DBO.cir_get_mode_name(comp_code, route1) MODE_NAME
		FROM  cir_lblmast 
		WHERE	 comp_code  = @pcomp_code
		 AND	unit_code  = @punit_code
		 AND	lbl_dt  = CONVERT(DATETIME, @plbldt)
		 AND	((publ  = @ppubl)
		 OR	(@ppubl  is null))
		 AND	((ISNULL(edtn, edtn_1)  = @pedtn)
		 OR	(@pedtn  is null))
		 AND	ISNULL(edtn, edtn_1)  in
			(
		 	SELECT edtn
			FROM  cir_edtn_mast 
			WHERE	 comp_code  = @pcomp_code
			 AND	(unit_code  = @punit_code
			 OR	@punit_code  is null)
			 AND	((edtn  = @pedtn)
			 OR	(@pedtn  is null))
			 AND	(main_edtn  = @pmainedtn
			 OR	@pmainedtn  is null)
			)
		 AND	((route1  = @proute)
		 OR	(@proute  is null))
		 AND	((agcd  = @pagcd)
		 OR	(@pagcd  is null))
		 AND	((dpcd  = @pdpcd)
		 OR	(@pdpcd  is null))
		ORDER BY unit_code,
			 seq_no,
			 route1,
			 edtn,
			 agname */
		

select cir_lblmast.*,DBO.cir_get_mode_name(comp_code, route1) MODE_NAME,
          SUBSTRING(DBO.cir_get_name_cir_edtn(comp_code,unit_code,edtn  ,'1',@pdateformat,'',''),1,30) EDTN_NAME,
          (select distinct reg_no from cir_edtn_mast where comp_code = @pcomp_code and edtn=cir_lblmast.edtn_1) AS "REG_NO" 
           from cir_lblMAST
             where comp_code = @pcomp_code and 
                   unit_code = @punit_code and 
                   lbl_dt    =@vdate and 
                   ((publ    = @ppubl) or (@ppubl is null) or (@ppubl ='')) and 
                   ((isnull(edtn,edtn_1)    = @pedtn) or (@pedtn is null) or (@pedtn='')) and
                   isnull(edtn,edtn_1) in(select edtn from cir_edtn_mast where comp_code=@pcomp_code and 
                   (unit_code=@punit_code or @punit_code is null or @punit_code='') and ((edtn = @pedtn) or (@pedtn is null) or (@pedtn='')) and 
					(main_edtn=@pmainedtn or @pmainedtn is null) or @pmainedtn ='') and
                   ((route1   = @proute) or (@proute is null) or (@proute='')) and 
                   ((agcd    = @pagcd) or (@pagcd is null) or (@pagcd='')) and 
                   ((dpcd    = @pdpcd) or (@pdpcd is null) or (@pdpcd=''))
					ORDER BY unit_code,
								 seq_no,
								 route1,
								 edtn,
								 agname





//////////*************** END OF ISSUE NO. 0005380 ******************///****************///
/**********************Issue No.5518 Laxman****************/
  ALTER procedure cir_rep_unsold_stock_p
      @pcompcode          varchar(20),
      @punitcode          varchar(20),
      @pbrancode          varchar(20),
      @ppublcode          varchar(20),
      @pfromdt            datetime,
      @ptilldt            datetime,
      @pdateformat        varchar(20),
      @pextra1            varchar(200),
      @pextra2            varchar(200)
    As
	declare @v_frdt datetime;
        declare @v_todt datetime;
	declare @v1_publ	varchar(20)
	declare @v1_edtn	varchar(20)
	declare @v1_copy_rate	decimal(10,2)

        declare c1 cursor  for
        select z.publ publ,z.edtn edtn,z.copy_rate copy_rate from
        (select publ,edtn,copy_rate from cir_unsold_dtl 
        where comp_code= @pcompcode and unit_code= @punitcode and doctype='UCN' and recptdt <= @v_todt and 
        (publ= @ppublcode or @ppublcode is null) and branch_code=isnull(@pbrancode,branch_code) and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0
        group by publ,edtn,copy_rate
        union
        select publ_code publ,edtn_code edtn, edtn_rate copy_rate from cir_branch_return_det 
        where comp_code= @pcompcode and unit_code= @punitcode and recptdt <= @v_todt and branch_code=isnull(@pbrancode,branch_code) and
        (publ_code= @ppublcode or @ppublcode is null)
        group by publ_code,edtn_code,edtn_rate
        union
        select publ_code publ,edtn_code edtn, edtn_rate copy_rate from cir_return_sale_det
        where comp_code= @pcompcode and unit_code= @punitcode and recptdt <= @v_todt and branch_code=isnull(@pbrancode,branch_code) and
        (publ_code= @ppublcode or @ppublcode is null)
        union
        select publ,edtn,copy_rate from cir_unsold_dtl_dis--for company return  
        where comp_code= @pcompcode and unit_code= @punitcode and doctype='UCN' and recptdt <= @v_todt and 
        (publ= @ppublcode or @ppublcode is null) and branch_code=isnull(@pbrancode,branch_code) and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0
        group by publ,edtn,copy_rate
        union
        select publ_code publ,edtn_code edtn, edtn_rate copy_rate from cir_physical_ver_det
        where comp_code= @pcompcode and unit_code= @punitcode and recptdt <= @v_todt and branch_code=isnull(@pbrancode,branch_code) and
        (publ_code= @ppublcode or @ppublcode is null)
        union
        select a.publ publ,a.edtn edtn, a.sup_rate copy_rate from cir_dbksup_resale a,cir_agmast b 
        where a.comp_code= @pcompcode and a.comp_code=b.comp_code and a.unit_code= @punitcode and a.unit_code=b.unit and 
        (a.publ= @ppublcode or @ppublcode is null) and a.agcd=b.agcd and a.dpcd=b.dpcd and a.supdate <= @v_todt and isnull(a.return_copy_sale,'N')='Y' and b.branch_code=isnull(@pbrancode,branch_code))z
        order by publ,edtn,copy_rate

      declare @v_opbal_unsold   int
      declare @v_op_branch_rec  int
      declare @v_op_branch_trf  int
      declare @v_op_sale	int
      declare @v_op_resale	int 
      declare @v_op_comp_ret	int 
      declare @v_op_short_excess int
      declare @v_opbal		int
      
      declare @v_branch_rec_copy int 
      declare @v_branch_trf_copy int
      declare @v_unsold_copy	int
      declare @v_sale_copy	int 
      declare @v_resale_copy	int
      declare @v_comp_ret_copy	int
      declare @v_short_excess	int
    Begin
       set @v_frdt    = @pfromdt
       set @v_todt    = @ptilldt
        
	CREATE TABLE #CIR_TEMP_UNSOLD_STOCK
	(COMP_CODE      VARCHAR(8),
	 UNIT_CODE      VARCHAR(8),
	BRANCH_CODE    VARCHAR(8),
	PUBL_CODE      VARCHAR(8),
	EDTN_CODE      VARCHAR(8),
	ASON_DT        DATETIME,
	COPY_RATE      decimal(10,2),
	OPBAL          INT,
	UNSOLD_RETURN  INT,
	BRANCH_REC     INT,
	UNSOLD_SALE    INT,
	UNSOLD_RESALE  INT,
	COMP_RETURN    INT,
	BRANCH_TRAN    INT,
	SHORT_EXCESS   INT,
	SESS_ID        INT )
        
	open c1
            fetch NEXT FROM C1 INTO @v1_publ, @v1_edtn, @v1_copy_rate
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN

            
            set @v_opbal_unsold=0      set @v_op_branch_rec =0    set @v_op_branch_trf=0     set @v_op_sale=0
            set @v_op_resale=0         set @v_op_comp_ret   =0    set @v_op_short_excess=0   set @v_opbal=0
            set @v_branch_rec_copy=0   set @v_branch_trf_copy=0   set @v_unsold_copy=0       set @v_sale_copy=0
            set @v_resale_copy=0       set @v_comp_ret_copy =0    set @v_short_excess=0

            /*-------for opening balance ----------*/            
            select @v_opbal_unsold = isnull(sum(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)),0) 
            from cir_unsold_dtl 
            where comp_code = @pcompcode and unit_code = @punitcode and doctype='UCN' and recptdt < @v_frdt and publ=@v1_publ and edtn = @v1_edtn and
            copy_rate = @v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null)

            select @v_op_branch_rec=isnull(sum(edtn_copy),0) from cir_branch_return_det 
                where comp_code = @pcompcode and unit_code = @punitcode and doctype='TI' and recptdt<@v_frdt and
                publ_code=@v1_publ and edtn_code=@v1_edtn and edtn_rate=@v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null)

            select @v_op_branch_trf=isnull(sum(edtn_copy),0) from cir_branch_return_det 
                where comp_code = @pcompcode and unit_code = @punitcode and doctype='TRF' and recptdt<@v_frdt and
                publ_code=@v1_publ and edtn_code=@v1_edtn and edtn_rate=@v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null)
            
            select @v_op_sale=isnull(sum(no_of_copy),0) from cir_return_sale_det
                where comp_code = @pcompcode and unit_code = @punitcode and doctype='RET' and recptdt<@v_frdt and
                publ_code=@v1_publ and edtn_code=@v1_edtn and edtn_rate=@v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null)

            /*select isnull(sum(return_copy),0) into v_op_comp_ret from cir_company_return_det
                where comp_code = @pcompcode and unit_code = @punitcode and doctype='RET' and recptdt<@v_frdt and
                publ_code = @v_publ and edtn_code = @v1_edtn and edtn_rate = @v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null);*/

            select @v_op_comp_ret=isnull(sum(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)),0) 
            from cir_unsold_dtl_dis 
                where comp_code = @pcompcode and unit_code = @punitcode and doctype='UCN' and recptdt < @v_frdt and publ = @v1_publ and edtn = @v1_edtn and
                copy_rate = @v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null)
            
            select @v_op_resale=isnull(sum(sup_copy),0) from cir_dbksup_resale 
                where comp_code = @pcompcode and unit_code = @punitcode and publ = @v1_publ and edtn = @v1_edtn and
                      supdate < @v_frdt and sup_rate = @v1_copy_rate and isnull(return_copy_sale,'N')='Y'
            
            select @v_op_short_excess = isnull(sum(isnull(short_excess,1)*no_of_copy),0) from cir_physical_ver_det
                where comp_code = @pcompcode and unit_code = @punitcode and doctype='VR' and recptdt<@v_frdt and
                publ_code=@v1_publ and edtn_code=@v1_edtn and edtn_rate=@v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null)
            /*-------for opening balance ----------*/

            
            set @v_opbal=isnull(@v_opbal_unsold,0)+isnull(@v_op_branch_rec,0)-isnull(@v_op_branch_trf,0)-isnull(@v_op_sale,0)-isnull(@v_op_comp_ret,0)-isnull(@v_op_resale,0)+isnull(@v_op_short_excess,0);
            
            /*-------for Period from to till date----------*/    
            select @v_unsold_copy =isnull(sum(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)),0) 
            from cir_unsold_dtl 
            where comp_code = @pcompcode and unit_code = @punitcode and doctype='UCN' and recptdt >= @v_frdt and recptdt <= @v_todt and
             publ = @v1_publ and edtn=@v1_edtn and copy_rate = @v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null)
            
            select @v_branch_rec_copy=isnull(sum(edtn_copy),0) from cir_branch_return_det 
                where comp_code = @pcompcode and unit_code = @punitcode and doctype='TI' and recptdt >= @v_frdt and recptdt <= @v_todt and
                publ_code = @v1_publ and edtn_code = @v1_edtn and edtn_rate=@v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null)                   

            select @v_branch_trf_copy=isnull(sum(edtn_copy),0)  from cir_branch_return_det 
                where comp_code = @pcompcode and unit_code = @punitcode and doctype='TRF' and recptdt >= @v_frdt and recptdt <= @v_todt and
                publ_code = @v1_publ and edtn_code = @v1_edtn and edtn_rate = @v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null)

            select @v_sale_copy=isnull(sum(no_of_copy),0) from cir_return_sale_det
                where comp_code = @pcompcode and unit_code = @punitcode and doctype='RET' and recptdt >= @v_frdt and recptdt <= @v_todt and
                publ_code = @v1_publ and edtn_code = @v1_edtn and edtn_rate = @v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null)

            /*select isnull(sum(return_copy),0) into v_comp_ret_copy from cir_company_return_det
                where comp_code = @pcompcode and unit_code = @punitcode and doctype='RET' and recptdt >= @v_frdt and recptdt <= @v_todt and
                publ_code = @v1_publ and edtn_code = @v1_edtn and edtn_rate = @v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null)*/

            select @v_comp_ret_copy = isnull(sum(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)),0) 
            from cir_unsold_dtl_dis
                where comp_code = @pcompcode and unit_code = @punitcode and doctype='UCN' and recptdt >= @v_frdt and recptdt <= @v_todt and
                publ = @v1_publ and edtn = @v1_edtn and copy_rate = @v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null) 
                                         
            select @v_resale_copy=isnull(sum(sup_copy),0) from cir_dbksup_resale 
                where comp_code = @pcompcode and unit_code = @punitcode and publ = @v1_publ and edtn = @v1_edtn and
                      supdate >= @v_frdt and supdate >= @v_todt and sup_rate = @v1_copy_rate and isnull(return_copy_sale,'N')='Y'

            select @v_short_excess = isnull(sum(isnull(short_excess,1)*no_of_copy),0)  from cir_physical_ver_det
                where comp_code = @pcompcode and unit_code = @punitcode and doctype='VR' and recptdt >= @v_frdt and recptdt <= @v_todt and
                publ_code = @v1_publ and edtn_code = @v1_edtn and edtn_rate = @v1_copy_rate and (branch_code = @pbrancode or @pbrancode is null)

	    /*-------for Period from to till date----------*/                 
            if abs(isnull(@v_opbal,0))+isnull(@v_unsold_copy,0)+isnull(@v_branch_rec_copy,0)+isnull(@v_sale_copy,0)+isnull(@v_resale_copy,0)+isnull(@v_comp_ret_copy,0)+
                isnull(@v_branch_trf_copy,0)+abs(isnull(@v_short_excess,0))<>0 Begin

				insert into #cir_temp_unsold_stock(comp_code,unit_code,branch_code,publ_code,edtn_code,ason_dt,copy_rate,
						opbal,unsold_return,branch_rec,unsold_sale,unsold_resale,comp_return,branch_tran,short_excess)
                values(@pcompcode, @punitcode, @pbrancode, @v1_publ, @v1_edtn, @v_todt, @v1_copy_rate, @v_opbal, @v_unsold_copy, @v_branch_rec_copy,
						@v_sale_copy, @v_resale_copy, @v_comp_ret_copy, @v_branch_trf_copy, @v_short_excess)
            end
	    fetch NEXT FROM C1 INTO @v1_publ, @v1_edtn, @v1_copy_rate
        end
	close c1
	deallocate c1
        
        select a.comp_code comp_code,a.unit_code unit_code,a.branch_code branch_code,a.publ_code publ_code,dbo.cir_get_publ_seqno(a.comp_code,a.publ_code) publ_seqno,
        dbo.cir_get_name.cir_publ(a.comp_code,a.publ_code,'1',@pdateformat,'','') publ_name,
        b.main_edtn main_edtn_code,dbo.cir_get_edtn_seqno(a.comp_code,b.main_edtn) main_edtn_seqno,
        a.edtn_code edtn_code,dbo.cir_get_edtn_seqno(a.comp_code,a.edtn_code) edtn_seqno,dbo.cir_get_name.cir_edtn(a.comp_code,a.unit_code,a.edtn_code,'1',@pdateformat,'','') edtn_name,
        a.copy_rate copy_rate,
        a.opbal opbal,a.unsold_return unsold_return,a.branch_rec branch_rec,a.unsold_sale unsold_sale,
        isnull(a.opbal,0)+isnull(a.unsold_return,0)+isnull(a.branch_rec,0) tot,
        a.unsold_resale unsold_resale,a.comp_return comp_return,a.branch_tran branch_tran,
        ((isnull(a.opbal,0)+isnull(a.unsold_return,0)+isnull(a.branch_rec,0))-(isnull(a.unsold_sale,0)+isnull(a.unsold_resale,0)+isnull(a.comp_return,0)+isnull(a.branch_tran,0))) total_bal,
        a.short_excess short_excess,((isnull(a.opbal,0)+isnull(a.unsold_return,0)+isnull(a.branch_rec,0))-(isnull(a.unsold_sale,0)+isnull(a.unsold_resale,0)+isnull(a.comp_return,0)+isnull(a.branch_tran,0)))+isnull(a.short_excess,0) closing_bal 
        from #cir_temp_unsold_stock a,cir_edtn_mast b where a.comp_code=b.comp_code and a.edtn_code=b.edtn
        order by publ_seqno,publ_code,main_edtn_seqno,edtn_seqno,edtn_code,copy_rate
        
        drop table #cir_temp_unsold_stock

    End
/******************************Issue No. 5518*******************************/
/*********************Laxman*******************************/
CREATE FUNCTION cir_publ_type
(@pcomp_code     as varchar(20),
 @publ_type      as varchar(20),
 @pextra1        as varchar(20),
 @pextra2        as varchar(20)) RETURNs varchar(200) AS
    
BEGIN
	declare @v_name  varchar(200)

      select @v_name="pubname" from pub_type_mast  where "pubtypecode"=@publ_type

  return isnull(@v_name,'')
END

/*********************Laxman*******************************/




//==================================================== issue no.  5389=============================================


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER PROCEDURE [dbo].[add_col_in_table]
	@p_table                                  VARCHAR(4000) ,
	@p_col_name                               VARCHAR(4000) ,
	@p_type                                   VARCHAR(4000) ,
	@p_default                                VARCHAR(4000) 
AS 
	BEGIN
set nocount on
		
		DECLARE @l_str                                    VARCHAR(4000) 
		DECLARE @l_count                                  FLOAT 

		SELECT @l_count = COUNT(*) 
		FROM sys.tables AS t
		INNER JOIN sys.columns c ON t.OBJECT_ID = c.OBJECT_ID 
		WHERE t.name=UPPER(@p_table) AND
		c.name=UPPER(@p_col_name);

		IF @l_count = 0 
		BEGIN 
			IF @p_default is null 
			BEGIN 
				SELECT @l_str  = 'alter  table ' + @p_table + ' add ' + @p_col_name + ' ' + @p_type 
					 EXEC (@l_str)
				
			
			END
			ELSE
			BEGIN 
			
				SELECT @l_str  = 'alter  table ' + @p_table + ' add ' + @p_col_name + ' ' + @p_type + ' default ''' + @p_default + ''''
			 EXEC (@l_str)
			END
   
		END

set nocount off
	END




//====================================================================================================================



//==============================================07/11/2011 issue no. 4763=============================


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[cir_rep_supply_cir_dist_taluka_wise_sup]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@proute                                   VARCHAR(20) ,
	@pfrom_supdate                            DATETIME ,
	@ptill_supdate                            DATETIME,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(200) ,
	@pextra2                                  VARCHAR(200) 
AS 
if(@ppubl = '') begin
  set @ppubl = null
end
if(@pmainedtn = '')begin
  set @pmainedtn = null
end
if(@pedtn = '')begin
  set @pedtn = null
end
if(@proute = '')begin
  set @proute = null
end
if(@pextra1 = '')begin
  set @pextra1 = null
end
if(@pextra2 = '')begin
  set @pextra2 = null
end
		

	select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
	m.dist_code AS "DIST_CODE",dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) AS "DIST_NAME",
	m.tehsil_taluka AS "TEHSIL_TALUKA",dbo.cir_get_taluka(d.comp_code,m.tehsil_taluka) AS "TALUKA_NAME",
	d.agcd AS "AGCD",d.dpcd AS "DPCD",m.ag_name AS "AG_NAME",m.ag_name_oth_lang AS "AG_NAME_OTH_LANG",sum(d.sup_copy) AS "SUP_COPY",
	dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,2,null,null,null) AS "DIST_OTH_NAME",
	dbo.cir_get_name_cir_taluka(d.comp_code,m.tehsil_taluka,2,null,null,null) as "TALUKA_OTH_NAME", 
	dbo.cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",
	dbo.cir_get_name_cir_city(d.comp_code,m.city_code,2,null,null,null) as "CITY_ONAME",
	dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME",
	dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) as "DROP_POINT_ONAME"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
		 d.unit_code    = m.unit and
		 d.agcd         = m.agcd and
		 d.dpcd         = m.dpcd and
		 d.comp_code    = @pcomp_code and
		 d.unit_code    = @punit_code and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (m.tehsil_taluka = @proute or @proute is null) and
		 d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
	  group by d.comp_code,d.unit_code,m.dist_code,m.state_code,m.tehsil_taluka,
			   d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code
	  order by comp_code,unit_code,dist_name,taluka_name,ag_name,agcd,dpcd		
		
	
	select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
	m.dist_code AS "DIST_CODE",dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) AS "DIST_NAME",
	m.tehsil_taluka AS "TEHSIL_TALUKA",dbo.cir_get_taluka(d.comp_code,m.tehsil_taluka) AS "TALUKA_NAME",
	sum(d.sup_copy) AS "SUP_COPY",
	dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,2,null,null,null) AS "DIST_OTH_NAME",
	dbo.cir_get_name_cir_taluka(d.comp_code,m.tehsil_taluka,2,null,null,null) as "TALUKA_OTH_NAME"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
		 d.unit_code    = m.unit and
		 d.agcd         = m.agcd and
		 d.dpcd         = m.dpcd and
		 d.comp_code    = @pcomp_code and
		 d.unit_code    = @punit_code and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (m.tehsil_taluka = @proute or @proute is null) and
		 d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
	  group by d.comp_code,d.unit_code,m.dist_code,m.state_code,m.tehsil_taluka
	  order by comp_code,unit_code,dist_name,taluka_name
		
		
	select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
	m.dist_code AS "DIST_CODE",dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) AS "DIST_NAME",
	sum(d.sup_copy) AS "SUP_COPY",
	dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,2,null,null,null) AS "DIST_OTH_NAME"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
		 d.unit_code    = m.unit and
		 d.agcd         = m.agcd and
		 d.dpcd         = m.dpcd and
		 d.comp_code    = @pcomp_code and
		 d.unit_code    = @punit_code and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (m.tehsil_taluka = @proute or @proute is null) and
		 d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
	  group by d.comp_code,d.unit_code,m.dist_code,m.state_code
	  order by comp_code,unit_code,dist_name	
		
	select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",sum(d.sup_copy) AS "SUP_COPY"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
		 d.unit_code    = m.unit and
		 d.agcd         = m.agcd and
		 d.dpcd         = m.dpcd and
		 d.comp_code    = @pcomp_code and
		 d.unit_code    = @punit_code and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (m.tehsil_taluka = @proute or @proute is null) and
		 d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
	  group by d.comp_code,d.unit_code
	  order by comp_code,unit_code

	select d.comp_code as "COMP_CODE",sum(d.sup_copy) AS "SUP_COPY",max(sup_rate) as "COPY_RATE"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
		 d.unit_code    = m.unit and
		 d.agcd         = m.agcd and
		 d.dpcd         = m.dpcd and
		 d.comp_code    = @pcomp_code and
		 d.unit_code    = @punit_code and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (m.tehsil_taluka = @proute or @proute is null) and
		 d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
	  group by d.comp_code
	  order by comp_code

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[cir_rep_supply_cir_dist_wise_supply]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@proute                                   VARCHAR(20) ,
	@pfrom_supdate                            DATETIME,
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
	m.dist_code AS "DIST_CODE",dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) AS "DIST_NAME",
	d.agcd AS "AGCD",d.dpcd AS "DPCD",m.ag_name AS "AG_NAME",m.ag_name_oth_lang AS "AG_NAME_OTH_LANG",sum(d.sup_copy) AS "SUP_COPY",
	dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,2,null,null,null) AS "DIST_OTH_NAME", 
	dbo.cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",
	dbo.cir_get_name_cir_city(d.comp_code,m.city_code,2,null,null,null) as "CITY_ONAME",
	dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME",
	dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) as "DROP_POINT_ONAME"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
		 d.unit_code    = m.unit and
		 d.agcd         = m.agcd and
		 d.dpcd         = m.dpcd and
		 d.comp_code    = @pcomp_code and
		 d.unit_code    = @punit_code and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (m.dist_code = @proute or @proute is null) and
		 d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
	  group by d.comp_code,d.unit_code,m.dist_code,m.state_code,
			   d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code
	  order by comp_code,unit_code,dist_name,ag_name,agcd,dpcd;
		
	select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
		m.dist_code AS "DIST_CODE",dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) AS "DIST_NAME",
		sum(d.sup_copy) AS "SUP_COPY",
		dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,2,null,null,null) AS "DIST_OTH_NAME"
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e
		where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
			 d.unit_code    = m.unit and
			 d.agcd         = m.agcd and
			 d.dpcd         = m.dpcd and
			 d.comp_code    = @pcomp_code and
			 d.unit_code    = @punit_code and
			 d.publ         = e.publ and d.publ         = @ppubl and
			 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
			 (m.dist_code = @proute or @proute is null) and
			 d.supdate between @pfrom_supdate and @ptill_supdate and
			 (e.main_edtn=@pmainedtn or @pmainedtn is null)
		  group by d.comp_code,d.unit_code,m.dist_code,m.state_code
		  order by comp_code,unit_code,dist_name;
	
	select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",sum(d.sup_copy) AS "SUP_COPY"
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e
		where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
			 d.unit_code    = m.unit and
			 d.agcd         = m.agcd and
			 d.dpcd         = m.dpcd and
			 d.comp_code    = @pcomp_code and
			 d.unit_code    = @punit_code and
			 d.publ         = e.publ and d.publ         = @ppubl and
			 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
			 (m.dist_code = @proute or @proute is null) and
			 d.supdate between @pfrom_supdate and @ptill_supdate and
			 (e.main_edtn=@pmainedtn or @pmainedtn is null)
		  group by d.comp_code,d.unit_code
		  order by comp_code,unit_code;
		
	select d.comp_code as "COMP_CODE",sum(d.sup_copy) AS "SUP_COPY",max(sup_rate) as "COPY_RATE"
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e
		where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
			 d.unit_code    = m.unit and
			 d.agcd         = m.agcd and
			 d.dpcd         = m.dpcd and
			 d.comp_code    = @pcomp_code and
			 d.unit_code    = @punit_code and
			 d.publ         = e.publ and d.publ         = @ppubl and
			 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
			 (m.dist_code = @proute or @proute is null) and
			 d.supdate between @pfrom_supdate and @ptill_supdate and
			 (e.main_edtn=@pmainedtn or @pmainedtn is null)
		  group by d.comp_code
		  order by comp_code;
		




//////////////////////////////////////////////////////////////////////////////////////////////////////////////



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[cir_rep_supply_cir_route_wise_supply]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@proute                                   VARCHAR(20) ,
	@pfrom_supdate                            DATETIME ,
	@ptill_supdate                            DATETIME ,
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
	d.route_code AS "ROUTE_CODE",dbo.cir_get_route_name(d.comp_code,d.unit_code,d.route_code) AS "ROUTE_NAME",
	d.agcd AS "AGCD",d.dpcd AS "DPCD",m.ag_name AS "AG_NAME",m.ag_name_oth_lang AS "AG_NAME_OTH_LANG",sum(d.sup_copy) AS "SUP_COPY",
	dbo.cir_get_route_seqno(d.comp_code,d.unit_code,d.route_code) AS "ROUTE_SEQNO",
	dbo.cir_get_supply_seqno(d.comp_code,d.unit_code,@ppubl,@pedtn,d.agcd,d.dpcd) AS "SUPPLY_SEQNO",
	dbo.cir_get_name_cir_route(d.comp_code,d.unit_code,d.route_code,2,null,null,null) AS "ROUTE_OTH_NAME",
	dbo.cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",
	dbo.cir_get_name_cir_city(d.comp_code,m.city_code,2,null,null,null) as "CITY_ONAME",
	dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME",
	dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) as "DROP_POINT_ONAME"
	from cir_dbksup d,cir_agmast m,cir_edtn_mast e
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
		 d.unit_code    = m.unit and
		 d.agcd         = m.agcd and
		 d.dpcd         = m.dpcd and
		 d.comp_code    = @pcomp_code and
		 d.unit_code    = @punit_code and
		 d.publ         = e.publ and d.publ         = @ppubl and
		 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
		 (d.route_code = @proute or @proute is null) and
		 d.supdate between @pfrom_supdate and @ptill_supdate and
		 (e.main_edtn=@pmainedtn or @pmainedtn is null)
	  group by d.comp_code,d.unit_code,d.route_code,
			   d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code
	  order by d.comp_code,d.unit_code,route_seqno,d.route_code,supply_seqno ,d.agcd,d.dpcd
        
		select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
		d.route_code AS "ROUTE_CODE",dbo.cir_get_route_name(d.comp_code,d.unit_code,d.route_code) AS "ROUTE_NAME",
		sum(d.sup_copy) AS "SUP_COPY",
		dbo.cir_get_route_seqno(d.comp_code,d.unit_code,d.route_code) AS "ROUTE_SEQNO",
		dbo.cir_get_name_cir_route(d.comp_code,d.unit_code,d.route_code,2,null,null,null) AS "ROUTE_OTH_NAME"
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e
		where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
			 d.unit_code    = m.unit and
			 d.agcd         = m.agcd and
			 d.dpcd         = m.dpcd and
			 d.comp_code    = @pcomp_code and
			 d.unit_code    = @punit_code and
			 d.publ         = e.publ and d.publ         = @ppubl and
			 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
			 (d.route_code = @proute or @proute is null) and
			 d.supdate between @pfrom_supdate and @ptill_supdate and
			 (e.main_edtn=@pmainedtn or @pmainedtn is null)
		  group by d.comp_code,d.unit_code,d.route_code
		  order by d.comp_code,d.unit_code,route_seqno,d.route_code
		
		select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",sum(d.sup_copy) AS "SUP_COPY"
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e
			where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
				 d.unit_code    = m.unit and
				 d.agcd         = m.agcd and
				 d.dpcd         = m.dpcd and
				 d.comp_code    = @pcomp_code and
				 d.unit_code    = @punit_code and
				 d.publ         = e.publ and d.publ         = @ppubl and
				 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
				 (d.route_code = @proute or @proute is null) and
				 d.supdate between @pfrom_supdate and @ptill_supdate and
				 (e.main_edtn=@pmainedtn or @pmainedtn is null)
			  group by d.comp_code,d.unit_code
			  order by d.comp_code,d.unit_code
		
		select d.comp_code as "COMP_CODE",sum(d.sup_copy) AS "SUP_COPY",max(sup_rate) as "COPY_RATE"
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e
			where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
				 d.unit_code    = m.unit and
				 d.agcd         = m.agcd and
				 d.dpcd         = m.dpcd and
				 d.comp_code    = @pcomp_code and
				 d.unit_code    = @punit_code and
				 d.publ         = e.publ and d.publ         = @ppubl and
				 d.edtn=e.edtn and (d.edtn       = @pedtn or @pedtn is null) and
				 (d.route_code = @proute or @proute is null) and
				 d.supdate between @pfrom_supdate and @ptill_supdate and
				 (e.main_edtn=@pmainedtn or @pmainedtn is null)
			  group by d.comp_code
			  order by d.comp_code
		

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

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
	dbo.cir_get_name.cir_taluka(d.comp_code,m.tehsil_taluka,2,null,null,null) as "TALUKA_OTH_NAME", 
	dbo.cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",
	dbo.cir_get_name.cir_city(d.comp_code,m.city_code,2,null,null,null) as "CITY_ONAME",
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
	dbo.cir_get_name.cir_taluka(d.comp_code,m.tehsil_taluka,2,null,null,null) as "TALUKA_OTH_NAME"
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



//============================================== 07/11/2011 end of issue no. 4763=============================





//********************** Start Issue no. 4688 ************************//



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[cir_rep_supply_cir_rep_supply1]
	@pcomp_code                               VARCHAR(40) ,
	@punit_code                               VARCHAR(40) ,
	@ppubl                                    VARCHAR(40) ,
	@pmainedtn                                VARCHAR(40) ,
	@pedtn                                    VARCHAR(40) ,
	@proute                                   VARCHAR(40) ,
	@pfrom_supdate                            DATETIME ,
	@ptill_supdate                            DATETIME ,
	@pdateformat                              VARCHAR(40) ,
	@pextra1                                  VARCHAR(40) ,
	@pextra2                                  VARCHAR(40)
AS 
	BEGIN
		DECLARE @vfrom_supdate                            DATETIME 
		DECLARE @vtill_supdate                            DATETIME 

		DECLARE cur_sup_type cursor LOCAL FOR 
		SELECT 'SUM(CASE SUP_TYPE_CODE WHEN  '+''''+sup_ty_code+''''+' then sup_copy else ''0'' end) "'+sup_ty_name+'",' vty,
			'SUM(CASE SUP_TYPE_CODE	WHEN  '+''''+sup_ty_code+''''+' then sup_copy else ''0'' end) +' vty_sum
		FROM  cir_supply_type_mast 
		WHERE comp_code  = @pcomp_code 
		ORDER BY sup_seq_no 
		
		DECLARE @supply_type_name	VARCHAR(4000)
		DECLARE @supply_sum			VARCHAR(4000) 
		DECLARE @vvar               VARCHAR(4000) 
		DECLARE @vvar_sum           VARCHAR(4000) 
		DECLARE @vquery             VARCHAR(8000) 
		DECLARE @vquery1            VARCHAR(8000) 
		DECLARE @vquery2            VARCHAR(8000) 
		DECLARE @vquery3            VARCHAR(8000) 
		DECLARE @vquery4            VARCHAR(8000) 
		SET @vfrom_supdate  = @pfrom_supdate
		SET @vtill_supdate  = @ptill_supdate
		
		OPEN cur_sup_type 
		fetch NEXT FROM cur_sup_type INTO  @supply_type_name,@supply_sum
		while(@@FETCH_STATUS = 0)
		BEGIN
			set @vvar =COALESCE(@vvar+'', SPACE(0)) + '' + COALESCE(@supply_type_name + '', SPACE(0))
			set @vvar_sum=COALESCE(@vvar_sum+'', SPACE(0)) + '' + COALESCE(@supply_sum + '', SPACE(0))

		fetch NEXT from cur_sup_type INTO  @supply_type_name,@supply_sum
		end
		close cur_sup_type
		
		SET @vvar  = SUBSTRING(@vvar, 1, LEN(@vvar) - 1)
		SET @vvar_sum  = SUBSTRING(@vvar_sum, 1, LEN(@vvar_sum) - 1)
		
		/*SET @vquery  = ' select COMP_CODE,UNIT_CODE,PUBL,dbo.cir_get_publ_name(comp_code,publ) PUBL_NAME,EDTN,dbo.cir_get_edtn_name(comp_code,edtn) EDTN_NAME,ROUTE_CODE,dbo.cir_get_route_name(comp_code,unit_code,route_code) ROUTE_NAME,agcd "AGENCY CODE",dpcd "AGENCY SUBCODE",      substring(dbo.cir_get_agency(comp_code,unit_code,agcd,dpcd),1,50) "AGENCY NAME",substring(dbo.cir_get_name_cir_agname(comp_code,unit_code,agcd,dpcd,2,' + '''' + @pdateformat + '''' + ','''',''''),1,50) "AGENCY ONAME",(select dbo.cir_get_city(m.comp_code,m.city_code) city_name from cir_agmast m where m.comp_code=cir_dbksup.comp_code and m.unit=cir_dbksup.unit_code and m.agcd=cir_dbksup.agcd and m.dpcd=cir_dbksup.dpcd) "CITY NAME",      (select isnull(dbo.CIR_GET_NAME_CIR_CITY(m.comp_code,m.city_code,2,' + '''' + @pdateformat + '''' + ','''',''''),''NA'') city_name from cir_agmast m where m.comp_code=cir_dbksup.comp_code and m.unit=cir_dbksup.unit_code and m.agcd=cir_dbksup.agcd and m.dpcd=cir_dbksup.dpcd) "CITY ONAME",' + @vvar + ',' + @vvar_sum + ' TOTAL 
	from cir_dbksup where comp_code=' + '''' + @pcomp_code + '''' + ' and unit_code=' + '''' + @punit_code + '''' + ' and ((publ=' + '''' + @ppubl + '''' + ') or (' + '''' + @ppubl + '''' + ' is null) or (' + '''' + @ppubl + '''' + '=' + ''''+'''' +')) and 
	((edtn=' + '''' + @pedtn + '''' + ' ) or (' + '''' + @pedtn + '''' + ' is null) or (' + '''' + @pedtn + '''' + '=' + ''''+'''' +')) and supdate between' + '''' + convert(varchar(20),@pfrom_supdate,101) + '''' + ' and ' + '''' + convert(varchar(20),@ptill_supdate,101) + '''' + ' and 
	((route_code=' + '''' + @proute + '''' + ') or (' + '''' + @proute + '''' + ' is null) or (' + '''' + @proute + '''' + '=' + ''''+'''' +')) and edtn in(select distinct edtn from cir_edtn_mast where comp_code=' + '''' + @pcomp_code + '''' + ' and ((edtn =' + '''' + @pedtn + '''' + ') or (' + '''' + @pedtn + '''' + ' is null) or (' + '''' + @pedtn + '''' + '=' + ''''+'''' +')) and (main_edtn=' + '''' + @pmainedtn + '''' + ' or' + '''' + @pmainedtn + '''' + ' is null) or (' + '''' + @pmainedtn + '''' + '=' + ''''+'''' +'))  
	group by comp_code,unit_code,publ,edtn,route_code,agcd,dpcd order by comp_code,unit_code,publ,edtn,route_code,agcd,dpcd' */


	set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,d.route_code ROUTE_CODE,dbo.cir_get_route_name(d.comp_code,d.unit_code,d.route_code) ROUTE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
		isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL from cir_dbksup d,cir_agmast m where m.comp_code=d.comp_code and d.comp_code='+
        ''''+@pcomp_code+''''+' and m.unit=d.unit_code and d.unit_code='+''''+@punit_code+''''+' and (d.publ=' + '''' + @ppubl + '''' + ' or ' + '''' + @ppubl + '''' + ' is null or ' + '''' + @ppubl + '''' + '=' + ''''+'''' +')
        and (d.edtn=' + '''' + @pedtn + '''' + '  or ' + '''' + @pedtn + '''' + ' is null or ' + '''' + @pedtn + '''' + '=' + ''''+'''' +') and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '+ '''' + convert(varchar(20),@pfrom_supdate,101) + '''' + ' and ' + '''' + convert(varchar(20),@ptill_supdate,101) + '''' + ' and ((route_code=' + '''' + @proute + '''' + ') or (' + '''' + @proute + '''' + ' is null) or (' + '''' + @proute + '''' + '=' + ''''+'''' +')) and
        d.edtn in(select distinct edtn from cir_edtn_mast where comp_code=d.comp_code and edtn = d.edtn and (main_edtn=' + '''' + @pmainedtn + '''' + ' or' + '''' + @pmainedtn + '''' + ' is null or ' + '''' + @pmainedtn + '''' + '=' + ''''+'''' +'))
        group by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code order by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code,d.agcd,d.dpcd'
                
		print @vquery 
		EXEC (@vquery)

		SET @vquery1  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,'+@vvar+','+@vvar_sum+' TOTAL from cir_dbksup d,cir_agmast m where m.comp_code=d.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and m.unit=d.unit_code and d.unit_code='+''''+@punit_code+''''+' and (d.publ=' + '''' + @ppubl + '''' + ' or ' + '''' + @ppubl + '''' + ' is null or ' + '''' + @ppubl + '''' + '=' + ''''+'''' +')and (d.edtn=' + '''' + @pedtn + '''' + '  or ' + '''' + @pedtn + '''' + ' is null or ' + '''' + @pedtn + '''' + '=' + ''''+'''' +') and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '+ '''' + convert(varchar(20),@pfrom_supdate,101) + '''' + ' and ' + '''' + convert(varchar(20),@ptill_supdate,101) + '''' + ' and ((route_code=' + '''' + @proute + '''' + ') or (' + '''' + @proute + '''' + ' is null) or (' + '''' + @proute + '''' + '=' + ''''+'''' +')) and d.edtn in(select distinct edtn from cir_edtn_mast where comp_code=d.comp_code and edtn = d.edtn and (main_edtn=' + '''' + @pmainedtn + '''' + ' or' + '''' + @pmainedtn + '''' + ' is null or ' + '''' + @pmainedtn + '''' + '=' + ''''+'''' +')) group by d.comp_code,d.unit_code order by d.comp_code,d.unit_code'
		print @vquery1
		EXEC (@vquery1)
		
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,d.route_code ROUTE_CODE,'+@vvar+','+@vvar_sum+' TOTAL from cir_dbksup d,cir_agmast m where m.comp_code=d.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and m.unit=d.unit_code and d.unit_code='+''''+@punit_code+''''+' and (d.publ=' + '''' + @ppubl + '''' + ' or ' + '''' + @ppubl + '''' + ' is null or ' + '''' + @ppubl + '''' + '=' + ''''+'''' +')and (d.edtn=' + '''' + @pedtn + '''' + '  or ' + '''' + @pedtn + '''' + ' is null or ' + '''' + @pedtn + '''' + '=' + ''''+'''' +') and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '+ '''' + convert(varchar(20),@pfrom_supdate,101) + '''' + ' and ' + '''' + convert(varchar(20),@ptill_supdate,101) + '''' + ' and ((route_code=' + '''' + @proute + '''' + ') or (' + '''' + @proute + '''' + ' is null) or (' + '''' + @proute + '''' + '=' + ''''+'''' +')) and d.edtn in(select distinct edtn from cir_edtn_mast where comp_code=d.comp_code and edtn = d.edtn and (main_edtn=' + '''' + @pmainedtn + '''' + ' or' + '''' + @pmainedtn + '''' + ' is null or ' + '''' + @pmainedtn + '''' + '=' + ''''+'''' +')) group by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code order by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code'
		print @vquery2
		EXEC (@vquery2)
		
		SET @vquery3  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,'+@vvar+','+@vvar_sum+' TOTAL from cir_dbksup d,cir_agmast m where m.comp_code=d.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and m.unit=d.unit_code and d.unit_code='+''''+@punit_code+''''+' and (d.publ=' + '''' + @ppubl + '''' + ' or ' + '''' + @ppubl + '''' + ' is null or ' + '''' + @ppubl + '''' + '=' + ''''+'''' +')and (d.edtn=' + '''' + @pedtn + '''' + '  or ' + '''' + @pedtn + '''' + ' is null or ' + '''' + @pedtn + '''' + '=' + ''''+'''' +') and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '+ '''' + convert(varchar(20),@pfrom_supdate,101) + '''' + ' and ' + '''' + convert(varchar(20),@ptill_supdate,101) + '''' + ' and ((route_code=' + '''' + @proute + '''' + ') or (' + '''' + @proute + '''' + ' is null) or (' + '''' + @proute + '''' + '=' + ''''+'''' +')) and d.edtn in(select distinct edtn from cir_edtn_mast where comp_code=d.comp_code and edtn = d.edtn and (main_edtn=' + '''' + @pmainedtn + '''' + ' or' + '''' + @pmainedtn + '''' + ' is null or ' + '''' + @pmainedtn + '''' + '=' + ''''+'''' +')) group by d.comp_code,d.unit_code,d.publ,d.edtn order by d.comp_code,d.unit_code,d.publ,d.edtn'
		print @vquery3
		EXEC (@vquery3)

		SET @vquery4  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,'+@vvar+','+@vvar_sum+' TOTAL from cir_dbksup d,cir_agmast m where m.comp_code=d.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and m.unit=d.unit_code and d.unit_code='+''''+@punit_code+''''+' and (d.publ=' + '''' + @ppubl + '''' + ' or ' + '''' + @ppubl + '''' + ' is null or ' + '''' + @ppubl + '''' + '=' + ''''+'''' +')and (d.edtn=' + '''' + @pedtn + '''' + '  or ' + '''' + @pedtn + '''' + ' is null or ' + '''' + @pedtn + '''' + '=' + ''''+'''' +') and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '+ '''' + convert(varchar(20),@pfrom_supdate,101) + '''' + ' and ' + '''' + convert(varchar(20),@ptill_supdate,101) + '''' + ' and ((route_code=' + '''' + @proute + '''' + ') or (' + '''' + @proute + '''' + ' is null) or (' + '''' + @proute + '''' + '=' + ''''+'''' +')) and d.edtn in(select distinct edtn from cir_edtn_mast where comp_code=d.comp_code and edtn = d.edtn and (main_edtn=' + '''' + @pmainedtn + '''' + ' or' + '''' + @pmainedtn + '''' + ' is null or ' + '''' + @pmainedtn + '''' + '=' + ''''+'''' +')) group by d.comp_code,d.unit_code,d.publ order by d.comp_code,d.unit_code,d.publ'
		print @vquery4
		EXEC (@vquery4)
		

 DEALLOCATE cur_sup_type

END




//******************************** End Issue no. 4688 *******************//
//////////*************** START*****ISSUE NO. 0005549 ******************///*******7/11/2011****//////
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[Cir_Gen_Code_festival_code_p]
	@pcompcode                                VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
	DECLARE @vno          INT 

	SELECT @vno  =  isnull(MAX(fest_code),0) + 1 FROM  cir_festival_mast 
	
	SELECT @vno AS "VAR_CODE"

/*****************************************************************************************************/
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
							set @finaldate=(select dbo.convert_user_date('/',@COL_VALUE1,@pdateformat))
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

















/***********************************************************************************************************************/
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER PROCEDURE [dbo].[cir_dynamic_execute_stmt]
	@ptable_name                              VARCHAR(4000) ,
	@pcond_colname                                 VARCHAR(4000) ,
	@pcond_colval                                VARCHAR(4000) ,
	@pdelimiter                               VARCHAR(4000) ,
	@pdateformat                              VARCHAR(4000) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS
    	DECLARE @pstmt_str                                VARCHAR(4000) 
		DECLARE @v_sess_id                                FLOAT 
		DECLARE @rec_stmt    VARCHAR(200)		
		DECLARE @vlength                                  NUMERIC(5) 
		DECLARE @vcolval                                  VARCHAR(4000) 
		DECLARE @vrunval                                  VARCHAR(1) 
		DECLARE @vcol_name                                VARCHAR(100) 
		DECLARE @vno                                      NUMERIC(5) 
		DECLARE @vrec                                     VARCHAR(4000) 
		DECLARE @vrec_upd                                 VARCHAR(4000) 
		DECLARE @vformat                                  VARCHAR(20) 
		DECLARE @v_col_exists                             NUMERIC(5) 
        DECLARE	 @COL_NAME    VARCHAR(200) 
        DECLARE	 @COL_VALUE1    VARCHAR(2000) 
		DECLARE @COL_DATATYPE VARCHAR(4000)
		declare @ss numeric(8)
		declare @vrec_val varchar(4000)
		declare @abj numeric(8)
		declare @col_val varchar(4000)
		declare @col_val1 varchar(4000)
declare @item varchar(4000)
declare @day varchar(4000)
declare @month varchar(4000)
declare @year varchar(4000)

		INSERT INTO  test1   ( vstring )   VALUES 	( CAST(@pcond_colname AS VARCHAR) + '33333' + CAST(@pcond_colval AS VARCHAR) )  
		set @v_sess_id = (select @@spid)
		DELETE FROM   temp_col_ins   WHERE  session_id  = (select @@spid)
		SET @vlength  = null 
		SET @vcolval  = null 
		SET @vrunval  = null 
		SET @vcol_name  = null 
		SET @vno  = null 
		SET @vcolval  = REPLACE(@pcond_colname, @pdelimiter, ',')
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
				SET @vcol_name  =  COALESCE(@vcol_name,space(0)) +  COALESCE(@vrunval,space(0))				
			  END
			ELSE
			 BEGIN				
				INSERT INTO  temp_col_ins  ( sqno , col_name , session_id )  
				 VALUES ( @vno , UPPER(LTRIM(RTRIM(@vcol_name))) , @v_sess_id )  				
				SET @vno  = @vno + 1 
				SET @vcol_name  = '' 
			END
			SET @i = @i + 1
		END 
		SELECT @v_col_exists  =  COUNT(*) FROM  temp_col_ins WHERE	 session_id  = @v_sess_id AND	col_name  = UPPER(LTRIM(RTRIM(@vcol_name)))		
		IF ISNULL(@v_col_exists, 0)= 0 
		BEGIN 
			INSERT INTO  temp_col_ins   ( sqno , col_name , session_id )   VALUES ( @vno , UPPER(@vcol_name) , @v_sess_id )			
		END
		SET @vlength  = null 
		SET @vcolval  = null 
		SET @vrunval  = null 
		SET @vcol_name  = null 
		SET @vno  = null 

		IF CHARINDEX(',', @pcond_colval)> 0 or CHARINDEX('''', @pcond_colval)> 0 
    		BEGIN 
	    		SET @vcolval  = REPLACE(@pcond_colval, ',', '~~~')
		END
		ELSE
		 BEGIN 
			SET @vcolval  = @pcond_colval 
		END
   
		SET @vcolval  = REPLACE(@vcolval, @pdelimiter, ',')
		SET @vlength  = LEN(@vcolval)
		SET @vno  = 1 
        SET @i = 1 
		
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
			END

			SET @i = @i + 1

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
			WHERE	 TABLE_NAME  = UPPER(LTRIM(RTRIM(@ptable_name)))
			 AND	column_name  = UPPER(LTRIM(RTRIM(temp_col_ins.col_name)))
		) 
		WHERE  session_id  = @v_sess_id 
		
		delete from temp_col_ins where col_value='''''' or col_value=''  and session_id=@v_sess_id 

		SET @vrec='select * from '+@ptable_name+' where ';

		SET @vformat  = @pdateformat 

		DECLARE cur_stmt cursor  FOR 
		SELECT COL_NAME,COL_VALUE,COL_DATA_TYPE  FROM  temp_col_ins WHERE	 session_id  = @v_sess_id ORDER BY sqno 
		

    OPEN cur_stmt 
		fetch NEXT FROM cur_stmt INTO @COL_NAME,@COL_VALUE1,@COL_DATATYPE
         while(@@FETCH_STATUS = 0)
			BEGIN 
               print(@COL_NAME) 
                print(@COL_VALUE1) 
                print(@COL_DATATYPE) 

				IF  ( @COL_DATATYPE = 'DATETIME') 
					BEGIN 
--                            print('11')
--                           print(@COL_NAME) 
--                print(@COL_VALUE1) 
--                print(@COL_DATATYPE) 
                         
						declare @finaldate varchar(4000)
						declare @count_dat int
						set @count_dat=0
						declare cur_date cursor for

						select item from Split_date(@COL_VALUE1,'/')
                     --   print(item)
						 open cur_date

						fetch NEXT FROM cur_date into @item
						while(@@FETCH_STATUS = 0)

							BEGIN  
							IF(LOWER(@pdateformat)='mm/dd/yyyy')
								begin
--                                print(@item)
								if @count_dat=0
									set @month= @item
								else if @count_dat=1
									set @day= @item
								else  
									set @year= @item
								  fetch NEXT FROM cur_date into @item
								  set @count_dat=@count_dat+1
								  
								end

					
							IF(LOWER(@pdateformat)='dd/mm/yyyy')
								begin
--                                  print(@item)
								if @count_dat=0
									set @day= @item
								else if @count_dat=1
									set @month= @item
								else  
									set @year= @item
								  fetch NEXT FROM cur_date into @item
								  set @count_dat=@count_dat+1
--								   print(@item)
--                                   print('22')
--                                    print(@day)
--                                     print(@month)
--                                       print(@year)
								end
						
							IF(LOWER(@pdateformat)='yyyy/mm/dd')
								begin
								if @count_dat=0
									set @year= @item
								else if @count_dat=1
									set @month= @item
								else  
									set @day= @item
								  fetch NEXT FROM cur_date into @item
								  set @count_dat=@count_dat+1
								  
								end
							end
						CLOSE cur_date
						DEALLOCATE cur_date 

 
                           

set @day =  replace(@day,'''','')
set @month =  replace(@month,'''','')
set @year =  replace(@year,'''','')

 

--						IF(LOWER(@pdateformat)='dd/mm/yyyy')
--							set @finaldate=COALESCE(@day + '/', SPACE(0))  + COALESCE(@month + '/', SPACE(0))+COALESCE(@year + '', SPACE(0))

						--IF(LOWER(@pdateformat)='mm/dd/yyyy')
							set @finaldate=COALESCE(@month + '/', SPACE(0))  + COALESCE(@day + '/', SPACE(0))+COALESCE(@year + '', SPACE(0))

--						IF(LOWER(@pdateformat)='yyyy/mm/dd')
--							set @finaldate=COALESCE(@year + '/', SPACE(0))  + COALESCE(@month + '/', SPACE(0))+COALESCE(@day + '', SPACE(0))



						set @finaldate=replace(@finaldate,'''','')
                              print('4440')
                             print(@col_val)
						--	SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + '' + COALESCE(@finaldate + '', SPACE(0))
                              SET @vrec=@vrec + @COL_NAME+'='+''''+@finaldate+''''+ ' and  ';
                            print(@vrec)
			
					END;
					else if(@COL_DATATYPE = 'numeric')
					begin
                            print('333')
                            print(@COL_NAME) 
							print(@COL_VALUE1) 
							print(@COL_DATATYPE) 

SET @col_val = COALESCE(@col_val + '', SPACE(0)) + '' + 'convert( int,' + COALESCE(@COL_VALUE1 + '', SPACE(0))+')'						
--							SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + '' + 'convert( int,' + COALESCE(@COL_VALUE1 + '', SPACE(0))+')'
                             print(@col_val)
                              SET @vrec=@vrec + @COL_NAME+'='+@col_val+ ' and  ';
                               print(@vrec)
                              SET @col_val = '';

					end
				ELSE
					BEGIN
					      SET @vrec=@vrec + '(('+@COL_NAME+'='+@COL_VALUE1+') or ('+@COL_NAME +' like '+@COL_VALUE1+')) and   ';
                       
                          print(@vrec);
						END;   
				fetch NEXT FROM cur_stmt INTO @COL_NAME,@COL_VALUE1,@COL_DATATYPE
			END 

--print @vrec;
              
			SET @col_val =COALESCE(substring(@col_val,1,len(@col_val)),SPACE(0))
			SET @vrec=  COALESCE(@vrec,SPACE(0)) + COALESCE(@col_val,SPACE(0)) + ')'
            declare   @len11 INT;
               print('444'); 
              print(@col_val); 
             print('4441'); 
              print(@vrec)
            SET @len11= LEN(@vrec)

            print(@len11)

            SET @len11= @len11 - 6; 

           SET @vrec=SUBSTRING(@vrec,0,@len11)

             print(@vrec)
             

			SET @vlength  = null 
			SET @vcolval  = null 
			SET @vrunval  = null 
			SET @vcol_name  = null 
			SET @vno  = null 
						
--		UPDATE   temp_col_ins   
--		SET	upd_str = @vrec 
--		WHERE  session_id  = @v_sess_id
		if @pextra1 is null or @pextra1='' or @pextra1=null
			begin
				set @vrec=@vrec +' order by 1'
			end
        else
			begin
				set @vrec=@vrec +' order by '+ @pextra1
			end

PRINT (@vrec)
EXEC (@vrec)
 DEALLOCATE cur_stmt 













/*********************************************************************************************/
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


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







/*****************************************************************************************************************************/


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[cir_dynamic_dml_variable_delete_stmt]
	@ptable_name                              VARCHAR(4000) ,
	@pcond_colname                                 VARCHAR(4000) ,
	@pcond_colval                                VARCHAR(4000) ,
	@pdelimiter                               VARCHAR(4000) ,
	@pdateformat                              VARCHAR(4000) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS
    	DECLARE @pstmt_str                                VARCHAR(4000) 
		DECLARE @v_sess_id                                FLOAT 
		DECLARE @rec_stmt    VARCHAR(200)		
		DECLARE @vlength                                  NUMERIC(5) 
		DECLARE @vcolval                                  VARCHAR(4000) 
		DECLARE @vrunval                                  VARCHAR(1) 
		DECLARE @vcol_name                                VARCHAR(100) 
		DECLARE @vno                                      NUMERIC(5) 
		DECLARE @vrec                                     VARCHAR(4000) 
		DECLARE @vrec_upd                                 VARCHAR(4000) 
		DECLARE @vformat                                  VARCHAR(20) 
		DECLARE @v_col_exists                             NUMERIC(5) 
        DECLARE	 @COL_NAME    VARCHAR(200) 
        DECLARE	 @COL_VALUE1    VARCHAR(2000) 
		DECLARE @COL_DATA_TYPE1 VARCHAR(4000)
		declare @item varchar(4000)
		declare @day varchar(4000)
		declare @month varchar(4000)
		declare @year varchar(4000)
		declare @ss numeric(8)
		declare @vrec_val varchar(4000)
		declare @abj numeric(8)
		declare @col_val varchar(4000)
		declare @col_val1 varchar(4000)
		INSERT INTO  test1   ( vstring )   VALUES 	( CAST(@pcond_colname AS VARCHAR) + '33333' + CAST(@pcond_colval AS VARCHAR) )  
		set @v_sess_id = (select @@spid)
		DELETE FROM   temp_col_ins   WHERE  session_id  = (select @@spid)
		SET @vlength  = null 
		SET @vcolval  = null 
		SET @vrunval  = null 
		SET @vcol_name  = null 
		SET @vno  = null 
		SET @vcolval  = REPLACE(@pcond_colname, @pdelimiter, ',')
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
				SET @vcol_name  =  COALESCE(@vcol_name,space(0)) +  COALESCE(@vrunval,space(0))				
			  END
			ELSE
			 BEGIN				
				INSERT INTO  temp_col_ins  ( sqno , col_name , session_id )  
				 VALUES ( @vno , UPPER(LTRIM(RTRIM(@vcol_name))) , @v_sess_id )  				
				SET @vno  = @vno + 1 
				SET @vcol_name  = '' 
			END
			SET @i = @i + 1
		END 
		SELECT @v_col_exists  =  COUNT(*) FROM  temp_col_ins WHERE	 session_id  = @v_sess_id AND	col_name  = UPPER(LTRIM(RTRIM(@vcol_name)))		
		IF ISNULL(@v_col_exists, 0)= 0 
		BEGIN 
			INSERT INTO  temp_col_ins   ( sqno , col_name , session_id )   VALUES ( @vno , UPPER(@vcol_name) , @v_sess_id )			
		END
		SET @vlength  = null 
		SET @vcolval  = null 
		SET @vrunval  = null 
		SET @vcol_name  = null 
		SET @vno  = null 

		IF CHARINDEX(',', @pcond_colval)> 0 or CHARINDEX('''', @pcond_colval)> 0 
    		BEGIN 
	    		SET @vcolval  = REPLACE(@pcond_colval, ',', '~~~')
		END
		ELSE
		 BEGIN 
			SET @vcolval  = @pcond_colval 
		END
   
		SET @vcolval  = REPLACE(@vcolval, @pdelimiter, ',')
		SET @vlength  = LEN(@vcolval)
		SET @vno  = 1 
        SET @i = 1 
		
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
			END

			SET @i = @i + 1

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
			WHERE	 TABLE_NAME  = UPPER(LTRIM(RTRIM(@ptable_name)))
			 AND	column_name  = UPPER(LTRIM(RTRIM(temp_col_ins.col_name)))
		) 
		WHERE  session_id  = @v_sess_id 
		
		delete from temp_col_ins where col_value='''''' or col_value=''  and session_id=@v_sess_id 

		SET @vrec='delete from '+@ptable_name+' where ';

		SET @vformat  = @pdateformat 

		DECLARE cur_stmt cursor  FOR 
		SELECT COL_NAME,COL_VALUE,COL_DATA_TYPE  FROM  temp_col_ins WHERE	 session_id  = @v_sess_id AND COL_NAME!='' ORDER BY sqno 
		

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
						
						print @finaldate
						
					--SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + '' + COALESCE(@finaldate + '', SPACE(0))
						SET @vrec=@vrec +@COL_NAME+'='+COALESCE(@finaldate + '', SPACE(0))+' and   ';
					end
				else if(@COL_DATA_TYPE1 = 'numeric')
					begin
						SET @col_val = COALESCE(@col_val + ',', SPACE(0)) + '' + 'convert( int,' + COALESCE(@COL_VALUE1 + '', SPACE(0))+')'
						SET @vrec=@vrec +@COL_NAME+'='+COALESCE(@COL_VALUE1 + '', SPACE(0))+' and   ';
					end
				ELSE
					BEGIN
						PRINT @COL_NAME
					    SET @vrec=@vrec +@COL_NAME+'='+COALESCE(@COL_VALUE1 + '', SPACE(0))+' and   ';
                          
					END;   
				fetch NEXT FROM cur_stmt INTO @COL_NAME,@COL_VALUE1,@COL_DATA_TYPE1
			END 


			--SET @col_val =COALESCE(substring(@col_val,1,len(@col_val)),SPACE(0))
			--SET @vrec=  COALESCE(@vrec,SPACE(0)) + COALESCE(@col_val,SPACE(0)) + ')'
 declare   @len11 INT;
              
         SET @len11= LEN(@vrec)
          print(@len11)

          SET @len11= @len11 - 3; 

         SET @vrec=SUBSTRING(@vrec,0,@len11)

             print(@vrec)
             

			SET @vlength  = null 
			SET @vcolval  = null 
			SET @vrunval  = null 
			SET @vcol_name  = null 
			SET @vno  = null 
						
--		UPDATE   temp_col_ins   
--		SET	upd_str = @vrec 
--		WHERE  session_id  = @v_sess_id

     PRINT @vrec
		EXEC (@vrec)
 DEALLOCATE cur_stmt 



/********************************************************************************************************************/
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go






ALTER PROCEDURE [dbo].[fa_check_duplicacy_fa_check_duplicacy_p]
	@pcomp_col         as                       VARCHAR(4000) ,
	@pcomp_val         as                       VARCHAR(4000) ,
	@punit_col         as                       VARCHAR(4000) ,
	@punit_val         as                       VARCHAR(4000) ,
	@ptbl_name         as                       VARCHAR(4000) ,
	@pdesc_col         as                       VARCHAR(4000) ,
	@pdesc_val         as                       VARCHAR(4000) ,
	@palias_col        as                       VARCHAR(4000) ,
	@palias_val        as                       VARCHAR(4000) ,
	@pdateformat       as                       VARCHAR(4000) ,
	@pextra1           as                       VARCHAR(4000) ,
	@pextra2           as                       VARCHAR(4000) 
AS 
	

		
		
		DECLARE @v_str1        as                           VARCHAR(2000) 
		DECLARE @v_str2        as                           VARCHAR(2000) 
		DECLARE @v_cnt1        as                           NUMERIC(5)                      
		SET @v_cnt1 = 0 
		DECLARE @v_cnt2        as                           NUMERIC(5)                      
		SET @v_cnt2 = 0 
		DECLARE @v_comp_exists  as                          NUMERIC(1)                      
		SET @v_comp_exists = 0 
		DECLARE @v_unit_exists  as                          NUMERIC(1)                      
		SET @v_unit_exists = 0 
		

        print('1')       

        SELECT @v_str1  = 'pcomp_col' + @pcomp_col + ' pcomp_val' + @pcomp_val + ' punit_col' + @punit_col + ' punit_val' + @punit_val + ' ptbl_name' + @ptbl_name + ' pdesc_col' + @pdesc_col + ' pdesc_val' + @pdesc_val + ' palias_col' + @palias_col + ' palias_val' + @palias_val 
		INSERT INTO  test1   ( vstring , vstring2 )  VALUES ( ' duplicacy ' , @v_str1 )  
		
         print(@v_str1)     		

		-- IMPLICIT_TRANSACTIONS is set to OFF
		DELETE FROM   cir_chk_duplicacy1   WHERE  1  = 1 
		
		SELECT @v_comp_exists  =  COUNT(*) FROM   INFORMATION_SCHEMA.COLUMNS WHERE	 TABLE_NAME  = @ptbl_name AND	column_name  = @pcomp_col
		
		INSERT INTO  test1   ( vstring , vstring2 )   VALUES ( ' v_comp_exists ' , @v_comp_exists )  
		
		
		-- IMPLICIT_TRANSACTIONS is set to OFF
		SELECT @v_unit_exists  =  COUNT(*) FROM   INFORMATION_SCHEMA.COLUMNS WHERE	 TABLE_NAME  = @ptbl_name AND	column_name  = @punit_col
		
		INSERT INTO  test1   ( vstring , vstring2 )   VALUES ( ' v_unit_exists ' , @v_unit_exists )  
		
		
		-- IMPLICIT_TRANSACTIONS is set to OFF
		SELECT @v_cnt1  =  COUNT(*) FROM   INFORMATION_SCHEMA.COLUMNS WHERE	 TABLE_NAME  = @ptbl_name AND	column_name  = @pdesc_col
		
		INSERT INTO  test1  ( vstring , vstring2 )   VALUES ( ' v_cnt1 ' , @v_cnt1 )  
		
		
		-- IMPLICIT_TRANSACTIONS is set to OFF
		SELECT @v_cnt2  =  COUNT(*) FROM   INFORMATION_SCHEMA.COLUMNS WHERE	 TABLE_NAME  = @ptbl_name AND	column_name  = @palias_col
		
		INSERT INTO  test1   ( vstring , vstring2 )  VALUES ( ' v_cnt2 ' , @v_cnt2 )  
		
		
		-- IMPLICIT_TRANSACTIONS is set to OFF
		
		IF (@v_cnt1 = 1 and @v_cnt2 = 0 )
		BEGIN 
			
			IF (@v_comp_exists = 1 and @v_unit_exists = 0 )
				BEGIN 
					--if comp code exists and unit code not exists in table
					--v_str1:=' insert into cir_chk_duplicacy(rec_name1) select count(*) from '||ptbl_name||' where '||pcomp_col||'='||''''||pcomp_val||''''||' and '||pdesc_col||'='||''''||pdesc_val||'''';
					
					SELECT @v_str1  = ' insert into cir_chk_duplicacy1(rec_name1) select count(*) from ' + @ptbl_name + ' where  ' + @pcomp_col + '=' + @pcomp_val + ' and upper(' + @pdesc_col + ')= upper(' + @pdesc_val + ')' 
					
				END
			ELSE IF (@v_comp_exists = 1 and @v_unit_exists = 1 )
				BEGIN 
					--if both are existng in table
					--v_str1:=' insert into cir_chk_duplicacy(rec_name1) select count(*) from '||ptbl_name||' where '||pcomp_col||'='||''''||pcomp_val||''''||' and '||punit_col||'='||''''||punit_val||''''||' and '||pdesc_col||'='||''''||pdesc_val||'''';
					
					SELECT @v_str1  = ' insert into cir_chk_duplicacy1(rec_name1) select count(*) from ' + @ptbl_name + ' where  ' + @pcomp_col + '=' + @pcomp_val + ' and ' + @punit_col + '=' + @punit_val + ' and upper(' + @pdesc_col + ')= upper(' + @pdesc_val + ')' 
					
				END
			ELSE 
				BEGIN 
					--if both are not existng in table
					--v_str1:=' insert into cir_chk_duplicacy(rec_name1) select count(*) from '||ptbl_name||' where '||pdesc_col||'='||''''||pdesc_val||'''';
					
					SELECT @v_str1  = ' insert into cir_chk_duplicacy1(rec_name1) select count(*) from ' + @ptbl_name + ' where upper(' + @pdesc_col + ')= upper(' + @pdesc_val + ')' 
				END
   
			INSERT INTO  test1   ( vstring , vstring2 )   VALUES 		( ' 1duplicacy ' , @v_str1 )  
			
			
			-- IMPLICIT_TRANSACTIONS is set to OFF
			
			--SELECT @v_str1  = insert into cir_chk_duplicacy(rec_name1) select count(*) from
print(@v_str1)
			EXEC (@v_str1)

			
		END
		ELSE IF (@v_cnt1 = 0 and @v_cnt2 = 1)
		BEGIN 
print('garima')
print(@v_comp_exists)
print(@v_unit_exists)			

			IF (@v_comp_exists = 1 and @v_unit_exists = 0) 
				BEGIN 
					--if comp code exists and unit code not exists in table
					--v_str2:=' insert into cir_chk_duplicacy(rec_name2) select count(*) from '||ptbl_name||' where '||pcomp_col||'='||''''||pcomp_val||''''||' and '||palias_col||'='||''''||palias_val||'''';
					
					SELECT @v_str2  = ' insert into cir_chk_duplicacy1(rec_name2) select count(*) from ' + @ptbl_name + ' where  ' + @pcomp_col + '=' + @pcomp_val + ' and upper(' + @pdesc_col + ')=upper(' + @pdesc_val + ')' 
					
				END
			ELSE IF (@v_comp_exists = 1 and @v_unit_exists = 1) 
				BEGIN 
					--if both are existng in table
					--v_str2:=' insert into cir_chk_duplicacy(rec_name2) select count(*) from '||ptbl_name||' where '||pcomp_col||'='||''''||pcomp_val||''''||' and '||punit_col||'='||''''||punit_val||''''||' and '||palias_col||'='||''''||palias_val||'''';
					
					SELECT @v_str2  = ' insert into cir_chk_duplicacy1(rec_name2) select count(*) from ' + @ptbl_name + ' where  ' + @pcomp_col + '=' + @pcomp_val + ' and ' + @punit_col + '=' + @punit_val + ' and upper(' + @pdesc_col + ')=upper(' + @pdesc_val + ')' 
				
				END
			ELSE
				BEGIN 
					--if both are not existng in table
					--v_str2:=' insert into cir_chk_duplicacy(rec_name2) select count(*) from '||ptbl_name||' where '||palias_col||'='||''''||palias_val||'''';
					
					SELECT @v_str2  = ' insert into cir_chk_duplicacy1(rec_name2) select count(*) from ' + @ptbl_name + ' where upper(' + @pdesc_col + ')=upper(' + @pdesc_val + ')' 
				END
   
			INSERT INTO  test1   ( vstring , vstring2 )   VALUES ( ' 2duplicacy ' , @v_str2 )  
			
			
			-- IMPLICIT_TRANSACTIONS is set to OFF
			
			--SELECT @v_str2  = insert into cir_chk_duplicacy(rec_name2) select count(*) from
print(@v_str2)
			EXEC (@v_str2)
			
		END
		ELSE IF (@v_cnt1 = 1 and @v_cnt2 = 1) 
		BEGIN 
			
			IF (@v_comp_exists = 1 and @v_unit_exists = 0 )
			BEGIN 
				--if comp code exists and unit code not exists in table
				--v_str1:=' insert into cir_chk_duplicacy(rec_name1) select count(*) from '||ptbl_name||' where '||pcomp_col||'='||''''||pcomp_val||''''||' and '||pdesc_col||'='||''''||pdesc_val||'''';
				
				SELECT @v_str1  = ' insert into cir_chk_duplicacy1(rec_name1) select count(*) from ' + @ptbl_name + ' where  ' + @pcomp_col + '=' + @pcomp_val + ' and upper(' + @pdesc_col + ')=upper(' + @pdesc_val + ')' 
				 	print(@v_str1);
			END
			ELSE IF (@v_comp_exists = 1 and @v_unit_exists = 1 )
			BEGIN 
				--if both are existng in table
				--v_str1:=' insert into cir_chk_duplicacy(rec_name1) select count(*) from '||ptbl_name||' where '||pcomp_col||'='||''''||pcomp_val||''''||' and '||punit_col||'='||''''||punit_val||''''||' and '||pdesc_col||'='||''''||pdesc_val||'''';
				
				SELECT @v_str1  = ' insert into cir_chk_duplicacy1(rec_name1) select count(*) from ' + @ptbl_name + ' where  ' + @pcomp_col + '=' + @pcomp_val + ' and ' + @punit_col + '=' + @punit_val + ' and upper(' + @pdesc_col + ')=upper(' + @pdesc_val + ')' 
				 	print(@v_str1);
			END
			ELSE
			BEGIN 
				--if both are not existng in table
				--v_str1:=' insert into cir_chk_duplicacy(rec_name1) select count(*) from '||ptbl_name||' where '||pdesc_col||'='||''''||pdesc_val||'''';
				
				SELECT @v_str1  = ' insert into cir_chk_duplicacy1(rec_name1) select count(*) from ' + @ptbl_name + ' where upper(' + @pdesc_col + ')=upper(' + @pdesc_val + ')' 
		       	print(@v_str1);
            END
   
			INSERT INTO  test1   ( vstring , vstring2 )   VALUES ( ' 3duplicacy ' , @v_str1 )  
			
			
			-- IMPLICIT_TRANSACTIONS is set to OFF
			
		--	SELECT @v_str1  = insert into cir_chk_duplicacy(rec_name1) select count(*) from
			EXEC (@v_str1)
		
			IF (@v_comp_exists = 1 and @v_unit_exists = 0 )
			BEGIN 
				--if comp code exists and unit code not exists in table
				--v_str2:=' update cir_chk_duplicacy set rec_name2=(select count(*) from '||ptbl_name||' where '||pcomp_col||'='||''''||pcomp_val||''''||' and '||palias_col||'='||''''||palias_val||''''||')';
				
				SELECT @v_str2  = ' update cir_chk_duplicacy1 set rec_name2=(select count(*) from ' + @ptbl_name + ' where  ' + @pcomp_col + ' = ' + @pcomp_val + ' and upper(' + @palias_col + ') = upper(' + @palias_val + ')' + ')' 
				print(@v_str2);
			END
			ELSE IF (@v_comp_exists = 1 and @v_unit_exists = 1)
			BEGIN 
				--if both are existng in table
				--v_str2:=' update cir_chk_duplicacy set rec_name2=(select count(*) from '||ptbl_name||' where '||pcomp_col||'='||''''||pcomp_val||''''||' and '||punit_col||'='||''''||punit_val||''''||' and '||palias_col||'='||''''||palias_val||''''||')';
				
				SELECT @v_str2  = ' update cir_chk_duplicacy1 set rec_name2 = (select count(*) from ' + @ptbl_name + ' where  ' + @pcomp_col + ' = ' + @pcomp_val + ' and ' + @punit_col + '=' + @punit_val + ' and upper(' + @palias_col + ')= upper(' + @palias_val + ')' + ')' 
				print(@v_str2);
			END
			ELSE
			BEGIN 
				--if both are not existng in table
				--v_str2:=' update cir_chk_duplicacy set rec_name2=(select count(*) from '||ptbl_name||' where '||palias_col||'='||''''||palias_val||''''||')';
				
				SELECT @v_str2  = ' update cir_chk_duplicacy1 set rec_name2 = (select count(*) from ' + @ptbl_name + ' where upper ( ' + @palias_col + ') = upper ( ' + @palias_val + ')' + ')' 
		        print(@v_str2);
         	END
   
			INSERT INTO  test1   ( vstring , vstring2 )   VALUES ( ' 4duplicacy ' , @v_str2 )  
			
			
			-- IMPLICIT_TRANSACTIONS is set to OFF
			
			--SELECT @v_str2  = update cir_chk_duplicacy set rec_name2=(select count(*) from
			EXEC (@v_str2)
			
		END
		ELSE
		BEGIN 
			INSERT INTO  cir_chk_duplicacy1   ( rec_name1 , rec_name2 )   VALUES ( 0 , 0 )  
			
		END
   
		
		-- IMPLICIT_TRANSACTIONS is set to OFF
		print('aa')

	
		SELECT DISTINCT ISNULL(rec_name1, 0) 'NAME' , ISNULL(rec_name2, 0) 'ALIAS' FROM  cir_chk_duplicacy1 WHERE	 1  = 1











//////////*************** end*****ISSUE NO. 0005549 ******************///*******7/11/2011****//////
/*********************************7-nov-2011 Laxman*****************/
CREATE procedure cir_route_droppoint_detail_p
    @pcompcode       AS varchar(20),
    @punitcode       AS varchar(20),
    @proutecode      AS varchar(20),
    @ptaxi_id        AS varchar(20),
    @puserid         AS varchar(20),
    @pdateformat     AS varchar(20),
    @pextra1         AS varchar(20),
    @pextra2         AS varchar(20),
    @pextra3         AS varchar(20),
    @pextra4         AS varchar(20),
    @pextra5         AS varchar(20),
    @pextra6         AS varchar(20),
    @pextra7         AS varchar(20),
    @pextra8         AS varchar(20),
    @pextra9         AS varchar(20),
    @pextra10        AS varchar(20)
  As
  Begin

  	    SELECT R.COMP_CODE COMP_CODE,R.UNIT_CODE UNIT_CODE,R.TAXI_ID TAXI_ID,
        M.RT_CODE RT_CODE,DBO.CIR_GET_ROUTE_NAME(R.COMP_CODE,R.UNIT_CODE,M.RT_CODE) ROUTE_NAME,
        R.DROP_POINT_CODE DROP_POINT_CODE,DBO.CIR_GET_DROP_POINT_NAME(R.COMP_CODE,R.UNIT_CODE,R.DROP_POINT_CODE,1) DROP_POINT_NAME, 
        R.ARRIVAL_TIME ARRIVAL_TIME,R.STOPPAGE_TIME STOPPAGE_TIME,P.LATITUDE LATITUDE,P.LOGNITUDE LOGNITUDE,R.DROP_POINT_SEQNO DROP_POINT_SEQNO 
        FROM CIR_TAXI_MAST M,CIR_TAXI_ROUTE R,CIR_DROP_POINT_MAST P
        WHERE M.COMP_CODE=R.COMP_CODE AND M.COMP_CODE=P.COMP_CODE AND R.COMP_CODE=@PCOMPCODE AND 
        M.UNIT_CODE=R.UNIT_CODE AND M.UNIT_CODE=P.UNIT_CODE AND R.UNIT_CODE=@PUNITCODE AND M.TAXI_ID=R.TAXI_ID AND 
        (R.TAXI_ID =@PTAXI_ID OR @PTAXI_ID IS NULL OR @PTAXI_ID='') AND (M.RT_CODE=@PROUTECODE) AND R.DROP_POINT_CODE=P.DROP_POINT
        ORDER BY ROUTE_NAME,DROP_POINT_SEQNO
                 
    select getdate() as "CUR_DATE"
                     
    select getdate() as "CUR_DATE"
  End 

/*********************************7-nov-2011 Laxman*****************/


//******************************** Start Issue no. 5466 **********************//



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER PROCEDURE [dbo].[cir_rep_supply_cir_rep_dist_day_daybook]
	@pcomp_code                                VARCHAR(20) ,
	@punit_code                                VARCHAR(20) ,
	@ppubl                                     VARCHAR(20) ,
	@pedtn                                     VARCHAR(20) ,
	@pcitycd                                   VARCHAR(20) ,
	@pdistcd                                   VARCHAR(20) ,
	@pmonth                                    VARCHAR(20) ,
	@pyear                                     VARCHAR(20) ,
	@pday                                      VARCHAR(20) ,
	@pdateformat                               VARCHAR(20) ,
	@pbranch								   varchar(20),
    @pdistcode								   varchar(20),
    @ptaluka								   varchar(20),
    @pagtype								   varchar(20),
    @pagclass								   varchar(20),
    @pagcode								   varchar(20),
    @pdpcode								   varchar(20), 
    @pextra1								   varchar(200),
    @pextra2								   varchar(200),
    @pextra3								   varchar(200),
    @pextra4								   varchar(200),
    @pextra5								   varchar(200)
AS 
	
		
		DECLARE @vquery1                                  VARCHAR(8000) 
		-- Oracle To SQL Server Edition : The precision of '@vquery2' is changed from 15000 to the maximum prcession in SQLServer is 8000
		DECLARE @vquery2                                  VARCHAR(8000) 
		-- Oracle To SQL Server Edition : The precision of '@vquery3' is changed from 15000 to the maximum prcession in SQLServer is 8000
		DECLARE @vquery3                                  VARCHAR(8000) 
		DECLARE @vdaysup                                  VARCHAR(2000) 
		DECLARE @vtotsup                                  VARCHAR(1000) 
	--	DECLARE @vfrdt                                   VARCHAR(20)
	--	DECLARE @vtodt                                   VARCHAR(20)
		DECLARE @v_dt                                     DATETIME 
		DECLARE @v_day                                    VARCHAR(3) 
		DECLARE @v_cnt                                    int                           
		SET @v_cnt = 0 



      DECLARE @vday11                                    VARCHAR(80)
        DECLARE @vdt11                                     VARCHAR(80)

		DECLARE c1 cursor LOCAL FOR 
		
	          	SELECT dt, UPPER(DATENAME(WEEKDAY, dt)) supply_day	FROM  cir_temp_dt 	ORDER BY sqno, dt 
		
		     DECLARE @vfrdt         VARCHAR(20)
		DECLARE @vtodt         VARCHAR(20)
       	DECLARE @vtodt1         VARCHAR(20)
		DECLAre @pquery         varchar(8000)
		DECLAre @pquery1         varchar(8000)
		DECLAre @pquery2         varchar(8000)
     --   PRINT('2')


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



if(@pday = 'sun')
begin
   set  @pday = 'Sunday'
end  
else if(@pday = 'mon')
begin
   set  @pday = 'Monday'
end  
else if(@pday = 'tue')
begin
   set  @pday = 'Tuesday'
end  
else if(@pday = 'wed')
begin
   set  @pday = 'Wednesday'
end  
else if(@pday = 'thu')
begin
   set  @pday = 'Thursday'
end  
else if(@pday = 'fri')
begin
   set  @pday = 'Friday'
end  
else if(@pday = 'sat')
begin
   set  @pday = 'Saturday'
end  
print (@pday)


--        SET @vfrdt=(@pmonth+'/'+'01/'+@pyear) 
--        PRINT( @vfrdt) 
--		SET @vtodt1=([dbo].[GetLastDayOfMonth](@vfrdt))
--   --      PRINT('2') 
--        print @vtodt1
--	    SET @vtodt=(@pmonth+'/'+SUBSTRING(@vtodt,5,2)+'/'+@pyear) 
--	

   SET @vfrdt=(@pmonth+'/'+'01/'+@pyear) 
  PRINT( @vfrdt) 
		SET @vtodt1=([dbo].[GetLastDayOfMonth](@vfrdt))
         PRINT('2') 
		set @vtodt=SUBSTRING(@vtodt1,5,2)
print @vtodt1
	    SET @vtodt=(@pmonth+'/'+@vtodt+'/'+@pyear) 
		PRINT @vtodt



    	DELETE FROM   cir_temp_dt    
		
	
		WHILE (0 = 0) 
		BEGIN  
			IF @v_dt >= @vtodt 
			BEGIN 
				BREAK

			END
			ELSE
			BEGIN 
				IF @v_dt is null 
				BEGIN 
					SET @v_dt  = @vfrdt 
				END
				ELSE
				BEGIN 
					SET @v_dt  = @v_dt + 1 
				END
   
			END
   
			IF UPPER(DATENAME(WEEKDAY, @v_dt))= UPPER(@pday)
			BEGIN 
				 INSERT INTO  cir_temp_dt   ( sqno , dt )   VALUES 		( 1 , @v_dt )  
				
			END
			ELSE
			BEGIN 
			     INSERT INTO  cir_temp_dt   ( sqno , dt )   VALUES 		( 2 , 	@v_dt )  
				
			END
   
		
		END
		
		
		OPEN c1 
		fetch NEXT FROM c1 INTO @vdt11,@vday11	
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN 
			
		

			SET @v_cnt  = @v_cnt + 1 
			IF @vquery1 is null 
			BEGIN 
	--	print @v_cnt
			--	SET @vquery1  = 'case day(A.SUPDATE  when day('+@vdt11+') then SUM(isnull(A.SUP_COPY,0)) end P'+left( convert(int, @v_cnt)+000000000,2);
              SET @vquery1  = 'case (select(day(A.SUPDATE)))  when day('''+@vdt11+''') then SUM(isnull(A.SUP_COPY,0)) end P'+dbo.fnPadLeft('0',2,@v_cnt);
		--		print 'ankurq'				
		--	SET @vdaysup  = 'SUM(isnull(P left( convert(varchar, '+@v_cnt+')+''000000000'',2) ,'+ 0 + ')) AS '+'"'+'left( convert(varchar, '+@v_cnt+')+''000000000'',2)'+'"'
		--	print 'ankur'
		--		SET @vtotsup  = 'isnull ( P '+' left( convert(varchar, '+@v_cnt+')+''000000000'',2)'+',0)'
             SET @vdaysup  = 'SUM(isnull(P'+ dbo.fnPadLeft('0',2,@v_cnt)+',0)) AS ' + '"' + dbo.fnPadLeft('0',2,@v_cnt) + '"';
              
             --   print(@vdaysup)

		        SET @vtotsup  = 'isnull(P'+ dbo.fnPadLeft ('0',2,@v_cnt)+',0)';


			END
			ELSE
			BEGIN
--print 'gg' 
--				SET @vquery1  = @vquery1 + ',' + 'case day(A.SUPDATE  when day('+@vdt11+') then SUM(isnull(A.SUP_COPY,0)) end P'+left( convert(varchar, @v_cnt)+'000000000',2);
--				SET @vdaysup  = @vdaysup + ',' + 'SUM(isnull(P left( convert(varchar, '+@v_cnt+')+''000000000'',2) ,'+ 0 + ')) AS '+'"'+'left( convert(varchar, '+@v_cnt+')+''000000000'',2)'+'"'
--				SET @vtotsup  = @vtotsup + '+' + 'isnull(P'+'left( convert(varchar, '+@v_cnt+')+''000000000'',2)'+',0)'

                SET @vquery1  = @vquery1 + ',' + 'case (select(day(A.SUPDATE)))  when day('''+@vdt11+''') then SUM(isnull(A.SUP_COPY,0)) end P'+dbo.fnPadLeft('0',2,@v_cnt);
 
				SET @vdaysup  = @vdaysup + ',' + 'SUM(isnull(P'+ dbo.fnPadLeft('0',2,@v_cnt)+',0)) AS ' + '"' + dbo.fnPadLeft('0',2,@v_cnt) + '"';
 
				SET @vtotsup  = @vtotsup + '+' + 'isnull(P'+ dbo.fnPadLeft ('0',2,@v_cnt)+',0)';


			END
   
			fetch NEXT FROM c1 INTO @vdt11,@vday11
		END 
	
print('asadasa')	
		
		close c1
		
		SET @vtotsup  = 'SUM(' + @vtotsup + ')' 
		--insert into test1(vstring,vstring2) values('1 '||vquery1,vdaysup||','||vtotsup||'AS "TOTAL"');
		
		SET @vquery3  = 'SELECT COMP_CODE,UNIT_CODE,AGCD "AGENCY CODE",DPCD "AGENCY SUBCODE",substring(dbo.cir_get_agency(comp_code,unit_code,agcd,dpcd),1,50) "AGENCY NAME",      substring(dbo.cir_get_name_cir_agname(comp_code,unit_code,agcd,dpcd,2,' + '''' + @pdateformat + '''' + ','''',''''),1,50) "AGENCY ONAME",         EDTN,dbo.CIR_GET_EDTN_NAME(COMP_CODE,EDTN) "EDITION NAME",isnull(dbo.CIR_GET_NAME_CIR_EDTN(COMP_CODE,'''',EDTN,2,' + '''' + @pdateformat + '''' + ','''',''''),''NA'') "EDITION ONAME",         isnull(CITY_CODE,''NA'') "CITY CODE",isnull(dbo.CIR_GET_CITY(COMP_CODE,CITY_CODE),''NA'') "CITY NAME",isnull(dbo.CIR_GET_NAME_CIR_CITY(COMP_CODE,CITY_CODE,2,' + '''' + @pdateformat + '''' + ','''',''''),''NA'') "CITY ONAME",         isnull(DIST_CODE,''NA'') "DIST CODE",isnull(dbo.CIR_GET_DIST(COMP_CODE,STATE_CODE,DIST_CODE),''NA'') "DISTRICT NAME",isnull(dbo.CIR_GET_NAME_CIR_DISTRICT(COMP_CODE,DIST_CODE,2,' + '''' + @pdateformat + '''' + ','''',''''),''NA'') "DISTRICT ONAME",         COUNTRY_CODE "COUNTRY CODE",' + @vdaysup + ',' + @vtotsup + 'AS "TOTAL"' + ' FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,A.EDTN EDTN,B.CITY_CODE,B.STATE_CODE STATE_CODE,B.DIST_CODE DIST_CODE,B.COUNTRY_CODE COUNTRY_CODE,' + @vquery1 
		SET @vquery2  = ' FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C          WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=''' + @pcomp_code + ''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=''' + @punit_code + ''' AND  A.AGCD=B.AGCD AND A.DPCD=B.DPCD AND A.PUBL=''' + @ppubl + ''' AND (A.EDTN=''' + @pedtn + ''' OR''' + @pedtn + ''' IS NULL ' + ' OR ''' + @pedtn + ''' = '''' ) AND (B.CITY_CODE=''' + @pcitycd + ''' OR''' + @pcitycd + ''' IS NULL ' + ' OR ''' + @pcitycd + ''' = '''' ) AND          (B.DIST_CODE=''' + @pdistcd + ''' OR''' + @pdistcd + ''' IS NULL ' + ' OR ''' + @pdistcd + ''' = '''') AND A.SUP_TYPE_CODE=C.SUP_TY_CODE AND          A.SUPDATE BETWEEN''' + @vfrdt + ''' AND''' + @vtodt + ''' AND isnull(A.SUP_COPY,0)>0          GROUP BY A.COMP_CODE,A.UNIT_CODE,A.AGCD,A.DPCD,A.SUPDATE,A.EDTN,B.CITY_CODE,B.STATE_CODE,B.DIST_CODE,B.COUNTRY_CODE)  m        GROUP BY m.COMP_CODE,m.UNIT_CODE,m.AGCD,m.DPCD,m.EDTN,m.CITY_CODE,m.STATE_CODE,m.DIST_CODE,m.COUNTRY_CODE          ORDER BY m.COMP_CODE,m.UNIT_CODE,m.STATE_CODE,m.DIST_CODE,m.CITY_CODE,m.EDTN,m.AGCD,m.DPCD' 
		--insert into test1(vstring,vstring2) values('2 '||vquery3,VQUERY2);commit;
		
		
	EXEC (@vquery3 + @vquery2)
		SET @vquery3  = 'SELECT COMP_CODE,UNIT_CODE,isnull(DIST_CODE,''NA'') "DIST CODE",isnull(dbo.CIR_GET_DIST(COMP_CODE,STATE_CODE,DIST_CODE),''NA'') "DISTRICT NAME",isnull(dbo.CIR_GET_NAME_CIR_DISTRICT(COMP_CODE,DIST_CODE,2,' + '''' + @pdateformat + '''' + ','''',''''),''NA'') "DISTRICT ONAME",COUNTRY_CODE "COUNTRY CODE",' + @vdaysup + ',' + @vtotsup + 'AS "TOTAL"' + ' FROM (SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,B.STATE_CODE STATE_CODE,B.DIST_CODE DIST_CODE,B.COUNTRY_CODE COUNTRY_CODE,' + @vquery1 
		SET @vquery2  = '  FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C          WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=''' + @pcomp_code + ''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=''' + @punit_code + ''' AND          A.AGCD=B.AGCD AND A.DPCD=B.DPCD AND A.PUBL=''' + @ppubl + ''' AND (A.EDTN=''' + @pedtn + ''' OR''' + @pedtn + ''' IS NULL ' + ' OR ''' + @pedtn + ''' = '''' ) AND (B.CITY_CODE=''' + @pcitycd + ''' OR''' + @pcitycd + ''' IS NULL ' + ' OR ''' + @pcitycd + ''' = '''') AND          (B.DIST_CODE=''' + @pdistcd + ''' OR''' + @pdistcd + ''' IS NULL ' + ' OR ''' + @pdistcd + ''' = '''') AND A.SUP_TYPE_CODE=C.SUP_TY_CODE AND          A.SUPDATE BETWEEN''' + @vfrdt + ''' AND''' + @vtodt + ''' AND isnull(A.SUP_COPY,0)>0          GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE,B.STATE_CODE,B.DIST_CODE,B.COUNTRY_CODE) o         GROUP BY o.COMP_CODE,o.UNIT_CODE,o.STATE_CODE,o.DIST_CODE,o.COUNTRY_CODE          ORDER BY o.COMP_CODE,o.UNIT_CODE,o.DIST_CODE,o.STATE_CODE' 
		
EXEC (@vquery3 + @vquery2)
		SET @vquery3  = 'SELECT COMP_CODE,UNIT_CODE,' + @vdaysup + ',' + @vtotsup + 'AS "TOTAL"' + ' FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,' + @vquery1 
		SET @vquery2  = ' FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C         WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=''' + @pcomp_code + ''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=''' + @punit_code + ''' AND          A.AGCD=B.AGCD AND A.DPCD=B.DPCD AND A.PUBL=''' + @ppubl + ''' AND (A.EDTN=''' + @pedtn + ''' OR''' + @pedtn + ''' IS NULL ' + ' OR ''' + @pedtn + ''' = '''' ) AND (B.CITY_CODE=''' + @pcitycd + ''' OR''' + @pcitycd + ''' IS NULL ' + ' OR ''' + @pcitycd + ''' = '''') AND          (B.DIST_CODE=''' + @pdistcd + ''' OR''' + @pdistcd + ''' IS NULL ' + ' OR ''' + @pdistcd + ''' = '''') AND A.SUP_TYPE_CODE=C.SUP_TY_CODE AND          A.SUPDATE BETWEEN''' + @vfrdt + ''' AND''' + @vtodt + ''' AND isnull(A.SUP_COPY,0)>0          GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE) q         GROUP BY q.COMP_CODE,q.UNIT_CODE          ORDER BY q.COMP_CODE,q.UNIT_CODE' 
	EXEC (@vquery3 + @vquery2)	
		
 DEALLOCATE c1






//******************************** End Issue no. 5466 ************************//

/**********************7-nov-2011 Laxman *****************/
CREATE PROCEDURE cir_festival_bind
    @pcompcode       as varchar(20),
    @pdateformat     as varchar(20),
    @puserid         as varchar(20),
    @pextra1         as varchar(20),
    @pextra2         as varchar(20)
as
begin
    select * from cir_festival_mast order by fest_name

end
CREATE PROCEDURE inct_slab_code_P 
    @pcompcode		AS varchar(20),
    @pdateformat	AS varchar(20),
    @pextra1 		AS varchar(200),
    @pextra2 		AS varchar(200) as
BEGIN
    DECLARE @vno         numeric(8)
    DECLARE @vtype_code  numeric(10)

     select @vno=max(inct_slab_id)+1 from cir_inct_slab_hdr where comp_code=@pcompcode
    
    If isnull(@vno,0)=0 Begin
        set @vtype_code=1
    End
    
    select @vtype_code as "VAR_CODE"
End
/**********************7-nov-2011 Laxman *****************/
/************************8-nov-2011 Laxman*******************/

ALTER procedure cir_route_droppoint_detail_p
    @pcompcode       AS varchar(20),
    @punitcode       AS varchar(20),
    @proutecode      AS varchar(20),
    @ptaxi_id        AS varchar(20),
    @puserid         AS varchar(20),
    @pdateformat     AS varchar(20),
    @pextra1         AS varchar(20),
    @pextra2         AS varchar(20),
    @pextra3         AS varchar(20),
    @pextra4         AS varchar(20),
    @pextra5         AS varchar(20),
    @pextra6         AS varchar(20),
    @pextra7         AS varchar(20),
    @pextra8         AS varchar(20),
    @pextra9         AS varchar(20),
    @pextra10        AS varchar(20)
  As
  Begin

  	    SELECT R.COMP_CODE COMP_CODE,R.UNIT_CODE UNIT_CODE,R.TAXI_ID TAXI_ID,M.VEHICLE_NO VEHICLE_NO, 
        M.RT_CODE RT_CODE,DBO.CIR_GET_ROUTE_NAME(R.COMP_CODE,R.UNIT_CODE,M.RT_CODE) ROUTE_NAME,
        R.DROP_POINT_CODE DROP_POINT_CODE,DBO.CIR_GET_DROP_POINT_NAME(R.COMP_CODE,R.UNIT_CODE,R.DROP_POINT_CODE,1) DROP_POINT_NAME, 
        R.ARRIVAL_TIME ARRIVAL_TIME,R.STOPPAGE_TIME STOPPAGE_TIME,P.LATITUDE LATITUDE,P.LOGNITUDE LOGNITUDE,R.DROP_POINT_SEQNO DROP_POINT_SEQNO 
        FROM CIR_TAXI_MAST M,CIR_TAXI_ROUTE R,CIR_DROP_POINT_MAST P
        WHERE M.COMP_CODE=R.COMP_CODE AND M.COMP_CODE=P.COMP_CODE AND R.COMP_CODE=@PCOMPCODE AND 
        M.UNIT_CODE=R.UNIT_CODE AND M.UNIT_CODE=P.UNIT_CODE AND R.UNIT_CODE=@PUNITCODE AND M.TAXI_ID=R.TAXI_ID AND 
        (R.TAXI_ID =@PTAXI_ID OR @PTAXI_ID IS NULL OR @PTAXI_ID='') AND (M.RT_CODE=@PROUTECODE) AND R.DROP_POINT_CODE=P.DROP_POINT
        ORDER BY ROUTE_NAME,DROP_POINT_SEQNO
                 
    select getdate() as "CUR_DATE"
                     
    select getdate() as "CUR_DATE"
  End 
/////////////////////////////////////////////////

CREATE PROCEDURE inct_slab_code_P 
    @pcompcode		AS varchar(20),
    @pdateformat	AS varchar(20),
    @pextra1 		AS varchar(200),
    @pextra2 		AS varchar(200) as
BEGIN
    DECLARE @vno         numeric(8)
    DECLARE @vtype_code  numeric(10)

     select @vno=max(inct_slab_id)+1 from cir_inct_slab_hdr where comp_code=@pcompcode
    
    If isnull(@vno,0)=0 Begin
        set @vtype_code=1
    End
    
    select @vtype_code as "VAR_CODE"
End
/*******************8-nov-2011********************************/


///////////////////issue no- 4869////////////////////////////////////////////

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[cir_rep_supply_cir_rep_supply_po]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@psupdate                                 VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000),--it is use for finalised or unfinalised
	@pextra2                                  VARCHAR(4000) 
AS
	DECLARE @vvty11				VARCHAR(2000)  
	DECLARE @vvty_sum11         VARCHAR(2000)  
	DECLARE @vvar               VARCHAR(4000) 
	DECLARE @vvar_sum           VARCHAR(4000) 
	DECLARE @vquery             VARCHAR(4000) 
	DECLARE @vquery1            VARCHAR(4000) 	
	DECLARE @vquery2            VARCHAR(4000) 
	DECLARE @vquery3            VARCHAR(4000) 	
    DECLARE @user_pfrom			VARCHAR(100)
	DECLARE @vsup_seq_no			INT
	DECLARE cur_sup_type cursor LOCAL FOR 
		select z.vty vty,z.vty_sum vty_sum,z.sup_seq_no sup_seq_no from 
		(SELECT 'SUM(CASE SUP_TYPE_CODE WHEN  '+''''+sup_ty_code+''''+' then sup_copy else 0 end) "'+sup_ty_name+'",' vty,
				'sum(case sup_type_code	when '+''''+sup_ty_code+''''+' then '+' sup_copy '+' else 0 end) +' vty_sum,sup_seq_no from cir_supply_type_mast 
		WHERE comp_code  = @pcomp_code /*and (upper(@pextra1)!='U' or @pextra1 is null)
		union
		SELECT 'SUM(CASE SUPPLY_TYPE_CODE WHEN  '+''''+sup_ty_code+''''+' then isnull(d.base_supply,0) else 0 end) "'+sup_ty_name+'",' vty,
				'sum(case supply_type_code	when '+''''+sup_ty_code+''''+' then '+' isnull(d.base_supply,0) '+' else 0 end) +' vty_sum,sup_seq_no from cir_supply_type_mast 
		WHERE comp_code  = @pcomp_code and upper(@pextra1)='U'*/)z
		order by sup_seq_no
		
		OPEN cur_sup_type 
			fetch NEXT FROM cur_sup_type INTO @vvty11 , @vvty_sum11,@vsup_seq_no
				WHILE (@@FETCH_STATUS = 0) 
				  BEGIN 
				   set @vvar =COALESCE(@vvar+'', SPACE(0)) + '' + COALESCE(@vvty11 + '', SPACE(0))
				   set @vvar_sum=COALESCE(@vvar_sum+'', SPACE(0)) + '' + COALESCE(@vvty_sum11 + '', SPACE(0))					
			fetch NEXT FROM cur_sup_type INTO @vvty11 , @vvty_sum11,@vsup_seq_no
		 END 
		close cur_sup_type

		SET @vvar  = SUBSTRING(@vvar, 1, LEN(@vvar) - 1)
		SET @vvar_sum  = SUBSTRING(@vvar_sum, 1, LEN(@vvar_sum) - 1)

        set @user_pfrom=(select dbo.convert_user_date('/',@psupdate,@pdateformat))

print(@psupdate)
print(@user_pfrom)
print(@pdateformat)
		
--SET @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,
--         dbo.cir_get_publ_name(d.comp_code,d.publ) publ_name,d.edtn EDTN,
--         dbo.cir_get_edtn_name(d.comp_code,d.edtn) "EDITION NAME", 
--         DBO.CONVERT_USER_DATE(''/'',d.supdate,'''+@pdateformat+''') SUPDATE,' + @vvar + ',' + @vvar_sum +' TOTAL,
--         dbo.cir_get_edtn_name(d.comp_code,e.main_edtn) MAINEDTN_NAME,
--         dbo.cir_get_edtn_seqno(d.comp_code,d.edtn) EDTN_SEQNO,
--         dbo.cir_get_edtn_seqno(d.comp_code,e.main_edtn) MAIN_EDTN_SEQNO from cir_dbksup d,cir_edtn_mast e
--         where d.comp_code=' + '''' + @pcomp_code + '''' + ' and d.comp_code=e.comp_code 
--         and d.unit_code=' + '''' + @punit_code + '''' + ' and d.unit_code=e.unit_code AND 
--         (d.publ='+''''+@ppubl+''''+' OR '+''''+@ppubl+''''+' IS NULL OR '+''''+@ppubl+''''+' ='''')  and d.publ=e.publ 
--         and d.supdate='+''''+@user_pfrom+''''+' and 
--         d.edtn=e.edtn 
--         group by d.comp_code,d.unit_code,d.publ,e.main_edtn,d.edtn,d.supdate 
--         order by d.comp_code,d.unit_code,d.publ,main_edtn_seqno,mainedtn_name,edtn_seqno,d.edtn,d.supdate' 
	
	SET @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,
         dbo.cir_get_publ_name(d.comp_code,d.publ) publ_name,d.edtn EDTN,
         dbo.cir_get_edtn_name(d.comp_code,d.edtn) "EDITION NAME", 
         DBO.CONVERT_USER_DATE(''/'',d.supdate,'''+@pdateformat+''') SUPDATE,' + @vvar + ',' 
         
	SET @vquery2=  @vvar_sum +' TOTAL,
         dbo.cir_get_edtn_name(d.comp_code,e.main_edtn) MAINEDTN_NAME,'''' SUPL_NAME,
         dbo.cir_get_edtn_seqno(d.comp_code,e.main_edtn) MAIN_EDTN_SEQNO,
         dbo.cir_get_edtn_seqno(d.comp_code,d.edtn) EDTN_SEQNO,'''' PAGE_NO,'''' AS SUPL_DETAIL from cir_dbksup d,cir_edtn_mast e
         where d.comp_code=' + '''' + @pcomp_code + '''' + ' and d.comp_code=e.comp_code 
         and d.unit_code=' + '''' + @punit_code + '''' + ' and d.unit_code=e.unit_code AND 
         (d.publ='+''''+@ppubl+''''+' OR '+''''+@ppubl+''''+' IS NULL OR '+''''+@ppubl+''''+' ='''')  and d.publ=e.publ 
         and d.supdate='+''''+@user_pfrom+''''+' and 
         d.edtn=e.edtn 
         group by d.comp_code,d.unit_code,d.publ,e.main_edtn,d.edtn,d.supdate 
         order by d.comp_code,d.unit_code,d.publ,main_edtn_seqno,mainedtn_name,edtn_seqno,d.edtn,d.supdate' 

        --SET @vquery1  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,
        -- dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,' + @vvar + ',' + @vvar_sum + 'TOTAL from cir_dbksup d where 
        -- d.comp_code=' + '''' + @pcomp_code + '''' + ' and d.unit_code=' + '''' + @punit_code + '''' + ' 
        -- and (d.publ='+''''+@ppubl+''''+' OR '+''''+@ppubl+''''+' IS NULL OR '+''''+@ppubl+''''+' ='''')
        --and d.supdate='+''''+@user_pfrom+''''+'         
        -- group by d.comp_code,d.unit_code,d.publ order by d.comp_code,d.unit_code,d.publ' 
        
	SET @vquery1  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,
         dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,' + @vvar + ',' 
	
	SET @vquery3  = @vvar_sum + 'TOTAL from cir_dbksup d where 
         d.comp_code=' + '''' + @pcomp_code + '''' + ' and d.unit_code=' + '''' + @punit_code + '''' + ' 
         and (d.publ='+''''+@ppubl+''''+' OR '+''''+@ppubl+''''+' IS NULL OR '+''''+@ppubl+''''+' ='''')
        and d.supdate='+''''+@user_pfrom+''''+'         
         group by d.comp_code,d.unit_code,d.publ order by d.comp_code,d.unit_code,d.publ' 
 
		print (@vquery + @vquery2)
		print (@vquery1 + @vquery3) 
		EXEC (@vquery + @vquery2)
		EXEC (@vquery1 + @vquery3) 

DEALLOCATE cur_sup_type
 






////////////////////end of procedure///////////////////////////////////////




/////////////////////function issue no-4869///////////////////////////////////
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER FUNCTION  [dbo].[cir_get_edtn_name] (@pcomp_code as varchar(100),@pedtn as varchar(100))  returns varchar(200)

AS  

BEGIN 
DECLARE @vedtn_name VARCHAR(4000)
select @vedtn_name=edtn_name from cir_edtn_mast where comp_code=@pcomp_code and edtn=@pedtn
	   
RETURN isnull(@vedtn_name,'')
END





////////////////////////end of function////////////////////////////////

//*******************************5257 11/11/2011 Ritu****************************//


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[cir_rep_return_sale](
      @pcompcode         as varchar(40),
      @punitcode         as varchar(40),
      @pbrancode         as varchar(40),
      @ppublcode         as varchar(40),
      @pmedtncode        as varchar(40),
      @pedtncode         as varchar(40),
      @pacc_code         as varchar(40),
      @pfrom_billdt      as datetime,
      @ptill_billdt      as datetime,
      @pdateformat       as varchar(40),
      @puserid           as varchar(40),
      @pextra1           as varchar(40),
      @pextra2           as varchar(40),
      @pextra3           as varchar(40),
      @pextra4           as varchar(40),
      @pextra5           as varchar(40))
    As
  Begin

        select x.comp_code as "COMP_CODE",x.unit_code as "UNIT_CODE",x.branch_code as "BRANCH_CODE",x.recptno as "RECPTNO",
        x.recptdt as "RECPTDT",x.acc_code as "ACC_CODE",x.acc_name as "ACC_NAME",
        x.tax1_type as "TAX1_TYPE",x.tax1_rate as "TAX1_RATE",x.tax2_type as "TAX2_TYPE",x.tax2_rate as "TAX2_RATE",
        x.publ_code as "PUBL_CODE",x.publ_name as "PUBL_NAME",
        x.main_edtn as "MAIN_EDTN",x.main_edtn_name as "MAIN_EDTN_NAME", x.edtn_code as "EDTN_CODE",x.edtn_name as "EDTN_NAME",
        x.edtn_rate as "EDTN_RATE",x.no_of_copy as "NO_OF_COPY",x.copy_rate as "COPY_RATE",x.copy_weight as "COPY_WEIGHT",
        x.grs_amt as "GRS_AMT",x.tax1_amt as "TAX1_AMT",x.tax2_amt as "TAX2_AMT",(x.grs_amt+x.tax1_amt+x.tax2_amt) as "BILL_AMT"
        from (select h.comp_code,h.unit_code,h.branch_code,h.recptno,h.recptdt,h.acc_code,m.acc_name,
        case when h.tax1_type<>'0' then h.tax1_type else null end tax1_type ,h.tax1_rate,
        case when h.tax2_type<>'0' then h.tax2_type else null end tax2_type,h.tax2_rate,d.publ_code,p.publ_name,
        e.main_edtn,dbo.cir_get_edtn_name(h.comp_code,e.main_edtn) main_edtn_name, d.edtn_code,e.edtn_name,
        d.edtn_rate,sum(d.no_of_copy) no_of_copy,d.copy_rate,sum(d.copy_weight) copy_weight,
        d.copy_rate*sum(d.copy_weight) grs_amt,
        case when h.tax1_type='P' then round((d.copy_rate*sum(d.copy_weight)*h.tax1_rate)/100,2) when h.tax1_type='F' then round(h.tax1_rate,2) else round(h.tax1_rate,2) end tax1_amt,
        case when h.tax2_type='P' then round((d.copy_rate*sum(d.copy_weight)*h.tax2_rate)/100,2) when h.tax2_type='F' then round(h.tax2_rate,2) else round(h.tax2_rate,2) end tax2_amt
        from  cir_return_sale_hdr h,cir_return_sale_det d,fa_acc_mast m,cir_publ_mast p, cir_edtn_mast e
        where h.comp_code=d.comp_code and h.comp_code=p.comp_code and h.comp_code=e.comp_code and h.comp_code=m.comp_code and  h.comp_code=@pcompcode and h.unit_code=d.unit_code  and  
        (h.unit_code=@punitcode or @punitcode is null or @punitcode='') and 
        h.doctype=d.doctype and h.doctype='RET' and h.recptno=d.recptno and h.recptdt=d.recptdt and h.recptdt between @pfrom_billdt and @ptill_billdt and
        (h.branch_code=@pbrancode or @pbrancode is null or @pbrancode='') and m.cdp=h.acc_code and d.publ_code=p.publ and (d.publ_code=isnull(@ppublcode,d.publ_code) or @ppublcode='')and 
        d.edtn_code=e.edtn and (d.edtn_code=isnull(@pedtncode,d.edtn_code) or @pedtncode='') and (e.main_edtn=isnull(@pmedtncode,e.main_edtn ) or @pmedtncode='')and 
        (h.acc_code=@pacc_code or @pacc_code is null or @pacc_code='')
        group by h.comp_code,h.unit_code,h.branch_code,h.recptno,h.recptdt,h.acc_code,m.ACC_NAME,
        h.tax1_type ,h.tax1_rate,h.tax2_type ,h.tax2_rate,d.publ_code,p.publ_name,e.main_edtn,d.edtn_code,e.edtn_name,
        d.edtn_rate,d.copy_rate) x
        order by comp_code,unit_code,recptdt,recptno,publ_name,main_edtn_name,edtn_name;
        
        select x.comp_code as "COMP_CODE",x.unit_code as "UNIT_CODE",x.branch_code as "BRANCH_CODE",x.recptno as "RECPTNO",x.recptdt as "RECPTDT",
        x.acc_code as "ACC_CODE",x.acc_name as "ACC_NAME",
        x.tax1_type as "TAX1_TYPE",x.tax1_rate AS "TAX1_RATE",x.tax2_type as "TAX2_TYPE",x.tax2_rate AS "TAX2_RATE",sum(x.no_of_copy) as "NO_OF_COPY",x.copy_rate as "COPY_RATE",sum(x.copy_weight) AS "COPY_WEIGHT",
        sum(x.grs_amt) AS "GRS_AMT",sum(x.tax1_amt) as "TAX1_AMT", sum(x.tax2_amt) as "TAX2_AMT",
        sum(x.grs_amt+x.tax1_amt+x.tax2_amt) as "BILL_AMT"
        from (select h.comp_code,h.unit_code,h.branch_code,h.recptno,h.recptdt,h.acc_code,m.acc_name,
        case when h.tax1_type<>'0' then h.tax1_type else null end tax1_type ,h.tax1_rate,
        case when h.tax2_type<>'0' then h.tax2_type else null end tax2_type,h.tax2_rate,d.publ_code,p.publ_name,
        e.main_edtn,dbo.cir_get_edtn_name(h.comp_code,e.main_edtn) main_edtn_name, d.edtn_code,e.edtn_name,
        d.edtn_rate,sum(d.no_of_copy) no_of_copy,d.copy_rate,sum(d.copy_weight) copy_weight,
        d.copy_rate*sum(d.no_of_copy) grs_amt,
        case when h.tax1_type='P' then round((d.copy_rate*sum(d.copy_weight)*h.tax1_rate)/100,2) when h.tax1_type='F' then round(h.tax1_rate,2) else round(h.tax1_rate,2) end tax1_amt,
        case when h.tax2_type='P' then round((d.copy_rate*sum(d.copy_weight)*h.tax2_rate)/100,2) when h.tax2_type='F' then round(h.tax2_rate,2) else round(h.tax2_rate,2) end tax2_amt
        from  cir_return_sale_hdr h,cir_return_sale_det d,fa_acc_mast m,cir_publ_mast p, cir_edtn_mast e
        where h.comp_code=d.comp_code and h.comp_code=p.comp_code and h.comp_code=e.comp_code and h.comp_code=m.comp_code and  h.comp_code=@pcompcode and h.unit_code=d.unit_code  and  
        (h.unit_code=@punitcode or @punitcode is null or @punitcode='') and 
        h.doctype=d.doctype and h.doctype='RET' and h.recptno=d.recptno and h.recptdt=d.recptdt and h.recptdt between @pfrom_billdt and @ptill_billdt and
        (h.branch_code=@pbrancode or @pbrancode is null or @pbrancode='') and m.cdp=h.acc_code and d.publ_code=p.publ and (d.publ_code=isnull(@ppublcode,d.publ_code) or @ppublcode='')and 
        d.edtn_code=e.edtn and (d.edtn_code=isnull(@pedtncode,d.edtn_code) or @pedtncode='') and (e.main_edtn=isnull(@pmedtncode,e.main_edtn ) or @pmedtncode='')and 
        (h.acc_code=@pacc_code or @pacc_code is null or @pacc_code='') and ISNULL(d.edtn_rate,0)>0
        group by h.comp_code,h.unit_code,h.branch_code,h.recptno,h.recptdt,h.acc_code,m.ACC_NAME,
        h.tax1_type ,h.tax1_rate,h.tax2_type ,h.tax2_rate,d.publ_code,p.publ_name,e.main_edtn,d.edtn_code,e.edtn_name,
        d.edtn_rate,d.copy_rate) x
        group by x.comp_code,x.unit_code,x.branch_code,x.recptno,x.recptdt,x.acc_code,x.acc_name,x.tax1_type ,x.tax1_rate,x.tax2_type,x.tax2_rate,x.copy_rate
        order by comp_code,unit_code,recptdt,recptno
        
        select getdate() as "CUR_DATE"
        
        select getdate() as "CUR_DATE"

End






/////////////////////////////////////end of issue////////////////////////////////////////////////////
/**************************11-nov-2011 sushil by mail*****************/
ALTER PROCEDURE [dbo].[FA_RPT_accountmast1_FA_RPT_accountmast1_p]
	@pcompcode                                VARCHAR(4000) ,
	@pmaingrpcode                             VARCHAR(4000) ,
	@pprmgrpcode                              VARCHAR(4000) ,
	@psecgrpcode                              VARCHAR(4000) ,
	@pthirdgrpcode                            VARCHAR(4000) --,
	--@P_Accounts                               T_Accounts_Cursor OUTPUT 
AS 
	BEGIN
		SET NOCOUNT ON
		
		
	--	OPEN p_accounts FOR 
		SELECT
				 ''''+MAIN_GROUP as "MAIN_GRP_CODE",
				 DBO.fa_main_group_name(@pcompcode, FA_ACC_MAST.MAIN_GROUP) as "MAIN_GRP_NAME",
				 ''''+PSUB_GROUP as "PSUB_GRP_CODE",
				 DBO.fa_psub_group_name(@pcompcode, FA_ACC_MAST.MAIN_GROUP, FA_ACC_MAST.PSUB_GROUP) as "PSUB_GRP_CODE",
				 ''''+SSUB_GROUP as "SSUB_GRP_CODE",
				 DBO.fa_ssub_group_name(@pcompcode, FA_ACC_MAST.MAIN_GROUP, FA_ACC_MAST.PSUB_GROUP, FA_ACC_MAST.SSUB_GROUP) as "SSUB_GRP_NAME",
				 ''''+TSUB_GROUP as "TSUB_GRP_CODE",
				 DBO.fa_tsub_group_name(@pcompcode, FA_ACC_MAST.MAIN_GROUP, FA_ACC_MAST.PSUB_GROUP, FA_ACC_MAST.SSUB_GROUP, FA_ACC_MAST.TSUB_GROUP) as "TSUB_GRP_NAME",
				 ''''+ACC_TY as "ACC_TYPE_CODE",
				 (		SELECT AC_TYPE_DESC
				FROM  FA_ACCOUNT_TYPE_MAST 
				WHERE	 FA_ACCOUNT_TYPE_MAST.AC_TYPE_CODE  = FA_ACC_MAST.ACC_TY
		) as "ACC_TYPE_NAME",
				 ''''+CDP AS CDP,
				 ACC_NAME,
				 ACC_NATURE
		FROM  FA_ACC_MAST 
		WHERE	 (COMP_CODE  = @pcompcode)
		 AND	(MAIN_GROUP  = @pmaingrpcode
		 OR	@pmaingrpcode  IS NULL)
		 AND	(PSUB_GROUP  = @pprmgrpcode
		 OR	@pprmgrpcode  IS NULL)
		 AND	(SSUB_GROUP  = @psecgrpcode
		 OR	@psecgrpcode  IS NULL)
		 AND	(TSUB_GROUP  = @pthirdgrpcode
		 OR	@pthirdgrpcode  IS NULL)
		ORDER BY MAIN_GROUP,
			 PSUB_GROUP,
			 SSUB_GROUP,
			 TSUB_GROUP,
			 CDP 
		

		SET NOCOUNT OFF

	END

///////////////////////////////////////////////////


ALTER procedure [dbo].[ad_pending_bills_for_budget](@pcomp_code varchar(10),@pason_date datetime,
@pextra1 varchar(10),@pextra2 varchar(10)) as
Begin

/*select pending_bill.COMP_CODE,dbo.get_agency_parent_child_region(pending_bill.COMP_CODE,pending_bill.ag_main_code,pending_bill.ag_sub_code,'P') parent_region,
       Agency_mast.Agency_Type_Code,(select Agency_Type_Name from Agency_type_mst where Comp_Code=pending_bill.comp_code and Agency_Type_Code=Agency_mast.Agency_Type_Code) as agency_type_name,
       pending_bill.ag_main_code,pending_bill.ag_sub_code,
       pending_bill.agcode,Agency_mast.Agency_Name+' '+(select '('+City_Name+')' from city_mst where Comp_Code=pending_bill.comp_code AND City_Code=Agency_mast.City_Code) Agency_Name,
       pending_bill.billno, (select max(ISNULL(clientcd,clientname)) from ad_bills where comp_code_v=pending_bill.COMP_CODE and bilno=pending_bill.billno) client_name,
       pending_bill.billdt,pending_bill.amount,
       case when billdt  between CONVERT(DATETIME,DATEADD(dd,-(DAY(@pason_date)-1),@pason_date),101) and DATEADD(dd,-(DAY(DATEADD(mm,1,@pason_date))),DATEADD(mm,1,@pason_date)) then pending_bill.amount else 0 end  as BBND,
       case when billdt  between DATEADD(dd,-(DAY(DATEADD(mm,-5,@pason_date))),DATEADD(mm,-5,@pason_date))+1 AND CONVERT(DATETIME,DATEADD(dd,-(DAY(@pason_date)-1),@pason_date),101)-1 then pending_bill.amount else 0 end  as DUE,
       case when billdt  between DATEADD(dd,-(DAY(DATEADD(mm,-11,@pason_date))),DATEADD(mm,-11,@pason_date))+1 AND DATEADD(dd,-(DAY(DATEADD(mm,-5,@pason_date))),DATEADD(mm,-5,@pason_date)) then pending_bill.amount else 0 end  as OD,
       case when billdt < DATEADD(dd,-(DAY(DATEADD(mm,-11,@pason_date))),DATEADD(mm,-11,@pason_date))+1  then pending_bill.amount else 0 end  as LOD from 
(select comp_code,ag_main_code,ag_sub_code,agcode,BILLNO,BILLDT,SUM(amount) amount from AD_OUTSTAND 
where comp_code=@pcomp_code and BILLDT<=@pason_date
group by comp_code,ag_main_code,ag_sub_code,agcode,BILLNO,BILLDT having SUM(amount)>0
union all
select comp_code,ag_main_code,ag_sub_code,agcode,RECPTNO,RECPTDT,SUM(amount) amount from AD_OUTSTAND 
where comp_code=@pcomp_code and RECPTDT <=@pason_date and BILLNO is null
group by comp_code,ag_main_code,ag_sub_code,agcode,RECPTNO,RECPTDT having SUM(amount)<0) 
pending_bill,agency_mast 
where pending_bill.ag_main_code=Agency_mast.Agency_Code 
  and pending_bill.ag_sub_code=Agency_mast.SUB_Agency_Code 
  and pending_bill.AGCODE     = Agency_mast.code_subcode 
order by Agency_mast.code_subcode,billdt*/


select pending_bill.COMP_CODE,dbo.get_agency_parent_child_region(pending_bill.COMP_CODE,pending_bill.ag_main_code,Agency_mast.SUB_Agency_Code,'P') parent_region,
       Agency_mast.Agency_Type_Code,(select Agency_Type_Name from Agency_type_mst where Comp_Code=pending_bill.comp_code and Agency_Type_Code=Agency_mast.Agency_Type_Code) as agency_type_name,
       pending_bill.ag_main_code,Agency_mast.SUB_Agency_Code ag_sub_code ,
       pending_bill.agcode,Agency_mast.Agency_Name+' '+(select '('+City_Name+')' from city_mst where Comp_Code=pending_bill.comp_code AND City_Code=Agency_mast.City_Code) Agency_Name,
       pending_bill.billno, (select max(ISNULL(clientcd,clientname)) from ad_bills where comp_code_v=pending_bill.COMP_CODE and bilno=pending_bill.billno) client_name,
       pending_bill.billdt,pending_bill.amount,
       case when billdt  between CONVERT(DATETIME,DATEADD(dd,-(DAY(@pason_date)-1),@pason_date),101) and DATEADD(dd,-(DAY(DATEADD(mm,1,@pason_date))),DATEADD(mm,1,@pason_date)) then pending_bill.amount else 0 end  as BBND,
       case when billdt  between DATEADD(dd,-(DAY(DATEADD(mm,-5,@pason_date))),DATEADD(mm,-5,@pason_date))+1 AND CONVERT(DATETIME,DATEADD(dd,-(DAY(@pason_date)-1),@pason_date),101)-1 then pending_bill.amount else 0 end  as DUE,
       case when billdt  between DATEADD(dd,-(DAY(DATEADD(mm,-11,@pason_date))),DATEADD(mm,-11,@pason_date))+1 AND DATEADD(dd,-(DAY(DATEADD(mm,-5,@pason_date))),DATEADD(mm,-5,@pason_date)) then pending_bill.amount else 0 end  as OD,
       case when billdt < DATEADD(dd,-(DAY(DATEADD(mm,-11,@pason_date))),DATEADD(mm,-11,@pason_date))+1  then pending_bill.amount else 0 end  as LOD from 
(select comp_code,ag_main_code,(SELECT MAX(AGCODE) FROM AD_BILLS WHERE COMP_CODE=AD_OUTSTAND.COMP_CODE AND BILNO = AD_OUTSTAND.BILLNO)agcode,BILLNO,BILLDT,SUM(amount) amount from AD_OUTSTAND 
where comp_code=@pcomp_code and BILLDT<=@pason_date  /*AND DOCTYPE not in ('DN','TD')*/
group by comp_code,ag_main_code,BILLNO,BILLDT having SUM(amount)>0
union all
select comp_code,ag_main_code,(SELECT MAX(AGCODE) FROM AD_RCPTHDR WHERE COMP_CODE=AD_OUTSTAND.COMP_CODE AND RECPTNO=AD_OUTSTAND.RECPTNO) agcode,RECPTNO,RECPTDT,SUM(amount) amount from AD_OUTSTAND 
where comp_code=@pcomp_code and RECPTDT <=@pason_date and BILLNO is null
group by comp_code,ag_main_code,RECPTNO,RECPTDT having SUM(amount)<0
/*union all
select comp_code,ag_main_code,(SELECT MAX(AGCODE) FROM AD_RCPTHDR WHERE COMP_CODE=AD_OUTSTAND.COMP_CODE AND RECPTNO=AD_OUTSTAND.RECPTNO) agcode,RECPTNO,RECPTDT,SUM(amount) amount from AD_OUTSTAND 
where comp_code=@pcomp_code and RECPTDT <=@pason_date and BILLNO is NOT null AND DOCTYPE in ('DN','TD')
group by comp_code,ag_main_code,RECPTNO,RECPTDT having SUM(amount)>0*/) 
pending_bill,agency_mast 
where pending_bill.ag_main_code=Agency_mast.Agency_Code 
  and pending_bill.AGCODE     = Agency_mast.code_subcode 
order by Agency_mast.code_subcode,billdt

End

/**************************11-nov-2011 sushil by mail*****************/


/////////////////////issue no-5023//////////procedure for taluka///////////////////////////////////////
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[cir_rep_unsold_supply_cir_edtn_unsold_supply]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@pdoc_type                                VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@pagcode                                  VARCHAR(20) ,
	@pdepocode                                VARCHAR(20) ,
	@pfromdate                                VARCHAR(20) ,
	@ptilldate                                VARCHAR(20) ,
	@papproved_flag                           VARCHAR(20) ,
	@ptaluka                                  VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 


AS 

		
		DECLARE @v_frdt                                   VARCHAR(20)
		DECLARE @v_todt                                  VARCHAR(20)





DECLARE	@pdoc_type11                                VARCHAR(20) 
DECLARE	@ppubl11                                    VARCHAR(20) 
DECLARE	@pmainedtn11                                VARCHAR(20) 
DECLARE	@pedtn11                                    VARCHAR(20) 
DECLARE	@pagcode11                                  VARCHAR(20) 
DECLARE	@pdepocode11                                VARCHAR(20) 
DECLARE	@ptaluka11                                  VARCHAR(20) 
DECLARE	@pextra111                                  VARCHAR(200) 
DECLARE	@pextra211                                  VARCHAR(200) 


set @pdoc_type11 = @pdoc_type
set @ppubl11 = @ppubl
set @pmainedtn11 = @pmainedtn
set @pedtn11 = @pedtn
set @pagcode11 = @pagcode
set @pdepocode11 = @pdepocode
set @ptaluka11 = @ptaluka



if(@pdoc_type = '')
begin
  set @pdoc_type = null;   
end
if(@ppubl = '')
begin
  set @ppubl = null;   
end
if(@pmainedtn = '')
begin
  set @pmainedtn = null;   
end
if(@pedtn = '')
begin
  set @pedtn = null;   
end
if(@pagcode = '')
begin
  set @pagcode = null;   
end
if(@pdepocode = '')
begin
  set @pdepocode = null;   
end
if(@ptaluka = '')
begin
  set @ptaluka = null;   
end
if(@pextra1 = '')
begin
  set @pextra1 = null;   
end
if(@pextra2 = '')
begin
  set @pextra2 = null;   
end










		DECLARE @v_query1                                 VARCHAR(8000) 








	DECLARE @vpubl1                                 VARCHAR(5) 
	DECLARE @vedtn1                                 VARCHAR(5)
	DECLARE @vedtn_name1                            VARCHAR(50)
	DECLARE @vedtn_seq_no1                          NUMERIC(18,0)

	

set @v_frdt=(select dbo.convert_user_date('/',@pfromdate,@pdateformat))
	set @v_todt=(select dbo.convert_user_date('/',@ptilldate,@pdateformat))


	DECLARE cur_edtn cursor LOCAL FOR 


    select distinct u.publ publ,u.edtn edtn,u.edtn_name edtn_name,u.edtn_seqno edtn_seq_no from
        (select distinct e.publ publ,e.edtn edtn,e.edtn_name edtn_name,e.edtn_seq_no edtn_seqno
        from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
        where a.comp_code=b.comp_code 
				and b.comp_code=e.comp_code 
				and b.comp_code=@pcomp_code 
				and a.unit=b.unit_code 
				and b.unit_code=e.unit_code 
				and b.unit_code=@punit_code 
				and b.doctype=@pdoc_type 
				and b.recptdt >= @v_frdt and b.recptdt<=@v_todt 
				and b.publ=e.publ 
				and b.publ=isnull(@ppubl,b.publ) 
				and b.edtn=e.edtn 
				and b.edtn=isnull(@pedtn,b.edtn) 
				and a.agcd=b.agcd 
				and a.dpcd=b.dpcd 
				and b.agcd=isnull(@pagcode,b.agcd) 
				and b.dpcd=isnull(@pdepocode,b.dpcd) 
				and (a.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka = '') 
				and isnull(@papproved_flag,'N')='Y' 
				and (isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0))>0
        union
        select distinct e.publ publ,e.edtn edtn,e.edtn_name edtn_name,e.edtn_seq_no edtn_seqno
        from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
        where a.comp_code=b.comp_code 
              and b.comp_code=e.comp_code 
              and b.comp_code=@pcomp_code 
              and a.unit=b.unit_code 
              and b.unit_code=e.unit_code 
              and b.unit_code=@punit_code 
              and b.doctype=@pdoc_type 
              and b.recptdt >= @v_frdt 
              and b.recptdt<=@v_todt 
              and b.publ=e.publ 
              and b.publ=isnull(@ppubl,b.publ) 
              and b.edtn=e.edtn 
              and b.edtn=isnull(@pedtn,b.edtn) 
              and a.agcd=b.agcd 
              and a.dpcd=b.dpcd 
              and b.agcd=isnull(@pagcode,b.agcd) 
              and b.dpcd=isnull(@pdepocode,b.dpcd) 
              and (a.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka = '') 
              and isnull(@papproved_flag,'N')='N' 
              and (isnull(short_recpt,0)+isnull(late_recpt,0)+isnull(bnr,0)+isnull(unsold,0))>0) u
        order by edtn_seq_no,edtn;


	
		



	--	DECLARE @rec_edtn                                 VARCHAR(200) /* SwisSQL (Oracle To SQL Server) : Table used in Cursor referenced here is not found in Metadata or Metadata not Updated*/ 
		DECLARE @vvar                                     VARCHAR(8000) 
		DECLARE @tot_vvar                                 VARCHAR(8000) 
		DECLARE @vtot_publ                                VARCHAR(4000) 
		DECLARE @v_cnt                                    FLOAT                           
		SET @v_cnt = 0 


--		SET @v_frdt  = DBO.CONVERT_USER_DATE('/', @pfromdate,@pdateformat)
--		SET @v_todt  = DBO.CONVERT_USER_DATE('/', @ptilldate,@pdateformat)
		




		OPEN cur_edtn 

	   fetch NEXT FROM cur_edtn INTO @vpubl1, @vedtn1 ,@vedtn_name1, @vedtn_seq_no1

            
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN 
			
			
			--	set @vvar        =@vvar+',round((case u.publ when '+''''+@publ_code+''''+' then sum(u.return_copy) end *100)/case u.publ when '+''''+@publ_code+''''+' then sum(u.supply_copy) end ,2) as "'+@publ_code+'_RETURN_PER"';

			SET @v_cnt  = ISNULL(@v_cnt, 0)+ 1 
			IF (@vvar is null) 
			BEGIN 
                       print('1')
				SET @vvar  = 'case u.edtn when  '+ '''' +  @vedtn1 + '''' + ' then sum(u.supply_copy) end as  "'+@vedtn1 +'_SUPPLY"' 
				SET @vvar  = COALESCE(@vvar+'', SPACE(0))  + COALESCE(',case u.edtn when ' + '''' +  @vedtn1 + '''' + ' then sum(u.return_copy) end as "' + @vedtn1 + '_RETURN"'+'', SPACE(0)) 
				SET @vvar  = COALESCE(@vvar+'', SPACE(0))  + COALESCE(',(((case u.edtn when  '+ '''' +  @vedtn1 + '''' + ' then sum(u.return_copy) end )*100)/(case u.edtn when  '+ '''' + @vedtn1 + '''' + 'then sum(u.supply_copy) else 2 end )) as "' + @vedtn1 + '_RETURN_PER"'+'', SPACE(0)) 
				SET @tot_vvar  = COALESCE(@tot_vvar+'', SPACE(0))  + COALESCE(',sum("' +  @vedtn1 + '_SUPPLY") "' +  @vedtn1 + '_SUPPLY"'+'', SPACE(0)) 
				SET @tot_vvar  = COALESCE(@tot_vvar+'', SPACE(0))  + COALESCE(',sum("' +  @vedtn1 + '_RETURN") "' + @vedtn1 + '_RETURN"'+'', SPACE(0)) 
				SET @tot_vvar  = COALESCE(@tot_vvar+'', SPACE(0))  + COALESCE(',sum("' +  @vedtn1 + '_RETURN_PER") "' + @vedtn1 + '_RETURN_PER"'+'', SPACE(0))
				SET @vtot_publ  =   @vedtn1
			END
			ELSE
			BEGIN 
                      print('1234')
				SET @vvar  = COALESCE(@vvar+'', SPACE(0)) +COALESCE(', case u.edtn when  '+ '''' +  @vedtn1 + '''' + ' then sum(u.supply_copy) end as  "'+@vedtn1 +'_SUPPLY"'+'', SPACE(0)) 
				SET @vvar  = COALESCE(@vvar+'', SPACE(0))  + COALESCE(',case u.edtn when ' + '''' +  @vedtn1 + '''' + ' then sum(u.return_copy) end as "' + @vedtn1 + '_RETURN"'+'', SPACE(0)) 
				SET @vvar  = COALESCE(@vvar+'', SPACE(0))  + COALESCE(',(((case u.edtn when  '+ '''' +  @vedtn1 + '''' + ' then sum(u.return_copy) end )*100)/(case u.edtn when  '+ '''' + @vedtn1 + '''' + 'then sum(u.supply_copy) else 2  end ))  as "' + @vedtn1 + '_RETURN_PER"'+'', SPACE(0)) 
				SET @tot_vvar  = COALESCE(@tot_vvar+'', SPACE(0)) + COALESCE(',sum("' +  @vedtn1 + '_SUPPLY") "' +  @vedtn1 + '_SUPPLY"'+'', SPACE(0)) 
				SET @tot_vvar  = COALESCE(@tot_vvar+'', SPACE(0)) + COALESCE(',sum("' +  @vedtn1 + '_RETURN") "' + @vedtn1 + '_RETURN"'+'', SPACE(0)) 
				SET @tot_vvar  = COALESCE(@tot_vvar+'', SPACE(0))+ COALESCE(',sum("' +  @vedtn1 + '_RETURN_PER") "' + @vedtn1 + '_RETURN_PER"'+'', SPACE(0)) 
				SET @vtot_publ  = COALESCE(@vtot_publ+'', SPACE(0))+  COALESCE( ', '  +  @vedtn1+'', SPACE(0))     
			END
   
		   fetch NEXT FROM cur_edtn INTO @vpubl1, @vedtn1 ,@vedtn_name1, @vedtn_seq_no1
		END 
		
		
		close cur_edtn


		  print('2')
 print(@v_frdt)
  print('21')
 print(@tot_vvar)
  print('22')
 print(@vtot_publ)
	print(@vvar)
		
		IF @vvar is not null 
		BEGIN 
			IF ISNULL(@papproved_flag, 'N')= 'Y' 
			BEGIN 
print('tt')
                SET @v_query1  = 'select c.comp_code comp_code,c.unit_code unit_code,c.agcd agcd,c.dpcd dpcd,c.agname agname,c.agname_oth_lang agname_oth_lang,
               isnull(DBO.cir_get_city(c.comp_code,c.city_code),''NA'') city_name,isnull( dbo.cir_get_taluka(c.comp_code,c.taluka_code),''NA'') taluka_name '+@tot_vvar+'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,dbo.cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,
               u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,u.city_code city_code,u.taluka_code taluka_code,'+@vvar
               +'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.tehsil_taluka taluka_code,
                            (select sum(sup_copy) from cir_dbksup
                            where comp_code=b.comp_code and unit_code=b.unit_code and
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='+''''+@pcomp_code+''''+' and
                               b.unit_code=a.unit and b.unit_code='+''''+@punit_code+''''+' and
                               b.doctype='+''''+@pdoc_type11+''''+' and b.recptdt between '+''''+@v_frdt+''''+' and '+''''+@v_todt+''''+' and
                               ((b.publ='+''''+@ppubl11+''''+') or ('+''''+@ppubl11+''''+' is null)  or (' + '''' + @ppubl11 + '''' + ' = ' + ''''')) and
                               ((b.edtn='+''''+@pedtn11+''''+') or ('+''''+@pedtn11+''''+' is null)  or (' + '''' + @pedtn11 + '''' + ' = ' + ''''')) and
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='+''''+@pagcode11+''''+') or ('+''''+@pagcode11+''''+' is null)  or (' + '''' + @pagcode11 + '''' + ' = ' + ''''')) and
                               ((b.dpcd='+''''+@pdepocode11+''''+') or ('+''''+@pdepocode11+''''+' is null) or (' + '''' + @pdepocode11 + '''' + ' = ' + ''''')) 
                               and ((a.tehsil_taluka='+''''+@ptaluka11+''''+') or ('+''''+@ptaluka11+''''+' is null) or (' + '''' + @ptaluka11 + '''' + ' = ' + ''''')) and
                               (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='+''''+@pcomp_code+''''+' and (edtn = '+''''+@pedtn11+''''+' or '+''''+@pedtn11+''''+' is null  or ' + '''' + @pedtn11 + '''' +' = '+ ''''' ) 
                               and (main_edtn='+''''+@pmainedtn11+''''+' or '+''''+@pmainedtn11+''''+' is null  or ' + '''' + @pmainedtn11 + '''' +' = '+ ''''' ))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,
                               u.city_code,u.taluka_code) c
                               group by c.comp_code,c.unit_code,c.agcd,c.dpcd,c.agname,c.agname_oth_lang,isnull(dbo.cir_get_city(c.comp_code,c.city_code),''NA''),
                               isnull(dbo.cir_get_taluka(c.comp_code,c.taluka_code),''NA'')
                               order by c.comp_code,c.unit_code,isnull(dbo.cir_get_taluka(c.comp_code,c.taluka_code),''NA''),c.agname';



			
				
				EXEC (@v_query1) 


    SET @v_query1  = 'select c.comp_code comp_code,c.unit_code unit_code,
                isnull(dbo.cir_get_taluka(c.comp_code,c.taluka_code),''NA'') taluka_name' + @tot_vvar + 
                ' from  (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,
                 dbo.cir_get_edtn_name(u.comp_code,u.edtn) edtn_name, u.taluka_code taluka_code,'
                 + @vvar   + ' from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                 b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang, a.city_code city_code,
                 a.tehsil_taluka taluka_code , (select sum(sup_copy) from cir_dbksup 
                 where comp_code=b.comp_code and unit_code=b.unit_code and agcd=b.agcd and dpcd=b.dpcd 
                 and publ=b.publ and supdate=b.supdate) supply_copy, isnull(b.apr_short_recpt,0)+
                 isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0) return_copy from cir_agmast a,
                 cir_unsold_dtl b where b.comp_code =a.comp_code and b.comp_code =' + '''' + @pcomp_code + '''' + ' 
                 and  b.unit_code=a.unit and b.unit_code=' + '''' + @punit_code + '''' + ' and b.doctype=' + '''' 
               +  @pdoc_type + '''' + ' and b.recptdt between' + '''' + @v_frdt + '''' + ' and' + '''' + @v_todt 
              +  '''' + ' and (b.publ=' + '''' + @ppubl11 + '''' + ' or ' + '''' + @ppubl11 + '''' + ' is null or ' + '''' + @ppubl11 + '''' + ' = ' + ''''') and 
                 ((b.edtn=' + '''' + @pedtn11 + '''' + ') or (' + '''' + @pedtn11 + '''' + ' is null) or (' + '''' + @pedtn11 + '''' + ' = ' + ''''') ) and a.agcd=b.agcd 
                 and a.dpcd=b.dpcd and ((b.agcd=' + '''' + @pagcode11 + '''' + ') or (' + '''' + @pagcode11 + '''' + ' 
                 is null) or (' + '''' + @pagcode11 + '''' + ' = ' + ''''')) and  ((b.dpcd=' + '''' + @pdepocode11 + '''' + ') or (' + '''' + @pdepocode11 + '''' + ' 
                 is null)  or (' + '''' + @pdepocode11 + '''' + ' = ' + ''''') ) and ((a.tehsil_taluka=' + '''' + @ptaluka11 + '''' + ') or (' + '''' + @ptaluka11 + '''' + ' 
                 is null) or (' + '''' + @ptaluka11 + '''' + ' = ' + ''''')) and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and 
                 b.edtn in(select distinct edtn from cir_edtn_mast where comp_code=' + '''' + @pcomp_code + '''' +
                 ' and (edtn =' + '''' + @pedtn11 + '''' + ' or' + '''' + @pedtn11 + '''' + ' is null  or ' + '''' + @pedtn11 + '''' +' = '+ ''''' ) 
                 and (main_edtn=' + '''' + @pmainedtn11 + '''' + ' or' + '''' + @pmainedtn11 + '''' + ' is null  or ' + '''' + @pmainedtn11 + '''' +' = '+ '''''   ))) u 
                 where u.supply_copy>0 group by u.comp_code,u.unit_code,u.publ,u.edtn,u.taluka_code) c 
                 group by c.comp_code,c.unit_code,isnull(dbo.cir_get_taluka(c.comp_code,c.taluka_code),''NA'')
                  order by c.comp_code,c.unit_code,isnull(dbo.cir_get_taluka(c.comp_code,c.taluka_code),''NA'')'
      		    


			
				
				EXEC (@v_query1)





                SET @v_query1  = 'select c.comp_code comp_code,c.unit_code unit_code' + @tot_vvar + ' from 
                (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,
                dbo.cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,' + @vvar + ' from (select b.comp_code comp_code,
                b.unit_code unit_code,b.publ publ,b.edtn edtn, b.agcd agcd,b.dpcd dpcd,a.ag_name agname,
                a.ag_name_oth_lang agname_oth_lang, a.city_code city_code,a.tehsil_taluka taluka_code,
                (select sum(sup_copy) from cir_dbksup where comp_code=b.comp_code and unit_code=b.unit_code and agcd=b.agcd
                and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy, isnull(b.apr_short_recpt,0)
                +isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0) return_copy from cir_agmast a,
                cir_unsold_dtl b where b.comp_code =a.comp_code and b.comp_code  =' + '''' + @pcomp_code + '''' + ' 
                and b.unit_code=a.unit and b.unit_code=' + '''' + @punit_code + '''' + ' and b.doctype=' + '''' + @pdoc_type + '''' + ' 
                and b.recptdt between' + '''' + @v_frdt + '''' + ' and' + '''' + @v_todt + '''' + ' 
                and (b.publ=' + '''' + @ppubl11 + '''' + ' or ' + '''' + @ppubl11 + '''' + ' is null or ' + '''' + @ppubl11 + '''' + ' = ' + ''''')
                and ((b.edtn=' + '''' + @pedtn11 + '''' + ') or 
                (' + '''' + @pedtn11 + '''' + ' is null) or (' + '''' + @pedtn11 + '''' + ' = ' + ''''')) 
                  and a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd=' + '''' + 
                @pagcode11 + '''' + ') or (' + '''' + @pagcode11 + '''' + ' is null) or (' + '''' + @pagcode11 + '''' + ' = ' + ''''')) 
                 and ((b.dpcd=' + '''' + @pdepocode11 + '''' + ') or (' + '''' + @pdepocode11 + '''' + ' is null)  or (' + '''' + @pdepocode11 + '''' + ' = ' + ''''')) 
                 and ((a.tehsil_taluka=' + '''' + @ptaluka11 + '''' + ') or (' + '''' + @ptaluka11 + '''' + ' is null) or (' + '''' + @ptaluka11 + '''' + ' = ' + ''''')) 
                and (isnull(apr_short_recpt,0)+
                 isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and b.edtn in(select distinct edtn
                 from cir_edtn_mast where comp_code=' + '''' + @pcomp_code + '''' + ' and (edtn =' + '''' + @pedtn11 
                 + '''' + ' or' + '''' + @pedtn11 + '''' + ' is null  or ' + '''' + @pedtn11 + '''' +' = '+ ''''') and (main_edtn=' + '''' + @pmainedtn11 + '''' 
                 + ' or' + '''' + @pmainedtn11 + '''' + ' is null  or ' + '''' + @pmainedtn11 + '''' +' = '+ '''''  ))) u  where u.supply_copy>0 group by u.comp_code,
                 u.unit_code,u.publ,u.edtn,dbo.cir_get_edtn_name(u.comp_code,u.edtn))c group by c.comp_code,c.unit_code
                 order by c.comp_code,c.unit_code' 

 
--	print(@v_query1)
			
				
				EXEC (@v_query1) 
			END
			ELSE
			BEGIN 
print('rr')
                   SET @v_query1  = 'select c.comp_code comp_code,c.unit_code unit_code,c.agcd agcd,c.dpcd dpcd,c.agname agname,c.agname_oth_lang agname_oth_lang,
               isnull(DBO.cir_get_city(c.comp_code,c.city_code),''NA'') city_name,isnull( dbo.cir_get_taluka(c.comp_code,c.taluka_code),''NA'') taluka_name '+@tot_vvar+'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,dbo.cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,
               u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,u.city_code city_code,u.taluka_code taluka_code,'+@vvar
               +'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.tehsil_taluka taluka_code,
                            (select sum(sup_copy) from cir_dbksup
                            where comp_code=b.comp_code and unit_code=b.unit_code and
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            isnull(b.short_recpt,0)+isnull(b.late_recpt,0)+isnull(b.bnr,0)+isnull(b.unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='+''''+@pcomp_code+''''+' and
                               b.unit_code=a.unit and b.unit_code='+''''+@punit_code+''''+' and
                               b.doctype='+''''+@pdoc_type11+''''+' and b.recptdt between '+''''+@v_frdt+''''+' and '+''''+@v_todt+''''+' and
                               ((b.publ='+''''+@ppubl11+''''+') or ('+''''+@ppubl11+''''+' is null)  or (' + '''' + @ppubl11 + '''' + ' = ' + ''''')) and
                               ((b.edtn='+''''+@pedtn11+''''+') or ('+''''+@pedtn11+''''+' is null)  or (' + '''' + @pedtn11 + '''' + ' = ' + ''''')) and
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='+''''+@pagcode11+''''+') or ('+''''+@pagcode11+''''+' is null)  or (' + '''' + @pagcode11 + '''' + ' = ' + ''''')) and
                               ((b.dpcd='+''''+@pdepocode11+''''+') or ('+''''+@pdepocode11+''''+' is null) or (' + '''' + @pdepocode11 + '''' + ' = ' + ''''')) 
                               and ((a.tehsil_taluka='+''''+@ptaluka11+''''+') or ('+''''+@ptaluka11+''''+' is null) or (' + '''' + @ptaluka11 + '''' + ' = ' + ''''')) and (isnull(short_recpt,0)+isnull(late_recpt,0)+
                               isnull(bnr,0)+isnull(unsold,0))>0  and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='+''''+@pcomp_code+''''+' and (edtn = '+''''+@pedtn11+''''+' or '+''''+@pedtn11+''''+' is null  or ' + '''' + @pedtn11 + '''' +' = '+ ''''' ) 
                               and (main_edtn='+''''+@pmainedtn11+''''+' or '+''''+@pmainedtn11+''''+' is null  or ' + '''' + @pmainedtn11 + '''' +' = '+ ''''' ))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,
                               u.city_code,u.taluka_code) c
                               group by c.comp_code,c.unit_code,c.agcd,c.dpcd,c.agname,c.agname_oth_lang,isnull(dbo.cir_get_city(c.comp_code,c.city_code),''NA''),
                               isnull(dbo.cir_get_taluka(c.comp_code,c.taluka_code),''NA'')
                               order by c.comp_code,c.unit_code,isnull(dbo.cir_get_taluka(c.comp_code,c.taluka_code),''NA''),c.agname';



print(@v_query1)

				
				
				EXEC (@v_query1) 

                SET @v_query1  = 'select c.comp_code comp_code,c.unit_code unit_code,
                isnull(dbo.cir_get_taluka(c.comp_code,c.taluka_code),''NA'') taluka_name' + @tot_vvar + 
                ' from  (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,
                 dbo.cir_get_edtn_name(u.comp_code,u.edtn) edtn_name, u.taluka_code taluka_code,'
                 + @vvar   + ' from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                 b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang, a.city_code city_code,
                 a.tehsil_taluka taluka_code , (select sum(sup_copy) from cir_dbksup 
                 where comp_code=b.comp_code and unit_code=b.unit_code and agcd=b.agcd and dpcd=b.dpcd 
                 and publ=b.publ and supdate=b.supdate) supply_copy,  isnull(b.short_recpt,0)+isnull(b.late_recpt,0)+isnull(b.bnr,0)+isnull(b.unsold,0) 
                return_copy  from cir_agmast a,
                 cir_unsold_dtl b where b.comp_code =a.comp_code and b.comp_code =' + '''' + @pcomp_code + '''' + ' 
                 and  b.unit_code=a.unit and b.unit_code=' + '''' + @punit_code + '''' + ' and b.doctype=' + '''' 
               +  @pdoc_type + '''' + ' and b.recptdt between' + '''' + @v_frdt + '''' + ' and' + '''' + @v_todt 
              +  '''' + ' and (b.publ=' + '''' + @ppubl11 + '''' + ' or ' + '''' + @ppubl11 + '''' + ' is null or ' + '''' + @ppubl11 + '''' + ' = ' + ''''') and 
                 ((b.edtn=' + '''' + @pedtn11 + '''' + ') or (' + '''' + @pedtn11 + '''' + ' is null) or (' + '''' + @pedtn11 + '''' + ' = ' + ''''') ) and a.agcd=b.agcd 
                 and a.dpcd=b.dpcd and ((b.agcd=' + '''' + @pagcode11 + '''' + ') or (' + '''' + @pagcode11 + '''' + ' 
                 is null) or (' + '''' + @pagcode11 + '''' + ' = ' + ''''')) and  ((b.dpcd=' + '''' + @pdepocode11 + '''' + ') or (' + '''' + @pdepocode11 + '''' + ' 
                 is null)  or (' + '''' + @pdepocode11 + '''' + ' = ' + ''''') ) and ((a.tehsil_taluka=' + '''' + @ptaluka11 + '''' + ') or (' + '''' + @ptaluka11 + '''' + ' 
                 is null) or (' + '''' + @ptaluka11 + '''' + ' = ' + ''''')) and   (isnull(short_recpt,0)+isnull(late_recpt,0)+isnull(bnr,0)+
                isnull(unsold,0))>0 and 
                 b.edtn in(select distinct edtn from cir_edtn_mast where comp_code=' + '''' + @pcomp_code + '''' +
                 ' and (edtn =' + '''' + @pedtn11 + '''' + ' or' + '''' + @pedtn11 + '''' + ' is null  or ' + '''' + @pedtn11 + '''' +' = '+ ''''' ) 
                 and (main_edtn=' + '''' + @pmainedtn11 + '''' + ' or' + '''' + @pmainedtn11 + '''' + ' is null  or ' + '''' + @pmainedtn11 + '''' +' = '+ '''''   ))) u 
                 where u.supply_copy>0 group by u.comp_code,u.unit_code,u.publ,u.edtn,u.taluka_code) c 
                 group by c.comp_code,c.unit_code,isnull(dbo.cir_get_taluka(c.comp_code,c.taluka_code),''NA'')
                  order by c.comp_code,c.unit_code,isnull(dbo.cir_get_taluka(c.comp_code,c.taluka_code),''NA'')'
      		    





			
				
				EXEC (@v_query1)

               
                SET @v_query1  = 'select c.comp_code comp_code,c.unit_code unit_code' + @tot_vvar + ' from 
                (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,
                dbo.cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,' + @vvar + ' from (select b.comp_code comp_code,
                b.unit_code unit_code,b.publ publ,b.edtn edtn, b.agcd agcd,b.dpcd dpcd,a.ag_name agname,
                a.ag_name_oth_lang agname_oth_lang, a.city_code city_code,a.tehsil_taluka taluka_code,
                (select sum(sup_copy) from cir_dbksup where comp_code=b.comp_code and unit_code=b.unit_code and agcd=b.agcd
                and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy, 
                isnull(b.short_recpt,0)+isnull(b.late_recpt,0)+isnull(b.bnr,0)+isnull(b.unsold,0) return_copy from cir_agmast a,
                cir_unsold_dtl b where b.comp_code =a.comp_code and b.comp_code  =' + '''' + @pcomp_code + '''' + ' 
                and b.unit_code=a.unit and b.unit_code=' + '''' + @punit_code + '''' + ' and b.doctype=' + '''' + @pdoc_type + '''' + ' 
                and b.recptdt between' + '''' + @v_frdt + '''' + ' and' + '''' + @v_todt + '''' + ' 
                and (b.publ=' + '''' + @ppubl11 + '''' + ' or ' + '''' + @ppubl11 + '''' + ' is null or ' + '''' + @ppubl11 + '''' + ' = ' + ''''')
                and ((b.edtn=' + '''' + @pedtn11 + '''' + ') or 
                (' + '''' + @pedtn11 + '''' + ' is null) or (' + '''' + @pedtn11 + '''' + ' = ' + ''''')) 
                  and a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd=' + '''' + 
                @pagcode11 + '''' + ') or (' + '''' + @pagcode11 + '''' + ' is null) or (' + '''' + @pagcode11 + '''' + ' = ' + ''''')) 
                 and ((b.dpcd=' + '''' + @pdepocode11 + '''' + ') or (' + '''' + @pdepocode11 + '''' + ' is null)  or (' + '''' + @pdepocode11 + '''' + ' = ' + ''''')) 
                 and ((a.tehsil_taluka=' + '''' + @ptaluka11 + '''' + ') or (' + '''' + @ptaluka11 + '''' + ' is null) or (' + '''' + @ptaluka11 + '''' + ' = ' + ''''')) 
                 and  (isnull(short_recpt,0)+isnull(late_recpt,0)+isnull(bnr,0)+
                isnull(unsold,0))>0 and b.edtn in(select distinct edtn
                 from cir_edtn_mast where comp_code=' + '''' + @pcomp_code + '''' + ' and (edtn =' + '''' + @pedtn11 
                 + '''' + ' or' + '''' + @pedtn11 + '''' + ' is null  or ' + '''' + @pedtn11 + '''' +' = '+ ''''') and (main_edtn=' + '''' + @pmainedtn11 + '''' 
                 + ' or' + '''' + @pmainedtn11 + '''' + ' is null  or ' + '''' + @pmainedtn11 + '''' +' = '+ '''''  ))) u  where u.supply_copy>0 group by u.comp_code,
                 u.unit_code,u.publ,u.edtn,dbo.cir_get_edtn_name(u.comp_code,u.edtn))c group by c.comp_code,c.unit_code
                 order by c.comp_code,c.unit_code' 


				
				
				EXEC (@v_query1) 
                print('45')

			END
   
			SET @v_query1  = 'select ' + @vtot_publ  
			EXEC (@v_query1) 
		END
		ELSE
		BEGIN 
print('bb')
			SET @v_query1  = 'select' + '''' + @pcomp_code + '''' + ' comp_code,' + '''' + @punit_code + '''' + 
            ' unit_code,null agcd,null dpcd,null agname,null agname_oth_lang,null city_name,null taluka_name,
             0 supply_copy,0 return_copy ' 
			
			print(@v_query1)
			EXEC (@v_query1)
			SET @v_query1  = 'select' + '''' + @pcomp_code + '''' + ' comp_code,' + '''' + @punit_code + '''' +
            ' unit_code,null taluka_name,0 supply_copy,0 return_copy ' 
		
			print(@v_query1)
			EXEC (@v_query1 )
			SET @v_query1  = 'select' + '''' + @pcomp_code + '''' + ' comp_code,' + '''' + @punit_code + '''' + 
           ' unit_code,0 supply_copy,0 return_copy ' 
		
			print(@v_query1)
			EXEC (@v_query1 )
			SET @v_query1  = 'select getdate() ' 
print(@v_query1)
			EXEC (@v_query1 )
		END
   
 DEALLOCATE cur_edtn


////////////////////////////end procedure///////////////////////////////////



///////////////////////////////////procedure for district////////////////////////////////////////
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go






ALTER PROCEDURE [dbo].[cir_rep_unsold_supply_cir_edtn_unsold_supply_dist]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@pdoc_type                                VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pmainedtn                                VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@pagcode                                  VARCHAR(20) ,
	@pdepocode                                VARCHAR(20) ,
	@pfromdate                                VARCHAR(20) ,
	@ptilldate                                VARCHAR(20) ,
	@papproved_flag                           VARCHAR(20) ,
	@pdistcd                                  VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(200) ,
	@pextra2                                  VARCHAR(200) 
AS 
	
		
		DECLARE @v_frdt                                   VARCHAR(20)
		DECLARE @v_todt                                   VARCHAR(20)
		DECLARE @v_query1                                 VARCHAR(8000) 
        DECLARE @vpubl1                                 VARCHAR(200) 
        DECLARE @vedtn1                                 VARCHAR(200) 
        DECLARE @vedtn_name1                            VARCHAR(200) 
        DECLARE @vedtn_seq_no1                          numeric(20,0) 



DECLARE	@pdoc_type11                                VARCHAR(20) 
DECLARE	@ppubl11                                    VARCHAR(20) 
DECLARE	@pmainedtn11                                VARCHAR(20) 
DECLARE	@pedtn11                                    VARCHAR(20) 
DECLARE	@pagcode11                                  VARCHAR(20) 
DECLARE	@pdepocode11                                VARCHAR(20) 
DECLARE	@pdistcd11                                  VARCHAR(20) 
DECLARE	@pextra111                                  VARCHAR(200) 
DECLARE	@pextra211                                  VARCHAR(200) 


set @pdoc_type11 = @pdoc_type
set @ppubl11 = @ppubl
set @pmainedtn11 = @pmainedtn
set @pedtn11 = @pedtn
set @pagcode11 = @pagcode
set @pdepocode11 = @pdepocode
set @pdistcd11 = @pdistcd



if(@pdoc_type = '')
begin
  set @pdoc_type = null;   
end
if(@ppubl = '')
begin
  set @ppubl = null;   
end
if(@pmainedtn = '')
begin
  set @pmainedtn = null;   
end
if(@pedtn = '')
begin
  set @pedtn = null;   
end
if(@pagcode = '')
begin
  set @pagcode = null;   
end
if(@pdepocode = '')
begin
  set @pdepocode = null;   
end
if(@pdistcd = '')
begin
  set @pdistcd = null;   
end
if(@pextra1 = '')
begin
  set @pextra1 = null;   
end
if(@pextra2 = '')
begin
  set @pextra2 = null;   
end

    
	set @v_frdt=(select dbo.convert_user_date('/',@pfromdate,@pdateformat))
	set @v_todt=(select dbo.convert_user_date('/',@ptilldate,@pdateformat))



		DECLARE cur_edtn cursor LOCAL FOR 


        select distinct u.publ publ,u.edtn edtn,u.edtn_name edtn_name,u.edtn_seqno edtn_seq_no from
        (select distinct e.publ publ,e.edtn edtn,e.edtn_name edtn_name,e.edtn_seq_no edtn_seqno
        from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
        where a.comp_code=b.comp_code 
				and b.comp_code=e.comp_code 
				and b.comp_code=@pcomp_code 
				and a.unit=b.unit_code 
				and b.unit_code=e.unit_code 
				and b.unit_code=@punit_code 
				and b.doctype=@pdoc_type 
				and b.recptdt >= @v_frdt and b.recptdt<=@v_todt 
				and b.publ=e.publ 
				and b.publ=isnull(@ppubl,b.publ) 
				and b.edtn=e.edtn 
				and b.edtn=isnull(@pedtn,b.edtn) 
				and a.agcd=b.agcd 
				and a.dpcd=b.dpcd 
				and b.agcd=isnull(@pagcode,b.agcd) 
				and b.dpcd=isnull(@pdepocode,b.dpcd) 
				and (a.dist_code=@pdistcd or @pdistcd is null or @pdistcd = '') 
				and isnull(@papproved_flag,'N')='Y' 
				and (isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0))>0
        union
        select distinct e.publ publ,e.edtn edtn,e.edtn_name edtn_name,e.edtn_seq_no edtn_seqno
        from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
        where a.comp_code=b.comp_code 
              and b.comp_code=e.comp_code 
              and b.comp_code=@pcomp_code 
              and a.unit=b.unit_code 
              and b.unit_code=e.unit_code 
              and b.unit_code=@punit_code 
              and b.doctype=@pdoc_type 
              and b.recptdt >= @v_frdt 
              and b.recptdt<=@v_todt 
              and b.publ=e.publ 
              and b.publ=isnull(@ppubl,b.publ) 
              and b.edtn=e.edtn 
              and b.edtn=isnull(@pedtn,b.edtn) 
              and a.agcd=b.agcd 
              and a.dpcd=b.dpcd 
              and b.agcd=isnull(@pagcode,b.agcd) 
              and b.dpcd=isnull(@pdepocode,b.dpcd) 
              and (a.dist_code=@pdistcd or @pdistcd is null or @pdistcd = '') 
              and isnull(@papproved_flag,'N')='N' 
              and (isnull(short_recpt,0)+isnull(late_recpt,0)+isnull(bnr,0)+isnull(unsold,0))>0) u
        order by edtn_seq_no,edtn;

--		SELECT DISTINCT publ, edtn, edtn_name, edtn_seq_no	FROM  cir_edtn_mast 
--		WHERE	 comp_code  = @pcomp_code AND	(publ  = @ppubl OR	@ppubl  is null or @ppubl='')
--		AND	edtn  in(SELECT DISTINCT b.edtn FROM  cir_agmast a, cir_unsold_dtl b 
--		WHERE	 b.comp_code  = a.comp_code AND	b.comp_code  = @pcomp_code	 
--        AND	b.unit_code  = a.unit
--		AND	b.unit_code  = @punit_code 
--        AND	b.doctype  = @pdoc_type AND	b.recptdt  between @v_frdt  and  @v_todt
--		AND	(b.publ  = @ppubl OR @ppubl  is null or @ppubl='') 
--        AND	(b.publ  = @pedtn OR	@pedtn  is null or  @pedtn='')
--		AND	a.agcd  = b.agcd AND	a.dpcd  = b.dpcd 
--        AND	(b.agcd  = @pagcode OR	@pagcode  is null or @pagcode='')
--		AND	(b.dpcd  = @pdepocode OR	@pdepocode  is null or @pdepocode='') 
--        AND	(a.dist_code  = @pdistcd OR	@pdistcd  is null OR	@pdistcd  ='')
--		AND	(ISNULL(@papproved_flag, 'N')  = 'Y' 
--        AND	(ISNULL(b.apr_short_recpt, 0) + ISNULL(b.apr_late_recpt, 0) + ISNULL(b.apr_bnr, 0) + ISNULL(b.apr_unsold, 0))  > 0)
--		OR	(ISNULL(@papproved_flag, 'N')  = 'N' 
--        AND	(ISNULL(short_recpt, 0) + ISNULL(late_recpt, 0) + ISNULL(bnr, 0) + ISNULL(unsold, 0))  > 0))
--		ORDER BY edtn_seq_no, edtn 
		
		DECLARE @vvar                                     VARCHAR(8000) 
		DECLARE @tot_vvar                                 VARCHAR(8000) 
		DECLARE @vtot_publ                                VARCHAR(4000) 
		DECLARE @v_cnt                                    FLOAT                           
		SET @v_cnt = 0 



		
		OPEN cur_edtn 
        	fetch NEXT FROM cur_edtn INTO @vpubl1, @vedtn1 ,@vedtn_name1, @vedtn_seq_no1
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN 	

			SET @v_cnt  = ISNULL(@v_cnt, 0)+ 1 
          
            PRINT(@vedtn1)
              PRINT(@vedtn_name1)

			IF (@vvar is null) 
			BEGIN 
                       print('1')
				SET @vvar  = 'case u.edtn when  '+ '''' +  @vedtn1 + '''' + ' then sum(u.supply_copy) end as  "'+@vedtn1 +'_SUPPLY"' 
				SET @vvar  = COALESCE(@vvar+'', SPACE(0))  + COALESCE(',case u.edtn when ' + '''' +  @vedtn1 + '''' + ' then sum(u.return_copy) end as "' + @vedtn1 + '_RETURN"'+'', SPACE(0)) 
				SET @vvar  = COALESCE(@vvar+'', SPACE(0))  + COALESCE(',(((case u.edtn when  '+ '''' +  @vedtn1 + '''' + ' then sum(u.return_copy) end )*100)/(case u.edtn when  '+ '''' + @vedtn1 + '''' + 'then sum(u.supply_copy) else 2 end )) as "' + @vedtn1 + '_RETURN_PER"'+'', SPACE(0)) 
				SET @tot_vvar  = COALESCE(@tot_vvar+'', SPACE(0))  + COALESCE(',sum("' +  @vedtn1 + '_SUPPLY") "' +  @vedtn1 + '_SUPPLY"'+'', SPACE(0)) 
				SET @tot_vvar  = COALESCE(@tot_vvar+'', SPACE(0))  + COALESCE(',sum("' +  @vedtn1 + '_RETURN") "' + @vedtn1 + '_RETURN"'+'', SPACE(0)) 
				SET @tot_vvar  = COALESCE(@tot_vvar+'', SPACE(0))  + COALESCE(',sum("' +  @vedtn1 + '_RETURN_PER") "' + @vedtn1 + '_RETURN_PER"'+'', SPACE(0))
				SET @vtot_publ  =   @vedtn1
			END
			ELSE
			BEGIN 
                      print('1234')
				SET @vvar  = COALESCE(@vvar+'', SPACE(0)) +COALESCE(', case u.edtn when  '+ '''' +  @vedtn1 + '''' + ' then sum(u.supply_copy) end as  "'+@vedtn1 +'_SUPPLY"'+'', SPACE(0)) 
				SET @vvar  = COALESCE(@vvar+'', SPACE(0))  + COALESCE(',case u.edtn when ' + '''' +  @vedtn1 + '''' + ' then sum(u.return_copy) end as "' + @vedtn1 + '_RETURN"'+'', SPACE(0)) 
				SET @vvar  = COALESCE(@vvar+'', SPACE(0))  + COALESCE(',(((case u.edtn when  '+ '''' +  @vedtn1 + '''' + ' then sum(u.return_copy) end )*100)/(case u.edtn when  '+ '''' + @vedtn1 + '''' + 'then sum(u.supply_copy) else 2  end ))  as "' + @vedtn1 + '_RETURN_PER"'+'', SPACE(0)) 
				SET @tot_vvar  = COALESCE(@tot_vvar+'', SPACE(0)) + COALESCE(',sum("' +  @vedtn1 + '_SUPPLY") "' +  @vedtn1 + '_SUPPLY"'+'', SPACE(0)) 
				SET @tot_vvar  = COALESCE(@tot_vvar+'', SPACE(0)) + COALESCE(',sum("' +  @vedtn1 + '_RETURN") "' + @vedtn1 + '_RETURN"'+'', SPACE(0)) 
				SET @tot_vvar  = COALESCE(@tot_vvar+'', SPACE(0))+ COALESCE(',sum("' +  @vedtn1 + '_RETURN_PER") "' + @vedtn1 + '_RETURN_PER"'+'', SPACE(0)) 
				SET @vtot_publ  = COALESCE(@vtot_publ+'', SPACE(0))+  COALESCE( ', '  +  @vedtn1+'', SPACE(0))     
			END
   
			fetch NEXT FROM cur_edtn INTO @vpubl1, @vedtn1 ,@vedtn_name1, @vedtn_seq_no1
		END 
		
		
		close cur_edtn
		  print('2')
 print(@v_frdt)
  print('21')
 print(@tot_vvar)
  print('22')
 print(@vtot_publ)
		IF @vvar is not null 
		BEGIN 
			IF ISNULL(@papproved_flag, 'N')= 'Y' 
			BEGIN 
--print('sfssd')

SET @v_query1  = 'select c.comp_code comp_code,c.unit_code unit_code,c.agcd agcd,c.dpcd dpcd,c.agname agname,c.agname_oth_lang agname_oth_lang,
               isnull(DBO.cir_get_city(c.comp_code,c.city_code),''NA'') city_name,isnull(dbo.cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'') dist_name '+@tot_vvar+'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,dbo.cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,
               u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,u.city_code city_code,u.state_code state_code,u.dist_code dist_code,'+@vvar
               +'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.state_code state_code,a.dist_code,
                            (select sum(sup_copy) from cir_dbksup
                            where comp_code=b.comp_code and unit_code=b.unit_code and
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='+''''+@pcomp_code+''''+' and
                               b.unit_code=a.unit and b.unit_code='+''''+@punit_code+''''+' and
                               b.doctype='+''''+@pdoc_type11+''''+' and b.recptdt between '+''''+@v_frdt+''''+' and '+''''+@v_todt+''''+' and
                               ((b.publ='+''''+@ppubl11+''''+') or ('+''''+@ppubl11+''''+' is null)  or (' + '''' + @ppubl11 + '''' + ' = ' + ''''')) and
                               ((b.edtn='+''''+@pedtn11+''''+') or ('+''''+@pedtn11+''''+' is null)  or (' + '''' + @pedtn11 + '''' + ' = ' + ''''')) and
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='+''''+@pagcode11+''''+') or ('+''''+@pagcode11+''''+' is null)  or (' + '''' + @pagcode11 + '''' + ' = ' + ''''')) and
                               ((b.dpcd='+''''+@pdepocode11+''''+') or ('+''''+@pdepocode11+''''+' is null) or (' + '''' + @pdepocode11 + '''' + ' = ' + ''''')) and ((a.dist_code='+''''+@pdistcd11+''''+') or ('+''''+@pdistcd11+''''+' is null) or (' + '''' + @pdistcd11 + '''' + ' = ' + ''''')) and
                               (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='+''''+@pcomp_code+''''+' and (edtn = '+''''+@pedtn11+''''+' or '+''''+@pedtn11+''''+' is null  or ' + '''' + @pedtn11 + '''' +' = '+ ''''' ) and (main_edtn='+''''+@pmainedtn11+''''+' or '+''''+@pmainedtn11+''''+' is null  or ' + '''' + @pmainedtn11 + '''' +' = '+ ''''' ))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,
                               u.city_code,u.state_code,u.dist_code) c
                               group by c.comp_code,c.unit_code,c.agcd,c.dpcd,c.agname,c.agname_oth_lang,isnull(dbo.cir_get_city(c.comp_code,c.city_code),''NA''),
                               isnull(dbo.cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'')
                               order by c.comp_code,c.unit_code,isnull(dbo.cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA''),c.agname';




 

                EXEC (@v_query1)
				
                SET @v_query1  = 'select c.comp_code comp_code,c.unit_code unit_code,
                isnull(dbo.cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'') dist_name' + @tot_vvar + 
                ' from  (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,
                 dbo.cir_get_edtn_name(u.comp_code,u.edtn) edtn_name, u.state_code state_code,u.dist_code dist_code,'
                 + @vvar   + ' from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                 b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang, a.city_code city_code,
                 a.state_code state_code,a.dist_code dist_code, (select sum(sup_copy) from cir_dbksup 
                 where comp_code=b.comp_code and unit_code=b.unit_code and agcd=b.agcd and dpcd=b.dpcd 
                 and publ=b.publ and supdate=b.supdate) supply_copy, isnull(b.apr_short_recpt,0)+
                 isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0) return_copy from cir_agmast a,
                 cir_unsold_dtl b where b.comp_code =a.comp_code and b.comp_code =' + '''' + @pcomp_code + '''' + ' 
                 and  b.unit_code=a.unit and b.unit_code=' + '''' + @punit_code + '''' + ' and b.doctype=' + '''' 
               +  @pdoc_type + '''' + ' and b.recptdt between' + '''' + @v_frdt + '''' + ' and' + '''' + @v_todt 
              +  '''' + ' and (b.publ=' + '''' + @ppubl11 + '''' + ' or ' + '''' + @ppubl11 + '''' + ' is null or ' + '''' + @ppubl11 + '''' + ' = ' + ''''') and 
                 ((b.edtn=' + '''' + @pedtn11 + '''' + ') or (' + '''' + @pedtn11 + '''' + ' is null) or (' + '''' + @pedtn11 + '''' + ' = ' + ''''') ) and a.agcd=b.agcd 
                 and a.dpcd=b.dpcd and ((b.agcd=' + '''' + @pagcode11 + '''' + ') or (' + '''' + @pagcode11 + '''' + ' 
                 is null) or (' + '''' + @pagcode11 + '''' + ' = ' + ''''')) and  ((b.dpcd=' + '''' + @pdepocode11 + '''' + ') or (' + '''' + @pdepocode11 + '''' + ' 
                 is null)  or (' + '''' + @pdepocode11 + '''' + ' = ' + ''''') ) and ((a.dist_code=' + '''' + @pdistcd11 + '''' + ') or (' + '''' + @pdistcd11 + '''' + ' 
                 is null) or (' + '''' + @pdistcd11 + '''' + ' = ' + ''''')) and (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and 
                 b.edtn in(select distinct edtn from cir_edtn_mast where comp_code=' + '''' + @pcomp_code + '''' +
                 ' and (edtn =' + '''' + @pedtn11 + '''' + ' or' + '''' + @pedtn11 + '''' + ' is null  or ' + '''' + @pedtn11 + '''' +' = '+ ''''' ) 
                 and (main_edtn=' + '''' + @pmainedtn11 + '''' + ' or' + '''' + @pmainedtn11 + '''' + ' is null  or ' + '''' + @pmainedtn11 + '''' +' = '+ '''''   ))) u 
                 where u.supply_copy>0 group by u.comp_code,u.unit_code,u.publ,u.edtn,u.state_code,u.dist_code) c 
                 group by c.comp_code,c.unit_code,isnull(dbo.cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'')
                  order by c.comp_code,c.unit_code,isnull(dbo.cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'')'
      		    

 print('4'+@v_query1)

                EXEC (@v_query1) 

				SET @v_query1  = 'select c.comp_code comp_code,c.unit_code unit_code' + @tot_vvar + ' from 
                (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,
                dbo.cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,' + @vvar + ' from (select b.comp_code comp_code,
                b.unit_code unit_code,b.publ publ,b.edtn edtn, b.agcd agcd,b.dpcd dpcd,a.ag_name agname,
                a.ag_name_oth_lang agname_oth_lang, a.city_code city_code,a.state_code state_code,a.dist_code dist_code,
                (select sum(sup_copy) from cir_dbksup where comp_code=b.comp_code and unit_code=b.unit_code and agcd=b.agcd
                and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy, isnull(b.apr_short_recpt,0)
                +isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0) return_copy from cir_agmast a,
                cir_unsold_dtl b where b.comp_code =a.comp_code and b.comp_code  =' + '''' + @pcomp_code + '''' + ' 
                and b.unit_code=a.unit and b.unit_code=' + '''' + @punit_code + '''' + ' and b.doctype=' + '''' + @pdoc_type + '''' + ' 
                and b.recptdt between' + '''' + @v_frdt + '''' + ' and' + '''' + @v_todt + '''' + ' 
                and (b.publ=' + '''' + @ppubl11 + '''' + ' or ' + '''' + @ppubl11 + '''' + ' is null or ' + '''' + @ppubl11 + '''' + ' = ' + ''''')
                and ((b.edtn=' + '''' + @pedtn11 + '''' + ') or 
                (' + '''' + @pedtn11 + '''' + ' is null) or (' + '''' + @pedtn11 + '''' + ' = ' + ''''')) 
                  and a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd=' + '''' + 
                @pagcode11 + '''' + ') or (' + '''' + @pagcode11 + '''' + ' is null) or (' + '''' + @pagcode11 + '''' + ' = ' + ''''')) 
                 and ((b.dpcd=' + '''' + @pdepocode11 + '''' + ') or (' + '''' + @pdepocode11 + '''' + ' is null)  or (' + '''' + @pdepocode11 + '''' + ' = ' + ''''')) 
                 and ((a.dist_code=' + '''' + @pdistcd11 + '''' + ') or (' + '''' + @pdistcd11 + '''' + ' is null) or (' + '''' + @pdistcd11 + '''' + ' = ' + ''''')) 
                and (isnull(apr_short_recpt,0)+
                 isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and b.edtn in(select distinct edtn
                 from cir_edtn_mast where comp_code=' + '''' + @pcomp_code + '''' + ' and (edtn =' + '''' + @pedtn11 
                 + '''' + ' or' + '''' + @pedtn11 + '''' + ' is null  or ' + '''' + @pedtn11 + '''' +' = '+ ''''') and (main_edtn=' + '''' + @pmainedtn11 + '''' 
                 + ' or' + '''' + @pmainedtn11 + '''' + ' is null  or ' + '''' + @pmainedtn11 + '''' +' = '+ '''''  ))) u  where u.supply_copy>0 group by u.comp_code,
                 u.unit_code,u.publ,u.edtn,dbo.cir_get_edtn_name(u.comp_code,u.edtn))c group by c.comp_code,c.unit_code
                 order by c.comp_code,c.unit_code' 


print('3'+@v_query1)

				EXEC (@v_query1) 
			END
			ELSE
			BEGIN 

                SET @v_query1  = 'select c.comp_code comp_code,c.unit_code unit_code,c.agcd agcd,c.dpcd dpcd,c.agname agname,c.agname_oth_lang agname_oth_lang,
               isnull(DBO.cir_get_city(c.comp_code,c.city_code),''NA'') city_name,isnull(dbo.cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'') dist_name '+@tot_vvar+'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,dbo.cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,
               u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,u.city_code city_code,u.state_code state_code,u.dist_code dist_code,'+@vvar
               +'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.state_code state_code,a.dist_code,
                            (select sum(sup_copy) from cir_dbksup
                            where comp_code=b.comp_code and unit_code=b.unit_code and
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                             isnull(b.short_recpt,0)+isnull(b.late_recpt,0)+isnull(b.bnr,0)+isnull(b.unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='+''''+@pcomp_code+''''+' and
                               b.unit_code=a.unit and b.unit_code='+''''+@punit_code+''''+' and
                               b.doctype='+''''+@pdoc_type11+''''+' and b.recptdt between '+''''+@v_frdt+''''+' and '+''''+@v_todt+''''+' and
                               ((b.publ='+''''+@ppubl11+''''+') or ('+''''+@ppubl11+''''+' is null)  or (' + '''' + @ppubl11 + '''' + ' = ' + ''''')) and
                               ((b.edtn='+''''+@pedtn11+''''+') or ('+''''+@pedtn11+''''+' is null)  or (' + '''' + @pedtn11 + '''' + ' = ' + ''''')) and
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='+''''+@pagcode11+''''+') or ('+''''+@pagcode11+''''+' is null)  or (' + '''' + @pagcode11 + '''' + ' = ' + ''''')) and
                               ((b.dpcd='+''''+@pdepocode11+''''+') or ('+''''+@pdepocode11+''''+' is null) or (' + '''' + @pdepocode11 + '''' + ' = ' + ''''')) and ((a.dist_code='+''''+@pdistcd11+''''+') or ('+''''+@pdistcd11+''''+' is null) or (' + '''' + @pdistcd11 + '''' + ' = ' + '''''))
                               and (isnull(short_recpt,0)+isnull(late_recpt,0)+
                               isnull(bnr,0)+isnull(unsold,0))>0 
                                 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='+''''+@pcomp_code+''''+' and (edtn = '+''''+@pedtn11+''''+' or '+''''+@pedtn11+''''+' is null  or ' + '''' + @pedtn11 + '''' +' = '+ ''''' ) and (main_edtn='+''''+@pmainedtn11+''''+' or '+''''+@pmainedtn11+''''+' is null  or ' + '''' + @pmainedtn11 + '''' +' = '+ ''''' ))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,
                               u.city_code,u.state_code,u.dist_code) c
                               group by c.comp_code,c.unit_code,c.agcd,c.dpcd,c.agname,c.agname_oth_lang,isnull(dbo.cir_get_city(c.comp_code,c.city_code),''NA''),
                               isnull(dbo.cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'')
                               order by c.comp_code,c.unit_code,isnull(dbo.cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA''),c.agname';



    			EXEC (@v_query1) 
	
                      SET @v_query1  = 'select c.comp_code comp_code,c.unit_code unit_code,
                isnull(dbo.cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'') dist_name' + @tot_vvar + 
                ' from  (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,
                 dbo.cir_get_edtn_name(u.comp_code,u.edtn) edtn_name, u.state_code state_code,u.dist_code dist_code,'
                 + @vvar   + ' from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                 b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang, a.city_code city_code,
                 a.state_code state_code,a.dist_code dist_code, (select sum(sup_copy) from cir_dbksup 
                 where comp_code=b.comp_code and unit_code=b.unit_code and agcd=b.agcd and dpcd=b.dpcd 
                 and publ=b.publ and supdate=b.supdate) supply_copy, isnull(b.short_recpt,0)+isnull(b.late_recpt,0)+isnull(b.bnr,0)+isnull(b.unsold,0) return_copy
                  from cir_agmast a,
                 cir_unsold_dtl b where b.comp_code =a.comp_code and b.comp_code =' + '''' + @pcomp_code + '''' + ' 
                 and  b.unit_code=a.unit and b.unit_code=' + '''' + @punit_code + '''' + ' and b.doctype=' + '''' 
               +  @pdoc_type + '''' + ' and b.recptdt between' + '''' + @v_frdt + '''' + ' and' + '''' + @v_todt 
              +  '''' + ' and (b.publ=' + '''' + @ppubl11 + '''' + ' or ' + '''' + @ppubl11 + '''' + ' is null or ' + '''' + @ppubl11 + '''' + ' = ' + ''''') and 
                 ((b.edtn=' + '''' + @pedtn11 + '''' + ') or (' + '''' + @pedtn11 + '''' + ' is null) or (' + '''' + @pedtn11 + '''' + ' = ' + ''''') ) and a.agcd=b.agcd 
                 and a.dpcd=b.dpcd and ((b.agcd=' + '''' + @pagcode11 + '''' + ') or (' + '''' + @pagcode11 + '''' + ' 
                 is null) or (' + '''' + @pagcode11 + '''' + ' = ' + ''''')) and  ((b.dpcd=' + '''' + @pdepocode11 + '''' + ') or (' + '''' + @pdepocode11 + '''' + ' 
                 is null)  or (' + '''' + @pdepocode11 + '''' + ' = ' + ''''') ) and ((a.dist_code=' + '''' + @pdistcd11 + '''' + ') or (' + '''' + @pdistcd11 + '''' + ' 
                 is null) or (' + '''' + @pdistcd11 + '''' + ' = ' + ''''')) 
                 and (isnull(short_recpt,0)+isnull(late_recpt,0)+isnull(bnr,0)+isnull(unsold,0))>0 and 
                 b.edtn in(select distinct edtn from cir_edtn_mast where comp_code=' + '''' + @pcomp_code + '''' +
                 ' and (edtn =' + '''' + @pedtn11 + '''' + ' or' + '''' + @pedtn11 + '''' + ' is null  or ' + '''' + @pedtn11 + '''' +' = '+ ''''' ) 
                 and (main_edtn=' + '''' + @pmainedtn11 + '''' + ' or' + '''' + @pmainedtn11 + '''' + ' is null  or ' + '''' + @pmainedtn11 + '''' +' = '+ '''''   ))) u 
                 where u.supply_copy>0 group by u.comp_code,u.unit_code,u.publ,u.edtn,u.state_code,u.dist_code) c 
                 group by c.comp_code,c.unit_code,isnull(dbo.cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'')
                  order by c.comp_code,c.unit_code,isnull(dbo.cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'')'
      		    



--print(@v_query1)

     		
				EXEC (@v_query1) 


               	SET @v_query1  = 'select c.comp_code comp_code,c.unit_code unit_code' + @tot_vvar + ' from 
                (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,
                dbo.cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,' + @vvar + ' from (select b.comp_code comp_code,
                b.unit_code unit_code,b.publ publ,b.edtn edtn, b.agcd agcd,b.dpcd dpcd,a.ag_name agname,
                a.ag_name_oth_lang agname_oth_lang, a.city_code city_code,a.state_code state_code,a.dist_code dist_code,
                (select sum(sup_copy) from cir_dbksup where comp_code=b.comp_code and unit_code=b.unit_code and agcd=b.agcd
                and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy, isnull(b.short_recpt,0)+isnull(b.late_recpt,0)+isnull(b.bnr,0)+isnull(b.unsold,0) return_copy  
                 from cir_agmast a,
                cir_unsold_dtl b where b.comp_code =a.comp_code and b.comp_code  =' + '''' + @pcomp_code + '''' + ' 
                and b.unit_code=a.unit and b.unit_code=' + '''' + @punit_code + '''' + ' and b.doctype=' + '''' + @pdoc_type + '''' + ' 
                and b.recptdt between' + '''' + @v_frdt + '''' + ' and' + '''' + @v_todt + '''' + ' 
                and (b.publ=' + '''' + @ppubl11 + '''' + ' or ' + '''' + @ppubl11 + '''' + ' is null or ' + '''' + @ppubl11 + '''' + ' = ' + ''''')
                and ((b.edtn=' + '''' + @pedtn11 + '''' + ') or 
                (' + '''' + @pedtn11 + '''' + ' is null) or (' + '''' + @pedtn11 + '''' + ' = ' + ''''')) 
                  and a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd=' + '''' + 
                @pagcode11 + '''' + ') or (' + '''' + @pagcode11 + '''' + ' is null) or (' + '''' + @pagcode11 + '''' + ' = ' + ''''')) 
                 and ((b.dpcd=' + '''' + @pdepocode11 + '''' + ') or (' + '''' + @pdepocode11 + '''' + ' is null)  or (' + '''' + @pdepocode11 + '''' + ' = ' + ''''')) 
                 and ((a.dist_code=' + '''' + @pdistcd11 + '''' + ') or (' + '''' + @pdistcd11 + '''' + ' is null) or (' + '''' + @pdistcd11 + '''' + ' = ' + ''''')) 
               and     
                            (isnull(short_recpt,0)+isnull(late_recpt,0)+isnull(bnr,0)+isnull(unsold,0))>0 and b.edtn in(select distinct edtn
                 from cir_edtn_mast where comp_code=' + '''' + @pcomp_code + '''' + ' and (edtn =' + '''' + @pedtn11 
                 + '''' + ' or' + '''' + @pedtn11 + '''' + ' is null  or ' + '''' + @pedtn11 + '''' +' = '+ ''''') and (main_edtn=' + '''' + @pmainedtn11 + '''' 
                 + ' or' + '''' + @pmainedtn11 + '''' + ' is null  or ' + '''' + @pmainedtn11 + '''' +' = '+ '''''  ))) u  where u.supply_copy>0 group by u.comp_code,
                 u.unit_code,u.publ,u.edtn,dbo.cir_get_edtn_name(u.comp_code,u.edtn))c group by c.comp_code,c.unit_code
                 order by c.comp_code,c.unit_code' 



			 
				EXEC (@v_query1) 
			END
   
			SET @v_query1  = 'select ' + @vtot_publ  
             print(@v_query1)

			EXEC (@v_query1) 
		END
		ELSE
		BEGIN 
			SET @v_query1  = 'select' + '''' + @pcomp_code + '''' + ' comp_code,' + '''' + @punit_code + '''' + ' unit_code,null agcd,null dpcd,null agname,null agname_oth_lang,null city_name,null taluka_name,0 supply_copy,0 return_copy ' 
		--	print('33'+@v_query1)
            EXEC (@v_query1) 
			SET @v_query1  = 'select' + '''' + @pcomp_code + '''' + ' comp_code,' + '''' + @punit_code + '''' + ' unit_code,null taluka_name,0 supply_copy,0 return_copy ' 
			EXEC (@v_query1) 
			SET @v_query1  = 'select' + '''' + @pcomp_code + '''' + ' comp_code,' + '''' + @punit_code + '''' + ' unit_code,0 supply_copy,0 return_copy ' 
			EXEC (@v_query1) 
			SET @v_query1  = 'select null ' 
			EXEC (@v_query1) 
		END
   
 DEALLOCATE cur_edtn







/////////////////////////////////end of issue no-5023////////////////////////////////////////

//**********************************5381*****************************************************//

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


/////////////////////////0005435 
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




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
		
//----------------------17/nov/11/ rinki (unsold user permission)--------------------//
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER procedure [dbo].[cir_Publ_unsold_return_p] (
     @pcomp_code as varchar(50),
     @pbillfreq as varchar(50),
     @pdateformat as varchar(50),
     @pextra1 as varchar(50),
     @pextra2 as varchar(50)
     ) as
   Begin
      
      --select * from CIR_UNSOLD_RETURN_CONTROL where (BILL_FREQ=@pbillfreq OR @pbillfreq IS NULL or @pbillfreq='');
      select z.COMP_CODE, z.BILL_FREQ, z.PUBL_CODE, z.NO_OF_DAYS, z.INSERT_ID, z.CREATED_BY, z.CREATED_DT, z.UPDATED_BY, z.UPDATED_DT, 
      z.UNIT_CODE, z.BRANCH_CODE, z.REG_CODE, z.EDTN_CODE, z.PERM_PER ,
      (select Pub_Cent_name from pub_cent_mast x where z.COMP_CODE=@pcomp_code and x.Pub_cent_Code= z.UNIT_CODE) as "UNIT", 
      (select Branch_Name from branch_mst x where z.COMP_CODE=@pcomp_code and x.Branch_Code= z.BRANCH_CODE) as "BRANCH", 
      dbo.cir_get_region_name(z.COMP_CODE ,z.REG_CODE) as "REG" ,
      x.EDTN_NAME as "SEDTN",
      dbo.cir_get_edtn_name(z.COMP_CODE,x.main_edtn) as "MEDTN",
      dbo.cir_get_publ_name(z.COMP_CODE ,z.PUBL_CODE) as "PUBL"
      ,x.MAIN_EDTN as "EDTN", z.ZONE_CODE AS "ZONE_CODE",dbo.cir_get_zone_name(z.COMP_CODE ,z.ZONE_CODE) as "ZONE" 
      from CIR_UNSOLD_RETURN_CONTROL z,cir_edtn_mast x where z.COMP_CODE=@pcomp_code 
      and x.EDTN=z.EDTN_CODE and x.cOMP_CODE=z.cOMP_CODE and (BILL_FREQ=@pbillfreq OR @pbillfreq IS NULL);
      
     
     select * from cir_publ_mast  order by publ;
     
     
     SELECT MAX(INSERT_ID) INSERT_ID FROM CIR_UNSOLD_RETURN_CONTROL where (BILL_FREQ=@pbillfreq OR @pbillfreq IS NULL or @pbillfreq='');
     
   
     select distinct BILL_FREQ  from CIR_UNSOLD_RETURN_CONTROL where (BILL_FREQ=@pbillfreq OR @pbillfreq IS NULL or @pbillfreq='');
         
         
   End 
//-------------------------------------------------------//
/**********************Disputed Bill Laxman******************/
ALTER procedure [dbo].[cir_for_dispute_bill]
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @pagency_type    as varchar(20),
    @pclass_type     as varchar(20),
    @pagcd           as varchar(20),
    @pdpcd           as varchar(20),   
    @ppubltype       as varchar(20),
    @ppublcode       as varchar(20),
    @pfromdate       as datetime, 
    @ptilldate       as datetime,
    @ptype           as varchar(20),--for disputed D or undisputed bill U
    @puserid         as varchar(20), 
    @pdateformate    as varchar(20),
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
begin
    If @pcompcode='' Begin
		set @pcompcode=null
	End	
    If @punitcode='' Begin
		set @punitcode=null
	End	
    If @pagency_type='' Begin
		set @pagency_type=null
	End	
    If @pclass_type='' Begin
		set @pclass_type=null
	End	
    If @pagcd='' Begin
		set @pagcd=null
	End		
    If @pdpcd='' Begin
		set @pdpcd=null
	End	
    If @ppubltype='' Begin
		set @ppubltype=null
	End	
    If @ppublcode='' Begin
		set @ppublcode=null
	End						

    if upper(@ptype)='U' Begin--for Undisputed bills
        if @ppubltype is null and @ppublcode is null Begin
            select o.comp_code AS "COMP_CODE",o.unit_code AS "UNIT_CODE",o.agcd as "AGCD",o.dpcd as "DPCD", m.ag_name as "AGENCY_NAME",
            m.station_code as "DROP_POINT",dbo.cir_get_drop_point_name(o.comp_code,o.unit_code,m.station_code,1) as "DROP_POINT_NAME", 
            m.city_code as "CITY_CODE",dbo.cir_get_city(o.comp_code,m.city_code) as "CITY_NAME",  
            o.billno as "BILLNO", o.billdt as "BILLDT" ,o.publ as "PUBL" ,dbo.cir_get_publ_name(o.comp_code,o.publ) as "PUBL_NAME",
            b.amount as "BILL_AMOUNT",sum(o.amount) as "DUE_AMOUNT",isnull(b.dispute_flag,'N') as "DISPUTE_BILL",null  as "DISPUTE_REMARK" from cir_outmast o,cir_agmast m,cir_outmast b 
                where o.comp_code=m.comp_code and o.comp_code=b.comp_code and o.comp_code=@pcompcode and 
                     o.unit_code=m.unit and o.unit_code=b.unit_code and o.unit_code=@punitcode and o.doctyp=b.doctyp and o.doctyp='BIL' and 
                    o.agcd=m.agcd and o.agcd=b.agcd and o.agcd =isnull(@pagcd,o.agcd) and o.dpcd=m.dpcd and o.dpcd=b.dpcd and o.dpcd =isnull(@pdpcd,o.dpcd) and 
                    o.billdt=b.billdt and o.billdt between @pfromdate and @ptilldate and (o.publ = @ppublcode or @ppublcode is null) and 
                    o.billno=b.billno and o.billno  is not null and (m.ag_type=@pagency_type or @pagency_type is null) and 
                    (m.ag_class=@pclass_type or @pclass_type is null) and isnull(b.dispute_flag,'N')='N'
                group by  o.comp_code,o.unit_code,o.agcd,o.dpcd,m.ag_name,m.station_code,m.city_code,o.billno, o.billdt, o.publ,b.amount,isnull(b.dispute_flag,'N')
                having sum( o.amount )>0
                order by agency_name,billdt,billno
         End       
         Else Begin
            select o.comp_code AS "COMP_CODE",o.unit_code AS "UNIT_CODE",o.agcd as "AGCD",o.dpcd as "DPCD", m.ag_name as "AGENCY_NAME",
            m.station_code as "DROP_POINT",dbo.cir_get_drop_point_name(o.comp_code,o.unit_code,m.station_code,1) as "DROP_POINT_NAME", 
            m.city_code as "CITY_CODE",dbo.cir_get_city(o.comp_code,m.city_code) as "CITY_NAME",  
            o.billno as "BILLNO", o.billdt as "BILLDT" ,o.publ as "PUBL" ,dbo.cir_get_publ_name(o.comp_code,o.publ) as "PUBL_NAME",
            b.amount as "BILL_AMOUNT",sum(o.amount) as "DUE_AMOUNT",isnull(b.dispute_flag,'N') as "DISPUTE_BILL", null as "DISPUTE_REMARK" from cir_outmast o,cir_agmast m,cir_outmast b 
                where o.comp_code=m.comp_code and o.comp_code=b.comp_code and o.comp_code=@pcompcode and 
                     o.unit_code=m.unit and o.unit_code=b.unit_code and o.unit_code=@punitcode and o.doctyp=b.doctyp and o.doctyp='BIL' and 
                    o.agcd=m.agcd and o.agcd=b.agcd and o.agcd =isnull(@pagcd,o.agcd) and o.dpcd=m.dpcd and o.dpcd=b.dpcd and o.dpcd =isnull(@pdpcd,o.dpcd) and 
                    o.billdt=b.billdt and o.billdt between @pfromdate and @ptilldate and (o.publ = @ppublcode or @ppublcode is null) and 
                    o.billno=b.billno and o.billno  is not null and (m.ag_type=@pagency_type or @pagency_type is null) and 
                    (m.ag_class=@pclass_type or @pclass_type is null) and isnull(b.dispute_flag,'N')='N' and 
                    b.publ in(select publ from cir_publ_mast where comp_code=@pcompcode and publ=isnull(@ppublcode,publ) and pro_type=isnull(@ppubltype,pro_type)) 
                group by  o.comp_code,o.unit_code,o.agcd,o.dpcd,m.ag_name,m.station_code,m.city_code,o.billno, o.billdt, o.publ,b.amount,isnull(b.dispute_flag,'N')
                having sum( o.amount )>0
                order by agency_name,billdt,billno
         End
     End    
     Else Begin--for disputed bills
        If (@ppubltype is null or @ppubltype='') and (@ppublcode is null or @ppublcode='') Begin
            select o.comp_code AS "COMP_CODE",o.unit_code AS "UNIT_CODE",o.agcd as "AGCD",o.dpcd as "DPCD", m.ag_name as "AGENCY_NAME",
            m.station_code as "DROP_POINT",dbo.cir_get_drop_point_name(o.comp_code,o.unit_code,m.station_code,1) as "DROP_POINT_NAME", 
            m.city_code as "CITY_CODE",dbo.cir_get_city(o.comp_code,m.city_code) as "CITY_NAME",  
            o.billno as "BILLNO", o.billdt as "BILLDT" ,o.publ as "PUBL" ,dbo.cir_get_publ_name(o.comp_code,o.publ) as "PUBL_NAME",
            b.amount as "BILL_AMOUNT",sum(o.amount) as "DUE_AMOUNT",isnull(b.dispute_flag,'N') as "DISPUTE_BILL",b.dispute_rmrk  as "DISPUTE_REMARK"  from cir_outmast o,cir_agmast m,cir_outmast b 
                where o.comp_code=m.comp_code and o.comp_code=b.comp_code and o.comp_code=@pcompcode and 
                     o.unit_code=m.unit and o.unit_code=b.unit_code and o.unit_code=@punitcode and o.doctyp=b.doctyp and o.doctyp='BIL' and 
                    o.agcd=m.agcd and o.agcd=b.agcd and o.agcd =isnull(@pagcd,o.agcd) and o.dpcd=m.dpcd and o.dpcd=b.dpcd and o.dpcd =isnull(@pdpcd,o.dpcd) and 
                    o.billdt=b.billdt and o.billdt between @pfromdate and @ptilldate and (o.publ = @ppublcode or @ppublcode is null) and 
                    o.billno=b.billno and o.billno  is not null and (m.ag_type=@pagency_type or @pagency_type is null) and 
                    (m.ag_class=@pclass_type or @pclass_type is null) and isnull(b.dispute_flag,'N')='Y'
                group by  o.comp_code,o.unit_code,o.agcd,o.dpcd,m.ag_name,m.station_code,m.city_code,o.billno, o.billdt, o.publ,b.amount,isnull(b.dispute_flag,'N'),
                b.dispute_rmrk
                having sum( o.amount )>0
                order by agency_name,billdt,billno
         End       
         Else Begin
            select o.comp_code AS "COMP_CODE",o.unit_code AS "UNIT_CODE",o.agcd as "AGCD",o.dpcd as "DPCD", m.ag_name as "AGENCY_NAME",
            m.station_code as "DROP_POINT",dbo.cir_get_drop_point_name(o.comp_code,o.unit_code,m.station_code,1) as "DROP_POINT_NAME", 
            m.city_code as "CITY_CODE",dbo.cir_get_city(o.comp_code,m.city_code) as "CITY_NAME",  
            o.billno as "BILLNO", o.billdt as "BILLDT" ,o.publ as "PUBL" ,dbo.cir_get_publ_name(o.comp_code,o.publ) as "PUBL_NAME",
            b.amount as "BILL_AMOUNT",sum(o.amount) as "DUE_AMOUNT",isnull(b.dispute_flag,'N') as "DISPUTE_BILL",b.dispute_rmrk  as "DISPUTE_REMARK" from cir_outmast o,cir_agmast m,cir_outmast b 
                where o.comp_code=m.comp_code and o.comp_code=b.comp_code and o.comp_code=@pcompcode and 
                     o.unit_code=m.unit and o.unit_code=b.unit_code and o.unit_code=@punitcode and o.doctyp=b.doctyp and o.doctyp='BIL' and 
                    o.agcd=m.agcd and o.agcd=b.agcd and o.agcd =isnull(@pagcd,o.agcd) and o.dpcd=m.dpcd and o.dpcd=b.dpcd and o.dpcd =isnull(@pdpcd,o.dpcd) and 
                    o.billdt=b.billdt and o.billdt between @pfromdate and @ptilldate and (o.publ = @ppublcode or @ppublcode is null) and 
                    o.billno=b.billno and o.billno  is not null and (m.ag_type=@pagency_type or @pagency_type is null) and 
                    (m.ag_class=@pclass_type or @pclass_type is null) and isnull(b.dispute_flag,'N')='Y' and
                    b.publ in(select publ from cir_publ_mast where comp_code=@pcompcode and publ=isnull(@ppublcode,publ) and pro_type=isnull(@ppubltype,pro_type))
                group by  o.comp_code,o.unit_code,o.agcd,o.dpcd,m.ag_name,m.station_code,m.city_code,o.billno, o.billdt, o.publ,b.amount,isnull(b.dispute_flag,'N'),
                b.dispute_rmrk
                having sum( o.amount )>0
                order by agency_name,billdt,billno;
         End    
     End       
    
    select getdate() as "CUR_DATE"
    
End
/////////////////////////////////////////////

ALTER procedure cir_updation_dispute_bill
    @pcompcode           as varchar(50),
    @punitcode           as varchar(50),
    @pagcd               as varchar(50),
    @pdpcd               as varchar(50),
    @pbillno             as varchar(50),
    @pbilldt             as datetime,
    @pdisputed_rmrk      as varchar(500),
    @pdisputed_flag      as varchar(5),
    @ptype               as varchar(50),--for disputed D or undisputed bill U
    @puserid             as varchar(50), 
    @pdateformate        as varchar(50),
    @pextra1             as varchar(50),
    @pextra2             as varchar(50),
    @pextra3             as varchar(50),
    @pextra4             as varchar(50),
    @pextra5             as varchar(50),
    @pextra6             as varchar(50),
    @pextra7             as varchar(50),
    @pextra8             as varchar(50),
    @pextra9             as varchar(50),
    @pextra10            as varchar(50)
As
    
begin
	declare @v_cnt int
    If @ptype='D' Begin
        select @v_cnt=count(*)  from cir_outmast where comp_code=@pcompcode and unit_code=@punitcode and doctyp='BIL' and 
            billno=@pbillno and billdt=@pbilldt and agcd=@pagcd and dpcd=@pdpcd and isnull(dispute_flag,'N')='Y'
    End        
    else Begin
        select @v_cnt=count(*) from cir_outmast where comp_code=@pcompcode and unit_code=@punitcode and doctyp='BIL' and 
            billno=@pbillno and billdt=@pbilldt and agcd=@pagcd and dpcd=@pdpcd and (isnull(dispute_flag,'N')='N' or dispute_flag='')
    End
    
    if @v_cnt>0 Begin
        set @v_cnt=0
        update cir_outmast set dispute_flag=@pdisputed_flag, dispute_user_code=@puserid, dispute_dt =getdate(),
        dispute_rmrk=@pdisputed_rmrk
         where comp_code=@pcompcode and unit_code=@punitcode and doctyp='BIL' and 
            billno=@pbillno and billdt=@pbilldt and agcd=@pagcd and dpcd=@pdpcd
        set @v_cnt=1
    End
    
    select @v_cnt as "UPDATE_RECORD"
    
End
/**********************Disputed Bill ******************/


/****************************17-nov-2011 neha***************************************/

ALTER procedure [dbo].[cir_fetch_supplment_rate]
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @ppublcode       as varchar(20),
    @pfromdate       as datetime, 
    @ptilldate       as datetime,
    @puserid         as varchar(50), 
    @pdateformate    as varchar(50),
    @pextra1         as varchar(50),
    @pextra2         as varchar(50),
    @pextra3         as varchar(50),
    @pextra4         as varchar(50),
    @pextra5         as varchar(50)
as
    declare @v_dt		as	datetime
    declare @v_day		as  varchar(20)
    declare @v_flg      as  varchar(1)
    declare @v_recno    as  int
    declare @v1_comp_code	as varchar(20)
    declare @v1_unit_code	as varchar(20)
    declare @v1_publ_code	as varchar(20)
    declare @v1_publ_name	as varchar(200)
    declare @v1_main_edtn	as varchar(20)
    declare @v1_main_edtn_name as varchar(200)
    declare @v1_edtn		as varchar(20)
    declare @v1_edtn_name	as varchar(200)
    declare @v1_supl_name	as varchar(200)
    declare @v1_valid_from	as datetime
    declare @v1_valid_till	as datetime
    declare @v1_insertion_fee	as numeric(14,2)
    declare @v1_sun_allow	as varchar(20)
    declare @v1_mon_allow	as varchar(20)
    declare @v1_tue_allow	as varchar(20)
    declare @v1_wed_allow	as varchar(20)
    declare @v1_thu_allow	as varchar(20)
    declare @v1_fri_allow	as varchar(20)
    declare @v1_sat_allow	as varchar(20)
    
    declare c1 cursor for
    select s.comp_code comp_code,s.unit_code unit_code,s.publ_code publ_code,p.publ_name publ_name,e.main_edtn main_edtn,dbo.cir_get_edtn_name(s.comp_code,e.main_edtn) main_edtn_name,
    s.edtn_code edtn,e.edtn_name edtn_name,s.supl_name_sun supl_name,max(s.valid_from) valid_from,max(s.valid_till) valid_till,s.insertion_fee,
    s.sun_allow,s.mon_allow,s.tue_allow,s.wed_allow,s.thu_allow,s.fri_allow,s.sat_allow
    from cir_publ_mast p,cir_edtn_mast e,cir_edtn_supl_mast s
    where p.comp_code=e.comp_code and p.comp_code=s.comp_code and p.comp_code=@pcompcode and
        p.publ=e.publ and p.publ=s.publ_code and (p.publ=@ppublcode or @ppublcode is null or @ppublcode='') and (s.unit_code=@punitcode or @punitcode is null or @punitcode='') and e.edtn=s.edtn_code --and
        --v_from_date between valid_from and valid_till  and 
        --v_till_date between valid_from and valid_till
        group by s.comp_code,s.unit_code,s.publ_code,p.publ_name,e.main_edtn,
		s.edtn_code,e.edtn_name,s.supl_name_sun,s.insertion_fee,sun_allow,mon_allow,tue_allow,wed_allow,thu_allow,fri_allow,sat_allow;
begin
	set @v_flg ='N'
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
	SEC_OPBAL        NUMERIC(15,2));
	
    open c1
        fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_publ_code,@v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,
			@v1_edtn,@v1_edtn_name,@v1_supl_name,@v1_valid_from,@v1_valid_till,@v1_insertion_fee,
			@v1_sun_allow,@v1_mon_allow,@v1_tue_allow,@v1_wed_allow,@v1_thu_allow,@v1_fri_allow,@v1_sat_allow
        WHILE (@@FETCH_STATUS = 0) 
		BEGIN
        set @v_dt=@pfromdate

        --Loop
          --      if @v_dt>@ptilldate Begin
            --        exit;
              --  end
            if @v_dt between @v1_valid_from and @v1_valid_till Begin

                set @v_day=CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @v_dt),20)
                if @v_day='Sunday' Begin 
                    If @v1_sun_allow='Y' Begin
                        set @v_flg='Y'
                    End    
                    Else Begin
                        set @v_flg='N'
                    End
                End    
                Else if @v_day='Monday' Begin
                    If @v1_mon_allow='Y' Begin
                        set @v_flg='Y'
                    End    
                    Else Begin
                        set @v_flg='N'
                    End
                End    
                Else if @v_day='Tuesday' Begin
                    If @v1_tue_allow='Y' Begin
                        set @v_flg='Y'
                    End    
                    Else Begin
                        set @v_flg='N'
                    End
                End 
                Else If @v_day='Wednesday' Begin
                    If @v1_wed_allow='Y' Begin
                        set @v_flg='Y'
                    End
                    Else Begin
                        set @v_flg='N'
                    End
                End    
                Else If @v_day='Thursday' Begin
                    If @v1_thu_allow='Y' Begin
                        set @v_flg='Y'
                    End    
                    Else Begin
                        set @v_flg='N'
                    End
                End    
                Else if @v_day='Friday' Begin
                    If @v1_fri_allow='Y' Begin
                        set @v_flg='Y'
                    End    
                    Else Begin
                        set @v_flg='N'
                    End    
                End
                Else Begin
                    If @v1_sat_allow='Y' Begin
                        set @v_flg='Y'
                    End    
                    Else Begin
                        set @v_flg='N'
                    End
                End

                If @v_flg='Y' Begin
                    insert into #cir_temp_bill_collection
                        (comp_code, unit_code, billno,publ_code, agcd, dpcd,agname,agname_oth_lang, city_code, 
                        billdt,comm_amt)
                    values(@v1_comp_code,@v1_unit_code,@v1_publ_code,@v1_publ_name,@v1_main_edtn,@v1_edtn,@v1_main_edtn_name,@v1_edtn_name,
                        @v1_supl_name,@v_dt,@v1_insertion_fee)
                End 
            End
            --set @v_dt:=@v_dt+1
        --End loop
    fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_publ_code,@v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,
			@v1_edtn,@v1_edtn_name,@v1_supl_name,@v1_valid_from,@v1_valid_till,@v1_insertion_fee,
			@v1_sun_allow,@v1_mon_allow,@v1_tue_allow,@v1_wed_allow,@v1_thu_allow,@v1_fri_allow,@v1_sat_allow
	End		
    close c1
    deallocate c1
    
    select comp_code AS "COMP_CODE", unit_code AS "UNIT_CODE", billno as "PUBL_CODE",publ_code AS "PUBL_NAME", agcd AS "MAIN_EDTN", dpcd AS "EDTN",
    agname AS "MAIN_EDTN_NAME",agname_oth_lang AS "EDTN_NAME", city_code AS "SUPL_NAME", 
    billdt AS "SUPDATE" ,comm_amt AS "INSERTION_FEE" 
    from #CIR_TEMP_BILL_COLLECTION
    
    drop table #CIR_TEMP_BILL_COLLECTION
End
/****************************************19-nov-2011*********************************/
ALTER FUNCTION cir_get_agency_type(
	@pcomp_code		AS varchar(10),
	@pagtype		AS varchar(10)) 
RETURNS VARCHAR(100) AS
Begin
	DECLARE @vag_type_desc AS VARCHAR(40)

     select @vag_type_desc =agency_type_desc from cir_agency_typ_mast
         where comp_code=@pcomp_code and agency_type_code=@pagtype

  RETURN ISNULL(@vag_type_desc,'')
End

//*************************************** 5707 ***************************//

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[cir_route_detail_p]
    @pcompcode       AS varchar(20),
    @punitcode       AS varchar(20),
    @proutetype      AS varchar(20),--for Route R,Sub Route SR,Sub Sub Route SS
    @puserid         AS varchar(20),
    @psortby         AS INT,--for Name Wise 1,Seq No. 2
    @pdateformat     AS varchar(20),
    @pextra1         AS varchar(200),
    @pextra2         AS varchar(200),
    @pextra3         AS varchar(200),
    @pextra4         AS varchar(200),
    @pextra5         AS varchar(200),
    @pextra6         AS varchar(200),
    @pextra7         AS varchar(200),
    @pextra8         AS varchar(200),
    @pextra9         AS varchar(200),
    @pextra10        AS varchar(200)
  As
  DECLARE @V_QUERY		VARCHAR(4000)
  DECLARE @V_SORTEDBY  VARCHAR(200)
Begin
    IF @PROUTETYPE='R' BEGIN
        IF @V_SORTEDBY=1 BEGIN
            SET @V_SORTEDBY=' ORDER BY UNIT,ROUTE_NAME,ROUTE_SEQ'
        END    
        ELSE BEGIN
            SET @V_SORTEDBY=' ORDER BY UNIT,ROUTE_SEQ,ROUTE_NAME'
        END
    END    
    IF @PROUTETYPE='SR' BEGIN
        IF @V_SORTEDBY=1 BEGIN
            SET @V_SORTEDBY=' ORDER BY UNIT,ROUTE_NAME,SUBRT_NAME,ROUTE_SEQ,SUBRT_SEQ';
        END
        ELSE BEGIN
            SET @V_SORTEDBY=' ORDER BY UNIT,ROUTE_SEQ,SUBRT_SEQ,ROUTE_NAME,SUBRT_NAME';
        END
	END
    IF @PROUTETYPE='SS' BEGIN
        IF @V_SORTEDBY=1 BEGIN
            SET @V_SORTEDBY=' ORDER BY UNIT,ROUTE_NAME,SUBRT_NAME,SUB_SUBRT_NAME,ROUTE_SEQ,SUBRT_SEQ,SUB_SUBRT_SEQ';     
        END    
        ELSE BEGIN
            SET @V_SORTEDBY=' ORDER BY UNIT,ROUTE_SEQ,SUBRT_SEQ,SUB_SUBRT_SEQ,ROUTE_NAME,SUBRT_NAME,SUB_SUBRT_NAME';
        END
    END

    IF @PROUTETYPE='R' BEGIN--FOR ROUTE
        SET @V_QUERY='SELECT R.COMP_CODE COMP_CODE, R.UNIT UNIT , R.ROUTE_CODE ROUTE_CODE, R.ROUTE_NAME ROUTE_NAME, R.ROUTE_NAME_OTH_LANG ROUTE_NAME_OTH_LANG, 
            R.ARR_TIME ARR_TIME, R.DEP_TIME DEP_TIME, R.ROUTE_DIST ROUTE_DIST, R.ROUTE_MODE ROUTE_MODE, R.ROUTE_SEQ ROUTE_SEQ, R.ROUTE_ALERT ROUTE_ALERT, 
            R.FREEZE_FLAG FREEZE_FLAG, R.START_POINT START_POINT,DBO.CIR_GET_DROP_POINT_NAME(R.COMP_CODE,R.UNIT,R.START_POINT,1) START_DROP_POINT,
            R.END_POINT END_POINT,DBO.CIR_GET_DROP_POINT_NAME(R.COMP_CODE,R.UNIT,R.END_POINT,1) END_DROP_POINT
            FROM CIR_ROUTE_MAST R
            WHERE R.COMP_CODE='+''''+@PCOMPCODE+''''+' AND (R.UNIT='+''''+@PUNITCODE+''''+' OR '+''''+@PUNITCODE+''''+' IS NULL)  
            '+@V_SORTEDBY
	END	  	    
    IF @PROUTETYPE='SR' BEGIN--FOR SUB ROUTE
        SET @V_QUERY='SELECT R.COMP_CODE COMP_CODE, R.UNIT UNIT , R.ROUTE_CODE ROUTE_CODE, R.ROUTE_NAME ROUTE_NAME, R.ROUTE_NAME_OTH_LANG ROUTE_NAME_OTH_LANG,
        S.SUBRT_CODE SUBRT_CODE,S.SUBRT_NAME  SUBRT_NAME,S.SUBRT_NAME_OTH_LANG  SUBRT_NAME_OTH_LANG,
        S.ARR_TIME ARR_TIME, S.DEP_TIME DEP_TIME, S.SUBRT_DIST ROUTE_DIST, S.SUBRT_MODE ROUTE_MODE, R.ROUTE_SEQ ROUTE_SEQ,S.SUBRT_SEQ SUBRT_SEQ,
        S.FREEZE_FLAG FREEZE_FLAG, S.START_POINT START_POINT,DBO.CIR_GET_DROP_POINT_NAME(R.COMP_CODE,R.UNIT,S.START_POINT,1) START_DROP_POINT,
        S.END_POINT END_POINT,DBO.CIR_GET_DROP_POINT_NAME(R.COMP_CODE,R.UNIT,S.END_POINT,1) END_DROP_POINT
        FROM CIR_ROUTE_MAST R,CIR_SUB_ROUTE_MAST S
        WHERE R.COMP_CODE='+''''+@PCOMPCODE+''''+' AND R.COMP_CODE=S.COMP_CODE AND (R.UNIT='+''''+@PUNITCODE+''''+' OR '+''''+@PUNITCODE+''''+' IS NULL) AND R.UNIT=S.UNIT AND
        R.ROUTE_CODE=S.ROUTE_CODE '+@V_SORTEDBY 
	END        
    IF @PROUTETYPE='SS' BEGIN--FOR SUB SUB ROUTE
  	    SET @V_QUERY='SELECT R.COMP_CODE COMP_CODE, R.UNIT UNIT , R.ROUTE_CODE ROUTE_CODE, R.ROUTE_NAME ROUTE_NAME, R.ROUTE_NAME_OTH_LANG ROUTE_NAME_OTH_LANG,
        S.SUBRT_CODE SUBRT_CODE,S.SUBRT_NAME  SUBRT_NAME,S.SUBRT_NAME_OTH_LANG  SUBRT_NAME_OTH_LANG,T.SUB_SUBRT_CODE SUB_SUBRT_CODE,T.SUB_SUBRT_NAME  SUB_SUBRT_NAME,T.SUB_SUBRT_NAME_OTH_LANG  SUB_SUBRT_NAME_OTH_LANG,
        T.ARR_TIME ARR_TIME, T.DEP_TIME DEP_TIME, T.SUB_SUBRT_DIST SUB_SUBRT_DIST, T.SUB_SUBRT_MODE ROUTE_MODE, R.ROUTE_SEQ ROUTE_SEQ,S.SUBRT_SEQ SUBRT_SEQ,
        T.SUB_SUBRT_SEQ SUB_SUBRT_SEQ,
        T.FREEZE_FLAG FREEZE_FLAG, T.START_POINT START_POINT,DBO.CIR_GET_DROP_POINT_NAME(R.COMP_CODE,T.UNIT,T.START_POINT,1) START_DROP_POINT,
        T.END_POINT END_POINT,DBO.CIR_GET_DROP_POINT_NAME(R.COMP_CODE,T.UNIT,T.END_POINT,1) END_DROP_POINT
        FROM CIR_ROUTE_MAST R,CIR_SUB_ROUTE_MAST S,CIR_SUB_SUBROUTE_MAST T
        WHERE R.COMP_CODE='+''''+@PCOMPCODE+''''+' AND R.COMP_CODE=S.COMP_CODE AND R.COMP_CODE=T.COMP_CODE AND (R.UNIT='+''''+@PUNITCODE+''''+' OR '+''''+@PUNITCODE+''''+' IS NULL) AND R.UNIT=S.UNIT AND
        R.UNIT=T.UNIT AND R.ROUTE_CODE=S.ROUTE_CODE  AND R.ROUTE_CODE=T.ROUTE_CODE AND S.SUBRT_CODE=T.SUBRT_CODE '+@V_SORTEDBY;
    END
	PRINT(@V_QUERY)
	EXEC(@V_QUERY)
    SELECT GETDATE() AS "CUR_DATE"
                     
    SELECT GETDATE() AS "CUR_DATE"
END

//*******************************************5707*************************************//

ALTER procedure cir_updation_seqno
	@pcompcode           as varchar(50),
    @punitcode           as varchar(50),
    @prtcode             as varchar(50),
    @psubrtcode          as varchar(50),
    @psub_subrtcode      as varchar(50),
    @pagcd               as varchar(50),
    @pdpcd               as varchar(50),
    @proute_seqno        as int,   
    @pupdtype            as varchar(20),--for Route R or Sub Route SR or SUB Sub Route SS
    @puserid             as varchar(20), 
    @pdateformate        as varchar(20),
    @pextra1             as varchar(200),
    @pextra2             as varchar(200),
    @pextra3             as varchar(200),
    @pextra4             as varchar(200),
    @pextra5             as varchar(200),
    @pextra6             as varchar(200),
    @pextra7             as varchar(200),
    @pextra8             as varchar(200),
    @pextra9             as varchar(200),
    @pextra10            as varchar(200)
as
    declare @v_cnt numeric(5)
begin
    set @v_cnt=0

    If @pupdtype='R' Begin
        select @v_cnt=count(*) from cir_route_mast 
            where comp_code=@pcompcode and unit=@punitcode and route_code=@prtcode
        
        If isnull(@v_cnt,0)>0 Begin  
            update cir_route_mast set route_seq=@proute_seqno 
                where comp_code=@pcompcode and unit=@punitcode and route_code=@prtcode
        End
    End    

    Else If @pupdtype='SR' Begin

        select @v_cnt=count(*) from cir_sub_route_mast
        where comp_code=@pcompcode and unit=@punitcode and route_code=@prtcode and subrt_code=@psubrtcode;
        
        If isnull(@v_cnt,0)>0 Begin
            update cir_sub_route_mast set subrt_seq=@proute_seqno 
                where comp_code=@pcompcode and unit=@punitcode and route_code=@prtcode and subrt_code=@psubrtcode;
        End
    End    
    Else If @pupdtype='SS' Begin

            select @v_cnt=count(*) from cir_sub_subroute_mast
            where comp_code=@pcompcode and unit=@punitcode and route_code=@prtcode and subrt_code=@psubrtcode and sub_subrt_code=@psub_subrtcode;
        
        If isnull(@v_cnt,0)>0 Begin
            update cir_sub_subroute_mast set sub_subrt_seq=@proute_seqno 
                where comp_code=@pcompcode and unit=@punitcode and route_code=@prtcode and subrt_code=@psubrtcode and sub_subrt_code=@psub_subrtcode;
        End
	End        


    select @v_cnt as "UPDATE_RECORD"
    
End
/***************************23-nov-2011******************/
ALTER PROCEDURE user_privileges_user_form_rights_p
	@pcomp_code			VARCHAR(20) ,
	@punit_code         VARCHAR(20) ,
	@puser_code         VARCHAR(20) ,
	@pmodule_code       VARCHAR(20) ,
	@pform_name         VARCHAR(100) ,
	@pdateformat        VARCHAR(20) ,
	@pextra1            VARCHAR(400) ,
	@pextra2            VARCHAR(400) 
AS 

	SELECT DISTINCT	 a.module_id module_id, DBO.get_module_name(a.module_id) module_name,
			 a.form_id form_id, b.form_name form_name, b.form_menuname,
			 b.form_type form_type, a.user_right user_right
	FROM  module_user_rights a,module_form_mast b 
	WHERE a.comp_code  = @pcomp_code AND a.unit_code  = @punit_code
		AND a.user_code  = @puser_code AND a.module_id  = @pmodule_code
		AND a.module_id  = b.module_id AND a.form_id  = b.form_id
		AND --a.form_id  = @v_form_id 
		b.form_name=@pform_name
	ORDER BY 1, 7, 6 
/***************************23-nov-2011******************/

////////////////////////////////5435

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER PROCEDURE [dbo].[Cir_Gen_Code_inct_slab_code_P]
	@pcompcode			VARCHAR(20) ,
	@pdateformat        VARCHAR(20) ,
	@pextra1            VARCHAR(4000) ,
	@pextra2            VARCHAR(4000) 
AS 
	DECLARE @vno	VARCHAR(8) 

	SELECT @vno  =  isnull(MAX(inct_slab_id),0) + 1 FROM  cir_inct_slab_hdr
--PRINT (@vno)
--if (@vno='NULL' OR  @vno=NULL OR @vno='')
--begin
--set @vno='0'
--end

	SELECT @vno as VAR_CODE














//////////////////////
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go





ALTER FUNCTION  [dbo].[get_pub_center] (@pub_cent_code as varchar(100))  returns varchar(200)

AS  

BEGIN 
DECLARE @vcentname VARCHAR(4000)

select @vcentname =Pub_Cent_name  from pub_cent_mast where Pub_cent_Code=@pub_cent_code;
	   
RETURN isnull(@vcentname,'')

END


//////////////////////
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




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
		

		









/////////////////////






ALTER FUNCTION [dbo].[cir_get_agency_type](
@pcomp_code AS varchar(10),
@pagtype AS varchar(10)
)
RETURNS VARCHAR(100) AS

    Begin
  DECLARE @vag_type_desc AS VARCHAR(40) --cir_agency_typ_mast.agency_type_desc%type
  
     select @vag_type_desc =agency_type_desc 
        from cir_agency_typ_mast
         where comp_code=@pcomp_code and
               agency_type_code=@pagtype
   

  RETURN ISNULL(@vag_type_desc,'')
    End

/////////////////////////end of 5435


/////////////////////////end of 4566  4698 //////////////////



for state----->




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
        A.AGCD=B.AGCD AND A.DPCD=B.DPCD AND A.PUBL='''+@PPUBL+''' AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') AND
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
        A.AGCD=B.AGCD AND A.DPCD=B.DPCD AND A.PUBL='''+@PPUBL+''' AND (A.EDTN='''+@PEDTN+''' OR '''+@PEDTN+''' IS NULL or '''+@PEDTN+'''='''') AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+'''='''') AND
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
        A.AGCD=B.AGCD AND A.DPCD=B.DPCD AND A.PUBL='''+@PPUBL+''' AND (A.EDTN='''+@PEDTN+''' OR '''+@PEDTN+''' IS NULL or '''+@PEDTN+'''='''') AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+'''='''') AND
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




for dist----->




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
 print '3'

	set @pquery='SELECT COMP_CODE, UNIT_CODE, AGCD "AGENCY CODE", DPCD "AGENCY SUBCODE", substrING(dbo.cir_get_name_cir_agname(comp_code,unit_code,agcd,dpcd,1,'''','''',''''),1,50) "AGENCY NAME",
	substring(dbo.cir_get_name_cir_agname(comp_code,unit_code,agcd,dpcd,2,'''','''',''''),1,50) "AGENCY ONAME",
    EDTN,
	dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION NAME",
    dbo.cir_get_edtn_name(COMP_CODE,d.EDTN) "EDITION ONAME",
	CITY_CODE "CITY CODE",dbo.cir_get_city(COMP_CODE,CITY_CODE) "CITY NAME",
    dbo.cir_get_name_cir_city(COMP_CODE,CITY_CODE,2,'''','''','''') "CITY ONAME",
     isnull(DIST_CODE,''NA'') "DIST CODE",
    isnull(dbo.cir_get_dist(COMP_CODE,STATE_CODE, DIST_CODE),''NA'') "DISTRICT NAME",
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
		WHERE	 A.COMP_CODE  = B.COMP_CODE AND	A.COMP_CODE  = C.COMP_CODE AND	A.COMP_CODE  = '''+@PCOMP_CODE+'''
		AND	A.UNIT_CODE  = B.UNIT AND	A.UNIT_CODE  = '''+@PUNIT_CODE+''' AND	A.AGCD  = B.AGCD 
        AND	A.DPCD  = B.DPCD
		AND	A.PUBL  = '''+@PPUBL+''' 
        AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') 
        AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') AND
        (B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL OR '''+@PSTATECD+'''='''') AND 
        (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND 
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND A.SUPDATE  BETWEEN '''+@VFRDT+'''  AND  '''+@VTODT+''' AND	ISNULL(A.SUP_COPY, 0)  > 0
		GROUP BY  A.COMP_CODE,A.UNIT_CODE,A.AGCD,A.DPCD,A.SUPDATE,A.EDTN,B.CITY_CODE,B.DIST_CODE,B.STATE_CODE) d
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.AGCD,d.DPCD,d.EDTN,d.CITY_CODE,d.DIST_CODE,d.STATE_CODE
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.DIST_CODE,d.CITY_CODE,d.EDTN,d.AGCD,d.DPCD;'
		
	--print @pquery	
	
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
		WHERE	 A.COMP_CODE  = B.COMP_CODE
	    AND	A.COMP_CODE  = C.COMP_CODE
		AND	A.COMP_CODE  = '''+@PCOMP_CODE+'''
		AND	A.UNIT_CODE  = B.UNIT
		AND	A.UNIT_CODE  = '''+@PUNIT_CODE+'''
		AND	A.AGCD  = B.AGCD
		AND	A.DPCD  = B.DPCD
		AND	A.PUBL  = '''+@PPUBL+'''
		AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') 
		AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') and
		(B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL OR '''+@PSTATECD+'''='''') AND 
		(B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND 
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND 
			 AND	A.SUPDATE  BETWEEN '''+@VFRDT +''' AND  '''+@VTODT+'''
			 AND	ISNULL(A.SUP_COPY, 0)  > 0
			  GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE,B.DIST_CODE,B.STATE_CODE) d
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.DIST_CODE,d.STATE_CODE
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.DIST_CODE'

	print @pquery1		
		
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
		AND	A.UNIT_CODE  = B.UNIT
		AND	A.UNIT_CODE  = '''+@PUNIT_CODE+'''
		AND	A.AGCD  = B.AGCD
		AND	A.DPCD  = B.DPCD
		AND	A.PUBL  = '''+@PPUBL+'''
		AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') 
		AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') and
		(B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL OR '''+@PSTATECD+'''='''') AND 
		(B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND 
        (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND 
		AND	A.SUP_TYPE_CODE  = C.SUP_TY_CODE
		AND	A.SUPDATE  BETWEEN '''+@VFRDT+'''  AND  '''+@VTODT+'''
		AND	ISNULL(A.SUP_COPY, 0)  > 0
		 GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE) d
        GROUP BY d.COMP_CODE, d.UNIT_CODE
        ORDER BY  d.COMP_CODE, d.UNIT_CODE;'
		
exec(@pquery)
	exec(@pquery1)
	exec(@pquery2)
	





for taluka---->



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
		FROM (	SELECT
					 A.COMP_CODE COMP_CODE,
					 A.UNIT_CODE UNIT_CODE,
					 A.AGCD AGCD,
					 A.DPCD DPCD,
					 A.EDTN EDTN,
					 B.CITY_CODE,
					 B.TEHSIL_TALUKA TEHSIL_TALUKA,
					 B.STATE_CODE STATE_CODE,
					 
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
			FROM  CIR_DBKSUP A,
				 CIR_AGMAST B,
				 CIR_SUPPLY_TYPE_MAST C 
			WHERE	 A.COMP_CODE  = B.COMP_CODE
			 AND	A.COMP_CODE  = C.COMP_CODE
			 AND	A.COMP_CODE  = '''+@PCOMP_CODE+'''
			 AND	A.UNIT_CODE  = B.UNIT
			 AND	A.UNIT_CODE  = '''+@PUNIT_CODE+'''
			 AND	A.AGCD  = B.AGCD
			 AND	A.DPCD  = B.DPCD
			 AND	A.PUBL  = '''+@ppubl+'''
			 AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') 
             AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') and
			(B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL OR '''+@PSTATECD+'''='''') AND 
			(B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND 
			(B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND
			A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND 
			 AND	A.SUPDATE  BETWEEN '''+@VFRDT+'''  AND  '''+@VTODT+'''
			 AND	ISNULL(A.SUP_COPY, 0)  > 0
		  GROUP BY A.COMP_CODE,A.UNIT_CODE,A.AGCD,A.DPCD,A.SUPDATE,A.EDTN,B.CITY_CODE,B.TEHSIL_TALUKA,B.STATE_CODE) d
        GROUP BY d.COMP_CODE,d.UNIT_CODE,d.AGCD,d.DPCD,d.EDTN,d.CITY_CODE,d.TEHSIL_TALUKA,d.STATE_CODE
        ORDER BY d.COMP_CODE,d.UNIT_CODE,d.STATE_CODE,d.TEHSIL_TALUKA,d.CITY_CODE,d.EDTN,d.AGCD,d.DPCD;'

		
		
	
			set @pquery1='SELECT COMP_CODE, UNIT_CODE,
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
		FROM (	SELECT
					 A.COMP_CODE COMP_CODE,
					 A.UNIT_CODE UNIT_CODE,
					 B.TEHSIL_TALUKA TEHSIL_TALUKA,
					 B.STATE_CODE STATE_CODE,
					 
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
			WHERE	 A.COMP_CODE  = B.COMP_CODE
			 AND	A.COMP_CODE  = C.COMP_CODE
			 AND	A.COMP_CODE  = '''+@PCOMP_CODE+'''
			 AND	A.UNIT_CODE  = B.UNIT
			 AND	A.UNIT_CODE  = '''+@PUNIT_CODE+'''
			 AND	A.AGCD  = B.AGCD
			 AND	A.DPCD  = B.DPCD
			 AND	A.PUBL  = '''+@PPUBL+'''
	     	 AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') 
             AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') and
			(B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL OR '''+@PSTATECD+'''='''') AND 
			(B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND 
			(B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND
			A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND 			 AND	A.SUPDATE  BETWEEN '''+@VFRDT+'''  AND  '''+@VTODT+'''
			 AND	ISNULL(A.SUP_COPY, 0)  > 0 
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
		FROM (	SELECT
					 A.COMP_CODE COMP_CODE,
					 A.UNIT_CODE UNIT_CODE,
					 
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
			FROM  CIR_DBKSUP A,
				 CIR_AGMAST B,
				 CIR_SUPPLY_TYPE_MAST C 
			WHERE	 A.COMP_CODE  = B.COMP_CODE
			 AND	A.COMP_CODE  = C.COMP_CODE
			 AND	A.COMP_CODE  = '''+@PCOMP_CODE+'''
			 AND	A.UNIT_CODE  = B.UNIT
			 AND	A.UNIT_CODE  = '''+@PUNIT_CODE+'''
			 AND	A.AGCD  = B.AGCD
			 AND	A.DPCD  = B.DPCD
			 AND	A.PUBL  = '''+@PPUBL+'''
			 	 AND (A.EDTN='''+@PEDTN+''' or '''+@PEDTN+''' IS NULL OR '''+@PEDTN+''' ='''') 
             AND (B.CITY_CODE='''+@PCITYCD+''' OR '''+@PCITYCD+''' IS NULL or '''+@PCITYCD+''' ='''') AND
			(B.STATE_CODE='''+@PSTATECD+''' OR '''+@PSTATECD+''' IS NULL OR '''+@PSTATECD+'''='''') AND 
			(B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL or '''+@PDISTCODE+''' ='''') AND (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL or '''+@PTALUKA+''' ='''') AND 
			(B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL or '''+@PBRANCH+''' ='''') AND (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL or '''+@PAGTYPE+''' ='''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL or '''+@PAGCLASS+''' ='''') AND
			A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''+@PEXTRA1+''' OR '''+@PEXTRA1+''' IS NULL or '''+@PEXTRA1+''' ='''') AND 
			 AND	A.SUPDATE  BETWEEN '''+@VFRDT+'''  AND  '''+@VTODT+'''
			 AND	ISNULL(A.SUP_COPY, 0)  > 0
		  GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE)  d
        GROUP BY d.COMP_CODE,d.UNIT_CODE
        ORDER BY d.COMP_CODE,d.UNIT_CODE;'
		
PRINT @pquery
exec(@pquery)
	exec(@pquery1)
	exec(@pquery2)




for state day wise-------->





ALTER PROCEDURE [dbo].[cir_rep_supply_cir_rep_day_daybook]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@pcitycd                                  VARCHAR(20) ,
	@pstatecd                                 VARCHAR(20) ,
	@pmonth                                   VARCHAR(20) ,
	@pyear                                    VARCHAR(20) ,
	@pday                                     VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pbranch								  varchar(20),
    @pdistcode								  varchar(20),
    @ptaluka								  varchar(20),
    @pagtype								  varchar(20),
    @pagclass								  varchar(20),
    @pagcode								  varchar(20),
    @pdpcode								  varchar(20),
    @pextra1								  varchar(200),
    @pextra2								  varchar(200),
    @pextra3								  varchar(200),
    @pextra4								  varchar(200),
    @pextra5								  varchar(200) 
AS 
	DECLARE @vquery1                                  VARCHAR(8000) 	
	DECLARE @vquery2                                  VARCHAR(8000) 	
	DECLARE @vquery3                                  VARCHAR(8000) 
	DECLARE @vdaysup                                  VARCHAR(2000) 
	DECLARE @vtotsup                                  VARCHAR(1000) 
	DECLARE @v_dt                                     DATETIME 
	DECLARE @v_day                                    VARCHAR(3) 
	DECLARE @v_cnt                                    INT                           
	SET @v_cnt = 0 


    DECLARE @vday11                                    VARCHAR(80)
    DECLARE @vdt11                                     VARCHAR(80) 




	DECLARE c1 cursor LOCAL FOR 

	SELECT dt, UPPER(DATENAME(WEEKDAY, dt)) supply_day	FROM  cir_temp_dt 	ORDER BY sqno, dt 
	


   	DECLARE @vfrdt         VARCHAR(20)
	DECLARE @vtodt         VARCHAR(20)
   	DECLARE @vtodt1         VARCHAR(20)
	DECLAre @pquery         varchar(8000)
	DECLAre @pquery1         varchar(8000)
	DECLAre @pquery2         varchar(8000)
    

print (@pday)

if(@pday = 'sun')
begin
   set  @pday = 'Sunday'
end  
else if(@pday = 'mon')
begin
   set  @pday = 'Monday'
end  
else if(@pday = 'tue')
begin
   set  @pday = 'Tuesday'
end  
else if(@pday = 'wed')
begin
   set  @pday = 'Wednesday'
end  
else if(@pday = 'thu')
begin
   set  @pday = 'Thursday'
end  
else if(@pday = 'fri')
begin
   set  @pday = 'Friday'
end  
else if(@pday = 'sat')
begin
   set  @pday = 'Saturday'
end  
print (@pday)


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




		DELETE FROM   cir_temp_dt    
		
	
		WHILE (0 = 0) 
		BEGIN 
					IF @v_dt >= @vtodt 
					BEGIN 
						    BREAK

					END
					ELSE
					BEGIN 
							IF @v_dt is null 
							BEGIN 
								    SET @v_dt  = @vfrdt 
							END
							ELSE
							BEGIN 
							     	SET @v_dt  = @v_dt + 1 
							END
		   
					END
		   
					IF UPPER(DATENAME(WEEKDAY, @v_dt))= UPPER(@pday)
					BEGIN 
						    INSERT INTO  cir_temp_dt   ( sqno , dt )   VALUES 		( 1 , @v_dt )  
						
					END
					ELSE
					BEGIN 
						    INSERT INTO  cir_temp_dt   ( sqno , dt )   VALUES 		( 2 , 	@v_dt )  
						
					END
   
		
		END 
		
	
	
		OPEN c1 
		
        fetch NEXT FROM c1 INTO @vdt11,@vday11
		
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN 
		 
		

			SET @v_cnt  = @v_cnt + 1 
			IF @vquery1 is null 
			BEGIN 
                	  PRINT('shachi11') 
 PRINT(@vdt11) 
				SET @vquery1  = 'case (select(day(A.SUPDATE)))  when day('''+@vdt11+''') then SUM(isnull(A.SUP_COPY,0)) end P'+dbo.fnPadLeft('0',2,@v_cnt);
             --	print(@v_cnt)

                SET @vdaysup  = 'SUM(isnull(P'+ dbo.fnPadLeft('0',2,@v_cnt)+',0)) AS ' + '"' + dbo.fnPadLeft('0',2,@v_cnt) + '"';
              
             --   print(@vdaysup)

		        SET @vtotsup  = 'isnull(P'+ dbo.fnPadLeft ('0',2,@v_cnt)+',0)';
 --print(@vtotsup)
               
			END
			ELSE
			BEGIN 
				SET @vquery1  = @vquery1 + ',' + 'case (select(day(A.SUPDATE)))  when day('''+@vdt11+''') then SUM(isnull(A.SUP_COPY,0)) end P'+dbo.fnPadLeft('0',2,@v_cnt);
 
				SET @vdaysup  = @vdaysup + ',' + 'SUM(isnull(P'+ dbo.fnPadLeft('0',2,@v_cnt)+',0)) AS ' + '"' + dbo.fnPadLeft('0',2,@v_cnt) + '"';
 
				SET @vtotsup  = @vtotsup + '+' + 'isnull(P'+ dbo.fnPadLeft ('0',2,@v_cnt)+',0)';

			END
   
		fetch NEXT FROM c1 INTO @vdt11,@vday11	
		END 
		
		
		close c1

--print(@vquery1)

	
		SET @vtotsup  = 'SUM(' + @vtotsup + ')' 

		
		SET @vquery3  = 'SELECT COMP_CODE,UNIT_CODE,AGCD "AGENCY CODE",DPCD "AGENCY SUBCODE",substring(dbo.cir_get_agency(comp_code,unit_code,agcd,dpcd),1,50) "AGENCY NAME",substring(dbo.cir_get_name_cir_agname(comp_code,unit_code,agcd,dpcd,2,' + '''' + @pdateformat + '''' + ','''',''''),1,50) "AGENCY ONAME",         EDTN,dbo.CIR_GET_EDTN_NAME(COMP_CODE,EDTN) "EDITION NAME",isnull(dbo.CIR_GET_NAME_CIR_EDTN(COMP_CODE,'''',EDTN,2,' + '''' + @pdateformat + '''' + ','''',''''),''NA'') "EDITION ONAME",         isnull(CITY_CODE,''NA'') "CITY CODE",isnull(dbo.CIR_GET_CITY(COMP_CODE,CITY_CODE),''NA'') "CITY NAME",isnull(dbo.CIR_GET_NAME_CIR_CITY(COMP_CODE,CITY_CODE,2,' + '''' + @pdateformat + '''' + ','''',''''),''NA'') "CITY ONAME",         isnull(STATE_CODE,''NA'') "STATE CODE",isnull(dbo.CIR_GET_STATE(COMP_CODE,COUNTRY_CODE,STATE_CODE),''NA'') "STATE NAME",COUNTRY_CODE "COUNTRY CODE",' + @vdaysup + ',' + @vtotsup + 'AS "TOTAL"' + ' FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,A.EDTN EDTN,B.CITY_CODE,B.STATE_CODE STATE_CODE,B.COUNTRY_CODE COUNTRY_CODE,' + @vquery1 
		SET @vquery2  = ' FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C  WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=''' + @pcomp_code + ''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=''' + @punit_code + ''' AND A.AGCD=B.AGCD AND A.DPCD=B.DPCD AND A.PUBL=''' + @ppubl + ''' AND (A.EDTN=''' + @pedtn + ''' OR''' + @pedtn + ''' IS NULL ' + ' OR ''' + @pedtn + ''' = ''''  ) AND (B.CITY_CODE=''' + @pcitycd + ''' OR''' + @pcitycd + ''' IS NULL ' + ' OR ''' + @pcitycd + ''' = '''') AND (B.STATE_CODE=''' + @pstatecd + ''' OR''' + @pstatecd + ''' IS NULL ' + ' OR ''' + @pstatecd + ''' = '''') AND (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL' + ' OR ''' + @PDISTCODE + ''' = '''') AND 
        (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL'+ ' OR ''' + @PDISTCODE + ''' = '''') AND (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL' + ' OR ''' + @PBRANCH + ''' = '''') AND
        (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL '+ ' OR ''' + @PAGTYPE + ''' = '''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL '+ ' OR ''' + @PAGCLASS + ''' = '''') AND A.SUP_TYPE_CODE=C.SUP_TY_CODE AND  A.SUPDATE BETWEEN''' + @vfrdt + ''' AND''' + @vtodt + ''' AND isnull(A.SUP_COPY,0)>0 and  upper (CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, A.SUPDATE),20)) =upper(''' + @pday + ''')          GROUP BY A.COMP_CODE,A.UNIT_CODE,A.AGCD,A.DPCD,A.SUPDATE,A.EDTN,B.CITY_CODE,B.STATE_CODE,B.COUNTRY_CODE) m         GROUP BY m.COMP_CODE,m.UNIT_CODE,m.AGCD,m.DPCD,m.EDTN,m.CITY_CODE,m.STATE_CODE,m.COUNTRY_CODE ORDER BY m.COMP_CODE,m.UNIT_CODE,m.STATE_CODE,m.CITY_CODE,m.EDTN,m.AGCD,m.DPCD' 
	
print (@vquery3 + @vquery2)

		EXEC (@vquery3 + @vquery2)
		
	
		SET @vquery3  = 'SELECT COMP_CODE,UNIT_CODE,isnull(STATE_CODE,''NA'') "STATE CODE",isnull(dbo.CIR_GET_STATE(COMP_CODE,COUNTRY_CODE,STATE_CODE),''NA'') "STATE NAME",COUNTRY_CODE "COUNTRY CODE",' + @vdaysup + ',' + @vtotsup + 'AS "TOTAL"' + ' FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,B.STATE_CODE STATE_CODE,B.COUNTRY_CODE COUNTRY_CODE,' + @vquery1 
		SET @vquery2  = '    FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C          WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=''' + @pcomp_code + ''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=''' + @punit_code + ''' AND          A.AGCD=B.AGCD AND A.DPCD=B.DPCD AND A.PUBL=''' + @ppubl + ''' AND (A.EDTN=''' + @pedtn + ''' OR''' + @pedtn + ''' IS NULL ' + ' OR ''' + @pedtn + ''' = '''') AND (B.CITY_CODE=''' + @pcitycd + ''' OR''' + @pcitycd + ''' IS NULL ' + ' OR ''' + @pcitycd + ''' = '''') AND          (B.STATE_CODE=''' + @pstatecd + ''' OR''' + @pstatecd + ''' IS NULL ' + ' OR ''' + @pstatecd + ''' = '''') AND 
		(B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL' + ' OR ''' + @PDISTCODE + ''' = '''') AND 
        (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL'+ ' OR ''' + @PDISTCODE + ''' = '''') AND (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL' + ' OR ''' + @PBRANCH + ''' = '''') AND
        (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL '+ ' OR ''' + @PAGTYPE + ''' = '''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL '+ ' OR ''' + @PAGCLASS + ''' = '''') and A.SUP_TYPE_CODE=C.SUP_TY_CODE AND          A.SUPDATE BETWEEN''' + @vfrdt + ''' AND''' + @vtodt + ''' AND isnull(A.SUP_COPY,0)>0 AND upper (CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, A.SUPDATE),20))=upper(''' + @pday + ''')          GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE,B.STATE_CODE,B.COUNTRY_CODE) o         GROUP BY o.COMP_CODE,o.UNIT_CODE,o.STATE_CODE,o.COUNTRY_CODE ORDER BY o.COMP_CODE,o.UNIT_CODE,o.STATE_CODE' 
		
	
        EXEC (@vquery3 + @vquery2)

		SET @vquery3  = 'SELECT COMP_CODE,UNIT_CODE,' + @vdaysup + ',' + @vtotsup + 'AS "TOTAL"' + ' FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,' + @vquery1 
		SET @vquery2  = ' FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C   WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=''' + @pcomp_code + ''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=''' + @punit_code + ''' AND          A.AGCD=B.AGCD AND A.DPCD=B.DPCD AND A.PUBL=''' + @ppubl + ''' AND (A.EDTN=''' + @pedtn + ''' OR''' + @pedtn + ''' IS NULL ' + ' OR ''' + @pedtn + ''' = '''') AND (B.CITY_CODE=''' + @pcitycd + ''' OR''' + @pcitycd + ''' IS NULL ' + ' OR ''' + @pcitycd + ''' = '''') AND          (B.STATE_CODE=''' + @pstatecd + ''' OR''' + @pstatecd + ''' IS NULL ' + ' OR ''' + @pstatecd + ''' = '''') AND (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL' + ' OR ''' + @PDISTCODE + ''' = '''') AND 
        (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL'+ ' OR ''' + @PDISTCODE + ''' = '''') AND (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL' + ' OR ''' + @PBRANCH + ''' = '''') AND
        (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL '+ ' OR ''' + @PAGTYPE + ''' = '''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL '+ ' OR ''' + @PAGCLASS + ''' = '''') and A.SUP_TYPE_CODE=C.SUP_TY_CODE AND          A.SUPDATE BETWEEN''' + @vfrdt + ''' AND''' + @vtodt + ''' AND isnull(A.SUP_COPY,0)>0 AND upper (CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, A.SUPDATE),20))=upper(''' + @pday + ''')          GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE)  q        GROUP BY q.COMP_CODE,q.UNIT_CODE   ORDER BY q.COMP_CODE,q.UNIT_CODE' 
		
	
   EXEC (@vquery3 + @vquery2)	
 DEALLOCATE c1





for dist day wise----->





ALTER PROCEDURE [dbo].[cir_rep_supply_cir_rep_dist_day_daybook]
	@pcomp_code                                VARCHAR(20) ,
	@punit_code                                VARCHAR(20) ,
	@ppubl                                     VARCHAR(20) ,
	@pedtn                                     VARCHAR(20) ,
	@pcitycd                                   VARCHAR(20) ,
	@pdistcd                                   VARCHAR(20) ,
	@pmonth                                    VARCHAR(20) ,
	@pyear                                     VARCHAR(20) ,
	@pday                                      VARCHAR(20) ,
	@pdateformat                               VARCHAR(20) ,
	@pbranch								   varchar(20),
    @pdistcode								   varchar(20),
    @ptaluka								   varchar(20),
    @pagtype								   varchar(20),
    @pagclass								   varchar(20),
    @pagcode								   varchar(20),
    @pdpcode								   varchar(20), 
    @pextra1								   varchar(200),
    @pextra2								   varchar(200),
    @pextra3								   varchar(200),
    @pextra4								   varchar(200),
    @pextra5								   varchar(200)
AS 
	
		
	DECLARE @vquery1		VARCHAR(8000) 
	DECLARE @vquery2        VARCHAR(8000) 
	DECLARE @vquery3        VARCHAR(8000) 
	DECLARE @vdaysup        VARCHAR(2000) 
	DECLARE @vtotsup        VARCHAR(1000) 
	--	DECLARE @vfrdt      VARCHAR(20)
	--	DECLARE @vtodt      VARCHAR(20)
	DECLARE @v_dt           DATETIME 
	DECLARE @v_day          VARCHAR(3) 
	DECLARE @v_cnt          int                           
	SET @v_cnt = 0 

	DECLARE @vday11         VARCHAR(80)
	DECLARE @vdt11          VARCHAR(80)

	DECLARE c1 cursor LOCAL FOR 
		SELECT dt, UPPER(DATENAME(WEEKDAY, dt)) supply_day	FROM  cir_temp_dt 	ORDER BY sqno, dt 
		
	DECLARE @vfrdt         VARCHAR(20)
	DECLARE @vtodt         VARCHAR(20)
	DECLARE @vtodt1        VARCHAR(20)
	DECLAre @pquery        varchar(8000)
	DECLAre @pquery1       varchar(8000)
	DECLAre @pquery2       varchar(8000)
     --   PRINT('2')


If(@pmonth = 'jan') Begin
   set  @pmonth = '01'
End

Else If(@pmonth = 'feb') Begin
   set  @pmonth = '02'
End
Else if(@pmonth = 'mar') Begin
   set  @pmonth = '03'
End
Else If(@pmonth = 'apr') Begin
   set  @pmonth = '04'
End
Else if(@pmonth = 'may') Begin
   set  @pmonth = '05'
End
Else if(@pmonth = 'jun') Begin
   set  @pmonth = '06'
End
Else if(@pmonth = 'jul') Begin
   set  @pmonth = '07'
End
Else if(@pmonth = 'aug') Begin
   set  @pmonth = '08'
End  
Else if(@pmonth = 'sep') Begin
   set  @pmonth = '09'
End  
Else if(@pmonth = 'oct') Begin
   set  @pmonth = '10'
End 
Else if(@pmonth = 'nov') Begin
   set  @pmonth = '11'
End 
Else if(@pmonth = 'dec') Begin
   set  @pmonth = '12'
End
Else Begin
   set  @pmonth = '00'
End


if(@pday = 'sun')
begin
   set  @pday = 'Sunday'
end  
else if(@pday = 'mon')
begin
   set  @pday = 'Monday'
end  
else if(@pday = 'tue')
begin
   set  @pday = 'Tuesday'
end  
else if(@pday = 'wed')
begin
   set  @pday = 'Wednesday'
end  
else if(@pday = 'thu')
begin
   set  @pday = 'Thursday'
end  
else if(@pday = 'fri')
begin
   set  @pday = 'Friday'
end  
else if(@pday = 'sat')
begin
   set  @pday = 'Saturday'
end  
print (@pday)

SET @vfrdt=(@pmonth+'/'+'01/'+@pyear) 
PRINT( @vfrdt) 
		SET @vtodt1=([dbo].[GetLastDayOfMonth](@vfrdt))
         PRINT('2') 
		set @vtodt=SUBSTRING(@vtodt1,5,2)
print @vtodt1
	    SET @vtodt=(@pmonth+'/'+@vtodt+'/'+@pyear) 
		PRINT @vtodt



    	DELETE FROM   cir_temp_dt    
		
	
		WHILE (0 = 0) BEGIN  
			IF @v_dt >= @vtodt BEGIN 
				BREAK
			END
			ELSE BEGIN 
				IF @v_dt is null BEGIN 
					SET @v_dt  = @vfrdt 
				END
					ELSE BEGIN 
						SET @v_dt  = @v_dt + 1 
					END
			END
			IF UPPER(DATENAME(WEEKDAY, @v_dt))= UPPER(@pday)
			BEGIN 
				 INSERT INTO  cir_temp_dt   ( sqno , dt )   VALUES 		( 1 , @v_dt )  
			END
			ELSE BEGIN 
				INSERT INTO  cir_temp_dt   ( sqno , dt )   VALUES 		( 2 , 	@v_dt )  
			END
		END
		
		OPEN c1 
		fetch NEXT FROM c1 INTO @vdt11,@vday11	
		WHILE (@@FETCH_STATUS = 0) BEGIN 
			SET @v_cnt  = @v_cnt + 1 
			IF @vquery1 is null BEGIN 
			--print @v_cnt
			--SET @vquery1  = 'case day(A.SUPDATE  when day('+@vdt11+') then SUM(isnull(A.SUP_COPY,0)) end P'+left( convert(int, @v_cnt)+000000000,2);
              SET @vquery1  = 'case (select(day(A.SUPDATE)))  when day('''+@vdt11+''') then SUM(isnull(A.SUP_COPY,0)) end P'+dbo.fnPadLeft('0',2,@v_cnt);
			--print 'ankurq'				
			--SET @vdaysup  = 'SUM(isnull(P left( convert(varchar, '+@v_cnt+')+''000000000'',2) ,'+ 0 + ')) AS '+'"'+'left( convert(varchar, '+@v_cnt+')+''000000000'',2)'+'"'
			--print 'ankur'
			--SET @vtotsup  = 'isnull ( P '+' left( convert(varchar, '+@v_cnt+')+''000000000'',2)'+',0)'
             SET @vdaysup  = 'SUM(isnull(P'+ dbo.fnPadLeft('0',2,@v_cnt)+',0)) AS ' + '"' + dbo.fnPadLeft('0',2,@v_cnt) + '"';
             --   print(@vdaysup)
			 SET @vtotsup  = 'isnull(P'+ dbo.fnPadLeft ('0',2,@v_cnt)+',0)';


			END
		ELSE BEGIN
			--print 'gg' 
			--SET @vquery1  = @vquery1 + ',' + 'case day(A.SUPDATE  when day('+@vdt11+') then SUM(isnull(A.SUP_COPY,0)) end P'+left( convert(varchar, @v_cnt)+'000000000',2);
			--SET @vdaysup  = @vdaysup + ',' + 'SUM(isnull(P left( convert(varchar, '+@v_cnt+')+''000000000'',2) ,'+ 0 + ')) AS '+'"'+'left( convert(varchar, '+@v_cnt+')+''000000000'',2)'+'"'
			--SET @vtotsup  = @vtotsup + '+' + 'isnull(P'+'left( convert(varchar, '+@v_cnt+')+''000000000'',2)'+',0)'

            SET @vquery1  = @vquery1 + ',' + 'case (select(day(A.SUPDATE)))  when day('''+@vdt11+''') then SUM(isnull(A.SUP_COPY,0)) end P'+dbo.fnPadLeft('0',2,@v_cnt);
 
			SET @vdaysup  = @vdaysup + ',' + 'SUM(isnull(P'+ dbo.fnPadLeft('0',2,@v_cnt)+',0)) AS ' + '"' + dbo.fnPadLeft('0',2,@v_cnt) + '"';
 
			SET @vtotsup  = @vtotsup + '+' + 'isnull(P'+ dbo.fnPadLeft ('0',2,@v_cnt)+',0)';
		END
   
			fetch NEXT FROM c1 INTO @vdt11,@vday11
		END 
	
print('asadasa')	
		
		close c1
		
		SET @vtotsup  = 'SUM(' + @vtotsup + ')' 
		--insert into test1(vstring,vstring2) values('1 '||vquery1,vdaysup||','||vtotsup||'AS "TOTAL"');
		
		SET @vquery3  = 'SELECT COMP_CODE,UNIT_CODE,AGCD "AGENCY CODE",DPCD "AGENCY SUBCODE",substring(dbo.cir_get_agency(comp_code,unit_code,agcd,dpcd),1,50) "AGENCY NAME",      substring(dbo.cir_get_name_cir_agname(comp_code,unit_code,agcd,dpcd,2,' + '''' + @pdateformat + '''' + ','''',''''),1,50) "AGENCY ONAME",         EDTN,dbo.CIR_GET_EDTN_NAME(COMP_CODE,EDTN) "EDITION NAME",isnull(dbo.CIR_GET_NAME_CIR_EDTN(COMP_CODE,'''',EDTN,2,' + '''' + @pdateformat + '''' + ','''',''''),''NA'') "EDITION ONAME",         isnull(CITY_CODE,''NA'') "CITY CODE",isnull(dbo.CIR_GET_CITY(COMP_CODE,CITY_CODE),''NA'') "CITY NAME",isnull(dbo.CIR_GET_NAME_CIR_CITY(COMP_CODE,CITY_CODE,2,' + '''' + @pdateformat + '''' + ','''',''''),''NA'') "CITY ONAME",         isnull(DIST_CODE,''NA'') "DIST CODE",isnull(dbo.CIR_GET_DIST(COMP_CODE,STATE_CODE,DIST_CODE),''NA'') "DISTRICT NAME",isnull(dbo.CIR_GET_NAME_CIR_DISTRICT(COMP_CODE,DIST_CODE,2,' + '''' + @pdateformat + '''' + ','''',''''),''NA'') "DISTRICT ONAME",         COUNTRY_CODE "COUNTRY CODE",' + @vdaysup + ',' + @vtotsup + 'AS "TOTAL"' + ' FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,A.EDTN EDTN,B.CITY_CODE,B.STATE_CODE STATE_CODE,B.DIST_CODE DIST_CODE,B.COUNTRY_CODE COUNTRY_CODE,' + @vquery1 
		SET @vquery2  = ' FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C  WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=''' + @pcomp_code + ''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=''' + @punit_code + ''' AND  A.AGCD=B.AGCD AND A.DPCD=B.DPCD AND A.PUBL=''' + @ppubl + ''' AND (A.EDTN=''' + @pedtn + ''' OR''' + @pedtn + ''' IS NULL ' + ' OR ''' + @pedtn + ''' = '''' ) AND (B.CITY_CODE=''' + @pcitycd + ''' OR''' + @pcitycd + ''' IS NULL ' + ' OR ''' + @pcitycd + ''' = '''' ) AND (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL' + ' OR ''' + @PDISTCODE + ''' = '''') AND 
        (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL'+ ' OR ''' + @PDISTCODE + ''' = '''') AND (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL' + ' OR ''' + @PBRANCH + ''' = '''') AND
        (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL '+ ' OR ''' + @PAGTYPE + ''' = '''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL '+ ' OR ''' + @PAGCLASS + ''' = '''') AND A.SUP_TYPE_CODE=C.SUP_TY_CODE AND   A.SUPDATE BETWEEN''' + @vfrdt + ''' AND''' + @vtodt + ''' AND isnull(A.SUP_COPY,0)>0          GROUP BY A.COMP_CODE,A.UNIT_CODE,A.AGCD,A.DPCD,A.SUPDATE,A.EDTN,B.CITY_CODE,B.STATE_CODE,B.DIST_CODE,B.COUNTRY_CODE)  m        GROUP BY m.COMP_CODE,m.UNIT_CODE,m.AGCD,m.DPCD,m.EDTN,m.CITY_CODE,m.STATE_CODE,m.DIST_CODE,m.COUNTRY_CODE          ORDER BY m.COMP_CODE,m.UNIT_CODE,m.STATE_CODE,m.DIST_CODE,m.CITY_CODE,m.EDTN,m.AGCD,m.DPCD' 
		--insert into test1(vstring,vstring2) values('2 '||vquery3,VQUERY2);commit;
		
		
		EXEC (@vquery3 + @vquery2)
		SET @vquery3  = 'SELECT COMP_CODE,UNIT_CODE,isnull(DIST_CODE,''NA'') "DIST CODE",isnull(dbo.CIR_GET_DIST(COMP_CODE,STATE_CODE,DIST_CODE),''NA'') "DISTRICT NAME",isnull(dbo.CIR_GET_NAME_CIR_DISTRICT(COMP_CODE,DIST_CODE,2,' + '''' + @pdateformat + '''' + ','''',''''),''NA'') "DISTRICT ONAME",COUNTRY_CODE "COUNTRY CODE",' + @vdaysup + ',' + @vtotsup + 'AS "TOTAL"' + ' FROM (SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,B.STATE_CODE STATE_CODE,B.DIST_CODE DIST_CODE,B.COUNTRY_CODE COUNTRY_CODE,' + @vquery1 
		SET @vquery2  = '  FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=''' + @pcomp_code + ''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=''' + @punit_code + ''' AND A.AGCD=B.AGCD AND A.DPCD=B.DPCD AND A.PUBL=''' + @ppubl + ''' AND (A.EDTN=''' + @pedtn + ''' OR''' + @pedtn + ''' IS NULL ' + ' OR ''' + @pedtn + ''' = '''' ) AND (B.CITY_CODE=''' + @pcitycd + ''' OR''' + @pcitycd + ''' IS NULL ' + ' OR ''' + @pcitycd + ''' = '''') AND  (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL' + ' OR ''' + @PDISTCODE + ''' = '''') AND 
        (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL'+ ' OR ''' + @PDISTCODE + ''' = '''') AND (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL' + ' OR ''' + @PBRANCH + ''' = '''') AND
        (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL '+ ' OR ''' + @PAGTYPE + ''' = '''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL '+ ' OR ''' + @PAGCLASS + ''' = '''') AND A.SUP_TYPE_CODE=C.SUP_TY_CODE AND          A.SUPDATE BETWEEN''' + @vfrdt + ''' AND''' + @vtodt + ''' AND isnull(A.SUP_COPY,0)>0          GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE,B.STATE_CODE,B.DIST_CODE,B.COUNTRY_CODE) o         GROUP BY o.COMP_CODE,o.UNIT_CODE,o.STATE_CODE,o.DIST_CODE,o.COUNTRY_CODE          ORDER BY o.COMP_CODE,o.UNIT_CODE,o.DIST_CODE,o.STATE_CODE' 
		
		EXEC (@vquery3 + @vquery2)
		SET @vquery3  = 'SELECT COMP_CODE,UNIT_CODE,' + @vdaysup + ',' + @vtotsup + 'AS "TOTAL"' + ' FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,' + @vquery1 
		SET @vquery2  = ' FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=''' + @pcomp_code + ''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=''' + @punit_code + ''' AND A.AGCD=B.AGCD AND A.DPCD=B.DPCD AND A.PUBL=''' + @ppubl + ''' AND (A.EDTN=''' + @pedtn + ''' OR''' + @pedtn + ''' IS NULL ' + ' OR ''' + @pedtn + ''' = '''' ) AND (B.CITY_CODE=''' + @pcitycd + ''' OR''' + @pcitycd + ''' IS NULL ' + ' OR ''' + @pcitycd + ''' = '''') AND (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL' + ' OR ''' + @PDISTCODE + ''' = '''') AND 
        (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL'+ ' OR ''' + @PDISTCODE + ''' = '''') AND (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL' + ' OR ''' + @PBRANCH + ''' = '''') AND
        (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL '+ ' OR ''' + @PAGTYPE + ''' = '''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL '+ ' OR ''' + @PAGCLASS + ''' = '''') AND A.SUP_TYPE_CODE=C.SUP_TY_CODE AND A.SUPDATE BETWEEN''' + @vfrdt + ''' AND''' + @vtodt + ''' AND isnull(A.SUP_COPY,0)>0          GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE) q         GROUP BY q.COMP_CODE,q.UNIT_CODE          ORDER BY q.COMP_CODE,q.UNIT_CODE' 
	EXEC (@vquery3 + @vquery2)	
		
 DEALLOCATE c1





for taluka day wise---->





ALTER PROCEDURE [dbo].[cir_rep_supply_cir_rep_taluka_day_daybook]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@pcitycd                                  VARCHAR(20) ,
	@ptalukacd                                 VARCHAR(20) ,
	@pmonth                                   VARCHAR(20) ,
	@pyear                                    VARCHAR(20) ,
	@pday                                     VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pbranch         varchar(20),
     @pdistcode       varchar(20),
     @ptaluka         varchar(20),
     @pagtype         varchar(20),
     @pagclass        varchar(20),
     @pagcode         varchar(20),
     @pdpcode         varchar(20),
     @pextra1         varchar(200),
     @pextra2         varchar(200),
     @pextra3         varchar(200),
     @pextra4         varchar(200),
     @pextra5         varchar(200) 
AS 
	
		
		DECLARE @vquery1                                  VARCHAR(8000) 	
		DECLARE @vquery2                                  VARCHAR(8000) 	
		DECLARE @vquery3                                  VARCHAR(8000) 
		DECLARE @vdaysup                                  VARCHAR(2000) 
		DECLARE @vtotsup                                  VARCHAR(1000) 
		DECLARE @v_dt                                     DATETIME 
		DECLARE @v_day                                    VARCHAR(3) 
		DECLARE @v_cnt                                    INT                           
		SET @v_cnt = 0 




        DECLARE @vday11                                    VARCHAR(80)
        DECLARE @vdt11                                     VARCHAR(80) 




		DECLARE c1 cursor LOCAL FOR 

		SELECT dt, UPPER(DATENAME(WEEKDAY, dt)) supply_day	FROM  cir_temp_dt 	ORDER BY sqno, dt 
		


       	DECLARE @vfrdt         VARCHAR(20)
		DECLARE @vtodt         VARCHAR(20)
       	DECLARE @vtodt1         VARCHAR(20)
		DECLAre @pquery         varchar(8000)
		DECLAre @pquery1         varchar(8000)
		DECLAre @pquery2         varchar(8000)
    

print (@pday)

if(@pday = 'sun')
begin
   set  @pday = 'Sunday'
end  
else if(@pday = 'mon')
begin
   set  @pday = 'Monday'
end  
else if(@pday = 'tue')
begin
   set  @pday = 'Tuesday'
end  
else if(@pday = 'wed')
begin
   set  @pday = 'Wednesday'
end  
else if(@pday = 'thu')
begin
   set  @pday = 'Thursday'
end  
else if(@pday = 'fri')
begin
   set  @pday = 'Friday'
end  
else if(@pday = 'sat')
begin
   set  @pday = 'Saturday'
end  
print (@pday)


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




		DELETE FROM   cir_temp_dt    
		
	
		WHILE (0 = 0) 
		BEGIN 
					IF @v_dt >= @vtodt 
					BEGIN 
						    BREAK

					END
					ELSE
					BEGIN 
							IF @v_dt is null 
							BEGIN 
								    SET @v_dt  = @vfrdt 
							END
							ELSE
							BEGIN 
							     	SET @v_dt  = @v_dt + 1 
							END
		   
					END
		   
					IF UPPER(DATENAME(WEEKDAY, @v_dt))= UPPER(@pday)
					BEGIN 
						    INSERT INTO  cir_temp_dt   ( sqno , dt )   VALUES 		( 1 , @v_dt )  
						
					END
					ELSE
					BEGIN 
						    INSERT INTO  cir_temp_dt   ( sqno , dt )   VALUES 		( 2 , 	@v_dt )  
						
					END
   
		
		END 
		
	
	
		OPEN c1 
		
        fetch NEXT FROM c1 INTO @vdt11,@vday11
		
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN 
		 
		

			SET @v_cnt  = @v_cnt + 1 
			IF @vquery1 is null 
			BEGIN 
                	  PRINT('shachi11') 
 PRINT(@vdt11) 
				SET @vquery1  = 'case (select(day(A.SUPDATE)))  when day('''+@vdt11+''') then SUM(isnull(A.SUP_COPY,0)) end P'+dbo.fnPadLeft('0',2,@v_cnt);
             --	print(@v_cnt)

                SET @vdaysup  = 'SUM(isnull(P'+ dbo.fnPadLeft('0',2,@v_cnt)+',0)) AS ' + '"' + dbo.fnPadLeft('0',2,@v_cnt) + '"';
              
             --   print(@vdaysup)

		        SET @vtotsup  = 'isnull(P'+ dbo.fnPadLeft ('0',2,@v_cnt)+',0)';
 --print(@vtotsup)
               
			END
			ELSE
			BEGIN 
				SET @vquery1  = @vquery1 + ',' + 'case (select(day(A.SUPDATE)))  when day('''+@vdt11+''') then SUM(isnull(A.SUP_COPY,0)) end P'+dbo.fnPadLeft('0',2,@v_cnt);
 
				SET @vdaysup  = @vdaysup + ',' + 'SUM(isnull(P'+ dbo.fnPadLeft('0',2,@v_cnt)+',0)) AS ' + '"' + dbo.fnPadLeft('0',2,@v_cnt) + '"';
 
				SET @vtotsup  = @vtotsup + '+' + 'isnull(P'+ dbo.fnPadLeft ('0',2,@v_cnt)+',0)';

			END
   
		fetch NEXT FROM c1 INTO @vdt11,@vday11	
		END 
		
		
		close c1

--print(@vquery1)

--	
--		SET @vtotsup  = 'SUM(' + @vtotsup + ')' 
--
--		
--		SET @vquery3  = 'SELECT COMP_CODE,UNIT_CODE,AGCD "AGENCY CODE",DPCD "AGENCY SUBCODE",substring(dbo.cir_get_agency(comp_code,unit_code,agcd,dpcd),1,50) "AGENCY NAME",substring(dbo.cir_get_name_cir_agname(comp_code,unit_code,agcd,dpcd,2,' + '''' + @pdateformat + '''' + ','''',''''),1,50) "AGENCY ONAME",         EDTN,dbo.CIR_GET_EDTN_NAME(COMP_CODE,EDTN) "EDITION NAME",isnull(dbo.CIR_GET_NAME_CIR_EDTN(COMP_CODE,'''',EDTN,2,' + '''' + @pdateformat + '''' + ','''',''''),''NA'') "EDITION ONAME",         isnull(CITY_CODE,''NA'') "CITY CODE",isnull(dbo.CIR_GET_CITY(COMP_CODE,CITY_CODE),''NA'') "CITY NAME",isnull(dbo.CIR_GET_NAME_CIR_CITY(COMP_CODE,CITY_CODE,2,' + '''' + @pdateformat + '''' + ','''',''''),''NA'') "CITY ONAME",         isnull(STATE_CODE,''NA'') "STATE CODE",isnull(dbo.CIR_GET_STATE(COMP_CODE,COUNTRY_CODE,STATE_CODE),''NA'') "STATE NAME",COUNTRY_CODE "COUNTRY CODE",' + @vdaysup + ',' + @vtotsup + 'AS "TOTAL"' + ' FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,A.EDTN EDTN,B.CITY_CODE,B.STATE_CODE STATE_CODE,B.COUNTRY_CODE COUNTRY_CODE,' + @vquery1 
--		SET @vquery2  = ' FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C  WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=''' + @pcomp_code + ''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=''' + @punit_code + ''' AND          A.AGCD=B.AGCD AND A.DPCD=B.DPCD AND A.PUBL=''' + @ppubl + ''' AND (A.EDTN=''' + @pedtn + ''' OR''' + @pedtn + ''' IS NULL ' + ' OR ''' + @pedtn + ''' = ''''  ) AND (B.CITY_CODE=''' + @pcitycd + ''' OR''' + @pcitycd + ''' IS NULL ' + ' OR ''' + @pcitycd + ''' = '''') AND          (B.STATE_CODE=''' + @pstatecd + ''' OR''' + @pstatecd + ''' IS NULL ' + ' OR ''' + @pstatecd + ''' = '''') AND A.SUP_TYPE_CODE=C.SUP_TY_CODE AND          A.SUPDATE BETWEEN''' + @vfrdt + ''' AND''' + @vtodt + ''' AND isnull(A.SUP_COPY,0)>0 and  upper (CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, A.SUPDATE),20)) =upper(''' + @pday + ''')          GROUP BY A.COMP_CODE,A.UNIT_CODE,A.AGCD,A.DPCD,A.SUPDATE,A.EDTN,B.CITY_CODE,B.STATE_CODE,B.COUNTRY_CODE) m         GROUP BY m.COMP_CODE,m.UNIT_CODE,m.AGCD,m.DPCD,m.EDTN,m.CITY_CODE,m.STATE_CODE,m.COUNTRY_CODE          ORDER BY m.COMP_CODE,m.UNIT_CODE,m.STATE_CODE,m.CITY_CODE,m.EDTN,m.AGCD,m.DPCD' 
--	
--print (@vquery3 + @vquery2)
--
--		EXEC (@vquery3 + @vquery2)
--		
--	
--		SET @vquery3  = 'SELECT COMP_CODE,UNIT_CODE,isnull(STATE_CODE,''NA'') "STATE CODE",isnull(dbo.CIR_GET_STATE(COMP_CODE,COUNTRY_CODE,STATE_CODE),''NA'') "STATE NAME",COUNTRY_CODE "COUNTRY CODE",' + @vdaysup + ',' + @vtotsup + 'AS "TOTAL"' + ' FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,B.STATE_CODE STATE_CODE,B.COUNTRY_CODE COUNTRY_CODE,' + @vquery1 
--		SET @vquery2  = '    FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C          WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=''' + @pcomp_code + ''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=''' + @punit_code + ''' AND          A.AGCD=B.AGCD AND A.DPCD=B.DPCD AND A.PUBL=''' + @ppubl + ''' AND (A.EDTN=''' + @pedtn + ''' OR''' + @pedtn + ''' IS NULL ' + ' OR ''' + @pedtn + ''' = '''') AND (B.CITY_CODE=''' + @pcitycd + ''' OR''' + @pcitycd + ''' IS NULL ' + ' OR ''' + @pcitycd + ''' = '''') AND          (B.STATE_CODE=''' + @pstatecd + ''' OR''' + @pstatecd + ''' IS NULL ' + ' OR ''' + @pstatecd + ''' = '''') AND A.SUP_TYPE_CODE=C.SUP_TY_CODE AND          A.SUPDATE BETWEEN''' + @vfrdt + ''' AND''' + @vtodt + ''' AND isnull(A.SUP_COPY,0)>0 AND upper (CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, A.SUPDATE),20))=upper(''' + @pday + ''')          GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE,B.STATE_CODE,B.COUNTRY_CODE) o         GROUP BY o.COMP_CODE,o.UNIT_CODE,o.STATE_CODE,o.COUNTRY_CODE          ORDER BY o.COMP_CODE,o.UNIT_CODE,o.STATE_CODE' 
--		
--	
--        EXEC (@vquery3 + @vquery2)
--
--		SET @vquery3  = 'SELECT COMP_CODE,UNIT_CODE,' + @vdaysup + ',' + @vtotsup + 'AS "TOTAL"' + ' FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,' + @vquery1 
--		SET @vquery2  = ' FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C   WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=''' + @pcomp_code + ''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=''' + @punit_code + ''' AND          A.AGCD=B.AGCD AND A.DPCD=B.DPCD AND A.PUBL=''' + @ppubl + ''' AND (A.EDTN=''' + @pedtn + ''' OR''' + @pedtn + ''' IS NULL ' + ' OR ''' + @pedtn + ''' = '''') AND (B.CITY_CODE=''' + @pcitycd + ''' OR''' + @pcitycd + ''' IS NULL ' + ' OR ''' + @pcitycd + ''' = '''') AND          (B.STATE_CODE=''' + @pstatecd + ''' OR''' + @pstatecd + ''' IS NULL ' + ' OR ''' + @pstatecd + ''' = '''') AND A.SUP_TYPE_CODE=C.SUP_TY_CODE AND          A.SUPDATE BETWEEN''' + @vfrdt + ''' AND''' + @vtodt + ''' AND isnull(A.SUP_COPY,0)>0 AND upper (CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, A.SUPDATE),20))=upper(''' + @pday + ''')          GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE)  q        GROUP BY q.COMP_CODE,q.UNIT_CODE          ORDER BY q.COMP_CODE,q.UNIT_CODE' 
--		
--	
--   EXEC (@vquery3 + @vquery2)	


SET @vtotsup  = 'SUM(' + @vtotsup + ')' 
		--insert into test1(vstring,vstring2) values('1 '||vquery1,vdaysup||','||vtotsup||'AS "TOTAL"');
		
		SET @vquery3  = 'SELECT COMP_CODE,UNIT_CODE,AGCD "AGENCY CODE",DPCD "AGENCY SUBCODE",substring(dbo.cir_get_agency(comp_code,unit_code,agcd,dpcd),1,50) "AGENCY NAME",         substring(dbo.cir_get_name_cir_agname(comp_code,unit_code,agcd,dpcd,2,' + '''' + @pdateformat + '''' + ','''',''''),1,50) "AGENCY ONAME",         EDTN,dbo.CIR_GET_EDTN_NAME(COMP_CODE,EDTN) "EDITION NAME",isnull(dbo.CIR_GET_NAME_CIR_EDTN(COMP_CODE,'''',EDTN,2,' + '''' + @pdateformat + '''' + ','''',''''),''NA'') "EDITION ONAME",         isnull(CITY_CODE,''NA'') "CITY CODE",isnull(dbo.CIR_GET_CITY(COMP_CODE,CITY_CODE),''NA'') "CITY NAME",isnull(dbo.CIR_GET_NAME_CIR_CITY(COMP_CODE,CITY_CODE,2,' + '''' + @pdateformat + '''' + ','''',''''),''NA'') "CITY ONAME",         isnull(TEHSIL_TALUKA,''NA'') "TALUKA CODE",isnull(dbo.CIR_GET_TALUKA(COMP_CODE,TEHSIL_TALUKA),''NA'') "TALUKA NAME",isnull(dbo.CIR_GET_NAME_CIR_TALUKA(COMP_CODE,TEHSIL_TALUKA,2,' + '''' + @pdateformat + '''' + ','''',''''),''NA'') "TALUKA ONAME",COUNTRY_CODE "COUNTRY CODE",' + @vdaysup + ',' + @vtotsup + 'AS "TOTAL"' + ' FROM (SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,A.EDTN EDTN,B.CITY_CODE,B.TEHSIL_TALUKA TEHSIL_TALUKA,B.COUNTRY_CODE COUNTRY_CODE,' + @vquery1 
		SET @vquery2  = ' FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C          WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=''' + @pcomp_code + ''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=''' + @punit_code + ''' AND          A.AGCD=B.AGCD AND A.DPCD=B.DPCD AND A.PUBL=''' + @ppubl + ''' AND (A.EDTN=''' + @pedtn + ''' OR''' + @pedtn + ''' IS NULL ' + ' OR ''' + @pedtn + ''' = '''' ) AND (B.CITY_CODE=''' + @pcitycd + ''' OR''' + @pcitycd + ''' IS NULL ' + ' OR ''' + @pcitycd + ''' = '''' ) AND  (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL' + ' OR ''' + @PDISTCODE + ''' = '''') AND 
        (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL'+ ' OR ''' + @PDISTCODE + ''' = '''') AND (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL' + ' OR ''' + @PBRANCH + ''' = '''') AND
        (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL '+ ' OR ''' + @PAGTYPE + ''' = '''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL '+ ' OR ''' + @PAGCLASS + ''' = '''') AND A.SUP_TYPE_CODE=C.SUP_TY_CODE AND          A.SUPDATE BETWEEN''' + @vfrdt + ''' AND''' + @vtodt + ''' AND isnull(A.SUP_COPY,0)>0          GROUP BY A.COMP_CODE,A.UNIT_CODE,A.AGCD,A.DPCD,A.SUPDATE,A.EDTN,B.CITY_CODE,TEHSIL_TALUKA,B.COUNTRY_CODE)m          GROUP BY m.COMP_CODE,m.UNIT_CODE,m.AGCD,m.DPCD,m.EDTN,m.CITY_CODE,m.TEHSIL_TALUKA,m.COUNTRY_CODE          ORDER BY m.COMP_CODE,m.UNIT_CODE,m.TEHSIL_TALUKA,m.CITY_CODE,m.EDTN,m.AGCD,m.DPCD' 
		--insert into test1(vstring,vstring2) values('2 '||vquery3,VQUERY2);commit;
		 EXEC (@vquery3 + @vquery2)
 print (@vquery3 + @vquery2)
		
		
		SET @vquery3  = 'SELECT COMP_CODE,UNIT_CODE,isnull(TEHSIL_TALUKA,''NA'') "TALUKA CODE",isnull(dbo.CIR_GET_TALUKA(COMP_CODE,TEHSIL_TALUKA),''NA'') "TALUKA NAME",isnull(dbo.CIR_GET_NAME_CIR_TALUKA(COMP_CODE,TEHSIL_TALUKA,2,' + '''' + @pdateformat + '''' + ','''',''''),''NA'') "TALUKA ONAME",COUNTRY_CODE "COUNTRY CODE",' + @vdaysup + ',' + @vtotsup + 'AS "TOTAL"' + ' FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,B.TEHSIL_TALUKA TEHSIL_TALUKA,B.COUNTRY_CODE COUNTRY_CODE,' + @vquery1 
		SET @vquery2  = '    FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C  WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=''' + @pcomp_code + ''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=''' + @punit_code + ''' AND          A.AGCD=B.AGCD AND A.DPCD=B.DPCD AND A.PUBL=''' + @ppubl + ''' AND (A.EDTN=''' + @pedtn + ''' OR''' + @pedtn + ''' IS NULL ' + ' OR ''' + @pedtn + ''' = '''' ) AND (B.CITY_CODE=''' + @pcitycd + ''' OR''' + @pcitycd + ''' IS NULL ' + ' OR ''' + @pcitycd + ''' = '''') AND   (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL' + ' OR ''' + @PDISTCODE + ''' = '''') AND 
        (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL'+ ' OR ''' + @PDISTCODE + ''' = '''') AND (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL' + ' OR ''' + @PBRANCH + ''' = '''') AND
        (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL '+ ' OR ''' + @PAGTYPE + ''' = '''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL '+ ' OR ''' + @PAGCLASS + ''' = '''') AND A.SUP_TYPE_CODE=C.SUP_TY_CODE AND          A.SUPDATE BETWEEN''' + @vfrdt + ''' AND''' + @vtodt + ''' AND isnull(A.SUP_COPY,0)>0          GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE,B.TEHSIL_TALUKA,B.COUNTRY_CODE)  o        GROUP BY o.COMP_CODE,o.UNIT_CODE,o.TEHSIL_TALUKA,o.COUNTRY_CODE          ORDER BY o.COMP_CODE,o.UNIT_CODE,o.TEHSIL_TALUKA' 
		 EXEC (@vquery3 + @vquery2)
 print (@vquery3 + @vquery2)
	
		SET @vquery3  = 'SELECT COMP_CODE,UNIT_CODE,' + @vdaysup + ',' + @vtotsup + 'AS "TOTAL"' + ' FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,' + @vquery1 
		SET @vquery2  = ' FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C  WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=''' + @pcomp_code + ''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=''' + @punit_code + ''' AND  A.AGCD=B.AGCD AND A.DPCD=B.DPCD AND A.PUBL=''' + @ppubl + ''' AND (A.EDTN=''' + @pedtn + ''' OR''' + @pedtn + ''' IS NULL ' + ' OR ''' + @pedtn + ''' = '''' ) AND (B.CITY_CODE=''' + @pcitycd + ''' OR''' + @pcitycd + ''' IS NULL ' + ' OR ''' + @pcitycd + ''' = '''') AND   (B.DIST_CODE='''+@PDISTCODE+''' OR '''+@PDISTCODE+''' IS NULL' + ' OR ''' + @PDISTCODE + ''' = '''') AND 
        (B.TEHSIL_TALUKA='''+@PTALUKA+''' OR '''+@PTALUKA+''' IS NULL'+ ' OR ''' + @PDISTCODE + ''' = '''') AND (B.BRANCH_CODE='''+@PBRANCH+''' OR '''+@PBRANCH+''' IS NULL' + ' OR ''' + @PBRANCH + ''' = '''') AND
        (B.AG_TYPE='''+@PAGTYPE+''' OR '''+@PAGTYPE+''' IS NULL '+ ' OR ''' + @PAGTYPE + ''' = '''') AND (B.AG_CLASS='''+@PAGCLASS+''' OR '''+@PAGCLASS+''' IS NULL '+ ' OR ''' + @PAGCLASS + ''' = '''') AND A.SUP_TYPE_CODE=C.SUP_TY_CODE AND          A.SUPDATE BETWEEN''' + @vfrdt + ''' AND''' + @vtodt + ''' AND isnull(A.SUP_COPY,0)>0          GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE)  q        GROUP BY q.COMP_CODE,q.UNIT_CODE          ORDER BY q.COMP_CODE,q.UNIT_CODE' 
		 EXEC (@vquery3 + @vquery2)
 print (@vquery3 + @vquery2)

 DEALLOCATE c1






/////////////////////////end of 4566  4698


//*********************************************5441******************************************************//

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[cir_for_dispute_bill]
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @pagency_type    as varchar(20),
    @pclass_type     as varchar(20),
    @pagcd           as varchar(20),
    @pdpcd           as varchar(20),   
    @ppubltype       as varchar(20),
    @ppublcode       as varchar(20),
    @pfromdate       as datetime, 
    @ptilldate       as datetime,
    @ptype           as varchar(20),--for disputed D or undisputed bill U
    @puserid         as varchar(20), 
    @pdateformate    as varchar(20),
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
begin
    If @pcompcode='' Begin
		set @pcompcode=null
	End	
    If @punitcode='' Begin
		set @punitcode=null
	End	
    If @pagency_type='' Begin
		set @pagency_type=null
	End	
    If @pclass_type='' Begin
		set @pclass_type=null
	End	
    If @pagcd='' Begin
		set @pagcd=null
	End		
    If @pdpcd='' Begin
		set @pdpcd=null
	End	
    If @ppubltype='' Begin
		set @ppubltype=null
	End	
    If @ppublcode='' Begin
		set @ppublcode=null
	End						

    if upper(@ptype)='U' Begin--for Undisputed bills
        if @ppubltype is null and @ppublcode is null Begin
            select o.comp_code AS "COMP_CODE",o.unit_code AS "UNIT_CODE",o.agcd as "AGCD",o.dpcd as "DPCD", m.ag_name as "AGENCY_NAME",
            m.station_code as "DROP_POINT",dbo.cir_get_drop_point_name(o.comp_code,o.unit_code,m.station_code,1) as "DROP_POINT_NAME", 
            m.city_code as "CITY_CODE",dbo.cir_get_city(o.comp_code,m.city_code) as "CITY_NAME",  
            o.billno as "BILLNO", o.billdt as "BILLDT" ,o.publ as "PUBL" ,dbo.cir_get_publ_name(o.comp_code,o.publ) as "PUBL_NAME",
            b.amount as "BILL_AMOUNT",sum(o.amount) as "DUE_AMOUNT",isnull(b.dispute_flag,'N') as "DISPUTE_BILL",null  as "DISPUTE_REMARK" from cir_outmast o,cir_agmast m,cir_outmast b 
                where o.comp_code=m.comp_code and o.comp_code=b.comp_code and o.comp_code=@pcompcode and 
                     o.unit_code=m.unit and o.unit_code=b.unit_code and o.unit_code=@punitcode and o.doctyp=b.doctyp and o.doctyp='BIL' and 
                    o.agcd=m.agcd and o.agcd=b.agcd and o.agcd =isnull(@pagcd,o.agcd) and o.dpcd=m.dpcd and o.dpcd=b.dpcd and o.dpcd =isnull(@pdpcd,o.dpcd) and 
                    o.billdt=b.billdt and o.billdt between @pfromdate and @ptilldate and (o.publ = @ppublcode or @ppublcode is null) and 
                    o.billno=b.billno and o.billno  is not null and (m.ag_type=@pagency_type or @pagency_type is null) and 
                    (m.ag_class=@pclass_type or @pclass_type is null) and isnull(b.dispute_flag,'N')='N'
                group by  o.comp_code,o.unit_code,o.agcd,o.dpcd,m.ag_name,m.station_code,m.city_code,o.billno, o.billdt, o.publ,b.amount,isnull(b.dispute_flag,'N')
                having sum( o.amount )>0
                order by agency_name,billdt,billno
         End       
         Else Begin
            select o.comp_code AS "COMP_CODE",o.unit_code AS "UNIT_CODE",o.agcd as "AGCD",o.dpcd as "DPCD", m.ag_name as "AGENCY_NAME",
            m.station_code as "DROP_POINT",dbo.cir_get_drop_point_name(o.comp_code,o.unit_code,m.station_code,1) as "DROP_POINT_NAME", 
            m.city_code as "CITY_CODE",dbo.cir_get_city(o.comp_code,m.city_code) as "CITY_NAME",  
            o.billno as "BILLNO", o.billdt as "BILLDT" ,o.publ as "PUBL" ,dbo.cir_get_publ_name(o.comp_code,o.publ) as "PUBL_NAME",
            b.amount as "BILL_AMOUNT",sum(o.amount) as "DUE_AMOUNT",isnull(b.dispute_flag,'N') as "DISPUTE_BILL", null as "DISPUTE_REMARK" from cir_outmast o,cir_agmast m,cir_outmast b 
                where o.comp_code=m.comp_code and o.comp_code=b.comp_code and o.comp_code=@pcompcode and 
                     o.unit_code=m.unit and o.unit_code=b.unit_code and o.unit_code=@punitcode and o.doctyp=b.doctyp and o.doctyp='BIL' and 
                    o.agcd=m.agcd and o.agcd=b.agcd and o.agcd =isnull(@pagcd,o.agcd) and o.dpcd=m.dpcd and o.dpcd=b.dpcd and o.dpcd =isnull(@pdpcd,o.dpcd) and 
                    o.billdt=b.billdt and o.billdt between @pfromdate and @ptilldate and (o.publ = @ppublcode or @ppublcode is null) and 
                    o.billno=b.billno and o.billno  is not null and (m.ag_type=@pagency_type or @pagency_type is null) and 
                    (m.ag_class=@pclass_type or @pclass_type is null) and isnull(b.dispute_flag,'N')='N' and 
                    b.publ in(select publ from cir_publ_mast where comp_code=@pcompcode and publ=isnull(@ppublcode,publ) and pro_type=isnull(@ppubltype,pro_type)) 
                group by  o.comp_code,o.unit_code,o.agcd,o.dpcd,m.ag_name,m.station_code,m.city_code,o.billno, o.billdt, o.publ,b.amount,isnull(b.dispute_flag,'N')
                having sum( o.amount )>0
                order by agency_name,billdt,billno
         End
     End    
     Else Begin--for disputed bills
        If (@ppubltype is null or @ppubltype='') and (@ppublcode is null or @ppublcode='') Begin
            select o.comp_code AS "COMP_CODE",o.unit_code AS "UNIT_CODE",o.agcd as "AGCD",o.dpcd as "DPCD", m.ag_name as "AGENCY_NAME",
            m.station_code as "DROP_POINT",dbo.cir_get_drop_point_name(o.comp_code,o.unit_code,m.station_code,1) as "DROP_POINT_NAME", 
            m.city_code as "CITY_CODE",dbo.cir_get_city(o.comp_code,m.city_code) as "CITY_NAME",  
            o.billno as "BILLNO", o.billdt as "BILLDT" ,o.publ as "PUBL" ,dbo.cir_get_publ_name(o.comp_code,o.publ) as "PUBL_NAME",
            b.amount as "BILL_AMOUNT",sum(o.amount) as "DUE_AMOUNT",isnull(b.dispute_flag,'N') as "DISPUTE_BILL",b.dispute_rmrk  as "DISPUTE_REMARK"  from cir_outmast o,cir_agmast m,cir_outmast b 
                where o.comp_code=m.comp_code and o.comp_code=b.comp_code and o.comp_code=@pcompcode and 
                     o.unit_code=m.unit and o.unit_code=b.unit_code and o.unit_code=@punitcode and o.doctyp=b.doctyp and o.doctyp='BIL' and 
                    o.agcd=m.agcd and o.agcd=b.agcd and o.agcd =isnull(@pagcd,o.agcd) and o.dpcd=m.dpcd and o.dpcd=b.dpcd and o.dpcd =isnull(@pdpcd,o.dpcd) and 
                    o.billdt=b.billdt and o.billdt between @pfromdate and @ptilldate and (o.publ = @ppublcode or @ppublcode is null) and 
                    o.billno=b.billno and o.billno  is not null and (m.ag_type=@pagency_type or @pagency_type is null) and 
                    (m.ag_class=@pclass_type or @pclass_type is null) and isnull(b.dispute_flag,'N')='Y'
                group by  o.comp_code,o.unit_code,o.agcd,o.dpcd,m.ag_name,m.station_code,m.city_code,o.billno, o.billdt, o.publ,b.amount,isnull(b.dispute_flag,'N'),
                b.dispute_rmrk
                having sum( o.amount )>0
                order by agency_name,billdt,billno
         End       
         Else Begin
            select o.comp_code AS "COMP_CODE",o.unit_code AS "UNIT_CODE",o.agcd as "AGCD",o.dpcd as "DPCD", m.ag_name as "AGENCY_NAME",
            m.station_code as "DROP_POINT",dbo.cir_get_drop_point_name(o.comp_code,o.unit_code,m.station_code,1) as "DROP_POINT_NAME", 
            m.city_code as "CITY_CODE",dbo.cir_get_city(o.comp_code,m.city_code) as "CITY_NAME",  
            o.billno as "BILLNO", o.billdt as "BILLDT" ,o.publ as "PUBL" ,dbo.cir_get_publ_name(o.comp_code,o.publ) as "PUBL_NAME",
            b.amount as "BILL_AMOUNT",sum(o.amount) as "DUE_AMOUNT",isnull(b.dispute_flag,'N') as "DISPUTE_BILL",b.dispute_rmrk  as "DISPUTE_REMARK" from cir_outmast o,cir_agmast m,cir_outmast b 
                where o.comp_code=m.comp_code and o.comp_code=b.comp_code and o.comp_code=@pcompcode and 
                     o.unit_code=m.unit and o.unit_code=b.unit_code and o.unit_code=@punitcode and o.doctyp=b.doctyp and o.doctyp='BIL' and 
                    o.agcd=m.agcd and o.agcd=b.agcd and o.agcd =isnull(@pagcd,o.agcd) and o.dpcd=m.dpcd and o.dpcd=b.dpcd and o.dpcd =isnull(@pdpcd,o.dpcd) and 
                    o.billdt=b.billdt and o.billdt between @pfromdate and @ptilldate and (o.publ = @ppublcode or @ppublcode is null) and 
                    o.billno=b.billno and o.billno  is not null and (m.ag_type=@pagency_type or @pagency_type is null) and 
                    (m.ag_class=@pclass_type or @pclass_type is null) and isnull(b.dispute_flag,'N')='Y' and
                    b.publ in(select publ from cir_publ_mast where comp_code=@pcompcode and publ=isnull(@ppublcode,publ) and pro_type=isnull(@ppubltype,pro_type))
                group by  o.comp_code,o.unit_code,o.agcd,o.dpcd,m.ag_name,m.station_code,m.city_code,o.billno, o.billdt, o.publ,b.amount,isnull(b.dispute_flag,'N'),
                b.dispute_rmrk
                having sum( o.amount )>0
                order by agency_name,billdt,billno;
         End    
     End       
    
    select getdate() as "CUR_DATE"
    
End

//**********************************************************5441**********************************************//

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[cir_updation_dispute_bill]
    @pcompcode           as varchar(50),
    @punitcode           as varchar(50),
    @pagcd               as varchar(50),
    @pdpcd               as varchar(50),
    @pbillno             as varchar(50),
    @pbilldt             as datetime,
    @pdisputed_rmrk      as varchar(500),
    @pdisputed_flag      as varchar(5),
    @ptype               as varchar(50),--for disputed D or undisputed bill U
    @puserid             as varchar(50), 
    @pdateformate        as varchar(50),
    @pextra1             as varchar(50),
    @pextra2             as varchar(50),
    @pextra3             as varchar(50),
    @pextra4             as varchar(50),
    @pextra5             as varchar(50),
    @pextra6             as varchar(50),
    @pextra7             as varchar(50),
    @pextra8             as varchar(50),
    @pextra9             as varchar(50),
    @pextra10            as varchar(50)
As
    
begin
	declare @v_cnt int
    If @ptype='D' Begin
        select @v_cnt=count(*)  from cir_outmast where comp_code=@pcompcode and unit_code=@punitcode and doctyp='BIL' and 
            billno=@pbillno and billdt=@pbilldt and agcd=@pagcd and dpcd=@pdpcd and isnull(dispute_flag,'N')='Y'
    End        
    else Begin
        select @v_cnt=count(*) from cir_outmast where comp_code=@pcompcode and unit_code=@punitcode and doctyp='BIL' and 
            billno=@pbillno and billdt=@pbilldt and agcd=@pagcd and dpcd=@pdpcd and (isnull(dispute_flag,'N')='N' or dispute_flag='')
    End
    
    if @v_cnt>0 Begin
        set @v_cnt=0
        update cir_outmast set dispute_flag=@pdisputed_flag, dispute_user_code=@puserid, dispute_dt =getdate(),
        dispute_rmrk=@pdisputed_rmrk
         where comp_code=@pcompcode and unit_code=@punitcode and doctyp='BIL' and 
            billno=@pbillno and billdt=@pbilldt and agcd=@pagcd and dpcd=@pdpcd
        set @v_cnt=1
    End
    
    select @v_cnt as "UPDATE_RECORD"
    
End


*********************************5738***************************************

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[cir_gen_code_mach_config_code_P] 
    @pcompcode		as	varchar(20),
    @pdateformat	as	varchar(20),
    @pextra1 		as	varchar(20),
    @pextra2 		as	varchar(20) as
BEGIN
	declare @vno	as numeric(8)
	
    select @vno=isnull(max(MACH_ID),0)+1  from cir_mach_config_mast

   select @vno as "VAR_CODE"
End

//************************************************************************





/*****************************************************************mimoh 25 nov*******************0005749***************************/
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
@p_CIR_UNSOLD_ON_RECEIVED_DT AS VARCHAR(5)
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
CIR_UNSOLD_INCLUDE_INSFEE=@p_CIR_UNSOLD_INCLUDE_INSFEE,CIR_UNSOLD_ON_RECEIVED_DT=@p_CIR_UNSOLD_ON_RECEIVED_DT
 WHERE comp_code=@compcode




/* ,
',Unsold_Entry_Flag='''+@Unsoldflag+''',Supply_Stop_Percentage='''+@Supplystopper+'''

,ROKEYCHECK='''+@drpRokeychk+''',AGENCYCOMM_SEQ_COM='''+@Agencycomm_seq+''' ,CREDIT_RECIPT='''+@creditreciept+''' where    comp_code='''+@compcode+'''   ' 



--,DISP_CASHBILL='''+@cashindisplay+''',CLA_CASHBILL='''+@cashinclassified+'''
*/

print(@query1)
exec(@query1)





































/***********************************************************************************************************/

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
CIR_AUTO_APPROVAL_UNSOLD, CIR_AUTO_PHYSICAL_UNSOLD, CIR_UNSOLD_INCLUDE_INCT, CIR_UNSOLD_INCLUDE_INSFEE, CIR_UNSOLD_ON_RECEIVED_DT
           FROM PREFERRENCES
          WHERE comp_code = @compcode






























/*****************************************************************mimoh 25 nov*******************0005749***************************/
	/************************************Lata 29 nov 2011*****************/
	set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[cir_unsold_credit_note_cir_notapproval_list_p]
    @pcomp_code    as varchar(50),
    @punit_code    as varchar(50),
    @pdoc_type     As varchar(50),
    @pdateformat   as varchar(50),
    @pextra1       as varchar(50),
    @pextra2       As varchar(50),
	@pextra3       as varchar(50) -- for receipt no
As
Begin
    If upper(@pextra2)='D' Begin
        SELECT DISTINCT H.RECPTNO RECPTNO,H.RECPTDT RECPTDT,H.AGCD AGCD,H.DPCD DPCD,DBO.CIR_GET_AGENCY(H.COMP_CODE,H.UNIT_CODE,H.AGCD,H.DPCD) AGENCY_NAME,
        DBO.CIR_GET_AGENCY_CITY(H.COMP_CODE,H.UNIT_CODE,H.AGCD,H.DPCD) CITY_NAME,H.PUBL PUBL,DBO.CIR_GET_PUBL_NAME(H.COMP_CODE,H.PUBL) PUBL_NAME,H.EDTN EDTN,
        DBO.CIR_GET_EDTN_NAME(H.COMP_CODE,H.EDTN) EDTN_NAME,H.ENTRYDT ENTRYDT,H.FRDT FRDT,H.TODT TODT,
        H.SUP_AGCD SUP_AGCD,H.SUP_DPCD SUP_DPCD,M.AG_NAME SUP_AGENCY, DBO.CIR_GET_CITY(H.COMP_CODE,M.CITY_CODE) SUP_CITY_NAME
        from cir_unsold_hdr_dis h,cir_agmast_dis m
        where h.comp_code=m.comp_code and h.comp_code=@pcomp_code and h.unit_code=m.unit and h.unit_code=@punit_code and h.doctype=@pdoc_type and
        h.sup_agcd=m.agcd and h.sup_dpcd=m.dpcd and (upper(m.ag_name) like upper(@pextra1)+'%' or @pextra1 is null or @pextra1='') and (h.app_userid is null or h.app_userid='')
		and (H.RECPTNO=@pextra3 or @pextra3='' or @pextra3 is null)
        order by recptdt,recptno,agency_name
    End
    Else Begin
        SELECT DISTINCT H.RECPTNO RECPTNO,H.RECPTDT RECPTDT,H.AGCD AGCD,H.DPCD DPCD,DBO.CIR_GET_AGENCY(H.COMP_CODE,H.UNIT_CODE,H.AGCD,H.DPCD) AGENCY_NAME,
        DBO.CIR_GET_AGENCY_CITY(H.COMP_CODE,H.UNIT_CODE,H.AGCD,H.DPCD) CITY_NAME,H.PUBL PUBL,DBO.CIR_GET_PUBL_NAME(H.COMP_CODE,H.PUBL) PUBL_NAME,H.EDTN EDTN,
        DBO.CIR_GET_EDTN_NAME(H.COMP_CODE,H.EDTN) EDTN_NAME,H.ENTRYDT ENTRYDT,H.FRDT FRDT,H.TODT TODT,
        H.SUP_AGCD SUP_AGCD,H.SUP_DPCD SUP_DPCD,M.AG_NAME SUP_AGENCY, DBO.CIR_GET_CITY(H.COMP_CODE,M.CITY_CODE) SUP_CITY_NAME
        from cir_unsold_hdr h,cir_agmast m
        where h.comp_code=m.comp_code and h.comp_code=@pcomp_code and h.unit_code=m.unit and h.unit_code=@punit_code and h.doctype=@pdoc_type and
        h.sup_agcd=m.agcd and h.sup_dpcd=m.dpcd and (upper(m.ag_name) like upper(@pextra1)+'%' or @pextra1 is null or @pextra1='') and (h.app_userid is null or h.app_userid='')
		and (H.RECPTNO=@pextra3 or @pextra3='' or @pextra3 is null)
        order by recptdt,recptno,agency_name
      End
end


/**********************************29 nov 2011 ******************/
	



/***************************29-nov-2011**********mimoh***************/
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
            sum(d.copy_amt) as "NET_AMT",sum(isnull(d.short_recpt,0)+isnull(d.late_recpt,0)+isnull(d.bnr,0)+isnull(d.unsold,0)) as "NET_UNSOLD"
            from cir_unsold_hdr_dis h,cir_unsold_dtl_dis d,cir_agmast_dis m
            where h.comp_code=d.comp_code and h.comp_code=m.comp_code and h.comp_code=@pcompcode and 
                h.unit_code=d.unit_code and h.unit_code=m.unit and h.unit_code=@punitcode and h.doctype=d.doctype and h.agcd=d.agcd and h.agcd=m.agcd and 
                h.dpcd=d.dpcd and h.dpcd=m.dpcd and (h.agcd=@pagcd or @pagcd is null or @pagcd='') and (h.dpcd=@pdpcd or @pdpcd is null or @pdpcd='') and
                h.recptdt=d.recptdt and 
                ((h.recptdt>=@v_from_date and h.recptdt<=@v_till_date) or @pfromdate is null or @pfromdate='') and 
                h.recptno=d.recptno and h.recptno=isnull(@precptno,h.recptno) and (d.branch_code=@pbrancode or @pbrancode is null or @pbrancode='') and
                (d.app_userid is null or d.app_userid='') and (isnull(d.apr_short_recpt,0)+isnull(d.apr_late_recpt,0)+isnull(d.apr_bnr,0)+isnull(d.apr_unsold,0))=0 and
                ((h.entrydt>=@v_efrom_date and h.entrydt<=@v_etill_date) or @pentry_fromdt is null or @pentry_fromdt='') and
                (m.station_code=@pdroppoint or @pdroppoint is null or @pdroppoint='')
            group by h.comp_code,h.unit_code,h.agcd,h.dpcd,m.ag_name,m.city_code,h.doctype,h.recptno,h.recptdt,m.station_code
            order by recptdt,recptno,agency_name
    End
    Else Begin
        select h.comp_code as "COMP_CODE",h.unit_code "UNIT_CODE",h.agcd as "AGCD",h.dpcd as "DPCD",m.ag_name as "AGENCY_NAME",m.city_code as "CITY_CODE",
            dbo.cir_get_city(h.comp_code,m.city_code) as "CITY_NAME",h.doctype as "DOCTYPE",h.recptno as "RECPTNO",h.recptdt as "RECPTDT",
            m.station_code as "DROP_POINT",dbo.cir_get_drop_point_name(h.comp_code,h.unit_code,m.station_code,'1') as "DROP_POINT_NAME",
            sum(d.copy_amt) as "NET_AMT",sum(isnull(d.short_recpt,0)+isnull(d.late_recpt,0)+isnull(d.bnr,0)+isnull(d.unsold,0)) as "NET_UNSOLD"
            from cir_unsold_hdr h,cir_unsold_dtl d,cir_agmast m
            where h.comp_code=d.comp_code and h.comp_code=m.comp_code and h.comp_code=@pcompcode and 
                h.unit_code=d.unit_code and h.unit_code=m.unit and h.unit_code=@punitcode and h.doctype=d.doctype and h.agcd=d.agcd and h.agcd=m.agcd and 
                h.dpcd=d.dpcd and h.dpcd=m.dpcd and (h.agcd=@pagcd or @pagcd is null or @pagcd='') and (h.dpcd=@pdpcd or @pdpcd is null or @pdpcd='') and
                h.recptdt=d.recptdt and 
                ((h.recptdt>=@v_from_date and h.recptdt<=@v_till_date) or @pfromdate is null or @pfromdate='') and 
                h.recptno=d.recptno and h.recptno=isnull(@precptno,h.recptno) and (d.branch_code=@pbrancode or @pbrancode is null or @pbrancode='') and
                (d.app_userid is null or d.app_userid='') and (isnull(d.apr_short_recpt,0)+isnull(d.apr_late_recpt,0)+isnull(d.apr_bnr,0)+isnull(d.apr_unsold,0))=0 and
                ((h.entrydt>=@v_efrom_date and h.entrydt<=@v_etill_date) or @pentry_fromdt is null or @pentry_fromdt='') and
                (m.station_code=@pdroppoint or @pdroppoint is null or @pdroppoint='')
            group by h.comp_code,h.unit_code,h.agcd,h.dpcd,m.ag_name,m.city_code,h.doctype,h.recptno,h.recptdt,m.station_code
            order by recptdt,recptno,agency_name
    End
End



/***************************29-nov-2011**********mimoh***************/

/**********************Start*****01-dec-2011**Issue no 5718********neha***************/
ALTER PROCEDURE cir_rep_agency_ledger_cir_agency_ledger_p
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
	If @punitcode='' Begin
		set @punitcode=null
	End
	If @pactype='' Begin
		set @pactype=null
	End
	If @pbranchcode='' Begin
		set @pbranchcode=null
	End
	If @pagency_type='' Begin
		set @pagency_type=null
	End
	If @pagcd='' Begin
		set @pagcd=null
	End
	If @pdpcd='' Begin
		set @pdpcd=null
	End
	If @pstatecode='' Begin
		set @pstatecode=null
	End
	If @pdistcode='' Begin
		set @pdistcode=null
	End

	If @pcitycode='' Begin
		set @pcitycode=null
	End
	If @ptalukacode='' Begin
		set @ptalukacode=null
	End
	If @pbilladj_flag='' Begin
		set @pbilladj_flag=null
	End
	If @pextra1='' Begin
		set @pextra1=null
	End
	If @pextra2='' Begin
		set @pextra2=null
	End

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
		fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit,@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_name_oth_lang,@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,@v1_country_code,@v1_branch_code
		WHILE (@@FETCH_STATUS = 0)  Begin
		set @v_opbal =dbo.cir_accounts_cir_agency_opbal(@pcompcode, @punitcode,null,@v1_agcd, @v1_dpcd, @v_opdate, @pactype,@pdateformat,null,null)

		----for secutiry outstanding---
		If @pactype='NM' Begin
			set @v_opbal_sec	=dbo.cir_accounts_cir_agency_opbal(@pcompcode, @punitcode,null,@v1_agcd,@v1_dpcd,@v_opdate,'SC',@pdateformat,null,null)

			select @v_dbcramt	=sum(amount) from cir_rcphdr
			where comp_code = @pcompcode and unit_code= @punitcode and 
				agcd=@v1_agcd and dpcd=@v1_dpcd and recptdt>= @v_opdate and recptdt<=@v_todt and achd='SC'

			set @v_opbal_sec=isnull(@v_opbal_sec,0)+isnull(@v_dbcramt,0)
		End
		Else Begin
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
            
		If @v_runbal>=0 Begin
			set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), @v_runbal ))+' Dr.'
		End
        Else Begin
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
			'Bill Copy '+ cast(sum(bill_copy) as VARCHAR)+' Trade Disc. '+cast(sum(comm_amount) as VARCHAR) narration,null received_from from cir_bill
				where comp_code=@v1_comp_code and unit_code=@v1_unit and agcd=@v1_agcd and dpcd=@v1_dpcd and 
					billdt between @v_frdt and @v_todt and @pactype='NM'
					group by comp_code,unit_code,agcd,dpcd,billno,billdt)u
			order by recptdt,doctype,recptno

		--------daily transactions------------
			open c2
			fetch NEXT FROM c2 INTO @v2_comp_code,@v2_unit_code,@v2_agcd,@v2_dpcd,@v2_doctype,@v2_recptno,@v2_recptdt,@v2_amount,@v2_chno,@v2_chdt,@v2_chbank,@v2_reason,@v2_narration,@v2_received_from
			WHILE (@@FETCH_STATUS = 0) Begin
				If isnull(@v2_amount,0)<>0 Begin
					set @v_rec_seqno=isnull(@v_rec_seqno,0)+1
					set @v_narration=null


					If @v2_doctype='BIL' Begin
						set @v_narration=@v2_narration
					End
					Else Begin
						If @v2_narration is not null Begin
							set @v_narration=@v2_narration
										
							If @v2_chno is not null Begin
								set @v_narration=@v_narration+' CHNO# '+@v2_chno
							End
							If @v2_chdt is not null Begin
								set @v_narration=@v_narration+' CHDT '+@v2_chdt
							End

							If @v2_chbank is not null Begin
								set @v_narration=@v_narration+' CHBNK '+@v2_chbank
							End
						End
					End
				End	
				Else Begin
					If @v2_chno is not null Begin
						set @v_narration='CHNO# '+@v2_chno
					End
					If @v2_chdt is not null Begin
						set @v_narration =@v_narration+' CHDT '+ DBO.convert_user_date('/',@v2_chdt,@pdateformat)  
					End

					If @v2_chbank is not null Begin
						set @v_narration=@v_narration+' CHBANK '+@v2_chbank
					End
					If @v2_reason='CASH' and @v2_doctype='RCR' Begin
						set @v_narration='By Cash '+@v_narration
					End
				End

			set @v_remark_len = LEN(ISNULL(LTRIM(RTRIM(@v_narration)), '-'))
			set @v_amt=isnull(@v_amt,0)+isnull(@v2_amount,0)
			                    

			set @v_runbal = @v_runbal+isnull(@v2_amount,0)

			If @v_runbal>=0 Begin
				set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), @v_runbal ))+' Dr.'
			End
			Else Begin
				set @v_runbal_txt=CONVERT(VARCHAR, CONVERT( numeric(14, 2), abs(@v_runbal) ))+' Cr.'
			End
			                                        
			If isnull(@v2_amount,0)>=0 Begin
				set @v_dbamt=isnull(@v_dbamt,0)+isnull(@v2_amount,0)
			End
			If isnull(@v2_amount,0)<0 Begin
				set @v_cramt=isnull(@v_cramt,0)+abs(isnull(@v2_amount,0))
			End
			
			insert into #cir_ledger_report
				  (comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
				  exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
				  billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line)
			  values(@v1_comp_code, @v1_unit, @v1_branch_code, @v1_agcd, @v1_dpcd, @v2_doctype, @v2_recptno, @v2_recptdt, @v2_amount,
					 @v2_received_from,isnull(ltrim(rtrim(@v_narration)),'-'), @v2_chno, @v2_chdt, @v2_chbank, @v2_reason,null, @v_runbal_txt,
					 null, null, null, null, @v_runbal, @v1_ag_name, @v_rec_seqno, dbo.mod_function(@v_remark_len, @v_divident))

			fetch NEXT FROM c2 INTO @v2_comp_code,@v2_unit_code,@v2_agcd,@v2_dpcd,@v2_doctype,@v2_recptno,@v2_recptdt,@v2_amount,@v2_chno,@v2_chdt,@v2_chbank,@v2_reason,
			@v2_narration,@v2_received_from
		End

        close c2
		deallocate c2
		
		--------daily transactions------------
            
        set @v_clbal =isnull(@v_opbal,0)+isnull(@v_amt,0)

        set @v_rec_seqno=isnull(@v_rec_seqno,0)+1
		If @v_runbal>=0 Begin
			set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), @v_runbal ))+' Dr.'
		End
		Else Begin
			set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), abs(@v_runbal) ))+' Cr.'
		End

			insert into #cir_ledger_report
			(comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
			exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
			billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line)
			values(@v1_comp_code, @v1_unit, @v1_branch_code, @v1_agcd, @v1_dpcd, null, null, @v_todt,isnull(@v_clbal,0),
			null,'Closing Balance',null,null,null,null,null,null,
			null,null,null,null,null, @v1_ag_name, @v_rec_seqno,1)

        If isnull(@v_opbal_sec,0)=0 and isnull(@v_opbal,0)=0 and @v_cramt=0 and @v_dbamt=0 Begin
           delete from #cir_ledger_report where comp_code = @v1_comp_code and unit_code = @v1_unit and
            agcd = @v1_agcd and dpcd = @v1_dpcd
        End

        set @v_billamt=0 set @v_dbcramt=0 set @v_opbal=0 set @v_clbal=0 set @v_amt=0 set @v_runbal=0 set @v_cramt=0 set @v_dbamt=0 set @v_runbal_txt=null
        
		fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit,@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_name_oth_lang,@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,
            @v1_country_code,@v1_branch_code     
        End

        close c1
		DEALLOCATE c1

		SELECT (SELECT Comp_Name FROM  comp_mst WHERE Comp_Code  = a.comp_code) as "CNAME",
			COMP_CODE,UNIT_CODE,BRANCH_CODE,(select "Branch_Name" from branch_mst where "Branch_Code"=branch_code) "BRANCH_NAME",
			AGCD,DPCD,AGNAME,DBO.cir_get_agency_city(comp_code,unit_code,agcd,dpcd) CITY_NAME,
			DOCTYPE,RECPTNO,RECPTDT,
			CASE a.debit WHEN 'D' THEN a.amount END as DEBIT,
			CASE a.credit WHEN 'C' THEN a.amount END as CREDIT,
			 EXEC_CODE,REMARKS,CHQNO,CHQDT,CHQ_BANK,REASON,DEBIT_HEAD,CREDIT_HEAD,BILLNO,BILLDT,BILLAMT,
			 ADJAMT,LEFTAMT,REC_SEQNO,narr_line
		FROM (SELECT comp_code,unit_code,branch_code,agcd,dpcd,agname,doctype,recptno,recptdt,
			CASE sign(amount) WHEN 1 THEN 'D' END as debit,
			CASE sign(amount) WHEN - 1 THEN 'C' END as credit,
				 ABS(amount) as amount,exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
				 billno,billdt,billamt,adjamt,leftamt,rec_seqno,ISNULL(narr_line, 1) as narr_line
		FROM  #cir_ledger_report 
		WHERE comp_code  = @pcompcode AND unit_code  = @punitcode) a 
		ORDER BY rec_seqno 
	
   SELECT (SELECT Comp_Name FROM  comp_mst WHERE Comp_Code  = a.comp_code) as "CNAME",
			 COMP_CODE,AGCD,DPCD,AGNAME,(SELECT COUNT(*) FROM 
			 ( SELECT     comp_code,     unit_code,     branch_code,     agcd,     dpcd,     agname,     doctype,     recptno,     recptdt,        
	CASE sign(amount)     WHEN 1 THEN 'D' END as DEBIT,
	CASE sign(amount)     WHEN - 1 THEN 'C'    END as CREDIT,ABS(amount) as AMOUNT,     rec_seqno,NARR_LINE
	FROM  #cir_ledger_report   WHERE  comp_code  = @pcompcode   AND unit_code  = @punitcode ) adv_alias_1  
	WHERE  adv_alias_1.comp_code  = a.comp_code  AND adv_alias_1.agcd  = a.agcd  AND adv_alias_1.dpcd  = a.dpcd  AND adv_alias_1.agname  = a.agname ) adv_count_value,
	 ISNULL(SUM(CONVERT(FLOAT, narr_line)), 0) sum_narr
	FROM (SELECT comp_code,unit_code,branch_code,agcd,dpcd,agname,doctype,recptno,recptdt,
		CASE sign(amount) WHEN 1 THEN 'D' END as debit,
		CASE sign(amount) WHEN - 1 THEN 'C' END as credit,ABS(amount) as amount,rec_seqno,narr_line
		FROM  #cir_ledger_report 
		WHERE comp_code  = @pcompcode AND unit_code  = @punitcode) a 
		group by a.comp_code,a.agcd,a.dpcd,a.agname
	ORDER BY comp_code,agcd,dpcd,agname 
	
	drop table #cir_ledger_report
END



/********************************3-dec-2011******************************************/
CREATE    PROCEDURE  AD_RETAIN_COMM_TARGET_INS (@PCOMP_CODE       AS VARCHAR(40),
												@PRETAIN_CODE     AS VARCHAR(40),
												@PTEAM_CODE       AS VARCHAR(40),
												@PADCTG_CODE      AS VARCHAR(40),
												@PFROM_TGT        AS NUMERIC,
												@PTO_TGT          AS NUMERIC,
												@PCUST_TYPE       AS VARCHAR(40),
												@PAD_TYPE         AS VARCHAR(40),
												@PPUB_TYPE        AS VARCHAR(40),
												@PPUBL_CODE       AS VARCHAR(40),
												@PCREATED_BY      AS VARCHAR(40),
												@PCREATED_DT      AS DATETIME,
												@PUPDATED_BY      AS VARCHAR(40),
												@PUPDATED_DT      AS DATETIME,
												@PCOMM_TARGET_ID  AS NUMERIC,
												@PDML_TYPE        AS VARCHAR(40)) AS
BEGIN
 IF ISNULL(@PDML_TYPE,'?')='I' 
   BEGIN 
     INSERT INTO RETAIN_COMM_TARGET (COMP_CODE,RETAIN_CODE,TEAM_CODE,ADCTG_CODE,FROM_TGT,
                                     TO_TGT,CUST_TYPE,AD_TYPE,PUB_TYPE,PUBL_CODE,
                                     CREATED_BY,CREATED_DT,UPDATED_BY,UPDATED_DT,COMM_TARGET_ID)
                            VALUES  (@PCOMP_CODE,@PRETAIN_CODE,@PTEAM_CODE,@PADCTG_CODE,@PFROM_TGT,
                                     @PTO_TGT,@PCUST_TYPE,@PAD_TYPE,@PPUB_TYPE,@PPUBL_CODE,
                                     @PCREATED_BY,@PCREATED_DT,@PUPDATED_BY,@PUPDATED_DT,@PCOMM_TARGET_ID);
   END
 IF ISNULL(@PDML_TYPE,'?')='U' 
   BEGIN
     UPDATE RETAIN_COMM_TARGET SET TEAM_CODE = @PTEAM_CODE, ADCTG_CODE = @PADCTG_CODE, FROM_TGT = @PFROM_TGT,
                                   TO_TGT = @PTO_TGT, CUST_TYPE = @PCUST_TYPE, AD_TYPE = @PAD_TYPE,
                                   PUB_TYPE = @PPUB_TYPE, PUBL_CODE = @PPUBL_CODE, CREATED_BY = @PCREATED_BY,
                                   CREATED_DT = @PCREATED_DT,UPDATED_BY = @PUPDATED_BY,UPDATED_DT = @PUPDATED_DT
        WHERE COMP_CODE      = @PCOMP_CODE
          AND RETAIN_CODE    = @PRETAIN_CODE
          AND COMM_TARGET_ID = @PCOMM_TARGET_ID;
   END
 IF ISNULL(@PDML_TYPE,'?')='D' 
   BEGIN
     DELETE FROM RETAIN_COMM_TARGET
        WHERE COMP_CODE      = @PCOMP_CODE
          AND RETAIN_CODE    = @PRETAIN_CODE
          AND COMM_TARGET_ID = @PCOMM_TARGET_ID;
   END
END



//==============================================issue no. 5798 06/12/2011============================================

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

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
   set @v_dt    = @pexpiry_date + isnull(@pexpiry_days,0)
	print(@v_dt)
      SELECT * FROM cir_bank_guarantee
        where comp_code = @pcomp_code
          and ((agcd    = @pagcd) or (@pagcd is null) or (@pagcd =''))
          and ((dpcd    = @pdpcd) or (@pdpcd is null) or (@pdpcd =''))
          and ((bg_type = @pinstrument_ty) or (@pinstrument_ty is null) or (@pinstrument_ty=''))
          and bg_valid<=@v_dt
END


//==============================================end of issue no. 5798 06/12/2011============================================

//============================================ISSUE NO. 5808,5809 06/12/2011============================================
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
		select distinct a.comp_code comp_code,a.unit_code unit_code,/*a.publ publ,*/a.agcd agcd,a.dpcd dpcd,b.ag_name ag_name,b.ag_name_oth_lang ag_name_oth_lang,
        b.city_code city_code,b.country_code country_code,b.state_code state_code,b.dist_code dist_code,b.tehsil_taluka taluka_code,
        /*a.billno billno,a.billdt billdt,*/sum(a.bill_copy) supply_copy,sum(a.gross_amount) gross_amount,sum(a.sur_amt) sur_amount,sum(a.comm_amt) comm_amount,
        c.bill_sec_amt bill_sec_amt,b.station_code drop_point
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
        		
		DECLARE cur_type cursor FOR
        select doctyp,sum(amount) amount from cir_outmast
            where comp_code=@v1_comp_code and unit_code=@v1_unit_code and
                achd='NM' and doctyp not in('BIL','UCN') and recptdt>=@pfrom_billdt and recptdt<=@ptill_billdt and
                agcd=@v1_agcd and dpcd=@v1_dpcd
            group by doctyp;

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

		fetch NEXT FROM cur_bill INTO @v1_comp_code,@v1_unit_code, @v1_publ,@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_name_oth_lang, @v1_city_code, @v1_country_code, @v1_state_code	,@v1_dist_code, @v1_taluka_code, @v1_billno,@v1_billdt,@v1_supply_copy,
			@v1_gross_amount, @v1_sur_amount,@v1_comm_amount, @v1_bill_sec_amt,@v1_drop_point

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
			SET @v_rec_amt  = 0 

			SELECT @v_rec_amt  =  SUM(amount) FROM  cir_rcphdr 
			WHERE comp_code  = @v1_comp_code AND unit_code  = @v1_unit_code AND achd  = 'SC'
			 AND recptdt  >= @v_opdate AND recptdt  <= @ptill_billdt
			 AND agcd  = @v1_agcd AND dpcd  = @v1_dpcd
			
			SET @v_sec_bal  = ISNULL(@v_sec_bal, 0)+ ISNULL(@v_rec_amt, 0)
			SET @v_rec_amt  = 0 
													
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

			insert into #cir_temp_bill_collection(
				comp_code,unit_code,billno,billdt,publ_code,agcd,dpcd,
                supply_copy, gross_amt, comm_amt, sur_amt, return_copy, return_amt,ret_comm_amt, dn_amt, rec_amt, prev_bal,cn_amt,
                agname, agname_oth_lang, city_code, taluka_code, dist_code, state_code, remarks,bill_sec_amt,sec_opbal)
            values(@v1_comp_code,  @v1_unit_code  , null   ,null  , null ,@v1_agcd,@v1_dpcd,
            @v1_supply_copy,@v1_gross_amount,isnull(@v1_comm_amount,0),@v1_sur_amount,@v_ret_copy,@v_ret_gross,@v_ret_comm,
            @v_dn_amt,@v_rec_amt,@v_prev_bal,@v_cn_amt,
            @v1_ag_name,@v1_ag_name_oth_lang,@v_city_name,@v_taluka_name,@v_dist_name,@v_state_name,@v_drop_point_name,
            @v1_bill_sec_amt,@v_sec_bal);

			fetch NEXT FROM cur_bill INTO @v1_comp_code,@v1_unit_code, @v1_publ,@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_name_oth_lang, @v1_city_code, @v1_country_code, @v1_state_code	,@v1_dist_code, @v1_taluka_code, @v1_billno,@v1_billdt,@v1_supply_copy,
			@v1_gross_amount, @v1_sur_amount,@v1_comm_amount, @v1_bill_sec_amt,@v1_drop_point
			set @v_dsign	=0	set @v_ret_gross=0	set @v_ret_comm	=0 	set @v_ret_copy=0 
			set @v_dn_amt	=0	set @v_cn_amt	=0	set @v_rec_amt	=0  set @v_prev_bal=0 set @v_sec_bal	=0
            set @v_state_name=null set @v_dist_name=null set @v_taluka_name=null set @v_city_name=null
		END 
		Close cur_bill

        If @repty='S' Begin
            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,A.AGNAME AG_NAME,A.AGNAME_OTH_LANG AG_NAME_OTH_LANG,
            A.STATE_CODE STATE_NAME,
            SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)) BILL_AMT,SUM(A.COMM_AMT) COMM_AMT,SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))) NET_BILL,
            SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(RET_COMM_AMT,0)) RETURN_AMT,SUM(ISNULL(A.RETURN_AMT,0)) NET_RETURN_AMT,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(ISNULL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(ISNULL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE,A.REMARKS DROP_POINT
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.state_code,a.remarks
            order by comp_code,unit_code,state_name,ag_name;

            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.STATE_CODE STATE_NAME,
            SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)) BILL_AMT,SUM(A.COMM_AMT) COMM_AMT,SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))) NET_BILL,
            SUM(A.RETURN_COPY) RETURN_COPY,SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(RET_COMM_AMT,0)) RETURN_AMT,SUM(ISNULL(A.RETURN_AMT,0))  NET_RETURN_AMT,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(ISNULL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(ISNULL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.state_code
            order by comp_code,unit_code,state_name;
        End    
        If @repty='D' Begin

            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,A.AGNAME AG_NAME,A.AGNAME_OTH_LANG AG_NAME_OTH_LANG,
            A.STATE_CODE STATE_NAME,A.DIST_CODE DISTRICT_NAME,
            SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)) BILL_AMT,SUM(A.COMM_AMT) COMM_AMT,SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))) NET_BILL,
            SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(A.RET_COMM_AMT,0)) RETURN_AMT,SUM(A.RETURN_AMT) NET_RETURN_AMT,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(ISNULL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(ISNULL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE,A.REMARKS DROP_POINT
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.state_code,a.dist_code,a.remarks
            order by comp_code,unit_code,state_name,district_name,ag_name;

            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.DIST_CODE DISTRICT_NAME,
            A.STATE_CODE STATE_NAME,
            SUM(A.SUPPLY_COPY) SUPPLY_CODE,SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)) BILL_AMT,SUM(A.COMM_AMT) COMM_AMT,SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0)) NET_BILL,
            SUM(A.RETURN_COPY) RETURN_COPY,SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(A.RET_COMM_AMT,0)) RETURN_AMT,SUM(A.RETURN_AMT) NET_RETURN_AMT,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(ISNULL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(ISNULL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.state_code,a.dist_code
            order by comp_code,unit_code,state_name,district_name
		End
        If @repty='C' Begin

            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,A.AGNAME AG_NAME,A.AGNAME_OTH_LANG AG_NAME_OTH_LANG,
            A.STATE_CODE STATE_NAME,A.DIST_CODE DISTRICT_NAME,A.CITY_CODE CITY_NAME,
            SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)) BILL_AMT,SUM(A.COMM_AMT) COMM_AMT,SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))) NET_BILL,
            SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(RET_COMM_AMT,0)) RETURN_AMT,SUM(A.RETURN_AMT) NET_RETURN_AMT,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(ISNULL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(ISNULL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE,A.REMARKS DROP_POINT
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.state_code,a.dist_code,a.city_code,a.remarks
            order by comp_code,unit_code,state_name,district_name,city_name,ag_name;

            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.CITY_CODE CITY_NAME,
            A.DIST_CODE DISTRICT_NAME,A.STATE_CODE STATE_NAME,
            SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)) BILL_AMT,A.COMM_AMT COMM_AMT,(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0)) NET_BILL,
            SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(RET_COMM_AMT,0)) RETURN_AMT,SUM(A.RETURN_AMT) NET_RETURN_AMT,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(ISNULL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(ISNULL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.city_code,a.dist_code,a.state_code
            order by comp_code,unit_code,state_name,district_name,city_name;
		End            
        If @repty='T' Begin
            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,A.AGNAME AG_NAME,A.AGNAME_OTH_LANG AG_NAME_OTH_LANG,
            A.STATE_CODE STATE_NAME,A.DIST_CODE DISTRICT_NAME,
            A.TALUKA_CODE+'('+A.DIST_CODE+')' TALUKA_NAME,
            SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)) BILL_AMT,SUM(A.COMM_AMT) COMM_AMT,SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))) NET_BILL,
            SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(A.RET_COMM_AMT,0)) RETURN_AMT,SUM(A.RETURN_AMT) NET_RETURN_AMT,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(ISNULL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(ISNULL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE,A.REMARKS DROP_POINT
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.taluka_code,a.dist_code,a.remarks,a.state_code
            order by comp_code,unit_code,state_name,district_name,taluka_name,ag_name;

            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.STATE_CODE STATE_NAME,A.DIST_CODE DISTRICT_NAME,
            A.TALUKA_CODE+'('+A.DIST_CODE+')' TALUKA_NAME,
            SUM(ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)) BILL_AMT,SUM(A.COMM_AMT) COMM_AMT,SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))) NET_BILL,
            SUM(ISNULL(A.RETURN_AMT,0)+ISNULL(RET_COMM_AMT,0)) RETURN_AMT,SUM(A.RETURN_AMT) NET_RETURN_AMT,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(ISNULL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(ISNULL(A.DN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((ISNULL(A.GROSS_AMT,0)+ISNULL(A.SUR_AMT,0)-ISNULL(A.COMM_AMT,0))-ISNULL(A.RETURN_AMT,0)+ISNULL(A.BILL_SEC_AMT,0)+ISNULL(A.PREV_BAL,0)+ISNULL(A.REC_AMT,0)+ISNULL(A.DN_AMT,0)+ISNULL(A.CN_AMT,0)-ISNULL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(ISNULL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE
            from #cir_temp_bill_collection a
            group by a.comp_code,a.unit_code,a.taluka_code,a.dist_code,a.state_code
            order by comp_code,unit_code,state_name,district_name,taluka_name;
        End	

		
 DEALLOCATE cur_bill


//===========================================procedure for date bind in f2=====================================

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[cir_bill_fromdt_todt_cir_bill_fromdt_todt_p] 
	@pcomp_code                               VARCHAR(4000) ,
	@punit_code                               VARCHAR(4000) ,
	@pbill_flag                               VARCHAR(4000) ,
	@pdateformat                              VARCHAR(4000) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
	
		  


/*select distinct  DBO.convert_user_date('/', BILL_FRDT,@pdateformat) VBILL_FROMDT,
 DBO.convert_user_date('/', BILL_TODT,@pdateformat) BILL_TODT
			FROM  cir_bill 
			WHERE	 comp_code  = @pcomp_code
			 AND	unit_code  = @punit_code
			 AND	(bill_flag  = @pbill_flag or @pbill_flag is null or @pbill_flag='')
		ORDER BY VBILL_FROMDT, BILL_TODT DESC*/
		

 select distinct ''''+CONVERT(VARCHAR(10), bill_frdt, 103)+''''  VBILL_FROMDT,
 ''''+CONVERT(VARCHAR(10), bill_todt, 103)+'''' BILL_TODT 
			FROM  cir_bill 
			WHERE	 comp_code  = @pcomp_code
			 AND	unit_code  = @punit_code
			 AND	(bill_flag  = @pbill_flag or @pbill_flag is null or @pbill_flag='')
		ORDER BY VBILL_FROMDT, BILL_TODT DESC
	

--select * FROM  cir_bill 	

		




/////////////////////////////////////////////////////////////end of issue 5808,5809/////////////////////////////////////////////////////////