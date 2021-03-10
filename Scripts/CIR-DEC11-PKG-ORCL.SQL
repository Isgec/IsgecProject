/***********************mimoh 7dec 2011*********************************0005889****************/




CREATE OR REPLACE PROCEDURE cir_agency_unblock_approval (
    pcomp_code         in varchar2,
    punit_code         in varchar2,
    pbran_code         in varchar2,
    pstatus            in varchar2,
    pfrdt              in varchar2,
    ptodt              in varchar2,
    pagcd              in varchar2,
    pdpcd              in varchar2,
    psuspty            in varchar2,
    puserid            in varchar2,
    p_accounts         OUT cur_type_new1.cursor_type) as
Begin

open p_accounts for
  select comp_code,unit,agcd,dpcd,cir_get_agency (comp_code,unit,agcd,dpcd) as agency_name,start_date as block_unblock_date,'' as block_unblock_time,
         (SELECT SUSPEND_DESC FROM CIR_SUSPEND_TYPE_MAST WHERE COMP_CODE=cir_suspend_tran.COMP_CODE AND SUSPEND_TYPE_CODE=cir_suspend_tran.suspty) block_reason,suspty suspty,
         (SELECT max("username") from login where com_code = cir_suspend_tran.comp_code  and "userid"=cir_suspend_tran.userid) as unblock_by,suspty suspend_type,
         agency_unblock_approval,userid,nvl(trn_date,trunc(creation_date)) trn_date from cir_suspend_tran
      where comp_code = pcomp_code
        and ((unit    = punit_code) or (punit_code is null))
        --and branch
        and susp      = pstatus
        and trn_date between pfrdt and ptodt
        and ((agcd    = pagcd) or (pagcd is null))
        and ((dpcd    = pdpcd) or (pdpcd is null))
        and ((userid  = puserid) or (puserid is null))
        and nvl(agency_unblock_approval,'N')='N';
    
  
End cir_agency_unblock_approval;
/
/***********************************************************************************/


CREATE OR REPLACE PACKAGE cir_suspend_type_bind IS
  type t_accounts_type is ref cursor;
  procedure cir_suspend_type_bind_p(
     pcomp_code in varchar2,
     pdateformat in varchar2,
     pextra1 in varchar2,
     pextra2 in varchar2,
     p_accounts out t_accounts_type);
END;
/





CREATE OR REPLACE PACKAGE BODY cir_suspend_type_bind IS
  procedure cir_suspend_type_bind_p(
    pcomp_code in varchar2,
    pdateformat in varchar2,
    pextra1 in varchar2,
    pextra2 in varchar2,
    p_accounts out t_accounts_type) as
  Begin
     open p_accounts for select * from cir_suspend_type_mast where comp_code=pcomp_code and nvl(freeze_flag,'N')='N';
  End cir_suspend_type_bind_p;
END cir_suspend_type_bind;
/


/*****************************************************************************************************/


CREATE OR REPLACE PROCEDURE cir_user_bind_for_bl_unblk (pcomp_code   in varchar2,
                                                  punit_code   in varchar2,
                                                  pextra1      in varchar2,
                                                  pextra2      in varchar2,
                                                  pextra3      in varchar2,
                                                  pextra4      in varchar2,
                                                  pextra5      in varchar2,
                                                  p_accounts   OUT cur_type_new1.cursor_type)
as
Begin
  open p_accounts for
  SELECT "username" as USERNAME,"userid" as USERID from login where com_code = pComp_code 
      and "userid" in (select distinct userid from cir_suspend_tran 
                          where comp_code = pcomp_code
                            and ((unit       = punit_code) or (punit_code is null) or (punit_code = '')));
End;
/





/***********************mimoh 7dec 2011*********************************0005889****************/


/////////////////////////////////////////ISSUE NO.4488//////////////////////////////////////////////////////////////

/////////////////////////////////////////BODY//////////////////////////////////////////////////////////////////
CREATE OR REPLACE PACKAGE BODY HT18JULY.cir_rep_unsold_supply IS
  procedure cir_rep_unsold_detail(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pdoc_type          in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pedtn              in varchar2,
     pcity              in varchar2,
     pagcode            in varchar2,
     pdepocode          in varchar2,
     pfrom_recdate      in varchar2,
     ptill_recdate      in varchar2,
     papproved_flag     in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts)
  As
       v_frdt    date;
       v_todt    date;
  Begin  
       v_frdt:=to_date(pfrom_recdate,''''||pdateformat||'''');
       v_todt:=to_date(ptill_recdate,''''||pdateformat||'''');
       
           open p_accounts for
               select u.comp_code comp_code,u.unit_code unit_code,u.doctype doctype,u.recptno recptno,u.recptdt recptdt,
                    u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,u.city_name city_name,
                    u.supdate supdate,u.supply_copy supply_copy,
                    u.short_recpt short_recpt,u.late_recpt late_recpt,u.bnr bnr,u.unsold unsold,
                    u.copy_rate copy_rate,u.comm_rate comm_rate,u.waste_alw waste_alw,u.waste_rate waste_rate,u.copy_amt copy_amt,
                    u.comm_amt comm_amt,u.waste_amt waste_amt,u.total_amt total_amt from
               (select b.comp_code comp_code,b.unit_code unit_code,b.doctype doctype,b.recptno recptno,b.recptdt recptdt,
                    b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,cir_get_city(b.comp_code,a.city_code) city_name,
                    b.supdate supdate,sum(b.supply_copy) supply_copy,
                    sum(b.apr_short_recpt) short_recpt,sum(b.apr_late_recpt) late_recpt,sum(b.apr_bnr) bnr,sum(b.apr_unsold) unsold,
                    b.copy_rate copy_rate,b.comm_rate comm_rate,b.waste_alw waste_alw,b.waste_rate waste_rate,
                    sum(nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0))*b.copy_rate copy_amt,
                    sum(b.comm_amt) comm_amt,sum(b.waste_amt) waste_amt,sum(nvl(b.copy_amt,0)) total_amt 
               from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
               where b.comp_code = a.comp_code and b.comp_code = e.comp_code and b.comp_code =pcomp_code and 
                     b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code=punit_code and 
                     b.doctype=pdoc_type and b.app_dt between v_frdt and v_todt and 
                     a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd=pagcode) or (pagcode is null)) and b.dpcd=nvl(pdepocode,b.dpcd) and 
                     b.publ=e.publ and b.publ=nvl(ppubl,b.publ) and b.edtn=e.edtn and b.edtn=nvl(pedtn,b.edtn) and
                     a.city_code=nvl(pcity,a.city_code) and
                     (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0 and 
                     e.main_edtn=nvl(pmainedtn,e.main_edtn) and upper(nvl(papproved_flag,'N'))='Y'
                     group by b.comp_code,b.unit_code,b.doctype,b.recptno,b.recptdt,b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,
                     a.city_code,b.supdate,b.copy_rate,b.comm_rate,b.waste_alw,b.waste_rate
               union
               select b.comp_code comp_code,b.unit_code unit_code,b.doctype doctype,b.recptno recptno,b.recptdt recptdt,
                    b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,cir_get_city(b.comp_code,a.city_code) city_name,
                    b.supdate supdate,sum(b.supply_copy) supply_copy,
                    sum(b.short_recpt) short_recpt,sum(b.late_recpt) late_recpt,sum(b.bnr) bnr,sum(b.unsold) unsold,
                    b.copy_rate copy_rate,b.comm_rate comm_rate,b.waste_alw waste_alw,b.waste_rate waste_rate,
                    sum(nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0))*b.copy_rate copy_amt,
                    sum(b.comm_amt) comm_amt,sum(b.waste_amt) waste_amt,sum(nvl(b.copy_amt,0)) total_amt 
               from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
               where b.comp_code = a.comp_code and b.comp_code = e.comp_code and b.comp_code =pcomp_code and 
                     b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code=punit_code and 
                     b.doctype=pdoc_type and b.recptdt between v_frdt and v_todt and 
                     a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd=pagcode) or (pagcode is null)) and b.dpcd=nvl(pdepocode,b.dpcd) and 
                     b.publ=e.publ and b.publ=nvl(ppubl,b.publ) and b.edtn=e.edtn and b.edtn=nvl(pedtn,b.edtn) and
                     a.city_code=nvl(pcity,a.city_code) and
                     (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0 and 
                     e.main_edtn=nvl(pmainedtn,e.main_edtn) and upper(nvl(papproved_flag,'N'))='N'
                     group by b.comp_code,b.unit_code,b.doctype,b.recptno,b.recptdt,b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,
                     a.city_code,b.supdate,b.copy_rate,b.comm_rate,b.waste_alw,b.waste_rate) u 
                     order by u.comp_code,u.unit_code,u.recptdt,u.recptno,u.agname;
  End cir_rep_unsold_detail;

  procedure cir_rep_unsold_summary(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pdoc_type          in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pedtn              in varchar2,
     pcity              in varchar2,
     pagcode            in varchar2,
     pdepocode          in varchar2,
     pfrom_recdate      in varchar2,
     ptill_recdate      in varchar2,
     papproved_flag     in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts)
  As
     v_frdt     date;
     v_todt    date;
  Begin
       v_frdt:=to_date(pfrom_recdate,''''||pdateformat||'''');
       v_todt:=to_date(ptill_recdate,''''||pdateformat||'''');
       
       if upper(nvl(papproved_flag,'N'))='Y' then
           open p_accounts for
           select b.comp_code comp_code,b.unit_code unit_code,b.doctype doctype,b.recptno recptno,b.recptdt recptdt,
                        b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,cir_get_city(b.comp_code,a.city_code) city_name,
                        sum(b.apr_short_recpt) short_recpt,sum(b.apr_late_recpt) late_recpt,sum(b.apr_bnr) bnr,sum(b.apr_unsold) unsold,
                        sum(nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0))*b.copy_rate copy_amt,
                        sum(b.comm_amt) comm_amt,sum(b.waste_amt) waste_amt,sum(nvl(b.copy_amt,0)) total_amt 
               from cir_agmast a,cir_unsold_dtl b
               where b.comp_code    =a.comp_code and b.comp_code    =pcomp_code and 
                           b.unit_code=a.unit and b.unit_code=punit_code and 
                           b.doctype=pdoc_type and b.app_dt between v_frdt and v_todt and 
                           a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd=pagcode) or (pagcode is null)) and
                           ((b.dpcd=pdepocode) or (pdepocode is null)) and 
                           ((b.publ=ppubl) or (ppubl is null)) and ((b.edtn=pedtn) or (pedtn is null)) and
                           ((a.city_code=pcity) or (pcity is null)) and
                           (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0 and
                           b.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null))
                           group by b.comp_code,b.unit_code,b.doctype,b.recptno,b.recptdt,b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.city_code
                           order by b.comp_code,b.unit_code,b.recptdt,b.recptno,city_name,agname;
       else
           open p_accounts for
           select b.comp_code comp_code,b.unit_code unit_code,b.doctype doctype,b.recptno recptno,b.recptdt recptdt,
                        b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,cir_get_city(b.comp_code,a.city_code) city_name,
                        sum(b.short_recpt) short_recpt,sum(b.late_recpt) late_recpt,sum(b.bnr) bnr,sum(b.unsold) unsold,
                        sum(nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0))*b.copy_rate copy_amt,
                        sum(b.comm_amt) comm_amt,sum(b.waste_amt) waste_amt,sum(nvl(b.copy_amt,0)) total_amt 
               from cir_agmast a,cir_unsold_dtl b
               where b.comp_code    =a.comp_code and b.comp_code    =pcomp_code and 
                           b.unit_code=a.unit and b.unit_code=punit_code and 
                           b.doctype=pdoc_type and b.recptdt between v_frdt and v_todt and 
                           a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd=pagcode) or (pagcode is null)) and
                           ((b.dpcd=pdepocode) or (pdepocode is null)) and
                           ((b.publ=ppubl) or (ppubl is null)) and ((b.edtn=pedtn) or (pedtn is null)) and
                           (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0 and
                           b.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null))
                            group by b.comp_code,b.unit_code,b.doctype,b.recptno,b.recptdt,b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.city_code                           
                           order by b.comp_code,b.unit_code,b.recptdt,b.recptno,city_name,agname;
       end if;    
  End cir_rep_unsold_summary;
  
   procedure cir_publ_unsold_supply(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pdoc_type          in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pedtn              in varchar2,
     pagcode            in varchar2,
     pdepocode          in varchar2,
     pfromdate          in varchar2,
     ptilldate          in varchar2,
     papproved_flag     in varchar2,
     ptaluka            in varchar2,
     pstatecode         in varchar2,
     pdistcode          in varchar2,
     pbranchcode        in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts,
     p_accounts3        out t_accounts)
  As
       v_frdt    date;
       v_todt    date;
       v_query1     varchar2(8000);
      cursor cur_publ is
          select distinct p.publ publ,p.publ_name publ_name from cir_publ_mast p,cir_agmast a,cir_unsold_dtl b
               where b.comp_code    =a.comp_code and b.comp_code    =p.comp_code and b.comp_code = pcomp_code and 
                    b.unit_code=a.unit and b.unit_code=punit_code and 
                   b.doctype=pdoc_type and b.recptdt between v_frdt and v_todt and 
                   b.publ=p.publ and b.publ=nvl(ppubl,b.publ) and 
                   a.agcd=b.agcd and b.agcd=nvl(pagcode,b.agcd) and a.dpcd=b.dpcd and b.dpcd=nvl(pdepocode,b.dpcd) and 
                   (a.tehsil_taluka=ptaluka or ptaluka is null) and
                   (a.state_code=pstatecode or pstatecode is null) and (a.dist_code=pdistcode or pdistcode is null) and
                   (a.branch_code=pbranchcode or pbranchcode is null) and
                   (upper(nvl(papproved_flag,'N'))='Y' and (nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0))>0) or
                   (upper(nvl(papproved_flag,'N'))='N' and (nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0))>0)
                   order by publ;

     v1 cur_publ%rowtype;
     vvar       varchar2(4000);
     vvar1      varchar2(4000);
     vtot_publ  varchar2(2000);
     v_cnt      number:=0;
  Begin
       v_frdt:=to_date(pfromdate,''''||pdateformat||'''');
       v_todt:=to_date(ptilldate,''''||pdateformat||'''');
        --delete from test1;
    open cur_publ;
    loop
        fetch cur_publ into v1;
      exit when cur_publ%notfound;
          v_cnt :=nvl(v_cnt,0)+1;
          if vvar is null then
              vvar        :='decode(u.publ,'||''''||v1.publ||''''||','||''''||v1.publ_name||''''||')"'||v1.publ_name||'",decode(u.publ,'||''''||v1.publ||''''||',sum(u.supply_copy))"'||v1.publ||'_SUPPLY"';
              --vvar        :='decode(u.publ,'||''''||v1.publ||''''||',sum(u.supply_copy))"'||v1.publ||'_Supply"';
              vvar        :=vvar||',decode(u.publ,'||''''||v1.publ||''''||',sum(u.return_copy))"'||v1.publ||'_RETURN"';
              vvar        :=vvar||',round((decode(u.publ,'||''''||v1.publ||''''||',sum(u.return_copy))*100)/decode(u.publ,'||''''||v1.publ||''''||',sum(u.supply_copy)),2)"'||v1.publ||'_RETURN_PER"';
              --vvar1        :='"'||v1.publ_name||'"'||',sum("'||v1.publ||'_SUPPLY") "'||v1.publ||'_SUPPLY",sum("'||v1.publ||'_RETURN") "'||v1.publ||'_RETURN",sum("'||v1.publ||'_RETURN_PER") "'||v1.publ||'_RETURN_PER"';
              vvar1        :='sum("'||v1.publ||'_SUPPLY") "'||v1.publ||'_SUPPLY",sum("'||v1.publ||'_RETURN") "'||v1.publ||'_RETURN",sum("'||v1.publ||'_RETURN_PER") "'||v1.publ||'_RETURN_PER"';
              vtot_publ:=v1.publ_name;
          else
              vvar        :=vvar||',decode(u.publ,'||''''||v1.publ||''''||','||''''||v1.publ_name||''''||')"'||v1.publ_name||'",decode(u.publ,'||''''||v1.publ||''''||',sum(u.supply_copy))"'||v1.publ||'_SUPPLY"';
              --vvar        :=vvar||',decode(u.publ,'||''''||v1.publ||''''||',sum(u.supply_copy))"'||v1.publ||'_Supply"';
              vvar        :=vvar||',decode(u.publ,'||''''||v1.publ||''''||',sum(u.return_copy))"'||v1.publ||'_RETURN"';
              vvar        :=vvar||',round((decode(u.publ,'||''''||v1.publ||''''||',sum(u.return_copy))*100)/decode(u.publ,'||''''||v1.publ||''''||',sum(u.supply_copy)),2)"'||v1.publ||'_RETURN_PER"';
              --vvar1        :=vvar1||',"'||v1.publ_name||'"'||',sum("'||v1.publ||'_SUPPLY") "'||v1.publ||'_SUPPLY",sum("'||v1.publ||'_RETURN") "'||v1.publ||'_RETURN",sum("'||v1.publ||'_RETURN_PER") "'||v1.publ||'_RETURN_PER"';
              vvar1        :=vvar1||',sum("'||v1.publ||'_SUPPLY") "'||v1.publ||'_SUPPLY",sum("'||v1.publ||'_RETURN") "'||v1.publ||'_RETURN",sum("'||v1.publ||'_RETURN_PER") "'||v1.publ||'_RETURN_PER"';
              vtot_publ:=vtot_publ||''''||','||''''||v1.publ_name;
          end if;    
    end loop;
    close cur_publ;
        --insert into test1(vstring,vstring2) values('unsold var ',vvar);commit;
        --insert into test1(vstring,vstring2) values('unsold var1 ',vvar1);commit;
        --insert into test1(vstring,vstring2) values('unsold vtot_publ ',vtot_publ);commit;
       if vvar is not null and vvar1 is not null then
           If upper(nvl(papproved_flag,'N'))='Y' Then
               
               v_query1:='select comp_code,unit_code,agcd,dpcd,agname,agname_oth_lang,city_name,taluka_name,'||vvar1 ||' from (select u.comp_code comp_code,u.unit_code unit_code,
               u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,
               nvl(cir_get_city(u.comp_code,u.city_code),''NA'') city_name,nvl(cir_get_taluka(u.comp_code,u.taluka_code),''NA'') taluka_name,
               u.publ publ,cir_get_publ_name(comp_code,publ) publ_name,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.tehsil_taluka taluka_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and (a.tehsil_taluka='||''''||ptaluka||''''||' or '||''''||ptaluka||''''||' is null) and
                               (a.state_code='||''''||pstatecode||''''||' or '||''''||pstatecode||''''||' is null) and (a.dist_code='||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and
                               (a.branch_code='||''''||pbranchcode||''''||' or '||''''||pbranchcode||''''||' is null) and
                               (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,
                                                nvl(cir_get_city(u.comp_code,u.city_code),''NA''),nvl(cir_get_taluka(u.comp_code,u.taluka_code),''NA''))
                               group by comp_code,unit_code,agcd,dpcd,agname,agname_oth_lang,city_name,taluka_name 
                               order by comp_code,unit_code,taluka_name,agname';
                               --insert into test1(vstring,vstring2) values('unsold vquery1 ',v_query1);commit;
               Begin
                  open p_accounts for v_query1;           
                     exception when others then 
                          p_accounts:=null;
                  End;        
               v_query1:='select comp_code,unit_code,taluka_name,'||vvar1 ||' from (select u.comp_code comp_code,u.unit_code unit_code,
               nvl(cir_get_taluka(u.comp_code,u.taluka_code),''NA'') taluka_name,u.publ publ,cir_get_publ_name(comp_code,publ) publ_name,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.tehsil_taluka taluka_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.tehsil_taluka='||''''||ptaluka||''''||') or ('||''''||ptaluka||''''||' is null)) and
                               (a.state_code='||''''||pstatecode||''''||' or '||''''||pstatecode||''''||' is null) and (a.dist_code='||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and
                               (a.branch_code='||''''||pbranchcode||''''||' or '||''''||pbranchcode||''''||' is null) and
                               (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,nvl(cir_get_taluka(u.comp_code,u.taluka_code),''NA''))
                               group by comp_code,unit_code,taluka_name
                               order by comp_code,unit_code,taluka_name';
                --insert into test1(vstring,vstring2) values('unsold vquery2 ',v_query1);commit;
               Begin
                  open p_accounts1 for v_query1;           
                     exception when others then
                          p_accounts1:=null;
                  End;  
               v_query1:='select comp_code,unit_code,'||vvar1 ||' from (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,cir_get_publ_name(comp_code,publ) publ_name,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.tehsil_taluka taluka_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.tehsil_taluka='||''''||ptaluka||''''||') or ('||''''||ptaluka||''''||' is null)) and
                               (a.state_code='||''''||pstatecode||''''||' or '||''''||pstatecode||''''||' is null) and (a.dist_code='||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and
                               (a.branch_code='||''''||pbranchcode||''''||' or '||''''||pbranchcode||''''||' is null) and
                               (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ)
                               group by comp_code,unit_code 
                               order by comp_code,unit_code';
               --insert into test1(vstring,vstring2) values('unsold vquery3 ',v_query1);commit;
               --open p_accounts2 for v_query1;
               Begin
                  open p_accounts2 for v_query1;           
                     exception when others then 
                          p_accounts2:=null;
                  End;
           Else
               if vvar1 is not null then
                   v_query1:='select comp_code,unit_code,agcd,dpcd,agname,agname_oth_lang,city_name,taluka_name,'||vvar1 ||' from (select u.comp_code comp_code,u.unit_code unit_code,
                   u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,
                   nvl(cir_get_city(u.comp_code,u.city_code),''NA'') city_name,nvl(cir_get_taluka(u.comp_code,u.taluka_code),''NA'') taluka_name,
                   u.publ publ,cir_get_publ_name(comp_code,publ) publ_name,'||vvar
                   ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,
                                b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                                a.city_code city_code,a.tehsil_taluka taluka_code,
                                (select sum(sup_copy) from cir_dbksup 
                                where comp_code=b.comp_code and unit_code=b.unit_code and 
                                            agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                                nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0) return_copy
                       from cir_agmast a,cir_unsold_dtl b
                       where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                                   b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                                   b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                                   ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                                   a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                                   ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.tehsil_taluka='||''''||ptaluka||''''||') or ('||''''||ptaluka||''''||' is null)) and
                                   (a.state_code='||''''||pstatecode||''''||' or '||''''||pstatecode||''''||' is null) and (a.dist_code='||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and
                                   (a.branch_code='||''''||pbranchcode||''''||' or '||''''||pbranchcode||''''||' is null) and
                                   (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0 and
                                   b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                                   where u.supply_copy>0
                                   group by u.comp_code,u.unit_code,u.publ,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,
                                            nvl(cir_get_city(u.comp_code,u.city_code),''NA''),nvl(cir_get_taluka(u.comp_code,u.taluka_code),''NA''))
                                   group by comp_code,unit_code,agcd,dpcd,agname,agname_oth_lang,city_name,taluka_name                  
                                   order by comp_code,unit_code,taluka_name,agname';
               end if;    
                --insert into test1(vstring,vstring2) values('unsold vquery1 ',v_query1);COMMIT;
               --open p_accounts for v_query1;
               Begin
                  open p_accounts for v_query1;           
                     exception when others then 
                          p_accounts:=null;
                  End;
                if vvar1 is not null then
                   v_query1:='select comp_code,unit_code,taluka_name,'||vvar1 ||' from (select u.comp_code comp_code,u.unit_code unit_code,
                   nvl(cir_get_taluka(u.comp_code,u.taluka_code),''NA'') taluka_name,'||vvar
                   ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,
                                b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                                a.city_code city_code,a.tehsil_taluka taluka_code,
                                (select sum(sup_copy) from cir_dbksup 
                                where comp_code=b.comp_code and unit_code=b.unit_code and 
                                            agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                                nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0) return_copy
                       from cir_agmast a,cir_unsold_dtl b
                       where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                                   b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                                   b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                                   ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                                   a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                                   ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.tehsil_taluka='||''''||ptaluka||''''||') or ('||''''||ptaluka||''''||' is null)) and
                                   (a.state_code='||''''||pstatecode||''''||' or '||''''||pstatecode||''''||' is null) and (a.dist_code='||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and
                                   (a.branch_code='||''''||pbranchcode||''''||' or '||''''||pbranchcode||''''||' is null) and
                                   (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0 and
                                   b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                                   where u.supply_copy>0
                                   group by u.comp_code,u.unit_code,u.publ,cir_get_taluka(u.comp_code,u.taluka_code))
                                   group by comp_code,unit_code,taluka_name
                                   order by comp_code,unit_code,taluka_name';
                   --insert into test1(vstring,vstring2) values('unsold vquery2 ',v_query1);COMMIT;
              end if;
               --open p_accounts1 for v_query1;
               Begin
                  open p_accounts1 for v_query1;           
                     exception when others then 
                          p_accounts1:=null;
                  End; 
                if vvar1 is not null then
                   v_query1:='select comp_code,unit_code,'||vvar1 ||' from (select u.comp_code comp_code,u.unit_code unit_code,'||vvar
                   ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,
                                b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                                a.city_code city_code,a.tehsil_taluka taluka_code,
                                (select sum(sup_copy) from cir_dbksup 
                                where comp_code=b.comp_code and unit_code=b.unit_code and 
                                            agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                                nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0) return_copy
                       from cir_agmast a,cir_unsold_dtl b
                       where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                                   b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                                   b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                                   ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                                   a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                                   ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.tehsil_taluka='||''''||ptaluka||''''||') or ('||''''||ptaluka||''''||' is null)) and
                                   (a.state_code='||''''||pstatecode||''''||' or '||''''||pstatecode||''''||' is null) and (a.dist_code='||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and
                                   (a.branch_code='||''''||pbranchcode||''''||' or '||''''||pbranchcode||''''||' is null) and
                                   (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0 and
                                   b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                                   where u.supply_copy>0
                                   group by u.comp_code,u.unit_code,u.publ)
                                   group by comp_code,unit_code
                                   order by comp_code,unit_code';--,'||vtot_publ;
                   end if;
                --insert into test1(vstring,vstring2) values('unsold vquery3 ',v_query1);COMMIT;
              --open p_accounts2 for v_query1;
              Begin
                  open p_accounts2 for v_query1;           
                     exception when others then 
                          p_accounts2:=null;
                  End;
           End if;
             v_query1:='select '||''''||vtot_publ||''''||' from dual';
             --open p_accounts3 for v_query1;
                    Begin
                  open p_accounts3 for v_query1;           
                     exception when others then 
                          p_accounts3:=null;
                  End;
        End if;

  End cir_publ_unsold_supply;


    procedure cir_edtn_unsold_supply(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pdoc_type          in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pedtn              in varchar2,
     pagcode            in varchar2,
     pdepocode          in varchar2,
     pfromdate          in varchar2,
     ptilldate          in varchar2,
     papproved_flag     in varchar2,
     ptaluka            in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts,
     p_accounts3        out t_accounts)
  As
       v_frdt    date;
       v_todt    date;
       v_query1  varchar2(32000);
      cursor cur_edtn is
          select distinct u.publ publ,u.edtn edtn,u.edtn_name edtn_name,u.edtn_seq_no edtn_seq_no from
          (select distinct e.publ publ,e.edtn edtn,e.edtn_name edtn_name,e.edtn_seq_no edtn_seq_no from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e 
          where b.comp_code = a.comp_code and b.comp_code = e.comp_code and b.comp_code=pcomp_code and
          b.unit_code = a.unit and b.unit_code = e.unit_code and b.unit_code = punit_code and 
          b.doctype=pdoc_type and b.recptdt>= v_frdt and b.recptdt <= v_todt and 
          b.publ=e.publ and b.publ=nvl(ppubl,e.publ) and b.edtn=e.edtn and b.edtn=nvl(pedtn,b.edtn) and 
          a.agcd=b.agcd and a.dpcd=b.dpcd and b.agcd=nvl(pagcode,b.agcd) and 
          b.dpcd=nvl(pdepocode,b.dpcd) and (a.tehsil_taluka=ptaluka or ptaluka is null) and
          nvl(papproved_flag,'N')='Y' and (nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0))>0
          union
          select distinct e.publ publ,e.edtn edtn,e.edtn_name edtn_name,e.edtn_seq_no edtn_seq_no from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e 
          where b.comp_code = a.comp_code and b.comp_code = e.comp_code and b.comp_code=pcomp_code and
          b.unit_code = a.unit and b.unit_code = e.unit_code and b.unit_code = punit_code and 
          b.doctype=pdoc_type and b.recptdt>= v_frdt and b.recptdt <= v_todt and 
          b.publ=e.publ and b.publ=nvl(ppubl,e.publ) and b.edtn=e.edtn and b.edtn=nvl(pedtn,b.edtn) and 
          a.agcd=b.agcd and a.dpcd=b.dpcd and b.agcd=nvl(pagcode,b.agcd) and 
          b.dpcd=nvl(pdepocode,b.dpcd) and (a.tehsil_taluka=ptaluka or ptaluka is null) and
          nvl(papproved_flag,'N')='N' and (nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0))>0) u
          order by edtn_seq_no,edtn;

     rec_edtn cur_edtn%rowtype;
     vvar       varchar2(10000);
     tot_vvar   varchar2(10000);
     vtot_publ  varchar2(8000);
     v_cnt      number:=0;
  Begin
       v_frdt:=to_date(pfromdate,''''||pdateformat||'''');
       v_todt:=to_date(ptilldate,''''||pdateformat||'''');
    open cur_edtn;
    loop
        fetch cur_edtn into rec_edtn;
      exit when cur_edtn%notfound;
          v_cnt :=nvl(v_cnt,0)+1;
          if vvar is null then
              vvar        :='decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.supply_copy))"'||rec_edtn.edtn||'_SUPPLY"';
              vvar        :=vvar||',decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.return_copy))"'||rec_edtn.edtn||'_RETURN"';
              vvar        :=vvar||',round((decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.return_copy))*100)/decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.supply_copy)),2)"'||rec_edtn.edtn||'_RETURN_PER"';
              tot_vvar:=',sum("'||rec_edtn.edtn||'_SUPPLY") "'||rec_edtn.edtn||'_SUPPLY"';
              tot_vvar:=tot_vvar||',sum("'||rec_edtn.edtn||'_RETURN") "'||rec_edtn.edtn||'_RETURN"';
              tot_vvar:=tot_vvar||',sum("'||rec_edtn.edtn||'_RETURN_PER") "'||rec_edtn.edtn||'_RETURN_PER"';
              vtot_publ:=rec_edtn.edtn_name;
          else
              vvar        :=vvar||',decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.supply_copy))"'||rec_edtn.edtn||'_SUPPLY"';
              vvar        :=vvar||',decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.return_copy))"'||rec_edtn.edtn||'_RETURN"';
              vvar        :=vvar||',round((decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.return_copy))*100)/decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.supply_copy)),2)"'||rec_edtn.edtn||'_RETURN_PER"';
              tot_vvar:=tot_vvar||',sum("'||rec_edtn.edtn||'_SUPPLY") "'||rec_edtn.edtn||'_SUPPLY"';
              tot_vvar:=tot_vvar||',sum("'||rec_edtn.edtn||'_RETURN") "'||rec_edtn.edtn||'_RETURN"';
              tot_vvar:=tot_vvar||',sum("'||rec_edtn.edtn||'_RETURN_PER") "'||rec_edtn.edtn||'_RETURN_PER"';
              vtot_publ:=vtot_publ||''''||','||''''||rec_edtn.edtn_name;
          end if;    
    end loop;
    close cur_edtn;
    
        --delete test1;
        --insert into test1(vstring,vstring2) values('unsold edtn vvar ',vvar);COMMIT;
        --insert into test1(vstring,vstring2) values('unsold edtn TOT_vvar ',tot_vvar);COMMIT;
        if vvar is not null then
           If nvl(papproved_flag,'N')='Y' Then
               v_query1:='select c.comp_code comp_code,c.unit_code unit_code,c.agcd agcd,c.dpcd dpcd,c.agname agname,c.agname_oth_lang agname_oth_lang,
               nvl(cir_get_city(c.comp_code,c.city_code),''NA'') city_name,nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA'') taluka_name '||tot_vvar||'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,
               u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,u.city_code city_code,u.taluka_code taluka_code,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.tehsil_taluka taluka_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               ((b.edtn='||''''||pedtn||''''||') or ('||''''||pedtn||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.tehsil_taluka='||''''||ptaluka||''''||') or ('||''''||ptaluka||''''||' is null)) and
                               (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,
                               u.city_code,u.taluka_code) c
                               group by c.comp_code,c.unit_code,c.agcd,c.dpcd,c.agname,c.agname_oth_lang,nvl(cir_get_city(c.comp_code,c.city_code),''NA''),
                               nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA'')
                               order by c.comp_code,c.unit_code,nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA''),c.agname';
                                              
               --insert into test1(vstring,vstring2) values('unsold edtn YY ',v_query1);COMMIT;
               open p_accounts for v_query1;           
               
               v_query1:='select c.comp_code comp_code,c.unit_code unit_code,
               nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA'') taluka_name '||tot_vvar||'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,
               u.taluka_code taluka_code,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.tehsil_taluka taluka_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                            agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               ((b.edtn='||''''||pedtn||''''||') or ('||''''||pedtn||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.tehsil_taluka='||''''||ptaluka||''''||') or ('||''''||ptaluka||''''||' is null)) and
                               (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.taluka_code) c
                               group by c.comp_code,c.unit_code,nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA'')
                               order by c.comp_code,c.unit_code,nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA'')';
                
                --insert into test1(vstring,vstring2) values('unsold edtn v_query2 ',v_query1);COMMIT;
                open p_accounts1 for v_query1;
               
               v_query1:='select c.comp_code comp_code,c.unit_code unit_code '||tot_vvar||'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.tehsil_taluka taluka_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               ((b.edtn='||''''||pedtn||''''||') or ('||''''||pedtn||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.tehsil_taluka='||''''||ptaluka||''''||') or ('||''''||ptaluka||''''||' is null)) and
                               (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,cir_get_edtn_name(u.comp_code,u.edtn))c
                               group by c.comp_code,c.unit_code
                               order by c.comp_code,c.unit_code';
               --insert into test1(vstring,vstring2) values('unsold edtn v_query3 ',v_query1);COMMIT;
               open p_accounts2 for v_query1;
           Else
               v_query1:='select c.comp_code comp_code,c.unit_code unit_code,c.agcd agcd,c.dpcd dpcd,c.agname agname,c.agname_oth_lang agname_oth_lang,
               nvl(cir_get_city(c.comp_code,c.city_code),''NA'') city_name,nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA'') taluka_name '||tot_vvar||'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,
               u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,u.city_code city_code,u.taluka_code taluka_code,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.tehsil_taluka taluka_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               ((b.edtn='||''''||pedtn||''''||') or ('||''''||pedtn||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.tehsil_taluka='||''''||ptaluka||''''||') or ('||''''||ptaluka||''''||' is null)) and
                               (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,
                               u.city_code,u.taluka_code) c
                               group by c.comp_code,c.unit_code,c.agcd,c.dpcd,c.agname,c.agname_oth_lang,nvl(cir_get_city(c.comp_code,c.city_code),''NA''),
                               nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA'')
                               order by c.comp_code,c.unit_code,nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA''),c.agname';
                    --insert into test1(vstring,vstring2) values('unsold edtn v_query1 ',v_query1);COMMIT;
               open p_accounts for v_query1;
    
               v_query1:='select c.comp_code comp_code,c.unit_code unit_code,
               nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA'') taluka_name '||tot_vvar||'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,
               u.taluka_code taluka_code,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.tehsil_taluka taluka_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               ((b.edtn='||''''||pedtn||''''||') or ('||''''||pedtn||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.tehsil_taluka='||''''||ptaluka||''''||') or ('||''''||ptaluka||''''||' is null)) and
                               (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.taluka_code) c
                               group by c.comp_code,c.unit_code,nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA'')
                               order by c.comp_code,c.unit_code,nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA'')';
               --insert into test1(vstring,vstring2) values('unsold edtn v_query2 ',v_query1);COMMIT;
               open p_accounts1 for v_query1;
    
               v_query1:='select c.comp_code comp_code,c.unit_code unit_code '||tot_vvar||'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.tehsil_taluka taluka_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               ((b.edtn='||''''||pedtn||''''||') or ('||''''||pedtn||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.tehsil_taluka='||''''||ptaluka||''''||') or ('||''''||ptaluka||''''||' is null)) and
                               (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,cir_get_edtn_name(u.comp_code,u.edtn))c
                               group by c.comp_code,c.unit_code
                               order by c.comp_code,c.unit_code';
                --insert into test1(vstring,vstring2) values('unsold edtn v_query3 ',v_query1);COMMIT;
               open p_accounts2 for v_query1;
           End if;
                 v_query1:='select '||''''||vtot_publ||''''||' from dual';
                 open p_accounts3 for v_query1;
        Else
            v_query1:='select '||''''||pcomp_code||''''||' comp_code,'||''''||punit_code||''''||' unit_code,null agcd,null dpcd,null agname,null agname_oth_lang,null city_name,null taluka_name,0 supply_copy,0 return_copy from dual';
            --insert into test1(vstring,vstring2) values('unsold else edtn vquery ',v_query1);COMMIT;
            open p_accounts for v_query1;
            v_query1:='select '||''''||pcomp_code||''''||' comp_code,'||''''||punit_code||''''||' unit_code,null taluka_name,0 supply_copy,0 return_copy from dual';
            --insert into test1(vstring,vstring2) values('unsold else edtn vquery2 ',v_query1);COMMIT;
            open p_accounts1 for v_query1;
            v_query1:='select '||''''||pcomp_code||''''||' comp_code,'||''''||punit_code||''''||' unit_code,0 supply_copy,0 return_copy from dual';
            --insert into test1(vstring,vstring2) values('unsold else edtn vquery3 ',v_query1);COMMIT;
            open p_accounts2 for v_query1;
                 v_query1:='select null from dual';
            open p_accounts3 for v_query1;            
        End if;
  End cir_edtn_unsold_supply;
    
    procedure cir_edtn_unsold_supply_dist(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pdoc_type          in varchar2,
     ppubl              in varchar2,
     pmainedtn             in varchar2,
     pedtn              in varchar2,
     pagcode            in varchar2,
     pdepocode          in varchar2,
     pfromdate          in varchar2,
     ptilldate          in varchar2,
     papproved_flag        in varchar2,
     pdistcd            in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts,
     p_accounts3         out t_accounts)
  As
       v_frdt    date;
       v_todt    date;
       v_query1     varchar2(32000);
      cursor cur_edtn is
        select distinct u.publ publ,u.edtn edtn,u.edtn_name edtn_name,u.edtn_seqno edtn_seq_no from
        (select distinct e.publ publ,e.edtn edtn,e.edtn_name edtn_name,e.edtn_seq_no edtn_seqno
        from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e 
        where a.comp_code=b.comp_code and b.comp_code=e.comp_code and b.comp_code=pcomp_code and
        a.unit=b.unit_code and b.unit_code=e.unit_code and b.unit_code=punit_code and b.doctype=pdoc_type and 
        b.recptdt >= v_frdt and b.recptdt<=v_todt and b.publ=e.publ and b.publ=nvl(ppubl,b.publ) and 
        b.edtn=e.edtn and b.edtn=nvl(pedtn,b.edtn) and a.agcd=b.agcd and a.dpcd=b.dpcd and b.agcd=nvl(pagcode,b.agcd) and 
        b.dpcd=nvl(pdepocode,b.dpcd) and (a.dist_code=pdistcd or pdistcd is null) and
        nvl(papproved_flag,'N')='Y' and (nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0))>0
        union
        select distinct e.publ publ,e.edtn edtn,e.edtn_name edtn_name,e.edtn_seq_no edtn_seqno 
        from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e 
        where a.comp_code=b.comp_code and b.comp_code=e.comp_code and b.comp_code=pcomp_code and
        a.unit=b.unit_code and b.unit_code=e.unit_code and b.unit_code=punit_code and b.doctype=pdoc_type and 
        b.recptdt >= v_frdt and b.recptdt<=v_todt and b.publ=e.publ and b.publ=nvl(ppubl,b.publ) and 
        b.edtn=e.edtn and b.edtn=nvl(pedtn,b.edtn) and a.agcd=b.agcd and a.dpcd=b.dpcd and b.agcd=nvl(pagcode,b.agcd) and 
        b.dpcd=nvl(pdepocode,b.dpcd) and (a.dist_code=pdistcd or pdistcd is null) and
        nvl(papproved_flag,'N')='N' and (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0) u
        order by edtn_seq_no,edtn;

     rec_edtn cur_edtn%rowtype;
     vvar         varchar2(10000);
     tot_vvar varchar2(10000);
     vtot_publ varchar2(8000);
     v_cnt     number:=0;
  Begin
       v_frdt:=to_date(pfromdate,''''||pdateformat||'''');
       v_todt:=to_date(ptilldate,''''||pdateformat||'''');
    open cur_edtn;
    loop
        fetch cur_edtn into rec_edtn;
      exit when cur_edtn%notfound;
          v_cnt :=nvl(v_cnt,0)+1;
          if vvar is null then
              vvar        :='decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.supply_copy))"'||rec_edtn.edtn||'_SUPPLY"';
              vvar        :=vvar||',decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.return_copy))"'||rec_edtn.edtn||'_RETURN"';
              vvar        :=vvar||',round((decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.return_copy))*100)/decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.supply_copy)),2)"'||rec_edtn.edtn||'_RETURN_PER"';
              tot_vvar:=tot_vvar||',sum("'||rec_edtn.edtn||'_SUPPLY") "'||rec_edtn.edtn||'_SUPPLY"';
              tot_vvar:=tot_vvar||',sum("'||rec_edtn.edtn||'_RETURN") "'||rec_edtn.edtn||'_RETURN"';
              tot_vvar:=tot_vvar||',sum("'||rec_edtn.edtn||'_RETURN_PER") "'||rec_edtn.edtn||'_RETURN_PER"';
              vtot_publ:=rec_edtn.edtn_name;
          else
              vvar        :=vvar||',decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.supply_copy))"'||rec_edtn.edtn||'_SUPPLY"';
              vvar        :=vvar||',decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.return_copy))"'||rec_edtn.edtn||'_RETURN"';
              vvar        :=vvar||',round((decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.return_copy))*100)/decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.supply_copy)),2)"'||rec_edtn.edtn||'_RETURN_PER"';
              tot_vvar:=tot_vvar||',sum("'||rec_edtn.edtn||'_SUPPLY") "'||rec_edtn.edtn||'_SUPPLY"';
              tot_vvar:=tot_vvar||',sum("'||rec_edtn.edtn||'_RETURN") "'||rec_edtn.edtn||'_RETURN"';
              tot_vvar:=tot_vvar||',sum("'||rec_edtn.edtn||'_RETURN_PER") "'||rec_edtn.edtn||'_RETURN_PER"';
              vtot_publ:=vtot_publ||''''||','||''''||rec_edtn.edtn_name;
          end if;    
    end loop;
    close cur_edtn;
    
        --delete test1;
        --insert into test1(vstring,vstring2) values('unsold edtn vvar ',vvar);COMMIT;
        --insert into test1(vstring,vstring2) values('unsold edtn TOT_vvar ',tot_vvar);COMMIT;
        if vvar is not null then
           If nvl(papproved_flag,'N')='Y' Then
               v_query1:='select c.comp_code comp_code,c.unit_code unit_code,c.agcd agcd,c.dpcd dpcd,c.agname agname,c.agname_oth_lang agname_oth_lang,
               nvl(cir_get_city(c.comp_code,c.city_code),''NA'') city_name,nvl(cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'') dist_name '||tot_vvar||'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,
               u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,u.city_code city_code,u.state_code state_code,u.dist_code dist_code,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.state_code state_code,a.dist_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               ((b.edtn='||''''||pedtn||''''||') or ('||''''||pedtn||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.dist_code='||''''||pdistcd||''''||') or ('||''''||pdistcd||''''||' is null)) and
                               (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,
                               u.city_code,u.state_code,u.dist_code) c
                               group by c.comp_code,c.unit_code,c.agcd,c.dpcd,c.agname,c.agname_oth_lang,nvl(cir_get_city(c.comp_code,c.city_code),''NA''),
                               nvl(cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'')
                               order by c.comp_code,c.unit_code,nvl(cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA''),c.agname';
                                              
               --insert into test1(vstring,vstring2) values('unsold edtn p_accounts ',v_query1);COMMIT;
               open p_accounts for v_query1;           
               
               v_query1:='select c.comp_code comp_code,c.unit_code unit_code,
               nvl(cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'') dist_name '||tot_vvar||'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,
               u.state_code state_code,u.dist_code dist_code,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.state_code state_code,a.dist_code dist_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                            agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               ((b.edtn='||''''||pedtn||''''||') or ('||''''||pedtn||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.dist_code='||''''||pdistcd||''''||') or ('||''''||pdistcd||''''||' is null)) and
                               (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.state_code,u.dist_code) c
                               group by c.comp_code,c.unit_code,nvl(cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'')
                               order by c.comp_code,c.unit_code,nvl(cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'')';
                
                --insert into test1(vstring,vstring2) values('unsold edtn p_accounts1 ',v_query1);COMMIT;
                open p_accounts1 for v_query1;
               
               v_query1:='select c.comp_code comp_code,c.unit_code unit_code '||tot_vvar||'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.state_code state_code,a.dist_code dist_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               ((b.edtn='||''''||pedtn||''''||') or ('||''''||pedtn||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.dist_code='||''''||pdistcd||''''||') or ('||''''||pdistcd||''''||' is null)) and
                               (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,cir_get_edtn_name(u.comp_code,u.edtn))c
                               group by c.comp_code,c.unit_code
                               order by c.comp_code,c.unit_code';
               --insert into test1(vstring,vstring2) values('unsold edtn p_accounts2 ',v_query1);COMMIT;
               open p_accounts2 for v_query1;
           Else
               v_query1:='select c.comp_code comp_code,c.unit_code unit_code,c.agcd agcd,c.dpcd dpcd,c.agname agname,c.agname_oth_lang agname_oth_lang,
               nvl(cir_get_city(c.comp_code,c.city_code),''NA'') city_name,nvl(cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'') dist_name '||tot_vvar||'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,
               u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,u.city_code city_code,u.state_code state_code,u.dist_code dist_code,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.state_code state_code,a.dist_code dist_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               ((b.edtn='||''''||pedtn||''''||') or ('||''''||pedtn||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.dist_code='||''''||pdistcd||''''||') or ('||''''||pdistcd||''''||' is null)) and
                               (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,
                               u.city_code,u.state_code,u.dist_code) c
                               group by c.comp_code,c.unit_code,c.agcd,c.dpcd,c.agname,c.agname_oth_lang,nvl(cir_get_city(c.comp_code,c.city_code),''NA''),
                               nvl(cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'')
                               order by c.comp_code,c.unit_code,nvl(cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA''),c.agname';
                    --insert into test1(vstring,vstring2) values('unsold edtn p_accounts',v_query1);COMMIT;
               open p_accounts for v_query1;
    
               v_query1:='select c.comp_code comp_code,c.unit_code unit_code,
               nvl(cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'') dist_name '||tot_vvar||'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,
               u.state_code state_code,u.dist_code dist_code,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.state_code state_code,a.dist_code dist_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               ((b.edtn='||''''||pedtn||''''||') or ('||''''||pedtn||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.dist_code='||''''||pdistcd||''''||') or ('||''''||pdistcd||''''||' is null)) and
                               (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.state_code,u.dist_code) c
                               group by c.comp_code,c.unit_code,nvl(cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'')
                               order by c.comp_code,c.unit_code,nvl(cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'')';
               --insert into test1(vstring,vstring2) values('unsold edtn p_accounts1 ',v_query1);COMMIT;
               open p_accounts1 for v_query1;
    
               v_query1:='select c.comp_code comp_code,c.unit_code unit_code '||tot_vvar||'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.state_code state_code,a.dist_code dist_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               ((b.edtn='||''''||pedtn||''''||') or ('||''''||pedtn||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.dist_code='||''''||pdistcd||''''||') or ('||''''||pdistcd||''''||' is null)) and
                               (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,cir_get_edtn_name(u.comp_code,u.edtn))c
                               group by c.comp_code,c.unit_code
                               order by c.comp_code,c.unit_code';
                --insert into test1(vstring,vstring2) values('unsold edtn p_accounts2 ',v_query1);COMMIT;
               open p_accounts2 for v_query1;
           End if;
                 v_query1:='select '||''''||vtot_publ||''''||' from dual';
                 open p_accounts3 for v_query1;
        Else
            v_query1:='select '||''''||pcomp_code||''''||' comp_code,'||''''||punit_code||''''||' unit_code,null agcd,null dpcd,null agname,null agname_oth_lang,null city_name,null taluka_name,0 supply_copy,0 return_copy from dual';
            --insert into test1(vstring,vstring2) values('unsold else edtn vquery p_accounts',v_query1);COMMIT;
            open p_accounts for v_query1;
            v_query1:='select '||''''||pcomp_code||''''||' comp_code,'||''''||punit_code||''''||' unit_code,null taluka_name,0 supply_copy,0 return_copy from dual';
            --insert into test1(vstring,vstring2) values('unsold else edtn p_accounts1 ',v_query1);COMMIT;
            open p_accounts1 for v_query1;
            v_query1:='select '||''''||pcomp_code||''''||' comp_code,'||''''||punit_code||''''||' unit_code,0 supply_copy,0 return_copy from dual';
            --insert into test1(vstring,vstring2) values('unsold else edtn p_accounts2 ',v_query1);COMMIT;
            open p_accounts2 for v_query1;
                 v_query1:='select null from dual';
             open p_accounts3 for v_query1;
        End if;
  End cir_edtn_unsold_supply_dist;  
  
procedure cir_monthly_net_paid_sale(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pedtn              in varchar2,
     pfromdate          in varchar2,
     ptilldate          in varchar2,
     pagency_type       in varchar2,
     pagency_class      in varchar2,
     pstatecode         in varchar2,
     pdistcode          in varchar2,
     ptaluka            in varchar2,
     pbranch            in varchar2,
     pagcd              in varchar2,
     pdpcd              in varchar2,
     preptype           in number,--1 for Agency Wise,2 for Main Edition wise,3 for District Taluka wise
     pbreak_on          in varchar2,--Region R/State S/District D/Branch B
     preturn_based      in varchar2,--it is use for return date or supply date(R/S)
     plangtype          in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     pextra3            in varchar2,
     pextra4            in varchar2,
     pextra5            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts,
     p_accounts3        out t_accounts)
  As
     v_frdt    date;
     v_todt    date;
     v_reg_code varchar2(200);
     v_avg_sale number(10);
cursor c1 is
    select u.comp_code,u.unit_code,
    u.branch_code branch_code,(select distinct "Branch_Name" from branch_mst where "Branch_Code"=u.branch_code) branch_name,
    u.publ,u.publ_name,u.main_edtn,
    cir_get_edtn_name(u.comp_code,u.main_edtn) main_edtn_name,u.edtn edtn,u.edtn_name,u.copy_rate,
    u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,
    u.state_code,cir_get_state(u.comp_code,u.country_code,u.state_code) state_name,
    u.dist_code ,cir_get_name.cir_district(u.comp_code,u.dist_code,plangtype,null,null,null) dist_name,
    u.city_code city_code,cir_get_name.cir_city(u.comp_code,u.city_code,plangtype,null,null,null) city_name,
    u.tehsil_taluka,cir_get_name.cir_taluka(u.comp_code,u.tehsil_taluka,plangtype,null,null,null) taluka_name,
    sum(supply_copy) supply_copy,sum(return_copy) return_copy,
    sum(supply_copy)-sum(return_copy) net_sale_copy,sum(no_of_days) no_of_days
    from (
    select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate copy_rate,
    b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
    a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka, 
    sum(nvl(b.sup_copy,0)) supply_copy,0 return_copy, count(distinct supdate) no_of_days
    from cir_agmast a,cir_dbksup b,cir_edtn_mast e,cir_publ_mast p
    where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and 
    b.comp_code =pcomp_code and 
    b.unit_code=a.unit and b.unit_code=punit_code and 
    b.publ=p.publ and b.publ=nvl(ppubl,b.publ) and b.edtn=e.edtn and b.edtn=nvl(pedtn,b.edtn) and
    a.agcd=b.agcd and b.agcd=nvl(pagcd,b.agcd) and a.dpcd=b.dpcd and b.dpcd=nvl(pdpcd,b.dpcd) and
    b.supdate >= v_frdt and b.supdate <=v_todt and 
    (a.ag_type=pagency_type or pagency_type is null) and(a.ag_class=pagency_class or pagency_class is null) and
    (a.branch_code=pbranch or pbranch is null) and (a.state_code=pstatecode or pstatecode is null) and
    (a.dist_code=pdistcode or pdistcode is null) and (a.tehsil_taluka=ptaluka or ptaluka is null) and
    (e.main_edtn=pmainedtn or pmainedtn is null)
    group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate,
    b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
    a.country_code,a.tehsil_taluka
    union all
    select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
    b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
    a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka, 
    0 supply_copy,sum(nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0)) return_copy,0 no_of_days
    from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e,cir_publ_mast p
    where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and b.comp_code =pcomp_code and 
    b.unit_code=a.unit and b.unit_code=punit_code and 
    b.doctype='UCN' and b.recptdt >= v_frdt and b.recptdt <=v_todt and 
    b.publ=e.publ and b.publ=p.publ and b.publ=nvl(ppubl,b.publ) and b.edtn=e.edtn and b.edtn=nvl(pedtn,b.edtn) and 
    a.agcd=b.agcd and b.agcd=nvl(pagcd,b.agcd) and a.dpcd=b.dpcd and b.dpcd=nvl(pdpcd,b.dpcd) and 
    (a.ag_type=pagency_type or pagency_type is null) and(a.ag_class=pagency_class or pagency_class is null) and
    (a.branch_code=pbranch or pbranch is null) and (a.state_code=pstatecode or pstatecode is null) and
    (a.dist_code=pdistcode or pdistcode is null) and (a.tehsil_taluka=ptaluka or ptaluka is null) and
    (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0 and
    (e.main_edtn=pmainedtn or pmainedtn is null)
    group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
    b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
    a.country_code,a.tehsil_taluka) u
    where (u.supply_copy+u.return_copy)>0
    group by u.comp_code,u.unit_code,
    u.branch_code,u.publ,u.publ_name,u.main_edtn,u.edtn,u.edtn_name,u.copy_rate,
    u.agcd,u.dpcd,u.agname,u.agname_oth_lang,
    u.state_code,u.dist_code ,u.city_code,u.tehsil_taluka,u.country_code;
            
    v1 c1%rowtype;
   
  Begin
        
        v_frdt         :=to_date(pfromdate,''''||pdateformat||'''');
        v_todt         :=to_date(ptilldate,''''||pdateformat||'''');
        delete from cir_temp_bill_collection where cur_sessionid=userenv('sessionid');
        open c1;
        loop
            fetch c1 into v1;
            exit when c1%notfound;
            /*select count(*) into v_hdays from cir_holiday_mast 
                where comp_code=v1.comp_code and unit=v1.unit_code and (h_publ=ppubl or ppubl is null) and 
                    trunc(h_date,'mm')=v1.mon;*/
            if nvl(v1.no_of_days,0)>0 then
                v_avg_sale:=round(nvl(v1.net_sale_copy,0)/(nvl(v1.no_of_days,0)));
            else
                v_avg_sale:=nvl(v1.net_sale_copy,0);
            end if;
            begin
                select distinct region_code into v_reg_code from cir_city_mast where comp_code=v1.comp_code and city_code=v1.city_code;
            exception when others then
             v_reg_code:=null;
            end;
            
            v_reg_code:=cir_get_region_name(v1.comp_code,v_reg_code); 
            insert into cir_temp_bill_collection
            (comp_code, unit_code, billno, publ_code, agcd, dpcd,agname,agname_oth_lang, city_code, 
            taluka_code, dist_code, state_code, remarks,supply_copy, return_copy ,comm_amt,gross_amt,cur_sessionid)
            values(v1.comp_code,v1.unit_code,v1.branch_name,v1.publ_name,v1.main_edtn_name,v1.edtn_name,v1.agname,v1.agname_oth_lang,v1.city_name,
            v1.taluka_name,v1.dist_name,v1.state_name,v_reg_code,v1.supply_copy,v1.return_copy,v1.copy_rate,v1.no_of_days,userenv('sessionid'));

        end loop;
        close c1;
        commit;
        if preptype=1 then
            if pbreak_on='R' then
                open p_accounts for
                select comp_code AS "COMP_CODE", unit_code AS "UNIT",agname AS "AGNAME",agname_oth_lang AS "AGNAME_OTH_LANG",city_code as "CITY_NAME", 
                remarks AS "REGION_NAME",comm_amt as "COPY_RATE",supply_copy AS "SUPPLY_COPY", return_copy AS "RETURN_COPY" ,(supply_copy-return_copy) AS "NET_SALE",
                case when nvl(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as "NET_PER",
                gross_amt AS "NO_OF_DAYS",case when nvl(gross_amt,0)>0 then round((supply_copy-return_copy)/gross_amt) else 0 end AS "AVG_NET_SALE" 
                from cir_temp_bill_collection where cur_sessionid=userenv('sessionid') order by remarks,agname,city_name,copy_rate;

                open p_accounts1 for
                select comp_code AS "COMP_CODE",  
                remarks AS "REGION_NAME",sum(supply_copy) AS "SUPPLY_COPY", sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",
                case when nvl(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as "NET_PER",
                0 AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from cir_temp_bill_collection where cur_sessionid=userenv('sessionid') 
                group by comp_code,remarks order by region_name;            
            elsif pbreak_on='S' then
                open p_accounts for
                select comp_code AS "COMP_CODE", unit_code AS "UNIT",agname AS "AGNAME",agname_oth_lang AS "AGNAME_OTH_LANG",city_code as "CITY_NAME", 
                state_code AS "STATE_NAME",comm_amt as "COPY_RATE",supply_copy AS "SUPPLY_COPY", return_copy AS "RETURN_COPY" ,(supply_copy-return_copy) AS "NET_SALE",
                case when nvl(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as "NET_PER",
                gross_amt AS "NO_OF_DAYS",case when nvl(gross_amt,0)>0 then round((supply_copy-return_copy)/gross_amt) else 0 end AS "AVG_NET_SALE" 
                from cir_temp_bill_collection where cur_sessionid=userenv('sessionid') 
                order by state_name,agname,city_name,comm_amt;

                open p_accounts1 for
                select comp_code AS "COMP_CODE",  
                state_code AS "STATE_NAME",sum(supply_copy) AS "SUPPLY_COPY", sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",
                case when nvl(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as "NET_PER",
                0 AS "NO_OF_DAYS",case when nvl(sum(gross_amt),0)>0 then round(sum(supply_copy-return_copy)/sum(gross_amt)) else 0 end AS "AVG_NET_SALE"
                from cir_temp_bill_collection where cur_sessionid=userenv('sessionid') 
                group by comp_code,state_code order by state_name;                
            elsif pbreak_on='D' then
                open p_accounts for
                select comp_code AS "COMP_CODE", unit_code AS "UNIT",agname AS "AGNAME",agname_oth_lang AS "AGNAME_OTH_LANG",city_code as "CITY_NAME", 
                state_code AS "STATE_NAME",dist_code AS "DIST_NAME",comm_amt as "COPY_RATE",supply_copy AS "SUPPLY_COPY", return_copy AS "RETURN_COPY" ,(supply_copy-return_copy) AS "NET_SALE",
                case when nvl(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as "NET_PER",
                gross_amt AS "NO_OF_DAYS",case when nvl(gross_amt,0)>0 then round((supply_copy-return_copy)/gross_amt) else 0 end AS "AVG_NET_SALE"
                from cir_temp_bill_collection where cur_sessionid=userenv('sessionid') order by state_name,dist_name,agname,city_name,comm_amt;

                open p_accounts1 for
                select comp_code AS "COMP_CODE",  
                state_code AS "STATE_NAME",dist_code AS "DIST_NAME",sum(supply_copy) AS "SUPPLY_COPY", sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",
                case when nvl(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as "NET_PER", 
                0 AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from cir_temp_bill_collection where cur_sessionid=userenv('sessionid') 
                group by comp_code,state_code,dist_code order by state_name,dist_name;
            elsif pbreak_on='B' then
                open p_accounts for
                select comp_code AS "COMP_CODE", unit_code AS "UNIT",agname AS "AGNAME",agname_oth_lang AS "AGNAME_OTH_LANG",city_code as "CITY_NAME", 
                billno AS "BRANCH_NAME",comm_amt as "COPY_RATE",supply_copy AS "SUPPLY_COPY", return_copy AS "RETURN_COPY" ,(supply_copy-return_copy) AS "NET_SALE",
                case when nvl(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as "NET_PER",
                gross_amt AS "NO_OF_DAYS",case when nvl(gross_amt,0)>0 then round((supply_copy-return_copy)/gross_amt) else 0 end AS "AVG_NET_SALE"
                from cir_temp_bill_collection where cur_sessionid=userenv('sessionid') order by branch_name,agname,city_name,comm_amt;

                open p_accounts1 for
                select comp_code AS "COMP_CODE",  
                billno AS "BRANCH_NAME",sum(supply_copy) AS "SUPPLY_COPY", sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",
                case when nvl(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as "NET_PER",
                0 AS "NO_OF_DAYS", 0 AS "AVG_NET_SALE"
                from cir_temp_bill_collection where cur_sessionid=userenv('sessionid') 
                group by comp_code,billno order by branch_name;                
            end if;
        elsif preptype=2 then--for edition wise
                open p_accounts for
                select comp_code AS "COMP_CODE",  publ_code AS "PUBL_NAME",agcd AS "MAIN_EDTN_NAME",dpcd AS "EDTN_NAME",comm_amt as "COPY_RATE", sum(supply_copy) AS "SUPPLY_COPY", 
                sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",
                case when nvl(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as "NET_PER",
                max(gross_amt) AS "NO_OF_DAYS",case when nvl(max(gross_amt),0)>0 then round(sum(supply_copy-return_copy)/max(gross_amt)) else 0 end AS "AVG_NET_SALE"
                from cir_temp_bill_collection where cur_sessionid=userenv('sessionid') group by comp_code,publ_code,agcd,dpcd,comm_amt order by publ_name,main_edtn_name,edtn_name,copy_rate;

                open p_accounts1 for
                select comp_code AS "COMP_CODE",  publ_code AS "PUBL_NAME",agcd AS "MAIN_EDTN_NAME",sum(supply_copy) AS "SUPPLY_COPY", 
                sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",
                case when nvl(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as "NET_PER",
                max(gross_amt) AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from cir_temp_bill_collection where cur_sessionid=userenv('sessionid') group by comp_code,publ_code,agcd order by publ_name,main_edtn_name;
        else
                open p_accounts for
                select comp_code AS "COMP_CODE", 
                state_code AS "STATE_NAME",dist_code AS "DIST_NAME",taluka_code AS "TALUKA_NAME",
                comm_amt as "COPY_RATE",sum(supply_copy) AS "SUPPLY_COPY", sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",
                case when nvl(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as "NET_PER",
                max(gross_amt) AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from cir_temp_bill_collection where cur_sessionid=userenv('sessionid') 
                group by comp_code,state_code,dist_code,taluka_code,comm_amt order by state_name,dist_name,taluka_name,comm_amt;

                open p_accounts1 for
                select comp_code AS "COMP_CODE", 
                state_code AS "STATE_NAME",dist_code AS "DIST_NAME",
                sum(supply_copy) AS "SUPPLY_COPY", sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",
                case when nvl(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as "NET_PER",
                max(gross_amt) AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from cir_temp_bill_collection where cur_sessionid=userenv('sessionid') 
                group by comp_code,state_code,dist_code order by state_name,dist_name;
        end if;
        
        --open p_accounts1 for select sysdate as "CUR_DATE" from dual;
        open p_accounts2 for select sysdate as "CUR_DATE" from dual;
        open p_accounts3 for select sysdate as "CUR_DATE" from dual;
        delete from cir_temp_bill_collection where cur_sessionid=userenv('sessionid');
    
  End cir_monthly_net_paid_sale;

  procedure cir_rep_unsold_slip(
    pcompcode       in varchar2,
    punitcode       in varchar2,
    pbrancode       in varchar2,
    pdoctype        in varchar2,
    pdistcode       in varchar2,
    ptalukacode     in varchar2,
    pagcode         in varchar2,
    pagsubcode      in varchar2,
    pfrom_recdate   in varchar2,
    ptill_recdate   in varchar2,
    papproved_flag  in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,--Blank for Agency and 'D' for Distribution
    p_accounts      out t_accounts)
  As
       v_frdt    date;
       v_todt    date;
  Begin
       v_frdt:=to_date(pfrom_recdate,''''||pdateformat||'''');
       v_todt:=to_date(ptill_recdate,''''||pdateformat||'''');
       
        if upper(nvl(papproved_flag,'N'))='Y' then
            if pextra2='D' then
               open p_accounts for
               select b.comp_code comp_code,b.unit_code unit_code,b.doctype doctype,b.publ publ,cir_get_name.cir_publ(b.comp_code,b.publ,'1','dd/mm/yyyy','','') publ_name,
                      b.edtn edtn,cir_get_name.cir_edtn(b.comp_code,b.unit_code,b.edtn,'1','dd/mm/yyyy','','') edtn_name,
                      b.recptno recptno,b.recptdt recptdt,
                      b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,cir_get_city(b.comp_code,a.city_code) city_name,
                      b.copy_rate copy_rate,h.frdt frdt,h.todt todt,
                      sum(b.apr_short_recpt) short_recpt,sum(b.apr_late_recpt) late_recpt,sum(b.apr_bnr) bnr,sum(b.apr_unsold) unsold,
                      sum(nvl(b.copy_rate,0)*(nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0))) gross_amt,
                      sum(b.comm_amt) comm_amt,sum(b.waste_amt) waste_amt,nvl(sum(b.copy_amt),0) amount,
                      nvl(sum(b.copy_amt),0)-nvl(sum(b.waste_amt),0)net_amt 
                   from cir_agmast_dis a,cir_unsold_dtl_dis b,cir_unsold_hdr_dis h
                   where b.comp_code =a.comp_code and b.comp_code =pcompcode and b.comp_code =h.comp_code and 
                        b.unit_code=a.unit and b.unit_code=h.unit_code and b.unit_code=punitcode and 
                        b.doctype=pdoctype and b.doctype=h.doctype and b.recptdt between v_frdt and v_todt and
                        b.recptno=h.recptno and a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd=pagcode) or (pagcode is null)) and 
                        ((b.dpcd=pagsubcode) or (pagsubcode is null)) and ((a.dist_code=pdistcode) or (pdistcode is null)) and
                        ((a.tehsil_taluka=ptalukacode) or (ptalukacode is null)) and a.branch_code=nvl(pbrancode,a.branch_code) and
                        (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0
                        group by b.comp_code,b.unit_code,b.doctype,b.publ,b.edtn,b.recptno,b.recptdt,h.frdt,h.todt,
                                 b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.city_code,b.copy_rate 
                        order by b.agcd,b.dpcd,b.recptdt,b.recptno,b.publ,b.edtn;
            else
               open p_accounts for
               select b.comp_code comp_code,b.unit_code unit_code,b.doctype doctype,b.publ publ,cir_get_name.cir_publ(b.comp_code,b.publ,'1','dd/mm/yyyy','','') publ_name,
                      b.edtn edtn,cir_get_name.cir_edtn(b.comp_code,b.unit_code,b.edtn,'1','dd/mm/yyyy','','') edtn_name,
                      b.recptno recptno,b.recptdt recptdt,
                      b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,cir_get_city(b.comp_code,a.city_code) city_name,
                      b.copy_rate copy_rate,h.frdt frdt,h.todt todt,
                      sum(b.apr_short_recpt) short_recpt,sum(b.apr_late_recpt) late_recpt,sum(b.apr_bnr) bnr,sum(b.apr_unsold) unsold,
                      sum(nvl(b.copy_rate,0)*(nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0))) gross_amt,
                      sum(b.comm_amt) comm_amt,sum(b.waste_amt) waste_amt,nvl(sum(b.copy_amt),0) amount,
                      nvl(sum(b.copy_amt),0)-nvl(sum(b.waste_amt),0)net_amt 
                   from cir_agmast a,cir_unsold_dtl b,cir_unsold_hdr h
                   where b.comp_code =a.comp_code and b.comp_code =pcompcode and b.comp_code =h.comp_code and 
                        b.unit_code=a.unit and b.unit_code=h.unit_code and b.unit_code=punitcode and 
                        b.doctype=pdoctype and b.doctype=h.doctype and b.recptdt between v_frdt and v_todt and
                        b.recptno=h.recptno and a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd=pagcode) or (pagcode is null)) and 
                        ((b.dpcd=pagsubcode) or (pagsubcode is null)) and ((a.dist_code=pdistcode) or (pdistcode is null)) and
                        ((a.tehsil_taluka=ptalukacode) or (ptalukacode is null)) and a.branch_code=nvl(pbrancode,a.branch_code) and
                        (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0
                        group by b.comp_code,b.unit_code,b.doctype,b.publ,b.edtn,b.recptno,b.recptdt,h.frdt,h.todt,
                                 b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.city_code,b.copy_rate 
                        order by b.agcd,b.dpcd,b.recptdt,b.recptno,b.publ,b.edtn;            
            end if;            
        else
            if pextra2='D' then
               open p_accounts for
               select b.comp_code comp_code,b.unit_code unit_code,b.doctype doctype,b.publ publ,cir_get_name.cir_publ(b.comp_code,b.publ,'1','dd/mm/yyyy','','') publ_name,
                      b.edtn edtn,cir_get_name.cir_edtn(b.comp_code,b.unit_code,b.edtn,'1','dd/mm/yyyy','','') edtn_name,b.recptno recptno,b.recptdt recptdt,
                      b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,cir_get_city(b.comp_code,a.city_code) city_name,
                      b.copy_rate copy_rate,h.frdt frdt,h.todt todt,
                      sum(b.short_recpt) short_recpt,sum(b.late_recpt) late_recpt,sum(b.bnr) bnr,sum(b.unsold) unsold,
                      sum(nvl(b.copy_rate,0)*(nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0))) gross_amt,sum(b.comm_amt) comm_amt,
                      sum(b.waste_amt) waste_amt,nvl(sum(b.copy_amt),0) amount,
                      nvl(sum(b.copy_amt),0)-nvl(sum(b.waste_amt),0) net_amt 
                   from cir_agmast_dis a,cir_unsold_dtl_dis b,cir_unsold_hdr_dis h
                   where b.comp_code =a.comp_code and b.comp_code =pcompcode and b.comp_code =h.comp_code and 
                        b.unit_code=a.unit and b.unit_code=h.unit_code and b.unit_code=punitcode and 
                        b.doctype=pdoctype and b.doctype=h.doctype and b.recptdt between v_frdt and v_todt and
                        b.recptno=h.recptno and a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd=pagcode) or (pagcode is null)) and 
                        ((b.dpcd=pagsubcode) or (pagsubcode is null)) and ((a.dist_code=pdistcode) or (pdistcode is null)) and
                        ((a.tehsil_taluka=ptalukacode) or (ptalukacode is null)) and a.branch_code=nvl(pbrancode,a.branch_code) and
                        (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0
                        group by b.comp_code,b.unit_code,b.doctype,b.publ,b.edtn,b.recptno,b.recptdt,h.frdt,h.todt,
                                 b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.city_code,b.copy_rate 
                        order by b.agcd,b.dpcd,b.recptdt,b.recptno,b.publ,b.edtn;
            else
               open p_accounts for
               select b.comp_code comp_code,b.unit_code unit_code,b.doctype doctype,b.publ publ,cir_get_name.cir_publ(b.comp_code,b.publ,'1','dd/mm/yyyy','','') publ_name,
                      b.edtn edtn,cir_get_name.cir_edtn(b.comp_code,b.unit_code,b.edtn,'1','dd/mm/yyyy','','') edtn_name,b.recptno recptno,b.recptdt recptdt,
                      b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,cir_get_city(b.comp_code,a.city_code) city_name,
                      b.copy_rate copy_rate,h.frdt frdt,h.todt todt,
                      sum(b.short_recpt) short_recpt,sum(b.late_recpt) late_recpt,sum(b.bnr) bnr,sum(b.unsold) unsold,
                      sum(nvl(b.copy_rate,0)*(nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0))) gross_amt,sum(b.comm_amt) comm_amt,
                      sum(b.waste_amt) waste_amt,nvl(sum(b.copy_amt),0) amount,
                      nvl(sum(b.copy_amt),0)-nvl(sum(b.waste_amt),0) net_amt 
                   from cir_agmast a,cir_unsold_dtl b,cir_unsold_hdr h
                   where b.comp_code =a.comp_code and b.comp_code =pcompcode and b.comp_code =h.comp_code and 
                        b.unit_code=a.unit and b.unit_code=h.unit_code and b.unit_code=punitcode and 
                        b.doctype=pdoctype and b.doctype=h.doctype and b.recptdt between v_frdt and v_todt and
                        b.recptno=h.recptno and a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd=pagcode) or (pagcode is null)) and 
                        ((b.dpcd=pagsubcode) or (pagsubcode is null)) and ((a.dist_code=pdistcode) or (pdistcode is null)) and
                        ((a.tehsil_taluka=ptalukacode) or (ptalukacode is null)) and a.branch_code=nvl(pbrancode,a.branch_code) and
                        (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0
                        group by b.comp_code,b.unit_code,b.doctype,b.publ,b.edtn,b.recptno,b.recptdt,h.frdt,h.todt,
                                 b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.city_code,b.copy_rate 
                        order by b.agcd,b.dpcd,b.recptdt,b.recptno,b.publ,b.edtn;            
            end if;             
       end if;
  End cir_rep_unsold_slip;

/*
var v1 refcursor;
var v2 refcursor;
var v3 refcursor;
var v4 refcursor;
var v5 refcursor;
var v6 refcursor;
exec cir_rep_unsold_supply.cir_unsold_return_punya('SP002','AUR','','UCN','','','','','','','','01-jun-2010','30-sep-2010','N','1','dd/mm/yyyy','','',:v1,:v2,:v3,:v4,:v5,:v6);
*/

    procedure cir_unsold_return_punya(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pbran_code         in varchar2,
     pdoc_type          in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pdistcode          in varchar2,
     ptalukacode        in varchar2,
     pcitycode          in varchar2,
     pagcode            in varchar2,
     pdepocode          in varchar2,
     pfrom_recdate      in varchar2,
     ptill_recdate      in varchar2,
     papproved_flag     in varchar2,
     plangtype          in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts,
     p_accounts3        out t_accounts,
     p_accounts5        out t_accounts,
     p_accounts6        out t_accounts)
   As
    v_frdt     date;
    v_todt    date;
    v_query1  varchar2(32000); 
       cursor cur_edtn is
           select distinct u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.main_edtn edtn,u.copy_rate copy_rate,
            cir_get_edtn_seqno(u.comp_code,u.main_edtn) edtn_seqno from
         (select distinct b.comp_code comp_code,b.unit_code unit_code,c.publ publ,c.main_edtn main_edtn,b.copy_rate copy_rate 
         from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast c
         where b.comp_code = a.comp_code and b.comp_code = c.comp_code and b.comp_code = pcomp_code and 
         b.unit_code = a.unit and b.unit_code = punit_code and 
         b.doctype=pdoc_type and b.recptdt <=v_todt and 
         b.publ=nvl(ppubl,b.publ) and c.main_edtn=nvl(pmainedtn,c.main_edtn) and
         b.publ=c.publ and b.edtn=c.edtn and     
         a.agcd=b.agcd and a.dpcd=b.dpcd and b.agcd=nvl(pagcode,b.agcd) and 
         b.dpcd=nvl(pdepocode,b.dpcd) and (a.tehsil_taluka=ptalukacode or ptalukacode is null) and
         (a.dist_code=pdistcode or pdistcode is null) and a.city_code=nvl(pcitycode,a.city_code) and
         b.branch_code=nvl(pbran_code,b.branch_code)
         union
         select distinct b.comp_code comp_code,b.unit_code unit_code,b.publ_code publ,c.main_edtn main_edtn,b.edtn_rate copy_rate 
         from cir_agmast a,cir_branch_return_det b,cir_edtn_mast c 
         where a.comp_code=b.comp_code and a.comp_code=c.comp_code and b.comp_code = pcomp_code and 
         a.unit=b.unit_code and a.unit=c.unit_code and b.unit_code = punit_code and 
         b.recptdt >= v_frdt and b.recptdt<=v_todt and b.publ_code=nvl(ppubl,b.publ_code) and 
         c.main_edtn=nvl(pmainedtn,c.main_edtn) and b.publ_code=c.publ and b.edtn_code=c.edtn and     
         (a.tehsil_taluka=ptalukacode or ptalukacode is null) and
         (a.dist_code=pdistcode or pdistcode is null) and a.city_code=nvl(pcitycode,a.city_code) and
         b.branch_code=nvl(pbran_code,b.branch_code)
         union
         select distinct b.comp_code comp_code,b.unit_code unit_code,c.publ publ,c.main_edtn main_edtn,b.copy_rate copy_rate 
         from cir_agmast_dis a,cir_unsold_dtl_dis b,cir_edtn_mast c
         where b.comp_code = a.comp_code and b.comp_code = c.comp_code and b.comp_code = pcomp_code and 
         b.unit_code = a.unit and b.unit_code = punit_code and 
         b.doctype=pdoc_type and b.recptdt <=v_todt and 
         b.publ=nvl(ppubl,b.publ) and c.main_edtn=nvl(pmainedtn,c.main_edtn) and
         b.publ=c.publ and b.edtn=c.edtn and     
         a.agcd=b.agcd and a.dpcd=b.dpcd and b.agcd=nvl(pagcode,b.agcd) and 
         b.dpcd=nvl(pdepocode,b.dpcd) and (a.tehsil_taluka=ptalukacode or ptalukacode is null) and
         (a.dist_code=pdistcode or pdistcode is null) and a.city_code=nvl(pcitycode,a.city_code) and
         b.branch_code=nvl(pbran_code,b.branch_code)
         union
         select distinct b.comp_code comp_code,b.unit_code unit_code,b.publ_code publ,c.main_edtn main_edtn,b.edtn_rate copy_rate 
         from cir_agmast a,cir_return_sale_det b,cir_edtn_mast c 
         where a.comp_code=b.comp_code and a.comp_code=c.comp_code and b.comp_code = pcomp_code and 
         a.unit=b.unit_code and a.unit=c.unit_code and b.unit_code = punit_code and 
         b.doctype='RET' and b.recptdt >= v_frdt and b.recptdt<=v_todt and b.publ_code=nvl(ppubl,b.publ_code) and 
         c.main_edtn=nvl(pmainedtn,c.main_edtn) and b.publ_code=c.publ and b.edtn_code=c.edtn and     
         (a.tehsil_taluka=ptalukacode or ptalukacode is null) and
         (a.dist_code=pdistcode or pdistcode is null) and a.city_code=nvl(pcitycode,a.city_code) and
         b.branch_code=nvl(pbran_code,b.branch_code)
         union
         select distinct b.comp_code comp_code,b.unit_code unit_code,b.publ_code publ,c.main_edtn main_edtn,b.edtn_rate copy_rate 
         from cir_physical_ver_det b,cir_edtn_mast c
            where b.comp_code = pcomp_code and 
            b.unit_code=c.unit_code and b.unit_code = punit_code and 
         b.recptdt<=v_todt and b.publ_code=nvl(ppubl,b.publ_code) and 
         c.main_edtn=nvl(pmainedtn,c.main_edtn) and b.publ_code=c.publ and b.edtn_code=c.edtn and     
         b.branch_code=nvl(pbran_code,b.branch_code)
         union
         select distinct b.comp_code comp_code,b.unit_code unit_code,b.publ publ,c.main_edtn main_edtn,b.sup_rate copy_rate 
         from cir_agmast a,cir_dbksup_resale b,cir_edtn_mast c
            where b.comp_code = a.comp_code and b.comp_code = c.comp_code and b.comp_code = pcomp_code and 
                  b.unit_code = a.unit and b.unit_code = punit_code and 
                  b.publ=nvl(ppubl,b.publ) and 
                  c.main_edtn=nvl(pmainedtn,c.main_edtn) and
                  b.publ=c.publ and b.edtn=c.edtn and
                  b.supdate >= v_frdt and b.supdate<=v_todt and 
                  a.agcd=b.agcd and a.dpcd=b.dpcd and b.agcd=nvl(pagcode,b.agcd) and 
                  b.dpcd=nvl(pdepocode,b.dpcd) and (a.tehsil_taluka=ptalukacode or ptalukacode is null) and
                  (a.dist_code=pdistcode or pdistcode is null) and a.city_code=nvl(pcitycode,a.city_code) and
                  b.resale_branch=nvl(pbran_code,b.resale_branch) and
                  nvl(b.sup_copy,0)>0 and nvl(b.return_copy_sale,'N')='Y') u                  
         order by publ,edtn_seqno,edtn,copy_rate;
     rec_edtn cur_edtn%rowtype;
     vvar       varchar2(8000);
     tot_vvar   varchar2(8000);
     vtot_publ  varchar2(4000);
     v_cnt      number:=0;
     v_opbal_unsold    number(10):=0;v_op_branch_rec   number(10):=0;v_op_branch_trf   number(10):=0;v_op_sale number(10):=0;
      v_op_resale number(10):=0;v_op_comp_ret number(10):=0;v_op_short_excess number(10):=0;
      
      v_opbal           number(10):=0;

  Begin
       --insert into aaa_test values (pcomp_code||'-'||punit_code ||'-'||pbran_code||'-'||pdoc_type||'-'||ppubl||'-'||pmainedtn||'-'||pdistcode||'-'||ptalukacode||'-'||pcitycode||'-'||pagcode||'-'||pdepocode||'-'||pfrom_recdate||'-'||ptill_recdate||'-'||papproved_flag||'-'||plangtype||'-'||pdateformat||'-'||pextra1||'-'||pextra2||'*'||'pcomp_code'||'-'||'punit_code'||'-'||'pbran_code'||'-'||'pdoc_type'||'-'||'ppubl'||'-'||'pmainedtn'||'-'||'pdistcode'||'-'||'ptalukacode'||'-'||'pcitycode'||'-'||'pagcode'||'-'||'pdepocode'||'-'||'pfrom_recdate'||'-'||'ptill_recdate'||'-'||'papproved_flag'||'-'||'plangtype'||'-'||'pdateformat'||'-'||'pextra1'||'-'||'pextra2');commit;
       --delete from test1;
       delete from cir_temp_unsold_stock where sess_id=userenv('sessionid');
       
       v_frdt:=to_date(pfrom_recdate,''''||pdateformat||'''');
       v_todt:=to_date(ptill_recdate,''''||pdateformat||'''');
    open cur_edtn;
    loop
        fetch cur_edtn into rec_edtn;
      exit when cur_edtn%notfound;
          v_cnt :=nvl(v_cnt,0)+1;
          if vvar is null then
              vvar    :='decode(u.edtn||u.copy_rate,'||''''||rec_edtn.edtn||rec_edtn.copy_rate||''''||',sum(u.return_copy))"'||rec_edtn.edtn||'_'||rec_edtn.copy_rate||'"';
              tot_vvar:=',sum("'||rec_edtn.edtn||'_'||rec_edtn.copy_rate||'") "'||rec_edtn.edtn||'_'||rec_edtn.copy_rate||'"';
          else
              vvar    :=vvar||',decode(u.edtn||u.copy_rate,'||''''||rec_edtn.edtn||rec_edtn.copy_rate||''''||',sum(u.return_copy))"'||rec_edtn.edtn||'_'||rec_edtn.copy_rate||'"';
              tot_vvar:=tot_vvar||',sum("'||rec_edtn.edtn||'_'||rec_edtn.copy_rate||'") "'||rec_edtn.edtn||'_'||rec_edtn.copy_rate||'"';
          end if;    
    
            select nvl(sum(nvl(a.apr_short_recpt,0)+nvl(a.apr_late_recpt,0)+nvl(a.apr_bnr,0)+nvl(a.apr_unsold,0)),0) into v_opbal_unsold 
            from cir_unsold_dtl a,cir_edtn_mast b 
            where a.comp_code=b.comp_code and a.comp_code=pcomp_code and a.unit_code=b.unit_code and a.unit_code=punit_code and 
            a.doctype='UCN' and a.recptdt<v_frdt and a.publ=b.publ and a.publ=rec_edtn.publ and a.edtn=b.edtn and b.main_edtn=rec_edtn.edtn and
            a.copy_rate=rec_edtn.copy_rate and a.branch_code=NVL(pbran_code,a.branch_code);

            select nvl(sum(a.edtn_copy),0) into v_op_branch_rec from cir_branch_return_det a,cir_edtn_mast b 
                where a.comp_code=b.comp_code and a.comp_code=pcomp_code and a.unit_code=b.unit_code and a.unit_code=punit_code and 
                a.doctype='TI' and a.recptdt<v_frdt and
                a.publ_code=b.publ and a.publ_code=rec_edtn.publ and a.edtn_code=b.edtn and b.main_edtn=rec_edtn.edtn and 
                a.edtn_rate=rec_edtn.copy_rate and (a.branch_code=pbran_code or pbran_code is null);

            select nvl(sum(a.edtn_copy),0) into v_op_branch_trf from cir_branch_return_det a,cir_edtn_mast b 
                where a.comp_code=b.comp_code and a.comp_code=pcomp_code and a.unit_code=b.unit_code and a.unit_code=punit_code and a.doctype='TRF' and a.recptdt<v_frdt and
                a.publ_code=b.publ and a.publ_code=rec_edtn.publ and a.edtn_code=b.edtn and b.main_edtn=rec_edtn.edtn and a.edtn_rate=rec_edtn.copy_rate and (a.branch_code=pbran_code or pbran_code is null);
            
            select nvl(sum(nvl(a.no_of_copy,0)),0) into v_op_sale from cir_return_sale_det a,cir_edtn_mast b
                where a.comp_code=b.comp_code and a.comp_code=pcomp_code and a.unit_code=b.unit_code and a.unit_code=punit_code and 
                a.doctype='RET' and a.recptdt<v_frdt and
                a.publ_code=b.publ and a.publ_code=rec_edtn.publ and a.edtn_code=b.edtn and b.main_edtn=rec_edtn.edtn and a.edtn_rate=rec_edtn.copy_rate and (branch_code=pbran_code or pbran_code is null);

            select nvl(sum(nvl(a.apr_short_recpt,0)+nvl(a.apr_late_recpt,0)+nvl(a.apr_bnr,0)+nvl(a.apr_unsold,0)),0) into v_op_comp_ret
            from cir_unsold_dtl_dis a,cir_edtn_mast b 
            where a.comp_code=b.comp_code and a.comp_code=pcomp_code and a.unit_code=b.unit_code and a.unit_code=punit_code and 
            a.doctype='UCN' and a.recptdt<v_frdt and a.publ=b.publ and a.publ=rec_edtn.publ and a.edtn=b.edtn and b.main_edtn=rec_edtn.edtn and
            a.copy_rate=rec_edtn.copy_rate and a.branch_code=NVL(pbran_code,a.branch_code);

            select nvl(sum(a.sup_copy),0) into v_op_resale from cir_dbksup_resale a,cir_edtn_mast b,cir_agmast c
                where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=pcomp_code and a.unit_code=b.unit_code and a.unit_code=c.unit and a.unit_code=punit_code and 
                a.agcd=c.agcd and a.dpcd=c.dpcd and a.publ=b.publ and a.publ=rec_edtn.publ and a.edtn=b.edtn and b.main_edtn=rec_edtn.edtn and
                      supdate<v_todt and sup_rate=rec_edtn.copy_rate and nvl(return_copy_sale,'N')='Y' and (a.resale_branch=pbran_code or pbran_code is null); 
            
            select nvl(sum(nvl(a.short_excess,1)*nvl(a.no_of_copy,0)),0) into v_op_short_excess from cir_physical_ver_det a,cir_edtn_mast b
                where a.comp_code=b.comp_code and a.comp_code=pcomp_code and a.unit_code=b.unit_code and a.unit_code=punit_code and a.doctype='VR' and a.recptdt<v_frdt and
                a.publ_code=b.publ and a.publ_code=rec_edtn.publ and a.edtn_code=b.edtn and b.main_edtn=rec_edtn.edtn and a.edtn_rate=rec_edtn.copy_rate and (a.branch_code=pbran_code or pbran_code is null);
            /*-------for opening balance ----------*/

            
            v_opbal:=nvl(v_opbal_unsold,0)+nvl(v_op_branch_rec,0)-nvl(v_op_comp_ret,0)-nvl(v_op_branch_trf,0)-nvl(v_op_sale,0)-nvl(v_op_resale,0)+nvl(v_op_short_excess,0);

            insert into cir_temp_unsold_stock(comp_code,unit_code,branch_code,publ_code,edtn_code,ason_dt,copy_rate,
                    opbal,sess_id)
                    values(pcomp_code,punit_code,pbran_code,rec_edtn.publ,rec_edtn.edtn,v_todt,rec_edtn.copy_rate,v_opbal,userenv('sessionid'));
    end loop;
    close cur_edtn;
    commit;
   -- insert into test1(vstring,vstring2) values(' vvar '||vvar,'tot_vvar '||tot_vvar); --commit;
    if vvar is not null then
       If nvl(papproved_flag,'N')='Y' Then
           v_query1:='select c.comp_code comp_code,c.unit_code unit_code,c.agcd agcd,c.dpcd dpcd,c.agname agname,c.agname_oth_lang agname_oth_lang,
           nvl(cir_get_name.cir_city(c.comp_code,c.city_code,'||''||plangtype||''||','''','''',''''),''NA'') city_name,
           nvl(cir_get_name.cir_taluka(c.comp_code,c.taluka_code,'||''||plangtype||''||','''','''',''''),''NA'') taluka_name '||tot_vvar||'
           from
           (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,
           u.copy_rate copy_rate,u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,u.city_code city_code,u.taluka_code taluka_code,'||vvar
           ||' from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,e.main_edtn edtn,b.copy_rate copy_rate,
               b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
               a.city_code city_code,a.tehsil_taluka taluka_code,
               nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0) return_copy
               from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
               where b.comp_code =a.comp_code and b.comp_code =e.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                   b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code='||''''||punit_code||''''||' and 
                   b.doctype='||''''||pdoc_type||''''||' and b.recptdt >= '||''''||v_frdt||''''||' and b.recptdt<='||''''||v_todt||''''||' and 
                   a.agcd=b.agcd and a.dpcd=b.dpcd and b.agcd=nvl('||''''||pagcode||''''||',b.agcd) and 
                   b.dpcd=nvl('||''''||pdepocode||''''||',b.dpcd) and b.publ=nvl('||''''||ppubl||''''||',b.publ) and
                   b.publ=e.publ and b.edtn=e.edtn and e.main_edtn=nvl('||''''||pmainedtn||''''||',e.main_edtn) and
                   (a.tehsil_taluka='||''''||ptalukacode||''''||' or '||''''||ptalukacode||''''||' is null) and
                   b.branch_code=nvl('||''''||pbran_code||''''||',b.branch_code) and
                   (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0) u
                   where u.return_copy>0
                   group by u.comp_code,u.unit_code,u.publ,u.edtn,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,
                   u.city_code,u.taluka_code,u.copy_rate) c
                   group by c.comp_code,c.unit_code,c.agcd,c.dpcd,c.agname,c.agname_oth_lang,c.city_code,c.taluka_code
                   order by c.comp_code,c.unit_code,taluka_name,c.agname';
                                              
           --insert into test1(vstring,vstring2) values('unsold edtn YY ',v_query1);COMMIT;
           open p_accounts for v_query1;           
               
           v_query1:='select c.comp_code comp_code,c.unit_code unit_code,
           nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA'') taluka_name '||tot_vvar||'
           from
           (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,u.copy_rate copy_rate,
           u.taluka_code taluka_code,'||vvar
           ||'  from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,e.main_edtn edtn,b.copy_rate copy_rate,
                b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                a.city_code city_code,a.tehsil_taluka taluka_code,
                nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0) return_copy
               from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
               where b.comp_code =a.comp_code and b.comp_code =e.comp_code and b.comp_code ='||''''||pcomp_code||''''||' and 
               b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code='||''''||punit_code||''''||' and 
               b.doctype='||''''||pdoc_type||''''||' and b.recptdt >= '||''''||v_frdt||''''||' and b.recptdt<='||''''||v_todt||''''||' and 
               a.agcd=b.agcd and a.dpcd=b.dpcd and b.agcd=nvl('||''''||pagcode||''''||',b.agcd) and 
               b.dpcd=nvl('||''''||pdepocode||''''||',b.dpcd) and b.publ=nvl('||''''||ppubl||''''||',b.publ) and
               b.publ=e.publ and b.edtn=e.edtn and e.main_edtn=nvl('||''''||pmainedtn||''''||',e.main_edtn) and
               (a.tehsil_taluka='||''''||ptalukacode||''''||' or '||''''||ptalukacode||''''||' is null) and
               b.branch_code=nvl('||''''||pbran_code||''''||',b.branch_code) and
               (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0) u
               where u.return_copy>0
               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.copy_rate,u.taluka_code) c
               group by c.comp_code,c.unit_code,c.taluka_code
               order by c.comp_code,c.unit_code,taluka_name';
                
            --insert into test1(vstring,vstring2) values('unsold edtn v_query2 ',v_query1);COMMIT;
            open p_accounts1 for v_query1;
               
           v_query1:='select c.comp_code comp_code,c.unit_code unit_code '||tot_vvar||'
           from
           (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,u.copy_rate copy_rate,'||vvar
           ||' from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,e.main_edtn edtn,b.copy_rate copy_rate,
                b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                a.city_code city_code,a.tehsil_taluka taluka_code,
                nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0) return_copy
               from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
               where b.comp_code =a.comp_code and b.comp_code =e.comp_code and b.comp_code ='||''''||pcomp_code||''''||' and 
               b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code='||''''||punit_code||''''||' and 
               b.doctype='||''''||pdoc_type||''''||' and b.recptdt >= '||''''||v_frdt||''''||' and b.recptdt<='||''''||v_todt||''''||' and 
               a.agcd=b.agcd and a.dpcd=b.dpcd and b.agcd=nvl('||''''||pagcode||''''||',b.agcd) and 
               b.dpcd=nvl('||''''||pdepocode||''''||',b.dpcd) and b.publ=nvl('||''''||ppubl||''''||',b.publ) and
               b.publ=e.publ and b.edtn=e.edtn and e.main_edtn=nvl('||''''||pmainedtn||''''||',e.main_edtn) and
               (a.tehsil_taluka='||''''||ptalukacode||''''||' or '||''''||ptalukacode||''''||' is null) and
               b.branch_code=nvl('||''''||pbran_code||''''||',b.branch_code) and
               (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0) u
               where u.return_copy>0
               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.copy_rate)c
               group by c.comp_code,c.unit_code
               order by c.comp_code,c.unit_code';
           --insert into test1(vstring,vstring2) values('unsold edtn v_query3 ',v_query1);COMMIT;
           open p_accounts2 for v_query1;
       Else
           v_query1:='select c.comp_code comp_code,c.unit_code unit_code,c.agcd agcd,c.dpcd dpcd,c.agname agname,c.agname_oth_lang agname_oth_lang,
           nvl(cir_get_name.cir_city(c.comp_code,c.city_code,'||''||plangtype||''||','''','''',''''),''NA'') city_name,
           nvl(cir_get_name.cir_taluka(c.comp_code,c.taluka_code,'||''||plangtype||''||','''','''',''''),''NA'') taluka_name '||tot_vvar||'
           from
           (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,
           u.copy_rate copy_rate,u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,u.city_code city_code,u.taluka_code taluka_code,'||vvar
           ||' from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,e.main_edtn edtn,b.copy_rate copy_rate,
               b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
               a.city_code city_code,a.tehsil_taluka taluka_code,
               nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0) return_copy
               from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
               where b.comp_code =a.comp_code and b.comp_code =e.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                   b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code='||''''||punit_code||''''||' and 
                   b.doctype='||''''||pdoc_type||''''||' and b.recptdt >= '||''''||v_frdt||''''||' and b.recptdt<='||''''||v_todt||''''||' and 
                   a.agcd=b.agcd and a.dpcd=b.dpcd and b.agcd=nvl('||''''||pagcode||''''||',b.agcd) and 
                   b.dpcd=nvl('||''''||pdepocode||''''||',b.dpcd) and b.publ=nvl('||''''||ppubl||''''||',b.publ) and
                   b.publ=e.publ and b.edtn=e.edtn and e.main_edtn=nvl('||''''||pmainedtn||''''||',e.main_edtn) and
                   (a.tehsil_taluka='||''''||ptalukacode||''''||' or '||''''||ptalukacode||''''||' is null) and
                   b.branch_code=nvl('||''''||pbran_code||''''||',b.branch_code) and
                   (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0) u
                   where u.return_copy>0
                   group by u.comp_code,u.unit_code,u.publ,u.edtn,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,
                   u.city_code,u.taluka_code,u.copy_rate) c
                   group by c.comp_code,c.unit_code,c.agcd,c.dpcd,c.agname,c.agname_oth_lang,c.city_code,c.taluka_code
                   order by c.comp_code,c.unit_code,taluka_name,c.agname';
                --insert into test1(vstring,vstring2) values('unsold edtn v_query1 ',v_query1);COMMIT;
           open p_accounts for v_query1;
    
           v_query1:='select c.comp_code comp_code,c.unit_code unit_code,
           nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA'') taluka_name '||tot_vvar||'
           from
           (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,u.copy_rate copy_rate,
           u.taluka_code taluka_code,'||vvar
           ||'  from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,e.main_edtn edtn,b.copy_rate copy_rate,
                b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                a.city_code city_code,a.tehsil_taluka taluka_code,
                nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0) return_copy
               from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
               where b.comp_code =a.comp_code and b.comp_code =e.comp_code and b.comp_code ='||''''||pcomp_code||''''||' and 
               b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code='||''''||punit_code||''''||' and 
               b.doctype='||''''||pdoc_type||''''||' and b.recptdt >= '||''''||v_frdt||''''||' and b.recptdt<='||''''||v_todt||''''||' and 
               a.agcd=b.agcd and a.dpcd=b.dpcd and b.agcd=nvl('||''''||pagcode||''''||',b.agcd) and 
               b.dpcd=nvl('||''''||pdepocode||''''||',b.dpcd) and b.publ=nvl('||''''||ppubl||''''||',b.publ) and
               b.publ=e.publ and b.edtn=e.edtn and e.main_edtn=nvl('||''''||pmainedtn||''''||',e.main_edtn) and
               (a.tehsil_taluka='||''''||ptalukacode||''''||' or '||''''||ptalukacode||''''||' is null) and
               b.branch_code=nvl('||''''||pbran_code||''''||',b.branch_code) and
               (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0) u
               where u.return_copy>0
               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.copy_rate,u.taluka_code) c
               group by c.comp_code,c.unit_code,c.taluka_code
               order by c.comp_code,c.unit_code,taluka_name';
           --insert into test1(vstring,vstring2) values('unsold edtn v_query2 ',v_query1);COMMIT;
           open p_accounts1 for v_query1;
    
           v_query1:='select c.comp_code comp_code,c.unit_code unit_code '||tot_vvar||'
           from
           (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,u.copy_rate copy_rate,'||vvar
           ||' from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,e.main_edtn edtn,b.copy_rate copy_rate,
                b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                a.city_code city_code,a.tehsil_taluka taluka_code,
                nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0) return_copy
               from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
               where b.comp_code =a.comp_code and b.comp_code =e.comp_code and b.comp_code ='||''''||pcomp_code||''''||' and 
               b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code='||''''||punit_code||''''||' and 
               b.doctype='||''''||pdoc_type||''''||' and b.recptdt >= '||''''||v_frdt||''''||' and b.recptdt<='||''''||v_todt||''''||' and 
               a.agcd=b.agcd and a.dpcd=b.dpcd and b.agcd=nvl('||''''||pagcode||''''||',b.agcd) and 
               b.dpcd=nvl('||''''||pdepocode||''''||',b.dpcd) and b.publ=nvl('||''''||ppubl||''''||',b.publ) and
               b.publ=e.publ and b.edtn=e.edtn and e.main_edtn=nvl('||''''||pmainedtn||''''||',e.main_edtn) and
               (a.tehsil_taluka='||''''||ptalukacode||''''||' or '||''''||ptalukacode||''''||' is null) and
               b.branch_code=nvl('||''''||pbran_code||''''||',b.branch_code) and
               (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0) u
               where u.return_copy>0
               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.copy_rate)c
               group by c.comp_code,c.unit_code
               order by c.comp_code,c.unit_code';
            --insert into test1(vstring,vstring2) values('unsold edtn v_query3 ',v_query1);COMMIT;
           open p_accounts2 for v_query1;
       End if;

            /*Branch Received */
           v_query1:='select c.comp_code comp_code,c.unit_code unit_code,c.branch_code branch_code,d."Branch_Name" branch_name'||tot_vvar||'
           from
           (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,u.copy_rate copy_rate,u.branch_code branch_code,'||vvar
           ||' from (select b.comp_code comp_code,b.unit_code unit_code,b.publ_code publ,e.main_edtn edtn,b.edtn_rate copy_rate,
               b.oth_branch_code branch_code,nvl(b.edtn_copy,0) return_copy
               from cir_branch_return_det b,cir_edtn_mast e
               where b.comp_code =e.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                   b.unit_code=e.unit_code and b.unit_code='||''''||punit_code||''''||' and 
                   b.doctype=''TI'' and b.recptdt >= '||''''||v_frdt||''''||' and b.recptdt<='||''''||v_todt||''''||' and 
                   b.publ_code=nvl('||''''||ppubl||''''||',b.publ_code) and
                   b.publ_code=e.publ and b.edtn_code=e.edtn and e.main_edtn=nvl('||''''||pmainedtn||''''||',e.main_edtn) and
                   b.branch_code=nvl('||''''||pbran_code||''''||',b.branch_code)) u
                   where u.return_copy>0
                   group by u.comp_code,u.unit_code,u.publ,u.edtn,u.branch_code,u.copy_rate) c,branch_mst d
                   where c.branch_code=d."Branch_Code"
                   group by c.comp_code,c.unit_code,c.branch_code,d."Branch_Name"
                   order by c.comp_code,c.unit_code,c.branch_code, branch_name';
            
            --insert into test1(vstring,vstring2) values('unsold edtn branch received v_query4 ',v_query1);COMMIT;
            
            open p_accounts3 for v_query1;

            v_query1:='select c.comp_code comp_code,c.unit_code unit_code,c.rec_type rec_type,c.branch_name branch_name '||tot_vvar||'
           from
           (select u.comp_code comp_code,u.unit_code unit_code,u.branch_name branch_name,u.publ publ,u.edtn edtn,u.copy_rate copy_rate,u.rec_type,'||vvar
           ||' from (select b.comp_code comp_code,b.unit_code unit_code,b.branch_code branch_code,f."Branch_Name" branch_name, b.publ_code publ,e.main_edtn edtn,b.edtn_rate copy_rate,
               1 rec_type,nvl(b.edtn_copy,0) return_copy
               from cir_branch_return_det b,cir_edtn_mast e,branch_mst f
               where b.comp_code =e.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                   b.unit_code=e.unit_code and b.unit_code='||''''||punit_code||''''||' and 
                   b.doctype=''TRF'' and b.recptdt >= '||''''||v_frdt||''''||' and b.recptdt<='||''''||v_todt||''''||' and 
                   b.publ_code=nvl('||''''||ppubl||''''||',b.publ_code) and
                   b.publ_code=e.publ and b.edtn_code=e.edtn and e.main_edtn=nvl('||''''||pmainedtn||''''||',e.main_edtn) and
                   b.branch_code=f."Branch_Code" and b.branch_code=nvl('||''''||pbran_code||''''||',b.branch_code)
                   union all
                   select b.comp_code comp_code,b.unit_code unit_code,NULL branch_code,''Company Return'' branch_name,b.publ publ,e.main_edtn edtn,b.copy_rate copy_rate,
                    2 rec_type,nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0) return_copy
                    from cir_unsold_dtl_dis b,cir_edtn_mast e
                    where b.comp_code =e.comp_code and b.comp_code ='||''''||pcomp_code||''''||' and 
                    b.unit_code=e.unit_code and b.unit_code='||''''||punit_code||''''||' and 
                    b.doctype='||''''||pdoc_type||''''||' and b.recptdt >= '||''''||v_frdt||''''||' and b.recptdt<='||''''||v_todt||''''||' and 
                    b.publ=nvl('||''''||ppubl||''''||',b.publ) and
                    b.publ=e.publ and b.edtn=e.edtn and e.main_edtn=nvl('||''''||pmainedtn||''''||',e.main_edtn) and
                    b.branch_code=nvl('||''''||pbran_code||''''||',b.branch_code)
                   union all
                   select b.comp_code comp_code,b.unit_code unit_code,NULL branch_code,''Raddi Sale'' branch_name,b.publ_code publ,e.main_edtn edtn,b.edtn_rate copy_rate,
                   3 rec_type,nvl(b.no_of_copy,0) return_copy
                   from cir_return_sale_det b,cir_edtn_mast e
                   where b.comp_code =e.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                   b.unit_code=e.unit_code and b.unit_code='||''''||punit_code||''''||' and 
                   b.doctype=''RET'' and b.recptdt >= '||''''||v_frdt||''''||' and b.recptdt<='||''''||v_todt||''''||' and 
                   b.publ_code=nvl('||''''||ppubl||''''||',b.publ_code) and
                   b.publ_code=e.publ and b.edtn_code=e.edtn and e.main_edtn=nvl('||''''||pmainedtn||''''||',e.main_edtn) and
                   b.branch_code=nvl('||''''||pbran_code||''''||',b.branch_code)
                   union all
                   select b.comp_code comp_code,b.unit_code unit_code,NULL branch_code,''Resale Supply'' branch_name,b.publ publ,e.main_edtn edtn,b.sup_rate copy_rate,
                    4 rec_type,nvl(b.sup_copy,0) return_copy
                    from cir_agmast a,cir_dbksup_resale b,cir_edtn_mast e
                    where b.comp_code =a.comp_code and b.comp_code =e.comp_code and b.comp_code ='||''''||pcomp_code||''''||' and 
                    b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code='||''''||punit_code||''''||' and 
                    b.supdate >= '||''''||v_frdt||''''||' and b.supdate<='||''''||v_todt||''''||' and a.agcd=b.agcd and a.dpcd=b.dpcd and
                    b.publ=nvl('||''''||ppubl||''''||',b.publ) and
                    b.publ=e.publ and b.edtn=e.edtn and e.main_edtn=nvl('||''''||pmainedtn||''''||',e.main_edtn) and
                    b.resale_branch=nvl('||''''||pbran_code||''''||',b.resale_branch)
                   union all
                   select b.comp_code comp_code,b.unit_code unit_code,NULL branch_code,''Short\Excess'' branch_name,b.publ_code publ,e.main_edtn edtn,b.edtn_rate copy_rate,
                   5 rec_type,nvl(b.short_excess,1)*nvl(b.no_of_copy,0) return_copy
                   from cir_physical_ver_det b,cir_edtn_mast e
                   where b.comp_code =e.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                   b.unit_code=e.unit_code and b.unit_code='||''''||punit_code||''''||' and 
                   b.recptdt >= '||''''||v_frdt||''''||' and b.recptdt<='||''''||v_todt||''''||' and 
                   b.publ_code=nvl('||''''||ppubl||''''||',b.publ_code) and
                   b.publ_code=e.publ and b.edtn_code=e.edtn and e.main_edtn=nvl('||''''||pmainedtn||''''||',e.main_edtn) and
                   b.branch_code=nvl('||''''||pbran_code||''''||',b.branch_code)
                   union all
                   select b.comp_code comp_code,b.unit_code unit_code,NULL branch_code,''Privious Balance'' branch_name,b.publ_code publ,e.main_edtn edtn,b.copy_rate copy_rate,
                   6 rec_type,nvl(b.opbal,0) return_copy
                   from cir_temp_unsold_stock b,cir_edtn_mast e
                   where b.comp_code =e.comp_code and b.unit_code=e.unit_code and  
                   b.publ_code=e.publ and b.edtn_code=e.edtn and sess_id=userenv(''sessionid'')) u
                   where u.return_copy<>0
                   group by u.comp_code,u.unit_code,u.branch_name,u.publ,u.edtn,u.rec_type,u.copy_rate) c
                   group by c.comp_code,c.unit_code,c.rec_type,c.branch_name
                   order by c.comp_code,c.unit_code,c.rec_type,c.branch_name';
                   
             --insert into test1(vstring,vstring2) values('unsold edtn branch comp return v_query5 ',v_query1);COMMIT;
            
            open p_accounts5 for v_query1; 
        
            open p_accounts6 for select sysdate from dual;
    Else
        v_query1:='select '||''''||pcomp_code||''''||' comp_code,'||''''||punit_code||''''||' unit_code,null agcd,null dpcd,null agname,null agname_oth_lang,null city_name,null taluka_name,0 supply_copy,0 return_copy from dual';
        --insert into test1(vstring,vstring2) values('unsold else edtn vquery ',v_query1);COMMIT;
        
        open p_accounts for v_query1;
        v_query1:='select '||''''||pcomp_code||''''||' comp_code,'||''''||punit_code||''''||' unit_code,null taluka_name,0 supply_copy,0 return_copy from dual';
        --insert into test1(vstring,vstring2) values('unsold else edtn vquery2 ',v_query1);COMMIT;
        
        open p_accounts1 for v_query1;
        v_query1:='select '||''''||pcomp_code||''''||' comp_code,'||''''||punit_code||''''||' unit_code,0 supply_copy,0 return_copy from dual';
        --insert into test1(vstring,vstring2) values('unsold else edtn vquery3 ',v_query1);COMMIT;
        
        open p_accounts2 for v_query1;
             v_query1:='select null from dual';
        open p_accounts3 for v_query1;    
        
        open p_accounts5 for select sysdate from dual; 
        
        open p_accounts6 for select sysdate from dual;         
    End if;
    delete from cir_temp_unsold_stock where sess_id=userenv('sessionid');commit;
   End cir_unsold_return_punya; 
   
  procedure cir_rep_unsold_challan(
     pcompcode             in varchar2,
     punitcode             in varchar2,
     pdoctype            in varchar2,
     pagcode            in varchar2,
     pagsubcode            in varchar2,
     pfrom_recdate         in varchar2,
     ptill_recdate      in varchar2,
     precptno           in varchar2,
     papproved_flag     in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts)
  As
    v_frdt date;
    v_todt date;
  Begin
    v_frdt:=to_date(pfrom_recdate,''''||pdateformat||'''');
    v_todt:=to_date(ptill_recdate,''''||pdateformat||'''');
    
    open p_accounts for
    select u.comp_code as comp_code,u.unit_code as unit_code,u.branch_code branch_code,
    u.branch_name branch_name,u.agcd agcd,u.dpcd dpcd,
    u.ag_name AS ag_name,u.recptdt recptdt,u.recptno recptno ,u.publ publ,u.publ_name publ_name, 
    u.main_edtn main_edtn, u.main_edtnname main_edtnname,u.edtn edtn,u.edtn_name edtn_name,
    u.copy_rate copy_rate,
    u.return_copy return_copy 
    from(select d.comp_code as comp_code,d.unit_code as unit_code,d.branch_code branch_code,
    get_branch_name(d.branch_code) branch_name,d.agcd agcd,d.dpcd dpcd,
    m.ag_name AS ag_name,d.recptdt recptdt,d.recptno recptno ,d.publ publ,cir_get_name.cir_publ(d.comp_code,d.publ,1,'','','') publ_name, 
    e.main_edtn main_edtn,cir_get_name.cir_edtn(d.comp_code,d.unit_code,e.main_edtn,1,'','','') main_edtnname,d.edtn edtn,e.edtn_name edtn_name,
    d.copy_rate copy_rate,
    sum(nvl(d.short_recpt,0)+nvl(d.late_recpt,0)+nvl(d.bnr,0)+nvl(d.unsold,0)) return_copy
    from cir_agmast_dis m, cir_unsold_hdr_dis h,cir_unsold_dtl_dis d,cir_edtn_mast e
    where m.comp_code=d.comp_code and d.comp_code=h.comp_code and m.comp_code=e.comp_code and m.comp_code=pcompcode and 
    m.unit=d.unit_code and d.unit_code=h.unit_code and m.unit=e.unit_code and m.unit=punitcode and 
    m.agcd=d.agcd and m.agcd=nvl(pagcode,m.agcd) and m.dpcd=d.dpcd and m.dpcd=nvl(pagsubcode,m.dpcd) and 
    d.doctype=h.doctype and d.doctype=nvl(pdoctype,d.doctype) and d.recptdt=h.recptdt and d.recptdt between v_frdt and v_todt and 
    d.recptno=h.recptno and d.recptno =nvl(precptno,d.recptno) and 
    d.publ=e.publ and d.edtn=e.edtn and pextra2='D'
    group by d.comp_code,d.unit_code,d.agcd,d.dpcd ,m.ag_name,d.recptdt,d.recptno ,d.publ,d.edtn,
    d.copy_rate,e.main_edtn,d.branch_code,e.edtn_name
    union
    select d.comp_code as comp_code,d.unit_code as unit_code,d.branch_code branch_code,
    get_branch_name(d.branch_code) branch_name,d.agcd agcd,d.dpcd dpcd,
    m.ag_name ag_name,d.recptdt recptdt,d.recptno recptno ,d.publ publ,cir_get_name.cir_publ(d.comp_code,d.publ,1,'','','') publ_name, 
    e.main_edtn main_edtn,cir_get_name.cir_edtn(d.comp_code,d.unit_code,e.main_edtn,1,'','','') main_edtnname,d.edtn edtn,e.edtn_name edtn_name,
    d.copy_rate copy_rate,
    sum(nvl(d.short_recpt,0)+nvl(d.late_recpt,0)+nvl(d.bnr,0)+nvl(d.unsold,0)) return_copy
    from cir_agmast m, cir_unsold_hdr h,cir_unsold_dtl d,cir_edtn_mast e
    where m.comp_code=d.comp_code and d.comp_code=h.comp_code and m.comp_code=e.comp_code and m.comp_code=pcompcode and 
    m.unit=d.unit_code and d.unit_code=h.unit_code and m.unit=e.unit_code and m.unit=punitcode and 
    m.agcd=d.agcd and m.agcd=nvl(pagcode,m.agcd) and m.dpcd=d.dpcd and m.dpcd=nvl(pagsubcode,m.dpcd) and 
    d.doctype=h.doctype and d.doctype=nvl(pdoctype,d.doctype) and d.recptdt=h.recptdt and d.recptdt between v_frdt and v_todt and 
    d.recptno=h.recptno and d.recptno =nvl(precptno,d.recptno) and 
    d.publ=e.publ and d.edtn=e.edtn and (pextra2!='D' or pextra2='' or pextra2 is null)
    group by d.comp_code,d.unit_code,d.agcd,d.dpcd ,m.ag_name,d.recptdt,d.recptno ,d.publ,d.edtn,
    d.copy_rate,e.main_edtn,d.branch_code,e.edtn_name) u
    order by comp_code,unit_code,recptdt,recptno,publ_name,main_edtnname,edtn_name;
    
  End cir_rep_unsold_challan;     
END cir_rep_unsold_supply;
/

///////////////////////////////////////////DESCRIPTION///////////////////////////////////////////////////////////

CREATE OR REPLACE PACKAGE HT18JULY.cir_rep_unsold_supply IS
  type t_accounts is ref cursor;
  procedure cir_rep_unsold_detail(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pdoc_type            in varchar2,
     ppubl                 in varchar2,
     pmainedtn             in varchar2,
     pedtn                 in varchar2,
     pcity                in varchar2,
     pagcode            in varchar2,
     pdepocode            in varchar2,
     pfrom_recdate         in varchar2,
     ptill_recdate      in varchar2,
     papproved_flag     in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts);

  procedure cir_rep_unsold_summary(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pdoc_type          in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pedtn              in varchar2,
     pcity              in varchar2,
     pagcode            in varchar2,
     pdepocode          in varchar2,
     pfrom_recdate      in varchar2,
     ptill_recdate      in varchar2,
     papproved_flag     in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts);
     
   procedure cir_publ_unsold_supply(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pdoc_type          in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pedtn              in varchar2,
     pagcode            in varchar2,
     pdepocode          in varchar2,
     pfromdate          in varchar2,
     ptilldate          in varchar2,
     papproved_flag     in varchar2,
     ptaluka            in varchar2,
     pstatecode         in varchar2,
     pdistcode          in varchar2,
     pbranchcode        in varchar2,     
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts,
     p_accounts3        out t_accounts);
  
  procedure cir_edtn_unsold_supply(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pdoc_type          in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pedtn              in varchar2,
     pagcode            in varchar2,
     pdepocode          in varchar2,
     pfromdate          in varchar2,
     ptilldate          in varchar2,
     papproved_flag     in varchar2,
     ptaluka            in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts,
     p_accounts3        out t_accounts);

  procedure cir_edtn_unsold_supply_dist(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pdoc_type          in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pedtn              in varchar2,
     pagcode            in varchar2,
     pdepocode          in varchar2,
     pfromdate          in varchar2,
     ptilldate          in varchar2,
     papproved_flag     in varchar2,
     pdistcd            in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts,
     p_accounts3        out t_accounts);
     
      procedure cir_monthly_net_paid_sale(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pedtn              in varchar2,
     pfromdate          in varchar2,
     ptilldate          in varchar2,
     pagency_type       in varchar2,
     pagency_class      in varchar2,
     pstatecode         in varchar2,
     pdistcode          in varchar2,
     ptaluka            in varchar2,
     pbranch            in varchar2,
     pagcd              in varchar2,
     pdpcd              in varchar2,
     preptype           in number,--1 for Agency Wise,2 for Main Edition wise,3 for District Taluka wise
     pbreak_on          in varchar2,--Region R/State S/District D/Branch B
     preturn_based      in varchar2,--it is use for return date or supply date(R/S)
     plangtype          in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     pextra3            in varchar2,
     pextra4            in varchar2,
     pextra5            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts,
     p_accounts3        out t_accounts);
     
  procedure cir_rep_unsold_slip(
     pcompcode             in varchar2,
     punitcode             in varchar2,
     pbrancode             in varchar2,
     pdoctype            in varchar2,
     pdistcode            in varchar2,
     ptalukacode        in varchar2,
     pagcode            in varchar2,
     pagsubcode            in varchar2,
     pfrom_recdate         in varchar2,
     ptill_recdate      in varchar2,
     papproved_flag     in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts);

  procedure cir_unsold_return_punya(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pbran_code         in varchar2,
     pdoc_type            in varchar2,
     ppubl                 in varchar2,
     pmainedtn             in varchar2,
     pdistcode          in varchar2,
     ptalukacode        in varchar2,
     pcitycode          in varchar2,
     pagcode            in varchar2,
     pdepocode            in varchar2,
     pfrom_recdate         in varchar2,
     ptill_recdate      in varchar2,
     papproved_flag     in varchar2,
     plangtype          in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts,
     p_accounts3        out t_accounts,
     p_accounts5        out t_accounts,
     p_accounts6        out t_accounts);

    procedure cir_rep_unsold_challan(
     pcompcode             in varchar2,
     punitcode             in varchar2,
     pdoctype            in varchar2,
     pagcode            in varchar2,
     pagsubcode            in varchar2,
     pfrom_recdate         in varchar2,
     ptill_recdate      in varchar2,
     precptno           in varchar2,
     papproved_flag     in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts);     
END cir_rep_unsold_supply;
/
////////////////////////////////////////////////////END/////////////////////////////////////////////////////////////////
///////////////////////////////////////////////start issue no 5718////////////////////////////////////////////////////////////////////

/* Formatted on 2011/12/05 12:57 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FUNCTION cir_get_city (
   pcomp_code   IN   VARCHAR2,
   pcity_code   IN   VARCHAR2
)
   RETURN VARCHAR2
IS
   vcity_name   cir_city_mast.city_name%TYPE;
BEGIN
   BEGIN
      SELECT city_name
        INTO vcity_name
        FROM cir_city_mast
       WHERE comp_code = pcomp_code AND city_code = pcity_code;
   -- exception when others then
             --vcity_name:=null;
   END;

   RETURN NVL (vcity_name, '');
END;
/


CREATE OR REPLACE FUNCTION cir_get_agency_city(pcomp_code in varchar2,punit_code in varchar,pagcd in varchar2,pdpcd in varchar2) RETURN varchar IS
v_city_name     varchar2(100);
BEGIN
 Begin
     select MAX(city_name) into v_city_name from
     (select cir_get_city(comp_code,city_code) city_name 
        from cir_agmast
         where comp_code=pcomp_code and
               unit=punit_code and
               agcd=pagcd and
               dpcd=pdpcd
     union
     select cir_get_city(comp_code,city_code) city_name 
        from cir_agmast_dis
         where comp_code=pcomp_code and
               unit=punit_code and
               agcd=pagcd and
               dpcd=pdpcd);
         exception when others then
              v_city_name:=null;
 End;
  return nvl(v_city_name,'');
END;









CREATE OR REPLACE PACKAGE BODY cir_rep_agency_ledger IS
PROCEDURE cir_agency_ledger_p(
    pcompcode       in varchar2,
    punitcode       in varchar2,
    pactype         in varchar2,
    pbranchcode     in varchar2,
    pagency_type    in varchar2,
    pagcd           in varchar2,
    pdpcd           in varchar2,
    pstatecode      in varchar2,
    pdistcode       in varchar2,
    pcitycode       in varchar2,
    ptalukacode     in varchar2,
    pfrom_date      in varchar2,  
    ptill_date      in varchar2,
    pbilladj_flag   in varchar2,
    psortedby       in varchar2,
    puserid         in varchar2,
    prowbreak       in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,--it is use for agency class
    pextra2         in varchar2,
    P_Accounts      out T_Accounts_Cursor,
    P_Accounts1     out T_Accounts_Cursor)
As
    v_frdt          date;
    v_todt          date;
    v_opdate        date;

    v_opbal         number(15,2):=0;
    v_opbal_sec     number(15,2):=0;
    v_amt           number(15,2):=0;
    v_clbal         number(15,2):=0;
    v_runbal        number(15,2):=0;
    v_billamt       number:=0;
    v_dbcramt       number:=0;
    v_cramt         number(15,2) :=0;
    v_dbamt         number(15,2) :=0;
    v_rec_seqno     number:=0;
    v_remark_len    number:=0;
    v_divident      number:=0;
    v_narration     varchar2(1000);
    v_runbal_txt    varchar2(20);
        cursor c1 is
            select distinct comp_code,unit,agcd,dpcd,ag_name,ag_name_oth_lang,city_code,tehsil_taluka,dist_code,state_code,
            country_code,branch_code from cir_agmast
                where comp_code=pcompcode and (unit=punitcode or punitcode is null) and
                            (ag_type=pagency_type or pagency_type is null) and agcd||dpcd in(select distinct agcd||dpcd from cir_outmast
                            where comp_code=pcompcode and (unit_code=punitcode or punitcode is null) and achd=pactype) and
                            (agcd=pagcd or pagcd is null) and (dpcd=pdpcd or pdpcd is null) and (branch_code=pbranchcode or pbranchcode is null) and
                            (state_code=pstatecode or pstatecode is null) and (dist_code=pdistcode or pdistcode is null) and
                            (tehsil_taluka=ptalukacode or ptalukacode is null) and (ag_class=pextra1 or pextra1 is null)
                            order by branch_code,city_code,ag_name;
        v1 c1%rowtype;
       cursor c2 is
        select comp_code,unit_code,agcd,dpcd,doctype,recptno,recptdt,amount,chno,chdt,chbank,reason,narration,received_from from
        (select comp_code,unit_code,agcd,dpcd,doctype,recptno,recptdt,amount,chno,chdt,chbank,
        case when cir_rcphdr.doctype='RCR' then (select "Payment_Mode_Name" from payment_mode_mast where "Pay_Mode_Code"=cir_rcphdr.reason)
        else (select reason_name from cir_reason_mst where comp_code=cir_rcphdr.comp_code and reason_code=cir_rcphdr.reason) end as reason,
        remark narration,received_from from cir_rcphdr
            where comp_code=v1.comp_code and unit_code=v1.unit and agcd=v1.agcd and dpcd=v1.dpcd and recptdt
                between v_frdt and v_todt and nvl(achd,'NM')=pactype
        union
        select comp_code,unit_code,agcd,dpcd,'BIL' doctype,billno recptno,billdt recptdt,sum(bill_amount) amount,null chno,null chdt,null chbnk,'BILL' reason,
        'Bill Copy '||sum(bill_copy)||' Comm. Amount '||sum(comm_amount) narration,null received_from from cir_bill
            where comp_code=v1.comp_code and unit_code=v1.unit and agcd=v1.agcd and dpcd=v1.dpcd and
                billdt between v_frdt and v_todt and pactype='NM'
                group by comp_code,unit_code,agcd,dpcd,billno,billdt)
        order by recptdt,doctype,recptno;
        v2 c2%rowtype;
    Begin
        v_opdate    :=cir_get_finandt(pcompcode,to_date(pfrom_date,''''||pdateformat||''''),pdateformat,'','');--for financial date

        v_frdt      :=to_date(pfrom_date,''''||pdateformat||'''');
        v_todt      :=to_date(ptill_date,''''||pdateformat||'''');
        v_divident  :=nvl(prowbreak,35);
           delete from cir_ledger_report where sess_id=userenv('sessionid');
        --delete from test1;commit;
        --insert into test1(vstring,vstring2) values('unit outstanding monthwise vvar ',v_months);commit;
        open c1;
        loop
            fetch c1 into v1;
            exit when c1%notfound;
            v_opbal        :=cir_accounts.cir_agency_opbal(pcompcode,punitcode,'',v1.agcd,v1.dpcd,v_opdate,pactype,pdateformat,'','');
            ----for secutiry outstanding---
            if pactype='NM' then
                v_opbal_sec :=cir_accounts.cir_agency_opbal(pcompcode,punitcode,'',v1.agcd,v1.dpcd,v_opdate,'SC',pdateformat,'','');
                select sum(amount) into v_dbcramt from cir_rcphdr
                where comp_code=pcompcode and (unit_code=punitcode or punitcode is null) and
                            agcd=v1.agcd and dpcd=v1.dpcd and recptdt>= v_opdate and recptdt<=v_todt and
                            achd='SC';
                v_opbal_sec:=nvl(v_opbal_sec,0)+nvl(v_dbcramt,0);

            else
                v_opbal_sec :=0;
            end if;
            ----for secutiry outstanding---
            v_dbcramt:=0;
            select sum(amount) into v_billamt from cir_outmast
                where comp_code=pcompcode and (unit_code=punitcode or punitcode is null) and
                            agcd=v1.agcd and dpcd=v1.dpcd and billdt >= v_opdate and billdt<v_frdt and
                            achd=pactype and recptno is null;
            select sum(amount) into v_dbcramt from cir_rcpdet
                where comp_code=pcompcode and (unit_code=punitcode or punitcode is null) and
                            agcd=v1.agcd and dpcd=v1.dpcd and recptdt>= v_opdate and recptdt<v_frdt and
                            achd=pactype and billno is null;

            v_opbal:=nvl(v_opbal,0)+nvl(v_billamt,0)+nvl(v_dbcramt,0);

            v_rec_seqno:=nvl(v_rec_seqno,0)+1;
              insert into cir_ledger_report
                  (comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
                  exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
                  billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line)
              values(v1.comp_code,v1.unit,v1.branch_code,v1.agcd,v1.dpcd,'',null,v_frdt,v_opbal_sec,
                     null,'Security Balance',null,null,null,null,null,null,
                     null,null,null,null,null,v1.ag_name,v_rec_seqno,1);

            v_rec_seqno:=nvl(v_rec_seqno,0)+1;
            v_runbal:=v_opbal;
            if v_runbal>=0 then
                v_runbal_txt:=to_char(v_runbal,'99999990.99')||' Dr.';
            else
                v_runbal_txt:=to_char(abs(v_runbal),'99999990.99')||' Cr.';
            end if;


              insert into cir_ledger_report
                  (comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
                  exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
                  billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line)
              values(v1.comp_code,v1.unit,v1.branch_code,v1.agcd,v1.dpcd,'',null,v_frdt,v_opbal,
                     null,'Opening Balance',null,null,null,null,null,null,
                     null,null,null,null,null,v1.ag_name,v_rec_seqno,2);

            --------daily transactions------------
            open c2;
            loop
                fetch c2 into v2;
                exit when c2%notfound;
                if nvl(v2.amount,0)<>0 then
                    v_rec_seqno:=nvl(v_rec_seqno,0)+1;
                    v_narration:=null;
                    if v2.doctype='BIL' then
                        v_narration:=v2.narration;
                    else
                        if v2.narration is not null then
                           v_narration:=v2.narration;
                            if v2.chno is not null then
                                v_narration:=v_narration||' CHNO# '||v2.chno;
                            end if;
                            if v2.chdt is not null then
                                v_narration:=v_narration||' CHDT '||v2.chdt;
                            end if;
                            if v2.chbank is not null then
                                v_narration:=v_narration||' CHBNK '||v2.chbank;
                            end if;
                        else
                            if v2.chno is not null then
                                v_narration:='CHNO# '||v2.chno;
                            end if;
                            if v2.chdt is not null then
                                v_narration:=v_narration||' CHDT '||to_char(v2.chdt,''||pdateformat||'');
                            end if;
                            if v2.chbank is not null then
                                v_narration:=v_narration||' CHBANK '||v2.chbank;
                            end if;
                            if v2.reason='CASH' and v2.doctype='RCR' then
                                v_narration:='By Cash '||v_narration;
                            end if;
                        end if;
                    end if;
                    v_remark_len := length(nvl(ltrim(rtrim(v_narration)),'-'));
                    v_amt:=nvl(v_amt,0)+nvl(v2.amount,0);

                    v_runbal:=v_runbal+nvl(v2.amount,0);

                    if v_runbal>=0 then
                        v_runbal_txt:=to_char(v_runbal,'99999990.99')||' Dr.';
                    else
                        v_runbal_txt:=to_char(abs(v_runbal),'99999990.99')||' Cr.';
                    end if;

                    if nvl(v2.amount,0)>=0 then
                        v_dbamt:=nvl(v_dbamt,0)+nvl(v2.amount,0);
                    elsif nvl(v2.amount,0)<0 then
                        v_cramt:=nvl(v_cramt,0)+abs(nvl(v2.amount,0));
                    end if;
                  insert into cir_ledger_report
                      (comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
                      exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
                      billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line)
                  values(v1.comp_code,v1.unit,v1.branch_code,v1.agcd,v1.dpcd,v2.doctype,v2.recptno,v2.recptdt,v2.amount,
                         v2.received_from,nvl(ltrim(rtrim(v_narration)),'-'),v2.chno,v2.chdt,v2.chbank,v2.reason,null,v_runbal_txt,
                         null,null,null,null,v_runbal,v1.ag_name,v_rec_seqno,mod_function(v_remark_len,v_divident));

                end if;
            end loop;
            close c2;
            --------daily transactions------------

            v_clbal :=nvl(v_opbal,0)+nvl(v_amt,0);

            v_rec_seqno:=nvl(v_rec_seqno,0)+1;
            if v_runbal>=0 then
                v_runbal_txt:=to_char(v_runbal,'99999990.99')||' Dr.';
            else
                v_runbal_txt:=to_char(abs(v_runbal),'99999990.99')||' Cr.';
            end if;
      insert into cir_ledger_report
          (comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
          exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
          billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line)
      values(v1.comp_code,v1.unit,v1.branch_code,v1.agcd,v1.dpcd,'',null,v_todt,nvl(v_clbal,0),
              null,'Closing Balance',null,null,null,null,null,null,
              null,null,null,null,null,v1.ag_name,v_rec_seqno,1);
        if nvl(v_opbal_sec,0)=0 and nvl(v_opbal,0)=0 and v_cramt=0 and v_dbamt=0 then
           delete from cir_ledger_report where comp_code=v1.comp_code and unit_code=v1.unit and
            agcd=v1.agcd and dpcd=v1.dpcd and sess_id=userenv('sessionid');
        end if;

        v_billamt:=0;v_dbcramt:=0;v_opbal:=0;v_clbal:=0;v_amt:=0;v_runbal:=0;v_cramt:=0;v_dbamt:=0;v_runbal_txt:=null;

        end loop;
        close c1;
        commit;
insert into test1(vstring,vstring2) values('unit outstanding monthwise vvar ','3');commit;
    open P_Accounts for
    select
    (select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code)  as "CNAME",
    comp_code,unit_code,branch_code,(select "Branch_Name" from branch_mst where "Branch_Code"=branch_code) branch_name,
    agcd,dpcd,agname,cir_get_agency_city(comp_code,unit_code,agcd,dpcd) city_name, 
    doctype,recptno,recptdt,
    decode(a.debit,'D',a.amount) as debit,decode(a.credit,'C',a.amount) as credit,exec_code,remarks,
    chqno,chqdt,chq_bank,reason,debit_head,credit_head,
    billno,billdt,billamt,adjamt,leftamt,rec_seqno,narr_line from
    (select comp_code,unit_code,branch_code,agcd,dpcd,agname,doctype,recptno,recptdt,
     decode(sign(amount),1,'D') as debit,decode(sign(amount),-1,'C') as credit,abs(amount) as amount,
     exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
     billno,billdt,billamt,adjamt,leftamt,rec_seqno,nvl(narr_line,1) as narr_line from cir_ledger_report
    where comp_code=pcompcode and unit_code=punitcode and sess_id=userenv('sessionid') ) a order by rec_seqno;
insert into test1(vstring,vstring2) values('unit outstanding monthwise vvar ','2');commit;
    open P_Accounts1 for
    select (select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code)  as "CNAME",comp_code,agcd,dpcd,agname,
    count(*),nvl(sum(narr_line),0) sum_narr from
    (select comp_code,unit_code,branch_code,agcd,dpcd,agname,doctype,recptno,recptdt,
    decode(sign(amount),1,'D') as debit,decode(sign(amount),-1,'C') as credit,abs(amount) as amount,rec_seqno,narr_line from cir_ledger_report
    where comp_code=pcompcode and unit_code=punitcode and sess_id=userenv('sessionid') ) a
    group by comp_code,agcd,dpcd,agname
    order by comp_code,agcd,dpcd,agname;
    insert into test1(vstring,vstring2) values('unit outstanding monthwise vvar ','1');commit;
    delete from cir_ledger_report where sess_id=userenv('sessionid');
    commit;
    End cir_agency_ledger_p;
    
END cir_rep_agency_ledger;
/



////////////////////////////////////////////////////////////end/////////////////////////////////////////////////////////
/*************************************************************************/
/***********************mimoh 7dec 2011*********************************0005889****************/


CREATE OR REPLACE PROCEDURE cir_agency_unblock_approval (
    pcomp_code         in varchar2,
    punit_code         in varchar2,
    pbran_code         in varchar2,
    pstatus            in varchar2,
    pfrdt              in varchar2,
    ptodt              in varchar2,
    pagcd              in varchar2,
    pdpcd              in varchar2,
    psuspty            in varchar2,
    puserid            in varchar2,
    p_accounts         OUT cur_type_new1.cursor_type) as
Begin

open p_accounts for
  select comp_code,unit,agcd,dpcd,cir_get_agency (comp_code,unit,agcd,dpcd) as agency_name,start_date as block_unblock_date,'' as block_unblock_time,
         (SELECT SUSPEND_DESC FROM CIR_SUSPEND_TYPE_MAST WHERE COMP_CODE=cir_suspend_tran.COMP_CODE AND SUSPEND_TYPE_CODE=cir_suspend_tran.suspty) block_reason,suspty suspty,
         (SELECT max("username") from login where com_code = cir_suspend_tran.comp_code  and "userid"=cir_suspend_tran.userid) as unblock_by,suspty suspend_type,
         agency_unblock_approval,userid,nvl(trn_date,trunc(creation_date)) trn_date from cir_suspend_tran
      where comp_code = pcomp_code
        and ((unit    = punit_code) or (punit_code is null))
        --and branch
        and susp      = pstatus
        and start_date between pfrdt and ptodt
        and ((agcd    = pagcd) or (pagcd is null))
        and ((dpcd    = pdpcd) or (pdpcd is null))
        and ((userid  = puserid) or (puserid is null))
        and nvl(agency_unblock_approval,'N')='N';
    
  
End cir_agency_unblock_approval;
/

/***********************************************************************************/


CREATE OR REPLACE PACKAGE cir_suspend_type_bind IS
  type t_accounts_type is ref cursor;
  procedure cir_suspend_type_bind_p(
     pcomp_code in varchar2,
     pdateformat in varchar2,
     pextra1 in varchar2,
     pextra2 in varchar2,
     p_accounts out t_accounts_type);
END;
/





CREATE OR REPLACE PACKAGE BODY cir_suspend_type_bind IS
  procedure cir_suspend_type_bind_p(
    pcomp_code in varchar2,
    pdateformat in varchar2,
    pextra1 in varchar2,
    pextra2 in varchar2,
    p_accounts out t_accounts_type) as
  Begin
     open p_accounts for select * from cir_suspend_type_mast where comp_code=pcomp_code and nvl(freeze_flag,'N')='N';
  End cir_suspend_type_bind_p;
END cir_suspend_type_bind;
/


/*****************************************************************************************************/


CREATE OR REPLACE PROCEDURE cir_user_bind_for_bl_unblk (pcomp_code   in varchar2,
                                                  punit_code   in varchar2,
                                                  pextra1      in varchar2,
                                                  pextra2      in varchar2,
                                                  pextra3      in varchar2,
                                                  pextra4      in varchar2,
                                                  pextra5      in varchar2,
                                                  p_accounts   OUT cur_type_new1.cursor_type)
as
Begin
  open p_accounts for
  SELECT "username" as USERNAME,"userid" as USERID from login where com_code = pComp_code 
      and "userid" in (select distinct userid from cir_suspend_tran 
                          where comp_code = pcomp_code
                            and ((unit       = punit_code) or (punit_code is null) or (punit_code = '')));
End;
/





/***********************mimoh 7dec 2011*********************************0005889****************/


/////////////////////////////////////////ISSUE NO.4488//////////////////////////////////////////////////////////////

/////////////////////////////////////////BODY//////////////////////////////////////////////////////////////////
CREATE OR REPLACE PACKAGE BODY HT18JULY.cir_rep_unsold_supply IS
  procedure cir_rep_unsold_detail(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pdoc_type          in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pedtn              in varchar2,
     pcity              in varchar2,
     pagcode            in varchar2,
     pdepocode          in varchar2,
     pfrom_recdate      in varchar2,
     ptill_recdate      in varchar2,
     papproved_flag     in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts)
  As
       v_frdt    date;
       v_todt    date;
  Begin  
       v_frdt:=to_date(pfrom_recdate,''''||pdateformat||'''');
       v_todt:=to_date(ptill_recdate,''''||pdateformat||'''');
       
           open p_accounts for
               select u.comp_code comp_code,u.unit_code unit_code,u.doctype doctype,u.recptno recptno,u.recptdt recptdt,
                    u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,u.city_name city_name,
                    u.supdate supdate,u.supply_copy supply_copy,
                    u.short_recpt short_recpt,u.late_recpt late_recpt,u.bnr bnr,u.unsold unsold,
                    u.copy_rate copy_rate,u.comm_rate comm_rate,u.waste_alw waste_alw,u.waste_rate waste_rate,u.copy_amt copy_amt,
                    u.comm_amt comm_amt,u.waste_amt waste_amt,u.total_amt total_amt from
               (select b.comp_code comp_code,b.unit_code unit_code,b.doctype doctype,b.recptno recptno,b.recptdt recptdt,
                    b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,cir_get_city(b.comp_code,a.city_code) city_name,
                    b.supdate supdate,sum(b.supply_copy) supply_copy,
                    sum(b.apr_short_recpt) short_recpt,sum(b.apr_late_recpt) late_recpt,sum(b.apr_bnr) bnr,sum(b.apr_unsold) unsold,
                    b.copy_rate copy_rate,b.comm_rate comm_rate,b.waste_alw waste_alw,b.waste_rate waste_rate,
                    sum(nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0))*b.copy_rate copy_amt,
                    sum(b.comm_amt) comm_amt,sum(b.waste_amt) waste_amt,sum(nvl(b.copy_amt,0)) total_amt 
               from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
               where b.comp_code = a.comp_code and b.comp_code = e.comp_code and b.comp_code =pcomp_code and 
                     b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code=punit_code and 
                     b.doctype=pdoc_type and b.app_dt between v_frdt and v_todt and 
                     a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd=pagcode) or (pagcode is null)) and b.dpcd=nvl(pdepocode,b.dpcd) and 
                     b.publ=e.publ and b.publ=nvl(ppubl,b.publ) and b.edtn=e.edtn and b.edtn=nvl(pedtn,b.edtn) and
                     a.city_code=nvl(pcity,a.city_code) and
                     (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0 and 
                     e.main_edtn=nvl(pmainedtn,e.main_edtn) and upper(nvl(papproved_flag,'N'))='Y'
                     group by b.comp_code,b.unit_code,b.doctype,b.recptno,b.recptdt,b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,
                     a.city_code,b.supdate,b.copy_rate,b.comm_rate,b.waste_alw,b.waste_rate
               union
               select b.comp_code comp_code,b.unit_code unit_code,b.doctype doctype,b.recptno recptno,b.recptdt recptdt,
                    b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,cir_get_city(b.comp_code,a.city_code) city_name,
                    b.supdate supdate,sum(b.supply_copy) supply_copy,
                    sum(b.short_recpt) short_recpt,sum(b.late_recpt) late_recpt,sum(b.bnr) bnr,sum(b.unsold) unsold,
                    b.copy_rate copy_rate,b.comm_rate comm_rate,b.waste_alw waste_alw,b.waste_rate waste_rate,
                    sum(nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0))*b.copy_rate copy_amt,
                    sum(b.comm_amt) comm_amt,sum(b.waste_amt) waste_amt,sum(nvl(b.copy_amt,0)) total_amt 
               from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
               where b.comp_code = a.comp_code and b.comp_code = e.comp_code and b.comp_code =pcomp_code and 
                     b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code=punit_code and 
                     b.doctype=pdoc_type and b.recptdt between v_frdt and v_todt and 
                     a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd=pagcode) or (pagcode is null)) and b.dpcd=nvl(pdepocode,b.dpcd) and 
                     b.publ=e.publ and b.publ=nvl(ppubl,b.publ) and b.edtn=e.edtn and b.edtn=nvl(pedtn,b.edtn) and
                     a.city_code=nvl(pcity,a.city_code) and
                     (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0 and 
                     e.main_edtn=nvl(pmainedtn,e.main_edtn) and upper(nvl(papproved_flag,'N'))='N'
                     group by b.comp_code,b.unit_code,b.doctype,b.recptno,b.recptdt,b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,
                     a.city_code,b.supdate,b.copy_rate,b.comm_rate,b.waste_alw,b.waste_rate) u 
                     order by u.comp_code,u.unit_code,u.recptdt,u.recptno,u.agname;
  End cir_rep_unsold_detail;

  procedure cir_rep_unsold_summary(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pdoc_type          in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pedtn              in varchar2,
     pcity              in varchar2,
     pagcode            in varchar2,
     pdepocode          in varchar2,
     pfrom_recdate      in varchar2,
     ptill_recdate      in varchar2,
     papproved_flag     in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts)
  As
     v_frdt     date;
     v_todt    date;
  Begin
       v_frdt:=to_date(pfrom_recdate,''''||pdateformat||'''');
       v_todt:=to_date(ptill_recdate,''''||pdateformat||'''');
       
       if upper(nvl(papproved_flag,'N'))='Y' then
           open p_accounts for
           select b.comp_code comp_code,b.unit_code unit_code,b.doctype doctype,b.recptno recptno,b.recptdt recptdt,
                        b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,cir_get_city(b.comp_code,a.city_code) city_name,
                        sum(b.apr_short_recpt) short_recpt,sum(b.apr_late_recpt) late_recpt,sum(b.apr_bnr) bnr,sum(b.apr_unsold) unsold,
                        sum(nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0))*b.copy_rate copy_amt,
                        sum(b.comm_amt) comm_amt,sum(b.waste_amt) waste_amt,sum(nvl(b.copy_amt,0)) total_amt 
               from cir_agmast a,cir_unsold_dtl b
               where b.comp_code    =a.comp_code and b.comp_code    =pcomp_code and 
                           b.unit_code=a.unit and b.unit_code=punit_code and 
                           b.doctype=pdoc_type and b.app_dt between v_frdt and v_todt and 
                           a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd=pagcode) or (pagcode is null)) and
                           ((b.dpcd=pdepocode) or (pdepocode is null)) and 
                           ((b.publ=ppubl) or (ppubl is null)) and ((b.edtn=pedtn) or (pedtn is null)) and
                           ((a.city_code=pcity) or (pcity is null)) and
                           (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0 and
                           b.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null))
                           group by b.comp_code,b.unit_code,b.doctype,b.recptno,b.recptdt,b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.city_code
                           order by b.comp_code,b.unit_code,b.recptdt,b.recptno,city_name,agname;
       else
           open p_accounts for
           select b.comp_code comp_code,b.unit_code unit_code,b.doctype doctype,b.recptno recptno,b.recptdt recptdt,
                        b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,cir_get_city(b.comp_code,a.city_code) city_name,
                        sum(b.short_recpt) short_recpt,sum(b.late_recpt) late_recpt,sum(b.bnr) bnr,sum(b.unsold) unsold,
                        sum(nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0))*b.copy_rate copy_amt,
                        sum(b.comm_amt) comm_amt,sum(b.waste_amt) waste_amt,sum(nvl(b.copy_amt,0)) total_amt 
               from cir_agmast a,cir_unsold_dtl b
               where b.comp_code    =a.comp_code and b.comp_code    =pcomp_code and 
                           b.unit_code=a.unit and b.unit_code=punit_code and 
                           b.doctype=pdoc_type and b.recptdt between v_frdt and v_todt and 
                           a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd=pagcode) or (pagcode is null)) and
                           ((b.dpcd=pdepocode) or (pdepocode is null)) and
                           ((b.publ=ppubl) or (ppubl is null)) and ((b.edtn=pedtn) or (pedtn is null)) and
                           (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0 and
                           b.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null))
                            group by b.comp_code,b.unit_code,b.doctype,b.recptno,b.recptdt,b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.city_code                           
                           order by b.comp_code,b.unit_code,b.recptdt,b.recptno,city_name,agname;
       end if;    
  End cir_rep_unsold_summary;
  
   procedure cir_publ_unsold_supply(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pdoc_type          in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pedtn              in varchar2,
     pagcode            in varchar2,
     pdepocode          in varchar2,
     pfromdate          in varchar2,
     ptilldate          in varchar2,
     papproved_flag     in varchar2,
     ptaluka            in varchar2,
     pstatecode         in varchar2,
     pdistcode          in varchar2,
     pbranchcode        in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts,
     p_accounts3        out t_accounts)
  As
       v_frdt    date;
       v_todt    date;
       v_query1     varchar2(8000);
      cursor cur_publ is
          select distinct p.publ publ,p.publ_name publ_name from cir_publ_mast p,cir_agmast a,cir_unsold_dtl b
               where b.comp_code    =a.comp_code and b.comp_code    =p.comp_code and b.comp_code = pcomp_code and 
                    b.unit_code=a.unit and b.unit_code=punit_code and 
                   b.doctype=pdoc_type and b.recptdt between v_frdt and v_todt and 
                   b.publ=p.publ and b.publ=nvl(ppubl,b.publ) and 
                   a.agcd=b.agcd and b.agcd=nvl(pagcode,b.agcd) and a.dpcd=b.dpcd and b.dpcd=nvl(pdepocode,b.dpcd) and 
                   (a.tehsil_taluka=ptaluka or ptaluka is null) and
                   (a.state_code=pstatecode or pstatecode is null) and (a.dist_code=pdistcode or pdistcode is null) and
                   (a.branch_code=pbranchcode or pbranchcode is null) and
                   (upper(nvl(papproved_flag,'N'))='Y' and (nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0))>0) or
                   (upper(nvl(papproved_flag,'N'))='N' and (nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0))>0)
                   order by publ;

     v1 cur_publ%rowtype;
     vvar       varchar2(4000);
     vvar1      varchar2(4000);
     vtot_publ  varchar2(2000);
     v_cnt      number:=0;
  Begin
       v_frdt:=to_date(pfromdate,''''||pdateformat||'''');
       v_todt:=to_date(ptilldate,''''||pdateformat||'''');
        --delete from test1;
    open cur_publ;
    loop
        fetch cur_publ into v1;
      exit when cur_publ%notfound;
          v_cnt :=nvl(v_cnt,0)+1;
          if vvar is null then
              vvar        :='decode(u.publ,'||''''||v1.publ||''''||','||''''||v1.publ_name||''''||')"'||v1.publ_name||'",decode(u.publ,'||''''||v1.publ||''''||',sum(u.supply_copy))"'||v1.publ||'_SUPPLY"';
              --vvar        :='decode(u.publ,'||''''||v1.publ||''''||',sum(u.supply_copy))"'||v1.publ||'_Supply"';
              vvar        :=vvar||',decode(u.publ,'||''''||v1.publ||''''||',sum(u.return_copy))"'||v1.publ||'_RETURN"';
              vvar        :=vvar||',round((decode(u.publ,'||''''||v1.publ||''''||',sum(u.return_copy))*100)/decode(u.publ,'||''''||v1.publ||''''||',sum(u.supply_copy)),2)"'||v1.publ||'_RETURN_PER"';
              --vvar1        :='"'||v1.publ_name||'"'||',sum("'||v1.publ||'_SUPPLY") "'||v1.publ||'_SUPPLY",sum("'||v1.publ||'_RETURN") "'||v1.publ||'_RETURN",sum("'||v1.publ||'_RETURN_PER") "'||v1.publ||'_RETURN_PER"';
              vvar1        :='sum("'||v1.publ||'_SUPPLY") "'||v1.publ||'_SUPPLY",sum("'||v1.publ||'_RETURN") "'||v1.publ||'_RETURN",sum("'||v1.publ||'_RETURN_PER") "'||v1.publ||'_RETURN_PER"';
              vtot_publ:=v1.publ_name;
          else
              vvar        :=vvar||',decode(u.publ,'||''''||v1.publ||''''||','||''''||v1.publ_name||''''||')"'||v1.publ_name||'",decode(u.publ,'||''''||v1.publ||''''||',sum(u.supply_copy))"'||v1.publ||'_SUPPLY"';
              --vvar        :=vvar||',decode(u.publ,'||''''||v1.publ||''''||',sum(u.supply_copy))"'||v1.publ||'_Supply"';
              vvar        :=vvar||',decode(u.publ,'||''''||v1.publ||''''||',sum(u.return_copy))"'||v1.publ||'_RETURN"';
              vvar        :=vvar||',round((decode(u.publ,'||''''||v1.publ||''''||',sum(u.return_copy))*100)/decode(u.publ,'||''''||v1.publ||''''||',sum(u.supply_copy)),2)"'||v1.publ||'_RETURN_PER"';
              --vvar1        :=vvar1||',"'||v1.publ_name||'"'||',sum("'||v1.publ||'_SUPPLY") "'||v1.publ||'_SUPPLY",sum("'||v1.publ||'_RETURN") "'||v1.publ||'_RETURN",sum("'||v1.publ||'_RETURN_PER") "'||v1.publ||'_RETURN_PER"';
              vvar1        :=vvar1||',sum("'||v1.publ||'_SUPPLY") "'||v1.publ||'_SUPPLY",sum("'||v1.publ||'_RETURN") "'||v1.publ||'_RETURN",sum("'||v1.publ||'_RETURN_PER") "'||v1.publ||'_RETURN_PER"';
              vtot_publ:=vtot_publ||''''||','||''''||v1.publ_name;
          end if;    
    end loop;
    close cur_publ;
        --insert into test1(vstring,vstring2) values('unsold var ',vvar);commit;
        --insert into test1(vstring,vstring2) values('unsold var1 ',vvar1);commit;
        --insert into test1(vstring,vstring2) values('unsold vtot_publ ',vtot_publ);commit;
       if vvar is not null and vvar1 is not null then
           If upper(nvl(papproved_flag,'N'))='Y' Then
               
               v_query1:='select comp_code,unit_code,agcd,dpcd,agname,agname_oth_lang,city_name,taluka_name,'||vvar1 ||' from (select u.comp_code comp_code,u.unit_code unit_code,
               u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,
               nvl(cir_get_city(u.comp_code,u.city_code),''NA'') city_name,nvl(cir_get_taluka(u.comp_code,u.taluka_code),''NA'') taluka_name,
               u.publ publ,cir_get_publ_name(comp_code,publ) publ_name,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.tehsil_taluka taluka_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and (a.tehsil_taluka='||''''||ptaluka||''''||' or '||''''||ptaluka||''''||' is null) and
                               (a.state_code='||''''||pstatecode||''''||' or '||''''||pstatecode||''''||' is null) and (a.dist_code='||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and
                               (a.branch_code='||''''||pbranchcode||''''||' or '||''''||pbranchcode||''''||' is null) and
                               (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,
                                                nvl(cir_get_city(u.comp_code,u.city_code),''NA''),nvl(cir_get_taluka(u.comp_code,u.taluka_code),''NA''))
                               group by comp_code,unit_code,agcd,dpcd,agname,agname_oth_lang,city_name,taluka_name 
                               order by comp_code,unit_code,taluka_name,agname';
                               --insert into test1(vstring,vstring2) values('unsold vquery1 ',v_query1);commit;
               Begin
                  open p_accounts for v_query1;           
                     exception when others then 
                          p_accounts:=null;
                  End;        
               v_query1:='select comp_code,unit_code,taluka_name,'||vvar1 ||' from (select u.comp_code comp_code,u.unit_code unit_code,
               nvl(cir_get_taluka(u.comp_code,u.taluka_code),''NA'') taluka_name,u.publ publ,cir_get_publ_name(comp_code,publ) publ_name,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.tehsil_taluka taluka_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.tehsil_taluka='||''''||ptaluka||''''||') or ('||''''||ptaluka||''''||' is null)) and
                               (a.state_code='||''''||pstatecode||''''||' or '||''''||pstatecode||''''||' is null) and (a.dist_code='||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and
                               (a.branch_code='||''''||pbranchcode||''''||' or '||''''||pbranchcode||''''||' is null) and
                               (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,nvl(cir_get_taluka(u.comp_code,u.taluka_code),''NA''))
                               group by comp_code,unit_code,taluka_name
                               order by comp_code,unit_code,taluka_name';
                --insert into test1(vstring,vstring2) values('unsold vquery2 ',v_query1);commit;
               Begin
                  open p_accounts1 for v_query1;           
                     exception when others then
                          p_accounts1:=null;
                  End;  
               v_query1:='select comp_code,unit_code,'||vvar1 ||' from (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,cir_get_publ_name(comp_code,publ) publ_name,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.tehsil_taluka taluka_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.tehsil_taluka='||''''||ptaluka||''''||') or ('||''''||ptaluka||''''||' is null)) and
                               (a.state_code='||''''||pstatecode||''''||' or '||''''||pstatecode||''''||' is null) and (a.dist_code='||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and
                               (a.branch_code='||''''||pbranchcode||''''||' or '||''''||pbranchcode||''''||' is null) and
                               (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ)
                               group by comp_code,unit_code 
                               order by comp_code,unit_code';
               --insert into test1(vstring,vstring2) values('unsold vquery3 ',v_query1);commit;
               --open p_accounts2 for v_query1;
               Begin
                  open p_accounts2 for v_query1;           
                     exception when others then 
                          p_accounts2:=null;
                  End;
           Else
               if vvar1 is not null then
                   v_query1:='select comp_code,unit_code,agcd,dpcd,agname,agname_oth_lang,city_name,taluka_name,'||vvar1 ||' from (select u.comp_code comp_code,u.unit_code unit_code,
                   u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,
                   nvl(cir_get_city(u.comp_code,u.city_code),''NA'') city_name,nvl(cir_get_taluka(u.comp_code,u.taluka_code),''NA'') taluka_name,
                   u.publ publ,cir_get_publ_name(comp_code,publ) publ_name,'||vvar
                   ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,
                                b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                                a.city_code city_code,a.tehsil_taluka taluka_code,
                                (select sum(sup_copy) from cir_dbksup 
                                where comp_code=b.comp_code and unit_code=b.unit_code and 
                                            agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                                nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0) return_copy
                       from cir_agmast a,cir_unsold_dtl b
                       where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                                   b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                                   b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                                   ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                                   a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                                   ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.tehsil_taluka='||''''||ptaluka||''''||') or ('||''''||ptaluka||''''||' is null)) and
                                   (a.state_code='||''''||pstatecode||''''||' or '||''''||pstatecode||''''||' is null) and (a.dist_code='||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and
                                   (a.branch_code='||''''||pbranchcode||''''||' or '||''''||pbranchcode||''''||' is null) and
                                   (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0 and
                                   b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                                   where u.supply_copy>0
                                   group by u.comp_code,u.unit_code,u.publ,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,
                                            nvl(cir_get_city(u.comp_code,u.city_code),''NA''),nvl(cir_get_taluka(u.comp_code,u.taluka_code),''NA''))
                                   group by comp_code,unit_code,agcd,dpcd,agname,agname_oth_lang,city_name,taluka_name                  
                                   order by comp_code,unit_code,taluka_name,agname';
               end if;    
                --insert into test1(vstring,vstring2) values('unsold vquery1 ',v_query1);COMMIT;
               --open p_accounts for v_query1;
               Begin
                  open p_accounts for v_query1;           
                     exception when others then 
                          p_accounts:=null;
                  End;
                if vvar1 is not null then
                   v_query1:='select comp_code,unit_code,taluka_name,'||vvar1 ||' from (select u.comp_code comp_code,u.unit_code unit_code,
                   nvl(cir_get_taluka(u.comp_code,u.taluka_code),''NA'') taluka_name,'||vvar
                   ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,
                                b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                                a.city_code city_code,a.tehsil_taluka taluka_code,
                                (select sum(sup_copy) from cir_dbksup 
                                where comp_code=b.comp_code and unit_code=b.unit_code and 
                                            agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                                nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0) return_copy
                       from cir_agmast a,cir_unsold_dtl b
                       where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                                   b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                                   b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                                   ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                                   a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                                   ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.tehsil_taluka='||''''||ptaluka||''''||') or ('||''''||ptaluka||''''||' is null)) and
                                   (a.state_code='||''''||pstatecode||''''||' or '||''''||pstatecode||''''||' is null) and (a.dist_code='||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and
                                   (a.branch_code='||''''||pbranchcode||''''||' or '||''''||pbranchcode||''''||' is null) and
                                   (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0 and
                                   b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                                   where u.supply_copy>0
                                   group by u.comp_code,u.unit_code,u.publ,cir_get_taluka(u.comp_code,u.taluka_code))
                                   group by comp_code,unit_code,taluka_name
                                   order by comp_code,unit_code,taluka_name';
                   --insert into test1(vstring,vstring2) values('unsold vquery2 ',v_query1);COMMIT;
              end if;
               --open p_accounts1 for v_query1;
               Begin
                  open p_accounts1 for v_query1;           
                     exception when others then 
                          p_accounts1:=null;
                  End; 
                if vvar1 is not null then
                   v_query1:='select comp_code,unit_code,'||vvar1 ||' from (select u.comp_code comp_code,u.unit_code unit_code,'||vvar
                   ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,
                                b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                                a.city_code city_code,a.tehsil_taluka taluka_code,
                                (select sum(sup_copy) from cir_dbksup 
                                where comp_code=b.comp_code and unit_code=b.unit_code and 
                                            agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                                nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0) return_copy
                       from cir_agmast a,cir_unsold_dtl b
                       where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                                   b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                                   b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                                   ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                                   a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                                   ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.tehsil_taluka='||''''||ptaluka||''''||') or ('||''''||ptaluka||''''||' is null)) and
                                   (a.state_code='||''''||pstatecode||''''||' or '||''''||pstatecode||''''||' is null) and (a.dist_code='||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and
                                   (a.branch_code='||''''||pbranchcode||''''||' or '||''''||pbranchcode||''''||' is null) and
                                   (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0 and
                                   b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                                   where u.supply_copy>0
                                   group by u.comp_code,u.unit_code,u.publ)
                                   group by comp_code,unit_code
                                   order by comp_code,unit_code';--,'||vtot_publ;
                   end if;
                --insert into test1(vstring,vstring2) values('unsold vquery3 ',v_query1);COMMIT;
              --open p_accounts2 for v_query1;
              Begin
                  open p_accounts2 for v_query1;           
                     exception when others then 
                          p_accounts2:=null;
                  End;
           End if;
             v_query1:='select '||''''||vtot_publ||''''||' from dual';
             --open p_accounts3 for v_query1;
                    Begin
                  open p_accounts3 for v_query1;           
                     exception when others then 
                          p_accounts3:=null;
                  End;
        End if;

  End cir_publ_unsold_supply;


    procedure cir_edtn_unsold_supply(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pdoc_type          in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pedtn              in varchar2,
     pagcode            in varchar2,
     pdepocode          in varchar2,
     pfromdate          in varchar2,
     ptilldate          in varchar2,
     papproved_flag     in varchar2,
     ptaluka            in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts,
     p_accounts3        out t_accounts)
  As
       v_frdt    date;
       v_todt    date;
       v_query1  varchar2(32000);
      cursor cur_edtn is
          select distinct u.publ publ,u.edtn edtn,u.edtn_name edtn_name,u.edtn_seq_no edtn_seq_no from
          (select distinct e.publ publ,e.edtn edtn,e.edtn_name edtn_name,e.edtn_seq_no edtn_seq_no from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e 
          where b.comp_code = a.comp_code and b.comp_code = e.comp_code and b.comp_code=pcomp_code and
          b.unit_code = a.unit and b.unit_code = e.unit_code and b.unit_code = punit_code and 
          b.doctype=pdoc_type and b.recptdt>= v_frdt and b.recptdt <= v_todt and 
          b.publ=e.publ and b.publ=nvl(ppubl,e.publ) and b.edtn=e.edtn and b.edtn=nvl(pedtn,b.edtn) and 
          a.agcd=b.agcd and a.dpcd=b.dpcd and b.agcd=nvl(pagcode,b.agcd) and 
          b.dpcd=nvl(pdepocode,b.dpcd) and (a.tehsil_taluka=ptaluka or ptaluka is null) and
          nvl(papproved_flag,'N')='Y' and (nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0))>0
          union
          select distinct e.publ publ,e.edtn edtn,e.edtn_name edtn_name,e.edtn_seq_no edtn_seq_no from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e 
          where b.comp_code = a.comp_code and b.comp_code = e.comp_code and b.comp_code=pcomp_code and
          b.unit_code = a.unit and b.unit_code = e.unit_code and b.unit_code = punit_code and 
          b.doctype=pdoc_type and b.recptdt>= v_frdt and b.recptdt <= v_todt and 
          b.publ=e.publ and b.publ=nvl(ppubl,e.publ) and b.edtn=e.edtn and b.edtn=nvl(pedtn,b.edtn) and 
          a.agcd=b.agcd and a.dpcd=b.dpcd and b.agcd=nvl(pagcode,b.agcd) and 
          b.dpcd=nvl(pdepocode,b.dpcd) and (a.tehsil_taluka=ptaluka or ptaluka is null) and
          nvl(papproved_flag,'N')='N' and (nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0))>0) u
          order by edtn_seq_no,edtn;

     rec_edtn cur_edtn%rowtype;
     vvar       varchar2(10000);
     tot_vvar   varchar2(10000);
     vtot_publ  varchar2(8000);
     v_cnt      number:=0;
  Begin
       v_frdt:=to_date(pfromdate,''''||pdateformat||'''');
       v_todt:=to_date(ptilldate,''''||pdateformat||'''');
    open cur_edtn;
    loop
        fetch cur_edtn into rec_edtn;
      exit when cur_edtn%notfound;
          v_cnt :=nvl(v_cnt,0)+1;
          if vvar is null then
              vvar        :='decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.supply_copy))"'||rec_edtn.edtn||'_SUPPLY"';
              vvar        :=vvar||',decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.return_copy))"'||rec_edtn.edtn||'_RETURN"';
              vvar        :=vvar||',round((decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.return_copy))*100)/decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.supply_copy)),2)"'||rec_edtn.edtn||'_RETURN_PER"';
              tot_vvar:=',sum("'||rec_edtn.edtn||'_SUPPLY") "'||rec_edtn.edtn||'_SUPPLY"';
              tot_vvar:=tot_vvar||',sum("'||rec_edtn.edtn||'_RETURN") "'||rec_edtn.edtn||'_RETURN"';
              tot_vvar:=tot_vvar||',sum("'||rec_edtn.edtn||'_RETURN_PER") "'||rec_edtn.edtn||'_RETURN_PER"';
              vtot_publ:=rec_edtn.edtn_name;
          else
              vvar        :=vvar||',decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.supply_copy))"'||rec_edtn.edtn||'_SUPPLY"';
              vvar        :=vvar||',decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.return_copy))"'||rec_edtn.edtn||'_RETURN"';
              vvar        :=vvar||',round((decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.return_copy))*100)/decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.supply_copy)),2)"'||rec_edtn.edtn||'_RETURN_PER"';
              tot_vvar:=tot_vvar||',sum("'||rec_edtn.edtn||'_SUPPLY") "'||rec_edtn.edtn||'_SUPPLY"';
              tot_vvar:=tot_vvar||',sum("'||rec_edtn.edtn||'_RETURN") "'||rec_edtn.edtn||'_RETURN"';
              tot_vvar:=tot_vvar||',sum("'||rec_edtn.edtn||'_RETURN_PER") "'||rec_edtn.edtn||'_RETURN_PER"';
              vtot_publ:=vtot_publ||''''||','||''''||rec_edtn.edtn_name;
          end if;    
    end loop;
    close cur_edtn;
    
        --delete test1;
        --insert into test1(vstring,vstring2) values('unsold edtn vvar ',vvar);COMMIT;
        --insert into test1(vstring,vstring2) values('unsold edtn TOT_vvar ',tot_vvar);COMMIT;
        if vvar is not null then
           If nvl(papproved_flag,'N')='Y' Then
               v_query1:='select c.comp_code comp_code,c.unit_code unit_code,c.agcd agcd,c.dpcd dpcd,c.agname agname,c.agname_oth_lang agname_oth_lang,
               nvl(cir_get_city(c.comp_code,c.city_code),''NA'') city_name,nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA'') taluka_name '||tot_vvar||'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,
               u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,u.city_code city_code,u.taluka_code taluka_code,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.tehsil_taluka taluka_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               ((b.edtn='||''''||pedtn||''''||') or ('||''''||pedtn||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.tehsil_taluka='||''''||ptaluka||''''||') or ('||''''||ptaluka||''''||' is null)) and
                               (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,
                               u.city_code,u.taluka_code) c
                               group by c.comp_code,c.unit_code,c.agcd,c.dpcd,c.agname,c.agname_oth_lang,nvl(cir_get_city(c.comp_code,c.city_code),''NA''),
                               nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA'')
                               order by c.comp_code,c.unit_code,nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA''),c.agname';
                                              
               --insert into test1(vstring,vstring2) values('unsold edtn YY ',v_query1);COMMIT;
               open p_accounts for v_query1;           
               
               v_query1:='select c.comp_code comp_code,c.unit_code unit_code,
               nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA'') taluka_name '||tot_vvar||'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,
               u.taluka_code taluka_code,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.tehsil_taluka taluka_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                            agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               ((b.edtn='||''''||pedtn||''''||') or ('||''''||pedtn||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.tehsil_taluka='||''''||ptaluka||''''||') or ('||''''||ptaluka||''''||' is null)) and
                               (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.taluka_code) c
                               group by c.comp_code,c.unit_code,nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA'')
                               order by c.comp_code,c.unit_code,nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA'')';
                
                --insert into test1(vstring,vstring2) values('unsold edtn v_query2 ',v_query1);COMMIT;
                open p_accounts1 for v_query1;
               
               v_query1:='select c.comp_code comp_code,c.unit_code unit_code '||tot_vvar||'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.tehsil_taluka taluka_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               ((b.edtn='||''''||pedtn||''''||') or ('||''''||pedtn||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.tehsil_taluka='||''''||ptaluka||''''||') or ('||''''||ptaluka||''''||' is null)) and
                               (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,cir_get_edtn_name(u.comp_code,u.edtn))c
                               group by c.comp_code,c.unit_code
                               order by c.comp_code,c.unit_code';
               --insert into test1(vstring,vstring2) values('unsold edtn v_query3 ',v_query1);COMMIT;
               open p_accounts2 for v_query1;
           Else
               v_query1:='select c.comp_code comp_code,c.unit_code unit_code,c.agcd agcd,c.dpcd dpcd,c.agname agname,c.agname_oth_lang agname_oth_lang,
               nvl(cir_get_city(c.comp_code,c.city_code),''NA'') city_name,nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA'') taluka_name '||tot_vvar||'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,
               u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,u.city_code city_code,u.taluka_code taluka_code,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.tehsil_taluka taluka_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               ((b.edtn='||''''||pedtn||''''||') or ('||''''||pedtn||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.tehsil_taluka='||''''||ptaluka||''''||') or ('||''''||ptaluka||''''||' is null)) and
                               (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,
                               u.city_code,u.taluka_code) c
                               group by c.comp_code,c.unit_code,c.agcd,c.dpcd,c.agname,c.agname_oth_lang,nvl(cir_get_city(c.comp_code,c.city_code),''NA''),
                               nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA'')
                               order by c.comp_code,c.unit_code,nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA''),c.agname';
                    --insert into test1(vstring,vstring2) values('unsold edtn v_query1 ',v_query1);COMMIT;
               open p_accounts for v_query1;
    
               v_query1:='select c.comp_code comp_code,c.unit_code unit_code,
               nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA'') taluka_name '||tot_vvar||'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,
               u.taluka_code taluka_code,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.tehsil_taluka taluka_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               ((b.edtn='||''''||pedtn||''''||') or ('||''''||pedtn||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.tehsil_taluka='||''''||ptaluka||''''||') or ('||''''||ptaluka||''''||' is null)) and
                               (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.taluka_code) c
                               group by c.comp_code,c.unit_code,nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA'')
                               order by c.comp_code,c.unit_code,nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA'')';
               --insert into test1(vstring,vstring2) values('unsold edtn v_query2 ',v_query1);COMMIT;
               open p_accounts1 for v_query1;
    
               v_query1:='select c.comp_code comp_code,c.unit_code unit_code '||tot_vvar||'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.tehsil_taluka taluka_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               ((b.edtn='||''''||pedtn||''''||') or ('||''''||pedtn||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.tehsil_taluka='||''''||ptaluka||''''||') or ('||''''||ptaluka||''''||' is null)) and
                               (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,cir_get_edtn_name(u.comp_code,u.edtn))c
                               group by c.comp_code,c.unit_code
                               order by c.comp_code,c.unit_code';
                --insert into test1(vstring,vstring2) values('unsold edtn v_query3 ',v_query1);COMMIT;
               open p_accounts2 for v_query1;
           End if;
                 v_query1:='select '||''''||vtot_publ||''''||' from dual';
                 open p_accounts3 for v_query1;
        Else
            v_query1:='select '||''''||pcomp_code||''''||' comp_code,'||''''||punit_code||''''||' unit_code,null agcd,null dpcd,null agname,null agname_oth_lang,null city_name,null taluka_name,0 supply_copy,0 return_copy from dual';
            --insert into test1(vstring,vstring2) values('unsold else edtn vquery ',v_query1);COMMIT;
            open p_accounts for v_query1;
            v_query1:='select '||''''||pcomp_code||''''||' comp_code,'||''''||punit_code||''''||' unit_code,null taluka_name,0 supply_copy,0 return_copy from dual';
            --insert into test1(vstring,vstring2) values('unsold else edtn vquery2 ',v_query1);COMMIT;
            open p_accounts1 for v_query1;
            v_query1:='select '||''''||pcomp_code||''''||' comp_code,'||''''||punit_code||''''||' unit_code,0 supply_copy,0 return_copy from dual';
            --insert into test1(vstring,vstring2) values('unsold else edtn vquery3 ',v_query1);COMMIT;
            open p_accounts2 for v_query1;
                 v_query1:='select null from dual';
            open p_accounts3 for v_query1;            
        End if;
  End cir_edtn_unsold_supply;
    
    procedure cir_edtn_unsold_supply_dist(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pdoc_type          in varchar2,
     ppubl              in varchar2,
     pmainedtn             in varchar2,
     pedtn              in varchar2,
     pagcode            in varchar2,
     pdepocode          in varchar2,
     pfromdate          in varchar2,
     ptilldate          in varchar2,
     papproved_flag        in varchar2,
     pdistcd            in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts,
     p_accounts3         out t_accounts)
  As
       v_frdt    date;
       v_todt    date;
       v_query1     varchar2(32000);
      cursor cur_edtn is
        select distinct u.publ publ,u.edtn edtn,u.edtn_name edtn_name,u.edtn_seqno edtn_seq_no from
        (select distinct e.publ publ,e.edtn edtn,e.edtn_name edtn_name,e.edtn_seq_no edtn_seqno
        from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e 
        where a.comp_code=b.comp_code and b.comp_code=e.comp_code and b.comp_code=pcomp_code and
        a.unit=b.unit_code and b.unit_code=e.unit_code and b.unit_code=punit_code and b.doctype=pdoc_type and 
        b.recptdt >= v_frdt and b.recptdt<=v_todt and b.publ=e.publ and b.publ=nvl(ppubl,b.publ) and 
        b.edtn=e.edtn and b.edtn=nvl(pedtn,b.edtn) and a.agcd=b.agcd and a.dpcd=b.dpcd and b.agcd=nvl(pagcode,b.agcd) and 
        b.dpcd=nvl(pdepocode,b.dpcd) and (a.dist_code=pdistcd or pdistcd is null) and
        nvl(papproved_flag,'N')='Y' and (nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0))>0
        union
        select distinct e.publ publ,e.edtn edtn,e.edtn_name edtn_name,e.edtn_seq_no edtn_seqno 
        from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e 
        where a.comp_code=b.comp_code and b.comp_code=e.comp_code and b.comp_code=pcomp_code and
        a.unit=b.unit_code and b.unit_code=e.unit_code and b.unit_code=punit_code and b.doctype=pdoc_type and 
        b.recptdt >= v_frdt and b.recptdt<=v_todt and b.publ=e.publ and b.publ=nvl(ppubl,b.publ) and 
        b.edtn=e.edtn and b.edtn=nvl(pedtn,b.edtn) and a.agcd=b.agcd and a.dpcd=b.dpcd and b.agcd=nvl(pagcode,b.agcd) and 
        b.dpcd=nvl(pdepocode,b.dpcd) and (a.dist_code=pdistcd or pdistcd is null) and
        nvl(papproved_flag,'N')='N' and (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0) u
        order by edtn_seq_no,edtn;

     rec_edtn cur_edtn%rowtype;
     vvar         varchar2(10000);
     tot_vvar varchar2(10000);
     vtot_publ varchar2(8000);
     v_cnt     number:=0;
  Begin
       v_frdt:=to_date(pfromdate,''''||pdateformat||'''');
       v_todt:=to_date(ptilldate,''''||pdateformat||'''');
    open cur_edtn;
    loop
        fetch cur_edtn into rec_edtn;
      exit when cur_edtn%notfound;
          v_cnt :=nvl(v_cnt,0)+1;
          if vvar is null then
              vvar        :='decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.supply_copy))"'||rec_edtn.edtn||'_SUPPLY"';
              vvar        :=vvar||',decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.return_copy))"'||rec_edtn.edtn||'_RETURN"';
              vvar        :=vvar||',round((decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.return_copy))*100)/decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.supply_copy)),2)"'||rec_edtn.edtn||'_RETURN_PER"';
              tot_vvar:=tot_vvar||',sum("'||rec_edtn.edtn||'_SUPPLY") "'||rec_edtn.edtn||'_SUPPLY"';
              tot_vvar:=tot_vvar||',sum("'||rec_edtn.edtn||'_RETURN") "'||rec_edtn.edtn||'_RETURN"';
              tot_vvar:=tot_vvar||',sum("'||rec_edtn.edtn||'_RETURN_PER") "'||rec_edtn.edtn||'_RETURN_PER"';
              vtot_publ:=rec_edtn.edtn_name;
          else
              vvar        :=vvar||',decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.supply_copy))"'||rec_edtn.edtn||'_SUPPLY"';
              vvar        :=vvar||',decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.return_copy))"'||rec_edtn.edtn||'_RETURN"';
              vvar        :=vvar||',round((decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.return_copy))*100)/decode(u.edtn,'||''''||rec_edtn.edtn||''''||',sum(u.supply_copy)),2)"'||rec_edtn.edtn||'_RETURN_PER"';
              tot_vvar:=tot_vvar||',sum("'||rec_edtn.edtn||'_SUPPLY") "'||rec_edtn.edtn||'_SUPPLY"';
              tot_vvar:=tot_vvar||',sum("'||rec_edtn.edtn||'_RETURN") "'||rec_edtn.edtn||'_RETURN"';
              tot_vvar:=tot_vvar||',sum("'||rec_edtn.edtn||'_RETURN_PER") "'||rec_edtn.edtn||'_RETURN_PER"';
              vtot_publ:=vtot_publ||''''||','||''''||rec_edtn.edtn_name;
          end if;    
    end loop;
    close cur_edtn;
    
        --delete test1;
        --insert into test1(vstring,vstring2) values('unsold edtn vvar ',vvar);COMMIT;
        --insert into test1(vstring,vstring2) values('unsold edtn TOT_vvar ',tot_vvar);COMMIT;
        if vvar is not null then
           If nvl(papproved_flag,'N')='Y' Then
               v_query1:='select c.comp_code comp_code,c.unit_code unit_code,c.agcd agcd,c.dpcd dpcd,c.agname agname,c.agname_oth_lang agname_oth_lang,
               nvl(cir_get_city(c.comp_code,c.city_code),''NA'') city_name,nvl(cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'') dist_name '||tot_vvar||'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,
               u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,u.city_code city_code,u.state_code state_code,u.dist_code dist_code,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.state_code state_code,a.dist_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               ((b.edtn='||''''||pedtn||''''||') or ('||''''||pedtn||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.dist_code='||''''||pdistcd||''''||') or ('||''''||pdistcd||''''||' is null)) and
                               (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,
                               u.city_code,u.state_code,u.dist_code) c
                               group by c.comp_code,c.unit_code,c.agcd,c.dpcd,c.agname,c.agname_oth_lang,nvl(cir_get_city(c.comp_code,c.city_code),''NA''),
                               nvl(cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'')
                               order by c.comp_code,c.unit_code,nvl(cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA''),c.agname';
                                              
               --insert into test1(vstring,vstring2) values('unsold edtn p_accounts ',v_query1);COMMIT;
               open p_accounts for v_query1;           
               
               v_query1:='select c.comp_code comp_code,c.unit_code unit_code,
               nvl(cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'') dist_name '||tot_vvar||'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,
               u.state_code state_code,u.dist_code dist_code,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.state_code state_code,a.dist_code dist_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                            agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               ((b.edtn='||''''||pedtn||''''||') or ('||''''||pedtn||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.dist_code='||''''||pdistcd||''''||') or ('||''''||pdistcd||''''||' is null)) and
                               (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.state_code,u.dist_code) c
                               group by c.comp_code,c.unit_code,nvl(cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'')
                               order by c.comp_code,c.unit_code,nvl(cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'')';
                
                --insert into test1(vstring,vstring2) values('unsold edtn p_accounts1 ',v_query1);COMMIT;
                open p_accounts1 for v_query1;
               
               v_query1:='select c.comp_code comp_code,c.unit_code unit_code '||tot_vvar||'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.state_code state_code,a.dist_code dist_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               ((b.edtn='||''''||pedtn||''''||') or ('||''''||pedtn||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.dist_code='||''''||pdistcd||''''||') or ('||''''||pdistcd||''''||' is null)) and
                               (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,cir_get_edtn_name(u.comp_code,u.edtn))c
                               group by c.comp_code,c.unit_code
                               order by c.comp_code,c.unit_code';
               --insert into test1(vstring,vstring2) values('unsold edtn p_accounts2 ',v_query1);COMMIT;
               open p_accounts2 for v_query1;
           Else
               v_query1:='select c.comp_code comp_code,c.unit_code unit_code,c.agcd agcd,c.dpcd dpcd,c.agname agname,c.agname_oth_lang agname_oth_lang,
               nvl(cir_get_city(c.comp_code,c.city_code),''NA'') city_name,nvl(cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'') dist_name '||tot_vvar||'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,
               u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,u.city_code city_code,u.state_code state_code,u.dist_code dist_code,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.state_code state_code,a.dist_code dist_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               ((b.edtn='||''''||pedtn||''''||') or ('||''''||pedtn||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.dist_code='||''''||pdistcd||''''||') or ('||''''||pdistcd||''''||' is null)) and
                               (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,
                               u.city_code,u.state_code,u.dist_code) c
                               group by c.comp_code,c.unit_code,c.agcd,c.dpcd,c.agname,c.agname_oth_lang,nvl(cir_get_city(c.comp_code,c.city_code),''NA''),
                               nvl(cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'')
                               order by c.comp_code,c.unit_code,nvl(cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA''),c.agname';
                    --insert into test1(vstring,vstring2) values('unsold edtn p_accounts',v_query1);COMMIT;
               open p_accounts for v_query1;
    
               v_query1:='select c.comp_code comp_code,c.unit_code unit_code,
               nvl(cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'') dist_name '||tot_vvar||'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,
               u.state_code state_code,u.dist_code dist_code,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.state_code state_code,a.dist_code dist_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               ((b.edtn='||''''||pedtn||''''||') or ('||''''||pedtn||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.dist_code='||''''||pdistcd||''''||') or ('||''''||pdistcd||''''||' is null)) and
                               (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.state_code,u.dist_code) c
                               group by c.comp_code,c.unit_code,nvl(cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'')
                               order by c.comp_code,c.unit_code,nvl(cir_get_dist(c.comp_code,c.state_code,c.dist_code),''NA'')';
               --insert into test1(vstring,vstring2) values('unsold edtn p_accounts1 ',v_query1);COMMIT;
               open p_accounts1 for v_query1;
    
               v_query1:='select c.comp_code comp_code,c.unit_code unit_code '||tot_vvar||'
               from
               (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,'||vvar
               ||'    from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,
                            b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                            a.city_code city_code,a.state_code state_code,a.dist_code dist_code,
                            (select sum(sup_copy) from cir_dbksup 
                            where comp_code=b.comp_code and unit_code=b.unit_code and 
                                        agcd=b.agcd and dpcd=b.dpcd and publ=b.publ and supdate=b.supdate) supply_copy,
                            nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0) return_copy
                   from cir_agmast a,cir_unsold_dtl b
                   where b.comp_code    =a.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                               b.unit_code=a.unit and b.unit_code='||''''||punit_code||''''||' and 
                               b.doctype='||''''||pdoc_type||''''||' and b.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and 
                               ((b.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and 
                               ((b.edtn='||''''||pedtn||''''||') or ('||''''||pedtn||''''||' is null)) and 
                               a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd='||''''||pagcode||''''||') or ('||''''||pagcode||''''||' is null)) and 
                               ((b.dpcd='||''''||pdepocode||''''||') or ('||''''||pdepocode||''''||' is null)) and ((a.dist_code='||''''||pdistcd||''''||') or ('||''''||pdistcd||''''||' is null)) and
                               (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0 and
                               b.edtn in(select distinct edtn from cir_edtn_mast where comp_code='||''''||pcomp_code||''''||' and (edtn = '||''''||pedtn||''''||' or '||''''||pedtn||''''||' is null) and (main_edtn='||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null))) u
                               where u.supply_copy>0
                               group by u.comp_code,u.unit_code,u.publ,u.edtn,cir_get_edtn_name(u.comp_code,u.edtn))c
                               group by c.comp_code,c.unit_code
                               order by c.comp_code,c.unit_code';
                --insert into test1(vstring,vstring2) values('unsold edtn p_accounts2 ',v_query1);COMMIT;
               open p_accounts2 for v_query1;
           End if;
                 v_query1:='select '||''''||vtot_publ||''''||' from dual';
                 open p_accounts3 for v_query1;
        Else
            v_query1:='select '||''''||pcomp_code||''''||' comp_code,'||''''||punit_code||''''||' unit_code,null agcd,null dpcd,null agname,null agname_oth_lang,null city_name,null taluka_name,0 supply_copy,0 return_copy from dual';
            --insert into test1(vstring,vstring2) values('unsold else edtn vquery p_accounts',v_query1);COMMIT;
            open p_accounts for v_query1;
            v_query1:='select '||''''||pcomp_code||''''||' comp_code,'||''''||punit_code||''''||' unit_code,null taluka_name,0 supply_copy,0 return_copy from dual';
            --insert into test1(vstring,vstring2) values('unsold else edtn p_accounts1 ',v_query1);COMMIT;
            open p_accounts1 for v_query1;
            v_query1:='select '||''''||pcomp_code||''''||' comp_code,'||''''||punit_code||''''||' unit_code,0 supply_copy,0 return_copy from dual';
            --insert into test1(vstring,vstring2) values('unsold else edtn p_accounts2 ',v_query1);COMMIT;
            open p_accounts2 for v_query1;
                 v_query1:='select null from dual';
             open p_accounts3 for v_query1;
        End if;
  End cir_edtn_unsold_supply_dist;  
  
procedure cir_monthly_net_paid_sale(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pedtn              in varchar2,
     pfromdate          in varchar2,
     ptilldate          in varchar2,
     pagency_type       in varchar2,
     pagency_class      in varchar2,
     pstatecode         in varchar2,
     pdistcode          in varchar2,
     ptaluka            in varchar2,
     pbranch            in varchar2,
     pagcd              in varchar2,
     pdpcd              in varchar2,
     preptype           in number,--1 for Agency Wise,2 for Main Edition wise,3 for District Taluka wise
     pbreak_on          in varchar2,--Region R/State S/District D/Branch B
     preturn_based      in varchar2,--it is use for return date or supply date(R/S)
     plangtype          in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     pextra3            in varchar2,
     pextra4            in varchar2,
     pextra5            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts,
     p_accounts3        out t_accounts)
  As
     v_frdt    date;
     v_todt    date;
     v_reg_code varchar2(200);
     v_avg_sale number(10);
cursor c1 is
    select u.comp_code,u.unit_code,
    u.branch_code branch_code,(select distinct "Branch_Name" from branch_mst where "Branch_Code"=u.branch_code) branch_name,
    u.publ,u.publ_name,u.main_edtn,
    cir_get_edtn_name(u.comp_code,u.main_edtn) main_edtn_name,u.edtn edtn,u.edtn_name,u.copy_rate,
    u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,
    u.state_code,cir_get_state(u.comp_code,u.country_code,u.state_code) state_name,
    u.dist_code ,cir_get_name.cir_district(u.comp_code,u.dist_code,plangtype,null,null,null) dist_name,
    u.city_code city_code,cir_get_name.cir_city(u.comp_code,u.city_code,plangtype,null,null,null) city_name,
    u.tehsil_taluka,cir_get_name.cir_taluka(u.comp_code,u.tehsil_taluka,plangtype,null,null,null) taluka_name,
    sum(supply_copy) supply_copy,sum(return_copy) return_copy,
    sum(supply_copy)-sum(return_copy) net_sale_copy,sum(no_of_days) no_of_days
    from (
    select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate copy_rate,
    b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
    a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka, 
    sum(nvl(b.sup_copy,0)) supply_copy,0 return_copy, count(distinct supdate) no_of_days
    from cir_agmast a,cir_dbksup b,cir_edtn_mast e,cir_publ_mast p
    where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and 
    b.comp_code =pcomp_code and 
    b.unit_code=a.unit and b.unit_code=punit_code and 
    b.publ=p.publ and b.publ=nvl(ppubl,b.publ) and b.edtn=e.edtn and b.edtn=nvl(pedtn,b.edtn) and
    a.agcd=b.agcd and b.agcd=nvl(pagcd,b.agcd) and a.dpcd=b.dpcd and b.dpcd=nvl(pdpcd,b.dpcd) and
    b.supdate >= v_frdt and b.supdate <=v_todt and 
    (a.ag_type=pagency_type or pagency_type is null) and(a.ag_class=pagency_class or pagency_class is null) and
    (a.branch_code=pbranch or pbranch is null) and (a.state_code=pstatecode or pstatecode is null) and
    (a.dist_code=pdistcode or pdistcode is null) and (a.tehsil_taluka=ptaluka or ptaluka is null) and
    (e.main_edtn=pmainedtn or pmainedtn is null)
    group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.sup_rate,
    b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
    a.country_code,a.tehsil_taluka
    union all
    select b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
    b.agcd,b.dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
    a.branch_code,a.city_code,a.dist_code, a.state_code,a.country_code,a.tehsil_taluka, 
    0 supply_copy,sum(nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0)) return_copy,0 no_of_days
    from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e,cir_publ_mast p
    where b.comp_code =a.comp_code and b.comp_code=e.comp_code and b.comp_code=p.comp_code and b.comp_code =pcomp_code and 
    b.unit_code=a.unit and b.unit_code=punit_code and 
    b.doctype='UCN' and b.recptdt >= v_frdt and b.recptdt <=v_todt and 
    b.publ=e.publ and b.publ=p.publ and b.publ=nvl(ppubl,b.publ) and b.edtn=e.edtn and b.edtn=nvl(pedtn,b.edtn) and 
    a.agcd=b.agcd and b.agcd=nvl(pagcd,b.agcd) and a.dpcd=b.dpcd and b.dpcd=nvl(pdpcd,b.dpcd) and 
    (a.ag_type=pagency_type or pagency_type is null) and(a.ag_class=pagency_class or pagency_class is null) and
    (a.branch_code=pbranch or pbranch is null) and (a.state_code=pstatecode or pstatecode is null) and
    (a.dist_code=pdistcode or pdistcode is null) and (a.tehsil_taluka=ptaluka or ptaluka is null) and
    (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0 and
    (e.main_edtn=pmainedtn or pmainedtn is null)
    group by b.comp_code,b.unit_code,b.publ,p.publ_name,e.main_edtn,b.edtn,e.edtn_name,b.copy_rate,
    b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.branch_code,a.city_code,a.dist_code, a.state_code,
    a.country_code,a.tehsil_taluka) u
    where (u.supply_copy+u.return_copy)>0
    group by u.comp_code,u.unit_code,
    u.branch_code,u.publ,u.publ_name,u.main_edtn,u.edtn,u.edtn_name,u.copy_rate,
    u.agcd,u.dpcd,u.agname,u.agname_oth_lang,
    u.state_code,u.dist_code ,u.city_code,u.tehsil_taluka,u.country_code;
            
    v1 c1%rowtype;
   
  Begin
        
        v_frdt         :=to_date(pfromdate,''''||pdateformat||'''');
        v_todt         :=to_date(ptilldate,''''||pdateformat||'''');
        delete from cir_temp_bill_collection where cur_sessionid=userenv('sessionid');
        open c1;
        loop
            fetch c1 into v1;
            exit when c1%notfound;
            /*select count(*) into v_hdays from cir_holiday_mast 
                where comp_code=v1.comp_code and unit=v1.unit_code and (h_publ=ppubl or ppubl is null) and 
                    trunc(h_date,'mm')=v1.mon;*/
            if nvl(v1.no_of_days,0)>0 then
                v_avg_sale:=round(nvl(v1.net_sale_copy,0)/(nvl(v1.no_of_days,0)));
            else
                v_avg_sale:=nvl(v1.net_sale_copy,0);
            end if;
            begin
                select distinct region_code into v_reg_code from cir_city_mast where comp_code=v1.comp_code and city_code=v1.city_code;
            exception when others then
             v_reg_code:=null;
            end;
            
            v_reg_code:=cir_get_region_name(v1.comp_code,v_reg_code); 
            insert into cir_temp_bill_collection
            (comp_code, unit_code, billno, publ_code, agcd, dpcd,agname,agname_oth_lang, city_code, 
            taluka_code, dist_code, state_code, remarks,supply_copy, return_copy ,comm_amt,gross_amt,cur_sessionid)
            values(v1.comp_code,v1.unit_code,v1.branch_name,v1.publ_name,v1.main_edtn_name,v1.edtn_name,v1.agname,v1.agname_oth_lang,v1.city_name,
            v1.taluka_name,v1.dist_name,v1.state_name,v_reg_code,v1.supply_copy,v1.return_copy,v1.copy_rate,v1.no_of_days,userenv('sessionid'));

        end loop;
        close c1;
        commit;
        if preptype=1 then
            if pbreak_on='R' then
                open p_accounts for
                select comp_code AS "COMP_CODE", unit_code AS "UNIT",agname AS "AGNAME",agname_oth_lang AS "AGNAME_OTH_LANG",city_code as "CITY_NAME", 
                remarks AS "REGION_NAME",comm_amt as "COPY_RATE",supply_copy AS "SUPPLY_COPY", return_copy AS "RETURN_COPY" ,(supply_copy-return_copy) AS "NET_SALE",
                case when nvl(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as "NET_PER",
                gross_amt AS "NO_OF_DAYS",case when nvl(gross_amt,0)>0 then round((supply_copy-return_copy)/gross_amt) else 0 end AS "AVG_NET_SALE" 
                from cir_temp_bill_collection where cur_sessionid=userenv('sessionid') order by remarks,agname,city_name,copy_rate;

                open p_accounts1 for
                select comp_code AS "COMP_CODE",  
                remarks AS "REGION_NAME",sum(supply_copy) AS "SUPPLY_COPY", sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",
                case when nvl(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as "NET_PER",
                0 AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from cir_temp_bill_collection where cur_sessionid=userenv('sessionid') 
                group by comp_code,remarks order by region_name;            
            elsif pbreak_on='S' then
                open p_accounts for
                select comp_code AS "COMP_CODE", unit_code AS "UNIT",agname AS "AGNAME",agname_oth_lang AS "AGNAME_OTH_LANG",city_code as "CITY_NAME", 
                state_code AS "STATE_NAME",comm_amt as "COPY_RATE",supply_copy AS "SUPPLY_COPY", return_copy AS "RETURN_COPY" ,(supply_copy-return_copy) AS "NET_SALE",
                case when nvl(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as "NET_PER",
                gross_amt AS "NO_OF_DAYS",case when nvl(gross_amt,0)>0 then round((supply_copy-return_copy)/gross_amt) else 0 end AS "AVG_NET_SALE" 
                from cir_temp_bill_collection where cur_sessionid=userenv('sessionid') 
                order by state_name,agname,city_name,comm_amt;

                open p_accounts1 for
                select comp_code AS "COMP_CODE",  
                state_code AS "STATE_NAME",sum(supply_copy) AS "SUPPLY_COPY", sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",
                case when nvl(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as "NET_PER",
                0 AS "NO_OF_DAYS",case when nvl(sum(gross_amt),0)>0 then round(sum(supply_copy-return_copy)/sum(gross_amt)) else 0 end AS "AVG_NET_SALE"
                from cir_temp_bill_collection where cur_sessionid=userenv('sessionid') 
                group by comp_code,state_code order by state_name;                
            elsif pbreak_on='D' then
                open p_accounts for
                select comp_code AS "COMP_CODE", unit_code AS "UNIT",agname AS "AGNAME",agname_oth_lang AS "AGNAME_OTH_LANG",city_code as "CITY_NAME", 
                state_code AS "STATE_NAME",dist_code AS "DIST_NAME",comm_amt as "COPY_RATE",supply_copy AS "SUPPLY_COPY", return_copy AS "RETURN_COPY" ,(supply_copy-return_copy) AS "NET_SALE",
                case when nvl(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as "NET_PER",
                gross_amt AS "NO_OF_DAYS",case when nvl(gross_amt,0)>0 then round((supply_copy-return_copy)/gross_amt) else 0 end AS "AVG_NET_SALE"
                from cir_temp_bill_collection where cur_sessionid=userenv('sessionid') order by state_name,dist_name,agname,city_name,comm_amt;

                open p_accounts1 for
                select comp_code AS "COMP_CODE",  
                state_code AS "STATE_NAME",dist_code AS "DIST_NAME",sum(supply_copy) AS "SUPPLY_COPY", sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",
                case when nvl(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as "NET_PER", 
                0 AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from cir_temp_bill_collection where cur_sessionid=userenv('sessionid') 
                group by comp_code,state_code,dist_code order by state_name,dist_name;
            elsif pbreak_on='B' then
                open p_accounts for
                select comp_code AS "COMP_CODE", unit_code AS "UNIT",agname AS "AGNAME",agname_oth_lang AS "AGNAME_OTH_LANG",city_code as "CITY_NAME", 
                billno AS "BRANCH_NAME",comm_amt as "COPY_RATE",supply_copy AS "SUPPLY_COPY", return_copy AS "RETURN_COPY" ,(supply_copy-return_copy) AS "NET_SALE",
                case when nvl(supply_copy,0)>0 then round((return_copy/supply_copy)*100,2) else 0 end as "NET_PER",
                gross_amt AS "NO_OF_DAYS",case when nvl(gross_amt,0)>0 then round((supply_copy-return_copy)/gross_amt) else 0 end AS "AVG_NET_SALE"
                from cir_temp_bill_collection where cur_sessionid=userenv('sessionid') order by branch_name,agname,city_name,comm_amt;

                open p_accounts1 for
                select comp_code AS "COMP_CODE",  
                billno AS "BRANCH_NAME",sum(supply_copy) AS "SUPPLY_COPY", sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",
                case when nvl(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as "NET_PER",
                0 AS "NO_OF_DAYS", 0 AS "AVG_NET_SALE"
                from cir_temp_bill_collection where cur_sessionid=userenv('sessionid') 
                group by comp_code,billno order by branch_name;                
            end if;
        elsif preptype=2 then--for edition wise
                open p_accounts for
                select comp_code AS "COMP_CODE",  publ_code AS "PUBL_NAME",agcd AS "MAIN_EDTN_NAME",dpcd AS "EDTN_NAME",comm_amt as "COPY_RATE", sum(supply_copy) AS "SUPPLY_COPY", 
                sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",
                case when nvl(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as "NET_PER",
                max(gross_amt) AS "NO_OF_DAYS",case when nvl(max(gross_amt),0)>0 then round(sum(supply_copy-return_copy)/max(gross_amt)) else 0 end AS "AVG_NET_SALE"
                from cir_temp_bill_collection where cur_sessionid=userenv('sessionid') group by comp_code,publ_code,agcd,dpcd,comm_amt order by publ_name,main_edtn_name,edtn_name,copy_rate;

                open p_accounts1 for
                select comp_code AS "COMP_CODE",  publ_code AS "PUBL_NAME",agcd AS "MAIN_EDTN_NAME",sum(supply_copy) AS "SUPPLY_COPY", 
                sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",
                case when nvl(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as "NET_PER",
                max(gross_amt) AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from cir_temp_bill_collection where cur_sessionid=userenv('sessionid') group by comp_code,publ_code,agcd order by publ_name,main_edtn_name;
        else
                open p_accounts for
                select comp_code AS "COMP_CODE", 
                state_code AS "STATE_NAME",dist_code AS "DIST_NAME",taluka_code AS "TALUKA_NAME",
                comm_amt as "COPY_RATE",sum(supply_copy) AS "SUPPLY_COPY", sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",
                case when nvl(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as "NET_PER",
                max(gross_amt) AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from cir_temp_bill_collection where cur_sessionid=userenv('sessionid') 
                group by comp_code,state_code,dist_code,taluka_code,comm_amt order by state_name,dist_name,taluka_name,comm_amt;

                open p_accounts1 for
                select comp_code AS "COMP_CODE", 
                state_code AS "STATE_NAME",dist_code AS "DIST_NAME",
                sum(supply_copy) AS "SUPPLY_COPY", sum(return_copy) AS "RETURN_COPY" ,sum(supply_copy-return_copy) AS "NET_SALE",
                case when nvl(sum(supply_copy),0)>0 then round((sum(return_copy)/sum(supply_copy))*100,2) else 0 end as "NET_PER",
                max(gross_amt) AS "NO_OF_DAYS",0 AS "AVG_NET_SALE" 
                from cir_temp_bill_collection where cur_sessionid=userenv('sessionid') 
                group by comp_code,state_code,dist_code order by state_name,dist_name;
        end if;
        
        --open p_accounts1 for select sysdate as "CUR_DATE" from dual;
        open p_accounts2 for select sysdate as "CUR_DATE" from dual;
        open p_accounts3 for select sysdate as "CUR_DATE" from dual;
        delete from cir_temp_bill_collection where cur_sessionid=userenv('sessionid');
    
  End cir_monthly_net_paid_sale;

  procedure cir_rep_unsold_slip(
    pcompcode       in varchar2,
    punitcode       in varchar2,
    pbrancode       in varchar2,
    pdoctype        in varchar2,
    pdistcode       in varchar2,
    ptalukacode     in varchar2,
    pagcode         in varchar2,
    pagsubcode      in varchar2,
    pfrom_recdate   in varchar2,
    ptill_recdate   in varchar2,
    papproved_flag  in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,--Blank for Agency and 'D' for Distribution
    p_accounts      out t_accounts)
  As
       v_frdt    date;
       v_todt    date;
  Begin
       v_frdt:=to_date(pfrom_recdate,''''||pdateformat||'''');
       v_todt:=to_date(ptill_recdate,''''||pdateformat||'''');
       
        if upper(nvl(papproved_flag,'N'))='Y' then
            if pextra2='D' then
               open p_accounts for
               select b.comp_code comp_code,b.unit_code unit_code,b.doctype doctype,b.publ publ,cir_get_name.cir_publ(b.comp_code,b.publ,'1','dd/mm/yyyy','','') publ_name,
                      b.edtn edtn,cir_get_name.cir_edtn(b.comp_code,b.unit_code,b.edtn,'1','dd/mm/yyyy','','') edtn_name,
                      b.recptno recptno,b.recptdt recptdt,
                      b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,cir_get_city(b.comp_code,a.city_code) city_name,
                      b.copy_rate copy_rate,h.frdt frdt,h.todt todt,
                      sum(b.apr_short_recpt) short_recpt,sum(b.apr_late_recpt) late_recpt,sum(b.apr_bnr) bnr,sum(b.apr_unsold) unsold,
                      sum(nvl(b.copy_rate,0)*(nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0))) gross_amt,
                      sum(b.comm_amt) comm_amt,sum(b.waste_amt) waste_amt,nvl(sum(b.copy_amt),0) amount,
                      nvl(sum(b.copy_amt),0)-nvl(sum(b.waste_amt),0)net_amt 
                   from cir_agmast_dis a,cir_unsold_dtl_dis b,cir_unsold_hdr_dis h
                   where b.comp_code =a.comp_code and b.comp_code =pcompcode and b.comp_code =h.comp_code and 
                        b.unit_code=a.unit and b.unit_code=h.unit_code and b.unit_code=punitcode and 
                        b.doctype=pdoctype and b.doctype=h.doctype and b.recptdt between v_frdt and v_todt and
                        b.recptno=h.recptno and a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd=pagcode) or (pagcode is null)) and 
                        ((b.dpcd=pagsubcode) or (pagsubcode is null)) and ((a.dist_code=pdistcode) or (pdistcode is null)) and
                        ((a.tehsil_taluka=ptalukacode) or (ptalukacode is null)) and a.branch_code=nvl(pbrancode,a.branch_code) and
                        (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0
                        group by b.comp_code,b.unit_code,b.doctype,b.publ,b.edtn,b.recptno,b.recptdt,h.frdt,h.todt,
                                 b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.city_code,b.copy_rate 
                        order by b.agcd,b.dpcd,b.recptdt,b.recptno,b.publ,b.edtn;
            else
               open p_accounts for
               select b.comp_code comp_code,b.unit_code unit_code,b.doctype doctype,b.publ publ,cir_get_name.cir_publ(b.comp_code,b.publ,'1','dd/mm/yyyy','','') publ_name,
                      b.edtn edtn,cir_get_name.cir_edtn(b.comp_code,b.unit_code,b.edtn,'1','dd/mm/yyyy','','') edtn_name,
                      b.recptno recptno,b.recptdt recptdt,
                      b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,cir_get_city(b.comp_code,a.city_code) city_name,
                      b.copy_rate copy_rate,h.frdt frdt,h.todt todt,
                      sum(b.apr_short_recpt) short_recpt,sum(b.apr_late_recpt) late_recpt,sum(b.apr_bnr) bnr,sum(b.apr_unsold) unsold,
                      sum(nvl(b.copy_rate,0)*(nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0))) gross_amt,
                      sum(b.comm_amt) comm_amt,sum(b.waste_amt) waste_amt,nvl(sum(b.copy_amt),0) amount,
                      nvl(sum(b.copy_amt),0)-nvl(sum(b.waste_amt),0)net_amt 
                   from cir_agmast a,cir_unsold_dtl b,cir_unsold_hdr h
                   where b.comp_code =a.comp_code and b.comp_code =pcompcode and b.comp_code =h.comp_code and 
                        b.unit_code=a.unit and b.unit_code=h.unit_code and b.unit_code=punitcode and 
                        b.doctype=pdoctype and b.doctype=h.doctype and b.recptdt between v_frdt and v_todt and
                        b.recptno=h.recptno and a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd=pagcode) or (pagcode is null)) and 
                        ((b.dpcd=pagsubcode) or (pagsubcode is null)) and ((a.dist_code=pdistcode) or (pdistcode is null)) and
                        ((a.tehsil_taluka=ptalukacode) or (ptalukacode is null)) and a.branch_code=nvl(pbrancode,a.branch_code) and
                        (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0
                        group by b.comp_code,b.unit_code,b.doctype,b.publ,b.edtn,b.recptno,b.recptdt,h.frdt,h.todt,
                                 b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.city_code,b.copy_rate 
                        order by b.agcd,b.dpcd,b.recptdt,b.recptno,b.publ,b.edtn;            
            end if;            
        else
            if pextra2='D' then
               open p_accounts for
               select b.comp_code comp_code,b.unit_code unit_code,b.doctype doctype,b.publ publ,cir_get_name.cir_publ(b.comp_code,b.publ,'1','dd/mm/yyyy','','') publ_name,
                      b.edtn edtn,cir_get_name.cir_edtn(b.comp_code,b.unit_code,b.edtn,'1','dd/mm/yyyy','','') edtn_name,b.recptno recptno,b.recptdt recptdt,
                      b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,cir_get_city(b.comp_code,a.city_code) city_name,
                      b.copy_rate copy_rate,h.frdt frdt,h.todt todt,
                      sum(b.short_recpt) short_recpt,sum(b.late_recpt) late_recpt,sum(b.bnr) bnr,sum(b.unsold) unsold,
                      sum(nvl(b.copy_rate,0)*(nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0))) gross_amt,sum(b.comm_amt) comm_amt,
                      sum(b.waste_amt) waste_amt,nvl(sum(b.copy_amt),0) amount,
                      nvl(sum(b.copy_amt),0)-nvl(sum(b.waste_amt),0) net_amt 
                   from cir_agmast_dis a,cir_unsold_dtl_dis b,cir_unsold_hdr_dis h
                   where b.comp_code =a.comp_code and b.comp_code =pcompcode and b.comp_code =h.comp_code and 
                        b.unit_code=a.unit and b.unit_code=h.unit_code and b.unit_code=punitcode and 
                        b.doctype=pdoctype and b.doctype=h.doctype and b.recptdt between v_frdt and v_todt and
                        b.recptno=h.recptno and a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd=pagcode) or (pagcode is null)) and 
                        ((b.dpcd=pagsubcode) or (pagsubcode is null)) and ((a.dist_code=pdistcode) or (pdistcode is null)) and
                        ((a.tehsil_taluka=ptalukacode) or (ptalukacode is null)) and a.branch_code=nvl(pbrancode,a.branch_code) and
                        (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0
                        group by b.comp_code,b.unit_code,b.doctype,b.publ,b.edtn,b.recptno,b.recptdt,h.frdt,h.todt,
                                 b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.city_code,b.copy_rate 
                        order by b.agcd,b.dpcd,b.recptdt,b.recptno,b.publ,b.edtn;
            else
               open p_accounts for
               select b.comp_code comp_code,b.unit_code unit_code,b.doctype doctype,b.publ publ,cir_get_name.cir_publ(b.comp_code,b.publ,'1','dd/mm/yyyy','','') publ_name,
                      b.edtn edtn,cir_get_name.cir_edtn(b.comp_code,b.unit_code,b.edtn,'1','dd/mm/yyyy','','') edtn_name,b.recptno recptno,b.recptdt recptdt,
                      b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,cir_get_city(b.comp_code,a.city_code) city_name,
                      b.copy_rate copy_rate,h.frdt frdt,h.todt todt,
                      sum(b.short_recpt) short_recpt,sum(b.late_recpt) late_recpt,sum(b.bnr) bnr,sum(b.unsold) unsold,
                      sum(nvl(b.copy_rate,0)*(nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0))) gross_amt,sum(b.comm_amt) comm_amt,
                      sum(b.waste_amt) waste_amt,nvl(sum(b.copy_amt),0) amount,
                      nvl(sum(b.copy_amt),0)-nvl(sum(b.waste_amt),0) net_amt 
                   from cir_agmast a,cir_unsold_dtl b,cir_unsold_hdr h
                   where b.comp_code =a.comp_code and b.comp_code =pcompcode and b.comp_code =h.comp_code and 
                        b.unit_code=a.unit and b.unit_code=h.unit_code and b.unit_code=punitcode and 
                        b.doctype=pdoctype and b.doctype=h.doctype and b.recptdt between v_frdt and v_todt and
                        b.recptno=h.recptno and a.agcd=b.agcd and a.dpcd=b.dpcd and ((b.agcd=pagcode) or (pagcode is null)) and 
                        ((b.dpcd=pagsubcode) or (pagsubcode is null)) and ((a.dist_code=pdistcode) or (pdistcode is null)) and
                        ((a.tehsil_taluka=ptalukacode) or (ptalukacode is null)) and a.branch_code=nvl(pbrancode,a.branch_code) and
                        (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0
                        group by b.comp_code,b.unit_code,b.doctype,b.publ,b.edtn,b.recptno,b.recptdt,h.frdt,h.todt,
                                 b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.city_code,b.copy_rate 
                        order by b.agcd,b.dpcd,b.recptdt,b.recptno,b.publ,b.edtn;            
            end if;             
       end if;
  End cir_rep_unsold_slip;

/*
var v1 refcursor;
var v2 refcursor;
var v3 refcursor;
var v4 refcursor;
var v5 refcursor;
var v6 refcursor;
exec cir_rep_unsold_supply.cir_unsold_return_punya('SP002','AUR','','UCN','','','','','','','','01-jun-2010','30-sep-2010','N','1','dd/mm/yyyy','','',:v1,:v2,:v3,:v4,:v5,:v6);
*/

    procedure cir_unsold_return_punya(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pbran_code         in varchar2,
     pdoc_type          in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pdistcode          in varchar2,
     ptalukacode        in varchar2,
     pcitycode          in varchar2,
     pagcode            in varchar2,
     pdepocode          in varchar2,
     pfrom_recdate      in varchar2,
     ptill_recdate      in varchar2,
     papproved_flag     in varchar2,
     plangtype          in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts,
     p_accounts3        out t_accounts,
     p_accounts5        out t_accounts,
     p_accounts6        out t_accounts)
   As
    v_frdt     date;
    v_todt    date;
    v_query1  varchar2(32000); 
       cursor cur_edtn is
           select distinct u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.main_edtn edtn,u.copy_rate copy_rate,
            cir_get_edtn_seqno(u.comp_code,u.main_edtn) edtn_seqno from
         (select distinct b.comp_code comp_code,b.unit_code unit_code,c.publ publ,c.main_edtn main_edtn,b.copy_rate copy_rate 
         from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast c
         where b.comp_code = a.comp_code and b.comp_code = c.comp_code and b.comp_code = pcomp_code and 
         b.unit_code = a.unit and b.unit_code = punit_code and 
         b.doctype=pdoc_type and b.recptdt <=v_todt and 
         b.publ=nvl(ppubl,b.publ) and c.main_edtn=nvl(pmainedtn,c.main_edtn) and
         b.publ=c.publ and b.edtn=c.edtn and     
         a.agcd=b.agcd and a.dpcd=b.dpcd and b.agcd=nvl(pagcode,b.agcd) and 
         b.dpcd=nvl(pdepocode,b.dpcd) and (a.tehsil_taluka=ptalukacode or ptalukacode is null) and
         (a.dist_code=pdistcode or pdistcode is null) and a.city_code=nvl(pcitycode,a.city_code) and
         b.branch_code=nvl(pbran_code,b.branch_code)
         union
         select distinct b.comp_code comp_code,b.unit_code unit_code,b.publ_code publ,c.main_edtn main_edtn,b.edtn_rate copy_rate 
         from cir_agmast a,cir_branch_return_det b,cir_edtn_mast c 
         where a.comp_code=b.comp_code and a.comp_code=c.comp_code and b.comp_code = pcomp_code and 
         a.unit=b.unit_code and a.unit=c.unit_code and b.unit_code = punit_code and 
         b.recptdt >= v_frdt and b.recptdt<=v_todt and b.publ_code=nvl(ppubl,b.publ_code) and 
         c.main_edtn=nvl(pmainedtn,c.main_edtn) and b.publ_code=c.publ and b.edtn_code=c.edtn and     
         (a.tehsil_taluka=ptalukacode or ptalukacode is null) and
         (a.dist_code=pdistcode or pdistcode is null) and a.city_code=nvl(pcitycode,a.city_code) and
         b.branch_code=nvl(pbran_code,b.branch_code)
         union
         select distinct b.comp_code comp_code,b.unit_code unit_code,c.publ publ,c.main_edtn main_edtn,b.copy_rate copy_rate 
         from cir_agmast_dis a,cir_unsold_dtl_dis b,cir_edtn_mast c
         where b.comp_code = a.comp_code and b.comp_code = c.comp_code and b.comp_code = pcomp_code and 
         b.unit_code = a.unit and b.unit_code = punit_code and 
         b.doctype=pdoc_type and b.recptdt <=v_todt and 
         b.publ=nvl(ppubl,b.publ) and c.main_edtn=nvl(pmainedtn,c.main_edtn) and
         b.publ=c.publ and b.edtn=c.edtn and     
         a.agcd=b.agcd and a.dpcd=b.dpcd and b.agcd=nvl(pagcode,b.agcd) and 
         b.dpcd=nvl(pdepocode,b.dpcd) and (a.tehsil_taluka=ptalukacode or ptalukacode is null) and
         (a.dist_code=pdistcode or pdistcode is null) and a.city_code=nvl(pcitycode,a.city_code) and
         b.branch_code=nvl(pbran_code,b.branch_code)
         union
         select distinct b.comp_code comp_code,b.unit_code unit_code,b.publ_code publ,c.main_edtn main_edtn,b.edtn_rate copy_rate 
         from cir_agmast a,cir_return_sale_det b,cir_edtn_mast c 
         where a.comp_code=b.comp_code and a.comp_code=c.comp_code and b.comp_code = pcomp_code and 
         a.unit=b.unit_code and a.unit=c.unit_code and b.unit_code = punit_code and 
         b.doctype='RET' and b.recptdt >= v_frdt and b.recptdt<=v_todt and b.publ_code=nvl(ppubl,b.publ_code) and 
         c.main_edtn=nvl(pmainedtn,c.main_edtn) and b.publ_code=c.publ and b.edtn_code=c.edtn and     
         (a.tehsil_taluka=ptalukacode or ptalukacode is null) and
         (a.dist_code=pdistcode or pdistcode is null) and a.city_code=nvl(pcitycode,a.city_code) and
         b.branch_code=nvl(pbran_code,b.branch_code)
         union
         select distinct b.comp_code comp_code,b.unit_code unit_code,b.publ_code publ,c.main_edtn main_edtn,b.edtn_rate copy_rate 
         from cir_physical_ver_det b,cir_edtn_mast c
            where b.comp_code = pcomp_code and 
            b.unit_code=c.unit_code and b.unit_code = punit_code and 
         b.recptdt<=v_todt and b.publ_code=nvl(ppubl,b.publ_code) and 
         c.main_edtn=nvl(pmainedtn,c.main_edtn) and b.publ_code=c.publ and b.edtn_code=c.edtn and     
         b.branch_code=nvl(pbran_code,b.branch_code)
         union
         select distinct b.comp_code comp_code,b.unit_code unit_code,b.publ publ,c.main_edtn main_edtn,b.sup_rate copy_rate 
         from cir_agmast a,cir_dbksup_resale b,cir_edtn_mast c
            where b.comp_code = a.comp_code and b.comp_code = c.comp_code and b.comp_code = pcomp_code and 
                  b.unit_code = a.unit and b.unit_code = punit_code and 
                  b.publ=nvl(ppubl,b.publ) and 
                  c.main_edtn=nvl(pmainedtn,c.main_edtn) and
                  b.publ=c.publ and b.edtn=c.edtn and
                  b.supdate >= v_frdt and b.supdate<=v_todt and 
                  a.agcd=b.agcd and a.dpcd=b.dpcd and b.agcd=nvl(pagcode,b.agcd) and 
                  b.dpcd=nvl(pdepocode,b.dpcd) and (a.tehsil_taluka=ptalukacode or ptalukacode is null) and
                  (a.dist_code=pdistcode or pdistcode is null) and a.city_code=nvl(pcitycode,a.city_code) and
                  b.resale_branch=nvl(pbran_code,b.resale_branch) and
                  nvl(b.sup_copy,0)>0 and nvl(b.return_copy_sale,'N')='Y') u                  
         order by publ,edtn_seqno,edtn,copy_rate;
     rec_edtn cur_edtn%rowtype;
     vvar       varchar2(8000);
     tot_vvar   varchar2(8000);
     vtot_publ  varchar2(4000);
     v_cnt      number:=0;
     v_opbal_unsold    number(10):=0;v_op_branch_rec   number(10):=0;v_op_branch_trf   number(10):=0;v_op_sale number(10):=0;
      v_op_resale number(10):=0;v_op_comp_ret number(10):=0;v_op_short_excess number(10):=0;
      
      v_opbal           number(10):=0;

  Begin
       --insert into aaa_test values (pcomp_code||'-'||punit_code ||'-'||pbran_code||'-'||pdoc_type||'-'||ppubl||'-'||pmainedtn||'-'||pdistcode||'-'||ptalukacode||'-'||pcitycode||'-'||pagcode||'-'||pdepocode||'-'||pfrom_recdate||'-'||ptill_recdate||'-'||papproved_flag||'-'||plangtype||'-'||pdateformat||'-'||pextra1||'-'||pextra2||'*'||'pcomp_code'||'-'||'punit_code'||'-'||'pbran_code'||'-'||'pdoc_type'||'-'||'ppubl'||'-'||'pmainedtn'||'-'||'pdistcode'||'-'||'ptalukacode'||'-'||'pcitycode'||'-'||'pagcode'||'-'||'pdepocode'||'-'||'pfrom_recdate'||'-'||'ptill_recdate'||'-'||'papproved_flag'||'-'||'plangtype'||'-'||'pdateformat'||'-'||'pextra1'||'-'||'pextra2');commit;
       --delete from test1;
       delete from cir_temp_unsold_stock where sess_id=userenv('sessionid');
       
       v_frdt:=to_date(pfrom_recdate,''''||pdateformat||'''');
       v_todt:=to_date(ptill_recdate,''''||pdateformat||'''');
    open cur_edtn;
    loop
        fetch cur_edtn into rec_edtn;
      exit when cur_edtn%notfound;
          v_cnt :=nvl(v_cnt,0)+1;
          if vvar is null then
              vvar    :='decode(u.edtn||u.copy_rate,'||''''||rec_edtn.edtn||rec_edtn.copy_rate||''''||',sum(u.return_copy))"'||rec_edtn.edtn||'_'||rec_edtn.copy_rate||'"';
              tot_vvar:=',sum("'||rec_edtn.edtn||'_'||rec_edtn.copy_rate||'") "'||rec_edtn.edtn||'_'||rec_edtn.copy_rate||'"';
          else
              vvar    :=vvar||',decode(u.edtn||u.copy_rate,'||''''||rec_edtn.edtn||rec_edtn.copy_rate||''''||',sum(u.return_copy))"'||rec_edtn.edtn||'_'||rec_edtn.copy_rate||'"';
              tot_vvar:=tot_vvar||',sum("'||rec_edtn.edtn||'_'||rec_edtn.copy_rate||'") "'||rec_edtn.edtn||'_'||rec_edtn.copy_rate||'"';
          end if;    
    
            select nvl(sum(nvl(a.apr_short_recpt,0)+nvl(a.apr_late_recpt,0)+nvl(a.apr_bnr,0)+nvl(a.apr_unsold,0)),0) into v_opbal_unsold 
            from cir_unsold_dtl a,cir_edtn_mast b 
            where a.comp_code=b.comp_code and a.comp_code=pcomp_code and a.unit_code=b.unit_code and a.unit_code=punit_code and 
            a.doctype='UCN' and a.recptdt<v_frdt and a.publ=b.publ and a.publ=rec_edtn.publ and a.edtn=b.edtn and b.main_edtn=rec_edtn.edtn and
            a.copy_rate=rec_edtn.copy_rate and a.branch_code=NVL(pbran_code,a.branch_code);

            select nvl(sum(a.edtn_copy),0) into v_op_branch_rec from cir_branch_return_det a,cir_edtn_mast b 
                where a.comp_code=b.comp_code and a.comp_code=pcomp_code and a.unit_code=b.unit_code and a.unit_code=punit_code and 
                a.doctype='TI' and a.recptdt<v_frdt and
                a.publ_code=b.publ and a.publ_code=rec_edtn.publ and a.edtn_code=b.edtn and b.main_edtn=rec_edtn.edtn and 
                a.edtn_rate=rec_edtn.copy_rate and (a.branch_code=pbran_code or pbran_code is null);

            select nvl(sum(a.edtn_copy),0) into v_op_branch_trf from cir_branch_return_det a,cir_edtn_mast b 
                where a.comp_code=b.comp_code and a.comp_code=pcomp_code and a.unit_code=b.unit_code and a.unit_code=punit_code and a.doctype='TRF' and a.recptdt<v_frdt and
                a.publ_code=b.publ and a.publ_code=rec_edtn.publ and a.edtn_code=b.edtn and b.main_edtn=rec_edtn.edtn and a.edtn_rate=rec_edtn.copy_rate and (a.branch_code=pbran_code or pbran_code is null);
            
            select nvl(sum(nvl(a.no_of_copy,0)),0) into v_op_sale from cir_return_sale_det a,cir_edtn_mast b
                where a.comp_code=b.comp_code and a.comp_code=pcomp_code and a.unit_code=b.unit_code and a.unit_code=punit_code and 
                a.doctype='RET' and a.recptdt<v_frdt and
                a.publ_code=b.publ and a.publ_code=rec_edtn.publ and a.edtn_code=b.edtn and b.main_edtn=rec_edtn.edtn and a.edtn_rate=rec_edtn.copy_rate and (branch_code=pbran_code or pbran_code is null);

            select nvl(sum(nvl(a.apr_short_recpt,0)+nvl(a.apr_late_recpt,0)+nvl(a.apr_bnr,0)+nvl(a.apr_unsold,0)),0) into v_op_comp_ret
            from cir_unsold_dtl_dis a,cir_edtn_mast b 
            where a.comp_code=b.comp_code and a.comp_code=pcomp_code and a.unit_code=b.unit_code and a.unit_code=punit_code and 
            a.doctype='UCN' and a.recptdt<v_frdt and a.publ=b.publ and a.publ=rec_edtn.publ and a.edtn=b.edtn and b.main_edtn=rec_edtn.edtn and
            a.copy_rate=rec_edtn.copy_rate and a.branch_code=NVL(pbran_code,a.branch_code);

            select nvl(sum(a.sup_copy),0) into v_op_resale from cir_dbksup_resale a,cir_edtn_mast b,cir_agmast c
                where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=pcomp_code and a.unit_code=b.unit_code and a.unit_code=c.unit and a.unit_code=punit_code and 
                a.agcd=c.agcd and a.dpcd=c.dpcd and a.publ=b.publ and a.publ=rec_edtn.publ and a.edtn=b.edtn and b.main_edtn=rec_edtn.edtn and
                      supdate<v_todt and sup_rate=rec_edtn.copy_rate and nvl(return_copy_sale,'N')='Y' and (a.resale_branch=pbran_code or pbran_code is null); 
            
            select nvl(sum(nvl(a.short_excess,1)*nvl(a.no_of_copy,0)),0) into v_op_short_excess from cir_physical_ver_det a,cir_edtn_mast b
                where a.comp_code=b.comp_code and a.comp_code=pcomp_code and a.unit_code=b.unit_code and a.unit_code=punit_code and a.doctype='VR' and a.recptdt<v_frdt and
                a.publ_code=b.publ and a.publ_code=rec_edtn.publ and a.edtn_code=b.edtn and b.main_edtn=rec_edtn.edtn and a.edtn_rate=rec_edtn.copy_rate and (a.branch_code=pbran_code or pbran_code is null);
            /*-------for opening balance ----------*/

            
            v_opbal:=nvl(v_opbal_unsold,0)+nvl(v_op_branch_rec,0)-nvl(v_op_comp_ret,0)-nvl(v_op_branch_trf,0)-nvl(v_op_sale,0)-nvl(v_op_resale,0)+nvl(v_op_short_excess,0);

            insert into cir_temp_unsold_stock(comp_code,unit_code,branch_code,publ_code,edtn_code,ason_dt,copy_rate,
                    opbal,sess_id)
                    values(pcomp_code,punit_code,pbran_code,rec_edtn.publ,rec_edtn.edtn,v_todt,rec_edtn.copy_rate,v_opbal,userenv('sessionid'));
    end loop;
    close cur_edtn;
    commit;
   -- insert into test1(vstring,vstring2) values(' vvar '||vvar,'tot_vvar '||tot_vvar); --commit;
    if vvar is not null then
       If nvl(papproved_flag,'N')='Y' Then
           v_query1:='select c.comp_code comp_code,c.unit_code unit_code,c.agcd agcd,c.dpcd dpcd,c.agname agname,c.agname_oth_lang agname_oth_lang,
           nvl(cir_get_name.cir_city(c.comp_code,c.city_code,'||''||plangtype||''||','''','''',''''),''NA'') city_name,
           nvl(cir_get_name.cir_taluka(c.comp_code,c.taluka_code,'||''||plangtype||''||','''','''',''''),''NA'') taluka_name '||tot_vvar||'
           from
           (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,
           u.copy_rate copy_rate,u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,u.city_code city_code,u.taluka_code taluka_code,'||vvar
           ||' from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,e.main_edtn edtn,b.copy_rate copy_rate,
               b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
               a.city_code city_code,a.tehsil_taluka taluka_code,
               nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0) return_copy
               from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
               where b.comp_code =a.comp_code and b.comp_code =e.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                   b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code='||''''||punit_code||''''||' and 
                   b.doctype='||''''||pdoc_type||''''||' and b.recptdt >= '||''''||v_frdt||''''||' and b.recptdt<='||''''||v_todt||''''||' and 
                   a.agcd=b.agcd and a.dpcd=b.dpcd and b.agcd=nvl('||''''||pagcode||''''||',b.agcd) and 
                   b.dpcd=nvl('||''''||pdepocode||''''||',b.dpcd) and b.publ=nvl('||''''||ppubl||''''||',b.publ) and
                   b.publ=e.publ and b.edtn=e.edtn and e.main_edtn=nvl('||''''||pmainedtn||''''||',e.main_edtn) and
                   (a.tehsil_taluka='||''''||ptalukacode||''''||' or '||''''||ptalukacode||''''||' is null) and
                   b.branch_code=nvl('||''''||pbran_code||''''||',b.branch_code) and
                   (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0) u
                   where u.return_copy>0
                   group by u.comp_code,u.unit_code,u.publ,u.edtn,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,
                   u.city_code,u.taluka_code,u.copy_rate) c
                   group by c.comp_code,c.unit_code,c.agcd,c.dpcd,c.agname,c.agname_oth_lang,c.city_code,c.taluka_code
                   order by c.comp_code,c.unit_code,taluka_name,c.agname';
                                              
           --insert into test1(vstring,vstring2) values('unsold edtn YY ',v_query1);COMMIT;
           open p_accounts for v_query1;           
               
           v_query1:='select c.comp_code comp_code,c.unit_code unit_code,
           nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA'') taluka_name '||tot_vvar||'
           from
           (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,u.copy_rate copy_rate,
           u.taluka_code taluka_code,'||vvar
           ||'  from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,e.main_edtn edtn,b.copy_rate copy_rate,
                b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                a.city_code city_code,a.tehsil_taluka taluka_code,
                nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0) return_copy
               from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
               where b.comp_code =a.comp_code and b.comp_code =e.comp_code and b.comp_code ='||''''||pcomp_code||''''||' and 
               b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code='||''''||punit_code||''''||' and 
               b.doctype='||''''||pdoc_type||''''||' and b.recptdt >= '||''''||v_frdt||''''||' and b.recptdt<='||''''||v_todt||''''||' and 
               a.agcd=b.agcd and a.dpcd=b.dpcd and b.agcd=nvl('||''''||pagcode||''''||',b.agcd) and 
               b.dpcd=nvl('||''''||pdepocode||''''||',b.dpcd) and b.publ=nvl('||''''||ppubl||''''||',b.publ) and
               b.publ=e.publ and b.edtn=e.edtn and e.main_edtn=nvl('||''''||pmainedtn||''''||',e.main_edtn) and
               (a.tehsil_taluka='||''''||ptalukacode||''''||' or '||''''||ptalukacode||''''||' is null) and
               b.branch_code=nvl('||''''||pbran_code||''''||',b.branch_code) and
               (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0) u
               where u.return_copy>0
               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.copy_rate,u.taluka_code) c
               group by c.comp_code,c.unit_code,c.taluka_code
               order by c.comp_code,c.unit_code,taluka_name';
                
            --insert into test1(vstring,vstring2) values('unsold edtn v_query2 ',v_query1);COMMIT;
            open p_accounts1 for v_query1;
               
           v_query1:='select c.comp_code comp_code,c.unit_code unit_code '||tot_vvar||'
           from
           (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,u.copy_rate copy_rate,'||vvar
           ||' from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,e.main_edtn edtn,b.copy_rate copy_rate,
                b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                a.city_code city_code,a.tehsil_taluka taluka_code,
                nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0) return_copy
               from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
               where b.comp_code =a.comp_code and b.comp_code =e.comp_code and b.comp_code ='||''''||pcomp_code||''''||' and 
               b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code='||''''||punit_code||''''||' and 
               b.doctype='||''''||pdoc_type||''''||' and b.recptdt >= '||''''||v_frdt||''''||' and b.recptdt<='||''''||v_todt||''''||' and 
               a.agcd=b.agcd and a.dpcd=b.dpcd and b.agcd=nvl('||''''||pagcode||''''||',b.agcd) and 
               b.dpcd=nvl('||''''||pdepocode||''''||',b.dpcd) and b.publ=nvl('||''''||ppubl||''''||',b.publ) and
               b.publ=e.publ and b.edtn=e.edtn and e.main_edtn=nvl('||''''||pmainedtn||''''||',e.main_edtn) and
               (a.tehsil_taluka='||''''||ptalukacode||''''||' or '||''''||ptalukacode||''''||' is null) and
               b.branch_code=nvl('||''''||pbran_code||''''||',b.branch_code) and
               (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0) u
               where u.return_copy>0
               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.copy_rate)c
               group by c.comp_code,c.unit_code
               order by c.comp_code,c.unit_code';
           --insert into test1(vstring,vstring2) values('unsold edtn v_query3 ',v_query1);COMMIT;
           open p_accounts2 for v_query1;
       Else
           v_query1:='select c.comp_code comp_code,c.unit_code unit_code,c.agcd agcd,c.dpcd dpcd,c.agname agname,c.agname_oth_lang agname_oth_lang,
           nvl(cir_get_name.cir_city(c.comp_code,c.city_code,'||''||plangtype||''||','''','''',''''),''NA'') city_name,
           nvl(cir_get_name.cir_taluka(c.comp_code,c.taluka_code,'||''||plangtype||''||','''','''',''''),''NA'') taluka_name '||tot_vvar||'
           from
           (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,
           u.copy_rate copy_rate,u.agcd agcd,u.dpcd dpcd,u.agname agname,u.agname_oth_lang agname_oth_lang,u.city_code city_code,u.taluka_code taluka_code,'||vvar
           ||' from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,e.main_edtn edtn,b.copy_rate copy_rate,
               b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
               a.city_code city_code,a.tehsil_taluka taluka_code,
               nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0) return_copy
               from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
               where b.comp_code =a.comp_code and b.comp_code =e.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                   b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code='||''''||punit_code||''''||' and 
                   b.doctype='||''''||pdoc_type||''''||' and b.recptdt >= '||''''||v_frdt||''''||' and b.recptdt<='||''''||v_todt||''''||' and 
                   a.agcd=b.agcd and a.dpcd=b.dpcd and b.agcd=nvl('||''''||pagcode||''''||',b.agcd) and 
                   b.dpcd=nvl('||''''||pdepocode||''''||',b.dpcd) and b.publ=nvl('||''''||ppubl||''''||',b.publ) and
                   b.publ=e.publ and b.edtn=e.edtn and e.main_edtn=nvl('||''''||pmainedtn||''''||',e.main_edtn) and
                   (a.tehsil_taluka='||''''||ptalukacode||''''||' or '||''''||ptalukacode||''''||' is null) and
                   b.branch_code=nvl('||''''||pbran_code||''''||',b.branch_code) and
                   (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0) u
                   where u.return_copy>0
                   group by u.comp_code,u.unit_code,u.publ,u.edtn,u.agcd,u.dpcd,u.agname,u.agname_oth_lang,
                   u.city_code,u.taluka_code,u.copy_rate) c
                   group by c.comp_code,c.unit_code,c.agcd,c.dpcd,c.agname,c.agname_oth_lang,c.city_code,c.taluka_code
                   order by c.comp_code,c.unit_code,taluka_name,c.agname';
                --insert into test1(vstring,vstring2) values('unsold edtn v_query1 ',v_query1);COMMIT;
           open p_accounts for v_query1;
    
           v_query1:='select c.comp_code comp_code,c.unit_code unit_code,
           nvl(cir_get_taluka(c.comp_code,c.taluka_code),''NA'') taluka_name '||tot_vvar||'
           from
           (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,cir_get_edtn_name(u.comp_code,u.edtn) edtn_name,u.copy_rate copy_rate,
           u.taluka_code taluka_code,'||vvar
           ||'  from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,e.main_edtn edtn,b.copy_rate copy_rate,
                b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                a.city_code city_code,a.tehsil_taluka taluka_code,
                nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0) return_copy
               from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
               where b.comp_code =a.comp_code and b.comp_code =e.comp_code and b.comp_code ='||''''||pcomp_code||''''||' and 
               b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code='||''''||punit_code||''''||' and 
               b.doctype='||''''||pdoc_type||''''||' and b.recptdt >= '||''''||v_frdt||''''||' and b.recptdt<='||''''||v_todt||''''||' and 
               a.agcd=b.agcd and a.dpcd=b.dpcd and b.agcd=nvl('||''''||pagcode||''''||',b.agcd) and 
               b.dpcd=nvl('||''''||pdepocode||''''||',b.dpcd) and b.publ=nvl('||''''||ppubl||''''||',b.publ) and
               b.publ=e.publ and b.edtn=e.edtn and e.main_edtn=nvl('||''''||pmainedtn||''''||',e.main_edtn) and
               (a.tehsil_taluka='||''''||ptalukacode||''''||' or '||''''||ptalukacode||''''||' is null) and
               b.branch_code=nvl('||''''||pbran_code||''''||',b.branch_code) and
               (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0) u
               where u.return_copy>0
               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.copy_rate,u.taluka_code) c
               group by c.comp_code,c.unit_code,c.taluka_code
               order by c.comp_code,c.unit_code,taluka_name';
           --insert into test1(vstring,vstring2) values('unsold edtn v_query2 ',v_query1);COMMIT;
           open p_accounts1 for v_query1;
    
           v_query1:='select c.comp_code comp_code,c.unit_code unit_code '||tot_vvar||'
           from
           (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,u.copy_rate copy_rate,'||vvar
           ||' from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,e.main_edtn edtn,b.copy_rate copy_rate,
                b.agcd agcd,b.dpcd dpcd,a.ag_name agname,a.ag_name_oth_lang agname_oth_lang,
                a.city_code city_code,a.tehsil_taluka taluka_code,
                nvl(b.short_recpt,0)+nvl(b.late_recpt,0)+nvl(b.bnr,0)+nvl(b.unsold,0) return_copy
               from cir_agmast a,cir_unsold_dtl b,cir_edtn_mast e
               where b.comp_code =a.comp_code and b.comp_code =e.comp_code and b.comp_code ='||''''||pcomp_code||''''||' and 
               b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code='||''''||punit_code||''''||' and 
               b.doctype='||''''||pdoc_type||''''||' and b.recptdt >= '||''''||v_frdt||''''||' and b.recptdt<='||''''||v_todt||''''||' and 
               a.agcd=b.agcd and a.dpcd=b.dpcd and b.agcd=nvl('||''''||pagcode||''''||',b.agcd) and 
               b.dpcd=nvl('||''''||pdepocode||''''||',b.dpcd) and b.publ=nvl('||''''||ppubl||''''||',b.publ) and
               b.publ=e.publ and b.edtn=e.edtn and e.main_edtn=nvl('||''''||pmainedtn||''''||',e.main_edtn) and
               (a.tehsil_taluka='||''''||ptalukacode||''''||' or '||''''||ptalukacode||''''||' is null) and
               b.branch_code=nvl('||''''||pbran_code||''''||',b.branch_code) and
               (nvl(short_recpt,0)+nvl(late_recpt,0)+nvl(bnr,0)+nvl(unsold,0))>0) u
               where u.return_copy>0
               group by u.comp_code,u.unit_code,u.publ,u.edtn,u.copy_rate)c
               group by c.comp_code,c.unit_code
               order by c.comp_code,c.unit_code';
            --insert into test1(vstring,vstring2) values('unsold edtn v_query3 ',v_query1);COMMIT;
           open p_accounts2 for v_query1;
       End if;

            /*Branch Received */
           v_query1:='select c.comp_code comp_code,c.unit_code unit_code,c.branch_code branch_code,d."Branch_Name" branch_name'||tot_vvar||'
           from
           (select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,u.copy_rate copy_rate,u.branch_code branch_code,'||vvar
           ||' from (select b.comp_code comp_code,b.unit_code unit_code,b.publ_code publ,e.main_edtn edtn,b.edtn_rate copy_rate,
               b.oth_branch_code branch_code,nvl(b.edtn_copy,0) return_copy
               from cir_branch_return_det b,cir_edtn_mast e
               where b.comp_code =e.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                   b.unit_code=e.unit_code and b.unit_code='||''''||punit_code||''''||' and 
                   b.doctype=''TI'' and b.recptdt >= '||''''||v_frdt||''''||' and b.recptdt<='||''''||v_todt||''''||' and 
                   b.publ_code=nvl('||''''||ppubl||''''||',b.publ_code) and
                   b.publ_code=e.publ and b.edtn_code=e.edtn and e.main_edtn=nvl('||''''||pmainedtn||''''||',e.main_edtn) and
                   b.branch_code=nvl('||''''||pbran_code||''''||',b.branch_code)) u
                   where u.return_copy>0
                   group by u.comp_code,u.unit_code,u.publ,u.edtn,u.branch_code,u.copy_rate) c,branch_mst d
                   where c.branch_code=d."Branch_Code"
                   group by c.comp_code,c.unit_code,c.branch_code,d."Branch_Name"
                   order by c.comp_code,c.unit_code,c.branch_code, branch_name';
            
            --insert into test1(vstring,vstring2) values('unsold edtn branch received v_query4 ',v_query1);COMMIT;
            
            open p_accounts3 for v_query1;

            v_query1:='select c.comp_code comp_code,c.unit_code unit_code,c.rec_type rec_type,c.branch_name branch_name '||tot_vvar||'
           from
           (select u.comp_code comp_code,u.unit_code unit_code,u.branch_name branch_name,u.publ publ,u.edtn edtn,u.copy_rate copy_rate,u.rec_type,'||vvar
           ||' from (select b.comp_code comp_code,b.unit_code unit_code,b.branch_code branch_code,f."Branch_Name" branch_name, b.publ_code publ,e.main_edtn edtn,b.edtn_rate copy_rate,
               1 rec_type,nvl(b.edtn_copy,0) return_copy
               from cir_branch_return_det b,cir_edtn_mast e,branch_mst f
               where b.comp_code =e.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                   b.unit_code=e.unit_code and b.unit_code='||''''||punit_code||''''||' and 
                   b.doctype=''TRF'' and b.recptdt >= '||''''||v_frdt||''''||' and b.recptdt<='||''''||v_todt||''''||' and 
                   b.publ_code=nvl('||''''||ppubl||''''||',b.publ_code) and
                   b.publ_code=e.publ and b.edtn_code=e.edtn and e.main_edtn=nvl('||''''||pmainedtn||''''||',e.main_edtn) and
                   b.branch_code=f."Branch_Code" and b.branch_code=nvl('||''''||pbran_code||''''||',b.branch_code)
                   union all
                   select b.comp_code comp_code,b.unit_code unit_code,NULL branch_code,''Company Return'' branch_name,b.publ publ,e.main_edtn edtn,b.copy_rate copy_rate,
                    2 rec_type,nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0) return_copy
                    from cir_unsold_dtl_dis b,cir_edtn_mast e
                    where b.comp_code =e.comp_code and b.comp_code ='||''''||pcomp_code||''''||' and 
                    b.unit_code=e.unit_code and b.unit_code='||''''||punit_code||''''||' and 
                    b.doctype='||''''||pdoc_type||''''||' and b.recptdt >= '||''''||v_frdt||''''||' and b.recptdt<='||''''||v_todt||''''||' and 
                    b.publ=nvl('||''''||ppubl||''''||',b.publ) and
                    b.publ=e.publ and b.edtn=e.edtn and e.main_edtn=nvl('||''''||pmainedtn||''''||',e.main_edtn) and
                    b.branch_code=nvl('||''''||pbran_code||''''||',b.branch_code)
                   union all
                   select b.comp_code comp_code,b.unit_code unit_code,NULL branch_code,''Raddi Sale'' branch_name,b.publ_code publ,e.main_edtn edtn,b.edtn_rate copy_rate,
                   3 rec_type,nvl(b.no_of_copy,0) return_copy
                   from cir_return_sale_det b,cir_edtn_mast e
                   where b.comp_code =e.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                   b.unit_code=e.unit_code and b.unit_code='||''''||punit_code||''''||' and 
                   b.doctype=''RET'' and b.recptdt >= '||''''||v_frdt||''''||' and b.recptdt<='||''''||v_todt||''''||' and 
                   b.publ_code=nvl('||''''||ppubl||''''||',b.publ_code) and
                   b.publ_code=e.publ and b.edtn_code=e.edtn and e.main_edtn=nvl('||''''||pmainedtn||''''||',e.main_edtn) and
                   b.branch_code=nvl('||''''||pbran_code||''''||',b.branch_code)
                   union all
                   select b.comp_code comp_code,b.unit_code unit_code,NULL branch_code,''Resale Supply'' branch_name,b.publ publ,e.main_edtn edtn,b.sup_rate copy_rate,
                    4 rec_type,nvl(b.sup_copy,0) return_copy
                    from cir_agmast a,cir_dbksup_resale b,cir_edtn_mast e
                    where b.comp_code =a.comp_code and b.comp_code =e.comp_code and b.comp_code ='||''''||pcomp_code||''''||' and 
                    b.unit_code=a.unit and b.unit_code=e.unit_code and b.unit_code='||''''||punit_code||''''||' and 
                    b.supdate >= '||''''||v_frdt||''''||' and b.supdate<='||''''||v_todt||''''||' and a.agcd=b.agcd and a.dpcd=b.dpcd and
                    b.publ=nvl('||''''||ppubl||''''||',b.publ) and
                    b.publ=e.publ and b.edtn=e.edtn and e.main_edtn=nvl('||''''||pmainedtn||''''||',e.main_edtn) and
                    b.resale_branch=nvl('||''''||pbran_code||''''||',b.resale_branch)
                   union all
                   select b.comp_code comp_code,b.unit_code unit_code,NULL branch_code,''Short\Excess'' branch_name,b.publ_code publ,e.main_edtn edtn,b.edtn_rate copy_rate,
                   5 rec_type,nvl(b.short_excess,1)*nvl(b.no_of_copy,0) return_copy
                   from cir_physical_ver_det b,cir_edtn_mast e
                   where b.comp_code =e.comp_code and b.comp_code    ='||''''||pcomp_code||''''||' and 
                   b.unit_code=e.unit_code and b.unit_code='||''''||punit_code||''''||' and 
                   b.recptdt >= '||''''||v_frdt||''''||' and b.recptdt<='||''''||v_todt||''''||' and 
                   b.publ_code=nvl('||''''||ppubl||''''||',b.publ_code) and
                   b.publ_code=e.publ and b.edtn_code=e.edtn and e.main_edtn=nvl('||''''||pmainedtn||''''||',e.main_edtn) and
                   b.branch_code=nvl('||''''||pbran_code||''''||',b.branch_code)
                   union all
                   select b.comp_code comp_code,b.unit_code unit_code,NULL branch_code,''Privious Balance'' branch_name,b.publ_code publ,e.main_edtn edtn,b.copy_rate copy_rate,
                   6 rec_type,nvl(b.opbal,0) return_copy
                   from cir_temp_unsold_stock b,cir_edtn_mast e
                   where b.comp_code =e.comp_code and b.unit_code=e.unit_code and  
                   b.publ_code=e.publ and b.edtn_code=e.edtn and sess_id=userenv(''sessionid'')) u
                   where u.return_copy<>0
                   group by u.comp_code,u.unit_code,u.branch_name,u.publ,u.edtn,u.rec_type,u.copy_rate) c
                   group by c.comp_code,c.unit_code,c.rec_type,c.branch_name
                   order by c.comp_code,c.unit_code,c.rec_type,c.branch_name';
                   
             --insert into test1(vstring,vstring2) values('unsold edtn branch comp return v_query5 ',v_query1);COMMIT;
            
            open p_accounts5 for v_query1; 
        
            open p_accounts6 for select sysdate from dual;
    Else
        v_query1:='select '||''''||pcomp_code||''''||' comp_code,'||''''||punit_code||''''||' unit_code,null agcd,null dpcd,null agname,null agname_oth_lang,null city_name,null taluka_name,0 supply_copy,0 return_copy from dual';
        --insert into test1(vstring,vstring2) values('unsold else edtn vquery ',v_query1);COMMIT;
        
        open p_accounts for v_query1;
        v_query1:='select '||''''||pcomp_code||''''||' comp_code,'||''''||punit_code||''''||' unit_code,null taluka_name,0 supply_copy,0 return_copy from dual';
        --insert into test1(vstring,vstring2) values('unsold else edtn vquery2 ',v_query1);COMMIT;
        
        open p_accounts1 for v_query1;
        v_query1:='select '||''''||pcomp_code||''''||' comp_code,'||''''||punit_code||''''||' unit_code,0 supply_copy,0 return_copy from dual';
        --insert into test1(vstring,vstring2) values('unsold else edtn vquery3 ',v_query1);COMMIT;
        
        open p_accounts2 for v_query1;
             v_query1:='select null from dual';
        open p_accounts3 for v_query1;    
        
        open p_accounts5 for select sysdate from dual; 
        
        open p_accounts6 for select sysdate from dual;         
    End if;
    delete from cir_temp_unsold_stock where sess_id=userenv('sessionid');commit;
   End cir_unsold_return_punya; 
   
  procedure cir_rep_unsold_challan(
     pcompcode             in varchar2,
     punitcode             in varchar2,
     pdoctype            in varchar2,
     pagcode            in varchar2,
     pagsubcode            in varchar2,
     pfrom_recdate         in varchar2,
     ptill_recdate      in varchar2,
     precptno           in varchar2,
     papproved_flag     in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts)
  As
    v_frdt date;
    v_todt date;
  Begin
    v_frdt:=to_date(pfrom_recdate,''''||pdateformat||'''');
    v_todt:=to_date(ptill_recdate,''''||pdateformat||'''');
    
    open p_accounts for
    select u.comp_code as comp_code,u.unit_code as unit_code,u.branch_code branch_code,
    u.branch_name branch_name,u.agcd agcd,u.dpcd dpcd,
    u.ag_name AS ag_name,u.recptdt recptdt,u.recptno recptno ,u.publ publ,u.publ_name publ_name, 
    u.main_edtn main_edtn, u.main_edtnname main_edtnname,u.edtn edtn,u.edtn_name edtn_name,
    u.copy_rate copy_rate,
    u.return_copy return_copy 
    from(select d.comp_code as comp_code,d.unit_code as unit_code,d.branch_code branch_code,
    get_branch_name(d.branch_code) branch_name,d.agcd agcd,d.dpcd dpcd,
    m.ag_name AS ag_name,d.recptdt recptdt,d.recptno recptno ,d.publ publ,cir_get_name.cir_publ(d.comp_code,d.publ,1,'','','') publ_name, 
    e.main_edtn main_edtn,cir_get_name.cir_edtn(d.comp_code,d.unit_code,e.main_edtn,1,'','','') main_edtnname,d.edtn edtn,e.edtn_name edtn_name,
    d.copy_rate copy_rate,
    sum(nvl(d.short_recpt,0)+nvl(d.late_recpt,0)+nvl(d.bnr,0)+nvl(d.unsold,0)) return_copy
    from cir_agmast_dis m, cir_unsold_hdr_dis h,cir_unsold_dtl_dis d,cir_edtn_mast e
    where m.comp_code=d.comp_code and d.comp_code=h.comp_code and m.comp_code=e.comp_code and m.comp_code=pcompcode and 
    m.unit=d.unit_code and d.unit_code=h.unit_code and m.unit=e.unit_code and m.unit=punitcode and 
    m.agcd=d.agcd and m.agcd=nvl(pagcode,m.agcd) and m.dpcd=d.dpcd and m.dpcd=nvl(pagsubcode,m.dpcd) and 
    d.doctype=h.doctype and d.doctype=nvl(pdoctype,d.doctype) and d.recptdt=h.recptdt and d.recptdt between v_frdt and v_todt and 
    d.recptno=h.recptno and d.recptno =nvl(precptno,d.recptno) and 
    d.publ=e.publ and d.edtn=e.edtn and pextra2='D'
    group by d.comp_code,d.unit_code,d.agcd,d.dpcd ,m.ag_name,d.recptdt,d.recptno ,d.publ,d.edtn,
    d.copy_rate,e.main_edtn,d.branch_code,e.edtn_name
    union
    select d.comp_code as comp_code,d.unit_code as unit_code,d.branch_code branch_code,
    get_branch_name(d.branch_code) branch_name,d.agcd agcd,d.dpcd dpcd,
    m.ag_name ag_name,d.recptdt recptdt,d.recptno recptno ,d.publ publ,cir_get_name.cir_publ(d.comp_code,d.publ,1,'','','') publ_name, 
    e.main_edtn main_edtn,cir_get_name.cir_edtn(d.comp_code,d.unit_code,e.main_edtn,1,'','','') main_edtnname,d.edtn edtn,e.edtn_name edtn_name,
    d.copy_rate copy_rate,
    sum(nvl(d.short_recpt,0)+nvl(d.late_recpt,0)+nvl(d.bnr,0)+nvl(d.unsold,0)) return_copy
    from cir_agmast m, cir_unsold_hdr h,cir_unsold_dtl d,cir_edtn_mast e
    where m.comp_code=d.comp_code and d.comp_code=h.comp_code and m.comp_code=e.comp_code and m.comp_code=pcompcode and 
    m.unit=d.unit_code and d.unit_code=h.unit_code and m.unit=e.unit_code and m.unit=punitcode and 
    m.agcd=d.agcd and m.agcd=nvl(pagcode,m.agcd) and m.dpcd=d.dpcd and m.dpcd=nvl(pagsubcode,m.dpcd) and 
    d.doctype=h.doctype and d.doctype=nvl(pdoctype,d.doctype) and d.recptdt=h.recptdt and d.recptdt between v_frdt and v_todt and 
    d.recptno=h.recptno and d.recptno =nvl(precptno,d.recptno) and 
    d.publ=e.publ and d.edtn=e.edtn and (pextra2!='D' or pextra2='' or pextra2 is null)
    group by d.comp_code,d.unit_code,d.agcd,d.dpcd ,m.ag_name,d.recptdt,d.recptno ,d.publ,d.edtn,
    d.copy_rate,e.main_edtn,d.branch_code,e.edtn_name) u
    order by comp_code,unit_code,recptdt,recptno,publ_name,main_edtnname,edtn_name;
    
  End cir_rep_unsold_challan;     
END cir_rep_unsold_supply;
/

///////////////////////////////////////////DESCRIPTION///////////////////////////////////////////////////////////

CREATE OR REPLACE PACKAGE HT18JULY.cir_rep_unsold_supply IS
  type t_accounts is ref cursor;
  procedure cir_rep_unsold_detail(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pdoc_type            in varchar2,
     ppubl                 in varchar2,
     pmainedtn             in varchar2,
     pedtn                 in varchar2,
     pcity                in varchar2,
     pagcode            in varchar2,
     pdepocode            in varchar2,
     pfrom_recdate         in varchar2,
     ptill_recdate      in varchar2,
     papproved_flag     in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts);

  procedure cir_rep_unsold_summary(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pdoc_type          in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pedtn              in varchar2,
     pcity              in varchar2,
     pagcode            in varchar2,
     pdepocode          in varchar2,
     pfrom_recdate      in varchar2,
     ptill_recdate      in varchar2,
     papproved_flag     in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts);
     
   procedure cir_publ_unsold_supply(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pdoc_type          in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pedtn              in varchar2,
     pagcode            in varchar2,
     pdepocode          in varchar2,
     pfromdate          in varchar2,
     ptilldate          in varchar2,
     papproved_flag     in varchar2,
     ptaluka            in varchar2,
     pstatecode         in varchar2,
     pdistcode          in varchar2,
     pbranchcode        in varchar2,     
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts,
     p_accounts3        out t_accounts);
  
  procedure cir_edtn_unsold_supply(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pdoc_type          in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pedtn              in varchar2,
     pagcode            in varchar2,
     pdepocode          in varchar2,
     pfromdate          in varchar2,
     ptilldate          in varchar2,
     papproved_flag     in varchar2,
     ptaluka            in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts,
     p_accounts3        out t_accounts);

  procedure cir_edtn_unsold_supply_dist(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pdoc_type          in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pedtn              in varchar2,
     pagcode            in varchar2,
     pdepocode          in varchar2,
     pfromdate          in varchar2,
     ptilldate          in varchar2,
     papproved_flag     in varchar2,
     pdistcd            in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts,
     p_accounts3        out t_accounts);
     
      procedure cir_monthly_net_paid_sale(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pedtn              in varchar2,
     pfromdate          in varchar2,
     ptilldate          in varchar2,
     pagency_type       in varchar2,
     pagency_class      in varchar2,
     pstatecode         in varchar2,
     pdistcode          in varchar2,
     ptaluka            in varchar2,
     pbranch            in varchar2,
     pagcd              in varchar2,
     pdpcd              in varchar2,
     preptype           in number,--1 for Agency Wise,2 for Main Edition wise,3 for District Taluka wise
     pbreak_on          in varchar2,--Region R/State S/District D/Branch B
     preturn_based      in varchar2,--it is use for return date or supply date(R/S)
     plangtype          in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     pextra3            in varchar2,
     pextra4            in varchar2,
     pextra5            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts,
     p_accounts3        out t_accounts);
     
  procedure cir_rep_unsold_slip(
     pcompcode             in varchar2,
     punitcode             in varchar2,
     pbrancode             in varchar2,
     pdoctype            in varchar2,
     pdistcode            in varchar2,
     ptalukacode        in varchar2,
     pagcode            in varchar2,
     pagsubcode            in varchar2,
     pfrom_recdate         in varchar2,
     ptill_recdate      in varchar2,
     papproved_flag     in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts);

  procedure cir_unsold_return_punya(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pbran_code         in varchar2,
     pdoc_type            in varchar2,
     ppubl                 in varchar2,
     pmainedtn             in varchar2,
     pdistcode          in varchar2,
     ptalukacode        in varchar2,
     pcitycode          in varchar2,
     pagcode            in varchar2,
     pdepocode            in varchar2,
     pfrom_recdate         in varchar2,
     ptill_recdate      in varchar2,
     papproved_flag     in varchar2,
     plangtype          in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts,
     p_accounts3        out t_accounts,
     p_accounts5        out t_accounts,
     p_accounts6        out t_accounts);

    procedure cir_rep_unsold_challan(
     pcompcode             in varchar2,
     punitcode             in varchar2,
     pdoctype            in varchar2,
     pagcode            in varchar2,
     pagsubcode            in varchar2,
     pfrom_recdate         in varchar2,
     ptill_recdate      in varchar2,
     precptno           in varchar2,
     papproved_flag     in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts);     
END cir_rep_unsold_supply;
/
////////////////////////////////////////////////////END/////////////////////////////////////////////////////////////////
///////////////////////////////////////////////start issue no 5718////////////////////////////////////////////////////////////////////

/* Formatted on 2011/12/05 12:57 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FUNCTION cir_get_city (
   pcomp_code   IN   VARCHAR2,
   pcity_code   IN   VARCHAR2
)
   RETURN VARCHAR2
IS
   vcity_name   cir_city_mast.city_name%TYPE;
BEGIN
   BEGIN
      SELECT city_name
        INTO vcity_name
        FROM cir_city_mast
       WHERE comp_code = pcomp_code AND city_code = pcity_code;
   -- exception when others then
             --vcity_name:=null;
   END;

   RETURN NVL (vcity_name, '');
END;
/

CREATE OR REPLACE PACKAGE BODY cir_rep_agency_ledger IS
PROCEDURE cir_agency_ledger_p(
    pcompcode       in varchar2,
    punitcode       in varchar2,
    pactype         in varchar2,
    pbranchcode     in varchar2,
    pagency_type    in varchar2,
    pagcd           in varchar2,
    pdpcd           in varchar2,
    pstatecode      in varchar2,
    pdistcode       in varchar2,
    pcitycode       in varchar2,
    ptalukacode     in varchar2,
    pfrom_date      in varchar2,  
    ptill_date      in varchar2,
    pbilladj_flag   in varchar2,
    psortedby       in varchar2,
    puserid         in varchar2,
    prowbreak       in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,--it is use for agency class
    pextra2         in varchar2,
    P_Accounts      out T_Accounts_Cursor,
    P_Accounts1     out T_Accounts_Cursor)
As
    v_frdt          date;
    v_todt          date;
    v_opdate        date;

    v_opbal         number(15,2):=0;
    v_opbal_sec     number(15,2):=0;
    v_amt           number(15,2):=0;
    v_clbal         number(15,2):=0;
    v_runbal        number(15,2):=0;
    v_billamt       number:=0;
    v_dbcramt       number:=0;
    v_cramt         number(15,2) :=0;
    v_dbamt         number(15,2) :=0;
    v_rec_seqno     number:=0;
    v_remark_len    number:=0;
    v_divident      number:=0;
    v_narration     varchar2(1000);
    v_runbal_txt    varchar2(20);
        cursor c1 is
            select distinct comp_code,unit,agcd,dpcd,ag_name,ag_name_oth_lang,city_code,tehsil_taluka,dist_code,state_code,
            country_code,branch_code from cir_agmast
                where comp_code=pcompcode and (unit=punitcode or punitcode is null) and
                            (ag_type=pagency_type or pagency_type is null) and agcd||dpcd in(select distinct agcd||dpcd from cir_outmast
                            where comp_code=pcompcode and (unit_code=punitcode or punitcode is null) and achd=pactype) and
                            (agcd=pagcd or pagcd is null) and (dpcd=pdpcd or pdpcd is null) and (branch_code=pbranchcode or pbranchcode is null) and
                            (state_code=pstatecode or pstatecode is null) and (dist_code=pdistcode or pdistcode is null) and
                            (tehsil_taluka=ptalukacode or ptalukacode is null) and (ag_class=pextra1 or pextra1 is null)
                            order by branch_code,city_code,ag_name;
        v1 c1%rowtype;
       cursor c2 is
        select comp_code,unit_code,agcd,dpcd,doctype,recptno,recptdt,amount,chno,chdt,chbank,reason,narration,received_from from
        (select comp_code,unit_code,agcd,dpcd,doctype,recptno,recptdt,amount,chno,chdt,chbank,
        case when cir_rcphdr.doctype='RCR' then (select "Payment_Mode_Name" from payment_mode_mast where "Pay_Mode_Code"=cir_rcphdr.reason)
        else (select reason_name from cir_reason_mst where comp_code=cir_rcphdr.comp_code and reason_code=cir_rcphdr.reason) end as reason,
        remark narration,received_from from cir_rcphdr
            where comp_code=v1.comp_code and unit_code=v1.unit and agcd=v1.agcd and dpcd=v1.dpcd and recptdt
                between v_frdt and v_todt and nvl(achd,'NM')=pactype
        union
        select comp_code,unit_code,agcd,dpcd,'BIL' doctype,billno recptno,billdt recptdt,sum(bill_amount) amount,null chno,null chdt,null chbnk,'BILL' reason,
        'Bill Copy '||sum(bill_copy)||' Comm. Amount '||sum(comm_amount) narration,null received_from from cir_bill
            where comp_code=v1.comp_code and unit_code=v1.unit and agcd=v1.agcd and dpcd=v1.dpcd and
                billdt between v_frdt and v_todt and pactype='NM'
                group by comp_code,unit_code,agcd,dpcd,billno,billdt)
        order by recptdt,doctype,recptno;
        v2 c2%rowtype;
    Begin
        v_opdate    :=cir_get_finandt(pcompcode,to_date(pfrom_date,''''||pdateformat||''''),pdateformat,'','');--for financial date

        v_frdt      :=to_date(pfrom_date,''''||pdateformat||'''');
        v_todt      :=to_date(ptill_date,''''||pdateformat||'''');
        v_divident  :=nvl(prowbreak,35);
           delete from cir_ledger_report where sess_id=userenv('sessionid');
        --delete from test1;commit;
        --insert into test1(vstring,vstring2) values('unit outstanding monthwise vvar ',v_months);commit;
        open c1;
        loop
            fetch c1 into v1;
            exit when c1%notfound;
            v_opbal        :=cir_accounts.cir_agency_opbal(pcompcode,punitcode,'',v1.agcd,v1.dpcd,v_opdate,pactype,pdateformat,'','');
            ----for secutiry outstanding---
            if pactype='NM' then
                v_opbal_sec :=cir_accounts.cir_agency_opbal(pcompcode,punitcode,'',v1.agcd,v1.dpcd,v_opdate,'SC',pdateformat,'','');
                select sum(amount) into v_dbcramt from cir_rcphdr
                where comp_code=pcompcode and (unit_code=punitcode or punitcode is null) and
                            agcd=v1.agcd and dpcd=v1.dpcd and recptdt>= v_opdate and recptdt<=v_todt and
                            achd='SC';
                v_opbal_sec:=nvl(v_opbal_sec,0)+nvl(v_dbcramt,0);

            else
                v_opbal_sec :=0;
            end if;
            ----for secutiry outstanding---
            v_dbcramt:=0;
            select sum(amount) into v_billamt from cir_outmast
                where comp_code=pcompcode and (unit_code=punitcode or punitcode is null) and
                            agcd=v1.agcd and dpcd=v1.dpcd and billdt >= v_opdate and billdt<v_frdt and
                            achd=pactype and recptno is null;
            select sum(amount) into v_dbcramt from cir_rcpdet
                where comp_code=pcompcode and (unit_code=punitcode or punitcode is null) and
                            agcd=v1.agcd and dpcd=v1.dpcd and recptdt>= v_opdate and recptdt<v_frdt and
                            achd=pactype and billno is null;

            v_opbal:=nvl(v_opbal,0)+nvl(v_billamt,0)+nvl(v_dbcramt,0);

            v_rec_seqno:=nvl(v_rec_seqno,0)+1;
              insert into cir_ledger_report
                  (comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
                  exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
                  billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line)
              values(v1.comp_code,v1.unit,v1.branch_code,v1.agcd,v1.dpcd,'',null,v_frdt,v_opbal_sec,
                     null,'Security Balance',null,null,null,null,null,null,
                     null,null,null,null,null,v1.ag_name,v_rec_seqno,1);

            v_rec_seqno:=nvl(v_rec_seqno,0)+1;
            v_runbal:=v_opbal;
            if v_runbal>=0 then
                v_runbal_txt:=to_char(v_runbal,'99999990.99')||' Dr.';
            else
                v_runbal_txt:=to_char(abs(v_runbal),'99999990.99')||' Cr.';
            end if;


              insert into cir_ledger_report
                  (comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
                  exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
                  billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line)
              values(v1.comp_code,v1.unit,v1.branch_code,v1.agcd,v1.dpcd,'',null,v_frdt,v_opbal,
                     null,'Opening Balance',null,null,null,null,null,null,
                     null,null,null,null,null,v1.ag_name,v_rec_seqno,2);

            --------daily transactions------------
            open c2;
            loop
                fetch c2 into v2;
                exit when c2%notfound;
                if nvl(v2.amount,0)<>0 then
                    v_rec_seqno:=nvl(v_rec_seqno,0)+1;
                    v_narration:=null;
                    if v2.doctype='BIL' then
                        v_narration:=v2.narration;
                    else
                        if v2.narration is not null then
                           v_narration:=v2.narration;
                            if v2.chno is not null then
                                v_narration:=v_narration||' CHNO# '||v2.chno;
                            end if;
                            if v2.chdt is not null then
                                v_narration:=v_narration||' CHDT '||v2.chdt;
                            end if;
                            if v2.chbank is not null then
                                v_narration:=v_narration||' CHBNK '||v2.chbank;
                            end if;
                        else
                            if v2.chno is not null then
                                v_narration:='CHNO# '||v2.chno;
                            end if;
                            if v2.chdt is not null then
                                v_narration:=v_narration||' CHDT '||to_char(v2.chdt,''||pdateformat||'');
                            end if;
                            if v2.chbank is not null then
                                v_narration:=v_narration||' CHBANK '||v2.chbank;
                            end if;
                            if v2.reason='CASH' and v2.doctype='RCR' then
                                v_narration:='By Cash '||v_narration;
                            end if;
                        end if;
                    end if;
                    v_remark_len := length(nvl(ltrim(rtrim(v_narration)),'-'));
                    v_amt:=nvl(v_amt,0)+nvl(v2.amount,0);

                    v_runbal:=v_runbal+nvl(v2.amount,0);

                    if v_runbal>=0 then
                        v_runbal_txt:=to_char(v_runbal,'99999990.99')||' Dr.';
                    else
                        v_runbal_txt:=to_char(abs(v_runbal),'99999990.99')||' Cr.';
                    end if;

                    if nvl(v2.amount,0)>=0 then
                        v_dbamt:=nvl(v_dbamt,0)+nvl(v2.amount,0);
                    elsif nvl(v2.amount,0)<0 then
                        v_cramt:=nvl(v_cramt,0)+abs(nvl(v2.amount,0));
                    end if;
                  insert into cir_ledger_report
                      (comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
                      exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
                      billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line)
                  values(v1.comp_code,v1.unit,v1.branch_code,v1.agcd,v1.dpcd,v2.doctype,v2.recptno,v2.recptdt,v2.amount,
                         v2.received_from,nvl(ltrim(rtrim(v_narration)),'-'),v2.chno,v2.chdt,v2.chbank,v2.reason,null,v_runbal_txt,
                         null,null,null,null,v_runbal,v1.ag_name,v_rec_seqno,mod_function(v_remark_len,v_divident));

                end if;
            end loop;
            close c2;
            --------daily transactions------------

            v_clbal :=nvl(v_opbal,0)+nvl(v_amt,0);

            v_rec_seqno:=nvl(v_rec_seqno,0)+1;
            if v_runbal>=0 then
                v_runbal_txt:=to_char(v_runbal,'99999990.99')||' Dr.';
            else
                v_runbal_txt:=to_char(abs(v_runbal),'99999990.99')||' Cr.';
            end if;
      insert into cir_ledger_report
          (comp_code,unit_code,branch_code,agcd,dpcd,doctype,recptno,recptdt,amount,
          exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
          billno,billdt,billamt,adjamt,leftamt,agname,rec_seqno,narr_line)
      values(v1.comp_code,v1.unit,v1.branch_code,v1.agcd,v1.dpcd,'',null,v_todt,nvl(v_clbal,0),
              null,'Closing Balance',null,null,null,null,null,null,
              null,null,null,null,null,v1.ag_name,v_rec_seqno,1);
        if nvl(v_opbal_sec,0)=0 and nvl(v_opbal,0)=0 and v_cramt=0 and v_dbamt=0 then
           delete from cir_ledger_report where comp_code=v1.comp_code and unit_code=v1.unit and
            agcd=v1.agcd and dpcd=v1.dpcd and sess_id=userenv('sessionid');
        end if;

        v_billamt:=0;v_dbcramt:=0;v_opbal:=0;v_clbal:=0;v_amt:=0;v_runbal:=0;v_cramt:=0;v_dbamt:=0;v_runbal_txt:=null;

        end loop;
        close c1;
        commit;
insert into test1(vstring,vstring2) values('unit outstanding monthwise vvar ','3');commit;
    open P_Accounts for
    select
    (select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code)  as "CNAME",
    comp_code,unit_code,branch_code,(select "Branch_Name" from branch_mst where "Branch_Code"=branch_code) branch_name,
    agcd,dpcd,agname,cir_get_agency_city(comp_code,unit_code,agcd,dpcd) city_name, 
    doctype,recptno,recptdt,
    decode(a.debit,'D',a.amount) as debit,decode(a.credit,'C',a.amount) as credit,exec_code,remarks,
    chqno,chqdt,chq_bank,reason,debit_head,credit_head,
    billno,billdt,billamt,adjamt,leftamt,rec_seqno,narr_line from
    (select comp_code,unit_code,branch_code,agcd,dpcd,agname,doctype,recptno,recptdt,
     decode(sign(amount),1,'D') as debit,decode(sign(amount),-1,'C') as credit,abs(amount) as amount,
     exec_code,remarks,chqno,chqdt,chq_bank,reason,debit_head,credit_head,
     billno,billdt,billamt,adjamt,leftamt,rec_seqno,nvl(narr_line,1) as narr_line from cir_ledger_report
    where comp_code=pcompcode and unit_code=punitcode and sess_id=userenv('sessionid') ) a order by rec_seqno;
insert into test1(vstring,vstring2) values('unit outstanding monthwise vvar ','2');commit;
    open P_Accounts1 for
    select (select "Comp_Name" from comp_mst where "Comp_Code"=a.comp_code)  as "CNAME",comp_code,agcd,dpcd,agname,
    count(*),nvl(sum(narr_line),0) sum_narr from
    (select comp_code,unit_code,branch_code,agcd,dpcd,agname,doctype,recptno,recptdt,
    decode(sign(amount),1,'D') as debit,decode(sign(amount),-1,'C') as credit,abs(amount) as amount,rec_seqno,narr_line from cir_ledger_report
    where comp_code=pcompcode and unit_code=punitcode and sess_id=userenv('sessionid') ) a
    group by comp_code,agcd,dpcd,agname
    order by comp_code,agcd,dpcd,agname;
    insert into test1(vstring,vstring2) values('unit outstanding monthwise vvar ','1');commit;
    delete from cir_ledger_report where sess_id=userenv('sessionid');
    commit;
    End cir_agency_ledger_p;
    
END cir_rep_agency_ledger;
/



////////////////////////////////////////////////////////////end/////////////////////////////////////////////////////////

/**************************************** For Login 8 dec 2011 **************************/
CREATE OR REPLACE PACKAGE BODY Websp_Loginemployee
IS

--var a refcursor;
--var b refcursor;
--var c refcursor;
--exec websp_loginemployee.websp_loginemployee_p('bh01','123','',:a,:b,:c);
    PROCEDURE Websp_Loginemployee_P (Vusername IN VARCHAR2 ,vpassword IN VARCHAR2 ,vqbc IN VARCHAR2,
        P_Accounts OUT T_Accounts_Cursor,
        P_Accounts1 OUT T_Accounts_Cursor,
        P_Accounts2 OUT T_Accounts_Cursor)
    AS
        vuserid VARCHAR2(100);
        v_nm varchar2(100);
        COUNT VARCHAR2(100);
    BEGIN
        IF Vqbc IS NULL THEN
        OPEN P_Accounts FOR
        SELECT "username","password","userid","date_format","COM_CODE","Autogenerate","curr_code","comp_name",
        to_date(sysdate)-to_date(CREATION_DATETIME) as "diff",DISCOUNT,FILTER,ROLEID,"retainer_code" AS RETAINER FROM LOGIN
        WHERE "userid"=Vusername  AND "password"=Vpassword and STATUS !='I';

        OPEN P_Accounts1 FOR SELECT "rate_gr_code","autogenerated","currency_code","date_format","solo","No_of_Decimal",
        "breakup","blackwhitecode","uom_code","rostatus","Tfn","Insert_breakup","Premium_type","Deal_type"     ,
        "prefix","suffix","financestatus","voucherst","Ad_category","Ro_datetime","Space_area","Vat","Booking_status","Cio_id","Receipt_no","Bgcolor_publication", "chkfor_valid_pubdates","Agency_ratecode","audit","copy_booking","RATE_COMPANY_AGENCY","SUBEDITIONRATE","ADDITIONAL_AGENCY_COMM","AGENCY_RETAINER_COMM",

        "invoice_no","rate_audit",CLS_BILLTYPE,DIS_BILLTYPE,BILLING_FORMAT, RATE_CHECK, ALL_PACKAGE,DAYRATE,SCHEME_TYPE,DISP_CLSBILL,RECEIPT_FORMAT,CASH_RECEIPT_BILL, BILL_ORDERWSLAST, FLOOR_CHK,ROKEYCHECK,
		DISP_CASHBILL, CLA_CASHBILL,RATE_AUDIT_PREF,        
        FA_LEDGER_ALLOW,CLEARANCE_TYPE_ALLOW,DISP_AUDITBKG, CIR_AUTO_PHYSICAL_UNSOLD
        FROM PREFERRENCES WHERE "comp_code"=(SELECT "COM_CODE" FROM LOGIN WHERE "userid"=Vusername AND "password"=Vpassword);
        
        BEGIN
              SELECT "COM_CODE","username" INTO COUNT,v_nm FROM LOGIN WHERE "userid"=vusername AND "password"=vpassword;
              EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
        END;
      
      -- Using Userid,UserNAme & User MAchine ID For Log Purpose
          sec_user.set_userid(vusername);
          sec_user.set_username(v_nm);
          sec_user.set_userip('');
      -- Using Userid,UserNAme & User MAchine ID For Log Purpose     

    OPEN P_Accounts2 FOR
    SELECT "Company_user","Admin" FROM LOGIN WHERE "userid"=Vusername;

ELSE
    OPEN P_Accounts FOR SELECT "username","password","userid","date_format","COM_CODE","Autogenerate","curr_code","comp_name",to_date(sysdate)-to_date(CREATION_DATETIME) as "diff", DISCOUNT,FILTER,ROLEID,"retainer_code" AS RETAINER FROM LOGIN
    WHERE "userid"=Vusername AND "password"=Vpassword AND ("retainer_code"=Vqbc) and STATUS !='I'/* or "retainer_code" in(select BRANCH_CODE from login_branch_mast where BRANCH_CODE =Vqbc and USER_CODE=Vusername and USER_FLAG='Y') )*/ and "Company_user" is null;

OPEN P_Accounts1 FOR SELECT "rate_gr_code","autogenerated","currency_code","date_format","solo","No_of_Decimal",
"breakup","blackwhitecode","uom_code","rostatus","Tfn","Insert_breakup","Premium_type","Deal_type"     ,
"prefix","suffix","financestatus","voucherst","Ad_category","Ro_datetime","Space_area","Vat","Booking_status","Cio_id","Receipt_no","Bgcolor_publication", "chkfor_valid_pubdates","Agency_ratecode","audit","copy_booking","RATE_COMPANY_AGENCY","SUBEDITIONRATE","ADDITIONAL_AGENCY_COMM","AGENCY_RETAINER_COMM",
"invoice_no","rate_audit",CLS_BILLTYPE,DIS_BILLTYPE,BILLING_FORMAT, RATE_CHECK, ALL_PACKAGE, DAYRATE,SCHEME_TYPE,DISP_CLSBILL,RECEIPT_FORMAT,CASH_RECEIPT_BILL, BILL_ORDERWSLAST, FLOOR_CHK,ROKEYCHECK,

DISP_CASHBILL, CLA_CASHBILL,RATE_AUDIT_PREF ,FA_LEDGER_ALLOW,CLEARANCE_TYPE_ALLOW,DISP_AUDITBKG,CIR_AUTO_PHYSICAL_UNSOLD
FROM PREFERRENCES WHERE "comp_code"=(SELECT "COM_CODE" FROM LOGIN WHERE "userid"=Vusername AND "password"=Vpassword);
BEGIN
SELECT "COM_CODE","username" INTO COUNT,v_nm FROM LOGIN WHERE "userid"=vusername AND "password"=vpassword AND "retainer_code"=vqbc;
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;

      -- Using Userid,UserNAme & User MAchine ID For Log Purpose
          sec_user.set_userid(vusername);
          sec_user.set_username(v_nm);
          sec_user.set_userip('');
      -- Using Userid,UserNAme & User MAchine ID For Log Purpose 

OPEN P_Accounts2 FOR
SELECT "Company_user","Admin" FROM LOGIN WHERE "userid"=Vusername;
END IF;



END Websp_Loginemployee_P;

END Websp_Loginemployee;
/

/*****************************************END****************************************/
CREATE OR REPLACE procedure cir_rep_supply_detail_p(
    pcomp_code      in varchar2,
    punit_code      in varchar2,
    ppubl           in varchar2,
    pdateformat     in varchar2,
    puserid         in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    pextra3         in varchar2,
    pextra4         in varchar2,
    pextra5         in varchar2,
    pextra6         in varchar2,
    pextra7         in varchar2,
    pextra8         in varchar2,
    pextra9         in varchar2,
    pextra10        in varchar2,            
    p_accounts      OUT Cur_Type_New1.cursor_type)
As
Begin
    
    open p_accounts for
    select m.comp_code as "COMP_CODE", m.unit as "UNIT", m.agcd as "AGCD", m.dpcd as "DPCD",m.ag_name as "AG_NAME",
    m.station_code as "DROP_POINT",cir_get_drop_point_name(m.comp_code,m.unit,m.station_code,1) as "DROP_POINT_NAME", 
    m.city_code as "CITY_CODE", cir_get_city(m.comp_code,m.city_code) as "CITY_NAME", s.publ as "PUBL",p.publ_name as "PUBL_NAME", 
    e.main_edtn as "MAIN_EDTN",cir_get_edtn_name(m.comp_code,e.main_edtn) as "MAIN_EDTN_NAME", 
    s.edtn as "EDTN",e.edtn_name as "EDTN_NAME", 
    s.supply_flag as "SUPPLY_FLAG", s.supply_type_code as "SUPPLY_TYPE_CODE",t.sup_ty_name as "SUP_TY_NAME", 
    s.base_supply as "BASE_SUPPLY", s.supply_sun as "SUPPLY_SUN", s.supply_mon as "SUPPLY_MON", s.supply_tue as "SUPPLY_TUE", s.supply_wed as "SUPPLY_WED",
    s.supply_thu as "SUPPLY_THU", s.supply_fri as "SUPPLY_FRI", s.supply_sat as "SUPPLY_SAT", s.supply_spl1 as "SUPPLY_SPL1", s.supply_spl2 as "SUPPLY_SPL2",
    m.SUSPEND_DATE as"SUSPEND_DATE"  
    from cir_supply s,cir_agmast m,cir_publ_mast p,cir_edtn_mast e,cir_supply_type_mast t
    where m.comp_code=s.comp_code and m.comp_code=p.comp_code and m.comp_code=e.comp_code and m.comp_code=t.comp_code and m.comp_code=nvl(pcomp_code,m.comp_code) and
    m.unit=s.unit and m.unit=nvl(punit_code,m.unit) and m.agcd=s.agcd and  m.dpcd=s.dpcd and s.publ=p.publ and s.publ=nvl(ppubl,s.publ) and 
    s.edtn=e.edtn and s.supply_type_code=t.sup_ty_code 
    and nvl(m.freeze_flag,'N') ='N' and nvl(m.suspend,'N')='Y'
    order by comp_code,unit,city_name,drop_point_name,ag_name,publ_name,main_edtn_name,edtn_name,sup_ty_name; 
    
End cir_rep_supply_detail_p;
/
///////////////////////////////////////////////////
CREATE OR REPLACE PACKAGE BODY cir_supply_alteration IS
  procedure cir_supply_alteration_p(
      pcomp_code        in varchar2,
      punit_code        in varchar2,
      ppubl_code        in varchar2,
      pmedtn_code       in varchar2,
      pedtn_code        in varchar2,
      psup_type         in varchar2,
      pstate            in varchar2,
      pdistcode         in varchar2,
      ptaluka           in varchar2,
      pcitycode         in varchar2,
      pbrancode         in varchar2,
      proutecode        in varchar2,
      pagcd_code        in varchar2,
      pdpcd_code        in varchar2,
      psorted_by        in varchar2,--1 for  edition route wise,2 for edition district wise
      pdateformat       in varchar2,
      puserid           in varchar2,--for login user id
      pextra1           in varchar2,--agency type
      pextra2           in varchar2,--for agency--A and distribution--D
      pextra3           in varchar2,--agency class
      pextra4           in varchar2,--for zone
      pextra5           in varchar2,--for region
      pextra6           in varchar2,--for suspend Y/N
      pextra7           in varchar2,--for commition category
      pextra8           in varchar2,
      pextra9           in varchar2,
      pextra10          in varchar2,      
      p_circuls         out T_Circul_Cursor)
 As

 Begin
  if upper(pextra2)='D' then
      if psorted_by=2 then---for edition district and agency wise
          open p_circuls for
            select a.comp_code comp_code,a.unit unit,a.agcd agcd,a.dpcd dpcd,a.ag_name agency_name,a.ag_name_oth_lang agency_name_other_lang,a.city_code city_code,
            cir_get_city(a.comp_code,a.city_code) city_name,a.station_code drop_point_code,cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,'1') drop_point_name,
            nvl(c.base_supply,0) base_supply,nvl(c.supply_sun,0) supply_sun,nvl(c.supply_mon,0) supply_mon,nvl(c.supply_tue,0) supply_tue,nvl(c.supply_wed,0) supply_wed,
            nvl(c.supply_thu,0) supply_thu,nvl(c.supply_fri,0) supply_fri,nvl(c.supply_sat,0) supply_sat,nvl(c.supply_spl1,0) supply_spl1,nvl(c.supply_spl2,0) supply_spl2,
            c.lbl_printno supply_seq,cir_get_route_seqno(c.comp_code,c.unit,c.route_code) route_seq,
            c.route_code,cir_get_name.cir_route(a.comp_code,a.unit,c.route_code,1,pdateformat,'','') route_name, 
            c.subroute_code,cir_get_name.cir_subroute(a.comp_code,a.unit,c.route_code,c.subroute_code,1,pdateformat,'','') subroute_name,
            c.sub_subroute_code,cir_get_name.cir_subsubroute(a.comp_code,a.unit,c.route_code,c.subroute_code,c.sub_subroute_code,1,pdateformat,'','') subsubroute_name,
            d.dist_name dist_name,nvl(p.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,c.supply_type_code supply_type_code,b.sup_ty_name supply_type_name,c.edtn edtn,e.edtn_name edtn_name,
            a.suspend suspend,c.publ publ,cir_get_publ_name(a.comp_code,c.publ) publ_name
            from cir_agmast_dis a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code=pcomp_code and p."comp_code"=pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit=punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ and c.publ=ppubl_code and c.edtn=e.edtn and c.edtn = nvl(pedtn_code,c.edtn) and e.main_edtn = nvl(pmedtn_code,e.main_edtn) and 
            a.agcd=c.agcd and a.agcd=nvl(pagcd_code,a.agcd) and a.dpcd=c.dpcd and a.dpcd=nvl(pdpcd_code,a.dpcd) and c.supply_type_code=nvl(psup_type,c.supply_type_code) and 
            (a.state_code=pstate or pstate is null) and
            (a.dist_code=pdistcode or pdistcode is null ) and (a.tehsil_taluka = ptaluka or ptaluka is null) and
            (a.city_code=pcitycode or pcitycode is null) and (a.branch_code = pbrancode or pbrancode is null) and
            (c.route_code=proutecode or proutecode is null) and nvl(c.supply_flag,'N') ='Y' and 
            ((nvl(a.suspend,'N')=nvl(pextra6,'N')) or (pextra6 is null)) and
            a.freeze_flag='N' and
            ((c.comm_code = pextra7) or (pextra7 is null)) and 
            (a.ag_type=pextra1 or pextra1 is null) and 
            (a.ag_class=pextra3 or pextra3 is null) 
            order by dist_name,agency_name,edtn_name,supply_type_name,supply_seq;
      else
          open p_circuls for
          select a.comp_code comp_code,a.unit unit,a.agcd agcd,a.dpcd dpcd,a.ag_name agency_name,a.ag_name_oth_lang agency_name_other_lang,a.city_code city_code,
            cir_get_city(a.comp_code,a.city_code) city_name,a.station_code drop_point_code,cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,'1') drop_point_name,
            nvl(c.base_supply,0) base_supply,nvl(c.supply_sun,0) supply_sun,nvl(c.supply_mon,0) supply_mon,nvl(c.supply_tue,0) supply_tue,nvl(c.supply_wed,0) supply_wed,
            nvl(c.supply_thu,0) supply_thu,nvl(c.supply_fri,0) supply_fri,nvl(c.supply_sat,0) supply_sat,nvl(c.supply_spl1,0) supply_spl1,nvl(c.supply_spl2,0) supply_spl2,
            c.lbl_printno supply_seq,cir_get_route_seqno(c.comp_code,c.unit,c.route_code) route_seq,
            c.route_code,cir_get_name.cir_route(a.comp_code,a.unit,c.route_code,1,pdateformat,'','') route_name, 
            c.subroute_code,cir_get_name.cir_subroute(a.comp_code,a.unit,c.route_code,c.subroute_code,1,pdateformat,'','') subroute_name,
            c.sub_subroute_code,cir_get_name.cir_subsubroute(a.comp_code,a.unit,c.route_code,c.subroute_code,c.sub_subroute_code,1,pdateformat,'','') subsubroute_name,
            d.dist_name dist_name,nvl(p.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,c.supply_type_code supply_type_code,b.sup_ty_name supply_type_name,c.edtn edtn,e.edtn_name edtn_name,
            a.suspend suspend,c.publ publ,cir_get_publ_name(a.comp_code,c.publ) publ_name
            from cir_agmast_dis a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code=pcomp_code and p."comp_code"=pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit=punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ and c.publ=ppubl_code and c.edtn=e.edtn and c.edtn = nvl(pedtn_code,c.edtn) and e.main_edtn = nvl(pmedtn_code,e.main_edtn) and 
            a.agcd=c.agcd and a.agcd=nvl(pagcd_code,a.agcd) and a.dpcd=c.dpcd and a.dpcd=nvl(pdpcd_code,a.dpcd) and c.supply_type_code=nvl(psup_type,c.supply_type_code) and 
            (a.state_code=pstate or pstate is null) and
            (a.dist_code=pdistcode or pdistcode is null ) and (a.tehsil_taluka = ptaluka or ptaluka is null) and
            (a.city_code=pcitycode or pcitycode is null) and (a.branch_code = pbrancode or pbrancode is null) and
            (c.route_code=proutecode or proutecode is null)  and nvl(c.supply_flag,'N') ='Y' and 
            ((nvl(a.suspend,'N')=nvl(pextra6,'N')) or (pextra6 is null)) and
            a.freeze_flag='N' and
            ((c.comm_code = pextra7) or (pextra7 is null)) and 
            (a.ag_type=pextra1 or pextra1 is null) and 
            (a.ag_class=pextra3 or pextra3 is null)
             order by route_seq,supply_seq,agency_name,edtn_name,supply_type_name;
      end if;
  else
      if psorted_by=2 then---for edition district and agency wise
          open p_circuls for
            select a.comp_code comp_code,a.unit unit,a.agcd agcd,a.dpcd dpcd,a.ag_name agency_name,a.ag_name_oth_lang agency_name_other_lang,a.city_code city_code,
            cir_get_city(a.comp_code,a.city_code) city_name,a.station_code drop_point_code,cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,'1') drop_point_name,
            nvl(c.base_supply,0) base_supply,nvl(c.supply_sun,0) supply_sun,nvl(c.supply_mon,0) supply_mon,nvl(c.supply_tue,0) supply_tue,nvl(c.supply_wed,0) supply_wed,
            nvl(c.supply_thu,0) supply_thu,nvl(c.supply_fri,0) supply_fri,nvl(c.supply_sat,0) supply_sat,nvl(c.supply_spl1,0) supply_spl1,nvl(c.supply_spl2,0) supply_spl2,
            c.lbl_printno supply_seq,cir_get_route_seqno(c.comp_code,c.unit,c.route_code) route_seq,
            c.route_code,cir_get_name.cir_route(a.comp_code,a.unit,c.route_code,1,pdateformat,'','') route_name, 
            c.subroute_code,cir_get_name.cir_subroute(a.comp_code,a.unit,c.route_code,c.subroute_code,1,pdateformat,'','') subroute_name,
            c.sub_subroute_code,cir_get_name.cir_subsubroute(a.comp_code,a.unit,c.route_code,c.subroute_code,c.sub_subroute_code,1,pdateformat,'','') subsubroute_name,
            d.dist_name dist_name,nvl(p.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,c.supply_type_code supply_type_code,b.sup_ty_name supply_type_name,c.edtn edtn,e.edtn_name edtn_name,
            a.suspend suspend,c.publ publ,cir_get_publ_name(a.comp_code,c.publ) publ_name
            from cir_agmast a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,
            --left outer join cir_city_mast m on a.comp_code=m.comp_code and a.city_code=m.city_code,
            cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code=pcomp_code and p."comp_code"=pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit=punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ and c.publ=ppubl_code and c.edtn=e.edtn and c.edtn = nvl(pedtn_code,c.edtn) and e.main_edtn = nvl(pmedtn_code,e.main_edtn) and 
            a.agcd=c.agcd and a.agcd=nvl(pagcd_code,a.agcd) and a.dpcd=c.dpcd and a.dpcd=nvl(pdpcd_code,a.dpcd) and c.supply_type_code=nvl(psup_type,c.supply_type_code) and 
            (a.state_code=pstate or pstate is null) and
            (a.dist_code=pdistcode or pdistcode is null ) and (a.tehsil_taluka = ptaluka or ptaluka is null) and
            (a.city_code=pcitycode or pcitycode is null) and (a.branch_code = pbrancode or pbrancode is null) and
            (c.route_code=proutecode or proutecode is null) and nvl(c.supply_flag,'N') ='Y' and 
            ((nvl(a.suspend,'N')=nvl(pextra6,'N')) or (pextra6 is null)) and
            a.freeze_flag='N' and
            ((c.comm_code = pextra7) or (pextra7 is null)) and 
            (a.ag_type=pextra1 or pextra1 is null) and 
            (a.ag_class=pextra3 or pextra3 is null)
            order by dist_name,agency_name,edtn_name,supply_type_name,supply_seq;
      else
          open p_circuls for
          select a.comp_code comp_code,a.unit unit,a.agcd agcd,a.dpcd dpcd,a.ag_name agency_name,a.ag_name_oth_lang agency_name_other_lang,a.city_code city_code,
            cir_get_city(a.comp_code,a.city_code) city_name,a.station_code drop_point_code,cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,'1') drop_point_name,
            nvl(c.base_supply,0) base_supply,nvl(c.supply_sun,0) supply_sun,nvl(c.supply_mon,0) supply_mon,nvl(c.supply_tue,0) supply_tue,nvl(c.supply_wed,0) supply_wed,
            nvl(c.supply_thu,0) supply_thu,nvl(c.supply_fri,0) supply_fri,nvl(c.supply_sat,0) supply_sat,nvl(c.supply_spl1,0) supply_spl1,nvl(c.supply_spl2,0) supply_spl2,
            c.lbl_printno supply_seq,cir_get_route_seqno(c.comp_code,c.unit,c.route_code) route_seq,
            c.route_code,cir_get_name.cir_route(a.comp_code,a.unit,c.route_code,1,pdateformat,'','') route_name, 
            c.subroute_code,cir_get_name.cir_subroute(a.comp_code,a.unit,c.route_code,c.subroute_code,1,pdateformat,'','') subroute_name,
            c.sub_subroute_code,cir_get_name.cir_subsubroute(a.comp_code,a.unit,c.route_code,c.subroute_code,c.sub_subroute_code,1,pdateformat,'','') subsubroute_name,
            d.dist_name dist_name,nvl(p.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,c.supply_type_code supply_type_code,b.sup_ty_name supply_type_name,c.edtn edtn,e.edtn_name edtn_name,
            a.suspend suspend,c.publ publ,cir_get_publ_name(a.comp_code,c.publ) publ_name
            from cir_agmast a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code=pcomp_code and p."comp_code"=pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit=punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ and c.publ=ppubl_code and c.edtn=e.edtn and c.edtn = nvl(pedtn_code,c.edtn) and e.main_edtn = nvl(pmedtn_code,e.main_edtn) and 
            a.agcd=c.agcd and a.agcd=nvl(pagcd_code,a.agcd) and a.dpcd=c.dpcd and a.dpcd=nvl(pdpcd_code,a.dpcd) and c.supply_type_code=nvl(psup_type,c.supply_type_code) and 
            (a.state_code=pstate or pstate is null) and
            (a.dist_code=pdistcode or pdistcode is null) and (a.tehsil_taluka = ptaluka or ptaluka is null) and
            (a.city_code=pcitycode or pcitycode is null) and (a.branch_code = pbrancode or pbrancode is null) and
            (c.route_code=proutecode or proutecode is null)  and nvl(c.supply_flag,'N') ='Y' and
            ((nvl(a.suspend,'N')=nvl(pextra6,'N')) or (pextra6 is null)) and
            a.freeze_flag='N' and
            ((c.comm_code = pextra7) or (pextra7 is null)) and 
            (a.ag_type=pextra1 or pextra1 is null) and 
            (a.ag_class=pextra3 or pextra3 is null)
             order by route_seq,supply_seq,agency_name,edtn_name,supply_type_name;
      end if;
   end if;
 End cir_supply_alteration_p;
procedure cir_supply_unsold_return_p(
      pcomp_code        in varchar2,
      punit_code        in varchar2,
      ppubl_code        in varchar2,
      pedtn_code        in varchar2,
      pagcd_code        in varchar2,
      pdpcd_code        in varchar2,
      pfromdate         in varchar2,
      ptilldate         in varchar2,
      preturn_type      in varchar2,--it is for on return date received or supply date
      pdateformat       in varchar2,
      pextra1           in varchar2,
      pextra2           in varchar2,
      pextra3           in varchar2,
      pextra4           in varchar2,
      pextra5           in varchar2,      
      p_circuls         out T_Circul_Cursor)
As
    v_frdt date;
    v_todt date;
Begin
    v_frdt :=to_date(pfromdate,''''||pdateformat||'''');
    v_todt :=to_date(ptilldate,''''||pdateformat||'''');
    
    if preturn_type='R' then
        open p_circuls for
        select u.supdate supdate,nvl(u.supply_copy,0) supply_copy,
        (nvl(u.apr_bnr,0)+nvl(u.apr_late_recpt,0)+nvl(u.apr_short_recpt,0)+nvl(u.apr_unsold,0)) return_copy 
        from cir_agmast m,cir_unsold_dtl u 
        where m.comp_code=u.comp_code and m.comp_code=pcomp_code and m.unit=punit_code and m.unit=u.unit_code and 
        doctype='UCN' and recptdt >= v_frdt and recptdt <=v_todt and m.bill_agcd=u.agcd and m.bill_dpcd=u.dpcd and 
        m.agcd=nvl(pagcd_code,m.agcd) and m.dpcd=nvl(pdpcd_code,m.dpcd) and u.publ=ppubl_code and u.edtn=pedtn_code and
        (nvl(u.apr_bnr,0)+nvl(u.apr_late_recpt,0)+nvl(u.apr_short_recpt,0)+nvl(u.apr_unsold,0))>0
        union
        select u.supdate supdate,nvl(u.supply_copy,0) supply_copy,
        (nvl(u.bnr,0)+nvl(u.late_recpt,0)+nvl(u.short_recpt,0)+nvl(u.unsold,0)) return_copy 
        from cir_agmast m,cir_unsold_dtl u 
        where m.comp_code=u.comp_code and m.comp_code=pcomp_code and m.unit=punit_code and m.unit=u.unit_code and 
        doctype='UCN' and recptdt >= v_frdt and recptdt <=v_todt and m.bill_agcd=u.agcd and m.bill_dpcd=u.dpcd and 
        m.agcd=nvl(pagcd_code,m.agcd) and m.dpcd=nvl(pdpcd_code,m.dpcd) and u.publ=ppubl_code and u.edtn=pedtn_code and
        (nvl(u.apr_bnr,0)+nvl(u.apr_late_recpt,0)+nvl(u.apr_short_recpt,0)+nvl(u.apr_unsold,0))=0
        order by supdate;
    else
        open p_circuls for
        select u.supdate supdate,nvl(u.supply_copy,0) supply_copy,
        (nvl(u.apr_bnr,0)+nvl(u.apr_late_recpt,0)+nvl(u.apr_short_recpt,0)+nvl(u.apr_unsold,0)) return_copy 
        from cir_agmast m,cir_unsold_dtl u 
        where m.comp_code=u.comp_code and m.comp_code=pcomp_code and m.unit=punit_code and m.unit=u.unit_code and 
        doctype='UCN' and supdate >= v_frdt and supdate <=v_todt and m.bill_agcd=u.agcd and m.bill_dpcd=u.dpcd and 
        m.agcd=nvl(pagcd_code,m.agcd) and m.dpcd=nvl(pdpcd_code,m.dpcd) and u.publ=ppubl_code and u.edtn=pedtn_code and 
        (nvl(u.apr_bnr,0)+nvl(u.apr_late_recpt,0)+nvl(u.apr_short_recpt,0)+nvl(u.apr_unsold,0))>0
        union
        select u.supdate supdate,nvl(u.supply_copy,0) supply_copy,
        (nvl(u.bnr,0)+nvl(u.late_recpt,0)+nvl(u.short_recpt,0)+nvl(u.unsold,0)) return_copy 
        from cir_agmast m,cir_unsold_dtl u 
        where m.comp_code=u.comp_code and m.comp_code=pcomp_code and m.unit=punit_code and m.unit=u.unit_code and 
        doctype='UCN' and supdate >= v_frdt and supdate <=v_todt and m.bill_agcd=u.agcd and m.bill_dpcd=u.dpcd and 
        m.agcd=nvl(pagcd_code,m.agcd) and m.dpcd=nvl(pdpcd_code,m.dpcd) and u.publ=ppubl_code and u.edtn=pedtn_code and
        (nvl(u.apr_bnr,0)+nvl(u.apr_late_recpt,0)+nvl(u.apr_short_recpt,0)+nvl(u.apr_unsold,0))=0        
        order by supdate;    
    end if;    

End cir_supply_unsold_return_p; 
END cir_supply_alteration;
/
/////////////////////////////////
CREATE OR REPLACE procedure cir_incentive_cn_process_p(
    pcompcode       in varchar2,
    punitcode       in varchar2,
    ppublcode       in varchar2,
    pedtncode       in varchar2,
    pagcode         in varchar2,
    pdepocode       in varchar2,
    pdatefrom       in varchar2,
    pdatetill       in varchar2,
    pdoctype        in varchar2,
    precptdt        in varchar2,
    precptno        in varchar2,
    preason         in varchar2,
    pinct_rate      in number,
    pinct_type      in varchar2,
    pfreg_type      in varchar2,   
    premark         in varchar2,
    puserid         in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    pextra3         in varchar2,
    pextra4         in varchar2,
    pextra5         in varchar2,
    P_Accounts      OUT Cur_Type_New1.cursor_type)
  As
    v_frdt      date;
    v_todt      date;
    v_doctype   varchar2(10);
    v_recptdt   date;
    v_dt        date;
    cursor c2 is
        select s.comp_code,s.unit_code,s.publ_code,s.doctype,sum(s.tot_supply) tot_supply,s.recptdt,s.recptno,sum(s.amount) amount,s.bilagcd,s.bildpcd 
        from cir_inct_process_det s,cir_agmast m 
        where s.comp_code=m.comp_code and s.comp_code=pcompcode and s.unit_code=m.unit and s.unit_code=punitcode and 
        s.bilagcd=m.agcd and (s.bilagcd=pagcode or pagcode is null) and s.bildpcd=m.dpcd and (s.bildpcd= pdepocode or pdepocode is null) and
        s.recptno=precptno and s.recptdt=v_recptdt and s.tran_type='INC'
        group by s.comp_code,s.unit_code,s.doctype,s.recptdt,s.recptno,s.bilagcd,s.bildpcd,s.publ_code
        having sum(s.amount)>0
        order by s.comp_code,s.unit_code,s.bilagcd,s.bildpcd;
    v_amt       number(15,2);
    v_remark    varchar2(500);
    v_recptno   varchar2(50);
    v_dsign     number(5);
    
    v_bran_code  varchar2(20);
    v_rec_no     number(10);  
    v_unsold_copy number(10);
    vdistcode   varchar2(4000);
    vtalukacode varchar2(4000);     
    v2 c2%rowtype;
  Begin
    --insert into test1(vstring,vstring2) values('pdatefrom '||pdatefrom||' pdatetill '||pdatetill||' precptdt '||precptdt,' pdateformat '||pdateformat); commit;
    v_frdt      :=to_date(pdatefrom,''''||pdateformat||'''');
    v_todt      :=to_date(pdatetill,''''||pdateformat||'''');
    v_recptdt   :=to_date(precptdt,''''||pdateformat||'''');

    insert into cir_inct_process_det
        (comp_code, unit_code, publ_code, edtn_code, sup_type_code, from_pdate, till_pdate, agcd, dpcd, tot_supply, from_supply, till_supply, inct_rate, calc_type, amount, doctype, recptdt, recptno, bilagcd, bildpcd,
        created_by, created_date, updated_by, updated_date,tran_type)
        select s.comp_code, s.unit_code, s.publ_code, s.edtn_code, s.sup_type_code, s.from_pdate, s.till_pdate, s.agcd, s.dpcd, s.tot_supply, s.from_supply, s.till_supply, nvl(pinct_rate, s.inct_rate), 
        s.calc_type, case when s.calc_type='P' then round(s.tot_supply*(nvl(pinct_rate, s.inct_rate)/100),2) else round(s.tot_supply*nvl(pinct_rate, s.inct_rate),2) end amount, s.doctype, s.recptdt, s.recptno, s.bilagcd, s.bildpcd,
                created_by, created_date, updated_by, updated_date,tran_type 
        from cir_inct_process_det_temp s,cir_edtn_mast e 
        where s.comp_code=pcompcode and s.comp_code=e.comp_code and s.unit_code=punitcode and 
            s.bilagcd=pagcode and s.bildpcd= pdepocode and s.recptno=precptno and s.recptdt=precptdt and 
            s.publ_code=e.publ and s.edtn_code=e.edtn and e.main_edtn=pedtncode and s.tran_type='INC' and nvl(final_process,'N')='Y';
            
    if pdoctype is null then
        v_doctype:='CN';
    else
        v_doctype:=pdoctype;
    end if;
        
   v_amt:=0;
   --insert into test1(vstring,vstring2) values(' suppliment charges1 ',userenv('sessionid'));commit;
   open c2;
   loop
    fetch c2 into v2;
    exit when c2%notfound;
        --insert into test1(vstring,vstring2) values(' suppliment charges2 ',userenv('sessionid'));commit;
        select branch_code into v_bran_code from cir_agmast 
            where comp_code=v2.comp_code and unit=v2.unit_code and agcd=v2.bilagcd and dpcd=v2.bildpcd;
        
        select Dsign into v_dsign from cir_docmst where Comp_code=pcompcode AND doc_type=v_doctype;

        if(v_dsign=-1) THEN
            v_amt:=v2.amount*v_dsign;
        else
            v_amt:=v2.amount*v_dsign;
        end if;
        if premark is null then
            v_remark:='Being amount auto credited against Incentive charges';
        else
            v_remark:=premark;
        end if;     


        Begin
            select max(to_number(substr(recptno,-8)))+1 into v_rec_no from cir_rcphdr 
                where comp_code=v2.comp_code  and doctype=v_doctype and to_char(recptdt,'yymm')=to_char(v_recptdt,'yymm') and 
                    branch_code=v_bran_code;
            Exception When Others Then
                v_rec_no:=null;
        End;
        
        If nvl(v_rec_no,0)=0 Then
          v_recptno:=v_bran_code||'-'||to_char(v_recptdt,'yymm')||'0001';
        Else
          v_recptno:=v_bran_code||'-'||lpad(v_rec_no,8,'0');
        End if;
    
          insert into cir_rcphdr(comp_code,unit_code,agcd,dpcd,doctype,
                                 recptno,recptdt,amount,reason,remark,
                                 achd,voucherno,voucherdt,userid,creation_date,branch_code)
                          values(v2.comp_code, v2.unit_code,v2.bilagcd, v2.bildpcd,v2.doctype,
                                 v_recptno,v2.recptdt,v_amt,nvl(preason,'INCENTIVE CHARGES'),v_remark,
                                 'NM',v_recptno,v2.recptdt,puserid,sysdate,v_bran_code);
          insert into cir_rcpdet(comp_code,unit_code,agcd,dpcd,doctyp,publ,
                                 recptno,recptdt,payfor,achd,amount,
                                 reason,remark,voucherno,voucherdt,usrid,
                                 creation_date,branch_code)
                          values(v2.comp_code, v2.unit_code,v2.bilagcd, v2.bildpcd,v2.doctype,v2.publ_code,
                                 v_recptno,v2.recptdt,v2.unit_code,'NM',v_amt,
                                 nvl(preason,'INCENTIVE CHARGES'),v_remark,v_recptno,v2.recptdt,puserid,
                                 sysdate,v_bran_code);
          insert into cir_outmast(comp_code,unit_code,agcd,dpcd,doctyp,publ,
                                  recptno,recptdt,achd,amount,reason,
                                  remark,voucherno,voucherdt,usrid,creation_date,branch_code)
                           values(v2.comp_code, v2.unit_code,v2.bilagcd, v2.bildpcd,v2.doctype,v2.publ_code,
                                  v_recptno,v2.recptdt,'NM',v_amt,nvl(preason,'INCENTIVE CHARGES'),
                                  v_remark,v_recptno,v2.recptdt,puserid,sysdate,v_bran_code);                               
        
          update cir_inct_process_det set recptno=v_recptno
            where comp_code=v2.comp_code and unit_code=v2.unit_code and doctype=v2.doctype and recptno=recptno and 
                  recptdt=v2.recptdt and from_pdate = v_frdt and till_pdate = v_todt and bilagcd = v2.bilagcd and bildpcd = v2.bildpcd and 
                  publ_code=v2.publ_code and tran_type='INC';
    
        delete from cir_inct_process_det_temp        
            where comp_code=v2.comp_code and unit_code=v2.unit_code and doctype=v2.doctype and recptno=recptno and 
                  recptdt=v2.recptdt and from_pdate = v_frdt and till_pdate = v_todt and bilagcd = v2.bilagcd and bildpcd = v2.bildpcd and 
                  publ_code=v2.publ_code and tran_type='INC';                  
    end loop;
    close c2;
    delete from cir_inct_process_det_temp where comp_code=pcompcode and unit_code=punitcode and 
            bilagcd=pagcode and bildpcd= pdepocode and recptno=precptno and recptdt=v_recptdt and 
            publ_code=ppublcode and tran_type='INC';
    commit;
            
    open P_Accounts for
    select sysdate as "CUR_DATE" from dual;
   
  End cir_incentive_cn_process_p;
/
/////////////////////

CREATE OR REPLACE procedure cir_fetch_incentive_rate(
    pcompcode       in varchar2,
    punitcode       in varchar2,
    ppublcode       in varchar2,
    psupply_type    in varchar2,
    pagency_type    in varchar2,
    pinct_type      in varchar2,
    pfreg_type      in varchar2,   
    pchkdate        in varchar2, 
    puserid         in varchar2, 
    pdateformate    in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    pextra3         in varchar2,
    pextra4         in varchar2,
    pextra5         in varchar2,
    pextra6         in varchar2,
    pextra7         in varchar2,
    pextra8         in varchar2,
    pextra9         in varchar2,
    pextra10        in varchar2,
    p_accounts      OUT Cur_Type_New1.cursor_type,
    p_accounts1      OUT Cur_Type_New1.cursor_type,
    p_accounts2     OUT Cur_Type_New1.cursor_type)
is
    v_from_date     date;
    v_till_date     date;
    v_dt            date;
    v_day           varchar2(20);
    v_flg           varchar2(1):='N';
    v_recno         number;
    cursor c1 is
    select d.comp_code comp_code,d.unit_code unit_code,d.publ_code publ_code,p.publ_name publ_name,
    e.main_edtn main_edtn,cir_get_edtn_name(d.comp_code,e.main_edtn) main_edtn_name,d.edtn_code edtn,e.edtn_name edtn_name,
    d.supply_type supply_type,s.sup_ty_name sup_ty_name,d.calc_type calc_type,
    d.supply_from supply_from,d.supply_till supply_till,
    max(d.eff_date) valid_from,d.inct_amt inct_amt,d.branch_code branch_code, d.agency_type agency_type,d.reason reason
    from cir_publ_mast p,cir_edtn_mast e,cir_inct_slab_det d,cir_supply_type_mast s 
    where p.comp_code=e.comp_code and p.comp_code=d.comp_code and p.comp_code=s.comp_code and p.comp_code=pcompcode and
    p.publ=e.publ and p.publ=d.publ_code 
    and (p.publ=ppublcode or ppublcode is null)
    and  (d.unit_code=punitcode or punitcode is null) 
    and e.edtn=d.edtn_code 
    and d.supply_type=s.sup_ty_code 
    and    d.supply_type=s.sup_ty_code 
    and (d.supply_type=psupply_type or psupply_type is null) 
    and   (d.agency_type=pagency_type or pagency_type is null)
    group by d.comp_code,d.unit_code,d.publ_code,p.publ_name,e.main_edtn,edtn_code,e.edtn_name,d.supply_type,
    s.sup_ty_name,d.calc_type,d.supply_from,d.supply_till,d.inct_amt,d.branch_code,d.agency_type,d.reason;

    v1 c1%rowtype;
    v_process_id    number;
begin
    v_from_date:=to_date(pchkdate,''''||pdateformate||'''');
    
    v_process_id:=cir_generate_processid(pcompcode,puserid,pdateformate,null,null,null,null,null);
    
    delete from cir_temp_bill_collection where cur_sessionid=v_process_id;COMMIT;    
    open c1;
    loop
        fetch c1 into v1;
        exit when c1%notfound;
        v_dt:=v_from_date;

        insert into cir_temp_bill_collection
            (comp_code, unit_code, billno,publ_code, agcd, dpcd,agname,agname_oth_lang, 
            city_code, state_code,taluka_code,dist_code,
            billdt,supply_copy,return_copy,comm_amt,remarks,cur_sessionid)
        values(v1.comp_code,v1.unit_code,v1.publ_code,v1.publ_name,v1.main_edtn,v1.edtn,v1.main_edtn_name,v1.edtn_name,
            v1.supply_type,v1.sup_ty_name,v1.branch_code,v1.agency_type,
            v_dt,v1.supply_from,v1.supply_till,v1.inct_amt,v1.calc_type,v_process_id);
 
    end loop;
    close c1;
    COMMIT;
    
    open p_accounts for select 0 as "PROCESS_ID" from dual;
    
    open p_accounts1 for 
    select comp_code AS "COMP_CODE", unit_code AS "UNIT_CODE", billno as "PUBL_CODE",publ_code AS "PUBL_NAME", agcd AS "MAIN_EDTN", dpcd AS "EDTN",
    agname AS "MAIN_EDTN_NAME",agname_oth_lang AS "EDTN_NAME", city_code AS "SUPPLY_TYPE", STATE_code AS "SUPPLY_TYPE_NAME",
    taluka_code as "BRANCH_CODE",dist_code AS "AGENCY_TYPE", 
    billdt AS "SUPDATE" ,comm_amt AS "INCT_AMT" ,REMARKS AS "CALC_TYPE",cur_sessionid as "PROCESSNO",
    supply_copy as "SUPPLY_FROM",return_copy as "SUPPLY_TILL",v_process_id as "PROCESSID",'RA0' as "REASON"
    from cir_temp_bill_collection  where cur_sessionid=v_process_id;
    
    open p_accounts2 for select sysdate as "CUR_DATE" from dual;
    
    delete from cir_temp_bill_collection where cur_sessionid=v_process_id;COMMIT;
    
End cir_fetch_incentive_rate;
/
CREATE OR REPLACE function cir_generate_processid(
    pcomp_code 	    in  varchar2,
    puserid         in  varchar2,
    pdateformat     in  varchar2,
    pextra1         in  varchar2,
    pextra2         in  varchar2,
    pextra3         in  varchar2,
    pextra4         in  varchar2,
    pextra5         in  varchar2) return varchar2 is

    v_id number(30);
Begin
	select nvl(max(process_id),0)+1 into v_id from cir_process_id;
	
	return v_id;
End	cir_generate_processid;
/



/***********************mimoh 14-dec 2011*********************************billing****************/

CREATE OR REPLACE PACKAGE cir_Publ_bind is
   type t_accounts_cursor is ref cursor;
   procedure cir_publ_bind_p (
       pcomp_code in varchar2,
       pdateformat in varchar2,
       pextra1 in varchar2,
       pextra2 in varchar2,
       p_accounts out t_accounts_cursor);
   procedure cir_publ_bind_p (
       pcomp_code in varchar2,
       ppubl_code in varchar2,
       pdateformat in varchar2,
       pextra1 in varchar2,
       pextra2 in varchar2,
       p_accounts out t_accounts_cursor);
End cir_publ_bind;
/





CREATE OR REPLACE PACKAGE BODY cir_publ_bind is
   procedure cir_publ_bind_p (
     pcomp_code in varchar2,
     pdateformat in varchar2,
     pextra1 in varchar2,
     pextra2 in varchar2,
     p_accounts out t_accounts_cursor) as
   Begin
      open p_accounts for
         select * from cir_publ_mast
                 where comp_code = pcomp_code and
                       ((upper(publ_name) like upper(pextra1)||'%') or (pextra1 is null)) 
                       
                       and(PUBL =pextra2 or  pextra2 is null)
                     
                       --nvl(freeze_flag,'N')='N' 
                 order by publ_name;
   End cir_publ_bind_p;
   procedure cir_publ_bind_p (
   	pcomp_code  in varchar2,
   	ppubl_code  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,--for publication type
   	p_accounts  out t_accounts_cursor) as
   Begin
      open p_accounts for
         select cir_publ_mast.*,cir_get_publ_type(cir_publ_mast.comp_code,cir_publ_mast.publ,null,null) as "PUBL_TYPE_NAME" 
         from cir_publ_mast
                 where comp_code = pcomp_code and 
                       (publ=ppubl_code or ppubl_code is null) and
                       ((upper(publ_name) like upper(pextra1)||'%') or (pextra1 is null)) 
                       AND (upper(pro_type)=pextra2 or pextra2 is null or pextra2='')
                 order by publ_name;
   End cir_publ_bind_p;
End cir_publ_bind;
/

/***********************mimoh 14-dec 2011*********************************billing****************/

/**********************14-dec-2011 Laxman *****************************/

CREATE OR REPLACE FUNCTION cir_get_agency_opening(
    pcomp_code  in  varchar2,
    punit_code  in  varchar2,
    ppubl_code  in  varchar2,
    pagcd       in  varchar2,
    pdpcd       in  varchar2,
    pason_date  in  varchar2,
    pac_type    in  varchar2,
    pdateformat in  varchar2,
    puserid     in  varchar2,
    pextra1     in  varchar2,
    pextra2     in  varchar2) return number is

    v_findt     date;
    v_ason      date;
    v_opbal     number(15,2);
    v_amt       number(15,2);
Begin
    v_ason      :=to_date(pason_date,''''||pdateformat||'''');        
    v_findt     :=cir_get_finandt(pcomp_code,to_date(pason_date,''''||pdateformat||''''),pdateformat,'','');--for financial date
    
    v_opbal     :=cir_accounts.cir_agency_opbal(pcomp_code,punit_code,ppubl_code,pagcd,pdpcd,v_findt,pac_type,pdateformat,null,null);
    
    v_amt       :=cir_accounts.cir_agency_ytodt(pcomp_code,punit_code,ppubl_code,pagcd,pdpcd,v_findt,v_ason+1,pac_type,pdateformat,null,null);
    
    return nvl(v_opbal,0)+nvl(v_amt,0);
End cir_get_agency_opening;


CREATE OR REPLACE PACKAGE cir_execute_unsoldapr_per IS
Type T_Accounts_Cursor Is Ref Cursor;
  PROCEDURE cir_execute_unsoldapr_per_P(

    loginid            in varchar2,  
    P_Accounts Out T_Accounts_Cursor);
END cir_execute_unsoldapr_per;
/
CREATE OR REPLACE PACKAGE BODY cir_execute_unsoldapr_per IS
  PROCEDURE cir_execute_unsoldapr_per_P(

    loginid            in varchar2,    
    P_Accounts Out T_Accounts_Cursor) as
    
begin    
    open P_Accounts for
    select distinct a.user_id user_id,b."username" as "USERNAME" 
    from cir_unsold_apr_permission a,login b 
    where a.user_id=b."userid" and (a.USER_ID=loginid OR loginid IS NULL);   

End cir_execute_unsoldapr_per_P;
END cir_execute_unsoldapr_per;

/**********************14-dec-2011 Laxman *****************************/
////////////////////////////////////14-dec-2011****************

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

////////////////////////////////////////////////////////////////////


/***********************mimoh 14-dec-2011*********************************5933****************/


CREATE OR REPLACE PACKAGE Wesp_Updatedate
IS
PROCEDURE      Wesp_Updatedate_p(
compcode IN VARCHAR2,
userid IN VARCHAR2,
dateformat IN VARCHAR2,
code IN VARCHAR2,
curr IN VARCHAR2,
RATECODE11 IN VARCHAR2,
solo  IN VARCHAR2,
breakup VARCHAR2,
bwcode IN VARCHAR2,
rostatus IN VARCHAR2,
filename IN VARCHAR2,
tfn IN NUMBER,
insertbreak IN VARCHAR2,
prem IN VARCHAR2,
dealtype IN VARCHAR2,
pre IN VARCHAR2,
suff IN VARCHAR2,
financestatus IN  VARCHAR2,
voucherst IN VARCHAR2,
adcode IN VARCHAR2,
rodatetime IN VARCHAR2,
spacearea IN VARCHAR2,
vat IN VARCHAR2,
bookstat IN VARCHAR2,
cio_id IN VARCHAR2,
receipt_no IN VARCHAR2,
uom IN VARCHAR2,
bgcolor IN VARCHAR2,
validdate IN VARCHAR2,
agencyratecode IN VARCHAR2,
AUDIT1 IN VARCHAR2,
book_insert_date IN VARCHAR2,
agencycomm IN VARCHAR2,
rateaudit IN VARCHAR2,
billaudit IN VARCHAR2,
bill_type IN VARCHAR2,
invoice_no1 IN VARCHAR2,
copybooking IN VARCHAR2,
ratecompany IN VARCHAR2,
addagenycomm IN VARCHAR2,
agencycommlinkretainer IN VARCHAR2,
subeditionr IN VARCHAR2,
displaybilltype IN VARCHAR2,
classifiedbilltype IN VARCHAR2,
billformat IN VARCHAR2,
ratechk IN VARCHAR2,
allpkg IN VARCHAR2,
dayrate1 in varchar2,
schemetype in varchar2,
PIncludeclassi in varchar2,
receiptformat IN VARCHAR2,
v_cash_receipt in varchar2,
v_bill_orderwiselast in varchar2,
v_floor_chk in varchar2,
Unsoldflag in varchar2,
Supplystopper in  number,
drpRokeychk in varchar2,
Agencycomm_seq in varchar2,
creditreciept in varchar,
cashindisplay IN VARCHAR,
cashinclassified IN VARCHAR,
v_rate_audit_pref in varchar,
v_barcoding_allow_pref in varchar2,
v_fmgbills IN VARCHAR2,
v_billed_cashdis in varchar2,
v_billed_cashcls in varchar,
v_drpbackdate in varchar,
dockitbooking in varchar2,
allowprevbooking in varchar2,
ro_wisecashbill in varchar2,
chkval in varchar2,
approval1 in varchar2,
pckstatus in varchar2,
cash_disc in varchar2,
cash_amt in varchar2,
seperate_cashier1 in varchar2,
disp_bill in varchar2,
clas_bill in varchar2,
mantimepost in varchar2,
bkdaypost in number,
maxterutn in number,
cir_return in varchar2,
noofchkbounc in number,
noofdaychkrec in number,
retday in number,
chngsuppord in number,
max_publishday in number,
p_billno_period in varchar,
spl_trans_edit in varchar2,
spl_dis_trans_editable in varchar2,
mul_pac_sel_trans in varchar2,
shmon_minword in varchar2,
tradon_spcrg in varchar2,
rateauth     in varchar2,
f2day in number,
rateauditmodify in varchar,
bindrevenuecenter in varchar,
p_led_allow in varchar,
p_clear_allow in varchar,
repeatday in varchar,
premiumedit in varchar,
P_BILL_GENERATION in varchar,
P_PUBLICATION_CENTER in varchar,
P_allow_discount_prem IN VARCHAR,
P_SCHEME_BILLING in varchar,
P_ALLOW_PDC in varchar,
PAD_TYPE_FOR_MANUL_BILL in varchar,
RO_OUTSTAND_P IN VARCHAR2,
genrate_agency_code IN VARCHAR2,
p_dispauditbk IN VARCHAR2,
p_aotosupply  IN VARCHAR2,
p_Authorization IN VARCHAR2,
p_CIR_AUTO_APPROVAL_UNSOLD IN VARCHAR2,
p_CIR_AUTO_PHYSICAL_UNSOLD IN VARCHAR2,
p_CIR_UNSOLD_INCLUDE_INCT IN VARCHAR2,
p_CIR_UNSOLD_INCLUDE_INSFEE IN VARCHAR2,
p_CIR_UNSOLD_ON_RECEIVED_DT IN VARCHAR2,
p_AGENCY_UNBLOCK_APROV IN VARCHAR2,
p_UNBLOCK_APROV_OUT_LMT IN VARCHAR2,
p_CIR_BILL_PUBLWISE IN VARCHAR2

);
END      Wesp_Updatedate;
/





CREATE OR REPLACE PACKAGE BODY Wesp_Updatedate IS
PROCEDURE      Wesp_Updatedate_p(
compcode IN VARCHAR2,
userid IN VARCHAR2,
dateformat IN VARCHAR2,
code IN VARCHAR2,
curr IN VARCHAR2,
RATECODE11 IN VARCHAR2,
solo  IN VARCHAR2,
breakup VARCHAR2,
bwcode IN VARCHAR2,
rostatus IN VARCHAR2,
filename IN VARCHAR2,
tfn IN NUMBER,
insertbreak IN VARCHAR2,
prem IN VARCHAR2,
dealtype IN VARCHAR2,
pre IN VARCHAR2,
suff IN VARCHAR2,
financestatus IN  VARCHAR2,
voucherst IN VARCHAR2,
adcode IN VARCHAR2,
rodatetime IN VARCHAR2,
spacearea IN VARCHAR2,
vat IN VARCHAR2,
bookstat IN VARCHAR2,
cio_id IN VARCHAR2,
receipt_no IN VARCHAR2,
uom IN VARCHAR2,
bgcolor IN VARCHAR2,
validdate IN VARCHAR2,
agencyratecode IN VARCHAR2,
AUDIT1 IN VARCHAR2,
book_insert_date IN VARCHAR2,
agencycomm IN VARCHAR2,
rateaudit IN VARCHAR2,
billaudit IN VARCHAR2,
bill_type IN VARCHAR2,
invoice_no1 IN VARCHAR2,
copybooking IN VARCHAR2,
ratecompany IN VARCHAR2,
addagenycomm IN VARCHAR2,
agencycommlinkretainer IN VARCHAR2,
subeditionr IN VARCHAR2,
displaybilltype IN VARCHAR2,
classifiedbilltype IN VARCHAR2,
billformat IN VARCHAR2,
ratechk IN VARCHAR2,
allpkg IN VARCHAR2,
dayrate1 in varchar2,
schemetype in varchar2,
PIncludeclassi in varchar2,
receiptformat IN VARCHAR2,
v_cash_receipt in varchar2,
v_bill_orderwiselast in varchar2,
v_floor_chk in varchar2,
Unsoldflag in varchar2,
Supplystopper in  number,
drpRokeychk in varchar2,
Agencycomm_seq in varchar2,
creditreciept in varchar,
cashindisplay IN VARCHAR,
cashinclassified IN VARCHAR,
v_rate_audit_pref in varchar,
v_barcoding_allow_pref in varchar2,
v_fmgbills IN VARCHAR2,
v_billed_cashdis in varchar2,
v_billed_cashcls in varchar,
v_drpbackdate in varchar,
dockitbooking in varchar2,
allowprevbooking in varchar2,
ro_wisecashbill in varchar2,
chkval in varchar2,
approval1 in varchar2,
pckstatus in varchar2,
cash_disc in varchar2,
cash_amt in varchar2,
seperate_cashier1 in varchar2,
disp_bill in varchar2,
clas_bill in varchar2,
mantimepost in varchar2,
bkdaypost in number,
maxterutn in number,
cir_return in varchar2,
noofchkbounc in number,
noofdaychkrec in number,
retday in number,
chngsuppord in number,
max_publishday in number,
p_billno_period in varchar,
spl_trans_edit in varchar2,
spl_dis_trans_editable in varchar2,
mul_pac_sel_trans in varchar2,
shmon_minword in varchar2,
tradon_spcrg in varchar2,
rateauth     in varchar2,
f2day in number,
rateauditmodify in varchar,
bindrevenuecenter in varchar,
p_led_allow in varchar,
p_clear_allow in varchar,
repeatday in varchar,
premiumedit in varchar,
P_BILL_GENERATION in varchar,
P_PUBLICATION_CENTER in varchar,
P_allow_discount_prem IN VARCHAR,
P_SCHEME_BILLING in varchar,
P_ALLOW_PDC in varchar,
PAD_TYPE_FOR_MANUL_BILL in varchar,
RO_OUTSTAND_P IN VARCHAR2,
genrate_agency_code IN VARCHAR2,
p_dispauditbk IN VARCHAR2,
p_aotosupply  IN VARCHAR2,
p_Authorization IN VARCHAR2,
p_CIR_AUTO_APPROVAL_UNSOLD IN VARCHAR2,
p_CIR_AUTO_PHYSICAL_UNSOLD IN VARCHAR2,
p_CIR_UNSOLD_INCLUDE_INCT IN VARCHAR2,
p_CIR_UNSOLD_INCLUDE_INSFEE IN VARCHAR2,
p_CIR_UNSOLD_ON_RECEIVED_DT IN VARCHAR2,
p_AGENCY_UNBLOCK_APROV IN VARCHAR2,
p_UNBLOCK_APROV_OUT_LMT IN VARCHAR2,
p_CIR_BILL_PUBLWISE IN VARCHAR2


)AS
BEGIN
UPDATE LOGIN SET "date_format"=dateformat, "Autogenerate"=code,"curr_code"=curr WHERE "COM_CODE"=compcode;
COMMIT;
        UPDATE PREFERRENCES SET  "autogenerated"=code,
"currency_code"=curr ,
"rate_gr_code"=RATECODE11,
"date_format"=dateformat,"solo"=solo,"breakup"=breakup,
"blackwhitecode"=bwcode,"rostatus"=rostatus,"File_name"=filename,"Tfn"=tfn,
"Insert_breakup"=insertbreak,"Premium_type"=prem,"Deal_type"=dealtype  ,
 "prefix"=pre, "suffix"=suff, "financestatus"=financestatus , "voucherst"=voucherst,
 "Ad_category"=adcode ,"Ro_datetime"=rodatetime ,"Space_area"=spacearea,"Vat"=vat,
 "Booking_status"=bookstat,"Cio_id"=cio_id,"Receipt_no"=receipt_no,"uom_code"=uom,
 "Bgcolor_publication"=bgcolor ,"chkfor_valid_pubdates"=validdate, "Agency_ratecode"=agencyratecode,
  "audit"=AUDIT1,"book_insert_date"=book_insert_date,"agencycomm"=agencycomm,
  "rate_audit"=rateaudit,"bill_audit"=billaudit,"billtype"=bill_type,"invoice_no"=invoice_no1,
  "copy_booking"=copybooking,"RATE_COMPANY_AGENCY"=ratecompany, "ADDITIONAL_AGENCY_COMM"=addagenycomm ,
  "AGENCY_RETAINER_COMM"=agencycommlinkretainer,"SUBEDITIONRATE"=subeditionr,
  "CLS_BILLTYPE"=classifiedbilltype,"DIS_BILLTYPE"=displaybilltype,"BILLING_FORMAT"=billformat,
  "RATE_CHECK"=ratechk,"ALL_PACKAGE"=allpkg,"DAYRATE"=dayrate1,"SCHEME_TYPE"=schemetype,"DISP_CLSBILL"=PIncludeclassi   ,
  "CASH_RECEIPT_BILL"=v_cash_receipt, "BILL_ORDERWSLAST"=v_bill_orderwiselast, "FLOOR_CHK"=v_floor_chk ,
  "UNSOLD_ENTRY_FLAG"=Unsoldflag ,"SUPPLY_STOP_PERCENTAGE"=Supplystopper,"ROKEYCHECK"=drpRokeychk ,
  "AGENCYCOMM_SEQ_COM"=Agencycomm_seq ,"CREDIT_RECIPT"=creditreciept,"DISP_CASHBILL"=cashindisplay,
  "CLA_CASHBILL"=cashinclassified,"RATE_AUDIT_PREF"=v_rate_audit_pref,"BARCODING_ALLOWED"=v_barcoding_allow_pref,
  "FMG_BILL_DIS" =v_fmgbills, "BILL_DISP_CASHBILL"=v_billed_cashdis , "BILL_CLA_CASHBILL"=v_billed_cashcls,"BACKDATERECEIPT"=v_drpbackdate,"DOCKIT_BOOKING"=dockitbooking,"Allowed_old_date"=allowprevbooking,"ROWISE_CASHBOOKING"=ro_wisecashbill,"CUTOFFTIME"=chkval,"APPROVAL"=approval1,"BACK_DAYS"=pckstatus ,CASH_DISCOUNT=cash_amt,CASH_DISCOUNTTYPE=cash_disc,SEPRATE_CASHIER=seperate_cashier1,
   CIR_MANY_TIME_POSTING=mantimepost, CIR_BACKDAYS_POSTING=bkdaypost, CIR_MAX_RETURN_ALLOW=maxterutn, CIR_RETURN_LIMIT_ALLOW=cir_return, CIR_NO_OF_CHQBOUNCE=noofchkbounc, CIR_DAYS_CHQBOUNCE=noofdaychkrec, CIR_RETURN_DAYS=retday, CIR_SUP_ORDER_LIMIT=chngsuppord, DISP_BILLING_CRITERIA=disp_bill, CLSD_BILLING_CRITERIA=clas_bill,MAX_PUBLISHDAYS=max_publishday,BILLNO_PERIODICITY=p_billno_period,
   SPECIALDISC_TRANS_EDIT=spl_trans_edit, SHARING_TRANS=spl_dis_trans_editable, MULTIPACKAGE_SEL_TRANS=mul_pac_sel_trans,SCHEME_MINWORD=shmon_minword, TRADE_SPLCHARGE=tradon_spcrg,RATE_AUTHORIZATION=rateauth
  ,F2_RECORD=f2day,PUBLISHAD_EDIT_RATEAUDIT=rateauditmodify,BINDREVENUE_CENTER=bindrevenuecenter,  
  FA_LEDGER_ALLOW=p_led_allow ,CLEARANCE_TYPE_ALLOW=p_clear_allow,REPEAT_DAY_TYPE=repeatday,PREMIUM_EDIT=premiumedit,
BILL_GENERATION_PRIOR=P_BILL_GENERATION,PUBLICATION_HO=P_PUBLICATION_CENTER,SPLDISC_ALLOWPREM=P_allow_discount_prem,

BILL_SCHEME=P_SCHEME_BILLING,ALLOWED_PDC_DAYS_RECEIPT=P_ALLOW_PDC ,AD_TYPE_MANUL_BILL=PAD_TYPE_FOR_MANUL_BILL,OUTSTANDING_AMT_CRITERIA=RO_OUTSTAND_P,GENRATE_CIR_AGCD=genrate_agency_code,DISP_AUDITBKG=p_dispauditbk,CIR_DIS_AUTO_POSTING=p_aotosupply,RELAUTHREQON=p_Authorization,
CIR_AUTO_APPROVAL_UNSOLD=p_CIR_AUTO_APPROVAL_UNSOLD,CIR_AUTO_PHYSICAL_UNSOLD=p_CIR_AUTO_PHYSICAL_UNSOLD,CIR_UNSOLD_INCLUDE_INCT=p_CIR_UNSOLD_INCLUDE_INCT,
CIR_UNSOLD_INCLUDE_INSFEE=p_CIR_UNSOLD_INCLUDE_INSFEE,CIR_UNSOLD_ON_RECEIVED_DT=p_CIR_UNSOLD_ON_RECEIVED_DT,
AGENCY_UNBLOCK_APPROVAL=p_AGENCY_UNBLOCK_APROV,UNBLOCK_APPROVAL_OUTSIDE_LIMIT=p_UNBLOCK_APROV_OUT_LMT,CIR_BILL_PUBLWISE=p_CIR_BILL_PUBLWISE


  
   WHERE "comp_code"=compcode;
COMMIT;
END      Wesp_Updatedate_p;
END      Wesp_Updatedate;
/






/******************************************************************************************************************/



CREATE OR REPLACE PACKAGE Currbindpreferpgld
IS
   TYPE t_account_cursor IS REF CURSOR;

   PROCEDURE currbindpreferpgld_p (
      compcode     IN       VARCHAR2,
      p_accounts   OUT      t_account_cursor
   );
END Currbindpreferpgld;
/





CREATE OR REPLACE PACKAGE BODY Currbindpreferpgld
IS
   PROCEDURE currbindpreferpgld_p (
      compcode     IN       VARCHAR2,
      p_accounts   OUT      t_account_cursor
   )
   AS
   BEGIN
      OPEN p_accounts FOR
         SELECT "date_format", "autogenerated", "currency_code",
                "rate_gr_code", "solo", "breakup", "blackwhitecode",
                "rostatus", "File_name", "Tfn", "Insert_breakup", "prefix",
                "suffix", "financestatus", "voucherst", "Ad_category",
                "Ro_datetime", "Vat", "Booking_status", "Cio_id",
                "Receipt_no","uom_code","Bgcolor_publication","chkfor_valid_pubdates","Agency_ratecode","audit","book_insert_date","agencycomm",
                "rate_audit","bill_audit","billtype","Premium_type","copy_booking","RATE_COMPANY_AGENCY","ADDITIONAL_AGENCY_COMM","AGENCY_RETAINER_COMM","SUBEDITIONRATE",CLS_BILLTYPE,DIS_BILLTYPE,
                "BILLING_FORMAT","RATE_CHECK","ALL_PACKAGE",dayrate,SCHEME_TYPE,DISP_CLSBILL,RECEIPT_FORMAT,CASH_RECEIPT_BILL, BILL_ORDERWSLAST, FLOOR_CHK,
                ROKEYCHECK, AGENCYCOMM_SEQ_COM, CREDIT_RECIPT,  DISP_CASHBILL, CLA_CASHBILL,
                RATE_AUDIT_PREF,BARCODING_ALLOWED, FMG_BILL_DIS,BILL_DISP_CASHBILL, BILL_CLA_CASHBILL,BACKDATERECEIPT,ROWISE_CASHBOOKING,CUTOFFTIME,DOCKIT_BOOKING,APPROVAL,BACK_DAYS,CASH_DISCOUNT,CASH_DISCOUNTTYPE,"Allowed_old_date",SEPRATE_CASHIER,
                CIR_MANY_TIME_POSTING, CIR_BACKDAYS_POSTING, CIR_MAX_RETURN_ALLOW, CIR_RETURN_LIMIT_ALLOW, CIR_NO_OF_CHQBOUNCE, CIR_DAYS_CHQBOUNCE, CIR_RETURN_DAYS, CIR_SUP_ORDER_LIMIT, DISP_BILLING_CRITERIA, CLSD_BILLING_CRITERIA,MAX_PUBLISHDAYS,
                BILLNO_PERIODICITY, SPECIALDISC_TRANS_EDIT, SHARING_TRANS, MULTIPACKAGE_SEL_TRANS,SCHEME_MINWORD, TRADE_SPLCHARGE,RATE_AUTHORIZATION,
           F2_RECORD,PUBLISHAD_EDIT_RATEAUDIT,BINDREVENUE_CENTER, FA_LEDGER_ALLOW,CLEARANCE_TYPE_ALLOW,REPEAT_DAY_TYPE,PREMIUM_EDIT,
           
           BILL_GENERATION_PRIOR,PUBLICATION_HO,SPLDISC_ALLOWPREM,BILL_SCHEME,ALLOWED_PDC_DAYS_RECEIPT,
           AD_TYPE_MANUL_BILL,OUTSTANDING_AMT_CRITERIA as RO_OUTSTAND,GENRATE_CIR_AGCD,DISP_AUDITBKG,CIR_DIS_AUTO_POSTING,RELAUTHREQON,
        CIR_AUTO_APPROVAL_UNSOLD, CIR_AUTO_PHYSICAL_UNSOLD, CIR_UNSOLD_INCLUDE_INCT, CIR_UNSOLD_INCLUDE_INSFEE, CIR_UNSOLD_ON_RECEIVED_DT,
        AGENCY_UNBLOCK_APPROVAL,UNBLOCK_APPROVAL_OUTSIDE_LIMIT,CIR_BILL_PUBLWISE   
            FROM PREFERRENCES
          WHERE "comp_code" = compcode;
          
         
   END currbindpreferpgld_p;
END Currbindpreferpgld;
/



























/***********************mimoh 14-dec-2011*********************************5933****************/


/*********************** 5886 *************************/


CREATE OR REPLACE PACKAGE cir_exe_unsold_apr_grid IS
Type T_Accounts_Cursor Is Ref Cursor;
  PROCEDURE cir_exe_unsold_apr_grid_P(

    loginid            in varchar2,  
    P_Accounts Out T_Accounts_Cursor,
    P_Accounts1 Out T_Accounts_Cursor,
    P_Accounts2 Out T_Accounts_Cursor,
    P_Accounts3 Out T_Accounts_Cursor,
    P_Accounts4 Out T_Accounts_Cursor);
END cir_exe_unsold_apr_grid;
/



CREATE OR REPLACE PACKAGE BODY cir_exe_unsold_apr_grid
IS
   PROCEDURE cir_exe_unsold_apr_grid_p (
      loginid       IN       VARCHAR2,
      p_accounts    OUT      t_accounts_cursor,
      p_accounts1   OUT      t_accounts_cursor,
      p_accounts2   OUT      t_accounts_cursor,
      p_accounts3   OUT      t_accounts_cursor,
      p_accounts4   OUT      t_accounts_cursor
   )
   AS
   BEGIN
      OPEN p_accounts FOR
         SELECT *
           FROM cir_unsold_apr_permission
          WHERE (user_id = loginid OR loginid IS NULL);

      OPEN p_accounts1 FOR
         SELECT   "Branch_Code", "Branch_Name"
             FROM branch_mst
         ORDER BY "Branch_Name";

      OPEN p_accounts2 FOR
         SELECT   "Comp_Code", "Comp_Name"
             FROM comp_mst
         ORDER BY "Comp_Name";

      OPEN p_accounts3 FOR
         SELECT   "doc_type", "doc_Name"
             FROM fa_docmst
            WHERE "doc_type" IN ('RCR', 'DN', 'CN')
         ORDER BY "doc_Name";

      OPEN p_accounts4 FOR
         SELECT MAX (insert_id) insert_id
           FROM cir_unsold_apr_permission
          WHERE (user_id = loginid OR loginid IS NULL);
   END cir_exe_unsold_apr_grid_p;
END cir_exe_unsold_apr_grid;
/


/************************for login********************//

CREATE OR REPLACE PACKAGE cir_execute_unsoldapr_per IS
Type T_Accounts_Cursor Is Ref Cursor;
  PROCEDURE cir_execute_unsoldapr_per_P(

    loginid            in varchar2,  
    P_Accounts Out T_Accounts_Cursor);
END cir_execute_unsoldapr_per;
/


CREATE OR REPLACE PACKAGE BODY cir_execute_unsoldapr_per IS
  PROCEDURE cir_execute_unsoldapr_per_P(

    loginid            in varchar2,    
    P_Accounts Out T_Accounts_Cursor) as
    
begin    
    open P_Accounts for
    select distinct a.user_id user_id,b."username" as "USERNAME" 
    from cir_unsold_apr_permission a,login b 
    where a.user_id=b."userid" and (a.USER_ID=loginid OR loginid IS NULL);   

End cir_execute_unsoldapr_per_P;
END cir_execute_unsoldapr_per;
/

/************************************login bind**************/

CREATE OR REPLACE PACKAGE cir_login_bind IS
  type t_accounts_type is ref cursor;
  procedure cir_login_bind_p(
    plogin_code in varchar2,
    pdateformat in varchar2,
    pextra1 		in varchar2,
    pextra2 		in varchar2,
    p_accounts out t_accounts_type);
END cir_login_bind;
/

CREATE OR REPLACE PACKAGE BODY cir_login_bind IS
  procedure cir_login_bind_p(
    plogin_code in varchar2,
    pdateformat in varchar2,
    pextra1 		in varchar2,
    pextra2 		in varchar2,
    p_accounts out t_accounts_type)
  As
  Begin
   	open p_accounts for
   	select * from login where ("userid"=plogin_code or plogin_code is null)  
    and ("username" like pextra1 || '%'  or pextra1 is null) order by "username";
  End cir_login_bind_p;
END cir_login_bind;
/


/********************************for unit******************/

CREATE OR REPLACE PACKAGE cir_unit_doc_com_bind IS
  TYPE T_ACCOUNTS_CURSOR IS REF CURSOR;
  PROCEDURE cir_unit_doc_com_bind_P(PCOMPCODE IN VARCHAR2,P_ACCOUNTS OUT T_ACCOUNTS_CURSOR,P_ACCOUNTS1 OUT T_ACCOUNTS_CURSOR,P_ACCOUNTS2 OUT T_ACCOUNTS_CURSOR);
END;
/

CREATE OR REPLACE PACKAGE BODY cir_unit_doc_com_bind IS
  procedure cir_unit_doc_com_bind_p(pcompcode in varchar2,p_accounts out t_accounts_cursor,p_accounts1 out t_accounts_cursor,p_accounts2 out t_accounts_cursor)  AS
  Begin
     open p_accounts for
                select  "Branch_Code","Branch_Name" from branch_mst order by  "Branch_Name";

            open p_accounts1 for
                select  "Comp_Code","Comp_Name" from comp_mst order by "Comp_Name";
                
                open p_accounts2 for
              --  select  "doc_type","doc_Name" from fa_docmst where "doc_type" in ('RCR','DN','CN') order by "doc_Name";
              select  DOC_TYPE "doc_type",DOC_NAME "doc_Name" from cir_docmst where DOC_TYPE in ('RCR','DN','CN') order by DOC_NAME;
             
   End cir_unit_doc_com_bind_p;
END cir_unit_doc_com_bind;
/

/*****************************unit bind**************************************/

CREATE OR REPLACE PROCEDURE websp_pubcenter_new (
pextra1 VARCHAR2,
p_accounts OUT cur_type_new1.cursor_type,
p_accounts1 OUT cur_type_new1.cursor_type
)
AS
BEGIN
OPEN p_accounts FOR
SELECT "Pub_cent_Code",
"Pub_Cent_name" || '(' || "City_Name" || ')' AS "center"
FROM pub_cent_mast, city_mst
WHERE city_mst."City_Code" = pub_cent_mast."City_Code"
AND NVL (pub_cent_mast.print_cent, 'Y') != 'N'
AND ( (UPPER ("Pub_Cent_name") LIKE UPPER (pextra1) || '%')
OR (pextra1 IS NULL)
)
ORDER BY "center";

OPEN p_accounts1 FOR
SELECT "Agency_Name", "code_subcode"
FROM agency_mast
ORDER BY "Agency_Name";
END ;
/


/***************************for region *****************/

CREATE OR REPLACE PACKAGE BODY cir_region_bind
IS
   PROCEDURE cir_region_bind_p (
      pcomp_code    IN       VARCHAR2,
      pdateformat   IN       VARCHAR2,
      pextra1       IN       VARCHAR2,
      pextra2       IN       VARCHAR2,
      p_accounts    OUT      t_accounts_cursor
   )
   AS
   BEGIN
      OPEN p_accounts FOR
         SELECT   cir_region_mast.*,
                  cir_get_zone_name (cir_region_mast.comp_code,
                                     cir_region_mast.zone_code
                                    ) zone_name
             FROM cir_region_mast
            WHERE comp_code = pcomp_code
         ORDER BY cir_region_mast.reg_code;
   END cir_region_bind_p;

   PROCEDURE cir_region_bind_p (
      pcomp_code    IN       VARCHAR2,
      preg_code     IN       VARCHAR2,
      pdateformat   IN       VARCHAR2,
      pextra1       IN       VARCHAR2,
      pextra2       IN       VARCHAR2,
      p_accounts    OUT      t_accounts_cursor
   )
   AS
   BEGIN
      OPEN p_accounts FOR
         SELECT   cir_region_mast.*,
                  cir_get_zone_name (cir_region_mast.comp_code,
                                     cir_region_mast.zone_code
                                    ) zone_name
             FROM cir_region_mast
            WHERE comp_code = pcomp_code
              AND (reg_code = preg_code OR preg_code IS NULL)
         ORDER BY cir_region_mast.reg_code;
   END cir_region_bind_p;

   PROCEDURE cir_region_bind_p (
      pcomp_code    IN       VARCHAR2,
      preg_code     IN       VARCHAR2,
      pcol_name     IN       VARCHAR2,
      porder        IN       VARCHAR2,
      pdateformat   IN       VARCHAR2,
      pextra1       IN       VARCHAR2,
      pextra2       IN       VARCHAR2,
      p_accounts    OUT      t_accounts_cursor
   )
   AS
      v_query   VARCHAR2 (2000);
   BEGIN
      v_query :=
            'select cir_region_mast.*,cir_get_zone_name(cir_region_mast.comp_code,cir_region_mast.zone_code) zone_name 
		from cir_region_mast 
		where comp_code='
         || ''''
         || pcomp_code
         || ''''
         || ' and (reg_code ='
         || ''''
         || preg_code
         || ''''
         || ' or '
         || ''''
         || preg_code
         || ''''
         || ' is null)
		order by '
         || pcol_name
         || ' '
         || porder;

      --insert into test1(vstring,vstring2) values('cir_region_bind_p',v_query);
      --commit;
      OPEN p_accounts FOR v_query;
   END cir_region_bind_p;
END cir_region_bind;
/

/*************************3/01/12*********************************************/

CREATE OR REPLACE FUNCTION cir_get_edtn_name(pcomp_code in varchar2,pedtn in varchar2) RETURN varchar2 IS
vedtn_name varchar2(500);
BEGIN
   Begin
      select edtn_name into vedtn_name from cir_edtn_mast where comp_code=pcomp_code and edtn=pedtn;
           exception when others then
            vedtn_name:=null;
  End;
    return nvl(vedtn_name,'');
END;
/

/*******************************************************************//

CREATE OR REPLACE FUNCTION cir_get_publ_name(pcomp_code in varchar2,ppubl in varchar2) RETURN varchar2 IS
vpubl_name cir_publ_mast.publ_name%type;
BEGIN
   Begin
      select publ_name into vpubl_name from cir_publ_mast where comp_code=pcomp_code and publ=ppubl;
           exception when others then
                            vpubl_name:=null;
  End;
    return nvl(vpubl_name,'');
END;
/

/******************************************************************/

CREATE OR REPLACE FUNCTION cir_get_zone_name(pcomp_code in varchar2,pzone_code in varchar2) RETURN varchar2 IS
vzone_name cir_zone_mast.zone_desc%type;
BEGIN
	Begin
      select zone_desc into vzone_name from cir_zone_mast 
      	where comp_code=pcomp_code and zone_code=pzone_code;
  Exception when others then
		vzone_name:=null;
	End;
  return nvl(vzone_name,'');
END;
/


/****************************************************************************/

CREATE OR REPLACE FUNCTION cir_get_region_name(pcomp_code in varchar2,pregion_code in varchar2) RETURN varchar2 IS
vreg_name cir_region_mast.reg_desc%type;
BEGIN
Begin
select reg_desc into vreg_name from cir_region_mast
where comp_code=pcomp_code and reg_code=pregion_code;
Exception when others then
vreg_name:=null;
End;
return nvl(vreg_name,'');
END;
/


/******************************************************************/

CREATE OR REPLACE PACKAGE cir_branch_detail IS
  type t_accounts is ref cursor;
     
  procedure cir_branch_detail_p(
     pcompcode          in varchar2,
     pbrancode          in varchar2,
     plangtype          in varchar2,---1 for enlish and 2 for other language
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts);

End cir_branch_detail;
/

CREATE OR REPLACE PACKAGE BODY cir_branch_detail IS

  Procedure cir_branch_detail_p(
     pcompcode          in varchar2,
     pbrancode          in varchar2,
     plangtype          in varchar2,---1 for enlish and 2 for other language
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts)
  As
  Begin
        open p_accounts for 
        select branch_mst.*,(select distinct "City_Name" from city_mst where "City_Code"=branch_mst."City_Code") city_name,
        (SELECT distinct "Country_Name" FROM count_mst where "Country_Code"=branch_mst."Country_Code") country_name from branch_mst 
        where ("Branch_Code"=pbrancode or pbrancode is null)
        order by "Comp_Code","Branch_Name";

  END cir_branch_detail_p;
END cir_branch_detail;
/

/*********************************************************************/

CREATE OR REPLACE PACKAGE cir_pcenter_detail IS
  type t_accounts is ref cursor;
     
  procedure cir_pcenter_detail_p(
     pcompcode          in varchar2,
     ppcenter           in varchar2,
     plangtype          in varchar2,---1 for enlish and 2 for other language
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts);

End cir_pcenter_detail;
/


CREATE OR REPLACE PACKAGE BODY cir_pcenter_detail IS

  Procedure cir_pcenter_detail_p(
     pcompcode          in varchar2,
     ppcenter           in varchar2,
     plangtype          in varchar2,---1 for enlish and 2 for other language
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts)
  As
  Begin
        open p_accounts for 
        select * from pub_cent_mast where /*"Comp_Code"=pcompcode  and*/
        ("Pub_cent_Code"=ppcenter or ppcenter is null) and rownum<=1
        order by "Comp_Code";

  END cir_pcenter_detail_p;

END cir_pcenter_detail;
/

/***************************************************************************/

CREATE OR REPLACE FUNCTION cir_get_edtn_name(pcomp_code in varchar2,pedtn in varchar2) RETURN varchar2 IS
vedtn_name varchar2(500);
BEGIN
   Begin
      select edtn_name into vedtn_name from cir_edtn_mast where comp_code=pcomp_code and edtn=pedtn;
           exception when others then
            vedtn_name:=null;
  End;
    return nvl(vedtn_name,'');
END;
/



/***************************** end of 5886 ******************/

////////////////////garima
CREATE OR REPLACE PACKAGE cir_one_day_supply_change IS
  TYPE T_Circul_Cursor is Ref Cursor;
procedure cir_one_day_supply_change_p(
    pcomp_code 		in varchar2,
    punit_code 		in varchar2,
    ppubl_code 		in varchar2,
    pedtn_code 		in varchar2,
    psup_type 		in varchar2,
    psup_date 		in varchar2,
    pagcd_code 		in varchar2,
    pdpcd_code 		in varchar2,
    pzone_code      in varchar2,--for zone filter added new 09122011 by Sushil
    pregion_code    in varchar2,--for region filter added new 09122011 by Sushil
    pcomm_category  in varchar2,--for commition category added new 09122011 by Sushil
    pstate_code     in varchar2,--for state filter added new 09122011 by Sushil
    pdist_code      in varchar2,--for district filter added new 09122011 by Sushil
    ptaluka_code    in varchar2,--for taluka filter added new 09122011 by Sushil
    pcity_code      in varchar2,--for city filter added new 09122011 by Sushil
    proute_code     in varchar2,--for route filter added new 09122011 by Sushil
    pbran_code      in varchar2,--for branch filter added new 09122011 by Sushil
    pagency_type    in varchar2,--for agency type filter added new 09122011 by Sushil
    pagency_class   in varchar2,--for agency class filter added new 09122011 by Sushil
    pdateformat     in varchar2,
    pextra1 		in varchar2,
    pextra2 		in varchar2,
    pextra3         in varchar2,
    pextra4         in varchar2,
    pextra5         in varchar2,
    pextra6         in varchar2,
    pextra7         in varchar2,
    pextra8         in varchar2,
    pextra9         in varchar2,
    pextra10        in varchar2,
    p_circuls 		out T_Circul_Cursor);

END cir_one_day_supply_change;
/
///////////////////////////////////////
CREATE OR REPLACE PACKAGE BODY cir_one_day_supply_change IS
  procedure cir_one_day_supply_change_p(
   pcomp_code     in varchar2,
   punit_code     in varchar2,
   ppubl_code     in varchar2,
   pedtn_code     in varchar2,
   psup_type      in varchar2,
   psup_date      in varchar2,
   pagcd_code     in varchar2,
   pdpcd_code     in varchar2,
   pzone_code     in varchar2,--for zone filter added new 09122011 by Sushil
   pregion_code   in varchar2,--for region filter added new 09122011 by Sushil
   pcomm_category in varchar2,--for commition category added new 09122011 by Sushil
   pstate_code    in varchar2,--for state filter added new 09122011 by Sushil
   pdist_code     in varchar2,--for district filter added new 09122011 by Sushil
   ptaluka_code   in varchar2,--for taluka filter added new 09122011 by Sushil
   pcity_code     in varchar2,--for city filter added new 09122011 by Sushil
   proute_code    in varchar2,--for route filter added new 09122011 by Sushil
   pbran_code     in varchar2,--for branch filter added new 09122011 by Sushil
   pagency_type   in varchar2,--for agency type filter added new 09122011 by Sushil
   pagency_class  in varchar2,--for agency class filter added new 09122011 by Sushil
   pdateformat    in varchar2,
   pextra1        in varchar2,--1 for  edition route wise,2 for edition district wise
   pextra2        in varchar2,
   pextra3        in varchar2,
   pextra4        in varchar2,
   pextra5        in varchar2,
   pextra6        in varchar2,
   pextra7        in varchar2,
   pextra8        in varchar2,
   pextra9        in varchar2,
   pextra10       in varchar2,
   p_circuls      out T_Circul_Cursor)
 As
  v_sup_date date;
 Begin
  v_sup_date:=to_date(psup_date,''''||pdateformat||'''');
  if upper(pextra2)='D' then
      open p_circuls for
      select c.comp_code as "COMP_CODE",c.unit_code as "UNIT_CODE",a.agcd as "AGCD",a.dpcd as "DPCD",a.ag_name as "AGENCY_NAME",
      a.ag_name_oth_lang as "AGENCY_NAME_OTHER_LANG",a.city_code as "CITY_CODE",
        cir_get_city(a.comp_code,a.city_code) as "CITY_NAME",a.station_code as "DROP_POINT_CODE",
        cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,'1') as "DROP_POINT_NAME",
        c.sup_copy as "SUP_COPY",cir_get_route_seqno(c.comp_code,c.unit_code,c.route_code) as "ROUTE_SEQ",
        cir_get_supply_seqno(c.comp_code,c.unit_code,c.publ,c.edtn,c.agcd,c.dpcd) as "SUPPLY_SEQ",
        c.publ as "PUBL",p.publ_name as "PUBL_NAME",e.main_edtn as "MAIN_EDTN",cir_get_edtn_name(c.comp_code,e.main_edtn) as "MAIN_EDTN_NAME",
        c.edtn as "EDTN",e.edtn_name as "EDTN_NAME",c.sup_type_code as "SUP_TYPE_CODE", b.sup_ty_name as "SUP_TY_NAME",
        s.base_supply as "BASE_SUPPLY", s.supply_sun as "SUPPLY_SUN", s.supply_mon as "SUPPLY_MON", s.supply_tue as "SUPPLY_TUE", 
        s.supply_wed as "SUPPLY_WED", s.supply_thu as "SUPPLY_THU", s.supply_fri as "SUPPLY_FRI", s.supply_sat as "SUPPLY_SAT",to_char(c.supdate,'DAY') as "SUPDAY", 
        (select sum(c.sup_copy) sup_copy from cir_agmast_dis a,cir_supply_type_mast b,cir_dbksup_dis c
        where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=pcomp_code and
              a.unit=c.unit_code and a.unit=nvl(punit_code,a.unit) and b.sup_ty_code=c.sup_type_code and
              c.publ=nvl(ppubl_code,c.publ) and c.edtn = nvl(pedtn_code,c.edtn) and c.supdate=v_sup_date and 
              a.agcd=c.agcd and a.dpcd=c.dpcd and
              a.agcd=nvl(pagcd_code,a.agcd) and a.dpcd=nvl(pdpcd_code,a.dpcd) and c.sup_type_code=psup_type) total_supply,
         c.final_supply_flag as "FINAL_SUPPLY_FLAG"
      from cir_agmast_dis a,cir_supply_type_mast b,cir_dbksup_dis c,cir_publ_mast p,cir_edtn_mast e,cir_supply_dis s
      where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=p.comp_code and a.comp_code=e.comp_code and a.comp_code=s.comp_code and a.comp_code=pcomp_code and
         a.unit=c.unit_code and a.unit=s.unit and a.unit=nvl(punit_code,a.unit) and b.sup_ty_code=c.sup_type_code and
         c.publ=p.publ and c.publ=e.publ and c.publ=s.publ and c.publ=nvl(ppubl_code,c.publ) and c.edtn=e.edtn and c.edtn=s.edtn and c.edtn = nvl(pedtn_code,c.edtn) and 
         c.supdate=v_sup_date and a.agcd=c.agcd and a.dpcd=c.dpcd and
         a.agcd=s.agcd and a.agcd=nvl(pagcd_code,a.agcd) and a.dpcd=s.dpcd and a.dpcd=nvl(pdpcd_code,a.dpcd) and c.sup_type_code=s.supply_type_code and c.sup_type_code=nvl(psup_type,c.sup_type_code) and
         (c.agency_ty_code = pagency_type or pagency_type is null) and
         (c.comm_code = pcomm_category or pcomm_category is null) and
         (c.route_code = proute_code or proute_code is null) and
         (a.state_code = pstate_code or pstate_code is null) and
         (a.dist_code = pdist_code or pdist_code is null) and
         (a.tehsil_taluka = ptaluka_code or ptaluka_code is null) and
         (a.branch_code = pbran_code or pbran_code is null) and
         a.city_code in (select city_code from cir_city_mast where a.comp_code=pcomp_code and city_code = nvl(pcity_code,city_code) and 
         (zone_code = pzone_code or pzone_code is null) and (region_code = pregion_code or pregion_code is null))
         order by route_seq,supply_seq,agency_name;
  else
      if pextra1=2 then---for edition district and agency wise
          open p_circuls for
          select a.agcd agcd,a.dpcd dpcd,a.ag_name agency_name,a.ag_name_oth_lang agency_name_other_lang,a.city_code city_code,
                cir_get_city(a.comp_code,a.city_code) city_name,a.station_code drop_point_code,cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,'1') drop_point_name,
                c.sup_copy sup_copy,cir_get_route_seqno(c.comp_code,c.unit_code,c.route_code) route_seq,
                cir_get_supply_seqno(c.comp_code,c.unit_code,c.publ,c.edtn,c.agcd,c.dpcd) supply_seq,
                (select sum(c.sup_copy) sup_copy from cir_agmast a,cir_supply_type_mast b,cir_dbksup c
                where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=pcomp_code and
                      a.unit=c.unit_code and a.unit=nvl(punit_code,a.unit) and b.sup_ty_code=c.sup_type_code and
                      c.publ=nvl(ppubl_code,c.publ) and c.edtn = nvl(pedtn_code,c.edtn) and c.supdate=v_sup_date and 
                      a.agcd=c.agcd and a.dpcd=c.dpcd and
                      a.agcd=nvl(pagcd_code,a.agcd) and a.dpcd=nvl(pdpcd_code,a.dpcd) and c.sup_type_code=psup_type) total_supply,d.dist_name dist_name
          from cir_agmast a,cir_supply_type_mast b,cir_dbksup c,cir_dist_mast d
          where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=d.comp_code(+) and a.comp_code=pcomp_code and
             a.unit=c.unit_code and a.unit=nvl(punit_code,a.unit) and b.sup_ty_code=c.sup_type_code and
             c.publ=nvl(ppubl_code,c.publ) and c.edtn = nvl(pedtn_code,c.edtn)
             and c.supdate=v_sup_date and a.agcd=c.agcd and a.dpcd=c.dpcd and
             a.agcd=nvl(pagcd_code,a.agcd) and a.dpcd=nvl(pdpcd_code,a.dpcd) and c.sup_type_code=psup_type and
             a.dist_code=d.dist_code(+) and
             (c.agency_ty_code = pagency_type or pagency_type is null) and
            (c.comm_code = pcomm_category or pcomm_category is null) and
            (c.route_code = proute_code or proute_code is null) and
            (a.state_code = pstate_code or pstate_code is null) and
            (a.dist_code = pdist_code or pdist_code is null) and
            (a.tehsil_taluka = ptaluka_code or ptaluka_code is null) and
            (a.branch_code = pbran_code or pbran_code is null) and
            a.city_code in (select city_code from cir_city_mast where a.comp_code=pcomp_code and city_code = nvl(pcity_code,city_code) and 
            (zone_code = pzone_code or pzone_code is null) and (region_code = pregion_code or pregion_code is null)) 
            order by dist_name,agency_name,supply_seq;
      else
          open p_circuls for
          select c.comp_code as "COMP_CODE",c.unit_code as "UNIT_CODE",a.agcd as "AGCD",a.dpcd as "DPCD",a.ag_name as "AGENCY_NAME",
      a.ag_name_oth_lang as "AGENCY_NAME_OTHER_LANG",a.city_code as "CITY_CODE",
        cir_get_city(a.comp_code,a.city_code) as "CITY_NAME",a.station_code as "DROP_POINT_CODE",
        cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,'1') as "DROP_POINT_NAME",
        c.sup_copy as "SUP_COPY",cir_get_route_seqno(c.comp_code,c.unit_code,c.route_code) as "ROUTE_SEQ",
        cir_get_supply_seqno(c.comp_code,c.unit_code,c.publ,c.edtn,c.agcd,c.dpcd) as "SUPPLY_SEQ",
        c.publ as "PUBL",p.publ_name as "PUBL_NAME",e.main_edtn as "MAIN_EDTN",cir_get_edtn_name(c.comp_code,e.main_edtn) as "MAIN_EDTN_NAME",
        c.edtn as "EDTN",e.edtn_name as "EDTN_NAME",c.sup_type_code as "SUP_TYPE_CODE", b.sup_ty_name as "SUP_TY_NAME",
        s.base_supply as "BASE_SUPPLY", s.supply_sun as "SUPPLY_SUN", s.supply_mon as "SUPPLY_MON", s.supply_tue as "SUPPLY_TUE", 
        s.supply_wed as "SUPPLY_WED", s.supply_thu as "SUPPLY_THU", s.supply_fri as "SUPPLY_FRI", s.supply_sat as "SUPPLY_SAT",to_char(c.supdate,'DAY') as "SUPDAY", 
        (select sum(c.sup_copy) sup_copy from cir_agmast a,cir_supply_type_mast b,cir_dbksup c
        where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=pcomp_code and
              a.unit=c.unit_code and a.unit=nvl(punit_code,a.unit) and b.sup_ty_code=c.sup_type_code and
              c.publ=nvl(ppubl_code,c.publ) and c.edtn = nvl(pedtn_code,c.edtn) and c.supdate=v_sup_date and 
              a.agcd=c.agcd and a.dpcd=c.dpcd and
              a.agcd=nvl(pagcd_code,a.agcd) and a.dpcd=nvl(pdpcd_code,a.dpcd) and c.sup_type_code=psup_type) total_supply,
         c.final_supply_flag as "FINAL_SUPPLY_FLAG"
      from cir_agmast a,cir_supply_type_mast b,cir_dbksup c,cir_publ_mast p,cir_edtn_mast e,cir_supply s
      where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=p.comp_code and a.comp_code=e.comp_code and a.comp_code=s.comp_code and a.comp_code=pcomp_code and
         a.unit=c.unit_code and a.unit=s.unit and a.unit=nvl(punit_code,a.unit) and b.sup_ty_code=c.sup_type_code and
         c.publ=p.publ and c.publ=e.publ and c.publ=s.publ and c.publ=nvl(ppubl_code,c.publ) and c.edtn=e.edtn and c.edtn=s.edtn and c.edtn = nvl(pedtn_code,c.edtn) and 
         c.supdate=v_sup_date and a.agcd=c.agcd and a.dpcd=c.dpcd and
         a.agcd=s.agcd and a.agcd=nvl(pagcd_code,a.agcd) and a.dpcd=s.dpcd and a.dpcd=nvl(pdpcd_code,a.dpcd) and c.sup_type_code=s.supply_type_code and c.sup_type_code=nvl(psup_type,c.sup_type_code) and
         (c.agency_ty_code = pagency_type or pagency_type is null) and
         (c.comm_code = pcomm_category or pcomm_category is null) and
         (c.route_code = proute_code or proute_code is null) and
         (a.state_code = pstate_code or pstate_code is null) and
         (a.dist_code = pdist_code or pdist_code is null) and
         (a.tehsil_taluka = ptaluka_code or ptaluka_code is null) and
         (a.branch_code = pbran_code or pbran_code is null) and
         a.city_code in (select city_code from cir_city_mast where a.comp_code=pcomp_code and city_code = nvl(pcity_code,city_code) and 
         (zone_code = pzone_code or pzone_code is null) and (region_code = pregion_code or pregion_code is null))
         order by route_seq,supply_seq,agency_name;
      end if;
   end if;
 End cir_one_day_supply_change_p;
END cir_one_day_supply_change;
/
/*****************************************19-dec-2011 Laxman transfer out for malesiya*********************/

CREATE OR REPLACE procedure cir_unsold_supply_for_transfer(
    pcomp_code         in varchar2,
    punit_code         in varchar2,
    pbran_code         in varchar2,
    pfromdate          in varchar2,
    ptilldate          in varchar2,
    puserid            in varchar2,   
    pdateformat        in varchar2,
    pextra1            in varchar2,
    pextra2            in varchar2,
    pextra3            in varchar2,
    pextra4            in varchar2,
    pextra5            in varchar2,
    pextra6            in varchar2,
    pextra7            in varchar2,
    pextra8            in varchar2,               
    pextra9            in varchar2,
    pextra10           in varchar2,
    p_accounts         OUT Cur_Type_New1.cursor_type,
    p_accounts1        OUT Cur_Type_New1.cursor_type)
As
    v_frdt          date;
    v_todt          date;
    v_process_id    number;
Begin
    v_frdt:=to_date(pfromdate,''''||pdateformat||'''');
    v_todt:=to_date(ptilldate,''''||pdateformat||'''');

    v_process_id:=cir_generate_processid(pcomp_code,puserid,pdateformat,null,null,null,null,null);
    
    open p_accounts for
    select v_process_id as "PROCESS_ID" from dual;  

    open p_accounts1 for
    select distinct d.comp_code as "COMP_CODE",d.unit_code as "UNIT_CODE",d.branch_code as "BRANCH_CODE",d.doctype as "DOCTYPE",
    d.recptno as "RECPTNO",d.recptdt as "RECPTDT",d.sup_agcd as "SUP_AGCD" ,d.sup_dpcd as "SUP_DPCD",m.ag_name as "SUPPLY_AGENCY",
    cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) drop_point_name, cir_get_city(d.comp_code,m.city_code) city_name,cir_get_agency(d.comp_code,d.unit_code,d.agcd,d.dpcd) as "BILLING_AGENCY",
    sum(nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0)+nvl(apr_damage,0)) as "TOTAL_UNSOLD",
    v_process_id as "PROCESS_IDNO" 
    from cir_unsold_hdr h,cir_unsold_dtl d,cir_agmast m
    where h.comp_code=d.comp_code and h.comp_code=m.comp_code and h.comp_code=pcomp_code and h.unit_code=d.unit_code and h.unit_code=m.unit and h.unit_code=punit_code and 
    h.doctype=d.doctype and h.doctype='UCN' and h.recptno=d.recptno and h.recptdt=d.recptdt and h.recptdt between v_frdt and v_todt and 
    h.agcd=nvl(d.sup_agcd,d.agcd) and h.agcd=m.agcd and h.dpcd=nvl(d.sup_dpcd,d.dpcd) and h.dpcd=m.dpcd and 
    d.branch_code=nvl(pbran_code,d.branch_code) and (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0)+nvl(apr_damage,0))>0 and
    (h.branch_trfno is null or h.branch_trfno='')
    group by d.comp_code,d.unit_code,d.branch_code,d.doctype,d.recptno,d.recptdt,d.sup_agcd,d.sup_dpcd,m.ag_name,m.station_code, m.city_code,d.agcd,d.dpcd
    order by comp_code,unit_code,recptdt,recptno;
            
End cir_unsold_supply_for_transfer;
/
CREATE OR REPLACE procedure cir_unsold_transfer_selected(
    pcompcode       in varchar2,
    punitcode       in varchar2,
    pbrancode       in varchar2,
    precptno        in varchar2,
    precptdt        in varchar2,
    pprocess_idno   in number,
    puserid         in varchar2, 
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    pextra3         in varchar2,
    pextra4         in varchar2,
    pextra5         in varchar2,
    pextra6         in varchar2,
    pextra7         in varchar2,
    pextra8         in varchar2,
    pextra9         in varchar2,
    pextra10        in varchar2,
    p_accounts      OUT Cur_Type_New1.cursor_type)
is
    v_precptdt     date;
begin
    v_precptdt:=to_date(precptdt,''''||pdateformat||'''');
    
    insert into cir_bill_return_print(comp_code,unit_code,branch_code,billno,billdt,return_copy)
    values(pcompcode,punitcode,pbrancode,precptno,v_precptdt,pprocess_idno);
    commit;
    
    open p_accounts for
    select sysdate as "CUR_DATE" from dual;
    
End cir_unsold_transfer_selected;
/
CREATE OR REPLACE procedure cir_fetch_for_unsold_transfer(
    pcomp_code      in varchar2,
    punit_code      in varchar2,
    pbran_code      in varchar2,
    pprocess_idno   in number,
    ppacket_szie    in number,
    puserid         in varchar2, 
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    pextra3         in varchar2,
    pextra4         in varchar2,
    pextra5         in varchar2,
    pextra6         in varchar2,
    pextra7         in varchar2,
    pextra8         in varchar2,
    pextra9         in varchar2,
    pextra10        in varchar2,
    p_accounts      OUT Cur_Type_New1.cursor_type,
    p_accounts1     OUT Cur_Type_New1.cursor_type)
is
begin

    open p_accounts for
    select distinct x.comp_code as "COMP_CODE",x.unit_code as "UNIT_CODE",x.branch_code as "BRANCH_CODE",x.doctype as "DOCTYPE",
    x.publ as "PUBL",x.publ_name as"PUBL_NAME", x.main_edtn as "MAIN_EDTN",x.main_edtn_name as "MAIN_EDTN_NAME",
    x.edtn as "EDTN",x.edtn_name as "EDTN_NAME",x.copy_rate as "COPY_RATE",x.total_unsold as "TOTAL_UNSOLD",
    ceil(x.total_unsold/ppacket_szie) as "PKT" 
    from(
    select distinct d.comp_code,d.unit_code,d.branch_code,d.doctype,
    d.publ,p.publ_name, e.main_edtn,cir_get_edtn_name(d.comp_code,d.edtn) main_edtn_name,
    d.edtn,e.edtn_name,d.copy_rate,sum(nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0)+nvl(apr_damage,0)) as TOTAL_UNSOLD
    from cir_unsold_hdr h,cir_unsold_dtl d,cir_agmast m,cir_publ_mast p,cir_edtn_mast e,cir_bill_return_print b
    where h.comp_code=d.comp_code and h.comp_code=m.comp_code and h.comp_code=p.comp_code and h.comp_code=e.comp_code and h.comp_code=b.comp_code and h.comp_code=pcomp_code and 
    h.unit_code=d.unit_code and h.unit_code=m.unit and h.unit_code=b.unit_code and h.unit_code=punit_code and 
    h.doctype=d.doctype and h.doctype='UCN' and h.recptno=d.recptno and h.recptno=b.billno and h.recptdt=d.recptdt and h.recptdt=b.billdt and
    h.agcd=nvl(d.sup_agcd,d.agcd) and h.agcd=m.agcd and h.dpcd=nvl(d.sup_dpcd,d.dpcd) and h.dpcd=m.dpcd and d.publ=p.publ and d.publ=e.publ and d.edtn=e.edtn and  
    d.branch_code=pbran_code and (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0)+nvl(apr_damage,0))>0 and b.return_copy=pprocess_idno
    group by d.comp_code,d.unit_code,d.branch_code,d.doctype,d.publ,p.publ_name,e.main_edtn,d.edtn,e.edtn_name,d.copy_rate) x
    order by comp_code,unit_code,publ_name,main_edtn_name,edtn_name,copy_rate;
    
    open p_accounts1 for
    select sysdate as "CUR_DATE" from dual;
    
    delete from cir_bill_return_print where return_copy=pprocess_idno;commit;
    
End cir_fetch_for_unsold_transfer;
/
CREATE OR REPLACE PACKAGE cir_branch_received is
   TYPE T_Circul_Cursor is Ref Cursor;
   procedure cir_branch_received_p1 (
        pcompcode       in varchar2,
        punitcode       in varchar2,
        pbranchcode     in varchar2,
        pfrombranch     in varchar2,
        pdoctypeout     in varchar2,
        pdoctypein      in varchar2,
        pfromdate       in varchar2,
        ptilldate       in varchar2,
        pdateformat     in varchar2,
        pextra1         in varchar2,
        pextra2         in varchar2,
        pextra3         in varchar2,
        pextra4         in varchar2,        
        pextra5         in varchar2,
        pextra6         in varchar2,
        pextra7         in varchar2,
        pextra8         in varchar2,
        pextra9         in varchar2,
        pextra10        in varchar2,                        
        p_circuls       out T_Circul_Cursor);

   procedure cir_branch_received_p2 (
   pcompcode    in varchar2,
   punitcode    in varchar2,
   pbranchcode  in varchar2,
   pfrombranch  in varchar2,
   pdoctypeout  in varchar2,
   pdoctypein   in varchar2,
   precptno     in varchar2,
   precptdt     in varchar2,
   pdateformat  in varchar2,
   pextra1      in varchar2,
   pextra2      in varchar2,
   p_circuls    out T_Circul_Cursor);
End cir_branch_received;
/
CREATE OR REPLACE PACKAGE BODY cir_branch_received is
    procedure cir_branch_received_p1 (
        pcompcode       in varchar2,
        punitcode       in varchar2,
        pbranchcode     in varchar2,
        pfrombranch     in varchar2,
        pdoctypeout     in varchar2,
        pdoctypein      in varchar2,
        pfromdate       in varchar2,
        ptilldate       in varchar2,
        pdateformat     in varchar2,
        pextra1         in varchar2,
        pextra2         in varchar2,
        pextra3         in varchar2,
        pextra4         in varchar2,        
        pextra5         in varchar2,
        pextra6         in varchar2,
        pextra7         in varchar2,
        pextra8         in varchar2,
        pextra9         in varchar2,
        pextra10        in varchar2,                        
        p_circuls       out T_Circul_Cursor) 
    As
    v_frdt  date;
    v_todt  date;
   Begin
        v_frdt:=to_date(pfromdate,''''||pdateformat||'''');
        v_todt:=to_date(pfromdate,''''||pdateformat||'''');
        
        open p_circuls for
        select distinct h.comp_code as "COMP_CODE",h.unit_code as "UNIT_CODE",d.branch_code as "BRANCH_CODE",(select "Branch_Name" from branch_mst where "Branch_Code"=d.branch_code) as "BRANCH_NAME",
        d.oth_branch_code as "OTH_BRANCH",(select "Branch_Name" from branch_mst where "Branch_Code"=d.oth_branch_code) as "OTH_BRANCH_NAME",
        d.recptno as "REF_RECPTNO" ,d.recptdt as "REF_RECPTDT",h.taxi_route_name as "TAXI_ROUTE_NAME", h.taxi_no as "TAXI_NO"
        from cir_branch_return_det d,cir_branch_return_hdr h 
        where h.comp_code=pcompcode and h.comp_code=d.comp_code and h.unit_code=punitcode and h.unit_code=d.unit_code and 
        h.doctype=d.doctype and ((h.recptdt between v_frdt and v_todt) or (v_frdt is null)) and h.recptno=d.recptno and d.branch_code=nvl(pfrombranch,d.branch_code) and 
        d.oth_branch_code=nvl(pbranchcode,d.oth_branch_code) and d.doctype=pdoctypeout and d.recptno||d.recptdt not in(select branch_refno||branch_refdt from cir_branch_return_hdr 
        where comp_code=pcompcode and unit_code=punitcode and doctype=pdoctypein)
        order by comp_code,unit_code,ref_recptdt,ref_recptno;
 
   End cir_branch_received_p1;

    procedure cir_branch_received_p2 (
        pcompcode    in varchar2,
        punitcode    in varchar2,
        pbranchcode  in varchar2,
        pfrombranch  in varchar2,
        pdoctypeout  in varchar2,
        pdoctypein   in varchar2,
        precptno     in varchar2,
        precptdt     in varchar2,        
        pdateformat  in varchar2,
        pextra1      in varchar2,
        pextra2      in varchar2,
        p_circuls    out T_Circul_Cursor) 
    As
    v_recptdt date;
   Begin
        v_recptdt:=to_date(precptdt,''''||pdateformat||'''');
        open p_circuls for
        select comp_code,unit_code,branch_code oth_branch,recptno ref_recptno,recptdt ref_recptdt,slno,publ_code,edtn_code ,
        edtn_rate ,edtn_copy,nvl(copy_weight,0) copy_weight,oth_branch_code branch from cir_branch_return_det 
        where comp_code=pcompcode and unit_code=punitcode and branch_code=pfrombranch and 
        oth_branch_code=pbranchcode and doctype=pdoctypeout and recptno||recptdt not in(select branch_refno||branch_refdt from cir_branch_return_hdr 
        where comp_code=pcompcode and unit_code=punitcode and doctype=pdoctypein) and recptno=precptno and recptdt=v_recptdt
        order by comp_code,unit_code,recptdt,recptno,slno;
 
   End cir_branch_received_p2;   
End cir_branch_received;
/



/*****************************************19-dec-2011 Laxman transfer out for malesiya*********************/////////////////////
//////////////////update by Garima
CREATE OR REPLACE PACKAGE cir_supply_populate IS
type t_accouts_type is ref cursor;
procedure cir_supply_populate_p(
  pcomp_code in varchar2,
  punit in varchar2,
  pagcd in varchar2,
  pdpcd in varchar2,
  ppubl in varchar2,
  pedtn in varchar2,
  pdateformat in varchar2,
  pextra1 in varchar2,
  pextra2 in varchar2,
  p_accounts out t_accouts_type);
END;
/
//////////////////////
/////////////////
CREATE OR REPLACE PACKAGE BODY cir_supply_populate IS
 procedure cir_supply_populate_p(
     pcomp_code in varchar2,
     punit in varchar2,
     pagcd in varchar2,
     pdpcd in varchar2,
     ppubl in varchar2,
     pedtn in varchar2,
     pdateformat in varchar2,
     pextra1 in varchar2,
     pextra2 in varchar2,
     p_accounts out t_accouts_type) as
 vquery varchar2(4000);
 Begin
      vquery:='select supply_type_code,cir_get_supply_name(cir_supply.comp_code,cir_supply.supply_type_code) supply_type_name,base_supply,supply_sun,supply_mon,supply_tue,
                supply_wed,supply_thu,supply_fri,supply_sat,supply_spl1,supply_spl2,supply_flag,base_supply,packet_size,comm_code,comm_flag,route_code,
                subroute_code,sub_subroute_code from cir_supply
              where comp_code='||pcomp_code||' and unit='||punit||' and agcd='||pagcd||' and dpcd='||pdpcd||' and publ='||ppubl||' and edtn='||pedtn
              ||'order by supply_type_code';
              --insert into test1(vstring) values (vquery);
    if upper(pextra2)='D' then
       open p_accounts for
         select supply_type_code,cir_get_supply_name(cir_supply_dis.comp_code,cir_supply_dis.supply_type_code) supply_type_name,base_supply,supply_sun,supply_mon,supply_tue,
                supply_wed,supply_thu,supply_fri,supply_sat,supply_spl1,supply_spl2,supply_flag,base_supply,packet_size,comm_code,comm_flag,
                lbl_printno supply_seq,route_code,cir_get_name.cir_route(comp_code,unit,route_code,1,pdateformat,'','') route_name, 
                subroute_code ,cir_get_name.cir_subroute(comp_code,unit,route_code,subroute_code,1,pdateformat,'','') subroute_name,
                sub_subroute_code,cir_get_name.cir_subsubroute(comp_code,unit,route_code,subroute_code,sub_subroute_code,1,pdateformat,'','') subsubroute_name,
                (select nvl(CIR_SUP_ORDER_LIMIT,0) from preferrences where "comp_code"=pcomp_code) as "CIR_SUP_ORDER_LIMIT"
                from cir_supply_dis
              where comp_code=pcomp_code and unit=punit and agcd=pagcd and dpcd=pdpcd and publ=ppubl and edtn=pedtn
              order by supply_type_code;
     else
       open p_accounts for
         select supply_type_code,cir_get_supply_name(cir_supply.comp_code,cir_supply.supply_type_code) supply_type_name,base_supply,supply_sun,supply_mon,supply_tue,
                supply_wed,supply_thu,supply_fri,supply_sat,supply_spl1,supply_spl2,supply_flag,base_supply,packet_size,comm_code,comm_flag,
                lbl_printno supply_seq,route_code,cir_get_name.cir_route(comp_code,unit,route_code,1,pdateformat,'','') route_name, 
                subroute_code ,cir_get_name.cir_subroute(comp_code,unit,route_code,subroute_code,1,pdateformat,'','') subroute_name,
                sub_subroute_code,cir_get_name.cir_subsubroute(comp_code,unit,route_code,subroute_code,sub_subroute_code,1,pdateformat,'','') subsubroute_name,
                (select nvl(CIR_SUP_ORDER_LIMIT,0) from preferrences where "comp_code"=pcomp_code) as "CIR_SUP_ORDER_LIMIT"
                from cir_supply
              where comp_code=pcomp_code and unit=punit and agcd=pagcd and dpcd=pdpcd and publ=ppubl and edtn=pedtn
              order by supply_type_code;
     end if;
 End cir_supply_populate_p;
END cir_supply_populate;
/
/****************************** 20-dec-2011***********/
CREATE OR REPLACE PROCEDURE rpt_reasonwise_summ
   (pcompcode           in varchar2,
    pcenter             in varchar2,
    punitcode           in varchar2,
    pzonecode           in varchar2,
    pregioncode         in varchar2,
    pstatecode          in varchar2,
    pdistcode           in varchar2,
    ptaluka             in varchar2,
    pcitycode           in varchar2,
    pdatefrom           in varchar2,
    pdateto             in varchar2,
    pagency_code        in varchar2,
    pagency_subcode     in varchar2,
    pretain_code        in varchar2,
    pexec_code          in varchar2,
    puserid             in varchar2,
    pdateformat         in varchar2,
    pextra1             in varchar2,
    pextra2             in varchar2,
    pextra3             in varchar2,
    pextra4             in varchar2,
    pextra5             in varchar2,
    p_accounts          OUT Cur_Type_New1.cursor_type,
    p_accounts1         OUT Cur_Type_New1.cursor_type,
    p_accounts2         OUT Cur_Type_New1.cursor_type)
IS
    v_frdt      date; 
    v_todt      date;
    
    v_query varchar2(8000);
     cursor cur_paymode is
        select distinct o.doctype as doctype
        from agency_mast m,ad_outstand o ,branch_mst b
        where o.comp_code=pcompcode and o.doctype<>'BILL' and o.unit=b."Branch_Code" and (o.unit=punitcode or punitcode is null) and 
              o.recptdt between v_frdt and v_todt and o.ag_main_code=m."Agency_Code" and (o.ag_main_code=pagency_code or pagency_code is null) and 
              o.ag_sub_code=m."SUB_Agency_Code" and (o.ag_sub_code=pagency_subcode or pagency_subcode is null) and
              (o.retainer_code=pretain_code or pretain_code is null) and (o.exec_code=pexec_code or pexec_code is null) and 
              (b."pub_center"=pcenter or pcenter is null) and (m.district =pdistcode or pdistcode is null) and (m.state =pstatecode or pstatecode is null)
              and (m."region" =pregioncode or pregioncode is null) and (m."zone_code" =pzonecode or pzonecode is null) 
              order by doctype;


         
    v_var       varchar2(4000);
    v_var_sum   varchar2(4000);
    v_doctype   varchar2(50);
Begin
    v_frdt      := to_date(pdatefrom,''''||pdateformat||'''');
    v_todt      := to_date(pdateto,''''||pdateformat||'''');

    open cur_paymode;
    loop
      fetch cur_paymode into v_doctype;
      exit when cur_paymode%notfound;
        if v_var is null then
            v_var       :='case when o.doctype='||''''||v_doctype||''''||' then abs(o.amount) else 0 end "'||v_doctype||'"';
            v_var_sum   :='round(sum("'||v_doctype||'"),2)'||' "'||v_doctype||'"';
        else
            v_var        :=v_var||','||'case when o.doctype='||''''||v_doctype||''''||' then abs(o.amount) else 0 end "'||v_doctype||'"';
            v_var_sum    :=v_var_sum||','||'round(sum("'||v_doctype||'"),2)'||' "'||v_doctype||'"';
        end if;            
    end loop;
    close cur_paymode;

        
        if v_var is null then
            v_query:='select distinct x.comp_code comp_code,x.reason reason,x.reason_name reason_name,
            sum(x.amount) TOTAL from(select o.comp_code comp_code,o.doctype doctype, o.reason reason,
            case when o.doctype in(''RCR'',''RCP'',''CA'') then (select "Payment_Mode_Name" from payment_mode_mast where "Pay_Mode_Code"=o.reason)
            else
            (select "reason_name" from reason_mst where "reason_code"=o.reason)  
            end reason_name, sum(o.amount) amount from agency_mast m,ad_outstand o ,branch_mst b
            where o.comp_code='||''''||pcompcode||''''||' and o.doctype<>''BILL'' and o.unit=b."Branch_Code" and (o.unit='||''''||punitcode||''''||' or '||''''||punitcode||''''||' is null) and  
              o.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and o.ag_main_code=m."Agency_Code" and 
              (o.ag_main_code='||''''||pagency_code||''''||' or '||''''||pagency_code||''''||' is null) and o.ag_sub_code=m."SUB_Agency_Code" and 
              (o.ag_sub_code='||''''||pagency_subcode||''''||' or '||''''||pagency_subcode||''''||' is null) and
              (o.retainer_code='||''''||pretain_code||''''||' or '||''''||pretain_code||''''||' is null) and (o.exec_code='||''''||pexec_code||''''||' or '||''''||pexec_code||''''||' is null) and
              (b."pub_center"='||''''||pcenter||''''||' or '||''''||pcenter||''''||' is null) and (m.district ='||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and (m.state ='||''''||pstatecode||''''||' or '||''''||pstatecode||''''||' is null)
              and (m."region" ='||''''||pregioncode||''''||' or '||''''||pregioncode||''''||' is null) and (m."zone_code" ='||''''||pzonecode||''''||' or '||''''||pzonecode||''''||' is null)
              group by o.comp_code,o.doctype,o.reason) x
            group by x.comp_code,x.reason,x.reason_name
            order by comp_code,reason_name';
        else
            v_query:='select distinct x.comp_code comp_code,x.reason reason,x.reason_name reason_name,
            '||v_var_sum||',sum(x.amount) TOTAL from(select o.comp_code comp_code,o.doctype doctype, o.reason reason,
            case when o.doctype in(''RCR'',''RCP'',''CA'') then (select "Payment_Mode_Name" from payment_mode_mast where "Pay_Mode_Code"=o.reason)
            else
            (select "reason_name" from reason_mst where "reason_code"=o.reason)  
            end reason_name,'||v_var||', o.amount amount from agency_mast m,ad_outstand o ,branch_mst b
            where o.comp_code='||''''||pcompcode||''''||' and o.doctype<>''BILL'' and o.unit=b."Branch_Code" and (o.unit='||''''||punitcode||''''||' or '||''''||punitcode||''''||' is null) and  
              o.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and o.ag_main_code=m."Agency_Code" and 
              (o.ag_main_code='||''''||pagency_code||''''||' or '||''''||pagency_code||''''||' is null) and o.ag_sub_code=m."SUB_Agency_Code" and 
              (o.ag_sub_code='||''''||pagency_subcode||''''||' or '||''''||pagency_subcode||''''||' is null) and
              (o.retainer_code='||''''||pretain_code||''''||' or '||''''||pretain_code||''''||' is null) and (o.exec_code='||''''||pexec_code||''''||' or '||''''||pexec_code||''''||' is null) and
              (b."pub_center"='||''''||pcenter||''''||' or '||''''||pcenter||''''||' is null) and (m.district ='||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and (m.state ='||''''||pstatecode||''''||' or '||''''||pstatecode||''''||' is null)
              and (m."region" ='||''''||pregioncode||''''||' or '||''''||pregioncode||''''||' is null) and (m."zone_code" ='||''''||pzonecode||''''||' or '||''''||pzonecode||''''||' is null)) x
            group by x.comp_code,x.reason,x.reason_name
            order by comp_code,reason_name';        
        
        end if;
        
        --delete test1;insert into test1(vstring,vstring2) values('rpt_reasonwise_summ',v_query);commit;
        
        open p_accounts for v_query;
        
        if v_var is null then
            v_query:='select distinct x.comp_code comp_code,
            sum(x.amount) TOTAL from(select o.comp_code comp_code,o.doctype doctype, o.reason reason,
            case when o.doctype in(''RCR'',''RCP'',''CA'') then (select "Payment_Mode_Name" from payment_mode_mast where "Pay_Mode_Code"=o.reason)
            else
            (select "reason_name" from reason_mst where "reason_code"=o.reason)  
            end reason_name, o.amount amount from agency_mast m,ad_outstand o ,branch_mst b
            where o.comp_code='||''''||pcompcode||''''||' and o.doctype<>''BILL'' and o.unit=b."Branch_Code" and (o.unit='||''''||punitcode||''''||' or '||''''||punitcode||''''||' is null) and  
              o.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and o.ag_main_code=m."Agency_Code" and 
              (o.ag_main_code='||''''||pagency_code||''''||' or '||''''||pagency_code||''''||' is null) and o.ag_sub_code=m."SUB_Agency_Code" and 
              (o.ag_sub_code='||''''||pagency_subcode||''''||' or '||''''||pagency_subcode||''''||' is null) and
              (o.retainer_code='||''''||pretain_code||''''||' or '||''''||pretain_code||''''||' is null) and (o.exec_code='||''''||pexec_code||''''||' or '||''''||pexec_code||''''||' is null) and
              (b."pub_center"='||''''||pcenter||''''||' or '||''''||pcenter||''''||' is null) and (m.district ='||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and (m.state ='||''''||pstatecode||''''||' or '||''''||pstatecode||''''||' is null)
              and (m."region" ='||''''||pregioncode||''''||' or '||''''||pregioncode||''''||' is null) and (m."zone_code" ='||''''||pzonecode||''''||' or '||''''||pzonecode||''''||' is null)) x
            group by x.comp_code
            order by comp_code';
        else
            v_query:='select distinct x.comp_code comp_code,
            '||v_var_sum||',sum(x.amount) TOTAL from(select o.comp_code comp_code,o.doctype doctype, o.reason reason,
            case when o.doctype in(''RCR'',''RCP'',''CA'') then (select "Payment_Mode_Name" from payment_mode_mast where "Pay_Mode_Code"=o.reason)
            else
            (select "reason_name" from reason_mst where "reason_code"=o.reason)  
            end reason_name,'||v_var||', o.amount amount from agency_mast m,ad_outstand o ,branch_mst b
            where o.comp_code='||''''||pcompcode||''''||' and o.doctype<>''BILL'' and o.unit=b."Branch_Code" and (o.unit='||''''||punitcode||''''||' or '||''''||punitcode||''''||' is null) and  
              o.recptdt between '||''''||v_frdt||''''||' and '||''''||v_todt||''''||' and o.ag_main_code=m."Agency_Code" and 
              (o.ag_main_code='||''''||pagency_code||''''||' or '||''''||pagency_code||''''||' is null) and o.ag_sub_code=m."SUB_Agency_Code" and 
              (o.ag_sub_code='||''''||pagency_subcode||''''||' or '||''''||pagency_subcode||''''||' is null) and
              (o.retainer_code='||''''||pretain_code||''''||' or '||''''||pretain_code||''''||' is null) and (o.exec_code='||''''||pexec_code||''''||' or '||''''||pexec_code||''''||' is null) and
              (b."pub_center"='||''''||pcenter||''''||' or '||''''||pcenter||''''||' is null) and (m.district ='||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and (m.state ='||''''||pstatecode||''''||' or '||''''||pstatecode||''''||' is null)
              and (m."region" ='||''''||pregioncode||''''||' or '||''''||pregioncode||''''||' is null) and (m."zone_code" ='||''''||pzonecode||''''||' or '||''''||pzonecode||''''||' is null)) x
            group by x.comp_code
            order by comp_code';
        end if;

        --insert into test1(vstring,vstring2) values('rpt_reasonwise_summ2',v_query);commit;

        open p_accounts1 for v_query;
        
        open p_accounts2 for select sysdate as "CUR_DATE" FROM DUAL;

        
End rpt_reasonwise_summ;
/
/****************************** 20-dec-2011***********/








**********************************************************************************************issue 5717*****************************************************************************



CREATE OR REPLACE PACKAGE HT18JULY.cir_rep_billing IS
  type t_accounts is ref cursor;
  procedure cir_billing_agency_list_p(
    pcomp_code         in varchar2,
    punit_code       in varchar2,
    ppubl            in varchar2,
    pfrom_billdt     in varchar2,
    ptill_billdt     in varchar2,
    pdateformat      in varchar2,
    pextra1          in varchar2,
    pextra2          in varchar2,
    p_accounts       out t_accounts);

  procedure cir_billno_list_p(
    pcomp_code         in varchar2,
    punit_code       in varchar2,
    ppubl            in varchar2,
    pbillagcd        in varchar2,
    pbilldpcd        in varchar2,
    pbill_freq       in varchar2,
    pfrom_billdt     in varchar2,
    ptill_billdt     in varchar2,
    pdateformat      in varchar2,
    pextra1          in varchar2,
    pextra2          in varchar2,
    p_accounts       out t_accounts);

  procedure cir_bill_print_punya(
    pcomp_code       in varchar2,
    punit_code       in varchar2,
    ppubl            in varchar2,
    pbill_freq       in varchar2,
    pfrom_billdt     in varchar2,
    ptill_billdt     in varchar2,
    pfrom_billno     in varchar2,
    ptill_billno     in varchar2,
    pbillagcd        in varchar2,
    pbilldpcd        in varchar2,
    pbranchcode      in varchar2,
    pdistcode        in varchar2,  
    ptalukacode      in varchar2,
    pcitycode        in varchar2,
    pdateformat      in varchar2,
    pextra1          in varchar2,
    pextra2          in varchar2,
    p_accounts       out t_accounts,
    p_accounts1      out t_accounts,
    p_accounts2      out t_accounts,
    p_accounts3      out t_accounts,
    p_accounts4      out t_accounts,
    p_accounts5      out t_accounts,
    p_accounts6      out t_accounts,
    p_accounts7      out t_accounts,
    p_accounts8      out t_accounts,
    p_accounts9      out t_accounts,
    p_accounts10     out t_accounts,
    p_accounts11     out t_accounts,
    p_accounts12     out t_accounts);  
  
  procedure cir_bill_print_bhaskar(
    pcomp_code       in varchar2,
    punit_code       in varchar2,
    ppubl            in varchar2,
    pbill_freq       in varchar2,
    pfrom_billdt     in varchar2,
    ptill_billdt     in varchar2,
    pfrom_billno     in varchar2,
    ptill_billno     in varchar2,
    pbillagcd        in varchar2,
    pbilldpcd        in varchar2,
    pdateformat      in varchar2,
    pextra1          in varchar2,
    pextra2          in varchar2,
    p_accounts       out t_accounts,
    p_accounts1      out t_accounts,
    p_accounts2      out t_accounts,
    p_accounts3      out t_accounts,
    p_accounts4      out t_accounts,
    p_accounts5      out t_accounts,
    p_accounts6      out t_accounts,
    p_accounts7      out t_accounts,
    p_accounts8      out t_accounts,
    p_accounts9      out t_accounts,
    p_accounts10     out t_accounts,
    p_accounts11     out t_accounts,
    p_accounts12     out t_accounts);

  procedure cir_before_bill_print_p1(
    pcompcode        in varchar2,
    punitcode        in varchar2,
    ppubl_freq       in varchar2,
    ppubl            in varchar2,
    pagencytype      in varchar2,
    pagencyclass     in varchar2,
    pbranchcode      in varchar2,
    pdistcode        in varchar2,
    ptaluka          in varchar2,
    pbillagcd        in varchar2,
    pbilldpcd        in varchar2,
    pfrom_date       in varchar2,
    ptill_date       in varchar2,
    plangtype        in varchar2,
    pdateformat      in varchar2,
    pextra1          in varchar2,
    pextra2          in varchar2,
    p_accounts       out t_accounts,
    p_accounts1      out t_accounts,
    p_accounts2      out t_accounts,
    p_accounts3      out t_accounts,
    p_accounts4      out t_accounts,
    p_accounts5      out t_accounts,
    p_accounts6      out t_accounts,
    p_accounts7      out t_accounts,
    p_accounts8      out t_accounts,
    p_accounts9      out t_accounts,
    p_accounts10     out t_accounts);

  procedure cir_before_bill_print_p2(
    pcompcode        in varchar2,
    punitcode        in varchar2,
    ppubl_freq       in varchar2,
    ppubl            in varchar2,
    pagencytype      in varchar2,
    pagencyclass     in varchar2,
    pbranchcode      in varchar2,
    pdistcode        in varchar2,
    ptaluka          in varchar2,
    pbillagcd        in varchar2,
    pbilldpcd        in varchar2,
    pfrom_date       in varchar2,
    ptill_date       in varchar2,
    plangtype        in varchar2,
    pdateformat      in varchar2,
    pextra1          in varchar2,
    pextra2          in varchar2,
    p_accounts       out t_accounts,
    p_accounts1      out t_accounts,
    p_accounts2      out t_accounts,
    p_accounts3      out t_accounts,
    p_accounts4      out t_accounts,
    p_accounts5      out t_accounts,
    p_accounts6      out t_accounts,
    p_accounts7      out t_accounts,
    p_accounts8      out t_accounts,
    p_accounts9      out t_accounts,
    p_accounts10     out t_accounts);
        
  procedure cir_bill_register_p(
    pcomp_code      in varchar2,
    punit_code      in varchar2,
    ppubl           in varchar2,
    repty           in varchar2,
    pbill_freq      in varchar2,
    pfrom_billdt    in varchar2,
    ptill_billdt    in varchar2,
    pbillagcd       in varchar2,
    pbilldpcd       in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    p_accounts      out t_accounts);

  procedure cir_billing_outstanding_p(
    pcomp_code      in varchar2,
    punit_code      in varchar2,
    repty           in varchar2,
    pbill_freq      in varchar2,
    pfrom_billdt    in varchar2,
    ptill_billdt    in varchar2,
    ppubl           in varchar2,
    pbillagcd       in varchar2,
    pbilldpcd       in varchar2,
    pdateformat     in varchar2,
    pbrancode       in varchar2,
    pdistcode       in varchar2,
    pagclass        in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    p_accounts      out t_accounts,
    p_accounts1     out t_accounts);

  procedure cir_unitwise_p(
    pcomp_code      in varchar2,
    punit_code      in varchar2,
    ppubl_code      in varchar2,
    pbill_freq      in varchar2,
    pfrom_billdt    in varchar2,
    ptill_billdt    in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    p_accounts      out t_accounts);

  procedure cir_billing_rate_p (
    pcomp_code      in varchar2,
    punit_code      in varchar2,
    ppubl           in varchar2,
    pagcd           in varchar2,
    pdpcd           in varchar2,
    BILLNO_FROM     in varchar2,
    BILLNO_TO       in varchar2,
    pfrom_billdt    in varchar2,
    ptill_billdt    in varchar2,
    pdateformat     in varchar2,  
    pextra1         in varchar2,
    pextra2         in varchar2,
    p_accounts      out t_accounts,
    p_accounts1     out t_accounts,
    p_accounts2     out t_accounts,
    p_accounts3     out t_accounts);

  Procedure cir_before_bill_process_p(
      pcomp_code         in varchar2,
    punit_code         in varchar2,
    ppubl_freq         in varchar2,
    ppubl             in varchar2,
    pfrdt             in varchar2,
    ptodt             in varchar2,
    pbillagcd       in varchar2,
    pbilldpcd       in varchar2,
    pagencytype     in varchar2,
    pagencyclass    in varchar2,
    pbranchcode     in varchar2,
    pdistcode       in varchar2,
    ptaluka         in varchar2,
    pdateformat     in varchar2,
    puserid         in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2);

procedure cir_weekly_bill_summary_p(
    pcomp_code      in varchar2,
    punit_code      in varchar2,
    repty           in varchar2,
    pbill_freq      in varchar2,
    pfrom_billdt    in varchar2,
    ptill_billdt    in varchar2,
    ppubl           in varchar2,
    pbillagcd       in varchar2,
    pbilldpcd       in varchar2,
    pdateformat     in varchar2,
    pbrancode       in varchar2,
    pdistcode       in varchar2,
    pagclass        in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    p_accounts      out t_accounts,
    p_accounts1     out t_accounts);    
End cir_rep_billing;
/








CREATE OR REPLACE PACKAGE BODY HT18JULY.cir_rep_billing IS
  procedure cir_billing_agency_list_p(
      pcomp_code        in varchar2,
      punit_code        in varchar2,
      ppubl             in varchar2,
      pfrom_billdt      in varchar2,
      ptill_billdt      in varchar2,
      pdateformat       in varchar2,
      pextra1           in varchar2,
      pextra2           in varchar2,
      p_accounts        out t_accounts)
    As
        v_bill_frdt date;
        v_bill_todt date;
    Begin
        v_bill_frdt    :=to_date(pfrom_billdt,''''||pdateformat||'''');
        v_bill_todt    :=to_date(ptill_billdt,''''||pdateformat||'''');

        open p_accounts for
        select distinct a.agcd agcd,a.dpcd dpcd,a.ag_name ag_name,a.ag_name_oth_lang ag_name_oth_lang,a.city_code city_code,cir_get_city(a.comp_code,a.city_code) city_name,a.tehsil_taluka tehsil_taluka,
        cir_get_taluka(a.comp_code,a.tehsil_taluka) taluka_name
        from cir_agmast a,cir_bill_det b
        where a.comp_code=pcomp_code and a.comp_code=b.comp_code and a.unit=b.unit_code and a.unit=punit_code and 
              b.billdt >=v_bill_frdt and b.billdt<=v_bill_todt and a.agcd=b.agcd and a.dpcd=b.dpcd and b.publ=nvl(ppubl,b.publ) and 
              ((upper(a.ag_name) like upper(pextra1)||'%') or (pextra1 is null))
        union
        select distinct a.agcd agcd,a.dpcd dpcd,a.ag_name ag_name,a.ag_name_oth_lang ag_name_oth_lang,a.city_code city_code,cir_get_city(a.comp_code,a.city_code) city_name,a.tehsil_taluka tehsil_taluka,
        cir_get_taluka(a.comp_code,a.tehsil_taluka) taluka_name
        from cir_agmast a,cir_bill_det b
        where a.comp_code=pcomp_code and a.comp_code=b.comp_code and a.unit=b.unit_code and a.unit=punit_code and 
              b.billdt >=v_bill_frdt and b.billdt<=v_bill_todt and a.agcd=b.agcd and a.dpcd=b.dpcd and b.publ=nvl(ppubl,b.publ) and 
              upper(a.agcd) = upper(pextra1)
        order by ag_name,city_name;

    End cir_billing_agency_list_p;

    procedure cir_billno_list_p(
      pcomp_code        in varchar2,
      punit_code        in varchar2,
      ppubl             in varchar2,
      pbillagcd         in varchar2,
      pbilldpcd         in varchar2,
      pbill_freq        in varchar2,
      pfrom_billdt      in varchar2,
      ptill_billdt      in varchar2,
      pdateformat       in varchar2,
      pextra1           in varchar2,--for agency Type
      pextra2           in varchar2,--for Agency Class
      p_accounts        out t_accounts)
    As
      v_bill_frdt date;
      v_bill_todt date;
    Begin
      v_bill_frdt    :=to_date(pfrom_billdt,''''||pdateformat||'''');
      v_bill_todt    :=to_date(ptill_billdt,''''||pdateformat||'''');
      
      open p_accounts for
        select min(d.billno) MIN_BILLNO,max(d.billno) MAX_BILLNO from cir_bill_det d,cir_agmast m
            where d.comp_code=m.comp_code and d.comp_code=pcomp_code and d.unit_code=punit_code and d.unit_code=m.unit and 
            d.billdt >= v_bill_frdt and d.billdt<=v_bill_todt and
            d.agcd=m.agcd and d.agcd=nvl(pbillagcd,d.agcd) and d.dpcd=m.dpcd and d.dpcd=nvl(pbilldpcd,d.dpcd) and 
            d.publ=nvl(ppubl,d.publ) and d.bill_flag=nvl(pbill_freq,d.bill_flag) and (m.ag_type=pextra1 or pextra1 is null)
            and (m.ag_class=pextra2 or pextra2 is null);
            
    End cir_billno_list_p;
 /*
set serveroutput on;
var v1 refcursor;
var v2 refcursor;
var v3 refcursor;
var v4 refcursor;
var v5 refcursor;
var v6 refcursor;
var v7 refcursor;
var v8 refcursor;
var v9 refcursor;
var v10 refcursor;
var v11 refcursor;
var v12 refcursor;
var v13 refcursor;
exec cir_rep_billing.cir_bill_print_punya('SP002','AUR','','M','01-jul-2011','31-jul-2011','AUR1107114','AUR1107114','L0012','0001','','','','','dd/mm/yyyy','','',:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11,:v12,:v13);
--*/

  procedure cir_bill_print_punya(
      pcomp_code      in varchar2,
      punit_code      in varchar2,
      ppubl           in varchar2,
      pbill_freq      in varchar2,
      pfrom_billdt    in varchar2,
      ptill_billdt    in varchar2,
      pfrom_billno    in varchar2,
      ptill_billno    in varchar2,
      pbillagcd       in varchar2,
      pbilldpcd       in varchar2,
      pbranchcode     in varchar2,
      pdistcode       in varchar2,  
      ptalukacode     in varchar2,
      pcitycode       in varchar2,
      pdateformat     in varchar2,
      pextra1         in varchar2,
      pextra2         in varchar2,
      p_accounts      out t_accounts,
      p_accounts1     out t_accounts,
      p_accounts2     out t_accounts,
      p_accounts3     out t_accounts,
      p_accounts4     out t_accounts,
      p_accounts5     out t_accounts,
      p_accounts6     out t_accounts,
      p_accounts7     out t_accounts,
      p_accounts8     out t_accounts,
      p_accounts9     out t_accounts,
      p_accounts10    out t_accounts,
      p_accounts11    out t_accounts,
      p_accounts12    out t_accounts)
    As
      v_bill_frdt     date;
      v_bill_todt     date;
      v_dt            date;
      v_query1        varchar2(32000);
      v_query2        varchar2(32000);
    cursor cur_bill is
        select distinct a.comp_code comp_code,a.unit_code unit_code,/*a.publ,*/a.agcd agcd,a.dpcd dpcd,a.billno billno,a.billdt billdt,
        min(a.bill_frdt) frdt,max(a.bill_todt) todt,nvl(sum(bill_sec_amt),0) bill_sec_amt  
        from cir_bill a,cir_agmast b
                where a.comp_code=pcomp_code and a.comp_code=b.comp_code and a.unit_code=punit_code and a.unit_code=b.unit and 
                    a.agcd=b.agcd and a.dpcd=b.dpcd and ((a.billno between pfrom_billno and ptill_billno) or (pfrom_billno is null)) and
                    a.billdt >= v_bill_frdt and a.billdt<=v_bill_todt and
                    /*((a.publ=ppubl) or (ppubl is null)) and*/ a.agcd=nvl(pbillagcd,a.agcd) and
                    a.dpcd=nvl(pbilldpcd,a.dpcd) and a.branch_code=nvl(pbranchcode,a.branch_code) and 
                    (b.dist_code =pdistcode or pdistcode is null) and (b.tehsil_taluka =ptalukacode or ptalukacode is null) and 
                    (b.city_code =pcitycode or pcitycode is null) and a.bill_flag=pbill_freq and nvl(a.bill_copy,0)>0 
            group by a.comp_code,a.unit_code,/*a.publ,*/a.agcd,a.dpcd,a.billno,a.billdt
            order by comp_code,unit_code,/*publ,*/billdt,billno,agcd,dpcd;
rec_bill cur_bill%rowtype;

    cursor cur_det is
        select distinct publ,edtn from cir_bill_det
        where comp_code=rec_bill.comp_code and unit_code=rec_bill.unit_code and billdt=rec_bill.billdt and billno=rec_bill.billno and
              agcd=rec_bill.agcd and dpcd=rec_bill.dpcd
        union
        select distinct publ,edtn
        from cir_unsold_dtl 
        where comp_code=rec_bill.comp_code and unit_code=rec_bill.unit_code and 
              recptdt>=v_bill_frdt and recptdt<=v_bill_todt and agcd=rec_bill.agcd and dpcd=rec_bill.dpcd and (nvl(apr_late_recpt,0)+nvl(apr_short_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0
              order by publ,edtn;
rec_det cur_det%rowtype;
              
    cursor cur_dbksup is
        select comp_code,unit_code,publ,edtn,supdate,copy_rate,
        sum(supply_copy) supply_copy from(select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,d.edtn edtn,d.supdate supdate,d.sup_rate copy_rate,
        sum(d.sup_copy) supply_copy
        from cir_dbksup d,cir_supply_type_mast t 
        where d.comp_code=rec_bill.comp_code and d.comp_code=t.comp_code and d.unit_code=rec_bill.unit_code and d.publ=rec_det.publ and d.edtn=rec_det.edtn and
              d.supdate=v_dt and d.sup_type_code=t.sup_ty_code and upper(t.bill_pay)='Y' and d.billagcd=rec_bill.agcd and 
              d.billdpcd=rec_bill.dpcd and nvl(d.sup_copy,0)>0
        group by d.comp_code,d.unit_code,d.publ,d.edtn,d.supdate,d.sup_rate
        union all
        select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,d.edtn edtn,d.supdate supdate,d.sup_rate copy_rate,
        sum(d.sup_copy) supply_copy
        from cir_dbksup_resale d,cir_supply_type_mast t 
        where d.comp_code=rec_bill.comp_code and d.comp_code=t.comp_code and d.unit_code=rec_bill.unit_code and d.publ=rec_det.publ and d.edtn=rec_det.edtn and
              d.supdate=v_dt and d.sup_type_code=t.sup_ty_code and upper(t.bill_pay)='Y' and d.billagcd=rec_bill.agcd and 
              d.billdpcd=rec_bill.dpcd and nvl(d.sup_copy,0)>0
        group by d.comp_code,d.unit_code,d.publ,d.edtn,d.supdate,d.sup_rate
        union all
        (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,d.edtn edtn,d.supdate supdate,d.sup_rate copy_rate,
        0 supply_copy
        from cir_dbksup d,cir_supply_type_mast t 
        where d.comp_code=rec_bill.comp_code and d.comp_code=t.comp_code and d.unit_code=rec_bill.unit_code and d.publ=rec_det.publ and d.edtn=rec_det.edtn and
              d.supdate=v_dt and d.sup_type_code=t.sup_ty_code and upper(t.bill_pay)='Y' and d.billagcd=rec_bill.agcd and 
              d.billdpcd=rec_bill.dpcd and nvl(d.sup_copy,0)>0
        group by d.comp_code,d.unit_code,d.publ,d.edtn,d.supdate,d.sup_rate
        minus
        select comp_code comp_code,unit_code unit_code,publ publ,edtn edtn,recptdt supdate,copy_rate copy_rate,
        0 supply_copy
        from cir_unsold_dtl 
        where comp_code=rec_bill.comp_code and unit_code=rec_bill.unit_code and publ=rec_det.publ and edtn=rec_det.edtn and
              recptdt=v_dt and agcd=rec_bill.agcd and dpcd=rec_bill.dpcd and (nvl(apr_late_recpt,0)+nvl(apr_short_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0
    group by comp_code,unit_code,recptdt,publ,edtn,copy_rate))
    group by comp_code,unit_code,publ,edtn,supdate,copy_rate
    order by comp_code,unit_code,publ,edtn,supdate;
rec_dbksup cur_dbksup%rowtype;

    cursor cur_unsold is
        select comp_code,unit_code,publ,edtn,recptdt,copy_rate,sum(nvl(apr_late_recpt,0)+nvl(apr_short_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0)) return_copy
        from cir_unsold_dtl
        where comp_code=rec_bill.comp_code and unit_code=rec_bill.unit_code and publ=rec_det.publ and edtn=rec_det.edtn and
              recptdt=v_dt and agcd=rec_bill.agcd and dpcd=rec_bill.dpcd and (nvl(apr_late_recpt,0)+nvl(apr_short_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0
    group by comp_code,unit_code,recptdt,publ,edtn,copy_rate
    order by comp_code,unit_code,recptdt,publ,edtn,copy_rate;
rec_unsold cur_unsold%rowtype;

      cursor cur_publ_edtn is
            select distinct a.comp_code comp_code,a.unit_code unit_code,a.publ publ_code,b.publ_name publ_name,a.edtn edtn,c.edtn_name edtn_name,
            substr(c.edition_nick,1,5) edtn_nick
            from cir_bill_det a,cir_publ_mast b,cir_edtn_mast c,cir_agmast d 
        where a.comp_code=pcomp_code and a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=d.comp_code and a.unit_code=punit_code and a.unit_code=d.unit and 
        a.billdt >= v_bill_frdt and a.billdt<=v_bill_todt and
        ((a.billno between pfrom_billno and ptill_billno) or (pfrom_billno is null)) and
        a.agcd=d.agcd and a.agcd=nvl(pbillagcd,a.agcd) and a.dpcd=d.dpcd and a.dpcd=nvl(pbilldpcd,a.dpcd) and
        a.publ=nvl(ppubl,a.publ) and a.publ=b.publ and a.publ=c.publ and a.edtn=c.edtn and  
        a.branch_code=nvl(pbranchcode,a.branch_code) and (d.dist_code =pdistcode or pdistcode is null) and 
        (d.tehsil_taluka =ptalukacode or ptalukacode is null) and (d.city_code =pcitycode or pcitycode is null)
        union
        select distinct a.comp_code comp_code,a.unit_code unit_code,a.publ publ_code,b.publ_name publ_name,a.edtn edtn,c.edtn_name edtn_name,
            substr(c.edition_nick,1,5) edtn_nick
            from cir_unsold_dtl a,cir_publ_mast b,cir_edtn_mast c,cir_agmast d 
        where a.comp_code=pcomp_code and a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=d.comp_code and a.unit_code=punit_code and a.unit_code=d.unit and 
        a.recptdt >= v_bill_frdt and a.recptdt<=v_bill_todt and
        a.agcd=d.agcd and a.agcd=nvl(pbillagcd,a.agcd) and a.dpcd=d.dpcd and a.dpcd=nvl(pbilldpcd,a.dpcd) and
        a.publ=nvl(ppubl,a.publ) and a.publ=b.publ and a.publ=c.publ and a.edtn=c.edtn and  
        a.branch_code=nvl(pbranchcode,a.branch_code) and (d.dist_code =pdistcode or pdistcode is null) and 
        (d.tehsil_taluka =ptalukacode or ptalukacode is null) and (d.city_code =pcitycode or pcitycode is null) and
        (nvl(a.apr_late_recpt,0)+nvl(a.apr_short_recpt,0)+nvl(a.apr_bnr,0)+nvl(a.apr_unsold,0))>0
        order by comp_code,unit_code,publ_code,edtn;

        v1 cur_publ_edtn%rowtype;

        v_edtn_cnt        number(5):=0;
        vvar              varchar2(8000);
        vvar_name         varchar2(8000);
        vvar1             varchar2(8000);
        vvar2             varchar2(8000);
        vvar3             varchar2(8000);
        vvar33            varchar2(8000);
        vvar4             varchar2(8000);
        vvar5             varchar2(8000);
        vvar6             varchar2(8000);
        vvar7             varchar2(8000);
        vvar8             varchar2(8000);
        vvar11            varchar2(8000);
        sum_vvar          varchar2(8000);
        sum_vvar1         varchar2(8000);
        sum_vvar2         varchar2(8000);
        sum_vvar3         varchar2(8000);
        sum_vvar33        varchar2(8000);
        sum_vvar4         varchar2(8000);
        sum_vvar5         varchar2(8000);
        sum_vvar6         varchar2(8000);
        sum_vvar7         varchar2(8000);
        sum_vvar8         varchar2(8000);
        sum_vvar11        varchar2(8000);
        vtot_publ         varchar2(8000);
        v_cnt             number:=0;
        v_return_copy     number;
        v_return_amt      number(14,2):=0;
        v_gross_amt       number(14,2):=0;
        v_comm_rate       number;
        v_comm_amt        number(14,2):=0;
        v_sur_rate        number;
        v_sur_amt         number(14,2):=0;
        v_opdate          date;
        v_opbal           number(14,2):=0;
        v_billamt         number(14,2):=0;
        v_dbcramt         number(14,2):=0;
        v_dbamt           number(14,2):=0;
        v_cramt           number(14,2):=0;
        v_recamt          number(14,2):=0;
        v_sec_opbal        number(14,2):=0;
        v_sec_pbal       number(14,2):=0;
        v_sec_rcpt        number(14,2):=0;
        v_sec_dn          number(14,2):=0;
    cursor cur_exist_edtn is
        select distinct a.comp_code comp_code,a.unit_code unit_code,a.billno billno,a.billdt billdt,a.edtn edtn 
        from cir_bill_det a,cir_agmast b
            where a.comp_code=pcomp_code and a.comp_code=b.comp_code and a.unit_code=punit_code and a.unit_code=b.unit and 
                a.billdt >= v_bill_frdt and a.billdt<=v_bill_todt and
                ((a.billno between pfrom_billno and ptill_billno) or (pfrom_billno is null)) and
                a.agcd=b.agcd and a.agcd=nvl(pbillagcd,a.agcd) and a.dpcd=b.dpcd and a.dpcd=nvl(pbilldpcd,a.dpcd) and a.branch_code=nvl(pbranchcode,a.branch_code) and 
                (b.dist_code =pdistcode or pdistcode is null) and (b.tehsil_taluka =ptalukacode or ptalukacode is null) and 
                (b.city_code =pcitycode or pcitycode is null) and 
                nvl(a.bill_copy,0)>0 and a.bill_flag=pbill_freq 
         union
        select distinct a.comp_code comp_code,a.unit_code unit_code,c.billno billno,c.billdt billdt,a.edtn edtn 
        from cir_unsold_dtl a,cir_agmast b,cir_bill c
            where a.comp_code=pcomp_code and a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.unit_code=punit_code and a.unit_code=b.unit and
            a.unit_code=c.unit_code and 
            a.recptdt >= v_bill_frdt and a.recptdt<=v_bill_todt and c.billdt >= v_bill_frdt and c.billdt<=v_bill_todt and
            ((c.billno between pfrom_billno and ptill_billno) or (pfrom_billno is null)) and
            a.agcd=b.agcd and a.agcd=c.agcd and a.agcd=nvl(pbillagcd,a.agcd) and a.dpcd=b.dpcd and a.dpcd=c.dpcd and a.dpcd=nvl(pbilldpcd,a.dpcd) and a.branch_code=nvl(pbranchcode,a.branch_code) and 
            (b.dist_code =pdistcode or pdistcode is null) and (b.tehsil_taluka =ptalukacode or ptalukacode is null) and 
            (b.city_code =pcitycode or pcitycode is null) and 
            (nvl(a.apr_late_recpt,0)+nvl(a.apr_short_recpt,0)+nvl(a.apr_bnr,0)+nvl(a.apr_unsold,0))>0 and 
            c.bill_flag=pbill_freq         
            order by comp_code,unit_code,billdt,billno;
    rec_exist_edtn cur_exist_edtn%rowtype;        
  Begin
        v_bill_frdt    :=to_date(pfrom_billdt,''''||pdateformat||'''');
        v_bill_todt    :=to_date(ptill_billdt,''''||pdateformat||'''');
        v_opdate       :=cir_get_finandt(pcomp_code,to_date(pfrom_billdt,''''||pdateformat||''''),pdateformat,'','');--for financial date

        --delete from test1;commit;

        delete from cir_bill_print where cur_sessionid=userenv('sessionid');
        delete from cir_bill_return_print where cur_sessionid=userenv('sessionid');
        delete from cir_temp_suppliment where sess_id=userenv('sessionid');
        delete from cir_temp_bill_collection where cur_sessionid=userenv('sessionid');
        delete from cir_temp_outstanding;
        
        Open cur_bill;---main cursor bill
        Loop
          fetch cur_bill into rec_bill;
          exit when cur_bill%notfound;

            v_dt:=rec_bill.frdt;
            Loop
              if v_dt>rec_bill.todt then
                exit;
              end if;
            open cur_det;
            loop
                fetch cur_det into rec_det;
                exit when cur_det%notfound;
                
                Open cur_dbksup;
                fetch cur_dbksup into rec_dbksup;
                if cur_dbksup%notfound then

                    /*select sum(nvl(apr_late_recpt,0)+nvl(apr_short_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0)) into v_return_copy
                    from cir_unsold_dtl
                    where comp_code=rec_bill.comp_code and unit_code=rec_bill.unit_code and doctype='UCN' and
                          recptdt=rec_dbksup.supdate and publ=rec_det.publ and edtn=rec_det.edtn and agcd=rec_bill.agcd and
                          dpcd=rec_bill.dpcd and copy_rate=rec_dbksup.copy_rate and (nvl(apr_late_recpt,0)+nvl(apr_short_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0;*/
                    begin
                        select max(comm_rate) comm_rate,max(sur_rate) sur_rate into v_comm_rate,v_sur_rate from cir_bill_det
                            where comp_code=rec_bill.comp_code and unit_code=rec_bill.unit_code and
                              billdt between v_bill_frdt and v_bill_todt and agcd=rec_bill.agcd and dpcd=rec_bill.dpcd and  
                              publ=rec_det.publ and edtn=rec_det.edtn;
                    exception when others then
                        v_comm_rate   :=0;v_sur_rate    :=0;
                    end;
                    v_gross_amt   :=0;
                    v_comm_amt    :=0;
                    v_sur_amt     :=0;

                    insert into cir_bill_print(comp_code,unit_code,billno,billdt,publ_code,edtn_code,agcd,dpcd,
                                               supply_date,supply_copy,supply_rate,gross_amt,comm_rate,comm_amt,sur_rate,sur_amt,
                                               return_copy,return_amt,cur_sessionid)
                     values(rec_bill.comp_code,rec_bill.unit_code,rec_bill.billno,rec_bill.billdt,rec_det.publ,rec_det.edtn,rec_bill.agcd,rec_bill.dpcd,
                                 v_dt,0,0,v_gross_amt,v_comm_rate,v_comm_amt,v_sur_rate,v_sur_amt,
                                 nvl(v_return_copy,0),nvl(v_return_amt,0),userenv('sessionid'));
                                 v_return_copy:=0;v_return_amt:=0;
                else
                    /*select sum(nvl(apr_late_recpt,0)+nvl(apr_short_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0)) into v_return_copy
                    from cir_unsold_dtl
                    where comp_code=rec_bill.comp_code and unit_code=rec_bill.unit_code and doctype='UCN' and
                          recptdt=rec_dbksup.supdate and publ=rec_det.publ and edtn=rec_det.edtn and agcd=rec_bill.agcd and
                          dpcd=rec_bill.dpcd and copy_rate=rec_dbksup.copy_rate and (nvl(apr_late_recpt,0)+nvl(apr_short_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0;*/
                    begin
                        select comm_rate,sur_rate into v_comm_rate,v_sur_rate from cir_bill_det
                            where comp_code=rec_bill.comp_code and unit_code=rec_bill.unit_code and
                              billdt >= v_bill_frdt and billdt<=v_bill_todt and billdt=rec_bill.billno and
                              agcd=rec_bill.agcd and dpcd=rec_bill.dpcd and 
                              publ=rec_dbksup.publ and edtn=rec_dbksup.edtn and
                              rec_dbksup.supdate >= fromdt and rec_dbksup.supdate<=todt;
                    exception when others then
                        v_comm_rate   :=0;v_sur_rate    :=0;
                    end;
                    
                        v_gross_amt   :=nvl(round((rec_dbksup.supply_copy*rec_dbksup.copy_rate),2),0);
                        v_comm_amt    :=nvl(round((rec_dbksup.supply_copy*(v_comm_rate/100)),2),0);
                        v_sur_amt     :=nvl(round((rec_dbksup.supply_copy*v_sur_rate),2),0);
                    

                    insert into cir_bill_print(comp_code,unit_code,billno,billdt,publ_code,edtn_code,agcd,dpcd,
                                               supply_date,supply_copy,supply_rate,gross_amt,comm_rate,comm_amt,sur_rate,sur_amt,
                                               return_copy,return_amt,cur_sessionid)
                     values(rec_bill.comp_code,rec_bill.unit_code,rec_bill.billno,rec_bill.billdt,rec_dbksup.publ,rec_dbksup.edtn,rec_bill.agcd,rec_bill.dpcd,
                                 rec_dbksup.supdate,rec_dbksup.supply_copy,rec_dbksup.copy_rate,v_gross_amt,v_comm_rate,v_comm_amt,v_sur_rate,v_sur_amt,
                                 nvl(v_return_copy,0),nvl(v_return_amt,0),userenv('sessionid'));
                                 v_return_copy:=0;v_return_amt:=0;
                end if;
            Close cur_dbksup;
            
            
            Open cur_unsold;
            loop
                fetch cur_unsold into rec_unsold;
                exit when cur_unsold%notfound;
                
                    insert into cir_bill_return_print(comp_code,unit_code,billno,billdt,publ_code,edtn_code,agcd,dpcd,
                                               receipt_date,return_copy,supply_rate,gross_amt,comm_rate,comm_amt,sur_rate,sur_amt,
                                               cur_sessionid)
                     values(rec_bill.comp_code,rec_bill.unit_code,rec_bill.billno,rec_bill.billdt,rec_det.publ,rec_det.edtn,rec_bill.agcd,rec_bill.dpcd,
                                 rec_unsold.recptdt,rec_unsold.return_copy,rec_unsold.copy_rate,0,0,0,0,0,
                                 userenv('sessionid'));
                                 
                                 v_return_copy:=nvl(v_return_copy,0)+nvl(rec_unsold.return_copy,0);
                                 
                                 rec_unsold.recptdt:=null;rec_unsold.return_copy:=null;rec_unsold.copy_rate:=null;
                    

                    
            end loop;
            Close cur_unsold;
            if nvl(v_return_copy,0)=0 then
                insert into cir_bill_return_print(comp_code,unit_code,billno,billdt,publ_code,edtn_code,agcd,dpcd,
                                           receipt_date,return_copy,supply_rate,gross_amt,comm_rate,comm_amt,sur_rate,sur_amt,
                                           cur_sessionid)
                 values(rec_bill.comp_code,rec_bill.unit_code,rec_bill.billno,rec_bill.billdt,rec_det.publ,rec_det.edtn,rec_bill.agcd,rec_bill.dpcd,
                             v_dt,0,0,0,0,0,0,0,
                             userenv('sessionid'));     
                    
            end if;
            v_return_copy:=0;v_return_amt:=0;            
            
            End loop;
            close cur_det;
            
        v_dt:=v_dt+1;
        End Loop;--close loop for date

            v_opbal     :=cir_accounts.cir_agency_opbal(rec_bill.comp_code,rec_bill.unit_code,null,rec_bill.agcd,rec_bill.dpcd,v_opdate,'NM',pdateformat,pextra1,pextra2);
            v_sec_opbal :=cir_accounts.cir_agency_opbal(rec_bill.comp_code,rec_bill.unit_code,null,rec_bill.agcd,rec_bill.dpcd,v_opdate,'SC',pdateformat,pextra1,pextra2);
            
            select sum(amount) into v_dbcramt from
            (select sum(amount) amount from cir_outmast
                where comp_code=rec_bill.comp_code and unit_code=rec_bill.unit_code and achd='NM' and doctyp='BIL' and 
                    billdt>= v_opdate and billdt<rec_bill.frdt and agcd=rec_bill.agcd and dpcd=rec_bill.dpcd 
            union all
            select sum(amount) amount from cir_rcphdr
                where comp_code=rec_bill.comp_code and unit_code=rec_bill.unit_code and achd='NM' and doctype<>'BIL' and 
                    recptdt>= v_opdate and recptdt<rec_bill.frdt and agcd=rec_bill.agcd and dpcd=rec_bill.dpcd);

            select sum(amount) into v_dbamt from cir_rcphdr
                where comp_code=rec_bill.comp_code and unit_code=rec_bill.unit_code and achd='NM' and 
                      recptdt>= rec_bill.frdt and recptdt<=rec_bill.billdt and agcd=rec_bill.agcd and dpcd=rec_bill.dpcd and 
                      amount>0;

            select sum(amount) into v_cramt from cir_rcphdr
                where comp_code=rec_bill.comp_code and unit_code=rec_bill.unit_code and doctype not in('RCR','UCN') and achd='NM' and 
                      recptdt>= rec_bill.frdt and recptdt<=rec_bill.billdt and agcd=rec_bill.agcd and dpcd=rec_bill.dpcd and 
                      amount<0;

            select sum(amount) into v_recamt from cir_rcphdr
                where comp_code=rec_bill.comp_code and unit_code=rec_bill.unit_code and doctype='RCR' and achd='NM' and 
                      recptdt>= rec_bill.frdt and recptdt<=rec_bill.billdt and agcd=rec_bill.agcd and dpcd=rec_bill.dpcd;

            v_opbal:=nvl(v_opbal,0)+nvl(v_dbcramt,0);
            
            select sum(amount) into v_sec_pbal from cir_rcphdr
                where comp_code=rec_bill.comp_code and unit_code=rec_bill.unit_code and achd='SC' and 
                recptdt>=v_opdate and recptdt<rec_bill.frdt and agcd=rec_bill.agcd and dpcd=rec_bill.dpcd;
            
            v_sec_pbal:=nvl(v_sec_pbal,0)+nvl(v_sec_opbal,0);
            
            select sum(amount) into v_sec_rcpt from cir_rcphdr
                where comp_code=rec_bill.comp_code and unit_code=rec_bill.unit_code and achd='SC' and doctype<>'DN' and 
                recptdt>=rec_bill.frdt and recptdt<=rec_bill.todt and agcd=rec_bill.agcd and dpcd=rec_bill.dpcd;
                      
            select sum(amount) into v_sec_dn from cir_rcphdr
                where comp_code=rec_bill.comp_code and unit_code=rec_bill.unit_code and achd='SC' and doctype='DN' and
                      recptdt>=rec_bill.frdt and recptdt<=rec_bill.todt and agcd=rec_bill.agcd and dpcd=rec_bill.dpcd;
            
            v_dbamt:=nvl(v_dbamt,0)-nvl(rec_bill.bill_sec_amt,0);

            
            insert into cir_temp_outstanding(comp_code,unit_code,dt,agname,publ_code,agcd,dpcd,dn_amt,cn_amt,rec_amt,op_amt,
            bill_amt,return_amt,country_code)
            values(rec_bill.comp_code,rec_bill.unit_code,rec_bill.billdt,rec_bill.billno,'',
            rec_bill.agcd,rec_bill.dpcd,v_dbamt,v_cramt,v_recamt,v_opbal,
            nvl(v_sec_rcpt,0),nvl(v_sec_pbal,0),v_sec_dn);
            
            insert into cir_temp_bill_collection(comp_code,unit_code,billno,billdt,remarks,cur_sessionid)
            values(rec_bill.comp_code,rec_bill.unit_code,rec_bill.billno,rec_bill.billdt,'',userenv('sessionid'));        
        End Loop;
        Close cur_bill;
        --delete from test1;delete searchtbl;commit;
    open cur_publ_edtn;
    loop
        fetch cur_publ_edtn into v1;
      exit when cur_publ_edtn%notfound;
          v_cnt :=nvl(v_cnt,0)+1;
        if vvar is null then
            vvar        :='decode(u.edtn_code,'||''''||v1.edtn||''''||',sum(u.supply_copy))"'||v1.edtn||'_SUPPLY"';
            --sum_vvar    :='nvl(sum("'||v1.edtn||'_SUPPLY"),0) "'||v1.edtn||'_SUPPLY",nvl(sum("'||v1.edtn||'_COPY_RATE"),0) "'||v1.edtn||'_COPY_RATE"';
            sum_vvar    :='nvl(sum("'||v1.edtn||'_SUPPLY"),0)||''#''||nvl(sum("'||v1.edtn||'_COPY_RATE"),0) "'||v1.edtn||'_SUPPLY"';
            vvar_name   :='decode(u.edtn_code,'||''''||v1.edtn||''''||','||''''||v1.edtn||''''||')"'||v1.edtn||'"';
            vvar1       :='decode(u.edtn_code,'||''''||v1.edtn||''''||','||''''||v1.edtn||''''||')"'||v1.edtn||'",decode(u.edtn_code,'||''''||v1.edtn||''''||',sum(u.supply_copy))"'||v1.edtn||'_TOT_SUPPLY"';
            sum_vvar1   :='nvl(sum("'||v1.edtn||'_TOT_SUPPLY"),0) "'||v1.edtn||'_TOT_SUPPLY"';
            vvar2       :='decode(u.edtn_code,'||''''||v1.edtn||''''||','||''''||v1.edtn||''''||')"'||v1.edtn||'",decode(u.edtn_code,'||''''||v1.edtn||''''||',sum(u.gross_amt))"'||v1.edtn||'_GROSS"';
            sum_vvar2   :='nvl(sum("'||v1.edtn||'_GROSS"),0) "'||v1.edtn||'_GROSS"';
            vvar3       :='decode(u.edtn_code,'||''''||v1.edtn||''''||','||''''||v1.edtn||''''||')"'||v1.edtn||'",decode(u.edtn_code,'||''''||v1.edtn||''''||',sum(u.return_copy))"'||v1.edtn||'_RETURN_COPY"';
            vvar33       :='decode(u.edtn_code,'||''''||v1.edtn||''''||','||''''||v1.edtn||''''||')"'||v1.edtn||'",decode(u.edtn_code,'||''''||v1.edtn||''''||',max(u.supply_rate))"'||v1.edtn||'_RETURN_RATE"';
            --sum_vvar3   :='nvl(max("'||v1.edtn||'_RETURN_RATE"),0) "'||v1.edtn||'_RETURN_RATE"||''#''||nvl(sum("'||v1.edtn||'_RETURN_COPY"),0) "'||v1.edtn||'_RETURN_COPY"';
            sum_vvar3   :='nvl(max("'||v1.edtn||'_RETURN_RATE"),0) ||''#''||nvl(sum("'||v1.edtn||'_RETURN_COPY"),0) "'||v1.edtn||'_RETURN_COPY"';
            --sum_vvar33   :='nvl(max("'||v1.edtn||'_RETURN_RATE"),0) "'||v1.edtn||'_RETURN_RATE"';
            vvar4       :='decode(u.edtn_code,'||''''||v1.edtn||''''||','||''''||v1.edtn||''''||')"'||v1.edtn||'",decode(u.edtn_code,'||''''||v1.edtn||''''||',sum(u.return_amt))"'||v1.edtn||'_RETURN_AMT"';
            sum_vvar4   :='nvl(sum("'||v1.edtn||'_RETURN_AMT"),0) "'||v1.edtn||'_RETURN_AMT"';
            vvar5       :='decode(u.edtn_code,'||''''||v1.edtn||''''||','||''''||v1.edtn||''''||')"'||v1.edtn||'",decode(u.edtn_code,'||''''||v1.edtn||''''||',sum(u.gross_amt-u.return_amt))"'||v1.edtn||'_TOTAL_AMT"';
            sum_vvar5   :='nvl(sum("'||v1.edtn||'_TOTAL_AMT"),0) "'||v1.edtn||'_TOTAL_AMT"';
            --vvar6       :='decode(u.edtn_code,'||''''||v1.edtn||''''||','||''''||v1.edtn_name||''''||')"'||v1.edtn_name||'",decode(u.edtn_code,'||''''||v1.edtn||''''||',sum(u.comm_amt))"'||v1.edtn||'_TOT_COMM"';
            vvar6       :='decode(u.edtn,'||''''||v1.edtn||''''||','||''''||v1.edtn||''''||')"'||v1.edtn||'",decode(u.edtn,'||''''||v1.edtn||''''||',sum(u.comm_amt))"'||v1.edtn||'_TOT_COMM"';
            sum_vvar6   :='nvl(sum("'||v1.edtn||'_TOT_COMM"),0) "'||v1.edtn||'_TOT_COMM"';
            vvar7       :='decode(u.edtn_code,'||''''||v1.edtn||''''||','||''''||v1.edtn||''''||')"'||v1.edtn||'",decode(u.edtn_code,'||''''||v1.edtn||''''||',sum(u.sur_amt))"'||v1.edtn||'_TOT_SURCHARGE"';
            sum_vvar7   :='nvl(sum("'||v1.edtn||'_TOT_SURCHARGE"),0) "'||v1.edtn||'_TOT_SURCHARGE"';
            vvar8       :='decode(u.edtn_code,'||''''||v1.edtn||''''||','||''''||v1.edtn||''''||')"'||v1.edtn||'",decode(u.edtn_code,'||''''||v1.edtn||''''||',sum(u.gross_amt-u.return_amt-u.comm_amt+sur_amt))"'||v1.edtn||'_NET"';
            sum_vvar8   :='nvl(sum("'||v1.edtn||'_NET"),0) "'||v1.edtn||'_NET"';
            vvar        :=vvar||',decode(u.edtn_code,'||''''||v1.edtn||''''||',sum(u.supply_rate))"'||v1.edtn||'_COPY_RATE"';
            vvar11      :='sum("'||v1.edtn||'_SUPPLY") "'||v1.edtn||'_SUPPLY",sum("'||v1.edtn||'_COPY_RATE") "'||v1.edtn||'_COPY_RATE"';
            vtot_publ   :='"'||v1.edtn||'"';
            --insert into test1(vstring,vstring2) values(' billing IN IF ',sum_vvar3);commit;
          else
            vvar        :=vvar||',decode(u.edtn_code,'||''''||v1.edtn||''''||',sum(u.supply_copy))"'||v1.edtn||'_SUPPLY"';
            --sum_vvar    :=sum_vvar||',nvl(sum("'||v1.edtn||'_SUPPLY"),0) "'||v1.edtn||'_SUPPLY",nvl(sum("'||v1.edtn||'_COPY_RATE"),0) "'||v1.edtn||'_COPY_RATE"';
            sum_vvar    :=sum_vvar||',nvl(sum("'||v1.edtn||'_SUPPLY"),0)||''#''||nvl(sum("'||v1.edtn||'_COPY_RATE"),0) "'||v1.edtn||'_SUPPLY"';
            vvar_name   :=vvar_name||',decode(u.edtn_code,'||''''||v1.edtn||''''||','||''''||v1.edtn||''''||')"'||v1.edtn||'"';
            vvar1       :=vvar1||',decode(u.edtn_code,'||''''||v1.edtn||''''||','||''''||v1.edtn||''''||')"'||v1.edtn||'",decode(u.edtn_code,'||''''||v1.edtn||''''||',sum(u.supply_copy))"'||v1.edtn||'_TOT_SUPPLY"';
            sum_vvar1   :=sum_vvar1||',nvl(sum("'||v1.edtn||'_TOT_SUPPLY"),0) "'||v1.edtn||'_TOT_SUPPLY"';
            vvar2       :=vvar2||',decode(u.edtn_code,'||''''||v1.edtn||''''||','||''''||v1.edtn||''''||')"'||v1.edtn||'",decode(u.edtn_code,'||''''||v1.edtn||''''||',sum(u.supply_copy*u.supply_rate))"'||v1.edtn||'_GROSS"';
            sum_vvar2   :=sum_vvar2||',nvl(sum("'||v1.edtn||'_GROSS"),0) "'||v1.edtn||'_GROSS"';
            vvar3       :=vvar3||',decode(u.edtn_code,'||''''||v1.edtn||''''||','||''''||v1.edtn||''''||')"'||v1.edtn||'",decode(u.edtn_code,'||''''||v1.edtn||''''||',sum(u.return_copy))"'||v1.edtn||'_RETURN_COPY"';
            vvar33      :=vvar33||',decode(u.edtn_code,'||''''||v1.edtn||''''||','||''''||v1.edtn||''''||')"'||v1.edtn||'",decode(u.edtn_code,'||''''||v1.edtn||''''||',max(u.supply_rate))"'||v1.edtn||'_RETURN_RATE"';
            --sum_vvar3   :=sum_vvar3||',nvl(max("'||v1.edtn||'_RETURN_RATE"),0) "'||v1.edtn||'_RETURN_RATE"||''#''||nvl(sum("'||v1.edtn||'_RETURN_COPY"),0) "'||v1.edtn||'_RETURN_COPY"'||sum_vvar33;
            sum_vvar3   :=sum_vvar3||',nvl(max("'||v1.edtn||'_RETURN_RATE"),0) ||''#''||nvl(sum("'||v1.edtn||'_RETURN_COPY"),0) "'||v1.edtn||'_RETURN_COPY"'||sum_vvar33;
            --sum_vvar33  :=sum_vvar33||',nvl(max("'||v1.edtn||'_RETURN_RATE"),0) "'||v1.edtn||'_RETURN_RATE"';
            vvar4       :=vvar4||',decode(u.edtn_code,'||''''||v1.edtn||''''||','||''''||v1.edtn||''''||')"'||v1.edtn||'",decode(u.edtn_code,'||''''||v1.edtn||''''||',sum(u.return_amt))"'||v1.edtn||'_RETURN_AMT"';
            sum_vvar4   :=sum_vvar4||',nvl(sum("'||v1.edtn||'_RETURN_AMT"),0) "'||v1.edtn||'_RETURN_AMT"';
            vvar5       :=vvar5||',decode(u.edtn_code,'||''''||v1.edtn||''''||','||''''||v1.edtn||''''||')"'||v1.edtn||'",decode(u.edtn_code,'||''''||v1.edtn||''''||',sum(u.gross_amt-u.return_amt))"'||v1.edtn||'_TOTAL_AMT"';
            sum_vvar5   :=sum_vvar5||',nvl(sum("'||v1.edtn||'_TOTAL_AMT"),0) "'||v1.edtn||'_TOTAL_AMT"';
            --vvar6       :=vvar6||',decode(u.edtn_code,'||''''||v1.edtn||''''||','||''''||v1.edtn_name||''''||')"'||v1.edtn_name||'",decode(u.edtn_code,'||''''||v1.edtn||''''||',sum(u.comm_amt))"'||v1.edtn||'_TOT_COMM"';
            vvar6       :=vvar6||',decode(u.edtn,'||''''||v1.edtn||''''||','||''''||v1.edtn||''''||')"'||v1.edtn||'",decode(u.edtn,'||''''||v1.edtn||''''||',sum(u.comm_amt))"'||v1.edtn||'_TOT_COMM"';
            sum_vvar6   :=sum_vvar6||',nvl(sum("'||v1.edtn||'_TOT_COMM"),0) "'||v1.edtn||'_TOT_COMM"';
            vvar7       :=vvar7||',decode(u.edtn_code,'||''''||v1.edtn||''''||','||''''||v1.edtn||''''||')"'||v1.edtn_name||'",decode(u.edtn_code,'||''''||v1.edtn||''''||',sum(u.sur_amt))"'||v1.edtn||'_TOT_SURCHARGE"';
            sum_vvar7   :=sum_vvar7||',nvl(sum("'||v1.edtn||'_TOT_SURCHARGE"),0) "'||v1.edtn||'_TOT_SURCHARGE"';
            vvar8       :=vvar8||',decode(u.edtn_code,'||''''||v1.edtn||''''||','||''''||v1.edtn||''''||')"'||v1.edtn_name||'",decode(u.edtn_code,'||''''||v1.edtn||''''||',sum(u.gross_amt-u.return_amt-u.comm_amt+sur_amt))"'||v1.edtn||'_NET"';
            sum_vvar8   :=sum_vvar8||',nvl(sum("'||v1.edtn||'_NET"),0) "'||v1.edtn||'_NET"';
            --vvar    :=vvar||',decode(u.edtn,'||''''||v1.edtn||''''||',sum(u.supply_copy))"'||v1.edtn||'_Supply"';
            vvar        :=vvar||',decode(u.edtn_code,'||''''||v1.edtn||''''||',sum(u.supply_rate))"'||v1.edtn||'_COPY_RATE"';
            vvar11      :=vvar1||',sum("'||v1.edtn||'_SUPPLY") "'||v1.edtn||'_SUPPLY",sum("'||v1.edtn||'_COPY_RATE") "'||v1.edtn||'_COPY_RATE"';
            vtot_publ   :=vtot_publ||',"'||v1.edtn||'"';
            --insert into test1(vstring,vstring2) values(' billing IN ELSE ',sum_vvar3);commit;
          end if;
          v_edtn_cnt:=nvl(v_edtn_cnt,0)+1;
            
          insert into cir_temp_suppliment(comp_code,unit_code,seq_no,edition_code,sess_id)
          values(v1.comp_code,v1.unit_code,v_edtn_cnt,v1.edtn,userenv('sessionid'));
           
        end loop;
        close cur_publ_edtn;
        
        open cur_exist_edtn;
        loop
            fetch cur_exist_edtn into rec_exist_edtn;
            exit when cur_exist_edtn%notfound;

            --select seq_no into v_exist_edtn from cir_temp_suppliment where comp_code=rec_exist_edtn.comp_code and unit_code=rec_exist_edtn.unit_code and 
            --edition_code=rec_exist_edtn.edtn and sess_id=userenv('sessionid');  
            
            update cir_temp_bill_collection set remarks=remarks||'#'||(select seq_no from cir_temp_suppliment where comp_code=rec_exist_edtn.comp_code and unit_code=rec_exist_edtn.unit_code and 
            edition_code=rec_exist_edtn.edtn and sess_id=userenv('sessionid'))
            where comp_code=rec_exist_edtn.comp_code and unit_code=rec_exist_edtn.unit_code and billno=rec_exist_edtn.billno and billdt=rec_exist_edtn.billdt and
                  cur_sessionid=userenv('sessionid');
        end loop;
        close cur_exist_edtn;
        update cir_temp_bill_collection set remarks=substr(remarks,2,length(remarks)) where cur_sessionid=userenv('sessionid');        
        --COMMIT;
        
        --insert into test1(vstring,vstring2) values(' billing var3 ',vvar3);commit;
       
        --insert into searchtbl(search) values(' billing first '||pcomp_code||' , '||punit_code||' , '||pbill_freq||' , '||pfrom_billno||' , '||ptill_billno||' , '||v_bill_frdt||' , '||v_bill_todt||' , '||pbillagcd||' , '||pbilldpcd||' , '||ppubl );commit;
        open p_accounts  for
        select z.comp_code comp_code,z.unit_code unit_code,z.agcd agcd,z.dpcd dpcd,z.ag_name ag_name,z.ag_name_oth_lang ag_name_oth_lang,
        z.addr1 addr1,z.addr2 addr2,z.addr3 addr3,z.city_name city_name,
        initcap(z.taluka_name) taluka_name,initcap(z.dist_name) dist_name,
        z.state_name state_name,z.pin_code pin_code,z.billno billno,z.billdt billdt,
        z.bill_copy bill_copy,z.gross_amount gross_amount,
        z.sur_amount sur_amount,z.comm_amount comm_amount,z.bill_amount bill_amount,z.bill_sec_amt bill_sec_amt,
        z.edtn_remark edtn_remark,z.return_amt return_amt,
        (select name from cir_ag_con_per where comp_code=z.comp_code and unit=z.unit_code and agcd=z.agcd and dpcd=z.dpcd and rownum<2) contact_person_name
        from(select b.comp_code comp_code,b.unit_code unit_code,b.agcd agcd,b.dpcd dpcd,a.ag_name ag_name,a.ag_name_oth_lang ag_name_oth_lang,
        a.addr1 addr1,a.addr2 addr2,a.addr3 addr3,cir_get_city(b.comp_code,a.city_code) city_name,
        cir_get_taluka(b.comp_code,a.tehsil_taluka) taluka_name,cir_get_dist(b.comp_code,a.state_code,a.dist_code) dist_name,
        cir_get_state(b.comp_code,a.country_code,a.state_code) state_name,a.pin_code pin_code,b.billno billno,b.billdt billdt,
        sum(b.bill_copy) bill_copy,sum(b.gross_amount) gross_amount,
        sum(b.sur_amount) sur_amount,sum(b.comm_amount) comm_amount,sum(b.bill_amount) bill_amount,sum(b.bill_sec_amt) bill_sec_amt,
        min(c.remarks) edtn_remark,(select nvl(sum(d.copy_amt),0) return_amt from cir_unsold_dtl d 
        where b.comp_code=d.comp_code and b.unit_code=d.unit_code and d.doctype='UCN' and d.recptdt >= v_bill_frdt and d.recptdt<=v_bill_todt and
        b.agcd=d.agcd and b.dpcd=d.dpcd and (nvl(d.apr_late_recpt,0)+nvl(d.apr_short_recpt,0)+nvl(d.apr_bnr,0)+nvl(d.apr_unsold,0))>0) return_amt        
        --,bill_frdt,bill_todt,bill_flag,bill_remark
        from cir_agmast a,cir_bill b,cir_temp_bill_collection c
        where a.comp_code=pcomp_code and a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.unit=b.unit_code and a.unit=c.unit_code and 
        b.unit_code=punit_code and b.billdt >= v_bill_frdt and b.billdt<=v_bill_todt and  
        b.bill_flag=pbill_freq and ((b.billno between pfrom_billno and ptill_billno) or (pfrom_billno is null)) and
        /*((b.publ=ppubl) or (ppubl is null)) and */a.agcd=b.agcd and a.dpcd=b.dpcd and b.branch_code=nvl(pbranchcode,b.branch_code) and 
        (a.dist_code =pdistcode or pdistcode is null) and (a.tehsil_taluka =ptalukacode or ptalukacode is null) and 
        (a.city_code =pcitycode or pcitycode is null) and b.agcd=nvl(pbillagcd,b.agcd) and b.dpcd=nvl(pbilldpcd,b.dpcd) and 
        c.billno=b.billno and c.billdt=b.billdt and c.cur_sessionid=userenv('sessionid')
        group by b.comp_code,b.unit_code,b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.addr1,a.addr2,a.addr3,
        a.city_code,a.tehsil_taluka,a.dist_code,a.country_code,a.state_code,a.pin_code,b.billno,b.billdt) z
        order by z.comp_code,z.unit_code,z.billdt,z.billno,z.agcd,z.dpcd;

        v_query1:='select comp_code,unit_code,billno,billdt,agcd,dpcd,supdate,sup_day,'||sum_vvar||' from (select u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.publ_code publ_code,u.edtn_code edtn_code,u.agcd agcd,u.dpcd dpcd,u.supply_date supdate,to_char(supply_date,''dd'') sup_day ,'||vvar||'
        from cir_bill_print u
        where u.comp_code='||''''||pcomp_code||''''||' and u.unit_code='||''''||punit_code ||''''||' and cur_sessionid='||userenv('sessionid')||'
        group by u.comp_code,u.unit_code,u.publ_code,u.edtn_code,u.agcd,u.dpcd,u.supply_date,u.billno,u.billdt)
        group by comp_code,unit_code,billno,billdt,agcd,dpcd,supdate,sup_day
        order by comp_code,unit_code,billdt,billno,supdate,agcd,dpcd';

        --insert into searchtbl(search) values(' billing before p_accounts1'||v_query1);commit;

        open p_accounts1 for v_query1;
                
        v_query1:='select comp_code,unit_code,billno,billdt,agcd,dpcd,'||sum_vvar1||' 
        from (select u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.publ_code publ_code,u.edtn_code edtn_code,u.agcd agcd,u.dpcd dpcd,'||vvar1||'
        from cir_bill_print u
        where u.comp_code='||''''||pcomp_code||''''||' and u.unit_code='||''''||punit_code ||''''||' and cur_sessionid='||userenv('sessionid')||'
        group by u.comp_code,u.unit_code,u.publ_code,u.edtn_code,u.agcd,u.dpcd,u.billno,u.billdt)
        group by comp_code,unit_code,billno,billdt,agcd,dpcd
        order by comp_code,unit_code,billdt,billno,agcd,dpcd';

        --insert into searchtbl(search) values(' billing before p_accounts2  '||v_query1);commit;

        open p_accounts2 for v_query1;

        v_query1:='select comp_code,unit_code,billno,billdt,agcd,dpcd,'||sum_vvar2||' 
        from (select u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.publ_code publ_code,u.edtn_code edtn_code,u.agcd agcd,u.dpcd dpcd,'||vvar2||'
        from cir_bill_print u
        where u.comp_code='||''''||pcomp_code||''''||' and u.unit_code='||''''||punit_code ||''''||' and cur_sessionid='||userenv('sessionid')||'
        group by u.comp_code,u.unit_code,u.publ_code,u.edtn_code,u.agcd,u.dpcd,u.billno,u.billdt)
        group by comp_code,unit_code,billno,billdt,agcd,dpcd
        order by comp_code,unit_code,billdt,billno,agcd,dpcd';

        --insert into searchtbl(search) values(' billing before p_accounts3  '||v_query1);commit;

        open p_accounts3 for v_query1;

        v_query1:='select comp_code,unit_code,billno,billdt,agcd,dpcd,SRLNO,'||sum_vvar3||' 
        from (select u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.publ_code publ_code,u.edtn_code edtn_code,u.agcd agcd,u.dpcd dpcd,SRLNO,'||vvar3||','||vvar33||'
        from (select comp_code,unit_code,billno,billdt,agcd,dpcd,publ_code,edtn_code,supply_rate, sum(return_copy) return_copy ,
        ROW_NUMBER( ) OVER (PARTITION BY
        comp_code,unit_code,billno,billdt,agcd,dpcd,publ_code,edtn_code ORDER BY 
        comp_code,unit_code,billno,billdt,agcd,dpcd,publ_code,edtn_code) SRLNO
        from cir_bill_return_print 
        where comp_code='||''''||pcomp_code||''''||' and unit_code='||''''||punit_code ||''''||' and cur_sessionid='||userenv('sessionid')||'
        group by comp_code,unit_code,billno,billdt,agcd,dpcd,publ_code,edtn_code,supply_rate) u
        group by comp_code,unit_code,billno,billdt,agcd,dpcd,publ_code,edtn_code,SRLNO)
        group by comp_code,unit_code,billno,billdt,agcd,dpcd,SRLNO
        order by comp_code,unit_code,billdt,billno,agcd,dpcd';

        --insert into test1(vstring,vstring2) values(' billing before p_accounts4 ',v_query1);commit;
        open p_accounts4 for v_query1;

        v_query1:='select comp_code,unit_code,billno,billdt,agcd,dpcd,'||sum_vvar4||' 
        from (select u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.publ_code publ_code,u.edtn_code edtn_code,u.agcd agcd,u.dpcd dpcd,'||vvar4||'
        from cir_bill_print u
        where u.comp_code='||''''||pcomp_code||''''||' and u.unit_code='||''''||punit_code ||''''||' and cur_sessionid='||userenv('sessionid')||'
        group by u.comp_code,u.unit_code,u.publ_code,u.edtn_code,u.agcd,u.dpcd,u.billno,u.billdt)
        group by comp_code,unit_code,billno,billdt,agcd,dpcd
        order by comp_code,unit_code,billdt,billno,agcd,dpcd';

        --insert into test1(vstring,vstring2) values(' billing before p_accounts5',v_query1);commit;

        open p_accounts5 for v_query1;

        v_query1:='select comp_code,unit_code,billno,billdt,agcd,dpcd,'||sum_vvar5||' 
        from (select u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.publ_code publ_code,u.edtn_code edtn_code,u.agcd agcd,u.dpcd dpcd,'||vvar5||'
        from cir_bill_print u
        where u.comp_code='||''''||pcomp_code||''''||' and u.unit_code='||''''||punit_code ||''''||' and cur_sessionid='||userenv('sessionid')||'
        group by u.comp_code,u.unit_code,u.publ_code,u.edtn_code,u.agcd,u.dpcd,u.billno,u.billdt)
        group by comp_code,unit_code,billno,billdt,agcd,dpcd
        order by comp_code,unit_code,billdt,billno,agcd,dpcd';

        --insert into test1(vstring,vstring2) values(' billing before p_accounts6',v_query1);commit;

        open p_accounts6 for v_query1;

        v_query1:='select comp_code,unit,billno,billdt,agcd,dpcd,'||sum_vvar6||' 
        from (select u.comp_code comp_code,u.unit_code unit,u.billno billno,u.billdt billdt,u.publ publ,u.edtn edtn,u.agcd agcd,u.dpcd dpcd,'||vvar6||'
        from cir_bill_det u,cir_agmast m
        where u.comp_code='||''''||pcomp_code||''''||' and u.comp_code=m.comp_code and u.unit_code=m.unit and u.unit_code='||''''||punit_code ||''''||' and u.billdt >='||''''||v_bill_frdt||''''||' and u.billdt <='||''''||v_bill_todt||''''||' and ((billno between '||''''||pfrom_billno||''''||' and '||''''||ptill_billno||''''||') or ('||''''||pfrom_billno||''''||' is null)) and
        u.agcd=m.agcd and u.agcd=nvl('||''''||pbillagcd||''''||',u.agcd) and u.dpcd=nvl('||''''||pbilldpcd||''''||',u.dpcd) and 
        u.bill_flag='||''''||pbill_freq||''''||' and u.branch_code=nvl('||''''||pbranchcode||''''||',u.branch_code) and (m.dist_code ='||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and (m.tehsil_taluka ='||''''||ptalukacode||''''||' or '||''''||ptalukacode||''''||' is null) and (m.city_code ='||''''||pcitycode||''''||' or '||''''||pcitycode||''''||'is null)
        group by u.comp_code,u.unit_code,u.publ,u.edtn,u.agcd,u.dpcd,u.billno,u.billdt)
        group by comp_code,unit,billno,billdt,agcd,dpcd
        order by comp_code,unit,billdt,billno,agcd,dpcd';

        --insert into test1(vstring,vstring2) values(' billing before p_accounts7',v_query1);commit;
        open p_accounts7 for v_query1;

        v_query1:='select comp_code,unit_code,billno,billdt,agcd,dpcd,'||sum_vvar7||' 
        from (select u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.publ_code publ_code,u.edtn_code edtn_code,u.agcd agcd,u.dpcd dpcd,'||vvar7||'
        from cir_bill_print u
        where u.comp_code='||''''||pcomp_code||''''||' and u.unit_code='||''''||punit_code ||''''||' and cur_sessionid='||userenv('sessionid')||'
        group by u.comp_code,u.unit_code,u.publ_code,u.edtn_code,u.agcd,u.dpcd,u.billno,u.billdt)
        group by comp_code,unit_code,billno,billdt,agcd,dpcd
        order by comp_code,unit_code,billdt,billno,agcd,dpcd';

        --insert into test1(vstring,vstring2) values(' billing before p_accounts8',v_query1);commit;
        open p_accounts8 for v_query1;

        v_query1:='select comp_code,unit_code,billno,billdt,agcd,dpcd,'||sum_vvar8||' 
        from (select u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.publ_code publ_code,u.edtn_code edtn_code,u.agcd agcd,u.dpcd dpcd,'||vvar8||'
        from cir_bill_print u
        where u.comp_code='||''''||pcomp_code||''''||' and u.unit_code='||''''||punit_code ||''''||' and cur_sessionid='||userenv('sessionid')||'
        group by u.comp_code,u.unit_code,u.publ_code,u.edtn_code,u.agcd,u.dpcd,u.billno,u.billdt)
        group by comp_code,unit_code,billno,billdt,agcd,dpcd
        order by comp_code,unit_code,billdt,billno,agcd,dpcd';

        --insert into test1(vstring,vstring2) values(' billing before p_accounts9',v_query1);commit;

        open p_accounts9 for v_query1;

        open p_accounts10 for
        select comp_code,unit_code,dt billdt,agname billno,publ_code publ,agcd,dpcd,
        dn_amt as "Debit Amt",cn_amt as "Credit Amt",rec_amt as "Receipt Amount",op_amt as "Previous Balance",
        nvl(return_amt,0) as "Deposit Previous Balance",nvl(bill_amt,0) as "Cuurent Deposit",to_number(country_code) as "Deposit Debit Amt",
        abs(nvl(return_amt,0)+nvl(bill_amt,0)+nvl(to_number(country_code),0)) as "Deposit Balance"
        from cir_temp_outstanding
        order by comp_code,unit_code,billdt,billno,agcd,dpcd;
        
        open p_accounts11 for 
        select distinct h.comp_code comp_code,h.unit_code unit_code,h.doctype||'\'||h.recptno recptno,h.recptdt recptdt,
        h.agcd agcd,h.dpcd dpcd,h.amount amount,
        case when h.doctype='RCR' then (select "Payment_Mode_Name" from payment_mode_mast where "Pay_Mode_Code"=h.reason)
        else (select reason_name from cir_reason_mst where comp_code=h.comp_code and reason_code=h.reason) end as reason,
        m.billno billno,m.billdt billdt, h.remark remark 
        from cir_rcphdr h,cir_bill_print m
        where h.comp_code=m.comp_code and h.comp_code=pcomp_code and h.unit_code=punit_code  and h.unit_code=m.unit_code and 
        h.doctype in('CN','DN') and h.recptdt >=v_bill_frdt and h.recptdt<=v_bill_todt and h.achd='NM' and h.amount<>0 and
        h.agcd=m.agcd and h.dpcd=m.dpcd and h.reason!='SEC DEBIT' and cur_sessionid=userenv('sessionid') 
        order by m.billdt,m.billno,agcd,dpcd,h.recptdt,recptno;
        
        open p_accounts12 for select sysdate from dual;
        delete from cir_bill_print where cur_sessionid=userenv('sessionid');commit;
        delete from cir_bill_return_print where cur_sessionid=userenv('sessionid');commit;
        delete from cir_temp_suppliment where sess_id=userenv('sessionid');commit;
        delete from cir_temp_bill_collection where cur_sessionid=userenv('sessionid');commit;
        --delete from cir_temp_outstanding; commit;
                
    End cir_bill_print_punya;


  procedure cir_bill_print_bhaskar(
      pcomp_code      in varchar2,
      punit_code      in varchar2,
      ppubl           in varchar2,
      pbill_freq      in varchar2,
      pfrom_billdt    in varchar2,
      ptill_billdt    in varchar2,
      pfrom_billno    in varchar2,
      ptill_billno    in varchar2,
      pbillagcd       in varchar2,
      pbilldpcd       in varchar2,
      pdateformat     in varchar2,
      pextra1         in varchar2,--for Agency Class
      pextra2         in varchar2,--for Agency Type
      p_accounts      out t_accounts,
      p_accounts1     out t_accounts,
      p_accounts2     out t_accounts,
      p_accounts3     out t_accounts,
      p_accounts4     out t_accounts,
      p_accounts5     out t_accounts,
      p_accounts6     out t_accounts,
      p_accounts7     out t_accounts,
      p_accounts8     out t_accounts,
      p_accounts9     out t_accounts,
      p_accounts10    out t_accounts,
      p_accounts11    out t_accounts,
      p_accounts12     out t_accounts)
    As
      v_bill_frdt         date;
      v_bill_todt         date;
          v_dt            date;
         v_query1        varchar2(8000);
      v_query2        varchar2(8000);
    cursor cur_bill is
        select distinct b.comp_code,b.unit_code,b.publ,b.agcd,b.dpcd,b.billno,b.billdt,min(b.bill_frdt) frdt,max(b.bill_todt) todt from cir_bill b,cir_agmast m
                where b.comp_code=m.comp_code and b.comp_code=pcomp_code and b.unit_code=nvl(punit_code,b.unit_code) and b.unit_code=m.unit and 
                b.billdt between v_bill_frdt and v_bill_todt and
                b.bill_flag=pbill_freq and ((b.billno between pfrom_billno and ptill_billno) or (pfrom_billno is null)) and
                            b.publ=nvl(ppubl,b.publ) and b.agcd=nvl(pbillagcd,b.agcd) and b.agcd=m.agcd and
                            b.dpcd=nvl(pbilldpcd,b.dpcd) and b.dpcd=m.dpcd and (m.ag_class=pextra1 or pextra1 is null) and
                            (m.ag_type=pextra2 or pextra2 is null) 
            group by b.comp_code,b.unit_code,b.publ,b.agcd,b.dpcd,b.billno,b.billdt
            order by b.comp_code,b.unit_code,b.publ,b.billdt,b.billno,b.agcd,b.dpcd;
rec_bill cur_bill%rowtype;

    cursor cur_dbksup is
        select d.comp_code,d.unit_code,d.publ,d.edtn,d.supdate,d.sup_rate copy_rate,d.comm_fix_auto_spl,d.comm_code,sum(d.sup_copy) supply_copy
        from cir_dbksup d,cir_supply_type_mast s
        where d.comp_code=s.comp_code and d.comp_code=rec_bill.comp_code and d.unit_code=rec_bill.unit_code and d.publ=rec_bill.publ and
              d.supdate=v_dt and d.billagcd=rec_bill.agcd and d.billdpcd=rec_bill.dpcd and
              d.sup_type_code=s.sup_ty_code and upper(s.bill_pay)='Y'
    group by d.comp_code,d.unit_code,d.publ,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code
    order by d.comp_code,d.unit_code,d.publ,d.edtn,d.supdate;
rec_dbksup cur_dbksup%rowtype;

      cursor cur_publ_edtn is
            select distinct comp_code,unit_code,publ_code,cir_get_publ_name(comp_code,publ_code) publ_name,edtn_code edtn,cir_get_edtn_name(comp_code,edtn_code) edtn_name
            from cir_bill_print
        where cur_sessionid=userenv('sessionid') and comp_code=pcomp_code and (unit_code=punit_code or punit_code is null) and
                    ((publ_code=ppubl) or (ppubl is null)) and ((billno between pfrom_billno and ptill_billno) or (pfrom_billno is null)) and
                    (agcd=pbillagcd or pbillagcd is null) and (dpcd=pbillagcd or pbillagcd is null)
        order by comp_code,unit_code,publ_code,edtn_code;

        v1 cur_publ_edtn%rowtype;
        v_cnt             number:=0;
        v_return_copy     number;
        v_return_amt      number(14,2):=0;
        v_gross_amt       number(14,2):=0;
        v_comm_rate       number;
        v_comm_amt        number(14,2):=0;
        v_sur_rate        number;
        v_sur_amt         number(14,2):=0;
        v_opdate          date;
        v_opbal           number(14,2):=0;
        v_billamt         number(14,2):=0;
        v_dbcramt         number(14,2):=0;
        v_dbamt           number(14,2):=0;
        v_cramt           number(14,2):=0;
        v_recamt          number(14,2):=0;        
  Begin
        v_bill_frdt    :=to_date(pfrom_billdt,''''||pdateformat||'''');
        v_bill_todt    :=to_date(ptill_billdt,''''||pdateformat||'''');
        v_opdate       :=cir_get_finandt(pcomp_code,to_date(pfrom_billdt,''''||pdateformat||''''),pdateformat,'','');--for financial date
        --delete from test1;commit;
        delete from cir_bill_print where cur_sessionid=userenv('sessionid');
        delete from cir_temp_outstanding;
        Open cur_bill;---main cursor bill
        Loop
            fetch cur_bill into rec_bill;
          exit when cur_bill%notfound;

            v_dt:=rec_bill.frdt;
            Loop
              if v_dt>rec_bill.todt then
                exit;
            end if;

            Open cur_dbksup;
                Loop
              fetch cur_dbksup into rec_dbksup;
              exit when cur_dbksup%notfound;

                select sum(nvl(apr_late_recpt,0)+nvl(apr_short_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0)),0 return_amt into v_return_copy,v_return_amt
                from cir_unsold_dtl
                where comp_code=rec_bill.comp_code and unit_code=rec_bill.unit_code and doctype='UCN' and
                      recptdt=rec_dbksup.supdate and publ=rec_dbksup.publ and edtn=rec_dbksup.edtn and agcd=rec_bill.agcd and
                      dpcd=rec_bill.dpcd and (nvl(apr_late_recpt,0)+nvl(apr_short_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0;

                v_gross_amt   :=nvl(round((rec_dbksup.supply_copy*rec_dbksup.copy_rate),2),0);
                v_comm_rate   :=0;
                v_comm_amt    :=nvl(round((rec_dbksup.supply_copy*v_comm_rate),2),0);
                v_sur_rate    :=0;
                v_sur_amt     :=nvl(round((rec_dbksup.supply_copy*v_sur_rate),2),0);

                insert into cir_bill_print(comp_code,unit_code,billno,billdt,publ_code,edtn_code,agcd,dpcd,
                                           supply_date,supply_copy,supply_rate,gross_amt,comm_rate,comm_amt,sur_rate,sur_amt,
                                           return_copy,return_amt,cur_sessionid)
                 values(rec_bill.comp_code,rec_bill.unit_code,rec_bill.billno,rec_bill.billdt,rec_dbksup.publ,rec_dbksup.edtn,rec_bill.agcd,rec_bill.dpcd,
                             rec_dbksup.supdate,rec_dbksup.supply_copy,rec_dbksup.copy_rate,v_gross_amt,v_comm_rate,v_comm_amt,v_sur_rate,v_sur_amt,
                             v_return_copy,v_return_amt,userenv('sessionid'));
               End loop;
            Close cur_dbksup;

            v_dt:=v_dt+1;
            End Loop;--close loop for date
            v_opbal :=cir_accounts.cir_agency_opbal(rec_bill.comp_code,rec_bill.unit_code,null,rec_bill.agcd,rec_bill.dpcd,v_opdate,'NM',pdateformat,'','')+
                      cir_accounts.cir_agency_ytodt(rec_bill.comp_code,rec_bill.unit_code,NULL,rec_bill.agcd,rec_bill.dpcd,v_opdate,rec_bill.frdt,'NM',pdateformat,'','');

            select sum(bill_amount) into v_billamt from cir_bill
                where comp_code=rec_bill.comp_code and unit_code=rec_bill.unit_code and
                      agcd=rec_bill.agcd and dpcd=rec_bill.dpcd and billdt >= rec_bill.frdt and billdt<=rec_bill.todt/* and
                      publ=rec_bill.publ*/;

            select sum(amount) into v_dbcramt from cir_outmast
                where comp_code=rec_bill.comp_code and unit_code=rec_bill.unit_code and
                            agcd=rec_bill.agcd and dpcd=rec_bill.dpcd and recptdt>= rec_bill.frdt and recptdt<=rec_bill.todt and
                            doctyp<>'BIL' and achd='NM' /*and publ=rec_bill.publ*/;

            select sum(amount) into v_dbamt from cir_outmast
                where comp_code=rec_bill.comp_code and unit_code=rec_bill.unit_code and
                      agcd=rec_bill.agcd and dpcd=rec_bill.dpcd and recptdt>= rec_bill.frdt and recptdt<=rec_bill.billdt and
                      doctyp not in('BIL','RCR') and achd='NM' and /*publ=rec_bill.publ and */amount>0;

            select sum(amount) into v_cramt from cir_outmast
                where comp_code=rec_bill.comp_code and unit_code=rec_bill.unit_code and
                      agcd=rec_bill.agcd and dpcd=rec_bill.dpcd and recptdt>= rec_bill.frdt and recptdt<=rec_bill.billdt and
                      doctyp not in('BIL','RCR') and achd='NM' and /*publ=rec_bill.publ and */amount<0;

            select sum(amount) into v_recamt from cir_outmast
                where comp_code=rec_bill.comp_code and unit_code=rec_bill.unit_code and
                      agcd=rec_bill.agcd and dpcd=rec_bill.dpcd and recptdt>= rec_bill.frdt and recptdt<=rec_bill.billdt and
                      doctyp='RCR' and achd='NM' /*and publ=rec_bill.publ*/;

            v_opbal:=nvl(v_opbal,0)+NVL(V_recamt,0);--nvl(v_billamt,0)+nvl(v_dbcramt,0);

            insert into cir_temp_outstanding(comp_code,unit_code,dt,agname,publ_code,agcd,dpcd,dn_amt,cn_amt,rec_amt,op_amt)
            values(rec_bill.comp_code,rec_bill.unit_code,rec_bill.billdt,rec_bill.billno,'',/*rec_bill.publ,*/
            rec_bill.agcd,rec_bill.dpcd,v_dbamt,v_cramt,v_recamt,v_opbal);
        
            insert into cir_temp_bill_collection(comp_code,unit_code,billno,billdt,remarks,cur_sessionid)
            values(rec_bill.comp_code,rec_bill.unit_code,rec_bill.billno,rec_bill.billdt,'',userenv('sessionid'));
            v_opbal:=0;v_billamt:=0;v_dbcramt:=0;v_dbamt:=0;v_cramt:=0;v_recamt:=0;            
        End Loop;
        Close cur_bill;
     --delete from test1;commit;

      --insert into test1(vstring,vstring2) values(' billing ',vvar);commit;

        open p_accounts  for
        select b.comp_code comp_code,b.unit_code unit_code,b.agcd agcd,b.dpcd dpcd,a.ag_name ag_name,a.ag_name_oth_lang ag_name_oth_lang,
        a.addr1 addr1,a.addr2 addr2,a.addr3 addr3,cir_get_city(b.comp_code,a.city_code) city_name,b.billno billno,b.billdt billdt,
        sum(b.bill_copy) bill_copy,sum(b.gross_amount) gross_amount,
        sum(b.sur_amount) sur_amount,sum(b.comm_amount) comm_amount,sum(b.bill_amount) bill_amount,
        (select max(d.comm_rate) from cir_bill_det d where d.comp_code=b.comp_code and d.unit_code=b.unit_code and d.agcd=b.agcd and 
        d.dpcd=b.dpcd and d.billno=b.billno and d.billdt=b.billdt) comm_rate   
        --,bill_frdt,bill_todt,bill_flag,bill_remark
                    from cir_agmast a,cir_bill b
        where a.comp_code=pcomp_code and a.unit=b.unit_code and b.unit_code=nvl(punit_code,b.unit_code) and b.billdt between v_bill_frdt and v_bill_todt and
                    b.bill_flag=pbill_freq and ((b.billno between pfrom_billno and ptill_billno) or (pfrom_billno is null)) and
                    b.publ=nvl(ppubl,b.publ) and a.agcd=b.agcd and a.dpcd=b.dpcd and
                    b.agcd=nvl(pbillagcd,b.agcd) and b.dpcd=nvl(pbilldpcd,b.dpcd) and (a.ag_class=pextra1 or pextra1 is null) and
                            (a.ag_type=pextra2 or pextra2 is null) 
        group by b.comp_code,b.unit_code,b.agcd,b.dpcd,a.ag_name,a.ag_name_oth_lang,a.addr1,a.addr2,a.addr3,a.city_code,b.billno,b.billdt
        order by b.comp_code,b.unit_code,b.billdt,b.billno,b.agcd,b.dpcd;

        open p_accounts1 for 
        select comp_code,unit_code,billno,billdt,agcd,dpcd,supdate,supply_rate copy_rate,sum(supply_copy) supply from 
        (select u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.agcd agcd,u.dpcd dpcd,u.supply_date supdate,u.supply_rate supply_rate,sum(u.supply_copy) supply_copy
        from cir_bill_print u
        where u.comp_code=pcomp_code and u.unit_code=punit_code and cur_sessionid=userenv('sessionid')
        group by u.comp_code,u.unit_code,u.agcd,u.dpcd,u.supply_date,u.billno,u.billdt,u.supply_rate)
        group by comp_code,unit_code,billno,billdt,agcd,dpcd,supdate,supply_rate
        order by comp_code,unit_code,billdt,billno,supdate,agcd,dpcd;

        open p_accounts2 for 
        select comp_code,unit_code,billno,billdt,agcd,dpcd,sum(supply_copy) tot_supply,sum(gross) gross_amt,sum(return_copy) return_copy,sum(return_amt) return_amt,
        sum(tot_amt) tot_amt,sum(tot_comm) tot_comm ,sum(tot_surcharge) tot_surcharge,sum(net_amt) net_amt
        from 
        (select u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.agcd agcd,u.dpcd dpcd,sum(u.supply_copy) supply_copy,
        sum(u.gross_amt) gross,sum(u.return_copy) return_copy,sum(u.return_amt) return_amt,sum(u.gross_amt-u.return_amt) tot_amt,sum(u.comm_amt) tot_comm,
        sum(u.sur_amt) tot_surcharge,sum(u.gross_amt-u.return_amt-u.comm_amt+u.sur_amt) net_amt
        from cir_bill_print u
        where u.comp_code=pcomp_code and u.unit_code=punit_code and cur_sessionid=userenv('sessionid')
        group by u.comp_code,u.unit_code,u.agcd,u.dpcd,u.billno,u.billdt)
        group by comp_code,unit_code,billno,billdt,agcd,dpcd
        order by comp_code,unit_code,billdt,billno,agcd,dpcd;

        open p_accounts3 for 
        select comp_code,unit_code,billno,billdt,agcd,dpcd,sum(gross) gross_amt from 
        (select u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.agcd agcd,u.dpcd dpcd,sum(u.gross_amt) gross
        from cir_bill_print u
        where u.comp_code=pcomp_code and u.unit_code=punit_code and cur_sessionid=userenv('sessionid')
        group by u.comp_code,u.unit_code,u.agcd,u.dpcd,u.billno,u.billdt)
        group by comp_code,unit_code,billno,billdt,agcd,dpcd
        order by comp_code,unit_code,billdt,billno,agcd,dpcd;

        open p_accounts4 for 
        select comp_code,unit_code,billno,billdt,agcd,dpcd,sum(return_copy) return_copy from 
        (select u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.agcd agcd,u.dpcd dpcd,sum(u.return_copy) return_copy
        from cir_bill_print u
        where u.comp_code=pcomp_code and u.unit_code=punit_code and cur_sessionid=userenv('sessionid')
        group by u.comp_code,u.unit_code,u.agcd,u.dpcd,u.billno,u.billdt)
        group by comp_code,unit_code,billno,billdt,agcd,dpcd
        order by comp_code,unit_code,billdt,billno,agcd,dpcd;

        open p_accounts5 for 
        select comp_code,unit_code,billno,billdt,agcd,dpcd,sum(return_amt) return_amt from 
        (select u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.agcd agcd,u.dpcd dpcd,sum(u.return_amt) return_amt
        from cir_bill_print u
        where u.comp_code=pcomp_code and u.unit_code=punit_code and cur_sessionid=userenv('sessionid')
        group by u.comp_code,u.unit_code,u.agcd,u.dpcd,u.billno,u.billdt)
        group by comp_code,unit_code,billno,billdt,agcd,dpcd
        order by comp_code,unit_code,billdt,billno,agcd,dpcd;

        open p_accounts6 for 
        select comp_code,unit_code,billno,billdt,agcd,dpcd,sum(tot_amt) tot_amt from 
        (select u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.agcd agcd,u.dpcd dpcd,sum(u.gross_amt-u.return_amt) tot_amt
        from cir_bill_print u
        where u.comp_code=pcomp_code and u.unit_code=punit_code and cur_sessionid=userenv('sessionid')
        group by u.comp_code,u.unit_code,u.agcd,u.dpcd,u.billno,u.billdt)
        group by comp_code,unit_code,billno,billdt,agcd,dpcd
        order by comp_code,unit_code,billdt,billno,agcd,dpcd;

        open p_accounts7 for 
        select comp_code,unit,billno,billdt,agcd,dpcd,sum(tot_comm) tot_comm from 
        (select u.comp_code comp_code,u.unit_code unit,u.billno billno,u.billdt billdt,u.agcd agcd,u.dpcd dpcd,sum(u.comm_amt) tot_comm
        from cir_bill_det u
        where u.comp_code=pcomp_code and u.unit_code=punit_code and billdt between v_bill_frdt and v_bill_todt and bill_flag=pbill_freq and ((billno between pfrom_billno and ptill_billno) or (pfrom_billno is null)) and
        (agcd=pbillagcd or pbillagcd is null) and (dpcd=pbilldpcd or pbilldpcd is null)
        group by u.comp_code,u.unit_code,u.agcd,u.dpcd,u.billno,u.billdt)
        group by comp_code,unit,billno,billdt,agcd,dpcd
        order by comp_code,unit,billdt,billno,agcd,dpcd;

        open p_accounts8 for 
        select comp_code,unit_code,billno,billdt,agcd,dpcd,sum(tot_surcharge) tot_surcharge from 
        (select u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.agcd agcd,u.dpcd dpcd,sum(u.sur_amt) tot_surcharge
        from cir_bill_print u
        where u.comp_code=pcomp_code and u.unit_code=punit_code and cur_sessionid=userenv('sessionid')
        group by u.comp_code,u.unit_code,u.agcd,u.dpcd,u.billno,u.billdt)
        group by comp_code,unit_code,billno,billdt,agcd,dpcd
        order by comp_code,unit_code,billdt,billno,agcd,dpcd;

        open p_accounts9 for 
        select comp_code,unit_code,billno,billdt,agcd,dpcd,sum(net_amt) net_amt from 
        (select u.comp_code comp_code,u.unit_code unit_code,u.billno billno,u.billdt billdt,u.agcd agcd,u.dpcd dpcd,sum(u.gross_amt-u.return_amt-u.comm_amt+u.sur_amt) net_amt
        from cir_bill_print u
        where u.comp_code=pcomp_code and u.unit_code=punit_code and cur_sessionid=userenv('sessionid')
        group by u.comp_code,u.unit_code,u.agcd,u.dpcd,u.billno,u.billdt)
        group by comp_code,unit_code,billno,billdt,agcd,dpcd
        order by comp_code,unit_code,billdt,billno,agcd,dpcd;
        
        open p_accounts10 for 
        select comp_code,unit_code,dt billdt,agname billno,publ_code publ,agcd,dpcd,
        dn_amt as "Debit Amt",cn_amt as "Credit Amt",rec_amt as "Receipt Amount",op_amt as "Previous Balance"
        from cir_temp_outstanding
        where comp_code=pcomp_code and (unit_code=punit_code or punit_code is null) and
        dt between v_bill_frdt and v_bill_todt;
        
        open p_accounts11 for
        select comp_code,unit_code,billno,billdt,agcd,dpcd,copy_rate,sum(bill_copy) bill_copy,sum(nvl(copy_rate,0)*nvl(bill_copy,0)) gross_amt 
        from cir_bill_det 
        where comp_code=pcomp_code and unit_code=punit_code and billdt between v_bill_frdt and v_bill_todt and bill_flag=pbill_freq and 
        ((billno between pfrom_billno and ptill_billno) or (pfrom_billno is null)) and
        (agcd=pbillagcd or pbillagcd is null) and (dpcd=pbilldpcd or pbilldpcd is null)
         group by comp_code,unit_code,billno,billdt,agcd,dpcd,copy_rate
         order by comp_code,unit_code,billdt,billno,agcd,dpcd;
         
        open p_accounts12 for
        select distinct b.comp_code comp_code,b.unit_code unit_code,b.billno billno,b.billdt billdt,b.agcd agcd,b.dpcd dpcd,
        (select nvl(sum(a.sup_copy),0) from cir_dbksup a,cir_supply_type_mast s 
        where b.comp_code=a.comp_code and s.comp_code=a.comp_code and a.unit_code=b.unit_code and b.publ=a.publ and
        a.edtn =b.edtn and a.sup_type_code=s.sup_ty_code and s.bill_pay='N' and 
        a.supdate between v_bill_frdt and v_bill_todt and --between b.fromdt and  b.todt and 
        a.billagcd =b.agcd and a.billdpcd=b.dpcd) unpaid_copy
        from cir_bill_det b
        where b.comp_code=pcomp_code and b.unit_code=punit_code and 
        (b.publ=ppubl or ppubl is null) and
        (b.agcd=pbillagcd or pbillagcd is null) and (b.dpcd=pbilldpcd or pbilldpcd is null) and
        b.billdt between trunc(v_bill_frdt,'MM') and v_bill_todt
        order by b.comp_code,b.unit_code,b.billno,b.billdt,b.agcd,b.dpcd;

    End cir_bill_print_bhaskar;
    
  procedure cir_before_bill_print_p1(
    pcompcode        in varchar2,
    punitcode        in varchar2,
    ppubl_freq       in varchar2,
    ppubl            in varchar2,
    pagencytype      in varchar2,
    pagencyclass     in varchar2,
    pbranchcode      in varchar2,
    pdistcode        in varchar2,
    ptaluka          in varchar2,
    pbillagcd        in varchar2,
    pbilldpcd        in varchar2,
    pfrom_date       in varchar2,
    ptill_date       in varchar2,
    plangtype        in varchar2,
    pdateformat      in varchar2,
    pextra1          in varchar2,
    pextra2          in varchar2,
    p_accounts       out t_accounts,
    p_accounts1      out t_accounts,
    p_accounts2      out t_accounts,
    p_accounts3      out t_accounts,
    p_accounts4      out t_accounts,
    p_accounts5      out t_accounts,
    p_accounts6      out t_accounts,
    p_accounts7      out t_accounts,
    p_accounts8      out t_accounts,
    p_accounts9      out t_accounts,
    p_accounts10     out t_accounts)
   As
    v_frdt  date;
    v_todt  date;
    v_start_date    date;
        cursor cur_not_supply is
            select distinct u.comp_code comp_code,u.unit_code unit_code,u.agcd agcd,u.dpcd dpcd,u.publ publ,u.edtn edtn,
            u.supply_date supply_date,u.copy_rate copy_rate from
            (select d.comp_code,d.unit_code,d.agcd,d.dpcd,d.publ,d.edtn,d.recptdt supply_date,d.copy_rate from cir_agmast m,cir_unsold_dtl d
            where d.comp_code=m.comp_code and d.comp_code=pcompcode and d.unit_code=m.unit and d.unit_code=punitcode and 
                d.app_dt >= v_start_date  and d.app_dt<=v_todt and d.agcd=m.agcd  and d.dpcd=m.dpcd and 
                d.agcd=nvl(pbillagcd,d.agcd) and d.dpcd=nvl(pbilldpcd,d.dpcd) and (m.ag_type=pagencytype or pagencytype is null) and 
                (m.ag_class=pagencyclass or pagencyclass is null) and (m.dist_code=pdistcode or pdistcode is null) and 
                (m.tehsil_taluka=ptaluka or ptaluka is null) and d.supply_copy>0 and (m.branch_code=pbranchcode or pbranchcode is null) and 
                (nvl(d.apr_late_recpt,0)+nvl(d.apr_short_recpt,0)+nvl(d.apr_bnr,0)+nvl(d.apr_unsold,0))>0
             minus
            select comp_code,unit_code,agcd,dpcd,publ_code publ,edtn_code edtn,supply_date,supply_rate copy_rate from cir_bill_print
            where comp_code=pcompcode and unit_code=punitcode and supply_date>= v_start_date  and supply_date<=v_todt and 
            agcd=nvl(pbillagcd,agcd) and dpcd=nvl(pbilldpcd,dpcd) and supply_copy>0 and cur_sessionid=userenv('sessionid')) u;
    rec_not_supply  cur_not_supply%rowtype;
    
        cursor cur_agcd is
        select distinct d.comp_code comp_code,d.unit_code unit_code,'' publ,d.agcd billagcd,d.dpcd billdpcd  
        from cir_bill_print d 
        where d.comp_code=pcompcode and d.unit_code=punitcode and d.supply_date>= v_start_date  and d.supply_date<=v_todt and 
        d.agcd=nvl(pbillagcd,d.agcd) and d.dpcd=nvl(pbilldpcd,d.dpcd) and --(d.publ_code=ppubl or ppubl is null) and 
        (nvl(d.supply_copy,0)+nvl(return_copy,0))>0 and d.cur_sessionid=userenv('sessionid')
        group by d.comp_code,d.unit_code,d.agcd,d.dpcd
        order by d.comp_code,d.unit_code,d.agcd,d.dpcd;        
                
    rec_agcd cur_agcd%rowtype;

        v_return_copy     number(10);
        v_return_amt      number(10,2);
        vbill_no          varchar2(20);
        v_rec_amt         number:=0;
        v_rcp_count       number:=0;
        v_prev_agcd       varchar2(30):='XX';  
        v_cur_agcd        varchar2(30):='XX';
            
        v_opdate          date;
        v_opbal           number(14,2):=0;
        v_billamt         number(14,2):=0;
        v_dbcramt         number(14,2):=0;
        v_dbamt           number(14,2):=0;
        v_cramt           number(14,2):=0;
        v_recamt          number(14,2):=0;
        v_secamt          number(14,2):=0;
        v_psecamt          number(14,2):=0;
        v_csecamt          number(14,2):=0;

   Begin
    v_frdt      :=to_date(pfrom_date,''''||pdateformat||'''');
    v_todt      :=to_date(ptill_date,''''||pdateformat||'''');
    
    v_opdate    :=cir_get_finandt(pcompcode,to_date(pfrom_date,''''||pdateformat||''''),pdateformat,'','');
    v_start_date:=trunc(v_frdt,'mm');
    
    --delete test1;commit;insert into test1(vstring,vstring2) values(' cir_before_bill_print_p1 ', pbillagcd||pbilldpcd);commit;
    delete from cir_temp_outstanding;
    delete from cir_bill_print where cur_sessionid=userenv('sessionid');
    delete from cir_bill_return_print where cur_sessionid=userenv('sessionid');
    --cir_before_bill_process_p(pcomp_code, punit_code,ppubl_freq, ppubl, pfrdt, ptodt, pbillagcd ,pbilldpcd, pagencytype,pagencyclass ,pbranchcode, pdistcode , ptaluka , pdateformat , puserid , pextra1 ,  pextra2);
    if v_frdt=v_start_date then
        cir_rep_billing.cir_before_bill_process_p(pcompcode,punitcode,ppubl_freq,ppubl,pfrom_date,ptill_date,pbillagcd,pbilldpcd,pagencytype,pagencyclass ,pbranchcode, pdistcode , ptaluka,pdateformat,'','','');
    else
        --cir_before_bill_process_p(pcompcode,punitcode,ppubl_freq,ppubl,to_char(v_start_date,''''||pdateformat||''''),to_char(v_frdt-1,''''||pdateformat||''''),pbillagcd,pbilldpcd,pagencytype,pagencyclass ,pbranchcode, pdistcode , ptaluka,pdateformat,'','','');
        --cir_before_bill_process_p(pcompcode,punitcode,ppubl_freq,ppubl,pfrom_date,ptill_date,pbillagcd,pbilldpcd,pagencytype,pagencyclass ,pbranchcode, pdistcode , ptaluka,pdateformat,'','','');
        cir_rep_billing.cir_before_bill_process_p(pcompcode,punitcode,ppubl_freq,ppubl,to_char(v_start_date,''''||pdateformat||''''),ptill_date,pbillagcd,pbilldpcd,pagencytype,pagencyclass ,pbranchcode, pdistcode , ptaluka,pdateformat,'','','');
    end if;
    open cur_not_supply;
    loop
        fetch cur_not_supply into rec_not_supply;
        exit when cur_not_supply%notfound;
        --insert into test1(vstring,vstring2) values('Weekly bill1 ',rec_not_supply.agcd||rec_not_supply.dpcd||' , '||rec_agcd.comp_code||','||rec_agcd.unit_code||','||v_opdate);
        v_cur_agcd  :=rec_not_supply.agcd||rec_not_supply.dpcd;
        
        if v_prev_agcd<>v_cur_agcd then--XX & A0002
            v_prev_agcd :=v_cur_agcd;
        
        select max(to_number(billno)) into vbill_no from cir_bill_print 
            where comp_code=pcompcode and unit_code=punitcode and supply_date>= v_start_date and supply_date<=v_todt and 
                agcd=nvl(pbillagcd,agcd) and dpcd=nvl(pbilldpcd,dpcd) and cur_sessionid=userenv('sessionid');            
        if to_number(vbill_no)=0 then
            select max(to_number(billno)) into vbill_no from cir_bill_print 
                where comp_code=pcompcode and unit_code=punitcode and 
                supply_date>= v_start_date and supply_date<=v_todt and 
                    cur_sessionid=userenv('sessionid');
        end if;
            
        end if;
        
        select sum(nvl(apr_late_recpt,0)+nvl(apr_short_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0)),sum(nvl(copy_amt,0)-nvl(waste_amt,0)) return_amt into v_return_copy,v_return_amt
            from cir_unsold_dtl
            where comp_code=rec_not_supply.comp_code and unit_code=rec_not_supply.unit_code and doctype='UCN' and
                app_dt=rec_not_supply.supply_date and publ=rec_not_supply.publ and edtn=rec_not_supply.edtn and 
                agcd=rec_not_supply.agcd and dpcd=rec_not_supply.dpcd and copy_rate=rec_not_supply.copy_rate and
                (nvl(apr_late_recpt,0)+nvl(apr_short_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0;
                            
        select abs(sum(amount)) into v_rec_amt from cir_rcphdr 
            where comp_code=rec_not_supply.comp_code and unit_code=rec_not_supply.unit_code and
                doctype='RCR' and recptdt = rec_not_supply.supply_date and
                agcd=rec_not_supply.agcd and dpcd=rec_not_supply.dpcd and achd='NM';
                        
        select count(*) into v_rcp_count from cir_bill_return_print
            where cur_sessionid=userenv('sessionid') and comp_code=rec_not_supply.comp_code and unit_code=rec_not_supply.unit_code and 
                receipt_date=rec_not_supply.supply_date and agcd=rec_not_supply.agcd and dpcd=rec_not_supply.dpcd;
        if nvl(v_rcp_count,0)>0 then
            v_rec_amt:=0; 
        else
            insert into cir_bill_return_print(comp_code,unit_code,agcd,dpcd,receipt_date,sur_amt)
            values(rec_not_supply.comp_code,rec_not_supply.unit_code,rec_not_supply.agcd,rec_not_supply.dpcd,rec_not_supply.supply_date,v_rec_amt);
        end if;           
                        
        insert into cir_bill_print(comp_code,unit_code,billno,billdt,publ_code,edtn_code,agcd,dpcd,
                                supply_date,supply_copy,supply_rate,gross_amt,comm_rate,comm_amt,sur_rate,sur_amt,
                                return_copy,return_amt,cur_sessionid,rec_amt)
                  values(rec_not_supply.comp_code,rec_not_supply.unit_code,vbill_no,v_todt,rec_not_supply.publ,rec_not_supply.edtn,rec_not_supply.agcd,rec_not_supply.dpcd,
                                rec_not_supply.supply_date,0,rec_not_supply.copy_rate,0,0,0,0,0,
                                v_return_copy,v_return_amt,userenv('sessionid'),v_rec_amt);
                             
    v_return_copy:=0;v_return_amt:=0;v_rcp_count:=0;
    end loop;
    close cur_not_supply;    

    open cur_agcd;
    loop
        fetch cur_agcd into rec_agcd;
        exit when cur_agcd%notfound;
            v_opbal:=0;v_billamt:=0;v_dbcramt :=0;v_dbamt :=0; v_cramt :=0; v_recamt :=0; v_secamt :=0;v_psecamt :=0;v_csecamt :=0;
            
            v_opbal :=cir_accounts.cir_agency_opbal(rec_agcd.comp_code,rec_agcd.unit_code,'',rec_agcd.billagcd,rec_agcd.billdpcd,v_opdate,'NM',pdateformat,pextra1,pextra2);
            --insert into test1(vstring,vstring2) values('Weekly bill1 ',v_opbal||' , '||rec_agcd.billagcd||' , '||rec_agcd.comp_code||','||rec_agcd.unit_code||','||v_opdate);
            
            select sum(bill_amount) into v_billamt from cir_bill
                where comp_code=rec_agcd.comp_code and unit_code=rec_agcd.unit_code and
                      agcd=rec_agcd.billagcd and dpcd=rec_agcd.billdpcd and billdt >= v_opdate and billdt<v_frdt;

            select sum(amount) into v_dbcramt from cir_outmast
                where comp_code=rec_agcd.comp_code and unit_code=rec_agcd.unit_code and achd='NM' and doctyp<>'BIL' and 
                      recptdt>= v_opdate and recptdt<v_frdt and agcd=rec_agcd.billagcd and dpcd=rec_agcd.billdpcd;

            select sum(amount) into v_dbamt from cir_outmast
                where comp_code=rec_agcd.comp_code and unit_code=rec_agcd.unit_code and achd='NM' and doctyp not in('BIL','RCR') and
                      recptdt>= v_frdt and recptdt<=v_todt and agcd=rec_agcd.billagcd and dpcd=rec_agcd.billdpcd and amount>0;

            select sum(amount) into v_cramt from cir_outmast
                where comp_code=rec_agcd.comp_code and unit_code=rec_agcd.unit_code and achd='NM' and doctyp not in('BIL','RCR') and
                      recptdt>= v_frdt and recptdt<=v_todt and agcd=rec_agcd.billagcd and dpcd=rec_agcd.billdpcd and amount<0;

            select sum(amount) into v_recamt from cir_outmast
                where comp_code=rec_agcd.comp_code and unit_code=rec_agcd.unit_code and achd='NM' and doctyp='RCR' and 
                      recptdt>= v_frdt and recptdt<=v_todt and agcd=rec_agcd.billagcd and dpcd=rec_agcd.billdpcd;

            v_opbal:=nvl(v_opbal,0)+nvl(v_billamt,0)+nvl(v_dbcramt,0);
            v_dbcramt:=0;
            ----for secutiry opening balance---
            v_dbcramt :=cir_accounts.cir_agency_opbal(rec_agcd.comp_code,rec_agcd.unit_code,'',rec_agcd.billagcd,rec_agcd.billdpcd,v_opdate,'SC',pdateformat,pextra1,pextra2);
            
            select sum(amount) into v_psecamt from cir_rcphdr
                where comp_code=rec_agcd.comp_code and unit_code=rec_agcd.unit_code and achd='SC' and
                      recptdt>=v_opdate and recptdt<=v_todt and agcd=rec_agcd.billagcd and dpcd=rec_agcd.billdpcd;
            
            v_secamt:=nvl(v_dbcramt,0)+nvl(v_psecamt,0);
            
            select abs(SUM(sec_amt)) into v_csecamt from cir_bill_print
                where comp_code=rec_agcd.comp_code and unit_code=rec_agcd.unit_code and agcd=rec_agcd.billagcd and dpcd=rec_agcd.billdpcd and 
                supply_date >= trunc(v_frdt,'mm') and supply_date<=v_todt and cur_sessionid=userenv('sessionid');
            
            v_secamt:=nvl(v_secamt,0)-nvl(v_csecamt,0);
            v_dbcramt:=0;
            select SUM(nvl(gross_amt,0)-nvl(comm_amt,0)+nvl(sur_amt,0)-nvl(return_amt,0)+nvl(sec_amt,0)) into v_dbcramt from cir_bill_print
                where comp_code=rec_agcd.comp_code and unit_code=rec_agcd.unit_code and agcd=rec_agcd.billagcd and dpcd=rec_agcd.billdpcd and 
                supply_date >= trunc(v_frdt,'mm') and supply_date<v_frdt and cur_sessionid=userenv('sessionid');            
            
            v_opbal:=nvl(v_opbal,0)+nvl(v_dbcramt,0);
            --insert into test1(vstring,vstring2) values('Weekly bill ',v_opbal||' , '||rec_agcd.billagcd);
            insert into cir_temp_outstanding(comp_code,unit_code,dt,agname,publ_code,
            agcd,dpcd,dn_amt,cn_amt,rec_amt,op_amt,return_amt)
            values(rec_agcd.comp_code,rec_agcd.unit_code,v_todt,cir_get_name.cir_agname(rec_agcd.comp_code,rec_agcd.unit_code,rec_agcd.billagcd,rec_agcd.billdpcd,1,pdateformat,'','') ,rec_agcd.publ,
            rec_agcd.billagcd,rec_agcd.billdpcd,v_dbamt,v_cramt,abs(v_recamt),v_opbal,v_secamt);
        End Loop;
        Close cur_agcd;
        
     open p_accounts for
        select comp_code,unit_code,publ,edtn,cir_get_name.cir_edtn(comp_code,unit_code,edtn,plangtype,''''||pdateformat||'''','','') edition_name,min(sup_rate) edtn_rate,billagcd,billdpcd,cir_get_name.cir_agname(comp_code,unit_code,billagcd,billdpcd,plangtype,''''||pdateformat||'''','','') agency_name,
        sum(p01) as "SUN",sum(p02) as "MON",sum(p03) as "TUE",sum(p04) as "WED",sum(p05) as "THU",sum(p06) as "FRI",sum(p07) as "SAT",
        sum(nvl(p02,0)+nvl(p03,0)+nvl(p04,0)+nvl(p05,0)+nvl(p06,0)+nvl(p07,0)) as "TOTAL_COPY",sum(nvl(p01,0)*nvl(sup_rate,0)+nvl(p02,0)*nvl(sup_rate,0)+nvl(p03,0)*nvl(sup_rate,0)+nvl(p04,0)*nvl(sup_rate,0)+nvl(p05,0)*nvl(sup_rate,0)+nvl(p06,0)*nvl(sup_rate,0)+nvl(p07,0)*nvl(sup_rate,0)) as "TOTAL_AMT",
        sum(daily_return) as "DAILY_RETURN",sum(sun_return) as "SUN_RETURN"
        from(select d.comp_code comp_code,d.unit_code unit_code,d.publ_code publ,d.edtn_code edtn,d.agcd billagcd,d.dpcd billdpcd,
        d.supply_date supdate,
        case when to_char(d.supply_date,'DY')='SUN' then sum(nvl(d.supply_copy,0)) else 0 end p01,
        case when to_char(d.supply_date,'DY')='MON' then sum(nvl(d.supply_copy,0)) else 0 end p02,
        case when to_char(d.supply_date,'DY')='TUE' then sum(nvl(d.supply_copy,0)) else 0 end p03,
        case when to_char(d.supply_date,'DY')='WED' then sum(nvl(d.supply_copy,0)) else 0 end p04,
        case when to_char(d.supply_date,'DY')='THU' then sum(nvl(d.supply_copy,0)) else 0 end p05,
        case when to_char(d.supply_date,'DY')='FRI' then sum(nvl(d.supply_copy,0)) else 0 end p06,
        case when to_char(d.supply_date,'DY')='SAT' then sum(nvl(d.supply_copy,0)) else 0 end p07,
        d.supply_rate sup_rate,d.comm_rate,
        case when to_char(d.supply_date,'d')='1' then SUM(return_copy) else 0  end sun_return,
        case when to_char(d.supply_date,'d')<>'1' then SUM(return_copy) else 0 end daily_return  
        from cir_agmast m,cir_bill_print d 
        where d.comp_code=pcompcode and d.comp_code=m.comp_code and d.unit_code=m.unit and d.unit_code=punitcode and d.supply_date >= v_frdt and d.supply_date<=v_todt and 
        m.agcd=d.agcd and m.dpcd=d.dpcd and d.agcd=nvl(pbillagcd,d.agcd) and d.dpcd=nvl(pbilldpcd,d.dpcd) and (m.ag_type=pagencytype or pagencytype is null) and 
        (m.ag_class=pagencyclass or pagencyclass is null) and (m.dist_code=pdistcode or pdistcode is null) and (m.tehsil_taluka=ptaluka or ptaluka is null) and 
        (nvl(d.supply_copy,0)+nvl(return_copy,0))>0 and 
        (m.branch_code=pbranchcode or pbranchcode is null) and d.cur_sessionid=userenv('sessionid')
        group by d.comp_code,d.unit_code,d.publ_code,d.edtn_code,d.agcd,d.dpcd,d.supply_date,d.supply_rate,d.comm_rate)
        group by comp_code,unit_code,publ,edtn,billagcd,billdpcd
        order by comp_code,unit_code,agency_name,publ,edtn;
    
    open p_accounts1 for
    select comp_code,unit_code,dt billdt,agname billno,publ_code publ,agcd,dpcd,
    dn_amt as "Debit Amt",abs(cn_amt) as "Credit Amt",abs(rec_amt) as "Receipt Amount",op_amt as "Previous Balance",
    return_amt as "Deposit Balance"
    from cir_temp_outstanding where comp_code||unit_code||agcd||dpcd 
    in(select distinct comp_code||unit_code||agcd||dpcd from cir_bill_print where comp_code=pcompcode and unit_code=punitcode and agcd=nvl(pbillagcd,agcd) and dpcd=nvl(pbilldpcd,dpcd) and
    supply_date >= v_frdt and supply_date<=v_todt and cur_sessionid=userenv('sessionid')) 
    order by comp_code,unit_code,agname;    

    open p_accounts2 for 
    select h.comp_code comp_code,h.unit_code unit_code,h.doctype||'\'||h.recptno recptno,h.recptdt recptdt,
    h.agcd agcd,h.dpcd dpcd,m.ag_name agname,h.amount amount,
    case when h.doctype='RCR' then (select "Payment_Mode_Name" from payment_mode_mast where "Pay_Mode_Code"=h.reason)
    else (select reason_name from cir_reason_mst where comp_code=h.comp_code and reason_code=h.reason) end as reason,
    h.remark remark 
    from cir_rcphdr h,cir_agmast m
    where h.comp_code=m.comp_code and h.comp_code=pcompcode and h.unit_code=punitcode  and h.unit_code=m.unit and 
    h.doctype in('CN','DN') and h.recptdt >=v_frdt and h.recptdt<=v_todt and h.achd='NM' and h.amount<>0 and
    h.agcd=m.agcd and h.dpcd=m.dpcd and h.agcd=nvl(pbillagcd,h.agcd) and h.dpcd=nvl(pbilldpcd,h.dpcd) and h.branch_code=nvl(pbranchcode,h.branch_code) and 
    (m.ag_type=pagencytype or pagencytype is null) and (m.ag_class=pagencyclass or pagencyclass is null) and
    (m.dist_code=pdistcode or pdistcode is null) and (m.tehsil_taluka=ptaluka or ptaluka is null) and 
    (m.branch_code=pbranchcode or pbranchcode is null) and nvl(m.to_bill,'N')='Y' 
    order by m.ag_name,h.recptdt,h.recptno;
    
    open p_accounts3 for 
    select comp_code,unit_code,agcd billagcd,dpcd billdpcd,cir_get_name.cir_agname(comp_code,unit_code,agcd,dpcd,plangtype,''''||pdateformat||'''','','') agency_name,
    sum(nvl(supply_copy,0)*nvl(supply_rate,0)) gross_amt,nvl(sum(comm_amt),0) comm_amt,nvl(sum(return_amt),0) return_amt,abs(sum(nvl(sec_amt,0))) sec_amt from cir_bill_print
    where comp_code=pcompcode and unit_code=punitcode and agcd=nvl(pbillagcd,agcd) and dpcd=nvl(pbilldpcd,dpcd) and 
    supply_date >= v_frdt and supply_date<=v_todt and cur_sessionid=userenv('sessionid')
    group by comp_code,unit_code,agcd,dpcd
    order by comp_code,unit_code,agency_name,agcd,dpcd;

    open p_accounts4 for select sysdate from dual;

    open p_accounts5 for select sysdate from dual;
    open p_accounts6 for select sysdate from dual;
    open p_accounts7 for select sysdate from dual;
    open p_accounts8 for select sysdate from dual;
    open p_accounts9 for select sysdate from dual;
    
    open p_accounts10 for select sysdate from dual;
    
    --delete from cir_bill_print where cur_sessionid=userenv('sessionid');commit;
    --delete from cir_bill_return_print where cur_sessionid=userenv('sessionid');commit;
    insert into ERRORMESSAGE(message) values('Weekly bill print p1 Complete ');commit;
    exception when others then
    insert into ERRORMESSAGE(message) values('Weekly bill print p1 error ');commit;
    
    
   End cir_before_bill_print_p1;

/*
  set serveroutput on;
  var v1 refcursor;
  var v2 refcursor;
  var v3 refcursor;
  var v4 refcursor;
  var v5 refcursor;
  var v6 refcursor;
  var v7 refcursor;
  var v8 refcursor;
  var v9 refcursor;
  var v10 refcursor;
  var v11 refcursor;
  exec cir_rep_billing.cir_before_bill_print_p2('SP002','AUR','','','','','','','','B0052','0001','01-nov-2010','07-nov-2010','1','dd/mm/yyyy','','',:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10,:v11);
  */
  procedure cir_before_bill_print_p2(
    pcompcode        in varchar2,
    punitcode        in varchar2,
    ppubl_freq       in varchar2,
    ppubl            in varchar2,
    pagencytype      in varchar2,
    pagencyclass     in varchar2,
    pbranchcode      in varchar2,
    pdistcode        in varchar2,
    ptaluka          in varchar2,
    pbillagcd        in varchar2,
    pbilldpcd        in varchar2,
    pfrom_date       in varchar2,
    ptill_date       in varchar2,
    plangtype        in varchar2,
    pdateformat      in varchar2,
    pextra1          in varchar2,
    pextra2          in varchar2,
    p_accounts       out t_accounts,
    p_accounts1      out t_accounts,
    p_accounts2      out t_accounts,
    p_accounts3      out t_accounts,
    p_accounts4      out t_accounts,
    p_accounts5      out t_accounts,
    p_accounts6      out t_accounts,
    p_accounts7      out t_accounts,
    p_accounts8      out t_accounts,
    p_accounts9      out t_accounts,
    p_accounts10     out t_accounts)
   As
    v_frdt          date;
    v_todt          date;
    v_start_date    date;
    
    cursor cur_not_supply is
            select u.comp_code comp_code,u.unit_code unit_code,u.agcd agcd,u.dpcd dpcd,u.publ publ,u.edtn edtn,
            u.supply_date supply_date,u.copy_rate copy_rate from
            (select d.comp_code,d.unit_code,d.agcd,d.dpcd,d.publ,d.edtn,d.recptdt supply_date,d.copy_rate from cir_agmast m,cir_unsold_dtl d
            where d.comp_code=m.comp_code and d.comp_code=pcompcode and d.unit_code=m.unit and d.unit_code=punitcode and 
                d.app_dt >= v_start_date  and d.app_dt<=v_todt and d.agcd=m.agcd  and d.dpcd=m.dpcd and 
                d.agcd=nvl(pbillagcd,d.agcd) and d.dpcd=nvl(pbilldpcd,d.dpcd) and (m.ag_type=pagencytype or pagencytype is null) and 
                (m.ag_class=pagencyclass or pagencyclass is null) and (m.dist_code=pdistcode or pdistcode is null) and 
                (m.tehsil_taluka=ptaluka or ptaluka is null) and d.supply_copy>0 and (m.branch_code=pbranchcode or pbranchcode is null) and 
                (nvl(d.apr_late_recpt,0)+nvl(d.apr_short_recpt,0)+nvl(d.apr_bnr,0)+nvl(d.apr_unsold,0))>0
             minus
            select comp_code,unit_code,agcd,dpcd,publ_code publ,edtn_code edtn,supply_date,supply_rate copy_rate from cir_bill_print
            where comp_code=pcompcode and unit_code=punitcode and supply_date>= v_start_date  and supply_date<=v_todt and 
            agcd=nvl(pbillagcd,agcd) and dpcd=nvl(pbilldpcd,dpcd) and supply_copy>0 and cur_sessionid=userenv('sessionid')) u;
    rec_not_supply  cur_not_supply%rowtype;
        
        cursor cur_agcd is
        select distinct d.comp_code comp_code,d.unit_code unit_code,'' publ,d.agcd billagcd,d.dpcd billdpcd  
        from cir_bill_print d 
        where d.comp_code=pcompcode and d.unit_code=punitcode and d.supply_date between v_start_date and v_todt and 
        d.agcd=nvl(pbillagcd,d.agcd) and d.dpcd=nvl(pbilldpcd,d.dpcd) and --(d.publ_code=ppubl or ppubl is null) and 
        d.cur_sessionid=userenv('sessionid') and (nvl(d.supply_copy,0)+nvl(return_copy,0))>0
        group by d.comp_code,d.unit_code,d.agcd,d.dpcd
        order by d.comp_code,d.unit_code,d.agcd,d.dpcd;       
    rec_agcd cur_agcd%rowtype;
    
        v_return_copy     number(10);
        v_return_amt      number(10,2);
        vbill_no          varchar2(20);
        v_rec_amt         number:=0;
        v_rcp_count       number:=0;
        v_prev_agcd       varchar2(30):='XX';  
        v_cur_agcd        varchar2(30):='XX';
            
        v_opdate          date;
        v_opbal           number(14,2):=0;
        v_billamt         number(14,2):=0;
        v_dbcramt         number(14,2):=0;
        v_dbamt           number(14,2):=0;
        v_cramt           number(14,2):=0;
        v_recamt          number(14,2):=0;   
        v_secamt          number(14,2):=0;
        v_psecamt          number(14,2):=0;
        v_csecamt          number(14,2):=0;
   Begin
    v_frdt      :=to_date(pfrom_date,''''||pdateformat||'''');
    v_todt      :=to_date(ptill_date,''''||pdateformat||'''');
    v_opdate    :=cir_get_finandt(pcompcode,to_date(pfrom_date,''''||pdateformat||''''),pdateformat,'','');
    v_start_date:=trunc(v_frdt,'mm');
    
    --delete test1;commit;insert into test1(vstring,vstring2) values(' cir_before_bill_print_p2 ', pbillagcd||pbilldpcd);commit; 
    delete from cir_temp_outstanding;
    delete from cir_bill_print where cur_sessionid=userenv('sessionid');
    delete from cir_bill_return_print where cur_sessionid=userenv('sessionid');
    --cir_before_bill_process_p(pcomp_code, punit_code,ppubl_freq, ppubl, pfrdt, ptodt, pbillagcd ,pbilldpcd, pagencytype,pagencyclass ,pbranchcode, pdistcode , ptaluka , pdateformat , puserid , pextra1 ,  pextra2);
        
    if v_frdt=v_start_date then
        cir_before_bill_process_p(pcompcode,punitcode,ppubl_freq,ppubl,pfrom_date,ptill_date,pbillagcd,pbilldpcd,pagencytype,pagencyclass ,pbranchcode, pdistcode , ptaluka,pdateformat,'','','');
    else
        --cir_before_bill_process_p(pcompcode,punitcode,ppubl_freq,ppubl,to_char(v_start_date,''''||pdateformat||''''),to_char(v_frdt-1,''''||pdateformat||''''),pbillagcd,pbilldpcd,pagencytype,pagencyclass ,pbranchcode, pdistcode , ptaluka,pdateformat,'','','');
        --cir_before_bill_process_p(pcompcode,punitcode,ppubl_freq,ppubl,pfrom_date,ptill_date,pbillagcd,pbilldpcd,pagencytype,pagencyclass ,pbranchcode, pdistcode , ptaluka,pdateformat,'','','');
        cir_before_bill_process_p(pcompcode,punitcode,ppubl_freq,ppubl,to_char(v_start_date,''''||pdateformat||''''),ptill_date,pbillagcd,pbilldpcd,pagencytype,pagencyclass ,pbranchcode, pdistcode , ptaluka,pdateformat,'','','');
    end if;

    open cur_not_supply;
    loop
        fetch cur_not_supply into rec_not_supply;
        exit when cur_not_supply%notfound;

        v_cur_agcd  :=rec_not_supply.agcd||rec_not_supply.dpcd;
        
        if v_prev_agcd<>v_cur_agcd then--XX & A0002
            v_prev_agcd :=v_cur_agcd;
        
        select max(to_number(billno)) into vbill_no from cir_bill_print 
            where comp_code=pcompcode and unit_code=punitcode and supply_date>= v_start_date and supply_date<=v_todt and 
                agcd=nvl(pbillagcd,agcd) and dpcd=nvl(pbilldpcd,dpcd) and cur_sessionid=userenv('sessionid');            
        if to_number(vbill_no)=0 then
            select max(to_number(billno)) into vbill_no from cir_bill_print 
                where comp_code=pcompcode and unit_code=punitcode and 
                supply_date>= v_start_date and supply_date<=v_todt and 
                    cur_sessionid=userenv('sessionid');
        end if;
            
        end if;
        
        select sum(nvl(apr_late_recpt,0)+nvl(apr_short_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0)),sum(nvl(copy_amt,0)-nvl(waste_amt,0)) return_amt into v_return_copy,v_return_amt
            from cir_unsold_dtl
            where comp_code=rec_not_supply.comp_code and unit_code=rec_not_supply.unit_code and doctype='UCN' and
                app_dt=rec_not_supply.supply_date and publ=rec_not_supply.publ and edtn=rec_not_supply.edtn and 
                agcd=rec_not_supply.agcd and dpcd=rec_not_supply.dpcd and copy_rate=rec_not_supply.copy_rate and
                (nvl(apr_late_recpt,0)+nvl(apr_short_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0;
                            
        select abs(sum(amount)) into v_rec_amt from cir_rcphdr 
            where comp_code=rec_not_supply.comp_code and unit_code=rec_not_supply.unit_code and
                doctype='RCR' and recptdt = rec_not_supply.supply_date and
                agcd=rec_not_supply.agcd and dpcd=rec_not_supply.dpcd and achd='NM';
                        
        select count(*) into v_rcp_count from cir_bill_return_print
            where cur_sessionid=userenv('sessionid') and comp_code=rec_not_supply.comp_code and unit_code=rec_not_supply.unit_code and 
                receipt_date=rec_not_supply.supply_date and agcd=rec_not_supply.agcd and dpcd=rec_not_supply.dpcd;
        if nvl(v_rcp_count,0)>0 then
            v_rec_amt:=0; 
        else
            insert into cir_bill_return_print(comp_code,unit_code,agcd,dpcd,receipt_date,sur_amt)
            values(rec_not_supply.comp_code,rec_not_supply.unit_code,rec_not_supply.agcd,rec_not_supply.dpcd,rec_not_supply.supply_date,v_rec_amt);
        end if;           
                        
        insert into cir_bill_print(comp_code,unit_code,billno,billdt,publ_code,edtn_code,agcd,dpcd,
                                supply_date,supply_copy,supply_rate,gross_amt,comm_rate,comm_amt,sur_rate,sur_amt,
                                return_copy,return_amt,cur_sessionid,rec_amt)
                  values(rec_not_supply.comp_code,rec_not_supply.unit_code,vbill_no,v_todt,rec_not_supply.publ,rec_not_supply.edtn,rec_not_supply.agcd,rec_not_supply.dpcd,
                                rec_not_supply.supply_date,0,rec_not_supply.copy_rate,0,0,0,0,0,
                                v_return_copy,v_return_amt,userenv('sessionid'),v_rec_amt);
                             
    v_return_copy:=0;v_return_amt:=0;v_rcp_count:=0;
    end loop;
    close cur_not_supply;
    
    open cur_agcd;
    loop
        fetch cur_agcd into rec_agcd;
        exit when cur_agcd%notfound;
            v_opbal:=0;v_billamt:=0;v_dbcramt :=0;v_dbamt :=0; v_cramt :=0; v_recamt :=0; v_secamt :=0;v_psecamt :=0;v_csecamt :=0;
            
            v_opbal :=cir_accounts.cir_agency_opbal(rec_agcd.comp_code,rec_agcd.unit_code,'',rec_agcd.billagcd,rec_agcd.billdpcd,v_opdate,'NM',pdateformat,pextra1,pextra2);
            
            select sum(bill_amount) into v_billamt from cir_bill
                where comp_code=rec_agcd.comp_code and unit_code=rec_agcd.unit_code  and billdt >= v_opdate and 
                billdt<v_frdt and agcd=rec_agcd.billagcd and dpcd=rec_agcd.billdpcd;

            select sum(amount) into v_dbcramt from cir_outmast
                where comp_code=rec_agcd.comp_code and unit_code=rec_agcd.unit_code and achd='NM' and doctyp<>'BIL' and 
                      recptdt>= v_opdate and recptdt<v_frdt and agcd=rec_agcd.billagcd and dpcd=rec_agcd.billdpcd;

            select sum(amount) into v_dbamt from cir_outmast
                where comp_code=rec_agcd.comp_code and unit_code=rec_agcd.unit_code and achd='NM' and doctyp not in('BIL','RCR') and
                      recptdt>= v_frdt and recptdt<=v_todt and agcd=rec_agcd.billagcd and dpcd=rec_agcd.billdpcd and amount>0;

            select sum(amount) into v_cramt from cir_outmast
                where comp_code=rec_agcd.comp_code and unit_code=rec_agcd.unit_code and achd='NM' and doctyp not in('BIL','RCR') and
                      recptdt>= v_frdt and recptdt<=v_todt and agcd=rec_agcd.billagcd and dpcd=rec_agcd.billdpcd and amount<0;

            select sum(amount) into v_recamt from cir_outmast
                where comp_code=rec_agcd.comp_code and unit_code=rec_agcd.unit_code and achd='NM' and doctyp='RCR' and 
                      recptdt>= v_frdt and recptdt<=v_todt and agcd=rec_agcd.billagcd and dpcd=rec_agcd.billdpcd;

            v_opbal:=nvl(v_opbal,0)+nvl(v_billamt,0)+nvl(v_dbcramt,0);
            v_dbcramt:=0;
            ----for secutiry opening balance---
            v_dbcramt :=cir_accounts.cir_agency_opbal(rec_agcd.comp_code,rec_agcd.unit_code,'',rec_agcd.billagcd,rec_agcd.billdpcd,v_opdate,'SC',pdateformat,pextra1,pextra2);
            
            select sum(amount) into v_psecamt from cir_rcphdr
                where comp_code=rec_agcd.comp_code and unit_code=rec_agcd.unit_code and achd='SC' and
                      recptdt>=v_opdate and recptdt<=v_todt and agcd=rec_agcd.billagcd and dpcd=rec_agcd.billdpcd;
            
            v_secamt:=nvl(v_dbcramt,0)+nvl(v_psecamt,0);
            
            select abs(SUM(sec_amt)) into v_csecamt from cir_bill_print
                where comp_code=rec_agcd.comp_code and unit_code=rec_agcd.unit_code and  
                supply_date >= trunc(v_frdt,'mm') and supply_date<=v_todt and 
                agcd=rec_agcd.billagcd and dpcd=rec_agcd.billdpcd and cur_sessionid=userenv('sessionid');
            
            v_secamt:=nvl(v_secamt,0)-nvl(v_csecamt,0);
            v_dbcramt:=0;
            select SUM(nvl(gross_amt,0)-nvl(comm_amt,0)+nvl(sur_amt,0)-nvl(return_amt,0)+nvl(sec_amt,0)) into v_dbcramt from cir_bill_print
                where comp_code=rec_agcd.comp_code and unit_code=rec_agcd.unit_code and  
                supply_date >= trunc(v_frdt,'mm') and supply_date<v_frdt and 
                agcd=rec_agcd.billagcd and dpcd=rec_agcd.billdpcd and cur_sessionid=userenv('sessionid');            
            
            v_opbal:=nvl(v_opbal,0)+nvl(v_dbcramt,0);
            
            insert into cir_temp_outstanding(comp_code,unit_code,dt,agname,publ_code,
            agcd,dpcd,dn_amt,cn_amt,rec_amt,op_amt,return_amt)
            values(rec_agcd.comp_code,rec_agcd.unit_code,v_todt,cir_get_name.cir_agname(rec_agcd.comp_code,rec_agcd.unit_code,rec_agcd.billagcd,rec_agcd.billdpcd,1,pdateformat,'','') ,rec_agcd.publ,
            rec_agcd.billagcd,rec_agcd.billdpcd,v_dbamt,v_cramt,v_recamt,v_opbal,v_secamt);
        End Loop;
        Close cur_agcd;    
        
        open p_accounts for
        select comp_code,unit_code,publ,edtn,cir_get_name.cir_edtn(comp_code,unit_code,edtn,plangtype,''''||pdateformat||'''','','') edition_name,min(sup_rate) edtn_rate,billagcd,billdpcd,
        cir_get_name.cir_agname(comp_code,unit_code,billagcd,billdpcd,plangtype,''''||pdateformat||'''','','') agency_name,
        sum(p01) as "SUN",sum(p02) as "MON",sum(p03) as "TUE",sum(p04) as "WED",sum(p05) as "THU",sum(p06) as "FRI",sum(p07) as "SAT",sum(gross_amt) as "TOTAL_AMT",
        sum(u01) as "SUN_RET",sum(u02) as "MON_RET",sum(u03) as "TUE_RET",sum(u04) as "WED_RET",sum(u05) as "THU_RET",sum(u06) as "FRI_RET",sum(u07) as "SAT_RET",sum(return_gross_amt) as "RETURN_TOTAL_AMT"
        from(select d.comp_code comp_code,d.unit_code unit_code,d.publ_code publ,d.edtn_code edtn,d.agcd billagcd,d.dpcd billdpcd,
        d.supply_date supdate,d.supply_rate sup_rate,
        case when to_char(d.supply_date,'DY')='SUN' then sum(nvl(d.supply_copy,0)) else 0 end p01,
        case when to_char(d.supply_date,'DY')='MON' then sum(nvl(d.supply_copy,0)) else 0 end p02,
        case when to_char(d.supply_date,'DY')='TUE' then sum(nvl(d.supply_copy,0)) else 0 end p03,
        case when to_char(d.supply_date,'DY')='WED' then sum(nvl(d.supply_copy,0)) else 0 end p04,
        case when to_char(d.supply_date,'DY')='THU' then sum(nvl(d.supply_copy,0)) else 0 end p05,
        case when to_char(d.supply_date,'DY')='FRI' then sum(nvl(d.supply_copy,0)) else 0 end p06,
        case when to_char(d.supply_date,'DY')='SAT' then sum(nvl(d.supply_copy,0)) else 0 end p07,
        sum(nvl(d.supply_copy,0)*nvl(d.supply_rate,0)) gross_amt,
        case when to_char(d.supply_date,'DY')='SUN' then sum(nvl(d.return_copy,0)) else 0 end u01,
        case when to_char(d.supply_date,'DY')='MON' then sum(nvl(d.return_copy,0)) else 0 end u02,
        case when to_char(d.supply_date,'DY')='TUE' then sum(nvl(d.return_copy,0)) else 0 end u03,
        case when to_char(d.supply_date,'DY')='WED' then sum(nvl(d.return_copy,0)) else 0 end u04,
        case when to_char(d.supply_date,'DY')='THU' then sum(nvl(d.return_copy,0)) else 0 end u05,
        case when to_char(d.supply_date,'DY')='FRI' then sum(nvl(d.return_copy,0)) else 0 end u06,
        case when to_char(d.supply_date,'DY')='SAT' then sum(nvl(d.return_copy,0)) else 0 end u07,        
        sum(nvl(d.return_copy,0)*nvl(d.supply_rate,0)) return_gross_amt
        from cir_agmast m,cir_bill_print d 
        where d.comp_code=pcompcode and d.comp_code=m.comp_code and d.unit_code=m.unit and d.unit_code=punitcode and d.supply_date >= v_frdt and d.supply_date <=v_todt and 
        m.agcd=d.agcd and m.dpcd=d.dpcd and d.agcd=nvl(pbillagcd,d.agcd) and d.dpcd=nvl(pbilldpcd,d.dpcd) and (m.ag_type=pagencytype or pagencytype is null) and 
        (m.ag_class=pagencyclass or pagencyclass is null) and (m.dist_code=pdistcode or pdistcode is null) and (m.tehsil_taluka=ptaluka or ptaluka is null) and (nvl(d.supply_copy,0)+nvl(return_copy,0))>0 and 
        (m.branch_code=pbranchcode or pbranchcode is null) and d.cur_sessionid=userenv('sessionid')
        group by d.comp_code,d.unit_code,d.publ_code,d.edtn_code,d.agcd,d.dpcd,d.supply_date,d.supply_rate)
        group by comp_code,unit_code,publ,edtn,billagcd,billdpcd
        order by comp_code,unit_code,agency_name,billagcd,billdpcd,publ,edtn;
    
        open p_accounts1 for
        select comp_code,unit_code,dt billdt,agname billno,publ_code publ,agcd,dpcd,
        dn_amt as "Debit Amt",abs(cn_amt) as "Credit Amt",abs(rec_amt) as "Receipt Amount",op_amt as "Previous Balance",
        return_amt as "Deposit Balance"
        from cir_temp_outstanding where comp_code||unit_code||agcd||dpcd 
        in(select distinct comp_code||unit_code||agcd||dpcd from cir_bill_print where comp_code=pcompcode and unit_code=punitcode and agcd=nvl(pbillagcd,agcd) and dpcd=nvl(pbilldpcd,dpcd) and
        supply_date >= v_frdt and supply_date<=v_todt and cur_sessionid=userenv('sessionid'))
        order by comp_code,unit_code,agname,agcd,dpcd;    

        open p_accounts2 for 
        select h.comp_code comp_code,h.unit_code unit_code,h.doctype||'\'||h.recptno recptno,h.recptdt recptdt,h.agcd agcd,h.dpcd dpcd,m.ag_name agname,h.amount amount,
        case when h.doctype='RCR' then (select "Payment_Mode_Name" from payment_mode_mast where "Pay_Mode_Code"=h.reason)
        else (select reason_name from cir_reason_mst where comp_code=h.comp_code and reason_code=h.reason) end as reason,
        h.remark remark 
        from cir_rcphdr h,cir_agmast m
        where h.comp_code=m.comp_code and h.comp_code=pcompcode and h.unit_code=punitcode  and h.unit_code=m.unit and h.recptdt >= v_frdt and h.recptdt<=v_todt and h.achd='NM' and h.amount<>0 and
        h.doctype in('CN','DN') and h.agcd=m.agcd and h.dpcd=m.dpcd and h.agcd=nvl(pbillagcd,h.agcd) and h.dpcd=nvl(pbilldpcd,h.dpcd) and h.branch_code=nvl(pbranchcode,h.branch_code) and 
        (m.ag_type=pagencytype or pagencytype is null) and (m.ag_class=pagencyclass or pagencyclass is null) and
        (m.dist_code=pdistcode or pdistcode is null) and (m.tehsil_taluka=ptaluka or ptaluka is null) and 
        (m.branch_code=pbranchcode or pbranchcode is null) and nvl(m.to_bill,'N')='Y' 
        order by m.ag_name,h.agcd,h.dpcd,h.recptdt,h.recptno;
    
        open p_accounts3 for 
        select comp_code,unit_code,agcd billagcd,dpcd billdpcd,cir_get_name.cir_agname(comp_code,unit_code,agcd,dpcd,plangtype,''''||pdateformat||'''','','') agency_name,
        sum(nvl(supply_copy,0)*nvl(supply_rate,0)) gross_amt,nvl(sum(comm_amt),0) comm_amt,nvl(sum(return_amt),0) return_amt,abs(sum(nvl(sec_amt,0))) sec_amt from cir_bill_print
        where comp_code=pcompcode and unit_code=punitcode and supply_date >= v_frdt and supply_date<=v_todt and 
        agcd=nvl(pbillagcd,agcd) and dpcd=nvl(pbilldpcd,dpcd) and cur_sessionid=userenv('sessionid')
        group by comp_code,unit_code,agcd,dpcd
        order by comp_code,unit_code,agency_name,agcd,dpcd;
        
        open p_accounts4 for 
        select comp_code,unit_code,billagcd,billdpcd,agency_name,
        abs(sum(p01)) as "SUN",abs(sum(p02)) as "MON",abs(sum(p03)) as "TUE",abs(sum(p04)) as "WED",abs(sum(p05)) as "THU",abs(sum(p06)) as "FRI",abs(sum(p07)) as "SAT",
        abs(sum(nvl(p01,0)+nvl(p02,0)+nvl(p03,0)+nvl(p04,0)+nvl(p05,0)+nvl(p06,0)+nvl(p07,0))) as "TOT_RECEIPT_AMT"
        from(
        select d.comp_code comp_code,d.unit_code unit_code,d.agcd billagcd,d.dpcd billdpcd,case when plangtype='1' then m.ag_name else m.ag_name_oth_lang  end agency_name,d.supply_date recptdt,
        case when to_char(d.supply_date,'DY')='SUN' then sum(nvl(d.rec_amt,0)) else 0 end p01,
        case when to_char(d.supply_date,'DY')='MON' then sum(nvl(d.rec_amt,0)) else 0 end p02,
        case when to_char(d.supply_date,'DY')='TUE' then sum(nvl(d.rec_amt,0)) else 0 end p03,
        case when to_char(d.supply_date,'DY')='WED' then sum(nvl(d.rec_amt,0)) else 0 end p04,
        case when to_char(d.supply_date,'DY')='THU' then sum(nvl(d.rec_amt,0)) else 0 end p05,
        case when to_char(d.supply_date,'DY')='FRI' then sum(nvl(d.rec_amt,0)) else 0 end p06,
        case when to_char(d.supply_date,'DY')='SAT' then sum(nvl(d.rec_amt,0)) else 0 end p07
        from cir_agmast m,cir_bill_print d 
        where d.comp_code=pcompcode and d.comp_code=m.comp_code and d.unit_code=m.unit and d.unit_code=punitcode and d.supply_date >= v_frdt and d.supply_date<=v_todt and 
        m.agcd=d.agcd and m.dpcd=d.dpcd and d.agcd=nvl(pbillagcd,d.agcd) and d.dpcd=nvl(pbilldpcd,d.dpcd) and (m.ag_type=pagencytype or pagencytype is null) and 
        (m.ag_class=pagencyclass or pagencyclass is null) and (m.dist_code=pdistcode or pdistcode is null) and (m.tehsil_taluka=ptaluka or ptaluka is null) and 
        (m.branch_code=pbranchcode or pbranchcode is null) and cur_sessionid=userenv('sessionid') 
        group by d.comp_code,d.unit_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,d.supply_date)
        group by comp_code,unit_code,billagcd,billdpcd,agency_name
        order by comp_code,unit_code,agency_name,billagcd,billdpcd;

        open p_accounts5 for select sysdate from dual;
        open p_accounts6 for select sysdate from dual;
        open p_accounts7 for select sysdate from dual;
        open p_accounts8 for select sysdate from dual;
        open p_accounts9 for select sysdate from dual;
        open p_accounts10 for select sysdate from dual;
            
        delete from cir_bill_print where cur_sessionid=userenv('sessionid');commit;
        delete from cir_bill_return_print where cur_sessionid=userenv('sessionid');commit;

    insert into ERRORMESSAGE(message) values('Weekly bill print p2 Complete ');commit;
    exception when others then
    insert into ERRORMESSAGE(message) values('Weekly bill print p2 error ');commit;        
   End cir_before_bill_print_p2;
       
    procedure cir_bill_register_p(
      pcomp_code    in varchar2,
      punit_code    in varchar2,
      ppubl         in varchar2,
      repty         in varchar2,--Is is used State(1)/District(2)/Taluka(3)
      pbill_freq    in varchar2,
      pfrom_billdt  in varchar2,
      ptill_billdt  in varchar2,
      pbillagcd     in varchar2,
      pbilldpcd     in varchar2,
      pdateformat   in varchar2,
      pextra1       in varchar2,--State or district or Taluka Code
      pextra2       in varchar2,
      p_accounts    out t_accounts)
    As
        vfrdt date;
        vtodt date;
        v_statecode   varchar2(20);
        v_distcode    varchar2(20);
        v_citycode    varchar2(20);
        v_taluka      varchar2(20);        
    Begin
        --delete from test1;insert into test1(vstring,vstring2) values('cir bill register ','pcomp_code '||pcomp_code||','||punit_code||','||ppubl||','||repty||','||pbill_freq||','||pfrom_billdt||','||ptill_billdt||','||pbillagcd||','||pbilldpcd||','||pdateformat||','||pextra1||','||pextra2);commit;
        if repty='1' then--State
            v_statecode:=pextra1;
        elsif repty='2' then    --District
            v_distcode:=pextra1;
        elsif repty='3' then    --Taluka
            v_taluka:=pextra1;
        else--City
            v_citycode:=pextra1;
        end if;        
        vfrdt:=to_date(pfrom_billdt,''''||pdateformat||'''');
        vtodt:=to_date(ptill_billdt,''''||pdateformat||'''');

        if nvl(repty,'N')='1' then--for state
            open p_accounts for
            select b.comp_code comp_code, b.unit_code unit_code, b.billno billno, b.billdt billdt, b.agcd agcd, b.dpcd dpcd, 
            min(b.publ) publ, sum(b.bill_copy) bill_copy, sum(b.gross_amount) gross_amount, sum(b.sur_amt) sur_amount, sum(b.comm_amt) comm_amount, 
            sum(b.bill_amount) bill_amount,max(b.bill_flag) bill_flag,null as  bill_remark, max(b.userid) userid, max(b.creation_date) creation_date, 
            b.branch_code branch_code,m.ag_name agency_name,cir_get_city(b.comp_code,m.city_code) as "CITY NAME",
            cir_get_state(b.comp_code,m.country_code,m.state_code) as "STATE_NAME"
            from cir_bill_det b,cir_agmast m
            where b.comp_code = pcomp_code and m.comp_code=b.comp_code and b.unit_code = nvl(punit_code,b.unit_code) and 
            m.unit=b.unit_code and b.agcd = nvl(pbillagcd,b.agcd) and m.agcd=b.agcd and b.dpcd = nvl(pbilldpcd,b.dpcd) and  
            m.dpcd=b.dpcd and b.billdt >= vfrdt and billdt <=vtodt and b.bill_flag = nvl(pbill_freq,b.bill_flag) and 
            b.publ = nvl(ppubl,b.publ) and (m.state_code=v_statecode or v_statecode is null) and (m.dist_code=v_distcode or v_distcode is null) and 
            (m.tehsil_taluka=v_taluka or v_taluka is null) and (m.city_code=v_citycode or v_citycode is null)
            group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code
            order by comp_code, state_name,agency_name,billdt,billno;
        elsif nvl(repty,'N')='2' then --for district
            open p_accounts for
            select b.comp_code comp_code, b.unit_code unit_code, b.billno billno, b.billdt billdt, b.agcd agcd, b.dpcd dpcd, 
            min(b.publ) publ, sum(b.bill_copy) bill_copy, sum(b.gross_amount) gross_amount, sum(b.sur_amt) sur_amount, sum(b.comm_amt) comm_amount, 
            sum(b.bill_amount) bill_amount,max(b.bill_flag) bill_flag,null as  bill_remark, max(b.userid) userid, max(b.creation_date) creation_date, 
            b.branch_code branch_code,m.ag_name agency_name,cir_get_city(b.comp_code,m.city_code) as "CITY NAME",
            cir_get_state(b.comp_code,m.country_code,m.state_code) as "STATE_NAME",
            cir_get_dist(b.comp_code,m.state_code,m.dist_code) AS "DIST_NAME" 
            from cir_bill_det b,cir_agmast m
            where b.comp_code = pcomp_code and m.comp_code=b.comp_code and b.unit_code = nvl(punit_code,b.unit_code) and 
            m.unit=b.unit_code and b.agcd = nvl(pbillagcd,b.agcd) and m.agcd=b.agcd and b.dpcd = nvl(pbilldpcd,b.dpcd) and  
            m.dpcd=b.dpcd and b.billdt >= vfrdt and billdt <=vtodt and b.bill_flag = nvl(pbill_freq,b.bill_flag) and 
            b.publ = nvl(ppubl,b.publ) and (m.state_code=v_statecode or v_statecode is null) and (m.dist_code=v_distcode or v_distcode is null) and 
            (m.tehsil_taluka=v_taluka or v_taluka is null) and (m.city_code=v_citycode or v_citycode is null)
            group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code,m.dist_code
            order by comp_code, state_name,dist_name,agency_name,billdt,billno;        
        elsif nvl(repty,'N')='3' then---for taluka
            open p_accounts for
            select b.comp_code comp_code, b.unit_code unit_code, b.billno billno, b.billdt billdt, b.agcd agcd, b.dpcd dpcd, 
            min(b.publ) publ, sum(b.bill_copy) bill_copy, sum(b.gross_amount) gross_amount, sum(b.sur_amt) sur_amount, sum(b.comm_amt) comm_amount, 
            sum(b.bill_amount) bill_amount,max(b.bill_flag) bill_flag,null as  bill_remark, max(b.userid) userid, max(b.creation_date) creation_date, 
            b.branch_code branch_code,m.ag_name agency_name,cir_get_city(b.comp_code,m.city_code) as "CITY NAME",
            cir_get_state(b.comp_code,m.country_code,m.state_code) as "STATE_NAME",
            cir_get_taluka(b.comp_code,m.tehsil_taluka) as "TALUKA_NAME"
            from cir_bill_det b,cir_agmast m
            where b.comp_code = pcomp_code and m.comp_code=b.comp_code and b.unit_code = nvl(punit_code,b.unit_code) and 
            m.unit=b.unit_code and b.agcd = nvl(pbillagcd,b.agcd) and m.agcd=b.agcd and b.dpcd = nvl(pbilldpcd,b.dpcd) and  
            m.dpcd=b.dpcd and b.billdt >= vfrdt and billdt <=vtodt and b.bill_flag = nvl(pbill_freq,b.bill_flag) and 
            b.publ = nvl(ppubl,b.publ) and (m.state_code=v_statecode or v_statecode is null) and (m.dist_code=v_distcode or v_distcode is null) and 
            (m.tehsil_taluka=v_taluka or v_taluka is null) and (m.city_code=v_citycode or v_citycode is null)
            group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code,m.tehsil_taluka
            order by comp_code, state_name,taluka_name,agency_name,billdt,billno;        
        else---for city
            open p_accounts for
            select b.comp_code comp_code, b.unit_code unit_code, b.billno billno, b.billdt billdt, b.agcd agcd, b.dpcd dpcd, 
            min(b.publ) publ, sum(b.bill_copy) bill_copy, sum(b.gross_amount) gross_amount, sum(b.sur_amt) sur_amount, sum(b.comm_amt) comm_amount, 
            sum(b.bill_amount) bill_amount,max(b.bill_flag) bill_flag,null as  bill_remark, max(b.userid) userid, max(b.creation_date) creation_date, 
            b.branch_code branch_code,m.ag_name agency_name,cir_get_city(b.comp_code,m.city_code) as "CITY NAME",
            cir_get_state(b.comp_code,m.country_code,m.state_code) as "STATE_NAME" 
            from cir_bill_det b,cir_agmast m
            where b.comp_code = pcomp_code and m.comp_code=b.comp_code and b.unit_code = nvl(punit_code,b.unit_code) and 
            m.unit=b.unit_code and b.agcd = nvl(pbillagcd,b.agcd) and m.agcd=b.agcd and b.dpcd = nvl(pbilldpcd,b.dpcd) and  
            m.dpcd=b.dpcd and b.billdt >= vfrdt and billdt <=vtodt and b.bill_flag = nvl(pbill_freq,b.bill_flag) and 
            b.publ = nvl(ppubl,b.publ) and (m.state_code=v_statecode or v_statecode is null) and (m.dist_code=v_distcode or v_distcode is null) and 
            (m.tehsil_taluka=v_taluka or v_taluka is null) and (m.city_code=v_citycode or v_citycode is null)
            group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code
            order by comp_code, state_name,"CITY NAME",agency_name,billdt,billno;        
        end if;
        
     End cir_bill_register_p;

/*
var v1 refcursor;
exec cir_rep_billing.cir_billing_outstanding_p('SP002','AUR','','M','01-nov-2010','30-nov-2010','','','','dd/mm/yyyy','','',:v1);
*/
        procedure cir_billing_outstanding_p(
            pcomp_code      in varchar2,
            punit_code      in varchar2,
            repty           in varchar2,
            pbill_freq      in varchar2,
            pfrom_billdt    in varchar2,
            ptill_billdt    in varchar2,
            ppubl           in varchar2,
            pbillagcd       in varchar2,
            pbilldpcd       in varchar2,
            pdateformat     in varchar2,
            pbrancode       in varchar2,
            pdistcode       in varchar2,
            pagclass        in varchar2,
            pextra1         in varchar2,--for executive code
            pextra2         in varchar2,
            p_accounts      out t_accounts,
            p_accounts1     out t_accounts)
    As
      v_bill_frdt   date;
      v_bill_todt   date;
      v_dt          date;
      v_statecode   varchar2(20);
      v_distcode    varchar2(20);
      v_citycode    varchar2(20);
      v_taluka      varchar2(20);

    cursor cur_bill is
        select distinct a.comp_code comp_code,a.unit_code unit_code,/*a.publ publ,*/a.agcd agcd,a.dpcd dpcd,b.ag_name ag_name,b.ag_name_oth_lang ag_name_oth_lang,
        b.city_code city_code,b.country_code country_code,b.state_code state_code,b.dist_code dist_code,b.tehsil_taluka taluka_code,
        /*a.billno billno,a.billdt billdt,*/sum(a.bill_copy) supply_copy,sum(a.gross_amount) gross_amount,sum(a.sur_amt) sur_amount,sum(a.comm_amt) comm_amount,
        c.bill_sec_amt bill_sec_amt,b.station_code drop_point
        from cir_bill_det a,cir_agmast b,cir_bill c
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=pcomp_code and
                  a.unit_code=b.unit and a.unit_code=c.unit_code and
                  a.unit_code=nvl(punit_code,a.unit_code) and
                  a.billdt=c.billdt and a.billdt >= v_bill_frdt and a.billdt<=v_bill_todt and a.billno=c.billno and
                  (a.bill_flag=pbill_freq or pbill_freq is null) and a.publ=nvl(ppubl,a.publ) and a.agcd=b.agcd and a.dpcd=b.dpcd and
                  a.agcd=c.agcd and a.dpcd=c.dpcd and a.agcd=nvl(pbillagcd,a.agcd) and a.dpcd=nvl(pbilldpcd,a.dpcd) and
                  (b.ag_class=pagclass or pagclass is null) and
                  (b.state_code=v_statecode or v_statecode is null) and (b.dist_code=v_distcode or v_distcode is null) and
                  (b.tehsil_taluka=v_taluka or v_taluka is null) and (b.branch_code=pbrancode or pbrancode is null) and
                  (b.city_code=v_citycode or v_citycode is null) and (b.executive_code = pextra1 or pextra1 is null)
                  group by a.comp_code,a.unit_code,/*a.publ,*/a.agcd,a.dpcd,b.ag_name,b.ag_name_oth_lang,
                  b.city_code,b.country_code,b.state_code,b.dist_code,b.tehsil_taluka,c.bill_sec_amt,b.station_code /*,a.billno,a.billdt*/
                  order by a.comp_code,a.unit_code,/*a.billdt,a.billno,*/a.agcd,a.dpcd/*,a.publ*/;
        v1 cur_bill%rowtype;

      cursor cur_type is
        select doctyp,sum(amount) amount from cir_outmast
            where comp_code=v1.comp_code and unit_code=v1.unit_code and
                achd='NM' and doctyp not in('BIL','UCN') and recptdt>=v_bill_frdt and recptdt<=v_bill_todt and
                agcd=v1.agcd and dpcd=v1.dpcd
            group by doctyp;
        v2 cur_type%rowtype;
        v_dsign           number(2);
        v_comp_code       varchar2(8);
        v_unit_code       varchar2(8);
        v_publ_code       varchar2(8);
        v_agcode          varchar2(20);
        v_depo_code       varchar2(20);
        v_agname          varchar2(200);
        v_agname_oth_lang varchar2(250);
        v_billno          varchar2(20);
        v_bildt           date;
        v_frdt            date;
        v_todt            date;
        v_ret_gross       number(15,2):=0;
        v_ret_comm        number(15,2):=0;
        v_ret_copy        number(15):=0;
        v_dn_amt          number(15,2):=0;
        v_cn_amt          number(15,2):=0;
        v_rec_amt         number(15,2):=0;
        v_prev_bal        number(15,2):=0;
        v_sec_bal         number(15,2):=0;
        v_opdate          date;
        v_state_name      varchar2(200);
        v_dist_name       varchar2(200);
        v_taluka_name     varchar2(200);
        v_city_name       varchar2(200);
        v_drop_point_name varchar2(200);
    Begin
    v_bill_frdt     :=to_date(pfrom_billdt,''''||pdateformat||'''');
    v_bill_todt     :=to_date(ptill_billdt,''''||pdateformat||'''');
    v_opdate        :=cir_get_finandt(pcomp_code,to_date(pfrom_billdt,''''||pdateformat||''''),pdateformat,'','');

    if repty='S' then
        v_statecode:=pdistcode;
    elsif repty='D' then
        v_distcode:=pdistcode;
    elsif repty='C' then
        v_citycode:=pdistcode;
    else
        v_taluka:=pdistcode;
    end if;

    --delete from test1;commit;
    --insert into test1(vstring,vstring2) values('cir_billing_outstanding ','pfrom_billdt '||pfrom_billdt||' ptill_billdt '||ptill_billdt||' repty '||repty||' pextra1 '||pextra1);commit;
        delete from cir_temp_bill_collection where cur_sessionid=userenv('sessionid');
        Open cur_bill;---main cursor bill
        Loop
            fetch cur_bill into v1;
            exit when cur_bill%notfound;

            select sum(nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0)) tot_return,
            nvl(sum(copy_amt),0) gross_amt,
            sum((nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))*nvl(copy_rate,0))-nvl(sum(copy_amt),0) comm_amt into
            v_ret_copy,v_ret_gross,v_ret_comm from cir_unsold_dtl
            where comp_code=v1.comp_code and unit_code=v1.unit_code and
                doctype='UCN' and process_crdt >= v_bill_frdt and process_crdt<=v_bill_todt and agcd=v1.agcd and
                dpcd=v1.dpcd and process_crno is not null/*and publ=v1.publ*/;

            v_prev_bal  :=cir_accounts.cir_agency_opbal(v1.comp_code,v1.unit_code,'',v1.agcd,v1.dpcd,v_opdate,'NM',pdateformat,pextra1,pextra2);
            v_sec_bal   :=cir_accounts.cir_agency_opbal(v1.comp_code,v1.unit_code,'',v1.agcd,v1.dpcd,v_opdate,'SC',pdateformat,pextra1,pextra2);

            select sum(amount) into v_rec_amt from
            (select sum(amount) amount  from cir_outmast
            where comp_code=v1.comp_code and unit_code=v1.unit_code and
            achd='NM' and doctyp='BIL' and billdt>=v_opdate and billdt<v_bill_frdt and agcd=v1.agcd and dpcd=v1.dpcd
            union all
            select sum(amount) amount from cir_rcphdr
            where comp_code=v1.comp_code and unit_code=v1.unit_code and
            agcd=v1.agcd and dpcd=v1.dpcd and doctype<>'BIL' and recptdt>=v_opdate and recptdt<v_bill_frdt and achd='NM') ;

            v_prev_bal  :=nvl(v_prev_bal,0)+nvl(v_rec_amt,0);

            v_rec_amt:=0;

            select sum(amount) into v_rec_amt from cir_rcphdr where comp_code=v1.comp_code and unit_code=v1.unit_code and
            agcd=v1.agcd and dpcd=v1.dpcd and recptdt>=v_opdate and recptdt<=v_bill_todt and achd='SC';

            v_sec_bal   :=nvl(v_sec_bal,0)+nvl(v_rec_amt,0);

            v_rec_amt:=0;
            open cur_type;
            loop
                fetch cur_type into v2;
                exit when cur_type%notfound;
                begin
                    select dsign into v_dsign from cir_docmst where comp_code=v1.comp_code and doc_type=v2.doctyp;
                exception when others then
                    v_dsign:=1;
                end;
                if v_dsign>0 then
                    v_dn_amt:=nvl(v_dn_amt,0)+nvl(v2.amount,0);
                else
                    if v2.doctyp='RCR' then
                        v_rec_amt:=nvl(v_rec_amt,0)+nvl(v2.amount,0);
                    else
                        v_cn_amt:=nvl(v_cn_amt,0)+nvl(v2.amount,0);
                    end if;
                end if;
            end loop;
            close cur_type;

            v_state_name        :=cir_get_state(v1.comp_code,v1.country_code,v1.state_code);
            v_drop_point_name   :=cir_get_drop_point_name(v1.comp_code,v1.unit_code,v1.drop_point,1);
            if repty='S' then
                null;
            else
                v_dist_name     :=cir_get_name.cir_district(v1.comp_code,v1.dist_code,'1','','','');
                if repty='D' then
                    null;
                elsif repty='C' then
                    v_city_name     :=cir_get_city(v1.comp_code,v1.city_code);
                else
                    begin
                        v_taluka_name   :=cir_get_name.cir_taluka(v1.comp_code,v1.taluka_code,'1','','','');
                    exception when others then
                        v_taluka_name   :='N/A';
                    end;
                end if;
            end if;
            /*v_state_name    :=cir_get_state(v1.comp_code,v1.country_code,v1.state_code);
            v_dist_name     :=cir_get_name.cir_district(v1.comp_code,v1.dist_code,'1','','','');
            begin
                v_taluka_name   :=cir_get_name.cir_taluka(v1.comp_code,v1.taluka_code,'1','','','');
            exception when others then
                v_taluka_name   :='N/A';
            end;
            v_city_name     :=cir_get_city(v1.comp_code,v1.city_code);*/

            insert into cir_temp_bill_collection(comp_code,unit_code,billno,billdt,publ_code,agcd,dpcd,
                                supply_copy, gross_amt, comm_amt, sur_amt, return_copy, return_amt,ret_comm_amt, dn_amt, rec_amt, prev_bal,cn_amt,cur_sessionid,
                                agname, agname_oth_lang, city_code, taluka_code, dist_code, state_code, remarks,bill_sec_amt,sec_opbal)
            values(v1.comp_code,  v1.unit_code  , null   ,null  , ''    ,v1.agcd,v1.dpcd,
            v1.supply_copy,v1.gross_amount,nvl(v1.comm_amount,0),v1.sur_amount,v_ret_copy,v_ret_gross,v_ret_comm,
            v_dn_amt,v_rec_amt,v_prev_bal,v_cn_amt,userenv('sessionid'),
            v1.ag_name,v1.ag_name_oth_lang,v_city_name,v_taluka_name,v_dist_name,v_state_name,v_drop_point_name,
            v1.bill_sec_amt,v_sec_bal);
            

            v_dsign:=0;v_ret_gross:=0;v_ret_comm:=0; v_ret_copy:=0; v_dn_amt:=0; v_cn_amt:=0; v_rec_amt:=0; v_prev_bal:=0;v_sec_bal:=0;
            v_state_name:=null;v_dist_name:=null;v_taluka_name:=null;v_city_name:=null;
        End Loop;
        Close cur_bill;
        commit;
        if repty='S' then
            open p_accounts for
            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,A.AGNAME AG_NAME,A.AGNAME_OTH_LANG AG_NAME_OTH_LANG,
            A.STATE_CODE STATE_NAME,
            SUM(NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)) BILL_AMT,SUM(A.COMM_AMT) COMM_AMT,SUM((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))) NET_BILL,
            SUM(NVL(A.RETURN_AMT,0)+NVL(RET_COMM_AMT,0)) RETURN_AMT,SUM(NVL(A.RETURN_AMT,0)) NET_RETURN_AMT,
            SUM((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))-NVL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(NVL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))-NVL(A.RETURN_AMT,0)+NVL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(NVL(A.DN_AMT,0)-NVL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(NVL(A.DN_AMT,0)+NVL(A.CN_AMT,0)-NVL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))-NVL(A.RETURN_AMT,0)+NVL(A.BILL_SEC_AMT,0)+NVL(A.PREV_BAL,0)+NVL(A.REC_AMT,0)+NVL(A.DN_AMT,0)+NVL(A.CN_AMT,0)-NVL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(NVL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE,A.REMARKS DROP_POINT
            from cir_temp_bill_collection a
            where cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.state_code,a.remarks
            order by comp_code,unit_code,state_name,ag_name;

            open p_accounts1 for
            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.STATE_CODE STATE_NAME,
            SUM(NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)) BILL_AMT,SUM(A.COMM_AMT) COMM_AMT,SUM((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))) NET_BILL,
            SUM(A.RETURN_COPY) RETURN_COPY,SUM(NVL(A.RETURN_AMT,0)+NVL(RET_COMM_AMT,0)) RETURN_AMT,SUM(NVL(A.RETURN_AMT,0))  NET_RETURN_AMT,
            SUM((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))-NVL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(NVL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))-NVL(A.RETURN_AMT,0)+NVL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(NVL(A.DN_AMT,0)-NVL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(NVL(A.DN_AMT,0)+NVL(A.CN_AMT,0)-NVL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))-NVL(A.RETURN_AMT,0)+NVL(A.BILL_SEC_AMT,0)+NVL(A.PREV_BAL,0)+NVL(A.REC_AMT,0)+NVL(A.DN_AMT,0)+NVL(A.CN_AMT,0)-NVL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(NVL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE
            from cir_temp_bill_collection a
            where cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.state_code
            order by comp_code,unit_code,state_name;
        elsif repty='D' then
            open p_accounts for
            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,A.AGNAME AG_NAME,A.AGNAME_OTH_LANG AG_NAME_OTH_LANG,
            A.STATE_CODE STATE_NAME,A.DIST_CODE DISTRICT_NAME,
            SUM(NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)) BILL_AMT,SUM(A.COMM_AMT) COMM_AMT,SUM((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))) NET_BILL,
            SUM(NVL(A.RETURN_AMT,0)+NVL(RET_COMM_AMT,0)) RETURN_AMT,SUM(A.RETURN_AMT) NET_RETURN_AMT,
            SUM((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))-NVL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(NVL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))-NVL(A.RETURN_AMT,0)+NVL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(NVL(A.DN_AMT,0)-NVL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(NVL(A.DN_AMT,0)+NVL(A.CN_AMT,0)-NVL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))-NVL(A.RETURN_AMT,0)+NVL(A.BILL_SEC_AMT,0)+NVL(A.PREV_BAL,0)+NVL(A.REC_AMT,0)+NVL(A.DN_AMT,0)+NVL(A.CN_AMT,0)-NVL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(NVL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE,A.REMARKS DROP_POINT
            from cir_temp_bill_collection a
            where cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.state_code,a.dist_code,a.remarks
            order by comp_code,unit_code,state_name,district_name,ag_name;

            open p_accounts1 for
            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.DIST_CODE DISTRICT_NAME,
            A.STATE_CODE STATE_NAME,
            SUM(A.SUPPLY_COPY) SUPPLY_CODE,SUM(NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)) BILL_AMT,SUM(A.COMM_AMT) COMM_AMT,SUM(NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0)) NET_BILL,
            SUM(A.RETURN_COPY) RETURN_COPY,SUM(NVL(A.RETURN_AMT,0)+NVL(RET_COMM_AMT,0)) RETURN_AMT,SUM(A.RETURN_AMT) NET_RETURN_AMT,
            SUM((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))-NVL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(NVL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))-NVL(A.RETURN_AMT,0)+NVL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(NVL(A.DN_AMT,0)-NVL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(NVL(A.DN_AMT,0)+NVL(A.CN_AMT,0)-NVL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))-NVL(A.RETURN_AMT,0)+NVL(A.BILL_SEC_AMT,0)+NVL(A.PREV_BAL,0)+NVL(A.REC_AMT,0)+NVL(A.DN_AMT,0)+NVL(A.CN_AMT,0)-NVL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(NVL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE
            from cir_temp_bill_collection a
            where cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.state_code,a.dist_code
            order by comp_code,unit_code,state_name,district_name;

        elsif repty='C' then
            open p_accounts for
            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,A.AGNAME AG_NAME,A.AGNAME_OTH_LANG AG_NAME_OTH_LANG,
            A.STATE_CODE STATE_NAME,A.DIST_CODE DISTRICT_NAME,A.CITY_CODE CITY_NAME,
            SUM(NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)) BILL_AMT,SUM(A.COMM_AMT) COMM_AMT,SUM((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))) NET_BILL,
            SUM(NVL(A.RETURN_AMT,0)+NVL(RET_COMM_AMT,0)) RETURN_AMT,SUM(A.RETURN_AMT) NET_RETURN_AMT,
            SUM((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))-NVL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(NVL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))-NVL(A.RETURN_AMT,0)+NVL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(NVL(A.DN_AMT,0)-NVL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(NVL(A.DN_AMT,0)+NVL(A.CN_AMT,0)-NVL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))-NVL(A.RETURN_AMT,0)+NVL(A.BILL_SEC_AMT,0)+NVL(A.PREV_BAL,0)+NVL(A.REC_AMT,0)+NVL(A.DN_AMT,0)+NVL(A.CN_AMT,0)-NVL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(NVL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE,A.REMARKS DROP_POINT
            from cir_temp_bill_collection a
            where cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.state_code,a.dist_code,a.city_code,a.remarks
            order by comp_code,unit_code,state_name,district_name,city_name,ag_name;

            open p_accounts1 for
            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.CITY_CODE CITY_NAME,
            A.DIST_CODE DISTRICT_NAME,A.STATE_CODE STATE_NAME,
            SUM(NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)) BILL_AMT,A.COMM_AMT COMM_AMT,(NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0)) NET_BILL,
            SUM(NVL(A.RETURN_AMT,0)+NVL(RET_COMM_AMT,0)) RETURN_AMT,SUM(A.RETURN_AMT) NET_RETURN_AMT,
            SUM((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))-NVL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(NVL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))-NVL(A.RETURN_AMT,0)+NVL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(NVL(A.DN_AMT,0)-NVL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(NVL(A.DN_AMT,0)+NVL(A.CN_AMT,0)-NVL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))-NVL(A.RETURN_AMT,0)+NVL(A.BILL_SEC_AMT,0)+NVL(A.PREV_BAL,0)+NVL(A.REC_AMT,0)+NVL(A.DN_AMT,0)+NVL(A.CN_AMT,0)-NVL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(NVL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE
            from cir_temp_bill_collection a
            where cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.city_code,a.dist_code,a.state_code
            order by comp_code,unit_code,state_name,district_name,city_name;
        else
            open p_accounts for
            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,A.AGNAME AG_NAME,A.AGNAME_OTH_LANG AG_NAME_OTH_LANG,
            A.STATE_CODE STATE_NAME,A.DIST_CODE DISTRICT_NAME,
            A.TALUKA_CODE||'('||A.DIST_CODE||')' TALUKA_NAME,
            SUM(NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)) BILL_AMT,SUM(A.COMM_AMT) COMM_AMT,SUM((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))) NET_BILL,
            SUM(NVL(A.RETURN_AMT,0)+NVL(RET_COMM_AMT,0)) RETURN_AMT,SUM(A.RETURN_AMT) NET_RETURN_AMT,
            SUM((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))-NVL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(NVL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))-NVL(A.RETURN_AMT,0)+NVL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(NVL(A.DN_AMT,0)-NVL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(NVL(A.DN_AMT,0)+NVL(A.CN_AMT,0)-NVL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))-NVL(A.RETURN_AMT,0)+NVL(A.BILL_SEC_AMT,0)+NVL(A.PREV_BAL,0)+NVL(A.REC_AMT,0)+NVL(A.DN_AMT,0)+NVL(A.CN_AMT,0)-NVL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(NVL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE,A.REMARKS DROP_POINT
            from cir_temp_bill_collection a
            where cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.taluka_code,a.dist_code,a.remarks,a.state_code
            order by comp_code,unit_code,state_name,district_name,taluka_name,ag_name;

            open p_accounts1 for
            SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.STATE_CODE STATE_NAME,A.DIST_CODE DISTRICT_NAME,
            A.TALUKA_CODE||'('||A.DIST_CODE||')' TALUKA_NAME,
            SUM(NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)) BILL_AMT,SUM(A.COMM_AMT) COMM_AMT,SUM((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))) NET_BILL,
            SUM(NVL(A.RETURN_AMT,0)+NVL(RET_COMM_AMT,0)) RETURN_AMT,SUM(A.RETURN_AMT) NET_RETURN_AMT,
            SUM((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))-NVL(A.RETURN_AMT,0)) TOTAL_BILL,ABS(SUM(NVL(A.BILL_SEC_AMT,0))) DEP_ADJ,
            SUM((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))-NVL(A.RETURN_AMT,0)+NVL(A.BILL_SEC_AMT,0)) TOTAL_NET,
            SUM(A.PREV_BAL) PREV_BAL, ABS(SUM(A.REC_AMT)) REC_AMT,SUM(NVL(A.DN_AMT,0)-NVL(A.BILL_SEC_AMT,0)) DN_AMT, SUM(A.CN_AMT) CN_AMT,SUM(NVL(A.DN_AMT,0)+NVL(A.CN_AMT,0)-NVL(A.BILL_SEC_AMT,0)) DR_CR_AMT,
            SUM(((NVL(A.GROSS_AMT,0)+NVL(A.SUR_AMT,0)-NVL(A.COMM_AMT,0))-NVL(A.RETURN_AMT,0)+NVL(A.BILL_SEC_AMT,0)+NVL(A.PREV_BAL,0)+NVL(A.REC_AMT,0)+NVL(A.DN_AMT,0)+NVL(A.CN_AMT,0)-NVL(A.BILL_SEC_AMT,0))) NET_BAL,
            ABS(SUM(NVL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE
            from cir_temp_bill_collection a
            where cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.taluka_code,a.dist_code,a.state_code
            order by comp_code,unit_code,state_name,district_name,taluka_name;
        end if;

        delete from cir_temp_bill_collection where cur_sessionid=userenv('sessionid');
    End cir_billing_outstanding_p;    

    procedure cir_unitwise_p(
        pcomp_code    in varchar2,
        punit_code    in varchar2,
        ppubl_code    in varchar2,
        pbill_freq    in varchar2,
        pfrom_billdt  in varchar2,
        ptill_billdt  in varchar2,
        pdateformat   in varchar2,
        pextra1       in varchar2,
        pextra2       in varchar2,
        p_accounts    out t_accounts) as
        vquery varchar2(4000);
        vquery_all varchar2(4000);
        v_bill_frdt date;
        v_bill_todt date;
        cursor cur_mon is select distinct mon_date,to_char(mon_date,'Mon-YY') mon  from col_dates;
        rec_mon cur_mon%rowtype;
      Begin
        vquery:=null;
        v_bill_frdt    :=to_date(pfrom_billdt,''''||pdateformat||'''');
        v_bill_todt    :=to_date(ptill_billdt,''''||pdateformat||'''');
        delete from col_dates;commit;
        insert into col_dates (mon_date) (select distinct trunc(billdt,'MM') from cir_bill
                                                where comp_code=pcomp_code and
                                                      ((unit_code=punit_code) or (punit_code is null)) and
                                                      ((publ     =ppubl_code) or (ppubl_code is null)) and
                                                      ((bill_flag=pbill_freq) or (pbill_freq is null)) and
                                                      billdt between v_bill_frdt and v_bill_todt);
         open cur_mon;
           loop
              fetch cur_mon into rec_mon;
                /*vquery:=vquery||'cir_get_unit_billamt(a.comp_code,a.unit_code,'||''''||ppubl_code||''''||','||''''||pbill_freq||''''||',
                          to_date('||''''||rec_mon.mon_date||''''||','||''''||pdateformat||''''||'))'||'"'||rec_mon.mon||'",';*/
                exit when cur_mon%notfound;
                vquery:=vquery||'cir_get_unit_billamt(a.comp_code,a.unit_code,'||''''||ppubl_code||''''||','||''''||pbill_freq||''''||','||''''||rec_mon.mon_date||''''||') "'||rec_mon.mon||'",';
           end loop;
         close cur_mon;
         vquery:=substr(vquery,1,length(vquery)-1);
         if vquery is null then
            vquery_all:='select distinct a.unit_code,b."Pub_Cent_name" unit_name from cir_bill a,pub_cent_mast b
                    where a.comp_code=b."Comp_Code" and a.unit_code=b."Pub_cent_Code" and comp_code='||''''||pcomp_code||''''||' and ((unit_code='||''''||punit_code||''''||') or ('||''''||punit_code||''''||' is null)) and
                                                      ((publ     ='||''''||ppubl_code||''''||') or ('||''''||ppubl_code||''''||' is null)) and
                                                      ((bill_flag='||''''||pbill_freq||''''||') or ('||''''||pbill_freq||''''||' is null)) and
                                                      billdt between '||''''||v_bill_frdt||''''||' and '||''''||v_bill_todt||'''';
         else
            vquery_all:='select distinct a.unit_code,b."Pub_Cent_name" unit_name,'||vquery||' from cir_bill a,pub_cent_mast b
                    where /*a.comp_code=b."Comp_Code" and */a.unit_code=b."Pub_cent_Code" and comp_code='||''''||pcomp_code||''''||' and ((unit_code='||''''||punit_code||''''||') or ('||''''||punit_code||''''||' is null)) and
                                                      ((publ     ='||''''||ppubl_code||''''||') or ('||''''||ppubl_code||''''||' is null)) and
                                                      ((bill_flag='||''''||pbill_freq||''''||') or ('||''''||pbill_freq||''''||' is null)) and
                                                      billdt between '||''''||v_bill_frdt||''''||' and '||''''||v_bill_todt||'''';
         end if;                                                         
          --insert into test1(vstring) values(vquery_all);commit;
          open p_accounts for vquery_all;
      End cir_unitwise_p;

      procedure cir_billing_rate_p (
        pcomp_code            in varchar2,
        punit_code            in varchar2,
        ppubl                 in varchar2,
        pagcd                 in varchar2,
        pdpcd                 in varchar2,
        BILLNO_FROM           in varchar2,
        BILLNO_TO             in varchar2,
        pfrom_billdt          in varchar2,
        ptill_billdt          in varchar2,
        pdateformat           in varchar2,
        pextra1               in varchar2,
        pextra2               in varchar2,
        p_accounts            out t_accounts,
        p_accounts1           out t_accounts,
        p_accounts2           out t_accounts,
        p_accounts3           out t_accounts)
    AS
        vquery   varchar2(4000);
        vquery1  varchar2(4000);
        vquery2  varchar2(4000);
        vquery3  varchar2(4000);
        v_bill_frdt date;
        v_bill_todt date;
    Begin
        v_bill_frdt    :=to_date(pfrom_billdt,''''||pdateformat||'''');
        v_bill_todt    :=to_date(ptill_billdt,''''||pdateformat||'''');

           open p_accounts for
           select comp_code,unit_code,billno,publ,agcd,dpcd,copy_rate,bill_copy,(copy_rate*bill_copy) AS "TOTAL"
               from cir_bill_det
                where comp_code=pcomp_code and unit_code=punit_code
                and BILLDT  between v_bill_frdt and v_bill_todt
                and ((publ=ppubl ) or (ppubl is null))
                and ((agcd=pagcd) or (pagcd is null))
                and ((dpcd=pdpcd) or (pdpcd is null))
                group by comp_code,unit_code,billno,publ,agcd,dpcd,copy_rate,bill_copy;

          vquery1 := vquery1||'SELECT SUM(a.SUP_COPY),a.comp_code,a.unit_code,b.billno,a.agcd,a.dpcd
                            from cir_dbksup a,cir_bill_det b
                            where a.COMP_CODE='''||pcomp_code||'''
                            and( a.unit_code='''||punit_code||''' or '''||punit_code||''' IS NULL)
                            and ((a.publ='''||ppubl||''' ) or ('''||ppubl||'''  is null))
                            and ((a.agcd='''||pagcd||''' ) or ('''||pagcd||'''  is null))
                            and ((a.dpcd='''||pdpcd||''') or ('''||pdpcd||'''  is null))   AND
                            a.AGCD || a.DPCD =b.AGCD || b.DPCD  AND
                            a.UNIT_CODE=b.UNIT_CODE AND
                            b.COMP_CODE=a.COMP_CODE
                            AND (b.PUBL='''||ppubl||''' OR '''||ppubl||''' IS NULL)
                            and b.BILLDT  between '''||v_bill_frdt||''' and '''||v_bill_todt||'''
                            AND a.SUPDATE BETWEEN  b.FROMDT AND  b.TODT
                            AND a.EDTN =b.EDTN
                            and a.SUP_TYPE_CODE IN
                            (SELECT cir_supply_type_mast.SUP_TY_CODE FROM cir_supply_type_mast WHERE cir_supply_type_mast.BILL_PAY=''N''
                            AND cir_supply_type_mast.COMP_CODE=a.COMP_CODE AND a.SUP_TYPE_CODE=cir_supply_type_mast.SUP_TY_CODE )
                            group by a.comp_code,a.unit_code,b.billno,a.agcd,a.dpcd';
                        --   INSERT INTO SEARCHTBL VALUES(vquery1);COMMIT;
                        open p_accounts1 for
                       vquery1;

        vquery2 := vquery2||'SELECT SUM(a.AMOUNT) as "CREDIT_AMT",a.comp_code comp_code,a.BILLNO BILLNO,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd
                             from cir_outmast a
                             where a.COMP_CODE='''||PCOMP_CODE||'''
                             and( a.unit_code='''||punit_code||'''  or '''||punit_code||'''  IS NULL)
                             and (a.BILLNO between  '''||BILLNO_FROM||''' AND '''||BILLNO_TO||''')
                             and ((a.publ='''||ppubl||''' ) or ('''||ppubl||''' is null))
                             and ((a.agcd='''||pagcd||''' ) or ('''||pagcd||''' is null))
                             and ((a.dpcd='''||pdpcd||''') or ('''||pdpcd||''' is null)) AND
                             a.AGCD || a.DPCD IN(SELECT b.AGCD || b.DPCD FROM cir_bill b
                             WHERE a.UNIT_CODE=b.UNIT_CODE AND b.COMP_CODE=a.COMP_CODE
                           --AND b.PUBL=a.PUBL
                             AND b.billdt between '''||v_bill_frdt||''' and '''||v_bill_todt||''')
                             and a.RECPTDT between '''||v_bill_frdt||''' and '''||v_bill_todt||''' AND
                             a.DOCTYP in(''UCN'',''CN'') and a.achd<>''SC''
                             group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.BILLNO';

                             open p_accounts2 for
                                  vquery2;

         vquery3 := vquery3||'SELECT SUM(a.AMOUNT) as "DEBIT_AMT",a.comp_code comp_code,a.BILLNO BILLNO, a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd
                                from cir_outmast a
                                where a.COMP_CODE='''||PCOMP_CODE||'''
                                and( a.unit_code='''||punit_code||''' or '''||punit_code||''' IS NULL)
                                and (a.BILLNO between  '''||BILLNO_FROM||''' AND '''||BILLNO_TO||''')
                                and ((a.publ='''||ppubl||'''  ) or ('''||ppubl||'''  is null))
                                and ((a.agcd='''||pagcd||'''  ) or ('''||pagcd||'''  is null))
                                and ((a.dpcd='''||pdpcd||''') or ('''||pdpcd||''' is null)) AND
                                a.AGCD || a.DPCD IN(SELECT b.AGCD || b.DPCD FROM cir_bill b
                                WHERE a.UNIT_CODE=b.UNIT_CODE AND b.COMP_CODE=a.COMP_CODE
                                --AND b.PUBL=a.PUBL
                                AND b.billdt between '''||v_bill_frdt||''' and '''||v_bill_todt||''')
                                and a.RECPTDT between '''||v_bill_frdt||''' and '''||v_bill_todt||''' AND
                                a.DOCTYP in(''DN'') and a.achd<>''SC''
                                group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.BILLNO';

        open p_accounts3 for vquery3;

     End  cir_billing_rate_p;

  Procedure cir_before_bill_process_p(
    pcomp_code         in varchar2,
    punit_code         in varchar2,
    ppubl_freq         in varchar2,
    ppubl             in varchar2,
    pfrdt             in varchar2,
    ptodt             in varchar2,
    pbillagcd       in varchar2,
    pbilldpcd       in varchar2,
    pagencytype     in varchar2,
    pagencyclass    in varchar2,
    pbranchcode     in varchar2,
    pdistcode       in varchar2,
    ptaluka         in varchar2,
    pdateformat     in varchar2,
    puserid         in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2)
  As
       ln_count           number;
       vsrch_amt           number;                                
       --bill_no               varchar2(20) ;
       daily_gross_amount number(15,2);
       daily_net_amount   number(15,2);
       tot_surcharge_amt  number(15,2);
       vcomm_per           number;
       vcomm_amt           number(15,2);
       curr_bilagcd           varchar2(30) := 'DUMMY_CURR';
       prev_bilagcd       varchar2(30) := 'DUMMY_PREV';
       curr_record           varchar2(100):= 'DUMMY_CURR'; --new add
       prev_record           varchar2(100):= 'DUMMY_PREV'; --new add
       tot_copy           number := 0;
       vbill_no            varchar2(20);
       vid                   number;
       v_frdt               date;
       v_todt               date;
       v_billdt           date;
        
       v_agcd_sec_per  number:=0;v_agcd_sec_amt_limt number:=0;
        
        v_sec_limit     number(10,2);
        v_bill_dbn_amt  number(10,2);
        v_bill_sec_amt  number(10,2);
        v_remark varchar2(200);
        v_reptno varchar2(25);
        v_rec_no            number(10);
        v_daily_comm_amt    number(15,2);
        v_daily_sur_amt     number(15,2);
        v_daily_gross_amt   number(15,2);
        v_daily_bill_amt    number(15,2);
        v_return_copy       number(10);
        v_return_amt        number(10,2);
      cursor agency_cur is
            /*select distinct m.comp_code comp_code,m.unit unit,m.agcd bill_agcd,m.dpcd bill_dpcd from 
            (select distinct a.comp_code,a.unit,a.bill_agcd,a.bill_dpcd
            from cir_agmast a
            where  a.comp_code = pcomp_code and a.unit     = punit_code and 
            a.agcd||a.dpcd in (select distinct agcd||dpcd agcdpdcd from cir_dbksup 
            where comp_code = pcomp_code and unit_code = punit_code and publ = nvl(ppubl,publ) and
            supdate >= v_frdt and supdate <=v_todt and nvl(sup_copy,0)>0
            union
            select distinct agcd||dpcd from cir_dbksup_resale 
            where comp_code = pcomp_code and unit_code = punit_code and publ = nvl(ppubl,publ) and
            supdate >= v_frdt and supdate <=v_todt and nvl(sup_copy,0)>0) and 
            a.bill_agcd=nvl(pbillagcd,a.bill_agcd) and a.bill_dpcd=nvl(pbilldpcd,a.bill_dpcd) and
            a.bill_agcd is not null and a.bill_dpcd is not null and nvl(a.to_bill,'N')='Y') u,cir_agmast m
            where u.comp_code = m.comp_code and u.comp_code = pcomp_code and u.unit=m.unit and u.unit = punit_code and 
            u.bill_agcd=m.agcd and u.bill_dpcd=m.dpcd and
            (m.ag_type=pagencytype or pagencytype is null) and (m.ag_class=pagencyclass or pagencyclass is null) and 
            (m.dist_code=pdistcode or pdistcode is null) and (m.tehsil_taluka=ptaluka or ptaluka is null) and 
            (m.branch_code=pbranchcode or pbranchcode is null)
            order by m.comp_code,m.unit,m.agcd,m.dpcd;*/
            select distinct x.comp_code comp_code,x.unit_code unit,x.billagcd bill_agcd,x.billdpcd bill_dpcd 
            from(select u.comp_code,u.unit_code,u.agcd,u.dpcd,u.billagcd,u.billdpcd 
            from(select distinct comp_code,unit_code,agcd,dpcd,billagcd,billdpcd  from cir_dbksup 
            where comp_code = pcomp_code and unit_code = punit_code and publ = nvl(ppubl,publ) and
            supdate >= v_frdt and supdate <=v_todt and nvl(sup_copy,0)>0
            union
            select distinct comp_code,unit_code,agcd,dpcd,billagcd,billdpcd from cir_dbksup_resale 
            where comp_code = pcomp_code and unit_code = punit_code and publ = nvl(ppubl,publ) and
            supdate >= v_frdt and supdate <=v_todt and nvl(sup_copy,0)>0) u,cir_agmast a
            where a.comp_code=u.comp_code and a.unit=u.unit_code and a.agcd=u.agcd and a.dpcd=u.dpcd and
            u.billagcd=nvl(pbillagcd,u.billagcd) and u.billdpcd=nvl(pbilldpcd,u.billdpcd) and
            a.bill_agcd is not null and a.bill_dpcd is not null and nvl(a.to_bill,'N')='Y' and
            (a.ag_type=pagencytype or pagencytype is null) and (a.ag_class=pagencyclass or pagencyclass is null) and 
            (a.dist_code=pdistcode or pdistcode is null) and (a.tehsil_taluka=ptaluka or ptaluka is null) and 
            (a.branch_code=pbranchcode or pbranchcode is null))x
            order by x.comp_code,x.unit_code,x.billagcd,x.billdpcd; 

    agency_rec agency_cur%rowtype;
    
        cursor cur_supply is 
        select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,u.comm_fix_auto_spl comm_fix_auto_spl,
        u.comm_code comm_code,u.sup_rate sup_rate,u.supdate supdate,u.surch_cd surch_cd,sum(u.sup_copy) sup_copy from 
        (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,d.edtn edtn,d.comm_fix_auto_spl comm_fix_auto_spl,
        d.comm_code comm_code,d.sup_rate sup_rate,d.supdate supdate,d.surch_cd surch_cd,d.billagcd agcd,d.billdpcd dpcd,d.sup_copy sup_copy 
                   from cir_dbksup d,cir_supply_type_mast s,cir_publ_mast p
                    where d.comp_code = pcomp_code and d.comp_code = s.comp_code and d.comp_code = p.comp_code and
                        d.unit_code = punit_code and d.sup_type_code=s.sup_ty_code and nvl(s.bill_pay,'N') = 'Y' and 
                        d.publ =p.publ /* and p.period    = ppubl_freq*/ and
                        d.supdate >= v_frdt and d.supdate <=v_todt and nvl(d.sup_copy,0)>0
            union all
             select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,d.edtn edtn,d.comm_fix_auto_spl comm_fix_auto_spl,
                    d.comm_code comm_code,d.sup_rate sup_rate,d.supdate supdate,d.surch_cd surch_cd,d.billagcd agcd,d.billdpcd dpcd,d.sup_copy sup_copy 
                   from cir_dbksup_resale d,cir_supply_type_mast s,cir_publ_mast p
                    where d.comp_code = pcomp_code and d.comp_code = s.comp_code and d.comp_code = p.comp_code and
                        d.unit_code = punit_code and d.sup_type_code=s.sup_ty_code and nvl(s.bill_pay,'N') = 'Y' and 
                        d.publ =p.publ /* and p.period    = ppubl_freq*/ and
                        d.supdate >= v_frdt and d.supdate <=v_todt and nvl(d.sup_copy,0)>0) u 
        where u.comp_code = agency_rec.comp_code and u.unit_code = agency_rec.unit and 
                u.agcd=agency_rec.bill_agcd and u.dpcd=agency_rec.bill_dpcd/*u.agcd||u.dpcd in (select agcd||dpcd from cir_agmast 
                        where comp_code = agency_rec.comp_code and unit = agency_rec.unit and
                              bill_agcd = agency_rec.bill_agcd and
                              bill_dpcd = agency_rec.bill_dpcd)*/
       group by u.comp_code,u.unit_code,u.publ,u.edtn,u.comm_fix_auto_spl,u.comm_code,u.sup_rate,u.supdate,u.surch_cd;
       rec_supply cur_supply%rowtype;

       avg_sup number;
       
       cursor comm_auto is select * from cir_comm_mast
            where comp_code = pcomp_code and
                  unit_code = punit_code and
                  publ = rec_supply.publ and
                  edtn = rec_supply.edtn and
                  comm_type = rec_supply.comm_fix_auto_spl and
                  comm_catg_code = rec_supply.comm_code and  
                  valid_from = (select max(valid_from) from cir_comm_mast
                                     where comp_code = pcomp_code and
                                           unit_code = punit_code and
                                           publ = rec_supply.publ and
                                           edtn = rec_supply.edtn and
                                           comm_type = rec_supply.comm_fix_auto_spl and
                                           comm_catg_code = rec_supply.comm_code and  
                                           valid_from <= v_billdt and
                                           avg_sup between nvl(sup_copy_from,0) and nvl(sup_copy_to,0)) and
                  avg_sup between nvl(sup_copy_from,0) and nvl(sup_copy_to,0);
        rec_comm_auto comm_auto%rowtype;          
       
       cursor comm_fix_spl is select * from cir_comm_mast
                                where comp_code = pcomp_code and
                                      unit_code = punit_code and
                                      publ = rec_supply.publ and
                                      edtn = rec_supply.edtn and
                                      comm_type = rec_supply.comm_fix_auto_spl and
                                      comm_catg_code = rec_supply.comm_code and  
                                      valid_from = (select max(valid_from) from cir_comm_mast
                                                         where comp_code = pcomp_code and
                                                               unit_code = punit_code and
                                                               publ = rec_supply.publ and
                                                               edtn = rec_supply.edtn and
                                                               comm_type = rec_supply.comm_fix_auto_spl and
                                                               comm_catg_code = rec_supply.comm_code and  
                                                               valid_from <= rec_supply.supdate);
        rec_comm_fix_spl comm_fix_spl%rowtype;          
                  
       cursor cur_surcharge is select * from cir_surcharge_mast 
                where comp_code  = pcomp_code and 
                      unit       = punit_code and
                      publ       = rec_supply.publ and
                      edtn       = rec_supply.edtn and
                      surch_cd   = rec_supply.surch_cd and 
                      valid_from = (select max(valid_from) from cir_surcharge_mast 
                                                where comp_code  = pcomp_code and 
                                                      unit       = punit_code and
                                                      publ       = rec_supply.publ and
                                                      edtn       = rec_supply.edtn and
                                                      surch_cd   = rec_supply.surch_cd and
                                                      valid_from<= rec_supply.supdate);
       rec_surcharge cur_surcharge%rowtype;
       
       v_bran_code cir_agmast.branch_code%type;
       v_rec_amt number:=0;
       v_rcp_count number:=0;

    Begin
        v_frdt         :=to_date(pfrdt,''''||pdateformat||'''');
        v_todt         :=to_date(ptodt,''''||pdateformat||'''');
        v_billdt     :=v_todt;
    Begin

        open agency_cur; 
        loop 
            fetch agency_cur into agency_rec;
            exit when agency_cur%notfound;
            
            curr_bilagcd := agency_rec.bill_agcd ||agency_rec.bill_dpcd;
            curr_record  := agency_rec.bill_agcd ||agency_rec.bill_dpcd/*||agency_rec.publ*/;
       ---------------------------------------------- add new code ------------------------------------------------------
            if curr_record <> prev_record then
                daily_gross_amount  := 0;
                tot_copy            := 0;
                tot_surcharge_amt   := 0;
                vsrch_amt           :=0;
                vcomm_amt           :=0;
            end if;

            open cur_supply;
            loop 
                fetch cur_supply into rec_supply;
                exit when cur_supply%notfound;
                tot_copy := nvl(tot_copy,0) + nvl(rec_supply.sup_copy,0) ;
                daily_gross_amount := nvl(daily_gross_amount,0)  + nvl(rec_supply.sup_copy,0) * nvl(rec_supply.sup_rate,0);
                v_daily_gross_amt:=nvl(rec_supply.sup_copy,0) * nvl(rec_supply.sup_rate,0);
                if rec_supply.comm_fix_auto_spl!='A' then
                    open comm_fix_spl;
                    fetch comm_fix_spl into rec_comm_fix_spl;
                    
                    if to_char(rec_supply.supdate,'DY') = 'SUN' then          ---for sunday commition rate
                        vcomm_per:= rec_comm_fix_spl.sun_comm_rate;
                    elsif to_char(rec_supply.supdate,'DY') = 'MON' then      ---for monday commition rate
                        vcomm_per:= rec_comm_fix_spl.mon_comm_rate;
                    elsif to_char(rec_supply.supdate,'DY') = 'TUE' then      ---for tueday commition rate
                        vcomm_per:= rec_comm_fix_spl.tue_comm_rate;
                    elsif to_char(rec_supply.supdate,'DY') = 'WED' then      ---for wednesday commition rate
                        vcomm_per:= rec_comm_fix_spl.wed_comm_rate;
                    elsif to_char(rec_supply.supdate,'DY') = 'THU' then      ---for Thursday commition rate
                        vcomm_per:= rec_comm_fix_spl.thu_comm_rate;
                    elsif to_char(rec_supply.supdate,'DY') = 'FRI' then      ---for friday commition rate
                        vcomm_per:= rec_comm_fix_spl.fri_comm_rate;
                    elsif to_char(rec_supply.supdate,'DY') = 'SAT' then      ---for saturday commition rate
                        vcomm_per:= rec_comm_fix_spl.sat_comm_rate;
                    else
                        vcomm_per:=    0;
                    end if;
                    rec_comm_fix_spl.sun_comm_rate:=0; rec_comm_fix_spl.mon_comm_rate:=0; rec_comm_fix_spl.tue_comm_rate:=0;
                    rec_comm_fix_spl.wed_comm_rate:=0;rec_comm_fix_spl.thu_comm_rate:=0; rec_comm_fix_spl.fri_comm_rate:=0;
                    rec_comm_fix_spl.sat_comm_rate:=0;                                     
                    if nvl(rec_comm_fix_spl.comm_catg_type,'N')='P' then
                        vcomm_amt:=nvl(vcomm_amt,0) + (nvl(rec_supply.sup_copy,0) * nvl(rec_supply.sup_rate,0))*nvl(vcomm_per,0)/100;
                        v_daily_comm_amt:=(nvl(rec_supply.sup_copy,0) * nvl(rec_supply.sup_rate,0))*nvl(vcomm_per,0)/100;
                    elsif nvl(rec_comm_fix_spl.comm_catg_type,'N')='C' then
                        vcomm_amt:= nvl(vcomm_amt,0) + nvl(rec_supply.sup_copy,0)*nvl(vcomm_per,0);
                        v_daily_comm_amt:=nvl(rec_supply.sup_copy,0)*nvl(vcomm_per,0);
                    else
                        vcomm_amt:=0;
                        v_daily_comm_amt:=0;
                    end if;
                    close comm_fix_spl;   
                end if; 
                            
                open cur_surcharge;
                fetch cur_surcharge into rec_surcharge;
                    if to_char(rec_supply.supdate,'DY') = 'SUN' then          ---for sunday commition rate
                        vsrch_amt:= rec_surcharge.sun_rate;
                    elsif to_char(rec_supply.supdate,'DY') = 'MON' then      ---for monday commition rate
                        vsrch_amt:= rec_surcharge.mon_rate;
                    elsif to_char(rec_supply.supdate,'DY') = 'TUE' then      ---for tueday surcharge rate
                        vsrch_amt:= rec_surcharge.tue_rate;
                    elsif to_char(rec_supply.supdate,'DY') = 'WED' then      ---for wednesday surcharge rate
                        vsrch_amt:= rec_surcharge.wed_rate;
                    elsif to_char(rec_supply.supdate,'DY') = 'THU' then      ---for Thursday surcharge rate
                        vsrch_amt:= rec_surcharge.thu_rate;
                    elsif to_char(rec_supply.supdate,'DY') = 'FRI' then      ---for friday surcharge rate
                        vsrch_amt:= rec_surcharge.fri_rate;
                    elsif to_char(rec_supply.supdate,'DY') = 'SAT' then      ---for saturday surcharge rate
                        vsrch_amt:= rec_surcharge.sat_rate;
                    else
                        vsrch_amt:=    0;
                    end if;
                close cur_surcharge;    
                
                tot_surcharge_amt   :=  nvl(tot_surcharge_amt,0) + nvl(rec_supply.sup_copy,0) * nvl(vsrch_amt,0);
                v_daily_sur_amt     :=  nvl(rec_supply.sup_copy,0) * nvl(vsrch_amt,0);
                v_daily_bill_amt    :=  nvl(v_daily_gross_amt,0)+nvl(v_daily_sur_amt,0)-nvl(v_daily_comm_amt,0);
                
                If pextra1 is null then
                    select sum(nvl(apr_late_recpt,0)+nvl(apr_short_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0)),sum(nvl(copy_amt,0)-nvl(waste_amt,0)) return_amt into v_return_copy,v_return_amt
                        from cir_unsold_dtl
                        where comp_code=rec_supply.comp_code and unit_code=rec_supply.unit_code and doctype='UCN' and
                            app_dt=rec_supply.supdate and publ=rec_supply.publ and edtn=rec_supply.edtn and agcd=agency_rec.bill_agcd and
                            dpcd=agency_rec.bill_dpcd and copy_rate=rec_supply.sup_rate and
                             (nvl(apr_late_recpt,0)+nvl(apr_short_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0;
                                
                    select abs(sum(amount)) into v_rec_amt from cir_rcphdr 
                        where comp_code=agency_rec.comp_code and unit_code=agency_rec.unit and
                            agcd=agency_rec.bill_agcd and dpcd=agency_rec.bill_dpcd and recptdt = rec_supply.supdate and
                            doctype='RCR' and achd='NM';
                            
                    select count(*) into v_rcp_count from cir_bill_return_print
                        where cur_sessionid=userenv('sessionid') and comp_code=rec_supply.comp_code and unit_code=rec_supply.unit_code and 
                            receipt_date=rec_supply.supdate and agcd=agency_rec.bill_agcd and dpcd=agency_rec.bill_dpcd;
                    if nvl(v_rcp_count,0)>0 then
                        v_rec_amt:=0; 
                    else
                        insert into cir_bill_return_print(comp_code,unit_code,agcd,dpcd,receipt_date,sur_amt)
                        values(rec_supply.comp_code,rec_supply.unit_code,agency_rec.bill_agcd,agency_rec.bill_dpcd,rec_supply.supdate,v_rec_amt);
                    end if;
                End if;
        
                insert into cir_bill_print(comp_code,unit_code,billno,billdt,publ_code,edtn_code,agcd,dpcd,
                                   supply_date,supply_copy,supply_rate,gross_amt,comm_rate,comm_amt,sur_rate,sur_amt,
                                   return_copy,return_amt,cur_sessionid,rec_amt)
                                        values(rec_supply.comp_code,rec_supply.unit_code,null,v_billdt,rec_supply.publ,rec_supply.edtn,agency_rec.bill_agcd,agency_rec.bill_dpcd,
                             rec_supply.supdate,rec_supply.sup_copy,rec_supply.sup_rate,nvl(v_daily_gross_amt,0),nvl(vcomm_per,0),nvl(v_daily_comm_amt,0),nvl(vsrch_amt,0),nvl(v_daily_sur_amt,0),
                             v_return_copy,v_return_amt,userenv('sessionid'),v_rec_amt);
                v_rec_amt:=0;v_rcp_count:=0;
            end loop; 
            avg_sup:=nvl(tot_copy,0);

            if rec_supply.comm_fix_auto_spl = 'A' then
                 --cal_avg_copy(agency_rec.bilagcd,agency_rec.bildpcd,agency_rec.publ);
                if tot_copy > 0 then 
                    open comm_auto;
                    fetch comm_auto into rec_comm_auto;
                    vcomm_per :=  rec_comm_auto.sun_comm_rate;
                    if nvl(rec_comm_auto.comm_catg_type,'N')='P' then
                          vcomm_amt:=nvl(daily_gross_amount,0)*nvl(vcomm_per,0)/100;
                    elsif nvl(rec_comm_auto.comm_catg_type,'N')='C' then
                          vcomm_amt:=nvl(tot_copy,0)*nvl(vcomm_per,0);
                    else
                          vcomm_amt:=0;
                    end if;      
                    close comm_auto;
                end if;
            end if;
           
           close cur_supply;
           daily_net_amount := nvl(daily_gross_amount,0) + nvl(tot_surcharge_amt,0) - nvl(vcomm_amt,0);
           vbill_no         :=nvl(vbill_no,0)+1;
           --vbill_no:=cir_generate_billno(agency_rec.comp_code,agency_rec.unit,v_billdt,pdateformat,'','');

           if nvl(tot_copy,0) > 0 then
             Begin
                 select abs(sum(amount)) into v_sec_limit from cir_rcphdr 
                      where comp_code=  agency_rec.comp_code and
                            unit_code=  agency_rec.unit and
                            agcd     =  agency_rec.bill_agcd and
                            dpcd     =  agency_rec.bill_dpcd and
                            recptdt  <= v_todt and
                            achd     =  'SC';
                      exception when others then
                            v_sec_limit:=0;
             End;

            select distinct security_per,sec_amt_limt,branch_code into v_agcd_sec_per,v_agcd_sec_amt_limt,v_bran_code from cir_agmast 
              where comp_code = pcomp_code and unit = punit_code and agcd=agency_rec.bill_agcd and 
                    dpcd=agency_rec.bill_dpcd;
             
             if nvl(v_agcd_sec_per,0)>0 then
                 if nvl(v_agcd_sec_amt_limt,0)>nvl(v_sec_limit,0) then
                    v_bill_dbn_amt:=nvl(v_agcd_sec_per,0)*nvl(daily_net_amount,0)/100;
                 end if;
                 if nvl(v_agcd_sec_amt_limt,0)-nvl(v_sec_limit,0)<nvl(v_bill_dbn_amt,0) then
                    v_bill_sec_amt:=nvl(v_agcd_sec_amt_limt,0)-nvl(v_sec_limit,0);
                 else
                    v_bill_sec_amt:=nvl(v_bill_dbn_amt,0);
                 end if;
                if nvl(v_bill_sec_amt,0)<0 then
                    v_bill_sec_amt:=0;
                end if;
             end if;
            
            update cir_bill_print set billno=vbill_no,sec_amt=v_bill_sec_amt
            where comp_code=agency_rec.comp_code and unit_code=agency_rec.unit and 
            billdt=v_billdt and agcd=agency_rec.bill_agcd and dpcd=agency_rec.bill_dpcd and cur_sessionid=userenv('sessionid') and rownum<2;

            /*update cir_bill_print set sec_amt=v_bill_sec_amt
            where comp_code=agency_rec.comp_code and unit_code=agency_rec.unit and 
            billdt=v_billdt and agcd=agency_rec.bill_agcd and dpcd=agency_rec.bill_dpcd and cur_sessionid=userenv('sessionid') and rownum<2;*/
           
            v_sec_limit      :=0; v_bill_dbn_amt:=0; v_bill_sec_amt   :=0;
            v_remark         :='';v_reptno      :='';v_rec_no         :=0; 
            v_daily_comm_amt :=0; v_daily_sur_amt:=0;v_daily_gross_amt:=0;
            v_daily_bill_amt :=0;
           end if;
       end loop;
    close agency_cur;
    commit;
    End;  
  
  End cir_before_bill_process_p;
  
  procedure cir_weekly_bill_summary_p(
    pcomp_code      in varchar2,
    punit_code      in varchar2,
    repty           in varchar2,
    pbill_freq      in varchar2,
    pfrom_billdt    in varchar2,
    ptill_billdt    in varchar2,
    ppubl           in varchar2,
    pbillagcd       in varchar2,
    pbilldpcd       in varchar2,
    pdateformat     in varchar2,
    pbrancode       in varchar2,
    pdistcode       in varchar2,
    pagclass        in varchar2,
    pextra1         in varchar2,--for executive code
    pextra2         in varchar2,
    p_accounts      out t_accounts,
    p_accounts1     out t_accounts)
    As
      v_bill_frdt   date;
      v_bill_todt   date;
      v_start_date  date;
      v_dt          date;
      v_query1      varchar2(8000);
      v_query2      varchar2(8000);
      v_statecode   varchar2(20);
      v_distcode    varchar2(20);
      v_citycode    varchar2(20);
      v_taluka      varchar2(20);

    cursor cur_not_supply is
            select u.comp_code comp_code,u.unit_code unit_code,u.agcd agcd,u.dpcd dpcd,u.publ publ,u.edtn edtn,
            u.supply_date supply_date,u.copy_rate copy_rate from
            (select d.comp_code,d.unit_code,d.agcd,d.dpcd,d.publ,d.edtn,d.recptdt supply_date,d.copy_rate 
            from cir_agmast m,cir_unsold_dtl d
            where d.comp_code=m.comp_code and d.comp_code=pcomp_code and d.unit_code=m.unit and d.unit_code=punit_code and 
                d.doctype='UCN' and d.agcd=m.agcd  and d.dpcd=m.dpcd and d.app_dt >= v_start_date  and d.agcd=nvl(pbillagcd,d.agcd) and d.dpcd=nvl(pbilldpcd,d.dpcd) and 
                d.app_dt<=v_bill_todt and  (m.ag_class=pagclass or pagclass is null) and (m.dist_code=v_distcode or v_distcode is null) and 
                (m.tehsil_taluka=v_taluka or v_taluka is null) and d.supply_copy>0 and (m.branch_code=pbrancode or pbrancode is null) and
                (m.executive_code = pextra1 or pextra1 is null) and 
                (nvl(d.apr_late_recpt,0)+nvl(d.apr_short_recpt,0)+nvl(d.apr_bnr,0)+nvl(d.apr_unsold,0))>0
             minus
            select comp_code,unit_code,agcd,dpcd,publ_code publ,edtn_code edtn,supply_date,supply_rate copy_rate from cir_bill_print
            where comp_code=pcomp_code and unit_code=punit_code and supply_date>= v_start_date  and supply_date<=v_bill_todt and 
            agcd=nvl(pbillagcd,agcd) and dpcd=nvl(pbilldpcd,dpcd) and supply_copy>0 and cur_sessionid=userenv('sessionid')) u;
    rec_not_supply  cur_not_supply%rowtype;
    
    cursor cur_bill is
        select distinct x.comp_code comp_code,x.unit_code unit_code,x.agcd agcd,x.dpcd dpcd,b.ag_name ag_name,b.ag_name_oth_lang ag_name_oth_lang,
        b.city_code city_code,b.country_code country_code,b.state_code state_code,b.dist_code dist_code,b.tehsil_taluka taluka_code,
        sum(x.supply_copy) supply_copy,sum(x.gross_amount) gross_amount,sum(x.sur_amount) sur_amount,sum(x.comm_amount) comm_amount,
        sum(x.bill_sec_amt) bill_sec_amt from
        (select distinct a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,
        sum(a.supply_copy) supply_copy,sum(a.gross_amt) gross_amount,sum(a.sur_amt) sur_amount,sum(a.comm_amt) comm_amount,
        sum(a.sec_amt) bill_sec_amt
        from cir_bill_print a
            where a.comp_code=pcomp_code and a.unit_code=nvl(punit_code,a.unit_code) and
                  a.supply_date >= v_bill_frdt and a.supply_date<=v_bill_todt and 
                  a.agcd=nvl(pbillagcd,a.agcd) and a.dpcd=nvl(pbilldpcd,a.dpcd) and
                  a.publ_code=nvl(ppubl,a.publ_code) and a.cur_sessionid=userenv('sessionid')
                  group by a.comp_code,a.unit_code,a.agcd,a.dpcd
        union
        select distinct a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,
        0 supply_copy,0 gross_amount,0 sur_amount,0 comm_amount,0 bill_sec_amt
        from cir_bill_print a
            where a.comp_code=pcomp_code and a.unit_code=nvl(punit_code,a.unit_code) and
                  a.supply_date >= v_start_date and a.supply_date<v_bill_frdt and 
                  a.agcd=nvl(pbillagcd,a.agcd) and a.dpcd=nvl(pbilldpcd,a.dpcd) and
                  a.cur_sessionid=userenv('sessionid') and a.publ_code=nvl(ppubl,a.publ_code)) x,cir_agmast b
                  where x.comp_code=b.comp_code and x.unit_code=b.unit and x.agcd=b.agcd and x.dpcd=b.dpcd
                  group by x.comp_code,x.unit_code,x.agcd,x.dpcd,b.ag_name,b.ag_name_oth_lang,
                  b.city_code,b.country_code,b.state_code,b.dist_code,b.tehsil_taluka
                  order by x.comp_code,x.unit_code,x.agcd,x.dpcd;
        v1 cur_bill%rowtype;
      
      cursor cur_type is
        select doctyp,sum(amount) amount from cir_outmast
            where comp_code=v1.comp_code and unit_code=v1.unit_code and
                achd='NM' and doctyp not in('BIL','UCN') and recptdt>=v_bill_frdt and recptdt<=v_bill_todt and 
                agcd=v1.agcd and dpcd=v1.dpcd
            group by doctyp;
        v2 cur_type%rowtype;
        v_dsign           number(2);
        v_comp_code       varchar2(8);
        v_unit_code       varchar2(8);
        v_publ_code       varchar2(8);
        v_agcode          varchar2(20);
        v_depo_code       varchar2(20);
        v_agname          varchar2(200);
        v_agname_oth_lang varchar2(250);
        v_city_name       varchar2(100);
        --v_billno          varchar2(20);
        --v_bildt           date;
        
        v_return_copy     number(10);
        v_return_amt      number(10,2);
        vbill_no          varchar2(20);
        --v_rec_amt         number:=0;
        v_rcp_count       number:=0;
        v_prev_agcd       varchar2(30):='XX';  
        v_cur_agcd        varchar2(30):='XX'; 

       v_ret_gross       number(15,2):=0;
        v_ret_comm        number(15,2):=0;
        v_ret_copy        number(15):=0;
        v_dn_amt          number(15,2):=0;
        v_cn_amt          number(15,2):=0;
        v_rec_amt         number(15,2):=0;
        v_prev_bal        number(15,2):=0;
        v_sec_bal         number(15,2):=0;
        v_psecamt         number(15,2):=0;
        v_csecamt         number(15,2):=0;  
        v_opdate          date;
        v_bill_exist      number(5);

        v_pbillret        number(15,2):=0;
        v_state_name        varchar2(200);
        v_dist_name         varchar2(200);
        v_taluka_name       varchar2(200);

    Begin
    v_bill_frdt     :=to_date(pfrom_billdt,''''||pdateformat||'''');
    v_bill_todt     :=to_date(ptill_billdt,''''||pdateformat||'''');
    v_opdate        :=cir_get_finandt(pcomp_code,to_date(pfrom_billdt,''''||pdateformat||''''),pdateformat,'','');
    v_start_date    :=trunc(v_bill_frdt,'mm');
    
    if repty='S' then
        v_statecode:=pdistcode;
    elsif repty='D' then
        v_distcode:=pdistcode;
    elsif repty='C' then
        v_citycode:=pdistcode;
    else
        v_taluka:=pdistcode;
    end if;
    --delete test1;commit;insert into test1(vstring,vstring2) values(' cir_before_bill_print_p1 ', pbillagcd||pbilldpcd);commit;
    delete from cir_temp_outstanding;
    delete from cir_bill_print where cur_sessionid=userenv('sessionid');
    delete from cir_bill_return_print where cur_sessionid=userenv('sessionid');

    
    select count(*) into v_bill_exist from cir_bill_det b,cir_publ_mast p 
        where b.comp_code=pcomp_code and b.comp_code = p.comp_code and b.unit_code=punit_code and 
            b.billdt >= v_bill_frdt and b.billdt<=v_bill_todt and b.publ =p.publ and 
            (b.agcd=nvl(pbillagcd,b.agcd) or pbillagcd='') and (b.dpcd=nvl(pbilldpcd,b.dpcd) or pbilldpcd='');
    
    if v_bill_frdt=v_start_date then
        cir_before_bill_process_p(pcomp_code,punit_code,'',ppubl,pfrom_billdt,ptill_billdt,pbillagcd,pbilldpcd,'',pagclass ,pbrancode, v_distcode , v_taluka,pdateformat,'','','');
    else
        --cir_before_bill_process_p(pcomp_code,punit_code,'',ppubl,to_char(v_start_date,''''||pdateformat||''''),to_char(v_bill_frdt-1,''''||pdateformat||''''),pbillagcd,pbilldpcd,'',pagclass ,pbrancode, v_distcode , v_taluka,pdateformat,'','','');
        --cir_before_bill_process_p(pcomp_code,punit_code,'',ppubl,pfrom_billdt,ptill_billdt,pbillagcd,pbilldpcd,'',pagclass ,pbrancode, v_distcode , v_taluka,pdateformat,'','','');
        cir_before_bill_process_p(pcomp_code,punit_code,'',ppubl,to_char(v_start_date,''''||pdateformat||''''),ptill_billdt,pbillagcd,pbilldpcd,'',pagclass ,pbrancode, v_distcode , v_taluka,pdateformat,'','','');
    end if;    
    --delete from test1;commit;
    --insert into test1(vstring,vstring2) values('cir_billing_outstanding ','pfrom_billdt '||pfrom_billdt||' ptill_billdt '||ptill_billdt||' repty '||repty||' pextra1 '||pextra1);commit; 
        delete from cir_temp_bill_collection where cur_sessionid=userenv('sessionid');

    open cur_not_supply;
    loop
        fetch cur_not_supply into rec_not_supply;
        exit when cur_not_supply%notfound;

        v_cur_agcd  :=rec_not_supply.agcd||rec_not_supply.dpcd;
        
        if v_prev_agcd<>v_cur_agcd then--XX & A0002
            v_prev_agcd :=v_cur_agcd;
        
        select max(to_number(billno)) into vbill_no from cir_bill_print 
            where comp_code=pcomp_code and unit_code=punit_code and supply_date>= v_start_date and supply_date<=v_bill_todt and 
                agcd=nvl(pbillagcd,agcd) and dpcd=nvl(pbilldpcd,dpcd) and cur_sessionid=userenv('sessionid');            
        if to_number(vbill_no)=0 then
            select max(to_number(billno)) into vbill_no from cir_bill_print 
                where comp_code=pcomp_code and unit_code=punit_code and 
                supply_date>= v_start_date and supply_date<=v_bill_todt and 
                    cur_sessionid=userenv('sessionid');
        end if;
            
        end if;
        
        select sum(nvl(apr_late_recpt,0)+nvl(apr_short_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0)),sum(nvl(copy_amt,0)-nvl(waste_amt,0)) return_amt into v_return_copy,v_return_amt
            from cir_unsold_dtl
            where comp_code=rec_not_supply.comp_code and unit_code=rec_not_supply.unit_code and doctype='UCN' and
                agcd=rec_not_supply.agcd and dpcd=rec_not_supply.dpcd and app_dt=rec_not_supply.supply_date and 
                publ=rec_not_supply.publ and edtn=rec_not_supply.edtn and copy_rate=rec_not_supply.copy_rate and
                (nvl(apr_late_recpt,0)+nvl(apr_short_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))>0;
                            
        select abs(sum(amount)) into v_rec_amt from cir_rcphdr 
            where comp_code=rec_not_supply.comp_code and unit_code=rec_not_supply.unit_code and
                doctype='RCR' and recptdt = rec_not_supply.supply_date and
                agcd=rec_not_supply.agcd and dpcd=rec_not_supply.dpcd and achd='NM';
                        
        select count(*) into v_rcp_count from cir_bill_return_print
            where cur_sessionid=userenv('sessionid') and comp_code=rec_not_supply.comp_code and unit_code=rec_not_supply.unit_code and 
                receipt_date=rec_not_supply.supply_date and agcd=rec_not_supply.agcd and dpcd=rec_not_supply.dpcd;
        if nvl(v_rcp_count,0)>0 then
            v_rec_amt:=0; 
        else
            insert into cir_bill_return_print(comp_code,unit_code,agcd,dpcd,receipt_date,sur_amt)
            values(rec_not_supply.comp_code,rec_not_supply.unit_code,rec_not_supply.agcd,rec_not_supply.dpcd,rec_not_supply.supply_date,v_rec_amt);
        end if;           
                        
        insert into cir_bill_print(comp_code,unit_code,billno,billdt,publ_code,edtn_code,agcd,dpcd,
                                supply_date,supply_copy,supply_rate,gross_amt,comm_rate,comm_amt,sur_rate,sur_amt,
                                return_copy,return_amt,cur_sessionid,rec_amt)
                  values(rec_not_supply.comp_code,rec_not_supply.unit_code,vbill_no,v_bill_todt,rec_not_supply.publ,rec_not_supply.edtn,rec_not_supply.agcd,rec_not_supply.dpcd,
                                rec_not_supply.supply_date,0,rec_not_supply.copy_rate,0,0,0,0,0,
                                v_return_copy,v_return_amt,userenv('sessionid'),v_rec_amt);
                             
    v_return_copy:=0;v_return_amt:=0;v_rcp_count:=0;v_rec_amt:=0;
    end loop;
    close cur_not_supply;
    
        Open cur_bill;---main cursor bill
        Loop
            fetch cur_bill into v1;
            exit when cur_bill%notfound;

            select sum(u.tot_return),sum(u.gross_amt),sum(u.comm_amt) into v_ret_copy,v_ret_gross,v_ret_comm from
            (select sum(nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0)) tot_return,
            nvl(sum(copy_amt),0) gross_amt,
            sum((nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))*nvl(copy_rate,0))-nvl(sum(copy_amt),0) comm_amt  
            from cir_unsold_dtl 
            where comp_code=v1.comp_code and unit_code=v1.unit_code and 
                doctype='UCN' and agcd=v1.agcd and dpcd=v1.dpcd and app_dt >= v_bill_frdt and app_dt<=v_bill_todt and process_crno is null/*and publ=v1.publ*/
            union
            select sum(nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0)) tot_return,
            nvl(sum(copy_amt),0) gross_amt,
            sum((nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0))*nvl(copy_rate,0))-nvl(sum(copy_amt),0) comm_amt 
            from cir_unsold_dtl 
            where comp_code=v1.comp_code and unit_code=v1.unit_code and 
                doctype='UCN' and agcd=v1.agcd and dpcd=v1.dpcd and app_dt >= v_bill_frdt and app_dt<=v_bill_todt and 
                process_crno is not null /*and publ=v1.publ*/) u;
                
            v_prev_bal  :=cir_accounts.cir_agency_opbal(v1.comp_code,v1.unit_code,'',v1.agcd,v1.dpcd,v_opdate,'NM',pdateformat,pextra1,pextra2);
            v_sec_bal   :=cir_accounts.cir_agency_opbal(v1.comp_code,v1.unit_code,'',v1.agcd,v1.dpcd,v_opdate,'SC',pdateformat,pextra1,pextra2);

            select sum(amount) into v_rec_amt from
            (select sum(amount) amount  from cir_outmast
            where comp_code=v1.comp_code and unit_code=v1.unit_code and
            achd='NM' and doctyp='BIL' and billdt>=v_opdate and billdt<v_bill_frdt and agcd=v1.agcd and dpcd=v1.dpcd
            union all
            select sum(amount) amount from cir_outmast
            where comp_code=v1.comp_code and unit_code=v1.unit_code and
            achd='NM' and doctyp <>'BIL' and recptdt>=v_opdate and recptdt<v_start_date and agcd=v1.agcd and dpcd=v1.dpcd
            union all
            select sum(amount) amount from cir_outmast
            where comp_code=v1.comp_code and unit_code=v1.unit_code and
            achd='NM' and doctyp<>'UCN' and recptdt>=v_start_date and recptdt<v_bill_frdt and agcd=v1.agcd and dpcd=v1.dpcd);
            
            v_prev_bal  :=nvl(v_prev_bal,0)+nvl(v_rec_amt,0);
            
            v_rec_amt:=0;
            
            select sum(amount) into v_rec_amt from cir_rcphdr where comp_code=v1.comp_code and unit_code=v1.unit_code and
             agcd=v1.agcd and dpcd=v1.dpcd and recptdt>=v_opdate and recptdt<=v_bill_todt and achd='SC' ;
            
            v_sec_bal   :=nvl(v_sec_bal,0)+nvl(v_rec_amt,0);

            select sum(nvl(gross_amt,0)-nvl(comm_amt,0)+nvl(sur_amt,0)-nvl(return_amt,0)),abs(sum(sec_amt)) into v_pbillret,v_psecamt 
            from cir_bill_print
                where comp_code=v1.comp_code and unit_code=v1.unit_code and supply_date>=v_start_date and supply_date<v_bill_frdt and  
                agcd=v1.agcd and dpcd=v1.dpcd and cur_sessionid=userenv('sessionid');
                            
            select abs(sum(sec_amt)) into v_csecamt from cir_bill_print
                where comp_code=v1.comp_code and unit_code=v1.unit_code and supply_date >= v_bill_frdt and supply_date<=v_bill_todt and 
                agcd=v1.agcd and dpcd=v1.dpcd and cur_sessionid=userenv('sessionid');
                
            if nvl(v_bill_exist,0)=0 then
                v_sec_bal   :=nvl(v_sec_bal,0)-nvl(v_psecamt,0)-nvl(v_csecamt,0);
            else
                v_sec_bal   :=nvl(v_sec_bal,0)+nvl(v_psecamt,0);
            end if;
            
            v_prev_bal      :=nvl(v_prev_bal,0)+nvl(v_pbillret,0)+nvl(v_psecamt,0);
                        
            v_rec_amt:=0;v_pbillret:=0;v_csecamt:=0;v_psecamt:=0;
            
            open cur_type;
            loop
                fetch cur_type into v2;
                exit when cur_type%notfound;
                begin
                    select dsign into v_dsign from cir_docmst where comp_code=v1.comp_code and doc_type=v2.doctyp;
                exception when others then
                    v_dsign:=1;
                end;
                if v_dsign>0 then
                    if v_bill_exist=0 then
                        v_dn_amt:=nvl(v_dn_amt,0)+nvl(v2.amount,0)+nvl(v_csecamt,0);
                    else
                        v_dn_amt:=nvl(v_dn_amt,0)+nvl(v2.amount,0);
                    end if;    
                else
                    if v2.doctyp='RCR' then   
                        v_rec_amt:=nvl(v_rec_amt,0)+nvl(v2.amount,0);
                    else
                        v_cn_amt:=nvl(v_cn_amt,0)+nvl(v2.amount,0);
                    end if;
                end if;
            end loop;
            close cur_type;

            v_state_name    :=cir_get_state(v1.comp_code,v1.country_code,v1.state_code);
            if repty='S' then
                null;
            else
                v_dist_name     :=cir_get_name.cir_district(v1.comp_code,v1.dist_code,'1','','','');
                if repty='D' then
                    null;           
                elsif repty='C' then
                    v_city_name     :=cir_get_city(v1.comp_code,v1.city_code);
                else
                    begin
                        v_taluka_name   :=cir_get_name.cir_taluka(v1.comp_code,v1.taluka_code,'1','','','');
                    exception when others then
                        v_taluka_name   :='N/A';
                    end;
                end if;
            end if;
            
            insert into cir_temp_bill_collection(comp_code,unit_code,billno,billdt,publ_code,agcd,dpcd, 
            supply_copy, gross_amt, comm_amt, sur_amt, return_copy, return_amt,ret_comm_amt, dn_amt, rec_amt, prev_bal,cn_amt,cur_sessionid,        
            agname, agname_oth_lang, city_code, taluka_code, dist_code, state_code, remarks,bill_sec_amt,sec_opbal)
               values(v1.comp_code,  v1.unit_code  , null   ,null  , ''    ,v1.agcd,v1.dpcd,
            v1.supply_copy,v1.gross_amount,nvl(v1.comm_amount,0),v1.sur_amount,v_ret_copy,v_ret_gross,v_ret_comm,
            v_dn_amt,v_rec_amt,v_prev_bal,v_cn_amt,userenv('sessionid'),
            v1.ag_name,v1.ag_name_oth_lang,v_city_name,v_taluka_name,v_dist_name,v_state_name,v1.country_code,v1.bill_sec_amt,v_sec_bal);
    
            v_dsign:=0;v_ret_gross:=0;v_ret_comm:=0; v_ret_copy:=0; v_dn_amt:=0; v_cn_amt:=0; v_rec_amt:=0; v_prev_bal:=0;v_sec_bal:=0;
            v_state_name    :=null;v_dist_name     :=null;v_taluka_name   :=null; v_city_name:=null; 
        End Loop;
        Close cur_bill;
        commit;
        
        if repty='S' then
            open p_accounts for
            select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname ag_name,a.agname_oth_lang ag_name_oth_lang,
            a.state_code state_name,
            sum(nvl(a.gross_amt,0)+nvl(a.sur_amt,0)) bill_amt,sum(a.comm_amt) comm_amt,sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))) net_bill,
            sum(nvl(a.return_amt,0)+nvl(ret_comm_amt,0)) return_amt,sum(nvl(a.return_amt,0)) net_return_amt,
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)) total_bill,abs(sum(nvl(a.bill_sec_amt,0))) dep_adj, 
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.bill_sec_amt,0)) total_net,
            sum(a.prev_bal) prev_bal, abs(sum(a.rec_amt)) rec_amt,sum(nvl(a.dn_amt,0)) dn_amt, sum(a.cn_amt) cn_amt,sum(nvl(a.dn_amt,0)+nvl(a.cn_amt,0)) dr_cr_amt,
            sum(((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.prev_bal,0)+nvl(a.rec_amt,0)+nvl(a.dn_amt,0)+nvl(a.cn_amt,0)+nvl(a.bill_sec_amt,0))) net_bal,
            abs(sum(nvl(a.sec_opbal,0))) deposit_balance
            from cir_temp_bill_collection a
            where cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.remarks,a.state_code
            order by comp_code,unit_code,state_name,ag_name;

            open p_accounts1 for
            select a.comp_code comp_code,a.unit_code unit_code,a.state_code state_name,
            sum(nvl(a.gross_amt,0)+nvl(a.sur_amt,0)) bill_amt,sum(a.comm_amt) comm_amt,sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))) net_bill,
            sum(nvl(a.return_amt,0)+nvl(ret_comm_amt,0)) return_amt,sum(nvl(a.return_amt,0)) net_return_amt,
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)) total_bill,abs(sum(nvl(a.bill_sec_amt,0))) dep_adj, 
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.bill_sec_amt,0)) total_net,
            sum(a.prev_bal) prev_bal, abs(sum(a.rec_amt)) rec_amt,sum(nvl(a.dn_amt,0)) dn_amt, sum(a.cn_amt) cn_amt,sum(nvl(a.dn_amt,0)+nvl(a.cn_amt,0)) dr_cr_amt,
            sum(((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.prev_bal,0)+nvl(a.rec_amt,0)+nvl(a.dn_amt,0)+nvl(a.cn_amt,0)+nvl(a.bill_sec_amt,0))) net_bal,
            abs(sum(nvl(a.sec_opbal,0))) deposit_balance
            from cir_temp_bill_collection a
            where cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.remarks,a.state_code
            order by comp_code,unit_code,state_name;            
        elsif repty='D' then
            open p_accounts for
            select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname ag_name,a.agname_oth_lang ag_name_oth_lang,
            a.state_code state_name,a.dist_code district_name,
            sum(nvl(a.gross_amt,0)+nvl(a.sur_amt,0)) bill_amt,sum(a.comm_amt) comm_amt,sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))) net_bill,
            sum(nvl(a.return_amt,0)+nvl(ret_comm_amt,0)) return_amt,sum(nvl(a.return_amt,0)) net_return_amt,
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)) total_bill,abs(sum(nvl(a.bill_sec_amt,0))) dep_adj, 
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.bill_sec_amt,0)) total_net,
            sum(a.prev_bal) prev_bal, abs(sum(a.rec_amt)) rec_amt,sum(nvl(a.dn_amt,0)) dn_amt, sum(a.cn_amt) cn_amt,sum(nvl(a.dn_amt,0)+nvl(a.cn_amt,0)) dr_cr_amt,
            sum(((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.prev_bal,0)+nvl(a.rec_amt,0)+nvl(a.dn_amt,0)+nvl(a.cn_amt,0)+nvl(a.bill_sec_amt,0))) net_bal,
            abs(sum(nvl(a.sec_opbal,0))) deposit_balance
            from cir_temp_bill_collection a
            where cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.remarks,a.state_code,a.dist_code
            order by comp_code,unit_code,district_name,ag_name;     

            open p_accounts1 for
            select a.comp_code comp_code,a.unit_code unit_code,a.dist_code district_name,a.state_code state_name,
            sum(nvl(a.gross_amt,0)+nvl(a.sur_amt,0)) bill_amt,sum(a.comm_amt) comm_amt,sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))) net_bill,
            sum(nvl(a.return_amt,0)+nvl(ret_comm_amt,0)) return_amt,sum(nvl(a.return_amt,0)) net_return_amt,
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)) total_bill,abs(sum(nvl(a.bill_sec_amt,0))) dep_adj, 
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.bill_sec_amt,0)) total_net,
            sum(a.prev_bal) prev_bal, abs(sum(a.rec_amt)) rec_amt,sum(nvl(a.dn_amt,0)) dn_amt, sum(a.cn_amt) cn_amt,sum(nvl(a.dn_amt,0)+nvl(a.cn_amt,0)) dr_cr_amt,
            sum(((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.prev_bal,0)+nvl(a.rec_amt,0)+nvl(a.dn_amt,0)+nvl(a.cn_amt,0)+nvl(a.bill_sec_amt,0))) net_bal,
            abs(sum(nvl(a.sec_opbal,0))) deposit_balance
            from cir_temp_bill_collection a
            where cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.remarks,a.state_code,a.dist_code
            order by comp_code,unit_code,state_name,district_name;
            
        elsif repty='C' then
            open p_accounts for
            select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname ag_name,a.agname_oth_lang ag_name_oth_lang,
            a.state_code state_name,a.dist_code district_name,a.city_code city_name,
            sum(nvl(a.gross_amt,0)+nvl(a.sur_amt,0)) bill_amt,sum(a.comm_amt) comm_amt,sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))) net_bill,
            sum(nvl(a.return_amt,0)+nvl(ret_comm_amt,0)) return_amt,sum(nvl(a.return_amt,0)) net_return_amt,
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)) total_bill,abs(sum(nvl(a.bill_sec_amt,0))) dep_adj, 
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.bill_sec_amt,0)) total_net,
            sum(a.prev_bal) prev_bal, abs(sum(a.rec_amt)) rec_amt,sum(nvl(a.dn_amt,0)) dn_amt, sum(a.cn_amt) cn_amt,sum(nvl(a.dn_amt,0)+nvl(a.cn_amt,0)) dr_cr_amt,
            sum(((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.prev_bal,0)+nvl(a.rec_amt,0)+nvl(a.dn_amt,0)+nvl(a.cn_amt,0)+nvl(a.bill_sec_amt,0))) net_bal,
            abs(sum(nvl(a.sec_opbal,0))) deposit_balance
            from cir_temp_bill_collection a
            where cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.remarks,a.state_code,a.dist_code,a.city_code
            order by comp_code,unit_code,city_name,ag_name;  
            
            open p_accounts1 for
            select a.comp_code comp_code,a.unit_code unit_code,a.city_code city_name,
            a.dist_code district_name,a.state_code state_name,
            sum(nvl(a.gross_amt,0)+nvl(a.sur_amt,0)) bill_amt,sum(a.comm_amt) comm_amt,sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))) net_bill,
            sum(nvl(a.return_amt,0)+nvl(ret_comm_amt,0)) return_amt,sum(nvl(a.return_amt,0)) net_return_amt,
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)) total_bill,abs(sum(nvl(a.bill_sec_amt,0))) dep_adj, 
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.bill_sec_amt,0)) total_net,
            sum(a.prev_bal) prev_bal, abs(sum(a.rec_amt)) rec_amt,sum(nvl(a.dn_amt,0)) dn_amt, sum(a.cn_amt) cn_amt,sum(nvl(a.dn_amt,0)+nvl(a.cn_amt,0)) dr_cr_amt,
            sum(((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.prev_bal,0)+nvl(a.rec_amt,0)+nvl(a.dn_amt,0)+nvl(a.cn_amt,0)+nvl(a.bill_sec_amt,0))) net_bal,
            abs(sum(nvl(a.sec_opbal,0))) deposit_balance
            from cir_temp_bill_collection a
            where cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.city_code,a.dist_code,a.remarks,a.state_code
            order by comp_code,unit_code,state_name,district_name,city_name;
        else
            open p_accounts for
            select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname ag_name,a.agname_oth_lang ag_name_oth_lang,
            a.state_code state_name,a.dist_code district_name,
            a.taluka_code||'('||a.dist_code||')' taluka_name,
            sum(nvl(a.gross_amt,0)+nvl(a.sur_amt,0)) bill_amt,sum(a.comm_amt) comm_amt,sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))) net_bill,
            sum(nvl(a.return_amt,0)+nvl(ret_comm_amt,0)) return_amt,sum(nvl(a.return_amt,0)) net_return_amt,
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)) total_bill,abs(sum(nvl(a.bill_sec_amt,0))) dep_adj, 
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.bill_sec_amt,0)) total_net,
            sum(a.prev_bal) prev_bal, abs(sum(a.rec_amt)) rec_amt,sum(nvl(a.dn_amt,0)) dn_amt, sum(a.cn_amt) cn_amt,sum(nvl(a.dn_amt,0)+nvl(a.cn_amt,0)) dr_cr_amt,
            sum(((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.prev_bal,0)+nvl(a.rec_amt,0)+nvl(a.dn_amt,0)+nvl(a.cn_amt,0)+nvl(a.bill_sec_amt,0))) net_bal,
            abs(sum(nvl(a.sec_opbal,0))) deposit_balance
            from cir_temp_bill_collection a
            where cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.taluka_code,a.dist_code,a.remarks,a.state_code
            order by comp_code,unit_code,state_name,district_name,taluka_name,ag_name;   

            open p_accounts1 for
            select a.comp_code comp_code,a.unit_code unit_code,a.state_code state_name,a.dist_code district_name,
            a.taluka_code||'('||a.dist_code||')' taluka_name,
            sum(nvl(a.gross_amt,0)+nvl(a.sur_amt,0)) bill_amt,sum(a.comm_amt) comm_amt,sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))) net_bill,
            sum(nvl(a.return_amt,0)+nvl(ret_comm_amt,0)) return_amt,sum(nvl(a.return_amt,0)) net_return_amt,
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)) total_bill,abs(sum(nvl(a.bill_sec_amt,0))) dep_adj, 
            sum((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.bill_sec_amt,0)) total_net,
            sum(a.prev_bal) prev_bal, abs(sum(a.rec_amt)) rec_amt,sum(nvl(a.dn_amt,0)) dn_amt, sum(a.cn_amt) cn_amt,sum(nvl(a.dn_amt,0)+nvl(a.cn_amt,0)) dr_cr_amt,
            sum(((nvl(a.gross_amt,0)+nvl(a.sur_amt,0)-nvl(a.comm_amt,0))-nvl(a.return_amt,0)+nvl(a.prev_bal,0)+nvl(a.rec_amt,0)+nvl(a.dn_amt,0)+nvl(a.cn_amt,0)+nvl(a.bill_sec_amt,0))) net_bal,
            abs(sum(nvl(a.sec_opbal,0))) deposit_balance
            from cir_temp_bill_collection a
            where cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.taluka_code,a.dist_code,a.remarks,a.state_code
            order by comp_code,unit_code,state_name,district_name,taluka_name;            
        end if;
        
        delete from cir_temp_bill_collection where cur_sessionid=userenv('sessionid');
        delete from cir_temp_outstanding;
        delete from cir_bill_print where cur_sessionid=userenv('sessionid');commit;
        delete from cir_bill_return_print where cur_sessionid=userenv('sessionid');commit;        
    End cir_weekly_bill_summary_p;         
End cir_rep_billing;
/






***************************************************end issue 5717*****************************************************************************************



//============================================issue no.6016 21\12\2011=======================================================

CREATE OR REPLACE function cir_get_pubcenter (
pcomp_code      in  varchar2,
pubcent_code    in  varchar2,
puserid         in  varchar2,
pdateformat     in  varchar2,
pextra1         in  varchar2,
pextra2         in  varchar2)
return varchar2 is
vcentname varchar2(200);
begin
  begin
    select "Pub_Cent_name" into vcentname from pub_cent_mast where "Pub_cent_Code"=pubcent_code;
     exception when others then
     vcentname:=null;
   end;
    return nvl(vcentname,'');
end;
/
==============================================================================================================
/*****************************Laxman 21-dec-2011***********************/
CREATE OR REPLACE PACKAGE HT18JULY.cir_agency_bind is
   type t_accounts_cursor is ref cursor;
procedure cir_agency_bind_p (
    pcompcode   in varchar2,
    punit       in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    p_accounts  out t_accounts_cursor);
   
procedure cir_branch_billagency_p (
    pcompcode   in varchar2,
    punit       in varchar2,
    pbranchcode in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    p_accounts  out t_accounts_cursor);

procedure cir_agency_bind_p (
    pcompcode   in varchar2,
    punit       in varchar2,
    pagcd       in varchar2,
    pdpcd       in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,    
    p_accounts  out t_accounts_cursor);
    
procedure cir_agency_listing_p (
    pcompcode   in varchar2,
    punit       in varchar2,
    pagty       in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,    
    p_accounts  out t_accounts_cursor);
      
procedure cir_agency_area_p (
    pcompcode   in varchar2,
    punit       in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,    
    p_accounts  out t_accounts_cursor);
        
procedure cir_agency_extraLabel_p(
    pcompcode     in varchar2,
    punit         in varchar2,
    pdateformat   in varchar2,
    pextra1       in varchar2,
    pextra2       in varchar2,
    p_accounts    out t_accounts_cursor);
procedure cir_agency_bind_pd (
    pcompcode       in varchar2,
    punit           in varchar2,
    pname           in varchar2,
    pdateformat     in varchar2,
    -- pextra1 in varchar2,
    pextra2         in varchar2,
    p_accounts      out t_accounts_cursor);
        
procedure cir_agency_bind_pgoogle (
    pcompcode   in varchar2,
    punit       in varchar2,
    pagcd       in varchar2,
    pdpcd       in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,    
    p_accounts  out t_accounts_cursor);
End cir_agency_bind;
/

CREATE OR REPLACE PACKAGE BODY cir_agency_bind is
    procedure cir_agency_bind_p (
        pcompcode         in varchar2,
        punit             in varchar2,
        pdateformat     in varchar2,
        pextra1         in varchar2,
        pextra2         in varchar2,
        p_accounts         out t_accounts_cursor)
        As
  Begin
      if upper(pextra2)='D' then
        open p_accounts for
        select cir_agmast_dis.*,cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME",
        cir_get_agency(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.agcd,cir_agmast_dis.dpcd) "BILL_AGENCY",
        cir_get_agency_city(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.agcd,cir_agmast_dis.dpcd) "BILL_AGENCY_CITY",
        cir_get_drop_point_name(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.station_code,1) as "DROP_POINT_NAME" from cir_agmast_dis
            where comp_code = pcompcode and unit = punit and
            ((upper(ag_name) like upper(pextra1||'%')) or (pextra1 is null)) /*and nvl(freeze_flag,'N')='N'*/
        union
        select cir_agmast_dis.*,cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME",
        cir_get_agency(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.agcd,cir_agmast_dis.dpcd) "BILL_AGENCY",
        cir_get_agency_city(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.agcd,cir_agmast_dis.dpcd) "BILL_AGENCY_CITY",
        cir_get_drop_point_name(cir_agmast_dis.comp_code,cir_agmast_dis.unit,cir_agmast_dis.station_code,1) as "DROP_POINT_NAME" from cir_agmast_dis
            where comp_code = pcompcode and unit = punit and
            ((upper(agcd) like upper(pextra1||'%')) or (pextra1 is null)) /*and nvl(freeze_flag,'N')='N'*/    
        order by 5;
      else
        open p_accounts for
        select cir_agmast.*,cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME",
        cir_get_agency(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY",
        cir_get_agency_city(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY_CITY",
        cir_get_drop_point_name(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.station_code,1) as "DROP_POINT_NAME" from cir_agmast
          where comp_code = pcompcode and unit = punit and
                    ((upper(ag_name) like upper(pextra1||'%')) or (pextra1 is null)) 
            /*and  nvl(freeze_flag,'N')='N'*/
        union
        select cir_agmast.*,cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME",
        cir_get_agency(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY",
        cir_get_agency_city(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.agcd,cir_agmast.dpcd) "BILL_AGENCY_CITY",
        cir_get_drop_point_name(cir_agmast.comp_code,cir_agmast.unit,cir_agmast.station_code,1) as "DROP_POINT_NAME" from cir_agmast
          where comp_code = pcompcode and unit = punit and
                ((upper(agcd) like upper(pextra1||'%')) or (pextra1 is null)) 
              /*and nvl(freeze_flag,'N')='N'*/      
        order by 5;
      end if;
  End cir_agency_bind_p;

  procedure cir_branch_billagency_p (
        pcompcode         in varchar2,
        punit             in varchar2,
        pbranchcode     in varchar2,
        pdateformat     in varchar2,
        pextra1         in varchar2,
        pextra2         in varchar2,
        p_accounts         out t_accounts_cursor)
        As
  Begin
      if upper(pextra2)='D' then
          open p_accounts for
            select cir_agmast_dis.* ,cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME" from cir_agmast_dis
              where comp_code = pcompcode and
                        unit = punit and
                        (branch_code=pbranchcode or pbranchcode is null) and
                        ((upper(ag_name) like upper(pextra1||'%')) or (pextra1 is null)) and
                  nvl(freeze_flag,'N')='N'
            union
            select cir_agmast_dis.* ,cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME" from cir_agmast_dis
              where comp_code = pcompcode and
                        unit = punit and
                        (branch_code=pbranchcode or pbranchcode is null) and
                        ((upper(agcd) like upper(pextra1||'%')) or (pextra1 is null)) and
                  nvl(freeze_flag,'N')='N'      
            order by 5;
       else
          open p_accounts for
            select cir_agmast.* ,cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME" from cir_agmast
              where comp_code = pcompcode and
                        unit = punit and
                        (branch_code=pbranchcode or pbranchcode is null) and
                        ((upper(ag_name) like upper(pextra1||'%')) or (pextra1 is null)) and
                  nvl(freeze_flag,'N')='N'
            union
            select cir_agmast.* ,cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME" from cir_agmast
              where comp_code = pcompcode and
                        unit = punit and
                        (branch_code=pbranchcode or pbranchcode is null) and
                        ((upper(agcd) like upper(pextra1||'%')) or (pextra1 is null)) and
                  nvl(freeze_flag,'N')='N'      
            order by 5;
       end if;
  End cir_branch_billagency_p;

  
procedure cir_agency_bind_pd (
    pcompcode   in varchar2,
    punit       in varchar2,
    pname       in varchar2,
    pdateformat in varchar2,
    -- pextra1 in varchar2,
    pextra2     in varchar2,
    p_accounts  out t_accounts_cursor) as
  Begin
      open p_accounts for
        select * from cir_agmast
           where comp_code = pcompcode and
                 unit = punit and
              ((upper(ag_name)=upper(pname)) or (upper(ag_name) like upper(pname||'%'))) and
              nvl(freeze_flag,'N')='N'
        union
        select * from cir_agmast
           where comp_code = pcompcode and
                 unit = punit and
              ((upper(agcd)=upper(pname)) or (upper(ag_name) like upper(pname||'%'))) and
              nvl(freeze_flag,'N')='N'      
         order by 5;
  End cir_agency_bind_pd;
  
procedure cir_agency_bind_p (
    pcompcode       in varchar2,
    punit           in varchar2,
    pagcd           in varchar2,
    pdpcd           in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    p_accounts      out t_accounts_cursor) as
Begin
    if upper(pextra2)='D' then
        open p_accounts for
            select * from cir_agmast_dis
             where comp_code = pcompcode and
                   unit = punit and
                   agcd=pagcd and
                   dpcd=pdpcd and
                   nvl(freeze_flag,'N')='N'
             order by ag_name;
     else
        open p_accounts for
            select * from cir_agmast
             where comp_code = pcompcode and
                   unit = punit and
                   agcd=pagcd and
                   dpcd=pdpcd and
                   nvl(freeze_flag,'N')='N'
             order by ag_name;
     end if;
End cir_agency_bind_p;

procedure cir_agency_listing_p (--Agency Master Listing
    pcompcode       in varchar2,
    punit           in varchar2,
    pagty           in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    p_accounts      out t_accounts_cursor) as
Begin
    open p_accounts for
    select A.COMP_CODE,A.UNIT,A.BRANCH_CODE,C."Branch_Name" BRANCH_NAME, A.AGCD,A.DPCD,A.AG_NAME,A.AG_NAME_OTH_LANG,
        A.AG_CLASS,(SELECT CLASS_DESC FROM CIR_AGENCY_CLASS_MAST WHERE CIR_AGENCY_CLASS_MAST.COMP_CODE=A.COMP_CODE AND CIR_AGENCY_CLASS_MAST.CLASS_CODE=A.AG_CLASS) AG_CLASS_NAME,
        A.AG_TYPE,CIR_GET_AGENCY_TYPE(A.COMP_CODE,A.AG_TYPE) AG_TYPE_NAME, A.SUPPLY_START_DT,
        A.ADDR1, A.ADDR2, A.ADDR3,A.PIN_CODE, A.CITY_CODE,CIR_GET_CITY(A.COMP_CODE,A.CITY_CODE) CITY_NAME, A.DIST_CODE,CIR_GET_DIST(A.COMP_CODE,A.STATE_CODE,A.DIST_CODE) DIST_NAME,
        A.STATE_CODE,CIR_GET_STATE(A.COMP_CODE,A.COUNTRY_CODE,A.STATE_CODE) STATE_NAME, A.TEHSIL_TALUKA TALUKA_CODE,CIR_GET_TALUKA(A.COMP_CODE,A.TEHSIL_TALUKA) TALUKA_NAME, 
        A.STATION_CODE,CIR_GET_DROP_POINT_NAME(A.COMP_CODE,A.UNIT,A.STATION_CODE,1) DROP_POINT_NAME,
        A.AREA_CODE,CIR_GET_AREA(A.COMP_CODE,A.AREA_CODE) AREA_NAME, A.PHONE_NO1, A.PHONE_NO2, A.MOBILE_NO1, A.MOBILE_NO2,A.FAX_NO, A.EMAIL_ID, A.SUSPEND, A.SUSPEND_TYPE, A.SUSPEND_DATE, 
        A.TO_BILL, A.BILL_AGCD, A.BILL_DPCD,CIR_GET_AGENCY(A.COMP_CODE,A.UNIT,A.BILL_AGCD,A.BILL_DPCD) BILL_AGENCY, A.PAYMODE, A.CREDIT_DAYS, A.PRINT_LABEL, A.PIN_PACKET, 
        A.PIN_AGCD, A.PIN_DPCD,CIR_GET_AGENCY(A.COMP_CODE,A.UNIT,A.PIN_AGCD,A.PIN_DPCD) PIN_AGENCY, A.PIN_OPEN_INSIDE,
        A.NAME_ON_LABEL, A.PRINT_SEQ,CASE WHEN A.UNSOLD_VALID_FLAG='D' THEN 'Daily' WHEN A.UNSOLD_VALID_FLAG='W' THEN 'Weekly' ELSE 'Monthly' END BILL_CYCLE, 
        A.SECURITY_PER, A.SEC_AMT_LIMT, A.SUPPLY_STOP_FLAG, A.SUPPLY_STOP_PER, A.ABC_CITYCODE,CIR_GET_CITY(A.COMP_CODE,A.ABC_CITYCODE) ABC_CITY_NAME,
        B.NAME CON_PER_NAME,B.DESIG CON_PER_DESIG,B.PER_ROLE CON_PER_PER_ROLE,B.DATE_OF_BIRTH DATE_OF_BIRTH, B.PHONE_NO1 CON_PER_PHONE_NO1, B.PHONE_NO2 CON_PER_PHONE_NO2, 
        B.MOBILE_NO1 CON_PER_MOBILE_NO1, B.MOBILE_NO2 CON_PER_MOBILE_NO2, B.FAX_NO CON_PER_FAX_NO, B.EMAIL_ID CON_PER_EMAIL_ID
    from cir_agmast a,cir_ag_con_per b,branch_mst c
        where a.comp_code=b.comp_code(+) and a.comp_code = pcompcode and a.unit=b.unit(+) and (a.unit = punit or punit is null) and 
        a.agcd=b.agcd(+) and a.dpcd=b.dpcd(+) and a.branch_code=c."Branch_Code" and (ag_type = pagty or pagty is null)
    order by a.comp_code,a.unit,a.ag_name, b.name;
    
End cir_agency_listing_p;

procedure cir_agency_area_p (
    pcompcode       in varchar2,
    punit           in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    p_accounts      out t_accounts_cursor) as
Begin
    if upper(pextra2)='D' then
        open p_accounts for
            select cir_agmast_dis.*,cir_get_area(cir_agmast_dis.comp_code,cir_agmast_dis.area_code) "AREA_NAME",cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME" from cir_agmast_dis
                where comp_code = pcompcode and
                        unit      = punit and
                        ((upper(ag_name) like upper(pextra1||'%')) or (pextra1 is null))
            union            
            select cir_agmast_dis.*,cir_get_area(cir_agmast_dis.comp_code,cir_agmast_dis.area_code) "AREA_NAME",cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME" from cir_agmast_dis
                where comp_code = pcompcode and
                        unit      = punit and
                        ((upper(agcd) like upper(pextra1||'%')) or (pextra1 is null))                        
                           order by 7,5;
    else
        open p_accounts for
            select cir_agmast.*,cir_get_area(cir_agmast.comp_code,cir_agmast.area_code) "AREA_NAME",cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME" from cir_agmast
                where comp_code = pcompcode and
                          unit      = punit and
                        ((upper(ag_name) like upper(pextra1||'%')) or (pextra1 is null))
            union
            select cir_agmast.*,cir_get_area(cir_agmast.comp_code,cir_agmast.area_code) "AREA_NAME",cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME" from cir_agmast
                where comp_code = pcompcode and
                          unit      = punit and
                        ((upper(agcd) like upper(pextra1||'%')) or (pextra1 is null))            
                           order by 7,5;
    end if;
End cir_agency_area_p;

procedure cir_agency_extraLabel_p(
    pcompcode     in varchar2,
    punit         in varchar2,
    pdateformat   in varchar2,
    pextra1       in varchar2,
    pextra2       in varchar2,
    p_accounts    out t_accounts_cursor) as
Begin

    open p_accounts for
    select cir_agmast.*,cir_get_area(cir_agmast.comp_code,cir_agmast.area_code) "AREA_NAME",cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME" from cir_agmast
        where comp_code = pcompcode and
              unit      = punit and
              (PRINT_LABEL= 'N' or PRINT_LABEL is null ) and
              (SUSPEND_TYPE='N' or SUSPEND_TYPE is null) and
            ((upper(ag_name) like upper(pextra1||'%')) or (pextra1 is null))
    union
    select cir_agmast.*,cir_get_area(cir_agmast.comp_code,cir_agmast.area_code) "AREA_NAME",cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME" from cir_agmast
        where comp_code = pcompcode and
              unit      = punit and
              (PRINT_LABEL= 'N' or PRINT_LABEL is null ) and
              (SUSPEND_TYPE='N' or SUSPEND_TYPE is null) and
            ((upper(agcd) like upper(pextra1||'%')) or (pextra1 is null))        
               order by 7,5;
End cir_agency_extraLabel_p;


procedure cir_agency_bind_pgoogle (
    pcompcode   in varchar2,
    punit       in varchar2,
    pagcd       in varchar2,
    pdpcd       in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,    
    p_accounts  out t_accounts_cursor)
As
Begin
      if upper(pextra2)='D' then
        open p_accounts for
        select cir_agmast_dis.*,cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME" from cir_agmast_dis
            where comp_code = pcompcode and unit = punit and
            ((upper(ag_name) like upper(pextra1||'%')) or (pextra1 is null)) and nvl(freeze_flag,'N')='N' AND ROWNUM<=10
        union
        select cir_agmast_dis.*,cir_get_city(cir_agmast_dis.comp_code,cir_agmast_dis.city_code) "CITY_NAME" from cir_agmast_dis
            where comp_code = pcompcode and unit = punit and
            ((upper(ag_name) like upper(pextra1||'%')) or (pextra1 is null)) and nvl(freeze_flag,'N')='N' AND ROWNUM<=10    
        order by 5;
      else
        open p_accounts for
        select cir_agmast.*,cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME" from cir_agmast
          where comp_code = pcompcode and
                    unit = punit and
                    ((upper(ag_name) like upper(pextra1||'%')) or (pextra1 is null)) and
              nvl(freeze_flag,'N')='N' AND ROWNUM<=10
        union
        select cir_agmast.*,cir_get_city(cir_agmast.comp_code,cir_agmast.city_code) "CITY_NAME" from cir_agmast
          where comp_code = pcompcode and
                    unit = punit and
                    ((upper(ag_name) like upper(pextra1||'%')) or (pextra1 is null)) and
              nvl(freeze_flag,'N')='N' AND ROWNUM<=10              
        order by 5;
      end if;
End cir_agency_bind_pgoogle;

End cir_agency_bind;
/

/*****************************Laxman 21-dec-2011***********************/




/*********************Laxman 22-dec-2011***************/
CREATE OR REPLACE procedure HT18JULY.cir_prov_receipt_id(
    pcompcode       in varchar2,
    pbranchcode     in varchar2,
    pdoctype        in varchar2,
    precptdt        in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    pextra3         in varchar2,
    pextra4         in varchar2,
    pextra5         in varchar2,
    p_accounts      OUT Cur_Type_New1.cursor_type)
    as
    vno         number(20);
    vrecptno  varchar2(15);
    v_dt date;
BEGIN

    v_dt:=to_date(precptdt,''''||pdateformat||'''');

    Begin
        select max(to_number(substr(recptno,-8)))+1 into vno from cir_rcphdr_prov
            where comp_code=pcompcode and doctype=pdoctype and to_char(recptdt,'yymm')=to_char(v_dt,'yymm') and branch_code=pbranchcode;
    Exception When Others Then
       vno:=null;
    End;

    If nvl(vno,0)=0 Then
      vrecptno:=pbranchcode||'-'||to_char(v_dt,'yymm')||'0001';
    Else
      vrecptno:=pbranchcode||'-'||lpad(vno,8,'0');
    End if;

    open p_accounts for select vrecptno as "VAR_CODE" from dual;

End cir_prov_receipt_id;
/

/*********************Laxman 22-dec-2011***************/

/*********************Laxman 24-dec-2011***************/
CREATE OR REPLACE procedure cir_receipt_for_chqbounce(
    pcompcode       in varchar2,
    punitcode       in varchar2,
    pdoctype        in varchar2,
    pagcd           in varchar2,
    pdpcd           in varchar2,
    precptno        in varchar2,
    prpt_fromdt     in varchar2,
    prpt_tilldt     in varchar2,
    pchqno          in varchar2,
    pchq_fromdt     in varchar2,
    pchq_tilldt     in varchar2,
    pchqbnk_code    in varchar2,
    puserid         in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    pextra3         in varchar2,
    pextra4         in varchar2,
    pextra5         in varchar2,
    pextra6         in varchar2,
    pextra7         in varchar2,
    pextra8         in varchar2,
    pextra9         in varchar2,
    pextra10        in varchar2,
    p_accounts      out Cur_Type_New1.cursor_type)
    as
    v_rpt_fromdt date;
    v_rpt_tilldt date;
    v_chq_fromdt date;
    v_chq_tilldt date;    
begin
    --insert into test1(vstring,vstring2) values('pcompcode '||pcompcode||' punitcode '||punitcode||' pdoctype '||pdoctype||' precptno '|| precptno ||' precptdt '||precptdt,'preasoncode '||preasoncode||' , '||puserid||' , '||pdateformat||' , '||pextra1||' , '||pextra2);commit;
    
    v_rpt_fromdt:=to_date(prpt_fromdt,''''||pdateformat||'''');
    v_rpt_tilldt:=to_date(prpt_tilldt,''''||pdateformat||'''');
    
    if pchq_fromdt is not null and pchq_tilldt is not null then
        v_chq_fromdt:=to_date(pchq_fromdt,''''||pdateformat||'''');
        v_chq_tilldt:=to_date(pchq_tilldt,''''||pdateformat||'''');        
    end if;
    
    
    open p_accounts  for
    select h.comp_code as "COMP_CODE",h.unit_code as "UNIT_CODE",h.agcd as "AGCD",h.dpcd as "DPCD",m.ag_name as "AG_NAME",cir_get_city(h.comp_code,m.city_code) as "CITY_NAME",
    h.doctype as "DOCTYPE",h.recptno as "RECPTNO",h.recptdt as "RECPTDT",abs(h.amount) AS "AMOUNT",h.chno as "CHNO",h.chdt as "CHDT",h.chbank as "CHBANK",
    (select bankname from cir_bank_mast where comp_code=h.comp_code and bankcode=h.chbank) as "CHQBANK_NMAE",
    h.reason as "REASON",h.prov_rec_no as "PROV_REC_NO",h.prov_rec_dt as "PROV_REC_DT",h.received_from as "RECEIVED_FROM",h.achd as "ACHD",
    h.ccdp as "DEBIT_HEAD",(select acc_name from fa_acc_mast where comp_code=h.comp_code and cdp=h.ccdp) as "CREDIT_HEAD_NAME",
    h.rcdp as "CREDIT_HEAD",(select acc_name from fa_acc_mast where comp_code=h.comp_code and cdp=h.rcdp) as "DEBIT_HEAD_NAME"
    from cir_rcphdr h,cir_agmast m
    where h.comp_code=m.comp_code and h.comp_code=pcompcode and h.unit_code=m.unit and h.unit_code=nvl(punitcode,h.unit_code) and 
    h.doctype=pdoctype and h.recptno=nvl(precptno,h.recptno) and h.recptdt>=v_rpt_fromdt and h.recptdt<=v_rpt_tilldt and 
    h.agcd=m.agcd and h.agcd=pagcd and h.dpcd=m.dpcd and h.dpcd=pdpcd and 
    (h.chno=pchqno or pchqno is null) and 
    ((h.chdt between v_chq_fromdt and v_chq_tilldt) or pchq_fromdt is null or pchq_tilldt is null) and
    (h.chbank=pchqbnk_code or pchqbnk_code is null) and h.reason='CH0'
    order by recptdt desc,recptno;
    
End cir_receipt_for_chqbounce;
/

/*********************Laxman 24-dec-2011***************/

/************************* 6138 26-DEC-2011*************/

CREATE OR REPLACE PACKAGE cir_bankbind IS
  type t_accounts_cursor is ref cursor;
  procedure bankbind_p(
  pcompcode in varchar2,
  pextra1    in varchar2,
  pextra2    in varchar2,
  p_accounts out t_accounts_cursor);
    
END cir_bankbind;
/

CREATE OR REPLACE PACKAGE BODY cir_bankbind IS
  procedure bankbind_p(
  pcompcode in varchar2,
  pextra1   in varchar2,
  pextra2   in varchar2,
  p_accounts out t_accounts_cursor)  AS
   Begin
     open p_accounts for
          select bankcode AS "bankcode",bankname as "bankname", 
          city_code,(select city_name from cir_city_mast where comp_code=pcompcode and city_code=cir_bank_mast.city_code) city_name
           from  cir_bank_mast where comp_code=pcompcode and 
          ((upper(bankname) like upper(pextra1)||'%') or (pextra1 is null))
           order by bankname;
   End bankbind_p;
End cir_bankbind;
/

//****************************For paymode****************//

CREATE OR REPLACE PACKAGE cir_paymode_bind IS
  type t_accounts is ref cursor;
  procedure cir_paymode_bind_p(
                pcomp_code in varchar2,
                pdoc_type in varchar2,
                pdateformat in varchar2,
                pextra1 in varchar2,
                pextra2 in varchar2,
                p_accounts out t_accounts);
END cir_paymode_bind;
/

CREATE OR REPLACE PACKAGE BODY cir_paymode_bind IS
 procedure cir_paymode_bind_p(pcomp_code in varchar2,
                pdoc_type in varchar2,
                pdateformat in varchar2,
                pextra1 in varchar2,
                pextra2 in varchar2,
                p_accounts out t_accounts)  AS
  vflagforreceiptentry       varchar(600);
  Begin
           if(pdoc_type !='RCR') then
            open p_accounts for
               select reason_code,reason_name,'N' mode_type from cir_reason_mst where comp_code = pcomp_code and 
               ((upper(reason_name) like upper(pextra1)||'%') or (pextra1 is null)) order by reason_name;
        else
            open p_accounts for
                select "Pay_Mode_Code" ,"Payment_Mode_Name",payment_mode_type mode_type from  Payment_Mode_Mast where ((upper("Payment_Mode_Name") like upper(pextra1)||'%') or (pextra1 is null))
                /*"Comp_Code"=pcomp_code */order by "Payment_Mode_Name";
        end if;
    End cir_paymode_bind_p;
END;
/

/*****************************for executive********************//

CREATE OR REPLACE PACKAGE Cir_Executive_Bind IS
   TYPE T_Circul_Cursor is Ref Cursor;
   procedure cir_executive_bind_p(
   pcompcode in	varchar2,
   pdateformat in varchar2,
   pextra1 in varchar2,
   pextra2 in varchar2,
   p_circuls out T_Circul_Cursor);
   procedure cir_executive_bind_p(
   pcompcode in	varchar2,
   pexecode in	varchar2,
   pdateformat in varchar2,
   pextra1 in varchar2,
   pextra2 in varchar2,
   p_circuls   	out T_Circul_Cursor);
END Cir_Executive_Bind;
/


CREATE OR REPLACE PACKAGE BODY Cir_Executive_Bind IS
   procedure cir_executive_bind_p (
   	    pcompcode in varchar2,
        pdateformat in varchar2,
        pextra1 in varchar2,
        pextra2 in varchar2,
        p_circuls out T_Circul_Cursor) as
       Begin
          open p_circuls for
             select * from cir_executive_mast
                    where comp_code=pcompcode and ((upper(executive_desc) like upper(pextra1)||'%') or (pextra1 is null))
                    and nvl(freeze_flag,'N')='N'
                    order by executive_desc;
       End cir_executive_bind_p;
   procedure cir_executive_bind_p (
   	    pcompcode in varchar2,
        pexecode in varchar2,
        pdateformat in varchar2,
        pextra1 in varchar2,
        pextra2 in varchar2,
        p_circuls out T_Circul_Cursor) as
       Begin
          open p_circuls for
             select * from cir_executive_mast
                    where comp_code=pcompcode and
                          (executive_code=pexecode or pexecode is null) and
                          nvl(freeze_flag,'N')='N'
                    order by executive_desc;
       End cir_executive_bind_p;
END Cir_Executive_Bind;
/

/**************************generate code*************************/

CREATE OR REPLACE PROCEDURE cir_prov_receipt_id (
   pcompcode     IN       VARCHAR2,
   pbranchcode   IN       VARCHAR2,
   pdoctype      IN       VARCHAR2,
   precptdt      IN       VARCHAR2,
   pdateformat   IN       VARCHAR2,
   pextra1       IN       VARCHAR2,
   pextra2       IN       VARCHAR2,
   pextra3       IN       VARCHAR2,
   pextra4       IN       VARCHAR2,
   pextra5       IN       VARCHAR2,
   p_accounts    OUT      cur_type_new1.cursor_type
)
AS
   vno        NUMBER (20);
   vrecptno   VARCHAR2 (15);
   v_dt       DATE;
BEGIN
   v_dt := TO_DATE (precptdt, '''' || pdateformat || '''');

   BEGIN
      SELECT MAX (TO_NUMBER (SUBSTR (recptno, -8))) + 1
        INTO vno
        FROM cir_rcphdr_prov
       WHERE comp_code = pcompcode
         AND doctype = pdoctype
         AND TO_CHAR (recptdt, 'yymm') = TO_CHAR (v_dt, 'yymm')
         AND branch_code = pbranchcode;
   EXCEPTION
      WHEN OTHERS
      THEN
         vno := NULL;
   END;

   IF NVL (vno, 0) = 0
   THEN
      vrecptno := pbranchcode || '-' || TO_CHAR (v_dt, 'yymm') || '0001';
   ELSE
      vrecptno := pbranchcode || '-' || LPAD (vno, 8, '0');
   END IF;

   OPEN p_accounts FOR
      SELECT vrecptno AS "VAR_CODE"
        FROM DUAL;
END cir_prov_receipt_id;
/

/***************************agency name***********************/

CREATE OR REPLACE FUNCTION cir_get_agency(pcomp_code in varchar2,punit_code in varchar,pagcd in varchar2,pdpcd in varchar2) RETURN varchar2 IS
vag_name cir_agmast.ag_name%type;
BEGIN
 Begin
     select ag_name into vag_name from
     (select ag_name 
        from cir_agmast
         where comp_code=pcomp_code and
               unit=punit_code and
               agcd=pagcd and
               dpcd=pdpcd
     union
     select ag_name 
        from cir_agmast_dis
         where comp_code=pcomp_code and
               unit=punit_code and
               agcd=pagcd and
               dpcd=pdpcd);
         exception when others then
              vag_name:=null;
 End;
  return nvl(vag_name,'');
END;
/

/************************pay mode***********************/

CREATE OR REPLACE FUNCTION cir_get_payreason(
    pcomp_code  in varchar2,
    pdoc_type   in varchar2,
    ppayreason  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    pextra3     in varchar2,
    pextra4     in varchar2,
    pextra5     in varchar2)  return varchar2 is
    v_desc       varchar(100);
Begin
    if(pdoc_type !='RCR') then
        select reason_name into v_desc from cir_reason_mst 
            where comp_code = pcomp_code and upper(reason_code) =ppayreason;
    else
        select distinct "Payment_Mode_Name" into v_desc from Payment_Mode_Mast 
            where /*"Comp_Code"=pcomp_code and*/ upper("Pay_Mode_Code") =ppayreason;
    end if;
    
    return nvl(v_desc,ppayreason);
END;
/

/*************************************************************/

CREATE OR REPLACE PACKAGE Cir_Executive_Bind IS
   TYPE T_Circul_Cursor is Ref Cursor;
   procedure cir_executive_bind_p(
   pcompcode in	varchar2,
   pdateformat in varchar2,
   pextra1 in varchar2,
   pextra2 in varchar2,
   p_circuls out T_Circul_Cursor);
END Cir_Executive_Bind;
/

CREATE OR REPLACE PACKAGE BODY Cir_Executive_Bind IS
   procedure cir_executive_bind_p (
   	    pcompcode in varchar2,
        pdateformat in varchar2,
        pextra1 in varchar2,
        pextra2 in varchar2,
        p_circuls out T_Circul_Cursor) as
       Begin
          open p_circuls for
             select * from cir_executive_mast
                    where comp_code=pcompcode and ((upper(executive_desc) like upper(pextra1)||'%') or (pextra1 is null))
                    and nvl(freeze_flag,'N')='N'
                    order by executive_desc;
       End cir_executive_bind_p;
END Cir_Executive_Bind;
/

/**********************************************************/

CREATE OR REPLACE PACKAGE cir_bankbind IS
  type t_accounts_cursor is ref cursor;
  procedure bankbind_p(
  pcompcode in varchar2,
  pextra1    in varchar2,
  pextra2    in varchar2,
  p_accounts out t_accounts_cursor);
END cir_bankbind;
/

CREATE OR REPLACE PACKAGE BODY cir_bankbind IS
  procedure bankbind_p(
  pcompcode in varchar2,
  pextra1   in varchar2,
  pextra2   in varchar2,
  p_accounts out t_accounts_cursor)  AS
   Begin
     open p_accounts for
          select bankcode AS "bankcode",bankname as "bankname", 
          city_code,(select city_name from cir_city_mast where comp_code=pcompcode and city_code=cir_bank_mast.city_code) city_name
           from  cir_bank_mast where comp_code=pcompcode and 
          ((upper(bankname) like upper(pextra1)||'%') or (pextra1 is null))
           order by bankname;
   End bankbind_p;
End cir_bankbind;
/

/**************************function**************************************/

CREATE OR REPLACE FUNCTION cir_get_provreceipt_exist
    (pcomp_code     in varchar2,
     punit_code     in varchar2,
     pbran_code     in varchar2,
     precptno       in varchar2,
     pdoctype       in varchar2,
     pagcd          in varchar2,
     pdpcd          in varchar2,
     pextra1        in varchar2,
     pextra2        in varchar2,
     pextra3        in varchar2,
     pextra4        in varchar2,
     pextra5        in varchar2) RETURN number IS
 v_rec_exist number(5):=0;
BEGIN
    if upper(pextra2)='D' then
        select count(*) into v_rec_exist from cir_rcphdr_prov where comp_code=pcomp_code and unit_code=punit_code and 
        doctype=pdoctype and recptno=precptno and agcd=pagcd and dpcd=pdpcd and branch_code=pbran_code;
    else
        select count(*) into v_rec_exist from cir_rcphdr_prov where comp_code=pcomp_code and unit_code=punit_code and 
        doctype=pdoctype and recptno=precptno and agcd=pagcd and dpcd=pdpcd and branch_code=pbran_code;    
    end if;    
     
  return nvl(v_rec_exist,0);
END;
/

/*******************************company address************************/

CREATE OR REPLACE PACKAGE cir_company_detail IS
  type t_accounts is ref cursor;
     
  procedure cir_company_detail_p(
     pcompcode          in varchar2,
     plangtype          in varchar2,---1 for enlish and 2 for other language
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts);

End cir_company_detail;
/

CREATE OR REPLACE PACKAGE BODY cir_company_detail IS

  Procedure cir_company_detail_p(
     pcompcode          in varchar2,
     plangtype          in varchar2,---1 for enlish and 2 for other language
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts)
  As
  Begin
        open p_accounts for 
        select comp_mst.*,(select distinct "City_Name" from city_mst where "City_Code"=comp_mst."City_Code") city_name,
        (SELECT distinct "Country_Name" FROM count_mst where "Country_Code"=comp_mst."Country_Code") country_name from comp_mst 
        where ("Comp_Code"=pcompcode or pcompcode is null)
        order by "Comp_Code";

  END cir_company_detail_p;

END cir_company_detail;
/


//***************************end of 6138*************************//


////////////////////////////issue no. 6085 26/12/2011//////////////////////////////////////////////

CREATE OR REPLACE FUNCTION HT18JULY.cir_get_publ_name(pcomp_code in varchar2,ppubl in varchar2) RETURN varchar2 IS
vpubl_name cir_publ_mast.publ_name%type;
BEGIN
   Begin
      select publ_name into vpubl_name from cir_publ_mast where comp_code=pcomp_code and publ=ppubl;
           exception when others then
                            vpubl_name:=null;
  End;
    return nvl(vpubl_name,'');
END;
/
//////////////////////////////////////////////////////////////////////////////////////////

/***********************mimoh 26dec 2011*********************************0006137****************/


CREATE OR REPLACE PACKAGE Wesp_Updatedate
IS
PROCEDURE      Wesp_Updatedate_p(
compcode IN VARCHAR2,
userid IN VARCHAR2,
dateformat IN VARCHAR2,
code IN VARCHAR2,
curr IN VARCHAR2,
RATECODE11 IN VARCHAR2,
solo  IN VARCHAR2,
breakup VARCHAR2,
bwcode IN VARCHAR2,
rostatus IN VARCHAR2,
filename IN VARCHAR2,
tfn IN NUMBER,
insertbreak IN VARCHAR2,
prem IN VARCHAR2,
dealtype IN VARCHAR2,
pre IN VARCHAR2,
suff IN VARCHAR2,
financestatus IN  VARCHAR2,
voucherst IN VARCHAR2,
adcode IN VARCHAR2,
rodatetime IN VARCHAR2,
spacearea IN VARCHAR2,
vat IN VARCHAR2,
bookstat IN VARCHAR2,
cio_id IN VARCHAR2,
receipt_no IN VARCHAR2,
uom IN VARCHAR2,
bgcolor IN VARCHAR2,
validdate IN VARCHAR2,
agencyratecode IN VARCHAR2,
AUDIT1 IN VARCHAR2,
book_insert_date IN VARCHAR2,
agencycomm IN VARCHAR2,
rateaudit IN VARCHAR2,
billaudit IN VARCHAR2,
bill_type IN VARCHAR2,
invoice_no1 IN VARCHAR2,
copybooking IN VARCHAR2,
ratecompany IN VARCHAR2,
addagenycomm IN VARCHAR2,
agencycommlinkretainer IN VARCHAR2,
subeditionr IN VARCHAR2,
displaybilltype IN VARCHAR2,
classifiedbilltype IN VARCHAR2,
billformat IN VARCHAR2,
ratechk IN VARCHAR2,
allpkg IN VARCHAR2,
dayrate1 in varchar2,
schemetype in varchar2,
PIncludeclassi in varchar2,
receiptformat IN VARCHAR2,
v_cash_receipt in varchar2,
v_bill_orderwiselast in varchar2,
v_floor_chk in varchar2,
Unsoldflag in varchar2,
Supplystopper in  number,
drpRokeychk in varchar2,
Agencycomm_seq in varchar2,
creditreciept in varchar,
cashindisplay IN VARCHAR,
cashinclassified IN VARCHAR,
v_rate_audit_pref in varchar,
v_barcoding_allow_pref in varchar2,
v_fmgbills IN VARCHAR2,
v_billed_cashdis in varchar2,
v_billed_cashcls in varchar,
v_drpbackdate in varchar,
dockitbooking in varchar2,
allowprevbooking in varchar2,
ro_wisecashbill in varchar2,
chkval in varchar2,
approval1 in varchar2,
pckstatus in varchar2,
cash_disc in varchar2,
cash_amt in varchar2,
seperate_cashier1 in varchar2,
disp_bill in varchar2,
clas_bill in varchar2,
mantimepost in varchar2,
bkdaypost in number,
maxterutn in number,
cir_return in varchar2,
noofchkbounc in number,
noofdaychkrec in number,
retday in number,
chngsuppord in number,
max_publishday in number,
p_billno_period in varchar,
spl_trans_edit in varchar2,
spl_dis_trans_editable in varchar2,
mul_pac_sel_trans in varchar2,
shmon_minword in varchar2,
tradon_spcrg in varchar2,
rateauth     in varchar2,
f2day in number,
rateauditmodify in varchar,
bindrevenuecenter in varchar,
p_led_allow in varchar,
p_clear_allow in varchar,
repeatday in varchar,
premiumedit in varchar,
P_BILL_GENERATION in varchar,
P_PUBLICATION_CENTER in varchar,
P_allow_discount_prem IN VARCHAR,
P_SCHEME_BILLING in varchar,
P_ALLOW_PDC in varchar,
PAD_TYPE_FOR_MANUL_BILL in varchar,
RO_OUTSTAND_P IN VARCHAR2,
genrate_agency_code IN VARCHAR2,
p_dispauditbk IN VARCHAR2,
p_aotosupply  IN VARCHAR2,
p_Authorization IN VARCHAR2,
p_CIR_AUTO_APPROVAL_UNSOLD IN VARCHAR2,
p_CIR_AUTO_PHYSICAL_UNSOLD IN VARCHAR2,
p_CIR_UNSOLD_INCLUDE_INCT IN VARCHAR2,
p_CIR_UNSOLD_INCLUDE_INSFEE IN VARCHAR2,
p_CIR_UNSOLD_ON_RECEIVED_DT IN VARCHAR2,
p_AGENCY_UNBLOCK_APROV IN VARCHAR2,
p_UNBLOCK_APROV_OUT_LMT IN VARCHAR2,
p_CIR_BILL_PUBLWISE IN VARCHAR2,
p_paging         IN VARCHAR2,
p_print          IN VARCHAR2,
p_allowpage      IN VARCHAR2,
p_agency_req     IN VARCHAR2,
p_region_req     IN VARCHAR2,
p_ALLOW_FOLLOW_DT_BOOOK     IN VARCHAR2,
p_CRM_SUPPLY_TYPE_PAID     IN VARCHAR2,
p_CRM_SUPPLY_TYPE_FREE     IN VARCHAR2

);
END      Wesp_Updatedate;
/





CREATE OR REPLACE PACKAGE BODY Wesp_Updatedate IS
PROCEDURE      Wesp_Updatedate_p(
compcode IN VARCHAR2,
userid IN VARCHAR2,
dateformat IN VARCHAR2,
code IN VARCHAR2,
curr IN VARCHAR2,
RATECODE11 IN VARCHAR2,
solo  IN VARCHAR2,
breakup VARCHAR2,
bwcode IN VARCHAR2,
rostatus IN VARCHAR2,
filename IN VARCHAR2,
tfn IN NUMBER,
insertbreak IN VARCHAR2,
prem IN VARCHAR2,
dealtype IN VARCHAR2,
pre IN VARCHAR2,
suff IN VARCHAR2,
financestatus IN  VARCHAR2,
voucherst IN VARCHAR2,
adcode IN VARCHAR2,
rodatetime IN VARCHAR2,
spacearea IN VARCHAR2,
vat IN VARCHAR2,
bookstat IN VARCHAR2,
cio_id IN VARCHAR2,
receipt_no IN VARCHAR2,
uom IN VARCHAR2,
bgcolor IN VARCHAR2,
validdate IN VARCHAR2,
agencyratecode IN VARCHAR2,
AUDIT1 IN VARCHAR2,
book_insert_date IN VARCHAR2,
agencycomm IN VARCHAR2,
rateaudit IN VARCHAR2,
billaudit IN VARCHAR2,
bill_type IN VARCHAR2,
invoice_no1 IN VARCHAR2,
copybooking IN VARCHAR2,
ratecompany IN VARCHAR2,
addagenycomm IN VARCHAR2,
agencycommlinkretainer IN VARCHAR2,
subeditionr IN VARCHAR2,
displaybilltype IN VARCHAR2,
classifiedbilltype IN VARCHAR2,
billformat IN VARCHAR2,
ratechk IN VARCHAR2,
allpkg IN VARCHAR2,
dayrate1 in varchar2,
schemetype in varchar2,
PIncludeclassi in varchar2,
receiptformat IN VARCHAR2,
v_cash_receipt in varchar2,
v_bill_orderwiselast in varchar2,
v_floor_chk in varchar2,
Unsoldflag in varchar2,
Supplystopper in  number,
drpRokeychk in varchar2,
Agencycomm_seq in varchar2,
creditreciept in varchar,
cashindisplay IN VARCHAR,
cashinclassified IN VARCHAR,
v_rate_audit_pref in varchar,
v_barcoding_allow_pref in varchar2,
v_fmgbills IN VARCHAR2,
v_billed_cashdis in varchar2,
v_billed_cashcls in varchar,
v_drpbackdate in varchar,
dockitbooking in varchar2,
allowprevbooking in varchar2,
ro_wisecashbill in varchar2,
chkval in varchar2,
approval1 in varchar2,
pckstatus in varchar2,
cash_disc in varchar2,
cash_amt in varchar2,
seperate_cashier1 in varchar2,
disp_bill in varchar2,
clas_bill in varchar2,
mantimepost in varchar2,
bkdaypost in number,
maxterutn in number,
cir_return in varchar2,
noofchkbounc in number,
noofdaychkrec in number,
retday in number,
chngsuppord in number,
max_publishday in number,
p_billno_period in varchar,
spl_trans_edit in varchar2,
spl_dis_trans_editable in varchar2,
mul_pac_sel_trans in varchar2,
shmon_minword in varchar2,
tradon_spcrg in varchar2,
rateauth     in varchar2,
f2day in number,
rateauditmodify in varchar,
bindrevenuecenter in varchar,
p_led_allow in varchar,
p_clear_allow in varchar,
repeatday in varchar,
premiumedit in varchar,
P_BILL_GENERATION in varchar,
P_PUBLICATION_CENTER in varchar,
P_allow_discount_prem IN VARCHAR,
P_SCHEME_BILLING in varchar,
P_ALLOW_PDC in varchar,
PAD_TYPE_FOR_MANUL_BILL in varchar,
RO_OUTSTAND_P IN VARCHAR2,
genrate_agency_code IN VARCHAR2,
p_dispauditbk IN VARCHAR2,
p_aotosupply  IN VARCHAR2,
p_Authorization IN VARCHAR2,
p_CIR_AUTO_APPROVAL_UNSOLD IN VARCHAR2,
p_CIR_AUTO_PHYSICAL_UNSOLD IN VARCHAR2,
p_CIR_UNSOLD_INCLUDE_INCT IN VARCHAR2,
p_CIR_UNSOLD_INCLUDE_INSFEE IN VARCHAR2,
p_CIR_UNSOLD_ON_RECEIVED_DT IN VARCHAR2,
p_AGENCY_UNBLOCK_APROV IN VARCHAR2,
p_UNBLOCK_APROV_OUT_LMT IN VARCHAR2,
p_CIR_BILL_PUBLWISE IN VARCHAR2,
p_paging         IN VARCHAR2,
p_print          IN VARCHAR2,
p_allowpage      IN VARCHAR2,
p_agency_req     IN VARCHAR2,
p_region_req     IN VARCHAR2,
p_ALLOW_FOLLOW_DT_BOOOK     IN VARCHAR2,
p_CRM_SUPPLY_TYPE_PAID     IN VARCHAR2,
p_CRM_SUPPLY_TYPE_FREE     IN VARCHAR2

)AS
BEGIN
UPDATE LOGIN SET "date_format"=dateformat, "Autogenerate"=code,"curr_code"=curr WHERE "COM_CODE"=compcode;
COMMIT;
        UPDATE PREFERRENCES SET  "autogenerated"=code,
"currency_code"=curr ,
"rate_gr_code"=RATECODE11,
"date_format"=dateformat,"solo"=solo,"breakup"=breakup,
"blackwhitecode"=bwcode,"rostatus"=rostatus,"File_name"=filename,"Tfn"=tfn,
"Insert_breakup"=insertbreak,"Premium_type"=prem,"Deal_type"=dealtype  ,
 "prefix"=pre, "suffix"=suff, "financestatus"=financestatus , "voucherst"=voucherst,
 "Ad_category"=adcode ,"Ro_datetime"=rodatetime ,"Space_area"=spacearea,"Vat"=vat,
 "Booking_status"=bookstat,"Cio_id"=cio_id,"Receipt_no"=receipt_no,"uom_code"=uom,
 "Bgcolor_publication"=bgcolor ,"chkfor_valid_pubdates"=validdate, "Agency_ratecode"=agencyratecode,
  "audit"=AUDIT1,"book_insert_date"=book_insert_date,"agencycomm"=agencycomm,
  "rate_audit"=rateaudit,"bill_audit"=billaudit,"billtype"=bill_type,"invoice_no"=invoice_no1,
  "copy_booking"=copybooking,"RATE_COMPANY_AGENCY"=ratecompany, "ADDITIONAL_AGENCY_COMM"=addagenycomm ,
  "AGENCY_RETAINER_COMM"=agencycommlinkretainer,"SUBEDITIONRATE"=subeditionr,
  "CLS_BILLTYPE"=classifiedbilltype,"DIS_BILLTYPE"=displaybilltype,"BILLING_FORMAT"=billformat,
  "RATE_CHECK"=ratechk,"ALL_PACKAGE"=allpkg,"DAYRATE"=dayrate1,"SCHEME_TYPE"=schemetype,"DISP_CLSBILL"=PIncludeclassi   ,
  "CASH_RECEIPT_BILL"=v_cash_receipt, "BILL_ORDERWSLAST"=v_bill_orderwiselast, "FLOOR_CHK"=v_floor_chk ,
  "UNSOLD_ENTRY_FLAG"=Unsoldflag ,"SUPPLY_STOP_PERCENTAGE"=Supplystopper,"ROKEYCHECK"=drpRokeychk ,
  "AGENCYCOMM_SEQ_COM"=Agencycomm_seq ,"CREDIT_RECIPT"=creditreciept,"DISP_CASHBILL"=cashindisplay,
  "CLA_CASHBILL"=cashinclassified,"RATE_AUDIT_PREF"=v_rate_audit_pref,"BARCODING_ALLOWED"=v_barcoding_allow_pref,
  "FMG_BILL_DIS" =v_fmgbills, "BILL_DISP_CASHBILL"=v_billed_cashdis , "BILL_CLA_CASHBILL"=v_billed_cashcls,"BACKDATERECEIPT"=v_drpbackdate,"DOCKIT_BOOKING"=dockitbooking,"Allowed_old_date"=allowprevbooking,"ROWISE_CASHBOOKING"=ro_wisecashbill,"CUTOFFTIME"=chkval,"APPROVAL"=approval1,"BACK_DAYS"=pckstatus ,CASH_DISCOUNT=cash_amt,CASH_DISCOUNTTYPE=cash_disc,SEPRATE_CASHIER=seperate_cashier1,
   CIR_MANY_TIME_POSTING=mantimepost, CIR_BACKDAYS_POSTING=bkdaypost, CIR_MAX_RETURN_ALLOW=maxterutn, CIR_RETURN_LIMIT_ALLOW=cir_return, CIR_NO_OF_CHQBOUNCE=noofchkbounc, CIR_DAYS_CHQBOUNCE=noofdaychkrec, CIR_RETURN_DAYS=retday, CIR_SUP_ORDER_LIMIT=chngsuppord, DISP_BILLING_CRITERIA=disp_bill, CLSD_BILLING_CRITERIA=clas_bill,MAX_PUBLISHDAYS=max_publishday,BILLNO_PERIODICITY=p_billno_period,
   SPECIALDISC_TRANS_EDIT=spl_trans_edit, SHARING_TRANS=spl_dis_trans_editable, MULTIPACKAGE_SEL_TRANS=mul_pac_sel_trans,SCHEME_MINWORD=shmon_minword, TRADE_SPLCHARGE=tradon_spcrg,RATE_AUTHORIZATION=rateauth
  ,F2_RECORD=f2day,PUBLISHAD_EDIT_RATEAUDIT=rateauditmodify,BINDREVENUE_CENTER=bindrevenuecenter,  
  FA_LEDGER_ALLOW=p_led_allow ,CLEARANCE_TYPE_ALLOW=p_clear_allow,REPEAT_DAY_TYPE=repeatday,PREMIUM_EDIT=premiumedit,
BILL_GENERATION_PRIOR=P_BILL_GENERATION,PUBLICATION_HO=P_PUBLICATION_CENTER,SPLDISC_ALLOWPREM=P_allow_discount_prem,

BILL_SCHEME=P_SCHEME_BILLING,ALLOWED_PDC_DAYS_RECEIPT=P_ALLOW_PDC ,AD_TYPE_MANUL_BILL=PAD_TYPE_FOR_MANUL_BILL,OUTSTANDING_AMT_CRITERIA=RO_OUTSTAND_P,GENRATE_CIR_AGCD=genrate_agency_code,DISP_AUDITBKG=p_dispauditbk,CIR_DIS_AUTO_POSTING=p_aotosupply,RELAUTHREQON=p_Authorization,
CIR_AUTO_APPROVAL_UNSOLD=p_CIR_AUTO_APPROVAL_UNSOLD,CIR_AUTO_PHYSICAL_UNSOLD=p_CIR_AUTO_PHYSICAL_UNSOLD,CIR_UNSOLD_INCLUDE_INCT=p_CIR_UNSOLD_INCLUDE_INCT,
CIR_UNSOLD_INCLUDE_INSFEE=p_CIR_UNSOLD_INCLUDE_INSFEE,CIR_UNSOLD_ON_RECEIVED_DT=p_CIR_UNSOLD_ON_RECEIVED_DT,
AGENCY_UNBLOCK_APPROVAL=p_AGENCY_UNBLOCK_APROV,UNBLOCK_APPROVAL_OUTSIDE_LIMIT=p_UNBLOCK_APROV_OUT_LMT,CIR_BILL_PUBLWISE=p_CIR_BILL_PUBLWISE,
RECORDS_ON_PAGE = p_paging,RECORDS_ON_PRINT = p_print,HEADER_ON_PAGE = p_allowpage,AGENCY_REQUIRED = p_agency_req,REGION_REQUIRED = p_region_req,ALLOW_FOLLOW_DT_BOOOK=p_ALLOW_FOLLOW_DT_BOOOK,CRM_SUPPLY_TYPE_PAID=p_CRM_SUPPLY_TYPE_PAID,CRM_SUPPLY_TYPE_FREE=p_CRM_SUPPLY_TYPE_FREE

  
   WHERE "comp_code"=compcode;
COMMIT;
END      Wesp_Updatedate_p;
END      Wesp_Updatedate;
/

/**********************/



CREATE OR REPLACE PACKAGE Currbindpreferpgld
IS
   TYPE t_account_cursor IS REF CURSOR;

   PROCEDURE currbindpreferpgld_p (
      compcode     IN       VARCHAR2,
      p_accounts   OUT      t_account_cursor
   );
END Currbindpreferpgld;
/





CREATE OR REPLACE PACKAGE BODY Currbindpreferpgld
IS
   PROCEDURE currbindpreferpgld_p (
      compcode     IN       VARCHAR2,
      p_accounts   OUT      t_account_cursor
   )
   AS
   BEGIN
      OPEN p_accounts FOR
         SELECT "date_format", "autogenerated", "currency_code",
                "rate_gr_code", "solo", "breakup", "blackwhitecode",
                "rostatus", "File_name", "Tfn", "Insert_breakup", "prefix",
                "suffix", "financestatus", "voucherst", "Ad_category",
                "Ro_datetime", "Vat", "Booking_status", "Cio_id",
                "Receipt_no","uom_code","Bgcolor_publication","chkfor_valid_pubdates","Agency_ratecode","audit","book_insert_date","agencycomm",
                "rate_audit","bill_audit","billtype","Premium_type","copy_booking","RATE_COMPANY_AGENCY","ADDITIONAL_AGENCY_COMM","AGENCY_RETAINER_COMM","SUBEDITIONRATE",CLS_BILLTYPE,DIS_BILLTYPE,
                "BILLING_FORMAT","RATE_CHECK","ALL_PACKAGE",dayrate,SCHEME_TYPE,DISP_CLSBILL,RECEIPT_FORMAT,CASH_RECEIPT_BILL, BILL_ORDERWSLAST, FLOOR_CHK,
                ROKEYCHECK, AGENCYCOMM_SEQ_COM, CREDIT_RECIPT,  DISP_CASHBILL, CLA_CASHBILL,
                RATE_AUDIT_PREF,BARCODING_ALLOWED, FMG_BILL_DIS,BILL_DISP_CASHBILL, BILL_CLA_CASHBILL,BACKDATERECEIPT,ROWISE_CASHBOOKING,CUTOFFTIME,DOCKIT_BOOKING,APPROVAL,BACK_DAYS,CASH_DISCOUNT,CASH_DISCOUNTTYPE,"Allowed_old_date",SEPRATE_CASHIER,
                CIR_MANY_TIME_POSTING, CIR_BACKDAYS_POSTING, CIR_MAX_RETURN_ALLOW, CIR_RETURN_LIMIT_ALLOW, CIR_NO_OF_CHQBOUNCE, CIR_DAYS_CHQBOUNCE, CIR_RETURN_DAYS, CIR_SUP_ORDER_LIMIT, DISP_BILLING_CRITERIA, CLSD_BILLING_CRITERIA,MAX_PUBLISHDAYS,
                BILLNO_PERIODICITY, SPECIALDISC_TRANS_EDIT, SHARING_TRANS, MULTIPACKAGE_SEL_TRANS,SCHEME_MINWORD, TRADE_SPLCHARGE,RATE_AUTHORIZATION,
           F2_RECORD,PUBLISHAD_EDIT_RATEAUDIT,BINDREVENUE_CENTER, FA_LEDGER_ALLOW,CLEARANCE_TYPE_ALLOW,REPEAT_DAY_TYPE,PREMIUM_EDIT,
           
           BILL_GENERATION_PRIOR,PUBLICATION_HO,SPLDISC_ALLOWPREM,BILL_SCHEME,ALLOWED_PDC_DAYS_RECEIPT,
           AD_TYPE_MANUL_BILL,OUTSTANDING_AMT_CRITERIA as RO_OUTSTAND,GENRATE_CIR_AGCD,DISP_AUDITBKG,CIR_DIS_AUTO_POSTING,RELAUTHREQON,
        CIR_AUTO_APPROVAL_UNSOLD, CIR_AUTO_PHYSICAL_UNSOLD, CIR_UNSOLD_INCLUDE_INCT, CIR_UNSOLD_INCLUDE_INSFEE, CIR_UNSOLD_ON_RECEIVED_DT,
        AGENCY_UNBLOCK_APPROVAL,UNBLOCK_APPROVAL_OUTSIDE_LIMIT,CIR_BILL_PUBLWISE ,RECORDS_ON_PAGE,RECORDS_ON_PRINT,HEADER_ON_PAGE,AGENCY_REQUIRED,REGION_REQUIRED,ALLOW_FOLLOW_DT_BOOOK,CRM_SUPPLY_TYPE_PAID,CRM_SUPPLY_TYPE_FREE  
            FROM PREFERRENCES
          WHERE "comp_code" = compcode;
          
         
   END currbindpreferpgld_p;
END Currbindpreferpgld;
/

/*************************/



CREATE OR REPLACE PACKAGE Cir_Supply_Type_Bind IS
    type t_accounts_type is ref cursor;
procedure Cir_Supply_Type_Bind_p(
    pcomp_code      in varchar2,
    pdateformat 	in varchar2,
    pextra1 		in varchar2,
    pextra2 		in varchar2,
    p_accounts 		out t_accounts_type);
        
END Cir_Supply_Type_Bind;
/





CREATE OR REPLACE PACKAGE BODY Cir_Supply_Type_Bind IS
procedure Cir_Supply_Type_Bind_p(
  	pcomp_code      in varchar2,
    pdateformat 	in varchar2,
    pextra1 		in varchar2,--for billing pay Y/N
    pextra2 		in varchar2,
    p_accounts 		out t_accounts_type)
  As
  Begin
	  open  p_accounts for
	  select * from cir_supply_type_mast where comp_code=pcomp_code and (bill_pay=pextra1 or pextra1 is null)
	  order by sup_seq_no,sup_ty_name;
      
  End Cir_Supply_Type_Bind_p;
END Cir_Supply_Type_Bind;
/


/***********************mimoh 26dec 2011*********************************0006137****************/
//////////////////////////////garima 27 dec****************************
CREATE OR REPLACE PACKAGE cir_supply_alteration IS
  TYPE T_Circul_Cursor is Ref Cursor;
  procedure cir_supply_alteration_p(
      pcomp_code        in varchar2,
      punit_code        in varchar2,
      ppubl_code        in varchar2,
      pmedtn_code       in varchar2,
      pedtn_code        in varchar2,
      psup_type         in varchar2,
      pstate            in varchar2,
      pdistcode         in varchar2,
      ptaluka           in varchar2,
      pcitycode         in varchar2,
      pbrancode         in varchar2,
      proutecode        in varchar2,
      pagcd_code        in varchar2,
      pdpcd_code        in varchar2,
      psorted_by        in varchar2,--1 for  edition route wise,2 for edition district wise
      pdateformat       in varchar2,
      puserid           in varchar2,--for login user id
      pextra1           in varchar2,--agency type
      pextra2           in varchar2,--for agency--A and distribution--D
      pextra3           in varchar2,--agency class
      pextra4           in varchar2,--for zone
      pextra5           in varchar2,--for region
      pextra6           in varchar2,
      pextra7           in varchar2,
      pextra8           in varchar2,
      pextra9           in varchar2,
      pextra10          in varchar2,      
      p_circuls         out T_Circul_Cursor);
  procedure cir_supply_unsold_return_p(
      pcomp_code        in varchar2,
      punit_code        in varchar2,
      ppubl_code        in varchar2,
      pedtn_code        in varchar2,
      pagcd_code        in varchar2,
      pdpcd_code        in varchar2,
      pfromdate         in varchar2,
      ptilldate         in varchar2,
      preturn_type      in varchar2,
      pdateformat       in varchar2,
      pextra1           in varchar2,
      pextra2           in varchar2,
      pextra3           in varchar2,
      pextra4           in varchar2,
      pextra5           in varchar2,      
      p_circuls         out T_Circul_Cursor);      
END cir_supply_alteration;

/
CREATE OR REPLACE PACKAGE BODY cir_supply_alteration IS
  procedure cir_supply_alteration_p(
      pcomp_code        in varchar2,
      punit_code        in varchar2,
      ppubl_code        in varchar2,
      pmedtn_code       in varchar2,
      pedtn_code        in varchar2,
      psup_type         in varchar2,
      pstate            in varchar2,
      pdistcode         in varchar2,
      ptaluka           in varchar2,
      pcitycode         in varchar2,
      pbrancode         in varchar2,
      proutecode        in varchar2,
      pagcd_code        in varchar2,
      pdpcd_code        in varchar2,
      psorted_by        in varchar2,--1 for  edition route wise,2 for edition district wise
      pdateformat       in varchar2,
      puserid           in varchar2,--for login user id
      pextra1           in varchar2,--agency type
      pextra2           in varchar2,--for agency--A and distribution--D
      pextra3           in varchar2,--agency class
      pextra4           in varchar2,--for zone
      pextra5           in varchar2,--for region
      pextra6           in varchar2,--for suspend Y/N
      pextra7           in varchar2,--for commition category
      pextra8           in varchar2,
      pextra9           in varchar2,
      pextra10          in varchar2,      
      p_circuls         out T_Circul_Cursor)
 As

 Begin
  if upper(pextra2)='D' then
      if psorted_by=2 then---for edition district and agency wise
          open p_circuls for
            select a.comp_code comp_code,a.unit unit,a.agcd agcd,a.dpcd dpcd,a.ag_name agency_name,a.ag_name_oth_lang agency_name_other_lang,a.city_code city_code,
            cir_get_city(a.comp_code,a.city_code) city_name,a.station_code drop_point_code,cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,'1') drop_point_name,
            nvl(c.base_supply,0) base_supply,nvl(c.supply_sun,0) supply_sun,nvl(c.supply_mon,0) supply_mon,nvl(c.supply_tue,0) supply_tue,nvl(c.supply_wed,0) supply_wed,
            nvl(c.supply_thu,0) supply_thu,nvl(c.supply_fri,0) supply_fri,nvl(c.supply_sat,0) supply_sat,nvl(c.supply_spl1,0) supply_spl1,nvl(c.supply_spl2,0) supply_spl2,
            c.lbl_printno supply_seq,cir_get_route_seqno(c.comp_code,c.unit,c.route_code) route_seq,
            c.route_code,cir_get_name.cir_route(a.comp_code,a.unit,c.route_code,1,pdateformat,'','') route_name, 
            c.subroute_code,cir_get_name.cir_subroute(a.comp_code,a.unit,c.route_code,c.subroute_code,1,pdateformat,'','') subroute_name,
            c.sub_subroute_code,cir_get_name.cir_subsubroute(a.comp_code,a.unit,c.route_code,c.subroute_code,c.sub_subroute_code,1,pdateformat,'','') subsubroute_name,
            d.dist_name dist_name,nvl(p.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,c.supply_type_code supply_type_code,b.sup_ty_name supply_type_name,c.edtn edtn,e.edtn_name edtn_name,
            a.suspend suspend,c.publ publ,cir_get_publ_name(a.comp_code,c.publ) publ_name
            from cir_agmast_dis a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code=pcomp_code and p."comp_code"=pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit=punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ and (c.publ=ppubl_code or ppubl_code is null)  and c.edtn=e.edtn and c.edtn = nvl(pedtn_code,c.edtn) and e.main_edtn = nvl(pmedtn_code,e.main_edtn) and 
            a.agcd=c.agcd and a.agcd=nvl(pagcd_code,a.agcd) and a.dpcd=c.dpcd and a.dpcd=nvl(pdpcd_code,a.dpcd) and c.supply_type_code=nvl(psup_type,c.supply_type_code) and 
            (a.state_code=pstate or pstate is null) and
            (a.dist_code=pdistcode or pdistcode is null ) and (a.tehsil_taluka = ptaluka or ptaluka is null) and
            (a.city_code=pcitycode or pcitycode is null) and (a.branch_code = pbrancode or pbrancode is null) and
            (c.route_code=proutecode or proutecode is null) and nvl(c.supply_flag,'N') ='Y' and 
            ((nvl(a.suspend,'N')=nvl(pextra6,'N')) or (pextra6 is null)) and
            a.freeze_flag='N' and
            ((c.comm_code = pextra7) or (pextra7 is null)) and 
            (a.ag_type=pextra1 or pextra1 is null) and 
            (a.ag_class=pextra3 or pextra3 is null) 
            order by dist_name,agency_name,edtn_name,supply_type_name,supply_seq;
      else
          open p_circuls for
          select a.comp_code comp_code,a.unit unit,a.agcd agcd,a.dpcd dpcd,a.ag_name agency_name,a.ag_name_oth_lang agency_name_other_lang,a.city_code city_code,
            cir_get_city(a.comp_code,a.city_code) city_name,a.station_code drop_point_code,cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,'1') drop_point_name,
            nvl(c.base_supply,0) base_supply,nvl(c.supply_sun,0) supply_sun,nvl(c.supply_mon,0) supply_mon,nvl(c.supply_tue,0) supply_tue,nvl(c.supply_wed,0) supply_wed,
            nvl(c.supply_thu,0) supply_thu,nvl(c.supply_fri,0) supply_fri,nvl(c.supply_sat,0) supply_sat,nvl(c.supply_spl1,0) supply_spl1,nvl(c.supply_spl2,0) supply_spl2,
            c.lbl_printno supply_seq,cir_get_route_seqno(c.comp_code,c.unit,c.route_code) route_seq,
            c.route_code,cir_get_name.cir_route(a.comp_code,a.unit,c.route_code,1,pdateformat,'','') route_name, 
            c.subroute_code,cir_get_name.cir_subroute(a.comp_code,a.unit,c.route_code,c.subroute_code,1,pdateformat,'','') subroute_name,
            c.sub_subroute_code,cir_get_name.cir_subsubroute(a.comp_code,a.unit,c.route_code,c.subroute_code,c.sub_subroute_code,1,pdateformat,'','') subsubroute_name,
            d.dist_name dist_name,nvl(p.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,c.supply_type_code supply_type_code,b.sup_ty_name supply_type_name,c.edtn edtn,e.edtn_name edtn_name,
            a.suspend suspend,c.publ publ,cir_get_publ_name(a.comp_code,c.publ) publ_name
            from cir_agmast_dis a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code=pcomp_code and p."comp_code"=pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit=punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ and (c.publ=ppubl_code or  ppubl_code is null) and c.edtn=e.edtn and c.edtn = nvl(pedtn_code,c.edtn) and e.main_edtn = nvl(pmedtn_code,e.main_edtn) and 
            a.agcd=c.agcd and a.agcd=nvl(pagcd_code,a.agcd) and a.dpcd=c.dpcd and a.dpcd=nvl(pdpcd_code,a.dpcd) and c.supply_type_code=nvl(psup_type,c.supply_type_code) and 
            (a.state_code=pstate or pstate is null) and
            (a.dist_code=pdistcode or pdistcode is null ) and (a.tehsil_taluka = ptaluka or ptaluka is null) and
            (a.city_code=pcitycode or pcitycode is null) and (a.branch_code = pbrancode or pbrancode is null) and
            (c.route_code=proutecode or proutecode is null)  and nvl(c.supply_flag,'N') ='Y' and 
            ((nvl(a.suspend,'N')=nvl(pextra6,'N')) or (pextra6 is null)) and
            a.freeze_flag='N' and
            ((c.comm_code = pextra7) or (pextra7 is null)) and 
            (a.ag_type=pextra1 or pextra1 is null) and 
            (a.ag_class=pextra3 or pextra3 is null)
             order by route_seq,supply_seq,agency_name,edtn_name,supply_type_name;
      end if;
  else
      if psorted_by=2 then---for edition district and agency wise
          open p_circuls for
            select a.comp_code comp_code,a.unit unit,a.agcd agcd,a.dpcd dpcd,a.ag_name agency_name,a.ag_name_oth_lang agency_name_other_lang,a.city_code city_code,
            cir_get_city(a.comp_code,a.city_code) city_name,a.station_code drop_point_code,cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,'1') drop_point_name,
            nvl(c.base_supply,0) base_supply,nvl(c.supply_sun,0) supply_sun,nvl(c.supply_mon,0) supply_mon,nvl(c.supply_tue,0) supply_tue,nvl(c.supply_wed,0) supply_wed,
            nvl(c.supply_thu,0) supply_thu,nvl(c.supply_fri,0) supply_fri,nvl(c.supply_sat,0) supply_sat,nvl(c.supply_spl1,0) supply_spl1,nvl(c.supply_spl2,0) supply_spl2,
            c.lbl_printno supply_seq,cir_get_route_seqno(c.comp_code,c.unit,c.route_code) route_seq,
            c.route_code,cir_get_name.cir_route(a.comp_code,a.unit,c.route_code,1,pdateformat,'','') route_name, 
            c.subroute_code,cir_get_name.cir_subroute(a.comp_code,a.unit,c.route_code,c.subroute_code,1,pdateformat,'','') subroute_name,
            c.sub_subroute_code,cir_get_name.cir_subsubroute(a.comp_code,a.unit,c.route_code,c.subroute_code,c.sub_subroute_code,1,pdateformat,'','') subsubroute_name,
            d.dist_name dist_name,nvl(p.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,c.supply_type_code supply_type_code,b.sup_ty_name supply_type_name,c.edtn edtn,e.edtn_name edtn_name,
            a.suspend suspend,c.publ publ,cir_get_publ_name(a.comp_code,c.publ) publ_name
            from cir_agmast a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,
            --left outer join cir_city_mast m on a.comp_code=m.comp_code and a.city_code=m.city_code,
            cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code=pcomp_code and p."comp_code"=pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit=punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ
             and 
             (c.publ=ppubl_code or ppubl_code is null)
            and c.edtn=e.edtn and c.edtn = nvl(pedtn_code,c.edtn) and e.main_edtn = nvl(pmedtn_code,e.main_edtn) and 
            a.agcd=c.agcd and a.agcd=nvl(pagcd_code,a.agcd) and a.dpcd=c.dpcd and a.dpcd=nvl(pdpcd_code,a.dpcd) and c.supply_type_code=nvl(psup_type,c.supply_type_code) and 
            (a.state_code=pstate or pstate is null) and
            (a.dist_code=pdistcode or pdistcode is null ) and (a.tehsil_taluka = ptaluka or ptaluka is null) and
            (a.city_code=pcitycode or pcitycode is null) and (a.branch_code = pbrancode or pbrancode is null) and
            (c.route_code=proutecode or proutecode is null) and nvl(c.supply_flag,'N') ='Y' and 
            ((nvl(a.suspend,'N')=nvl(pextra6,'N')) or (pextra6 is null)) and
            a.freeze_flag='N' and
            ((c.comm_code = pextra7) or (pextra7 is null)) and 
            (a.ag_type=pextra1 or pextra1 is null) and 
            (a.ag_class=pextra3 or pextra3 is null)
            order by dist_name,agency_name,edtn_name,supply_type_name,supply_seq;
      else
          open p_circuls for
          select a.comp_code comp_code,a.unit unit,a.agcd agcd,a.dpcd dpcd,a.ag_name agency_name,a.ag_name_oth_lang agency_name_other_lang,a.city_code city_code,
            cir_get_city(a.comp_code,a.city_code) city_name,a.station_code drop_point_code,cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,'1') drop_point_name,
            nvl(c.base_supply,0) base_supply,nvl(c.supply_sun,0) supply_sun,nvl(c.supply_mon,0) supply_mon,nvl(c.supply_tue,0) supply_tue,nvl(c.supply_wed,0) supply_wed,
            nvl(c.supply_thu,0) supply_thu,nvl(c.supply_fri,0) supply_fri,nvl(c.supply_sat,0) supply_sat,nvl(c.supply_spl1,0) supply_spl1,nvl(c.supply_spl2,0) supply_spl2,
            c.lbl_printno supply_seq,cir_get_route_seqno(c.comp_code,c.unit,c.route_code) route_seq,
            c.route_code,cir_get_name.cir_route(a.comp_code,a.unit,c.route_code,1,pdateformat,'','') route_name, 
            c.subroute_code,cir_get_name.cir_subroute(a.comp_code,a.unit,c.route_code,c.subroute_code,1,pdateformat,'','') subroute_name,
            c.sub_subroute_code,cir_get_name.cir_subsubroute(a.comp_code,a.unit,c.route_code,c.subroute_code,c.sub_subroute_code,1,pdateformat,'','') subsubroute_name,
            d.dist_name dist_name,nvl(p.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,c.supply_type_code supply_type_code,b.sup_ty_name supply_type_name,c.edtn edtn,e.edtn_name edtn_name,
            a.suspend suspend,c.publ publ,cir_get_publ_name(a.comp_code,c.publ) publ_name
            from cir_agmast a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code=pcomp_code and p."comp_code"=pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit=punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ and 
            (c.publ=ppubl_code or ppubl_code is null)
            and c.edtn=e.edtn and c.edtn = nvl(pedtn_code,c.edtn) and e.main_edtn = nvl(pmedtn_code,e.main_edtn) and 
            a.agcd=c.agcd and a.agcd=nvl(pagcd_code,a.agcd) and a.dpcd=c.dpcd and a.dpcd=nvl(pdpcd_code,a.dpcd) and c.supply_type_code=nvl(psup_type,c.supply_type_code) and 
            (a.state_code=pstate or pstate is null) and
            (a.dist_code=pdistcode or pdistcode is null) 
            and (a.tehsil_taluka = ptaluka or ptaluka is null) and
            (a.city_code=pcitycode or pcitycode is null) and (a.branch_code = pbrancode or pbrancode is null) and
            (c.route_code=proutecode or proutecode is null)  and nvl(c.supply_flag,'N') ='Y' and
            ((nvl(a.suspend,'N')=nvl(pextra6,'N')) or (pextra6 is null)) and
            a.freeze_flag='N' and
            ((c.comm_code = pextra7) or (pextra7 is null)) and 
            (a.ag_type=pextra1 or pextra1 is null) and 
            (a.ag_class=pextra3 or pextra3 is null)
             order by route_seq,supply_seq,agency_name,edtn_name,supply_type_name;
      end if;
   end if;
 End cir_supply_alteration_p;
procedure cir_supply_unsold_return_p(
      pcomp_code        in varchar2,
      punit_code        in varchar2,
      ppubl_code        in varchar2,
      pedtn_code        in varchar2,
      pagcd_code        in varchar2,
      pdpcd_code        in varchar2,
      pfromdate         in varchar2,
      ptilldate         in varchar2,
      preturn_type      in varchar2,--it is for on return date received or supply date
      pdateformat       in varchar2,
      pextra1           in varchar2,
      pextra2           in varchar2,
      pextra3           in varchar2,
      pextra4           in varchar2,
      pextra5           in varchar2,      
      p_circuls         out T_Circul_Cursor)
As
    v_frdt date;
    v_todt date;
Begin
    v_frdt :=to_date(pfromdate,''''||pdateformat||'''');
    v_todt :=to_date(ptilldate,''''||pdateformat||'''');
    
    if preturn_type='R' then
        open p_circuls for
        select u.supdate supdate,nvl(u.supply_copy,0) supply_copy,
        (nvl(u.apr_bnr,0)+nvl(u.apr_late_recpt,0)+nvl(u.apr_short_recpt,0)+nvl(u.apr_unsold,0)) return_copy 
        from cir_agmast m,cir_unsold_dtl u 
        where m.comp_code=u.comp_code and m.comp_code=pcomp_code and m.unit=punit_code and m.unit=u.unit_code and 
        doctype='UCN' and recptdt >= v_frdt and recptdt <=v_todt and m.bill_agcd=u.agcd and m.bill_dpcd=u.dpcd and 
        m.agcd=nvl(pagcd_code,m.agcd) and m.dpcd=nvl(pdpcd_code,m.dpcd) and u.publ=ppubl_code and u.edtn=pedtn_code and
        (nvl(u.apr_bnr,0)+nvl(u.apr_late_recpt,0)+nvl(u.apr_short_recpt,0)+nvl(u.apr_unsold,0))>0
        union
        select u.supdate supdate,nvl(u.supply_copy,0) supply_copy,
        (nvl(u.bnr,0)+nvl(u.late_recpt,0)+nvl(u.short_recpt,0)+nvl(u.unsold,0)) return_copy 
        from cir_agmast m,cir_unsold_dtl u 
        where m.comp_code=u.comp_code and m.comp_code=pcomp_code and m.unit=punit_code and m.unit=u.unit_code and 
        doctype='UCN' and recptdt >= v_frdt and recptdt <=v_todt and m.bill_agcd=u.agcd and m.bill_dpcd=u.dpcd and 
        m.agcd=nvl(pagcd_code,m.agcd) and m.dpcd=nvl(pdpcd_code,m.dpcd) and u.publ=ppubl_code and u.edtn=pedtn_code and
        (nvl(u.apr_bnr,0)+nvl(u.apr_late_recpt,0)+nvl(u.apr_short_recpt,0)+nvl(u.apr_unsold,0))=0
        order by supdate;
    else
        open p_circuls for
        select u.supdate supdate,nvl(u.supply_copy,0) supply_copy,
        (nvl(u.apr_bnr,0)+nvl(u.apr_late_recpt,0)+nvl(u.apr_short_recpt,0)+nvl(u.apr_unsold,0)) return_copy 
        from cir_agmast m,cir_unsold_dtl u 
        where m.comp_code=u.comp_code and m.comp_code=pcomp_code and m.unit=punit_code and m.unit=u.unit_code and 
        doctype='UCN' and supdate >= v_frdt and supdate <=v_todt and m.bill_agcd=u.agcd and m.bill_dpcd=u.dpcd and 
        m.agcd=nvl(pagcd_code,m.agcd) and m.dpcd=nvl(pdpcd_code,m.dpcd) and u.publ=ppubl_code and u.edtn=pedtn_code and 
        (nvl(u.apr_bnr,0)+nvl(u.apr_late_recpt,0)+nvl(u.apr_short_recpt,0)+nvl(u.apr_unsold,0))>0
        union
        select u.supdate supdate,nvl(u.supply_copy,0) supply_copy,
        (nvl(u.bnr,0)+nvl(u.late_recpt,0)+nvl(u.short_recpt,0)+nvl(u.unsold,0)) return_copy 
        from cir_agmast m,cir_unsold_dtl u 
        where m.comp_code=u.comp_code and m.comp_code=pcomp_code and m.unit=punit_code and m.unit=u.unit_code and 
        doctype='UCN' and supdate >= v_frdt and supdate <=v_todt and m.bill_agcd=u.agcd and m.bill_dpcd=u.dpcd and 
        m.agcd=nvl(pagcd_code,m.agcd) and m.dpcd=nvl(pdpcd_code,m.dpcd) and u.publ=ppubl_code and u.edtn=pedtn_code and
        (nvl(u.apr_bnr,0)+nvl(u.apr_late_recpt,0)+nvl(u.apr_short_recpt,0)+nvl(u.apr_unsold,0))=0        
        order by supdate;    
    end if;    

End cir_supply_unsold_return_p; 
END cir_supply_alteration;
/

////////////////////////////////////////////////////////

////////////////////garima
//cir_supply_alteration.cir_supply_alteration_p

CREATE OR REPLACE PACKAGE cir_supply_alteration IS
  TYPE T_Circul_Cursor is Ref Cursor;
  procedure cir_supply_alteration_p(
      pcomp_code        in varchar2,
      punit_code        in varchar2,
      ppubl_code        in varchar2,
      pmedtn_code       in varchar2,
      pedtn_code        in varchar2,
      psup_type         in varchar2,
      pstate            in varchar2,
      pdistcode         in varchar2,
      ptaluka           in varchar2,
      pcitycode         in varchar2,
      pbrancode         in varchar2,
      proutecode        in varchar2,
      pagcd_code        in varchar2,
      pdpcd_code        in varchar2,
      psorted_by        in varchar2,--1 for  edition route wise,2 for edition district wise
      pdateformat       in varchar2,
      puserid           in varchar2,--for login user id
      pextra1           in varchar2,--agency type
      pextra2           in varchar2,--for agency--A and distribution--D
      pextra3           in varchar2,--agency class
      pextra4           in varchar2,--for zone
      pextra5           in varchar2,--for region
      pextra6           in varchar2,
      pextra7           in varchar2,
      pextra8           in varchar2,
      pextra9           in varchar2,
      pextra10          in varchar2,      
      p_circuls         out T_Circul_Cursor);
  procedure cir_supply_unsold_return_p(
      pcomp_code        in varchar2,
      punit_code        in varchar2,
      ppubl_code        in varchar2,
      pedtn_code        in varchar2,
      pagcd_code        in varchar2,
      pdpcd_code        in varchar2,
      pfromdate         in varchar2,
      ptilldate         in varchar2,
      preturn_type      in varchar2,
      pdateformat       in varchar2,
      pextra1           in varchar2,
      pextra2           in varchar2,
      pextra3           in varchar2,
      pextra4           in varchar2,
      pextra5           in varchar2,      
      p_circuls         out T_Circul_Cursor);      
END cir_supply_alteration;
/
CREATE OR REPLACE PACKAGE BODY cir_supply_alteration IS
  procedure cir_supply_alteration_p(
      pcomp_code        in varchar2,
      punit_code        in varchar2,
      ppubl_code        in varchar2,
      pmedtn_code       in varchar2,
      pedtn_code        in varchar2,
      psup_type         in varchar2,
      pstate            in varchar2,
      pdistcode         in varchar2,
      ptaluka           in varchar2,
      pcitycode         in varchar2,
      pbrancode         in varchar2,
      proutecode        in varchar2,
      pagcd_code        in varchar2,
      pdpcd_code        in varchar2,
      psorted_by        in varchar2,--1 for  edition route wise,2 for edition district wise
      pdateformat       in varchar2,
      puserid           in varchar2,--for login user id
      pextra1           in varchar2,--agency type
      pextra2           in varchar2,--for agency--A and distribution--D
      pextra3           in varchar2,--agency class
      pextra4           in varchar2,--for zone
      pextra5           in varchar2,--for region
      pextra6           in varchar2,--for suspend Y/N
      pextra7           in varchar2,--for commition category
      pextra8           in varchar2,
      pextra9           in varchar2,
      pextra10          in varchar2,      
      p_circuls         out T_Circul_Cursor)
 As

 Begin
  if upper(pextra2)='D' then
      if psorted_by=2 then---for edition district and agency wise
          open p_circuls for
            select a.comp_code comp_code,a.unit unit,a.agcd agcd,a.dpcd dpcd,a.ag_name agency_name,a.ag_name_oth_lang agency_name_other_lang,a.city_code city_code,
            cir_get_city(a.comp_code,a.city_code) city_name,a.station_code drop_point_code,cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,'1') drop_point_name,
            nvl(c.base_supply,0) base_supply,nvl(c.supply_sun,0) supply_sun,nvl(c.supply_mon,0) supply_mon,nvl(c.supply_tue,0) supply_tue,nvl(c.supply_wed,0) supply_wed,
            nvl(c.supply_thu,0) supply_thu,nvl(c.supply_fri,0) supply_fri,nvl(c.supply_sat,0) supply_sat,nvl(c.supply_spl1,0) supply_spl1,nvl(c.supply_spl2,0) supply_spl2,
            c.lbl_printno supply_seq,cir_get_route_seqno(c.comp_code,c.unit,c.route_code) route_seq,
            c.route_code,cir_get_name.cir_route(a.comp_code,a.unit,c.route_code,1,pdateformat,'','') route_name, 
            c.subroute_code,cir_get_name.cir_subroute(a.comp_code,a.unit,c.route_code,c.subroute_code,1,pdateformat,'','') subroute_name,
            c.sub_subroute_code,cir_get_name.cir_subsubroute(a.comp_code,a.unit,c.route_code,c.subroute_code,c.sub_subroute_code,1,pdateformat,'','') subsubroute_name,
            d.dist_name dist_name,nvl(p.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,c.supply_type_code supply_type_code,b.sup_ty_name supply_type_name,c.edtn edtn,e.edtn_name edtn_name,
            a.suspend suspend,c.publ publ,cir_get_publ_name(a.comp_code,c.publ) publ_name
            from cir_agmast_dis a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code=pcomp_code and p."comp_code"=pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit=punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ and c.publ=ppubl_code and c.edtn=e.edtn and c.edtn = nvl(pedtn_code,c.edtn) and e.main_edtn = nvl(pmedtn_code,e.main_edtn) and 
            a.agcd=c.agcd and a.agcd=nvl(pagcd_code,a.agcd) and a.dpcd=c.dpcd and a.dpcd=nvl(pdpcd_code,a.dpcd) and c.supply_type_code=nvl(psup_type,c.supply_type_code) and 
            (a.state_code=pstate or pstate is null) and
            (a.dist_code=pdistcode or pdistcode is null ) and (a.tehsil_taluka = ptaluka or ptaluka is null) and
            (a.city_code=pcitycode or pcitycode is null) and (a.branch_code = pbrancode or pbrancode is null) and
            (c.route_code=proutecode or proutecode is null) and nvl(c.supply_flag,'N') ='Y' and 
            ((nvl(a.suspend,'N')=nvl(pextra6,'N')) or (pextra6 is null)) and
            a.freeze_flag='N' and
            ((c.comm_code = pextra7) or (pextra7 is null)) and 
            (a.ag_type=pextra1 or pextra1 is null) and 
            (a.ag_class=pextra3 or pextra3 is null) 
            order by dist_name,agency_name,edtn_name,supply_type_name,supply_seq;
      else
          open p_circuls for
          select a.comp_code comp_code,a.unit unit,a.agcd agcd,a.dpcd dpcd,a.ag_name agency_name,a.ag_name_oth_lang agency_name_other_lang,a.city_code city_code,
            cir_get_city(a.comp_code,a.city_code) city_name,a.station_code drop_point_code,cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,'1') drop_point_name,
            nvl(c.base_supply,0) base_supply,nvl(c.supply_sun,0) supply_sun,nvl(c.supply_mon,0) supply_mon,nvl(c.supply_tue,0) supply_tue,nvl(c.supply_wed,0) supply_wed,
            nvl(c.supply_thu,0) supply_thu,nvl(c.supply_fri,0) supply_fri,nvl(c.supply_sat,0) supply_sat,nvl(c.supply_spl1,0) supply_spl1,nvl(c.supply_spl2,0) supply_spl2,
            c.lbl_printno supply_seq,cir_get_route_seqno(c.comp_code,c.unit,c.route_code) route_seq,
            c.route_code,cir_get_name.cir_route(a.comp_code,a.unit,c.route_code,1,pdateformat,'','') route_name, 
            c.subroute_code,cir_get_name.cir_subroute(a.comp_code,a.unit,c.route_code,c.subroute_code,1,pdateformat,'','') subroute_name,
            c.sub_subroute_code,cir_get_name.cir_subsubroute(a.comp_code,a.unit,c.route_code,c.subroute_code,c.sub_subroute_code,1,pdateformat,'','') subsubroute_name,
            d.dist_name dist_name,nvl(p.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,c.supply_type_code supply_type_code,b.sup_ty_name supply_type_name,c.edtn edtn,e.edtn_name edtn_name,
            a.suspend suspend,c.publ publ,cir_get_publ_name(a.comp_code,c.publ) publ_name
            from cir_agmast_dis a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code=pcomp_code and p."comp_code"=pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit=punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ and c.publ=ppubl_code and c.edtn=e.edtn and c.edtn = nvl(pedtn_code,c.edtn) and e.main_edtn = nvl(pmedtn_code,e.main_edtn) and 
            a.agcd=c.agcd and a.agcd=nvl(pagcd_code,a.agcd) and a.dpcd=c.dpcd and a.dpcd=nvl(pdpcd_code,a.dpcd) and c.supply_type_code=nvl(psup_type,c.supply_type_code) and 
            (a.state_code=pstate or pstate is null) and
            (a.dist_code=pdistcode or pdistcode is null ) and (a.tehsil_taluka = ptaluka or ptaluka is null) and
            (a.city_code=pcitycode or pcitycode is null) and (a.branch_code = pbrancode or pbrancode is null) and
            (c.route_code=proutecode or proutecode is null)  and nvl(c.supply_flag,'N') ='Y' and 
            ((nvl(a.suspend,'N')=nvl(pextra6,'N')) or (pextra6 is null)) and
            a.freeze_flag='N' and
            ((c.comm_code = pextra7) or (pextra7 is null)) and 
            (a.ag_type=pextra1 or pextra1 is null) and 
            (a.ag_class=pextra3 or pextra3 is null)
             order by route_seq,supply_seq,agency_name,edtn_name,supply_type_name;
      end if;
  else
      if psorted_by=2 then---for edition district and agency wise
          open p_circuls for
            select a.comp_code comp_code,a.unit unit,a.agcd agcd,a.dpcd dpcd,a.ag_name agency_name,a.ag_name_oth_lang agency_name_other_lang,a.city_code city_code,
            cir_get_city(a.comp_code,a.city_code) city_name,a.station_code drop_point_code,cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,'1') drop_point_name,
            nvl(c.base_supply,0) base_supply,nvl(c.supply_sun,0) supply_sun,nvl(c.supply_mon,0) supply_mon,nvl(c.supply_tue,0) supply_tue,nvl(c.supply_wed,0) supply_wed,
            nvl(c.supply_thu,0) supply_thu,nvl(c.supply_fri,0) supply_fri,nvl(c.supply_sat,0) supply_sat,nvl(c.supply_spl1,0) supply_spl1,nvl(c.supply_spl2,0) supply_spl2,
            c.lbl_printno supply_seq,cir_get_route_seqno(c.comp_code,c.unit,c.route_code) route_seq,
            c.route_code,cir_get_name.cir_route(a.comp_code,a.unit,c.route_code,1,pdateformat,'','') route_name, 
            c.subroute_code,cir_get_name.cir_subroute(a.comp_code,a.unit,c.route_code,c.subroute_code,1,pdateformat,'','') subroute_name,
            c.sub_subroute_code,cir_get_name.cir_subsubroute(a.comp_code,a.unit,c.route_code,c.subroute_code,c.sub_subroute_code,1,pdateformat,'','') subsubroute_name,
            d.dist_name dist_name,nvl(p.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,c.supply_type_code supply_type_code,b.sup_ty_name supply_type_name,c.edtn edtn,e.edtn_name edtn_name,
            a.suspend suspend,c.publ publ,cir_get_publ_name(a.comp_code,c.publ) publ_name
            from cir_agmast a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,
            --left outer join cir_city_mast m on a.comp_code=m.comp_code and a.city_code=m.city_code,
            cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code=pcomp_code and p."comp_code"=pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit=punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ and c.publ=ppubl_code and c.edtn=e.edtn and c.edtn = nvl(pedtn_code,c.edtn) and e.main_edtn = nvl(pmedtn_code,e.main_edtn) and 
            a.agcd=c.agcd and a.agcd=nvl(pagcd_code,a.agcd) and a.dpcd=c.dpcd and a.dpcd=nvl(pdpcd_code,a.dpcd) and c.supply_type_code=nvl(psup_type,c.supply_type_code) and 
            (a.state_code=pstate or pstate is null) and
            (a.dist_code=pdistcode or pdistcode is null ) and (a.tehsil_taluka = ptaluka or ptaluka is null) and
            (a.city_code=pcitycode or pcitycode is null) and (a.branch_code = pbrancode or pbrancode is null) and
            (c.route_code=proutecode or proutecode is null) and nvl(c.supply_flag,'N') ='Y' and 
            ((nvl(a.suspend,'N')=nvl(pextra6,'N')) or (pextra6 is null)) and
            a.freeze_flag='N' and
            ((c.comm_code = pextra7) or (pextra7 is null)) and 
            (a.ag_type=pextra1 or pextra1 is null) and 
            (a.ag_class=pextra3 or pextra3 is null)
            order by dist_name,agency_name,edtn_name,supply_type_name,supply_seq;
      else
          open p_circuls for
          select a.comp_code comp_code,a.unit unit,a.agcd agcd,a.dpcd dpcd,a.ag_name agency_name,a.ag_name_oth_lang agency_name_other_lang,a.city_code city_code,
            cir_get_city(a.comp_code,a.city_code) city_name,a.station_code drop_point_code,cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,'1') drop_point_name,
            nvl(c.base_supply,0) base_supply,nvl(c.supply_sun,0) supply_sun,nvl(c.supply_mon,0) supply_mon,nvl(c.supply_tue,0) supply_tue,nvl(c.supply_wed,0) supply_wed,
            nvl(c.supply_thu,0) supply_thu,nvl(c.supply_fri,0) supply_fri,nvl(c.supply_sat,0) supply_sat,nvl(c.supply_spl1,0) supply_spl1,nvl(c.supply_spl2,0) supply_spl2,
            c.lbl_printno supply_seq,cir_get_route_seqno(c.comp_code,c.unit,c.route_code) route_seq,
            c.route_code,cir_get_name.cir_route(a.comp_code,a.unit,c.route_code,1,pdateformat,'','') route_name, 
            c.subroute_code,cir_get_name.cir_subroute(a.comp_code,a.unit,c.route_code,c.subroute_code,1,pdateformat,'','') subroute_name,
            c.sub_subroute_code,cir_get_name.cir_subsubroute(a.comp_code,a.unit,c.route_code,c.subroute_code,c.sub_subroute_code,1,pdateformat,'','') subsubroute_name,
            d.dist_name dist_name,nvl(p.CIR_SUP_ORDER_LIMIT,0) CIR_SUP_ORDER_LIMIT,c.supply_type_code supply_type_code,b.sup_ty_name supply_type_name,c.edtn edtn,e.edtn_name edtn_name,
            a.suspend suspend,c.publ publ,cir_get_publ_name(a.comp_code,c.publ) publ_name
            from cir_agmast a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,cir_supply_type_mast b,cir_supply c,cir_edtn_mast e,preferrences p
            where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=e.comp_code and  a.comp_code=pcomp_code and p."comp_code"=pcomp_code and
            a.unit=c.unit and a.unit=e.unit_code and a.unit=punit_code and b.sup_ty_code=c.supply_type_code and
            c.publ=e.publ and c.publ=ppubl_code and c.edtn=e.edtn and c.edtn = nvl(pedtn_code,c.edtn) and e.main_edtn = nvl(pmedtn_code,e.main_edtn) and 
            a.agcd=c.agcd and a.agcd=nvl(pagcd_code,a.agcd) and a.dpcd=c.dpcd and a.dpcd=nvl(pdpcd_code,a.dpcd) and c.supply_type_code=nvl(psup_type,c.supply_type_code) and 
            (a.state_code=pstate or pstate is null) and
            (a.dist_code=pdistcode or pdistcode is null) and (a.tehsil_taluka = ptaluka or ptaluka is null) and
            (a.city_code=pcitycode or pcitycode is null) and (a.branch_code = pbrancode or pbrancode is null) and
            (c.route_code=proutecode or proutecode is null)  and nvl(c.supply_flag,'N') ='Y' and
            ((nvl(a.suspend,'N')=nvl(pextra6,'N')) or (pextra6 is null)) and
            a.freeze_flag='N' and
            ((c.comm_code = pextra7) or (pextra7 is null)) and 
            (a.ag_type=pextra1 or pextra1 is null) and 
            (a.ag_class=pextra3 or pextra3 is null)
             order by route_seq,supply_seq,agency_name,edtn_name,supply_type_name;
      end if;
   end if;
 End cir_supply_alteration_p;
procedure cir_supply_unsold_return_p(
      pcomp_code        in varchar2,
      punit_code        in varchar2,
      ppubl_code        in varchar2,
      pedtn_code        in varchar2,
      pagcd_code        in varchar2,
      pdpcd_code        in varchar2,
      pfromdate         in varchar2,
      ptilldate         in varchar2,
      preturn_type      in varchar2,--it is for on return date received or supply date
      pdateformat       in varchar2,
      pextra1           in varchar2,
      pextra2           in varchar2,
      pextra3           in varchar2,
      pextra4           in varchar2,
      pextra5           in varchar2,      
      p_circuls         out T_Circul_Cursor)
As
    v_frdt date;
    v_todt date;
Begin
    v_frdt :=to_date(pfromdate,''''||pdateformat||'''');
    v_todt :=to_date(ptilldate,''''||pdateformat||'''');
    
    if preturn_type='R' then
        open p_circuls for
        select u.supdate supdate,nvl(u.supply_copy,0) supply_copy,
        (nvl(u.apr_bnr,0)+nvl(u.apr_late_recpt,0)+nvl(u.apr_short_recpt,0)+nvl(u.apr_unsold,0)) return_copy 
        from cir_agmast m,cir_unsold_dtl u 
        where m.comp_code=u.comp_code and m.comp_code=pcomp_code and m.unit=punit_code and m.unit=u.unit_code and 
        doctype='UCN' and recptdt >= v_frdt and recptdt <=v_todt and m.bill_agcd=u.agcd and m.bill_dpcd=u.dpcd and 
        m.agcd=nvl(pagcd_code,m.agcd) and m.dpcd=nvl(pdpcd_code,m.dpcd) and u.publ=ppubl_code and u.edtn=pedtn_code and
        (nvl(u.apr_bnr,0)+nvl(u.apr_late_recpt,0)+nvl(u.apr_short_recpt,0)+nvl(u.apr_unsold,0))>0
        union
        select u.supdate supdate,nvl(u.supply_copy,0) supply_copy,
        (nvl(u.bnr,0)+nvl(u.late_recpt,0)+nvl(u.short_recpt,0)+nvl(u.unsold,0)) return_copy 
        from cir_agmast m,cir_unsold_dtl u 
        where m.comp_code=u.comp_code and m.comp_code=pcomp_code and m.unit=punit_code and m.unit=u.unit_code and 
        doctype='UCN' and recptdt >= v_frdt and recptdt <=v_todt and m.bill_agcd=u.agcd and m.bill_dpcd=u.dpcd and 
        m.agcd=nvl(pagcd_code,m.agcd) and m.dpcd=nvl(pdpcd_code,m.dpcd) and u.publ=ppubl_code and u.edtn=pedtn_code and
        (nvl(u.apr_bnr,0)+nvl(u.apr_late_recpt,0)+nvl(u.apr_short_recpt,0)+nvl(u.apr_unsold,0))=0
        order by supdate;
    else
        open p_circuls for
        select u.supdate supdate,nvl(u.supply_copy,0) supply_copy,
        (nvl(u.apr_bnr,0)+nvl(u.apr_late_recpt,0)+nvl(u.apr_short_recpt,0)+nvl(u.apr_unsold,0)) return_copy 
        from cir_agmast m,cir_unsold_dtl u 
        where m.comp_code=u.comp_code and m.comp_code=pcomp_code and m.unit=punit_code and m.unit=u.unit_code and 
        doctype='UCN' and supdate >= v_frdt and supdate <=v_todt and m.bill_agcd=u.agcd and m.bill_dpcd=u.dpcd and 
        m.agcd=nvl(pagcd_code,m.agcd) and m.dpcd=nvl(pdpcd_code,m.dpcd) and u.publ=ppubl_code and u.edtn=pedtn_code and 
        (nvl(u.apr_bnr,0)+nvl(u.apr_late_recpt,0)+nvl(u.apr_short_recpt,0)+nvl(u.apr_unsold,0))>0
        union
        select u.supdate supdate,nvl(u.supply_copy,0) supply_copy,
        (nvl(u.bnr,0)+nvl(u.late_recpt,0)+nvl(u.short_recpt,0)+nvl(u.unsold,0)) return_copy 
        from cir_agmast m,cir_unsold_dtl u 
        where m.comp_code=u.comp_code and m.comp_code=pcomp_code and m.unit=punit_code and m.unit=u.unit_code and 
        doctype='UCN' and supdate >= v_frdt and supdate <=v_todt and m.bill_agcd=u.agcd and m.bill_dpcd=u.dpcd and 
        m.agcd=nvl(pagcd_code,m.agcd) and m.dpcd=nvl(pdpcd_code,m.dpcd) and u.publ=ppubl_code and u.edtn=pedtn_code and
        (nvl(u.apr_bnr,0)+nvl(u.apr_late_recpt,0)+nvl(u.apr_short_recpt,0)+nvl(u.apr_unsold,0))=0        
        order by supdate;    
    end if;    

End cir_supply_unsold_return_p; 
END cir_supply_alteration;
/

/***********************mimoh 28dec 2011*********6162****************************************/


CREATE OR REPLACE PACKAGE Currbindpreferpgld
IS
   TYPE t_account_cursor IS REF CURSOR;

   PROCEDURE currbindpreferpgld_p (
      compcode     IN       VARCHAR2,
      p_accounts   OUT      t_account_cursor
   );
END Currbindpreferpgld;
/





CREATE OR REPLACE PACKAGE BODY Currbindpreferpgld
IS
   PROCEDURE currbindpreferpgld_p (
      compcode     IN       VARCHAR2,
      p_accounts   OUT      t_account_cursor
   )
   AS
   BEGIN
      OPEN p_accounts FOR
         SELECT "date_format", "autogenerated", "currency_code",
                "rate_gr_code", "solo", "breakup", "blackwhitecode",
                "rostatus", "File_name", "Tfn", "Insert_breakup", "prefix",
                "suffix", "financestatus", "voucherst", "Ad_category",
                "Ro_datetime", "Vat", "Booking_status", "Cio_id",
                "Receipt_no","uom_code","Bgcolor_publication","chkfor_valid_pubdates","Agency_ratecode","audit","book_insert_date","agencycomm",
                "rate_audit","bill_audit","billtype","Premium_type","copy_booking","RATE_COMPANY_AGENCY","ADDITIONAL_AGENCY_COMM","AGENCY_RETAINER_COMM","SUBEDITIONRATE",CLS_BILLTYPE,DIS_BILLTYPE,
                "BILLING_FORMAT","RATE_CHECK","ALL_PACKAGE",dayrate,SCHEME_TYPE,DISP_CLSBILL,RECEIPT_FORMAT,CASH_RECEIPT_BILL, BILL_ORDERWSLAST, FLOOR_CHK,
                ROKEYCHECK, AGENCYCOMM_SEQ_COM, CREDIT_RECIPT,  DISP_CASHBILL, CLA_CASHBILL,
                RATE_AUDIT_PREF,BARCODING_ALLOWED, FMG_BILL_DIS,BILL_DISP_CASHBILL, BILL_CLA_CASHBILL,BACKDATERECEIPT,ROWISE_CASHBOOKING,CUTOFFTIME,DOCKIT_BOOKING,APPROVAL,BACK_DAYS,CASH_DISCOUNT,CASH_DISCOUNTTYPE,"Allowed_old_date",SEPRATE_CASHIER,
                CIR_MANY_TIME_POSTING, CIR_BACKDAYS_POSTING, CIR_MAX_RETURN_ALLOW, CIR_RETURN_LIMIT_ALLOW, CIR_NO_OF_CHQBOUNCE, CIR_DAYS_CHQBOUNCE, CIR_RETURN_DAYS, CIR_SUP_ORDER_LIMIT, DISP_BILLING_CRITERIA, CLSD_BILLING_CRITERIA,MAX_PUBLISHDAYS,
                BILLNO_PERIODICITY, SPECIALDISC_TRANS_EDIT, SHARING_TRANS, MULTIPACKAGE_SEL_TRANS,SCHEME_MINWORD, TRADE_SPLCHARGE,RATE_AUTHORIZATION,
           F2_RECORD,PUBLISHAD_EDIT_RATEAUDIT,BINDREVENUE_CENTER, FA_LEDGER_ALLOW,CLEARANCE_TYPE_ALLOW,REPEAT_DAY_TYPE,PREMIUM_EDIT,
           
           BILL_GENERATION_PRIOR,PUBLICATION_HO,SPLDISC_ALLOWPREM,BILL_SCHEME,ALLOWED_PDC_DAYS_RECEIPT,
           AD_TYPE_MANUL_BILL,OUTSTANDING_AMT_CRITERIA as RO_OUTSTAND,GENRATE_CIR_AGCD,DISP_AUDITBKG,CIR_DIS_AUTO_POSTING,RELAUTHREQON,
        CIR_AUTO_APPROVAL_UNSOLD, CIR_AUTO_PHYSICAL_UNSOLD, CIR_UNSOLD_INCLUDE_INCT, CIR_UNSOLD_INCLUDE_INSFEE, CIR_UNSOLD_ON_RECEIVED_DT,
        AGENCY_UNBLOCK_APPROVAL,UNBLOCK_APPROVAL_OUTSIDE_LIMIT,CIR_BILL_PUBLWISE ,RECORDS_ON_PAGE,RECORDS_ON_PRINT,HEADER_ON_PAGE,AGENCY_REQUIRED,REGION_REQUIRED,ALLOW_FOLLOW_DT_BOOOK,CRM_SUPPLY_TYPE_PAID,CRM_SUPPLY_TYPE_FREE,CURRENCY_MEASUREMENT  
            FROM PREFERRENCES
          WHERE "comp_code" = compcode;
          
         
   END currbindpreferpgld_p;
END Currbindpreferpgld;
/

/******************************************************************/



CREATE OR REPLACE PACKAGE Wesp_Updatedate
IS
PROCEDURE      Wesp_Updatedate_p(
compcode IN VARCHAR2,
userid IN VARCHAR2,
dateformat IN VARCHAR2,
code IN VARCHAR2,
curr IN VARCHAR2,
RATECODE11 IN VARCHAR2,
solo  IN VARCHAR2,
breakup VARCHAR2,
bwcode IN VARCHAR2,
rostatus IN VARCHAR2,
filename IN VARCHAR2,
tfn IN NUMBER,
insertbreak IN VARCHAR2,
prem IN VARCHAR2,
dealtype IN VARCHAR2,
pre IN VARCHAR2,
suff IN VARCHAR2,
financestatus IN  VARCHAR2,
voucherst IN VARCHAR2,
adcode IN VARCHAR2,
rodatetime IN VARCHAR2,
spacearea IN VARCHAR2,
vat IN VARCHAR2,
bookstat IN VARCHAR2,
cio_id IN VARCHAR2,
receipt_no IN VARCHAR2,
uom IN VARCHAR2,
bgcolor IN VARCHAR2,
validdate IN VARCHAR2,
agencyratecode IN VARCHAR2,
AUDIT1 IN VARCHAR2,
book_insert_date IN VARCHAR2,
agencycomm IN VARCHAR2,
rateaudit IN VARCHAR2,
billaudit IN VARCHAR2,
bill_type IN VARCHAR2,
invoice_no1 IN VARCHAR2,
copybooking IN VARCHAR2,
ratecompany IN VARCHAR2,
addagenycomm IN VARCHAR2,
agencycommlinkretainer IN VARCHAR2,
subeditionr IN VARCHAR2,
displaybilltype IN VARCHAR2,
classifiedbilltype IN VARCHAR2,
billformat IN VARCHAR2,
ratechk IN VARCHAR2,
allpkg IN VARCHAR2,
dayrate1 in varchar2,
schemetype in varchar2,
PIncludeclassi in varchar2,
receiptformat IN VARCHAR2,
v_cash_receipt in varchar2,
v_bill_orderwiselast in varchar2,
v_floor_chk in varchar2,
Unsoldflag in varchar2,
Supplystopper in  number,
drpRokeychk in varchar2,
Agencycomm_seq in varchar2,
creditreciept in varchar,
cashindisplay IN VARCHAR,
cashinclassified IN VARCHAR,
v_rate_audit_pref in varchar,
v_barcoding_allow_pref in varchar2,
v_fmgbills IN VARCHAR2,
v_billed_cashdis in varchar2,
v_billed_cashcls in varchar,
v_drpbackdate in varchar,
dockitbooking in varchar2,
allowprevbooking in varchar2,
ro_wisecashbill in varchar2,
chkval in varchar2,
approval1 in varchar2,
pckstatus in varchar2,
cash_disc in varchar2,
cash_amt in varchar2,
seperate_cashier1 in varchar2,
disp_bill in varchar2,
clas_bill in varchar2,
mantimepost in varchar2,
bkdaypost in number,
maxterutn in number,
cir_return in varchar2,
noofchkbounc in number,
noofdaychkrec in number,
retday in number,
chngsuppord in number,
max_publishday in number,
p_billno_period in varchar,
spl_trans_edit in varchar2,
spl_dis_trans_editable in varchar2,
mul_pac_sel_trans in varchar2,
shmon_minword in varchar2,
tradon_spcrg in varchar2,
rateauth     in varchar2,
f2day in number,
rateauditmodify in varchar,
bindrevenuecenter in varchar,
p_led_allow in varchar,
p_clear_allow in varchar,
repeatday in varchar,
premiumedit in varchar,
P_BILL_GENERATION in varchar,
P_PUBLICATION_CENTER in varchar,
P_allow_discount_prem IN VARCHAR,
P_SCHEME_BILLING in varchar,
P_ALLOW_PDC in varchar,
PAD_TYPE_FOR_MANUL_BILL in varchar,
RO_OUTSTAND_P IN VARCHAR2,
genrate_agency_code IN VARCHAR2,
p_dispauditbk IN VARCHAR2,
p_aotosupply  IN VARCHAR2,
p_Authorization IN VARCHAR2,
p_CIR_AUTO_APPROVAL_UNSOLD IN VARCHAR2,
p_CIR_AUTO_PHYSICAL_UNSOLD IN VARCHAR2,
p_CIR_UNSOLD_INCLUDE_INCT IN VARCHAR2,
p_CIR_UNSOLD_INCLUDE_INSFEE IN VARCHAR2,
p_CIR_UNSOLD_ON_RECEIVED_DT IN VARCHAR2,
p_AGENCY_UNBLOCK_APROV IN VARCHAR2,
p_UNBLOCK_APROV_OUT_LMT IN VARCHAR2,
p_CIR_BILL_PUBLWISE IN VARCHAR2,
p_paging         IN VARCHAR2,
p_print          IN VARCHAR2,
p_allowpage      IN VARCHAR2,
p_agency_req     IN VARCHAR2,
p_region_req     IN VARCHAR2,
p_ALLOW_FOLLOW_DT_BOOOK     IN VARCHAR2,
p_CRM_SUPPLY_TYPE_PAID     IN VARCHAR2,
p_CRM_SUPPLY_TYPE_FREE     IN VARCHAR2,
p_CURRENCY_MEASUREMENT     IN VARCHAR2

);
END      Wesp_Updatedate;
/





CREATE OR REPLACE PACKAGE BODY Wesp_Updatedate IS
PROCEDURE      Wesp_Updatedate_p(
compcode IN VARCHAR2,
userid IN VARCHAR2,
dateformat IN VARCHAR2,
code IN VARCHAR2,
curr IN VARCHAR2,
RATECODE11 IN VARCHAR2,
solo  IN VARCHAR2,
breakup VARCHAR2,
bwcode IN VARCHAR2,
rostatus IN VARCHAR2,
filename IN VARCHAR2,
tfn IN NUMBER,
insertbreak IN VARCHAR2,
prem IN VARCHAR2,
dealtype IN VARCHAR2,
pre IN VARCHAR2,
suff IN VARCHAR2,
financestatus IN  VARCHAR2,
voucherst IN VARCHAR2,
adcode IN VARCHAR2,
rodatetime IN VARCHAR2,
spacearea IN VARCHAR2,
vat IN VARCHAR2,
bookstat IN VARCHAR2,
cio_id IN VARCHAR2,
receipt_no IN VARCHAR2,
uom IN VARCHAR2,
bgcolor IN VARCHAR2,
validdate IN VARCHAR2,
agencyratecode IN VARCHAR2,
AUDIT1 IN VARCHAR2,
book_insert_date IN VARCHAR2,
agencycomm IN VARCHAR2,
rateaudit IN VARCHAR2,
billaudit IN VARCHAR2,
bill_type IN VARCHAR2,
invoice_no1 IN VARCHAR2,
copybooking IN VARCHAR2,
ratecompany IN VARCHAR2,
addagenycomm IN VARCHAR2,
agencycommlinkretainer IN VARCHAR2,
subeditionr IN VARCHAR2,
displaybilltype IN VARCHAR2,
classifiedbilltype IN VARCHAR2,
billformat IN VARCHAR2,
ratechk IN VARCHAR2,
allpkg IN VARCHAR2,
dayrate1 in varchar2,
schemetype in varchar2,
PIncludeclassi in varchar2,
receiptformat IN VARCHAR2,
v_cash_receipt in varchar2,
v_bill_orderwiselast in varchar2,
v_floor_chk in varchar2,
Unsoldflag in varchar2,
Supplystopper in  number,
drpRokeychk in varchar2,
Agencycomm_seq in varchar2,
creditreciept in varchar,
cashindisplay IN VARCHAR,
cashinclassified IN VARCHAR,
v_rate_audit_pref in varchar,
v_barcoding_allow_pref in varchar2,
v_fmgbills IN VARCHAR2,
v_billed_cashdis in varchar2,
v_billed_cashcls in varchar,
v_drpbackdate in varchar,
dockitbooking in varchar2,
allowprevbooking in varchar2,
ro_wisecashbill in varchar2,
chkval in varchar2,
approval1 in varchar2,
pckstatus in varchar2,
cash_disc in varchar2,
cash_amt in varchar2,
seperate_cashier1 in varchar2,
disp_bill in varchar2,
clas_bill in varchar2,
mantimepost in varchar2,
bkdaypost in number,
maxterutn in number,
cir_return in varchar2,
noofchkbounc in number,
noofdaychkrec in number,
retday in number,
chngsuppord in number,
max_publishday in number,
p_billno_period in varchar,
spl_trans_edit in varchar2,
spl_dis_trans_editable in varchar2,
mul_pac_sel_trans in varchar2,
shmon_minword in varchar2,
tradon_spcrg in varchar2,
rateauth     in varchar2,
f2day in number,
rateauditmodify in varchar,
bindrevenuecenter in varchar,
p_led_allow in varchar,
p_clear_allow in varchar,
repeatday in varchar,
premiumedit in varchar,
P_BILL_GENERATION in varchar,
P_PUBLICATION_CENTER in varchar,
P_allow_discount_prem IN VARCHAR,
P_SCHEME_BILLING in varchar,
P_ALLOW_PDC in varchar,
PAD_TYPE_FOR_MANUL_BILL in varchar,
RO_OUTSTAND_P IN VARCHAR2,
genrate_agency_code IN VARCHAR2,
p_dispauditbk IN VARCHAR2,
p_aotosupply  IN VARCHAR2,
p_Authorization IN VARCHAR2,
p_CIR_AUTO_APPROVAL_UNSOLD IN VARCHAR2,
p_CIR_AUTO_PHYSICAL_UNSOLD IN VARCHAR2,
p_CIR_UNSOLD_INCLUDE_INCT IN VARCHAR2,
p_CIR_UNSOLD_INCLUDE_INSFEE IN VARCHAR2,
p_CIR_UNSOLD_ON_RECEIVED_DT IN VARCHAR2,
p_AGENCY_UNBLOCK_APROV IN VARCHAR2,
p_UNBLOCK_APROV_OUT_LMT IN VARCHAR2,
p_CIR_BILL_PUBLWISE IN VARCHAR2,
p_paging         IN VARCHAR2,
p_print          IN VARCHAR2,
p_allowpage      IN VARCHAR2,
p_agency_req     IN VARCHAR2,
p_region_req     IN VARCHAR2,
p_ALLOW_FOLLOW_DT_BOOOK     IN VARCHAR2,
p_CRM_SUPPLY_TYPE_PAID     IN VARCHAR2,
p_CRM_SUPPLY_TYPE_FREE     IN VARCHAR2,
p_CURRENCY_MEASUREMENT     IN VARCHAR2

)AS
BEGIN
UPDATE LOGIN SET "date_format"=dateformat, "Autogenerate"=code,"curr_code"=curr WHERE "COM_CODE"=compcode;
COMMIT;
        UPDATE PREFERRENCES SET  "autogenerated"=code,
"currency_code"=curr ,
"rate_gr_code"=RATECODE11,
"date_format"=dateformat,"solo"=solo,"breakup"=breakup,
"blackwhitecode"=bwcode,"rostatus"=rostatus,"File_name"=filename,"Tfn"=tfn,
"Insert_breakup"=insertbreak,"Premium_type"=prem,"Deal_type"=dealtype  ,
 "prefix"=pre, "suffix"=suff, "financestatus"=financestatus , "voucherst"=voucherst,
 "Ad_category"=adcode ,"Ro_datetime"=rodatetime ,"Space_area"=spacearea,"Vat"=vat,
 "Booking_status"=bookstat,"Cio_id"=cio_id,"Receipt_no"=receipt_no,"uom_code"=uom,
 "Bgcolor_publication"=bgcolor ,"chkfor_valid_pubdates"=validdate, "Agency_ratecode"=agencyratecode,
  "audit"=AUDIT1,"book_insert_date"=book_insert_date,"agencycomm"=agencycomm,
  "rate_audit"=rateaudit,"bill_audit"=billaudit,"billtype"=bill_type,"invoice_no"=invoice_no1,
  "copy_booking"=copybooking,"RATE_COMPANY_AGENCY"=ratecompany, "ADDITIONAL_AGENCY_COMM"=addagenycomm ,
  "AGENCY_RETAINER_COMM"=agencycommlinkretainer,"SUBEDITIONRATE"=subeditionr,
  "CLS_BILLTYPE"=classifiedbilltype,"DIS_BILLTYPE"=displaybilltype,"BILLING_FORMAT"=billformat,
  "RATE_CHECK"=ratechk,"ALL_PACKAGE"=allpkg,"DAYRATE"=dayrate1,"SCHEME_TYPE"=schemetype,"DISP_CLSBILL"=PIncludeclassi   ,
  "CASH_RECEIPT_BILL"=v_cash_receipt, "BILL_ORDERWSLAST"=v_bill_orderwiselast, "FLOOR_CHK"=v_floor_chk ,
  "UNSOLD_ENTRY_FLAG"=Unsoldflag ,"SUPPLY_STOP_PERCENTAGE"=Supplystopper,"ROKEYCHECK"=drpRokeychk ,
  "AGENCYCOMM_SEQ_COM"=Agencycomm_seq ,"CREDIT_RECIPT"=creditreciept,"DISP_CASHBILL"=cashindisplay,
  "CLA_CASHBILL"=cashinclassified,"RATE_AUDIT_PREF"=v_rate_audit_pref,"BARCODING_ALLOWED"=v_barcoding_allow_pref,
  "FMG_BILL_DIS" =v_fmgbills, "BILL_DISP_CASHBILL"=v_billed_cashdis , "BILL_CLA_CASHBILL"=v_billed_cashcls,"BACKDATERECEIPT"=v_drpbackdate,"DOCKIT_BOOKING"=dockitbooking,"Allowed_old_date"=allowprevbooking,"ROWISE_CASHBOOKING"=ro_wisecashbill,"CUTOFFTIME"=chkval,"APPROVAL"=approval1,"BACK_DAYS"=pckstatus ,CASH_DISCOUNT=cash_amt,CASH_DISCOUNTTYPE=cash_disc,SEPRATE_CASHIER=seperate_cashier1,
   CIR_MANY_TIME_POSTING=mantimepost, CIR_BACKDAYS_POSTING=bkdaypost, CIR_MAX_RETURN_ALLOW=maxterutn, CIR_RETURN_LIMIT_ALLOW=cir_return, CIR_NO_OF_CHQBOUNCE=noofchkbounc, CIR_DAYS_CHQBOUNCE=noofdaychkrec, CIR_RETURN_DAYS=retday, CIR_SUP_ORDER_LIMIT=chngsuppord, DISP_BILLING_CRITERIA=disp_bill, CLSD_BILLING_CRITERIA=clas_bill,MAX_PUBLISHDAYS=max_publishday,BILLNO_PERIODICITY=p_billno_period,
   SPECIALDISC_TRANS_EDIT=spl_trans_edit, SHARING_TRANS=spl_dis_trans_editable, MULTIPACKAGE_SEL_TRANS=mul_pac_sel_trans,SCHEME_MINWORD=shmon_minword, TRADE_SPLCHARGE=tradon_spcrg,RATE_AUTHORIZATION=rateauth
  ,F2_RECORD=f2day,PUBLISHAD_EDIT_RATEAUDIT=rateauditmodify,BINDREVENUE_CENTER=bindrevenuecenter,  
  FA_LEDGER_ALLOW=p_led_allow ,CLEARANCE_TYPE_ALLOW=p_clear_allow,REPEAT_DAY_TYPE=repeatday,PREMIUM_EDIT=premiumedit,
BILL_GENERATION_PRIOR=P_BILL_GENERATION,PUBLICATION_HO=P_PUBLICATION_CENTER,SPLDISC_ALLOWPREM=P_allow_discount_prem,

BILL_SCHEME=P_SCHEME_BILLING,ALLOWED_PDC_DAYS_RECEIPT=P_ALLOW_PDC ,AD_TYPE_MANUL_BILL=PAD_TYPE_FOR_MANUL_BILL,OUTSTANDING_AMT_CRITERIA=RO_OUTSTAND_P,GENRATE_CIR_AGCD=genrate_agency_code,DISP_AUDITBKG=p_dispauditbk,CIR_DIS_AUTO_POSTING=p_aotosupply,RELAUTHREQON=p_Authorization,
CIR_AUTO_APPROVAL_UNSOLD=p_CIR_AUTO_APPROVAL_UNSOLD,CIR_AUTO_PHYSICAL_UNSOLD=p_CIR_AUTO_PHYSICAL_UNSOLD,CIR_UNSOLD_INCLUDE_INCT=p_CIR_UNSOLD_INCLUDE_INCT,
CIR_UNSOLD_INCLUDE_INSFEE=p_CIR_UNSOLD_INCLUDE_INSFEE,CIR_UNSOLD_ON_RECEIVED_DT=p_CIR_UNSOLD_ON_RECEIVED_DT,
AGENCY_UNBLOCK_APPROVAL=p_AGENCY_UNBLOCK_APROV,UNBLOCK_APPROVAL_OUTSIDE_LIMIT=p_UNBLOCK_APROV_OUT_LMT,CIR_BILL_PUBLWISE=p_CIR_BILL_PUBLWISE,
RECORDS_ON_PAGE = p_paging,RECORDS_ON_PRINT = p_print,HEADER_ON_PAGE = p_allowpage,AGENCY_REQUIRED = p_agency_req,REGION_REQUIRED = p_region_req,ALLOW_FOLLOW_DT_BOOOK=p_ALLOW_FOLLOW_DT_BOOOK,CRM_SUPPLY_TYPE_PAID=p_CRM_SUPPLY_TYPE_PAID,CRM_SUPPLY_TYPE_FREE=p_CRM_SUPPLY_TYPE_FREE,CURRENCY_MEASUREMENT=p_CURRENCY_MEASUREMENT

  
   WHERE "comp_code"=compcode;
COMMIT;
END      Wesp_Updatedate_p;
END      Wesp_Updatedate;
/



/***********************mimoh 28dec 2011*********6162****************************************/
///////////////////////////////////////////////////////


CREATE OR REPLACE procedure cir_rep_inct_slab(
    pcompcode       in varchar2,
    punitcode       in varchar2,
    ppublcode       in varchar2,
    pagency_type    in varchar2,
    psupply_type    in varchar2,    
    pchkdate        in varchar2, 
    puserid         in varchar2, 
    pdateformate    in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    pextra3         in varchar2,
    pextra4         in varchar2,
    pextra5         in varchar2,
    pextra6         in varchar2,
    pextra7         in varchar2,
    pextra8         in varchar2,
    pextra9         in varchar2,
    pextra10        in varchar2,
    p_accounts      OUT Cur_Type_New1.cursor_type,
    p_accounts1     OUT Cur_Type_New1.cursor_type,
    p_accounts2     OUT Cur_Type_New1.cursor_type)
is
    v_from_date date;
begin
    v_from_date:=to_date(pchkdate,''''||pdateformate||'''');
    
    open p_accounts for 
    select d.comp_code as "COMP_CODE",d.inct_slab_id as "INCT_SLAB_ID", case when d.inct_base='S' then 'SUPPLY' else 'GROWTH' end as "INCT_BASE",
    case  
    when d.inct_type ='SW' THEN 'Weekly' 
    when d.inct_type ='SM' THEN 'Monthly' 
    when d.inct_type ='SQ' THEN 'Querterly' 
    when d.inct_type ='SY' THEN 'Yearly'  end as "INCT_TYPE" ,
    d.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=d.unit_code) as "UNIT_NAME", 
    d.publ_code as "PUBL_CODE",p.publ_name as "PUBL_NAME",
    e.main_edtn as "MAIN_EDTN",cir_get_edtn_name(d.comp_code,e.main_edtn) as "MAIN_EDTN_NAME",d.edtn_code as "EDTN",e.edtn_name as "EDTN_NAME",
    d.supply_type as "SUPPLY_TYPE",s.sup_ty_name as "SUP_TY_NAME",d.calc_type as "CALC_TYPE",
    d.supply_from as "SUPPLY_FROM",d.supply_till as "SUPPLY_TILL",
    d.inct_amt as "INCT_AMT",d.branch_code as "BRANCH_CODE",(select "Branch_Name" from branch_mst where "Branch_Code"=d.branch_code) as "BRANCH_NAME",
    d.agency_type as "AGENCY_TYPE",(select agency_type_desc from cir_agency_typ_mast where comp_code=d.comp_code and agency_type_code=d.agency_type) as "AGENCY_TYPE_NAME",
    CASE  pdateformate
    WHEN 'mm/dd/yyyy' THEN TO_CHAR(d.eff_date ,'mm/dd/yyyy')
    WHEN 'dd/mm/yyyy' THEN TO_CHAR(d.eff_date,'dd/mm/yyyy')
    WHEN 'yyyy/mm/dd' THEN TO_CHAR(d.eff_date,'yyyy/mm/dd')  END AS "EFFECTIVE_FROM",
    (select rmrk from cir_inct_slab_hdr where comp_code=d.comp_code and unit_code=d.unit_code and inct_slab_id=d.inct_slab_id) as "REMARKS"     
    from cir_publ_mast p,cir_edtn_mast e,cir_inct_slab_det d,cir_supply_type_mast s 
    where p.comp_code=e.comp_code and p.comp_code=d.comp_code and p.comp_code=s.comp_code and p.comp_code=pcompcode and
    p.publ=e.publ and p.publ=d.publ_code and p.publ=nvl(ppublcode,p.publ)
    and d.unit_code=nvl(punitcode,d.unit_code) 
    and e.edtn=d.edtn_code 
    and d.supply_type=s.sup_ty_code and d.supply_type=s.sup_ty_code 
    and d.supply_type=nvl(psupply_type,d.supply_type) 
    and (d.agency_type=pagency_type or pagency_type is null)
    and d.inct_base='S'
    order by unit_name,branch_name,inct_slab_id,inct_slabid_det;
    
    open p_accounts1 for 
    select distinct d.comp_code as "COMP_CODE",d.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=d.unit_code) as "UNIT_NAME", 
    d.branch_code as "BRANCH_CODE",(select "Branch_Name" from branch_mst where "Branch_Code"=d.branch_code) as "BRANCH_NAME"
    from cir_publ_mast p,cir_edtn_mast e,cir_inct_slab_det d,cir_supply_type_mast s 
    where p.comp_code=e.comp_code and p.comp_code=d.comp_code and p.comp_code=s.comp_code and p.comp_code=pcompcode and
    p.publ=e.publ and p.publ=d.publ_code and p.publ=nvl(ppublcode,p.publ)
    and d.unit_code=nvl(punitcode,d.unit_code) and e.edtn=d.edtn_code 
    and d.supply_type=s.sup_ty_code and d.supply_type=s.sup_ty_code 
    and d.supply_type=nvl(psupply_type,d.supply_type) 
    and (d.agency_type=pagency_type or pagency_type is null)
    and d.inct_base='S'
    order by unit_name,branch_name;
    
    open p_accounts2 for 
    select distinct d.comp_code as "COMP_CODE",d.unit_code as "UNIT_CODE",(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=d.unit_code) as "UNIT_NAME"
    from cir_publ_mast p,cir_edtn_mast e,cir_inct_slab_det d,cir_supply_type_mast s 
    where p.comp_code=e.comp_code and p.comp_code=d.comp_code and p.comp_code=s.comp_code and p.comp_code=pcompcode and
    p.publ=e.publ and p.publ=d.publ_code and p.publ=nvl(ppublcode,p.publ)
    and d.unit_code=nvl(punitcode,d.unit_code) and e.edtn=d.edtn_code 
    and d.supply_type=s.sup_ty_code and d.supply_type=s.sup_ty_code 
    and d.supply_type=nvl(psupply_type,d.supply_type) 
    and (d.agency_type=pagency_type or pagency_type is null)
     and d.inct_base='S'
    order by unit_name;
    
End cir_rep_inct_slab;
/
///////////////////////////////////////////////////garima
CREATE OR REPLACE PACKAGE cir_region_bind IS
  type t_accounts_cursor is ref cursor;
  procedure cir_region_bind_p (
		pcomp_code 	in varchar2,
		pdateformat in varchar2,
		pextra1 		in varchar2,
		pextra2 		in varchar2,
		p_accounts 	out t_accounts_cursor);
  procedure cir_region_bind_p (
		pcomp_code 	in varchar2,
		preg_code 	in varchar2,
		pdateformat in varchar2,
		pextra1 		in varchar2,
		pextra2 		in varchar2,
		p_accounts 	out t_accounts_cursor);
  procedure cir_region_bind_p (
		pcomp_code 	in varchar2,
		preg_code 	in varchar2,
		pcol_name 	in varchar2,
		porder 			in varchar2,
		pdateformat in varchar2,
		pextra1 		in varchar2,
		pextra2 		in varchar2,
		p_accounts 	out t_accounts_cursor);
End cir_region_bind;
/
/////////////////////

CREATE OR REPLACE PACKAGE BODY cir_region_bind IS
  procedure cir_region_bind_p (
		pcomp_code 	in varchar2,
		pdateformat in varchar2,
		pextra1 		in varchar2,
		pextra2 		in varchar2,
		p_accounts 	out t_accounts_cursor)
	As
	Begin
		open p_accounts for
		select cir_region_mast.*,cir_get_zone_name(cir_region_mast.comp_code,cir_region_mast.zone_code) zone_name from cir_region_mast 
		where comp_code=pcomp_code and (cir_region_mast.reg_desc like pextra1||'%' or pextra1 is null) order by cir_region_mast.reg_code;
	End cir_region_bind_p;
	
  procedure cir_region_bind_p (
		pcomp_code 	in varchar2,
		preg_code 	in varchar2,
		pdateformat in varchar2,
		pextra1 		in varchar2,
		pextra2 		in varchar2,
		p_accounts 	out t_accounts_cursor)
	As
	Begin
		open p_accounts for
		select cir_region_mast.*,cir_get_zone_name(cir_region_mast.comp_code,cir_region_mast.zone_code) zone_name 
		from cir_region_mast 
		where comp_code=pcomp_code and (reg_code =preg_code or preg_code is null)
		order by cir_region_mast.reg_code;	
	End cir_region_bind_p;

  procedure cir_region_bind_p (
		pcomp_code 	in varchar2,
		preg_code 	in varchar2,
		pcol_name 	in varchar2,
		porder			in varchar2,
		pdateformat in varchar2,
		pextra1 		in varchar2,
		pextra2 		in varchar2,
		p_accounts 	out t_accounts_cursor)
	As
		v_query varchar2(2000);
	Begin
		v_query:='select cir_region_mast.*,cir_get_zone_name(cir_region_mast.comp_code,cir_region_mast.zone_code) zone_name 
		from cir_region_mast 
		where comp_code='||''''||pcomp_code||''''||' and (reg_code ='||''''||preg_code ||''''||' or '||''''||preg_code||''''||' is null)
		order by '||pcol_name||' '||porder;
		--insert into test1(vstring,vstring2) values('cir_region_bind_p',v_query);
		--commit;
		open p_accounts for v_query;
		
	End cir_region_bind_p;
End cir_region_bind;
/
/////////////////////////////////////////garima
CREATE OR REPLACE package cir_dist_bind is
   type t_accounts_cursor is ref cursor;
   procedure cir_dist_bind_p (
       pcomp_code 	in varchar2,
       pdateformat 	in varchar2,
       pextra1 			in varchar2,
       pextra2 			in varchar2,
       p_accounts 	out t_accounts_cursor);
   
   procedure cir_dist_bind_p (
       pcomp_code 	in varchar2,
       pdist_code 	in varchar2,
       pdateformat 	in varchar2,
       pextra1 			in varchar2,
       pextra2 			in varchar2,
       p_accounts 	out t_accounts_cursor);
   
   procedure cir_dist_bind_p (
       pcomp_code 	in varchar2,
       pcolname 		in varchar2,
       porder 			in varchar2,
       pdateformat 	in varchar2,
       pextra1 			in varchar2,
       pextra2 			in varchar2,
       p_accounts 	out t_accounts_cursor);
End cir_dist_bind;
/
///////////////////////////////////////////
CREATE OR REPLACE package body cir_dist_bind is
   procedure cir_dist_bind_p (
     pcomp_code 	in varchar2,
     pdateformat 	in varchar2,
     pextra1 			in varchar2,
     pextra2 			in varchar2,
     p_accounts 	out t_accounts_cursor) 
   As
   Begin
   	open p_accounts for
		select cir_dist_mast.comp_code comp_code,cir_dist_mast.dist_code dist_code,cir_dist_mast.dist_name dist_name,cir_dist_mast.dist_alias,cir_dist_mast.userid userid,
		cir_dist_mast.creation_date creation_date,cir_dist_mast.freeze_flag freeze_flag, cir_dist_mast.state_code state_code,
		cir_dist_mast.country_code country_code,cir_dist_mast.dist_oname dist_oname,
		count_mst."Country_Name" country_name, state_mst."State_Name" state_name
		from cir_dist_mast,count_mst,state_mst
		where cir_dist_mast.comp_code=count_mst."Comp_Code"(+) and cir_dist_mast.comp_code=state_mst."Comp_Code"(+) and cir_dist_mast.comp_code=pcomp_code and
		      cir_dist_mast.country_code=count_mst."Country_Code"(+) and cir_dist_mast.country_code=state_mst."Country_Code"(+) and
	      	cir_dist_mast.state_code=state_mst."State_Code"(+) and (cir_dist_mast.dist_name like pextra1||'%' or pextra1 is null)
          order by dist_name;
   End cir_dist_bind_p;

   procedure cir_dist_bind_p (
     pcomp_code 	in varchar2,
     pdist_code 	in varchar2,
     pdateformat 	in varchar2,
     pextra1 			in varchar2,
     pextra2 			in varchar2,
     p_accounts 	out t_accounts_cursor) 
   As
   Begin
   	open p_accounts for
		select cir_dist_mast.comp_code comp_code,cir_dist_mast.dist_code dist_code,cir_dist_mast.dist_name dist_name,cir_dist_mast.dist_alias,cir_dist_mast.userid userid,
		cir_dist_mast.creation_date creation_date,cir_dist_mast.freeze_flag freeze_flag, cir_dist_mast.state_code state_code,
		cir_dist_mast.country_code country_code,cir_dist_mast.dist_oname dist_oname,
		count_mst."Country_Name" country_name, state_mst."State_Name" state_name
		from cir_dist_mast,count_mst,state_mst
		where cir_dist_mast.comp_code=count_mst."Comp_Code"(+) and cir_dist_mast.comp_code=state_mst."Comp_Code"(+) and cir_dist_mast.comp_code=pcomp_code and
		      cir_dist_mast.country_code=count_mst."Country_Code"(+) and cir_dist_mast.country_code=state_mst."Country_Code"(+) and
	      	cir_dist_mast.state_code=state_mst."State_Code"(+) and (cir_dist_mast.dist_code=pdist_code or pdist_code is null) and
            (cir_dist_mast.dist_name like pextra1||'%' or pextra1 is null)
          order by dist_name;
   End cir_dist_bind_p;
   
    procedure cir_dist_bind_p (
     pcomp_code 	in varchar2,
     pcolname 		in varchar2,
     porder 			in varchar2,
     pdateformat 	in varchar2,
     pextra1 			in varchar2,
     pextra2 			in varchar2,
     p_accounts 	out t_accounts_cursor) 
   As
 
   Begin
      insert into tbl values (pcolname||'- '||porder); commit;
   	open p_accounts for
		'select cir_dist_mast.comp_code comp_code,cir_dist_mast.dist_code dist_code,cir_dist_mast.dist_name dist_name,cir_dist_mast.dist_alias,cir_dist_mast.userid userid,
		cir_dist_mast.creation_date creation_date,cir_dist_mast.freeze_flag freeze_flag, cir_dist_mast.state_code state_code,
		cir_dist_mast.country_code country_code,cir_dist_mast.dist_oname dist_oname,
		count_mst."Country_Name" country_name, state_mst."State_Name" state_name
		from cir_dist_mast,count_mst,state_mst
		where cir_dist_mast.comp_code=count_mst."Comp_Code"(+) and cir_dist_mast.comp_code=state_mst."Comp_Code"(+) and cir_dist_mast.comp_code='||pcomp_code||' and
		      cir_dist_mast.country_code=count_mst."Country_Code"(+) and cir_dist_mast.country_code=state_mst."Country_Code"(+) and
	      	cir_dist_mast.state_code=state_mst."State_Code"(+)
          order by '||pcolname||' '||porder;
          
   End cir_dist_bind_p;
End cir_dist_bind;
/

/**************************Nand kishor  29-dec-2011**************************/

/**************************Nand kishor   29-dec-2011**************************/
/**************************************6176***mimoh 29-dec-2011*******************/


CREATE OR REPLACE PROCEDURE cir_agency_unblock_approval (
    pcomp_code         in varchar2,
    punit_code         in varchar2,
    pbran_code         in varchar2,
    pstatus            in varchar2,
    pfrdt              in date,
    ptodt              in date,
    pagcd              in varchar2,
    pdpcd              in varchar2,
    psuspty            in varchar2,
    puserid            in varchar2,
    p_accounts         OUT cur_type_new1.cursor_type) as
Begin

open p_accounts for
  select s.comp_code as "COMP_CODE",s.unit as "UNIT",s.agcd as "AGCD",s.dpcd as "DPCD",m.ag_name as "AGENCY_NAME",
  cir_get_drop_point_name(s.comp_code,s.unit,m.station_code,1) as "DROP_POINT_NAME",cir_get_city(s.comp_code,m.city_code) as "CITY_NAME",
  s.start_date as "BLOCK_UNBLOCK_DATE",'' as "BLOCK_UNBLOCK_TIME",
         (SELECT SUSPEND_DESC FROM CIR_SUSPEND_TYPE_MAST WHERE COMP_CODE=s.COMP_CODE AND SUSPEND_TYPE_CODE=s.suspty) AS "BLOCK_REASON",s.suspty as "SUSPTY",
         (SELECT max("username") from login where com_code = s.comp_code  and "userid"=s.userid) as unblock_by,s.suspty as "SUSPEND_TYPE",
         s.agency_unblock_approval as "AGENCY_UNBLOCK_APPROVAL",s.userid as "USERID",nvl(s.trn_date,trunc(s.creation_date)) as "TRN_DATE" 
         from cir_suspend_tran s,cir_agmast m
      where s.comp_code = m.comp_code and s.comp_code = pcomp_code
        and s.unit=m.unit and s.unit      = nvl(punit_code,s.unit)
        and s.susp      = pstatus
        and s.trn_date between pfrdt and ptodt
        and s.agcd=m.agcd and s.agcd    = nvl(pagcd,s.agcd)
        and s.dpcd=m.dpcd and s.dpcd    = nvl(pdpcd,s.dpcd)
        and s.userid  = nvl(puserid,s.userid)
        and nvl(s.agency_unblock_approval,'N')='N';
    
  
End cir_agency_unblock_approval;
/

/**************************************6176***mimoh 29-dec-2011*******************/


///////////////////////////////////////Issue No. 6175 02/01/2011 ///////////////////////////////////////////////////


CREATE OR REPLACE PROCEDURE HT18JULY.cir_bank_guarantee_bind(
   pcomp_code     IN       VARCHAR2,
   pagcd          IN       VARCHAR2,
   pdpcd          IN       VARCHAR2,
   pexpiry_date   IN       VARCHAR2,
   pexpiry_days   IN       NUMBER,
   pinstrument_ty IN       VARCHAR2,
   pdateformat    IN       VARCHAR2,
   pextra         IN       VARCHAR2,
   pextra1        IN       VARCHAR2,
   pextra2        IN       VARCHAR2,
   p_accounts     OUT      cur_type_new1.cursor_type
)
IS
v_dt date;
v_expdt date;
BEGIN
    v_expdt := to_date(pexpiry_date,''''||pdateformat||'''');
    v_dt    := v_expdt + nvl(pexpiry_days,0);
    OPEN p_accounts FOR
    SELECT b.COMP_CODE, b.UNIT_CODE, b.AGCD, b.DPCD,m.ag_name AG_NAME,CIR_GET_DROP_POINT_NAME(B.COMP_CODE,B.UNIT_CODE,M.STATION_CODE,1) DROP_POINT_NAME,
    CIR_GET_CITY(B.COMP_CODE,M.CITY_CODE) CITY_NAME, 
    b.BG_NO, b.BG_AMT, b.BG_DATE, b.BG_VALID, b.BANK_DESC, 
    b.CREATED_BY, b.CREATED_DT, b.UPDATED_BY, b.UPDATED_DT, b.BG_TYPE
    FROM cir_bank_guarantee b,cir_agmast m
    where m.comp_code =b.comp_code and m.comp_code = pcomp_code and b.unit_code=m.unit  
    and b.agcd=m.agcd and b.agcd    = nvl(pagcd,b.agcd) 
    and b.dpcd=m.dpcd and b.dpcd    = nvl(pdpcd,b.dpcd)
    and ((b.bg_type = pinstrument_ty) or (pinstrument_ty is null))
    and b.bg_valid<=v_dt ORDER BY AG_NAME;
    
END cir_bank_guarantee_bind;
/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////Issue NO. 6161 02/01/2012//////////////////////////////////////////////////////////////

CREATE OR REPLACE PACKAGE BODY HT18JULY.cir_pcenter_detail IS

  Procedure cir_pcenter_detail_p(
     pcompcode          in varchar2,
     ppcenter           in varchar2,
     plangtype          in varchar2,---1 for enlish and 2 for other language
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts)
  As
  Begin
        open p_accounts for 
        select * from pub_cent_mast where /*"Comp_Code"=pcompcode  and*/
        ("Pub_cent_Code"=ppcenter or ppcenter is null) and rownum<=1
        order by "Comp_Code";

  END cir_pcenter_detail_p;

END cir_pcenter_detail;
/

////************3rd Jan 2012 ****************************************************
CREATE OR REPLACE procedure cir_unsold_supply_for_transfer(
    pcomp_code         in varchar2,
    punit_code         in varchar2,
    pbran_code         in varchar2,
    pfromdate          in varchar2,
    ptilldate          in varchar2,
    puserid            in varchar2,   
    pdateformat        in varchar2,
    pextra1            in varchar2,
    pextra2            in varchar2,
    pextra3            in varchar2,
    pextra4            in varchar2,
    pextra5            in varchar2,
    pextra6            in varchar2,
    pextra7            in varchar2,
    pextra8            in varchar2,               
    pextra9            in varchar2,
    pextra10           in varchar2,
    p_accounts         OUT Cur_Type_New1.cursor_type,
    p_accounts1        OUT Cur_Type_New1.cursor_type)
As
    v_frdt          date;
    v_todt          date;
    v_process_id    number;
Begin
    v_frdt:=to_date(pfromdate,''''||pdateformat||'''');
    v_todt:=to_date(ptilldate,''''||pdateformat||'''');

    v_process_id:=cir_generate_processid(pcomp_code,puserid,pdateformat,null,null,null,null,null);
    
    open p_accounts for
    select v_process_id as "PROCESS_ID" from dual;  

    open p_accounts1 for
    select distinct d.comp_code as "COMP_CODE",d.unit_code as "UNIT_CODE",d.branch_code as "BRANCH_CODE",d.doctype as "DOCTYPE",
    d.recptno as "RECPTNO",d.recptdt as "RECPTDT",d.sup_agcd as "SUP_AGCD" ,d.sup_dpcd as "SUP_DPCD",m.ag_name as "SUPPLY_AGENCY",
    cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) drop_point_name, cir_get_city(d.comp_code,m.city_code) city_name,cir_get_agency(d.comp_code,d.unit_code,d.agcd,d.dpcd) as "BILLING_AGENCY",
    sum(nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0)+nvl(apr_damage,0)) as "TOTAL_UNSOLD",
    v_process_id as "PROCESS_IDNO" 
    from cir_unsold_hdr h,cir_unsold_dtl d,cir_agmast m
    where h.comp_code=d.comp_code and h.comp_code=m.comp_code and h.comp_code=pcomp_code and h.unit_code=d.unit_code and h.unit_code=m.unit and h.unit_code=punit_code and 
    h.doctype=d.doctype and h.doctype='UCN' and h.recptno=d.recptno and h.recptdt=d.recptdt and h.recptdt between v_frdt and v_todt and 
    h.agcd=nvl(d.sup_agcd,d.agcd) and h.agcd=m.agcd and h.dpcd=nvl(d.sup_dpcd,d.dpcd) and h.dpcd=m.dpcd and 
    d.branch_code=nvl(pbran_code,d.branch_code) and (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0)+nvl(apr_damage,0))>0 and
    (h.branch_trfno is null or h.branch_trfno='')
    group by d.comp_code,d.unit_code,d.branch_code,d.doctype,d.recptno,d.recptdt,d.sup_agcd,d.sup_dpcd,m.ag_name,m.station_code, m.city_code,d.agcd,d.dpcd
    order by comp_code,unit_code,recptdt,recptno;
            
End cir_unsold_supply_for_transfer;
/

//********************************
CREATE OR REPLACE procedure cir_unsold_transfer_selected(
    pcompcode       in varchar2,
    punitcode       in varchar2,
    pbrancode       in varchar2,
    precptno        in varchar2,
    precptdt        in varchar2,
    pprocess_idno   in numeric,
    puserid         in varchar2, 
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    pextra3         in varchar2,
    pextra4         in varchar2,
    pextra5         in varchar2,
    pextra6         in varchar2,
    pextra7         in varchar2,
    pextra8         in varchar2,
    pextra9         in varchar2,
    pextra10        in varchar2,
    p_accounts      OUT Cur_Type_New1.cursor_type)
is
    v_precptdt     date;
begin
    v_precptdt:=to_date(precptdt,''''||pdateformat||'''');
    
    insert into cir_bill_return_print(comp_code,unit_code,branch_code,billno,billdt,return_copy)
    values(pcompcode,punitcode,pbrancode,precptno,v_precptdt,pprocess_idno);
    commit;
    
    open p_accounts for
    select sysdate as "CUR_DATE" from dual;
    
End cir_unsold_transfer_selected;
/

//**************************************************************

CREATE OR REPLACE procedure cir_fetch_for_unsold_transfer(
    pcomp_code      in varchar2,
    punit_code      in varchar2,
    pbran_code      in varchar2,
    pprocess_idno   in number,
    ppacket_szie    in number,
    puserid         in varchar2, 
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    pextra3         in varchar2,
    pextra4         in varchar2,
    pextra5         in varchar2,
    pextra6         in varchar2,
    pextra7         in varchar2,
    pextra8         in varchar2,
    pextra9         in varchar2,
    pextra10        in varchar2,
    p_accounts      OUT Cur_Type_New1.cursor_type,
    p_accounts1     OUT Cur_Type_New1.cursor_type)
is
begin

    open p_accounts for
    select distinct x.comp_code as "COMP_CODE",x.unit_code as "UNIT_CODE",x.branch_code as "BRANCH_CODE",x.doctype as "DOCTYPE",
    x.publ as "PUBL",x.publ_name as"PUBL_NAME", x.main_edtn as "MAIN_EDTN",x.main_edtn_name as "MAIN_EDTN_NAME",
    x.edtn as "EDTN",x.edtn_name as "EDTN_NAME",x.copy_rate as "COPY_RATE",x.total_unsold as "TOTAL_UNSOLD",
    ceil(x.total_unsold/ppacket_szie) as "PKT" 
    from(
    select distinct d.comp_code,d.unit_code,d.branch_code,d.doctype,
    d.publ,p.publ_name, e.main_edtn,cir_get_edtn_name(d.comp_code,d.edtn) main_edtn_name,
    d.edtn,e.edtn_name,d.copy_rate,sum(nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0)+nvl(apr_damage,0)) as TOTAL_UNSOLD
    from cir_unsold_hdr h,cir_unsold_dtl d,cir_agmast m,cir_publ_mast p,cir_edtn_mast e,cir_bill_return_print b
    where h.comp_code=d.comp_code and h.comp_code=m.comp_code and h.comp_code=p.comp_code and h.comp_code=e.comp_code and h.comp_code=b.comp_code and h.comp_code=pcomp_code and 
    h.unit_code=d.unit_code and h.unit_code=m.unit and h.unit_code=b.unit_code and h.unit_code=punit_code and 
    h.doctype=d.doctype and h.doctype='UCN' and h.recptno=d.recptno and h.recptno=b.billno and h.recptdt=d.recptdt and h.recptdt=b.billdt and
    h.agcd=nvl(d.sup_agcd,d.agcd) and h.agcd=m.agcd and h.dpcd=nvl(d.sup_dpcd,d.dpcd) and h.dpcd=m.dpcd and d.publ=p.publ and d.publ=e.publ and d.edtn=e.edtn and  
    d.branch_code=pbran_code and (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0)+nvl(apr_damage,0))>0 and b.return_copy=pprocess_idno
    group by d.comp_code,d.unit_code,d.branch_code,d.doctype,d.publ,p.publ_name,e.main_edtn,d.edtn,e.edtn_name,d.copy_rate) x
    order by comp_code,unit_code,publ_name,main_edtn_name,edtn_name,copy_rate;
    
    open p_accounts1 for
    select sysdate as "CUR_DATE" from dual;
    
    delete from cir_bill_return_print where return_copy=pprocess_idno;commit;
    
End cir_fetch_for_unsold_transfer;
/

//********************************************************************
CREATE OR REPLACE PACKAGE cir_edtion_bind is
   TYPE T_Circul_Cursor is Ref Cursor;
   procedure cir_edtion_bind_p (
    pcomp_code  in varchar2,
    ppubl_code  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    p_circuls   out T_Circul_Cursor);
   procedure cir_edtion_bind_p (
    pcomp_code  in varchar2,
    ppubl_code  in varchar2,
    pedtn_code  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    p_circuls   out T_Circul_Cursor);

   procedure cir_mian_edtion_bind_p (
    pcomp_code  in varchar2,
    ppubl_code  in varchar2,
    pedtn_code  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    p_circuls   out T_Circul_Cursor);
   procedure cir_sub_edtion_bind_p (
    pcomp_code       in varchar2,
    ppubl_code       in varchar2,
    pedtn_code       in varchar2,
    psubedtn_code    in varchar2,
    pdateformat      in varchar2,
    pextra1          in varchar2,
    pextra2          in varchar2,
    p_circuls        out T_Circul_Cursor);
procedure cir_mian_edtion_pick_bind_p (
   pcomp_code       in varchar2,
   ppubl_code       in varchar2,
   pedtn_code       in varchar2,
   pdateformat      in varchar2,
   pextra1          in varchar2,
   pextra2          in varchar2,
   p_circuls        out T_Circul_Cursor);
   procedure cir_main_edition_bind_p (
    pcomp_code  in varchar2,
    ppubl_code  in varchar2,
    pedtn_code  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    p_circuls   out T_Circul_Cursor); 
    
    procedure cir_sub_edition_bind_p (
    pcomp_code       in varchar2,
    ppubl_code       in varchar2,
    pedtn_code       in varchar2,
    psubedtn_code    in varchar2,
    pdateformat      in varchar2,
    pextra1          in varchar2,
    pextra2          in varchar2,
    p_circuls        out T_Circul_Cursor); 
End cir_edtion_bind;
/

CREATE OR REPLACE PACKAGE BODY cir_edtion_bind is
   procedure cir_edtion_bind_p (
    pcomp_code  in varchar2,
    ppubl_code  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    p_circuls   out T_Circul_Cursor) as
   Begin
      open p_circuls for
         select * from cir_edtn_mast
                 where comp_code = pcomp_code and
                      (publ=ppubl_code or ppubl_code is null) and
                       nvl(freeze_flag,'N')='N' and edtn<>main_edtn and
                       ((upper(edtn_name) like upper(pextra1)||'%') or (pextra1 is null))
                       and (unit_code=pextra2 or pextra2 is null)
                 order by edtn_name;
   End cir_edtion_bind_p;

   procedure cir_edtion_bind_p (
    pcomp_code  in varchar2,
    ppubl_code  in varchar2,
    pedtn_code  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    p_circuls   out T_Circul_Cursor) as
   Begin
      open p_circuls for
         select * from cir_edtn_mast
                 where comp_code = pcomp_code and
                       publ = ppubl_code and
                       (edtn=pedtn_code or pedtn_code is null) and
                       nvl(freeze_flag,'N')='N' and (unit_code=pextra2 or pextra2 is null)
                       order by edtn_name;
   End cir_edtion_bind_p;
   
   procedure cir_mian_edtion_bind_p (
    pcomp_code  in varchar2,
    ppubl_code  in varchar2,
    pedtn_code  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    p_circuls   out T_Circul_Cursor)
   As
   Begin
        open p_circuls for
        select * from cir_edtn_mast
            where comp_code = pcomp_code and (unit_code=pextra1 or pextra1 is null) and publ = ppubl_code and
                    (edtn=pedtn_code or pedtn_code is null) and edtn=main_edtn and (upper(edtn_name) like upper(pextra2)||'%' or pextra2 is null)
                    and nvl(freeze_flag,'N')='N' 
        order by edtn_name;

   End cir_mian_edtion_bind_p;
   
   procedure cir_sub_edtion_bind_p (
    pcomp_code      in varchar2,
    ppubl_code      in varchar2,
    pedtn_code      in varchar2,
    psubedtn_code   in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    p_circuls       out T_Circul_Cursor)
   As
   Begin
        open p_circuls for
        select * from cir_edtn_mast
            where comp_code = pcomp_code and publ = ppubl_code and
                    (edtn=psubedtn_code or psubedtn_code is null) and (main_edtn=pedtn_code or pedtn_code is null) and
                    edtn<>main_edtn and
        nvl(freeze_flag,'N')='N' and (unit_code=pextra2 or pextra2 is null)
        order by edtn_name;

   End cir_sub_edtion_bind_p;

   procedure cir_mian_edtion_pick_bind_p (
   pcomp_code       in varchar2,
   ppubl_code       in varchar2,
   pedtn_code       in varchar2,
   pdateformat      in varchar2,
   pextra1          in varchar2,
   pextra2          in varchar2,
   p_circuls        out T_Circul_Cursor)
   As
   Begin
        open p_circuls for
        select * from cir_edtn_mast
            where comp_code = pcomp_code and publ = ppubl_code and
                    edtn in (select main_edtn from cir_edtn_mast where comp_code = pcomp_code and publ = ppubl_code and
                         edtn<>nvl(main_edtn,'/') and edtn=pedtn_code) and
                       nvl(freeze_flag,'N')='N' and (unit_code=pextra2 or pextra2 is null)
        order by edtn_seq_no;

   End cir_mian_edtion_pick_bind_p;
   
   procedure cir_main_edition_bind_p (
    pcomp_code  in varchar2,
    ppubl_code  in varchar2,
    pedtn_code  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    p_circuls   out T_Circul_Cursor)
   As
   Begin
        open p_circuls for
        select * from cir_edtn_mast
            where comp_code = pcomp_code and (unit_code=pextra1 or pextra1 is null) and --publ = ppubl_code and
                    (edtn=pedtn_code or pedtn_code is null) and edtn=main_edtn and (upper(edtn_name) like upper(pextra2)||'%' or pextra2 is null)
                    and nvl(freeze_flag,'N')='N' 
        order by edtn_name;

   End cir_main_edition_bind_p;
   
   procedure cir_sub_edition_bind_p (
    pcomp_code      in varchar2,
    ppubl_code      in varchar2,
    pedtn_code      in varchar2,
    psubedtn_code   in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    p_circuls       out T_Circul_Cursor)
   As
   Begin
        open p_circuls for
        select * from cir_edtn_mast where comp_code = pcomp_code 
        -- and publ = ppubl_code and (edtn=psubedtn_code or psubedtn_code is null) and (main_edtn=pedtn_code or pedtn_code is null) 
        and edtn<>main_edtn and nvl(freeze_flag,'N')='N' and (unit_code=pextra2 or pextra2 is null)
        order by edtn_name;

   End cir_sub_edition_bind_p;
End cir_edtion_bind;
/

//********************************************************************************
CREATE OR REPLACE PACKAGE cir_edtion_bind is
   TYPE T_Circul_Cursor is Ref Cursor;
   procedure cir_edtion_bind_p (
    pcomp_code  in varchar2,
    ppubl_code  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    p_circuls   out T_Circul_Cursor);
   procedure cir_edtion_bind_p (
    pcomp_code  in varchar2,
    ppubl_code  in varchar2,
    pedtn_code  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    p_circuls   out T_Circul_Cursor);

   procedure cir_mian_edtion_bind_p (
    pcomp_code  in varchar2,
    ppubl_code  in varchar2,
    pedtn_code  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    p_circuls   out T_Circul_Cursor);
   procedure cir_sub_edtion_bind_p (
    pcomp_code       in varchar2,
    ppubl_code       in varchar2,
    pedtn_code       in varchar2,
    psubedtn_code    in varchar2,
    pdateformat      in varchar2,
    pextra1          in varchar2,
    pextra2          in varchar2,
    p_circuls        out T_Circul_Cursor);
procedure cir_mian_edtion_pick_bind_p (
   pcomp_code       in varchar2,
   ppubl_code       in varchar2,
   pedtn_code       in varchar2,
   pdateformat      in varchar2,
   pextra1          in varchar2,
   pextra2          in varchar2,
   p_circuls        out T_Circul_Cursor);
   procedure cir_main_edition_bind_p (
    pcomp_code  in varchar2,
    ppubl_code  in varchar2,
    pedtn_code  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    p_circuls   out T_Circul_Cursor); 
    
    procedure cir_sub_edition_bind_p (
    pcomp_code       in varchar2,
    ppubl_code       in varchar2,
    pedtn_code       in varchar2,
    psubedtn_code    in varchar2,
    pdateformat      in varchar2,
    pextra1          in varchar2,
    pextra2          in varchar2,
    p_circuls        out T_Circul_Cursor); 
End cir_edtion_bind;
/

CREATE OR REPLACE PACKAGE BODY cir_edtion_bind is
   procedure cir_edtion_bind_p (
    pcomp_code  in varchar2,
    ppubl_code  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    p_circuls   out T_Circul_Cursor) as
   Begin
      open p_circuls for
         select * from cir_edtn_mast
                 where comp_code = pcomp_code and
                      (publ=ppubl_code or ppubl_code is null) and
                       nvl(freeze_flag,'N')='N' and edtn<>main_edtn and
                       ((upper(edtn_name) like upper(pextra1)||'%') or (pextra1 is null))
                       and (unit_code=pextra2 or pextra2 is null)
                 order by edtn_name;
   End cir_edtion_bind_p;

   procedure cir_edtion_bind_p (
    pcomp_code  in varchar2,
    ppubl_code  in varchar2,
    pedtn_code  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    p_circuls   out T_Circul_Cursor) as
   Begin
      open p_circuls for
         select * from cir_edtn_mast
                 where comp_code = pcomp_code and
                       publ = ppubl_code and
                       (edtn=pedtn_code or pedtn_code is null) and
                       nvl(freeze_flag,'N')='N' and (unit_code=pextra2 or pextra2 is null)
                       order by edtn_name;
   End cir_edtion_bind_p;
   
   procedure cir_mian_edtion_bind_p (
    pcomp_code  in varchar2,
    ppubl_code  in varchar2,
    pedtn_code  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    p_circuls   out T_Circul_Cursor)
   As
   Begin
        open p_circuls for
        select * from cir_edtn_mast
            where comp_code = pcomp_code and (unit_code=pextra1 or pextra1 is null) and publ = ppubl_code and
                    (edtn=pedtn_code or pedtn_code is null) and edtn=main_edtn and (upper(edtn_name) like upper(pextra2)||'%' or pextra2 is null)
                    and nvl(freeze_flag,'N')='N' 
        order by edtn_name;

   End cir_mian_edtion_bind_p;
   
   procedure cir_sub_edtion_bind_p (
    pcomp_code      in varchar2,
    ppubl_code      in varchar2,
    pedtn_code      in varchar2,
    psubedtn_code   in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    p_circuls       out T_Circul_Cursor)
   As
   Begin
        open p_circuls for
        select * from cir_edtn_mast
            where comp_code = pcomp_code and publ = ppubl_code and
                    (edtn=psubedtn_code or psubedtn_code is null) and (main_edtn=pedtn_code or pedtn_code is null) and
                    edtn<>main_edtn and
        nvl(freeze_flag,'N')='N' and (unit_code=pextra2 or pextra2 is null)
        order by edtn_name;

   End cir_sub_edtion_bind_p;

   procedure cir_mian_edtion_pick_bind_p (
   pcomp_code       in varchar2,
   ppubl_code       in varchar2,
   pedtn_code       in varchar2,
   pdateformat      in varchar2,
   pextra1          in varchar2,
   pextra2          in varchar2,
   p_circuls        out T_Circul_Cursor)
   As
   Begin
        open p_circuls for
        select * from cir_edtn_mast
            where comp_code = pcomp_code and publ = ppubl_code and
                    edtn in (select main_edtn from cir_edtn_mast where comp_code = pcomp_code and publ = ppubl_code and
                         edtn<>nvl(main_edtn,'/') and edtn=pedtn_code) and
                       nvl(freeze_flag,'N')='N' and (unit_code=pextra2 or pextra2 is null)
        order by edtn_seq_no;

   End cir_mian_edtion_pick_bind_p;
   
   procedure cir_main_edition_bind_p (
    pcomp_code  in varchar2,
    ppubl_code  in varchar2,
    pedtn_code  in varchar2,
    pdateformat in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2,
    p_circuls   out T_Circul_Cursor)
   As
   Begin
        open p_circuls for
        select * from cir_edtn_mast
            where comp_code = pcomp_code and (unit_code=pextra1 or pextra1 is null) and --publ = ppubl_code and
                    (edtn=pedtn_code or pedtn_code is null) and edtn=main_edtn and (upper(edtn_name) like upper(pextra2)||'%' or pextra2 is null)
                    and nvl(freeze_flag,'N')='N' 
        order by edtn_name;

   End cir_main_edition_bind_p;
   
   procedure cir_sub_edition_bind_p (
    pcomp_code      in varchar2,
    ppubl_code      in varchar2,
    pedtn_code      in varchar2,
    psubedtn_code   in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    p_circuls       out T_Circul_Cursor)
   As
   Begin
        open p_circuls for
        select * from cir_edtn_mast where comp_code = pcomp_code 
        -- and publ = ppubl_code and (edtn=psubedtn_code or psubedtn_code is null) and (main_edtn=pedtn_code or pedtn_code is null) 
        and edtn<>main_edtn and nvl(freeze_flag,'N')='N' and (unit_code=pextra2 or pextra2 is null)
        order by edtn_name;

   End cir_sub_edition_bind_p;
End cir_edtion_bind;
/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////




/************************************RAHUL 4 JAN 2012***************************************/


CREATE OR REPLACE PACKAGE HT18JULY.cir_transporter_bind IS
  type t_accounts_type is ref cursor;
  procedure cir_transporter_bind_p(
  pcomp_code 		in varchar2,
  pdateformat 	    in varchar2,
  pextra1 			in varchar2,
  pextra2 			in varchar2,
  p_accounts 		out t_accounts_type);
  procedure cir_transporter_bind_p(
  pcomp_code 		in varchar2,
  ptpt_code 		in varchar2,
  pdateformat 	    in varchar2,
  pextra1 			in varchar2,
  pextra2 			in varchar2,
  p_accounts 		out t_accounts_type);
  
END cir_transporter_bind;
/


CREATE OR REPLACE PACKAGE BODY HT18JULY.cir_transporter_bind IS
  procedure cir_transporter_bind_p(
      pcomp_code 		in varchar2,
      pdateformat 	in varchar2,
      pextra1 			in varchar2,
      pextra2 			in varchar2,
      p_accounts 		out t_accounts_type) 
      As
  Begin
  	open p_accounts for
    	select * from CIR_TRANSPORTER_MAST
                where COMP_CODE=pcomp_code and (TRANSPORTER_NAME like pextra1||'%' OR pextra1 IS NULL)
                      order by TRANSPORTER_CODE;
  End cir_transporter_bind_p;
  
  procedure cir_transporter_bind_p(
  	  pcomp_code in varchar2,
  	  ptpt_code in varchar2,
      pdateformat in varchar2,
      pextra1 in varchar2,
      pextra2 in varchar2,
  	  p_accounts out t_accounts_type) as
      Begin
        open p_accounts for
          select * from cir_transporter_mast
                where COMP_CODE=pcomp_code and
                      (TRANSPORTER_CODE=ptpt_code or nvl(ptpt_code,'0')='0') ;
  End cir_transporter_bind_p;
END cir_transporter_bind;
/
/**********************************************************/

CREATE OR REPLACE package HT18JULY.Cir_Route_Bind is
   TYPE T_Circul_Cursor is Ref Cursor;
   procedure Cir_Route_Bind_p (
   pcompcode in varchar2,
   punitcode in varchar2,
   pdateformat in varchar2,
   pextra1 in varchar2,
   pextra2 in varchar2,
   p_circuls out T_Circul_Cursor);
   procedure Cir_Route_Bind_p (
   pcompcode in varchar2,
   punitcode in varchar2,
   prtcode in varchar2,
   pdateformat in varchar2,
   pextra1 in varchar2,
   pextra2 in varchar2,
   p_circuls out T_Circul_Cursor);
   procedure Cir_Route_Bind_pm (
   pcompcode in varchar2,
   punitcode in varchar2,
   prmode in varchar2,
   pdateformat in varchar2,
   pextra1 in varchar2,
   pextra2 in varchar2,
   p_circuls out T_Circul_Cursor);
End Cir_Route_Bind;
/




CREATE OR REPLACE package BODY HT18JULY.Cir_Route_Bind is
   Procedure Cir_Route_Bind_p (
   	pcompcode in varchar2,
   	punitcode in varchar2,
    pdateformat in varchar2,
    pextra1 in varchar2,
    pextra2 in varchar2,
   	p_circuls out T_Circul_Cursor) as
   Begin
   	open p_circuls for
   	     select * from cir_route_mast
   	         where comp_code=pcompcode and 
                   unit=punitcode and
                   nvl(freeze_flag,'N')='N' and ((upper("ROUTE_NAME") like upper(pextra1)||'%') or (pextra1 is null))
   	         order by route_name;
   End Cir_Route_Bind_p;
   Procedure Cir_Route_Bind_p (
   	pcompcode in varchar2,
   	punitcode in varchar2,
   	prtcode in varchar2,
    pdateformat in varchar2,
    pextra1 in varchar2,
    pextra2 in varchar2,
   	p_circuls out T_Circul_Cursor) as
   Begin
   	open p_circuls for
   	     select * from cir_route_mast
   	         where COMP_CODE=pcompcode and 
                   UNIT=punitcode and 
                   (route_code=prtcode or nvl(prtcode,'0')='0')
                    and ((upper("ROUTE_NAME") like upper(pextra1)||'%') or (pextra1 is null))
                    and
                   nvl(freeze_flag,'N')='N'
   	         order by ROUTE_NAME;
   End Cir_Route_Bind_p;
   
   Procedure Cir_Route_Bind_pm (
   	pcompcode 	in varchar2,
   	punitcode 	in varchar2,
    prmode 			in varchar2,
    pdateformat in varchar2,
    pextra1 		in varchar2,
    pextra2 		in varchar2,
   	p_circuls 	out T_Circul_Cursor) as
   Begin
   	open p_circuls for
   	     select cir_route_mast.*,cir_get_drop_point_name(cir_route_mast.comp_code,cir_route_mast.unit,cir_route_mast.start_point,1) start_drop_point_name,
   	     cir_get_drop_point_name(cir_route_mast.comp_code,cir_route_mast.unit,cir_route_mast.end_point,1) end_drop_point_name,CIR_GET_ROUTE_mode(cir_route_mast.comp_code,cir_route_mast.ROUTE_MODE) as Route_Mode_Name
   	     from cir_route_mast
   	         where comp_code=pcompcode and 
                   unit=punitcode and
                   ((route_mode=prmode) or (prmode is null))
   	         order by cir_route_mast.route_mode,route_name;
   End Cir_Route_Bind_pm;
End Cir_Route_Bind;
/





  
  /*******************************************************************/
  
  
  CREATE OR REPLACE PACKAGE HT18JULY.Cir_SubRoute_Bind is
  TYPE T_Circul_Cursor is Ref Cursor;
    Procedure Cir_SubRoute_Bind_p (
        pcompcode   in varchar2,
        punitcode   in varchar2,
        proutecode  in varchar2,
        pdateformat in varchar2,
        pextra1     in varchar2,
        pextra2     in varchar2,
        p_circuls   out T_Circul_Cursor);
        
    Procedure Cir_SubRoute_Bind_p (
        pcompcode   in varchar2,
        punitcode   in varchar2,
        proutecode  in varchar2,
        psubrtcode  in varchar2,
        pdateformat in varchar2,
        pextra1     in varchar2,
        pextra2     in varchar2,
        p_circuls   out T_Circul_Cursor);
    Procedure Cir_SubRoute_Bind_p (
        pcompcode 	in varchar2,
        punitcode 	in varchar2,
        pdateformat in varchar2,
        pextra1     in varchar2,
        pextra2     in varchar2,
        p_circuls 	out T_Circul_Cursor);
End Cir_SubRoute_Bind;
/



CREATE OR REPLACE PACKAGE BODY HT18JULY.Cir_SubRoute_Bind is
Procedure Cir_SubRoute_Bind_p (
    pcompcode    in varchar2,
    punitcode    in varchar2,
    proutecode   in varchar2,
    pdateformat  in varchar2,
    pextra1      in varchar2,    
    pextra2      in varchar2,
    p_circuls    out T_Circul_Cursor) as
Begin
    open p_circuls for
 	select * from cir_sub_route_mast
        where comp_code=pcompcode and
            unit=punitcode and
 		    ((route_code=proutecode)  or (proutecode is null)) and 
            ((upper(subrt_name) like upper(pextra1)||'%') or (pextra1 is null)) and 
            nvl(freeze_flag,'N')='N'
            order by route_code,subrt_code;
End Cir_SubRoute_Bind_p;

Procedure Cir_SubRoute_Bind_p (
    pcompcode        in varchar2,
    punitcode        in varchar2,
    proutecode       in varchar2,
    psubrtcode       in varchar2,
    pdateformat      in varchar2,
    pextra1          in varchar2,
    pextra2          in varchar2,
    p_circuls        out T_Circul_Cursor) as
Begin
 	open p_circuls for
    select a.comp_code comp_code,a.unit unit,a.route_code route_code,cir_get_route_name(a.comp_code,a.unit,a.route_code) route_name,a.subrt_code subrt_code,
           a.subrt_name subrt_name,a.subrt_name_oth_lang subrt_name_oth_lang,a.subrt_mode subrt_mode,
           (select b.mode_desc from cir_route_mode_mast b where b.comp_code=a.comp_code and b.mode_code=a.subrt_mode) as mode_name,
           a.start_point start_point,a.end_point end_point,a.subrt_dist subrt_dist,a.subrt_seq subrt_seq,
           (select c.drop_point_name from cir_drop_point_mast c	where a.comp_code=c.comp_code and a.unit=c.unit_code and a.start_point=c.drop_point) start_drop_point_name,
           (select d.drop_point_name from cir_drop_point_mast d	where a.comp_code=d.comp_code and a.unit=d.unit_code and a.end_point=d.drop_point) end_drop_point_name
       from cir_sub_route_mast a
       where a.comp_code=pcompcode and
             a.unit=punitcode and
             (a.route_code=proutecode or nvl(proutecode,'0')='0') and
             (a.subrt_code=psubrtcode or nvl(psubrtcode,'0')='0')
              and ((upper(subrt_name) like upper(pextra1)||'%') or (pextra1 is null))
              and (a.subrt_mode=pextra2 or pextra2 is null)
             --and nvl(a.freeze_flag,'N')='N'
       order by route_code,subrt_code;
End Cir_SubRoute_Bind_p;

procedure Cir_SubRoute_Bind_p (
    pcompcode        in varchar2,
    punitcode        in varchar2,
    pdateformat      in varchar2,
    pextra1          in varchar2,
    pextra2          in varchar2,
    p_circuls        out T_Circul_Cursor) as
Begin
    open p_circuls for
 	select * from cir_sub_route_mast
    where comp_code=pcompcode and
    unit=punitcode and
    nvl(freeze_flag,'N')='N'  and ((upper(subrt_name) like upper(pextra1)||'%') or (pextra1 is null))
 	order by route_code,subrt_code;
    
End Cir_SubRoute_Bind_p;
End Cir_SubRoute_Bind;
/
  
  
  
  
  

/*****************************************************************************/




CREATE OR REPLACE PACKAGE HT18JULY.Cir_SubSubRoute_bind IS
    TYPE T_Circul_Cursor is Ref Cursor;
Procedure Cir_SubSubRoute_Bind_p (
    pcompcode 	    in varchar2,
    punitcode 	    in varchar2,
    proutecode 	    in varchar2,
    psubrtcode 	    in varchar2,
    pdateformat     in varchar2,
    pextra1 	    in varchar2,
    pextra2 	    in varchar2,
    p_circuls 	    out T_Circul_Cursor);
Procedure Cir_SubSubRoute_Bind_p (
   pcompcode 	    in varchar2,
   punitcode 	    in varchar2,
   proutecode 	    in varchar2,
   psubrtcode 	    in varchar2,
   psubsubrtcode    in varchar2,
   pdateformat 	    in varchar2,
   pextra1 			in varchar2,
   pextra2 			in varchar2,
   p_circuls 		out T_Circul_Cursor);
procedure Cir_SubSubRoute_Bind_p (
   pcompcode 		in varchar2,
   punitcode 		in varchar2,
   pdateformat	    in varchar2,
   pextra1 			in varchar2,
   pextra2 			in varchar2,
   p_circuls 		out T_Circul_Cursor);
End Cir_SubSubRoute_Bind;
/



CREATE OR REPLACE PACKAGE BODY HT18JULY.Cir_SubSubRoute_bind IS
Procedure Cir_SubSubRoute_Bind_p (
    pcompcode       in varchar2,
    punitcode 		in varchar2,
    proutecode 	    in varchar2,
    psubrtcode 	    in varchar2,
    pdateformat 	in varchar2,
    pextra1 		in varchar2,
    pextra2 		in varchar2,
    p_circuls 		out T_Circul_Cursor)
As 
Begin
  	open p_circuls for
  	    select cir_sub_subroute_mast.* ,cir_get_route_rep(cir_sub_subroute_mast.comp_code,cir_sub_subroute_mast.UNIT,cir_sub_subroute_mast.ROUTE_CODE) as route_name,cir_get_subroute_rep(cir_sub_subroute_mast.comp_code,cir_sub_subroute_mast.UNIT,cir_sub_subroute_mast.ROUTE_CODE,cir_sub_subroute_mast.SUBRT_CODE) as Route_sub_name from cir_sub_subroute_mast  
            where comp_code=pcompcode and 
                  unit=punitcode and
  	              (route_code=proutecode or proutecode is null) and 
                  (subrt_code=psubrtcode or psubrtcode is null) and
                  nvl(freeze_flag,'N')='N' 
            order by route_code,subrt_code,sub_subrt_code;
End	Cir_SubSubRoute_Bind_p;
  
Procedure Cir_SubSubRoute_Bind_p (
    pcompcode       in varchar2,
    punitcode 		in varchar2,
    proutecode 		in varchar2,
    psubrtcode 		in varchar2,
    psubsubrtcode 	in varchar2,
    pdateformat 	in varchar2,
    pextra1 		in varchar2,
    pextra2 		in varchar2,
    p_circuls 		out T_Circul_Cursor) 
As
Begin
  	open p_circuls for
  	    select cir_sub_subroute_mast.*,cir_get_route_name(cir_sub_subroute_mast.comp_code,cir_sub_subroute_mast.unit,cir_sub_subroute_mast.route_code) "ROUTE NAME",
  	    cir_get_subroute_name(cir_sub_subroute_mast.comp_code,cir_sub_subroute_mast.unit,cir_sub_subroute_mast.route_code,cir_sub_subroute_mast.subrt_code) "SUBROUTE NAME",
  	    cir_get_drop_point_name(cir_sub_subroute_mast.comp_code,cir_sub_subroute_mast.unit,cir_sub_subroute_mast.start_point,1) start_drop_point_name,
   	    cir_get_drop_point_name(cir_sub_subroute_mast.comp_code,cir_sub_subroute_mast.unit,cir_sub_subroute_mast.end_point,1) end_drop_point_name,
        sub_subrt_mode, (select b.mode_desc from cir_route_mode_mast b where b.comp_code=cir_sub_subroute_mast.comp_code and b.mode_code=cir_sub_subroute_mast.sub_subrt_mode) as mode_name
  	    from cir_sub_subroute_mast 
              where comp_code=pcompcode and 
                    unit=punitcode and
  	                (route_code=proutecode OR proutecode is null) and 
                    (subrt_code=psubrtcode or psubrtcode is null) and 
                    (sub_subrt_code=psubsubrtcode or nvl(psubsubrtcode,'0')='0')
                    and ((upper(SUB_SUBRT_NAME) like upper(pextra1||'%')) or (pextra1 is null))
                    and (sub_subrt_mode=pextra2 or pextra2 is null)
                     /*and
                    nvl(freeze_flag,'N')='N'*/
  	          order by route_code,subrt_code,sub_subrt_code;
End Cir_SubSubRoute_Bind_p;
 
procedure  Cir_SubSubRoute_Bind_p (
    pcompcode 		in varchar2,
    punitcode 		in varchar2,
    pdateformat 	in varchar2,
    pextra1 		in varchar2,
    pextra2 		in varchar2,
    p_circuls 		out T_Circul_Cursor)
  As
  Begin
  	open p_circuls for
  	   select * from cir_sub_subroute_mast 
            where comp_code=pcompcode and 
                  unit=punitcode and
                  nvl(freeze_flag,'N')='N'
            order by route_code,subrt_code,sub_subrt_code;
  End	Cir_SubSubRoute_Bind_p;
End Cir_SubSubRoute_Bind;
/







   
   /*******************************END OF RAHUL 4 JAN 2012********************************/
//////////////////////update by Garima

CREATE OR REPLACE PROCEDURE cir_rep_inct_detail(
      pcompcode         in varchar2,
      punitcode         in varchar2,
      pbrancode         in varchar2,
      ppublcode         in varchar2,
      pagcd             in varchar2,
      pdpcd             in varchar2,
      pagtype           in varchar2,
      pstate_code       in varchar2,
      pdist_code        in varchar2,
      pcity_code        in varchar2,
      pfrom_dt          in varchar2,
      ptill_dt          in varchar2,
      pbreakon          in varchar2,--1 for Agency Type,2 for Agency Name
      preptype          in varchar2,--D for Detail ,M Monthly Summary,S for Summary
      pdateformat       in varchar2,
      puserid           in varchar2,
      pextra1           in varchar2,
      pextra2           in varchar2,
      pextra3           in varchar2,
      pextra4           in varchar2,
      pextra5           in varchar2,
      p_accounts        OUT Cur_Type_New1.cursor_type,
      p_accounts1       OUT Cur_Type_New1.cursor_type,
      p_accounts2       OUT Cur_Type_New1.cursor_type,
      p_accounts3       OUT Cur_Type_New1.cursor_type)
    As
      v_frdt         date;
      v_todt         date;

  Begin
        v_frdt    :=to_date(pfrom_dt,''''||pdateformat||'''');
        v_todt    :=to_date(ptill_dt,''''||pdateformat||'''');
        
        
            If pbreakon='1' then--for agency type wise
                if preptype='D' then--details
                    
                    open p_accounts for
                    select d.comp_code as "COMP_CODE", d.unit_code as "UNIT_CODE", d.recptdt as "RECPTDT", d.recptno as "RECPTNO",
                    d.publ_code as "PUBL_CODE", cir_get_publ_name(d.comp_code,d.publ_code) as "PUBL_NAME", d.bilagcd as "AGCD", d.bildpcd as "DPCD",
                    m.ag_name as "AG_NAME",cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME", 
                    cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",cir_get_state(d.comp_code,m.country_code, m.state_code) as "STATE_NAME",
                    cir_get_dist(d.comp_code,m.state_code,m.dist_code) as "DIST_NAME",
                    m.ag_type as "AG_TYPE",(select agency_type_desc from cir_agency_typ_mast where comp_code=d.comp_code and agency_type_code=m.ag_type) as "AGENCY_TYPE_NAME",
                    sum(d.tot_supply) as "TOT_SUPPLY", 
                    sum(d.amount) as "AMOUNT",  sum(d.no_of_days) as "NO_OF_DAYS"
                    from cir_inct_process_det d,cir_agmast m
                    where d.comp_code=m.comp_code and d.comp_code=pcompcode and d.unit_code=m.unit and  d.unit_code=nvl(punitcode,d.unit_code) and 
                    d.bilagcd=m.agcd and d.bilagcd=nvl(pagcd,d.bilagcd) 
                    and d.bildpcd=m.dpcd 
                    and d.bildpcd=nvl(pdpcd,d.bildpcd) 
                    and                    d.doctype='CN' and d.recptdt between v_frdt and v_todt and d.publ_code=nvl(ppublcode,d.publ_code) and d.tran_type='INC' and 
                    (m.branch_code=pbrancode or pbrancode is null) and (m.state_code=pstate_code or pstate_code is null) and 
                    (m.dist_code=pdist_code or pdist_code is null) and (m.city_code=pcity_code or pcity_code is null) and 
                    (m.state_code=pstate_code or pstate_code is null)
                    group by d.comp_code , d.unit_code , d.recptdt, d.recptno,d.publ_code, d.bilagcd, d.bildpcd,m.ag_name,m.station_code, 
                    m.city_code,m.country_code, m.state_code,m.dist_code,m.ag_type
                    order by comp_code,unit_code,agency_type_name,recptdt,recptno;
                    
                    open p_accounts1 for
                    select d.comp_code as "COMP_CODE", d.unit_code as "UNIT_CODE", m.ag_type as "AG_TYPE",(select agency_type_desc from cir_agency_typ_mast where comp_code=d.comp_code and agency_type_code=m.ag_type) as "AGENCY_TYPE_NAME",
                    sum(d.tot_supply) as "TOT_SUPPLY", sum(d.amount) as "AMOUNT",  sum(d.no_of_days) as "NO_OF_DAYS"
                    from cir_inct_process_det d,cir_agmast m
                    where d.comp_code=m.comp_code and d.comp_code=pcompcode and d.unit_code=m.unit and  d.unit_code=nvl(punitcode,d.unit_code) and 
                    d.bilagcd=m.agcd and d.bilagcd=nvl(pagcd,d.bilagcd) and d.bildpcd=m.dpcd and d.bildpcd=nvl(pdpcd,d.bildpcd) and 
                    d.doctype='CN' and d.recptdt between v_frdt and v_todt and d.publ_code=nvl(ppublcode,d.publ_code) and d.tran_type='INC' and 
                    (m.branch_code=pbrancode or pbrancode is null) and (m.state_code=pstate_code or pstate_code is null) and 
                    (m.dist_code=pdist_code or pdist_code is null) and (m.city_code=pcity_code or pcity_code is null) and 
                    (m.state_code=pstate_code or pstate_code is null)
                    group by d.comp_code , d.unit_code , d.recptdt, d.recptno,d.publ_code, d.bilagcd, d.bildpcd,m.ag_name,m.station_code, 
                    m.city_code,m.country_code, m.state_code,m.dist_code,m.ag_type
                    order by comp_code,unit_code,agency_type_name;
                    
                elsif preptype='S' then--summary
                    
                    open p_accounts for
                    select d.comp_code as "COMP_CODE", d.unit_code as "UNIT_CODE", 
                    m.ag_type as "AG_TYPE",(select agency_type_desc from cir_agency_typ_mast where comp_code=d.comp_code and agency_type_code=m.ag_type) as "AGENCY_TYPE_NAME",
                    sum(d.tot_supply) as "TOT_SUPPLY", sum(d.amount) as "AMOUNT",  sum(d.no_of_days) as "NO_OF_DAYS"
                    from cir_inct_process_det d,cir_agmast m
                    where d.comp_code=m.comp_code and d.comp_code=pcompcode and d.unit_code=m.unit and  d.unit_code=nvl(punitcode,d.unit_code) and 
                    d.bilagcd=m.agcd and d.bilagcd=nvl(pagcd,d.bilagcd) and d.bildpcd=m.dpcd and d.bildpcd=nvl(pdpcd,d.bildpcd) and 
                    d.doctype='CN' and d.recptdt between v_frdt and v_todt and d.publ_code=nvl(ppublcode,d.publ_code) and d.tran_type='INC' and 
                    (m.branch_code=pbrancode or pbrancode is null) and (m.state_code=pstate_code or pstate_code is null) and 
                    (m.dist_code=pdist_code or pdist_code is null) and (m.city_code=pcity_code or pcity_code is null) and 
                    (m.state_code=pstate_code or pstate_code is null)
                    group by d.comp_code , d.unit_code , m.ag_type
                    order by comp_code,unit_code,agency_type_name;
                    
                    open p_accounts1 for
                    select d.comp_code as "COMP_CODE", d.unit_code as "UNIT_CODE", 
                    sum(d.tot_supply) as "TOT_SUPPLY", sum(d.amount) as "AMOUNT",  sum(d.no_of_days) as "NO_OF_DAYS"
                    from cir_inct_process_det d,cir_agmast m
                    where d.comp_code=m.comp_code and d.comp_code=pcompcode and d.unit_code=m.unit and  d.unit_code=nvl(punitcode,d.unit_code) and 
                    d.bilagcd=m.agcd and d.bilagcd=nvl(pagcd,d.bilagcd) and d.bildpcd=m.dpcd and d.bildpcd=nvl(pdpcd,d.bildpcd) and 
                    d.doctype='CN' and d.recptdt between v_frdt and v_todt and d.publ_code=nvl(ppublcode,d.publ_code) and d.tran_type='INC' and 
                    (m.branch_code=pbrancode or pbrancode is null) and (m.state_code=pstate_code or pstate_code is null) and 
                    (m.dist_code=pdist_code or pdist_code is null) and (m.city_code=pcity_code or pcity_code is null) and 
                    (m.state_code=pstate_code or pstate_code is null)
                    group by d.comp_code , d.unit_code , d.recptdt, d.recptno,d.publ_code, d.bilagcd, d.bildpcd,m.ag_name,m.station_code, 
                    m.city_code,m.country_code, m.state_code,m.dist_code,m.ag_type
                    order by comp_code,unit_code;
                    
                else--for Monthly summary
                    
                    open p_accounts for
                    select d.comp_code as "COMP_CODE", d.unit_code as "UNIT_CODE",to_char(last_day(d.recptdt),'MONTH-YYYY') as "MONTH_YEAR",
                    m.ag_type as "AG_TYPE",(select agency_type_desc from cir_agency_typ_mast where comp_code=d.comp_code and agency_type_code=m.ag_type) as "AGENCY_TYPE_NAME",
                    sum(d.tot_supply) as "TOT_SUPPLY", sum(d.amount) as "AMOUNT",  sum(d.no_of_days) as "NO_OF_DAYS"
                    from cir_inct_process_det d,cir_agmast m
                    where d.comp_code=m.comp_code and d.comp_code=pcompcode and d.unit_code=m.unit and  d.unit_code=nvl(punitcode,d.unit_code) and 
                    d.bilagcd=m.agcd and d.bilagcd=nvl(pagcd,d.bilagcd) and d.bildpcd=m.dpcd and d.bildpcd=nvl(pdpcd,d.bildpcd) and 
                    d.doctype='CN' and d.recptdt between v_frdt and v_todt and d.publ_code=nvl(ppublcode,d.publ_code) and d.tran_type='INC' and 
                    (m.branch_code=pbrancode or pbrancode is null) and (m.state_code=pstate_code or pstate_code is null) and 
                    (m.dist_code=pdist_code or pdist_code is null) and (m.city_code=pcity_code or pcity_code is null) and 
                    (m.state_code=pstate_code or pstate_code is null)
                    group by d.comp_code , d.unit_code , to_char(last_day(d.recptdt),'MONTH-YYYY'),m.ag_type
                    order by comp_code,unit_code,agency_type_name,recptdt,recptno;
                    
                    open p_accounts1 for
                    select d.comp_code as "COMP_CODE", d.unit_code as "UNIT_CODE", 
                    sum(d.tot_supply) as "TOT_SUPPLY", sum(d.amount) as "AMOUNT",  sum(d.no_of_days) as "NO_OF_DAYS"
                    from cir_inct_process_det d,cir_agmast m
                    where d.comp_code=m.comp_code and d.comp_code=pcompcode and d.unit_code=m.unit and  d.unit_code=nvl(punitcode,d.unit_code) and 
                    d.bilagcd=m.agcd and d.bilagcd=nvl(pagcd,d.bilagcd) and d.bildpcd=m.dpcd and d.bildpcd=nvl(pdpcd,d.bildpcd) and 
                    d.doctype='CN' and d.recptdt between v_frdt and v_todt and d.publ_code=nvl(ppublcode,d.publ_code) and d.tran_type='INC' and 
                    (m.branch_code=pbrancode or pbrancode is null) and (m.state_code=pstate_code or pstate_code is null) and 
                    (m.dist_code=pdist_code or pdist_code is null) and (m.city_code=pcity_code or pcity_code is null) and 
                    (m.state_code=pstate_code or pstate_code is null)
                    group by d.comp_code , d.unit_code,d.bilagcd , d.bildpcd,m.ag_name
                    order by comp_code,unit_code;
                                    
                end if;                    
            else--for agency wise
                if preptype='D' then--details
                    open p_accounts for
                    select d.comp_code as "COMP_CODE", d.unit_code as "UNIT_CODE", d.recptdt as "RECPTDT", d.recptno as "RECPTNO",
                    d.publ_code as "PUBL_CODE", cir_get_publ_name(d.comp_code,d.publ_code) as "PUBL_NAME", d.bilagcd as "AGCD", d.bildpcd as "DPCD",
                    m.ag_name as "AG_NAME",cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME", 
                    cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",cir_get_state(d.comp_code,m.country_code, m.state_code) as "STATE_NAME",
                    cir_get_dist(d.comp_code,m.state_code,m.dist_code) as "DIST_NAME",
                    m.ag_type as "AG_TYPE",(select agency_type_desc from cir_agency_typ_mast where comp_code=d.comp_code and agency_type_code=m.ag_type) as "AGENCY_TYPE_NAME",
                    sum(d.tot_supply) as "TOT_SUPPLY", 
                    sum(d.amount) as "AMOUNT",  sum(d.no_of_days) as "NO_OF_DAYS"
                    from cir_inct_process_det d,cir_agmast m
                    where d.comp_code=m.comp_code and d.comp_code=pcompcode and d.unit_code=m.unit and  d.unit_code=nvl(punitcode,d.unit_code) and 
                    d.bilagcd=m.agcd and d.bilagcd=nvl(pagcd,d.bilagcd) and d.bildpcd=m.dpcd and d.bildpcd=nvl(pdpcd,d.bildpcd) and 
                    d.doctype='CN' and d.recptdt between v_frdt and v_todt and d.publ_code=nvl(ppublcode,d.publ_code) and d.tran_type='INC' and 
                    (m.branch_code=pbrancode or pbrancode is null) and (m.state_code=pstate_code or pstate_code is null) and 
                    (m.dist_code=pdist_code or pdist_code is null) and (m.city_code=pcity_code or pcity_code is null) and 
                    (m.state_code=pstate_code or pstate_code is null)
                    group by d.comp_code , d.unit_code , d.recptdt, d.recptno,d.publ_code, d.bilagcd, d.bildpcd,m.ag_name,m.station_code, 
                    m.city_code,m.country_code, m.state_code,m.dist_code,m.ag_type
                    order by comp_code,unit_code,ag_name,recptdt,recptno;
                    
                    open p_accounts1 for
                    select d.comp_code as "COMP_CODE", d.unit_code as "UNIT_CODE", d.bilagcd as "AGCD", d.bildpcd as "DPCD",
                    m.ag_name as "AG_NAME",
                    sum(d.tot_supply) as "TOT_SUPPLY", sum(d.amount) as "AMOUNT",  sum(d.no_of_days) as "NO_OF_DAYS"
                    from cir_inct_process_det d,cir_agmast m
                    where d.comp_code=m.comp_code and d.comp_code=pcompcode and d.unit_code=m.unit and  d.unit_code=nvl(punitcode,d.unit_code) and 
                    d.bilagcd=m.agcd and d.bilagcd=nvl(pagcd,d.bilagcd) and d.bildpcd=m.dpcd and d.bildpcd=nvl(pdpcd,d.bildpcd) and 
                    d.doctype='CN' and d.recptdt between v_frdt and v_todt and d.publ_code=nvl(ppublcode,d.publ_code) and d.tran_type='INC' and 
                    (m.branch_code=pbrancode or pbrancode is null) and (m.state_code=pstate_code or pstate_code is null) and 
                    (m.dist_code=pdist_code or pdist_code is null) and (m.city_code=pcity_code or pcity_code is null) and 
                    (m.state_code=pstate_code or pstate_code is null)
                    group by d.comp_code , d.unit_code ,d.bilagcd , d.bildpcd,m.ag_name
                    order by comp_code,unit_code,ag_name;    
                    
                elsif preptype='S' then--summary

                    open p_accounts for
                    select d.comp_code as "COMP_CODE", d.unit_code as "UNIT_CODE", d.bilagcd as "AGCD", d.bildpcd as "DPCD",
                    m.ag_name as "AG_NAME",cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME", 
                    cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",cir_get_state(d.comp_code,m.country_code, m.state_code) as "STATE_NAME",
                    cir_get_dist(d.comp_code,m.state_code,m.dist_code) as "DIST_NAME",
                    m.ag_type as "AG_TYPE",(select agency_type_desc from cir_agency_typ_mast where comp_code=d.comp_code and agency_type_code=m.ag_type) as "AGENCY_TYPE_NAME",
                    sum(d.tot_supply) as "TOT_SUPPLY", sum(d.amount) as "AMOUNT",  sum(d.no_of_days) as "NO_OF_DAYS"
                    from cir_inct_process_det d,cir_agmast m
                    where d.comp_code=m.comp_code and d.comp_code=pcompcode and d.unit_code=m.unit and  d.unit_code=nvl(punitcode,d.unit_code) and 
                    d.bilagcd=m.agcd and d.bilagcd=nvl(pagcd,d.bilagcd) and d.bildpcd=m.dpcd and d.bildpcd=nvl(pdpcd,d.bildpcd) and 
                    d.doctype='CN' and d.recptdt between v_frdt and v_todt and d.publ_code=nvl(ppublcode,d.publ_code) and d.tran_type='INC' and 
                    (m.branch_code=pbrancode or pbrancode is null) and (m.state_code=pstate_code or pstate_code is null) and 
                    (m.dist_code=pdist_code or pdist_code is null) and (m.city_code=pcity_code or pcity_code is null) and 
                    (m.state_code=pstate_code or pstate_code is null)
                    group by d.comp_code , d.unit_code , d.bilagcd, d.bildpcd,m.ag_name,m.station_code, 
                    m.city_code,m.country_code, m.state_code,m.dist_code,m.ag_type
                    order by comp_code,unit_code,ag_name;
                    
                    open p_accounts1 for
                    select d.comp_code as "COMP_CODE", d.unit_code as "UNIT_CODE", 
                    sum(d.tot_supply) as "TOT_SUPPLY", sum(d.amount) as "AMOUNT",  sum(d.no_of_days) as "NO_OF_DAYS"
                    from cir_inct_process_det d,cir_agmast m
                    where d.comp_code=m.comp_code and d.comp_code=pcompcode and d.unit_code=m.unit and  d.unit_code=nvl(punitcode,d.unit_code) and 
                    d.bilagcd=m.agcd and d.bilagcd=nvl(pagcd,d.bilagcd) and d.bildpcd=m.dpcd and d.bildpcd=nvl(pdpcd,d.bildpcd) and 
                    d.doctype='CN' and d.recptdt between v_frdt and v_todt and d.publ_code=nvl(ppublcode,d.publ_code) and d.tran_type='INC' and 
                    (m.branch_code=pbrancode or pbrancode is null) and (m.state_code=pstate_code or pstate_code is null) and 
                    (m.dist_code=pdist_code or pdist_code is null) and (m.city_code=pcity_code or pcity_code is null) and 
                    (m.state_code=pstate_code or pstate_code is null)
                    group by d.comp_code , d.unit_code 
                    order by comp_code,unit_code;                
                    
                else --for Monthly summary
                                               
                    open p_accounts for
                    select d.comp_code as "COMP_CODE", d.unit_code as "UNIT_CODE",to_char(last_day(d.recptdt),'MONTH-YYYY') as "MONTH_YEAR",
                    d.bilagcd as "AGCD", d.bildpcd as "DPCD",
                    m.ag_name as "AG_NAME",cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME", 
                    cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",cir_get_state(d.comp_code,m.country_code, m.state_code) as "STATE_NAME",
                    cir_get_dist(d.comp_code,m.state_code,m.dist_code) as "DIST_NAME",
                    m.ag_type as "AG_TYPE",(select agency_type_desc from cir_agency_typ_mast where comp_code=d.comp_code and agency_type_code=m.ag_type) as "AGENCY_TYPE_NAME",
                    sum(d.tot_supply) as "TOT_SUPPLY", sum(d.amount) as "AMOUNT",  sum(d.no_of_days) as "NO_OF_DAYS"
                    from cir_inct_process_det d,cir_agmast m
                    where d.comp_code=m.comp_code and d.comp_code=pcompcode and d.unit_code=m.unit and  d.unit_code=nvl(punitcode,d.unit_code) and 
                    d.bilagcd=m.agcd and d.bilagcd=nvl(pagcd,d.bilagcd) and d.bildpcd=m.dpcd and d.bildpcd=nvl(pdpcd,d.bildpcd) and 
                    d.doctype='CN' and d.recptdt between v_frdt and v_todt and d.publ_code=nvl(ppublcode,d.publ_code) and d.tran_type='INC' and 
                    (m.branch_code=pbrancode or pbrancode is null) and (m.state_code=pstate_code or pstate_code is null) and 
                    (m.dist_code=pdist_code or pdist_code is null) and (m.city_code=pcity_code or pcity_code is null) and 
                    (m.state_code=pstate_code or pstate_code is null)
                    group by d.comp_code , d.unit_code , to_char(last_day(d.recptdt),'MONTH-YYYY'),
                    d.bilagcd, d.bildpcd,m.ag_name,m.station_code, m.city_code,m.country_code, m.state_code,m.dist_code,m.ag_type
                    order by comp_code,unit_code,agency_type_name;
                    --,recptdt,recptno;
                    
                    open p_accounts1 for
                    select d.comp_code as "COMP_CODE", d.unit_code as "UNIT_CODE", 
                    sum(d.tot_supply) as "TOT_SUPPLY", sum(d.amount) as "AMOUNT",  sum(d.no_of_days) as "NO_OF_DAYS"
                    from cir_inct_process_det d,cir_agmast m
                    where d.comp_code=m.comp_code and d.comp_code=pcompcode and d.unit_code=m.unit and  d.unit_code=nvl(punitcode,d.unit_code) and 
                    d.bilagcd=m.agcd and d.bilagcd=nvl(pagcd,d.bilagcd) and d.bildpcd=m.dpcd and d.bildpcd=nvl(pdpcd,d.bildpcd) and 
                    d.doctype='CN' and d.recptdt between v_frdt and v_todt and d.publ_code=nvl(ppublcode,d.publ_code) and d.tran_type='INC' and 
                    (m.branch_code=pbrancode or pbrancode is null) and (m.state_code=pstate_code or pstate_code is null) and 
                    (m.dist_code=pdist_code or pdist_code is null) and (m.city_code=pcity_code or pcity_code is null) and 
                    (m.state_code=pstate_code or pstate_code is null)
                    group by d.comp_code , d.unit_code
                    order by comp_code,unit_code;
                                    
                End if;
            End if;     

        open p_accounts2 for select sysdate as "CUR_DATE" from dual;

        open p_accounts3 for select sysdate as "CUR_DATE" from dual;

    End cir_rep_inct_detail;
/




/////////////////////////////////////////////////////Bank Guaranee 04/01/2012//////////////////////////////////////////////



CREATE OR REPLACE PROCEDURE HT18JULY.cir_bank_guarantee_bind(
   pcomp_code     IN       VARCHAR2,
   pagcd          IN       VARCHAR2,
   pdpcd          IN       VARCHAR2,
   pexpiry_date   IN       VARCHAR2,
   pexpiry_days   IN       NUMBER,
   pinstrument_ty IN       VARCHAR2,
   pdateformat    IN       VARCHAR2,
   pextra         IN       VARCHAR2,
   pextra1        IN       VARCHAR2,
   pextra2        IN       VARCHAR2,
   p_accounts     OUT      cur_type_new1.cursor_type
)
IS
v_dt date;
v_expdt date;
BEGIN
    v_expdt := to_date(pexpiry_date,''''||pdateformat||'''');
    v_dt    := v_expdt + nvl(pexpiry_days,0);
    
    OPEN p_accounts FOR
    SELECT b.COMP_CODE, b.UNIT_CODE, b.AGCD, b.DPCD,m.ag_name AG_NAME,CIR_GET_DROP_POINT_NAME(B.COMP_CODE,B.UNIT_CODE,M.STATION_CODE,1) DROP_POINT_NAME,
    CIR_GET_CITY(B.COMP_CODE,M.CITY_CODE) CITY_NAME, 
    b.BG_NO, b.BG_AMT, b.BG_DATE, b.BG_VALID, b.BANK_DESC, 
    b.CREATED_BY, b.CREATED_DT, b.UPDATED_BY, b.UPDATED_DT, b.BG_TYPE
    FROM cir_bank_guarantee b,cir_agmast m
    where m.comp_code =b.comp_code and m.comp_code = pcomp_code and b.unit_code=m.unit  
    and b.agcd=m.agcd and b.agcd    = nvl(pagcd,b.agcd) 
    and b.dpcd=m.dpcd and b.dpcd    = nvl(pdpcd,b.dpcd)
    and ((b.bg_type = pinstrument_ty) or (pinstrument_ty is null))
    and b.bg_valid between v_expdt and v_dt ORDER BY AG_NAME;
    
END cir_bank_guarantee_bind;
/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////