//===ADD BY DEEPIKA 09-JULY-2013 SENT BY Naman





alter table cir_unsold_hdr add SUPPLY_TY_CODE varchar2(10)



CREATE OR REPLACE PACKAGE cir_unsold_credit_note IS
  TYPE T_Circul_Cursor is Ref Cursor;
  procedure cir_unsold_supply_p(
      pcomp_code         in varchar2,
      punit_code         in varchar2,
      ppubl_code         in varchar2,
      pedtn_code         in varchar2,
      psup_fromdate      in varchar2,
      psup_todate        in varchar2,
      pagcd_code         in varchar2,
      pdpcd_code         in varchar2,
      pdateformat        in varchar2,
      pextra1            in varchar2,
      pextra2            in varchar2,
      
      preceiptdt         in varchar2,
      puserid            in varchar2:=null,
      pextra3            in varchar2,
      pextra4            in varchar2,
      pextra5            in varchar2,
      p_circuls         out T_Circul_Cursor,
      p_circuls1         out T_Circul_Cursor);
  procedure cir_unsold_check_p(
      pcomp_code         in varchar2,
      punit_code         in varchar2,
      ppubl_code         in varchar2,
      pedtn_code         in varchar2,
      psup_date         in varchar2,
      pagcd_code         in varchar2,
      pdpcd_code         in varchar2,
      pdoc_type         in varchar2,
      precptno             in varchar2,
      pmissing_recpt    in varchar2,
      plate_recpt        in varchar2,
      pbnr_recpt        in varchar2,
      punsold            in varchar2,
      pcopy_rate        in varchar2,
      pcomm_per            in varchar2,
      pcomm_type        in varchar2,
      pwaste_flag        in varchar2,
      pwaste_rate         in varchar2,
      pdateformat         in varchar2,
      pextra1             in varchar2,
      pextra2             in varchar2,
      p_circuls         out T_Circul_Cursor,
      p_circuls1         out T_Circul_Cursor);

  procedure cir_unsold_calculation_p(
      pcomp_code         in varchar2,
      punit_code         in varchar2,
      ppubl_code         in varchar2,
      pedtn_code         in varchar2,
      pmissing_recpt    in number,
      plate_recpt        in number,
      pbnr_recpt        in number,
      punsold            in number,
      pcopy_rate        in number,
      pcomm_per            in number,
      pcomm_type        in varchar2,
      pwaste_flag        in varchar2,
      pwaste_rate         in number,
      pdateformat         in varchar2,
      pextra1             in varchar2,
      pextra2             in varchar2,
      p_circuls         out T_Circul_Cursor);
      
  procedure cir_notapproval_list_p(
      pcomp_code         in varchar2,
      punit_code         in varchar2,
      pdoc_type         in varchar2,
      pdateformat         in varchar2,
      pextra1             in varchar2,
      pextra2             in varchar2,
      pextra3               in varchar2,
      p_circuls         out T_Circul_Cursor);
      
  procedure cir_notapproval_unsold_p(
      pcomp_code         in varchar2,
      punit_code         in varchar2,
      pdoc_type         in varchar2,
      precptno             in varchar2,
      pagcd_code         in varchar2,
      pdpcd_code         in varchar2,
      pdateformat         in varchar2,
      pextra1             in varchar2,
      pextra2             in varchar2,
      p_circuls         out T_Circul_Cursor);

  procedure cir_unsold_process_p(
      pcomp_code         in varchar2,
      punit_code         in varchar2,
      prec_fromdate     in varchar2,
      prec_todate         in varchar2,
      pagtype_code      in varchar2,
      pagcd_code         in varchar2,
      pdpcd_code         in varchar2,
      puserid           in varchar2,
      pdateformat         in varchar2,
      pextra1             in varchar2,
      pextra2             in varchar2,
      
      p_circuls         out T_Circul_Cursor);
      
procedure cir_unsold_supply_p_resale( 
      pcomp_code         in varchar2,
      punit_code         in varchar2,
      ppubl_code         in varchar2,
      pedtn_code         in varchar2,
      psup_fromdate      in varchar2,
      psup_todate        in varchar2,
      pagcd_code         in varchar2,
      pdpcd_code         in varchar2,
      pdateformat        in varchar2,
      pextra1            in varchar2,
      pextra2            in varchar2,
      preceiptdt         in varchar2,
      puserid            in varchar2:=null,
      pextra3            in varchar2,
      pextra4            in varchar2,
      pextra5            in varchar2,
      p_circuls         out T_Circul_Cursor,
      p_circuls1         out T_Circul_Cursor);
      
END cir_unsold_credit_note;
/






CREATE OR REPLACE PACKAGE BODY HERALD.cir_unsold_credit_note IS
procedure cir_unsold_supply_p(
    pcomp_code          in varchar2,
    punit_code          in varchar2,
    ppubl_code          in varchar2,
    pedtn_code          in varchar2,
    psup_fromdate       in varchar2,
    psup_todate         in varchar2,
    pagcd_code          in varchar2,
    pdpcd_code          in varchar2,
    pdateformat         in varchar2,
    pextra1             in varchar2,--it is use for datewise or ratewise
    pextra2             in varchar2,
    preceiptdt          in varchar2,
    puserid             in varchar2:=null,
    pextra3             in varchar2,--supplytypecode
    pextra4             in varchar2,
    pextra5             in varchar2,
    
    p_circuls           out T_Circul_Cursor,
    p_circuls1         out T_Circul_Cursor)
As
    v_frdt date;
    v_todt date;
    v_cnt VARCHAR2(500);
Begin
    v_frdt:=to_date(psup_fromdate,''''||pdateformat||'''');
    v_todt:=to_date(psup_todate,''''||pdateformat||'''');
        if upper(pextra2)='D' then
            open p_circuls for
            select comp_code,unit_code,publ,publ_name,edtn, edtn_name,supply_date, supply_date supply_datemon,
            copy_rate,comm_fix_auto_spl,comm_code,waste_rate,
            substr(comm_rate,1,1) comm_catg_type,substr(comm_rate,2,length(comm_rate)-1) comm_rate,supply_copy,rate_supply,
            RETURNABLE,per_copy_weight, "RETURNABLEper" as "RETURNABLEper" from--P30,C0.5
            (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,
            d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
            d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,cir_get_waste_rate_catg(d.comp_code,d.unit_code,d.edtn,to_char(supdate,''''||pdateformat||''''),''''||pdateformat||'''',d.waste_catg_code,null,null) waste_rate,
            cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,to_char(d.supdate,''''||pdateformat||''''),''''||pdateformat||'''',sum(d.sup_copy),'','') comm_rate,'P' comm_catg_type, 
            sum(d.sup_copy) supply_copy,
            /*(select sum(u.sup_copy) from cir_dbksup_dis u where u.comp_code=d.comp_code and u.unit_code=d.unit_code and 
            (u.publ=d.publ) and u.edtn=d.edtn and u.supdate between v_frdt and v_todt and 
            u.billagcd=pagcd_code and u.billdpcd=pdpcd_code and u.sup_rate=d.sup_rate)*/  sum(d.sup_copy) rate_supply,
            --100 as RETURNABLE,
            d.per_copy_weight per_copy_weight,d.waste_catg_code waste_catg_code
            ,cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.sup_copy),nvl(puserid,d.USERID) ,pagcd_code,pdpcd_code,'Q',d.edtn,'')  as "RETURNABLE" 
        ,cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.sup_copy),nvl(puserid,d.USERID),pagcd_code,pdpcd_code,'P',d.edtn,'')   as "RETURNABLEper"
            from cir_dbksup_dis d,cir_publ_mast p,cir_edtn_mast e
            where d.comp_code=pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
                  d.unit_code=punit_code and d.publ=p.publ and d.publ=e.publ and
                  (d.publ=ppubl_code or ppubl_code is null) and
                  d.edtn=e.edtn and (d.edtn = pedtn_code or pedtn_code is null) and
                d.supdate between v_frdt and v_todt and
               d.billagcd=pagcd_code and d.billdpcd=pdpcd_code
               and (d.SUP_TYPE_CODE=pextra3 or pextra3='' or pextra3 is null)
              --  d.agcd=pagcd_code and d.dpcd=pdpcd_code
                
                 and upper(nvl(pextra1,'D'))='D'
                group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight)
           
        
        
         union
            select distinct z.comp_code comp_code,z.unit_code unit_code,z.publ publ,z.publ_name publ_name,z.edtn,z.edtn_name edtn_name,MAX(z.supply_date) supply_date,last_day(trunc(z.supply_date,'mm')) supply_datemon,
            z.copy_rate copy_rate,z.comm_fix_auto_spl comm_fix_auto_spl,z.comm_code comm_code,z.waste_rate waste_rate,
            z.comm_catg_type comm_catg_type,z.comm_rate comm_rate,sum(z.supply_copy) supply_copy,sum(z.supply_copy) rate_supply,
            RETURNABLE,
           
            
            max(z.per_copy_weight) per_copy_weight
            ,"RETURNABLEper" as "RETURNABLEper"   from
            (select distinct comp_code,unit_code,publ,publ_name,edtn,edtn_name,supply_date,
            copy_rate,comm_fix_auto_spl,comm_code,waste_rate,
            substr(comm_rate,1,1) comm_catg_type,substr(comm_rate,2,length(comm_rate)-1) 
            comm_rate,supply_copy,rate_supply,
            RETURNABLE,per_copy_weight,"RETURNABLEper" as "RETURNABLEper" from--P30,C0.5
            (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,
            d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
            d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,cir_get_waste_rate_catg(d.comp_code,d.unit_code,d.edtn,to_char(d.supdate,''''||pdateformat||''''),''''||pdateformat||'''',d.waste_catg_code,null,null) waste_rate,
            cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,
            to_char(d.supdate,''''||pdateformat||''''),''''||pdateformat||'''',sum(d.sup_copy),'','') comm_rate,'P' comm_catg_type, sum(d.sup_copy) supply_copy,
            (select sum(u.sup_copy) from cir_dbksup_dis u where u.comp_code=d.comp_code and u.unit_code=d.unit_code and 
            (u.publ=d.publ) and u.edtn=d.edtn and u.supdate between v_frdt and v_todt and 
            u.billagcd=pagcd_code and u.billdpcd=pdpcd_code and u.sup_rate=d.sup_rate) rate_supply,
            --100 as RETURNABLE,
             cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.SUP_COPY),puserid,pagcd_code,pdpcd_code,'Q',d.edtn,'')  RETURNABLE,
            d.per_copy_weight per_copy_weight,d.waste_catg_code waste_catg_code 
            ,cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.SUP_COPY),puserid,pagcd_code,pdpcd_code,'P',d.edtn,'') as "RETURNABLEper" 
            from cir_dbksup_dis d,cir_publ_mast p,cir_edtn_mast e
            where d.comp_code=pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
                  d.unit_code=punit_code and d.publ=p.publ and d.publ=e.publ and
                  (d.publ=ppubl_code or ppubl_code is null) and
                  d.edtn=e.edtn and (d.edtn = pedtn_code or pedtn_code is null) and
                d.supdate between v_frdt and v_todt and
                d.billagcd=pagcd_code and d.billdpcd=pdpcd_code 
               --  d.agcd=pagcd_code and d.dpcd=pdpcd_code
                and 
                upper(nvl(pextra1,'D'))='R'
                   and (d.SUP_TYPE_CODE=pextra3 or pextra3='' or pextra3 is null)
                group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,
                d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight,d.waste_catg_code)) z
                group by z.comp_code,z.unit_code,z.publ,z.publ_name,z.edtn,z.edtn_name,last_day(trunc(z.supply_date,'mm')),
                    z.copy_rate,z.comm_fix_auto_spl,z.comm_code,z.waste_rate,z.comm_catg_type,z.comm_rate,z.RETURNABLE;
        else
            open p_circuls for
            select comp_code,unit_code,publ,publ_name,edtn,edtn_name,supply_date,supply_date supply_datemon,
            copy_rate,comm_fix_auto_spl,comm_code,waste_rate,
            substr(comm_rate,1,1) comm_catg_type,substr(comm_rate,2,length(comm_rate)-1) comm_rate,supply_copy,rate_supply,
            RETURNABLE,per_copy_weight,"RETURNABLEper" as "RETURNABLEper" from--P30,C0.5
            (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,
            d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
            d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,cir_get_waste_rate_catg(d.comp_code,d.unit_code,d.edtn,to_char(supdate,''''||pdateformat||''''),''''||pdateformat||'''',d.waste_catg_code,null,null) waste_rate,
            cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,to_char(d.supdate,''''||pdateformat||''''),''''||pdateformat||'''',sum(d.sup_copy),'','') comm_rate,'P' comm_catg_type, sum(d.sup_copy) supply_copy,
            /*(select sum(u.sup_copy) from cir_dbksup u where u.comp_code=d.comp_code and u.unit_code=d.unit_code and 
            (u.publ=d.publ) and u.edtn=d.edtn and u.supdate between v_frdt and v_todt and 
            u.billagcd=pagcd_code and u.billdpcd=pdpcd_code and u.sup_rate=d.sup_rate)*/  
            sum(d.sup_copy) rate_supply,--100 as RETURNABLE,
            cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.sup_copy),puserid,pagcd_code,pdpcd_code,'Q',d.edtn,'')  RETURNABLE,
            d.per_copy_weight per_copy_weight,d.waste_catg_code waste_catg_code
            ,cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.sup_copy),puserid,pagcd_code,pdpcd_code,'P',d.edtn,'') as "RETURNABLEper"
            from cir_dbksup d,cir_publ_mast p,cir_edtn_mast e
            where d.comp_code=pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
                  d.unit_code=punit_code and d.publ=p.publ and d.publ=e.publ and
                  (d.publ=ppubl_code or ppubl_code is null) and
                  d.edtn=e.edtn and (d.edtn = pedtn_code or pedtn_code is null) and
                d.supdate between v_frdt and v_todt and
                d.billagcd=pagcd_code and d.billdpcd=pdpcd_code 
              --  d.AGCD =pagcd_code and d.dpcd=pdpcd_code 
                and upper(nvl(pextra1,'D'))='D'
                 and (d.SUP_TYPE_CODE=pextra3 or pextra3='' or pextra3 is null)
                group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight,d.waste_catg_code)
               -- group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight,d.waste_catg_code) z
        
         union
            select distinct z.comp_code comp_code,z.unit_code unit_code,z.publ publ,z.publ_name publ_name,z.edtn,z.edtn_name edtn_name,MAX(z.supply_date) supply_date,last_day(trunc(z.supply_date,'mm')) supply_datemon,
            z.copy_rate copy_rate,z.comm_fix_auto_spl comm_fix_auto_spl,z.comm_code comm_code,z.waste_rate waste_rate,
            z.comm_catg_type comm_catg_type,z.comm_rate comm_rate,sum(z.supply_copy) supply_copy,sum(z.supply_copy) rate_supply,
            RETURNABLE,max(z.per_copy_weight) per_copy_weight,"RETURNABLEper" as "RETURNABLEper" from
            (select distinct comp_code,unit_code,publ,publ_name,edtn,edtn_name,supply_date,
            copy_rate,comm_fix_auto_spl,comm_code,waste_rate,
            substr(comm_rate,1,1) comm_catg_type,substr(comm_rate,2,length(comm_rate)-1) comm_rate,supply_copy,rate_supply,
            RETURNABLE,per_copy_weight,"RETURNABLEper" from--P30,C0.5
            (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,
            d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
            d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,cir_get_waste_rate_catg(d.comp_code,d.unit_code,d.edtn,to_char(d.supdate,''''||pdateformat||''''),''''||pdateformat||'''',d.waste_catg_code,null,null) waste_rate,
            cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,
            to_char(d.supdate,''''||pdateformat||''''),''''||pdateformat||'''',sum(d.sup_copy),'','') comm_rate,'P' comm_catg_type, sum(d.sup_copy) supply_copy,
            (select sum(u.sup_copy) from cir_dbksup u where u.comp_code=d.comp_code and u.unit_code=d.unit_code and 
            (u.publ=d.publ) and u.edtn=d.edtn and u.supdate between v_frdt and v_todt and 
            u.billagcd=pagcd_code and u.billdpcd=pdpcd_code and u.sup_rate=d.sup_rate) rate_supply,
            --100 as RETURNABLE,
             cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.sup_copy),puserid,pagcd_code,pdpcd_code,'Q',d.edtn,'')  RETURNABLE,
            d.per_copy_weight per_copy_weight,d.waste_catg_code waste_catg_code
            --,0 RETURNABLEper
            ,cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.sup_copy),puserid,pagcd_code,pdpcd_code,'P',d.edtn,'') as "RETURNABLEper"
            from cir_dbksup d,cir_publ_mast p,cir_edtn_mast e
            where d.comp_code=pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
                  d.unit_code=punit_code and d.publ=p.publ and d.publ=e.publ and
                  (d.publ=ppubl_code or ppubl_code is null) and
                  d.edtn=e.edtn and (d.edtn = pedtn_code or pedtn_code is null) and
                d.supdate between v_frdt and v_todt and
              -- d.AGCD =pagcd_code and d.dpcd=pdpcd_code  
                d.billagcd =pagcd_code and d.dpcd=pdpcd_code 
               
               and upper(nvl(pextra1,'D'))='R'
                and (d.SUP_TYPE_CODE=pextra3 or pextra3='' or pextra3 is null)
                group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate, d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight,d.waste_catg_code)) z
                group by z.comp_code,z.unit_code,z.publ,z.publ_name,z.edtn,z.edtn_name,last_day(trunc(z.supply_date,'mm')),
                    z.copy_rate,z.comm_fix_auto_spl,z.comm_code,z.waste_rate,z.comm_catg_type,z.comm_rate,RETURNABLE,"RETURNABLEper"
             --   group by z.comp_code,z.unit_code,z.publ,z.publ_name,z.edtn,z.edtn_name,dbo.GetLastDayOfMonth(z.supply_date),
                  --  z.copy_rate,z.comm_fix_auto_spl,z.comm_code,z.waste_rate,z.comm_catg_type,z.comm_rate
                    
                    
                order by publ_name,edtn,supply_date;
        end if;
        --  this table for permissable days---------
       BEGIN
        select  z.output into v_cnt from(    
    select distinct cir_get_unsold_permis_days
    (pcomp_code,nvl(ppubl_code,d.PUBL),'A01',pagcd_code,pdpcd_code,'D',to_date(preceiptdt,''''||pdateformat||''''),to_date(psup_fromdate,''''||pdateformat||''''),'','') as output
    ,publ from cir_dbksup d 
    where d.comp_code=pcomp_code and
    d.unit_code=punit_code and
    (d.publ=ppubl_code or ppubl_code is null or ppubl_code='')  
    and (d.edtn = pedtn_code or pedtn_code is null or pedtn_code='') 
    and d.supdate between to_date(psup_fromdate,''''||pdateformat||'''') and to_date(psup_todate,''''||pdateformat||'''') and
    d.billagcd=pagcd_code and d.billdpcd=pdpcd_code
     and (d.SUP_TYPE_CODE=pextra3 or pextra3='' or pextra3 is null)
    --d.AGCD =pagcd_code and d.dpcd=pdpcd_code 

    group by d.PUBL) z where z.output not like 'OK%' and rownum=1;
    EXCEPTION WHEN NO_DATA_FOUND THEN 
    v_cnt:=NULL;
    END;
    
    if(v_cnt is null) then 
     open p_circuls1 for
     select 'OK' AS OUTPUT FROM DUAL;
     ELSE
      open p_circuls1 for
     select v_cnt AS OUTPUT FROM DUAL;
     END IF;
  End cir_unsold_supply_p;
  
  
  
    
  procedure cir_unsold_check_p(
      pcomp_code        in varchar2,
      punit_code        in varchar2,
      ppubl_code        in varchar2,
      pedtn_code        in varchar2,
      psup_date         in varchar2,
      pagcd_code        in varchar2,
      pdpcd_code        in varchar2,
      pdoc_type         in varchar2,
      precptno          in varchar2,
      pmissing_recpt    in varchar2,
      plate_recpt       in varchar2,
      pbnr_recpt        in varchar2,
      punsold           in varchar2,
      pcopy_rate        in varchar2,
      pcomm_per         in varchar2,
      pcomm_type        in varchar2,
      pwaste_flag       in varchar2,
      pwaste_rate       in varchar2,
      pdateformat       in varchar2,
      pextra1           in varchar2,--for damaged copies
      pextra2           in varchar2,
      p_circuls         out T_Circul_Cursor,
      p_circuls1        out T_Circul_Cursor)
  As
        v_supdt date;
        v_tot_copy    number;
        v_waste_amt number;
        v_gross_amt number;
        v_comm_amt     number;
        v_total_amt number;
        v_query     varchar2(2000);
        pvat_on_gross varchar2(1);
        ptax_rate numeric(15,2);
         ptax_type VARCHAR2(20);
         v_tax_amt        number(15,2);

v_vat_allow varchar(20):='N';
  Begin
        v_supdt:=to_date(psup_date,''''||pdateformat||'''');
        select cir_vat_allow,cir_vat_on_gross into  v_vat_allow,pvat_on_gross from preferrences where "comp_code"=pcomp_code;

        if upper(pextra2)='D' then
            open p_circuls for
            select nvl(sum(nvl(nvl(apr_short_recpt,0),nvl(short_recpt,0))+nvl(apr_late_recpt,late_recpt)+nvl(nvl(apr_bnr,0),nvl(bnr,0))+nvl(nvl(apr_unsold,0),nvl(unsold,0))+nvl(nvl(apr_damage,0),nvl(damage,0))),0) as total from cir_unsold_dtl_dis
                where comp_code   =pcomp_code and
                      unit_code   =punit_code and
                      doctype     =pdoc_type and
                      publ        =ppubl_code and
                      edtn        =pedtn_code and
                      supdate     =v_supdt and
                      agcd        =pagcd_code and
                      dpcd        =pdpcd_code and
                      recptno     <>nvl(precptno,'/');
        else
            open p_circuls for
            select nvl(sum(nvl(nvl(apr_short_recpt,0),nvl(short_recpt,0))+nvl(apr_late_recpt,late_recpt)+nvl(nvl(apr_bnr,0),nvl(bnr,0))+nvl(nvl(apr_unsold,0),nvl(unsold,0))+nvl(nvl(apr_damage,0),nvl(damage,0))),0) as total from cir_unsold_dtl
                where comp_code   =pcomp_code and
                      unit_code   =punit_code and
                      doctype     =pdoc_type and
                      publ        =ppubl_code and
                      edtn        =pedtn_code and
                      supdate     =v_supdt and
                      agcd        =pagcd_code and
                      dpcd        =pdpcd_code and
                      recptno     <>nvl(precptno,'/');
         end if;

        if nvl(pwaste_flag,'N')='Y' then
            v_waste_amt:=round((nvl(punsold,0)*nvl(pwaste_rate,0)),2);
        else
            v_waste_amt:=0;
        end if;
        
        v_tot_copy:=nvl(pmissing_recpt,0)+nvl(plate_recpt,0)+nvl(pbnr_recpt,0)+nvl(punsold,0)+nvl(pextra1,0);        
        v_gross_amt :=nvl(v_tot_copy,0)*nvl(pcopy_rate,0);        

         if nvl(v_vat_allow,'N') ='Y' THEN               
                if nvl(pvat_on_gross,'N') ='Y' THEN

                    begin
                        select tax_rate,tax_calc_type into ptax_rate,ptax_type from cir_tax_mast 
                        where comp_code=pcomp_code and tax_type_id=1 and tax_status='Y' and valid_from=(select max(valid_from) from cir_tax_mast
                        where comp_code=pcomp_code and tax_type_id=1 and tax_status='Y' and valid_from<=sysdate);
                        exception WHEN NO_DATA_FOUND THEN
                        ptax_rate:=0;
                       ptax_type:=null;
                    end;
            
                    insert into test1 values('naman',ptax_rate||'`'||ptax_type);
           
                     if ptax_type='P' then
                        v_tax_amt:=round((nvl(v_gross_amt,0)*nvl(ptax_rate,0))/100,2);     
                        insert into test1 values('naman123' ,v_tax_amt);  
                     elsif ptax_type='F' then
                        v_tax_amt:=round(nvl(v_gross_amt,0)+nvl(ptax_rate,0),2); 
                     else
                        v_tax_amt:=0;          
                     end if;
                     
                    if pcomm_type='C' then--for per copy rate
                              
                        v_comm_amt  :=round(((v_tot_copy)*nvl(pcomm_per,0)),2);
                      --  insert into test1 values('namancccc', v_tot_copy ||'`'||v_tax_amt||'`'||pcomm_per);  
                    else
                              
                        v_comm_amt  :=round(((v_gross_amt+v_tax_amt)*nvl(pcomm_per,0)/100),2);
                        insert into test1 values('namancccc', v_gross_amt ||'`'||v_tax_amt||'`'||pcomm_per);  
                    end if;
                    
                    v_total_amt :=round((v_gross_amt+v_tax_amt-v_comm_amt-v_waste_amt),2);
                else

                    if pcomm_type='C' then--for per copy rate
                              
                        v_comm_amt  :=round(((v_tot_copy)*nvl(pcomm_per,0)),2);
                      --  insert into test1 values('namancccc', v_tot_copy ||'`'||v_tax_amt||'`'||pcomm_per);  
                    else
                              
                        v_comm_amt  :=round(((v_gross_amt)*nvl(pcomm_per,0)/100),2);
                        insert into test1 values('namancccc', v_gross_amt ||'`'||v_tax_amt||'`'||pcomm_per);  
                    end if;
                    
                    v_total_amt :=round((v_gross_amt-v_comm_amt-v_waste_amt),2);
                    begin
                        select tax_rate,tax_calc_type into ptax_rate,ptax_type from cir_tax_mast 
                        where comp_code=pcomp_code and tax_type_id=1 and tax_status='Y' and valid_from=(select max(valid_from) from cir_tax_mast
                        where comp_code=pcomp_code and tax_type_id=1 and tax_status='Y' and valid_from<=sysdate);
                        exception WHEN NO_DATA_FOUND THEN
                        ptax_rate:=0;
                       ptax_type:=null;
                    end;
            
                    insert into test1 values('naman',ptax_rate||'`'||ptax_type);
           
                     if ptax_type='P' then
                        v_tax_amt:=round((nvl(v_total_amt,0)*nvl(ptax_rate,0))/100,2);     
                        insert into test1 values('naman123' ,v_tax_amt);  
                     elsif ptax_type='F' then
                        v_tax_amt:=round(nvl(v_total_amt,0)+nvl(ptax_rate,0),2); 
                     else
                        v_tax_amt:=0;          
                     end if;                 
                    
                     v_total_amt :=round((v_gross_amt+v_tax_amt-v_comm_amt-v_waste_amt),2);
                    
                END IF;
         
         else
                if pcomm_type='C' then--for per copy rate
                          
                    v_comm_amt  :=round(((v_tot_copy)*nvl(pcomm_per,0)),2);
                  --  insert into test1 values('namancccc', v_tot_copy ||'`'||v_tax_amt||'`'||pcomm_per);  
                else
                          
                    v_comm_amt  :=round(((v_gross_amt)*nvl(pcomm_per,0)/100),2);
                    insert into test1 values('namancccc', v_gross_amt ||'`'||v_tax_amt||'`'||pcomm_per);  
                end if;
                
                v_total_amt :=round((v_gross_amt-v_comm_amt-v_waste_amt),2);         
         end if;       
        

        
     
        --v_query:='SELECT '||v_tot_copy||'as "TOTAL_COPY" ,'||v_waste_amt||' as "WASTE_AMOUNT" ,'||v_comm_amt||' as "COMM_AMOUNT" ,'||v_total_amt||' as "TOTAL_AMOUNT" '||','||v_tax_amt||' as "TAX_AMOUNT" '||' FROM DUAL';
     v_query:='SELECT '||v_tot_copy||'as "TOTAL_COPY" ,'||v_waste_amt||' as "WASTE_AMOUNT" ,'||v_comm_amt||' as "COMM_AMOUNT" ,'||v_total_amt||' as "TOTAL_AMOUNT"   FROM DUAL';
   open p_circuls1 for v_query;
  End cir_unsold_check_p;
    
  procedure cir_notapproval_list_p(
      pcomp_code    in varchar2,
      punit_code    in varchar2,
      pdoc_type     in varchar2,
      pdateformat   in varchar2,
      pextra1       in varchar2,
      pextra2       in varchar2,
      pextra3       in varchar2,
      p_circuls     out T_Circul_Cursor)
  As
  Begin
      if upper(pextra2)='D' then  
        open p_circuls for
        select distinct h.recptno recptno,h.recptdt recptdt,h.agcd agcd,h.dpcd dpcd,m.ag_name agency_name,
        cir_get_city(h.comp_code,m.city_code) city_name,h.publ publ,cir_get_publ_name(h.comp_code,h.publ) publ_name,h.edtn edtn,
        cir_get_edtn_name(h.comp_code,h.edtn) edtn_name,h.entrydt entrydt,h.frdt frdt,h.todt todt
        from cir_unsold_hdr_dis h,cir_agmast_dis m
        where h.comp_code=m.comp_code and h.comp_code=pcomp_code and h.unit_code=m.unit and h.unit_code=punit_code and h.doctype=pdoc_type and 
        h.agcd=m.agcd and h.dpcd=m.dpcd and (upper(m.ag_name) like upper(pextra1)||'%' or pextra1 is null) and h.app_userid is null
        and (h.recptno=pextra3 or pextra3 is null)
        order by recptdt,recptno,agency_name;
      else
        open p_circuls for
        select distinct h.recptno recptno,h.recptdt recptdt,h.agcd agcd,h.dpcd dpcd,m.ag_name agency_name,
        cir_get_city(h.comp_code,m.city_code) city_name,h.publ publ,cir_get_publ_name(h.comp_code,h.publ) publ_name,h.edtn edtn,
        cir_get_edtn_name(h.comp_code,h.edtn) edtn_name,h.entrydt entrydt,h.frdt frdt,h.todt todt
        ,H.sup_agcd SUP_AGCD,H.sup_dpcd SUP_DPCD,M.ag_name SUP_AGENCY, CIR_GET_CITY(H.comp_code,M.city_code) SUP_CITY_NAME
        from cir_unsold_hdr h,cir_agmast m
        where h.comp_code=m.comp_code and h.comp_code=pcomp_code and h.unit_code=m.unit and h.unit_code=punit_code and h.doctype=pdoc_type and 
        h.agcd=m.agcd and h.dpcd=m.dpcd and (upper(m.ag_name) like upper(pextra1)||'%' or pextra1 is null) and h.app_userid is null
        and (h.recptno=pextra3 or pextra3 is null)
        order by recptdt,recptno,agency_name;
      end if;
  End cir_notapproval_list_p;
    
  procedure cir_notapproval_unsold_p(
      pcomp_code    in varchar2,
      punit_code    in varchar2,
      pdoc_type     in varchar2,
      precptno      in varchar2,
      pagcd_code    in varchar2,
      pdpcd_code    in varchar2,
      pdateformat   in varchar2,
      pextra1       in varchar2,
      pextra2       in varchar2,
      p_circuls     out T_Circul_Cursor)
    As
    
       
        v_return_per    number;
        v_sup_copy      number;
        v_returnnable   number;
     
    
    
    Begin
    
             --    select nvl(RETURN_PER,0) into v_return_per   from cir_unsold_dtl_dis   where comp_code=pcomp_code and unit_code=punit_code and doctype=pdoc_type and
            --     recptno=precptno and agcd=pagcd_code and dpcd=pdpcd_code
             --    order by recptdt,recptno,supdate;
                 
            --       select nvl(SUPPLY_COPY,0) into v_sup_copy   from cir_unsold_dtl_dis   where comp_code=pcomp_code and unit_code=punit_code and doctype=pdoc_type and
           --      recptno=precptno and agcd=pagcd_code and dpcd=pdpcd_code
            --     order by recptdt,recptno,supdate;
    
            --   v_returnnable  :=  (v_return_per * v_sup_copy)/100;
    
   -- round((nvl(punsold,0)*nvl(pwaste_rate,0)),2);
     --  v_return_per :=
    
        if upper(pextra2)='D' then
        open p_circuls for
            select * from cir_unsold_dtl_dis
            where comp_code=pcomp_code and unit_code=punit_code and doctype=pdoc_type and
                        recptno=precptno and agcd=pagcd_code and dpcd=pdpcd_code
            order by recptdt,recptno,supdate;
        else
            open p_circuls for
            
           select   COMP_CODE ,UNIT_CODE , DOCTYPE ,RECPTNO , RECPTDT ,ENTRYDT , AGCD,DPCD  ,SUPDATE  ,SHORT_RECPT, LATE_RECPT  ,BNR   , UNSOLD ,APR_SHORT_RECPT, APR_LATE_RECPT , APR_BNR ,APR_UNSOLD ,
                   USERID , CREATION_DATE , COPY_RATE , COMM_RATE , WASTE_ALW   ,WASTE_RATE,COPY_AMT ,COMM_AMT , WASTE_AMT,APP_USERID ,APP_DT, PUBL ,EDTN ,SUPPLY_COPY, RATE_SUPPLY ,BRANCH_CODE,
                 COMM_CATG_TYPE ,PROCESS_CRNO ,PROCESS_CRDT,RETURN_PER , DAMAGE   ,APR_DAMAGE  ,VAR_SHORT_RECPT , VAR_LATE_RECPT , VAR_BNR   , VAR_UNSOLD ,VAR_DAMAGE  ,VAR_USERID,VAR_DT ,
                  SUP_AGCD , SUP_DPCD , UPDATE_BY , UPDATE_DT ,NO_OF_PACKET ,REF_DOCTYPE ,REF_RECPTNO , REF_RECPTDT ,PER_COPY_WT, UNSOLD_WT  , UNSOLD_REJECT , ((RETURN_PER*SUPPLY_COPY)/100) as RETURNABLE  from cir_unsold_dtl
            where comp_code=pcomp_code and unit_code=punit_code and doctype=pdoc_type and
                        recptno=precptno and agcd=pagcd_code and dpcd=pdpcd_code
            order by recptdt,recptno,supdate;
            
            
            
        --    select * from cir_unsold_dtl,v_returnnable from dual 
         --   where comp_code=pcomp_code and unit_code=punit_code and doctype=pdoc_type and
          --              recptno=precptno and agcd=pagcd_code and dpcd=pdpcd_code
         --   order by recptdt,recptno,supdate;
        end if;
    End cir_notapproval_unsold_p;
    
  --  cast(round((RETURN_PER*SUPPLY_COPY)/100,0) as int) as RETURNABLE
    
  procedure cir_unsold_calculation_p(
      pcomp_code        in varchar2,
      punit_code        in varchar2,
      ppubl_code        in varchar2,
      pedtn_code        in varchar2,
      pmissing_recpt    in number,
      plate_recpt       in number,
      pbnr_recpt        in number,
      punsold           in number,
      pcopy_rate        in number,
      pcomm_per         in number,
      pcomm_type        in varchar2,
      pwaste_flag       in varchar2,
      pwaste_rate       in number,
      pdateformat       in varchar2,
      pextra1           in varchar2,--for damaged copies
      pextra2           in varchar2,--for unsold receipt date
      p_circuls         out T_Circul_Cursor)
    As
        v_tot_copy    number;
        v_waste_amt number;
        v_gross_amt number;
        v_comm_amt     number;
        v_total_amt number;
        v_query varchar2(2000);
        
v_vat_allow      varchar2(1);
vbill_tax_on_gross  varchar2(1):='N';
v_tax_calc_type      varchar2(1);
v_tax_amt        number(15,2);
v_tax_prate      number(15,3);   
v_tax_frate      number(15,3); 


v_rcpdt date;
cursor cur_tax is
    select tax_rate,tax_calc_type from cir_tax_mast 
        where comp_code=pcomp_code and tax_type_id=1 and tax_status='Y' and valid_from=(select max(valid_from) from cir_tax_mast
            where comp_code=pcomp_code and tax_type_id=1 and tax_status='Y' and valid_from<=v_rcpdt);
              
rec_tax cur_tax%rowtype;       
Begin

    select cir_vat_allow,cir_vat_on_gross into v_vat_allow,vbill_tax_on_gross from preferrences where "comp_code"=pcomp_code;
    
    
    v_rcpdt:=to_date(pextra2,''''||pdateformat||'''');
    --pcomp_code,punit_code,ppubl_code,pedtn_code this parameter future use
    if nvl(pwaste_flag,'N')='Y' then
        v_waste_amt:=round((nvl(punsold,0)*nvl(pwaste_rate,0)),2);
    else
        v_waste_amt:=0;
    end if;
        
    v_tot_copy:=nvl(pmissing_recpt,0)+nvl(plate_recpt,0)+nvl(pbnr_recpt,0)+nvl(punsold,0)+nvl(pextra1,0);
    v_gross_amt :=nvl(v_tot_copy,0)*nvl(pcopy_rate,0);

    if pcomm_type='C' then--for per copy rate
        v_comm_amt  :=round((v_tot_copy*nvl(pcomm_per,0)),2);
    else
        v_comm_amt  :=round((v_gross_amt*nvl(pcomm_per,0)/100),2);
    end if;    
    v_total_amt :=round((v_gross_amt-v_comm_amt-v_waste_amt),2);   
         
    
----------------for tax amount--------------------------    
    if v_vat_allow='Y' then   
        if vbill_tax_on_gross='Y' then 
            open cur_tax;
            loop
                fetch cur_tax into rec_tax;
                exit when cur_tax%notfound; 
                if rec_tax.tax_calc_type='P' then
                    v_tax_amt:=nvl(v_tax_amt,0)+round((nvl(v_gross_amt,0)*nvl(rec_tax.tax_rate,0))/100,2);
                    v_tax_prate:=nvl(v_tax_prate,0)+nvl(rec_tax.tax_rate,0);
                    v_tax_calc_type:=rec_tax.tax_calc_type;
                else
                    v_tax_amt:=nvl(v_tax_amt,0)+round(nvl(v_gross_amt,0)+nvl(rec_tax.tax_rate,0),2);
                    v_tax_frate:=nvl(v_tax_frate,0)+nvl(rec_tax.tax_rate,0);
                    v_tax_calc_type:=rec_tax.tax_calc_type;
                end if;
            end loop;
            close cur_tax;
        else
        
            open cur_tax;
            loop
                fetch cur_tax into rec_tax;
                exit when cur_tax%notfound; 
                if rec_tax.tax_calc_type='P' then
                    v_tax_amt:=nvl(v_tax_amt,0)+round((nvl(v_total_amt,0)*nvl(rec_tax.tax_rate,0))/100,2);
                    v_tax_prate:=nvl(v_tax_prate,0)+nvl(rec_tax.tax_rate,0);
                    v_tax_calc_type:=rec_tax.tax_calc_type;
                else
                    v_tax_amt:=nvl(v_tax_amt,0)+round(nvl(v_total_amt,0)+nvl(rec_tax.tax_rate,0),2);
                    v_tax_frate:=nvl(v_tax_frate,0)+nvl(rec_tax.tax_rate,0);
                    v_tax_calc_type:=rec_tax.tax_calc_type;
                end if;
            end loop;
            close cur_tax;        

        end if; 
    else
        v_tax_amt   :=0;
        v_tax_prate :=0;
        v_tax_frate :=0;        
    end if;   
        
    v_total_amt :=nvl(v_total_amt,0)+nvl(v_tax_amt,0);
        
        v_query:='SELECT '||v_tot_copy||'as "TOTAL_COPY" ,'||v_waste_amt||' as "WASTE_AMOUNT" ,'||v_comm_amt||' as "COMM_AMOUNT" ,'||v_total_amt||' as "TOTAL_AMOUNT" '||','||v_tax_amt||' as "TAX_AMOUNT" '||' FROM DUAL';
        open p_circuls for v_query;
    End cir_unsold_calculation_p;

/*
var v1 refcursor;
exec cir_unsold_credit_note.cir_unsold_process_p('DB001','JA0','01-oct-2010','31-oct-2010','','','','SH0','dd/mm/yyyy','','',:v1);
*/
    procedure cir_unsold_process_p(
      pcomp_code         in varchar2,
      punit_code         in varchar2,
      prec_fromdate     in varchar2,
      prec_todate         in varchar2,
      pagtype_code      in varchar2,
      pagcd_code         in varchar2,
      pdpcd_code         in varchar2,
      puserid           in varchar2,
      pdateformat         in varchar2,
      pextra1             in varchar2,
      pextra2             in varchar2,
      p_circuls         out T_Circul_Cursor)
As
    v_frdt      date;
    v_todt      date;
    v_doctype   varchar2(5):='UCN';
    v_tot_amt   NUMBER(15,2):=0;
    v_count     number:=0;
    v_dsign     number;
    v_recptdt   date;
    v_amt       number(15,2);
            
    v_rcdp      varchar2(20);
    v_ccdp        varchar2(10);
                
        cursor c1 is
            select h.comp_code comp_code,h.unit_code unit_code,m.branch_code branch_code,h.agcd agcd,h.dpcd dpcd,
            nvl(sum(d.apr_unsold),0) unsold_copy,nvl(sum(d.apr_bnr),0) missing_copy ,
            nvl(sum(d.apr_late_recpt),0) late_copy,nvl(sum(d.apr_short_recpt),0) short_copy,nvl(sum(d.apr_damage),0) damage_copy,
            sum((nvl(d.apr_unsold,0)+nvl(d.apr_bnr,0)+nvl(d.apr_late_recpt,0)+nvl(d.apr_short_recpt,0)+nvl(d.apr_damage,0))*nvl(d.copy_rate,0)) gross_amt,
            nvl(sum(d.comm_amt),0) comm_amt,nvl(sum(d.waste_amt),0) waste_amt,
            sum(((nvl(d.apr_unsold,0)+nvl(d.apr_bnr,0)+nvl(d.apr_late_recpt,0)+nvl(d.apr_short_recpt,0)+nvl(d.apr_damage,0))*nvl(d.copy_rate,0))-nvl(d.comm_amt,0)-nvl(d.waste_amt,0)) amount
            from cir_unsold_hdr_DIS h,cir_unsold_dtl_DIS d,cir_agmast_DIS m
            where h.comp_code=pcomp_code and h.comp_code=d.comp_code and h.comp_code=m.comp_code and
            h.unit_code=punit_code and h.unit_code=d.unit_code and h.unit_code=m.unit and h.doctype=v_doctype and h.doctype=d.doctype and 
            h.recptno=d.recptno and h.recptdt=d.recptdt and h.agcd=nvl(pagcd_code,h.agcd) and h.dpcd=nvl(pdpcd_code,h.dpcd) and 
            h.agcd=d.agcd and h.dpcd=d.dpcd and h.agcd=m.agcd and h.dpcd=m.dpcd and (m.ag_type=pagtype_code or pagtype_code is null) and
            h.app_dt >= v_frdt and h.app_dt<=v_todt and h.app_userid is not null and h.process_crno is null and 
            (nvl(d.apr_unsold,0)+nvl(d.apr_bnr,0)+nvl(d.apr_late_recpt,0)+nvl(d.apr_short_recpt,0)+nvl(d.apr_damage,0))>0 and upper(nvl(pextra2,'/'))='D'
            group by h.comp_code,h.unit_code,m.branch_code,h.agcd,h.dpcd
            union
            select h.comp_code comp_code,h.unit_code unit_code,m.branch_code branch_code,h.agcd agcd,h.dpcd dpcd,
            nvl(sum(d.apr_unsold),0) unsold_copy,nvl(sum(d.apr_bnr),0) missing_copy ,
            nvl(sum(d.apr_late_recpt),0) late_copy,nvl(sum(d.apr_short_recpt),0) short_copy,nvl(sum(d.apr_damage),0) damage_copy,
            sum((nvl(d.apr_unsold,0)+nvl(d.apr_bnr,0)+nvl(d.apr_late_recpt,0)+nvl(d.apr_short_recpt,0)+nvl(d.apr_damage,0))*nvl(d.copy_rate,0)) gross_amt,
            nvl(sum(d.comm_amt),0) comm_amt,nvl(sum(d.waste_amt),0) waste_amt,
            sum(((nvl(d.apr_unsold,0)+nvl(d.apr_bnr,0)+nvl(d.apr_late_recpt,0)+nvl(d.apr_short_recpt,0)+nvl(d.apr_damage,0))*nvl(d.copy_rate,0))-nvl(d.comm_amt,0)-nvl(d.waste_amt,0)) amount
            from cir_unsold_hdr h,cir_unsold_dtl d,cir_agmast m
            where h.comp_code=pcomp_code and h.comp_code=d.comp_code and h.comp_code=m.comp_code and
            h.unit_code=punit_code and h.unit_code=d.unit_code and h.unit_code=m.unit and h.doctype=v_doctype and h.doctype=d.doctype and 
            h.recptno=d.recptno and h.recptdt=d.recptdt and h.agcd=nvl(pagcd_code,h.agcd) and h.dpcd=nvl(pdpcd_code,h.dpcd) and 
            h.agcd=d.agcd and h.dpcd=d.dpcd and h.agcd=m.agcd and h.dpcd=m.dpcd and (m.ag_type=pagtype_code or pagtype_code is null) and
            h.app_dt >= v_frdt and h.app_dt<=v_todt and h.app_userid is not null and h.process_crno is null and 
            (nvl(d.apr_unsold,0)+nvl(d.apr_bnr,0)+nvl(d.apr_late_recpt,0)+nvl(d.apr_short_recpt,0)+nvl(d.apr_damage,0))>0 and upper(nvl(pextra2,'/'))<>'D'
            group by h.comp_code,h.unit_code,m.branch_code,h.agcd,h.dpcd
            order by comp_code,unit_code,branch_code,agcd,dpcd;
    v1 c1%rowtype;
    v_recptno varchar2(20);
    v_remark varchar2(200);
    Begin
        v_frdt:=to_date(prec_fromdate,''''||pdateformat||'''');
        v_todt:=to_date(prec_todate,''''||pdateformat||'''');
        v_recptdt:=v_todt;
        
        open c1;
        loop
            fetch c1 into v1;
            exit when c1%notfound;
            
            
            select Dsign into v_dsign from cir_docmst where Comp_code=pcomp_code AND doc_type=v_doctype;

            v_amt:=v1.amount*v_dsign;
            v_remark:='Being amount credited against unsold return';
            
            Begin
                select distinct dr_cdp,cr_cdp into v_rcdp,v_ccdp from FA_FIN_LINK_MAST 
                    where comp_code=v1.comp_code and unit_code=v1.unit_code and 
                        branch_code=v1.branch_code and modual_alias='CCOL' and doctype=v_doctype and 
                        sysdate BETWEEN nvl(EFF_FR_DATE,sysdate) AND nvl(EFF_TO_DATE,sysdate());
            Exception when others then
                v_rcdp:=null;v_ccdp:=null;
            End;
                                
            if nvl(v1.unsold_copy,0)>0 then
                v_remark:=v_remark||' Unsold Copy:- '||v1.unsold_copy;
            end if;
            if nvl(v1.missing_copy,0)>0 then
                v_remark:=v_remark||' Missing Copy:- '||v1.missing_copy;
            end if;
            if nvl(v1.late_copy,0)>0 then
                v_remark:=v_remark||' Late Copy:- '||v1.late_copy;
            end if;
            if nvl(v1.short_copy,0)>0 then
                v_remark:=v_remark||' Short Copy:- '||v1.short_copy;
            end if;
            if nvl(v1.damage_copy,0)>0 then
                v_remark:=v_remark||' Damage Copy:- '||v1.damage_copy;
            end if;
            
            --v_recptno:=cir_genrate_id.receipt_cndn_id_p (pcomp_code,punit_code,v_doctype,to_char(v_recptdt,''''||pdateformat||''''),pdateformat,pextra1,pextra2);
            Begin
                if upper(pextra2)='D' then
                select max(to_number(substr(recptno,-8)))+1 into v_recptno from cir_rcphdr_dis 
                    where comp_code=v1.comp_code  and doctype=v_doctype and to_char(recptdt,'yymm')=to_char(v_recptdt,'yymm') and 
                        branch_code=v1.branch_code;
                else
                select max(to_number(substr(recptno,-8)))+1 into v_recptno from cir_rcphdr 
                    where comp_code=v1.comp_code  and doctype=v_doctype and to_char(recptdt,'yymm')=to_char(v_recptdt,'yymm') and 
                        branch_code=v1.branch_code;                
                end if;
                Exception When Others Then
                    v_recptno:=null;
            End;
    
            If nvl(v_recptno,0)=0 Then
              v_recptno:=v1.branch_code||'-'||to_char(v_recptdt,'yymm')||'0001';
            Else
              v_recptno:=v1.branch_code||'-'||lpad(v_recptno,8,'0');
            End if;
            if upper(pextra2)='D' then
              if v_recptno is not null and nvl(v_amt,0)<>0 then
                  insert into cir_rcphdr_dis(comp_code,unit_code,agcd,dpcd,doctype,
                                         recptno,recptdt,amount,reason,remark,
                                         achd,voucherno,voucherdt,userid,creation_date,branch_code,ccdp,rcdp)
                                  values(v1.comp_code, v1.unit_code,v1.agcd, v1.dpcd,v_doctype,
                                         v_recptno,v_recptdt,v_amt,'UNSOLD CREDIT NOTE',v_remark,
                                         'NM',v_recptno,v_recptdt,puserid,sysdate,v1.branch_code,v_ccdp,v_rcdp);
                  insert into cir_rcpdet_dis(comp_code,unit_code,agcd,dpcd,doctyp,
                                         recptno,recptdt,payfor,achd,amount,
                                         reason,remark,voucherno,voucherdt,usrid,
                                         creation_date,branch_code)
                                  values(v1.comp_code, v1.unit_code,v1.agcd, v1.dpcd,v_doctype,
                                         v_recptno,v_recptdt,v1.branch_code,'NM',v_amt,
                                         'UNSOLD CREDIT NOTE',v_remark,v_recptno,v_recptdt,puserid,
                                         sysdate,v1.branch_code);
                  insert into cir_outmast_dis(comp_code,unit_code,agcd,dpcd,doctyp,
                                          recptno,recptdt,achd,amount,reason,
                                          remark,voucherno,voucherdt,usrid,creation_date,branch_code)
                                   values(v1.comp_code, v1.unit_code,v1.agcd, v1.dpcd,v_doctype,
                                          v_recptno,v_recptdt,'NM',v_amt,'UNSOLD CREDIT NOTE',
                                          v_remark,v_recptno,v_recptdt,puserid,sysdate,v1.branch_code);
                    v_count     :=nvl(v_count,0)+1;
                    v_tot_amt   :=nvl(v_tot_amt,0)+nvl(v1.amount,0);

                    update cir_unsold_dtl_dis set process_crno=v_recptno,process_crdt=v_recptdt
                        where comp_code=v1.comp_code and unit_code=v1.unit_code and doctype=v_doctype and 
                        app_dt >= v_frdt and app_dt <=v_todt and agcd=v1.agcd and dpcd=v1.dpcd and 
                        process_crno is null and recptno in(select distinct recptno from cir_unsold_hdr_dis
                        where comp_code=v1.comp_code and unit_code=v1.unit_code and doctype=v_doctype and 
                        app_dt >= v_frdt and app_dt <=v_todt and app_userid is not null and agcd=v1.agcd and dpcd=v1.dpcd and 
                        process_crno is null);
                        
                    update cir_unsold_hdr_dis set process_crno=v_recptno,process_crdt=v_recptdt
                        where comp_code=v1.comp_code and unit_code=v1.unit_code and doctype=v_doctype and 
                        app_dt >= v_frdt and app_dt <=v_todt and app_userid is not null and agcd=v1.agcd and dpcd=v1.dpcd and 
                        process_crno is null;
              end if;
          else
              if v_recptno is not null and nvl(v_amt,0)<>0 then
                  insert into cir_rcphdr(comp_code,unit_code,agcd,dpcd,doctype,
                                         recptno,recptdt,amount,reason,remark,
                                         achd,voucherno,voucherdt,userid,creation_date,branch_code,ccdp,rcdp)
                                  values(v1.comp_code, v1.unit_code,v1.agcd, v1.dpcd,v_doctype,
                                         v_recptno,v_recptdt,v_amt,'UNSOLD CREDIT NOTE',v_remark,
                                         'NM',v_recptno,v_recptdt,puserid,sysdate,v1.branch_code,v_ccdp,v_rcdp);
                  insert into cir_rcpdet(comp_code,unit_code,agcd,dpcd,doctyp,
                                         recptno,recptdt,payfor,achd,amount,
                                         reason,remark,voucherno,voucherdt,usrid,
                                         creation_date,branch_code)
                                  values(v1.comp_code, v1.unit_code,v1.agcd, v1.dpcd,v_doctype,
                                         v_recptno,v_recptdt,v1.branch_code,'NM',v_amt,
                                         'UNSOLD CREDIT NOTE',v_remark,v_recptno,v_recptdt,puserid,
                                         sysdate,v1.branch_code);
                  insert into cir_outmast(comp_code,unit_code,agcd,dpcd,doctyp,
                                          recptno,recptdt,achd,amount,reason,
                                          remark,voucherno,voucherdt,usrid,creation_date,branch_code)
                                   values(v1.comp_code, v1.unit_code,v1.agcd, v1.dpcd,v_doctype,
                                          v_recptno,v_recptdt,'NM',v_amt,'UNSOLD CREDIT NOTE',
                                          v_remark,v_recptno,v_recptdt,puserid,sysdate,v1.branch_code);
                    v_count     :=nvl(v_count,0)+1;
                    v_tot_amt   :=nvl(v_tot_amt,0)+nvl(v1.amount,0);

                    update cir_unsold_dtl set process_crno=v_recptno,process_crdt=v_recptdt
                        where comp_code=v1.comp_code and unit_code=v1.unit_code and doctype=v_doctype and 
                        app_dt >= v_frdt and app_dt <=v_todt and agcd=v1.agcd and dpcd=v1.dpcd and 
                        process_crno is null and recptno in(select distinct recptno from cir_unsold_hdr 
                        where comp_code=v1.comp_code and unit_code=v1.unit_code and doctype=v_doctype and 
                        app_dt >= v_frdt and app_dt <=v_todt and app_userid is not null and agcd=v1.agcd and dpcd=v1.dpcd and 
                        process_crno is null);
                        
                    update cir_unsold_hdr set process_crno=v_recptno,process_crdt=v_recptdt
                        where comp_code=v1.comp_code and unit_code=v1.unit_code and doctype=v_doctype and 
                        app_dt >= v_frdt and app_dt <=v_todt and app_userid is not null and agcd=v1.agcd and dpcd=v1.dpcd and 
                        process_crno is null;
              end if;
          end if;
        end loop;
        close c1;
        commit;
        open p_circuls for 
        select v_count as "TOTAL_CREDIT_NOTE",v_tot_amt as "TOTAL_CREDIT_NOTE_AMOUNT" from dual;
   End cir_unsold_process_p;
   
   
   
   
   procedure cir_unsold_supply_p_resale(
    pcomp_code          in varchar2,
    punit_code          in varchar2,
    ppubl_code          in varchar2,
    pedtn_code          in varchar2,
    psup_fromdate       in varchar2,
    psup_todate         in varchar2,
    pagcd_code          in varchar2,
    pdpcd_code          in varchar2,
    pdateformat         in varchar2,
    pextra1             in varchar2,--it is use for datewise or ratewise
    pextra2             in varchar2,
    preceiptdt          in varchar2,
    puserid             in varchar2:=null,
     pextra3            in varchar2,
      pextra4            in varchar2,
      pextra5            in varchar2,
    p_circuls           out T_Circul_Cursor,
    p_circuls1         out T_Circul_Cursor)
As
    v_frdt date;
    v_todt date;
    v_cnt VARCHAR2(500);
Begin
    v_frdt:=to_date(psup_fromdate,''''||pdateformat||'''');
    v_todt:=to_date(psup_todate,''''||pdateformat||'''');
          if upper(pextra2)='D' then
            open p_circuls for
            select comp_code,unit_code,publ,publ_name,edtn, edtn_name,supply_date, supply_date supply_datemon,
            copy_rate,comm_fix_auto_spl,comm_code,waste_rate,
            substr(comm_rate,1,1) comm_catg_type,substr(comm_rate,2,length(comm_rate)-1) comm_rate,supply_copy,rate_supply,
            RETURNABLE,per_copy_weight, "RETURNABLEper" as "RETURNABLEper" from--P30,C0.5
            (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,
            d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
            d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,cir_get_waste_rate_catg(d.comp_code,d.unit_code,d.edtn,to_char(supdate,''''||pdateformat||''''),''''||pdateformat||'''',d.waste_catg_code,null,null) waste_rate,
            cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,to_char(d.supdate,''''||pdateformat||''''),''''||pdateformat||'''',sum(d.sup_copy),'','') comm_rate,'P' comm_catg_type, 
            sum(d.sup_copy) supply_copy,
            /*(select sum(u.sup_copy) from cir_dbksup_dis u where u.comp_code=d.comp_code and u.unit_code=d.unit_code and 
            (u.publ=d.publ) and u.edtn=d.edtn and u.supdate between v_frdt and v_todt and 
            u.billagcd=pagcd_code and u.billdpcd=pdpcd_code and u.sup_rate=d.sup_rate)*/  sum(d.sup_copy) rate_supply,
            --100 as RETURNABLE,
            d.per_copy_weight per_copy_weight,d.waste_catg_code waste_catg_code
            ,cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.sup_copy),nvl(puserid,d.USERID) ,pagcd_code,pdpcd_code,'Q',d.edtn,'')  as "RETURNABLE" 
        ,cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.sup_copy),nvl(puserid,d.USERID),pagcd_code,pdpcd_code,'P',d.edtn,'')   as "RETURNABLEper"
            from cir_dbksup_dis d,cir_publ_mast p,cir_edtn_mast e
            where d.comp_code=pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
                  d.unit_code=punit_code and d.publ=p.publ and d.publ=e.publ and
                  (d.publ=ppubl_code or ppubl_code is null) and
                  d.edtn=e.edtn and (d.edtn = pedtn_code or pedtn_code is null) and
                d.supdate between v_frdt and v_todt and
               d.billagcd=pagcd_code and d.billdpcd=pdpcd_code
              --  d.agcd=pagcd_code and d.dpcd=pdpcd_code
                
                 and upper(nvl(pextra1,'D'))='D'
                 and (d.SUP_TYPE_CODE=pextra3 or pextra3='' or pextra3 is null)
                group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight)
           
        
        
         union
            select distinct z.comp_code comp_code,z.unit_code unit_code,z.publ publ,z.publ_name publ_name,z.edtn,z.edtn_name edtn_name,MAX(z.supply_date) supply_date,last_day(trunc(z.supply_date,'mm')) supply_datemon,
            z.copy_rate copy_rate,z.comm_fix_auto_spl comm_fix_auto_spl,z.comm_code comm_code,z.waste_rate waste_rate,
            z.comm_catg_type comm_catg_type,z.comm_rate comm_rate,sum(z.supply_copy) supply_copy,sum(z.supply_copy) rate_supply,
            RETURNABLE,
           
            
            max(z.per_copy_weight) per_copy_weight
            ,"RETURNABLEper" as "RETURNABLEper"   from
            (select distinct comp_code,unit_code,publ,publ_name,edtn,edtn_name,supply_date,
            copy_rate,comm_fix_auto_spl,comm_code,waste_rate,
            substr(comm_rate,1,1) comm_catg_type,substr(comm_rate,2,length(comm_rate)-1) 
            comm_rate,supply_copy,rate_supply,
            RETURNABLE,per_copy_weight,"RETURNABLEper" as "RETURNABLEper" from--P30,C0.5
            (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,
            d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
            d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,cir_get_waste_rate_catg(d.comp_code,d.unit_code,d.edtn,to_char(d.supdate,''''||pdateformat||''''),''''||pdateformat||'''',d.waste_catg_code,null,null) waste_rate,
            cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,
            to_char(d.supdate,''''||pdateformat||''''),''''||pdateformat||'''',sum(d.sup_copy),'','') comm_rate,'P' comm_catg_type, sum(d.sup_copy) supply_copy,
            (select sum(u.sup_copy) from cir_dbksup_dis u where u.comp_code=d.comp_code and u.unit_code=d.unit_code and 
            (u.publ=d.publ) and u.edtn=d.edtn and u.supdate between v_frdt and v_todt and 
            u.billagcd=pagcd_code and u.billdpcd=pdpcd_code and u.sup_rate=d.sup_rate) rate_supply,
            --100 as RETURNABLE,
             cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.SUP_COPY),puserid,pagcd_code,pdpcd_code,'Q',d.edtn,'')  RETURNABLE,
            d.per_copy_weight per_copy_weight,d.waste_catg_code waste_catg_code 
            ,cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.SUP_COPY),puserid,pagcd_code,pdpcd_code,'P',d.edtn,'') as "RETURNABLEper" 
            from cir_dbksup_dis d,cir_publ_mast p,cir_edtn_mast e
            where d.comp_code=pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
                  d.unit_code=punit_code and d.publ=p.publ and d.publ=e.publ and
                  (d.publ=ppubl_code or ppubl_code is null) and
                  d.edtn=e.edtn and (d.edtn = pedtn_code or pedtn_code is null) and
                d.supdate between v_frdt and v_todt and
                d.billagcd=pagcd_code and d.billdpcd=pdpcd_code 
               --  d.agcd=pagcd_code and d.dpcd=pdpcd_code
                and 
                upper(nvl(pextra1,'D'))='R'
                and (d.SUP_TYPE_CODE=pextra3 or pextra3='' or pextra3 is null)
                group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,
                d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight,d.waste_catg_code)) z
                group by z.comp_code,z.unit_code,z.publ,z.publ_name,z.edtn,z.edtn_name,last_day(trunc(z.supply_date,'mm')),
                    z.copy_rate,z.comm_fix_auto_spl,z.comm_code,z.waste_rate,z.comm_catg_type,z.comm_rate,z.RETURNABLE;
        else
        
        
            open p_circuls for
            select comp_code,unit_code,publ,publ_name,edtn,edtn_name,supply_date,supply_date supply_datemon,
            copy_rate,comm_fix_auto_spl,comm_code,waste_rate,
            substr(comm_rate,1,1) comm_catg_type,substr(comm_rate,2,length(comm_rate)-1) comm_rate,supply_copy,rate_supply,
            RETURNABLE,per_copy_weight,"RETURNABLEper" as "RETURNABLEper" from--P30,C0.5
            (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,
            d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
            d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,cir_get_waste_rate_catg(d.comp_code,d.unit_code,d.edtn,to_char(supdate,''''||pdateformat||''''),''''||pdateformat||'''',d.waste_catg_code,null,null) waste_rate,
            cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,to_char(d.supdate,''''||pdateformat||''''),''''||pdateformat||'''',sum(d.sup_copy),'','') comm_rate,'P' comm_catg_type, sum(d.sup_copy) supply_copy,
            /*(select sum(u.sup_copy) from cir_dbksup u where u.comp_code=d.comp_code and u.unit_code=d.unit_code and 
            (u.publ=d.publ) and u.edtn=d.edtn and u.supdate between v_frdt and v_todt and 
            u.billagcd=pagcd_code and u.billdpcd=pdpcd_code and u.sup_rate=d.sup_rate)*/  
            sum(d.sup_copy) rate_supply,--100 as RETURNABLE,
            cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.sup_copy),puserid,pagcd_code,pdpcd_code,'Q',d.edtn,'')  RETURNABLE,
            d.per_copy_weight per_copy_weight,d.waste_catg_code waste_catg_code
            ,cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.sup_copy),puserid,pagcd_code,pdpcd_code,'P',d.edtn,'') as "RETURNABLEper"
            from CIR_DBKSUP_RESALE d,cir_publ_mast p,cir_edtn_mast e
            where d.comp_code=pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
                  d.unit_code=punit_code and d.publ=p.publ and d.publ=e.publ and
                  (d.publ=ppubl_code or ppubl_code is null) and
                  d.edtn=e.edtn and (d.edtn = pedtn_code or pedtn_code is null) and
                d.supdate between v_frdt and v_todt and
                d.billagcd=pagcd_code and d.billdpcd=pdpcd_code 
              --  d.AGCD =pagcd_code and d.dpcd=pdpcd_code 
                and upper(nvl(pextra1,'D'))='D'
                and (d.SUP_TYPE_CODE=pextra3 or pextra3='' or pextra3 is null)
                group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight,d.waste_catg_code)
               -- group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate,d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight,d.waste_catg_code) z
        
         union
            select distinct z.comp_code comp_code,z.unit_code unit_code,z.publ publ,z.publ_name publ_name,z.edtn,z.edtn_name edtn_name,MAX(z.supply_date) supply_date,last_day(trunc(z.supply_date,'mm')) supply_datemon,
            z.copy_rate copy_rate,z.comm_fix_auto_spl comm_fix_auto_spl,z.comm_code comm_code,z.waste_rate waste_rate,
            z.comm_catg_type comm_catg_type,z.comm_rate comm_rate,sum(z.supply_copy) supply_copy,sum(z.supply_copy) rate_supply,
            RETURNABLE,max(z.per_copy_weight) per_copy_weight,"RETURNABLEper" as "RETURNABLEper" from
            (select distinct comp_code,unit_code,publ,publ_name,edtn,edtn_name,supply_date,
            copy_rate,comm_fix_auto_spl,comm_code,waste_rate,
            substr(comm_rate,1,1) comm_catg_type,substr(comm_rate,2,length(comm_rate)-1) comm_rate,supply_copy,rate_supply,
            RETURNABLE,per_copy_weight,"RETURNABLEper" from--P30,C0.5
            (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,p.publ_name publ_name,
            d.edtn edtn,edition_nick edtn_name,d.supdate supply_date,
            d.sup_rate copy_rate,d.comm_fix_auto_spl comm_fix_auto_spl,d.comm_code comm_code,cir_get_waste_rate_catg(d.comp_code,d.unit_code,d.edtn,to_char(d.supdate,''''||pdateformat||''''),''''||pdateformat||'''',d.waste_catg_code,null,null) waste_rate,
            cir_get_commission(d.comp_code,d.unit_code,d.publ,d.edtn,d.comm_fix_auto_spl ,d.comm_code,
            to_char(d.supdate,''''||pdateformat||''''),''''||pdateformat||'''',sum(d.sup_copy),'','') comm_rate,'P' comm_catg_type, sum(d.sup_copy) supply_copy,
            (select sum(u.sup_copy) from cir_dbksup u where u.comp_code=d.comp_code and u.unit_code=d.unit_code and 
            (u.publ=d.publ) and u.edtn=d.edtn and u.supdate between v_frdt and v_todt and 
            u.billagcd=pagcd_code and u.billdpcd=pdpcd_code and u.sup_rate=d.sup_rate) rate_supply,
            --100 as RETURNABLE,
             cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.sup_copy),puserid,pagcd_code,pdpcd_code,'Q',d.edtn,'')  RETURNABLE,
            d.per_copy_weight per_copy_weight,d.waste_catg_code waste_catg_code
            --,0 RETURNABLEper
            ,cir_get_unsold_returnable(d.comp_code,d.publ,sum(d.sup_copy),puserid,pagcd_code,pdpcd_code,'P',d.edtn,'') as "RETURNABLEper"
            from CIR_DBKSUP_RESALE d,cir_publ_mast p,cir_edtn_mast e
            where d.comp_code=pcomp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and
                  d.unit_code=punit_code and d.publ=p.publ and d.publ=e.publ and
                  (d.publ=ppubl_code or ppubl_code is null) and
                  d.edtn=e.edtn and (d.edtn = pedtn_code or pedtn_code is null) and
                d.supdate between v_frdt and v_todt and
              -- d.AGCD =pagcd_code and d.dpcd=pdpcd_code  
                d.billagcd =pagcd_code and d.dpcd=pdpcd_code 
               
               and upper(nvl(pextra1,'D'))='R'
               and (d.SUP_TYPE_CODE=pextra3 or pextra3='' or pextra3 is null)
                group by d.comp_code,d.unit_code,d.publ,p.publ_name,e.edition_nick,d.edtn,d.supdate, d.sup_rate,d.comm_fix_auto_spl,d.comm_code,d.per_copy_weight,d.waste_catg_code)) z
                group by z.comp_code,z.unit_code,z.publ,z.publ_name,z.edtn,z.edtn_name,last_day(trunc(z.supply_date,'mm')),
                    z.copy_rate,z.comm_fix_auto_spl,z.comm_code,z.waste_rate,z.comm_catg_type,z.comm_rate,RETURNABLE,"RETURNABLEper"
             --   group by z.comp_code,z.unit_code,z.publ,z.publ_name,z.edtn,z.edtn_name,dbo.GetLastDayOfMonth(z.supply_date),
                  --  z.copy_rate,z.comm_fix_auto_spl,z.comm_code,z.waste_rate,z.comm_catg_type,z.comm_rate
                    
                    
                order by publ_name,edtn,supply_date;
        end if;
        --  this table for permissable days---------
       BEGIN
        select  z.output into v_cnt from(    
    select distinct cir_get_unsold_permis_days
    (pcomp_code,nvl(ppubl_code,d.PUBL),'A01',pagcd_code,pdpcd_code,'D',to_date(preceiptdt,''''||pdateformat||''''),to_date(psup_fromdate,''''||pdateformat||''''),'','') as output
    ,publ from CIR_DBKSUP_RESALE d 
    where d.comp_code=pcomp_code and
    d.unit_code=punit_code and
    (d.publ=ppubl_code or ppubl_code is null or ppubl_code='')  
    and (d.edtn = pedtn_code or pedtn_code is null or pedtn_code='') 
    and d.supdate between to_date(psup_fromdate,''''||pdateformat||'''') and to_date(psup_todate,''''||pdateformat||'''') and
    d.billagcd=pagcd_code and d.billdpcd=pdpcd_code
    and (d.SUP_TYPE_CODE=pextra3 or pextra3='' or pextra3 is null)
    --d.AGCD =pagcd_code and d.dpcd=pdpcd_code 

    group by d.PUBL) z where z.output not like 'OK%' and rownum=1;
    EXCEPTION WHEN NO_DATA_FOUND THEN 
    v_cnt:=NULL;
    END;
    
    if(v_cnt is null) then 
     open p_circuls1 for
     select 'OK' AS OUTPUT FROM DUAL;
     ELSE
      open p_circuls1 for
     select v_cnt AS OUTPUT FROM DUAL;
     END IF;
  End cir_unsold_supply_p_resale;
   
   
   
END cir_unsold_credit_note;
/




/////////////////////////////////////END/////////////////////////