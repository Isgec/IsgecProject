issue number 6263
                                                                     
                                                                     
                                                                     
                                             
ALTER procedure [dbo].[cir_rep_abc_cir_rate_comm_supply_unsold]
     @pcomp_code 		as varchar(20),
     @punit_code 		as varchar(20),
     @pbrancode         as varchar(20),
     @ppublcode         as varchar(20),
     @pagtype 			as varchar(20),
     @pfrom_supdate 	as datetime,
     @ptill_supdate 	as datetime,
     @preptype          as varchar(20),--for comm & rate wise supply & unsold--
     @pdateformat 		as varchar(20),
     @pextra1 			as varchar(20),
     @pextra2           as varchar(20)
    As
     declare @vfrdt    datetime
     declare @vtodt    datetime
     declare @v_dt     datetime
     declare @v_cnt    INT
     declare @vvar     varchar(8000)
     declare @vvar_sum  varchar(8000)
     declare @vvar_sum1 varchar(8000)
     declare @v_query   varchar(8000)
     declare @v_query1  varchar(8000)
       
   Begin
SET CONCAT_NULL_YIELDS_NULL OFF
        set @vfrdt=dbo.GetFirstDayOfMonth(@pfrom_supdate)
        set @vtodt=dbo.GetLastDayOfMonth(@ptill_supdate)   
		
		CREATE TABLE #CIR_TEMP_DT(SEQNO INT,DT	DATETIME)
		declare @month_count as numeric(6)
		declare @loopval as numeric(6)
		declare @dynamic_month_last as datetime 

		set @loopval=0
		set @month_count=DATEDIFF(month, @vfrdt, @vtodt)+1
		while(@month_count !=0)
		begin

			set @dynamic_month_last=DATEADD(mm, @loopval, isnull(@dynamic_month_last,@vfrdt))
			set @v_cnt=isnull(@v_cnt,0)+1

			insert into #cir_temp_dt(SEQNO,dt) 
			values(@v_cnt,dbo.GetLastDayOfMonth(@dynamic_month_last))

			set @loopval=@loopval+1
			set @month_count=@month_count-1
		end
--select * from #cir_temp_dt
declare c1 cursor for
           select dt from #cir_temp_dt order by SEQNO,dt
		open c1
			fetch NEXT FROM c1 INTO @v_dt
			WHILE (@@FETCH_STATUS = 0)  
			Begin
				set @v_cnt        = @v_cnt+1
				if @preptype in('CS','RS') 
					Begin--comm. wise & Rate wise supply--
						if @vvar is null 
							Begin
								set @vvar        ='case CONVERT(VARCHAR(10), dbo.GetlastDayOfMonth(b.billdt), 103) when '+''''+CONVERT(VARCHAR(10), @V_DT, 101)+''''+' then sum(b.bill_copy) else sum(0) end "'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8) +'"'
								--set @vvar        ='sum(decode(dbo.GetFirstDayOfMonth(b.billdt),'+''''+CONVERT(VARCHAR(11), @V_DT, 103)+''''+',b.bill_copy,0))"'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8) +'"'
								set @vvar_sum    ='sum('+'"'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'") "'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'"'
								set @vvar_sum1   ='sum('+'"'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'"'
							End
						else
							Begin
								set @vvar        =	@vvar+','+'case CONVERT(VARCHAR(10), dbo.GetlastDayOfMonth(b.billdt), 103) when '+''''+CONVERT(VARCHAR(10), @V_DT, 101)+''''+' then sum(b.bill_copy) else sum(0) end "'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8) +'"'
								set @vvar_sum    =	@vvar_sum+','+'sum('+'"'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'") "'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'"'
								set @vvar_sum1   =	@vvar_sum1+'+"'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'"'
							End
					End
				else if @preptype in('CU','RU') --comm. wise & Rate wise unsold--
					Begin
						if @vvar is null 
							Begin
												--case dbo.GetFirstDayOfMonth(b.app_dt) when '+''''+CONVERT(VARCHAR(11), @V_DT, 103)+''''+' then sum(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0)) else sum(0) end "'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8) +'"'
								set @vvar        ='case CONVERT(VARCHAR(10), dbo.GetlastDayOfMonth(b.app_dt), 103) when '+''''+CONVERT(VARCHAR(11), @V_DT, 103)+''''+' then sum(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0)) else sum(0) end "'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8) +'"'
								set @vvar_sum    ='sum('+'"'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'") "'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'"';
								set @vvar_sum1   ='sum('+'"'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'"';
							End
						else
							Begin
								set @vvar        =@vvar+','+'case CONVERT(VARCHAR(10), dbo.GetlastDayOfMonth(b.app_dt), 103) when '+''''+CONVERT(VARCHAR(11), @V_DT, 103)+''''+' then sum(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0)) else sum(0) end "'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8) +'"'
								set @vvar_sum    =@vvar_sum+','+'sum('+'"'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'") "'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'"';
								set @vvar_sum1   =@vvar_sum1+'+"'+SUBSTRING(CONVERT(VARCHAR(11), @V_DT, 113), 4, 8)+'"';
							End
					End
					
					fetch NEXT FROM c1 INTO @v_dt
			End
		close c1
		deallocate c1

		if @vvar_sum1 is not null 
			Begin
				set @vvar_sum1=@vvar_sum1+') "Total"'
			End
print(@vvar)
		if @preptype='CS' --comm. wise supply-- 
			Begin
				set @v_query='select comp_code,unit_code,comm_rate ,'+@vvar_sum+','+@vvar_sum1+' from (select b.comp_code comp_code,b.unit_code unit_code,isnull(b.comm_rate,0) comm_rate, '+@vvar+' from cir_agmast a, cir_bill_det b
				where a.comp_code=b.comp_code and b.comp_code='+''''+@pcomp_code+''''+' and a.unit=b.unit_code and b.unit_code='+''''+@punit_code+''''+' and 
				a.agcd=b.agcd and a.dpcd=b.dpcd and (a.branch_code=isnull('+''''+@pbrancode+''''+',a.branch_code) or '''+@pbrancode+''' ='''') and (a.ag_type=isnull('+''''+@pagtype+''''+',a.ag_type) or '''+@pagtype+''' ='''') and (b.publ=isnull('+''''+@ppublcode+''''+',b.publ) or '''+@ppublcode+''' ='''') and
				b.billdt between '+''''+CONVERT(VARCHAR(11), @VFRDT, 101)+''''+' and '+''''+CONVERT(VARCHAR(11), @VTODT, 101)+''''+' group by b.comp_code,b.unit_code,b.billdt,b.comm_rate) x
				group by comp_code,unit_code,comm_rate order by comp_code,unit_code,comm_rate'
        
				set @v_query1='select comp_code,unit_code,'+@vvar_sum+','+@vvar_sum1+' from 
				(select b.comp_code comp_code,b.unit_code unit_code,isnull(b.comm_rate,0) comm_rate, '+@vvar+' from cir_agmast a, cir_bill_det b
				where a.comp_code=b.comp_code and b.comp_code='+''''+@pcomp_code+''''+' and a.unit=b.unit_code and b.unit_code='+''''+@punit_code+''''+' and 
				a.agcd=b.agcd and a.dpcd=b.dpcd and (a.branch_code=isnull('+''''+@pbrancode+''''+',a.branch_code) or '''+@pbrancode+''' ='''') and (a.ag_type=isnull('+''''+@pagtype+''''+',a.ag_type) or '''+@pagtype+''' ='''') and (b.publ=isnull('+''''+@ppublcode+''''+',b.publ) or '''+@ppublcode+''' ='''') and
				b.billdt between '+''''+CONVERT(VARCHAR(11), @VFRDT, 101)+''''+' and '+''''+CONVERT(VARCHAR(11), @VTODT, 101)+''''+' group by b.comp_code,b.unit_code,b.billdt,b.comm_rate) x
				group by comp_code,unit_code order by comp_code,unit_code' 

			End
		else if @preptype='RS' -- Edition Rate wise supply-- 
			Begin	
				set @v_query='select comp_code,unit_code,publ,dbo.cir_get_publ_name(comp_code,publ) publ_name,dbo.cir_get_publ_seqno(comp_code,publ) publ_seqno,edtn,dbo.cir_get_edtn_name(comp_code,edtn) edtn_name,dbo.cir_get_edtn_seqno(comp_code,edtn) edtn_seqno,copy_rate ,'+@vvar_sum+','+@vvar_sum1+' 
				from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,isnull(b.copy_rate,0) copy_rate, '+@vvar+' from cir_agmast a, cir_bill_det b
				where a.comp_code=b.comp_code and b.comp_code='+''''+@pcomp_code+''''+' and a.unit=b.unit_code and b.unit_code='+''''+@punit_code+''''+' and 
				a.agcd=b.agcd and a.dpcd=b.dpcd and (a.branch_code=isnull('+''''+@pbrancode+''''+',a.branch_code) or '''+@pbrancode+''' ='''')and (a.ag_type=isnull('+''''+@pagtype+''''+',a.ag_type) or '''+@pagtype+''' ='''') and (b.publ=isnull('+''''+@ppublcode+''''+',b.publ) or '''+@ppublcode+''' ='''') and
				b.billdt between '+''''+CONVERT(VARCHAR(11), @VFRDT, 101)+''''+' and '+''''+CONVERT(VARCHAR(11), @VTODT, 101)+''''+' group by b.comp_code,b.unit_code,b.billdt,b.publ,b.edtn,b.copy_rate) x
				group by comp_code,unit_code,publ,edtn,copy_rate order by comp_code,unit_code,publ_seqno,publ,edtn_seqno,edtn,copy_rate'

				set @v_query1='select comp_code,unit_code,'+@vvar_sum+','+@vvar_sum1+' 
				from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,isnull(b.copy_rate,0) copy_rate, '+@vvar+' from cir_agmast a, cir_bill_det b
				where a.comp_code=b.comp_code and b.comp_code='+''''+@pcomp_code+''''+' and a.unit=b.unit_code and b.unit_code='+''''+@punit_code+''''+' and 
				a.agcd=b.agcd and a.dpcd=b.dpcd and (a.branch_code=isnull('+''''+@pbrancode+''''+',a.branch_code) or '''+@pbrancode+''' ='''') and (a.ag_type=isnull('+''''+@pagtype+''''+',a.ag_type) or '''+@pagtype+''' ='''') and (b.publ=isnull('+''''+@ppublcode+''''+',b.publ) or '''+@ppublcode+''' ='''') and
				b.billdt between '+''''+CONVERT(VARCHAR(11), @VFRDT, 101)+''''+' and '+''''+CONVERT(VARCHAR(11), @VTODT, 101)+''''+' group by b.comp_code,b.unit_code,b.billdt,b.publ,b.edtn,b.copy_rate) x
				group by comp_code,unit_code order by comp_code,unit_code'
			End
		else if @preptype='CU' --comm. wise unsold-- 
			Begin
				set @v_query='select comp_code,unit_code,comm_rate ,'+@vvar_sum+','+@vvar_sum1+' from (select b.comp_code comp_code,b.unit_code unit_code,isnull(b.comm_rate,0) comm_rate, '+@vvar+' from cir_agmast a, cir_unsold_dtl b
				where a.comp_code=b.comp_code and b.comp_code='+''''+@pcomp_code+''''+' and a.unit=b.unit_code and b.unit_code='+''''+@punit_code+''''+' and 
				a.agcd=b.agcd and a.dpcd=b.dpcd and (a.branch_code=isnull('+''''+@pbrancode+''''+',a.branch_code) or '''+@pbrancode+''' ='''') and (a.ag_type=isnull('+''''+@pagtype+''''+',a.ag_type) or '''+@pagtype+''' ='''') and (b.publ=isnull('+''''+@ppublcode+''''+',b.publ) or '''+@ppublcode+''' ='''') and
				b.app_dt between '+''''+CONVERT(VARCHAR(11), @VFRDT, 101)+''''+' and '+''''+CONVERT(VARCHAR(11), @VTODT, 101)+''''+' group by b.comp_code,b.unit_code,b.app_dt,b.comm_rate) x
				group by comp_code,unit_code,comm_rate order by comp_code,unit_code,comm_rate'; 
		        
				set @v_query1='select comp_code,unit_code,'+@vvar_sum+','+@vvar_sum1+' from (select b.comp_code comp_code,b.unit_code unit_code,isnull(b.comm_rate,0) comm_rate, '+@vvar+' from cir_agmast a, cir_unsold_dtl b
				where a.comp_code=b.comp_code and b.comp_code='+''''+@pcomp_code+''''+' and a.unit=b.unit_code and b.unit_code='+''''+@punit_code+''''+' and 
				a.agcd=b.agcd and a.dpcd=b.dpcd and (a.branch_code=isnull('+''''+@pbrancode+''''+',a.branch_code) or '''+@pbrancode+''' ='''') and (a.ag_type=isnull('+''''+@pagtype+''''+',a.ag_type) or '''+@pagtype+''' ='''') and (b.publ=isnull('+''''+@ppublcode+''''+',b.publ) or '''+@ppublcode+''' ='''') and
				b.app_dt between '+''''+CONVERT(VARCHAR(11), @VFRDT, 101)+''''+' and '+''''+CONVERT(VARCHAR(11), @VTODT, 101)+''''+' group by b.comp_code,b.unit_code,b.app_dt,b.comm_rate) x
				group by comp_code,unit_code order by comp_code,unit_code'
			End
		else if @preptype='RU' -- Edition Rate wise Unsold-- 
			Begin
				set @v_query='select comp_code,unit_code,publ,dbo.cir_get_publ_name(comp_code,publ) publ_name,dbo.cir_get_publ_seqno(comp_code,publ) publ_seqno,edtn,dbo.cir_get_edtn_name(comp_code,edtn) edtn_name,dbo.cir_get_edtn_seqno(comp_code,edtn) edtn_seqno,copy_rate ,'+@vvar_sum+','+@vvar_sum1+' 
				from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,isnull(b.copy_rate,0) copy_rate, '+@vvar+' from cir_agmast a, cir_unsold_dtl b
				where a.comp_code=b.comp_code and b.comp_code='+''''+@pcomp_code+''''+' and a.unit=b.unit_code and b.unit_code='+''''+@punit_code+''''+' and 
				a.agcd=b.agcd and a.dpcd=b.dpcd and (a.branch_code=isnull('+''''+@pbrancode+''''+',a.branch_code) or '''+@pbrancode+''' ='''') and (a.ag_type=isnull('+''''+@pagtype+''''+',a.ag_type) or '''+@pagtype+''' ='''') and (b.publ=isnull('+''''+@ppublcode+''''+',b.publ) or '''+@ppublcode+''' ='''') and
				b.app_dt between '+''''+CONVERT(VARCHAR(11), @VFRDT, 101)+''''+' and '+''''+CONVERT(VARCHAR(11), @VTODT, 101)+''''+' group by b.comp_code,b.unit_code,b.app_dt,b.publ,b.edtn,b.copy_rate) x
				group by comp_code,unit_code,publ,edtn,copy_rate order by comp_code,unit_code,publ_seqno,publ,edtn_seqno,edtn,copy_rate'
	        
				set @v_query1='select comp_code,unit_code,'+@vvar_sum+','+@vvar_sum1+' 
				from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,isnull(b.copy_rate,0) copy_rate, '+@vvar+' from cir_agmast a, cir_unsold_dtl b
				where a.comp_code=b.comp_code and b.comp_code='+''''+@pcomp_code+''''+' and a.unit=b.unit_code and b.unit_code='+''''+@punit_code+''''+' and 
				a.agcd=b.agcd and a.dpcd=b.dpcd and (a.branch_code=isnull('+''''+@pbrancode+''''+',a.branch_code) or '''+@pbrancode+''' ='''') and (a.ag_type=isnull('+''''+@pagtype+''''+',a.ag_type) or '''+@pagtype+''' ='''') and (b.publ=isnull('+''''+@ppublcode+''''+',b.publ) or '''+@ppublcode+''' ='''') and
				b.app_dt between '+''''+CONVERT(VARCHAR(11), @VFRDT, 101)+''''+' and '+''''+CONVERT(VARCHAR(11), @VTODT, 101)+''''+' group by b.comp_code,b.unit_code,b.app_dt,b.publ,b.edtn,b.copy_rate) x
				group by comp_code,unit_code order by comp_code,unit_code'
			End
    

print(@v_query)    

	exec (@v_query)
    --print('v_query')
	--print(@v_query)
 --print('v_query1')
--print(@v_query1)

print(@v_query1)   
    exec (@v_query1)
        
    End

///////////////////////////////end of issue number 6263////////////////////////////////////////////
/////////////////////////issue number 6264

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER procedure [dbo].[cir_citywise_supply](
@pcomp_code        as varchar(50),
@punit_code       as varchar(50),
@pbrancode         as varchar(50),
@ppublcode        as varchar(50),
@pagtype          as varchar(50),
@pstatecode        as varchar(50),
@pcitycode         as varchar(50),
@pfrom_supdate     as varchar(50),
@ptill_supdate     as varchar(50),
@pdateformat       as varchar(50),
@pextra1           as varchar(50),
@pextra2            as varchar(50)

)
as
SET CONCAT_NULL_YIELDS_NULL OFF
CREATE TABLE #CIR_TEMP_DT
(
  SQNO  NUMeric,
  DT    DATEtime
)

declare @vfrdt  as  datetime;
declare @vtodt  as datetime;
declare @v_dt   as  datetime;
declare @v_cnt   as numeric(5)
declare @vvar    as varchar(2000);
declare @vvar_sum   as  varchar(2000);
declare @vvar_sum1  as  varchar(2000);
declare @v_query  as  varchar(max);
declare @v_query1  as  varchar(max);

set @v_cnt=0;

set @vfrdt=dbo.GetLastDayOfMonth (@pfrom_supdate)  --@pfrom_supdate;
set @vtodt=dbo.GetFirstDayOfMonth (@ptill_supdate) --@ptill_supdate;


print('abcd')
print(@v_dt)


if @v_dt is null or @v_dt = '' 
begin
print('abc')
set @v_dt=@vfrdt
end
print('@vfrdt')print(@vfrdt)
WHILE (@v_dt < @vtodt)
BEGIN
	if @v_dt>=@vtodt begin
       break;
    end
	print('@v_dt') print(@v_dt)
	if @v_dt is null or @v_dt = '' begin
	--if @v_dt=@vfrdt begin
		set @v_dt=dbo.GetLastDayOfMonth (@vfrdt);
		print('@v_dt1') print(@v_dt)
	end
	else
	begin
	print('@v_dt2')
		set @v_dt=DATEADD(mm,1,@v_dt)
		print(@v_dt)
	end
	set @v_cnt=@v_cnt+1
	print(@v_cnt)
	insert into #cir_temp_dt(sqno,dt) values(@v_cnt,@v_dt);
END
print('x')

declare c1 cursor for
select sqno,dt from #cir_temp_dt order by sqno,dt;

declare @c1_sqno as numeric
declare @c1_dt as datetime



OPEN c1 
	fetch NEXT FROM c1 INTO @c1_sqno , @v_dt
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
		print('1')
			set @v_cnt= @v_cnt+1 
			if (@vvar is null or @vvar = '') begin print('2')
				--set @vvar        ='sum(decode(last_day(b.billdt),'+''''+@v_dt+''''+',b.bill_copy,0))"'+to_char(v_dt,'Mon/YYYY')+'"';
				set @vvar        ='sum(case(dbo.GetLastDayOfMonth(b.billdt)) when '+''''+cast(@v_dt as varchar)+''''+' then b.bill_copy else 0 end) "'+SUBSTRING(CONVERT(VARCHAR(11), @v_dt, 113), 4, 8)+'"';
				print('3')--set @vvar_sum    ='sum('+'"'+to_char(v_dt,'Mon/YYYY')+'") "'+to_char(v_dt,'Mon/YYYY')+'"';
				set @vvar_sum    ='sum(d.'+'"'+SUBSTRING(CONVERT(VARCHAR(11), @v_dt, 113), 4, 8)+'") "'+SUBSTRING(CONVERT(VARCHAR(11), @v_dt, 113), 4, 8)+'"';
				set @vvar_sum1   ='sum(d.'+'"'+SUBSTRING(CONVERT(VARCHAR(11), @v_dt, 113), 4, 8)+'"';
			end
			else
			begin
				--set @vvar        =@vvar+','+'sum(decode(last_day(b.billdt),'+''''+v_dt+''''+',b.bill_copy,0))"'+SUBSTRING(CONVERT(VARCHAR(11), @v_dt, 113), 4, 8)+'"';
				set @vvar        =@vvar+','+'sum(case(dbo.GetLastDayOfMonth(b.billdt)) when '+''''+cast(@v_dt as varchar)+''''+' then b.bill_copy else 0 end) "'+SUBSTRING(CONVERT(VARCHAR(11), @v_dt, 113), 4, 8)+'"';
				set @vvar_sum    =@vvar_sum+','+'sum(d.'+'"'+SUBSTRING(CONVERT(VARCHAR(11), @v_dt, 113), 4, 8)+'") "'+SUBSTRING(CONVERT(VARCHAR(11), @v_dt, 113), 4, 8)+'"';
				set @vvar_sum1   =@vvar_sum1+'+d."'+SUBSTRING(CONVERT(VARCHAR(11), @v_dt, 113), 4, 8)+'"';
			end
				
				
	fetch NEXT FROM c1 INTO @c1_sqno , @v_dt
END 	
close c1
DEALLOCATE c1
if @vvar_sum1 is not null or @vvar_sum1 !='' begin
            set @vvar_sum1=@vvar_sum1+') "Total"'
end
print('a')




set  @v_query='select d.comp_code comp_code,d.unit_code unit_code,s."State_Name" state_name,dbo.cir_get_city(d.comp_code,d.city_code) city_name,'+@vvar_sum+','+@vvar_sum1+' from (select b.comp_code comp_code,b.unit_code unit_code,a.state_code state_code,
        a.city_code city_code,'+@vvar+' from cir_agmast a, cir_bill_det b
        where a.comp_code=b.comp_code and b.comp_code='+''''+@pcomp_code+''''+' and a.unit=b.unit_code 
and 
(b.unit_code='''+@punit_code+''' or  '''+@punit_code+''' is null or '''+@punit_code+''' ='''' )
 and 
        a.agcd=b.agcd and a.dpcd=b.dpcd 
and (a.branch_code='''+@pbrancode+''' or '''+@pbrancode+'''='''' or  '''+@pbrancode+''' is null) 

and (a.ag_type='''+@pagtype+''' or '''+@pagtype+'''='''' or  '''+@pagtype+''' is null ) 
and (b.publ ='''+@ppublcode+'''  or '''+@ppublcode+'''='''' or  '''+@ppublcode+''' is null) 
and (a.state_code='''+@pstatecode+'''   or '''+@pstatecode+'''='''' or  '''+@pstatecode+''' is null) 
and (a.city_code='''+@pcitycode+'''  or '''+@pcitycode+'''='''' or  '''+@pcitycode+''' is null)

 and
        b.billdt between '+''''+cast(@vfrdt as varchar)+''''+' and '+''''+cast(@vtodt as varchar)+''''+' group by b.comp_code,b.unit_code,b.billdt,a.city_code,a.state_code) d,state_mst s
        where d.state_code=s."State_Code" 
        group by d.comp_code,d.unit_code,s."State_Name",d.city_code order by comp_code,unit_code,state_name,city_name';
        --insert into test1(vstring,vstring2) values('cir_citywise_supply ',v_query);commit;
      
print(@v_query)
exec(@v_query)
        
		set      @v_query1='select d.comp_code comp_code,d.unit_code unit_code,s."State_Name" state_name,'+@vvar_sum+','+@vvar_sum1+' from (select b.comp_code comp_code,b.unit_code unit_code,a.state_code state_code,
		a.city_code city_code,'+@vvar+' from cir_agmast a, cir_bill_det b
		where a.comp_code=b.comp_code and b.comp_code='+''''+@pcomp_code+''''+' 
		and a.unit=b.unit_code 

and 
(b.unit_code='''+@punit_code+''' or  '''+@punit_code+''' is null or '''+@punit_code+''' ='''' )
 and 
        a.agcd=b.agcd and a.dpcd=b.dpcd 
and (a.branch_code='''+@pbrancode+''' or '''+@pbrancode+'''='''' or  '''+@pbrancode+''' is null) 

and (a.ag_type='''+@pagtype+''' or '''+@pagtype+'''='''' or  '''+@pagtype+''' is null ) 
and (b.publ ='''+@ppublcode+'''  or '''+@ppublcode+'''='''' or  '''+@ppublcode+''' is null) 
and (a.state_code='''+@pstatecode+'''   or '''+@pstatecode+'''='''' or  '''+@pstatecode+''' is null) 
and (a.city_code='''+@pcitycode+'''  or '''+@pcitycode+'''='''' or  '''+@pcitycode+''' is null)

 and


		 b.billdt between '+''''+cast(@vfrdt as varchar)+''''+' 
		and '+''''+cast(@vtodt as varchar)+''''+' 
		group by b.comp_code,b.unit_code,b.billdt,a.city_code,a.state_code) d,state_mst s
		where d.state_code=s."State_Code"
		group by d.comp_code,d.unit_code,s."State_Name" order by comp_code,unit_code,state_name';
        --insert into test1(vstring,vstring2) values('cir_citywise_supply ',v_query);commit;
        --open p_accounts1 for v_query;

print(@v_query1)
exec(@v_query1)     


SET CONCAT_NULL_YIELDS_NULL On

///////////////////////////////////////////////end of issue 6264
//////////////////////bankreco

                                                                     
                                                                     
                                                                     
                                             
USE [abhi]
GO
/****** Object:  StoredProcedure [dbo].[fa_rep_bankreco_p]    Script Date: 03/02/2012 11:24:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[fa_rep_bankreco_p]

(
	@pcomp_code     as varchar(200),
	@punit_code     as varchar(200),
	@pbranch_code   as varchar(200),
	@pbnkcdp        as varchar(200),
	@pdoc_date      as datetime,
	@pbank_date     as datetime,
	@pbank_date_to  as datetime,
	@pstatus        as varchar(200),
	@pdateformat    as varchar(200),
	@pextra1        as varchar(200),
	@pextra2        as varchar(200)

)
AS 

 declare  @vlbldt     as   datetime;
 declare  @vlbldt_to  as   datetime;
 
	set @vlbldt=@pbank_date
	set @vlbldt_to=@pbank_date_to
	
	
SELECT x.comp_code, x.company_name,x.branch_code,x.branch_name,
x.unit_code,x.doc_type,x.doc_no,x.doc_date,x.bnkcdp, "AMT_DR","AMT_CR",x.chq_no,x.chq_dt,
x.narr,x.bank_date,x.bank_payto,x.status,x.bnk_stmt_ctrl_no,x.account_name
FROM(
select comp_code,dbo.get_company_name (comp_code) company_name,branch_code, dbo.get_branch_name(branch_code)branch_name,
unit_code,doc_type,doc_no,
case @pdateformat 
when 'dd/mm/yyyy' then convert(varchar(10),doc_date,103)
when 'mm/dd/yyyy' then convert(varchar(10),doc_date,101)
when 'yyyy/mm/dd' then convert(varchar(10),doc_date,111) end doc_date
,bnkcdp,
doc_amt AS "AMT_DR",NULL "AMT_CR",chq_no,chq_dt,narr,bank_date,bank_payto,status,bnk_stmt_ctrl_no,
dbo.fa_get_account_name(comp_code,bnkcdp) account_name
from fa_bankreco  WHERE comp_code  = @pcomp_code and unit_code       = @punit_code and
branch_code =@pbranch_code  and bnkcdp          = @pbnkcdp and
doc_date  between @vlbldt and @vlbldt_to and (status =@pstatus or @pstatus is null) and DOC_AMT>0
UNION all
select comp_code,dbo.get_company_name (comp_code) company_name,branch_code, dbo.get_branch_name(branch_code)branch_name,
unit_code,doc_type,doc_no,
case @pdateformat 
when 'dd/mm/yyyy' then convert(varchar(10),doc_date,103)
when 'mm/dd/yyyy' then convert(varchar(10),doc_date,101)
when 'yyyy/mm/dd' then convert(varchar(10),doc_date,111) end doc_date
,bnkcdp,
NULL "AMT_DR",DOC_AMT "AMT_CR",chq_no,chq_dt,narr,bank_date,bank_payto,status,bnk_stmt_ctrl_no,
dbo.fa_get_account_name(comp_code,bnkcdp) account_name
from fa_bankreco WHERE comp_code  = @pcomp_code and unit_code       = @punit_code and
branch_code =@pbranch_code  and bnkcdp          = @pbnkcdp and
doc_date  between @vlbldt and @vlbldt_to and (status =@pstatus or @pstatus is null) and DOC_AMT<0)x;
///////////////////////////
.////////////////////////////////////////////update By Garima

day Book summary
                                                                     
                                                                     
                                                                     
                                             
alter procedure [dbo].[cir_rep_abc_daybook_summ](
	@pcompcode           as varchar(500),
    @punitcode           as varchar(500),
    @pbrancode           as varchar(500),
    @ppublcode           as varchar(500),
    @pmedtncode          as varchar(500),
    @pedtncode           as varchar(500),
    @pagtype             as varchar(500),
    @pagclass            as varchar(500),     
    @pmonth              as varchar(500),--month jan 
    @pyear               as numeric,---2012
    @pday_period         as varchar(500),--1 for 1 to 15,2 for 16 to last month of day, 3 for 1 to last month of day
    @ppaid_free          as varchar(500),--P for paid supply,F for Free supply and blank for All
    @preptype            as varchar(500),--1 for pcentre wise summary report,2 for pcentre wise branch wise report, 3 for Zone wise ,4 for zone wise region wise,5 for state wise, 6 state wise district wise
    @pdateformat         as varchar(500),
    @puserid             as varchar(500),     
    @pextra1             as varchar(500),
    @pextra2             as varchar(500),
    @pextra3             as varchar(500),
    @pextra4             as varchar(500),
    @pextra5             as varchar(500)

)
as
SET CONCAT_NULL_YIELDS_NULL OFF

CREATE TABLE #CIR_LEDGER_REPORT
(
  COMP_CODE      VARCHAR(10),
  UNIT_CODE      VARCHAR(10),
  BRANCH_CODE    VARCHAR(10),
  DOCTYPE        VARCHAR(10),
  AGCD           VARCHAR(50),
  DPCD           VARCHAR(50),
  RECPTNO        VARCHAR(50),
  RECPTDT        DATEtime,
  AMOUNT         numeric(14,2),
  CHQNO          VARCHAR(50),
  CHQDT          DATEtime,
  CHQ_BANK       VARCHAR(100),
  EXEC_CODE      VARCHAR(20),
  REMARKS        VARCHAR(500),
  REASON         VARCHAR(30),
  BILLNO         VARCHAR(50),
  BILLDT         DATEtime,
  BILLAMT        numeric(14,2),
  ADJAMT         numeric(14,2),
  LEFTAMT        numeric(14,2),
  DEBIT_HEAD     VARCHAR(200),
  CREDIT_HEAD    VARCHAR(200),
  REC_SEQNO      numeric(10),
  RECOVARY_DAYS  numeric(5),
  AGNAME         VARCHAR(500),
  OPBAL_SEC      numeric(14,2),
  SESS_ID        numeric(10)                     DEFAULT @@spid,
  NARR_LINE      numeric(3),
  CITY_CODE      VARCHAR(10)
)


declare @v_frdt    datetime;
declare @v_todt    datetime;

declare @v_comp_code     varchar(50);
declare @v_comp_name     varchar(50);
declare @v_unit_code     varchar(50);
declare @v_unit_name     varchar(50);    
declare @v_publ          varchar(50);
declare @v_medtn         varchar(50);
declare @v_edtn          varchar(50);
declare @v_edtn_name     varchar(50);
declare @v_state_code    varchar(50);
declare @v_dist_code     varchar(50);
declare @v_tehsil_taluka varchar(50);
declare @v_city_code     varchar(50);
declare @v_city_name     varchar(50);
declare @v_zone_code     varchar(50);
declare @v_zone_name     varchar(50);
declare @v_region_code   varchar(50);
declare @v_region_name   varchar(50);
declare @v_branch_code   varchar(50);
declare @v_sup_copy      numeric(10);
declare @v_supdate       datetime;
declare @v_bill_pay      varchar(20);
declare @v_sday          varchar(2);
declare @vvar            varchar(2000);
declare @tot_vvar        varchar(2000);

declare @v_query1        varchar(max);
declare @v_query2        varchar(max);
declare @v_query3        varchar(max);
declare @v_query4        varchar(max);
declare @v_query5        varchar(max);
declare @v_query6        varchar(max);

--set @vsupdate =@pfrom_supdate
--set @vsupdate1=@ptill_supdate

declare @v_cnt       numeric
declare @v_sess_id   numeric;
set @v_cnt=0

select @v_sess_id = @@spid

if @pday_period='1' begin--for 1 to 15
    set @v_frdt   = @pmonth +'/01/'+@pyear   --'01/'+pmonth+'/'+pyear,pdateformat);
    set @v_todt   = @pmonth +'/15/'+@pyear   --to_date('15/'+pmonth+'/'+pyear,pdateformat);
end
else if @pday_period='2' begin--for 16 to last day of month
    set @v_frdt   =@pmonth +'/16/'+@pyear--to_date('16/'+pmonth+'/'+pyear,pdateformat);
    set @v_todt   =dbo.getlastdayofmonth(@v_frdt)
end
else        
begin
    set @v_frdt   =@pmonth +'/01/'+@pyear --to_date('01/'+pmonth+'/'+pyear,pdateformat);
    set @v_todt   =dbo.getlastdayofmonth(@v_frdt);
end

declare cur_data cursor for
select x.comp_code,(select "Comp_Name" from comp_mst where "Comp_Code"=x.comp_code) as comp_name,
x.unit_code,(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=x.unit_code) as unit_name,
x.state_name,x.dist_name,x.taluka_name,x.city_code,x.city_name,x.zone_code,x.region_code,x.branch_code,
(select "Branch_Name" from branch_mst where "Branch_Code"=x.branch_code) as branch_name,
x.bill_pay,x.supdate, sum(x.sup_copy) sup_copy
from(
select b.comp_code,b.unit_code,b.publ,e.main_edtn,b.edtn,e.edtn_name,dbo.cir_get_state(b.comp_code,m.country_code,m.state_code) state_name,
dbo.cir_get_dist(b.comp_code,m.state_code,m.dist_code) as dist_name,
dbo.cir_get_taluka(b.comp_code,m.tehsil_taluka) taluka_name,m.city_code,c.city_name,
c.zone_code, c.region_code,m.branch_code,
b.supdate ,case isnull(s.bill_pay,'N') when 'Y' then 'BILLED' else 'UNBILLED' END bill_pay,
sum(b.sup_copy) sup_copy
from cir_dbksup b,cir_agmast m,cir_edtn_mast e ,cir_city_mast c,cir_supply_type_mast s
where b.comp_code=@pcompcode and b.comp_code=m.comp_code and b.comp_code=e.comp_code and b.comp_code=c.comp_code and b.comp_code=s.comp_code and
b.unit_code=isnull(@punitcode,b.unit_code) and b.unit_code=m.unit and b.agcd=m.agcd and b.dpcd=m.dpcd and
b.publ=e.publ and b.publ=isnull(@ppublcode,b.publ) and b.edtn=e.edtn and b.edtn=isnull(@pedtncode,b.edtn) and  
b.supdate between @v_frdt and @v_todt and b.sup_type_code=s.sup_ty_code and  
e.main_edtn=isnull(@pmedtncode,e.main_edtn) and (m.ag_type=@pagtype or @pagtype is null) and (m.ag_class=@pagclass or @pagclass is null) and
(m.branch_code=@pbrancode or @pbrancode is null) and m.city_code=c.city_code
group by b.comp_code,b.unit_code,b.publ,e.main_edtn,b.edtn,m.state_code,m.country_code,m.dist_code,m.tehsil_taluka,
e.edtn_name,b.edtn,b.supdate ,isnull(s.bill_pay,'N'),
m.city_code,c.city_name,c.zone_code,c.region_code,m.branch_code) x
group by x.comp_code,x.unit_code,x.publ,x.main_edtn,x.edtn,x.edtn_name,x.state_name,
x.dist_name,x.taluka_name,x.city_code,x.city_name,x.zone_code,x.region_code,x.branch_code,
x.bill_pay,supdate

OPEN cur_data 
	fetch NEXT FROM cur_data into @v_comp_code,@v_comp_name,@v_unit_code,@v_unit_name,@v_state_code,@v_dist_code,@v_tehsil_taluka,@v_city_code,@v_city_name,@v_zone_code,@v_region_code,@v_branch_code,@v_edtn_name,@v_bill_pay,@v_supdate,@v_sup_copy
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
			set @v_zone_name     =dbo.cir_get_zone_name(@v_comp_code,@v_zone_code)
			set @v_region_name   =dbo.cir_get_region_name(@v_comp_code,@v_region_code)
			insert into #cir_ledger_report
            (comp_code, credit_head,unit_code,agname, branch_code, billno, recptno, debit_head,chqno,chq_bank, agcd, remarks,  
                reason,rec_seqno,billdt,sess_id)
            values
            (@v_comp_code,@v_comp_name,@v_unit_code,@v_unit_name,@v_branch_code,isnull(@v_edtn_name,'NOT DEFINE'),isnull(@v_state_code,'NOT DEFINE'),isnull(@v_dist_code,'NOT DEFINE'),isnull(@v_tehsil_taluka,'NOT DEFINE'),isnull(@v_zone_name,'NOT DEFINE'),isnull(@v_region_name,'NOT DEFINE'),isnull(@v_city_name,'NOT DEFINE'),
            @v_bill_pay,@v_sup_copy, @v_supdate,@v_sess_id);	
				
	fetch NEXT FROM cur_data into @v_comp_code,@v_comp_name,@v_unit_code,@v_unit_name,@v_state_code,@v_dist_code,@v_tehsil_taluka,@v_city_code,@v_city_name,@v_zone_code,@v_region_code,@v_branch_code,@v_edtn_name,@v_bill_pay,@v_supdate,@v_sup_copy
END 	
close cur_data
DEALLOCATE cur_data

set @v_supdate=null;
declare c1 cursor for
	select distinct billdt,datepart(dd,billdt) sday from #cir_ledger_report
    where sess_id=@@spid order by billdt
-- end here --
OPEN c1	 
	fetch NEXT FROM c1 into @v_supdate,@v_sday
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
			if (@vvar is null or @vvar = '') begin 
				set @vvar        ='case datepart(dd,billdt) when '+''''+@v_sday+''''+' then a.rec_seqno else 0 end "'+@v_sday+'"';
				set @tot_vvar    ='sum("'+@v_sday+'") "'+@v_sday+'"';
				
			end
			else
			begin
				set @vvar        =@vvar+','+'case when to_char(a.billdt,''dd'')='+''''+@v_sday+''''+' then a.rec_seqno else 0 end "'+@v_sday+'"';
				set @tot_vvar    =@tot_vvar+','+'sum("'+@v_sday+'") "'+@v_sday+'"'
				
			end
				
				
	fetch NEXT FROM c1 into @v_supdate,@v_sday
END 	
close c1
DEALLOCATE c1


		if @vvar is null or @vvar ='' begin
            set @v_query1='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                    a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, a.rec_seqno as "TOTAL"
                    from #cir_ledger_report a
                    where sess_id='+@v_sess_id+') x
                    group by x.comp_code, x.comp_name,x.unit_code,x.unit_name, x.branch_code,x.branch_name,x.reason
                    order by x.comp_code, x.comp_name,x.unit_code,x.unit_name,x.reason,x.branch_code,x.branch_name';
                    
        set @v_query2='select x.comp_code as comp_code, x.comp_name as comp_name,x.unit_code as unit_code,x.unit_name as unit_name,
                 x.branch_code as branch_code,x.branch_name as branch_name,x.reason, sum(x.TOTAL) as "TOTAL" from';            
        
        --print(v_query2+v_query1)    
        exec(@v_query2+@v_query1);
            
        set @v_query3='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                    a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, a.rec_seqno as "TOTAL"
                    from #cir_ledger_report a
                    where sess_id='+@v_sess_id+') x
                    group by x.comp_code, x.comp_name,x.unit_code,x.unit_name,x.reason
                    order by x.comp_code, x.comp_name,x.unit_code,x.unit_name,x.reason';
                    
        set @v_query4='select x.comp_code as comp_code, x.comp_name as comp_name,x.unit_code as unit_code,x.unit_name as unit_name,
                 x.reason, sum(x.TOTAL) as "TOTAL" from';
            
        print(@v_query4+@v_query3)    
        exec(@v_query4+@v_query3)
            
        set @v_query5='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                    a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, a.rec_seqno as "TOTAL"
                    from #cir_ledger_report a
                    where sess_id='+@v_sess_id+') x
                    group by x.comp_code, x.comp_name,x.unit_code,x.unit_name
                    order by x.comp_code, x.comp_name,x.unit_code,x.unit_name';
                    
        set @v_query6='select x.comp_code as comp_code, x.comp_name as comp_name,x.unit_code as unit_code,x.unit_name as unit_name,
                   sum(x.TOTAL) as "TOTAL" from';



		print(@v_query6+@v_query5)    
		exec(@v_query6+@v_query5)
        
        end
        else
        begin
            if @preptype='1' begin--for Pcenter wise
            set @v_query1='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                        a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+@v_sess_id+') x
                        group by x.comp_code, x.comp_name,x.unit_code,x.unit_name,x.reason
                        order by x.comp_code, x.comp_name,x.unit_code,x.unit_name,x.reason';
                        
            set @v_query2='select x.comp_code as comp_code, x.comp_name as comp_name,x.unit_code as unit_code,x.unit_name as unit_name,
                     x.reason, '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';            
                
            set @v_query3='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                        a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+@v_sess_id+') x
                        group by x.comp_code, x.comp_name,x.reason
                        order by x.comp_code, x.comp_name,x.reason';
                        
            set @v_query4='select x.comp_code as comp_code, x.comp_name as comp_name,
                     x.reason, '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';
                
            set @v_query5='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                        a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+@v_sess_id+') x
                        group by x.comp_code, x.comp_name
                        order by x.comp_code, x.comp_name';
                        
            set @v_query6='select x.comp_code as comp_code, x.comp_name as comp_name,
                     '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';            
		end
        Else if @preptype='2' begin--for Pcenter wise branch wise
            set @v_query1='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                        a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+@v_sess_id+') x
                        group by x.comp_code, x.comp_name,x.unit_code,x.unit_name, x.branch_code,x.branch_name,x.reason
                        order by x.comp_code, x.comp_name,x.unit_code,x.unit_name,x.reason,x.branch_code,x.branch_name';
                        
            set @v_query2='select x.comp_code as comp_code, x.comp_name as comp_name,x.unit_code as unit_code,x.unit_name as unit_name,
                     x.branch_code as branch_code,x.branch_name as branch_name,x.reason, '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';            
                
            set @v_query3='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                        a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+@v_sess_id+') x
                        group by x.comp_code, x.comp_name,x.unit_code,x.unit_name,x.reason
                        order by x.comp_code, x.comp_name,x.unit_code,x.unit_name,x.reason';
                        
            set @v_query4='select x.comp_code as comp_code, x.comp_name as comp_name,x.unit_code as unit_code,x.unit_name as unit_name,
                     x.reason, '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';
                
            set @v_query5='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                        a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from cir_ledger_report a
                        where sess_id='+@v_sess_id+') x
                        group by x.comp_code, x.comp_name,x.unit_code,x.unit_name
                        order by x.comp_code, x.comp_name,x.unit_code,x.unit_name';
                        
            set @v_query6='select x.comp_code as comp_code, x.comp_name as comp_name,x.unit_code as unit_code,x.unit_name as unit_name,
                     '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';            
        end    
        Else if @preptype='3' begin--for Zone wise
            set @v_query1='(select a.comp_code as comp_code, a.credit_head as comp_name,a.chq_bank as zone_name,
                        a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+@v_sess_id+') x
                        group by x.comp_code, x.comp_name,x.zone_name,x.reason
                        order by x.comp_code, x.comp_name,x.zone_name,x.reason';
                        
            set @v_query2='select x.comp_code as comp_code, x.comp_name as comp_name,x.zone_name as zone_name,
                     x.reason, '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';    
                     
                     
                     --open p_accounts for v_query2+v_query1;        
                
            set @v_query3='(select a.comp_code as comp_code, a.credit_head as comp_name,a.chq_bank as zone_name,
                        a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+@v_sess_id+') x
                        group by x.comp_code, x.comp_name,x.reason
                        order by x.comp_code, x.comp_name,x.reason';
                        
            set @v_query4='select x.comp_code as comp_code, x.comp_name as comp_name,
                     x.reason, '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';
                     
                     --open p_accounts1 for v_query4+v_query3;
                
            set @v_query5='(select a.comp_code as comp_code, a.credit_head as comp_name,a.chq_bank as zone_name,
                        a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+@v_sess_id+') x
                        group by x.comp_code, x.comp_name
                        order by x.comp_code, x.comp_name';
                        
            set @v_query6='select x.comp_code as comp_code, x.comp_name as comp_name,
                     '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';
                     
                     --open p_accounts2 for v_query6+v_query5;

        end   
        Else if @preptype='4' begin--for Zone wise Region wise
            set @v_query1='(select a.comp_code as comp_code, a.credit_head as comp_name,a.chq_bank as zone_name,a.exec_code as region_name,
                        a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+@v_sess_id+') x
                        group by x.comp_code, x.comp_name,x.zone_name,x.reason,x.region_name
                        order by x.comp_code, x.comp_name,x.zone_name,x.reason,x.region_name';
                        
            set @v_query2='select x.comp_code as comp_code, x.comp_name as comp_name,x.zone_name as zone_name,x.region_name as region_name,
                     x.reason, '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';            
                
            set @v_query3='(select a.comp_code as comp_code, a.credit_head as comp_name,a.chq_bank as zone_name,a.exec_code as region_name,
                        a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+@v_sess_id+') x
                        group by x.comp_code, x.comp_name,x.zone_name,x.reason
                        order by x.comp_code, x.comp_name,x.zone_name,x.reason';
                        
            set @v_query4='select x.comp_code as comp_code, x.comp_name as comp_name,x.zone_name,
                     x.reason, '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';
                
            set @v_query5='(select a.comp_code as comp_code, a.credit_head as comp_name,a.chq_bank as zone_name, a.exec_code as region_name,
                        a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+@v_sess_id+') x
                        group by x.comp_code, x.comp_name,x.zone_name
                        order by x.comp_code, x.comp_name,x.zone_name';
                        
            set @v_query6='select x.comp_code as comp_code, x.comp_name as comp_name,x.zone_name,
                     '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';
		end
        Else if @preptype='5' begin--for State wise
            set @v_query1='(select a.comp_code as comp_code, a.credit_head as comp_name,a.recptno as state_name,
                        a.debit_head as dist_name,a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+@v_sess_id+') x
                        group by x.comp_code, x.comp_name,x.state_name,x.reason
                        order by x.comp_code, x.comp_name,x.state_name,x.reason';
                        
            set @v_query2='select x.comp_code as comp_code, x.comp_name as comp_name,x.state_name as state_name,
                      x.reason, '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';
                
            set @v_query3='(select a.comp_code as comp_code, a.credit_head as comp_name,a.recptno as state_name,
                        a.debit_head as dist_name,a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+@v_sess_id+') x
                        group by x.comp_code, x.comp_name,x.state_name
                        order by x.comp_code, x.comp_name,x.state_name';
                        
            set @v_query4='select x.comp_code as comp_code, x.comp_name as comp_name,x.state_name as state_name,
                       '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';
                
            set @v_query5='(select a.comp_code as comp_code, a.credit_head as comp_name,a.recptno as state_name,
                        a.debit_head as dist_name,a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+@v_sess_id+') x
                        group by x.comp_code, x.comp_name
                        order by x.comp_code, x.comp_name';
                        
            set @v_query6='select x.comp_code as comp_code, x.comp_name as comp_name,
                     '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';
		end
        else--for State wise district wise
        begin
            set @v_query1='(select a.comp_code as comp_code, a.credit_head as comp_name,a.recptno as state_name,
                        a.debit_head as dist_name,a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+@v_sess_id+') x
                        group by x.comp_code, x.comp_name,x.state_name, x.dist_name,x.reason
                        order by x.comp_code, x.comp_name,x.state_name,x.reason,x.dist_name';
                        
            set @v_query2='select x.comp_code as comp_code, x.comp_name as comp_name,x.state_name as state_name,
                     x.dist_name as dist_name,x.reason, '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';            
                
            set @v_query3='(select a.comp_code as comp_code, a.credit_head as comp_name,a.recptno as state_name,
                        a.debit_head as dist_name,a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+@v_sess_id+') x
                        group by x.comp_code, x.comp_name,x.state_name, x.reason
                        order by x.comp_code, x.comp_name,x.state_name,x.reason';
                        
            set @v_query4='select x.comp_code as comp_code, x.comp_name as comp_name,x.state_name as state_name,
                     x.reason, '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';
                
            set @v_query5='(select a.comp_code as comp_code, a.credit_head as comp_name,a.recptno as state_name,
                        a.debit_head as dist_name,a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+@v_sess_id+') x
                        group by x.comp_code, x.comp_name,x.state_name
                        order by x.comp_code, x.comp_name,x.state_name';
                        
            set @v_query6='select x.comp_code as comp_code, x.comp_name as comp_name,x.state_name as state_name,
                     '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';            

        End
        end

print(@v_query2+@v_query1)
exec(@v_query2+@v_query1)
 
print(@v_query4+@v_query3)
exec(@v_query4+@v_query3)   

print(@v_query6+@v_query5)
exec(@v_query6+@v_query5) 
drop table #cir_ledger_report    
SET CONCAT_NULL_YIELDS_NULL On

//-----------------------------------------05/03/2012------------------

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE cir_rep_billing_cir_bill_print_bhaskar
	@pcomp_code                               VARCHAR(40) ,
	@punit_code                               VARCHAR(40) ,
	@ppubl                                    VARCHAR(40) ,
	@pbill_freq                               VARCHAR(40) ,
	@pfrom_billdt                             DATETIME,
	@ptill_billdt                             DATETIME ,
	@pfrom_billno                             VARCHAR(40) ,
	@ptill_billno                             VARCHAR(40) ,
	@pbillagcd                                VARCHAR(40) ,
	@pbilldpcd                                VARCHAR(40) ,
	@pdateformat                              VARCHAR(40) ,
	@pextra1                                  VARCHAR(40) ,--for Agency Class
	@pextra2                                  VARCHAR(40)--for Agency Type 
AS 

	If @ppubl='' Begin
		set @ppubl=null
	End
	If @pfrom_billno='' Begin
		set @pfrom_billno=null
	End
	If @pbillagcd='' Begin
		set @pbillagcd=null
	End
	If @pbilldpcd='' Begin
		set @pbilldpcd=null
	End
	If @punit_code='' Begin
		set @punit_code=null
	End			
	DECLARE @v_bill_frdt                              DATETIME 
	DECLARE @v_bill_todt                              DATETIME 
	DECLARE @v_dt                                     DATETIME 

	DECLARE @rec_bill_comp_code                       VARCHAR(8) 
	DECLARE @rec_bill_unit_code                       VARCHAR(8) 
	DECLARE @rec_bill_publ                            VARCHAR(10) 
	DECLARE @rec_bill_agcd                            VARCHAR(8) 
	DECLARE @rec_bill_dpcd                            VARCHAR(8) 
	DECLARE @rec_bill_billno                          VARCHAR(40) 
	DECLARE @rec_bill_billdt                          DATETIME 
	DECLARE @rec_bill_frdt                            DATETIME 
	DECLARE @rec_bill_todt                            DATETIME 

	DECLARE cur_bill CURSOR FOR
	select distinct b.comp_code,b.unit_code,b.publ,b.agcd,b.dpcd,b.billno,b.billdt,min(b.bill_frdt) frdt,max(b.bill_todt) todt 
	from cir_bill b,cir_agmast m
                where b.comp_code=m.comp_code and b.comp_code=@pcomp_code and b.unit_code=isnull(@punit_code,b.unit_code) and b.unit_code=m.unit and 
                b.billdt between @pfrom_billdt and @ptill_billdt and
                b.bill_flag=@pbill_freq and ((b.billno between @pfrom_billno and @ptill_billno) or (@pfrom_billno is null)) and-- 
                            b.publ=isnull(@ppubl,b.publ) and b.agcd=isnull(@pbillagcd,b.agcd) and b.agcd=m.agcd and
                            b.dpcd=isnull(@pbilldpcd,b.dpcd) and b.dpcd=m.dpcd and (m.ag_class=@pextra1 or @pextra1 is null or @pextra1='') and
                            (m.ag_type=@pextra2 or @pextra2 is null  or @pextra2='') 
            group by b.comp_code,b.unit_code,b.publ,b.agcd,b.dpcd,b.billno,b.billdt
            order by b.comp_code,b.unit_code,b.publ,b.billdt,b.billno,b.agcd,b.dpcd; 
		

    	DECLARE @rec_dbksup_comp_code                     VARCHAR(8) 
		DECLARE @rec_dbksup_unit_code                     VARCHAR(8) 
		DECLARE @rec_dbksup_publ                          VARCHAR(10) 
		DECLARE @rec_dbksup_edtn                          VARCHAR(10) 
		DECLARE @rec_dbksup_supdate                       DATETIME 
		DECLARE @rec_dbksup_copy_rate                     NUMERIC(10,4) 
		DECLARE @rec_dbksup_comm_fix_auto_spl             VARCHAR(1) 
		DECLARE @rec_dbksup_comm_code                     VARCHAR(6) 
		DECLARE @rec_dbksup_supply_copy                   NUMERIC(10) 
		DECLARE @count									  INT

CREATE TABLE #CIR_BILL_PRINT
( COMP_CODE      VARCHAR(8),
  UNIT_CODE      VARCHAR(8),
  BILLNO         VARCHAR(20),
  BILLDT         DATETIME,
  PUBL_CODE      VARCHAR(8),
  EDTN_CODE      VARCHAR(8),
  AGCD           VARCHAR(8),
  DPCD           VARCHAR(8),
  SUPPLY_DATE    DATETIME,
  SUPPLY_COPY    NUMERIC(10),
  SUPPLY_RATE    NUMERIC(10,2),
  COMM_RATE      NUMERIC(12,2),
  SUR_RATE       NUMERIC(10,2),
  RETURN_COPY    NUMERIC(10),
  RETURN_AMT     NUMERIC(14,2),
  CUR_SESSIONID  NUMERIC(10),
  GROSS_AMT      NUMERIC(15,2)                   DEFAULT 0,
  COMM_AMT       NUMERIC(15,5)                   DEFAULT 0,
  SUR_AMT        NUMERIC(15,2),
  SEC_AMT        NUMERIC(15,2)                   DEFAULT 0,
  BRANCH_CODE    VARCHAR(8),
  REC_AMT        NUMERIC(15,2)                   DEFAULT 0)
  
		DECLARE cur_publ_edtn CURSOR FOR 
		SELECT DISTINCT
				 comp_code, unit_code, publ_code,
				 DBO.cir_get_publ_name(comp_code, publ_code) publ_name,
				 edtn_code edtn,
				 DBO.cir_get_edtn_name(comp_code, edtn_code) edtn_name
		FROM  #cir_bill_print 
		ORDER BY comp_code, unit_code, publ_code, edtn_code 
		
		DECLARE @v1						VARCHAR(200)
		DECLARE @v_cnt                  INT                           
		DECLARE @v_return_copy          INT
		DECLARE @v_return_amt           NUMERIC(14,2)
		DECLARE @v_gross_amt            NUMERIC(14,2)                   
		DECLARE @v_comm_rate            FLOAT 
		DECLARE @v_comm_amt             NUMERIC(14,2)                   
		DECLARE @v_sur_rate             FLOAT 
		DECLARE @v_sur_amt              NUMERIC(14,2)                   
		DECLARE @v_opdate               DATETIME 
		DECLARE @v_opbal                NUMERIC(14,2)                   
		DECLARE @v_billamt              NUMERIC(14,2)                   
		DECLARE @v_dbcramt              NUMERIC(14,2)                   
		DECLARE @v_dbamt                NUMERIC(14,2)                   
		DECLARE @v_cramt                NUMERIC(14,2)                   
		DECLARE @v_recamt               NUMERIC(14,2)                   
BEGIN
		
		SET @v_cnt			= 0 
		SET @v_return_amt	= 0
		SET @v_gross_amt	= 0 
		SET @v_comm_amt		= 0 
		SET @v_sur_amt		= 0 
		SET @v_opbal		= 0 
		SET @v_billamt		= 0 
		SET @v_dbcramt		= 0 
		SET @v_dbamt		= 0 
		SET @v_cramt		= 0 
		SET @v_recamt		= 0 
		SET @count			= 1 
		SET @v_bill_frdt	= @pfrom_billdt--DBO.convert_user_date('/', @pfrom_billdt,@pdateformat)
        SET @v_bill_todt	= @ptill_billdt--DBO.convert_user_date('/', @ptill_billdt,@pdateformat)
		SET @v_opdate		= DBO.cir_get_finandt(@pcomp_code, @v_bill_frdt, @pdateformat, '', '')



		CREATE TABLE #CIR_TEMP_OUTSTANDING(
		COMP_CODE	varchar(8) ,
		UNIT_CODE	varchar(8) ,
		DT			datetime ,
		PUBL_CODE	varchar(8) ,
		AGCD		varchar(8) ,
		DPCD		varchar(8) ,
		BILL_AMT	numeric(15, 2) DEFAULT ((0)),
		RETURN_AMT	numeric(15, 2) DEFAULT ((0)),
		DN_AMT		numeric(15, 2) DEFAULT ((0)),
		CN_AMT		numeric(15, 2) DEFAULT ((0)),
		REC_AMT		numeric(15, 2) DEFAULT ((0)),
		AGNAME		varchar(200) ,
		AGNAME_OTH_LANG varchar(250),
		CITY_CODE	varchar(20),
		TALUKA_CODE varchar(20),
		DIST_CODE	varchar(20),
		STATE_CODE	varchar(20),
		COUNTRY_CODE varchar(20),
		OP_AMT		numeric(15, 2))

		CREATE TABLE #CIR_TEMP_BILL_COLLECTION(
		COMP_CODE	varchar(8),	UNIT_CODE	varchar(8),	BILLNO	varchar(20),
		BILLDT		datetime ,PUBL_CODE	varchar(8),	AGCD	varchar(8) ,
		DPCD		varchar(8) ,SUPPLY_COPY numeric(10,0)	DEFAULT 0,GROSS_AMT	numeric(15,2)	DEFAULT 0,
		COMM_AMT	numeric(15,2)	DEFAULT 0,SUR_AMT		numeric(15,2)	DEFAULT 0,
		RETURN_COPY numeric(10,0)	DEFAULT 0,RETURN_AMT	numeric(15,2)	DEFAULT 0,
		DN_AMT		numeric(15,2)	DEFAULT 0,CN_AMT		numeric(15,2)	DEFAULT 0,
		REC_AMT		numeric(15,2)	DEFAULT 0,PREV_BAL		numeric(15,2)	DEFAULT 0,
		CUR_SESSIONID numeric(18,0),AGNAME		varchar(200),AGNAME_OTH_LANG varchar(250),
		CITY_CODE	varchar(20),TALUKA_CODE varchar(20),DIST_CODE	varchar(20),STATE_CODE	varchar(20),REMARKS		varchar(500))
		
		OPEN cur_bill 
			fetch NEXT FROM cur_bill INTO 
								@rec_bill_comp_code, @rec_bill_unit_code, @rec_bill_publ, 
								@rec_bill_agcd, @rec_bill_dpcd, @rec_bill_billno, @rec_bill_billdt, @rec_bill_frdt, @rec_bill_todt
			WHILE (@@FETCH_STATUS = 0) BEGIN

				--print('1')print(@v_dt)

				WHILE (0 = 0) BEGIN 
					IF @v_dt >= @rec_bill_todt BEGIN 
						BREAK
					END
					ELSE BEGIN 
						IF @v_dt is null BEGIN 
							SET @v_dt  = @rec_bill_frdt 
						END
						ELSE BEGIN 
							SET @v_dt  = @v_dt + 1 
						END
		   			END

					DECLARE cur_dbksup CURSOR local FOR 
					SELECT d.comp_code comp_code, d.unit_code unit_code, d.publ publ,d.edtn edtn , d.supdate supdate, d.sup_rate copy_rate, 
					d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,SUM(d.sup_copy) supply_copy
					FROM  cir_dbksup d,cir_supply_type_mast s
					WHERE d.comp_code=s.comp_code and d.comp_code  = @rec_bill_comp_code
					AND d.unit_code  = @rec_bill_unit_code	 AND d.publ  = ISNULL(@ppubl ,d.publ) AND 
					d.supdate  = @v_dt AND d.billagcd	 = @rec_bill_agcd AND d.billdpcd  = @rec_bill_dpcd
					AND d.sup_type_code=s.sup_ty_code and UPPER(s.bill_pay)  = 'Y'
					GROUP BY d.comp_code, d.unit_code, d.publ, d.edtn, d.supdate, d.sup_rate, d.comm_fix_auto_spl, d.comm_code 
					ORDER BY comp_code, unit_code, publ, edtn, supdate 

					OPEN cur_dbksup 
						FETCH NEXT FROM cur_dbksup INTO 
										@rec_dbksup_comp_code, @rec_dbksup_unit_code, @rec_dbksup_publ, 
										@rec_dbksup_edtn, @rec_dbksup_supdate, @rec_dbksup_copy_rate, 
										@rec_dbksup_comm_fix_auto_spl, @rec_dbksup_comm_code, @rec_dbksup_supply_copy
					WHILE (@@FETCH_STATUS = 0) BEGIN

						SELECT @v_return_copy  =  SUM(ISNULL(apr_late_recpt, 0) + ISNULL(apr_short_recpt, 0) + ISNULL(apr_bnr, 0) + ISNULL(apr_unsold, 0)),@v_return_amt  =  0
						FROM  cir_unsold_dtl 
						WHERE comp_code  = @rec_bill_comp_code AND unit_code  = @rec_bill_unit_code AND doctype  = 'UCN'
						AND recptdt  = @rec_dbksup_supdate AND publ  = @rec_dbksup_publ AND edtn  = @rec_dbksup_edtn
						AND agcd  = @rec_bill_agcd AND dpcd  = @rec_bill_dpcd
						AND (ISNULL(apr_late_recpt, 0) + ISNULL(apr_short_recpt, 0) + ISNULL(apr_bnr, 0) + ISNULL(apr_unsold, 0))  > 0
					
						SET @v_gross_amt  = ISNULL(ROUND((@rec_dbksup_supply_copy * @rec_dbksup_copy_rate), 2), 0)
						SET @v_comm_rate  = 0 
						SET @v_comm_amt   = ISNULL(ROUND((@rec_dbksup_supply_copy * @v_comm_rate), 2), 0)
						SET @v_sur_rate   = 0 
						SET @v_sur_amt  = ISNULL(ROUND((@rec_dbksup_supply_copy * @v_sur_rate), 2), 0)
					
						INSERT INTO  #cir_bill_print   
							(comp_code , unit_code , billno , billdt , publ_code , 
							edtn_code , agcd , dpcd , supply_date , supply_copy , supply_rate , 
							gross_amt , comm_rate , comm_amt , sur_rate , sur_amt , return_copy , return_amt)  
						VALUES ( @rec_bill_comp_code , @rec_bill_unit_code , @rec_bill_billno , @rec_bill_billdt , @rec_dbksup_publ , 
							@rec_dbksup_edtn , @rec_bill_agcd , @rec_bill_dpcd , @rec_dbksup_supdate , 
							@rec_dbksup_supply_copy , @rec_dbksup_copy_rate , @v_gross_amt , @v_comm_rate , 
							@v_comm_amt , @v_sur_rate , @v_sur_amt , @v_return_copy , @v_return_amt )  
					
						FETCH NEXT FROM cur_dbksup INTO 
										@rec_dbksup_comp_code, @rec_dbksup_unit_code, @rec_dbksup_publ, 
										@rec_dbksup_edtn, @rec_dbksup_supdate, @rec_dbksup_copy_rate, 
										@rec_dbksup_comm_fix_auto_spl, @rec_dbksup_comm_code, @rec_dbksup_supply_copy
					END

				CLOSE cur_dbksup
				DEALLOCATE cur_dbksup
			END

			SET @v_opbal  = DBO.cir_accounts_cir_agency_opbal(@rec_bill_comp_code, @rec_bill_unit_code, null, @rec_bill_agcd, @rec_bill_dpcd, @v_opdate, 'NM', @pdateformat, '', '')+ DBO.cir_accounts_cir_agency_ytodt(@rec_bill_comp_code, @rec_bill_unit_code, null, @rec_bill_agcd, @rec_bill_dpcd, @v_opdate, @rec_bill_frdt, 'NM', @pdateformat, '', '')
			
			SELECT @v_billamt  =  SUM(bill_amount) FROM  cir_bill 
			WHERE comp_code = @rec_bill_comp_code AND unit_code  = @rec_bill_unit_code
			 AND agcd  = @rec_bill_agcd AND dpcd  = @rec_bill_dpcd
			 AND billdt  >= @rec_bill_frdt AND billdt  <= @rec_bill_todt /* and publ=rec_bill_publ*/
			
			SELECT @v_dbcramt  =  SUM(amount) FROM  cir_outmast 
			WHERE comp_code  = @rec_bill_comp_code AND unit_code  = @rec_bill_unit_code
			 AND agcd  = @rec_bill_agcd AND dpcd  = @rec_bill_dpcd AND recptdt  >= @rec_bill_frdt
			 AND recptdt  <= @rec_bill_todt AND doctyp  <> 'BIL' AND achd  = 'NM' /*and publ=rec_bill_publ*/
			
			SELECT @v_dbamt  =  SUM(amount) FROM cir_outmast 
			WHERE comp_code  = @rec_bill_comp_code AND unit_code  = @rec_bill_unit_code
			 AND agcd  = @rec_bill_agcd AND dpcd  = @rec_bill_dpcd AND recptdt  >= @rec_bill_frdt
			 AND recptdt  <= @rec_bill_billdt AND doctyp  NOT IN ( 'BIL'  , 'RCR'  ) AND achd  = 'NM'
			 AND amount  > 0
			
			SELECT @v_cramt  =  SUM(amount) FROM  cir_outmast 
			WHERE comp_code  = @rec_bill_comp_code AND unit_code  = @rec_bill_unit_code
			 AND agcd  = @rec_bill_agcd AND dpcd  = @rec_bill_dpcd
			 AND recptdt  >= @rec_bill_frdt AND recptdt  <= @rec_bill_billdt
			 AND doctyp  NOT IN ( 'BIL'  , 'RCR'  )
			 AND achd  = 'NM' AND amount  < 0
			
			SELECT @v_recamt  =  SUM(amount) FROM  cir_outmast 
			WHERE comp_code  = @rec_bill_comp_code AND unit_code  = @rec_bill_unit_code
			 AND agcd  = @rec_bill_agcd AND dpcd  = @rec_bill_dpcd
			 AND recptdt  >= @rec_bill_frdt AND recptdt  <= @rec_bill_billdt
			 AND doctyp  = 'RCR' AND achd  = 'NM' /*and publ=rec_bill_publ*/

			SET @v_opbal  = ISNULL(@v_opbal, 0)+ ISNULL(@v_recamt, 0)
			
			INSERT INTO  #cir_temp_outstanding (comp_code , unit_code , dt , agname , publ_code , agcd , dpcd , dn_amt , cn_amt , rec_amt , op_amt )  
			 VALUES (@rec_bill_comp_code , @rec_bill_unit_code , 
					@rec_bill_billdt , @rec_bill_billno , '' , /*rec_bill_publ,*/ /*rec_bill_publ,*/ @rec_bill_agcd , 
					@rec_bill_dpcd , @v_dbamt , @v_cramt ,@v_recamt , @v_opbal )  
			
			INSERT INTO  #cir_temp_bill_collection   
					(comp_code , unit_code , billno , billdt , remarks , cur_sessionid )  
			 VALUES (@rec_bill_comp_code , @rec_bill_unit_code , @rec_bill_billno , @rec_bill_billdt , '' , @@SPID )  
			
			SET @v_opbal	= 0 
			SET @v_billamt  = 0 
			SET @v_dbcramt  = 0 
			SET @v_dbamt	= 0 
			SET @v_cramt	= 0 
			SET @v_recamt	= 0
			SET @v_dt		=NULL
				FETCH NEXT FROM cur_bill INTO 
								@rec_bill_comp_code, @rec_bill_unit_code, @rec_bill_publ, 
								@rec_bill_agcd, @rec_bill_dpcd, @rec_bill_billno, @rec_bill_billdt, @rec_bill_frdt, @rec_bill_todt
		END
		CLOSE cur_bill

		SELECT b.comp_code comp_code, b.unit_code unit_code,
				 b.agcd agcd,b.dpcd dpcd,a.ag_name ag_name, a.ag_name_oth_lang ag_name_oth_lang,
				 a.addr1 addr1, a.addr2 addr2,a.addr3 addr3,
				 DBO.cir_get_city(b.comp_code, a.city_code) city_name,
				 b.billno billno,b.billdt billdt, SUM(b.bill_copy) bill_copy,SUM(b.gross_amount) gross_amount,
				 SUM(b.sur_amount) sur_amount, SUM(b.comm_amount) comm_amount,SUM(b.bill_amount) bill_amount,
				 (SELECT MAX(d.comm_rate) FROM  cir_bill_det d 
				WHERE d.comp_code  = b.comp_code AND	d.unit_code  = b.unit_code
				 AND d.agcd  = b.agcd AND d.dpcd  = b.dpcd
				 AND d.billno  = b.billno AND	d.billdt  = b.billdt) comm_rate
		FROM  cir_agmast a, cir_bill b 
		WHERE a.comp_code  = @pcomp_code
		 AND a.unit  = b.unit_code
		 AND b.unit_code  = ISNULL(@punit_code,b.unit_code)
		 AND b.billdt  BETWEEN @v_bill_frdt  AND  @v_bill_todt
		 AND b.bill_flag  = @pbill_freq
		 AND ((b.billno BETWEEN @pfrom_billno  AND  @ptill_billno) OR (@pfrom_billno  IS NULL) OR (@pfrom_billno=''))
		 AND b.publ  = ISNULL(@ppubl,b.publ)
		 AND a.agcd  = b.agcd AND a.dpcd  = b.dpcd
		 AND b.agcd  = ISNULL(@pbillagcd,b.agcd)
		 AND b.dpcd  = ISNULL(@pbilldpcd,b.dpcd)
		GROUP BY b.comp_code, b.unit_code, b.agcd, b.dpcd, a.ag_name, a.ag_name_oth_lang,a.addr1, a.addr2, a.addr3,a.city_code,b.billno, b.billdt 
		ORDER BY b.comp_code, b.unit_code, b.billdt, b.billno, b.agcd, b.dpcd 
		INSERT INTO CIR_BILL_PRINT(COMP_CODE,BILLDT) VALUES('8',GETDATE());
		SELECT x.comp_code comp_code, x.unit_code unit_code, x.billno billno, x.billdt billdt,x.agcd agcd,x.dpcd dpcd,x.supdate supdate,
		x.supply_rate copy_rate,SUM(x.supply_copy) supply
		FROM (SELECT u.comp_code comp_code, u.unit_code unit_code, u.billno billno, u.billdt billdt, u.agcd agcd, u.dpcd dpcd, u.supply_date supdate, u.supply_rate supply_rate, SUM(u.supply_copy) supply_copy
			FROM  #cir_bill_print u 
			GROUP BY u.comp_code,u.unit_code,u.agcd,u.dpcd, u.supply_date, u.billno,u.billdt, u.supply_rate) x 
		GROUP BY x.comp_code, x.unit_code,x.billno,x.billdt,x.agcd, x.dpcd, x.supdate, x.supply_rate 
		ORDER BY comp_code, unit_code, billdt,billno, supdate, agcd,dpcd 

		SELECT x.comp_code comp_code, x.unit_code unit_code, x.billno billno, x.billdt billdt, x.agcd agcd, x.dpcd dpcd,
				 SUM(x.supply_copy) tot_supply, SUM(x.gross) gross_amt, SUM(x.return_copy) return_copy,
				 SUM(x.return_amt) return_amt,SUM(x.tot_amt) tot_amt, SUM(x.tot_comm) tot_comm,
				 SUM(x.tot_surcharge) tot_surcharge, SUM(x.net_amt) net_amt
		FROM (	SELECT u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.agcd agcd,u.dpcd dpcd,
					 SUM(u.supply_copy) supply_copy,SUM(u.gross_amt) gross,
					 SUM(u.return_copy) return_copy,SUM(u.return_amt) return_amt,
					 SUM(u.gross_amt - u.return_amt) tot_amt,
					 SUM(u.comm_amt) tot_comm, SUM(u.sur_amt) tot_surcharge,
					 SUM(u.gross_amt - u.return_amt - u.comm_amt + u.sur_amt) net_amt
			FROM  #cir_bill_print u 
		GROUP BY u.comp_code, u.unit_code, u.agcd, u.dpcd,u.billno, u.billdt) x
		GROUP BY x.comp_code,x.unit_code,x.billno,x.billdt, x.agcd, x.dpcd 
		ORDER BY comp_code, unit_code, billdt, billno, agcd,dpcd 

		SELECT x.comp_code comp_code,x.unit_code unit_code, x.billno billno, x.billdt billdt, x.agcd agcd, x.dpcd dpcd,SUM(x.gross) gross_amt
		FROM (SELECT u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.agcd agcd,u.dpcd dpcd,
			 SUM(u.gross_amt) gross
			FROM  #cir_bill_print u 
 		GROUP BY u.comp_code, u.unit_code, u.agcd, u.dpcd,u.billno, u.billdt) x
		GROUP BY x.comp_code, x.unit_code, x.billno,x.billdt, x.agcd, x.dpcd 
		ORDER BY comp_code, unit_code, billdt,billno, agcd, dpcd 
		
		SELECT comp_code, unit_code, billno, billdt, agcd,dpcd,SUM(return_copy) return_copy
		FROM (SELECT u.comp_code comp_code, u.unit_code unit_code,u.billno billno,u.billdt billdt,u.agcd agcd,u.dpcd dpcd,SUM(u.return_copy) return_copy
			FROM  #cir_bill_print u 
			GROUP BY u.comp_code, u.unit_code,u.agcd,u.dpcd,u.billno, u.billdt )x
		GROUP BY comp_code, unit_code, billno, billdt,agcd, dpcd 
		ORDER BY comp_code, unit_code, billdt, billno, agcd,dpcd 
		
		SELECT x.comp_code comp_code, x.unit_code unit_code,x.billno billno,x.billdt billdt,x.agcd agcd,x.dpcd dpcd,SUM(x.return_amt) return_amt
		FROM (SELECT u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.agcd agcd,u.dpcd dpcd,SUM(u.return_amt) return_amt
			FROM  #cir_bill_print u 
		GROUP BY u.comp_code, u.unit_code, u.agcd, u.dpcd, u.billno, u.billdt )x
		GROUP BY x.comp_code,x.unit_code, x.billno, x.billdt, x.agcd,x.dpcd 
		ORDER BY comp_code, unit_code, billdt, billno, agcd,dpcd 

		SELECT x.comp_code comp_code,x.unit_code unit_code, x.billno billno, x.billdt billdt, x.agcd agcd, x.dpcd dpcd,SUM(x.tot_amt) tot_amt
		FROM (SELECT u.comp_code comp_code, u.unit_code unit_code,u.billno billno,u.billdt billdt,u.agcd agcd,u.dpcd dpcd,SUM(u.gross_amt - u.return_amt) tot_amt
			FROM  #cir_bill_print u 
			GROUP BY u.comp_code,u.unit_code,u.agcd,u.dpcd, u.billno, u.billdt )x
		GROUP BY x.comp_code, x.unit_code, x.billno, x.billdt, x.agcd, x.dpcd 
		ORDER BY comp_code, unit_code, billdt, billno, agcd, dpcd
		
		SELECT x.comp_code comp_code, x.unit unit, x.billno billno, x.billdt billdt, x.agcd agcd, x.dpcd dpcd, SUM(x.tot_comm) tot_comm
		FROM (SELECT u.comp_code comp_code, u.unit_code unit, u.billno billno,u.billdt billdt,u.agcd agcd,u.dpcd dpcd,SUM(u.comm_amt) tot_comm
			FROM  cir_bill_det u 
			WHERE u.comp_code  = @pcomp_code AND	u.unit_code  = @punit_code
			 AND billdt  BETWEEN @v_bill_frdt  AND  @v_bill_todt
			 AND bill_flag  = @pbill_freq
			 AND ((billno  BETWEEN @pfrom_billno  AND  @ptill_billno) OR (@pfrom_billno  IS NULL))
			 AND (agcd  = @pbillagcd OR	@pbillagcd IS NULL OR @pbillagcd='')
			 AND (dpcd  = @pbilldpcd OR	@pbilldpcd IS NULL OR @pbilldpcd='')
			GROUP BY u.comp_code, u.unit_code, u.agcd,u.dpcd,u.billno, u.billdt )x
		GROUP BY x.comp_code, x.unit,x.billno,x.billdt, x.agcd,x.dpcd 
		ORDER BY comp_code, unit, billdt,billno,agcd,dpcd 
		
		SELECT x.comp_code comp_code,x.unit_code unit_code, x.billno billno,x.billdt billdt,x.agcd agcd,x.dpcd dpcd,SUM(x.tot_surcharge) tot_surcharge
		FROM (SELECT u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.agcd agcd,u.dpcd dpcd,SUM(u.sur_amt) tot_surcharge
			FROM  #cir_bill_print u 
		GROUP BY u.comp_code,u.unit_code,u.agcd,u.dpcd, u.billno, u.billdt ) x
		GROUP BY x.comp_code, x.unit_code, x.billno, x.billdt, x.agcd, x.dpcd 
		ORDER BY comp_code, unit_code, billdt, billno, agcd, dpcd 
		
		SELECT comp_code,unit_code, billno, billdt,agcd,dpcd,SUM(net_amt) net_amt
		FROM (SELECT u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.agcd agcd,u.dpcd dpcd,
			 SUM(u.gross_amt - u.return_amt - u.comm_amt + u.sur_amt) net_amt
			FROM  #cir_bill_print u 
		GROUP BY u.comp_code,u.unit_code, u.agcd, u.dpcd, u.billno,u.billdt )x
		GROUP BY comp_code, unit_code, billno,billdt, agcd,dpcd 
		ORDER BY comp_code, unit_code, billdt,billno, agcd,dpcd 
		
		SELECT comp_code,unit_code, dt billdt, agname billno,publ_code publ,agcd, dpcd,dn_amt AS "Debit Amt", cn_amt AS "Credit Amt",rec_amt AS "Receipt Amount",
		op_amt AS "Previous Balance"
		FROM  #cir_temp_outstanding
		
		SELECT comp_code,unit_code, billno,billdt,agcd, dpcd,copy_rate,SUM(bill_copy) bill_copy,SUM(ISNULL(copy_rate, 0) * ISNULL(bill_copy, 0)) gross_amt
		FROM  cir_bill_det 
		WHERE comp_code  = @pcomp_code AND unit_code  = @punit_code
		 AND billdt  BETWEEN @v_bill_frdt  AND  @v_bill_todt
		 AND bill_flag  = @pbill_freq
		 AND ((billno  BETWEEN @pfrom_billno  AND  @ptill_billno) OR (@pfrom_billno  IS NULL) OR (@pfrom_billno=''))
		 AND (agcd  = @pbillagcd OR	@pbillagcd IS NULL OR @pbillagcd='')
		 AND (dpcd  = @pbilldpcd OR	@pbilldpcd  IS NULL OR @pbilldpcd='')
		GROUP BY comp_code,unit_code, billno,billdt,agcd, dpcd,copy_rate 
		ORDER BY comp_code,unit_code, billdt,billno,agcd, dpcd 

		SELECT DISTINCT	 b.comp_code comp_code,b.unit_code unit_code,b.billno billno,b.billdt billdt,b.agcd agcd,b.dpcd dpcd,
				 (SELECT ISNULL(SUM(a.sup_copy), 0)
				FROM cir_dbksup a ,cir_supply_type_mast s
				WHERE b.comp_code  = a.comp_code AND a.comp_code  = s.comp_code AND a.unit_code  = b.unit_code
				 AND b.publ  = a.publ AND a.edtn  = b.edtn
				 AND a.sup_type_code=s.sup_ty_code
     			 AND s.bill_pay  = 'N' AND a.supdate BETWEEN @v_bill_frdt  AND  @v_bill_todt
				 AND a.billagcd  = b.agcd AND a.billdpcd  = b.dpcd) unpaid_copy
		FROM  cir_bill_det b 
		WHERE b.comp_code  = @pcomp_code AND	b.unit_code  = @punit_code
		 AND b.billdt  BETWEEN @v_bill_frdt  AND  @v_bill_todt
		 AND b.bill_flag  = @pbill_freq
		 AND ((b.billno  BETWEEN @pfrom_billno  AND  @ptill_billno) OR (@pfrom_billno  IS NULL) OR (@pfrom_billno=''))
		 AND (b.publ  = @ppubl OR @ppubl IS NULL OR @ppubl='') AND (b.agcd  = @pbillagcd OR @pbillagcd IS NULL OR @pbillagcd='')
		 AND (b.dpcd  = @pbilldpcd OR @pbilldpcd  IS NULL OR @pbilldpcd='') AND b.billdt  BETWEEN  @v_bill_frdt  AND  @v_bill_todt
		ORDER BY b.comp_code, b.unit_code, b.billno,b.billdt, b.agcd,b.dpcd 
		
		DROP TABLE #cir_BILL_PRINT;
		DROP TABLE #cir_temp_outstanding;
		DROP TABLE #cir_temp_bill_collection;
 DEALLOCATE cur_bill
 DEALLOCATE cur_publ_edtn

END

//---------------------------end---------------------------//

                                                                     
                                                                     
                                                                     
                                             
create PROCEDURE [dbo].[cir_rep_unsold_copybranch]
(
	 @pcomp_code         as varchar(200),
     @punit_code         as varchar(200),
     @pdoc_type          as varchar(200),
     @ppubl              as varchar(200),
     @pmainedtn          as varchar(200),
     @pedtn              as varchar(200),
     @pcity              as varchar(200),
     @pagcode            as varchar(200),
     @pdepocode          as varchar(200),
     @pagtype            as varchar(200),
     @pagclass           as varchar(200),
     @pfrom_recdate      as datetime,
     @ptill_recdate      as datetime,
     @papproved_flag     as varchar(200),
     @pdateformat        as varchar(200),
     @pextra1            as varchar(200),
     @pextra2            as varchar(200)

)
AS 

 declare  @v_frdt     as   datetime;
 declare  @v_todt  as   datetime;
 
	set @v_frdt=@pfrom_recdate
	set @v_todt=@ptill_recdate
	
	
if upper(isnull(@papproved_flag,'N'))='C' 
begin
    select b.comp_code,dbo.get_company_name (b.comp_code) company_name,b.unit_code,a.ag_name ,b.doctype,b.supdate,b.copy_rate,
                sum(b.short_recpt) short_recpt,sum(b.late_recpt) late_recpt,sum(b.bnr) bnr,sum(b.unsold) unsold,sum(b.damage) damage  from cir_agmast a,cir_unsold_dtl b 
                WHERE b.comp_code =a.comp_code 
                and b.comp_code  =@pcomp_code 
                and    b.unit_code=a.unit 
                and b.unit_code=@punit_code 
                and b.doctype=@pdoc_type 
                and b.recptdt between @v_frdt and @v_todt 
                and a.agcd=b.agcd and a.dpcd=b.dpcd 
                and ((b.agcd=@pagcode) or (@pagcode is null) or (@pagcode ='')) 
                and((b.dpcd=@pdepocode) or (@pdepocode is null) or (@pdepocode ='')) 
                and ((b.publ=@ppubl) or (@ppubl is null) or (@ppubl ='')) 
                and ((b.edtn=@pedtn) or (@pedtn is null) or (@pedtn ='')) 
                and  (a.ag_type=@pagtype or @pagtype is null or @pagtype ='')
                and (a.ag_class=@pagclass or @pagclass is null or @pagclass ='')
                and(isnull(b.short_recpt,0)+isnull(b.late_recpt,0)+isnull(b.bnr,0)+isnull(b.unsold,0))>0
                group by b.comp_code,b.unit_code,a.ag_name,b.doctype,b.copy_rate,b.supdate
                order by b.comp_code,b.unit_code,a.ag_name,b.doctype,b.copy_rate,b.supdate
end
else if upper(isnull(@papproved_flag,'N'))='N' 
begin
     select  b.comp_code,dbo.get_company_name (b.comp_code) company_name,b.unit_code,a.ag_name ,b.doctype,b.supdate,b.copy_rate,
            sum(b.var_short_recpt) var_short_recpt,sum(b.var_late_recpt) var_late_recpt,sum(b.var_bnr) var_bnr,
            sum(b.var_unsold) var_unsold,sum(b.var_damage) var_damage from cir_agmast a,cir_unsold_dtl b
            WHERE b.comp_code  =a.comp_code 
            and b.comp_code    =@pcomp_code 
            and b.unit_code=a.unit 
            and b.unit_code=@punit_code 
            and b.doctype=@pdoc_type 
            and b.recptdt between @v_frdt and @v_todt 
            and a.agcd=b.agcd 
            and a.dpcd=b.dpcd
            and ((b.agcd=@pagcode) or (@pagcode is null) or (@pagcode ='')) 
            and ((b.dpcd=@pdepocode) or (@pdepocode is null) or (@pdepocode ='')) 
            and((b.publ=@ppubl) or (@ppubl is null) or (@ppubl ='')) 
            and  (a.ag_type=@pagtype or @pagtype is null or @pagtype ='')
            and (a.ag_class=@pagclass or @pagclass is null or @pagclass ='')
            and ((b.edtn=@pedtn) or (@pedtn is null) or (@pedtn ='')) 
            and (isnull(b.var_short_recpt,0)+isnull(b.var_late_recpt,0)+isnull(b.var_bnr,0)+isnull(b.var_unsold,0))>0
            group by b.comp_code,b.unit_code,a.ag_name,b.doctype,b.copy_rate,b.supdate
            order by b.comp_code,b.unit_code,a.ag_name,b.doctype,b.copy_rate,b.supdate;
end
else
begin
	select b.comp_code,dbo.get_company_name (b.comp_code) company_name,b.unit_code,a.ag_name,b.doctype,b.supdate,b.copy_rate,
            sum(b.apr_short_recpt) apr_short_recpt,
            sum(b.apr_late_recpt) apr_late_recpt,sum(b.apr_bnr) apr_bnr,sum(b.apr_unsold) apr_unsold,sum(b.apr_damage) apr_damage 
            from cir_agmast a,cir_unsold_dtl b
            WHERE 
            b.comp_code =a.comp_code 
            and b.comp_code =@pcomp_code 
            and b.unit_code=a.unit 
            and b.unit_code=@punit_code 
            and b.doctype=@pdoc_type 
            and b.app_dt between @v_frdt and @v_todt 
            and a.agcd=b.agcd and a.dpcd=b.dpcd 
            and ((b.agcd=@pagcode) or (@pagcode is null) or (@pagcode =''))
            and((b.dpcd=@pdepocode) or (@pdepocode is null) or (@pdepocode ='')) 
            and ((b.publ=@ppubl) or (@ppubl is null) or (@ppubl ='')) 
            and ((b.edtn=@pedtn) or (@pedtn is null) or (@pedtn ='')) 
            and((a.city_code=@pcity) or (@pcity is null) or (@pcity ='')) 
            and  (a.ag_type=@pagtype or @pagtype is null or @pagtype ='')
            and (a.ag_class=@pagclass or @pagclass is null or @pagclass ='')
            and (isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0))>0
            group by b.comp_code,b.unit_code,a.ag_name,b.doctype,b.copy_rate,b.supdate
            order by b.comp_code,b.unit_code,b.doctype,b.copy_rate,b.supdate;
end

//------------------------------------end of proc---------------

                                                                     
                                                                     
                                                                     
                                             
create PROCEDURE [dbo].[cir_rep_unsold_copyagency]
(
	 @pcomp_code         as varchar(200),
     @punit_code         as varchar(200),
     @pdoc_type          as varchar(200),
     @ppubl              as varchar(200),
     @pmainedtn          as varchar(200),
     @pedtn              as varchar(200),
     @pcity              as varchar(200),
     @pagcode            as varchar(200),
     @pdepocode          as varchar(200),
     @pagtype            as varchar(200),
     @pagclass           as varchar(200),
     @pfrom_recdate      as datetime,
     @ptill_recdate      as datetime,
     @papproved_flag     as varchar(200),
     @pdateformat        as varchar(200),
     @pextra1            as varchar(200),
     @pextra2            as varchar(200)

)
AS 

 declare  @v_frdt     as   datetime;
 declare  @v_todt  as   datetime;
 
	set @v_frdt=@pfrom_recdate
	set @v_todt=@ptill_recdate
	
	
if upper(isnull(@papproved_flag,'N'))='C' 
begin
    select b.comp_code,dbo.get_company_name (b.comp_code) company_name,b.unit_code,b.publ,
    dbo.cir_get_publ_name(b.comp_code,publ) publ_name,b.edtn,dbo.cir_get_edtn_name(b.comp_code,b.edtn)edtn_name,a.ag_name ,b.doctype,b.supdate,b.copy_rate,
    sum(b.short_recpt) short_recpt,sum(b.late_recpt) late_recpt,sum(b.bnr) bnr,sum(b.unsold) unsold,sum(b.damage) damage  from cir_agmast a,cir_unsold_dtl b 
    WHERE b.comp_code =a.comp_code 
    and b.comp_code =@pcomp_code
    and b.unit_code=a.unit 
    and b.unit_code=@punit_code 
    and b.doctype=@pdoc_type 
    and b.recptdt between @v_frdt and @v_todt 
    and a.agcd=b.agcd and a.dpcd=b.dpcd 
    and ((b.agcd=@pagcode) or (@pagcode is null) or (@pagcode ='')) 
    and ((b.dpcd=@pdepocode) or (@pdepocode is null) or (@pdepocode =''))
    and((b.publ=@ppubl) or (@ppubl is null) or (@ppubl ='')) 
    and ((b.edtn=@pedtn) or (@pedtn is null) or (@pedtn ='')) 
    and  (a.ag_type=@pagtype or @pagtype is null or @pagtype ='')
    and (a.ag_class=@pagclass or @pagclass is null or @pagclass ='')
    and(isnull(b.short_recpt,0)+isnull(b.late_recpt,0)+isnull(b.bnr,0)+isnull(b.unsold,0))>0
    group by b.comp_code,b.unit_code,b.publ,b.edtn,a.ag_name,b.doctype,b.copy_rate,b.supdate
    order by b.comp_code,b.unit_code,b.publ,b.edtn,a.ag_name,b.doctype,b.copy_rate,b.supdate
end
else if upper(isnull(@papproved_flag,'N'))='N' 
begin
    select  b.comp_code,dbo.get_company_name (b.comp_code) company_name,b.unit_code,b.publ,
    dbo.cir_get_publ_name(b.comp_code,publ) publ_name,b.edtn,dbo.cir_get_edtn_name(b.comp_code,edtn)edtn_name,a.ag_name ,b.doctype,b.supdate,b.copy_rate,
    sum(b.var_short_recpt) var_short_recpt,sum(b.var_late_recpt) var_late_recpt,sum(b.var_bnr) var_bnr,
    sum(b.var_unsold) var_unsold,sum(b.var_damage) var_damage from cir_agmast a,cir_unsold_dtl b
    WHERE b.comp_code    =a.comp_code and b.comp_code    =@pcomp_code and 
    b.unit_code=a.unit and b.unit_code=@punit_code and 
    b.doctype=@pdoc_type and b.recptdt between @v_frdt and @v_todt and 
    a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd=@pagcode) or (@pagcode is null) or (@pagcode ='')) and
    ((b.dpcd=@pdepocode) or (@pdepocode is null) or (@pdepocode ='')) and
    ((b.publ=@ppubl) or (@ppubl is null) or (@ppubl ='')) 
    and  (a.ag_type=@pagtype or @pagtype is null or @pagtype ='')
    and (a.ag_class=@pagclass or @pagclass is null or @pagclass ='')
    and ((b.edtn=@pedtn) or (@pedtn is null) or (@pedtn ='')) 
    and (isnull(b.var_short_recpt,0)+isnull(b.var_late_recpt,0)+isnull(b.var_bnr,0)+isnull(b.var_unsold,0))>0
    group by b.comp_code,b.unit_code,b.publ,b.edtn,a.ag_name,b.doctype,b.copy_rate,b.supdate
    order by b.comp_code,b.unit_code,b.publ,b.edtn,a.ag_name,b.doctype,b.copy_rate,b.supdate
end
else
begin
	select  b.comp_code,dbo.get_company_name (b.comp_code) company_name,b.unit_code,b.publ,
    dbo.cir_get_publ_name(b.comp_code,b.publ) publ_name,b.edtn,dbo.cir_get_edtn_name(b.comp_code,b.edtn)edtn_name,a.ag_name ,b.doctype,b.supdate,b.copy_rate,
    sum(b.apr_short_recpt) apr_short_recpt,
    sum(b.apr_late_recpt) apr_late_recpt,sum(b.apr_bnr) apr_bnr,sum(b.apr_unsold) apr_unsold,sum(b.apr_damage) apr_damage from  cir_agmast a,cir_unsold_dtl b
    WHERE 
    b.comp_code =a.comp_code 
    and b.comp_code  =@pcomp_code 
    and b.unit_code=a.unit 
    and b.unit_code=@punit_code 
    and b.doctype=@pdoc_type 
    and b.app_dt between @v_frdt and @v_todt 
    and a.agcd=b.agcd and a.dpcd=b.dpcd 
    and ((b.agcd=@pagcode) or (@pagcode is null) or (@pagcode ='')) 
    and((b.dpcd=@pdepocode) or (@pdepocode is null) or (@pdepocode ='')) 
    and ((b.publ=@ppubl) or (@ppubl is null) or (@ppubl ='')) 
    and ((b.edtn=@pedtn) or (@pedtn is null) or (@pedtn =''))
    and((a.city_code=@pcity) or (@pcity is null) or (@pcity ='')) 
    and(a.ag_type=@pagtype or @pagtype is null or @pagtype ='')
    and (a.ag_class=@pagclass or @pagclass is null or @pagclass ='') 
    and (isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0))>0
    group by b.comp_code,b.unit_code,b.publ,b.edtn,a.ag_name,b.doctype,b.copy_rate,b.supdate
    order by b.comp_code,b.unit_code,b.publ,b.edtn,a.ag_name,b.doctype,b.copy_rate,b.supdate;
end


//----------------------------------end of proc---------------------

                                                                     
                                                                     
                                                                     
                                             
create PROCEDURE [dbo].[cir_rep_unsold_copypubl]
(
	 @pcomp_code         as varchar(200),
     @punit_code         as varchar(200),
     @pdoc_type          as varchar(200),
     @ppubl              as varchar(200),
     @pmainedtn          as varchar(200),
     @pedtn              as varchar(200),
     @pcity              as varchar(200),
     @pagcode            as varchar(200),
     @pdepocode          as varchar(200),
     @pagtype            as varchar(200),
     @pagclass           as varchar(200),
     @pfrom_recdate      as datetime,
     @ptill_recdate      as datetime,
     @papproved_flag     as varchar(200),
     @pdateformat        as varchar(200),
     @pextra1            as varchar(200),
     @pextra2            as varchar(200)

)
AS 

 declare  @v_frdt     as   datetime;
 declare  @v_todt  as   datetime;
 
	set @v_frdt=@pfrom_recdate
	set @v_todt=@ptill_recdate
	
	
if upper(isnull(@papproved_flag,'N'))='C' 
begin
    select b.comp_code,dbo.get_company_name (b.comp_code) company_name,b.unit_code,b.publ,
    dbo.cir_get_publ_name(b.comp_code,b.publ) publ_name,b.edtn,dbo.cir_get_edtn_name(b.comp_code,b.edtn)edtn_name ,b.doctype,b.supdate,b.copy_rate,
    sum(b.short_recpt) short_recpt,sum(b.late_recpt) late_recpt,sum(b.bnr) bnr,sum(b.unsold) unsold,sum(b.damage) damage  from cir_agmast a,cir_unsold_dtl b 
    WHERE b.comp_code    =a.comp_code 
    and b.comp_code    =@pcomp_code 
    and  b.unit_code=a.unit 
    and b.unit_code=@punit_code
    and b.doctype=@pdoc_type 
    and b.recptdt between @v_frdt and @v_todt 
    and a.agcd=b.agcd and a.dpcd=b.dpcd 
    and ((b.agcd=@pagcode) or (@pagcode is null) or (@pagcode ='')) 
    and((b.dpcd=@pdepocode) or (@pdepocode is null) or (@pdepocode =''))
    and((b.publ=@ppubl) or (@ppubl is null) or (@ppubl =''))
    and ((b.edtn=@pedtn) or (@pedtn is null) or (@pedtn ='')) 
    and  (a.ag_type=@pagtype or @pagtype is null  or @pagtype ='')
    and (a.ag_class=@pagclass or @pagclass is null or @pagclass ='')
    and(isnull(b.short_recpt,0)+isnull(b.late_recpt,0)+isnull(b.bnr,0)+isnull(b.unsold,0))>0
    group by b.comp_code,b.unit_code,b.publ,b.edtn,b.doctype,b.copy_rate,b.supdate
    order by b.comp_code,b.unit_code,b.publ,b.edtn,b.doctype,b.copy_rate,b.supdate ;
end
else if upper(isnull(@papproved_flag,'N'))='N' 
begin
    select  b.comp_code,dbo.get_company_name (b.comp_code) company_name,b.unit_code,b.publ,
    dbo.cir_get_publ_name(b.comp_code,publ) publ_name,b.edtn,dbo.cir_get_edtn_name(b.comp_code,edtn)edtn_name ,b.doctype,b.supdate,b.copy_rate,
    sum(b.var_short_recpt) var_short_recpt,sum(b.var_late_recpt) var_late_recpt,sum(b.var_bnr) var_bnr,
    sum(b.var_unsold) var_unsold,sum(b.var_damage) var_damage from cir_agmast a,cir_unsold_dtl b
    WHERE b.comp_code  =a.comp_code 
    and b.comp_code =@pcomp_code 
    and b.unit_code=a.unit 
    and b.unit_code=@punit_code 
    and b.doctype=@pdoc_type 
    and b.recptdt between @v_frdt and @v_todt 
    and a.agcd=b.agcd and a.dpcd=b.dpcd 
    and ((b.agcd=@pagcode) or (@pagcode is null) or (@pagcode =''))
    and((b.dpcd=@pdepocode) or (@pdepocode is null) or (@pdepocode =''))
    and    ((b.publ=@ppubl) or (@ppubl is null) or (@ppubl='')) 
    and  (a.ag_type=@pagtype or @pagtype is null or @pagtype ='')
    and (a.ag_class=@pagclass or @pagclass is null or @pagclass ='')
    and ((b.edtn=@pedtn) or (@pedtn is null) or (@pedtn ='')) 
    and (isnull(b.var_short_recpt,0)+isnull(b.var_late_recpt,0)+isnull(b.var_bnr,0)+isnull(b.var_unsold,0))>0
    group by b.comp_code,b.unit_code,b.publ,b.edtn,b.doctype,b.copy_rate,b.supdate
    order by b.comp_code,b.unit_code,b.publ,b.edtn,b.doctype,b.copy_rate,b.supdate 
end
else
begin
	select  b.comp_code,dbo.get_company_name (b.comp_code) company_name,b.unit_code,b.publ,
	dbo.cir_get_publ_name(b.comp_code,b.publ) publ_name,b.edtn,dbo.cir_get_edtn_name(b.comp_code,b.edtn)edtn_name ,b.doctype,b.supdate,b.copy_rate,
	sum(b.apr_short_recpt) apr_short_recpt,
	sum(b.apr_late_recpt) apr_late_recpt,sum(b.apr_bnr) apr_bnr,sum(b.apr_unsold) apr_unsold,sum(b.apr_damage) apr_damage from  cir_agmast a,cir_unsold_dtl b
	WHERE 
	b.comp_code =a.comp_code 
	and b.comp_code =@pcomp_code 
	and b.unit_code=a.unit 
	and b.unit_code=@punit_code 
	and    b.doctype=@pdoc_type 
	and b.app_dt between @v_frdt and @v_todt 
	and a.agcd=b.agcd 
	and a.dpcd=b.dpcd 
	and ((b.agcd=@pagcode) or (@pagcode is null) or (@pagcode='')) 
	and((b.dpcd=@pdepocode) or (@pdepocode is null) or (@pdepocode='')) 
	and ((b.publ=@ppubl) or (@ppubl is null) or (@ppubl ='')) 
	and ((b.edtn=@pedtn) or (@pedtn is null) or (@pedtn =''))
	and((a.city_code=@pcity) or (@pcity is null) or (@pcity =''))
	and(a.ag_type=@pagtype or @pagtype is null or @pagtype ='')
	and (a.ag_class=@pagclass or @pagclass is null or @pagclass ='') 
	and(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0))>0
	group by b.comp_code,b.unit_code,b.publ,b.edtn,b.doctype,b.copy_rate,b.supdate
	order by b.comp_code,b.unit_code,b.publ,b.edtn,b.doctype,b.copy_rate,b.supdate;
end


//----------------------------------------end of proc-------------------

//------------------------------start---------------------

CREATE INDEX CIR_DBKKSUP_IDX1 ON CIR_DBKSUP(COMP_CODE, UNIT_CODE,SUPDATE,BILLAGCD, BILLDPCD);
//--------------------------end-------------------------------------
*************************************************start***************sapna***********************date(5-march-2012)******************************

ALTER procedure [dbo].[cir_rep_abc_daybook_summ](
	@pcompcode           as varchar(500),
    @punitcode           as varchar(500),
    @pbrancode           as varchar(500),
    @ppublcode           as varchar(500),
    @pmedtncode          as varchar(500),
    @pedtncode           as varchar(500),
    @pagtype             as varchar(500),
    @pagclass            as varchar(500),     
    @pmonth              as varchar(500),--month jan 
    @pyear               as int,---2012
    @pday_period         as varchar(500),--1 for 1 to 15,2 for 16 to last month of day, 3 for 1 to last month of day
    @ppaid_free          as varchar(500),--P for paid supply,F for Free supply and blank for All
    @preptype            as varchar(500),--1 for pcentre wise summary report,2 for pcentre wise branch wise report, 3 for Zone wise ,4 for zone wise region wise,5 for state wise, 6 state wise district wise
    @pdateformat         as varchar(500),
    @puserid             as varchar(500),     
    @pextra1             as varchar(500),
    @pextra2             as varchar(500),
    @pextra3             as varchar(500),
    @pextra4             as varchar(500),
    @pextra5             as varchar(500)

)
as
SET CONCAT_NULL_YIELDS_NULL OFF

CREATE TABLE #CIR_LEDGER_REPORT
(
  COMP_CODE      VARCHAR(10),
  UNIT_CODE      VARCHAR(10),
  BRANCH_CODE    VARCHAR(10),
  DOCTYPE        VARCHAR(10),
  AGCD           VARCHAR(50),
  DPCD           VARCHAR(50),
  RECPTNO        VARCHAR(50),
  RECPTDT        DATEtime,
  AMOUNT         numeric(14,2),
  CHQNO          VARCHAR(50),
  CHQDT          DATEtime,
  CHQ_BANK       VARCHAR(100),
  EXEC_CODE      VARCHAR(20),
  REMARKS        VARCHAR(500),
  REASON         VARCHAR(30),
  BILLNO         VARCHAR(50),
  BILLDT         DATEtime,
  BILLAMT        numeric(14,2),
  ADJAMT         numeric(14,2),
  LEFTAMT        numeric(14,2),
  DEBIT_HEAD     VARCHAR(200),
  CREDIT_HEAD    VARCHAR(200),
  REC_SEQNO      numeric(10),
  RECOVARY_DAYS  numeric(5),
  AGNAME         VARCHAR(500),
  OPBAL_SEC      numeric(14,2),
  SESS_ID        numeric(10)                     DEFAULT @@spid,
  NARR_LINE      numeric(3),
  CITY_CODE      VARCHAR(10)
)


declare @v_frdt    datetime;
declare @v_todt    datetime;

declare @v_comp_code     varchar(50);
declare @v_comp_name     varchar(50);
declare @v_unit_code     varchar(50);
declare @v_unit_name     varchar(50);    
declare @v_publ          varchar(50);
declare @v_medtn         varchar(50);
declare @v_edtn          varchar(50);
declare @v_edtn_name     varchar(50);
declare @v_state_code    varchar(50);
declare @v_dist_code     varchar(50);
declare @v_tehsil_taluka varchar(50);
declare @v_city_code     varchar(50);
declare @v_city_name     varchar(50);
declare @v_zone_code     varchar(50);
declare @v_zone_name     varchar(50);
declare @v_region_code   varchar(50);
declare @v_region_name   varchar(50);
declare @v_branch_code   varchar(50);
declare @v_sup_copy      numeric(10);
declare @v_supdate       datetime;
declare @v_bill_pay      varchar(20);
declare @v_sday          varchar(2);
declare @vvar            varchar(2000);
declare @tot_vvar        varchar(2000);

declare @v_query1        varchar(max);
declare @v_query2        varchar(max);
declare @v_query3        varchar(max);
declare @v_query4        varchar(max);
declare @v_query5        varchar(max);
declare @v_query6        varchar(max);

--set @vsupdate =@pfrom_supdate
--set @vsupdate1=@ptill_supdate

declare @v_cnt       numeric
declare @v_sess_id   numeric;
set @v_cnt=0

select @v_sess_id = @@spid

if @pday_period='1' begin--for 1 to 15
    --set @v_frdt   = @pmonth +'/01/'+@pyear   --'01/'+pmonth+'/'+pyear,pdateformat);
    --set @v_todt   = @pmonth +'/15/'+@pyear   --to_date('15/'+pmonth+'/'+pyear,pdateformat);
    set @v_frdt   = '01/'+cast(@pmonth as varchar)+'/'+cast(@pyear as varchar)  --'01/'+pmonth+'/'+pyear,pdateformat);
    set @v_todt   = '15/'+cast(@pmonth as varchar)+'/'+cast(@pyear as varchar)  --to_date('15/'+pmonth+'/'+pyear,pdateformat);
end
else if @pday_period='2' begin--for 16 to last day of month
    set @v_frdt   ='16/'+cast(@pmonth as varchar)+'/'+cast(@pyear as varchar)
    set @v_todt   =dbo.getlastdayofmonth(@v_frdt)
end
else        
begin
    set @v_frdt   ='01/'+cast(@pmonth as varchar)+'/'+cast(@pyear as varchar)
    set @v_todt   =dbo.getlastdayofmonth(@v_frdt);
end
print(@v_frdt)
print(@v_todt)

declare cur_data cursor for
select x.comp_code,(select "Comp_Name" from comp_mst where "Comp_Code"=x.comp_code) as comp_name,
x.unit_code,(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=x.unit_code) as unit_name,
x.state_name,x.dist_name,x.taluka_name,x.city_code,x.city_name,x.zone_code,x.region_code,x.branch_code,
(select "Branch_Name" from branch_mst where "Branch_Code"=x.branch_code) as branch_name,
x.bill_pay,x.supdate, sum(x.sup_copy) sup_copy
from(
select b.comp_code,b.unit_code,b.publ,e.main_edtn,b.edtn,e.edtn_name,dbo.cir_get_state(b.comp_code,m.country_code,m.state_code) state_name,
dbo.cir_get_dist(b.comp_code,m.state_code,m.dist_code) as dist_name,
dbo.cir_get_taluka(b.comp_code,m.tehsil_taluka) taluka_name,m.city_code,c.city_name,
c.zone_code, c.region_code,m.branch_code,
b.supdate ,case isnull(s.bill_pay,'N') when 'Y' then 'BILLED' else 'UNBILLED' END bill_pay,
sum(b.sup_copy) sup_copy
from cir_dbksup b,cir_agmast m,cir_edtn_mast e ,cir_city_mast c,cir_supply_type_mast s
where b.comp_code=@pcompcode and b.comp_code=m.comp_code and b.comp_code=e.comp_code and b.comp_code=c.comp_code and b.comp_code=s.comp_code and
b.unit_code=isnull(@punitcode,b.unit_code) and b.unit_code=m.unit and b.agcd=m.agcd and b.dpcd=m.dpcd and
b.publ=e.publ and (b.publ=isnull(@ppublcode,b.publ) or @ppublcode ='') and b.edtn=e.edtn and b.edtn=isnull(@pedtncode,b.edtn) and  
b.supdate between @v_frdt and @v_todt and b.sup_type_code=s.sup_ty_code and  
e.main_edtn=isnull(@pmedtncode,e.main_edtn) and (m.ag_type=@pagtype or @pagtype is null) and (m.ag_class=@pagclass or @pagclass is null) and
(m.branch_code=@pbrancode or @pbrancode is null) and m.city_code=c.city_code
group by b.comp_code,b.unit_code,b.publ,e.main_edtn,b.edtn,m.state_code,m.country_code,m.dist_code,m.tehsil_taluka,
e.edtn_name,b.edtn,b.supdate ,isnull(s.bill_pay,'N'),
m.city_code,c.city_name,c.zone_code,c.region_code,m.branch_code) x
group by x.comp_code,x.unit_code,x.publ,x.main_edtn,x.edtn,x.edtn_name,x.state_name,
x.dist_name,x.taluka_name,x.city_code,x.city_name,x.zone_code,x.region_code,x.branch_code,
x.bill_pay,supdate

OPEN cur_data 
	fetch NEXT FROM cur_data into @v_comp_code,@v_comp_name,@v_unit_code,@v_unit_name,@v_state_code,@v_dist_code,@v_tehsil_taluka,@v_city_code,@v_city_name,@v_zone_code,@v_region_code,@v_branch_code,@v_edtn_name,@v_bill_pay,@v_supdate,@v_sup_copy
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
			set @v_zone_name     =dbo.cir_get_zone_name(@v_comp_code,@v_zone_code)
			set @v_region_name   =dbo.cir_get_region_name(@v_comp_code,@v_region_code)
			insert into #cir_ledger_report
            (comp_code, credit_head,unit_code,agname, branch_code, billno, recptno, debit_head,chqno,chq_bank, agcd, remarks,  
                reason,rec_seqno,billdt,sess_id)
            values
            (@v_comp_code,@v_comp_name,@v_unit_code,@v_unit_name,@v_branch_code,isnull(@v_edtn_name,'NOT DEFINE'),isnull(@v_state_code,'NOT DEFINE'),isnull(@v_dist_code,'NOT DEFINE'),isnull(@v_tehsil_taluka,'NOT DEFINE'),isnull(@v_zone_name,'NOT DEFINE'),isnull(@v_region_name,'NOT DEFINE'),isnull(@v_city_name,'NOT DEFINE'),
            @v_bill_pay,@v_sup_copy, @v_supdate,@v_sess_id);	
				
	fetch NEXT FROM cur_data into @v_comp_code,@v_comp_name,@v_unit_code,@v_unit_name,@v_state_code,@v_dist_code,@v_tehsil_taluka,@v_city_code,@v_city_name,@v_zone_code,@v_region_code,@v_branch_code,@v_edtn_name,@v_bill_pay,@v_supdate,@v_sup_copy
END 	
close cur_data
DEALLOCATE cur_data

set @v_supdate=null;
declare c1 cursor for
	select distinct billdt,datepart(dd,billdt) sday from #cir_ledger_report
    where sess_id=@@spid order by billdt
-- end here --
OPEN c1	 
	fetch NEXT FROM c1 into @v_supdate,@v_sday
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
			if (@vvar is null or @vvar = '') begin 
				set @vvar        ='case datepart(dd,billdt) when '+''''+@v_sday+''''+' then a.rec_seqno else 0 end "'+@v_sday+'"';
				set @tot_vvar    ='sum("'+@v_sday+'") "'+@v_sday+'"';
				
			end
			else
			begin
				set @vvar        =@vvar+','+'case when datepart(dd,billdt)='+''''+@v_sday+''''+' then a.rec_seqno else 0 end "'+@v_sday+'"';
				set @tot_vvar    =@tot_vvar+','+'sum("'+@v_sday+'") "'+@v_sday+'"'
				
			end
				
				
	fetch NEXT FROM c1 into @v_supdate,@v_sday
END 	
close c1
DEALLOCATE c1


		if @vvar is null or @vvar ='' begin
            set @v_query1='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                    a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, a.rec_seqno as "TOTAL"
                    from #cir_ledger_report a
                    where sess_id='+cast(@v_sess_id as varchar)+') x
                    group by x.comp_code, x.comp_name,x.unit_code,x.unit_name, x.branch_code,x.branch_name,x.reason
                    order by x.comp_code, x.comp_name,x.unit_code,x.unit_name,x.reason,x.branch_code,x.branch_name';
                    
        set @v_query2='select x.comp_code as comp_code, x.comp_name as comp_name,x.unit_code as unit_code,x.unit_name as unit_name,
                 x.branch_code as branch_code,x.branch_name as branch_name,x.reason, sum(x.TOTAL) as "TOTAL" from';            
        
        --print(v_query2+v_query1)    
        exec(@v_query2+@v_query1);
            
        set @v_query3='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                    a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, a.rec_seqno as "TOTAL"
                    from #cir_ledger_report a
                    where sess_id='+cast(@v_sess_id as varchar)+') x
                    group by x.comp_code, x.comp_name,x.unit_code,x.unit_name,x.reason
                    order by x.comp_code, x.comp_name,x.unit_code,x.unit_name,x.reason';
                    
        set @v_query4='select x.comp_code as comp_code, x.comp_name as comp_name,x.unit_code as unit_code,x.unit_name as unit_name,
                 x.reason, sum(x.TOTAL) as "TOTAL" from';
            
        print(@v_query4+@v_query3)    
        exec(@v_query4+@v_query3)
            
        set @v_query5='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                    a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, a.rec_seqno as "TOTAL"
                    from #cir_ledger_report a
                    where sess_id='+cast(@v_sess_id as varchar)+') x
                    group by x.comp_code, x.comp_name,x.unit_code,x.unit_name
                    order by x.comp_code, x.comp_name,x.unit_code,x.unit_name';
                    
        set @v_query6='select x.comp_code as comp_code, x.comp_name as comp_name,x.unit_code as unit_code,x.unit_name as unit_name,
                   sum(x.TOTAL) as "TOTAL" from';



		print(@v_query6+@v_query5)    
		exec(@v_query6+@v_query5)
        
        end
        else
        begin
            if @preptype='1' begin--for Pcenter wise
            set @v_query1='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                        a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+cast(@v_sess_id as varchar)+') x
                        group by x.comp_code, x.comp_name,x.unit_code,x.unit_name,x.reason
                        order by x.comp_code, x.comp_name,x.unit_code,x.unit_name,x.reason';
                        
            set @v_query2='select x.comp_code as comp_code, x.comp_name as comp_name,x.unit_code as unit_code,x.unit_name as unit_name,
                     x.reason, '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';            
                
            set @v_query3='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                        a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+cast(@v_sess_id as varchar)+') x
                        group by x.comp_code, x.comp_name,x.reason
                        order by x.comp_code, x.comp_name,x.reason';
                        
            set @v_query4='select x.comp_code as comp_code, x.comp_name as comp_name,
                     x.reason, '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';
                
            set @v_query5='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                        a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+cast(@v_sess_id as varchar)+') x
                        group by x.comp_code, x.comp_name
                        order by x.comp_code, x.comp_name';
                        
            set @v_query6='select x.comp_code as comp_code, x.comp_name as comp_name,
                     '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';            
		end
        Else if @preptype='2' begin--for Pcenter wise branch wise
            set @v_query1='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                        a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+cast(@v_sess_id as varchar)+') x
                        group by x.comp_code, x.comp_name,x.unit_code,x.unit_name, x.branch_code,x.branch_name,x.reason
                        order by x.comp_code, x.comp_name,x.unit_code,x.unit_name,x.reason,x.branch_code,x.branch_name';
                        
            set @v_query2='select x.comp_code as comp_code, x.comp_name as comp_name,x.unit_code as unit_code,x.unit_name as unit_name,
                     x.branch_code as branch_code,x.branch_name as branch_name,x.reason, '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';            
                
            set @v_query3='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                        a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+cast(@v_sess_id as varchar)+') x
                        group by x.comp_code, x.comp_name,x.unit_code,x.unit_name,x.reason
                        order by x.comp_code, x.comp_name,x.unit_code,x.unit_name,x.reason';
                        
            set @v_query4='select x.comp_code as comp_code, x.comp_name as comp_name,x.unit_code as unit_code,x.unit_name as unit_name,
                     x.reason, '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';
                
            set @v_query5='(select a.comp_code as comp_code, a.credit_head as comp_name,a.unit_code as unit_code,a.agname as unit_name,
                        a.branch_code as branch_code,a.billno as branch_name,a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+cast(@v_sess_id as varchar)+') x
                        group by x.comp_code, x.comp_name,x.unit_code,x.unit_name
                        order by x.comp_code, x.comp_name,x.unit_code,x.unit_name';
                        
            set @v_query6='select x.comp_code as comp_code, x.comp_name as comp_name,x.unit_code as unit_code,x.unit_name as unit_name,
                     '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';            
        end    
        Else if @preptype='3' begin--for Zone wise
            set @v_query1='(select a.comp_code as comp_code, a.credit_head as comp_name,a.chq_bank as zone_name,
                        a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+cast(@v_sess_id as varchar)+') x
                        group by x.comp_code, x.comp_name,x.zone_name,x.reason
                        order by x.comp_code, x.comp_name,x.zone_name,x.reason';
                        
            set @v_query2='select x.comp_code as comp_code, x.comp_name as comp_name,x.zone_name as zone_name,
                     x.reason, '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';    
                     
                     
                     --open p_accounts for v_query2+v_query1;        
                
            set @v_query3='(select a.comp_code as comp_code, a.credit_head as comp_name,a.chq_bank as zone_name,
                        a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+cast(@v_sess_id as varchar)+') x
                        group by x.comp_code, x.comp_name,x.reason
                        order by x.comp_code, x.comp_name,x.reason';
                        
            set @v_query4='select x.comp_code as comp_code, x.comp_name as comp_name,
                     x.reason, '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';
                     
                     --open p_accounts1 for v_query4+v_query3;
                
            set @v_query5='(select a.comp_code as comp_code, a.credit_head as comp_name,a.chq_bank as zone_name,
                        a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+cast(@v_sess_id as varchar)+') x
                        group by x.comp_code, x.comp_name
                        order by x.comp_code, x.comp_name';
                        
            set @v_query6='select x.comp_code as comp_code, x.comp_name as comp_name,
                     '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';
                     
                     --open p_accounts2 for v_query6+v_query5;

        end   
        Else if @preptype='4' begin--for Zone wise Region wise
            set @v_query1='(select a.comp_code as comp_code, a.credit_head as comp_name,a.chq_bank as zone_name,a.exec_code as region_name,
                        a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+cast(@v_sess_id as varchar)+') x
                        group by x.comp_code, x.comp_name,x.zone_name,x.reason,x.region_name
                        order by x.comp_code, x.comp_name,x.zone_name,x.reason,x.region_name';
                        
            set @v_query2='select x.comp_code as comp_code, x.comp_name as comp_name,x.zone_name as zone_name,x.region_name as region_name,
                     x.reason, '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';            
                
            set @v_query3='(select a.comp_code as comp_code, a.credit_head as comp_name,a.chq_bank as zone_name,a.exec_code as region_name,
                        a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+cast(@v_sess_id as varchar)+') x
                        group by x.comp_code, x.comp_name,x.zone_name,x.reason
                        order by x.comp_code, x.comp_name,x.zone_name,x.reason';
                        
            set @v_query4='select x.comp_code as comp_code, x.comp_name as comp_name,x.zone_name,
                     x.reason, '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';
                
            set @v_query5='(select a.comp_code as comp_code, a.credit_head as comp_name,a.chq_bank as zone_name, a.exec_code as region_name,
                        a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+cast(@v_sess_id as varchar)+') x
                        group by x.comp_code, x.comp_name,x.zone_name
                        order by x.comp_code, x.comp_name,x.zone_name';
                        
            set @v_query6='select x.comp_code as comp_code, x.comp_name as comp_name,x.zone_name,
                     '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';
		end
        Else if @preptype='5' begin--for State wise
            set @v_query1='(select a.comp_code as comp_code, a.credit_head as comp_name,a.recptno as state_name,
                        a.debit_head as dist_name,a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+cast(@v_sess_id as varchar)+') x
                        group by x.comp_code, x.comp_name,x.state_name,x.reason
                        order by x.comp_code, x.comp_name,x.state_name,x.reason';
                        
            set @v_query2='select x.comp_code as comp_code, x.comp_name as comp_name,x.state_name as state_name,
                      x.reason, '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';
                
            set @v_query3='(select a.comp_code as comp_code, a.credit_head as comp_name,a.recptno as state_name,
                        a.debit_head as dist_name,a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+cast(@v_sess_id as varchar)+') x
                        group by x.comp_code, x.comp_name,x.state_name
                        order by x.comp_code, x.comp_name,x.state_name';
                        
            set @v_query4='select x.comp_code as comp_code, x.comp_name as comp_name,x.state_name as state_name,
                       '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';
                
            set @v_query5='(select a.comp_code as comp_code, a.credit_head as comp_name,a.recptno as state_name,
                        a.debit_head as dist_name,a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+cast(@v_sess_id as varchar)+') x
                        group by x.comp_code, x.comp_name
                        order by x.comp_code, x.comp_name';
                        
            set @v_query6='select x.comp_code as comp_code, x.comp_name as comp_name,
                     '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';
		end
        else--for State wise district wise
        begin
            set @v_query1='(select a.comp_code as comp_code, a.credit_head as comp_name,a.recptno as state_name,
                        a.debit_head as dist_name,a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+cast(@v_sess_id as varchar)+') x
                        group by x.comp_code, x.comp_name,x.state_name, x.dist_name,x.reason
                        order by x.comp_code, x.comp_name,x.state_name,x.reason,x.dist_name';
                        
            set @v_query2='select x.comp_code as comp_code, x.comp_name as comp_name,x.state_name as state_name,
                     x.dist_name as dist_name,x.reason, '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';            
                
            set @v_query3='(select a.comp_code as comp_code, a.credit_head as comp_name,a.recptno as state_name,
                        a.debit_head as dist_name,a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+cast(@v_sess_id as varchar)+') x
                        group by x.comp_code, x.comp_name,x.state_name, x.reason
                        order by x.comp_code, x.comp_name,x.state_name,x.reason';
                        
            set @v_query4='select x.comp_code as comp_code, x.comp_name as comp_name,x.state_name as state_name,
                     x.reason, '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';
                
            set @v_query5='(select a.comp_code as comp_code, a.credit_head as comp_name,a.recptno as state_name,
                        a.debit_head as dist_name,a.reason as reason, '+@vvar+', a.rec_seqno as "TOTAL"
                        from #cir_ledger_report a
                        where sess_id='+cast(@v_sess_id as varchar)+') x
                        group by x.comp_code, x.comp_name,x.state_name
                        order by x.comp_code, x.comp_name,x.state_name';
                        
            set @v_query6='select x.comp_code as comp_code, x.comp_name as comp_name,x.state_name as state_name,
                     '+@tot_vvar+', sum(x.TOTAL) as "TOTAL" from';            

        End
        end

print(@v_query2+@v_query1)
exec(@v_query2+@v_query1)
 
print(@v_query4+@v_query3)
exec(@v_query4+@v_query3)   

print(@v_query6+@v_query5)
exec(@v_query6+@v_query5) 
drop table #cir_ledger_report    
SET CONCAT_NULL_YIELDS_NULL On






************************************************end*******************************************
/////////////////////////update by Garima
USE [ERP]
GO
/****** Object:  StoredProcedure [dbo].[cir_rep_supply_cir_rep_supply_po]    Script Date: 03/05/2012 16:28:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[cir_rep_supply_cir_rep_supply_po]
	@pcomp_code                               VARCHAR(20) ,
	@punit_code                               VARCHAR(20) ,
	@ppubl                                    VARCHAR(20) ,
	@pedtn                                    VARCHAR(20) ,
	@psupdate                                 VARCHAR(20) ,
	@pdateformat                              VARCHAR(20) ,
	@pextra1                                  VARCHAR(4000),--it is use for finalised or unfinalised
	@pextra2                                  VARCHAR(4000),
	@pextra3                                  VARCHAR(4000)  
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
		WHERE comp_code  = @pcomp_code
		
		/* and (upper(@pextra1)!='U' or @pextra1 is null)
		
		union
		SELECT 'SUM(CASE SUPPLY_TYPE_CODE WHEN  '+''''+sup_ty_code+''''+' then isnull(d.base_supply,0) else 0 end) "'+sup_ty_name+'",' vty,
				'sum(case supply_type_code	when '+''''+sup_ty_code+''''+' then '+' isnull(d.base_supply,0) '+' else 0 end) +' vty_sum,sup_seq_no from cir_supply_type_mast 
		WHERE comp_code  = @pcomp_code and upper(@pextra1)='U'
		*/)z
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
         (d.publ='+''''+@ppubl+''''+' OR '+''''+@ppubl+''''+' IS NULL OR '+''''+@ppubl+''''+' ='''') 
         and (d.final_supply_flag='''+@pextra3+'''   or '''+@pextra3+''' = '''')
         and d.publ=e.publ 
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
 




//////////////////////////////////////////
USE [ERP]
GO
/****** Object:  StoredProcedure [dbo].[cir_route_editionwise_print]    Script Date: 03/05/2012 17:14:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[cir_route_editionwise_print](
	@pcompcode      as varchar(500),
	@punitcode      as varchar(500),
	@ppublcode      as varchar(500),
	@pmainedtn      as varchar(500),
	@pedtncode      as varchar(500),
	@proute         as varchar(500),
	@pfrom_supdate  as datetime,
	@ptill_supdate  as datetime,
	@plangtype      as varchar(500),
	@pdateformat    as varchar(500),
	@pextra1        as varchar(500),
	@pextra2        as varchar(500),
	@pextra3        as varchar(500),--------supply posted final and un final
	@pextra4        as varchar(500),
	@pextra5        as varchar(500),
	@pextra6        as varchar(500),
	@pextra7        as varchar(500),
	@pextra8        as varchar(500),
	@pextra9        as varchar(500),
	@pextra10       as varchar(500)

)
as
SET CONCAT_NULL_YIELDS_NULL OFF
--CREATE TABLE #CIR_TEMP_DT
--(
--  SQNO  NUMeric,
--  DT    DATEtime
--)
declare @vsupdate  as  datetime;
declare @vsupdate1  as datetime;
declare @vvar    as varchar(max);
declare @vvar_sum   as  varchar(max);
declare @vvar_sum1  as  varchar(max);
declare @v_query  as  varchar(max);
declare @v_query1  as  varchar(max);

set @vsupdate =@pfrom_supdate
set @vsupdate1=@ptill_supdate

declare cur_edtn cursor for
	select distinct d.publ publ,d.edtn edtn,p.edtn_seq_no edtn_seqno,
	case @plangtype when '1' then substring(p.edition_nick,1,15)
	else substring(p.edtn_name_oth_lang,1,20) end edtn_name
	,d.sup_rate sup_rate,p.main_edtn main_edtn
	from cir_route_mast m,cir_dbksup d ,cir_edtn_mast p ,cir_supply_type_mast k
	where m.comp_code=@pcompcode and m.comp_code=d.comp_code and d.comp_code=p.comp_code and m.unit=d.unit_code and
	d.comp_code=k.comp_code  and d.sup_type_code=k.sup_ty_code and 
	m.unit=p.unit_code and d.unit_code = @punitcode and
	d.supdate >= @vsupdate and d.supdate <=@vsupdate1 and
	m.route_code=d.route_code and (m.route_code=@proute or @proute is null)
	and d.publ=isnull(@ppublcode,d.publ) and
	d.publ=p.publ and d.edtn=p.edtn and k.bill_pay='Y'
	order by publ,main_edtn,edtn_seqno,edtn,sup_rate
print('a')
-- cursor variable for cur_edtn
declare @rec_edtn_publ as varchar(200)
declare @rec_edtn_edtn as varchar(200)
declare @rec_edtn_edtn_seqno as numeric(5)
declare @rec_edtn_edtn_name as varchar(500)
declare @rec_edtn_sup_rate as numeric(14,2)
declare @rec_edtn_main_edtn as varchar(200)
-- end here --

OPEN cur_edtn 
	fetch NEXT FROM cur_edtn INTO @rec_edtn_publ , @rec_edtn_edtn,@rec_edtn_edtn_seqno,@rec_edtn_edtn_name,@rec_edtn_sup_rate,@rec_edtn_main_edtn
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
			if (@vvar is null or @vvar = '') begin 
				set @vvar        ='sum(case edtn when '+''''+@rec_edtn_edtn+''''+' then sup_copy else 0 end) "'+@rec_edtn_edtn_name+'"';
				set @vvar_sum    ='sum('+'"'+@rec_edtn_edtn_name+'") "'+@rec_edtn_edtn_name+'"';
				set @vvar_sum1   ='sum('+'"'+@rec_edtn_edtn_name+'"';
			end
			else
			begin
				set @vvar        =@vvar+','+'sum(case edtn when '+''''+@rec_edtn_edtn+''''+' then sup_copy else 0 end) "'+@rec_edtn_edtn_name+'"';
				set @vvar_sum    =@vvar_sum+','+'sum('+'"'+@rec_edtn_edtn_name+'") "'+@rec_edtn_edtn_name+'"';
				set @vvar_sum1   =@vvar_sum1+'+"'+@rec_edtn_edtn_name+'"';
			end
				
				
	fetch NEXT FROM cur_edtn INTO @rec_edtn_publ , @rec_edtn_edtn,@rec_edtn_edtn_seqno,@rec_edtn_edtn_name,@rec_edtn_sup_rate,@rec_edtn_main_edtn
END 	
close cur_edtn
DEALLOCATE cur_edtn

if @vvar_sum1 is not null or @vvar_sum1 !='' begin
    set @vvar_sum1=@vvar_sum1+') "Total"'
end
print(@vvar)
 if @vvar is null or @vvar ='' begin
	set @v_query='select x.comp_code,x.unit_code,x.route_code,x.route_name from(select d.comp_code,d.unit_code,d.route_code,
			case '''+@plangtype+''' when ''1'' then substring(m.route_name,1,25)
            else substring(m.route_name_oth_lang,1,25) end route_name 
            from cir_dbksup d,cir_route_mast m ,cir_supply_type_mast k
            where d.comp_code = m.comp_code and d.unit_code = m.unit 
            and d.comp_code=k.comp_code  and d.sup_type_code=k.sup_ty_code and d.comp_code = '+''''+@pcompcode+''''+' and
            d.unit_code = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and
            d.route_code = m.route_code  and 
            d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <='+''''+cast(@vsupdate1 as varchar)+''''+' 
            and k.bill_pay=''Y'' 
            and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' is null)
            group by d.comp_code,d.unit_code,d.route_code,m.route_name) x
            group by x.comp_code,x.unit_code,x.route_code,x.route_name
            order by x.comp_code,x.unit_code,x.route_code,x.route_name';
end
else
begin        
	set @v_query='select x.comp_code,x.unit_code,x.route_code,x.route_name,'+@vvar_sum+','+@vvar_sum1+' from(select d.comp_code,d.unit_code,d.route_code route_code,
            case '''+@plangtype+''' when ''1'' then substring(m.route_name,1,25) 
            else substring(m.route_name_oth_lang,1,25) end route_name
            ,'+@vvar+' from cir_dbksup d,cir_route_mast m,cir_supply_type_mast k
            where d.comp_code = m.comp_code and d.unit_code = m.unit 
            and d.comp_code=k.comp_code  and d.sup_type_code=k.sup_ty_code  and d.comp_code = '+''''+@pcompcode+''''+' and
            d.unit_code = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and
            d.route_code = m.route_code  and
            d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <= '+''''+cast(@vsupdate1 as varchar)+''''+' 
            and k.bill_pay=''Y'' 
            and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' is null)
            group by d.comp_code,d.unit_code,m.route_name,d.route_code) x
            group by x.comp_code,x.unit_code,x.route_code,x.route_name
            order by x.comp_code,x.unit_code,x.route_code,x.route_name';	   
end
print(@v_query)
exec(@v_query)  
print('q')
-- for free supply
	set @vvar=null
	set @vvar_sum=null
	set @vvar_sum1=null
	
declare cur_edtn_free cursor for
	select distinct d.publ publ,d.edtn edtn,p.edtn_seq_no edtn_seqno,
	case @plangtype when '1' then substring(p.edition_nick,1,15)
	else substring(p.edtn_name_oth_lang,1,20) end edtn_name
	,d.sup_rate sup_rate,p.main_edtn main_edtn
	from cir_supply_type_mast m,cir_dbksup d ,cir_edtn_mast p 
	where m.comp_code=@pcompcode and m.comp_code=d.comp_code and d.comp_code=p.comp_code and 
	  d.comp_code=m.comp_code  and d.sup_type_code=m.sup_ty_code and 
	  d.unit_code=p.unit_code and d.unit_code = @punitcode and
	  d.supdate >= @vsupdate and d.supdate <=@vsupdate1 and
	  d.publ=isnull(@ppublcode,d.publ) and
	  d.publ=p.publ and d.edtn=p.edtn and m.bill_pay='N'
	  order by publ,main_edtn,edtn_seqno,edtn,sup_rate
-- cursor variable for cur_edtn_free
declare @rec_edtn_free_publ as varchar(200)
declare @rec_edtn_free_edtn as varchar(200)
declare @rec_edtn_free_edtn_seqno as numeric(5)
declare @rec_edtn_free_edtn_name as varchar(500)
declare @rec_edtn_free_sup_rate as numeric(14,2)
declare @rec_edtn_free_main_edtn as varchar(200)
-- end here --

OPEN cur_edtn_free 
	fetch NEXT FROM cur_edtn_free INTO @rec_edtn_free_publ , @rec_edtn_free_edtn,@rec_edtn_free_edtn_seqno,@rec_edtn_free_edtn_name,@rec_edtn_free_sup_rate,@rec_edtn_free_main_edtn
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
			if (@vvar is null or @vvar = '') begin 
				set @vvar        ='sum(case edtn when '+''''+@rec_edtn_free_edtn+''''+' then sup_copy else 0 end) "'+@rec_edtn_free_edtn_name+'"';
				set @vvar_sum    ='sum('+'"'+@rec_edtn_free_edtn_name+'") "'+@rec_edtn_free_edtn_name+'"';
				set @vvar_sum1   ='sum('+'"'+@rec_edtn_free_edtn_name+'"';
			end
			else
			begin
				set @vvar        =@vvar+','+'sum(case edtn when '+''''+@rec_edtn_free_edtn+''''+' then sup_copy else 0 end) "'+@rec_edtn_free_edtn_name+'"';
				set @vvar_sum    =@vvar_sum+','+'sum('+'"'+@rec_edtn_free_edtn_name+'") "'+@rec_edtn_free_edtn_name+'"';
				set @vvar_sum1   =@vvar_sum1+'+"'+@rec_edtn_free_edtn_name+'"';
			end
				
				
	fetch NEXT FROM cur_edtn_free INTO @rec_edtn_free_publ , @rec_edtn_free_edtn,@rec_edtn_free_edtn_seqno,@rec_edtn_free_edtn_name,@rec_edtn_free_sup_rate,@rec_edtn_free_main_edtn
END 	
close cur_edtn_free
DEALLOCATE cur_edtn_free
if @vvar_sum1 is not null or @vvar_sum1 !='' begin
    set @vvar_sum1=@vvar_sum1+') "Total"'
end

		if @vvar is null or @vvar ='' begin
            set @v_query1='select x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name from(select d.comp_code,d.unit_code,m.sup_ty_code,
			substring(m.sup_ty_name,1,25) supply_name
            from cir_dbksup d,cir_supply_type_mast m
            where d.comp_code = m.comp_code 
            and d.sup_type_code=m.sup_ty_code
            and d.comp_code = '+''''+@pcompcode+''''+' and
            d.unit_code = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and            
            d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <='+''''+cast(@vsupdate1 as varchar)+''''+' 
            and m.bill_pay=''N'' 
            and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' is null)
            group by d.comp_code,d.unit_code,m.sup_ty_code,m.sup_ty_name) x
            group by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name
            order by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name';
        end
        else
        begin
            set @v_query1='select x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name,'+@vvar_sum+','+@vvar_sum1+' from
            (select d.comp_code,d.unit_code,m.sup_ty_code sup_ty_code,
            substring(m.sup_ty_name,1,25) supply_name
            ,'+@vvar+' from cir_dbksup d,cir_supply_type_mast m
            where d.comp_code = m.comp_code
             and d.sup_type_code=m.sup_ty_code 
            and d.comp_code = '+''''+@pcompcode+''''+' and
            d.unit_code = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and            
             d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <= '+''''+cast(@vsupdate1 as varchar)+''''+' 
             and m.bill_pay=''N'' and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' is null)
            group by d.comp_code,d.unit_code,m.sup_ty_code,m.sup_ty_name) x
            group by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name
            order by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name';
        end

print(@v_query1)
exec(@v_query1)
SET CONCAT_NULL_YIELDS_NULL On
//////////////////////////////////////////end  update by Garima
//////////////////updated by Garima
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

                                                                     
                                                                     
                                                                     
                                             
ALTER PROCEDURE [dbo].[cir_rep_outstanding_cir_rep_outstanding_summ_p]
	@pcompcode                                VARCHAR(20) ,
	@punitcode                                VARCHAR(20) ,
	@ppublcode                                VARCHAR(20) ,
	@pactype                                  VARCHAR(20) ,
	@pagency_type                             VARCHAR(20) ,
	@pagcd                                    VARCHAR(20) ,
	@pdpcd                                    VARCHAR(20) ,
	@prep_type                                VARCHAR(20) ,--statewise or districtwise or talukawise	
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


	DECLARE c1 cursor LOCAL FOR 
		SELECT DISTINCT comp_code, unit, agcd, dpcd, ag_name, ag_name_oth_lang, city_code, tehsil_taluka, dist_code,
		state_code, country_code
		FROM  cir_agmast 
		WHERE comp_code  = @pcompcode AND unit  = @punitcode 
		AND	(ag_type  = @pagency_type OR	@pagency_type  is null or @pagency_type='')
		AND	(EXECUTIVE_CODE  = @pextra1 OR	@pextra1  is null or @pextra1='')
		AND	agcd + dpcd  in
			(SELECT DISTINCT CAST(agcd AS VARCHAR) + CAST(dpcd AS VARCHAR)
			FROM  cir_outmast 
			WHERE comp_code  = @pcompcode AND	unit_code  = @punitcode	AND	achd  = @pactype
			AND	(publ  = @ppublcode OR	@ppublcode  is null OR	@ppublcode = ''))
			AND	(agcd  = @pagcd OR	@pagcd  is null OR	@pagcd = '')
			AND	(dpcd  = @pdpcd OR	@pdpcd  is null OR	@pdpcd = '')
			AND	(((state_code  = @pcode OR	@pcode  is null OR	@pcode = '')
			AND	@prep_type  = '1') OR	((dist_code  = @pcode OR	@pcode  is null  or @pcode = '')
			AND	@prep_type  = '2') OR	((tehsil_taluka  = @pcode OR	@pcode  is null OR	@pcode  = '') 
			AND	@prep_type  = '3'))
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

	SET @v_opdate  = DBO.cir_get_finandt(@pcompcode, dbo.convert_user_date('/', @pfromdate , @pdateformat), @pdateformat, '', '')

	SET @v_frdt  = dbo.convert_user_date('/', @pfromdate, @pdateformat)
	SET @v_todt  = dbo.convert_user_date('/', @pasondate, @pdateformat)
		
	OPEN c1 
	fetch NEXT FROM c1 INTO @v_comp_code1 ,@v_unit1, @v_agcd1,@v_dpcd1 ,@v_ag_name1,@v_ag_name_oth_lang1,@v_city_code1,
            @v_tehsil_taluka1, @v_dist_code1, @v_state_code1,@v_country_code1

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
				state_code , country_code )  
				VALUES 	( @v_comp_code1 , @v_unit1 , @v_frdt , @ppublcode , @v_agcd1 , @v_dpcd1 , isnull(@v_opbal, 0) , 
				isnull(@v_billamt, 0) , isnull(@v_othdbamt, 0) , isnull(@v_recamt, 0) , isnull(@v_othcramt, 0) , @v_ag_name1 , 
				@v_ag_name_oth_lang1 , @v_city_code1 , @v_tehsil_taluka1 , @v_dist_code1 , @v_state_code1 , @v_country_code1 )  
				

			END
   
			SET @v_billamt  = 0 
			SET @v_dbcramt  = 0 
			SET @v_opbal  = 0 
			SET @v_clbal  = 0 
			SET @v_recamt  = 0 
			SET @v_othdbamt  = 0 
			SET @v_othcramt  = 0 
			
            fetch NEXT FROM c1 INTO @v_comp_code1 ,@v_unit1, @v_agcd1,@v_dpcd1 ,@v_ag_name1,@v_ag_name_oth_lang1,@v_city_code1,
            @v_tehsil_taluka1, @v_dist_code1, @v_state_code1,@v_country_code1

		END 
		close c1
		
		
		IF @prep_type = '1' --for statewise group
		BEGIN 
			
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
		IF @prep_type = '2' 
		BEGIN 
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
		IF @prep_type = '3' 
		BEGIN 
			--for talukawise group
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


select a.comp_code comp_code,a.unit_code unit_code,a.branch_code branch_code,dbo.AD_GET_BRANCHNAME (a.comp_code,a.branch_code) rep_type_name,
                    a.agcd agcd,a.dpcd dpcd,a.op_amt op_amt,a.bill_amt billamt,a.dn_amt other_dbamt,a.rec_amt recamt,a.cn_amt other_cramt,
                    isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0) cl_amt,
                    a.agname agname,a.agname_oth_lang agname_oth_lang,
                    a.city_code city_code,substring(dbo.cir_get_city(a.comp_code,a.city_code),1,30) city_name
                    from #cir_temp_outstanding a
               order by a.comp_code,a.unit_code,rep_type_name,a.agname,a.branch_code;
  
        select x.comp_code comp_code,x.unit_code unit_code,x.state_code rep_type_code,x.branch_Name rep_type_name,
        sum(x.op_amt) op_amt,sum(x.bill_amt) billamt,sum(x.dn_amt) other_dbamt,
                    sum(x.rec_amt) recamt,sum(x.cn_amt) other_cramt,
                    sum(isnull(x.op_amt,0)+isnull(x.bill_amt,0)+isnull(x.dn_amt,0)+isnull(x.rec_amt,0)+isnull(x.cn_amt,0)) cl_amt from
        (select a.comp_code comp_code,a.unit_code unit_code,a.state_code state_code,dbo.AD_GET_BRANCHNAME (a.comp_code,a.branch_code) branch_name,
                    sum(a.op_amt) op_amt,sum(a.bill_amt) bill_amt,sum(a.dn_amt) dn_amt,sum(a.rec_amt) rec_amt,sum(a.cn_amt) cn_amt,
                    sum(isnull(a.op_amt,0)+isnull(a.bill_amt,0)+isnull(a.dn_amt,0)+isnull(a.rec_amt,0)+isnull(a.cn_amt,0)) cl_amt
                    from #cir_temp_outstanding a
                    group by a.comp_code,a.unit_code,a.country_code,a.branch_code) x
                    group by x.comp_code,x.unit_code,x.state_code,x.branch_name
            order by comp_code,unit_code,rep_type_name;

end



 DEALLOCATE c1
	drop table #cir_temp_outstanding;
End
////////////////////////////////////////////end by Garima

///////////////////////////////////5 march 2012 taxi route detail//////by rahul////////////////////////////////////////////////


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[cir_route_drop_point_detail_p]
    @pcomp_code          as varchar(200),
    @punit_code          as varchar(200),
    @ptaxi_code          as varchar(200),
    @proute_code         as varchar(200),
    @psubroutecode       as varchar(200),
    @psub_subroutecode   as varchar(200),
    @puserid             as varchar(200),
    @pdateformat         as varchar(200),
    @pextra1             as varchar(200),
    @pextra2             as varchar(200),
    @pextra3             as varchar(200),
    @pextra4             as varchar(200),
    @pextra5             as varchar(200)
  As
declARE @query as varchar(4000)
Begin
PRINT(@psub_subroutecode)
    If @proute_code='' Begin
		set @proute_code=null
	End	
    If @psubroutecode  ='' Begin
		set @psubroutecode=null
	End
	If @psub_subroutecode='' Begin		
		set @psub_subroutecode=null
	End
	
    if @proute_code is not null and @psubroutecode is null Begin
PRINT('1')
 SET @query='
 select DISTINCT X.COMP_CODE COMP_CODE, X.UNIT_CODE UNIT_CODE, X.TPT_CODE TPT_CODE,X.TPT_NAME TPT_NAME,
        X.RT_CODE RT_CODE,X.RT_NAME RT_NAME,X.SUBRT_CODE SUBRT_CODE, X.SUBRT_NAME SUBRT_NAME,X.SUB_SUBRT_CODE SUB_SUBRT_CODE,X.SUB_SUBRT_NAME SUB_SUBRT_NAME,
        X.TAXI_ID TAXI_ID, X.VEHICLE_NAME VEHICLE_NAME, X.VEHICLE_NO VEHICLE_NO,
        Y.DROP_POINT_CODE DROP_POINT_CODE,Y.DROP_POINT_NAME DROP_POINT_NAME,Y.LATITUDE LATITUDE,Y.LOGNITUDE "LONGITUDE",
        MIN(Y.LBL_PRINTNO) LBL_PRINTNO,y.DROP_POINT_SEQNO 
        from
        (select t.comp_code comp_code, t.unit_code unit_code, t.tpt_code tpt_code,(select transporter_name from cir_transporter_mast where comp_code=t.comp_code and transporter_code=t.tpt_code) tpt_name,
        t.rt_code rt_code,r.route_name rt_name,   
        t.subrt_code subrt_code,(select subrt_name from cir_sub_route_mast where comp_code=t.comp_code and unit=t.unit_code and route_code=t.rt_code and subrt_code=t.subrt_code) subrt_name, 
        t.sub_subrt_code sub_subrt_code,(select sub_subrt_name from cir_sub_subroute_mast where comp_code=t.comp_code and unit=t.unit_code and route_code=t.rt_code and subrt_code=t.subrt_code and sub_subrt_code=t.sub_subrt_code) sub_subrt_name,
        t.taxi_id ,t.vehicle_name vehicle_name, t.vehicle_no vehicle_no
        from cir_taxi_mast t,cir_route_mast r
        where t.comp_code=r.comp_code and t.comp_code='''+@pcomp_code+''' and t.unit_code=r.unit and (t.unit_code='''+@punit_code+''' or '''+@punit_code+''' is null) and 
        t.rt_code=r.route_code and (t.rt_code='''+@proute_code+''' or '''+@proute_code+''' is null) and taxi_id='''+@ptaxi_code+''') x,
        (select distinct b.comp_code comp_code,b.unit unit_code,b.route_code route_code,b.subroute_code subroute_code,
        b.sub_subroute_code sub_subroute_code,a.station_code drop_point_code,c.drop_point_name drop_point_name,
        c.latitude latitude,c.lognitude lognitude,b.lbl_printno lbl_printno,c.DROP_POINT_SEQNO
        from cir_agmast a,cir_supply b,cir_drop_point_mast c
        where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code='''+@pcomp_code+''' and a.unit=b.unit and
        a.unit=c.unit_code and (a.unit='''+@punit_code+''' or  '''+@punit_code+''' is null) and a.agcd=b.agcd and a.dpcd=b.dpcd and
        a.station_code=c.drop_point and (b.route_code='''+@proute_code+''' or '''+@proute_code+''' is null) and 
        isnull(a.suspend,''N'')=''N'' and isnull(a.freeze_flag,''N'')=''N'' and isnull(c.freeze_flag,''N'')=''N'') y
        where x.comp_code=y.comp_code and x.unit_code=y.unit_code and x.rt_code=y.route_code and (y.subroute_code is null OR y.subroute_code='''')
        group by x.comp_code, x.unit_code, x.tpt_code,x.tpt_name,
        x.rt_code,x.rt_name,x.subrt_code, x.subrt_name,x.sub_subrt_code,x.sub_subrt_name,
        x.taxi_id, x.vehicle_name, x.vehicle_no,
        y.drop_point_code,y.drop_point_name,y.latitude,y.lognitude,y.DROP_POINT_SEQNO 
        order by x.comp_code, x.unit_code,x.taxi_id,lbl_printno,y.drop_point_name';
	End
    else if @psubroutecode is not null and @psub_subroutecode is null Begin
PRINT('2')    
  SET @query='  
 select DISTINCT X.COMP_CODE COMP_CODE, X.UNIT_CODE UNIT_CODE, X.TPT_CODE TPT_CODE,X.TPT_NAME TPT_NAME,
        X.RT_CODE RT_CODE,X.RT_NAME RT_NAME,X.SUBRT_CODE SUBRT_CODE, X.SUBRT_NAME SUBRT_NAME,X.SUB_SUBRT_CODE SUB_SUBRT_CODE,X.SUB_SUBRT_NAME SUB_SUBRT_NAME,
        X.TAXI_ID TAXI_ID, X.VEHICLE_NAME VEHICLE_NAME, X.VEHICLE_NO VEHICLE_NO,
        Y.DROP_POINT_CODE DROP_POINT_CODE,Y.DROP_POINT_NAME DROP_POINT_NAME,Y.LATITUDE LATITUDE,Y.LOGNITUDE "LONGITUDE",
        MIN(Y.LBL_PRINTNO) LBL_PRINTNO,y.DROP_POINT_SEQNO
        from
        (select t.comp_code comp_code, t.unit_code unit_code, t.tpt_code tpt_code,(select transporter_name from cir_transporter_mast where comp_code=t.comp_code and transporter_code=t.tpt_code) tpt_name,
        t.rt_code rt_code,r.route_name rt_name,  
        t.subrt_code subrt_code,(select subrt_name from cir_sub_route_mast where comp_code=t.comp_code and unit=t.unit_code and route_code=t.rt_code and subrt_code=t.subrt_code) subrt_name, 
        t.sub_subrt_code sub_subrt_code,(select sub_subrt_name from cir_sub_subroute_mast where comp_code=t.comp_code and unit=t.unit_code and route_code=t.rt_code and subrt_code=t.subrt_code and sub_subrt_code=t.sub_subrt_code) sub_subrt_name,
        t.taxi_id ,t.vehicle_name vehicle_name, t.vehicle_no vehicle_no
        from cir_taxi_mast t,cir_route_mast r
        where t.comp_code=r.comp_code and t.comp_code='''+@pcomp_code+''' and t.unit_code=r.unit and (t.unit_code='''+@punit_code+''' or '''+@punit_code+''' is null) and 
        t.rt_code=r.route_code and (t.rt_code='''+@proute_code+''' or '''+@proute_code+''' is null) and taxi_id='''+@ptaxi_code+''') x,
        (select distinct b.comp_code comp_code,b.unit unit_code,b.route_code route_code,b.subroute_code subroute_code,
        b.sub_subroute_code sub_subroute_code,a.station_code drop_point_code,c.drop_point_name drop_point_name,
        c.latitude latitude,c.lognitude lognitude,b.lbl_printno lbl_printno,c.DROP_POINT_SEQNO
        from cir_agmast a,cir_supply b,cir_drop_point_mast c
        where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code='''+@pcomp_code+''' and a.unit=b.unit and
        a.unit=c.unit_code and (a.unit='''+@punit_code+''' or '''+@punit_code+''' is null) and a.agcd=b.agcd and a.dpcd=b.dpcd and
        a.station_code=c.drop_point and (b.route_code='''+@proute_code+''' or '''+@proute_code+''' is null) and 
        isnull(a.suspend,''N'')=''N'' and isnull(a.freeze_flag,''N'')=''N'' and isnull(c.freeze_flag,''N'')=''N'') y
        where x.comp_code=y.comp_code and x.unit_code=y.unit_code and x.rt_code=y.route_code and 
        x.subrt_code=y.subroute_code and (x.subrt_code='''+@psubroutecode+''' or '''+@psubroutecode+''' is null) and y.subroute_code is not null and y.sub_subroute_code is null
        group by x.comp_code, x.unit_code, x.tpt_code,x.tpt_name,
        x.rt_code,x.rt_name,x.subrt_code, x.subrt_name,x.sub_subrt_code,x.sub_subrt_name,
        x.taxi_id, x.vehicle_name, x.vehicle_no,
        y.drop_point_code,y.drop_point_name,y.latitude,y.lognitude,y.DROP_POINT_SEQNO
        order by x.comp_code, x.unit_code,x.taxi_id,y.drop_point_name';
	End
    else Begin
PRINT('NEHA')  
    SET @query='    
 select DISTINCT X.COMP_CODE COMP_CODE, X.UNIT_CODE UNIT_CODE, X.TPT_CODE TPT_CODE,X.TPT_NAME TPT_NAME,
        X.RT_CODE RT_CODE,X.RT_NAME RT_NAME,X.SUBRT_CODE SUBRT_CODE, X.SUBRT_NAME SUBRT_NAME,X.SUB_SUBRT_CODE SUB_SUBRT_CODE,X.SUB_SUBRT_NAME SUB_SUBRT_NAME,
        X.TAXI_ID TAXI_ID, X.VEHICLE_NAME VEHICLE_NAME, X.VEHICLE_NO VEHICLE_NO,
        Y.DROP_POINT_CODE DROP_POINT_CODE,Y.DROP_POINT_NAME DROP_POINT_NAME,Y.LATITUDE LATITUDE,Y.LOGNITUDE "LONGITUDE",
        MIN(Y.LBL_PRINTNO) LBL_PRINTNO,x.DROP_POINT_SEQNO 
        from
        (select t.comp_code comp_code, t.unit_code unit_code, t.tpt_code tpt_code,(select transporter_name from cir_transporter_mast where comp_code=t.comp_code and transporter_code=t.tpt_code) tpt_name,
        t.rt_code rt_code,r.route_name rt_name, 
        t.subrt_code subrt_code,(select subrt_name from cir_sub_route_mast where comp_code=t.comp_code and unit=t.unit_code and route_code=t.rt_code and subrt_code=t.subrt_code) subrt_name, 
        t.sub_subrt_code sub_subrt_code,(select sub_subrt_name from cir_sub_subroute_mast where comp_code=t.comp_code and unit=t.unit_code and route_code=t.rt_code and subrt_code=t.subrt_code and sub_subrt_code=t.sub_subrt_code) sub_subrt_name,
        t.taxi_id, t.vehicle_name vehicle_name, t.vehicle_no vehicle_no 
        from cir_taxi_mast t,cir_route_mast r
        where t.comp_code=r.comp_code and t.comp_code='''+@pcomp_code+''' and t.unit_code=r.unit and (t.unit_code='''+@punit_code+''' or '''+@punit_code+''' is null) and 
        t.rt_code=r.route_code and (t.rt_code='''+@proute_code+''' or '''+@proute_code+''' is null) and taxi_id='''+@ptaxi_code+''') x,
        (select distinct b.comp_code comp_code,b.unit unit_code,b.route_code route_code,b.subroute_code subroute_code,
        b.sub_subroute_code sub_subroute_code,a.station_code drop_point_code,c.drop_point_name drop_point_name,
        c.latitude latitude,c.lognitude lognitude,b.lbl_printno lbl_printno,c.DROP_POINT_SEQNO
        from cir_agmast a,cir_supply b,cir_drop_point_mast c
        where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code='''+@pcomp_code+''' and a.unit=b.unit and
        a.unit=c.unit_code and (a.unit='''+@punit_code+''' or '''+@punit_code+''' is null) and a.agcd=b.agcd and a.dpcd=b.dpcd and
        a.station_code=c.drop_point and (b.route_code='''+@proute_code+''' or '''+@proute_code+''' is null) and 
        isnull(a.suspend,''N'')=''N'' and isnull(a.freeze_flag,''N'')=''N'' and isnull(c.freeze_flag,''N'')=''N'') y
        where x.comp_code=y.comp_code and x.unit_code=y.unit_code and x.rt_code=y.route_code and 
        x.subrt_code=y.subroute_code and (x.subrt_code='''+@psubroutecode+''' or '''+@psubroutecode+''' is null) and 
        x.sub_subrt_code=y.sub_subroute_code and (x.sub_subrt_code='''+@psub_subroutecode+''' or '''+@psub_subroutecode+''' is null) and 
        y.subroute_code is not null and y.sub_subroute_code is not null
        group by x.comp_code, x.unit_code, x.tpt_code,x.tpt_name,
        x.rt_code,x.rt_name,x.subrt_code, x.subrt_name,x.sub_subrt_code,x.sub_subrt_name,
        x.taxi_id, x.vehicle_name, x.vehicle_no,y.drop_point_code,y.drop_point_name,y.latitude,y.lognitude,x.DROP_POINT_SEQNO 
        order by x.comp_code, x.unit_code,x.taxi_id,y.drop_point_name';       
    End
End

PRINT(@query)
EXEC(@query)


/////////////////////////////////5 march 2012 end/////by rahul/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////
update by Garima
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER procedure [dbo].[cir_route_editionwise_print](
    @pcompcode      as varchar(500),
    @punitcode      as varchar(500),
    @ppublcode      as varchar(500),
    @pmainedtn      as varchar(500),
    @pedtncode      as varchar(500),
    @proute         as varchar(500),
    @pfrom_supdate  as datetime,
    @ptill_supdate  as datetime,
    @plangtype      as varchar(500),
    @pdateformat    as varchar(500),
    @pextra1        as varchar(500),
    @pextra2        as varchar(500),
    @pextra3        as varchar(500),--------supply posted final and un final
    @pextra4        as varchar(500),
    @pextra5        as varchar(500),
    @pextra6        as varchar(500),
    @pextra7        as varchar(500),
    @pextra8        as varchar(500),
    @pextra9        as varchar(500),
    @pextra10       as varchar(500)

)
as
SET CONCAT_NULL_YIELDS_NULL OFF
--CREATE TABLE #CIR_TEMP_DT
--(
--  SQNO  NUMeric,
--  DT    DATEtime
--)
declare @vsupdate  as  datetime;
declare @vsupdate1  as datetime;
declare @vvar    as varchar(max);
declare @vvar_sum   as  varchar(max);
declare @vvar_sum1  as  varchar(max);
declare @v_query  as  varchar(max);
declare @v_query1  as  varchar(max);

set @vsupdate =@pfrom_supdate
set @vsupdate1=@ptill_supdate

declare cur_edtn cursor for
    select distinct d.publ publ,d.edtn edtn,p.edtn_seq_no edtn_seqno,
    case @plangtype when '1' then substring(p.edition_nick,1,15)
    else substring(p.edtn_name_oth_lang,1,20) end edtn_name
    ,d.sup_rate sup_rate,p.main_edtn main_edtn
    from cir_route_mast m,cir_dbksup d ,cir_edtn_mast p ,cir_supply_type_mast k
    where m.comp_code=@pcompcode and m.comp_code=d.comp_code and d.comp_code=p.comp_code and m.unit=d.unit_code and
    d.comp_code=k.comp_code  and d.sup_type_code=k.sup_ty_code and 
    m.unit=p.unit_code and d.unit_code = @punitcode and
    d.supdate >= @vsupdate and d.supdate <=@vsupdate1 and
    m.route_code=d.route_code and (m.route_code=@proute or @proute is null)
    and d.publ=isnull(@ppublcode,d.publ) and
    d.publ=p.publ and d.edtn=p.edtn and k.bill_pay='Y'
    order by publ,main_edtn,edtn_seqno,edtn,sup_rate
print('a')
-- cursor variable for cur_edtn
declare @rec_edtn_publ as varchar(200)
declare @rec_edtn_edtn as varchar(200)
declare @rec_edtn_edtn_seqno as numeric(5)
declare @rec_edtn_edtn_name as varchar(500)
declare @rec_edtn_sup_rate as numeric(14,2)
declare @rec_edtn_main_edtn as varchar(200)
-- end here --

OPEN cur_edtn 
    fetch NEXT FROM cur_edtn INTO @rec_edtn_publ , @rec_edtn_edtn,@rec_edtn_edtn_seqno,@rec_edtn_edtn_name,@rec_edtn_sup_rate,@rec_edtn_main_edtn
        WHILE (@@FETCH_STATUS = 0) 
        BEGIN
            if (@vvar is null or @vvar = '') begin 
                set @vvar        ='sum(case edtn when '+''''+@rec_edtn_edtn+''''+' then sup_copy else 0 end) "'+@rec_edtn_edtn_name+'"';
                set @vvar_sum    ='sum('+'"'+@rec_edtn_edtn_name+'") "'+@rec_edtn_edtn_name+'"';
                set @vvar_sum1   ='sum('+'"'+@rec_edtn_edtn_name+'"';
            end
            else
            begin
                set @vvar        =@vvar+','+'sum(case edtn when '+''''+@rec_edtn_edtn+''''+' then sup_copy else 0 end) "'+@rec_edtn_edtn_name+'"';
                set @vvar_sum    =@vvar_sum+','+'sum('+'"'+@rec_edtn_edtn_name+'") "'+@rec_edtn_edtn_name+'"';
                set @vvar_sum1   =@vvar_sum1+'+"'+@rec_edtn_edtn_name+'"';
            end
                
                
    fetch NEXT FROM cur_edtn INTO @rec_edtn_publ , @rec_edtn_edtn,@rec_edtn_edtn_seqno,@rec_edtn_edtn_name,@rec_edtn_sup_rate,@rec_edtn_main_edtn
END     
close cur_edtn
DEALLOCATE cur_edtn

if @vvar_sum1 is not null or @vvar_sum1 !='' begin
    set @vvar_sum1=@vvar_sum1+') "Total"'
end
print(@vvar)
 if @vvar is null or @vvar ='' begin
    set @v_query='select x.comp_code,x.unit_code,x.route_code,x.route_name from(select d.comp_code,d.unit_code,d.route_code,
            case '''+@plangtype+''' when ''1'' then substring(m.route_name,1,25)
            else substring(m.route_name_oth_lang,1,25) end route_name 
            from cir_dbksup d,cir_route_mast m ,cir_supply_type_mast k
            where d.comp_code = m.comp_code and d.unit_code = m.unit 
            and d.comp_code=k.comp_code  and d.sup_type_code=k.sup_ty_code and d.comp_code = '+''''+@pcompcode+''''+' and
            d.unit_code = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and
            d.route_code = m.route_code  and 
            d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <='+''''+cast(@vsupdate1 as varchar)+''''+' 
            and k.bill_pay=''Y'' 
            and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' ='''')
            group by d.comp_code,d.unit_code,d.route_code,m.route_name) x
            group by x.comp_code,x.unit_code,x.route_code,x.route_name
            order by x.comp_code,x.unit_code,x.route_code,x.route_name';
end
else
begin        
    set @v_query='select x.comp_code,x.unit_code,x.route_code,x.route_name,'+@vvar_sum+','+@vvar_sum1+' from(select d.comp_code,d.unit_code,d.route_code route_code,
            case '''+@plangtype+''' when ''1'' then substring(m.route_name,1,25) 
            else substring(m.route_name_oth_lang,1,25) end route_name
            ,'+@vvar+' from cir_dbksup d,cir_route_mast m,cir_supply_type_mast k
            where d.comp_code = m.comp_code and d.unit_code = m.unit 
            and d.comp_code=k.comp_code  and d.sup_type_code=k.sup_ty_code  and d.comp_code = '+''''+@pcompcode+''''+' and
            d.unit_code = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and
            d.route_code = m.route_code  and
            d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <= '+''''+cast(@vsupdate1 as varchar)+''''+' 
            and k.bill_pay=''Y'' 
            and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' ='''')
            group by d.comp_code,d.unit_code,m.route_name,d.route_code) x
            group by x.comp_code,x.unit_code,x.route_code,x.route_name
            order by x.comp_code,x.unit_code,x.route_code,x.route_name';       
end
print(@v_query)
exec(@v_query)  
print('q')
-- for free supply
    set @vvar=null
    set @vvar_sum=null
    set @vvar_sum1=null
    
declare cur_edtn_free cursor for
    select distinct d.publ publ,d.edtn edtn,p.edtn_seq_no edtn_seqno,
    case @plangtype when '1' then substring(p.edition_nick,1,15)
    else substring(p.edtn_name_oth_lang,1,20) end edtn_name
    ,d.sup_rate sup_rate,p.main_edtn main_edtn
    from cir_supply_type_mast m,cir_dbksup d ,cir_edtn_mast p 
    where m.comp_code=@pcompcode and m.comp_code=d.comp_code and d.comp_code=p.comp_code and 
      d.comp_code=m.comp_code  and d.sup_type_code=m.sup_ty_code and 
      d.unit_code=p.unit_code and d.unit_code = @punitcode and
      d.supdate >= @vsupdate and d.supdate <=@vsupdate1 and
      d.publ=isnull(@ppublcode,d.publ) and
      d.publ=p.publ and d.edtn=p.edtn and m.bill_pay='N'
      order by publ,main_edtn,edtn_seqno,edtn,sup_rate
-- cursor variable for cur_edtn_free
declare @rec_edtn_free_publ as varchar(200)
declare @rec_edtn_free_edtn as varchar(200)
declare @rec_edtn_free_edtn_seqno as numeric(5)
declare @rec_edtn_free_edtn_name as varchar(500)
declare @rec_edtn_free_sup_rate as numeric(14,2)
declare @rec_edtn_free_main_edtn as varchar(200)
-- end here --

OPEN cur_edtn_free 
    fetch NEXT FROM cur_edtn_free INTO @rec_edtn_free_publ , @rec_edtn_free_edtn,@rec_edtn_free_edtn_seqno,@rec_edtn_free_edtn_name,@rec_edtn_free_sup_rate,@rec_edtn_free_main_edtn
        WHILE (@@FETCH_STATUS = 0) 
        BEGIN
            if (@vvar is null or @vvar = '') begin 
                set @vvar        ='sum(case edtn when '+''''+@rec_edtn_free_edtn+''''+' then sup_copy else 0 end) "'+@rec_edtn_free_edtn_name+'"';
                set @vvar_sum    ='sum('+'"'+@rec_edtn_free_edtn_name+'") "'+@rec_edtn_free_edtn_name+'"';
                set @vvar_sum1   ='sum('+'"'+@rec_edtn_free_edtn_name+'"';
            end
            else
            begin
                set @vvar        =@vvar+','+'sum(case edtn when '+''''+@rec_edtn_free_edtn+''''+' then sup_copy else 0 end) "'+@rec_edtn_free_edtn_name+'"';
                set @vvar_sum    =@vvar_sum+','+'sum('+'"'+@rec_edtn_free_edtn_name+'") "'+@rec_edtn_free_edtn_name+'"';
                set @vvar_sum1   =@vvar_sum1+'+"'+@rec_edtn_free_edtn_name+'"';
            end
                
                
    fetch NEXT FROM cur_edtn_free INTO @rec_edtn_free_publ , @rec_edtn_free_edtn,@rec_edtn_free_edtn_seqno,@rec_edtn_free_edtn_name,@rec_edtn_free_sup_rate,@rec_edtn_free_main_edtn
END     
close cur_edtn_free
DEALLOCATE cur_edtn_free
if @vvar_sum1 is not null or @vvar_sum1 !='' begin
    set @vvar_sum1=@vvar_sum1+') "Total"'
end

        if @vvar is null or @vvar ='' begin
            set @v_query1='select x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name from(select d.comp_code,d.unit_code,m.sup_ty_code,
            substring(m.sup_ty_name,1,25) supply_name
            from cir_dbksup d,cir_supply_type_mast m
            where d.comp_code = m.comp_code 
            and d.sup_type_code=m.sup_ty_code
            and d.comp_code = '+''''+@pcompcode+''''+' and
            d.unit_code = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and            
            d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <='+''''+cast(@vsupdate1 as varchar)+''''+' 
            and m.bill_pay=''N'' 
            and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' ='''')
            group by d.comp_code,d.unit_code,m.sup_ty_code,m.sup_ty_name) x
            group by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name
            order by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name';
        end
        else
        begin
            set @v_query1='select x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name,'+@vvar_sum+','+@vvar_sum1+' from
            (select d.comp_code,d.unit_code,m.sup_ty_code sup_ty_code,
            substring(m.sup_ty_name,1,25) supply_name
            ,'+@vvar+' from cir_dbksup d,cir_supply_type_mast m
            where d.comp_code = m.comp_code
             and d.sup_type_code=m.sup_ty_code 
            and d.comp_code = '+''''+@pcompcode+''''+' and
            d.unit_code = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and            
             d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <= '+''''+cast(@vsupdate1 as varchar)+''''+' 
             and m.bill_pay=''N'' and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' = '''')
            group by d.comp_code,d.unit_code,m.sup_ty_code,m.sup_ty_name) x
            group by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name
            order by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name';
        end

print(@v_query1)
exec(@v_query1)




 set @vvar=null
    set @vvar_sum=null
    set @vvar_sum1=null


-------------------for edition total


declare cur_edtn_total cursor for
    select distinct d.publ publ,d.edtn edtn,p.edtn_seq_no edtn_seqno,
    case @plangtype when '1' then substring(p.edition_nick,1,15)
    else substring(p.edtn_name_oth_lang,1,20) end edtn_name
    ,d.sup_rate sup_rate,p.main_edtn main_edtn
    from cir_supply_type_mast m,cir_dbksup d ,cir_edtn_mast p 
    where m.comp_code=@pcompcode and m.comp_code=d.comp_code and d.comp_code=p.comp_code and 
      d.comp_code=m.comp_code  and d.sup_type_code=m.sup_ty_code and 
      d.unit_code=p.unit_code and d.unit_code = @punitcode and
      d.supdate >= @vsupdate and d.supdate <=@vsupdate1 and
      d.publ=isnull(@ppublcode,d.publ) and
      d.publ=p.publ and d.edtn=p.edtn 
      order by publ,main_edtn,edtn_seqno,edtn,sup_rate
    
-- cursor variable for cur_edtn_free
declare @rec_edtn_total_publ as varchar(200)
declare @rec_edtn_total_edtn as varchar(200)
declare @rec_edtn_total_edtn_seqno as numeric(5)
declare @rec_edtn_total_edtn_name as varchar(500)
declare @rec_edtn_total_sup_rate as numeric(14,2)
declare @rec_edtn_total_main_edtn as varchar(200)
-- end here --

OPEN cur_edtn_total 
    fetch NEXT FROM cur_edtn_total INTO @rec_edtn_total_publ , @rec_edtn_total_edtn,@rec_edtn_total_edtn_seqno,@rec_edtn_total_edtn_name,@rec_edtn_total_sup_rate,@rec_edtn_total_main_edtn
        WHILE (@@FETCH_STATUS = 0) 
        BEGIN
            if (@vvar is null or @vvar = '') begin 
                set @vvar        ='sum(case edtn when '+''''+@rec_edtn_total_edtn+''''+' then sup_copy else 0 end) "'+@rec_edtn_total_edtn_name+'"';
                set @vvar_sum    ='sum('+'"'+@rec_edtn_total_edtn_name+'") "'+@rec_edtn_total_edtn_name+'"';
                set @vvar_sum1   ='sum('+'"'+@rec_edtn_total_edtn_name+'"';
            end
            else
            begin
                set @vvar        =@vvar+','+'sum(case edtn when '+''''+@rec_edtn_total_edtn+''''+' then sup_copy else 0 end) "'+@rec_edtn_total_edtn_name+'"';
                set @vvar_sum    =@vvar_sum+','+'sum('+'"'+@rec_edtn_total_edtn_name+'") "'+@rec_edtn_total_edtn_name+'"';
                set @vvar_sum1   =@vvar_sum1+'+"'+@rec_edtn_total_edtn_name+'"';
            end
                
                
    fetch NEXT FROM cur_edtn_total INTO @rec_edtn_total_publ , @rec_edtn_total_edtn,@rec_edtn_total_edtn_seqno,@rec_edtn_total_edtn_name,@rec_edtn_total_sup_rate,@rec_edtn_total_main_edtn
END     
close cur_edtn_total
DEALLOCATE cur_edtn_total
if @vvar_sum1 is not null or @vvar_sum1 !='' begin
    set @vvar_sum1=@vvar_sum1+') "Total"'
end

        if @vvar is null or @vvar ='' begin
            set @v_query1='select x.comp_code,x.unit_code
            ,
            --x.sup_ty_code,
            ''a'' as "sup_ty_code",
           -- x.supply_name from(select d.comp_code,d.unit_code,m.sup_ty_code,
            --substring(m.sup_ty_name,1,25) supply_name
            ''a'' as "supply_name",
            
            from cir_dbksup d,cir_supply_type_mast m
            where d.comp_code = m.comp_code 
            and d.sup_type_code=m.sup_ty_code
            and d.comp_code = '+''''+@pcompcode+''''+' and
            d.unit_code = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and            
            d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <='+''''+cast(@vsupdate1 as varchar)+''''+' 
            
            and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' ='''')
            group by d.comp_code,d.unit_code,m.sup_ty_code,m.sup_ty_name) x
            group by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name
            order by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name';
        end
        else
        begin
            set @v_query1='select x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name,'+@vvar_sum+','+@vvar_sum1+' from
            (select d.comp_code,d.unit_code,
            ''a'' as "sup_ty_code",
            --m.sup_ty_code sup_ty_code,
            --substring(m.sup_ty_name,1,25) supply_name
            ''a'' as "supply_name"
            ,'+@vvar+' from cir_dbksup d,cir_supply_type_mast m
            where d.comp_code = m.comp_code
             and d.sup_type_code=m.sup_ty_code 
            and d.comp_code = '+''''+@pcompcode+''''+' and
            d.unit_code = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and            
             d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <= '+''''+cast(@vsupdate1 as varchar)+''''+' 
              and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' = '''')
            group by d.comp_code,d.unit_code,m.sup_ty_code,m.sup_ty_name) x
            group by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name
            order by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name';
        end

print(@v_query1)
exec(@v_query1)











SET CONCAT_NULL_YIELDS_NULL On







//////////////////////////////////update by  Garima (end)
/////////////////////////////////(startby Garima)

                                                                     
                                                                     
                                                                     
                                             
create PROCEDURE [dbo].[cir_rep_unsold_copybranch]
(
	 @pcomp_code         as varchar(200),
     @punit_code         as varchar(200),
     @pdoc_type          as varchar(200),
     @ppubl              as varchar(200),
     @pmainedtn          as varchar(200),
     @pedtn              as varchar(200),
     @pcity              as varchar(200),
     @pagcode            as varchar(200),
     @pdepocode          as varchar(200),
     @pagtype            as varchar(200),
     @pagclass           as varchar(200),
     @pfrom_recdate      as datetime,
     @ptill_recdate      as datetime,
     @papproved_flag     as varchar(200),
     @pdateformat        as varchar(200),
     @pextra1            as varchar(200),
     @pextra2            as varchar(200)

)
AS 

 declare  @v_frdt     as   datetime;
 declare  @v_todt  as   datetime;
 
	set @v_frdt=@pfrom_recdate
	set @v_todt=@ptill_recdate
	
	
if upper(isnull(@papproved_flag,'N'))='C' 
begin
    select b.comp_code,dbo.get_company_name (b.comp_code) company_name,b.unit_code,a.ag_name ,b.doctype,b.supdate,b.copy_rate,
                sum(b.short_recpt) short_recpt,sum(b.late_recpt) late_recpt,sum(b.bnr) bnr,sum(b.unsold) unsold,sum(b.damage) damage  from cir_agmast a,cir_unsold_dtl b 
                WHERE b.comp_code =a.comp_code 
                and b.comp_code  =@pcomp_code 
                and    b.unit_code=a.unit 
                and b.unit_code=@punit_code 
                and b.doctype=@pdoc_type 
                and b.recptdt between @v_frdt and @v_todt 
                and a.agcd=b.agcd and a.dpcd=b.dpcd 
                and ((b.agcd=@pagcode) or (@pagcode is null) or (@pagcode ='')) 
                and((b.dpcd=@pdepocode) or (@pdepocode is null) or (@pdepocode ='')) 
                and ((b.publ=@ppubl) or (@ppubl is null) or (@ppubl ='')) 
                and ((b.edtn=@pedtn) or (@pedtn is null) or (@pedtn ='')) 
                and  (a.ag_type=@pagtype or @pagtype is null or @pagtype ='')
                and (a.ag_class=@pagclass or @pagclass is null or @pagclass ='')
                and(isnull(b.short_recpt,0)+isnull(b.late_recpt,0)+isnull(b.bnr,0)+isnull(b.unsold,0))>0
                group by b.comp_code,b.unit_code,a.ag_name,b.doctype,b.copy_rate,b.supdate
                order by b.comp_code,b.unit_code,a.ag_name,b.doctype,b.copy_rate,b.supdate
end
else if upper(isnull(@papproved_flag,'N'))='N' 
begin
     select  b.comp_code,dbo.get_company_name (b.comp_code) company_name,b.unit_code,a.ag_name ,b.doctype,b.supdate,b.copy_rate,
            sum(b.var_short_recpt) var_short_recpt,sum(b.var_late_recpt) var_late_recpt,sum(b.var_bnr) var_bnr,
            sum(b.var_unsold) var_unsold,sum(b.var_damage) var_damage from cir_agmast a,cir_unsold_dtl b
            WHERE b.comp_code  =a.comp_code 
            and b.comp_code    =@pcomp_code 
            and b.unit_code=a.unit 
            and b.unit_code=@punit_code 
            and b.doctype=@pdoc_type 
            and b.recptdt between @v_frdt and @v_todt 
            and a.agcd=b.agcd 
            and a.dpcd=b.dpcd
            and ((b.agcd=@pagcode) or (@pagcode is null) or (@pagcode ='')) 
            and ((b.dpcd=@pdepocode) or (@pdepocode is null) or (@pdepocode ='')) 
            and((b.publ=@ppubl) or (@ppubl is null) or (@ppubl ='')) 
            and  (a.ag_type=@pagtype or @pagtype is null or @pagtype ='')
            and (a.ag_class=@pagclass or @pagclass is null or @pagclass ='')
            and ((b.edtn=@pedtn) or (@pedtn is null) or (@pedtn ='')) 
            and (isnull(b.var_short_recpt,0)+isnull(b.var_late_recpt,0)+isnull(b.var_bnr,0)+isnull(b.var_unsold,0))>0
            group by b.comp_code,b.unit_code,a.ag_name,b.doctype,b.copy_rate,b.supdate
            order by b.comp_code,b.unit_code,a.ag_name,b.doctype,b.copy_rate,b.supdate;
end
else
begin
	select b.comp_code,dbo.get_company_name (b.comp_code) company_name,b.unit_code,a.ag_name,b.doctype,b.supdate,b.copy_rate,
            sum(b.apr_short_recpt) apr_short_recpt,
            sum(b.apr_late_recpt) apr_late_recpt,sum(b.apr_bnr) apr_bnr,sum(b.apr_unsold) apr_unsold,sum(b.apr_damage) apr_damage 
            from cir_agmast a,cir_unsold_dtl b
            WHERE 
            b.comp_code =a.comp_code 
            and b.comp_code =@pcomp_code 
            and b.unit_code=a.unit 
            and b.unit_code=@punit_code 
            and b.doctype=@pdoc_type 
            and b.app_dt between @v_frdt and @v_todt 
            and a.agcd=b.agcd and a.dpcd=b.dpcd 
            and ((b.agcd=@pagcode) or (@pagcode is null) or (@pagcode =''))
            and((b.dpcd=@pdepocode) or (@pdepocode is null) or (@pdepocode ='')) 
            and ((b.publ=@ppubl) or (@ppubl is null) or (@ppubl ='')) 
            and ((b.edtn=@pedtn) or (@pedtn is null) or (@pedtn ='')) 
            and((a.city_code=@pcity) or (@pcity is null) or (@pcity ='')) 
            and  (a.ag_type=@pagtype or @pagtype is null or @pagtype ='')
            and (a.ag_class=@pagclass or @pagclass is null or @pagclass ='')
            and (isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0))>0
            group by b.comp_code,b.unit_code,a.ag_name,b.doctype,b.copy_rate,b.supdate
            order by b.comp_code,b.unit_code,b.doctype,b.copy_rate,b.supdate;
end
/////////////////////////////////////////////////
                                                                     
                                                                     
                                                                     
                                             
create PROCEDURE [dbo].[cir_rep_unsold_copyagency]
(
	 @pcomp_code         as varchar(200),
     @punit_code         as varchar(200),
     @pdoc_type          as varchar(200),
     @ppubl              as varchar(200),
     @pmainedtn          as varchar(200),
     @pedtn              as varchar(200),
     @pcity              as varchar(200),
     @pagcode            as varchar(200),
     @pdepocode          as varchar(200),
     @pagtype            as varchar(200),
     @pagclass           as varchar(200),
     @pfrom_recdate      as datetime,
     @ptill_recdate      as datetime,
     @papproved_flag     as varchar(200),
     @pdateformat        as varchar(200),
     @pextra1            as varchar(200),
     @pextra2            as varchar(200)

)
AS 

 declare  @v_frdt     as   datetime;
 declare  @v_todt  as   datetime;
 
	set @v_frdt=@pfrom_recdate
	set @v_todt=@ptill_recdate
	
	
if upper(isnull(@papproved_flag,'N'))='C' 
begin
    select b.comp_code,dbo.get_company_name (b.comp_code) company_name,b.unit_code,b.publ,
    dbo.cir_get_publ_name(b.comp_code,publ) publ_name,b.edtn,dbo.cir_get_edtn_name(b.comp_code,b.edtn)edtn_name,a.ag_name ,b.doctype,b.supdate,b.copy_rate,
    sum(b.short_recpt) short_recpt,sum(b.late_recpt) late_recpt,sum(b.bnr) bnr,sum(b.unsold) unsold,sum(b.damage) damage  from cir_agmast a,cir_unsold_dtl b 
    WHERE b.comp_code =a.comp_code 
    and b.comp_code =@pcomp_code
    and b.unit_code=a.unit 
    and b.unit_code=@punit_code 
    and b.doctype=@pdoc_type 
    and b.recptdt between @v_frdt and @v_todt 
    and a.agcd=b.agcd and a.dpcd=b.dpcd 
    and ((b.agcd=@pagcode) or (@pagcode is null) or (@pagcode ='')) 
    and ((b.dpcd=@pdepocode) or (@pdepocode is null) or (@pdepocode =''))
    and((b.publ=@ppubl) or (@ppubl is null) or (@ppubl ='')) 
    and ((b.edtn=@pedtn) or (@pedtn is null) or (@pedtn ='')) 
    and  (a.ag_type=@pagtype or @pagtype is null or @pagtype ='')
    and (a.ag_class=@pagclass or @pagclass is null or @pagclass ='')
    and(isnull(b.short_recpt,0)+isnull(b.late_recpt,0)+isnull(b.bnr,0)+isnull(b.unsold,0))>0
    group by b.comp_code,b.unit_code,b.publ,b.edtn,a.ag_name,b.doctype,b.copy_rate,b.supdate
    order by b.comp_code,b.unit_code,b.publ,b.edtn,a.ag_name,b.doctype,b.copy_rate,b.supdate
end
else if upper(isnull(@papproved_flag,'N'))='N' 
begin
    select  b.comp_code,dbo.get_company_name (b.comp_code) company_name,b.unit_code,b.publ,
    dbo.cir_get_publ_name(b.comp_code,publ) publ_name,b.edtn,dbo.cir_get_edtn_name(b.comp_code,edtn)edtn_name,a.ag_name ,b.doctype,b.supdate,b.copy_rate,
    sum(b.var_short_recpt) var_short_recpt,sum(b.var_late_recpt) var_late_recpt,sum(b.var_bnr) var_bnr,
    sum(b.var_unsold) var_unsold,sum(b.var_damage) var_damage from cir_agmast a,cir_unsold_dtl b
    WHERE b.comp_code    =a.comp_code and b.comp_code    =@pcomp_code and 
    b.unit_code=a.unit and b.unit_code=@punit_code and 
    b.doctype=@pdoc_type and b.recptdt between @v_frdt and @v_todt and 
    a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd=@pagcode) or (@pagcode is null) or (@pagcode ='')) and
    ((b.dpcd=@pdepocode) or (@pdepocode is null) or (@pdepocode ='')) and
    ((b.publ=@ppubl) or (@ppubl is null) or (@ppubl ='')) 
    and  (a.ag_type=@pagtype or @pagtype is null or @pagtype ='')
    and (a.ag_class=@pagclass or @pagclass is null or @pagclass ='')
    and ((b.edtn=@pedtn) or (@pedtn is null) or (@pedtn ='')) 
    and (isnull(b.var_short_recpt,0)+isnull(b.var_late_recpt,0)+isnull(b.var_bnr,0)+isnull(b.var_unsold,0))>0
    group by b.comp_code,b.unit_code,b.publ,b.edtn,a.ag_name,b.doctype,b.copy_rate,b.supdate
    order by b.comp_code,b.unit_code,b.publ,b.edtn,a.ag_name,b.doctype,b.copy_rate,b.supdate
end
else
begin
	select  b.comp_code,dbo.get_company_name (b.comp_code) company_name,b.unit_code,b.publ,
    dbo.cir_get_publ_name(b.comp_code,b.publ) publ_name,b.edtn,dbo.cir_get_edtn_name(b.comp_code,b.edtn)edtn_name,a.ag_name ,b.doctype,b.supdate,b.copy_rate,
    sum(b.apr_short_recpt) apr_short_recpt,
    sum(b.apr_late_recpt) apr_late_recpt,sum(b.apr_bnr) apr_bnr,sum(b.apr_unsold) apr_unsold,sum(b.apr_damage) apr_damage from  cir_agmast a,cir_unsold_dtl b
    WHERE 
    b.comp_code =a.comp_code 
    and b.comp_code  =@pcomp_code 
    and b.unit_code=a.unit 
    and b.unit_code=@punit_code 
    and b.doctype=@pdoc_type 
    and b.app_dt between @v_frdt and @v_todt 
    and a.agcd=b.agcd and a.dpcd=b.dpcd 
    and ((b.agcd=@pagcode) or (@pagcode is null) or (@pagcode ='')) 
    and((b.dpcd=@pdepocode) or (@pdepocode is null) or (@pdepocode ='')) 
    and ((b.publ=@ppubl) or (@ppubl is null) or (@ppubl ='')) 
    and ((b.edtn=@pedtn) or (@pedtn is null) or (@pedtn =''))
    and((a.city_code=@pcity) or (@pcity is null) or (@pcity ='')) 
    and(a.ag_type=@pagtype or @pagtype is null or @pagtype ='')
    and (a.ag_class=@pagclass or @pagclass is null or @pagclass ='') 
    and (isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0))>0
    group by b.comp_code,b.unit_code,b.publ,b.edtn,a.ag_name,b.doctype,b.copy_rate,b.supdate
    order by b.comp_code,b.unit_code,b.publ,b.edtn,a.ag_name,b.doctype,b.copy_rate,b.supdate;
end
//////////////////////////////////////////////////////////////////

                                                                     
                                                                     
                                                                     
                                             
create PROCEDURE [dbo].[cir_rep_unsold_copypubl]
(
	 @pcomp_code         as varchar(200),
     @punit_code         as varchar(200),
     @pdoc_type          as varchar(200),
     @ppubl              as varchar(200),
     @pmainedtn          as varchar(200),
     @pedtn              as varchar(200),
     @pcity              as varchar(200),
     @pagcode            as varchar(200),
     @pdepocode          as varchar(200),
     @pagtype            as varchar(200),
     @pagclass           as varchar(200),
     @pfrom_recdate      as datetime,
     @ptill_recdate      as datetime,
     @papproved_flag     as varchar(200),
     @pdateformat        as varchar(200),
     @pextra1            as varchar(200),
     @pextra2            as varchar(200)

)
AS 

 declare  @v_frdt     as   datetime;
 declare  @v_todt  as   datetime;
 
	set @v_frdt=@pfrom_recdate
	set @v_todt=@ptill_recdate
	
	
if upper(isnull(@papproved_flag,'N'))='C' 
begin
    select b.comp_code,dbo.get_company_name (b.comp_code) company_name,b.unit_code,b.publ,
    dbo.cir_get_publ_name(b.comp_code,b.publ) publ_name,b.edtn,dbo.cir_get_edtn_name(b.comp_code,b.edtn)edtn_name ,b.doctype,b.supdate,b.copy_rate,
    sum(b.short_recpt) short_recpt,sum(b.late_recpt) late_recpt,sum(b.bnr) bnr,sum(b.unsold) unsold,sum(b.damage) damage  from cir_agmast a,cir_unsold_dtl b 
    WHERE b.comp_code    =a.comp_code 
    and b.comp_code    =@pcomp_code 
    and  b.unit_code=a.unit 
    and b.unit_code=@punit_code
    and b.doctype=@pdoc_type 
    and b.recptdt between @v_frdt and @v_todt 
    and a.agcd=b.agcd and a.dpcd=b.dpcd 
    and ((b.agcd=@pagcode) or (@pagcode is null) or (@pagcode ='')) 
    and((b.dpcd=@pdepocode) or (@pdepocode is null) or (@pdepocode =''))
    and((b.publ=@ppubl) or (@ppubl is null) or (@ppubl =''))
    and ((b.edtn=@pedtn) or (@pedtn is null) or (@pedtn ='')) 
    and  (a.ag_type=@pagtype or @pagtype is null  or @pagtype ='')
    and (a.ag_class=@pagclass or @pagclass is null or @pagclass ='')
    and(isnull(b.short_recpt,0)+isnull(b.late_recpt,0)+isnull(b.bnr,0)+isnull(b.unsold,0))>0
    group by b.comp_code,b.unit_code,b.publ,b.edtn,b.doctype,b.copy_rate,b.supdate
    order by b.comp_code,b.unit_code,b.publ,b.edtn,b.doctype,b.copy_rate,b.supdate ;
end
else if upper(isnull(@papproved_flag,'N'))='N' 
begin
    select  b.comp_code,dbo.get_company_name (b.comp_code) company_name,b.unit_code,b.publ,
    dbo.cir_get_publ_name(b.comp_code,publ) publ_name,b.edtn,dbo.cir_get_edtn_name(b.comp_code,edtn)edtn_name ,b.doctype,b.supdate,b.copy_rate,
    sum(b.var_short_recpt) var_short_recpt,sum(b.var_late_recpt) var_late_recpt,sum(b.var_bnr) var_bnr,
    sum(b.var_unsold) var_unsold,sum(b.var_damage) var_damage from cir_agmast a,cir_unsold_dtl b
    WHERE b.comp_code  =a.comp_code 
    and b.comp_code =@pcomp_code 
    and b.unit_code=a.unit 
    and b.unit_code=@punit_code 
    and b.doctype=@pdoc_type 
    and b.recptdt between @v_frdt and @v_todt 
    and a.agcd=b.agcd and a.dpcd=b.dpcd 
    and ((b.agcd=@pagcode) or (@pagcode is null) or (@pagcode =''))
    and((b.dpcd=@pdepocode) or (@pdepocode is null) or (@pdepocode =''))
    and    ((b.publ=@ppubl) or (@ppubl is null) or (@ppubl='')) 
    and  (a.ag_type=@pagtype or @pagtype is null or @pagtype ='')
    and (a.ag_class=@pagclass or @pagclass is null or @pagclass ='')
    and ((b.edtn=@pedtn) or (@pedtn is null) or (@pedtn ='')) 
    and (isnull(b.var_short_recpt,0)+isnull(b.var_late_recpt,0)+isnull(b.var_bnr,0)+isnull(b.var_unsold,0))>0
    group by b.comp_code,b.unit_code,b.publ,b.edtn,b.doctype,b.copy_rate,b.supdate
    order by b.comp_code,b.unit_code,b.publ,b.edtn,b.doctype,b.copy_rate,b.supdate 
end
else
begin
	select  b.comp_code,dbo.get_company_name (b.comp_code) company_name,b.unit_code,b.publ,
	dbo.cir_get_publ_name(b.comp_code,b.publ) publ_name,b.edtn,dbo.cir_get_edtn_name(b.comp_code,b.edtn)edtn_name ,b.doctype,b.supdate,b.copy_rate,
	sum(b.apr_short_recpt) apr_short_recpt,
	sum(b.apr_late_recpt) apr_late_recpt,sum(b.apr_bnr) apr_bnr,sum(b.apr_unsold) apr_unsold,sum(b.apr_damage) apr_damage from  cir_agmast a,cir_unsold_dtl b
	WHERE 
	b.comp_code =a.comp_code 
	and b.comp_code =@pcomp_code 
	and b.unit_code=a.unit 
	and b.unit_code=@punit_code 
	and    b.doctype=@pdoc_type 
	and b.app_dt between @v_frdt and @v_todt 
	and a.agcd=b.agcd 
	and a.dpcd=b.dpcd 
	and ((b.agcd=@pagcode) or (@pagcode is null) or (@pagcode='')) 
	and((b.dpcd=@pdepocode) or (@pdepocode is null) or (@pdepocode='')) 
	and ((b.publ=@ppubl) or (@ppubl is null) or (@ppubl ='')) 
	and ((b.edtn=@pedtn) or (@pedtn is null) or (@pedtn =''))
	and((a.city_code=@pcity) or (@pcity is null) or (@pcity =''))
	and(a.ag_type=@pagtype or @pagtype is null or @pagtype ='')
	and (a.ag_class=@pagclass or @pagclass is null or @pagclass ='') 
	and(isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0))>0
	group by b.comp_code,b.unit_code,b.publ,b.edtn,b.doctype,b.copy_rate,b.supdate
	order by b.comp_code,b.unit_code,b.publ,b.edtn,b.doctype,b.copy_rate,b.supdate;
end
////////////////////////////////////////////////end by  Garima
////////////////////////update by Garima (Print order)
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER procedure [dbo].[cir_route_editionwise_print](
    @pcompcode      as varchar(500),
    @punitcode      as varchar(500),
    @ppublcode      as varchar(500),
    @pmainedtn      as varchar(500),
    @pedtncode      as varchar(500),
    @proute         as varchar(500),
    @pfrom_supdate  as datetime,
    @ptill_supdate  as datetime,
    @plangtype      as varchar(500),
    @pdateformat    as varchar(500),
    @pextra1        as varchar(500),
    @pextra2        as varchar(500),
    @pextra3        as varchar(500),--------supply posted final and un final
    @pextra4        as varchar(500),
    @pextra5        as varchar(500),
    @pextra6        as varchar(500),
    @pextra7        as varchar(500),
    @pextra8        as varchar(500),
    @pextra9        as varchar(500),
    @pextra10       as varchar(500)

)
as
SET CONCAT_NULL_YIELDS_NULL OFF
--CREATE TABLE #CIR_TEMP_DT
--(
--  SQNO  NUMeric,
--  DT    DATEtime
--)
declare @vsupdate  as  datetime;
declare @vsupdate1  as datetime;
declare @vvar    as varchar(max);
declare @vvar_sum   as  varchar(max);
declare @vvar_sum1  as  varchar(max);
declare @v_query  as  varchar(max);
declare @v_query1  as  varchar(max);

set @vsupdate =@pfrom_supdate
set @vsupdate1=@ptill_supdate

declare cur_edtn cursor for
    select distinct d.publ publ,d.edtn edtn,p.edtn_seq_no edtn_seqno,
    case @plangtype when '1' then substring(p.edition_nick,1,15)
    else substring(p.edtn_name_oth_lang,1,20) end edtn_name
    ,d.sup_rate sup_rate,p.main_edtn main_edtn
    from cir_route_mast m,cir_dbksup d ,cir_edtn_mast p ,cir_supply_type_mast k
    where m.comp_code=@pcompcode and m.comp_code=d.comp_code and d.comp_code=p.comp_code and m.unit=d.unit_code and
    d.comp_code=k.comp_code  and d.sup_type_code=k.sup_ty_code and 
    m.unit=p.unit_code and d.unit_code = @punitcode and
    d.supdate >= @vsupdate and d.supdate <=@vsupdate1 and
    m.route_code=d.route_code and (m.route_code=@proute or @proute is null)
    and d.publ=isnull(@ppublcode,d.publ) and
    d.publ=p.publ and d.edtn=p.edtn and k.bill_pay='Y'
    order by publ,main_edtn,edtn_seqno,edtn,sup_rate
print('a')
-- cursor variable for cur_edtn
declare @rec_edtn_publ as varchar(200)
declare @rec_edtn_edtn as varchar(200)
declare @rec_edtn_edtn_seqno as numeric(5)
declare @rec_edtn_edtn_name as varchar(500)
declare @rec_edtn_sup_rate as numeric(14,2)
declare @rec_edtn_main_edtn as varchar(200)
-- end here --

OPEN cur_edtn 
    fetch NEXT FROM cur_edtn INTO @rec_edtn_publ , @rec_edtn_edtn,@rec_edtn_edtn_seqno,@rec_edtn_edtn_name,@rec_edtn_sup_rate,@rec_edtn_main_edtn
        WHILE (@@FETCH_STATUS = 0) 
        BEGIN
            if (@vvar is null or @vvar = '') begin 
                set @vvar        ='sum(case edtn when '+''''+@rec_edtn_edtn+''''+' then sup_copy else 0 end) "'+@rec_edtn_edtn_name+'"';
                set @vvar_sum    ='sum('+'"'+@rec_edtn_edtn_name+'") "'+@rec_edtn_edtn_name+'"';
                set @vvar_sum1   ='sum('+'"'+@rec_edtn_edtn_name+'"';
            end
            else
            begin
                set @vvar        =@vvar+','+'sum(case edtn when '+''''+@rec_edtn_edtn+''''+' then sup_copy else 0 end) "'+@rec_edtn_edtn_name+'"';
                set @vvar_sum    =@vvar_sum+','+'sum('+'"'+@rec_edtn_edtn_name+'") "'+@rec_edtn_edtn_name+'"';
                set @vvar_sum1   =@vvar_sum1+'+"'+@rec_edtn_edtn_name+'"';
            end
                
                
    fetch NEXT FROM cur_edtn INTO @rec_edtn_publ , @rec_edtn_edtn,@rec_edtn_edtn_seqno,@rec_edtn_edtn_name,@rec_edtn_sup_rate,@rec_edtn_main_edtn
END     
close cur_edtn
DEALLOCATE cur_edtn

if @vvar_sum1 is not null or @vvar_sum1 !='' begin
    set @vvar_sum1=@vvar_sum1+') "Total"'
end
print(@vvar)
 if @vvar is null or @vvar ='' begin
    set @v_query='select x.comp_code,x.unit_code,x.route_code,x.route_name from(select d.comp_code,d.unit_code,d.route_code,
            case '''+@plangtype+''' when ''1'' then substring(m.route_name,1,25)
            else substring(m.route_name_oth_lang,1,25) end route_name 
            from cir_dbksup d,cir_route_mast m ,cir_supply_type_mast k
            where d.comp_code = m.comp_code and d.unit_code = m.unit 
            and d.comp_code=k.comp_code  and d.sup_type_code=k.sup_ty_code and d.comp_code = '+''''+@pcompcode+''''+' and
            d.unit_code = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and
            d.route_code = m.route_code  and 
            d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <='+''''+cast(@vsupdate1 as varchar)+''''+' 
            and k.bill_pay=''Y'' 
            and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' ='''')
            group by d.comp_code,d.unit_code,d.route_code,m.route_name) x
            group by x.comp_code,x.unit_code,x.route_code,x.route_name
            order by x.comp_code,x.unit_code,x.route_code,x.route_name';
end
else
begin        
    set @v_query='select x.comp_code,x.unit_code,x.route_code,x.route_name,'+@vvar_sum+','+@vvar_sum1+' from(select d.comp_code,d.unit_code,d.route_code route_code,
            case '''+@plangtype+''' when ''1'' then substring(m.route_name,1,25) 
            else substring(m.route_name_oth_lang,1,25) end route_name
            ,'+@vvar+' from cir_dbksup d,cir_route_mast m,cir_supply_type_mast k
            where d.comp_code = m.comp_code and d.unit_code = m.unit 
            and d.comp_code=k.comp_code  and d.sup_type_code=k.sup_ty_code  and d.comp_code = '+''''+@pcompcode+''''+' and
            d.unit_code = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and
            d.route_code = m.route_code  and
            d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <= '+''''+cast(@vsupdate1 as varchar)+''''+' 
            and k.bill_pay=''Y'' 
            and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' ='''')
            group by d.comp_code,d.unit_code,m.route_name,d.route_code) x
            group by x.comp_code,x.unit_code,x.route_code,x.route_name
            order by x.comp_code,x.unit_code,x.route_code,x.route_name';       
end
print(@v_query)
exec(@v_query)  
print('q')
-- for free supply
    set @vvar=null
    set @vvar_sum=null
    set @vvar_sum1=null
    
declare cur_edtn_free cursor for
    select distinct d.publ publ,d.edtn edtn,p.edtn_seq_no edtn_seqno,
    case @plangtype when '1' then substring(p.edition_nick,1,15)
    else substring(p.edtn_name_oth_lang,1,20) end edtn_name
    ,d.sup_rate sup_rate,p.main_edtn main_edtn
    from cir_supply_type_mast m,cir_dbksup d ,cir_edtn_mast p 
    where m.comp_code=@pcompcode and m.comp_code=d.comp_code and d.comp_code=p.comp_code and 
      d.comp_code=m.comp_code  and d.sup_type_code=m.sup_ty_code and 
      d.unit_code=p.unit_code and d.unit_code = @punitcode and
      d.supdate >= @vsupdate and d.supdate <=@vsupdate1 and
      d.publ=isnull(@ppublcode,d.publ) and
      d.publ=p.publ and d.edtn=p.edtn and m.bill_pay='N'
      order by publ,main_edtn,edtn_seqno,edtn,sup_rate
-- cursor variable for cur_edtn_free
declare @rec_edtn_free_publ as varchar(200)
declare @rec_edtn_free_edtn as varchar(200)
declare @rec_edtn_free_edtn_seqno as numeric(5)
declare @rec_edtn_free_edtn_name as varchar(500)
declare @rec_edtn_free_sup_rate as numeric(14,2)
declare @rec_edtn_free_main_edtn as varchar(200)
-- end here --

OPEN cur_edtn_free 
    fetch NEXT FROM cur_edtn_free INTO @rec_edtn_free_publ , @rec_edtn_free_edtn,@rec_edtn_free_edtn_seqno,@rec_edtn_free_edtn_name,@rec_edtn_free_sup_rate,@rec_edtn_free_main_edtn
        WHILE (@@FETCH_STATUS = 0) 
        BEGIN
            if (@vvar is null or @vvar = '') begin 
                set @vvar        ='sum(case edtn when '+''''+@rec_edtn_free_edtn+''''+' then sup_copy else 0 end) "'+@rec_edtn_free_edtn_name+'"';
                set @vvar_sum    ='sum('+'"'+@rec_edtn_free_edtn_name+'") "'+@rec_edtn_free_edtn_name+'"';
                set @vvar_sum1   ='sum('+'"'+@rec_edtn_free_edtn_name+'"';
            end
            else
            begin
                set @vvar        =@vvar+','+'sum(case edtn when '+''''+@rec_edtn_free_edtn+''''+' then sup_copy else 0 end) "'+@rec_edtn_free_edtn_name+'"';
                set @vvar_sum    =@vvar_sum+','+'sum('+'"'+@rec_edtn_free_edtn_name+'") "'+@rec_edtn_free_edtn_name+'"';
                set @vvar_sum1   =@vvar_sum1+'+"'+@rec_edtn_free_edtn_name+'"';
            end
                
                
    fetch NEXT FROM cur_edtn_free INTO @rec_edtn_free_publ , @rec_edtn_free_edtn,@rec_edtn_free_edtn_seqno,@rec_edtn_free_edtn_name,@rec_edtn_free_sup_rate,@rec_edtn_free_main_edtn
END     
close cur_edtn_free
DEALLOCATE cur_edtn_free
if @vvar_sum1 is not null or @vvar_sum1 !='' begin
    set @vvar_sum1=@vvar_sum1+') "Total"'
end

        if @vvar is null or @vvar ='' begin
            set @v_query1='select x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name from(select d.comp_code,d.unit_code,m.sup_ty_code,
            substring(m.sup_ty_name,1,25) supply_name
            from cir_dbksup d,cir_supply_type_mast m
            where d.comp_code = m.comp_code 
            and d.sup_type_code=m.sup_ty_code
            and d.comp_code = '+''''+@pcompcode+''''+' and
            d.unit_code = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and            
            d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <='+''''+cast(@vsupdate1 as varchar)+''''+' 
            and m.bill_pay=''N'' 
            and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' ='''')
            group by d.comp_code,d.unit_code,m.sup_ty_code,m.sup_ty_name) x
            group by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name
            order by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name';
        end
        else
        begin
            set @v_query1='select x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name,'+@vvar_sum+','+@vvar_sum1+' from
            (select d.comp_code,d.unit_code,m.sup_ty_code sup_ty_code,
            substring(m.sup_ty_name,1,25) supply_name
            ,'+@vvar+' from cir_dbksup d,cir_supply_type_mast m
            where d.comp_code = m.comp_code
             and d.sup_type_code=m.sup_ty_code 
            and d.comp_code = '+''''+@pcompcode+''''+' and
            d.unit_code = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and            
             d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <= '+''''+cast(@vsupdate1 as varchar)+''''+' 
             and m.bill_pay=''N'' and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' = '''')
            group by d.comp_code,d.unit_code,m.sup_ty_code,m.sup_ty_name) x
            group by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name
            order by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name';
        end

print(@v_query1)
exec(@v_query1)




 set @vvar=null
    set @vvar_sum=null
    set @vvar_sum1=null


-------------------for edition total


declare cur_edtn_total cursor for
    select distinct d.publ publ,d.edtn edtn,p.edtn_seq_no edtn_seqno,
    case @plangtype when '1' then substring(p.edition_nick,1,15)
    else substring(p.edtn_name_oth_lang,1,20) end edtn_name
    ,d.sup_rate sup_rate,p.main_edtn main_edtn
    from cir_supply_type_mast m,cir_dbksup d ,cir_edtn_mast p 
    where m.comp_code=@pcompcode and m.comp_code=d.comp_code and d.comp_code=p.comp_code and 
      d.comp_code=m.comp_code  and d.sup_type_code=m.sup_ty_code and 
      d.unit_code=p.unit_code and d.unit_code = @punitcode and
      d.supdate >= @vsupdate and d.supdate <=@vsupdate1 and
      d.publ=isnull(@ppublcode,d.publ) and
      d.publ=p.publ and d.edtn=p.edtn 
      order by publ,main_edtn,edtn_seqno,edtn,sup_rate
    
-- cursor variable for cur_edtn_free
declare @rec_edtn_total_publ as varchar(200)
declare @rec_edtn_total_edtn as varchar(200)
declare @rec_edtn_total_edtn_seqno as numeric(5)
declare @rec_edtn_total_edtn_name as varchar(500)
declare @rec_edtn_total_sup_rate as numeric(14,2)
declare @rec_edtn_total_main_edtn as varchar(200)
-- end here --

OPEN cur_edtn_total 
    fetch NEXT FROM cur_edtn_total INTO @rec_edtn_total_publ , @rec_edtn_total_edtn,@rec_edtn_total_edtn_seqno,@rec_edtn_total_edtn_name,@rec_edtn_total_sup_rate,@rec_edtn_total_main_edtn
        WHILE (@@FETCH_STATUS = 0) 
        BEGIN
            if (@vvar is null or @vvar = '') begin 
                set @vvar        ='sum(case edtn when '+''''+@rec_edtn_total_edtn+''''+' then sup_copy else 0 end) "'+@rec_edtn_total_edtn_name+'"';
                set @vvar_sum    ='sum('+'"'+@rec_edtn_total_edtn_name+'") "'+@rec_edtn_total_edtn_name+'"';
                set @vvar_sum1   ='sum('+'"'+@rec_edtn_total_edtn_name+'"';
            end
            else
            begin
                set @vvar        =@vvar+','+'sum(case edtn when '+''''+@rec_edtn_total_edtn+''''+' then sup_copy else 0 end) "'+@rec_edtn_total_edtn_name+'"';
                set @vvar_sum    =@vvar_sum+','+'sum('+'"'+@rec_edtn_total_edtn_name+'") "'+@rec_edtn_total_edtn_name+'"';
                set @vvar_sum1   =@vvar_sum1+'+"'+@rec_edtn_total_edtn_name+'"';
            end
                
                
    fetch NEXT FROM cur_edtn_total INTO @rec_edtn_total_publ , @rec_edtn_total_edtn,@rec_edtn_total_edtn_seqno,@rec_edtn_total_edtn_name,@rec_edtn_total_sup_rate,@rec_edtn_total_main_edtn
END     
close cur_edtn_total
DEALLOCATE cur_edtn_total
if @vvar_sum1 is not null or @vvar_sum1 !='' begin
    set @vvar_sum1=@vvar_sum1+') "Total"'
end

        if @vvar is null or @vvar ='' begin
            set @v_query1='select x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name from(select d.comp_code,unit_code,null as sup_ty_code, null as supply_name
            from cir_dbksup d
            where d.comp_code = '+''''+@pcompcode+''''+' and
            d.unit_code = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and            
            d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <='+''''+cast(@vsupdate1 as varchar)+''''+' 
            
            and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' ='''')
            group by d.comp_code,d.unit_code) x
            group by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name
            order by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name';
        end
        else
        begin
            set @v_query1='select x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name,'+@vvar_sum+','+@vvar_sum1+' from
            (select d.comp_code,d.unit_code   ,null as sup_ty_code, null as supply_name
            ,'+@vvar+' from cir_dbksup d,cir_supply_type_mast m
            where d.comp_code = m.comp_code
             and d.sup_type_code=m.sup_ty_code 
            and d.comp_code = '+''''+@pcompcode+''''+' and
            d.unit_code = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and            
             d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <= '+''''+cast(@vsupdate1 as varchar)+''''+' 
              and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' = '''')
            group by d.comp_code,d.unit_code) x
            group by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name
            order by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name';
        end

print(@v_query1)
exec(@v_query1)











SET CONCAT_NULL_YIELDS_NULL On







///////////////////////////////////////////////////////////////

//----------------------start---------------------------------//

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[cir_rep_edtnwise_billing_p]
(


    @pcompcode        as varchar(50),
    @punitcode        as varchar(50),
    @pbranchcode      as varchar(50),
    @ppublcode        as varchar(50),
    @pmedtncode       as varchar(50),
    @pedtncode        as varchar(50),
    @pdistcode        as varchar(50),
    @ptaluka          as varchar(50),
    @pfrom_date       as datetime,--for supply from date
    @ptill_date       as datetime,--for supply till date
    @pagencytype      as varchar(50),
    @pagencyclass     as varchar(50),
    @ptrantype        as varchar(50),--for Type Agency(A)/Distribution(D) 
    @preptype         as varchar(50),--for Datewise(D)/Edition Rate Wise(S)
    @prettype         as varchar(50),--for Return Based Received Date(R)/Supply Date(S)
    @pretsup_frdt     as varchar(50),--for return based on from supply date 
    @pretsup_todt     as varchar(50),--for return based on till supply date
    @puserid          as varchar(50),
    @pdateformat      as varchar(50),
    @pextra1          as varchar(50),
    @pextra2          as varchar(50),
    @pextra3          as varchar(50),
    @pextra4          as varchar(50),
    @pextra5          as varchar(50)
)

as


declare @v_frdt     as datetime
declare  @v_todt    as datetime
declare @v_return_copy     numeric(10);
declare @v_return_amt      numeric(10,2)
declare @vbill_no          varchar(20)
declare @v_rec_amt         numeric
declare @v_rcp_count       numeric
declare @v_prev_agcd       varchar(30) 
declare @v_cur_agcd        varchar(30)

set @v_prev_agcd='XX'; 
set @v_cur_agcd='XX';
set @v_rec_amt=0;
set @v_rcp_count=0;

set @v_frdt=@pfrom_date
set @v_todt=@ptill_date
/*
 select distinct u.comp_code comp_code,u.unit_code unit_code,u.publ agcd,u.edtn dpcd,u.publ publ,u.edtn edtn,
            u.supply_date supply_date,u.copy_rate copy_rate from
            (select d.comp_code,d.unit_code,d.publ,d.edtn,d.recptdt supply_date,d.copy_rate from cir_agmast m,cir_unsold_dtl d,cir_edtn_mast e
            where d.comp_code=m.comp_code and d.comp_code=e.comp_code and d.comp_code=pcompcode and d.unit_code=m.unit and 
            d.unit_code=e.unit_code and d.unit_code=punitcode and 
                d.publ=e.publ and d.publ=isnull(ppublcode,d.publ) and d.edtn=e.edtn and d.edtn=isnull(pedtncode,d.edtn) and                  
                ((prettype='S' and d.app_dt >= v_frdt  and d.app_dt<=v_todt) or 
                (prettype='R' and d.app_dt >= v_ret_frdt  and d.app_dt<v_ret_todt and d.supdate >= v_frdt  and d.supdate<=v_todt)) and 
                d.agcd=m.agcd  and d.dpcd=m.dpcd and (m.ag_type=pagencytype or pagencytype is null) and 
                (m.ag_class=pagencyclass or pagencyclass is null) and (m.dist_code=pdistcode or pdistcode is null) and 
                (m.tehsil_taluka=ptaluka or ptaluka is null) and (m.branch_code=pbranchcode or pbranchcode is null) and
                e.main_edtn=isnull(pmedtncode,e.main_edtn) and d.supply_copy>0 and 
                (isnull(d.apr_late_recpt,0)+isnull(d.apr_short_recpt,0)+isnull(d.apr_bnr,0)+isnull(d.apr_unsold,0))>0
             minus
            select comp_code,unit_code,publ_code publ,edtn_code edtn,supply_date,supply_rate copy_rate from cir_bill_print
            where comp_code=pcompcode and unit_code=punitcode and supply_date>= v_frdt  and supply_date<=v_todt and 
            supply_copy>0 
--and cur_sessionid=userenv('sessionid')
) u
            where (ptrantype<>'D' or ptrantype is null)
            union
            select distinct u.comp_code comp_code,u.unit_code unit_code,u.publ agcd,u.edtn dpcd,u.publ publ,u.edtn edtn,
            u.supply_date supply_date,u.copy_rate copy_rate from
            (select d.comp_code,d.unit_code,d.publ,d.edtn,d.recptdt supply_date,d.copy_rate from cir_agmast_dis m,cir_unsold_dtl_dis d,cir_edtn_mast e
            where d.comp_code=m.comp_code and d.comp_code=e.comp_code and d.comp_code=pcompcode and d.unit_code=m.unit and 
            d.unit_code=e.unit_code and d.unit_code=punitcode and 
                d.publ=e.publ and d.publ=isnull(ppublcode,d.publ) and d.edtn=e.edtn and d.edtn=isnull(pedtncode,d.edtn) and                  
                ((prettype='S' and d.app_dt >= v_frdt  and d.app_dt<=v_todt) or 
                (prettype='R' and d.app_dt >= v_ret_frdt  and d.app_dt<v_ret_todt and d.supdate >= v_frdt  and d.supdate<=v_todt)) and
                d.agcd=m.agcd  and d.dpcd=m.dpcd and (m.ag_type=pagencytype or pagencytype is null) and 
                (m.ag_class=pagencyclass or pagencyclass is null) and (m.dist_code=pdistcode or pdistcode is null) and 
                (m.tehsil_taluka=ptaluka or ptaluka is null) and (m.branch_code=pbranchcode or pbranchcode is null) and
                e.main_edtn=isnull(pmedtncode,e.main_edtn) and d.supply_copy>0 and 
                (isnull(d.apr_late_recpt,0)+isnull(d.apr_short_recpt,0)+isnull(d.apr_bnr,0)+isnull(d.apr_unsold,0))>0
             minus
            select comp_code,unit_code,publ_code publ,edtn_code edtn,supply_date,supply_rate copy_rate from cir_bill_print
            where comp_code=pcompcode and unit_code=punitcode and supply_date>= v_frdt  and supply_date<=v_todt and 
            supply_copy>0 ) u
--and cur_sessionid=userenv('sessionid')
 where ptrantype='D';
           

*/ 
print('a')
print(@ptrantype)
print(@prettype)
if (@ptrantype='D')
 begin
		if (@prettype='S')
		begin
			select 	@v_return_copy=sum(isnull(apr_late_recpt,0)+isnull(apr_short_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)),
			@v_return_amt=sum(isnull(copy_amt,0)-isnull(waste_amt,0)),
			@v_rec_amt=	sum(isnull(comm_amt,0)) 
			from cir_unsold_dtl_dis
		end
		else
		begin
			select 	@v_return_copy=sum(isnull(apr_late_recpt,0)+isnull(apr_short_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)),@v_return_amt=sum(isnull(copy_amt,0)-isnull(waste_amt,0)) ,@v_rec_amt=	sum(isnull(comm_amt,0))  
			from cir_unsold_dtl_dis
		end
end 



if (@preptype='D')
 begin--for datewise
        select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,dbo.cir_get_publ_name(u.comp_code,u.publ) publ_name, 
        u.main_edtn edtn,dbo.cir_get_edtn_name(u.comp_code,u.main_edtn) edtn_name, u.edtn sub_edtn,u.edtn_name sub_edtn_name,
        u.supply_date supply_date,u.supply_rate supply_rate,
        sum(u.supply_copy) supply_copy,sum(u.return_copy) return_copy,sum(u.net_copy) net_copy,
        sum(isnull(u.net_gamt,0)) net_gamt,sum(isnull(u.comm_amt,0)) comm_amt,sum(isnull(u.net_gamt,0))-sum(isnull(u.comm_amt,0)) net_amount
        from(select d.comp_code comp_code,d.unit_code unit_code,d.publ_code publ,e.main_edtn main_edtn,d.edtn_code edtn,e.edtn_name edtn_name,d.supply_date supply_date,d.supply_rate supply_rate,
        sum(isnull(d.supply_copy,0)) supply_copy,sum(isnull(d.return_copy,0)) return_copy,sum(isnull(d.supply_copy,0)-isnull(d.return_copy,0)) net_copy,
        sum(isnull(d.gross_amt,0))-sum(isnull(d.return_amt,0)+isnull(rec_amt,0)) net_gamt,sum(isnull(d.comm_amt,0)-isnull(d.rec_amt,0)) comm_amt  
        from cir_bill_print d,cir_edtn_mast e 
        where d.comp_code=@pcompcode and d.comp_code=e.comp_code and d.unit_code=e.unit_code and  d.unit_code=@punitcode and 
        d.supply_date >=@v_frdt and d.supply_date<=@v_todt and d.publ_code=e.publ and d.edtn_code=e.edtn and  
        (isnull(d.supply_copy,0)+isnull(return_copy,0))>0 
        group by d.comp_code,d.unit_code,d.publ_code,e.main_edtn,d.edtn_code,e.edtn_name,d.supply_date,d.supply_rate)u
        group by u.comp_code,u.unit_code,u.publ,u.main_edtn,u.edtn,u.edtn_name,u.supply_date,u.supply_rate
        order by comp_code,unit_code,publ_name,edtn_name,sub_edtn_name,supply_date,supply_rate;
end
else--for edition rate wise
begin 
	select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,dbo.cir_get_publ_name(u.comp_code,u.publ) publ_name, 
	u.main_edtn edtn,dbo.cir_get_edtn_name(u.comp_code,u.main_edtn) edtn_name, u.edtn sub_edtn,u.edtn_name sub_edtn_name,
	u.supply_rate supply_rate,
	sum(u.supply_copy) supply_copy,sum(u.return_copy) return_copy,sum(u.net_copy) net_copy,
	sum(isnull(u.net_gamt,0)) net_gamt,sum(isnull(u.comm_amt,0)) comm_amt,sum(isnull(u.net_gamt,0))-sum(isnull(u.comm_amt,0)) net_amount
	from(select d.comp_code comp_code,d.unit_code unit_code,d.publ_code publ,e.main_edtn main_edtn,d.edtn_code edtn,e.edtn_name edtn_name,d.supply_date supply_date,d.supply_rate supply_rate,
	sum(isnull(d.supply_copy,0)) supply_copy,sum(isnull(d.return_copy,0)) return_copy,sum(isnull(d.supply_copy,0)-isnull(d.return_copy,0)) net_copy,
	sum(isnull(d.gross_amt,0))-sum(isnull(d.return_amt,0)+isnull(rec_amt,0)) net_gamt,sum(isnull(d.comm_amt,0)-isnull(d.rec_amt,0)) comm_amt  
	from cir_bill_print d,cir_edtn_mast e 
	where d.comp_code=@pcompcode and d.comp_code=e.comp_code and d.unit_code=e.unit_code and  d.unit_code=@punitcode and 
	d.supply_date >= @v_frdt and d.supply_date<=@v_todt and 
	d.publ_code=e.publ and d.edtn_code=e.edtn and (isnull(d.supply_copy,0)+isnull(return_copy,0))>0 
	group by d.comp_code,d.unit_code,d.publ_code,e.main_edtn,d.edtn_code,e.edtn_name,d.supply_date,d.supply_rate)u
	group by u.comp_code,u.unit_code,u.publ,u.main_edtn,u.edtn,u.edtn_name,u.supply_rate
	order by comp_code,unit_code,publ_name,edtn_name,sub_edtn_name,supply_rate;     
end   


//--------------------------end------------------------------------

/////////////////////////////////////////start add By Garima Agency  Listing
                                                                     
                                                                     
                                                                     
                                             
alter PROCEDURE [dbo].[cir_rep_supply_temp]
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
@pextra2            as varchar(200),
@pextra3            as varchar(200),----this is use to final and unfinal po
@pextra4            as varchar(200),---for  zone,
@pextra5            as varchar(200),---for region
@pextra6            as varchar(200),---for district
@pextra7            as varchar(200),---fortaluka
@pextra8            as varchar(200),-----report type filter
@pextra9            as varchar(200),
@pextra10           as varchar(200)

AS

declare @vfrom_supdate    datetime;
declare @vtill_supdate    datetime;

declare @rec_sup_type as varchar(200) 
DECLARE cur_sup_type CURSOR READ_ONLY FOR
	select 'sum(COALESCE(sup_type_code,'+'''+sup_ty_code+'''+',sup_copy,0)) '+sup_ty_name+',@rec_sup_type=' vty
	from cir_supply_type_mast where comp_code=@pcomp_code

     declare @vvar varchar(4000)
     declare @vvar_sum varchar(4000)
     declare @vquery varchar(4000)
     declare @vquery1 varchar(4000)
     declare @vquery2 varchar(4000)
     declare @vquery3 varchar(4000)
     declare @vquery4 varchar(4000)
 
 Begin
    open cur_sup_type   
    	fetch cur_sup_type into @rec_sup_type    
      		set @vvar=@vvar+@rec_sup_type    
    close cur_sup_type
	DEALLOCATE cur_sup_type
end 

set @vfrom_supdate=@pfrom_supdate
set @vtill_supdate=@ptill_supdate

set @vvar    =substring(@vvar,1,len(@vvar)-1)
set @vvar_sum=substring(@vvar_sum,1,len(@vvar_sum)-1)
   
if @pextra8='1' begin----for route 
	set @vquery=' select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,cir_get_publ_name(d.comp_code,d.publ) publ_name,
				d.route_code route_code,cir_get_route_name(d.comp_code,d.unit_code,d.route_code) route_name, '+@vvar+','+@vvar_sum+' TOTAL 
				from cir_dbksup d,cir_agmast m where m.comp_code=d.comp_code and d.comp_code='+ 
                ''''+@pcomp_code+''''+' and m.unit=d.unit_code and d.unit_code='+''''+@punit_code+''''+
				' and (d.publ='+''''+@ppubl+''''+' or '+''''+@ppubl+''''+' is null) 
				and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' is null) and
				and (d.edtn='+''''+@pedtn+''''+' or '+''''+@pedtn+''''+' is null) 
				and m.agcd=d.agcd and m.dpcd=d.dpcd 
				and d.supdate between '''+cast(@pfrom_supdate as varchar)+''' and '''+cast(@ptill_supdate as varchar)+''' 
				and ((route_code='+''''+@proute+''''+') or ('+''''+@proute+''''+' is null)) and
				 ((branch_code='+''''+@pextra1+''''+') or ('+''''+@pextra1+''''+' is null)) and
               d.edtn in(select distinct edtn from cir_edtn_mast 
			   where comp_code=d.comp_code and edtn = d.edtn 
			   and (main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' is null))
                group by d.comp_code,d.unit_code,d.publ,d.route_code
				order by d.comp_code,d.unit_code,d.publ,d.route_code';
end ------ route	
else if @pextra8='2' begin----for  branch
	set @vquery=' select d.comp_code comp_code,d.unit_code unit_code,d.branch_code branch_code,AD_GET_BRANCHNAME (d.comp_code,m.branch_code) branch_name
, '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_dbksup d,cir_agmast m where m.comp_code=d.comp_code and d.comp_code='+ 
                ''''+@pcomp_code+''''+' and m.unit=d.unit_code and d.unit_code='+''''+@punit_code+''''+
				' and (d.publ='+''''+@ppubl+''''+' or '+''''+@ppubl+''''+' is null) 
				and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' is null) and
				and (d.edtn='+''''+@pedtn+''''+' or '+''''+@pedtn+''''+' is null) 
				and m.agcd=d.agcd and m.dpcd=d.dpcd 
				and d.supdate between '''+cast(@pfrom_supdate as varchar)+''' and '''+cast(@ptill_supdate as varchar)+''' 
				and ((route_code='+''''+@proute+''''+') or ('+''''+@proute+''''+' is null)) and
				 ((branch_code='+''''+@pextra1+''''+') or ('+''''+@pextra1+''''+' is null)) and
               d.edtn in(select distinct edtn from cir_edtn_mast 
			   where comp_code=d.comp_code and edtn = d.edtn 
			   and (main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' is null))
                group by d.comp_code,d.unit_code,m.branch_code
				order by d.comp_code,d.unit_code,m.branch_code';

end ---- branch		
else if @pextra8='3' begin----for  zone   
	set @vquery=' d.comp_code comp_code,d.unit_code unit_code,cir_get_zone_name(d.comp_code,k.zone_code) zone_name
, '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_dbksup d,cir_agmast m,cir_city_mast k where m.comp_code=d.comp_code and d.comp_code='+ 
                ''''+@pcomp_code+''''+' and m.unit=d.unit_code and d.unit_code='+''''+@punit_code+''''+
				' and (d.publ='+''''+@ppubl+''''+' or '+''''+@ppubl+''''+' is null) 
				and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' is null) and
				and (d.edtn='+''''+@pedtn+''''+' or '+''''+@pedtn+''''+' is null) 
				and m.agcd=d.agcd and m.dpcd=d.dpcd and  m.comp_code=k.comp_code and m.city_code=k.city_code 
				and d.supdate between '''+cast(@pfrom_supdate as varchar)+''' and '''+cast(@ptill_supdate as varchar)+'''  
				and ((d.route_code='+''''+@proute+''''+') or ('+''''+@proute+''''+' is null)) and
				 ((d.branch_code='+''''+@pextra1+''''+') or ('+''''+@pextra1+''''+' is null)) and
				  ((k.zone_code='+''''+@pextra4+''''+') or ('+''''+@pextra4+''''+' is null)) and
               d.edtn in(select distinct edtn from cir_edtn_mast 
			   where comp_code=d.comp_code and edtn = d.edtn 
			   and (main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' is null))
                group by d.comp_code,d.unit_code,k.zone_code
				order by d.comp_code,d.unit_code,k.zone_code';
     
end  ---- zone
else if @pextra8='4' begin----for  region   
	set @vquery=' d.comp_code comp_code,d.unit_code unit_code,cir_get_region_name(d.comp_code,k.region_code) region_name
, '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_dbksup d,cir_agmast m,cir_city_mast k where m.comp_code=d.comp_code and d.comp_code='+ 
                ''''+@pcomp_code+''''+' and m.unit=d.unit_code and d.unit_code='+''''+@punit_code+''''+
				' and (d.publ='+''''+@ppubl+''''+' or '+''''+@ppubl+''''+' is null) 
				and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' is null) and
				and (d.edtn='+''''+@pedtn+''''+' or '+''''+@pedtn+''''+' is null) 
				and m.agcd=d.agcd and m.dpcd=d.dpcd and  m.comp_code=k.comp_code and m.city_code=k.city_code 
				and d.supdate between '''+cast(@pfrom_supdate as varchar)+''' and '''+cast(@ptill_supdate as varchar)+''' 
				and ((route_code='+''''+@proute+''''+') or ('+''''+@proute+''''+' is null)) and
				 ((d.branch_code='+''''+@pextra1+''''+') or ('+''''+@pextra1+''''+' is null)) and
				  ((k.region_code='+''''+@pextra5+''''+') or ('+''''+@pextra5+''''+' is null)) and
               d.edtn in(select distinct edtn from cir_edtn_mast 
			   where comp_code=d.comp_code and edtn = d.edtn 
			   and (main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' is null))
                group by d.comp_code,d.unit_code,k.region_code
				order by d.comp_code,d.unit_code,k.region_code';
end ---- end  region
else if @pextra8='5' begin----for  district
	set @vquery=' d.comp_code comp_code,d.unit_code unit_code,m.dist_code dist_code,cir_get_dist(d.comp_code,m.state_code,m.dist_code) district_name
, '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_dbksup d,cir_agmast m where m.comp_code=d.comp_code and d.comp_code='+ 
                ''''+@pcomp_code+''''+' and m.unit=d.unit_code and d.unit_code='+''''+@punit_code+''''+
				' and (d.publ='+''''+@ppubl+''''+' or '+''''+@ppubl+''''+' is null) 
				and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' is null) and
				and (d.edtn='+''''+@pedtn+''''+' or '+''''+@pedtn+''''+' is null) 
				and m.agcd=d.agcd and m.dpcd=d.dpcd 
				and d.supdate between '''+cast(@pfrom_supdate as varchar)+''' and '''+cast(@ptill_supdate as varchar)+''' 
				and ((route_code='+''''+@proute+''''+') or ('+''''+@proute+''''+' is null)) and
				((d.branch_code='+''''+@pextra1+''''+') or ('+''''+@pextra1+''''+' is null)) and
				((m.dist_code='+''''+@pextra6+''''+') or ('+''''+@pextra6+''''+' is null)) and
               d.edtn in(select distinct edtn from cir_edtn_mast 
			   where comp_code=d.comp_code and edtn = d.edtn 
			   and (main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' is null))
                group by d.comp_code,d.unit_code,m.state_code,m.dist_code
				order by d.comp_code,d.unit_code,m.state_code,m.dist_code'     		 
end  ---- district
else ----for  tehsil_taluka
begin
set @vquery=' d.comp_code comp_code,d.unit_code unit_code,m.tehsil_taluka tehsil_taluka,cir_get_taluka(d.comp_code,m.tehsil_taluka) taluka_name
, '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_dbksup d,cir_agmast m where m.comp_code=d.comp_code and d.comp_code='+ 
                ''''+@pcomp_code+''''+' and m.unit=d.unit_code and d.unit_code='+''''+@punit_code+''''+
				' and (d.publ='+''''+@ppubl+''''+' or '+''''+@ppubl+''''+' is null) 
				and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' is null) and
				and (d.edtn='+''''+@pedtn+''''+' or '+''''+@pedtn+''''+' is null) 
				and m.agcd=d.agcd and m.dpcd=d.dpcd 
				and d.supdate between '''+cast(@pfrom_supdate as varchar)+''' and '''+cast(@ptill_supdate as varchar)+''' 
				and ((route_code='+''''+@proute+''''+') or ('+''''+@proute+''''+' is null)) and
				((d.branch_code='+''''+@pextra1+''''+') or ('+''''+@pextra1+''''+' is null)) and
				((m.tehsil_taluka='+''''+@pextra7+''''+') or ('+''''+@pextra7+''''+' is null)) and
               d.edtn in(select distinct edtn from cir_edtn_mast 
			   where comp_code=d.comp_code and edtn = d.edtn 
			   and (main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' is null))
                group by d.comp_code,d.unit_code,m.tehsil_taluka
				order by d.comp_code,d.unit_code,m.tehsil_taluka';
end  ----for  tehsil_taluka

print(@vquery)
exec(@vquery)
//////////////////////////////////////////end by Garima

////////////////////////////////////for Agency listing (for Branch)
                                                                     
                                                                     
                                                                     
                                             
create PROCEDURE [dbo].[cir_branchlisting_commcat]
@pcomp_code       as varchar(200),
@punit            as varchar(200),
@pbranch_code     as varchar(200),
@pagcd            as varchar(200),
@pdpcd            as varchar(200),
@pag_type         as varchar(200),
@pag_class        as varchar(200),
@pcomm_code       as varchar(200),
@pextra1          as varchar(200),
@pextra2          as varchar(200)

AS 
	
select x.branch_code,x.branch_name,x.comm_catg_desc,max(x.comm_catg_desc),sum(x.upline)main ,sum(x.sub) sub,sum(isnull(x.upline,0))+sum(isnull(x.sub,0)) total from(
 select  b.branch_code, bdo.cir_get_branch(a.comp_code,b.branch_code) branch_name ,c.comm_catg_desc,count(*) "UPLINE",null "SUB"  from cir_supply a,cir_agmast b,cir_comm_catg_mast c
		where a.comp_code=@pcomp_code 
		and a.comp_code=b.comp_code 
		and a.comp_code=c.comp_code 
		and (a.unit=@punit or @punit is null or @punit ='') 
		and a.unit=b.unit 
		and (b.branch_code=@pbranch_code or @pbranch_code is null or @pbranch_code ='') 
		and a.agcd=b.agcd and a.dpcd=b.dpcd and a.dpcd='0001'
		and (a.agcd=@pagcd or @pagcd is null or @pagcd ='') 
		and (a.dpcd=@pdpcd or @pdpcd is null or @pdpcd ='') 
		and (b.ag_type=@pag_type or @pag_type is null or @pag_type ='')
		and (b.ag_class=@pag_class or @pag_class is null or @pag_class ='') 
		and (a.comm_code=@pcomm_code or @pcomm_code is null or @pcomm_code ='') 
		and a.comm_code=c.comm_catg_code
		group by a.comp_code,b.branch_code,c.comm_catg_desc
union
select  b.branch_code, dbo.cir_get_branch(a.comp_code,b.branch_code) branch_name ,c.comm_catg_desc,count(*) "UPLINE",null "SUB"  from cir_supply a,cir_agmast b,cir_comm_catg_mast c
		where a.comp_code=@pcomp_code 
		and a.comp_code=b.comp_code 
		and a.comp_code=c.comp_code 
		and (a.unit=@punit or @punit is null or @punit ='') 
		and a.unit=b.unit 
		and (b.branch_code=@pbranch_code or @pbranch_code is null or @pbranch_code ='') 
		and a.agcd=b.agcd and a.dpcd=b.dpcd and a.dpcd!='0001'
		and (a.agcd=@pagcd or @pagcd is null or @pagcd ='') 
		and (a.dpcd=@pdpcd or @pdpcd is null or @pdpcd ='') 
		and (b.ag_type=@pag_type or @pag_type is null or @pag_type ='')
		and (b.ag_class=@pag_class or @pag_class is null or @pag_class ='') 
		and (a.comm_code=@pcomm_code or @pcomm_code is null or @pcomm_code ='') 
		and a.comm_code=c.comm_catg_code
		group by a.comp_code,b.branch_code,c.comm_catg_desc) x 
		group by x.branch_code,x.branch_name,x.comm_catg_desc 
		order by x.branch_code,x.branch_name,x.comm_catg_desc





`

/`//////////////////////////////////////////////////////////////


                                                                     
                                                                     
                                                                     
                                             
create PROCEDURE [dbo].[cir_aglisting_commcat]
@pcomp_code       as varchar(200),
@punit            as varchar(200),
@pbranch_code     as varchar(200),
@pagcd            as varchar(200),
@pdpcd            as varchar(200),
@pag_type         as varchar(200),
@pag_class        as varchar(200),
@pcomm_code       as varchar(200),
@pextra1          as varchar(200),
@pextra2          as varchar(200)

AS 
	
select x.comm_catg_desc,max(x.comm_catg_desc),sum(x.upline)main ,sum(x.sub) sub,sum(isnull(x.upline,0))+sum(isnull(x.sub,0)) total from(
select  c.comm_catg_desc,count(*) "UPLINE",null "SUB"  from cir_supply a,cir_agmast b,cir_comm_catg_mast c
  where a.comp_code=@pcomp_code
  and a.comp_code=b.comp_code
  and a.comp_code=c.comp_code
  and (a.unit=@punit or @punit is null or @punit ='')
  and a.unit=b.unit
  and (b.branch_code=@pbranch_code or @pbranch_code is null  or @pbranch_code ='')
  and a.agcd=b.agcd and a.dpcd=b.dpcd and a.dpcd='0001'
  and (a.agcd=@pagcd or @pagcd is null or @pagcd ='')
  and (a.dpcd=@pdpcd or @pdpcd is null or @pdpcd='')
  and (b.ag_type=@pag_type or @pag_type is null or @pag_type ='')
  and (b.ag_class=@pag_class or @pag_class is null or @pag_class ='')
  and (a.comm_code=@pcomm_code or @pcomm_code is null or @pcomm_code ='')
  and a.comm_code=c.comm_catg_code
  group by c.comm_catg_desc
union all
select c.comm_catg_desc,null "UPLINE",count(*) "SUB"   from cir_supply a,cir_agmast b,cir_comm_catg_mast c
  where a.comp_code=@pcomp_code
  and a.comp_code=b.comp_code
  and a.comp_code=c.comp_code
  and (a.unit=@punit or @punit is null or @punit ='')
  and a.unit=b.unit
  and (b.branch_code=@pbranch_code or @pbranch_code is null or @pbranch_code ='')
  and a.agcd=b.agcd and a.dpcd=b.dpcd and a.dpcd!='0001'
  and (a.agcd=@pagcd or @pagcd is null or @pagcd ='')
  and (a.dpcd=@pdpcd or @pdpcd is null or @pdpcd ='')
  and (b.ag_type=@pag_type or @pag_type is null or @pag_type ='')
  and (b.ag_class=@pag_class or @pag_class is null or @pag_class ='')
  and (a.comm_code=@pcomm_code or @pcomm_code is null or @pcomm_code ='')
  and a.comm_code=c.comm_catg_code
  group by c.comm_catg_desc) x
  group by x.comm_catg_desc order by X.comm_catg_desc;





/////////////////////////////////////////////////////////////////////////
end of Agency listing By Garima




//////////////////////////////start anurag   supply type wise summary////////////26 mar /////////////////



USE [abhi]
GO
/****** Object:  StoredProcedure [dbo].[cir_rep_supply_temp]    Script Date: 03/26/2012 11:57:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



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
@pextra2            as varchar(200),
@pextra3            as varchar(200),----this is use to final and unfinal po
@pextra4            as varchar(200),---for  zone,
@pextra5            as varchar(200),---for region
@pextra6            as varchar(200),---for district
@pextra7            as varchar(200),---fortaluka
@pextra8            as varchar(200),-----report type filter
@pextra9            as varchar(200),
@pextra10           as varchar(200)

AS

declare @vfrom_supdate    datetime;
declare @vtill_supdate    datetime;


IF(@ppubl=NULL)
SET @ppubl=''

declare @rec_sup_type as varchar(200) 
declare @rec_sup_type_sum as varchar(200) 
DECLARE cur_sup_type CURSOR READ_ONLY FOR
	select /*'sum(COALESCE(sup_type_code,'+'''+sup_ty_code+'''+',sup_copy,0)) '+sup_ty_name+',@rec_sup_type=' vty,*/
	 
	 ' sum(case sup_type_code when '+''''+sup_ty_code+''''+' then sup_copy else 0 end ) "'+sup_ty_name+'",' vty,
	
	'sum(case sup_type_code when '+''''+sup_ty_code+''''+' then sup_copy else 0 end ) +' vty_sum
	from cir_supply_type_mast where comp_code=@pcomp_code

     declare @vvar varchar(4000)
     declare @vvar_sum varchar(4000)
     declare @vquery varchar(4000)
     declare @vquery1 varchar(4000)
     declare @vquery2 varchar(4000)
     declare @vquery3 varchar(4000)
     declare @vquery4 varchar(4000)
     
     set @vvar=''
     set @vvar_sum=''
 
 
    open cur_sup_type  
   
    	fetch next from cur_sup_type into @rec_sup_type ,@rec_sup_type_sum  



WHILE @@FETCH_STATUS = 0

   Begin 	
      		set @vvar=@vvar+@rec_sup_type          		
      		set  @vvar_sum=@vvar_sum+@rec_sup_type_sum
      		
      	fetch next from cur_sup_type into @rec_sup_type ,@rec_sup_type_sum   

end

    close cur_sup_type
	DEALLOCATE cur_sup_type


print('sum')
print(@vvar_sum)


set @vfrom_supdate=@pfrom_supdate
set @vtill_supdate=@ptill_supdate

set @vvar    =substring(@vvar,1,len(@vvar)-1)
set @vvar_sum=substring(@vvar_sum,1,len(@vvar_sum)-1)
   
if @pextra8='1' begin----for route 
	set @vquery='select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,dbo.cir_get_publ_name(d.comp_code,d.publ) publ_name,
d.route_code route_code,dbo.cir_get_route_name(d.comp_code,d.unit_code,d.route_code) route_name
,
 '+@vvar+' ,'+@vvar_sum+' TOTAL 
from cir_dbksup d,cir_agmast m where m.comp_code=d.comp_code
and d.comp_code='+ ''''+@pcomp_code+''''+'
and m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
and (d.publ='''+@ppubl+'''  or '''+@ppubl+''' ='''')
and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''  ='''') 
And (d.edtn='''+@pedtn+''' or '''+@pedtn+''' ='''') 
and m.agcd=d.agcd and m.dpcd=d.dpcd 
and (route_code='''+@proute+''' or '''+@proute+''' = '''') and
(m.branch_code='''+@pextra1+''' or '''+@pextra1+''' ='''') and

d.edtn in(select distinct edtn from cir_edtn_mast 
where comp_code=d.comp_code and edtn = d.edtn 
and (main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' =''''))

 group by d.comp_code,d.unit_code,d.publ,d.route_code
				order by d.comp_code,d.unit_code,d.publ,d.route_code';

;
end ------ route	
else if @pextra8='2' begin----for  branch
	set @vquery='select d.comp_code comp_code,d.unit_code unit_code,m.branch_code branch_code,m.branch_code branch_code,
dbo.AD_GET_BRANCHNAME (d.comp_code,m.branch_code) branch_name
, 
 '+@vvar+' ,'+@vvar_sum+' TOTAL 
from cir_dbksup d,cir_agmast m where m.comp_code=d.comp_code
and d.comp_code='+ ''''+@pcomp_code+''''+'
and m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
and (d.publ='''+@ppubl+'''  or '''+@ppubl+''' ='''')
and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''  ='''') 
And (d.edtn='''+@pedtn+''' or '''+@pedtn+''' ='''') 
and m.agcd=d.agcd and m.dpcd=d.dpcd 
and (route_code='''+@proute+''' or '''+@proute+''' = '''') and
(m.branch_code='''+@pextra1+''' or '''+@pextra1+''' ='''') and

d.edtn in(select distinct edtn from cir_edtn_mast 
where comp_code=d.comp_code and edtn = d.edtn 
and (main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' =''''))

 group by d.comp_code,d.unit_code,m.branch_code
				order by d.comp_code,d.unit_code,m.branch_code';

end ---- branch		
else if @pextra8='3' begin----for  zone  
 
	set @vquery=' select d.comp_code comp_code,d.unit_code unit_code,

k.zone_code,k.zone_code,
dbo.cir_get_zone_name(d.comp_code,k.zone_code) zone_name
, 
 '+@vvar+' ,'+@vvar_sum+' TOTAL 
from cir_dbksup d,cir_agmast m,cir_city_mast k where m.comp_code=d.comp_code
and d.comp_code='+ ''''+@pcomp_code+''''+'
and m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
and (d.publ='''+@ppubl+'''  or '''+@ppubl+''' ='''')
and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''  ='''') 
And (d.edtn='''+@pedtn+''' or '''+@pedtn+''' ='''') 
and m.agcd=d.agcd and m.dpcd=d.dpcd 
and (route_code='''+@proute+''' or '''+@proute+''' = '''') and
(m.branch_code='''+@pextra1+''' or '''+@pextra1+''' ='''') and
 (k.zone_code='''+@pextra4+''' or '''+@pextra4+''' ='''') and


d.edtn in(select distinct edtn from cir_edtn_mast 
where comp_code=d.comp_code and edtn = d.edtn 
and (main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' =''''))

 group by d.comp_code,d.unit_code,k.zone_code
order by d.comp_code,d.unit_code,k.zone_code';



     
end  ---- zone
else if @pextra8='4' begin----for  region   
	set @vquery='  select d.comp_code comp_code,d.unit_code unit_code,k.region_code,k.region_code
,dbo.cir_get_region_name(d.comp_code,k.region_code) 
region_name
,
 '+@vvar+' ,'+@vvar_sum+' TOTAL 
from cir_dbksup d,cir_agmast m,cir_city_mast k where m.comp_code=d.comp_code
and d.comp_code='+ ''''+@pcomp_code+''''+'
and m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
and (d.publ='''+@ppubl+'''  or '''+@ppubl+''' ='''')
and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''  ='''') 
And (d.edtn='''+@pedtn+''' or '''+@pedtn+''' ='''') 
and m.agcd=d.agcd and m.dpcd=d.dpcd 
and (route_code='''+@proute+''' or '''+@proute+''' = '''') and
(m.branch_code='''+@pextra1+''' or '''+@pextra1+''' ='''') and
 (k.region_code='''+@pextra5+''' or '''+@pextra5+''' ='''') and


d.edtn in(select distinct edtn from cir_edtn_mast 
where comp_code=d.comp_code and edtn = d.edtn 
and (main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' =''''))

group by d.comp_code,d.unit_code,k.region_code
				order by d.comp_code,d.unit_code,k.region_code';
end ---- end  region
else if @pextra8='5' begin----for  district





set @vquery='select d.comp_code comp_code,d.unit_code unit_code,m.dist_code dist_code,m.dist_code dist_code,dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) district_name, '+@vvar+' ,'+@vvar_sum+' TOTAL 
from cir_dbksup d,cir_agmast m where m.comp_code=d.comp_code
and d.comp_code='+ ''''+@pcomp_code+''''+'
and m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
and (d.publ='''+@ppubl+'''  or '''+@ppubl+''' ='''')
and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''  ='''') 
And (d.edtn='''+@pedtn+''' or '''+@pedtn+''' ='''') 
and m.agcd=d.agcd and m.dpcd=d.dpcd 
and (route_code='''+@proute+''' or '''+@proute+''' = '''') and
(m.branch_code='''+@pextra1+''' or '''+@pextra1+''' ='''') and
(m.dist_code='''+@pextra6+''' or '''+@pextra6+''' ='''') and
d.edtn in(select distinct edtn from cir_edtn_mast 
where comp_code=d.comp_code and edtn = d.edtn 
and (main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' =''''))

group by d.comp_code,d.unit_code,m.state_code,m.dist_code
order by d.comp_code,d.unit_code,m.state_code,m.dist_code	'



	/*
	set @vquery=' d.comp_code comp_code,d.unit_code unit_code,m.dist_code dist_code,cir_get_dist(d.comp_code,m.state_code,m.dist_code) district_name
, '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_dbksup d,cir_agmast m where m.comp_code=d.comp_code and d.comp_code='+ 
                ''''+@pcomp_code+''''+' and m.unit=d.unit_code and d.unit_code='+''''+@punit_code+''''+
				' and (d.publ='+''''+@ppubl+''''+' or '+''''+@ppubl+''''+' is null) 
				and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' is null) and
				and (d.edtn='+''''+@pedtn+''''+' or '+''''+@pedtn+''''+' is null) 
				and m.agcd=d.agcd and m.dpcd=d.dpcd 
				and d.supdate between '''+cast(@pfrom_supdate as varchar)+''' and '''+cast(@ptill_supdate as varchar)+''' 
				and ((route_code='+''''+@proute+''''+') or ('+''''+@proute+''''+' is null)) and
				((d.branch_code='+''''+@pextra1+''''+') or ('+''''+@pextra1+''''+' is null)) and
				((m.dist_code='+''''+@pextra6+''''+') or ('+''''+@pextra6+''''+' is null)) and
               d.edtn in(select distinct edtn from cir_edtn_mast 
			   where comp_code=d.comp_code and edtn = d.edtn 
			   and (main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' is null))
                group by d.comp_code,d.unit_code,m.state_code,m.dist_code
				order by d.comp_code,d.unit_code,m.state_code,m.dist_code'     		 
				
				
	*/			
			

end  ---- district
else if @pextra8='6'----for  tehsil_taluka
begin
set @vquery='  select d.comp_code comp_code,d.unit_code unit_code,m.tehsil_taluka tehsil_taluka,m.tehsil_taluka tehsil_taluka,
dbo.cir_get_taluka(d.comp_code,m.tehsil_taluka) taluka_name
,
 '+@vvar+' ,'+@vvar_sum+' TOTAL 
from cir_dbksup d,cir_agmast m where m.comp_code=d.comp_code
and d.comp_code='+ ''''+@pcomp_code+''''+'
and m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
and (d.publ='''+@ppubl+'''  or '''+@ppubl+''' ='''')
and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''  ='''') 
And (d.edtn='''+@pedtn+''' or '''+@pedtn+''' ='''') 
and m.agcd=d.agcd and m.dpcd=d.dpcd 
and (route_code='''+@proute+''' or '''+@proute+''' = '''') and
(m.branch_code='''+@pextra1+''' or '''+@pextra1+''' ='''') and
(m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+''' ='''') and
d.edtn in(select distinct edtn from cir_edtn_mast 
where comp_code=d.comp_code and edtn = d.edtn 
and (main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' =''''))

 group by d.comp_code,d.unit_code,m.tehsil_taluka
				order by d.comp_code,d.unit_code,m.tehsil_taluka';
end  ----for  tehsil_taluka



else
begin
set @vquery='
 select d.comp_code comp_code,d.unit_code unit_code,m.country_code country_code,
m.state_code state_code,dbo.cir_get_state(d.comp_code,m.country_code,m.state_code) state_name

 ,'+@vvar+' ,'+@vvar_sum+' TOTAL 
from cir_dbksup d,cir_agmast m where m.comp_code=d.comp_code
and d.comp_code='+ ''''+@pcomp_code+''''+'
and m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
and (d.publ='''+@ppubl+'''  or '''+@ppubl+''' ='''')
and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''  ='''') 
And (d.edtn='''+@pedtn+''' or '''+@pedtn+''' ='''') 
and m.agcd=d.agcd and m.dpcd=d.dpcd 
and (route_code='''+@proute+''' or '''+@proute+''' = '''') and
(m.branch_code='''+@pextra1+''' or '''+@pextra1+''' ='''') and
(m.state_code='''+@pextra9+''' or '''+@pextra9+''' ='''') and
d.edtn in(select distinct edtn from cir_edtn_mast 
where comp_code=d.comp_code and edtn = d.edtn 
and (main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' =''''))

group by d.comp_code,d.unit_code,m.country_code,m.state_code
order by d.comp_code,d.unit_code,m.country_code,m.state_code';
end


print(@vquery)
exec(@vquery)
///////////////////////////////////end anurag/////////////////////////////////////////////
///////////////////////////////////update By Garima///////////start

                                                                     
                                                                     
                                                                     
                                             
create pROCEDURE [dbo].[cir_rep_unsold_supply_cir_rep_unsold_confirmation]
	@pcomp_code         as varchar(200),
	@punit_code         as varchar(200),
	@ppubl              as varchar(200),
	@pmainedtn          as varchar(200),
	@pedtn              as varchar(200),
	@proute             as varchar(200),
	@pfrom_supdate      as datetime,
	@ptill_supdate      as datetime,
	@pdateformat        as varchar(200),
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
	declare @vfrom_supdate    datetime
	declare @vtill_supdate    datetime
	declare @vvar             varchar(4000)
	declare @vvar_sum         varchar(4000)
	declare @vquery           varchar(4000)
	declare @vquery1          varchar(4000)
	declare @vquery2          varchar(4000)
	declare @vquery3          varchar(4000)
	declare @vquery4          varchar(4000)

	if @ppubl ='' begin
		set @ppubl=null
	end
	if @pmainedtn =''  begin
		set @pmainedtn=null
	end
	if @pedtn  =''     begin
		set @pedtn=null
	end
	if @proute =''    begin
		set @proute =null
	end
	if @pfrom_supdate =''  begin
		set @pfrom_supdate=null
	end
	if @ptill_supdate =''  begin
		set @ptill_supdate=null
	end
	if @pdateformat   =''  begin
		set @pdateformat=null
	end
	if @pextra1     =''  begin
		set @pextra1=null
	end
	if @pextra2     =''  begin
		set @pextra2=null
	end
	if @pextra3     =''  begin
		set @pextra3=null
	end
	if @pextra4     =''  begin
		set @pextra4=null
	end
	if @pextra5     =''  begin
		set @pextra5=null
	end
	if @pextra6     =''  begin
		set @pextra6=null
	end
	if @pextra7     =''  begin
		set @pextra7=null
	end
	if @pextra8     =''  begin
		set @pextra8=null
	end
	if @pextra9     =''  begin
		set @pextra9=null
	end
	if @pextra10    ='' begin 
		set @pextra10=null
	end
	
	set @vfrom_supdate=@pfrom_supdate
	set @vtill_supdate=@ptill_supdate
	
	declare @rec_sup_type_vty as varchar(4000)
	declare @rec_sup_type_vty_sum as varchar(4000)
	
	DECLARE cur_sup_type cursor LOCAL FOR 
		select 'sum(
		case publ when '+''''+publ+''''+',sum(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+ isnull(apr_bnr,0)+ isnull(apr_unsold,0)+isnull(apr_damage,0)) unsold_copy)) else 0 end "'+publ_name+'",' vty,
		'sum(
		case publ,'+''''+publ+''''+',sum(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+ isnull(apr_bnr,0)+ isnull(apr_unsold,0)+isnull(apr_damage,0)) unsold_copy)) else 0 end +' vty_sum
		from cir_publ_mast
		where comp_code=@pcomp_code and period='1' order by publ


		OPEN cur_sup_type 
			fetch NEXT FROM cur_sup_type INTO @rec_sup_type_vty, @rec_sup_type_vty_sum
			WHILE (@@FETCH_STATUS = 0) 
			BEGIN 
				set @vvar       =@vvar+@rec_sup_type_vty;
				set @vvar_sum   =@vvar_sum+@rec_sup_type_vty_sum;
   
		    fetch NEXT FROM cur_sup_type INTO @rec_sup_type_vty, @rec_sup_type_vty_sum
			END
		close cur_sup_type

		set @vvar    =substring(@vvar,1,len(@vvar)-1);
		set @vvar_sum=substring(@vvar_sum,1,len(@vvar_sum)-1);
	
		
		set @vquery='select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,dbo.cir_get_publ_name(d.comp_code,d.publ) publ_name,d.edtn,dbo.cir_get_edtn_name(d.comp_code,d.edtn) edtn_name,
		d.route_code route_code,dbo.cir_get_route_name(d.comp_code,d.unit_code,d.route_code) route_name,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
substring(m.ag_name,1,50) "AGENCY NAME",substring(m.ag_name_oth_lang,1,50) "AGENCY ONAME",dbo.cir_get_city(d.comp_code,m.city_code) "CITY NAME",
isnull(dbo.CIR_GET_NAME_CIR_CITY(d.comp_code,m.city_code,2,'+''''+@pdateformat+''''+','''',''''),''NA'') "CITY ONAME", 
dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", dbo.cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT"
, '+@vvar+','+@vvar_sum+' TOTAL 
from cir_unsold_dtl d,cir_agmast m,cir_publ_mast p where m.comp_code=d.comp_code  and m.comp_code=p.comp_code 
and d.comp_code='+''''+@pcomp_code+''''+' and m.unit=d.unit_code and d.unit_code='+''''+@punit_code+''''+' 
and d.publ=p.publ and p.period=''1'' and (d.publ='+''''+@ppubl+''''+' or '+''''+@ppubl+''''+' is null) 
and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '+'to_date('+''''+@pfrom_supdate+''''+','+''''+@pdateformat+''''+') and to_date('+''''+@ptill_supdate+''''+','+''''+@pdateformat+''''+') and ((route_code='+''''+@proute+''''+') or ('+''''+@proute+''''+' is null)) and
d.edtn in(select distinct edtn from cir_edtn_mast where comp_code=d.comp_code and edtn = d.edtn and (main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' is null))
group by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code order by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code,d.agcd,d.dpcd';
     insert into test1(vstring) values ('1'+@vquery);commit;
 print(@vquery)
 exec(@vquery)
 
      set @vquery2='select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,dbo.cir_get_publ_name(d.comp_code,d.publ) publ_name, '+@vvar+','+@vvar_sum+' TOTAL 
				from cir_unsold_dtl d,cir_agmast m,cir_publ_mast p where m.comp_code=d.comp_code  and m.comp_code=p.comp_code  
				and d.comp_code='+ ''''+@pcomp_code+''''+' 
				and m.unit=d.unit_code and d.publ=p.publ and p.period=''1'' 
				and d.unit_code='+''''+@punit_code+''''+' 
				and (d.publ='+''''+@ppubl+''''+' or '+''''+@ppubl+''''+' is null) 
				and m.agcd=d.agcd and m.dpcd=d.dpcd 
				and d.supdate between '+'to_date('+''''+@pfrom_supdate+''''+','+''''+@pdateformat+''''+') 
				and to_date('+''''+@ptill_supdate+''''+','+''''+@pdateformat+''''+') 
				group by d.comp_code,d.unit_code,d.publ order by d.comp_code,d.unit_code,d.publ';
				insert into test1(vstring) values ('22'+@vquery2);commit;

	select d.comp_code,d.publ,dbo.cir_get_publ_name(d.comp_code,d.publ) publ_name,sum(isnull(c.sup_copy,0)) sup_copy, 
					sum(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+ isnull(apr_bnr,0)+ isnull(apr_unsold,0)+isnull(apr_damage,0)) unsold_copy,
					sum(isnull(c.sup_copy,0))-sum(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+ isnull(apr_bnr,0)+ isnull(apr_unsold,0)+isnull(apr_damage,0)) net_copy
	from cir_dbksup c ,cir_unsold_dtl d,cir_publ_mast p
			where  c.comp_code=p.comp_code and d.comp_code=c.comp_code and  d.comp_code=@pcomp_code
			and   c.unit_code=d.unit_code 
			and  (d.unit_code=@punit_code or @punit_code is null)
			and c.publ=d.publ and  d.publ=p.publ and p.period<>'1'  and (d.publ=@ppubl or @ppubl  is null) 
			and d.supdate between @vfrom_supdate and  @vtill_supdate  
   group by  d.comp_code,d.publ order by d.comp_code,d.publ;
        
        select getdate() as "CUR_DATE" 
        select getdate() as "CUR_DATE"
        select getdate() as "CUR_DATE" 
   
 DEALLOCATE cur_sup_type

/////////////////////////////////////////////////////end



/////////////////start   anurag ////////26 mar///////////////////////////////////

USE [abhi]
GO
/****** Object:  StoredProcedure [dbo].[cir_rep_edtnrate_unsold_supply]    Script Date: 03/26/2012 12:50:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                                                                     
                                                                     
                                                                     
                                             
ALTER procedure [dbo].[cir_rep_edtnrate_unsold_supply]
     @pcomp_code         as varchar(20),
     @punit_code         as varchar(20),
     @pdoc_type          as varchar(20),
     @ppubl              as varchar(20),
     @pmainedtn          as varchar(20),
     @pedtn              as varchar(20),
     @pagcode            as varchar(20),
     @pdepocode          as varchar(20),
     @pstatecode         as varchar(20),
     @pdistcode          as varchar(20),
     @ptalukacode        as varchar(20),
     @pfromdate          as datetime,
     @ptilldate          as datetime,
     @papproved_flag     as varchar(20),
     @preptype           as varchar(20),---it is used for report break on 1 for state,2 for district and 3 for district taluka
     @pdateformat        as varchar(20),
     @pextra1            as varchar(200),
     @pextra2            as varchar(200)
  As
	declare @v_frdt    as datetime
	declare @v_todt    as datetime
	declare @v_query1  as varchar(8000)
	declare @rec_edtn_publ	as varchar(20) 
	declare @rec_edtn_edtn	as varchar(20)
	declare @rec_edtn_edtn_name	as varchar(50)
	declare @rec_edtn_edtn_seq_no as int
      
	declare cur_edtn cursor for
        select distinct u.publ publ,u.edtn edtn,u.edtn_name edtn_name,u.edtn_seqno edtn_seq_no from
        (select distinct e.publ publ,e.edtn edtn,e.edtn_name edtn_name,e.edtn_seq_no edtn_seqno
        from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e 
        where a.comp_code=b.comp_code and b.comp_code=e.comp_code and b.comp_code=@pcomp_code and
        a.unit=b.unit_code and b.unit_code=e.unit_code and b.unit_code=@punit_code and b.doctype=isnull(@pdoc_type,'UCN') and 
        b.recptdt >= @v_frdt and b.recptdt<=@v_todt and b.publ=e.publ and (b.publ=isnull(@ppubl,b.publ) or @ppubl='') and 
        b.edtn=e.edtn and (b.edtn=isnull(@pedtn,b.edtn) or @pedtn ='') and (e.main_edtn=isnull(@pmainedtn,e.main_edtn) or @pmainedtn ='') and 
        a.agcd=b.agcd and a.dpcd=b.dpcd and (b.agcd=isnull(@pagcode,b.agcd) or @pagcode='') and (b.dpcd=isnull(@pdepocode,b.dpcd) or @pdepocode='') and 
        (a.state_code=@pstatecode or @pstatecode is null or @pstatecode='') and 
        (a.dist_code=@pdistcode or @pdistcode is null or @pdistcode='') and 
        (a.tehsil_taluka=@ptalukacode or @ptalukacode is null or @ptalukacode='') and
        (isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0))>0) u
        order by edtn_seq_no,edtn

     declare @vvar       varchar(8000)
     declare @tot_vvar   varchar(8000)
     declare @vtot_publ  varchar(8000)
     declare @v_cnt      int
  Begin
	set @v_frdt   =@pfromdate
	set @v_todt   =@ptilldate
     
    open cur_edtn
        fetch NEXT FROM cur_edtn INTO @rec_edtn_publ,@rec_edtn_edtn,@rec_edtn_edtn_name,@rec_edtn_edtn_seq_no
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
          set @v_cnt =isnull(@v_cnt,0)+1
          if @vvar is null 
			Begin
              set @vvar      ='case when u.edtn='+''''+@rec_edtn_edtn+''''+' then sum(u.supply_copy) else 0 end "'+@rec_edtn_edtn+'_SUPPLY"';
              set @vvar      =@vvar+',case when u.edtn='+''''+@rec_edtn_edtn+''''+' then sum(u.return_copy) else 0 end "'+@rec_edtn_edtn+'_RETURN"';
              set @vvar      =@vvar+',round((case when u.edtn='+''''+@rec_edtn_edtn+''''+' then sum(u.return_copy) else 0 end *100)/case when u.edtn='+''''+@rec_edtn_edtn+''''+' then sum(u.supply_copy) else 1 end ,2)"'+@rec_edtn_edtn+'_RETURN_PER"';
              set @tot_vvar  =@tot_vvar+',sum("'+@rec_edtn_edtn+'_SUPPLY") "'+@rec_edtn_edtn+'_SUPPLY"';
              set @tot_vvar  =@tot_vvar+',sum("'+@rec_edtn_edtn+'_RETURN") "'+@rec_edtn_edtn+'_RETURN"';
              set @tot_vvar  =@tot_vvar+',sum("'+@rec_edtn_edtn+'_RETURN_PER") "'+@rec_edtn_edtn+'_RETURN_PER"';
              set @vtot_publ =@rec_edtn_edtn_name
			End
          else
			Begin
              set @vvar      =@vvar+',case when u.edtn='+''''+@rec_edtn_edtn+''''+' then sum(u.supply_copy) else 0 end "'+@rec_edtn_edtn+'_SUPPLY"';
              set @vvar      =@vvar+',case when u.edtn='+''''+@rec_edtn_edtn+''''+'then sum(u.return_copy) else 0 end "'+@rec_edtn_edtn+'_RETURN"';
              set @vvar      =@vvar+',round((case when u.edtn='+''''+@rec_edtn_edtn+''''+' then sum(u.return_copy) else 0 end *100)/case when u.edtn='+''''+@rec_edtn_edtn+''''+' then sum(u.supply_copy) else 1 end,2)"'+@rec_edtn_edtn+'_RETURN_PER"';
              set @tot_vvar  =@tot_vvar+',sum("'+@rec_edtn_edtn+'_SUPPLY") "'+@rec_edtn_edtn+'_SUPPLY"';
              set @tot_vvar  =@tot_vvar+',sum("'+@rec_edtn_edtn+'_RETURN") "'+@rec_edtn_edtn+'_RETURN"';
              set @tot_vvar  =@tot_vvar+',sum("'+@rec_edtn_edtn+'_RETURN_PER") "'+@rec_edtn_edtn+'_RETURN_PER"';
              set @vtot_publ =@vtot_publ+''''+','+''''+@rec_edtn_edtn_name
			End

			fetch NEXT FROM cur_edtn INTO @rec_edtn_publ,@rec_edtn_edtn,@rec_edtn_edtn_name,@rec_edtn_edtn_seq_no
		End
    close cur_edtn
    
    if @vvar is not null --agency wise detail
		Begin
            set @v_query1='select c.comp_code comp_code,c.unit_code unit_code,c.agcd agcd,c.dpcd dpcd,c.agname agname,c.agname_oth_lang agname_oth_lang,
               c.state_code state_code,isnull(dbo.cir_get_state(c.comp_code,c.country_code,c.state_code),''NA'') state_name,isnull(dbo.cir_get_city(c.comp_code,c.city_code),''NA'') city_name,
               c.dist_code,isnull(dbo.cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'') dist_name,
               c.tehsil_taluka taluka_code,isnull(dbo.cir_get_taluka(c.comp_code,c.tehsil_taluka),''NA'') taluka_name '+@tot_vvar+'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,
               u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,u.city_code city_code,u.state_code state_code,u.dist_code dist_code,
               u.country_code country_code,u.tehsil_taluka tehsil_taluka,'+@vvar
               +'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.state_code state_code,a.dist_code,a.country_code,a.tehsil_taluka, 
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and billagcd=b.agcd and billdpcd=b.dpcd and publ=b.publ and edtn=b.edtn and supdate=b.supdate) supply_copy,
                            isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
                   where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code ='+''''+@pcomp_code+''''+' and 
                               b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code='+''''+@punit_code+''''+' and 
                               b.doctype='+''''+@pdoc_type+''''+' and b.recptdt >= '+''''+CONVERT(VARCHAR(11), @V_FRDT, 101)+''''+' and b.recptdt <='+''''+CONVERT(VARCHAR(11), @V_TODT, 101)+''''+' and 
                               b.publ=e.publ and ((b.publ='+''''+@ppubl+''''+') or ('+''''+@ppubl+''''+' is null) or ('+''''+@ppubl+''''+'='''')) and 
                               b.edtn=e.edtn and ((b.edtn='+''''+@pedtn+''''+') or ('+''''+@pedtn+''''+' is null) or ('+''''+@pedtn+''''+'='''')) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='+''''+@pagcode+''''+') or ('+''''+@pagcode+''''+' is null) or ('+''''+@pagcode+''''+'='''')) and 
                               ((b.dpcd='+''''+@pdepocode+''''+') or ('+''''+@pdepocode+''''+' is null) or ('+''''+@pdepocode+''''+'='''')) and 
                               ((a.dist_code='+''''+@pdistcode+''''+') or ('+''''+@pdistcode+''''+' is null) or ('+''''+@pdistcode+''''+'='''')) and
                               ((a.state_code='+''''+@pstatecode+''''+') or ('+''''+@pstatecode+''''+' is null)or ('+''''+@pstatecode+''''+'='''')) and
                               ((a.tehsil_taluka='+''''+@ptalukacode+''''+') or ('+''''+@ptalukacode+''''+' is null)or ('+''''+@ptalukacode+''''+'='''')) and
                               (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and
                               (e.main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' is null or ('+''''+@pmainedtn+''''+'=''''))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,
                               u.city_code,u.state_code,u.dist_code,u.country_code,u.tehsil_taluka) c
                               group by c.comp_code,c.unit_code,c.agcd,c.dpcd,c.agname,c.agname_oth_lang,c.city_code,
                               c.state_code,c.dist_code,c.country_code,c.tehsil_taluka
                               order by c.comp_code,c.unit_code,state_name, dist_name,taluka_name,c.agname'
                                              
			print(@v_query1)
			exec(@v_query1)

			if @preptype='1'  --for statewise
				Begin
                   set @v_query1='select c.comp_code comp_code,c.unit_code unit_code,
                   c.state_code state_code,isnull(dbo.cir_get_state(c.comp_code,c.country_code,c.state_code),''NA'') state_name '+@tot_vvar+'
                   from
                   (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,
                   u.state_code state_code,u.dist_code dist_code,u.country_code country_code,'+@vvar
                   +'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                                b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                                a.city_code city_code,a.state_code state_code,a.dist_code dist_code,a.country_code,
                                (select sum(sup_copy) from cir_dbksup 
                                where comp_code=b.comp_code and unit_code=b.unit_code and billagcd=b.agcd and billdpcd=b.dpcd and publ=b.publ and edtn=b.edtn and supdate=b.supdate) supply_copy,
                                isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0) return_copy
                       from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
                       where b.comp_code    =a.comp_code and b.comp_code=e.comp_code and b.comp_code    ='+''''+@pcomp_code+''''+' and 
                                   b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code='+''''+@punit_code+''''+' and 
                                   b.doctype='+''''+@pdoc_type+''''+' and b.recptdt >= '+''''+CONVERT(VARCHAR(11), @V_FRDT, 101)+''''+' and b.recptdt <='+''''+CONVERT(VARCHAR(11), @V_TODT, 101)+''''+' and 
                                    b.publ=e.publ and ((b.publ='+''''+@ppubl+''''+') or ('+''''+@ppubl+''''+' is null) or ('+''''+@ppubl+''''+'='''')) and 
                                    b.edtn=e.edtn and ((b.edtn='+''''+@pedtn+''''+') or ('+''''+@pedtn+''''+' is null) or ('+''''+@pedtn+''''+'='''')) and 
                                   a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='+''''+@pagcode+''''+') or ('+''''+@pagcode+''''+' is null) or ('+''''+@pagcode+''''+'='''') ) and 
                                    ((b.dpcd='+''''+@pdepocode+''''+') or ('+''''+@pdepocode+''''+' is null) or ('+''''+@pdepocode+''''+'='''')) and 
                                    ((a.dist_code='+''''+@pdistcode+''''+') or ('+''''+@pdistcode+''''+' is null) or ('+''''+@pdistcode+''''+'='''')) and
                                    ((a.state_code='+''''+@pstatecode+''''+') or ('+''''+@pstatecode+''''+' is null)or ('+''''+@pstatecode+''''+'='''')) and
                                    ((a.tehsil_taluka='+''''+@ptalukacode+''''+') or ('+''''+@ptalukacode+''''+' is null)or ('+''''+@ptalukacode+''''+'='''')) and
                                   (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and
                                   (e.main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' is null or ('+''''+@pmainedtn+''''+'=''''))) u
                                   where u.supply_copy>0
                                   group by u.comp_code,u.unit_code,u.publ,u.edtn,u.state_code,u.country_code,u.dist_code) c
                                   group by c.comp_code,c.unit_code,c.country_code,c.state_code
                                   order by c.comp_code,c.unit_code,state_name'
				End
			else --for district wise and district taluka wise
				Begin
					set @v_query1='select c.comp_code comp_code,c.unit_code unit_code,
					   c.state_code state_code,isnull(dbo.cir_get_state(c.comp_code,c.country_code,c.state_code),''NA'') state_name,
					   c.dist_code dist_code,isnull(dbo.cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'') dist_name '+@tot_vvar+'
					   from
					   (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,
					   u.state_code state_code,u.dist_code dist_code,u.country_code country_code, '+@vvar
					   +'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
									b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
									a.city_code city_code,a.state_code state_code,a.dist_code dist_code,a.country_code country_code,
									(select sum(sup_copy) from cir_dbksup 
									where comp_code=b.comp_code and unit_code=b.unit_code and billagcd=b.agcd and billdpcd=b.dpcd and publ=b.publ and edtn=b.edtn and supdate=b.supdate) supply_copy,
									isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0) return_copy
						   from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
						   where b.comp_code    =a.comp_code and b.comp_code=e.comp_code and b.comp_code    ='+''''+@pcomp_code+''''+' and 
									   b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code='+''''+@punit_code+''''+' and 
									   b.doctype='+''''+@pdoc_type+''''+' and b.recptdt >= '+''''+CONVERT(VARCHAR(11), @V_FRDT, 101)+''''+' and b.recptdt <='+''''+CONVERT(VARCHAR(11), @V_TODT, 101)+''''+' and 
									   b.publ=e.publ and ((b.publ='+''''+@ppubl+''''+') or ('+''''+@ppubl+''''+' is null) or ('+''''+@ppubl+''''+'='''')) and 
										b.edtn=e.edtn and ((b.edtn='+''''+@pedtn+''''+') or ('+''''+@pedtn+''''+' is null) or ('+''''+@pedtn+''''+'='''')) and 
									   a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='+''''+@pagcode+''''+') or ('+''''+@pagcode+''''+' is null) or ('+''''+@pagcode+''''+'='''') ) and 
									   ((b.dpcd='+''''+@pdepocode+''''+') or ('+''''+@pdepocode+''''+' is null) or ('+''''+@pdepocode+''''+'='''')) and 
								   ((a.dist_code='+''''+@pdistcode+''''+') or ('+''''+@pdistcode+''''+' is null) or ('+''''+@pdistcode+''''+'='''')) and
								   ((a.state_code='+''''+@pstatecode+''''+') or ('+''''+@pstatecode+''''+' is null)or ('+''''+@pstatecode+''''+'='''')) and
								   ((a.tehsil_taluka='+''''+@ptalukacode+''''+') or ('+''''+@ptalukacode+''''+' is null)or ('+''''+@ptalukacode+''''+'='''')) and
									   (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and
									   (e.main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' is null or ('+''''+@pmainedtn+''''+'=''''))) u
									   where u.supply_copy>0
									   group by u.comp_code,u.unit_code,u.publ,u.edtn,u.state_code,u.country_code,u.dist_code) c
									   group by c.comp_code,c.unit_code,c.country_code,c.state_code,c.dist_code
									   order by c.comp_code,c.unit_code,state_name,dist_name';
					print(@v_query1)
					exec(@v_query1)

               
				   set @v_query1='select c.comp_code comp_code,c.unit_code unit_code '+@tot_vvar+'
				   from
				   (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,dbo.cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,'+@vvar
				   +'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
								b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
								a.city_code city_code,a.state_code state_code,a.dist_code dist_code,
								(select sum(sup_copy) from cir_dbksup 
								where comp_code=b.comp_code and unit_code=b.unit_code and billagcd=b.agcd and billdpcd=b.dpcd and publ=b.publ and edtn=b.edtn and supdate=b.supdate) supply_copy,
								isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0) return_copy
					   from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
					   where b.comp_code    =a.comp_code and b.comp_code=e.comp_code and b.comp_code    ='+''''+@pcomp_code+''''+' and 
								   b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code='+''''+@punit_code+''''+' and 
								   b.doctype='+''''+@pdoc_type+''''+' and b.recptdt >= '+''''+CONVERT(VARCHAR(11), @V_FRDT, 101)+''''+' and b.recptdt <='+''''+CONVERT(VARCHAR(11), @V_TODT, 101)+''''+' and 
								   b.publ=e.publ and ((b.publ='+''''+@ppubl+''''+') or ('+''''+@ppubl+''''+' is null) or ('+''''+@ppubl+''''+'='''')) and 
								   b.edtn=e.edtn and ((b.edtn='+''''+@pedtn+''''+') or ('+''''+@pedtn+''''+' is null) or ('+''''+@pedtn+''''+'='''')) and 
								   a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='+''''+@pagcode+''''+') or ('+''''+@pagcode+''''+' is null) or ('+''''+@pagcode+''''+'='''') ) and 
								   ((b.dpcd='+''''+@pdepocode+''''+') or ('+''''+@pdepocode+''''+' is null) or ('+''''+@pdepocode+''''+'='''')) and 
								   ((a.dist_code='+''''+@pdistcode+''''+') or ('+''''+@pdistcode+''''+' is null) or ('+''''+@pdistcode+''''+'='''')) and
								   ((a.state_code='+''''+@pstatecode+''''+') or ('+''''+@pstatecode+''''+' is null)or ('+''''+@pstatecode+''''+'='''')) and
								   ((a.tehsil_taluka='+''''+@ptalukacode+''''+') or ('+''''+@ptalukacode+''''+' is null)or ('+''''+@ptalukacode+''''+'='''')) and
								   (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and
								   (e.main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' is null or ('+''''+@pmainedtn+''''+'=''''))) u
								   where u.supply_copy>0
								   group by u.comp_code,u.unit_code,u.publ,u.edtn)c
								   group by c.comp_code,c.unit_code
								   order by c.comp_code,c.unit_code'

					print(@v_query1)
					exec(@v_query1)

					set @v_query1='select '+''''+@vtot_publ+''''+' '

					print(@v_query1)
					exec(@v_query1)


               if @preptype ='3' Begin --for district taluka wise
                    set @v_query1='select c.comp_code comp_code,c.unit_code unit_code,
                       c.state_code state_code,isnull(dbo.cir_get_state(c.comp_code,c.country_code,c.state_code),''NA'') state_name,
                       c.dist_code dist_code, isnull(dbo.cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'') dist_name,
                       c.tehsil_taluka taluka_code,isnull(dbo.cir_get_taluka(c.comp_code,c.tehsil_taluka),''NA'') taluka_name '+@tot_vvar+'
                       from
                       (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,
                       u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,u.city_code city_code,u.state_code state_code,u.dist_code dist_code,
                       u.country_code country_code,u.tehsil_taluka tehsil_taluka,'+@vvar
                       +'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                                    b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                                    a.city_code city_code,a.state_code state_code,a.dist_code,a.country_code,a.tehsil_taluka, 
                                    (select sum(sup_copy) from cir_dbksup 
                                    where comp_code=b.comp_code and unit_code=b.unit_code and billagcd=b.agcd and billdpcd=b.dpcd and publ=b.publ and edtn=b.edtn and supdate=b.supdate) supply_copy,
                                    isnull(b.apr_short_recpt,0)+isnull(b.apr_late_recpt,0)+isnull(b.apr_bnr,0)+isnull(b.apr_unsold,0) return_copy
                           from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
                           where b.comp_code    =a.comp_code and b.comp_code=e.comp_code and b.comp_code    ='+''''+@pcomp_code+''''+' and 
                                       b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code='+''''+@punit_code+''''+' and 
                                       b.doctype='+''''+@pdoc_type+''''+' and b.recptdt >= '+''''+CONVERT(VARCHAR(11), @V_FRDT, 101)+''''+' and b.recptdt <='+''''+CONVERT(VARCHAR(11), @V_TODT, 101)+''''+' and 
                                       b.publ=e.publ and ((b.publ='+''''+@ppubl+''''+') or ('+''''+@ppubl+''''+' is null) or ('+''''+@ppubl+''''+'='''')) and 
                                    b.edtn=e.edtn and ((b.edtn='+''''+@pedtn+''''+') or ('+''''+@pedtn+''''+' is null) or ('+''''+@pedtn+''''+'='''')) and 
                                       a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='+''''+@pagcode+''''+') or ('+''''+@pagcode+''''+' is null) or ('+''''+@pagcode+''''+'='''') ) and 
                                    ((b.dpcd='+''''+@pdepocode+''''+') or ('+''''+@pdepocode+''''+' is null) or ('+''''+@pdepocode+''''+'='''')) and 
                                    ((a.dist_code='+''''+@pdistcode+''''+') or ('+''''+@pdistcode+''''+' is null) or ('+''''+@pdistcode+''''+'='''')) and
                                    ((a.state_code='+''''+@pstatecode+''''+') or ('+''''+@pstatecode+''''+' is null)or ('+''''+@pstatecode+''''+'='''')) and
                                    ((a.tehsil_taluka='+''''+@ptalukacode+''''+') or ('+''''+@ptalukacode+''''+' is null)or ('+''''+@ptalukacode+''''+'='''')) and
                                       (isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0 and
                                       (e.main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' is null or ('+''''+@pmainedtn+''''+'=''''))) u
                                       where u.supply_copy>0
                                       group by u.comp_code,u.unit_code,u.publ,u.edtn,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,
                                       u.city_code,u.state_code,u.dist_code,u.country_code,u.tehsil_taluka) c
                                       group by c.comp_code,c.unit_code,c.state_code,c.dist_code,c.country_code,c.tehsil_taluka
                                       order by c.comp_code,c.unit_code,state_name, dist_name,taluka_name'
					End
               else
				   Begin
					set @v_query1='select '+''''+@pcomp_code+''''+' comp_code,'+''''+@punit_code+''''+' unit_code,0 supply_copy,0 return_copy'
				   End
		       print(@v_query1)
		       exec(@v_query1)
			End
		End       
        Else
			Begin
				set @v_query1='select '+''''+@pcomp_code+''''+' comp_code,'+''''+@punit_code+''''+' unit_code,null agcd,null dpcd,null agname,null agname_oth_lang,null city_name,null taluka_name,0 supply_copy,0 return_copy';

				print(@v_query1)
				exec(@v_query1)

				set @v_query1='select '+''''+@pcomp_code+''''+' comp_code,'+''''+@punit_code+''''+' unit_code,null taluka_name,0 supply_copy,0 return_copy '

				print(@v_query1)
				exec(@v_query1)

				set @v_query1='select '+''''+@pcomp_code+''''+' comp_code,'+''''+@punit_code+''''+' unit_code,0 supply_copy,0 return_copy '
            
			    print(@v_query1)
				exec(@v_query1)
            
				set @v_query1='select '+''''+@pcomp_code+''''+' comp_code,'+''''+@punit_code+''''+' unit_code,0 supply_copy,0 return_copy '

				print(@v_query1)
				exec(@v_query1)
            
				set @v_query1='select null '

	            exec (@v_query1) 
		    End
End 


/////////////////////////////end ////////////////////////////////////////////////



/////////////////////start anurag  23 mar ///////////////////////////////


USE [abhi]
GO
/****** Object:  StoredProcedure [dbo].[cir_rep_collection_cir_rep_unitwise_monthwise_p]    Script Date: 03/26/2012 17:07:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[cir_rep_collection_cir_rep_unitwise_monthwise_p] 
	@pcompcode                                VARCHAR(4000) ,
	@punitcode                                VARCHAR(4000) ,
	@pdoctype                                 VARCHAR(4000) ,
	@ppaymode_reason                          VARCHAR(4000) ,
	@pactype                                  VARCHAR(4000) ,
	@pfromdate                                datetime ,
	@ptodate                                  datetime ,
	@pdateformat                              VARCHAR(4000) ,
	@pextra1                                  VARCHAR(4000) ,
	@pextra2                                  VARCHAR(4000) 
AS 
	
SET CONCAT_NULL_YIELDS_NULL OFF
	DECLARE @v_frdt                                   DATETIME 
	DECLARE @v_todt                                   DATETIME 

	DECLARE @v_frdt11                                 VARCHAR(40) 
	DECLARE @v_todt11                                 VARCHAR(40) 
	DECLARE @v_months                                 FLOAT                           
	SET @v_months = 0 
	DECLARE @v_cnt                                    FLOAT                           
	SET @v_cnt = 0 
	DECLARE @v_dt                                     DATETIME 
	DECLARE @v_dt11                                   VARCHAR(40) 
	DECLARE @vvar                                     VARCHAR(4000) 
	DECLARE @vvar_sum                                 VARCHAR(4000) 
	DECLARE @vquery                                   VARCHAR(4000) 
	DECLARE @vquery1                                   VARCHAR(4000) 


	SET @v_frdt  = @pfromdate--dbo.convert_user_date('/',@pdateformat, @pfromdate)
	SET @v_todt  = @ptodate--dbo.convert_user_date('/',@pdateformat, @ptodate)
     
    

	set @v_frdt11 =  cast (@v_frdt as datetime)
	set @v_todt11 =  cast (@v_todt as datetime)

    SET @v_frdt11  = CONVERT(VARCHAR(25),@v_frdt,101)
    SET @v_todt11  = CONVERT(VARCHAR(25),@v_todt,101)

	PRINT('1')

		SELECT @v_months  =  ( convert(FLOAT ,month(@v_todt)) - convert(FLOAT ,month(@v_frdt)) ),@v_dt  =   (CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@v_frdt)-1),@v_frdt),101))
		
		PRINT(@v_months)

		PRINT(@v_dt)
PRINT('11')
		set @v_dt11 =  cast (@v_dt as varchar)

		IF @v_months = 0 BEGIN 
			SET @v_months  = 0 
		END
	
		WHILE (0 = 0) BEGIN 
			IF @v_cnt > @v_months BEGIN 
				BREAK
			END
			IF @vvar is null BEGIN 
				SET @vvar  = 'sum(case(CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(a.recptdt)-1),a.recptdt),101)) when ' + '''' + @v_dt11 + '''' + 'then a.amount else 0 end ) "' + @v_dt11 + '"' 
				SET @vvar_sum  = 'sum("' + @v_dt11 + '") "' + @v_dt11 + '"' 
			END
			ELSE BEGIN 
				SET @vvar  = @vvar + ',sum(case(CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(a.recptdt)-1),a.recptdt),101)) when ' + '''' + @v_dt11 + '''' + 'then a.amount else 0 end ) "' + @v_dt11 + '"' 
				SET @vvar_sum  = @vvar_sum + ',sum("' + @v_dt11 + '") "' + @v_dt11 + '"' 
			END
   
			SET @v_dt  = DATEADD(M, 1, @v_dt)
			SET @v_cnt  = @v_cnt + 1 
		    set @v_dt11 =  cast (@v_dt as varchar)
		END 
		

		print(@vvar)
		print(@vvar_sum)
		--insert into test1(vstring,vstring2) values('unit monthwise vvar ',v_months,vvar)
		
		IF @vvar is not null BEGIN 
			SET @vquery  = 'select comp_code,unit_code,unit_code unit_name,' + @vvar_sum + ' from  
			(select a.comp_code comp_code,a.unit_code unit_code,CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(recptdt)-1),recptdt),101) as  recptdt
			,' + @vvar + ' from cir_rcphdr a  where a.comp_code=' + '''' + @pcompcode + '''' + ' 
			and (a.unit_code=' + '''' + @punitcode + '''' + ' or' + '''' + @punitcode + '''' + ' is null' + ' or  ' + '''' + @punitcode + '''' + ' = '''') 
			and (a.doctype=' + '''' + @pdoctype + '''' + ' or' + '''' + @pdoctype + '''' + ' is null' + ' or  ' + '''' + @pdoctype + '''' + ' = '''') 
			and a.recptdt between' + '''' + @v_frdt11 + '''' + ' and' + '''' + @v_todt11 + '''' + ' 
			and (a.reason=' + '''' + @ppaymode_reason + '''' + ' or' + '''' + @ppaymode_reason + '''' + ' is null' + ' or  ' + '''' + @ppaymode_reason + '''' + ' = '''') 
			and (a.achd=' + '''' + @pactype + '''' + ' or' + '''' + @pactype + '''' + ' is null' + ' or  ' + '''' + @pactype + '''' + ' = '''')   
			group by a.comp_code,a.unit_code,CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(recptdt)-1),recptdt),101) )l 
			group by l.comp_code,l.unit_code,CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(l.recptdt)-1),l.recptdt),101) 
			,(DATENAME(MM, l.recptdt) '+ ' + '+ '''' +'-' +''''+ ' + ' + 'CAST(YEAR(l.recptdt) AS VARCHAR(4)))   
			order by l.comp_code,l.unit_code' 
			EXEC (@vquery) 
			SET @vquery1  = 'select comp_code,' + @vvar_sum + ' from  (select a.comp_code comp_code,a.unit_code unit_code
			,a.recptdt recptdt,' + @vvar + ' from cir_rcphdr a  where a.comp_code=' + '''' + @pcompcode + '''' + ' 
			and (a.unit_code=' + '''' + @punitcode + '''' + ' or' + '''' + @punitcode + '''' + ' is null' + ' or  ' + '''' + @punitcode + '''' + ' = '''') 
			and (a.doctype=' + '''' + @pdoctype + '''' + ' or' + '''' + @pdoctype + '''' + ' is null' + ' or  ' + '''' + @pdoctype + '''' + ' = '''')
			and a.recptdt between' + '''' + @v_frdt11 + '''' + ' and' + '''' + @v_todt11 + '''' + ' 
			and (a.reason=' + '''' + @ppaymode_reason + '''' + ' or' + '''' + @ppaymode_reason + '''' + ' is null' + ' or  ' + '''' + @ppaymode_reason + '''' + ' = '''') 
			and (a.achd=' + '''' + @pactype + '''' + ' or' + '''' + @pactype + '''' + ' is null' + ' or  ' + '''' + @pactype + '''' + ' = '''')   
			group by a.comp_code,a.unit_code,a.recptdt,a.reason) 
			m group by m.comp_code  order by m.comp_code' 
			EXEC (@vquery1) 
		END
		ELSE 
        BEGIN 
			SET @vquery  = 'select' + '''' + @pcompcode + '''' + ' "comp_code",' + '''' + @punitcode + '''' + ' "unit_code"  where 1=2' 
			EXEC (@vquery) 
			SET @vquery1  = 'select' + '''' + @pcompcode + '''' + ' "comp_code"  where 1=2' 
			EXEC (@vquery1) 
		END
		
print(@vquery)
print(@vquery1)


///////////////////////////////////end///////////////////////////////////////////////////////



/////////////////////////////////national sales report 26 mar 2012//////by rahul////////////////////////////////////

ALTER PROCEDURE [dbo].[cir_rep_national_sale_cir_rep_national_zone]
    @pcomp_code                               varchar(4000) ,
    @punit_code                               varchar(4000) ,
    @pbranch_code                             varchar(4000) ,
    @ppubl                                    varchar(4000) ,
    @pedtn                                    varchar(4000) ,
    @pag_type                                 varchar(4000) ,
    @pag_class                                varchar(4000) ,
    @preport_type                             varchar(4000) ,
    @pbill_pay                                varchar(4000) ,
    @pfrom_supdate                            varchar(4000) ,
    @ptill_supdate                            varchar(4000) ,
    @pdateformat                              varchar(4000) ,
    @pextra1                                  varchar(4000) ,
    @pextra2                                  varchar(4000) ,
    @pextra3                                  varchar(4000) ,
    @pextra4                                  varchar(4000) ,
    @pextra5                                  varchar(4000) ,
    @pextra6                                  varchar(4000) ,
    @pextra7                                  varchar(4000) ,
    @pextra8                                  varchar(4000) ,
    @pextra9                                  varchar(4000) ,
    @pextra10                                 varchar(4000)  
AS 
    DECLARE @LOOPPROCESSINGFLAG BIT 
    BEGIN
        SET NOCOUNT ON
        
        DECLARE @VFROM_SUPDATE                            DATETIME 
        DECLARE @VTILL_SUPDATE                            DATETIME 
        SELECT @VFROM_SUPDATE  = CONVERT(DATETIME, @pfrom_supdate)
        SELECT @VTILL_SUPDATE  = CONVERT(DATETIME, @ptill_supdate)
        ---BRANCH WISE
        
        SET @LOOPPROCESSINGFLAG = 0
        IF @preport_type = '1' 
        BEGIN 
            

                            SELECT
                                     A.COMP_CODE,
                                     A.UNIT_CODE,
                                     A.PUBL,
                                     A.EDTN,
                                     DBO.CIR_GET_PUBL_NAME(A.COMP_CODE, A.PUBL) AS "PUBL_NAME",
                                     DBO.CIR_GET_EDTN_NAME(A.COMP_CODE, A.EDTN) AS "EDITION",
                                     SUM(CONVERT(FLOAT, A.SUP_COPY)) AS "SUP_COPY",
                                     A.SUP_RATE,
                                     COUNT(A.EDTN) AS "DAYS",
                                     DBO.CIR_GET_BRANCH(A.COMP_CODE, M.BRANCH_CODE) AS "BRANCH_NAME",
                                     CAST(ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) / CONVERT(FLOAT, COUNT(A.EDTN)),0) AS INTEGER) AVG_COPY,
                                     ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) * SUP_RATE, 2) AS "COPY_AMT"
                            FROM  CIR_DBKSUP A,
                                 CIR_SUPPLY_TYPE_MAST B,
                                 CIR_AGMAST M,
                                 CIR_CITY_MAST K 
                            WHERE     A.COMP_CODE  = B.COMP_CODE
                             AND    A.COMP_CODE  = M.COMP_CODE
                             AND    (A.COMP_CODE  = @pcomp_code
                             OR    @pcomp_code  IS NULL)
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL)
                             AND    (M.BRANCH_CODE  = @pbranch_code
                             OR    @pbranch_code  IS NULL)
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL)
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL)
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL)
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL)
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL)
                             AND    (A.SUPDATE  BETWEEN @VFROM_SUPDATE  AND  @VTILL_SUPDATE)
                            GROUP BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 M.BRANCH_CODE,
                                  A.SUP_RATE 
            ORDER BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 M.BRANCH_CODE,
                                 A.SUP_RATE 
            
            

                            SELECT
                                     A.COMP_CODE,
                                     A.UNIT_CODE,
                                     A.PUBL,
                                     DBO.CIR_GET_PUBL_NAME(A.COMP_CODE, A.PUBL) AS "PUBL_NAME",
                                     A.SUP_RATE,
                                     C.COPY_RATE,
                                     A.EDTN,
                                     DBO.CIR_GET_EDTN_NAME(A.COMP_CODE, A.EDTN) AS "EDITION",
                                     SUM(CONVERT(FLOAT, A.SUP_COPY)) AS "SUP_COPY",
                                     COUNT(A.EDTN) AS "DAYS",
                                     CAST(ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) / CONVERT(FLOAT, COUNT(A.EDTN)),0) AS INTEGER) AVG_COPY,
                                     ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) * SUP_RATE, 2) AS "COPY_AMT",
                                     SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) AS "UNSOLD_COPY",
                                     SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) * C.COPY_RATE AS "UNSOLD_AMT",
                                     ROUND((SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) * 100) / CONVERT(FLOAT, SUM(CONVERT(FLOAT, A.SUP_COPY))), 2) AS "UNS_PER"
                            FROM  CIR_DBKSUP A,
                                 CIR_SUPPLY_TYPE_MAST B,
                                 CIR_UNSOLD_DTL C,
                                 CIR_AGMAST M 
                            WHERE     A.COMP_CODE  = B.COMP_CODE
                             AND    A.COMP_CODE  = M.COMP_CODE
                             AND    (A.COMP_CODE  = @pcomp_code
                             OR    @pcomp_code  IS NULL)
                             AND    A.COMP_CODE  = C.COMP_CODE
                             AND    A.UNIT_CODE  = C.UNIT_CODE
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL)
                             AND    A.PUBL  = C.PUBL
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL)
                             AND    A.EDTN  = C.EDTN
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL)
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL)
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL)
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_RATE  = C.COPY_RATE
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL)
                             AND    (A.SUPDATE  BETWEEN @VFROM_SUPDATE  AND  @VTILL_SUPDATE)
                            GROUP BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 A.SUP_RATE,
                                  C.COPY_RATE 
            ORDER BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 A.SUP_RATE 
            
            SET @LOOPPROCESSINGFLAG = 1
        END
        IF @preport_type = '2'  AND (@LOOPPROCESSINGFLAG = 0)
        BEGIN 
            

                            SELECT
                                     A.COMP_CODE,
                                     A.UNIT_CODE,
                                     A.PUBL,
                                     A.EDTN,
                                     DBO.CIR_GET_PUBL_NAME(A.COMP_CODE, A.PUBL) AS "PUBL_NAME",
                                     DBO.CIR_GET_EDTN_NAME(A.COMP_CODE, A.EDTN) AS "EDITION",
                                     SUM(CONVERT(FLOAT, A.SUP_COPY)) AS "SUP_COPY",
                                     A.SUP_RATE,
                                     COUNT(A.EDTN) AS "DAYS",
                                     DBO.CIR_GET_ZONE_NAME(A.COMP_CODE, K.ZONE_CODE) AS "ZONE_NAME",
                                     CAST(ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) / CONVERT(FLOAT, COUNT(A.EDTN)),0) AS INTEGER) AVG_COPY,
                                     ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) * SUP_RATE, 2) AS "COPY_AMT"
                            FROM  CIR_DBKSUP A,
                                 CIR_SUPPLY_TYPE_MAST B,
                                 CIR_AGMAST M,
                                 CIR_CITY_MAST K 
                            WHERE     A.COMP_CODE  = B.COMP_CODE
                             AND    A.COMP_CODE  = M.COMP_CODE
                             AND    (A.COMP_CODE  = @pcomp_code
                             OR    @pcomp_code  IS NULL)
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL)
                             AND    (M.BRANCH_CODE  = @pbranch_code
                             OR    @pbranch_code  IS NULL)
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL)
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL)
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL)
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL)
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL)
                             AND    (A.SUPDATE  BETWEEN @VFROM_SUPDATE  AND  @VTILL_SUPDATE)
                            GROUP BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 K.ZONE_CODE,
                                  A.SUP_RATE 
            ORDER BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 K.ZONE_CODE,
                                 A.SUP_RATE 
            
            

                            SELECT
                                     A.COMP_CODE,
                                     A.UNIT_CODE,
                                     A.PUBL,
                                     DBO.CIR_GET_PUBL_NAME(A.COMP_CODE, A.PUBL) AS "PUBL_NAME",
                                     A.SUP_RATE,
                                     C.COPY_RATE,
                                     A.EDTN,
                                     DBO.CIR_GET_EDTN_NAME(A.COMP_CODE, A.EDTN) AS "EDITION",
                                     SUM(CONVERT(FLOAT, A.SUP_COPY)) AS "SUP_COPY",
                                     A.SUP_RATE,
                                     COUNT(A.EDTN) AS "DAYS",
                                     CAST(ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) / CONVERT(FLOAT, COUNT(A.EDTN)),0) AS INTEGER) AVG_COPY,
                                     ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) * SUP_RATE, 2) AS "COPY_AMT",
                                     SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) AS "UNSOLD_COPY",
                                     C.COPY_RATE,
                                     SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) * C.COPY_RATE AS "UNSOLD_AMT",
                                     ROUND((SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) * 100) / CONVERT(FLOAT, SUM(CONVERT(FLOAT, A.SUP_COPY))), 2) AS "UNS_PER"
                            FROM  CIR_DBKSUP A,
                                 CIR_SUPPLY_TYPE_MAST B,
                                 CIR_UNSOLD_DTL C,
                                 CIR_AGMAST M 
                            WHERE     A.COMP_CODE  = B.COMP_CODE
                             AND    A.COMP_CODE  = M.COMP_CODE
                             AND    (A.COMP_CODE  = @pcomp_code
                             OR    @pcomp_code  IS NULL)
                             AND    A.COMP_CODE  = C.COMP_CODE
                             AND    A.UNIT_CODE  = C.UNIT_CODE
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL)
                             AND    A.PUBL  = C.PUBL
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL)
                             AND    A.EDTN  = C.EDTN
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL)
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL)
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL)
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_RATE  = C.COPY_RATE
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL)
                             AND    (A.SUPDATE  BETWEEN @VFROM_SUPDATE  AND  @VTILL_SUPDATE)
                            GROUP BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 A.SUP_RATE,
                                  C.COPY_RATE 
            ORDER BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 A.SUP_RATE 
            
            SET @LOOPPROCESSINGFLAG = 1
        END
        IF @preport_type = '3'  AND (@LOOPPROCESSINGFLAG = 0)
        BEGIN 
            

                            SELECT
                                     A.COMP_CODE,
                                     A.UNIT_CODE,
                                     A.PUBL,
                                     A.EDTN,
                                     DBO.CIR_GET_PUBL_NAME(A.COMP_CODE, A.PUBL) AS "PUBL_NAME",
                                     DBO.CIR_GET_EDTN_NAME(A.COMP_CODE, A.EDTN) AS "EDITION",
                                     SUM(CONVERT(FLOAT, A.SUP_COPY)) AS "SUP_COPY",
                                     A.SUP_RATE,
                                     COUNT(A.EDTN) AS "DAYS",
                                     DBO.CIR_GET_REGION_NAME(A.COMP_CODE, K.REGION_CODE) AS "REGION_NAME",
                                     CAST(ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) / CONVERT(FLOAT, COUNT(A.EDTN)),0) AS INTEGER) AVG_COPY,
                                     ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) * SUP_RATE, 2) AS "COPY_AMT"
                            FROM  CIR_DBKSUP A,
                                 CIR_SUPPLY_TYPE_MAST B,
                                 CIR_AGMAST M,
                                 CIR_CITY_MAST K 
                            WHERE     A.COMP_CODE  = B.COMP_CODE
                             AND    A.COMP_CODE  = M.COMP_CODE
                             AND    (A.COMP_CODE  = @pcomp_code
                             OR    @pcomp_code  IS NULL)
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL)
                             AND    (M.BRANCH_CODE  = @pbranch_code
                             OR    @pbranch_code  IS NULL)
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL)
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL)
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL)
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL)
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL)
                             AND    (A.SUPDATE  BETWEEN @VFROM_SUPDATE  AND  @VTILL_SUPDATE)
                            GROUP BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 K.REGION_CODE,
                                  A.SUP_RATE 
            ORDER BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 K.REGION_CODE,
                                 A.SUP_RATE 
            
            

                            SELECT
                                     A.COMP_CODE,
                                     A.UNIT_CODE,
                                     A.PUBL,
                                     DBO.CIR_GET_PUBL_NAME(A.COMP_CODE, A.PUBL) AS "PUBL_NAME",
                                     A.SUP_RATE,
                                     C.COPY_RATE,
                                     A.EDTN,
                                     DBO.CIR_GET_EDTN_NAME(A.COMP_CODE, A.EDTN) AS "EDITION",
                                     SUM(CONVERT(FLOAT, A.SUP_COPY)) AS "SUP_COPY",
                                     COUNT(A.EDTN) AS "DAYS",
                                     CAST(ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) / CONVERT(FLOAT, COUNT(A.EDTN)),0) AS INTEGER) AVG_COPY,
                                     ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) * SUP_RATE, 2) AS "COPY_AMT",
                                     SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) AS "UNSOLD_COPY",
                                     SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) * C.COPY_RATE AS "UNSOLD_AMT",
                                     ROUND((SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) * 100) / CONVERT(FLOAT, SUM(CONVERT(FLOAT, A.SUP_COPY))), 2) AS "UNS_PER"
                            FROM  CIR_DBKSUP A,
                                 CIR_SUPPLY_TYPE_MAST B,
                                 CIR_UNSOLD_DTL C,
                                 CIR_AGMAST M 
                            WHERE     A.COMP_CODE  = B.COMP_CODE
                             AND    A.COMP_CODE  = M.COMP_CODE
                             AND    (A.COMP_CODE  = @pcomp_code
                             OR    @pcomp_code  IS NULL)
                             AND    A.COMP_CODE  = C.COMP_CODE
                             AND    A.UNIT_CODE  = C.UNIT_CODE
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL)
                             AND    A.PUBL  = C.PUBL
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL)
                             AND    A.EDTN  = C.EDTN
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL)
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL)
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL)
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_RATE  = C.COPY_RATE
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL)
                             AND    (A.SUPDATE  BETWEEN @VFROM_SUPDATE  AND  @VTILL_SUPDATE)
                            GROUP BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 A.SUP_RATE,
                                  C.COPY_RATE 
            ORDER BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 A.SUP_RATE 
            
            SET @LOOPPROCESSINGFLAG = 1
        END
        IF @preport_type = '4'  AND (@LOOPPROCESSINGFLAG = 0)
        BEGIN 
            

                            SELECT
                                     A.COMP_CODE,
                                     A.UNIT_CODE,
                                     A.PUBL,
                                     A.EDTN,
                                     DBO.CIR_GET_PUBL_NAME(A.COMP_CODE, A.PUBL) AS "PUBL_NAME",
                                     DBO.CIR_GET_EDTN_NAME(A.COMP_CODE, A.EDTN) AS "EDITION",
                                     SUM(CONVERT(FLOAT, A.SUP_COPY)) AS "SUP_COPY",
                                     A.SUP_RATE,
                                     COUNT(A.EDTN) AS "DAYS",
                                     DBO.CIR_GET_STATE(A.COMP_CODE, K.COUNTRY_CODE, K.STATE_CODE) AS "STATE_NAME",
                                     CAST(ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) / CONVERT(FLOAT, COUNT(A.EDTN)),0) AS INTEGER) AVG_COPY,
                                     ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) * SUP_RATE, 2) AS "COPY_AMT"
                            FROM  CIR_DBKSUP A,
                                 CIR_SUPPLY_TYPE_MAST B,
                                 CIR_AGMAST M,
                                 CIR_CITY_MAST K 
                            WHERE     A.COMP_CODE  = B.COMP_CODE
                             AND    A.COMP_CODE  = M.COMP_CODE
                             AND    (A.COMP_CODE  = @pcomp_code
                             OR    @pcomp_code  IS NULL)
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL)
                             AND    (M.BRANCH_CODE  = @pbranch_code
                             OR    @pbranch_code  IS NULL)
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL)
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL)
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL)
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL)
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL)
                             AND    (A.SUPDATE  BETWEEN @VFROM_SUPDATE  AND  @VTILL_SUPDATE)
                            GROUP BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 K.COUNTRY_CODE,
                                 K.STATE_CODE,
                                  A.SUP_RATE 
            ORDER BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 K.COUNTRY_CODE,
                                 K.STATE_CODE,
                                 A.SUP_RATE 
            
            

                            SELECT
                                     A.COMP_CODE,
                                     A.UNIT_CODE,
                                     A.PUBL,
                                     DBO.CIR_GET_PUBL_NAME(A.COMP_CODE, A.PUBL) AS "PUBL_NAME",
                                     A.EDTN,
                                     DBO.CIR_GET_EDTN_NAME(A.COMP_CODE, A.EDTN) AS "EDITION",
                                     SUM(CONVERT(FLOAT, A.SUP_COPY)) AS "SUP_COPY",
                                     COUNT(A.EDTN) AS "DAYS",
                                     CAST(ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) / CONVERT(FLOAT, COUNT(A.EDTN)),0) AS INTEGER) AVG_COPY,
                                     ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) * SUP_RATE, 2) AS "COPY_AMT",
                                     A.SUP_RATE,
                                     C.COPY_RATE,
                                     SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) AS "UNSOLD_COPY",
                                     SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) * C.COPY_RATE AS "UNSOLD_AMT",
                                     ROUND((SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) * 100) / CONVERT(FLOAT, SUM(CONVERT(FLOAT, A.SUP_COPY))), 2) AS "UNS_PER"
                            FROM  CIR_DBKSUP A,
                                 CIR_SUPPLY_TYPE_MAST B,
                                 CIR_UNSOLD_DTL C,
                                 CIR_AGMAST M 
                            WHERE     A.COMP_CODE  = B.COMP_CODE
                             AND    A.COMP_CODE  = M.COMP_CODE
                             AND    (A.COMP_CODE  = @pcomp_code
                             OR    @pcomp_code  IS NULL)
                             AND    A.COMP_CODE  = C.COMP_CODE
                             AND    A.UNIT_CODE  = C.UNIT_CODE
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL)
                             AND    A.PUBL  = C.PUBL
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL)
                             AND    A.EDTN  = C.EDTN
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL)
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL)
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL)
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_RATE  = C.COPY_RATE
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL)
                             AND    (A.SUPDATE  BETWEEN @VFROM_SUPDATE  AND  @VTILL_SUPDATE)
                            GROUP BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 A.SUP_RATE,
                                  C.COPY_RATE 
            ORDER BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 A.SUP_RATE
                                
            
            SET @LOOPPROCESSINGFLAG = 1
        END
        IF @preport_type = '5'  AND (@LOOPPROCESSINGFLAG = 0)
        BEGIN 
            

                            SELECT
                                     A.COMP_CODE,
                                     A.UNIT_CODE,
                                     A.PUBL,
                                     A.EDTN,
                                     DBO.CIR_GET_PUBL_NAME(A.COMP_CODE, A.PUBL) AS "PUBL_NAME",
                                     DBO.CIR_GET_EDTN_NAME(A.COMP_CODE, A.EDTN) AS "EDITION",
                                     SUM(CONVERT(FLOAT, A.SUP_COPY)) AS "SUP_COPY",
                                     A.SUP_RATE,
                                     COUNT(A.EDTN) AS "DAYS",
                                     DBO.CIR_GET_DIST(A.COMP_CODE, K.STATE_CODE, K.DIST_CODE) AS "DIST_NAME",
                                     CAST(ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) / CONVERT(FLOAT, COUNT(A.EDTN)),0) AS INTEGER) AVG_COPY,
                                     ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) * SUP_RATE, 2) AS "COPY_AMT"
                            FROM  CIR_DBKSUP A,
                                 CIR_SUPPLY_TYPE_MAST B,
                                 CIR_AGMAST M,
                                 CIR_CITY_MAST K 
                            WHERE     A.COMP_CODE  = B.COMP_CODE
                             AND    A.COMP_CODE  = M.COMP_CODE
                             AND    (A.COMP_CODE  = @pcomp_code
                             OR    @pcomp_code  IS NULL)
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL)
                             AND    (M.BRANCH_CODE  = @pbranch_code
                             OR    @pbranch_code  IS NULL)
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL)
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL)
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL)
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL)
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL)
                             AND    (A.SUPDATE  BETWEEN @VFROM_SUPDATE  AND  @VTILL_SUPDATE)
                            GROUP BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 K.STATE_CODE,
                                 K.DIST_CODE,
                                  A.SUP_RATE 
            ORDER BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 K.STATE_CODE,
                                 K.DIST_CODE,
                                 A.SUP_RATE 
            
            

                            SELECT
                                     A.COMP_CODE,
                                     A.UNIT_CODE,
                                     A.PUBL,
                                     DBO.CIR_GET_PUBL_NAME(A.COMP_CODE, A.PUBL) AS "PUBL_NAME",
                                     A.SUP_RATE,
                                     C.COPY_RATE,
                                     A.EDTN,
                                     DBO.CIR_GET_EDTN_NAME(A.COMP_CODE, A.EDTN) AS "EDITION",
                                     SUM(CONVERT(FLOAT, A.SUP_COPY)) AS "SUP_COPY",
                                     COUNT(A.EDTN) AS "DAYS",
                                     CAST(ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) / CONVERT(FLOAT, COUNT(A.EDTN)),0) AS INTEGER) AVG_COPY,
                                     ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) * SUP_RATE, 2) AS "COPY_AMT",
                                     SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) AS "UNSOLD_COPY",
                                     SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) * C.COPY_RATE AS "UNSOLD_AMT",
                                     ROUND((SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) * 100) / CONVERT(FLOAT, SUM(CONVERT(FLOAT, A.SUP_COPY))), 2) AS "UNS_PER"
                            FROM  CIR_DBKSUP A,
                                 CIR_SUPPLY_TYPE_MAST B,
                                 CIR_UNSOLD_DTL C,
                                 CIR_AGMAST M 
                            WHERE     A.COMP_CODE  = B.COMP_CODE
                             AND    A.COMP_CODE  = M.COMP_CODE
                             AND    (A.COMP_CODE  = @pcomp_code
                             OR    @pcomp_code  IS NULL)
                             AND    A.COMP_CODE  = C.COMP_CODE
                             AND    A.UNIT_CODE  = C.UNIT_CODE
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL)
                             AND    A.PUBL  = C.PUBL
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL)
                             AND    A.EDTN  = C.EDTN
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL)
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL)
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL)
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_RATE  = C.COPY_RATE
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL)
                             AND    (A.SUPDATE  BETWEEN @VFROM_SUPDATE  AND  @VTILL_SUPDATE)
                            GROUP BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 A.SUP_RATE,
                                  C.COPY_RATE 
            ORDER BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 A.SUP_RATE 
            
            SET @LOOPPROCESSINGFLAG = 1
        END
        IF (@LOOPPROCESSINGFLAG = 0)
        BEGIN 
            ---NONE
            
            

                            SELECT
                                     A.COMP_CODE,
                                     A.UNIT_CODE,
                                     A.PUBL,
                                     A.EDTN,
                                     DBO.CIR_GET_PUBL_NAME(A.COMP_CODE, A.PUBL) AS "PUBL_NAME",
                                     DBO.CIR_GET_EDTN_NAME(A.COMP_CODE, A.EDTN) AS "EDITION",
                                     SUM(CONVERT(FLOAT, A.SUP_COPY)) AS "SUP_COPY",
                                     A.SUP_RATE,
                                     COUNT(A.EDTN) AS "DAYS",
                                     CAST(ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) / CONVERT(FLOAT, COUNT(A.EDTN)),0) AS INTEGER) AVG_COPY,
                                     ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) * SUP_RATE, 2) AS "COPY_AMT"
                            FROM  CIR_DBKSUP A,
                                 CIR_SUPPLY_TYPE_MAST B,
                                 CIR_AGMAST M,
                                 CIR_CITY_MAST K 
                            WHERE     A.COMP_CODE  = B.COMP_CODE
                             AND    A.COMP_CODE  = M.COMP_CODE
                             AND    (A.COMP_CODE  = @pcomp_code
                             OR    @pcomp_code  IS NULL)
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL)
                             AND    (M.BRANCH_CODE  = @pbranch_code
                             OR    @pbranch_code  IS NULL)
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL)
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL)
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL)
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL)
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL)
                             AND    (A.SUPDATE  BETWEEN @VFROM_SUPDATE  AND  @VTILL_SUPDATE)
                            GROUP BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                  A.SUP_RATE 
            ORDER BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 A.SUP_RATE 
            
            

                            SELECT
                                     A.COMP_CODE,
                                     A.UNIT_CODE,
                                     A.PUBL,
                                     DBO.CIR_GET_PUBL_NAME(A.COMP_CODE, A.PUBL) AS "PUBL_NAME",
                                     A.SUP_RATE,
                                     C.COPY_RATE,
                                     A.EDTN,
                                     DBO.CIR_GET_EDTN_NAME(A.COMP_CODE, A.EDTN) AS "EDITION",
                                     SUM(CONVERT(FLOAT, A.SUP_COPY)) AS "SUP_COPY",
                                     COUNT(A.EDTN) AS "DAYS",
                                     CAST(ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) / CONVERT(FLOAT, COUNT(A.EDTN)),0) AS INTEGER) AVG_COPY,
                                     ROUND(SUM(CONVERT(FLOAT, A.SUP_COPY)) * SUP_RATE, 2) AS "COPY_AMT",
                                     SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) AS "UNSOLD_COPY",
                                     SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) * C.COPY_RATE AS "UNSOLD_AMT",
                                     ROUND((SUM(CONVERT(FLOAT, ISNULL(C.APR_SHORT_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_LATE_RECPT, 0) + ISNULL(C.APR_UNSOLD, 0) + ISNULL(C.APR_BNR, 0))) * 100) / CONVERT(FLOAT, SUM(CONVERT(FLOAT, A.SUP_COPY))), 2) AS "UNS_PER"
                            FROM  CIR_DBKSUP A,
                                 CIR_SUPPLY_TYPE_MAST B,
                                 CIR_UNSOLD_DTL C,
                                 CIR_AGMAST M 
                            WHERE     A.COMP_CODE  = B.COMP_CODE
                             AND    A.COMP_CODE  = M.COMP_CODE
                             AND    (A.COMP_CODE  = @pcomp_code
                             OR    @pcomp_code  IS NULL)
                             AND    A.COMP_CODE  = C.COMP_CODE
                             AND    A.UNIT_CODE  = C.UNIT_CODE
                             AND    A.UNIT_CODE  = M.UNIT
                             AND    (A.UNIT_CODE  = @punit_code
                             OR    @punit_code  IS NULL)
                             AND    A.PUBL  = C.PUBL
                             AND    (A.PUBL  = @ppubl
                             OR    @ppubl  IS NULL)
                             AND    A.EDTN  = C.EDTN
                             AND    (A.EDTN  = @pedtn
                             OR    @pedtn  IS NULL)
                             AND    (M.AG_TYPE  = @pag_type
                             OR    @pag_type  IS NULL)
                             AND    (M.AG_CLASS  = @pag_class
                             OR    @pag_class  IS NULL)
                             AND    A.AGCD  = M.AGCD
                             AND    A.DPCD  = M.DPCD
                             AND    A.SUP_RATE  = C.COPY_RATE
                             AND    A.SUP_TYPE_CODE  = B.SUP_TY_CODE
                             AND    (B.BILL_PAY  = @pbill_pay
                             OR    @pbill_pay  IS NULL)
                             AND    (A.SUPDATE  BETWEEN @VFROM_SUPDATE  AND  @VTILL_SUPDATE)
                            GROUP BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 A.SUP_RATE,
                                  C.COPY_RATE 
            ORDER BY A.COMP_CODE,
                                 A.UNIT_CODE,
                                 A.PUBL,
                                 A.EDTN,
                                 A.SUP_RATE 
            
        END
   

        SET NOCOUNT OFF

    END


/////////////////////////////////////////////end of national sales report /////////////////////////////////////////


////////////////////////////////////for bank master 27/03/2012/////////////////////////////////////

ALTER PROCEDURE [dbo].[CIR_checkkbankcode]
	@str                                      VARCHAR(200) ,
	@cod                                      VARCHAR(200) 
AS 

		SELECT *
		FROM  cir_bank_mast 
		WHERE	 bankname  = @str
		
		
	
		SELECT MAX( cast(SUBSTRING(bankcode, 3, LEN(bankcode)) as int)  ) as CURR_CODE 
		FROM  cir_bank_mast 
		WHERE	 bankcode  like @cod + '%'
		
		
		

////////////////////////////////////////////////end//////////////////////////////////////////////////////

//----------------------------------start 27/03/2012 Ritu---------------//


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[cir_route_drop_point_time_p]
   (
@pcomp_code          as varchar(50),
    @punit_code          as varchar(50),
    @ptaxi_code          as varchar(50),
    @proute_code         as varchar(50),
    @psubroutecode       as varchar(50),
    @psub_subroutecode   as varchar(50),
    @puserid             as varchar(50),
    @pdateformat         as varchar(50),
    @pextra1             as varchar(50),
    @pextra2             as varchar(50),
    @pextra3             as varchar(50),
    @pextra4             as varchar(50),
    @pextra5             as varchar(50)
    --p_accounts          OUT Cur_Type_New1.cursor_type)
)
  As
 
						select a.comp_code, a.unit_code,a.taxi_id,a.vehicle_no,a.drop_point_code,
dbo.cir_get_drop_point_name(a.comp_code,a.unit_code,a.drop_point_code,1) "DROP_POINT_NAME",
						a.arrival_time,a.stoppage_time,a.created_by, a.created_dt, a.updated_by, a.updated_dt,a.drop_point_seqno,a.latitude, a.longitude,a.status,b.rt_code,
						b.subrt_code,b.sub_subrt_code from cir_taxi_route a,cir_taxi_mast b 
						where 
						a.comp_code=b.comp_code and a.comp_code=@pcomp_code   and a.unit_code=b.unit_code and 
						a.unit_code=@punit_code and a.taxi_id=b.taxi_id and a.status='Y' and a.taxi_id=@ptaxi_code and 
						(b.rt_code=@proute_code or @proute_code='') and (b.subrt_code=@psubroutecode  or  @psubroutecode='') and
						(b.sub_subrt_code=@psub_subroutecode or @psub_subroutecode='')
						order by a.comp_code, a.unit_code,a.taxi_id,a.vehicle_no,a.drop_point_code



//------------------------------------------end------------------------





   //--------------------start-------anurag------31 mar----------------------------------------------------------------------//


USE [abhi]
GO
/****** Object:  StoredProcedure [dbo].[cir_rep_billing_cir_weekly_bill_summary_p]    Script Date: 03/31/2012 12:31:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[cir_rep_billing_cir_weekly_bill_summary_p]
	@pcomp_code      as varchar(200),
    @punit_code      as varchar(200),
    @repty           as varchar(200),
    @pbill_freq      as varchar(200),
    @pfrom_billdt    as varchar(200),
    @ptill_billdt    as varchar(200),
    @ppubl           as varchar(200),
    @pbillagcd       as varchar(200),
    @pbilldpcd       as varchar(200),
    @pdateformat     as varchar(200),
    @pbrancode       as varchar(200),
    @pdistcode       as varchar(200),
    @pagclass        as varchar(200),
    @pextra1         as varchar(200),--for executive code
    @pextra2         as varchar(200) 
AS 
begin

	declare @v_bill_frdt   datetime;
	declare @v_bill_todt   datetime
	declare @v_start_date  datetime
	declare @v_dt          datetime
	declare @v_query1      varchar(8000);
	declare @v_query2      varchar(8000);
	declare @v_statecode   varchar(20);
	declare @v_distcode    varchar(20);
	declare @v_citycode    varchar(20);
	declare @v_taluka      varchar(20);
      
	if @ppubl ='' begin
		set @ppubl = null
	end
	if @pbillagcd ='' begin
		set @pbillagcd = null
	end
	if @pbilldpcd ='' begin
		set @pbilldpcd = null
	end
	if @pbrancode ='' begin
		set @pbrancode = null
	end
	if @pdistcode ='' begin
		set @pdistcode = null
	end
	if @pagclass ='' begin
		set @pagclass = null
	end
	if @pextra1 ='' begin
		set @pextra1 = null
	end
	if @pextra2 ='' begin
		set @pextra2 = null
	end
	if @pbill_freq ='' begin
		set @pbill_freq = null
	end
	if @repty ='' begin
		set @repty = null
	end	
	
	      
		-- cursor variable cur_not_supply start here --
		DECLARE @rec_not_supply_comp_code as varchar(200)
		DECLARE @rec_not_supply_unit_code as varchar(200)
		DECLARE @rec_not_supply_agcd as varchar(200)
		DECLARE @rec_not_supply_dpcd as varchar(200)
		DECLARE @rec_not_supply_publ as varchar(200)
		DECLARE @rec_not_supply_edtn as varchar(200)
		DECLARE @rec_not_supply_supply_date as datetime
		DECLARE @rec_not_supply_copy_rate  as numeric(8,4)
		-- cursor variable cur_not_supply end here --			
		
		-- cursor variable cur_bill start here --	
		DECLARE @cur_bill_comp_code as varchar(200)
		DECLARE @cur_bill_unit_code as varchar(200)
		DECLARE @cur_bill_agcd as varchar(200)
		DECLARE @cur_bill_dpcd as varchar(200)
		DECLARE @cur_bill_ag_name as varchar(500)
		DECLARE @cur_bill_ag_name_oth_lang as varchar(500)
		DECLARE @cur_bill_city_code as varchar(200)
		DECLARE @cur_bill_country_code as varchar(200)
		DECLARE @cur_bill_state_code as varchar(200)
		DECLARE @cur_bill_dist_code as varchar(200)
		DECLARE @cur_bill_taluka_code as varchar(200)
		DECLARE @cur_bill_supply_copy numeric(10)
		DECLARE @cur_bill_gross_amount numeric(15,2)
		DECLARE @cur_bill_sur_amount numeric(15,2)
		DECLARE @cur_bill_comm_amount numeric(15,5)
		DECLARE @cur_bill_bill_sec_amt numeric(15,2)
		-- cursor variable cur_bill end here --	
		
		-- cursor variable cur_type start here -- cur_type	 
		declare @v2_doctyp as varchar(200)	
		declare @v2_amount as numeric(15,2)
			
		-- cursor variable cur_type end here --

    	declare @v_dsign           numeric(2);
        declare @v_comp_code       varchar(8);
        declare @v_unit_code       varchar(8);
        declare @v_publ_code       varchar(8);
        declare @v_agcode          varchar(20);
        declare @v_depo_code       varchar(20);
        declare @v_agname          varchar(200);
        declare @v_agname_oth_lang varchar(250);
        declare @v_city_name       varchar(100);
        
        declare @v_return_copy     numeric(10);
        declare @v_return_amt      numeric(10,2);
        declare @vbill_no          varchar(20);
        declare @v_rcp_count       numeric;
        set @v_rcp_count=0
        declare @v_prev_agcd       varchar(30);  
        set @v_prev_agcd='XX'
        declare @v_cur_agcd        varchar(30); 
		set @v_cur_agcd='XX'
        declare @v_ret_gross       numeric(15,2);
        set @v_ret_gross=0
        declare @v_ret_comm        numeric(15,2);
        set @v_ret_comm=0
        declare @v_ret_copy        numeric(15);
        set @v_ret_copy=0
        declare @v_dn_amt          numeric(15,2);
        set @v_dn_amt=0
        declare @v_cn_amt          numeric(15,2);
        set @v_cn_amt=0
        declare @v_rec_amt         numeric(15,2);
        set @v_rec_amt=0
        declare @v_prev_bal        numeric(15,2);
        set @v_prev_bal=0
        declare @v_sec_bal         numeric(15,2);
        set @v_sec_bal=0
        declare @v_psecamt         numeric(15,2);
        set @v_psecamt=0
        declare @v_csecamt         numeric(15,2) 
        set @v_csecamt=0
        declare @v_opdate          datetime
        declare @v_bill_exist      numeric(5);

        declare @v_pbillret        numeric(15,2);
        set @v_pbillret=0
        declare @v_state_name        varchar(200);
        declare @v_dist_name         varchar(200);
        declare @v_taluka_name       varchar(200);    	
    	
		set @v_bill_frdt     =@pfrom_billdt
		set @v_bill_todt     =@ptill_billdt
		set @v_opdate        =dbo.cir_get_finandt(@pcomp_code,@pfrom_billdt,@pdateformat,'','');
		set @v_start_date    =dbo.GetFirstDayOfMonth(@v_bill_frdt)
	
CREATE TABLE #CIR_TEMP_BILL_COLLECTION
(
  COMP_CODE           VARCHAR(100),
  UNIT_CODE           VARCHAR(100),
  BILLNO              VARCHAR(200),
  BILLDT              DATEtime,
  PUBL_CODE           VARCHAR(100),
  AGCD                VARCHAR(100),
  DPCD                VARCHAR(100),
  SUPPLY_COPY         numeric(10)                DEFAULT 0,
  GROSS_AMT           numeric(15,2)              DEFAULT 0,
  COMM_AMT            numeric(15,2)              DEFAULT 0,
  SUR_AMT             numeric(15,2)              DEFAULT 0,
  RETURN_COPY         numeric(10)                DEFAULT 0,
  RETURN_AMT          numeric(15,2)              DEFAULT 0,
  DN_AMT              numeric(15,2)              DEFAULT 0,
  CN_AMT              numeric(15,2)              DEFAULT 0,
  REC_AMT             numeric(15,2)              DEFAULT 0,
  PREV_BAL            numeric(15,2)              DEFAULT 0,
  CUR_SESSIONID       numeric,
  AGNAME              VARCHAR(200),
  AGNAME_OTH_LANG     VARCHAR(250),
  CITY_CODE           VARCHAR(200),
  TALUKA_CODE         VARCHAR(200),
  DIST_CODE           VARCHAR(200),
  STATE_CODE          VARCHAR(200),
  REMARKS             VARCHAR(500),
  RET_COMM_AMT        numeric(15,2),
  BILL_SEC_AMT        numeric(15,2),
  SEC_OPBAL           numeric(15,2),
  ZONE_CODE           VARCHAR(200),
  REGION_CODE         VARCHAR(200),
  PRO_TYPE            VARCHAR(200),
  COMM_CODE           VARCHAR(200),
  ROUTE_CODE          VARCHAR(200),
  PRINTING_CENT_CODE  VARCHAR(200),
  SUPPLY_AVG_TODT     numeric(15,2),
  RETURN_AVG_TODT     numeric(15,2),
  NET_AVG_TODT        numeric(15,2),
  PER_AVG_TODT        numeric(15,2)
)
	
		
	CREATE TABLE #CIR_TEMP_OUTSTANDING
	(
	COMP_CODE        VARCHAR(8),
	UNIT_CODE        VARCHAR(8),
	DT               DATEtime,
	PUBL_CODE        VARCHAR(8),
	AGCD             VARCHAR(8),
	DPCD             VARCHAR(8),
	BILL_AMT         NUMERic(15,2)                 DEFAULT 0,
	RETURN_AMT       NUMERic(15,2)                 DEFAULT 0,
	DN_AMT           NUMERic(15,2)                 DEFAULT 0,
	CN_AMT           NUMERic(15,2)                 DEFAULT 0,
	REC_AMT          NUMERic(15,2)                 DEFAULT 0,
	AGNAME           VARCHAR(200),
	AGNAME_OTH_LANG  VARCHAR(250),
	CITY_CODE        VARCHAR(20),
	TALUKA_CODE      VARCHAR(20),
	DIST_CODE        VARCHAR(20),
	STATE_CODE       VARCHAR(20),
	COUNTRY_CODE     VARCHAR(20),
	OP_AMT           NUMERic(15,2),
	BRANCH_CODE      VARCHAR(8)
	)
	
	if @repty='S' begin
			set @v_statecode=@pdistcode;
		end
		else if @repty='D' begin
			set @v_distcode=@pdistcode;
		end
		else if @repty='C' begin
			set @v_citycode=@pdistcode;
		end
		else
		begin
			set @v_taluka=@pdistcode;
		end
		
	declare @v_str_dt as varchar(10)
		delete from cir_bill_print where cur_sessionid=@@spid
		delete from cir_bill_return_print where cur_sessionid=@@spid
       
		select @v_bill_exist=count(*) from cir_bill_det b,cir_publ_mast p 
		where b.comp_code=@pcomp_code and b.comp_code = p.comp_code and b.unit_code=@punit_code and 
		b.billdt >= @v_bill_frdt and b.billdt<=@v_bill_todt and b.publ =p.publ and 
		(b.agcd=isnull(@pbillagcd,b.agcd) or @pbillagcd='') and (b.dpcd=isnull(@pbilldpcd,b.dpcd) or @pbilldpcd='');
/*
if @v_frdt=@v_start_date begin
			exec cir_rep_billing_cir_before_bill_process_p @pcompcode,@punitcode,@ppubl_freq,@ppubl,@pfrom_date,@ptill_date,@pbillagcd,@pbilldpcd,@pagencytype,@pagencyclass ,@pbranchcode, @pdistcode , @ptaluka,@pdateformat,'','',''
		end
		else begin
			exec cir_rep_billing_cir_before_bill_process_p @pcompcode,@punitcode,@ppubl_freq,@ppubl,@v_start_date,@ptill_date,@pbillagcd,@pbilldpcd,@pagencytype,@pagencyclass ,@pbranchcode, @pdistcode , ptaluka,@pdateformat,'','',''
		end

*/
		
		if @v_bill_frdt=@v_start_date begin
			exec cir_rep_billing_cir_before_bill_process_p @pcomp_code,@punit_code,'',@ppubl,@pfrom_billdt,@ptill_billdt,@pbillagcd,@pbilldpcd,'',@pagclass ,@pbrancode, @v_distcode , @v_taluka,@pdateformat,'','',''
			print('P')
		end
		else
		begin
			
			select @v_str_dt = case @pdateformat 
							   when 'dd/mm/yyyy' then convert(varchar(10),@v_start_date,103)
							   when 'mm/dd/yyyy' then convert(varchar(10),@v_start_date,101)
							   when 'yyyy/mm/dd' then convert(varchar(10),@v_start_date,111) end
		exec cir_rep_billing_cir_before_bill_process_p @pcomp_code,@punit_code,'',@ppubl,@v_str_dt,@ptill_billdt,@pbillagcd,@pbilldpcd,'',@pagclass ,@pbrancode, @v_distcode , @v_taluka,@pdateformat,'','',''
		end
		
		delete from #cir_temp_bill_collection where cur_sessionid=@@spid
		
print('start')
print(@v_start_date)
print(@pbillagcd)
print(@pbilldpcd)
print(@v_bill_todt)
print(@pagclass)
print(@v_distcode)
print(@v_taluka)
print(@pbrancode)
print(@pextra1)
print('end')
		DECLARE cur_not_supply cursor LOCAL FOR 
			select u.comp_code ,u.unit_code ,u.agcd ,u.dpcd ,u.publ ,u.edtn ,u.supply_date ,u.copy_rate  from             
            (select d.comp_code,d.unit_code,d.agcd,d.dpcd,d.publ,d.edtn,d.recptdt supply_date,d.copy_rate 
            from cir_agmast m,cir_unsold_dtl d
            where d.comp_code=m.comp_code and d.comp_code=@pcomp_code and d.unit_code=m.unit and d.unit_code=@punit_code and 
                d.doctype='UCN' and d.agcd=m.agcd  and d.dpcd=m.dpcd and d.app_dt >= @v_start_date  and d.agcd=isnull(@pbillagcd,d.agcd) 
                and d.dpcd=isnull(@pbilldpcd,d.dpcd) and d.app_dt<=@v_bill_todt and  (m.ag_class=@pagclass or @pagclass is null) 
                and (m.dist_code=@v_distcode or @v_distcode is null) and 
                (m.tehsil_taluka=@v_taluka or @v_taluka is null) and d.supply_copy>0 and (m.branch_code=@pbrancode or @pbrancode is null) and
                (m.executive_code = @pextra1 or @pextra1 is null) and 
                (isnull(d.apr_late_recpt,0)+isnull(d.apr_short_recpt,0)+isnull(d.apr_bnr,0)+isnull(d.apr_unsold,0))>0
             AND NOT EXISTS
            (select x.comp_code,x.unit_code,x.agcd,x.dpcd,x.publ_code publ,x.edtn_code edtn,x.supply_date,x.supply_rate copy_rate from cir_bill_print x
            where x.comp_code=@pcomp_code and x.unit_code=@punit_code and x.supply_date>= @v_start_date  and x.supply_date<=@v_bill_todt and 
            x.agcd=isnull(@pbillagcd,x.agcd) and x.dpcd=isnull(@pbilldpcd,x.dpcd) and x.supply_copy>0 and x.cur_sessionid=@@spid) ) u
				
		print('*')
		OPEN cur_not_supply 	
		fetch NEXT FROM cur_not_supply INTO @rec_not_supply_comp_code,@rec_not_supply_unit_code,@rec_not_supply_agcd,@rec_not_supply_dpcd,@rec_not_supply_publ,@rec_not_supply_edtn,@rec_not_supply_supply_date ,@rec_not_supply_copy_rate
		WHILE (@@FETCH_STATUS = 0) 
		BEGIN
			print('**')
				set @v_cur_agcd  =@rec_not_supply_agcd+@rec_not_supply_dpcd;
				if @v_prev_agcd<>@v_cur_agcd begin--XX & A0002
					set @v_prev_agcd =@v_cur_agcd;
				
						select @vbill_no=max(cast(billno as numeric)) from cir_bill_print 
						where comp_code=@pcomp_code and unit_code=@punit_code and supply_date>= @v_start_date 
						and supply_date<=@v_bill_todt and agcd=isnull(@pbillagcd,agcd) and dpcd=isnull(@pbilldpcd,dpcd) 
						and cur_sessionid=@@spid
					
						if cast(@vbill_no as numeric)=0 begin print('***')
							select @vbill_no=max(cast(billno as numeric)) from cir_bill_print 
							where comp_code=@pcomp_code and unit_code=@punit_code and 
							supply_date>= @v_start_date and supply_date<=@v_bill_todt and 
								cur_sessionid=@@spid
						end

				end
			
				select @v_return_copy=sum(isnull(apr_late_recpt,0)+isnull(apr_short_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)),@v_return_amt=sum(isnull(copy_amt,0)-isnull(waste_amt,0))
				from cir_unsold_dtl
				where comp_code=@rec_not_supply_comp_code and unit_code=@rec_not_supply_unit_code and doctype='UCN' and
					agcd=@rec_not_supply_agcd and dpcd=@rec_not_supply_dpcd and app_dt=@rec_not_supply_supply_date and 
					publ=@rec_not_supply_publ and edtn=@rec_not_supply_edtn and copy_rate=@rec_not_supply_copy_rate and
					(isnull(apr_late_recpt,0)+isnull(apr_short_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))>0;
                            
				select @v_rec_amt=abs(sum(amount))  from cir_rcphdr 
					where comp_code=@rec_not_supply_comp_code and unit_code=@rec_not_supply_unit_code and
						doctype='RCR' and recptdt = @rec_not_supply_supply_date and
						agcd=@rec_not_supply_agcd and dpcd=@rec_not_supply_dpcd and achd='NM';
                        
				select @v_rcp_count=count(*) from cir_bill_return_print
					where cur_sessionid=@@spid and comp_code=@rec_not_supply_comp_code and unit_code=@rec_not_supply_unit_code and 
						receipt_date=@rec_not_supply_supply_date and agcd=@rec_not_supply_agcd and dpcd=@rec_not_supply_dpcd;
				print('****')
				print(@v_rcp_count)
				if isnull(@v_rcp_count,0)>0 begin
					set @v_rec_amt=0; 
				end
				else
				begin print('*****')
					insert into cir_bill_return_print(comp_code,unit_code,agcd,dpcd,receipt_date,sur_amt)
					values(@rec_not_supply_comp_code,@rec_not_supply_unit_code,@rec_not_supply_agcd,@rec_not_supply_dpcd,@rec_not_supply_supply_date,@v_rec_amt);
				end
                  print('******')      
				insert into cir_bill_print(comp_code,unit_code,billno,billdt,publ_code,edtn_code,agcd,dpcd,
										supply_date,supply_copy,supply_rate,gross_amt,comm_rate,comm_amt,sur_rate,sur_amt,
										return_copy,return_amt,cur_sessionid,rec_amt)
						  values(@rec_not_supply_comp_code,@rec_not_supply_unit_code,@vbill_no,@v_bill_todt,@rec_not_supply_publ,@rec_not_supply_edtn,@rec_not_supply_agcd,@rec_not_supply_dpcd,
										@rec_not_supply_supply_date,0,@rec_not_supply_copy_rate,0,0,0,0,0,
										@v_return_copy,@v_return_amt,@@spid,@v_rec_amt);
                             
				set @v_return_copy=0;
				set @v_return_amt=0
				set @v_rcp_count=0
				set @v_rec_amt=0;
	
		fetch NEXT FROM cur_not_supply INTO @rec_not_supply_comp_code,@rec_not_supply_unit_code,@rec_not_supply_agcd,@rec_not_supply_dpcd,@rec_not_supply_publ,@rec_not_supply_edtn,@rec_not_supply_supply_date ,@rec_not_supply_copy_rate
        END 		
	close cur_not_supply
	DEALLOCATE cur_not_supply
	
print('@')	
	DECLARE cur_bill cursor LOCAL FOR
				select distinct x.comp_code,x.unit_code,x.agcd ,x.dpcd ,b.ag_name ,b.ag_name_oth_lang ,
        b.city_code ,b.country_code ,b.state_code ,b.dist_code ,b.tehsil_taluka ,
        sum(x.supply_copy) ,sum(x.gross_amount) ,sum(x.sur_amount) ,sum(x.comm_amount) ,
        sum(x.bill_sec_amt)  from
        (select distinct a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,
        sum(a.supply_copy) supply_copy,sum(a.gross_amt) gross_amount,sum(a.sur_amt) sur_amount,sum(a.comm_amt) comm_amount,
        sum(a.sec_amt) bill_sec_amt from cir_bill_print a
            where a.comp_code=@pcomp_code and a.unit_code=isnull(@punit_code,a.unit_code) and
                  a.supply_date >= @v_bill_frdt and a.supply_date<=@v_bill_todt and 
                  a.agcd=isnull(@pbillagcd,a.agcd) and a.dpcd=isnull(@pbilldpcd,a.dpcd) and
                  a.publ_code=isnull(@ppubl,a.publ_code) and a.cur_sessionid=@@spid
                  group by a.comp_code,a.unit_code,a.agcd,a.dpcd
        union all
        select distinct a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,
        0 supply_copy,0 gross_amount,0 sur_amount,0 comm_amount,0 bill_sec_amt from cir_bill_print a
            where a.comp_code=@pcomp_code and a.unit_code=isnull(@punit_code,a.unit_code) and
                  a.supply_date >= @v_start_date and a.supply_date<@v_bill_frdt and 
                  a.agcd=isnull(@pbillagcd,a.agcd) and a.dpcd=isnull(@pbilldpcd,a.dpcd) and
                  a.cur_sessionid=@@spid and a.publ_code=isnull(@ppubl,a.publ_code)) x,cir_agmast b
                  where x.comp_code=b.comp_code and x.unit_code=b.unit and x.agcd=b.agcd and x.dpcd=b.dpcd
                  group by x.comp_code,x.unit_code,x.agcd,x.dpcd,b.ag_name,b.ag_name_oth_lang,
                  b.city_code,b.country_code,b.state_code,b.dist_code,b.tehsil_taluka
                  order by x.comp_code,x.unit_code,x.agcd,x.dpcd 
	
	OPEN cur_bill---main cursor bill	
		fetch NEXT FROM cur_bill INTO @cur_bill_comp_code,@cur_bill_unit_code,@cur_bill_agcd,@cur_bill_dpcd,@cur_bill_ag_name,@cur_bill_ag_name_oth_lang,@cur_bill_city_code,@cur_bill_country_code,@cur_bill_state_code,@cur_bill_dist_code,@cur_bill_taluka_code,@cur_bill_supply_copy,@cur_bill_gross_amount,@cur_bill_sur_amount,@cur_bill_comm_amount,@cur_bill_bill_sec_amt
		WHILE (@@FETCH_STATUS = 0) BEGIN			
		
		select @v_ret_copy=sum(u.tot_return),@v_ret_gross=sum(u.gross_amt),@v_ret_comm=sum(u.comm_amt) from
            (select sum(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)) tot_return,
            isnull(sum(copy_amt),0) gross_amt,
            sum((isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))*isnull(copy_rate,0))-isnull(sum(copy_amt),0) comm_amt  
            from cir_unsold_dtl 
            where comp_code=@cur_bill_comp_code and unit_code=@cur_bill_unit_code and 
                doctype='UCN' and agcd=@cur_bill_agcd and dpcd=@cur_bill_dpcd and app_dt >= @v_bill_frdt and app_dt<=@v_bill_todt and process_crno is null/*and publ=v1.publ*/
            union
            select sum(isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0)) tot_return,
            isnull(sum(copy_amt),0) gross_amt,
            sum((isnull(apr_short_recpt,0)+isnull(apr_late_recpt,0)+isnull(apr_bnr,0)+isnull(apr_unsold,0))*isnull(copy_rate,0))-isnull(sum(copy_amt),0) comm_amt 
            from cir_unsold_dtl 
            where comp_code=@cur_bill_comp_code and unit_code=@cur_bill_unit_code and 
                doctype='UCN' and agcd=@cur_bill_agcd and dpcd=@cur_bill_dpcd and app_dt >= @v_bill_frdt and app_dt<=@v_bill_todt and 
                process_crno is not null /*and publ=v1.publ*/) u;
                
            set @v_prev_bal  =dbo.cir_accounts_cir_agency_opbal(@cur_bill_comp_code,@cur_bill_unit_code,'',@cur_bill_agcd,@cur_bill_dpcd,@v_opdate,'NM',@pdateformat,@pextra1,@pextra2)
            set @v_sec_bal   =dbo.cir_accounts_cir_agency_opbal(@cur_bill_comp_code,@cur_bill_unit_code,'',@cur_bill_agcd,@cur_bill_dpcd,@v_opdate,'SC',@pdateformat,@pextra1,@pextra2);

            select @v_rec_amt=sum(x.amount) from
            (
            select sum(amount) amount  from cir_outmast
            where comp_code=@cur_bill_comp_code and unit_code=@cur_bill_unit_code and
            achd='NM' and doctyp='BIL' and billdt>=@v_opdate and billdt<@v_bill_frdt 
            and agcd=@cur_bill_agcd and dpcd=@cur_bill_dpcd
            union all
            select sum(amount) amount from cir_outmast
            where comp_code=@cur_bill_comp_code and unit_code=@cur_bill_unit_code and
            achd='NM' and doctyp <>'BIL' and recptdt>=@v_opdate and recptdt<@v_start_date 
            and agcd=@cur_bill_agcd and dpcd=@cur_bill_dpcd
            union all
            select sum(amount) amount from cir_outmast
            where comp_code=@cur_bill_comp_code and unit_code=@cur_bill_unit_code and
            achd='NM' and doctyp<>'UCN' and recptdt>=@v_start_date and recptdt<@v_bill_frdt 
            and agcd=@cur_bill_agcd and dpcd=@cur_bill_dpcd
            ) x
            
            set @v_prev_bal  =isnull(@v_prev_bal,0)+isnull(@v_rec_amt,0);
            
            set @v_rec_amt=0;
            
            select @v_rec_amt=sum(amount)  from cir_rcphdr where comp_code=@cur_bill_comp_code 
            and unit_code=@cur_bill_unit_code and agcd=@cur_bill_agcd and dpcd=@cur_bill_dpcd 
            and recptdt>=@v_opdate and recptdt<=@v_bill_todt and achd='SC' ;
            
            set @v_sec_bal   =isnull(@v_sec_bal,0)+isnull(@v_rec_amt,0);

            select @v_pbillret=sum(isnull(gross_amt,0)-isnull(comm_amt,0)+isnull(sur_amt,0)-isnull(return_amt,0)),@v_psecamt=abs(sum(sec_amt)) 
            from cir_bill_print
                where comp_code=@cur_bill_comp_code and unit_code=@cur_bill_unit_code 
                and supply_date>=@v_start_date and supply_date<@v_bill_frdt and  
                agcd=@cur_bill_agcd and dpcd=@cur_bill_dpcd and cur_sessionid=@@spid
                            
            select @v_csecamt=abs(sum(sec_amt))  from cir_bill_print
                where comp_code=@cur_bill_comp_code and unit_code=@cur_bill_unit_code 
                and supply_date >= @v_bill_frdt and supply_date<=@v_bill_todt and 
                agcd=@cur_bill_agcd and dpcd=@cur_bill_dpcd and cur_sessionid=@@spid
                
            if isnull(@v_bill_exist,0)=0 begin
                set @v_sec_bal   =isnull(@v_sec_bal,0)-isnull(@v_psecamt,0)-isnull(@v_csecamt,0);
            end
            else
            begin
                set @v_sec_bal   =isnull(@v_sec_bal,0)+isnull(@v_psecamt,0);
            end
            
            set @v_prev_bal      =isnull(@v_prev_bal,0)+isnull(@v_pbillret,0)+isnull(@v_psecamt,0);
                        
            set @v_rec_amt=0;
            set @v_pbillret=0
            set @v_csecamt=0
            set @v_psecamt=0;
		
			DECLARE cur_type cursor LOCAL FOR
				select doctyp,sum(amount) amount from cir_outmast
            where comp_code=@cur_bill_comp_code and unit_code=@cur_bill_unit_code and
                achd='NM' and doctyp not in('BIL','UCN') and recptdt>=@v_bill_frdt and recptdt<=@v_bill_todt and 
                agcd=@cur_bill_agcd and dpcd=@cur_bill_dpcd group by doctyp
		
		
			OPEN cur_type---main cursor bill	
			fetch NEXT FROM cur_type INTO @v2_doctyp ,@v2_amount
			WHILE (@@FETCH_STATUS = 0) BEGIN
				select @v_dsign=dsign from cir_docmst 
				where comp_code=@cur_bill_comp_code and doc_type=@v2_doctyp;
				if @v_dsign is null or @v_dsign =0 begin
					set @v_dsign=1
				end
				if @v_dsign>0 begin
                    if @v_bill_exist=0 begin
                        set @v_dn_amt=isnull(@v_dn_amt,0)+isnull(@v2_amount,0)+isnull(@v_csecamt,0);
                    end
                    else
                    begin
                        set @v_dn_amt=isnull(@v_dn_amt,0)+isnull(@v2_amount,0);
                    end
                end
                else
                begin
                    if @v2_doctyp='RCR' begin
                        set @v_rec_amt=isnull(@v_rec_amt,0)+isnull(@v2_amount,0);
                    end
                    else
                    begin
                        set @v_cn_amt=isnull(@v_cn_amt,0)+isnull(@v2_amount,0);
                    end
                end
			
			fetch NEXT FROM cur_type INTO @v2_doctyp ,@v2_amount
			END 		
		close cur_type
		DEALLOCATE cur_type	
		
			set @v_state_name    =dbo.cir_get_state(@cur_bill_comp_code,@cur_bill_country_code,@cur_bill_state_code);
            if @repty='S' begin
                print('*')
            end
            else
            begin
                set @v_dist_name     =dbo.cir_get_name_cir_district(@cur_bill_comp_code,@cur_bill_dist_code,'1','','','');
                if @repty='D' begin
                    print('*');    
                end       
                else if @repty='C' begin
                    set @v_city_name     =dbo.cir_get_city(@cur_bill_comp_code,@cur_bill_city_code);
                end
                else
                begin
                    
                        set @v_taluka_name   =dbo.cir_get_name_cir_taluka(@cur_bill_comp_code,@cur_bill_taluka_code,'1','','','');
						if @v_taluka_name is null or @v_taluka_name ='' begin
							set @v_taluka_name   ='N/A';
                        end
                    
                end
            end
			
			insert into #cir_temp_bill_collection(comp_code,unit_code,billno,billdt,publ_code,agcd,dpcd, 
            supply_copy, gross_amt, comm_amt, sur_amt, return_copy, return_amt,ret_comm_amt, dn_amt, rec_amt, prev_bal,cn_amt,cur_sessionid,        
            agname, agname_oth_lang, city_code, taluka_code, dist_code, state_code, remarks,bill_sec_amt,sec_opbal)
               values(@cur_bill_comp_code,  @cur_bill_unit_code  , null   ,null  , ''    ,@cur_bill_agcd,@cur_bill_dpcd,
            @cur_bill_supply_copy,@cur_bill_gross_amount,isnull(@cur_bill_comm_amount,0),@cur_bill_sur_amount,@v_ret_copy,@v_ret_gross,@v_ret_comm,
            @v_dn_amt,@v_rec_amt,@v_prev_bal,@v_cn_amt,@@spid,
            @cur_bill_ag_name,@cur_bill_ag_name_oth_lang,@v_city_name,@v_taluka_name,@v_dist_name,@v_state_name,@cur_bill_country_code,@cur_bill_bill_sec_amt,@v_sec_bal);
    
            set @v_dsign=0
            set @v_ret_gross=0
            set @v_ret_comm=0
            set @v_ret_copy=0
            set @v_dn_amt=0
            set @v_cn_amt=0
            set @v_rec_amt=0
            set @v_prev_bal=0
            set @v_sec_bal=0
            set @v_state_name    =null
            set @v_dist_name     =null
            set @v_taluka_name   =null
            set @v_city_name=null
			
	
	fetch NEXT FROM cur_bill INTO @cur_bill_comp_code,@cur_bill_unit_code,@cur_bill_agcd,@cur_bill_dpcd,@cur_bill_ag_name,@cur_bill_ag_name_oth_lang,@cur_bill_city_code,@cur_bill_country_code,@cur_bill_state_code,@cur_bill_dist_code,@cur_bill_taluka_code,@cur_bill_supply_copy,@cur_bill_gross_amount,@cur_bill_sur_amount,@cur_bill_comm_amount,@cur_bill_bill_sec_amt
    END 		
close cur_bill
DEALLOCATE cur_bill


if @repty='S' begin
            
            select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname ag_name,a.agname_oth_lang ag_name_oth_lang,
            a.state_code state_name,
            sum(isnull(a.gross_amt,0)+isnull(a.sur_amt,0)) bill_amt,sum(a.comm_amt) comm_amt,sum((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))) net_bill,
            sum(isnull(a.return_amt,0)+isnull(ret_comm_amt,0)) return_amt,sum(isnull(a.return_amt,0)) net_return_amt,
            sum((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))-isnull(a.return_amt,0)) total_bill,abs(sum(isnull(a.bill_sec_amt,0))) dep_adj, 
            sum((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))-isnull(a.return_amt,0)+isnull(a.bill_sec_amt,0)) total_net,
            sum(a.prev_bal) prev_bal, abs(sum(a.rec_amt)) rec_amt,sum(isnull(a.dn_amt,0)) dn_amt, sum(a.cn_amt) cn_amt,sum(isnull(a.dn_amt,0)+isnull(a.cn_amt,0)) dr_cr_amt,
            sum(((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))-isnull(a.return_amt,0)+isnull(a.prev_bal,0)+isnull(a.rec_amt,0)+isnull(a.dn_amt,0)+isnull(a.cn_amt,0)+isnull(a.bill_sec_amt,0))) net_bal,
            abs(sum(isnull(a.sec_opbal,0))) deposit_balance
            from #cir_temp_bill_collection a
            where cur_sessionid=@@spid
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.remarks,a.state_code
            order by comp_code,unit_code,state_name,ag_name;

            
            select a.comp_code comp_code,a.unit_code unit_code,a.state_code state_name,
            sum(isnull(a.gross_amt,0)+isnull(a.sur_amt,0)) bill_amt,sum(a.comm_amt) comm_amt,sum((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))) net_bill,
            sum(isnull(a.return_amt,0)+isnull(ret_comm_amt,0)) return_amt,sum(isnull(a.return_amt,0)) net_return_amt,
            sum((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))-isnull(a.return_amt,0)) total_bill,abs(sum(isnull(a.bill_sec_amt,0))) dep_adj, 
            sum((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))-isnull(a.return_amt,0)+isnull(a.bill_sec_amt,0)) total_net,
            sum(a.prev_bal) prev_bal, abs(sum(a.rec_amt)) rec_amt,sum(isnull(a.dn_amt,0)) dn_amt, sum(a.cn_amt) cn_amt,sum(isnull(a.dn_amt,0)+isnull(a.cn_amt,0)) dr_cr_amt,
            sum(((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))-isnull(a.return_amt,0)+isnull(a.prev_bal,0)+isnull(a.rec_amt,0)+isnull(a.dn_amt,0)+isnull(a.cn_amt,0)+isnull(a.bill_sec_amt,0))) net_bal,
            abs(sum(isnull(a.sec_opbal,0))) deposit_balance
            from #cir_temp_bill_collection a
            where cur_sessionid=@@spid
            group by a.comp_code,a.unit_code,a.remarks,a.state_code
            order by comp_code,unit_code,state_name; 
        end           
        else if @repty='D' begin
            
            select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname ag_name,a.agname_oth_lang ag_name_oth_lang,
            a.state_code state_name,a.dist_code district_name,
            sum(isnull(a.gross_amt,0)+isnull(a.sur_amt,0)) bill_amt,sum(a.comm_amt) comm_amt,sum((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))) net_bill,
            sum(isnull(a.return_amt,0)+isnull(ret_comm_amt,0)) return_amt,sum(isnull(a.return_amt,0)) net_return_amt,
            sum((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))-isnull(a.return_amt,0)) total_bill,abs(sum(isnull(a.bill_sec_amt,0))) dep_adj, 
            sum((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))-isnull(a.return_amt,0)+isnull(a.bill_sec_amt,0)) total_net,
            sum(a.prev_bal) prev_bal, abs(sum(a.rec_amt)) rec_amt,sum(isnull(a.dn_amt,0)) dn_amt, sum(a.cn_amt) cn_amt,sum(isnull(a.dn_amt,0)+isnull(a.cn_amt,0)) dr_cr_amt,
            sum(((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))-isnull(a.return_amt,0)+isnull(a.prev_bal,0)+isnull(a.rec_amt,0)+isnull(a.dn_amt,0)+isnull(a.cn_amt,0)+isnull(a.bill_sec_amt,0))) net_bal,
            abs(sum(isnull(a.sec_opbal,0))) deposit_balance
            from #cir_temp_bill_collection a
            where cur_sessionid=@@spid
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.remarks,a.state_code,a.dist_code
            order by comp_code,unit_code,district_name,ag_name;     

            
            select a.comp_code comp_code,a.unit_code unit_code,a.dist_code district_name,a.state_code state_name,
            sum(isnull(a.gross_amt,0)+isnull(a.sur_amt,0)) bill_amt,sum(a.comm_amt) comm_amt,sum((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))) net_bill,
            sum(isnull(a.return_amt,0)+isnull(ret_comm_amt,0)) return_amt,sum(isnull(a.return_amt,0)) net_return_amt,
            sum((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))-isnull(a.return_amt,0)) total_bill,abs(sum(isnull(a.bill_sec_amt,0))) dep_adj, 
            sum((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))-isnull(a.return_amt,0)+isnull(a.bill_sec_amt,0)) total_net,
            sum(a.prev_bal) prev_bal, abs(sum(a.rec_amt)) rec_amt,sum(isnull(a.dn_amt,0)) dn_amt, sum(a.cn_amt) cn_amt,sum(isnull(a.dn_amt,0)+isnull(a.cn_amt,0)) dr_cr_amt,
            sum(((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))-isnull(a.return_amt,0)+isnull(a.prev_bal,0)+isnull(a.rec_amt,0)+isnull(a.dn_amt,0)+isnull(a.cn_amt,0)+isnull(a.bill_sec_amt,0))) net_bal,
            abs(sum(isnull(a.sec_opbal,0))) deposit_balance
            from #cir_temp_bill_collection a
            where cur_sessionid=@@spid
            group by a.comp_code,a.unit_code,a.remarks,a.state_code,a.dist_code
            order by comp_code,unit_code,state_name,district_name;
        end
        else if @repty='C' begin
            
            select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname ag_name,a.agname_oth_lang ag_name_oth_lang,
            a.state_code state_name,a.dist_code district_name,a.city_code city_name,
            sum(isnull(a.gross_amt,0)+isnull(a.sur_amt,0)) bill_amt,sum(a.comm_amt) comm_amt,sum((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))) net_bill,
            sum(isnull(a.return_amt,0)+isnull(ret_comm_amt,0)) return_amt,sum(isnull(a.return_amt,0)) net_return_amt,
            sum((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))-isnull(a.return_amt,0)) total_bill,abs(sum(isnull(a.bill_sec_amt,0))) dep_adj, 
            sum((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))-isnull(a.return_amt,0)+isnull(a.bill_sec_amt,0)) total_net,
            sum(a.prev_bal) prev_bal, abs(sum(a.rec_amt)) rec_amt,sum(isnull(a.dn_amt,0)) dn_amt, sum(a.cn_amt) cn_amt,sum(isnull(a.dn_amt,0)+isnull(a.cn_amt,0)) dr_cr_amt,
            sum(((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))-isnull(a.return_amt,0)+isnull(a.prev_bal,0)+isnull(a.rec_amt,0)+isnull(a.dn_amt,0)+isnull(a.cn_amt,0)+isnull(a.bill_sec_amt,0))) net_bal,
            abs(sum(isnull(a.sec_opbal,0))) deposit_balance
            from #cir_temp_bill_collection a
            where cur_sessionid=@@spid
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.remarks,a.state_code,a.dist_code,a.city_code
            order by comp_code,unit_code,city_name,ag_name;  
            
            
            select a.comp_code comp_code,a.unit_code unit_code,a.city_code city_name,
            a.dist_code district_name,a.state_code state_name,
            sum(isnull(a.gross_amt,0)+isnull(a.sur_amt,0)) bill_amt,sum(a.comm_amt) comm_amt,sum((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))) net_bill,
            sum(isnull(a.return_amt,0)+isnull(ret_comm_amt,0)) return_amt,sum(isnull(a.return_amt,0)) net_return_amt,
            sum((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))-isnull(a.return_amt,0)) total_bill,abs(sum(isnull(a.bill_sec_amt,0))) dep_adj, 
            sum((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))-isnull(a.return_amt,0)+isnull(a.bill_sec_amt,0)) total_net,
            sum(a.prev_bal) prev_bal, abs(sum(a.rec_amt)) rec_amt,sum(isnull(a.dn_amt,0)) dn_amt, sum(a.cn_amt) cn_amt,sum(isnull(a.dn_amt,0)+isnull(a.cn_amt,0)) dr_cr_amt,
            sum(((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))-isnull(a.return_amt,0)+isnull(a.prev_bal,0)+isnull(a.rec_amt,0)+isnull(a.dn_amt,0)+isnull(a.cn_amt,0)+isnull(a.bill_sec_amt,0))) net_bal,
            abs(sum(isnull(a.sec_opbal,0))) deposit_balance
            from #cir_temp_bill_collection a
            where cur_sessionid=@@spid
            group by a.comp_code,a.unit_code,a.city_code,a.dist_code,a.remarks,a.state_code
            order by comp_code,unit_code,state_name,district_name,city_name;
		end
        else
        begin
            
            select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname ag_name,a.agname_oth_lang ag_name_oth_lang,
            a.state_code state_name,a.dist_code district_name,
            a.taluka_code+'('+a.dist_code+')' taluka_name,
            sum(isnull(a.gross_amt,0)+isnull(a.sur_amt,0)) bill_amt,sum(a.comm_amt) comm_amt,sum((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))) net_bill,
            sum(isnull(a.return_amt,0)+isnull(ret_comm_amt,0)) return_amt,sum(isnull(a.return_amt,0)) net_return_amt,
            sum((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))-isnull(a.return_amt,0)) total_bill,abs(sum(isnull(a.bill_sec_amt,0))) dep_adj, 
            sum((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))-isnull(a.return_amt,0)+isnull(a.bill_sec_amt,0)) total_net,
            sum(a.prev_bal) prev_bal, abs(sum(a.rec_amt)) rec_amt,sum(isnull(a.dn_amt,0)) dn_amt, sum(a.cn_amt) cn_amt,sum(isnull(a.dn_amt,0)+isnull(a.cn_amt,0)) dr_cr_amt,
            sum(((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))-isnull(a.return_amt,0)+isnull(a.prev_bal,0)+isnull(a.rec_amt,0)+isnull(a.dn_amt,0)+isnull(a.cn_amt,0)+isnull(a.bill_sec_amt,0))) net_bal,
            abs(sum(isnull(a.sec_opbal,0))) deposit_balance
            from #cir_temp_bill_collection a
            where cur_sessionid=@@spid
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.taluka_code,a.dist_code,a.remarks,a.state_code
            order by comp_code,unit_code,state_name,district_name,taluka_name,ag_name;   

            
            select a.comp_code comp_code,a.unit_code unit_code,a.state_code state_name,a.dist_code district_name,
            a.taluka_code+'('+a.dist_code+')' taluka_name,
            sum(isnull(a.gross_amt,0)+isnull(a.sur_amt,0)) bill_amt,sum(a.comm_amt) comm_amt,sum((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))) net_bill,
            sum(isnull(a.return_amt,0)+isnull(ret_comm_amt,0)) return_amt,sum(isnull(a.return_amt,0)) net_return_amt,
            sum((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))-isnull(a.return_amt,0)) total_bill,abs(sum(isnull(a.bill_sec_amt,0))) dep_adj, 
            sum((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))-isnull(a.return_amt,0)+isnull(a.bill_sec_amt,0)) total_net,
            sum(a.prev_bal) prev_bal, abs(sum(a.rec_amt)) rec_amt,sum(isnull(a.dn_amt,0)) dn_amt, sum(a.cn_amt) cn_amt,sum(isnull(a.dn_amt,0)+isnull(a.cn_amt,0)) dr_cr_amt,
            sum(((isnull(a.gross_amt,0)+isnull(a.sur_amt,0)-isnull(a.comm_amt,0))-isnull(a.return_amt,0)+isnull(a.prev_bal,0)+isnull(a.rec_amt,0)+isnull(a.dn_amt,0)+isnull(a.cn_amt,0)+isnull(a.bill_sec_amt,0))) net_bal,
            abs(sum(isnull(a.sec_opbal,0))) deposit_balance
            from #cir_temp_bill_collection a
            where cur_sessionid=@@spid
            group by a.comp_code,a.unit_code,a.taluka_code,a.dist_code,a.remarks,a.state_code
            order by comp_code,unit_code,state_name,district_name,taluka_name;            
        end
        
        drop table #cir_temp_bill_collection
        drop table #cir_temp_outstanding;
        delete from cir_bill_print where cur_sessionid=@@spid
        delete from cir_bill_return_print where cur_sessionid=@@spid
         
end

//----------------------------------end---------------------------------------------------------------------------

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[cir_aglisting_commcat]
@pcomp_code       as varchar(200),
@punit            as varchar(200),
@pbranch_code     as varchar(200),
@pagcd            as varchar(200),
@pdpcd            as varchar(200),
@pag_type         as varchar(200),
@pag_class        as varchar(200),
@pcomm_code       as varchar(200),
@pextra1          as varchar(200),
@pextra2          as varchar(200)

AS 
	
select x.comm_catg_desc,max(x.comm_catg_desc),sum(x.upline)main ,sum(x.sub) sub,sum(isnull(x.upline,0))+sum(isnull(x.sub,0)) total from(
select  c.comm_catg_desc,count(*) "UPLINE",null "SUB"  from cir_supply a,cir_agmast b,cir_comm_catg_mast c
  where a.comp_code=@pcomp_code
  and a.comp_code=b.comp_code
  and a.comp_code=c.comp_code
  and (a.unit=@punit or @punit is null or @punit ='')
  and a.unit=b.unit
  and (b.branch_code=@pbranch_code or @pbranch_code is null  or @pbranch_code ='')
  and a.agcd=b.agcd and a.dpcd=b.dpcd and a.dpcd='0001'
  and (a.agcd=@pagcd or @pagcd is null or @pagcd ='')
  and (a.dpcd=@pdpcd or @pdpcd is null or @pdpcd='')
  and (b.ag_type=@pag_type or @pag_type is null or @pag_type ='')
  and (b.ag_class=@pag_class or @pag_class is null or @pag_class ='')
  and (a.comm_code=@pcomm_code or @pcomm_code is null or @pcomm_code ='')
  and a.comm_code=c.comm_catg_code
  group by c.comm_catg_desc
union all
select c.comm_catg_desc,null "UPLINE",count(*) "SUB"   from cir_supply a,cir_agmast b,cir_comm_catg_mast c
  where a.comp_code=@pcomp_code
  and a.comp_code=b.comp_code
  and a.comp_code=c.comp_code
  and (a.unit=@punit or @punit is null or @punit ='')
  and a.unit=b.unit
  and (b.branch_code=@pbranch_code or @pbranch_code is null or @pbranch_code ='')
  and a.agcd=b.agcd and a.dpcd=b.dpcd and a.dpcd!='0001'
  and (a.agcd=@pagcd or @pagcd is null or @pagcd ='')
  and (a.dpcd=@pdpcd or @pdpcd is null or @pdpcd ='')
  and (b.ag_type=@pag_type or @pag_type is null or @pag_type ='')
  and (b.ag_class=@pag_class or @pag_class is null or @pag_class ='')
  and (a.comm_code=@pcomm_code or @pcomm_code is null or @pcomm_code ='')
  and a.comm_code=c.comm_catg_code
  group by c.comm_catg_desc) x
  group by x.comm_catg_desc order by X.comm_catg_desc;






////////////////////////////////////////////


///////////////////////////////////// deepika 30/03/2012 sent by Ashok sahani sir///////////////////////////////////////////////

                                                                     
                                                                     
                                                                     
                                             

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
@pextra2            as varchar(200),
@pextra3            as varchar(200),----this is use to final and unfinal po
@pextra4            as varchar(200),---for  zone,
@pextra5            as varchar(200),---for region
@pextra6            as varchar(200),---for district
@pextra7            as varchar(200),---fortaluka
@pextra8            as varchar(200),-----report type filter
@pextra9            as varchar(200),
@pextra10           as varchar(200)

AS

declare @vfrom_supdate    varchar(20);
declare @vtill_supdate    varchar(20);


IF(@ppubl=NULL)

SET @ppubl=''

declare @rec_sup_type as varchar(200) 
declare @rec_sup_type_sum as varchar(200) 
DECLARE cur_sup_type CURSOR READ_ONLY FOR
	select /*'sum(COALESCE(sup_type_code,'+'''+sup_ty_code+'''+',sup_copy,0)) '+sup_ty_name+',@rec_sup_type=' vty,*/
	 
	 ' sum(case sup_type_code when '+''''+sup_ty_code+''''+' then sup_copy else 0 end ) "'+sup_ty_name+'",' vty,
	
	'sum(case sup_type_code when '+''''+sup_ty_code+''''+' then sup_copy else 0 end ) +' vty_sum
	from cir_supply_type_mast where comp_code=@pcomp_code

     declare @vvar varchar(4000)
     declare @vvar_sum varchar(4000)
     declare @vquery varchar(4000)
     declare @vquery1 varchar(4000)
     declare @vquery2 varchar(4000)
     declare @vquery3 varchar(4000)
     declare @vquery4 varchar(4000)
     
     set @vvar=''
     set @vvar_sum=''
 
 
	open cur_sup_type  
		fetch next from cur_sup_type into @rec_sup_type ,@rec_sup_type_sum  
		WHILE @@FETCH_STATUS = 0 Begin 	
      		set @vvar=@vvar+@rec_sup_type          		
      		set  @vvar_sum=@vvar_sum+@rec_sup_type_sum
      		
      	fetch next from cur_sup_type into @rec_sup_type ,@rec_sup_type_sum   
		end
    close cur_sup_type
	DEALLOCATE cur_sup_type


	print('sum')
	print(@vvar_sum)


set @vfrom_supdate=convert(varchar(20),@pfrom_supdate,101)
set @vtill_supdate=convert(varchar(20),@ptill_supdate,101)

print('@vfrom_supdate ')print(@vfrom_supdate)
print('@vtill_supdate ')print(@vtill_supdate)
set @vvar    =substring(@vvar,1,len(@vvar)-1)
set @vvar_sum=substring(@vvar_sum,1,len(@vvar_sum)-1)
   
if @pextra8='1' begin----for route 
	set @vquery='select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,dbo.cir_get_publ_name(d.comp_code,d.publ) publ_name,
d.route_code route_code,dbo.cir_get_route_name(d.comp_code,d.unit_code,d.route_code) route_name,
 '+@vvar+' ,'+@vvar_sum+' TOTAL 
from cir_dbksup d,cir_agmast m where m.comp_code=d.comp_code
and d.comp_code='+ ''''+@pcomp_code+''''+'
and m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
and (d.publ='''+@ppubl+'''  or '''+@ppubl+''' ='''')
and d.supdate between '''+@vfrom_supdate+''' and '''+ @vtill_supdate+'''
and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''  ='''') 
And (d.edtn='''+@pedtn+''' or '''+@pedtn+''' ='''') 
and m.agcd=d.agcd and m.dpcd=d.dpcd 
and (route_code='''+@proute+''' or '''+@proute+''' = '''') and
(m.branch_code='''+@pextra1+''' or '''+@pextra1+''' ='''') and
d.edtn in(select distinct edtn from cir_edtn_mast 
where comp_code=d.comp_code and edtn = d.edtn 
and (main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' =''''))
group by d.comp_code,d.unit_code,d.publ,d.route_code
order by d.comp_code,d.unit_code,d.publ,d.route_code';

;
end ------ route	
else if @pextra8='2' begin----for  branch
	set @vquery='select d.comp_code comp_code,d.unit_code unit_code,m.branch_code branch_code,m.branch_code branch_code,
dbo.AD_GET_BRANCHNAME (d.comp_code,m.branch_code) branch_name
, 
 '+@vvar+' ,'+@vvar_sum+' TOTAL 
from cir_dbksup d,cir_agmast m where m.comp_code=d.comp_code
and d.comp_code='+ ''''+@pcomp_code+''''+'
and m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
and (d.publ='''+@ppubl+'''  or '''+@ppubl+''' ='''')
and d.supdate between '''+@vfrom_supdate+''' and '''+ @vtill_supdate+'''
and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''  ='''') 
And (d.edtn='''+@pedtn+''' or '''+@pedtn+''' ='''') 
and m.agcd=d.agcd and m.dpcd=d.dpcd 
and (route_code='''+@proute+''' or '''+@proute+''' = '''') and
(m.branch_code='''+@pextra1+''' or '''+@pextra1+''' ='''') and

d.edtn in(select distinct edtn from cir_edtn_mast 
where comp_code=d.comp_code and edtn = d.edtn 
and (main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' =''''))

 group by d.comp_code,d.unit_code,m.branch_code
				order by d.comp_code,d.unit_code,m.branch_code';

end ---- branch		
else if @pextra8='3' begin----for  zone  
 
	set @vquery=' select d.comp_code comp_code,d.unit_code unit_code,

k.zone_code,k.zone_code,
dbo.cir_get_zone_name(d.comp_code,k.zone_code) zone_name
, 
 '+@vvar+' ,'+@vvar_sum+' TOTAL 
from cir_dbksup d,cir_agmast m,cir_city_mast k where m.comp_code=d.comp_code
and d.comp_code='+ ''''+@pcomp_code+''''+'
and m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
and (d.publ='''+@ppubl+'''  or '''+@ppubl+''' ='''')
and d.supdate between '''+@vfrom_supdate+''' and '''+ @vtill_supdate+'''
and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''  ='''') 
And (d.edtn='''+@pedtn+''' or '''+@pedtn+''' ='''') 
and m.agcd=d.agcd and m.dpcd=d.dpcd 
and (route_code='''+@proute+''' or '''+@proute+''' = '''') and
(m.branch_code='''+@pextra1+''' or '''+@pextra1+''' ='''') and
 (k.zone_code='''+@pextra4+''' or '''+@pextra4+''' ='''') and


d.edtn in(select distinct edtn from cir_edtn_mast 
where comp_code=d.comp_code and edtn = d.edtn 
and (main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' =''''))

 group by d.comp_code,d.unit_code,k.zone_code
order by d.comp_code,d.unit_code,k.zone_code';



     
end  ---- zone
else if @pextra8='4' begin----for  region   
	set @vquery='  select d.comp_code comp_code,d.unit_code unit_code,k.region_code,k.region_code
,dbo.cir_get_region_name(d.comp_code,k.region_code) 
region_name
,
 '+@vvar+' ,'+@vvar_sum+' TOTAL 
from cir_dbksup d,cir_agmast m,cir_city_mast k where m.comp_code=d.comp_code
and d.comp_code='+ ''''+@pcomp_code+''''+'
and m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
and (d.publ='''+@ppubl+'''  or '''+@ppubl+''' ='''')
and d.supdate between '''+@vfrom_supdate+''' and '''+ @vtill_supdate+'''
and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''  ='''') 
And (d.edtn='''+@pedtn+''' or '''+@pedtn+''' ='''') 
and m.agcd=d.agcd and m.dpcd=d.dpcd 
and (route_code='''+@proute+''' or '''+@proute+''' = '''') and
(m.branch_code='''+@pextra1+''' or '''+@pextra1+''' ='''') and
 (k.region_code='''+@pextra5+''' or '''+@pextra5+''' ='''') and


d.edtn in(select distinct edtn from cir_edtn_mast 
where comp_code=d.comp_code and edtn = d.edtn 
and (main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' =''''))

group by d.comp_code,d.unit_code,k.region_code
				order by d.comp_code,d.unit_code,k.region_code';
end ---- end  region
else if @pextra8='5' begin----for  district





set @vquery='select d.comp_code comp_code,d.unit_code unit_code,m.dist_code dist_code,m.dist_code dist_code,dbo.cir_get_dist(d.comp_code,m.state_code,m.dist_code) district_name, '+@vvar+' ,'+@vvar_sum+' TOTAL 
from cir_dbksup d,cir_agmast m where m.comp_code=d.comp_code
and d.comp_code='+ ''''+@pcomp_code+''''+'
and m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
and (d.publ='''+@ppubl+'''  or '''+@ppubl+''' ='''')
and d.supdate between '''+@vfrom_supdate+''' and '''+ @vtill_supdate+'''
and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''  ='''') 
And (d.edtn='''+@pedtn+''' or '''+@pedtn+''' ='''') 
and m.agcd=d.agcd and m.dpcd=d.dpcd 
and (route_code='''+@proute+''' or '''+@proute+''' = '''') and
(m.branch_code='''+@pextra1+''' or '''+@pextra1+''' ='''') and
(m.dist_code='''+@pextra6+''' or '''+@pextra6+''' ='''') and
d.edtn in(select distinct edtn from cir_edtn_mast 
where comp_code=d.comp_code and edtn = d.edtn 
and (main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' =''''))

group by d.comp_code,d.unit_code,m.state_code,m.dist_code
order by d.comp_code,d.unit_code,m.state_code,m.dist_code	'



	/*
	set @vquery=' d.comp_code comp_code,d.unit_code unit_code,m.dist_code dist_code,cir_get_dist(d.comp_code,m.state_code,m.dist_code) district_name
, '+@vvar+','+@vvar_sum+' TOTAL 
	from cir_dbksup d,cir_agmast m where m.comp_code=d.comp_code and d.comp_code='+ 
                ''''+@pcomp_code+''''+' and m.unit=d.unit_code and d.unit_code='+''''+@punit_code+''''+
				' and (d.publ='+''''+@ppubl+''''+' or '+''''+@ppubl+''''+' is null) 
				and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' is null) and
				and (d.edtn='+''''+@pedtn+''''+' or '+''''+@pedtn+''''+' is null) 
				and m.agcd=d.agcd and m.dpcd=d.dpcd 
				and d.supdate between '''+cast(@pfrom_supdate as varchar)+''' and '''+cast(@ptill_supdate as varchar)+''' 
				and ((route_code='+''''+@proute+''''+') or ('+''''+@proute+''''+' is null)) and
				((d.branch_code='+''''+@pextra1+''''+') or ('+''''+@pextra1+''''+' is null)) and
				((m.dist_code='+''''+@pextra6+''''+') or ('+''''+@pextra6+''''+' is null)) and
               d.edtn in(select distinct edtn from cir_edtn_mast 
			   where comp_code=d.comp_code and edtn = d.edtn 
			   and (main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' is null))
                group by d.comp_code,d.unit_code,m.state_code,m.dist_code
				order by d.comp_code,d.unit_code,m.state_code,m.dist_code'     		 
				
				
	*/			
			

end  ---- district
else if @pextra8='6'----for  tehsil_taluka
begin
set @vquery='  select d.comp_code comp_code,d.unit_code unit_code,m.tehsil_taluka tehsil_taluka,m.tehsil_taluka tehsil_taluka,
dbo.cir_get_taluka(d.comp_code,m.tehsil_taluka) taluka_name
,
 '+@vvar+' ,'+@vvar_sum+' TOTAL 
from cir_dbksup d,cir_agmast m where m.comp_code=d.comp_code
and d.comp_code='+ ''''+@pcomp_code+''''+'
and m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
and (d.publ='''+@ppubl+'''  or '''+@ppubl+''' ='''')
and d.supdate between '''+@vfrom_supdate+''' and '''+ @vtill_supdate+'''
and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''  ='''') 
And (d.edtn='''+@pedtn+''' or '''+@pedtn+''' ='''') 
and m.agcd=d.agcd and m.dpcd=d.dpcd 
and (route_code='''+@proute+''' or '''+@proute+''' = '''') and
(m.branch_code='''+@pextra1+''' or '''+@pextra1+''' ='''') and
(m.tehsil_taluka='''+@pextra7+''' or '''+@pextra7+''' ='''') and
d.edtn in(select distinct edtn from cir_edtn_mast 
where comp_code=d.comp_code and edtn = d.edtn 
and (main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' =''''))

 group by d.comp_code,d.unit_code,m.tehsil_taluka
				order by d.comp_code,d.unit_code,m.tehsil_taluka';
end  ----for  tehsil_taluka



else
begin
set @vquery='
 select d.comp_code comp_code,d.unit_code unit_code,m.country_code country_code,
m.state_code state_code,dbo.cir_get_state(d.comp_code,m.country_code,m.state_code) state_name

 ,'+@vvar+' ,'+@vvar_sum+' TOTAL 
from cir_dbksup d,cir_agmast m where m.comp_code=d.comp_code
and d.comp_code='+ ''''+@pcomp_code+''''+'
and m.unit=d.unit_code and d.unit_code='''+@punit_code+''' 
and (d.publ='''+@ppubl+'''  or '''+@ppubl+''' ='''')
and d.supdate between '''+@vfrom_supdate+''' and '''+ @vtill_supdate+'''
and (d.final_supply_flag='''+@pextra3+''' or '''+@pextra3+'''  ='''') 
And (d.edtn='''+@pedtn+''' or '''+@pedtn+''' ='''') 
and m.agcd=d.agcd and m.dpcd=d.dpcd 
and (route_code='''+@proute+''' or '''+@proute+''' = '''') and
(m.branch_code='''+@pextra1+''' or '''+@pextra1+''' ='''') and
(m.state_code='''+@pextra9+''' or '''+@pextra9+''' ='''') and
d.edtn in(select distinct edtn from cir_edtn_mast 
where comp_code=d.comp_code and edtn = d.edtn 
and (main_edtn='+''''+@pmainedtn+''''+' or '+''''+@pmainedtn+''''+' =''''))
group by d.comp_code,d.unit_code,m.country_code,m.state_code
order by d.comp_code,d.unit_code,m.country_code,m.state_code';
end


print(@vquery)
exec(@vquery)


////////////////////////////////////////////////////end///////////////////////////////////////////////////////////////////
////////////////////insertion fee report
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER  procedure [dbo].[cir_insertion_fee_report_new]
(
		@pcomp_code        as varchar(50),
		@puserid           as varchar(50),
		@punit_code        as varchar(50),
		@pbranch           as varchar(50),
		@ppub_type         as varchar(50),
		@ppubl             as varchar(50),
		@pedition          as varchar(50),
		@psub_edition      as varchar(50),
		@pagency_class     as varchar(50),
		@pagency_type      as varchar(50),
		@pagency           as varchar(50),
		@proute            as varchar(50),
		@pfromdate       as varchar(50), 
        @ptilldate       as varchar(50),
		@pdateformate    as varchar(50)		
)

as 
declare @v_from_date   as  datetime;
declare  @v_till_date   as  datetime;


 set @v_from_date=(@pfromdate);
 set @v_till_date=(@ptilldate);

select s.comp_code comp_code,s.unit_code unit_code,s.publ_code publ_code,p.publ_name publ_name,e.main_edtn main_edtn,dbo.cir_get_edtn_name(s.comp_code,e.main_edtn) main_edtn_name,
s.edtn_code edtn,e.edtn_name edtn_name,s.supl_name_sun supl_name,max(s.valid_from) valid_from,max(s.valid_till) valid_till,s.insertion_fee,
d.agcd,d.dpcd,
dbo.cir_get_agency(s.comp_code,s.unit_code,d.agcd,d.dpcd) agency,sum(sup_copy) copy
from cir_publ_mast p,cir_edtn_mast e,cir_edtn_supl_mast s,cir_dbksup d
where p.comp_code=e.comp_code and s.comp_code=d.comp_code and  s.unit_code=d.unit_code and s.publ_code=d.publ 
and s.main_edtn=d.edtn 
and p.comp_code=s.comp_code and p.comp_code=@pcomp_code 
and p.publ=e.publ and p.publ=s.publ_code and (p.publ=@ppubl or @ppubl is null) and (s.unit_code=@punit_code or @punit_code is null) 
and e.edtn=s.edtn_code and @v_from_date between valid_from and valid_till  and 
@v_till_date between valid_from and valid_till
group by s.comp_code,s.unit_code,s.publ_code,p.publ_name,e.main_edtn,
s.edtn_code,e.edtn_name,s.supl_name_sun,s.insertion_fee,d.agcd,d.dpcd;


////////////////////////////////////////////////////////////////////

//////////////////issue number  7096
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

 ALTER Procedure [dbo].[cir_pcenter_detail_p]
     @pcompcode           VARCHAR(20),
     @ppcenter           VARCHAR(20),
     @plangtype           VARCHAR(20),  ---1 for enlish and 2 for other language
     @pdateformat         VARCHAR(20),
     @pextra1             VARCHAR(200),
     @pextra2            VARCHAR(200)


  As
  
       
	select TOP 1 *,(select pan_no from comp_mst x where x.comp_code= pub_cent_mast.comp_code and comp_code=@pcompcode) as "pan_no"
	from pub_cent_mast where /*"Comp_Code"=pcompcode  and*/
	(Pub_cent_Code=@ppcenter or @ppcenter is null or @ppcenter = '') 
	order by "Comp_Code";
        


 

///////////////////////////////////////

//----------------------------------start 04/04/2012 ritu-------------------------------//


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
                                             
ALTER procedure [dbo].[cir_edtnwise_rate_update](
    @pcompcode       as varchar(10),
    @punitcode       as varchar(10),
    @ppublcode       as varchar(10),
    @pedtncode       as varchar(10),
    @psupdate        as varchar(10),
    @psuprate        as numeric,
    @pactrate        as numeric,
    @puserid         as varchar(10),
    @pdateformat     as varchar(20),
    @pextra1         as varchar(20),
    @pextra2         as varchar(20),
    @pextra3         as varchar(20),
    @pextra4         as varchar(20),
    @pextra5         as varchar(20)    
    )
    as
Begin


    declare @v_sup_date          datetime;
    declare @v_cnt1              numeric(8);
    declare @v_cnt2              numeric(8);
    declare @v_rmrk              varchar(200);


    set @v_sup_date = @psupdate
   
    select @v_cnt1=count(*) from cir_bill_det where comp_code=@pcompcode and unit_code=@punitcode 
    and publ=@ppublcode and edtn=@pedtncode and @v_sup_date between fromdt and todt and copy_rate=@psuprate;
   
    if isnull(@v_cnt1,0)>0 
    begin
        set @v_rmrk='Rate cannot be changed for the selected Period. Already Billed';
    end
    else
    begin
			select @v_cnt1 =count(*) from cir_dbksup where comp_code=@pcompcode and unit_code=@punitcode 
			and publ=@ppublcode and edtn=@pedtncode and supdate=@v_sup_date and sup_rate=@psuprate;

        if isnull(@v_cnt1,0)=0 begin
           set @v_rmrk='Supply rate does not exist for the selected Period';
        end
        else
        begin
				update cir_dbksup set sup_rate=@pactrate,updated_by=@puserid,updated_dt=getdate()
                where comp_code=@pcompcode and unit_code=@punitcode and publ=@ppublcode and
                    edtn=@pedtncode and supdate=@v_sup_date and sup_rate=@psuprate;

            select @v_cnt1=count(*)  from cir_unsold_dtl where comp_code=@pcompcode and unit_code=@punitcode 
            and publ=@ppublcode and edtn=@pedtncode and supdate=@v_sup_date and copy_rate=@psuprate 
            and exists (select 'x' from cir_rcphdr where comp_code=cir_unsold_dtl.comp_code and
                    unit_code=cir_unsold_dtl.unit_code and doctype='UCN' 
                    and recptdt=cir_unsold_dtl.process_crdt and recptno=cir_unsold_dtl.process_crno);
           
            if isnull(@v_cnt1,0)=0 begin
                update cir_unsold_dtl set copy_rate=@psuprate 
                where comp_code=@pcompcode and unit_code=@punitcode and publ=@ppublcode and
                    edtn=@pedtncode and supdate=@v_sup_date and copy_rate=@psuprate and not exists (select 'x' from cir_rcphdr where comp_code=cir_unsold_dtl.comp_code and
                    unit_code=cir_unsold_dtl.unit_code and doctype='UCN' and recptdt=cir_unsold_dtl.process_crdt and recptno=cir_unsold_dtl.process_crno);
            End
            set @v_cnt2=1;
            set @v_rmrk='Supply Rate Updated Successfully';
            --commit;
        end
    end
 end


//--------------------------------------------end---------------------//

//---------------------------------start 04/04/2012 ritu----------------------//

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[cir_fetch_edtnwise_rate_change]
    @pcompcode       as varchar(20),
    @punitcode       as varchar(20),
    @ppublcode       as varchar(20),
    @pmedtncode      as varchar(20),
    @pedtncode       as varchar(20),
    @pdatefrom       as varchar(20),
    @pdatetill       as varchar(20),
    @puserid         as varchar(20),
    @pdateformat     as varchar(20),
    @pextra1         as varchar(200),
    @pextra2         as varchar(200),
    @pextra3         as varchar(200),
    @pextra4         as varchar(200),
    @pextra5         as varchar(200)
As
    declare @v_frdt      datetime
    declare @v_todt      datetime
Begin

	If @punitcode='' Begin
		set @punitcode=null
	End	
	
	If @ppublcode='' Begin
		set @ppublcode=null
	End	
	
	If @pmedtncode='' Begin
		set @pmedtncode=null
	End

	If @pedtncode='' Begin
		set @pedtncode=null
	End	
    set @v_frdt      =dbo.convert_user_date('/',@pdatefrom,@pdateformat)
    set @v_todt      =dbo.convert_user_date('/',@pdatetill,@pdateformat)
    
    select distinct x.comp_code as "COMP_CODE",x.unit_code AS "UNIT_CODE",x.publ AS "PUBL",x.publ_name AS "PUBL_NAME", 
    x.edtn AS "EDTN",x.edtn_name AS "EDTN_NAME",x.main_edtn AS "MAIN_EDTN",x.main_edtn_name AS "MAIN_EDTN_NAME", 
    x.supdate AS "SUPDATE",x.sup_rate AS "SUP_RATE" ,x.act_rate as "ACT_RATE"
    from (select distinct d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",d.publ AS "PUBL",p.publ_name AS "PUBL_NAME", 
    d.edtn AS "EDTN",e.edtn_name AS "EDTN_NAME",e.main_edtn AS "MAIN_EDTN",dbo.cir_get_edtn_name(d.comp_code,d.edtn) AS "MAIN_EDTN_NAME", 
    d.supdate AS "SUPDATE",d.sup_rate AS "SUP_RATE" ,dbo.cir_get_edtn_rate(d.comp_code,d.unit_code,d.edtn,
    CASE WHEN @pdateformat='mm/dd/yyyy' THEN CONVERT(varchar(20),d.supdate,101)
	WHEN @pdateformat='dd/mm/yyyy' THEN CONVERT(varchar(20),d.supdate,103)
	WHEN @pdateformat='yyyy/mm/dd' THEN CONVERT(varchar(20),d.supdate,111) END,@pdateformat) AS "ACT_RATE"
    from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_publ_mast p
    where d.comp_code=m.comp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and d.comp_code=@pcompcode and
    d.unit_code=m.unit and d.unit_code=isnull(@punitcode,d.unit_code) and d.publ=p.publ and d.publ=e.publ and d.publ=isnull(@ppublcode,d.publ) and 
    d.edtn=e.edtn and d.edtn=isnull(@pedtncode,d.edtn) and d.agcd=m.agcd and d.dpcd=m.dpcd and supdate between @v_frdt and @v_todt and 
    e.main_edtn=isnull(@pmedtncode,e.main_edtn))x
    where isnull(x.sup_rate,0)<>isnull(x.act_rate,0)
    order by comp_code,unit_code,publ_name,main_edtn_name,edtn_name,supdate;


End


//---------------------------------------end--------------------------//



//////////////////////////////////////////////For Print order Route wise//////////////////////////////////////////////


ALTER procedure [dbo].[cir_route_editionwise_print](
    @pcompcode      as varchar(500),
    @punitcode      as varchar(500),
    @ppublcode      as varchar(500),
    @pmainedtn      as varchar(500),
    @pedtncode      as varchar(500),
    @proute         as varchar(500),
    @pfrom_supdate  as datetime,
    @ptill_supdate  as datetime,
    @plangtype      as varchar(500),
    @pdateformat    as varchar(500),
    @pextra1        as varchar(500),
    @pextra2        as varchar(500),
    @pextra3        as varchar(500),--------supply posted final and un final
    @pextra4        as varchar(500),
    @pextra5        as varchar(500),
    @pextra6        as varchar(500),
    @pextra7        as varchar(500),
    @pextra8        as varchar(500),
    @pextra9        as varchar(500),
    @pextra10       as varchar(500)

)
as
SET CONCAT_NULL_YIELDS_NULL OFF
--CREATE TABLE #CIR_TEMP_DT
--(
--  SQNO  NUMeric,
--  DT    DATEtime
--)
declare @vsupdate  as  datetime;
declare @vsupdate1  as datetime;
declare @vvar    as varchar(max);
declare @vvar_sum   as  varchar(max);
declare @vvar_sum1  as  varchar(max);
declare @v_query  as  varchar(max);
declare @v_query1  as  varchar(max);

set @vsupdate =@pfrom_supdate
set @vsupdate1=@ptill_supdate

declare cur_edtn cursor for
    select distinct d.publ publ,d.edtn edtn,p.edtn_seq_no edtn_seqno,
    case @plangtype when '1' then substring(p.edition_nick,1,15)
    else substring(p.edtn_name_oth_lang,1,20) end edtn_name
    ,d.sup_rate sup_rate,p.main_edtn main_edtn
    from cir_route_mast m,cir_dbksup d ,cir_edtn_mast p ,cir_supply_type_mast k
    where m.comp_code=@pcompcode and m.comp_code=d.comp_code and d.comp_code=p.comp_code and m.unit=d.unit_code and
    d.comp_code=k.comp_code  and d.sup_type_code=k.sup_ty_code and 
    m.unit=p.unit_code and d.unit_code = @punitcode and
    d.supdate >= @vsupdate and d.supdate <=@vsupdate1 and
    m.route_code=d.route_code and (m.route_code=@proute or @proute is null)
    and d.publ=isnull(@ppublcode,d.publ) and
    d.publ=p.publ and d.edtn=p.edtn and k.bill_pay='Y'
    order by publ,main_edtn,edtn_seqno,edtn,sup_rate
print('a')
-- cursor variable for cur_edtn
declare @rec_edtn_publ as varchar(200)
declare @rec_edtn_edtn as varchar(200)
declare @rec_edtn_edtn_seqno as numeric(5)
declare @rec_edtn_edtn_name as varchar(500)
declare @rec_edtn_sup_rate as numeric(14,2)
declare @rec_edtn_main_edtn as varchar(200)
-- end here --

OPEN cur_edtn 
    fetch NEXT FROM cur_edtn INTO @rec_edtn_publ , @rec_edtn_edtn,@rec_edtn_edtn_seqno,@rec_edtn_edtn_name,@rec_edtn_sup_rate,@rec_edtn_main_edtn
        WHILE (@@FETCH_STATUS = 0) 
        BEGIN
            if (@vvar is null or @vvar = '') begin 
                set @vvar        ='sum(case edtn when '+''''+@rec_edtn_edtn+''''+' then sup_copy else 0 end) "'+@rec_edtn_edtn_name+'"';
                set @vvar_sum    ='sum('+'"'+@rec_edtn_edtn_name+'") "'+@rec_edtn_edtn_name+'"';
                set @vvar_sum1   ='sum('+'"'+@rec_edtn_edtn_name+'"';
            end
            else
            begin
                set @vvar        =@vvar+','+'sum(case edtn when '+''''+@rec_edtn_edtn+''''+' then sup_copy else 0 end) "'+@rec_edtn_edtn_name+'"';
                set @vvar_sum    =@vvar_sum+','+'sum('+'"'+@rec_edtn_edtn_name+'") "'+@rec_edtn_edtn_name+'"';
                set @vvar_sum1   =@vvar_sum1+'+"'+@rec_edtn_edtn_name+'"';
            end
                
                
    fetch NEXT FROM cur_edtn INTO @rec_edtn_publ , @rec_edtn_edtn,@rec_edtn_edtn_seqno,@rec_edtn_edtn_name,@rec_edtn_sup_rate,@rec_edtn_main_edtn
END     
close cur_edtn
DEALLOCATE cur_edtn

if @vvar_sum1 is not null or @vvar_sum1 !='' begin
    set @vvar_sum1=@vvar_sum1+') "Total"'
end
print(@vvar)
 if @vvar is null or @vvar ='' begin
    set @v_query='select x.comp_code,x.unit_code,x.route_code,x.route_name from(select d.comp_code,d.unit_code,d.route_code,
            case '''+@plangtype+''' when ''1'' then substring(m.route_name,1,25)
            else substring(m.route_name_oth_lang,1,25) end route_name 
            from cir_dbksup d,cir_route_mast m ,cir_supply_type_mast k
            where d.comp_code = m.comp_code and d.unit_code = m.unit 
            and d.comp_code=k.comp_code  and d.sup_type_code=k.sup_ty_code and d.comp_code = '+''''+@pcompcode+''''+' and
            d.unit_code = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and
            d.route_code = m.route_code  and 
            d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <='+''''+cast(@vsupdate1 as varchar)+''''+' 
            and k.bill_pay=''Y'' 
            and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' ='''')
            group by d.comp_code,d.unit_code,d.route_code,m.route_name) x
            group by x.comp_code,x.unit_code,x.route_code,x.route_name
            order by x.comp_code,x.unit_code,x.route_code,x.route_name';
end
else
begin        
    set @v_query='select x.comp_code,x.unit_code,x.route_code,x.route_name,'+@vvar_sum+','+@vvar_sum1+' from(select d.comp_code,d.unit_code,d.route_code route_code,
            case '''+@plangtype+''' when ''1'' then substring(m.route_name,1,25) 
            else substring(m.route_name_oth_lang,1,25) end route_name
            ,'+@vvar+' from cir_dbksup d,cir_route_mast m,cir_supply_type_mast k
            where d.comp_code = m.comp_code and d.unit_code = m.unit 
            and d.comp_code=k.comp_code  and d.sup_type_code=k.sup_ty_code  and d.comp_code = '+''''+@pcompcode+''''+' and
            d.unit_code = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and
            d.route_code = m.route_code  and
            d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <= '+''''+cast(@vsupdate1 as varchar)+''''+' 
            and k.bill_pay=''Y'' 
            and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' ='''')
            group by d.comp_code,d.unit_code,m.route_name,d.route_code) x
            group by x.comp_code,x.unit_code,x.route_code,x.route_name
            order by x.comp_code,x.unit_code,x.route_code,x.route_name';       
end
print(@v_query)
exec(@v_query)  
print('q')
-- for free supply
    set @vvar=null
    set @vvar_sum=null
    set @vvar_sum1=null
    
declare cur_edtn_free cursor for
    select distinct d.publ publ,d.edtn edtn,p.edtn_seq_no edtn_seqno,
    case @plangtype when '1' then substring(p.edition_nick,1,15)
    else substring(p.edtn_name_oth_lang,1,20) end edtn_name
    ,d.sup_rate sup_rate,p.main_edtn main_edtn
    from cir_supply_type_mast m,cir_dbksup d ,cir_edtn_mast p 
    where m.comp_code=@pcompcode and m.comp_code=d.comp_code and d.comp_code=p.comp_code and 
      d.comp_code=m.comp_code  and d.sup_type_code=m.sup_ty_code and 
      d.unit_code=p.unit_code and d.unit_code = @punitcode and
      d.supdate >= @vsupdate and d.supdate <=@vsupdate1 and
      d.publ=isnull(@ppublcode,d.publ) and
      d.publ=p.publ and d.edtn=p.edtn and m.bill_pay='N'
      order by publ,main_edtn,edtn_seqno,edtn,sup_rate
-- cursor variable for cur_edtn_free
declare @rec_edtn_free_publ as varchar(200)
declare @rec_edtn_free_edtn as varchar(200)
declare @rec_edtn_free_edtn_seqno as numeric(5)
declare @rec_edtn_free_edtn_name as varchar(500)
declare @rec_edtn_free_sup_rate as numeric(14,2)
declare @rec_edtn_free_main_edtn as varchar(200)
-- end here --

OPEN cur_edtn_free 
    fetch NEXT FROM cur_edtn_free INTO @rec_edtn_free_publ , @rec_edtn_free_edtn,@rec_edtn_free_edtn_seqno,@rec_edtn_free_edtn_name,@rec_edtn_free_sup_rate,@rec_edtn_free_main_edtn
        WHILE (@@FETCH_STATUS = 0) 
        BEGIN
            if (@vvar is null or @vvar = '') begin 
                set @vvar        ='sum(case edtn when '+''''+@rec_edtn_free_edtn+''''+' then sup_copy else 0 end) "'+@rec_edtn_free_edtn_name+'"';
                set @vvar_sum    ='sum('+'"'+@rec_edtn_free_edtn_name+'") "'+@rec_edtn_free_edtn_name+'"';
                set @vvar_sum1   ='sum('+'"'+@rec_edtn_free_edtn_name+'"';
            end
            else
            begin
                set @vvar        =@vvar+','+'sum(case edtn when '+''''+@rec_edtn_free_edtn+''''+' then sup_copy else 0 end) "'+@rec_edtn_free_edtn_name+'"';
                set @vvar_sum    =@vvar_sum+','+'sum('+'"'+@rec_edtn_free_edtn_name+'") "'+@rec_edtn_free_edtn_name+'"';
                set @vvar_sum1   =@vvar_sum1+'+"'+@rec_edtn_free_edtn_name+'"';
            end
                
                
    fetch NEXT FROM cur_edtn_free INTO @rec_edtn_free_publ , @rec_edtn_free_edtn,@rec_edtn_free_edtn_seqno,@rec_edtn_free_edtn_name,@rec_edtn_free_sup_rate,@rec_edtn_free_main_edtn
END     
close cur_edtn_free
DEALLOCATE cur_edtn_free
if @vvar_sum1 is not null or @vvar_sum1 !='' begin
    set @vvar_sum1=@vvar_sum1+') "Total"'
end

        if @vvar is null or @vvar ='' begin
            set @v_query1='select x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name from(select d.comp_code,d.unit_code,m.sup_ty_code,
            substring(m.sup_ty_name,1,25) supply_name
            from cir_dbksup d,cir_supply_type_mast m
            where d.comp_code = m.comp_code 
            and d.sup_type_code=m.sup_ty_code
            and d.comp_code = '+''''+@pcompcode+''''+' and
            d.unit_code = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and            
            d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <='+''''+cast(@vsupdate1 as varchar)+''''+' 
            and m.bill_pay=''N'' 
            and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' ='''')
            group by d.comp_code,d.unit_code,m.sup_ty_code,m.sup_ty_name) x
            group by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name
            order by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name';
        end
        else
        begin
            set @v_query1='select x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name,'+@vvar_sum+','+@vvar_sum1+' from
            (select d.comp_code,d.unit_code,m.sup_ty_code sup_ty_code,
            substring(m.sup_ty_name,1,25) supply_name
            ,'+@vvar+' from cir_dbksup d,cir_supply_type_mast m
            where d.comp_code = m.comp_code
             and d.sup_type_code=m.sup_ty_code 
            and d.comp_code = '+''''+@pcompcode+''''+' and
            d.unit_code = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and            
             d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <= '+''''+cast(@vsupdate1 as varchar)+''''+' 
             and m.bill_pay=''N'' and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' = '''')
            group by d.comp_code,d.unit_code,m.sup_ty_code,m.sup_ty_name) x
            group by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name
            order by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name';
        end

print(@v_query1)
exec(@v_query1)




 set @vvar=null
    set @vvar_sum=null
    set @vvar_sum1=null


-------------------for edition total


declare cur_edtn_total cursor for
    select distinct d.publ publ,d.edtn edtn,p.edtn_seq_no edtn_seqno,
    case @plangtype when '1' then substring(p.edition_nick,1,15)
    else substring(p.edtn_name_oth_lang,1,20) end edtn_name
    ,d.sup_rate sup_rate,p.main_edtn main_edtn
    from cir_supply_type_mast m,cir_dbksup d ,cir_edtn_mast p 
    where m.comp_code=@pcompcode and m.comp_code=d.comp_code and d.comp_code=p.comp_code and 
      d.comp_code=m.comp_code  and d.sup_type_code=m.sup_ty_code and 
      d.unit_code=p.unit_code and d.unit_code = @punitcode and
      d.supdate >= @vsupdate and d.supdate <=@vsupdate1 and
      d.publ=isnull(@ppublcode,d.publ) and
      d.publ=p.publ and d.edtn=p.edtn 
      order by publ,main_edtn,edtn_seqno,edtn,sup_rate
    
-- cursor variable for cur_edtn_free
declare @rec_edtn_total_publ as varchar(200)
declare @rec_edtn_total_edtn as varchar(200)
declare @rec_edtn_total_edtn_seqno as numeric(5)
declare @rec_edtn_total_edtn_name as varchar(500)
declare @rec_edtn_total_sup_rate as numeric(14,2)
declare @rec_edtn_total_main_edtn as varchar(200)
-- end here --

OPEN cur_edtn_total 
    fetch NEXT FROM cur_edtn_total INTO @rec_edtn_total_publ , @rec_edtn_total_edtn,@rec_edtn_total_edtn_seqno,@rec_edtn_total_edtn_name,@rec_edtn_total_sup_rate,@rec_edtn_total_main_edtn
        WHILE (@@FETCH_STATUS = 0) 
        BEGIN
            if (@vvar is null or @vvar = '') begin 
                set @vvar        ='sum(case edtn when '+''''+@rec_edtn_total_edtn+''''+' then sup_copy else 0 end) "'+@rec_edtn_total_edtn_name+'"';
                set @vvar_sum    ='sum('+'"'+@rec_edtn_total_edtn_name+'") "'+@rec_edtn_total_edtn_name+'"';
                set @vvar_sum1   ='sum('+'"'+@rec_edtn_total_edtn_name+'"';
            end
            else
            begin
                set @vvar        =@vvar+','+'sum(case edtn when '+''''+@rec_edtn_total_edtn+''''+' then sup_copy else 0 end) "'+@rec_edtn_total_edtn_name+'"';
                set @vvar_sum    =@vvar_sum+','+'sum('+'"'+@rec_edtn_total_edtn_name+'") "'+@rec_edtn_total_edtn_name+'"';
                set @vvar_sum1   =@vvar_sum1+'+"'+@rec_edtn_total_edtn_name+'"';
            end
                
                
    fetch NEXT FROM cur_edtn_total INTO @rec_edtn_total_publ , @rec_edtn_total_edtn,@rec_edtn_total_edtn_seqno,@rec_edtn_total_edtn_name,@rec_edtn_total_sup_rate,@rec_edtn_total_main_edtn
END     
close cur_edtn_total
DEALLOCATE cur_edtn_total
if @vvar_sum1 is not null or @vvar_sum1 !='' begin
    set @vvar_sum1=@vvar_sum1+') "Total"'
end

        if @vvar is null or @vvar ='' begin
            set @v_query1='select x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name from(select d.comp_code,unit_code,null as sup_ty_code, null as supply_name
            from cir_dbksup d
            where d.comp_code = '+''''+@pcompcode+''''+' and
            d.unit_code = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and            
            d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <='+''''+cast(@vsupdate1 as varchar)+''''+' 
            
            and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' ='''')
            group by d.comp_code,d.unit_code) x
            group by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name
            order by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name';
        end
        else
        begin
            set @v_query1='select x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name,'+@vvar_sum+','+@vvar_sum1+' from
            (select d.comp_code,d.unit_code   ,null as sup_ty_code, null as supply_name
            ,'+@vvar+' from cir_dbksup d,cir_supply_type_mast m
            where d.comp_code = m.comp_code
             and d.sup_type_code=m.sup_ty_code 
            and d.comp_code = '+''''+@pcompcode+''''+' and
            d.unit_code = '+''''+@punitcode+''''+' and d.publ = isnull('+''''+@ppublcode+''''+',d.publ) and            
             d.supdate >= '+''''+cast(@vsupdate as varchar)+''''+' and d.supdate <= '+''''+cast(@vsupdate1 as varchar)+''''+' 
              and (d.final_supply_flag='+''''+@pextra3+''''+' or '+''''+@pextra3+''''+' = '''')
            group by d.comp_code,d.unit_code) x
            group by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name
            order by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name';
        end

print(@v_query1)
exec(@v_query1)

SET CONCAT_NULL_YIELDS_NULL On


////////////////////////////////////////////////////////////////end of procedure//////////////////////////////////////////