*************** Rikkee Garg issue no. - 8005  23/07/2012 supply weight update***************

create or replace procedure checksupdate

(
pcomp_code  in varchar2,
punit_code  in varchar2,
ppub_code  in varchar2,
pdateformate in varchar2,
psup_date   in varchar2,
pextra1  in varchar2,
p_accounts out cur_type_new1.cursor_type    

)
is
pcount  int;
v_dt  date;
begin
v_dt :=to_date(psup_date,''''||pdateformate||'''');
select  count(*) into pcount from cir_dbksup where comp_code = pcomp_code and unit_code = punit_code and publ = ppub_code and supdate = v_dt;

open p_accounts for
select pcount as TOTAL FROM DUAL;

end;

******************* end of issue 8005 ***********************************

**********************Rikkee Garg Agency Master(searching times) 1-08-2012************


create or replace procedure cir_agdetail(

pcomp_code   in varchar2,
punit_code    in varchar2,
pagnm         in varchar2,
pextra1       in varchar2,
pextra2       in varchar2,
p_accounts   OUT   cur_type_new1.cursor_type

)
as
begin

open p_accounts  for
select cir_agmast.*,cir_get_agency_type(comp_code,AG_TYPE) AGENCY_TYPE,
cir_get_executive(comp_code,EXECUTIVE_CODE) EXECUTIVE,
cir_get_city(comp_code,city_code) CITY from cir_agmast
where comp_code = pcomp_code and unit = punit_code and 
(ag_name like pagnm || '%')

UNION
 select cir_agmast.* ,cir_get_agency_type(comp_code,AG_TYPE) AGENCY_TYPE,
cir_get_executive(comp_code,EXECUTIVE_CODE) EXECUTIVE,
cir_get_city(comp_code,city_code) CITY from cir_agmast
where comp_code = pcomp_code and unit = punit_code and 
(ag_name like pagnm || '%');
end;

*************************end ***************************************************************

****************** rikkee garg  06/08/12 unsold entry ***************************

create or replace procedure cir_billbranch_day_p (
pcomp_code       in varchar2,
punit_code       in varchar2,  
pagcd            in varchar2,
pdpcd            in varchar2,
pdateformate     in varchar2,
pextra1          in varchar2,
pextra2           in varchar2,
p_accounts      out cur_type_new1.cursor_type,
p_accounts1      out cur_type_new1.cursor_type,
p_accounts2      out cur_type_new1.cursor_type
)
as
begin
open p_accounts for  
 select  s.comp_code comp_code,s.unit unit,s.billing_cycle billing_cycle,
max(to_char(sysdate+1-nvl(no_of_days,0),''''||pdateformate||''''))as FIST_DT,
to_char(sysdate,''''||pdateformate||'''') as SEC_DT
from cir_supply s,CIR_UNSOLD_RETURN_CONTROL r
where s.comp_code = pcomp_code
AND    s.unit  = punit_code
AND s.agcd=pagcd
and s.dpcd=pdpcd
and s.comp_code=r.comp_code
and s.publ=r.publ_code
and s.edtn=r.edtn_code 
and s.billing_cycle=r.bill_freq
group by s.comp_code,s.unit,s.billing_cycle;


open p_accounts1 for
select comp_code,unit,billing_cycle,
 max(CASE billing_cycle 
WHEN 'D' THEN to_char(sysdate,''''||pdateformate||'''')
WHEN 'W' THEN to_char(sysdate-6,''''||pdateformate||'''') 
WHEN 'M' THEN to_char(trunc(sysdate,'MON'),''''||pdateformate||'''')
ELSE to_char(sysdate,''''||pdateformate||'''') END )AS FIST_DT,
 max(CASE billing_cycle 
WHEN 'D' THEN to_char(sysdate,''''||pdateformate||'''')
WHEN 'W' THEN to_char(sysdate,''''||pdateformate||'''')
WHEN 'M' THEN to_char(last_day(sysdate),''''||pdateformate||'''')
ELSE to_char(sysdate,''''||pdateformate||'''') END )AS SEC_DT
 from cir_supply 
WHERE     comp_code  = pcomp_code
             AND    unit  = punit_code
AND agcd=pagcd
and dpcd=pdpcd
group by comp_code,unit,billing_cycle;


open p_accounts2 for
select OVERRIDE_BACKDAYS from CIR_UNSOLD_APR_PERMISSION
where  comp_code=pcomp_code
and user_id=pextra1
and printing_center=punit_code
and branch_code=pextra2;
end;


*******************end***************************************

******************* rikkee garg unsold branchwise 6/08/2012

USE [abhi]
GO
/****** Object:  StoredProcedure [dbo].[cir_agency_bind_branch_p]    Script Date: 08/06/2012 12:26:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[cir_agency_bind_branch_p]
	@pcompcode			VARCHAR(20) ,
	@punit              VARCHAR(20) ,
	@pdateformat        VARCHAR(20) ,
    @pdistcode          VARCHAR(20)=null,  
	@pextra1            VARCHAR(4000) ,
	@pextra2            VARCHAR(4000) ,
@pbranch            VARCHAR(4000) 
AS 
BEGIN
	If UPPER(@pextra2)='D' Begin
			
		SELECT cir_agmast_dis.*,dbo.cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.BILL_AGCD,cir_agmast_dis.BILL_AGCD) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.agcd,cir_agmast_dis.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.station_code,1) as "DROP_POINT_NAME"
		FROM  cir_agmast_dis 
		WHERE comp_code  = @pcompcode AND unit  = @punit and(dist_code =@pdistcode or @pdistcode is null or @pdistcode ='')
		 AND ((UPPER(ag_name)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
		 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/
and branch_code=@pbranch
		union
		SELECT cir_agmast_dis.*,dbo.cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.BILL_AGCD,cir_agmast_dis.BILL_AGCD) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.agcd,cir_agmast_dis.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.station_code,1) as "DROP_POINT_NAME"
		FROM  cir_agmast_dis 
		WHERE comp_code  = @pcompcode AND unit  = @punit and(dist_code =@pdistcode or @pdistcode is null or @pdistcode ='')
		 AND ((UPPER(agcd)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
		 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/
and branch_code=@pbranch
		ORDER BY 5
	End
	Else Begin
		SELECT cir_agmast.*,dbo.cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.BILL_AGCD,cir_agmast.BILL_DPCD) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.station_code,1) as "DROP_POINT_NAME"
			FROM  cir_agmast 
			WHERE comp_code  = @pcompcode AND unit  = @punit and(dist_code =@pdistcode or @pdistcode is null or @pdistcode ='')
			 AND ((UPPER(ag_name)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
			 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/
and branch_code=@pbranch
		union
		SELECT cir_agmast.*,dbo.cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME",
		dbo.cir_get_agency(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.BILL_AGCD,cir_agmast.BILL_DPCD) "BILL_AGENCY",
		dbo.cir_get_agency_city(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY_CITY",
		dbo.cir_get_drop_point_name(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.station_code,1) as "DROP_POINT_NAME"
			FROM  cir_agmast 
			WHERE comp_code  = @pcompcode AND unit  = @punit and(dist_code =@pdistcode or @pdistcode is null or @pdistcode ='')
			 AND ((UPPER(agcd)  like UPPER(CAST(@pextra1 AS VARCHAR) + '%')) OR	(@pextra1  is null) OR	(@pextra1  = ''))
			 /*AND ISNULL(freeze_flag, 'N')  = 'N'*/			 
and branch_code=@pbranch
			ORDER BY 5
	End
END

********************** end****************************



****************************************************issue no.8178********************************************************

CREATE OR REPLACE PACKAGE BODY HT18JULY.CIR_SUPPLY_POST_FOR_NEXT_DAY IS
  Procedure cir_supply_posting_p(
    pcomp_code      in varchar2,
    punit_code      in varchar2,
    ppubl_code      in varchar2,
    pedtn_code      in varchar2,
    pagcd           in varchar2,
    pdpcd           in varchar2,
    puserid         in varchar2,
    psup_date       in varchar2,
    psup_ty         in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,  
    pextra2         in varchar2, ---for issue_date
    pper_copy_wt    in number,
    p_circul        out T_Circul_Cursor)
   As
    vsup_date       date;
    vpextra2        date;
    v_holi_count    number(5);
	
--begin
--null;
--end;	
	
    
    cursor cir_edtn_cur is
        select distinct edtn,edtn_name from cir_edtn_mast 
            where comp_code=pcomp_code and publ = ppubl_code and
                main_edtn = nvl(pedtn_code,main_edtn) and nvl(freeze_flag,'N')='N' and 
                main_edtn not in(select distinct h_main_edtn from cir_holiday_mast 
                    where comp_code = pcomp_code and unit = punit_code and
                        h_publ = ppubl_code and h_date = vsup_date and nvl(freeze_flag,'N')='N' and h_main_edtn is not null);
                    
    cir_edtn_rec cir_edtn_cur%rowtype;

    v_spl_rate number(10,4):=0;

    
	cursor cur_supply is
              select a.unit unit,a.agcd agcd,a.dpcd dpcd,a.publ publ,a.edtn edtn,a.supply_type_code supply_type_code,a.base_supply base_supply,a.supply_sun supply_sun,a.supply_mon supply_mon,a.supply_tue supply_tue,a.supply_wed supply_wed,
              a.supply_thu supply_thu,a.supply_fri supply_fri,a.supply_sat supply_sat,a.supply_spl1 supply_spl1,a.supply_spl2 supply_spl2, b.ag_type ag_type,b.supply_start_dt    supply_start_dt,b.suspend_date suspend_date, nvl(a.packet_size,0) packet_size,
                 a.comm_code comm_code,a.comm_flag comm_flag,b.bill_agcd bill_agcd,b.bill_dpcd bill_dpcd,a.route_code route_code,a.subroute_code subroute_code,a.sub_subroute_code sub_subroute_code,
                 a.surch_cd surch_cd,a.waste_catg_code
                 from cir_supply a,cir_agmast b
                 where a.comp_code=b.comp_code and a.unit=b.unit and
                              a.agcd=b.agcd and a.dpcd=b.dpcd and a.agcd=nvl(pagcd,a.agcd) and a.dpcd=nvl(pdpcd,a.dpcd) and
                              a.unit=punit_code and (a.publ=ppubl_code) and nvl(base_supply,0)>0 and
                              a.edtn=cir_edtn_rec.edtn and nvl(a.supply_flag,'N')='Y' and nvl(b.suspend,'N')='N'
                 order by a.agcd,a.dpcd,a.edtn,a.supply_type_code;
vcur_supply        cur_supply%rowtype;






    cursor cur_rate is
        select sun_rate,mon_rate,tue_rate,wed_rate,thu_rate,fri_rate,sat_rate from cir_rate_mast
            where comp_code=pcomp_code and unit=punit_code and publ=ppubl_code and edtn=cir_edtn_rec.edtn and
              valid_from=(select max(valid_from) from cir_rate_mast where comp_code=pcomp_code and
              unit=punit_code and publ=ppubl_code and edtn=cir_edtn_rec.edtn and valid_from<=vsup_date and
              nvl(freeze_flag,'N')='N');
cur_rate_rec cur_rate%rowtype;

cursor cur_surcharge is select * from cir_surcharge_mast
            where comp_code  =pcomp_code and
                  unit       =punit_code and
                  publ       =ppubl_code and
                  edtn       =cir_edtn_rec.edtn and
                  surch_cd   =vcur_supply.surch_cd and
                  valid_from = (select max(valid_from) from cir_surcharge_mast
                                            where comp_code  =pcomp_code and
                                                  unit       =punit_code and
                                                  publ       =ppubl_code and
                                                  edtn       =cir_edtn_rec.edtn and
                                                  surch_cd   =vcur_supply.surch_cd and
                                                  valid_from<=vsup_date);
    v_sup_copy      number(7);
    v_edtn_rate     number(10,4);
    vreccnt         number(5);
    v_old_sup_copy  number(7);
    v_supply_copy_dt date;
begin

    vsup_date:=to_date(psup_date,''''||pdateformat||'''');
    
    vpextra2:=to_date(pextra2,''''||pdateformat||'''');
    
    if pextra1 is not null then
        v_supply_copy_dt:=to_date(pextra1,''''||pdateformat||'''');
    end if;
    
    select count(*) into v_holi_count from cir_holiday_mast
        where comp_code = pcomp_code and unit = punit_code and
              h_publ = ppubl_code and h_date = vsup_date and nvl(freeze_flag,'N')='N' and 
              h_main_edtn is null and h_edtn is null and dist_code is null and state_code is null;

    if v_holi_count=0 then
        open cir_edtn_cur; --cursor open for edition
        loop
            fetch cir_edtn_cur into cir_edtn_rec;
            exit when cir_edtn_cur%notfound;
            --deletion record for already exists data

            delete from cir_dbksup where comp_code=pcomp_code and unit_code=punit_code and
                    publ=ppubl_code and edtn=cir_edtn_rec.edtn and supdate=vsup_date and
                    agcd=nvl(pagcd,agcd) and dpcd=nvl(pdpcd,dpcd);
            
            --for if special day of date on supply date
            Begin
                select spl_day_rate into v_spl_rate from cir_special_rate_mast
                    where comp_code=pcomp_code and unit=punit_code and
                          publ=ppubl_code and edtn=cir_edtn_rec.edtn and spl_day_date=vsup_date;
            Exception when no_data_found then
                v_spl_rate:=0;
            End;
                            
        if nvl(v_spl_rate,0)=0 then
            open cur_rate;--cursor open for regular rate
            fetch cur_rate into cur_rate_rec;


              if to_char(vsup_date,'DY') = 'SUN' then            ---for sunday edition rate
                  v_edtn_rate        :=    cur_rate_rec.sun_rate;
              elsif to_char(vsup_date,'DY') = 'MON' then    ---for monday edition rate
                  v_edtn_rate        :=    cur_rate_rec.mon_rate;
              elsif to_char(vsup_date,'DY') = 'TUE' then    ---for tueday edition rate
                  v_edtn_rate        :=    cur_rate_rec.tue_rate;
              elsif to_char(vsup_date,'DY') = 'WED' then    ---for wednesday edition rate
                  v_edtn_rate        :=    cur_rate_rec.wed_rate;
              elsif to_char(vsup_date,'DY') = 'THU' then    ---for Thursday edition rate
                  v_edtn_rate        :=    cur_rate_rec.thu_rate;
              elsif to_char(vsup_date,'DY') = 'FRI' then    ---for friday edition rate
                  v_edtn_rate        :=    cur_rate_rec.fri_rate;
              elsif to_char(vsup_date,'DY') = 'SAT' then    ---for saturday edition rate
                  v_edtn_rate        :=    cur_rate_rec.sat_rate;
              else
                  v_edtn_rate        :=    0;
              end if;
           close cur_rate;
        else
            v_edtn_rate:=v_spl_rate;
        end if;

        if v_edtn_rate=0 then
            dbms_output.put_line('Please Check,The Rate Today Is not Define for '||' '||    cir_edtn_rec.edtn_name);
        end if;

        open cur_supply; ---- cursor open for supply type wise
        loop
          fetch cur_supply into vcur_supply;
            exit when cur_supply%notfound;
            if (vsup_date>=vcur_supply.supply_start_dt or vcur_supply.supply_start_dt is null) and
                    (vsup_date<=vcur_supply.suspend_date or vcur_supply.suspend_date is null) then

              if psup_ty='R' and to_char(vsup_date,'DY') = 'SUN' then            ---for sunday supply
                if nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_sun,0)>0 then
                    v_sup_copy        :=     nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_sun,0);
                else
                    v_sup_copy        := 0;
                 end if;
            elsif psup_ty='R' and to_char(vsup_date,'DY') = 'MON' then    ---for monday supply
                if nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_mon,0)>0 then
                    v_sup_copy        :=     nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_mon,0);
                else
                    v_sup_copy        := 0;
                 end if;
            elsif psup_ty='R' and to_char(vsup_date,'DY') = 'TUE' then    ---for tueday supply
                if nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_tue,0)>0 then
                    v_sup_copy        :=     nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_tue,0);
                else
                    v_sup_copy        := 0;
                 end if;
            elsif psup_ty='R' and to_char(vsup_date,'DY') = 'WED' then    ---for wednesday supply
                if nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_wed,0)>0 then
                    v_sup_copy        :=     nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_wed,0);
                else
                    v_sup_copy        := 0;
                 end if;
            elsif psup_ty='R' and to_char(vsup_date,'DY') = 'THU' then    ---for Thursday supply
                if nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_thu,0)>0 then
                    v_sup_copy        :=     nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_thu,0);
                else
                    v_sup_copy        := 0;
                 end if;
            elsif psup_ty='R' and to_char(vsup_date,'DY') = 'FRI' then    ---for friday supply
                if nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_fri,0)>0 then
                    v_sup_copy        :=     nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_fri,0);
                else
                    v_sup_copy        := 0;
                 end if;
            elsif psup_ty='R' and to_char(vsup_date,'DY') = 'SAT' then    ---for saturday supply
                if nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_sat,0)>0 then
                    v_sup_copy        :=     nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_sat,0);
                else
                    v_sup_copy        := 0;
                 end if;
            elsif psup_ty='S1' then    ---for Special Day supply
                if nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_spl1,0)>0 then
                    v_sup_copy        :=     nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_spl1,0);
                else
                    v_sup_copy        := 0;
                 end if;
            elsif psup_ty='S2' then    ---for Special Day supply
                if nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_spl2,0)>0 then
                    v_sup_copy        :=     nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_spl2,0);
                else
                    v_sup_copy        := 0;
                 end if;
            end if;

            --------change for supply copy--------
            if psup_ty='R' and v_supply_copy_dt is not null then
                v_old_sup_copy:=0;
                select sum(sup_copy) into v_old_sup_copy from cir_dbksup where comp_code=pcomp_code and unit_code=punit_code and publ=ppubl_code and edtn=vcur_supply.edtn and
                    agcd=vcur_supply.agcd and dpcd=vcur_supply.dpcd and supdate=v_supply_copy_dt and sup_type_code=vcur_supply.supply_type_code;

            end if;

            if nvl(v_old_sup_copy,0)>0 then
                v_sup_copy:=v_old_sup_copy;
            end if;
            --------change for supply copy--------
            
            
          if nvl(v_sup_copy,0)>0 and nvl(v_edtn_rate,0)>0 then

               Begin
                insert into cir_dbksup (comp_code,unit_code,publ,edtn,agcd,dpcd,supdate,sup_type_code,sup_copy,agency_ty_code,
                                                                    agency_pkt_size,comm_code,comm_fix_auto_spl,sup_rate,billagcd,billdpcd,
                                                                    route_code,subroute_code,subsubroute_code,userid,surch_cd,
                                                                    issue_date,per_copy_weight,waste_catg_code)
                 values (pcomp_code,punit_code,ppubl_code,vcur_supply.edtn,vcur_supply.agcd,vcur_supply.dpcd,vsup_date,vcur_supply.supply_type_code,
                                 v_sup_copy,vcur_supply.ag_type,vcur_supply.packet_size,vcur_supply.comm_code,vcur_supply.comm_flag,
                                 v_edtn_rate,vcur_supply.bill_agcd,vcur_supply.bill_dpcd,vcur_supply.route_code,
                                     vcur_supply.subroute_code,vcur_supply.sub_subroute_code,puserid,vcur_supply.surch_cd,
                                     vpextra2,pper_copy_wt,vcur_supply.waste_catg_code);
                          exception when others then
                               /*insert into test1(vstring) values ('Exp'||pcomp_code||','||punit_code||','||ppubl_code||','||vcur_supply.edtn||','||vcur_supply.agcd||','||vcur_supply.dpcd||','||vsup_date||','||vcur_supply.supply_type_code||','||
                                 v_sup_copy||','||vcur_supply.ag_type||','||vcur_supply.packet_size||','||vcur_supply.comm_code||','||vcur_supply.comm_flag||','||
                                 v_edtn_rate||','||vcur_supply.bill_agcd||','||vcur_supply.bill_dpcd||','||vcur_supply.route_code||','||
                                     vcur_supply.subroute_code||','||vcur_supply.sub_subroute_code||','||puserid);commit;*/
                         null;
               End;
               /*select count(*) into vreccnt from cir_dbksup
               where comp_code=pcomp_code and unit_code=punit_code and publ=ppubl_code and edtn=vcur_supply.edtn and
               supdate=vsup_date and agcd=nvl(pagcd,agcd) and dpcd=nvl(pdpcd,dpcd);*/
         end if;
        end if;
        end loop;
        close cur_supply;
        v_edtn_rate:=0;v_spl_rate:=0;cir_edtn_rec.edtn:=NULL;
    end loop;
    close cir_edtn_cur;
    commit;
  end if;

  open p_circul for
  select decode(b.bill_pay,'Y','PAID','N','UNPAID','UNPAID') bill_pay,sum(a.sup_copy) sup_copy
    from cir_dbksup a,cir_supply_type_mast b,cir_edtn_mast e
    where a.comp_code=pcomp_code and a.comp_code=b.comp_code and a.comp_code=e.comp_code and a.unit_code=punit_code and
          a.publ=e.publ and a.publ=ppubl_code and a.edtn=e.edtn and e.main_edtn = nvl(pedtn_code,e.main_edtn) and
          a.sup_type_code=b.sup_ty_code and a.supdate=vsup_date and
          a.agcd=nvl(pagcd,a.agcd) and a.dpcd=nvl(pdpcd,a.dpcd)
    group by b.bill_pay
    order by b.bill_pay desc;

  End cir_supply_posting_p;

  Procedure cir_supply_posting_resale_p(
    pcomp_code      in varchar2,
    punit_code      in varchar2,
    ppubl_code      in varchar2,
    pedtn_code      in varchar2,
    pagcd           in varchar2,
    pdpcd           in varchar2,
    puserid         in varchar2,
    psup_date       in varchar2,
    psup_ty         in varchar2,-----------means Regular or Special day1 or Special Day2 Supply--
    pissue_date     in varchar2,---from preiodical issue master---
    pdateformat     in varchar2,
    pextra1         in varchar2,--for supply type code
    pextra2         in varchar2,--for supply copy
    pextra3         in varchar2,--for login branch code
    pextra4         in varchar2,
    pextra5         in varchar2,
    p_circul        out T_Circul_Cursor) 
   As
        vsup_date  date;
        viss_date  date;
        
        cursor cur_holiday is
            select h_date,h_name from cir_holiday_mast
                where comp_code=pcomp_code and 
                      unit=punit_code and 
                      h_publ=ppubl_code and
                      h_date=vsup_date and nvl(freeze_flag,'N')='N';
    vcur_holiday cur_holiday%rowtype;

        cursor cir_edtn_cur is
                    select distinct edtn,edtn_name from cir_edtn_mast
                    where comp_code=pcomp_code and publ = ppubl_code and
                    ((edtn = pedtn_code) or (pedtn_code is null)) and
                      nvl(freeze_flag,'N')='N';
         cir_edtn_rec cir_edtn_cur%rowtype;
        
        cursor cur_spl_rate is
            select spl_day_rate from cir_special_rate_mast
                where comp_code=pcomp_code and unit=punit_code and
                      publ=ppubl_code and edtn=cir_edtn_rec.edtn and spl_day_date=vsup_date;

    v_spl_rate number(10,4):=0;

    cursor cur_supply is
              select a.unit unit,a.agcd agcd,a.dpcd dpcd,a.publ publ,a.edtn edtn,a.supply_type_code supply_type_code,a.base_supply base_supply,a.supply_sun supply_sun,a.supply_mon supply_mon,a.supply_tue supply_tue,a.supply_wed supply_wed,
              a.supply_thu supply_thu,a.supply_fri supply_fri,a.supply_sat supply_sat,a.supply_spl1 supply_spl1,a.supply_spl2 supply_spl2, b.ag_type ag_type,b.supply_start_dt    supply_start_dt,b.suspend_date suspend_date, nvl(a.packet_size,0) packet_size,
                 a.comm_code comm_code,a.comm_flag comm_flag,b.bill_agcd bill_agcd,b.bill_dpcd bill_dpcd,a.route_code route_code,a.subroute_code subroute_code,a.sub_subroute_code sub_subroute_code,
                 a.surch_cd surch_cd,a.waste_catg_code  
                 from cir_supply a,cir_agmast b
                 where a.comp_code=b.comp_code and a.unit=b.unit and 
                              a.agcd=b.agcd and a.dpcd=b.dpcd and a.agcd=pagcd and a.dpcd=pdpcd and 
                              a.unit=punit_code and (a.publ=ppubl_code) and
                              nvl(base_supply,0)>0 and
                              a.edtn=cir_edtn_rec.edtn and
                              nvl(a.supply_flag,'N')='Y' and nvl(b.suspend,'N')='N'
                 order by a.agcd,a.dpcd,a.edtn,a.supply_type_code;
vcur_supply        cur_supply%rowtype;

    cursor cur_rate is
        select sun_rate,mon_rate,tue_rate,wed_rate,thu_rate,fri_rate,sat_rate from cir_rate_mast
            where comp_code=pcomp_code and unit=punit_code and publ=ppubl_code and edtn=cir_edtn_rec.edtn and
              valid_from=(select max(valid_from) from cir_rate_mast where comp_code=pcomp_code and
              unit=punit_code and publ=ppubl_code and edtn=cir_edtn_rec.edtn and valid_from<=vsup_date and 
              nvl(freeze_flag,'N')='N');
cur_rate_rec cur_rate%rowtype;

cursor cur_surcharge is select * from cir_surcharge_mast 
            where comp_code  =pcomp_code and 
                  unit       =punit_code and
                  publ       =ppubl_code and
                  edtn       =cir_edtn_rec.edtn and
                  surch_cd   =vcur_supply.surch_cd and 
                  valid_from = (select max(valid_from) from cir_surcharge_mast 
                                            where comp_code  =pcomp_code and 
                                                  unit       =punit_code and
                                                  publ       =ppubl_code and
                                                  edtn       =cir_edtn_rec.edtn and
                                                  surch_cd   =vcur_supply.surch_cd and
                                                  valid_from<=vsup_date);
            v_sup_copy     number(7);
            v_edtn_rate    number(10,4);
            vreccnt number(5);
begin

    vsup_date:=to_date(psup_date,''''||pdateformat||'''');
    viss_date:=to_date(pissue_date,''''||pdateformat||'''');
    insert into test1(vstring,vstring2) values('vsup_dat '||vsup_date,'viss_date '||viss_date);commit;
    /* Holiday Checking */
    open cur_holiday;
      fetch cur_holiday into vcur_holiday;
    close cur_holiday;
    
    if vsup_date=vcur_holiday.h_date then
        dbms_output.put_line('Please Check The  Holiday Today Is  '||' '||    vcur_holiday.h_name);
        dbms_output.put_line('Please Check The  Holiday Today Is  '||' '||    vcur_holiday.h_name);
    end if;
    
  if (vsup_date<>vcur_holiday.h_date) or vcur_holiday.h_date is null then
    open cir_edtn_cur; --cursor open for edition
    loop
        fetch cir_edtn_cur into cir_edtn_rec;
        exit when cir_edtn_cur%notfound;
            --deletion record for already exists data

            delete from cir_dbksup_resale where comp_code=pcomp_code and unit_code=punit_code and
                    publ=ppubl_code and edtn=cir_edtn_rec.edtn and supdate=vsup_date and 
                    (agcd=pagcd or pagcd is null) and (dpcd=pdpcd or pdpcd is null);

        /*open cur_spl_rate;----cursor open for if special day of date on supply date
        fetch cur_spl_rate into v_spl_rate;
        close cur_spl_rate;

        if nvl(v_spl_rate,0)=0 then
            open cur_rate;--cursor open for regular rate
            fetch cur_rate into cur_rate_rec;
            close cur_rate;
            
      if to_char(vsup_date,'DY') = 'SUN' then            ---for sunday edition rate
          v_edtn_rate        :=    cur_rate_rec.sun_rate;
      elsif to_char(vsup_date,'DY') = 'MON' then    ---for monday edition rate
          v_edtn_rate        :=    cur_rate_rec.mon_rate;
      elsif to_char(vsup_date,'DY') = 'TUE' then    ---for tueday edition rate
          v_edtn_rate        :=    cur_rate_rec.tue_rate;
      elsif to_char(vsup_date,'DY') = 'WED' then    ---for wednesday edition rate
          v_edtn_rate        :=    cur_rate_rec.wed_rate;
      elsif to_char(vsup_date,'DY') = 'THU' then    ---for Thursday edition rate
          v_edtn_rate        :=    cur_rate_rec.thu_rate;
      elsif to_char(vsup_date,'DY') = 'FRI' then    ---for friday edition rate
          v_edtn_rate        :=    cur_rate_rec.fri_rate;
      elsif to_char(vsup_date,'DY') = 'SAT' then    ---for saturday edition rate
          v_edtn_rate        :=    cur_rate_rec.sat_rate;
      else
          v_edtn_rate        :=    0;
      end if;
        else
            v_edtn_rate:=v_spl_rate;
        end if;*/
        begin
            select nvl(issue_price,0) into v_edtn_rate from cir_priodical_issue_mast 
                where comp_code=pcomp_code and unit_code=punit_code and publ_code=ppubl_code and edtn_code=cir_edtn_rec.edtn and issue_date=viss_date;
        exception when no_data_found then
            v_edtn_rate:=0;
        end;         

        if v_edtn_rate=0 then
            dbms_output.put_line('Please Check,The Rate Today Is not Define for '||' '||    cir_edtn_rec.edtn_name);
        end if;
        
        open cur_supply; ---- cursor open for supply type wise
        loop
          fetch cur_supply into vcur_supply;
            exit when cur_supply%notfound;
            if (vsup_date>=vcur_supply.supply_start_dt or vcur_supply.supply_start_dt is null) and
                    (vsup_date<=vcur_supply.suspend_date or vcur_supply.suspend_date is null) then

              if psup_ty='R' and to_char(vsup_date,'DY') = 'SUN' then            ---for sunday supply
                if nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_sun,0)>0 then
                    v_sup_copy        :=     nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_sun,0);
                else
                    v_sup_copy        := 0;
                 end if;
            elsif psup_ty='R' and to_char(vsup_date,'DY') = 'MON' then    ---for monday supply
                if nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_mon,0)>0 then
                    v_sup_copy        :=     nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_mon,0);
                else
                    v_sup_copy        := 0;
                 end if;
            elsif psup_ty='R' and to_char(vsup_date,'DY') = 'TUE' then    ---for tueday supply
                if nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_tue,0)>0 then
                    v_sup_copy        :=     nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_tue,0);
                else
                    v_sup_copy        := 0;
                 end if;
            elsif psup_ty='R' and to_char(vsup_date,'DY') = 'WED' then    ---for wednesday supply
                if nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_wed,0)>0 then
                    v_sup_copy        :=     nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_wed,0);
                else
                    v_sup_copy        := 0;
                 end if;
            elsif psup_ty='R' and to_char(vsup_date,'DY') = 'THU' then    ---for Thursday supply
                if nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_thu,0)>0 then
                    v_sup_copy        :=     nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_thu,0);
                else
                    v_sup_copy        := 0;
                 end if;
            elsif psup_ty='R' and to_char(vsup_date,'DY') = 'FRI' then    ---for friday supply
                if nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_fri,0)>0 then
                    v_sup_copy        :=     nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_fri,0);
                else
                    v_sup_copy        := 0;
                 end if;
            elsif psup_ty='R' and to_char(vsup_date,'DY') = 'SAT' then    ---for saturday supply
                if nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_sat,0)>0 then
                    v_sup_copy        :=     nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_sat,0);
                else
                    v_sup_copy        := 0;
                 end if;
            elsif psup_ty='S1' then    ---for Special Day supply
                if nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_spl1,0)>0 then
                    v_sup_copy        :=     nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_spl1,0);
                else
                    v_sup_copy        := 0;
                 end if;
            elsif psup_ty='S2' then    ---for Special Day supply
                if nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_spl2,0)>0 then
                    v_sup_copy        :=     nvl(vcur_supply.base_supply,0)+nvl(vcur_supply.supply_spl2,0);
                else
                    v_sup_copy        := 0;
                 end if;
            end if;
            
            v_sup_copy:=pextra2;
            
          if nvl(v_sup_copy,0)>0 then
               
               Begin
                insert into cir_dbksup_resale (comp_code,unit_code,publ,edtn,agcd,dpcd,supdate,sup_type_code,sup_copy,agency_ty_code,
                                                                    agency_pkt_size,comm_code,comm_fix_auto_spl,sup_rate,billagcd,billdpcd,
                                                                    route_code,subroute_code,subsubroute_code,userid,surch_cd,issue_date,return_copy_sale,resale_branch,waste_catg_code)
                 values (pcomp_code,punit_code,ppubl_code,vcur_supply.edtn,vcur_supply.agcd,vcur_supply.dpcd,vsup_date,/*vcur_supply.SUPPLY_TYPE_CODE,*/pextra1,
                                 v_sup_copy,vcur_supply.ag_type,vcur_supply.packet_size,vcur_supply.comm_code,vcur_supply.comm_flag,
                                 v_edtn_rate,vcur_supply.bill_agcd,vcur_supply.bill_dpcd,vcur_supply.route_code,
                                     vcur_supply.subroute_code,vcur_supply.sub_subroute_code,puserid,vcur_supply.surch_cd,viss_date,'Y',v_sup_copy,vcur_supply.waste_catg_code);
               Exception when others then
                   null;
               End;                     
               /*select count(*) into vreccnt from cir_dbksup_resale 
                where comp_code=pcomp_code and unit_code=punit_code and publ=ppubl_code and edtn=vcur_supply.edtn and supdate=vsup_date and 
                agcd=nvl(pagcd,agcd) and dpcd=nvl(pdpcd,dpcd);*/
                 --end if;
         end if;
        end if;
        end loop;
        close cur_supply;
    end loop;
    close cir_edtn_cur;
    commit;
  end if;  
  
  open p_circul for
  select decode(b.bill_pay,'Y','PAID','N','UNPAID','UNPAID') bill_pay,sum(a.sup_copy) sup_copy
    from cir_dbksup_resale a,cir_supply_type_mast b
    where a.comp_code=pcomp_code and a.comp_code=b.comp_code and a.unit_code=punit_code and 
          a.publ=ppubl_code and (a.edtn = pedtn_code or pedtn_code is null) and 
          a.sup_type_code=b.sup_ty_code and a.supdate=vsup_date and 
          (a.agcd=pagcd or pagcd is null) and (a.dpcd=pdpcd or pdpcd is null)
    group by b.bill_pay
    order by b.bill_pay desc;
  
  End cir_supply_posting_resale_p;

  procedure cir_check_supply_posting_p(
    pcomp_code  in varchar2,
    punit_code  in varchar2,
    ppubl_code  in varchar2,
    pedtn_code  in varchar2,
    pagcd       in varchar2,
    pdpcd       in varchar2,
    psup_date   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    p_circul    out T_Circul_Cursor)
  As
    vsup_date date;
    v_many_time_posting varchar2(1);
    v_backdays_posting  number(10);
    v_days              number(10);
    v_bill_exist        number(10);
    v_sup_copy          number(30);
  Begin
    vsup_date:=to_date(psup_date,''''||pdateformat||'''');
    
    select to_date(sysdate)-vsup_date into v_days from dual;

    select count(*) into v_bill_exist from cir_bill_det d,cir_publ_mast p,cir_edtn_mast e
        where d.comp_code = p.comp_code and d.comp_code = e.comp_code and d.comp_code=pcomp_code and d.unit_code=punit_code and
        vsup_date between fromdt and todt and d.publ=p.publ and d.publ = ppubl_code and d.edtn=e.edtn and e.main_edtn = nvl(pedtn_code,e.main_edtn);

    
    select cir_many_time_posting,cir_backdays_posting into v_many_time_posting,v_backdays_posting from preferrences 
        where "comp_code"=pcomp_code;
        
    If v_bill_exist=0 then--for bill checking
        if vsup_date-1>trunc(sysdate) then
            if nvl(v_many_time_posting,'N')='N' then
                select nvl(sum(a.sup_copy),0) sup_copy into v_sup_copy
                from cir_dbksup a,cir_edtn_mast e
                where a.comp_code=pcomp_code and a.comp_code=e.comp_code and a.unit_code=punit_code and 
                      a.publ=ppubl_code and a.publ = e.publ and a.edtn= e.edtn and 
                      a.supdate=vsup_date and a.agcd=nvl(pagcd,a.agcd) and a.dpcd=nvl(pdpcd,a.dpcd) and
                      e.main_edtn = nvl(pedtn_code,e.main_edtn);
            else
                v_sup_copy:=0;                
            end if;
        else
            if nvl(v_many_time_posting,'N')='N' then
                select nvl(sum(a.sup_copy),0) sup_copy into v_sup_copy
                    from cir_dbksup a,cir_edtn_mast e
                    where a.comp_code=pcomp_code and a.comp_code=e.comp_code and a.unit_code=punit_code and 
                          a.publ=ppubl_code and a.publ = e.publ and a.edtn= e.edtn and 
                          a.supdate=vsup_date and a.agcd=nvl(pagcd,a.agcd) and a.dpcd=nvl(pdpcd,a.dpcd) and
                          e.main_edtn = nvl(pedtn_code,e.main_edtn);
            else
                if nvl(v_backdays_posting,0)>0 then
                    if v_days>=v_backdays_posting then
                        v_sup_copy:=0;
                    else
                       v_sup_copy:=1;
                    end if;
                else
                    v_sup_copy:=0;                
                end if;
            end if;
        end if;
    Else
        v_sup_copy:=1;    
    End if;
    
    open p_circul for
    select v_sup_copy as "SUP_COPY" from dual;
    
  End cir_check_supply_posting_p;
  
  procedure cir_check_supply_posting_p(
    pcomp_code  in varchar2,
   punit_code  in varchar2,
    ppubl_code  in varchar2,
    pedtn_code  in varchar2,
     psup_date   in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    p_circul    out T_Circul_Cursor)
  As
    vsup_date date;
  Begin
    vsup_date:=to_date(psup_date,''''||pdateformat||'''');
    if /*vsup_date-1>trunc(sysdate) and */1=2 then
        open p_circul for
        select nvl(sum(a.sup_copy),0) sup_copy
        from cir_dbksup_resale a,cir_edtn_mast e
        where a.comp_code=pcomp_code and a.comp_code=e.comp_code and a.unit_code=punit_code and 
              a.publ = e.publ and a.publ=ppubl_code and a.edtn =e.edtn and 
              (nvl(e.main_edtn,e.edtn) = pedtn_code or pedtn_code is null) and 
              a.supdate=vsup_date /*and a.agcd=nvl(pagcd,a.agcd) and a.dpcd=nvl(pdpcd,a.dpcd)*/;
    else
        open p_circul for
        select 0 sup_copy from dual;
    end if;
   
     
  End cir_check_supply_posting_p;  
  procedure cir_check_supply_resale_p(
    pcomp_code      in varchar2,
    punit_code      in varchar2,
    ppubl_code      in varchar2,
    pedtn_code      in varchar2,
     pagcd           in varchar2,
    pdpcd           in varchar2,
    psup_date       in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    p_circul        out T_Circul_Cursor)
     As
    vsup_date date;
  Begin
    vsup_date:=to_date(psup_date,''''||pdateformat||'''');
    if /*vsup_date-1>trunc(sysdate) and */1=2 then
        open p_circul for
        select nvl(sum(a.sup_copy),0) sup_copy
        from cir_dbksup_resale a,cir_edtn_mast e
        where a.comp_code=pcomp_code and a.comp_code=e.comp_code and a.unit_code=punit_code and 
              a.publ = e.publ and a.publ=ppubl_code and a.edtn =e.edtn and 
              (nvl(e.main_edtn,e.edtn) = pedtn_code or pedtn_code is null) and 
              a.supdate=vsup_date and a.agcd=nvl(pagcd,a.agcd) and a.dpcd=nvl(pdpcd,a.dpcd);
    else
        open p_circul for
        select 0 sup_copy from dual;
    end if;
   
     
  End cir_check_supply_resale_p;   
END CIR_SUPPLY_POST_FOR_NEXT_DAY;
/







CREATE OR REPLACE PROCEDURE HT18JULY.cir_supply_posting_next_day(
    pcompcode   in  varchar2, 
    punitcode   in  varchar2 ,--- for print center
    ppublcode   in  varchar2 ,---- pub not mandatory    
    pextra1     in  varchar2 ,
    pextra2     in  varchar2, 
    pextra3     in  varchar2,
    pextra4     in  varchar2, 
    pextra5     in  varchar2,
    p_accounts  OUT Cur_Type_New1.cursor_type,
    p_accounts1 OUT Cur_Type_New1.cursor_type)is 

begin

open p_accounts for
select "Pub_cent_Code","Pub_Cent_name" from Pub_Cent_Mast where "Comp_Code"=pcompcode 
and ("Pub_cent_Code" =punitcode or punitcode is null)
and nvl(PRINT_CENT,'N')='Y';

open p_accounts1 for
select * from CIR_PUBL_MAST where COMP_CODE=pcompcode
and (PUBL=ppublcode or ppublcode is null or ppublcode='');

end cir_supply_posting_next_day;







CREATE OR REPLACE FUNCTION HT18JULY.CRM_chk_issue_date
(
ppubl        in  varchar2,
pedtn        in varchar2,
pfrequency   in varchar2,
pdate        in varchar2,
pextra1      in varchar2,
pextra2      in varchar2,
pextra3      in varchar2,
pextra4      in varchar2,
pdateformat      in varchar2
)
RETURN varchar2 is


q1  varchar2(3);
q2  varchar2(3);
q3  varchar2(3);
q4  varchar2(3);

v_c1_reg_name varchar2(200);
v_c1_reg_name1 varchar2(200);
pcount  integer;
freq  integer;
v_date date;
begin

v_date:=to_date(pdate,''''||pdateformat||'''');
    if(pedtn is null) 
    then
        select count(*) into pcount from cir_edition_issue_date where pub_code=ppubl;
        select  frequency_code into freq from cir_edition_issue_date where pub_code=ppubl;
        select First_Issue,Second_Issue into v_c1_reg_name,v_c1_reg_name1 from cir_edition_issue_date where pub_code=ppubl;

    
    else
    
        select count(distinct frequency_code) into pcount  from cir_edition_issue_date where pub_code=ppubl and edition_code=pedtn;
        select   frequency_code into freq from cir_edition_issue_date where pub_code=ppubl  and edition_code=pedtn;
       select  First_Issue,Second_Issue into v_c1_reg_name,v_c1_reg_name1 from cir_edition_issue_date where pub_code=ppubl and edition_code=pedtn;
    end if;


q1:=upper(TO_CHAR(ADD_MONTHS(v_date,0), 'MON'));
q2:=upper(TO_CHAR(ADD_MONTHS(v_date,3), 'MON'));
q3:=upper(TO_CHAR(ADD_MONTHS(v_date,6), 'MON'));
q4:=upper(TO_CHAR(ADD_MONTHS(v_date,9), 'MON'));







    if pcount >1 
    then
        v_c1_reg_name := 'Post Individual';
    
    else
    
        if freq = '1' 
        then
            v_c1_reg_name := 'Y';
        
        elsif(freq = '7') 
        then
            if(v_c1_reg_name=upper(TO_CHAR(v_date, 'DY')))
            then
                v_c1_reg_name := 'Y';
            
            else
            
                v_c1_reg_name := 'N';
            end if;
        
        elsif freq = '15' 
        then
            if(v_c1_reg_name= TO_CHAR(v_date, 'DD') or v_c1_reg_name1= TO_CHAR(v_date, 'DD'))
            then       
                v_c1_reg_name := 'Y';
            
            else
            
                v_c1_reg_name := 'N';
            end if;
        
        elsif freq = '30' 
        then
            if(v_c1_reg_name=TO_CHAR(v_date, 'DD'))
            then
                v_c1_reg_name := 'Y';
            
            else
            
                v_c1_reg_name := 'N';
            end if;
        
        elsif freq = '90' 
        then
            if(v_c1_reg_name= TO_CHAR(v_date, 'DD') and ((v_c1_reg_name1= q1) or v_c1_reg_name1=q2 or v_c1_reg_name1=q3 or v_c1_reg_name1=q4))
            then 
                v_c1_reg_name := 'Y';
           
            else
            
                v_c1_reg_name := 'N';
            end if;
        
        elsif freq = '365' 
        then
            if(v_c1_reg_name= TO_CHAR(v_date, 'DD') and (v_c1_reg_name1= upper(TO_CHAR(v_date, 'MON'))))
                                                         
            then
                v_c1_reg_name := 'Y';
            
            else
            
                v_c1_reg_name := 'N';
            end if;
        end if;
    end if;

    return v_c1_reg_name;
    end;
/
********************************************************end********************************************************