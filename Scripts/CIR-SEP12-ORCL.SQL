ALTER TABLE CIR_RCPHDR MODIFY CCDP VARCHAR2(14) NOT NULL

ALTER TABLE CIR_RCPHDR MODIFY RCDP VARCHAR2(14) NOT NULL

ALTER TABLE CIR_RCPHDR_DIS MODIFY CCDP VARCHAR2(14) NOT NULL

ALTER TABLE CIR_RCPHDR_DIS MODIFY RCDP VARCHAR2(14) NOT NULL

////////////////////////////////add by Deepika 21/09/2012  Sent by Laxman sir ///////////////////////////////


                                                                     
                                                                     
                                                                     
                                             
CREATE OR REPLACE PACKAGE BODY cir_rep_abc IS
   procedure cir_commwise_supply_unsold(
     pcomp_code 		in varchar2,
     punit_code 		in varchar2,
     pbrancode          in varchar2,
     ppublcode          in varchar2,
     pagtype 			in varchar2,
     pfrom_supdate 	    in varchar2,
     ptill_supdate 	    in varchar2,
     pdateformat 		in varchar2,
     pextra1 			in varchar2,--for Edition 
     pextra2            in varchar2,--for Sub Edition
     p_accounts         out t_accounts)
    As
     vfrom_supdate    date;
     vtill_supdate    date;
    Begin
        vfrom_supdate:=to_date(pfrom_supdate,''''||pdateformat||'''');
        vtill_supdate:=to_date(ptill_supdate,''''||pdateformat||'''');
     
        open p_accounts for 
        select mon_date mon_dt,to_char(mon_date,'Mon/YYYY') mon_date,comm_rate,sum(billed_copy) billed_copy,sum(unsold_copy) unsold_copy,sum(billed_copy-unsold_copy) net_copy,sum(billed_amt-unsold_amt) net_amount
        from (select last_day(b.billdt) mon_date,b.comm_rate,sum(b.bill_copy) billed_copy,sum(nvl(gross_amount,0)+nvl(sur_amt,0)-nvl(comm_amt,0)) billed_amt,0 unsold_copy,0 unsold_amt 
        from cir_agmast a, cir_bill_det b,cir_edtn_mast e
        where a.comp_code=b.comp_code and a.comp_code=e.comp_code and b.comp_code=pcomp_code and a.unit=b.unit_code and a.unit=e.unit_code and b.unit_code=punit_code and 
        a.agcd=b.agcd and a.dpcd=b.dpcd and a.branch_code=nvl(pbrancode,a.branch_code) and a.ag_type=nvl(pagtype,a.ag_type) and b.publ=nvl(ppublcode,b.publ) and
        b.publ=e.publ and b.edtn=e.edtn and b.edtn=nvl(pextra2,b.edtn) and b.billdt between vfrom_supdate and vtill_supdate and e.main_edtn=nvl(pextra1,e.main_edtn)
        group by b.billdt,b.comm_rate
        union
        select last_day(b.app_dt) mon_date,b.comm_rate comm_rate,0 billed_copy,0 billed_amt,sum(nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0)) unsold_copy,
        sum(nvl(copy_amt,0)-nvl(comm_amt,0)-nvl(waste_amt,0)) unsold_amt 
        from cir_agmast a, cir_unsold_dtl b,cir_edtn_mast e
        where a.comp_code=b.comp_code and a.comp_code=e.comp_code and b.comp_code=pcomp_code and a.unit=b.unit_code and a.unit=e.unit_code and b.unit_code=punit_code and 
        a.agcd=b.agcd and a.dpcd=b.dpcd and a.branch_code=nvl(pbrancode,a.branch_code) and a.ag_type=nvl(pagtype,a.ag_type) and b.publ=nvl(ppublcode,b.publ) and
        b.publ=e.publ and b.edtn=e.edtn and b.edtn=nvl(pextra2,b.edtn) and b.app_dt between vfrom_supdate and vtill_supdate and e.main_edtn=nvl(pextra1,e.main_edtn)
        group by b.app_dt,b.comm_rate)
        group by mon_date,comm_rate
        order by mon_dt,comm_rate;
     
    End cir_commwise_supply_unsold;
    
    procedure cir_rate_comm_supply_unsold(
     pcomp_code 		in varchar2,
     punit_code 		in varchar2,
     pbrancode          in varchar2,
     ppublcode          in varchar2,
     pagtype 			in varchar2,
     pfrom_supdate 	    in varchar2,
     ptill_supdate 	    in varchar2,
     preptype           in varchar2,--for comm & rate wise supply & unsold--
     pdateformat 		in varchar2,
     pextra1 			in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts)
    As
     vfrdt    date;
     vtodt    date;
     v_dt     date;
     v_cnt    number(5):=0;
     vvar     varchar2(2000);
     vvar_sum  varchar2(2000);
     vvar_sum1 varchar2(2000);
     v_query   varchar2(30000);
     v_query1  varchar2(30000);
       cursor c1 is
           select dt from cir_temp_dt order by sqno,dt;
   Begin
        vfrdt:=trunc(to_date(pfrom_supdate,''''||pdateformat||''''),'mm');
        vtodt:=last_day(to_date(ptill_supdate,''''||pdateformat||''''));   
   --delete from test1;commit;
    delete from cir_temp_dt;
    loop
        if v_dt>=vtodt then
            exit;
        else
            if v_dt is null then
                v_dt:=last_day(vfrdt);
            else
                v_dt:=add_months(v_dt,1);
            end if;
        end if;
        v_cnt:=v_cnt+1;
        
        insert into cir_temp_dt(sqno,dt) values(v_cnt,v_dt);
    end loop;

    open c1;
    loop
        fetch c1 into v_dt;
        exit when c1%notfound;
        v_cnt        := v_cnt+1;
        if preptype in('CS','RS') then--comm. wise & Rate wise supply--
            if vvar is null then
                vvar        :='sum(decode(last_day(b.billdt),'||''''||v_dt||''''||',b.bill_copy,0))"'||to_char(v_dt,'Mon/YYYY')||'"';
                vvar_sum    :='sum('||'"'||to_char(v_dt,'Mon/YYYY')||'") "'||to_char(v_dt,'Mon/YYYY')||'"';
                vvar_sum1   :='sum('||'"'||to_char(v_dt,'Mon/YYYY')||'"';
            else
                vvar        :=vvar||','||'sum(decode(last_day(b.billdt),'||''''||v_dt||''''||',b.bill_copy,0))"'||to_char(v_dt,'Mon/YYYY')||'"';
                vvar_sum    :=vvar_sum||','||'sum('||'"'||to_char(v_dt,'Mon/YYYY')||'") "'||to_char(v_dt,'Mon/YYYY')||'"';
                vvar_sum1   :=vvar_sum1||'+"'||to_char(v_dt,'Mon/YYYY')||'"';
            end if;
         elsif preptype in('CU','RU') then--comm. wise & Rate wise unsold--
            if vvar is null then
                vvar        :='sum(decode(last_day(b.app_dt),'||''''||v_dt||''''||',(nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0)),0))"'||to_char(v_dt,'Mon/YYYY')||'"';
                vvar_sum    :='sum('||'"'||to_char(v_dt,'Mon/YYYY')||'") "'||to_char(v_dt,'Mon/YYYY')||'"';
                vvar_sum1   :='sum('||'"'||to_char(v_dt,'Mon/YYYY')||'"';
            else
                vvar        :=vvar||','||'sum(decode(last_day(b.app_dt),'||''''||v_dt||''''||',(nvl(b.apr_short_recpt,0)+nvl(b.apr_late_recpt,0)+nvl(b.apr_bnr,0)+nvl(b.apr_unsold,0)),0))"'||to_char(v_dt,'Mon/YYYY')||'"';
                vvar_sum    :=vvar_sum||','||'sum('||'"'||to_char(v_dt,'Mon/YYYY')||'") "'||to_char(v_dt,'Mon/YYYY')||'"';
                vvar_sum1   :=vvar_sum1||'+"'||to_char(v_dt,'Mon/YYYY')||'"';
            end if;
         end if;
    end loop;
    close c1;
    if vvar_sum1 is not null then
        vvar_sum1:=vvar_sum1||') "Total"';
    end if;

    if preptype='CS' then--comm. wise supply-- 
        v_query:='select comp_code,unit_code,comm_rate ,'||vvar_sum||','||vvar_sum1||' from (select b.comp_code comp_code,b.unit_code unit_code,nvl(b.comm_rate,0) comm_rate, '||vvar||' from cir_agmast a, cir_bill_det b
        where a.comp_code=b.comp_code and b.comp_code='||''''||pcomp_code||''''||' and a.unit=b.unit_code and b.unit_code='||''''||punit_code||''''||' and 
        a.agcd=b.agcd and a.dpcd=b.dpcd and a.branch_code=nvl('||''''||pbrancode||''''||',a.branch_code) and a.ag_type=nvl('||''''||pagtype||''''||',a.ag_type) and b.publ=nvl('||''''||ppublcode||''''||',b.publ) and
        b.billdt between '||''''||vfrdt||''''||' and '||''''||vtodt||''''||' group by b.comp_code,b.unit_code,b.billdt,b.comm_rate)
        group by comp_code,unit_code,comm_rate order by comp_code,unit_code,comm_rate';
        
        v_query1:='select comp_code,unit_code,'||vvar_sum||','||vvar_sum1||' from (select b.comp_code comp_code,b.unit_code unit_code,nvl(b.comm_rate,0) comm_rate, '||vvar||' from cir_agmast a, cir_bill_det b
        where a.comp_code=b.comp_code and b.comp_code='||''''||pcomp_code||''''||' and a.unit=b.unit_code and b.unit_code='||''''||punit_code||''''||' and 
        a.agcd=b.agcd and a.dpcd=b.dpcd and a.branch_code=nvl('||''''||pbrancode||''''||',a.branch_code) and a.ag_type=nvl('||''''||pagtype||''''||',a.ag_type) and b.publ=nvl('||''''||ppublcode||''''||',b.publ) and
        b.billdt between '||''''||vfrdt||''''||' and '||''''||vtodt||''''||' group by b.comp_code,b.unit_code,b.billdt,b.comm_rate)
        group by comp_code,unit_code order by comp_code,unit_code';        
    elsif preptype='RS' then-- Edition Rate wise supply-- 
        v_query:='select comp_code,unit_code,publ,cir_get_publ_name(comp_code,publ) publ_name,cir_get_publ_seqno(comp_code,publ) publ_seqno,edtn,cir_get_edtn_name(comp_code,edtn) edtn_name,cir_get_edtn_seqno(comp_code,edtn) edtn_seqno,copy_rate ,'||vvar_sum||','||vvar_sum1||' 
        from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,nvl(b.copy_rate,0) copy_rate, '||vvar||' from cir_agmast a, cir_bill_det b
        where a.comp_code=b.comp_code and b.comp_code='||''''||pcomp_code||''''||' and a.unit=b.unit_code and b.unit_code='||''''||punit_code||''''||' and 
        a.agcd=b.agcd and a.dpcd=b.dpcd and a.branch_code=nvl('||''''||pbrancode||''''||',a.branch_code) and a.ag_type=nvl('||''''||pagtype||''''||',a.ag_type) and b.publ=nvl('||''''||ppublcode||''''||',b.publ) and
        b.billdt between '||''''||vfrdt||''''||' and '||''''||vtodt||''''||' group by b.comp_code,b.unit_code,b.billdt,b.publ,b.edtn,b.copy_rate)
        group by comp_code,unit_code,publ,edtn,copy_rate order by comp_code,unit_code,publ_seqno,publ,edtn_seqno,edtn,copy_rate';
        
        v_query1:='select comp_code,unit_code,'||vvar_sum||','||vvar_sum1||' 
        from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,nvl(b.copy_rate,0) copy_rate, '||vvar||' from cir_agmast a, cir_bill_det b
        where a.comp_code=b.comp_code and b.comp_code='||''''||pcomp_code||''''||' and a.unit=b.unit_code and b.unit_code='||''''||punit_code||''''||' and 
        a.agcd=b.agcd and a.dpcd=b.dpcd and a.branch_code=nvl('||''''||pbrancode||''''||',a.branch_code) and a.ag_type=nvl('||''''||pagtype||''''||',a.ag_type) and b.publ=nvl('||''''||ppublcode||''''||',b.publ) and
        b.billdt between '||''''||vfrdt||''''||' and '||''''||vtodt||''''||' group by b.comp_code,b.unit_code,b.billdt,b.publ,b.edtn,b.copy_rate)
        group by comp_code,unit_code order by comp_code,unit_code';
    elsif preptype='CU' then--comm. wise unsold-- 
        v_query:='select comp_code,unit_code,comm_rate ,'||vvar_sum||','||vvar_sum1||' from (select b.comp_code comp_code,b.unit_code unit_code,nvl(b.comm_rate,0) comm_rate, '||vvar||' from cir_agmast a, cir_unsold_dtl b
        where a.comp_code=b.comp_code and b.comp_code='||''''||pcomp_code||''''||' and a.unit=b.unit_code and b.unit_code='||''''||punit_code||''''||' and 
        a.agcd=b.agcd and a.dpcd=b.dpcd and a.branch_code=nvl('||''''||pbrancode||''''||',a.branch_code) and a.ag_type=nvl('||''''||pagtype||''''||',a.ag_type) and b.publ=nvl('||''''||ppublcode||''''||',b.publ) and
        b.app_dt between '||''''||vfrdt||''''||' and '||''''||vtodt||''''||' group by b.comp_code,b.unit_code,b.app_dt,b.comm_rate)
        group by comp_code,unit_code,comm_rate order by comp_code,unit_code,comm_rate'; 
        
        v_query1:='select comp_code,unit_code,'||vvar_sum||','||vvar_sum1||' from (select b.comp_code comp_code,b.unit_code unit_code,nvl(b.comm_rate,0) comm_rate, '||vvar||' from cir_agmast a, cir_unsold_dtl b
        where a.comp_code=b.comp_code and b.comp_code='||''''||pcomp_code||''''||' and a.unit=b.unit_code and b.unit_code='||''''||punit_code||''''||' and 
        a.agcd=b.agcd and a.dpcd=b.dpcd and a.branch_code=nvl('||''''||pbrancode||''''||',a.branch_code) and a.ag_type=nvl('||''''||pagtype||''''||',a.ag_type) and b.publ=nvl('||''''||ppublcode||''''||',b.publ) and
        b.app_dt between '||''''||vfrdt||''''||' and '||''''||vtodt||''''||' group by b.comp_code,b.unit_code,b.app_dt,b.comm_rate)
        group by comp_code,unit_code order by comp_code,unit_code';        
    elsif preptype='RU' then-- Edition Rate wise Unsold-- 
        v_query:='select comp_code,unit_code,publ,cir_get_publ_name(comp_code,publ) publ_name,cir_get_publ_seqno(comp_code,publ) publ_seqno,edtn,cir_get_edtn_name(comp_code,edtn) edtn_name,cir_get_edtn_seqno(comp_code,edtn) edtn_seqno,copy_rate ,'||vvar_sum||','||vvar_sum1||' 
        from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,nvl(b.copy_rate,0) copy_rate, '||vvar||' from cir_agmast a, cir_unsold_dtl b
        where a.comp_code=b.comp_code and b.comp_code='||''''||pcomp_code||''''||' and a.unit=b.unit_code and b.unit_code='||''''||punit_code||''''||' and 
        a.agcd=b.agcd and a.dpcd=b.dpcd and a.branch_code=nvl('||''''||pbrancode||''''||',a.branch_code) and a.ag_type=nvl('||''''||pagtype||''''||',a.ag_type) and b.publ=nvl('||''''||ppublcode||''''||',b.publ) and
        b.app_dt between '||''''||vfrdt||''''||' and '||''''||vtodt||''''||' group by b.comp_code,b.unit_code,b.app_dt,b.publ,b.edtn,b.copy_rate)
        group by comp_code,unit_code,publ,edtn,copy_rate order by comp_code,unit_code,publ_seqno,publ,edtn_seqno,edtn,copy_rate';
        
        v_query1:='select comp_code,unit_code,'||vvar_sum||','||vvar_sum1||' 
        from (select b.comp_code comp_code,b.unit_code unit_code,b.publ publ,b.edtn edtn,nvl(b.copy_rate,0) copy_rate, '||vvar||' from cir_agmast a, cir_unsold_dtl b
        where a.comp_code=b.comp_code and b.comp_code='||''''||pcomp_code||''''||' and a.unit=b.unit_code and b.unit_code='||''''||punit_code||''''||' and 
        a.agcd=b.agcd and a.dpcd=b.dpcd and a.branch_code=nvl('||''''||pbrancode||''''||',a.branch_code) and a.ag_type=nvl('||''''||pagtype||''''||',a.ag_type) and b.publ=nvl('||''''||ppublcode||''''||',b.publ) and
        b.app_dt between '||''''||vfrdt||''''||' and '||''''||vtodt||''''||' group by b.comp_code,b.unit_code,b.app_dt,b.publ,b.edtn,b.copy_rate)
        group by comp_code,unit_code order by comp_code,unit_code';
    end if;   
    
    --insert into test1(vstring,vstring2) values('cir_rate_comm_supply_unsold ',v_query);commit;
   --insert into test1(vstring,vstring2) values('cir_rate_comm_supply_unsold v_query1',v_query1);commit;
    
    open p_accounts for v_query;
    
    open p_accounts1 for v_query1;
        
    End cir_rate_comm_supply_unsold;
        
    procedure cir_citywise_supply(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pbrancode          in varchar2,
     ppublcode          in varchar2,
     pagtype             in varchar2,
     pstatecode         in varchar2,
     pcitycode          in varchar2,
     pfrom_supdate         in varchar2,
     ptill_supdate         in varchar2,
     pdateformat         in varchar2,
     pextra1             in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts)
    As
     vfrdt    date;
     vtodt    date;
     v_dt     date;
     v_cnt    number(5):=0;
     vvar     varchar2(2000);
     vvar_sum     varchar2(2000);
     vvar_sum1    varchar2(2000);
     v_query    varchar2(30000);
       cursor c1 is
           select dt from cir_temp_dt order by sqno,dt;
   Begin
        vfrdt:=trunc(to_date(pfrom_supdate,''''||pdateformat||''''),'mm');
        vtodt:=last_day(to_date(ptill_supdate,''''||pdateformat||''''));
        delete from cir_temp_dt;
        --delete from test1;
        loop
            if v_dt>=vtodt then
                exit;
            else
                if v_dt is null then
                    v_dt:=last_day(vfrdt);
                else
                    v_dt:=add_months(v_dt,1);
                end if;
            end if;
            v_cnt:=v_cnt+1;
            
            insert into cir_temp_dt(sqno,dt) values(v_cnt,v_dt);
        end loop;

        open c1;
        loop
            fetch c1 into v_dt;
            exit when c1%notfound;
            v_cnt        := v_cnt+1;
                if vvar is null then
                    vvar        :='sum(decode(last_day(b.billdt),'||''''||v_dt||''''||',b.bill_copy,0))"'||to_char(v_dt,'Mon/YYYY')||'"';
                    vvar_sum    :='sum('||'"'||to_char(v_dt,'Mon/YYYY')||'") "'||to_char(v_dt,'Mon/YYYY')||'"';
                    vvar_sum1   :='sum('||'"'||to_char(v_dt,'Mon/YYYY')||'"';
                else
                    vvar        :=vvar||','||'sum(decode(last_day(b.billdt),'||''''||v_dt||''''||',b.bill_copy,0))"'||to_char(v_dt,'Mon/YYYY')||'"';
                    vvar_sum    :=vvar_sum||','||'sum('||'"'||to_char(v_dt,'Mon/YYYY')||'") "'||to_char(v_dt,'Mon/YYYY')||'"';
                    vvar_sum1   :=vvar_sum1||'+"'||to_char(v_dt,'Mon/YYYY')||'"';
                end if;
        end loop;
        close c1;
        if vvar_sum1 is not null then
            vvar_sum1:=vvar_sum1||') "Total"';
        end if;
                
        v_query:='select d.comp_code comp_code,d.unit_code unit_code,s."State_Name" state_name,cir_get_city(d.comp_code,d.city_code) city_name,'||vvar_sum||','||vvar_sum1||' from (select b.comp_code comp_code,b.unit_code unit_code,a.state_code state_code,
        a.city_code city_code,'||vvar||' from cir_agmast a, cir_bill_det b
        where a.comp_code=b.comp_code and b.comp_code='||''''||pcomp_code||''''||' and a.unit=b.unit_code and b.unit_code='||''''||punit_code||''''||' and 
        a.agcd=b.agcd and a.dpcd=b.dpcd and a.branch_code=nvl('||''''||pbrancode||''''||',a.branch_code) and a.ag_type=nvl('||''''||pagtype||''''||',a.ag_type) and 
        b.publ=nvl('||''''||ppublcode||''''||',b.publ) and a.state_code=nvl('||''''||pstatecode||''''||',a.state_code) and a.city_code=nvl('||''''||pcitycode||''''||',a.city_code) and
        b.billdt between '||''''||vfrdt||''''||' and '||''''||vtodt||''''||' group by b.comp_code,b.unit_code,b.billdt,a.city_code,a.state_code) d,state_mst s
        where d.state_code=s."State_Code"(+)
        group by d.comp_code,d.unit_code,s."State_Name",d.city_code order by comp_code,unit_code,state_name,city_name';
        --insert into test1(vstring,vstring2) values('cir_citywise_supply ',v_query);commit;
        open p_accounts for v_query;
        
        v_query:='select d.comp_code comp_code,d.unit_code unit_code,s."State_Name" state_name,'||vvar_sum||','||vvar_sum1||' from (select b.comp_code comp_code,b.unit_code unit_code,a.state_code state_code,
        a.city_code city_code,'||vvar||' from cir_agmast a, cir_bill_det b
        where a.comp_code=b.comp_code and b.comp_code='||''''||pcomp_code||''''||' and a.unit=b.unit_code and b.unit_code='||''''||punit_code||''''||' and 
        a.agcd=b.agcd and a.dpcd=b.dpcd and a.branch_code=nvl('||''''||pbrancode||''''||',a.branch_code) and a.ag_type=nvl('||''''||pagtype||''''||',a.ag_type) and 
        b.publ=nvl('||''''||ppublcode||''''||',b.publ) and a.state_code=nvl('||''''||pstatecode||''''||',a.state_code) and a.city_code=nvl('||''''||pcitycode||''''||',a.city_code) and
        b.billdt between '||''''||vfrdt||''''||' and '||''''||vtodt||''''||' group by b.comp_code,b.unit_code,b.billdt,a.city_code,a.state_code) d,state_mst s
        where d.state_code=s."State_Code"(+)
        group by d.comp_code,d.unit_code,s."State_Name" order by comp_code,unit_code,state_name';
        --insert into test1(vstring,vstring2) values('cir_citywise_supply ',v_query);commit;
        open p_accounts1 for v_query;        
        
   End cir_citywise_supply;
    
    procedure cir_agencywise_supply(
        pcomp_code         in varchar2,
        punit_code         in varchar2,
        pbrancode       in varchar2,
        ppublcode       in varchar2,
        pagcd           in varchar2,
        pdpcd           in varchar2,
        pagtype         in varchar2,
        pstatecode      in varchar2,
        pcitycode       in varchar2,
        pfrom_supdate     in varchar2,
        ptill_supdate     in varchar2,
        psortedby       in varchar2,
        pdateformat     in varchar2,
        pextra1         in varchar2,
        pextra2         in varchar2,
        p_accounts      out t_accounts)
    As
     vfrdt    date;
     vtodt    date;
     v_dt     date;
     v_cnt    number(5):=0;
     vvar     varchar2(2000);
     vvar_sum     varchar2(2000);
     vvar_sum1    varchar2(2000);
     v_query    varchar2(30000);
       cursor c1 is
           select dt from cir_temp_dt order by sqno,dt;
   Begin
        vfrdt:=trunc(to_date(pfrom_supdate,''''||pdateformat||''''),'mm');
        vtodt:=last_day(to_date(ptill_supdate,''''||pdateformat||''''));   
    delete from cir_temp_dt;
    --delete from test1;
    loop
        if v_dt>=vtodt then
            exit;
        else
            if v_dt is null then
                v_dt:=last_day(vfrdt);
            else
                v_dt:=add_months(v_dt,1);
            end if;
        end if;
        v_cnt:=v_cnt+1;
        
        insert into cir_temp_dt(sqno,dt) values(v_cnt,v_dt);
    end loop;

    open c1;
    loop
        fetch c1 into v_dt;
        exit when c1%notfound;
        v_cnt        := v_cnt+1;
            if vvar is null then
                vvar        :='sum(decode(last_day(b.billdt),'||''''||v_dt||''''||',b.bill_copy,0))"'||to_char(v_dt,'Mon/YY')||'"';
                vvar_sum    :='sum('||'"'||to_char(v_dt,'Mon/YY')||'") "'||to_char(v_dt,'Mon/YY')||'"';
                vvar_sum1   :='sum('||'"'||to_char(v_dt,'Mon/YY')||'"';
            else
                vvar        :=vvar||','||'sum(decode(last_day(b.billdt),'||''''||v_dt||''''||',b.bill_copy,0))"'||to_char(v_dt,'Mon/YY')||'"';
                vvar_sum    :=vvar_sum||','||'sum('||'"'||to_char(v_dt,'Mon/YY')||'") "'||to_char(v_dt,'Mon/YY')||'"';
                vvar_sum1   :=vvar_sum1||'+"'||to_char(v_dt,'Mon/YY')||'"';
            end if;
    end loop;
    close c1;
    if vvar_sum1 is not null then
        vvar_sum1:=vvar_sum1||') "Total"';
    end if;

        v_query:='select comp_code,unit_code,comm_rate ,ag_name,cir_get_city(comp_code,city_code) city_name,'||vvar_sum||','||vvar_sum1||' from (select b.comp_code comp_code,b.unit_code unit_code,nvl(b.comm_rate,0) comm_rate,a.agcd agcd,b.dpcd dpcd,
        a.ag_name ag_name,a.city_code city_code,'||vvar||' from cir_agmast a, cir_bill_det b
        where a.comp_code=b.comp_code and b.comp_code='||''''||pcomp_code||''''||' and a.unit=b.unit_code and b.unit_code='||''''||punit_code||''''||' and 
        a.agcd=b.agcd and a.dpcd=b.dpcd and a.agcd=nvl('||''''||pagcd||''''||',a.agcd) and a.dpcd=nvl('||''''||pdpcd||''''||',a.dpcd) and a.branch_code=nvl('||''''||pbrancode||''''||',a.branch_code) and a.ag_type=nvl('||''''||pagtype||''''||',a.ag_type) and b.publ=nvl('||''''||ppublcode||''''||',b.publ) and
        b.billdt between '||''''||vfrdt||''''||' and '||''''||vtodt||''''||' and a.state_code=nvl('||''''||pstatecode||''''||',a.state_code) and a.city_code=nvl('||''''||pcitycode||''''||',a.city_code) group by b.comp_code,b.unit_code,b.billdt,b.comm_rate,a.city_code,a.agcd,b.dpcd,a.ag_name)
        group by comp_code,unit_code,comm_rate,city_code,ag_name order by comp_code,unit_code,comm_rate,ag_name';
    --insert into test1(vstring,vstring2) values('cir_agencywise_supply ',v_query);commit;
    
    open p_accounts for v_query;
        
    End cir_agencywise_supply;  
    
    procedure cir_monthwise_billing_summary(
        pcomp_code         in varchar2,
        punit_code         in varchar2,
        pbrancode       in varchar2,
        ppublcode       in varchar2,
        pagtype         in varchar2,
        pstatecode      in varchar2,
        pcitycode       in varchar2,
        pfromdate       in varchar2,
        ptilldate       in varchar2,
        pdateformat     in varchar2,
        pextra1         in varchar2,
        pextra2         in varchar2,
        p_accounts      out t_accounts)
    As
     vfrdt    date;
     vtodt    date;
   Begin
        vfrdt:=trunc(to_date(pfromdate,''''||pdateformat||''''),'mm');
        vtodt:=last_day(to_date(ptilldate,''''||pdateformat||''''));
        
        open p_accounts for 
        select b.comp_code comp_code,b.unit_code unit_code,last_day(b.billdt) billdt,to_char(last_day(b.billdt),'Mon/YYYY') month_date,sum(b.bill_copy) billing_copy,sum(b.gross_amount) gross_amount,
       sum(b.sur_amt) sur_amount, sum(b.comm_amt) comm_amount,sum(b.bill_amount) bill_amount 
        from cir_agmast a,cir_bill_det b 
        where a.comp_code=b.comp_code and b.comp_code=pcomp_code and a.unit=b.unit_code and b.unit_code=punit_code and 
        a.agcd=b.agcd and a.dpcd=b.dpcd and a.branch_code=nvl(pbrancode,a.branch_code) and a.ag_type=nvl(pagtype,a.ag_type) and 
        b.publ=nvl(ppublcode,b.publ) and b.billdt between vfrdt and vtodt
        group by b.comp_code,b.unit_code,last_day(b.billdt)
        order by b.comp_code,b.unit_code,last_day(b.billdt);
        
        
    End cir_monthwise_billing_summary;
    
  procedure cir_billing_outstanding(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pbrancode          in varchar2,
     pagcd              in varchar2,
     pdpcd              in varchar2,
     pagtype             in varchar2,
     pstatecode         in varchar2,
     pcitycode          in varchar2,
     pason_date         in varchar2,
     pdateformat         in varchar2,
     pextra1             in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts)
    As
        v_ason        date;
        v_opdate      date;
        v_opbal       number(15,2):=0;
        v_clbal       number(15,2):=0;
        v_billamt     number:=0;
        v_dbcramt     number:=0;
        v_diff        number:=0;
        cursor c1 is 
            select distinct comp_code,unit,agcd,dpcd,ag_name,ag_name_oth_lang,city_code,tehsil_taluka,dist_code,state_code,
            country_code from cir_agmast 
                where comp_code=pcomp_code and unit=punit_code and 
                      (ag_type=pagtype or pagtype is null) and agcd||dpcd in(select distinct agcd||dpcd from cir_outmast 
                      where comp_code=pcomp_code and (unit_code=punit_code or punit_code is null) and 
                      achd='NM' /*and (agcd=pagcd or pagcd is null) and (dpcd=pdpcd or pdpcd is null)*/);
        v1 c1%rowtype;
    Begin
        v_ason:=to_date(pason_date,''''||pdateformat||'''');

        v_opdate    :=cir_get_finandt(pcomp_code,v_ason,pdateformat,'','');--for financial date
        
        delete from cir_temp_outstanding;
        --delete from test1;commit;
        --insert into test1(vstring,vstring2) values('unit outstanding monthwise vvar ',v_months);commit;    
        open c1;
        loop
            fetch c1 into v1;
            exit when c1%notfound;
            v_opbal        :=cir_accounts.cir_agency_opbal(pcomp_code,punit_code,'',v1.agcd,v1.dpcd,v_opdate,'NM',pdateformat,pextra1,pextra2);

            select sum(amount) into v_billamt from cir_outmast
                where comp_code=pcomp_code and (unit_code=punit_code or punit_code is null) and 
                            agcd=v1.agcd and dpcd=v1.dpcd and billdt >= v_opdate and billdt<=v_ason and 
                            achd='NM' and recptno is null;            
            select sum(amount) into v_dbcramt from cir_rcphdr
                where comp_code=pcomp_code and (unit_code=punit_code or punit_code is null) and 
                            agcd=v1.agcd and dpcd=v1.dpcd and recptdt>= v_opdate and recptdt<=v_ason and 
                            achd='NM';
            
            v_clbal:=nvl(v_opbal,0)+nvl(v_billamt,0)+nvl(v_dbcramt,0);
            v_billamt:=0;v_dbcramt:=0;
            select sum(bill_amount) into v_dbcramt from cir_bill ----previous bill amount
                where comp_code=pcomp_code and unit_code=punit_code and 
                    billdt between trunc(add_months(v_ason,-1)) and last_day(add_months(v_ason,-1)) and 
                    agcd=v1.agcd and dpcd=v1.dpcd;


            select sum(bill_amount) into v_billamt from cir_bill--------current bill amount 
                where comp_code=pcomp_code and unit_code=punit_code and 
                    billdt=last_day(v_ason) and agcd=v1.agcd  and dpcd=v1.dpcd;
                                
            if v_clbal<>0 or nvl(v_billamt,0)<>0 or nvl(v_dbcramt,0)<>0 then
                
                v_diff:=(nvl(v_clbal,0)-nvl(v_billamt,0)-nvl(v_dbcramt,0));
                
                if v_diff<=0 then
                    v_diff:=0;
                else            
                    v_diff:=v_diff;
                end if;    

                insert into cir_temp_outstanding(comp_code,unit_code,dt,publ_code,agcd,dpcd,op_amt,bill_amt,dn_amt,cn_amt,
                            agname,agname_oth_lang,city_code,taluka_code,dist_code,state_code,country_code)
                            values(v1.comp_code,v1.unit,v_ason,'',v1.agcd,v1.dpcd,v_clbal,v_billamt,v_dbcramt,v_diff,
                            v1.ag_name,v1.ag_name_oth_lang,v1.city_code,v1.tehsil_taluka,v1.dist_code,v1.state_code,v1.country_code);
            end if;
            v_billamt:=0;v_dbcramt:=0;v_opbal    :=0;v_clbal:=0;v_diff:=0;
        end loop;
        close c1;
        
        open p_accounts for
        select comp_code,unit_code,dt,publ_code,agcd,dpcd,agname,agname_oth_lang,
        op_amt as outstanding_amt,bill_amt as curr_billamt,dn_amt as prev_billamt,cn_amt as diff_amt,
        city_code,cir_get_city(comp_code,city_code) city_name,taluka_code,cir_get_taluka(comp_code,taluka_code) taluka_name,
        dist_code,cir_get_dist(comp_code,state_code,dist_code) dist_name, state_code,country_code 
        from cir_temp_outstanding
        where comp_code=pcomp_code and unit_code=punit_code
        order by comp_code,unit_code,city_name,agname;
        
   End cir_billing_outstanding;
   
    procedure cir_area_break_down(
        pcomp_code         in varchar2,
        punit_code         in varchar2,
        pbrancode          in varchar2,
        ppublcode          in varchar2,
        pmedtncode         in varchar2,
        pedtncode          in varchar2,
        pagtype            in varchar2,
        pzonecode          in varchar2,
        pregioncode        in varchar2,
        pstatecode         in varchar2,
        pdistcode          in varchar2,
        pfromdate          in varchar2,
        ptilldate          in varchar2,
        psup_copy          in number,
        psup_baseon        in varchar2,--it is used for Gross(G)/Average(A)
        pdateformat        in varchar2,
        puserid            in varchar2,
        pbreakon           in number,--it is used for Grouping on Zone(1)/Region(2)/State(3)/Branch(4)/District(5)/Taluka(6)
        pdatashow          in number,--it is used for data show Agency(1)/City(2)
        pextra1            in varchar2,
        pextra2            in varchar2,
        pextra3            in varchar2,
        pextra4            in varchar2,
        pextra5            in varchar2,
        p_accounts         out t_accounts,
        p_accounts1        out t_accounts)
  As
    v_frdt date;
    v_todt date;
    cursor cur_supply is 
    select a.comp_code comp_code,a.unit unit,a.agcd agcd,a.dpcd dpcd,a.ag_name agency_name,
    d.zone_code zone_code,cir_get_zone_name(a.comp_code,d.zone_code) zone_name,
    d.region_code region,cir_get_region_name(a.comp_code,d.region_code) region_name,
    a.state_code state_code,cir_get_state(a.comp_code,a.country_code,a.state_code) state_name,
    a.dist_code dist_code,cir_get_dist(a.comp_code,a.state_code,a.dist_code) dist_name, 
    nvl(a.abc_citycode,a.city_code) city_code,d.city_name city_name,
    a.tehsil_taluka taluka_code,cir_get_taluka(a.comp_code,a.tehsil_taluka) taluka_name,
    a.branch_code branch_code,null branch_name,
    sum(b.sup_copy) sup_copy
    from cir_agmast a,cir_dbksup b,cir_edtn_mast c,cir_city_mast d
    where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=d.comp_code and a.comp_code=pcomp_code and 
        a.unit=punit_code and a.unit=b.unit_code and a.unit=c.unit_code and a.agcd=b.agcd and a.dpcd=b.dpcd and 
        b.supdate>=v_frdt and b.supdate<=v_todt and b.publ=c.publ and b.publ=nvl(ppublcode,b.publ) and b.edtn=c.edtn and  b.edtn=nvl(pedtncode, b.edtn) and c.main_edtn=nvl(pmedtncode, c.main_edtn) and
        nvl(a.abc_citycode,a.city_code)=d.city_code and (d.zone_code=pzonecode or pzonecode is null) and (d.region_code=pregioncode  or pregioncode is null)
        group by a.comp_code,a.unit,a.agcd,a.dpcd,a.ag_name,a.country_code,a.state_code,a.dist_code,nvl(a.abc_citycode,a.city_code),d.city_name,d.zone_code,d.region_code,a.tehsil_taluka,a.branch_code;
    rec_supply cur_supply%rowtype;        
  Begin
    v_frdt:=to_date(pfromdate,''''||pdateformat||'''');
    v_todt:=to_date(ptilldate,''''||pdateformat||'''');
    delete from cir_temp_bill_collection where cur_sessionid=userenv('sessionid');
    open cur_supply;
    loop
        fetch cur_supply into rec_supply;
        exit when cur_supply%notfound;
        
        insert into cir_temp_bill_collection(comp_code,unit_code,agcd,dpcd,agname, agname_oth_lang ,remarks ,state_code,
            billno,dist_code,taluka_code,city_code,publ_code,supply_copy,return_copy,cur_sessionid)
        values(rec_supply.comp_code,rec_supply.unit,rec_supply.agcd,rec_supply.dpcd,rec_supply.agency_name,rec_supply.zone_name,rec_supply.region_name,rec_supply.state_name,
            rec_supply.branch_name,rec_supply.dist_name,rec_supply.taluka_name,rec_supply.city_name,null,rec_supply.sup_copy,0,userenv('sessionid'));

    end loop;
    close cur_supply;    
    
    if pdatashow='1' then --agency wise
        if pbreakon='1' then --zone wise
            open p_accounts for
            select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname agname,
            a.agname_oth_lang zone_code,a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<nvl(psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=nvl(psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from cir_temp_bill_collection a where a.cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.city_code
            order by comp_code,unit_code,zone_code,agname,city_name,agcd,dpcd;
            
            open p_accounts1 for 
            select x.comp_code comp_code,x.unit_code unit_code,
            x.zone_code zone_code,sum(x.gross_copy) gross_copy,
            sum(x.less_copy) as less_copy,sum(x.Above_copy) as Above_copy
            from
            (select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname agname,
            a.agname_oth_lang zone_code,a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<nvl(psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=nvl(psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from cir_temp_bill_collection a where a.cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.city_code)x
            order by comp_code,unit_code,zone_code;
            
        elsif pbreakon='2' then --region wise
            open p_accounts for
            select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname agname,
            a.remarks region_name,a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<nvl(psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=nvl(psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from cir_temp_bill_collection a where a.cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.remarks,a.city_code,a.agcd,a.dpcd,a.agname
            order by comp_code,unit_code,region_name,agname,city_name;
            
            open p_accounts1 for 
            select x.comp_code comp_code,x.unit_code unit_code,
            x.region_name region_name,sum(x.gross_copy) gross_copy,
            sum(x.less_copy) as less_copy,sum(x.Above_copy) as Above_copy
            from
            (select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname agname,
            a.remarks region_name,a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<nvl(psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=nvl(psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from cir_temp_bill_collection a where a.cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.remarks,a.city_code,a.agcd,a.dpcd,a.agname)x
            order by comp_code,unit_code,region_name;
                    
        elsif pbreakon='3' then --state wise
            open p_accounts for
            select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname agname,
            a.state_code state_name,
            a.city_code city_name,
            a.taluka_code taluka_name,sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<nvl(psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=nvl(psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from cir_temp_bill_collection a where a.cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.state_code,a.city_code,a.agcd,a.dpcd,a.agname
            order by comp_code,unit_code,state_name,agname,city_name;
            
            open p_accounts1 for 
            select x.comp_code comp_code,x.unit_code unit_code,
            x.state_name state_name,sum(x.gross_copy) gross_copy,
            sum(x.less_copy) as less_copy,sum(x.Above_copy) as Above_copy
            from
            (select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname agname,
            a.state_code state_name,
            a.city_code city_name,
            a.taluka_code taluka_name,sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<nvl(psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=nvl(psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from cir_temp_bill_collection a where a.cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.state_code,a.city_code,a.agcd,a.dpcd,a.agname)x
            order by comp_code,unit_code,state_name;        
        elsif pbreakon='4' then --Branch wise
            
            open p_accounts for
            select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname agname,
            a.billno branch_name,
            a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<nvl(psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=nvl(psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from cir_temp_bill_collection a where a.cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.billno,a.city_code,a.agcd,a.dpcd,a.agname
            order by comp_code,unit_code,branch_name,agname,city_name;
            
            open p_accounts1 for 
            select x.comp_code comp_code,x.unit_code unit_code,
            x.branch_name branch_name,sum(x.gross_copy) gross_copy,
            sum(x.less_copy) as less_copy,sum(x.Above_copy) as Above_copy
            from
            (select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname agname,
            a.billno branch_name,
            a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<nvl(psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=nvl(psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from cir_temp_bill_collection a where a.cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.billno,a.city_code,a.agcd,a.dpcd,a.agname)x
            order by comp_code,unit_code,branch_name;
            
        elsif pbreakon='5' then --District wise
            open p_accounts for
            select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname agname,
            a.dist_code dist_name, 
            a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<nvl(psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=nvl(psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from cir_temp_bill_collection a where a.cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.dist_code,a.city_code,a.agcd,a.dpcd,a.agname
            order by comp_code,unit_code,dist_name,agname,city_name;
            
            open p_accounts1 for 
            select x.comp_code comp_code,x.unit_code unit_code,
            x.dist_name dist_name,sum(x.gross_copy) gross_copy,
            sum(x.less_copy) as less_copy,sum(x.Above_copy) as Above_copy
            from
            (select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname agname,
            a.dist_code dist_name, 
            a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<nvl(psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=nvl(psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from cir_temp_bill_collection a where a.cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.dist_code,a.city_code,a.agcd,a.dpcd,a.agname)x
            order by comp_code,unit_code,dist_name;        
        elsif pbreakon='6' then --Taluka wise
            open p_accounts for
            select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname agname,
            a.taluka_code taluka_name,
            a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<nvl(psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=nvl(psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from cir_temp_bill_collection a where a.cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.taluka_code,a.city_code,a.agcd,a.dpcd,a.agname
            order by comp_code,unit_code,taluka_name,agname,city_name;
            
            open p_accounts1 for 
            select x.comp_code comp_code,x.unit_code unit_code,
            x.taluka_name taluka_name,sum(x.gross_copy) gross_copy,
            sum(x.less_copy) as less_copy,sum(x.Above_copy) as Above_copy
            from
            (select a.comp_code comp_code,a.unit_code unit_code,a.agcd agcd,a.dpcd dpcd,a.agname agname,
            a.taluka_code taluka_name,
            a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<nvl(psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=nvl(psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from cir_temp_bill_collection a where a.cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.taluka_code,a.city_code,a.agcd,a.dpcd,a.agname)x
            order by comp_code,unit_code,taluka_name;        
         end if;   
    else --city wise
        if pbreakon='1' then --zone wise
            open p_accounts for
            select a.comp_code comp_code,a.unit_code unit_code,
            a.agname_oth_lang zone_code,a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<nvl(psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=nvl(psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from cir_temp_bill_collection a where a.cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.agname_oth_lang,a.city_code
            order by comp_code,unit_code,zone_code,city_name;
            
            open p_accounts1 for 
            select x.comp_code comp_code,x.unit_code unit_code,
            x.zone_code zone_code,sum(x.gross_copy) gross_copy,
            sum(x.less_copy) as less_copy,sum(x.Above_copy) as Above_copy
            from
            (select a.comp_code comp_code,a.unit_code unit_code,
            a.agname_oth_lang zone_code,a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<nvl(psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=nvl(psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from cir_temp_bill_collection a where a.cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.agname_oth_lang,a.city_code)x
            order by comp_code,unit_code,zone_code;
            
        elsif pbreakon='2' then --region wise
            open p_accounts for
            select a.comp_code comp_code,a.unit_code unit_code,
            a.remarks region_name,a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<nvl(psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=nvl(psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from cir_temp_bill_collection a where a.cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.remarks,a.city_code
            order by comp_code,unit_code,region_name,city_name;
            
            open p_accounts1 for 
            select x.comp_code comp_code,x.unit_code unit_code,
            x.region_name region_name,sum(x.gross_copy) gross_copy,
            sum(x.less_copy) as less_copy,sum(x.Above_copy) as Above_copy
            from
            (select a.comp_code comp_code,a.unit_code unit_code,
            a.remarks region_name,a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<nvl(psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=nvl(psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from cir_temp_bill_collection a where a.cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.remarks,a.city_code)x
            order by comp_code,unit_code,region_name;
                    
        elsif pbreakon='3' then --state wise
            open p_accounts for
            select a.comp_code comp_code,a.unit_code unit_code,
            a.state_code state_name,
            a.city_code city_name,
            a.taluka_code taluka_name,sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<nvl(psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=nvl(psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from cir_temp_bill_collection a where a.cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.state_code,a.city_code
            order by comp_code,unit_code,state_name,city_name;
            
            open p_accounts1 for 
            select x.comp_code comp_code,x.unit_code unit_code,
            x.state_name state_name,sum(x.gross_copy) gross_copy,
            sum(x.less_copy) as less_copy,sum(x.Above_copy) as Above_copy
            from
            (select a.comp_code comp_code,a.unit_code unit_code,
            a.state_code state_name,
            a.city_code city_name,
            a.taluka_code taluka_name,sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<nvl(psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=nvl(psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from cir_temp_bill_collection a where a.cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.state_code,a.city_code)x
            order by comp_code,unit_code,state_name;        
        elsif pbreakon='4' then --Branch wise
            
            open p_accounts for
            select a.comp_code comp_code,a.unit_code unit_code,
            a.billno branch_name,
            a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<nvl(psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=nvl(psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from cir_temp_bill_collection a where a.cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.billno,a.city_code
            order by comp_code,unit_code,branch_name,city_name;
            
            open p_accounts1 for 
            select x.comp_code comp_code,x.unit_code unit_code,
            x.branch_name branch_name,sum(x.gross_copy) gross_copy,
            sum(x.less_copy) as less_copy,sum(x.Above_copy) as Above_copy
            from
            (select a.comp_code comp_code,a.unit_code unit_code,
            a.billno branch_name,
            a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<nvl(psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=nvl(psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from cir_temp_bill_collection a where a.cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.billno,a.city_code)x
            order by comp_code,unit_code,branch_name;        
        elsif pbreakon='5' then --District wise
            open p_accounts for
            select a.comp_code comp_code,a.unit_code unit_code,
            a.dist_code dist_name, 
            a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<nvl(psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=nvl(psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from cir_temp_bill_collection a where a.cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.dist_code,a.city_code
            order by comp_code,unit_code,dist_name,city_name;
            
            open p_accounts1 for 
            select x.comp_code comp_code,x.unit_code unit_code,
            x.dist_name dist_name,sum(x.gross_copy) gross_copy,
            sum(x.less_copy) as less_copy,sum(x.Above_copy) as Above_copy
            from
            (select a.comp_code comp_code,a.unit_code unit_code,
            a.dist_code dist_name, 
            a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<nvl(psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=nvl(psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from cir_temp_bill_collection a where a.cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.dist_code,a.city_code)x
            order by comp_code,unit_code,dist_name;        
        elsif pbreakon='6' then --Taluka wise
            open p_accounts for
            select a.comp_code comp_code,a.unit_code unit_code,
            a.taluka_code taluka_name,
            a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<nvl(psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=nvl(psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from cir_temp_bill_collection a where a.cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.taluka_code,a.city_code
            order by comp_code,unit_code,taluka_name,city_name;
            
            open p_accounts1 for 
            select x.comp_code comp_code,x.unit_code unit_code,
            x.taluka_name taluka_name,sum(x.gross_copy) gross_copy,
            sum(x.less_copy) as less_copy,sum(x.Above_copy) as Above_copy
            from
            (select a.comp_code comp_code,a.unit_code unit_code,
            a.taluka_code taluka_name,
            a.city_code city_name,
            sum(a.supply_copy) gross_copy,
            case when sum(a.supply_copy)<nvl(psup_copy,250) then sum(a.supply_copy) else 0 end as less_copy,
            case when sum(a.supply_copy)>=nvl(psup_copy,250) then sum(a.supply_copy) else 0 end Above_copy     
            from cir_temp_bill_collection a where a.cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.taluka_code,a.city_code)x
            order by comp_code,unit_code,taluka_name;        
         end if;    
    end if;
    
    delete from cir_temp_bill_collection where cur_sessionid=userenv('sessionid');
  End cir_area_break_down;
END cir_rep_abc;
/


///////////////////////////////////////////////////////end//////////////////////////////////////////////////////////////////



/*******by laxman sir************/

alter table cir_dbksup add(ACCAGCD   VARCHAR2(8),
  ACCDPCD   VARCHAR2(8), SUP_BILL_PAY  VARCHAR2(1), SO_COPY   NUMBER(8),DAY_COPY NUMBER(5))
  
alter table cir_dbksup_dis add(ACCAGCD   VARCHAR2(8),
  ACCDPCD   VARCHAR2(8), SUP_BILL_PAY  VARCHAR2(1), SO_COPY   NUMBER(8),DAY_COPY NUMBER(5))
  
alter table cir_dbksup_resale add(ACCAGCD   VARCHAR2(8),
  ACCDPCD   VARCHAR2(8), SUP_BILL_PAY  VARCHAR2(1), SO_COPY   NUMBER(8),DAY_COPY NUMBER(5))

                                                                     
                                                                     
                                                                     
                                             
CREATE OR REPLACE procedure cir_rep_daybook_supply(
    pcompcode       in varchar2,
    punitcode       in varchar2,
    ppublcode       in varchar2,
    pmedtncode      in varchar2,
    pedtncode       in varchar2,
    pagtype         in varchar2,
    pagclass        in varchar2,
    pfromdate       in varchar2,
    ptilldate       in varchar2,
    pdateformat     in varchar2,
    puserid         in varchar2,
    preptype        in varchar2,--D for detail S for Summary
    preg_extra      in varchar2,--R for Regular,E for Extra
    pextra1         in varchar2,--for E for Edition wise R for Route Wise
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
As
    v_frdt  date;
    v_todt  date;
Begin

    v_frdt := to_date(pfromdate,''''||pdateformat||'''');
    v_todt := to_date(ptilldate,''''||pdateformat||'''');
   
    if pextra1='E' then--for edition wise
        if preptype='D' then --for detail
            if preg_extra='E' then
                open p_accounts for
                select x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,x.main_edtn,x.edtn,x.edtn_name,x.edition_nick,x.edtn_seq_no,
                x.agcd,x.dpcd,x.ag_name,x.ag_name_oth_lang,x.city_code,cir_get_city(x.comp_code,x.city_code) city_name,
                x.station_code,cir_get_drop_point_name(x.comp_code,x.unit_code,x.station_code,1) drop_point_name,
                x.lbl_printno,sum(x.paid_copy) paid_copy,sum(x.unpaid_copy) unpaid_copy,
                sum(x.pday_copy) pday_copy,sum(x.uday_copy) uday_copy,
                x.route_code,cir_get_name.cir_route(x.comp_code,x.unit_code,x.route_code,'1',null,null,null) route_name,
                x.subroute_code,cir_get_name.cir_subroute(x.comp_code,x.unit_code,x.route_code,x.subroute_code,'1',null,null,null) subrt_name,
                x.subsubroute_code,cir_get_name.cir_subsubroute(x.comp_code,x.unit_code,x.route_code,x.subroute_code,x.subsubroute_code,'1',null,null,null) subsubrt_name
                from
                (select d.comp_code,d.unit_code,(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=d.unit_code) unit_name,
                d.publ,p.publ_name,e.main_edtn,d.edtn,e.edtn_name,e.edition_nick,e.edtn_seq_no,
                d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,s.lbl_printno,
                case when nvl(t.bill_pay,'N')='Y' then d.sup_copy else 0 end paid_copy,
                case when nvl(t.bill_pay,'N')='N' then d.sup_copy else 0 end unpaid_copy,
                case when nvl(t.bill_pay,'N')='Y' then d.day_copy else 0 end pday_copy,
                case when nvl(t.bill_pay,'N')='N' then d.day_copy else 0 end uday_copy,
                d.route_code, d.subroute_code, d.subsubroute_code
                from cir_agmast m,cir_supply s ,cir_dbksup d,cir_publ_mast p,cir_edtn_mast e,cir_supply_type_mast t
                where m.comp_code=d.comp_code and m.comp_code=p.comp_code and m.comp_code=s.comp_code and m.comp_code=e.comp_code and
                m.comp_code=t.comp_code and m.comp_code=pcompcode and m.unit=d.unit_code and m.unit=s.unit and d.unit_code=punitcode and
                d.publ = p.publ and p.publ = e.publ and d.publ = ppublcode and d.edtn=e.edtn and d.edtn=s.edtn and d.edtn=nvl(pedtncode,d.edtn) and e.main_edtn=nvl(pmedtncode,e.main_edtn) and
                d.sup_type_code=t.sup_ty_code and d.sup_type_code=s.supply_type_code and m.agcd=d.agcd and m.agcd=s.agcd and m.dpcd=d.dpcd and m.dpcd=s.dpcd and
                d.supdate between v_frdt and v_todt and (m.ag_type=pagtype or pagtype is null)
                and (m.ag_class=pagclass or pagclass is null) and nvl(d.day_copy,0)>0) x
                group by x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,x.main_edtn,x.edtn,x.edtn_name,x.edition_nick,x.edtn_seq_no,
                x.agcd,x.dpcd,x.ag_name,x.ag_name_oth_lang,x.city_code,x.station_code,x.lbl_printno,x.route_code,x.subroute_code,x.subsubroute_code
                having sum(x.pday_copy)>0
                order by x.comp_code,x.unit_code,x.unit_name,x.publ_name,x.publ,x.edtn_seq_no,x.edtn_name,x.lbl_printno,x.ag_name,x.agcd,x.dpcd;
            else
                open p_accounts for
                select x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,x.main_edtn,x.edtn,x.edtn_name,x.edition_nick,x.edtn_seq_no,
                x.agcd,x.dpcd,x.ag_name,x.ag_name_oth_lang,x.city_code,cir_get_city(x.comp_code,x.city_code) city_name,
                x.station_code,cir_get_drop_point_name(x.comp_code,x.unit_code,x.station_code,1) drop_point_name,
                x.lbl_printno,sum(x.paid_copy) paid_copy,sum(x.unpaid_copy) unpaid_copy,
                sum(x.pday_copy) pday_copy,sum(x.uday_copy) uday_copy,
                x.route_code,cir_get_name.cir_route(x.comp_code,x.unit_code,x.route_code,'1',null,null,null) route_name,
                x.subroute_code,cir_get_name.cir_subroute(x.comp_code,x.unit_code,x.route_code,x.subroute_code,'1',null,null,null) subrt_name,
                x.subsubroute_code,cir_get_name.cir_subsubroute(x.comp_code,x.unit_code,x.route_code,x.subroute_code,x.subsubroute_code,'1',null,null,null) subsubrt_name
                from
                (select d.comp_code,d.unit_code,(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=d.unit_code) unit_name,
                d.publ,p.publ_name,e.main_edtn,d.edtn,e.edtn_name,e.edition_nick,e.edtn_seq_no,
                d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,s.lbl_printno,
                case when nvl(t.bill_pay,'N')='Y' then d.sup_copy else 0 end paid_copy,
                case when nvl(t.bill_pay,'N')='N' then d.sup_copy else 0 end unpaid_copy,
                case when nvl(t.bill_pay,'N')='Y' then d.day_copy else 0 end pday_copy,
                case when nvl(t.bill_pay,'N')='N' then d.day_copy else 0 end uday_copy,
                d.route_code, d.subroute_code, d.subsubroute_code
                from cir_agmast m,cir_supply s ,cir_dbksup d,cir_publ_mast p,cir_edtn_mast e,cir_supply_type_mast t
                where m.comp_code=d.comp_code and m.comp_code=p.comp_code and m.comp_code=s.comp_code and m.comp_code=e.comp_code and
                m.comp_code=t.comp_code and m.comp_code=pcompcode and m.unit=d.unit_code and m.unit=s.unit and d.unit_code=punitcode and
                d.publ = p.publ and p.publ = e.publ and d.publ = ppublcode and d.edtn=e.edtn and d.edtn=s.edtn and d.edtn=nvl(pedtncode,d.edtn) and e.main_edtn=nvl(pmedtncode,e.main_edtn) and
                d.sup_type_code=t.sup_ty_code and d.sup_type_code=s.supply_type_code and m.agcd=d.agcd and m.agcd=s.agcd and m.dpcd=d.dpcd and m.dpcd=s.dpcd and
                d.supdate between v_frdt and v_todt and (m.ag_type=pagtype or pagtype is null)
                and (m.ag_class=pagclass or pagclass is null) ) x
                group by x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,x.main_edtn,x.edtn,x.edtn_name,x.edition_nick,x.edtn_seq_no,
                x.agcd,x.dpcd,x.ag_name,x.ag_name_oth_lang,x.city_code,x.station_code,x.lbl_printno,x.route_code,x.subroute_code,x.subsubroute_code
                order by x.comp_code,x.unit_code,x.unit_name,x.publ_name,x.publ,x.edtn_seq_no,x.edtn_name,x.lbl_printno,x.ag_name,x.agcd,x.dpcd;
            end if;       
        else--for summary
            if preg_extra='E' then
                open p_accounts for
                select x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,x.main_edtn,x.edtn,x.edtn_name,x.edition_nick,x.edtn_seq_no,
                sum(x.paid_copy) paid_copy,sum(x.unpaid_copy) unpaid_copy,
                sum(x.pday_copy) pday_copy,sum(x.uday_copy) uday_copy
                from
                (select d.comp_code,d.unit_code,(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=d.unit_code) unit_name,
                d.publ,p.publ_name,e.main_edtn,d.edtn,e.edtn_name,e.edition_nick,e.edtn_seq_no,
                d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,s.lbl_printno,
                case when nvl(t.bill_pay,'N')='Y' then d.sup_copy else 0 end paid_copy,
                case when nvl(t.bill_pay,'N')='N' then d.sup_copy else 0 end unpaid_copy,
                case when nvl(t.bill_pay,'N')='Y' then d.day_copy else 0 end pday_copy,
                case when nvl(t.bill_pay,'N')='N' then d.day_copy else 0 end uday_copy,       
                d.route_code,  d.subroute_code,d.subsubroute_code
                from cir_agmast m,cir_supply s ,cir_dbksup d,cir_publ_mast p,cir_edtn_mast e,cir_supply_type_mast t
                where m.comp_code=d.comp_code and m.comp_code=p.comp_code and m.comp_code=s.comp_code and m.comp_code=e.comp_code and
                m.comp_code=t.comp_code and m.comp_code=pcompcode and m.unit=d.unit_code and m.unit=s.unit and d.unit_code=punitcode and
                d.publ = p.publ and p.publ = e.publ and d.publ = ppublcode and d.edtn=e.edtn and d.edtn=s.edtn and d.edtn=nvl(pedtncode,d.edtn) and e.main_edtn=nvl(pmedtncode,e.main_edtn) and
                d.sup_type_code=t.sup_ty_code and d.sup_type_code=s.supply_type_code and m.agcd=d.agcd and m.agcd=s.agcd and m.dpcd=d.dpcd and m.dpcd=s.dpcd and
                d.supdate between v_frdt and v_todt and (m.ag_type=pagtype or pagtype is null)
                and (m.ag_class=pagclass or pagclass is null) and nvl(d.day_copy,0)>0) x
                group by x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,x.main_edtn,x.edtn,x.edtn_name,x.edition_nick,x.edtn_seq_no
                having sum(x.pday_copy)>0
                order by x.comp_code,x.unit_code,x.unit_name,x.publ_name,x.publ,x.edtn_seq_no,x.edtn_name;
            else
                open p_accounts for
                select x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,x.main_edtn,x.edtn,x.edtn_name,x.edition_nick,x.edtn_seq_no,
                sum(x.paid_copy) paid_copy,sum(x.unpaid_copy) unpaid_copy,
                sum(x.pday_copy) pday_copy,sum(x.uday_copy) uday_copy
                from
                (select d.comp_code,d.unit_code,(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=d.unit_code) unit_name,
                d.publ,p.publ_name,e.main_edtn,d.edtn,e.edtn_name,e.edition_nick,e.edtn_seq_no,
                d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,s.lbl_printno,
                case when nvl(t.bill_pay,'N')='Y' then d.sup_copy else 0 end paid_copy,
                case when nvl(t.bill_pay,'N')='N' then d.sup_copy else 0 end unpaid_copy,
                case when nvl(t.bill_pay,'N')='Y' then d.day_copy else 0 end pday_copy,
                case when nvl(t.bill_pay,'N')='N' then d.day_copy else 0 end uday_copy,       
                d.route_code, d.subroute_code,d.subsubroute_code
                from cir_agmast m,cir_supply s ,cir_dbksup d,cir_publ_mast p,cir_edtn_mast e,cir_supply_type_mast t
                where m.comp_code=d.comp_code and m.comp_code=p.comp_code and m.comp_code=s.comp_code and m.comp_code=e.comp_code and
                m.comp_code=t.comp_code and m.comp_code=pcompcode and m.unit=d.unit_code and m.unit=s.unit and d.unit_code=punitcode and
                d.publ = p.publ and p.publ = e.publ and d.publ = ppublcode and d.edtn=e.edtn and d.edtn=s.edtn and d.edtn=nvl(pedtncode,d.edtn) and e.main_edtn=nvl(pmedtncode,e.main_edtn) and
                d.sup_type_code=t.sup_ty_code and d.sup_type_code=s.supply_type_code and m.agcd=d.agcd and m.agcd=s.agcd and m.dpcd=d.dpcd and m.dpcd=s.dpcd and
                d.supdate between v_frdt and v_todt and (m.ag_type=pagtype or pagtype is null)
                and (m.ag_class=pagclass or pagclass is null)) x
                group by x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,x.main_edtn,x.edtn,x.edtn_name,x.edition_nick,x.edtn_seq_no
                order by x.comp_code,x.unit_code,x.unit_name,x.publ_name,x.publ,x.edtn_seq_no,x.edtn_name;       
            end if;
        end if;
    else--for route wise
        if preptype='D' then --for detail
            if preg_extra='E' then
                open p_accounts for
                select x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,
                x.agcd,x.dpcd,x.ag_name,x.ag_name_oth_lang,x.city_code,cir_get_city(x.comp_code,x.city_code) city_name,
                x.station_code,cir_get_drop_point_name(x.comp_code,x.unit_code,x.station_code,1) drop_point_name,
                x.lbl_printno,sum(x.paid_copy) paid_copy,sum(x.unpaid_copy) unpaid_copy,
                sum(x.pday_copy) pday_copy,sum(x.uday_copy) uday_copy,
                x.route_code,cir_get_name.cir_route(x.comp_code,x.unit_code,x.route_code,'1',null,null,null) route_name
                from
                (select d.comp_code,d.unit_code,(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=d.unit_code) unit_name,
                d.publ,p.publ_name,
                d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,s.lbl_printno,
                case when nvl(t.bill_pay,'N')='Y' then d.sup_copy else 0 end paid_copy,
                case when nvl(t.bill_pay,'N')='N' then d.sup_copy else 0 end unpaid_copy,
                case when nvl(t.bill_pay,'N')='Y' then d.day_copy else 0 end pday_copy,
                case when nvl(t.bill_pay,'N')='N' then d.day_copy else 0 end uday_copy,
                d.route_code, d.subroute_code, d.subsubroute_code
                from cir_agmast m,cir_supply s ,cir_dbksup d,cir_publ_mast p,cir_edtn_mast e,cir_supply_type_mast t
                where m.comp_code=d.comp_code and m.comp_code=p.comp_code and m.comp_code=s.comp_code and m.comp_code=e.comp_code and
                m.comp_code=t.comp_code and m.comp_code=pcompcode and m.unit=d.unit_code and m.unit=s.unit and d.unit_code=punitcode and
                d.publ = p.publ and p.publ = e.publ and d.publ = ppublcode and d.edtn=e.edtn and d.edtn=s.edtn and d.edtn=nvl(pedtncode,d.edtn) and e.main_edtn=nvl(pmedtncode,e.main_edtn) and
                d.sup_type_code=t.sup_ty_code and d.sup_type_code=s.supply_type_code and m.agcd=d.agcd and m.agcd=s.agcd and m.dpcd=d.dpcd and m.dpcd=s.dpcd and
                d.supdate between v_frdt and v_todt and (m.ag_type=pagtype or pagtype is null)
                and (m.ag_class=pagclass or pagclass is null) and nvl(d.day_copy,0)>0) x
                group by x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,
                x.agcd,x.dpcd,x.ag_name,x.ag_name_oth_lang,x.city_code,x.station_code,x.lbl_printno,x.route_code
                having sum(x.pday_copy)>0
                order by x.comp_code,x.unit_code,x.unit_name,x.publ_name,x.publ,route_name,x.lbl_printno,x.ag_name,x.agcd,x.dpcd;
            else
                open p_accounts for
                select x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,
                x.agcd,x.dpcd,x.ag_name,x.ag_name_oth_lang,x.city_code,cir_get_city(x.comp_code,x.city_code) city_name,
                x.station_code,cir_get_drop_point_name(x.comp_code,x.unit_code,x.station_code,1) drop_point_name,
                x.lbl_printno,sum(x.paid_copy) paid_copy,sum(x.unpaid_copy) unpaid_copy,
                sum(x.pday_copy) pday_copy,sum(x.uday_copy) uday_copy,
                x.route_code,cir_get_name.cir_route(x.comp_code,x.unit_code,x.route_code,'1',null,null,null) route_name
                from
                (select d.comp_code,d.unit_code,(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=d.unit_code) unit_name,
                d.publ,p.publ_name,e.main_edtn,d.edtn,e.edtn_name,e.edition_nick,e.edtn_seq_no,
                d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,s.lbl_printno,
                case when nvl(t.bill_pay,'N')='Y' then d.sup_copy else 0 end paid_copy,
                case when nvl(t.bill_pay,'N')='N' then d.sup_copy else 0 end unpaid_copy,
                case when nvl(t.bill_pay,'N')='Y' then d.day_copy else 0 end pday_copy,
                case when nvl(t.bill_pay,'N')='N' then d.day_copy else 0 end uday_copy,
                d.route_code, d.subroute_code, d.subsubroute_code
                from cir_agmast m,cir_supply s ,cir_dbksup d,cir_publ_mast p,cir_edtn_mast e,cir_supply_type_mast t
                where m.comp_code=d.comp_code and m.comp_code=p.comp_code and m.comp_code=s.comp_code and m.comp_code=e.comp_code and
                m.comp_code=t.comp_code and m.comp_code=pcompcode and m.unit=d.unit_code and m.unit=s.unit and d.unit_code=punitcode and
                d.publ = p.publ and p.publ = e.publ and d.publ = ppublcode and d.edtn=e.edtn and d.edtn=s.edtn and d.edtn=nvl(pedtncode,d.edtn) and e.main_edtn=nvl(pmedtncode,e.main_edtn) and
                d.sup_type_code=t.sup_ty_code and d.sup_type_code=s.supply_type_code and m.agcd=d.agcd and m.agcd=s.agcd and m.dpcd=d.dpcd and m.dpcd=s.dpcd and
                d.supdate between v_frdt and v_todt and (m.ag_type=pagtype or pagtype is null)
                and (m.ag_class=pagclass or pagclass is null) ) x
                group by x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,
                x.agcd,x.dpcd,x.ag_name,x.ag_name_oth_lang,x.city_code,x.station_code,x.lbl_printno,x.route_code
                order by x.comp_code,x.unit_code,x.unit_name,x.publ_name,x.publ,route_name,x.lbl_printno,x.ag_name,x.agcd,x.dpcd;
            end if;       
        else--for summary
            if preg_extra='E' then
                open p_accounts for
                select x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,
                sum(x.paid_copy) paid_copy,sum(x.unpaid_copy) unpaid_copy,
                sum(x.pday_copy) pday_copy,sum(x.uday_copy) uday_copy,
                x.route_code,cir_get_name.cir_route(x.comp_code,x.unit_code,x.route_code,'1',null,null,null) route_name
                from
                (select d.comp_code,d.unit_code,(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=d.unit_code) unit_name,
                d.publ,p.publ_name,e.main_edtn,d.edtn,e.edtn_name,e.edition_nick,e.edtn_seq_no,
                d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,s.lbl_printno,
                case when nvl(t.bill_pay,'N')='Y' then d.sup_copy else 0 end paid_copy,
                case when nvl(t.bill_pay,'N')='N' then d.sup_copy else 0 end unpaid_copy,
                case when nvl(t.bill_pay,'N')='Y' then d.day_copy else 0 end pday_copy,
                case when nvl(t.bill_pay,'N')='N' then d.day_copy else 0 end uday_copy,       
                d.route_code,  d.subroute_code,d.subsubroute_code
                from cir_agmast m,cir_supply s ,cir_dbksup d,cir_publ_mast p,cir_edtn_mast e,cir_supply_type_mast t
                where m.comp_code=d.comp_code and m.comp_code=p.comp_code and m.comp_code=s.comp_code and m.comp_code=e.comp_code and
                m.comp_code=t.comp_code and m.comp_code=pcompcode and m.unit=d.unit_code and m.unit=s.unit and d.unit_code=punitcode and
                d.publ = p.publ and p.publ = e.publ and d.publ = ppublcode and d.edtn=e.edtn and d.edtn=s.edtn and d.edtn=nvl(pedtncode,d.edtn) and e.main_edtn=nvl(pmedtncode,e.main_edtn) and
                d.sup_type_code=t.sup_ty_code and d.sup_type_code=s.supply_type_code and m.agcd=d.agcd and m.agcd=s.agcd and m.dpcd=d.dpcd and m.dpcd=s.dpcd and
                d.supdate between v_frdt and v_todt and (m.ag_type=pagtype or pagtype is null)
                and (m.ag_class=pagclass or pagclass is null) and nvl(d.day_copy,0)>0) x
                group by x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,x.route_code
                having sum(x.pday_copy)>0
                order by x.comp_code,x.unit_code,x.unit_name,x.publ_name,x.publ,route_name;
            else
                open p_accounts for
                select x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,
                sum(x.paid_copy) paid_copy,sum(x.unpaid_copy) unpaid_copy,
                sum(x.pday_copy) pday_copy,sum(x.uday_copy) uday_copy,
                x.route_code,cir_get_name.cir_route(x.comp_code,x.unit_code,x.route_code,'1',null,null,null) route_name
                from
                (select d.comp_code,d.unit_code,(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=d.unit_code) unit_name,
                d.publ,p.publ_name,e.main_edtn,d.edtn,e.edtn_name,e.edition_nick,e.edtn_seq_no,
                d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code,s.lbl_printno,
                case when nvl(t.bill_pay,'N')='Y' then d.sup_copy else 0 end paid_copy,
                case when nvl(t.bill_pay,'N')='N' then d.sup_copy else 0 end unpaid_copy,
                case when nvl(t.bill_pay,'N')='Y' then d.day_copy else 0 end pday_copy,
                case when nvl(t.bill_pay,'N')='N' then d.day_copy else 0 end uday_copy,       
                d.route_code, d.subroute_code,d.subsubroute_code
                from cir_agmast m,cir_supply s ,cir_dbksup d,cir_publ_mast p,cir_edtn_mast e,cir_supply_type_mast t
                where m.comp_code=d.comp_code and m.comp_code=p.comp_code and m.comp_code=s.comp_code and m.comp_code=e.comp_code and
                m.comp_code=t.comp_code and m.comp_code=pcompcode and m.unit=d.unit_code and m.unit=s.unit and d.unit_code=punitcode and
                d.publ = p.publ and p.publ = e.publ and d.publ = ppublcode and d.edtn=e.edtn and d.edtn=s.edtn and d.edtn=nvl(pedtncode,d.edtn) and e.main_edtn=nvl(pmedtncode,e.main_edtn) and
                d.sup_type_code=t.sup_ty_code and d.sup_type_code=s.supply_type_code and m.agcd=d.agcd and m.agcd=s.agcd and m.dpcd=d.dpcd and m.dpcd=s.dpcd and
                d.supdate between v_frdt and v_todt and (m.ag_type=pagtype or pagtype is null)
                and (m.ag_class=pagclass or pagclass is null)) x
                group by x.comp_code,x.unit_code,x.unit_name,x.publ,x.publ_name,x.route_code
                order by x.comp_code,x.unit_code,x.unit_name,x.publ_name,x.publ,route_name;       
            end if;
        end if;       
    end if;
    open p_accounts1 for
    select sysdate as "CUR_DATE" from dual;
       
    open p_accounts2 for
    select sysdate as "CUR_DATE" from dual;

End cir_rep_daybook_supply;
/
/*******by laxman sir************/