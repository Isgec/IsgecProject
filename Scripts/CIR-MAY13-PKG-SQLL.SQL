//====================add by Deepika sent by Gaurav sir 16-may-2013==================

ALTER FUNCTION [dbo].[CRM_chk_issue_date]
(
	@publ as varchar(200),
	@edtn as varchar(200),
	@frequency as varchar(200),
	@date as datetime,
	@extra1 as varchar(200),
	@extra2 as varchar(200),
	@extra3 as varchar(200),
	@extra4 as varchar(200)
)
RETURNS varchar(50) AS
begin

declare @q1 as varchar(3)
declare @q2 as varchar(3)
declare @q3 as varchar(3)
declare @q4 as varchar(3)



DECLARE @v_c1_reg_name AS VARCHAR(200)
DECLARE @v_c1_reg_name1 AS VARCHAR(200)
declare @count as int
declare @freq as int

	if @edtn is null or @edtn ='' 
	begin
		select @count=count(distinct first_issue)  from cir_edition_issue_date 
		where comp_code=@extra1 and pub_code=@publ
		and edition_code in (SELECT distinct EDTN from CIR_EDTN_MAST where COMP_CODE=@extra1 and ISNULL(freeze_flag,'Y') ='N' )
		
		select distinct @freq= frequency_code from cir_edition_issue_date 
		where comp_code=@extra1 and pub_code=@publ
		and edition_code in (SELECT distinct EDTN from CIR_EDTN_MAST where COMP_CODE=@extra1 and ISNULL(freeze_flag,'Y') ='N' )
		
		select @v_c1_reg_name=First_Issue,@v_c1_reg_name1=Second_Issue from cir_edition_issue_date 
		where comp_code=@extra1 and pub_code=@publ
		and edition_code in (SELECT distinct EDTN from CIR_EDTN_MAST where COMP_CODE=@extra1 and ISNULL(freeze_flag,'Y') ='N' )

	end
	else
	begin
		select @count=count(distinct frequency_code)  from cir_edition_issue_date 
		where comp_code=@extra1 and comp_code=@extra1 and pub_code=@publ and edition_code=@edtn
		and edition_code in (SELECT distinct EDTN from CIR_EDTN_MAST where COMP_CODE=@extra1 and ISNULL(freeze_flag,'Y') ='N' )
		
		select @freq= frequency_code from cir_edition_issue_date 
		where comp_code=@extra1 and pub_code=@publ  and edition_code=@edtn
		and edition_code in (SELECT distinct EDTN from CIR_EDTN_MAST where COMP_CODE=@extra1 and ISNULL(freeze_flag,'Y') ='N' )
		
		select @v_c1_reg_name=First_Issue,@v_c1_reg_name1=Second_Issue from cir_edition_issue_date 
		where comp_code=@extra1 and pub_code=@publ and edition_code=@edtn
		and edition_code in (SELECT distinct EDTN from CIR_EDTN_MAST where COMP_CODE=@extra1 and ISNULL(freeze_flag,'Y') ='N' )
	end


set @q1=upper(CONVERT(VARCHAR(3),(dateadd (mm,0, @date))))
set @q2=upper(CONVERT(VARCHAR(3),(dateadd (mm,3, @date))))
set @q3=upper(CONVERT(VARCHAR(3),(dateadd (mm,6, @date))))
set @q4=upper(CONVERT(VARCHAR(3),(dateadd (mm,9, @date))))



	if @count >1 
	begin
	
	--	set @v_c1_reg_name = 'Post Individual'
	/**new added**/
	    if @freq = '1' 	begin
			   if @v_c1_reg_name IN ('SUN','MON','TUE','WED','THU','FRI','SAT') BEGIN
				set @v_c1_reg_name = 'Y'
				end
				else begin
				set @v_c1_reg_name = 'Post Individual'
				end
		end
		else begin
		set @v_c1_reg_name = 'Post Individual'
		end
	
	/**new added**/
	end
	else
	begin
		if @freq = '1' 
		begin
			set @v_c1_reg_name = 'Y'
		end
		else if(@freq = '7') 
		begin
			if(@v_c1_reg_name=upper(CONVERT(VARCHAR(3),(datename (dw, @date)))))
			begin
				set @v_c1_reg_name = 'Y'
			end
			else
			begin
				set @v_c1_reg_name = 'N'
			end
		end
		else if @freq = '15' 
		begin
			if(@v_c1_reg_name= DateName(d, @date) or @v_c1_reg_name1= DateName(d, @date))
			begin	   
				set @v_c1_reg_name = 'Y'
			end
			else
			begin
				set @v_c1_reg_name = 'N'
			end
		end
		else if @freq = '30' 
		begin
			if(@v_c1_reg_name= DateName(d, @date))
			begin
				set @v_c1_reg_name = 'Y'
			end
			else
			begin
				set @v_c1_reg_name = 'N'
			end
		end
		else if @freq = '90' 
		begin
			if(@v_c1_reg_name= DateName(d, @date) and ((@v_c1_reg_name1= @q1) or @v_c1_reg_name1=@q2 or @v_c1_reg_name1=@q3 or @v_c1_reg_name1=@q4))
			begin 
				set @v_c1_reg_name = 'Y'
			end
			else
			begin
				set @v_c1_reg_name = 'N'
			end
		end
		else if @freq = '365' 
		begin
			if(@v_c1_reg_name= DateName(d, @date) and (@v_c1_reg_name1=upper(CONVERT(VARCHAR(3),(datename (mm, @date))))))
			begin
				set @v_c1_reg_name = 'Y'
			end
			else
			begin
				set @v_c1_reg_name = 'N'
			end
		end
	end

	return @v_c1_reg_name
	end


--select  dbo.CRM_chk_issue_date('P32', '091', '', '04/05/2012', '', '', '', '') as CITY_NAME
--select * from cir_edition_issue_date






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
    and isnull(d.supply_flag,'Y')!='N'
    and isnull(e.freeze_flag,'N')='N'
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
    and isnull(e.freeze_flag,'N')='N'
    order by sup_seq_no;
end
	declare @vvar		varchar(4000)
	declare @vvar_sum	varchar(4000)
	declare @vquery		varchar(8000)
	declare @vquery1		varchar(8000)

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
		set @vquery='select d.comp_code comp_code,d.unit unit_code,
		dbo.cir_get_unit_name(d.comp_code,d.unit) unit_name,
		d.route_code route_code,dbo.cir_get_route_name(d.comp_code,d.unit,d.route_code) route_name,
		dbo.cir_get_name_cir_route(d.comp_code,d.unit,d.route_code,''2'',null,null,null) route_oname
		from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''' )
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
		and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
		group by d.comp_code,d.unit,d.route_code
		order by d.comp_code,d.unit,route_name';
		
		set @vquery1='select d.comp_code comp_code,d.unit unit_code,
		dbo.cir_get_unit_name(d.comp_code,d.unit) unit_name,		
		from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''' )
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
		and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')		
		and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
		group by d.comp_code,d.unit
		order by d.comp_code,d.unit';
	end
	else 
	begin
		if @pextra8='1' 
		begin----for route 
			set @vquery='select d.comp_code comp_code,d.unit unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit) unit_name,			
			d.route_code route_code,dbo.cir_get_route_name(d.comp_code,d.unit,d.route_code) route_name,
			dbo.cir_get_name_cir_route(d.comp_code,d.unit,d.route_code,''2'',null,null,null) route_oname,
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''' )
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit,d.publ,d.route_code
			order by d.comp_code,d.unit,d.publ,route_name';
			
			set @vquery1='select d.comp_code comp_code,d.unit unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit) unit_name,			
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''' )
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit
			order by d.comp_code,d.unit';
		end ------ route	
		else if @pextra8='2' 
		begin----for  branch
			set @vquery='select d.comp_code comp_code,d.unit unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit) unit_name,
			m.branch_code branch_code,
			dbo.cir_get_branch(d.comp_code,m.branch_code) branch_name, 
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''' )
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit,m.branch_code
			order by d.comp_code,d.unit,branch_name'
			
			set @vquery1='select d.comp_code comp_code,d.unit unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit) unit_name,			
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''' )
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit
			order by d.comp_code,d.unit'
		end ---- branch		
		else if @pextra8='3' 
		begin----for  zone
			set @vquery=' select d.comp_code comp_code,d.unit unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit) unit_name,
			c.zone_code,
			dbo.cir_get_zone_name(d.comp_code,c.zone_code) zone_name, 
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''' )
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit,c.zone_code
			order by d.comp_code,d.unit,zone_name';
			
			set @vquery1=' select d.comp_code comp_code,d.unit unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit) unit_name,			
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''' )
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit
			order by d.comp_code,d.unit';
		end  ---- zone
		else if @pextra8='4' 
		begin----for  region   
			set @vquery='  select d.comp_code comp_code,d.unit unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit) unit_name,
			c.region_code,
			dbo.cir_get_region_name(d.comp_code,c.region_code) region_name,
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit,c.region_code
			order by d.comp_code,d.unit,region_name';
			
			set @vquery1='  select d.comp_code comp_code,d.unit unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit) unit_name,			
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit
			order by d.comp_code,d.unit';
		end ---- end  region
		else if @pextra8='5' 
		begin----for  district
			set @vquery='select d.comp_code comp_code,d.unit unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit) unit_name,
			m.dist_code dist_code,dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) district_name,
			dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,''2'',null,null,null) district_oname, '+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit,m.state_code,m.dist_code
			order by d.comp_code,d.unit,m.state_code,district_name	'
			
			set @vquery1='select d.comp_code comp_code,d.unit unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit) unit_name,			
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit
			order by d.comp_code,d.unit'
		end  ---- district
		else if @pextra8='6' 
		begin----for  tehsil_taluka
			set @vquery='  select d.comp_code comp_code,d.unit unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit) unit_name,
			m.tehsil_taluka tehsil_taluka,
			dbo.cir_get_taluka(d.comp_code,m.tehsil_taluka) taluka_name,
			dbo.cir_get_name_cir_taluka(d.comp_code,m.tehsil_taluka,''2'',null,null,null) taluka_oname,
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit,m.tehsil_taluka
			order by d.comp_code,d.unit,taluka_name';
			
			set @vquery1='  select d.comp_code comp_code,d.unit unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit) unit_name,						
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit
			order by d.comp_code,d.unit';
		end  ----for  tehsil_taluka
		else if @pextra8='7' 
		begin----for  State
			set @vquery='select d.comp_code comp_code,d.unit unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit) unit_name,
			m.country_code country_code,
			m.state_code state_code,dbo.cir_get_state(d.comp_code,m.country_code,m.state_code) state_name
			,'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit,m.country_code,m.state_code
			order by d.comp_code,d.unit,m.country_code,state_name';
			
			set @vquery1='select d.comp_code comp_code,d.unit unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit) unit_name,			
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit
			order by d.comp_code,d.unit';
		end  ----for  state
		else 
		begin--for executive
			set @vquery='select d.comp_code comp_code,d.unit unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit) unit_name,
			m.country_code country_code,
			m.executive_code executive_code,dbo.cir_get_executive(d.comp_code,m.executive_code) executive_name
			,'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit,m.country_code,m.executive_code
			order by d.comp_code,d.unit,m.country_code,executive_name';
			
			set @vquery1='select d.comp_code comp_code,d.unit unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit) unit_name,			
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit
			order by d.comp_code,d.unit';
		end
	end
end
else
begin
	if @vvar='' or @vvar is null 
	begin
		set @vquery='select d.comp_code comp_code,d.unit_code unit_code,
		dbo.cir_get_unit_name(d.comp_code,d.unit_code) unit_name,
		d.route_code route_code,dbo.cir_get_route_name(d.comp_code,d.unit_code,d.route_code) route_name,
		dbo.cir_get_name_cir_route(d.comp_code,d.unit_code,d.route_code,''2'',null,null,null) route_oname
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+''' ='''')
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
		and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		and isnull(e.freeze_flag,''N'')=''N''
		group by d.comp_code,d.unit_code,d.route_code
		order by d.comp_code,d.unit_code,route_name';
		
		set @vquery1='select d.comp_code comp_code,d.unit_code unit_code,
		dbo.cir_get_unit_name(d.comp_code,d.unit_code) unit_name,		
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+''' ='''')
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
		and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		and isnull(e.freeze_flag,''N'')=''N''
		group by d.comp_code,d.unit_code
		order by d.comp_code,d.unit_code';
	end
	else 
	begin
		if @pextra8='1' 
		begin----for route 		
			set @vquery='select d.comp_code comp_code,d.unit_code unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit_code) unit_name,
			d.route_code route_code,dbo.cir_get_route_name(d.comp_code,d.unit_code,d.route_code) route_name,
			dbo.cir_get_name_cir_route(d.comp_code,d.unit_code,d.route_code,''2'',null,null,null) route_oname,
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+''' ='''')
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit_code,d.route_code
			order by d.comp_code,d.unit_code,route_name';
			
			set @vquery1='select d.comp_code comp_code,d.unit_code unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit_code) unit_name,			
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+''' ='''')
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit_code
			order by d.comp_code,d.unit_code';
		end ------ route	
		else if @pextra8='2' 
		begin----for  branch
			set @vquery='select d.comp_code comp_code,d.unit_code unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit_code) unit_name,			
			m.branch_code branch_code,
			dbo.cir_get_branch(d.comp_code,m.branch_code) branch_name, 
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+''' ='''')
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit_code,m.branch_code
			order by d.comp_code,d.unit_code,branch_name'
			
			set @vquery1='select d.comp_code comp_code,d.unit_code unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit_code) unit_name,
			--m.branch_code branch_code,
			--dbo.cir_get_branch(d.comp_code,m.branch_code) branch_name, 
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+''' ='''')
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit_code
			order by d.comp_code,d.unit_code'
		end ---- branch		
		else if @pextra8='3' 
		begin----for  zone
			set @vquery=' select d.comp_code comp_code,d.unit_code unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit_code) unit_name,
			c.zone_code,
			dbo.cir_get_zone_name(d.comp_code,c.zone_code) zone_name, 
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+''' ='''')
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit_code,c.zone_code
			order by d.comp_code,d.unit_code,zone_name';
			
			set @vquery1=' select d.comp_code comp_code,d.unit_code unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit_code) unit_name,			
			--c.zone_code,
			--dbo.cir_get_zone_name(d.comp_code,c.zone_code) zone_name, 
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+''' ='''')
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit_code
			order by d.comp_code,d.unit_code';
		end  ---- zone
		else if @pextra8='4' 
		begin----for  region   
			set @vquery='  select d.comp_code comp_code,d.unit_code unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit_code) unit_name,
			c.region_code,
			dbo.cir_get_region_name(d.comp_code,c.region_code) region_name,
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+''' ='''')
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit_code,c.region_code
			order by d.comp_code,d.unit_code,region_name';
			
			set @vquery1='  select d.comp_code comp_code,d.unit_code unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit_code) unit_name,
			--c.region_code,
			--dbo.cir_get_region_name(d.comp_code,c.region_code) region_name,
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+''' ='''')
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit_code
			order by d.comp_code,d.unit_code';
		end ---- end  region
		else if @pextra8='5' 
		begin----for  district
			set @vquery='select d.comp_code comp_code,d.unit_code unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit_code) unit_name,
			m.dist_code dist_code,dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) district_name,
			dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,''2'',null,null,null) district_oname, '+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+''' ='''')
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit_code,m.state_code,m.dist_code
			order by d.comp_code,d.unit_code,m.state_code,district_name	'
			
			set @vquery1='select d.comp_code comp_code,d.unit_code unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit_code) unit_name,
			--m.dist_code dist_code,dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) district_name,
			--dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,''2'',null,null,null) district_oname, 
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+''' ='''')
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit_code
			order by d.comp_code,d.unit_code'
		end  ---- district
		else if @pextra8='6' 
		begin----for  tehsil_taluka
			set @vquery='  select d.comp_code comp_code,d.unit_code unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit_code) unit_name,
			m.tehsil_taluka tehsil_taluka,
			dbo.cir_get_taluka(d.comp_code,m.tehsil_taluka) taluka_name,
			dbo.cir_get_name_cir_taluka(d.comp_code,m.tehsil_taluka,''2'',null,null,null) taluka_oname,
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+''' ='''')
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit_code,m.tehsil_taluka
			order by d.comp_code,d.unit_code,taluka_name';
			
			set @vquery1='  select d.comp_code comp_code,d.unit_code unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit_code) unit_name,
			--m.tehsil_taluka tehsil_taluka,
			--dbo.cir_get_taluka(d.comp_code,m.tehsil_taluka) taluka_name,
			--dbo.cir_get_name_cir_taluka(d.comp_code,m.tehsil_taluka,''2'',null,null,null) taluka_oname,
			'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+''' ='''')
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit_code
			order by d.comp_code,d.unit_code';
		end  ----for  tehsil_taluka
		else if @pextra8='7' 
		begin----for  State
			set @vquery='select d.comp_code comp_code,d.unit_code unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit_code) unit_name,
			m.country_code country_code,
			m.state_code state_code,dbo.cir_get_state(d.comp_code,m.country_code,m.state_code) state_name
			,'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+''' ='''')
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit_code,m.country_code,m.state_code
			order by d.comp_code,d.unit_code,m.country_code,state_name';
			
			set @vquery1='select d.comp_code comp_code,d.unit_code unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit_code) unit_name			
			,'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+''' ='''')
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit_code
			order by d.comp_code,d.unit_code';
		end  ----for  state
		else 
		begin--for executive
			set @vquery='select d.comp_code comp_code,d.unit_code unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit_code) unit_name,
			m.country_code country_code,
			m.executive_code executive_code,dbo.cir_get_executive(d.comp_code,m.executive_code) executive_name
			,'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+''' ='''')
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit_code,m.country_code,m.executive_code
			order by d.comp_code,d.unit_code,m.country_code,executive_name';
			
			set @vquery1='select d.comp_code comp_code,d.unit_code unit_code,
			dbo.cir_get_unit_name(d.comp_code,d.unit_code) unit_name			
			,'+@vvar+' ,'+@vvar_sum+' TOTAL 
			from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c
			where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
			m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+''' ='''')
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
			and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
			and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
			and isnull(e.freeze_flag,''N'')=''N''
			group by d.comp_code,d.unit_code
			order by d.comp_code,d.unit_code';
		end
	end
end
print(@vquery)
print(@vquery1)
exec(@vquery)
exec(@vquery1)







ALTER PROCEDURE [dbo].[cir_rep_supply_cir_rep_supply1]
	@pcomp_code			VARCHAR(40) ,
	@punit_code         VARCHAR(40) ,
	@ppubl              VARCHAR(40) ,
	@pmainedtn          VARCHAR(40) ,
	@pedtn              VARCHAR(40) ,
	@proute             VARCHAR(40) ,
	@pfrom_supdate      DATETIME ,
	@ptill_supdate      DATETIME ,
	@pdateformat        VARCHAR(40) ,
    @pextra1            VARCHAR(40) ,--for branch
    @pextra2            VARCHAR(40) ,--for state,
	@pextra3			VARCHAR(40) ,--this is use to final and unfinal po
	@pextra4            VARCHAR(40) ,--for zone,
	@pextra5            VARCHAR(40) ,--for region
	@pextra6            VARCHAR(40) ,--for district
	@pextra7            VARCHAR(40) ,--for taluka
	@pextra8            VARCHAR(40) ,--report type filter 1 for routewise,2 for branchwise,3 for zonewise,4 for regionwise,5 for district,6 for talukaiwse,other than statewise
	@pextra9            VARCHAR(40) ,--for publication type
	@pextra10           VARCHAR(40),--for executive
	@pextra11           VARCHAR(40),-- it is using for standing order / posting
	@pextra12           VARCHAR(40), -- AGENCY TYPE
	@pextra13           VARCHAR(40), -- AGENCY CLASS
	@pextra14           VARCHAR(40),
	@pextra15           VARCHAR(40)
AS 
BEGIN
	DECLARE @vfrom_supdate	varchar(20);
	DECLARE @vtill_supdate  varchar(20);
	declare @vsup_seq_no	int
	
	DECLARE @supply_type_name	VARCHAR(4000)
	DECLARE @supply_sum			VARCHAR(4000) 
	DECLARE @vvar               VARCHAR(4000) 
	DECLARE @vvar_sum           VARCHAR(4000) 
	DECLARE @vquery             VARCHAR(8000) 
	DECLARE @vquery1            VARCHAR(8000) 
	DECLARE @vquery2            VARCHAR(8000) 
	DECLARE @vquery3            VARCHAR(8000) 
	DECLARE @vquery4            VARCHAR(8000) 
	DECLARE @vquery5            VARCHAR(8000) 

	SET @vfrom_supdate  = convert(varchar(20),@pfrom_supdate,101)
	SET @vtill_supdate  = convert(varchar(20),@ptill_supdate,101)
	
	if @pextra11 = '2' begin
	DECLARE cur_sup_type cursor LOCAL FOR 
		select distinct ' sum(case supply_type_code when '+''''+sup_ty_code+''''+' then base_supply else 0 end ) "'+sup_ty_name+'",' vty,
		'sum(case supply_type_code when '+''''+sup_ty_code+''''+' then base_supply else 0 end ) +' vty_sum,sup_seq_no
		from cir_supply_type_mast s, cir_supply d,cir_edtn_mast e
		where s.comp_code=@pcomp_code and s.comp_code=d.comp_code and s.comp_code=e.comp_code 
		and s.sup_ty_code =d.supply_type_code and
		(d.unit=isnull(@punit_code,d.unit) or @punit_code='') and d.publ=e.publ and 
		(d.publ=isnull(@ppubl,d.publ) or @ppubl='') and 
		d.edtn=e.edtn and (d.edtn=isnull(@pedtn,d.edtn) or @pedtn='') and 
		(e.main_edtn=isnull(@pmainedtn,e.main_edtn) or @pmainedtn='')
		and isnull(d.supply_flag,'Y')!='N'
		and isnull(e.freeze_flag,'N')='N'
		order by sup_seq_no;
		
		OPEN cur_sup_type 
		fetch NEXT FROM cur_sup_type INTO  @supply_type_name,@supply_sum,@vsup_seq_no
			while(@@FETCH_STATUS = 0) BEGIN
				set @vvar =COALESCE(@vvar+'', SPACE(0)) + '' + COALESCE(@supply_type_name + '', SPACE(0))
				set @vvar_sum=COALESCE(@vvar_sum+'', SPACE(0)) + '' + COALESCE(@supply_sum + '', SPACE(0))

		fetch NEXT from cur_sup_type INTO  @supply_type_name,@supply_sum,@vsup_seq_no
		end
		close cur_sup_type
		
		SET @vvar  = SUBSTRING(@vvar, 1, LEN(@vvar) - 1)
		SET @vvar_sum  = SUBSTRING(@vvar_sum, 1, LEN(@vvar_sum) - 1)
	end
	else
	begin
		DECLARE cur_sup_type cursor LOCAL FOR 
		select distinct ' sum(case sup_type_code when '+''''+sup_ty_code+''''+' then sup_copy else 0 end ) "'+sup_ty_name+'",' vty,
		'sum(case sup_type_code when '+''''+sup_ty_code+''''+' then sup_copy else 0 end ) +' vty_sum,sup_seq_no
		from cir_supply_type_mast s, cir_dbksup d,cir_edtn_mast e
		where s.comp_code=@pcomp_code and s.comp_code=d.comp_code and s.comp_code=e.comp_code 
		and s.sup_ty_code =d.sup_type_code and
		(d.unit_code=isnull(@punit_code,d.unit_code) or @punit_code='') and d.publ=e.publ 
		and (d.publ=isnull(@ppubl,d.publ) or @ppubl='') 
		and d.edtn=e.edtn and (d.edtn=isnull(@pedtn,d.edtn) or @pedtn='') and 
		d.supdate between @pfrom_supdate and @ptill_supdate and
		(e.main_edtn=isnull(@pmainedtn,e.main_edtn) or @pmainedtn='')		
		and isnull(e.freeze_flag,'N')='N'
		order by sup_seq_no;
		
		OPEN cur_sup_type 
		fetch NEXT FROM cur_sup_type INTO  @supply_type_name,@supply_sum,@vsup_seq_no
			while(@@FETCH_STATUS = 0) BEGIN
				set @vvar =COALESCE(@vvar+'', SPACE(0)) + '' + COALESCE(@supply_type_name + '', SPACE(0))
				set @vvar_sum=COALESCE(@vvar_sum+'', SPACE(0)) + '' + COALESCE(@supply_sum + '', SPACE(0))

		fetch NEXT from cur_sup_type INTO  @supply_type_name,@supply_sum,@vsup_seq_no
		end
		close cur_sup_type
		
		SET @vvar  = SUBSTRING(@vvar, 1, LEN(@vvar) - 1)
		SET @vvar_sum  = SUBSTRING(@vvar_sum, 1, LEN(@vvar_sum) - 1)
	end	
		
		
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

if @pextra11 = '1' 
begin
	if @pextra8='1' 
	Begin--for route
		set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,
		dbo.cir_get_unit_name(d.comp_code,d.unit_code) UNIT_NAME,
		d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,d.route_code ROUTE_CODE,dbo.cir_get_route_name(d.comp_code,d.unit_code,d.route_code) ROUTE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
		isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
		,dbo.cir_get_mode_name(d.comp_code,d.unit_code+d.route_code) as "MODE_NAME"
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code 
		and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+'''='''')
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		--and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
		group by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
		order by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code,d.agcd,d.dpcd'
		   print ('ss1') 
		print @vquery 
		EXEC (@vquery)
	end
	if @pextra8='2' 
	Begin----for  branch
		set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,
		dbo.cir_get_unit_name(d.comp_code,d.unit_code) UNIT_NAME,
		d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.branch_code BRANCH_CODE,dbo.cir_get_branch(d.comp_code,m.branch_code) BRANCH_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
		isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+'''='''')
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		--and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.branch_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
		order by d.comp_code,d.unit_code,d.publ,d.edtn,branch_name,d.agcd,d.dpcd'

		print @vquery 
		EXEC (@vquery)
	end

	if @pextra8='3' 
	Begin----for  zone
		set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,
		dbo.cir_get_unit_name(d.comp_code,d.unit_code) UNIT_NAME,
		d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.zone_code ZONE_CODE,
		dbo.cir_get_zone_name(d.comp_code,c.zone_code) ZONE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
		isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+'''='''')
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		--and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
		group by d.comp_code,d.unit_code,d.publ,d.edtn,c.zone_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
		order by d.comp_code,d.unit_code,d.publ,d.edtn,zone_code,d.agcd,d.dpcd'
		    
		print @vquery 
		EXEC (@vquery)
	end

	if @pextra8='4' 
	Begin----for  region
		set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,
		dbo.cir_get_unit_name(d.comp_code,d.unit_code) UNIT_NAME,
		d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.region_code REGION_CODE,dbo.cir_get_region_name(d.comp_code,c.region_code) REGION_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
		isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+'''='''')
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		--and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
		group by d.comp_code,d.unit_code,d.publ,d.edtn,c.region_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
		order by d.comp_code,d.unit_code,d.publ,d.edtn,c.region_code,d.agcd,d.dpcd'
		    
		print @vquery 
		EXEC (@vquery)
	end

	if @pextra8='5' 
	Begin----for  district
		set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,
		dbo.cir_get_unit_name(d.comp_code,d.unit_code) UNIT_NAME,
		d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.dist_code DIST_CODE,dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,''1'',null,null,null) DIST_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
		isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+'''='''')
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		--and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.dist_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code order by d.comp_code,d.unit_code,d.publ,d.edtn,dist_code,d.agcd,d.dpcd'
		    
		print @vquery 
		EXEC (@vquery)
	end

	if @pextra8='6' 
	Begin----for Taluka
		set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,
		dbo.cir_get_unit_name(d.comp_code,d.unit_code) UNIT_NAME,
		d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.tehsil_taluka TALUKA_CODE,dbo.cir_get_taluka(d.comp_code,m.tehsil_taluka) TALUKA_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
		isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+'''='''')
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		--and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.tehsil_taluka,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code order by d.comp_code,d.unit_code,d.publ,d.edtn,taluka_code,d.agcd,d.dpcd'
		    
		print @vquery 
		EXEC (@vquery)
	end
	if @pextra8='7' 
	Begin----for State
		set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,
		dbo.cir_get_unit_name(d.comp_code,d.unit_code) UNIT_NAME,
		d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.state_code STATE_CODE,dbo.cir_get_state1(d.comp_code,m.state_code) STATE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",c.city_name "CITY NAME",
		c.city_oname "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+'''='''')
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		--and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.state_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,c.city_name,c.city_Oname order by d.comp_code,d.unit_code,d.publ,d.edtn,m.state_code,d.agcd,d.dpcd'
		    
		print @vquery 
		EXEC (@vquery)
	end

	if @pextra8='8' 
	Begin----for Executive
		set @vquery='select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,
		dbo.cir_get_unit_name(d.comp_code,d.unit_code) UNIT_NAME,
		d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.executive_code EXECUTIVE_CODE,dbo.cir_get_executive(d.comp_code,m.executive_code) EXECUTIVE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
		substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",c.city_name "CITY NAME",
		c.city_oname "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+'''='''')
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		--and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.executive_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,c.city_name,c.city_Oname order by d.comp_code,d.unit_code,d.publ,d.edtn,m.executive_code,d.agcd,d.dpcd'
		    
		print @vquery 
		EXEC (@vquery)
	end
		SET @vquery1  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+'''='''')
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		--and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
		group by d.comp_code,d.unit_code order by d.comp_code,d.unit_code'
		print('tb 1')
		print @vquery1
		EXEC (@vquery1)
			
	if @pextra8='1' 
	Begin--for route
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,
		dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,
		dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,d.route_code ROUTE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+'''='''')
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		--and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
		group by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code order by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code'
		print ('ss')
		print @vquery2
		EXEC (@vquery2)
	end

	if @pextra8='2' 
	Begin--for branch
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.branch_code BRANCH_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+'''='''')
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		--and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.branch_code order by d.comp_code,d.unit_code,d.publ,d.edtn,m.branch_code'
		print @vquery2
		EXEC (@vquery2)
	end

	if @pextra8='3' 
	Begin--for Zone
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.zone_code ZONE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+'''='''')
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		--and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
		group by d.comp_code,d.unit_code,d.publ,d.edtn,c.zone_code order by d.comp_code,d.unit_code,d.publ,d.edtn,c.zone_code'
		print @vquery2
		EXEC (@vquery2)
	end

	if @pextra8='4' 
	Begin--for region
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.region_code REGION_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+'''='''')
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		--and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
		group by d.comp_code,d.unit_code,d.publ,d.edtn,c.region_code order by d.comp_code,d.unit_code,d.publ,d.edtn,c.region_code'
		print @vquery2
		EXEC (@vquery2)
	end

	if @pextra8='5' 
	Begin--for District
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.dist_code DIST_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+'''='''')
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		--and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.dist_code order by d.comp_code,d.unit_code,d.publ,d.edtn,m.dist_code'
		print @vquery2
		EXEC (@vquery2)
	end

	if @pextra8='6' 
	Begin--for Taluka
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.tehsil_taluka TALUKA_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+'''='''')
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		--and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.tehsil_taluka order by d.comp_code,d.unit_code,d.publ,d.edtn,m.tehsil_taluka'
		print @vquery2
		EXEC (@vquery2)
	end

	if @pextra8='7' 
	Begin--for state
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.state_code STATE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+'''='''')
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		--and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.state_code order by d.comp_code,d.unit_code,d.publ,d.edtn,m.state_code'
		print @vquery2
		EXEC (@vquery2)
	end

	if @pextra8='8' 
	Begin--for executive
		SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.executive_code EXECUTIVE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+'''='''')
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		--and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
		group by d.comp_code,d.unit_code,d.publ,d.edtn,m.executive_code order by d.comp_code,d.unit_code,d.publ,d.edtn,m.executive_code'
		print @vquery2
		EXEC (@vquery2)
	end

		SET @vquery3  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+'''='''')
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		--and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
		group by d.comp_code,d.unit_code,d.publ,d.edtn order by d.comp_code,d.unit_code,d.publ,d.edtn'
		print ('33')
		print @vquery3
		EXEC (@vquery3)

		SET @vquery4  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,d.publ PUBL,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+'''='''')
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		--and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
		group by d.comp_code,d.unit_code,d.publ order by d.comp_code,d.unit_code,d.publ'
		print @vquery4
		EXEC (@vquery4)
		
		
	SET @vquery5  = ' select d.comp_code COMP_CODE,d.unit_code UNIT_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
		from cir_dbksup d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
		where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
		m.unit=d.unit_code and (d.unit_code='''+@punit_code+''' or '''+@punit_code+'''='''')
		and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
		and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
		and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
		and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		--and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
		group by d.comp_code,d.unit_code order by d.comp_code,d.unit_code'
	print @vquery5
		EXEC (@vquery5)
end
else
begin
	if @pextra8='1' 
	Begin--for route
	set @vquery='select d.comp_code COMP_CODE,d.unit UNIT_CODE,
	dbo.cir_get_unit_name(d.comp_code,d.unit) UNIT_NAME,
	d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,d.route_code ROUTE_CODE,dbo.cir_get_route_name(d.comp_code,d.unit,d.route_code) ROUTE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
	substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
	isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,2) "ODROP_POINT"
	, '+@vvar+','+@vvar_sum+' TOTAL 
	,dbo.cir_get_mode_name(d.comp_code,d.unit+d.route_code) as "MODE_NAME"
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code 
	and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
	group by d.comp_code,d.unit,d.publ,d.edtn,d.route_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
	order by d.comp_code,d.unit,d.publ,d.edtn,d.route_code,d.agcd,d.dpcd'
	    
	print @vquery 
	EXEC (@vquery)
end
if @pextra8='2' 
Begin----for  branch
	set @vquery='select d.comp_code COMP_CODE,d.unit UNIT_CODE,
	dbo.cir_get_unit_name(d.comp_code,d.unit) UNIT_NAME,
	d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.branch_code BRANCH_CODE,dbo.cir_get_branch(d.comp_code,m.branch_code) BRANCH_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
	substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
	isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME"
	, dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,1) "DROP_POINT"
	, dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
	group by d.comp_code,d.unit,d.publ,d.edtn,m.branch_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
	order by d.comp_code,d.unit,d.publ,d.edtn,branch_name,d.agcd,d.dpcd'

	print @vquery 
	EXEC (@vquery)
end

if @pextra8='3' 
Begin----for  zone
	set @vquery='select d.comp_code COMP_CODE,d.unit UNIT_CODE,
	dbo.cir_get_unit_name(d.comp_code,d.unit) UNIT_NAME,
	d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME
	,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.zone_code ZONE_CODE,
	dbo.cir_get_zone_name(d.comp_code,c.zone_code) ZONE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
	substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
	isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME"
	, dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
	group by d.comp_code,d.unit,d.publ,d.edtn,c.zone_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
	order by d.comp_code,d.unit,d.publ,d.edtn,zone_code,d.agcd,d.dpcd'
	    
	print @vquery 
	EXEC (@vquery)
end

if @pextra8='4' 
Begin----for  region
	set @vquery='select d.comp_code COMP_CODE,d.unit UNIT_CODE,
	dbo.cir_get_unit_name(d.comp_code,d.unit) UNIT_NAME,
	d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn
	,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.region_code REGION_CODE,dbo.cir_get_region_name(d.comp_code,c.region_code) REGION_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
	substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
	isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME"
	, dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
	group by d.comp_code,d.unit,d.publ,d.edtn,c.region_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code 
	order by d.comp_code,d.unit,d.publ,d.edtn,c.region_code,d.agcd,d.dpcd'
	    
	print @vquery 
	EXEC (@vquery)
end

if @pextra8='5' 
Begin----for  district
	set @vquery='select d.comp_code COMP_CODE,d.unit UNIT_CODE,
	dbo.cir_get_unit_name(d.comp_code,d.unit) UNIT_NAME,
	d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.dist_code DIST_CODE,dbo.cir_get_name_cir_district(d.comp_code,m.dist_code,''1'',null,null,null) DIST_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
	substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
	isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME"
	, dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
	group by d.comp_code,d.unit,d.publ,d.edtn,m.dist_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code order by d.comp_code,d.unit,d.publ,d.edtn,dist_code,d.agcd,d.dpcd'
	    
	print @vquery 
	EXEC (@vquery)
end

if @pextra8='6' 
Begin----for Taluka
	set @vquery='select d.comp_code COMP_CODE,d.unit UNIT_CODE,
	dbo.cir_get_unit_name(d.comp_code,d.unit) UNIT_NAME,
	d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.tehsil_taluka TALUKA_CODE,dbo.cir_get_taluka(d.comp_code,m.tehsil_taluka) TALUKA_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
	substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
	isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,null,null,null),''NA'') "CITY ONAME",
	 dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
	group by d.comp_code,d.unit,d.publ,d.edtn,m.tehsil_taluka,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code order by d.comp_code,d.unit,d.publ,d.edtn,taluka_code,d.agcd,d.dpcd'
	    
	print @vquery 
	EXEC (@vquery)
end
if @pextra8='7' 
Begin----for State
	set @vquery='select d.comp_code COMP_CODE,d.unit UNIT_CODE,
	dbo.cir_get_unit_name(d.comp_code,d.unit) UNIT_NAME,
	d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.state_code STATE_CODE,dbo.cir_get_state1(d.comp_code,m.state_code) STATE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
	substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",c.city_name "CITY NAME",
	c.city_oname "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,1) "DROP_POINT",
	 dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
	group by d.comp_code,d.unit,d.publ,d.edtn,m.state_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,c.city_name,c.city_Oname 
	order by d.comp_code,d.unit,d.publ,d.edtn,m.state_code,d.agcd,d.dpcd'
	    
	print @vquery 
	EXEC (@vquery)
end

if @pextra8='8' 
Begin----for Executive
	set @vquery='select d.comp_code COMP_CODE,d.unit UNIT_CODE,
	dbo.cir_get_unit_name(d.comp_code,d.unit) UNIT_NAME,
	d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.executive_code EXECUTIVE_CODE,dbo.cir_get_executive(d.comp_code,m.executive_code) EXECUTIVE_NAME,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
	substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",c.city_name "CITY NAME",
	c.city_oname "CITY ONAME", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit,m.station_code,2) "ODROP_POINT", '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
	group by d.comp_code,d.unit,d.publ,d.edtn,m.executive_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,c.city_name,c.city_Oname
	order by d.comp_code,d.unit,d.publ,d.edtn,m.executive_code,d.agcd,d.dpcd'
	    
	print @vquery 
	EXEC (@vquery)
end
	SET @vquery1  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
	group by d.comp_code,d.unit order by d.comp_code,d.unit'
	print @vquery1
	EXEC (@vquery1)
		
if @pextra8='1' 
Begin--for route
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,d.route_code ROUTE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
	group by d.comp_code,d.unit,d.publ,d.edtn,d.route_code order by d.comp_code,d.unit,d.publ,d.edtn,d.route_code'
	print @vquery2
	EXEC (@vquery2)
end

if @pextra8='2' 
Begin--for branch
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME
	,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.branch_code BRANCH_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
	group by d.comp_code,d.unit,d.publ,d.edtn,m.branch_code order by d.comp_code,d.unit,d.publ,d.edtn,m.branch_code'
	print @vquery2
	EXEC (@vquery2)
end

if @pextra8='3' 
Begin--for Zone
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.zone_code ZONE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
	group by d.comp_code,d.unit,d.publ,d.edtn,c.zone_code order by d.comp_code,d.unit,d.publ,d.edtn,c.zone_code'
	print @vquery2
	EXEC (@vquery2)
end

if @pextra8='4' 
Begin--for region
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,c.region_code REGION_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
	group by d.comp_code,d.unit,d.publ,d.edtn,c.region_code order by d.comp_code,d.unit,d.publ,d.edtn,c.region_code'
	print @vquery2
	EXEC (@vquery2)
end

if @pextra8='5' 
Begin--for District
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.dist_code DIST_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
	group by d.comp_code,d.unit,d.publ,d.edtn,m.dist_code order by d.comp_code,d.unit,d.publ,d.edtn,m.dist_code'
	print @vquery2
	EXEC (@vquery2)
end

if @pextra8='6' 
Begin--for Taluka
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.tehsil_taluka TALUKA_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
	group by d.comp_code,d.unit,d.publ,d.edtn,m.tehsil_taluka order by d.comp_code,d.unit,d.publ,d.edtn,m.tehsil_taluka'
	print @vquery2
	EXEC (@vquery2)
end

if @pextra8='7' 
Begin--for state
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.state_code STATE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
	group by d.comp_code,d.unit,d.publ,d.edtn,m.state_code order by d.comp_code,d.unit,d.publ,d.edtn,m.state_code'
	print @vquery2
	EXEC (@vquery2)
end

if @pextra8='8' 
Begin--for executive
	SET @vquery2  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) EDTN_NAME,m.executive_code EXECUTIVE_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
	group by d.comp_code,d.unit,d.publ,d.edtn,m.executive_code order by d.comp_code,d.unit,d.publ,d.edtn,m.executive_code'
	print @vquery2
	EXEC (@vquery2)
end

	SET @vquery3  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,dbo.cir_get_publ_name(d.comp_code,d.publ) PUBL_NAME,d.edtn,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
	group by d.comp_code,d.unit,d.publ,d.edtn order by d.comp_code,d.unit,d.publ,d.edtn'
	print @vquery3
	EXEC (@vquery3)

	SET @vquery4  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,d.publ PUBL,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
	group by d.comp_code,d.unit,d.publ order by d.comp_code,d.unit,d.publ'
	print @vquery4
	EXEC (@vquery4)
	
	SET @vquery5  = ' select d.comp_code COMP_CODE,d.unit UNIT_CODE,'+@vvar+','+@vvar_sum+' TOTAL 
	from cir_supply d,cir_agmast m,cir_edtn_mast e, cir_city_mast c,cir_publ_mast p
	where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='+''''+@pcomp_code+''''+' and 
	m.unit=d.unit and (d.unit='''+@punit_code+''' or '''+@punit_code+'''='''')
	and d.publ=e.publ and d.publ=p.publ and (d.publ='''+@ppubl+''' or '''+@ppubl+'''='''')
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
	and (p.pro_type='''+@pextra9+''' or '''+@pextra9+'''='''')
	and (m.executive_code='''+@pextra10+''' or '''+@pextra10+'''='''')
	and (m.AG_TYPE='''+@pextra12+''' or '''+@pextra12+'''='''')
		and (m.AG_CLASS='''+@pextra13+''' or '''+@pextra13+'''='''')
		and isnull(d.supply_flag,''Y'')!=''N''
		and isnull(e.freeze_flag,''N'')=''N''
	group by d.comp_code,d.unit order by d.comp_code,d.unit'
	
	print @vquery5
	EXEC (@vquery5)
end

DEALLOCATE cur_sup_type

END


///////////////////////////////////////////////end////////////////////////////////////////////

//================add by Deepika 16/may/2013 sent by Sushil sir===================================


alter procedure [dbo].[cir_interest_on_overdue_bill](
    @pcomp_code          as varchar(20),
    @punit_code          as varchar(20),
    @pason_date          as datetime,
    @pagency_type        as varchar(20),
    @pagmain_code        as varchar(20),
    @pagsub_code         as varchar(20),
    @pint_rate           as numeric(12,2),
    @poverdue_days       as numeric(10),
    @pposting_req        as varchar(20),--Y for Posting & N for no posting
    @puserid             as varchar(20),
    @pdateformat         as varchar(20),
    @pextra1             as varchar(200),
    @pextra2             as varchar(200),
    @pextra3             as varchar(200),
    @pextra4             as varchar(200),
    @pextra5             as varchar(200))
As
    declare @v_cnt            int
    --declare @v_ason_dt        datetime;
    declare @v_userid         varchar(20);
    declare @v_days           numeric(10);
    
    declare c_agency cursor for select Comp_Code comp_code, agcd agency_code, dpcd agency_sub_code, ag_name agency_name, City_Code city_code,
	                                   isnull((select "City_Name" from city_mst 
								                  where "Comp_Code" = cir_agmast.Comp_Code 
								                     and City_Code=cir_agmast.City_Code),'Not Define') city_name,
                                       Credit_Days credit_days from cir_agmast
									where "Comp_Code"=@pcomp_code 
										and ((agcd=@pagmain_code) or (@pagmain_code is null)) 
										and ((dpcd=@pagsub_code) or (@pagsub_code is null)) 
										and ((ag_type=@pagency_type) or (@pagency_type is null));
    
 declare @v_agency_comp_code		varchar(20)
 declare @v_agency_agency_code		varchar(20)
 declare @v_agency_agency_sub_code	varchar(20)
 declare @v_agency_agency_name		varchar(500)
 declare @v_agency_city_code		varchar(50)
 declare @v_agency_city_name		varchar(100)
 declare @v_agency_credit_days		as numeric(10)


declare @v_pub_center	varchar(50);
declare @v_recptno		varchar(50);
declare @v_vchno		varchar(50);
declare @v_doctype		varchar(10);
declare @v_remark		VARCHAR(500);
declare @v_pprocessdt   DATETIME;
declare @p_pprocessdt   varchar(30);
declare @v_prefix		varchar(30);
declare @v_branchnm		varchar(20);
declare @v_reason		varchar(20);
declare @v_dr_cdp		varchar(20);
declare @v_cr_cdp		varchar(20);
declare @rec_intt_comp_code		varchar(50)
declare @rec_intt_bran_code		varchar(50)
	
begin

	--set @p_pprocessdt = convert(varchar(10),getdate(),101)
	
	--set @v_pprocessdt= @p_pprocessdt;
    
	set @v_pprocessdt = @pason_date

    print('@v_pprocessdt')print(@p_pprocessdt)
    set @v_remark    = 'Interest Invoice ';
    set @v_doctype   = 'INI';
    set @v_reason    = 'IN0';--Interest Invoice


    open c_agency;
        FETCH NEXT FROM c_agency INTO  @v_agency_comp_code , @v_agency_agency_code,@v_agency_agency_sub_code,@v_agency_agency_name,
			@v_agency_city_code,@v_agency_city_name,@v_agency_credit_days
		WHILE (@@FETCH_STATUS = 0) BEGIN

		print('@v_agency_agency_code ')print(@v_agency_agency_code)print(@v_agency_agency_sub_code)

		
			--select distinct @v_branchnm= substring(isnull("Branch_Alias","Branch_Name"),1,3)  from branch_mst 
            --where "Comp_Code"=@rec_intt_comp_code and "Branch_Code"=@rec_intt_bran_code
			
			--set @v_prefix  = @v_doctype + '/' +   @v_branchnm + '/' + replace(CONVERT(VARCHAR(5), @v_pprocessdt, 11) ,'/','-')+ '/' 
			--set @v_prefix  = @v_doctype + replace(CONVERT(VARCHAR(2), @v_pprocessdt, 11) ,'/','-') 
			--set @v_recptno  = dbo.ad_genreceiptno( @rec_intt_comp_code, @v_prefix, null, @v_doctype, @p_pprocessdt, 'mm/dd/yyyy', 'F')			
		
		      

		declare @v_bill_comp_code    varchar(100);
		declare @v_bill_billno       varchar(100);
		declare @v_bill_billdt       datetime;
		declare @v_bill_bill_amt     numeric(18,2);
		declare @v_intt_amt          numeric(18,2);
		declare @v_bill_unit         varchar(20);
		 
		 declare  c_bill cursor for
                select distinct x.comp_code, x.billno, x.billdt as billdt, sum(x.bill_amt) bill_amt,
				                b.unit_Code from (select distinct comp_code, billno, billdt as billdt, sum(amount) bill_amt from cir_outmast
                                                 where comp_code              = @pcomp_code 
												  and (unit_Code              = isnull(@punit_code,unit_code) or @punit_code='') 
												  and  agcd                   = @v_agency_agency_code 
												  and  dpcd                   = isnull(@v_agency_agency_sub_code,dpcd) 
												  and  billdt                <= @pason_date 
												  and isnull(recptdt,billdt) <= @pason_date
                                                 group by comp_code,billno,billdt having sum(amount)>0
                                             union
                                             select distinct comp_code, recptno billno, recptdt billdt, sum(amount) bill_amt from cir_outmast
                                                 where comp_code = @pcomp_code 
												  and (unit_code = isnull(@punit_code,unit_Code) or @punit_code='') 
												  and  agcd      = @v_agency_agency_code 
												  and  dpcd      = isnull(@v_agency_agency_sub_code, dpcd) 
												  and  recptdt  <= @pason_date and isnull(amount,0)>0 
                                                  and (billno is null or billno='')
                                                 group by comp_code,recptno,recptdt having sum(amount)>0) x, cir_bill b
                where x.comp_code=b.comp_code and x.billdt=b.billdt and x.billno=b.billno and
                not exists (select 'x' from CIR_interest_bill_detail d 
				              where d.comp_code=b.comp_code 
							    and d.billdt=b.billdt 
								and d.billno=b.billno)
                group by x.comp_code,x.billno,x.billdt,b.unit_code
                order by x.billdt,x.billno;
           print('open c_bill') print(@pcomp_code)print(@punit_code)print(@v_agency_agency_code)print(@pason_date)
        open c_bill;
			FETCH NEXT FROM c_bill INTO @v_bill_comp_code,@v_bill_billno,@v_bill_billdt,@v_bill_bill_amt,@v_bill_unit;
			WHILE (@@FETCH_STATUS = 0) BEGIN
			print('@@v_bill_billno ')print(@v_bill_billno)print(@v_bill_bill_amt)print(@v_bill_billdt)print(@pason_date)
             if SUBSTRING((isnull(@v_bill_billno,'?')),1,4) = 'OLDI'
			    BEGIN
				   set @v_days = '60'
				END
             else
			    BEGIN
                   set @v_days=DATEDIFF(dd, DBO.GetLastDayOfMonth(@v_bill_billdt),@pason_date )- isnull(@v_agency_credit_days,0)+1;
                END
			print('v_days')print(@v_days)
			if @v_days<0 begin
			  set @v_days=0;
			end
        
        if @v_days >=isnull(@poverdue_days,0) begin
        
            set @v_intt_amt  =round((isnull(@v_bill_bill_amt,0)*@pint_rate*@v_days)/(100*365),2);
            if isnull(@v_intt_amt,0) > 0 
			   begin
					insert into cir_interest_bill_detail (comp_code, bran_code, agcd, dpcd, billno,
															billdt, bill_osamt, bill_ason, intt_rate, intt_amt,
															intt_days, credit_days, overdue_days, post_flag, created_by,
															created_dt, int_date,  int_doc_type, int_doc_no)
													values(@v_agency_comp_code, @v_bill_unit, @v_agency_agency_code, @v_agency_agency_sub_code, @v_bill_billno,
															@v_bill_billdt, @v_bill_bill_amt, @pason_date, @pint_rate, @v_intt_amt,
															@v_days, @v_agency_credit_days, @poverdue_days, 'N', @puserid,
															getdate(), @v_pprocessdt, @v_doctype,@v_recptno);
               end
        end
        
        set @v_days=0;
        set @v_bill_bill_amt =0;
        set @v_bill_comp_code=null;
        set @v_bill_billno   =null;
        set @v_bill_billdt   =null;
        set @v_intt_amt      =0; 
			FETCH NEXT FROM c_bill INTO @v_bill_comp_code,@v_bill_billno,@v_bill_billdt,@v_bill_bill_amt,@v_bill_unit; 
        end
        close c_bill;
        deallocate c_bill;
		

       FETCH NEXT FROM c_agency INTO  @v_agency_comp_code , @v_agency_agency_code,@v_agency_agency_sub_code,@v_agency_agency_name,
			@v_agency_city_code,@v_agency_city_name,@v_agency_credit_days 
    end
    close c_agency;
    deallocate c_agency;



    begin
        select distinct @v_dr_cdp=dr_cdp,@v_cr_cdp=cr_cdp
            from fa_fin_link_mast
        where comp_code         = @pcomp_code
            and unit_code      = 'ALL'
            and branch_code    = 'ALL'
            and modual_alias   = 'ADCOLL'
            and doctype        = @v_doctype
            and reason_paymode = @v_reason
            and @v_pprocessdt between eff_fr_date and eff_to_date;
               
    end
    

	declare @rec_intt_ag_main_code	varchar(50)
	declare @rec_intt_ag_sub_code	varchar(50)
	declare @rec_intt_intt_rate		numeric(12,2)
	declare @rec_intt_amount		numeric(18,2)
	declare @rec_intt_region		varchar(50)    

    declare cur_intt cursor for select d.comp_code, d.bran_code, d.agcd, d.dpcd, d.intt_rate,
	                                   sum(d.intt_amt) amount, '' region from cir_interest_bill_detail d, cir_Agmast m
                                   where d.comp_code = m.Comp_Code 
								     and d.agcd      = m.agcd 
									 and d.dpcd      = m.dpcd
									 and d.post_flag = 'N' 
									 --and created_dt=getdate()
                                   group by d.comp_code ,d.bran_code ,d.agcd ,d.dpcd, d.intt_rate;

    
    open cur_intt;
        FETCH NEXT FROM cur_intt INTO @rec_intt_comp_code, @rec_intt_bran_code, @rec_intt_ag_main_code, @rec_intt_ag_sub_code, @rec_intt_intt_rate ,@rec_intt_amount, @rec_intt_region
		   WHILE (@@FETCH_STATUS = 0) BEGIN
             set @v_cnt=isnull(@v_cnt,0)+1;
          
			select @v_vchno  =  MAX(voucherno) FROM  cir_rcphdr 
			  WHERE comp_code  = @rec_intt_comp_code 
			   AND  doctype  = @v_doctype 
			   AND	replace(CONVERT(VARCHAR(5), recptdt, 11) ,'/','')  = replace(CONVERT(VARCHAR(5), @v_pprocessdt, 11) ,'/','')
			
			IF (@v_vchno is null or @v_vchno = '0' )
			BEGIN 
				set @v_vchno  = replace(CONVERT(VARCHAR(5), @v_pprocessdt, 11) ,'/','')+ '0001' 
			END
			ELSE
			BEGIN 
				if( len(cast(@v_vchno as int))=1)
					set @v_vchno='0000000'+@v_vchno
				if( len(cast(@v_vchno as int))=2)
					set @v_vchno='000000'+@v_vchno
				if( len(cast(@v_vchno as int))=3)
					set @v_vchno='00000'+@v_vchno
				if( len(cast(@v_vchno as int))=4)
					set @v_vchno='0000'+@v_vchno
				if( len(cast(@v_vchno as int))=5)
					set @v_vchno='000'+@v_vchno
				if( len(cast(@v_vchno as int))=6)
					set @v_vchno='00'+@v_vchno
				if( len(cast(@v_vchno as int))=7)
					set @v_vchno='0'+@v_vchno
				else
					set @v_vchno=@v_vchno
			END          
          
            Begin
                select distinct @v_pub_center = pub_center  from branch_mst 
					where Comp_Code   = @rec_intt_comp_code 
					  and Branch_Code = @rec_intt_bran_code;
  
            End;
              if isnull(@rec_intt_amount,0) > 0 
			     begin
			          set @v_recptno  = [dbo].[cir_generate_intbillno] (  @rec_intt_comp_code, @v_pub_center, 'INI', @v_pprocessdt,'mm/dd/yyyy','INTI', '')      
						/*PRINT '@v_recptno'
						PRINT @v_recptno
						print '@v_recptno'
						print @v_recptno     
						--set @v_recptno='eeeee' 
						print @rec_intt_comp_code
						print @puserid
						print @rec_intt_bran_code
						print @v_doctype
						print @v_recptno 
						print @v_pprocessdt
						print @v_reason 
						print @rec_intt_amount 
						print @v_remark
						print @v_vchno
						print @v_pprocessdt
						print @rec_intt_ag_main_code
						print @rec_intt_ag_sub_code
						print @v_dr_cdp
						print @v_cr_cdp 
						print @v_pub_center*/
					insert into cir_rcphdr (comp_code, userid, branch_code, doctype, recptno, 
											recptdt, reason, amount, oth_amount, chno, 
											chdt, chbank, remark, received_from, voucherno, 
											voucherdt, agcd, dpcd, ccdp, rcdp, 
											unit_Code)
									values (@rec_intt_comp_code, @puserid, @rec_intt_bran_code, @v_doctype, @v_recptno,
											@v_pprocessdt, @v_reason, @rec_intt_amount, null, null, 
											null , null , @v_remark, null, @v_vchno, 
											@v_pprocessdt, @rec_intt_ag_main_code, @rec_intt_ag_sub_code, @v_dr_cdp, @v_cr_cdp, 
											@v_pub_center);
                                   
					insert into cir_rcpdet (comp_code, usrid, branch_code, doctyp, recptno, 
											recptdt, reason, voucherno, voucherdt, amount, 
											chno, chdt, chbnk, remark, agcd, 
											dpcd, unit_code)
									values (@rec_intt_comp_code, @puserid, @rec_intt_bran_code, @v_doctype, @v_recptno,
											@v_pprocessdt, @v_reason, @v_vchno, @v_pprocessdt, @rec_intt_amount,
											null, null, null, @v_remark, @rec_intt_ag_main_code,
											@rec_intt_ag_sub_code, @v_pub_center);

				   insert into cir_outmast (comp_code, usrid, branch_Code, doctyp, recptno,
											recptdt, reason, voucherno, voucherdt, amount,
											chno, chdt, chbnk, remark, agcd, 
											dpcd, unit_code)
									values (@rec_intt_comp_code, @puserid, @rec_intt_bran_code, @v_doctype, @v_recptno,
											@v_pprocessdt, @v_reason, @v_vchno, @v_pprocessdt, 0,
											null ,null ,null,@v_remark, @rec_intt_ag_main_code,
											@rec_intt_ag_sub_code, @v_pub_center);
				--------debit note as billno allocate
				   insert into cir_outmast (comp_code, branch_code, doctyp, reason , billno, 
											billdt, recptno, recptdt, chno, chdt, 
											chbnk, voucherno, voucherdt, amount, usrid,
											agcd, dpcd, remark, unit_Code)
									  values(@rec_intt_comp_code, @rec_intt_bran_code, @v_doctype, @v_reason, @v_recptno,
											 @v_pprocessdt, @v_recptno, @v_pprocessdt, null, null,
											 null, @v_vchno, @v_pprocessdt, abs(@rec_intt_amount), @puserid,
											 @rec_intt_ag_main_code, @rec_intt_ag_sub_code, @v_remark, @v_pub_center);
    
                   update cir_interest_bill_detail set post_flag = 'Y', int_Doc_no = @v_recptno
                        where comp_code = @rec_intt_comp_code 
			              and bran_code = @rec_intt_bran_code 
			              and agcd      = @rec_intt_ag_main_code 
			              and dpcd      = @rec_intt_ag_sub_code 
			              and post_flag = 'N' 
			              --and created_dt=GETDATE();
        
		
		       end 
            
		FETCH NEXT FROM cur_intt INTO @rec_intt_comp_code , @rec_intt_bran_code ,@rec_intt_ag_main_code ,@rec_intt_ag_sub_code ,
			@rec_intt_intt_rate ,@rec_intt_amount,@rec_intt_region
    end
    close cur_intt;
    deallocate cur_intt;
    
    select getdate() as "CUR_DATE";
    

End



CREATE FUNCTION [dbo].[cir_generate_intbillno]
(
    @pcomp_code                               VARCHAR(20) ,
    @punit_code                               VARCHAR(20) ,
	@pdoctype                                 VARCHAR(20) , 
    @pbill_date                               DATETIME ,
    @pdateformat                              VARCHAR(20) ,
    @pextra1                                  VARCHAR(4000) ,
    @pextra2                                  VARCHAR(4000)
)
RETURNS VARCHAR(20)
AS
    BEGIN
       
        DECLARE @v_billno                                 VARCHAR(20)
        DECLARE @v_billdt                                 DATETIME
		DECLARE @v_start_date                             DATETIME
		DECLARE @v_end_date                               DATETIME

/**********     SEND CONVERTED DATE FROM SQL CLASS       ***************************/
        SET @v_billdt     = @pbill_date
		SET @v_start_date = CAST(dbo.fa_fin_dt (@pcomp_code,@v_billdt) AS DATETIME)
		SET @v_end_date   = dateadd(d,-1,dateadd(m,12,CAST(dbo.fa_fin_dt (@pcomp_code,@v_billdt) AS DATETIME)))
        
        IF ((ISNULL(@pextra1,'?')='?') OR (@pextra1=''))
           BEGIN
              SET @pextra1 = 'CIRI'
           END
        ELSE
           BEGIN
              SET @pextra1 = @pextra1
           END   
/***********************************************************************************/

if upper(@pextra2)='D'
begin

        SELECT @v_billno  =   max(convert(int,SUBSTRING(billno,(len(billno) -6),len(billno))))
        FROM  cir_rphdr_dis
        WHERE     comp_code  = @pcomp_code
         AND    unit_code  = @punit_code
		 and DOCTYPE = @pdoctype
		 and recptdt between @v_start_date and @v_end_date
         AND SUBSTRING(recptno,1,4)=ISNULL(@pextra1,'')
		  --AND    YEAR(billdt)  = YEAR(@v_billdt)
end
else
begin
SELECT @v_billno  =   max(convert(int,SUBSTRING(recptno,(len(recptno) -6),len(recptno))))
        FROM  cir_rcphdr
        WHERE     comp_code  = @pcomp_code
         AND    unit_code  = @punit_code
		 and DOCTYPE = @pdoctype
		 and recptdt between @v_start_date and @v_end_date
         AND SUBSTRING(recptno,1,4)=ISNULL(@pextra1,'')
		 --AND    YEAR(billdt)  = YEAR(@v_billdt)
end       
        IF @v_billno is null or @v_billno = '0'
        BEGIN
            --SET @v_billno  = /*@punit_code*/'CIRI' + SUBSTRING (CONVERT (VARCHAR(10),YEAR(@v_end_date),10),3,4)+ '00001'
              SET @v_billno  = ISNULL(@pextra1,'') + SUBSTRING (CONVERT (VARCHAR(10),YEAR(@v_end_date),10),3,4)+ '00001'
        END
        ELSE
        BEGIN
           
           
             
                    DECLARE @VBILLNO11     VARCHAR(50)
            
                    SELECT @VBILLNO11 = dbo.fnPadLeft('0',7,convert(int,@v_billno)+1) 
                     
          
                    --SET @v_billno = /*@punit_code*/'CIRI' + @VBILLNO11
                      SET @v_billno = ISNULL(@pextra1,'') + @VBILLNO11
               
            
        END
  
       
        return @v_billno

    END


/////////////////////////////////////////////////////////////END////////////////////////////////////////////


//////////////////////////////////add by Deepika 20/05/2013 sent by sushil sir///////////////////////////////





create PROCEDURE [dbo].[cir_agency_billwise_statement]

@pcompcode varchar(20),
@punitcode varchar(20),
@ppcentcode varchar(20),
@pagcd varchar(30),
@pdpcd varchar(30),
@pfrom_date datetime,
@ptill_date datetime,
@prcpt_upto datetime,
@pdateformat varchar(20),
@preptype varchar(20),--complete bills or outstanding bills(Y/N)
@pdist_code varchar(50),
@preg_code varchar(50),
@pcatcode varchar(20),
@pextra1 varchar(20),
@pextra2 varchar(20)

AS

declare  @v_frdt as datetime
declare  @v_todt as datetime
declare  @vrct_upto as datetime
declare  @v_rec_bill_amt  as   decimal(15,2)
declare @v_adjamt      as   decimal(15,2)
declare @v_dbamt      as   decimal(15,2)
declare @v_agcity as varchar(200); 
-- cursor c1 variables
declare @v1_comp_code as varchar(30)
declare @v1_unit_code as varchar(20)
declare @v1_agency_name as varchar(200)
declare @v1_city_code as varchar(20)
declare @v1_billno as varchar(30)
declare @v1_billdt as datetime
declare @v1_agcd as varchar(50)
declare @v1_dpcd as varchar(50)
declare @v1_amount as decimal(15,2)
--cursor c2---
declare @v2_doctype as varchar(30)
declare @v2_recptno as varchar(50)
declare @v2_recptdt as datetime
declare @v2_rec_amount   as decimal(15,2)
DECLARE @V1_ADDR as varchar(200)
-----------------------
set @v_frdt= @pfrom_date
set @v_todt= @ptill_date
set @vrct_upto= @prcpt_upto

declare c1 cursor for SELECT DISTINCT a.comp_code comp_code, a.unit_code, b.Ag_Name agency_name, b.City_Code city_code,
                                      a.billno billno, a.billdt billdt, a.agcd agcd, a.dpcd dpcd,
                                      a.bill_amount amount, b.addr1+' '+b.addr2+' '+b.addr3+' '+b.dist_code  as addr
			            FROM cir_bill a, cir_agmast b
			              WHERE a.Comp_Code = b.comp_code 
			                AND a.unit_code = b.unit
			                AND a.AGCD      = b.agcd
			                AND a.dpcd      = b.dpcd
			                AND	a.billdt    >= @v_frdt 
			                AND	a.billdt    <= @v_todt
			                AND	a.agcd      = ISNULL(@pagcd, a.agcd)
			                AND	a.dpcd      = ISNULL(@pdpcd,  a.dpcd)
			                --AND	(b.region   = @preg_code  OR @preg_code  is null)
			               -- AND	(b.Dist_Code  = @pdist_code OR	@pdist_code  is null)
			                AND	ISNULL(a.bill_amount, 0)  > 0 
			                AND	ISNULL(@preptype, 'N')  = 'Y' --for complete bills
		              union
			          SELECT DISTINCT a.comp_code comp_code, a.unit_code, b.Ag_Name agency_name, b.City_Code city_code,
                                      a.billno billno, a.billdt billdt, a.agcd agcd, a.dpcd dpcd,
                                      a.bill_amount amount, b.addr1+' '+b.addr2+' '+b.addr3+' '+b.dist_code  as addr
			            FROM cir_bill a, cir_agmast b
			              WHERE a.Comp_Code = b.comp_code 
			                AND a.unit_code = b.unit
			                AND a.AGCD      = b.agcd
			                AND a.dpcd      = b.dpcd
			                AND	a.billdt    >= @v_frdt 
			                AND	a.billdt    <= @v_todt
			                AND	a.agcd      = ISNULL(@pagcd, a.agcd)
			                AND	a.dpcd      = ISNULL(@pdpcd,  a.dpcd)
			                --AND	(b.region   = @preg_code  OR @preg_code  is null)
			                AND	(b.Dist_Code  = @pdist_code OR	@pdist_code  is null)
			                AND	ISNULL(a.bill_amount, 0)  > 0 
			                AND	ISNULL(@preptype, 'N')  = 'N' 
                            AND	ISNULL(a.bill_amount, 0)  > 0
			                AND	a.comp_code + CAST(a.billdt AS VARCHAR(20)) + a.billno  in (SELECT CAST(o.comp_code AS VARCHAR) + CAST(o.billdt AS VARCHAR) + CAST(o.billno AS VARCHAR) FROM  cir_outmast o  
			                                                                                 WHERE o.comp_code = a.comp_code
			                                                                                   AND o.agcd      = a.agcd
			                                                                                   AND o.dpcd      = a.dpcd
                                                                                               AND o.billdt    = a.billdt 
                                                                                               AND o.billno    = a.billno 
                                                                                               and isnull(o.recptdt,o.billdt)<=@vrct_upto
			                                                                                 GROUP BY o.comp_code, o.billno, o.billdt 
			                                                                                 HAVING SUM(CONVERT(FLOAT, o.amount)) > 0)
			
			             ORDER BY a.comp_code, a.unit_code, a.agcd, a.dpcd, a.billdt, a.billno 	
print 'a'
CREATE TABLE #TEMP_AD_RECEIPT_REPORT
(
  COMP_CODE         VARCHAR(10),
  UNIT_CODE         VARCHAR(10),
  BRANCH_CODE       VARCHAR(10),
  AGCD              VARCHAR(50),
  DPCD              VARCHAR(50),
  RECPTNO           VARCHAR(50),
  RECPTDT           DATEtime,
  AMOUNT            decimal(14,2),
  REMARKS           VARCHAR(500),
  CHQNO             VARCHAR(50),
  CHQDT             DATEtime,
  CHQ_BANK          VARCHAR(100),
  REASON            VARCHAR(30),
  BILLNO            VARCHAR(50),
  BILLDT            DATEtime,
  BILLAMT           decimal(14,2),
  ADJAMT            decimal(14,2),
  LEFTAMT           decimal(14,2),
  EXE_CODE          VARCHAR(200),
  SESS_ID           decimal(10),
  DEBIT_HEAD        VARCHAR(200),
  CREDIT_HEAD       VARCHAR(200),
  DOCTYPE           VARCHAR(10),
  REC_SEQNO         decimal(10),
  RECOVARY_DAYS     decimal(5),
  AGNAME            VARCHAR(500),
  INSDATE           DATEtime,
  NARR_LINE         decimal(3),
  ADDR              VARCHAR(200)
)
print 'b'
declare @v_rec_seqno as int
declare @v_dsign     as int
print 'c'
set @v_rec_seqno=0
set @v_dsign=0
print 'd'
open c1
		        
		fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_agency_name,@v1_city_code,@v1_billno,@v1_billdt,@v1_agcd,@v1_dpcd,@v1_amount,@V1_ADDR
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
		print 'e'
			set @v_rec_seqno=isnull(@v_rec_seqno,0)+1;
			print('hi')
			
			set @v_agcity    =[dbo].[cir_city](@v1_comp_code,@v1_city_code, '1', 'mm/dd/yyyy', '', '')

			insert into #temp_ad_receipt_report (comp_code, unit_code, agcd, dpcd, doctype, 
			                                     recptno, recptdt, amount, billno, billdt,
			                                     billamt, adjamt, leftamt, rec_seqno, exe_code, 
			                                     chqno, chqdt, agname, credit_head, addr)
			                             values (@v1_comp_code, @v1_comp_code, @v1_agcd, @v1_dpcd, 'BIL',
			                                     null, null, null, @v1_billno, @v1_billdt,
			                                     @v1_amount, null, @v1_amount, @v_rec_seqno, null,
			                                     null, null, @v1_agency_name, @v_agcity, @V1_ADDR);

			set @v_rec_bill_amt=isnull(@v1_amount,0);

			declare c2 cursor for select doctyp, recptno, recptdt, amount rec_amount from cir_outmast
						             where comp_code = @v1_comp_code 
						               and agcd      = @v1_agcd 
						               and dpcd      = @v1_dpcd 
						               and billdt    = @v1_billdt 
						               and recptdt  <= @vrct_upto 
						               and billno    = @v1_billno 
						             order by recptdt,recptno

			open c2	fetch NEXT FROM c2 INTO @v2_doctype, @v2_recptno, @v2_recptdt, @v2_rec_amount
					  WHILE (@@FETCH_STATUS = 0) 
					BEGIN
						set @v_rec_seqno=isnull(@v_rec_seqno,0)+1;
						 select @v_dsign=Dsign from cir_docmst 
						  where Comp_code=@v1_comp_code 
						    and doc_type=@v2_doctype
						if @v_dsign=-1 begin
						insert into #temp_ad_receipt_report	(comp_code, unit_code, agcd, dpcd, doctype,
						                                     recptno, recptdt, amount, billno, billdt,
						                                     billamt, adjamt, leftamt, rec_seqno, agname,
						                                     credit_head, ADDR)
						                             values (@v1_comp_code, @v1_unit_code, @v1_agcd, @v1_dpcd, @v2_doctype,
						                                     @v2_recptno, @v2_recptdt, @v2_rec_amount, null, null,
						                                     isnull(@v2_rec_amount,0),0, 0, @v_rec_seqno,	@v1_agency_name,
						                                     @v_agcity, @V1_ADDR);
						
						set @v_rec_bill_amt=isnull(@v_rec_bill_amt,0)+isnull(@v2_rec_amount,0);
						set @v_adjamt      =isnull(@v_adjamt,0)+isnull(@v2_rec_amount,0);
					end
					else  
					begin
						insert into #temp_ad_receipt_report (comp_code, unit_code, agcd, dpcd, doctype,
						                                     recptno, recptdt, amount, billno, billdt,
						                                     billamt, adjamt, leftamt, rec_seqno, agname,
						                                     credit_head, ADDR)
						                             values (@v1_comp_code, @v1_unit_code, @v1_agcd, @v1_dpcd, @v2_doctype,
						                                     @v2_recptno, @v2_recptdt, @v2_rec_amount, @v1_billno,@v1_billdt,
						                                     isnull(@v2_rec_amount,0), null, 0, @v_rec_seqno, @v1_agency_name,
						                                     @v_agcity, @V1_ADDR);
						set @v_rec_bill_amt=isnull(@v_rec_bill_amt,0)+isnull(@v2_rec_amount,0);
						set @v_adjamt      =0
						end

					fetch NEXT FROM c2 INTO @v2_doctype,@v2_recptno,@v2_recptdt,@v2_rec_amount
					end
			close c2;		
		deallocate c2
		   update #temp_ad_receipt_report set adjamt=@v_adjamt, leftamt=isnull(leftamt,0)+isnull(@v_adjamt,0)
            where comp_code=@v1_comp_code 
              and doctype='BIL' 
              and billno=@v1_billno 
              and billdt=@v1_billdt;
      
        set @v_rec_bill_amt=0;
		set @v_adjamt=0;	
		set @v1_agcd=null
		set @v_agcity=null

		fetch NEXT FROM c1 INTO @v1_comp_code,@v1_unit_code,@v1_agency_name,@v1_city_code,@v1_billno,@v1_billdt,@v1_agcd,@v1_dpcd, @v1_amount, @V1_ADDR
		end
close c1;

select distinct a.comp_code as COMP_CODE,a.unit_code as UNIT,
case @pdateformat
when 'mm/dd/yyyy' then convert(varchar(10),a.recptdt,101)
when 'dd/mm/yyyy' then convert(varchar(10),a.recptdt,103)
when 'yyyy/mm/dd' then convert(varchar(10),a.recptdt,111) end
 as RECEIPT_DATE,
a.recptno as RECEIPT_NUMBER,a.doctype as DOCTYPE,
a.agcd as AGENCY_CODE,a.dpcd as AGENCY_SUB_CODE,
a.agname as AGENCY_NAME,substring(a.credit_head,1,100) as CITY_NAME,
abs(a.amount) as REC_AMOUNT,
(select Comp_Name from comp_mst where Comp_Code=a.comp_code)  as CNAME,
a.billno,a.billdt,a.billamt,abs(a.adjamt) adjamt,a.leftamt leftamt,a.rec_seqno rec_seqno,
a.chqno ronum,
a.chqdt rodate,
ADDR
from #temp_ad_receipt_report a
ORDER BY AGENCY_NAME,a.billdt,a.billno,a.rec_seqno

select distinct a.comp_code as COMP_CODE,a.unit_code as UNIT, a.agcd as AGENCY_CODE,
(select Comp_Name from comp_mst where Comp_Code=a.comp_code)  as CNAME,
a.dpcd as AGENCY_SUB_CODE,a.debit_head as AGENCY_NAME,
count(*) agrec_count
from #temp_ad_receipt_report a where 1=2
group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.debit_head
ORDER BY AGENCY_NAME;

deallocate c1


////////////////////////////////////////////////////end//////////////////////////////////

/***23 may*****/
--EXEC cir_interest_on_overdue_bill 'TN001','WIN','04/04/2013',NULL,'B0001','0030',18,60,'Y','AD01','MM/DD/YYYY','','','','',''
--EXEC cir_interest_on_overdue_bill 'TN001','WIN','04/30/2013',NULL,null,null,18,60,'Y','AD01','MM/DD/YYYY','','','','',''

ALTER procedure [dbo].[cir_interest_on_overdue_bill](
    @pcomp_code          as varchar(20),
    @punit_code          as varchar(20),
    @pason_date          as datetime,
    @pagency_type        as varchar(20),
    @pagmain_code        as varchar(20),
    @pagsub_code         as varchar(20),
    @pint_rate           as numeric(12,2),
    @poverdue_days       as numeric(10),
    @pposting_req        as varchar(20),--Y for Posting & N for no posting
    @puserid             as varchar(20),
    @pdateformat         as varchar(20),
    @pextra1             as varchar(200),
    @pextra2             as varchar(200),
    @pextra3             as varchar(200),
    @pextra4             as varchar(200),
    @pextra5             as varchar(200))
As
    declare @v_cnt            int
    --declare @v_ason_dt        datetime;
    declare @v_userid         varchar(20);
    declare @v_days           numeric(10);
   
    declare c_agency cursor for select Comp_Code comp_code, agcd agency_code, dpcd agency_sub_code, ag_name agency_name, City_Code city_code,
                                       isnull((select "City_Name" from city_mst
                                                  where "Comp_Code" = cir_agmast.Comp_Code
                                                     and City_Code=cir_agmast.City_Code),'Not Define') city_name,
                                       Credit_Days credit_days from cir_agmast
                                    where "Comp_Code"=@pcomp_code
                                        and ((agcd=@pagmain_code) or (@pagmain_code is null))
                                        and ((dpcd=@pagsub_code) or (@pagsub_code is null))
                                        and ((ag_type=@pagency_type) or (@pagency_type is null));
   
 declare @v_agency_comp_code        varchar(20)
 declare @v_agency_agency_code        varchar(20)
 declare @v_agency_agency_sub_code    varchar(20)
 declare @v_agency_agency_name        varchar(500)
 declare @v_agency_city_code        varchar(50)
 declare @v_agency_city_name        varchar(100)
 declare @v_agency_credit_days        as numeric(10)


declare @v_pub_center    varchar(50);
declare @v_recptno        varchar(50);
declare @v_vchno        varchar(50);
declare @v_doctype        varchar(10);
declare @v_remark        VARCHAR(500);
declare @v_pprocessdt   DATETIME;
declare @p_pprocessdt   varchar(30);
declare @v_prefix        varchar(30);
declare @v_branchnm        varchar(20);
declare @v_reason        varchar(20);
declare @v_dr_cdp        varchar(20);
declare @v_cr_cdp        varchar(20);
declare @rec_intt_comp_code        varchar(50)
declare @rec_intt_bran_code        varchar(50)
declare @rec_Publ        varchar(50)
   
begin

    --set @p_pprocessdt = convert(varchar(10),getdate(),101)
   
    --set @v_pprocessdt= @p_pprocessdt;
   
    set @v_pprocessdt = @pason_date

    print('@v_pprocessdt')print(@p_pprocessdt)
    set @v_remark    = 'Interest Invoice ';
    set @v_doctype   = 'INI';
    set @v_reason    = 'IN0';--Interest Invoice


    open c_agency;
        FETCH NEXT FROM c_agency INTO  @v_agency_comp_code , @v_agency_agency_code,@v_agency_agency_sub_code,@v_agency_agency_name,
            @v_agency_city_code,@v_agency_city_name,@v_agency_credit_days
        WHILE (@@FETCH_STATUS = 0) BEGIN

        print('@v_agency_agency_code ')print(@v_agency_agency_code)print(@v_agency_agency_sub_code)

       
            --select distinct @v_branchnm= substring(isnull("Branch_Alias","Branch_Name"),1,3)  from branch_mst
            --where "Comp_Code"=@rec_intt_comp_code and "Branch_Code"=@rec_intt_bran_code
           
            --set @v_prefix  = @v_doctype + '/' +   @v_branchnm + '/' + replace(CONVERT(VARCHAR(5), @v_pprocessdt, 11) ,'/','-')+ '/'
            --set @v_prefix  = @v_doctype + replace(CONVERT(VARCHAR(2), @v_pprocessdt, 11) ,'/','-')
            --set @v_recptno  = dbo.ad_genreceiptno( @rec_intt_comp_code, @v_prefix, null, @v_doctype, @p_pprocessdt, 'mm/dd/yyyy', 'F')           
       
             

        declare @v_bill_comp_code    varchar(100);
        declare @v_bill_billno       varchar(100);
        declare @v_bill_billdt       datetime;
        declare @v_bill_bill_amt     numeric(18,2);
        declare @v_intt_amt          numeric(18,2);
        declare @v_bill_unit         varchar(20);
         
         declare  c_bill cursor for
                select distinct x.comp_code, x.publ, x.billno, x.billdt as billdt, sum(x.bill_amt) bill_amt,
                                b.unit_Code from (select distinct comp_code, publ, billno, billdt as billdt, sum(amount) bill_amt from cir_outmast
                                                 where comp_code              = @pcomp_code
                                                  and (unit_Code              = isnull(@punit_code,unit_code) or @punit_code='')
                                                  and  agcd                   = @v_agency_agency_code
                                                  and  dpcd                   = isnull(@v_agency_agency_sub_code,dpcd)
                                                  and  billdt                <= @pason_date
                                                  and isnull(recptdt,billdt) <= @pason_date
                                                 group by comp_code, publ,billno,billdt having sum(amount)>0
                                             union
                                             select distinct comp_code, publ, recptno billno, recptdt billdt, sum(amount) bill_amt from cir_outmast
                                                 where comp_code = @pcomp_code
                                                  and (unit_code = isnull(@punit_code,unit_Code) or @punit_code='')
                                                  and  agcd      = @v_agency_agency_code
                                                  and  dpcd      = isnull(@v_agency_agency_sub_code, dpcd)
                                                  and  recptdt  <= @pason_date and isnull(amount,0)>0
                                                  and (billno is null or billno='')
                                                 group by comp_code, publ,recptno,recptdt having sum(amount)>0) x, cir_bill b
                where x.comp_code=b.comp_code and x.billdt=b.billdt and x.billno=b.billno and
                not exists (select 'x' from CIR_interest_bill_detail d
                              where d.comp_code=b.comp_code
                                and d.billdt=b.billdt
                                and d.billno=b.billno)
                group by x.comp_code,x.publ, x.billno,x.billdt,b.unit_code
                order by x.billdt,x.billno;
           print('open c_bill') print(@pcomp_code)print(@punit_code)print(@v_agency_agency_code)print(@pason_date)
        open c_bill;
            FETCH NEXT FROM c_bill INTO @v_bill_comp_code, @rec_publ, @v_bill_billno,@v_bill_billdt,@v_bill_bill_amt,@v_bill_unit;
            WHILE (@@FETCH_STATUS = 0) BEGIN
            print('@@v_bill_billno ')print(@v_bill_billno)print(@v_bill_bill_amt)print(@v_bill_billdt)print(@pason_date)
             if SUBSTRING((isnull(@v_bill_billno,'?')),1,4) = 'OLDI'
                BEGIN
                   set @v_days = '60'
                END
             else
                BEGIN
                   set @v_days=DATEDIFF(dd, DBO.GetLastDayOfMonth(@v_bill_billdt),@pason_date )- isnull(@v_agency_credit_days,0)+1;
                END
            print('v_days')print(@v_days)
            if @v_days<0 begin
              set @v_days=0;
            end
       
        if @v_days >=isnull(@poverdue_days,0) begin
       
            set @v_intt_amt  =round((isnull(@v_bill_bill_amt,0)*@pint_rate*@v_days)/(100*365),2);
            if isnull(@v_intt_amt,0) > 0
               begin
                    insert into cir_interest_bill_detail (comp_code, bran_code, agcd, dpcd, billno,
                                                          billdt, bill_osamt, bill_ason, intt_rate, intt_amt,
                                                          intt_days, credit_days, overdue_days, post_flag, created_by,
                                                          created_dt, int_date,  int_doc_type, int_doc_no)
                                                  values (@v_agency_comp_code, @v_bill_unit, @v_agency_agency_code, @v_agency_agency_sub_code, @v_bill_billno,
                                                          @v_bill_billdt, @v_bill_bill_amt, @pason_date, @pint_rate, @v_intt_amt,
                                                          @v_days, @v_agency_credit_days, @poverdue_days, 'N', @puserid,
                                                          getdate(), @v_pprocessdt, @v_doctype,@v_recptno);
               end
        end
       
        set @v_days=0;
        set @v_bill_bill_amt =0;
        set @v_bill_comp_code=null;
        set @v_bill_billno   =null;
        set @v_bill_billdt   =null;
        set @v_intt_amt      =0;
            FETCH NEXT FROM c_bill INTO @v_bill_comp_code,@v_bill_billno,@v_bill_billdt,@v_bill_bill_amt,@v_bill_unit;
        end
        close c_bill;
        deallocate c_bill;
       

       FETCH NEXT FROM c_agency INTO  @v_agency_comp_code , @v_agency_agency_code,@v_agency_agency_sub_code,@v_agency_agency_name,
            @v_agency_city_code,@v_agency_city_name,@v_agency_credit_days
    end
    close c_agency;
    deallocate c_agency;



    begin
        select distinct @v_dr_cdp=dr_cdp,@v_cr_cdp=cr_cdp
            from fa_fin_link_mast
        where comp_code         = @pcomp_code
            and unit_code      = 'ALL'
            and branch_code    = 'ALL'
            and modual_alias   = 'ADCOLL'
            and doctype        = @v_doctype
            and reason_paymode = @v_reason
            and @v_pprocessdt between eff_fr_date and eff_to_date;
              
    end
   

    declare @rec_intt_ag_main_code    varchar(50)
    declare @rec_intt_ag_sub_code    varchar(50)
    declare @rec_intt_intt_rate        numeric(12,2)
    declare @rec_intt_amount        numeric(18,2)
    declare @rec_intt_region        varchar(50)   

    declare cur_intt cursor for select d.comp_code, d.bran_code, d.agcd, d.dpcd, d.intt_rate,
                                       sum(d.intt_amt) amount, '' region from cir_interest_bill_detail d, cir_Agmast m
                                   where d.comp_code = m.Comp_Code
                                     and d.agcd      = m.agcd
                                     and d.dpcd      = m.dpcd
                                     and d.post_flag = 'N'
                                     --and created_dt=getdate()
                                   group by d.comp_code ,d.bran_code ,d.agcd ,d.dpcd, d.intt_rate;

   
    open cur_intt;
        FETCH NEXT FROM cur_intt INTO @rec_intt_comp_code, @rec_intt_bran_code, @rec_intt_ag_main_code, @rec_intt_ag_sub_code, @rec_intt_intt_rate ,@rec_intt_amount, @rec_intt_region
           WHILE (@@FETCH_STATUS = 0) BEGIN
             set @v_cnt=isnull(@v_cnt,0)+1;
         
            select @v_vchno  =  MAX(voucherno) FROM  cir_rcphdr
              WHERE comp_code  = @rec_intt_comp_code
               AND  doctype  = @v_doctype
               AND    replace(CONVERT(VARCHAR(5), recptdt, 11) ,'/','')  = replace(CONVERT(VARCHAR(5), @v_pprocessdt, 11) ,'/','')
           
            IF (@v_vchno is null or @v_vchno = '0' )
            BEGIN
                set @v_vchno  = replace(CONVERT(VARCHAR(5), @v_pprocessdt, 11) ,'/','')+ '0001'
            END
            ELSE
            BEGIN
                if( len(cast(@v_vchno as int))=1)
                    set @v_vchno='0000000'+@v_vchno
                if( len(cast(@v_vchno as int))=2)
                    set @v_vchno='000000'+@v_vchno
                if( len(cast(@v_vchno as int))=3)
                    set @v_vchno='00000'+@v_vchno
                if( len(cast(@v_vchno as int))=4)
                    set @v_vchno='0000'+@v_vchno
                if( len(cast(@v_vchno as int))=5)
                    set @v_vchno='000'+@v_vchno
                if( len(cast(@v_vchno as int))=6)
                    set @v_vchno='00'+@v_vchno
                if( len(cast(@v_vchno as int))=7)
                    set @v_vchno='0'+@v_vchno
                else
                    set @v_vchno=@v_vchno
            END         
         
            Begin
                select distinct @v_pub_center = pub_center  from branch_mst
                    where Comp_Code   = @rec_intt_comp_code
                      and Branch_Code = @rec_intt_bran_code;
 
            End;
              if isnull(@rec_intt_amount,0) > 0
                 begin
                      set @v_recptno  = [dbo].[cir_generate_intbillno] (  @rec_intt_comp_code, @v_pub_center, 'INI', @v_pprocessdt,'mm/dd/yyyy','INTI', '')     
                        /*PRINT '@v_recptno'
                        PRINT @v_recptno
                        print '@v_recptno'
                        print @v_recptno    
                        --set @v_recptno='eeeee'
                        print @rec_intt_comp_code
                        print @puserid
                        print @rec_intt_bran_code
                        print @v_doctype
                        print @v_recptno
                        print @v_pprocessdt
                        print @v_reason
                        print @rec_intt_amount
                        print @v_remark
                        print @v_vchno
                        print @v_pprocessdt
                        print @rec_intt_ag_main_code
                        print @rec_intt_ag_sub_code
                        print @v_dr_cdp
                        print @v_cr_cdp
                        print @v_pub_center*/
                    insert into cir_rcphdr (comp_code, userid, branch_code, doctype, recptno,
                                            recptdt, reason, amount, oth_amount, chno,
                                            chdt, chbank, remark, received_from, voucherno,
                                            voucherdt, agcd, dpcd, ccdp, rcdp,
                                            unit_Code)
                                    values (@rec_intt_comp_code, @puserid, @rec_intt_bran_code, @v_doctype, @v_recptno,
                                            @v_pprocessdt, @v_reason, @rec_intt_amount, null, null,
                                            null , null , @v_remark, null, @v_vchno,
                                            @v_pprocessdt, @rec_intt_ag_main_code, @rec_intt_ag_sub_code, @v_dr_cdp, @v_cr_cdp,
                                            @v_pub_center);
                                  
                    insert into cir_rcpdet (comp_code, usrid, branch_code, doctyp, recptno,
                                            recptdt, reason, voucherno, voucherdt, amount,
                                            chno, chdt, chbnk, remark, agcd,
                                            dpcd, unit_code)
                                    values (@rec_intt_comp_code, @puserid, @rec_intt_bran_code, @v_doctype, @v_recptno,
                                            @v_pprocessdt, @v_reason, @v_vchno, @v_pprocessdt, @rec_intt_amount,
                                            null, null, null, @v_remark, @rec_intt_ag_main_code,
                                            @rec_intt_ag_sub_code, @v_pub_center);

                   insert into cir_outmast (comp_code, usrid, branch_Code, doctyp, recptno,
                                            recptdt, reason, voucherno, voucherdt, amount,
                                            chno, chdt, chbnk, remark, agcd,
                                            dpcd, unit_code,publ)
                                    values (@rec_intt_comp_code, @puserid, @rec_intt_bran_code, @v_doctype, @v_recptno,
                                            @v_pprocessdt, @v_reason, @v_vchno, @v_pprocessdt, 0,
                                            null ,null ,null,@v_remark, @rec_intt_ag_main_code,
                                            @rec_intt_ag_sub_code, @v_pub_center, @rec_publ);
                --------debit note as billno allocate
                   insert into cir_outmast (comp_code, branch_code, doctyp, reason , billno,
                                            billdt, recptno, recptdt, chno, chdt,
                                            chbnk, voucherno, voucherdt, amount, usrid,
                                            agcd, dpcd, remark, unit_Code, publ)
                                      values(@rec_intt_comp_code, @rec_intt_bran_code, @v_doctype, @v_reason, @v_recptno,
                                             @v_pprocessdt, @v_recptno, @v_pprocessdt, null, null,
                                             null, @v_vchno, @v_pprocessdt, abs(@rec_intt_amount), @puserid,
                                             @rec_intt_ag_main_code, @rec_intt_ag_sub_code, @v_remark, @v_pub_center, @rec_publ);
   
                   update cir_interest_bill_detail set post_flag = 'Y', int_Doc_no = @v_recptno
                        where comp_code = @rec_intt_comp_code
                          and bran_code = @rec_intt_bran_code
                          and agcd      = @rec_intt_ag_main_code
                          and dpcd      = @rec_intt_ag_sub_code
                          and post_flag = 'N'
                          --and created_dt=GETDATE();
       
       
               end
           
        FETCH NEXT FROM cur_intt INTO @rec_intt_comp_code , @rec_intt_bran_code ,@rec_intt_ag_main_code ,@rec_intt_ag_sub_code ,
            @rec_intt_intt_rate ,@rec_intt_amount,@rec_intt_region
    end
    close cur_intt;
    deallocate cur_intt;
   
    select getdate() as "CUR_DATE";
   

End

/////////////////////add by Deepika 27-may  sent by Sushil Sir//////////////////////

ALTER PROCEDURE [dbo].[binddoc_no]
@pcompcode    as varchar(20),
@ext          as varchar(50),
@doctype      as varchar(10),
@agcd         as varchar(10),
@dpcd         as varchar(10),
@extra1       as varchar(10),
@extra2       as varchar(10)

as

	begin
		select  int_doc_no, int_date from ad_interest_bill_detail
		  where Comp_Code=@pcompcode 
		    and INT_DOC_TYPE= @doctype 
		    and ((AG_MAIN_CODE=@agcd )or(@agcd='')or(@agcd=null))
		    and ((AG_SUB_CODE=@dpcd)or (@agcd='')or(@agcd=null))
		    and int_doc_no like '%' +@ext+ '%'
		union
		select  int_doc_no, int_date from CIR_INTEREST_BILL_DETAIL
		  where Comp_Code=@pcompcode 
		    and INT_DOC_TYPE= @doctype 
		    and ((AGCD=@agcd )or(@agcd='')or(@agcd=null))
		    and ((DPCD=@dpcd)or (@agcd='')or(@agcd=null))
		    and int_doc_no like '%' +@ext+ '%'
		order by int_date, int_doc_no

	end
	
	



create procedure [dbo].[cir_rep_interest_invoice](
    @pcomp_code          as varchar(200),
    @punit_code          as varchar(200),
    @pagency_type        as varchar(200),
    @pagmain_code        as varchar(200),
    @pagsub_code         as varchar(200),
    @pfrom_date          as datetime,
    @ptill_date          as datetime,
    @pfrom_rcpno         as varchar(200),
    @ptill_rcpno         as varchar(200),
    @puserid             as varchar(200),
    @pdateformat         as varchar(20),
    @pextra1             as varchar(200),
    @pextra2             as varchar(200),
    @pextra3             as varchar(200),
    @pextra4             as varchar(200),
    @pextra5             as varchar(200))
As

begin

    select i.comp_code , i.bran_code ,i.agcd ,i.dpcd,
           a.ag_name agency_name,(select city_name from cir_city_mast where "Comp_Code"=i.comp_code and "City_Code"=a."City_Code") city_name,
           i.billno, i.billdt, i.bill_osamt, DBO.GetLastDayOfMonth(i.billdt)+i.credit_days due_date,
           i.intt_rate ,i.intt_amt ,i.intt_days, i.credit_days,
           i.overdue_days, i.int_date , i.int_doc_type , i.int_doc_no,a.Addr1,a.Addr2,(select country_name from count_mst where Country_Code=a.country_code) as country_name
    from cir_interest_bill_detail i,cir_agmast a,cir_rcphdr h
    where  i.comp_code    = h."comp_code" 
      and  i.int_doc_type = h."doctype" 
      and  i.int_doc_no   = h."recptno" 
      and  i.int_date=h."recptdt" 
      and  i.comp_code    = a."Comp_Code"
      and  i.agcd = a.agcd 
      and  i.dpcd  = a.dpcd
      and  i.comp_code    = @pcomp_code 
      and (i.bran_code=isnull(@punit_code,i.bran_code) or @punit_code='') 
      and ((i.int_doc_no between @pfrom_rcpno and @ptill_rcpno) or @pfrom_rcpno is null or @pfrom_rcpno='' or @ptill_rcpno is null or @ptill_rcpno='')
      and  i.int_date between @pfrom_date and @ptill_date
      and (i.agcd  = isnull(@pagmain_code,i.agcd) or @pagmain_code='')
      and (i.agcd   = isnull(@pagsub_code,i.agcd) or @pagsub_code='')
      and (a.AGEING_TYPE =@pagency_type or @pagency_type is null or @pagency_type='')
    order by int_date,int_doc_no,billdt,billno;

End

//////////////////////////////////////////////////////end/////////////////////////////////////////////////



///////////////////////////////////////add by deepika 6/6/2013 sent by shushil sir ///////////////////////




ALTER procedure [dbo].[cir_agent_net_sale_Detail]

(

@pcomp_code varchar(20),

@punit_code varchar(20),

@pfrdate datetime,

@ptodate datetime,
@pappr_unappr varchar(20), 
@pagcd varchar(20),

@pdpcd varchar(20),

@pdateformate varchar(20),

@pextra1 varchar(20),

@pextra2 varchar(20),

@pextra3 varchar(20),

@pextra4 varchar(20),

@pextra5 varchar(20),

@pextra6 varchar(20),

@pextra7 varchar(20),

@pextra8 varchar(20),

@pextra9 varchar(20),

@pextra10 varchar(20)) as

Begin

--exec cir_agent_net_sale_Detail 'TN001','WIN','12/17/2012','12/21/2012','O0006','0002','DD/MM/YYYY', '', '', '', '', '', '', '', '', '', ''

select x.comp_code,x.unit_code,x.publ,x.edtn,x.agcd,x.dpcd,

cir_agmast.ag_name as outlet_name,x.supdate,sum(x.delivery) delivery,sum(x.unsold) unsold,sum(x.delivery-x.unsold) sale,

round((100*sum(x.unsold)/sum(x.delivery)),2) unsold_per,

replace(isnull(cir_agmast.old_agency,'??'),'','##') old_agency_code from

(select s.comp_code,s.unit_code,s.publ,s.edtn,s.agcd,s.dpcd,s.supdate,sum(s.sup_copy) delivery,

(select CASE WHEN ISNULL(@pappr_unappr, '?')='A' THEN
                isnull(sum(isnull(u.apr_short_recpt,0)+isnull(u.apr_late_recpt,0)+isnull(u.apr_bnr,0)+isnull(u.apr_unsold,0)),0) 
			 ELSE
			    isnull(sum(isnull(u.short_recpt,0)+isnull(u.late_recpt,0)+isnull(u.bnr,0)+isnull(u.unsold,0)),0) 
			 END AS unsold from cir_unsold_dtl u

where u.comp_code = s.comp_code

and u.unit_code = s.unit_code

and u.agcd = s.agcd

and u.dpcd = s.dpcd

and u.supdate = s.supdate) unsold

from cir_dbksup s

where s.comp_code = @pcomp_code

and s.unit_code = @punit_code

and s.sup_type_code in (select sup_ty_code from CIR_SUPPLY_TYPE_MAST where comp_code = s.comp_code and bill_pay = 'Y')

and s.supdate between @pfrdate and @ptodate

and ((s.agcd = @pagcd) or (@pagcd is null) or (@pagcd=''))

and ((s.dpcd = @pdpcd) or (@pdpcd is null) or (@pdpcd=''))

--and @pdpcd='0001'

group by s.comp_code,s.unit_code,s.publ,s.edtn,s.agcd,s.dpcd,s.supdate) x, cir_agmast

where x.comp_code = cir_agmast.comp_code

and x.unit_code = cir_agmast.unit

and x.agcd = cir_agmast.agcd

and x.dpcd = cir_agmast.dpcd

and isnull(cir_agmast.to_bill,'N') = 'Y'

group by x.comp_code,x.unit_code,x.publ,x.edtn,x.agcd,x.dpcd,cir_agmast.ag_name,x.supdate, cir_agmast.old_agency

having sum(x.delivery)>0

order by x.comp_code,x.unit_code,x.publ,x.edtn,x.agcd,x.dpcd

select UNS.RECPTNO AS RECPTNO, UNS.RECPTDT AS RECPTDT, UNS.SUPDATE AS SUPDATE,
             CASE WHEN ISNULL(@pappr_unappr, '?')='A' THEN
                isnull(sum(isnull(UNS.apr_short_recpt,0)),0) 
			 ELSE
			    isnull(sum(isnull(UNS.short_recpt,0)),0) 
			 END AS SHORT_RECPT,
			 CASE WHEN ISNULL(@pappr_unappr, '?')='A' THEN
                isnull(sum(isnull(UNS.apr_late_recpt,0)),0) 
			 ELSE
			    isnull(sum(isnull(UNS.late_recpt,0)),0) 
			 END AS LATE_RECPT,
			 CASE WHEN ISNULL(@pappr_unappr, '?')='A' THEN
                isnull(sum(isnull(UNS.apr_bnr,0)),0) 
			 ELSE
			    isnull(sum(isnull(UNS.bnr,0)),0) 
			 END AS BNR,
			 CASE WHEN ISNULL(@pappr_unappr, '?')='A' THEN
                isnull(sum(isnull(UNS.apr_unsold,0)),0) 
			 ELSE
			    isnull(sum(isnull(UNS.unsold,0)),0) 
			 END AS UNSOLD,
			 CASE WHEN ISNULL(@pappr_unappr, '?')='A' THEN
                isnull(sum(isnull(UNS.apr_short_recpt,0)+isnull(UNS.apr_late_recpt,0)+isnull(UNS.apr_bnr,0)+isnull(UNS.apr_unsold,0)),0) 
			 ELSE
			    isnull(sum(isnull(UNS.short_recpt,0)+isnull(UNS.late_recpt,0)+isnull(UNS.bnr,0)+isnull(UNS.unsold,0)),0) 
			 END AS TOT_UNSOLD from cir_unsold_dtl UNS
           where UNS.comp_code = @pcomp_code
		     and UNS.unit_code = @punit_code
             and UNS.supdate between @pfrdate and @ptodate
             and UNS.agcd = @pagcd
			 and UNS.dpcd = @pdpcd
			 group by UNS.RECPTNO, UNS.RECPTDT, UNS.SUPDATE
			 order by 1,2,3

End

/////////////////////////////////////////////////////





ALTER procedure [dbo].[cir_agent_comm_process] 
(@pcomp_code   varchar(20),
 @punit_code   varchar(20),
 @pfrdate      datetime,
 @ptodate      datetime,
 @pappr_unappr varchar(20), 
 @pagcd        varchar(20),
 @pdpcd        varchar(20),
 @pdateformate varchar(20),
 @pextra1      varchar(20),-- For Old Client Code & Delivery Note Number
 @pextra2      varchar(20),-- For Agenct Report 'A' Monthly Report 'M'
 @pextra3      varchar(20),
 @pextra4      varchar(20),
 @pextra5      varchar(20),
 @pextra6      varchar(20),
 @pextra7      varchar(20),
 @pextra8      varchar(20),
 @pextra9      varchar(20),
 @pextra10     varchar(20)) as
 Begin
    If ((isnull(@pextra2,'#')='#') or (@pextra2=''))
	   Begin
	     set @pextra2 = 'A'
	   End

    --exec cir_agent_comm_process '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''
	if isnull(@pextra2,'#')='A'
	   Begin
		 select x.comp_code,x.unit_code,x.publ,x.edtn,x.agcd,x.dpcd,
		        dbo.cir_get_agency(x.comp_code,x.unit_code,x.agcd,'0001') as agent_name,
				cir_agmast.ag_name as outlet_name,sum(x.delivery) delivery,sum(x.unsold) unsold,sum(x.delivery-x.unsold) sale,
				round((100*sum(x.unsold)/sum(x.delivery)),2) unsold_per,
				case when isnull(@pextra1,'D')='O' then 
				         cast(replace(isnull(cir_agmast.old_agency,'??'),'','##') as varchar(25))
					 else
						cast((select max(form_no) from cir_unsold_hdr h
							where h.comp_code = X.comp_code
							  and h.unit_code = X.unit_code
							  and h.agcd      = X.agcd
							  and h.dpcd      = X.dpcd
							  and h.frdt      = @pfrdate
							  and h.todt      = @ptodate) as varchar(25))
					 end as old_agency_code	  from
		(select s.comp_code,s.unit_code,s.publ,s.edtn,s.agcd,s.dpcd,s.supdate,sum(s.sup_copy) delivery,
		(select CASE WHEN ISNULL(@pappr_unappr,'?')='A' THEN
		                  isnull(sum(isnull(u.apr_short_recpt,0)+isnull(u.apr_late_recpt,0)+isnull(u.apr_bnr,0)+isnull(u.apr_unsold,0)),0)
                     ELSE
					      isnull(sum(isnull(u.short_recpt,0)+isnull(u.late_recpt,0)+isnull(u.bnr,0)+isnull(u.unsold,0)),0)
					 END AS unsold from cir_unsold_dtl u
			where u.comp_code = s.comp_code
			  and u.unit_code = s.unit_code
			  and u.agcd      = s.agcd
			  and u.dpcd      = s.dpcd
			  and u.supdate   = s.supdate) unsold            
		 from cir_dbksup s
		 where s.comp_code = @pcomp_code
		   and s.unit_code = @punit_code
		   and s.sup_type_code in (select sup_ty_code from CIR_SUPPLY_TYPE_MAST where comp_code = s.comp_code and bill_pay = 'Y')
		   and s.supdate between @pfrdate and @ptodate
		   and ((s.agcd = @pagcd) or (@pagcd is null) or (@pagcd=''))
		   --and ((s.dpcd = @pdpcd) or (@pdpcd is null) or (@pdpcd=''))
		   --and @pdpcd='0001'
		group by s.comp_code,s.unit_code,s.publ,s.edtn,s.agcd,s.dpcd,s.supdate) x, cir_agmast
		where x.comp_code = cir_agmast.comp_code
		  and x.unit_code = cir_agmast.unit
		  and x.agcd      = cir_agmast.agcd
		  and x.dpcd      = cir_agmast.dpcd
		  and ((isnull(cir_agmast.to_bill,'N') = 'Y') or (cir_agmast.ag_type='AT002'))
		group by x.comp_code,x.unit_code,x.publ,x.edtn,x.agcd,x.dpcd,cir_agmast.ag_name, cir_agmast.old_agency
		having sum(x.delivery)>0
		order by x.comp_code,x.unit_code,x.publ,x.edtn,x.agcd,x.dpcd

		 select x.comp_code,x.unit_code,x.publ,x.edtn,x.agcd,'0001' dpcd,
		        sum(x.delivery) delivery,sum(x.unsold) unsold,sum(x.delivery-x.unsold) sale,
				round((100*sum(x.unsold)/sum(x.delivery)),2) unsold_per,
				0.3140*sum(x.delivery-x.unsold) AGENT_COMM,
				(sum(x.delivery-x.unsold)*(isnull((SELECT dbo.CIR_GET_UNSOLD_SLAB_PER (x.comp_code,x.unit_code,@ptodate,(round((100*sum(x.unsold)/sum(x.delivery)),2)),'DD/MM/YYYY','','')),0)))/100 UNSOLD_COMM  from
		(select s.comp_code,s.unit_code,s.publ,s.edtn,s.agcd,s.dpcd,s.supdate,sum(s.sup_copy) delivery,
		(select CASE WHEN ISNULL(@pappr_unappr,'?')='A' THEN
		                  isnull(sum(isnull(u.apr_short_recpt,0)+isnull(u.apr_late_recpt,0)+isnull(u.apr_bnr,0)+isnull(u.apr_unsold,0)),0)
                     ELSE
					      isnull(sum(isnull(u.short_recpt,0)+isnull(u.late_recpt,0)+isnull(u.bnr,0)+isnull(u.unsold,0)),0)
					 END AS
					   unsold from cir_unsold_dtl u
			where u.comp_code = s.comp_code
			  and u.unit_code = s.unit_code
			  and u.agcd      = s.agcd
			  and u.dpcd      = s.dpcd
			  and u.supdate   = s.supdate) unsold
		 from cir_dbksup s
		 where s.comp_code = @pcomp_code
		   and s.unit_code = @punit_code
		   and s.sup_type_code in (select sup_ty_code from CIR_SUPPLY_TYPE_MAST where comp_code = s.comp_code and bill_pay = 'Y')
		   and s.supdate between @pfrdate and @ptodate
		   and ((s.agcd = @pagcd) or (@pagcd is null) or (@pagcd=''))
		   --and ((s.dpcd = @pdpcd) or (@pdpcd is null) or (@pdpcd=''))
		   --and @pdpcd='0001'
		group by s.comp_code,s.unit_code,s.publ,s.edtn,s.agcd,s.dpcd,s.supdate) x, cir_agmast
		where x.comp_code = cir_agmast.comp_code
		  and x.unit_code = cir_agmast.unit
		  and x.agcd      = cir_agmast.agcd
		  and x.dpcd      = cir_agmast.dpcd
		  and ((isnull(cir_agmast.to_bill,'N') = 'Y') or (cir_agmast.ag_type='AT002'))
		group by x.comp_code,x.unit_code,x.publ,x.edtn,x.agcd
		having sum(x.delivery)>0
		order by x.comp_code,x.unit_code,x.publ,x.edtn,x.agcd
     End
	 if isnull(@pextra2,'#')='M'
	   Begin
	     create table #temp_supply_detail (comp_code   varchar(50),
		                                   unit_code   varchar(50),
										   publ        varchar(50),
										   edtn        varchar(50),
										   delivery    int,
										   unsold      int,
										   sale        int,
										   unsold_per  numeric(10,4),
										   state_code  varchar(50),
										   state_name  varchar(50),
										   city_code   varchar(50),
										   city_name   varchar(50))
      
	  
	  insert into #temp_supply_detail (comp_code, unit_code, publ, edtn, delivery,
									   unsold, sale, unsold_per, state_code, state_name, city_code,
									   city_name)
		 (select y.comp_code,y.unit_code,y.publ,y.edtn,sum(y.delivery) as delivery,sum(y.unsold) as unsold,sum(y.sale) as sale,
		        round((100*sum(y.unsold)/sum(y.delivery)),2) unsold_per,y.state_code,y.state_name,y.city_code,y.city_name from
		 (select x.comp_code,x.unit_code,x.publ,x.edtn,x.agcd,x.dpcd,
		        dbo.cir_get_agency(x.comp_code,x.unit_code,x.agcd,'0001') as agent_name,
				cir_agmast.ag_name as outlet_name,sum(x.delivery) delivery,sum(x.unsold) unsold,sum(x.delivery-x.unsold) sale,
				round((100*sum(x.unsold)/sum(x.delivery)),2) unsold_per,
				case when isnull(@pextra1,'D')='O' then 
				         cast(replace(isnull(cir_agmast.old_agency,'??'),'','##') as varchar(25))
					 else
						cast((select max(form_no) from cir_unsold_hdr h
							where h.comp_code = X.comp_code
							  and h.unit_code = X.unit_code
							  and h.agcd      = X.agcd
							  and h.dpcd      = X.dpcd
							  and h.frdt      = @pfrdate
							  and h.todt      = @ptodate) as varchar(25))
					 end as old_agency_code,
					 cir_agmast.ag_type	as ag_type,
					 cir_Agmast.STATE_CODE as state_code,
					 (select state_name from state_mst where comp_code = X.comp_code and State_Code = cir_Agmast.STATE_CODE) as STATE_NAME,
					 cir_Agmast.city_code as city_code,
					 (select city_name from cir_city_mast where comp_code = X.comp_code and city_code = cir_Agmast.city_code) as CITY_NAME from
		(select s.comp_code,s.unit_code,s.publ,s.edtn,s.agcd,s.dpcd,s.supdate,sum(s.sup_copy) delivery,
		(select CASE WHEN ISNULL(@pappr_unappr,'?')='A' THEN
		                  isnull(sum(isnull(u.apr_short_recpt,0)+isnull(u.apr_late_recpt,0)+isnull(u.apr_bnr,0)+isnull(u.apr_unsold,0)),0)
                     ELSE
					      isnull(sum(isnull(u.short_recpt,0)+isnull(u.late_recpt,0)+isnull(u.bnr,0)+isnull(u.unsold,0)),0)
					 END AS unsold from cir_unsold_dtl u
			where u.comp_code = s.comp_code
			  and u.unit_code = s.unit_code
			  and u.agcd      = s.agcd
			  and u.dpcd      = s.dpcd
			  and u.supdate   = s.supdate) unsold            
		 from cir_dbksup s
		 where s.comp_code = @pcomp_code
		   and s.unit_code = @punit_code
		   and s.sup_type_code in (select sup_ty_code from CIR_SUPPLY_TYPE_MAST where comp_code = s.comp_code and bill_pay = 'Y')
		   and s.supdate between @pfrdate and @ptodate
		   and ((s.agcd = @pagcd) or (@pagcd is null) or (@pagcd=''))
		   and s.sup_type_code not in ('S02')
		   --and ((s.dpcd = @pdpcd) or (@pdpcd is null) or (@pdpcd=''))
		   --and @pdpcd='0001'
		group by s.comp_code,s.unit_code,s.publ,s.edtn,s.agcd,s.dpcd,s.supdate) x, cir_agmast
		where x.comp_code = cir_agmast.comp_code
		  and x.unit_code = cir_agmast.unit
		  and x.agcd      = cir_agmast.agcd
		  and x.dpcd      = cir_agmast.dpcd
		  and ((isnull(cir_agmast.to_bill,'N') = 'Y'))
		group by x.comp_code,x.unit_code,x.publ,x.edtn,x.agcd,x.dpcd,cir_agmast.ag_name, cir_agmast.old_agency,cir_agmast.ag_type,cir_agmast.state_code,cir_agmast.city_code
		having sum(x.delivery)>0) y
		group by y.comp_code,y.unit_code,y.publ,y.edtn,y.state_code,y.state_name,y.city_code,y.city_name)
		
		insert into #temp_supply_detail (comp_code, unit_code, publ, edtn, delivery,
									   unsold, sale, unsold_per, state_code, state_name, city_code,
									   city_name)
		 (select y.comp_code,y.unit_code,y.publ,y.edtn,sum(y.delivery) as delivery,sum(y.unsold) as unsold,sum(y.sale) as sale,
		        round((100*sum(y.unsold)/sum(y.delivery)),2) unsold_per,'AAA','STREET SALE',y.city_code,y.city_name from
		 (select x.comp_code,x.unit_code,x.publ,x.edtn,x.agcd,x.dpcd,
		        dbo.cir_get_agency(x.comp_code,x.unit_code,x.agcd,'0001') as agent_name,
				cir_agmast.ag_name as outlet_name,sum(x.delivery) delivery,sum(x.unsold) unsold,sum(x.delivery-x.unsold) sale,
				round((100*sum(x.unsold)/sum(x.delivery)),2) unsold_per,
				case when isnull(@pextra1,'D')='O' then 
				         cast(replace(isnull(cir_agmast.old_agency,'??'),'','##') as varchar(25))
					 else
						cast((select max(form_no) from cir_unsold_hdr h
							where h.comp_code = X.comp_code
							  and h.unit_code = X.unit_code
							  and h.agcd      = X.agcd
							  and h.dpcd      = X.dpcd
							  and h.frdt      = @pfrdate
							  and h.todt      = @ptodate) as varchar(25))
					 end as old_agency_code,
					 cir_agmast.ag_type	as ag_type,
					 cir_Agmast.STATE_CODE as state_code,
					 (select state_name from state_mst where comp_code = X.comp_code and State_Code = cir_Agmast.STATE_CODE) as STATE_NAME,
					 cir_Agmast.city_code as city_code,
					 (select city_name from cir_city_mast where comp_code = X.comp_code and city_code = cir_Agmast.city_code) as CITY_NAME from
		(select s.comp_code,s.unit_code,s.publ,s.edtn,s.agcd,s.dpcd,s.supdate,sum(s.sup_copy) delivery,
		(select CASE WHEN ISNULL(@pappr_unappr,'?')='A' THEN
		                  isnull(sum(isnull(u.apr_short_recpt,0)+isnull(u.apr_late_recpt,0)+isnull(u.apr_bnr,0)+isnull(u.apr_unsold,0)),0)
                     ELSE
					      isnull(sum(isnull(u.short_recpt,0)+isnull(u.late_recpt,0)+isnull(u.bnr,0)+isnull(u.unsold,0)),0)
					 END AS unsold from cir_unsold_dtl u
			where u.comp_code = s.comp_code
			  and u.unit_code = s.unit_code
			  and u.agcd      = s.agcd
			  and u.dpcd      = s.dpcd
			  and u.supdate   = s.supdate) unsold            
		 from cir_dbksup s
		 where s.comp_code = @pcomp_code
		   and s.unit_code = @punit_code
		   and s.sup_type_code in (select sup_ty_code from CIR_SUPPLY_TYPE_MAST where comp_code = s.comp_code and bill_pay = 'Y')
		   and s.supdate between @pfrdate and @ptodate
		   and ((s.agcd = @pagcd) or (@pagcd is null) or (@pagcd=''))
		   --and ((s.dpcd = @pdpcd) or (@pdpcd is null) or (@pdpcd=''))
		   --and @pdpcd='0001'
		group by s.comp_code,s.unit_code,s.publ,s.edtn,s.agcd,s.dpcd,s.supdate) x, cir_agmast
		where x.comp_code        = cir_agmast.comp_code
		  and x.unit_code        = cir_agmast.unit
		  and x.agcd             = cir_agmast.agcd
		  and x.dpcd             = cir_agmast.dpcd
		  and cir_agmast.ag_type = 'AT002'
		group by x.comp_code,x.unit_code,x.publ,x.edtn,x.agcd,x.dpcd,cir_agmast.ag_name, cir_agmast.old_agency,cir_agmast.ag_type,cir_agmast.state_code,cir_agmast.city_code
		having sum(x.delivery)>0) y
		group by y.comp_code,y.unit_code,y.publ,y.edtn,y.state_code,y.state_name,y.city_code,y.city_name)

		
		SELECT comp_code as COMP_CODE, unit_code as UNIT_CODE, publ as PUBL, edtn as EDTN, delivery as DELIVERY,
			   unsold as UNSOLD, sale as SALE, unsold_per as UNSOLD_PER, state_code as STATE_CODE, state_name as STATE_NAME, city_code as CITY_CODE,
			   city_name as CITY_NAME 
		  FROM #temp_supply_detail
		  ORDER by comp_code,unit_code,state_code,city_code,city_name 
		
		
		 select x.comp_code,x.unit_code,x.publ,x.edtn,x.agcd,'0001' dpcd,
		        sum(x.delivery) delivery,sum(x.unsold) unsold,sum(x.delivery-x.unsold) sale,
				round((100*sum(x.unsold)/sum(x.delivery)),2) unsold_per,
				0.3140*sum(x.delivery-x.unsold) AGENT_COMM,
				(sum(x.delivery-x.unsold)*(isnull((SELECT dbo.CIR_GET_UNSOLD_SLAB_PER (x.comp_code,x.unit_code,@ptodate,(round((100*sum(x.unsold)/sum(x.delivery)),2)),'DD/MM/YYYY','','')),0)))/100 UNSOLD_COMM  from
		(select s.comp_code,s.unit_code,s.publ,s.edtn,s.agcd,s.dpcd,s.supdate,sum(s.sup_copy) delivery,
		(select CASE WHEN ISNULL(@pappr_unappr,'?')='A' THEN
		                  isnull(sum(isnull(u.apr_short_recpt,0)+isnull(u.apr_late_recpt,0)+isnull(u.apr_bnr,0)+isnull(u.apr_unsold,0)),0)
                     ELSE
					      isnull(sum(isnull(u.short_recpt,0)+isnull(u.late_recpt,0)+isnull(u.bnr,0)+isnull(u.unsold,0)),0)
					 END AS
					   unsold from cir_unsold_dtl u
			where u.comp_code = s.comp_code
			  and u.unit_code = s.unit_code
			  and u.agcd      = s.agcd
			  and u.dpcd      = s.dpcd
			  and u.supdate   = s.supdate) unsold
		 from cir_dbksup s
		 where s.comp_code = @pcomp_code
		   and s.unit_code = @punit_code
		   and s.sup_type_code in (select sup_ty_code from CIR_SUPPLY_TYPE_MAST where comp_code = s.comp_code and bill_pay = 'Y')
		   and s.supdate between @pfrdate and @ptodate
		   and ((s.agcd = @pagcd) or (@pagcd is null) or (@pagcd=''))
		   --and ((s.dpcd = @pdpcd) or (@pdpcd is null) or (@pdpcd=''))
		   --and @pdpcd='0001'
		group by s.comp_code,s.unit_code,s.publ,s.edtn,s.agcd,s.dpcd,s.supdate) x, cir_agmast
		where x.comp_code = cir_agmast.comp_code
		  and x.unit_code = cir_agmast.unit
		  and x.agcd      = cir_agmast.agcd
		  and x.dpcd      = cir_agmast.dpcd
		  and ((isnull(cir_agmast.to_bill,'N') = 'Y') or (cir_agmast.ag_type='AT002'))
		group by x.comp_code,x.unit_code,x.publ,x.edtn,x.agcd
		having sum(x.delivery)>0
		order by x.comp_code,x.unit_code,x.publ,x.edtn,x.agcd
     End
 End



///////////////////////////////////////////////////////////end/////////////////////////////////////////////






/**********************/
ALTER TABLE [CIR_INTEREST_BILL_DETAIL] ALTER COLUMN [BILL_ASON] DATETIME NOT NULL


ALTER TABLE [dbo].[CIR_INTEREST_BILL_DETAIL] ADD  CONSTRAINT [PK_CIR_INTEREST_BILL_DETAIL] PRIMARY KEY  
(
[COMP_CODE] ,
[BILLDT] ,
[BILLNO] ,
[BILL_ASON] 
)

/**********************/
PROCEDURE
/*********************/
USE [THENIBERP]
GO
/****** Object:  StoredProcedure [dbo].[cir_interest_on_overdue_bill]    Script Date: 6/11/2013 2:56:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--EXEC cir_interest_on_overdue_bill 'TN001','WIN','04/04/2013',NULL,'B0001','0030',18,60,'Y','AD01','MM/DD/YYYY','','','','',''
--EXEC cir_interest_on_overdue_bill 'TN001','WIN','04/30/2013',NULL,null,null,18,60,'Y','AD01','MM/DD/YYYY','','','','',''

ALTER procedure [dbo].[cir_interest_on_overdue_bill](
    @pcomp_code          as varchar(20),
    @punit_code          as varchar(20),
    @pason_date          as datetime,
    @pagency_type        as varchar(20),
    @pagmain_code        as varchar(20),
    @pagsub_code         as varchar(20),
    @pint_rate           as numeric(12,2),
    @poverdue_days       as numeric(10),
    @pposting_req        as varchar(20),--Y for Posting & N for no posting
    @puserid             as varchar(20),
    @pdateformat         as varchar(20),
    @pextra1             as varchar(200),
    @pextra2             as varchar(200),
    @pextra3             as varchar(200),
    @pextra4             as varchar(200),
    @pextra5             as varchar(200))
As
    declare @v_cnt                int
    --declare @v_ason_dt          datetime;
    declare @v_userid             varchar(20);
    declare @v_days               numeric(10);
    declare @v_already_int_days   numeric(10);
declare @v_prev_interest_date datetime;


    declare c_agency cursor for select Comp_Code comp_code, agcd agency_code, dpcd agency_sub_code, ag_name agency_name, City_Code city_code,
                                  isnull((select "City_Name" from city_mst 
                 where "Comp_Code" = cir_agmast.Comp_Code 
                    and City_Code=cir_agmast.City_Code),'Not Define') city_name,
                                       Credit_Days credit_days from cir_agmast
where "Comp_Code"=@pcomp_code 
and ((agcd=@pagmain_code) or (@pagmain_code is null)) 
and ((dpcd=@pagsub_code) or (@pagsub_code is null)) 
and ((ag_CLASS=@pagency_type) or (@pagency_type is null));
    
 declare @v_agency_comp_code	varchar(20)
 declare @v_agency_agency_code	varchar(20)
 declare @v_agency_agency_sub_code	varchar(20)
 declare @v_agency_agency_name	varchar(500)
 declare @v_agency_city_code	varchar(50)
 declare @v_agency_city_name	varchar(100)
 declare @v_agency_credit_days	as numeric(10)


declare @v_pub_center	varchar(50);
declare @v_recptno	varchar(50);
declare @v_vchno	varchar(50);
declare @v_doctype	varchar(10);
declare @v_remark	VARCHAR(500);
declare @v_pprocessdt   DATETIME;
declare @p_pprocessdt   varchar(30);
declare @v_prefix	varchar(30);
declare @v_branchnm	varchar(20);
declare @v_reason	varchar(20);
declare @v_dr_cdp	varchar(20);
declare @v_cr_cdp	varchar(20);
declare @rec_intt_comp_code	varchar(50)
declare @rec_intt_bran_code	varchar(50)
declare @rec_Publ	varchar(50)
begin

--set @p_pprocessdt = convert(varchar(10),getdate(),101)
--set @v_pprocessdt= @p_pprocessdt;
    
set @v_pprocessdt = @pason_date

    print('@v_pprocessdt')print(@p_pprocessdt)
    set @v_remark    = 'Interest Invoice ';
    set @v_doctype   = 'INI';
    set @v_reason    = 'IN0';--Interest Invoice


    open c_agency;
        FETCH NEXT FROM c_agency INTO  @v_agency_comp_code , @v_agency_agency_code,@v_agency_agency_sub_code,@v_agency_agency_name,
@v_agency_city_code,@v_agency_city_name,@v_agency_credit_days
WHILE (@@FETCH_STATUS = 0) BEGIN

print('@v_agency_agency_code ')print(@v_agency_agency_code)print(@v_agency_agency_sub_code)

--select distinct @v_branchnm= substring(isnull("Branch_Alias","Branch_Name"),1,3)  from branch_mst 
            --where "Comp_Code"=@rec_intt_comp_code and "Branch_Code"=@rec_intt_bran_code
--set @v_prefix  = @v_doctype + '/' +   @v_branchnm + '/' + replace(CONVERT(VARCHAR(5), @v_pprocessdt, 11) ,'/','-')+ '/' 
--set @v_prefix  = @v_doctype + replace(CONVERT(VARCHAR(2), @v_pprocessdt, 11) ,'/','-') 
--set @v_recptno  = dbo.ad_genreceiptno( @rec_intt_comp_code, @v_prefix, null, @v_doctype, @p_pprocessdt, 'mm/dd/yyyy', 'F')	
     

declare @v_bill_comp_code    varchar(100);
declare @v_bill_billno       varchar(100);
declare @v_bill_billdt       datetime;
declare @v_bill_bill_amt     numeric(18,2);
declare @v_intt_amt          numeric(18,2);
declare @v_bill_unit         varchar(20);
 
declare  c_bill cursor for
                select distinct x.comp_code, x.publ, x.billno, x.billdt as billdt, sum(x.bill_amt) bill_amt,
               b.unit_Code from (select distinct comp_code, publ, billno, billdt as billdt, sum(amount) bill_amt from cir_outmast
                                                 where comp_code              = @pcomp_code 
 and (unit_Code              = isnull(@punit_code,unit_code) or @punit_code='') 
 and  doctyp not in ('INI')
 and  agcd                   = @v_agency_agency_code 
 and  dpcd                   = isnull(@v_agency_agency_sub_code,dpcd) 
 and  billdt                <= @pason_date 
 and isnull(recptdt,billdt) <= @pason_date
                                                 group by comp_code, publ,billno,billdt having sum(amount)>0
                                             union
                                             select distinct comp_code, publ, recptno billno, recptdt billdt, sum(amount) bill_amt from cir_outmast
                                                 where comp_code = @pcomp_code 
 and (unit_code = isnull(@punit_code,unit_Code) or @punit_code='') 
 and  doctyp not in ('INI')
 and  agcd      = @v_agency_agency_code 
 and  dpcd      = isnull(@v_agency_agency_sub_code, dpcd) 
 and  recptdt  <= @pason_date and isnull(amount,0)>0 
                                                  and (billno is null or billno='')
                                                 group by comp_code, publ,recptno,recptdt having sum(amount)>0) x, cir_bill b
                where x.comp_code=b.comp_code 
 and x.billdt=b.billdt 
 and x.billno=b.billno 
 /*and not exists (select 'x' from CIR_interest_bill_detail d 
             where d.comp_code=b.comp_code 
   and d.billdt=b.billdt 
and d.billno=b.billno)*/
                group by x.comp_code,x.publ, x.billno,x.billdt,b.unit_code
                order by x.billdt,x.billno;
           print('open c_bill') print(@pcomp_code)print(@punit_code)print(@v_agency_agency_code)print(@pason_date)
        open c_bill;
FETCH NEXT FROM c_bill INTO @v_bill_comp_code, @rec_publ, @v_bill_billno, @v_bill_billdt, @v_bill_bill_amt, @v_bill_unit;
WHILE (@@FETCH_STATUS = 0) BEGIN
print('@@v_bill_billno ')print(@v_bill_billno)print(@v_bill_bill_amt)print(@v_bill_billdt)print(@pason_date)
             
select @v_prev_interest_date = max(bill_ason), @v_already_int_days = sum(overdue_days) 
   from ad_interest_bill_detail
where comp_code = @pcomp_code
 and billno    = @v_bill_billno

if SUBSTRING((isnull(@v_bill_billno,'?')),1,4) = 'OLDI'
   BEGIN
  if isnull(@v_already_int_days,0) > 0
    BEGIN
   SET @v_days = datediff(dd, @pason_date, @v_prev_interest_date)
END
                  ELSE
    BEGIN
  set @v_days = '60'
    END
END
             else
   BEGIN
                   --set @v_days=DATEDIFF(dd, DBO.GetLastDayOfMonth(@v_bill_billdt),@pason_date )- isnull(@v_agency_credit_days,0)+1;
  set @v_days = DATEDIFF(dd, DBO.GetLastDayOfMonth(@v_bill_billdt),@pason_date )- isnull(@v_agency_credit_days,0)-1;
  set @v_days = isnull(@v_days,0) - isnull(@v_already_int_days,0)
                END
print('v_days')print(@v_days)
if @v_days<0 begin
 set @v_days=0;
end
        
        if @v_days >=isnull(@poverdue_days,0) begin
        
            set @v_intt_amt  =round((isnull(@v_bill_bill_amt,0)*@pint_rate*@v_days)/(100*365),2);
            if isnull(@v_intt_amt,0) > 0 
  begin
insert into cir_interest_bill_detail (comp_code, bran_code, agcd, dpcd, billno,
 billdt, bill_osamt, bill_ason, intt_rate, intt_amt,
 intt_days, credit_days, overdue_days, post_flag, created_by,
 created_dt, int_date,  int_doc_type, int_doc_no)
     values (@v_agency_comp_code, @v_bill_unit, @v_agency_agency_code, @v_agency_agency_sub_code, @v_bill_billno,
     @v_bill_billdt, @v_bill_bill_amt, @pason_date, @pint_rate, @v_intt_amt,
 @v_days, @v_agency_credit_days, @poverdue_days, 'N', @puserid,
 getdate(), @v_pprocessdt, @v_doctype, @v_recptno);
               end
        end
        
        set @v_days=0;
        set @v_bill_bill_amt =0;
        set @v_bill_comp_code=null;
        set @v_bill_billno   =null;
        set @v_bill_billdt   =null;
        set @v_intt_amt      =0; 
FETCH NEXT FROM c_bill INTO @v_bill_comp_code, @rec_publ, @v_bill_billno, @v_bill_billdt, @v_bill_bill_amt, @v_bill_unit; 
        end
        close c_bill;
        deallocate c_bill;

       FETCH NEXT FROM c_agency INTO  @v_agency_comp_code , @v_agency_agency_code,@v_agency_agency_sub_code,@v_agency_agency_name,
@v_agency_city_code,@v_agency_city_name,@v_agency_credit_days 
    end
    close c_agency;
    deallocate c_agency;



    begin
        select distinct @v_dr_cdp=dr_cdp,@v_cr_cdp=cr_cdp
            from fa_fin_link_mast
        where comp_code         = @pcomp_code
            and unit_code      = 'ALL'
            and branch_code    = 'ALL'
            and modual_alias   = 'ADCOLL'
            and doctype        = @v_doctype
            and reason_paymode = @v_reason
            and @v_pprocessdt between eff_fr_date and eff_to_date;
               
    end
    

declare @rec_intt_ag_main_code	varchar(50)
declare @rec_intt_ag_sub_code	varchar(50)
declare @rec_intt_intt_rate	numeric(12,2)
declare @rec_intt_amount	numeric(18,2)
declare @rec_intt_region	varchar(50)    

    declare cur_intt cursor for select d.comp_code, d.bran_code, d.agcd, d.dpcd, d.intt_rate,
                                  sum(d.intt_amt) amount, '' region from cir_interest_bill_detail d, cir_Agmast m
                                   where d.comp_code = m.Comp_Code 
    and d.agcd      = m.agcd 
and d.dpcd      = m.dpcd
and d.post_flag = 'N' 
--and created_dt=getdate()
                                   group by d.comp_code ,d.bran_code ,d.agcd ,d.dpcd, d.intt_rate;

    
    open cur_intt;
        FETCH NEXT FROM cur_intt INTO @rec_intt_comp_code, @rec_intt_bran_code, @rec_intt_ag_main_code, @rec_intt_ag_sub_code, @rec_intt_intt_rate ,@rec_intt_amount, @rec_intt_region
  WHILE (@@FETCH_STATUS = 0) BEGIN
             set @v_cnt=isnull(@v_cnt,0)+1;
          
select @v_vchno  =  MAX(voucherno) FROM  cir_rcphdr 
 WHERE comp_code  = @rec_intt_comp_code 
  AND  doctype  = @v_doctype 
  AND	replace(CONVERT(VARCHAR(5), recptdt, 11) ,'/','')  = replace(CONVERT(VARCHAR(5), @v_pprocessdt, 11) ,'/','')
IF (@v_vchno is null or @v_vchno = '0' )
BEGIN 
set @v_vchno  = replace(CONVERT(VARCHAR(5), @v_pprocessdt, 11) ,'/','')+ '0001' 
END
ELSE
BEGIN 
if( len(cast(@v_vchno as int))=1)
set @v_vchno='0000000'+@v_vchno
if( len(cast(@v_vchno as int))=2)
set @v_vchno='000000'+@v_vchno
if( len(cast(@v_vchno as int))=3)
set @v_vchno='00000'+@v_vchno
if( len(cast(@v_vchno as int))=4)
set @v_vchno='0000'+@v_vchno
if( len(cast(@v_vchno as int))=5)
set @v_vchno='000'+@v_vchno
if( len(cast(@v_vchno as int))=6)
set @v_vchno='00'+@v_vchno
if( len(cast(@v_vchno as int))=7)
set @v_vchno='0'+@v_vchno
else
set @v_vchno=@v_vchno
END          
          
            Begin
                select distinct @v_pub_center = pub_center  from branch_mst 
where Comp_Code   = @rec_intt_comp_code 
 and Branch_Code = @rec_intt_bran_code;
  
            End;
              if isnull(@rec_intt_amount,0) > 0 
    begin
         set @v_recptno  = [dbo].[cir_generate_intbillno] (  @rec_intt_comp_code, @v_pub_center, 'INI', @v_pprocessdt,'mm/dd/yyyy','INTI', '')      
/*PRINT '@v_recptno'
PRINT @v_recptno
print '@v_recptno'
print @v_recptno     
--set @v_recptno='eeeee' 
print @rec_intt_comp_code
print @puserid
print @rec_intt_bran_code
print @v_doctype
print @v_recptno 
print @v_pprocessdt
print @v_reason 
print @rec_intt_amount 
print @v_remark
print @v_vchno
print @v_pprocessdt
print @rec_intt_ag_main_code
print @rec_intt_ag_sub_code
print @v_dr_cdp
print @v_cr_cdp 
print @v_pub_center*/
insert into cir_rcphdr (comp_code, userid, branch_code, doctype, recptno, 
recptdt, reason, amount, oth_amount, chno, 
chdt, chbank, remark, received_from, voucherno, 
voucherdt, agcd, dpcd, ccdp, rcdp, 
unit_Code)
values (@rec_intt_comp_code, @puserid, @rec_intt_bran_code, @v_doctype, @v_recptno,
@v_pprocessdt, @v_reason, @rec_intt_amount, null, null, 
null , null , @v_remark, null, @v_vchno, 
@v_pprocessdt, @rec_intt_ag_main_code, @rec_intt_ag_sub_code, @v_dr_cdp, @v_cr_cdp, 
@v_pub_center);
                                   
insert into cir_rcpdet (comp_code, usrid, branch_code, doctyp, recptno, 
recptdt, reason, voucherno, voucherdt, amount, 
chno, chdt, chbnk, remark, agcd, 
dpcd, unit_code)
values (@rec_intt_comp_code, @puserid, @rec_intt_bran_code, @v_doctype, @v_recptno,
@v_pprocessdt, @v_reason, @v_vchno, @v_pprocessdt, @rec_intt_amount,
null, null, null, @v_remark, @rec_intt_ag_main_code,
@rec_intt_ag_sub_code, @v_pub_center);

  insert into cir_outmast (comp_code, usrid, branch_Code, doctyp, recptno,
recptdt, reason, voucherno, voucherdt, amount,
chno, chdt, chbnk, remark, agcd, 
dpcd, unit_code,publ)
values (@rec_intt_comp_code, @puserid, @rec_intt_bran_code, @v_doctype, @v_recptno,
@v_pprocessdt, @v_reason, @v_vchno, @v_pprocessdt, 0,
null ,null ,null,@v_remark, @rec_intt_ag_main_code,
@rec_intt_ag_sub_code, @v_pub_center, @rec_publ);
--------debit note as billno allocate
  insert into cir_outmast (comp_code, branch_code, doctyp, reason , billno, 
billdt, recptno, recptdt, chno, chdt, 
chbnk, voucherno, voucherdt, amount, usrid,
agcd, dpcd, remark, unit_Code, publ)
 values(@rec_intt_comp_code, @rec_intt_bran_code, @v_doctype, @v_reason, @v_recptno,
@v_pprocessdt, @v_recptno, @v_pprocessdt, null, null,
null, @v_vchno, @v_pprocessdt, abs(@rec_intt_amount), @puserid,
@rec_intt_ag_main_code, @rec_intt_ag_sub_code, @v_remark, @v_pub_center, @rec_publ);
    
                   update cir_interest_bill_detail set post_flag = 'Y', int_Doc_no = @v_recptno
                        where comp_code = @rec_intt_comp_code 
             and bran_code = @rec_intt_bran_code 
             and agcd      = @rec_intt_ag_main_code 
             and dpcd      = @rec_intt_ag_sub_code 
             and post_flag = 'N' 
             --and created_dt=GETDATE();
        
      end 
            
FETCH NEXT FROM cur_intt INTO @rec_intt_comp_code , @rec_intt_bran_code ,@rec_intt_ag_main_code ,@rec_intt_ag_sub_code ,
@rec_intt_intt_rate ,@rec_intt_amount,@rec_intt_region
    end
    close cur_intt;
    deallocate cur_intt;
    
    select getdate() as "CUR_DATE";
    

End
/*********************/



ALTER FUNCTION [dbo].[CRM_GET_READER_NAME] (@p_locid varchar(20), @p_rid varchar(20), @sch_id varchar(10))
RETURNS varchar(500) AS 

  BEGIN
     DECLARE @v_nm    VARCHAR(500) 
     
SELECT @v_nm = r_name from crm_reader_detail
        where loc_id=@p_locid
 and SCH_OPT=@sch_id
 and r_id=@p_rid

     return isnull(@v_nm, '')

  END

ALTER FUNCTION [dbo].[Currency_ToWords] (
@Input Numeric (38, 3) -- Input number with as many as 18 digits

) RETURNS VARCHAR(8000)

/*
* Converts a integer number as large as 34 digits into the
* equivalent words. The first letter is capitalized.
*
* Attribution: Based on NumberToWords by Srinivas Sampath
* as revised by Nick Barclay
*
* Example:
select dbo.udf_Num_ToWords (1234567890) + CHAR(10)
+ dbo.udf_Num_ToWords (0) + CHAR(10)
+ dbo.udf_Num_ToWords (123) + CHAR(10)
select dbo.udf_Num_ToWords(76543210987654321098765432109876543210)

DECLARE @i numeric (38,0)
SET @i = 0
WHILE @I <= 1000 BEGIN
PRINT convert (char(5), @i)
+ convert(varchar(255), dbo.udf_Num_ToWords(@i))
SET @I = @i + 1
END
*
* Published as the T-SQL UDF of the Week Vol 2 #9 2/17/03
****************************************************************/
AS BEGIN
Declare @Number Numeric(38,0)
set @Number = floor(@Input)
Declare @Cents as int
set @Cents = 100*Convert(money,(@Input - convert(Numeric(38,3),@Number)))
DECLARE @inputNumber VARCHAR(38)
DECLARE @NumbersTable TABLE (number CHAR(2), word VARCHAR(10))
DECLARE @outputString VARCHAR(8000)
DECLARE @length INT
DECLARE @counter INT
DECLARE @loops INT
DECLARE @position INT
DECLARE @chunk CHAR(3) -- for chunks of 3 numbers
DECLARE @tensones CHAR(2)
DECLARE @hundreds CHAR(1)
DECLARE @tens CHAR(1)
DECLARE @ones CHAR(1)
DECLARE @cent_in_word VARCHAR(500)

IF @Number = 0 Return 'Zero'

-- initialize the variables
SELECT @inputNumber = CONVERT(varchar(38), @Number)
, @outputString = ''
, @counter = 1
SELECT @length = LEN(@inputNumber)
, @position = LEN(@inputNumber) - 2
, @loops = LEN(@inputNumber)/3

-- make sure there is an extra loop added for the remaining numbers
IF LEN(@inputNumber) % 3 <> 0 SET @loops = @loops + 1

-- insert data for the numbers and words
INSERT INTO @NumbersTable SELECT '00', ''
UNION ALL SELECT '01', 'one' UNION ALL SELECT '02', 'two'
UNION ALL SELECT '03', 'three' UNION ALL SELECT '04', 'four'
UNION ALL SELECT '05', 'five' UNION ALL SELECT '06', 'six'
UNION ALL SELECT '07', 'seven' UNION ALL SELECT '08', 'eight'
UNION ALL SELECT '09', 'nine' UNION ALL SELECT '10', 'ten'
UNION ALL SELECT '11', 'eleven' UNION ALL SELECT '12', 'twelve'
UNION ALL SELECT '13', 'thirteen' UNION ALL SELECT '14', 'fourteen'
UNION ALL SELECT '15', 'fifteen' UNION ALL SELECT '16', 'sixteen'
UNION ALL SELECT '17', 'seventeen' UNION ALL SELECT '18', 'eighteen'
UNION ALL SELECT '19', 'nineteen' UNION ALL SELECT '20', 'twenty'
UNION ALL SELECT '30', 'thirty' UNION ALL SELECT '40', 'forty'
UNION ALL SELECT '50', 'fifty' UNION ALL SELECT '60', 'sixty'
UNION ALL SELECT '70', 'seventy' UNION ALL SELECT '80', 'eighty'
UNION ALL SELECT '90', 'ninety'

WHILE @counter <= @loops BEGIN

-- get chunks of 3 numbers at a time, padded with leading zeros
SET @chunk = RIGHT('000' + SUBSTRING(@inputNumber, @position, 3), 3)

IF @chunk <> '000' BEGIN
SELECT @tensones = SUBSTRING(@chunk, 2, 2)
, @hundreds = SUBSTRING(@chunk, 1, 1)
, @tens = SUBSTRING(@chunk, 2, 1)
, @ones = SUBSTRING(@chunk, 3, 1)

-- If twenty or less, use the word directly from @NumbersTable
IF CONVERT(INT, @tensones) <= 20 OR @Ones='0' BEGIN
SET @outputString = (SELECT word
FROM @NumbersTable
WHERE @tensones = number)
+ CASE @counter WHEN 1 THEN '' -- No name
WHEN 2 THEN ' thousand ' WHEN 3 THEN ' million '
WHEN 4 THEN ' billion ' WHEN 5 THEN ' trillion '
WHEN 6 THEN ' quadrillion ' WHEN 7 THEN ' quintillion '
WHEN 8 THEN ' sextillion ' WHEN 9 THEN ' septillion '
WHEN 10 THEN ' octillion ' WHEN 11 THEN ' nonillion '
WHEN 12 THEN ' decillion ' WHEN 13 THEN ' undecillion '
ELSE '' END
+ @outputString
END
ELSE BEGIN -- break down the ones and the tens separately

SET @outputString = ' '
+ (SELECT word
FROM @NumbersTable
WHERE @tens + '0' = number)
+ '-'
+ (SELECT word
FROM @NumbersTable
WHERE '0'+ @ones = number)
+ CASE @counter WHEN 1 THEN '' -- No name
WHEN 2 THEN ' thousand ' WHEN 3 THEN ' million '
WHEN 4 THEN ' billion ' WHEN 5 THEN ' trillion '
WHEN 6 THEN ' quadrillion ' WHEN 7 THEN ' quintillion '
WHEN 8 THEN ' sextillion ' WHEN 9 THEN ' septillion '
WHEN 10 THEN ' octillion ' WHEN 11 THEN ' nonillion '
WHEN 12 THEN ' decillion ' WHEN 13 THEN ' undecillion '
ELSE '' END
+ @outputString
END

-- now get the hundreds
IF @hundreds <> '0' BEGIN
SET @outputString = (SELECT word
FROM @NumbersTable
WHERE '0' + @hundreds = number)
+ ' hundred '
+ @outputString
END
END

SELECT @counter = @counter + 1
, @position = @position - 3

END

-- Remove any double spaces
SET @outputString = LTRIM(RTRIM(REPLACE(@outputString, ' ', ' ')))
SET @outputstring = UPPER(LEFT(@outputstring, 1)) + SUBSTRING(@outputstring, 2, 8000)

if isnull(@Cents,0)>0
   Begin
     set @cent_in_word = ' & '+dbo.Number_ToWords(@Cents)+ ' CENTS';
   End
ELSE
   BEGIN
     set @cent_in_word = '';
   END
   
   RETURN UPPER(@outputString) + @cent_in_word -- return the result   


END
/***************************/