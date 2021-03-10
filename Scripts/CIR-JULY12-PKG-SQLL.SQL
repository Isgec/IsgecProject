///////////////14/07/2012 add by Deepika////////////////////////////////


create procedure [dbo].[cir_unblock_agency_p]
	@pcomp_code		as varchar(200),
	@punit_code     as varchar(200),
	@pagcd			as varchar(200),
	@pdpcd			as varchar(200),
	@puserid		as VARCHAR(20) ,
	@pstype         as varchar(200),
	@psupdt         as varchar(200),
	@pdateformat    as varchar(200),
	@pextra1        as varchar(200),
	@pextra2        as varchar(200),
	@pextra3        as varchar(200),
	@pextra4        as varchar(200),
	@pextra5        as varchar(200)
As
begin
	update CIR_AGMAST set SUSPEND='N',SUSPEND_TYPE=@pstype ,UPDATED_BY=@puserid	where 
	COMP_CODE=@pcomp_code and  unit=@punit_code 
	and AGCD=@pagcd	and DPCD=@pdpcd
	
	insert into CIR_SUSPEND_TRAN(COMP_CODE,UNIT,AGCD,DPCD,TRN_DATE,SUSP,SUSPTY,USERID,CREATION_DATE) values
	(@pcomp_code,@punit_code,@pagcd,@pdpcd,getdate(),'N',@pstype,@puserid,GETDATE())
	
	select ISSUE_DATE,PER_COPY_WEIGHT,SUP_TYPE_CODE from cir_dbksup where SUPDATE=@psupdt
end
	

//////////////////next



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
    s.edtn as "EDTN",e.edtn_name as "EDTN_NAME", 
    s.supply_flag as "SUPPLY_FLAG", s.supply_type_code as "SUPPLY_TYPE_CODE",t.sup_ty_name as "SUP_TY_NAME", 
    s.base_supply as "BASE_SUPPLY", s.supply_sun as "SUPPLY_SUN", s.supply_mon as "SUPPLY_MON", s.supply_tue as "SUPPLY_TUE", s.supply_wed as "SUPPLY_WED",
    s.supply_thu as "SUPPLY_THU", s.supply_fri as "SUPPLY_FRI", s.supply_sat as "SUPPLY_SAT", s.supply_spl1 as "SUPPLY_SPL1", s.supply_spl2 as "SUPPLY_SPL2",

   

case @pdateformat

 when 'mm/dd/yyyy' then convert(varchar(10),m.SUSPEND_DATE,101) 

when 'dd/mm/yyyy' then convert(varchar(10),m.SUSPEND_DATE,103) 
when 'yyyy/mm/dd' then convert(varchar(10),m.SUSPEND_DATE,111)  end as "SUSPEND_DATE" ,

dbo.get_suspend_type(m.suspend_type) as"SUSPEND_TYPE"




    from cir_supply s,cir_agmast m,cir_publ_mast p,cir_edtn_mast e,cir_supply_type_mast t
    where m.comp_code=s.comp_code and m.comp_code=p.comp_code and m.comp_code=e.comp_code and m.comp_code=t.comp_code and m.comp_code=isnull(@pcomp_code,m.comp_code) 
and    m.unit=s.unit 
and m.unit=isnull(@punit_code,m.unit) 
and m.agcd=s.agcd and  m.dpcd=s.dpcd and s.publ=p.publ 
and s.publ=isnull(@ppubl,s.publ) 
and s.edtn=e.edtn 
and s.supply_type_code=t.sup_ty_code 
and isnull(m.freeze_flag,'N') ='N' and isnull(m.suspend,'N')='Y'
    order by comp_code,unit,city_name,drop_point_name,ag_name,publ_name,main_edtn_name,edtn_name,sup_ty_name;    
End


//////////////////////////////////////end////////////////////////////////////////


////////////////////////////add by Deepika !8/07/2012////////////////////////



ALTER procedure [dbo].[cir_unapproved_unsold_receipt]
    @pcompcode       as  varchar(20),
    @punitcode       as  varchar(20),
    @pbrancode       as  varchar(20),
    @pagcd           as  varchar(20),
    @pdpcd           as  varchar(20),
    @puserid         as  varchar(20), 
    @pdateformat     as  varchar(20),
    @pextra1         as  varchar(200),
    @pextra2         as  varchar(200),--it is used for agency or distribution
    @pextra3         as  varchar(200),
    @pextra4         as  varchar(200),
    @pextra5         as  varchar(200),
    @pextra6         as  varchar(200),
    @pextra7         as  varchar(200),
    @pextra8         as  varchar(200),
    @pextra9         as  varchar(200),
    @pextra10        as  varchar(200)
as

begin
    if upper(@pextra2)='D' Begin
        select distinct d.comp_code as "COMP_CODE",d.unit_code as "UNIT_CODE",d.recptno as "RECPTNO",d.recptdt as "RECPTDT" ,h.doctype as "DOCTYPE",
        h.app_dt as "APP_DT",getdate() as "ENTRYDT",h.frdt as "FRDT",h.todt as "TODT",h.agcd as "AGCD",h.dpcd as "DPCD",
		h.publ as "PUBL",h.edtn as "EDTN",@puserid as "APP_USERID",@puserid as "VAR_USERID"
        from cir_unsold_hdr_dis h,cir_unsold_dtl_dis d
        where h.comp_code=d.comp_code and h.comp_code=@pcompcode and h.unit_code=d.unit_code and 
        h.unit_code=@punitcode and h.doctype='UCN' and h.doctype=d.doctype and h.recptno=d.recptno and h.recptdt=d.recptdt and
        h.agcd=d.agcd and h.sup_agcd=@pagcd and h.dpcd=d.dpcd and h.sup_dpcd=@pdpcd and 
        (isnull(var_short_recpt,0)+isnull(var_late_recpt,0)+isnull(var_bnr,0)+isnull(var_unsold,0)+isnull(var_damage,0))-
        (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)+isnull(apr_damage,0))>0 and
        (h.recptno like @pextra1+'%' or @pextra1 is null or @pextra1='')
        order by recptdt,recptno;
     End   
     Else Begin
        select distinct d.comp_code as "COMP_CODE",d.unit_code as "UNIT_CODE",d.recptno as "RECPTNO",d.recptdt as "RECPTDT" ,h.doctype as "DOCTYPE",
        h.app_dt as "APP_DT",getdate() as "ENTRYDT",h.frdt as "FRDT",h.todt as "TODT",h.agcd as "AGCD",h.dpcd as "DPCD",
		h.publ as "PUBL",h.edtn as "EDTN",@puserid as "APP_USERID",@puserid as "VAR_USERID"
        from cir_unsold_hdr h,cir_unsold_dtl d
        where h.comp_code=d.comp_code and h.comp_code=@pcompcode and h.unit_code=d.unit_code 
        and h.unit_code=@punitcode and h.doctype='UCN' 
        and h.doctype=d.doctype and h.recptno=d.recptno 
        and h.recptdt=d.recptdt 
        and h.agcd=d.agcd and (h.sup_agcd=isnull(@pagcd , h.SUP_AGCD) or @pagcd ='')
        and h.dpcd=d.dpcd and (h.sup_dpcd=isnull(@pdpcd , h.SUP_DPCD) or @pdpcd ='')
        and (isnull(var_short_recpt,0)+isnull(var_late_recpt,0)+isnull(var_bnr,0)+isnull(var_unsold,0)+isnull(var_damage,0))-
        (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)+isnull(apr_damage,0))>0 
        and (h.recptno like @pextra1+'%' or @pextra1 is null or @pextra1='')
        order by recptdt,recptno
     End
End



//////////////////////////////////next

ALTER procedure [dbo].[cir_unsold_detail_for_sanction](
    @pcompcode       as  varchar(20),
    @punitcode       as  varchar(20),
    @pagcd           as  varchar(20),
    @pdpcd           as  varchar(20),
    @precptno        as  varchar(200),
    @precptdt        as  varchar(200),    
    @puserid         as  varchar(200), 
    @pdateformate    as  varchar(200),
    @pextra1         as  varchar(200),
    @pextra2         as  varchar(200),--it is used for agency or distribution
    @pextra3         as  varchar(200),
    @pextra4         as  varchar(200),-- it is used for from unsold date
    @pextra5         as  varchar(200),-- it is used for TO unsold date
    @pextra6         as  varchar(200),
    @pextra7         as  varchar(200),
    @pextra8         as  varchar(200),
    @pextra9         as  varchar(200),
    @pextra10        as  varchar(200))
as
	declare @v_recptdt   datetime
	declare @vextra3   datetime
	declare @vextra4   datetime
begin
    set @v_recptdt =dbo.convert_user_date('/', @precptdt, @pdateformate)
    set @vextra3 =dbo.convert_user_date('/', @pextra3, @pdateformate)
    set @vextra4 =dbo.convert_user_date('/', @pextra4, @pdateformate)
    
	If upper(@pextra2)='D' Begin
        select distinct d.comp_code as "COMP_CODE",d.unit_code as "UNIT_CODE",--d.recptno as "RECPTNO",d.recptdt as "RECPTDT",--h.doctype as "DOCTYPE", 
        d.agcd as "AGCD",d.dpcd as "DPCD", d.branch_code as "BRANCH_CODE",d.publ as "PUBL", d.edtn as "EDTN",
        d.supdate as "SUPDATE", d.supply_copy as "SUPPLY_COPY", d.rate_supply as "RATE_SUPPLY", 
        sum(d.var_short_recpt) as "SHORT_RECPT", sum(d.var_late_recpt) as "LATE_RECPT",sum(d.damage) as "DAMAGE", 
        sum(d.VAR_BNR) as "BNR", sum(d.var_unsold) as "UNSOLD", sum(d.apr_short_recpt) as "APR_SHORT_RECPT", sum(d.apr_late_recpt) as "APR_LATE_RECPT", sum(d.apr_bnr) as "APR_BNR",
        sum(d.apr_unsold) as "APR_UNSOLD",sum(d.apr_damage) as "APR_DAMAGE",d.copy_rate as "COPY_RATE",d.comm_rate as "COMM_RATE", d.waste_alw as "WASTE_ALW", d.waste_rate as "WASTE_RATE", 
        d.return_per as "RETURN_PER", d.sup_agcd as "SUP_AGCD", d.sup_dpcd as "SUP_DPCD",
		sum(d.copy_amt) as "COPY_AMT",sum(d.comm_amt) as "COMM_AMT",sum(d.waste_amt) as "WASTE_AMT"
		,ISNULL(h.ref_recptno,h.recptno) as RECPTNO 
		,sum(isnull(d.var_short_recpt,0))+sum(isnull(d.var_late_recpt,0))+sum(isnull(d.var_bnr,0))+sum(isnull(d.var_unsold,0))+sum(isnull(d.var_damage,0)) as "NET_UNSOLD",
        sum(isnull(d.apr_short_recpt,0))+sum(isnull(d.apr_late_recpt,0))+sum(isnull(d.apr_bnr,0))+sum(isnull(d.apr_unsold,0))+sum(isnull(d.apr_damage,0)) as "NET_APPROVED"
		from CIR_UNSOLD_HDR_DIS h,CIR_UNSOLD_DTL_DIS d
        where h.comp_code=d.comp_code and h.comp_code=@pcompcode and h.unit_code=d.unit_code and 
        h.unit_code=@punitcode 
        and h.recptno=d.recptno 
        and (h.recptno=isnull(@precptno,h.recptno) or h.REF_RECPTNO=isnull(@precptno,h.REF_RECPTNO) or @precptno = '') 
        and h.recptdt=d.recptdt 
        and (h.recptdt=isnull(@v_recptdt,h.recptdt ) or h.ref_recptdt=isnull(@v_recptdt,h.ref_recptdt ) or @v_recptdt='') 
        and h.SUP_AGCD=d.SUP_AGCD
        and (h.SUP_AGCD=isnull(@pagcd,h.SUP_AGCD) or @pagcd ='')        
        and h.SUP_DPCD=d.SUP_DPCD 
        and (h.SUP_DPCD=isnull(@pdpcd,h.SUP_DPCD) or @pdpcd ='') 
        and ((d.RECPTDT between @vextra3 and @vextra4) or d.DOCTYPE='SCN')        
        group by d.comp_code,d.unit_code,d.agcd,d.dpcd,d.branch_code,d.publ,d.edtn,d.supdate,d.supply_copy,d.rate_supply
        ,d.copy_rate,d.comm_rate, d.waste_alw, d.waste_rate, 
         d.return_per, d.sup_agcd, d.sup_dpcd,ISNULL(h.ref_recptno,h.recptno)
        having (sum(isnull(d.var_short_recpt,0))+sum(isnull(d.var_late_recpt,0))+sum(isnull(d.var_bnr,0))+sum(isnull(d.var_unsold,0))+sum(isnull(d.var_damage,0)))-
        (sum(isnull(d.apr_short_recpt,0))+sum(isnull(d.apr_late_recpt,0))+sum(isnull(d.apr_bnr,0))+sum(isnull(d.apr_unsold,0))+sum(isnull(d.apr_damage,0)))>0 
        order by publ,edtn,supdate;
	End
    Else Begin
        select distinct d.comp_code as "COMP_CODE",d.unit_code as "UNIT_CODE",--d.recptno as "RECPTNO",d.recptdt as "RECPTDT",--h.doctype as "DOCTYPE", 
        d.agcd as "AGCD",d.dpcd as "DPCD", d.branch_code as "BRANCH_CODE",d.publ as "PUBL", d.edtn as "EDTN",
        d.supdate as "SUPDATE", d.supply_copy as "SUPPLY_COPY", d.rate_supply as "RATE_SUPPLY", 
        sum(d.var_short_recpt) as "SHORT_RECPT", sum(d.var_late_recpt) as "LATE_RECPT",sum(d.damage) as "DAMAGE", 
        sum(d.VAR_BNR) as "BNR", sum(d.var_unsold) as "UNSOLD", sum(d.apr_short_recpt) as "APR_SHORT_RECPT", sum(d.apr_late_recpt) as "APR_LATE_RECPT", sum(d.apr_bnr) as "APR_BNR",
        sum(d.apr_unsold) as "APR_UNSOLD",sum(d.apr_damage) as "APR_DAMAGE",d.copy_rate as "COPY_RATE",d.comm_rate as "COMM_RATE", d.waste_alw as "WASTE_ALW", d.waste_rate as "WASTE_RATE", 
        d.return_per as "RETURN_PER", d.sup_agcd as "SUP_AGCD", d.sup_dpcd as "SUP_DPCD",
		sum(d.copy_amt) as "COPY_AMT",sum(d.comm_amt) as "COMM_AMT",sum(d.waste_amt) as "WASTE_AMT"
		,ISNULL(h.ref_recptno,h.recptno) as RECPTNO 
		,sum(isnull(d.var_short_recpt,0))+sum(isnull(d.var_late_recpt,0))+sum(isnull(d.var_bnr,0))+sum(isnull(d.var_unsold,0))+sum(isnull(d.var_damage,0)) as "NET_UNSOLD",
        sum(isnull(d.apr_short_recpt,0))+sum(isnull(d.apr_late_recpt,0))+sum(isnull(d.apr_bnr,0))+sum(isnull(d.apr_unsold,0))+sum(isnull(d.apr_damage,0)) as "NET_APPROVED"
		from cir_unsold_hdr h,cir_unsold_dtl d
        where h.comp_code=d.comp_code and h.comp_code=@pcompcode and h.unit_code=d.unit_code and 
        h.unit_code=@punitcode 
        and h.recptno=d.recptno 
        and (h.recptno=isnull(@precptno,h.recptno) or h.REF_RECPTNO=isnull(@precptno,h.REF_RECPTNO) or @precptno = '') 
        and h.recptdt=d.recptdt 
        and (h.recptdt=isnull(@v_recptdt,h.recptdt ) or h.ref_recptdt=isnull(@v_recptdt,h.ref_recptdt ) or @v_recptdt='') 
        and h.SUP_AGCD=d.SUP_AGCD
        and (h.SUP_AGCD=isnull(@pagcd,h.SUP_AGCD) or @pagcd ='')        
        and h.SUP_DPCD=d.SUP_DPCD 
        and (h.SUP_DPCD=isnull(@pdpcd,h.SUP_DPCD) or @pdpcd ='') 
        and ((d.RECPTDT between @vextra3 and @vextra4) or d.DOCTYPE='SCN')        
        group by d.comp_code,d.unit_code,d.agcd,d.dpcd,d.branch_code,d.publ,d.edtn,d.supdate,d.supply_copy,d.rate_supply
        ,d.copy_rate,d.comm_rate, d.waste_alw, d.waste_rate, 
         d.return_per, d.sup_agcd, d.sup_dpcd,ISNULL(h.ref_recptno,h.recptno)
        having (sum(isnull(d.var_short_recpt,0))+sum(isnull(d.var_late_recpt,0))+sum(isnull(d.var_bnr,0))+sum(isnull(d.var_unsold,0))+sum(isnull(d.var_damage,0)))-
        (sum(isnull(d.apr_short_recpt,0))+sum(isnull(d.apr_late_recpt,0))+sum(isnull(d.apr_bnr,0))+sum(isnull(d.apr_unsold,0))+sum(isnull(d.apr_damage,0)))>0 
        order by publ,edtn,supdate;
	End
           

End

////////////////////////////////////////////////next



create procedure [dbo].[cir_unsold_detail_for_sanction_insert](
@pcompcode       as  varchar(20),
    @punitcode       as  varchar(20),
    @pagcd           as  varchar(20),
    @pdpcd           as  varchar(20),
    @precptno        as  varchar(200),
    @precptdt        as  varchar(200),    
    @puserid         as  varchar(200), 
    @pdateformate    as  varchar(200),
    @pextra1         as  varchar(200),
    @pextra2         as  varchar(200),--it is used for agency or distribution
    @pextra3         as  varchar(200),
    @pextra4         as  varchar(200),-- it is used for from unsold date
    @pextra5         as  varchar(200),-- it is used for TO unsold date
    @pextra6         as  varchar(200),
    @pextra7         as  varchar(200),
    @pextra8         as  varchar(200),
    @pextra9         as  varchar(200),
    @pextra10        as  varchar(200))
as
	declare @v_recptdt   datetime
	declare @vextra3   datetime
	declare @vextra4   datetime
begin
    set @v_recptdt =dbo.convert_user_date('/', @precptdt, @pdateformate)
    set @vextra3 =dbo.convert_user_date('/', @pextra4, @pdateformate)
    set @vextra4 =dbo.convert_user_date('/', @pextra5, @pdateformate)
    
	If upper(@pextra2)='D' Begin
        select distinct d.comp_code as "COMP_CODE",d.unit_code as "UNIT_CODE",--d.recptno as "RECPTNO",d.recptdt as "RECPTDT",--h.doctype as "DOCTYPE", 
        d.agcd as "AGCD",d.dpcd as "DPCD", d.branch_code as "BRANCH_CODE",d.publ as "PUBL", d.edtn as "EDTN",
        d.supdate as "SUPDATE", d.supply_copy as "SUPPLY_COPY", d.rate_supply as "RATE_SUPPLY", 
        sum(d.var_short_recpt) as "SHORT_RECPT", sum(d.var_late_recpt) as "LATE_RECPT",sum(d.damage) as "DAMAGE", 
        sum(d.VAR_BNR) as "BNR", sum(d.var_unsold) as "UNSOLD", sum(d.apr_short_recpt) as "APR_SHORT_RECPT", sum(d.apr_late_recpt) as "APR_LATE_RECPT", sum(d.apr_bnr) as "APR_BNR",
        sum(d.apr_unsold) as "APR_UNSOLD",sum(d.apr_damage) as "APR_DAMAGE",d.copy_rate as "COPY_RATE",d.comm_rate as "COMM_RATE", d.waste_alw as "WASTE_ALW", d.waste_rate as "WASTE_RATE", 
        d.return_per as "RETURN_PER", d.sup_agcd as "SUP_AGCD", d.sup_dpcd as "SUP_DPCD",
		sum(d.copy_amt) as "COPY_AMT",sum(d.comm_amt) as "COMM_AMT",sum(d.waste_amt) as "WASTE_AMT"
		,ISNULL(h.ref_recptno,h.recptno) as RECPTNO 
		,sum(isnull(d.var_short_recpt,0))+sum(isnull(d.var_late_recpt,0))+sum(isnull(d.var_bnr,0))+sum(isnull(d.var_unsold,0))+sum(isnull(d.var_damage,0)) as "NET_UNSOLD",
        sum(isnull(d.apr_short_recpt,0))+sum(isnull(d.apr_late_recpt,0))+sum(isnull(d.apr_bnr,0))+sum(isnull(d.apr_unsold,0))+sum(isnull(d.apr_damage,0)) as "NET_APPROVED"
		from CIR_UNSOLD_HDR_DIS h,CIR_UNSOLD_DTL_DIS d
        where h.comp_code=d.comp_code and h.comp_code=@pcompcode and h.unit_code=d.unit_code and 
        h.unit_code=@punitcode 
        and h.recptno=d.recptno 
        and (h.recptno=isnull(@precptno,h.recptno) or h.REF_RECPTNO=isnull(@precptno,h.REF_RECPTNO) or @precptno = '') 
        and h.recptdt=d.recptdt 
        and (h.recptdt=isnull(@v_recptdt,h.recptdt ) or h.ref_recptdt=isnull(@v_recptdt,h.ref_recptdt ) or @v_recptdt='') 
        and h.SUP_AGCD=d.SUP_AGCD
        and (h.SUP_AGCD=isnull(@pagcd,h.SUP_AGCD) or @pagcd ='')        
        and h.SUP_DPCD=d.SUP_DPCD 
        and (h.SUP_DPCD=isnull(@pdpcd,h.SUP_DPCD) or @pdpcd ='') 
        and ((d.RECPTDT between @vextra3 and @vextra4) or d.DOCTYPE='SCN')        
        group by d.comp_code,d.unit_code,d.agcd,d.dpcd,d.branch_code,d.publ,d.edtn,d.supdate,d.supply_copy,d.rate_supply
        ,d.copy_rate,d.comm_rate, d.waste_alw, d.waste_rate, 
         d.return_per, d.sup_agcd, d.sup_dpcd,ISNULL(h.ref_recptno,h.recptno)        
        order by publ,edtn,supdate;
	End
    Else Begin
        select distinct d.comp_code as "COMP_CODE",d.unit_code as "UNIT_CODE",--d.recptno as "RECPTNO",d.recptdt as "RECPTDT",--h.doctype as "DOCTYPE", 
        d.agcd as "AGCD",d.dpcd as "DPCD", d.branch_code as "BRANCH_CODE",d.publ as "PUBL", d.edtn as "EDTN",
        d.supdate as "SUPDATE", d.supply_copy as "SUPPLY_COPY", d.rate_supply as "RATE_SUPPLY", 
        sum(d.var_short_recpt) as "SHORT_RECPT", sum(d.var_late_recpt) as "LATE_RECPT",sum(d.damage) as "DAMAGE", 
        sum(d.VAR_BNR) as "BNR", sum(d.var_unsold) as "UNSOLD", sum(d.apr_short_recpt) as "APR_SHORT_RECPT", sum(d.apr_late_recpt) as "APR_LATE_RECPT", sum(d.apr_bnr) as "APR_BNR",
        sum(d.apr_unsold) as "APR_UNSOLD",sum(d.apr_damage) as "APR_DAMAGE",d.copy_rate as "COPY_RATE",d.comm_rate as "COMM_RATE", d.waste_alw as "WASTE_ALW", d.waste_rate as "WASTE_RATE", 
        d.return_per as "RETURN_PER", d.sup_agcd as "SUP_AGCD", d.sup_dpcd as "SUP_DPCD",
		sum(d.copy_amt) as "COPY_AMT",sum(d.comm_amt) as "COMM_AMT",sum(d.waste_amt) as "WASTE_AMT"
		,ISNULL(h.ref_recptno,h.recptno) as RECPTNO 
		,sum(isnull(d.var_short_recpt,0))+sum(isnull(d.var_late_recpt,0))+sum(isnull(d.var_bnr,0))+sum(isnull(d.var_unsold,0))+sum(isnull(d.var_damage,0)) as "NET_UNSOLD",
        sum(isnull(d.apr_short_recpt,0))+sum(isnull(d.apr_late_recpt,0))+sum(isnull(d.apr_bnr,0))+sum(isnull(d.apr_unsold,0))+sum(isnull(d.apr_damage,0)) as "NET_APPROVED"
		from cir_unsold_hdr h,cir_unsold_dtl d
        where h.comp_code=d.comp_code and h.comp_code=@pcompcode and h.unit_code=d.unit_code and 
        h.unit_code=@punitcode 
        and h.recptno=d.recptno 
        and (h.recptno=isnull(@precptno,h.recptno) or h.REF_RECPTNO=isnull(@precptno,h.REF_RECPTNO) or @precptno = '') 
        and h.recptdt=d.recptdt 
        and (h.recptdt=isnull(@v_recptdt,h.recptdt ) or h.ref_recptdt=isnull(@v_recptdt,h.ref_recptdt ) or @v_recptdt='') 
        and h.SUP_AGCD=d.SUP_AGCD
        and (h.SUP_AGCD=isnull(@pagcd,h.SUP_AGCD) or @pagcd ='')        
        and h.SUP_DPCD=d.SUP_DPCD 
        and (h.SUP_DPCD=isnull(@pdpcd,h.SUP_DPCD) or @pdpcd ='') 
        and ((d.RECPTDT between @vextra3 and @vextra4) or d.DOCTYPE='SCN')        
        group by d.comp_code,d.unit_code,d.agcd,d.dpcd,d.branch_code,d.publ,d.edtn,d.supdate,d.supply_copy,d.rate_supply
        ,d.copy_rate,d.comm_rate, d.waste_alw, d.waste_rate, 
         d.return_per, d.sup_agcd, d.sup_dpcd,ISNULL(h.ref_recptno,h.recptno)        
        order by publ,edtn,supdate;
	End
           

End

/////////////////////////////////////////next


create  procedure [dbo].[cir_unsold_sanction_delete_hdr](
               @pcompcode          varchar(50),
               @punitcode          varchar(50),
               @pdoctype           varchar(50),
               @pscn_no            varchar(50),
               @pscn_date          varchar(50),
               @pdateformate       varchar(50),
               @pextra1            varchar(50),
               @pextra2            varchar(50),
               @pextra4            varchar(50),
               @pextra5            varchar(50)
               ) as
  
  
 declare @v_scndate as datetime

begin

	set @v_scndate=dbo.convert_user_date('/', @pscn_date, @pdateformate)
	
	delete from CIR_UNSOLD_HDR where COMP_CODE=@pcompcode 
	and UNIT_CODE=@punitcode and DOCTYPE=@pdoctype
	and RECPTNO=@pscn_no and RECPTDT=@v_scndate

               
End 


///////////////////////////////////next

ALTER PROCEDURE  [dbo].[Cir_update_sanction_details]
  	@puserid as varchar(100),
	@pcompcode as varchar(10),
    @punitcode as varchar(10),
	@psup_agcode as varchar(20),
	@psup_agsubcode as varchar(20),
    @pbranch as varchar(100),
	@preceiptno as varchar(100),
	@preceiptdate as varchar(50),
	@psup_date as varchar(50),
    @pa_unsold as	varchar(20),
	@pa_short as	varchar(20),
	@pa_damage as	varchar(20),
	@pa_bnr as	varchar(20),
	@pa_laterec as	varchar(20),
	@pdoctype	as varchar(20),
	@pdateformat as varchar(20),
    @pextra1 as	varchar(100),
    @pextra2 as varchar(100) 

 AS  
	declare @v_recptdt   datetime
	declare @v_supdt   datetime 

begin
    set @v_recptdt =dbo.convert_user_date('/', @preceiptdate, @pdateformat)
	set @v_supdt =dbo.convert_user_date('/', @psup_date, @pdateformat)
	
	
	If upper(@pextra2)='D' 
	begin
		UPDATE cir_unsold_dtl_dis set apr_short_recpt=apr_short_recpt+@pa_short,apr_late_recpt=apr_late_recpt+@pa_laterec,
		apr_bnr=apr_bnr+@pa_bnr,apr_unsold=apr_unsold+@pa_unsold,apr_damage=apr_damage+@pa_damage,userid=@puserid  
		WHERE comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype
		and branch_code=@pbranch and recptno=@preceiptno and recptdt=@v_recptdt
		and supdate=@v_supdt and agcd=@psup_agcode and dpcd=@psup_agsubcode and publ=@pextra1 and EDTN=@pextra2
	    and (PROCESS_CRNO is not null and PROCESS_CRNO!='')
	    and (PROCESS_CRDT is not null and PROCESS_CRDT!='')	;
	end
	else
	begin
		if(1=2)
		begin
			UPDATE cir_unsold_dtl 
			set apr_short_recpt=apr_short_recpt+@pa_short,
			apr_late_recpt=apr_late_recpt+@pa_laterec,
			apr_bnr=apr_bnr+@pa_bnr,
			apr_unsold=apr_unsold+@pa_unsold,
			apr_damage=apr_damage+@pa_damage,
			userid=@puserid  
			WHERE comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype
			and branch_code=@pbranch and recptno=@preceiptno and recptdt=@v_recptdt
			and supdate=@v_supdt and agcd=@psup_agcode and dpcd=@psup_agsubcode and publ=@pextra1 and EDTN=@pextra2
			and (PROCESS_CRNO is not null and PROCESS_CRNO!='')
			and (PROCESS_CRDT is not null and PROCESS_CRDT!='')	;
		end
		
	end
end


////////////////////////////////////////////////////end//////////////////////////////////////////////////////////////////


****************Rikkee Garg  issue no - 8005  supply weight update  23/07/2012*****



alter procedure [dbo]. [checksupdate]
(
@pcomp_code  varchar(200),
@punit_code  varchar(200),
@ppub_code  varchar(200),
@pdateformate varchar(200),
@psup_date varchar(200),
@pextra1 varchar(20)

)

as begin
DECLARE @v_dt                              DATETIME 
	SET @v_dt  = DBO.CONVERT_USER_DATE('/', @psup_date,@pdateformate)
declare @count int
select @count = count(*)  from cir_dbksup where comp_code = @pcomp_code and unit_code = @punit_code and publ = @ppub_code and supdate = @v_dt
select @count as TOTAL
end
********************* end of issue 8005*****************************************

//*****************************add By Deepika 30/07/2012 sent by Amit sir**************************


ALTER function dbo.cir_bill_outstanding(
@comp_code		as varchar(100),
@unit_code		as varchar(100),
@branch_code	as varchar(100),
@agcd			as varchar(50),
@agdpcd			as varchar(50),
@dateformate	as varchar(50),
@puserid		as  varchar(20),
@extra1			as varchar(50),
@extra2			as varchar(50))returns numeric(25,2)
as
	begin
	
		declare @amount   numeric(25,2)
	
		 select @amount=  sum(x.amt)
		 from (select SUM(amount) as amt from CIR_OUTMAST where COMP_CODE=@comp_code 
		 and UNIT_CODE=@unit_code AND (BRANCH_CODE=@branch_code OR @branch_code='' OR @branch_code IS NULL)
		 and AGCD=@agcd and DPCD=@agdpcd  and BILLNO is not NULL and  RECPTNO is  null
		 union all
		 select SUM(amount) as amt from CIR_OUTMAST where COMP_CODE=@comp_code and  AGCD=@agcd 
		 and UNIT_CODE=@unit_code AND (BRANCH_CODE=@branch_code OR @branch_code='' OR @branch_code IS NULL) 
		 and DPCD=@agdpcd  and RECPTNO is not NULL  and BILLNO is not NULL)x 
		 
		 return @amount
	end


************************* next

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
    
    select h.comp_code COMP_CODE,h.unit_code UNIT_CODE,h.agcd AGCD,h.dpcd DPCD,m.ag_name AG_NAME,h.doctype DOCTYPE,h.recptno RECPTNO,h.recptdt RECPTDT,
    abs(h.amount) AS AMOUNT,h.chno CHNO,h.chdt CHDT,h.chbank CHBANK,h.reason REASON,h.prov_rec_no PROV_REC_NO,
    h.prov_rec_dt PROV_REC_DT,h.received_from RECEIVED_FROM,h.achd AHCD,h.ccdp DEBIT_HEAD,
	(select acc_name from fa_acc_mast where comp_code=h.comp_code and cdp=h.ccdp) as CREDIT_HEAD_NAME,
	h.rcdp credit_head,(select acc_name from fa_acc_mast where comp_code=h.comp_code and cdp=h.rcdp) as DEBIT_HEAD_NAME
    from cir_rcphdr h,cir_agmast m
    where h.comp_code=m.comp_code and h.comp_code=@pcompcode and h.unit_code=m.unit and h.unit_code=@punitcode 
    and h.agcd=m.agcd and h.dpcd=m.dpcd and h.chno is not null
    and h.doctype=@pdoctype 
    and ( (h.recptno=@precptno and h.recptdt=@precptdt ) or (h.CHNO=upper(@precptno) and (@precptdt is null or @precptdt ='') )  )
    
End

****************************next


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

	select @rec_agency_comp_code=m.Comp_Code ,@rec_agency_agcd=m.agcd ,@rec_agency_dpcd=m.dpcd 
	,@rec_agency_agency_name=m.ag_name ,@rec_agency_city_code=m.City_Code
	,@rec_agency_city_name=c.city_name,@rec_agency_credit_days=m.credit_days
	,@rec_agency_branch_name=m.branch_code,@rec_agency_ageing_type=m.ageing_type
	from cir_agmast m,cir_city_mast c
	where m.comp_code=c.comp_code and m.comp_code=@pcomp_code 
	and m.unit=@punit_code and m.city_code=c.city_code 			
	and (m.Dist_Code=@pdist_code or @pdist_code is null or @pdist_code ='') 
	and (m.tehsil_taluka=@ptaluka_code or @ptaluka_code is null or @ptaluka_code ='') 
	and (m.agcd=@pag_main_code or @pag_main_code is null or @pag_main_code ='') 
	and (m.dpcd=@pag_sub_code or @pag_sub_code is null or @pag_sub_code ='')


set @pdebitupto_date =@pasondt
set @pcreditupto_date =@pasondt


declare @day as int


	declare cur_agency cursor for
			select distinct publ from cir_supply where comp_code=@pcomp_code and agcd=@pag_main_code and dpcd=@pag_sub_code
			order by publ
			
		
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

open cur_agency
		fetch NEXT FROM cur_agency INTO @fetch_pub
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN print('dddddd') print(@fetch_pub)
			
			select distinct @fetch_protype=pro_type,@fetch_pubname=PUBL_NAME,@fetch_pubtype=
			(Select pubname from pub_type_mast where Comp_Code=@pcomp_code and pub_type_mast.pubtypecode=CIR_PUBL_MAST.PRO_TYPE)
			from CIR_PUBL_MAST where COMP_CODE=@pcomp_code and publ=@fetch_pub
			
			select @ptill_days1=SLAB_TILL1,@ptill_days2=SLAB_TILL2,@ptill_days3=SLAB_TILL3,@ptill_days4=SLAB_TILL4
			,@ptill_days5=SLAB_TILL5,@ptill_days6=SLAB_TILL6,@rec_agency_ageing_type=AGEING_TYPE from CIR_AGEING_SLAB_MAST 
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
--SELECT 'cursor has ' + CAST(@@CURSOR_ROWS AS VARCHAR) + ' rows'
deallocate cur_agency

select comp_code,unit_code,agcd,dpcd,ag_name PRO_TYPE,PUBNAME,city_name PUBL_NAME,pending_amt,cur_amt,slab_1,slab_2,slab_3,slab_4,slab_5,
slab_6,rect_pending from #cir_temp_ageing  --
 order by ag_name;
 
drop table #cir_temp_ageing

/*************************************************next


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
      
      delete from cir_rcphdr_temp where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
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
                    
			delete from cir_rcpdet_temp
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
		
		 delete from cir_outmast_temp
             where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and 
                    recptno=@precptno and recptdt=@v_dt
		
		
		insert into cir_rcpt_document(comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt)
		select comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt from cir_rcpt_document_temp
		where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
     	recptno=@precptno and recptdt=@v_dt
		
		delete from cir_rcpt_document_temp
		where comp_code=@pcompcode and unit_code=@punitcode and doctype=@pdoctype and 
     	recptno=@precptno and recptdt=@v_dt
		
		
		insert into cir_rcp_unadj(comp_code,unit_code,agcd,dpcd,doctyp,recptno,recptdt,publ,amount,created_by,created_date,updated_by,updated_date)
		select comp_code,unit_code,agcd,dpcd,doctyp,recptno,recptdt,publ,amount,created_by,created_date,updated_by,updated_date from cir_rcp_unadj_temp
		where comp_code=@pcompcode and unit_code=@punitcode and doctyp=@pdoctype and recptno=@precptno
		
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
from CIR_RCPHDR where COMP_CODE=@pcompcode and RECPTNO=@precptno and RECPTDT=@v_dt
print('***')
print(@precptno)print(@v_dt)
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

**********************************************end*********************************************************


*********************anuj issue no 8207***************************

ALTER PROCEDURE [dbo].[FA_VOUCHERS_VIEW_FA_SEGMENT_TYPE_MAST_p]
	@pcompcode                                VARCHAR(4000) ,
	@pdateformat                              VARCHAR(4000) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) --,
	--@p_fin                                    t_fin_type OUTPUT 
AS 
	BEGIN
		SET NOCOUNT ON
		
		
		--OPEN p_fin for 
		SELECT
				 COMP_CODE,
				 SEG_CODE,
				 SEG_DESC,
				 FREEZE_FLAG,
				 CREATED_BY,
				 CREATION_DATE,
				 LAST_UPDATED_BY,
				 LAST_UPDATED_DATE,
				 SEG_ALIAS
		FROM  fa_segment_mast 
		WHERE	 comp_code  = @pcompcode AND
		       ((Upper(SEG_ALIAS) LIKE upper (cast(@pextra1 as varchar) + '%')) OR (@pextra1 IS NULL) OR (@pextra1=''))
		ORDER BY SEG_CODE 
		

		SET NOCOUNT OFF

	END
*****************************************************************************************************************



**************************************************issue no.8178****************************************************************



ALTER PROCEDURE [dbo].[CIR_SUPPLY_POSTing_FOR_NEXT_DAY]
	@pcomp_code			VARCHAR(20) ,
	@punit_code			VARCHAR(20) ,--- for print center
	@ppubl_code         VARCHAR(20) ,---- pub not mandatory	
	@pextra1			VARCHAR(20) ,
	@pextra2			VARCHAR(20), 
	@pextra3     		varchar(20),
	@pextra4			VARCHAR(20), 
	@pextra5     		varchar(20)
AS 

begin

select Pub_cent_Code,pub_cent_name from Pub_Cent_Mast where Comp_Code=@pcomp_code 
and (Pub_cent_Code =@punit_code or @punit_code is null or @punit_code='')
and ISNULL(PRINT_CENT,'N')='Y'

select * from CIR_PUBL_MAST where COMP_CODE=@pcomp_code 
and (publ=@ppubl_code or @ppubl_code is null or @ppubl_code='')







end

*****************************************************end*****************************************************************



///////////////////////////add by deepika 09/08/2101  sent by amit sir//////////////////////////////////////



create function [dbo].[cir_chk_rate_commission](
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
				select @countcommcat=count(*) from CIR_COMM_CATG_MAST
				select @countc=count(*) from CIR_COMM_MAST where COMP_CODE=@comp_code 
				and (UNIT_CODE=@unit_code or @unit_code='' or @unit_code is null)
				and PUBL=@pub_code and EDTN= @edtn_code
				if(@countc=@countcommcat) 
				begin
					set @msg='ok'
				End
				else
				begin
					set @msg='First Enter Commission Of All category For This Edition!'
				End
				
			End
		else
			begin
				set @msg='First Open Rate For This Edition!!'
			End
			
			
	return @msg;
End


/////////////////////////next

create PROCEDURE  [dbo].[cir_new_publ_update_in_supply]

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



//////////////////////////////////////////end////////////////////////////////////////////////////////////////

*****************Rikkee Garg netsale report issue no. 8105 ***********************

USE [adbooking]
GO
/****** Object:  StoredProcedure [dbo].[cir_rep_unsold_supply_cir_monthly_net_paid_sale]    Script Date: 08/10/2012 15:17:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


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
	@pbreak_on          as varchar(20),--Region R/State S/District D/Branch B / ZONE Z/ routewise O/ center C /PUBL  P / EDITION E
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
		
	@pextra5            as varchar(50),
	@pextra6            as varchar(50),
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
		
		/*and ( cast(substring(cast(dbo.cir_get_commission(b.comp_code,b.unit_code,b.publ,b.edtn,
		b.COMM_FIX_AUTO_SPL,b.COMM_CODE,b.SUPDATE,@pdateformat,b.SUP_COPY,'','' )
		 as varchar),2,len(cast(dbo.cir_get_commission(b.comp_code,b.unit_code,b.publ,b.edtn,
		 b.COMM_FIX_AUTO_SPL,b.COMM_CODE,b.SUPDATE,@pdateformat,b.SUP_COPY,'','' ) as varchar)) 
		 
		 
		 ) as numeric)*/
		 and ( round(isnull(substring(cast(dbo.cir_get_commission(b.comp_code,b.unit_code,b.publ,b.edtn,
		b.COMM_FIX_AUTO_SPL,b.COMM_CODE,b.SUPDATE,@pdateformat,b.SUP_COPY,'','' )
		 as varchar),2,len(cast(dbo.cir_get_commission(b.comp_code,b.unit_code,b.publ,b.edtn,
		 b.COMM_FIX_AUTO_SPL,b.COMM_CODE,b.SUPDATE,@pdateformat,b.SUP_COPY,'','' ) as varchar))  ) ,0),0) !=''
		 and round(isnull(substring(cast(dbo.cir_get_commission(b.comp_code,b.unit_code,b.publ,b.edtn,
		b.COMM_FIX_AUTO_SPL,b.COMM_CODE,b.SUPDATE,@pdateformat,b.SUP_COPY,'','' )
		 as varchar),2,len(cast(dbo.cir_get_commission(b.comp_code,b.unit_code,b.publ,b.edtn,
		 b.COMM_FIX_AUTO_SPL,b.COMM_CODE,b.SUPDATE,@pdateformat,b.SUP_COPY,'','' ) as varchar))  ) ,0),0) 	
		  > cast(@pcommper as numeric) or cast(@pcommper as numeric) is null or cast(@pcommper as numeric) = 0)
		  
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
		and ( round(isnull(substring(cast(dbo.cir_get_commission(b.comp_code,b.unit_code,b.publ,b.edtn,b.COMM_FIX_AUTO_SPL,
		b.COMM_CODE,b.SUPDATE,@pdateformat,b.SUP_COPY,'','' ) as varchar),2,		
		len(cast(dbo.cir_get_commission(b.comp_code,b.unit_code,b.publ,b.edtn,b.COMM_FIX_AUTO_SPL,b.COMM_CODE,
		b.SUPDATE,@pdateformat,b.SUP_COPY,'','' ) as varchar)) ) ,0),0) !=''
		and round(isnull(substring(cast(dbo.cir_get_commission(b.comp_code,b.unit_code,b.publ,b.edtn,b.COMM_FIX_AUTO_SPL,
		b.COMM_CODE,b.SUPDATE,@pdateformat,b.SUP_COPY,'','' ) as varchar),2,		
		len(cast(dbo.cir_get_commission(b.comp_code,b.unit_code,b.publ,b.edtn,b.COMM_FIX_AUTO_SPL,b.COMM_CODE,
		b.SUPDATE,@pdateformat,b.SUP_COPY,'','' ) as varchar)) ) ,0),0) 
		< cast(@pcommper as numeric) or cast(@pcommper as numeric) is null or cast(@pcommper as numeric) = 1)
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
		a.country_code,a.tehsil_taluka,d.route_code ,d.comm_code) u
		where (u.supply_copy+u.return_copy)>0
		group by u.comp_code,u.unit_code,u.branch_code,u.publ,u.publ_name,u.main_edtn,u.edtn,u.edtn_name,u.copy_rate,
		u.agcd,u.dpcd,u.agname,u.agname_oth_lang,u.state_code,u.dist_code ,u.city_code,u.tehsil_taluka,u.route_code,u.country_code,u.comm_cat; 
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
		a.country_code,a.tehsil_taluka,d.route_code ,d.comm_code) u
		where (u.supply_copy+u.return_copy)>0
		group by u.comp_code,u.unit_code,u.branch_code,u.publ,u.publ_name,u.main_edtn,u.edtn,u.edtn_name,u.copy_rate,
		u.agcd,u.dpcd,u.agname,u.agname_oth_lang,u.state_code,u.dist_code ,u.city_code,u.tehsil_taluka,u.route_code,u.country_code,u.comm_cat; 
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
				,u.comm_cat as COM_CAT,count (distinct u.supdate) as no_of_days
				from (
				select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate copy_rate,
				b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
				a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka, b.route_code, 
				sum(isnull(b.sup_copy,0)) supply_copy,0 return_copy, supdate supdate
				,b.comm_code comm_cat
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
				a.country_code,a.tehsil_taluka,b.route_code,b.comm_code,b.supdate
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
				a.country_code,a.tehsil_taluka,d.route_code ,d.comm_code) u
				where (u.supply_copy+u.return_copy)>0
				group by u.comp_code,u.unit_code,u.branch_code,u.publ,u.publ_name,u.main_edtn,u.edtn,u.edtn_name,u.copy_rate,
				u.agcd,u.dpcd,u.agname,u.agname_oth_lang,u.state_code,u.dist_code ,u.city_code,u.tehsil_taluka,u.route_code,u.country_code,u.comm_cat,u.supdate; 
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
			,u.comm_cat as COM_CAT,count (distinct u.supdate) as no_of_days
			from (
			select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate copy_rate,
			b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
			a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka, b.route_code, 
			sum(isnull(b.sup_copy,0)) supply_copy,0 return_copy, supdate supdate
			,b.comm_code comm_cat
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
			a.country_code,a.tehsil_taluka,b.route_code,b.comm_code,b.supdate
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
			a.country_code,a.tehsil_taluka,d.route_code ,d.comm_code) u
			where (u.supply_copy+u.return_copy)>0
			group by u.comp_code,u.unit_code,u.branch_code,u.publ,u.publ_name,u.main_edtn,u.edtn,u.edtn_name,u.copy_rate,
			u.agcd,u.dpcd,u.agname,u.agname_oth_lang,u.state_code,u.dist_code ,u.city_code,u.tehsil_taluka,u.route_code,u.country_code,u.comm_cat,u.supdate; 
		end
            
        delete from #cir_temp_bill_collection    
        OPEN c2 
        fetch NEXT FROM c2 INTO @v1_comp_code,@v1_unit_code, @v1_branch_code, @v1_branch_name,@v1_publ, @v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,@v1_edtn,@v1_edtn_name,@v1_copy_rate, @v1_agcd, @v1_dpcd,@v1_agname,@v1_agname_oth_lang,@v1_state_code,@v1_state_name,@v1_dist_code,@v1_dist_name,@v1_city_code,@v1_city_name, @v1_tehsil_taluka,@v1_taluka_name,@v1_route_code,@v1_route_name,@v1_supply_copy,@v1_return_copy,@v1_net_sale_copy, @v1_supdate,@v1_unit_name,@v1_COM_CAT,@v1_no_of_days
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
				,unit_name,COM_CAT,supdate)
            values(@v1_comp_code,@v1_unit_code,@v1_branch_name,@v1_publ_name,@v1_main_edtn_name,@v1_edtn_name,@v1_agname,@v1_agname_oth_lang,@v1_city_name,
				@v1_taluka_name,@v1_dist_name,@v1_state_name,@v_reg_code,@v1_supply_copy,@v1_return_copy,@v1_copy_rate,@v1_no_of_days,@v_zone_code,@v_reg_code,@v_publ_code,@v1_route_name
				,@v1_unit_name,@v1_COM_CAT,@v1_supdate)
            
		    fetch NEXT FROM c2 INTO @v1_comp_code,@v1_unit_code, @v1_branch_code, @v1_branch_name,@v1_publ, @v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,@v1_edtn,@v1_edtn_name,@v1_copy_rate, @v1_agcd, @v1_dpcd,@v1_agname,@v1_agname_oth_lang,@v1_state_code,@v1_state_name,@v1_dist_code,@v1_dist_name,@v1_city_code,@v1_city_name, @v1_tehsil_taluka,@v1_taluka_name,@v1_route_code,@v1_route_name,@v1_supply_copy,@v1_return_copy,@v1_net_sale_copy, @v1_supdate,@v1_unit_name,@v1_COM_CAT,@v1_no_of_days
		
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
				,u.comm_cat as COM_CAT,count (distinct u.supdate) as no_of_days
				from (
				select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate copy_rate,
				b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
				a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka, b.route_code, 
				sum(isnull(b.sup_copy,0)) supply_copy,0 return_copy, supdate supdate
				,b.comm_code comm_cat
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
				a.country_code,a.tehsil_taluka,b.route_code,b.comm_code,b.supdate
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
				a.country_code,a.tehsil_taluka,d.route_code ,d.comm_code) u
				where (u.supply_copy+u.return_copy)>0
				group by u.comp_code,u.unit_code,u.branch_code,u.publ,u.publ_name,u.main_edtn,u.edtn,u.edtn_name,u.copy_rate,
				u.agcd,u.dpcd,u.agname,u.agname_oth_lang,u.state_code,u.dist_code ,u.city_code,u.tehsil_taluka,u.route_code,u.country_code,u.comm_cat,u.supdate; 
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
			,u.comm_cat as COM_CAT,count (distinct u.supdate) as no_of_days
			from (
			select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate copy_rate,
			b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
			a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka, b.route_code, 
			sum(isnull(b.sup_copy,0)) supply_copy,0 return_copy, supdate supdate
			,b.comm_code comm_cat
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
			a.country_code,a.tehsil_taluka,b.route_code,b.comm_code,b.supdate
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
			a.country_code,a.tehsil_taluka,d.route_code ,d.comm_code) u
			where (u.supply_copy+u.return_copy)>0
			group by u.comp_code,u.unit_code,u.branch_code,u.publ,u.publ_name,u.main_edtn,u.edtn,u.edtn_name,u.copy_rate,
			u.agcd,u.dpcd,u.agname,u.agname_oth_lang,u.state_code,u.dist_code ,u.city_code,u.tehsil_taluka,u.route_code,u.country_code,u.comm_cat,u.supdate; 
		end
            
        delete from #cir_temp_bill_collection    
        OPEN c2 
        fetch NEXT FROM c2 INTO @v1_comp_code,@v1_unit_code, @v1_branch_code, @v1_branch_name,@v1_publ, @v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,@v1_edtn,@v1_edtn_name,@v1_copy_rate, @v1_agcd, @v1_dpcd,@v1_agname,@v1_agname_oth_lang,@v1_state_code,@v1_state_name,@v1_dist_code,@v1_dist_name,@v1_city_code,@v1_city_name, @v1_tehsil_taluka,@v1_taluka_name,@v1_route_code,@v1_route_name,@v1_supply_copy,@v1_return_copy,@v1_net_sale_copy, @v1_supdate,@v1_unit_name,@v1_COM_CAT,@v1_no_of_days
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
				,unit_name,COM_CAT,supdate)
            values(@v1_comp_code,@v1_unit_code,@v1_branch_name,@v1_publ_name,@v1_main_edtn_name,@v1_edtn_name,@v1_agname,@v1_agname_oth_lang,@v1_city_name,
				@v1_taluka_name,@v1_dist_name,@v1_state_name,@v_reg_code,@v1_supply_copy,@v1_return_copy,@v1_copy_rate,@v1_no_of_days,@v_zone_code,@v_reg_code,@v_publ_code,@v1_route_name
				,@v1_unit_name,@v1_COM_CAT,@v1_supdate)
            
		    fetch NEXT FROM c2 INTO @v1_comp_code,@v1_unit_code, @v1_branch_code, @v1_branch_name,@v1_publ, @v1_publ_name,@v1_main_edtn,@v1_main_edtn_name,@v1_edtn,@v1_edtn_name,@v1_copy_rate, @v1_agcd, @v1_dpcd,@v1_agname,@v1_agname_oth_lang,@v1_state_code,@v1_state_name,@v1_dist_code,@v1_dist_name,@v1_city_code,@v1_city_name, @v1_tehsil_taluka,@v1_taluka_name,@v1_route_code,@v1_route_name,@v1_supply_copy,@v1_return_copy,@v1_net_sale_copy, @v1_supdate,@v1_unit_name,@v1_COM_CAT,@v1_no_of_days
		
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
        End
        
        select getdate() as CUR_DATE
        select getdate() as CUR_DATE
   drop table #CIR_TEMP_BILL_COLLECTION
   
   drop table #CIR_DBKSUP_temp

 


*********************** end of issue 8105*****************************************


//======================add by deepika 29-aug-2013=========






create procedure cir_get_unsold_receiptno
(
@pcomp_code         varchar(50),
@punit_code         varchar(50),
@pbranch_code       varchar(50),
@pdoctype           varchar(50),
@pagcd              varchar(50),
@pdpcd              varchar(50),
@precptdt           datetime,
@pextra1             varchar(10),
@pextra2             varchar(10),
@pextra3            varchar(10),
@pextra4            varchar(10),
@pextra5            varchar(10))
as
begin

select distinct RECPTNO,RECPTDT from cir_unsold_dtl
 where  comp_code    = @pcomp_code
    and UNIT_CODE    = @punit_code
	and DOCTYPE      = @pdoctype
	and agcd         = @pagcd
	and dpcd         = @pdpcd
	and RECPTDT      = @precptdt
  

end




create procedure cir_unapproved_approved_unsol (@pcomp_code varchar(50),
                                                @punit_code varchar(50),
												@pbranch_code varchar(50),
									            @pdoctype   varchar(50),
									            @pagcd      varchar(50),
									            @pdpcd      varchar(50),
									            @precptdt   datetime,
												@precptno   varchar(50),
												@pextra1    varchar(10),
												@pextra2    varchar(10),
												@pextra3    varchar(10),
												@pextra4    varchar(10),
												@pextra5    varchar(10)) as
Begin
  Declare @v_cond_no    int
  Declare @v_bill_exist int
  Declare @v_message    varchar(1000)
  Declare @v_frdt       datetime
  Declare @v_todt       datetime
  Begin
    
	 if @precptno is null or @precptno = '' or len(@precptno)<2
	    Begin
		   set @v_message = 'Please Select the proper Receipt No.'
		   set @v_cond_no = 1
		End
     Else
        Begin
		   set @v_message = null
		End
    select @v_frdt = min(frdt), @v_todt = max(todt) from cir_unsold_hdr
	  where comp_code = @pcomp_code
	    and unit_code = @punit_code
		and agcd      = @pagcd
		and dpcd      = @pdpcd
		and recptdt   = @precptdt 
		and recptno   = @precptno
   
    select @v_bill_exist = count(*) from cir_bill
	  where comp_code = @pcomp_code
	    and unit_code = @punit_code
		and agcd      = @pagcd
		and dpcd      = @pdpcd
		and bill_frdt = @v_frdt
		and bill_todt = @v_todt

    if isnull(@v_bill_exist,0)>0
	    Begin
		   set @v_message = 'Invoice Already Generated Against This Receipt. So That You Can not Un-Approved This Receipt.'
		   set @v_cond_no = isnull(@v_cond_no,0)+1
		End

    If isnull(@v_cond_no,0)=0 
	   Begin
	     update cir_unsold_hdr set APP_DT=null,APP_USERID=null 
		   where comp_code = @pcomp_code
	         and unit_code = @punit_code
		     and agcd      = @pagcd
		     and dpcd      = @pdpcd
		     and recptdt   = @precptdt 
		     and recptno   = @precptno

         update cir_unsold_dtl set apr_short_recpt = 0, apr_late_recpt = 0, apr_bnr = 0, apr_unsold = 0, APP_DT = null, APP_USERID = null 
		   where comp_code = @pcomp_code
	         and unit_code = @punit_code
		     and agcd      = @pagcd
		     and dpcd      = @pdpcd
		     and recptdt   = @precptdt 
		     and recptno   = @precptno

         set @v_message = 'Unsold Un-Approved Successfully.'
		 
	   End
	   select @v_message as MASSEGE
  End


End


//////////////////////////////////////end////////////////////////////