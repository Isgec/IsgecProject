ALTER TABLE CIR_RCPHDR ALTER COLUMN CCDP VARCHAR(14) NOT NULL

ALTER TABLE CIR_RCPHDR ALTER COLUMN RCDP VARCHAR(14) NOT NULL

ALTER TABLE CIR_RCPHDR_DIS ALTER COLUMN CCDP VARCHAR(14) NOT NULL

ALTER TABLE CIR_RCPHDR_DIS ALTER COLUMN RCDP VARCHAR(14) NOT NULL

////////////////////////////////add by Deepika 24/08/2012//////////////////////////////////////////////




ALTER PROCEDURE [dbo].[cir_agency_bind_cir_agency_listing_p]
@pcompcode

VARCHAR(20) ,
@punit

VARCHAR(20) ,
@pagty

VARCHAR(20) ,
@agcd

VARCHAR(20) ,
@dpcd

VARCHAR(20) ,
@pdateformat

VARCHAR(20) ,
@pextra1

varchar(200),----------agency class
@pextra2

varchar(200),---------- comm category
@pextra3

varchar(200),
@pextra4

varchar(200),
@pextra5

varchar(200),
@pextra6

varchar(200),
@pextra7

varchar(200),
@pextra8

varchar(200),
@pextra9

varchar(200),
@pextra10

varchar(200)
AS

--select * from cir_agmast a
select A.COMP_CODE,A.UNIT,A.BRANCH_CODE,C."Branch_Name" BRANCH_NAME, A.AGCD,A.DPCD,A.AG_NAME,A.AG_NAME_OTH_LANG,
A.AG_CLASS,(SELECT CLASS_DESC FROM CIR_AGENCY_CLASS_MAST WHERE CIR_AGENCY_CLASS_MAST.COMP_CODE=A.COMP_CODE AND CIR_AGENCY_CLASS_MAST.CLASS_CODE=A.AG_CLASS) AG_CLASS_NAME,
A.AG_TYPE,dbo.CIR_GET_AGENCY_TYPE(A.COMP_CODE,A.AG_TYPE) AG_TYPE_NAME, A.SUPPLY_START_DT,A.CITY_CODE,dbo.CIR_GET_CITY(A.COMP_CODE,A.CITY_CODE)CITY_NAME,

----CHANGE HERE
(A.ADDR1 + ',' + A.ADDR2+ ',' + A.ADDR3+ ',' + dbo.CIR_GET_CITY(A.COMP_CODE,A.CITY_CODE) + ',' + cast(A.PIN_CODE as varchar)) AS ALL_ADDRESS, 

A.DIST_CODE,DBO.CIR_GET_DIST(A.COMP_CODE,A.STATE_CODE,A.DIST_CODE) DIST_NAME,
A.STATE_CODE,DBO.CIR_GET_STATE(A.COMP_CODE,A.COUNTRY_CODE,A.STATE_CODE) STATE_NAME, A.TEHSIL_TALUKA TALUKA_CODE,DBO.CIR_GET_TALUKA(A.COMP_CODE,A.TEHSIL_TALUKA) TALUKA_NAME,
A.STATION_CODE,DBO.CIR_GET_DROP_POINT_NAME(A.COMP_CODE,A.UNIT,A.STATION_CODE,1) DROP_POINT_NAME,
A.AREA_CODE,DBO.CIR_GET_AREA(A.COMP_CODE,A.AREA_CODE) AREA_NAME, A.PHONE_NO1, A.PHONE_NO2, A.MOBILE_NO1, A.MOBILE_NO2,A.FAX_NO, A.EMAIL_ID, A.SUSPEND, A.SUSPEND_TYPE, A.SUSPEND_DATE,
A.TO_BILL, A.BILL_AGCD, A.BILL_DPCD,DBO.CIR_GET_AGENCY(A.COMP_CODE,A.UNIT,A.BILL_AGCD,A.BILL_DPCD) BILL_AGENCY, A.PAYMODE, A.CREDIT_DAYS, A.PRINT_LABEL, A.PIN_PACKET,
A.PIN_AGCD, A.PIN_DPCD,DBO.CIR_GET_AGENCY(A.COMP_CODE,A.UNIT,A.PIN_AGCD,A.PIN_DPCD) PIN_AGENCY, A.PIN_OPEN_INSIDE,
A.NAME_ON_LABEL, A.PRINT_SEQ,CASE WHEN A.UNSOLD_VALID_FLAG='D' THEN 'Daily' WHEN A.UNSOLD_VALID_FLAG='W' THEN 'Weekly' ELSE 'Monthly' END BILL_CYCLE,
A.SECURITY_PER, A.SEC_AMT_LIMT, A.SUPPLY_STOP_FLAG, A.SUPPLY_STOP_PER, A.ABC_CITYCODE,DBO.CIR_GET_CITY(A.COMP_CODE,A.ABC_CITYCODE) ABC_CITY_NAME,
B.NAME CON_PER_NAME,B.DESIG CON_PER_DESIG,B.PER_ROLE CON_PER_PER_ROLE,B.DATE_OF_BIRTH DATE_OF_BIRTH, B.PHONE_NO1 CON_PER_PHONE_NO1, B.PHONE_NO2 CON_PER_PHONE_NO2,
B.MOBILE_NO1 CON_PER_MOBILE_NO1, B.MOBILE_NO2 CON_PER_MOBILE_NO2, B.FAX_NO CON_PER_FAX_NO, B.EMAIL_ID CON_PER_EMAIL_ID

------new add

,(A.H_ADDR1 + ',' + A.H_ADDR2+ ',' + A.H_ADDR3+ ',' + dbo.CIR_GET_CITY(A.COMP_CODE,A.H_CITY_CODE)) AS H_ALL_ADDRESS 
---new add

FROM cir_agmast a LEFT OUTER JOIN cir_ag_con_per b ON a.comp_code = b.comp_code
AND a.unit = b.unit
AND a.agcd = b.agcd
AND a.dpcd = b.dpcd ,
--LEFT OUTER JOIN cir_supply d ON a.comp_code = d.comp_code
--AND a.unit = d.unit
--AND a.agcd = d.agcd
--AND a.dpcd = d.dpcd ,
branch_mst c

WHERE a.comp_code = @pcompcode
AND (a.unit = @punit OR @punit is null OR @punit ='')
AND (a.AGCD =@agcd OR @agcd IS NULL OR @agcd='')
AND (a.DPCD=@dpcd or @dpcd is null or @dpcd='')
AND a.branch_code = c.Branch_Code
AND (ag_type = @pagty OR @pagty is null OR @pagty ='')
AND (ag_class = @pextra1 OR @pextra1 is null OR @pextra1 ='')
--AND (d.comm_code = @pextra2 OR @pextra2 is null OR @pextra2 ='')
order by a.comp_code,a.unit,a.ag_name, b.name



////////////////////////////////////////////////end///////////////////////////////////////////////////
//////////////////////////
ALTER procedure [dbo].[cir_dummy_billdetail]
(
@pcomp_code   varchar(8),
@punit_code   varchar(8),
@pagcd        varchar(20),
@pdpcd        varchar(20),
@ppubl        varchar(20),
@pag_type     varchar(20),
@psupdate     varchar(20),
@pextra1      varchar(20),
@pextra2      varchar(20)
)
as
begin
create table #result_new(SegmentNum INT, Edition_Name  VARCHAR(255))
insert into #result_new select * from dbo.Fn_Splitfield_NEW(@ppubl,',')

select d.comp_code,d.unit_code,d.agcd,d.dpcd,sap_id,d.supdate supdate
,sum(sup_copy) sup_copy,sum(sup_rate) sup_rate,comm_code,
a.ag_name AGENCY_NAME,
d.publ,
dbo.cir_get_publ_name(d.comp_code,d.publ) PUB_NAME 
,a.addr1 addr1
,a.addr2 addr2
,a.addr3 addr3
,a.city_code city_code
,a.dist_code dist_code
,a.tehsil_taluka tehsil_taluka
,a.state_code state_code
,a.country_code country_code
,dbo.cir_get_country(a.comp_code,a.country_code) country_name
,dbo.cir_get_state(a.comp_code,a.country_code,a.state_code) state_name
,dbo.cir_get_city(a.comp_code,a.city_code) city_name
,dbo.cir_get_dist(a.comp_code,a.state_code,a.dist_code ) dist_name
,dbo.cir_get_taluka(a.comp_code,a.tehsil_taluka) taluka_name
,(SELECT top 1 RAND() magic_number FROM information_schema.tables) bill_no
,getdate()  bill_date
,'English' lang
,case CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @psupdate),20)
when 'Sunday' then  (select max(sun_comm_rate)
					from cir_comm_mast  where comp_code = @pcomp_code and  unit_code = @punit_code and  publ =  d.publ and
					edtn = d.edtn and comm_type =  d.comm_fix_auto_spl and  comm_catg_code =  d.comm_code and  
					valid_from = (select max(valid_from) from cir_comm_mast where comp_code = @pcomp_code and unit_code = @punit_code and
					publ = d.publ and  edtn = d.edtn and comm_type = d.comm_fix_auto_spl and comm_catg_code = d.comm_code and 
					valid_from <= @psupdate)	) 
when 'Monday' then ( select max(mon_comm_rate)
					from cir_comm_mast  where comp_code = @pcomp_code and  unit_code = @punit_code and  publ =  d.publ and
					edtn = d.edtn and comm_type =  d.comm_fix_auto_spl and  comm_catg_code =  d.comm_code and  
					valid_from = (select max(valid_from) from cir_comm_mast where comp_code = @pcomp_code and unit_code = @punit_code and
					publ = d.publ and  edtn = d.edtn and comm_type = d.comm_fix_auto_spl and comm_catg_code =  d.comm_code and 
					valid_from <= @psupdate))	
when 'Tuesday' then (select max(tue_comm_rate)
					from cir_comm_mast  where comp_code = @pcomp_code and  unit_code = @punit_code and  publ =  d.publ and
					edtn = d.edtn and comm_type =  d.comm_fix_auto_spl and  comm_catg_code =  d.comm_code and  
					valid_from = (select max(valid_from) from cir_comm_mast where comp_code = @pcomp_code and unit_code = @punit_code and
					publ = d.publ and  edtn = d.edtn and comm_type = d.comm_fix_auto_spl and comm_catg_code =  d.comm_code and 
					valid_from <= @psupdate)	)
when 'Wednesday' then (select max(wed_comm_rate)
					from cir_comm_mast  where comp_code = @pcomp_code and  unit_code = @punit_code and  publ =  d.publ and
					edtn = d.edtn and comm_type =  d.comm_fix_auto_spl and  comm_catg_code =  d.comm_code and  
					valid_from = (select max(valid_from) from cir_comm_mast where comp_code = @pcomp_code and unit_code = @punit_code and
					publ = d.publ and  edtn = d.edtn and comm_type = d.comm_fix_auto_spl and comm_catg_code =  d.comm_code and 
					valid_from <= @psupdate))	 
when 'Thursday' then  (select max(thu_comm_rate)
					from cir_comm_mast  where comp_code = @pcomp_code and  unit_code = @punit_code and  publ =  d.publ and
					edtn = d.edtn and comm_type =  d.comm_fix_auto_spl and  comm_catg_code =  d.comm_code and  
					valid_from = (select max(valid_from) from cir_comm_mast where comp_code = @pcomp_code and unit_code = @punit_code and
					publ = d.publ and  edtn = d.edtn and comm_type = d.comm_fix_auto_spl and comm_catg_code =  d.comm_code and 
					valid_from <= @psupdate))	 
when 'Friday' then  (select max(fri_comm_rate)
					from cir_comm_mast  where comp_code = @pcomp_code and  unit_code = @punit_code and  publ =  d.publ and
					edtn = d.edtn and comm_type =  d.comm_fix_auto_spl and  comm_catg_code =  d.comm_code and  
					valid_from = (select max(valid_from) from cir_comm_mast where comp_code = @pcomp_code and unit_code = @punit_code and
					publ = d.publ and  edtn = d.edtn and comm_type = d.comm_fix_auto_spl and comm_catg_code =  d.comm_code and 
					valid_from <= @psupdate))	
when 'Saturday' then (select max(sat_comm_rate)
					from cir_comm_mast  where comp_code = @pcomp_code and  unit_code = @punit_code and  publ =  d.publ and
					edtn = d.edtn and comm_type =  d.comm_fix_auto_spl and  comm_catg_code =  d.comm_code and  
					valid_from = (select max(valid_from) from cir_comm_mast where comp_code = @pcomp_code and unit_code = @punit_code and
					publ = d.publ and  edtn = d.edtn and comm_type = d.comm_fix_auto_spl and comm_catg_code =  d.comm_code and 
					valid_from <= @psupdate))	
else   0  end as disc_per
,sum((isnull(SUP_COPY,0)*isnull(SUP_RATE,0))) gross_amt
--,sum((gross_amt*disc_per/100)) disc_amt
,(sum((isnull(SUP_COPY,0)*isnull(SUP_RATE,0)))*
(case CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @psupdate),20)
when 'Sunday' then  (select max(sun_comm_rate)
					from cir_comm_mast  where comp_code = @pcomp_code and  unit_code = @punit_code and  publ =  d.publ and
					edtn = d.edtn and comm_type =  d.comm_fix_auto_spl and  comm_catg_code =  d.comm_code and  
					valid_from = (select max(valid_from) from cir_comm_mast where comp_code = @pcomp_code and unit_code = @punit_code and
					publ = d.publ and  edtn = d.edtn and comm_type = d.comm_fix_auto_spl and comm_catg_code = d.comm_code and 
					valid_from <= @psupdate)	) 
when 'Monday' then ( select max(mon_comm_rate)
					from cir_comm_mast  where comp_code = @pcomp_code and  unit_code = @punit_code and  publ =  d.publ and
					edtn = d.edtn and comm_type =  d.comm_fix_auto_spl and  comm_catg_code =  d.comm_code and  
					valid_from = (select max(valid_from) from cir_comm_mast where comp_code = @pcomp_code and unit_code = @punit_code and
					publ = d.publ and  edtn = d.edtn and comm_type = d.comm_fix_auto_spl and comm_catg_code =  d.comm_code and 
					valid_from <= @psupdate))	
when 'Tuesday' then (select max(tue_comm_rate)
					from cir_comm_mast  where comp_code = @pcomp_code and  unit_code = @punit_code and  publ =  d.publ and
					edtn = d.edtn and comm_type =  d.comm_fix_auto_spl and  comm_catg_code =  d.comm_code and  
					valid_from = (select max(valid_from) from cir_comm_mast where comp_code = @pcomp_code and unit_code = @punit_code and
					publ = d.publ and  edtn = d.edtn and comm_type = d.comm_fix_auto_spl and comm_catg_code =  d.comm_code and 
					valid_from <= @psupdate)	)
when 'Wednesday' then (select max(wed_comm_rate)
					from cir_comm_mast  where comp_code = @pcomp_code and  unit_code = @punit_code and  publ =  d.publ and
					edtn = d.edtn and comm_type =  d.comm_fix_auto_spl and  comm_catg_code =  d.comm_code and  
					valid_from = (select max(valid_from) from cir_comm_mast where comp_code = @pcomp_code and unit_code = @punit_code and
					publ = d.publ and  edtn = d.edtn and comm_type = d.comm_fix_auto_spl and comm_catg_code =  d.comm_code and 
					valid_from <= @psupdate))	 
when 'Thursday' then  (select max(thu_comm_rate)
					from cir_comm_mast  where comp_code = @pcomp_code and  unit_code = @punit_code and  publ =  d.publ and
					edtn = d.edtn and comm_type =  d.comm_fix_auto_spl and  comm_catg_code =  d.comm_code and  
					valid_from = (select max(valid_from) from cir_comm_mast where comp_code = @pcomp_code and unit_code = @punit_code and
					publ = d.publ and  edtn = d.edtn and comm_type = d.comm_fix_auto_spl and comm_catg_code =  d.comm_code and 
					valid_from <= @psupdate))	 
when 'Friday' then  (select max(fri_comm_rate)
					from cir_comm_mast  where comp_code = @pcomp_code and  unit_code = @punit_code and  publ =  d.publ and
					edtn = d.edtn and comm_type =  d.comm_fix_auto_spl and  comm_catg_code =  d.comm_code and  
					valid_from = (select max(valid_from) from cir_comm_mast where comp_code = @pcomp_code and unit_code = @punit_code and
					publ = d.publ and  edtn = d.edtn and comm_type = d.comm_fix_auto_spl and comm_catg_code =  d.comm_code and 
					valid_from <= @psupdate))	
when 'Saturday' then (select max(sat_comm_rate)
					from cir_comm_mast  where comp_code = @pcomp_code and  unit_code = @punit_code and  publ =  d.publ and
					edtn = d.edtn and comm_type =  d.comm_fix_auto_spl and  comm_catg_code =  d.comm_code and  
					valid_from = (select max(valid_from) from cir_comm_mast where comp_code = @pcomp_code and unit_code = @punit_code and
					publ = d.publ and  edtn = d.edtn and comm_type = d.comm_fix_auto_spl and comm_catg_code =  d.comm_code and 
					valid_from <= @psupdate))	
else   0  end)/100 ) as  disc_amt
,sum((isnull(SUP_COPY,0)*isnull(SUP_RATE,0)))-
(sum((isnull(SUP_COPY,0)*isnull(SUP_RATE,0)))*
(case CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @psupdate),20)
when 'Sunday' then  (select max(sun_comm_rate)
					from cir_comm_mast  where comp_code = @pcomp_code and  unit_code = @punit_code and  publ =  d.publ and
					edtn = d.edtn and comm_type =  d.comm_fix_auto_spl and  comm_catg_code =  d.comm_code and  
					valid_from = (select max(valid_from) from cir_comm_mast where comp_code = @pcomp_code and unit_code = @punit_code and
					publ = d.publ and  edtn = d.edtn and comm_type = d.comm_fix_auto_spl and comm_catg_code = d.comm_code and 
					valid_from <= @psupdate)	) 
when 'Monday' then ( select max(mon_comm_rate)
					from cir_comm_mast  where comp_code = @pcomp_code and  unit_code = @punit_code and  publ =  d.publ and
					edtn = d.edtn and comm_type =  d.comm_fix_auto_spl and  comm_catg_code =  d.comm_code and  
					valid_from = (select max(valid_from) from cir_comm_mast where comp_code = @pcomp_code and unit_code = @punit_code and
					publ = d.publ and  edtn = d.edtn and comm_type = d.comm_fix_auto_spl and comm_catg_code =  d.comm_code and 
					valid_from <= @psupdate))	
when 'Tuesday' then (select max(tue_comm_rate)
					from cir_comm_mast  where comp_code = @pcomp_code and  unit_code = @punit_code and  publ =  d.publ and
					edtn = d.edtn and comm_type =  d.comm_fix_auto_spl and  comm_catg_code =  d.comm_code and  
					valid_from = (select max(valid_from) from cir_comm_mast where comp_code = @pcomp_code and unit_code = @punit_code and
					publ = d.publ and  edtn = d.edtn and comm_type = d.comm_fix_auto_spl and comm_catg_code =  d.comm_code and 
					valid_from <= @psupdate)	)
when 'Wednesday' then (select max(wed_comm_rate)
					from cir_comm_mast  where comp_code = @pcomp_code and  unit_code = @punit_code and  publ =  d.publ and
					edtn = d.edtn and comm_type =  d.comm_fix_auto_spl and  comm_catg_code =  d.comm_code and  
					valid_from = (select max(valid_from) from cir_comm_mast where comp_code = @pcomp_code and unit_code = @punit_code and
					publ = d.publ and  edtn = d.edtn and comm_type = d.comm_fix_auto_spl and comm_catg_code =  d.comm_code and 
					valid_from <= @psupdate))	 
when 'Thursday' then  (select max(thu_comm_rate)
					from cir_comm_mast  where comp_code = @pcomp_code and  unit_code = @punit_code and  publ =  d.publ and
					edtn = d.edtn and comm_type =  d.comm_fix_auto_spl and  comm_catg_code =  d.comm_code and  
					valid_from = (select max(valid_from) from cir_comm_mast where comp_code = @pcomp_code and unit_code = @punit_code and
					publ = d.publ and  edtn = d.edtn and comm_type = d.comm_fix_auto_spl and comm_catg_code =  d.comm_code and 
					valid_from <= @psupdate))	 
when 'Friday' then  (select max(fri_comm_rate)
					from cir_comm_mast  where comp_code = @pcomp_code and  unit_code = @punit_code and  publ =  d.publ and
					edtn = d.edtn and comm_type =  d.comm_fix_auto_spl and  comm_catg_code =  d.comm_code and  
					valid_from = (select max(valid_from) from cir_comm_mast where comp_code = @pcomp_code and unit_code = @punit_code and
					publ = d.publ and  edtn = d.edtn and comm_type = d.comm_fix_auto_spl and comm_catg_code =  d.comm_code and 
					valid_from <= @psupdate))	
when 'Saturday' then (select max(sat_comm_rate)
					from cir_comm_mast  where comp_code = @pcomp_code and  unit_code = @punit_code and  publ =  d.publ and
					edtn = d.edtn and comm_type =  d.comm_fix_auto_spl and  comm_catg_code =  d.comm_code and  
					valid_from = (select max(valid_from) from cir_comm_mast where comp_code = @pcomp_code and unit_code = @punit_code and
					publ = d.publ and  edtn = d.edtn and comm_type = d.comm_fix_auto_spl and comm_catg_code =  d.comm_code and 
					valid_from <= @psupdate))	
else   0  end)/100 ) as bill_amt
 from cir_dbksup d,cir_agmast a
where d.comp_code=@pcomp_code
and d.unit_code=@punit_code
and a.comp_code=d.comp_code
and a.unit=d.unit_code
and a.agcd=d.agcd
and a.dpcd=d.dpcd
and (d.agcd=@pagcd or @pagcd is null or @pagcd='')
and (d.dpcd=@pdpcd or @pdpcd is null or @pdpcd='')
and (d.agency_ty_code=@pag_type or @pag_type is null or @pag_type='')
and d.supdate =@psupdate 
and ( d.publ in(select EDITION_NAME from #result_new ) or @ppubl is null or @ppubl='') 
 group by d.COMP_CODE,d.unit_code,d.agcd,d.dpcd,sap_id,d.supdate,d.comm_code,ag_name,d.publ
 ,addr1,addr2,addr3,city_code,dist_code,TEHSIL_TALUKA,state_code,COUNTRY_CODE,a.comp_code
,d.COMM_FIX_AUTO_SPL,d.edtn
select * from comp_mst where comp_code=@pcomp_code

end


///////////////////////////////////////////add by Deepika 24/08/2012/////////////////////////////////////////

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE [dbo].[CIR_SUPPLY_POST_FOR_NEXT_DAY_cir_check_supply_posting_p]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl_code                               VARCHAR(20) ,
	@pedtn_code                               VARCHAR(20) ,
	@pagcd                                    VARCHAR(20) ,
	@pdpcd                                    VARCHAR(20) ,
	@psup_date                                DATETIME,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(40) ,
	@pextra2                                  VARCHAR(40) 
  
AS 
    declare @v_many_time_posting	varchar(1)
    declare @v_backdays_posting		numeric(10)
    declare @v_days					numeric(10)
    declare @v_bill_exist			numeric(10)
    declare @v_sup_copy				numeric(1)
  Begin	

    set @v_days=(DATEDIFF(day,@psup_date,GETDATE()))+1
    print('@v_days')
	print(@v_days)	

    select @v_bill_exist=count(*) from cir_bill_det d,cir_publ_mast p,cir_edtn_mast e
        where d.comp_code = p.comp_code and d.comp_code = e.comp_code and d.comp_code=@pcomp_code and d.unit_code=@punit_code and
        @psup_date between fromdt and todt and d.publ=p.publ and d.publ = @ppubl_code and d.edtn=e.edtn and e.main_edtn = isnull(@pedtn_code,e.main_edtn)
        	
    print('@v_bill_exist')
	print(@v_bill_exist)	
	
    select @v_many_time_posting=cir_many_time_posting,@v_backdays_posting=cir_backdays_posting from preferrences 
        where "comp_code"=@pcomp_code
    
    print('@v_many_time_posting')
    print(@v_many_time_posting)
    print('@v_backdays_posting')
    print(@v_backdays_posting)
    
	If @v_bill_exist=0 Begin
		if @psup_date-1>(GETDATE()) Begin
			print('1')
			if isnull(@v_many_time_posting,'N')='N' Begin
				print('2')
				select @v_sup_copy=isnull(sum(a.sup_copy),0) --as "SUP_COPY"
					from cir_dbksup a,cir_edtn_mast e
						where a.comp_code=@pcomp_code and a.comp_code=e.comp_code and a.unit_code=@punit_code and 
							a.publ=@ppubl_code and a.publ = e.publ and a.edtn= e.edtn and 
							a.supdate=@psup_date and a.agcd=isnull(@pagcd,a.agcd) and a.dpcd=isnull(@pdpcd,a.dpcd) and
							e.main_edtn = isnull(@pedtn_code,e.main_edtn)
			End
			Else Begin
				print('3')
				set @v_sup_copy=0
			End
		End    
		else Begin
			print('4')
			if isnull(@v_many_time_posting,'N')='N' Begin
				select @v_sup_copy=isnull(sum(a.sup_copy),0) --as "SUP_COPY"
					from cir_dbksup a,cir_edtn_mast e
						where a.comp_code=@pcomp_code and a.comp_code=e.comp_code and a.unit_code=@punit_code and 
							a.publ=@ppubl_code and a.publ = e.publ and a.edtn= e.edtn and 
							a.supdate=@psup_date and a.agcd=isnull(@pagcd,a.agcd) and a.dpcd=isnull(@pdpcd,a.dpcd) and
							e.main_edtn = isnull(@pedtn_code,e.main_edtn)
			End
			Else Begin
				if isnull(@v_backdays_posting,0)>0 Begin
					print('5')
					if @v_days<=@v_backdays_posting Begin
						print('6')
						set @v_sup_copy=0
					End
					else Begin
						print('7')
						set @v_sup_copy=1
					End
				End    
				else Begin
					print('8')
					set @v_sup_copy=0
				End
			End	
		End
	End	
	Else Begin
		set @v_sup_copy=1
	End
	select @v_sup_copy as "SUP_COPY"
 End


/////////////////////////////////////////////////////////////

                                                                     
                                                                     
                                                                     
                                             
ALTER function [dbo].[cir_get_unsold_permissable_dates]
(
  @pcompcode         as varchar(20),      
  @ppublcode         as varchar(20),      
  @puserid           as varchar(20),
  @pagcd             as varchar(20),
  @pdpcd             as varchar(20),
  @pflag             as varchar(1),
  @pchkdate          as datetime,
  @preceivedt        as datetime,
  @pextra1           as varchar(20),
  @pextra2           as varchar(20)
) returns datetime
as
Begin
	-------
	declare @v_bill_freq as varchar(1)
	declare @v_unit      as varchar(20)
	declare @v_branch   as varchar(20)
	declare @v_region    as varchar(20)
	declare @v_zone      as varchar(20)
	declare @v_agtype    as varchar(20)
	declare @v_agclass   as varchar(20)
	declare @v_citycode  as varchar(20)
	declare @v_cnt       as int
	declare @v_output    as int
	declare @v_value     as varchar(500)
	
	select distinct @v_bill_freq=billing_cycle from CIR_SUPPLY where comp_code= @pcompcode 
	and agcd=@pagcd and dpcd=@pdpcd and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
	and (EDTN=@pextra1 or @pextra1 is null or @pextra1 ='')

	select @v_unit=unit,@v_branch=branch_code,@v_citycode=city_code,@v_agtype=ag_type,@v_agclass=ag_class from cir_agmast
	where comp_code=@pcompcode and agcd=@pagcd and dpcd=@pdpcd
	
	select distinct @v_zone=zone_code,@v_region=region_code from cir_city_mast c where c.city_code=@v_citycode
	
	if @v_unit = '' begin
		set @v_unit=null
	end
	if @v_branch ='' begin
		set @v_branch=null
	end
	if @v_region ='' begin
		set @v_region=null
	end
	if @v_zone='' begin
		set @v_zone=null
	end
	if @v_agtype='' begin
		set @v_agtype=null
	end
	if @v_agclass ='' begin
		set @v_agclass=null
	end
	
	select @v_cnt= count(*) from CIR_UNSOLD_RETURN_CONTROL where comp_code=@pcompcode	
	and (publ_code=@ppublcode or publ_code is null or publ_code ='')
	and bill_freq=@v_bill_freq 
	--and (unit_code=@v_unit or unit_code is null or unit_code ='') 
	and (branch_code=@v_branch or branch_code is null or branch_code ='')
	and (reg_code=@v_region or reg_code is null or reg_code ='') 
	and (zone_code=@v_zone or zone_code is null or zone_code ='') 
	and (ag_type=@v_agtype or ag_type is null or ag_type ='') 
	and (ag_class=@v_agclass or ag_class is null or ag_class ='')

	
	select @v_output= isnull(no_of_days,0) from CIR_UNSOLD_RETURN_CONTROL p
	where comp_code=@pcompcode	
	and (publ_code=@ppublcode or publ_code is null or publ_code ='')
	and bill_freq=@v_bill_freq 
	and (unit_code=@v_unit or unit_code is null or unit_code ='') 
	and (branch_code=@v_branch or branch_code is null or branch_code ='')
	and (reg_code=@v_region or reg_code is null or reg_code ='') 
	and (zone_code=@v_zone or zone_code is null or zone_code ='') 
	and (ag_type=@v_agtype or ag_type is null or ag_type ='') 
	and (ag_class=@v_agclass or ag_class is null or ag_class ='')
	
	if @v_cnt =0 begin
		set @v_output= 0
	end	
	
	set @preceivedt = cast(getdate() as date)
	set @pchkdate   = dateadd(dd, -1*@v_output,@preceivedt)

	declare @diff_days as int
	set @diff_days=datediff(dd,@preceivedt,@pchkdate)
	
		

--- for checking the holidays from holiday master
declare @v_holidays as int
			select @v_holidays=count(*) from cir_holiday_mast where comp_code=@pcompcode 
			and (unit=@v_unit or @v_unit is null or @v_unit ='') 
			and (h_publ=@ppublcode or @ppublcode is null or @ppublcode ='')
			and isnull(freeze_flag,'N') ='N'
			and h_date between @preceivedt and  @pchkdate
if @v_holidays is not null or @v_holidays !=0
begin
	set @v_output=isnull(@v_output,0) + isnull(@v_holidays,0)
end

-- for checking by issue date
declare @v_d_cnt as int
declare @v_dt1 as datetime
declare @v_dt2 as datetime
declare @v_first_iss as varchar(3)
declare @v_second_iss as varchar(3)
declare @v_freq_pub as int
select @v_first_iss=first_issue,@v_second_iss=second_issue,@v_freq_pub=frequency_code from Cir_Edition_Issue_Date 
where comp_code=@pcompcode 
and (pub_code=@ppublcode or @ppublcode is null or @ppublcode ='')
and (edition_code=@pextra1 or @pextra1 is null or @pextra1='')

set @v_d_cnt =0

if @v_bill_freq != 'D'
begin
	if @v_freq_pub ='7'
	begin
		/*
		SELECT dbo.f_countweekdays(1, '2012-07-01', '2012-07-31'),dbo.f_countweekdays(2, '2012-07-01', '2012-07-31')
		  ,dbo.f_countweekdays(3, '2012-07-01', '2012-07-31'),dbo.f_countweekdays(4, '2012-07-01', '2012-07-31')
		  ,dbo.f_countweekdays(5, '2012-07-01', '2012-07-31'),dbo.f_countweekdays(6, '2012-07-01', '2012-07-31')
		  ,dbo.f_countweekdays(7, '2012-07-01', '2012-07-31')
		  */
			if @v_first_iss = 'SUN'
			begin
				set @v_d_cnt=dbo.f_countweekdays(1, @pchkdate, @preceivedt)
			end
			else
			if @v_first_iss = 'MON'
			begin
				set @v_d_cnt=dbo.f_countweekdays(2, @pchkdate, @preceivedt)
			end
			else
			if @v_first_iss = 'TUE'
			begin
				set @v_d_cnt=dbo.f_countweekdays(3, @pchkdate, @preceivedt)
			end
			else
			if @v_first_iss = 'WED'
			begin
				set @v_d_cnt=dbo.f_countweekdays(4, @pchkdate, @preceivedt)
			end
			else
			if @v_first_iss = 'THU'
			begin
				set @v_d_cnt=dbo.f_countweekdays(5, @pchkdate, @preceivedt)
			end
			else
			if @v_first_iss = 'FRI'
			begin
				set @v_d_cnt=dbo.f_countweekdays(6, @pchkdate, @preceivedt)
			end
			else
			if @v_first_iss = 'SAT'
			begin
				set @v_d_cnt=dbo.f_countweekdays(7, @pchkdate, @preceivedt)
			end
	end
	else if @v_freq_pub='15'
	begin
		if cast(@v_first_iss as int) >= DATEPART ( dd , @preceivedt ) and cast(@v_first_iss as int) <= DATEPART ( dd , @pchkdate )
		begin
			set @v_d_cnt=@v_d_cnt+1
		end
		if cast(@v_second_iss as int) >= DATEPART ( dd , @preceivedt ) and cast(@v_second_iss as int) <= DATEPART ( dd , @pchkdate )
		begin
			set @v_d_cnt=@v_d_cnt+1
		end
		
	end
	else if @v_freq_pub='30'
	begin
		if cast(@v_first_iss as int) >= DATEPART ( dd , @preceivedt ) and cast(@v_first_iss as int) <= DATEPART ( dd , @pchkdate )
		begin
			set @v_d_cnt=@v_d_cnt+1
		end
	end
	else
	begin
		set @v_first_iss='1'
	end
	set @v_output=isnull(@v_output,0) + isnull(@v_d_cnt,0)
end
else
begin 
	-- for checking in preferrences 
declare @v_holiday_sun as varchar(1)
declare @v_holiday_mon as varchar(1)
declare @v_holiday_tue as varchar(1)
declare @v_holiday_wed as varchar(1)
declare @v_holiday_thu as varchar(1)
declare @v_holiday_fri as varchar(1)
declare @v_holiday_sat as varchar(1)
			select @v_holiday_sun=isnull(cir_allow_holiday_sun,'N'),
			@v_holiday_mon=isnull(CIR_ALLOW_HOLIDAY_MON,'N'),
			@v_holiday_tue=isnull(CIR_ALLOW_HOLIDAY_TUE,'N'),
			@v_holiday_wed=isnull(CIR_ALLOW_HOLIDAY_WED,'N'),
			@v_holiday_thu=isnull(CIR_ALLOW_HOLIDAY_THU,'N'),
			@v_holiday_fri=isnull(CIR_ALLOW_HOLIDAY_FRI,'N'),
			@v_holiday_fri=isnull(CIR_ALLOW_HOLIDAY_SAT,'N')
			from preferrences where comp_code=@pcompcode 

		if	@v_holiday_sun ='Y'
		begin
			set @v_d_cnt=@v_d_cnt+dbo.f_countweekdays(1, @pchkdate, @preceivedt)
		end
		if	@v_holiday_mon ='Y'
		begin
				set @v_d_cnt=@v_d_cnt+dbo.f_countweekdays(2, @pchkdate, @preceivedt)
		end
		if	@v_holiday_tue ='Y'
		begin
				set @v_d_cnt=@v_d_cnt+dbo.f_countweekdays(3, @pchkdate, @preceivedt)
		end
		if	@v_holiday_wed ='Y'
		begin
				set @v_d_cnt=@v_d_cnt+dbo.f_countweekdays(4, @pchkdate, @preceivedt)
		end
		if	@v_holiday_thu ='Y'
		begin
				set @v_d_cnt=@v_d_cnt+dbo.f_countweekdays(5, @pchkdate, @preceivedt)
		end
		if	@v_holiday_fri ='Y'
		begin
				set @v_d_cnt=@v_d_cnt+dbo.f_countweekdays(6, @pchkdate, @preceivedt)
		end
		if	@v_holiday_sat ='Y'
		begin
				set @v_d_cnt=@v_d_cnt+dbo.f_countweekdays(7, @pchkdate, @preceivedt)
		end
		
		set @v_output=isnull(@v_output,0) + isnull(@v_d_cnt,0)
end


	if @pflag = 'D'
	begin
		--@v_output -- contains permissable days allowed
		if @diff_days > @v_output
		begin
			set @v_value='You are not authorized to receive unsold more than '+ cast (@v_output as varchar) + ' days.'
		end
		else
		begin
			set @v_value='OK'		
		end
	end	
	else
	begin
		set @v_value='OK'
		
	end
-------	 

set @pchkdate=dateadd(dd,-1*@v_output,@preceivedt)
	return isnull(@pchkdate,@preceivedt)

End 
	

////////////////////////////////////////////////////////////////////////////////////////////

                                                                     
                                                                     
                                                                     
                                             
ALTER procedure [dbo].[CIR_RECEIPT_DATA_MOVE]
    @pcompcode       as varchar(200),
    @punitcode       as varchar(200),
    @pdoctype        as varchar(200),
    @precptdt        as varchar(200),
    @precptno        as varchar(200),
    @pdateformate    as varchar(200),
    @puserid         as varchar(200),
    @prectype        as varchar(200),--it is for agency receipt or distraibution receipt
    @pextra1         as varchar(200),
    @pextra2         as varchar(200),
    @pextra3         as varchar(200),
    @pextra4         as varchar(200),
    @pextra5         as varchar(200)
as
declare @v_recno numeric(10)
declare @v_dt    datetime
begin
    set @v_dt=dbo.convert_user_date('/', @precptdt,@pdateformate)
    
    if upper(@prectype)='D' Begin
        insert into cir_rcphdr_dis(comp_code,unit_code,doctype,agcd,dpcd,recptno,
            recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,
            remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,
              staxamt,status,ref_recptno,ref_recptdt,ref_amount,ref_doctype,cancel_user,cancel_datetime,
              cancel_remark,userid,creation_datetime,branch_code,prov_rec_no,prov_rec_dt,remark_oth,MANNUALRECPTNO)
          select comp_code,unit_code,doctype,agcd,dpcd,recptno,
          recptdt,chno,
          CASE chdt WHEN '1900-01-01 00:00:00.000' THEN NULL else chdt END chdt,
          chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,
          remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,
          staxamt,status,ref_recptno,
          CASE ref_recptdt WHEN '1900-01-01 00:00:00.000' THEN NULL else ref_recptdt END ref_recptdt,
          ref_amount,ref_doctype,cancel_user,cancel_date,
          cancel_remark,userid,creation_date,branch_code,prov_rec_no,
          CASE prov_rec_dt WHEN '1900-01-01 00:00:00.000' THEN NULL else prov_rec_dt END prov_rec_dt,
          remark_oth,MANNUALRECPTNO from cir_rcphdr_dis_temp
            where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
      
      delete from CIR_RCPHDR_DIS_TEMP where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
      
          insert into cir_rcpdet_dis(comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                            payfor, achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, 
                            tds, stax, status, usrid, creation_datetime, branch_code)
          select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                            payfor, achd, publ, chno, chbnk, 
                            CASE chdt WHEN '1900-01-01 00:00:00.000' THEN NULL else chdt END chdt, 
                            amount, reason, remark, voucherno, voucherdt, 
                            tds, stax, status, usrid, creation_date, branch_code from cir_rcpdet_dis_temp
            where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt

		delete from cir_rcpdet_dis_temp
            where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt

        insert into cir_outmast_dis (comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                        achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, balance, 
                        tds, stax, status, cancel_userid, cancel_dt, cancel_remark, usrid, creation_datetime, bill_sec_amt, branch_code)
        select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                        achd, publ, chno, chbnk, 
                        CASE chdt WHEN '1900-01-01 00:00:00.000' THEN NULL else chdt END chdt, 
                        amount, reason, remark, voucherno, voucherdt, balance, 
                        tds, stax, status, cancel_userid, cancel_dt, cancel_remark, usrid, creation_date, bill_sec_amt, branch_code from cir_outmast_dis_temp
             where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
		
		 delete from cir_outmast_dis_temp
             where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
		
			select @v_recno=count(*) from cir_rcpt_document_dis_temp
			where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
						recptno=@precptno and recptdt=@v_dt
			If @v_recno>0 Begin		                    
				insert into cir_rcpt_document_dis(comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt)
				select comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt from cir_rcpt_document_dis_temp
				where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
							recptno=@precptno and recptdt=@v_dt
			End

			
			insert into cir_rcp_unadj_dis(comp_code,unit_code,agcd,dpcd,doctyp,recptno,recptdt,publ,amount,created_by,created_date,updated_by,updated_date)
			select comp_code,unit_code,agcd,dpcd,doctyp,recptno,recptdt,publ,amount,created_by,created_date,updated_by,updated_date from cir_rcp_unadj_temp_dis
			where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and recptno=@precptno
			
			delete from cir_rcp_unadj_temp_dis
			where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and recptno=@precptno
			
		End
    else Begin
        insert into cir_rcphdr(comp_code,unit_code,doctype,agcd,dpcd,recptno,
            recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,
            remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,
              staxamt,status,ref_recptno,
              ref_recptdt,
              ref_amount,ref_doctype,cancel_user,cancel_date,
              cancel_remark,userid,creation_date,branch_code,prov_rec_no,prov_rec_dt,remark_oth,MANNUALRECPTNO)
          select comp_code,unit_code,doctype,agcd,dpcd,recptno,
          recptdt,chno,
          CASE chdt WHEN '1900-01-01 00:00:00.000' THEN NULL else chdt END chdt,
          chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,
          remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,
          staxamt,status,ref_recptno,
          CASE ref_recptdt WHEN '1900-01-01 00:00:00.000' THEN NULL else ref_recptdt END  ref_recptdt,
          ref_amount,ref_doctype,cancel_user,cancel_date,
          cancel_remark,userid,creation_date,branch_code,prov_rec_no,
          CASE prov_rec_dt WHEN '1900-01-01 00:00:00.000' THEN NULL else prov_rec_dt END prov_rec_dt,remark_oth,MANNUALRECPTNO from cir_rcphdr_temp
            where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
      
          insert into cir_rcpdet(comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                            payfor, achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, 
                            tds, stax, status, usrid, creation_date, branch_code)
          select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                            payfor, achd, publ, chno, chbnk, 
                            CASE chdt WHEN '1900-01-01 00:00:00.000' THEN NULL else chdt END chdt, 
                            amount, reason, remark, voucherno, voucherdt, 
                            tds, stax, status, usrid, creation_date, branch_code from cir_rcpdet_temp
            where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt

        insert into cir_outmast (comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                        achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, balance, 
                        tds, stax, status, cancel_userid, cancel_dt, cancel_remark, usrid, creation_date, bill_sec_amt, branch_code)
        select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                        achd, publ, chno, chbnk, 
                        CASE chdt WHEN '1900-01-01 00:00:00.000' THEN NULL else chdt END chdt, 
                        amount, reason, remark, voucherno, voucherdt, balance, 
                        tds, stax, status, cancel_userid, cancel_dt, cancel_remark, usrid, creation_date, bill_sec_amt, branch_code from cir_outmast_temp
             where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
	
		insert into cir_rcpt_document(comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt)
		select comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt from cir_rcpt_document_temp
		where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
     	recptno=@precptno and recptdt=@v_dt
		
		insert into cir_rcp_unadj(comp_code,unit_code,agcd,dpcd,doctyp,recptno,recptdt,publ,amount,created_by,created_date,updated_by,updated_date)
		select comp_code,unit_code,agcd,dpcd,doctyp,recptno,recptdt,publ,amount,created_by,created_date,updated_by,updated_date from cir_rcp_unadj_temp
		where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and recptno=@precptno
		
		delete from cir_rcphdr_temp where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
		recptno=@precptno and recptdt=@v_dt
		    
		delete from cir_rcpdet_temp
		where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
		recptno=@precptno and recptdt=@v_dt

		delete from cir_outmast_temp
		where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
		recptno=@precptno and recptdt=@v_dt

		delete from cir_rcpt_document_temp
		where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
		recptno=@precptno and recptdt=@v_dt

		delete from cir_rcp_unadj_temp
		where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and recptno=@precptno
	
    end           
    
-----  this part starts from here for blocking agency for debit note-----------------
	declare @v_doctype_BU as varchar(10) -- rcpt_hdr table 
	declare @v_reason_BU as varchar(10) -- rcpt_hdr table 
	declare @v_agcd_BU as varchar(10) -- rcpt_hdr table 
	declare @v_dpcd_BU as varchar(10) -- rcpt_hdr table 
	declare @v_nooftimes_BU as int  -- reason_mast	
	declare @v_noofdays_BU as int  -- reason_mast
	declare @v_NO_OF_CHQbnc_pref as int  -- preference table
	declare @v_CIR_DAYS_CHQ_pref as int  -- preference table
	
	declare @v_cnt_specific_reason as int	
	declare @vod_payment as varchar(3)	
	declare @no_of_days_pref as int-- for preferrence / anniversary date
	
	set @vod_payment='N'
	set @no_of_days_pref=365
	
	select @v_doctype_BU = DOCTYPE,@v_agcd_BU=agcd,@v_dpcd_BU=DPCD from cir_rcphdr where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
	recptno=@precptno and recptdt=@v_dt
	
	if @v_doctype_BU ='DN' begin	
		
		select @v_reason_BU = REASON from cir_rcphdr where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
		recptno=@precptno and recptdt=@v_dt
		select @v_nooftimes_BU=isnull(no_of_times,0),@v_noofdays_BU=isnull(VALID_DAYS,0) from CIR_REASON_MST where REASON_CODE=@v_reason_BU and DOC_TYPE='DN'
		select @v_NO_OF_CHQbnc_pref=isnull(CIR_NO_OF_CHQBOUNCE,0),@v_CIR_DAYS_CHQ_pref=isnull(CIR_DAYS_CHQBOUNCE,0) from preferrences where comp_code=@pcompcode
		
		if @v_nooftimes_BU ='' 
		begin
			set @v_nooftimes_BU=0
		end	
		if @v_noofdays_BU ='' 
		begin
			set @v_noofdays_BU=0
		end
		if @v_NO_OF_CHQbnc_pref ='' 
		begin
			set @v_NO_OF_CHQbnc_pref=0
		end
		if @v_CIR_DAYS_CHQ_pref ='' 
		begin
			set @v_CIR_DAYS_CHQ_pref=0
		end
		----------------- in case of immediate effect of any reason to suspend the agency---------------
		select @v_cnt_specific_reason=count(*) from cir_rcphdr where comp_code=@pcompcode 
		and unit_code=@punitcode and doctype=@pdoctype and REASON=@v_reason_BU and
		recptno=@precptno and recptdt between dateadd(dd,-1*@v_noofdays_BU,@v_dt) and @v_dt
		
		if @v_nooftimes_BU =0 or @vod_payment='Y' -- 0 for stop payment and over due payment
		begin
					
			update cir_agmast set SUSPEND='Y',SUSPEND_DATE=GETDATE(),SUSPEND_TYPE='CH0' where COMP_CODE=@pcompcode 
			and AGCD=@v_agcd_BU and DPCD=@v_dpcd_BU			
			update CIR_AGENCY_PAYMODE set PAYMODE_ACTIVE='N',BLOCK_BY_A_M=null,UPDATED_DT = getdate()  where COMP_CODE=@pcompcode and AGCD=@v_agcd_BU and DPCD=@v_dpcd_BU
			and PAYMODE='CH0'
		end
		else if @v_nooftimes_BU < ISNULL(@v_cnt_specific_reason,0) or @vod_payment='Y' -- 0 for stop payment and over due payment
		begin
						
			update cir_agmast set SUSPEND='Y',SUSPEND_DATE=GETDATE(),SUSPEND_TYPE='CH0' where COMP_CODE=@pcompcode 
			and AGCD=@v_agcd_BU and DPCD=@v_dpcd_BU			
			update CIR_AGENCY_PAYMODE set PAYMODE_ACTIVE='N',BLOCK_BY_A_M=null,UPDATED_DT = getdate()  where COMP_CODE=@pcompcode and AGCD=@v_agcd_BU and DPCD=@v_dpcd_BU
			and PAYMODE='CH0'
		end
		-------------  end here ------------------------
		declare @v_cnt_specific_period as int
		----------------- in case of cheque bounce specific times in specic period block chq payments only for tht period---------------
		select @v_cnt_specific_period=count(*) from cir_rcphdr where comp_code=@pcompcode 
		and unit_code=@punitcode and doctype=@pdoctype and
		recptno=@precptno and recptdt between dateadd(dd,-1*@v_CIR_DAYS_CHQ_pref,@v_dt) and @v_dt
		
		if @v_NO_OF_CHQbnc_pref < ISNULL(@v_cnt_specific_period,0) 
		begin
						
			update CIR_AGENCY_PAYMODE set PAYMODE_ACTIVE='N',BLOCK_BY_A_M='A',UPDATED_DT = getdate() where COMP_CODE=@pcompcode and AGCD=@v_agcd_BU and DPCD=@v_dpcd_BU
			and PAYMODE='CH0'
		end
		---------------  end here -----------------------
	end
       
-----  this part ends here for blocking agency for debit note  ----------------------


-----  this part starts from here for cheque dishonoured  debit note reverse entry-----------------       

declare @v_refrecnum as varchar(20)
declare @v_refrecdt  as datetime 
declare @v_refrecamt  as numeric(14,2)
declare @vrefdoctype as varchar(20)
declare @v_doctype as varchar(20)
declare @v_reason as varchar(20)

declare @rec_count as int
declare @rec_count1 as int
declare @vag_main_code as varchar(30)
declare @vag_sub_code as varchar(30)
declare @vunit as varchar(30)
declare @rec_amount as numeric(14,2)
declare @rem_amount as numeric(14,2)


/******************************  parameters for cursor*******************************/
declare @c1_branch			as varchar(20)
declare @c1_billno			as varchar(50)
declare @c1_billdt			as datetime
declare @c1_amount			as float
declare @c1_unit			as varchar(20)
declare @c1_agcode			as varchar(30)
declare @c1_doctype			as varchar(20)
declare @c1_reason			as varchar(20)
declare @c1_recptno			as varchar(50)
declare @c1_recptdt			as datetime
declare @c1_chno			as varchar(30)
declare @c1_chdt			as datetime
declare @c1_bank			as varchar(20)
declare @c1_voucherno		as varchar(30)
declare @c1_voucherdate		as datetime
declare @c1_comp_code		as varchar(20)
declare @c1_userid			as varchar(20)
declare @c1_pripub			as varchar(20)
declare @c1_tds				as float
declare @c1_received_region as varchar(30)
declare @c1_stax				as float
declare @c1_ag_main_code	as varchar(20)
declare @c1_ag_sub_code		as varchar(30)
declare @c1_remark			as varchar(200)
declare @v_print_center as varchar(8)

select @v_refrecnum= REF_RECPTNO, @v_refrecdt=REF_RECPTDT,@v_refrecamt=AMOUNT,@v_doctype=DOCTYPE,@v_reason=REASON,
@vag_main_code=AGCD ,@vag_sub_code=DPCD,@vunit=UNIT_CODE,@vrefdoctype=REF_DOCTYPE
from CIR_RCPHDR where COMP_CODE=@pcompcode and RECPTNO=@precptno and RECPTDT=@v_dt and DOCTYPE='DN'
print('***')
print(@precptno)print(@v_dt)print(@v_refrecamt)print(@v_doctype)print(@v_reason)print(@v_refrecnum)print(@v_refrecdt)
print('start')
if isnull(@v_refrecamt,0)>0 and @v_doctype ='DN' and  @v_reason='CH0' and @v_refrecnum is not null and @v_refrecdt is not null 
begin
		select @rec_count=count(*) from cir_rcphdr where comp_code=@pcompcode and UNIT_CODE=@vunit  and recptno=@v_refrecnum and
        AGCD=@vag_main_code and DPCD=@vag_sub_code and amount<>0
		
		print(@vunit)print(@vrefdoctype)print(@v_refrecnum)print(@vag_sub_code)print(@vag_main_code)
        
        select @rec_count1=count(*) from CIR_OUTMAST where comp_code=@pcompcode and UNIT_CODE=@vunit and doctyp=@vrefdoctype and recptno=@v_refrecnum and
        agcd=@vag_main_code and DPCD=@vag_sub_code and billno is not null and amount<>0
print('start_1')		
		if isnull(@rec_count,0)>0
		begin
		print('start_2')
		print(@vunit)print(@vrefdoctype)print(@v_refrecnum)print(@vag_sub_code)print(@vag_main_code)
			select @rec_amount=abs(amount) from cir_rcphdr where comp_code=@pcompcode and UNIT_CODE=@vunit and recptno=@v_refrecnum and
			agcd=@vag_main_code and dpcd=@vag_sub_code and amount<>0
			
			declare c1 cursor for
				select branch_code,billno,billdt,amount,unit_code,'',doctyp,reason,recptno,recptdt							
				,chno,chdt,chbnk,voucherno,voucherdt,comp_code,usrid,publ,tds						
				,'',stax,agcd,dpcd,remark from cir_outmast
				where comp_code=@pcompcode and unit_code=@vunit and recptno=@v_refrecnum and
				agcd=@vag_main_code and dpcd=@vag_sub_code --and amount<>0 
				order by recptdt,recptno,billdt,billno
			
			if @rec_amount=@v_refrecamt 
			begin --3
                set @rem_amount=@v_refrecamt
                print('start_3')
                OPEN c1 
				fetch NEXT FROM c1 INTO	@c1_branch,@c1_billno,@c1_billdt,@c1_amount,@c1_unit,@c1_agcode,@c1_doctype,@c1_reason,@c1_recptno,@c1_recptdt,@c1_chno,@c1_chdt,@c1_bank,@c1_voucherno,@c1_voucherdate,@c1_comp_code,@c1_userid,@c1_pripub,@c1_tds,@c1_received_region,@c1_stax,@c1_ag_main_code,@c1_ag_sub_code,@c1_remark
                WHILE (@@FETCH_STATUS = 0) 
				BEGIN
					 --set @vbillamt=abs(@c1_amount)
					 print('start_4')
					 if @c1_billno is not null and @c1_billdt is not null 
					 begin --4
					 print('start_5')print(@c1_billno)print(@c1_billdt)print('AAA')
						delete from CIR_OUTMAST where comp_code=@c1_comp_code and unit_code=@c1_unit 
						and agcd=@c1_ag_main_code and dpcd=@c1_ag_sub_code and BILLNO=@c1_billno and BILLDT=@c1_billdt and RECPTNO is not null					
						delete from CIR_RCPDET where comp_code=@c1_comp_code and unit_code=@c1_unit 
						and agcd=@c1_ag_main_code and dpcd=@c1_ag_sub_code and BILLNO=@c1_billno and BILLDT=@c1_billdt and RECPTNO is not null					
					 end
					 else --if abs(@c1_amount)=ABS(@v_refrecamt) --4
					 begin
						/*---if ref recipt amount in hand greater than zero amount---*/
						print('start_6')
                        insert into cir_outmast (UNIT_CODE,doctyp,reason , BRANCH_CODE , billno , billdt , recptno , recptdt ,
                                                 chno , chdt , chbnk , voucherno , voucherdt , amount , comp_code , USRID ,
                                                 publ , tds , stax,agcd,dpcd,remark)
                                          values(@c1_unit,@c1_doctype,@c1_reason,@c1_branch,@precptno,@v_dt,@c1_recptno,@c1_recptdt,
                                                 @c1_chno , @c1_chdt ,@c1_bank,@c1_voucherno,@c1_voucherdate,-1*@v_refrecamt,@c1_comp_code,@c1_userid,
                                                 @c1_pripub,@c1_tds,@c1_stax,@c1_ag_main_code,@c1_ag_sub_code,@c1_remark)                                                 
                        
                        update cir_outmast set amount=0 where comp_code=@c1_comp_code and unit_code=@c1_unit and recptno=@c1_recptno
                        and recptdt=@c1_recptdt and billno is null and billdt is null
                        
                        insert into cir_rcpdet(UNIT_CODE,doctyp,reason , BRANCH_CODE , billno , billdt , recptno , recptdt ,
                                                 chno , chdt , chbnk , voucherno , voucherdt , amount , comp_code , USRID ,
                                                 publ , tds , stax,agcd,dpcd,remark)
                                          values(@c1_unit,@c1_doctype,@c1_reason,@c1_branch,@precptno,@v_dt,@c1_recptno,@c1_recptdt,
                                                 @c1_chno , @c1_chdt ,@c1_bank,@c1_voucherno,@c1_voucherdate,-1*@v_refrecamt,@c1_comp_code,@c1_userid,
                                                 @c1_pripub,@c1_tds,@c1_stax,@c1_ag_main_code,@c1_ag_sub_code,@c1_remark)
                        print('@v_refrecamt')print(@v_refrecamt)
                        /*---if ref recipt amount in hand greater than zero amount---*/
					 end
					 
				
				fetch NEXT FROM c1 INTO	@c1_branch,@c1_billno,@c1_billdt,@c1_amount,@c1_unit,@c1_agcode,@c1_doctype,@c1_reason,@c1_recptno,@c1_recptdt,@c1_chno,@c1_chdt,@c1_bank,@c1_voucherno,@c1_voucherdate,@c1_comp_code,@c1_userid,@c1_pripub,@c1_tds,@c1_received_region,@c1_stax,@c1_ag_main_code,@c1_ag_sub_code,@c1_remark
				END
				close c1
				deallocate c1
                print('start_7')
                
                
			end
			print('start_8')
		end
	print('start_9')
end



-----  this part ends here for cheque dishonoured  debit note reverse entry -----------------
    if upper(@prectype)='D' Begin
        select @v_recno=count(*) from cir_rcphdr_dis 
            where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
                recptno=@precptno
		End
    else Begin
        select @v_recno=count(*) from cir_rcphdr 
            where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
                recptno=@precptno 
    End

    if isnull(@v_recno,0)>0 Begin		
        select @v_recno as "RECNO"
		End
     else Begin
        select 0 as "RECNO"
     End

end

//////////////////////////////////////////////////////////////////////////////////////////////////


                                                                     
                                                                     
                                                                     
                                             
ALTER function [dbo].[cir_get_unsold_returnable]
(
  @pcompcode         as varchar(20),      
  @ppublcode         as varchar(20),      
  @psupcopy  		 as int,      
  @puserid           as varchar(20),
  @pagcd             as varchar(20),
  @pdpcd             as varchar(20),
  @pflag             as varchar(1),
  @pextra1           as varchar(20),
  @pextra2           as varchar(20)
 )					returns numeric

As
Begin
	-------
	declare @v_bill_freq as varchar(1)
	declare @v_unit      as varchar(20)
	declare @v_branch   as varchar(20)
	declare @v_region    as varchar(20)
	declare @v_zone      as varchar(20)
	declare @v_agtype    as varchar(20)
	declare @v_agclass   as varchar(20)
	declare @v_citycode  as varchar(20)
	declare @v_cnt       as int
	declare @v_output    as numeric(14,2)
	declare @v_value     as numeric(14,2)
	
	select distinct @v_bill_freq=billing_cycle from CIR_SUPPLY where comp_code= @pcompcode 
	and agcd=@pagcd and dpcd=@pdpcd and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
	and (EDTN=@pextra1 or @pextra1 is null or @pextra1 ='')
	
	select @v_unit=unit,@v_branch=branch_code,@v_citycode=city_code,@v_agtype=ag_type,@v_agclass=ag_class from cir_agmast
	where comp_code=@pcompcode and agcd=@pagcd and dpcd=@pdpcd
	
	select distinct @v_zone=zone_code,@v_region=region_code from cir_city_mast c where c.city_code=@v_citycode
	
	
	
	if @v_unit = '' begin
		set @v_unit=null
	end
	if @v_branch ='' begin
		set @v_branch=null
	end
	if @v_region ='' begin
		set @v_region=null
	end
	if @v_zone='' begin
		set @v_zone=null
	end
	if @v_agtype='' begin
		set @v_agtype=null
	end
	if @v_agclass ='' begin
		set @v_agclass=null
	end
	
	select @v_cnt= count(*) from CIR_UNSOLD_RETURN_CONTROL where comp_code=@pcompcode
	and (publ_code=@ppublcode or publ_code is null or publ_code ='') 
	and bill_freq=@v_bill_freq 
	--and (unit_code=@v_unit or unit_code is null or unit_code ='') 
	and (branch_code=@v_branch or branch_code is null or branch_code ='')
	and (reg_code=@v_region or reg_code is null or reg_code='') 
	and (zone_code=@v_zone or zone_code is null or zone_code='') 
	and (ag_type=@v_agtype or ag_type is null or ag_type='') 
	and (ag_class=@v_agclass or ag_class is null or ag_class='')
	and (EDTN_CODE=@pextra1 or EDTN_CODE is null or EDTN_CODE ='')
	
	select @v_output= isnull(perm_per,0) from CIR_UNSOLD_RETURN_CONTROL p--,cir_dbksup x
	where comp_code=@pcompcode
	--and x.comp_code=p.comp_code and x.publ=p.publ and x.edtn=p.edtn
	and (publ_code=@ppublcode or publ_code is null or publ_code ='') 
	and bill_freq=@v_bill_freq 
	and (unit_code=@v_unit or unit_code is null or unit_code ='') 
	and (branch_code=@v_branch or branch_code is null or branch_code ='')
	and (reg_code=@v_region or reg_code is null or reg_code='') 
	and (zone_code=@v_zone or zone_code is null or zone_code='') 
	and (ag_type=@v_agtype or ag_type is null or ag_type='') 
	and (ag_class=@v_agclass or ag_class is null or ag_class='')
	and (EDTN_CODE=@pextra1 or EDTN_CODE is null or EDTN_CODE ='')
	
	if @v_cnt =0 begin
		set @v_output= 0
	end		

	if @pflag = 'P'
	begin
		set @v_value=@v_output
	end	
	else
	begin
		set @v_value=round(((@psupcopy*@v_output)/100),0)
		
	end
/*	-------	 */
	return isnull(@v_value,0)

End 
	

///////////////////////////////////////sent by amit sir//////

ALTER procedure [dbo].[cir_payreason_for_receipt]
    @pcompcode       as varchar(200),
    @punitcode       as varchar(200),
    @pdoctype        as varchar(200),
    @pagcd           as varchar(200),
    @pdpcd           as varchar(200),
    @pdateformat     as varchar(200),
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
as
begin

    if(@pdoctype !='RCR') Begin
        select distinct reason_code as "PAY_MODE_CODE",reason_name as "PAYMENT_MODE_NAME",'N' as "MODE_TYPE" ,chq_return_flag as "CHQ_RETURN_FLAG",
        no_of_times as "NO_OF_TIMES",valid_days as "VALID_DAYS",DR_CDP,CR_CDP
        from cir_reason_mst where comp_code = @pcompcode and ((upper(reason_name) like upper(@pextra1)+'%') or (@pextra1 is null) or (@pextra1='')) and
        ((doc_type=@pdoctype) or doc_type is null or doc_type='')
        order by payment_mode_name
    End
    if(@pdoctype ='RCR') Begin
        select distinct x.PAY_MODE_CODE as "PAY_MODE_CODE" ,x."PAYMENT_MODE_NAME" as "PAYMENT_MODE_NAME",x."MODE_TYPE" as "MODE_TYPE" ,x."CHQ_RETURN_FLAG" as "CHQ_RETURN_FLAG",
        x."NO_OF_TIMES" as "NO_OF_TIMES",x."VALID_DAYS" as "VALID_DAYS" from
        (select distinct p."Pay_Mode_Code" as "PAY_MODE_CODE" ,p."Payment_Mode_Name" as "PAYMENT_MODE_NAME",p.payment_mode_type as "MODE_TYPE" ,'N' as "CHQ_RETURN_FLAG",
        0 as "NO_OF_TIMES",0 as "VALID_DAYS"
        from payment_mode_mast p,cir_agency_paymode a
        where a.comp_code=@pcompcode and a.unit_code=@punitcode and a.agcd=@pagcd and a.dpcd=@pdpcd and
        a.paymode=p."Pay_Mode_Code" and ((upper(p."Payment_Mode_Name") like upper(@pextra1)+'%') or (@pextra1 is null) or (@pextra1='')) and
        isnull(a.paymode_active,'N')='Y'
        union
        select distinct p."Pay_Mode_Code" as "PAY_MODE_CODE" ,p."Payment_Mode_Name" as "PAYMENT_MODE_NAME",p.payment_mode_type as "MODE_TYPE" ,'N' as "CHQ_RETURN_FLAG",
        0 as "NO_OF_TIMES",0 as "VALID_DAYS"
        from payment_mode_mast p
        where ((upper(p."Payment_Mode_Name") like upper(@pextra1)+'%') or (@pextra1 is null) or (@pextra1='')) and p."Pay_Mode_Code"='CA0') x
        order by payment_mode_name
    End
   
    select getdate() as "CUR_DATE"
   
End

///////////////////////////////////////////

ALTER PROCEDURE [dbo].[CIR_reasoncode]
@str                                      VARCHAR(200) ,
@cod                                      VARCHAR(200)
AS

SELECT *
FROM  cir_reason_mst
WHERE reason_name  = @str


SELECT MAX(CONVERT(NUMERIC(8, 0), SUBSTRING(reason_code, 3, LEN(reason_code)))) as CURR_CODE
FROM  cir_reason_mst
WHERE reason_code  like @cod + '%'

//////////////////////////////////////////////////



alter PROCEDURE [dbo].[cir_account_mast_fa_receipt_debit_head_utusan]
@pcompcode                                VARCHAR(20) ,
@punitcode                                VARCHAR(20) ,
@pbranch                                  VARCHAR(20) ,
@pdoctype                                 VARCHAR(20) ,
@presion                                  VARCHAR(20) ,
@pactyp                                   VARCHAR(20) ,
@pdateformat                              VARCHAR(20) ,
@pextra1                                  VARCHAR(4000) ,
@pextra2                                  VARCHAR(4000) ,
@pextra3                                  VARCHAR(4000) ,
@pextra4                                  VARCHAR(4000) ,
@pextra5                                  VARCHAR(4000) ,
@pextra6                                  VARCHAR(4000)
AS
Begin

SELECT * FROM  fa_acc_mast
WHERE comp_code  = @pcompcode
and (DEFAULT_UNIT=@punitcode  OR @punitcode = '' OR @punitcode  is null)
and (DEFAULT_BRANCH=@pbranch  OR @pbranch   = '' OR @pbranch  is null)
and (DETAIL_CAPTURE_CODE=@presion  OR @presion  is null)
and (CDP  =@pextra1  OR @pextra1='' OR @pextra1  is null)
and (ACC_TY in (Select ac_type_code from FA_ACCOUNT_TYPE_MAST where AC_CASH_BANK=@pactyp or @pactyp is null or @pactyp=''))


select * from FA_ACC_MAST
WHERE comp_code  = @pcompcode
and (CDP  =@pextra2 OR @pextra2  = '' OR @pextra2  is null)
and (ACC_TY in (Select ac_type_code from FA_ACCOUNT_TYPE_MAST where AC_CASH_BANK=@pactyp or @pactyp is null or @pactyp=''))

End

/////////////////////////////////////////////////////


ALTER procedure [dbo].[cir_rep_do_agencywise_p]
     @pcompcode          as varchar(20),
     @punitcode          as varchar(20),
     @pbrancode          as varchar(20),
     @proutemode         as varchar(20),
     @proute             as varchar(200),
     @psubroute          as varchar(200),
     @psubsub_route      as varchar(200),
     @ppubl              as varchar(20),
     @pagtype            as varchar(20),
     @pagclass           as varchar(20),
     @pagcd              as varchar(20),
     @pdpcd              as varchar(20),
     @pdistcode          as varchar(20),
     @plbldt             as datetime,
     @preptype           as varchar(20),
     @puserid            as varchar(20),
     @pdateformat        as varchar(20),
     @pextra1            as varchar(200),
     @pextra2            as varchar(200),
     @pextra3            as varchar(200),
     @pextra4            as varchar(200),
     @pextra5            as varchar(200)
As
    declare @vlbldt datetime
Begin
    If @pbrancode='' Begin
		set @pbrancode=null
	End	
    If @proutemode  ='' Begin
		set @proutemode=null
	End
	If @proute='' Begin		
		set @proute=null
	End
    If @psubroute='' Begin
		set @psubroute=null
	End	
    If @psubsub_route  ='' Begin
		set @psubsub_route=null
	End
	If @ppubl='' Begin		
		set @ppubl=null
	End

    If @pagtype  ='' Begin
		set @pagtype=null
	End
	If @pagclass='' Begin		
		set @pagclass=null
	End
    If @pagcd='' Begin
		set @pagcd=null
	End	
    If @pdpcd  ='' Begin
		set @pdpcd=null
	End
	If @pdistcode='' Begin		
		set @pdistcode=null
	End
	
    select distinct l.comp_code as "COMP_CODE",l.unit_code as "UNIT_CODE",dbo.get_unit_name(l.comp_code,l.unit_code) as "UNIT_NAME",a.branch_code as "branch",dbo.get_branch_name(a.branch_code) as "branch_name", l.agcd as "AGCD", l.dpcd as "DPCD",l.lbl_dt as "LBL_DT",
    l.route1 as "ROUTE_CODE",l.rtnm as "RTNM",l.rtonm as "RTONM",l.subrt as "SUBROUTE_CODE",l.subrtnm as "SUBRTNM",l.subrtonm as "SUBRTONM",
    l.sub_subrt as "SUB_SUBROUTE_CODE",l.subsubrtnm as "SUBSUBRTNM",l.subsubrtonm as "SUBSUBRTONM",l.pkt_size as "PACKET_SIZE", 
    l.lbl_tno as "NO_OF_PACKET",m.mode_desc as "MODE_NAME",
    l.agname as "AGNAME",l.agoname as "AGONAME", l.city_name as "CITY_NAME", l.city_oname as "CITY_ONAME", 
    a.station_code as "DROP_POINT", l.station_name as "DROP_POINT_NAME", l.station_oname as "DROP_POINT_ONAME", l.publ as "PUBL",dbo.cir_get_publ_name(l.comp_code,l.publ) as "PUBL_NAME", 
    l.edtn as "EDTN",dbo.cir_get_edtn_name(l.comp_code,l.edtn) as "EDTN_NAME", 
    sum(l.supply_1) as "NO_OF_COPY",case when l.lbl_tno<=1 then 0 else l.lbl_tno-1 end "STD_PACKET",
    case when l.lbl_tno<=1 then sum(l.supply_1) else sum(l.supply_1)-((l.lbl_tno-1)*l.PKT_SIZE) end as "END_PACKET_COPY",
    l.sup_rate as "SUP_RATE", l.distname as "DISTNAME", l.distoname as "DISTONAME"
    from cir_agmast a,cir_lblmast l,cir_route_mast r,cir_route_mode_mast m
    where a.comp_code=l.comp_code and a.comp_code=r.comp_code and a.comp_code=m.comp_code and a.comp_code=@pcompcode and 
    a.unit=l.unit_code and a.unit=r.unit and a.unit=@punitcode and a.agcd=l.agcd and a.agcd=isnull(@pagcd,l.agcd) and a.dpcd=l.dpcd and a.dpcd=isnull(@pdpcd,l.dpcd) and
    r.route_code=l.route1 and r.route_code=isnull(@proute,r.route_code) and (l.subrt=@psubroute or @psubroute is null) and
    (l.sub_subrt=@psubsub_route or @psubsub_route is null) and r.route_mode=m.mode_code and r.route_mode=isnull(@proutemode,r.route_mode) and 
    l.lbl_dt=@plbldt and (a.ag_type=@pagtype or @pagtype is null) and (a.ag_class=@pagclass or @pagclass is null) and 
    (a.branch_code=@pbrancode or @pbrancode is null) and (a.dist_code=@pdistcode or @pdistcode is null)
    group by l.comp_code,l.unit_code,a.branch_code,l.agcd, l.dpcd,l.lbl_dt,l.route1,l.rtnm,l.rtonm,l.subrt,l.subrtnm,l.subrtonm,
    l.sub_subrt,l.subsubrtnm,l.subsubrtonm,l.pkt_size,l.lbl_tno,m.mode_desc,l.agname,l.agoname, l.city_name, l.city_oname, 
    a.station_code,l.station_name, l.station_oname,publ,edtn,l.sup_rate, l.publ_name, l.distname, l.distoname
    order by comp_code,unit_code,branch_code,rtnm,subrtnm,subsubrtnm,agname;
    
    select getdate() as "CUR_DATE"
End



////////////////////////////////////////////////////end//////////////////////////////////////////////////////////// 

/**8240****/

ALTER procedure [dbo].[cir_get_tran_detail]
(
@ptext1 varchar(200),
@pcomp_code varchar(200),
@ptext2 varchar(200),
@punit_code varchar(200),
@ptext3 varchar(200),
@puser_code varchar(200),
@ptext4 varchar(200),
@pfromdt varchar(200),
@ptodt varchar(200),
@ptname varchar(200),
@pdateformat varchar(200)
)

as
begin

declare @pquery varchar(2000)

print('prachi')

set @pquery='select * from '+@ptname+' where   1=1  '

if(@ptext1!='' and @ptext1 is not null and @pcomp_code!='' and @pcomp_code is not null) begin
set @pquery=@pquery+' and  '+@ptext1+'= '''+@pcomp_code+'''  '
end

if(@ptext2!='' and @ptext2 is not null and @punit_code!='' and @punit_code is not null) begin
set @pquery=@pquery+' and '+@ptext2+'= '''+@punit_code+'''  '
end
if(@ptext3!='' and @ptext3 is not null and @puser_code!='' and @puser_code is not null) begin
set @pquery=@pquery+' and '+@ptext3+'= '''+@puser_code+'''  '
end
if(@ptext4!='' and @ptext4 is not null) begin
set @pquery=@pquery+' and '+@ptext4+' between cast( DBO.CONVERT_USER_DATE(''/'', '''+@pfromdt+''',''mm/dd/yyyy'')as datetime)  and  (cast( DBO.CONVERT_USER_DATE(''/'','''+@ptodt+''',''mm/dd/yyyy'')as datetime)+1) '
end
print(@pquery)
exec(@pquery)
end


////////////////////

ALTER PROCEDURE [dbo].[cir_receipt_ref_receipt_P]
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @pdoctype        as varchar(20),
    @precptno        as varchar(20),
    @precptdt        as datetime,
    @preasoncode     as varchar(20),
    @puserid         as varchar(20),
    @pdateformat     as varchar(20),
    @pextra1         as varchar(20),--allbill_tag
    @pextra2         as varchar(20)
    as
begin
    if(@pextra1='Y')begin
    select h.comp_code COMP_CODE,h.unit_code UNIT_CODE,h.agcd AGCD,h.dpcd DPCD,m.ag_name AG_NAME,h.doctype DOCTYPE,h.recptno RECPTNO,h.recptdt RECPTDT,
    abs(h.amount) AS AMOUNT,h.chno CHNO,h.chdt CHDT,h.chbank CHBANK,h.reason REASON,h.prov_rec_no PROV_REC_NO,
    h.prov_rec_dt PROV_REC_DT,h.received_from RECEIVED_FROM,h.achd AHCD,h.ccdp DEBIT_HEAD,
	(select acc_name from fa_acc_mast where comp_code=h.comp_code and cdp=h.ccdp) as CREDIT_HEAD_NAME,
	h.rcdp credit_head,(select acc_name from fa_acc_mast where comp_code=h.comp_code and cdp=h.rcdp) as DEBIT_HEAD_NAME
    from cir_rcphdr h,cir_agmast m
    where h.comp_code=m.comp_code and h.comp_code=@pcompcode and h.unit_code=m.unit and h.unit_code=@punitcode 
    and h.agcd=m.agcd and h.dpcd=m.dpcd and h.chno is not null
    and h.doctype=@pdoctype 
    and ( (h.recptno=@precptno and h.recptdt=@precptdt ) 
    or (h.CHNO=upper(@precptno) and (@precptdt is null or @precptdt ='') )  )
    end
    else begin
    select h.comp_code COMP_CODE,h.unit_code UNIT_CODE,h.agcd AGCD,h.dpcd DPCD,m.ag_name AG_NAME,h.doctyp DOCTYPE,h.recptno RECPTNO,h.recptdt RECPTDT,
    abs(h.amount) AS AMOUNT,h.chno CHNO,h.chdt CHDT,h.chbnk CHBANK,h.reason REASON,
    r.prov_rec_no PROV_REC_NO,
  r.prov_rec_dt PROV_REC_DT,
   r.received_from RECEIVED_FROM,
   h.achd AHCD
   ,r.ccdp DEBIT_HEAD
	,(select acc_name from fa_acc_mast where comp_code=h.comp_code and cdp=r.ccdp) as CREDIT_HEAD_NAME,
	r.rcdp credit_head,(select acc_name from fa_acc_mast where comp_code=h.comp_code and cdp=r.rcdp) as DEBIT_HEAD_NAME
    from cir_outmast h,cir_agmast m,cir_rcphdr r
    where h.comp_code=m.comp_code and h.comp_code=@pcompcode and h.unit_code=m.unit and h.unit_code=@punitcode 
    and h.agcd=m.agcd and h.dpcd=m.dpcd and h.chno is not null
    and h.doctyp=@pdoctype 
    and billno is not null
    and ( (h.recptno=@precptno and h.recptdt=@precptdt ) 
    or (h.CHNO=upper(@precptno) and (@precptdt is null or @precptdt ='') )  )
    and r.comp_code=m.comp_code and r.unit_code=m.unit
    and r.agcd=m.agcd and r.dpcd=m.dpcd and r.chno is not null
    and r.comp_code=h.comp_code and r.unit_code=h.unit_code
    and r.agcd=h.agcd
    and r.dpcd=h.dpcd
    and r.doctype=h.doctyp
    and r.recptno=h.recptno
    and r.recptdt=h.recptdt
    and r.chno=h.chno
    and r.chdt=h.chdt
    and r.chbank=h.chbnk
    and r.achd=h.achd
    and r.voucherno=h.voucherno
    and r.voucherdt=h.voucherdt
    end
    
End


///////////////////////////////
                                                                     
                                                                     
                                                                     
                                             
create PROCEDURE [dbo].[cir_get_userlist_]
@pcompcode VARCHAR(20) ,
@punit VARCHAR(20) ,
@pbranch VARCHAR(20) ,
@agcd VARCHAR(20) ,
@dpcd VARCHAR(20) ,
@pfromdate VARCHAR(20) ,
@ptodate VARCHAR(20) ,
@userid VARCHAR(20) ,
@pdateformat VARCHAR(20) ,
@pextra1 varchar(200),
@pextra2 varchar(200),
@pextra3 varchar(200),
@pextra4 varchar(200),
@pextra5 varchar(200),
@pextra6 varchar(200),
@pextra7 varchar(200),
@pextra8 varchar(200),
@pextra9 varchar(200),
@pextra10 varchar(200)

AS
BEGIN

SELECT T.COMP_CODE,UNIT,T.AGCD,T.DPCD,MAX(T.ALTER_ST) ALTER_ST,MAX(T.ALTER_USER) ALTER_USER ,MAX(T.CORRECT_ST) CORRECT_ST
,MAX(T.CORRECT_USER) CORRECT_USER FROM (
select distinct Q.COMP_CODE,Q.UNIT,Q.AGCD,Q.DPCD
,CASE Q.ALTER_ST WHEN 'CORRECT' THEN 'Y' ELSE '' END CORRECT_ST 
,CASE Q.ALTER_ST WHEN 'ALTER' THEN 'Y' ELSE '' END ALTER_ST 
,Q.ALTER_USER,Q.ALTER_USER CORRECT_USER from (

	select z.COMP_CODE,z.UNIT,z.AGCD,z.DPCD,z.ALTER_ST,z.ALTER_USER  from 
	(select x.COMP_CODE,x.UNIT,x.AGCD,x.DPCD,x.ALTER_ST,x.ALTER_USER   from (
	select COMP_CODE,UNIT,AGCD,DPCD,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,SUPPLY_WED,SUPPLY_THU
	,SUPPLY_FRI,SUPPLY_SAT,SUPPLY_SPL1,SUPPLY_SPL2,SP_SUPPLY_SUN1,SP_SUPPLY_MON1,SP_SUPPLY_TUE1,SP_SUPPLY_WED1,SP_SUPPLY_THU1
	,SP_SUPPLY_FRI1,SP_SUPPLY_SAT1,SP_SUPPLY_SUN2,SP_SUPPLY_MON2,SP_SUPPLY_TUE2,SP_SUPPLY_WED2,SP_SUPPLY_THU2
	,SP_SUPPLY_FRI2,SP_SUPPLY_SAT2,'ALTER' ALTER_ST ,LOG_USER ALTER_USER  from CIR_SUPPLY_LOG v 
	WHERE COMP_CODE=@pcompcode and LOG_TYPE='N#UPDATE' and cast(LOG_DATE as datetime) between @pfromdate and @ptodate
	and not exists(
	select COMP_CODE,UNIT,AGCD,DPCD,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,SUPPLY_WED,SUPPLY_THU
	,SUPPLY_FRI,SUPPLY_SAT,SUPPLY_SPL1,SUPPLY_SPL2,SP_SUPPLY_SUN1,SP_SUPPLY_MON1,SP_SUPPLY_TUE1,SP_SUPPLY_WED1,SP_SUPPLY_THU1
	,SP_SUPPLY_FRI1,SP_SUPPLY_SAT1,SP_SUPPLY_SUN2,SP_SUPPLY_MON2,SP_SUPPLY_TUE2,SP_SUPPLY_WED2,SP_SUPPLY_THU2
	,SP_SUPPLY_FRI2,SP_SUPPLY_SAT2,'ALTER' ALTER_ST,LOG_USER ALTER_USER  from CIR_SUPPLY_LOG t 
	WHERE COMP_CODE=@pcompcode and LOG_TYPE='O#UPDATE'  and cast(LOG_DATE as datetime) between @pfromdate and @ptodate
	and v.COMP_CODE=t.COMP_CODE and v.UNIT=t.UNIT and v.AGCD=t.AGCD and v.DPCD=t.DPCD
	and v.BASE_SUPPLY=t.BASE_SUPPLY and v.SUPPLY_SUN=t.SUPPLY_SUN and v.SUPPLY_MON=t.SUPPLY_MON and v.SUPPLY_TUE=t.SUPPLY_TUE
	and v.SUPPLY_WED=t.SUPPLY_WED and v.SUPPLY_THU=t.SUPPLY_THU and v.SUPPLY_FRI=t.SUPPLY_FRI and v.SUPPLY_SAT =t.SUPPLY_SAT
	and v.SUPPLY_SPL1=t.SUPPLY_SPL1 and v.SUPPLY_SPL2=t.SUPPLY_SPL2 and v.SP_SUPPLY_SUN1 = t.SP_SUPPLY_SUN1 and v.SP_SUPPLY_MON1=t.SP_SUPPLY_MON1
	and v.SP_SUPPLY_TUE1=t.SP_SUPPLY_TUE1 and v.SP_SUPPLY_WED1=t.SP_SUPPLY_WED1 and v.SP_SUPPLY_THU1=t.SP_SUPPLY_THU1
	and v.SP_SUPPLY_FRI1 =t.SP_SUPPLY_FRI1 and v.SP_SUPPLY_SAT1=t.SP_SUPPLY_SAT1 and v.SP_SUPPLY_SUN2 = t.SP_SUPPLY_SUN2 and v.SP_SUPPLY_MON2=t.SP_SUPPLY_MON2
	and v.SP_SUPPLY_TUE2=t.SP_SUPPLY_TUE2 and v.SP_SUPPLY_WED2=t.SP_SUPPLY_WED2 and v.SP_SUPPLY_THU2=t.SP_SUPPLY_THU2
	and v.SP_SUPPLY_FRI2 =t.SP_SUPPLY_FRI2 and v.SP_SUPPLY_SAT2=t.SP_SUPPLY_SAT2)
	) x
	union all
	select y.COMP_CODE,y.UNIT_CODE UNIT,y.AGCD,y.DPCD,y.ALTER_ST,y.ALTER_USER  from
	(select COMP_CODE,UNIT_CODE,AGCD,DPCD,SUP_COPY,'CORRECT' ALTER_ST ,LOG_USER ALTER_USER  
	from cir_dbksup_log v WHERE COMP_CODE=@pcompcode and LOG_TYPE='N#UPDATE' and cast(LOG_DATE as datetime) between @pfromdate and @ptodate
	and not exists(
	select COMP_CODE,UNIT_CODE,AGCD,DPCD,SUP_COPY,'CORRECT' ALTER_ST ,LOG_USER ALTER_USER  
	from cir_dbksup_log t WHERE COMP_CODE=@pcompcode and LOG_TYPE='O#UPDATE' and cast(LOG_DATE as datetime) between @pfromdate and @ptodate
	and v.COMP_CODE=t.COMP_CODE and v.SUP_COPY=t.SUP_COPY and v.UNIT_CODE=t.UNIT_CODE and v.AGCD=t.AGCD and v.DPCD=t.DPCD
	)
	)y )z where z.COMP_CODE=@pcompcode 
	and (z.UNIT =@punit or @punit is null or @punit='')
	--and (branch_code =@pbranch or @pbranch is null or @pbranch ='')
	and (z.AGCD =@agcd or @agcd is null or @agcd='')
	and (z.DPCD=@dpcd or @dpcd is null or @dpcd ='')
	group by z.COMP_CODE,z.UNIT,z.AGCD,z.DPCD,z.ALTER_ST,z.ALTER_USER
) Q ) T
	GROUP BY T.COMP_CODE,T.UNIT,T.AGCD,T.DPCD


END

/*select z.COMP_CODE,z.UNIT,z.AGCD,z.DPCD,z.ALTER_ST,z.ALTER_USER,z.CORRECT_ST,z.CORRECT_USER from 
	(select x.COMP_CODE,x.UNIT,x.AGCD,x.DPCD,x.ALTER_ST,x.ALTER_USER,x.CORRECT_ST,x.CORRECT_USER   from (
	select COMP_CODE,UNIT,AGCD,DPCD,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,SUPPLY_WED,SUPPLY_THU
	,SUPPLY_FRI,SUPPLY_SAT,SUPPLY_SPL1,SUPPLY_SPL2,SP_SUPPLY_SUN1,SP_SUPPLY_MON1,SP_SUPPLY_TUE1,SP_SUPPLY_WED1,SP_SUPPLY_THU1
	,SP_SUPPLY_FRI1,SP_SUPPLY_SAT1,SP_SUPPLY_SUN2,SP_SUPPLY_MON2,SP_SUPPLY_TUE2,SP_SUPPLY_WED2,SP_SUPPLY_THU2
	,SP_SUPPLY_FRI2,SP_SUPPLY_SAT2,'YES' ALTER_ST ,LOG_USER ALTER_USER ,'NO' CORRECT_ST ,null CORRECT_USER from CIR_SUPPLY_LOG v 
	WHERE COMP_CODE=@pcompcode and LOG_TYPE='N#UPDATE' and cast(LOG_DATE as date) between @pfromdate and @ptodate
	and not exists(
	select COMP_CODE,UNIT,AGCD,DPCD,BASE_SUPPLY,SUPPLY_SUN,SUPPLY_MON,SUPPLY_TUE,SUPPLY_WED,SUPPLY_THU
	,SUPPLY_FRI,SUPPLY_SAT,SUPPLY_SPL1,SUPPLY_SPL2,SP_SUPPLY_SUN1,SP_SUPPLY_MON1,SP_SUPPLY_TUE1,SP_SUPPLY_WED1,SP_SUPPLY_THU1
	,SP_SUPPLY_FRI1,SP_SUPPLY_SAT1,SP_SUPPLY_SUN2,SP_SUPPLY_MON2,SP_SUPPLY_TUE2,SP_SUPPLY_WED2,SP_SUPPLY_THU2
	,SP_SUPPLY_FRI2,SP_SUPPLY_SAT2,'YES' ALTER_ST,LOG_USER ALTER_USER ,'NO' CORRECT_ST ,null CORRECT_USER from CIR_SUPPLY_LOG t 
	WHERE COMP_CODE=@pcompcode and LOG_TYPE='O#UPDATE'  and cast(LOG_DATE as date) between @pfromdate and @ptodate
	and v.COMP_CODE=t.COMP_CODE and v.UNIT=t.UNIT and v.AGCD=t.AGCD and v.DPCD=t.DPCD
	and v.BASE_SUPPLY=t.BASE_SUPPLY and v.SUPPLY_SUN=t.SUPPLY_SUN and v.SUPPLY_MON=t.SUPPLY_MON and v.SUPPLY_TUE=t.SUPPLY_TUE
	and v.SUPPLY_WED=t.SUPPLY_WED and v.SUPPLY_THU=t.SUPPLY_THU and v.SUPPLY_FRI=t.SUPPLY_FRI and v.SUPPLY_SAT =t.SUPPLY_SAT
	and v.SUPPLY_SPL1=t.SUPPLY_SPL1 and v.SUPPLY_SPL2=t.SUPPLY_SPL2 and v.SP_SUPPLY_SUN1 = t.SP_SUPPLY_SUN1 and v.SP_SUPPLY_MON1=t.SP_SUPPLY_MON1
	and v.SP_SUPPLY_TUE1=t.SP_SUPPLY_TUE1 and v.SP_SUPPLY_WED1=t.SP_SUPPLY_WED1 and v.SP_SUPPLY_THU1=t.SP_SUPPLY_THU1
	and v.SP_SUPPLY_FRI1 =t.SP_SUPPLY_FRI1 and v.SP_SUPPLY_SAT1=t.SP_SUPPLY_SAT1 and v.SP_SUPPLY_SUN2 = t.SP_SUPPLY_SUN2 and v.SP_SUPPLY_MON2=t.SP_SUPPLY_MON2
	and v.SP_SUPPLY_TUE2=t.SP_SUPPLY_TUE2 and v.SP_SUPPLY_WED2=t.SP_SUPPLY_WED2 and v.SP_SUPPLY_THU2=t.SP_SUPPLY_THU2
	and v.SP_SUPPLY_FRI2 =t.SP_SUPPLY_FRI2 and v.SP_SUPPLY_SAT2=t.SP_SUPPLY_SAT2)
	) x
	union all
	select y.COMP_CODE,y.UNIT_CODE UNIT,y.AGCD,y.DPCD,y.ALTER_ST,y.ALTER_USER,y.CORRECT_ST,y.CORRECT_USER  from
	(select COMP_CODE,UNIT_CODE,AGCD,DPCD,SUP_COPY,'NO' ALTER_ST ,null ALTER_USER ,'YES' CORRECT_ST ,LOG_USER CORRECT_USER 
	from cir_dbksup_log v WHERE COMP_CODE=@pcompcode and LOG_TYPE='N#UPDATE' and cast(LOG_DATE as date) between @pfromdate and @ptodate
	and not exists(
	select COMP_CODE,UNIT_CODE,AGCD,DPCD,SUP_COPY,'NO' ALTER_ST ,null ALTER_USER ,'YES' CORRECT_ST ,LOG_USER CORRECT_USER 
	from cir_dbksup_log t WHERE COMP_CODE=@pcompcode and LOG_TYPE='O#UPDATE' and cast(LOG_DATE as date) between @pfromdate and @ptodate
	and v.COMP_CODE=t.COMP_CODE and v.SUP_COPY=t.SUP_COPY and v.UNIT_CODE=t.UNIT_CODE and v.AGCD=t.AGCD and v.DPCD=t.DPCD
	)
	)y )z where z.COMP_CODE=@pcompcode 
	and (z.UNIT =@punit or @punit is null or @punit='')
	--and (branch_code =@pbranch or @pbranch is null or @pbranch ='')
	and (z.AGCD =@agcd or @agcd is null or @agcd='')
	and (z.DPCD=@dpcd or @dpcd is null or @dpcd ='')
	group by z.COMP_CODE,z.UNIT,z.AGCD,z.DPCD,z.ALTER_ST,z.ALTER_USER,z.CORRECT_ST,z.CORRECT_USER

*/
/***********/
                                                                     
                                                                     
                                                                     
                                             
alter PROCEDURE [dbo].[cir_ledger_ageing]   
@pcomp_code varchar(20),
@punit_code varchar(20),
@pbran_code varchar(20),
@pzone_code varchar(30),
@pregion_code varchar(30),
@pdist_code varchar(20),
@ptaluka_code varchar(20),
@pagtype      varchar(50),
@pagclass      varchar(50),
@pag_main_code varchar(50),
@pag_sub_code varchar(50),
@paging_by varchar(50),
@pasondt datetime,
@pdebitupto_date datetime,
@pcreditupto_date datetime,
@pdateformat varchar(20),
@puserid varchar(20),
@pextra1 varchar(20),
@pextra2 varchar(20),
@pextra3 varchar(30),
@pextra4 varchar(30),
@pextra5 varchar(50)
As
 
--------- slabs end 
declare  @ptill_days1 as varchar(20)
declare  @ptill_days2 as varchar(20)
declare  @ptill_days3 as varchar(30)
declare  @ptill_days4 as varchar(30)
declare  @ptill_days5 as varchar(50)
declare  @ptill_days6 as varchar(50)
declare  @ptill_current as varchar(50)
----------------  slabs  
declare  @vtodt   as datetime
declare  @vasondt  as datetime     
declare  @v_dt    as datetime
declare  @v_ondt  as datetime
declare  @v_days numeric(10);

declare  @v_pending_rcpt_amt as numeric(14,2) 

declare  @v_amt     as    numeric(14,2);
declare  @v_amt030  as   numeric(14,2);
declare  @v_amt3160 as   numeric(14,2);
declare  @v_amt6190 as   numeric(14,2);
declare  @v_amt91120 as numeric(14,2);
declare  @v_amt121180   as numeric(14,2);
declare  @v_amt181   as numeric(14,2);
declare  @v_amtcur   as numeric(14,2);

declare  @debit_amt_030  as  numeric(14,2)  --debit amt  for slab  1 days
declare  @debit_amt_3160 as  numeric(14,2)  --debit amt  for slab  2 days
declare  @debit_amt_6190 as  numeric(14,2)  --debit amt  for slab  3 days
declare  @debit_amt_91120 as numeric(14,2)  --debit amt  for slab  4 days
declare  @debit_amt_121180  as  numeric(14,2)  --debit amt  for >slab 5 days
declare  @debit_amt_181  as  numeric(14,2)  --debit amt  for >slab 6 days
declare  @debit_amt_cur  as  numeric(14,2)  --debit amt  for >current

declare  @bill_pending_amt as numeric(14,2)
declare  @rcpt_pending_amt  as numeric(14,2) --pending receipt amount

CREATE TABLE #cir_temp_ageing
(
  COMP_CODE     VARCHAR(8),
  UNIT_CODE     VARCHAR(8),
  BRAN_CODE     VARCHAR(8),
  AGCD          VARCHAR(8),
  DPCD          VARCHAR(8),
  AG_NAME       VARCHAR(100),
  CITY_NAME     VARCHAR(100),
  PENDING_AMT   NUMERIC(14,2),
  CUR_AMT        NUMERIC(14,2),
  SLAB_1        NUMERIC(14,2),
  SLAB_2        NUMERIC(14,2),
  SLAB_3        NUMERIC(14,2),
  SLAB_4        NUMERIC(14,2),
  SLAB_5        NUMERIC(14,2),
  SLAB_6        NUMERIC(14,2),
  ON_ACAMT      NUMERIC(14,2),
  RECT_PENDING  NUMERIC(14,2),
  SESSIONID     NUMERIC(14),
  PUBNAME		VARCHAR(200)
)

set @debit_amt_030    =0  --debit amt  for slab  1 days
set @debit_amt_3160   =0  --debit amt  for slab  2 days
set @debit_amt_6190   =0  --debit amt  for slab  3 days
set @debit_amt_91120  =0 --debit amt  for slab  4 days
set @debit_amt_121180 =0  --debit amt  for >slab 4 days
set @debit_amt_181    =0  --debit amt  for >slab 4 days
set @debit_amt_cur    =0  --debit amt  for >current
set @bill_pending_amt =0
set @rcpt_pending_amt =0  --pending receipt amount

-- cursor cur_agency variables
declare @rec_agency_comp_code as varchar(30)
declare @rec_agency_agcd as varchar(20)
declare @rec_agency_dpcd as varchar(30)
declare @rec_agency_agency_name as varchar(300)
declare @rec_agency_city_code as varchar(200)
declare @rec_agency_city_name as varchar(200)
declare @rec_agency_credit_days as int
declare @rec_agency_branch_name as varchar(50)
declare @rec_agency_ageing_type as varchar(1)

--@rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name,@rec_agency_city_code,@rec_agency_city_name,
--@rec_agency_credit_days,@rec_agency_branch_name,@rec_agency_ageing_type
declare cur_agency_1 cursor for	
	select m.Comp_Code ,m.agcd ,m.dpcd ,m.ag_name ,m.City_Code,c.city_name,m.credit_days,m.branch_code,m.ageing_type
	from cir_agmast m,cir_city_mast c
	where m.comp_code=c.comp_code and m.comp_code=@pcomp_code 
	and m.unit=@punit_code and m.city_code=c.city_code 			
	and (m.Dist_Code=@pdist_code or @pdist_code is null or @pdist_code ='') 
	and (m.tehsil_taluka=@ptaluka_code or @ptaluka_code is null or @ptaluka_code ='') 
	and (m.agcd=@pag_main_code or @pag_main_code is null or @pag_main_code ='') 
	and (m.dpcd=@pag_sub_code or @pag_sub_code is null or @pag_sub_code ='')


set @pdebitupto_date =@pasondt
set @pcreditupto_date =@pasondt

open cur_agency_1
		fetch NEXT FROM cur_agency_1 INTO @rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name,@rec_agency_city_code,@rec_agency_city_name,@rec_agency_credit_days,@rec_agency_branch_name,@rec_agency_ageing_type
		WHILE (@@FETCH_STATUS = 0) 
		begin
declare @day as int


	declare cur_agency cursor for
			select distinct publ from cir_supply where comp_code=@pcomp_code and agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd order by publ
			--select distinct  dbo.cir_get_publ_type(comp_code,publ,'C','')  publ from cir_supply where comp_code=@pcomp_code and agcd=@pag_main_code and dpcd=@pag_sub_code order by publ
			
		
declare @fetch_protype as varchar(20)
declare @fetch_pub as varchar(20)

-- cursor v_bill variables
declare @v_bill_billno as varchar(50)
declare @v_bill_billdt as varchar(30)
declare @v_bill_bill_amt as numeric(15,2)

-- cursor v_pending_rcpt variables  
declare @v_pending_rcpt_ag_main_code as varchar(30)
declare @v_pending_rcpt_ag_sub_code as varchar(50)
declare @v_pending_rcpt_amount as numeric(15,2)

declare @fetch_pubname as varchar(200)
declare @fetch_pubtype as varchar(200)

--SELECT 'cursor has ' + CAST(@@CURSOR_ROWS AS VARCHAR) + ' rows'
declare @v_mcnt1 as datetime
declare @v_mcnt2 as datetime
declare @v_mcnt3 as datetime
declare @v_mcnt4 as datetime
declare @v_mcnt5 as datetime
declare  @vtill_days1 AS int
declare  @vtill_days2 AS int
declare  @vtill_days3 AS int
declare  @vtill_days4 AS int
declare  @vtill_days5 AS int
print('@rec_agency_ageing_type')print(@rec_agency_ageing_type)
open cur_agency
		fetch NEXT FROM cur_agency INTO @fetch_pub
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN print('dddddd') print(@fetch_pub)
			
			select distinct @fetch_protype=pro_type,@fetch_pubname=PUBL_NAME,@fetch_pubtype=
			(Select pubname from pub_type_mast where Comp_Code=@pcomp_code and pub_type_mast.pubtypecode=CIR_PUBL_MAST.PRO_TYPE)
			from CIR_PUBL_MAST where COMP_CODE=@pcomp_code and publ=@fetch_pub
			
			print('@fetch_protype')print(@fetch_protype)
			print('@@fetch_pubname')print(@fetch_pubname)
			print('@fetch_pubtype')print(@fetch_pubtype)
			if @fetch_protype ='MA0'
			begin
				set @rec_agency_ageing_type='M'
			end 
			
			select @ptill_days1=SLAB_TILL1,@ptill_days2=SLAB_TILL2,@ptill_days3=SLAB_TILL3,@ptill_days4=SLAB_TILL4
			,@ptill_days5=SLAB_TILL5,@ptill_days6=SLAB_TILL6--,@rec_agency_ageing_type=AGEING_TYPE 
			from CIR_AGEING_SLAB_MAST 
			where COMP_CODE=@pcomp_code and PRO_TYPE=@fetch_protype

print('slab')print(@ptill_days1)print(@ptill_days2)print(@ptill_days3)print(@ptill_days4)print(@ptill_days5)
print(@ptill_days6)print(@rec_agency_ageing_type)

print('gaurav')
print(@rec_agency_ageing_type)
print(@pasondt)
print(dbo.GetLastDayOfMonth(@pasondt))
print('debug')
		if upper(@rec_agency_ageing_type) = 'D' 
		begin
			set @vtodt=dateadd(dd,-1,@pasondt)
		end
		else if upper(@rec_agency_ageing_type) = 'W' 
		begin
			select @day=DATEPART(dw,@pasondt) 
			print(@day)
			set @vtodt=dateadd(dd,-(@day-1),@pasondt)
		end
		else
		begin
			if dbo.GetLastDayOfMonth(@pasondt)=@pasondt 
			begin
				set @vtodt=@pasondt
			end
			else
			begin
			
				set @vtodt=dbo.GetLastDayOfMonth(dateadd(mm,-1,@pasondt))
				
			end
		end
			
print('come')
print(@vtodt)
	
print('custom')print(@ptill_days1)print(@ptill_days2)print(@ptill_days3)print(@ptill_days4)print(@ptill_days5)
			if @rec_agency_ageing_type='M' begin print('gks')
				set @v_mcnt1=DATEADD(MM,-1*@ptill_days1,@vtodt+1)
				set @v_mcnt2=DATEADD(MM,-1*@ptill_days2,@vtodt+1)
				set @v_mcnt3=DATEADD(MM,-1*@ptill_days3,@vtodt+1)
				set @v_mcnt4=DATEADD(MM,-1*@ptill_days4,@vtodt+1)
				set @v_mcnt5=DATEADD(MM,-1*@ptill_days5,@vtodt+1)
				--DATEDIFF(dd, dbo.GetFirstDayOfMonth( @vtodt),@vtodt )+1  
				set @vtill_days1=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt1),@vtodt )+1    
				set @vtill_days2=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt2),@vtodt )+1
				set @vtill_days3=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt3),@vtodt )+1
				set @vtill_days4=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt4),@vtodt )+1
				set @vtill_days5=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt5),@vtodt )+1
			end
			else
			begin
				set @vtill_days1=@ptill_days1
				set @vtill_days2=@ptill_days2
				set @vtill_days3=@ptill_days3
				set @vtill_days4=@ptill_days4
				set @vtill_days5=@ptill_days5
			end
print('custom1')print(@vtill_days1)print(@vtill_days2)print(@vtill_days3)print(@vtill_days4)print(@vtill_days5)
								
	
			
			print @rec_agency_dpcd
			set @debit_amt_030 = 0;
			set @debit_amt_3160 = 0;
			set @debit_amt_6190 = 0;
			set @debit_amt_91120 = 0;
			set @debit_amt_121180 = 0;
			set @debit_amt_181 = 0;
			set @rcpt_pending_amt = 0;
			set @bill_pending_amt = 0;
			print('enter first')
			declare c_bill cursor for
					select distinct billno,billdt,sum(amount) bill_amt from cir_outmast
					where comp_code=@pcomp_code and unit_code=@punit_code and
					agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
					billdt<=@vtodt and  isnull(abs(amount),0)>0
					group by comp_code,billno,billdt having sum(amount)>0
					union all
					select distinct recptno billno,recptdt billdt,sum(amount) bill_amt from cir_outmast
					where comp_code=@pcomp_code and unit_code=@punit_code and
					agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd  and publ=@fetch_pub and
					recptdt<=@vtodt and isnull(amount,0)>0 and billno is null
					group by comp_code,recptno,recptdt order by 2,1
                          
				     --having  sum(amount)<0
					open c_bill
							fetch NEXT FROM c_bill INTO @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt
							WHILE (@@FETCH_STATUS = 0) 
							begin
								print('enter second')
								
								set @v_dt    = @v_bill_billdt
								set @v_ondt  = @vtodt
								
								print(@v_dt)
								print(@v_ondt)
								
								if @paging_by='D' begin
									set @v_days=DATEDIFF(dd, @v_dt,@v_ondt )---isnull(pcrdtday,0)+1;
								end
								else
								begin    
									set @v_days=DATEDIFF(dd, @v_dt,@v_ondt )+1;
								end
								
								if @v_days<0 begin
									set @v_days=0;
								end
								
								print('x')
								print(@v_days)
								set @v_amt               =0;
								set @v_amt030            =0;
								set @v_amt3160           =0;
								set @v_amt6190           =0;
								set @v_amt91120          =0;
								set @v_amt121180         =0;
								set @v_amt181            =0;	

								if @v_days between 0 and @vtill_days1 begin
									select @v_amt030=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0

									set @v_amt030 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt030,0);
									set @debit_amt_030 =isnull(@debit_amt_030,0)+isnull(@v_amt030,0)
								end
								else if @v_days between isnull(@vtill_days1,0)+1 and @vtill_days2 begin
									select @v_amt3160=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt3160 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt3160,0);
									set @debit_amt_3160 =isnull(@debit_amt_3160,0)+isnull(@v_amt3160,0)
								end
								else if @v_days between isnull(@vtill_days2,0)+1 and @vtill_days3 begin
									select @v_amt6190=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt6190 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt6190,0);
									set @debit_amt_6190 =isnull(@debit_amt_6190,0)+isnull(@v_amt6190,0)
								end
								else if @v_days between isnull(@vtill_days3,0)+1 and @vtill_days4 begin
									select @v_amt91120=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt91120 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt91120,0);
									set @debit_amt_91120 =isnull(@debit_amt_91120,0)+isnull(@v_amt91120,0)
								end  
								else if @v_days between isnull(@vtill_days4,0)+1 and @vtill_days5 begin
									select @v_amt121180=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt121180 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt121180,0);
									set @debit_amt_121180 =isnull(@debit_amt_121180,0)+isnull(@v_amt121180,0)
								end        
								else
								begin
									select @v_amt181=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt181 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt181,0);
									set @debit_amt_181 =isnull(@debit_amt_181,0)+isnull(@v_amt181,0)
								end
								

							fetch NEXT FROM c_bill INTO @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt
							end
					close c_bill		
				deallocate c_bill

declare @cur_from_dt as datetime
print('t')	
print(@punit_code)	

print(@fetch_pub)
set @cur_from_dt= dateadd(dd,1,@vtodt)
print(@cur_from_dt)
print(@pasondt)
print('W')
		select @v_amtcur=sum(amount) from cir_outmast 
		where comp_code=@pcomp_code and unit_code=@punit_code and
		agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
		billdt between @cur_from_dt and @pasondt  
		and RECPTNO is null and RECPTDT is null
		--and recptdt<=@pasondt and amount<0
		
		
		select @v_pending_rcpt_amt=sum(amount) from cir_outmast 
        where comp_code=@pcomp_code and unit_code=@punit_code and
          agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
          (billno is null or billdt>@pcreditupto_date) and 
          recptdt<=@pcreditupto_date and 
          doctyp+recptno+cast(recptdt as varchar) not in 
          (select distinct doctyp+recptno+cast(recptdt as varchar) from ad_outstand
           where comp_code=@pcomp_code and unit_code=@punit_code and
                 agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
                 recptdt<=@vtodt and isnull(amount,0)<0 and billno IS NULL)
	
		set @v_amt=isnull(@v_amtcur,0)+ isnull(@debit_amt_030,0)+isnull(@debit_amt_3160,0)+isnull(@debit_amt_6190,0)+isnull(@debit_amt_91120,0)+isnull(@debit_amt_121180,0)+isnull(@debit_amt_181,0)

		if @v_amt=0 begin
			set @debit_amt_030    = 0
			set @debit_amt_3160   = 0
			set @debit_amt_6190   = 0
			set @debit_amt_91120  = 0
			set @debit_amt_121180 = 0
			set @debit_amt_181    = 0
			set @rcpt_pending_amt = 0
		end
		else
		begin
			set @rcpt_pending_amt=isnull(@v_pending_rcpt_amount,0)
			set @bill_pending_amt=isnull(@v_amt,0)
		end
		print('zzz')
		insert into #cir_temp_ageing (comp_code,unit_code,agcd,dpcd,ag_name,
                city_name,pending_amt,CUR_AMT
                , SLAB_1 ,slab_2,slab_3,slab_4,slab_5,slab_6,rect_pending,on_acamt,sessionid,PUBNAME)
        values (@rec_agency_comp_code,@punit_code,@rec_agency_agcd, @rec_agency_dpcd, @fetch_protype,
               @fetch_pubname,isnull(@bill_pending_amt,0),isnull(@v_amtcur,0)
               ,isnull(@debit_amt_030,0),isnull(@debit_amt_3160,0), isnull(@debit_amt_6190,0)
               ,isnull(@debit_amt_91120,0), isnull(@debit_amt_121180,0), isnull(@debit_amt_181,0),
               isnull(@rcpt_pending_amt,0),0,@@spid,@fetch_pubtype);
		print('xxx')
		fetch NEXT FROM cur_agency INTO @fetch_pub
		    set @debit_amt_030    = 0
			set @debit_amt_3160   = 0
			set @debit_amt_6190   = 0
			set @debit_amt_91120  = 0
			set @debit_amt_121180 = 0
			set @debit_amt_181    = 0
			set @rcpt_pending_amt = 0
			set @bill_pending_amt = 0
		end
		
close cur_agency;
deallocate cur_agency


fetch NEXT FROM cur_agency_1 INTO @rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name,@rec_agency_city_code,@rec_agency_city_name,@rec_agency_credit_days,@rec_agency_branch_name,@rec_agency_ageing_type
end
close cur_agency_1		
deallocate cur_agency_1



select comp_code,unit_code,agcd,dpcd,ag_name PRO_TYPE,PUBNAME--,city_name PUBL_NAME
,sum(isnull(pending_amt,0)) pending_amt,sum(isnull(cur_amt,0)) cur_amt,sum(isnull(slab_1,0)) slab_1,sum(isnull(slab_2,0)) slab_2
,sum(isnull(slab_3,0)) slab_3,sum(isnull(slab_4,0)) slab_4,sum(isnull(slab_5,0)) slab_5,sum(isnull(slab_6,0)) slab_6,sum(isnull(rect_pending,0)) rect_pending
from #cir_temp_ageing group by #cir_temp_ageing.COMP_CODE,#cir_temp_ageing.UNIT_CODE,#cir_temp_ageing.AGCD,#cir_temp_ageing.DPCD
,#cir_temp_ageing.AG_NAME,PUBNAME
order by ag_name;
 
drop table #cir_temp_ageing




**************************Rikkee garg sended by Gaurav sir  04/09/12 *****************



alter FUNCTION [dbo].[get_unadj_bill_amount](
@comp_code    varchar(20),
@unit_code    varchar(20),
@bill_no      varchar(50),
@bill_date    datetime,
@dateformate  varchar(50),
@extra1       varchar(20),
@extra2	      varchar(20)) returns float
As
BEGIN
	
			DECLARE @vbillamount  as float
			
			SELECT @vbillamount=SUM(AMOUNT) from CIR_OUTMAST where COMP_CODE=@comp_code 
			AND UNIT_CODE=@unit_code AND BILLNO=@bill_no 
			AND BILLDT=@bill_date
			
			return isnull(@vbillamount,0)
END

*************************end****************************************************

///////////////////////////////////////add by Deepika ////////////////////////////////////////////





alter PROCEDURE [dbo].[cir_get_rates_ofday_p]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@pdate									  varchar(20) ,
	@ppub									  VARCHAR(20) ,
	@pedtn									  VARCHAR(20) ,
	@pdateformat							  VARCHAR(20) 
AS 
Begin
		declare @Day  as varchar(20)
	
		 set @pdate= case @pdateformat when 'dd/mm/yyyy' then convert(varchar(10),@pdate,103)
						  when 'mm/dd/yyyy' then CONVERT(varchar(10),@pdate,101)
						  when 'yyyy/mm/dd' then CONVERT(varchar(10),@pdate,111)
					end
					  
		set @Day =  SUBSTRING(DATENAME(dw, @pdate),1,3) + '_RATE' 

			SELECT PUBL,EDTN,case @Day when  'MON_RATE' THEN MON_RATE
				  WHEN 'TUE_RATE' THEN  TUE_RATE
				  when 'WED_RATE' then WED_RATE
				  WHEN 'THU_RATE' THEN THU_RATE
				  WHEN 'FRI_RATE' THEN FRI_RATE
				  WHEN 'SAT_RATE' THEN SAT_RATE
				  WHEN 'SUN_RATE' THEN SUN_RATE 
			END AS RATE
			FROM  cir_rate_mast 
			WHERE	 comp_code  = @pcomp_code AND	unit  = @punit_code
			and PUBL=@ppub and EDTN=@pedtn
End
	

/////////////////////////////////////////////////////

ALTER PROCEDURE [dbo].[cir_datapos_integration_ag_break]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@pfile_type                               VARCHAR(20) ,-- School S/ Others O		
	@pdateformat                              VARCHAR(20) ,
	@puserid                                  VARCHAR(20) ,
	@pbranch								  VARCHAR(20) ,
	@psup_branch							  VARCHAR(20) ,
	@pextra1                                  VARCHAR(400) , 
	@pextra2                                  VARCHAR(400) ,
	@pextra3                                  VARCHAR(400) ,
	@pextra4                                  VARCHAR(400) ,
	@pextra5                                  VARCHAR(400) ,
	@pextra6                                  VARCHAR(400) 
	
AS 
	if @pfile_type ='S' --stmt_school_[05]_20120701
	begin    	
		select * from CIR_AGmast a where a.COMP_CODE=@pcomp_code
		and isnull(a.DATA_POST,'N')='Y' and a.AG_TYPE='AT004'
		and (BRANCH_CODE=@pbranch)
		and (SUP_BRANCH_CODE=@psup_branch )
	end
	else --stmt_[02]_20120701
	begin
		select * from CIR_AGmast a where a.COMP_CODE=@pcomp_code
		and isnull(a.DATA_POST,'N')='Y' and a.AG_TYPE!='AT004'
		and (BRANCH_CODE=@pbranch)
		and (SUP_BRANCH_CODE=@psup_branch)
	end

///////////////////////////////////////////////////////////

ALTER PROCEDURE [dbo].[cir_datapos_integration_filedata]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@pfile_type                               VARCHAR(20) ,-- School S/ Others O	
	@pfile_name                               VARCHAR(20) ,-- file seq no
	@ptrn_frdt                                datetime ,
	@ptrn_todt                                datetime ,
	@pbg_exp_frdt                             datetime ,
	@pbg_exp_todt                             datetime ,		
	@psec_exp_dt							  datetime ,	
	@pdateformat                              VARCHAR(20) ,
	@puserid                                  VARCHAR(20) ,
	@pbranch								  VARCHAR(20) ,
	@psup_branch							  VARCHAR(20) ,
	@pagcd   						    	  VARCHAR(20) , -- manadatory
	@pdpcd      							  VARCHAR(20) , -- manadatory
	@pextra1                                  VARCHAR(400) , 
	@pextra2                                  VARCHAR(400) ,
	@pextra3                                  VARCHAR(400) ,
	@pextra4                                  VARCHAR(400) ,
	@pextra5                                  VARCHAR(400) ,
	@pextra6                                  VARCHAR(400) 
	
AS 
SET CONCAT_NULL_YIELDS_NULL off

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
	
	declare @v1_issue_date		datetime
	declare @v1_product_code	varchar(20)
	declare @v1_quantity		int
	declare @v1_unit_price		numeric(8,3)
	declare @v1_addr1	varchar(200)
	declare @v1_ADDR2	varchar(200)
	declare @v1_ADDR3	varchar(200)
	declare @v1_PIN_CODE	numeric(10)



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


	set @v_opdate    =dbo.cir_get_finandt(@pcomp_code,@ptrn_frdt,@pdateformat,null,null)--for financial date
	print('%')

	set @v_frdt      =@ptrn_frdt
	set @v_todt      =@ptrn_todt

	CREATE TABLE #CIR_LEDGER_REPORT
	( COMP_CODE      VARCHAR(10),
	  UNIT_CODE      VARCHAR(10),
	  BRANCH_CODE    VARCHAR(10),
	  DOCTYPE        VARCHAR(100),
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
	  NARR_LINE      INT,
	  ISSUE_DATE     DATETIME,
	  PRODUCT        VARCHAR(200),
	  QUANTITY       INT,
	  UNIT_PRICE     NUMERIC(8,3),
	  addr1			 varchar(200),
	  ADDR2			 varchar(200),
	  ADDR3			 varchar(200),
	  PIN_CODE       numeric(10)
	  )

	create table #cir_summary_statement
	(
	comp_code varchar(20),
	unit_code varchar(20),
	PUBL_code varchar(20),
	EDTN_code varchar(20),
	PUBL_NAME varchar(200),
	EDTN_NAME varchar(200),
	AGCD varchar(20),
	DPCD varchar(20),
	INV_QTY  numeric(12),
	INV_AMT  numeric(14,2),
	RET_QTY  numeric(12),
	RET_AMT  numeric(14,2),
	INSERT_LATE numeric(14,2),
	REMARK    varchar(200),
	TOTAL numeric(14,2),
	line_no varchar(3)

	)	

declare @sum_ag_comp_code as varchar(20)
declare @sum_ag_unit as varchar(20)
declare @sum_ag_agcd as varchar(20)
declare @sum_ag_dpcd as varchar(20)
declare @sum_ag_ag_name	 as varchar(200)
declare @sum_publ_publ	 as varchar(200)
declare @sum_edtn	 as varchar(200)
declare @sum_edtn_name	 as varchar(200)

declare @v_invqty as numeric(12)
declare @v_invamt as numeric(14,2)
declare @v_retqty as numeric(12)
declare @v_retamt as numeric(14,2)
declare @v_late_ins as numeric(14,2)
declare @v_publ_tot as numeric(14,2)
declare @v_payment as  numeric(14,2)

declare @v_dn_chq as numeric(14,2)					
declare @v_dn_nom as numeric(14,2)					
declare @v_cn as numeric(14,2)
declare @v_tot_inv as numeric(14,2)
declare @v_tot_ucn as numeric(14,2)
declare @v_close_bal as numeric(14,2)

		DECLARE @vtrn_frdt      DATETIME 
		DECLARE @vtrn_todt      DATETIME 
		DECLARE @vbgexp_frdt    DATETIME 
		DECLARE @vbgexp_todt    DATETIME 
		DECLARE @vsec_expdt     DATETIME 
     	SET @vtrn_frdt  =  @ptrn_frdt--dbo.convert_user_date('/',@pfrdt,@pdateformat)
     	SET @vtrn_todt  =  @ptrn_todt--dbo.convert_user_date('/',@ptodt,@pdateformat)
     	SET @vbgexp_frdt  =  @pbg_exp_frdt--dbo.convert_user_date('/',@pfrdt,@pdateformat)
     	SET @vbgexp_todt  =  @psec_exp_dt--dbo.convert_user_date('/',@ptodt,@pdateformat)
     	SET @vsec_expdt  =  @psec_exp_dt--dbo.convert_user_date('/',@pfrdt,@pdateformat)
     	
     	declare @xlen as int
     	declare @xmon as int
     	declare @xlen_str as varchar(10)
     	set @xmon=len(DATENAME(MM, @vtrn_frdt) + ' ' + CAST(YEAR(@vtrn_frdt) AS VARCHAR(4)))
     	set @xlen = round(cast((20-@xmon)/2 as int) ,0) 
     	print('%')print(@xlen) print(len(DATENAME(MM, @vtrn_frdt) + ' ' + CAST(YEAR(@vtrn_frdt) AS VARCHAR(4))))
	 while @xlen >0
	 begin
		set @xlen_str=@xlen_str+'~'
		set @xlen =@xlen-1
	 end 
     print('T')print(@xlen_str)	



	if CAST(@pfile_name as int) < 10
	begin
		set @pfile_name='0'+@pfile_name
	end
	if @pfile_type ='S' --stmt_school_[05]_20120701
	begin    	
		select 'stmt_school_['+@pfile_name+']_'+CONVERT(VARCHAR(8), dbo.GetFirstDayOfMonth(@vtrn_frdt),112) as "file_name"
	end
	else --stmt_[02]_20120701
	begin
		select 'stmt_['+@pfile_name+']_'+CONVERT(VARCHAR(8), dbo.GetFirstDayOfMonth(@vtrn_frdt),112) as "file_name"
	end

	select dbo.fnPadright(' ',141,'000 '+substring(AGCD,4,len(AGCD)))+'*' as "1",
	dbo.fnPadright(' ',141,'001 '+substring(AGCD,4,len(AGCD)) +' '+ag_name )+'*' as "2",
	dbo.fnPadright(' ',141,'002 '+substring(AGCD,4,len(AGCD)) +' '+ case isnull(ADDR1,'') when '' then '~' when null then '~' else isnull(ADDR1,'') end )+'*' as "3",
	dbo.fnPadright(' ',141,'003 '+substring(AGCD,4,len(AGCD)) +' '+case isnull(ADDR2,'') when '' then '~' when null then '~' else isnull(ADDR2,'') end )+'*'  as "4" 
	,
	dbo.fnPadright(' ',31,'004 '+substring(AGCD,4,len(AGCD)) +' '+
	case isnull(cast(PIN_CODE as varchar),'') when '' then '~' else cast(PIN_CODE as varchar) end +' '+
	case isnull(ADDR3,'') when '' then '~' else isnull(ADDR3,'') end ) as "5_1",
	dbo.fnPadright(' ',110,'M2u Online Payment : '+ case isnull(branch_code,'') when '' then '~' else branch_code end + substring(AGCD,4,len(AGCD)) )+'*' as "5_2",
	dbo.fnPadright(' ',141,'005 '+substring(AGCD,4,len(AGCD)) +' '+case isnull(dbo.cir_get_state(@pcomp_code,country_code,state_code),'') when '' then '~' else isnull(dbo.cir_get_state(@pcomp_code,country_code,state_code),'') end )+'*'  as "6",
	dbo.fnPadright(' ',141,'006 '+substring(AGCD,4,len(AGCD)) +' Attn : '+case isnull(dbo.cir_get_contact_person(@pcomp_code,AGCD,@pdpcd),'') when '' then '~' else isnull(dbo.cir_get_contact_person(@pcomp_code,AGCD,@pdpcd),'') end ) +'*' as "7",
	dbo.fnPadright(' ',141,'007 '+substring(AGCD,4,len(AGCD)) +' '
	+@xlen_str + upper(DATENAME(MM, @vtrn_frdt)) + ' ' + CAST(YEAR(@vtrn_frdt) AS VARCHAR(4))+' SUMMARY' ) + '*' as "8",
	dbo.fnPadright(' ',141,'008 '+substring(AGCD,4,len(AGCD)) +' '+CONVERT(VARCHAR(11), GETDATE(), 106) +  ' '+
	case isnull(BRANCH_CODE,'') when '' then '~' else  isnull(BRANCH_CODE,'') end + ' ' +
	case isnull(UNIT,'') when '' then '~' else  isnull(UNIT,'') end 
	)+'*' as "9"	
	from CIR_AGMAST where COMP_CODE=@pcomp_code and AGCD=@pagcd and DPCD=@pdpcd
	----------------------------------  for account summary -----------------------------------
	declare sum_ag cursor for
			select distinct comp_code,unit,agcd,dpcd,ag_name from cir_agmast  
			where comp_code = @pcomp_code 
			/*and agcd+dpcd in(select distinct agcd+dpcd from cir_outmast 
							where comp_code = @pcomp_code and (unit_code=@punit_code or @punit_code is null) and achd='NM') */
			and (agcd=@pagcd or @pagcd is null) 
			and (dpcd=@pdpcd or @pdpcd is null)
			order by comp_code,unit,ag_name;
	
	
			open sum_ag
				fetch NEXT FROM sum_ag INTO @sum_ag_comp_code,@sum_ag_unit,@sum_ag_agcd,@sum_ag_dpcd,@sum_ag_ag_name
				WHILE (@@FETCH_STATUS = 0) Begin
					set @v_opbal=0
					set @v_opbal =dbo.cir_accounts_cir_agency_opbal(@pcomp_code, @punit_code,null,@sum_ag_agcd, @sum_ag_dpcd, @v_opdate, 'NM',@pdateformat,null,null)
					set @v_dbcramt=0					

							select @v_billamt=sum(amount) from cir_outmast
								where comp_code = @pcomp_code and unit_code=@punit_code and 
									agcd=@sum_ag_agcd and dpcd=@sum_ag_dpcd and billdt >= @v_opdate and billdt<@v_frdt and 
									achd='NM' and recptno is null

							select @v_dbcramt=sum(amount) from cir_rcpdet
								where comp_code=@pcomp_code and unit_code=@punit_code and 
									agcd=@sum_ag_agcd and dpcd=@sum_ag_dpcd and recptdt>= @v_opdate and recptdt<@v_frdt and 
									achd='NM' and billno is null

							set @v_opbal=isnull(@v_opbal,0)+isnull(@v_billamt,0)+isnull(@v_dbcramt,0)
			------------------  insert BF ----------------
			insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
						AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL,line_no)	
			values (@sum_ag_comp_code,@sum_ag_unit,null,null,'Balance B/F',null,@sum_ag_agcd,@sum_ag_dpcd
					,null,null,null,null,null,'Balance B/F',@v_opbal,'010')
			---------------------------------------------		
					declare sum_publ cursor for
						select distinct  publ,pro_type,publ_name from cir_publ_mast
						where comp_code = @pcomp_code --and (unit_code=@punitcode or @punitcode is null) 
						order by pro_type
						set @v_close_bal=@v_opbal
						set @v_tot_inv =0
						set @v_tot_ucn =0
			print('@v_close_bal0')print(@v_close_bal)
						open sum_publ
							fetch NEXT FROM sum_publ INTO @sum_publ_publ,@sum_edtn,@sum_edtn_name
							WHILE (@@FETCH_STATUS = 0) Begin
								select @v_invqty=SUM(isnull(bill_copy,0))
								,@v_invamt=sum(isnull(bill_amount,0))								
								from cir_bill where COMP_CODE=@sum_ag_comp_code
								and UNIT_CODE=@sum_ag_unit and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd
								and BILLDT between @v_frdt and @v_todt and PUBL=@sum_publ_publ 
								
								select @v_retqty=sum(ISNULL(APR_BNR,0))+sum(ISNULL(APR_DAMAGE,0))+sum(ISNULL(APR_LATE_RECPT,0))+
								sum(ISNULL(APR_SHORT_RECPT,0))+sum(ISNULL(APR_UNSOLD,0)) 
								,@v_retamt =SUM(isnull(copy_amt,0)) from CIR_UNSOLD_DTL 
								where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
								and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and PUBL=@sum_publ_publ 
								and APP_DT between @v_frdt and @v_todt
								and (PROCESS_CRNO is not null or PROCESS_CRNO!='')
								and (PROCESS_CRDT is not null or PROCESS_CRDT!='')
								
								select @v_late_ins=SUM(isnull(abs(AMOUNT),0)) from cir_rcphdr 
								where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
								and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and PUBL=@sum_publ_publ 
								and RECPTDT between @v_frdt and @v_todt
								
								set @v_publ_tot=isnull(@v_invamt,0)+(-1*ISNULL(@v_retamt,0))+(-1*ISNULL(@v_late_ins,0))
								------------------  insert product summary ----------------
								if isnull(@v_invamt ,0) !=0 or isnull(@v_retamt ,0) !=0 or isnull(@v_late_ins ,0) !=0
								begin
									insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
												AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL,line_no)	
									values (@sum_ag_comp_code,@sum_ag_unit,@sum_publ_publ,@sum_edtn,@sum_edtn_name,null,@sum_ag_agcd,@sum_ag_dpcd
											,@v_invqty,@v_invamt,@v_retqty,@v_retamt,@v_late_ins,@sum_edtn_name,@v_publ_tot,'011')
								set @v_close_bal=	@v_close_bal+(@v_publ_tot)
								set @v_tot_inv =@v_tot_inv+@v_invamt
								set @v_tot_ucn =@v_tot_ucn+@v_retamt
								end
								---------------------------------------------	
								
								print('@v_close_bal1')print(@v_close_bal)
							fetch NEXT FROM sum_publ INTO @sum_publ_publ,@sum_edtn,@sum_edtn_name
							End

						close sum_publ
						deallocate sum_publ
print('@v_close_bal_p')print(@v_close_bal)print(@v_tot_inv)print(@v_tot_ucn)print('OOO')
					------------------------ just for  total----------------
					if isnull(@v_tot_inv ,0) !=0 or isnull(@v_tot_ucn ,0) !=0 
					begin
						insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
									AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL,line_no)	
						values (@sum_ag_comp_code,@sum_ag_unit,null,null,null,null,@sum_ag_agcd,@sum_ag_dpcd
								,null,@v_tot_inv,null,@v_tot_ucn,null,'~',0,'012')
					end
					
					select @v_dn_chq=SUM(isnull(abs(amount),0)) from CIR_RCPHDR 
					where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
					and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and DOCTYPE='DN' and REASON='CH0'					
					and RECPTDT between @v_frdt and @v_todt
									
					------------------  insert DN CHQ Bounce summary ----------------
					if isnull(@v_dn_chq ,0) !=0 
					begin
						insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
							AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL,line_no)	
						values (@sum_ag_comp_code,@sum_ag_unit,null,null,'CHEQUE BOUNCED',null,@sum_ag_agcd,@sum_ag_dpcd
								,null,null,null,null,null,'CHEQUE BOUNCED',@v_dn_chq,'013')
					set @v_close_bal=	@v_close_bal+(@v_dn_chq)
					end
					
					---------------------------------------------	
					print('@v_close_bal2')print(@v_close_bal)
					select @v_dn_nom=SUM(isnull(abs(amount),0)) from CIR_RCPHDR 
					where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
					and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and DOCTYPE='DN' and REASON!='CH0'					
					and RECPTDT between @v_frdt and @v_todt
									
					------------------  insert DN summary ----------------
					if isnull(@v_dn_nom ,0) !=0 
					begin
						insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
							AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL,line_no)	
						values (@sum_ag_comp_code,@sum_ag_unit,null,null,'DEBIT NOTE',null,@sum_ag_agcd,@sum_ag_dpcd
								,null,null,null,null,null,'DEBIT NOTE',@v_dn_nom,'014')
					set @v_close_bal=	@v_close_bal+(@v_dn_nom)
					end
					
					---------------------------------------------	
					print('@v_close_bal3')print(@v_close_bal)
					select @v_cn=SUM(isnull(abs(amount),0)) from CIR_RCPHDR 
					where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
					and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and DOCTYPE='CN'					
					and RECPTDT between @v_frdt and @v_todt
									
					------------------  insert CN summary ----------------
					if isnull(@v_cn ,0) !=0 
					begin
						insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
							AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL,line_no)	
						values (@sum_ag_comp_code,@sum_ag_unit,null,null,'CREDIT NOTE',null,@sum_ag_agcd,@sum_ag_dpcd
								,null,null,null,null,null,'CREDIT NOTE',@v_cn,'015')
					set @v_close_bal=	@v_close_bal+(-1*@v_cn)
					end
					
					---------------------------------------------
					print('@v_close_bal4')print(@v_close_bal)
					select @v_payment=SUM(isnull(abs(amount),0)) from CIR_RCPHDR 
					where COMP_CODE=@sum_ag_comp_code and UNIT_CODE=@sum_ag_unit 
					and AGCD=@sum_ag_agcd and DPCD=@sum_ag_dpcd and DOCTYPE='RCR'					
					and RECPTDT between @v_frdt and @v_todt
									
					------------------  insert PAYMENT summary ----------------
					if isnull(@v_payment ,0) !=0 
					begin
						insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
							AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL,line_no)	
						values (@sum_ag_comp_code,@sum_ag_unit,null,null,'PAYMENT',null,@sum_ag_agcd,@sum_ag_dpcd
								,null,null,null,null,null,'PAYMENT',@v_payment,'016')
					set @v_close_bal=	@v_close_bal+(-1*@v_payment)
					end
					
					---------------------------------------------
					print('@v_close_bal')print(@v_close_bal)
					--if isnull(@v_close_bal ,0) !=0 
					--begin
						insert into #cir_summary_statement(comp_code,unit_code,PUBL_code,EDTN_code,PUBL_NAME,EDTN_NAME,
							AGCD,DPCD,INV_QTY,INV_AMT,RET_QTY,RET_AMT,INSERT_LATE,REMARK,TOTAL,line_no)	
						values (@sum_ag_comp_code,@sum_ag_unit,null,null,'BALANCE C/F',null,@sum_ag_agcd,@sum_ag_dpcd
								,null,null,null,null,null,'BALANCE C/F',@v_close_bal,'017')
					--end
		
				fetch NEXT FROM sum_ag INTO @sum_ag_comp_code,@sum_ag_unit,@sum_ag_agcd,@sum_ag_dpcd,@sum_ag_ag_name
				End

			close sum_ag
			deallocate sum_ag

	 --select * from #cir_summary_statement
	 select replace(z."1",'~',' ')+replace(z."2",'~',' ')+replace(z."3",'~',' ')
	 +replace(z."4",'~',' ')+replace(z."5",'~',' ')+replace(z."6",'~',' ')+replace(z."7",'~',' ') +'*'  as data from 
	(select line_no+' '+substring(AGCD,4,len(AGCD))+' '+ dbo.fnPadright('~',30,remark ) as "1"
	, dbo.fnPadLeft('~',14,isnull(cast(INV_QTY as varchar),'~')) as "2"
	, dbo.fnPadLeft('~',14,isnull(cast(INV_AMT as varchar),'~')) as "3"
	, dbo.fnPadLeft('~',14,isnull(cast(RET_QTY as varchar),'~')) as "4"
	, dbo.fnPadLeft('~',14,isnull(cast(RET_AMT as varchar),'~')) as "5"
	, dbo.fnPadLeft('~',14,isnull(cast(INSERT_LATE as varchar),'~')) as "6"
	, dbo.fnPadLeft('~',14,cast(TOTAL as varchar))+'~~~~~~~~~~~~~~~~~' as "7"
	 from #cir_summary_statement) z
	 -----------------------------------  for ageing  -------------------------------------------------------
	CREATE TABLE #cir_temp_ageing
	(
		COMP_CODE     VARCHAR(8),
		UNIT_CODE     VARCHAR(8),
		BRAN_CODE     VARCHAR(8),
		AGCD          VARCHAR(8),
		DPCD          VARCHAR(8),
		AG_NAME       VARCHAR(100),
		CITY_NAME     VARCHAR(100),
		PENDING_AMT   NUMERIC(14,2),
		CUR_AMT        NUMERIC(14,2),
		SLAB_1        NUMERIC(14,2),
		SLAB_2        NUMERIC(14,2),
		SLAB_3        NUMERIC(14,2),
		SLAB_4        NUMERIC(14,2),
		SLAB_5        NUMERIC(14,2),
		SLAB_6        NUMERIC(14,2),
		ON_ACAMT      NUMERIC(14,2),
		RECT_PENDING  NUMERIC(14,2),
		SESSIONID     NUMERIC(14),
		PUBNAME		VARCHAR(200),
		ageing		varchar(1)
	)
	 
	--exec cir_ledger_ageing @pcomp_code='UM001',@punit_code='BA0',@pbran_code='',@pzone_code=''
	--,@pregion_code='',@pdist_code='',@ptaluka_code='',@pagtype='',@pagclass='',@pag_main_code='BA100003'
	--,@pag_sub_code='0001',@paging_by='',@pdebitupto_date=NULL,@pcreditupto_date=NULL,@pasondt='09/10/2012'
	--,@puserid='',@pdateformat='dd/mm/yyyy',@pextra1='',@pextra2='',@pextra3='',@pextra4='',@pextra5=''

	 insert into #cir_temp_ageing select * from dbo.cir_ledger_ageing_datapos
	 (@pcomp_code,@punit_code,'','','','','','','',@pagcd,@pdpcd,'',null,null,@ptrn_todt,@puserid,@pdateformat
	 ,@pextra1,@pextra2,@pextra3,@pextra4,@pextra5 )
	

	select '020 '+substring(@pagcd,4,len(@pagcd))+'       >=6 MTHS      4-5 MTHS        3 MTHS        2 MTHS         1 MTH       CURRENT     TOTAL DUE                                 *' as data
	union all
	select 	'021 '+substring(x.agcd,4,len(x.agcd))+'       ' 
	+ dbo.fnPadLeft('~',8,isnull(cast(x.slab_5 as varchar),'~')) +'~~~~~~'
	+ dbo.fnPadLeft('~',8,isnull(cast(x.slab_4 as varchar),'~')) +'~~~~~~'
	+ dbo.fnPadLeft('~',8,isnull(cast(x.slab_3 as varchar),'~')) +'~~~~~~'
	+ dbo.fnPadLeft('~',8,isnull(cast(x.slab_2 as varchar),'~')) +'~~~~~~'
	+ dbo.fnPadLeft('~',8,isnull(cast(x.slab_1 as varchar),'~')) +'~~~~~~'
	+ dbo.fnPadLeft('~',8,isnull(cast(x.cur_amt as varchar),'~')) +'~~~~~~'
	+ dbo.fnPadLeft('~',8,isnull(cast(ISNULL(x.pending_amt,0)-(ISNULL(x.rect_pending,0)) as varchar),'~'))+'~~~~~~'+'                           *' as data
	from
	(select comp_code,unit_code,agcd,dpcd,ag_name PRO_TYPE,PUBNAME--,city_name PUBL_NAME
	,sum(isnull(pending_amt,0)) pending_amt,sum(isnull(cur_amt,0)) cur_amt,sum(isnull(slab_1,0)) slab_1,sum(isnull(slab_2,0)) slab_2
	,sum(isnull(slab_3,0)) slab_3,sum(isnull(slab_4,0)) slab_4,sum(isnull(slab_5,0)) slab_5,sum(isnull(slab_6,0)) slab_6,sum(isnull(rect_pending,0)) rect_pending
	,ageing from #cir_temp_ageing 
	group by #cir_temp_ageing.COMP_CODE,#cir_temp_ageing.UNIT_CODE,#cir_temp_ageing.AGCD,#cir_temp_ageing.DPCD
	,#cir_temp_ageing.AG_NAME,PUBNAME,ageing ) x where x.PRO_TYPE='NE0'
	union all
	select '022 '+substring(@pagcd,4,len(@pagcd))+'       >=6 MTHS      4-5 MTHS        3 MTHS        2 MTHS         1 MTH       CURRENT     TOTAL DUE                                 *' as data
	union all
	select 	'023 '+substring(x.agcd,4,len(x.agcd))+'       ' 
	+ dbo.fnPadLeft('~',8,isnull(cast(x.slab_5 as varchar),'~')) +'~~~~~~'
	+ dbo.fnPadLeft('~',8,isnull(cast(x.slab_4 as varchar),'~')) +'~~~~~~'
	+ dbo.fnPadLeft('~',8,isnull(cast(x.slab_3 as varchar),'~')) +'~~~~~~'
	+ dbo.fnPadLeft('~',8,isnull(cast(x.slab_2 as varchar),'~')) +'~~~~~~'
	+ dbo.fnPadLeft('~',8,isnull(cast(x.slab_1 as varchar),'~')) +'~~~~~~'
	+ dbo.fnPadLeft('~',8,isnull(cast(x.cur_amt as varchar),'~')) +'~~~~~~'
	+ dbo.fnPadLeft('~',8,isnull(cast(ISNULL(x.pending_amt,0)-(ISNULL(x.rect_pending,0)) as varchar),'~'))+'~~~~~~'+'                           *' as data
	from
	(select comp_code,unit_code,agcd,dpcd,ag_name PRO_TYPE,PUBNAME--,city_name PUBL_NAME
	,sum(isnull(pending_amt,0)) pending_amt,sum(isnull(cur_amt,0)) cur_amt,sum(isnull(slab_1,0)) slab_1,sum(isnull(slab_2,0)) slab_2
	,sum(isnull(slab_3,0)) slab_3,sum(isnull(slab_4,0)) slab_4,sum(isnull(slab_5,0)) slab_5,sum(isnull(slab_6,0)) slab_6,sum(isnull(rect_pending,0)) rect_pending
	,ageing from #cir_temp_ageing 
	group by #cir_temp_ageing.COMP_CODE,#cir_temp_ageing.UNIT_CODE,#cir_temp_ageing.AGCD,#cir_temp_ageing.DPCD
	,#cir_temp_ageing.AG_NAME,PUBNAME,ageing ) x where x.PRO_TYPE='MA0'
	union all
	select '024 '+substring(@pagcd,4,len(@pagcd))+'                                                                                               0.00                                 *' as data
	union all
	select 	'025 '+substring(x.agcd,4,len(x.agcd))+'                                                                                           ' 
	+ dbo.fnPadLeft('~',8,isnull(cast(sum(ISNULL(x.pending_amt,0))-(sum(ISNULL(x.rect_pending,0))) as varchar),'~'))+'~~~~~~'+'                           *' as data
	from
	(select comp_code,unit_code,agcd,dpcd,ag_name PRO_TYPE,PUBNAME--,city_name PUBL_NAME
	,sum(isnull(pending_amt,0)) pending_amt,sum(isnull(cur_amt,0)) cur_amt,sum(isnull(slab_1,0)) slab_1,sum(isnull(slab_2,0)) slab_2
	,sum(isnull(slab_3,0)) slab_3,sum(isnull(slab_4,0)) slab_4,sum(isnull(slab_5,0)) slab_5,sum(isnull(slab_6,0)) slab_6,sum(isnull(rect_pending,0)) rect_pending
	,ageing from #cir_temp_ageing 
	group by #cir_temp_ageing.COMP_CODE,#cir_temp_ageing.UNIT_CODE,#cir_temp_ageing.AGCD,#cir_temp_ageing.DPCD
	,#cir_temp_ageing.AG_NAME,PUBNAME,ageing ) x group by '025 '+substring(x.agcd,4,len(x.agcd))
	union all
	select 	'026 '+substring(@pagcd,4,len(@pagcd))+'         0.00        0.00                                                                                                           *' as data
	union all
	select '030 '+substring(@pagcd,4,len(@pagcd))+'                                                                                                                                    *' as data
	
	--------------------------------- for statement detail -----------------------------------------------------------
	declare c1 cursor for
				select distinct comp_code,unit,agcd,dpcd,ag_name,ag_name_oth_lang,city_code,tehsil_taluka,dist_code,state_code,
					country_code,branch_code,addr1,ADDR2,ADDR3,PIN_CODE from cir_agmast 
						where comp_code = @pcomp_code and (unit=@punit_code or @punit_code is null) /*and 
									agcd+dpcd in(select distinct agcd+dpcd from cir_outmast 
									where comp_code = @pcomp_code and (unit_code=@punit_code or @punit_code is null) and achd='NM') */and 
									(agcd=@pagcd or @pagcd is null) and (dpcd=@pdpcd or @pdpcd is null) 
									order by branch_code,city_code,ag_name;
declare @v1_commrate as numeric(14,2)		  

			open c1
				fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit,@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_name_oth_lang,@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,@v1_country_code,@v1_branch_code,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE
				WHILE (@@FETCH_STATUS = 0)  Begin
				set @v_opbal =dbo.cir_accounts_cir_agency_opbal(@pcomp_code, @punit_code,null,@v1_agcd, @v1_dpcd, @v_opdate, 'NM',@pdateformat,null,null)
		print('@')
				----for secutiry outstanding---
			/*	If @pactype='SC' Begin
					set @v_opbal_sec	=dbo.cir_accounts_cir_agency_opbal(@pcompcode, @punitcode,null,@v1_agcd,@v1_dpcd,@v_opdate,'SC',@pdateformat,null,null)

					select @v_dbcramt	=sum(amount) from cir_rcphdr
					where comp_code = @pcompcode and unit_code= @punitcode and 
						agcd=@v1_agcd and dpcd=@v1_dpcd and recptdt>= @v_opdate and recptdt<=@v_todt and achd='SC'

					set @v_opbal_sec=isnull(@v_opbal_sec,0)+isnull(@v_dbcramt,0)
				End
				Else Begin
					set @v_opbal_sec =0
				End
				
				insert into #cir_ledger_report
					(comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
					exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
					billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line
					,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE)
				values(@v1_comp_code,@v1_unit,@v1_branch_code,@v1_agcd,@v1_dpcd,null,null,@v_frdt,@v_opbal_sec,
					null,'Security Balance',null,null,null,null,null,null,
					null,null,null,null,null,@v1_ag_name,@v_rec_seqno,1,null,null,null,null,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE)

				set @v_rec_seqno = isnull(@v_rec_seqno,0)+1
				
			*/
				----for secutiry outstanding---
				set @v_dbcramt=0

				select @v_billamt=sum(amount) from cir_outmast
					where comp_code = @pcomp_code and unit_code=@punit_code and 
						agcd=@v1_agcd and dpcd=@v1_dpcd and billdt >= @v_opdate and billdt<@v_frdt and 
						achd='NM' and recptno is null

				select @v_dbcramt=sum(amount) from cir_rcpdet
					where comp_code=@pcomp_code and unit_code=@punit_code and 
						agcd=@v1_agcd and dpcd=@v1_dpcd and recptdt>= @v_opdate and recptdt<@v_frdt and 
						achd='NM' and billno is null

				set @v_opbal=isnull(@v_opbal,0)+isnull(@v_billamt,0)+isnull(@v_dbcramt,0)

				set @v_rec_seqno=isnull(@v_rec_seqno,0)+1

				set @v_runbal = @v_opbal
		            
				If @v_runbal>=0 Begin
					set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), @v_runbal ))--+' Dr.'
				End
				Else Begin
					set @v_runbal_txt= '('+ CONVERT(VARCHAR, CONVERT( numeric(14, 2), @v_runbal )) + ')'--+' Cr.'
				End
		            
				insert into #cir_ledger_report
					(comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
					exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
					billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE)
				values(@v1_comp_code,@v1_unit,@v1_branch_code,@v1_agcd,@v1_dpcd,null,null,@v_frdt,@v_opbal,
					null,'Balance B/F',null,null,null,null,null,null,
					null,null,null,null,null,@v1_ag_name,@v_rec_seqno,2,null,null,null,null,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE)
		 
		 print('set')print(@v1_unit)print(@v1_agcd) print(@v1_dpcd) print(@v_frdt) print(@v_todt)     

				declare c2 cursor for
					select u.comp_code comp_code,u.unit_code unit_code,u.agcd agcd,u.dpcd dpcd,u.doctype doctype,u.recptno recptno,u.recptdt recptdt,u.amount amount,u.chno chno,u.chdt chdt,u.chbank chbank,u.reason reason,
					u.narration narration,u.received_from received_from from 
					(select comp_code,unit_code,agcd,dpcd,doctype,recptno,recptdt,amount,chno,chdt,chbank,reason,remark narration,received_from from cir_rcphdr
						where comp_code=@v1_comp_code and unit_code=@v1_unit and agcd=@v1_agcd and dpcd=@v1_dpcd and recptdt 
							between @v_frdt and @v_todt and case isnull( achd,'NM')  when '' then 'NM' else achd end='NM'
					union all
					select comp_code,unit_code,agcd,dpcd,'BIL' doctype,billno recptno,billdt recptdt,sum(bill_amount) amount,null chno,null chdt,null chbnk,'BILL' reason,
					'Bill Copy '+ cast(sum(bill_copy) as VARCHAR)+' Trade Disc. '+cast(sum(comm_amount) as VARCHAR) narration,null received_from from cir_bill
						where comp_code=@v1_comp_code and unit_code=@v1_unit and agcd=@v1_agcd and dpcd=@v1_dpcd and 
							billdt between @v_frdt and @v_todt and ('NM'='NM' or 'NM' is null or 'NM' ='')
							group by comp_code,unit_code,agcd,dpcd,billno,billdt
					/*union all
					select comp_code,unit_code,agcd,dpcd,doctyp doctype,billno recptno,billdt recptdt,sum(amount) amount,null chno,null chdt,null chbnk, reason,
					remark narration,null received_from from cir_outmast
						where comp_code=@v1_comp_code and unit_code=@v1_unit and agcd=@v1_agcd and dpcd=@v1_dpcd and 
							billdt between @v_frdt and @v_todt and @pactype='NM' and isnull(amount,0)>0 and billno is null 
							group by comp_code,unit_code,agcd,dpcd,billno,billdt,doctyp,reason,remark		*/
							)u
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
									select distinct @v1_issue_date=TODT,@v1_product_code=PUBL,@v1_quantity=sum(BILL_COPY)
									,@v1_unit_price=COPY_RATE,@v1_commrate=COMM_RATE  from cir_bill_det
									where COMP_CODE=@pcomp_code and UNIT_CODE=@v2_unit_code and BILLNO=@v2_recptno 
									and AGCD=@v2_agcd and DPCD=@v2_dpcd
									group by TODT,PUBL,COPY_RATE,COMM_RATE
								End
								Else 
								Begin
										set @v1_issue_date=null
										set @v1_product_code=null
										set @v1_quantity=null
										set @v1_unit_price=null
										set @v1_commrate=null
									If @v2_narration is not null 
									Begin
										set @v_narration=@v2_narration
													
										If @v2_chno is not null and @v2_chno !=''
										Begin
											set @v_narration=@v_narration+' CHNO# '+@v2_chno
										End
										If @v2_chdt is not null and @v2_chdt !=''
										Begin
											set @v_narration=@v_narration+' CHDT '+ cast(@v2_chdt as varchar)
										End
										If @v2_chbank is not null and @v2_chbank !=''
										Begin
											set @v_narration=@v_narration+' CHBNK '+@v2_chbank
										End
										If @v2_reason='CA0' and @v2_doctype='RCR' 
										Begin
											set @v_narration='By Cash '+@v_narration
										End
									End
								End
						End	
						Else 
						Begin print('test')
							If @v2_chno is not null and @v2_chno !=''
							Begin
								set @v_narration='CHNO# '+@v2_chno
							End
							If @v2_chdt is not null  and @v2_chdt !=''
							Begin
								set @v_narration =@v_narration+' CHDT '+ DBO.convert_user_date('/',@v2_chdt,@pdateformat)  
							End
							If @v2_chbank is not null  and @v2_chbank !=''
							Begin
								set @v_narration=@v_narration+' CHBANK '+@v2_chbank
							End
							If @v2_reason='CA0' and @v2_doctype='RCR' 
							Begin
								set @v_narration='By Cash '+@v_narration
							End
						End

					set @v_remark_len = LEN(ISNULL(LTRIM(RTRIM(@v_narration)), '-'))
					set @v_amt=isnull(@v_amt,0)+isnull(@v2_amount,0)
					                    

					set @v_runbal = @v_runbal+isnull(@v2_amount,0)

					If @v_runbal>=0 Begin
						set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), @v_runbal ))--+' Dr.'
					End
					Else Begin
						set @v_runbal_txt= '('+CONVERT(VARCHAR, CONVERT( numeric(14, 2), abs(@v_runbal) ))+')'--+' Cr.'
					End
					                                        
					If isnull(@v2_amount,0)>=0 Begin
						set @v_dbamt=isnull(@v_dbamt,0)+isnull(@v2_amount,0)
					End
					If isnull(@v2_amount,0)<0 Begin
						set @v_cramt=isnull(@v_cramt,0)+abs(isnull(@v2_amount,0))
					End

		set @v1_unit_price=round(@v1_unit_price-((isnull(@v1_unit_price,0)*isnull(@v1_commrate,1))/100),3)			
					
		print('#')	
		print(@v_remark_len)
		print(@v_divident)		
					insert into #cir_ledger_report
						  (comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
						  exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
						  billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line
						  ,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE)
					  values(@v1_comp_code, @v1_unit, @v1_branch_code, @v1_agcd, @v1_dpcd, @v2_doctype, @v2_recptno, @v2_recptdt, @v2_amount,
							 @v2_received_from,isnull(ltrim(rtrim(@v_narration)),'-'), @v2_chno, @v2_chdt, @v2_chbank, @v2_reason,null, @v_runbal_txt,
							 null, null, null, null, @v_runbal, @v1_ag_name, @v_rec_seqno, dbo.mod_function(@v_remark_len, @v_divident)
							 ,@v1_issue_date,@v1_product_code,@v1_quantity,@v1_unit_price,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE)
		print('$')
					fetch NEXT FROM c2 INTO @v2_comp_code,@v2_unit_code,@v2_agcd,@v2_dpcd,@v2_doctype,@v2_recptno,@v2_recptdt,@v2_amount,@v2_chno,@v2_chdt,@v2_chbank,@v2_reason,
					@v2_narration,@v2_received_from
				End

				close c2
				deallocate c2
				
				--------daily transactions------------
		            
				set @v_clbal =isnull(@v_opbal,0)+isnull(@v_amt,0)

				set @v_rec_seqno=isnull(@v_rec_seqno,0)+1
				If @v_runbal>=0 Begin
					set @v_runbal_txt= CONVERT(VARCHAR, CONVERT( numeric(14, 2), @v_runbal ))--+ ' Dr.'
				End
				Else Begin
					set @v_runbal_txt='('+ CONVERT(VARCHAR, CONVERT( numeric(14, 2), abs(@v_runbal) )) +')' --+' Cr.'
				End

					insert into #cir_ledger_report
					(comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
					exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
					billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE)
					values(@v1_comp_code, @v1_unit, @v1_branch_code, @v1_agcd, @v1_dpcd, null, null, @ptrn_todt,null,
					null,'Balance C/F',null,null,null,null,null,isnull(@v_runbal_txt,''),
					null,null,null,null,null, null, null,1,@v1_issue_date,@v1_product_code,@v1_quantity,@v1_unit_price,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE)

				If isnull(@v_opbal_sec,0)=0 and isnull(@v_opbal,0)=0 and @v_cramt=0 and @v_dbamt=0 Begin
				   delete from #cir_ledger_report where comp_code = @v1_comp_code and unit_code = @v1_unit and
					agcd = @v1_agcd and dpcd = @v1_dpcd
				End

				set @v_billamt=0 set @v_dbcramt=0 set @v_opbal=0 set @v_clbal=0 set @v_amt=0 set @v_runbal=0 set @v_cramt=0 set @v_dbamt=0 set @v_runbal_txt=null
		        
				fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit,@v1_agcd,@v1_dpcd,@v1_ag_name,@v1_ag_name_oth_lang,@v1_city_code,@v1_tehsil_taluka,@v1_dist_code,@v1_state_code,
					@v1_country_code,@v1_branch_code,@v1_addr1,@v1_ADDR2,@v1_ADDR3,@v1_PIN_CODE
				End

				close c1
				DEALLOCATE c1
				
				----------------------------------------  for hard code bank account --------------------------------
				--dbo.fnPadright(' ',141,'000 '+substring(AGCD,4,len(AGCD)))+'*'
				select '031 '+substring(@pagcd,4,len(@pagcd))+' Tarikh akhir bayaran diatas ialah 15 '+SUBSTRING(CONVERT(VARCHAR(11), @ptrn_frdt, 113), 4, 8) +
				'. Pembayaran boleh dibuat di pejabat cawangan Utusan di Klang atau secara             *' as data 
				union all
				select '032 '+substring(@pagcd,4,len(@pagcd))+' bank-in terus ke bank Maybank  A/C: 5124-6400-4313. Sila simpan Slip Bank untuk tujuan kutipan oleh wakil syarikat.                *' as data 
				-------------------------------------------------------------------------------------------------------
				
	
	
		
		select t.data,dbo.fnPadleft('~',141,cast(t.data as varchar)) + '*'  
		from
		 (select '040 '+substring(@pagcd,4,len(@pagcd))+' '
		+dbo.fnPadleft('~',8,CONVERT(VARCHAR(8), z.RECPTDT, 3))+'~'		
		+cast(dbo.fnPadright('~',18,isnull(z.RECPTNO,'~')) AS varchar)
		+dbo.fnPadright('~',30,isnull(cast(z.DOCTYPE as varchar),'~'))
		+dbo.fnPadright('~',4,isnull(z.PRODUCT,'~~~~~~~~~~~~') )
		+isnull(CONVERT(VARCHAR(8),z.ISSUE_DATE, 3),'~')
		+dbo.fnPadleft('~',8,isnull(cast(z.QUANTITY as varchar),'~'))
		+dbo.fnPadleft('~',12,isnull(cast(z.UNIT_PRICE as varchar),'~'))
		+dbo.fnPadleft('~',12,isnull(z.DEBIT,0))
		+dbo.fnPadleft('~',12,isnull(z.CREDIT,0))
		+dbo.fnPadleft('~',12,isnull(z.CREDIT_HEAD,'0')) 
		as data
		from		
		( SELECT (SELECT distinct Comp_Name FROM  comp_mst WHERE Comp_Code  = a.comp_code) as "CNAME",
			COMP_CODE,UNIT_CODE,BRANCH_CODE
			,(select distinct "Branch_Name" from branch_mst where Comp_Code=a.Comp_Code and "Branch_Code"=a.BRANCH_CODE) "BRANCH_NAME",
			AGCD,DPCD,AGNAME,DBO.cir_get_agency_city(comp_code,unit_code,agcd,dpcd) CITY_NAME,
			case isnull(DOCTYPE,'~')
			when 'BIL' then 'INVOICE'
			when 'RCR' then 'TUNAI'
			when 'UCN' then 
				case REASON 
				when 'NO0' then 'RETURN[Pulangan Biasa]'
				else (Select reason_name from CIR_REASON_MST t where t.COMP_CODE=a.COMP_CODE and t.REASON_CODE=a.REASON ) end
			when 'DN' then 
				case REASON
				when 'CH0' then 'Return Cheque'				
				else isnull(REMARKS,(Select reason_name from CIR_REASON_MST t where t.COMP_CODE=a.COMP_CODE and t.REASON_CODE=a.REASON )) end 	
			when 'CN' then
				case isnull(REMARKS,'~')
				when '' then reason
				when '~' then reason				
				else REMARKS end
			when '~' then
				case REMARKS
				when 'Balance C/F' then '~'
				when 'Balance B/F' then 'Balance Forward:' end
			end DOCTYPE
			,RECPTNO,RECPTDT as  RECPTDT,
			CASE a.debit WHEN 'D' THEN a.amount END as DEBIT,
			CASE a.credit WHEN 'C' THEN a.amount END as CREDIT,
			EXEC_CODE,REMARKS,CHQNO,CHQDT,CHQ_BANK,REASON,DEBIT_HEAD,CREDIT_HEAD,BILLNO,BILLDT,BILLAMT,
			ADJAMT,LEFTAMT,REC_SEQNO,narr_line
			,a.ISSUE_DATE	 as ISSUE_DATE,a.PRODUCT as PRODUCT
			,a.QUANTITY,a.UNIT_PRICE,a.addr1,a.ADDR2,a.ADDR3,a.PIN_CODE
		FROM (SELECT comp_code,unit_code,branch_code,agcd,dpcd,agname,doctype,recptno,recptdt,
		CASE sign(amount) WHEN 1 THEN 'D' END as debit,
		CASE sign(amount) WHEN - 1 THEN 'C' END as credit,
		ABS(amount) as amount,exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
		billno,billdt,billamt,adjamt,leftamt,rec_seqno,ISNULL(narr_line, 1) as narr_line
		,ISSUE_DATE,PRODUCT,QUANTITY,UNIT_PRICE,addr1,ADDR2,ADDR3,PIN_CODE
		FROM  #cir_ledger_report 
		WHERE comp_code  = @pcomp_code AND unit_code  = @punit_code) a  ) z ) t
		

	
	------------------------------------------------------------------------------------------------------------------


drop table #cir_ledger_report

drop table #cir_summary_statement
drop table #cir_temp_ageing
	
SET CONCAT_NULL_YIELDS_NULL on	
	/*
	

	
	*/


////////////////////////////////////////////////////////////next


ALTER PROCEDURE [dbo].[cir_datapos_integration_utusan]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@pfile_type                               VARCHAR(20) ,-- School S/ Others O	
	@ptrn_frdt                                datetime ,
	@ptrn_todt                                datetime ,
	@pbg_exp_frdt                             datetime ,
	@pbg_exp_todt                             datetime ,		
	@psec_exp_dt							  datetime ,	
	@pdateformat                              VARCHAR(20) ,
	@puserid                                  VARCHAR(20) ,
	@pbranch								  VARCHAR(20) ,
	@psup_branch							  VARCHAR(20) ,
	@pagcd_fr   							  VARCHAR(20) ,
	@pagcd_to   							  VARCHAR(20) ,
	@pextra1                                  VARCHAR(400) , 
	@pextra2                                  VARCHAR(400) ,
	@pextra3                                  VARCHAR(400) ,
	@pextra4                                  VARCHAR(400) ,
	@pextra5                                  VARCHAR(400) ,
	@pextra6                                  VARCHAR(400) 
	
AS 
		DECLARE @vtrn_frdt      DATETIME 
		DECLARE @vtrn_todt      DATETIME 
		DECLARE @vbgexp_frdt    DATETIME 
		DECLARE @vbgexp_todt    DATETIME 
		DECLARE @vsec_expdt     DATETIME 
     	SET @vtrn_frdt  =  @ptrn_frdt--dbo.convert_user_date('/',@pfrdt,@pdateformat)
     	SET @vtrn_todt  =  @ptrn_todt--dbo.convert_user_date('/',@ptodt,@pdateformat)
     	SET @vbgexp_frdt  =  @pbg_exp_frdt--dbo.convert_user_date('/',@pfrdt,@pdateformat)
     	SET @vbgexp_todt  =  @psec_exp_dt--dbo.convert_user_date('/',@ptodt,@pdateformat)
     	SET @vsec_expdt  =  @psec_exp_dt--dbo.convert_user_date('/',@pfrdt,@pdateformat)
     	
	
	if @pfile_type ='S'
	begin
		select ROW_NUMBER() OVER (Order by b.Branch_Name) as FILE_NO
		,b.Branch_Code ,b.Branch_Name,a.SUP_BRANCH_CODE,
		(Select Branch_Name from branch_mst x where x.Comp_Code=a.comp_code and x.Branch_Code=a.SUP_BRANCH_CODE) as SUP_BRANCH_NAME 
		,count(agcd) tot_agent
		from CIR_AGMAST a,branch_mst b where a.COMP_CODE=b.Comp_Code and a.COMP_CODE=@pcomp_code
		and a.BRANCH_CODE=b.Branch_Code 
		and isnull(a.DATA_POST,'N')='Y' and a.AG_TYPE='AT004'
		group by b.Branch_Code ,b.Branch_Name,a.SUP_BRANCH_CODE,a.comp_code

		select x.AG_NAME name,x.H_ADDR1 as company_address1,x.H_ADDR2 as company_address2,x.PIN_CODE as company_zip,x.H_ADDR3 as company_address3
		,dbo.cir_get_state ( x.comp_code,x.country_code, x.STATE_CODE) as state_name,'MY' as compute_0007,x.PHONE_NO1 as phone1,x.FAX_NO as fax1
		,'' as compute_0011,x.AGCD+x.DPCD as code,'' as compute_0013 from CIR_AGMAST x
		where x.COMP_CODE=@pcomp_code and isnull(x.DATA_POST,'N')='Y' and x.AG_TYPE='AT004'
	
	end
	else
	begin
		select ROW_NUMBER() OVER (Order by b.Branch_Name) as FILE_NO
		,b.Branch_Code ,b.Branch_Name,a.SUP_BRANCH_CODE,
		(Select Branch_Name from branch_mst x where x.Comp_Code=a.comp_code and x.Branch_Code=a.SUP_BRANCH_CODE) as SUP_BRANCH_NAME 
		,count(agcd) tot_agent
		from CIR_AGMAST a,branch_mst b where a.COMP_CODE=b.Comp_Code  and a.COMP_CODE=@pcomp_code
		and a.BRANCH_CODE=b.Branch_Code 
		and isnull(a.DATA_POST,'N')='Y' and a.AG_TYPE!='AT004'
		group by b.Branch_Code ,b.Branch_Name,a.SUP_BRANCH_CODE,a.comp_code
		
		select x.AG_NAME name,x.H_ADDR1 as company_address1,x.H_ADDR2 as company_address2,x.PIN_CODE as company_zip,x.H_ADDR3 as company_address3
		,dbo.cir_get_state ( x.comp_code,x.country_code, x.STATE_CODE) as state_name,'MY' as compute_0007,x.PHONE_NO1 as phone1,x.FAX_NO as fax1
		,'' as compute_0011,x.AGCD+x.DPCD as code,'' as compute_0013 from CIR_AGMAST x
		where x.COMP_CODE=@pcomp_code and isnull(x.DATA_POST,'N')='Y' and x.AG_TYPE!='AT004'
	end
	/*
	
	*/

///////////////////////////////////////////////////next



create FUNCTION [dbo].[cir_get_contact_person](
@pcomp_code AS varchar(10),
@pagcd AS varchar(20),
@pdpcd AS varchar(20)
) RETURNS VARCHAR(2000) AS

BEGIN
   DECLARE @vperson_name AS VARCHAR(200)

      select @vperson_name=name   from CIR_AG_CON_PER 
          where comp_code=@pcomp_code and agcd=@pagcd and dpcd=@pdpcd

  return ISNULL(@vperson_name,'')
END


/////////////////////////////////////////////////////////next

create function [dbo].[cir_ledger_ageing_datapos]   
( @pcomp_code varchar(20),
@punit_code varchar(20),
@pbran_code varchar(20),
@pzone_code varchar(30),
@pregion_code varchar(30),
@pdist_code varchar(20),
@ptaluka_code varchar(20),
@pagtype      varchar(50),
@pagclass      varchar(50),
@pag_main_code varchar(50),
@pag_sub_code varchar(50),
@paging_by varchar(50),
@pasondt datetime,
@pdebitupto_date datetime,
@pcreditupto_date datetime,
@pdateformat varchar(20),
@puserid varchar(20),
@pextra1 varchar(20),
@pextra2 varchar(20),
@pextra3 varchar(30),
@pextra4 varchar(30),
@pextra5 varchar(50) )
RETURNS @cir_temp_ageing TABLE
(
  COMP_CODE     VARCHAR(8),
  UNIT_CODE     VARCHAR(8),
  BRAN_CODE     VARCHAR(8),
  AGCD          VARCHAR(8),
  DPCD          VARCHAR(8),
  AG_NAME       VARCHAR(100),
  CITY_NAME     VARCHAR(100),
  PENDING_AMT   NUMERIC(14,2),
  CUR_AMT        NUMERIC(14,2),
  SLAB_1        NUMERIC(14,2),
  SLAB_2        NUMERIC(14,2),
  SLAB_3        NUMERIC(14,2),
  SLAB_4        NUMERIC(14,2),
  SLAB_5        NUMERIC(14,2),
  SLAB_6        NUMERIC(14,2),
  ON_ACAMT      NUMERIC(14,2),
  RECT_PENDING  NUMERIC(14,2),
  SESSIONID     NUMERIC(14),
  PUBNAME		VARCHAR(200),
  ageing		varchar(1)
)
As
 begin
--------- slabs end 
declare  @ptill_days1 as varchar(20)
declare  @ptill_days2 as varchar(20)
declare  @ptill_days3 as varchar(30)
declare  @ptill_days4 as varchar(30)
declare  @ptill_days5 as varchar(50)
declare  @ptill_days6 as varchar(50)
declare  @ptill_current as varchar(50)
----------------  slabs  
declare  @vtodt   as datetime
declare  @vasondt  as datetime     
declare  @v_dt    as datetime
declare  @v_ondt  as datetime
declare  @v_days numeric(10);

declare  @v_pending_rcpt_amt as numeric(14,2) 

declare  @v_amt     as    numeric(14,2);
declare  @v_amt030  as   numeric(14,2);
declare  @v_amt3160 as   numeric(14,2);
declare  @v_amt6190 as   numeric(14,2);
declare  @v_amt91120 as numeric(14,2);
declare  @v_amt121180   as numeric(14,2);
declare  @v_amt181   as numeric(14,2);
declare  @v_amtcur   as numeric(14,2);

declare  @debit_amt_030  as  numeric(14,2)  --debit amt  for slab  1 days
declare  @debit_amt_3160 as  numeric(14,2)  --debit amt  for slab  2 days
declare  @debit_amt_6190 as  numeric(14,2)  --debit amt  for slab  3 days
declare  @debit_amt_91120 as numeric(14,2)  --debit amt  for slab  4 days
declare  @debit_amt_121180  as  numeric(14,2)  --debit amt  for >slab 5 days
declare  @debit_amt_181  as  numeric(14,2)  --debit amt  for >slab 6 days
declare  @debit_amt_cur  as  numeric(14,2)  --debit amt  for >current

declare  @bill_pending_amt as numeric(14,2)
declare  @rcpt_pending_amt  as numeric(14,2) --pending receipt amount

set @debit_amt_030    =0  --debit amt  for slab  1 days
set @debit_amt_3160   =0  --debit amt  for slab  2 days
set @debit_amt_6190   =0  --debit amt  for slab  3 days
set @debit_amt_91120  =0 --debit amt  for slab  4 days
set @debit_amt_121180 =0  --debit amt  for >slab 4 days
set @debit_amt_181    =0  --debit amt  for >slab 4 days
set @debit_amt_cur    =0  --debit amt  for >current
set @bill_pending_amt =0
set @rcpt_pending_amt =0  --pending receipt amount

-- cursor cur_agency variables
declare @rec_agency_comp_code as varchar(30)
declare @rec_agency_agcd as varchar(20)
declare @rec_agency_dpcd as varchar(30)
declare @rec_agency_agency_name as varchar(300)
declare @rec_agency_city_code as varchar(200)
declare @rec_agency_city_name as varchar(200)
declare @rec_agency_credit_days as int
declare @rec_agency_branch_name as varchar(50)
declare @rec_agency_ageing_type as varchar(1)

--@rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name,@rec_agency_city_code,@rec_agency_city_name,
--@rec_agency_credit_days,@rec_agency_branch_name,@rec_agency_ageing_type
declare cur_agency_1 cursor for	
	select m.Comp_Code ,m.agcd ,m.dpcd ,m.ag_name ,m.City_Code,c.city_name,m.credit_days,m.branch_code,m.ageing_type
	from cir_agmast m,cir_city_mast c
	where m.comp_code=c.comp_code and m.comp_code=@pcomp_code 
	and m.unit=@punit_code and m.city_code=c.city_code 			
	and (m.Dist_Code=@pdist_code or @pdist_code is null or @pdist_code ='') 
	and (m.tehsil_taluka=@ptaluka_code or @ptaluka_code is null or @ptaluka_code ='') 
	and (m.agcd=@pag_main_code or @pag_main_code is null or @pag_main_code ='') 
	and (m.dpcd=@pag_sub_code or @pag_sub_code is null or @pag_sub_code ='')

	if @pdebitupto_date is null or @pdebitupto_date='' 
	begin
		set @pdebitupto_date =@pasondt
	end
	if @pcreditupto_date is null or @pcreditupto_date='' 
	begin
		set @pcreditupto_date =@pasondt
	end
	if @pasondt is null or @pasondt =''
	begin
		set @pasondt=@pcreditupto_date
	end
declare @fetch_protype as varchar(20)
declare @fetch_pub as varchar(20)

-- cursor v_bill variables
declare @v_bill_billno as varchar(50)
declare @v_bill_billdt as varchar(30)
declare @v_bill_bill_amt as numeric(15,2)

-- cursor v_pending_rcpt variables  
declare @v_pending_rcpt_ag_main_code as varchar(30)
declare @v_pending_rcpt_ag_sub_code as varchar(50)
declare @v_pending_rcpt_amount as numeric(15,2)

declare @fetch_pubname as varchar(200)
declare @fetch_pubtype as varchar(200)

--SELECT 'cursor has ' + CAST(@@CURSOR_ROWS AS VARCHAR) + ' rows'
declare @v_mcnt1 as datetime
declare @v_mcnt2 as datetime
declare @v_mcnt3 as datetime
declare @v_mcnt4 as datetime
declare @v_mcnt5 as datetime
declare  @vtill_days1 AS int
declare  @vtill_days2 AS int
declare  @vtill_days3 AS int
declare  @vtill_days4 AS int
declare  @vtill_days5 AS int
declare @vrec_agency_ageing_type as varchar(10)

open cur_agency_1
		fetch NEXT FROM cur_agency_1 INTO @rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name,@rec_agency_city_code,@rec_agency_city_name,@rec_agency_credit_days,@rec_agency_branch_name,@rec_agency_ageing_type
		WHILE (@@FETCH_STATUS = 0) 
		begin
declare @day as int


	declare cur_agency cursor for
			select distinct publ from cir_supply where comp_code=@pcomp_code and agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd order by publ
			--select distinct  dbo.cir_get_publ_type(comp_code,publ,'C','')  publ from cir_supply where comp_code=@pcomp_code and agcd=@pag_main_code and dpcd=@pag_sub_code order by publ
			
		

open cur_agency
		fetch NEXT FROM cur_agency INTO @fetch_pub
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN 
			
			select distinct @fetch_protype=pro_type,@fetch_pubname=PUBL_NAME,@fetch_pubtype=
			(Select pubname from pub_type_mast where Comp_Code=@pcomp_code and pub_type_mast.pubtypecode=CIR_PUBL_MAST.PRO_TYPE)
			from CIR_PUBL_MAST where COMP_CODE=@pcomp_code and publ=@fetch_pub
			
			if @fetch_protype ='MA0'
			begin
				set @vrec_agency_ageing_type='M'
			end 
			else
			begin
				set @vrec_agency_ageing_type=@rec_agency_ageing_type
			end
			
			select @ptill_days1=SLAB_TILL1,@ptill_days2=SLAB_TILL2,@ptill_days3=SLAB_TILL3,@ptill_days4=SLAB_TILL4
			,@ptill_days5=SLAB_TILL5,@ptill_days6=SLAB_TILL6--,@rec_agency_ageing_type=AGEING_TYPE 
			from CIR_AGEING_SLAB_MAST 
			where COMP_CODE=@pcomp_code and PRO_TYPE=@fetch_protype


		if upper(@vrec_agency_ageing_type) = 'D' 
		begin
			set @vtodt=dateadd(dd,-1,@pasondt)
		end
		else if upper(@vrec_agency_ageing_type) = 'W' 
		begin
			select @day=DATEPART(dw,@pasondt) 
			set @vtodt=dateadd(dd,-(@day-1),@pasondt)
		end
		else
		begin
			if dbo.GetLastDayOfMonth(@pasondt)=@pasondt 
			begin
				set @vtodt=@pasondt
			end
			else
			begin
			
				set @vtodt=dbo.GetLastDayOfMonth(dateadd(mm,-1,@pasondt))
				
			end
		end
			
			if @vrec_agency_ageing_type='M' begin 
				set @v_mcnt1=DATEADD(MM,-1*@ptill_days1,@vtodt+1)
				set @v_mcnt2=DATEADD(MM,-1*@ptill_days2,@vtodt+1)
				set @v_mcnt3=DATEADD(MM,-1*@ptill_days3,@vtodt+1)
				set @v_mcnt4=DATEADD(MM,-1*@ptill_days4,@vtodt+1)
				set @v_mcnt5=DATEADD(MM,-1*@ptill_days5,@vtodt+1)
				--DATEDIFF(dd, dbo.GetFirstDayOfMonth( @vtodt),@vtodt )+1  
				set @vtill_days1=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt1),@vtodt )+1    
				set @vtill_days2=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt2),@vtodt )+1
				set @vtill_days3=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt3),@vtodt )+1
				set @vtill_days4=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt4),@vtodt )+1
				set @vtill_days5=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt5),@vtodt )+1
			end
			else
			begin
				set @vtill_days1=@ptill_days1
				set @vtill_days2=@ptill_days2
				set @vtill_days3=@ptill_days3
				set @vtill_days4=@ptill_days4
				set @vtill_days5=@ptill_days5
			end
		
			set @debit_amt_030 = 0;
			set @debit_amt_3160 = 0;
			set @debit_amt_6190 = 0;
			set @debit_amt_91120 = 0;
			set @debit_amt_121180 = 0;
			set @debit_amt_181 = 0;
			set @rcpt_pending_amt = 0;
			set @bill_pending_amt = 0;
			declare c_bill cursor for
					select distinct billno,billdt,sum(amount) bill_amt from cir_outmast
					where comp_code=@pcomp_code and unit_code=@punit_code and
					agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
					billdt<=@vtodt and  isnull(abs(amount),0)>0
					group by comp_code,billno,billdt having sum(amount)>0
					union all
					select distinct recptno billno,recptdt billdt,sum(amount) bill_amt from cir_outmast
					where comp_code=@pcomp_code and unit_code=@punit_code and
					agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd  and publ=@fetch_pub and
					recptdt<=@vtodt and isnull(amount,0)>0 and billno is null
					group by comp_code,recptno,recptdt order by 2,1
                          
				     --having  sum(amount)<0
					open c_bill
							fetch NEXT FROM c_bill INTO @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt
							WHILE (@@FETCH_STATUS = 0) 
							begin							
								
								set @v_dt    = @v_bill_billdt
								set @v_ondt  = @vtodt								
								
								if @paging_by='D' begin
									set @v_days=DATEDIFF(dd, @v_dt,@v_ondt )---isnull(pcrdtday,0)+1;
								end
								else
								begin    
									set @v_days=DATEDIFF(dd, @v_dt,@v_ondt )+1;
								end
								
								if @v_days<0 begin
									set @v_days=0;
								end
								
								set @v_amt               =0;
								set @v_amt030            =0;
								set @v_amt3160           =0;
								set @v_amt6190           =0;
								set @v_amt91120          =0;
								set @v_amt121180         =0;
								set @v_amt181            =0;	

								if @v_days between 0 and @vtill_days1 begin
									select @v_amt030=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0

									set @v_amt030 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt030,0);
									set @debit_amt_030 =isnull(@debit_amt_030,0)+isnull(@v_amt030,0)
								end
								else if @v_days between isnull(@vtill_days1,0)+1 and @vtill_days2 begin
									select @v_amt3160=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt3160 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt3160,0);
									set @debit_amt_3160 =isnull(@debit_amt_3160,0)+isnull(@v_amt3160,0)
								end
								else if @v_days between isnull(@vtill_days2,0)+1 and @vtill_days3 begin
									select @v_amt6190=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt6190 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt6190,0);
									set @debit_amt_6190 =isnull(@debit_amt_6190,0)+isnull(@v_amt6190,0)
								end
								else if @v_days between isnull(@vtill_days3,0)+1 and @vtill_days4 begin
									select @v_amt91120=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt91120 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt91120,0);
									set @debit_amt_91120 =isnull(@debit_amt_91120,0)+isnull(@v_amt91120,0)
								end  
								else if @v_days between isnull(@vtill_days4,0)+1 and @vtill_days5 begin
									select @v_amt121180=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt121180 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt121180,0);
									set @debit_amt_121180 =isnull(@debit_amt_121180,0)+isnull(@v_amt121180,0)
								end        
								else
								begin
									select @v_amt181=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt181 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt181,0);
									set @debit_amt_181 =isnull(@debit_amt_181,0)+isnull(@v_amt181,0)
								end
								

							fetch NEXT FROM c_bill INTO @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt
							end
					close c_bill		
				deallocate c_bill

declare @cur_from_dt as datetime
set @cur_from_dt= dateadd(dd,1,@vtodt)
		select @v_amtcur=sum(amount) from cir_outmast 
		where comp_code=@pcomp_code and unit_code=@punit_code and
		agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
		billdt between @cur_from_dt and @pasondt  
		and RECPTNO is null and RECPTDT is null
		--and recptdt<=@pasondt and amount<0
		
		
		select @v_pending_rcpt_amt=sum(amount) from cir_outmast 
        where comp_code=@pcomp_code and unit_code=@punit_code and
          agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
          (billno is null or billdt>@pcreditupto_date) and 
          recptdt<=@pcreditupto_date and 
          doctyp+recptno+cast(recptdt as varchar) not in 
          (select distinct doctyp+recptno+cast(recptdt as varchar) from ad_outstand
           where comp_code=@pcomp_code and unit_code=@punit_code and
                 agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
                 recptdt<=@vtodt and isnull(amount,0)<0 and billno IS NULL)
	
		set @v_amt=isnull(@v_amtcur,0)+ isnull(@debit_amt_030,0)+isnull(@debit_amt_3160,0)+isnull(@debit_amt_6190,0)+isnull(@debit_amt_91120,0)+isnull(@debit_amt_121180,0)+isnull(@debit_amt_181,0)

		if @v_amt=0 begin
			set @debit_amt_030    = 0
			set @debit_amt_3160   = 0
			set @debit_amt_6190   = 0
			set @debit_amt_91120  = 0
			set @debit_amt_121180 = 0
			set @debit_amt_181    = 0
			set @rcpt_pending_amt = 0
		end
		else
		begin
			set @rcpt_pending_amt=isnull(@v_pending_rcpt_amount,0)
			set @bill_pending_amt=isnull(@v_amt,0)
		end
		insert into @cir_temp_ageing (comp_code,unit_code,agcd,dpcd,ag_name,
                city_name,pending_amt,CUR_AMT
                , SLAB_1 ,slab_2,slab_3,slab_4,slab_5,slab_6,rect_pending,on_acamt,sessionid,PUBNAME,ageing)
        values (@rec_agency_comp_code,@punit_code,@rec_agency_agcd, @rec_agency_dpcd, @fetch_protype,
               @fetch_pubname,isnull(@bill_pending_amt,0),isnull(@v_amtcur,0)
               ,isnull(@debit_amt_030,0),isnull(@debit_amt_3160,0), isnull(@debit_amt_6190,0)
               ,isnull(@debit_amt_91120,0), isnull(@debit_amt_121180,0), isnull(@debit_amt_181,0),
               isnull(@rcpt_pending_amt,0),0,@@spid,@fetch_pubtype,@rec_agency_ageing_type);
		fetch NEXT FROM cur_agency INTO @fetch_pub
		    set @debit_amt_030    = 0
			set @debit_amt_3160   = 0
			set @debit_amt_6190   = 0
			set @debit_amt_91120  = 0
			set @debit_amt_121180 = 0
			set @debit_amt_181    = 0
			set @rcpt_pending_amt = 0
			set @bill_pending_amt = 0
		end
		
close cur_agency;
deallocate cur_agency


fetch NEXT FROM cur_agency_1 INTO @rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name,@rec_agency_city_code,@rec_agency_city_name,@rec_agency_credit_days,@rec_agency_branch_name,@rec_agency_ageing_type
end
close cur_agency_1		
deallocate cur_agency_1

RETURN

--select comp_code,unit_code,agcd,dpcd,ag_name PRO_TYPE,PUBNAME--,city_name PUBL_NAME
--,sum(isnull(pending_amt,0)) pending_amt,sum(isnull(cur_amt,0)) cur_amt,sum(isnull(slab_1,0)) slab_1,sum(isnull(slab_2,0)) slab_2
--,sum(isnull(slab_3,0)) slab_3,sum(isnull(slab_4,0)) slab_4,sum(isnull(slab_5,0)) slab_5,sum(isnull(slab_6,0)) slab_6,sum(isnull(rect_pending,0)) rect_pending
--,ageing
--from #cir_temp_ageing group by #cir_temp_ageing.COMP_CODE,#cir_temp_ageing.UNIT_CODE,#cir_temp_ageing.AGCD,#cir_temp_ageing.DPCD
--,#cir_temp_ageing.AG_NAME,PUBNAME,ageing
--order by ag_name;



 


end

////////////////////////////////////////////////////


alter function [dbo].[cir_get_emailofcomp_p]
	(@pcomp_code      as varchar(20),
	 @pextra1         as varchar(20),
	 @pextar2	      as varchar(20)
	) returns varchar(100)

Begin
	declare @v_email as varchar(100)
	select @v_email =  emailid from comp_mst where comp_code=@pcomp_code;
	
	return @v_email
end


///////////////////////////////////////////////


ALTER procedure [dbo].[cir_agency_bind_for_mail_sms] (
        @pcompcode            varchar(10),
        @punit                varchar(10),
        @pbranch              varchar(10),
        @psource              varchar(10),
        @pregion_code         varchar(20),
        @pzone_code           varchar(20),
        @pstate_code          varchar(20), -- roleid in case of internal
        @pdist_code           varchar(20), -- userid  in case of internal
        @pcity_code           varchar(20),
        @pagcd                varchar(10),
        @pdpcd                varchar(10),
        @pdateformat          varchar(10),
        @pextra1              varchar(10),
        @pextra2              varchar(10)
        ) as
  Begin
  
  
	if @psource ='E'
	begin
	     select distinct a.* from cir_agmast a,CIR_SUPPLY s
         where a.COMP_CODE=s.COMP_CODE 
         and  a.unit=s.unit
         and a.AGCD=s.AGCD
         and a.DPCD=s.DPCD and
         a.comp_code = @pcompcode 
         and (a.unit = @punit or @punit ='' or @punit is null)
         and (BRANCH_CODE = @pbranch or @pbranch ='' or @pbranch is null)
         and (dbo.cir_get_region_by_city(@pcompcode,a.CITY_CODE,'C') = @pregion_code or @pregion_code ='' or @pregion_code is null)
         and (dbo.cir_get_zone_by_city(@pcompcode,a.CITY_CODE,'C') = @pzone_code or @pzone_code ='' or @pzone_code is null)
         and (STATE_CODE = @pstate_code or @pstate_code ='' or @pstate_code is null) 
         and (DIST_CODE = @pdist_code or @pdist_code ='' or @pdist_code is null) 
         and (CITY_CODE = @pcity_code or @pcity_code ='' or @pcity_code is null) 
         and (s.ROUTE_CODE = @pextra1 or @pextra1 ='' or @pextra1 is null) 
         and (a.agcd=@pagcd or @pagcd is null or @pagcd ='') 
         and (a.dpcd=@pdpcd or @pdpcd is null or @pdpcd ='')
         and isnull(freeze_flag,'N')='N'
         order by ag_name
	end
	else
	begin
		select * from login
         where com_code = @pcompcode 
         --and (unit = @punit or @punit ='' or @punit is null)
         and (retainer_code = @pbranch or @pbranch ='' or @pbranch is null)         
         and (ROLEID = @pstate_code or @pstate_code ='' or @pstate_code is null) 
         and (userid = @pdist_code or @pdist_code ='' or @pdist_code is null)
         order by username
	
	end
  
  End 

/////////////////////////////////////////////////////

create PROCEDURE [dbo].[cir_get_userforsenction]

  	@pcompcode as varchar(200),
  	@punitcode as varchar(200),
  	@pbranchcode as varchar(200),
    @pdateformat as	varchar(200),
    @pextra1 as	varchar(200),
    @pextra2 as varchar(200)

 AS
	Begin
		select * from login where userid = (select MAX(USER_ID) from CIR_UNSOLD_APR_PERMISSION where COMP_CODE=@pcompcode
		AND PRINTING_CENTER=@punitcode
		AND BRANCH_CODE=@pbranchcode)
		
	End


///////////////////////////////////////////////////////////////




ALTER PROCEDURE [dbo].[cir_ledger_ageing]   
@pcomp_code varchar(20),
@punit_code varchar(20),
@pbran_code varchar(20),
@pzone_code varchar(30),
@pregion_code varchar(30),
@pdist_code varchar(20),
@ptaluka_code varchar(20),
@pagtype      varchar(50),
@pagclass      varchar(50),
@pag_main_code varchar(50),
@pag_sub_code varchar(50),
@paging_by varchar(50),
@pasondt datetime,
@pdebitupto_date datetime,
@pcreditupto_date datetime,
@pdateformat varchar(20),
@puserid varchar(20),
@pextra1 varchar(20),
@pextra2 varchar(20),
@pextra3 varchar(30),
@pextra4 varchar(30),
@pextra5 varchar(50)
As
 
--------- slabs end 
declare  @ptill_days1 as varchar(20)
declare  @ptill_days2 as varchar(20)
declare  @ptill_days3 as varchar(30)
declare  @ptill_days4 as varchar(30)
declare  @ptill_days5 as varchar(50)
declare  @ptill_days6 as varchar(50)
declare  @ptill_current as varchar(50)
----------------  slabs  
declare  @vtodt   as datetime
declare  @vasondt  as datetime     
declare  @v_dt    as datetime
declare  @v_ondt  as datetime
declare  @v_days numeric(10);

declare  @v_pending_rcpt_amt as numeric(14,2) 

declare  @v_amt     as    numeric(14,2);
declare  @v_amt030  as   numeric(14,2);
declare  @v_amt3160 as   numeric(14,2);
declare  @v_amt6190 as   numeric(14,2);
declare  @v_amt91120 as numeric(14,2);
declare  @v_amt121180   as numeric(14,2);
declare  @v_amt181   as numeric(14,2);
declare  @v_amtcur   as numeric(14,2);

declare  @debit_amt_030  as  numeric(14,2)  --debit amt  for slab  1 days
declare  @debit_amt_3160 as  numeric(14,2)  --debit amt  for slab  2 days
declare  @debit_amt_6190 as  numeric(14,2)  --debit amt  for slab  3 days
declare  @debit_amt_91120 as numeric(14,2)  --debit amt  for slab  4 days
declare  @debit_amt_121180  as  numeric(14,2)  --debit amt  for >slab 5 days
declare  @debit_amt_181  as  numeric(14,2)  --debit amt  for >slab 6 days
declare  @debit_amt_cur  as  numeric(14,2)  --debit amt  for >current

declare  @bill_pending_amt as numeric(14,2)
declare  @rcpt_pending_amt  as numeric(14,2) --pending receipt amount

CREATE TABLE #cir_temp_ageing
(
  COMP_CODE     VARCHAR(8),
  UNIT_CODE     VARCHAR(8),
  BRAN_CODE     VARCHAR(8),
  AGCD          VARCHAR(8),
  DPCD          VARCHAR(8),
  AG_NAME       VARCHAR(100),
  CITY_NAME     VARCHAR(100),
  PENDING_AMT   NUMERIC(14,2),
  CUR_AMT        NUMERIC(14,2),
  SLAB_1        NUMERIC(14,2),
  SLAB_2        NUMERIC(14,2),
  SLAB_3        NUMERIC(14,2),
  SLAB_4        NUMERIC(14,2),
  SLAB_5        NUMERIC(14,2),
  SLAB_6        NUMERIC(14,2),
  ON_ACAMT      NUMERIC(14,2),
  RECT_PENDING  NUMERIC(14,2),
  SESSIONID     NUMERIC(14),
  PUBNAME		VARCHAR(200),
  ageing		varchar(1)
)

set @debit_amt_030    =0  --debit amt  for slab  1 days
set @debit_amt_3160   =0  --debit amt  for slab  2 days
set @debit_amt_6190   =0  --debit amt  for slab  3 days
set @debit_amt_91120  =0 --debit amt  for slab  4 days
set @debit_amt_121180 =0  --debit amt  for >slab 4 days
set @debit_amt_181    =0  --debit amt  for >slab 4 days
set @debit_amt_cur    =0  --debit amt  for >current
set @bill_pending_amt =0
set @rcpt_pending_amt =0  --pending receipt amount

-- cursor cur_agency variables
declare @rec_agency_comp_code as varchar(30)
declare @rec_agency_agcd as varchar(20)
declare @rec_agency_dpcd as varchar(30)
declare @rec_agency_agency_name as varchar(300)
declare @rec_agency_city_code as varchar(200)
declare @rec_agency_city_name as varchar(200)
declare @rec_agency_credit_days as int
declare @rec_agency_branch_name as varchar(50)
declare @rec_agency_ageing_type as varchar(1)

--@rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name,@rec_agency_city_code,@rec_agency_city_name,
--@rec_agency_credit_days,@rec_agency_branch_name,@rec_agency_ageing_type
declare cur_agency_1 cursor for	
	select m.Comp_Code ,m.agcd ,m.dpcd ,m.ag_name ,m.City_Code,c.city_name,m.credit_days,m.branch_code,m.ageing_type
	from cir_agmast m,cir_city_mast c
	where m.comp_code=c.comp_code and m.comp_code=@pcomp_code 
	and m.unit=@punit_code and m.city_code=c.city_code 			
	and (m.Dist_Code=@pdist_code or @pdist_code is null or @pdist_code ='') 
	and (m.tehsil_taluka=@ptaluka_code or @ptaluka_code is null or @ptaluka_code ='') 
	and (m.agcd=@pag_main_code or @pag_main_code is null or @pag_main_code ='') 
	and (m.dpcd=@pag_sub_code or @pag_sub_code is null or @pag_sub_code ='')

	if @pdebitupto_date is null or @pdebitupto_date='' 
	begin
		set @pdebitupto_date =@pasondt
	end
	if @pcreditupto_date is null or @pcreditupto_date='' 
	begin
		set @pcreditupto_date =@pasondt
	end
	if @pasondt is null or @pasondt =''
	begin
		set @pasondt=@pcreditupto_date
	end
declare @fetch_protype as varchar(20)
declare @fetch_pub as varchar(20)

-- cursor v_bill variables
declare @v_bill_billno as varchar(50)
declare @v_bill_billdt as varchar(30)
declare @v_bill_bill_amt as numeric(15,2)

-- cursor v_pending_rcpt variables  
declare @v_pending_rcpt_ag_main_code as varchar(30)
declare @v_pending_rcpt_ag_sub_code as varchar(50)
declare @v_pending_rcpt_amount as numeric(15,2)

declare @fetch_pubname as varchar(200)
declare @fetch_pubtype as varchar(200)

--SELECT 'cursor has ' + CAST(@@CURSOR_ROWS AS VARCHAR) + ' rows'
declare @v_mcnt1 as datetime
declare @v_mcnt2 as datetime
declare @v_mcnt3 as datetime
declare @v_mcnt4 as datetime
declare @v_mcnt5 as datetime
declare  @vtill_days1 AS int
declare  @vtill_days2 AS int
declare  @vtill_days3 AS int
declare  @vtill_days4 AS int
declare  @vtill_days5 AS int
declare @vrec_agency_ageing_type as varchar(10)

open cur_agency_1
		fetch NEXT FROM cur_agency_1 INTO @rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name,@rec_agency_city_code,@rec_agency_city_name,@rec_agency_credit_days,@rec_agency_branch_name,@rec_agency_ageing_type
		WHILE (@@FETCH_STATUS = 0) 
		begin
declare @day as int


	declare cur_agency cursor for
			select distinct publ from cir_supply where comp_code=@pcomp_code and agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd order by publ
			--select distinct  dbo.cir_get_publ_type(comp_code,publ,'C','')  publ from cir_supply where comp_code=@pcomp_code and agcd=@pag_main_code and dpcd=@pag_sub_code order by publ
			
		

print('@rec_agency_ageing_type')print(@rec_agency_ageing_type)
open cur_agency
		fetch NEXT FROM cur_agency INTO @fetch_pub
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN print('dddddd') print(@fetch_pub)
			
			select distinct @fetch_protype=pro_type,@fetch_pubname=PUBL_NAME,@fetch_pubtype=
			(Select pubname from pub_type_mast where Comp_Code=@pcomp_code and pub_type_mast.pubtypecode=CIR_PUBL_MAST.PRO_TYPE)
			from CIR_PUBL_MAST where COMP_CODE=@pcomp_code and publ=@fetch_pub
			
			print('@fetch_protype')print(@fetch_protype)
			print('@@fetch_pubname')print(@fetch_pubname)
			print('@fetch_pubtype')print(@fetch_pubtype)
			if @fetch_protype ='MA0'
			begin
				set @vrec_agency_ageing_type='M'
			end 
			else
			begin
				set @vrec_agency_ageing_type=@rec_agency_ageing_type
			end
			
			select @ptill_days1=SLAB_TILL1,@ptill_days2=SLAB_TILL2,@ptill_days3=SLAB_TILL3,@ptill_days4=SLAB_TILL4
			,@ptill_days5=SLAB_TILL5,@ptill_days6=SLAB_TILL6--,@rec_agency_ageing_type=AGEING_TYPE 
			from CIR_AGEING_SLAB_MAST 
			where COMP_CODE=@pcomp_code and PRO_TYPE=@fetch_protype

print('slab')print(@ptill_days1)print(@ptill_days2)print(@ptill_days3)print(@ptill_days4)print(@ptill_days5)
print(@ptill_days6)print(@rec_agency_ageing_type)

print('gaurav')
print(@vrec_agency_ageing_type)
print(@pasondt)
print(dbo.GetLastDayOfMonth(@pasondt))
print('debug')
		if upper(@vrec_agency_ageing_type) = 'D' 
		begin
			set @vtodt=dateadd(dd,-1,@pasondt)
		end
		else if upper(@vrec_agency_ageing_type) = 'W' 
		begin
			select @day=DATEPART(dw,@pasondt) 
			print(@day)
			set @vtodt=dateadd(dd,-(@day-1),@pasondt)
		end
		else
		begin
			if dbo.GetLastDayOfMonth(@pasondt)=@pasondt 
			begin
				set @vtodt=@pasondt
			end
			else
			begin
			
				set @vtodt=dbo.GetLastDayOfMonth(dateadd(mm,-1,@pasondt))
				
			end
		end
			
print('come')
print(@vtodt)
	
print('custom')print(@ptill_days1)print(@ptill_days2)print(@ptill_days3)print(@ptill_days4)print(@ptill_days5)
			if @vrec_agency_ageing_type='M' begin print('gks')
				set @v_mcnt1=DATEADD(MM,-1*@ptill_days1,@vtodt+1)
				set @v_mcnt2=DATEADD(MM,-1*@ptill_days2,@vtodt+1)
				set @v_mcnt3=DATEADD(MM,-1*@ptill_days3,@vtodt+1)
				set @v_mcnt4=DATEADD(MM,-1*@ptill_days4,@vtodt+1)
				set @v_mcnt5=DATEADD(MM,-1*@ptill_days5,@vtodt+1)
				--DATEDIFF(dd, dbo.GetFirstDayOfMonth( @vtodt),@vtodt )+1  
				set @vtill_days1=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt1),@vtodt )+1    
				set @vtill_days2=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt2),@vtodt )+1
				set @vtill_days3=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt3),@vtodt )+1
				set @vtill_days4=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt4),@vtodt )+1
				set @vtill_days5=DATEDIFF(dd, dbo.GetFirstDayOfMonth( @v_mcnt5),@vtodt )+1
			end
			else
			begin
				set @vtill_days1=@ptill_days1
				set @vtill_days2=@ptill_days2
				set @vtill_days3=@ptill_days3
				set @vtill_days4=@ptill_days4
				set @vtill_days5=@ptill_days5
			end
print('custom1')print(@vtill_days1)print(@vtill_days2)print(@vtill_days3)print(@vtill_days4)print(@vtill_days5)
			
			print @rec_agency_dpcd
			set @debit_amt_030 = 0;
			set @debit_amt_3160 = 0;
			set @debit_amt_6190 = 0;
			set @debit_amt_91120 = 0;
			set @debit_amt_121180 = 0;
			set @debit_amt_181 = 0;
			set @rcpt_pending_amt = 0;
			set @bill_pending_amt = 0;
			print('enter first')
			declare c_bill cursor for
					select distinct billno,billdt,sum(amount) bill_amt from cir_outmast
					where comp_code=@pcomp_code and unit_code=@punit_code and
					agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
					billdt<=@vtodt and  isnull(abs(amount),0)>0
					group by comp_code,billno,billdt having sum(amount)>0
					union all
					select distinct recptno billno,recptdt billdt,sum(amount) bill_amt from cir_outmast
					where comp_code=@pcomp_code and unit_code=@punit_code and
					agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd  and publ=@fetch_pub and
					recptdt<=@vtodt and isnull(amount,0)>0 and billno is null
					group by comp_code,recptno,recptdt order by 2,1
                          
				     --having  sum(amount)<0
					open c_bill
							fetch NEXT FROM c_bill INTO @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt
							WHILE (@@FETCH_STATUS = 0) 
							begin
								print('enter second')
								
								set @v_dt    = @v_bill_billdt
								set @v_ondt  = @vtodt
								
								print(@v_dt)
								print(@v_ondt)
								
								if @paging_by='D' begin
									set @v_days=DATEDIFF(dd, @v_dt,@v_ondt )---isnull(pcrdtday,0)+1;
								end
								else
								begin    
									set @v_days=DATEDIFF(dd, @v_dt,@v_ondt )+1;
								end
								
								if @v_days<0 begin
									set @v_days=0;
								end
								
								print('x')
								print(@v_days)
								set @v_amt               =0;
								set @v_amt030            =0;
								set @v_amt3160           =0;
								set @v_amt6190           =0;
								set @v_amt91120          =0;
								set @v_amt121180         =0;
								set @v_amt181            =0;	

								if @v_days between 0 and @vtill_days1 begin
									select @v_amt030=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0

									set @v_amt030 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt030,0);
									set @debit_amt_030 =isnull(@debit_amt_030,0)+isnull(@v_amt030,0)
								end
								else if @v_days between isnull(@vtill_days1,0)+1 and @vtill_days2 begin
									select @v_amt3160=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt3160 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt3160,0);
									set @debit_amt_3160 =isnull(@debit_amt_3160,0)+isnull(@v_amt3160,0)
								end
								else if @v_days between isnull(@vtill_days2,0)+1 and @vtill_days3 begin
									select @v_amt6190=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt6190 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt6190,0);
									set @debit_amt_6190 =isnull(@debit_amt_6190,0)+isnull(@v_amt6190,0)
								end
								else if @v_days between isnull(@vtill_days3,0)+1 and @vtill_days4 begin
									select @v_amt91120=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt91120 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt91120,0);
									set @debit_amt_91120 =isnull(@debit_amt_91120,0)+isnull(@v_amt91120,0)
								end  
								else if @v_days between isnull(@vtill_days4,0)+1 and @vtill_days5 begin
									select @v_amt121180=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt121180 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt121180,0);
									set @debit_amt_121180 =isnull(@debit_amt_121180,0)+isnull(@v_amt121180,0)
								end        
								else
								begin
									select @v_amt181=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
										  agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
										  billno=@v_bill_billno and billdt=@v_bill_billdt and 
										  recptdt<=@vasondt and amount<0
									--insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
									set @v_amt181 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt181,0);
									set @debit_amt_181 =isnull(@debit_amt_181,0)+isnull(@v_amt181,0)
								end
								

							fetch NEXT FROM c_bill INTO @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt
							end
					close c_bill		
				deallocate c_bill

declare @cur_from_dt as datetime
print('t')	
print(@punit_code)	

print(@fetch_pub)
set @cur_from_dt= dateadd(dd,1,@vtodt)
print(@cur_from_dt)
print(@pasondt)
print('W')
		select @v_amtcur=sum(amount) from cir_outmast 
		where comp_code=@pcomp_code and unit_code=@punit_code and
		agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and publ=@fetch_pub and
		billdt between @cur_from_dt and @pasondt  
		and RECPTNO is null and RECPTDT is null
		--and recptdt<=@pasondt and amount<0
		
		
		select @v_pending_rcpt_amt=sum(amount) from cir_outmast 
        where comp_code=@pcomp_code and unit_code=@punit_code and
          agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
          (billno is null or billdt>@pcreditupto_date) and 
          recptdt<=@pcreditupto_date and 
          doctyp+recptno+cast(recptdt as varchar) not in 
          (select distinct doctyp+recptno+cast(recptdt as varchar) from ad_outstand
           where comp_code=@pcomp_code and unit_code=@punit_code and
                 agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
                 recptdt<=@vtodt and isnull(amount,0)<0 and billno IS NULL)
	
		set @v_amt=isnull(@v_amtcur,0)+ isnull(@debit_amt_030,0)+isnull(@debit_amt_3160,0)+isnull(@debit_amt_6190,0)+isnull(@debit_amt_91120,0)+isnull(@debit_amt_121180,0)+isnull(@debit_amt_181,0)

		if @v_amt=0 begin
			set @debit_amt_030    = 0
			set @debit_amt_3160   = 0
			set @debit_amt_6190   = 0
			set @debit_amt_91120  = 0
			set @debit_amt_121180 = 0
			set @debit_amt_181    = 0
			set @rcpt_pending_amt = 0
		end
		else
		begin
			set @rcpt_pending_amt=isnull(@v_pending_rcpt_amount,0)
			set @bill_pending_amt=isnull(@v_amt,0)
		end
		print('zzz')
		insert into #cir_temp_ageing (comp_code,unit_code,agcd,dpcd,ag_name,
                city_name,pending_amt,CUR_AMT
                , SLAB_1 ,slab_2,slab_3,slab_4,slab_5,slab_6,rect_pending,on_acamt,sessionid,PUBNAME,ageing)
        values (@rec_agency_comp_code,@punit_code,@rec_agency_agcd, @rec_agency_dpcd, @fetch_protype,
               @fetch_pubname,isnull(@bill_pending_amt,0),isnull(@v_amtcur,0)
               ,isnull(@debit_amt_030,0),isnull(@debit_amt_3160,0), isnull(@debit_amt_6190,0)
               ,isnull(@debit_amt_91120,0), isnull(@debit_amt_121180,0), isnull(@debit_amt_181,0),
               isnull(@rcpt_pending_amt,0),0,@@spid,@fetch_pubtype,@rec_agency_ageing_type);
		print('xxx')
		fetch NEXT FROM cur_agency INTO @fetch_pub
		    set @debit_amt_030    = 0
			set @debit_amt_3160   = 0
			set @debit_amt_6190   = 0
			set @debit_amt_91120  = 0
			set @debit_amt_121180 = 0
			set @debit_amt_181    = 0
			set @rcpt_pending_amt = 0
			set @bill_pending_amt = 0
		end
		
close cur_agency;
deallocate cur_agency


fetch NEXT FROM cur_agency_1 INTO @rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name,@rec_agency_city_code,@rec_agency_city_name,@rec_agency_credit_days,@rec_agency_branch_name,@rec_agency_ageing_type
end
close cur_agency_1		
deallocate cur_agency_1



select comp_code,unit_code,agcd,dpcd,ag_name PRO_TYPE,PUBNAME--,city_name PUBL_NAME
,sum(isnull(pending_amt,0)) pending_amt,sum(isnull(cur_amt,0)) cur_amt,sum(isnull(slab_1,0)) slab_1,sum(isnull(slab_2,0)) slab_2
,sum(isnull(slab_3,0)) slab_3,sum(isnull(slab_4,0)) slab_4,sum(isnull(slab_5,0)) slab_5,sum(isnull(slab_6,0)) slab_6,sum(isnull(rect_pending,0)) rect_pending
,ageing
from #cir_temp_ageing group by #cir_temp_ageing.COMP_CODE,#cir_temp_ageing.UNIT_CODE,#cir_temp_ageing.AGCD,#cir_temp_ageing.DPCD
,#cir_temp_ageing.AG_NAME,PUBNAME,ageing
order by ag_name;


select SUM(abs(isnull(amount,0))) as SEC_ONDT from CIR_RCPHDR where COMP_CODE=@pcomp_code 
and (UNIT_CODE=@punit_code or @punit_code is null or @punit_code ='')
and (AGCD=@pag_main_code or @pag_main_code is null or @pag_main_code ='')
and (DPCD=@pag_sub_code or @pag_sub_code is null or @pag_sub_code ='')
and ACHD='SC'
group by comp_code,unit_code,agcd,dpcd

select SUM(abs(isnull(bg_amt,0))) as BG_ONDT from CIR_BANK_GUARANTEE where COMP_CODE=@pcomp_code 
and (UNIT_CODE=@punit_code or @punit_code is null or @punit_code ='')
and (AGCD=@pag_main_code or @pag_main_code is null or @pag_main_code ='')
and (DPCD=@pag_sub_code or @pag_sub_code is null or @pag_sub_code ='')
group by comp_code,unit_code,agcd,dpcd

 
drop table #cir_temp_ageing


///////////////////////////////////////////////////////////




ALTER
PROCEDURE [dbo].[cir_security_report]

(

@pcomp_code
VARCHAR(20) ,

@punit_code
VARCHAR(200) ,

@pbranch_code
VARCHAR(200) ,

@ppubl
VARCHAR(200) ,

@pedtn
VARCHAR(200) ,

@pagcd
VARCHAR(200) ,-- mandatory

@pdpcd
VARCHAR(200) ,-- mandatory

@pdate
VARCHAR(20) ,

@pdateformat
VARCHAR(200) ,

@ppubl_type
VARCHAR(200) ,

@pag_class
VARCHAR(200) ,

@pag_type
VARCHAR(200) ,

@proute
VARCHAR(200) ,

@pextra1
VARCHAR(200) ,

@pextra2
VARCHAR(200)

)

as

begin

create
table #cir_security

(

COMP_CODE
VARCHAR(20),

UNIT_CODE
VARCHAR(20),

PRO_TYPE
VARCHAR(20),

BILL_FREQ
VARCHAR(20),

publ
varchar(20),

edtn
varchar(20),

SUPPLY
INT,

RATE
NUMERIC(15,2),

GROSS_AMT
NUMERIC(15,2),

COMM_AMT
NUMERIC(15,2),

BILL_AMT
NUMERIC(15,2),

AGCD
VARCHAR(20),

DPCD
VARCHAR(20)

)

create
table #cir_security_dep

(

COMP_CODE
VARCHAR(20),

UNIT_CODE
VARCHAR(20),

AGCD
VARCHAR(20),

DPCD
VARCHAR(20),

AMOUNT
numeric(14,2),

BG_AMOUNT
numeric(14,2)

)

declare
@avg_sup as int

declare
@v_date as datetime

set
@v_date=dbo.convert_user_date('/',@pdate,@pdateformat)

declare
@day as int

declare
@v_day as varchar(3)

set
@v_day=upper(DATENAME(dw,@v_date) )

declare
@tot_sup_pro as int

declare
@v_rate_prod as numeric(14,2)

declare
@v_gross_prod as numeric(14,2)

declare
@v_net_prod as numeric(14,2)

declare
@v_com_prod as numeric(14,2)

declare
@v_com_type as varchar(1)

declare
@v1_comp_code varchar(20)

declare
@v1_unit varchar(20)

declare
@v1_pro_type varchar(20)

declare
@v1_publ as varchar(20)

declare
@v1_edtn as varchar(20)

declare
@v1_comm_code as varchar(20)

declare
@v1_billfreq varchar(1)

declare
@v_sec_ondt as numeric(14,2)

declare
@v_bgamt as numeric(14,2)

DECLARE c1 CURSOR for

select b.comp_code,b.unit,p.pro_type,b.publ,b.edtn,b.comm_code ,isnull(a.ageing_type,'F') as BILL_CYCLE

,a.AGCD,a.DPCD

from cir_supply b,cir_agmast a,cir_publ_mast p

where a.comp_code=b.comp_code and a.unit=b.unit

and a.agcd=b.agcd and a.dpcd=b.dpcd

and a.comp_code=p.comp_code and b.comp_code=p.comp_code

and b.publ=p.publ and b.comp_code=@pcomp_code

and (b.unit=@punit_code or @punit_code is null or @punit_code ='')

and (b.publ=@ppubl or @ppubl is null or @ppubl='')

and (b.edtn=@pedtn or @pedtn is null or @pedtn='')

and (b.agcd=@pagcd or @pagcd is null or @pagcd='' )

and (b.dpcd=@pdpcd or @pdpcd is null or @pdpcd='' )

and (p.pro_type=@ppubl_type or @ppubl_type is null or @ppubl_type='')

and (a.branch_code =@pbranch_code or @pbranch_code is null or @pbranch_code='')

and (a.ag_type=@pag_type or @pag_type is null or @pag_type='')

and (a.ag_class=@pag_class or @pag_class is null or @pag_class='')

and (b.route_code=@proute or @proute is null or @proute='' )

group by b.comp_code,b.unit,p.pro_type,b.publ,b.edtn,b.comm_code,a.ageing_type ,a.AGCD,a.DPCD

order by p.pro_type,a.AGCD,a.DPCD

print
('X')

DECLARE
c2 CURSOR for

select distinct a.comp_code,a.unit,a.AGCD,a.DPCD

from cir_agmast a

where a.comp_code=@pcomp_code

and (a.unit=@punit_code or @punit_code is null or @punit_code ='')

and (a.agcd=@pagcd or @pagcd is null or @pagcd='' )

and (a.dpcd=@pdpcd or @pdpcd is null or @pdpcd='' )

and (a.branch_code =@pbranch_code or @pbranch_code is null or @pbranch_code='')

and (a.ag_type=@pag_type or @pag_type is null or @pag_type='')

and (a.ag_class=@pag_class or @pag_class is null or @pag_class='')

order by a.AGCD,a.DPCD

DECLARE
c3 CURSOR for

select distinct a.comp_code,a.unit,a.AGCD,a.DPCD

from cir_agmast a

where a.comp_code=@pcomp_code

and (a.unit=@punit_code or @punit_code is null or @punit_code ='')

and (a.agcd=@pagcd or @pagcd is null or @pagcd='' )

and (a.dpcd=@pdpcd or @pdpcd is null or @pdpcd='' )

and (a.branch_code =@pbranch_code or @pbranch_code is null or @pbranch_code='')

and (a.ag_type=@pag_type or @pag_type is null or @pag_type='')

and (a.ag_class=@pag_class or @pag_class is null or @pag_class='')

order by a.AGCD,a.DPCD

open c1

fetch next from c1 into @v1_comp_code,@v1_unit,@v1_pro_type,@v1_publ,@v1_edtn,@v1_comm_code,@v1_billfreq,@pagcd,@pdpcd

while(@@fetch_status=0) begin

print('G')

if(@v1_billfreq='M') BEGIN

set @day=60

end

else if(@v1_billfreq='W') BEGIN

set @day=14

end

else BEGIN/*daily*/

set @day=7

end

if @v1_pro_type='M'

begin

set @day=90

end

select @avg_sup=SUM(isnull(sup_copy,0)) from cir_dbksup b where b.comp_code=@v1_comp_code

and b.unit_code=@v1_unit

and (b.publ=@v1_publ ) and EDTN=@v1_edtn

and (b.agcd=@pagcd or @pagcd is null or @pagcd='' )

and (b.dpcd=@pdpcd or @pdpcd is null or @pdpcd='' )

and b.SUPDATE=DATEADD(dd,-1,@v_date)

PRINT('1')

PRINT(@avg_sup)print(@v1_comm_code)print('AAA')

if @avg_sup is null or @avg_sup<1

begin

PRINT('2')

PRINT(@avg_sup)

select @avg_sup = case @v_day

when 'SUN' then SUM(isnull(base_supply,0)+ isnull(SUPPLY_SUN,0) )

when 'MON' then SUM(isnull(base_supply,0)+ isnull(SUPPLY_MON,0) )

when 'TUE' then SUM(isnull(base_supply,0)+ isnull(SUPPLY_TUE,0) )

when 'WED' then SUM(isnull(base_supply,0)+ isnull(SUPPLY_WED,0) )

when 'THU' then SUM(isnull(base_supply,0)+ isnull(SUPPLY_THU,0) )

when 'FRI' then SUM(isnull(base_supply,0)+ isnull(SUPPLY_FRI,0) )

when 'SAT' then SUM(isnull(base_supply,0)+ isnull(SUPPLY_SAT,0) ) end

from cir_supply b where b.comp_code=@v1_comp_code

and b.unit=@v1_unit and (b.publ=@v1_publ) and EDTN=@v1_edtn

and (b.agcd=@pagcd or @pagcd is null or @pagcd='' )

and (b.dpcd=@pdpcd or @pdpcd is null or @pdpcd='' )

end

PRINT('3')

PRINT(@avg_sup)

set @tot_sup_pro=@avg_sup*@day

select @v_rate_prod= case @v_day

when 'SUN' then SUM(isnull(SUN_RATE,0))

when 'MON' then SUM(isnull(MON_RATE,0))

when 'TUE' then SUM(isnull(TUE_RATE,0))

when 'WED' then SUM(isnull(WED_RATE,0))

when 'THU' then SUM(isnull(THU_RATE,0))

when 'FRI' then SUM(isnull(FRI_RATE,0))

when 'SAT' then SUM(isnull(SAT_RATE,0)) end

from CIR_RATE_MAST where COMP_CODE=@v1_comp_code and UNIT=@v1_unit and PUBL=@v1_publ and EDTN=@v1_edtn

select @v_com_prod=case @v_day

when 'SUN' then SUM(isnull(SUN_COMM_RATE,0))

when 'MON' then SUM(isnull(MON_COMM_RATE,0))

when 'TUE' then SUM(isnull(TUE_COMM_RATE,0))

when 'WED' then SUM(isnull(WED_COMM_RATE,0))

when 'THU' then SUM(isnull(THU_COMM_RATE,0))

when 'FRI' then SUM(isnull(FRI_COMM_RATE,0))

when 'SAT' then SUM(isnull(SAT_COMM_RATE,0)) end

,@v_com_type=COMM_CATG_TYPE from CIR_COMM_MAST

where COMP_CODE=@v1_comp_code and UNIT_CODE=@v1_unit and PUBL=@v1_publ and EDTN=@v1_edtn and COMM_CATG_CODE=@v1_comm_code

group by COMM_CATG_TYPE

set @v_gross_prod = isnull(@tot_sup_pro,0)*isnull(@v_rate_prod,0)

set @v_com_prod=isnull(@v_gross_prod,0)*ISNULL(@v_com_prod,0)/100

insert into #cir_security (COMP_CODE,UNIT_CODE,PRO_TYPE,BILL_FREQ,PUBL,EDTN,SUPPLY,RATE ,GROSS_AMT,COMM_AMT,BILL_AMT,AGCD,DPCD)

values (@v1_comp_code,@v1_unit,@v1_pro_type,@v1_billfreq,@v1_publ,@v1_edtn,@tot_sup_pro,@v_rate_prod,@v_gross_prod,@v_com_prod,ISNULL(@v_gross_prod,0)-ISNULL(@v_com_prod,0),@pagcd,@pdpcd )

fetch next from c1 into @v1_comp_code,@v1_unit,@v1_pro_type,@v1_publ,@v1_edtn,@v1_comm_code,@v1_billfreq,@pagcd,@pdpcd

end

close c1

deallocate c1

open c2

fetch next from c2 into @v1_comp_code,@v1_unit,@pagcd,@pdpcd

while(@@fetch_status=0) begin

print('G')

select @v_sec_ondt= SUM(abs(amount)) from CIR_RCPHDR where COMP_CODE =@pcomp_code

and (UNIT_CODE=@punit_code or @punit_code is null or @punit_code ='')

and AGCD=@pagcd and DPCD=@pdpcd and ACHD='SC'

select @v_bgamt=SUM(abs(bg_amt)) from CIR_BANK_GUARANTEE where COMP_CODE =@pcomp_code

and (UNIT_CODE=@punit_code or @punit_code is null or @punit_code ='')

and AGCD=@pagcd and DPCD=@pdpcd

insert into #cir_security_dep (COMP_CODE,UNIT_CODE,AGCD,DPCD,AMOUNT,BG_AMOUNT)

values(@v1_comp_code,@v1_unit,@pagcd,@pdpcd,@v_sec_ondt,@v_bgamt)

fetch next from c2 into @v1_comp_code,@v1_unit,@pagcd,@pdpcd

end

close c2

deallocate c2

declare
@v_sec_fund as numeric(14,2)

declare
@v_sec_reqd as numeric(14,2)

create
table #temp_code

(

agcd_i
varchar(10),

dpcd_i
varchar(10),

agcd_m
varchar(10),

dpcd_m
varchar(10)

)

open c3

fetch next from c3 into @v1_comp_code,@v1_unit,@pagcd,@pdpcd

while(@@fetch_status=0) begin

print('G')

select @v_sec_reqd=SUM(isnull(BILL_AMT,0)) from #cir_security where COMP_CODE=@v1_comp_code and UNIT_CODE=@v1_unit and AGCD=@pagcd and DPCD=@pdpcd

select @v_sec_fund=SUM(isnull(abs(amount),0)) from #cir_security_dep where COMP_CODE=@v1_comp_code and UNIT_CODE=@v1_unit and AGCD=@pagcd and DPCD=@pdpcd

select @v_bgamt=SUM(abs(bg_amt)) from CIR_BANK_GUARANTEE where COMP_CODE =@pcomp_code

and (UNIT_CODE=@punit_code or @punit_code is null or @punit_code ='')

and AGCD=@pagcd and DPCD=@pdpcd

print('RRR')print(@v_sec_reqd)print(@v_sec_fund) print('ZZZ')

if @v_sec_reqd >= (isnull(@v_sec_fund,0)+ISNULL(@v_bgamt,0) )

begin

insert into #temp_code(agcd_i,dpcd_i) values(@pagcd,@pdpcd)

end

else

begin

insert into #temp_code(agcd_m,dpcd_m) values(@pagcd,@pdpcd)

end

fetch next from c3 into @v1_comp_code,@v1_unit,@pagcd,@pdpcd

end

close c3

deallocate c3

--select * from #temp_code

if @pextra1 is null or @pextra1 ='' or @pextra1 ='S'

begin

select COMP_CODE,UNIT_CODE

,(select distinct pubname from pub_type_mast x where x.Comp_Code=#cir_security.COMP_CODE and x.pubtypecode=#cir_security.PRO_TYPE ) PRO_TYPE

,BILL_FREQ ,SUM(isnull(SUPPLY,0)) as SUPPLY

,SUM(isnull(GROSS_AMT,0)) GROSS_AMT,SUM(isnull(COMM_AMT,0)) COMM_AMT,SUM(isnull(BILL_AMT,0)) REQ_SEC ,AGCD,DPCD

from #cir_security

group by COMP_CODE,UNIT_CODE,PRO_TYPE,BILL_FREQ,AGCD,DPCD

select SUM(abs(amount)) as DEP_ONDT,SUM(BG_AMOUNT) as BG_ONDT,AGCD,DPCD from #cir_security_dep

group by AGCD,DPCD

end

else if @pextra1 ='D'

begin

select COMP_CODE,UNIT_CODE

,(select distinct pubname from pub_type_mast x where x.Comp_Code=#cir_security.COMP_CODE and x.pubtypecode=#cir_security.PRO_TYPE ) PRO_TYPE

,BILL_FREQ,PUBL,EDTN,SUPPLY,GROSS_AMT,COMM_AMT,BILL_AMT REQ_SEC,AGCD,DPCD

,dbo.cir_get_agency(comp_code,unit_code,agcd,dpcd) as AGENCY

,dbo.cir_get_publ_name(comp_code,publ) as PUBNAME

,dbo.cir_get_edtn_name(comp_code,edtn) as EDTNNAME

from #cir_security order by AGCD,DPCD,3

select SUM(abs(amount)) as DEP_ONDT,SUM(BG_AMOUNT) as BG_ONDT,AGCD,DPCD from #cir_security_dep

group by AGCD,DPCD

end

else if @pextra1 ='I'

begin

select t.COMP_CODE,t.UNIT_CODE

-- ,(select distinct pubname from pub_type_mast x where x.Comp_Code=t.COMP_CODE and x.pubtypecode=t.PRO_TYPE ) PRO_TYPE

,t.BILL_FREQ ,SUM(isnull(t.SUPPLY,0)) as SUPPLY

,SUM(isnull(t.GROSS_AMT,0)) GROSS_AMT,SUM(isnull(t.COMM_AMT,0)) COMM_AMT,SUM(isnull(t.BILL_AMT,0)) REQ_SEC ,t.AGCD,t.DPCD

,isnull(abs(y.amount),0) as DEP_ONDT

,isnull(abs(BG_AMOUNT),0) as BG_ONDT

,dbo.cir_get_agency(t.comp_code,t.unit_code,t.agcd,t.DPCD) as AGENCY

from #cir_security t,#cir_security_dep y where t.COMP_CODE=y.COMP_CODE

and t.UNIT_CODE=y.UNIT_CODE and t.AGCD=y.AGCD and t.DPCD=y.DPCD and

t
.AGCD in(Select distinct agcd_i from #temp_code) and t.DPCD in(Select distinct dpcd_i from #temp_code)

group by t.COMP_CODE,t.UNIT_CODE,t.BILL_FREQ,t.AGCD,t.DPCD,y.amount,BG_AMOUNT

/* select SUM(bg_amt) as BG_ONDT,AGCD,DPCD from CIR_BANK_GUARANTEE

where AGCD in(Select distinct agcd_i from #temp_code) and DPCD in(Select distinct dpcd_i from #temp_code)

group by comp_code,AGCD,DPCD

select COMP_CODE,UNIT_CODE

,(select distinct pubname from pub_type_mast x where x.Comp_Code=#cir_security.COMP_CODE and x.pubtypecode=#cir_security.PRO_TYPE ) PRO_TYPE

,BILL_FREQ ,SUM(isnull(SUPPLY,0)) as SUPPLY

,SUM(isnull(GROSS_AMT,0)) GROSS_AMT,SUM(isnull(COMM_AMT,0)) COMM_AMT,SUM(isnull(BILL_AMT,0)) REQ_SEC ,AGCD,DPCD

from #cir_security where AGCD in(Select distinct agcd_i from #temp_code) and DPCD in(Select distinct dpcd_i from #temp_code)

group by COMP_CODE,UNIT_CODE,PRO_TYPE,BILL_FREQ,AGCD,DPCD

select SUM(amount) as DEP_ONDT,AGCD,DPCD from #cir_security_dep

where AGCD in(Select distinct agcd_i from #temp_code) and DPCD in(Select distinct dpcd_i from #temp_code)

group by AGCD,DPCD */

end

else if @pextra1 ='M'

begin

select t.COMP_CODE,t.UNIT_CODE

--,(select distinct pubname from pub_type_mast x where x.Comp_Code=t.COMP_CODE and x.pubtypecode=t.PRO_TYPE ) PRO_TYPE

,t.BILL_FREQ ,SUM(isnull(t.SUPPLY,0)) as SUPPLY

,SUM(isnull(t.GROSS_AMT,0)) GROSS_AMT,SUM(isnull(t.COMM_AMT,0)) COMM_AMT,SUM(isnull(t.BILL_AMT,0)) REQ_SEC ,t.AGCD,t.DPCD

,isnull(abs(y.amount),0) as DEP_ONDT

,isnull(abs(BG_AMOUNT),0) as BG_ONDT

,dbo.cir_get_agency(t.comp_code,t.unit_code,t.agcd,t.DPCD) as AGENCY

from #cir_security t,#cir_security_dep y where t.COMP_CODE=y.COMP_CODE

and t.UNIT_CODE=y.UNIT_CODE and t.AGCD=y.AGCD and t.DPCD=y.DPCD and

t
.AGCD in(Select distinct agcd_m from #temp_code) and t.DPCD in(Select distinct dpcd_m from #temp_code)

group by t.COMP_CODE,t.UNIT_CODE,t.BILL_FREQ,t.AGCD,t.DPCD,y.amount,BG_AMOUNT

/* select SUM(bg_amt) as BG_ONDT,AGCD,DPCD from CIR_BANK_GUARANTEE

where AGCD in(Select distinct agcd_m from #temp_code) and DPCD in(Select distinct dpcd_m from #temp_code)

group by comp_code,AGCD,DPCD

select COMP_CODE,UNIT_CODE

,(select distinct pubname from pub_type_mast x where x.Comp_Code=#cir_security.COMP_CODE and x.pubtypecode=#cir_security.PRO_TYPE ) PRO_TYPE

,BILL_FREQ ,SUM(isnull(SUPPLY,0)) as SUPPLY

,SUM(isnull(GROSS_AMT,0)) GROSS_AMT,SUM(isnull(COMM_AMT,0)) COMM_AMT,SUM(isnull(BILL_AMT,0)) REQ_SEC ,AGCD,DPCD

from #cir_security

where AGCD in(Select distinct agcd_m from #temp_code) and DPCD in(Select distinct dpcd_m from #temp_code)

group by COMP_CODE,UNIT_CODE,PRO_TYPE,BILL_FREQ,AGCD,DPCD

select SUM(amount) as DEP_ONDT,AGCD,DPCD from #cir_security_dep

where AGCD in(Select distinct agcd_m from #temp_code) and DPCD in(Select distinct dpcd_m from #temp_code)

group by AGCD,DPCD

*/

end

drop table #cir_security_dep

drop table #cir_security

drop table #temp_code

end

////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////end all procedures////////////////////////////////////////////////////


////////////////////////////////////add by Deepika 18/09/2012////////////////////////////////////


ALTER Procedure [dbo].[cir_branch_detail_p]
     @pcompcode          VARCHAR(40) ,
     @pbrancode          VARCHAR(40) ,
     @plangtype          VARCHAR(40) ,---1 for enlish and 2 for other language
     @pdateformat        VARCHAR(40) ,
     @pextra1            VARCHAR(400) ,
     @pextra2            VARCHAR(400) 


  As

    select branch_mst.*,(select distinct City_Name from city_mst where city_mst.comp_code=@pcompcode and
    City_Code=branch_mst.City_Code) CITY_NAME,
    (SELECT distinct Country_Name FROM count_mst where count_mst.comp_code=@pcompcode and
    Country_Code=branch_mst.Country_Code) COUNTRY_NAME 
    from branch_mst 
    where (Branch_Code=@pbrancode or @pbrancode is null or @pbrancode = '')
    order by Comp_Code,Branch_Name;

  ////////////////////////////////////////////////////////


ALTER procedure [dbo].[cir_fetch_late_rate]
    @pcompcode       as varchar(200),
    @punitcode       as varchar(200),
    @ppublcode       as varchar(200),
    @pfromdate       as datetime, 
    @ptilldate       as datetime,
    @puserid         as varchar(200), 
    @pdateformate    as varchar(200),
    @pextra1         as varchar(200),
    @pextra2         as varchar(200),
    @pextra3         as varchar(200),
    @pextra4         as varchar(200),
    @pextra5         as varchar(200)
as

begin 

    declare @v_dt			as datetime
    declare @v_day			as varchar(20)
    declare @v_rate			as numeric(14,2)
    declare @v_rate_type	as varchar(20)
    declare @v_recno		as int
    declare @v1_comp_code	as varchar(20)
    declare @v1_unit_code	as varchar(20)
    declare @v1_publ_code	as varchar(20)
    declare @v1_publ_name	as varchar(200)
    declare @v1_main_edtn	as varchar(20)
    declare @v1_main_edtn_name as varchar(200)
    declare @v1_edtn		as varchar(20)
    declare @v1_edtn_name	as varchar(200)
    declare @v1_valid_from	as datetime
    declare @v1_valid_till	as datetime
    declare @v1_sun_rate	as numeric(14,2)
    declare @v1_mon_rate	as numeric(14,2)
    declare @v1_tue_rate	as numeric(14,2)
    declare @v1_wed_rate	as numeric(14,2)
    declare @v1_thu_rate	as numeric(14,2)
    declare @v1_fri_rate	as numeric(14,2)
    declare @v1_sat_rate	as numeric(14,2)
    
    declare @v_from_date as datetime
    declare @v_till_date as datetime
    
    set @v_from_date=@pfromdate
    set @v_till_date=@ptilldate
    
    declare c1 cursor for
    SELECT DISTINCT L.COMP_CODE COMP_CODE,L.UNIT_CODE UNIT_CODE,L.PUBL_CODE PUBL_CODE,P.PUBL_NAME PUBL_NAME,E.MAIN_EDTN MAIN_EDTN,
    DBO.CIR_GET_EDTN_NAME(L.COMP_CODE,E.MAIN_EDTN) MAIN_EDTN_NAME,
    L.EDTN_CODE EDTN,E.EDTN_NAME EDTN_NAME,max(L.VALID_FROM) VALID_FROM,
    L.SUN_RATE,L.MON_RATE,L.TUE_RATE,L.WED_RATE,L.THU_RATE,L.FRI_RATE,L.SAT_RATE,L.RATE_TYPE
    from cir_publ_mast p,cir_edtn_mast e,cir_late_fee_mast l
    where p.comp_code=e.comp_code and p.comp_code=l.comp_code and p.comp_code=@pcompcode and
        p.publ=e.publ and p.publ=l.publ_code and (p.publ=@ppublcode or @ppublcode is null or @ppublcode='') and 
        (l.unit_code=@punitcode or @punitcode is null or @punitcode='') and e.edtn=l.edtn_code and
        --valid_from between @v_from_date and @v_till_date
        valid_from <= @v_from_date --and @v_till_date
group by L.COMP_CODE,L.UNIT_CODE,L.PUBL_CODE,P.PUBL_NAME,E.MAIN_EDTN,L.EDTN_CODE,E.EDTN_NAME,L.SUN_RATE
,L.MON_RATE,L.TUE_RATE,L.WED_RATE,L.THU_RATE,L.FRI_RATE,L.SAT_RATE,L.RATE_TYPE



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
	ZONE_CODE        VARCHAR(500),
	REGION_CODE      VARCHAR(500),
	PRO_TYPE         VARCHAR(500),
	COMM_CODE        VARCHAR(500),
	ROUTE_CODE       VARCHAR(500),
	PRINTING_CENT_CODE  VARCHAR(500),
	SUPPLY_AVG_TODT     NUMERIC(15,2),
	RETURN_AVG_TODT     NUMERIC(15,2),
	NET_AVG_TODT        NUMERIC(15,2),
	PER_AVG_TODT        NUMERIC(15,2),
	BILL_COUNT			INT
  )
  
  
        
        
declare @loop as int
set @loop=2
	open c1
        fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_publ_code,@v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,
			@v1_edtn,@v1_edtn_name,@v1_valid_from,
			@v1_sun_rate,@v1_mon_rate,@v1_tue_rate,@v1_wed_rate,@v1_thu_rate,@v1_fri_rate,@v1_sat_rate,@v_rate_type
        WHILE (@@FETCH_STATUS = 0) 
		BEGIN
        set @v_dt=@v_from_date
			
			while @loop!=1
			begin	
				--if @v1_valid_from between @v_dt and @v_dt
				if @v1_valid_from <= @v_dt-- and @v_dt
				Begin

					set @v_day=CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @v_dt),20)
					if @v_day='Sunday' Begin 
					   set @v_rate=@v1_sun_rate
					End    
					Else if @v_day='Monday' Begin
						set @v_rate=@v1_mon_rate
					End    
					Else if @v_day='Tuesday' Begin
						set @v_rate=@v1_tue_rate
					End 
					Else If @v_day='Wednesday' Begin
						set @v_rate=@v1_wed_rate
					End    
					Else If @v_day='Thursday' Begin
						set @v_rate=@v1_thu_rate
					End    
					Else if @v_day='Friday' Begin
						set @v_rate=@v1_fri_rate
					End
					Else Begin
						set @v_rate=@v1_sat_rate
					End

					insert into #cir_temp_bill_collection
						(comp_code, unit_code, billno,publ_code, agcd, dpcd,agname,agname_oth_lang, 
                    city_code,billdt,comm_amt,cur_sessionid)
					values(@v1_comp_code,@v1_unit_code,@v1_publ_code,@v1_publ_name,@v1_main_edtn,@v1_edtn,@v1_main_edtn_name,@v1_edtn_name,
                    @v_rate_type,@v_dt,@v_rate,@@spid)
                    print('x')
                   
				end
				 set @v_dt=dateadd(dd,1,@v_dt); 
				print('@v_dt')print(@v_day)
				print(@loop) print(@v_dt)
				if @v_dt>@v_till_date begin
					set @loop=1
				end		
			end
			
				
        fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_publ_code,@v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,
			@v1_edtn,@v1_edtn_name,@v1_valid_from,
			@v1_sun_rate,@v1_mon_rate,@v1_tue_rate,@v1_wed_rate,@v1_thu_rate,@v1_fri_rate,@v1_sat_rate,@v_rate_type        
    end
    close c1;
    deallocate c1
                
    select comp_code AS COMP_CODE, unit_code AS UNIT_CODE, billno as PUBL_CODE,publ_code AS PUBL_NAME, agcd AS MAIN_EDTN, dpcd AS EDTN,
    agname AS MAIN_EDTN_NAME,agname_oth_lang AS EDTN_NAME, city_code AS RATE_TYPE, 
    billdt AS ISSUE_DATE ,comm_amt AS LATE_FEE 
    from #cir_temp_bill_collection  where cur_sessionid=@@SPID
    order by unit_code,publ_name,main_edtn_name,edtn_name,issue_date;
    drop table #cir_temp_bill_collection

End


/////////////////////////////////////////////////////////////////////

create FUNCTION  [dbo].[cir_get_agclass_name] (@pcomp_code as varchar(100),@pagcode as varchar(100))  returns varchar(200)

AS  

BEGIN 
DECLARE @vagclass_name VARCHAR(4000)
select @vagclass_name= CLASS_DESC from cir_agency_class_mast  where comp_code=@pcomp_code and class_code=@pagcode
	   
RETURN isnull(@vagclass_name,'')
END


/////////////////////////////////////////////////////////////////////

create FUNCTION  [dbo].[cir_get_agtype_name] (@pcomp_code as varchar(100),@pagcode as varchar(100))  returns varchar(200)

AS  

BEGIN 
DECLARE @vagclass_name VARCHAR(4000)
select @vagclass_name= AGENCY_TYPE_DESC from CIR_AGENCY_TYP_MAST   where comp_code=@pcomp_code and agency_type_code=@pagcode
	   
RETURN isnull(@vagclass_name,'')
END



//////////////////////////////////////////////////////////////////////////////

ALTER procedure [dbo].[cir_late_factor_aglist]
    @pcompcode       as varchar(200),
    @punitcode       as varchar(200),
    @ppublcode       as varchar(200),
    @pissuedate      as datetime, 
    @platerate			 as numeric(14,2), 
    @puserid         as varchar(200), 
    @pdateformate    as varchar(200),
    @processby       as varchar(200),---- 1/branch , 2/route , 3/zone , 4/region , 5/district
    @pvar_sel		 as varchar(max),---- value in ['a','b','c','d'] format
    @pagcd			 as varchar(20),
    @pdpcd			 as varchar(20),
    @pagtype		 as varchar(20),
    @pagclass    	 as varchar(20),
    @psuptype		 as varchar(20),
    @preason 		 as varchar(20),
    @pextra1         as varchar(200),
    @pextra2         as varchar(200),
    @pextra3         as varchar(200),
    @pextra4         as varchar(200),
    @pextra5         as varchar(200)
as
    
begin

declare @v1_agcd as varchar(20)
declare @v1_dpcd as varchar(20)
declare @v1_branch_code as varchar(20)
declare @v1_ag_type as varchar(20)
declare @v1_ag_class as varchar(20)
declare @v1_ag_name as varchar(200)
declare @v1_station_code as varchar(20)
declare @v1_route_code as varchar(20)
declare @v1_billagcd as varchar(20)
create table #Results(SegmentNum INT, Edition_Name  VARCHAR(255))

insert into #Results select * from dbo.Fn_Splitfield(@pvar_sel,',')

    declare c1 cursor for
		select distinct a.agcd,a.dpcd,dbo.cir_get_agency(@pcompcode,@punitcode,a.BILL_AGCD,a.BILL_DPCD)as billagname,a.branch_code,a.ag_type,a.ag_class,a.ag_name,a.station_code,b.route_code 
		from cir_agmast a,cir_supply b
		where a.comp_code=@pcompcode 
		and a.comp_code=b.comp_code and a.agcd=b.agcd and a.dpcd=b.dpcd --and a.unit=b.unit
		and isnull(b.late_fee,'N')='Y'
		and (a.unit= @punitcode or @punitcode is null or @punitcode ='')    
		and (
			(@processby='1' and a.branch_code in (select Edition_Name from #Results) ) or
			(@processby='2' and b.route_code in (select Edition_Name from #Results)  ) or
			(@processby='3' and dbo.cir_get_zone_by_city(a.comp_code,a.city_code,'C') in (select Edition_Name from #Results) ) or
			(@processby='4' and dbo.cir_get_region_by_city(a.comp_code,a.city_code,'C') in (select Edition_Name from #Results) ) or
			(@processby='5' and a.dist_code   in (select Edition_Name from #Results) )
			)
		and (a.agcd=@pagcd or @pagcd is null or @pagcd ='')
		and (a.dpcd=@pdpcd or @pdpcd is null or @pdpcd ='')
		and (a.ag_type=@pagtype or @pagtype is null or @pagtype ='')
		and (a.ag_class=@pagclass or @pagclass is null or @pagclass ='')
		and (b.publ=@ppublcode or @ppublcode is null or @ppublcode='')
    


   CREATE TABLE #CIR_late_factor_fee
	(COMP_CODE       VARCHAR(100),
	UNIT_CODE        VARCHAR(100),	
	BRANCH_CODE      varchar(200),
	AGCD             VARCHAR(100),
	DPCD             VARCHAR(100),
	BILL_AGNAME        VARCHAR(100),
	AGNAME           VARCHAR(250),
	AG_TYPE          VARCHAR(20),
	AG_CLASS         VARCHAR(20),
	AG_DROP          VARCHAR(20),
	AG_ROUTE         VARCHAR(20),
	ISSUE_DAY        VARCHAR(20),	
	ISSUE_DT         DATETIME,
	SUPPLY_COPY      NUMERIC(10)                   DEFAULT 0,
	LATE_RATE        NUMERIC(15,2)                 DEFAULT 0,
	LATE_AMT         NUMERIC(15,2)                 DEFAULT 0,
	lateby			 varchar(5),
	dep_time		 varchar(5),
	act_dep_time     varchar(5)
	)

    
declare @vsecond as numeric(14)
declare @v_time_line as varchar(20)
declare @v_supply as numeric(14)
declare @v_day as varchar(20)
declare @v_dep_time as varchar(5)
declare @v_exp_dep as varchar(5)
declare @vtimediff as varchar(6)
set @v_day=CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @pissuedate),20)


open c1
        fetch NEXT FROM c1 INTO @v1_agcd,@v1_dpcd,@v1_billagcd,@v1_branch_code,@v1_ag_type,@v1_ag_class,@v1_ag_name,@v1_station_code,@v1_route_code
     
        WHILE (@@FETCH_STATUS = 0) 
		BEGIN
		print(@v1_route_code)
		print(@pissuedate)
		
		select @v_time_line=isnull(time_line,'00:00') from cir_route_mast where comp_code=@pcompcode 
		and unit=@punitcode and route_code=@v1_route_code
			
		select distinct @v_exp_dep=EXP_DEP_TIME,@v_dep_time=DEP_TIME, @vtimediff=replace(DBO.time_diff(dep_time, exp_dep_time),'S','') from CIR_ROUTE_TAXI_MAST
		where comp_code=@pcompcode and (unit_code=@punitcode or @punitcode is null or @punitcode='')
		and route_code=	@v1_route_code and dep_date= @pissuedate
		
		print(@v_time_line)	
		print(@v_exp_dep)	
		print(@v_dep_time)
		print(@vtimediff)
		print('22222222222')
		print(@v_day)
		if @v_day='Sunday' Begin 
		   select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_sun,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (publ=@psuptype or @psuptype is null or @psuptype ='')
		   
		End    
		Else if @v_day='Monday' Begin
			select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_mon,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (publ=@psuptype or @psuptype is null or @psuptype ='')
		End    
		Else if @v_day='Tuesday' Begin
			select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_tue,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (publ=@psuptype or @psuptype is null or @psuptype ='')
		End 
		Else If @v_day='Wednesday' Begin
			select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_wed,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (publ=@psuptype or @psuptype is null or @psuptype ='')
		End    
		Else If @v_day='Thursday' Begin
			select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_thu,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (publ=@psuptype or @psuptype is null or @psuptype ='')
		End    
		Else if @v_day='Friday' Begin
			select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_fri,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (publ=@psuptype or @psuptype is null or @psuptype ='')
		End
		Else Begin
			select distinct @v_supply=sum(isnull(base_supply,0))+sum(isnull(supply_sat,0)) from cir_supply 
		   where comp_code=@pcompcode and (unit=@punitcode or @punitcode is null or @punitcode='')
		   and agcd=@v1_agcd and dpcd=@v1_dpcd 
		   and (publ=@ppublcode or @ppublcode is null or @ppublcode ='')
		   and (publ=@psuptype or @psuptype is null or @psuptype ='')
		End
		print('X')print(@v_dep_time)print(@v_time_line)print('Z')
		set @vsecond=datediff(ss,@v_time_line,@v_dep_time )	
		
		print('debug')

		print(@v_supply)
		print('3434')
		print(@vsecond)
		print('end')
		
		if @vsecond >0 begin
			insert into #CIR_late_factor_fee
				(COMP_CODE, UNIT_CODE, BRANCH_CODE,AGCD, DPCD,BILL_AGNAME, AGNAME,AG_TYPE,AG_CLASS, 
			AG_DROP,AG_ROUTE,ISSUE_DAY,ISSUE_DT,SUPPLY_COPY,LATE_RATE,LATE_AMT,lateby,dep_time,act_dep_time)
			values(@pcompcode,@punitcode,@v1_branch_code,@v1_agcd,@v1_dpcd,@v1_billagcd,@v1_ag_name,@v1_ag_type,@v1_ag_class,
			@v1_station_code,@v1_route_code,upper(@v_day),@pissuedate,@v_supply,@platerate,isnull(@v_supply,0)*isnull(@platerate,0)
			,@vtimediff,@v_dep_time,@v_exp_dep)
		end
			
        fetch NEXT FROM c1 INTO @v1_agcd,@v1_dpcd,@v1_billagcd,@v1_branch_code,@v1_ag_type,@v1_ag_class,@v1_ag_name,@v1_station_code,@v1_route_code
    end
    close c1;
    deallocate c1
     
     select * from #CIR_late_factor_fee
           
select COMP_CODE, UNIT_CODE,--dbo.cir_get_unit_name(COMP_CODE,UNIT_CODE) as UNIT, 
BRANCH_CODE,dbo.cir_get_branch(COMP_CODE,BRANCH_CODE) BRANCH ,
AGCD, DPCD,BILL_AGNAME, AGNAME,AG_TYPE,AG_CLASS, 
AG_DROP,AG_ROUTE,dbo.cir_get_route_name(COMP_CODE,UNIT_CODE,AG_ROUTE) ROUTE
,ISSUE_DAY,ISSUE_DT,SUPPLY_COPY,LATE_RATE,LATE_AMT,lateby 
,dep_time,act_dep_time,dbo.cir_get_drop_point_name(COMP_CODE,UNIT_CODE,AG_DROP,'1') AG_DROP_NAME
from #CIR_late_factor_fee x
where x.comp_code+x.AGCD+x.DPCD--+CAST(ISSUE_DT as varchar) 
not in
(select t.comp_code+t.AGCD+t.DPCD from cir_late_factor_fee_process t --+CAST(ISSUE_DT as varchar)
where t.comp_code=@pcompcode and t.docno is not null and t.docdt is not null and t.flag='Y' )


drop table #CIR_late_factor_fee
drop table #Results
End


//////////////////////////////////////////////////////////////

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
    
	select  m.comp_code as "COMP_CODE", m.unit as "UNIT", m.agcd as "AGCD", m.dpcd as "DPCD",m.ag_name as "AG_NAME",
	m.station_code as "DROP_POINT",dbo.cir_get_drop_point_name(m.comp_code,m.unit,m.station_code,1) as "DROP_POINT_NAME", 
	m.city_code as "CITY_CODE", dbo.cir_get_city(m.comp_code,m.city_code) as "CITY_NAME", s.publ as "PUBL",p.publ_name as "PUBL_NAME", 
	e.main_edtn as "MAIN_EDTN",dbo.cir_get_edtn_name(m.comp_code,e.main_edtn) as "MAIN_EDTN_NAME", 
	s.edtn as "EDTN",e.edtn_name as "EDTN_NAME", s.supply_flag as "SUPPLY_FLAG", s.supply_type_code as "SUPPLY_TYPE_CODE"
	,t.sup_ty_name as "SUP_TY_NAME", s.base_supply as "BASE_SUPPLY", s.supply_sun as "SUPPLY_SUN", s.supply_mon as "SUPPLY_MON"
	, s.supply_tue as "SUPPLY_TUE", s.supply_wed as "SUPPLY_WED",s.supply_thu as "SUPPLY_THU", s.supply_fri as "SUPPLY_FRI"
	, s.supply_sat as "SUPPLY_SAT", s.supply_spl1 as "SUPPLY_SPL1", s.supply_spl2 as "SUPPLY_SPL2",
	case @pdateformat
	when 'mm/dd/yyyy' then convert(varchar(10),m.SUSPEND_DATE,101) 
	when 'dd/mm/yyyy' then convert(varchar(10),m.SUSPEND_DATE,103) 
	when 'yyyy/mm/dd' then convert(varchar(10),m.SUSPEND_DATE,111)  end as "SUSPEND_DATE" ,
	dbo.get_suspend_type(m.suspend_type) as"SUSPEND_TYPE"
	from cir_supply s,cir_agmast m,cir_publ_mast p,cir_edtn_mast e,cir_supply_type_mast t
	where m.comp_code=s.comp_code and m.comp_code=p.comp_code and m.comp_code=e.comp_code and m.comp_code=t.comp_code and m.comp_code=isnull(@pcomp_code,m.comp_code) 
	and    m.unit=s.unit 
	and (m.unit=isnull(@punit_code,m.unit) or @punit_code ='')
	and m.agcd=s.agcd and  m.dpcd=s.dpcd and s.publ=p.publ 
	and (s.publ=isnull(@ppubl,s.publ) or @ppubl ='')
	and s.edtn=e.edtn 
	and s.supply_type_code=t.sup_ty_code 
	and isnull(m.freeze_flag,'N') ='N' and isnull(m.suspend,'N')='Y'
	order by comp_code,unit,city_name,drop_point_name,ag_name,publ_name,main_edtn_name,edtn_name,sup_ty_name;    
End




//////////////////////////////////////////////////////////end//////////////////////////////////////////////
/*sent by sushil sir*/
ALTER PROCEDURE [dbo].[cir_zone_region_bind_new]
@pcompcode as varchar(20),
@pzonecode as varchar(1000),
@preg_code as varchar(1000),
@pdateformat as varchar(20),
@puserid as varchar(20),
@pextra1 as varchar(20),
@pextra2 as varchar(20)
as
begin
declare @v_str	 varchar(4000)
declare @v_zonecode varchar(1000)
print(@pzonecode)
If @pzonecode is not null or @pzonecode<>'' Begin
set @v_zonecode=''''+replace(@pzonecode,',',''',''')+''''
End
If @pzonecode is null or @pzonecode='' Begin
set @v_str='select cir_region_mast.*,dbo.cir_get_zone_name(cir_region_mast.comp_code,cir_region_mast.zone_code) zone_name
from cir_region_mast
where comp_code='
+''''+@pcompcode+''''+' and
(cir_region_mast.reg_code ='
+''''+@preg_code+''''+' or '+''''+@preg_code+''''+' is null)
order by cir_region_mast.reg_code'
End

Else Begin
print(@preg_code)
set @v_str='select cir_region_mast.*,dbo.cir_get_zone_name(cir_region_mast.comp_code,cir_region_mast.zone_code) zone_name
from cir_region_mast
where comp_code='
+''''+@pcompcode+''''+' and zone_code in ('+@v_zonecode+')
order by cir_region_mast.reg_code'
/* (cir_region_mast.reg_code ='+''''+@preg_code+''''+' or '+''''+@preg_code+''''+' is NULL ) */

print (@v_str)
End
print(@v_str)
exec(@v_str)
End



/*sent by sushil sir*/
/*********CREDIT RATING***********/


ALTER PROCEDURE [dbo].[cir_credit_rating_security_report]
(
	@pcomp_code                         VARCHAR(20) ,
	@punit_code                         VARCHAR(200) ,
	@pbranch_code                       VARCHAR(200) ,
	@ppubl                              VARCHAR(200) ,
	@pedtn                              VARCHAR(200) ,
	@pagcd                              VARCHAR(200) ,-- mandatory
	@pdpcd                              VARCHAR(200) ,-- mandatory
	@pdate                              VARCHAR(20) ,
	@pdateformat                        VARCHAR(200) ,
	@ppubl_type                         VARCHAR(200) ,
	@pag_class                          VARCHAR(200) ,
	@pag_type                           VARCHAR(200) ,
	@proute                             VARCHAR(200) ,
	@pextra1                            VARCHAR(200) ,
	@pextra2                            VARCHAR(200) 
)
as
begin
create table #cir_security
(
COMP_CODE VARCHAR(20),
UNIT_CODE VARCHAR(20),
PRO_TYPE VARCHAR(20),
BILL_FREQ VARCHAR(20),
publ varchar(20),
edtn varchar(20),
SUPPLY INT,
RATE NUMERIC(15,2),
GROSS_AMT NUMERIC(15,2),
COMM_AMT NUMERIC(15,2),
BILL_AMT NUMERIC(15,2)
)

declare @avg_sup as int
declare @v_date as datetime
set @v_date=dbo.convert_user_date('/',@pdate,@pdateformat)
declare @day as int
declare @v_day as varchar(3)
set @v_day=upper(DATENAME(dw,@v_date)	)


declare @tot_sup_pro as int
declare @v_rate_prod as numeric(14,2)
declare @v_gross_prod as numeric(14,2)
declare @v_net_prod as numeric(14,2)
declare @v_com_prod as numeric(14,2)
declare @v_com_type as varchar(1)

declare @v1_comp_code varchar(20)
declare @v1_unit varchar(20)
declare @v1_pro_type varchar(20)
declare @v1_publ as varchar(20)
declare @v1_edtn as varchar(20)
declare @v1_comm_code as varchar
declare @v1_billfreq varchar(1)


	DECLARE c1 CURSOR  for 
		select b.comp_code,b.unit,p.pro_type,b.publ,b.edtn,b.comm_code ,isnull(b.billing_cycle,'F') as BILL_CYCLE 
		from cir_supply b,cir_agmast a,cir_publ_mast p 
		where a.comp_code=b.comp_code and a.unit=b.unit
		and a.agcd=b.agcd and a.dpcd=b.dpcd
		and a.comp_code=p.comp_code and b.comp_code=p.comp_code 
		and b.publ=p.publ and b.comp_code=@pcomp_code
		and (b.unit=@punit_code or @punit_code is null or @punit_code ='')
		and (b.publ=@ppubl or @ppubl is null or @ppubl='')
		and (b.edtn=@pedtn or @pedtn is null or @pedtn='')
		and (b.agcd=@pagcd or @pagcd is null or @pagcd='' )
		and (b.dpcd=@pdpcd or @pdpcd is null or @pdpcd='' )
		and (p.pro_type=@ppubl_type or @ppubl_type is null or @ppubl_type='')
		and (a.branch_code =@pbranch_code or @pbranch_code is null or @pbranch_code='')
		and (a.ag_type=@pag_type or @pag_type is null or @pag_type='')
		and (a.ag_class=@pag_class or @pag_class is null or @pag_class='')
		and (b.route_code=@proute or @proute is null or @proute='' )
		group by b.comp_code,b.unit,p.pro_type,b.publ,b.edtn,b.comm_code,b.billing_cycle order by p.pro_type
print('X')

	 open c1
	 fetch next from c1 into @v1_comp_code,@v1_unit,@v1_pro_type,@v1_publ,@v1_edtn,@v1_comm_code,@v1_billfreq
print('@v1_pro_type')
print(@v1_pro_type)
print(@v1_publ)
print(@v1_edtn)
print(@v1_comm_code)

	 while(@@fetch_status=0) begin
	 print('G')
		 if(@v1_billfreq='M') BEGIN
			set @day=60
		 end 
		 else  if(@v1_billfreq='W') BEGIN
			set @day=14
		 end 
		 else  BEGIN/*daily*/
			set @day=7
		 end
 

		select @avg_sup=SUM(isnull(sup_copy,0)) from cir_dbksup  b where b.comp_code=@v1_comp_code 
		and b.unit_code=@v1_unit 
		and (b.publ=@v1_publ ) and EDTN=@v1_edtn
		and (b.agcd=@pagcd or @pagcd is null or @pagcd='' )
		and (b.dpcd=@pdpcd or @pdpcd is null or @pdpcd='' )
		and b.SUPDATE=DATEADD(dd,-1,@v_date)

		PRINT('1')
		PRINT(@avg_sup)
		 if @avg_sup is null or @avg_sup<1
		 begin		 
			PRINT('2')
			PRINT(@avg_sup)
			
			select @avg_sup =  case @v_day 
			when 'SUN' then SUM(isnull(base_supply,0)+ isnull(SUPPLY_SUN,0) )
			when 'MON' then SUM(isnull(base_supply,0)+ isnull(SUPPLY_MON,0) )
			when 'TUE' then SUM(isnull(base_supply,0)+ isnull(SUPPLY_TUE,0) )
			when 'WED' then SUM(isnull(base_supply,0)+ isnull(SUPPLY_WED,0) )
			when 'THU' then SUM(isnull(base_supply,0)+ isnull(SUPPLY_THU,0) )
			when 'FRI' then SUM(isnull(base_supply,0)+ isnull(SUPPLY_FRI,0) )
			when 'SAT' then SUM(isnull(base_supply,0)+ isnull(SUPPLY_SAT,0) ) end
			from cir_supply b  where	b.comp_code=@v1_comp_code
			and b.unit=@v1_unit and (b.publ=@v1_publ) and EDTN=@v1_edtn
			and (b.agcd=@pagcd or @pagcd is null or @pagcd='' )
			and (b.dpcd=@pdpcd or @pdpcd is null or @pdpcd='' )
			
		end
		
		set @tot_sup_pro=@avg_sup*@day
		
		select @v_rate_prod= case @v_day
		when 'SUN' then SUM(isnull(SUN_RATE,0))
		when 'MON' then SUM(isnull(MON_RATE,0))
		when 'TUE' then SUM(isnull(TUE_RATE,0))
		when 'WED' then SUM(isnull(WED_RATE,0))
		when 'THU' then SUM(isnull(THU_RATE,0))
		when 'FRI' then SUM(isnull(FRI_RATE,0))
		when 'SAT' then SUM(isnull(SAT_RATE,0)) end		
		from CIR_RATE_MAST where COMP_CODE=@v1_comp_code and UNIT=@v1_unit and PUBL=@v1_publ and EDTN=@v1_edtn

		select @v_com_prod=case @v_day
		when 'SUN' then SUM(isnull(SUN_COMM_RATE,0))
		when 'MON' then SUM(isnull(MON_COMM_RATE,0))
		when 'TUE' then SUM(isnull(TUE_COMM_RATE,0))
		when 'WED' then SUM(isnull(WED_COMM_RATE,0))
		when 'THU' then SUM(isnull(THU_COMM_RATE,0))
		when 'FRI' then SUM(isnull(FRI_COMM_RATE,0))
		when 'SAT' then SUM(isnull(SAT_COMM_RATE,0)) end		
		,@v_com_type=COMM_CATG_TYPE from CIR_COMM_MAST where COMP_CODE=@v1_comp_code and UNIT_CODE=@v1_unit and PUBL=@v1_publ and EDTN=@v1_edtn and COMM_CATG_CODE=@v1_comm_code
		group by COMM_CATG_TYPE
		
		set @v_gross_prod = isnull(@tot_sup_pro,0)*isnull(@v_rate_prod,0)
		set @v_com_prod=isnull(@v_gross_prod,0)*ISNULL(@v_com_prod,0)/100
		
		insert into #cir_security (COMP_CODE,UNIT_CODE,PRO_TYPE,BILL_FREQ,PUBL,EDTN,SUPPLY,RATE ,GROSS_AMT,COMM_AMT,BILL_AMT)
		values (@v1_comp_code,@v1_unit,@v1_pro_type,@v1_billfreq,@v1_publ,@v1_edtn,@tot_sup_pro,@v_rate_prod,@v_gross_prod,@v_com_prod,ISNULL(@v_gross_prod,0)-ISNULL(@v_com_prod,0) )
		
	 fetch next from c1 into @v1_comp_code,@v1_unit,@v1_pro_type,@v1_publ,@v1_edtn,@v1_comm_code,@v1_billfreq
	 end
	 close c1
	 deallocate c1

declare @v_sec_ondt as numeric(14,2)



	
	 
	 
	 
	 select SUM(amount) as DEP_ONDT from CIR_RCPHDR where COMP_CODE =@pcomp_code 
	and (UNIT_CODE=@punit_code or @punit_code is null or @punit_code ='')
	and AGCD=@pagcd and DPCD=@pdpcd and ACHD='SC'
	
	select SUM(isnull(b.bg_amt,0)) bg_amt--,SUM(a.amount)+SUM(isnull(b.bg_amt,0)) TOTAL_AMT ,SUM(a.amount) CASH
		from cir_rcphdr a  left outer join cir_bank_guarantee b
		on a.comp_code=b.comp_code and a.unit_code=b.unit_code and a.agcd=b.agcd and a.dpcd=b.dpcd
		,cir_agmast c where 
		a.comp_code=c.comp_code
		--and achd='SC'
		and a.agcd=c.agcd 
		and a.dpcd=c.dpcd
		and a.comp_code=@pcomp_code  
		and a.unit_code =@punit_code
		and (a.agcd=@pagcd or @pagcd is null or @pagcd='') 
		and (a.dpcd=@pdpcd or @pdpcd is null or @pdpcd='') 
		and a.recptdt <=@v_date 
	--	and(a.reason =@ppaymode or @ppaymode is null or @ppaymode='')
		and (a.branch_code =@pbranch_code or @pbranch_code is null or @pbranch_code='')
		and (c.ag_type=@pag_type or @pag_type is null or @pag_type='') 
		and (c.ag_class=@pag_class or @pag_class is null or @pag_class='')
	                          
	  select SUM(isnull(BILL_AMT,0)) REQ_SEC 
	 from #cir_security
	
	 drop table #cir_security

end


/////////

ALTER PROCEDURE [dbo].[cir_credit_rating_sale]
	@pcomp_code         as varchar(20),
	@punit_code         as varchar(20),
	@ppubl              as varchar(20),	
	@pfromdate          as varchar(20),
	@ptilldate          as varchar(20),
	@pagency_type       as varchar(20),
	@pagency_class      as varchar(20),	
	@pbranch            as varchar(20),
	@pagcd              as varchar(20),
	@pdpcd              as varchar(20),	
	@preturn_based      as varchar(20),--it is use for return date or supply date(R/S)	
	@plangtype          as varchar(20),
	@pdateformat        as varchar(20)
		
	
AS 
		
	DECLARE @v_hdays	AS	NUMERIC(5) 
	DECLARE @v_avg_sale AS  NUMERIC(10) 
	DECLARE @v_reg_code AS  varchar(200)
	DECLARE @v_zone_code varchar(200);
	DECLARE @v_publ_code varchar(200);
	DECLARE @v_route_code varchar(200);

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
    DECLARE @v1_route_code   		as varchar(50)
    DECLARE @v1_route_name			as varchar(150)
    DECLARE @v1_supply_copy			as int
    DECLARE @v1_return_copy			as int
    DECLARE @v1_net_sale_copy		as int
    DECLARE @v1_no_of_days			as int
    DECLARE @v1_unit_name			as varchar(150)
    DECLARE @v1_COM_CAT  			as varchar(150)
    declare @v1_supdate				as datetime


CREATE TABLE #CIR_DBKSUP_temp
(
	COMP_CODE varchar(8) NOT NULL,
	UNIT_CODE varchar(8) NOT NULL,
	PUBL varchar(3) NOT NULL,
	EDTN varchar(3) NOT NULL,
	AGCD varchar(8) NOT NULL,
	DPCD varchar(8) NOT NULL,
	SUPDATE datetime NOT NULL,
	SUP_TYPE_CODE varchar(5) NOT NULL,
	SUP_COPY numeric(10, 0) NULL,
	AGENCY_TY_CODE varchar(8) NULL,
	AGENCY_PKT_SIZE numeric(7, 0) NULL,
	COMM_CODE varchar(6) NULL,
	COMM_FIX_AUTO_SPL varchar(1) NULL,
	SUP_RATE numeric(10, 4) NULL,
	BILLAGCD varchar(8) NULL,
	BILLDPCD varchar(8) NULL,
	ROUTE_CODE varchar(5) NULL,
	SUBROUTE_CODE varchar(5) NULL,
	SUBSUBROUTE_CODE varchar(5) NULL,
	USERID varchar(10) NULL,
	CREATION_DATE datetime NULL,
	SURCH_CD varchar(5) NULL,
	ISSUE_DATE datetime NULL,
	RETURN_COPY_SALE varchar(1) NULL,
	FINAL_SUPPLY_FLAG varchar(1) NULL,
	UPDATED_BY varchar(30) NULL,
	UPDATED_DT datetime NULL,
	PER_COPY_WEIGHT numeric(15, 3) NULL,
	WASTE_CATG_CODE varchar(50) NULL
)

	
		insert into #CIR_DBKSUP_temp(
		COMP_CODE,UNIT_CODE,PUBL,EDTN,AGCD,DPCD,SUPDATE,SUP_TYPE_CODE,SUP_COPY,AGENCY_TY_CODE,AGENCY_PKT_SIZE,
		COMM_CODE,COMM_FIX_AUTO_SPL,SUP_RATE,BILLAGCD,BILLDPCD,ROUTE_CODE,SUBROUTE_CODE,SUBSUBROUTE_CODE,
		USERID,CREATION_DATE,SURCH_CD,ISSUE_DATE,RETURN_COPY_SALE,FINAL_SUPPLY_FLAG,UPDATED_BY,UPDATED_DT,
		PER_COPY_WEIGHT,WASTE_CATG_CODE
		)
		select COMP_CODE,UNIT_CODE,PUBL,EDTN,AGCD,DPCD,SUPDATE,SUP_TYPE_CODE,SUP_COPY,AGENCY_TY_CODE,AGENCY_PKT_SIZE,
		COMM_CODE,COMM_FIX_AUTO_SPL,SUP_RATE,BILLAGCD,BILLDPCD,ROUTE_CODE,SUBROUTE_CODE,SUBSUBROUTE_CODE,
		USERID,CREATION_DATE,SURCH_CD,ISSUE_DATE,RETURN_COPY_SALE,FINAL_SUPPLY_FLAG,UPDATED_BY,UPDATED_DT,
		PER_COPY_WEIGHT,WASTE_CATG_CODE 		
		from cir_dbksup b
		where b.comp_code =@pcomp_code 
		and (b.unit_code=@punit_code or @punit_code is null or @punit_code ='') 
		and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') 

	and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') 
		and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='')
		and b.supdate >= @pfromdate and b.supdate <=@ptilldate
	
		
		 and ( round(isnull(substring(cast(dbo.cir_get_commission(b.comp_code,b.unit_code,b.publ,b.edtn,
		b.COMM_FIX_AUTO_SPL,b.COMM_CODE,b.SUPDATE,@pdateformat,b.SUP_COPY,'','' )
		 as varchar),2,len(cast(dbo.cir_get_commission(b.comp_code,b.unit_code,b.publ,b.edtn,
		 b.COMM_FIX_AUTO_SPL,b.COMM_CODE,b.SUPDATE,@pdateformat,b.SUP_COPY,'','' ) as varchar))  ) ,0),0) !='')
		/* and round(isnull(substring(cast(dbo.cir_get_commission(b.comp_code,b.unit_code,b.publ,b.edtn,
		b.COMM_FIX_AUTO_SPL,b.COMM_CODE,b.SUPDATE,@pdateformat,b.SUP_COPY,'','' )
		 as varchar),2,len(cast(dbo.cir_get_commission(b.comp_code,b.unit_code,b.publ,b.edtn,
		 b.COMM_FIX_AUTO_SPL,b.COMM_CODE,b.SUPDATE,@pdateformat,b.SUP_COPY,'','' ) as varchar))  ) ,0),0) 	
		  > cast(@pcommper as numeric) or cast(@pcommper as numeric) is null or cast(@pcommper as numeric) = 0)
		  */
	
	


	
		DECLARE c1 cursor LOCAL FOR 
		select u.comp_code,u.unit_code,
		u.branch_code branch_code,(select distinct Branch_Name from branch_mst where Branch_Code=u.branch_code) branch_name,
		u.publ,u.publ_name,u.main_edtn,
		dbo.cir_get_edtn_name(u.comp_code,u.main_edtn) main_edtn_name,u.edtn edtn,u.edtn_name,u.copy_rate,
		u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,
		u.state_code,dbo.cir_get_state(u.comp_code,u.country_code,u.state_code) state_name,
		u.dist_code ,dbo.cir_get_name_cir_district(u.comp_code,u.dist_code,@plangtype,null,null,null) dist_name,
		u.city_code city_code,dbo.cir_get_name_cir_city(u.comp_code,u.city_code,@plangtype,null,null,null) city_name,
		u.tehsil_taluka,dbo.cir_get_name_cir_taluka(u.comp_code,u.tehsil_taluka,@plangtype,null,null,null) taluka_name,
		u.route_code,dbo.cir_get_route_name(u.comp_code,u.unit_code,u.route_code ) route_name,
		sum(supply_copy) supply_copy,sum(return_copy) return_copy,
		sum(supply_copy)-sum(return_copy) net_sale_copy,sum(no_of_days) no_of_days
		,dbo.cir_get_unit_name(u.comp_code,u.unit_code) as UNIT_NAME
		,u.comm_cat as COM_CAT
		from (
		select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate copy_rate,
		b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
		a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka, b.route_code, 
		sum(isnull(b.sup_copy,0)) supply_copy,0 return_copy, count(distinct supdate) no_of_days
		,b.comm_code comm_cat
		--from cir_agmast a,cir_dbksup b,cir_edtn_mast e,cir_publ_mast p
		from cir_agmast a,#CIR_DBKSUP_temp b,cir_edtn_mast e,cir_publ_mast p		
		where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and 
		b.comp_code =@pcomp_code and 
		b.unit_code=a.unit and (b.unit_code=@punit_code or @punit_code is null or @punit_code ='') and 
		b.publ=p.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and b.edtn=e.edtn  and
		a.agcd=b.agcd and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') and a.dpcd=b.dpcd and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='') and
		b.supdate >= @pfromdate and b.supdate <=@ptilldate and 
		(a.ag_type=@pagency_type or @pagency_type is null or @pagency_type='') and(a.ag_class=@pagency_class or @pagency_class is null or @pagency_class='') and
		(a.branch_code=@pbranch or @pbranch is null or @pbranch='')   
		   
		
		group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate,
		b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
		a.country_code,a.tehsil_taluka,b.route_code,b.comm_code
		union all
		select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
		b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
		a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka,d.route_code,  
		0 supply_copy,sum(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0)) return_copy,0 no_of_days
		,d.comm_code comm_cat
		from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e,cir_publ_mast p,cir_dbksup d
		where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and b.comp_code =@pcomp_code and 
		b.unit_code=a.unit and (b.unit_code=@punit_code or @punit_code is null or @punit_code ='') and  
		b.doctype='UCN' and ((b.recptdt >= @pfromdate and b.recptdt <=@ptilldate and isnull(@preturn_based,'R') ='R') or (b.supdate >= @pfromdate and b.supdate <=@ptilldate and isnull(@preturn_based,'R') ='S')) and 
		b.publ=d.publ and b.edtn=d.edtn and a.agcd=d.agcd and a.dpcd=d.dpcd and
		b.publ=e.publ and b.publ=p.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and b.edtn=e.edtn and 
		a.agcd=b.agcd and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') and a.dpcd=b.dpcd and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='') and
		(a.ag_type=@pagency_type or @pagency_type is null or @pagency_type='') and(a.ag_class=@pagency_class or @pagency_class is null or @pagency_class='') and
		(a.branch_code=@pbranch or @pbranch is null or @pbranch='')  and
		(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 
		
	
		
		group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
		b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
		a.country_code,a.tehsil_taluka,d.route_code ,d.comm_code) u
		where (u.supply_copy+u.return_copy)>0
		group by u.comp_code,u.unit_code,u.branch_code,u.publ,u.publ_name,u.main_edtn,u.edtn,u.edtn_name,u.copy_rate,
		u.agcd,u.dpcd,u.agname,u.agname_oth_lang,u.state_code,u.dist_code ,u.city_code,u.tehsil_taluka,u.route_code,u.country_code,u.comm_cat; 
	
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
	  REGION          VARCHAR(500),
	  RET_COMM_AMT     NUMERIC(15,2),
	  BILL_SEC_AMT     NUMERIC(15,2),
	  SEC_OPBAL        NUMERIC(15,2),
	  zone_code        VARCHAR(200),
	  region_code        VARCHAR(200),
	  pro_type        VARCHAR(200),
	  route_code      VARCHAR(200),
	  copy_rate			numeric(14,2),
	  no_of_days		numeric(10),
	  unit_name			varchar(150),
	  COM_CAT           varchar(150),
	  supdate           datetime
	  )
		
		
		OPEN c1 
        fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code, @v1_branch_code, @v1_branch_name,@v1_publ, @v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,@v1_edtn,@v1_edtn_name,@v1_copy_rate, @v1_agcd, @v1_dpcd,@v1_agname,@v1_agname_oth_lang,@v1_state_code,@v1_state_name,@v1_dist_code,@v1_dist_name,@v1_city_code,@v1_city_name, @v1_tehsil_taluka,@v1_taluka_name,@v1_route_code,@v1_route_name,@v1_supply_copy,@v1_return_copy,@v1_net_sale_copy, @v1_no_of_days,@v1_unit_name,@v1_COM_CAT
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN 
		
             
   
			If isnull(@v1_no_of_days,0)>0 Begin
                set @v_avg_sale=round(isnull(@v1_net_sale_copy,0)/(isnull(@v1_no_of_days,0)),0)
            End    
            Else Begin
                set @v_avg_sale=isnull(@v1_net_sale_copy,0)
            End

            select distinct @v_reg_code=region_code,@v_zone_code=zone_code from cir_city_mast where comp_code=@v1_comp_code and city_code=@v1_city_code            
            if(@v_reg_code='')
            begin
				set @v_reg_code=null
            end
           
            if(@v_zone_code='')
            begin
				set @v_zone_code=null
            end
            
            select distinct @v_publ_code=pro_type from cir_publ_mast where comp_code=@v1_comp_code and publ=@v1_publ;
            if(@v_publ_code='')
            begin
				set @v_publ_code=null
            end
            
            select distinct @v1_COM_CAT=COMM_CATG_DESC from CIR_COMM_CATG_MAST where comp_code=@v1_comp_code and COMM_CATG_CODE=@v1_COM_CAT            
            if(@v1_COM_CAT='')
            begin
				set @v1_COM_CAT=null
            end
            
            
            set @v_reg_code=dbo.cir_get_region_name(@v1_comp_code,@v_reg_code)
            set @v_zone_code=dbo.cir_get_zone_name(@v1_comp_code, @v_zone_code); 
			set @v_publ_code=dbo.cir_publ_type(@v1_comp_code,@v_publ_code,null,null);
            
            insert into #cir_temp_bill_collection
				(comp_code, unit_code, billno, publ_code, agcd, dpcd,agname,agname_oth_lang, city_code, 
				taluka_code, dist_code, state_code, REGION,supply_copy, return_copy ,copy_rate,no_of_days,zone_code, region_code,pro_type,route_code
				,unit_name,COM_CAT)
            values(@v1_comp_code,@v1_unit_code,@v1_branch_name,@v1_publ_name,@v1_main_edtn_name,@v1_edtn_name,@v1_agname,@v1_agname_oth_lang,@v1_city_name,
				@v1_taluka_name,@v1_dist_name,@v1_state_name,@v_reg_code,@v1_supply_copy,@v1_return_copy,@v1_copy_rate,@v1_no_of_days,@v_zone_code,@v_reg_code,@v_publ_code,@v1_route_name
				,@v1_unit_name,@v1_COM_CAT)
            
		    fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code, @v1_branch_code, @v1_branch_name,@v1_publ, @v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,@v1_edtn,@v1_edtn_name,@v1_copy_rate, @v1_agcd, @v1_dpcd,@v1_agname,@v1_agname_oth_lang,@v1_state_code,@v1_state_name,@v1_dist_code,@v1_dist_name,@v1_city_code,@v1_city_name, @v1_tehsil_taluka,@v1_taluka_name,@v1_route_code,@v1_route_name,@v1_supply_copy,@v1_return_copy,@v1_net_sale_copy, @v1_no_of_days,@v1_unit_name,@v1_COM_CAT
		
		END 
		close c1
		DEALLOCATE c1
              
                select comp_code AS COMP_CODE, unit_code AS UNIT,
                publ_code AS PUBL_NAME,
                --agcd AS MAIN_EDTN_NAME,
                --dpcd AS EDTN_NAME,
               -- publ_code AS PUBL_NAME,
               -- copy_rate as COPY_RATE,
                sum(supply_copy) AS SUPPLY_COPY, 
                sum(return_copy) AS RETURN_COPY ,
                (sum(supply_copy)-sum(return_copy)) AS NET_SALE,
                case 
                when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) 
                else 0 end as NET_PER
               --, no_of_days AS NO_OF_DAYS,
               -- case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) 
                --else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection  
                group by comp_code,unit_code,publ_code
                order by publ_code
                
              
     
   drop table #CIR_TEMP_BILL_COLLECTION
   
   drop table #CIR_DBKSUP_temp

 


///////////////


--cir_credit_rating_report 'HT001','DEL','P27','08','2012','','','','N0004','0001',''
ALTER procedure [dbo].[cir_credit_rating_report]
(
	@pcomp_code         as varchar(20),
	@punit_code         as varchar(20),
	@ppubl              as varchar(20),	
	@pmonth             as varchar(20),
	@pyear              as varchar(20),
	@pagency_type       as varchar(20),
	@pagency_class      as varchar(20),	
	@pbranch            as varchar(20),
	@pagcd              as varchar(20),
	@pdpcd              as varchar(20),	
	@pdateformat        as varchar(20),
	@pmonth_bg        as int
	
)
as
begin
declare @pfromdate varchar(10)
declare @ptilldate varchar(10)
declare @pdate varchar(10)
declare @preturn_based varchar(1)
declare @plangtype varchar(1)
declare @ptodate varchar(10)
set @preturn_based='R'
set @plangtype='1'
set @pdate=@pmonth+'/01/'+@pyear
SET @ptodate=convert(varchar(10),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@pdate)+1,0)),101)

/*TABLE 0      agency detail 00*/
select distinct top 1 a.* ,
b.route_code,
dbo.cir_get_city(a.comp_code,a.city_code) city_name,
dbo.cir_get_route_name(a.comp_code,a.unit,b.route_code) route_name
,dbo.cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,1) drop_point_name,
dbo.cir_get_agency_type(a.comp_code,a.ag_type) agent_type
,dbo.cir_get_state(a.comp_code,a.country_code,a.state_code)state_name,
dbo.cir_get_name_cir_district(a.comp_code,a.dist_code,1,@pdateformat,'','') dist_name
,dbo.cir_get_country(a.comp_code,a.country_code)country_name,
(select max(zone_code) from cir_city_mast where cir_city_mast.comp_code=a.comp_code
and cir_city_mast.city_code=a.city_code ) zone_code,dbo.cir_get_zone_name(a.comp_code,(select max(zone_code) from cir_city_mast where cir_city_mast.comp_code=a.comp_code
and cir_city_mast.city_code=a.city_code )) zone_name,(select max(region_code) from cir_city_mast where cir_city_mast.comp_code=a.comp_code
and cir_city_mast.city_code=a.city_code ) region_code,dbo.cir_get_region_name(a.comp_code,(select max(region_code) from cir_city_mast where cir_city_mast.comp_code=a.comp_code
and cir_city_mast.city_code=a.city_code )) region_name,
(select max(c.name) from  cir_ag_con_per c where a.comp_code=c.comp_code and b.comp_code=c.comp_code and a.unit=c.unit and b.unit=c.unit
and a.agcd=c.agcd and b.agcd=c.agcd and a.dpcd=c.dpcd and b.dpcd=c.dpcd )cont_person_name
,dbo.cir_get_branch(a.comp_code,a.branch_code) branch_name from cir_agmast a ,cir_supply b
where a.comp_code=b.comp_code and a.unit=b.unit and a.agcd=b.agcd and a.dpcd=b.dpcd and
a.comp_code=@pcomp_code and a.unit=@punit_code and a.agcd=@pagcd and a.dpcd=@pdpcd
and (a.branch_code=@pbranch  or @pbranch is null or @pbranch='') and (a.ag_type=@pagency_type 
or @pagency_type is null or @pagency_type='') and (a.ag_class=@pagency_class or @pagency_class is null or @pagency_class='') 

/*TABLE 1      sales performance 1 month 01*/
set @pfromdate=@pmonth+'/01/'+@pyear
set @ptilldate=convert(varchar(10),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@pdate)+1,0)),101)
exec  cir_credit_rating_sale @pcomp_code,@punit_code,@ppubl,@pfromdate,@ptilldate,@pagency_type,@pagency_class,	@pbranch,@pagcd,@pdpcd,		@preturn_based,	@plangtype,	@pdateformat

/*TABLE 2      sales performance 3 month 02*/
set @pfromdate=CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@pdate))-1),DATEADD(mm,-2,@pdate)),101)
set @ptilldate=convert(varchar(10),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@pdate)+1,0)),101)
exec  cir_credit_rating_sale @pcomp_code,@punit_code,@ppubl,@pfromdate,@ptilldate,@pagency_type,@pagency_class,	@pbranch,@pagcd,@pdpcd,		@preturn_based,	@plangtype,	@pdateformat

/*TABLE 3      sales performance 1 year 03*/
set @pfromdate='01/01/'+@pyear
print('@pfromdate')
print(@pfromdate)
set @ptilldate='12/31/'+@pyear
exec  cir_credit_rating_sale @pcomp_code,@punit_code,@ppubl,@pfromdate,@ptilldate,@pagency_type,@pagency_class,	@pbranch,@pagcd,@pdpcd,		@preturn_based,	@plangtype,	@pdateformat

/*TABLE 4      ageing report ONLY FOR NEWSPAPER*/
exec cir_credit_rating_ageing  @pcomp_code,@punit_code,@pbranch,@pagency_type,	@pagency_class,@pagcd,	@pdpcd,'B',@ptodate,@ptodate,'1','2','3','5','6',null,@ppubl

/*TABLE 5      blocking history 05*/
exec cir_credit_rating_block @pcomp_code,@punit_code,@pbranch,'B',@pagcd,	@pdpcd,@pfromdate,@ptilldate,@pdateformat

/*TABLE 6      return cheque 06*/
select o.comp_code,o.unit_code,o.agcd,o.dpcd,o.chno,o.chdt,o.chbnk,o.amount,
'Cleared' STATUS
 from cir_outmast o,cir_reason_mst r where o.doctyp='DN' and o.comp_code=r.comp_code
and o.reason=r.reason_code and  o.billno is not null and chq_return_flag='Y'
AND o.comp_code=@pcomp_code and (o.unit_code=@punit_code ) and o.agcd =@pagcd and 
o.dpcd =@pdpcd  and  o.chdt between  @pfromdate and @ptilldate

/*TABLE 7      bank guarantee FOR EXPIRY LIST*/
SELECT b.COMP_CODE, b.UNIT_CODE, b.AGCD, b.DPCD,m.ag_name AG_NAME,
DBO.CIR_GET_DROP_POINT_NAME(B.COMP_CODE,B.UNIT_CODE,M.STATION_CODE,1) DROP_POINT_NAME,
    DBO.CIR_GET_CITY(B.COMP_CODE,M.CITY_CODE) CITY_NAME, 
    b.BG_NO, b.BG_AMT, b.BG_DATE, b.BG_VALID, b.BANK_DESC, 
    b.CREATED_BY, b.CREATED_DT, b.UPDATED_BY, b.UPDATED_DT, b.BG_TYPE
    FROM cir_bank_guarantee b,cir_agmast m
    where m.comp_code =b.comp_code and m.comp_code = @pcomp_code and b.unit_code=m.unit  
    and m.unit=@punit_code
    and b.agcd=m.agcd and b.agcd    = ISNULL(@pagcd,b.agcd) 
    and b.dpcd=m.dpcd and b.dpcd    = ISNULL(@pdpcd,b.dpcd)
   -- and b.bg_valid between @pfromdate and @ptilldate
    and b.bg_valid between @pfromdate and dateadd(mm,@pmonth_bg,'01/26/2012') 
    ORDER BY AG_NAME
    
    /*TABLE 8      PAYMENT HISTORY 08*/
select TOP 5 o.comp_code,o.unit_code,o.agcd,o.dpcd,o.RECPTNO,o.RECPTDT,o.amount
 from cir_outmast o where o.doctyp='RCR' 
AND o.comp_code=@pcomp_code and (o.unit_code=@punit_code ) and o.agcd =@pagcd and 
o.dpcd =@pdpcd  and  o.RECPTDT between  @pfromdate and @ptilldate
ORDER BY o.RECPTDT DESC
   
     /*TABLE 9+10+11      target bank guarantee (returns 3 table----- 3-req security,1-dep security,2-bank guarantee)*/ 
   declare @v_dt varchar(200)
   set @v_dt=convert(varchar(10),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@pdate)+1,0)),101) 
   exec cir_credit_rating_security_report @pcomp_code ,@punit_code,@pbranch,@ppubl,null,@pagcd,@pdpcd,@v_dt,'mm/dd/yyyy',null,@pagency_class,@pagency_type,null,null,null
 print('@v_dt') 
print(@v_dt) 
print(@pagcd)
 print(@pdpcd)
 print(@pagency_class)
 print(@pagency_type)

/*TABLE 12      collection report/index 10*/	
 exec  cir_credit_rating_overdue @pcomp_code,@punit_code,ppubl,@pagency_type,@pagency_class,@pagcd,@pdpcd,@v_dt,@v_dt,'mm/dd/yyyy'

/*TABLE 13      ageing report magzine month wise*/
exec cir_credit_rating_monthly_ageing  @pcomp_code,@punit_code,@pbranch,@ppubl,@pagency_type,@pagency_class,@pagcd,	@pdpcd,'B',@v_dt,@v_dt,'30','60','90','120','150',null,'N'
/*table 14      ageing report total installment and total amt*/
exec cir_credit_rating_monthly_ageing  @pcomp_code,@punit_code,@pbranch,@ppubl,@pagency_type,@pagency_class,@pagcd,	@pdpcd,'B',@v_dt,@v_dt,'30','60','90','120','150',null,''
   
--cir_credit_rating_report 'HT001','DEL','','08','2012','','','','','',''


end

/******************end************/




///////////////////
                                     
ALTER PROCEDURE [dbo].[cir_credit_rating_overdue]
@pcomp_code          as varchar(200),
@punit_code          as varchar(200),
@ppubl_code          as varchar(200),
@pagtype             as varchar(200),
@pagclass            as varchar(200),
@pag_main_code       as varchar(200),
@pag_sub_code        as varchar(200),
@pdebitupto_date     as datetime,
@pcreditupto_date    as datetime,
@pdateformat         as varchar(200)

AS

     
declare  @v_opdate   as datetime
declare  @vtodt  as datetime     
declare  @vasondt    as datetime
declare  @v_dt  as datetime
declare @v_ondt as datetime
declare  @v_days numeric(10)

declare  @v_dispute_amt	     numeric(14,2)
declare  @v_over_total         numeric(14,2);
declare  @v_index              numeric(14,2);
declare  @v_amt               numeric(14,2);
declare  @v_amt_daily         numeric(14,2);
declare  @v_amt_weekly           numeric(14,2);
declare  @v_amt_monthly          numeric(14,2);
declare  @v_amt_mags         numeric(14,2);
declare  @v_amt_install        numeric(14,2);
declare  @debit_amt_daily       numeric(14,2);  
declare  @debit_amt_weekly     numeric(14,2)  
declare  @debit_amt_monthly     numeric(14,2) 
declare  @debit_amt_mags    numeric(14,2)
declare  @debit_amt_istall    numeric(14,2)

set @debit_amt_daily=0
set @debit_amt_weekly=0
set @debit_amt_monthly=0
set @debit_amt_mags=0
set @debit_amt_istall=0

declare  @v_opbal     numeric(15,2)
declare  @v_clbal     numeric(15,2)
declare  @v_billamt    numeric
declare  @v_dbcramt    numeric
declare  @v_recamt    numeric
declare  @v_othdbamt    numeric
declare  @v_othcramt    numeric

set @v_opbal=0
set @v_clbal=0
set @v_billamt=0
set @v_dbcramt=0
set @v_recamt=0
set @v_othdbamt=0
set @v_othcramt=0

set @v_opdate    = dbo.cir_get_finandt(@pcomp_code,@pdebitupto_date,@pdateformat,'','');
set @vtodt=@pdebitupto_date
set @vasondt=@pcreditupto_date
print('prachi')
print(@v_opdate)
print(@vtodt)
print(@vasondt)
CREATE TABLE #cir_temp_overdue
(
  COMP_CODE      VARCHAR(8),
  UNIT_CODE      VARCHAR(8),
  BRAN_CODE      VARCHAR(8),
  AGCD           VARCHAR(8),
  DPCD           VARCHAR(8),
  AG_NAME        VARCHAR(100),
  BRANCH_NAME    VARCHAR(100),
  ZONE_NAME      VARCHAR(100),
  STATE_NAME     VARCHAR(100),
  CITY_NAME      VARCHAR(100),
  PRODUCT        VARCHAR(100),
  INSTALL_AMT    NUMERIC(14,2),
  DAILY_AMT      NUMERIC(14,2),
  WEEKLY_AMT     NUMERIC(14,2),
  MONTHLY_AMT    NUMERIC(14,2),
  MAGS_AMT       NUMERIC(14,2),
  OVERDUE_TOTAL  NUMERIC(14,2),
  OUTS_TOTAL     NUMERIC(14,2),
  INDEX_AMT      NUMERIC(14,2),
  DISPUTE        NUMERIC(14,2),
  SESSIONID      NUMERIC(14)
)

-- cursor cur_agency variables
declare @rec_agency_zone_name as varchar(300)
declare @rec_agency_state_name as varchar(200)
declare @rec_agency_branch_name as varchar(300)
declare @rec_agency_city_code as varchar(200)
declare @rec_agency_city_name as varchar(300)
declare @rec_agency_ag_name as varchar(300)
declare @rec_agency_comp_code as varchar(20)
declare @rec_agency_unit as varchar(30)
declare @rec_agency_agcd as varchar(20)
declare @rec_agency_dpcd as varchar(30)
declare @rec_agency_branch_code as varchar(30)
declare @rec_agency_publ as varchar(20)
declare @rec_agency_publ_name as varchar(300)
declare @rec_agency_pnick as varchar(30)
declare @rec_agency_period as varchar(20)
declare @rec_agency_pro_type as varchar(300)
declare @rec_agency_product as varchar(300)
declare @rec_agency_credit_days as int
declare @rec_agency_credit_limit as numeric(14,2)

-- cursor v_bill variables
declare @v_bill_billno as varchar(50)
declare @v_bill_billdt as varchar(30)
declare @v_bill_bill_amt as numeric(15,2)

-- cursor v_pending_rcpt variables  
declare @v_pending_rcpt_ag_main_code as varchar(30)
declare @v_pending_rcpt_ag_sub_code as varchar(50)
declare @v_pending_rcpt_amount as numeric(15,2)


	declare cur_agency cursor for
		select distinct 
		dbo.cir_get_zone_name(m.comp_code,c.zone_code) zone_name,
		dbo.cir_get_state(m.comp_code,c.country_code,c.state_code) state_name ,
		dbo.cir_get_branch(m.comp_code,m.branch_code) branch_name,
		m.city_code city_code,c.city_name city_name,M.Ag_Name ag_name,
		m.comp_code comp_code,m.unit unit,m.agcd agcd,m.dpcd dpcd,
		m.branch_code branch_code,p.publ publ, p.publ_name publ_name, p.pnick pnick,p.period,p.pro_type,
		case when p.pro_type='NE0' then 'Newspaper' when p.pro_type='ME0' then 'Magzine' else p.pro_type end product,
		o.credit_days credit_days,o.credit_limit credit_limit
		from cir_agmast m,cir_city_mast c,cir_supply s,cir_publ_mast p,cir_overdue_mast o
		where p.comp_code=o.comp_code and p.publ=o.publ_code 
		and m.comp_code=c.comp_code and m.comp_code=s.comp_code
		and s.comp_code=p.comp_code and s.comp_code=o.comp_code
		and s.publ=p.publ and s.publ=o.publ_code
		and (s.publ=@ppubl_code or @ppubl_code is null or @ppubl_code ='')
		
		and m.unit=s.unit and m.agcd=s.agcd
		and m.dpcd=s.dpcd and m.city_code=c.city_code
		and m.comp_code=@pcomp_code 
		and m.unit=@punit_code
	
		and (m.agcd=@pag_main_code or @pag_main_code is null or @pag_main_code ='') 
		and (m.dpcd=@pag_sub_code or @pag_sub_code is null or @pag_sub_code='')
		order by branch_name,ag_name;
		

open cur_agency
		fetch NEXT FROM cur_agency INTO @rec_agency_zone_name ,@rec_agency_state_name,@rec_agency_branch_name,@rec_agency_city_code,@rec_agency_city_name,@rec_agency_ag_name,@rec_agency_comp_code,@rec_agency_unit,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_branch_code,@rec_agency_publ,@rec_agency_publ_name,@rec_agency_pnick,@rec_agency_period,@rec_agency_pro_type,@rec_agency_product,@rec_agency_credit_days,@rec_agency_credit_limit
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
			set @debit_amt_daily   =0;  
			set @debit_amt_weekly =0;  
			set @debit_amt_monthly =0;  
			set @debit_amt_mags    =0;  
			set @debit_amt_istall  =0; 

			declare c_bill cursor for
				select distinct billno,billdt,sum(amount) bill_amt from cir_outmast
				where comp_code=@pcomp_code and unit_code=@punit_code and publ=@rec_agency_publ
				and agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
				billdt<=@vtodt and isnull(amount,0)>0
				group by comp_code,billno,billdt
				union all
				select distinct recptno billno,recptdt billdt,sum(amount) bill_amt from cir_outmast
				where comp_code=@pcomp_code and unit_code=@punit_code and publ=@rec_agency_publ and
				agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
				recptdt<=@vtodt and isnull(amount,0)>0 and billno is null
				group by comp_code,recptno,recptdt order by 2,1
                          
				     --having  sum(amount)<0
					open c_bill
							fetch NEXT FROM c_bill INTO @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt
							WHILE (@@FETCH_STATUS = 0) 
							begin
								print('enter second')								
								set @v_dt    = @v_bill_billdt
								set @v_ondt  = @vtodt
								set @v_days=datediff(dd,@v_ondt,@v_dt);
								
								print(@v_dt)
								print(@v_ondt)

								if @v_days<0 begin
									set @v_days=0;
								end
								print('x')
								print(@v_days)
								set @v_dispute_amt          =0;
								set @v_over_total           =0;
								set @v_index                =0;   
								set @v_amt                  =0;
								set @v_amt_daily            =0;
								set @v_amt_weekly           =0;
								set @v_amt_monthly          =0;
								set @v_amt_mags             =0;
								set @v_amt_install          =0;	

								if (@v_days>=@rec_agency_credit_days  and @rec_agency_period='1' and @rec_agency_pro_type='NE0') 
								begin
									select @v_amt_daily=sum(amount)  from cir_outmast m,cir_supply s,cir_publ_mast p,cir_overdue_mast o
									where p.comp_code=o.comp_code and p.publ=o.publ_code 
									and m.comp_code=s.comp_code
									and s.comp_code=p.comp_code and s.comp_code=o.comp_code
									and s.publ=p.publ and s.publ=o.publ_code
									and m.unit_code=s.unit and m.agcd=s.agcd
									and m.dpcd=s.dpcd and p.period='1' and p.pro_type='NE0'
									and m.comp_code=@pcomp_code and unit_code=@punit_code
									and m.agcd=@rec_agency_agcd and m.dpcd=@rec_agency_dpcd and
									billno=@v_bill_billno and billdt=@v_bill_billdt and 
									recptdt<=@vasondt and amount<0 and m.dispute_flag<>'Y'

									set @v_amt_daily      =isnull(@v_bill_bill_amt,0)+isnull(@v_amt_daily,0)
									set @debit_amt_daily  =isnull(@debit_amt_daily,0)+isnull(@v_amt_daily,0)
								end
								else if (@v_days>=@rec_agency_credit_days  and @rec_agency_period='7' and @rec_agency_pro_type='NE0')  
								begin
									select @v_amt_weekly=sum(amount) from cir_outmast m,cir_supply s,cir_publ_mast p,cir_overdue_mast o
									where p.comp_code=o.comp_code and p.publ=o.publ_code 
									and m.comp_code=s.comp_code
									and s.comp_code=p.comp_code and s.comp_code=o.comp_code
									and s.publ=p.publ and s.publ=o.publ_code
									and m.unit_code=s.unit and m.agcd=s.agcd
									and m.dpcd=s.dpcd and p.period='7' and p.pro_type='NE0'
									and m.comp_code=@pcomp_code and unit_code=@punit_code 
									and m.agcd=@rec_agency_agcd and m.dpcd=@rec_agency_dpcd and
									billno=@v_bill_billno and billdt=@v_bill_billdt and 
									recptdt<=@vasondt and amount<0 and m.dispute_flag<>'Y';
									set @v_amt_weekly     =isnull(@v_bill_bill_amt,0)+isnull(@v_amt_weekly,0);
									set @debit_amt_weekly=isnull(@debit_amt_weekly,0)+isnull(@v_amt_weekly,0);
								end
								else if (@v_days>=@rec_agency_credit_days  and @rec_agency_period='30' and @rec_agency_pro_type='NE0') begin
									select @v_amt_monthly=sum(amount) from cir_outmast m,cir_supply s,cir_publ_mast p,cir_overdue_mast o
									where p.comp_code=o.comp_code and p.publ=o.publ_code 
									and m.comp_code=s.comp_code
									and s.comp_code=p.comp_code and s.comp_code=o.comp_code
									and s.publ=p.publ and s.publ=o.publ_code
									and m.unit_code=s.unit and m.agcd=s.agcd
									and m.dpcd=s.dpcd and p.period='30' and p.pro_type='NE0'
									and m.comp_code=@pcomp_code and m.unit_code=@punit_code 
									and m.agcd=@rec_agency_agcd and m.dpcd=@rec_agency_dpcd and
									billno=@v_bill_billno and billdt=@v_bill_billdt and 
									recptdt<=@vasondt and amount<0 and m.dispute_flag<>'Y';
									set @v_amt_monthly    =isnull(@v_bill_bill_amt,0)+isnull(@v_amt_monthly,0);
									set @debit_amt_monthly=isnull(@debit_amt_monthly,0)+isnull(@v_amt_monthly,0)
								end
								else if (@v_days>=@rec_agency_credit_days   and @rec_agency_pro_type='ME0') begin
									select @v_amt_mags=sum(amount) from cir_outmast m,cir_supply s,cir_publ_mast p,cir_overdue_mast o
									where p.comp_code=o.comp_code and p.publ=o.publ_code 
									and m.comp_code=s.comp_code
									and s.comp_code=p.comp_code and s.comp_code=o.comp_code
									and s.publ=p.publ and s.publ=o.publ_code
									and m.unit_code=s.unit and m.agcd=s.agcd
									and m.dpcd=s.dpcd and p.pro_type='ME0'
									and m.comp_code=@pcomp_code and m.unit_code=@punit_code 
									and m.agcd=@rec_agency_agcd and m.dpcd=@rec_agency_dpcd and
									billno=@v_bill_billno and billdt=@v_bill_billdt and 
									recptdt<=@vasondt and amount<0 and m.dispute_flag<>'Y'
									set @v_amt_mags       =isnull(@v_bill_bill_amt,0)+isnull(@v_amt_mags,0);
									set @debit_amt_mags  =isnull(@debit_amt_mags,0)+isnull(@v_amt_mags,0); 
								end  
								else
								begin
									select @v_amt_install=sum(inst_due_amt) from cir_inst_bill_det m,cir_installment_mast s
									where m.comp_code=s.comp_code
									and m.unit_code=s.unit_code and m.agcd=s.agcd
									and m.dpcd=s.dpcd 
									and m.comp_code=@pcomp_code and m.unit_code=@punit_code and
									m.agcd=@rec_agency_agcd and m.dpcd=@rec_agency_dpcd and
									inst_billno=@v_bill_billno and inst_billdt=@v_bill_billdt and 
									recptdt<=@vasondt and inst_due_amt<0 and @v_days>=s.over_due_days;
								end								
							
								select @v_dispute_amt=sum(amount) from cir_outmast
								where  comp_code=@pcomp_code and unit_code=@punit_code
								and agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
								billno=@v_bill_billno and billdt=@v_bill_billdt and 
								recptdt<=@vasondt and amount<0 and dispute_flag='Y';

								select @v_billamt=sum(amount)  from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and 
								agcd=@rec_agency_agcd  and dpcd=@rec_agency_dpcd and billdt >= @v_opdate and billdt<@vtodt 
								and  recptno is null and dispute_flag<>'Y';
								
								select @v_dbcramt=sum(amount)  from cir_rcphdr
								where  comp_code=@pcomp_code and unit_code=@punit_code and 
								agcd=@rec_agency_agcd  and dpcd=@rec_agency_dpcd and recptdt>= @v_opdate and recptdt<@vtodt  ;

								set @v_opbal=isnull(@v_billamt,0)+isnull(@v_dbcramt,0);
								set @v_billamt=0;
								
								select @v_billamt=sum(amount)  from cir_outmast
								where comp_code=@pcomp_code and unit_code=@punit_code and 
								agcd=@rec_agency_agcd  and dpcd=@rec_agency_dpcd  and billdt >= @vtodt and billdt<=@vasondt and 
								recptno is null and dispute_flag<>'Y';
								 
								select @v_othdbamt=sum(amount) from cir_rcphdr
								where comp_code=@pcomp_code and unit_code=@punit_code and 
								agcd=@rec_agency_agcd  and dpcd=@rec_agency_dpcd and recptdt<=@vasondt and isnull(amount,0)>0;

								select @v_recamt=sum(amount)  from cir_rcphdr
								where comp_code=@pcomp_code and unit_code=@punit_code and 
								agcd=@rec_agency_agcd  and dpcd=@rec_agency_dpcd  and doctype='RCR' and  isnull(amount,0)<0;

								select @v_othcramt=sum(amount) from cir_rcphdr
								where comp_code=@pcomp_code and unit_code=@punit_code and agcd=@rec_agency_agcd  and dpcd=@rec_agency_dpcd and doctype<>'RCR' and 
								isnull(amount,0)<0;
								set @v_clbal=isnull(@v_opbal,0)+isnull(@v_billamt,0)+isnull(@v_othdbamt,0)+isnull(@v_recamt,0)+isnull(@v_othcramt,0); 
							
							fetch NEXT FROM c_bill INTO @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt
							end
					close c_bill		
				deallocate c_bill
		
		set @v_over_total =isnull(@debit_amt_daily,0)+isnull(@debit_amt_weekly,0)+isnull(@debit_amt_monthly,0)+isnull(@debit_amt_mags,0)+isnull(@debit_amt_istall,0);
		
		if @v_over_total>@v_clbal begin
			set @v_index = (@v_over_total/@v_clbal*100)-1; 
		end
        else
        begin             
        set @v_index=1;
        end
        set @v_amt=isnull(@debit_amt_daily,0)+isnull(@debit_amt_weekly,0)+isnull(@debit_amt_monthly,0)+isnull(@debit_amt_mags,0)+isnull(@debit_amt_istall,0);
		if @v_amt=0 begin
			 set @debit_amt_daily    =0;
             set @debit_amt_weekly   =0;
             set @debit_amt_monthly  =0;
             set @debit_amt_mags     =0;
             set @debit_amt_istall   =0;
		end
		
		print('zzz')
		insert into #cir_temp_overdue (comp_code,unit_code, bran_code, agcd, dpcd, ag_name,
         branch_name, zone_name, state_name, city_name,product,daily_amt, weekly_amt, monthly_amt, mags_amt,install_amt, overdue_total,
         outs_total, index_amt, dispute, sessionid)
         values (@rec_agency_comp_code,@rec_agency_unit,@rec_agency_branch_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_ag_name,
         @rec_agency_branch_name,@rec_agency_zone_name,@rec_agency_state_name,@rec_agency_city_name,@rec_agency_product,
         isnull(@debit_amt_daily,0),isnull(@debit_amt_weekly,0),isnull(@debit_amt_monthly,0),isnull(@debit_amt_mags,0),isnull(@debit_amt_istall,0),
          @v_over_total,@v_clbal,@v_index,@v_dispute_amt ,@@spid);
		print('xxx')
		
		set @debit_amt_daily  =0;
        set @debit_amt_weekly =0;
        set @debit_amt_monthly=0;
        set @debit_amt_mags   =0;
        set @debit_amt_istall =0;
		
		fetch NEXT FROM cur_agency INTO @rec_agency_zone_name ,@rec_agency_state_name,@rec_agency_branch_name,@rec_agency_city_code,@rec_agency_city_name,@rec_agency_ag_name,@rec_agency_comp_code,@rec_agency_unit,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_branch_code,@rec_agency_publ,@rec_agency_publ_name,@rec_agency_pnick,@rec_agency_period,@rec_agency_pro_type,@rec_agency_product,@rec_agency_credit_days,@rec_agency_credit_limit
		    
		end
		
close cur_agency;

deallocate cur_agency


select 
   sum(daily_amt) daily_amt, sum(weekly_amt) weekly_amt, sum(monthly_amt) monthly_amt,sum(mags_amt) mags_amt,sum(install_amt) install_amt,
  sum(overdue_total) overdue_total,sum(outs_total) outs_total,sum(index_amt) index_amt,sum(dispute) dispute
  from #cir_temp_overdue  where sessionid=@@spid 

drop table #cir_temp_overdue

	




      




















////////////////////
                                                         
                                          
ALTER PROCEDURE [dbo].[cir_credit_rating_monthly_ageing]   
@pcomp_code          as varchar(200),
@punit_code          as varchar(200),
@pbranch            as varchar(200),
@ppubl_code          as varchar(200),
@pagtype             as varchar(200),
@pagclass            as varchar(200),
@pag_main_code       as varchar(200),
@pag_sub_code        as varchar(200),
@paging_by           as varchar(200),
@pdebitupto_date     as varchar(200),
@pcreditupto_date    as varchar(200),
@ptill_days1         as numeric(10),
@ptill_days2         as numeric(10),
@ptill_days3         as numeric(10),
@ptill_days4         as numeric(10),
@ptill_days5         as numeric(10),
@ptill_days6         as numeric(10),
@pval                as varchar(200)
As

     
declare  @cur_date   as datetime
declare  @vtodt  as datetime     
declare  @vasondt    as datetime
declare  @v_dt  as datetime
declare @v_ondt as datetime
declare  @v_days numeric(10)
declare  @curr_days numeric(10)

declare  @curr_v_amt          numeric(14,2);
declare  @v_sub_total         numeric(14,2);
declare  @v_grand_total       numeric(14,2);
declare  @v_install_amt       numeric(14,2);
declare  @v_dispute           numeric(14,2); 
declare  @v_amt               numeric(14,2);
declare  @v_amt_pend               numeric(14,2);
declare  @v_amt030            numeric(14,2);
declare  @v_amt3160           numeric(14,2);
declare  @v_amt6190           numeric(14,2);
declare  @v_amt91120          numeric(14,2);
declare  @v_amt121180         numeric(14,2);
declare  @v_amt181            numeric(14,2);
declare  @debit_curr_v_amt    numeric(14,2)  
declare  @debit_amt_030       numeric(14,2)
declare  @debit_amt_3160      numeric(14,2) 
declare  @debit_amt_6190      numeric(14,2)
declare  @debit_amt_91120     numeric(14,2)
declare  @debit_amt_121180    numeric(14,2)
declare  @debit_amt_181       numeric(14,2)
declare  @debit_amt_dispute   numeric(14,2)

set  @debit_curr_v_amt   =0 
set  @debit_amt_030      =0  
set  @debit_amt_3160     =0  
set  @debit_amt_6190     =0  
set  @debit_amt_91120    =0  
set  @debit_amt_121180   =0  
set  @debit_amt_181      =0 
set  @debit_amt_dispute  =0

set @vtodt=@pdebitupto_date
set @vasondt=@pcreditupto_date
set @cur_date=dbo.GetFirstDayOfMonth (@pdebitupto_date)

CREATE TABLE #CIR_TEMP_AGEING_REPORT
(
  COMP_CODE    VARCHAR(8),
  UNIT_CODE    VARCHAR(8),
  BRAN_CODE    VARCHAR(8),
  AGCD         VARCHAR(8),
  DPCD         VARCHAR(8),
  AG_NAME      VARCHAR(100),
  BRANCH_NAME  VARCHAR(100),
  ZONE_NAME    VARCHAR(100),
  STATE_NAME   VARCHAR(100),
  CITY_NAME    VARCHAR(100),
  PRODUCT      VARCHAR(100),
  CURRENT_AMT  NUMERIC(14,2),
  MONTH_1      NUMERIC(14,2),
  MONTH_2      NUMERIC(14,2),
  MONTH_3      NUMERIC(14,2),
  MONTH_4      NUMERIC(14,2),
  MONTH_5      NUMERIC(14,2),
  MONTH_6      NUMERIC(14,2),
  PENDING_AMT  NUMERIC(14,2),
  SUB_TOTAL    NUMERIC(14,2),
  DISPUTE      NUMERIC(14,2),
  INSTALL_AMT  NUMERIC(14,2),
  GRAND_TOTAL  NUMERIC(14,2),
  SESSIONID    NUMERIC(14)
)

-- cursor cur_agency variables
declare @rec_agency_zone_name as varchar(300)
declare @rec_agency_state_name as varchar(200)
declare @rec_agency_branch_name as varchar(300)
declare @rec_agency_city_code as varchar(200)
declare @rec_agency_city_name as varchar(300)
declare @rec_agency_ag_name as varchar(300)
declare @rec_agency_comp_code as varchar(20)
declare @rec_agency_unit as varchar(30)
declare @rec_agency_agcd as varchar(20)
declare @rec_agency_dpcd as varchar(30)
declare @rec_agency_branch_code as varchar(30)
declare @rec_agency_publ as varchar(20)
declare @rec_agency_publ_name as varchar(300)
declare @rec_agency_pnick as varchar(30)
declare @rec_agency_period as varchar(20)
declare @rec_agency_pro_type as varchar(300)
declare @rec_agency_product as varchar(300)
declare @rec_agency_credit_days as int
declare  @bill_pending_amt as numeric(14,2)
declare @rec_agency_credit_limit as numeric(14,2)

-- cursor v_bill variables
declare @v_bill_billno as varchar(50)
declare @v_bill_billdt as varchar(30)
declare @v_bill_bill_amt as numeric(15,2)
declare @v_bill_bill_amt_curr as numeric(15,2)

-- cursor v_pending_rcpt variables  
declare @v_pending_rcpt_ag_main_code as varchar(30)
declare @v_pending_rcpt_ag_sub_code as varchar(50)
declare @v_pending_rcpt_amount as numeric(15,2)
set   @bill_pending_amt  =0
	declare cur_agency cursor for
		select distinct 
		dbo.cir_get_zone_name(m.comp_code,c.zone_code) zone_name,
		dbo.cir_get_state(m.comp_code,c.country_code,c.state_code) state_name ,
		dbo.cir_get_branch(m.comp_code,m.branch_code) branch_name,
		m.city_code city_code,c.city_name city_name,M.Ag_Name ag_name,
		m.comp_code comp_code,m.unit unit,m.agcd agcd,m.dpcd dpcd,
		m.branch_code branch_code,p.publ publ, p.publ_name publ_name, p.pnick pnick,
		case when p.pro_type='NE0' then 'Newspaper' when p.pro_type='ME0' then 'Magzine' else p.pro_type end product,
		o.credit_days credit_days,o.credit_limit credit_limit
		from cir_agmast m,cir_city_mast c,cir_supply s,cir_publ_mast p,cir_overdue_mast o
		where p.comp_code=o.comp_code and p.publ=o.publ_code 
		and m.comp_code=c.comp_code and m.comp_code=s.comp_code
		and s.comp_code=p.comp_code and s.comp_code=o.comp_code
		and s.publ=p.publ and s.publ=o.publ_code
		and (s.publ=@ppubl_code or @ppubl_code is null or @ppubl_code ='')
		and m.unit=s.unit and m.agcd=s.agcd
		and m.dpcd=s.dpcd and m.city_code=c.city_code
		and m.comp_code=@pcomp_code 
		and m.unit=@punit_code
		AND (p.pro_type NOT LIKE @pval+'%' or @pval is null or @pval='')
		and (m.agcd=@pag_main_code or @pag_main_code is null or @pag_main_code ='') 
		and (m.dpcd=@pag_sub_code or @pag_sub_code is null or @pag_sub_code='')
		order by branch_name,ag_name;
		

open cur_agency
		fetch NEXT FROM cur_agency INTO @rec_agency_zone_name ,@rec_agency_state_name,@rec_agency_branch_name,@rec_agency_city_code,
@rec_agency_city_name,@rec_agency_ag_name,@rec_agency_comp_code,@rec_agency_unit,@rec_agency_agcd,@rec_agency_dpcd,
@rec_agency_branch_code,@rec_agency_publ,@rec_agency_publ_name,@rec_agency_pnick--,@rec_agency_period,
,@rec_agency_product,
@rec_agency_credit_days,@rec_agency_credit_limit
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
			set @debit_amt_030     =0;  
			set @debit_amt_3160    =0;  
			set @debit_amt_6190    =0;  
			set @debit_amt_91120   =0;  
			set @debit_amt_121180  =0;  
			set @debit_amt_181     =0; 
			set @debit_amt_dispute =0;
set @bill_pending_amt = 0;
			declare c_bill cursor for
				select distinct billno,billdt,sum(amount) bill_amt from cir_outmast
				where comp_code=@pcomp_code and unit_code=@punit_code --and publ=@rec_agency_publ
				and agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
				billdt<=@vtodt and isnull(amount,0)>0
				group by comp_code,billno,billdt
				union all
				select distinct recptno billno,recptdt billdt,sum(amount) bill_amt from cir_outmast
				where comp_code=@pcomp_code and unit_code=@punit_code and --publ=@rec_agency_publ and
				agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
				recptdt<=@vtodt and isnull(amount,0)>0 and billno is null
				group by comp_code,recptno,recptdt order by 2,1
             
                          
				     --having  sum(amount)<0
					open c_bill
							fetch NEXT FROM c_bill INTO @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt
							WHILE (@@FETCH_STATUS = 0) 
							begin
								print('enter second')								
								set @v_dt    = @v_bill_billdt
								set @v_ondt  = @vtodt
								
								if @paging_by='D' begin								
									set @v_days= datediff(dd,@v_ondt,@v_dt);
								end
								else  
								begin  
									set @v_days=datediff(dd,@v_ondt,@v_dt)+1
								end    
								if @v_days<0 begin
									set @v_days=0;
								end
								
								
									set @curr_v_amt          =0;
									set @v_sub_total         =0;
									set @v_grand_total       =0;
									set @v_install_amt       =0;
									set @v_amt               =0;
									set @v_amt_pend=0
									set @v_amt030            =0;
									set @v_amt3160           =0;
									set @v_amt6190           =0;
									set @v_amt91120          =0;
									set @v_amt121180         =0;
									set @v_amt181            =0;
									set @v_dispute           =0;
									
									if @curr_days>0 begin
										select @curr_v_amt=isnull(sum(amount),0) from cir_outmast
										where comp_code=@pcomp_code and unit_code=@punit_code and
										agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
										billno=@v_bill_billno and billdt=@v_bill_billdt and 
										recptdt between @cur_date and  @vtodt and amount<0 and dispute_flag<>'Y' ;

										set @curr_v_amt  =isnull(@v_bill_bill_amt_curr,0)+isnull(@curr_v_amt,0);
										set @debit_curr_v_amt   =isnull(@debit_curr_v_amt,0)+isnull(@curr_v_amt,0);

									end	
									
									if @v_days>0 begin 
										select @v_install_amt=sum(inst_due_amt)  
										from cir_inst_bill_det m,cir_installment_mast s
										where m.comp_code=s.comp_code
										and m.unit_code=s.unit_code and m.agcd=s.agcd
										and m.dpcd=s.dpcd 
										and m.comp_code=@pcomp_code and m.unit_code=@punit_code and
										m.agcd=@rec_agency_agcd and m.dpcd=@rec_agency_dpcd and
										inst_billno=@v_bill_billno and inst_billdt=@v_bill_billdt and 
										recptdt<=@vasondt and inst_due_amt<0 and @v_days>=s.over_due_days; 
									end

									if @v_days between 0 and @ptill_days1 
									begin
										select @v_amt030=sum(amount) from cir_outmast 
										where comp_code=@pcomp_code and unit_code=@punit_code and
										agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
										billno=@v_bill_billno and billdt=@v_bill_billdt and 
										recptdt<=@vasondt and amount<0 and dispute_flag<>'Y';
										set @v_amt030        =isnull(@v_bill_bill_amt,0)+isnull(@v_amt030,0);
										set @debit_amt_030   =isnull(@debit_amt_030,0)+isnull(@v_amt030,0);
									end
									else if @v_days between isnull( @ptill_days1,0) and @ptill_days2 
									begin
										select @v_amt3160=sum(amount) from cir_outmast 
										where comp_code=@pcomp_code and unit_code=@punit_code and
										agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
										billno=@v_bill_billno and billdt=@v_bill_billdt and 
										recptdt<=@vasondt and amount<0 and dispute_flag<>'Y';
										set @v_amt3160     =isnull(@v_bill_bill_amt,0)+isnull(@v_amt3160,0);
										set @debit_amt_3160=isnull(@debit_amt_3160,0)+isnull(@v_amt3160,0);
									end
									else if @v_days between isnull(@ptill_days2,0)+1 and @ptill_days3 
									begin
										select @v_amt6190=sum(amount) from cir_outmast 
										where comp_code=@pcomp_code and unit_code=@punit_code and
										agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
										billno=@v_bill_billno and billdt=@v_bill_billdt and 
										recptdt<=@vasondt and amount<0 and dispute_flag<>'Y';
										set @v_amt6190     =isnull(@v_bill_bill_amt,0)+isnull(@v_amt6190,0);
										set @debit_amt_6190=isnull(@debit_amt_6190,0)+isnull(@v_amt6190,0);
									end
									else if @v_days between isnull(@ptill_days3,0)+1 and @ptill_days4 
									begin
										select @v_amt91120=sum(amount)  from cir_outmast 
										where comp_code=@pcomp_code and unit_code=@punit_code and
										agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
										billno=@v_bill_billno and billdt=@v_bill_billdt and 
										recptdt<=@vasondt and amount<0 and dispute_flag<>'Y';

										set @v_amt91120        =isnull(@v_bill_bill_amt,0)+isnull(@v_amt91120,0);
										set @debit_amt_91120   =isnull(@debit_amt_91120,0)+isnull(@v_amt91120,0); 
									end
									else if @v_days between isnull(@ptill_days4,0)+1 and @ptill_days5 
									begin
										select @v_amt121180=sum(amount)  from cir_outmast 
										where comp_code=@pcomp_code and unit_code=@punit_code and
										agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
										billno=@v_bill_billno and billdt=@v_bill_billdt and 
										recptdt<=@vasondt and amount<0 and dispute_flag<>'Y';

										set @v_amt121180       =isnull(@v_bill_bill_amt,0)+isnull(@v_amt121180,0);
										set @debit_amt_121180  =isnull(@debit_amt_121180,0)+isnull(@v_amt121180,0);                  
									end
									else
									begin
										select @v_amt181=sum(amount) from cir_outmast 
										where comp_code=@pcomp_code and unit_code=@punit_code and
										agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
										billno=@v_bill_billno and billdt=@v_bill_billdt and 
										recptdt<=@vasondt and amount<0 and dispute_flag<>'Y';

										set @v_amt181      =isnull(@v_bill_bill_amt,0)+isnull(@v_amt181,0);
										set @debit_amt_181 =isnull(@debit_amt_181,0)+isnull(@v_amt181,0);

									end 

									select @v_dispute=sum(amount) from cir_outmast 
									where comp_code=@pcomp_code and unit_code=@punit_code and
									agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
									billno=@v_bill_billno and billdt=@v_bill_billdt and 
									recptdt<=@vasondt and amount<0 and dispute_flag='Y';

									set @v_dispute      =isnull(@v_bill_bill_amt,0)+isnull(@v_dispute,0);
									set @debit_amt_dispute =isnull(@debit_amt_dispute,0)+isnull(@v_dispute,0);
									
							fetch NEXT FROM c_bill INTO @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt
							end
					close c_bill		
				deallocate c_bill
		
		set @v_sub_total=isnull(@debit_curr_v_amt,0)+isnull(@debit_amt_030,0)+isnull(@debit_amt_3160,0)+isnull(@debit_amt_6190,0)+isnull(@debit_amt_91120,0)+isnull(@debit_amt_121180,0)+isnull(@debit_amt_181,0);
        
        set @v_grand_total=isnull(@debit_curr_v_amt,0)+isnull(@debit_amt_030,0)+isnull(@debit_amt_3160,0)+isnull(@debit_amt_6190,0)+isnull(@debit_amt_91120,0)+isnull(@debit_amt_121180,0)+isnull(@debit_amt_181,0)+isnull(@v_install_amt,0)+isnull(@debit_amt_dispute,0);
        
        set @v_amt=isnull(@debit_curr_v_amt,0)+isnull(@debit_amt_030,0)+isnull(@debit_amt_3160,0)+isnull(@debit_amt_6190,0)+isnull(@debit_amt_91120,0)+isnull(@debit_amt_121180,0)+isnull(@debit_amt_181,0);
        set @v_amt_pend=isnull(@debit_amt_030,0)+isnull(@debit_amt_3160,0)+isnull(@debit_amt_6190,0)+isnull(@debit_amt_91120,0)+isnull(@debit_amt_121180,0)+isnull(@debit_amt_181,0);
        if @v_amt=0 begin
             set @debit_curr_v_amt   =0;
             set @debit_amt_030      =0;
             set @debit_amt_3160     =0;
             set @debit_amt_6190     =0;
             set @debit_amt_91120    =0;
             set @debit_amt_121180   =0;
             set @debit_amt_181      =0;
        end
        
        
        
        
        /*************************/
       
        else
        begin
          
            set @bill_pending_amt=isnull(@v_amt_pend,0)
        end
        /*************************************/
         insert into #cir_temp_ageing_report (comp_code,unit_code, bran_code, agcd, dpcd, ag_name,
         branch_name, zone_name, state_name, city_name,product,
         current_amt,month_1, month_2,month_3,month_4,month_5,month_6,PENDING_AMT,sub_total,install_amt,dispute,grand_total,sessionid)
         values (@rec_agency_comp_code,@rec_agency_unit,@rec_agency_branch_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_ag_name,
         @rec_agency_branch_name,@rec_agency_zone_name,@rec_agency_state_name,@rec_agency_city_name,@rec_agency_product,
         isnull(@debit_curr_v_amt,0),isnull(@debit_amt_030,0),isnull(@debit_amt_3160,0),isnull(@debit_amt_6190,0),isnull(@debit_amt_91120,0),
         isnull(@debit_amt_121180,0), isnull(@debit_amt_181,0),@bill_pending_amt,isnull(@v_sub_total,0),isnull(@v_install_amt,0),isnull(@debit_amt_dispute,0),@v_grand_total,@@SPID);
        
    
        set @debit_curr_v_amt=0;
        set @debit_amt_030   =0;
        set @debit_amt_3160  =0;
        set @debit_amt_6190  =0;
        set @debit_amt_91120 =0;
        set @debit_amt_121180=0;
        set @debit_amt_181   =0;
        set @v_sub_total     =0; 
		 set @bill_pending_amt = 0
		fetch NEXT FROM cur_agency INTO @rec_agency_zone_name ,@rec_agency_state_name,@rec_agency_branch_name,@rec_agency_city_code,@rec_agency_city_name,@rec_agency_ag_name,
@rec_agency_comp_code,@rec_agency_unit,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_branch_code,@rec_agency_publ,
@rec_agency_publ_name,@rec_agency_pnick--,@rec_agency_period
,@rec_agency_product,@rec_agency_credit_days,@rec_agency_credit_limit
		    
		end
		
close cur_agency;

deallocate cur_agency



 select sum(current_amt) current_amt, sum(month_1) month_1, sum(month_2) month_2, sum(month_3) month_3, sum(month_4) month_4, sum(month_5) month_5, 
 sum(month_6) month_6, sum(pending_amt)pending_amt,sum(sub_total) sub_total, sum(dispute) dispute, sum(install_amt) install_amt,sum(grand_total) grand_total 
 from #cir_temp_ageing_report
       where  sessionid=@@spid 
   
      
drop table #cir_temp_ageing_report

	




      





















////////////////////


ALTER PROCEDURE [dbo].[cir_credit_rating_block]
	@pcompcode               as varchar(20),
    @punitcode               as varchar(20),
    @pbranchcode             as varchar(20),    
    @pstatus                 as varchar(20), --   U/B  
    @pagcd                   as varchar(20),   
    @pdpcd                   as varchar(20),    
    @pfrom_date              as varchar(20),
    @ptill_date              as varchar(20),   
    @pdateformat             as varchar(20)

AS 
SET CONCAT_NULL_YIELDS_NULL OFF
	declare @vvar       varchar(8000)
	declare @tot_vvar   varchar(8000)
	declare @vtot_publ  varchar(8000)
	declare @v_cnt      int
	declare @rec_susp_code	as varchar(20) 
	declare @rec_susp_name	as varchar(200)
    declare @pvar as varchar(20)

	if @pstatus = 'B'
	begin
		declare cur_reason cursor for			
			select suspend_type_code,suspend_desc from CIR_SUSPEND_TYPE_MAST s where s.COMP_CODE=@pcompcode-- and s.block_reason='Y'
	
    open cur_reason
        fetch NEXT FROM cur_reason INTO @rec_susp_code,@rec_susp_name
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
          set @v_cnt =isnull(@v_cnt,0)+1
			  if @vvar is null 
				Begin
				  set @vvar      ='case when s.suspty='+''''+@rec_susp_code+''''+' then ''Y'' else ''N'' end "'+@rec_susp_name+'"';
				End
			  else
				Begin
				  set @vvar      =@vvar+',case when s.suspty='+''''+@rec_susp_code+''''+' then ''Y'' else ''N'' end "'+@rec_susp_name+'"'
				End	
		
			fetch NEXT FROM cur_reason INTO @rec_susp_code,@rec_susp_name
		End
    close cur_reason
    deallocate cur_reason
     
declare @pquery as varchar(max)	
		set @pquery='select a.AGCD dealer_code,a.AG_NAME dealer_name,a.AGEING_TYPE,isnull(s.AGENCY_UNBLOCK_TYPE,''A'') as auto_manual,substring(CONVERT(VARCHAR(12), s.TRN_DATE, 114),1,5) as time,s.TRN_DATE tran_date
		
		,'+@vvar+'
		,(SELECT COUNT(*) FROM  CIR_SUSPEND_TRAN t where 
		t.COMP_CODE='''+@pcompcode+'''
		and t.COMP_CODE=a.COMP_CODE and t.AGCD=a.AGCD and t.DPCD=a.dpcd
		and t.COMP_CODE=s.COMP_CODE and t.AGCD=s.AGCD and t.DPCD=s.dpcd
		and (Select l.block_reason from CIR_SUSPEND_TYPE_MAST l where l.COMp_CODE='''+@pcompcode+''' and l.SUSPEND_TYPE_CODE=t.SUSPTY )=''Y''
		and (t.UNIT=isnull('''+@punitcode+''',t.UNIT) or '''+@punitcode+''' ='''')
		and (a.BRANCH_CODE=ISNULL('''+@pbranchcode+''',a.BRANCH_CODE) or '''+@pbranchcode+''' ='''')
		and (t.AGCD=ISNULL('''+@pagcd+''',t.agcd) or '''+@pagcd+'''='''') 
		and (t.dpcd=ISNULL('''+@pdpcd+''',t.dpcd) or '''+@pdpcd+'''='''')
		and (t.TRN_DATE between '''+cast(@pfrom_date as varchar)+''' and '''+cast(@ptill_date as varchar)+''')
		) NO_OF_TIMES_BLOCK
		from CIR_SUSPEND_TRAN s, CIR_AGMAST a where s.COMP_CODE='''+@pcompcode+'''
		and s.COMP_CODE=a.COMP_CODE and s.AGCD=a.AGCD and s.DPCD=a.dpcd
		and (Select l.block_reason from CIR_SUSPEND_TYPE_MAST l where l.COMp_CODE='''+@pcompcode+''' and l.SUSPEND_TYPE_CODE=s.SUSPTY )=''Y''
		and (s.UNIT=isnull('''+@punitcode+''',s.UNIT) or '''+@punitcode+''' ='''')
		and (a.BRANCH_CODE=ISNULL('''+@pbranchcode+''',a.BRANCH_CODE) or '''+@pbranchcode+''' ='''')
		and (s.AGCD=ISNULL('''+@pagcd+''',s.agcd) or '''+@pagcd+'''='''') and (s.dpcd=ISNULL('''+@pdpcd+''',s.dpcd) or '''+@pdpcd+'''='''')
		and (s.TRN_DATE between '''+cast(@pfrom_date as varchar)+''' and '''+cast(@ptill_date as varchar)+''')
		group by a.AGCD,a.AG_NAME,a.AGEING_TYPE,s.AGENCY_UNBLOCK_TYPE,s.USERID,s.SUSPTY,s.TRN_DATE ,
		a.comp_code ,a.dpcd,s.comp_code,s.agcd,s.dpcd 
		order by s.TRN_DATE'
		
		print(@pquery)
		exec(@pquery)
	
	end
	else
	begin

		select a.AGCD dealer_code,a.AG_NAME dealer_name,a.AGEING_TYPE,isnull(s.AGENCY_UNBLOCK_TYPE,'A') as auto_manual,substring(CONVERT(VARCHAR(12), s.TRN_DATE, 114),1,5) as time,s.TRN_DATE tran_date
		,(Select l.ROLE from login l where l.COM_CODE=@pcompcode and l.userid=s.USERID ) as user_group
		,(Select l.username from login l where l.COM_CODE=@pcompcode and l.userid=s.USERID ) as unblockby
		,(Select l.SUSPEND_DESC from CIR_SUSPEND_TYPE_MAST l where l.COMp_CODE=@pcompcode and l.SUSPEND_TYPE_CODE=s.SUSPTY ) as ub_reason
		from CIR_SUSPEND_TRAN s, CIR_AGMAST a where s.COMP_CODE=@pcompcode
		and s.COMP_CODE=a.COMP_CODE and s.AGCD=a.AGCD and s.DPCD=a.dpcd
		and (Select l.block_reason from CIR_SUSPEND_TYPE_MAST l where l.COMp_CODE=@pcompcode and l.SUSPEND_TYPE_CODE=s.SUSPTY )!='Y'
		and (s.UNIT=isnull(@punitcode,s.UNIT) or @punitcode ='')
		and (a.BRANCH_CODE=ISNULL(@pbranchcode,a.BRANCH_CODE) or @pbranchcode ='')
		and (s.AGCD=ISNULL(@pagcd,s.agcd) or @pagcd='') and (s.dpcd=ISNULL(@pdpcd,s.dpcd) or @pdpcd='')
		and (s.TRN_DATE between @pfrom_date and @ptill_date)
		group by a.AGCD,a.AG_NAME,a.AGEING_TYPE,s.AGENCY_UNBLOCK_TYPE,s.USERID,s.SUSPTY,s.TRN_DATE 
		order by s.TRN_DATE
		
	end
	
	SET CONCAT_NULL_YIELDS_NULL ON
	
	
	
////////

ALTER PROCEDURE [dbo].[cir_credit_rating_ageing]
@pcomp_code varchar(20),
@punit_code varchar(20),
@pbran_code varchar(20),
@pagtype      varchar(50),
@pagclass      varchar(50),
@pag_main_code varchar(50),
@pag_sub_code varchar(50),
@paging_by varchar(50),
@pdebitupto_date varchar(50),
@pcreditupto_date varchar(50),
@ptill_days1 varchar(20),
@ptill_days2 varchar(20),
@ptill_days3 varchar(30),
@ptill_days4 varchar(30),
@ptill_days5 varchar(50),
@ptill_days6 varchar(50),
@ppubl varchar(50)

AS

declare  @vtodt   as datetime
declare  @vasondt  as datetime     
declare  @v_dt    as datetime
declare  @v_ondt  as datetime
declare  @v_days numeric(10);

declare  @v_pending_rcpt_amt as numeric(14,2) 

declare  @v_amt     as    numeric(14,2);
declare  @v_amt030  as   numeric(14,2);
declare  @v_amt3160 as   numeric(14,2);
declare  @v_amt6190 as   numeric(14,2);
declare  @v_amt91120 as numeric(14,2);
declare  @v_amt121180   as numeric(14,2);
declare  @v_amt181   as numeric(14,2);

declare  @debit_amt_030  as  numeric(14,2)  --debit amt  for slab  1 days
declare  @debit_amt_3160 as  numeric(14,2)  --debit amt  for slab  2 days
declare  @debit_amt_6190 as  numeric(14,2)  --debit amt  for slab  3 days
declare  @debit_amt_91120 as numeric(14,2)  --debit amt  for slab  4 days
declare  @debit_amt_121180  as  numeric(14,2)  --debit amt  for >slab 5 days
declare  @debit_amt_181  as  numeric(14,2)  --debit amt  for >slab 6 days
declare  @bill_pending_amt as numeric(14,2)
declare  @rcpt_pending_amt  as numeric(14,2) --pending receipt amount

CREATE TABLE #cir_temp_ageing
(
  COMP_CODE     VARCHAR(8),
  UNIT_CODE     VARCHAR(8),
  BRAN_CODE     VARCHAR(8),
  AGCD          VARCHAR(8),
  DPCD          VARCHAR(8),
  AG_NAME       VARCHAR(100),
  CITY_NAME     VARCHAR(100),
  PENDING_AMT   NUMERIC(14,2),
  SLAB_1        NUMERIC(14,2),
  SLAB_2        NUMERIC(14,2),
  SLAB_3        NUMERIC(14,2),
  SLAB_4        NUMERIC(14,2),
  SLAB_5        NUMERIC(14,2),
  SLAB_6        NUMERIC(14,2),
  ON_ACAMT      NUMERIC(14,2),
  RECT_PENDING  NUMERIC(14,2),
  SESSIONID     NUMERIC(14),

  PUBL_TYPE_NAME          VARCHAR(200)
)

set @vtodt=@pdebitupto_date
set @vasondt=@pcreditupto_date

set @debit_amt_030  =0  --debit amt  for slab  1 days
set @debit_amt_3160  =0  --debit amt  for slab  2 days
set  @debit_amt_6190  =0  --debit amt  for slab  3 days
set   @debit_amt_91120  =0 --debit amt  for slab  4 days
set   @debit_amt_121180   =0  --debit amt  for >slab 4 days
set   @debit_amt_181   =0  --debit amt  for >slab 4 days
set   @bill_pending_amt  =0
set   @rcpt_pending_amt  =0  --pending receipt amount


    declare cur_agency cursor for
            select m.Comp_Code comp_code,m.agcd agcd,m.dpcd dpcd,m.ag_name agency_name,
            m.City_Code city_code,c.city_name city_name,m.credit_days credit_days,m.branch_code branch_name
            from cir_agmast m,cir_city_mast c
            where m.comp_code=c.comp_code and m.comp_code=@pcomp_code 
            and m.unit=@punit_code and m.city_code=c.city_code 
            
            and (m.agcd=@pag_main_code or @pag_main_code is null or @pag_main_code ='') 
            and (m.dpcd=@pag_sub_code or @pag_sub_code is null or @pag_sub_code ='')
            order by branch_name,agency_name; 
        

-- cursor cur_agency variables
declare @rec_agency_comp_code as varchar(30)
declare @rec_agency_agcd as varchar(20)
declare @rec_agency_dpcd as varchar(30)
declare @rec_agency_agency_name as varchar(300)
declare @rec_agency_city_code as varchar(200)
declare @rec_agency_city_name as varchar(200)
declare @rec_agency_credit_days as int
declare @rec_agency_branch_name as varchar(50)

-- cursor v_bill variables
declare @v_bill_billno as varchar(50)
declare @v_bill_billdt as varchar(30)
declare @v_bill_bill_amt as numeric(15,2)

-- cursor v_pending_rcpt variables  
declare @v_pending_rcpt_ag_main_code as varchar(30)
declare @v_pending_rcpt_ag_sub_code as varchar(50)
declare @v_pending_rcpt_amount as numeric(15,2)
DECLARE @v_publ VARCHAR(20)
DECLARE @v_pub_type VARCHAR(20)
DECLARE @v_pub_type_name VARCHAR(20)


--SELECT 'cursor has ' + CAST(@@CURSOR_ROWS AS VARCHAR) + ' rows'
open cur_agency
        fetch NEXT FROM cur_agency INTO @rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name ,@rec_agency_city_code ,@rec_agency_city_name ,@rec_agency_credit_days ,@rec_agency_branch_name
        WHILE (@@FETCH_STATUS = 0) 
        BEGIN
            --SELECT 'cursor has ' + CAST(@@CURSOR_ROWS AS VARCHAR) + ' rows'
            print @rec_agency_dpcd
            set @debit_amt_030 = 0;
            set @debit_amt_3160 = 0;
            set @debit_amt_6190 = 0;
            set @debit_amt_91120 = 0;
            set @debit_amt_121180 = 0;
            set @debit_amt_181 = 0;
            set @rcpt_pending_amt = 0;
            set @bill_pending_amt = 0;
            print('enter first')
            declare c_bill cursor for
                    select distinct billno,billdt,sum(amount) bill_amt 
                    
                    from cir_outmast a
                    where comp_code=@pcomp_code and unit_code=@punit_code and
                    agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
                    billdt<=@vtodt and isnull(amount,0)>0
                    and (isnull(publ,@ppubl)=@ppubl or @ppubl is null or @ppubl='' )
                   
                    group by comp_code,billno,billdt
                    union
                    select distinct recptno billno,recptdt billdt,sum(amount) bill_amt 
                    from cir_outmast a
                    where comp_code=@pcomp_code and unit_code=@punit_code and
                    agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
                    recptdt<=@vtodt and isnull(amount,0)>0 and billno is null
                    and (isnull(publ,@ppubl)=@ppubl or @ppubl is null or @ppubl='' )
                     
                    group by comp_code,recptno,recptdt order by 2,1
                          
                     --having  sum(amount)<0
                    open c_bill
                            fetch NEXT FROM c_bill INTO @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt
                            WHILE (@@FETCH_STATUS = 0) 
                            begin
                                print('enter second')
                                set @v_dt    = @v_bill_billdt
                                set @v_ondt  = @vtodt
                                print(@v_dt)
                                print(@v_ondt)
                                if @paging_by='D' begin
                                    set @v_days=DATEDIFF(dd, @v_dt,@v_ondt )---isnull(pcrdtday,0)+1;
                                end
                                else
                                begin    
                                    set @v_days=DATEDIFF(dd, @v_dt,@v_ondt )+1;
                                end
                                if @v_days<0 begin
                                    set @v_days=0;
                                end
                                print('x')
                                print(@v_days)
                                set @v_amt               =0;
                                set @v_amt030            =0;
                                set @v_amt3160           =0;
                                set @v_amt6190           =0;
                                set @v_amt91120          =0;
                                set @v_amt121180         =0;
                                set @v_amt181            =0;    

                                if @v_days between 0 and @ptill_days1 begin
                                    select @v_amt030=sum(amount) from cir_outmast 
                                    where comp_code=@pcomp_code and unit_code=@punit_code and
                                          agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
                                          billno=@v_bill_billno and billdt=@v_bill_billdt and 
                                          recptdt<=@vasondt and amount<0
                                           and (isnull(publ,@ppubl)=@ppubl or @ppubl is null or @ppubl='' )
                     

                                    set @v_amt030 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt030,0);
                                    set @debit_amt_030 =isnull(@debit_amt_030,0)+isnull(@v_amt030,0)
                                end
                                else if @v_days between isnull(@ptill_days1,0)+1 and @ptill_days2 begin
                                    select @v_amt3160=sum(amount) from cir_outmast 
                                    where comp_code=@pcomp_code and unit_code=@punit_code and
                                          agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
                                          billno=@v_bill_billno and billdt=@v_bill_billdt and 
                                          recptdt<=@vasondt and amount<0
                                           and (isnull(publ,@ppubl)=@ppubl or @ppubl is null or @ppubl='' )
                     
                                    --insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
                                    set @v_amt3160 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt3160,0);
                                    set @debit_amt_3160 =isnull(@debit_amt_3160,0)+isnull(@v_amt3160,0)
                                end
                                else if @v_days between isnull(@ptill_days2,0)+1 and @ptill_days3 begin
                                    select @v_amt6190=sum(amount) from cir_outmast 
                                    where comp_code=@pcomp_code and unit_code=@punit_code and
                                          agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
                                          billno=@v_bill_billno and billdt=@v_bill_billdt and 
                                          recptdt<=@vasondt and amount<0
                                           and (isnull(publ,@ppubl)=@ppubl or @ppubl is null or @ppubl='' )
                     
                                    --insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
                                    set @v_amt6190 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt6190,0);
                                    set @debit_amt_6190 =isnull(@debit_amt_6190,0)+isnull(@v_amt6190,0)
                                end
                                else if @v_days between isnull(@ptill_days3,0)+1 and @ptill_days4 begin
                                    select @v_amt91120=sum(amount) from cir_outmast 
                                    where comp_code=@pcomp_code and unit_code=@punit_code and
                                          agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
                                          billno=@v_bill_billno and billdt=@v_bill_billdt and 
                                          recptdt<=@vasondt and amount<0
                                           and (isnull(publ,@ppubl)=@ppubl or @ppubl is null or @ppubl='' )
                     
                                    --insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
                                    set @v_amt91120 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt91120,0);
                                    set @debit_amt_91120 =isnull(@debit_amt_91120,0)+isnull(@v_amt91120,0)
                                end  
                                else if @v_days between isnull(@ptill_days4,0)+1 and @ptill_days5 begin
                                    select @v_amt121180=sum(amount) from cir_outmast 
                                    where comp_code=@pcomp_code and unit_code=@punit_code and
                                          agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
                                          billno=@v_bill_billno and billdt=@v_bill_billdt and 
                                          recptdt<=@vasondt and amount<0
                                           and (isnull(publ,@ppubl)=@ppubl or @ppubl is null or @ppubl='' )
                     
                                    --insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
                                    set @v_amt121180 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt121180,0);
                                    set @debit_amt_121180 =isnull(@debit_amt_121180,0)+isnull(@v_amt121180,0)
                                end        
                                else
                                begin
                                    select @v_amt181=sum(amount) from cir_outmast 
                                    where comp_code=@pcomp_code and unit_code=@punit_code and
                                          agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
                                          billno=@v_bill_billno and billdt=@v_bill_billdt and 
                                          recptdt<=@vasondt and amount<0
                                           and (isnull(publ,@ppubl)=@ppubl or @ppubl is null or @ppubl='' )
                     
                                    --insert into debug_ageing (BILLNO, BILLDATE, DAYS,AMOUNT2) values( v_bill.billno,v_bill.billdt,v_days, isnull(v_bill.bill_amt,0));
                                    set @v_amt181 =isnull(@v_bill_bill_amt,0)+isnull(@v_amt181,0);
                                    set @debit_amt_181 =isnull(@debit_amt_181,0)+isnull(@v_amt181,0)
                                end
                                
                                
         select @v_pub_type_name=(select max(pubname) from pub_type_mast c where  pubtypecode  
                    in(select pro_type from cir_publ_mast b where  b.publ=a.publ and a.comp_code=b.comp_code
                    and pubtypecode=pro_type and c.comp_code=b.comp_code  )
                    and pubtypecode LIKE 'N%'
                    )
                                from cir_outmast a
                                    where comp_code=@pcomp_code and unit_code=@punit_code and
                                          agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
                                          billno=@v_bill_billno and billdt=@v_bill_billdt and 
                                          recptdt<=@vasondt and amount<0  and                                         
                                          (isnull(publ,@ppubl)=@ppubl or @ppubl is null or @ppubl='' )
                                
                                

                            fetch NEXT FROM c_bill INTO @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt
                            end
                    close c_bill        
                deallocate c_bill
        
        select @v_pending_rcpt_amt=sum(amount) from cir_outmast 
        where comp_code=@pcomp_code and unit_code=@punit_code and
          agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
          (billno is null or isnull(billdt,@vtodt)>@vasondt) and 
          recptdt<=@vasondt 
           and (isnull(publ,@ppubl)=@ppubl or @ppubl is null or @ppubl='' )
                     
          /*and 
          doctyp+recptno+cast(recptdt as varchar) not in 
          (select distinct doctyp+recptno+cast(recptdt as varchar) from cir_outmast
           where comp_code=@pcomp_code and unit_code=@punit_code and
                 agcd=@rec_agency_agcd and dpcd=@rec_agency_dpcd and
                 recptdt<=@vtodt and isnull(amount,0)<0 and billno IS NULL)*/
    
    PRINT '@v_pending_rcpt_amt'
    PRINT  @v_pending_rcpt_amt
    
        set @v_amt=isnull(@debit_amt_030,0)+isnull(@debit_amt_3160,0)+isnull(@debit_amt_6190,0)+isnull(@debit_amt_91120,0)+isnull(@debit_amt_121180,0)+isnull(@debit_amt_181,0)

        if @v_amt=0 begin
            set @debit_amt_030    = 0
            set @debit_amt_3160   = 0
            set @debit_amt_6190   = 0
            set @debit_amt_91120  = 0
            set @debit_amt_121180 = 0
            set @debit_amt_181    = 0
            set @rcpt_pending_amt = 0
        end
        else
        begin
            set @rcpt_pending_amt=isnull(@v_pending_rcpt_amount,0)
            set @bill_pending_amt=isnull(@v_amt,0)
        end
        print('zzz')
        insert into #cir_temp_ageing (comp_code,unit_code,agcd,dpcd,ag_name,
                                      city_name,pending_amt,slab_1,slab_2,slab_3,
                                      slab_4,slab_5,slab_6,rect_pending,on_acamt,
                                      sessionid,PUBL_TYPE_NAME)
                              values (@rec_agency_comp_code,@punit_code,@rec_agency_agcd, @rec_agency_dpcd, @rec_agency_agency_name,
                                      @rec_agency_city_name,isnull(@bill_pending_amt,0),isnull(@debit_amt_030,0),isnull(@debit_amt_3160,0), isnull(@debit_amt_6190,0), 
                                      isnull(@debit_amt_121180,0), isnull(@debit_amt_181,0),0,isnull(@rcpt_pending_amt,0),
                                      isnull(@v_pending_rcpt_amt,0),@@spid,@v_pub_type_name);
        print('xxx')
        fetch NEXT FROM cur_agency INTO @rec_agency_comp_code,@rec_agency_agcd,@rec_agency_dpcd,@rec_agency_agency_name ,@rec_agency_city_code ,@rec_agency_city_name ,@rec_agency_credit_days ,@rec_agency_branch_name
            set @debit_amt_030    = 0
            set @debit_amt_3160   = 0
            set @debit_amt_6190   = 0
            set @debit_amt_91120  = 0
            set @debit_amt_121180 = 0
            set @debit_amt_181    = 0
            set @rcpt_pending_amt = 0
            set @bill_pending_amt = 0
        end
        
close cur_agency;
--SELECT 'cursor has ' + CAST(@@CURSOR_ROWS AS VARCHAR) + ' rows'
deallocate cur_agency

select comp_code,unit_code,agcd,dpcd,ag_name,city_name,PUBL_TYPE_NAME,pending_amt,slab_1,slab_2,slab_3,slab_4,slab_5,
slab_6,rect_pending,on_acamt from #cir_temp_ageing 
/*where (PENDING_AMT>0 or SLAB_1>0 or SLAB_2>0 or SLAB_3>0 or SLAB_4>0 or SLAB_5>0 or ABS(RECT_PENDING)>0  )  
 and sessionid=@@SPID  */
 order by ag_name;
drop table #cir_temp_ageing
/***********CREDIT RATING**************/
/*************target vs collection*************/
alter PROCEDURE [dbo].[cir_target_vs_collection]
	@pcompcode                                VARCHAR(20) ,
	@punitcode                                VARCHAR(20) ,	
	@pbranchcode                              VARCHAR(20) ,	
	@pregioncode                              VARCHAR(20) ,	
	@pzonecode                                VARCHAR(20) ,	
	@pagcd                                    VARCHAR(20) ,	
	@pdpcd                                    VARCHAR(20) ,	
	@pagtype								  VARCHAR(20) ,	
	@pagclass								  VARCHAR(20) ,	
	@pcitycode								  VARCHAR(20) ,	
	@pstatecode								  VARCHAR(20) ,	
	@pdistcode								  VARCHAR(20) ,	
	@pasondate                                varchar(20) ,	
	@pdateformat                              VARCHAR(20) ,
	@pbasedon								  VARCHAR(1),--A for agency, Z for zone, R for region,B branch
	@preptype								  VARCHAR(1),
	@puserid                                  VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) ,
	@pextra3                                  VARCHAR(4000) ,
	@pextra4                                  VARCHAR(4000) ,
	@pextra5                                  VARCHAR(4000) ,
	@pextra6                                  VARCHAR(4000) ,
	@pextra7                                  VARCHAR(4000) ,
	@pextra8                                  VARCHAR(4000) ,
	@pextra9                                  VARCHAR(4000) ,
	@pextra10                                 VARCHAR(4000) 

AS 

create table #cir_target_collection_temp
(
comp_code varchar(20),
unit_code varchar(20),
agcd varchar(20),
dpcd varchar(20),
agname varchar(500),
city_code varchar(20),
dist_code varchar(20),
state_code varchar(20),
region_code varchar(20),
zone_code varchar(20),
branch_code varchar(20),
city_name varchar(200),
dist_name varchar(200),
state_name varchar(200),
region_name varchar(200),
zone_name varchar(200),
ageing_type varchar(1),
daily_coll numeric(20,2),
weekly_coll numeric(20,2),
monthly_coll numeric(20,2),
cur_dep  numeric(20,2),
tot_dep  numeric(20,2),
tot_bg  numeric(20,2),
req_dep  numeric(20,2),
tot_bg_dep numeric(20,2),
dep_index  numeric(20,3)
)
declare @vdaily as numeric(20,2)
declare @vweekly as numeric(20,2)
declare @vmonthly as numeric(20,2)
declare @vcurdeposit as numeric(20,2)
declare @vtotdeposit as numeric(20,2)
declare @vtotbg as numeric(20,2)
declare @vreqdeposit as numeric(20,2)
declare @vtotdep_bg as numeric(20,2)
declare @dep_index as numeric(20,3)

--- variables for cursor c1 ---
declare @v1_comp_code as varchar(20)
declare @v1_unit_code as varchar(20)
declare @v1_agcd as varchar(20)
declare @v1_dpcd as varchar(20)
declare @v1_agname as varchar(500)
declare @v1_citycode as varchar(20)
declare @v1_distcode as varchar(20)
declare @v1_statecode as varchar(20)
declare @v1_regioncode as varchar(20)
declare @v1_zonecode as varchar(20)
declare @v1_branchcode as varchar(20)
declare @v1_cityname as varchar(200)
declare @v1_distname as varchar(200)
declare @v1_statename as varchar(200)
declare @v1_regionname as varchar(200)
declare @v1_zonename as varchar(200)
declare @v1_ageing as varchar(200)

declare @v_date as datetime
set @v_date=dbo.convert_user_date('/',@pasondate,@pdateformat)

declare @vfirstdt as datetime
declare @vlastdt as datetime

set @vfirstdt=dbo.GetFirstDayOfMonth(@v_date)
set @vlastdt=dbo.GetLastDayOfMonth(@v_date)

print('*')
print(@vfirstdt)
print(@vlastdt)

declare c1 cursor for
	select comp_code,unit,agcd,dpcd,ag_name,city_code,dist_code,state_code 
	,dbo.cir_get_region_by_city(comp_code,city_code,'C') as regioncode
	,dbo.cir_get_zone_by_city(comp_code,city_code,'C') as zonecode
	,branch_code
	,dbo.cir_get_name_cir_city(comp_code,city_code,'1','dd/mm/yyyy','','') as city
	,dbo.cir_get_name_cir_district(comp_code,city_code,'1','dd/mm/yyyy','','') as dist
	,dbo.cir_get_state(comp_code,country_code,state_code) as statename
	,dbo.cir_get_region_by_city(comp_code,city_code,'N') as region
	,dbo.cir_get_zone_by_city(comp_code,city_code,'N') as zone
	,ageing_type
	from cir_agmast x where comp_code=@pcompcode and unit=@punitcode
	and (branch_code=isnull(@pbranchcode,branch_code) or @pbranchcode='')
	and (dbo.cir_get_region_by_city(comp_code,city_code,'C')=@pregioncode or @pregioncode='' or @pregioncode is null)
	and (dbo.cir_get_zone_by_city(comp_code,city_code,'C')=@pzonecode or @pzonecode='' or @pzonecode is null)
	and (agcd=@pagcd or @pagcd is null or @pagcd='')
	and (dpcd=@pdpcd or @pdpcd is null or @pdpcd='')	
	and (ag_type=@pagtype or @pagtype is null or @pagtype='')
	and (ag_class=@pagclass or @pagclass is null or @pagclass='')	
	and (city_code=@pcitycode or @pcitycode is null or @pcitycode='')	
	and (dist_code=@pstatecode or @pstatecode is null or @pstatecode='')
	and (state_code=@pdistcode or @pdistcode is null or @pdistcode='')

	open c1
		fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_agcd,@v1_dpcd,@v1_agname,@v1_citycode,@v1_distcode
		,@v1_statecode,@v1_regioncode,@v1_zonecode,@v1_branchcode,@v1_cityname,@v1_distname,@v1_statename
		,@v1_regionname,@v1_zonename,@v1_ageing
		WHILE (@@FETCH_STATUS = 0) 
		begin
		
			set @vcurdeposit=0
			set @vmonthly=0
			set @vweekly=0
			set @vdaily=0
			
			select @vreqdeposit=req_sec,@vtotdeposit=dep_ondt,@vtotbg=bg_ondt,@vtotdep_bg=(isnull(dep_ondt,0)+ isnull(bg_ondt,0) )  
			from  dbo.cir_security_target_vs_collection (@v1_comp_code,@v1_unit_code,'','','',@v1_agcd,@v1_dpcd,@pasondate,@pdateformat
			,'','','','','S','')
			
			select @vcurdeposit=SUM(isnull(abs(amount),0)) from CIR_RCPHDR where COMP_CODE=@v1_comp_code and UNIT_CODE=@v1_unit_code
			and AGCD=@v1_agcd and DPCD=@v1_dpcd
			and RECPTDT between @vfirstdt and @vlastdt and ACHD='SC' 
			print('@vcurdeposit')
			print(@vcurdeposit)
			if @v1_ageing='M'
			begin
				set @vmonthly=ISNULL(@vcurdeposit,0)
			end
			if @v1_ageing='W'
			begin
				set @vweekly=ISNULL(@vcurdeposit,0)
			end
			if @v1_ageing='D'
			begin
				set @vdaily=ISNULL(@vcurdeposit,0)
			end
			if @vreqdeposit is null or @vreqdeposit =0
			begin
				set @dep_index= ((@vtotdep_bg/1)*100)
			end
			else
			begin
				set @dep_index= ((@vtotdep_bg/@vreqdeposit)*100)
			end
			
			
			
			insert into #cir_target_collection_temp(comp_code,unit_code,agcd,dpcd,agname,city_code,dist_code,state_code,
						region_code,zone_code,branch_code,city_name,dist_name,state_name,region_name,zone_name,ageing_type,
						daily_coll,weekly_coll,monthly_coll,cur_dep,tot_dep,tot_bg,req_dep,tot_bg_dep,dep_index)
				values  (@v1_comp_code,@v1_unit_code,@v1_agcd,@v1_dpcd,@v1_agname,@v1_citycode,@v1_distcode,@v1_statecode,
			@v1_regioncode,@v1_zonecode,@v1_branchcode,@v1_cityname,@v1_distname,@v1_statename,@v1_regionname,@v1_zonename,@v1_ageing,
			@vdaily,@vweekly,@vmonthly,@vcurdeposit,@vtotdeposit,@vtotbg,@vreqdeposit,@vtotdep_bg,@dep_index )		

		fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_agcd,@v1_dpcd,@v1_agname,@v1_citycode,@v1_distcode
		,@v1_statecode,@v1_regioncode,@v1_zonecode,@v1_branchcode,@v1_cityname,@v1_distname,@v1_statename
		,@v1_regionname,@v1_zonename,@v1_ageing
		end
	close c1		
	deallocate c1

	if @pbasedon='A'
	begin
		select region_name,dbo.cir_get_branch (comp_code, branch_code) as branchname,agname
		,case ageing_type 
		when 'D' then SUM(isnull(daily_coll,0)) end daily
		,case ageing_type 
		when 'W' then SUM(isnull(weekly_coll,0)) end weekly
		,case ageing_type 
		when 'M' then SUM(isnull(monthly_coll,0)) end Monthly
		,SUM(isnull(cur_dep,0)) as cur_dep
		,SUM(isnull(req_dep,0)) as req_dep
		,SUM(isnull(tot_dep,0)) as tot_dep
		,SUM(isnull(tot_bg,0)) as tot_bg
		,SUM(isnull(tot_bg_dep,0)) as tot_bg_dep 
		,SUM(isnull(dep_index,0)) as deposit_index
		from #cir_target_collection_temp group by comp_code,region_name,branch_code,agname,ageing_type
	end
	else if @pbasedon='B'
	begin
		select region_name,dbo.cir_get_branch (comp_code, branch_code) as branchname,'' agname
		,case ageing_type 
		when 'D' then SUM(isnull(daily_coll,0)) end daily
		,case ageing_type 
		when 'W' then SUM(isnull(weekly_coll,0)) end weekly
		,case ageing_type 
		when 'M' then SUM(isnull(monthly_coll,0)) end Monthly
		,SUM(isnull(cur_dep,0)) as cur_dep
		,SUM(isnull(req_dep,0)) as req_dep
		,SUM(isnull(tot_dep,0)) as tot_dep
		,SUM(isnull(tot_bg,0)) as tot_bg
		,SUM(isnull(tot_bg_dep,0)) as tot_bg_dep 
		,SUM(isnull(dep_index,0)) as deposit_index
		from #cir_target_collection_temp group by comp_code,region_name,branch_code,ageing_type
	end
	else --if @pbasedon='R'
	begin
		select region_name,'' branchname,'' agname
		,case ageing_type 
		when 'D' then SUM(isnull(daily_coll,0)) end daily
		,case ageing_type 
		when 'W' then SUM(isnull(weekly_coll,0)) end weekly
		,case ageing_type 
		when 'M' then SUM(isnull(monthly_coll,0)) end Monthly
		,SUM(isnull(cur_dep,0)) as cur_dep
		,SUM(isnull(req_dep,0)) as req_dep
		,SUM(isnull(tot_dep,0)) as tot_dep
		,SUM(isnull(tot_bg,0)) as tot_bg
		,SUM(isnull(tot_bg_dep,0)) as tot_bg_dep 
		,SUM(isnull(dep_index,0)) as deposit_index
		from #cir_target_collection_temp group by region_name,ageing_type
	end
alter function [dbo].[cir_security_target_vs_collection]   
( 
	@pcomp_code                         VARCHAR(20) ,
	@punit_code                         VARCHAR(200) ,
	@pbranch_code                       VARCHAR(200) ,
	@ppubl                              VARCHAR(200) ,
	@pedtn                              VARCHAR(200) ,
	@pagcd                              VARCHAR(200) ,-- mandatory
	@pdpcd                              VARCHAR(200) ,-- mandatory
	@pdate                              VARCHAR(20) ,
	@pdateformat                        VARCHAR(200) ,
	@ppubl_type                         VARCHAR(200) ,
	@pag_class                          VARCHAR(200) ,
	@pag_type                           VARCHAR(200) ,
	@proute                             VARCHAR(200) ,
	@pextra1                            VARCHAR(200) ,
	@pextra2                            VARCHAR(200)
)
RETURNS @cir_temp_security TABLE
(
  COMP_CODE      VARCHAR(8),
  UNIT_CODE      VARCHAR(8),
  bill_freq      VARCHAR(8),
  supply		 numeric(20),
  gross_amt      NUMERIC(20,2),
  comm_amt       NUMERIC(20,2),
  req_sec        NUMERIC(20,2),
  AGCD           VARCHAR(8),
  DPCD           VARCHAR(8),
  dep_ondt       NUMERIC(20,2),
  bg_ondt        NUMERIC(20,2)
)


As
begin

	declare @cir_security table
	(
		COMP_CODE VARCHAR(20),
		UNIT_CODE VARCHAR(20),
		PRO_TYPE VARCHAR(20),
		BILL_FREQ VARCHAR(20),
		publ varchar(20),
		edtn varchar(20),
		SUPPLY INT,
		RATE NUMERIC(20,2),
		GROSS_AMT NUMERIC(20,2),
		COMM_AMT NUMERIC(20,2),
		BILL_AMT NUMERIC(20,2),
		AGCD    VARCHAR(20),
		DPCD    VARCHAR(20)
	)
	declare @cir_security_dep table
	(
		COMP_CODE VARCHAR(20),
		UNIT_CODE VARCHAR(20),
		AGCD    VARCHAR(20),
		DPCD    VARCHAR(20),
		AMOUNT  numeric(20,2),
		BG_AMOUNT  numeric(20,2)
	)
declare @avg_sup as int
declare @v_date as datetime
set @v_date=dbo.convert_user_date('/',@pdate,@pdateformat)
declare @day as int
declare @v_day as varchar(3)
set @v_day=upper(DATENAME(dw,@v_date)	)


declare @tot_sup_pro as int
declare @v_rate_prod as numeric(20,2)
declare @v_gross_prod as numeric(20,2)
declare @v_net_prod as numeric(20,2)
declare @v_com_prod as numeric(20,2)
declare @v_com_type as varchar(1)

declare @v1_comp_code varchar(20)
declare @v1_unit varchar(20)
declare @v1_pro_type varchar(20)
declare @v1_publ as varchar(20)
declare @v1_edtn as varchar(20)
declare @v1_comm_code as varchar(20)
declare @v1_billfreq varchar(1)
declare @v_sec_ondt as numeric(20,2)
declare @v_bgamt as numeric(20,2)

	DECLARE c1 CURSOR  for 
		select b.comp_code,b.unit,p.pro_type,b.publ,b.edtn,b.comm_code ,isnull(a.ageing_type,'F') as BILL_CYCLE 
		,a.AGCD,a.DPCD
		from cir_supply b,cir_agmast a,cir_publ_mast p 
		where a.comp_code=b.comp_code and a.unit=b.unit
		and a.agcd=b.agcd and a.dpcd=b.dpcd
		and a.comp_code=p.comp_code and b.comp_code=p.comp_code 
		and b.publ=p.publ and b.comp_code=@pcomp_code
		and (b.unit=@punit_code or @punit_code is null or @punit_code ='')
		and (b.publ=@ppubl or @ppubl is null or @ppubl='')
		and (b.edtn=@pedtn or @pedtn is null or @pedtn='')
		and (b.agcd=@pagcd or @pagcd is null or @pagcd='' )
		and (b.dpcd=@pdpcd or @pdpcd is null or @pdpcd='' )
		and (p.pro_type=@ppubl_type or @ppubl_type is null or @ppubl_type='')
		and (a.branch_code =@pbranch_code or @pbranch_code is null or @pbranch_code='')
		and (a.ag_type=@pag_type or @pag_type is null or @pag_type='')
		and (a.ag_class=@pag_class or @pag_class is null or @pag_class='')
		and (b.route_code=@proute or @proute is null or @proute='' )
		group by b.comp_code,b.unit,p.pro_type,b.publ,b.edtn,b.comm_code,a.ageing_type ,a.AGCD,a.DPCD
		order by p.pro_type,a.AGCD,a.DPCD

DECLARE c2 CURSOR  for 
		select distinct a.comp_code,a.unit,a.AGCD,a.DPCD
		from cir_agmast a
		where a.comp_code=@pcomp_code
		and (a.unit=@punit_code or @punit_code is null or @punit_code ='')
		and (a.agcd=@pagcd or @pagcd is null or @pagcd='' )
		and (a.dpcd=@pdpcd or @pdpcd is null or @pdpcd='' )
		and (a.branch_code =@pbranch_code or @pbranch_code is null or @pbranch_code='')
		and (a.ag_type=@pag_type or @pag_type is null or @pag_type='')
		and (a.ag_class=@pag_class or @pag_class is null or @pag_class='')
		order by a.AGCD,a.DPCD

	 open c1
	 fetch next from c1 into @v1_comp_code,@v1_unit,@v1_pro_type,@v1_publ,@v1_edtn,@v1_comm_code,@v1_billfreq,@pagcd,@pdpcd
	 while(@@fetch_status=0) begin
		 if(@v1_billfreq='M') BEGIN
			set @day=60
		 end 
		 else  if(@v1_billfreq='W') BEGIN
			set @day=14
		 end 
		 else  BEGIN/*daily*/
			set @day=7
		 end
 
		if @v1_pro_type='M'
		begin
			set @day=90
		end

		select @avg_sup=SUM(isnull(sup_copy,0)) from cir_dbksup  b where b.comp_code=@v1_comp_code 
		and b.unit_code=@v1_unit 
		and (b.publ=@v1_publ ) and EDTN=@v1_edtn
		and (b.agcd=@pagcd or @pagcd is null or @pagcd='' )
		and (b.dpcd=@pdpcd or @pdpcd is null or @pdpcd='' )
		and b.SUPDATE=DATEADD(dd,-1,@v_date)

		 if @avg_sup is null or @avg_sup<1
		 begin		 
			
			select @avg_sup =  case @v_day 
			when 'SUN' then SUM(isnull(base_supply,0)+ isnull(SUPPLY_SUN,0) )
			when 'MON' then SUM(isnull(base_supply,0)+ isnull(SUPPLY_MON,0) )
			when 'TUE' then SUM(isnull(base_supply,0)+ isnull(SUPPLY_TUE,0) )
			when 'WED' then SUM(isnull(base_supply,0)+ isnull(SUPPLY_WED,0) )
			when 'THU' then SUM(isnull(base_supply,0)+ isnull(SUPPLY_THU,0) )
			when 'FRI' then SUM(isnull(base_supply,0)+ isnull(SUPPLY_FRI,0) )
			when 'SAT' then SUM(isnull(base_supply,0)+ isnull(SUPPLY_SAT,0) ) end
			from cir_supply b  where	b.comp_code=@v1_comp_code
			and b.unit=@v1_unit and (b.publ=@v1_publ) and EDTN=@v1_edtn
			and (b.agcd=@pagcd or @pagcd is null or @pagcd='' )
			and (b.dpcd=@pdpcd or @pdpcd is null or @pdpcd='' )
			
		end

		set @tot_sup_pro=@avg_sup*@day
		
		select @v_rate_prod= case @v_day
		when 'SUN' then SUM(isnull(SUN_RATE,0))
		when 'MON' then SUM(isnull(MON_RATE,0))
		when 'TUE' then SUM(isnull(TUE_RATE,0))
		when 'WED' then SUM(isnull(WED_RATE,0))
		when 'THU' then SUM(isnull(THU_RATE,0))
		when 'FRI' then SUM(isnull(FRI_RATE,0))
		when 'SAT' then SUM(isnull(SAT_RATE,0)) end		
		from CIR_RATE_MAST where COMP_CODE=@v1_comp_code and UNIT=@v1_unit and PUBL=@v1_publ and EDTN=@v1_edtn

		select @v_com_prod=case @v_day
		when 'SUN' then SUM(isnull(SUN_COMM_RATE,0))
		when 'MON' then SUM(isnull(MON_COMM_RATE,0))
		when 'TUE' then SUM(isnull(TUE_COMM_RATE,0))
		when 'WED' then SUM(isnull(WED_COMM_RATE,0))
		when 'THU' then SUM(isnull(THU_COMM_RATE,0))
		when 'FRI' then SUM(isnull(FRI_COMM_RATE,0))
		when 'SAT' then SUM(isnull(SAT_COMM_RATE,0)) end		
		,@v_com_type=COMM_CATG_TYPE from CIR_COMM_MAST 
		where COMP_CODE=@v1_comp_code and UNIT_CODE=@v1_unit and PUBL=@v1_publ and EDTN=@v1_edtn and COMM_CATG_CODE=@v1_comm_code
		group by COMM_CATG_TYPE
		
		set @v_gross_prod = isnull(@tot_sup_pro,0)*isnull(@v_rate_prod,0)
		set @v_com_prod=isnull(@v_gross_prod,0)*ISNULL(@v_com_prod,0)/100
		
		insert into @cir_security (COMP_CODE,UNIT_CODE,PRO_TYPE,BILL_FREQ,PUBL,EDTN,SUPPLY,RATE ,GROSS_AMT,COMM_AMT,BILL_AMT,AGCD,DPCD)
		values (@v1_comp_code,@v1_unit,@v1_pro_type,@v1_billfreq,@v1_publ,@v1_edtn,@tot_sup_pro,@v_rate_prod,@v_gross_prod,@v_com_prod,ISNULL(@v_gross_prod,0)-ISNULL(@v_com_prod,0),@pagcd,@pdpcd )
		
	 fetch next from c1 into @v1_comp_code,@v1_unit,@v1_pro_type,@v1_publ,@v1_edtn,@v1_comm_code,@v1_billfreq,@pagcd,@pdpcd
	 end
	 close c1
	 deallocate c1


	
	open c2
		 fetch next from c2 into @v1_comp_code,@v1_unit,@pagcd,@pdpcd
		 while(@@fetch_status=0) begin
		 
		 select @v_sec_ondt= SUM(abs(amount)) from CIR_RCPHDR where COMP_CODE =@pcomp_code 
		 and (UNIT_CODE=@punit_code or @punit_code is null or @punit_code ='')
		 and AGCD=@pagcd and DPCD=@pdpcd and ACHD='SC'
		 
		 select @v_bgamt=SUM(abs(bg_amt))  from CIR_BANK_GUARANTEE where COMP_CODE =@pcomp_code 
		 and (UNIT_CODE=@punit_code or @punit_code is null or @punit_code ='')
		 and AGCD=@pagcd and DPCD=@pdpcd 
		 
		 
		 insert into @cir_security_dep (COMP_CODE,UNIT_CODE,AGCD,DPCD,AMOUNT,BG_AMOUNT)
		 values(@v1_comp_code,@v1_unit,@pagcd,@pdpcd,@v_sec_ondt,@v_bgamt)
		 
	fetch next from c2 into @v1_comp_code,@v1_unit,@pagcd,@pdpcd
	end
 close c2
 deallocate c2

declare @v_sec_fund as numeric(14,2)
declare @v_sec_reqd as numeric(14,2)

insert into @cir_temp_security (COMP_CODE, UNIT_CODE,bill_freq, supply, gross_amt,comm_amt ,req_sec,
								AGCD     ,DPCD     ,dep_ondt ,bg_ondt  )
	 select t.COMP_CODE,t.UNIT_CODE
	 ,t.BILL_FREQ ,SUM(isnull(t.SUPPLY,0)) as SUPPLY
	 ,SUM(isnull(t.GROSS_AMT,0)) GROSS_AMT,SUM(isnull(t.COMM_AMT,0)) COMM_AMT,SUM(isnull(t.BILL_AMT,0)) REQ_SEC ,t.AGCD,t.DPCD
	 ,isnull(abs(y.amount),0) as DEP_ONDT
	 ,isnull(abs(BG_AMOUNT),0) as BG_ONDT
	 --,dbo.cir_get_agency(t.comp_code,t.unit_code,t.agcd,t.DPCD) as AGENCY	
	 from @cir_security t,@cir_security_dep y where t.COMP_CODE=y.COMP_CODE 
	 and t.UNIT_CODE=y.UNIT_CODE and t.AGCD=y.AGCD and t.DPCD=y.DPCD	 
	 group by t.COMP_CODE,t.UNIT_CODE,t.BILL_FREQ,t.AGCD,t.DPCD,y.amount,BG_AMOUNT



RETURN

end

ALTER FUNCTION  [dbo].[cir_get_zone_by_city](@pcomp_code  varchar(100),@pcity_code  varchar(100),@flag varchar(1)) RETURNs char(400) 
AS
       Begin

       DECLARE @vzone VARCHAR(400)
       
       if @flag='C' begin
                       select @vzone= zone_code from CIR_CITY_MAST where city_code=@pcity_code
                      -- and comp_code=@pcomp_code
       end
       else
       begin
                       select @vzone= z.zone_desc from cir_zone_mast z where z.zone_code =
                       (select c.zone_code from CIR_CITY_MAST c where c.city_code=@pcity_code and c.comp_code=z.comp_code)
                      -- and comp_code=@pcomp_code
       end
       

       
 return isnull(@vzone,'')
END
                                            
ALTER FUNCTION  [dbo].[cir_get_region_by_city](@pcomp_code  varchar(100),@pcity_code  varchar(100),@flag varchar(1)) RETURNs char(400) 
AS
	Begin

        DECLARE @vregion VARCHAR(400)
        
        if @flag='C' begin
			select @vregion= region_code from CIR_CITY_MAST where city_code=@pcity_code
			--and comp_code=@pcomp_code
        end
        else
        begin
			select @vregion= z.reg_desc from cir_region_mast z where z.reg_code =
			(select c.region_code from CIR_CITY_MAST c where c.city_code=@pcity_code and c.comp_code=z.comp_code)
			--and comp_code=@pcomp_code
        end
        

	
  return isnull(@vregion,'')
END
/*************target vs collection*************/



////////////////////////////////////add by Deepika 20/09/2012 sent by Gaurav Sir/////////////////////////////


ALTER PROCEDURE [dbo].[cir_doc_bind_cir_doc_bind_p]
@pcompcode                                VARCHAR(20) ,
@pflag                                    VARCHAR(20) ,
@pdateformat                              VARCHAR(20) ,
@pextra1                                  VARCHAR(4000) ,
@pextra2                                  VARCHAR(4000)
AS

if @pextra2='B'
begin
SELECT
comp_code  "Comp_code",
userid  "userid",
doc_type  "doc_type",
doc_name  "doc_Name",
dsign  "Dsign",
creation_datetime  "Creation_Datetime",
flagforreceiptentry  "flagforreceiptentry"
FROM  cir_docmst
WHERE Comp_code  = @pcompcode
AND (flagforreceiptentry  = @pflag or @pflag is null or @pflag='')
AND (UPPER(DOC_TYPE) in ('RCR','DN') )
end
else
begin
SELECT
comp_code  "Comp_code",
userid  "userid",
doc_type  "doc_type",
doc_name  "doc_Name",
dsign  "Dsign",
creation_datetime  "Creation_Datetime",
flagforreceiptentry  "flagforreceiptentry"
FROM  cir_docmst
WHERE Comp_code  = @pcompcode
AND (flagforreceiptentry  = @pflag or @pflag is null or @pflag='')
AND ((UPPER(doc_Name)  like UPPER(@pextra1) + '%') OR (@pextra1  is null))
end 


////////////////////////////////////////////next procedure

ALTER procedure [dbo].[cir_payreason_for_receipt]
    @pcompcode       as varchar(200),
    @punitcode       as varchar(200),
    @pdoctype        as varchar(200),
    @pagcd           as varchar(200),
    @pdpcd           as varchar(200),
    @pdateformat     as varchar(200),
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
as
begin

    if(@pdoctype !='RCR') Begin
if (@pextra2!='B')
begin   
select distinct reason_code as "PAY_MODE_CODE",reason_name as "PAYMENT_MODE_NAME",'N' as "MODE_TYPE" ,chq_return_flag as "CHQ_RETURN_FLAG",
no_of_times as "NO_OF_TIMES",valid_days as "VALID_DAYS",DR_CDP,CR_CDP
from cir_reason_mst where comp_code = @pcompcode and ((upper(reason_name) like upper(@pextra1)+'%') or (@pextra1 is null) or (@pextra1='')) and
((doc_type=@pdoctype) or doc_type is null or doc_type='')
order by payment_mode_name
        end
        else
        begin   
select distinct reason_code as "PAY_MODE_CODE",reason_name as "PAYMENT_MODE_NAME",'N' as "MODE_TYPE" ,chq_return_flag as "CHQ_RETURN_FLAG",
no_of_times as "NO_OF_TIMES",valid_days as "VALID_DAYS",DR_CDP,CR_CDP
from cir_reason_mst where comp_code = @pcompcode and ((upper(REASON_CODE) like upper('CH0')+'%') or ('CH0' is null) or ('CH0'='')) and
((doc_type=@pdoctype) or doc_type is null or doc_type='')
order by payment_mode_name
        end
    End
    if(@pdoctype ='RCR') Begin
        select distinct x.PAY_MODE_CODE as "PAY_MODE_CODE" ,x."PAYMENT_MODE_NAME" as "PAYMENT_MODE_NAME",x."MODE_TYPE" as "MODE_TYPE" ,x."CHQ_RETURN_FLAG" as "CHQ_RETURN_FLAG",
        x."NO_OF_TIMES" as "NO_OF_TIMES",x."VALID_DAYS" as "VALID_DAYS" from
        (select distinct p."Pay_Mode_Code" as "PAY_MODE_CODE" ,p."Payment_Mode_Name" as "PAYMENT_MODE_NAME",p.payment_mode_type as "MODE_TYPE" ,'N' as "CHQ_RETURN_FLAG",
        0 as "NO_OF_TIMES",0 as "VALID_DAYS"
        from payment_mode_mast p,cir_agency_paymode a
        where a.comp_code=@pcompcode and a.unit_code=@punitcode and a.agcd=@pagcd and a.dpcd=@pdpcd and
        a.paymode=p."Pay_Mode_Code" and ((upper(p."Payment_Mode_Name") like upper(@pextra1)+'%') or (@pextra1 is null) or (@pextra1='')) and
        isnull(a.paymode_active,'N')='Y'
        union
        select distinct p."Pay_Mode_Code" as "PAY_MODE_CODE" ,p."Payment_Mode_Name" as "PAYMENT_MODE_NAME",p.payment_mode_type as "MODE_TYPE" ,'N' as "CHQ_RETURN_FLAG",
        0 as "NO_OF_TIMES",0 as "VALID_DAYS"
        from payment_mode_mast p
        where ((upper(p."Payment_Mode_Name") like upper(@pextra1)+'%') or (@pextra1 is null) or (@pextra1='')) and p."Pay_Mode_Code"='CA0') x
        order by payment_mode_name
    End
   
    select getdate() as "CUR_DATE"
   
End

/////////////////////////////////////////////////next

ALTER PROCEDURE [dbo].[cir_receipt_ref_receipt_P]
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @pdoctype        as varchar(20),
    @precptno        as varchar(20),
    @precptdt        as datetime,
    @preasoncode     as varchar(20),
    @puserid         as varchar(20),
    @pdateformat     as varchar(20),
    @pextra1         as varchar(20),
    @pextra2         as varchar(20)
    as
begin

declare @vdate as datetime
--set @vdate=dbo.convert_user_date('/',@precptdt,@pdateformat)
   
    select h.comp_code COMP_CODE,h.unit_code UNIT_CODE,h.agcd AGCD,h.dpcd DPCD,m.ag_name AG_NAME,h.doctype DOCTYPE,h.recptno RECPTNO,h.recptdt RECPTDT,
    abs(h.amount) AS AMOUNT,h.chno CHNO,h.chdt CHDT,h.chbank CHBANK,h.reason REASON,h.prov_rec_no PROV_REC_NO,
    h.prov_rec_dt PROV_REC_DT,h.received_from RECEIVED_FROM,h.achd AHCD,h.ccdp DEBIT_HEAD,
(select acc_name from fa_acc_mast where comp_code=h.comp_code and cdp=h.ccdp) as CREDIT_HEAD_NAME,
h.rcdp credit_head,(select acc_name from fa_acc_mast where comp_code=h.comp_code and cdp=h.rcdp) as DEBIT_HEAD_NAME
    from cir_rcphdr h,cir_agmast m
    where h.comp_code=m.comp_code and h.comp_code=@pcompcode and h.unit_code=m.unit and h.unit_code=@punitcode
    and h.agcd=m.agcd and h.dpcd=m.dpcd and h.chno is not null
    and h.doctype=@pdoctype
    and (
    (h.recptno=@precptno and h.recptdt=@precptdt ) or
    (h.CHNO=upper(@precptno) and CHBANK =UPPER(@pextra2) )
    )
   
End


//////////////////////////////////////////////////////end///////////////////////////////////////////////////////////////


//////////////////////////////////////////ADD BY DEEPIKA 21/09/2012 SENT BY LAXMAN SIR//////////////////////////////////////////////////////


                                  
ALTER procedure [dbo].[cir_area_break_down]
	@pcomp_code         as varchar(100),
	@punit_code         as varchar(100),
	@pbrancode          as varchar(100),
	@ppublcode          as varchar(100),
	@pmedtncode         as varchar(100),
	@pedtncode          as varchar(100),
	@pagtype            as varchar(100),
	@pzonecode          as varchar(100),
	@pregioncode        as varchar(100),
	@pstatecode         as varchar(100),
	@pdistcode          as varchar(100),
	@pfromdate          as varchar(100),
	@ptilldate          as varchar(100),
	@psup_copy          as NUMERIC,
	@psup_baseon        as varchar(100),--it is used for Gross(G)/Average(A)
	@pdateformat        as varchar(100),
	@puserid            as varchar(100),
	@pbreakon           as NUMERIC,--it is used for Grouping on Zone(1)/Region(2)/State(3)/Branch(4)/District(5)/Taluka(6)
	@pdatashow          as NUMERIC,--it is used for data show Agency(1)/City(2)
	@pextra1            as varchar(100),
	@pextra2            as varchar(100),
	@pextra3            as varchar(100),
	@pextra4            as varchar(100),
	@pextra5            as varchar(100)
As

declare @v_comp_code	as  varchar(800);
declare @v_unit			as  varchar(800);
declare @v_agcd			as  varchar(800);
declare @v_dpcd			as  varchar(800);
declare @v_agency_name	as  varchar(800);
declare @v_zone_name	as  varchar(800);
declare @v_region_name	as  varchar(800);
declare @v_state_name	as  varchar(800);
declare @v_branch_name	as  varchar(800);
declare @v_dist_name	as  varchar(800);
declare @v_taluka_name	as  varchar(800);
declare @v_city_name	as  varchar(800);
declare @v_sup_copy		as  varchar(800);

if @ppublcode='' begin
	set @ppublcode=null
end
if @pmedtncode='' begin
	set @pmedtncode=null
end
if @pedtncode='' begin
	set @pedtncode=null
end
CREATE TABLE #CIR_TEMP_BILL_COLLECTION
( COMP_CODE        VARCHAR(100),
  UNIT_CODE        VARCHAR(100),
  BILLNO           VARCHAR(200),
  BILLDT           DATETIME,
  PUBL_CODE        VARCHAR(100),
  AGCD             VARCHAR(100 ),
  DPCD             VARCHAR(100 ),
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
  AGNAME           VARCHAR(200 ),
  AGNAME_OTH_LANG  VARCHAR(250 ),
  CITY_CODE        VARCHAR(200 ),
  TALUKA_CODE      VARCHAR(200 ),
  DIST_CODE        VARCHAR(200 ),
  STATE_CODE       VARCHAR(200 ),
  REMARKS          VARCHAR(500 ),
  RET_COMM_AMT     NUMERIC(15,2),
  BILL_SEC_AMT     NUMERIC(15,2),
  SEC_OPBAL        NUMERIC(15,2))


declare @v_frdt    as  datetime;
declare @v_todt    as  datetime;

set @v_frdt   =@pfromdate
set @v_todt   =@ptilldate

declare cur_supply cursor for
    select a.comp_code comp_code,a.unit unit,a.agcd agcd,a.dpcd dpcd,a.ag_name agency_name,
 --d.zone_code zone_code,
dbo.cir_get_zone_name(a.comp_code,d.zone_code) zone_name,
    --d.region_code region,
dbo.cir_get_region_name(a.comp_code,d.region_code) region_name,
    --a.state_code state_code,
dbo.cir_get_state(a.comp_code,a.country_code,a.state_code) state_name,
    --a.dist_code dist_code,
       (select "Branch_Name" from branch_mst where "Branch_Code"=a.branch_code) branch_name,
dbo.cir_get_dist(a.comp_code,a.state_code,a.dist_code) dist_name,
   -- isnull(a.abc_citycode,a.city_code) city_code,
   dbo.cir_get_taluka(a.comp_code,a.tehsil_taluka) taluka_name,
d.city_name city_name,
sum(b.sup_copy) sup_copy

    from cir_agmast a,cir_dbksup b,cir_edtn_mast c,cir_city_mast d
    where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=d.comp_code and a.comp_code=@pcomp_code 
and a.unit=@punit_code and a.unit=b.unit_code 
and a.unit=c.unit_code and a.agcd=b.agcd and a.dpcd=b.dpcd 
and b.supdate>=@v_frdt and b.supdate<=@v_todt 
and b.publ=c.publ 
and b.publ=isnull(@ppublcode,b.publ) 
and b.edtn=c.edtn and  b.edtn=isnull(@pedtncode, b.edtn) 
and c.main_edtn=isnull(@pmedtncode, c.main_edtn) 
--and  isnull(a.abc_citycode,a.city_code)=d.city_code 
and  a.city_code=d.city_code 
and (d.zone_code=@pzonecode or @pzonecode is null OR  @pzonecode='') 
and (d.region_code=@pregioncode  or @pregioncode is null OR  @pregioncode='')
and (d.dist_code=@pdistcode  or @pdistcode is null or @pdistcode='')
and (d.state_code=@pstatecode  or @pstatecode is null or @pstatecode='')
and (a.branch_code=@pbrancode  or @pbrancode is null or @pbrancode='')
and (a.ag_type=@pagtype  or @pagtype is null or @pagtype='')
group by a.comp_code,a.unit,a.agcd,a.dpcd,a.ag_name,a.country_code,a.state_code,a.dist_code,isnull(a.abc_citycode,a.city_code),d.city_name,d.zone_code,d.region_code,a.tehsil_taluka,a.branch_code



begin
print('1')
open cur_supply
fetch next from  cur_supply INTO 
@v_comp_code,@v_unit,@v_agcd,@v_dpcd,@v_agency_name,@v_zone_name,@v_region_name,@v_state_name,
            @v_branch_name,@v_dist_name,@v_taluka_name,@v_city_name,@v_sup_copy


	WHILE (@@FETCH_STATUS = 0) BEGIN  
	PRINT('2')
        insert into #cir_temp_bill_collection(comp_code,unit_code,agcd,dpcd,agname, agname_oth_lang ,remarks ,state_code,
            billno,dist_code,taluka_code,city_code,publ_code,supply_copy,return_copy)
        values(@v_comp_code,@v_unit,@v_agcd,@v_dpcd,@v_agency_name,@v_zone_name,@v_region_name,@v_state_name,
            @v_branch_name,@v_dist_name,@v_taluka_name,@v_city_name,null,@v_sup_copy,0);

fetch next from  cur_supply INTO 
@v_comp_code,@v_unit,@v_agcd,@v_dpcd,@v_agency_name,@v_zone_name,@v_region_name,@v_state_name,
            @v_branch_name,@v_dist_name,@v_taluka_name,@v_city_name,@v_sup_copy


END
close cur_supply
deallocate cur_supply
print('12')

    if @pdatashow='1' begin --agency wise
        if @pbreakon='1' begin --zone wise

            select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname agname,
            a.agname_oth_lang zone_code,a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from #cir_temp_bill_collection a 
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.city_code
            order by comp_code,unit_code,zone_code,agname,city_name,agcd,dpcd;
            
            select x.comp_code comp_code,x.unit_code unit_code,
            x.zone_code zone_code,sum(x.gross_copy) gross_copy,
            sum(x.less_copy) as less_copy,sum(x.Above_copy) as Above_copy
            from
            (select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname agname,
            a.agname_oth_lang zone_code,a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from #cir_temp_bill_collection a 
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.city_code)x
            group by x.comp_code,x.unit_code,x.zone_code
            order by comp_code,unit_code,zone_code;
		end            
        else if @pbreakon='2' begin --region wise

            select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname agname,
            a.remarks region_name,a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from #cir_temp_bill_collection a 
            group by a.comp_code,a.unit_code,a.remarks,a.city_code,a.agcd,a.dpcd,a.agname
            order by comp_code,unit_code,region_name,agname,city_name;
            

            select x.comp_code comp_code,x.unit_code unit_code,
            x.region_name region_name,sum(x.gross_copy) gross_copy,
            sum(x.less_copy) as less_copy,sum(x.Above_copy) as Above_copy
            from
            (select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname agname,
            a.remarks region_name,a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from #cir_temp_bill_collection a 
            group by a.comp_code,a.unit_code,a.remarks,a.city_code,a.agcd,a.dpcd,a.agname)x
            group by x.comp_code ,x.unit_code, x.region_name
            order by comp_code,unit_code,region_name;
		end     
        else if @pbreakon='3' begin --state wise

            select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname agname,
            a.state_code state_name,
            a.city_code city_name,
            a.taluka_code taluka_name,sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from #cir_temp_bill_collection a 
            group by a.comp_code,a.unit_code,a.state_code,a.city_code,a.agcd,a.dpcd,a.agname,a.taluka_code
            order by comp_code,unit_code,state_name,agname,city_name;
            
            select x.comp_code comp_code,x.unit_code unit_code,
            x.state_name state_name,sum(x.gross_copy) gross_copy,
            sum(x.less_copy) as less_copy,sum(x.Above_copy) as Above_copy
            from
            (select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname agname,
            a.state_code state_name,
            a.city_code city_name,
            a.taluka_code taluka_name,sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from #cir_temp_bill_collection a 
            group by a.comp_code,a.unit_code,a.state_code,a.city_code,a.agcd,a.dpcd,a.agname)x
            group by x.comp_code ,x.unit_code,x.state_name
            order by comp_code,unit_code,state_name;
		end            
        else if @pbreakon='4' begin --Branch wise
            
            select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname agname,
            a.billno branch_name,
            a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from #cir_temp_bill_collection a 
            group by a.comp_code,a.unit_code,a.billno,a.city_code,a.agcd,a.dpcd,a.agname
            order by comp_code,unit_code,branch_name,agname,city_name;
            
            select x.comp_code comp_code,x.unit_code unit_code,
            x.branch_name branch_name,sum(x.gross_copy) gross_copy,
            sum(x.less_copy) as less_copy,sum(x.Above_copy) as Above_copy
            from
            (select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname agname,
            a.billno branch_name,
            a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from #cir_temp_bill_collection a 
            group by a.comp_code,a.unit_code,a.billno,a.city_code,a.agcd,a.dpcd,a.agname)x
            group by x.comp_code ,x.unit_code ,x.branch_name
            order by comp_code,unit_code,branch_name;
        end    
        else if @pbreakon='5' begin --District wise

            select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname agname,
            a.dist_code dist_name, 
            a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from #cir_temp_bill_collection a 
            group by a.comp_code,a.unit_code,a.dist_code,a.city_code,a.agcd,a.dpcd,a.agname
            order by comp_code,unit_code,dist_name,agname,city_name;
            
            select x.comp_code comp_code,x.unit_code unit_code,
            x.dist_name dist_name,sum(x.gross_copy) gross_copy,
            sum(x.less_copy) as less_copy,sum(x.Above_copy) as Above_copy
            from
            (select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname agname,
            a.dist_code dist_name, 
            a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from #cir_temp_bill_collection a 
            group by a.comp_code,a.unit_code,a.dist_code,a.city_code,a.agcd,a.dpcd,a.agname)x
            group by x.comp_code ,x.unit_code,x.dist_name
            order by comp_code,unit_code,dist_name;        
        end
        else if @pbreakon='6' begin --Taluka wise
            
            select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname agname,
            a.taluka_code taluka_name,
            a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from #cir_temp_bill_collection a 
            group by a.comp_code,a.unit_code,a.taluka_code,a.city_code,a.agcd,a.dpcd,a.agname
            order by comp_code,unit_code,taluka_name,agname,city_name;
            

            select x.comp_code comp_code,x.unit_code unit_code,
            x.taluka_name taluka_name,sum(x.gross_copy) gross_copy,
            sum(x.less_copy) as less_copy,sum(x.Above_copy) as Above_copy
            from
            (select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname agname,
            a.taluka_code taluka_name,
            a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from #cir_temp_bill_collection a 
            group by a.comp_code,a.unit_code,a.taluka_code,a.city_code,a.agcd,a.dpcd,a.agname)x
            group by x.comp_code,x.unit_code,x.taluka_name
            order by comp_code,unit_code,taluka_name;        
		end
	end       
    else begin--city wise
        if @pbreakon='1' begin --zone wise

            select a.comp_code comp_code,a.unit_code unit_code,
            a.agname_oth_lang zone_code,a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from #cir_temp_bill_collection a 
            group by a.comp_code,a.unit_code,a.agname_oth_lang,a.city_code
            order by comp_code,unit_code,zone_code,city_name;
            

            select x.comp_code comp_code,x.unit_code unit_code,
            x.zone_code zone_code,sum(x.gross_copy) gross_copy,
            sum(x.less_copy) as less_copy,sum(x.Above_copy) as Above_copy
            from
            (select a.comp_code comp_code,a.unit_code unit_code,
            a.agname_oth_lang zone_code,a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from #cir_temp_bill_collection a 
            group by a.comp_code,a.unit_code,a.agname_oth_lang,a.city_code)x
            group by x.comp_code,x.unit_code ,x.zone_code
            order by comp_code,unit_code,zone_code;
		end
        else if @pbreakon='2' begin --region wise

            select a.comp_code comp_code,a.unit_code unit_code,
            a.remarks region_name,a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from #cir_temp_bill_collection a 
            group by a.comp_code,a.unit_code,a.remarks,a.city_code
            order by comp_code,unit_code,region_name,city_name;
            
            select x.comp_code comp_code,x.unit_code unit_code,
            x.region_name region_name,sum(x.gross_copy) gross_copy,
            sum(x.less_copy) as less_copy,sum(x.Above_copy) as Above_copy
            from
            (select a.comp_code comp_code,a.unit_code unit_code,
            a.remarks region_name,a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from #cir_temp_bill_collection a 
            group by a.comp_code,a.unit_code,a.remarks,a.city_code)x
            group by x.comp_code ,x.unit_code ,x.region_name 
            order by comp_code,unit_code,region_name;
		end
        else if @pbreakon='3' begin --state wise

            select a.comp_code comp_code,a.unit_code unit_code,
            a.state_code state_name,
            a.city_code city_name,
            a.taluka_code taluka_name,sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from #cir_temp_bill_collection a 
            group by a.comp_code,a.unit_code,a.state_code,a.city_code,a.taluka_code
            order by comp_code,unit_code,state_name,city_name;
            
            select x.comp_code comp_code,x.unit_code unit_code,
            x.state_name state_name,sum(x.gross_copy) gross_copy,
            sum(x.less_copy) as less_copy,sum(x.Above_copy) as Above_copy
            from
            (select a.comp_code comp_code,a.unit_code unit_code,
            a.state_code state_name,
            a.city_code city_name,
            a.taluka_code taluka_name,sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from #cir_temp_bill_collection a 
            group by a.comp_code,a.unit_code,a.state_code,a.city_code,a.taluka_code)x
            group by x.comp_code ,x.unit_code,x.state_name
            order by comp_code,unit_code,state_name;        
        end    
        else if @pbreakon='4' begin --Branch wise
            
            select a.comp_code comp_code,a.unit_code unit_code,
            a.billno branch_name,
            a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from #cir_temp_bill_collection a 
            group by a.comp_code,a.unit_code,a.billno,a.city_code
            order by comp_code,unit_code,branch_name,city_name;
            
            select x.comp_code comp_code,x.unit_code unit_code,
            x.branch_name branch_name,sum(x.gross_copy) gross_copy,
            sum(x.less_copy) as less_copy,sum(x.Above_copy) as Above_copy
            from
            (select a.comp_code comp_code,a.unit_code unit_code,
            a.billno branch_name,
            a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from #cir_temp_bill_collection a 
            group by a.comp_code,a.unit_code,a.billno,a.city_code)x
            group by x.comp_code ,x.unit_code ,x.branch_name
            order by comp_code,unit_code,branch_name;        
        end    
        else if @pbreakon='5' begin --District wise

            select a.comp_code comp_code,a.unit_code unit_code,
            a.dist_code dist_name, 
            a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from #cir_temp_bill_collection a 
            group by a.comp_code,a.unit_code,a.dist_code,a.city_code
            order by comp_code,unit_code,dist_name,city_name;
            

            select x.comp_code comp_code,x.unit_code unit_code,
            x.dist_name dist_name,sum(x.gross_copy) gross_copy,
            sum(x.less_copy) as less_copy,sum(x.Above_copy) as Above_copy
            from
            (select a.comp_code comp_code,a.unit_code unit_code,
            a.dist_code dist_name, 
            a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from #cir_temp_bill_collection a 
            group by a.comp_code,a.unit_code,a.dist_code,a.city_code)x
            group by x.comp_code ,x.unit_code ,x.dist_name
            order by comp_code,unit_code,dist_name;        
        end    
        else if @pbreakon='6' begin --Taluka wise

            select a.comp_code comp_code,a.unit_code unit_code,
            a.taluka_code taluka_name,
            a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from #cir_temp_bill_collection a 
            group by a.comp_code,a.unit_code,a.taluka_code,a.city_code
            order by comp_code,unit_code,taluka_name,city_name;

            select x.comp_code comp_code,x.unit_code unit_code,
            x.taluka_name taluka_name,sum(x.gross_copy) gross_copy,
            sum(x.less_copy) as less_copy,sum(x.Above_copy) as Above_copy
            from
            (select a.comp_code comp_code,a.unit_code unit_code,
            a.taluka_code taluka_name,
            a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=isnull(@psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from #cir_temp_bill_collection a 
            group by a.comp_code,a.unit_code,a.taluka_code,a.city_code)x
            group by x.comp_code ,x.unit_code ,x.taluka_name
            order by comp_code,unit_code,taluka_name;        
         end
    end

drop table #cir_temp_bill_collection


end

/////////////////////////////////////////////NEXT  sent by rikkee/////////


ALTER procedure [dbo].[cir_get_ag_sub_add]
(
@pcompcode varchar(8),
@punitcode varchar(8),
@ppubl    varchar(50),
@pedtn    varchar(50),
@pagency  varchar(50),
@psuptype  varchar(50),
@pextra1  varchar(50),
@pextra2  varchar(50),
@pextra3  varchar(50),
@pextra4  varchar(50),
@pextra5  varchar(50),
@pagency_sub  varchar(50),
@psupdate   varchar(50)
)
as begin
select *,dbo.cir_get_city(a.comp_code,a.city_code) as CITY_NAME from cir_agmast a,cir_dbksup b
where 
a.comp_code=@pcompcode
and a.unit=@punitcode
and sup_type_code=@psuptype
and a.comp_code=b.comp_code
and a.unit=b.unit_code
and a.agcd=b.agcd
and a.dpcd=b.dpcd
and b.publ=isnull(@ppubl,b.publ)
and (b.edtn=isnull(@pedtn,b.edtn) or (@pedtn='') or (@pedtn is null)) 
and b.SUPDATE=@psupdate


end

//////////////////////////////////////////////////////end///////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////add by Deepika 21/09/2012//////////////////////////


                                   
ALTER PROCEDURE [dbo].[CIR_SUPPLY_POST_FOR_NEXT_DAY_cir_supply_posting_resale_p]
	@pcomp_code		VARCHAR(20) ,
	@punit_code     VARCHAR(20) ,
	@ppubl_code     VARCHAR(20) ,
	@pedtn_code     VARCHAR(20) ,
	@pagcd          VARCHAR(20) ,
	@pdpcd          VARCHAR(20) ,
	@puserid        VARCHAR(20) ,
	@psup_date      DATETIME ,
	@psup_ty        VARCHAR(20) ,
	@pissue_date    DATETIME ,--from preiodical issue master---
	@pdateformat    VARCHAR(20) ,
	@pextra1        varchar(2000),--for supply type code
	@pextra2        varchar(2000),--for supply copy
	@pextra3        varchar(2000),--for login branch code
	@pextra4        varchar(2000),
	@pextra5        varchar(2000)
AS 
    DECLARE  @vsup_date     DATETIME
    DECLARE  @vedtn1        VARCHAR(500)
    DECLARE  @vedtn_name1   VARCHAR(500)

       DECLARE cir_edtn_cur cursor LOCAL FOR 
                    select distinct edtn,edtn_name from cir_edtn_mast
                    where comp_code=@pcomp_code and publ = @ppubl_code and
                    (edtn = @pedtn_code or @pedtn_code is null or @pedtn_code='') and
                     ISNULL(freeze_flag,'N')='N'
 
    DECLARE  @vunit1			VARCHAR(500)
    DECLARE  @vagcd1			VARCHAR(500)
    DECLARE  @vdpcd1			VARCHAR(500)
    DECLARE  @vpubl1			VARCHAR(500)
    DECLARE  @vedtn11			VARCHAR(500)
    DECLARE  @vsupply_type_code1    VARCHAR(500)
    DECLARE  @vbase_supply1		VARCHAR(500)
    DECLARE  @vsupply_sun1		VARCHAR(500)
    DECLARE  @vsupply_mon1		VARCHAR(500)
    DECLARE  @vsupply_tue1		VARCHAR(500)
    DECLARE  @vsupply_wed1		VARCHAR(500)
    DECLARE  @vsupply_thu1		VARCHAR(500)
    DECLARE  @vsupply_fri1		VARCHAR(500)
    DECLARE  @vsupply_sat1		VARCHAR(500)
    DECLARE  @vsupply_spl11		VARCHAR(500)
    DECLARE  @vsupply_spl21		VARCHAR(500)
    DECLARE  @vag_type1			VARCHAR(500)
    DECLARE  @vsupply_start_dt1 VARCHAR(500)
    DECLARE  @vsuspend_date1    VARCHAR(500)
    DECLARE  @vpacket_size1		VARCHAR(500)
    DECLARE  @vcomm_code1		VARCHAR(500)
    DECLARE  @vcomm_flag1		VARCHAR(500)
    DECLARE  @vbill_agcd1		VARCHAR(500)
    DECLARE  @vroute_code1		VARCHAR(500)
    DECLARE  @vsubroute_code1   VARCHAR(500)
    DECLARE  @vsub_subroute_code1    VARCHAR(500)
    DECLARE  @vsurch_cd1		VARCHAR(500)
	DECLARE  @vwaste_catg_code	NUMERIC(20)
	
    DECLARE  @vbill_dpcd1		VARCHAR(500)
	DECLARE  @v_sup_copy		NUMERIC(7)
	DECLARE  @v_edtn_rate		NUMERIC(10,4)
	DECLARE  @vreccnt			NUMERIC(5,0)    


	SET  @vsup_date = @psup_date
	open cir_edtn_cur
	fetch NEXT FROM cir_edtn_cur into @vedtn1 , @vedtn_name1
	
	WHILE @@FETCH_STATUS = 0
	BEGIN

		delete from cir_dbksup_resale where comp_code=@pcomp_code and unit_code=@punit_code and
		publ=@ppubl_code and edtn=@vedtn1 and supdate=@psup_date and 
		(agcd=@pagcd or @pagcd is null or @pagcd='') and (dpcd=@pdpcd or @pdpcd is null or @pdpcd='')
	            
		begin
			select @v_edtn_rate=isnull(issue_price,0) from cir_priodical_issue_mast 
				where comp_code=@pcomp_code and unit_code=@punit_code and publ_code=@ppubl_code and 
					edtn_code=@vedtn1 and issue_date=@pissue_date
		end

		if (@v_edtn_rate=0)
		begin
			print('Please Check,The Rate Today Is not Define for '+' '+  @vedtn_name1)
		end 
	
		DECLARE  cur_supply cursor LOCAL FOR 
			select a.unit unit,a.agcd agcd,a.dpcd dpcd,a.publ publ,a.edtn edtn,a.supply_type_code supply_type_code,a.base_supply base_supply,a.supply_sun supply_sun,
			  a.supply_mon supply_mon,a.supply_tue supply_tue,a.supply_wed supply_wed,
			  a.supply_thu supply_thu,a.supply_fri supply_fri,a.supply_sat supply_sat,
			  b.ag_type ag_type,b.supply_start_dt    supply_start_dt,b.suspend_date suspend_date, ISNULL(a.packet_size,0) packet_size,
			  a.comm_code comm_code,a.comm_flag comm_flag,b.bill_agcd bill_agcd,b.bill_dpcd bill_dpcd,
			  a.route_code route_code,a.subroute_code subroute_code,a.sub_subroute_code sub_subroute_code,
			  a.surch_cd surch_cd,case a.waste_catg_code
			  when '' then 0 when null then 0 else  a.waste_catg_code end as  waste_catg_code
			  from cir_supply a,cir_agmast b
			  where a.comp_code=b.comp_code and a.comp_code=@pcomp_code and a.unit=b.unit and a.unit=@punit_code and 
				a.agcd=b.agcd and a.dpcd=b.dpcd and (a.agcd=@pagcd or @pagcd is null) 
				and (a.dpcd=@pdpcd or @pdpcd is null) and 
				a.publ=@ppubl_code and --ISNULL(base_supply,0)>0 and
				a.edtn=@vedtn1 and
				ISNULL(a.supply_flag,'N')='Y' and ISNULL(b.suspend,'N')='N'
				order by a.agcd,a.dpcd,a.edtn,a.supply_type_code

		open cur_supply 
		fetch next from cur_supply into @vunit1 ,@vagcd1 ,@vdpcd1 ,@vpubl1 ,@vedtn11 ,@vsupply_type_code1,@vbase_supply1,
			@vsupply_sun1 ,@vsupply_mon1 ,@vsupply_tue1 ,@vsupply_wed1 ,@vsupply_thu1 ,@vsupply_fri1,@vsupply_sat1 ,
			@vag_type1 ,@vsupply_start_dt1, @vsuspend_date1 ,@vpacket_size1 ,@vcomm_code1 ,@vcomm_flag1 ,@vbill_agcd1 ,@vbill_dpcd1,
			@vroute_code1 ,@vsubroute_code1 ,@vsub_subroute_code1 ,@vsurch_cd1 ,@vwaste_catg_code
        WHILE @@FETCH_STATUS = 0
        Begin
        
			if (@vsup_date>=@vsupply_start_dt1 or @vsupply_start_dt1 is null) and (@vsup_date<=@vsuspend_date1 or @vsuspend_date1 is null) 
			Begin 
				set @v_sup_copy=@pextra2
				if ISNULL(@v_sup_copy,0)>0 
				Begin
				
				
					 insert into cir_dbksup_resale (comp_code,unit_code,publ,edtn,agcd,dpcd,supdate,sup_type_code,sup_copy,agency_ty_code,
							agency_pkt_size,comm_code,comm_fix_auto_spl,sup_rate,billagcd,billdpcd,
							route_code,subroute_code,subsubroute_code,userid,surch_cd,issue_date,return_copy_sale,RESALE_BRANCH,waste_catg_code)
							 
					 values (@pcomp_code,@punit_code,@ppubl_code,@vedtn11,@vagcd1,@vdpcd1,@vsup_date,
							 @vsupply_type_code1,
							 @v_sup_copy,@vag_type1,@vpacket_size1,@vcomm_code1,@vcomm_flag1,
							 @v_edtn_rate,@vbill_agcd1,@vbill_dpcd1,@vroute_code1,
							 @vsubroute_code1,@vsub_subroute_code1,@puserid,@vsurch_cd1,@pissue_date,'Y',@pextra3,CAST(@vwaste_catg_code AS numeric (5)));
                         
							 select @vreccnt    = count(*)  from cir_dbksup_resale where comp_code=@pcomp_code and unit_code=@punit_code and 
							 publ=@ppubl_code and edtn=@vedtn1 and supdate=@vsup_date and (agcd=@pagcd or @pagcd is null) and (dpcd=@pdpcd or @pdpcd is null);
	                             
				End
			End 
			
		fetch next from cur_supply into @vunit1 ,@vagcd1 ,@vdpcd1 ,@vpubl1 ,@vedtn11 ,@vsupply_type_code1,@vbase_supply1,
			@vsupply_sun1 ,@vsupply_mon1 ,@vsupply_tue1 ,@vsupply_wed1 ,@vsupply_thu1 ,@vsupply_fri1,@vsupply_sat1 ,
			@vag_type1 ,@vsupply_start_dt1, @vsuspend_date1 ,@vpacket_size1 ,@vcomm_code1 ,@vcomm_flag1 ,@vbill_agcd1 ,@vbill_dpcd1,
			@vroute_code1 ,@vsubroute_code1 ,@vsub_subroute_code1 ,@vsurch_cd1 ,@vwaste_catg_code
		End 
		close cur_supply;
	fetch NEXT FROM cir_edtn_cur into @vedtn1 , @vedtn_name1
	set  @v_edtn_rate = 0    set  @vedtn1=NULL
end
close cir_edtn_cur   

select case b.bill_pay
              when 'Y' then 'PAID'
              when 'N' then 'UNPAID'
              else  'UNPAID' 
              end  BILL_PAY,sum(a.sup_copy) SUP_COPY
from cir_dbksup_resale a,cir_supply_type_mast b
where a.comp_code=@pcomp_code and a.comp_code=b.comp_code and a.unit_code=@punit_code and 
      a.publ=@ppubl_code and (a.edtn=@pedtn_code or @pedtn_code is null or @pedtn_code='') and 
      a.sup_type_code=b.sup_ty_code and a.supdate=@vsup_date and 
      (a.agcd=@pagcd or @pagcd is null or @pagcd='') and (a.dpcd=@pdpcd or @pdpcd is null or @pdpcd='')
group by b.bill_pay
order by b.bill_pay desc
  
deallocate cir_edtn_cur
deallocate cur_supply


//////////////////////////////////////////////////////end////////////////////////////////////////////////////



//////////////////////////////////////add by Deepika Sent By Laxman Sir 21/09/2012//////////////////////////

ALTER PROCEDURE [dbo].[cir_fetch_suppliment_data_p]
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
print ('**')
SET @v_recptdt  = @pdatetill--CONVERT(DATETIME, @pdatetill)

CREATE TABLE #CIR_LEDGER_REPORT
(COMP_CODE VARCHAR(100),
UNIT_CODE VARCHAR(100),
DEBIT_HEAD VARCHAR(100),
REC_SEQNO INT)

CREATE TABLE #CIR_TEMP_SUPPLIMENT
( COMP_CODE     VARCHAR(10),
  UNIT_CODE     VARCHAR(10),
  SEQ_NO        NUMERIC(5),
  EDITION_CODE  VARCHAR(10),
  SUP_DATE      DATETIME,
  INC_RATE      NUMERIC(10,2),
  NOOF_SUPL     NUMERIC(3),
  SUPL_NAME     VARCHAR(100),
  SESS_ID       INT )

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
   
DELETE FROM   cir_supl_process_det_temp WHERE  recptno  = '''' + cast(@@SPID as varchar) + ''''


print('8')
print(@@SPID )
SET @v_sess_id  =  @@SPID

/* for  Edition Code */

SET @vlength  = null SET @vrunval  = null
SET @v_val  = REPLACE(@pedtncode_val, @pdelimiter, ',')
SET @vlength  = LEN(@v_val)SET @vno  = 1
print(@v_val)
DECLARE @i INT
SET @i  = 1

WHILE @i <= @vlength BEGIN
SET @vrunval  = SUBSTRING(@v_val, @i, 1)
print('@vrunval')
print(@vrunval)
IF @vrunval != ',' BEGIN
SET @v_name  = isnull(@v_name,'') + @vrunval
END
ELSE BEGIN
print('@v_name')
print(@v_name)
INSERT INTO  #cir_temp_suppliment( comp_code , unit_code , seq_no , edition_code) 
VALUES ( @pcompcode , @punitcode , @vno , @v_name) 

SET @vno  = @vno + 1
SET @v_name  = ''
END
SET @i = @i + 1
END

/* for Supply Date */

SET @vrunval = null
SET @v_name = null SET @v_sname  = null
SET @v_val = REPLACE(@psupdate_val, @pdelimiter, ',')
SET @vlength = LEN(@v_val)
SET @vno  = 1 SET @i = 1

WHILE @i <= @vlength BEGIN

SET @vrunval  = SUBSTRING(@v_val, @i, 1)
IF @vrunval != ',' BEGIN
SET @v_name  = isnull(@v_name,'') + @vrunval
END
ELSE
BEGIN
declare @dd as varchar(2)
declare @mm as varchar(2)
declare @yyyy as varchar(4)
if @pdateformat='dd/mm/yyyy'
begin
set @dd= substring(@v_name,1,2)
set @mm= substring(@v_name,4,2)
set @yyyy=substring(@v_name,7,4)
set @v_name=@mm +'/'+@dd+'/'+@yyyy
end
else if @pdateformat='yyyy/mm/dd'
begin
set @yyyy= substring(@v_name,1,4)
set @mm= substring(@v_name,6,2)
set @dd=substring(@v_name,9,2)
set @v_name=@mm +'/'+@dd+'/'+@yyyy
end
SET @v_dt  = CONVERT(DATETIME, @v_name)
UPDATE  #cir_temp_suppliment SET sup_date = @v_dt WHERE seq_no  = @vno

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
SET @v_name  = isnull(@v_name,'') + @vrunval
END
ELSE BEGIN
UPDATE  #cir_temp_suppliment SET inc_rate = (@v_name) WHERE  seq_no  = @vno

SET @vno  = @vno + 1
SET @v_name  = ''
END
SET @i = @i + 1
END

/* for No of Supl */

SET @vrunval  = null
SET @v_name  = null
SET @v_sname = null
SET @v_val = REPLACE(@psupl_no_val, @pdelimiter, ',')
SET @vlength = LEN(@v_val) SET @vno  = 1 SET @i = 1

WHILE @i <= @vlength BEGIN
SET @vrunval  = SUBSTRING(@v_val, @i, 1)
IF @vrunval != ','
BEGIN
SET @v_name  = isnull(@v_name,'') + @vrunval
END
ELSE BEGIN
UPDATE  #cir_temp_suppliment  SET noof_supl = (@v_name) WHERE  seq_no  = @vno

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
SET @vno = 1 SET @i = 1

WHILE @i <= @vlength BEGIN
SET @vrunval  = SUBSTRING(@v_val, @i, 1)
IF @vrunval != ',' BEGIN
SET @v_sname  = isnull(@v_sname,'') + @vrunval
END
ELSE BEGIN
UPDATE  #cir_temp_suppliment  SET supl_name = (@v_sname) WHERE  seq_no  = @vno

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
SET @v_name  = isnull(@v_name,'') + @vrunval
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


DECLARE @c1_comp_code VARCHAR(40)
DECLARE @c1_unit_code VARCHAR(40)
DECLARE @c1_publ VARCHAR(40)
DECLARE @c1_edtn VARCHAR(40)
DECLARE @c1_supdate DATETIME
DECLARE @c1_agcd VARCHAR(40)
DECLARE @c1_dpcd VARCHAR(40)
DECLARE @c1_billagcd VARCHAR(40)
DECLARE @c1_billdpcd VARCHAR(40)
DECLARE @c1_inc_rate NUMERIC(15,2)
DECLARE @c1_no_of_supl  INT
DECLARE @c1_supl_name VARCHAR(400)
DECLARE @c1_sup_copy INT

  
DECLARE c1 CURSOR LOCAL FOR
SELECT DISTINCT a.comp_code comp_code, a.unit_code unit_code, a.publ publ,
a.edtn edtn, a.supdate supdate, a.agcd agcd, a.dpcd dpcd, a.billagcd billagcd,
a.billdpcd billdpcd, b.inc_rate inc_rate, b.noof_supl no_of_supl,b.supl_name supl_name,
SUM(a.sup_copy) sup_copy
FROM  cir_dbksup a, #cir_temp_suppliment b,cir_supply_type_mast c,cir_agmast d
WHERE a.comp_code  = @pcompcode AND a.comp_code  = b.comp_code AND a.comp_code  = c.comp_code AND a.comp_code  = d.comp_code
AND a.unit_code  = ISNULL(@punitcode, a.unit_code) AND a.unit_code  = d.unit
AND a.edtn  = b.edition_code
AND a.supdate  >= @pdatefrom AND a.supdate  <= @pdatetill
AND a.sup_type_code  = c.sup_ty_code
AND (a.sup_type_code  = ISNULL(@psup_type, a.sup_type_code)  OR @psup_type  ='')
AND a.agcd  = d.agcd AND a.dpcd  = d.dpcd
AND (d.agcd  = ISNULL(@pagcode, d.agcd)  OR @pagcode  ='')
AND (d.dpcd  = ISNULL(@pdepocode, d.dpcd) OR @pdepocode  ='')
AND (d.ag_type  = @pagtype OR @pagtype IS NULL)
AND (d.ag_class  = @pagclass OR @pagclass  IS NULL)
AND (d.dist_code  IN(SELECT debit_head FROM  #cir_ledger_report) OR @pcode  IS NULL  OR @pcode  ='')
--AND b.sess_id  = @@SPID
AND a.supdate  = b.sup_date
AND a.billagcd  IS NOT NULL
GROUP BY a.comp_code, a.unit_code, a.publ, a.edtn, a.supdate, a.agcd,a.dpcd,a.billagcd,
a.billdpcd,b.inc_rate, b.noof_supl, b.supl_name
ORDER BY a.comp_code,a.unit_code,a.supdate,a.publ,a.edtn

print('Q')
OPEN c1
FETCH NEXT FROM c1 INTO @c1_comp_code,@c1_unit_code,@c1_publ,@c1_edtn,@c1_supdate,@c1_agcd,@c1_dpcd,@c1_billagcd,@c1_billdpcd,
@c1_inc_rate,@c1_no_of_supl,@c1_supl_name,@c1_sup_copy
WHILE (@@FETCH_STATUS = 0)
BEGIN
SET @v_amt  = ( ISNULL( @c1_sup_copy, 0)- ISNULL(@v_unsold_copy, 0)) * ISNULL(@c1_inc_rate, 0)* ISNULL(@c1_no_of_supl, 0)
print('W')
IF ISNULL(@v_amt, 0)<> 0 BEGIN
INSERT INTO  cir_supl_process_det_temp  
( comp_code , unit_code , publ_code , edtn_code , supdate , agcd ,
dpcd , tot_supply , per_copy_rate , no_of_supl , recptdt , recptno , amount ,
bilagcd , bildpcd , created_by , doctype , supl_name) 

VALUES ( @c1_comp_code , @c1_unit_code , @c1_publ , @c1_edtn , @c1_supdate , @c1_agcd , @c1_dpcd ,
ISNULL(@c1_sup_copy, 0) - ISNULL(@v_unsold_copy, 0) ,
@c1_inc_rate , @c1_no_of_supl , @v_recptdt , @@SPID , @v_amt , @c1_billagcd ,
@c1_billdpcd , @puserid , @v_doctype , @c1_supl_name ) 
print('*')print(@c1_comp_code)print(@c1_unit_code)print(@c1_publ)print(@c1_edtn)print(@c1_supdate)print(@c1_agcd)
print(@c1_dpcd) print(@c1_sup_copy)print(@v_unsold_copy)print(@c1_inc_rate)
print(@c1_no_of_supl) print(@v_doctype)print(@c1_supl_name)print('%')
END
FETCH NEXT FROM c1 INTO @c1_comp_code,@c1_unit_code,@c1_publ,@c1_edtn,@c1_supdate,@c1_agcd,@c1_dpcd,@c1_billagcd,@c1_billdpcd,
@c1_inc_rate,@c1_no_of_supl,@c1_supl_name,
@c1_sup_copy

END
CLOSE c1
SET @v_amt  = 0
print('@v_sess_id')print(@v_sess_id)
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
and dbo.cir_get_ins_status(s.comp_code,s.bilagcd,s.bildpcd,s.unit_code,'','')='Y'
AND s.recptno  = @v_sess_id
GROUP BY s.comp_code,s.unit_code,s.recptno,s.recptdt,s.doctype,s.bilagcd,s.bildpcd,m.station_code,m.city_code,m.ag_name
HAVING SUM(CONVERT(FLOAT, amount))  > 0 
ORDER BY comp_code,unit_code,bilagcd,bildpcd
DEALLOCATE c1
--DELETE FROM   cir_supl_process_det_temp   --change by neha
DROP TABLE #cir_ledger_report;
DROP TABLE #cir_temp_suppliment;

END

/////////////////////////////////////next


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
    declare @v_dt as datetime
    declare @v_day as  varchar(20)
    declare @v_flg      as  varchar(1)
    declare @v_recno    as  int
    declare @v1_comp_code as varchar(20)
    declare @v1_unit_code as varchar(20)
    declare @v1_publ_code as varchar(20)
    declare @v1_publ_name as varchar(200)
    declare @v1_main_edtn as varchar(20)
    declare @v1_main_edtn_name as varchar(200)
    declare @v1_edtn as varchar(20)
    declare @v1_edtn_name as varchar(200)
    declare @v1_supl_name as varchar(200)
    declare @v1_valid_from as datetime
    declare @v1_valid_till as datetime
    declare @v1_insertion_fee as numeric(14,2)
    declare @v1_sun_allow as varchar(20)
    declare @v1_mon_allow as varchar(20)
    declare @v1_tue_allow as varchar(20)
    declare @v1_wed_allow as varchar(20)
    declare @v1_thu_allow as varchar(20)
    declare @v1_fri_allow as varchar(20)
    declare @v1_sat_allow as varchar(20)
   
   
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
declare @x as int
set @x=0
    open c1
        fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_publ_code,@v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,
@v1_edtn,@v1_edtn_name,@v1_supl_name,@v1_valid_from,@v1_valid_till,@v1_insertion_fee,
@v1_sun_allow,@v1_mon_allow,@v1_tue_allow,@v1_wed_allow,@v1_thu_allow,@v1_fri_allow,@v1_sat_allow
        WHILE (@@FETCH_STATUS = 0)
BEGIN
set @x=@x+1
        print('@x')print(@x)
       
set @v_dt=@pfromdate
WHILE (@v_dt <= @ptilldate)
BEGIN

print('@v_dt1') print(@v_dt)print(@v1_valid_from)print(@v1_valid_till)

if @v_dt between @v1_valid_from and @v1_valid_till
Begin
                set @v_day=CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @v_dt),20)
               
if @v_day='Sunday'
Begin
If @v1_sun_allow='Y'
Begin
set @v_flg='Y'
End   
Else
Begin
set @v_flg='N'
End
End   
Else if @v_day='Monday'
Begin
If @v1_mon_allow='Y'
Begin
set @v_flg='Y'
End   
Else Begin
set @v_flg='N'
End
End   
Else if @v_day='Tuesday'
Begin
If @v1_tue_allow='Y'
Begin
set @v_flg='Y'
End   
Else Begin
set @v_flg='N'
End
End
Else If @v_day='Wednesday'
Begin
If @v1_wed_allow='Y'
Begin
set @v_flg='Y'
End
Else
Begin
set @v_flg='N'
End
End   
Else If @v_day='Thursday'
Begin
If @v1_thu_allow='Y'
Begin
set @v_flg='Y'
End   
Else Begin
set @v_flg='N'
End
End   
Else if @v_day='Friday'
Begin
If @v1_fri_allow='Y'
Begin
set @v_flg='Y'
End   
Else Begin
set @v_flg='N'
End   
End
Else
Begin
If @v1_sat_allow='Y'
Begin
set @v_flg='Y'
End   
Else Begin
set @v_flg='N'
End
End
print('@v_flg')print(@v_flg)
                If @v_flg='Y' Begin
                    insert into #cir_temp_bill_collection
                        (comp_code, unit_code, billno,publ_code, agcd, dpcd,agname,agname_oth_lang, city_code,
                        billdt,comm_amt)
                    values(@v1_comp_code,@v1_unit_code,@v1_publ_code,@v1_publ_name,@v1_main_edtn,@v1_edtn,@v1_main_edtn_name,@v1_edtn_name,
                        @v1_supl_name,@v_dt,@v1_insertion_fee)
                End                
end
print('@v_dt = 1')print(@v_dt)
set @v_dt=DATEADD(dd,1,@v_dt)
print('@v_dt = 2')print(@v_dt)
           
     End

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

////////////////////////////////////////////////////next


create FUNCTION  [dbo].[cir_get_ins_status]
(@pcomp_code  varchar(100),@agcd  varchar(100),@dpcd  varchar(100),@unit  varchar(100),@extra1 varchar(10),@extra2 varchar(10))
RETURNs char(400)
AS
Begin

        DECLARE @vregion VARCHAR(400)
       
        select distinct @vregion=  insertion_fee from cir_supply
        where comp_code=@pcomp_code and unit=@unit and agcd=@agcd and dpcd=@dpcd


  return isnull(@vregion,'N')
END

///////////////////////////////////////////end///////////////////////////////////////////////////////////////////

 
/********delivery order**************/

ALTER PROCEDURE [dbo].[cir_DO_generation]
(
@pcomp_code                         VARCHAR(20) ,
@punit_code                         VARCHAR(200),
@pbranch_code                       VARCHAR(200),
@proute_code                        VARCHAR(200),
@pagcd                              VARCHAR(200),
@pdpcd                              VARCHAR(200),
@pdate                              VARCHAR(20) ,
@pubcode                            VARCHAR(200),
@pdateformat                        VARCHAR(200),
@pextra1                            VARCHAR(200),
@pextra2                            VARCHAR(200) ,
@pprocess   varchar(200)-- 1 for process and 2 for report
)
as
--exec cir_DO_generation 'ht001','del','','rt001','b0002','0001','09/30/2012','p04,p08,p12,p57','','','','2'
	create table #Results(SegmentNum INT, Edition_Name  VARCHAR(255))
	insert into #Results select * from dbo.Fn_Splitfield(@proute_code,',')
	
	create table #Results1(SegmentNum INT, Edition_Name  VARCHAR(255))
	insert into #Results1 select * from dbo.Fn_Splitfield(@pubcode,',')
	
	create table #output( out_put  VARCHAR(2000))


  Begin
declare @v_output varchar(2000) 
	if(@pprocess='1') begin
			declare c1 cursor for
			select distinct d.comp_code,d.unit_code,d.agcd,d.dpcd from cir_dbksup d,cir_agmast a 
			where d.comp_code=a.comp_code 
			and a.unit=d.unit_code
			and d.agcd=a.agcd 
			and d.dpcd=a.dpcd
			and  d.comp_code=@pcomp_code 
			and  d.unit_code=a.unit 
			and d.unit_code=@punit_code 
			and (a.branch_code=@pbranch_code or @pbranch_code is null or @pbranch_code='')
			and (d.route_code in ( select edition_name from #Results) or @proute_code is null or @proute_code='' )
			and (d.agcd=@pagcd  or @pagcd is null or @pagcd='')
			and (d.dpcd=@pdpcd or @pdpcd is null or @pdpcd='')
			and d.supdate=@pdate 
			and (d.publ in ( select edition_name from #Results1) or @pubcode is null or @pubcode='')
			order by d.agcd,d.dpcd
			
			
			

			declare @v_comp varchar(20)
			declare @v_unit varchar(20)
			declare @v_publ varchar(20)
			declare @v_agcd varchar(20)
			declare @v_dpcd varchar(20)
			DECLARE @v_count int
			DECLARE @v_dono int
			DECLARE @v_publication varchar(8000)
			DECLARE @v1_pub varchar(8000)
			set @v1_pub=null
			set @v_publication=null
			open c1
			
			
		fetch next from c1 into @v_comp,@v_unit,@v_agcd,@v_dpcd
		while(@@fetch_status=0)begin
		--delete  from  CIR_DELIVERY_ORDER where comp_code=@v_comp and unit_code=@v_unit
		--and agcd=@v_agcd and dpcd=@v_dpcd

		set @v_publication=''
		declare c2 cursor for
		select distinct d.publ from cir_dbksup d 
		where   d.comp_code=@pcomp_code    and  d.unit_code=@punit_code   
		and (d.agcd=@v_agcd)   and (d.dpcd=@v_dpcd)    
		and (d.publ in ( select edition_name from #Results1) or @pubcode is null or @pubcode='')
		order by d.publ






		open c2
		fetch next from c2 into @v1_pub
		while(@@fetch_status=0)begin
		delete from #output
		insert into #output	exec cir_check_DO @v_comp,@v_unit,@v_agcd,@v_dpcd,@v1_pub
		
		select @v_output=out_put from #output
		
		if(@v_output='OK')BEGIN
			if(@v_publication is null or @v_publication='')begin
			set @v_publication=@v1_pub
			end
			else begin
			set @v_publication=@v_publication+','+@v1_pub
			end
		END
		fetch next from c2 into @v1_pub
		end
		close c2 
		deallocate c2
		
	    
		
		if(@v_publication IS NOT NULL AND @v_publication!='')BEGIN
			select @v_dono=isnull(max(cast(do_no as int)),0)+1  from  CIR_DELIVERY_ORDER
			insert into  CIR_DELIVERY_ORDER values(@v_comp,@v_unit,@v_dono,@v_publication,@v_agcd,@v_dpcd)
		end
		fetch next from c1 into @v_comp,@v_unit,@v_agcd,@v_dpcd
		end
		close c1
		deallocate c1

		select * from  CIR_DELIVERY_ORDER  order by agcd,dpcd
	end 
		
	else begin
declare @vv_pub varchar(4000)
declare @vv_dono varchar(4000)
declare @vv_agcd varchar(4000)
declare @vv_dpcd varchar(4000)

declare do cursor for
select distinct publ,DO_NO,agcd,dpcd from CIR_DELIVERY_ORDER d
		where d.comp_code = @pcomp_code and 
		d.unit_code = @punit_code and 
		--((d.publ   in ( select edition_name from #Results1)) or @pubcode is null or @pubcode='') and 
		((d.agcd    = @pagcd) or (@pagcd is null) or (@pagcd='')) and 
		((d.dpcd    = @pdpcd) or (@pdpcd is null) or (@pdpcd=''))
		create table #Results_do(SegmentNum INT, Edition_Name  VARCHAR(255))
		create table #Results_temp(SegmentNum INT, Edition_Name  VARCHAR(255))
		create table #output_do(publ VARCHAR(4000) , dono  VARCHAR(4000), agcd  VARCHAR(4000), dpcd  VARCHAR(4000))
	

	declare @v_v varchar(4000)
		
		open do
		fetch next from do into @vv_pub,@vv_dono,@vv_agcd,@vv_dpcd
		while(@@fetch_status=0)begin
		
	insert into #Results_temp select * from dbo.Fn_Splitfield(@vv_pub,',')
					insert into #Results_do select * from dbo.Fn_Splitfield(@vv_pub,',')
					
					
					declare vt cursor for
					select Edition_Name from #Results_temp
					open vt
					fetch next from vt into @v_v
					while(@@fetch_status=0)begin
					insert into #output_do	values(@v_v,@vv_dono,@vv_agcd,@vv_dpcd)
					fetch next from vt into @v_v
					end
					close vt
					deallocate vt
					
					
	delete from #Results_temp
		fetch next from do into @vv_pub,@vv_dono,@vv_agcd,@vv_dpcd
		end
		close do
		deallocate do
		

		SELECT distinct  a.COMP_CODE,a.UNIT_CODE,a.AGCD,a.DPCD,AGNAME,
		dbo.cir_get_agency_address(a.COMP_CODE,a.UNIT_CODE,a.AGCD,a.DPCD,'')AG_ADDR,
		a.PUBL,dbo.cir_get_publ_name(a.COMP_CODE,a.PUBL) PUBL_NAME,LBL_DT,
		(SELECT SUM(SUPPLY_1) FROM CIR_LBLMAST T WHERE T.COMP_CODE=A.COMP_CODE AND T.UNIT_CODE=A.UNIT_CODE AND 
		T.LBL_DT=A.LBL_DT AND T.AGCD=A.AGCD AND T.DPCD=A.DPCD AND T.PUBL=A.PUBL ) AS "TOTAL_SUPPLY_COPY",PKT_SIZE,
		(SELECT SUM(SUPPLY_1) FROM CIR_LBLMAST T WHERE T.COMP_CODE=A.COMP_CODE AND T.UNIT_CODE=A.UNIT_CODE AND 
		T.LBL_DT=A.LBL_DT AND T.AGCD=A.AGCD AND T.DPCD=A.DPCD AND T.PUBL=A.PUBL )%PKT_SIZE LAST_PKT,           
		CASE ( (SELECT SUM(SUPPLY_1) FROM CIR_LBLMAST T WHERE T.COMP_CODE=A.COMP_CODE AND T.UNIT_CODE=A.UNIT_CODE AND 
		T.LBL_DT=A.LBL_DT AND T.AGCD=A.AGCD AND T.DPCD=A.DPCD AND T.PUBL=A.PUBL )%PKT_SIZE)
		--WHEN 0 THEN  (MAX(LBL_TNO)-1)
		--ELSE  (MAX(LBL_TNO)-1) END ST_BUNDLE  
		WHEN 0 THEN  (count(*)-1)
		ELSE  (count(*)-1) END ST_BUNDLE  
		,#output_do.dono  DO_NO
		FROM CIR_LBLMAST A,CIR_DELIVERY_ORDER d,#output_do
		where a.comp_code = @pcomp_code and 
		a.unit_code = @punit_code and 
		lbl_dt    =@pdate and 
		((a.publ   in ( select edition_name from #Results1)) or @pubcode is null or @pubcode='') and                   
		((route1   in ( select edition_name from #Results)) or @proute_code is null or @proute_code='')and 
		((a.agcd    = @pagcd) or (@pagcd is null) or (@pagcd='')) and 
		((a.dpcd    = @pdpcd) or (@pdpcd is null) or (@pdpcd='')) and
		a.comp_code=d.comp_code
		and a.unit_code=d.unit_code
		and a.agcd=d.agcd
		and a.dpcd=d.dpcd
		and #output_do.publ=a.publ
		and #output_do.agcd=a.agcd
		and #output_do.dpcd=a.dpcd
		and #output_do.agcd=d.agcd
		and #output_do.dpcd=d.dpcd
		GROUP BY a.COMP_CODE,a.UNIT_CODE,AGNAME,a.AGCD,a.DPCD,a.PUBL,PKT_SIZE,LBL_DT
		,#output_do.dono 
		ORDER BY a.COMP_CODE,a.UNIT_CODE,#output_do.dono,AGNAME,a.publ
	drop table #Results_do
drop table #Results_temp
drop table #output_do
	end
drop table #Results
drop table #Results1
drop table #output

End
  
  

/********************delivery order**************/

////////////////////////////////////////////add by Deepika 26/09/2012/////////


ALTER Procedure [dbo].[cir_suspend_type_wise_permission]
     @pcompcode           VARCHAR(20),
     @ppcenter            VARCHAR(20),
     @pbranch             VARCHAR(20),     
     @pdateformat         VARCHAR(20),
     @puserid             VARCHAR(20),
     @puserrole           VARCHAR(20),
     @psusp_type          VARCHAR(20),
     @pFlag               VARCHAR(20), -- Y / N 
     @pextra1             VARCHAR(200),
     @pextra2             VARCHAR(200),
     @pextra3             VARCHAR(200),
     @pextra4             VARCHAR(200),
     @pextra5             VARCHAR(200),
     @pextra6             VARCHAR(200),
     @pextra7             VARCHAR(200),
     @pextra8             VARCHAR(200),
     @pextra9             VARCHAR(200),
     @pextra10            VARCHAR(200)


  As
  begin
	declare @v_cnt as int
	declare @v1_userid as varchar(20)
    declare @v1_username as varchar(2000)
	
	DECLARE c1 cursor LOCAL FOR 
	   select userid,username from login where com_code=@pcompcode 
	   and roleid=@puserrole and (userid=isnull(@puserid,userid) or @puserid ='')
   
	OPEN c1 
	fetch NEXT FROM c1 INTO @v1_userid, @v1_username 
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
		
			select @v_cnt=count(*) from CIR_SUSPEND_TYPE_PERMISSION 
			where comp_code=@pcompcode and unit_code=@ppcenter and user_code=@v1_userid
			and SUSPEND_TYPE_CODE=isnull(@psusp_type,'N')
			
			if(@v_cnt>0)
			begin
				update CIR_SUSPEND_TYPE_PERMISSION set  [USER_FLAG]=isnull(@pFlag,'N')
				where comp_code=@pcompcode and unit_code=@ppcenter and user_code=@v1_userid
				and SUSPEND_TYPE_CODE=isnull(@psusp_type,'N')
			end
			else
			begin
				INSERT INTO CIR_SUSPEND_TYPE_PERMISSION ([COMP_CODE],[UNIT_CODE],[USER_CODE],[SUSPEND_TYPE_CODE],[USER_FLAG],[USER_ROLE])
								VALUES					(@pcompcode,@ppcenter,@v1_userid,isnull(@psusp_type,'N'),isnull(@pFlag,'N'),@puserrole )
			end

		fetch NEXT FROM c1 INTO @v1_userid, @v1_username
		END 
	close c1
	DEALLOCATE c1
	
	
		
	
  
  end
       
	//////////////////////////////////next sent by amit sir


ALTER procedure [dbo].[cir_agency_bind_for_mail_sms] (
        @pcompcode            varchar(10),
        @punit                varchar(10),
        @pbranch              varchar(10),
        @psource              varchar(10),
        @pregion_code         varchar(20),
        @pzone_code           varchar(20),
        @pstate_code          varchar(20), -- roleid in case of internal
        @pdist_code           varchar(20), -- userid  in case of internal
        @pcity_code           varchar(20),
        @pagcd                varchar(10),
        @pdpcd                varchar(10),
        @pdateformat          varchar(10),
        @pextra1              varchar(10),
        @pextra2              varchar(10)
        ) as
  Begin
  
  
	if @psource ='E'
	begin

			 create table #temp_route(SegmentNum INT,Route_cd varchar(100))
			 insert into #temp_route select * from  dbo.Fn_Splitfield(@pextra1,',')
		
	     select distinct a.* from cir_agmast a,CIR_SUPPLY s
         where a.COMP_CODE=s.COMP_CODE 
         and  a.unit=s.unit
         and a.AGCD=s.AGCD
         and a.DPCD=s.DPCD and
         a.comp_code = @pcompcode 
         and (a.unit = @punit or @punit ='' or @punit is null)
         and (BRANCH_CODE = @pbranch or @pbranch ='' or @pbranch is null)
         and (dbo.cir_get_region_by_city(@pcompcode,a.CITY_CODE,'C') = @pregion_code or @pregion_code ='' or @pregion_code is null)
         and (dbo.cir_get_zone_by_city(@pcompcode,a.CITY_CODE,'C') = @pzone_code or @pzone_code ='' or @pzone_code is null)
         and (STATE_CODE = @pstate_code or @pstate_code ='' or @pstate_code is null) 
         and (DIST_CODE = @pdist_code or @pdist_code ='' or @pdist_code is null) 
         and (CITY_CODE = @pcity_code or @pcity_code ='' or @pcity_code is null) 
         and (s.ROUTE_CODE in ( select Route_cd from #temp_route) or @pextra1 ='' or @pextra1 is null) 
         and (a.agcd=@pagcd or @pagcd is null or @pagcd ='') 
         and (a.dpcd=@pdpcd or @pdpcd is null or @pdpcd ='')
         and isnull(freeze_flag,'N')='N'
         order by ag_name
         
         drop table #temp_route
	end
	else
	begin
		select * from login
         where com_code = @pcompcode 
         --and (unit = @punit or @punit ='' or @punit is null)
         and (retainer_code = @pbranch or @pbranch ='' or @pbranch is null)         
         and (ROLEID = @pstate_code or @pstate_code ='' or @pstate_code is null) 
         and (userid = @pdist_code or @pdist_code ='' or @pdist_code is null)
         order by username
	
	end
  
  End 

///////////////////////////////////////////////next/////////////////

create procedure cir_update_datapos
	@pcompcode			VARCHAR(20) ,
	@punit              VARCHAR(20) ,
	@pagclass           VARCHAR(20),
	@pdataposf           VARCHAR(20),  
	@pdateformat        VARCHAR(20) ,
	@pextra1            VARCHAR(4000) ,
	@pextra2            VARCHAR(4000) 
As
begin
   
    update CIR_AGMAST set DATA_POST=@pdataposf
    where COMP_CODE=@pcompcode and UNIT=@punit
    and AG_CLASS=@pagclass
    
 end

////////////////////////////////////for suspend type pemission form/////////////////////



create procedure [dbo].[cir_suspend_detail]

 @pcompcode         as  varchar(50),
 @pblockunblock     as  varchar(10),
 @puserid           as  varchar(50),
 @pextra1           as  varchar(20),
 @pextra2           as  varchar(20)
 
   
As

    SELECT distinct a.comp_code,a.SUSPEND_TYPE_CODE,a.SUSPEND_DESC,ISNULL(b.user_flag,'N') 
    FLAG,ISNULL(  b.SUSPEND_TYPE_CODE ,'N')  AS ENTRY_EXISTS 
    FROM cir_suspend_type_mast a left outer join CIR_SUSPEND_TYPE_PERMISSION b
    on a.SUSPEND_TYPE_CODE=b.SUSPEND_TYPE_CODE AND a.comp_code=b.comp_code 
    --and b.user_code=@puserid
    and b.user_role=@pextra1  
    where a.comp_code=@pcompcode 
    and ( isnull(block_reason,'N')= @pblockunblock OR block_reason ='')
   

/////////////////////////next table script**********************


CREATE TABLE [dbo].[CIR_SUSPEND_TYPE_PERMISSION](
	[COMP_CODE] [varchar](20) NOT NULL,
	[UNIT_CODE] [varchar](20) NOT NULL,
	[BRANCH_CODE] [varchar](20) NULL,
	[USER_CODE] [varchar](10) NOT NULL,
	[SUSPEND_TYPE_CODE] [varchar](8) NOT NULL,
	[USER_FLAG] [varchar](1) NULL,
	[USER_ROLE] [varchar](10) NULL,
 CONSTRAINT [CIR_SUSPEND_TYPE_PERMISSION_PK] PRIMARY KEY CLUSTERED 
(
	[COMP_CODE] ASC,
	[UNIT_CODE] ASC,
	[SUSPEND_TYPE_CODE] ASC,
	[USER_CODE] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CIR_SUSPEND_TYPE_PERMISSION] ADD  DEFAULT ('N') FOR [USER_FLAG]



///////////////////////////////////////////////////////////////////////



create Procedure [dbo].[cir_suspend_type_wise_permission]
     @pcompcode           VARCHAR(20),
     @ppcenter            VARCHAR(20),
     @pbranch             VARCHAR(20),     
     @pdateformat         VARCHAR(20),
     @puserid             VARCHAR(20),
     @puserrole           VARCHAR(20),
     @psusp_type          VARCHAR(20),
     @pFlag               VARCHAR(20), -- Y / N 
     @pextra1             VARCHAR(200),
     @pextra2             VARCHAR(200),
     @pextra3             VARCHAR(200),
     @pextra4             VARCHAR(200),
     @pextra5             VARCHAR(200),
     @pextra6             VARCHAR(200),
     @pextra7             VARCHAR(200),
     @pextra8             VARCHAR(200),
     @pextra9             VARCHAR(200),
     @pextra10            VARCHAR(200)


  As
  begin
	declare @v_cnt as int
	declare @v1_userid as varchar(20)
    declare @v1_username as varchar(2000)
	
	DECLARE c1 cursor LOCAL FOR 
	   select userid,username from login where com_code=@pcompcode 
	   and roleid=@puserrole and (userid=isnull(@puserid,userid) or @puserid ='')
   
	OPEN c1 
	fetch NEXT FROM c1 INTO @v1_userid, @v1_username 
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
		
			select @v_cnt=count(*) from CIR_SUSPEND_TYPE_PERMISSION 
			where comp_code=@pcompcode and unit_code=@ppcenter and user_code=@v1_userid
			and SUSPEND_TYPE_CODE=isnull(@psusp_type,'N')
			
			if(@v_cnt>0)
			begin
				update CIR_SUSPEND_TYPE_PERMISSION set  [USER_FLAG]=isnull(@pFlag,'N')
				where comp_code=@pcompcode and unit_code=@ppcenter and user_code=@v1_userid
				and SUSPEND_TYPE_CODE=isnull(@psusp_type,'N')
			end
			else
			begin
				INSERT INTO CIR_SUSPEND_TYPE_PERMISSION ([COMP_CODE],[UNIT_CODE],[USER_CODE],[SUSPEND_TYPE_CODE],[USER_FLAG],[USER_ROLE])
								VALUES					(@pcompcode,@ppcenter,@v1_userid,isnull(@psusp_type,'N'),isnull(@pFlag,'N'),@puserrole )
			end

		fetch NEXT FROM c1 INTO @v1_userid, @v1_username
		END 
	close c1
	DEALLOCATE c1
	
	
		
	
  
  end
       
	

 
///////////////////////////////////////////////////end/////////////////////////////////////////////////////////////////


/////////////////////////////////add by deepika 27/09/2012////////////////////////////////////

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
	@preptype           as int,--1 for Agency Wise,2 for Main Edition wise,3 for District Taluka wise--4 for publication wise,5 for comm category wise, 6 for state wise,7 for branch wise,8 for zone wise,9 for route wise,10 for region wise
							   --11 route wise detailed,12 for main edition wise detailed
	@pbreak_on          as varchar(20),--Region R/State S/District D/Branch B / ZONE Z/ routewise O/ center C /PUBL  P / EDITION E / AREA A
	@preturn_based      as varchar(20),--it is use for return date or supply date(R/S)	
	@plangtype          as varchar(20),
	@pdateformat        as varchar(20),
	@pextra1            as varchar(50),--for zone
	@pextra2            as varchar(50),-- for region
	@pextra3            as varchar(50),--for commission
	@pextra4            as varchar(50),-- for publication type		
	@pcommper           as numeric(14,2), -- for commper 
	@pcomslab           as varchar(50), -- for commision less than or greater than  
	@psuptype           as varchar(50),-- for supply type
	@pcopy_amt          as varchar(10),-- for based on copy or amt / C for Copy and A for AMOUNT
		
	@pextra5            as varchar(50), -- for city code 
	@pextra6            as varchar(50), -- for area code
	@pextra7            as varchar(50),
	@pextra8            as varchar(50),
	@pextra9            as varchar(50),
	@pextra10            as varchar(50)
AS 
		
	DECLARE @v_hdays	AS	NUMERIC(5) 
	DECLARE @v_avg_sale AS  NUMERIC(10) 
	DECLARE @v_reg_code AS  varchar(200)
	DECLARE @v_zone_code varchar(200);
	DECLARE @v_publ_code varchar(200);
	DECLARE @v_route_code varchar(200);

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
    DECLARE @v1_route_code   		as varchar(50)
    DECLARE @v1_route_name			as varchar(150)
    DECLARE @v1_supply_copy			as int
    DECLARE @v1_return_copy			as int
    DECLARE @v1_net_sale_copy		as int
    DECLARE @v1_no_of_days			as int
    DECLARE @v1_unit_name			as varchar(150)
    DECLARE @v1_COM_CAT  			as varchar(150)
    declare @v1_supdate				as datetime
    DECLARE @v1_area_code   		as varchar(50)
    DECLARE @v1_area_name   		as varchar(500)


CREATE TABLE #CIR_DBKSUP_temp
(
	COMP_CODE varchar(8) NOT NULL,
	UNIT_CODE varchar(8) NOT NULL,
	PUBL varchar(3) NOT NULL,
	EDTN varchar(3) NOT NULL,
	AGCD varchar(8) NOT NULL,
	DPCD varchar(8) NOT NULL,
	SUPDATE datetime NOT NULL,
	SUP_TYPE_CODE varchar(5) NOT NULL,
	SUP_COPY numeric(10, 0) NULL,
	AGENCY_TY_CODE varchar(8) NULL,
	AGENCY_PKT_SIZE numeric(7, 0) NULL,
	COMM_CODE varchar(6) NULL,
	COMM_FIX_AUTO_SPL varchar(1) NULL,
	SUP_RATE numeric(10, 4) NULL,
	BILLAGCD varchar(8) NULL,
	BILLDPCD varchar(8) NULL,
	ROUTE_CODE varchar(5) NULL,
	SUBROUTE_CODE varchar(5) NULL,
	SUBSUBROUTE_CODE varchar(5) NULL,
	USERID varchar(10) NULL,
	CREATION_DATE datetime NULL,
	SURCH_CD varchar(5) NULL,
	ISSUE_DATE datetime NULL,
	RETURN_COPY_SALE varchar(1) NULL,
	FINAL_SUPPLY_FLAG varchar(1) NULL,
	UPDATED_BY varchar(30) NULL,
	UPDATED_DT datetime NULL,
	PER_COPY_WEIGHT numeric(15, 3) NULL,
	WASTE_CATG_CODE numeric(5, 0) NULL
)

	
	if @pcomslab ='G' 
	begin
		insert into #CIR_DBKSUP_temp(
		COMP_CODE,UNIT_CODE,PUBL,EDTN,AGCD,DPCD,SUPDATE,SUP_TYPE_CODE,SUP_COPY,AGENCY_TY_CODE,AGENCY_PKT_SIZE,
		COMM_CODE,COMM_FIX_AUTO_SPL,SUP_RATE,BILLAGCD,BILLDPCD,ROUTE_CODE,SUBROUTE_CODE,SUBSUBROUTE_CODE,
		USERID,CREATION_DATE,SURCH_CD,ISSUE_DATE,RETURN_COPY_SALE,FINAL_SUPPLY_FLAG,UPDATED_BY,UPDATED_DT,
		PER_COPY_WEIGHT,WASTE_CATG_CODE
		)
		select COMP_CODE,UNIT_CODE,PUBL,EDTN,AGCD,DPCD,SUPDATE,SUP_TYPE_CODE,SUP_COPY,AGENCY_TY_CODE,AGENCY_PKT_SIZE,
		COMM_CODE,COMM_FIX_AUTO_SPL,SUP_RATE,BILLAGCD,BILLDPCD,ROUTE_CODE,SUBROUTE_CODE,SUBSUBROUTE_CODE,
		USERID,CREATION_DATE,SURCH_CD,ISSUE_DATE,RETURN_COPY_SALE,FINAL_SUPPLY_FLAG,UPDATED_BY,UPDATED_DT,
		PER_COPY_WEIGHT,WASTE_CATG_CODE 
		from cir_dbksup b
		where b.comp_code =@pcomp_code 
		and (b.unit_code=@punit_code or @punit_code is null or @punit_code ='') 
		and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') 
		and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn='') 
		and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') 
		and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='')
		and b.supdate >= @pfromdate and b.supdate <=@ptilldate
		and (b.comm_code=@pextra3 or @pextra3 is null or @pextra3 ='')
		and (b.sup_type_code=@psuptype or @psuptype is null or @psuptype ='') 
		and ( cast(substring(cast(dbo.cir_get_commission(b.comp_code,b.unit_code,b.publ,b.edtn,b.COMM_FIX_AUTO_SPL,b.COMM_CODE,b.SUPDATE,@pdateformat,b.SUP_COPY,'','' ) as varchar),2,len(cast(dbo.cir_get_commission(b.comp_code,b.unit_code,b.publ,b.edtn,b.COMM_FIX_AUTO_SPL,b.COMM_CODE,b.SUPDATE,@pdateformat,b.SUP_COPY,'','' ) as varchar)) ) as numeric) > cast(@pcommper as numeric) or cast(@pcommper as numeric) is null or cast(@pcommper as numeric) = '0')
	end
	else
	begin
		insert into #CIR_DBKSUP_temp(
		COMP_CODE,UNIT_CODE,PUBL,EDTN,AGCD,DPCD,SUPDATE,SUP_TYPE_CODE,SUP_COPY,AGENCY_TY_CODE,AGENCY_PKT_SIZE,
		COMM_CODE,COMM_FIX_AUTO_SPL,SUP_RATE,BILLAGCD,BILLDPCD,ROUTE_CODE,SUBROUTE_CODE,SUBSUBROUTE_CODE,
		USERID,CREATION_DATE,SURCH_CD,ISSUE_DATE,RETURN_COPY_SALE,FINAL_SUPPLY_FLAG,UPDATED_BY,UPDATED_DT,
		PER_COPY_WEIGHT,WASTE_CATG_CODE
		)
		select COMP_CODE,UNIT_CODE,PUBL,EDTN,AGCD,DPCD,SUPDATE,SUP_TYPE_CODE,SUP_COPY,AGENCY_TY_CODE,AGENCY_PKT_SIZE,
		COMM_CODE,COMM_FIX_AUTO_SPL,SUP_RATE,BILLAGCD,BILLDPCD,ROUTE_CODE,SUBROUTE_CODE,SUBSUBROUTE_CODE,
		USERID,CREATION_DATE,SURCH_CD,ISSUE_DATE,RETURN_COPY_SALE,FINAL_SUPPLY_FLAG,UPDATED_BY,UPDATED_DT,
		PER_COPY_WEIGHT,WASTE_CATG_CODE 
		from cir_dbksup b
		where b.comp_code =@pcomp_code 
		and (b.unit_code=@punit_code or @punit_code is null or @punit_code ='') 
		and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') 
		and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn='') 
		and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') 
		and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='')
		and b.supdate >= @pfromdate and b.supdate <=@ptilldate
		and (b.comm_code=@pextra3 or @pextra3 is null or @pextra3 ='')
		and (b.sup_type_code=@psuptype or @psuptype is null or @psuptype ='') 
		and ( cast(substring(cast(dbo.cir_get_commission(b.comp_code,b.unit_code,b.publ,b.edtn,b.COMM_FIX_AUTO_SPL,b.COMM_CODE,b.SUPDATE,@pdateformat,b.SUP_COPY,'','' ) as varchar),2,len(cast(dbo.cir_get_commission(b.comp_code,b.unit_code,b.publ,b.edtn,b.COMM_FIX_AUTO_SPL,b.COMM_CODE,b.SUPDATE,@pdateformat,b.SUP_COPY,'','' ) as varchar)) ) as numeric) < cast(@pcommper as numeric) or cast(@pcommper as numeric) is null or cast(@pcommper as numeric) = '0')
	end
	
	if @pcopy_amt ='C' begin	
		DECLARE c1 cursor LOCAL FOR 
		select u.comp_code,u.unit_code,
		u.branch_code branch_code,(select distinct Branch_Name from branch_mst where Branch_Code=u.branch_code) branch_name,
		u.publ,u.publ_name,u.main_edtn,
		dbo.cir_get_edtn_name(u.comp_code,u.main_edtn) main_edtn_name,u.edtn edtn,u.edtn_name,u.copy_rate,
		u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,
		u.state_code,dbo.cir_get_state(u.comp_code,u.country_code,u.state_code) state_name,
		u.dist_code ,dbo.cir_get_name_cir_district(u.comp_code,u.dist_code,@plangtype,null,null,null) dist_name,
		u.city_code city_code,dbo.cir_get_name_cir_city(u.comp_code,u.city_code,@plangtype,null,null,null) city_name,
		u.tehsil_taluka,dbo.cir_get_name_cir_taluka(u.comp_code,u.tehsil_taluka,@plangtype,null,null,null) taluka_name,
		u.route_code,dbo.cir_get_route_name(u.comp_code,u.unit_code,u.route_code ) route_name,
		sum(supply_copy) supply_copy,sum(return_copy) return_copy,
		sum(supply_copy)-sum(return_copy) net_sale_copy,sum(no_of_days) no_of_days
		,dbo.cir_get_unit_name(u.comp_code,u.unit_code) as UNIT_NAME
		,u.comm_cat as COM_CAT,u.area_code AREA_CODE
		from (
		select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate copy_rate,
		b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
		a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka, b.route_code, 
		sum(isnull(b.sup_copy,0)) supply_copy,0 return_copy, count(distinct supdate) no_of_days
		,b.comm_code comm_cat,a.area_code
		--from cir_agmast a,cir_dbksup b,cir_edtn_mast e,cir_publ_mast p
		from cir_agmast a,#CIR_DBKSUP_temp b,cir_edtn_mast e,cir_publ_mast p		
		where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and 
		b.comp_code =@pcomp_code and 
		b.unit_code=a.unit and (b.unit_code=@punit_code or @punit_code is null or @punit_code ='') and 
		b.publ=p.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and b.edtn=e.edtn and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn='') and
		a.agcd=b.agcd and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') and a.dpcd=b.dpcd and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='') and
		b.supdate >= @pfromdate and b.supdate <=@ptilldate and 
		(a.ag_type=@pagency_type or @pagency_type is null or @pagency_type='') and(a.ag_class=@pagency_class or @pagency_class is null or @pagency_class='') and
		(a.branch_code=@pbranch or @pbranch is null or @pbranch='') and (a.state_code=@pstatecode or @pstatecode is null or @pstatecode='') and
		(a.dist_code=@pdistcode or @pdistcode is null or @pdistcode='') and (a.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka='') and
		(e.main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')
		and (b.comm_code=@pextra3 or @pextra3 is null or @pextra3 ='')
		and (a.city_code=@pextra5 or @pextra5 is null or @pextra5 ='')
		and (a.area_code=@pextra6 or @pextra6 is null or @pextra6 ='')
		and (p.pro_type=@pextra4 or @pextra4 is null or @pextra4 ='')
		and (b.sup_type_code=@psuptype or @psuptype is null or @psuptype ='')    
		and (dbo.cir_get_zone_by_city(a.comp_code,a.city_code,'C')=@pextra1 or @pextra1 is null or @pextra1 ='')
		and (dbo.cir_get_region_by_city(a.comp_code,a.city_code,'C')=@pextra2 or @pextra2 is null or @pextra2 ='')
		group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate,
		b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
		a.country_code,a.tehsil_taluka,b.route_code,b.comm_code,a.area_code
		union all
		select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
		b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
		a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka,d.route_code,  
		0 supply_copy,sum(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0)) return_copy,0 no_of_days
		,d.comm_code comm_cat,a.area_code
		from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e,cir_publ_mast p,cir_dbksup d
		where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and b.comp_code =@pcomp_code and 
		b.unit_code=a.unit and (b.unit_code=@punit_code or @punit_code is null or @punit_code ='') and  
		b.doctype='UCN' and ((b.recptdt >= @pfromdate and b.recptdt <=@ptilldate and isnull(@preturn_based,'R') ='R') or (b.supdate >= @pfromdate and b.supdate <=@ptilldate and isnull(@preturn_based,'R') ='S')) and 
		b.publ=d.publ and b.edtn=d.edtn and a.agcd=d.agcd and a.dpcd=d.dpcd and
		b.publ=e.publ and b.publ=p.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and b.edtn=e.edtn and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn='') and 
		a.agcd=b.agcd and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') and a.dpcd=b.dpcd and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='') and
		(a.ag_type=@pagency_type or @pagency_type is null or @pagency_type='') and(a.ag_class=@pagency_class or @pagency_class is null or @pagency_class='') and
		(a.branch_code=@pbranch or @pbranch is null or @pbranch='') and (a.state_code=@pstatecode or @pstatecode is null or @pstatecode='') and
		(a.dist_code=@pdistcode or @pdistcode is null or @pdistcode='') and (a.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka='') and
		(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and
		(e.main_edtn=@pmainedtn or @pmainedtn is null)
		and (d.comm_code=@pextra3 or @pextra3 is null or @pextra3 ='')
		and (a.city_code=@pextra5 or @pextra5 is null or @pextra5 ='')
		and (a.area_code=@pextra6 or @pextra6 is null or @pextra6 ='')
		and (p.pro_type=@pextra4 or @pextra4 is null or @pextra4 ='')
		and (d.sup_type_code=@psuptype or @psuptype is null or @psuptype ='')
		and (dbo.cir_get_zone_by_city(a.comp_code,a.city_code,'C')=@pextra1 or @pextra1 is null or @pextra1 ='')
		and (dbo.cir_get_region_by_city(a.comp_code,a.city_code,'C')=@pextra2 or @pextra2 is null or @pextra2 ='')
		group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
		b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
		a.country_code,a.tehsil_taluka,d.route_code ,d.comm_code,a.area_code) u
		where (u.supply_copy+u.return_copy)>0
		group by u.comp_code,u.unit_code,u.branch_code,u.publ,u.publ_name,u.main_edtn,u.edtn,u.edtn_name,u.copy_rate,
		u.agcd,u.dpcd,u.agname,u.agname_oth_lang,u.state_code,u.dist_code ,u.city_code,u.tehsil_taluka,u.route_code,u.country_code,u.comm_cat,u.area_code; 
	end
	else
	begin
		DECLARE c1 cursor LOCAL FOR 
		select u.comp_code,u.unit_code,
		u.branch_code branch_code,(select distinct Branch_Name from branch_mst where Branch_Code=u.branch_code) branch_name,
		u.publ,u.publ_name,u.main_edtn,
		dbo.cir_get_edtn_name(u.comp_code,u.main_edtn) main_edtn_name,u.edtn edtn,u.edtn_name,u.copy_rate,
		u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,
		u.state_code,dbo.cir_get_state(u.comp_code,u.country_code,u.state_code) state_name,
		u.dist_code ,dbo.cir_get_name_cir_district(u.comp_code,u.dist_code,@plangtype,null,null,null) dist_name,
		u.city_code city_code,dbo.cir_get_name_cir_city(u.comp_code,u.city_code,@plangtype,null,null,null) city_name,
		u.tehsil_taluka,dbo.cir_get_name_cir_taluka(u.comp_code,u.tehsil_taluka,@plangtype,null,null,null) taluka_name,
		u.route_code,dbo.cir_get_route_name(u.comp_code,u.unit_code,u.route_code ) route_name,
		(sum(supply_copy)* u.copy_rate) supply_copy,(sum(return_copy)* u.copy_rate) return_copy,
		(sum(supply_copy)* u.copy_rate)-(sum(return_copy)* u.copy_rate) net_sale_copy,sum(no_of_days) no_of_days
		,dbo.cir_get_unit_name(u.comp_code,u.unit_code) as UNIT_NAME
		,u.comm_cat as COM_CAT,u.area_code as AREA_CODE
		from (
		select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate copy_rate,
		b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
		a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka, b.route_code, 
		sum(isnull(b.sup_copy,0)) supply_copy,0 return_copy, count(distinct supdate) no_of_days
		,b.comm_code comm_cat,a.area_code
		--from cir_agmast a,cir_dbksup b,cir_edtn_mast e,cir_publ_mast p
		from cir_agmast a,#CIR_DBKSUP_temp b,cir_edtn_mast e,cir_publ_mast p
		where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and 
		b.comp_code =@pcomp_code and 
		b.unit_code=a.unit and (b.unit_code=@punit_code or @punit_code is null or @punit_code ='') and 
		b.publ=p.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and b.edtn=e.edtn and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn='') and
		a.agcd=b.agcd and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') and a.dpcd=b.dpcd and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='') and
		b.supdate >= @pfromdate and b.supdate <=@ptilldate and 
		(a.ag_type=@pagency_type or @pagency_type is null or @pagency_type='') and(a.ag_class=@pagency_class or @pagency_class is null or @pagency_class='') and
		(a.branch_code=@pbranch or @pbranch is null or @pbranch='') and (a.state_code=@pstatecode or @pstatecode is null or @pstatecode='') and
		(a.dist_code=@pdistcode or @pdistcode is null or @pdistcode='') and (a.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka='') and
		(e.main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')
		and (b.comm_code=@pextra3 or @pextra3 is null or @pextra3 ='')
		and (a.city_code=@pextra5 or @pextra5 is null or @pextra5 ='')
		and (a.area_code=@pextra6 or @pextra6 is null or @pextra6 ='')
		and (p.pro_type=@pextra4 or @pextra4 is null or @pextra4 ='')
		and (b.sup_type_code=@psuptype or @psuptype is null or @psuptype ='')    
		and (dbo.cir_get_zone_by_city(a.comp_code,a.city_code,'C')=@pextra1 or @pextra1 is null or @pextra1 ='')
		and (dbo.cir_get_region_by_city(a.comp_code,a.city_code,'C')=@pextra2 or @pextra2 is null or @pextra2 ='')
		group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate,
		b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
		a.country_code,a.tehsil_taluka,b.route_code,b.comm_code,a.area_code
		union all
		select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
		b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
		a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka,d.route_code,  
		0 supply_copy,sum(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0)) return_copy,0 no_of_days
		,d.comm_code comm_cat,a.area_code
		from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e,cir_publ_mast p,cir_dbksup d
		where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and b.comp_code =@pcomp_code and 
		b.unit_code=a.unit and (b.unit_code=@punit_code or @punit_code is null or @punit_code ='') and  
		b.doctype='UCN' and ((b.recptdt >= @pfromdate and b.recptdt <=@ptilldate and isnull(@preturn_based,'R') ='R') or (b.supdate >= @pfromdate and b.supdate <=@ptilldate and isnull(@preturn_based,'R') ='S')) and 
		b.publ=d.publ and b.edtn=d.edtn and a.agcd=d.agcd and a.dpcd=d.dpcd and
		b.publ=e.publ and b.publ=p.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and b.edtn=e.edtn and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn='') and 
		a.agcd=b.agcd and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') and a.dpcd=b.dpcd and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='') and
		(a.ag_type=@pagency_type or @pagency_type is null or @pagency_type='') and(a.ag_class=@pagency_class or @pagency_class is null or @pagency_class='') and
		(a.branch_code=@pbranch or @pbranch is null or @pbranch='') and (a.state_code=@pstatecode or @pstatecode is null or @pstatecode='') and
		(a.dist_code=@pdistcode or @pdistcode is null or @pdistcode='') and (a.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka='') and
		(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and
		(e.main_edtn=@pmainedtn or @pmainedtn is null)
		and (d.comm_code=@pextra3 or @pextra3 is null or @pextra3 ='')
		and (a.city_code=@pextra5 or @pextra5 is null or @pextra5 ='')
		and (a.area_code=@pextra6 or @pextra6 is null or @pextra6 ='')
		and (p.pro_type=@pextra4 or @pextra4 is null or @pextra4 ='')
		and (d.sup_type_code=@psuptype or @psuptype is null or @psuptype ='')
		and (dbo.cir_get_zone_by_city(a.comp_code,a.city_code,'C')=@pextra1 or @pextra1 is null or @pextra1 ='')
		and (dbo.cir_get_region_by_city(a.comp_code,a.city_code,'C')=@pextra2 or @pextra2 is null or @pextra2 ='')
		group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
		b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
		a.country_code,a.tehsil_taluka,d.route_code ,d.comm_code,a.area_code) u
		where (u.supply_copy+u.return_copy)>0
		group by u.comp_code,u.unit_code,u.branch_code,u.publ,u.publ_name,u.main_edtn,u.edtn,u.edtn_name,u.copy_rate,
		u.agcd,u.dpcd,u.agname,u.agname_oth_lang,u.state_code,u.dist_code ,u.city_code,u.tehsil_taluka,u.route_code,u.country_code,u.comm_cat,a.area_code; 
	end
	
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
	  REGION          VARCHAR(500),
	  RET_COMM_AMT     NUMERIC(15,2),
	  BILL_SEC_AMT     NUMERIC(15,2),
	  SEC_OPBAL        NUMERIC(15,2),
	  zone_code        VARCHAR(200),
	  region_code        VARCHAR(200),
	  pro_type        VARCHAR(200),
	  route_code      VARCHAR(200),
	  copy_rate			numeric(14,2),
	  no_of_days		numeric(10),
	  unit_name			varchar(150),
	  COM_CAT           varchar(150),
	  supdate           datetime,
	  area_code      VARCHAR(200),
	  area_name      VARCHAR(500)
	  )
		
		
		OPEN c1 
        fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code, @v1_branch_code, @v1_branch_name,@v1_publ, @v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,@v1_edtn,@v1_edtn_name,@v1_copy_rate, @v1_agcd, @v1_dpcd,@v1_agname,@v1_agname_oth_lang,@v1_state_code,@v1_state_name,@v1_dist_code,@v1_dist_name,@v1_city_code,@v1_city_name, @v1_tehsil_taluka,@v1_taluka_name,@v1_route_code,@v1_route_name,@v1_supply_copy,@v1_return_copy,@v1_net_sale_copy, @v1_no_of_days,@v1_unit_name,@v1_COM_CAT,@v1_area_code
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN 
		
             
   
			If isnull(@v1_no_of_days,0)>0 Begin
                set @v_avg_sale=round(isnull(@v1_net_sale_copy,0)/(isnull(@v1_no_of_days,0)),0)
            End    
            Else Begin
                set @v_avg_sale=isnull(@v1_net_sale_copy,0)
            End

            select distinct @v_reg_code=region_code,@v_zone_code=zone_code from cir_city_mast where comp_code=@v1_comp_code and city_code=@v1_city_code            
            if(@v_reg_code='')
            begin
				set @v_reg_code=null
            end
           
            if(@v_zone_code='')
            begin
				set @v_zone_code=null
            end
            
            select distinct @v_publ_code=pro_type from cir_publ_mast where comp_code=@v1_comp_code and publ=@v1_publ;
            if(@v_publ_code='')
            begin
				set @v_publ_code=null
            end
            
            select distinct @v1_COM_CAT=COMM_CATG_DESC from CIR_COMM_CATG_MAST where comp_code=@v1_comp_code and COMM_CATG_CODE=@v1_COM_CAT            
            if(@v1_COM_CAT='')
            begin
				set @v1_COM_CAT=null
            end
            
            
            set @v_reg_code=dbo.cir_get_region_name(@v1_comp_code,@v_reg_code)
            set @v_zone_code=dbo.cir_get_zone_name(@v1_comp_code, @v_zone_code); 
			set @v_publ_code=dbo.cir_publ_type(@v1_comp_code,@v_publ_code,null,null);
			set @v1_area_name=dbo.cir_get_area(@v1_comp_code,@v1_area_code)
            
            insert into #cir_temp_bill_collection
				(comp_code, unit_code, billno, publ_code, agcd, dpcd,agname,agname_oth_lang, city_code, 
				taluka_code, dist_code, state_code, REGION,supply_copy, return_copy ,copy_rate,no_of_days,zone_code, region_code,pro_type,route_code
				,unit_name,COM_CAT,area_code,area_name)
            values(@v1_comp_code,@v1_unit_code,@v1_branch_name,@v1_publ_name,@v1_main_edtn_name,@v1_edtn_name,@v1_agname,@v1_agname_oth_lang,@v1_city_name,
				@v1_taluka_name,@v1_dist_name,@v1_state_name,@v_reg_code,@v1_supply_copy,@v1_return_copy,@v1_copy_rate,@v1_no_of_days,@v_zone_code,@v_reg_code,@v_publ_code,@v1_route_name
				,@v1_unit_name,@v1_COM_CAT,@v1_area_code,@v1_area_name)
            
		    fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code, @v1_branch_code, @v1_branch_name,@v1_publ, @v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,@v1_edtn,@v1_edtn_name,@v1_copy_rate, @v1_agcd, @v1_dpcd,@v1_agname,@v1_agname_oth_lang,@v1_state_code,@v1_state_name,@v1_dist_code,@v1_dist_name,@v1_city_code,@v1_city_name, @v1_tehsil_taluka,@v1_taluka_name,@v1_route_code,@v1_route_name,@v1_supply_copy,@v1_return_copy,@v1_net_sale_copy, @v1_no_of_days,@v1_unit_name,@v1_COM_CAT,@v1_area_code
		
		END 
		close c1
		DEALLOCATE c1
--------------  start for report type 1 AGENCY WISE 		
        if @preptype=1 Begin
            if @pbreak_on='R' Begin -- region wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,agname AS AGNAME,agname_oth_lang AS AGNAME_OTH_LANG,city_code as CITY_NAME, 
                region AS REGION_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection order by region,agname,city_name,copy_rate

                select comp_code AS COMP_CODE,  
                region AS REGION_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection
                group by comp_code,region order by region_name
			End       
            else if @pbreak_on='S' Begin  -- state wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,agname AS AGNAME,agname_oth_lang AS AGNAME_OTH_LANG,city_code as CITY_NAME, 
                state_code AS STATE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection
                order by state_name,agname,city_name,copy_rate;

                select comp_code AS COMP_CODE,  
                state_code AS STATE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE
                from #cir_temp_bill_collection 
                group by comp_code,state_code order by state_name
            End    
            Else if @pbreak_on='D' Begin -- district wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,agname AS AGNAME,agname_oth_lang AS AGNAME_OTH_LANG,city_code as CITY_NAME, 
                state_code AS STATE_NAME,dist_code AS DIST_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by state_name,dist_name,agname,city_name,copy_rate;

                select comp_code AS COMP_CODE,  
                state_code AS STATE_NAME,dist_code AS DIST_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,state_code,dist_code order by state_name,dist_name;
            End             
            else if @pbreak_on='Z' begin  ---ZONE WISE
                select comp_code AS COMP_CODE, unit_code AS UNIT,agname AS AGNAME,agname_oth_lang AS AGNAME_OTH_LANG,city_code as CITY_NAME, 
                state_code AS STATE_NAME,dist_code AS DIST_NAME,zone_code as ZONE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 
                then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,
                case when isnull(no_of_days,0)>0 
                then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by zone_name,agname,city_name,copy_rate;

                select comp_code AS COMP_CODE,  
                zone_code as ZONE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,zone_code order by zone_name
            end
            else if @pbreak_on='C' begin  ---CENTER WISE
                
                select comp_code AS COMP_CODE, unit_code AS UNIT,agname AS AGNAME,agname_oth_lang AS AGNAME_OTH_LANG,city_code as CITY_NAME, 
                state_code AS STATE_NAME,dist_code AS DIST_NAME
                ,unit_name as UNIT_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by UNIT_NAME,agname,city_name,copy_rate;
                
                select comp_code AS COMP_CODE,  
                UNIT_NAME as UNIT_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,UNIT_NAME order by UNIT_NAME;
			end
			else if @pbreak_on='P' begin  ---PUBLICATION WISE
                
                select comp_code AS COMP_CODE, unit_code AS UNIT,agname AS AGNAME,agname_oth_lang AS AGNAME_OTH_LANG,city_code as CITY_NAME, 
                state_code AS STATE_NAME,dist_code AS DIST_NAME,publ_code AS PUBL_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection  order by publ_name,agname,city_name,copy_rate;
                
                select comp_code AS COMP_CODE,  
                publ_code AS PUBL_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,publ_code order by publ_name;
            end
			else if @pbreak_on='O' begin  --- ROUTE WISE
                select comp_code AS COMP_CODE, unit_code AS UNIT,agname AS AGNAME,agname_oth_lang AS AGNAME_OTH_LANG,city_code as CITY_NAME, 
                state_code AS STATE_NAME,dist_code AS DIST_NAME,route_code as ROUTE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection --order by state_name,dist_name,agname,city_name,copy_rate,route_name;
                order by route_name,agname,city_name,copy_rate;

                select comp_code AS COMP_CODE,  
                route_code as ROUTE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,route_code order by route_name ;
             end
            else if @pbreak_on='B' Begin  ---  Branch Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,agname AS AGNAME,agname_oth_lang AS AGNAME_OTH_LANG,city_code as CITY_NAME, 
                billno AS BRANCH_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by branch_name,agname,city_name,copy_rate;

                select comp_code AS COMP_CODE,  
                billno AS BRANCH_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,billno order by branch_name;   
             End
             else if @pbreak_on='E' Begin  ---  Edition Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,agname AS AGNAME,agname_oth_lang AS AGNAME_OTH_LANG,city_code as CITY_NAME, 
                agcd AS MAIN_EDTN,dpcd AS SUB_EDTN,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by AGCD,dpcd,agname,city_name,copy_rate;

                select comp_code AS COMP_CODE,  
                agcd AS MAIN_EDTN,dpcd AS SUB_EDTN,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,agcd,dpcd order by agcd,dpcd;   
             End 
             else if @pbreak_on='A' Begin  ---  Area Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,agname AS AGNAME,agname_oth_lang AS AGNAME_OTH_LANG,city_code as CITY_NAME, 
                area_code AS AREA_CODE,area_name AS AREA_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by area_name,agname,city_name,copy_rate;

                select comp_code AS COMP_CODE,  
                area_code AS AREA_CODE,area_name AS AREA_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,area_code,area_name order by area_name;   
             End   
            End
-------------------   end here for agency wise -------------------------
        Else if @preptype=2 Begin--for edition wise
             if @pbreak_on='R' Begin -- region wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,publ_code AS PUBL_NAME,agcd AS MAIN_EDTN_NAME,dpcd AS EDTN_NAME, 
                region AS REGION_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection order by region,publ_code,agcd,copy_rate

                select comp_code AS COMP_CODE,  
                region AS REGION_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection
                group by comp_code,region order by region_name
			End       
            else if @pbreak_on='S' Begin  -- state wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,publ_code AS PUBL_NAME,agcd AS MAIN_EDTN_NAME,dpcd AS EDTN_NAME, 
                state_code AS STATE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection
                order by state_name,publ_code,agcd,copy_rate;

                select comp_code AS COMP_CODE,  
                state_code AS STATE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE
                from #cir_temp_bill_collection 
                group by comp_code,state_code order by state_name
            End    
            Else if @pbreak_on='D' Begin -- district wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,publ_code AS PUBL_NAME,agcd AS MAIN_EDTN_NAME,dpcd AS EDTN_NAME,  
                state_code AS STATE_NAME,dist_code AS DIST_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by state_name,dist_code,publ_code,agcd,copy_rate;

                select comp_code AS COMP_CODE,  
                state_code AS STATE_NAME,dist_code AS DIST_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,state_code,dist_code order by state_name,dist_name;
            End             
            else if @pbreak_on='Z' begin  ---ZONE WISE
                select comp_code AS COMP_CODE, unit_code AS UNIT,publ_code AS PUBL_NAME,agcd AS MAIN_EDTN_NAME,dpcd AS EDTN_NAME,  
                state_code AS STATE_NAME,dist_code AS DIST_NAME,zone_code as ZONE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 
                then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,
                case when isnull(no_of_days,0)>0 
                then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by zone_name,publ_code,agcd,copy_rate;

                select comp_code AS COMP_CODE,  
                zone_code as ZONE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,zone_code order by zone_name
            end
            else if @pbreak_on='C' begin  ---CENTER WISE
                
                select comp_code AS COMP_CODE, unit_code AS UNIT,publ_code AS PUBL_NAME,agcd AS MAIN_EDTN_NAME,dpcd AS EDTN_NAME,  
                state_code AS STATE_NAME,dist_code AS DIST_NAME
                ,unit_name as UNIT_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by unit_name,publ_code,agcd,copy_rate;
                
                select comp_code AS COMP_CODE,  
                UNIT_NAME as UNIT_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,UNIT_NAME order by UNIT_NAME;
			end
			else if @pbreak_on='P' begin  ---PUBLICATION WISE
                
                select comp_code AS COMP_CODE, unit_code AS UNIT,publ_code AS PUBL_NAME,agcd AS MAIN_EDTN_NAME,dpcd AS EDTN_NAME, 
                state_code AS STATE_NAME,dist_code AS DIST_NAME,publ_code AS PUBL_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection  order by publ_code,agcd,copy_rate;
                
                select comp_code AS COMP_CODE,  
                publ_code AS PUBL_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,publ_code order by publ_name;
            end
			else if @pbreak_on='O' begin  --- ROUTE WISE
                select comp_code AS COMP_CODE, unit_code AS UNIT,publ_code AS PUBL_NAME,agcd AS MAIN_EDTN_NAME,dpcd AS EDTN_NAME,  
                state_code AS STATE_NAME,dist_code AS DIST_NAME,route_code as ROUTE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection 
                order by route_name,publ_code,agcd,copy_rate;

                select comp_code AS COMP_CODE,  
                route_code as ROUTE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,route_code order by route_name ;
             end
            else if @pbreak_on='B' Begin  ---  Branch Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,publ_code AS PUBL_NAME,agcd AS MAIN_EDTN_NAME,dpcd AS EDTN_NAME, 
                billno AS BRANCH_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by branch_name,publ_code,agcd,copy_rate;

                select comp_code AS COMP_CODE,  
                billno AS BRANCH_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,billno order by branch_name;   
             End 
             else if @pbreak_on='E' Begin  ---  Edition Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,publ_code AS PUBL_NAME, 
                agcd AS MAIN_EDTN,dpcd AS SUB_EDTN,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by AGCD,dpcd,publ_code,copy_rate;

                select comp_code AS COMP_CODE,  
                agcd AS MAIN_EDTN,dpcd AS SUB_EDTN,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,agcd,dpcd order by agcd,dpcd;   
             End
             else if @pbreak_on='A' Begin  ---  Area Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,publ_code AS PUBL_NAME, 
                area_code AS AREA_CODE,area_name AS AREA_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by area_name,publ_code,copy_rate;

                select comp_code AS COMP_CODE,  
                area_code AS AREA_CODE,area_name AS AREA_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,area_code,area_name order by area_name;   
             End  
		End                
         Else if @preptype=3 Begin--for district taluka wise
            if @pbreak_on='R' Begin -- region wise
                select comp_code AS COMP_CODE, unit_code AS UNIT
                ,state_code AS STATE_NAME,dist_code AS DIST_NAME,taluka_code AS TALUKA_NAME,
                region AS REGION_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection order by region,dist_code,taluka_code,copy_rate

                select comp_code AS COMP_CODE,  
                region AS REGION_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection
                group by comp_code,region order by region_name
			End       
            else if @pbreak_on='S' Begin  -- state wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,taluka_code AS TALUKA_NAME,
                state_code AS STATE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection
                order by state_code,dist_code,taluka_code,copy_rate

                select comp_code AS COMP_CODE,  
                state_code AS STATE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE
                from #cir_temp_bill_collection 
                group by comp_code,state_code order by state_name
            End    
            Else if @pbreak_on='D' Begin -- district wise
                select comp_code AS COMP_CODE, unit_code AS UNIT
                ,state_code AS STATE_NAME,dist_code AS DIST_NAME,taluka_code AS TALUKA_NAME,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by dist_code,taluka_code,copy_rate

                select comp_code AS COMP_CODE,  
                state_code AS STATE_NAME,dist_code AS DIST_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,state_code,dist_code order by state_name,dist_name;
            End             
            else if @pbreak_on='Z' begin  ---ZONE WISE
                select comp_code AS COMP_CODE, unit_code AS UNIT,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,taluka_code AS TALUKA_NAME,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,zone_code as ZONE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 
                then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,
                case when isnull(no_of_days,0)>0 
                then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by zone_name,dist_code,taluka_code,copy_rate

                select comp_code AS COMP_CODE,  
                zone_code as ZONE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,zone_code order by zone_name
            end
            else if @pbreak_on='C' begin  ---CENTER WISE
                
                select comp_code AS COMP_CODE, unit_code AS UNIT,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,taluka_code AS TALUKA_NAME,
                unit_name as UNIT_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by unit_name,dist_code,taluka_code,copy_rate
                
                select comp_code AS COMP_CODE,  
                UNIT_NAME as UNIT_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,UNIT_NAME order by UNIT_NAME;
			end
			else if @pbreak_on='P' begin  ---PUBLICATION WISE
                
                select comp_code AS COMP_CODE, unit_code AS UNIT,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,taluka_code AS TALUKA_NAME,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,publ_code AS PUBL_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection  order by publ_code,dist_code,taluka_code,copy_rate
                
                select comp_code AS COMP_CODE,  
                publ_code AS PUBL_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,publ_code order by publ_name;
            end
			else if @pbreak_on='O' begin  --- ROUTE WISE
                select comp_code AS COMP_CODE, unit_code AS UNIT,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,taluka_code AS TALUKA_NAME,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,route_code as ROUTE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection 
                order by route_name,dist_code,taluka_code,copy_rate;

                select comp_code AS COMP_CODE,  
                route_code as ROUTE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,route_code order by route_name ;
             end
            else if @pbreak_on='B' Begin  ---  Branch Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,taluka_code AS TALUKA_NAME,
                billno AS BRANCH_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by branch_name,dist_code,taluka_code,copy_rate

                select comp_code AS COMP_CODE,  
                billno AS BRANCH_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,billno order by branch_name;   
             End 
             else if @pbreak_on='E' Begin  ---  Edition Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,state_code AS STATE_NAME,dist_code AS DIST_NAME,taluka_code AS TALUKA_NAME, 
                agcd AS MAIN_EDTN,dpcd AS SUB_EDTN,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by AGCD,dpcd,dist_code,taluka_code,copy_rate

                select comp_code AS COMP_CODE,  
                agcd AS MAIN_EDTN,dpcd AS SUB_EDTN,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,agcd,dpcd order by agcd,dpcd;   
             End 
             else if @pbreak_on='A' Begin  ---  Area Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,state_code AS STATE_NAME,dist_code AS DIST_NAME,taluka_code AS TALUKA_NAME, 
                area_code AS AREA_CODE,area_name AS AREA_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by area_name,dist_code,taluka_code,copy_rate

                select comp_code AS COMP_CODE,  
                area_code AS AREA_CODE,area_name AS AREA_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,area_code,area_name order by area_name;  
             End 
        End
        Else if @preptype=4 Begin--for publication wise
            
            if @pbreak_on='R' Begin -- region wise
                select comp_code AS COMP_CODE, unit_code AS UNIT
                ,publ_code AS PUBL_NAME,agcd AS MAIN_EDTN_NAME,dpcd AS EDTN_NAME,
                region AS REGION_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection order by region,publ_code,agcd,dpcd,copy_rate

                select comp_code AS COMP_CODE,  
                region AS REGION_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection
                group by comp_code,region order by region_name
			End       
            else if @pbreak_on='S' Begin  -- state wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,
                publ_code AS PUBL_NAME,agcd AS MAIN_EDTN_NAME,dpcd AS EDTN_NAME,
                state_code AS STATE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection
                order by state_code,publ_code,agcd,dpcd,copy_rate

                select comp_code AS COMP_CODE,  
                state_code AS STATE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE
                from #cir_temp_bill_collection 
                group by comp_code,state_code order by state_name
            End    
            Else if @pbreak_on='D' Begin -- district wise
                select comp_code AS COMP_CODE, unit_code AS UNIT
                ,publ_code AS PUBL_NAME,agcd AS MAIN_EDTN_NAME,dpcd AS EDTN_NAME,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by dist_code,publ_code,agcd,dpcd,copy_rate

                select comp_code AS COMP_CODE,  
                state_code AS STATE_NAME,dist_code AS DIST_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,state_code,dist_code order by state_name,dist_name;
            End             
            else if @pbreak_on='Z' begin  ---ZONE WISE
                select comp_code AS COMP_CODE, unit_code AS UNIT,
                publ_code AS PUBL_NAME,agcd AS MAIN_EDTN_NAME,dpcd AS EDTN_NAME,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,zone_code as ZONE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 
                then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,
                case when isnull(no_of_days,0)>0 
                then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by zone_name,publ_code,agcd,dpcd,copy_rate

                select comp_code AS COMP_CODE,  
                zone_code as ZONE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,zone_code order by zone_name
            end
            else if @pbreak_on='C' begin  ---CENTER WISE
                
                select comp_code AS COMP_CODE, unit_code AS UNIT,
                publ_code AS PUBL_NAME,agcd AS MAIN_EDTN_NAME,dpcd AS EDTN_NAME,
                 unit_name as UNIT_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by unit_name,publ_code,agcd,dpcd,copy_rate
                
                select comp_code AS COMP_CODE,  
                UNIT_NAME as UNIT_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,UNIT_NAME order by UNIT_NAME;
			end
			else if @pbreak_on='P' begin  ---PUBLICATION WISE
                
                select comp_code AS COMP_CODE, unit_code AS UNIT,
                publ_code AS PUBL_NAME,agcd AS MAIN_EDTN_NAME,dpcd AS EDTN_NAME,
                publ_code AS PUBL_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection  order by publ_code,agcd,dpcd,copy_rate
                
                select comp_code AS COMP_CODE,  
                publ_code AS PUBL_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,publ_code order by publ_name;
            end
			else if @pbreak_on='O' begin  --- ROUTE WISE
                select comp_code AS COMP_CODE, unit_code AS UNIT,
                publ_code AS PUBL_NAME,agcd AS MAIN_EDTN_NAME,dpcd AS EDTN_NAME,
                route_code as ROUTE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection 
                order by route_name,publ_code,agcd,dpcd,copy_rate

                select comp_code AS COMP_CODE,  
                route_code as ROUTE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,route_code order by route_name ;
             end
            else if @pbreak_on='B' Begin  ---  Branch Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,
                publ_code AS PUBL_NAME,agcd AS MAIN_EDTN_NAME,dpcd AS EDTN_NAME,
                billno AS BRANCH_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by branch_name,publ_code,agcd,dpcd,copy_rate

                select comp_code AS COMP_CODE,  
                billno AS BRANCH_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,billno order by branch_name;   
             End 
             else if @pbreak_on='E' Begin  ---  Edition Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,publ_code AS PUBL_NAME, 
                agcd AS MAIN_EDTN,dpcd AS SUB_EDTN,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by AGCD,dpcd,publ_code,copy_rate

                select comp_code AS COMP_CODE,  
                agcd AS MAIN_EDTN,dpcd AS SUB_EDTN,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,agcd,dpcd order by agcd,dpcd;   
             End 
             else if @pbreak_on='A' Begin  ---  Area Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,publ_code AS PUBL_NAME, 
                area_code AS AREA_CODE,area_name AS AREA_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by area_name,publ_code,copy_rate

                select comp_code AS COMP_CODE,  
                area_code AS AREA_CODE,area_name AS AREA_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,area_code,area_name order by area_name;  
             End 
        End
        Else if @preptype=5 Begin--for comm category wise
            
            if @pbreak_on='R' Begin -- region wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,COM_CAT AS COM_CAT ,
                region AS REGION_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection order by region,COM_CAT,copy_rate

                select comp_code AS COMP_CODE,  
                region AS REGION_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection
                group by comp_code,region order by region_name
			End       
            else if @pbreak_on='S' Begin  -- state wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,COM_CAT AS COM_CAT, 
                state_code AS STATE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection
                order by state_name,COM_CAT,copy_rate;

                select comp_code AS COMP_CODE,  
                state_code AS STATE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE
                from #cir_temp_bill_collection 
                group by comp_code,state_code order by state_name
            End    
            Else if @pbreak_on='D' Begin -- district wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,COM_CAT AS COM_CAT, 
                state_code AS STATE_NAME,dist_code AS DIST_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by dist_name,COM_CAT,copy_rate;

                select comp_code AS COMP_CODE,  
                state_code AS STATE_NAME,dist_code AS DIST_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,state_code,dist_code order by state_name,dist_name;
            End             
            else if @pbreak_on='Z' begin  ---ZONE WISE
                select comp_code AS COMP_CODE, unit_code AS UNIT,COM_CAT AS COM_CAT,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,zone_code as ZONE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 
                then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,
                case when isnull(no_of_days,0)>0 
                then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by zone_name,COM_CAT,copy_rate;

                select comp_code AS COMP_CODE,  
                zone_code as ZONE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,zone_code order by zone_name
            end
            else if @pbreak_on='C' begin  ---CENTER WISE
                
                select comp_code AS COMP_CODE, unit_code AS UNIT,COM_CAT AS COM_CAT,
                state_code AS STATE_NAME,dist_code AS DIST_NAME
                ,unit_name as UNIT_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by UNIT_NAME,COM_CAT,copy_rate;
                
                select comp_code AS COMP_CODE,  
                UNIT_NAME as UNIT_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,UNIT_NAME order by UNIT_NAME;
			end
			else if @pbreak_on='P' begin  ---PUBLICATION WISE
                
                select comp_code AS COMP_CODE, unit_code AS UNIT,COM_CAT AS COM_CAT,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,publ_code AS PUBL_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection  order by publ_name,COM_CAT,copy_rate;
                
                select comp_code AS COMP_CODE,  
                publ_code AS PUBL_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,publ_code order by publ_name;
            end
			else if @pbreak_on='O' begin  --- ROUTE WISE
                select comp_code AS COMP_CODE, unit_code AS UNIT,COM_CAT AS COM_CAT, 
                state_code AS STATE_NAME,dist_code AS DIST_NAME,route_code as ROUTE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection --order by state_name,dist_name,agname,city_name,copy_rate,route_name;
                order by route_name,COM_CAT,copy_rate;

                select comp_code AS COMP_CODE,  
                route_code as ROUTE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,route_code order by route_name ;
             end
            else if @pbreak_on='B' Begin  ---  Branch Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,COM_CAT AS COM_CAT,
                billno AS BRANCH_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by branch_name,COM_CAT,copy_rate;

                select comp_code AS COMP_CODE,  
                billno AS BRANCH_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,billno order by branch_name;   
             End 
             else if @pbreak_on='E' Begin  ---  Edition Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,COM_CAT AS COM_CAT, 
                agcd AS MAIN_EDTN,dpcd AS SUB_EDTN,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by AGCD,dpcd,COM_CAT,copy_rate

                select comp_code AS COMP_CODE,  
                agcd AS MAIN_EDTN,dpcd AS SUB_EDTN,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,agcd,dpcd order by agcd,dpcd;   
             End 
             else if @pbreak_on='A' Begin  ---  Area Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,COM_CAT AS COM_CAT, 
                area_code AS AREA_CODE,area_name AS AREA_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by area_name,COM_CAT,copy_rate

                select comp_code AS COMP_CODE,  
                area_code AS AREA_CODE,area_name AS AREA_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,area_code,area_name order by area_name 
             End 
        End
        Else if @preptype=6 Begin--for State wise
            
            if @pbreak_on='R' Begin -- region wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,state_code AS STATE_NAME ,
                region AS REGION_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection order by region,state_code,copy_rate

                select comp_code AS COMP_CODE,  
                region AS REGION_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection
                group by comp_code,region order by region_name
			End       
            else if @pbreak_on='S' Begin  -- state wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,
                state_code AS STATE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection
                order by state_code,copy_rate;

                select comp_code AS COMP_CODE,  
                state_code AS STATE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE
                from #cir_temp_bill_collection 
                group by comp_code,state_code order by state_name
            End    
            Else if @pbreak_on='D' Begin -- district wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,COM_CAT AS COM_CAT, 
                state_code AS STATE_NAME,dist_code AS DIST_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by dist_name,state_code,copy_rate;

                select comp_code AS COMP_CODE,  
                state_code AS STATE_NAME,dist_code AS DIST_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,state_code,dist_code order by state_name,dist_name;
            End             
            else if @pbreak_on='Z' begin  ---ZONE WISE
                select comp_code AS COMP_CODE, unit_code AS UNIT,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,zone_code as ZONE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 
                then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,
                case when isnull(no_of_days,0)>0 
                then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by zone_name,state_code,copy_rate;

                select comp_code AS COMP_CODE,  
                zone_code as ZONE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,zone_code order by zone_name
            end
            else if @pbreak_on='C' begin  ---CENTER WISE
                
                select comp_code AS COMP_CODE, unit_code AS UNIT,
                state_code AS STATE_NAME,dist_code AS DIST_NAME
                ,unit_name as UNIT_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by UNIT_NAME,state_code,copy_rate;
                
                select comp_code AS COMP_CODE,  
                UNIT_NAME as UNIT_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,UNIT_NAME order by UNIT_NAME;
			end
			else if @pbreak_on='P' begin  ---PUBLICATION WISE
                
                select comp_code AS COMP_CODE, unit_code AS UNIT,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,publ_code AS PUBL_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection  order by publ_name,state_code,copy_rate;
                
                select comp_code AS COMP_CODE,  
                publ_code AS PUBL_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,publ_code order by publ_name;
            end
			else if @pbreak_on='O' begin  --- ROUTE WISE
                select comp_code AS COMP_CODE, unit_code AS UNIT, 
                state_code AS STATE_NAME,dist_code AS DIST_NAME,route_code as ROUTE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection --order by state_name,dist_name,agname,city_name,copy_rate,route_name;
                order by route_name,state_code,copy_rate;

                select comp_code AS COMP_CODE,  
                route_code as ROUTE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,route_code order by route_name ;
             end
            else if @pbreak_on='B' Begin  ---  Branch Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,state_code AS STATE_NAME,
                billno AS BRANCH_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by branch_name,state_code,copy_rate;

                select comp_code AS COMP_CODE,  
                billno AS BRANCH_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,billno order by branch_name;   
             End
             else if @pbreak_on='E' Begin  ---  Edition Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,state_code AS STATE_NAME, 
                agcd AS MAIN_EDTN,dpcd AS SUB_EDTN,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by AGCD,dpcd,state_code,copy_rate

                select comp_code AS COMP_CODE,  
                agcd AS MAIN_EDTN,dpcd AS SUB_EDTN,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,agcd,dpcd order by agcd,dpcd;   
             End  
             else if @pbreak_on='A' Begin  ---  Area Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,state_code AS STATE_NAME, 
                area_code AS AREA_CODE,area_name AS AREA_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by area_name,state_code,copy_rate

                select comp_code AS COMP_CODE,  
                area_code AS AREA_CODE,area_name AS AREA_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,area_code,area_name order by area_name
             End 
        End
        Else if @preptype=7 Begin--for Branch wise            
            if @pbreak_on='R' Begin -- region wise
                select comp_code AS COMP_CODE, unit_code AS UNIT, billno AS BRANCH_NAME ,
                region AS REGION_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection order by region,billno,copy_rate

                select comp_code AS COMP_CODE,  
                region AS REGION_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection
                group by comp_code,region order by region_name
			End       
            else if @pbreak_on='S' Begin  -- state wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,billno AS BRANCH_NAME,
                state_code AS STATE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection
                order by state_code,BILLNO,copy_rate;

                select comp_code AS COMP_CODE,  
                state_code AS STATE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE
                from #cir_temp_bill_collection 
                group by comp_code,state_code order by state_name
            End    
            Else if @pbreak_on='D' Begin -- district wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,billno AS BRANCH_NAME, 
                state_code AS STATE_NAME,dist_code AS DIST_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by dist_code,BILLNO,copy_rate;

                select comp_code AS COMP_CODE,  
                state_code AS STATE_NAME,dist_code AS DIST_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,state_code,dist_code order by state_name,dist_name;
            End             
            else if @pbreak_on='Z' begin  ---ZONE WISE
                select comp_code AS COMP_CODE, unit_code AS UNIT,billno AS BRANCH_NAME,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,zone_code as ZONE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 
                then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,
                case when isnull(no_of_days,0)>0 
                then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by zone_name,BILLNO,copy_rate;

                select comp_code AS COMP_CODE,  
                zone_code as ZONE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,zone_code order by zone_name
            end
            else if @pbreak_on='C' begin  ---CENTER WISE
                
                select comp_code AS COMP_CODE, unit_code AS UNIT,billno AS BRANCH_NAME,
                state_code AS STATE_NAME,dist_code AS DIST_NAME
                ,unit_name as UNIT_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by UNIT_NAME,BILLNO,copy_rate;
                
                select comp_code AS COMP_CODE,  
                UNIT_NAME as UNIT_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,UNIT_NAME order by UNIT_NAME;
			end
			else if @pbreak_on='P' begin  ---PUBLICATION WISE
                
                select comp_code AS COMP_CODE, unit_code AS UNIT,billno AS BRANCH_NAME,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,publ_code AS PUBL_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection  order by BILLNO,publ_code,copy_rate;
                
                select comp_code AS COMP_CODE,  
                publ_code AS PUBL_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,publ_code order by publ_name;
            end
			else if @pbreak_on='O' begin  --- ROUTE WISE
                select comp_code AS COMP_CODE, unit_code AS UNIT, billno AS BRANCH_NAME,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,route_code as ROUTE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection --order by state_name,dist_name,agname,city_name,copy_rate,route_name;
                order by BILLNO,dist_code,copy_rate;

                select comp_code AS COMP_CODE,  
                route_code as ROUTE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,route_code order by route_name ;
             end
            else if @pbreak_on='B' Begin  ---  Branch Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,billno AS BRANCH_NAME,
                billno AS BRANCH_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by BILLNO,dist_code,copy_rate;

                select comp_code AS COMP_CODE,  
                billno AS BRANCH_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,billno order by branch_name;   
             End 
             else if @pbreak_on='E' Begin  ---  Edition Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,billno AS BRANCH_NAME, 
                agcd AS MAIN_EDTN,dpcd AS SUB_EDTN,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by AGCD,dpcd,billno,copy_rate

                select comp_code AS COMP_CODE,  
                agcd AS MAIN_EDTN,dpcd AS SUB_EDTN,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,agcd,dpcd order by agcd,dpcd;   
             End 
             else if @pbreak_on='A' Begin  ---  Area Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,billno AS BRANCH_NAME, 
                area_code AS AREA_CODE,area_name AS AREA_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by area_name,billno,copy_rate

                select comp_code AS COMP_CODE,  
                area_code AS AREA_CODE,area_name AS AREA_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,area_code,area_name order by area_name 
             End 
        End
        Else if @preptype=8 Begin--for zone wise
            
            if @pbreak_on='R' Begin -- region wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,zone_code as ZONE_NAME ,
                region AS REGION_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection order by region,zone_code,copy_rate

                select comp_code AS COMP_CODE,  
                region AS REGION_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection
                group by comp_code,region order by region_name
			End       
            else if @pbreak_on='S' Begin  -- state wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,zone_code as ZONE_NAME,
                state_code AS STATE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection
                order by state_code,zone_code,copy_rate;

                select comp_code AS COMP_CODE,  
                state_code AS STATE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE
                from #cir_temp_bill_collection 
                group by comp_code,state_code order by state_name
            End    
            Else if @pbreak_on='D' Begin -- district wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,zone_code as ZONE_NAME, 
                state_code AS STATE_NAME,dist_code AS DIST_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by zone_code,state_code,copy_rate;

                select comp_code AS COMP_CODE,  
                state_code AS STATE_NAME,dist_code AS DIST_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,state_code,dist_code order by state_name,dist_name;
            End             
            else if @pbreak_on='Z' begin  ---ZONE WISE
                select comp_code AS COMP_CODE, unit_code AS UNIT,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,zone_code as ZONE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 
                then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,
                case when isnull(no_of_days,0)>0 
                then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by zone_name,dist_code,copy_rate;

                select comp_code AS COMP_CODE,  
                zone_code as ZONE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,zone_code order by zone_name
            end
            else if @pbreak_on='C' begin  ---CENTER WISE
                
                select comp_code AS COMP_CODE, unit_code AS UNIT,zone_code as ZONE_NAME,
                state_code AS STATE_NAME,dist_code AS DIST_NAME
                ,unit_name as UNIT_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by UNIT_NAME,zone_code,copy_rate;
                
                select comp_code AS COMP_CODE,  
                UNIT_NAME as UNIT_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,UNIT_NAME order by UNIT_NAME;
			end
			else if @pbreak_on='P' begin  ---PUBLICATION WISE
                
                select comp_code AS COMP_CODE, unit_code AS UNIT,zone_code as ZONE_NAME,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,publ_code AS PUBL_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection  order by publ_name,zone_code,copy_rate;
                
                select comp_code AS COMP_CODE,  
                publ_code AS PUBL_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,publ_code order by publ_name;
            end
			else if @pbreak_on='O' begin  --- ROUTE WISE
                select comp_code AS COMP_CODE, unit_code AS UNIT, zone_code as ZONE_NAME,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,route_code as ROUTE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection --order by state_name,dist_name,agname,city_name,copy_rate,route_name;
                order by route_name,zone_code,copy_rate;

                select comp_code AS COMP_CODE,  
                route_code as ROUTE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,route_code order by route_name ;
             end
            else if @pbreak_on='B' Begin  ---  Branch Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,zone_code as ZONE_NAME,
                billno AS BRANCH_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by branch_name,zone_code,copy_rate;

                select comp_code AS COMP_CODE,  
                billno AS BRANCH_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,billno order by branch_name;   
             End
             else if @pbreak_on='E' Begin  ---  Edition Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,zone_code as ZONE_NAME, 
                agcd AS MAIN_EDTN,dpcd AS SUB_EDTN,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by AGCD,dpcd,zone_code,copy_rate

                select comp_code AS COMP_CODE,  
                agcd AS MAIN_EDTN,dpcd AS SUB_EDTN,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,agcd,dpcd order by agcd,dpcd;   
             End  
             else if @pbreak_on='A' Begin  ---  Area Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,zone_code as ZONE_NAME, 
                area_code AS AREA_CODE,area_name AS AREA_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by area_name,zone_code,copy_rate

                select comp_code AS COMP_CODE,  
                area_code AS AREA_CODE,area_name AS AREA_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,area_code,area_name order by area_name;   
             End 
        End
        Else if @preptype=9 Begin--for Route wise
            
            if @pbreak_on='R' Begin -- region wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,route_code as ROUTE_NAME ,
                region AS REGION_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection order by region,route_code,copy_rate

                select comp_code AS COMP_CODE,  
                region AS REGION_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection
                group by comp_code,region order by region_name
			End       
            else if @pbreak_on='S' Begin  -- state wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,route_code as ROUTE_NAME,
                state_code AS STATE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection
                order by state_code,route_code,copy_rate;

                select comp_code AS COMP_CODE,  
                state_code AS STATE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE
                from #cir_temp_bill_collection 
                group by comp_code,state_code order by state_name
            End    
            Else if @pbreak_on='D' Begin -- district wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,route_code as ROUTE_NAME, 
                state_code AS STATE_NAME,dist_code AS DIST_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by zone_code,route_code,copy_rate;

                select comp_code AS COMP_CODE,  
                state_code AS STATE_NAME,dist_code AS DIST_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,state_code,dist_code order by state_name,dist_name;
            End             
            else if @pbreak_on='Z' begin  ---ZONE WISE
                select comp_code AS COMP_CODE, unit_code AS UNIT,route_code as ROUTE_NAME,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,zone_code as ZONE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 
                then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,
                case when isnull(no_of_days,0)>0 
                then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by zone_name,route_code,copy_rate;

                select comp_code AS COMP_CODE,  
                zone_code as ZONE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,zone_code order by zone_name
            end
            else if @pbreak_on='C' begin  ---CENTER WISE
                
                select comp_code AS COMP_CODE, unit_code AS UNIT,route_code as ROUTE_NAME,
                state_code AS STATE_NAME,dist_code AS DIST_NAME
                ,unit_name as UNIT_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by UNIT_NAME,route_code,copy_rate;
                
                select comp_code AS COMP_CODE,  
                UNIT_NAME as UNIT_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,UNIT_NAME order by UNIT_NAME;
			end
			else if @pbreak_on='P' begin  ---PUBLICATION WISE
                
                select comp_code AS COMP_CODE, unit_code AS UNIT,route_code as ROUTE_NAME,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,publ_code AS PUBL_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection  order by publ_name,route_code,copy_rate;
                
                select comp_code AS COMP_CODE,  
                publ_code AS PUBL_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,publ_code order by publ_name;
            end
			else if @pbreak_on='O' begin  --- ROUTE WISE
                select comp_code AS COMP_CODE, unit_code AS UNIT,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,route_code as ROUTE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection --order by state_name,dist_name,agname,city_name,copy_rate,route_name;
                order by route_name,copy_rate;

                select comp_code AS COMP_CODE,  
                route_code as ROUTE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,route_code order by route_name ;
             end
            else if @pbreak_on='B' Begin  ---  Branch Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,route_code as ROUTE_NAME,
                billno AS BRANCH_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by branch_name,route_code,copy_rate;

                select comp_code AS COMP_CODE,  
                billno AS BRANCH_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,billno order by branch_name;   
             End 
             else if @pbreak_on='E' Begin  ---  Edition Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,route_code as ROUTE_NAME, 
                agcd AS MAIN_EDTN,dpcd AS SUB_EDTN,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by AGCD,dpcd,route_code,copy_rate

                select comp_code AS COMP_CODE,  
                agcd AS MAIN_EDTN,dpcd AS SUB_EDTN,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,agcd,dpcd order by agcd,dpcd;   
             End 
              else if @pbreak_on='A' Begin  ---  Area Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,route_code as ROUTE_NAME, 
                area_code AS AREA_CODE,area_name AS AREA_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by area_name,route_code,copy_rate

                select comp_code AS COMP_CODE,  
                area_code AS AREA_CODE,area_name AS AREA_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,area_code,area_name order by area_name;         
             End 
        End
        Else if @preptype=10 Begin--for region wise
            
            if @pbreak_on='R' Begin -- region wise
                select comp_code AS COMP_CODE, unit_code AS UNIT ,
                region AS REGION_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection order by region,copy_rate

                select comp_code AS COMP_CODE,  
                region AS REGION_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection
                group by comp_code,region order by region_name
			End       
            else if @pbreak_on='S' Begin  -- state wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,region AS REGION_NAME,
                state_code AS STATE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection
                order by state_code,REGION,copy_rate;

                select comp_code AS COMP_CODE,  
                state_code AS STATE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE
                from #cir_temp_bill_collection 
                group by comp_code,state_code order by state_name
            End    
            Else if @pbreak_on='D' Begin -- district wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,region AS REGION_NAME,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by zone_code,REGION,copy_rate;

                select comp_code AS COMP_CODE,  
                state_code AS STATE_NAME,dist_code AS DIST_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,state_code,dist_code order by state_name,dist_name;
            End             
            else if @pbreak_on='Z' begin  ---ZONE WISE
                select comp_code AS COMP_CODE, unit_code AS UNIT,region AS REGION_NAME,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,zone_code as ZONE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 
                then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,
                case when isnull(no_of_days,0)>0 
                then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by zone_name,REGION,copy_rate;

                select comp_code AS COMP_CODE,  
                zone_code as ZONE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,zone_code order by zone_name
            end
            else if @pbreak_on='C' begin  ---CENTER WISE
                
                select comp_code AS COMP_CODE, unit_code AS UNIT,region AS REGION_NAME,
                state_code AS STATE_NAME,dist_code AS DIST_NAME
                ,unit_name as UNIT_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by UNIT_NAME,REGION,copy_rate;
                
                select comp_code AS COMP_CODE,  
                UNIT_NAME as UNIT_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,UNIT_NAME order by UNIT_NAME;
			end
			else if @pbreak_on='P' begin  ---PUBLICATION WISE
                
                select comp_code AS COMP_CODE, unit_code AS UNIT,region AS REGION_NAME,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,publ_code AS PUBL_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection  order by publ_name,REGION,copy_rate;
                
                select comp_code AS COMP_CODE,  
                publ_code AS PUBL_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,publ_code order by publ_name;
            end
			else if @pbreak_on='O' begin  --- ROUTE WISE
                select comp_code AS COMP_CODE, unit_code AS UNIT,region AS REGION_NAME,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,route_code as ROUTE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection --order by state_name,dist_name,agname,city_name,copy_rate,route_name;
                order by route_name,region,copy_rate;

                select comp_code AS COMP_CODE,  
                route_code as ROUTE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,route_code order by route_name ;
             end
            else if @pbreak_on='B' Begin  ---  Branch Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,region AS REGION_NAME,
                billno AS BRANCH_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by branch_name,REGION,copy_rate;

                select comp_code AS COMP_CODE,  
                billno AS BRANCH_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,billno order by branch_name;   
             End 
             else if @pbreak_on='E' Begin  ---  Edition Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,region AS REGION_NAME, 
                agcd AS MAIN_EDTN,dpcd AS SUB_EDTN,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by AGCD,dpcd,region,copy_rate

                select comp_code AS COMP_CODE,  
                agcd AS MAIN_EDTN,dpcd AS SUB_EDTN,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,agcd,dpcd order by agcd,dpcd;   
             End 
             else if @pbreak_on='A' Begin  ---  Area Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,region AS REGION_NAME, 
                area_code AS AREA_CODE,area_name AS AREA_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by area_name,region,copy_rate

                select comp_code AS COMP_CODE,  
                area_code AS AREA_CODE,area_name AS AREA_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,area_code,area_name order by area_name;            
             End 
        End
        Else if @preptype=11 Begin--for edition date wise detailed            
			if @pcopy_amt ='C' begin	
				DECLARE c2 cursor LOCAL FOR 
				select u.comp_code,u.unit_code,
				u.branch_code branch_code,(select distinct Branch_Name from branch_mst where Branch_Code=u.branch_code) branch_name,
				u.publ,u.publ_name,u.main_edtn,
				dbo.cir_get_edtn_name(u.comp_code,u.main_edtn) main_edtn_name,u.edtn edtn,u.edtn_name,u.copy_rate,
				u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,
				u.state_code,dbo.cir_get_state(u.comp_code,u.country_code,u.state_code) state_name,
				u.dist_code ,dbo.cir_get_name_cir_district(u.comp_code,u.dist_code,@plangtype,null,null,null) dist_name,
				u.city_code city_code,dbo.cir_get_name_cir_city(u.comp_code,u.city_code,@plangtype,null,null,null) city_name,
				u.tehsil_taluka,dbo.cir_get_name_cir_taluka(u.comp_code,u.tehsil_taluka,@plangtype,null,null,null) taluka_name,
				u.route_code,dbo.cir_get_route_name(u.comp_code,u.unit_code,u.route_code ) route_name,
				sum(supply_copy) supply_copy,sum(return_copy) return_copy,
				sum(supply_copy)-sum(return_copy) net_sale_copy, supdate supdate
				,dbo.cir_get_unit_name(u.comp_code,u.unit_code) as UNIT_NAME
				,u.comm_cat as COM_CAT,count (distinct u.supdate) as no_of_days,u.area_code AREA_CODE
				from (
				select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate copy_rate,
				b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
				a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka, b.route_code, 
				sum(isnull(b.sup_copy,0)) supply_copy,0 return_copy, supdate supdate
				,b.comm_code comm_cat,a.area_code
				from cir_agmast a,#CIR_DBKSUP_temp b,cir_edtn_mast e,cir_publ_mast p
				where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and 
				b.comp_code =@pcomp_code and 
				b.unit_code=a.unit and (b.unit_code=@punit_code or @punit_code is null or @punit_code ='') and 
				b.publ=p.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and b.edtn=e.edtn and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn='') and
				a.agcd=b.agcd and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') and a.dpcd=b.dpcd and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='') and
				b.supdate >= @pfromdate and b.supdate <=@ptilldate and 
				(a.ag_type=@pagency_type or @pagency_type is null or @pagency_type='') and(a.ag_class=@pagency_class or @pagency_class is null or @pagency_class='') and
				(a.branch_code=@pbranch or @pbranch is null or @pbranch='') and (a.state_code=@pstatecode or @pstatecode is null or @pstatecode='') and
				(a.dist_code=@pdistcode or @pdistcode is null or @pdistcode='') and (a.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka='') and
				(e.main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')
				and (b.comm_code=@pextra3 or @pextra3 is null or @pextra3 ='')
				and (p.pro_type=@pextra4 or @pextra4 is null or @pextra4 ='')
				and (b.sup_type_code=@psuptype or @psuptype is null or @psuptype ='')    
				and (dbo.cir_get_zone_by_city(a.comp_code,a.city_code,'C')=@pextra1 or @pextra1 is null or @pextra1 ='')
				and (dbo.cir_get_region_by_city(a.comp_code,a.city_code,'C')=@pextra2 or @pextra2 is null or @pextra2 ='')
				group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate,
				b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
				a.country_code,a.tehsil_taluka,b.route_code,b.comm_code,b.supdate,a.area_code
				union all
				select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
				b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
				a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka,d.route_code,  
				0 supply_copy,sum(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0)) return_copy,0 no_of_days
				,d.comm_code comm_cat,a.area_code
				from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e,cir_publ_mast p,cir_dbksup d
				where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and b.comp_code =@pcomp_code and 
				b.unit_code=a.unit and (b.unit_code=@punit_code or @punit_code is null or @punit_code ='') and  
				b.doctype='UCN' and ((b.recptdt >= @pfromdate and b.recptdt <=@ptilldate and isnull(@preturn_based,'R') ='R') or (b.supdate >= @pfromdate and b.supdate <=@ptilldate and isnull(@preturn_based,'R') ='S')) and 
				b.publ=d.publ and b.edtn=d.edtn and a.agcd=d.agcd and a.dpcd=d.dpcd and
				b.publ=e.publ and b.publ=p.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and b.edtn=e.edtn and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn='') and 
				a.agcd=b.agcd and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') and a.dpcd=b.dpcd and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='') and
				(a.ag_type=@pagency_type or @pagency_type is null or @pagency_type='') and(a.ag_class=@pagency_class or @pagency_class is null or @pagency_class='') and
				(a.branch_code=@pbranch or @pbranch is null or @pbranch='') and (a.state_code=@pstatecode or @pstatecode is null or @pstatecode='') and
				(a.dist_code=@pdistcode or @pdistcode is null or @pdistcode='') and (a.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka='') and
				(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and
				(e.main_edtn=@pmainedtn or @pmainedtn is null)
				and (d.comm_code=@pextra3 or @pextra3 is null or @pextra3 ='')
				and (p.pro_type=@pextra4 or @pextra4 is null or @pextra4 ='')
				and (d.sup_type_code=@psuptype or @psuptype is null or @psuptype ='')
				and (dbo.cir_get_zone_by_city(a.comp_code,a.city_code,'C')=@pextra1 or @pextra1 is null or @pextra1 ='')
				and (dbo.cir_get_region_by_city(a.comp_code,a.city_code,'C')=@pextra2 or @pextra2 is null or @pextra2 ='')
				group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
				b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
				a.country_code,a.tehsil_taluka,d.route_code ,d.comm_code,a.area_code) u
				where (u.supply_copy+u.return_copy)>0
				group by u.comp_code,u.unit_code,u.branch_code,u.publ,u.publ_name,u.main_edtn,u.edtn,u.edtn_name,u.copy_rate,
				u.agcd,u.dpcd,u.agname,u.agname_oth_lang,u.state_code,u.dist_code ,u.city_code,u.tehsil_taluka,u.route_code,u.country_code,u.comm_cat,u.supdate,u.area_code; 
		end
		else
		begin
			DECLARE c2 cursor LOCAL FOR 
			select u.comp_code,u.unit_code,
			u.branch_code branch_code,(select distinct Branch_Name from branch_mst where Branch_Code=u.branch_code) branch_name,
			u.publ,u.publ_name,u.main_edtn,
			dbo.cir_get_edtn_name(u.comp_code,u.main_edtn) main_edtn_name,u.edtn edtn,u.edtn_name,u.copy_rate,
			u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,
			u.state_code,dbo.cir_get_state(u.comp_code,u.country_code,u.state_code) state_name,
			u.dist_code ,dbo.cir_get_name_cir_district(u.comp_code,u.dist_code,@plangtype,null,null,null) dist_name,
			u.city_code city_code,dbo.cir_get_name_cir_city(u.comp_code,u.city_code,@plangtype,null,null,null) city_name,
			u.tehsil_taluka,dbo.cir_get_name_cir_taluka(u.comp_code,u.tehsil_taluka,@plangtype,null,null,null) taluka_name,
			u.route_code,dbo.cir_get_route_name(u.comp_code,u.unit_code,u.route_code ) route_name,
			(sum(supply_copy)* u.copy_rate) supply_copy,(sum(return_copy)* u.copy_rate) return_copy,
			(sum(supply_copy)* u.copy_rate)-(sum(return_copy)* u.copy_rate) net_sale_copy, supdate supdate
			,dbo.cir_get_unit_name(u.comp_code,u.unit_code) as UNIT_NAME
			,u.comm_cat as COM_CAT,count (distinct u.supdate) as no_of_days,u.area_code As AREA_CODE
			from (
			select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate copy_rate,
			b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
			a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka, b.route_code, 
			sum(isnull(b.sup_copy,0)) supply_copy,0 return_copy, supdate supdate
			,b.comm_code comm_cat,a.area_code
			from cir_agmast a,#CIR_DBKSUP_temp b,cir_edtn_mast e,cir_publ_mast p
			where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and 
			b.comp_code =@pcomp_code and 
			b.unit_code=a.unit and (b.unit_code=@punit_code or @punit_code is null or @punit_code ='') and 
			b.publ=p.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and b.edtn=e.edtn and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn='') and
			a.agcd=b.agcd and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') and a.dpcd=b.dpcd and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='') and
			b.supdate >= @pfromdate and b.supdate <=@ptilldate and 
			(a.ag_type=@pagency_type or @pagency_type is null or @pagency_type='') and(a.ag_class=@pagency_class or @pagency_class is null or @pagency_class='') and
			(a.branch_code=@pbranch or @pbranch is null or @pbranch='') and (a.state_code=@pstatecode or @pstatecode is null or @pstatecode='') and
			(a.dist_code=@pdistcode or @pdistcode is null or @pdistcode='') and (a.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka='') and
			(e.main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')
			and (b.comm_code=@pextra3 or @pextra3 is null or @pextra3 ='')
			and (p.pro_type=@pextra4 or @pextra4 is null or @pextra4 ='')
			and (b.sup_type_code=@psuptype or @psuptype is null or @psuptype ='')    
			and (dbo.cir_get_zone_by_city(a.comp_code,a.city_code,'C')=@pextra1 or @pextra1 is null or @pextra1 ='')
			and (dbo.cir_get_region_by_city(a.comp_code,a.city_code,'C')=@pextra2 or @pextra2 is null or @pextra2 ='')
			group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate,
			b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
			a.country_code,a.tehsil_taluka,b.route_code,b.comm_code,b.supdate,a.area_code
			union all
			select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
			b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
			a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka,d.route_code,  
			0 supply_copy,sum(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0)) return_copy,0 no_of_days
			,d.comm_code comm_cat,a.area_code
			from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e,cir_publ_mast p,cir_dbksup d
			where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and b.comp_code =@pcomp_code and 
			b.unit_code=a.unit and (b.unit_code=@punit_code or @punit_code is null or @punit_code ='') and  
			b.doctype='UCN' and ((b.recptdt >= @pfromdate and b.recptdt <=@ptilldate and isnull(@preturn_based,'R') ='R') or (b.supdate >= @pfromdate and b.supdate <=@ptilldate and isnull(@preturn_based,'R') ='S')) and 
			b.publ=d.publ and b.edtn=d.edtn and a.agcd=d.agcd and a.dpcd=d.dpcd and
			b.publ=e.publ and b.publ=p.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and b.edtn=e.edtn and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn='') and 
			a.agcd=b.agcd and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') and a.dpcd=b.dpcd and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='') and
			(a.ag_type=@pagency_type or @pagency_type is null or @pagency_type='') and(a.ag_class=@pagency_class or @pagency_class is null or @pagency_class='') and
			(a.branch_code=@pbranch or @pbranch is null or @pbranch='') and (a.state_code=@pstatecode or @pstatecode is null or @pstatecode='') and
			(a.dist_code=@pdistcode or @pdistcode is null or @pdistcode='') and (a.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka='') and
			(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and
			(e.main_edtn=@pmainedtn or @pmainedtn is null)
			and (d.comm_code=@pextra3 or @pextra3 is null or @pextra3 ='')
			and (p.pro_type=@pextra4 or @pextra4 is null or @pextra4 ='')
			and (d.sup_type_code=@psuptype or @psuptype is null or @psuptype ='')
			and (dbo.cir_get_zone_by_city(a.comp_code,a.city_code,'C')=@pextra1 or @pextra1 is null or @pextra1 ='')
			and (dbo.cir_get_region_by_city(a.comp_code,a.city_code,'C')=@pextra2 or @pextra2 is null or @pextra2 ='')
			group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
			b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
			a.country_code,a.tehsil_taluka,d.route_code ,d.comm_code,a.area_code) u
			where (u.supply_copy+u.return_copy)>0
			group by u.comp_code,u.unit_code,u.branch_code,u.publ,u.publ_name,u.main_edtn,u.edtn,u.edtn_name,u.copy_rate,
			u.agcd,u.dpcd,u.agname,u.agname_oth_lang,u.state_code,u.dist_code ,u.city_code,u.tehsil_taluka,u.route_code,u.country_code,u.comm_cat,u.supdate,u.area_code; 
		end
            
        delete from #cir_temp_bill_collection    
        OPEN c2 
        fetch NEXT FROM c2 INTO @v1_comp_code,@v1_unit_code, @v1_branch_code, @v1_branch_name,@v1_publ, @v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,@v1_edtn,@v1_edtn_name,@v1_copy_rate, @v1_agcd, @v1_dpcd,@v1_agname,@v1_agname_oth_lang,@v1_state_code,@v1_state_name,@v1_dist_code,@v1_dist_name,@v1_city_code,@v1_city_name, @v1_tehsil_taluka,@v1_taluka_name,@v1_route_code,@v1_route_name,@v1_supply_copy,@v1_return_copy,@v1_net_sale_copy, @v1_supdate,@v1_unit_name,@v1_COM_CAT,@v1_no_of_days,@v1_area_code
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN 
   
			If isnull(@v1_no_of_days,0)>0 Begin
                set @v_avg_sale=round(isnull(@v1_net_sale_copy,0)/(isnull(@v1_no_of_days,0)),0)
            End    
            Else Begin
                set @v_avg_sale=isnull(@v1_net_sale_copy,0)
            End

            select distinct @v_reg_code=region_code,@v_zone_code=zone_code from cir_city_mast where comp_code=@v1_comp_code and city_code=@v1_city_code            
            if(@v_reg_code='')
            begin
				set @v_reg_code=null
            end
           
            if(@v_zone_code='')
            begin
				set @v_zone_code=null
            end
            
            select distinct @v_publ_code=pro_type from cir_publ_mast where comp_code=@v1_comp_code and publ=@v1_publ;
            if(@v_publ_code='')
            begin
				set @v_publ_code=null
            end
            
            select distinct @v1_COM_CAT=COMM_CATG_DESC from CIR_COMM_CATG_MAST where comp_code=@v1_comp_code and COMM_CATG_CODE=@v1_COM_CAT            
            if(@v1_COM_CAT='')
            begin
				set @v1_COM_CAT=null
            end
            
            
            set @v_reg_code=dbo.cir_get_region_name(@v1_comp_code,@v_reg_code)
            set @v_zone_code=dbo.cir_get_zone_name(@v1_comp_code, @v_zone_code); 
			set @v_publ_code=dbo.cir_publ_type(@v1_comp_code,@v_publ_code,null,null);
            set @v1_area_name=dbo.cir_get_area(@v1_comp_code,@v1_area_code)
            insert into #cir_temp_bill_collection
				(comp_code, unit_code, billno, publ_code, agcd, dpcd,agname,agname_oth_lang, city_code, 
				taluka_code, dist_code, state_code, REGION,supply_copy, return_copy ,copy_rate,no_of_days,zone_code, region_code,pro_type,route_code
				,unit_name,COM_CAT,supdate,area_code,area_name)
            values(@v1_comp_code,@v1_unit_code,@v1_branch_name,@v1_publ_name,@v1_main_edtn_name,@v1_edtn_name,@v1_agname,@v1_agname_oth_lang,@v1_city_name,
				@v1_taluka_name,@v1_dist_name,@v1_state_name,@v_reg_code,@v1_supply_copy,@v1_return_copy,@v1_copy_rate,@v1_no_of_days,@v_zone_code,@v_reg_code,@v_publ_code,@v1_route_name
				,@v1_unit_name,@v1_COM_CAT,@v1_supdate,@v1_area_code,@v1_area_name)
            
		    fetch NEXT FROM c2 INTO @v1_comp_code,@v1_unit_code, @v1_branch_code, @v1_branch_name,@v1_publ, @v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,@v1_edtn,@v1_edtn_name,@v1_copy_rate, @v1_agcd, @v1_dpcd,@v1_agname,@v1_agname_oth_lang,@v1_state_code,@v1_state_name,@v1_dist_code,@v1_dist_name,@v1_city_code,@v1_city_name, @v1_tehsil_taluka,@v1_taluka_name,@v1_route_code,@v1_route_name,@v1_supply_copy,@v1_return_copy,@v1_net_sale_copy, @v1_supdate,@v1_unit_name,@v1_COM_CAT,@v1_no_of_days,@v1_area_code
		
		END 
		close c2
		DEALLOCATE c2 
            
            
            if @pbreak_on='R' Begin -- region wise
                select comp_code AS COMP_CODE,agcd AS MAIN_EDTN,dpcd AS SUB_EDTN ,supdate,
                region AS REGION_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection order by region,copy_rate

                select comp_code AS COMP_CODE,  
                region AS REGION_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection
                group by comp_code,region order by region_name
			End       
            else if @pbreak_on='S' Begin  -- state wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,agcd AS MAIN_EDTN,dpcd AS SUB_EDTN ,supdate,
                state_code AS STATE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection
                order by state_code,REGION,copy_rate;

                select comp_code AS COMP_CODE,  
                state_code AS STATE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE
                from #cir_temp_bill_collection 
                group by comp_code,state_code order by state_name
            End    
            Else if @pbreak_on='D' Begin -- district wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,agcd AS MAIN_EDTN,dpcd AS SUB_EDTN ,supdate,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by zone_code,REGION,copy_rate;

                select comp_code AS COMP_CODE,  
                state_code AS STATE_NAME,dist_code AS DIST_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,state_code,dist_code order by state_name,dist_name;
            End             
            else if @pbreak_on='Z' begin  ---ZONE WISE
                select comp_code AS COMP_CODE, unit_code AS UNIT,agcd AS MAIN_EDTN,dpcd AS SUB_EDTN ,supdate,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,zone_code as ZONE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 
                then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,
                case when isnull(no_of_days,0)>0 
                then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by zone_name,REGION,copy_rate;

                select comp_code AS COMP_CODE,  
                zone_code as ZONE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,zone_code order by zone_name
            end
            else if @pbreak_on='C' begin  ---CENTER WISE
                
                select comp_code AS COMP_CODE, unit_code AS UNIT,agcd AS MAIN_EDTN,dpcd AS SUB_EDTN ,supdate,
                state_code AS STATE_NAME,dist_code AS DIST_NAME
                ,unit_name as UNIT_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by UNIT_NAME,REGION,copy_rate;
                
                select comp_code AS COMP_CODE,  
                UNIT_NAME as UNIT_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,UNIT_NAME order by UNIT_NAME;
			end
			else if @pbreak_on='P' begin  ---PUBLICATION WISE
                
                select comp_code AS COMP_CODE, unit_code AS UNIT,agcd AS MAIN_EDTN,dpcd AS SUB_EDTN ,supdate,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,publ_code AS PUBL_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection  order by publ_name,REGION,copy_rate;
                
                select comp_code AS COMP_CODE,  
                publ_code AS PUBL_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,publ_code order by publ_name;
            end
			else if @pbreak_on='O' begin  --- ROUTE WISE
                select comp_code AS COMP_CODE, unit_code AS UNIT,agcd AS MAIN_EDTN,dpcd AS SUB_EDTN ,supdate,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,route_code as ROUTE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection --order by state_name,dist_name,agname,city_name,copy_rate,route_name;
                order by route_name,region,copy_rate;

                select comp_code AS COMP_CODE,  
                route_code as ROUTE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,route_code order by route_name ;
             end
            else if @pbreak_on='B' Begin  ---  Branch Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,agcd AS MAIN_EDTN,dpcd AS SUB_EDTN ,supdate,
                billno AS BRANCH_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by branch_name,REGION,copy_rate;

                select comp_code AS COMP_CODE,  
                billno AS BRANCH_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,billno order by branch_name;   
             End 
             else if @pbreak_on='E' Begin  ---  Edition Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,supdate,
                agcd AS MAIN_EDTN,dpcd AS SUB_EDTN,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by AGCD,dpcd,region,copy_rate

                select comp_code AS COMP_CODE,  
                agcd AS MAIN_EDTN,dpcd AS SUB_EDTN,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,agcd,dpcd order by agcd,dpcd;   
             End 
             else if @pbreak_on='A' Begin  ---  Area Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,supdate,
                area_code AS AREA_CODE,area_name AS AREA_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by area_name,region,copy_rate

                select comp_code AS COMP_CODE,  
                area_code AS AREA_CODE,area_name AS AREA_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,area_code,area_name order by area_name;   
             End 
        End
        Else if @preptype=12 Begin--for Route date wise detailed            
			if @pcopy_amt ='C' begin	
				DECLARE c2 cursor LOCAL FOR 
				select u.comp_code,u.unit_code,
				u.branch_code branch_code,(select distinct Branch_Name from branch_mst where Branch_Code=u.branch_code) branch_name,
				u.publ,u.publ_name,u.main_edtn,
				dbo.cir_get_edtn_name(u.comp_code,u.main_edtn) main_edtn_name,u.edtn edtn,u.edtn_name,u.copy_rate,
				u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,
				u.state_code,dbo.cir_get_state(u.comp_code,u.country_code,u.state_code) state_name,
				u.dist_code ,dbo.cir_get_name_cir_district(u.comp_code,u.dist_code,@plangtype,null,null,null) dist_name,
				u.city_code city_code,dbo.cir_get_name_cir_city(u.comp_code,u.city_code,@plangtype,null,null,null) city_name,
				u.tehsil_taluka,dbo.cir_get_name_cir_taluka(u.comp_code,u.tehsil_taluka,@plangtype,null,null,null) taluka_name,
				u.route_code,dbo.cir_get_route_name(u.comp_code,u.unit_code,u.route_code ) route_name,
				sum(supply_copy) supply_copy,sum(return_copy) return_copy,
				sum(supply_copy)-sum(return_copy) net_sale_copy, supdate supdate
				,dbo.cir_get_unit_name(u.comp_code,u.unit_code) as UNIT_NAME
				,u.comm_cat as COM_CAT,count (distinct u.supdate) as no_of_days,u.area_code as AREA_NAME
				from (
				select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate copy_rate,
				b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
				a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka, b.route_code, 
				sum(isnull(b.sup_copy,0)) supply_copy,0 return_copy, supdate supdate
				,b.comm_code comm_cat,a.area_code
				from cir_agmast a,#CIR_DBKSUP_temp b,cir_edtn_mast e,cir_publ_mast p
				where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and 
				b.comp_code =@pcomp_code and 
				b.unit_code=a.unit and (b.unit_code=@punit_code or @punit_code is null or @punit_code ='') and 
				b.publ=p.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and b.edtn=e.edtn and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn='') and
				a.agcd=b.agcd and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') and a.dpcd=b.dpcd and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='') and
				b.supdate >= @pfromdate and b.supdate <=@ptilldate and 
				(a.ag_type=@pagency_type or @pagency_type is null or @pagency_type='') and(a.ag_class=@pagency_class or @pagency_class is null or @pagency_class='') and
				(a.branch_code=@pbranch or @pbranch is null or @pbranch='') and (a.state_code=@pstatecode or @pstatecode is null or @pstatecode='') and
				(a.dist_code=@pdistcode or @pdistcode is null or @pdistcode='') and (a.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka='') and
				(e.main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')
				and (b.comm_code=@pextra3 or @pextra3 is null or @pextra3 ='')
				and (p.pro_type=@pextra4 or @pextra4 is null or @pextra4 ='')
				and (b.sup_type_code=@psuptype or @psuptype is null or @psuptype ='')    
				and (dbo.cir_get_zone_by_city(a.comp_code,a.city_code,'C')=@pextra1 or @pextra1 is null or @pextra1 ='')
				and (dbo.cir_get_region_by_city(a.comp_code,a.city_code,'C')=@pextra2 or @pextra2 is null or @pextra2 ='')
				group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate,
				b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
				a.country_code,a.tehsil_taluka,b.route_code,b.comm_code,b.supdate,a.area_code
				union all
				select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
				b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
				a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka,d.route_code,  
				0 supply_copy,sum(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0)) return_copy,0 no_of_days
				,d.comm_code comm_cat,a.area_code
				from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e,cir_publ_mast p,cir_dbksup d
				where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and b.comp_code =@pcomp_code and 
				b.unit_code=a.unit and (b.unit_code=@punit_code or @punit_code is null or @punit_code ='') and  
				b.doctype='UCN' and ((b.recptdt >= @pfromdate and b.recptdt <=@ptilldate and isnull(@preturn_based,'R') ='R') or (b.supdate >= @pfromdate and b.supdate <=@ptilldate and isnull(@preturn_based,'R') ='S')) and 
				b.publ=d.publ and b.edtn=d.edtn and a.agcd=d.agcd and a.dpcd=d.dpcd and
				b.publ=e.publ and b.publ=p.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and b.edtn=e.edtn and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn='') and 
				a.agcd=b.agcd and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') and a.dpcd=b.dpcd and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='') and
				(a.ag_type=@pagency_type or @pagency_type is null or @pagency_type='') and(a.ag_class=@pagency_class or @pagency_class is null or @pagency_class='') and
				(a.branch_code=@pbranch or @pbranch is null or @pbranch='') and (a.state_code=@pstatecode or @pstatecode is null or @pstatecode='') and
				(a.dist_code=@pdistcode or @pdistcode is null or @pdistcode='') and (a.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka='') and
				(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and
				(e.main_edtn=@pmainedtn or @pmainedtn is null)
				and (d.comm_code=@pextra3 or @pextra3 is null or @pextra3 ='')
				and (p.pro_type=@pextra4 or @pextra4 is null or @pextra4 ='')
				and (d.sup_type_code=@psuptype or @psuptype is null or @psuptype ='')
				and (dbo.cir_get_zone_by_city(a.comp_code,a.city_code,'C')=@pextra1 or @pextra1 is null or @pextra1 ='')
				and (dbo.cir_get_region_by_city(a.comp_code,a.city_code,'C')=@pextra2 or @pextra2 is null or @pextra2 ='')
				group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
				b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
				a.country_code,a.tehsil_taluka,d.route_code ,d.comm_code,a.area_code) u
				where (u.supply_copy+u.return_copy)>0
				group by u.comp_code,u.unit_code,u.branch_code,u.publ,u.publ_name,u.main_edtn,u.edtn,u.edtn_name,u.copy_rate,
				u.agcd,u.dpcd,u.agname,u.agname_oth_lang,u.state_code,u.dist_code ,u.city_code,u.tehsil_taluka,u.route_code,u.country_code,u.comm_cat,u.supdate,u.area_code; 
		end
		else
		begin
			DECLARE c2 cursor LOCAL FOR 
			select u.comp_code,u.unit_code,
			u.branch_code branch_code,(select distinct Branch_Name from branch_mst where Branch_Code=u.branch_code) branch_name,
			u.publ,u.publ_name,u.main_edtn,
			dbo.cir_get_edtn_name(u.comp_code,u.main_edtn) main_edtn_name,u.edtn edtn,u.edtn_name,u.copy_rate,
			u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,
			u.state_code,dbo.cir_get_state(u.comp_code,u.country_code,u.state_code) state_name,
			u.dist_code ,dbo.cir_get_name_cir_district(u.comp_code,u.dist_code,@plangtype,null,null,null) dist_name,
			u.city_code city_code,dbo.cir_get_name_cir_city(u.comp_code,u.city_code,@plangtype,null,null,null) city_name,
			u.tehsil_taluka,dbo.cir_get_name_cir_taluka(u.comp_code,u.tehsil_taluka,@plangtype,null,null,null) taluka_name,
			u.route_code,dbo.cir_get_route_name(u.comp_code,u.unit_code,u.route_code ) route_name,
			(sum(supply_copy)* u.copy_rate) supply_copy,(sum(return_copy)* u.copy_rate) return_copy,
			(sum(supply_copy)* u.copy_rate)-(sum(return_copy)* u.copy_rate) net_sale_copy, supdate supdate
			,dbo.cir_get_unit_name(u.comp_code,u.unit_code) as UNIT_NAME
			,u.comm_cat as COM_CAT,count (distinct u.supdate) as no_of_days,u.area_code as AREA_NAME
			from (
			select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate copy_rate,
			b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
			a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka, b.route_code, 
			sum(isnull(b.sup_copy,0)) supply_copy,0 return_copy, supdate supdate
			,b.comm_code comm_cat,a.area_code
			from cir_agmast a,#CIR_DBKSUP_temp b,cir_edtn_mast e,cir_publ_mast p
			where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and 
			b.comp_code =@pcomp_code and 
			b.unit_code=a.unit and (b.unit_code=@punit_code or @punit_code is null or @punit_code ='') and 
			b.publ=p.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and b.edtn=e.edtn and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn='') and
			a.agcd=b.agcd and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') and a.dpcd=b.dpcd and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='') and
			b.supdate >= @pfromdate and b.supdate <=@ptilldate and 
			(a.ag_type=@pagency_type or @pagency_type is null or @pagency_type='') and(a.ag_class=@pagency_class or @pagency_class is null or @pagency_class='') and
			(a.branch_code=@pbranch or @pbranch is null or @pbranch='') and (a.state_code=@pstatecode or @pstatecode is null or @pstatecode='') and
			(a.dist_code=@pdistcode or @pdistcode is null or @pdistcode='') and (a.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka='') and
			(e.main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn='')
			and (b.comm_code=@pextra3 or @pextra3 is null or @pextra3 ='')
			and (p.pro_type=@pextra4 or @pextra4 is null or @pextra4 ='')
			and (b.sup_type_code=@psuptype or @psuptype is null or @psuptype ='')    
			and (dbo.cir_get_zone_by_city(a.comp_code,a.city_code,'C')=@pextra1 or @pextra1 is null or @pextra1 ='')
			and (dbo.cir_get_region_by_city(a.comp_code,a.city_code,'C')=@pextra2 or @pextra2 is null or @pextra2 ='')
			group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate,
			b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
			a.country_code,a.tehsil_taluka,b.route_code,b.comm_code,b.supdate,a.area_code
			union all
			select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
			b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
			a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka,d.route_code,  
			0 supply_copy,sum(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0)) return_copy,0 no_of_days
			,d.comm_code comm_cat,a.area_code
			from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e,cir_publ_mast p,cir_dbksup d
			where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and b.comp_code =@pcomp_code and 
			b.unit_code=a.unit and (b.unit_code=@punit_code or @punit_code is null or @punit_code ='') and  
			b.doctype='UCN' and ((b.recptdt >= @pfromdate and b.recptdt <=@ptilldate and isnull(@preturn_based,'R') ='R') or (b.supdate >= @pfromdate and b.supdate <=@ptilldate and isnull(@preturn_based,'R') ='S')) and 
			b.publ=d.publ and b.edtn=d.edtn and a.agcd=d.agcd and a.dpcd=d.dpcd and
			b.publ=e.publ and b.publ=p.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and b.edtn=e.edtn and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn='') and 
			a.agcd=b.agcd and (b.agcd=isnull(@pagcd,b.agcd) or @pagcd='') and a.dpcd=b.dpcd and (b.dpcd=isnull(@pdpcd,b.dpcd) or @pdpcd='') and
			(a.ag_type=@pagency_type or @pagency_type is null or @pagency_type='') and(a.ag_class=@pagency_class or @pagency_class is null or @pagency_class='') and
			(a.branch_code=@pbranch or @pbranch is null or @pbranch='') and (a.state_code=@pstatecode or @pstatecode is null or @pstatecode='') and
			(a.dist_code=@pdistcode or @pdistcode is null or @pdistcode='') and (a.tehsil_taluka=@ptaluka or @ptaluka is null or @ptaluka='') and
			(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and
			(e.main_edtn=@pmainedtn or @pmainedtn is null)
			and (d.comm_code=@pextra3 or @pextra3 is null or @pextra3 ='')
			and (p.pro_type=@pextra4 or @pextra4 is null or @pextra4 ='')
			and (d.sup_type_code=@psuptype or @psuptype is null or @psuptype ='')
			and (dbo.cir_get_zone_by_city(a.comp_code,a.city_code,'C')=@pextra1 or @pextra1 is null or @pextra1 ='')
			and (dbo.cir_get_region_by_city(a.comp_code,a.city_code,'C')=@pextra2 or @pextra2 is null or @pextra2 ='')
			group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
			b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
			a.country_code,a.tehsil_taluka,d.route_code ,d.comm_code,a.area_code) u
			where (u.supply_copy+u.return_copy)>0
			group by u.comp_code,u.unit_code,u.branch_code,u.publ,u.publ_name,u.main_edtn,u.edtn,u.edtn_name,u.copy_rate,
			u.agcd,u.dpcd,u.agname,u.agname_oth_lang,u.state_code,u.dist_code ,u.city_code,u.tehsil_taluka,u.route_code,u.country_code,u.comm_cat,u.supdate,u.area_code; 
		end
            
        delete from #cir_temp_bill_collection    
        OPEN c2 
        fetch NEXT FROM c2 INTO @v1_comp_code,@v1_unit_code, @v1_branch_code, @v1_branch_name,@v1_publ, @v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,@v1_edtn,@v1_edtn_name,@v1_copy_rate, @v1_agcd, @v1_dpcd,@v1_agname,@v1_agname_oth_lang,@v1_state_code,@v1_state_name,@v1_dist_code,@v1_dist_name,@v1_city_code,@v1_city_name, @v1_tehsil_taluka,@v1_taluka_name,@v1_route_code,@v1_route_name,@v1_supply_copy,@v1_return_copy,@v1_net_sale_copy, @v1_supdate,@v1_unit_name,@v1_COM_CAT,@v1_no_of_days,@v1_area_code
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN 
   
			If isnull(@v1_no_of_days,0)>0 Begin
                set @v_avg_sale=round(isnull(@v1_net_sale_copy,0)/(isnull(@v1_no_of_days,0)),0)
            End    
            Else Begin
                set @v_avg_sale=isnull(@v1_net_sale_copy,0)
            End

            select distinct @v_reg_code=region_code,@v_zone_code=zone_code from cir_city_mast where comp_code=@v1_comp_code and city_code=@v1_city_code            
            if(@v_reg_code='')
            begin
				set @v_reg_code=null
            end
           
            if(@v_zone_code='')
            begin
				set @v_zone_code=null
            end
            
            select distinct @v_publ_code=pro_type from cir_publ_mast where comp_code=@v1_comp_code and publ=@v1_publ;
            if(@v_publ_code='')
            begin
				set @v_publ_code=null
            end
            
            select distinct @v1_COM_CAT=COMM_CATG_DESC from CIR_COMM_CATG_MAST where comp_code=@v1_comp_code and COMM_CATG_CODE=@v1_COM_CAT            
            if(@v1_COM_CAT='')
            begin
				set @v1_COM_CAT=null
            end
            
            
            set @v_reg_code=dbo.cir_get_region_name(@v1_comp_code,@v_reg_code)
            set @v_zone_code=dbo.cir_get_zone_name(@v1_comp_code, @v_zone_code); 
			set @v_publ_code=dbo.cir_publ_type(@v1_comp_code,@v_publ_code,null,null);
            set @v1_area_name=dbo.cir_get_area(@v1_comp_code,@v1_area_code)
            insert into #cir_temp_bill_collection
				(comp_code, unit_code, billno, publ_code, agcd, dpcd,agname,agname_oth_lang, city_code, 
				taluka_code, dist_code, state_code, REGION,supply_copy, return_copy ,copy_rate,no_of_days,zone_code, region_code,pro_type,route_code
				,unit_name,COM_CAT,supdate,area_code,area_name)
            values(@v1_comp_code,@v1_unit_code,@v1_branch_name,@v1_publ_name,@v1_main_edtn_name,@v1_edtn_name,@v1_agname,@v1_agname_oth_lang,@v1_city_name,
				@v1_taluka_name,@v1_dist_name,@v1_state_name,@v_reg_code,@v1_supply_copy,@v1_return_copy,@v1_copy_rate,@v1_no_of_days,@v_zone_code,@v_reg_code,@v_publ_code,@v1_route_name
				,@v1_unit_name,@v1_COM_CAT,@v1_supdate,@v1_area_code,@v1_area_name)
            
		    fetch NEXT FROM c2 INTO @v1_comp_code,@v1_unit_code, @v1_branch_code, @v1_branch_name,@v1_publ, @v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,@v1_edtn,@v1_edtn_name,@v1_copy_rate, @v1_agcd, @v1_dpcd,@v1_agname,@v1_agname_oth_lang,@v1_state_code,@v1_state_name,@v1_dist_code,@v1_dist_name,@v1_city_code,@v1_city_name, @v1_tehsil_taluka,@v1_taluka_name,@v1_route_code,@v1_route_name,@v1_supply_copy,@v1_return_copy,@v1_net_sale_copy, @v1_supdate,@v1_unit_name,@v1_COM_CAT,@v1_no_of_days,@v1_area_code
		
		END 
		close c2
		DEALLOCATE c2 
            
            
            if @pbreak_on='R' Begin -- region wise
                select comp_code AS COMP_CODE,route_code as ROUTE_NAME ,supdate,
                region AS REGION_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection order by region,copy_rate

                select comp_code AS COMP_CODE,  
                region AS REGION_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection
                group by comp_code,region order by region_name
			End       
            else if @pbreak_on='S' Begin  -- state wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,route_code as ROUTE_NAME ,supdate,
                state_code AS STATE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE 
                from #cir_temp_bill_collection
                order by state_code,REGION,copy_rate;

                select comp_code AS COMP_CODE,  
                state_code AS STATE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE
                from #cir_temp_bill_collection 
                group by comp_code,state_code order by state_name
            End    
            Else if @pbreak_on='D' Begin -- district wise
                select comp_code AS COMP_CODE, unit_code AS UNIT,route_code as ROUTE_NAME ,supdate,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round((supply_copy-return_copy)/no_of_days,0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by zone_code,REGION,copy_rate;

                select comp_code AS COMP_CODE,  
                state_code AS STATE_NAME,dist_code AS DIST_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,state_code,dist_code order by state_name,dist_name;
            End             
            else if @pbreak_on='Z' begin  ---ZONE WISE
                select comp_code AS COMP_CODE, unit_code AS UNIT,route_code as ROUTE_NAME ,supdate,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,zone_code as ZONE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 
                then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,
                case when isnull(no_of_days,0)>0 
                then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by zone_name,REGION,copy_rate;

                select comp_code AS COMP_CODE,  
                zone_code as ZONE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,zone_code order by zone_name
            end
            else if @pbreak_on='C' begin  ---CENTER WISE
                
                select comp_code AS COMP_CODE, unit_code AS UNIT,route_code as ROUTE_NAME ,supdate,
                state_code AS STATE_NAME,dist_code AS DIST_NAME
                ,unit_name as UNIT_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by UNIT_NAME,REGION,copy_rate;
                
                select comp_code AS COMP_CODE,  
                UNIT_NAME as UNIT_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,UNIT_NAME order by UNIT_NAME;
			end
			else if @pbreak_on='P' begin  ---PUBLICATION WISE
                
                select comp_code AS COMP_CODE, unit_code AS UNIT,route_code as ROUTE_NAME ,supdate,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,publ_code AS PUBL_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection  order by publ_name,REGION,copy_rate;
                
                select comp_code AS COMP_CODE,  
                publ_code AS PUBL_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,publ_code order by publ_name;
            end
			else if @pbreak_on='O' begin  --- ROUTE WISE
                select comp_code AS COMP_CODE, unit_code AS UNIT ,supdate,
                state_code AS STATE_NAME,dist_code AS DIST_NAME,route_code as ROUTE_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection --order by state_name,dist_name,agname,city_name,copy_rate,route_name;
                order by route_code,region,copy_rate;

                select comp_code AS COMP_CODE,  
                route_code as ROUTE_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER, 
                0 AS NO_OF_DAYS,0 AS AVG_NET_SALE 
                from #cir_temp_bill_collection 
                group by comp_code,route_code order by route_name ;
             end
            else if @pbreak_on='B' Begin  ---  Branch Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,route_code as ROUTE_NAME  ,supdate,
                billno AS BRANCH_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by branch_name,REGION,copy_rate;

                select comp_code AS COMP_CODE,  
                billno AS BRANCH_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,billno order by branch_name;   
             End 
             else if @pbreak_on='E' Begin  ---  Edition Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,route_code as ROUTE_NAME ,supdate,
                agcd AS MAIN_EDTN,dpcd AS SUB_EDTN,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by AGCD,dpcd,region,copy_rate

                select comp_code AS COMP_CODE,  
                agcd AS MAIN_EDTN,dpcd AS SUB_EDTN,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,agcd,dpcd order by agcd,dpcd;   
             End 
             else if @pbreak_on='A' Begin  ---  Area Wise

                select comp_code AS COMP_CODE, unit_code AS UNIT,route_code as ROUTE_NAME ,supdate,
                area_code AS AREA_CODE,area_name AS AREA_NAME,copy_rate as COPY_RATE,supply_copy AS SUPPLY_COPY, return_copy AS RETURN_COPY ,(supply_copy-return_copy) AS NET_SALE,
                case when isnull(supply_copy,0)>0 then round(((return_copy/supply_copy)*100),2) else 0 end as NET_PER,
                no_of_days AS NO_OF_DAYS,case when isnull(no_of_days,0)>0 then round(((supply_copy-return_copy)/no_of_days),0) else 0 end AS AVG_NET_SALE
                from #cir_temp_bill_collection order by area_name,region,copy_rate

                select comp_code AS COMP_CODE,  
                area_code AS AREA_CODE,area_name AS AREA_NAME,sum(supply_copy) AS SUPPLY_COPY, sum(return_copy) AS RETURN_COPY ,sum(supply_copy-return_copy) AS NET_SALE,
                case when isnull(sum(supply_copy),0)>0 then round(((sum(return_copy)/sum(supply_copy))*100),2) else 0 end as NET_PER,
                0 AS NO_OF_DAYS, 0 AS AVG_NET_SALE
                from #cir_temp_bill_collection
                group by comp_code,area_code,area_name order by area_name; 
             End 
        End
        
        select getdate() as CUR_DATE
        select getdate() as CUR_DATE
   drop table #CIR_TEMP_BILL_COLLECTION
   
   drop table #CIR_DBKSUP_temp


//////////////////////////////////////end/////////////////////


/*****by laxman sir*********/
alter table cir_dbksup add ACCAGCD   VARCHAR(8),
  ACCDPCD   VARCHAR(8), SUP_BILL_PAY  VARCHAR(1), SO_COPY   NUMERIC(8),DAY_COPY NUMERIC(5)

alter table cir_dbksup_dis add ACCAGCD   VARCHAR(8),
  ACCDPCD   VARCHAR(8), SUP_BILL_PAY  VARCHAR(1), SO_COPY   NUMERIC(8),DAY_COPY NUMERIC(5)

alter table cir_dbksup_resale add ACCAGCD   VARCHAR(8),
  ACCDPCD   VARCHAR(8), SUP_BILL_PAY  VARCHAR(1), SO_COPY   NUMERIC(8),DAY_COPY NUMERIC(5)

                                                                     
                                                                     
                                                                     
                                             
create procedure cir_rep_daybook_supply
    @pcompcode       as varchar(100),
    @punitcode       as varchar(100),
    @ppublcode       as varchar(100),
    @pmedtncode      as varchar(100),
    @pedtncode       as varchar(100),
    @pagtype         as varchar(100),
    @pagclass        as varchar(100),
    @pfromdate       as varchar(100),
    @ptilldate       as varchar(100),
    @pdateformat     as varchar(100),
    @puserid         as varchar(100),
    @preptype        as varchar(100),--D for detail S for Summary
    @preg_extra      as varchar(100),--R for Regular,E for Extra
    @pextra1         as varchar(100),--for E for Edition wise R for Route Wise
    @pextra2         as varchar(100),
    @pextra3         as varchar(100),
    @pextra4         as varchar(100),
    @pextra5         as varchar(100),
    @pextra6         as varchar(100),
    @pextra7         as varchar(100),
    @pextra8         as varchar(100),
    @pextra9         as varchar(100),
    @pextra10        as varchar(100)
As
    declare @v_frdt  datetime
    declare @v_todt  datetime
Begin

    set @v_frdt = dbo.convert_user_date('/',@pfromdate,@pdateformat)
    set @v_todt = dbo.convert_user_date('/',@ptilldate,@pdateformat)

	if @ppublcode='' begin
		set @ppublcode =null
	end
	if @pmedtncode='' begin
		set @pmedtncode =null
	end
	if @pedtncode='' begin
		set @pedtncode =null
	end
	if @pagtype='' begin
		set @pagtype =null
	end
	if @pagclass='' begin
		set @pagclass =null
	end
   
    if @pextra1='E' begin--for edition wise
        if @preptype='D' begin --for detail
            if @preg_extra='E' begin
                select x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,x.main_edtn,x.edtn,x.edtn_name,x.edition_nick,x.edtn_seq_no,
                x.agcd,x.dpcd,x.ag_name,x.ag_name_oth_lang,x.city_code,dbo.cir_get_city(x.comp_code,x.city_code) city_name,
                x.station_code,dbo.cir_get_drop_point_name(x.comp_code,x.unit_code,x.station_code,1) drop_point_name,
                x.lbl_printno,sum(x.paid_copy) paid_copy,sum(x.unpaid_copy) unpaid_copy,
                sum(x.pday_copy) pday_copy,sum(x.uday_copy) uday_copy,
                x.route_code,dbo.cir_get_name_cir_route(x.comp_code,x.unit_code,x.route_code,'1',null,null,null) route_name,
                x.subroute_code,dbo.cir_get_name_cir_subroute(x.comp_code,x.unit_code,x.route_code,x.subroute_code,'1',null,null,null) subrt_name,
                x.subsubroute_code,dbo.cir_get_name_cir_subsubroute(x.comp_code,x.unit_code,x.route_code,x.subroute_code,x.subsubroute_code,'1',null,null,null) subsubrt_name
                from
                (select d.comp_code,d.unit_code,(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=d.unit_code) unit_name,
                d.publ,p.publ_name,e.main_edtn,d.edtn,e.edtn_name,e.edition_nick,e.edtn_seq_no,
                d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,s.lbl_printno,
                case when isnull(t.bill_pay,'N')='Y' then d.sup_copy else 0 end paid_copy,
                case when isnull(t.bill_pay,'N')='N' then d.sup_copy else 0 end unpaid_copy,
                case when isnull(t.bill_pay,'N')='Y' then d.day_copy else 0 end pday_copy,
                case when isnull(t.bill_pay,'N')='N' then d.day_copy else 0 end uday_copy,
                d.route_code, d.subroute_code, d.subsubroute_code
                from cir_agmast m,cir_supply s ,cir_dbksup d,cir_publ_mast p,cir_edtn_mast e,cir_supply_type_mast t
                where m.comp_code=d.comp_code and m.comp_code=p.comp_code and m.comp_code=s.comp_code and m.comp_code=e.comp_code and
                m.comp_code=t.comp_code and m.comp_code=@pcompcode and m.unit=d.unit_code and m.unit=s.unit and d.unit_code=@punitcode and
                d.publ = p.publ and p.publ = e.publ and d.publ = @ppublcode and d.edtn=e.edtn and d.edtn=s.edtn and d.edtn=isnull(@pedtncode,d.edtn) and e.main_edtn=isnull(@pmedtncode,e.main_edtn) and
                d.sup_type_code=t.sup_ty_code and d.sup_type_code=s.supply_type_code and m.agcd=d.agcd and m.agcd=s.agcd and m.dpcd=d.dpcd and m.dpcd=s.dpcd and
                d.supdate between @v_frdt and @v_todt and (m.ag_type=@pagtype or @pagtype is null)
                and (m.ag_class=@pagclass or @pagclass is null) and isnull(d.day_copy,0)>0) x
                group by x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,x.main_edtn,x.edtn,x.edtn_name,x.edition_nick,x.edtn_seq_no,
                x.agcd,x.dpcd,x.ag_name,x.ag_name_oth_lang,x.city_code,x.station_code,x.lbl_printno,x.route_code,x.subroute_code,x.subsubroute_code
                having sum(x.pday_copy)>0
                order by x.comp_code,x.unit_code,x.unit_name,x.publ_name,x.publ,x.edtn_seq_no,x.edtn_name,x.lbl_printno,x.ag_name,x.agcd,x.dpcd;
            end
            else begin

                select x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,x.main_edtn,x.edtn,x.edtn_name,x.edition_nick,x.edtn_seq_no,
                x.agcd,x.dpcd,x.ag_name,x.ag_name_oth_lang,x.city_code,dbo.cir_get_city(x.comp_code,x.city_code) city_name,
                x.station_code,dbo.cir_get_drop_point_name(x.comp_code,x.unit_code,x.station_code,1) drop_point_name,
                x.lbl_printno,sum(x.paid_copy) paid_copy,sum(x.unpaid_copy) unpaid_copy,
                sum(x.pday_copy) pday_copy,sum(x.uday_copy) uday_copy,
                x.route_code,dbo.cir_get_name_cir_route(x.comp_code,x.unit_code,x.route_code,'1',null,null,null) route_name,
                x.subroute_code,dbo.cir_get_name_cir_subroute(x.comp_code,x.unit_code,x.route_code,x.subroute_code,'1',null,null,null) subrt_name,
                x.subsubroute_code,dbo.cir_get_name_cir_subsubroute(x.comp_code,x.unit_code,x.route_code,x.subroute_code,x.subsubroute_code,'1',null,null,null) subsubrt_name
                from
                (select d.comp_code,d.unit_code,(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=d.unit_code) unit_name,
                d.publ,p.publ_name,e.main_edtn,d.edtn,e.edtn_name,e.edition_nick,e.edtn_seq_no,
                d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,s.lbl_printno,
                case when isnull(t.bill_pay,'N')='Y' then d.sup_copy else 0 end paid_copy,
                case when isnull(t.bill_pay,'N')='N' then d.sup_copy else 0 end unpaid_copy,
                case when isnull(t.bill_pay,'N')='Y' then d.day_copy else 0 end pday_copy,
                case when isnull(t.bill_pay,'N')='N' then d.day_copy else 0 end uday_copy,
                d.route_code, d.subroute_code, d.subsubroute_code
                from cir_agmast m,cir_supply s ,cir_dbksup d,cir_publ_mast p,cir_edtn_mast e,cir_supply_type_mast t
                where m.comp_code=d.comp_code and m.comp_code=p.comp_code and m.comp_code=s.comp_code and m.comp_code=e.comp_code and
                m.comp_code=t.comp_code and m.comp_code=@pcompcode and m.unit=d.unit_code and m.unit=s.unit and d.unit_code=@punitcode and
                d.publ = p.publ and p.publ = e.publ and d.publ = @ppublcode and d.edtn=e.edtn and d.edtn=s.edtn and d.edtn=isnull(@pedtncode,d.edtn) and e.main_edtn=isnull(@pmedtncode,e.main_edtn) and
                d.sup_type_code=t.sup_ty_code and d.sup_type_code=s.supply_type_code and m.agcd=d.agcd and m.agcd=s.agcd and m.dpcd=d.dpcd and m.dpcd=s.dpcd and
                d.supdate between @v_frdt and @v_todt and (m.ag_type=@pagtype or @pagtype is null)
                and (m.ag_class=@pagclass or @pagclass is null) ) x
                group by x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,x.main_edtn,x.edtn,x.edtn_name,x.edition_nick,x.edtn_seq_no,
                x.agcd,x.dpcd,x.ag_name,x.ag_name_oth_lang,x.city_code,x.station_code,x.lbl_printno,x.route_code,x.subroute_code,x.subsubroute_code
                order by x.comp_code,x.unit_code,x.unit_name,x.publ_name,x.publ,x.edtn_seq_no,x.edtn_name,x.lbl_printno,x.ag_name,x.agcd,x.dpcd;
            end
		end
        else begin--for summary
            if @preg_extra='E' begin
                select x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,x.main_edtn,x.edtn,x.edtn_name,x.edition_nick,x.edtn_seq_no,
                sum(x.paid_copy) paid_copy,sum(x.unpaid_copy) unpaid_copy,
                sum(x.pday_copy) pday_copy,sum(x.uday_copy) uday_copy
                from
                (select d.comp_code,d.unit_code,(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=d.unit_code) unit_name,
                d.publ,p.publ_name,e.main_edtn,d.edtn,e.edtn_name,e.edition_nick,e.edtn_seq_no,
                d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,s.lbl_printno,
                case when isnull(t.bill_pay,'N')='Y' then d.sup_copy else 0 end paid_copy,
                case when isnull(t.bill_pay,'N')='N' then d.sup_copy else 0 end unpaid_copy,
                case when isnull(t.bill_pay,'N')='Y' then d.day_copy else 0 end pday_copy,
                case when isnull(t.bill_pay,'N')='N' then d.day_copy else 0 end uday_copy,       
                d.route_code,  d.subroute_code,d.subsubroute_code
                from cir_agmast m,cir_supply s ,cir_dbksup d,cir_publ_mast p,cir_edtn_mast e,cir_supply_type_mast t
                where m.comp_code=d.comp_code and m.comp_code=p.comp_code and m.comp_code=s.comp_code and m.comp_code=e.comp_code and
                m.comp_code=t.comp_code and m.comp_code=@pcompcode and m.unit=d.unit_code and m.unit=s.unit and d.unit_code=@punitcode and
                d.publ = p.publ and p.publ = e.publ and d.publ = @ppublcode and d.edtn=e.edtn and d.edtn=s.edtn and d.edtn=isnull(@pedtncode,d.edtn) and e.main_edtn=isnull(@pmedtncode,e.main_edtn) and
                d.sup_type_code=t.sup_ty_code and d.sup_type_code=s.supply_type_code and m.agcd=d.agcd and m.agcd=s.agcd and m.dpcd=d.dpcd and m.dpcd=s.dpcd and
                d.supdate between @v_frdt and @v_todt and (m.ag_type=@pagtype or @pagtype is null)
                and (m.ag_class=@pagclass or @pagclass is null) and isnull(d.day_copy,0)>0) x
                group by x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,x.main_edtn,x.edtn,x.edtn_name,x.edition_nick,x.edtn_seq_no
                having sum(x.pday_copy)>0
                order by x.comp_code,x.unit_code,x.unit_name,x.publ_name,x.publ,x.edtn_seq_no,x.edtn_name;
            end
            else begin
                select x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,x.main_edtn,x.edtn,x.edtn_name,x.edition_nick,x.edtn_seq_no,
                sum(x.paid_copy) paid_copy,sum(x.unpaid_copy) unpaid_copy,
                sum(x.pday_copy) pday_copy,sum(x.uday_copy) uday_copy
                from
                (select d.comp_code,d.unit_code,(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=d.unit_code) unit_name,
                d.publ,p.publ_name,e.main_edtn,d.edtn,e.edtn_name,e.edition_nick,e.edtn_seq_no,
                d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,s.lbl_printno,
                case when isnull(t.bill_pay,'N')='Y' then d.sup_copy else 0 end paid_copy,
                case when isnull(t.bill_pay,'N')='N' then d.sup_copy else 0 end unpaid_copy,
                case when isnull(t.bill_pay,'N')='Y' then d.day_copy else 0 end pday_copy,
                case when isnull(t.bill_pay,'N')='N' then d.day_copy else 0 end uday_copy,       
                d.route_code, d.subroute_code,d.subsubroute_code
                from cir_agmast m,cir_supply s ,cir_dbksup d,cir_publ_mast p,cir_edtn_mast e,cir_supply_type_mast t
                where m.comp_code=d.comp_code and m.comp_code=p.comp_code and m.comp_code=s.comp_code and m.comp_code=e.comp_code and
                m.comp_code=t.comp_code and m.comp_code=@pcompcode and m.unit=d.unit_code and m.unit=s.unit and d.unit_code=@punitcode and
                d.publ = p.publ and p.publ = e.publ and d.publ = @ppublcode and d.edtn=e.edtn and d.edtn=s.edtn and d.edtn=isnull(@pedtncode,d.edtn) and e.main_edtn=isnull(@pmedtncode,e.main_edtn) and
                d.sup_type_code=t.sup_ty_code and d.sup_type_code=s.supply_type_code and m.agcd=d.agcd and m.agcd=s.agcd and m.dpcd=d.dpcd and m.dpcd=s.dpcd and
                d.supdate between @v_frdt and @v_todt and (m.ag_type=@pagtype or @pagtype is null)
                and (m.ag_class=@pagclass or @pagclass is null)) x
                group by x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,x.main_edtn,x.edtn,x.edtn_name,x.edition_nick,x.edtn_seq_no
                order by x.comp_code,x.unit_code,x.unit_name,x.publ_name,x.publ,x.edtn_seq_no,x.edtn_name;       
            end
        end
    end    
    else begin--for route wise
        if @preptype='D' begin --for detail
            if @preg_extra='E' begin
                select x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,
                x.agcd,x.dpcd,x.ag_name,x.ag_name_oth_lang,x.city_code,dbo.cir_get_city(x.comp_code,x.city_code) city_name,
                x.station_code,dbo.cir_get_drop_point_name(x.comp_code,x.unit_code,x.station_code,1) drop_point_name,
                x.lbl_printno,sum(x.paid_copy) paid_copy,sum(x.unpaid_copy) unpaid_copy,
                sum(x.pday_copy) pday_copy,sum(x.uday_copy) uday_copy,
                x.route_code,dbo.cir_get_name_cir_route(x.comp_code,x.unit_code,x.route_code,'1',null,null,null) route_name
                from
                (select d.comp_code,d.unit_code,(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=d.unit_code) unit_name,
                d.publ,p.publ_name,
                d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,s.lbl_printno,
                case when isnull(t.bill_pay,'N')='Y' then d.sup_copy else 0 end paid_copy,
                case when isnull(t.bill_pay,'N')='N' then d.sup_copy else 0 end unpaid_copy,
                case when isnull(t.bill_pay,'N')='Y' then d.day_copy else 0 end pday_copy,
                case when isnull(t.bill_pay,'N')='N' then d.day_copy else 0 end uday_copy,
                d.route_code, d.subroute_code, d.subsubroute_code
                from cir_agmast m,cir_supply s ,cir_dbksup d,cir_publ_mast p,cir_edtn_mast e,cir_supply_type_mast t
                where m.comp_code=d.comp_code and m.comp_code=p.comp_code and m.comp_code=s.comp_code and m.comp_code=e.comp_code and
                m.comp_code=t.comp_code and m.comp_code=@pcompcode and m.unit=d.unit_code and m.unit=s.unit and d.unit_code=@punitcode and
                d.publ = p.publ and p.publ = e.publ and d.publ = @ppublcode and d.edtn=e.edtn and d.edtn=s.edtn and d.edtn=isnull(@pedtncode,d.edtn) and e.main_edtn=isnull(@pmedtncode,e.main_edtn) and
                d.sup_type_code=t.sup_ty_code and d.sup_type_code=s.supply_type_code and m.agcd=d.agcd and m.agcd=s.agcd and m.dpcd=d.dpcd and m.dpcd=s.dpcd and
                d.supdate between @v_frdt and @v_todt and (m.ag_type=@pagtype or @pagtype is null)
                and (m.ag_class=@pagclass or @pagclass is null) and isnull(d.day_copy,0)>0) x
                group by x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,
                x.agcd,x.dpcd,x.ag_name,x.ag_name_oth_lang,x.city_code,x.station_code,x.lbl_printno,x.route_code
                having sum(x.pday_copy)>0
                order by x.comp_code,x.unit_code,x.unit_name,x.publ_name,x.publ,route_name,x.lbl_printno,x.ag_name,x.agcd,x.dpcd;
            end
            else begin
                select x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,
                x.agcd,x.dpcd,x.ag_name,x.ag_name_oth_lang,x.city_code,dbo.cir_get_city(x.comp_code,x.city_code) city_name,
                x.station_code,dbo.cir_get_drop_point_name(x.comp_code,x.unit_code,x.station_code,1) drop_point_name,
                x.lbl_printno,sum(x.paid_copy) paid_copy,sum(x.unpaid_copy) unpaid_copy,
                sum(x.pday_copy) pday_copy,sum(x.uday_copy) uday_copy,
                x.route_code,dbo.cir_get_name_cir_route(x.comp_code,x.unit_code,x.route_code,'1',null,null,null) route_name
                from
                (select d.comp_code,d.unit_code,(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=d.unit_code) unit_name,
                d.publ,p.publ_name,e.main_edtn,d.edtn,e.edtn_name,e.edition_nick,e.edtn_seq_no,
                d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,s.lbl_printno,
                case when isnull(t.bill_pay,'N')='Y' then d.sup_copy else 0 end paid_copy,
                case when isnull(t.bill_pay,'N')='N' then d.sup_copy else 0 end unpaid_copy,
                case when isnull(t.bill_pay,'N')='Y' then d.day_copy else 0 end pday_copy,
                case when isnull(t.bill_pay,'N')='N' then d.day_copy else 0 end uday_copy,
                d.route_code, d.subroute_code, d.subsubroute_code
                from cir_agmast m,cir_supply s ,cir_dbksup d,cir_publ_mast p,cir_edtn_mast e,cir_supply_type_mast t
                where m.comp_code=d.comp_code and m.comp_code=p.comp_code and m.comp_code=s.comp_code and m.comp_code=e.comp_code and
                m.comp_code=t.comp_code and m.comp_code=@pcompcode and m.unit=d.unit_code and m.unit=s.unit and d.unit_code=@punitcode and
                d.publ = p.publ and p.publ = e.publ and d.publ = @ppublcode and d.edtn=e.edtn and d.edtn=s.edtn and d.edtn=isnull(@pedtncode,d.edtn) and e.main_edtn=isnull(@pmedtncode,e.main_edtn) and
                d.sup_type_code=t.sup_ty_code and d.sup_type_code=s.supply_type_code and m.agcd=d.agcd and m.agcd=s.agcd and m.dpcd=d.dpcd and m.dpcd=s.dpcd and
                d.supdate between @v_frdt and @v_todt and (m.ag_type=@pagtype or @pagtype is null)
                and (m.ag_class=@pagclass or @pagclass is null) ) x
                group by x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,
                x.agcd,x.dpcd,x.ag_name,x.ag_name_oth_lang,x.city_code,x.station_code,x.lbl_printno,x.route_code
                order by x.comp_code,x.unit_code,x.unit_name,x.publ_name,x.publ,route_name,x.lbl_printno,x.ag_name,x.agcd,x.dpcd;
            end    
        end    
        else begin--for summary
            if @preg_extra='E' begin
                select x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,
                sum(x.paid_copy) paid_copy,sum(x.unpaid_copy) unpaid_copy,
                sum(x.pday_copy) pday_copy,sum(x.uday_copy) uday_copy,
                x.route_code,dbo.cir_get_name_cir_route(x.comp_code,x.unit_code,x.route_code,'1',null,null,null) route_name
                from
                (select d.comp_code,d.unit_code,(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=d.unit_code) unit_name,
                d.publ,p.publ_name,e.main_edtn,d.edtn,e.edtn_name,e.edition_nick,e.edtn_seq_no,
                d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,s.lbl_printno,
                case when isnull(t.bill_pay,'N')='Y' then d.sup_copy else 0 end paid_copy,
                case when isnull(t.bill_pay,'N')='N' then d.sup_copy else 0 end unpaid_copy,
                case when isnull(t.bill_pay,'N')='Y' then d.day_copy else 0 end pday_copy,
                case when isnull(t.bill_pay,'N')='N' then d.day_copy else 0 end uday_copy,       
                d.route_code,  d.subroute_code,d.subsubroute_code
                from cir_agmast m,cir_supply s ,cir_dbksup d,cir_publ_mast p,cir_edtn_mast e,cir_supply_type_mast t
                where m.comp_code=d.comp_code and m.comp_code=p.comp_code and m.comp_code=s.comp_code and m.comp_code=e.comp_code and
                m.comp_code=t.comp_code and m.comp_code=@pcompcode and m.unit=d.unit_code and m.unit=s.unit and d.unit_code=@punitcode and
                d.publ = p.publ and p.publ = e.publ and d.publ = @ppublcode and d.edtn=e.edtn and d.edtn=s.edtn and d.edtn=isnull(@pedtncode,d.edtn) and e.main_edtn=isnull(@pmedtncode,e.main_edtn) and
                d.sup_type_code=t.sup_ty_code and d.sup_type_code=s.supply_type_code and m.agcd=d.agcd and m.agcd=s.agcd and m.dpcd=d.dpcd and m.dpcd=s.dpcd and
                d.supdate between @v_frdt and @v_todt and (m.ag_type=@pagtype or @pagtype is null)
                and (m.ag_class=@pagclass or @pagclass is null) and isnull(d.day_copy,0)>0) x
                group by x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,x.route_code
                having sum(x.pday_copy)>0
                order by x.comp_code,x.unit_code,x.unit_name,x.publ_name,x.publ,route_name;
            end
            else begin
                select x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,
                sum(x.paid_copy) paid_copy,sum(x.unpaid_copy) unpaid_copy,
                sum(x.pday_copy) pday_copy,sum(x.uday_copy) uday_copy,
                x.route_code,dbo.cir_get_name_cir_route(x.comp_code,x.unit_code,x.route_code,'1',null,null,null) route_name
                from
                (select d.comp_code,d.unit_code,(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=d.unit_code) unit_name,
                d.publ,p.publ_name,e.main_edtn,d.edtn,e.edtn_name,e.edition_nick,e.edtn_seq_no,
                d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,s.lbl_printno,
                case when isnull(t.bill_pay,'N')='Y' then d.sup_copy else 0 end paid_copy,
                case when isnull(t.bill_pay,'N')='N' then d.sup_copy else 0 end unpaid_copy,
                case when isnull(t.bill_pay,'N')='Y' then d.day_copy else 0 end pday_copy,
                case when isnull(t.bill_pay,'N')='N' then d.day_copy else 0 end uday_copy,       
                d.route_code, d.subroute_code,d.subsubroute_code
                from cir_agmast m,cir_supply s ,cir_dbksup d,cir_publ_mast p,cir_edtn_mast e,cir_supply_type_mast t
                where m.comp_code=d.comp_code and m.comp_code=p.comp_code and m.comp_code=s.comp_code and m.comp_code=e.comp_code and
                m.comp_code=t.comp_code and m.comp_code=@pcompcode and m.unit=d.unit_code and m.unit=s.unit and d.unit_code=@punitcode and
                d.publ = p.publ and p.publ = e.publ and d.publ = @ppublcode and d.edtn=e.edtn and d.edtn=s.edtn and d.edtn=isnull(@pedtncode,d.edtn) and e.main_edtn=isnull(@pmedtncode,e.main_edtn) and
                d.sup_type_code=t.sup_ty_code and d.sup_type_code=s.supply_type_code and m.agcd=d.agcd and m.agcd=s.agcd and m.dpcd=d.dpcd and m.dpcd=s.dpcd and
                d.supdate between @v_frdt and @v_todt and (m.ag_type=@pagtype or @pagtype is null)
                and (m.ag_class=@pagclass or @pagclass is null)) x
                group by x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,x.route_code
                order by x.comp_code,x.unit_code,x.unit_name,x.publ_name,x.publ,route_name;       
            end
        end
    end

    select getdate() as "CUR_DATE"
       
    select getdate() as "CUR_DATE"

End 
/*****by laxman sir*********/


////////////////////////////////////add by deepika 28/09/2012//////

ALTER procedure [dbo].[cir_suspend_detail]

@pcompcode         as  varchar(50),
@pblockunblock     as  varchar(10),
@puserid           as  varchar(50),
@pextra1           as  varchar(20),
@pextra2           as  varchar(20)

   
As

    SELECT distinct a.comp_code,a.SUSPEND_TYPE_CODE,a.SUSPEND_DESC,ISNULL(b.user_flag,'N') 
    FLAG,ISNULL(  b.SUSPEND_TYPE_CODE ,'N')  AS ENTRY_EXISTS 
    FROM cir_suspend_type_mast a left outer join CIR_SUSPEND_TYPE_PERMISSION b
    on a.SUSPEND_TYPE_CODE=b.SUSPEND_TYPE_CODE AND a.comp_code=b.comp_code 
    --and b.user_code=@puserid
    and b.user_role=@pextra1  
    where a.comp_code=@pcompcode 
    and case isnull(block_reason,'N')
    when '' then 'N' else isnull(block_reason,'N') end= @pblockunblock 

////////////////////////////////////end//////////////////////////////////////

****************************add by Deepika 29/09/2012***************


ALTER PROCEDURE [dbo].[cir_inct_net_sale_report]
	@pcomp_code		VARCHAR(20) ,
	@punit_code     VARCHAR(20) ,
	@pmonth         VARCHAR(20) ,
	@pyear          VARCHAR(20) ,
	@pdateformat    VARCHAR(20) ,
	@pbranch        varchar(20),
	@pagtype        varchar(20),
	@pagclass       varchar(20),
	@pagcode        varchar(20),
	@pdpcode        varchar(20),
	@ppubl          varchar(50)=null,
    @ppubl_type      varchar(50)=null,
	@pextra1        varchar(200),--S SUMMARY,D-DETAIL
	@pextra2        varchar(200),
	@pextra3        varchar(200),
	@pextra4        varchar(200),
	@pextra5        varchar(200)

--EXEC cir_inct_net_sale_report 'UM001','BA0','08','2012','dd/mm/yyyy','','','','','','','','','','','',''
AS 
begin
	DECLARE @vfrdt         VARCHAR(20)
	DECLARE @vtodt         VARCHAR(20)
	DECLARE @vtodt1         VARCHAR(20)
	SET @vfrdt=(@pmonth+'/'+'01/'+@pyear) 	
		SET @vtodt1=([dbo].[GetLastDayOfMonth](@vfrdt))	
		set @vtodt=SUBSTRING(@vtodt1,5,2)	
	SET @vtodt=(@pmonth+'/'+@vtodt+'/'+@pyear) 
	declare @preturn_based varchar(1)
	set @preturn_based='S'


      
            

declare c1 cursor for 

select u.comp_code,u.unit_code,
		u.branch_code branch_code,(select distinct Branch_Name from branch_mst where Branch_Code=u.branch_code) branch_name,
		u.publ,u.publ_name,u.main_edtn,
		dbo.cir_get_edtn_name(u.comp_code,u.main_edtn) main_edtn_name,u.edtn edtn,u.edtn_name,u.copy_rate,
		u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,
		u.state_code,dbo.cir_get_state(u.comp_code,u.country_code,u.state_code) state_name,
		u.dist_code ,dbo.cir_get_name_cir_district(u.comp_code,u.dist_code,'1',null,null,null) dist_name,
		u.city_code city_code,dbo.cir_get_name_cir_city(u.comp_code,u.city_code,'1',null,null,null) city_name,
		u.tehsil_taluka,dbo.cir_get_name_cir_taluka(u.comp_code,u.tehsil_taluka,'1',null,null,null) taluka_name,
		u.route_code,dbo.cir_get_route_name(u.comp_code,u.unit_code,u.route_code ) route_name,
		sum(supply_copy) supply_copy,sum(return_copy) return_copy,
		sum(supply_copy)-sum(return_copy) net_sale_copy,sum(no_of_days) no_of_days
		,dbo.cir_get_unit_name(u.comp_code,u.unit_code) as UNIT_NAME
		,u.comm_cat as COM_CAT,u.supdate SUPDATE,SUM(u.formon_gross) FORMON_GROSS,SUM(u.formon_return) FORMON_RETURN
		
		from (
		select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate copy_rate,
		b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
		a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka, b.route_code, 
		sum(isnull(b.sup_copy,0)) supply_copy,0 return_copy, 0 no_of_days
		,b.comm_code comm_cat,b.supdate
		,(select sum(sup_copy) from CIR_DBKSUP b1 where b1.supdate between @vfrdt and @vtodt
		and b1.comp_code=@pcomp_code and (b1.unit_code=@punit_code or @punit_code is null or @punit_code ='')and  (b1.publ=isnull(@ppubl,b1.publ) or @ppubl='') and (b1.agcd=isnull(@pagcode,b1.agcd) or @pagcode='') and (b1.dpcd=isnull(@pdpcode,b1.dpcd) or @pdpcode='')
		 and  b.comp_code=b1.comp_code and b.unit_code=b1.unit_code and b.agcd=b1.agcd and b.dpcd=b1.dpcd and b.supdate=b1.supdate and b.publ=b1.publ and b.edtn=b1.edtn 
		  )as formon_gross,0 formon_return
		from cir_agmast a,CIR_DBKSUP b,cir_edtn_mast e,cir_publ_mast p	,CIR_INCT_NET_SALE i	
		where 
	
		/*added*/
		a.comp_code=i.comp_code and b.comp_code=i.comp_code and e.comp_code=i.comp_code and p.comp_code=i.comp_code and
		a.unit=i.unit_code and b.unit_code=i.unit_code and 
		a.agcd=i.agcd and b.agcd=i.agcd and
		a.dpcd=i.dpcd and b.dpcd=i.dpcd and
		(p.publ=isnull(i.publ,p.publ) or i.publ='')and (b.publ=isnull(i.publ,b.publ) or i.publ='')and	
		p.pro_type=i.publ_type and
		target_month between @vfrdt and @vtodt and
		b.supdate between  CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(BASE_MONTH)-1),BASE_MONTH),101)  and 
              CONVERT(VARCHAR(25),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,BASE_MONTH)+1,0)),101) AND	
		/*added*/
		b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and 
		b.comp_code =@pcomp_code and 
		b.unit_code=a.unit and (b.unit_code=@punit_code or @punit_code is null or @punit_code ='') and 
		b.publ=p.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and b.edtn=e.edtn  and
		a.agcd=b.agcd and (b.agcd=isnull(@pagcode,b.agcd) or @pagcode='') 
		and a.dpcd=b.dpcd and (b.dpcd=isnull(@pdpcode,b.dpcd) or @pdpcode='') 
		and	(a.ag_type=@pagtype or @pagtype is null or @pagtype='') 
		and(a.ag_class=@pagclass or @pagclass is null or @pagclass='') 
		and	(a.branch_code=@pbranch or @pbranch is null or @pbranch='')  		
		group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate,
		b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
		a.country_code,a.tehsil_taluka,b.route_code,b.comm_code,b.supdate
		union all
		select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
		b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
		a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka,d.route_code,  
		0 supply_copy,sum(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0)) 
		return_copy,0 no_of_days
		,d.comm_code comm_cat,b.supdate
		,0 as formon_gross,
		(select sum(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0))  from cir_unsold_dtl b1 where 
		 (b1.supdate >= @vfrdt and b.supdate <=@vtodt and isnull(@preturn_based,'R') ='S')
		and b1.comp_code=@pcomp_code and (b1.unit_code=@punit_code or @punit_code is null or @punit_code ='')and  (b1.publ=isnull(@ppubl,b1.publ) or @ppubl='') and (b1.agcd=isnull(@pagcode,b1.agcd) or @pagcode='') and (b1.dpcd=isnull(@pdpcode,b1.dpcd) or @pdpcode='')		
		 and b1.comp_Code=b.comp_code and b1.unit_code=b.unit_code and b1.agcd=b.agcd and b1.dpcd=b.dpcd and 
		 b.supdate=b1.supdate and b.publ=b1.publ and b.edtn=b1.edtn
		 )as formon_return
		from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e,cir_publ_mast p,cir_dbksup d	,CIR_INCT_NET_SALE i	
		where 
		
		/*added*/
		a.comp_code=i.comp_code and d.comp_code=i.comp_code and e.comp_code=i.comp_code and p.comp_code=i.comp_code and b.comp_code=i.comp_code and
		a.unit=i.unit_code and d.unit_code=i.unit_code and  b.unit_code=i.unit_code and 
		a.agcd=i.agcd and d.agcd=i.agcd and b.agcd=i.agcd and
		a.dpcd=i.dpcd and d.dpcd=i.dpcd and b.dpcd=i.dpcd and
		(p.publ=isnull(i.publ,p.publ) or i.publ='')and (d.publ=isnull(i.publ,d.publ) or i.publ='')and	
		(b.publ=isnull(i.publ,b.publ) or i.publ='')and
		p.pro_type=i.publ_type and
		target_month between @vfrdt and @vtodt and
       ((b.recptdt >= CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(BASE_MONTH)-1),BASE_MONTH),101) and b.recptdt <=CONVERT(VARCHAR(25),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,BASE_MONTH)+1,0)),101) and isnull(@preturn_based,'R') ='R') 
		or (b.supdate >= CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(BASE_MONTH)-1),BASE_MONTH),101) and b.supdate <=CONVERT(VARCHAR(25),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,BASE_MONTH)+1,0)),101) and isnull(@preturn_based,'R') ='S')) and 
		/*added*/
		
		b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and b.comp_code =@pcomp_code and 
		b.unit_code=a.unit and (b.unit_code=@punit_code or @punit_code is null or @punit_code ='') and  
		b.doctype='UCN' and
		-- ((b.recptdt >= @vfrdt and b.recptdt <=@vtodt and isnull(@preturn_based,'R') ='R') 
		--or (b.supdate >= @vfrdt and b.supdate <=@vtodt and isnull(@preturn_based,'R') ='S')) and 
			b.comp_code  = d.comp_code
		and 	b.UNIT_CODE  = d.UNIT_CODE
		and 	b.agcd  = d.agcd
		and 	b.DPCD  = d.DPCD and
		b.SUPDATE=d.SUPDATE and
		b.publ=d.publ and b.edtn=d.edtn and a.agcd=d.agcd and a.dpcd=d.dpcd and
		b.publ=e.publ and b.publ=p.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and b.edtn=e.edtn and 
		a.agcd=b.agcd and (b.agcd=isnull(@pagcode,b.agcd) or @pagcode='') and a.dpcd=b.dpcd and (b.dpcd=isnull(@pdpcode,b.dpcd) or @pdpcode='') and
		(a.ag_type=@pagtype or @pagtype is null or @pagtype='') and(a.ag_class=@pagclass or @pagclass is null or @pagclass='') and
		(a.branch_code=@pbranch or @pbranch is null or @pbranch='')  and
		(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 
		group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
		b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
		a.country_code,a.tehsil_taluka,d.route_code ,d.comm_code,b.supdate) u
		where (u.supply_copy+u.return_copy)>0
		group by u.comp_code,u.unit_code,u.branch_code,u.publ,u.publ_name,u.main_edtn,u.edtn,u.edtn_name,u.copy_rate,
		u.agcd,u.dpcd,u.agname,u.agname_oth_lang,u.state_code,u.dist_code ,u.city_code,u.tehsil_taluka,u.route_code,
		u.country_code,u.comm_cat,u.supdate; 
		
		
	
	CREATE TABLE #CIR_TEMP_BILL_COLLECTION
	( COMP_CODE        VARCHAR(100),
	  UNIT_CODE        VARCHAR(100),
	  BILLNO           VARCHAR(200),
	  BILLDT           DATETIME,
	  PUBL_CODE        VARCHAR(100),
	  AGCD             VARCHAR(100),
	  DPCD             VARCHAR(100),
	  SUPPLY_COPY      NUMERIC(10)                   DEFAULT 0,
	 
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
	  REGION          VARCHAR(500),
	  RET_COMM_AMT     NUMERIC(15,2),
	  BILL_SEC_AMT     NUMERIC(15,2),
	  SEC_OPBAL        NUMERIC(15,2),
	  zone_code        VARCHAR(200),
	  region_code        VARCHAR(200),
	  pro_type        VARCHAR(200),
	  route_code      VARCHAR(200),
	  copy_rate			numeric(14,2),
	  no_of_days		numeric(10),
	  unit_name			varchar(150),
	  COM_CAT           varchar(150),
	  supdate           datetime,	
		PUBL          varchar(150),
		EDTN  VARCHAR(20),
		[GROSS_AMT] [numeric](38, 2) NULL,
		[NET_AMT] [numeric](38, 2) NULL,
		PROD_CODE VARCHAR(100)
	  )
	  DECLARE @v_hdays	AS	NUMERIC(5) 
	DECLARE @v_avg_sale AS  NUMERIC(10) 
	DECLARE @v_reg_code AS  varchar(200)
	DECLARE @v_zone_code varchar(200);
	DECLARE @v_publ_code varchar(200);
	DECLARE @v_route_code varchar(200);

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
    DECLARE @v1_route_code   		as varchar(50)
    DECLARE @v1_route_name			as varchar(150)
    DECLARE @v1_supply_copy			as int
    DECLARE @v1_return_copy			as int
    DECLARE @v1_net_sale_copy		as int
    DECLARE @v1_no_of_days			as int
    DECLARE @v1_unit_name			as varchar(150)
    DECLARE @v1_COM_CAT  			as varchar(150)
    declare @v1_supdate				as datetime
    
       DECLARE @v1_formon_gross  			as numeric(30)
       DECLARE @v1_formon_return  			as  numeric(30)
       
declare @v_day varchar(20)
declare @v_rate numeric(20,2)
declare @v_com numeric(20,2)
declare @v_com_type varchar(20)
declare @v_gross numeric(20,2)
declare @v_billamt numeric(20,2)
declare @v_grossbillamt numeric(20,2)
declare @v_netbillamt numeric(20,2)
declare @v_pro_code varchar(20)
declare @b2_publ varchar(20)
declare @b2_edtn varchar(20)
declare @b2_comm varchar(20)
declare @b2_supdate datetime
	OPEN c1 
	
	
        fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code, @v1_branch_code, @v1_branch_name,@v1_publ, @v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,@v1_edtn,@v1_edtn_name,@v1_copy_rate, @v1_agcd, @v1_dpcd,@v1_agname,@v1_agname_oth_lang,@v1_state_code,@v1_state_name,@v1_dist_code,@v1_dist_name,@v1_city_code,@v1_city_name, @v1_tehsil_taluka,@v1_taluka_name,@v1_route_code,@v1_route_name,@v1_supply_copy,@v1_return_copy,@v1_net_sale_copy, @v1_no_of_days,@v1_unit_name,@v1_COM_CAT,@v1_supdate,@v1_formon_gross,@v1_formon_return
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN 	
   
			If isnull(@v1_no_of_days,0)>0 Begin
                set @v_avg_sale=round(isnull(@v1_net_sale_copy,0)/(isnull(@v1_no_of_days,0)),0)
            End    
            Else Begin
                set @v_avg_sale=isnull(@v1_net_sale_copy,0)
            End

            select distinct @v_reg_code=region_code,@v_zone_code=zone_code from cir_city_mast where comp_code=@v1_comp_code and city_code=@v1_city_code            
            if(@v_reg_code='')
            begin
				set @v_reg_code=null
            end
           
            if(@v_zone_code='')
            begin
				set @v_zone_code=null
            end
            
            select distinct @v_publ_code=pro_type from cir_publ_mast where comp_code=@v1_comp_code and publ=@v1_publ;
            if(@v_publ_code='')
            begin
				set @v_publ_code=null
            end
            set @v_pro_code=@v_publ_code
            select distinct @v1_COM_CAT=COMM_CATG_DESC from CIR_COMM_CATG_MAST where comp_code=@v1_comp_code and COMM_CATG_CODE=@v1_COM_CAT            
            if(@v1_COM_CAT='')
            begin
				set @v1_COM_CAT=null
            end
            
            
            set @v_reg_code=dbo.cir_get_region_name(@v1_comp_code,@v_reg_code)
            set @v_zone_code=dbo.cir_get_zone_name(@v1_comp_code, @v_zone_code); 
			set @v_publ_code=dbo.cir_publ_type(@v1_comp_code,@v_publ_code,null,null);
            
            
            
  set @v_gross=0
  set @v_com=0
  set @v_grossbillamt=0
  set @v_netbillamt=0
  set @v_rate=0
set @v_com=0

         declare c_sup cursor for   
select  publ, edtn,comm_code,supdate from cir_dbksup where-- supdate between  @vfrdt and @vtodt and
 comp_code=@pcomp_code and UNIT_CODE=@punit_code and AGCD=@v1_agcd and dpcd=@v1_dpcd and ROUTE_CODE=@v1_route_code

 
            open c_sup 
            fetch next from c_sup into @b2_publ , @b2_edtn,@b2_comm  ,@b2_supdate
            while(@@FETCH_STATUS=0)begin
            
         
        set @v_day=upper(DATENAME(dw,@b2_supdate))
	    select @v_rate= case @v_day
		when 'SUNDAY' then SUM(isnull(SUN_RATE,0))
		when 'MONDAY' then SUM(isnull(MON_RATE,0))
		when 'TUESDAY' then SUM(isnull(TUE_RATE,0))
		when 'WEDNESDAY' then SUM(isnull(WED_RATE,0))
		when 'THURSDAY' then SUM(isnull(THU_RATE,0))
		when 'FRIDAY' then SUM(isnull(FRI_RATE,0))
		when 'SATURDAY' then SUM(isnull(SAT_RATE,0)) end		
		from CIR_RATE_MAST where COMP_CODE=@v1_comp_code and UNIT=@v1_unit_code and PUBL=@b2_publ and EDTN=@b2_edtn

        
		select @v_com=case @v_day
			when 'SUNDAY' then SUM(isnull(SUN_COMM_RATE,0))
		when 'MONDAY' then SUM(isnull(MON_COMM_RATE,0))
		when 'TUESDAY' then SUM(isnull(TUE_COMM_RATE,0))
		when 'WEDNESDAY' then SUM(isnull(WED_COMM_RATE,0))
		when 'THURSDAY' then SUM(isnull(THU_COMM_RATE,0))
		when 'FRIDAY' then SUM(isnull(FRI_COMM_RATE,0))
		when 'SATURDAY' then SUM(isnull(SAT_COMM_RATE,0)) end		
		,@v_com_type=COMM_CATG_TYPE from CIR_COMM_MAST 
		where COMP_CODE=@v1_comp_code and UNIT_CODE=@v1_unit_code and PUBL=@b2_publ and EDTN=@b2_edtn and COMM_CATG_CODE=@b2_comm
		group by COMP_CODE,UNIT_CODE,COMM_CATG_TYPE
	
		if @v_com_type='P'
		begin
	
			set @v_gross = isnull(@v1_formon_gross,0)*isnull(@v_rate,0)
			set @v_com=isnull(@v_gross,0)*ISNULL(@v_com,0)/100
		end
		else
		begin
	
			set @v_gross = isnull(@v1_formon_gross,0)*isnull(@v_rate,0)
	
			set @v_com=isnull(@v1_formon_gross,0)*ISNULL(@v_com,0)
			
		end
set @v_grossbillamt=@v_grossbillamt+ISNULL(@v_gross,0)-ISNULL(@v_com,0) 

            if @v_com_type='P'
		begin
			set @v_gross =(isnull(@v1_formon_gross,0)-ISNULL(@v1_formon_return,0))*isnull(@v_rate,0)
			set @v_com=isnull(@v_gross,0)*ISNULL(@v_com,0)/100
		end
		else
		begin
			set @v_gross = (isnull(@v1_formon_gross,0)-ISNULL(@v1_formon_return,0))*isnull(@v_rate,0)
			set @v_com=(isnull(@v1_formon_gross,0)-ISNULL(@v1_formon_return,0))*ISNULL(@v_com,0)
		end
   
    set @v_netbillamt   =@v_netbillamt+ISNULL(@v_gross,0)-ISNULL(@v_com,0)     

   fetch next from c_sup into @b2_publ , @b2_edtn,@b2_comm  ,@b2_supdate
   end
 close c_sup
 deallocate c_sup
 
 
            insert into #cir_temp_bill_collection
				(comp_code, unit_code, billno, publ_code, agcd, dpcd,agname,agname_oth_lang, city_code, 
				taluka_code, dist_code, state_code, REGION,supply_copy, return_copy ,copy_rate,no_of_days,zone_code, region_code,pro_type,route_code
				,unit_name,COM_CAT,PUBL,supdate,EDTN,GROSS_AMT,NET_AMT,PROD_CODE)
            values(@v1_comp_code,@v1_unit_code,@v1_branch_name,@v1_publ_name,@v1_agcd,@v1_dpcd,@v1_agname,@v1_agname_oth_lang,@v1_city_name,
				@v1_taluka_name,@v1_dist_name,@v1_state_name,@v_reg_code,@v1_supply_copy,@v1_return_copy,@v1_copy_rate,@v1_no_of_days,@v_zone_code,@v_reg_code,@v_publ_code,@v1_route_name
				,@v1_unit_name,@v1_COM_CAT,@v1_publ,@v1_supdate,@v1_edtn,@v_grossbillamt,@v_netbillamt,@v_pro_code)
            
		    fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code, @v1_branch_code, @v1_branch_name,@v1_publ, @v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,@v1_edtn,@v1_edtn_name,@v1_copy_rate, @v1_agcd, @v1_dpcd,@v1_agname,@v1_agname_oth_lang,@v1_state_code,@v1_state_name,@v1_dist_code,@v1_dist_name,@v1_city_code,@v1_city_name, @v1_tehsil_taluka,@v1_taluka_name,@v1_route_code,@v1_route_name,@v1_supply_copy,@v1_return_copy,@v1_net_sale_copy, @v1_no_of_days,@v1_unit_name,@v1_COM_CAT,@v1_supdate,@v1_formon_gross,@v1_formon_return
		
		END 
		close c1
		DEALLOCATE c1
              -- select * from  #cir_temp_bill_collection
              DECLARE @c2_comp_code varchar(50)
              DECLARE @c2_unit_code varchar(50)
              DECLARE @c2_branch_code varchar(50)
              DECLARE @c2_agcd varchar(50)
              DECLARE @c2_dpcd varchar(50)
              DECLARE @c2_agname varchar(50)
              DECLARE @c2_region_code varchar(50)
              DECLARE @c2_zone_code varchar(50)
              DECLARE @c2_publ varchar(50)
                DECLARE @c2_publ_code varchar(50)
              DECLARE @c2gross numeric(20,2)
              DECLARE @c2_return numeric(20,2)
              DECLARE @c2_net numeric(20,2)
              DECLARE @c2_grossamt numeric(20,2)
              DECLARE @c2_netamt numeric(20,2)
               DECLARE @c2_supdate datetime
                DECLARE @c2_commcat varchar(50)
              DECLARE @c2_edtn varchar(50)
              
              
CREATE TABLE #CIR_INCT_NET_SALE_TEMP(
	[COMP_CODE] [varchar](8) NULL,
	[UNIT_CODE] [varchar](8) NULL,
	[BRANCH_CODE] [varchar](50) NULL,
	[AGCD] [varchar](10) NULL,
	[DPCD] [varchar](10) NULL,
	[AG_NAME] [varchar](1000) NULL,
	[REGION] [varchar](100) NULL,
	[ZONE] [varchar](100) NULL,
	[INCT_BASE] [varchar](1) NULL,
	[PUBL] [varchar](50) NULL,
	[BASE_DATE] [datetime] NULL,
	[TARGET_DATE] [datetime] NULL,	
	[GROSS_SUPPLY] [int] NULL,
	[NET_SUPPLY] [INT] NULL,
	[GROSS_AMT] [numeric](38, 2) NULL,
	[NET_AMT] [numeric](38, 2) NULL,
	[TRGT_BASE] [varchar](1) NULL,
	[INCT_PER] [numeric](38, 2) NULL,
	[INCT_AMT] [numeric](38, 2) NULL,
	PUBL_CODE VARCHAR(100),
	EDTN VARCHAR(100),
	[GROSS_ACHVD] [numeric](38, 2) NULL,
	[NET_ACHVD] [numeric](38, 2) NULL,
	[TGT_RET] [numeric](38, 2) NULL,
	[TGT] [numeric](38, 2) NULL,	
	[BASE_GROSS] [numeric](38, 2) NULL,
	[BASE_NET] [numeric](38, 2) NULL,
	[TARGET_GROSS] [numeric](38, 2) NULL,
	[TARGET_NET] [numeric](38, 2) NULL,
	TOT_GROSS_NET NUMERIC(38,2)
	
) 

            DECLARE C2 CURSOR FOR
            select comp_code AS COMP_CODE, unit_code AS UNIT,billno BRANCH,agcd,dpcd,agname AG_NAME,region_code REGION_CODE,zone_code ZONE_CODE,
                publ_code AS PUBL_NAME,  PUBL,             
                sum(supply_copy) AS GROSS_SUPPLY, 
                sum(return_copy) AS RETURN_COPY ,
                (sum(supply_copy)-sum(return_copy)) AS NET_SUPPLY,supdate,COM_CAT,EDTN
                ,SUM(GROSS_AMT) GROSS_AMT,SUM(NET_AMT)NET_AMT,PROD_CODE
                from #cir_temp_bill_collection  
                group by comp_code,unit_code,billno,region_code,zone_code,agname,publ_code,PUBL,agcd,dpcd,supdate,COM_CAT,EDTN,PROD_CODE
                order by publ_code
                

		declare @p_inct_base varchar(1)
		declare @p_trgt_base varchar(1)
		declare @p_basemon datetime
		declare @p_trgtmon datetime
		declare @p_trgt_inct numeric(20,2)
		declare @p_trgt_ret  numeric(20,2)
		declare @p_trgt_per  numeric(20,2)

		declare @p_base_gross numeric(20,2)
		--declare @p_base_net  numeric(20,2)
		declare @p_trgt_gross  numeric(20,2)          
		--declare @p_trgt_net  numeric(20,2)

		declare @p_gross_amt  numeric(20,2)
		declare @p_net_amt  numeric(20,2)

        
          declare @v_target_gross numeric(20)
          declare @v_target_net numeric(20)
           declare @v_target_inct numeric(20)
              declare @v_target_inctamt numeric(20,2)
          declare @v_CNT INT
           declare @v_prod_code varchar(200)
          
            DECLARE @p2_base_gross_amt			as numeric(38,2)
            	declare @tot_gross_net numeric(38,2)	
  --DECLARE @p2_base_net_amt			as numeric(38,2)
  DECLARE @p2_target_gross_amt			as numeric(38,2)
  --DECLARE @p2_target_net_amt			as numeric(38,2)

              OPEN C2
              FETCH NEXT FROM C2 INTO @c2_comp_code,@c2_unit_code,@c2_branch_code,@c2_agcd,@c2_dpcd,@c2_agname,@c2_region_code,@c2_zone_code,@c2_publ,@c2_publ_code,@c2gross,@c2_return,@c2_net,@c2_supdate,@c2_commcat,@c2_edtn,@p_gross_amt,@p_net_amt,@v_prod_code
              WHILE(@@FETCH_STATUS=0)BEGIN
             
              SET @v_CNT=0
              SET @p_inct_base=NULL
              SET @p_trgt_inct=0
              SET @v_target_gross=0
              SET @v_target_net=0
              SET @p_trgt_ret=0
              SET @p_trgt_base=NULL
              SET @v_target_inct=0
              SET @p_trgt_per=0
               set @v_com=0
              SET @v_rate=0
              SET @v_com_type=NULL
              SET @v_gross=0
              SET @v_grossbillamt=0
              SET @v_netbillamt=0
              SET @v_target_inctamt=0
              set @tot_gross_net=0
               select @p_inct_base=INCT_BASE,@p_basemon=BASE_MONTH,@p_trgtmon=TARGET_MONTH,@p_trgt_inct=TRGT_INCT,@p_trgt_ret=TRGT_RET,
              @p_trgt_per=TRGT_PER,@p_trgt_base=trgt_base,@v_CNT=COUNT(*) from CIR_INCT_NET_SALE
              where COMP_CODE=@c2_comp_code and UNIT_CODE=@c2_unit_code and AGCD=@c2_agcd and DPCD=@c2_dpcd
              and (ISNULL(publ,@c2_publ_code)=@c2_publ_code or publ='')
              and   @c2_supdate between  CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(BASE_MONTH)-1),BASE_MONTH),101)  and 
              CONVERT(VARCHAR(25),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,BASE_MONTH)+1,0)),101)
              AND publ_type=@v_prod_code
              GROUP BY INCT_BASE,BASE_MONTH,TARGET_MONTH,TRGT_INCT,TRGT_RET,
              TRGT_PER,trgt_base
              
             
             
              IF(@v_CNT>0)BEGIN
              
              
             
              
         --1000     
if(@p_inct_base='N')begin
set @v_target_gross=round((@c2_net*@p_trgt_inct)/100,0)--100
set @v_target_gross=ISNULL(@c2_net,0)+@v_target_gross--1100

set @p_base_gross=round((@c2_net*@p_trgt_inct)/100,0)
set @p_base_gross=ISNULL(@c2_net,0)+@p_base_gross


end
else begin
set @v_target_gross=round((@c2gross*@p_trgt_inct)/100,0)
set @v_target_gross=ISNULL(@c2gross,0)+@v_target_gross

set @p_base_gross=round((@c2gross*@p_trgt_inct)/100,0)
set @p_base_gross=ISNULL(@c2gross,0)+@p_base_gross


end
PRINT('@c2gross')
PRINT(@c2gross)
 set @v_target_net=round((@v_target_gross*@p_trgt_ret)/100,0)--165
set @v_target_net=@v_target_gross-@v_target_net--935

     set @p_trgt_gross=round((@p_base_gross*@p_trgt_ret)/100,0)--165
set @p_trgt_gross=@p_base_gross-@p_trgt_gross
   

		
		if(@p_trgt_base='N')
		begin
			set @v_target_inct=round((@v_target_net*@p_trgt_per)/100,0)--100
		end
		else 
		begin
			set @v_target_inct=round((@v_target_gross*@p_trgt_per)/100,0)
		end
              
set @v_day=upper(DATENAME(dw,@c2_supdate))

select @v_rate= case @v_day
when 'SUNDAY' then SUM(isnull(SUN_RATE,0))
when 'MONDAY' then SUM(isnull(MON_RATE,0))
when 'TUESDAY' then SUM(isnull(TUE_RATE,0))
when 'WEDNESDAY' then SUM(isnull(WED_RATE,0))
when 'THURSDAY' then SUM(isnull(THU_RATE,0))
when 'FRIDAY' then SUM(isnull(FRI_RATE,0))
when 'SATURDAY' then SUM(isnull(SAT_RATE,0)) end		
from CIR_RATE_MAST where COMP_CODE=@c2_comp_code and UNIT=@c2_unit_code and PUBL=@c2_publ_code and EDTN=@c2_edtn
       
		select @v_com=case @v_day
			when 'SUNDAY' then SUM(isnull(SUN_COMM_RATE,0))
		when 'MONDAY' then SUM(isnull(MON_COMM_RATE,0))
		when 'TUESDAY' then SUM(isnull(TUE_COMM_RATE,0))
		when 'WEDNESDAY' then SUM(isnull(WED_COMM_RATE,0))
		when 'THURSDAY' then SUM(isnull(THU_COMM_RATE,0))
		when 'FRIDAY' then SUM(isnull(FRI_COMM_RATE,0))
		when 'SATURDAY' then SUM(isnull(SAT_COMM_RATE,0)) end		
		,@v_com_type=COMM_CATG_TYPE from CIR_COMM_MAST 
		where COMP_CODE=@c2_comp_code and UNIT_CODE=@c2_unit_code and PUBL=@c2_publ_code and EDTN=@c2_edtn and COMM_CATG_CODE=@c2_commcat
		group by COMP_CODE,UNIT_CODE,COMM_CATG_TYPE
	
	PRINT('@v_target_gross')
	PRINT(@v_target_gross)
				if @v_com_type='P'
				begin	
					set @v_gross = isnull(@v_target_gross,0)*isnull(@v_rate,0)
					set @v_com=isnull(@v_gross,0)*ISNULL(@v_com,0)/100
				end
				else
				begin

					set @v_gross = isnull(@v_target_gross,0)*isnull(@v_rate,0)	
					set @v_com=isnull(@v_target_gross,0)*ISNULL(@v_com,0)
					
				end
				set @v_grossbillamt=ISNULL(@v_gross,0)-ISNULL(@v_com,0) 
PRINT('@v_grossbillamt')
PRINT(@v_grossbillamt)
				if @v_com_type='P'
				begin	
					set @v_gross = isnull(@v_target_net,0)*isnull(@v_rate,0)
					set @v_com=isnull(@v_gross,0)*ISNULL(@v_com,0)/100
				end
				else
				begin
					set @v_gross = isnull(@v_target_net,0)*isnull(@v_rate,0)	
					set @v_com=isnull(@v_target_net,0)*ISNULL(@v_com,0)
				end
   
				set @v_netbillamt   =ISNULL(@v_gross,0)-ISNULL(@v_com,0)
              
				if @v_com_type='P'
				begin	
					set @v_gross = isnull(@v_target_inct,0)*isnull(@v_rate,0)
					set @v_com=isnull(@v_gross,0)*ISNULL(@v_com,0)/100
				end
				else
				begin
					set @v_gross = isnull(@v_target_inct,0)*isnull(@v_rate,0)	
					set @v_com=isnull(@v_target_inct,0)*ISNULL(@v_com,0)
				end
   
				set @v_target_inctamt   =ISNULL(@v_gross,0)-ISNULL(@v_com,0)
				/*base and target*/
            
				if @v_com_type='P'
				begin	
					set @v_gross = isnull(@p_base_gross,0)*isnull(@v_rate,0)
					set @v_com=isnull(@v_gross,0)*ISNULL(@v_com,0)/100
				end
				else
				begin
					set @v_gross = isnull(@p_base_gross,0)*isnull(@v_rate,0)	
					set @v_com=isnull(@p_base_gross,0)*ISNULL(@v_com,0)
				end
				
				set @p2_base_gross_amt=ISNULL(@v_gross,0)-ISNULL(@v_com,0) 
							
				
				if @v_com_type='P'
				begin	
					set @v_gross = isnull(@p_trgt_gross,0)*isnull(@v_rate,0)
					set @v_com=isnull(@v_gross,0)*ISNULL(@v_com,0)/100
				end
				else
				begin
					set @v_gross = isnull(@p_trgt_gross,0)*isnull(@v_rate,0)	
					set @v_com=isnull(@p_trgt_gross,0)*ISNULL(@v_com,0)
				end
				set @p2_target_gross_amt=ISNULL(@v_gross,0)-ISNULL(@v_com,0)										
						
						
						
						
						
						
				
						if(@p_inct_base='N')begin 
							set @tot_gross_net=@c2_net
						end
						else begin
						set @tot_gross_net=@c2gross
						end
			if @v_com_type='P'
				begin	
					set @v_gross = isnull(@tot_gross_net,0)*isnull(@v_rate,0)
					set @v_com=isnull(@v_gross,0)*ISNULL(@v_com,0)/100
				end
				else
				begin
					set @v_gross = isnull(@tot_gross_net,0)*isnull(@v_rate,0)	
					set @v_com=isnull(@tot_gross_net,0)*ISNULL(@v_com,0)
				end
				set @tot_gross_net=ISNULL(@v_gross,0)-ISNULL(@v_com,0)		
			
			
              /*base and target*/
              INSERT INTO   #CIR_INCT_NET_SALE_TEMP(COMP_CODE,UNIT_CODE,BRANCH_CODE,AGCD,DPCD,AG_NAME,REGION,ZONE,INCT_BASE,PUBL,BASE_DATE,
              TARGET_DATE,GROSS_SUPPLY,NET_SUPPLY,GROSS_AMT,NET_AMT,TRGT_BASE,INCT_PER,INCT_AMT,PUBL_CODE,EDTN,
              GROSS_ACHVD,NET_ACHVD,TGT_RET,TGT,BASE_GROSS,TARGET_GROSS,TOT_GROSS_NET)
              VALUES(@c2_comp_code,@c2_unit_code,@c2_branch_code,@c2_agcd,@c2_dpcd,@c2_agname,@c2_region_code,@c2_zone_code,@p_inct_base,@c2_publ,@p_basemon,
              @p_trgtmon,@v_target_gross,@v_target_net,@v_grossbillamt,@v_netbillamt,@p_trgt_base,@p_trgt_per,@v_target_inctamt,@c2_publ_code,@c2_edtn,
              @p_gross_amt,@p_net_amt,@p_trgt_ret,@p_trgt_inct,@p2_base_gross_amt,@p2_target_gross_amt,@tot_gross_net)
		  END
		  FETCH NEXT FROM C2 INTO @c2_comp_code,@c2_unit_code,@c2_branch_code,@c2_agcd,@c2_dpcd,@c2_agname,@c2_region_code,@c2_zone_code,@c2_publ,@c2_publ_code,@c2gross,@c2_return,@c2_net,@c2_supdate,@c2_commcat,@c2_edtn,@p_gross_amt,@p_net_amt,@v_prod_code
	  END
	  CLOSE C2
	  DEALLOCATE C2
              
              
              
              if(@pextra1='S')
              BEGIN
				  select   distinct COMP_CODE,UNIT_CODE,BRANCH_CODE,AGCD,DPCD,AG_NAME,REGION,ZONE,INCT_BASE,--PUBL_CODE,PUBL,EDTN,
				  BASE_DATE,DATEPART(yyyy,BASE_DATE) AS BASE_YEAR,
				  DATEPART(mm,BASE_DATE) AS BASE_MONTH ,
				  DATEPART(yyyy,TARGET_DATE) AS TARGET_YEAR,
				  DATEPART(mm,TARGET_DATE) AS TARGET_MONTH ,
				  TARGET_DATE,
				  DateName( month , DateAdd( month ,  DATEPART(mm,TARGET_DATE) , 0 ) - 1 ) FOR_MONTH,
				  sum(isnull(GROSS_SUPPLY,0))GROSS_SUPPLY,sum(isnull(NET_SUPPLY,0))NET_SUPPLY,sum(isnull(GROSS_AMT,0))GROSS_AMT,
				  sum(isnull(NET_AMT,0))NET_AMT,TRGT_BASE,INCT_PER,sum(isnull(INCT_AMT,0))INCT_AMT 
				  ,SUM(isnull(GROSS_ACHVD,0)) GROSS_ACHVD,SUM(isnull(NET_ACHVD,0)) NET_ACHVD,TGT_RET,
				  SUM(isnull(BASE_GROSS,0))BASE_GROSS,SUM(isnull(BASE_NET,0))BASE_NET,SUM(isnull(TARGET_GROSS,0))TARGET_GROSS,SUM(isnull(TARGET_NET,0))TARGET_NET	             
				  from   #CIR_INCT_NET_SALE_TEMP
				  group by COMP_CODE,UNIT_CODE,BRANCH_CODE,AGCD,DPCD,AG_NAME,REGION,ZONE,INCT_BASE,BASE_DATE,TARGET_DATE,
				  TRGT_BASE,INCT_PER,TGT_RET
              END
              else 
              BEGIN
				  select   distinct COMP_CODE,UNIT_CODE,BRANCH_CODE,AGCD,DPCD,AG_NAME,REGION,ZONE,INCT_BASE,PUBL_CODE,PUBL,--EDTN,
				  BASE_DATE, DateName( month , DateAdd( month ,  DATEPART(mm,BASE_DATE) , 0 ) - 1 ) BASE_MONTH,
				  TARGET_DATE,DateName( month , DateAdd( month ,  DATEPART(mm,TARGET_DATE) , 0 ) - 1 ) TARGET_MONTH,
				  sum(isnull(GROSS_SUPPLY,0))GROSS_SUPPLY,sum(isnull(NET_SUPPLY,0))NET_SUPPLY,sum(isnull(GROSS_AMT,0))GROSS_AMT,
				  sum(isnull(NET_AMT,0))NET_AMT,TRGT_BASE,INCT_PER,sum(isnull(INCT_AMT,0))INCT_AMT 
				 ,SUM(isnull(GROSS_ACHVD,0)) GROSS_ACHVD,SUM(isnull(NET_ACHVD,0)) NET_ACHVD,TGT_RET,TGT,
				   SUM(isnull(BASE_GROSS,0))BASE_GROSS,SUM(isnull(BASE_NET,0))BASE_NET,SUM(isnull(TARGET_GROSS,0))TARGET_GROSS,SUM(isnull(TARGET_NET,0))TARGET_NET
				   ,SUM(ISNULL(TOT_GROSS_NET,0)) TOT_GROSS_NET
				  from   #CIR_INCT_NET_SALE_TEMP
				  group by COMP_CODE,UNIT_CODE,BRANCH_CODE,AGCD,DPCD,AG_NAME,REGION,ZONE,INCT_BASE,BASE_DATE,TARGET_DATE,
				  TRGT_BASE,INCT_PER  ,PUBL_CODE,PUBL,TGT_RET,TGT--EDTN,
              END

     
   drop table #CIR_TEMP_BILL_COLLECTION
   
   
 end

//////////////////////////////////////////////////////end//////////////////////////////////////////////

//////////////////////////////////////add by deepika 04/09/2012 sent by gaurav sir////////////////////////////////////
                                                                     
                                                                     
                                                                     
                                             
alter PROCEDURE [dbo].[cir_inct_net_sale_calculation]
	@pcomp_code		VARCHAR(20) ,
	@punit_code     VARCHAR(20) ,
	@pmonth         VARCHAR(20) ,
	@pyear          VARCHAR(20) ,
	@pdateformat    VARCHAR(20) ,
	@pbranch        varchar(20),
	@pagtype        varchar(20),
	@pagclass       varchar(20),
	@pagcode        varchar(20),
	@pdpcode        varchar(20),
	@ppubl          varchar(50)=null,
    @ppubl_type      varchar(50)=null,
	@pextra1        varchar(200),--S SUMMARY,D-DETAIL
	@pextra2        varchar(200),
	@pextra3        varchar(200),
	@pextra4        varchar(200),
	@pextra5        varchar(200)

--EXEC cir_inct_net_sale_report 'UM001','BA0','08','2012','dd/mm/yyyy','','','','','','','','','','','',''
AS 
begin
/*
	DECLARE @v_hdays	AS	NUMERIC(5) 
	DECLARE @v_avg_sale AS  NUMERIC(10) 
	DECLARE @v_reg_code AS  varchar(200)
	DECLARE @v_zone_code varchar(200);
	DECLARE @v_publ_code varchar(200);
	DECLARE @v_route_code varchar(200);
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
    DECLARE @v1_route_code   		as varchar(50)
    DECLARE @v1_route_name			as varchar(150)
    DECLARE @v1_supply_copy			as int
    DECLARE @v1_return_copy			as int
    DECLARE @v1_net_sale_copy		as int
    DECLARE @v1_no_of_days			as int
    DECLARE @v1_unit_name			as varchar(150)
    DECLARE @v1_COM_CAT  			as varchar(150)
    declare @v1_supdate				as datetime
    
	DECLARE @v1_formon_gross  			as numeric(30)
	DECLARE @v1_formon_return  			as  numeric(30)

	declare @v_day varchar(20)
	declare @v_rate numeric(20,2)
	declare @v_com numeric(20,2)
	declare @v_com_type varchar(20)
	declare @v_gross numeric(20,2)
	declare @v_billamt numeric(20,2)
	declare @v_grossbillamt numeric(20,2)
	declare @v_netbillamt numeric(20,2)
	declare @v_pro_code varchar(20)
	declare @b2_publ varchar(20)
	declare @b2_edtn varchar(20)
	declare @b2_comm varchar(20)
	declare @b2_supdate datetime
    
    */

	DECLARE @vfrdt         VARCHAR(20)
	DECLARE @vtodt         VARCHAR(20)
	DECLARE @vtodt1         VARCHAR(20)
	
	SET @vfrdt=(@pmonth+'/'+'01/'+@pyear) 	 -- 01/09/2012
	SET @vtodt1=([dbo].[GetLastDayOfMonth](@vfrdt))	 -- 30/09/2012
	
	set @vtodt=SUBSTRING(@vtodt1,5,2)		-- 30
	SET @vtodt=(@pmonth+'/'+@vtodt+'/'+@pyear)  -- '30/09/2012'
	
	declare @preturn_based varchar(1)
	set @preturn_based='S'

	declare @v1_INCT_BASE as varchar(1)
	declare @v1_AGCD as varchar(8)
	declare @v1_DPCD as varchar(8)
	declare @v1_PUBL as varchar(8)
	declare @v1_PUBL_TYPE as varchar(8)
	declare @v1_BASE_MONTH as datetime
	declare @v1_TARGET_MONTH as datetime	
	declare @v1_TRGT_INCT  as numeric(14,2)
	declare @v1_TRGT_RET  as numeric(14,2)
	declare @v1_TRGT_PER  as numeric(14,2)
	declare @v1_TRGT_BASE as varchar(1)
      
 CREATE TABLE #CIR_TEMP_incentive_calculation( 
COMP_CODE        VARCHAR(100),
UNIT_CODE        VARCHAR(100),
PUBL             VARCHAR(100),
EDTN             VARCHAR(100),
AGCD             VARCHAR(100),
DPCD             VARCHAR(100),
SUPCOPY_ACH      NUMERIC(10)                   DEFAULT 0,
RETURN_ACH       NUMERIC(10)                   DEFAULT 0,
SUPCOPY_TGT      NUMERIC(10)                   DEFAULT 0,
RETURN_TGT       NUMERIC(10)                   DEFAULT 0,
copy_rate		 numeric(14,2),
BASE_COPY		 numeric(14),
TGT_PER 		 numeric(14,2),
TGT_B_COPY		 numeric(14),
RET_ALLOW		 numeric(14,2),
TGT_N_COPY		 numeric(14),
TGT_N_AMT		 numeric(14,2),
ACH_COPY		 numeric(14),
ACH_RET		     numeric(14),--- return copy
ACH_N_COPY		 numeric(14),
INCT_PER		 numeric(14,2),
ACH_N_AMT		 numeric(14,2),
FINAL_AMT		 numeric(14,2)
) 


declare @v2_publ as varchar(10)
declare @v2_publname as varchar(200)
declare @v2_edtn as varchar(10)
declare @v2_edtnname as varchar(200)
---- variables for calculation -----
declare @v_copies_ach as numeric(14)          
declare @v_unsold_ach as numeric(14)
declare @v_copies_tgt as numeric(14)          
declare @v_unsold_tgt as numeric(14)
declare @v_tgt_frdt as datetime
declare @v_rate   as numeric(14,2)
declare @v_amount as numeric(14)

declare @v_tgt_base_copy  as numeric(14)
declare @v_tgt_net_copy  as numeric(14)
declare @v_tgt_net_amt  as numeric(14,2)
declare @v_ach_net_copy  as numeric(14)
declare @v_ach_net_amt  as numeric(14,2)
declare @v_tgt_ret_allow  as numeric(14,2)
declare @v_tgtnetcopy  as numeric(14)
declare @v_final_amt as numeric(14,2)
-------------------------------------
declare c1 cursor for 	
		select INCT_BASE, AGCD, DPCD, PUBL, PUBL_TYPE, BASE_MONTH, TARGET_MONTH	, TRGT_INCT, TRGT_RET, TRGT_PER, TRGT_BASE
		from cir_inct_net_sale where comp_code=@pcomp_code and unit_code=@punit_code and target_month=@vtodt1
       

	OPEN c1 
        fetch NEXT FROM c1 INTO @v1_INCT_BASE,@v1_AGCD,@v1_DPCD,@v1_PUBL,@v1_PUBL_TYPE,@v1_BASE_MONTH,@v1_TARGET_MONTH,@v1_TRGT_INCT,@v1_TRGT_RET,@v1_TRGT_PER,@v1_TRGT_BASE
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN 	
			set @v_tgt_frdt=dbo.GetFirstDayOfMonth(@v1_BASE_MONTH)
			declare c2 cursor for 
				select x.publ,x.PUBL_NAME,z.edtn,z.edtn_name from CIR_PUBL_MAST x,CIR_EDTN_MAST z 
				where x.comp_code=z.comp_code and x.COMP_CODE=@pcomp_code 
				and x.publ=z.publ
				and PRO_TYPE=@v1_PUBL_TYPE
					
					OPEN c2 
						fetch NEXT FROM c2 INTO @v2_publ,@v2_publname,@v2_edtn,@v2_edtnname
						WHILE (@@FETCH_STATUS = 0) 
						BEGIN
							set @v_tgt_base_copy = 0
							set @v_tgt_ret_allow = 0
							set @v_tgt_net_copy  = 0
							set @v_tgt_net_amt   = 0
							set @v_ach_net_copy  = 0
							set @v_ach_net_amt   = 0
							set @v_tgtnetcopy    = 0
							set @v_final_amt = 0
							
							set @v_copies_ach   = 0
							set @v_rate  = 0
							set @v_unsold_ach   = 0
							set @v_copies_tgt   = 0
							set @v_rate  = 0
							set @v_unsold_tgt   = 0
						
						
						
							select @v_copies_ach=SUM(isnull(sup_copy,0)),@v_rate=isnull(sup_rate,0) from cir_dbksup 
							where COMP_CODE=@pcomp_code and UNIT_CODE=@punit_code and AGCD=@v1_AGCD and DPCD=@v1_DPCD 
							and PUBL=@v2_publ and EDTN=@v2_edtn and SUPDATE between @vfrdt and @vtodt1
							group by sup_rate
						
							select @v_unsold_ach=sum(ISNULL(apr_short_recpt,0)) + sum(ISNULL(apr_late_recpt,0)) + sum(ISNULL(apr_bnr,0))
							+ sum(ISNULL(apr_unsold,0)) + sum(ISNULL(apr_damage,0))
							from CIR_UNSOLD_DTL where COMP_CODE=@pcomp_code and UNIT_CODE=@punit_code and AGCD=@v1_AGCD and DPCD=@v1_DPCD 
							and PUBL=@v2_publ and EDTN=@v2_edtn and SUPDATE between @vfrdt and @vtodt1
							
							select @v_copies_tgt=SUM(isnull(sup_copy,0)),@v_rate=isnull(sup_rate,0) from cir_dbksup 
							where COMP_CODE=@pcomp_code and UNIT_CODE=@punit_code and AGCD=@v1_AGCD and DPCD=@v1_DPCD 
							and PUBL=@v2_publ and EDTN=@v2_edtn and SUPDATE between @v_tgt_frdt and @v1_BASE_MONTH
							group by sup_rate
						
							select @v_unsold_tgt=sum(ISNULL(apr_short_recpt,0)) + sum(ISNULL(apr_late_recpt,0)) + sum(ISNULL(apr_bnr,0))
							+ sum(ISNULL(apr_unsold,0)) + sum(ISNULL(apr_damage,0))
							from CIR_UNSOLD_DTL where COMP_CODE=@pcomp_code and UNIT_CODE=@punit_code and AGCD=@v1_AGCD and DPCD=@v1_DPCD 
							and PUBL=@v2_publ and EDTN=@v2_edtn and SUPDATE between @v_tgt_frdt and @v1_BASE_MONTH
							
							print('JAI')
							print(@vfrdt)print(@vtodt1)print(@v_tgt_frdt)print(@v1_BASE_MONTH)
							print(@v_copies_ach)print(@v_unsold_ach)print(@v_copies_tgt)print(@v_unsold_tgt)print('VEERU')
							
							if(@v1_INCT_BASE='N')
							begin
								set @v_tgt_base_copy = isnull(@v_copies_tgt,0) + ((ISNULL(@v_copies_tgt,0) * ISNULL(@v1_TRGT_INCT,0))/100)
								set @v_tgt_ret_allow = ((isnull(@v_tgt_base_copy,0) * isnull(@v1_TRGT_RET,0)) /100)
								set @v_tgt_net_copy  = isnull(@v_tgt_base_copy,0) - isnull(@v_tgt_ret_allow,0)
							end
							else
							begin
								set @v_tgtnetcopy=isnull(@v_copies_tgt,0)-isnull(@v_unsold_tgt,0)
								set @v_tgt_base_copy = isnull(@v_tgtnetcopy,0) + ((ISNULL(@v_tgtnetcopy,0) * ISNULL(@v1_TRGT_INCT,0))/100)
								set @v_tgt_ret_allow = ((isnull(@v_tgt_base_copy,0) * isnull(@v1_TRGT_RET,0)) /100)
								set @v_tgt_net_copy  = isnull(@v_tgt_base_copy,0) - isnull(@v_tgt_ret_allow,0)
							end							
							
							
							set @v_tgt_net_amt   = ISNULL(@v_tgt_net_copy,0) * ISNULL(@v_rate,0)
							set @v_ach_net_copy  = ISNULL(@v_copies_ach,0) - ISNULL(@v_unsold_ach,0)
							
							if(@v_ach_net_copy >=@v_tgt_net_copy)
							begin
								if(@v1_TRGT_BASE ='N')
								begin
									set @v_ach_net_amt   = ISNULL(@v_ach_net_copy,0) * ISNULL(@v_rate,0)
								end
								else
								begin
									set @v_ach_net_amt   = ISNULL(@v_copies_ach,0) * ISNULL(@v_rate,0)
								end
								set @v_final_amt = (isnull(@v_ach_net_amt,0) + ((isnull(@v_ach_net_amt,0) * ISNULL(@v1_TRGT_PER,0) ) /100) )
							end
							else
							begin
								set @v_final_amt = 0
							end
							
							
							insert into #CIR_TEMP_incentive_calculation
							(COMP_CODE,UNIT_CODE,PUBL,EDTN,AGCD,DPCD,SUPCOPY_ACH,RETURN_ACH,SUPCOPY_TGT,RETURN_TGT,copy_rate
							,BASE_COPY,TGT_PER,TGT_B_COPY,RET_ALLOW,TGT_N_COPY,TGT_N_AMT
							,ACH_COPY,ACH_RET,ACH_N_COPY,INCT_PER,ACH_N_AMT,FINAL_AMT )
						values(@pcomp_code,@punit_code,@v2_publ,@v2_edtn,@v1_agcd,@v1_dpcd,@v_copies_ach,@v_unsold_ach,@v_copies_tgt,@v_unsold_tgt,@v_rate
							,@v_copies_tgt,@v1_TRGT_INCT,@v_tgt_base_copy,@v1_TRGT_RET,@v_tgt_net_copy,@v_tgt_net_amt
							,@v_copies_ach,@v_unsold_ach,@v_ach_net_copy,@v1_TRGT_PER,@v_ach_net_amt,@v_final_amt)
            
						
						fetch NEXT FROM c2  INTO @v2_publ,@v2_publname,@v2_edtn,@v2_edtnname		
						END 
					close c2
					DEALLOCATE c2
        
		    fetch NEXT FROM c1 INTO @v1_INCT_BASE,@v1_AGCD,@v1_DPCD,@v1_PUBL,@v1_PUBL_TYPE,@v1_BASE_MONTH,@v1_TARGET_MONTH,@v1_TRGT_INCT,@v1_TRGT_RET,@v1_TRGT_PER,@v1_TRGT_BASE
		
		END 
		close c1
		DEALLOCATE c1
             
    select * from #CIR_TEMP_incentive_calculation  where SUPCOPY_ACH >0        
             
          
   drop table #CIR_TEMP_incentive_calculation
   
   
 end

////////////////////////////////////////next


                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE [dbo].[cir_inct_net_sale_calculation]
	@pcomp_code		VARCHAR(20) ,
	@punit_code     VARCHAR(20) ,
	@pmonth         VARCHAR(20) ,
	@pyear          VARCHAR(20) ,
	@pdateformat    VARCHAR(20) ,
	@pbranch        varchar(20),
	@pagtype        varchar(20),
	@pagclass       varchar(20),
	@pagcode        varchar(20),
	@pdpcode        varchar(20),
	@ppubl          varchar(50)=null,
    @ppubl_type      varchar(50)=null,
	@pextra1        varchar(200),--S SUMMARY,D-DETAIL
	@pextra2        varchar(200),
	@pextra3        varchar(200),
	@pextra4        varchar(200),
	@pextra5        varchar(200)

--EXEC cir_inct_net_sale_report 'UM001','BA0','08','2012','dd/mm/yyyy','','','','','','','','','','','',''
AS 
begin


	DECLARE @vfrdt         VARCHAR(20)
	DECLARE @vtodt         VARCHAR(20)
	DECLARE @vtodt1         VARCHAR(20)
	
	SET @vfrdt=(@pmonth+'/'+'01/'+@pyear) 	 -- 01/09/2012
	SET @vtodt1=([dbo].[GetLastDayOfMonth](@vfrdt))	 -- 30/09/2012
	
	set @vtodt=SUBSTRING(@vtodt1,5,2)		-- 30
	SET @vtodt=(@pmonth+'/'+@vtodt+'/'+@pyear)  -- '30/09/2012'
	
	declare @preturn_based varchar(1)
	set @preturn_based='S'

	declare @v1_INCT_BASE as varchar(1)
	declare @v1_AGCD as varchar(8)
	declare @v1_DPCD as varchar(8)
	declare @v1_PUBL as varchar(8)
	declare @v1_PUBL_TYPE as varchar(8)
	declare @v1_BASE_MONTH as datetime
	declare @v1_TARGET_MONTH as datetime	
	declare @v1_TRGT_INCT  as numeric(14,2)
	declare @v1_TRGT_RET  as numeric(14,2)
	declare @v1_TRGT_PER  as numeric(14,2)
	declare @v1_TRGT_BASE as varchar(1)
      
 CREATE TABLE #CIR_TEMP_incentive_calculation( 
COMP_CODE        VARCHAR(100),
UNIT_CODE        VARCHAR(100),
PUBL             VARCHAR(100),
EDTN             VARCHAR(100),
AGCD             VARCHAR(100),
DPCD             VARCHAR(100),
SUPCOPY_ACH      NUMERIC(10)                   DEFAULT 0,
RETURN_ACH       NUMERIC(10)                   DEFAULT 0,
SUPCOPY_TGT      NUMERIC(10)                   DEFAULT 0,
RETURN_TGT       NUMERIC(10)                   DEFAULT 0,
copy_rate		 numeric(14,2),
BASE_COPY		 numeric(14),
TGT_PER 		 numeric(14,2),
TGT_B_COPY		 numeric(14),
RET_ALLOW		 numeric(14,2),
TGT_N_COPY		 numeric(14),
TGT_N_AMT		 numeric(14,2),
ACH_COPY		 numeric(14),
ACH_RET		     numeric(14),--- return copy
ACH_N_COPY		 numeric(14),
INCT_PER		 numeric(14,2),
ACH_N_AMT		 numeric(14,2),
FINAL_AMT		 numeric(14,2)
) 


declare @v2_publ as varchar(10)
declare @v2_publname as varchar(200)
declare @v2_edtn as varchar(10)
declare @v2_edtnname as varchar(200)
---- variables for calculation -----
declare @v_copies_ach as numeric(14)          
declare @v_unsold_ach as numeric(14)
declare @v_copies_tgt as numeric(14)          
declare @v_unsold_tgt as numeric(14)
declare @v_tgt_frdt as datetime
declare @v_rate   as numeric(14,2)
declare @v_amount as numeric(14)

declare @v_tgt_base_copy  as numeric(14)
declare @v_tgt_net_copy  as numeric(14)
declare @v_tgt_net_amt  as numeric(14,2)
declare @v_ach_net_copy  as numeric(14)
declare @v_ach_net_amt  as numeric(14,2)
declare @v_tgt_ret_allow  as numeric(14,2)
declare @v_tgtnetcopy  as numeric(14)
declare @v_final_amt as numeric(14,2)
-------------------------------------
declare c1 cursor for 	
		select INCT_BASE, AGCD, DPCD, PUBL, PUBL_TYPE, BASE_MONTH, TARGET_MONTH	, TRGT_INCT, TRGT_RET, TRGT_PER, TRGT_BASE
		from cir_inct_net_sale where comp_code=@pcomp_code and unit_code=@punit_code and target_month=@vtodt1
		and (agcd=@pagcode or @pagcode is null or @pagcode ='') and (dpcd=@pdpcode or @pdpcode is null or @pdpcode ='')
       print('@vtodt1')
       print(@vtodt1)
	  
	OPEN c1 
        fetch NEXT FROM c1 INTO @v1_INCT_BASE,@v1_AGCD,@v1_DPCD,@v1_PUBL,@v1_PUBL_TYPE,@v1_BASE_MONTH,@v1_TARGET_MONTH,@v1_TRGT_INCT,@v1_TRGT_RET,@v1_TRGT_PER,@v1_TRGT_BASE
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN 	
			set @v_tgt_frdt=dbo.GetFirstDayOfMonth(@v1_BASE_MONTH)
			declare c2 cursor for 
				select x.publ,x.PUBL_NAME,z.edtn,z.edtn_name from CIR_PUBL_MAST x,CIR_EDTN_MAST z 
				where x.comp_code=z.comp_code and x.COMP_CODE=@pcomp_code 
				and x.publ=z.publ
				and PRO_TYPE=@v1_PUBL_TYPE
					
					OPEN c2 
						fetch NEXT FROM c2 INTO @v2_publ,@v2_publname,@v2_edtn,@v2_edtnname
						WHILE (@@FETCH_STATUS = 0) 
						BEGIN
							set @v_tgt_base_copy = 0
							set @v_tgt_ret_allow = 0
							set @v_tgt_net_copy  = 0
							set @v_tgt_net_amt   = 0
							set @v_ach_net_copy  = 0
							set @v_ach_net_amt   = 0
							set @v_tgtnetcopy    = 0
							set @v_final_amt = 0
							
							set @v_copies_ach   = 0
							set @v_rate  = 0
							set @v_unsold_ach   = 0
							set @v_copies_tgt   = 0
							set @v_rate  = 0
							set @v_unsold_tgt   = 0
						
						print(@v2_publ)
						print(@v2_edtn)
						print(@vfrdt)
						print(@vtodt1)
						
							select @v_copies_ach=SUM(isnull(sup_copy,0)),@v_rate=isnull(sup_rate,0) from cir_dbksup 
							where COMP_CODE=@pcomp_code and UNIT_CODE=@punit_code and AGCD=@v1_AGCD and DPCD=@v1_DPCD 
							and PUBL=@v2_publ and EDTN=@v2_edtn and SUPDATE between @vfrdt and @vtodt1
							group by sup_rate
					
							select @v_unsold_ach=sum(ISNULL(apr_short_recpt,0)) + sum(ISNULL(apr_late_recpt,0)) + sum(ISNULL(apr_bnr,0))
							+ sum(ISNULL(apr_unsold,0)) + sum(ISNULL(apr_damage,0))
							from CIR_UNSOLD_DTL where COMP_CODE=@pcomp_code and UNIT_CODE=@punit_code and AGCD=@v1_AGCD and DPCD=@v1_DPCD 
							and PUBL=@v2_publ and EDTN=@v2_edtn and SUPDATE between @vfrdt and @vtodt1
							
							select @v_copies_tgt=SUM(isnull(sup_copy,0)),@v_rate=isnull(sup_rate,0) from cir_dbksup 
							where COMP_CODE=@pcomp_code and UNIT_CODE=@punit_code and AGCD=@v1_AGCD and DPCD=@v1_DPCD 
							and PUBL=@v2_publ and EDTN=@v2_edtn and SUPDATE between @v_tgt_frdt and @v1_BASE_MONTH
							group by sup_rate
						
							select @v_unsold_tgt=sum(ISNULL(apr_short_recpt,0)) + sum(ISNULL(apr_late_recpt,0)) + sum(ISNULL(apr_bnr,0))
							+ sum(ISNULL(apr_unsold,0)) + sum(ISNULL(apr_damage,0))
							from CIR_UNSOLD_DTL where COMP_CODE=@pcomp_code and UNIT_CODE=@punit_code and AGCD=@v1_AGCD and DPCD=@v1_DPCD 
							and PUBL=@v2_publ and EDTN=@v2_edtn and SUPDATE between @v_tgt_frdt and @v1_BASE_MONTH
							
							print('JAI')
							print(@vfrdt)print(@vtodt1)print(@v_tgt_frdt)print(@v1_BASE_MONTH)
							print(@v_copies_ach)print(@v_unsold_ach)print(@v_copies_tgt)print(@v_unsold_tgt)print('VEERU')
							
							if(@v1_INCT_BASE='N')
							begin
								set @v_tgt_base_copy = isnull(@v_copies_tgt,0) + ((ISNULL(@v_copies_tgt,0) * ISNULL(@v1_TRGT_INCT,0))/100)
								set @v_tgt_ret_allow = ((isnull(@v_tgt_base_copy,0) * isnull(@v1_TRGT_RET,0)) /100)
								set @v_tgt_net_copy  = isnull(@v_tgt_base_copy,0) - isnull(@v_tgt_ret_allow,0)
							end
							else
							begin
								set @v_tgtnetcopy=isnull(@v_copies_tgt,0)-isnull(@v_unsold_tgt,0)
								set @v_tgt_base_copy = isnull(@v_tgtnetcopy,0) + ((ISNULL(@v_tgtnetcopy,0) * ISNULL(@v1_TRGT_INCT,0))/100)
								set @v_tgt_ret_allow = ((isnull(@v_tgt_base_copy,0) * isnull(@v1_TRGT_RET,0)) /100)
								set @v_tgt_net_copy  = isnull(@v_tgt_base_copy,0) - isnull(@v_tgt_ret_allow,0)
							end							
							
							
							set @v_tgt_net_amt   = ISNULL(@v_tgt_net_copy,0) * ISNULL(@v_rate,0)
							set @v_ach_net_copy  = ISNULL(@v_copies_ach,0) - ISNULL(@v_unsold_ach,0)
							
							if(@v_ach_net_copy >=@v_tgt_net_copy)
							begin
								if(@v1_TRGT_BASE ='N')
								begin
									set @v_ach_net_amt   = ISNULL(@v_ach_net_copy,0) * ISNULL(@v_rate,0)
								end
								else
								begin
									set @v_ach_net_amt   = ISNULL(@v_copies_ach,0) * ISNULL(@v_rate,0)
								end
								set @v_final_amt =  ((isnull(@v_ach_net_amt,0) * ISNULL(@v1_TRGT_PER,0) ) /100) --) (isnull(@v_ach_net_amt,0) +
							end
							else
							begin
								set @v_final_amt = 0
							end
							
							
							insert into #CIR_TEMP_incentive_calculation
							(COMP_CODE,UNIT_CODE,PUBL,EDTN,AGCD,DPCD,SUPCOPY_ACH,RETURN_ACH,SUPCOPY_TGT,RETURN_TGT,copy_rate
							,BASE_COPY,TGT_PER,TGT_B_COPY,RET_ALLOW,TGT_N_COPY,TGT_N_AMT
							,ACH_COPY,ACH_RET,ACH_N_COPY,INCT_PER,ACH_N_AMT,FINAL_AMT )
						values(@pcomp_code,@punit_code,@v2_publ,@v2_edtn,@v1_agcd,@v1_dpcd,@v_copies_ach,@v_unsold_ach,@v_copies_tgt,@v_unsold_tgt,@v_rate
							,@v_copies_tgt,@v1_TRGT_INCT,@v_tgt_base_copy,@v1_TRGT_RET,@v_tgt_net_copy,@v_tgt_net_amt
							,@v_copies_ach,@v_unsold_ach,@v_ach_net_copy,@v1_TRGT_PER,@v_ach_net_amt,@v_final_amt)
            
						
						fetch NEXT FROM c2  INTO @v2_publ,@v2_publname,@v2_edtn,@v2_edtnname		
						END 
					close c2
					DEALLOCATE c2
        
		    fetch NEXT FROM c1 INTO @v1_INCT_BASE,@v1_AGCD,@v1_DPCD,@v1_PUBL,@v1_PUBL_TYPE,@v1_BASE_MONTH,@v1_TARGET_MONTH,@v1_TRGT_INCT,@v1_TRGT_RET,@v1_TRGT_PER,@v1_TRGT_BASE
		
		END 
		close c1
		DEALLOCATE c1
		
		--SELECT * FROM #CIR_TEMP_incentive_calculation --where SUPCOPY_ACH >0 
          if(@pextra1='S')   begin
    select COMP_CODE,UNIT_CODE,
    dbo.cir_get_unit_name(COMP_CODE,UNIT_CODE) UNIT_NAME,
    AGCD,DPCD,
    dbo.cir_get_agency(COMP_CODE,UNIT_CODE,AGCD,DPCD)AG_NAME,
    SUM(BASE_COPY) BASE_COPY,SUM(TGT_B_COPY)TGT_B_COPY,
    SUM(TGT_N_COPY)TGT_N_COPY,SUM(TGT_N_AMT)TGT_N_AMT,SUM(ACH_COPY)ACH_COPY,SUM(ISNULL(ACH_RET,0))ACH_RET
    ,SUM(ACH_N_COPY)ACH_N_COPY,SUM(ACH_N_AMT)ACH_N_AMT,SUM(FINAL_AMT)FINAL_AMT
     from #CIR_TEMP_incentive_calculation  where (SUPCOPY_ACH >0   or SUPCOPY_TGT >0)
     GROUP BY COMP_CODE,UNIT_CODE,AGCD,DPCD  
    
    end
    else 
    begin
        select COMP_CODE,UNIT_CODE, dbo.cir_get_unit_name(COMP_CODE,UNIT_CODE) UNIT_NAME,PUBL,
        dbo.cir_get_publ_name(COMP_CODE,PUBL)PUBL_NAME,
        AGCD,DPCD,
          dbo.cir_get_agency(COMP_CODE,UNIT_CODE,AGCD,DPCD)AG_NAME,
        SUM(BASE_COPY) BASE_COPY,TGT_PER,SUM(TGT_B_COPY)TGT_B_COPY,RET_ALLOW,
    SUM(TGT_N_COPY)TGT_N_COPY,SUM(TGT_N_AMT)TGT_N_AMT,SUM(ACH_COPY)ACH_COPY,SUM(ISNULL(ACH_RET,0))ACH_RET
    ,SUM(ACH_N_COPY)ACH_N_COPY,INCT_PER,SUM(ACH_N_AMT)ACH_N_AMT,SUM(FINAL_AMT)FINAL_AMT
     from #CIR_TEMP_incentive_calculation  where (SUPCOPY_ACH >0   or SUPCOPY_TGT >0)  
     GROUP BY COMP_CODE,UNIT_CODE,PUBL,AGCD,DPCD,TGT_PER  ,RET_ALLOW  ,INCT_PER
    end
             
          
   drop table #CIR_TEMP_incentive_calculation
   
   
 end


/////////////////////////////////////////////////next

                                                                     
                                                                     
                                                                     
                                             
ALTER procedure [dbo].[cir_inct_net_sale_duplicate]
@pcompcode       as varchar(20),
@punitcode       as varchar(20),
@ppublcode       as varchar(20),  
@pagcode         as varchar(20),
@pdepocode       as varchar(20),
@pmonth			 as varchar(20),
@pyear 			 as varchar(20),
@pextra1         as varchar(20),
@pextra2         as varchar(20),
@pextra3    	 as varchar(20),
@pextra4 	 	 as varchar(20)

As
declare @v_count int
declare @v_date as datetime

begin
	set @v_date=dbo.GetLastDayOfMonth(@pmonth+'/'+'01'+'/'+@pyear)

print(@v_date)

	select @v_count=count(*) from CIR_INCT_NET_SALE
	where comp_code=@pcompcode and unit_code=@punitcode
	and (publ=@ppublcode or @ppublcode is null or @ppublcode ='') 
	and agcd=@pagcode and dpcd=@pdepocode and TARGET_MONTH=@v_date

	if @v_count>0
	begin
		select 'NOT OK' AS OUTPUT
	end
	ELSE 
	begin
		select 'OK' AS OUTPUT
	end
end


//////////////////////////////////////////end/////////////////////////////////////////////////////

///////////////////////////////////add by deepika 04/09/2012 sent by amit sir///////////////


alter table preferrences add DIFF_SUPPLY_ROUTE VARCHAR(1) DEFAULT 'Y'


//////////////////////next

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
		DECLARE @route_flg   as varchar(1)
	
		select @route_flg= diff_supply_route from preferrences
if(@route_flg='Y') begin
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
					,ISNULL(c.SP_SUPPLY_MON1,0)  SP_SUPPLY_MON1
					,ISNULL(c.SP_SUPPLY_TUE1,0)  SP_SUPPLY_TUE1
					,ISNULL(c.SP_SUPPLY_WED1,0)  SP_SUPPLY_WED1
					,ISNULL(c.SP_SUPPLY_THU1,0)  SP_SUPPLY_THU1
					,ISNULL(c.SP_SUPPLY_FRI1,0)  SP_SUPPLY_FRI1
					,ISNULL(c.SP_SUPPLY_SAT1,0)  SP_SUPPLY_SAT1
					,ISNULL(c.SP_SUPPLY_SUN1,0)  SP_SUPPLY_SUN1
					,ISNULL(c.SP_SUPPLY_MON2,0)  SP_SUPPLY_MON2
					,ISNULL(c.SP_SUPPLY_TUE2,0)  SP_SUPPLY_TUE2
					,ISNULL(c.SP_SUPPLY_WED2,0)  SP_SUPPLY_WED2
					,ISNULL(c.SP_SUPPLY_THU2,0)  SP_SUPPLY_THU2
					,ISNULL(c.SP_SUPPLY_FRI2,0)  SP_SUPPLY_FRI2
					,ISNULL(c.SP_SUPPLY_SAT2,0)  SP_SUPPLY_SAT2
					,ISNULL(c.SP_SUPPLY_SUN2,0)  SP_SUPPLY_SUN2
					,ISNULL(P.CIR_SUP_ORDER_DEC_LIMIT,0) CIR_SUP_ORDER_DEC_LIMIT
					from cir_agmast_dis a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
					where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code= @pcomp_code and p.comp_code= @pcomp_code and
					a.unit=c.unit and a.unit=e.unit_code and a.unit= @punit_code and b.sup_ty_code=c.supply_type_code and
					c.publ=e.publ 
					and (c.publ= @ppubl_code or @ppubl_code is null)
					and c.edtn=e.edtn and (c.edtn = isnull(@pedtn_code,c.edtn) or @pedtn_code='') and (e.main_edtn = isnull(@pmedtn_code,e.main_edtn) or @pmedtn_code='') and 
					a.agcd=c.agcd and (a.bill_agcd=isnull(@pagcd_code,a.bill_agcd) or @pagcd_code='') and a.dpcd=c.dpcd and (a.bill_dpcd=isnull(@pdpcd_code,a.bill_dpcd) or @pdpcd_code='') and (c.supply_type_code= @psup_type or @psup_type is null or @psup_type='') and 
					(a.state_code=@pstate or @pstate is null or @pstate='') and
					(a.dist_code=@pdistcode or @pdistcode is null  or @pdistcode='') and (a.tehsil_taluka = @ptaluka or @ptaluka is null or @ptaluka='') and
					--(a.city_code=@pcitycode or @pcitycode is null) and 
					--(a.branch_code = @pbrancode or @pbrancode is null or @pbrancode='') and

					a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcitycode,city_code) and 
					(zone_code in(select  distinct l.zone_code from login_zone_mast l where zone_code=l.zone_code and (zone_code=@pextra4 or @pextra4 is null or @pextra4='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))  and
					(region_code in(select  distinct l.region_code from login_region_mast l where region_code=l.region_code and (region_code=@pextra5 or @pextra5 is null or @pextra5='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))
					)and

					(a.branch_code in(select  distinct l.branch_code from login_branch_mast l where a.branch_code=l.branch_code and (a.branch_code=@pbrancode or @pbrancode is null or @pbrancode='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))  and


					(c.route_code=@proutecode or @proutecode is null) and isnull(c.supply_flag,'N') ='Y' and 
					((isnull(a.suspend,'N')=isnull(@pextra6,'N')) or (@pextra6 is null) or (@pextra6='')) and
					a.freeze_flag='N' and
					((c.comm_code = @pextra7) or (@pextra7 is null) or (@pextra7 = '')) and 
					(a.ag_type=@pextra1 or @pextra1 is null or @pextra1='') and 
					(a.ag_class=@pextra3 or @pextra3 is null or @pextra3='')
					
and (ISNULL(c.SP_SUPPLY_MON1,0)+ISNULL(c.SP_SUPPLY_TUE1,0)+ISNULL(c.SP_SUPPLY_WED1,0)+ISNULL(c.SP_SUPPLY_THU1,0)+
ISNULL(c.SP_SUPPLY_FRI1,0)+ISNULL(c.SP_SUPPLY_SAT1,0)+ISNULL(c.SP_SUPPLY_SUN1,0)+ISNULL(c.SP_SUPPLY_MON2,0)+
ISNULL(c.SP_SUPPLY_TUE2,0) +ISNULL(c.SP_SUPPLY_WED2,0)+ISNULL(c.SP_SUPPLY_THU2,0)+ISNULL(c.SP_SUPPLY_FRI2,0)+
ISNULL(c.SP_SUPPLY_SAT2,0)+ISNULL(c.SP_SUPPLY_SUN2,0)+ISNULL(C.BASE_SUPPLY,0)+ISNULL(C.SUPPLY_SUN,0)+ISNULL(C.SUPPLY_MON,0)
+ISNULL(C.SUPPLY_TUE,0)+ISNULL(C.SUPPLY_WED,0)+	ISNULL(C.SUPPLY_THU,0)+ISNULL(C.SUPPLY_FRI,0)+ISNULL(C.SUPPLY_SAT,0)+
ISNULL(C.SUPPLY_SPL1,0)+ISNULL(C.SUPPLY_SPL2,0))>0
					
					
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
					,ISNULL(c.SP_SUPPLY_MON1,0)  SP_SUPPLY_MON1
					,ISNULL(c.SP_SUPPLY_TUE1,0)  SP_SUPPLY_TUE1
					,ISNULL(c.SP_SUPPLY_WED1,0)  SP_SUPPLY_WED1
					,ISNULL(c.SP_SUPPLY_THU1,0)  SP_SUPPLY_THU1
					,ISNULL(c.SP_SUPPLY_FRI1,0)  SP_SUPPLY_FRI1
					,ISNULL(c.SP_SUPPLY_SAT1,0)  SP_SUPPLY_SAT1
					,ISNULL(c.SP_SUPPLY_SUN1,0)  SP_SUPPLY_SUN1
					,ISNULL(c.SP_SUPPLY_MON2,0)  SP_SUPPLY_MON2
					,ISNULL(c.SP_SUPPLY_TUE2,0)  SP_SUPPLY_TUE2
					,ISNULL(c.SP_SUPPLY_WED2,0)  SP_SUPPLY_WED2
					,ISNULL(c.SP_SUPPLY_THU2,0)  SP_SUPPLY_THU2
					,ISNULL(c.SP_SUPPLY_FRI2,0)  SP_SUPPLY_FRI2
					,ISNULL(c.SP_SUPPLY_SAT2,0)  SP_SUPPLY_SAT2
					,ISNULL(c.SP_SUPPLY_SUN2,0)  SP_SUPPLY_SUN2
					,ISNULL(P.CIR_SUP_ORDER_DEC_LIMIT,0) CIR_SUP_ORDER_DEC_LIMIT
					from cir_agmast_dis a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
					where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code= @pcomp_code and p.comp_code= @pcomp_code and
					a.unit=c.unit and a.unit=e.unit_code and a.unit= @punit_code and b.sup_ty_code=c.supply_type_code and
					c.publ=e.publ 
					and (c.publ= @ppubl_code  or @ppubl_code is null)
					and c.edtn=e.edtn and (c.edtn = isnull(@pedtn_code,c.edtn) or @pedtn_code='') and (e.main_edtn = isnull(@pmedtn_code,e.main_edtn) or @pmedtn_code='') and 
					a.agcd=c.agcd and (a.bill_agcd=isnull(@pagcd_code,a.bill_agcd) or @pagcd_code='') and a.dpcd=c.dpcd and (a.bill_dpcd=isnull(@pdpcd_code,a.bill_dpcd) or @pdpcd_code='') and (c.supply_type_code= @psup_type or @psup_type is null or @psup_type='') and 
					(a.state_code=@pstate or @pstate is null or @pstate='') and
					(a.dist_code=@pdistcode or @pdistcode is null  or @pdistcode='') and (a.tehsil_taluka = @ptaluka or @ptaluka is null or @ptaluka='') and
					--  (a.city_code=@pcitycode or @pcitycode is null) and (a.branch_code = @pbrancode or @pbrancode is null or @pbrancode='') and

					a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcitycode,city_code) and 
					(zone_code in(select  distinct l.zone_code from login_zone_mast l where zone_code=l.zone_code and (zone_code=@pextra4 or @pextra4 is null or @pextra4='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))  and
					(region_code in(select  distinct l.region_code from login_region_mast l where region_code=l.region_code and (region_code=@pextra5 or @pextra5 is null or @pextra5='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))
					)and 


					-- (a.branch_code = pbrancode or pbrancode is null) and
					(a.branch_code in(select  distinct l.branch_code from login_branch_mast l where a.branch_code=l.branch_code and (a.branch_code=@pbrancode or @pbrancode is null or @pbrancode='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))  and



					(c.route_code=@proutecode or @proutecode is null) and isnull(c.supply_flag,'N') ='Y' and 
					((isnull(a.suspend,'N')=isnull(@pextra6,'N')) or (@pextra6 is null) or (@pextra6='')) and
					a.freeze_flag='N' and
					((c.comm_code = @pextra7) or (@pextra7 is null) or (@pextra7 = '')) and 
					(a.ag_type=@pextra1 or @pextra1 is null or @pextra1='') and 
					(a.ag_class=@pextra3 or @pextra3 is null or @pextra3='')
					and (ISNULL(c.SP_SUPPLY_MON1,0)+ISNULL(c.SP_SUPPLY_TUE1,0)+ISNULL(c.SP_SUPPLY_WED1,0)+ISNULL(c.SP_SUPPLY_THU1,0)+
ISNULL(c.SP_SUPPLY_FRI1,0)+ISNULL(c.SP_SUPPLY_SAT1,0)+ISNULL(c.SP_SUPPLY_SUN1,0)+ISNULL(c.SP_SUPPLY_MON2,0)+
ISNULL(c.SP_SUPPLY_TUE2,0) +ISNULL(c.SP_SUPPLY_WED2,0)+ISNULL(c.SP_SUPPLY_THU2,0)+ISNULL(c.SP_SUPPLY_FRI2,0)+
ISNULL(c.SP_SUPPLY_SAT2,0)+ISNULL(c.SP_SUPPLY_SUN2,0)+ISNULL(C.BASE_SUPPLY,0)+ISNULL(C.SUPPLY_SUN,0)+ISNULL(C.SUPPLY_MON,0)
+ISNULL(C.SUPPLY_TUE,0)+ISNULL(C.SUPPLY_WED,0)+	ISNULL(C.SUPPLY_THU,0)+ISNULL(C.SUPPLY_FRI,0)+ISNULL(C.SUPPLY_SAT,0)+
ISNULL(C.SUPPLY_SPL1,0)+ISNULL(C.SUPPLY_SPL2,0))>0
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
					C.ROUTE_CODE,DBO.CIR_GET_NAME_CIR_ROUTE(A.COMP_CODE,null,C.ROUTE_CODE,1,@PDATEFORMAT,'','') ROUTE_NAME, 
					C.SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBROUTE(A.COMP_CODE,null,C.ROUTE_CODE,C.SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBROUTE_NAME,
					C.SUB_SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBSUBROUTE(A.COMP_CODE,null,C.ROUTE_CODE,C.SUBROUTE_CODE,C.SUB_SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBSUBROUTE_NAME,
					D.DIST_NAME DIST_NAME,ISNULL(P.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,C.SUPPLY_TYPE_CODE SUPPLY_TYPE_CODE,B.SUP_TY_NAME SUPPLY_TYPE_NAME,
					C.EDTN EDTN,E.EDTN_NAME EDTN_NAME,B.SUP_SEQ_NO SUP_SEQ_NO,
					A.SUSPEND SUSPEND,C.PUBL PUBL,DB0.CIR_GET_PUBL_NAME(A.COMP_CODE,C.PUBL) PUBL_NAME
					,ISNULL(c.SP_SUPPLY_MON1,0)  SP_SUPPLY_MON1
					,ISNULL(c.SP_SUPPLY_TUE1,0)  SP_SUPPLY_TUE1
					,ISNULL(c.SP_SUPPLY_WED1,0)  SP_SUPPLY_WED1
					,ISNULL(c.SP_SUPPLY_THU1,0)  SP_SUPPLY_THU1
					,ISNULL(c.SP_SUPPLY_FRI1,0)  SP_SUPPLY_FRI1
					,ISNULL(c.SP_SUPPLY_SAT1,0)  SP_SUPPLY_SAT1
					,ISNULL(c.SP_SUPPLY_SUN1,0)  SP_SUPPLY_SUN1
					,ISNULL(c.SP_SUPPLY_MON2,0)  SP_SUPPLY_MON2
					,ISNULL(c.SP_SUPPLY_TUE2,0)  SP_SUPPLY_TUE2
					,ISNULL(c.SP_SUPPLY_WED2,0)  SP_SUPPLY_WED2
					,ISNULL(c.SP_SUPPLY_THU2,0)  SP_SUPPLY_THU2
					,ISNULL(c.SP_SUPPLY_FRI2,0)  SP_SUPPLY_FRI2
					,ISNULL(c.SP_SUPPLY_SAT2,0)  SP_SUPPLY_SAT2
					,ISNULL(c.SP_SUPPLY_SUN2,0)  SP_SUPPLY_SUN2
					,ISNULL(P.CIR_SUP_ORDER_DEC_LIMIT,0) CIR_SUP_ORDER_DEC_LIMIT
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
					--(a.city_code=@pcitycode or @pcitycode is null) and (a.branch_code = @pbrancode or @pbrancode is null or @pbrancode='') and

					a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcitycode,city_code) and 
					(zone_code in(select  distinct l.zone_code from login_zone_mast l where zone_code=l.zone_code and (zone_code=@pextra4 or @pextra4 is null or @pextra4='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))  and
					(region_code in(select  distinct l.region_code from login_region_mast l where region_code=l.region_code and (region_code=@pextra5 or @pextra5 is null or @pextra5='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))
					)and 

					--  (a.branch_code = pbrancode or pbrancode is null) and
					(a.branch_code in(select  distinct l.branch_code from login_branch_mast l where a.branch_code=l.branch_code and (a.branch_code=@pbrancode or @pbrancode is null or @pbrancode='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))  and

					(c.route_code=@proutecode or @proutecode is null) and isnull(c.supply_flag,'N') ='Y' and 
					((isnull(a.suspend,'N')=isnull(@pextra6,'N')) or (@pextra6 is null) or (@pextra6='')) and
					a.freeze_flag='N' and
					((c.comm_code = @pextra7) or (@pextra7 is null) or (@pextra7 = '')) and 
					(a.ag_type=@pextra1 or @pextra1 is null or @pextra1='') and (a.ag_class=@pextra3 or @pextra3 is null or @pextra3='')
					and (ISNULL(c.SP_SUPPLY_MON1,0)+ISNULL(c.SP_SUPPLY_TUE1,0)+ISNULL(c.SP_SUPPLY_WED1,0)+ISNULL(c.SP_SUPPLY_THU1,0)+
ISNULL(c.SP_SUPPLY_FRI1,0)+ISNULL(c.SP_SUPPLY_SAT1,0)+ISNULL(c.SP_SUPPLY_SUN1,0)+ISNULL(c.SP_SUPPLY_MON2,0)+
ISNULL(c.SP_SUPPLY_TUE2,0) +ISNULL(c.SP_SUPPLY_WED2,0)+ISNULL(c.SP_SUPPLY_THU2,0)+ISNULL(c.SP_SUPPLY_FRI2,0)+
ISNULL(c.SP_SUPPLY_SAT2,0)+ISNULL(c.SP_SUPPLY_SUN2,0)+ISNULL(C.BASE_SUPPLY,0)+ISNULL(C.SUPPLY_SUN,0)+ISNULL(C.SUPPLY_MON,0)
+ISNULL(C.SUPPLY_TUE,0)+ISNULL(C.SUPPLY_WED,0)+	ISNULL(C.SUPPLY_THU,0)+ISNULL(C.SUPPLY_FRI,0)+ISNULL(C.SUPPLY_SAT,0)+
ISNULL(C.SUPPLY_SPL1,0)+ISNULL(C.SUPPLY_SPL2,0))>0
					order by dist_name,agency_name,edtn_name,sup_seq_no,supply_type_name,supply_seq
					End
					else	Begin
					SELECT A.COMP_CODE COMP_CODE,A.UNIT UNIT,A.AGCD AGCD,A.DPCD DPCD,A.AG_NAME AGENCY_NAME,A.AG_NAME_OTH_LANG AGENCY_NAME_OTHER_LANG,A.CITY_CODE CITY_CODE,
					DBO.CIR_GET_CITY(A.COMP_CODE,A.CITY_CODE) CITY_NAME,A.STATION_CODE DROP_POINT_CODE,DBO.CIR_GET_DROP_POINT_NAME(A.COMP_CODE,A.UNIT,A.STATION_CODE,'1') DROP_POINT_NAME,
					ISNULL(C.BASE_SUPPLY,0) BASE_SUPPLY,ISNULL(C.SUPPLY_SUN,0) SUPPLY_SUN,ISNULL(C.SUPPLY_MON,0) SUPPLY_MON,ISNULL(C.SUPPLY_TUE,0) SUPPLY_TUE,ISNULL(C.SUPPLY_WED,0) SUPPLY_WED,
					ISNULL(C.SUPPLY_THU,0) SUPPLY_THU,ISNULL(C.SUPPLY_FRI,0) SUPPLY_FRI,ISNULL(C.SUPPLY_SAT,0) SUPPLY_SAT,ISNULL(C.SUPPLY_SPL1,0) SUPPLY_SPL1,ISNULL(C.SUPPLY_SPL2,0) SUPPLY_SPL2,
					C.LBL_PRINTNO SUPPLY_SEQ,DBO.CIR_GET_ROUTE_SEQNO(C.COMP_CODE,C.UNIT,C.ROUTE_CODE) ROUTE_SEQ,
					C.ROUTE_CODE,DBO.CIR_GET_NAME_CIR_ROUTE(A.COMP_CODE,null,C.ROUTE_CODE,1,@PDATEFORMAT,'','') ROUTE_NAME, 
					C.SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBROUTE(A.COMP_CODE,null,C.ROUTE_CODE,C.SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBROUTE_NAME,
					C.SUB_SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBSUBROUTE(A.COMP_CODE,null,C.ROUTE_CODE,C.SUBROUTE_CODE,C.SUB_SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBSUBROUTE_NAME,
					D.DIST_NAME DIST_NAME,ISNULL(P.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,C.SUPPLY_TYPE_CODE SUPPLY_TYPE_CODE,B.SUP_TY_NAME SUPPLY_TYPE_NAME,
					C.EDTN EDTN,E.EDTN_NAME EDTN_NAME,B.SUP_SEQ_NO SUP_SEQ_NO,
					A.SUSPEND SUSPEND,C.PUBL PUBL,dbo.cir_get_publ_name(A.COMP_CODE,C.PUBL) PUBL_NAME
					,ISNULL(c.SP_SUPPLY_MON1,0)  SP_SUPPLY_MON1
					,ISNULL(c.SP_SUPPLY_TUE1,0)  SP_SUPPLY_TUE1
					,ISNULL(c.SP_SUPPLY_WED1,0)  SP_SUPPLY_WED1
					,ISNULL(c.SP_SUPPLY_THU1,0)  SP_SUPPLY_THU1
					,ISNULL(c.SP_SUPPLY_FRI1,0)  SP_SUPPLY_FRI1
					,ISNULL(c.SP_SUPPLY_SAT1,0)  SP_SUPPLY_SAT1
					,ISNULL(c.SP_SUPPLY_SUN1,0)  SP_SUPPLY_SUN1
					,ISNULL(c.SP_SUPPLY_MON2,0)  SP_SUPPLY_MON2
					,ISNULL(c.SP_SUPPLY_TUE2,0)  SP_SUPPLY_TUE2
					,ISNULL(c.SP_SUPPLY_WED2,0)  SP_SUPPLY_WED2
					,ISNULL(c.SP_SUPPLY_THU2,0)  SP_SUPPLY_THU2
					,ISNULL(c.SP_SUPPLY_FRI2,0)  SP_SUPPLY_FRI2
					,ISNULL(c.SP_SUPPLY_SAT2,0)  SP_SUPPLY_SAT2
					,ISNULL(c.SP_SUPPLY_SUN2,0)  SP_SUPPLY_SUN2
					,ISNULL(P.CIR_SUP_ORDER_DEC_LIMIT,0) CIR_SUP_ORDER_DEC_LIMIT
					from cir_agmast a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
					where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code= @pcomp_code and p.comp_code= @pcomp_code and
					a.unit=c.unit and a.unit=e.unit_code and a.unit= @punit_code and b.sup_ty_code=c.supply_type_code and
					c.publ=e.publ 
					and (c.publ= @ppubl_code or @ppubl_code is null)
					and c.edtn=e.edtn and (c.edtn = isnull(@pedtn_code,c.edtn) or @pedtn_code='') and (e.main_edtn = isnull(@pmedtn_code,e.main_edtn) or @pmedtn_code='') 
					and 
					a.agcd=c.agcd and (a.bill_agcd=isnull(@pagcd_code,a.bill_agcd) or @pagcd_code='') 
					and a.dpcd=c.dpcd and (a.bill_dpcd=isnull(@pdpcd_code,a.bill_dpcd) or @pdpcd_code='') and (c.supply_type_code= @psup_type or @psup_type is null or @psup_type='') 
					and 
					(a.state_code=@pstate or @pstate is null or @pstate='')
					and
					(a.dist_code=@pdistcode or @pdistcode is null  or @pdistcode='') and (a.tehsil_taluka = @ptaluka or @ptaluka is null or @ptaluka='') and
					-- (a.city_code=@pcitycode or @pcitycode is null) and (a.branch_code = @pbrancode or @pbrancode is null or @pbrancode='') and
					a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcitycode,city_code) and 
					(zone_code in(select  distinct l.zone_code from login_zone_mast l where zone_code=l.zone_code and (zone_code=@pextra4 or @pextra4 is null or @pextra4='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))  and
					(region_code in(select  distinct l.region_code from login_region_mast l where region_code=l.region_code and (region_code=@pextra5 or @pextra5 is null or @pextra5='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))
					)and 

					--  (a.branch_code = pbrancode or pbrancode is null) and
					(a.branch_code in(select  distinct l.branch_code from login_branch_mast l where a.branch_code=l.branch_code and (a.branch_code=@pbrancode or @pbrancode is null or @pbrancode='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))  and

					(c.route_code=@proutecode or @proutecode is null) and isnull(c.supply_flag,'N') ='Y' and 
					((isnull(a.suspend,'N')=isnull(@pextra6,'N')) or (@pextra6 is null) or (@pextra6='')) and
					a.freeze_flag='N' 
					and
					((c.comm_code = @pextra7) or (@pextra7 is null) or (@pextra7 = '')) and 
					(a.ag_type=@pextra1 or @pextra1 is null or @pextra1='') 
					and 
					(a.ag_class=@pextra3 or @pextra3 is null or @pextra3='')
and (ISNULL(c.SP_SUPPLY_MON1,0)+ISNULL(c.SP_SUPPLY_TUE1,0)+ISNULL(c.SP_SUPPLY_WED1,0)+ISNULL(c.SP_SUPPLY_THU1,0)+
ISNULL(c.SP_SUPPLY_FRI1,0)+ISNULL(c.SP_SUPPLY_SAT1,0)+ISNULL(c.SP_SUPPLY_SUN1,0)+ISNULL(c.SP_SUPPLY_MON2,0)+
ISNULL(c.SP_SUPPLY_TUE2,0) +ISNULL(c.SP_SUPPLY_WED2,0)+ISNULL(c.SP_SUPPLY_THU2,0)+ISNULL(c.SP_SUPPLY_FRI2,0)+
ISNULL(c.SP_SUPPLY_SAT2,0)+ISNULL(c.SP_SUPPLY_SUN2,0)+ISNULL(C.BASE_SUPPLY,0)+ISNULL(C.SUPPLY_SUN,0)+ISNULL(C.SUPPLY_MON,0)
+ISNULL(C.SUPPLY_TUE,0)+ISNULL(C.SUPPLY_WED,0)+	ISNULL(C.SUPPLY_THU,0)+ISNULL(C.SUPPLY_FRI,0)+ISNULL(C.SUPPLY_SAT,0)+
ISNULL(C.SUPPLY_SPL1,0)+ISNULL(C.SUPPLY_SPL2,0))>0
					order by route_seq,supply_seq,agency_name,edtn_name,sup_seq_no,supply_type_name
					End
End
end
else
begin
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
					,ISNULL(c.SP_SUPPLY_MON1,0)  SP_SUPPLY_MON1
					,ISNULL(c.SP_SUPPLY_TUE1,0)  SP_SUPPLY_TUE1
					,ISNULL(c.SP_SUPPLY_WED1,0)  SP_SUPPLY_WED1
					,ISNULL(c.SP_SUPPLY_THU1,0)  SP_SUPPLY_THU1
					,ISNULL(c.SP_SUPPLY_FRI1,0)  SP_SUPPLY_FRI1
					,ISNULL(c.SP_SUPPLY_SAT1,0)  SP_SUPPLY_SAT1
					,ISNULL(c.SP_SUPPLY_SUN1,0)  SP_SUPPLY_SUN1
					,ISNULL(c.SP_SUPPLY_MON2,0)  SP_SUPPLY_MON2
					,ISNULL(c.SP_SUPPLY_TUE2,0)  SP_SUPPLY_TUE2
					,ISNULL(c.SP_SUPPLY_WED2,0)  SP_SUPPLY_WED2
					,ISNULL(c.SP_SUPPLY_THU2,0)  SP_SUPPLY_THU2
					,ISNULL(c.SP_SUPPLY_FRI2,0)  SP_SUPPLY_FRI2
					,ISNULL(c.SP_SUPPLY_SAT2,0)  SP_SUPPLY_SAT2
					,ISNULL(c.SP_SUPPLY_SUN2,0)  SP_SUPPLY_SUN2
					,ISNULL(P.CIR_SUP_ORDER_DEC_LIMIT,0) CIR_SUP_ORDER_DEC_LIMIT
					from cir_agmast_dis a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
					where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code= @pcomp_code and p.comp_code= @pcomp_code and
					a.unit=c.unit and a.unit=e.unit_code and a.unit= @punit_code and b.sup_ty_code=c.supply_type_code and
					c.publ=e.publ 
					and (c.publ= @ppubl_code or @ppubl_code is null)
					and c.edtn=e.edtn and (c.edtn = isnull(@pedtn_code,c.edtn) or @pedtn_code='') and (e.main_edtn = isnull(@pmedtn_code,e.main_edtn) or @pmedtn_code='') and 
					a.agcd=c.agcd and (a.bill_agcd=isnull(@pagcd_code,a.bill_agcd) or @pagcd_code='') and a.dpcd=c.dpcd and (a.bill_dpcd=isnull(@pdpcd_code,a.bill_dpcd) or @pdpcd_code='') and (c.supply_type_code= @psup_type or @psup_type is null or @psup_type='') and 
					(a.state_code=@pstate or @pstate is null or @pstate='') and
					(a.dist_code=@pdistcode or @pdistcode is null  or @pdistcode='') and (a.tehsil_taluka = @ptaluka or @ptaluka is null or @ptaluka='') and
					--(a.city_code=@pcitycode or @pcitycode is null) and 
					--(a.branch_code = @pbrancode or @pbrancode is null or @pbrancode='') and

					a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcitycode,city_code) and 
					(zone_code in(select  distinct l.zone_code from login_zone_mast l where zone_code=l.zone_code and (zone_code=@pextra4 or @pextra4 is null or @pextra4='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))  and
					(region_code in(select  distinct l.region_code from login_region_mast l where region_code=l.region_code and (region_code=@pextra5 or @pextra5 is null or @pextra5='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))
					)and

					(a.branch_code in(select  distinct l.branch_code from login_branch_mast l where a.branch_code=l.branch_code and (a.branch_code=@pbrancode or @pbrancode is null or @pbrancode='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))  and


					(c.route_code=@proutecode or @proutecode is null) and isnull(c.supply_flag,'N') ='Y' and 
					((isnull(a.suspend,'N')=isnull(@pextra6,'N')) or (@pextra6 is null) or (@pextra6='')) and
					a.freeze_flag='N' and
					((c.comm_code = @pextra7) or (@pextra7 is null) or (@pextra7 = '')) and 
					(a.ag_type=@pextra1 or @pextra1 is null or @pextra1='') and 
					(a.ag_class=@pextra3 or @pextra3 is null or @pextra3='')
					
and (ISNULL(c.SP_SUPPLY_MON1,0)+ISNULL(c.SP_SUPPLY_TUE1,0)+ISNULL(c.SP_SUPPLY_WED1,0)+ISNULL(c.SP_SUPPLY_THU1,0)+
ISNULL(c.SP_SUPPLY_FRI1,0)+ISNULL(c.SP_SUPPLY_SAT1,0)+ISNULL(c.SP_SUPPLY_SUN1,0)+ISNULL(c.SP_SUPPLY_MON2,0)+
ISNULL(c.SP_SUPPLY_TUE2,0) +ISNULL(c.SP_SUPPLY_WED2,0)+ISNULL(c.SP_SUPPLY_THU2,0)+ISNULL(c.SP_SUPPLY_FRI2,0)+
ISNULL(c.SP_SUPPLY_SAT2,0)+ISNULL(c.SP_SUPPLY_SUN2,0)+ISNULL(C.BASE_SUPPLY,0)+ISNULL(C.SUPPLY_SUN,0)+ISNULL(C.SUPPLY_MON,0)
+ISNULL(C.SUPPLY_TUE,0)+ISNULL(C.SUPPLY_WED,0)+	ISNULL(C.SUPPLY_THU,0)+ISNULL(C.SUPPLY_FRI,0)+ISNULL(C.SUPPLY_SAT,0)+
ISNULL(C.SUPPLY_SPL1,0)+ISNULL(C.SUPPLY_SPL2,0))>0
					
					
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
					,ISNULL(c.SP_SUPPLY_MON1,0)  SP_SUPPLY_MON1
					,ISNULL(c.SP_SUPPLY_TUE1,0)  SP_SUPPLY_TUE1
					,ISNULL(c.SP_SUPPLY_WED1,0)  SP_SUPPLY_WED1
					,ISNULL(c.SP_SUPPLY_THU1,0)  SP_SUPPLY_THU1
					,ISNULL(c.SP_SUPPLY_FRI1,0)  SP_SUPPLY_FRI1
					,ISNULL(c.SP_SUPPLY_SAT1,0)  SP_SUPPLY_SAT1
					,ISNULL(c.SP_SUPPLY_SUN1,0)  SP_SUPPLY_SUN1
					,ISNULL(c.SP_SUPPLY_MON2,0)  SP_SUPPLY_MON2
					,ISNULL(c.SP_SUPPLY_TUE2,0)  SP_SUPPLY_TUE2
					,ISNULL(c.SP_SUPPLY_WED2,0)  SP_SUPPLY_WED2
					,ISNULL(c.SP_SUPPLY_THU2,0)  SP_SUPPLY_THU2
					,ISNULL(c.SP_SUPPLY_FRI2,0)  SP_SUPPLY_FRI2
					,ISNULL(c.SP_SUPPLY_SAT2,0)  SP_SUPPLY_SAT2
					,ISNULL(c.SP_SUPPLY_SUN2,0)  SP_SUPPLY_SUN2
					,ISNULL(P.CIR_SUP_ORDER_DEC_LIMIT,0) CIR_SUP_ORDER_DEC_LIMIT
					from cir_agmast_dis a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
					where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code= @pcomp_code and p.comp_code= @pcomp_code and
					a.unit=c.unit and a.unit=e.unit_code and a.unit= @punit_code and b.sup_ty_code=c.supply_type_code and
					c.publ=e.publ 
					and (c.publ= @ppubl_code  or @ppubl_code is null)
					and c.edtn=e.edtn and (c.edtn = isnull(@pedtn_code,c.edtn) or @pedtn_code='') and (e.main_edtn = isnull(@pmedtn_code,e.main_edtn) or @pmedtn_code='') and 
					a.agcd=c.agcd and (a.bill_agcd=isnull(@pagcd_code,a.bill_agcd) or @pagcd_code='') and a.dpcd=c.dpcd and (a.bill_dpcd=isnull(@pdpcd_code,a.bill_dpcd) or @pdpcd_code='') and (c.supply_type_code= @psup_type or @psup_type is null or @psup_type='') and 
					(a.state_code=@pstate or @pstate is null or @pstate='') and
					(a.dist_code=@pdistcode or @pdistcode is null  or @pdistcode='') and (a.tehsil_taluka = @ptaluka or @ptaluka is null or @ptaluka='') and
					--  (a.city_code=@pcitycode or @pcitycode is null) and (a.branch_code = @pbrancode or @pbrancode is null or @pbrancode='') and

					a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcitycode,city_code) and 
					(zone_code in(select  distinct l.zone_code from login_zone_mast l where zone_code=l.zone_code and (zone_code=@pextra4 or @pextra4 is null or @pextra4='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))  and
					(region_code in(select  distinct l.region_code from login_region_mast l where region_code=l.region_code and (region_code=@pextra5 or @pextra5 is null or @pextra5='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))
					)and 


					-- (a.branch_code = pbrancode or pbrancode is null) and
					(a.branch_code in(select  distinct l.branch_code from login_branch_mast l where a.branch_code=l.branch_code and (a.branch_code=@pbrancode or @pbrancode is null or @pbrancode='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))  and



					(c.route_code=@proutecode or @proutecode is null) and isnull(c.supply_flag,'N') ='Y' and 
					((isnull(a.suspend,'N')=isnull(@pextra6,'N')) or (@pextra6 is null) or (@pextra6='')) and
					a.freeze_flag='N' and
					((c.comm_code = @pextra7) or (@pextra7 is null) or (@pextra7 = '')) and 
					(a.ag_type=@pextra1 or @pextra1 is null or @pextra1='') and 
					(a.ag_class=@pextra3 or @pextra3 is null or @pextra3='')
					and (ISNULL(c.SP_SUPPLY_MON1,0)+ISNULL(c.SP_SUPPLY_TUE1,0)+ISNULL(c.SP_SUPPLY_WED1,0)+ISNULL(c.SP_SUPPLY_THU1,0)+
ISNULL(c.SP_SUPPLY_FRI1,0)+ISNULL(c.SP_SUPPLY_SAT1,0)+ISNULL(c.SP_SUPPLY_SUN1,0)+ISNULL(c.SP_SUPPLY_MON2,0)+
ISNULL(c.SP_SUPPLY_TUE2,0) +ISNULL(c.SP_SUPPLY_WED2,0)+ISNULL(c.SP_SUPPLY_THU2,0)+ISNULL(c.SP_SUPPLY_FRI2,0)+
ISNULL(c.SP_SUPPLY_SAT2,0)+ISNULL(c.SP_SUPPLY_SUN2,0)+ISNULL(C.BASE_SUPPLY,0)+ISNULL(C.SUPPLY_SUN,0)+ISNULL(C.SUPPLY_MON,0)
+ISNULL(C.SUPPLY_TUE,0)+ISNULL(C.SUPPLY_WED,0)+	ISNULL(C.SUPPLY_THU,0)+ISNULL(C.SUPPLY_FRI,0)+ISNULL(C.SUPPLY_SAT,0)+
ISNULL(C.SUPPLY_SPL1,0)+ISNULL(C.SUPPLY_SPL2,0))>0
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
					C.SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBROUTE(A.COMP_CODE,a.UNIT,C.ROUTE_CODE,C.SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBROUTE_NAME,
					C.SUB_SUBROUTE_CODE,DBO.CIR_GET_NAME_CIR_SUBSUBROUTE(A.COMP_CODE,A.UNIT,C.ROUTE_CODE,C.SUBROUTE_CODE,C.SUB_SUBROUTE_CODE,1,@PDATEFORMAT,'','') SUBSUBROUTE_NAME,
					D.DIST_NAME DIST_NAME,ISNULL(P.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,C.SUPPLY_TYPE_CODE SUPPLY_TYPE_CODE,B.SUP_TY_NAME SUPPLY_TYPE_NAME,
					C.EDTN EDTN,E.EDTN_NAME EDTN_NAME,B.SUP_SEQ_NO SUP_SEQ_NO,
					A.SUSPEND SUSPEND,C.PUBL PUBL,DB0.CIR_GET_PUBL_NAME(A.COMP_CODE,C.PUBL) PUBL_NAME
					,ISNULL(c.SP_SUPPLY_MON1,0)  SP_SUPPLY_MON1
					,ISNULL(c.SP_SUPPLY_TUE1,0)  SP_SUPPLY_TUE1
					,ISNULL(c.SP_SUPPLY_WED1,0)  SP_SUPPLY_WED1
					,ISNULL(c.SP_SUPPLY_THU1,0)  SP_SUPPLY_THU1
					,ISNULL(c.SP_SUPPLY_FRI1,0)  SP_SUPPLY_FRI1
					,ISNULL(c.SP_SUPPLY_SAT1,0)  SP_SUPPLY_SAT1
					,ISNULL(c.SP_SUPPLY_SUN1,0)  SP_SUPPLY_SUN1
					,ISNULL(c.SP_SUPPLY_MON2,0)  SP_SUPPLY_MON2
					,ISNULL(c.SP_SUPPLY_TUE2,0)  SP_SUPPLY_TUE2
					,ISNULL(c.SP_SUPPLY_WED2,0)  SP_SUPPLY_WED2
					,ISNULL(c.SP_SUPPLY_THU2,0)  SP_SUPPLY_THU2
					,ISNULL(c.SP_SUPPLY_FRI2,0)  SP_SUPPLY_FRI2
					,ISNULL(c.SP_SUPPLY_SAT2,0)  SP_SUPPLY_SAT2
					,ISNULL(c.SP_SUPPLY_SUN2,0)  SP_SUPPLY_SUN2
					,ISNULL(P.CIR_SUP_ORDER_DEC_LIMIT,0) CIR_SUP_ORDER_DEC_LIMIT
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
					--(a.city_code=@pcitycode or @pcitycode is null) and (a.branch_code = @pbrancode or @pbrancode is null or @pbrancode='') and

					a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcitycode,city_code) and 
					(zone_code in(select  distinct l.zone_code from login_zone_mast l where zone_code=l.zone_code and (zone_code=@pextra4 or @pextra4 is null or @pextra4='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))  and
					(region_code in(select  distinct l.region_code from login_region_mast l where region_code=l.region_code and (region_code=@pextra5 or @pextra5 is null or @pextra5='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))
					)and 

					--  (a.branch_code = pbrancode or pbrancode is null) and
					(a.branch_code in(select  distinct l.branch_code from login_branch_mast l where a.branch_code=l.branch_code and (a.branch_code=@pbrancode or @pbrancode is null or @pbrancode='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))  and

					(c.route_code=@proutecode or @proutecode is null) and isnull(c.supply_flag,'N') ='Y' and 
					((isnull(a.suspend,'N')=isnull(@pextra6,'N')) or (@pextra6 is null) or (@pextra6='')) and
					a.freeze_flag='N' and
					((c.comm_code = @pextra7) or (@pextra7 is null) or (@pextra7 = '')) and 
					(a.ag_type=@pextra1 or @pextra1 is null or @pextra1='') and (a.ag_class=@pextra3 or @pextra3 is null or @pextra3='')
					and (ISNULL(c.SP_SUPPLY_MON1,0)+ISNULL(c.SP_SUPPLY_TUE1,0)+ISNULL(c.SP_SUPPLY_WED1,0)+ISNULL(c.SP_SUPPLY_THU1,0)+
ISNULL(c.SP_SUPPLY_FRI1,0)+ISNULL(c.SP_SUPPLY_SAT1,0)+ISNULL(c.SP_SUPPLY_SUN1,0)+ISNULL(c.SP_SUPPLY_MON2,0)+
ISNULL(c.SP_SUPPLY_TUE2,0) +ISNULL(c.SP_SUPPLY_WED2,0)+ISNULL(c.SP_SUPPLY_THU2,0)+ISNULL(c.SP_SUPPLY_FRI2,0)+
ISNULL(c.SP_SUPPLY_SAT2,0)+ISNULL(c.SP_SUPPLY_SUN2,0)+ISNULL(C.BASE_SUPPLY,0)+ISNULL(C.SUPPLY_SUN,0)+ISNULL(C.SUPPLY_MON,0)
+ISNULL(C.SUPPLY_TUE,0)+ISNULL(C.SUPPLY_WED,0)+	ISNULL(C.SUPPLY_THU,0)+ISNULL(C.SUPPLY_FRI,0)+ISNULL(C.SUPPLY_SAT,0)+
ISNULL(C.SUPPLY_SPL1,0)+ISNULL(C.SUPPLY_SPL2,0))>0
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
					A.SUSPEND SUSPEND,C.PUBL PUBL,dbo.cir_get_publ_name(A.COMP_CODE,C.PUBL) PUBL_NAME
					,ISNULL(c.SP_SUPPLY_MON1,0)  SP_SUPPLY_MON1
					,ISNULL(c.SP_SUPPLY_TUE1,0)  SP_SUPPLY_TUE1
					,ISNULL(c.SP_SUPPLY_WED1,0)  SP_SUPPLY_WED1
					,ISNULL(c.SP_SUPPLY_THU1,0)  SP_SUPPLY_THU1
					,ISNULL(c.SP_SUPPLY_FRI1,0)  SP_SUPPLY_FRI1
					,ISNULL(c.SP_SUPPLY_SAT1,0)  SP_SUPPLY_SAT1
					,ISNULL(c.SP_SUPPLY_SUN1,0)  SP_SUPPLY_SUN1
					,ISNULL(c.SP_SUPPLY_MON2,0)  SP_SUPPLY_MON2
					,ISNULL(c.SP_SUPPLY_TUE2,0)  SP_SUPPLY_TUE2
					,ISNULL(c.SP_SUPPLY_WED2,0)  SP_SUPPLY_WED2
					,ISNULL(c.SP_SUPPLY_THU2,0)  SP_SUPPLY_THU2
					,ISNULL(c.SP_SUPPLY_FRI2,0)  SP_SUPPLY_FRI2
					,ISNULL(c.SP_SUPPLY_SAT2,0)  SP_SUPPLY_SAT2
					,ISNULL(c.SP_SUPPLY_SUN2,0)  SP_SUPPLY_SUN2
					,ISNULL(P.CIR_SUP_ORDER_DEC_LIMIT,0) CIR_SUP_ORDER_DEC_LIMIT
					from cir_agmast a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
					where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code= @pcomp_code and p.comp_code= @pcomp_code and
					a.unit=c.unit and a.unit=e.unit_code and a.unit= @punit_code and b.sup_ty_code=c.supply_type_code and
					c.publ=e.publ 
					and (c.publ= @ppubl_code or @ppubl_code is null)
					and c.edtn=e.edtn and (c.edtn = isnull(@pedtn_code,c.edtn) or @pedtn_code='') and (e.main_edtn = isnull(@pmedtn_code,e.main_edtn) or @pmedtn_code='') 
					and 
					a.agcd=c.agcd and (a.bill_agcd=isnull(@pagcd_code,a.bill_agcd) or @pagcd_code='') 
					and a.dpcd=c.dpcd and (a.bill_dpcd=isnull(@pdpcd_code,a.bill_dpcd) or @pdpcd_code='') and (c.supply_type_code= @psup_type or @psup_type is null or @psup_type='') 
					and 
					(a.state_code=@pstate or @pstate is null or @pstate='')
					and
					(a.dist_code=@pdistcode or @pdistcode is null  or @pdistcode='') and (a.tehsil_taluka = @ptaluka or @ptaluka is null or @ptaluka='') and
					-- (a.city_code=@pcitycode or @pcitycode is null) and (a.branch_code = @pbrancode or @pbrancode is null or @pbrancode='') and
					a.city_code in (select city_code from cir_city_mast where a.comp_code=@pcomp_code and city_code = isnull(@pcitycode,city_code) and 
					(zone_code in(select  distinct l.zone_code from login_zone_mast l where zone_code=l.zone_code and (zone_code=@pextra4 or @pextra4 is null or @pextra4='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))  and
					(region_code in(select  distinct l.region_code from login_region_mast l where region_code=l.region_code and (region_code=@pextra5 or @pextra5 is null or @pextra5='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))
					)and 

					--  (a.branch_code = pbrancode or pbrancode is null) and
					(a.branch_code in(select  distinct l.branch_code from login_branch_mast l where a.branch_code=l.branch_code and (a.branch_code=@pbrancode or @pbrancode is null or @pbrancode='')and  l.user_code=@puserid and isnull(l.user_flag,'N')='Y' ))  and

					(c.route_code=@proutecode or @proutecode is null) and isnull(c.supply_flag,'N') ='Y' and 
					((isnull(a.suspend,'N')=isnull(@pextra6,'N')) or (@pextra6 is null) or (@pextra6='')) and
					a.freeze_flag='N' 
					and
					((c.comm_code = @pextra7) or (@pextra7 is null) or (@pextra7 = '')) and 
					(a.ag_type=@pextra1 or @pextra1 is null or @pextra1='') 
					and 
					(a.ag_class=@pextra3 or @pextra3 is null or @pextra3='')
and (ISNULL(c.SP_SUPPLY_MON1,0)+ISNULL(c.SP_SUPPLY_TUE1,0)+ISNULL(c.SP_SUPPLY_WED1,0)+ISNULL(c.SP_SUPPLY_THU1,0)+
ISNULL(c.SP_SUPPLY_FRI1,0)+ISNULL(c.SP_SUPPLY_SAT1,0)+ISNULL(c.SP_SUPPLY_SUN1,0)+ISNULL(c.SP_SUPPLY_MON2,0)+
ISNULL(c.SP_SUPPLY_TUE2,0) +ISNULL(c.SP_SUPPLY_WED2,0)+ISNULL(c.SP_SUPPLY_THU2,0)+ISNULL(c.SP_SUPPLY_FRI2,0)+
ISNULL(c.SP_SUPPLY_SAT2,0)+ISNULL(c.SP_SUPPLY_SUN2,0)+ISNULL(C.BASE_SUPPLY,0)+ISNULL(C.SUPPLY_SUN,0)+ISNULL(C.SUPPLY_MON,0)
+ISNULL(C.SUPPLY_TUE,0)+ISNULL(C.SUPPLY_WED,0)+	ISNULL(C.SUPPLY_THU,0)+ISNULL(C.SUPPLY_FRI,0)+ISNULL(C.SUPPLY_SAT,0)+
ISNULL(C.SUPPLY_SPL1,0)+ISNULL(C.SUPPLY_SPL2,0))>0
					order by route_seq,supply_seq,agency_name,edtn_name,sup_seq_no,supply_type_name
					End
End
End
End

///////////////////////////////////next


ALTER function [dbo].[cir_chk_rate_commission](
@comp_code		varchar(10),
@unit_code		varchar(10),
@pub_code		varchar(10),
@edtn_code		varchar(10),
@user_id		varchar(10),
@dateformat		varchar(10),
@extra1			varchar(10),
@extra2			varchar(10)
)returns varchar(200)
begin
		declare @countr as numeric(10);
		declare @countc as numeric(10);
		declare @countcommcat as numeric(10);
		declare @msg   as varchar(200);
		select @countr=count(*) from CIR_RATE_MAST where COMP_CODE=@comp_code 
		and (unit=@unit_code or @unit_code='' or @unit_code is null)
		and PUBL=@pub_code and EDTN= @edtn_code 
		
		if(@countr>0)
			begin
				--select @countcommcat=count(*) from CIR_COMM_CATG_MAST
				--select @countc=count(*) from CIR_COMM_MAST where COMP_CODE=@comp_code 
				--and (UNIT_CODE=@unit_code or @unit_code='' or @unit_code is null)
				--and PUBL=@pub_code and EDTN= @edtn_code
				--if(@countc=1) 
				--begin
					set @msg='ok'
				--End
				--else
				--begin
				--	set @msg='First Enter Commission Of All category For This Edition!'
				--End
				
			End
		else
			begin
				set @msg='First Open Rate For This Edition!!'
			End
			
			
	return @msg;
End

//////////////////////////////////next


ALTER PROCEDURE  [dbo].[cir_new_publ_update_in_supply]

  	@pcompcode as varchar(200),
    @pdateformat as	varchar(200),
    @puserid as varchar(200),    
    @punitcode as varchar(200),    
    @pbranch as varchar(200),
    @ppubl   as varchar(200),
    @pedtn   as varchar(20),
    @pextra1 as	varchar(200),
    @pextra2 as varchar(200),
    @pextra3 as	varchar(200),
    @pextra4 as varchar(200),
    @pextra5 as	varchar(200),
    @pextra6 as varchar(200),
    @pextra7 as	varchar(200),
    @pextra8 as varchar(200),
    @pextra9 as	varchar(200),
    @pextra10 as varchar(200)

 AS
   begin
		 declare @countc as numeric(10)
		 declare @countcommcat as numeric(10);
   				select @countcommcat=count(*) from CIR_COMM_CATG_MAST
				select @countc=count(*) from CIR_COMM_MAST where COMP_CODE=@pcompcode 
				and (UNIT_CODE=@punitcode or @punitcode='' or @punitcode is null)
				and PUBL=@ppubl and EDTN= @pedtn
				
		if @countc=0
		begin
		declare @v3_UNIT			as varchar(20)
		declare @v3_COMM_CD			as varchar(20)
		declare @v3_COMM_TYP		as varchar(20)
		declare @v3_VALID_FROM		as datetime
		declare @v3_SUP_FROM		as numeric(10)
		declare @v3_SUP_TO			as numeric(10)
		declare @v3_SUN_COMM		as numeric(10)
		declare @v3_MON_COMM		as numeric(10)
		declare @v3_TUS_COMM		as numeric(10)
		declare @v3_WED_COMM		as numeric(10)
		declare @v3_THU_COMM		as numeric(10)
		declare @v3_FRI_COMM		as numeric(10)
		declare @v3_SAT_COMM		as numeric(10)
		declare @v3_FREEZE_FLG		as varchar(1)
		declare @v3_COMM_CAT_CODE	as varchar(5)
		declare @v3_COMM_CAT_TYP	as varchar(1)
	

		declare comm cursor local for
			select unit_code,COMM_CODE,COMM_TYPE,VALID_FROM,SUP_COPY_FROM,SUP_COPY_TO,SUN_COMM_RATE,MON_COMM_RATE,TUE_COMM_RATE,
			WED_COMM_RATE,THU_COMM_RATE,FRI_COMM_RATE,SAT_COMM_RATE,FREEZE_FLAG,COMM_CATG_CODE,COMM_CATG_TYPE from CIR_COMM_MAST
			where PUBL in(select top 1 publ from CIR_PUBL_MAST where PRO_TYPE in(select PRO_TYPE from CIR_PUBL_MAST 
			where COMP_CODE =@pcompcode and PUBL=@ppubl))and EDTN in (select top 1 EDTN  from CIR_EDTN_MAST where PUBL 
			in(select top 1 publ from CIR_PUBL_MAST where PRO_TYPE in(select PRO_TYPE from CIR_PUBL_MAST where COMP_CODE =@pcompcode
			and PUBL=@ppubl)) and EDTN_TY='S')
		open comm

			fetch  next from comm into  @v3_unit,@v3_COMM_CD,@v3_COMM_TYP,@v3_VALID_FROM,@v3_SUP_FROM,@v3_SUP_TO,@v3_SUN_COMM,@v3_MON_COMM,@v3_TUS_COMM,
			@v3_WED_COMM,@v3_THU_COMM,@v3_FRI_COMM,@v3_SAT_COMM,@v3_FREEZE_FLG,@v3_COMM_CAT_CODE,@v3_COMM_CAT_TYP
				 while (@@fetch_status=0)
				 Begin
			 
					 insert into CIR_COMM_MAST(COMP_CODE,UNIT_CODE,PUBL,EDTN,COMM_CODE,COMM_TYPE,VALID_FROM,SUP_COPY_FROM,SUP_COPY_TO,SUN_COMM_RATE,MON_COMM_RATE,TUE_COMM_RATE,
					 WED_COMM_RATE,THU_COMM_RATE,FRI_COMM_RATE,SAT_COMM_RATE,FREEZE_FLAG,CREATION_DATE, COMM_CATG_CODE,COMM_CATG_TYPE,UPDATED_DT) 
					 values(@pcompcode,@v3_unit,@ppubl,@pedtn,@v3_COMM_CD,@v3_COMM_TYP,@v3_VALID_FROM,@v3_SUP_FROM,@v3_SUP_TO,@v3_SUN_COMM,@v3_MON_COMM,@v3_TUS_COMM,
					 @v3_WED_COMM,@v3_THU_COMM,@v3_FRI_COMM,@v3_SAT_COMM,@v3_FREEZE_FLG,GETDATE(),@v3_COMM_CAT_CODE,@v3_COMM_CAT_TYP,GETDATE())
				
			fetch  next from comm into  @v3_unit,@v3_COMM_CD,@v3_COMM_TYP,@v3_VALID_FROM,@v3_SUP_FROM,@v3_SUP_TO,@v3_SUN_COMM,@v3_MON_COMM,@v3_TUS_COMM,
			@v3_WED_COMM,@v3_THU_COMM,@v3_FRI_COMM,@v3_SAT_COMM,@v3_FREEZE_FLG,@v3_COMM_CAT_CODE,@v3_COMM_CAT_TYP
			end
			close comm
			deallocate comm
			end
				
				
   declare @v1_UNIT as varchar(20)
   declare @v1_AGCD as varchar(20)
   declare @v1_DPCD as varchar(20)
   declare @v1_BILLING_CYCLE as varchar(2)
   declare @v1_INSERTION_FEE as varchar(2)
   declare @v1_LATE_FEE as varchar(2)
   declare @v1_INCENTIVE as varchar(2)
   declare @v_cnt as int
	declare @v2_COMM_FLAG as varchar(20)
	declare @v2_COMM_CODE as varchar(20)
	declare @v2_ROUTE_CODE as varchar(20)
	declare @v2_SUBROUTE_CODE as varchar(20)
	declare @v2_SUB_SUBROUTE_CODE as varchar(20)
	declare @v2_WASTE_CATG_CODE as varchar(20)

   
   DECLARE c1 cursor LOCAL FOR 
    select UNIT,AGCD,DPCD from cir_agmast where COMP_CODE=@pcompcode 
    and (UNIT=@punitcode or @punitcode is null or @punitcode ='')
   
	   
	OPEN c1 
	fetch NEXT FROM c1 INTO @v1_UNIT, @v1_AGCD ,@v1_DPCD
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
			print('A')
			DECLARE c2 cursor LOCAL FOR 
			select top 1 COMM_FLAG,COMM_CODE,ROUTE_CODE,SUBROUTE_CODE,SUB_SUBROUTE_CODE,WASTE_CATG_CODE,BILLING_CYCLE,INCENTIVE
			,INSERTION_FEE,LATE_FEE
			from cir_supply
			where COMP_CODE=@pcompcode and agcd=@v1_AGCD and dpcd=@v1_DPCD
			and (UNIT=@punitcode or @punitcode is null or @punitcode ='')
			
			
			OPEN c2 
			fetch NEXT FROM c2 INTO @v2_COMM_FLAG,@v2_COMM_CODE,@v2_ROUTE_CODE,@v2_SUBROUTE_CODE,@v2_SUB_SUBROUTE_CODE,@v2_WASTE_CATG_CODE,@v1_BILLING_CYCLE,@v1_INCENTIVE,@v1_INSERTION_FEE,@v1_LATE_FEE
				WHILE (@@FETCH_STATUS = 0) 
				BEGIN print('Q')
					select @v_cnt =count(*) from CIR_SUPPLY where COMP_CODE=@pcompcode 
					and AGCD=@v1_AGCD and DPCD=@v1_DPCD and PUBL=@ppubl and EDTN=@pedtn
					print(@v_cnt)
					if(@v_cnt=0)
					begin
						INSERT INTO cir_supply (COMP_CODE,UNIT,AGCD,DPCD,PUBL,EDTN,SUPPLY_FLAG,SUPPLY_TYPE_CODE,BASE_SUPPLY,SUPPLY_SUN
												,SUPPLY_MON,SUPPLY_TUE,SUPPLY_WED,SUPPLY_THU,SUPPLY_FRI,SUPPLY_SAT,DEVATION_SUPPLY
												,COMM_FLAG,COMM_CODE,PACKET_SIZE,ROUTE_CODE,SUBROUTE_CODE,SUB_SUBROUTE_CODE,USERID
												,SUPPLY_SPL1,SUPPLY_SPL2,LBL_PRINTNO,SURCH_CD,BILLING_CYCLE,INSERTION_FEE,WASTE_CATG_CODE
												,SP_SUPPLY_MON1,SP_SUPPLY_TUE1,SP_SUPPLY_WED1,SP_SUPPLY_THU1,SP_SUPPLY_FRI1,SP_SUPPLY_SAT1
												,SP_SUPPLY_SUN1,SP_SUPPLY_MON2,SP_SUPPLY_TUE2,SP_SUPPLY_WED2,SP_SUPPLY_THU2,SP_SUPPLY_FRI2
												,SP_SUPPLY_SAT2,SP_SUPPLY_SUN2,LATE_FEE,INCENTIVE)
						VALUES				   (@pcompcode,@v1_UNIT,@v1_AGCD,@v1_DPCD,@ppubl,@pedtn,'Y','S01',0,0
												,0,0,0,0,0,0,0,
												@v2_COMM_FLAG,@v2_COMM_CODE,0,@v2_ROUTE_CODE,@v2_SUBROUTE_CODE,@v2_SUB_SUBROUTE_CODE,@puserid
												,0,0,0,null,@v1_BILLING_CYCLE,@v1_INSERTION_FEE,@v2_WASTE_CATG_CODE
												,0,0,0,0,0,0,0,0,0,0,0,0
												,0,0,@v1_LATE_FEE,@v1_INCENTIVE)
					end
					
				fetch NEXT FROM c2 INTO @v2_COMM_FLAG,@v2_COMM_CODE,@v2_ROUTE_CODE,@v2_SUBROUTE_CODE,@v2_SUB_SUBROUTE_CODE,@v2_WASTE_CATG_CODE,@v1_BILLING_CYCLE,@v1_INCENTIVE,@v1_INSERTION_FEE,@v1_LATE_FEE
				END 
			close c2
			DEALLOCATE c2

		fetch NEXT FROM c1 INTO @v1_UNIT, @v1_AGCD ,@v1_DPCD--,@v1_BILLING_CYCLE,@v1_INSERTION_FEE,@v1_LATE_FEE,@v1_INCENTIVE
		END 
	close c1
	DEALLOCATE c1
   
end








//////////////////////////////////////////////////end////////////////////////////////////////////////////

//////////////////////////////////////////////add by deepika 05/10/2012 sent by gaurav sir///////////////


IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CIR_BANK_GUARANTEE]') AND name = N'CIR_BANK_GUARANTEE_PK')
ALTER TABLE [dbo].[CIR_BANK_GUARANTEE] DROP CONSTRAINT [CIR_BANK_GUARANTEE_PK]
GO
alter table CIR_BANK_GUARANTEE alter column bg_no varchar(20) not null

ALTER TABLE [dbo].[CIR_BANK_GUARANTEE] ADD  CONSTRAINT [CIR_BANK_GUARANTEE_PK] PRIMARY KEY CLUSTERED 
(
	[COMP_CODE] ASC,
	[UNIT_CODE] ASC,
	[AGCD] ASC,
	[DPCD] ASC,
	[BG_NO] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CIR_BANK_GUARANTEE_DIS]') AND name = N'CIR_BANK_GUARANTEE_DIS_PK')
ALTER TABLE [dbo].[CIR_BANK_GUARANTEE_DIS] DROP CONSTRAINT [CIR_BANK_GUARANTEE_DIS_PK]
GO

alter table CIR_BANK_GUARANTEE_DIS alter column bg_no varchar(20) not null

ALTER TABLE [dbo].[CIR_BANK_GUARANTEE_DIS] ADD  CONSTRAINT [CIR_BANK_GUARANTEE_DIS_PK] PRIMARY KEY CLUSTERED 
(
	[COMP_CODE] ASC,
	[UNIT_CODE] ASC,
	[AGCD] ASC,
	[DPCD] ASC,
	[BG_NO] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

alter table CIR_BANK_GUARANTEE_LOG alter column bg_no varchar(20) not null



////////////////////////////////////////next

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
    ,dbo.cir_get_branch(m.COMP_CODE,m.BRANCH_CODE) as BRANCH
	,dbo.cir_get_unit_name(m.COMP_CODE,m.UNIT) as UNIT
    FROM cir_bank_guarantee b,cir_agmast m
    where m.comp_code =b.comp_code and m.comp_code = @pcomp_code and b.unit_code=m.unit  
    and b.agcd=m.agcd and b.agcd    = ISNULL(@pagcd,b.agcd) 
    and b.dpcd=m.dpcd and b.dpcd    = ISNULL(@pdpcd,b.dpcd)
    and ((b.bg_type = @pinstrument_ty) or (@pinstrument_ty is null))
    and b.bg_valid between convert(varchar(20),@pexpiry_date,101) and convert(varchar(20),@v_dt,101) 
    ORDER BY AG_NAME
END


////////////////////////////////////////next

ALTER PROCEDURE [dbo].[cir_bankbind_cir_bank_bind_p]
	@pcomp_code                               VARCHAR(20) ,
	@pbank_code                                VARCHAR(20) ,
	@pdateformat                               VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
	
		SELECT
				 comp_code COMP_CODE,
				 bankcode BANKCODE,
				 bankname BANKNAME,
				 city_code CITY_CODE,
				 (		SELECT city_name
				FROM  cir_city_mast 
				WHERE	 comp_code  = @pcomp_code
				 AND	city_code  = cir_bank_mast.city_code
		) CITY_NAME,
				 userid,
				 creation_datetime
		FROM  cir_bank_mast 
		WHERE	 comp_code  = @pcomp_code
		and (BANKCODE=@pbank_code		or @pbank_code is null or @pbank_code ='')
		ORDER BY city_name, 			 bankname 
		



///////////////////////////////////////////next

ALTER procedure [dbo].[cir_get_tran_detail]
(
@ptext1 varchar(200),
@pcomp_code varchar(200),
@ptext2 varchar(200),
@punit_code varchar(200),
@ptext3 varchar(200),
@puser_code varchar(200),
@ptext4 varchar(200),
@pfromdt varchar(200),
@ptodt varchar(200),
@ptname varchar(200),
@pdateformat varchar(200)
)

as
begin

declare @pquery varchar(2000)

print('prachi')

set @pquery='select * from '+@ptname+' where '+@ptext1+'= '''+@pcomp_code+'''  '
if(@ptext2!='' and @ptext2 is not null and @punit_code!='' and @punit_code is not null) begin
set @pquery=@pquery+' and '+@ptext2+'= '''+@punit_code+'''  '
end
if(@ptext3!='' and @ptext3 is not null and @puser_code!='' and @puser_code is not null) begin
set @pquery=@pquery+' and '+@ptext3+'= '''+@puser_code+'''  '
end
if(@ptext4!='' and @ptext4 is not null) begin
--set @pquery=@pquery+' and '+ CONVERT(varchar(10), @ptext4,101)   +' between cast( DBO.CONVERT_USER_DATE(''/'', '''+@pfromdt+''',''mm/dd/yyyy'')as datetime)  and  cast( DBO.CONVERT_USER_DATE(''/'','''+@ptodt+''',''mm/dd/yyyy'')as datetime) '
set @pquery=@pquery+' and  CONVERT(varchar(10),'+ @ptext4 +',101)    between cast( '''+convert(varchar(10), @pfromdt,101)+''' as datetime)  and  cast( '''+convert(varchar(10), @ptodt,101)+'''  as datetime) '
end
print(@pquery)
exec(@pquery)
end


//////////////////////////////////////////////////////////////end///////////////////////////////////////////////

////////////////////////////////add by deepika 05/10/2012 sent by gaurav sir/////////////////////



ALTER FUNCTION [dbo].[cir_get_route_name](@pcomp_code  varchar(20),@punit_code  varchar(20),@proute  varchar(20)) 
RETURNs varchar(200) AS

   Begin
   declare @v_prefer as varchar(1)
   declare  @vroute_name      varchar(200)

	select @v_prefer=DIFF_SUPPLY_ROUTE from preferrences where comp_code=@pcomp_code
    if(isnull(@v_prefer,'N')='N')
    begin
		select @vroute_name = route_name  from cir_route_mast
        where comp_code=@pcomp_code and unit=@punit_code and route_code=@proute;
    end
    else
    begin
    	select @vroute_name = route_name  from cir_route_mast
        where comp_code=@pcomp_code and route_code=@proute;    
    end
  
    Return isnull(@vroute_name,'');
END;

////////////////////////////////////////////////////////next

ALTER PROCEDURE [dbo].[cir_rep_supply_cir_dist_supply_variance_p]
    @pcomp_code                               VARCHAR(20) ,
    @punit_code                               VARCHAR(20) ,
    @ppublication                             VARCHAR(20) ,
    @pmainedtn                                VARCHAR(20) ,
    @pedtn                                    VARCHAR(20) ,
    @pdist                                    VARCHAR(20) ,
    @pfirstdate                                VARCHAR(20),
    @pseconddate                               VARCHAR(20),
    @pdateformat                              VARCHAR(20) ,
    @pextra1                                  VARCHAR(200) ,
    @pextra2                                  VARCHAR(200) ,
    @pextra3             as varchar(200),--agency type
    @pextra4             as varchar(200),-- agency class
    @pextra5             as varchar(200),--final.unfinal
    @pextra6             as varchar(200),
    @pextra7             as varchar(200),
    @pextra8             as varchar(200),
    @pextra9             as varchar(200),
    @pextra10            as varchar(200)
AS

    DECLARE @vfirstdate                               DATETIME
    DECLARE @vseconddate                              DATETIME
    --    SELECT @vfirstdate  = @pfirstdate
    --    SELECT @vseconddate  =  @pseconddate
    SET @vfirstdate  =  dbo.convert_user_date('/',@pfirstdate,@pdateformat)
    SET @vseconddate  = dbo.convert_user_date('/',@pseconddate,@pdateformat)

print(@vfirstdate)
print(@vseconddate)

if upper(@pextra1)='U' begin       
	SELECT
	m.comp_code "COMP CODE",m.agcd "AGENCY CODE",m.dpcd "AGENCY SUB CODE",
	m.ag_name "AGENCY NAME",m.ag_name_oth_lang "AGENCY OTHER LANG",DBO.cir_get_city(m.comp_code, m.city_code) "CITY NAME",
	m.dist_code "DISTRICT CODE",m.dist_name "DISTRICT NAME",m.dist_oname "DISTRICT NAME OTHER LANG",
	SUM(m.first_sup) "FIRST SUPPLY",SUM(m.second_sup) "SECOND SUPPLY",

	CASE sign(ISNULL(SUM(m.second_sup), 0) - ISNULL(SUM(m.first_sup), 0)) WHEN - 1 THEN 0
	ELSE (ISNULL(SUM(m.second_sup), 0) - ISNULL(SUM(m.first_sup), 0))
	END "INCREASE SUPPLY",

	CASE sign(ISNULL(SUM(m.second_sup), 0) - ISNULL(SUM(m.first_sup), 0)) WHEN 1 THEN 0
	ELSE (ISNULL(SUM(m.second_sup), 0) - ISNULL(SUM(m.first_sup), 0))
	END "DECREASE SUPPLY",

	CASE ISNULL(SUM(m.first_sup), 0) WHEN 0 THEN 100
	ELSE ROUND(((ISNULL(SUM(m.second_sup), 0) - ISNULL(SUM(m.first_sup), 0)) * 100) / CONVERT(FLOAT,
	CASE sign(SUM(m.second_sup) - SUM(m.first_sup)) WHEN - 1 THEN SUM(m.first_sup)
	ELSE SUM(m.second_sup) END), 2)
	END "PERCENT_VARIANCE",
	dbo.cir_get_drop_point_name(m.comp_code,unit_code,station_code,1) "DROP POINT NAME",
    dbo.cir_get_drop_point_name(m.comp_code,unit_code,station_code,2) "DROP POINT NAME OTHER LANG",branch_code "BRANCH NAME"
	FROM (    
	SELECT DISTINCT a.comp_code ,a.unit_code ,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang
	,c.city_code,c.dist_code,b.dist_name,b.dist_oname,c.station_code station_code,c.branch_code branch_code,
	 (    SELECT ISNULL(SUM(sup_copy), 0)
	from cir_supply
	WHERE comp_code  = @pcomp_code
	 AND (unit  = @punit_code or @punit_code is null or @punit_code='')
	 AND publ  = @ppublication
	 AND (edtn  = @pedtn OR    @pedtn  is null  OR    @pedtn = '')
	 and isnull(cir_supply.supply_flag,'N') =    'Y' 
	 AND cir_supply.agcd  = a.agcd
	 AND cir_supply.dpcd  = a.dpcd
	 AND cir_supply.edtn  in(
		 SELECT DISTINCT edtn FROM  cir_edtn_mast
		WHERE comp_code  = @pcomp_code
		 AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
		 AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = '')
		 and (cir_supply.supply_type_code = @pextra2 or @pextra2 is null  or @pextra2='')
		 ))	 first_sup,
	 (SELECT ISNULL(SUM(sup_copy), 0)
	FROM  cir_dbksup a
	WHERE comp_code  = @pcomp_code AND    (unit_code  = @punit_code or @punit_code is null or @punit_code='')
	 AND publ  = @ppublication
	 AND (edtn  = @pedtn OR @pedtn  is null OR    @pedtn = '')
	 AND supdate  = @vseconddate
	 AND a.agcd  = a.agcd AND    a.dpcd  = a.dpcd
	 AND a.edtn  in
		(SELECT DISTINCT edtn FROM  cir_edtn_mast
		WHERE comp_code  = @pcomp_code
		 AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
		 AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = '')
		 and  (a.sup_type_code = @pextra2 or @pextra2 is null or @pextra2 ='')
		 )) second_sup
	FROM  cir_dbksup a,cir_dist_mast b,cir_agmast c
	WHERE a.comp_code  = @pcomp_code AND a.comp_code  = c.comp_code AND b.comp_code  = c.comp_code
	AND (a.unit_code  = @punit_code or @punit_code is null or @punit_code='')
	 AND a.unit_code  = c.unit
	AND (a.supdate  = @vfirstdate OR    a.supdate  = @vseconddate)
	AND a.agcd  = c.agcd AND a.dpcd  = c.dpcd
	AND (c.dist_code  = @pdist OR    @pdist  is null  OR    @pdist = '')
	AND c.dist_code  = b.dist_code
	and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
	and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
	and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')
	group by a.comp_code ,a.unit_code ,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname,c.station_code ,c.branch_code 
	) m
	WHERE    ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
	GROUP BY m.comp_code,m.unit_code,m.agcd,m.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.dist_code,m.dist_name,m.dist_oname,m.station_code,m.branch_code
	ORDER BY m.comp_code,m.dist_code,m.ag_name
end
else
begin
SELECT
	m.comp_code "COMP CODE",m.agcd "AGENCY CODE",m.dpcd "AGENCY SUB CODE",
	m.ag_name "AGENCY NAME",m.ag_name_oth_lang "AGENCY OTHER LANG",DBO.cir_get_city(m.comp_code, m.city_code) "CITY NAME",
	m.dist_code "DISTRICT CODE",m.dist_name "DISTRICT NAME",m.dist_oname "DISTRICT NAME OTHER LANG",
	SUM(m.first_sup) "FIRST SUPPLY",SUM(m.second_sup) "SECOND SUPPLY",

	CASE sign(ISNULL(SUM(m.second_sup), 0) - ISNULL(SUM(m.first_sup), 0)) WHEN - 1 THEN 0
	ELSE (ISNULL(SUM(m.second_sup), 0) - ISNULL(SUM(m.first_sup), 0))
	END "INCREASE SUPPLY",

	CASE sign(ISNULL(SUM(m.second_sup), 0) - ISNULL(SUM(m.first_sup), 0)) WHEN 1 THEN 0
	ELSE (ISNULL(SUM(m.second_sup), 0) - ISNULL(SUM(m.first_sup), 0))
	END "DECREASE SUPPLY",

	CASE ISNULL(SUM(m.first_sup), 0) WHEN 0 THEN 100
	ELSE ROUND(((ISNULL(SUM(m.second_sup), 0) - ISNULL(SUM(m.first_sup), 0)) * 100) / CONVERT(FLOAT,
	CASE sign(SUM(m.second_sup) - SUM(m.first_sup)) WHEN - 1 THEN SUM(m.first_sup)
	ELSE SUM(m.second_sup) END), 2)
	END "PERCENT_VARIANCE",
	dbo.cir_get_drop_point_name(m.comp_code,m.unit_code,m.station_code,1) "DROP POINT NAME",
    dbo.cir_get_drop_point_name(m.comp_code,unit_code,station_code,2) "DROP POINT NAME OTHER LANG",branch_code "BRANCH NAME"
	FROM (    SELECT DISTINCT
	 a.comp_code comp_code,a.unit_code unit_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname,c.station_code station_code,c.branch_code branch_code,
	 (    SELECT ISNULL(SUM(sup_copy), 0)
	FROM  cir_dbksup
	WHERE comp_code  = @pcomp_code
	 AND (unit_code  = @punit_code or @punit_code is null or @punit_code='')
	 AND publ  = @ppublication
	 AND (edtn  = @pedtn OR    @pedtn  is null  OR    @pedtn = '')
	 AND supdate  = @vfirstdate
	 AND cir_dbksup.agcd  = a.agcd
	 AND cir_dbksup.dpcd  = a.dpcd
	 AND cir_dbksup.edtn  in(
		 SELECT DISTINCT edtn FROM  cir_edtn_mast
		WHERE comp_code  = @pcomp_code
		 AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
		 AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = ''))) first_sup,
	 (SELECT ISNULL(SUM(sup_copy), 0)
	FROM  cir_dbksup
	WHERE comp_code  = @pcomp_code AND    (unit_code  = @punit_code or @punit_code is null or @punit_code='')
	 AND publ  = @ppublication
	 AND (edtn  = @pedtn OR @pedtn  is null OR    @pedtn = '')
	 AND supdate  = @vseconddate
	 AND cir_dbksup.agcd  = a.agcd AND    cir_dbksup.dpcd  = a.dpcd
	 AND cir_dbksup.edtn  in
		(SELECT DISTINCT edtn FROM  cir_edtn_mast
		WHERE comp_code  = @pcomp_code
		 AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
		 AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = ''))) second_sup	
	FROM  cir_dbksup a,cir_dist_mast b,cir_agmast c
	WHERE a.comp_code  = @pcomp_code AND a.comp_code  = c.comp_code AND b.comp_code  = c.comp_code
	AND (a.unit_code  = @punit_code or @punit_code is null or @punit_code='')
	 AND a.unit_code  = c.unit
	AND (a.supdate  = @vfirstdate OR    a.supdate  = @vseconddate)
	AND a.agcd  = c.agcd AND a.dpcd  = c.dpcd
	AND (c.dist_code  = @pdist OR    @pdist  is null  OR    @pdist = '')
	AND c.dist_code  = b.dist_code
	and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
	and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
	and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')
	group by a.comp_code ,a.unit_code ,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname,c.station_code ,c.branch_code ) m
	WHERE    ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
	GROUP BY m.comp_code,m.unit_code,m.agcd,m.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.dist_code,m.dist_name,m.dist_oname,m.station_code,m.branch_code
	ORDER BY m.comp_code,m.dist_code,m.ag_name

end


-- district wise
if upper(@pextra1)='U' begin 
	SELECT r.comp_code "COMP CODE", r.dist_code "DISTRICT CODE", r.dist_name "DISTRICT NAME",
	r.dist_oname "DISTRICT NAME OTHER LANG",
	SUM(r.first_sup) "FIRST SUPPLY",
	SUM(r.second_sup) "SECOND SUPPLY",
	CASE sign(ISNULL(SUM(r.second_sup), 0) - ISNULL(SUM(r.first_sup), 0)) WHEN - 1 THEN 0
	ELSE (ISNULL(SUM(r.second_sup), 0) - ISNULL(SUM(r.first_sup), 0))
	END "INCREASE SUPPLY",

	CASE sign(ISNULL(SUM(r.second_sup), 0) - ISNULL(SUM(r.first_sup), 0)) WHEN 1 THEN 0
	ELSE (ISNULL(SUM(r.second_sup), 0) - ISNULL(SUM(r.first_sup), 0))
	END "DECREASE SUPPLY",

	CASE ISNULL(SUM(r.first_sup), 0) WHEN 0 THEN 100
	ELSE ROUND(((ISNULL(SUM(r.second_sup), 0) - ISNULL(SUM(r.first_sup), 0)) * 100) / CONVERT(FLOAT,
	CASE sign(SUM(r.second_sup) - SUM(r.first_sup)) WHEN - 1 THEN SUM(r.first_sup)
	ELSE SUM(r.second_sup)END), 2)
	END "PERCENT_VARIANCE"
	FROM (SELECT DISTINCT
	a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname,
	(    SELECT ISNULL(SUM(sup_copy), 0)
	from cir_supply
	WHERE comp_code  = @pcomp_code
	 AND (unit = @punit_code or @punit_code is null or @punit_code='')
	 AND publ  = @ppublication
	 AND (edtn  = @pedtn OR    @pedtn  is null  OR    @pedtn = '')
	 and isnull(cir_supply.supply_flag,'N') =    'Y' 
	 AND cir_supply.agcd  = a.agcd
	 AND cir_supply.dpcd  = a.dpcd
	 AND cir_supply.edtn  in(
		 SELECT DISTINCT edtn FROM  cir_edtn_mast
		WHERE comp_code  = @pcomp_code
		 AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
		 AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = '')
		 and (cir_supply.supply_type_code = @pextra2 or @pextra2 is null  or @pextra2='')
		 ))	 first_sup ,
	(SELECT ISNULL(SUM(sup_copy), 0)
	FROM  cir_dbksup a
	WHERE comp_code  = @pcomp_code AND    (unit_code  = @punit_code or @punit_code is null or @punit_code='')
	AND publ  = @ppublication
	AND (edtn  = @pedtn OR @pedtn  is null OR    @pedtn = '')
	AND supdate  = @vseconddate
	AND a.agcd  = a.agcd AND    a.dpcd  = a.dpcd
	AND a.edtn  in
	(SELECT DISTINCT edtn FROM  cir_edtn_mast
	WHERE comp_code  = @pcomp_code
	 AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
	 AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = '')
	 and  (a.sup_type_code = @pextra2 or @pextra2 is null or @pextra2 ='')
	 )) second_sup 
	FROM  cir_dbksup a,cir_dist_mast b,cir_agmast c
	WHERE a.comp_code  = @pcomp_code
	AND a.comp_code  = c.comp_code
	AND b.comp_code  = c.comp_code
	AND (a.unit_code  = @punit_code or @punit_code is null or @punit_code='')
	AND a.unit_code  = c.unit
	AND (a.supdate  = @vfirstdate OR    a.supdate  = @vseconddate)
	AND a.agcd  = c.agcd AND a.dpcd  = c.dpcd
	AND (c.dist_code  = @pdist OR    @pdist  is null OR    @pdist = '')
	AND c.dist_code  = b.dist_code 
	and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
	and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
	and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')
	group by a.comp_code ,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname) r
	WHERE ISNULL(r.second_sup, 0) - ISNULL(r.first_sup, 0)  <> 0
	GROUP BY r.comp_code,r.dist_code,r.dist_name,r.dist_oname
	ORDER BY r.comp_code,r.dist_code
end
else
begin

       SELECT
                 r.comp_code "COMP CODE", r.dist_code "DISTRICT CODE", r.dist_name "DISTRICT NAME",
                 r.dist_oname "DISTRICT NAME OTHER LANG",
                 SUM(r.first_sup) "FIRST SUPPLY",
                 SUM(r.second_sup) "SECOND SUPPLY",
                CASE sign(ISNULL(SUM(r.second_sup), 0) - ISNULL(SUM(r.first_sup), 0)) WHEN - 1 THEN 0
                ELSE (ISNULL(SUM(r.second_sup), 0) - ISNULL(SUM(r.first_sup), 0))
                END "INCREASE SUPPLY",
                 
                CASE sign(ISNULL(SUM(r.second_sup), 0) - ISNULL(SUM(r.first_sup), 0)) WHEN 1 THEN 0
                ELSE (ISNULL(SUM(r.second_sup), 0) - ISNULL(SUM(r.first_sup), 0))
                END "DECREASE SUPPLY",
                 
                CASE ISNULL(SUM(r.first_sup), 0) WHEN 0 THEN 100
                ELSE ROUND(((ISNULL(SUM(r.second_sup), 0) - ISNULL(SUM(r.first_sup), 0)) * 100) / CONVERT(FLOAT,
                CASE sign(SUM(r.second_sup) - SUM(r.first_sup)) WHEN - 1 THEN SUM(r.first_sup)
                ELSE SUM(r.second_sup)END), 2)
                END "PERCENT_VARIANCE"
        FROM (    SELECT DISTINCT
                     a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname,
                     (SELECT ISNULL(SUM(sup_copy), 0)
                    FROM  cir_dbksup
                    WHERE comp_code  = @pcomp_code
                     AND (unit_code  = @punit_code or @punit_code is null or @punit_code='')
                     AND publ  = @ppublication
                     AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
                     AND supdate  = @vfirstdate
                     AND cir_dbksup.agcd  = a.agcd
                     AND cir_dbksup.dpcd  = a.dpcd
                     AND cir_dbksup.edtn  in
                        (SELECT DISTINCT edtn FROM  cir_edtn_mast
                        WHERE comp_code  = @pcomp_code
                         AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
                         AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = ''))) first_sup,
                     (SELECT ISNULL(SUM(sup_copy), 0) FROM  cir_dbksup
                    WHERE comp_code  = @pcomp_code
                     AND (unit_code  = @punit_code or @punit_code is null or @punit_code='')
                     AND publ  = @ppublication
                     AND (edtn  = @pedtn OR    @pedtn  is null)
                     AND supdate  = @vseconddate
                     AND cir_dbksup.agcd  = a.agcd
                     AND cir_dbksup.dpcd  = a.dpcd
                     AND cir_dbksup.edtn  in (SELECT DISTINCT edtn FROM  cir_edtn_mast
                        WHERE comp_code  = @pcomp_code
                         AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
                         AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = ''))) second_sup
            FROM  cir_dbksup a,cir_dist_mast b,cir_agmast c
            WHERE a.comp_code  = @pcomp_code
             AND a.comp_code  = c.comp_code
             AND b.comp_code  = c.comp_code
             AND (a.unit_code  = @punit_code or @punit_code is null or @punit_code='')
             AND a.unit_code  = c.unit
             AND (a.supdate  = @vfirstdate OR    a.supdate  = @vseconddate)
             AND a.agcd  = c.agcd AND a.dpcd  = c.dpcd
             AND (c.dist_code  = @pdist OR    @pdist  is null OR    @pdist = '')
             AND c.dist_code  = b.dist_code
             and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
	and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
	and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')
             ) r
        WHERE ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
        GROUP BY r.comp_code,r.dist_code,r.dist_name,r.dist_oname
        ORDER BY r.comp_code,r.dist_code
end
if upper(@pextra1)='U' begin 
	SELECT
         q.comp_code "COMP CODE",
         SUM(q.first_sup) "FIRST SUPPLY",
         SUM(q.second_sup) "SECOND SUPPLY",
        CASE sign(ISNULL(SUM(q.second_sup), 0) - ISNULL(SUM(q.first_sup), 0)) WHEN - 1 THEN 0
        ELSE (ISNULL(SUM(q.second_sup), 0) - ISNULL(SUM(q.first_sup), 0))
        END "INCREASE SUPPLY",
         
        CASE sign(ISNULL(SUM(q.second_sup), 0) - ISNULL(SUM(q.first_sup), 0)) WHEN 1 THEN 0
        ELSE (ISNULL(SUM(q.second_sup), 0) - ISNULL(SUM(q.first_sup), 0))
        END "DECREASE SUPPLY",
         
        CASE ISNULL(SUM(q.first_sup), 0) WHEN 0 THEN 100
        ELSE ROUND(((ISNULL(SUM(q.second_sup), 0) - ISNULL(SUM(q.first_sup), 0)) * 100) / CASE sign(SUM(q.second_sup) - SUM(q.first_sup)) WHEN - 1 THEN SUM(q.first_sup) ELSE SUM(q.second_sup) END, 2)
        END "PERCENT_VARIANCE",
        
        (select isnull(sum(d.sup_copy),0) from cir_dbksup d,cir_agmast m  where d.comp_code = m.comp_code and d.comp_code = @pcomp_code and d.unit_code = m.unit 
        and (d.unit_code = @punit_code or @punit_code is null or @punit_code='') and
                    d.publ = @ppublication and (d.edtn = @pedtn or @pedtn is null or @pedtn ='') 
                    and d.agcd=m.agcd and d.dpcd=m.dpcd and d.supdate = @vfirstdate and
                    (m.dist_code = @pdist or @pdist is null or @pdist='') and d.edtn in
                    (select distinct edtn from cir_edtn_mast
                    where comp_code=d.comp_code and edtn = d.edtn and (main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn ='')) 
                    and (d.sup_type_code = @pextra2 or @pextra2 is null or @pextra2 ='')) first_total_supply        
			    FROM (SELECT DISTINCT a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname,
    (SELECT ISNULL(SUM(sup_copy), 0)
	from cir_supply
	WHERE comp_code  = @pcomp_code
	 AND (unit  = @punit_code or @punit_code is null or @punit_code ='')
	 AND publ  = @ppublication
	 AND (edtn  = @pedtn OR    @pedtn  is null  OR    @pedtn = '')
	 and isnull(cir_supply.supply_flag,'N') =    'Y' 
	 AND cir_supply.agcd  = a.agcd
	 AND cir_supply.dpcd  = a.dpcd
	 AND cir_supply.edtn  in(
		 SELECT DISTINCT edtn FROM  cir_edtn_mast
		WHERE comp_code  = @pcomp_code
		 AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
		 AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = '')
		 and (cir_supply.supply_type_code = @pextra2 or @pextra2 is null  or @pextra2='')
		 ))	 first_sup,
	 (SELECT ISNULL(SUM(sup_copy), 0)
	FROM  cir_dbksup a
	WHERE comp_code  = @pcomp_code AND    (unit_code  = @punit_code or @punit_code is null or @punit_code='')
	 AND publ  = @ppublication
	 AND (edtn  = @pedtn OR @pedtn  is null OR    @pedtn = '')
	 AND supdate  = @vseconddate
	 AND a.agcd  = a.agcd AND    a.dpcd  = a.dpcd
	 AND a.edtn  in
		(SELECT DISTINCT edtn FROM  cir_edtn_mast
		WHERE comp_code  = @pcomp_code
		 AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
		 AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = '')
		 and  (a.sup_type_code = @pextra2 or @pextra2 is null or @pextra2 ='')
	 )) second_sup
        FROM  cir_dbksup a,cir_dist_mast b,cir_agmast c
        WHERE a.comp_code  = @pcomp_code AND  a.comp_code  = c.comp_code AND b.comp_code  = c.comp_code
         AND (a.unit_code  = @punit_code or @punit_code is null or @punit_code='') AND    a.unit_code  = c.unit
         AND (a.supdate  = @vfirstdate OR    a.supdate  = @vseconddate)
         AND a.agcd  = c.agcd AND a.dpcd  = c.dpcd
         AND (c.dist_code  = @pdist OR    @pdist  is null OR    @pdist = '')
         AND c.dist_code  = b.dist_code
         and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
	and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
	and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')
         group by a.comp_code ,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname
         ) q
        WHERE ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
        GROUP BY  q.comp_code  ORDER BY q.comp_code
end
else
begin       
       

        SELECT
                 q.comp_code "COMP CODE",
                 SUM(q.first_sup) "FIRST SUPPLY",
                 SUM(q.second_sup) "SECOND SUPPLY",
                CASE sign(ISNULL(SUM(q.second_sup), 0) - ISNULL(SUM(q.first_sup), 0)) WHEN - 1 THEN 0
                ELSE (ISNULL(SUM(q.second_sup), 0) - ISNULL(SUM(q.first_sup), 0))
                END "INCREASE SUPPLY",
                 
                CASE sign(ISNULL(SUM(q.second_sup), 0) - ISNULL(SUM(q.first_sup), 0)) WHEN 1 THEN 0
                ELSE (ISNULL(SUM(q.second_sup), 0) - ISNULL(SUM(q.first_sup), 0))
                END "DECREASE SUPPLY",
                 
                CASE ISNULL(SUM(q.first_sup), 0) WHEN 0 THEN 100
                ELSE ROUND(((ISNULL(SUM(q.second_sup), 0) - ISNULL(SUM(q.first_sup), 0)) * 100) / CASE sign(SUM(q.second_sup) - SUM(q.first_sup)) WHEN - 1 THEN SUM(q.first_sup) ELSE SUM(q.second_sup) END, 2)
                END "PERCENT_VARIANCE",
                (select isnull(sum(d.sup_copy),0) from cir_dbksup d,cir_agmast m  where d.comp_code = m.comp_code and d.comp_code = @pcomp_code and d.unit_code = m.unit 
        and (d.unit_code = @punit_code or @punit_code is null or @punit_code='') and
                    d.publ = @ppublication and (d.edtn = @pedtn or @pedtn is null or @pedtn ='') 
                    and d.agcd=m.agcd and d.dpcd=m.dpcd and d.supdate = @vfirstdate and
                    (m.dist_code = @pdist or @pdist is null or @pdist='') and d.edtn in
                    (select distinct edtn from cir_edtn_mast
                    where comp_code=d.comp_code and edtn = d.edtn and (main_edtn=@pmainedtn or @pmainedtn is null or @pmainedtn ='')) 
                    and (d.sup_type_code = @pextra2 or @pextra2 is null or @pextra2 ='')) first_total_supply   
                    
        FROM (    SELECT DISTINCT a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname,
                     (SELECT ISNULL(SUM(sup_copy), 0)
                    FROM  cir_dbksup
                    WHERE comp_code  = @pcomp_code
                     AND (unit_code  = @punit_code or @punit_code is null or @punit_code='')
                     AND publ  = @ppublication
                     AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
                     AND supdate  = @vfirstdate
                     AND cir_dbksup.agcd  = a.agcd AND    cir_dbksup.dpcd  = a.dpcd
                     AND cir_dbksup.edtn  in
                        (SELECT DISTINCT edtn
                        FROM  cir_edtn_mast
                        WHERE comp_code  = @pcomp_code
                         AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
                         AND (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = ''))) first_sup,
                     (    SELECT ISNULL(SUM(sup_copy), 0)
                    FROM  cir_dbksup
                    WHERE comp_code  = @pcomp_code AND (unit_code  = @punit_code or @punit_code is null or @punit_code='')
                     AND publ  = @ppublication
                     AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
                     AND supdate  = @vseconddate
                     AND cir_dbksup.agcd  = a.agcd AND cir_dbksup.dpcd  = a.dpcd
                     AND cir_dbksup.edtn  in
                        (SELECT DISTINCT edtn
                        FROM  cir_edtn_mast
                        WHERE comp_code  = @pcomp_code
                         AND (edtn  = @pedtn OR    @pedtn  is null OR    @pedtn = '')
                         AND    (main_edtn  = @pmainedtn OR    @pmainedtn  is null OR    @pmainedtn = ''))) second_sup
            FROM  cir_dbksup a,cir_dist_mast b,cir_agmast c
            WHERE a.comp_code  = @pcomp_code AND    a.comp_code  = c.comp_code AND    b.comp_code  = c.comp_code
             AND (a.unit_code  = @punit_code or @punit_code is null or @punit_code='')
              AND    a.unit_code  = c.unit
             AND (a.supdate  = @vfirstdate OR    a.supdate  = @vseconddate)
             AND a.agcd  = c.agcd AND a.dpcd  = c.dpcd
             AND (c.dist_code  = @pdist OR    @pdist  is null OR    @pdist = '')
             AND c.dist_code  = b.dist_code
             and (a.AGENCY_TY_CODE=@pextra3 or @pextra3 is null or @pextra3='')
	and (c.AG_CLASS=@pextra4 or @pextra4 is null or @pextra4='')
	and (isnull(final_supply_flag,'N') = @pextra5  or @pextra5 is null or @pextra5='')
             ) q
        WHERE ISNULL(second_sup, 0) - ISNULL(first_sup, 0)  <> 0
        GROUP BY  q.comp_code         ORDER BY q.comp_code
end   

/////////////////////////////////////////////next     

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
	@pextra2                                  VARCHAR(200), -------agency class
	@pextra3            as varchar(200),-------supply type 
    @pextra4            as varchar(200)-------agency type
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
if(@pextra3 = '') begin
  set @pextra4 = null
end
if(@pextra4 = '') begin
  set @pextra4 = null
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
	where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code 
	and d.unit_code    = m.unit 
	and d.agcd         = m.agcd 
	 and d.dpcd         = m.dpcd 
	 and d.comp_code    = @pcomp_code 
	 and  d.unit_code    = @punit_code 
	 and d.publ         = e.publ and d.publ         = @ppubl 
	 and d.edtn=e.edtn 
	 and (d.edtn       = @pedtn or @pedtn is null) 
	 and (m.dist_code = @proute or @proute is null) 
	 and d.supdate between @pfrom_supdate and @ptill_supdate 
	 and (e.main_edtn=@pmainedtn or @pmainedtn is null) 
	 and (m.ag_class=@pextra2 or @pextra2 is null) 
	 and (d.sup_type_code=@pextra3 or @pextra3 is null or @pextra3 ='') 
	 and (m.ag_type=@pextra4 or @pextra4 is null)      
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
			 and (d.sup_type_code=@pextra3 or @pextra3 is null or @pextra3 ='') and 
                    (m.ag_type=@pextra4 or @pextra4 is null)       
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
			 and (d.sup_type_code=@pextra3 or @pextra3 is null or @pextra3 ='') and 
                    (m.ag_type=@pextra4 or @pextra4 is null)
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
			 and (d.sup_type_code=@pextra3 or @pextra3 is null or @pextra3 ='') and 
                    (m.ag_type=@pextra4 or @pextra4 is null)
		  group by d.comp_code
		  order by comp_code;
		


/////////////////////////////////////////////////next

create PROCEDURE [dbo].[cir_rep_supply_cir_executive_wise_supply]
	@pcomp_code			as VARCHAR(20) ,
	@punit_code         as VARCHAR(20) ,
	@ppubl              as VARCHAR(20) ,
	@pmainedtn          as VARCHAR(20) ,
	@pedtn              as VARCHAR(20) ,
	@proute             as VARCHAR(20) ,
	@pfrom_supdate      as DATETIME ,
	@ptill_supdate      as DATETIME ,
	@pdateformat        as VARCHAR(20) ,
	@pextra1            as varchar(200),--for login user id
    @pextra2            as varchar(200),--supply type
    @pextra3            as varchar(200),--agency type
    @pextra4            as varchar(200),--agency class
    @pextra5            as varchar(200), 
    @pextra6            as varchar(200)
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
	if(@pextra3 = '') begin
	  set @pextra3 = null
	end
	if(@pextra4 = '') begin
	  set @pextra4 = null
	end

	
select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
m.EXECUTIVE_CODE as "EXECUTIVE_CODE",
(Select executive_desc from cir_executive_mast 
	where COMP_CODE=d.COMP_CODE and EXECUTIVE_CODE=m.executive_code) as "EXECUTIVE_NAME",
	d.agcd AS "AGCD",d.dpcd AS "DPCD",m.ag_name AS "AG_NAME",m.ag_name_oth_lang AS "AG_NAME_OTH_LANG",sum(d.sup_copy) AS "SUP_COPY",
	dbo.cir_get_supply_seqno(d.comp_code,d.unit_code,@ppubl,@pedtn,d.agcd,d.dpcd) AS "SUPPLY_SEQNO",
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
		 and (d.sup_type_code=@pextra2 or @pextra2 is null or @pextra2 ='') and 
         (m.ag_type=@pextra3 or @pextra3 is null or @pextra3 ='') and 
         (m.ag_class=@pextra4 or @pextra4 is null or @pextra4 ='')
	  group by d.comp_code,d.unit_code,m.executive_code,
			   d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code
	  order by d.comp_code,d.unit_code,executive_code,supply_seqno ,d.agcd,d.dpcd
        
		select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
		
		m.EXECUTIVE_CODE as "EXECUTIVE_CODE",(Select executive_desc from cir_executive_mast 
		where COMP_CODE=d.COMP_CODE and EXECUTIVE_CODE=m.executive_code) as "EXECUTIVE_NAME",
		sum(d.sup_copy) AS "SUP_COPY"
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
			 and (m.ag_type=@pextra3 or @pextra3 is null or @pextra3 ='') and 
					(m.ag_class=@pextra4 or @pextra4 is null or @pextra4 ='')
		  group by d.comp_code,d.unit_code,m.executive_code
		  order by d.comp_code,d.unit_code,m.executive_code
		
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
				 and (m.ag_type=@pextra3 or @pextra3 is null or @pextra3 ='') and 
					(m.ag_class=@pextra4 or @pextra4 is null or @pextra4 ='')
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
				 and (m.ag_type=@pextra3 or @pextra3 is null or @pextra3 ='') and 
					(m.ag_class=@pextra4 or @pextra4 is null or @pextra4 ='')
			  group by d.comp_code
			  order by d.comp_code
		


//////////////////////////////////////next

                                          
ALTER PROCEDURE [dbo].[cir_rep_supply_temp]
@pcomp_code         as varchar(200),
@punit_code         as varchar(200),
@ppubl              as varchar(200),
@pmainedtn          as varchar(200),
@pedtn              as varchar(200),
@proute             as varchar(200),
@pfrom_supdate      as datetime,
@ptill_supdate      as datetime,
@pdateformat        as varchar(200),
@pextra1            as varchar(200),--for branch
@pextra2            as varchar(200),--for State
@pextra3            as varchar(200),--this is use to final and unfinal po
@pextra4            as varchar(200),--for zone,
@pextra5            as varchar(200),--for region
@pextra6            as varchar(200),--for district
@pextra7            as varchar(200),--for taluka
@pextra8            as varchar(200),--report type filter 1 for routewise,2 for branchwise,3 for zonewise,4 for regionwise,5 for district,6 for talukaiwse,7 for statewise,8 for executive
@pextra9            as varchar(200),--for publication type
@pextra10           as varchar(200),--for executive
@pextra11           as varchar(200),--for based on 1 for supply post and 2 for standing order
@pextra12           as varchar(200),
@pextra13           as varchar(200),
@pextra14           as varchar(200),
@pextra15           as varchar(200)

AS

declare @vfrom_supdate    varchar(20);
declare @vtill_supdate    varchar(20);
declare @rec_sup_type		as varchar(200) 
declare @rec_sup_type_sum	as varchar(200) 
declare @rec_sup_seq_no		as int

if @pextra11 ='2' begin
DECLARE cur_sup_type CURSOR READ_ONLY FOR
	select distinct ' sum(case supply_type_code when '+''''+sup_ty_code+''''+' then base_supply else 0 end ) "'+sup_ty_name+'",' vty,
	'sum(case supply_type_code when '+''''+sup_ty_code+''''+' then base_supply else 0 end ) +' vty_sum,sup_seq_no
	from cir_supply_type_mast s, cir_supply d,cir_edtn_mast e
    where s.comp_code=@pcomp_code and s.comp_code=d.comp_code and s.comp_code=e.comp_code and s.sup_ty_code =d.supply_type_code and
    (d.unit=isnull(@punit_code,d.unit) or @punit_code='') and d.publ=e.publ and 
    (d.publ=isnull(@ppubl,d.publ) or @ppubl='') and 
    d.edtn=e.edtn and (d.edtn=isnull(@pedtn,d.edtn) or @pedtn='') and 
    --d.supdate between @pfrom_supdate and @ptill_supdate and
    (e.main_edtn=isnull(@pmainedtn,e.main_edtn) or @pmainedtn='')
    order by sup_seq_no;
end
else
begin
DECLARE cur_sup_type CURSOR READ_ONLY FOR
	select distinct ' sum(case sup_type_code when '+''''+sup_ty_code+''''+' then sup_copy else 0 end ) "'+sup_ty_name+'",' vty,
	'sum(case sup_type_code when '+''''+sup_ty_code+''''+' then sup_copy else 0 end ) +' vty_sum,sup_seq_no
	from cir_supply_type_mast s, cir_dbksup d,cir_edtn_mast e
    where s.comp_code=@pcomp_code and s.comp_code=d.comp_code and s.comp_code=e.comp_code and s.sup_ty_code =d.sup_type_code and
    (d.unit_code=isnull(@punit_code,d.unit_code) or @punit_code='') and d.publ=e.publ and 
    (d.publ=isnull(@ppubl,d.publ) or @ppubl='') and 
    d.edtn=e.edtn and (d.edtn=isnull(@pedtn,d.edtn) or @pedtn='') and 
    d.supdate between @pfrom_supdate and @ptill_supdate and
    (e.main_edtn=isnull(@pmainedtn,e.main_edtn) or @pmainedtn='')
    order by sup_seq_no;
end
	declare @vvar		varchar(4000)
	declare @vvar_sum	varchar(4000)
	declare @vquery		varchar(8000)

	set @vvar=''
	set @vvar_sum=''
 
	set @vfrom_supdate=convert(varchar(20),@pfrom_supdate,101)
	set @vtill_supdate=convert(varchar(20),@ptill_supdate,101)

	print('@vfrom_supdate')print(@vfrom_supdate);
	print('@vtill_supdate')print(@vtill_supdate);

if @pextra11 ='2' begin
	open cur_sup_type  
		fetch next from cur_sup_type into @rec_sup_type ,@rec_sup_type_sum,@rec_sup_seq_no
		WHILE @@FETCH_STATUS = 0 Begin 	
      		set @vvar		=@vvar+@rec_sup_type          		
      		set  @vvar_sum	=@vvar_sum+@rec_sup_type_sum
      		print('1')
      	fetch next from cur_sup_type into @rec_sup_type ,@rec_sup_type_sum,@rec_sup_seq_no
		end
    close cur_sup_type
	DEALLOCATE cur_sup_type
end
else
begin
	open cur_sup_type  
		fetch next from cur_sup_type into @rec_sup_type ,@rec_sup_type_sum,@rec_sup_seq_no
		WHILE @@FETCH_STATUS = 0 Begin 	
      		set @vvar		=@vvar+@rec_sup_type          		
      		set  @vvar_sum	=@vvar_sum+@rec_sup_type_sum
      		print('1')
      	fetch next from cur_sup_type into @rec_sup_type ,@rec_sup_type_sum,@rec_sup_seq_no
		end
    close cur_sup_type
	DEALLOCATE cur_sup_type
end

	print('@vvar')print(@vvar)
	print('@vvar_sum')print(@vvar_sum)

if @vvar='' or @vvar is null begin
	set @vvar=null
end
else begin
	set @vvar    =substring(@vvar,1,len(@vvar)-1)
	set @vvar_sum=substring(@vvar_sum,1,len(@vvar_sum)-1)
end	
	print('@vvar2')print(@vvar)
	print('@vvar_sum2')print(@vvar_sum)
   
if @punit_code=null begin
	set @punit_code=''
end
if @ppubl=null begin
	set @ppubl=''
end
if @pmainedtn=null begin
	set @pmainedtn=''
end
if @pedtn=null begin
	set @pedtn=''
end
if @proute=null begin
	set @proute=''
end
if @pextra1=null begin
	set @pextra1=''
end
if @pextra2=null begin
	set @pextra2=''
end
if @pextra3=null begin
	set @pextra3=''
end
if @pextra4=null begin
	set @pextra4=''
end
if @pextra5=null begin
	set @pextra5=''
end
if @pextra6=null begin
	set @pextra6=''
end
if @pextra7=null begin
	set @pextra7=''
end

if @pextra9=null begin
	set @pextra9=''
end
if @pextra10=null begin
	set @pextra10=''
end

if @pextra11=null begin
	set @pextra11=''
end
if @pextra12=null begin
	set @pextra12=''
end
if @pextra13=null begin
	set @pextra13=''
end

if @pextra14=null begin
	set @pextra14=''
end
if @pextra15=null begin
	set @pextra15=''
end
if @pextra11 ='2' begin
	if @vvar='' or @vvar is null 
	begin
		set @vquery='select d.comp_code comp_code,d.unit unit_code,d.publ publ,dbo.cir_get_publ_name(d.comp_code,d.publ) publ_name,
		d.route_code route_code,dbo.cir_get_route_name(d.comp_code,d.unit,d.route_code) route_name,
		dbo.cir_get_name_cir_route(d.comp_code,d.unit,d.route_code,''2'',null,null,null) route_oname
		from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit and d.unit='''+@punit_code+''' 
		and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
		and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
		and m.agcd=d.agcd and m.dpcd=d.dpcd 
		--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
		--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
		and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
		and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
		and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
		and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
		and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
		and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
		and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
		and m.city_code=c.city_code 
		and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
		and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		group by d.comp_code,d.unit,d.publ,d.route_code
		order by d.comp_code,d.unit,d.publ,route_name';
	end
	else 
	begin
		if @pextra8='1' 
		begin----for route 
			set @vquery='select d.comp_code comp_code,d.unit unit_code,d.publ publ,dbo.cir_get_publ_name(d.comp_code,d.publ) publ_name,
			d.route_code route_code,dbo.cir_get_route_name(d.comp_code,d.unit,d.route_code) route_name,
			dbo.cir_get_name_cir_route(d.comp_code,d.unit,d.route_code,''2'',null,null,null) route_oname,
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and d.unit='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit,d.publ,d.route_code
			order by d.comp_code,d.unit,d.publ,route_name';
		end ------ route	
		else if @pextra8='2' 
		begin----for  branch
			set @vquery='select d.comp_code comp_code,d.unit unit_code,m.branch_code branch_code,
			dbo.cir_get_branch(d.comp_code,m.branch_code) branch_name, 
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and d.unit='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit,m.branch_code
			order by d.comp_code,d.unit,branch_name'
		end ---- branch		
		else if @pextra8='3' 
		begin----for  zone
			set @vquery=' select d.comp_code comp_code,d.unit unit_code,c.zone_code,
			dbo.cir_get_zone_name(d.comp_code,c.zone_code) zone_name, 
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and d.unit='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit,c.zone_code
			order by d.comp_code,d.unit,zone_name';
		end  ---- zone
		else if @pextra8='4' 
		begin----for  region   
			set @vquery='  select d.comp_code comp_code,d.unit unit_code,c.region_code,
			dbo.cir_get_region_name(d.comp_code,c.region_code) region_name,
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and d.unit='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit,c.region_code
			order by d.comp_code,d.unit,region_name';
		end ---- end  region
		else if @pextra8='5' 
		begin----for  district
			set @vquery='select d.comp_code comp_code,d.unit unit_code,m.dist_code dist_code,dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) district_name,
			dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,''2'',null,null,null) district_oname, '+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and d.unit='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit,m.state_code,m.dist_code
			order by d.comp_code,d.unit,m.state_code,district_name	'
		end  ---- district
		else if @pextra8='6' 
		begin----for  tehsil_taluka
			set @vquery='  select d.comp_code comp_code,d.unit unit_code,m.tehsil_taluka tehsil_taluka,
			dbo.cir_get_taluka(d.comp_code,m.tehsil_taluka) taluka_name,
			dbo.cir_get_name_cir_taluka(d.comp_code,m.tehsil_taluka,''2'',null,null,null) taluka_oname,
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and d.unit='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit,m.tehsil_taluka
			order by d.comp_code,d.unit,taluka_name';
		end  ----for  tehsil_taluka
		else if @pextra8='7' 
		begin----for  State
			set @vquery='select d.comp_code comp_code,d.unit unit_code,m.country_code country_code,
			m.state_code state_code,dbo.cir_get_state(d.comp_code,m.country_code,m.state_code) state_name
			,'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and d.unit='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit,m.country_code,m.state_code
			order by d.comp_code,d.unit,m.country_code,state_name';
		end  ----for  state
		else 
		begin--for executive
			set @vquery='select d.comp_code comp_code,d.unit unit_code,m.country_code country_code,
			m.executive_code executive_code,dbo.cir_get_executive(d.comp_code,m.executive_code) executive_name
			,'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and d.unit='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			--and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			--and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit,m.country_code,m.executive_code
			order by d.comp_code,d.unit,m.country_code,executive_name';
		end
	end
end
else
begin
	if @vvar='' or @vvar is null 
	begin
		set @vquery='select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,dbo.cir_get_publ_name(d.comp_code,d.publ) publ_name,
		d.route_code route_code,dbo.cir_get_route_name(d.comp_code,d.unit_code,d.route_code) route_name,
		dbo.cir_get_name_cir_route(d.comp_code,d.unit_code,d.route_code,''2'',null,null,null) route_oname
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
		and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
		and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
		and m.agcd=d.agcd and m.dpcd=d.dpcd 
		and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
		and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
		and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
		and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
		and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
		and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
		and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
		and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
		and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
		and m.city_code=c.city_code 
		and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
		and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		group by d.comp_code,d.unit_code,d.publ,d.route_code
		order by d.comp_code,d.unit_code,d.publ,route_name';
	end
	else 
	begin
		if @pextra8='1' 
		begin----for route 
			set @vquery='select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,dbo.cir_get_publ_name(d.comp_code,d.publ) publ_name,
			d.route_code route_code,dbo.cir_get_route_name(d.comp_code,d.unit_code,d.route_code) route_name,
			dbo.cir_get_name_cir_route(d.comp_code,d.unit_code,d.route_code,''2'',null,null,null) route_oname,
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit_code,d.publ,d.route_code
			order by d.comp_code,d.unit_code,d.publ,route_name';
		end ------ route	
		else if @pextra8='2' 
		begin----for  branch
			set @vquery='select d.comp_code comp_code,d.unit_code unit_code,m.branch_code branch_code,
			dbo.cir_get_branch(d.comp_code,m.branch_code) branch_name, 
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit_code,m.branch_code
			order by d.comp_code,d.unit_code,branch_name'
		end ---- branch		
		else if @pextra8='3' 
		begin----for  zone
			set @vquery=' select d.comp_code comp_code,d.unit_code unit_code,c.zone_code,
			dbo.cir_get_zone_name(d.comp_code,c.zone_code) zone_name, 
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit_code,c.zone_code
			order by d.comp_code,d.unit_code,zone_name';
		end  ---- zone
		else if @pextra8='4' 
		begin----for  region   
			set @vquery='  select d.comp_code comp_code,d.unit_code unit_code,c.region_code,
			dbo.cir_get_region_name(d.comp_code,c.region_code) region_name,
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit_code,c.region_code
			order by d.comp_code,d.unit_code,region_name';
		end ---- end  region
		else if @pextra8='5' 
		begin----for  district
			set @vquery='select d.comp_code comp_code,d.unit_code unit_code,m.dist_code dist_code,dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) district_name,
			dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,''2'',null,null,null) district_oname, '+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit_code,m.state_code,m.dist_code
			order by d.comp_code,d.unit_code,m.state_code,district_name	'
		end  ---- district
		else if @pextra8='6' 
		begin----for  tehsil_taluka
			set @vquery='  select d.comp_code comp_code,d.unit_code unit_code,m.tehsil_taluka tehsil_taluka,
			dbo.cir_get_taluka(d.comp_code,m.tehsil_taluka) taluka_name,
			dbo.cir_get_name_cir_taluka(d.comp_code,m.tehsil_taluka,''2'',null,null,null) taluka_oname,
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit_code,m.tehsil_taluka
			order by d.comp_code,d.unit_code,taluka_name';
		end  ----for  tehsil_taluka
		else if @pextra8='7' 
		begin----for  State
			set @vquery='select d.comp_code comp_code,d.unit_code unit_code,m.country_code country_code,
			m.state_code state_code,dbo.cir_get_state(d.comp_code,m.country_code,m.state_code) state_name
			,'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit_code,m.country_code,m.state_code
			order by d.comp_code,d.unit_code,m.country_code,state_name';
		end  ----for  state
		else 
		begin--for executive
			set @vquery='select d.comp_code comp_code,d.unit_code unit_code,m.country_code country_code,
			m.executive_code executive_code,dbo.cir_get_executive(d.comp_code,m.executive_code) executive_name
			,'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
			and d.publ=e.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
			and d.edtn=e.edtn and (d.edtn='''+@pedtn+''' or '''+@pedtn+'''='''') 
			and m.agcd=d.agcd and m.dpcd=d.dpcd 
			and d.supdate between '+''''+@vfrom_supdate+''''+' and '+''''+ @vtill_supdate+''''+'
			and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''='''')
			and (d.route_code='''+@proute+''' or '''+@proute+'''='''') 
			and (m.branch_code='''+@pextra1+''' or '''+@pextra1+'''='''')
			and (m.state_code='''+@pextra2+''' or '''+@pextra2+'''='''')
			and (c.zone_code='''+@pextra4+''' or '''+@pextra4+'''='''')
			and (c.region_code='''+@pextra5+''' or '''+@pextra5+'''='''')
			and (m.dist_code='''+@pextra6+''' or '''+@pextra6+'''='''')
			and (m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+'''='''')
			and m.city_code=c.city_code 
			and (e.main_edtn='''+@pmainedtn+''' or '''+@pmainedtn+'''='''')
			and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''+@pextra9+''' or '''+@pextra9+'''=''''))
			and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
			group by d.comp_code,d.unit_code,m.country_code,m.executive_code
			order by d.comp_code,d.unit_code,m.country_code,executive_name';
		end
	end
end
print(@vquery)
exec(@vquery)


///////////////////////////////////////////////////end///////////////////////////////////////////////////////////

