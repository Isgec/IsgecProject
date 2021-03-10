//===========================add by deepika for Issue no. 7535, 6821, 7005////////////////////////////////////////
CREATE OR REPLACE procedure CIR_RECEIPT_DATA_MOVE(
    pcompcode       in varchar2,
    punitcode       in varchar2,
    pdoctype        in varchar2,
    precptdt        in varchar2,
    precptno        in varchar2,
    pdateformate    in varchar2,
    puserid         in varchar2,
    prectype        in varchar2,--it is for agency receipt or distraibution receipt
    pextra1         in varchar2,
    pextra2         in varchar2,
    pextra3         in varchar2,
    pextra4         in varchar2,
    pextra5         in varchar2,
    p_accounts      OUT Cur_Type_New1.cursor_type)
is
v_recno number(10);
v_dt    date;
begin
    v_dt:=to_date(precptdt,''''||pdateformate||'''');
    
    if upper(prectype)='D' then
        insert into cir_rcphdr_dis(comp_code,unit_code,doctype,agcd,dpcd,recptno,
            recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,
            remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,
              staxamt,status,ref_recptno,ref_recptdt,ref_amount,ref_doctype,cancel_user,cancel_date,
              cancel_remark,userid,creation_date,branch_code,prov_rec_no,prov_rec_dt,remark_oth,MANNUALRECPTNO)
          select comp_code,unit_code,doctype,agcd,dpcd,recptno,
          recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,
          remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,
          staxamt,status,ref_recptno,ref_recptdt,ref_amount,ref_doctype,cancel_user,cancel_date,
          cancel_remark,userid,creation_date,branch_code,prov_rec_no,prov_rec_dt,remark_oth,MANNUALRECPTNO
           from cir_rcphdr_dis_temp
            where comp_code=pcompcode and unit_code=punitcode and doctype=pdoctype and 
                    recptno=precptno and recptdt=v_dt;
      
          insert into cir_rcpdet_dis(comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                            payfor, achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, 
                            tds, stax, status, usrid, creation_date, branch_code)
          select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                            payfor, achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, 
                            tds, stax, status, usrid, creation_date, branch_code from cir_rcpdet_dis_temp
            where comp_code=pcompcode and unit_code=punitcode and doctyp=pdoctype and 
                    recptno=precptno and recptdt=v_dt;

        insert into cir_outmast_dis (comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                        achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, balance, 
                        tds, stax, status, cancel_userid, cancel_dt, cancel_remark, usrid, creation_date, bill_sec_amt, branch_code)
        select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                        achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, balance, 
                        tds, stax, status, cancel_userid, cancel_dt, cancel_remark, usrid, creation_date, bill_sec_amt, branch_code from cir_outmast_dis_temp
             where comp_code=pcompcode and unit_code=punitcode and doctyp=pdoctype and 
                    recptno=precptno and recptdt=v_dt;
        
        select count(*) into v_recno from cir_rcpt_document_dis_temp
        where comp_code=pcompcode and unit_code=punitcode and doctype=pdoctype and recptno=precptno and recptdt=v_dt;
        
        if v_recno>0 then
            insert into cir_rcpt_document_dis(comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt)
            select comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt from cir_rcpt_document_dis_temp
            where comp_code=pcompcode and unit_code=punitcode and doctype=pdoctype and recptno=precptno and recptdt=v_dt; 
        End if;
        
        select count(*) into v_recno from cir_rcp_unadj_temp_dis 
        where comp_code=pcompcode and unit_code=punitcode and doctyp=pdoctype and recptno=precptno;
        
        if v_recno>0 then
            insert into cir_rcp_unadj_dis(comp_code,unit_code,agcd,dpcd,doctyp,recptno,recptdt,publ,amount,created_by,created_date,updated_by,updated_date)
            select comp_code,unit_code,agcd,dpcd,doctyp,recptno,recptdt,publ,amount,created_by,created_date,updated_by,updated_date from cir_rcp_unadj_temp_dis
            where comp_code=pcompcode and unit_code=punitcode and doctyp=pdoctype and recptno=precptno;
        end if;            

    else
        insert into cir_rcphdr(comp_code,unit_code,doctype,agcd,dpcd,recptno,
            recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,
            remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,
              staxamt,status,ref_recptno,ref_recptdt,ref_amount,ref_doctype,cancel_user,cancel_date,
              cancel_remark,userid,creation_date,branch_code,prov_rec_no,prov_rec_dt,remark_oth,MANNUALRECPTNO)
          select comp_code,unit_code,doctype,agcd,dpcd,recptno,
          recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,
          remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,
          staxamt,status,ref_recptno,ref_recptdt,ref_amount,ref_doctype,cancel_user,cancel_date,
          cancel_remark,userid,creation_date,branch_code,prov_rec_no,prov_rec_dt,remark_oth,MANNUALRECPTNO from cir_rcphdr_temp
            where comp_code=pcompcode and unit_code=punitcode and doctype=pdoctype and 
                    recptno=precptno and recptdt=v_dt;
      
          insert into cir_rcpdet(comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                            payfor, achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, 
                            tds, stax, status, usrid, creation_date, branch_code)
          select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                            payfor, achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, 
                            tds, stax, status, usrid, creation_date, branch_code from cir_rcpdet_temp
            where comp_code=pcompcode and unit_code=punitcode and doctyp=pdoctype and 
                    recptno=precptno and recptdt=v_dt;

        insert into cir_outmast (comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                        achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, balance, 
                        tds, stax, status, cancel_userid, cancel_dt, cancel_remark, usrid, creation_date, bill_sec_amt, branch_code)
        select comp_code, unit_code, agcd, dpcd, doctyp, billno, billdt, recptno, recptdt, 
                        achd, publ, chno, chbnk, chdt, amount, reason, remark, voucherno, voucherdt, balance, 
                        tds, stax, status, cancel_userid, cancel_dt, cancel_remark, usrid, creation_date, bill_sec_amt, branch_code from cir_outmast_temp
             where comp_code=pcompcode and unit_code=punitcode and doctyp=pdoctype and 
                    recptno=precptno and recptdt=v_dt;
        
        select count(*) into v_recno from cir_rcpt_document_temp
            where comp_code=pcompcode and unit_code=punitcode and doctype=pdoctype and recptno=precptno and recptdt=v_dt;
        
        if v_recno>0 then                    
            insert into cir_rcpt_document(comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt)
            select comp_code, unit_code, doctype, recptno, recptdt, filename, created_by, created_dt from cir_rcpt_document_temp
            where comp_code=pcompcode and unit_code=punitcode and doctype=pdoctype and recptno=precptno and recptdt=v_dt;                    
        end if;
        
        select count(*) into v_recno from cir_rcp_unadj_temp 
        where comp_code=pcompcode and unit_code=punitcode and doctyp=pdoctype and recptno=precptno;
        
        if v_recno>0 then
            insert into cir_rcp_unadj(comp_code,unit_code,agcd,dpcd,doctyp,recptno,recptdt,publ,amount,created_by,created_date,updated_by,updated_date)
            select comp_code,unit_code,agcd,dpcd,doctyp,recptno,recptdt,publ,amount,created_by,created_date,updated_by,updated_date from cir_rcp_unadj_temp
            where comp_code=pcompcode and unit_code=punitcode and doctyp=pdoctype and recptno=precptno;
        end if;                    
    end if;                    
    
    if upper(prectype)='D' then            
        select count(*) into v_recno from cir_rcphdr_dis 
            where comp_code=pcompcode and unit_code=punitcode and doctype=pdoctype and 
                recptno=precptno;
    else
        select count(*) into v_recno from cir_rcphdr 
            where comp_code=pcompcode and unit_code=punitcode and doctype=pdoctype and 
                recptno=precptno;
    end if;

    if nvl(v_recno,0)>0 then
        if upper(prectype)='D' then            
            delete from cir_rcphdr_dis_temp 
                where comp_code=pcompcode and unit_code=punitcode and doctype=pdoctype and 
                    recptno=precptno;
        else
            delete from cir_rcphdr_temp
                where comp_code=pcompcode and unit_code=punitcode and doctype=pdoctype and 
                    recptno=precptno;
        end if;
        commit;
        open p_accounts for
        select v_recno recno from dual;
     else
        open p_accounts for
        select 0 recno from dual;
     end if;

end CIR_RECEIPT_DATA_MOVE;
/


//////////////////////////////////////


CREATE OR REPLACE procedure cir_chk_dupl_rcptchno (
    pcompcode   in varchar2,
    punitcode   in varchar2,
    pagcd        in varchar2,
    pdpcd        in varchar2,
    pdoctyp      in varchar2,
    pachd        in varchar2,
    pbank        in varchar2,
    pchno        in varchar2,
    extra1      in varchar2,
    extra2      in varchar2,
    p_accounts      OUT Cur_Type_New1.cursor_type)
    
   as
     cnt int;
    begin
    
   
   select count(*) into cnt from cir_rcphdr    
   where comp_code=pcompcode and unit_code=punitcode and 
       agcd=pagcd and dpcd=pdpcd and doctype=pdoctyp and achd=pachd
        and chbank=pbank and chno=pchno ;
        if(cnt>0) then
        open  p_accounts for
        select 'DUPLICATE RECORD' from dual;
   
        ELSE  
        open  p_accounts for
          select 'True' from dual;
        END if;
        
        END;
/


////////////////////////////////////


CREATE OR REPLACE procedure cir_update_flag_provreceipt (
    pcompcode   in varchar2,
    punitcode   in varchar2,
    precptno    in varchar2,
    precptdt    in varchar2,
    pdoctyp     in varchar2,
    pflag       in varchar2,
    pextra1     in varchar2,
    pextra2     in varchar2)
    
    
   as
     
    begin
    
   
        UPDATE CIR_RCPHDR_PROV set  FLAG=pflag 
        where comp_code=pcompcode and unit_code=punitcode and 
        recptno=precptno and recptdt=precptdt and doctype=pdoctyp; 
        
        END;
/


//////////////////////////////for bill tag


CREATE OR REPLACE procedure cir_get_prorecipt_detail (
   pcompcode   in varchar2,
   punitcode   in varchar2,
   prorecno    in varchar2,
   prorecdate  in varchar2,
   pdroctyp    in varchar2,
   pdateformat in varchar2,
   pextra1     in varchar2,
   pextra2     in varchar2,
   pextra3     in varchar2,
   pextra4     in varchar2,
   pextra5     in varchar2, 
   p_accounts      OUT Cur_Type_New1.cursor_type)
    
   as
     
    begin
    
    open p_accounts for
        select * from CIR_OUTMAST_PROV
        where comp_code=pcompcode and unit_code=punitcode and 
        recptno=prorecno and recptdt=prorecdate and doctyp=pdroctyp; 
   
        
        
        END;
/

//////////////////////////////////////end///////////////////////////////////////////////////////////////////////////

****************************** rikkee Garg Bill Register 12/6/12************************

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
    
         v_route  varchar(20);
         v_exec  varchar(20);
        vfrdt date;
        vtodt date;
        v_statecode   varchar2(20);
        v_distcode    varchar2(20);
        v_citycode    varchar2(20);
        v_taluka      varchar2(20); 
        v_query       varchar2(8000);       
    Begin
        --delete from test1;insert into test1(vstring,vstring2) values('cir bill register ','pcomp_code '||pcomp_code||','||punit_code||','||ppubl||','||repty||','||pbill_freq||','||pfrom_billdt||','||ptill_billdt||','||pbillagcd||','||pbilldpcd||','||pdateformat||','||pextra1||','||pextra2);commit;
        if repty='1' then--State
            v_statecode:=pextra1;
        elsif repty='2' then    --District
            v_distcode:=pextra1;
        elsif repty='3' then    --Taluka
            v_taluka:=pextra1;
            
            elsif repty='3' then    --route
            v_route:=pextra1;
            
            elsif repty='3' then    --exec
            v_exec:=pextra1;
            
        else--City
            v_citycode:=pextra1;
        end if;        
        vfrdt:=to_date(pfrom_billdt,''''||pdateformat||'''');
        vtodt:=to_date(ptill_billdt,''''||pdateformat||'''');

        if nvl(repty,'N')='1' then--for state
           
          v_query:='  select b.comp_code comp_code, b.unit_code unit_code, b.billno billno, b.billdt billdt, b.agcd agcd, b.dpcd dpcd, 
            min(b.publ) publ, sum(b.bill_copy) bill_copy, sum(b.gross_amount) gross_amount, sum(b.sur_amt) sur_amount, sum(b.comm_amt) comm_amount, 
            sum(b.bill_amount) bill_amount,max(b.bill_flag) bill_flag,null as  bill_remark, max(b.userid) userid, max(b.creation_date) creation_date, 
            b.branch_code branch_code,m.ag_name agency_name,cir_get_city(b.comp_code,m.city_code) as "CITY_NAME",
            cir_get_state(b.comp_code,m.country_code,m.state_code) as "STATE_NAME"
            from cir_bill_det b,cir_agmast m
            where b.comp_code = '''||pcomp_code||''' and m.comp_code=b.comp_code and b.unit_code = nvl('''||punit_code||''',b.unit_code) and 
            m.unit=b.unit_code and b.agcd = nvl('''||pbillagcd||''',b.agcd) and m.agcd=b.agcd and b.dpcd = nvl('''||pbilldpcd||''',b.dpcd) and  
            m.dpcd=b.dpcd and b.billdt >= '''||vfrdt||''' and billdt <='''||vtodt||''' and b.bill_flag = nvl('''||pbill_freq||''',b.bill_flag) and 
            b.publ = nvl('''||ppubl||''',b.publ) and (m.state_code='''||v_statecode||''' or '''||v_statecode||''' is null) and (m.dist_code='''||v_distcode||''' or '''||v_distcode||''' is null) and 
            (m.tehsil_taluka='''||v_taluka||''' or '''||v_taluka||''' is null) and (m.city_code='''||v_citycode||''' or '''||v_citycode||''' is null)
            group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code
            order by comp_code, state_name,'||pextra2||'';--billdt,billno,agency_name;
            delete from searchtbl ;
            insert into searchtbl values(v_query);commit;
           open p_accounts for v_query;  
        elsif nvl(repty,'N')='2' then --for district
           
          v_query:='  select b.comp_code comp_code, b.unit_code unit_code, b.billno billno, b.billdt billdt, b.agcd agcd, b.dpcd dpcd, 
            min(b.publ) publ, sum(b.bill_copy) bill_copy, sum(b.gross_amount) gross_amount, sum(b.sur_amt) sur_amount, sum(b.comm_amt) comm_amount, 
            sum(b.bill_amount) bill_amount,max(b.bill_flag) bill_flag,null as  bill_remark, max(b.userid) userid, max(b.creation_date) creation_date, 
            b.branch_code branch_code,m.ag_name agency_name,cir_get_city(b.comp_code,m.city_code) as "CITY_NAME",
            cir_get_state(b.comp_code,m.country_code,m.state_code) as "STATE_NAME",
            cir_get_dist(b.comp_code,m.state_code,m.dist_code) AS "DIST_NAME" 
            from cir_bill_det b,cir_agmast m
            where b.comp_code = '''||pcomp_code||''' and m.comp_code=b.comp_code and b.unit_code = nvl('''||punit_code||''',b.unit_code) and 
            m.unit=b.unit_code and b.agcd = nvl('''||pbillagcd||''',b.agcd) and m.agcd=b.agcd and b.dpcd = nvl('''||pbilldpcd||''',b.dpcd) and  
            m.dpcd=b.dpcd and b.billdt >= '''||vfrdt||''' and billdt <='''||vtodt||''' and b.bill_flag = nvl('''||pbill_freq||''',b.bill_flag) and 
            b.publ = nvl('''||ppubl||''',b.publ) and (m.state_code='''||v_statecode||''' or '''||v_statecode||''' is null) and (m.dist_code='''||v_distcode||''' or '''||v_distcode||''' is null) and 
            (m.tehsil_taluka='''||v_taluka||''' or '''||v_taluka||''' is null) and (m.city_code='''||v_citycode||''' or '''||v_citycode||''' is null)
            group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code,m.dist_code
            order by comp_code, state_name,dist_name,'||pextra2||'';--billdt,billno,agency_name;
            delete from searchtbl ;
            insert into searchtbl values(v_query);commit;
              open p_accounts for v_query;        
        elsif nvl(repty,'N')='3' then---for taluka
           
            v_query:=' select b.comp_code comp_code, b.unit_code unit_code, b.billno billno, b.billdt billdt, b.agcd agcd, b.dpcd dpcd, 
            min(b.publ) publ, sum(b.bill_copy) bill_copy, sum(b.gross_amount) gross_amount, sum(b.sur_amt) sur_amount, sum(b.comm_amt) comm_amount, 
            sum(b.bill_amount) bill_amount,max(b.bill_flag) bill_flag,null as  bill_remark, max(b.userid) userid, max(b.creation_date) creation_date, 
            b.branch_code branch_code,m.ag_name agency_name,cir_get_city(b.comp_code,m.city_code) as "CITY_NAME",
            cir_get_state(b.comp_code,m.country_code,m.state_code) as "STATE_NAME",
            cir_get_taluka(b.comp_code,m.tehsil_taluka) as "TALUKA_NAME"
            from cir_bill_det b,cir_agmast m
            where b.comp_code = '''||pcomp_code||''' and m.comp_code=b.comp_code and b.unit_code = nvl('''||punit_code||''',b.unit_code) and 
            m.unit=b.unit_code and b.agcd = nvl('''||pbillagcd||''',b.agcd) and m.agcd=b.agcd and b.dpcd = nvl('''||pbilldpcd||''',b.dpcd) and  
            m.dpcd=b.dpcd and b.billdt >= '''||vfrdt||''' and billdt <='''||vtodt||''' and b.bill_flag = nvl('''||pbill_freq||''',b.bill_flag) and 
            b.publ = nvl('''||ppubl||''',b.publ) and (m.state_code='''||v_statecode||''' or '''||v_statecode||''' is null) and (m.dist_code='''||v_distcode||''' or '''||v_distcode||''' is null) and 
            (m.tehsil_taluka='''||v_taluka||''' or '''||v_taluka||''' is null) and (m.city_code='''||v_citycode||''' or '''||v_citycode||''' is null)
            group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code,m.tehsil_taluka
            order by comp_code, state_name,taluka_name,'||pextra2||'';--,billdt,billno,agency_name;
            delete from searchtbl ;
            insert into searchtbl values(v_query);commit;
            open p_accounts for v_query;         
        
        elsif nvl(repty,'N')='4' then --for route
           
          v_query:='  select b.comp_code comp_code, b.unit_code unit_code, b.billno billno, b.billdt billdt, b.agcd agcd, b.dpcd dpcd, 
            min(b.publ) publ, sum(b.bill_copy) bill_copy, sum(b.gross_amount) gross_amount, sum(b.sur_amt) sur_amount, sum(b.comm_amt) comm_amount, 
            sum(b.bill_amount) bill_amount,max(b.bill_flag) bill_flag,null as  bill_remark, max(b.userid) userid, max(b.creation_date) creation_date, 
            b.branch_code branch_code,m.ag_name agency_name,cir_get_city(b.comp_code,m.city_code) as "CITY_NAME",
            cir_get_state(b.comp_code,m.country_code,m.state_code) as "STATE_NAME",
            p.route_code,cir_get_route_name(b.comp_code, b.unit_code, p.route_code) as "ROUTE_NAME"
            from cir_bill_det b,cir_agmast m,cir_dbksup p
            where b.comp_code = '''||pcomp_code||''' 
            and m.comp_code=p.comp_code and m.agcd=p.agcd and m.dpcd=p.dpcd and b.comp_code=p.comp_code and b.agcd=p.agcd and b.dpcd=p.dpcd
            and m.comp_code=b.comp_code and b.unit_code = nvl('''||punit_code||''',b.unit_code) and 
            m.unit=b.unit_code and b.agcd = nvl('''||pbillagcd||''',b.agcd) and m.agcd=b.agcd and b.dpcd = nvl('''||pbilldpcd||''',b.dpcd) and  
            m.dpcd=b.dpcd and b.billdt >= '''||vfrdt||''' and billdt <='''||vtodt||''' and b.bill_flag = nvl('''||pbill_freq||''',b.bill_flag) and 
            b.publ = nvl('''||ppubl||''',b.publ) and (m.state_code='''||v_statecode||''' or '''||v_statecode||''' is null) and (m.dist_code='''||v_distcode||''' or '''||v_distcode||''' is null) and 
            (p.route_code='''||v_route||''' or '''||v_route||''' is null) and (m.city_code='''||v_citycode||''' or '''||v_citycode||''' is null)
            group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code,p.route_code
            order by comp_code, state_name,ROUTE_NAME,'||pextra2||'';--billdt,billno,agency_name;
            delete from searchtbl ;
            insert into searchtbl values(v_query);commit;
              open p_accounts for v_query; 
        elsif nvl(repty,'N')='5' then --for executive
           
          v_query:='  select b.comp_code comp_code, b.unit_code unit_code, b.billno billno, b.billdt billdt, b.agcd agcd, b.dpcd dpcd, 
            min(b.publ) publ, sum(b.bill_copy) bill_copy, sum(b.gross_amount) gross_amount, sum(b.sur_amt) sur_amount, sum(b.comm_amt) comm_amount, 
            sum(b.bill_amount) bill_amount,max(b.bill_flag) bill_flag,null as  bill_remark, max(b.userid) userid, max(b.creation_date) creation_date, 
            b.branch_code branch_code,m.ag_name agency_name,cir_get_city(b.comp_code,m.city_code) as "CITY_NAME",
            cir_get_state(b.comp_code,m.country_code,m.state_code) as "STATE_NAME",
            m.executive_code,cir_get_executive(b.comp_code, m.executive_code) as "EXEC_NAME"
            from cir_bill_det b,cir_agmast m
            where b.comp_code = '''||pcomp_code||''' and m.comp_code=b.comp_code and b.unit_code = nvl('''||punit_code||''',b.unit_code) and 
            m.unit=b.unit_code and b.agcd = nvl('''||pbillagcd||''',b.agcd) and m.agcd=b.agcd and b.dpcd = nvl('''||pbilldpcd||''',b.dpcd) and  
            m.dpcd=b.dpcd and b.billdt >= '''||vfrdt||''' and billdt <='''||vtodt||''' and b.bill_flag = nvl('''||pbill_freq||''',b.bill_flag) and 
            b.publ = nvl('''||ppubl||''',b.publ) and (m.state_code='''||v_statecode||''' or '''||v_statecode||''' is null) and (m.dist_code='''||v_distcode||''' or '''||v_distcode||''' is null) and 
            (m.executive_code='''||v_exec||''' or '''||v_exec||''' is null) and (m.city_code='''||v_citycode||''' or '''||v_citycode||''' is null)
            group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code,m.executive_code
            order by comp_code, state_name,EXEC_NAME,'||pextra2||'';--billdt,billno,agency_name;
            delete from searchtbl ;
            insert into searchtbl values(v_query);commit;
              open p_accounts for v_query;         
        else---for city
           
            v_query:='  select b.comp_code comp_code, b.unit_code unit_code, b.billno billno, b.billdt billdt, b.agcd agcd, b.dpcd dpcd, 
            min(b.publ) publ, sum(b.bill_copy) bill_copy, sum(b.gross_amount) gross_amount, sum(b.sur_amt) sur_amount, sum(b.comm_amt) comm_amount, 
            sum(b.bill_amount) bill_amount,max(b.bill_flag) bill_flag,null as  bill_remark, max(b.userid) userid, max(b.creation_date) creation_date, 
            b.branch_code branch_code,m.ag_name agency_name,cir_get_city(b.comp_code,m.city_code) as "CITY_NAME",
            cir_get_state(b.comp_code,m.country_code,m.state_code) as "STATE_NAME" 
            from cir_bill_det b,cir_agmast m
            where b.comp_code = '''||pcomp_code||''' and m.comp_code=b.comp_code and b.unit_code = nvl('''||punit_code||''',b.unit_code) and 
            m.unit=b.unit_code and b.agcd = nvl('''||pbillagcd||''',b.agcd) and m.agcd=b.agcd and b.dpcd = nvl('''||pbilldpcd||''',b.dpcd) and  
            m.dpcd=b.dpcd and b.billdt >= '''||vfrdt||''' and billdt <='''||vtodt||''' and b.bill_flag = nvl('''||pbill_freq||''',b.bill_flag) and 
            b.publ = nvl('''||ppubl||''',b.publ) and (m.state_code='''||v_statecode||''' or '''||v_statecode||''' is null) and (m.dist_code='''||v_distcode||''' or '''||v_distcode||''' is null) and 
            (m.tehsil_taluka='''||v_taluka||''' or '''||v_taluka||''' is null) and (m.city_code='''||v_citycode||''' or '''||v_citycode||''' is null)
            group by b.comp_code, b.unit_code, b.billno ,b.billdt,b.agcd, b.dpcd,m.ag_name,b.branch_code,m.city_code,m.country_code,m.state_code
            order by comp_code, state_name,"CITY_NAME",'||pextra2||'';--,billdt,billno,agency_name;
            
            delete from searchtbl ;
            insert into searchtbl values(v_query);commit;
            open p_accounts for v_query;         
        end if;
        
     End cir_bill_register_p;

***************************************** end of Bill register**********************************

************************** rikkee garg tax master 18/6/12************************

create procedure cir_bostwana_tax_mast
(

pcomp_code      in varchar2,
ptaxtypeid      in varchar2,
ptaxtid         in varchar2,
pvaliddate      in date,
ptaxtcalctype   in varchar2,
ptaxtrate       in varchar2,
ptaxstatus      in varchar2,
pquery_type     in varchar2,
pextra1         in varchar2,
pextra2         in varchar2,
pextra3         in varchar2,
pextra4         in varchar2,
puserid         in varchar2

)
As
Begin

if(pquery_type = 'I')

then
insert into cir_tax_mast(COMP_CODE,TAX_TYPE_ID,TAX_ID,VALID_FROM,TAX_CALC_TYPE,TAX_RATE,TAX_STATUS,CREATED_BY,CREATED_DT)
values(pcomp_code,ptaxtypeid,ptaxtid,pvaliddate,ptaxtcalctype,ptaxtrate,ptaxstatus,puserid,sysdate);


elsif(pquery_type = 'U')

then
update cir_tax_mast set TAX_TYPE_ID =ptaxtypeid,VALID_FROM = pvaliddate,TAX_CALC_TYPE = ptaxtcalctype,TAX_RATE = ptaxtrate ,TAX_STATUS = ptaxstatus,UPDATED_BY = puserid,UPDATED_DT=sysdate
where TAX_ID = ptaxtid;
end if;

end;



******************************** end of tax master**********************************


*******************************Rikkee Garg issue no.7794 ************************



create or replace procedure cir_rep_ag_block_un_reasonwise
(

    pcompcode               in varchar2,
    punitcode               in varchar2,
    pbranchcode             in varchar2,
    pblock_unblock_type     in varchar2, 
    pstatus                 in varchar2, --   U/B
    pblock_unblock_by       in varchar2,
    pagcd                   in varchar2,   
    pdpcd                   in varchar2,
    pb_ub_reason            in varchar2,
    pfrom_date              in varchar2,
    ptill_date              in varchar2,
    papproved               in varchar2,-- A/U
    puserid                 in varchar2,
    pdateformat             in varchar2,
    pextra1                 in varchar2,
    pextra2                 in varchar2,
    p_accounts              out Cur_Type_New1.cursor_type

)

 is
   vvar             varchar2(8000);
      tot_vvar         varchar2(8000);
	  vtot_publ        varchar2(8000);
	  v_cnt            int;
	  rec_susp_code	   varchar2(8000);
	  rec_susp_name	   varchar2(8000);
      pvar             varchar2(8000);
      pquery           varchar(8000);	
      v_frdt  date;
      v_todt  date;
    
      
 
  cursor  cur_reason  is 
    select suspend_type_code,suspend_desc from cir_suspend_type_mast s where s.COMP_CODE=pcompcode
    and pstatus = 'B';
    v1 cur_reason%rowtype;
   begin 
   -- delete from searchtbl;
     --   insert into searchtbl values('tytyty');commit;
     v_frdt :=to_date(pfrom_date,''''||pdateformat||'''');
       v_todt:=to_date(ptill_date,''''||pdateformat||'''');
     
      
            if (pstatus = 'B')
            then
             
            open cur_reason;
            loop
            fetch cur_reason into v1;
            exit when cur_reason%notfound;
              
                  
              v_cnt :=nvl(v_cnt,0)+1;
            if (vvar is null) then
            vvar      :='case when s.suspty='||''''||v1.suspend_type_code||''''||' then ''Y'' else ''N'' end "'||v1.suspend_desc||'"';			
            else
            				
            vvar      :=vvar||',case when s.suspty='||''''||v1.suspend_type_code||''''||' then ''Y'' else ''N'' end "'||v1.suspend_desc||'"';
            End if	;
            
            end loop;
            close cur_reason;
            
          
   
    
      
      
		 pquery:='select a.AGCD dealer_code,a.AG_NAME dealer_name,a.AGEING_TYPE,nvl(s.AGENCY_UNBLOCK_TYPE,''A'') as auto_manual,substr(to_char(TRN_DATE,''hh:mm:ss''),1,5) as time
		,'||vvar||'
		from CIR_SUSPEND_TRAN s, CIR_AGMAST a where s.COMP_CODE='''||pcompcode||'''
	and s.COMP_CODE=a.COMP_CODE and s.AGCD=a.AGCD and s.DPCD=a.dpcd
		and (Select l.block_reason from CIR_SUSPEND_TYPE_MAST l where l.COMp_CODE='''||pcompcode||''' and l.SUSPEND_TYPE_CODE=s.SUSPTY )=''Y''
		and (s.UNIT=nvl('''||punitcode||''',s.UNIT) or '''||punitcode||''' ='''')
		and (a.BRANCH_CODE=nvl('''||pbranchcode||''',a.BRANCH_CODE) or '''||pbranchcode||''' ='''')
		and (s.AGENCY_UNBLOCK_APPROVAL=nvl( '''||pblock_unblock_type||''' ,s.AGENCY_UNBLOCK_APPROVAL) or  '''||pblock_unblock_type||'''  ='''')
		and (s.USERID=nvl('''||pblock_unblock_by||''',s.USERID) or '''||pblock_unblock_by||'''='''')
		and (s.AGCD=nvl('''||pagcd||''',s.agcd) or '''||pagcd||'''='''') and (s.dpcd=nvl('''||pdpcd||''',s.dpcd) or '''||pdpcd||'''='''')
		and (s.SUSPTY=nvl('''||pb_ub_reason||''',s.suspty) or '''||pb_ub_reason||''' ='''')
		and (s.TRN_DATE between '''||v_frdt ||''' and '''||v_todt ||''')
		and (nvl(s.AGENCY_UNBLOCK_APPROVAL,''U'') ='''||papproved||''' or '''||papproved||''' ='''')
   
   
		group by a.AGCD,a.AG_NAME,a.AGEING_TYPE,s.AGENCY_UNBLOCK_TYPE,s.USERID,s.SUSPTY,s.TRN_DATE 
		order by s.TRN_DATE';
		delete from searchtbl;
        insert into searchtbl values(pquery);commit;
		open p_accounts  for pquery;
	
  
   	
	else
    
    open p_accounts  for
    select a.AGCD dealer_code,a.AG_NAME dealer_name,a.AGEING_TYPE,nvl(s.AGENCY_UNBLOCK_TYPE,'A') as auto_manual,
    substr(to_char(TRN_DATE,'hh:mm:ss'),1,5) as time,
		(Select l.ROLE from login l where l.COM_CODE=pcompcode and l."userid"=s.USERID ) as user_group
		,(Select l."username" from login l where l.COM_CODE=pcompcode and l."userid"=s.USERID ) as unblockby
		,(Select l.SUSPEND_DESC from CIR_SUSPEND_TYPE_MAST l where l.COMp_CODE=pcompcode and l.SUSPEND_TYPE_CODE=s.SUSPTY ) as ub_reason
		from CIR_SUSPEND_TRAN s, CIR_AGMAST a where s.COMP_CODE=pcompcode
		and s.COMP_CODE=a.COMP_CODE and s.AGCD=a.AGCD and s.DPCD=a.dpcd
		and (Select l.block_reason from CIR_SUSPEND_TYPE_MAST l where l.COMp_CODE=pcompcode and l.SUSPEND_TYPE_CODE=s.SUSPTY )!='Y'
		and (s.UNIT=nvl(punitcode,s.UNIT) or punitcode ='')
		and (a.BRANCH_CODE=nvl(pbranchcode,a.BRANCH_CODE) or pbranchcode ='')
		and (s.AGENCY_UNBLOCK_APPROVAL=nvl( pblock_unblock_type ,s.AGENCY_UNBLOCK_APPROVAL) or  pblock_unblock_type  ='')
		and (s.USERID=nvl(pblock_unblock_by,s.USERID) or pblock_unblock_by='')
		and (s.AGCD=nvl(pagcd,s.agcd) or pagcd='') and (s.dpcd=nvl(pdpcd,s.dpcd) or pdpcd='')
		and (s.SUSPTY=nvl(pb_ub_reason,s.suspty) or pb_ub_reason ='')
		and (s.TRN_DATE between v_frdt and v_todt)
		and (nvl(s.AGENCY_UNBLOCK_APPROVAL,'U') =papproved or papproved ='')
		group by a.AGCD,a.AG_NAME,a.AGEING_TYPE,s.AGENCY_UNBLOCK_TYPE,s.USERID,s.SUSPTY,s.TRN_DATE 
		order by s.TRN_DATE;
	end if;

        end ;
	
 **********************************end of issue no.7794***************************************************   
   
********************Rikkee Garg sended by Gaurav sir  for supply correction 27/6/12************


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
   pzone_code     in varchar2,--for zone
   pregion_code   in varchar2,--for region 
   pcomm_category in varchar2,--for commition category 
   pstate_code    in varchar2,--for state 
   pdist_code     in varchar2,--for district 
   ptaluka_code   in varchar2,--for taluka 
   pcity_code     in varchar2,--for city 
   proute_code    in varchar2,--for route 
   pbran_code     in varchar2,--for branch 
   pagency_type   in varchar2,--for agency type 
   pagency_class  in varchar2,--for agency class 
   pdateformat    in varchar2,
   pextra1        in varchar2,--1 for  edition route wise,2 for edition district wise
   pextra2        in varchar2,--user id
   pextra3        in varchar2,-- L for less than / M for More than
   pextra4        in varchar2, -- value
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
              a.agcd=c.agcd and a.dpcd=c.dpcd and a.agcd=nvl(pagcd_code,a.agcd) and a.dpcd=nvl(pdpcd_code,a.dpcd) and 
              c.sup_type_code=nvl(psup_type,c.sup_type_code)) as "TOTAL_SUPPLY",
         c.final_supply_flag as "FINAL_SUPPLY_FLAG"
      from cir_agmast_dis a,cir_supply_type_mast b,cir_dbksup_dis c,cir_publ_mast p,cir_edtn_mast e,cir_supply_dis s
      where a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=p.comp_code and a.comp_code=e.comp_code and a.comp_code=s.comp_code and a.comp_code=pcomp_code and
         a.unit=c.unit_code and a.unit=s.unit and a.unit=nvl(punit_code,a.unit) and b.sup_ty_code=c.sup_type_code and
         c.publ=p.publ and c.publ=e.publ and c.publ=s.publ and c.publ=nvl(ppubl_code,c.publ) and c.edtn=e.edtn and c.edtn=s.edtn and c.edtn = nvl(pedtn_code,c.edtn) and 
         c.supdate=v_sup_date and a.agcd=c.agcd and a.dpcd=c.dpcd and a.agcd=s.agcd and a.agcd=nvl(pagcd_code,a.agcd) and a.dpcd=s.dpcd and a.dpcd=nvl(pdpcd_code,a.dpcd) and 
         c.sup_type_code=s.supply_type_code and c.sup_type_code=nvl(psup_type,c.sup_type_code) and
         (c.agency_ty_code = pagency_type or pagency_type is null) and
         (c.comm_code = pcomm_category or pcomm_category is null) and
         (c.route_code = proute_code or proute_code is null) and
         (a.state_code = pstate_code or pstate_code is null) and
         (a.dist_code = pdist_code or pdist_code is null) and
         (a.tehsil_taluka = ptaluka_code or ptaluka_code is null) and
        -- (a.branch_code = pbran_code or pbran_code is null) and
          (a.branch_code in(select  distinct l.branch_code from login_branch_mast l where a.branch_code=l.branch_code and (a.branch_code=pbran_code or pbran_code is null)and  l.user_code=pextra2 and nvl(l.user_flag,'N')='Y' ))  and
       /*  a.city_code in (select city_code from cir_city_mast where a.comp_code=pcomp_code and city_code = nvl(pcity_code,city_code) and 
         (zone_code = pzone_code or pzone_code is null) and (region_code = pregion_code or pregion_code is null))*/
         a.city_code in (select city_code from cir_city_mast where a.comp_code=pcomp_code and city_code = nvl(pcity_code,city_code) and 
         --(zone_code = pzone_code or pzone_code is null) and 
        -- (region_code = pregion_code or pregion_code is null)
        (zone_code in(select  distinct l.zone_code from login_zone_mast l where zone_code=l.zone_code and (zone_code=pzone_code or pzone_code is null)and  l.user_code=pextra2 and nvl(l.user_flag,'N')='Y' ))  and
        (region_code in(select  distinct l.region_code from login_region_mast l where region_code=l.region_code and (region_code=pregion_code or pregion_code is null)and  l.user_code=pextra2 and nvl(l.user_flag,'N')='Y' ))  
         )
         order by route_seq,supply_seq,agency_name;
  else
      if pextra1=2 then---for edition district and agency wise
            if pextra3='M' then
              open p_circuls for
              select c.comp_code as "COMP_CODE",c.unit_code as "UNIT_CODE",a.agcd as "AGCD",a.dpcd as "DPCD",a.ag_name as "AGENCY_NAME",a.ag_name_oth_lang as "AGENCY_NAME_OTHER_LANG",a.city_code as "CITY_CODE",
                    cir_get_city(a.comp_code,a.city_code) as "CITY_NAME",a.station_code as "DROP_POINT_CODE",cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,'1') as "DROP_POINT_NAME",
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
                  a.agcd=c.agcd and a.dpcd=c.dpcd and a.agcd=nvl(pagcd_code,a.agcd) and a.dpcd=nvl(pdpcd_code,a.dpcd) and 
                  c.sup_type_code=nvl(psup_type,c.sup_type_code)) as "TOTAL_SUPPLY",c.final_supply_flag as "FINAL_SUPPLY_FLAG",
                  d.dist_name as "DIST_NAME"
              from cir_agmast a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,
                   cir_supply_type_mast b,cir_dbksup c,cir_publ_mast p,cir_edtn_mast e,cir_supply s
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
             --(a.branch_code = pbran_code or pbran_code is null) and
             (a.branch_code in(select  distinct l.branch_code from login_branch_mast l where a.branch_code=l.branch_code and (a.branch_code=pbran_code or pbran_code is null)and  l.user_code=pextra2 and nvl(l.user_flag,'N')='Y' ))  and
             a.city_code in (select city_code from cir_city_mast where a.comp_code=pcomp_code and city_code = nvl(pcity_code,city_code) and 
            -- (zone_code = pzone_code or pzone_code is null) and (region_code = pregion_code or pregion_code is null))
            (zone_code in(select  distinct l.zone_code from login_zone_mast l where zone_code=l.zone_code and (zone_code=pzone_code or pzone_code is null)and  l.user_code=pextra2 and nvl(l.user_flag,'N')='Y' ))  and
            (region_code in(select  distinct l.region_code from login_region_mast l where region_code=l.region_code and (region_code=pregion_code or pregion_code is null)and  l.user_code=pextra2 and nvl(l.user_flag,'N')='Y' ))
            and (c.SUP_COPY > to_number(pextra4) or pextra4 is null)
            )
             order by dist_name,agency_name,supply_seq;
          else
            open p_circuls for
          select c.comp_code as "COMP_CODE",c.unit_code as "UNIT_CODE",a.agcd as "AGCD",a.dpcd as "DPCD",a.ag_name as "AGENCY_NAME",a.ag_name_oth_lang as "AGENCY_NAME_OTHER_LANG",a.city_code as "CITY_CODE",
                cir_get_city(a.comp_code,a.city_code) as "CITY_NAME",a.station_code as "DROP_POINT_CODE",cir_get_drop_point_name(a.comp_code,a.unit,a.station_code,'1') as "DROP_POINT_NAME",
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
              a.agcd=c.agcd and a.dpcd=c.dpcd and a.agcd=nvl(pagcd_code,a.agcd) and a.dpcd=nvl(pdpcd_code,a.dpcd) and 
              c.sup_type_code=nvl(psup_type,c.sup_type_code)) as "TOTAL_SUPPLY",c.final_supply_flag as "FINAL_SUPPLY_FLAG",
              d.dist_name as "DIST_NAME"
          from cir_agmast a left outer join cir_dist_mast d on a.comp_code=d.comp_code and a.dist_code=d.dist_code,
               cir_supply_type_mast b,cir_dbksup c,cir_publ_mast p,cir_edtn_mast e,cir_supply s
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
         --(a.branch_code = pbran_code or pbran_code is null) and
         (a.branch_code in(select  distinct l.branch_code from login_branch_mast l where a.branch_code=l.branch_code and (a.branch_code=pbran_code or pbran_code is null)and  l.user_code=pextra2 and nvl(l.user_flag,'N')='Y' ))  and
         a.city_code in (select city_code from cir_city_mast where a.comp_code=pcomp_code and city_code = nvl(pcity_code,city_code) and 
        -- (zone_code = pzone_code or pzone_code is null) and (region_code = pregion_code or pregion_code is null))
        (zone_code in(select  distinct l.zone_code from login_zone_mast l where zone_code=l.zone_code and (zone_code=pzone_code or pzone_code is null)and  l.user_code=pextra2 and nvl(l.user_flag,'N')='Y' ))  and
        (region_code in(select  distinct l.region_code from login_region_mast l where region_code=l.region_code and (region_code=pregion_code or pregion_code is null)and  l.user_code=pextra2 and nvl(l.user_flag,'N')='Y' ))
        and (c.SUP_COPY < to_number(pextra4) or pextra4 is null)
        )
         order by dist_name,agency_name,supply_seq;
       end if;
      else
            if pextra3 ='M' then
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
                  a.agcd=c.agcd and a.dpcd=c.dpcd and a.agcd=nvl(pagcd_code,a.agcd) and a.dpcd=nvl(pdpcd_code,a.dpcd) and c.sup_type_code=nvl(psup_type,c.sup_type_code)) as "TOTAL_SUPPLY",
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
             --(a.branch_code = pbran_code or pbran_code is null) and
             (a.branch_code in(select  distinct l.branch_code from login_branch_mast l where a.branch_code=l.branch_code and (a.branch_code=pbran_code or pbran_code is null)and  l.user_code=pextra2 and nvl(l.user_flag,'N')='Y' ))  and
             a.city_code in (select city_code from cir_city_mast where a.comp_code=pcomp_code and city_code = nvl(pcity_code,city_code) and 
             --(zone_code = pzone_code or pzone_code is null) and (region_code = pregion_code or pregion_code is null))
             (zone_code in(select  distinct l.zone_code from login_zone_mast l where zone_code=l.zone_code and (zone_code=pzone_code or pzone_code is null)and  l.user_code=pextra2 and nvl(l.user_flag,'N')='Y' ))  and
            (region_code in(select  distinct l.region_code from login_region_mast l where region_code=l.region_code and (region_code=pregion_code or pregion_code is null)and  l.user_code=pextra2 and nvl(l.user_flag,'N')='Y' ))
            and (c.SUP_COPY > to_number(pextra4) or pextra4 is null)
            )
             order by route_seq,supply_seq,agency_name;
             
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
                  a.agcd=c.agcd and a.dpcd=c.dpcd and a.agcd=nvl(pagcd_code,a.agcd) and a.dpcd=nvl(pdpcd_code,a.dpcd) and c.sup_type_code=nvl(psup_type,c.sup_type_code)) as "TOTAL_SUPPLY",
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
             --(a.branch_code = pbran_code or pbran_code is null) and
             (a.branch_code in(select  distinct l.branch_code from login_branch_mast l where a.branch_code=l.branch_code and (a.branch_code=pbran_code or pbran_code is null)and  l.user_code=pextra2 and nvl(l.user_flag,'N')='Y' ))  and
             a.city_code in (select city_code from cir_city_mast where a.comp_code=pcomp_code and city_code = nvl(pcity_code,city_code) and 
             --(zone_code = pzone_code or pzone_code is null) and (region_code = pregion_code or pregion_code is null))
             (zone_code in(select  distinct l.zone_code from login_zone_mast l where zone_code=l.zone_code and (zone_code=pzone_code or pzone_code is null)and  l.user_code=pextra2 and nvl(l.user_flag,'N')='Y' ))  and
            (region_code in(select  distinct l.region_code from login_region_mast l where region_code=l.region_code and (region_code=pregion_code or pregion_code is null)and  l.user_code=pextra2 and nvl(l.user_flag,'N')='Y' ))
            and (c.SUP_COPY < to_number(pextra4) or pextra4 is null)
            )
             order by route_seq,supply_seq,agency_name;
             
         end if;
      end if;
   end if;
 End cir_one_day_supply_change_p;
END cir_one_day_supply_change;
/


***************************** end ****************************************************************


************************** Rikkee Garg updated by Ghansyam sir Supply type wise report issue-7885*********

********spe*****
CREATE OR REPLACE PACKAGE HT18JULY.cir_rep_supply IS
  type t_accounts is ref cursor;
procedure cir_rep_supply1(
    pcomp_code          in varchar2,
    punit_code          in varchar2,
    ppubl               in varchar2,
    pmainedtn           in varchar2,
    pedtn               in varchar2,
    proute              in varchar2,
    pfrom_supdate       in varchar2,
    ptill_supdate       in varchar2,
    pdateformat         in varchar2,
    pextra1             in varchar2,--for branch
    pextra2             in varchar2,---for  route,
    pextra3             in varchar2,----this is use to final and unfinal po
    pextra4             in varchar2,---for  zone,
    pextra5             in varchar2,---for region
    pextra6             in varchar2,---for district
    pextra7             in varchar2,---fortaluka
    pextra8             in varchar2,
    pextra9             in varchar2,
    pextra10            in varchar2,
    -- pextra11          in  VARCHAR2,-- it is using for standing order / posting
 --   pextra12          in  VARCHAR2,
   -- pextra13         in   VARCHAR2,
 --  pextra14         in   VARCHAR2,
  --  pextra15         in  VARCHAR2,
    p_accounts          out t_accounts,
    p_accounts1         out t_accounts,
    p_accounts2         out t_accounts,
    p_accounts3         out t_accounts,
    p_accounts4         out t_accounts);
    
procedure cir_rep_supply_po(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     ppubl              in varchar2,
     pedtn              in varchar2,
     psupdate           in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     pextra3            in varchar2,------suply flag final unfinal y/n
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts);
     
procedure cir_rep_daybook(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     ppubl              in varchar2,
     pedtn              in varchar2,
     pcitycd            in varchar2,
     pstatecd           in varchar2,
     pmonth             in varchar2,
     pyear              in number,
     pdateformat        in varchar2,
     pbranch            in varchar2,
     pdistcode          in varchar2,
     ptaluka            in varchar2,
     pagtype            in varchar2,
     pagclass           in varchar2,
     pagcode            in varchar2,
     pdpcode            in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     pextra3            in varchar2,
     pextra4            in varchar2,
     pextra5            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts);
     
procedure cir_rep_dist_daybook(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     ppubl              in varchar2,
     pedtn              in varchar2,
     pcitycd            in varchar2,
     pstatecd           in varchar2,
     pmonth             in varchar2,
     pyear              in number,
     pdateformat        in varchar2,
     pbranch            in varchar2,
     pdistcode          in varchar2,
     ptaluka            in varchar2,
     pagtype            in varchar2,
     pagclass           in varchar2,
     pagcode            in varchar2,
     pdpcode            in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     pextra3            in varchar2,
     pextra4            in varchar2,
     pextra5            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts);
       
procedure cir_rep_taluka_daybook(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     ppubl              in varchar2,
     pedtn              in varchar2,
     pcitycd            in varchar2,
     pstatecd           in varchar2,
     pmonth             in varchar2,
     pyear              in number,
     pdateformat        in varchar2,
     pbranch            in varchar2,
     pdistcode          in varchar2,
     ptaluka            in varchar2,
     pagtype            in varchar2,
     pagclass           in varchar2,
     pagcode            in varchar2,
     pdpcode            in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     pextra3            in varchar2,
     pextra4            in varchar2,
     pextra5            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts);
       
procedure cir_rep_day_daybook(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     ppubl              in varchar2,
     pedtn              in varchar2,
     pcitycd            in varchar2,
     pstatecd           in varchar2,
     pmonth             in varchar2,
     pyear              in number,
     pday               in varchar2,
     pdateformat        in varchar2,
     pbranch            in varchar2,
     pdistcode          in varchar2,
     ptaluka            in varchar2,
     pagtype            in varchar2,
     pagclass           in varchar2,
     pagcode            in varchar2,
     pdpcode            in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     pextra3            in varchar2,
     pextra4            in varchar2,
     pextra5            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts);
     
procedure cir_rep_dist_day_daybook(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     ppubl              in varchar2,
     pedtn              in varchar2,
     pcitycd            in varchar2,
     pstatecd           in varchar2,
     pmonth             in varchar2,
     pyear              in number,
     pday               in varchar2,
     pdateformat        in varchar2,
     pbranch            in varchar2,
     pdistcode          in varchar2,
     ptaluka            in varchar2,
     pagtype            in varchar2,
     pagclass           in varchar2,
     pagcode            in varchar2,
     pdpcode            in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     pextra3            in varchar2,
     pextra4            in varchar2,
     pextra5            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts);
          
procedure cir_rep_taluka_day_daybook(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     ppubl              in varchar2,
     pedtn              in varchar2,
     pcitycd            in varchar2,
     pstatecd           in varchar2,
     pmonth             in varchar2,
     pyear              in number,
     pday               in varchar2,
     pdateformat        in varchar2,
     pbranch            in varchar2,
     pdistcode          in varchar2,
     ptaluka            in varchar2,
     pagtype            in varchar2,
     pagclass           in varchar2,
     pagcode            in varchar2,
     pdpcode            in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     pextra3            in varchar2,
     pextra4            in varchar2,
     pextra5            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts);
     
procedure cir_rep_route_challan(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pperiod            in number,
     prmode             in varchar2,
     psupdate           in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts);

procedure cir_rep_dist_challan(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pperiod            in number,
     prmode             in varchar2,
     psupdate           in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts);

procedure cir_rep_taluka_challan(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     pperiod            in number,
     prmode             in varchar2,
     psupdate           in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts);

procedure cir_route_wise_supply(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pedtn              in varchar2,
     proute             in varchar2,
     pfrom_supdate      in varchar2,
     ptill_supdate      in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,--for login user id
     pextra2            in varchar2,-------supply type
     pextra3            in varchar2,-------agency type
     pextra4            in varchar2,-------agency class
     pextra5            in varchar2, 
     pextra6            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts,
     p_accounts3        out t_accounts);

procedure cir_dist_wise_supply(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pedtn              in varchar2,
     proute             in varchar2,
     pfrom_supdate      in varchar2,
     ptill_supdate      in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,--for login user id
     pextra2            in varchar2,-------agency class
     pextra3            in varchar2,-------supply type 
     pextra4            in varchar2,-------agency type    
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts,
     p_accounts3        out t_accounts);

procedure cir_taluka_wise_supply(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pedtn              in varchar2,
     proute             in varchar2,
     pfrom_supdate      in varchar2,
     ptill_supdate      in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,--for login user id
     pextra2            in varchar2,-------agency class
     pextra3            in varchar2,-------supply type 
     pextra4            in varchar2,-------agency type
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts,
     p_accounts3        out t_accounts);

procedure cir_dist_taluka_wise_sup(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pedtn              in varchar2,
     proute             in varchar2,
     pfrom_supdate      in varchar2,
     ptill_supdate      in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts,
     p_accounts3        out t_accounts,
     p_accounts4        out t_accounts);

procedure cir_supply_comp(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     ppublication       in varchar2,
     psupdate           in varchar2,
     psupdate1          in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts,
     p_accounts3        out t_accounts);

procedure cir_route_supply_variance_p(
    pcomp_code         in varchar2,
    punit_code         in varchar2,
    ppublication       in varchar2,
    pmainedtn          in varchar2,
    pedtn              in varchar2,
    proute             in varchar2,
    pfirstdate         in varchar2,
    pseconddate        in varchar2,
    pdateformat        in varchar2,
    pextra1            in varchar2,
    pextra2            in varchar2,
    pextra3            in varchar2,--agency type
    pextra4            in varchar2,-- agency class
    pextra5            in varchar2,--final.unfinal
    pextra6            in varchar2,
    pextra7            in varchar2,
    pextra8            in varchar2,
    pextra9            in varchar2,
    pextra10           in varchar2,
    p_accounts         out t_accounts,
    p_accounts1        out t_accounts,
    p_accounts2        out t_accounts);
    
procedure cir_dist_supply_variance_p(
    pcomp_code         in varchar2,
    punit_code         in varchar2,
    ppublication       in varchar2,
    pmainedtn          in varchar2,
    pedtn              in varchar2,
    pdist              in varchar2,
    pfirstdate         in varchar2,
    pseconddate        in varchar2,
    pdateformat        in varchar2,
    pextra1            in varchar2,
    pextra2            in varchar2,
    pextra3            in varchar2,--agency type
    pextra4            in varchar2,-- agency class
    pextra5            in varchar2,--final.unfinal
    pextra6            in varchar2,
    pextra7            in varchar2,
    pextra8            in varchar2,
    pextra9            in varchar2,
    pextra10           in varchar2,
    p_accounts         out t_accounts,
    p_accounts1        out t_accounts,
    p_accounts2        out t_accounts);
    
procedure cir_taluka_supply_variance_p(
    pcomp_code          in varchar2,
    punit_code          in varchar2,
    ppublication        in varchar2,
    pmainedtn           in varchar2,
    pedtn               in varchar2,
    ptaluka             in varchar2,
    pfirstdate          in varchar2,
    pseconddate         in varchar2,
    pdateformat         in varchar2,
    pextra1             in varchar2,--it is use for finalised or unfinalised
    pextra2             in varchar2,--it is used for supply type
    pextra3             in varchar2,--agency type
    pextra4             in varchar2,-- agency class
    pextra5             in varchar2,--final.unfinal
    pextra6             in varchar2,
    pextra7             in varchar2,
    pextra8             in varchar2,
    pextra9             in varchar2,
    pextra10            in varchar2,
    p_accounts          out t_accounts,
    p_accounts1         out t_accounts,
    p_accounts2         out t_accounts);
    
procedure cir_edition_supply_variance_p(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     ppublication       in varchar2,
     pmainedtn          in varchar2,
     pedtn              in varchar2,
     pfirstdate         in varchar2,
     pseconddate        in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts);
     
procedure cir_rep_supply_unit(
    pcomp_code         in varchar2,
    punit_code         in varchar2,
    ppubl              in varchar2,
    pfrom_supdate      in varchar2,
    ptill_supdate      in varchar2,
    pdateformat        in varchar2,
    pextra1            in varchar2,
    pextra2            in varchar2,
    p_accounts         out t_accounts,
    p_accounts1        out t_accounts);
    
procedure cir_dist_taluka_publ_wise(
    pcompcode          in varchar2,
    punitcode          in varchar2,
    pbrancode          in varchar2,
    ppublcode          in varchar2,
    pmainedtn          in varchar2,
    pedtncode          in varchar2,
    pdistcode          in varchar2,
    ptalukacode        in varchar2,
    pagtypecode        in varchar2,
    pagclasscode       in varchar2,
    pagcd              in varchar2,
    pdpcd              in varchar2,
    pfrom_supdate      in varchar2,
    ptill_supdate      in varchar2,
    plangtype          in varchar2,
    pdateformat        in varchar2,
    pextra1            in varchar2,
    pextra2            in varchar2,
    p_accounts         out t_accounts);
    
procedure cir_datewise_resale(
    pcompcode          in varchar2,
    punitcode          in varchar2,
    pbrancode          in varchar2,
    ppublcode          in varchar2,
    pmainedtn          in varchar2,
    pedtncode          in varchar2,
    pdistcode          in varchar2,
    ptalukacode        in varchar2,
    pagtypecode        in varchar2,
    pagclasscode       in varchar2,
    pagcd              in varchar2,
    pdpcd              in varchar2,
    pfrom_supdate      in varchar2,
    ptill_supdate      in varchar2,
    plangtype          in varchar2,
    pdateformat        in varchar2,
    pextra1            in varchar2,
    pextra2            in varchar2,
    p_accounts         out t_accounts);  

procedure cir_branch_wise_supply(
    pcomp_code     in varchar2,
    punit_code     in varchar2,
    ppubl          in varchar2,
    pmainedtn      in varchar2,
    pedtn          in varchar2,
    proute         in varchar2,
    pfrom_supdate  in varchar2,
    ptill_supdate  in varchar2,
    pdateformat    in varchar2,
    pextra1        in varchar2,--for login user id
    pextra2        in varchar2,----supply type
    pextra3        in varchar2,------fro ag_type
    pextra4        in varchar2,------ for ,ag_class
    p_accounts     out t_accounts,
    p_accounts1    out t_accounts,
    p_accounts2    out t_accounts,
    p_accounts3    out t_accounts) ;                     
END cir_rep_supply;
/
***************

CREATE OR REPLACE PACKAGE HT18JULY.CIR_REP_SUPPLY_TEMP IS
    type t_accounts is ref cursor;
procedure cir_rep_supply_summ_new_p1(
    pcomp_code      in varchar2,
    punit_code      in varchar2,
    ppubl           in varchar2,
    pmainedtn       in varchar2,
    pedtn           in varchar2,
    proute          in varchar2,
    pfrom_supdate   in varchar2,
    ptill_supdate   in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,--for branch
    pextra2         in varchar2,
    pextra3         in varchar2,----this is use to final and unfinal po
    pextra4         in varchar2,---for  zone,
    pextra5         in varchar2,---for region
    pextra6         in varchar2,---for district
    pextra7         in varchar2,---fortaluka
    pextra8         in varchar2,-----report type filter
    pextra9         in varchar2,
    pextra10        in varchar2,
    p_accounts      out t_accounts);

end CIR_REP_SUPPLY_TEMP;
/
************end of spe**********

************Body***************

CREATE OR REPLACE PACKAGE BODY HT18JULY.cir_rep_supply IS
  procedure cir_rep_supply1(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     ppubl              in varchar2,
     pmainedtn          in varchar2,
     pedtn              in varchar2,
     proute             in varchar2,
     pfrom_supdate      in varchar2,
     ptill_supdate      in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,--for branch
     pextra2            in varchar2,--for State,
     pextra3            in varchar2,--this is use to final and unfinal po
     pextra4            in varchar2,--for zone,
     pextra5            in varchar2,--for region
     pextra6            in varchar2,--for district
     pextra7            in varchar2,--fortaluka
     pextra8            in varchar2,--report type filter 1 for routewise,2 for branchwise,3 for zonewise,4 for regionwise,5 for district,6 for talukaiwse,7 for state,other than executivewise
     pextra9            in varchar2,--for publication type
     pextra10           in varchar2,--for executive
    -- pextra11          in  VARCHAR2,-- it is using for standing order / posting
   --  pextra12          in  VARCHAR2,
  --   pextra13         in   VARCHAR2,
   --  pextra14         in   VARCHAR2,
   --  pextra15         in  VARCHAR2,
    
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts,
     p_accounts2        out t_accounts,
     p_accounts3        out t_accounts,
     p_accounts4        out t_accounts)
As
vfrom_supdate    date;
vtill_supdate    date;
     cursor cur_sup_type is
         select distinct ' sum(case sup_type_code when '||''''||sup_ty_code||''''||' then sup_copy else 0 end ) "'||sup_ty_name||'",' vty,
     'sum(case sup_type_code when '||''''||sup_ty_code||''''||' then sup_copy else 0 end ) +' vty_sum, 
     --'sum(decode(sup_type_code,'||''''||sup_ty_code||''''||',sup_copy,0)) "'||sup_ty_name||'",' vty,
     --'sum(decode(sup_type_code,'||''''||sup_ty_code||''''||',sup_copy,0)) +' vty_sum,
     sup_seq_no
    from cir_supply_type_mast s, cir_dbksup d,cir_edtn_mast e,cir_publ_mast p
    where s.comp_code=pcomp_code and s.comp_code=d.comp_code and s.comp_code=e.comp_code and s.comp_code=p.comp_code and  
    s.sup_ty_code =d.sup_type_code and
    d.unit_code=nvl(punit_code,d.unit_code) and d.publ=e.publ and d.publ=p.publ and d.publ=nvl(ppubl,d.publ) and d.edtn=e.edtn and 
    d.edtn=nvl(pedtn,d.edtn) and
    d.supdate between vfrom_supdate and vtill_supdate and
    e.main_edtn=nvl(pmainedtn,e.main_edtn) and (p.pro_type=pextra9 or pextra9 is null)
    order by sup_seq_no;
     rec_sup_type cur_sup_type%rowtype;
     vvar         varchar2(4000);
     vvar_sum    varchar2(4000);
     vquery     varchar2(4000);
     vquery1     varchar2(4000);
     vquery2     varchar2(4000);
     vquery3     varchar2(4000);
     vquery4     varchar2(4000);
Begin
       vfrom_supdate:=to_date(pfrom_supdate,''''||pdateformat||'''');
       vtill_supdate:=to_date(ptill_supdate,''''||pdateformat||'''');
    open cur_sup_type;
    loop
        fetch cur_sup_type into rec_sup_type;
      exit when cur_sup_type%notfound;
          vvar        :=vvar||rec_sup_type.vty;
          vvar_sum:=vvar_sum||rec_sup_type.vty_sum;
    end loop;
    close cur_sup_type;
    vvar    :=substr(vvar,1,length(vvar)-1);
    vvar_sum:=substr(vvar_sum,1,length(vvar_sum)-1);
    --insert into test1(vstring) values (vquery);commit;

if pextra8='1' then--for route
    vquery:=' select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,cir_get_publ_name(d.comp_code,d.publ) publ_name,d.edtn,cir_get_edtn_name(d.comp_code,d.edtn) edtn_name,d.route_code route_code,cir_get_route_name(d.comp_code,d.unit_code,d.route_code) route_name,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
        substr(m.ag_name,1,50) "AGENCY NAME",substr(m.ag_name_oth_lang,1,50) "AGENCY ONAME",c.city_name "CITY NAME",
        c.city_oname "CITY ONAME", cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '||vvar||','||vvar_sum||' TOTAL
        ,cir_get_mode_name(d.comp_code,d.unit_code||d.route_code) as "MODE_NAME" 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p 
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='''||pcomp_code||''' and m.unit=d.unit_code and d.unit_code='||''''||punit_code||''''||' and d.publ=e.publ and d.publ=p.publ and d.publ=nvl('''||ppubl||''',d.publ) 
        and d.edtn=e.edtn and d.edtn=nvl('''||pedtn||''',d.edtn) 
        and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
        and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
        and (d.route_code='''||proute||''' or '''||proute||''' is null) 
        and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
        and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
        and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
        and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
        and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
        and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
        and m.city_code=c.city_code
        and e.main_edtn=nvl('''||pmainedtn||''',e.main_edtn)
        and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
        and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
        group by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,c.city_name,c.city_oname,m.station_code 
        order by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code,d.agcd,d.dpcd';

        insert into test1(vstring) values ('1'||vquery);commit;

        open p_accounts for vquery;

        vquery2:=' select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,cir_get_publ_name(d.comp_code,d.publ) publ_name,d.edtn,cir_get_edtn_name(d.comp_code,d.edtn) edtn_name,d.route_code route_code, '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c ,cir_publ_mast p
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='''||pcomp_code||''' and m.unit=d.unit_code and d.unit_code='||''''||punit_code||''''||' and d.publ=e.publ and d.publ=p.publ and d.publ=nvl('''||ppubl||''',d.publ) 
        and d.edtn=e.edtn and d.edtn=nvl('''||pedtn||''',d.edtn) 
        and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
        and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
        and (d.route_code='''||proute||''' or '''||proute||''' is null) 
        and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
        and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
        and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
        and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
        and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
        and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
        and m.city_code=c.city_code
        and e.main_edtn=nvl('''||pmainedtn||''',e.main_edtn)
        and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
        and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
        group by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code order by d.comp_code,d.unit_code,d.publ,d.edtn,d.route_code';

        insert into test1(vstring) values ('3'||vquery2);commit;
        open p_accounts2 for vquery2;
        
elsif pextra8='2' then----for  branch
    vquery:=' select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,cir_get_publ_name(d.comp_code,d.publ) publ_name,d.edtn,cir_get_edtn_name(d.comp_code,d.edtn) edtn_name,m.branch_code branch_code,cir_get_branch(d.comp_code,m.branch_code) branch_name,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
        substr(m.ag_name,1,50) "AGENCY NAME",substr(m.ag_name_oth_lang,1,50) "AGENCY ONAME",c.city_name "CITY NAME",
        c.city_oname "CITY ONAME", cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='''||pcomp_code||''' and m.unit=d.unit_code and d.unit_code='||''''||punit_code||''''||' and d.publ=e.publ and d.publ=p.publ and d.publ=nvl('''||ppubl||''',d.publ) 
        and d.edtn=e.edtn and d.edtn=nvl('''||pedtn||''',d.edtn) 
        and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
        and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
        and (d.route_code='''||proute||''' or '''||proute||''' is null) 
        and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
        and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
        and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
        and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
        and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
        and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
        and m.city_code=c.city_code
        and e.main_edtn=nvl('''||pmainedtn||''',e.main_edtn)
        and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
        and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
        group by d.comp_code,d.unit_code,d.publ,d.edtn,m.branch_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,c.city_name,c.city_oname,m.station_code 
        order by d.comp_code,d.unit_code,d.publ,d.edtn,m.branch_code,d.agcd,d.dpcd';

        insert into test1(vstring) values ('1'||vquery);commit;

        open p_accounts for vquery;

        vquery2:=' select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,cir_get_publ_name(d.comp_code,d.publ) publ_name,d.edtn,cir_get_edtn_name(d.comp_code,d.edtn) edtn_name,
        m.branch_code branch_code,cir_get_branch(d.comp_code,m.branch_code) branch_name, '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c ,cir_publ_mast p
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='''||pcomp_code||''' and m.unit=d.unit_code and d.unit_code='||''''||punit_code||''''||' and d.publ=e.publ and d.publ=p.publ and d.publ=nvl('''||ppubl||''',d.publ) 
        and d.edtn=e.edtn and d.edtn=nvl('''||pedtn||''',d.edtn) 
        and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
        and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
        and (d.route_code='''||proute||''' or '''||proute||''' is null) 
        and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
        and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
        and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
        and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
        and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
        and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
        and m.city_code=c.city_code
        and e.main_edtn=nvl('''||pmainedtn||''',e.main_edtn)
        and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
        and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
        group by d.comp_code,d.unit_code,d.publ,d.edtn,m.branch_code order by d.comp_code,d.unit_code,d.publ,d.edtn,m.branch_code';

        insert into test1(vstring) values ('3'||vquery2);commit;
        open p_accounts2 for vquery2;
        
elsif pextra8='3' then----for  zone
    vquery:=' select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,cir_get_publ_name(d.comp_code,d.publ) publ_name,d.edtn,cir_get_edtn_name(d.comp_code,d.edtn) edtn_name,
        c.zone_code,cir_get_zone_name(d.comp_code,c.zone_code) zone_name,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
        substr(m.ag_name,1,50) "AGENCY NAME",substr(m.ag_name_oth_lang,1,50) "AGENCY ONAME",c.city_name "CITY NAME",
        c.city_oname "CITY ONAME", cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='''||pcomp_code||''' and m.unit=d.unit_code and d.unit_code='||''''||punit_code||''''||' and d.publ=e.publ and d.publ=p.publ and d.publ=nvl('''||ppubl||''',d.publ) 
        and d.edtn=e.edtn and d.edtn=nvl('''||pedtn||''',d.edtn) 
        and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
        and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
        and (d.route_code='''||proute||''' or '''||proute||''' is null) 
        and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
        and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
        and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
        and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
        and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
        and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
        and m.city_code=c.city_code
        and e.main_edtn=nvl('''||pmainedtn||''',e.main_edtn)
        and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
        and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
        group by d.comp_code,d.unit_code,d.publ,d.edtn,c.zone_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,c.city_name,c.city_oname,m.station_code 
        order by d.comp_code,d.unit_code,d.publ,d.edtn,c.zone_code,d.agcd,d.dpcd';

        insert into test1(vstring) values ('1'||vquery);commit;

        open p_accounts for vquery;

        vquery2:=' select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,cir_get_publ_name(d.comp_code,d.publ) publ_name,d.edtn,cir_get_edtn_name(d.comp_code,d.edtn) edtn_name,c.zone_code zone_code, '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='''||pcomp_code||''' and m.unit=d.unit_code and d.unit_code='||''''||punit_code||''''||' and d.publ=e.publ and d.publ=p.publ and d.publ=nvl('''||ppubl||''',d.publ) 
        and d.edtn=e.edtn and d.edtn=nvl('''||pedtn||''',d.edtn) 
        and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
        and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
        and (d.route_code='''||proute||''' or '''||proute||''' is null) 
        and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
        and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
        and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
        and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
        and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
        and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
        and m.city_code=c.city_code
        and e.main_edtn=nvl('''||pmainedtn||''',e.main_edtn)
        and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
        and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
        group by d.comp_code,d.unit_code,d.publ,d.edtn,c.zone_code order by d.comp_code,d.unit_code,d.publ,d.edtn,c.zone_code';

        insert into test1(vstring) values ('3'||vquery2);commit;
        open p_accounts2 for vquery2;        
        
elsif pextra8='4' then----for  region
    vquery:=' select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,cir_get_publ_name(d.comp_code,d.publ) publ_name,d.edtn,cir_get_edtn_name(d.comp_code,d.edtn) edtn_name,c.region_code region_code,cir_get_region_name(d.comp_code,c.region_code) region_name,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
        substr(m.ag_name,1,50) "AGENCY NAME",substr(m.ag_name_oth_lang,1,50) "AGENCY ONAME",c.city_name "CITY NAME",
        c.city_oname "CITY ONAME", cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='''||pcomp_code||''' and m.unit=d.unit_code and d.unit_code='||''''||punit_code||''''||' and d.publ=e.publ and d.publ=p.publ and d.publ=nvl('''||ppubl||''',d.publ) 
        and d.edtn=e.edtn and d.edtn=nvl('''||pedtn||''',d.edtn) 
        and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
        and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
        and (d.route_code='''||proute||''' or '''||proute||''' is null) 
        and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
        and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
        and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
        and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
        and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
        and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
        and m.city_code=c.city_code
        and e.main_edtn=nvl('''||pmainedtn||''',e.main_edtn)
        and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
        and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
        group by d.comp_code,d.unit_code,d.publ,d.edtn,c.region_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,c.city_name,c.city_oname,m.station_code 
        order by d.comp_code,d.unit_code,d.publ,d.edtn,c.region_code,d.agcd,d.dpcd';

        insert into test1(vstring) values ('1'||vquery);commit;

        open p_accounts for vquery;

        vquery2:=' select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,cir_get_publ_name(d.comp_code,d.publ) publ_name,d.edtn,cir_get_edtn_name(d.comp_code,d.edtn) edtn_name,c.region_code region_code, '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='''||pcomp_code||''' and m.unit=d.unit_code and d.unit_code='||''''||punit_code||''''||' and d.publ=e.publ and d.publ=p.publ and d.publ=nvl('''||ppubl||''',d.publ) 
        and d.edtn=e.edtn and d.edtn=nvl('''||pedtn||''',d.edtn) 
        and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
        and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
        and (d.route_code='''||proute||''' or '''||proute||''' is null) 
        and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
        and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
        and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
        and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
        and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
        and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
        and m.city_code=c.city_code
        and e.main_edtn=nvl('''||pmainedtn||''',e.main_edtn)
        and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
        and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
        group by d.comp_code,d.unit_code,d.publ,d.edtn,c.region_code 
        order by d.comp_code,d.unit_code,d.publ,d.edtn,c.region_code';

        insert into test1(vstring) values ('3'||vquery2);commit;
        open p_accounts2 for vquery2;
elsif pextra8='5' then----for  district
    vquery:=' select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,cir_get_publ_name(d.comp_code,d.publ) publ_name,d.edtn,cir_get_edtn_name(d.comp_code,d.edtn) edtn_name,m.dist_code dist_code,cir_get_name.cir_district(d.comp_code,m.dist_code,''1'',null,null,null) dist_name,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
        substr(m.ag_name,1,50) "AGENCY NAME",substr(m.ag_name_oth_lang,1,50) "AGENCY ONAME",c.city_name "CITY NAME",
        c.city_oname "CITY ONAME", cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='''||pcomp_code||''' and m.unit=d.unit_code and d.unit_code='||''''||punit_code||''''||' and d.publ=e.publ and d.publ=p.publ and d.publ=nvl('''||ppubl||''',d.publ) 
        and d.edtn=e.edtn and d.edtn=nvl('''||pedtn||''',d.edtn) 
        and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
        and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
        and (d.route_code='''||proute||''' or '''||proute||''' is null) 
        and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
        and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
        and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
        and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
        and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
        and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
        and m.city_code=c.city_code
        and e.main_edtn=nvl('''||pmainedtn||''',e.main_edtn)
        and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
        and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
        group by d.comp_code,d.unit_code,d.publ,d.edtn,m.dist_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,c.city_name,c.city_oname,m.station_code 
        order by d.comp_code,d.unit_code,d.publ,d.edtn,m.dist_code,d.agcd,d.dpcd';

        insert into test1(vstring) values ('1'||vquery);commit;

        open p_accounts for vquery;

        vquery2:=' select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,cir_get_publ_name(d.comp_code,d.publ) publ_name,d.edtn,cir_get_edtn_name(d.comp_code,d.edtn) edtn_name,m.dist_code dist_code, '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='''||pcomp_code||''' and m.unit=d.unit_code and d.unit_code='||''''||punit_code||''''||' and d.publ=e.publ and d.publ=p.publ and d.publ=nvl('''||ppubl||''',d.publ) 
        and d.edtn=e.edtn and d.edtn=nvl('''||pedtn||''',d.edtn) 
        and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
        and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
        and (d.route_code='''||proute||''' or '''||proute||''' is null) 
        and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
        and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
        and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
        and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
        and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
        and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
        and m.city_code=c.city_code
        and e.main_edtn=nvl('''||pmainedtn||''',e.main_edtn)
        and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
        and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
        group by d.comp_code,d.unit_code,d.publ,d.edtn,m.dist_code 
        order by d.comp_code,d.unit_code,d.publ,d.edtn,m.dist_code';

        insert into test1(vstring) values ('3'||vquery2);commit;
        open p_accounts2 for vquery2;
elsif pextra8='6' then----for  tehsil_taluka 
    vquery:=' select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,cir_get_publ_name(d.comp_code,d.publ) publ_name,d.edtn,cir_get_edtn_name(d.comp_code,d.edtn) edtn_name,m.tehsil_taluka taluka_code,cir_get_taluka(d.comp_code,m.tehsil_taluka) taluka_name,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
        substr(m.ag_name,1,50) "AGENCY NAME",substr(m.ag_name_oth_lang,1,50) "AGENCY ONAME",c.city_name "CITY NAME",
        c.city_oname "CITY ONAME", cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='''||pcomp_code||''' and m.unit=d.unit_code and d.unit_code='||''''||punit_code||''''||' and d.publ=e.publ and d.publ=p.publ and d.publ=nvl('''||ppubl||''',d.publ) 
        and d.edtn=e.edtn and d.edtn=nvl('''||pedtn||''',d.edtn) 
        and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
        and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
        and (d.route_code='''||proute||''' or '''||proute||''' is null) 
        and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
        and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
        and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
        and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
        and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
        and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
        and m.city_code=c.city_code
        and e.main_edtn=nvl('''||pmainedtn||''',e.main_edtn)
        and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
        and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
        group by d.comp_code,d.unit_code,d.publ,d.edtn,m.tehsil_taluka,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,c.city_name,c.city_oname,m.station_code 
        order by d.comp_code,d.unit_code,d.publ,d.edtn,taluka_name,d.agcd,d.dpcd';

        insert into test1(vstring) values ('1'||vquery);commit;

        open p_accounts for vquery;

        vquery2:=' select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,cir_get_publ_name(d.comp_code,d.publ) publ_name,d.edtn,cir_get_edtn_name(d.comp_code,d.edtn) edtn_name,m.tehsil_taluka taluka_code, '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='''||pcomp_code||''' and m.unit=d.unit_code and d.unit_code='||''''||punit_code||''''||' and d.publ=e.publ and d.publ=p.publ and d.publ=nvl('''||ppubl||''',d.publ) 
        and d.edtn=e.edtn and d.edtn=nvl('''||pedtn||''',d.edtn) 
        and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
        and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
        and (d.route_code='''||proute||''' or '''||proute||''' is null) 
        and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
        and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
        and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
        and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
        and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
        and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
        and m.city_code=c.city_code
        and e.main_edtn=nvl('''||pmainedtn||''',e.main_edtn)
        and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
        and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
        group by d.comp_code,d.unit_code,d.publ,d.edtn,m.tehsil_taluka 
        order by d.comp_code,d.unit_code,d.publ,d.edtn,m.tehsil_taluka';

        insert into test1(vstring) values ('3'||vquery2);commit;
        open p_accounts2 for vquery2;
elsif pextra8='7' then----for  State Wise
    vquery:=' select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,cir_get_publ_name(d.comp_code,d.publ) publ_name,d.edtn,cir_get_edtn_name(d.comp_code,d.edtn) edtn_name,m.state_code state_code,cir_get_state1(d.comp_code,m.state_code) state_name,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
        substr(m.ag_name,1,50) "AGENCY NAME",substr(m.ag_name_oth_lang,1,50) "AGENCY ONAME",c.city_name "CITY NAME",
        c.city_oname "CITY ONAME", cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='''||pcomp_code||''' and m.unit=d.unit_code and d.unit_code='||''''||punit_code||''''||' and d.publ=e.publ and d.publ=p.publ and d.publ=nvl('''||ppubl||''',d.publ) 
        and d.edtn=e.edtn and d.edtn=nvl('''||pedtn||''',d.edtn) 
        and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
        and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
        and (d.route_code='''||proute||''' or '''||proute||''' is null) 
        and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
        and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
        and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
        and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
        and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
        and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
        and m.city_code=c.city_code
        and e.main_edtn=nvl('''||pmainedtn||''',e.main_edtn)
        and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
        and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
        group by d.comp_code,d.unit_code,d.publ,d.edtn,m.state_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,c.city_name,c.city_oname,m.station_code 
        order by d.comp_code,d.unit_code,d.publ,d.edtn,m.state_code,d.agcd,d.dpcd';

        insert into test1(vstring) values ('1'||vquery);commit;

        open p_accounts for vquery;

        vquery2:=' select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,cir_get_publ_name(d.comp_code,d.publ) publ_name,d.edtn,cir_get_edtn_name(d.comp_code,d.edtn) edtn_name,m.state_code state_code, '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='''||pcomp_code||''' and m.unit=d.unit_code and d.unit_code='||''''||punit_code||''''||' and d.publ=e.publ and d.publ=p.publ and d.publ=nvl('''||ppubl||''',d.publ) 
        and d.edtn=e.edtn and d.edtn=nvl('''||pedtn||''',d.edtn) 
        and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
        and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
        and (d.route_code='''||proute||''' or '''||proute||''' is null) 
        and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
        and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
        and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
        and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
        and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
        and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
        and m.city_code=c.city_code
        and e.main_edtn=nvl('''||pmainedtn||''',e.main_edtn)
        and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
        and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
        group by d.comp_code,d.unit_code,d.publ,d.edtn,m.state_code 
        order by d.comp_code,d.unit_code,d.publ,d.edtn,state_code';

        insert into test1(vstring) values ('3'||vquery2);commit;
        open p_accounts2 for vquery2;                                
 


elsif pextra8='8' then----for  Executive Wise
    vquery:=' select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,cir_get_publ_name(d.comp_code,d.publ) publ_name,d.edtn,cir_get_edtn_name(d.comp_code,d.edtn) edtn_name,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
        substr(m.ag_name,1,50) "AGENCY NAME",substr(m.ag_name_oth_lang,1,50) "AGENCY ONAME",c.city_name "CITY NAME",
        c.city_oname "CITY ONAME", cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT",m.executive_code executive_code,cir_get_executive(d.comp_code,m.executive_code) executive_name ,'||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='''||pcomp_code||''' and m.unit=d.unit_code and d.unit_code='||''''||punit_code||''''||' and d.publ=e.publ and d.publ=p.publ and d.publ=nvl('''||ppubl||''',d.publ) 
        and d.edtn=e.edtn and d.edtn=nvl('''||pedtn||''',d.edtn) 
        and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
        and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
        and (d.route_code='''||proute||''' or '''||proute||''' is null) 
        and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
        and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
        and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
        and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
        and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
        and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
        and m.city_code=c.city_code
        and e.main_edtn=nvl('''||pmainedtn||''',e.main_edtn)
        and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
        and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
        group by d.comp_code,d.unit_code,d.publ,d.edtn,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,c.city_name,c.city_oname,m.station_code,m.executive_code 
        order by d.comp_code,d.unit_code,d.publ,d.edtn,m.executive_code,d.agcd,d.dpcd';

        insert into test1(vstring) values ('1'||vquery);commit;

        open p_accounts for vquery;

        vquery2:=' select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,cir_get_publ_name(d.comp_code,d.publ) publ_name,d.edtn,cir_get_edtn_name(d.comp_code,d.edtn) edtn_name,m.executive_code executive_code,cir_get_executive(d.comp_code,m.executive_code) executive_name, '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='''||pcomp_code||''' and m.unit=d.unit_code and d.unit_code='||''''||punit_code||''''||' and d.publ=e.publ and d.publ=p.publ and d.publ=nvl('''||ppubl||''',d.publ) 
        and d.edtn=e.edtn and d.edtn=nvl('''||pedtn||''',d.edtn) 
        and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
        and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
        and (d.route_code='''||proute||''' or '''||proute||''' is null) 
        and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
        and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
        and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
        and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
        and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
        and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
        and m.city_code=c.city_code
        and e.main_edtn=nvl('''||pmainedtn||''',e.main_edtn)
        and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
        and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
        group by d.comp_code,d.unit_code,d.publ,d.edtn,m.executive_code 
        order by d.comp_code,d.unit_code,d.publ,d.edtn,m.executive_code';

        insert into test1(vstring) values ('3'||vquery2);commit;
        open p_accounts2 for vquery2;                                
  
 
        
else----for  executive wise
    vquery:=' select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,cir_get_publ_name(d.comp_code,d.publ) publ_name,d.edtn,cir_get_edtn_name(d.comp_code,d.edtn) edtn_name,m.executive_code executive_code,cir_get_executive(d.comp_code,m.executive_code) executive_name,d.agcd "AGENCY CODE",d.dpcd "AGENCY SUBCODE",
        substr(m.ag_name,1,50) "AGENCY NAME",substr(m.ag_name_oth_lang,1,50) "AGENCY ONAME",c.city_name "CITY NAME",
        c.city_oname "CITY ONAME", cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) "DROP_POINT", cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) "ODROP_POINT", '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='''||pcomp_code||''' and m.unit=d.unit_code and d.unit_code='||''''||punit_code||''''||' and d.publ=e.publ and d.publ=p.publ and d.publ=nvl('''||ppubl||''',d.publ) 
        and d.edtn=e.edtn and d.edtn=nvl('''||pedtn||''',d.edtn) 
        and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
        and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
        and (d.route_code='''||proute||''' or '''||proute||''' is null) 
        and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
        and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
        and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
        and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
        and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
        and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
        and m.city_code=c.city_code
        and e.main_edtn=nvl('''||pmainedtn||''',e.main_edtn)
        and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
        and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
        group by d.comp_code,d.unit_code,d.publ,d.edtn,m.executive_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,c.city_name,c.city_oname,m.station_code 
        order by d.comp_code,d.unit_code,d.publ,d.edtn,m.executive_code,d.agcd,d.dpcd';

        insert into test1(vstring) values ('1'||vquery);commit;

        open p_accounts for vquery;

        vquery2:=' select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,cir_get_publ_name(d.comp_code,d.publ) publ_name,d.edtn,cir_get_edtn_name(d.comp_code,d.edtn) edtn_name,m.executive_code executive_code, '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='''||pcomp_code||''' and m.unit=d.unit_code and d.unit_code='||''''||punit_code||''''||' and d.publ=e.publ and d.publ=p.publ and d.publ=nvl('''||ppubl||''',d.publ) 
        and d.edtn=e.edtn and d.edtn=nvl('''||pedtn||''',d.edtn) 
        and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
        and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
        and (d.route_code='''||proute||''' or '''||proute||''' is null) 
        and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
        and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
        and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
        and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
        and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
        and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
        and m.city_code=c.city_code
        and e.main_edtn=nvl('''||pmainedtn||''',e.main_edtn)
        and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
        and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
        group by d.comp_code,d.unit_code,d.publ,d.edtn,m.exectuive_code 
        order by d.comp_code,d.unit_code,d.publ,d.edtn,executive_code';

        insert into test1(vstring) values ('3'||vquery2);commit;
        open p_accounts2 for vquery2;        
end if;


        vquery3:=' select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,cir_get_publ_name(d.comp_code,d.publ) publ_name,d.edtn, '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='''||pcomp_code||''' and m.unit=d.unit_code and d.unit_code='||''''||punit_code||''''||' and d.publ=e.publ and d.publ=p.publ and d.publ=nvl('''||ppubl||''',d.publ) 
        and d.edtn=e.edtn and d.edtn=nvl('''||pedtn||''',d.edtn) 
        and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
        and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
        and (d.route_code='''||proute||''' or '''||proute||''' is null) 
        and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
        and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
        and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
        and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
        and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
        and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
        and m.city_code=c.city_code
        and e.main_edtn=nvl('''||pmainedtn||''',e.main_edtn)
        and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
        and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
        group by d.comp_code,d.unit_code,d.publ,d.edtn order by d.comp_code,d.unit_code,d.publ,d.edtn';
        
        insert into test1(vstring) values ('2'||vquery3);commit;
        open p_accounts3 for vquery3;
        
        vquery4:=' select d.comp_code comp_code,d.unit_code unit_code,d.publ publ, '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='''||pcomp_code||''' and m.unit=d.unit_code and d.unit_code='||''''||punit_code||''''||' and d.publ=e.publ and d.publ=p.publ and d.publ=nvl('''||ppubl||''',d.publ) 
        and d.edtn=e.edtn and d.edtn=nvl('''||pedtn||''',d.edtn) 
        and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
        and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
        and (d.route_code='''||proute||''' or '''||proute||''' is null) 
        and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
        and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
        and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
        and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
        and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
        and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
        and m.city_code=c.city_code
        and e.main_edtn=nvl('''||pmainedtn||''',e.main_edtn)
        and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
        and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
        group by d.comp_code,d.unit_code,d.publ,d.edtn order by d.comp_code,d.unit_code,d.publ';
        
        insert into test1(vstring) values ('4'||vquery4);commit;
        open p_accounts4 for vquery4;
        
        vquery1:=' select d.comp_code comp_code,d.unit_code unit_code, '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.comp_code='''||pcomp_code||''' and m.unit=d.unit_code and d.unit_code='||''''||punit_code||''''||' and d.publ=e.publ and d.publ=p.publ and d.publ=nvl('''||ppubl||''',d.publ) 
        and d.edtn=e.edtn and d.edtn=nvl('''||pedtn||''',d.edtn) 
        and m.agcd=d.agcd and m.dpcd=d.dpcd and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
        and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
        and (d.route_code='''||proute||''' or '''||proute||''' is null) 
        and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
        and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
        and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
        and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
        and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
        and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
        and m.city_code=c.city_code
        and e.main_edtn=nvl('''||pmainedtn||''',e.main_edtn)
        and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
        and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
        group by d.comp_code,d.unit_code,d.publ,d.edtn 
        order by d.comp_code,d.unit_code';
        
        insert into test1(vstring) values ('5'||vquery1);commit;
     open p_accounts1 for vquery1;
End cir_rep_supply1;

  
procedure cir_rep_supply_po(
     pcomp_code     in varchar2,
     punit_code     in varchar2,
     ppubl          in varchar2,
     pedtn          in varchar2,
     psupdate       in varchar2,
     pdateformat    in varchar2,
     pextra1        in varchar2,--finalize and unfinalize
     pextra2        in varchar2,--supply flag final and unfinal y/n
     pextra3        in varchar2,
     p_accounts     out t_accounts,
     p_accounts1    out t_accounts) as
     /*cursor cur_sup_type is
         /*select distinct 'sum(decode(d.sup_type_code,'||''''||sup_ty_code||''''||',d.sup_copy,0)) "'||sup_ty_name||'",' vty,
             'sum(decode(d.sup_type_code,'||''''||sup_ty_code||''''||',d.sup_copy,0)) +' vty_sum
             from cir_supply_type_mast s,cir_dbksup d
             where s.comp_code=d.comp_code and s.comp_code=pcomp_code and d.sup_type_code=s.sup_ty_code and
             d.unit_code=punit_code and (d.publ=ppubl or ppubl is null) and
             d.supdate=to_date(psupdate,''''||pdateformat||'''') order by sup_seq_no;*/
         /*select distinct s.sup_ty_code vty,s.sup_ty_name vty_name,s.sup_seq_no sup_seq_no
             from cir_supply_type_mast s,cir_dbksup d
             where s.comp_code=d.comp_code and s.comp_code=pcomp_code and d.sup_type_code=s.sup_ty_code and
             d.unit_code=punit_code and (d.publ=ppubl or ppubl is null) and
             d.supdate=to_date(psupdate,''''||pdateformat||'''') order by s.sup_seq_no;
     rec_sup_type cur_sup_type%rowtype;
     vvar       varchar2(4000);
     vvar1      varchar2(4000);
     vvar_sum   varchar2(4000);
     vquery     varchar2(4000);
     vquery1    varchar2(4000);
  Begin
    delete from test1;
    open cur_sup_type;
    loop
        fetch cur_sup_type into rec_sup_type;
        exit when cur_sup_type%notfound;
        if vvar is null then
            vvar    :=' case when d.sup_type_code='||''''||rec_sup_type.vty||''''||' then d.sup_copy else 0 end '||'"'||rec_sup_type.vty_name||'"';
            vvar1   :='sum("'||rec_sup_type.vty_name||'")'||' as "'||rec_sup_type.vty_name||'"';
            vvar_sum:=' sum('||'"'||rec_sup_type.vty_name||'"';
        else
            vvar    :=vvar||','||' case when d.sup_type_code='||''''||rec_sup_type.vty||''''||' then d.sup_copy else 0 end '||'"'||rec_sup_type.vty_name||'"';
            vvar1   :=vvar1||','||'sum("'||rec_sup_type.vty_name||'")'||' as "'||rec_sup_type.vty_name||'"';
            vvar_sum:=vvar_sum||'+'||'"'||rec_sup_type.vty_name||'"';
        end if;
    end loop;
    close cur_sup_type;
    --vvar    :=substr(vvar,1,length(vvar)-1);
    --vvar_sum:=substr(vvar_sum,1,length(vvar_sum)-1);
    vvar_sum:=vvar_sum||') '||' as "TOTAL"';
    --insert into test1(vstring,vstring2) values ('PO Report ',vvar1||','||vvar_sum);commit;
    vquery:= 'select x.comp_code comp_code,x.unit_code unit_code,x.publ publ,x.publ_name publ_name,x.edtn edtn,
            x.edtn_name "EDITION NAME",x.supdate supdate,'||vvar1||','||vvar_sum||',x.mainedtn_name mainedtn_name,
            x.edtn_seqno edtn_seqno,x.main_edtn_seqno main_edtn_seqno FROM
            (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,cir_get_publ_name(d.comp_code,d.publ) publ_name,d.edtn edtn,
            cir_get_edtn_name(d.comp_code,d.edtn) edtn_name,to_char(d.supdate'||','||''''||pdateformat||''''||') supdate, '||vvar||',
            cir_get_edtn_name(d.comp_code,e.main_edtn) mainedtn_name,
            cir_get_edtn_seqno(d.comp_code,d.edtn) edtn_seqno,cir_get_edtn_seqno(d.comp_code,e.main_edtn) main_edtn_seqno
            from cir_dbksup d,cir_edtn_mast e
            where d.comp_code='||''''||pcomp_code||''''||' and d.comp_code=e.comp_code and d.unit_code='||''''||punit_code||''''||' and d.unit_code=e.unit_code and
            ((d.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and d.publ=e.publ and
            d.supdate='|| 'to_date('||''''||psupdate||''''||','||''''||pdateformat||''''||') and d.edtn=e.edtn) x
            group by x.comp_code,x.unit_code ,x.publ,x.publ_name,x.edtn,
            x.edtn_name ,x.supdate,x.mainedtn_name,x.edtn_seqno,x.main_edtn_seqno
            order by x.comp_code,x.unit_code,x.publ,main_edtn_seqno,mainedtn_name,edtn_seqno,x.edtn,x.supdate';
        --insert into test1(vstring,vstring2) values ('PO Report vquery',vquery);commit;
    open p_accounts for vquery;
    vquery1:= 'select x.comp_code comp_code,x.unit_code unit_code,x.publ publ,x.publ_name publ_name,'||vvar1||','||vvar_sum||' FROM
            (select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,cir_get_publ_name(d.comp_code,d.publ) publ_name,d.edtn edtn,
            cir_get_edtn_name(d.comp_code,d.edtn) edtn_name,to_char(d.supdate'||','||''''||pdateformat||''''||') supdate, '||vvar||',
            cir_get_edtn_name(d.comp_code,e.main_edtn) mainedtn_name,
            cir_get_edtn_seqno(d.comp_code,d.edtn) edtn_seqno,cir_get_edtn_seqno(d.comp_code,e.main_edtn) main_edtn_seqno
            from cir_dbksup d,cir_edtn_mast e
            where d.comp_code='||''''||pcomp_code||''''||' and d.comp_code=e.comp_code and d.unit_code='||''''||punit_code||''''||' and d.unit_code=e.unit_code and
            ((d.publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and d.publ=e.publ and
            d.supdate='|| 'to_date('||''''||psupdate||''''||','||''''||pdateformat||''''||') and d.edtn=e.edtn) x
            group by x.comp_code,x.unit_code ,x.publ,x.publ_name
            order by x.comp_code,x.unit_code,x.publ,x.publ_name';
        --insert into test1(vstring,vstring2) values ('PO Report vquery1',vquery1);commit;
    open p_accounts1 for vquery1;*/
v_date             date;
     cursor cur_sup_type is
        select distinct 'sum(decode(d.agname,'||''''||agname||''''||',d.supply_copy,0)) "'||agname||'",' vty,
            'sum(decode(d.agname,'||''''||agname||''''||',d.supply_copy,0)) +' vty_sum,rec_amt sup_seq_no,agname supply_type_name
            from cir_temp_bill_collection
            where cur_sessionid=userenv('sessionid') 
        order by rec_amt,agname;
     rec_sup_type cur_sup_type%rowtype;
    cursor cur_dbk is
            select x.comp_code comp_code,x.unit_code unit_code,x.supdate supdate,x.publ_name publ_name,x.mainedtn_name mainedtn_name,
            x.main_edtn_seqno main_edtn_seqno,x.edtn_name||to_char(x.sup_rate,'990.99') edtn_name,x.edtn_seqno edtn_seqno,x.sup_ty_name sup_ty_name,
            x.sup_seqno sup_seqno,x.sup_rate sup_rate,x.supply_copy supply_copy,x.supl_name supl_name,x.pgno pgno from
            (select d.comp_code comp_code,d.unit_code unit_code,d.supdate supdate,p.publ_name publ_name,cir_get_edtn_name(d.comp_code,e.main_edtn) mainedtn_name,
            cir_get_edtn_seqno(d.comp_code,e.main_edtn) main_edtn_seqno,
            e.edtn edtn,e.edtn_name edtn_name,e.edtn_seq_no edtn_seqno,t.sup_ty_name sup_ty_name,t.sup_seq_no sup_seqno,d.sup_rate sup_rate, sum(d.sup_copy) supply_copy,
            cir_get_edtn_supl(d.comp_code,d.unit_code,e.edtn,d.supdate,pdateformat,1,null,null,null,null,null) supl_name,
            case when to_char(d.supdate,'DY')='SUN' then min(nvl(e.main_issue_pgno_sun,0)+nvl(e.pullout_pgno_sun,0))
                when to_char(d.supdate,'DY')='MON' then min(nvl(e.main_issue_pgno_mon,0)+nvl(e.pullout_pgno_mon,0))
                when to_char(d.supdate,'DY')='TUE' then min(nvl(e.main_issue_pgno_tue,0)+nvl(e.pullout_pgno_tue,0))
                when to_char(d.supdate,'DY')='WED' then min(nvl(e.main_issue_pgno_wed,0)+nvl(e.pullout_pgno_wed,0))
                when to_char(d.supdate,'DY')='THU' then min(nvl(e.main_issue_pgno_thu,0)+nvl(e.pullout_pgno_thu,0))
                when to_char(d.supdate,'DY')='FRI' then min(nvl(e.main_issue_pgno_fri,0)+nvl(e.pullout_pgno_fri,0)) else min(nvl(e.main_issue_pgno_sat,0)+nvl(e.pullout_pgno_sat,0)) end pgno
            from cir_dbksup d,cir_edtn_mast e,cir_publ_mast p,cir_supply_type_mast t
            where d.comp_code=e.comp_code and d.comp_code=p.comp_code 
            and d.comp_code=t.comp_code and d.comp_code=pcomp_code and
            d.unit_code=e.unit_code and d.unit_code=nvl(punit_code,d.unit_code) and d.publ=p.publ 
            and d.publ=e.publ and d.publ=nvl(ppubl,d.publ) and 
            d.edtn=e.edtn 
            and d.supdate =v_date and d.sup_type_code=t.sup_ty_code 
            and upper(pextra1)!='U' and (d.final_supply_flag=pextra2 or pextra2 is null)
            group by d.comp_code,d.unit_code,d.supdate,p.publ_name,e.main_edtn,
            e.edtn,e.edtn_name,e.edtn_seq_no,t.sup_ty_name,t.sup_seq_no,d.sup_rate
            union
            select d.comp_code comp_code,d.unit unit_code,v_date supdate,p.publ_name publ_name,cir_get_edtn_name(d.comp_code,e.main_edtn) mainedtn_name,
            cir_get_edtn_seqno(d.comp_code,e.main_edtn) main_edtn_seqno,
            e.edtn edtn,e.edtn_name edtn_name,e.edtn_seq_no edtn_seqno,t.sup_ty_name sup_ty_name,t.sup_seq_no sup_seqno,
            cir_get_edtn_rate(d.comp_code,d.unit,e.edtn,to_char(v_date,'dd/mm/yyyy'),'dd/mm/yyyy') sup_rate, 
            case when to_char(v_date,'DY')='SUN' then sum(nvl(d.base_supply,0)+nvl(d.supply_sun,0))
                 when to_char(v_date,'DY')='MON' then sum(nvl(d.base_supply,0)+nvl(d.supply_mon,0))
                 when to_char(v_date,'DY')='TUE' then sum(nvl(d.base_supply,0)+nvl(d.supply_tue,0))
                 when to_char(v_date,'DY')='WED' then sum(nvl(d.base_supply,0)+nvl(d.supply_wed,0))
                 when to_char(v_date,'DY')='THU' then sum(nvl(d.base_supply,0)+nvl(d.supply_thu,0))
                 when to_char(v_date,'DY')='FRI' then sum(nvl(d.base_supply,0)+nvl(d.supply_fri,0))
            else sum(nvl(d.base_supply,0)+nvl(d.supply_sat,0)) end supply_copy,
            cir_get_edtn_supl(d.comp_code,d.unit,e.edtn,v_date,pdateformat,1,null,null,null,null,null) supl_name,
            case when to_char(v_date,'DY')='SUN' then min(nvl(e.main_issue_pgno_sun,0)+nvl(e.pullout_pgno_sun,0))
                when to_char(v_date,'DY')='MON' then min(nvl(e.main_issue_pgno_mon,0)+nvl(e.pullout_pgno_mon,0))
                when to_char(v_date,'DY')='TUE' then min(nvl(e.main_issue_pgno_tue,0)+nvl(e.pullout_pgno_tue,0))
                when to_char(v_date,'DY')='WED' then min(nvl(e.main_issue_pgno_wed,0)+nvl(e.pullout_pgno_wed,0))
                when to_char(v_date,'DY')='THU' then min(nvl(e.main_issue_pgno_thu,0)+nvl(e.pullout_pgno_thu,0))
                when to_char(v_date,'DY')='FRI' then min(nvl(e.main_issue_pgno_fri,0)+nvl(e.pullout_pgno_fri,0)) else min(nvl(e.main_issue_pgno_sat,0)+nvl(e.pullout_pgno_sat,0)) end pgno
            from cir_supply d,cir_edtn_mast e,cir_publ_mast p,cir_supply_type_mast t
            where d.comp_code=e.comp_code and d.comp_code=p.comp_code and d.comp_code=t.comp_code and d.comp_code=pcomp_code and
            d.unit=e.unit_code and d.unit=nvl(punit_code,d.unit) and d.publ=p.publ and d.publ=e.publ and d.publ=nvl(ppubl,d.publ) and 
            d.edtn=e.edtn and d.supply_flag='Y' and d.supply_type_code=t.sup_ty_code and upper(pextra1)='U'
            group by d.comp_code,d.unit,p.publ_name,e.main_edtn,e.edtn,e.edtn_name,e.edtn_seq_no,t.sup_ty_name,t.sup_seq_no) x
            order by comp_code,unit_code,supdate,publ_name,main_edtn_seqno,mainedtn_name,edtn_seqno,edtn_name,sup_seqno,sup_ty_name;
        rec_dbk cur_dbk%rowtype;
        cursor cur_main_edtn is
            select comp_code,unit_code,agcd,dpcd
            from cir_ledger_report where sess_id=userenv('sessionid') and remarks is null
            group by comp_code,unit_code,agcd,dpcd
            order by comp_code,unit_code,agcd,dpcd;
        rec_main_edtn cur_main_edtn%rowtype;                                    
        cursor cur_supl is
            select chq_bank,sum(rec_seqno) sup_copy
            from cir_ledger_report where sess_id=userenv('sessionid') and comp_code=rec_main_edtn.comp_code and 
            unit_code=rec_main_edtn.unit_code and agcd=rec_main_edtn.agcd and dpcd=rec_main_edtn.dpcd and
            remarks is null
            group by chq_bank
            order by chq_bank;
        rec_supl cur_supl%rowtype;        
    vvar        varchar2(4000);
    vvar_sum    varchar2(4000);
    vquery      varchar2(8000);
    v_count     number(5);
    vlength     number(7);
    vrunval     varchar2(8000);
    v_val       varchar2(800);
    v_name      varchar2(8000);
    vno         number:=0;
    v_remarks   varchar2(500);
  Begin
    if upper(pextra1)='U' then  
        v_date:=to_date(trunc(sysdate),''''||pdateformat||'''');
    else
        v_date:=to_date(psupdate,''''||pdateformat||'''');
    end if;    
    delete from cir_temp_bill_collection where cur_sessionid=userenv('sessionid');
    delete from cir_ledger_report where sess_id=userenv('sessionid');commit;
    --delete from test1;commit;
    open cur_dbk;
    loop
        fetch cur_dbk into rec_dbk;
        exit when cur_dbk%notfound;
        v_count:=nvl(v_count,0)+1;
        if rec_dbk.pgno=0 then
            rec_dbk.pgno:=null;
        end if;
        vlength :=null; v_val :=null; vrunval :=null; vno:=null;
        v_val   :=replace(rec_dbk.supl_name||'+','+',',');
        vlength :=length(v_val);
        vno:=1;
        for i in 1.. vlength loop
        vrunval:=substr(v_val,i,1);
        if vrunval!=',' then
            v_name:=v_name||vrunval;
        else
            insert into cir_ledger_report(comp_code, unit_code, recptdt,agcd, dpcd, recptno, chq_bank, rec_seqno,sess_id)
                    values (rec_dbk.comp_code,rec_dbk.unit_code,v_date,rec_dbk.publ_name,rec_dbk.mainedtn_name,rec_dbk.edtn_name,v_name,rec_dbk.supply_copy,userenv('sessionid'));
            vno:=vno+1;
            v_name:='';
        end if;
        end loop;
        insert into cir_temp_bill_collection
        (comp_code, unit_code, billdt, publ_code, agcd, dpcd, supply_copy, gross_amt, 
        cur_sessionid, agname,return_copy,remarks,dn_amt,cn_amt,rec_amt)
        values
        (rec_dbk.comp_code,rec_dbk.unit_code,v_date,rec_dbk.publ_name,rec_dbk.mainedtn_name,rec_dbk.edtn_name,rec_dbk.supply_copy,rec_dbk.sup_rate,
        userenv('sessionid'),rec_dbk.sup_ty_name,rec_dbk.pgno,rec_dbk.supl_name,rec_dbk.main_edtn_seqno,rec_dbk.edtn_seqno,rec_dbk.sup_seqno);
    end loop;
    close cur_dbk;
    open cur_main_edtn;
    loop
        fetch cur_main_edtn into rec_main_edtn;
        exit when cur_main_edtn%notfound;
        open cur_supl;
        loop
            fetch cur_supl into rec_supl;
            exit when cur_supl%notfound;
            if v_remarks is null then
                v_remarks:=rec_supl.chq_bank||' # '||rec_supl.sup_copy;
            else
                v_remarks:=v_remarks||','||rec_supl.chq_bank||' # '||rec_supl.sup_copy;
            end if;
            if rec_supl.chq_bank is null then
                v_remarks:=null;
            end if;             
        end loop;
        close cur_supl;
        insert into cir_ledger_report(comp_code, unit_code, recptdt,agcd, dpcd, remarks,sess_id)
                values (rec_main_edtn.comp_code,rec_main_edtn.unit_code,v_date,rec_main_edtn.agcd,rec_main_edtn.dpcd,v_remarks,userenv('sessionid'));        
       v_remarks:=null;
    end loop;
    close cur_main_edtn;    
    delete from cir_ledger_report where sess_id=userenv('sessionid') and remarks is null;
    delete from test1;commit;
    open cur_sup_type;
    loop
        fetch cur_sup_type into rec_sup_type;
        exit when cur_sup_type%notfound;
        if vvar is null then
            vvar       :='case when d.agname='||''''||rec_sup_type.supply_type_name||''''||' then d.supply_copy else 0 end "'||rec_sup_type.supply_type_name||'"';
            vvar_sum   :='sum("'||rec_sup_type.supply_type_name||'")'||' "'||rec_sup_type.supply_type_name||'"';
        else
            vvar       :=vvar||','||'case when d.agname='||''''||rec_sup_type.supply_type_name||''''||' then d.supply_copy else 0 end "'||rec_sup_type.supply_type_name||'"';
            vvar_sum   :=vvar_sum||','||'sum("'||rec_sup_type.supply_type_name||'")'||' "'||rec_sup_type.supply_type_name||'"';
        end if;            
    end loop;
    close cur_sup_type;
    --insert into test1(vstring) values (pextra1||' '||vquery);
    if vvar is null then            
        vquery:=' select x.comp_code comp_code,x.unit_code unit_code,x.publ publ,x.publ_name publ_name,x.edtn edtn,x.edtn_name "EDITION NAME",
                x.supdate supdate, sum(x.supply_copy) TOTAL,x.mainedtn_name mainedtn_name,x.supl_name supl_name,x.main_seqno main_seqno,x.edtn_seqno edtn_seqno,x.return_copy page_no,x.supl_detail supl_detail
                from
                (select d.comp_code comp_code,d.unit_code unit_code,d.publ_code publ,d.publ_code publ_name,d.dpcd edtn,d.dpcd edtn_name,
                to_char(d.billdt'||','||''''||pdateformat||''''||') supdate,d.agcd mainedtn_name,d.remarks supl_name,d.dn_amt main_seqno,d.cn_amt edtn_seqno,d.supply_copy supply_copy,
                (select remarks from cir_ledger_report where sess_id=userenv(''sessionid'') and remarks is not null and comp_code=d.comp_code and unit_code=d.unit_code and agcd=d.publ_code and dpcd=d.agcd and recptdt=d.billdt) supl_detail,d.RETURN_COPY return_copy from cir_temp_bill_collection d
                where d.cur_sessionid=userenv(''sessionid'')) x  group by x.comp_code,x.unit_code,x.publ,x.publ_name,x.edtn,x.edtn_name,x.supdate,x.mainedtn_name,x.supl_name,x.main_seqno,x.edtn_seqno,x.return_copy,x.supl_detail
                order by comp_code,unit_code,publ_name,main_seqno,edtn_seqno';                
    else
        vquery:=' select x.comp_code comp_code,x.unit_code unit_code,x.publ publ,x.publ_name publ_name,x.edtn edtn,x.edtn_name "EDITION NAME",
                x.supdate supdate,'||vvar_sum||', sum(x.supply_copy) TOTAL,x.mainedtn_name mainedtn_name,x.supl_name supl_name,x.main_seqno main_seqno,x.edtn_seqno edtn_seqno,x.return_copy page_no,x.supl_detail supl_detail
                from
                (select d.comp_code comp_code,d.unit_code unit_code,d.publ_code publ,d.publ_code publ_name,d.dpcd edtn,d.dpcd edtn_name,
                to_char(d.billdt'||','||''''||pdateformat||''''||') supdate,'||vvar||',d.agcd mainedtn_name,d.remarks supl_name,d.dn_amt main_seqno,d.cn_amt edtn_seqno,d.supply_copy supply_copy,
                (select remarks from cir_ledger_report where sess_id=userenv(''sessionid'') and remarks is not null and comp_code=d.comp_code and unit_code=d.unit_code and agcd=d.publ_code and dpcd=d.agcd and recptdt=d.billdt) supl_detail,d.RETURN_COPY return_copy from cir_temp_bill_collection d
                where d.cur_sessionid=userenv(''sessionid'')) x  group by x.comp_code,x.unit_code,x.publ,x.publ_name,x.edtn,x.edtn_name,x.supdate,x.mainedtn_name,x.supl_name,x.main_seqno,x.edtn_seqno,x.return_copy,x.supl_detail
                order by comp_code,unit_code,publ_name,main_seqno,edtn_seqno';
    end if;                    
    --insert into test1(vstring) values ('1 pextra1 '||vquery);commit;
    open p_accounts for vquery;
    if vvar is null then
        vquery:=' select x.comp_code comp_code,x.unit_code unit_code,x.publ publ,x.publ_name publ_name,
                 sum(x.supply_copy) TOTAL from
                (select d.comp_code comp_code,d.unit_code unit_code,d.publ_code publ,d.publ_code publ_name,d.dpcd edtn,d.dpcd edtn_name,
                to_char(d.billdt'||','||''''||pdateformat||''''||') supdate,d.agcd mainedtn_name,d.remarks supl_name,d.dn_amt main_seqno,d.cn_amt edtn_seqno,d.supply_copy supply_copy from cir_temp_bill_collection d
                where d.cur_sessionid=userenv(''sessionid'')) x group by x.comp_code,x.unit_code,x.publ,x.publ_name
                order by comp_code,unit_code,publ_name';                
    else
        vquery:=' select x.comp_code comp_code,x.unit_code unit_code,x.publ publ,x.publ_name publ_name,
                '||vvar_sum||', sum(x.supply_copy) TOTAL from
                (select d.comp_code comp_code,d.unit_code unit_code,d.publ_code publ,d.publ_code publ_name,d.dpcd edtn,d.dpcd edtn_name,
                to_char(d.billdt'||','||''''||pdateformat||''''||') supdate,'||vvar||',d.agcd mainedtn_name,d.remarks supl_name,d.dn_amt main_seqno,d.cn_amt edtn_seqno,d.supply_copy supply_copy from cir_temp_bill_collection d
                where d.cur_sessionid=userenv(''sessionid'')) x group by x.comp_code,x.unit_code,x.publ,x.publ_name
                order by comp_code,unit_code,publ_name';    
    end if;
    insert into test1(vstring) values ('2 pextra1 '||vquery);commit;
    --delete from cir_temp_bill_collection where cur_sessionid=userenv('sessionid');
    --delete from cir_ledger_report where sess_id=userenv('sessionid');commit;
    open p_accounts1 for vquery;    
  End cir_rep_supply_po;

  procedure cir_rep_daybook(
     pcomp_code     in varchar2,
     punit_code     in varchar2,
     ppubl          in varchar2,
     pedtn          in varchar2,
     pcitycd        in varchar2,
     pstatecd       in varchar2,
     pmonth         in varchar2,
     pyear          in number,
     pdateformat    in varchar2,
     pbranch        in varchar2,
     pdistcode      in varchar2,
     ptaluka        in varchar2,
     pagtype        in varchar2,
     pagclass       in varchar2,
     pagcode        in varchar2,
     pdpcode        in varchar2,
     pextra1        in varchar2,--it is used for supply type
     pextra2        in varchar2,
     pextra3        in varchar2,
     pextra4        in varchar2,
     pextra5        in varchar2,
     p_accounts     out t_accounts,
     p_accounts1    out t_accounts,
     p_accounts2    out t_accounts)
    As
     vfrdt          date;
     vtodt          date;
   Begin
       vfrdt:=to_date('01/'||pmonth||'/'||pyear,pdateformat);
       vtodt:=last_day(vfrdt);
       open p_accounts for
       SELECT COMP_CODE,UNIT_CODE,AGCD "AGENCY CODE",DPCD "AGENCY SUBCODE",substr(cir_get_agency(comp_code,unit_code,agcd,dpcd),1,50) "AGENCY NAME",
       substr(cir_get_name.cir_agname(comp_code,unit_code,agcd,dpcd,2,pdateformat,'',''),1,50) "AGENCY ONAME",
       EDTN,CIR_GET_EDTN_NAME(COMP_CODE,EDTN) "EDITION NAME",nvl(CIR_GET_NAME.CIR_EDTN(COMP_CODE,'',EDTN,2,pdateformat,'',''),'NA') "EDITION ONAME",
       nvl(CITY_CODE,'NA') "CITY CODE",nvl(CIR_GET_CITY(COMP_CODE,CITY_CODE),'NA') "CITY NAME",
       nvl(CIR_GET_NAME.CIR_CITY(COMP_CODE,CITY_CODE,2,pdateformat,'',''),'NA') "CITY ONAME",
       nvl(STATE_CODE,'NA') "STATE CODE",nvl(CIR_GET_STATE(COMP_CODE,COUNTRY_CODE,STATE_CODE),'NA') "STATE NAME",COUNTRY_CODE,SUM(p01) AS "01",SUM(p02) AS "02",SUM(p03) AS "03",SUM(p04) AS "04",SUM(p05) AS "05",
        SUM(p06) AS "06",SUM(p07) AS "07",SUM(p08) AS "08",SUM(p09) AS "09",SUM(p10) AS "10",
        SUM(p11) AS "11",SUM(p12) AS "12",SUM(p13) AS "13",SUM(p14) AS "14",SUM(p15) AS "15",
        SUM(p16) AS "16",SUM(p17) AS "17",SUM(p18) AS "18",SUM(p19) AS "19",SUM(p20) AS "20",
        SUM(p21) AS "21",SUM(p22) AS "22",SUM(p23) AS "23",SUM(p24) AS "24",SUM(p25) AS "25",
        SUM(p26) AS "26",SUM(p27) AS "27",SUM(p28) AS "28",SUM(p29) AS "29",SUM(p30) AS "30",SUM(p31) AS "31",
        SUM(nvl(p01,0)+nvl(p02,0)+nvl(p03,0)+nvl(p04,0)+nvl(p05,0)+nvl(p06,0)+nvl(p07,0)+nvl(p08,0)+nvl(p09,0)+nvl(p10,0)+
            nvl(p11,0)+nvl(p12,0)+nvl(p13,0)+nvl(p14,0)+nvl(p15,0)+nvl(p16,0)+nvl(p17,0)+nvl(p18,0)+nvl(p19,0)+nvl(p20,0)+
            nvl(p21,0)+nvl(p22,0)+nvl(p23,0)+nvl(p24,0)+nvl(p25,0)+nvl(p26,0)+nvl(p27,0)+nvl(p28,0)+nvl(p29,0)+nvl(p30,0)+nvl(p31,0)) AS "TOTAL"
        FROM (SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,MIN(A.EDTN) EDTN,B.CITY_CODE,B.STATE_CODE STATE_CODE,B.COUNTRY_CODE COUNTRY_CODE,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'01',SUM(nvl(A.SUP_COPY,0))) p01,DECODE(TO_CHAR(A.SUPDATE,'DD'),'02',SUM(nvl(A.SUP_COPY,0))) p02,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'03',SUM(nvl(A.SUP_COPY,0))) p03, DECODE(TO_CHAR(A.SUPDATE,'DD'),'04',SUM(nvl(A.SUP_COPY,0))) p04,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'05',SUM(nvl(A.SUP_COPY,0))) p05, DECODE(TO_CHAR(A.SUPDATE,'DD'),'06',SUM(nvl(A.SUP_COPY,0))) p06,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'07',SUM(nvl(A.SUP_COPY,0))) p07, DECODE(TO_CHAR(A.SUPDATE,'DD'),'08',SUM(nvl(A.SUP_COPY,0))) p08,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'09',SUM(nvl(A.SUP_COPY,0))) p09, DECODE(TO_CHAR(A.SUPDATE,'DD'),'10',SUM(nvl(A.SUP_COPY,0))) p10,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'11',SUM(nvl(A.SUP_COPY,0))) p11, DECODE(TO_CHAR(A.SUPDATE,'DD'),'12',SUM(nvl(A.SUP_COPY,0))) p12,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'13',SUM(nvl(A.SUP_COPY,0))) p13, DECODE(TO_CHAR(A.SUPDATE,'DD'),'14',SUM(nvl(A.SUP_COPY,0))) p14,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'15',SUM(nvl(A.SUP_COPY,0))) p15, DECODE(TO_CHAR(A.SUPDATE,'DD'),'16',SUM(nvl(A.SUP_COPY,0))) p16,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'17',SUM(nvl(A.SUP_COPY,0))) p17, DECODE(TO_CHAR(A.SUPDATE,'DD'),'18',SUM(nvl(A.SUP_COPY,0))) p18,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'19',SUM(nvl(A.SUP_COPY,0))) p19, DECODE(TO_CHAR(A.SUPDATE,'DD'),'20',SUM(nvl(A.SUP_COPY,0))) p20,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'21',SUM(nvl(A.SUP_COPY,0))) p21, DECODE(TO_CHAR(A.SUPDATE,'DD'),'22',SUM(nvl(A.SUP_COPY,0))) p22,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'23',SUM(nvl(A.SUP_COPY,0))) p23, DECODE(TO_CHAR(A.SUPDATE,'DD'),'24',SUM(nvl(A.SUP_COPY,0))) p24,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'25',SUM(nvl(A.SUP_COPY,0))) p25, DECODE(TO_CHAR(A.SUPDATE,'DD'),'26',SUM(nvl(A.SUP_COPY,0))) p26,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'27',SUM(nvl(A.SUP_COPY,0))) p27, DECODE(TO_CHAR(A.SUPDATE,'DD'),'28',SUM(nvl(A.SUP_COPY,0))) p28,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'29',SUM(nvl(A.SUP_COPY,0))) p29, DECODE(TO_CHAR(A.SUPDATE,'DD'),'30',SUM(nvl(A.SUP_COPY,0))) p30,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'31',SUM(nvl(A.SUP_COPY,0))) p31
        FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=PCOMP_CODE AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=PUNIT_CODE AND
        A.AGCD=B.AGCD AND A.AGCD=NVL(PAGCODE,A.AGCD) AND A.DPCD=B.DPCD AND A.DPCD=B.DPCD AND  A.DPCD=NVL(PDPCODE,A.DPCD) AND
        A.PUBL=PPUBL AND A.EDTN=NVL(PEDTN,A.EDTN) AND (B.CITY_CODE=PCITYCD OR PCITYCD IS NULL) AND
        (B.STATE_CODE=PSTATECD OR PSTATECD IS NULL) AND (B.DIST_CODE=PDISTCODE OR PDISTCODE IS NULL) AND (B.TEHSIL_TALUKA=PTALUKA OR PTALUKA IS NULL) AND 
        (B.BRANCH_CODE=PBRANCH OR PBRANCH IS NULL) AND (B.AG_TYPE=PAGTYPE OR PAGTYPE IS NULL) AND (B.AG_CLASS=PAGCLASS OR PAGCLASS IS NULL) AND
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE=PEXTRA1 OR PEXTRA1 IS NULL) AND 
        A.SUPDATE >= VFRDT AND A.SUPDATE <=VTODT AND NVL(A.SUP_COPY,0)>0
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.AGCD,A.DPCD,A.SUPDATE,/*A.EDTN,*/B.CITY_CODE,B.STATE_CODE,B.COUNTRY_CODE)
        GROUP BY COMP_CODE,UNIT_CODE,AGCD,DPCD,EDTN,CITY_CODE,STATE_CODE,COUNTRY_CODE
        ORDER BY COMP_CODE,UNIT_CODE,STATE_CODE,CITY_CODE,EDTN,AGCD,DPCD;
       open p_accounts1 for
       SELECT COMP_CODE,UNIT_CODE,nvl(STATE_CODE,'NA') "STATE CODE",nvl(CIR_GET_STATE(COMP_CODE,COUNTRY_CODE,STATE_CODE),'NA') "STATE NAME",COUNTRY_CODE,
        SUM(p01) AS "01",SUM(p02) AS "02",SUM(p03) AS "03",SUM(p04) AS "04",SUM(p05) AS "05",
        SUM(p06) AS "06",SUM(p07) AS "07",SUM(p08) AS "08",SUM(p09) AS "09",SUM(p10) AS "10",
        SUM(p11) AS "11",SUM(p12) AS "12",SUM(p13) AS "13",SUM(p14) AS "14",SUM(p15) AS "15",
        SUM(p16) AS "16",SUM(p17) AS "17",SUM(p18) AS "18",SUM(p19) AS "19",SUM(p20) AS "20",
        SUM(p21) AS "21",SUM(p22) AS "22",SUM(p23) AS "23",SUM(p24) AS "24",SUM(p25) AS "25",
        SUM(p26) AS "26",SUM(p27) AS "27",SUM(p28) AS "28",SUM(p29) AS "29",SUM(p30) AS "30",SUM(p31) AS "31",
        SUM(nvl(p01,0)+nvl(p02,0)+nvl(p03,0)+nvl(p04,0)+nvl(p05,0)+nvl(p06,0)+nvl(p07,0)+nvl(p08,0)+nvl(p09,0)+nvl(p10,0)+
        nvl(p11,0)+nvl(p12,0)+nvl(p13,0)+nvl(p14,0)+nvl(p15,0)+nvl(p16,0)+nvl(p17,0)+nvl(p18,0)+nvl(p19,0)+nvl(p20,0)+
        nvl(p21,0)+nvl(p22,0)+nvl(p23,0)+nvl(p24,0)+nvl(p25,0)+nvl(p26,0)+nvl(p27,0)+nvl(p28,0)+nvl(p29,0)+nvl(p30,0)+nvl(p31,0)) AS "TOTAL"
        FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,B.STATE_CODE STATE_CODE,B.COUNTRY_CODE COUNTRY_CODE,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'01',SUM(nvl(A.SUP_COPY,0))) p01,DECODE(TO_CHAR(A.SUPDATE,'DD'),'02',SUM(nvl(A.SUP_COPY,0))) p02,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'03',SUM(nvl(A.SUP_COPY,0))) p03, DECODE(TO_CHAR(A.SUPDATE,'DD'),'04',SUM(nvl(A.SUP_COPY,0))) p04,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'05',SUM(nvl(A.SUP_COPY,0))) p05, DECODE(TO_CHAR(A.SUPDATE,'DD'),'06',SUM(nvl(A.SUP_COPY,0))) p06,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'07',SUM(nvl(A.SUP_COPY,0))) p07, DECODE(TO_CHAR(A.SUPDATE,'DD'),'08',SUM(nvl(A.SUP_COPY,0))) p08,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'09',SUM(nvl(A.SUP_COPY,0))) p09, DECODE(TO_CHAR(A.SUPDATE,'DD'),'10',SUM(nvl(A.SUP_COPY,0))) p10,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'11',SUM(nvl(A.SUP_COPY,0))) p11, DECODE(TO_CHAR(A.SUPDATE,'DD'),'12',SUM(nvl(A.SUP_COPY,0))) p12,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'13',SUM(nvl(A.SUP_COPY,0))) p13, DECODE(TO_CHAR(A.SUPDATE,'DD'),'14',SUM(nvl(A.SUP_COPY,0))) p14,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'15',SUM(nvl(A.SUP_COPY,0))) p15, DECODE(TO_CHAR(A.SUPDATE,'DD'),'16',SUM(nvl(A.SUP_COPY,0))) p16,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'17',SUM(nvl(A.SUP_COPY,0))) p17, DECODE(TO_CHAR(A.SUPDATE,'DD'),'18',SUM(nvl(A.SUP_COPY,0))) p18,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'19',SUM(nvl(A.SUP_COPY,0))) p19, DECODE(TO_CHAR(A.SUPDATE,'DD'),'20',SUM(nvl(A.SUP_COPY,0))) p20,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'21',SUM(nvl(A.SUP_COPY,0))) p21, DECODE(TO_CHAR(A.SUPDATE,'DD'),'22',SUM(nvl(A.SUP_COPY,0))) p22,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'23',SUM(nvl(A.SUP_COPY,0))) p23, DECODE(TO_CHAR(A.SUPDATE,'DD'),'24',SUM(nvl(A.SUP_COPY,0))) p24,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'25',SUM(nvl(A.SUP_COPY,0))) p25, DECODE(TO_CHAR(A.SUPDATE,'DD'),'26',SUM(nvl(A.SUP_COPY,0))) p26,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'27',SUM(nvl(A.SUP_COPY,0))) p27, DECODE(TO_CHAR(A.SUPDATE,'DD'),'28',SUM(nvl(A.SUP_COPY,0))) p28,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'29',SUM(nvl(A.SUP_COPY,0))) p29, DECODE(TO_CHAR(A.SUPDATE,'DD'),'30',SUM(nvl(A.SUP_COPY,0))) p30,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'31',SUM(nvl(A.SUP_COPY,0))) p31
        FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=PCOMP_CODE AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=PUNIT_CODE AND
        A.AGCD=B.AGCD AND A.AGCD=NVL(PAGCODE,A.AGCD) AND A.DPCD=B.DPCD AND A.DPCD=B.DPCD AND  A.DPCD=NVL(PDPCODE,A.DPCD) AND 
        A.PUBL=PPUBL AND (A.EDTN=PEDTN OR PEDTN IS NULL) AND (B.CITY_CODE=PCITYCD OR PCITYCD IS NULL) AND
        (B.STATE_CODE=PSTATECD OR PSTATECD IS NULL) AND (B.DIST_CODE=PDISTCODE OR PDISTCODE IS NULL) AND (B.TEHSIL_TALUKA=PTALUKA OR PTALUKA IS NULL) AND 
        (B.BRANCH_CODE=PBRANCH OR PBRANCH IS NULL) AND (B.AG_TYPE=PAGTYPE OR PAGTYPE IS NULL) AND (B.AG_CLASS=PAGCLASS OR PAGCLASS IS NULL) AND 
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE=PEXTRA1 OR PEXTRA1 IS NULL) AND A.SUPDATE >= VFRDT AND A.SUPDATE<= VTODT    AND NVL(A.SUP_COPY,0)>0
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE,B.STATE_CODE,B.COUNTRY_CODE)
        GROUP BY COMP_CODE,UNIT_CODE,STATE_CODE,COUNTRY_CODE
        ORDER BY COMP_CODE,UNIT_CODE,STATE_CODE;
       open p_accounts2 for
       SELECT COMP_CODE,UNIT_CODE,SUM(p01) AS "01",SUM(p02) AS "02",SUM(p03) AS "03",SUM(p04) AS "04",SUM(p05) AS "05",
        SUM(p06) AS "06",SUM(p07) AS "07",SUM(p08) AS "08",SUM(p09) AS "09",SUM(p10) AS "10",
        SUM(p11) AS "11",SUM(p12) AS "12",SUM(p13) AS "13",SUM(p14) AS "14",SUM(p15) AS "15",
        SUM(p16) AS "16",SUM(p17) AS "17",SUM(p18) AS "18",SUM(p19) AS "19",SUM(p20) AS "20",
        SUM(p21) AS "21",SUM(p22) AS "22",SUM(p23) AS "23",SUM(p24) AS "24",SUM(p25) AS "25",
        SUM(p26) AS "26",SUM(p27) AS "27",SUM(p28) AS "28",SUM(p29) AS "29",SUM(p30) AS "30",SUM(p31) AS "31",
        SUM(nvl(p01,0)+nvl(p02,0)+nvl(p03,0)+nvl(p04,0)+nvl(p05,0)+nvl(p06,0)+nvl(p07,0)+nvl(p08,0)+nvl(p09,0)+nvl(p10,0)+
        nvl(p11,0)+nvl(p12,0)+nvl(p13,0)+nvl(p14,0)+nvl(p15,0)+nvl(p16,0)+nvl(p17,0)+nvl(p18,0)+nvl(p19,0)+nvl(p20,0)+
        nvl(p21,0)+nvl(p22,0)+nvl(p23,0)+nvl(p24,0)+nvl(p25,0)+nvl(p26,0)+nvl(p27,0)+nvl(p28,0)+nvl(p29,0)+nvl(p30,0)+nvl(p31,0)) AS "TOTAL"
        FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'01',SUM(nvl(A.SUP_COPY,0))) p01,DECODE(TO_CHAR(A.SUPDATE,'DD'),'02',SUM(nvl(A.SUP_COPY,0))) p02,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'03',SUM(nvl(A.SUP_COPY,0))) p03, DECODE(TO_CHAR(A.SUPDATE,'DD'),'04',SUM(nvl(A.SUP_COPY,0))) p04,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'05',SUM(nvl(A.SUP_COPY,0))) p05, DECODE(TO_CHAR(A.SUPDATE,'DD'),'06',SUM(nvl(A.SUP_COPY,0))) p06,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'07',SUM(nvl(A.SUP_COPY,0))) p07, DECODE(TO_CHAR(A.SUPDATE,'DD'),'08',SUM(nvl(A.SUP_COPY,0))) p08,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'09',SUM(nvl(A.SUP_COPY,0))) p09, DECODE(TO_CHAR(A.SUPDATE,'DD'),'10',SUM(nvl(A.SUP_COPY,0))) p10,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'11',SUM(nvl(A.SUP_COPY,0))) p11, DECODE(TO_CHAR(A.SUPDATE,'DD'),'12',SUM(nvl(A.SUP_COPY,0))) p12,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'13',SUM(nvl(A.SUP_COPY,0))) p13, DECODE(TO_CHAR(A.SUPDATE,'DD'),'14',SUM(nvl(A.SUP_COPY,0))) p14,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'15',SUM(nvl(A.SUP_COPY,0))) p15, DECODE(TO_CHAR(A.SUPDATE,'DD'),'16',SUM(nvl(A.SUP_COPY,0))) p16,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'17',SUM(nvl(A.SUP_COPY,0))) p17, DECODE(TO_CHAR(A.SUPDATE,'DD'),'18',SUM(nvl(A.SUP_COPY,0))) p18,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'19',SUM(nvl(A.SUP_COPY,0))) p19, DECODE(TO_CHAR(A.SUPDATE,'DD'),'20',SUM(nvl(A.SUP_COPY,0))) p20,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'21',SUM(nvl(A.SUP_COPY,0))) p21, DECODE(TO_CHAR(A.SUPDATE,'DD'),'22',SUM(nvl(A.SUP_COPY,0))) p22,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'23',SUM(nvl(A.SUP_COPY,0))) p23, DECODE(TO_CHAR(A.SUPDATE,'DD'),'24',SUM(nvl(A.SUP_COPY,0))) p24,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'25',SUM(nvl(A.SUP_COPY,0))) p25, DECODE(TO_CHAR(A.SUPDATE,'DD'),'26',SUM(nvl(A.SUP_COPY,0))) p26,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'27',SUM(nvl(A.SUP_COPY,0))) p27, DECODE(TO_CHAR(A.SUPDATE,'DD'),'28',SUM(nvl(A.SUP_COPY,0))) p28,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'29',SUM(nvl(A.SUP_COPY,0))) p29, DECODE(TO_CHAR(A.SUPDATE,'DD'),'30',SUM(nvl(A.SUP_COPY,0))) p30,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'31',SUM(nvl(A.SUP_COPY,0))) p31
        FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=PCOMP_CODE AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=PUNIT_CODE AND
        A.AGCD=B.AGCD AND A.AGCD=NVL(PAGCODE,A.AGCD) AND A.DPCD=B.DPCD AND A.DPCD=B.DPCD AND  A.DPCD=NVL(PDPCODE,A.DPCD) AND 
        A.PUBL=PPUBL AND (A.EDTN=PEDTN OR PEDTN IS NULL) AND (B.CITY_CODE=PCITYCD OR PCITYCD IS NULL) AND
        (B.STATE_CODE=PSTATECD OR PSTATECD IS NULL) AND (B.DIST_CODE=PDISTCODE OR PDISTCODE IS NULL) AND (B.TEHSIL_TALUKA=PTALUKA OR PTALUKA IS NULL) AND 
        (B.BRANCH_CODE=PBRANCH OR PBRANCH IS NULL) AND (B.AG_TYPE=PAGTYPE OR PAGTYPE IS NULL) AND (B.AG_CLASS=PAGCLASS OR PAGCLASS IS NULL) AND 
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE=PEXTRA1 OR PEXTRA1 IS NULL) AND A.SUPDATE >= VFRDT AND A.SUPDATE<=VTODT    AND NVL(A.SUP_COPY,0)>0
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE)
        GROUP BY COMP_CODE,UNIT_CODE
        ORDER BY COMP_CODE,UNIT_CODE;
  End cir_rep_daybook;
  procedure cir_rep_dist_daybook(
     pcomp_code     in varchar2,
     punit_code     in varchar2,
     ppubl          in varchar2,
     pedtn          in varchar2,
     pcitycd        in varchar2,
     pstatecd       in varchar2,
     pmonth         in varchar2,
     pyear          in number,
     pdateformat    in varchar2,
     pbranch        in varchar2,
     pdistcode      in varchar2,
     ptaluka        in varchar2,
     pagtype        in varchar2,
     pagclass       in varchar2,
     pagcode        in varchar2,
     pdpcode        in varchar2,
     pextra1        in varchar2,--it is used for supply type
     pextra2        in varchar2,
     pextra3        in varchar2,
     pextra4        in varchar2,
     pextra5        in varchar2,
     p_accounts     out t_accounts,
     p_accounts1    out t_accounts,
     p_accounts2    out t_accounts)
    As
     vfrdt            date;
     vtodt            date;
   Begin
       vfrdt:=to_date('01/'||pmonth||'/'||pyear,pdateformat);
       vtodt:=last_day(vfrdt);
       open p_accounts for
       SELECT COMP_CODE,UNIT_CODE,AGCD "AGENCY CODE",DPCD "AGENCY SUBCODE",substr(cir_get_agency(comp_code,unit_code,agcd,dpcd),1,50) "AGENCY NAME",
       substr(cir_get_name.cir_agname(comp_code,unit_code,agcd,dpcd,2,pdateformat,'',''),1,50) "AGENCY ONAME",
       EDTN,CIR_GET_EDTN_NAME(COMP_CODE,EDTN) "EDITION NAME",nvl(CIR_GET_NAME.CIR_EDTN(COMP_CODE,'',EDTN,2,pdateformat,'',''),'NA') "EDITION ONAME",
       nvl(CITY_CODE,'NA') "CITY CODE",nvl(CIR_GET_CITY(COMP_CODE,CITY_CODE),'NA') "CITY NAME",nvl(CIR_GET_NAME.CIR_CITY(COMP_CODE,CITY_CODE,2,pdateformat,'',''),'NA') "CITY ONAME",
       nvl(DIST_CODE,'NA') "DIST CODE",nvl(CIR_GET_DIST(COMP_CODE,STATE_CODE,DIST_CODE),'NA') "DISTRICT NAME",nvl(CIR_GET_NAME.CIR_DISTRICT(COMP_CODE,DIST_CODE,2,pdateformat,'',''),'NA') "DISTRICT ONAME",
       STATE_CODE,SUM(p01) AS "01",SUM(p02) AS "02",SUM(p03) AS "03",SUM(p04) AS "04",SUM(p05) AS "05",
        SUM(p06) AS "06",SUM(p07) AS "07",SUM(p08) AS "08",SUM(p09) AS "09",SUM(p10) AS "10",
        SUM(p11) AS "11",SUM(p12) AS "12",SUM(p13) AS "13",SUM(p14) AS "14",SUM(p15) AS "15",
        SUM(p16) AS "16",SUM(p17) AS "17",SUM(p18) AS "18",SUM(p19) AS "19",SUM(p20) AS "20",
        SUM(p21) AS "21",SUM(p22) AS "22",SUM(p23) AS "23",SUM(p24) AS "24",SUM(p25) AS "25",
        SUM(p26) AS "26",SUM(p27) AS "27",SUM(p28) AS "28",SUM(p29) AS "29",SUM(p30) AS "30",SUM(p31) AS "31",
        SUM(nvl(p01,0)+nvl(p02,0)+nvl(p03,0)+nvl(p04,0)+nvl(p05,0)+nvl(p06,0)+nvl(p07,0)+nvl(p08,0)+nvl(p09,0)+nvl(p10,0)+
            nvl(p11,0)+nvl(p12,0)+nvl(p13,0)+nvl(p14,0)+nvl(p15,0)+nvl(p16,0)+nvl(p17,0)+nvl(p18,0)+nvl(p19,0)+nvl(p20,0)+
        nvl(p21,0)+nvl(p22,0)+nvl(p23,0)+nvl(p24,0)+nvl(p25,0)+nvl(p26,0)+nvl(p27,0)+nvl(p28,0)+nvl(p29,0)+nvl(p30,0)+nvl(p31,0)) AS "TOTAL"
        FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,MIN(A.EDTN) EDTN,B.CITY_CODE,B.DIST_CODE DIST_CODE,B.STATE_CODE STATE_CODE,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'01',SUM(nvl(A.SUP_COPY,0))) p01,DECODE(TO_CHAR(A.SUPDATE,'DD'),'02',SUM(nvl(A.SUP_COPY,0))) p02,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'03',SUM(nvl(A.SUP_COPY,0))) p03, DECODE(TO_CHAR(A.SUPDATE,'DD'),'04',SUM(nvl(A.SUP_COPY,0))) p04,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'05',SUM(nvl(A.SUP_COPY,0))) p05, DECODE(TO_CHAR(A.SUPDATE,'DD'),'06',SUM(nvl(A.SUP_COPY,0))) p06,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'07',SUM(nvl(A.SUP_COPY,0))) p07, DECODE(TO_CHAR(A.SUPDATE,'DD'),'08',SUM(nvl(A.SUP_COPY,0))) p08,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'09',SUM(nvl(A.SUP_COPY,0))) p09, DECODE(TO_CHAR(A.SUPDATE,'DD'),'10',SUM(nvl(A.SUP_COPY,0))) p10,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'11',SUM(nvl(A.SUP_COPY,0))) p11, DECODE(TO_CHAR(A.SUPDATE,'DD'),'12',SUM(nvl(A.SUP_COPY,0))) p12,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'13',SUM(nvl(A.SUP_COPY,0))) p13, DECODE(TO_CHAR(A.SUPDATE,'DD'),'14',SUM(nvl(A.SUP_COPY,0))) p14,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'15',SUM(nvl(A.SUP_COPY,0))) p15, DECODE(TO_CHAR(A.SUPDATE,'DD'),'16',SUM(nvl(A.SUP_COPY,0))) p16,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'17',SUM(nvl(A.SUP_COPY,0))) p17, DECODE(TO_CHAR(A.SUPDATE,'DD'),'18',SUM(nvl(A.SUP_COPY,0))) p18,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'19',SUM(nvl(A.SUP_COPY,0))) p19, DECODE(TO_CHAR(A.SUPDATE,'DD'),'20',SUM(nvl(A.SUP_COPY,0))) p20,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'21',SUM(nvl(A.SUP_COPY,0))) p21, DECODE(TO_CHAR(A.SUPDATE,'DD'),'22',SUM(nvl(A.SUP_COPY,0))) p22,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'23',SUM(nvl(A.SUP_COPY,0))) p23, DECODE(TO_CHAR(A.SUPDATE,'DD'),'24',SUM(nvl(A.SUP_COPY,0))) p24,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'25',SUM(nvl(A.SUP_COPY,0))) p25, DECODE(TO_CHAR(A.SUPDATE,'DD'),'26',SUM(nvl(A.SUP_COPY,0))) p26,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'27',SUM(nvl(A.SUP_COPY,0))) p27, DECODE(TO_CHAR(A.SUPDATE,'DD'),'28',SUM(nvl(A.SUP_COPY,0))) p28,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'29',SUM(nvl(A.SUP_COPY,0))) p29, DECODE(TO_CHAR(A.SUPDATE,'DD'),'30',SUM(nvl(A.SUP_COPY,0))) p30,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'31',SUM(nvl(A.SUP_COPY,0))) p31
        FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=PCOMP_CODE AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=PUNIT_CODE AND
        A.AGCD=B.AGCD AND A.AGCD=NVL(PAGCODE,A.AGCD) AND A.DPCD=B.DPCD AND A.DPCD=B.DPCD AND  A.DPCD=NVL(PDPCODE,A.DPCD) AND 
        A.PUBL=PPUBL AND (A.EDTN=PEDTN OR PEDTN IS NULL) AND (B.CITY_CODE=PCITYCD OR PCITYCD IS NULL) AND
        (B.STATE_CODE=PSTATECD OR PSTATECD IS NULL) AND (B.DIST_CODE=PDISTCODE OR PDISTCODE IS NULL) AND (B.TEHSIL_TALUKA=PTALUKA OR PTALUKA IS NULL) AND 
        (B.BRANCH_CODE=PBRANCH OR PBRANCH IS NULL) AND (B.AG_TYPE=PAGTYPE OR PAGTYPE IS NULL) AND (B.AG_CLASS=PAGCLASS OR PAGCLASS IS NULL) AND 
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE=PEXTRA1 OR PEXTRA1 IS NULL) AND A.SUPDATE >= VFRDT AND A.SUPDATE <= VTODT    AND NVL(A.SUP_COPY,0)>0
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.AGCD,A.DPCD,A.SUPDATE,B.CITY_CODE,B.DIST_CODE,B.STATE_CODE)
        GROUP BY COMP_CODE,UNIT_CODE,AGCD,DPCD,EDTN,CITY_CODE,DIST_CODE,STATE_CODE
        ORDER BY COMP_CODE,UNIT_CODE,STATE_CODE,DIST_CODE,CITY_CODE,EDTN,AGCD,DPCD;
       open p_accounts1 for
       SELECT COMP_CODE,UNIT_CODE,nvl(DIST_CODE,'NA') DIST_CODE,nvl(CIR_GET_DIST(COMP_CODE,STATE_CODE,DIST_CODE),'NA') "DISTRICT NAME",
       nvl(CIR_GET_NAME.CIR_DISTRICT(COMP_CODE,DIST_CODE,2,pdateformat,'',''),'NA') "DISTRICT ONAME",STATE_CODE,
       SUM(p01) AS "01",SUM(p02) AS "02",SUM(p03) AS "03",SUM(p04) AS "04",SUM(p05) AS "05",
        SUM(p06) AS "06",SUM(p07) AS "07",SUM(p08) AS "08",SUM(p09) AS "09",SUM(p10) AS "10",
        SUM(p11) AS "11",SUM(p12) AS "12",SUM(p13) AS "13",SUM(p14) AS "14",SUM(p15) AS "15",
        SUM(p16) AS "16",SUM(p17) AS "17",SUM(p18) AS "18",SUM(p19) AS "19",SUM(p20) AS "20",
        SUM(p21) AS "21",SUM(p22) AS "22",SUM(p23) AS "23",SUM(p24) AS "24",SUM(p25) AS "25",
        SUM(p26) AS "26",SUM(p27) AS "27",SUM(p28) AS "28",SUM(p29) AS "29",SUM(p30) AS "30",SUM(p31) AS "31",
        SUM(nvl(p01,0)+nvl(p02,0)+nvl(p03,0)+nvl(p04,0)+nvl(p05,0)+nvl(p06,0)+nvl(p07,0)+nvl(p08,0)+nvl(p09,0)+nvl(p10,0)+
        nvl(p11,0)+nvl(p12,0)+nvl(p13,0)+nvl(p14,0)+nvl(p15,0)+nvl(p16,0)+nvl(p17,0)+nvl(p18,0)+nvl(p19,0)+nvl(p20,0)+
        nvl(p21,0)+nvl(p22,0)+nvl(p23,0)+nvl(p24,0)+nvl(p25,0)+nvl(p26,0)+nvl(p27,0)+nvl(p28,0)+nvl(p29,0)+nvl(p30,0)+nvl(p31,0)) AS "TOTAL"
        FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,B.DIST_CODE DIST_CODE,B.STATE_CODE STATE_CODE,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'01',SUM(nvl(A.SUP_COPY,0))) p01,DECODE(TO_CHAR(A.SUPDATE,'DD'),'02',SUM(nvl(A.SUP_COPY,0))) p02,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'03',SUM(nvl(A.SUP_COPY,0))) p03, DECODE(TO_CHAR(A.SUPDATE,'DD'),'04',SUM(nvl(A.SUP_COPY,0))) p04,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'05',SUM(nvl(A.SUP_COPY,0))) p05, DECODE(TO_CHAR(A.SUPDATE,'DD'),'06',SUM(nvl(A.SUP_COPY,0))) p06,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'07',SUM(nvl(A.SUP_COPY,0))) p07, DECODE(TO_CHAR(A.SUPDATE,'DD'),'08',SUM(nvl(A.SUP_COPY,0))) p08,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'09',SUM(nvl(A.SUP_COPY,0))) p09, DECODE(TO_CHAR(A.SUPDATE,'DD'),'10',SUM(nvl(A.SUP_COPY,0))) p10,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'11',SUM(nvl(A.SUP_COPY,0))) p11, DECODE(TO_CHAR(A.SUPDATE,'DD'),'12',SUM(nvl(A.SUP_COPY,0))) p12,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'13',SUM(nvl(A.SUP_COPY,0))) p13, DECODE(TO_CHAR(A.SUPDATE,'DD'),'14',SUM(nvl(A.SUP_COPY,0))) p14,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'15',SUM(nvl(A.SUP_COPY,0))) p15, DECODE(TO_CHAR(A.SUPDATE,'DD'),'16',SUM(nvl(A.SUP_COPY,0))) p16,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'17',SUM(nvl(A.SUP_COPY,0))) p17, DECODE(TO_CHAR(A.SUPDATE,'DD'),'18',SUM(nvl(A.SUP_COPY,0))) p18,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'19',SUM(nvl(A.SUP_COPY,0))) p19, DECODE(TO_CHAR(A.SUPDATE,'DD'),'20',SUM(nvl(A.SUP_COPY,0))) p20,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'21',SUM(nvl(A.SUP_COPY,0))) p21, DECODE(TO_CHAR(A.SUPDATE,'DD'),'22',SUM(nvl(A.SUP_COPY,0))) p22,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'23',SUM(nvl(A.SUP_COPY,0))) p23, DECODE(TO_CHAR(A.SUPDATE,'DD'),'24',SUM(nvl(A.SUP_COPY,0))) p24,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'25',SUM(nvl(A.SUP_COPY,0))) p25, DECODE(TO_CHAR(A.SUPDATE,'DD'),'26',SUM(nvl(A.SUP_COPY,0))) p26,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'27',SUM(nvl(A.SUP_COPY,0))) p27, DECODE(TO_CHAR(A.SUPDATE,'DD'),'28',SUM(nvl(A.SUP_COPY,0))) p28,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'29',SUM(nvl(A.SUP_COPY,0))) p29, DECODE(TO_CHAR(A.SUPDATE,'DD'),'30',SUM(nvl(A.SUP_COPY,0))) p30,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'31',SUM(nvl(A.SUP_COPY,0))) p31
        FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=PCOMP_CODE AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=PUNIT_CODE AND
        A.AGCD=B.AGCD AND A.AGCD=NVL(PAGCODE,A.AGCD) AND A.DPCD=B.DPCD AND A.DPCD=B.DPCD AND  A.DPCD=NVL(PDPCODE,A.DPCD) AND 
        A.PUBL=PPUBL AND (A.EDTN=PEDTN OR PEDTN IS NULL) AND (B.CITY_CODE=PCITYCD OR PCITYCD IS NULL) AND
        (B.STATE_CODE=PSTATECD OR PSTATECD IS NULL) AND (B.DIST_CODE=PDISTCODE OR PDISTCODE IS NULL) AND (B.TEHSIL_TALUKA=PTALUKA OR PTALUKA IS NULL) AND 
        (B.BRANCH_CODE=PBRANCH OR PBRANCH IS NULL) AND (B.AG_TYPE=PAGTYPE OR PAGTYPE IS NULL) AND (B.AG_CLASS=PAGCLASS OR PAGCLASS IS NULL) AND 
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE=PEXTRA1 OR PEXTRA1 IS NULL) AND A.SUPDATE >= VFRDT AND A.SUPDATE <= VTODT  AND NVL(A.SUP_COPY,0)>0
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE,B.DIST_CODE,B.STATE_CODE)
        GROUP BY COMP_CODE,UNIT_CODE,DIST_CODE,STATE_CODE
        ORDER BY COMP_CODE,UNIT_CODE,STATE_CODE,DIST_CODE;
       open p_accounts2 for
       SELECT COMP_CODE,UNIT_CODE,
       SUM(p01) AS "01",SUM(p02) AS "02",SUM(p03) AS "03",SUM(p04) AS "04",SUM(p05) AS "05",
        SUM(p06) AS "06",SUM(p07) AS "07",SUM(p08) AS "08",SUM(p09) AS "09",SUM(p10) AS "10",
        SUM(p11) AS "11",SUM(p12) AS "12",SUM(p13) AS "13",SUM(p14) AS "14",SUM(p15) AS "15",
        SUM(p16) AS "16",SUM(p17) AS "17",SUM(p18) AS "18",SUM(p19) AS "19",SUM(p20) AS "20",
        SUM(p21) AS "21",SUM(p22) AS "22",SUM(p23) AS "23",SUM(p24) AS "24",SUM(p25) AS "25",
        SUM(p26) AS "26",SUM(p27) AS "27",SUM(p28) AS "28",SUM(p29) AS "29",SUM(p30) AS "30",SUM(p31) AS "31",
        SUM(nvl(p01,0)+nvl(p02,0)+nvl(p03,0)+nvl(p04,0)+nvl(p05,0)+nvl(p06,0)+nvl(p07,0)+nvl(p08,0)+nvl(p09,0)+nvl(p10,0)+
        nvl(p11,0)+nvl(p12,0)+nvl(p13,0)+nvl(p14,0)+nvl(p15,0)+nvl(p16,0)+nvl(p17,0)+nvl(p18,0)+nvl(p19,0)+nvl(p20,0)+
        nvl(p21,0)+nvl(p22,0)+nvl(p23,0)+nvl(p24,0)+nvl(p25,0)+nvl(p26,0)+nvl(p27,0)+nvl(p28,0)+nvl(p29,0)+nvl(p30,0)+nvl(p31,0)) AS "TOTAL"
        FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'01',SUM(nvl(A.SUP_COPY,0))) p01,DECODE(TO_CHAR(A.SUPDATE,'DD'),'02',SUM(nvl(A.SUP_COPY,0))) p02,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'03',SUM(nvl(A.SUP_COPY,0))) p03, DECODE(TO_CHAR(A.SUPDATE,'DD'),'04',SUM(nvl(A.SUP_COPY,0))) p04,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'05',SUM(nvl(A.SUP_COPY,0))) p05, DECODE(TO_CHAR(A.SUPDATE,'DD'),'06',SUM(nvl(A.SUP_COPY,0))) p06,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'07',SUM(nvl(A.SUP_COPY,0))) p07, DECODE(TO_CHAR(A.SUPDATE,'DD'),'08',SUM(nvl(A.SUP_COPY,0))) p08,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'09',SUM(nvl(A.SUP_COPY,0))) p09, DECODE(TO_CHAR(A.SUPDATE,'DD'),'10',SUM(nvl(A.SUP_COPY,0))) p10,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'11',SUM(nvl(A.SUP_COPY,0))) p11, DECODE(TO_CHAR(A.SUPDATE,'DD'),'12',SUM(nvl(A.SUP_COPY,0))) p12,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'13',SUM(nvl(A.SUP_COPY,0))) p13, DECODE(TO_CHAR(A.SUPDATE,'DD'),'14',SUM(nvl(A.SUP_COPY,0))) p14,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'15',SUM(nvl(A.SUP_COPY,0))) p15, DECODE(TO_CHAR(A.SUPDATE,'DD'),'16',SUM(nvl(A.SUP_COPY,0))) p16,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'17',SUM(nvl(A.SUP_COPY,0))) p17, DECODE(TO_CHAR(A.SUPDATE,'DD'),'18',SUM(nvl(A.SUP_COPY,0))) p18,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'19',SUM(nvl(A.SUP_COPY,0))) p19, DECODE(TO_CHAR(A.SUPDATE,'DD'),'20',SUM(nvl(A.SUP_COPY,0))) p20,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'21',SUM(nvl(A.SUP_COPY,0))) p21, DECODE(TO_CHAR(A.SUPDATE,'DD'),'22',SUM(nvl(A.SUP_COPY,0))) p22,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'23',SUM(nvl(A.SUP_COPY,0))) p23, DECODE(TO_CHAR(A.SUPDATE,'DD'),'24',SUM(nvl(A.SUP_COPY,0))) p24,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'25',SUM(nvl(A.SUP_COPY,0))) p25, DECODE(TO_CHAR(A.SUPDATE,'DD'),'26',SUM(nvl(A.SUP_COPY,0))) p26,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'27',SUM(nvl(A.SUP_COPY,0))) p27, DECODE(TO_CHAR(A.SUPDATE,'DD'),'28',SUM(nvl(A.SUP_COPY,0))) p28,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'29',SUM(nvl(A.SUP_COPY,0))) p29, DECODE(TO_CHAR(A.SUPDATE,'DD'),'30',SUM(nvl(A.SUP_COPY,0))) p30,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'31',SUM(nvl(A.SUP_COPY,0))) p31
        FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=PCOMP_CODE AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=PUNIT_CODE AND
        A.AGCD=B.AGCD AND A.AGCD=NVL(PAGCODE,A.AGCD) AND A.DPCD=B.DPCD AND A.DPCD=B.DPCD AND  A.DPCD=NVL(PDPCODE,A.DPCD) AND 
        A.PUBL=PPUBL AND (A.EDTN=PEDTN OR PEDTN IS NULL) AND (B.CITY_CODE=PCITYCD OR PCITYCD IS NULL) AND
        (B.STATE_CODE=PSTATECD OR PSTATECD IS NULL) AND (B.DIST_CODE=PDISTCODE OR PDISTCODE IS NULL) AND (B.TEHSIL_TALUKA=PTALUKA OR PTALUKA IS NULL) AND 
        (B.BRANCH_CODE=PBRANCH OR PBRANCH IS NULL) AND (B.AG_TYPE=PAGTYPE OR PAGTYPE IS NULL) AND (B.AG_CLASS=PAGCLASS OR PAGCLASS IS NULL) AND 
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE=PEXTRA1 OR PEXTRA1 IS NULL) AND A.SUPDATE >= VFRDT AND A.SUPDATE <= VTODT AND NVL(A.SUP_COPY,0)>0
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE)
        GROUP BY COMP_CODE,UNIT_CODE
        ORDER BY COMP_CODE,UNIT_CODE;
  End cir_rep_dist_daybook;
  procedure cir_rep_taluka_daybook(
     pcomp_code     in varchar2,
     punit_code     in varchar2,
     ppubl          in varchar2,
     pedtn          in varchar2,
     pcitycd        in varchar2,
     pstatecd       in varchar2,
     pmonth         in varchar2,
     pyear          in number,
     pdateformat    in varchar2,
     pbranch        in varchar2,
     pdistcode      in varchar2,
     ptaluka        in varchar2,
     pagtype        in varchar2,
     pagclass       in varchar2,
     pagcode        in varchar2,
     pdpcode        in varchar2,
     pextra1        in varchar2,--it is used for supply type
     pextra2        in varchar2,
     pextra3        in varchar2,
     pextra4        in varchar2,
     pextra5        in varchar2,
     p_accounts     out t_accounts,
     p_accounts1    out t_accounts,
     p_accounts2    out t_accounts)
    As
     vfrdt          date;
     vtodt          date;
   Begin
       vfrdt:=to_date('01/'||pmonth||'/'||pyear,pdateformat);
       vtodt:=last_day(vfrdt);
       open p_accounts for
       SELECT COMP_CODE,UNIT_CODE,AGCD "AGENCY CODE",DPCD "AGENCY SUBCODE",substr(cir_get_agency(comp_code,unit_code,agcd,dpcd),1,50) "AGENCY NAME",
       substr(cir_get_name.cir_agname(comp_code,unit_code,agcd,dpcd,2,pdateformat,'',''),1,50) "AGENCY ONAME",
       EDTN,CIR_GET_EDTN_NAME(COMP_CODE,EDTN) "EDITION NAME",nvl(CIR_GET_NAME.CIR_EDTN(COMP_CODE,'',EDTN,2,pdateformat,'',''),'NA') "EDITION ONAME",
       nvl(CITY_CODE,'NA') "CITY CODE",nvl(CIR_GET_CITY(COMP_CODE,CITY_CODE),'NA') "CITY NAME",nvl(CIR_GET_NAME.CIR_CITY(COMP_CODE,CITY_CODE,2,pdateformat,'',''),'NA') "CITY ONAME",
       nvl(TEHSIL_TALUKA,'NA') "TALUKA CODE",nvl(CIR_GET_TALUKA(COMP_CODE,TEHSIL_TALUKA),'NA') "TALUKA NAME",nvl(CIR_GET_NAME.CIR_TALUKA(COMP_CODE,TEHSIL_TALUKA,2,pdateformat,'',''),'NA') "TALUKA ONAME",
       STATE_CODE "STATE CODE",
        SUM(p01) AS "01",SUM(p02) AS "02",SUM(p03) AS "03",SUM(p04) AS "04",SUM(p05) AS "05",
        SUM(p06) AS "06",SUM(p07) AS "07",SUM(p08) AS "08",SUM(p09) AS "09",SUM(p10) AS "10",
        SUM(p11) AS "11",SUM(p12) AS "12",SUM(p13) AS "13",SUM(p14) AS "14",SUM(p15) AS "15",
        SUM(p16) AS "16",SUM(p17) AS "17",SUM(p18) AS "18",SUM(p19) AS "19",SUM(p20) AS "20",
        SUM(p21) AS "21",SUM(p22) AS "22",SUM(p23) AS "23",SUM(p24) AS "24",SUM(p25) AS "25",
        SUM(p26) AS "26",SUM(p27) AS "27",SUM(p28) AS "28",SUM(p29) AS "29",SUM(p30) AS "30",SUM(p31) AS "31",
        SUM(nvl(p01,0)+nvl(p02,0)+nvl(p03,0)+nvl(p04,0)+nvl(p05,0)+nvl(p06,0)+nvl(p07,0)+nvl(p08,0)+nvl(p09,0)+nvl(p10,0)+
            nvl(p11,0)+nvl(p12,0)+nvl(p13,0)+nvl(p14,0)+nvl(p15,0)+nvl(p16,0)+nvl(p17,0)+nvl(p18,0)+nvl(p19,0)+nvl(p20,0)+
        nvl(p21,0)+nvl(p22,0)+nvl(p23,0)+nvl(p24,0)+nvl(p25,0)+nvl(p26,0)+nvl(p27,0)+nvl(p28,0)+nvl(p29,0)+nvl(p30,0)+nvl(p31,0)) AS "TOTAL"
        FROM (SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,MIN(A.EDTN) EDTN,B.CITY_CODE,B.TEHSIL_TALUKA TEHSIL_TALUKA,B.STATE_CODE STATE_CODE,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'01',SUM(nvl(A.SUP_COPY,0))) p01,DECODE(TO_CHAR(A.SUPDATE,'DD'),'02',SUM(nvl(A.SUP_COPY,0))) p02,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'03',SUM(nvl(A.SUP_COPY,0))) p03, DECODE(TO_CHAR(A.SUPDATE,'DD'),'04',SUM(nvl(A.SUP_COPY,0))) p04,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'05',SUM(nvl(A.SUP_COPY,0))) p05, DECODE(TO_CHAR(A.SUPDATE,'DD'),'06',SUM(nvl(A.SUP_COPY,0))) p06,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'07',SUM(nvl(A.SUP_COPY,0))) p07, DECODE(TO_CHAR(A.SUPDATE,'DD'),'08',SUM(nvl(A.SUP_COPY,0))) p08,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'09',SUM(nvl(A.SUP_COPY,0))) p09, DECODE(TO_CHAR(A.SUPDATE,'DD'),'10',SUM(nvl(A.SUP_COPY,0))) p10,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'11',SUM(nvl(A.SUP_COPY,0))) p11, DECODE(TO_CHAR(A.SUPDATE,'DD'),'12',SUM(nvl(A.SUP_COPY,0))) p12,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'13',SUM(nvl(A.SUP_COPY,0))) p13, DECODE(TO_CHAR(A.SUPDATE,'DD'),'14',SUM(nvl(A.SUP_COPY,0))) p14,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'15',SUM(nvl(A.SUP_COPY,0))) p15, DECODE(TO_CHAR(A.SUPDATE,'DD'),'16',SUM(nvl(A.SUP_COPY,0))) p16,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'17',SUM(nvl(A.SUP_COPY,0))) p17, DECODE(TO_CHAR(A.SUPDATE,'DD'),'18',SUM(nvl(A.SUP_COPY,0))) p18,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'19',SUM(nvl(A.SUP_COPY,0))) p19, DECODE(TO_CHAR(A.SUPDATE,'DD'),'20',SUM(nvl(A.SUP_COPY,0))) p20,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'21',SUM(nvl(A.SUP_COPY,0))) p21, DECODE(TO_CHAR(A.SUPDATE,'DD'),'22',SUM(nvl(A.SUP_COPY,0))) p22,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'23',SUM(nvl(A.SUP_COPY,0))) p23, DECODE(TO_CHAR(A.SUPDATE,'DD'),'24',SUM(nvl(A.SUP_COPY,0))) p24,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'25',SUM(nvl(A.SUP_COPY,0))) p25, DECODE(TO_CHAR(A.SUPDATE,'DD'),'26',SUM(nvl(A.SUP_COPY,0))) p26,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'27',SUM(nvl(A.SUP_COPY,0))) p27, DECODE(TO_CHAR(A.SUPDATE,'DD'),'28',SUM(nvl(A.SUP_COPY,0))) p28,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'29',SUM(nvl(A.SUP_COPY,0))) p29, DECODE(TO_CHAR(A.SUPDATE,'DD'),'30',SUM(nvl(A.SUP_COPY,0))) p30,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'31',SUM(nvl(A.SUP_COPY,0))) p31
        FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=PCOMP_CODE AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=PUNIT_CODE AND
        A.AGCD=B.AGCD AND A.AGCD=NVL(PAGCODE,A.AGCD) AND A.DPCD=B.DPCD AND A.DPCD=B.DPCD AND  A.DPCD=NVL(PDPCODE,A.DPCD) AND 
        A.PUBL=PPUBL AND (A.EDTN=PEDTN OR PEDTN IS NULL) AND (B.CITY_CODE=PCITYCD OR PCITYCD IS NULL) AND
        (B.STATE_CODE=PSTATECD OR PSTATECD IS NULL) AND (B.DIST_CODE=PDISTCODE OR PDISTCODE IS NULL) AND (B.TEHSIL_TALUKA=PTALUKA OR PTALUKA IS NULL) AND 
        (B.BRANCH_CODE=PBRANCH OR PBRANCH IS NULL) AND (B.AG_TYPE=PAGTYPE OR PAGTYPE IS NULL) AND (B.AG_CLASS=PAGCLASS OR PAGCLASS IS NULL) AND
         A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE=PEXTRA1 OR PEXTRA1 IS NULL) AND A.SUPDATE >= VFRDT AND A.SUPDATE <= VTODT AND NVL(A.SUP_COPY,0)>0
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.AGCD,A.DPCD,A.SUPDATE,B.CITY_CODE,B.TEHSIL_TALUKA,B.STATE_CODE)
        GROUP BY COMP_CODE,UNIT_CODE,AGCD,DPCD,EDTN,CITY_CODE,TEHSIL_TALUKA,STATE_CODE
        ORDER BY COMP_CODE,UNIT_CODE,STATE_CODE,TEHSIL_TALUKA,CITY_CODE,EDTN,AGCD,DPCD;
       open p_accounts1 for
       SELECT COMP_CODE,UNIT_CODE,nvl(TEHSIL_TALUKA,'NA') "TALUKA CODE",nvl(CIR_GET_TALUKA(COMP_CODE,TEHSIL_TALUKA),'NA') "TALUKA NAME",
       nvl(CIR_GET_NAME.CIR_TALUKA(COMP_CODE,TEHSIL_TALUKA,2,pdateformat,'',''),'NA') "TALUKA ONAME",STATE_CODE "STATE CODE",
       SUM(p01) AS "01",SUM(p02) AS "02",SUM(p03) AS "03",SUM(p04) AS "04",SUM(p05) AS "05",
        SUM(p06) AS "06",SUM(p07) AS "07",SUM(p08) AS "08",SUM(p09) AS "09",SUM(p10) AS "10",
        SUM(p11) AS "11",SUM(p12) AS "12",SUM(p13) AS "13",SUM(p14) AS "14",SUM(p15) AS "15",
        SUM(p16) AS "16",SUM(p17) AS "17",SUM(p18) AS "18",SUM(p19) AS "19",SUM(p20) AS "20",
        SUM(p21) AS "21",SUM(p22) AS "22",SUM(p23) AS "23",SUM(p24) AS "24",SUM(p25) AS "25",
        SUM(p26) AS "26",SUM(p27) AS "27",SUM(p28) AS "28",SUM(p29) AS "29",SUM(p30) AS "30",SUM(p31) AS "31",
        SUM(nvl(p01,0)+nvl(p02,0)+nvl(p03,0)+nvl(p04,0)+nvl(p05,0)+nvl(p06,0)+nvl(p07,0)+nvl(p08,0)+nvl(p09,0)+nvl(p10,0)+
        nvl(p11,0)+nvl(p12,0)+nvl(p13,0)+nvl(p14,0)+nvl(p15,0)+nvl(p16,0)+nvl(p17,0)+nvl(p18,0)+nvl(p19,0)+nvl(p20,0)+
        nvl(p21,0)+nvl(p22,0)+nvl(p23,0)+nvl(p24,0)+nvl(p25,0)+nvl(p26,0)+nvl(p27,0)+nvl(p28,0)+nvl(p29,0)+nvl(p30,0)+nvl(p31,0)) AS "TOTAL"
        FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,B.TEHSIL_TALUKA TEHSIL_TALUKA,B.STATE_CODE STATE_CODE,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'01',SUM(nvl(A.SUP_COPY,0))) p01,DECODE(TO_CHAR(A.SUPDATE,'DD'),'02',SUM(nvl(A.SUP_COPY,0))) p02,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'03',SUM(nvl(A.SUP_COPY,0))) p03, DECODE(TO_CHAR(A.SUPDATE,'DD'),'04',SUM(nvl(A.SUP_COPY,0))) p04,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'05',SUM(nvl(A.SUP_COPY,0))) p05, DECODE(TO_CHAR(A.SUPDATE,'DD'),'06',SUM(nvl(A.SUP_COPY,0))) p06,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'07',SUM(nvl(A.SUP_COPY,0))) p07, DECODE(TO_CHAR(A.SUPDATE,'DD'),'08',SUM(nvl(A.SUP_COPY,0))) p08,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'09',SUM(nvl(A.SUP_COPY,0))) p09, DECODE(TO_CHAR(A.SUPDATE,'DD'),'10',SUM(nvl(A.SUP_COPY,0))) p10,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'11',SUM(nvl(A.SUP_COPY,0))) p11, DECODE(TO_CHAR(A.SUPDATE,'DD'),'12',SUM(nvl(A.SUP_COPY,0))) p12,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'13',SUM(nvl(A.SUP_COPY,0))) p13, DECODE(TO_CHAR(A.SUPDATE,'DD'),'14',SUM(nvl(A.SUP_COPY,0))) p14,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'15',SUM(nvl(A.SUP_COPY,0))) p15, DECODE(TO_CHAR(A.SUPDATE,'DD'),'16',SUM(nvl(A.SUP_COPY,0))) p16,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'17',SUM(nvl(A.SUP_COPY,0))) p17, DECODE(TO_CHAR(A.SUPDATE,'DD'),'18',SUM(nvl(A.SUP_COPY,0))) p18,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'19',SUM(nvl(A.SUP_COPY,0))) p19, DECODE(TO_CHAR(A.SUPDATE,'DD'),'20',SUM(nvl(A.SUP_COPY,0))) p20,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'21',SUM(nvl(A.SUP_COPY,0))) p21, DECODE(TO_CHAR(A.SUPDATE,'DD'),'22',SUM(nvl(A.SUP_COPY,0))) p22,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'23',SUM(nvl(A.SUP_COPY,0))) p23, DECODE(TO_CHAR(A.SUPDATE,'DD'),'24',SUM(nvl(A.SUP_COPY,0))) p24,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'25',SUM(nvl(A.SUP_COPY,0))) p25, DECODE(TO_CHAR(A.SUPDATE,'DD'),'26',SUM(nvl(A.SUP_COPY,0))) p26,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'27',SUM(nvl(A.SUP_COPY,0))) p27, DECODE(TO_CHAR(A.SUPDATE,'DD'),'28',SUM(nvl(A.SUP_COPY,0))) p28,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'29',SUM(nvl(A.SUP_COPY,0))) p29, DECODE(TO_CHAR(A.SUPDATE,'DD'),'30',SUM(nvl(A.SUP_COPY,0))) p30,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'31',SUM(nvl(A.SUP_COPY,0))) p31
        FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=PCOMP_CODE AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=PUNIT_CODE AND
        A.AGCD=B.AGCD AND A.AGCD=NVL(PAGCODE,A.AGCD) AND A.DPCD=B.DPCD AND A.DPCD=B.DPCD AND  A.DPCD=NVL(PDPCODE,A.DPCD) AND 
        A.PUBL=PPUBL AND (A.EDTN=PEDTN OR PEDTN IS NULL) AND (B.CITY_CODE=PCITYCD OR PCITYCD IS NULL) AND
        (B.STATE_CODE=PSTATECD OR PSTATECD IS NULL) AND (B.DIST_CODE=PDISTCODE OR PDISTCODE IS NULL) AND (B.TEHSIL_TALUKA=PTALUKA OR PTALUKA IS NULL) AND 
        (B.BRANCH_CODE=PBRANCH OR PBRANCH IS NULL) AND (B.AG_TYPE=PAGTYPE OR PAGTYPE IS NULL) AND (B.AG_CLASS=PAGCLASS OR PAGCLASS IS NULL) AND 
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE=PEXTRA1 OR PEXTRA1 IS NULL) AND A.SUPDATE >= VFRDT AND A.SUPDATE <= VTODT AND NVL(A.SUP_COPY,0)>0
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE,B.TEHSIL_TALUKA,B.STATE_CODE)
        GROUP BY COMP_CODE,UNIT_CODE,TEHSIL_TALUKA,STATE_CODE
        ORDER BY COMP_CODE,UNIT_CODE,STATE_CODE,TEHSIL_TALUKA;
       open p_accounts2 for
       SELECT COMP_CODE,UNIT_CODE,
       SUM(p01) AS "01",SUM(p02) AS "02",SUM(p03) AS "03",SUM(p04) AS "04",SUM(p05) AS "05",
        SUM(p06) AS "06",SUM(p07) AS "07",SUM(p08) AS "08",SUM(p09) AS "09",SUM(p10) AS "10",
        SUM(p11) AS "11",SUM(p12) AS "12",SUM(p13) AS "13",SUM(p14) AS "14",SUM(p15) AS "15",
        SUM(p16) AS "16",SUM(p17) AS "17",SUM(p18) AS "18",SUM(p19) AS "19",SUM(p20) AS "20",
        SUM(p21) AS "21",SUM(p22) AS "22",SUM(p23) AS "23",SUM(p24) AS "24",SUM(p25) AS "25",
        SUM(p26) AS "26",SUM(p27) AS "27",SUM(p28) AS "28",SUM(p29) AS "29",SUM(p30) AS "30",SUM(p31) AS "31",
        SUM(nvl(p01,0)+nvl(p02,0)+nvl(p03,0)+nvl(p04,0)+nvl(p05,0)+nvl(p06,0)+nvl(p07,0)+nvl(p08,0)+nvl(p09,0)+nvl(p10,0)+
        nvl(p11,0)+nvl(p12,0)+nvl(p13,0)+nvl(p14,0)+nvl(p15,0)+nvl(p16,0)+nvl(p17,0)+nvl(p18,0)+nvl(p19,0)+nvl(p20,0)+
        nvl(p21,0)+nvl(p22,0)+nvl(p23,0)+nvl(p24,0)+nvl(p25,0)+nvl(p26,0)+nvl(p27,0)+nvl(p28,0)+nvl(p29,0)+nvl(p30,0)+nvl(p31,0)) AS "TOTAL"
        FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'01',SUM(nvl(A.SUP_COPY,0))) p01,DECODE(TO_CHAR(A.SUPDATE,'DD'),'02',SUM(nvl(A.SUP_COPY,0))) p02,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'03',SUM(nvl(A.SUP_COPY,0))) p03, DECODE(TO_CHAR(A.SUPDATE,'DD'),'04',SUM(nvl(A.SUP_COPY,0))) p04,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'05',SUM(nvl(A.SUP_COPY,0))) p05, DECODE(TO_CHAR(A.SUPDATE,'DD'),'06',SUM(nvl(A.SUP_COPY,0))) p06,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'07',SUM(nvl(A.SUP_COPY,0))) p07, DECODE(TO_CHAR(A.SUPDATE,'DD'),'08',SUM(nvl(A.SUP_COPY,0))) p08,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'09',SUM(nvl(A.SUP_COPY,0))) p09, DECODE(TO_CHAR(A.SUPDATE,'DD'),'10',SUM(nvl(A.SUP_COPY,0))) p10,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'11',SUM(nvl(A.SUP_COPY,0))) p11, DECODE(TO_CHAR(A.SUPDATE,'DD'),'12',SUM(nvl(A.SUP_COPY,0))) p12,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'13',SUM(nvl(A.SUP_COPY,0))) p13, DECODE(TO_CHAR(A.SUPDATE,'DD'),'14',SUM(nvl(A.SUP_COPY,0))) p14,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'15',SUM(nvl(A.SUP_COPY,0))) p15, DECODE(TO_CHAR(A.SUPDATE,'DD'),'16',SUM(nvl(A.SUP_COPY,0))) p16,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'17',SUM(nvl(A.SUP_COPY,0))) p17, DECODE(TO_CHAR(A.SUPDATE,'DD'),'18',SUM(nvl(A.SUP_COPY,0))) p18,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'19',SUM(nvl(A.SUP_COPY,0))) p19, DECODE(TO_CHAR(A.SUPDATE,'DD'),'20',SUM(nvl(A.SUP_COPY,0))) p20,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'21',SUM(nvl(A.SUP_COPY,0))) p21, DECODE(TO_CHAR(A.SUPDATE,'DD'),'22',SUM(nvl(A.SUP_COPY,0))) p22,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'23',SUM(nvl(A.SUP_COPY,0))) p23, DECODE(TO_CHAR(A.SUPDATE,'DD'),'24',SUM(nvl(A.SUP_COPY,0))) p24,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'25',SUM(nvl(A.SUP_COPY,0))) p25, DECODE(TO_CHAR(A.SUPDATE,'DD'),'26',SUM(nvl(A.SUP_COPY,0))) p26,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'27',SUM(nvl(A.SUP_COPY,0))) p27, DECODE(TO_CHAR(A.SUPDATE,'DD'),'28',SUM(nvl(A.SUP_COPY,0))) p28,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'29',SUM(nvl(A.SUP_COPY,0))) p29, DECODE(TO_CHAR(A.SUPDATE,'DD'),'30',SUM(nvl(A.SUP_COPY,0))) p30,
        DECODE(TO_CHAR(A.SUPDATE,'DD'),'31',SUM(nvl(A.SUP_COPY,0))) p31
        FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE=PCOMP_CODE AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE=PUNIT_CODE AND
        A.AGCD=B.AGCD AND A.AGCD=NVL(PAGCODE,A.AGCD) AND A.DPCD=B.DPCD AND A.DPCD=B.DPCD AND  A.DPCD=NVL(PDPCODE,A.DPCD) AND 
        A.PUBL=PPUBL AND (A.EDTN=PEDTN OR PEDTN IS NULL) AND (B.CITY_CODE=PCITYCD OR PCITYCD IS NULL) AND
        (B.STATE_CODE=PSTATECD OR PSTATECD IS NULL) AND (B.DIST_CODE=PDISTCODE OR PDISTCODE IS NULL) AND (B.TEHSIL_TALUKA=PTALUKA OR PTALUKA IS NULL) AND 
        (B.BRANCH_CODE=PBRANCH OR PBRANCH IS NULL) AND (B.AG_TYPE=PAGTYPE OR PAGTYPE IS NULL) AND (B.AG_CLASS=PAGCLASS OR PAGCLASS IS NULL) AND 
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE=PEXTRA1 OR PEXTRA1 IS NULL) AND A.SUPDATE >= VFRDT AND A.SUPDATE <= VTODT AND NVL(A.SUP_COPY,0)>0
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE)
        GROUP BY COMP_CODE,UNIT_CODE
        ORDER BY COMP_CODE,UNIT_CODE;
  End cir_rep_taluka_daybook;
  procedure cir_rep_day_daybook(
     pcomp_code     in varchar2,
     punit_code     in varchar2,
     ppubl          in varchar2,
     pedtn          in varchar2,
     pcitycd        in varchar2,
     pstatecd       in varchar2,
     pmonth         in varchar2,
     pyear          in number,
     pday           in varchar2,
     pdateformat    in varchar2,
     pbranch        in varchar2,
     pdistcode      in varchar2,
     ptaluka        in varchar2,
     pagtype        in varchar2,
     pagclass       in varchar2,
     pagcode        in varchar2,
     pdpcode        in varchar2,
     pextra1        in varchar2,--it is used for supply type
     pextra2        in varchar2,
     pextra3        in varchar2,
     pextra4        in varchar2,
     pextra5        in varchar2,
     p_accounts     out t_accounts,
     p_accounts1    out t_accounts,
     p_accounts2    out t_accounts)
    As
     vquery1        varchar2(12000);
     vquery2        varchar2(12000);
     vquery3        varchar2(12000);
     vdaysup        varchar2(2000);
     vtotsup        varchar2(1000);
     vfrdt          date;
     vtodt          date;
     v_dt           date;
     v_day          varchar2(3);
     v_cnt          number:=0;
       cursor c1 is
           select dt,upper(to_char(dt,'DY')) supply_day from cir_temp_dt order by sqno,dt;
   Begin
       vfrdt:=to_date('01/'||pmonth||'/'||pyear,pdateformat);
       vtodt:=last_day(vfrdt);
    delete from cir_temp_dt;
    loop
        if v_dt>=vtodt then
            exit;
        else
            if v_dt is null then
                v_dt:=vfrdt;
            else
                v_dt:=v_dt+1;
            end if;
        end if;
           if upper(to_char(v_dt,'DY'))=upper(pday) then
               insert into cir_temp_dt(sqno,dt) values(1,v_dt);
           else
               insert into cir_temp_dt(sqno,dt) values(2,v_dt);
           end if;
    end loop;
    open c1;
    loop
        fetch c1 into v_dt,v_day;
        exit when c1%notfound;
        v_cnt        := v_cnt+1;
        if vquery1 is null then
            vquery1:='DECODE(TO_CHAR(A.SUPDATE,''DD''),'''||to_char(v_dt,'dd')||''',SUM(nvl(A.SUP_COPY,0))) P'||lpad(v_cnt,2,'0');
            vdaysup:='SUM(NVL(P'||lpad(v_cnt,2,'0')||',0)) AS '||'"'||lpad(v_cnt,2,'0')||'"';
            vtotsup:='NVL(P'||lpad(v_cnt,2,'0')||',0)';
        else
            vquery1:=vquery1||','||'DECODE(TO_CHAR(A.SUPDATE,''DD''),'''||to_char(v_dt,'dd')||''',SUM(nvl(A.SUP_COPY,0))) P'||lpad(v_cnt,2,'0');
            vdaysup:=vdaysup||','||'SUM(NVL(P'||lpad(v_cnt,2,'0')||',0)) AS '||'"'||lpad(v_cnt,2,'0')||'"';
            vtotsup:=vtotsup||'+'||'NVL(P'||lpad(v_cnt,2,'0')||',0)';
        end if;
    end loop;
    close c1;
    vtotsup:='SUM('||vtotsup||')';
    insert into test1(vstring,vstring2) values('1 '||vquery1,vdaysup||','||vtotsup||'AS "TOTAL"');
    vquery3:='SELECT COMP_CODE,UNIT_CODE,AGCD "AGENCY CODE",DPCD "AGENCY SUBCODE",substr(cir_get_agency(comp_code,unit_code,agcd,dpcd),1,50) "AGENCY NAME",substr(cir_get_name.cir_agname(comp_code,unit_code,agcd,dpcd,2,'||''''||pdateformat||''''||','''',''''),1,50) "AGENCY ONAME",
       EDTN,CIR_GET_EDTN_NAME(COMP_CODE,EDTN) "EDITION NAME",nvl(CIR_GET_NAME.CIR_EDTN(COMP_CODE,'''',EDTN,2,'||''''||pdateformat||''''||','''',''''),''NA'') "EDITION ONAME",
       nvl(CITY_CODE,''NA'') "CITY CODE",nvl(CIR_GET_CITY(COMP_CODE,CITY_CODE),''NA'') "CITY NAME",nvl(CIR_GET_NAME.CIR_CITY(COMP_CODE,CITY_CODE,2,'||''''||pdateformat||''''||','''',''''),''NA'') "CITY ONAME",
       nvl(STATE_CODE,''NA'') "STATE CODE",nvl(CIR_GET_STATE(COMP_CODE,COUNTRY_CODE,STATE_CODE),''NA'') "STATE NAME",COUNTRY_CODE "COUNTRY CODE",'||vdaysup||','||vtotsup||'AS "TOTAL"'||
       ' FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,MIN(A.EDTN) EDTN,B.CITY_CODE,B.STATE_CODE STATE_CODE,B.COUNTRY_CODE COUNTRY_CODE,'||vquery1;
       vquery2:=' FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''||PCOMP_CODE||''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE='''||PUNIT_CODE||''' AND
        A.AGCD=B.AGCD AND A.AGCD=NVL('''||PAGCODE||''',A.AGCD) AND A.DPCD=B.DPCD AND A.DPCD=NVL('''||PDPCODE||''',A.DPCD) AND 
        A.PUBL='''||PPUBL||''' AND (A.EDTN='''||PEDTN||''' OR '''||PEDTN||''' IS NULL) AND (B.CITY_CODE='''||PCITYCD||''' OR '''||PCITYCD ||''' IS NULL) AND
        (B.STATE_CODE='''||PSTATECD||''' OR '''||PSTATECD||''' IS NULL) AND (B.DIST_CODE='''||PDISTCODE||''' OR '''||PDISTCODE||''' IS NULL) AND 
        (B.TEHSIL_TALUKA='''||PTALUKA||''' OR '''||PTALUKA||''' IS NULL) AND (B.BRANCH_CODE='''||PBRANCH||''' OR '''||PBRANCH||''' IS NULL) AND
        (B.AG_TYPE='''||PAGTYPE||''' OR '''||PAGTYPE||''' IS NULL) AND (B.AG_CLASS='''||PAGCLASS||''' OR '''||PAGCLASS||''' IS NULL) AND
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND A.SUPDATE >= '''||VFRDT||''' AND A.SUPDATE <='''||VTODT||''' AND NVL(A.SUP_COPY,0)>0 AND upper(to_char(A.SUPDATE,''DY''))=upper('''||pday||''')
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.AGCD,A.DPCD,A.SUPDATE,B.CITY_CODE,B.STATE_CODE,B.COUNTRY_CODE)
        GROUP BY COMP_CODE,UNIT_CODE,AGCD,DPCD,EDTN,CITY_CODE,STATE_CODE,COUNTRY_CODE
        ORDER BY COMP_CODE,UNIT_CODE,STATE_CODE,CITY_CODE,EDTN,AGCD,DPCD';
       insert into test1(vstring,vstring2) values('2 '||vquery3,VQUERY2);commit;
       open p_accounts for vquery3||vquery2;
        vquery3:='SELECT COMP_CODE,UNIT_CODE,nvl(STATE_CODE,''NA'') "STATE CODE",nvl(CIR_GET_STATE(COMP_CODE,COUNTRY_CODE,STATE_CODE),''NA'') "STATE NAME",COUNTRY_CODE "COUNTRY CODE",'||vdaysup||','||vtotsup||'AS "TOTAL"'||
        ' FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,B.STATE_CODE STATE_CODE,B.COUNTRY_CODE COUNTRY_CODE,'||vquery1;
        vquery2:='    FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''||PCOMP_CODE||''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE='''||PUNIT_CODE||''' AND
        A.AGCD=B.AGCD AND A.AGCD=NVL('''||PAGCODE||''',A.AGCD) AND A.DPCD=B.DPCD AND A.DPCD=NVL('''||PDPCODE||''',A.DPCD) AND 
        A.PUBL='''||PPUBL||''' AND (A.EDTN='''||PEDTN||''' OR '''||PEDTN||''' IS NULL) AND (B.CITY_CODE='''||PCITYCD||''' OR '''||PCITYCD ||''' IS NULL) AND
        (B.STATE_CODE='''||PSTATECD||''' OR '''||PSTATECD||''' IS NULL) AND (B.DIST_CODE='''||PDISTCODE||''' OR '''||PDISTCODE||''' IS NULL) AND 
        (B.TEHSIL_TALUKA='''||PTALUKA||''' OR '''||PTALUKA||''' IS NULL) AND (B.BRANCH_CODE='''||PBRANCH||''' OR '''||PBRANCH||''' IS NULL) AND
        (B.AG_TYPE='''||PAGTYPE||''' OR '''||PAGTYPE||''' IS NULL) AND (B.AG_CLASS='''||PAGCLASS||''' OR '''||PAGCLASS||''' IS NULL) AND 
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''||PEXTRA1||''' OR '''||PEXTRA1||''' IS NULL) AND A.SUPDATE >= '''||VFRDT||''' AND A.SUPDATE <= '''||VTODT||''' AND NVL(A.SUP_COPY,0)>0 AND upper(to_char(A.SUPDATE,''DY''))=upper('''||pday||''')
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE,B.STATE_CODE,B.COUNTRY_CODE)
        GROUP BY COMP_CODE,UNIT_CODE,STATE_CODE,COUNTRY_CODE
        ORDER BY COMP_CODE,UNIT_CODE,STATE_CODE';
insert into test1(vstring,vstring2) values('3 '||vquery3,VQUERY2);commit;
       open p_accounts1 for vquery3||vquery2;
        vquery3:='SELECT COMP_CODE,UNIT_CODE,'||vdaysup||','||vtotsup||'AS "TOTAL"'||
        ' FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,'||vquery1;
       vquery2:=' FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C
       WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''||PCOMP_CODE||''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE='''||PUNIT_CODE||''' AND
        A.AGCD=B.AGCD AND A.AGCD=NVL('''||PAGCODE||''',A.AGCD) AND A.DPCD=B.DPCD AND A.DPCD=NVL('''||PDPCODE||''',A.DPCD) AND 
        A.PUBL='''||PPUBL||''' AND (A.EDTN='''||PEDTN||''' OR '''||PEDTN||''' IS NULL) AND (B.CITY_CODE='''||PCITYCD||''' OR '''||PCITYCD ||''' IS NULL) AND
        (B.STATE_CODE='''||PSTATECD||''' OR '''||PSTATECD||''' IS NULL) AND (B.DIST_CODE='''||PDISTCODE||''' OR '''||PDISTCODE||''' IS NULL) AND 
        (B.TEHSIL_TALUKA='''||PTALUKA||''' OR '''||PTALUKA||''' IS NULL) AND (B.BRANCH_CODE='''||PBRANCH||''' OR '''||PBRANCH||''' IS NULL) AND
        (B.AG_TYPE='''||PAGTYPE||''' OR '''||PAGTYPE||''' IS NULL) AND (B.AG_CLASS='''||PAGCLASS||''' OR '''||PAGCLASS||''' IS NULL) AND 
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''||PEXTRA1||''' OR '''||PEXTRA1||''' IS NULL) AND A.SUPDATE >= '''||VFRDT||''' AND A.SUPDATE <= '''||VTODT||''' AND NVL(A.SUP_COPY,0)>0 AND upper(to_char(A.SUPDATE,''DY''))=upper('''||pday||''')
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE)
        GROUP BY COMP_CODE,UNIT_CODE
        ORDER BY COMP_CODE,UNIT_CODE';
insert into test1(vstring,vstring2) values('4 '||vquery3,VQUERY2);commit;        
       open p_accounts2 for vquery3||vquery2;
  End cir_rep_day_daybook;
  procedure cir_rep_dist_day_daybook(
     pcomp_code     in varchar2,
     punit_code     in varchar2,
     ppubl          in varchar2,
     pedtn          in varchar2,
     pcitycd        in varchar2,
     pstatecd       in varchar2,
     pmonth         in varchar2,
     pyear          in number,
     pday           in varchar2,
     pdateformat    in varchar2,
     pbranch        in varchar2,
     pdistcode      in varchar2,
     ptaluka        in varchar2,
     pagtype        in varchar2,
     pagclass       in varchar2,
     pagcode        in varchar2,
     pdpcode        in varchar2,
     pextra1        in varchar2,--it is used for supply type
     pextra2        in varchar2,
     pextra3        in varchar2,
     pextra4        in varchar2,
     pextra5        in varchar2,
     p_accounts     out t_accounts,
     p_accounts1    out t_accounts,
     p_accounts2    out t_accounts)
    As
     vquery1        varchar2(4000);
     vquery2        varchar2(12000);
     vquery3        varchar2(12000);
     vdaysup        varchar2(2000);
     vtotsup        varchar2(1000);
     vfrdt          date;
     vtodt          date;
     v_dt           date;
     v_day          varchar2(3);
     v_cnt          number:=0;
       cursor c1 is
           select dt,upper(to_char(dt,'DY')) supply_day from cir_temp_dt order by sqno,dt;
   Begin
       vfrdt:=to_date('01/'||pmonth||'/'||pyear,pdateformat);
       vtodt:=last_day(vfrdt);
    delete from cir_temp_dt;
    loop
        if v_dt>=vtodt then
            exit;
        else
            if v_dt is null then
                v_dt:=vfrdt;
            else
                v_dt:=v_dt+1;
            end if;
        end if;
           if upper(to_char(v_dt,'DY'))=upper(pday) then
               insert into cir_temp_dt(sqno,dt) values(1,v_dt);
           else
               insert into cir_temp_dt(sqno,dt) values(2,v_dt);
           end if;
    end loop;
    open c1;
    loop
        fetch c1 into v_dt,v_day;
        exit when c1%notfound;
        v_cnt        := v_cnt+1;
        if vquery1 is null then
            vquery1:='DECODE(TO_CHAR(A.SUPDATE,''DD''),'''||to_char(v_dt,'dd')||''',SUM(nvl(A.SUP_COPY,0))) P'||lpad(v_cnt,2,'0');
            vdaysup:='SUM(NVL(P'||lpad(v_cnt,2,'0')||',0)) AS '||'"'||lpad(v_cnt,2,'0')||'"';
            vtotsup:='NVL(P'||lpad(v_cnt,2,'0')||',0)';
        else
            vquery1:=vquery1||','||'DECODE(TO_CHAR(A.SUPDATE,''DD''),'''||to_char(v_dt,'dd')||''',SUM(nvl(A.SUP_COPY,0))) P'||lpad(v_cnt,2,'0');
            vdaysup:=vdaysup||','||'SUM(NVL(P'||lpad(v_cnt,2,'0')||',0)) AS '||'"'||lpad(v_cnt,2,'0')||'"';
            vtotsup:=vtotsup||'+'||'NVL(P'||lpad(v_cnt,2,'0')||',0)';
        end if;
    end loop;
    close c1;
    vtotsup:='SUM('||vtotsup||')';
    --insert into test1(vstring,vstring2) values('1 '||vquery1,vdaysup||','||vtotsup||'AS "TOTAL"');
    vquery3:='SELECT COMP_CODE,UNIT_CODE,AGCD "AGENCY CODE",DPCD "AGENCY SUBCODE",substr(cir_get_agency(comp_code,unit_code,agcd,dpcd),1,50) "AGENCY NAME",
    substr(cir_get_name.cir_agname(comp_code,unit_code,agcd,dpcd,2,'||''''||pdateformat||''''||','''',''''),1,50) "AGENCY ONAME",
       EDTN,CIR_GET_EDTN_NAME(COMP_CODE,EDTN) "EDITION NAME",nvl(CIR_GET_NAME.CIR_EDTN(COMP_CODE,'''',EDTN,2,'||''''||pdateformat||''''||','''',''''),''NA'') "EDITION ONAME",
       nvl(CITY_CODE,''NA'') "CITY CODE",nvl(CIR_GET_CITY(COMP_CODE,CITY_CODE),''NA'') "CITY NAME",nvl(CIR_GET_NAME.CIR_CITY(COMP_CODE,CITY_CODE,2,'||''''||pdateformat||''''||','''',''''),''NA'') "CITY ONAME",
       nvl(DIST_CODE,''NA'') "DIST CODE",nvl(CIR_GET_DIST(COMP_CODE,STATE_CODE,DIST_CODE),''NA'') "DISTRICT NAME",nvl(CIR_GET_NAME.CIR_DISTRICT(COMP_CODE,DIST_CODE,2,'||''''||pdateformat||''''||','''',''''),''NA'') "DISTRICT ONAME",
       COUNTRY_CODE "COUNTRY CODE",'||vdaysup||','||vtotsup||'AS "TOTAL"'||
       ' FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,MIN(A.EDTN) EDTN,B.CITY_CODE,B.STATE_CODE STATE_CODE,B.DIST_CODE DIST_CODE,B.COUNTRY_CODE COUNTRY_CODE,'||vquery1;
       vquery2:=' FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''||PCOMP_CODE||''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE='''||PUNIT_CODE||''' AND
        A.AGCD=B.AGCD AND A.AGCD=NVL('''||PAGCODE||''',A.AGCD) AND A.DPCD=B.DPCD AND A.DPCD=NVL('''||PDPCODE||''',A.DPCD) AND 
        A.PUBL='''||PPUBL||''' AND (A.EDTN='''||PEDTN||''' OR '''||PEDTN||''' IS NULL) AND (B.CITY_CODE='''||PCITYCD||''' OR '''||PCITYCD ||''' IS NULL) AND
        (B.STATE_CODE='''||PSTATECD||''' OR '''||PSTATECD||''' IS NULL) AND (B.DIST_CODE='''||PDISTCODE||''' OR '''||PDISTCODE||''' IS NULL) AND 
        (B.TEHSIL_TALUKA='''||PTALUKA||''' OR '''||PTALUKA||''' IS NULL) AND (B.BRANCH_CODE='''||PBRANCH||''' OR '''||PBRANCH||''' IS NULL) AND
        (B.AG_TYPE='''||PAGTYPE||''' OR '''||PAGTYPE||''' IS NULL) AND (B.AG_CLASS='''||PAGCLASS||''' OR '''||PAGCLASS||''' IS NULL) AND 
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''||PEXTRA1||''' OR '''||PEXTRA1||''' IS NULL) AND A.SUPDATE >= '''||VFRDT||''' AND A.SUPDATE <= '''||VTODT||''' AND NVL(A.SUP_COPY,0)>0  AND upper(to_char(A.SUPDATE,''DY''))=upper('''||pday||''')
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.AGCD,A.DPCD,A.SUPDATE,B.CITY_CODE,B.STATE_CODE,B.DIST_CODE,B.COUNTRY_CODE)
        GROUP BY COMP_CODE,UNIT_CODE,AGCD,DPCD,EDTN,CITY_CODE,STATE_CODE,DIST_CODE,COUNTRY_CODE
        ORDER BY COMP_CODE,UNIT_CODE,STATE_CODE,DIST_CODE,CITY_CODE,EDTN,AGCD,DPCD';
       --insert into test1(vstring,vstring2) values('2 '||vquery3,VQUERY2);commit;
       open p_accounts for vquery3||vquery2;
        vquery3:='SELECT COMP_CODE,UNIT_CODE,nvl(DIST_CODE,''NA'') "DIST CODE",nvl(CIR_GET_DIST(COMP_CODE,STATE_CODE,DIST_CODE),''NA'') "DISTRICT NAME",nvl(CIR_GET_NAME.CIR_DISTRICT(COMP_CODE,DIST_CODE,2,'||''''||pdateformat||''''||','''',''''),''NA'') "DISTRICT ONAME",COUNTRY_CODE "COUNTRY CODE",'||vdaysup||','||vtotsup||'AS "TOTAL"'||
        ' FROM (SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,B.STATE_CODE STATE_CODE,B.DIST_CODE DIST_CODE,B.COUNTRY_CODE COUNTRY_CODE,'||vquery1;
        vquery2:='  FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''||PCOMP_CODE||''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE='''||PUNIT_CODE||''' AND
        A.AGCD=B.AGCD AND A.AGCD=NVL('''||PAGCODE||''',A.AGCD) AND A.DPCD=B.DPCD AND A.DPCD=NVL('''||PDPCODE||''',A.DPCD) AND 
        A.PUBL='''||PPUBL||''' AND (A.EDTN='''||PEDTN||''' OR '''||PEDTN||''' IS NULL) AND (B.CITY_CODE='''||PCITYCD||''' OR '''||PCITYCD ||''' IS NULL) AND
        (B.STATE_CODE='''||PSTATECD||''' OR '''||PSTATECD||''' IS NULL) AND (B.DIST_CODE='''||PDISTCODE||''' OR '''||PDISTCODE||''' IS NULL) AND 
        (B.TEHSIL_TALUKA='''||PTALUKA||''' OR '''||PTALUKA||''' IS NULL) AND (B.BRANCH_CODE='''||PBRANCH||''' OR '''||PBRANCH||''' IS NULL) AND
        (B.AG_TYPE='''||PAGTYPE||''' OR '''||PAGTYPE||''' IS NULL) AND (B.AG_CLASS='''||PAGCLASS||''' OR '''||PAGCLASS||''' IS NULL) AND 
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''||PEXTRA1||''' OR '''||PEXTRA1||''' IS NULL) AND A.SUPDATE >= '''||VFRDT||''' AND A.SUPDATE <= '''||VTODT||''' AND NVL(A.SUP_COPY,0)>0  AND upper(to_char(A.SUPDATE,''DY''))=upper('''||pday||''')
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE,B.STATE_CODE,B.DIST_CODE,B.COUNTRY_CODE)
        GROUP BY COMP_CODE,UNIT_CODE,STATE_CODE,DIST_CODE,COUNTRY_CODE
        ORDER BY COMP_CODE,UNIT_CODE,DIST_CODE,STATE_CODE';
       open p_accounts1 for vquery3||vquery2;
        vquery3:='SELECT COMP_CODE,UNIT_CODE,'||vdaysup||','||vtotsup||'AS "TOTAL"'||
        ' FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,'||vquery1;
       vquery2:=' FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C
       WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''||PCOMP_CODE||''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE='''||PUNIT_CODE||''' AND
        A.AGCD=B.AGCD AND A.AGCD=NVL('''||PAGCODE||''',A.AGCD) AND A.DPCD=B.DPCD AND A.DPCD=NVL('''||PDPCODE||''',A.DPCD) AND 
        A.PUBL='''||PPUBL||''' AND (A.EDTN='''||PEDTN||''' OR '''||PEDTN||''' IS NULL) AND (B.CITY_CODE='''||PCITYCD||''' OR '''||PCITYCD ||''' IS NULL) AND
        (B.STATE_CODE='''||PSTATECD||''' OR '''||PSTATECD||''' IS NULL) AND (B.DIST_CODE='''||PDISTCODE||''' OR '''||PDISTCODE||''' IS NULL) AND 
        (B.TEHSIL_TALUKA='''||PTALUKA||''' OR '''||PTALUKA||''' IS NULL) AND (B.BRANCH_CODE='''||PBRANCH||''' OR '''||PBRANCH||''' IS NULL) AND
        (B.AG_TYPE='''||PAGTYPE||''' OR '''||PAGTYPE||''' IS NULL) AND (B.AG_CLASS='''||PAGCLASS||''' OR '''||PAGCLASS||''' IS NULL) AND 
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''||PEXTRA1||''' OR '''||PEXTRA1||''' IS NULL) AND 
        A.SUPDATE >= '''||VFRDT||''' AND A.SUPDATE <= '''||VTODT||''' AND NVL(A.SUP_COPY,0)>0  AND upper(to_char(A.SUPDATE,''DY''))=upper('''||pday||''')
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE)
        GROUP BY COMP_CODE,UNIT_CODE
        ORDER BY COMP_CODE,UNIT_CODE';
       open p_accounts2 for vquery3||vquery2;
   End cir_rep_dist_day_daybook;
  procedure cir_rep_taluka_day_daybook(
     pcomp_code     in varchar2,
     punit_code     in varchar2,
     ppubl          in varchar2,
     pedtn          in varchar2,
     pcitycd        in varchar2,
     pstatecd       in varchar2,
     pmonth         in varchar2,
     pyear          in number,
     pday           in varchar2,
     pdateformat    in varchar2,
     pbranch        in varchar2,
     pdistcode      in varchar2,
     ptaluka        in varchar2,
     pagtype        in varchar2,
     pagclass       in varchar2,
     pagcode        in varchar2,
     pdpcode        in varchar2,
     pextra1        in varchar2,--it is used for supply type
     pextra2        in varchar2,
     pextra3        in varchar2,
     pextra4        in varchar2,
     pextra5        in varchar2,
     p_accounts     out t_accounts,
     p_accounts1    out t_accounts,
     p_accounts2    out t_accounts)
    As
     vquery1        varchar2(4000);
     vquery2        varchar2(12000);
     vquery3        varchar2(12000);
     vdaysup        varchar2(2000);
     vtotsup        varchar2(1000);
     vfrdt          date;
     vtodt          date;
     v_dt           date;
     v_day          varchar2(3);
     v_cnt          number:=0;
       cursor c1 is
           select dt,upper(to_char(dt,'DY')) supply_day from cir_temp_dt order by sqno,dt;
   Begin
       vfrdt:=to_date('01/'||pmonth||'/'||pyear,pdateformat);
       vtodt:=last_day(vfrdt);
    delete from cir_temp_dt;
    loop
        if v_dt>=vtodt then
            exit;
        else
            if v_dt is null then
                v_dt:=vfrdt;
            else
                v_dt:=v_dt+1;
            end if;
        end if;
           if upper(to_char(v_dt,'DY'))=upper(pday) then
               insert into cir_temp_dt(sqno,dt) values(1,v_dt);
           else
               insert into cir_temp_dt(sqno,dt) values(2,v_dt);
           end if;
    end loop;
    open c1;
    loop
        fetch c1 into v_dt,v_day;
        exit when c1%notfound;
        v_cnt        := v_cnt+1;
        if vquery1 is null then
            vquery1:='DECODE(TO_CHAR(A.SUPDATE,''DD''),'''||to_char(v_dt,'dd')||''',SUM(nvl(A.SUP_COPY,0))) P'||lpad(v_cnt,2,'0');
            vdaysup:='SUM(NVL(P'||lpad(v_cnt,2,'0')||',0)) AS '||'"'||lpad(v_cnt,2,'0')||'"';
            vtotsup:='NVL(P'||lpad(v_cnt,2,'0')||',0)';
        else
            vquery1:=vquery1||','||'DECODE(TO_CHAR(A.SUPDATE,''DD''),'''||to_char(v_dt,'dd')||''',SUM(nvl(A.SUP_COPY,0))) P'||lpad(v_cnt,2,'0');
            vdaysup:=vdaysup||','||'SUM(NVL(P'||lpad(v_cnt,2,'0')||',0)) AS '||'"'||lpad(v_cnt,2,'0')||'"';
            vtotsup:=vtotsup||'+'||'NVL(P'||lpad(v_cnt,2,'0')||',0)';
        end if;
    end loop;
    close c1;
    vtotsup:='SUM('||vtotsup||')';
    --insert into test1(vstring,vstring2) values('1 '||vquery1,vdaysup||','||vtotsup||'AS "TOTAL"');
    vquery3:='SELECT COMP_CODE,UNIT_CODE,AGCD "AGENCY CODE",DPCD "AGENCY SUBCODE",substr(cir_get_agency(comp_code,unit_code,agcd,dpcd),1,50) "AGENCY NAME",
       substr(cir_get_name.cir_agname(comp_code,unit_code,agcd,dpcd,2,'||''''||pdateformat||''''||','''',''''),1,50) "AGENCY ONAME",
       EDTN,CIR_GET_EDTN_NAME(COMP_CODE,EDTN) "EDITION NAME",nvl(CIR_GET_NAME.CIR_EDTN(COMP_CODE,'''',EDTN,2,'||''''||pdateformat||''''||','''',''''),''NA'') "EDITION ONAME",
       nvl(CITY_CODE,''NA'') "CITY CODE",nvl(CIR_GET_CITY(COMP_CODE,CITY_CODE),''NA'') "CITY NAME",nvl(CIR_GET_NAME.CIR_CITY(COMP_CODE,CITY_CODE,2,'||''''||pdateformat||''''||','''',''''),''NA'') "CITY ONAME",
       nvl(TEHSIL_TALUKA,''NA'') "TALUKA CODE",nvl(CIR_GET_TALUKA(COMP_CODE,TEHSIL_TALUKA),''NA'') "TALUKA NAME",nvl(CIR_GET_NAME.CIR_TALUKA(COMP_CODE,TEHSIL_TALUKA,2,'||''''||pdateformat||''''||','''',''''),''NA'') "TALUKA ONAME",COUNTRY_CODE "COUNTRY CODE",'||vdaysup||','||vtotsup||'AS "TOTAL"'||
       ' FROM (SELECT A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,A.AGCD AGCD,A.DPCD DPCD,MIN(A.EDTN) EDTN,B.CITY_CODE,B.TEHSIL_TALUKA TEHSIL_TALUKA,B.COUNTRY_CODE COUNTRY_CODE,'||vquery1;
       vquery2:=' FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''||PCOMP_CODE||''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE='''||PUNIT_CODE||''' AND
        A.AGCD=B.AGCD AND A.AGCD=NVL('''||PAGCODE||''',A.AGCD) AND A.DPCD=B.DPCD AND A.DPCD=NVL('''||PDPCODE||''',A.DPCD) AND 
        A.PUBL='''||PPUBL||''' AND (A.EDTN='''||PEDTN||''' OR '''||PEDTN||''' IS NULL) AND (B.CITY_CODE='''||PCITYCD||''' OR '''||PCITYCD ||''' IS NULL) AND
        (B.STATE_CODE='''||PSTATECD||''' OR '''||PSTATECD||''' IS NULL) AND (B.DIST_CODE='''||PDISTCODE||''' OR '''||PDISTCODE||''' IS NULL) AND 
        (B.TEHSIL_TALUKA='''||PTALUKA||''' OR '''||PTALUKA||''' IS NULL) AND (B.BRANCH_CODE='''||PBRANCH||''' OR '''||PBRANCH||''' IS NULL) AND
        (B.AG_TYPE='''||PAGTYPE||''' OR '''||PAGTYPE||''' IS NULL) AND (B.AG_CLASS='''||PAGCLASS||''' OR '''||PAGCLASS||''' IS NULL) AND
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''||PEXTRA1||''' OR '''||PEXTRA1||''' IS NULL) AND 
        A.SUPDATE >= '''||VFRDT||''' AND A.SUPDATE <='''||VTODT||''' AND NVL(A.SUP_COPY,0)>0  AND upper(to_char(A.SUPDATE,''DY''))=upper('''||pday||''')
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.AGCD,A.DPCD,A.SUPDATE,B.CITY_CODE,TEHSIL_TALUKA,B.COUNTRY_CODE)
        GROUP BY COMP_CODE,UNIT_CODE,AGCD,DPCD,EDTN,CITY_CODE,TEHSIL_TALUKA,COUNTRY_CODE
        ORDER BY COMP_CODE,UNIT_CODE,TEHSIL_TALUKA,CITY_CODE,EDTN,AGCD,DPCD';
       --insert into test1(vstring,vstring2) values('2 '||vquery3,VQUERY2);commit;
       open p_accounts for vquery3||vquery2;
        vquery3:='SELECT COMP_CODE,UNIT_CODE,nvl(TEHSIL_TALUKA,''NA'') "TALUKA CODE",nvl(CIR_GET_TALUKA(COMP_CODE,TEHSIL_TALUKA),''NA'') "TALUKA NAME",nvl(CIR_GET_NAME.CIR_TALUKA(COMP_CODE,TEHSIL_TALUKA,2,'||''''||pdateformat||''''||','''',''''),''NA'') "TALUKA ONAME",COUNTRY_CODE "COUNTRY CODE",'||vdaysup||','||vtotsup||'AS "TOTAL"'||
        ' FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,B.TEHSIL_TALUKA TEHSIL_TALUKA,B.COUNTRY_CODE COUNTRY_CODE,'||vquery1;
        vquery2:='    FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C
        WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''||PCOMP_CODE||''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE='''||PUNIT_CODE||''' AND
        A.AGCD=B.AGCD AND A.AGCD=NVL('''||PAGCODE||''',A.AGCD) AND A.DPCD=B.DPCD AND A.DPCD=NVL('''||PDPCODE||''',A.DPCD) AND 
        A.PUBL='''||PPUBL||''' AND (A.EDTN='''||PEDTN||''' OR '''||PEDTN||''' IS NULL) AND (B.CITY_CODE='''||PCITYCD||''' OR '''||PCITYCD ||''' IS NULL) AND
        (B.STATE_CODE='''||PSTATECD||''' OR '''||PSTATECD||''' IS NULL) AND (B.DIST_CODE='''||PDISTCODE||''' OR '''||PDISTCODE||''' IS NULL) AND 
        (B.TEHSIL_TALUKA='''||PTALUKA||''' OR '''||PTALUKA||''' IS NULL) AND (B.BRANCH_CODE='''||PBRANCH||''' OR '''||PBRANCH||''' IS NULL) AND
        (B.AG_TYPE='''||PAGTYPE||''' OR '''||PAGTYPE||''' IS NULL) AND (B.AG_CLASS='''||PAGCLASS||''' OR '''||PAGCLASS||''' IS NULL) AND 
        A.SUP_TYPE_CODE=C.SUP_TY_CODE AND
        A.SUPDATE>= '''||VFRDT||''' AND A.SUPDATE <= '''||VTODT||''' AND NVL(A.SUP_COPY,0)>0  AND upper(to_char(A.SUPDATE,''DY''))=upper('''||pday||''')
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE,B.TEHSIL_TALUKA,B.COUNTRY_CODE)
        GROUP BY COMP_CODE,UNIT_CODE,TEHSIL_TALUKA,COUNTRY_CODE
        ORDER BY COMP_CODE,UNIT_CODE,TEHSIL_TALUKA';
       open p_accounts1 for vquery3||vquery2;
        vquery3:='SELECT COMP_CODE,UNIT_CODE,'||vdaysup||','||vtotsup||'AS "TOTAL"'||
        ' FROM (SELECT     A.COMP_CODE COMP_CODE,A.UNIT_CODE UNIT_CODE,'||vquery1;
       vquery2:=' FROM CIR_DBKSUP A,CIR_AGMAST B,CIR_SUPPLY_TYPE_MAST C
       WHERE A.COMP_CODE=B.COMP_CODE AND A.COMP_CODE=C.COMP_CODE AND A.COMP_CODE='''||PCOMP_CODE||''' AND A.UNIT_CODE=B.UNIT AND A.UNIT_CODE='''||PUNIT_CODE||''' AND
        A.AGCD=B.AGCD AND A.AGCD=NVL('''||PAGCODE||''',A.AGCD) AND A.DPCD=B.DPCD AND A.DPCD=NVL('''||PDPCODE||''',A.DPCD) AND 
        A.PUBL='''||PPUBL||''' AND (A.EDTN='''||PEDTN||''' OR '''||PEDTN||''' IS NULL) AND (B.CITY_CODE='''||PCITYCD||''' OR '''||PCITYCD ||''' IS NULL) AND
        (B.STATE_CODE='''||PSTATECD||''' OR '''||PSTATECD||''' IS NULL) AND (B.DIST_CODE='''||PDISTCODE||''' OR '''||PDISTCODE||''' IS NULL) AND 
        (B.TEHSIL_TALUKA='''||PTALUKA||''' OR '''||PTALUKA||''' IS NULL) AND (B.BRANCH_CODE='''||PBRANCH||''' OR '''||PBRANCH||''' IS NULL) AND
        (B.AG_TYPE='''||PAGTYPE||''' OR '''||PAGTYPE||''' IS NULL) AND (B.AG_CLASS='''||PAGCLASS||''' OR '''||PAGCLASS||''' IS NULL) AND
         A.SUP_TYPE_CODE=C.SUP_TY_CODE AND (A.SUP_TYPE_CODE='''||PEXTRA1||''' OR '''||PEXTRA1||''' IS NULL) AND 
        A.SUPDATE>= '''||VFRDT||''' AND A.SUPDATE <= '''||VTODT||''' AND NVL(A.SUP_COPY,0)>0  AND upper(to_char(A.SUPDATE,''DY''))=upper('''||pday||''')
        GROUP BY A.COMP_CODE,A.UNIT_CODE,A.SUPDATE)
        GROUP BY COMP_CODE,UNIT_CODE
        ORDER BY COMP_CODE,UNIT_CODE';
       open p_accounts2 for vquery3||vquery2;
   End cir_rep_taluka_day_daybook;
  Procedure cir_rep_route_challan(
     pcomp_code     in varchar2,
     punit_code     in varchar2,
     pperiod        in number,
     prmode         in varchar2,
     psupdate       in varchar2,
     pdateformat    in varchar2,
     pextra1        in varchar2,
     pextra2        in varchar2,
     p_accounts     out t_accounts)
  As
      vsupdate date;
     cursor cur_edtn is
         select distinct edtn,edtn_seq_no from cir_edtn_mast where comp_code=pcomp_code and edtn in(select distinct edtn--'sum(decode(edtn,'||''''||edtn||''''||')) '||edtn||',' vty,
      from cir_lblmast where comp_code=pcomp_code and unit_code     = punit_code and
                  publ in (select publ from cir_publ_mast
                      where comp_code = pcomp_code and
                            period    = pperiod) and route in (select route_code from cir_route_mast
                            where comp_code = pcomp_code and
                                  unit_code = punit_code and
                                  ((route_mode = prmode) or (prmode is null))) and lbl_dt   = vsupdate)
      order by edtn_seq_no,edtn;
     rec_edtn cur_edtn%rowtype;
     vvar       varchar2(4000);
     vquery     varchar2(4000);
  Begin
    --insert into test1(vstring,vstring2) values('1111 '||vvar,' vsupdate '||vsupdate||' pdateformat '||pdateformat||' psupdate '||psupdate);commit;
    vsupdate:=to_date(psupdate,''''||pdateformat||'''');
    --insert into test1(vstring,vstring2) values('2222 '||vvar,' vsupdate '||vsupdate||' pdateformat '||pdateformat||' psupdate '||psupdate);commit;
    open cur_edtn;
    loop
        fetch cur_edtn into rec_edtn;
      exit when cur_edtn%notfound;
                if vvar is null then
              vvar:='sum(decode(edtn,'||''''||rec_edtn.edtn||''''||',supply_1,0))"'||cir_get_edtnnm_rate(pcomp_code,punit_code,rec_edtn.edtn,psupdate,pdateformat)||'"';--'sum(decode(edtn,'||''''||cir_get_edtnnm_rate(pcomp_code,punit_code,rec_edtn.edtn,psupdate,pdateformat)||''''||',supply_1,0))"'||cir_get_edtnnm_rate(pcomp_code,punit_code,rec_edtn.edtn,psupdate,pdateformat)||'"';
                else
                    vvar:=vvar||','||'sum(decode(edtn,'||''''||rec_edtn.edtn||''''||',supply_1,0))"'||cir_get_edtnnm_rate(pcomp_code,punit_code,rec_edtn.edtn,psupdate,pdateformat)||'"';
                end if;
    end loop;
    close cur_edtn;
    --vvar:=substr(vvar,1,length(vvar)-1);
    --insert into test1(vstring,vstring2) values('1 '||vvar,' vsupdate '||vsupdate);commit;
        if vvar is null then
            vquery:='select a.route "ROUTE CODE",cir_get_route_name(a.comp_code,a.unit_code,a.route) "ROUTE NAME",a.subrt "SUB ROUTE",cir_get_subroute_name(a.comp_code,a.unit_code,a.route,a.subrt) "SUBROUTE NAME",a.sub_subrt "SUB SUBROUTE",cir_get_sub_subroute_name(a.comp_code,a.unit_code,a.route,a.subrt,a.sub_subrt) "SUB SUBROUTE NAME",a.agcd "AGENCY CODE",a.dpcd "AGENCY SUBCODE",b.ag_name "AGENCY NAME",b.city_code "CITY CODE",cir_get_city(b.comp_code,b.city_code) "CITY NAME",max(a.lbl_sno) "TOTAL PACKET" from cir_lblmast a,cir_agmast b--sum(a.SUPPLY_1) "SUPPLY COPY",
                where a.comp_code = b.comp_code and a.unit_code = b.unit and a.agcd = b.agcd and a.dpcd = b.dpcd and a.comp_code = '||''''||pcomp_code||''''||' and a.unit_code = '||''''||punit_code||''''||' and a.publ in (select publ from cir_publ_mast where comp_code = '||''''||pcomp_code||''''||' and period = '||''''||pperiod||''''||') and a.route in (select route_code from cir_route_mast where comp_code = '||''''||pcomp_code||''''||' and ((route_mode = '||''''||prmode||''''||') or ('||''''||prmode||''''||' is null))) and a.lbl_dt = '||''''||vsupdate||''''||' group by a.route,cir_get_route_name(a.comp_code,a.unit_code,a.route),a.subrt,cir_get_subroute_name(a.comp_code,a.unit_code,a.route,a.subrt),a.sub_subrt,cir_get_sub_subroute_name(a.comp_code,a.unit_code,a.route,a.subrt,a.sub_subrt),a.agcd,a.dpcd,b.ag_name,b.city_code,cir_get_city(b.comp_code,b.city_code),a.edtn order by a.route,a.subrt,a.sub_subrt,b.ag_name';--,'||vvar||'
        else
            vquery:='select a.route "ROUTE CODE",cir_get_route_name(a.comp_code,a.unit_code,a.route) "ROUTE NAME",a.subrt "SUB ROUTE",cir_get_subroute_name(a.comp_code,a.unit_code,a.route,a.subrt) "SUBROUTE NAME",a.sub_subrt "SUB SUBROUTE",cir_get_sub_subroute_name(a.comp_code,a.unit_code,a.route,a.subrt,a.sub_subrt) "SUB SUBROUTE NAME",a.agcd "AGENCY CODE",a.dpcd "AGENCY SUBCODE",b.ag_name "AGENCY NAME",b.city_code "CITY CODE",cir_get_city(b.comp_code,b.city_code) "CITY NAME",max(a.lbl_sno) "TOTAL PACKET",'||vvar||'from cir_lblmast a,cir_agmast b--sum(a.SUPPLY_1) "SUPPLY COPY",
                where a.comp_code = b.comp_code and a.unit_code = b.unit and a.agcd = b.agcd and a.dpcd = b.dpcd and a.comp_code = '||''''||pcomp_code||''''||' and a.unit_code = '||''''||punit_code||''''||' and a.publ in (select publ from cir_publ_mast where comp_code = '||''''||pcomp_code||''''||' and period = '||''''||pperiod||''''||') and a.route in (select route_code from cir_route_mast where comp_code = '||''''||pcomp_code||''''||' and ((route_mode = '||''''||prmode||''''||') or ('||''''||prmode||''''||' is null))) and a.lbl_dt = '||''''||vsupdate||''''||' group by a.route,cir_get_route_name(a.comp_code,a.unit_code,a.route),a.subrt,cir_get_subroute_name(a.comp_code,a.unit_code,a.route,a.subrt),a.sub_subrt,cir_get_sub_subroute_name(a.comp_code,a.unit_code,a.route,a.subrt,a.sub_subrt),a.agcd,a.dpcd,b.ag_name,b.city_code,cir_get_city(b.comp_code,b.city_code),a.edtn order by a.route,a.subrt,a.sub_subrt,b.ag_name';--,'||vvar||'
        end if;
    --insert into test1(vstring,vstring2) values('2 '||vquery,null);commit;
    open p_accounts for vquery;
  End cir_rep_route_challan;
procedure cir_rep_dist_challan(
   pcomp_code       in varchar2,
   punit_code       in varchar2,
   pperiod          in number,
   prmode           in varchar2,
   psupdate         in varchar2,
   pdateformat      in varchar2,
   pextra1          in varchar2,
   pextra2          in varchar2,
   p_accounts       out t_accounts)
   As
     vsupdate date;
     cursor cur_edtn is
         select distinct edtn,edtn_seq_no from cir_edtn_mast where comp_code=pcomp_code and edtn in(select distinct edtn_1--'sum(decode(edtn,'||''''||edtn||''''||')) '||edtn||',' vty,
      from cir_lblmast where comp_code=pcomp_code and unit_code     = punit_code and
                  publ in (select publ from cir_publ_mast
                      where comp_code = pcomp_code and
                            period    = pperiod) and route in (select route_code from cir_route_mast
                            where comp_code = pcomp_code and
                                  unit_code = punit_code and
                                  ((route_mode = prmode) or (prmode is null))) and lbl_dt   = vsupdate)
      order by edtn_seq_no,edtn;
     rec_edtn cur_edtn%rowtype;
     vvar         varchar2(4000);
     vquery     varchar2(4000);
Begin
    vsupdate:=to_date(psupdate,''''||pdateformat||'''');
    open cur_edtn;
    loop
        fetch cur_edtn into rec_edtn;
      exit when cur_edtn%notfound;
                if vvar is null then
              vvar:='sum(decode(edtn,'||''''||rec_edtn.edtn||''''||',supply_1,0))"'||cir_get_edtnnm_rate(pcomp_code,punit_code,rec_edtn.edtn,psupdate,pdateformat)||'"';--'sum(decode(edtn,'||''''||cir_get_edtnnm_rate(pcomp_code,punit_code,rec_edtn.edtn,psupdate,pdateformat)||''''||',supply_1,0))"'||cir_get_edtnnm_rate(pcomp_code,punit_code,rec_edtn.edtn,psupdate,pdateformat)||'"';
                else
                    vvar:=vvar||','||'sum(decode(edtn,'||''''||rec_edtn.edtn||''''||',supply_1,0))"'||cir_get_edtnnm_rate(pcomp_code,punit_code,rec_edtn.edtn,psupdate,pdateformat)||'"';
                end if;
    end loop;
    close cur_edtn;
        if vvar is null then
            vquery:='select b.dist_code "DISTRICT CODE",cir_get_dist(b.comp_code,b.state_code,b.dist_code) "DISTRICT NAME",a.agcd "AGENCY CODE",a.dpcd "AGENCY SUBCODE",b.ag_name "AGENCY NAME",b.city_code "CITY CODE",cir_get_city(b.comp_code,b.city_code) "CITY NAME",max(a.lbl_sno) "TOTAL PACKET" from cir_lblmast a,cir_agmast b--sum(a.SUPPLY_1) "SUPPLY COPY",
                where a.comp_code = b.comp_code and a.unit_code = b.unit and a.agcd = b.agcd and a.dpcd = b.dpcd and a.comp_code = '||''''||pcomp_code||''''||' and a.unit_code = '||''''||punit_code||''''||' and a.publ in (select publ from cir_publ_mast where comp_code = '||''''||pcomp_code||''''||' and period = '||''''||pperiod||''''||') and a.route in (select route_code from cir_route_mast where comp_code = '||''''||pcomp_code||''''||' and ((route_mode = '||''''||prmode||''''||') or ('||''''||prmode||''''||' is null))) and a.lbl_dt = '||''''||vsupdate||''''||' group by b.dist_code,cir_get_dist(b.comp_code,b.state_code,b.dist_code),a.agcd,a.dpcd,b.ag_name,b.city_code,cir_get_city(b.comp_code,b.city_code),a.edtn order by b.dist_code,b.ag_name';--,'||vvar||'
        else
            vquery:='select b.dist_code "DISTRICT CODE",cir_get_dist(b.comp_code,b.state_code,b.dist_code) "DISTRICT NAME",a.agcd "AGENCY CODE",a.dpcd "AGENCY SUBCODE",b.ag_name "AGENCY NAME",b.city_code "CITY CODE",cir_get_city(b.comp_code,b.city_code) "CITY NAME",max(a.lbl_sno) "TOTAL PACKET",'||vvar||'from cir_lblmast a,cir_agmast b--sum(a.SUPPLY_1) "SUPPLY COPY",
                where a.comp_code = b.comp_code and a.unit_code = b.unit and a.agcd = b.agcd and a.dpcd = b.dpcd and a.comp_code = '||''''||pcomp_code||''''||' and a.unit_code = '||''''||punit_code||''''||' and a.publ in (select publ from cir_publ_mast where comp_code = '||''''||pcomp_code||''''||' and period = '||''''||pperiod||''''||') and a.route in (select route_code from cir_route_mast where comp_code = '||''''||pcomp_code||''''||' and ((route_mode = '||''''||prmode||''''||') or ('||''''||prmode||''''||' is null))) and a.lbl_dt = '||''''||vsupdate||''''||' group by b.dist_code,cir_get_dist(b.comp_code,b.state_code,b.dist_code),a.agcd,a.dpcd,b.ag_name,b.city_code,cir_get_city(b.comp_code,b.city_code),a.edtn order by b.dist_code,b.ag_name';--,'||vvar||'
        end if;
    --insert into test1(vstring,vstring2) values('DIST '||vquery,null);commit;
    open p_accounts for vquery;
  End cir_rep_dist_challan;
    procedure cir_rep_taluka_challan(
        pcomp_code     in varchar2,
        punit_code     in varchar2,
        pperiod        in number,
        prmode         in varchar2,
        psupdate       in varchar2,
        pdateformat    in varchar2,
        pextra1        in varchar2,
        pextra2        in varchar2,
        p_accounts     out t_accounts)
     As
     vsupdate date;
     cursor cur_edtn is
         select distinct edtn,edtn_seq_no from cir_edtn_mast where comp_code=pcomp_code and edtn in(select distinct edtn--'sum(decode(edtn,'||''''||edtn||''''||')) '||edtn||',' vty,
      from cir_lblmast where comp_code=pcomp_code and unit_code     = punit_code and
                  publ in (select publ from cir_publ_mast
                      where comp_code = pcomp_code and
                            period    = pperiod) and route in (select route_code from cir_route_mast
                            where comp_code = pcomp_code and
                                  unit_code = punit_code and
                                  ((route_mode = prmode) or (prmode is null))) and lbl_dt   = vsupdate)
      order by edtn_seq_no,edtn;
     rec_edtn cur_edtn%rowtype;
     vvar         varchar2(4000);
     vquery     varchar2(4000);
    Begin
        vsupdate:=to_date(psupdate,''''||pdateformat||'''');
        open cur_edtn;
        loop
            fetch cur_edtn into rec_edtn;
          exit when cur_edtn%notfound;
                    if vvar is null then
                  vvar:='sum(decode(edtn,'||''''||rec_edtn.edtn||''''||',supply_1,0))"'||cir_get_edtnnm_rate(pcomp_code,punit_code,rec_edtn.edtn,psupdate,pdateformat)||'"';--'sum(decode(edtn,'||''''||cir_get_edtnnm_rate(pcomp_code,punit_code,rec_edtn.edtn,psupdate,pdateformat)||''''||',supply_1,0))"'||cir_get_edtnnm_rate(pcomp_code,punit_code,rec_edtn.edtn,psupdate,pdateformat)||'"';
                    else
                        vvar:=vvar||','||'sum(decode(edtn,'||''''||rec_edtn.edtn||''''||',supply_1,0))"'||cir_get_edtnnm_rate(pcomp_code,punit_code,rec_edtn.edtn,psupdate,pdateformat)||'"';
                    end if;
        end loop;
        close cur_edtn;
        if vvar is null then
        vquery:='select b.tehsil_taluka "TALUKA CODE",cir_get_taluka(b.comp_code,b.tehsil_taluka) "TALUKA NAME",a.agcd "AGENCY CODE",a.dpcd "AGENCY SUBCODE",b.ag_name "AGENCY NAME",b.city_code "CITY CODE",cir_get_city(b.comp_code,b.city_code) "CITY NAME",max(a.lbl_sno) "TOTAL PACKET" from cir_lblmast a,cir_agmast b--sum(a.SUPPLY_1) "SUPPLY COPY",
            where a.comp_code = b.comp_code and a.unit_code = b.unit and a.agcd = b.agcd and a.dpcd = b.dpcd and a.comp_code = '||''''||pcomp_code||''''||' and a.unit_code = '||''''||punit_code||''''||' and a.publ in (select publ from cir_publ_mast where comp_code = '||''''||pcomp_code||''''||' and period = '||''''||pperiod||''''||') and a.route in (select route_code from cir_route_mast where comp_code = '||''''||pcomp_code||''''||' and ((route_mode = '||''''||prmode||''''||') or ('||''''||prmode||''''||' is null))) and a.lbl_dt = '||''''||vsupdate||''''||' group by b.tehsil_taluka,cir_get_taluka(b.comp_code,b.tehsil_taluka),a.agcd,a.dpcd,b.ag_name,b.city_code,cir_get_city(b.comp_code,b.city_code),a.edtn order by b.tehsil_taluka,b.ag_name';--,'||vvar||'
        else
        vquery:='select b.tehsil_taluka "TALUKA CODE",cir_get_taluka(b.comp_code,b.tehsil_taluka) "TALUKA NAME",a.agcd "AGENCY CODE",a.dpcd "AGENCY SUBCODE",b.ag_name "AGENCY NAME",b.city_code "CITY CODE",cir_get_city(b.comp_code,b.city_code) "CITY NAME",max(a.lbl_sno) "TOTAL PACKET",'||vvar||'from cir_lblmast a,cir_agmast b--sum(a.SUPPLY_1) "SUPPLY COPY",
            where a.comp_code = b.comp_code and a.unit_code = b.unit and a.agcd = b.agcd and a.dpcd = b.dpcd and a.comp_code = '||''''||pcomp_code||''''||' and a.unit_code = '||''''||punit_code||''''||' and a.publ in (select publ from cir_publ_mast where comp_code = '||''''||pcomp_code||''''||' and period = '||''''||pperiod||''''||') and a.route in (select route_code from cir_route_mast where comp_code = '||''''||pcomp_code||''''||' and ((route_mode = '||''''||prmode||''''||') or ('||''''||prmode||''''||' is null))) and a.lbl_dt = '||''''||vsupdate||''''||' group by b.tehsil_taluka,cir_get_taluka(b.comp_code,b.tehsil_taluka),a.agcd,a.dpcd,b.ag_name,b.city_code,cir_get_city(b.comp_code,b.city_code),a.edtn order by b.tehsil_taluka,b.ag_name';--,'||vvar||'
        end if;
        --insert into tes t1(vstring,vstring2) values('TALUKA '||vquery,null);commit;
        open p_accounts for vquery;
    End cir_rep_taluka_challan;
    procedure cir_route_wise_supply(
        pcomp_code     in varchar2,
        punit_code     in varchar2,
        ppubl          in varchar2,
        pmainedtn      in varchar2,
        pedtn          in varchar2,
        proute         in varchar2,
        pfrom_supdate  in varchar2,
        ptill_supdate  in varchar2,
        pdateformat    in varchar2,
        pextra1            in varchar2,--for login user id
        pextra2            in varchar2,-------supply type
        pextra3            in varchar2,-------agency type
        pextra4            in varchar2,-------agency class
        pextra5            in varchar2, 
        pextra6            in varchar2,
        p_accounts     out t_accounts,
        p_accounts1    out t_accounts,
        p_accounts2    out t_accounts,
        p_accounts3    out t_accounts)
     As
        vfrom_supdate    date;
        vtill_supdate    date;
     Begin
       vfrom_supdate:=to_date(pfrom_supdate,''''||pdateformat||'''');
       vtill_supdate:=to_date(ptill_supdate,''''||pdateformat||'''');
       open p_accounts for
       select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
               d.route_code AS "ROUTE_CODE",cir_get_route_name(d.comp_code,d.unit_code,d.route_code) AS "ROUTE_NAME",
               d.agcd AS "AGCD",d.dpcd AS "DPCD",m.ag_name AS "AG_NAME",m.ag_name_oth_lang AS "AG_NAME_OTH_LANG",sum(d.sup_copy) AS "SUP_COPY",
               cir_get_route_seqno(d.comp_code,d.unit_code,d.route_code) AS "ROUTE_SEQNO",
               cir_get_supply_seqno(d.comp_code,d.unit_code,ppubl,pedtn,d.agcd,d.dpcd) AS "SUPPLY_SEQNO",
               cir_get_name.cir_route(d.comp_code,d.unit_code,d.route_code,2,null,null,null) AS "ROUTE_OTH_NAME",
               cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",
               cir_get_name.cir_city(d.comp_code,m.city_code,2,null,null,null) as "CITY_ONAME",
               cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME",
               cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) as "DROP_POINT_ONAME"
               from cir_dbksup d,cir_agmast m,cir_edtn_mast e
               where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
                     d.unit_code    = m.unit and
                     d.agcd         = m.agcd and
                     d.dpcd         = m.dpcd and
                     d.comp_code    = pcomp_code and
                     d.unit_code    = punit_code and
                     d.publ         = e.publ and d.publ         = ppubl and
                     d.edtn=e.edtn and (d.edtn       = pedtn or pedtn is null) and
                     (d.route_code = proute or proute is null) and
                     d.supdate between vfrom_supdate and vtill_supdate and
                     (e.main_edtn=pmainedtn or pmainedtn is null) and 
                     (d.sup_type_code=pextra2 or pextra2 is null) and 
                     (m.ag_type=pextra3 or pextra3 is null) and 
                     (m.ag_class=pextra4 or pextra4 is null)
                  group by d.comp_code,d.unit_code,d.route_code,
                           d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code
                  order by d.comp_code,d.unit_code,route_seqno,d.route_code,supply_seqno ,d.agcd,d.dpcd;
       open p_accounts1 for
        select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
               d.route_code AS "ROUTE_CODE",cir_get_route_name(d.comp_code,d.unit_code,d.route_code) AS "ROUTE_NAME",
               sum(d.sup_copy) AS "SUP_COPY",
               cir_get_route_seqno(d.comp_code,d.unit_code,d.route_code) AS "ROUTE_SEQNO",
               cir_get_name.cir_route(d.comp_code,d.unit_code,d.route_code,2,null,null,null) AS "ROUTE_OTH_NAME"
               from cir_dbksup d,cir_agmast m,cir_edtn_mast e
               where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
                     d.unit_code    = m.unit and
                     d.agcd         = m.agcd and
                     d.dpcd         = m.dpcd and
                     d.comp_code    = pcomp_code and
                     d.unit_code    = punit_code and
                     d.publ         = e.publ and d.publ         = ppubl and
                     d.edtn=e.edtn and (d.edtn       = pedtn or pedtn is null) and
                     (d.route_code = proute or proute is null) and
                     d.supdate between vfrom_supdate and vtill_supdate and
                     (e.main_edtn=pmainedtn or pmainedtn is null) and 
                     (m.ag_type=pextra3 or pextra3 is null) and 
                     (m.ag_class=pextra4 or pextra4 is null)
                  group by d.comp_code,d.unit_code,d.route_code
                  order by d.comp_code,d.unit_code,route_seqno,d.route_code;
       open p_accounts2 for
        select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
               sum(d.sup_copy) AS "SUP_COPY"
               from cir_dbksup d,cir_agmast m,cir_edtn_mast e
               where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
                     d.unit_code    = m.unit and
                     d.agcd         = m.agcd and
                     d.dpcd         = m.dpcd and
                     d.comp_code    = pcomp_code and
                     d.unit_code    = punit_code and
                     d.publ         = e.publ and d.publ         = ppubl and
                     d.edtn=e.edtn and (d.edtn       = pedtn or pedtn is null) and
                     (d.route_code = proute or proute is null) and
                     d.supdate between vfrom_supdate and vtill_supdate and
                     (e.main_edtn=pmainedtn or pmainedtn is null) and 
                     (m.ag_type=pextra3 or pextra3 is null) and 
                     (m.ag_class=pextra4 or pextra4 is null)
                  group by d.comp_code,d.unit_code
                  order by d.comp_code,d.unit_code;
       open p_accounts3 for
       select d.comp_code as "COMP_CODE",sum(d.sup_copy) AS "SUP_COPY",max(sup_rate) as "COPY_RATE"
               from cir_dbksup d,cir_agmast m,cir_edtn_mast e
               where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
                     d.unit_code    = m.unit and
                     d.agcd         = m.agcd and
                     d.dpcd         = m.dpcd and
                     d.comp_code    = pcomp_code and
                     d.unit_code    = punit_code and
                     d.publ         = e.publ and d.publ         = ppubl and
                     d.edtn=e.edtn and (d.edtn       = pedtn or pedtn is null) and
                     (d.route_code = proute or proute is null) and
                     d.supdate between vfrom_supdate and vtill_supdate and
                     (e.main_edtn=pmainedtn or pmainedtn is null) and 
                     (m.ag_type=pextra3 or pextra3 is null) and 
                     (m.ag_class=pextra4 or pextra4 is null)
                  group by d.comp_code
                  order by d.comp_code;
    End cir_route_wise_supply;
    procedure cir_dist_wise_supply(
     pcomp_code     in varchar2,
     punit_code     in varchar2,
     ppubl          in varchar2,
     pmainedtn      in varchar2,
     pedtn          in varchar2,
     proute         in varchar2,
     pfrom_supdate  in varchar2,
     ptill_supdate  in varchar2,
     pdateformat    in varchar2,
     pextra1            in varchar2,--for login user id
     pextra2            in varchar2,-------agency class
     pextra3            in varchar2,-------supply type 
     pextra4            in varchar2,-------agency type
     p_accounts     out t_accounts,
     p_accounts1    out t_accounts,
     p_accounts2    out t_accounts,
     p_accounts3    out t_accounts)
     as
     vfrom_supdate  date;
     vtill_supdate  date;
     Begin
       vfrom_supdate:=to_date(pfrom_supdate,''''||pdateformat||'''');
       vtill_supdate:=to_date(ptill_supdate,''''||pdateformat||'''');
       open p_accounts for
        select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
               m.dist_code AS "DIST_CODE",cir_get_dist(d.comp_code,m.state_code,m.dist_code) AS "DIST_NAME",
               d.agcd AS "AGCD",d.dpcd AS "DPCD",m.ag_name AS "AG_NAME",m.ag_name_oth_lang AS "AG_NAME_OTH_LANG",sum(d.sup_copy) AS "SUP_COPY",
               cir_get_name.cir_district(d.comp_code,m.dist_code,2,null,null,null) AS "DIST_OTH_NAME", 
               cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",
               cir_get_name.cir_city(d.comp_code,m.city_code,2,null,null,null) as "CITY_ONAME",
               cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME",
               cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) as "DROP_POINT_ONAME"
               from cir_dbksup d,cir_agmast m,cir_edtn_mast e
               where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
                     d.unit_code    = m.unit and
                     d.agcd         = m.agcd and
                     d.dpcd         = m.dpcd and
                     d.comp_code    = pcomp_code and
                     d.unit_code    = punit_code and
                     d.publ         = e.publ and d.publ         = ppubl and
                     d.edtn=e.edtn and (d.edtn       = pedtn or pedtn is null) and
                     (m.dist_code = proute or proute is null) and
                     d.supdate between vfrom_supdate and vtill_supdate and
                     (e.main_edtn=pmainedtn or pmainedtn is null) and 
                     (m.ag_class=pextra2 or pextra2 is null) and 
                    (d.sup_type_code=pextra3 or pextra3 is null) and 
                    (m.ag_type=pextra4 or pextra4 is null)                     
                  group by d.comp_code,d.unit_code,m.dist_code,m.state_code,
                           d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code
                  order by comp_code,unit_code,dist_name,ag_name,agcd,dpcd;
       open p_accounts1 for
        select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
               m.dist_code AS "DIST_CODE",cir_get_dist(d.comp_code,m.state_code,m.dist_code) AS "DIST_NAME",
               sum(d.sup_copy) AS "SUP_COPY",
               cir_get_name.cir_district(d.comp_code,m.dist_code,2,null,null,null) AS "DIST_OTH_NAME" 
               from cir_dbksup d,cir_agmast m,cir_edtn_mast e
               where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
                     d.unit_code    = m.unit and
                     d.agcd         = m.agcd and
                     d.dpcd         = m.dpcd and
                     d.comp_code    = pcomp_code and
                     d.unit_code    = punit_code and
                     d.publ         = e.publ and d.publ         = ppubl and
                     d.edtn=e.edtn and (d.edtn       = pedtn or pedtn is null) and
                     (m.dist_code = proute or proute is null) and
                     d.supdate between vfrom_supdate and vtill_supdate and
                     (e.main_edtn=pmainedtn or pmainedtn is null) and 
                      (m.ag_class=pextra2 or pextra2 is null) and 
                    (d.sup_type_code=pextra3 or pextra3 is null) and 
                    (m.ag_type=pextra4 or pextra4 is null)         
                  group by d.comp_code,d.unit_code,m.dist_code,m.state_code
                  order by comp_code,unit_code,dist_name;
       open p_accounts2 for
        select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",sum(d.sup_copy) AS "SUP_COPY"
               from cir_dbksup d,cir_agmast m,cir_edtn_mast e
               where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
                     d.unit_code    = m.unit and
                     d.agcd         = m.agcd and
                     d.dpcd         = m.dpcd and
                     d.comp_code    = pcomp_code and
                     d.unit_code    = punit_code and
                     d.publ         = e.publ and d.publ         = ppubl and
                     d.edtn=e.edtn and (d.edtn       = pedtn or pedtn is null) and
                     (m.dist_code = proute or proute is null) and
                     d.supdate between vfrom_supdate and vtill_supdate and
                     (e.main_edtn=pmainedtn or pmainedtn is null) and 
                      (m.ag_class=pextra2 or pextra2 is null) and 
                    (d.sup_type_code=pextra3 or pextra3 is null) and 
                    (m.ag_type=pextra4 or pextra4 is null)         
                  group by d.comp_code,d.unit_code
                  order by comp_code,unit_code;
       open p_accounts3 for
       select d.comp_code as "COMP_CODE",sum(d.sup_copy) AS "SUP_COPY",max(sup_rate) as "COPY_RATE"
               from cir_dbksup d,cir_agmast m,cir_edtn_mast e
               where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
                     d.unit_code    = m.unit and
                     d.agcd         = m.agcd and
                     d.dpcd         = m.dpcd and
                     d.comp_code    = pcomp_code and
                     d.unit_code    = punit_code and
                     d.publ         = e.publ and d.publ         = ppubl and
                     d.edtn=e.edtn and (d.edtn       = pedtn or pedtn is null) and
                     (m.dist_code = proute or proute is null) and
                     d.supdate between vfrom_supdate and vtill_supdate and
                     (e.main_edtn=pmainedtn or pmainedtn is null) and 
                      (m.ag_class=pextra2 or pextra2 is null) and 
                    (d.sup_type_code=pextra3 or pextra3 is null) and 
                    (m.ag_type=pextra4 or pextra4 is null)         
                  group by d.comp_code
                  order by comp_code;
  End cir_dist_wise_supply;
    procedure cir_taluka_wise_supply(
     pcomp_code     in varchar2,
     punit_code     in varchar2,
     ppubl          in varchar2,
     pmainedtn      in varchar2,
     pedtn          in varchar2,
     proute         in varchar2,
     pfrom_supdate  in varchar2,
     ptill_supdate  in varchar2,
     pdateformat    in varchar2,
     pextra1            in varchar2,--for login user id
     pextra2            in varchar2,-------agency class
     pextra3            in varchar2,-------supply type 
     pextra4            in varchar2,-------agency type
     p_accounts     out t_accounts,
     p_accounts1    out t_accounts,
     p_accounts2    out t_accounts,
     p_accounts3    out t_accounts)
     as
     vsupdate date;
     vsupdate1 date;
     Begin
       vsupdate :=to_date(pfrom_supdate,''''||pdateformat||'''');
       vsupdate1:=to_date(ptill_supdate,''''||pdateformat||'''');
       open p_accounts for
        select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
               m.tehsil_taluka AS "TEHSIL_TALUKA",cir_get_taluka(d.comp_code,m.tehsil_taluka) AS "TALUKA_NAME",
               d.agcd AS "AGCD",d.dpcd AS "DPCD",m.ag_name AS "AG_NAME",m.ag_name_oth_lang AS "AG_NAME_OTH_LANG",sum(d.sup_copy) AS "SUP_COPY",
               cir_get_name.cir_taluka(d.comp_code,m.tehsil_taluka,2,null,null,null) as "TALUKA_OTH_NAME", 
               cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",
               cir_get_name.cir_city(d.comp_code,m.city_code,2,null,null,null) as "CITY_ONAME",
               cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME",
               cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) as "DROP_POINT_ONAME"
               from cir_dbksup d,cir_agmast m,cir_edtn_mast e
               where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and d.comp_code    = pcomp_code and
                     d.unit_code    = m.unit and d.unit_code    = punit_code and
                     d.agcd         = m.agcd and d.dpcd         = m.dpcd and
                     d.publ         = e.publ and d.publ         = ppubl and
                     d.edtn=e.edtn and (d.edtn       = pedtn or pedtn is null) and
                     (m.tehsil_taluka = proute or proute is null) and d.supdate between vsupdate and vsupdate1 and
                     (e.main_edtn=pmainedtn or pmainedtn is null) and 
                      (m.ag_class=pextra2 or pextra2 is null) and 
                    (d.sup_type_code=pextra3 or pextra3 is null) and 
                    (m.ag_type=pextra4 or pextra4 is null)         
                  group by d.comp_code,d.unit_code,m.tehsil_taluka,
                           d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code
                  order by comp_code,unit_code,taluka_name,ag_name,agcd,dpcd;
       open p_accounts1 for
        select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
               m.tehsil_taluka AS "TEHSIL_TALUKA",cir_get_taluka(d.comp_code,m.tehsil_taluka) AS "TALUKA_NAME",
               sum(d.sup_copy) AS "SUP_COPY",
               cir_get_name.cir_taluka(d.comp_code,m.tehsil_taluka,2,null,null,null) as "TALUKA_OTH_NAME" 
               from cir_dbksup d,cir_agmast m,cir_edtn_mast e
               where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and d.comp_code    = pcomp_code and
                     d.unit_code    = m.unit and d.unit_code    = punit_code and
                     d.agcd         = m.agcd and d.dpcd         = m.dpcd and
                     d.publ         = e.publ and d.publ         = ppubl and
                     d.edtn=e.edtn and (d.edtn       = pedtn or pedtn is null) and
                     (m.tehsil_taluka = proute or proute is null) and
                     d.supdate between vsupdate and vsupdate1 and
                     (e.main_edtn=pmainedtn or pmainedtn is null) and 
                      (m.ag_class=pextra2 or pextra2 is null) and 
                    (d.sup_type_code=pextra3 or pextra3 is null) and 
                    (m.ag_type=pextra4 or pextra4 is null)         
                  group by d.comp_code,d.unit_code,m.tehsil_taluka
                  order by comp_code,unit_code,taluka_name;
       open p_accounts2 for
        select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",sum(d.sup_copy) AS "SUP_COPY"
               from cir_dbksup d,cir_agmast m,cir_edtn_mast e
               where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and d.comp_code    = pcomp_code and
                     d.unit_code    = m.unit and d.unit_code    = punit_code and 
                     d.agcd         = m.agcd and d.dpcd         = m.dpcd and
                     d.publ         = e.publ and d.publ         = ppubl and
                     d.edtn=e.edtn and (d.edtn       = pedtn or pedtn is null) and
                     (m.tehsil_taluka = proute or proute is null) and d.supdate between vsupdate and vsupdate1 and
                     (e.main_edtn=pmainedtn or pmainedtn is null) and
                      (m.ag_class=pextra2 or pextra2 is null) and 
                    (d.sup_type_code=pextra3 or pextra3 is null) and 
                    (m.ag_type=pextra4 or pextra4 is null)         
                  group by d.comp_code,d.unit_code
                  order by comp_code,unit_code;
       open p_accounts3 for
        select d.comp_code as "COMP_CODE",sum(d.sup_copy) AS "SUP_COPY",max(sup_rate) as  "COPY_RATE"
               from cir_dbksup d,cir_agmast m,cir_edtn_mast e
               where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and d.comp_code    = pcomp_code and
                     d.unit_code    = m.unit and d.unit_code    = punit_code and
                     d.agcd         = m.agcd and d.dpcd         = m.dpcd and
                     d.publ         = e.publ and d.publ         = ppubl and
                     d.edtn=e.edtn and (d.edtn       = pedtn or pedtn is null) and
                     (m.tehsil_taluka = proute or proute is null) and d.supdate between vsupdate and vsupdate1 and
                     (e.main_edtn=pmainedtn or pmainedtn is null) and 
                      (m.ag_class=pextra2 or pextra2 is null) and 
                    (d.sup_type_code=pextra3 or pextra3 is null) and 
                    (m.ag_type=pextra4 or pextra4 is null)         
                  group by d.comp_code
                  order by comp_code;
     End cir_taluka_wise_supply;
    procedure cir_dist_taluka_wise_sup(
     pcomp_code     in varchar2,
     punit_code     in varchar2,
     ppubl          in varchar2,
     pmainedtn      in varchar2,
     pedtn          in varchar2,
     proute         in varchar2,
     pfrom_supdate  in varchar2,
     ptill_supdate  in varchar2,
     pdateformat    in varchar2,
     pextra1        in varchar2,--for login user id
     pextra2        in varchar2,
     p_accounts     out t_accounts,
     p_accounts1    out t_accounts,
     p_accounts2    out t_accounts,
     p_accounts3    out t_accounts,
     p_accounts4    out t_accounts)
     as
     vsupdate   date;
     vsupdate1  date;
     Begin
       vsupdate :=to_date(pfrom_supdate,''''||pdateformat||'''');
       vsupdate1:=to_date(ptill_supdate,''''||pdateformat||'''');
       open p_accounts for
        select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
               m.dist_code AS "DIST_CODE",cir_get_dist(d.comp_code,m.state_code,m.dist_code) AS "DIST_NAME",
               m.tehsil_taluka AS "TEHSIL_TALUKA",cir_get_taluka(d.comp_code,m.tehsil_taluka) AS "TALUKA_NAME",
               d.agcd AS "AGCD",d.dpcd AS "DPCD",m.ag_name AS "AG_NAME",m.ag_name_oth_lang AS "AG_NAME_OTH_LANG",sum(d.sup_copy) AS "SUP_COPY",
               cir_get_name.cir_district(d.comp_code,m.dist_code,2,null,null,null) AS "DIST_OTH_NAME",
               cir_get_name.cir_taluka(d.comp_code,m.tehsil_taluka,2,null,null,null) as "TALUKA_OTH_NAME", 
               cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",
               cir_get_name.cir_city(d.comp_code,m.city_code,2,null,null,null) as "CITY_ONAME",
               cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME",
               cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) as "DROP_POINT_ONAME"
               from cir_dbksup d,cir_agmast m,cir_edtn_mast e
               where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
                     d.unit_code    = m.unit and
                     d.agcd         = m.agcd and
                     d.dpcd         = m.dpcd and
                     d.comp_code    = pcomp_code and
                     d.unit_code    = punit_code and
                     d.publ         = e.publ and d.publ         = ppubl and
                     d.edtn=e.edtn and (d.edtn       = pedtn or pedtn is null) and
                     (m.tehsil_taluka = proute or proute is null) and
                     d.supdate between vsupdate and vsupdate1 and
                     (e.main_edtn=pmainedtn or pmainedtn is null)
                  group by d.comp_code,d.unit_code,m.dist_code,m.state_code,m.tehsil_taluka,
                           d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code
                  order by comp_code,unit_code,dist_name,taluka_name,ag_name,agcd,dpcd;
       open p_accounts1 for
        select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
               m.dist_code AS "DIST_CODE",cir_get_dist(d.comp_code,m.state_code,m.dist_code) AS "DIST_NAME",
               m.tehsil_taluka AS "TEHSIL_TALUKA",cir_get_taluka(d.comp_code,m.tehsil_taluka) AS "TALUKA_NAME",
               sum(d.sup_copy) AS "SUP_COPY",
               cir_get_name.cir_district(d.comp_code,m.dist_code,2,null,null,null) AS "DIST_OTH_NAME",
               cir_get_name.cir_taluka(d.comp_code,m.tehsil_taluka,2,null,null,null) as "TALUKA_OTH_NAME" 
               from cir_dbksup d,cir_agmast m,cir_edtn_mast e
               where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
                     d.unit_code    = m.unit and
                     d.agcd         = m.agcd and
                     d.dpcd         = m.dpcd and
                     d.comp_code    = pcomp_code and
                     d.unit_code    = punit_code and
                     d.publ         = e.publ and d.publ         = ppubl and
                     d.edtn=e.edtn and (d.edtn       = pedtn or pedtn is null) and
                     (m.tehsil_taluka = proute or proute is null) and
                     d.supdate between vsupdate and vsupdate1 and
                     (e.main_edtn=pmainedtn or pmainedtn is null)
                  group by d.comp_code,d.unit_code,m.dist_code,m.state_code,m.tehsil_taluka
                  order by comp_code,unit_code,dist_name,taluka_name;
       open p_accounts2 for
        select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
               m.dist_code AS "DIST_CODE",cir_get_dist(d.comp_code,m.state_code,m.dist_code) AS "DIST_NAME",
               sum(d.sup_copy) AS "SUP_COPY",
               cir_get_name.cir_district(d.comp_code,m.dist_code,2,null,null,null) AS "DIST_OTH_NAME"
               from cir_dbksup d,cir_agmast m,cir_edtn_mast e
               where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
                     d.unit_code    = m.unit and
                     d.agcd         = m.agcd and
                     d.dpcd         = m.dpcd and
                     d.comp_code    = pcomp_code and
                     d.unit_code    = punit_code and
                     d.publ         = e.publ and d.publ         = ppubl and
                     d.edtn=e.edtn and (d.edtn       = pedtn or pedtn is null) and
                     (m.tehsil_taluka = proute or proute is null) and
                     d.supdate between vsupdate and vsupdate1 and
                     (e.main_edtn=pmainedtn or pmainedtn is null)
                  group by d.comp_code,d.unit_code,m.dist_code,m.state_code
                  order by comp_code,unit_code,dist_name;
       open p_accounts3 for
        select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",sum(d.sup_copy) AS "SUP_COPY"
               from cir_dbksup d,cir_agmast m,cir_edtn_mast e
               where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
                     d.unit_code    = m.unit and
                     d.agcd         = m.agcd and
                     d.dpcd         = m.dpcd and
                     d.comp_code    = pcomp_code and
                     d.unit_code    = punit_code and
                     d.publ         = e.publ and d.publ         = ppubl and
                     d.edtn=e.edtn and (d.edtn       = pedtn or pedtn is null) and
                     (m.tehsil_taluka = proute or proute is null) and
                     d.supdate between vsupdate and vsupdate1 and
                     (e.main_edtn=pmainedtn or pmainedtn is null)
                  group by d.comp_code,d.unit_code
                  order by comp_code,unit_code;
       open p_accounts4 for
        select d.comp_code as "COMP_CODE",sum(d.sup_copy) AS "SUP_COPY",max(sup_rate) as "COPY_RATE"
               from cir_dbksup d,cir_agmast m,cir_edtn_mast e
               where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
                     d.unit_code    = m.unit and
                     d.agcd         = m.agcd and
                     d.dpcd         = m.dpcd and
                     d.comp_code    = pcomp_code and
                     d.unit_code    = punit_code and
                     d.publ         = e.publ and d.publ         = ppubl and
                     d.edtn=e.edtn and (d.edtn       = pedtn or pedtn is null) and
                     (m.tehsil_taluka = proute or proute is null) and
                     d.supdate between vsupdate and vsupdate1 and
                     (e.main_edtn=pmainedtn or pmainedtn is null)
                  group by d.comp_code
                  order by comp_code;
     End cir_dist_taluka_wise_sup;
     procedure cir_supply_comp(
         pcomp_code     in varchar2,
         punit_code     in varchar2,
         ppublication   in varchar2,
         psupdate       in varchar2,
         psupdate1      in varchar2,
         pdateformat    in varchar2,
         pextra1        in varchar2,
         pextra2        in varchar2,
         p_accounts     out t_accounts,
         p_accounts1    out t_accounts,
         p_accounts2    out t_accounts,
         p_accounts3    out t_accounts)
     as
        vsupdate     date;
        vsupdate1    date;
     begin
        vsupdate    :=to_date(psupdate,''''||pdateformat||'''');
        vsupdate1   :=to_date(psupdate1,''''||pdateformat||'''');
        --insert into test1(vstring,vstring2) values(pcomp_code||','||punit_code||','||ppublication,psupdate||','||pdateformat||','||pextra1||','||','||pextra2); commit;
        open p_accounts for
             select comp_code,(select "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"= unit_code) unit_code,publ,cir_get_publ_name(comp_code,publ) publ_name,edtn,edtn_name,edtn_name_oth_lang,
             main_edtn,cir_get_edtn_name(comp_code,main_edtn) main_edtn_name,
             prev_sup,curr_sup,nvl(curr_sup,0)-nvl(prev_sup,0) diff,cir_get_publ_seqno(comp_code,publ) publ_seqno,
             cir_get_edtn_seqno(comp_code,main_edtn) mainedtn_seqno,cir_get_edtn_seqno(comp_code,edtn) edtn_seqno from
                    (select distinct comp_code,unit_code,publ,edtn,edtn_name,edtn_name_oth_lang,main_edtn,
                          (select nvl(sum(sup_copy),0) from cir_dbksup
                               where comp_code  =cir_edtn_mast.comp_code and
                                     unit_code =cir_edtn_mast.unit_code and
                                     publ       =cir_edtn_mast.publ and
                                     edtn       =cir_edtn_mast.edtn and
                                     supdate    =vsupdate1) prev_sup,
                          (select nvl(sum(sup_copy),0) from cir_dbksup
                               where comp_code  =cir_edtn_mast.comp_code and
                                     unit_code =cir_edtn_mast.unit_code and
                                     publ       =cir_edtn_mast.publ and
                                     edtn       =cir_edtn_mast.edtn and
                                     supdate    =to_date(vsupdate)) curr_sup
                         from cir_edtn_mast
                         where comp_code=pcomp_code and
                               (publ    =ppublication or ppublication is null) and
                               (unit_code =punit_code or punit_code is null) and
                               nvl(freeze_flag,'N')='N')
                               where nvl(prev_sup,0)+nvl(curr_sup,0)>0
                               order by publ_seqno,publ_name,unit_code,mainedtn_seqno,main_edtn_name,edtn_seqno,edtn_name;
        open p_accounts1 for
             select comp_code,unit_code,publ,cir_get_publ_name(comp_code,publ) publ_name,main_edtn,cir_get_edtn_name(comp_code,main_edtn) main_edtn_name,
             sum(prev_sup) prev_sup,sum(curr_sup) curr_sup,sum(nvl(curr_sup,0)-nvl(prev_sup,0)) diff,cir_get_publ_seqno(comp_code,publ) publ_seqno,
             cir_get_edtn_seqno(comp_code,main_edtn) mainedtn_seqno
             from
                    (select distinct comp_code,unit_code,publ,main_edtn,
                          (select nvl(sum(sup_copy),0) from cir_dbksup
                               where comp_code  =cir_edtn_mast.comp_code and
                                     unit_code  =cir_edtn_mast.unit_code and
                                     publ       =cir_edtn_mast.publ and
                                     edtn       =cir_edtn_mast.edtn and
                                     supdate    =vsupdate1) prev_sup,
                          (select nvl(sum(sup_copy),0) from cir_dbksup
                               where comp_code  =cir_edtn_mast.comp_code and
                                     unit_code  =cir_edtn_mast.unit_code and
                                     publ       =cir_edtn_mast.publ and
                                     edtn       =cir_edtn_mast.edtn and
                                     supdate    =to_date(vsupdate)) curr_sup
                         from cir_edtn_mast
                         where comp_code=pcomp_code and
                               (publ    =ppublication or ppublication is null) and
                               (unit_code =punit_code or punit_code is null) and
                               nvl(freeze_flag,'N')='N')
                               where nvl(prev_sup,0)+nvl(curr_sup,0)>0
                               group by comp_code,publ,unit_code,main_edtn
                               order by publ_seqno,publ_name,unit_code,mainedtn_seqno,main_edtn_name;
        open p_accounts2 for
             select comp_code,unit_code,publ,cir_get_publ_name(comp_code,publ) publ_name,
             sum(prev_sup) prev_sup,sum(curr_sup) curr_sup,sum(nvl(curr_sup,0)-nvl(prev_sup,0)) diff,
             cir_get_publ_seqno(comp_code,publ) publ_seqno from
                    (select distinct comp_code,unit_code,publ,main_edtn,
                          (select nvl(sum(sup_copy),0) from cir_dbksup
                               where comp_code  =cir_edtn_mast.comp_code and
                                     unit_code  =cir_edtn_mast.unit_code and
                                     publ       =cir_edtn_mast.publ and
                                     edtn       =cir_edtn_mast.edtn and
                                     supdate    =vsupdate1) prev_sup,
                          (select nvl(sum(sup_copy),0) from cir_dbksup
                               where comp_code  =cir_edtn_mast.comp_code and
                                     unit_code  =cir_edtn_mast.unit_code and
                                     publ       =cir_edtn_mast.publ and
                                     edtn       =cir_edtn_mast.edtn and
                                     supdate    =to_date(vsupdate)) curr_sup
                         from cir_edtn_mast
                         where comp_code=pcomp_code and
                               (publ    =ppublication or ppublication is null) and
                               (unit_code=punit_code or punit_code is null) and
                               nvl(freeze_flag,'N')='N')
                               where nvl(prev_sup,0)+nvl(curr_sup,0)>0
                               group by comp_code,publ,unit_code
                               order by publ_seqno,publ_name,unit_code;
             open p_accounts3 for
             select comp_code,publ,cir_get_publ_name(comp_code,publ) publ_name,
             sum(prev_sup) prev_sup,sum(curr_sup) curr_sup,sum(nvl(curr_sup,0)-nvl(prev_sup,0)) diff,
             cir_get_publ_seqno(comp_code,publ) publ_seqno from
                    (select distinct comp_code,unit_code,publ,edtn,edtn_name,edtn_name_oth_lang,
                          (select nvl(sum(sup_copy),0) from cir_dbksup
                               where comp_code =cir_edtn_mast.comp_code and
                                     unit_code  =cir_edtn_mast.unit_code and
                                     publ=cir_edtn_mast.publ and
                                     edtn=cir_edtn_mast.edtn and
                                     supdate=vsupdate1) prev_sup,
                          (select nvl(sum(sup_copy),0) from cir_dbksup
                               where comp_code=cir_edtn_mast.comp_code and
                                     unit_code  =cir_edtn_mast.unit_code and
                                     publ=cir_edtn_mast.publ and
                                     edtn=cir_edtn_mast.edtn and
                                     supdate=to_date(vsupdate)) curr_sup
                         from cir_edtn_mast
                         where comp_code=pcomp_code and
                               (publ    =ppublication or ppublication is null) and
                               (unit_code=punit_code or punit_code is null) and
                               nvl(freeze_flag,'N')='N')
                               where nvl(prev_sup,0)+nvl(curr_sup,0)>0
                               group by comp_code,publ
                               order by publ_seqno,publ_name;
     End cir_supply_comp;
    procedure cir_route_supply_variance_p(
    pcomp_code          in varchar2,
    punit_code          in varchar2,
    ppublication        in varchar2,
    pmainedtn           in varchar2,
    pedtn               in varchar2,
    proute              in varchar2,
    pfirstdate          in varchar2,
    pseconddate         in varchar2,
    pdateformat         in varchar2,
    pextra1             in varchar2,--it is use for finalised or unfinalised
    pextra2             in varchar2,--it is used for supply type
    pextra3             in varchar2,--agency type
    pextra4             in varchar2,-- agency class
    pextra5             in varchar2,--final.unfinal
    pextra6             in varchar2,
    pextra7             in varchar2,
    pextra8             in varchar2,
    pextra9             in varchar2,
    pextra10            in varchar2,
    p_accounts          out t_accounts,
    p_accounts1         out t_accounts,
    p_accounts2         out t_accounts)
   As
     vfirstdate     date;
     vseconddate    date;
    Begin
        vfirstdate    :=to_date(pfirstdate,''''||pdateformat||'''');
        vseconddate    :=to_date(pseconddate,''''||pdateformat||'''');
        if upper(pextra1)='U' then
            open p_accounts for
                 select comp_code "COMP CODE",agcd "AGENCY CODE",dpcd "AGENCY SUB CODE",ag_name "AGENCY NAME",ag_name_oth_lang "AGENCY OTHER LANG",
                 cir_get_city(comp_code,city_code) "CITY NAME",
                 route_code "ROUTE CODE",route_name "ROUTE NAME",route_name_oth_lang "ROUTE NAME OTHER LANG",sum(first_sup) "FIRST SUPPLY",sum(second_sup) "SECOND SUPPLY",
                 decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),-1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "INCREASE SUPPLY",
                 decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "DECREASE SUPPLY",
                 decode(sum(first_sup),0,100,round(((nvl(sum(second_sup),0)-nvl(sum(first_sup),0))*100)/decode(sign(sum(second_sup)-sum(first_sup)),-1,sum(first_sup),sum(second_sup)),2)) "PERCENT_VARIANCE",
                 cir_get_drop_point_name(comp_code,unit_code,station_code,1) "DROP POINT NAME",
                 cir_get_drop_point_name(comp_code,unit_code,station_code,2) "DROP POINT NAME OTHER LANG",branch_code "BRANCH NAME" from
                                (select distinct a.comp_code comp_code,a.unit_code unit_code,a.agcd,a.dpcd,a.publ,a.edtn,c.ag_name,c.ag_name_oth_lang,c.city_code,a.route_code,b.route_name,b.route_name_oth_lang,c.station_code station_code,c.branch_code branch_code,
                        (select nvl(sum(base_supply),0) from cir_supply
                                   where cir_supply.comp_code     =   pcomp_code and unit =   punit_code and
                                         cir_supply.publ          =   ppublication and (edtn   =   pedtn or pedtn is null) and
                                         nvl(cir_supply.supply_flag,'N') =   'Y' and cir_supply.comp_code = b.comp_code and
                                         cir_supply.unit          =   b.unit and cir_supply.agcd          = a.agcd and
                                         cir_supply.dpcd          =   a.dpcd and cir_supply.route_code    = b.route_code and
                                         cir_supply.publ          =   a.publ and cir_supply.edtn          = a.edtn and
                                         (cir_supply.route_code   =   proute or proute is null) and
                                         cir_supply.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and
                                         (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                         (cir_supply.supply_type_code = pextra2 or pextra2 is null)) first_sup,
                              (select nvl(sum(sup_copy),0) from cir_dbksup
                                   where comp_code    =    pcomp_code and unit_code =    punit_code and
                                         publ         =    ppublication and (edtn   =    pedtn or pedtn is null) and
                                         supdate         = vseconddate and cir_dbksup.agcd =    a.agcd and
                                         cir_dbksup.dpcd = a.dpcd and cir_dbksup.route_code =  a.route_code and
                                         cir_dbksup.publ = a.publ and cir_dbksup.edtn =  a.edtn and
                                         (cir_dbksup.route_code= proute or proute is null) and
                                         cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                         (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) second_sup
                             from cir_dbksup a,cir_route_mast b,cir_agmast c
                             where a.comp_code=pcomp_code and a.comp_code=b.comp_code and a.comp_code=c.comp_code and
                                   a.unit_code=punit_code and a.unit_code=b.unit and a.unit_code=c.unit and
                                   (a.supdate = vfirstdate or a.supdate = vseconddate) and
                                   a.agcd=c.agcd and a.dpcd=c.dpcd and                                   
                                   (c.AG_TYPE=pextra3 OR pextra3 IS NULL) AND (c.AG_CLASS=pextra4 OR pextra4 IS NULL) and                                    
                                   (a.route_code=proute or proute is null) and a.route_code=b.route_code )
                             where nvl(second_sup,0)-nvl(first_sup,0)<>0
                                   group by comp_code,unit_code,agcd,dpcd,ag_name,ag_name_oth_lang,city_code,route_code,route_name,route_name_oth_lang,station_code,branch_code
                                   order by comp_code,route_code,ag_name;
        else
            open p_accounts for
                 select comp_code "COMP CODE",agcd "AGENCY CODE",dpcd "AGENCY SUB CODE",ag_name "AGENCY NAME",ag_name_oth_lang "AGENCY OTHER LANG",
                 cir_get_city(comp_code,city_code) "CITY NAME",
                 route_code "ROUTE CODE",route_name "ROUTE NAME",route_name_oth_lang "ROUTE NAME OTHER LANG",sum(first_sup) "FIRST SUPPLY",sum(second_sup) "SECOND SUPPLY",
                 decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),-1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "INCREASE SUPPLY",
                 decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "DECREASE SUPPLY",
                 decode(sum(first_sup),0,100,round(((nvl(sum(second_sup),0)-nvl(sum(first_sup),0))*100)/decode(sign(sum(second_sup)-sum(first_sup)),-1,sum(first_sup),sum(second_sup)),2)) "PERCENT_VARIANCE",
                 cir_get_drop_point_name(comp_code,unit_code,station_code,1) "DROP POINT NAME",
                 cir_get_drop_point_name(comp_code,unit_code,station_code,2) "DROP POINT NAME OTHER LANG",branch_code "BRANCH NAME" from
                                (select distinct a.comp_code comp_code,a.unit_code unit_code,a.agcd,a.dpcd,a.publ,a.edtn,c.ag_name,c.ag_name_oth_lang,c.city_code,a.route_code,b.route_name,b.route_name_oth_lang,c.station_code station_code,c.branch_code branch_code,
                        (select nvl(sum(sup_copy),0) from cir_dbksup
                                   where comp_code                =   pcomp_code and unit_code =   punit_code and
                                         publ                     =   ppublication and (edtn   =   pedtn or pedtn is null) and
                                         supdate                  =   vfirstdate and cir_dbksup.comp_code =     b.comp_code and
                                         cir_dbksup.unit_code        =     b.unit and cir_dbksup.agcd                 =   a.agcd and
                                         cir_dbksup.dpcd                 =   a.dpcd and cir_dbksup.route_code    =     b.route_code and
                                         cir_dbksup.publ                     =      a.publ and cir_dbksup.edtn                     =      a.edtn and
                                         (cir_dbksup.route_code   =      proute or proute is null) and
                                         cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and
                                         (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and 
                                         (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) first_sup,
                              (select nvl(sum(sup_copy),0) from cir_dbksup
                                   where comp_code    =    pcomp_code and unit_code =    punit_code and
                                         publ         =    ppublication and (edtn   =    pedtn or pedtn is null) and
                                         supdate         = vseconddate and cir_dbksup.agcd =    a.agcd and
                                         cir_dbksup.dpcd = a.dpcd and cir_dbksup.route_code =  a.route_code and
                                         cir_dbksup.publ = a.publ and cir_dbksup.edtn =  a.edtn and
                                         (cir_dbksup.route_code= proute or proute is null) and
                                         cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                         (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) second_sup
                             from cir_dbksup a,cir_route_mast b,cir_agmast c
                             where a.comp_code=pcomp_code and a.comp_code=b.comp_code and a.comp_code=c.comp_code and
                                   a.unit_code=punit_code and a.unit_code=b.unit and a.unit_code=c.unit and
                                   (a.supdate = vfirstdate or a.supdate = vseconddate) and
                                   a.agcd=c.agcd and a.dpcd=c.dpcd and
                                   (c.AG_TYPE=pextra3 OR pextra3 IS NULL) AND (c.AG_CLASS=pextra4 OR pextra4 IS NULL) and   
                                   (a.route_code=proute or proute is null) and a.route_code=b.route_code )
                             where nvl(second_sup,0)-nvl(first_sup,0)<>0
                                   group by comp_code,unit_code,agcd,dpcd,ag_name,ag_name_oth_lang,city_code,route_code,route_name,route_name_oth_lang,station_code,branch_code
                                   order by comp_code,route_code,ag_name;
        end if;
        if upper(pextra1)='U' then
            open p_accounts1 for----route wise total
                 select comp_code "COMP CODE",route_code "ROUTE CODE",route_name "ROUTE NAME",route_name_oth_lang "ROUTE NAME OTHER LANG",sum(first_sup) "FIRST SUPPLY",sum(second_sup) "SECOND SUPPLY",
                 decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),-1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "INCREASE SUPPLY",
                 decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "DECREASE SUPPLY",
                 decode(sum(first_sup),0,100,round(((nvl(sum(second_sup),0)-nvl(sum(first_sup),0))*100)/decode(sign(sum(second_sup)-sum(first_sup)),-1,sum(first_sup),sum(second_sup)),2)) "PERCENT_VARIANCE" from
                (select distinct a.comp_code comp_code,a.agcd,a.dpcd,a.publ,a.edtn,c.ag_name,c.ag_name_oth_lang,c.city_code,a.route_code,b.route_name,b.route_name_oth_lang,
                        (select nvl(sum(sup_copy),0) from cir_supply
                                   where cir_supply.comp_code     =   pcomp_code and cir_supply.unit =   punit_code and
                                         cir_supply.publ          =   ppublication and (edtn   =   pedtn or pedtn is null) and
                                         nvl(cir_supply.supply_flag,'N')     =   'Y' and cir_supply.comp_code =     b.comp_code and
                                         cir_supply.unit          =   b.unit and cir_supply.agcd                 =   a.agcd and
                                         cir_supply.dpcd          =   a.dpcd and cir_supply.route_code    =     b.route_code and
                                         cir_supply.publ          =   a.publ and cir_supply.edtn                     =      a.edtn and
                                         (cir_supply.route_code   =   proute or proute is null) and
                                         cir_supply.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and
                                         (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                         (cir_supply.supply_type_code = pextra2 or pextra2 is null)) first_sup,
                              (select nvl(sum(sup_copy),0) from cir_dbksup
                                   where comp_code    =    pcomp_code and unit_code =    punit_code and
                                         publ         =    ppublication and (edtn   =    pedtn or pedtn is null) and
                                         supdate         = vseconddate and cir_dbksup.agcd =    a.agcd and
                                         cir_dbksup.dpcd = a.dpcd and cir_dbksup.route_code =  a.route_code and
                                         cir_dbksup.publ = a.publ and cir_dbksup.edtn =  a.edtn and
                                         (cir_dbksup.route_code= proute or proute is null) and
                                         cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                         (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) second_sup
                             from cir_dbksup a,cir_route_mast b,cir_agmast c
                             where a.comp_code=pcomp_code and a.comp_code=b.comp_code and a.comp_code=c.comp_code and
                                   a.unit_code=punit_code and a.unit_code=b.unit and a.unit_code=c.unit and
                                   (a.supdate = vfirstdate or a.supdate = vseconddate) and
                                   a.agcd=c.agcd and a.dpcd=c.dpcd and                                  
                                   (c.AG_TYPE=pextra3 OR pextra3 IS NULL) AND (c.AG_CLASS=pextra4 OR pextra4 IS NULL) and  
                                   (a.route_code=proute or proute is null) and a.route_code=b.route_code )
                             where nvl(second_sup,0)-nvl(first_sup,0)<>0
                                   group by comp_code,route_code,route_name,route_name_oth_lang
                                   order by comp_code,route_code;
        else
            open p_accounts1 for----route wise total
                 select comp_code "COMP CODE",route_code "ROUTE CODE",route_name "ROUTE NAME",route_name_oth_lang "ROUTE NAME OTHER LANG",sum(first_sup) "FIRST SUPPLY",sum(second_sup) "SECOND SUPPLY",
                 decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),-1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "INCREASE SUPPLY",
                 decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "DECREASE SUPPLY",
                 decode(sum(first_sup),0,100,round(((nvl(sum(second_sup),0)-nvl(sum(first_sup),0))*100)/decode(sign(sum(second_sup)-sum(first_sup)),-1,sum(first_sup),sum(second_sup)),2)) "PERCENT_VARIANCE" from
                (select distinct a.comp_code comp_code,a.agcd,a.dpcd,a.publ,a.edtn,c.ag_name,c.ag_name_oth_lang,c.city_code,a.route_code,b.route_name,b.route_name_oth_lang,
                        (select nvl(sum(sup_copy),0) from cir_dbksup
                                   where comp_code                =   pcomp_code and unit_code =   punit_code and
                                         publ                     =   ppublication and (edtn   =   pedtn or pedtn is null) and
                                         supdate                  =   vfirstdate and cir_dbksup.comp_code =     b.comp_code and
                                         cir_dbksup.unit_code        =     b.unit and cir_dbksup.agcd                 =   a.agcd and
                                         cir_dbksup.dpcd                 =   a.dpcd and cir_dbksup.route_code    =     b.route_code and
                                         cir_dbksup.publ                     =      a.publ and cir_dbksup.edtn                     =      a.edtn and
                                         (cir_dbksup.route_code   =      proute or proute is null) and
                                         cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and
                                         (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                         (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) first_sup,
                              (select nvl(sum(sup_copy),0) from cir_dbksup
                                   where comp_code    =    pcomp_code and unit_code =    punit_code and
                                         publ         =    ppublication and (edtn   =    pedtn or pedtn is null) and
                                         supdate         = vseconddate and cir_dbksup.agcd =    a.agcd and
                                         cir_dbksup.dpcd = a.dpcd and cir_dbksup.route_code =  a.route_code and
                                         cir_dbksup.publ = a.publ and cir_dbksup.edtn =  a.edtn and
                                         (cir_dbksup.route_code= proute or proute is null) and
                                         cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                         (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) second_sup
                             from cir_dbksup a,cir_route_mast b,cir_agmast c
                             where a.comp_code=pcomp_code and a.comp_code=b.comp_code and a.comp_code=c.comp_code and
                                   a.unit_code=punit_code and a.unit_code=b.unit and a.unit_code=c.unit and
                                   (a.supdate = vfirstdate or a.supdate = vseconddate) and
                                   a.agcd=c.agcd and a.dpcd=c.dpcd and
                                   (c.AG_TYPE=pextra3 OR pextra3 IS NULL) AND (c.AG_CLASS=pextra4 OR pextra4 IS NULL) and   
                                   (a.route_code=proute or proute is null) and a.route_code=b.route_code )
                             where nvl(second_sup,0)-nvl(first_sup,0)<>0
                                   group by comp_code,route_code,route_name,route_name_oth_lang
                                   order by comp_code,route_code;
        end if;
        if upper(pextra1)='U' then
            open p_accounts2 for----comp wise total
                 select comp_code "COMP CODE",sum(first_sup) "FIRST SUPPLY",sum(second_sup) "SECOND SUPPLY",
                 decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),-1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "INCREASE SUPPLY",
                 decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "DECREASE SUPPLY",
                 decode(sum(first_sup),0,100,round(((nvl(sum(second_sup),0)-nvl(sum(first_sup),0))*100)/decode(sign(sum(second_sup)-sum(first_sup)),-1,sum(first_sup),sum(second_sup)),2)) "PERCENT_VARIANCE",
                 (select nvl(sum(d.sup_copy),0) from cir_dbksup d,cir_agmast m  where d.comp_code = m.comp_code and d.comp_code = pcomp_code and d.unit_code = m.unit and d.unit_code = punit_code and
                            d.publ = ppublication and (d.edtn = pedtn or pedtn is null) and d.agcd=m.agcd and d.dpcd=m.dpcd and d.supdate = vfirstdate and
                            (m.dist_code = proute or proute is null) and d.edtn in(select distinct edtn from cir_edtn_mast
                            where comp_code=d.comp_code and edtn = d.edtn and (main_edtn=pmainedtn or pmainedtn is null)) and
                            (d.sup_type_code = pextra2 or pextra2 is null)) first_total_supply from
                (select distinct a.comp_code comp_code,a.agcd,a.dpcd,a.publ,a.edtn,c.ag_name,c.ag_name_oth_lang,c.city_code,a.route_code,b.route_name,b.route_name_oth_lang,
                        (select nvl(sum(sup_copy),0) from cir_supply
                                   where cir_supply.comp_code                =   pcomp_code and unit =   punit_code and
                                         cir_supply.publ                     =   ppublication and (edtn   =   pedtn or pedtn is null) and
                                         nvl(supply_flag,'N')                =   'Y' and cir_supply.comp_code =     b.comp_code and
                                         cir_supply.unit     =   b.unit and cir_supply.agcd          =     a.agcd and
                                         cir_supply.dpcd          =   a.dpcd and cir_supply.route_code    =     b.route_code and
                                         cir_supply.publ          =   a.publ and cir_supply.edtn          =     a.edtn and
                                         (cir_supply.route_code   =   proute or proute is null) and
                                         cir_supply.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and
                                         (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                         (cir_supply.supply_type_code = pextra2 or pextra2 is null)) first_sup,
                              (select nvl(sum(sup_copy),0) from cir_dbksup
                                   where comp_code    =    pcomp_code and unit_code =    punit_code and
                                         publ         =    ppublication and (edtn   =    pedtn or pedtn is null) and
                                         supdate      = vseconddate and cir_dbksup.agcd =    a.agcd and
                                         cir_dbksup.dpcd = a.dpcd and cir_dbksup.route_code =  a.route_code and
                                         cir_dbksup.publ = a.publ and cir_dbksup.edtn =  a.edtn and
                                         (cir_dbksup.route_code= proute or proute is null) and
                                         cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and 
                                         (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) second_sup
                             from cir_dbksup a,cir_route_mast b,cir_agmast c
                             where a.comp_code=pcomp_code and a.comp_code=b.comp_code and a.comp_code=c.comp_code and
                                   a.unit_code=punit_code and a.unit_code=b.unit and a.unit_code=c.unit and
                                   (a.supdate = vfirstdate or a.supdate = vseconddate) and
                                   a.agcd=c.agcd and a.dpcd=c.dpcd and                                   
                                   (c.AG_TYPE=pextra3 OR pextra3 IS NULL) AND (c.AG_CLASS=pextra4 OR pextra4 IS NULL) and
                                   (a.route_code=proute or proute is null) and a.route_code=b.route_code )
                             where nvl(second_sup,0)-nvl(first_sup,0)<>0
                                   group by comp_code
                                   order by comp_code;
        else
                open p_accounts2 for----comp wise total
                     select comp_code "COMP CODE",sum(first_sup) "FIRST SUPPLY",sum(second_sup) "SECOND SUPPLY",
                     decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),-1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "INCREASE SUPPLY",
                     decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "DECREASE SUPPLY",
                     decode(sum(first_sup),0,100,round(((nvl(sum(second_sup),0)-nvl(sum(first_sup),0))*100)/decode(sign(sum(second_sup)-sum(first_sup)),-1,sum(first_sup),sum(second_sup)),2)) "PERCENT_VARIANCE",
                     (select nvl(sum(d.sup_copy),0) from cir_dbksup d,cir_agmast m  where d.comp_code = m.comp_code and d.comp_code = pcomp_code and d.unit_code = m.unit and d.unit_code = punit_code and
                            d.publ = ppublication and (d.edtn = pedtn or pedtn is null) and d.agcd=m.agcd and d.dpcd=m.dpcd and d.supdate = vfirstdate and
                            (m.dist_code = proute or proute is null) and d.edtn in(select distinct edtn from cir_edtn_mast
                            where comp_code=d.comp_code and edtn = d.edtn and (main_edtn=pmainedtn or pmainedtn is null)) and
                            (d.sup_type_code = pextra2 or pextra2 is null)) first_total_supply from
                    (select distinct a.comp_code comp_code,a.agcd,a.dpcd,a.publ,a.edtn,c.ag_name,c.ag_name_oth_lang,c.city_code,a.route_code,b.route_name,b.route_name_oth_lang,
                            (select nvl(sum(sup_copy),0) from cir_dbksup
                                       where comp_code                =   pcomp_code and unit_code =   punit_code and
                                             publ                     =   ppublication and (edtn   =   pedtn or pedtn is null) and
                                             supdate                  =   vfirstdate and cir_dbksup.comp_code =     b.comp_code and
                                             cir_dbksup.unit_code     =   b.unit and cir_dbksup.agcd          =     a.agcd and
                                             cir_dbksup.dpcd          =   a.dpcd and cir_dbksup.route_code    =     b.route_code and
                                             cir_dbksup.publ          =   a.publ and cir_dbksup.edtn          =     a.edtn and
                                             (cir_dbksup.route_code   =   proute or proute is null) and
                                             cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and
                                             (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                             (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) first_sup,
                                  (select nvl(sum(sup_copy),0) from cir_dbksup
                                       where comp_code    =    pcomp_code and unit_code =    punit_code and
                                             publ         =    ppublication and (edtn   =    pedtn or pedtn is null) and
                                             supdate      = vseconddate and cir_dbksup.agcd =    a.agcd and
                                             cir_dbksup.dpcd = a.dpcd and cir_dbksup.route_code =  a.route_code and
                                             cir_dbksup.publ = a.publ and cir_dbksup.edtn =  a.edtn and
                                             (cir_dbksup.route_code= proute or proute is null) and
                                             cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                             (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) second_sup
                                 from cir_dbksup a,cir_route_mast b,cir_agmast c
                                 where a.comp_code=pcomp_code and a.comp_code=b.comp_code and a.comp_code=c.comp_code and
                                       a.unit_code=punit_code and a.unit_code=b.unit and a.unit_code=c.unit and
                                       (a.supdate = vfirstdate or a.supdate = vseconddate) and
                                       a.agcd=c.agcd and a.dpcd=c.dpcd and
                                       (c.AG_TYPE=pextra3 OR pextra3 IS NULL) AND (c.AG_CLASS=pextra4 OR pextra4 IS NULL) and  
                                       (a.route_code=proute or proute is null) and a.route_code=b.route_code )
                                 where nvl(second_sup,0)-nvl(first_sup,0)<>0
                                       group by comp_code
                                       order by comp_code;
        end if;
   End cir_route_supply_variance_p;
    procedure cir_dist_supply_variance_p(
        pcomp_code          in varchar2,
        punit_code          in varchar2,
        ppublication        in varchar2,
        pmainedtn           in varchar2,
        pedtn               in varchar2,
        pdist               in varchar2,
        pfirstdate          in varchar2,
        pseconddate         in varchar2,
        pdateformat         in varchar2,
        pextra1             in varchar2,--it is use for finalised or unfinalised
        pextra2             in varchar2,--it is used for supply type        
        pextra3             in varchar2,--agency type
        pextra4             in varchar2,-- agency class
        pextra5             in varchar2,--final.unfinal
        pextra6             in varchar2,
        pextra7             in varchar2,
        pextra8             in varchar2,
        pextra9             in varchar2,
        pextra10            in varchar2,
        p_accounts          out t_accounts,
        p_accounts1         out t_accounts,
        p_accounts2         out t_accounts)
   As
     vfirstdate             date;
     vseconddate            date;
    Begin
        vfirstdate    :=to_date(pfirstdate,''''||pdateformat||'''');
        vseconddate    :=to_date(pseconddate,''''||pdateformat||'''');
        if upper(pextra1)='U' then
            open p_accounts for
                 select comp_code "COMP CODE",agcd "AGENCY CODE",dpcd "AGENCY SUB CODE",ag_name "AGENCY NAME",ag_name_oth_lang "AGENCY OTHER LANG",
                 cir_get_city(comp_code,city_code) "CITY NAME",
                 dist_code "DISTRICT CODE",dist_name "DISTRICT NAME",dist_oname "DISTRICT NAME OTHER LANG",sum(first_sup) "FIRST SUPPLY",sum(second_sup) "SECOND SUPPLY",
                 decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),-1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "INCREASE SUPPLY",
                 decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "DECREASE SUPPLY",
                             decode(nvl(sum(first_sup),0),0,100,round(((nvl(sum(second_sup),0)-nvl(sum(first_sup),0))*100)/decode(sign(sum(second_sup)-sum(first_sup)),-1,sum(first_sup),sum(second_sup)),2)) "PERCENT_VARIANCE",
                             cir_get_drop_point_name(comp_code,unit_code,station_code,1) "DROP POINT NAME",
                             cir_get_drop_point_name(comp_code,unit_code,station_code,2) "DROP POINT NAME OTHER LANG",branch_code "BRANCH NAME" from
                        (select distinct a.comp_code comp_code,a.unit_code unit_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname,c.station_code station_code,c.branch_code branch_code,
                              (select nvl(sum(sup_copy),0) from cir_supply
                                   where comp_code    =    pcomp_code and
                                         unit         =    punit_code and
                                         publ         =    ppublication and
                                         (edtn        =    pedtn or pedtn is null) and
                                         nvl(cir_supply.supply_flag,'N') =    'Y' and
                                     cir_supply.agcd  =    a.agcd and
                                     cir_supply.dpcd  =    a.dpcd and
                                     cir_supply.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and 
                                     (main_edtn=pmainedtn or pmainedtn is null)) and
                                     (cir_supply.supply_type_code = pextra2 or pextra2 is null)) first_sup,
                              (select nvl(sum(sup_copy),0) from cir_dbksup
                                   where comp_code    =    pcomp_code and
                                         unit_code    =    punit_code and
                                         publ         =    ppublication and
                                         (edtn        =    pedtn or pedtn is null) and
                                         supdate      =    vseconddate and
                                     cir_dbksup.agcd  =    a.agcd and
                                     cir_dbksup.dpcd  =    a.dpcd and
                                     cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                     (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) second_sup
                             from cir_dbksup a,cir_dist_mast b,cir_agmast c
                             where a.comp_code    =    pcomp_code and a.comp_code    =    c.comp_code and b.comp_code    =    c.comp_code and
                                   a.unit_code=punit_code and a.unit_code=c.unit and
                                   (a.supdate = vfirstdate or a.supdate = vseconddate) and
                                   a.agcd=c.agcd and a.dpcd=c.dpcd 
                                   and (c.ag_type=pextra3 or pextra3 is null) and (c.ag_class=pextra4 or pextra4 is null) and 
                                   (c.dist_code=    pdist or pdist is null) and c.dist_code=b.dist_code)
                                   where nvl(second_sup,0)-nvl(first_sup,0)<>0
                                   group by comp_code,unit_code,agcd,dpcd,ag_name,ag_name_oth_lang,city_code,dist_code,dist_name,dist_oname,station_code,branch_code
                                   order by comp_code,dist_code,ag_name;
        else
                open p_accounts for
                     select comp_code "COMP CODE",agcd "AGENCY CODE",dpcd "AGENCY SUB CODE",ag_name "AGENCY NAME",ag_name_oth_lang "AGENCY OTHER LANG",
                     cir_get_city(comp_code,city_code) "CITY NAME",
                     dist_code "DISTRICT CODE",dist_name "DISTRICT NAME",dist_oname "DISTRICT NAME OTHER LANG",sum(first_sup) "FIRST SUPPLY",sum(second_sup) "SECOND SUPPLY",
                     decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),-1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "INCREASE SUPPLY",
                     decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "DECREASE SUPPLY",
                                 decode(nvl(sum(first_sup),0),0,100,round(((nvl(sum(second_sup),0)-nvl(sum(first_sup),0))*100)/decode(sign(sum(second_sup)-sum(first_sup)),-1,sum(first_sup),sum(second_sup)),2)) "PERCENT_VARIANCE",
                                 cir_get_drop_point_name(comp_code,unit_code,station_code,1) "DROP POINT NAME",
                                 cir_get_drop_point_name(comp_code,unit_code,station_code,2) "DROP POINT NAME OTHER LANG",branch_code "BRANCH NAME" from
                            (select distinct a.comp_code comp_code,a.unit_code unit_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname,c.station_code station_code,c.branch_code branch_code,
                                  (select nvl(sum(sup_copy),0) from cir_dbksup
                                       where comp_code    =    pcomp_code and
                                             unit_code    =    punit_code and
                                             publ                =    ppublication and
                                             (edtn            =    pedtn or pedtn is null) and
                                             supdate        =    vfirstdate and
                                             cir_dbksup.agcd =    a.agcd and
                                             cir_dbksup.dpcd =    a.dpcd and
                                             cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                             (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) first_sup,
                                  (select nvl(sum(sup_copy),0) from cir_dbksup
                                       where comp_code    =    pcomp_code and
                                             unit_code    =    punit_code and
                                             publ                =    ppublication and
                                             (edtn            =    pedtn or pedtn is null) and
                                             supdate        =    vseconddate and
                                             cir_dbksup.agcd                 =    a.agcd and
                                             cir_dbksup.dpcd                 =    a.dpcd and
                                             cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                             (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) second_sup
                                 from cir_dbksup a,cir_dist_mast b,cir_agmast c
                                 where a.comp_code    =    pcomp_code and a.comp_code    =    c.comp_code and b.comp_code    =    c.comp_code and
                                       a.unit_code=punit_code and a.unit_code=c.unit and
                                       (a.supdate = vfirstdate or a.supdate = vseconddate) and
                                       a.agcd=c.agcd and a.dpcd=c.dpcd 
                                       and (c.ag_type=pextra3 or pextra3 is null) and (c.ag_class=pextra4 or pextra4 is null) and 
                                       (c.dist_code=    pdist or pdist is null) and c.dist_code=b.dist_code)
                                       where nvl(second_sup,0)-nvl(first_sup,0)<>0
                                       group by comp_code,unit_code,agcd,dpcd,ag_name,ag_name_oth_lang,city_code,dist_code,dist_name,dist_oname,station_code,branch_code
                                       order by comp_code,dist_code,ag_name;            
        end if;
        if upper(pextra1)='U' then
        open p_accounts1 for----district wise total
             select comp_code "COMP CODE",dist_code "DISTRICT CODE",dist_name "DISTRICT NAME",dist_oname "DISTRICT NAME OTHER LANG",sum(first_sup) "FIRST SUPPLY",sum(second_sup) "SECOND SUPPLY",
             decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),-1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "INCREASE SUPPLY",
             decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "DECREASE SUPPLY",
                         decode(nvl(sum(first_sup),0),0,100,round(((nvl(sum(second_sup),0)-nvl(sum(first_sup),0))*100)/decode(sign(sum(second_sup)-sum(first_sup)),-1,sum(first_sup),sum(second_sup)),2)) "PERCENT_VARIANCE" from
                    (select distinct a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname,
                          (select nvl(sum(sup_copy),0) from cir_supply
                               where comp_code    =    pcomp_code and
                                     unit    =    punit_code and
                                     publ                =    ppublication and
                                     (edtn            =    pedtn or pedtn is null) and
                                     nvl(supply_flag,'N')=    'Y' and
                             cir_supply.agcd =    a.agcd and
                             cir_supply.dpcd =    a.dpcd and
                             cir_supply.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                             (cir_supply.supply_type_code = pextra2 or pextra2 is null)) first_sup,
                          (select nvl(sum(sup_copy),0) from cir_dbksup
                               where comp_code    =    pcomp_code and
                                     unit_code    =    punit_code and
                                     publ                =    ppublication and
                                     (edtn            =    pedtn or pedtn is null) and
                                     supdate        =    vseconddate and
                                 cir_dbksup.agcd                 =    a.agcd and
                                 cir_dbksup.dpcd                 =    a.dpcd and
                                 cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                 (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) second_sup
                         from cir_dbksup a,cir_dist_mast b,cir_agmast c
                         where a.comp_code    =    pcomp_code and a.comp_code    =    c.comp_code and b.comp_code    =    c.comp_code and
                               a.unit_code=punit_code and a.unit_code=c.unit and
                               (a.supdate = vfirstdate or a.supdate = vseconddate) and
                               a.agcd=c.agcd and a.dpcd=c.dpcd
                               and (c.ag_type=pextra3 or pextra3 is null) and (c.ag_class=pextra4 or pextra4 is null) and 
                               (c.dist_code=    pdist or pdist is null) and c.dist_code=b.dist_code)
                               where nvl(second_sup,0)-nvl(first_sup,0)<>0
                               group by comp_code,dist_code,dist_name,dist_oname
                               order by comp_code,dist_code;
             else
                open p_accounts1 for----district wise total
                     select comp_code "COMP CODE",dist_code "DISTRICT CODE",dist_name "DISTRICT NAME",dist_oname "DISTRICT NAME OTHER LANG",sum(first_sup) "FIRST SUPPLY",sum(second_sup) "SECOND SUPPLY",
                     decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),-1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "INCREASE SUPPLY",
                     decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "DECREASE SUPPLY",
                                 decode(nvl(sum(first_sup),0),0,100,round(((nvl(sum(second_sup),0)-nvl(sum(first_sup),0))*100)/decode(sign(sum(second_sup)-sum(first_sup)),-1,sum(first_sup),sum(second_sup)),2)) "PERCENT_VARIANCE" from
                            (select distinct a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname,
                                  (select nvl(sum(sup_copy),0) from cir_dbksup
                                       where comp_code    =    pcomp_code and
                                             unit_code    =    punit_code and
                                             publ         =    ppublication and
                                             (edtn        =    pedtn or pedtn is null) and
                                             supdate      =    vfirstdate and
                                         cir_dbksup.agcd =    a.agcd and
                                         cir_dbksup.dpcd =    a.dpcd and
                                         cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                         (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) first_sup,
                                  (select nvl(sum(sup_copy),0) from cir_dbksup
                                       where comp_code    =    pcomp_code and
                                             unit_code    =    punit_code and
                                             publ                =    ppublication and
                                             (edtn            =    pedtn or pedtn is null) and
                                             supdate        =    vseconddate and
                                         cir_dbksup.agcd                 =    a.agcd and
                                         cir_dbksup.dpcd                 =    a.dpcd and
                                         cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast 
                                         where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                         (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) second_sup
                                 from cir_dbksup a,cir_dist_mast b,cir_agmast c
                                 where a.comp_code    =    pcomp_code and a.comp_code    =    c.comp_code and b.comp_code    =    c.comp_code and
                                       a.unit_code=punit_code and a.unit_code=c.unit and
                                       (a.supdate = vfirstdate or a.supdate = vseconddate) and
                                       a.agcd=c.agcd and a.dpcd=c.dpcd 
                                       and (c.ag_type=pextra3 or pextra3 is null) and (c.ag_class=pextra4 or pextra4 is null) and 
                                       (c.dist_code=    pdist or pdist is null) and c.dist_code=b.dist_code)
                                       where nvl(second_sup,0)-nvl(first_sup,0)<>0
                                       group by comp_code,dist_code,dist_name,dist_oname
                                       order by comp_code,dist_code;
        end if;
        if upper(pextra1)='U' then
            open p_accounts2 for----comp wise total
                 select comp_code "COMP CODE",sum(first_sup) "FIRST SUPPLY",sum(second_sup) "SECOND SUPPLY",
                 decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),-1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "INCREASE SUPPLY",
                 decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "DECREASE SUPPLY",
                 decode(nvl(sum(first_sup),0),0,100,round(((nvl(sum(second_sup),0)-nvl(sum(first_sup),0))*100)/decode(sign(sum(second_sup)-sum(first_sup)),-1,sum(first_sup),sum(second_sup)),2)) "PERCENT_VARIANCE",
                    (select nvl(sum(d.sup_copy),0) from cir_dbksup d,cir_agmast m  where d.comp_code = m.comp_code and d.comp_code = pcomp_code and d.unit_code = m.unit and d.unit_code = punit_code and
                    d.publ = ppublication and (d.edtn = pedtn or pedtn is null) and d.agcd=m.agcd and d.dpcd=m.dpcd and d.supdate = vfirstdate and
                    (m.dist_code = pdist or pdist is null) and d.edtn in(select distinct edtn from cir_edtn_mast
                    where comp_code=d.comp_code and edtn = d.edtn and (main_edtn=pmainedtn or pmainedtn is null)) and
                    (d.sup_type_code = pextra2 or pextra2 is null)) first_total_supply  from
                        (select distinct a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname,
                              (select nvl(sum(sup_copy),0) from cir_supply
                                   where comp_code    =    pcomp_code and
                                         unit         =    punit_code and
                                         publ         =    ppublication and
                                         (edtn        =    pedtn or pedtn is null) and
                                         nvl(supply_flag,'N')      =    'Y' and
                                         cir_supply.agcd =    a.agcd and
                                         cir_supply.dpcd =    a.dpcd and
                                         cir_supply.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and 
                                         (main_edtn=pmainedtn or pmainedtn is null)) and
                                         (cir_supply.supply_type_code = pextra2 or pextra2 is null)) first_sup,
                              (select nvl(sum(sup_copy),0) from cir_dbksup
                                   where comp_code    =    pcomp_code and
                                         unit_code    =    punit_code and
                                         publ                =    ppublication and
                                         (edtn            =    pedtn or pedtn is null) and
                                         supdate        =    vseconddate and
                         cir_dbksup.agcd                 =    a.agcd and
                         cir_dbksup.dpcd                 =    a.dpcd and
                         cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                         (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) second_sup
                             from cir_dbksup a,cir_dist_mast b,cir_agmast c
                             where a.comp_code    =    pcomp_code and a.comp_code    =    c.comp_code and b.comp_code    =    c.comp_code and
                                   a.unit_code=punit_code and a.unit_code=c.unit and
                                   (a.supdate = vfirstdate or a.supdate = vseconddate) and
                                   a.agcd=c.agcd and a.dpcd=c.dpcd 
                                   and (c.ag_type=pextra3 or pextra3 is null) and (c.ag_class=pextra4 or pextra4 is null) and 
                                   (c.dist_code=    pdist or pdist is null) and c.dist_code=b.dist_code)
                                   where nvl(second_sup,0)-nvl(first_sup,0)<>0
                                   group by comp_code
                                   order by comp_code;
            else
                open p_accounts2 for----comp wise total
                 select comp_code "COMP CODE",sum(first_sup) "FIRST SUPPLY",sum(second_sup) "SECOND SUPPLY",
                 decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),-1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "INCREASE SUPPLY",
                 decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "DECREASE SUPPLY",
                decode(nvl(sum(first_sup),0),0,100,round(((nvl(sum(second_sup),0)-nvl(sum(first_sup),0))*100)/decode(sign(sum(second_sup)-sum(first_sup)),-1,sum(first_sup),sum(second_sup)),2)) "PERCENT_VARIANCE",
                (select nvl(sum(d.sup_copy),0) from cir_dbksup d,cir_agmast m  where d.comp_code = m.comp_code and d.comp_code = pcomp_code and d.unit_code = m.unit and d.unit_code = punit_code and
                    d.publ = ppublication and (d.edtn = pedtn or pedtn is null) and d.agcd=m.agcd and d.dpcd=m.dpcd and d.supdate = vfirstdate and
                    (m.dist_code = pdist or pdist is null) and d.edtn in(select distinct edtn from cir_edtn_mast
                    where comp_code=d.comp_code and edtn = d.edtn and (main_edtn=pmainedtn or pmainedtn is null)) and
                    (d.sup_type_code = pextra2 or pextra2 is null)) first_total_supply from
                        (select distinct a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.dist_code,b.dist_name,b.dist_oname,
                              (select nvl(sum(sup_copy),0) from cir_dbksup
                                   where comp_code    =    pcomp_code and
                                         unit_code    =    punit_code and
                                         publ                =    ppublication and
                                         (edtn            =    pedtn or pedtn is null) and
                                         supdate        =    vfirstdate and
                                        cir_dbksup.agcd =    a.agcd and
                                        cir_dbksup.dpcd =    a.dpcd and
                                        cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                        (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) first_sup,
                              (select nvl(sum(sup_copy),0) from cir_dbksup
                                   where comp_code    =    pcomp_code and
                                         unit_code    =    punit_code and
                                         publ                =    ppublication and
                                         (edtn            =    pedtn or pedtn is null) and
                                         supdate        =    vseconddate and
                                         cir_dbksup.agcd                 =    a.agcd and
                                         cir_dbksup.dpcd                 =    a.dpcd and
                                         cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                         (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) second_sup
                             from cir_dbksup a,cir_dist_mast b,cir_agmast c
                             where a.comp_code    =    pcomp_code and a.comp_code    =    c.comp_code and b.comp_code    =    c.comp_code and
                                   a.unit_code=punit_code and a.unit_code=c.unit and
                                   (a.supdate = vfirstdate or a.supdate = vseconddate) and
                                   a.agcd=c.agcd and a.dpcd=c.dpcd 
                                   and (c.ag_type=pextra3 or pextra3 is null) and (c.ag_class=pextra4 or pextra4 is null) and 
                                   (c.dist_code=    pdist or pdist is null) and c.dist_code=b.dist_code)
                                   where nvl(second_sup,0)-nvl(first_sup,0)<>0
                                   group by comp_code
                                   order by comp_code;
            end if;
   End cir_dist_supply_variance_p;
    procedure cir_taluka_supply_variance_p(
    pcomp_code       in varchar2,
    punit_code       in varchar2,
    ppublication     in varchar2,
    pmainedtn        in varchar2,
    pedtn            in varchar2,
    ptaluka          in varchar2,
    pfirstdate       in varchar2,
    pseconddate      in varchar2,
    pdateformat      in varchar2,
    pextra1          in varchar2,--it is use for finalised or unfinalised
    pextra2          in varchar2,--it is used for supply type
    pextra3             in varchar2,--agency type
    pextra4             in varchar2,-- agency class
    pextra5             in varchar2,--final.unfinal
    pextra6             in varchar2,
    pextra7             in varchar2,
    pextra8             in varchar2,
    pextra9             in varchar2,
    pextra10            in varchar2,
    p_accounts       out t_accounts,
    p_accounts1      out t_accounts,
    p_accounts2      out t_accounts)
   As
     vfirstdate      date;
     vseconddate     date;
    Begin
        vfirstdate    :=to_date(pfirstdate,''''||pdateformat||'''');
        vseconddate    :=to_date(pseconddate,''''||pdateformat||'''');
        if upper(pextra1)='U' then
            open p_accounts for
                 select comp_code "COMP CODE",agcd "AGENCY CODE",dpcd "AGENCY SUB CODE",ag_name "AGENCY NAME",ag_name_oth_lang "AGENCY OTHER LANG",
                 cir_get_city(comp_code,city_code) "CITY NAME",
                 tehsil_taluka "TALUKA CODE",nvl(talu_name,'(blank)') "TALUKA NAME",talu_oname "TALUKA NAME OTHER LANG",sum(first_sup) "FIRST SUPPLY",sum(second_sup) "SECOND SUPPLY",
                 decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),-1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "INCREASE SUPPLY",
                 decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "DECREASE SUPPLY",
                             decode(nvl(sum(first_sup),0),0,100,round(((nvl(sum(second_sup),0)-nvl(sum(first_sup),0))*100)/decode(sign(sum(second_sup)-sum(first_sup)),-1,sum(first_sup),sum(second_sup)),2)) "PERCENT_VARIANCE",
                             cir_get_drop_point_name(comp_code,unit_code,station_code,1) "DROP POINT NAME",
                 cir_get_drop_point_name(comp_code,unit_code,station_code,2) "DROP POINT NAME OTHER LANG",branch_code "BRANCH NAME" from
                        (select distinct a.comp_code comp_code,a.unit_code unit_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.tehsil_taluka,b.talu_name,b.talu_oname,c.station_code station_code,c.branch_code branch_code,
                              (select nvl(sum(sup_copy),0) from cir_supply
                                   where cir_supply.comp_code    =    pcomp_code and
                                         cir_supply.unit    =    punit_code and
                                         cir_supply.publ    =    ppublication and
                                         (cir_supply.edtn   =    pedtn or pedtn is null) and
                                         nvl(cir_supply.supply_flag,'N') =    'Y' and
                                         cir_supply.agcd =    a.agcd and
                                         cir_supply.dpcd =    a.dpcd and
                                         cir_supply.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                         (cir_supply.supply_type_code = pextra2 or pextra2 is null)) first_sup,
                              (select nvl(sum(sup_copy),0) from cir_dbksup
                                   where comp_code    =    pcomp_code and
                                         unit_code    =    punit_code and
                                         publ                =    ppublication and
                                         (edtn            =    pedtn or pedtn is null) and
                                         supdate        =    vseconddate and
                                         cir_dbksup.agcd                 =    a.agcd and
                                         cir_dbksup.dpcd                 =    a.dpcd and
                                         cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                         (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) second_sup
                             from cir_dbksup a,cir_taluka_mast b,cir_agmast c
                             where a.comp_code    =    pcomp_code and a.comp_code    =    c.comp_code and b.comp_code(+)    =    c.comp_code and
                                   a.unit_code=punit_code and a.unit_code=c.unit and
                                   (a.supdate = vfirstdate or a.supdate = vseconddate) and
                                   a.agcd=c.agcd and a.dpcd=c.dpcd 
                  and (c.ag_type=pextra3 or pextra3 is null) and (c.ag_class=pextra4 or pextra4 is null) and 
                                   (c.tehsil_taluka=    ptaluka or ptaluka is null) and c.tehsil_taluka=b.talu_code(+))
                                   where nvl(second_sup,0)-nvl(first_sup,0)<>0
                                   group by comp_code ,unit_code,agcd,dpcd,ag_name,ag_name_oth_lang,city_code,tehsil_taluka,talu_name,talu_oname,station_code,branch_code
                                   order by comp_code,tehsil_taluka,ag_name;
             else
                open p_accounts for
                 select comp_code "COMP CODE",agcd "AGENCY CODE",dpcd "AGENCY SUB CODE",ag_name "AGENCY NAME",ag_name_oth_lang "AGENCY OTHER LANG",
                 cir_get_city(comp_code,city_code) "CITY NAME",
                 tehsil_taluka "TALUKA CODE",nvl(talu_name,'(blank)') "TALUKA NAME",talu_oname "TALUKA NAME OTHER LANG",sum(first_sup) "FIRST SUPPLY",sum(second_sup) "SECOND SUPPLY",
                 decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),-1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "INCREASE SUPPLY",
                 decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "DECREASE SUPPLY",
                             decode(nvl(sum(first_sup),0),0,100,round(((nvl(sum(second_sup),0)-nvl(sum(first_sup),0))*100)/decode(sign(sum(second_sup)-sum(first_sup)),-1,sum(first_sup),sum(second_sup)),2)) "PERCENT_VARIANCE",
                             cir_get_drop_point_name(comp_code,unit_code,station_code,1) "DROP POINT NAME",
                            cir_get_drop_point_name(comp_code,unit_code,station_code,2) "DROP POINT NAME OTHER LANG",branch_code "BRANCH NAME" from
                        (select distinct a.comp_code comp_code,a.unit_code unit_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.tehsil_taluka,b.talu_name,b.talu_oname,c.station_code station_code,c.branch_code branch_code,
                              (select nvl(sum(sup_copy),0) from cir_dbksup
                                   where comp_code    =    pcomp_code and
                                         unit_code    =    punit_code and
                                         publ                =    ppublication and
                                         (edtn            =    pedtn or pedtn is null) and
                                         supdate        =    vfirstdate and
                                         cir_dbksup.agcd =    a.agcd and
                                         cir_dbksup.dpcd =    a.dpcd and
                                         cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                         (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) first_sup,
                              (select nvl(sum(sup_copy),0) from cir_dbksup
                                   where comp_code    =    pcomp_code and
                                         unit_code    =    punit_code and
                                         publ                =    ppublication and
                                         (edtn            =    pedtn or pedtn is null) and
                                         supdate        =    vseconddate and
                                         cir_dbksup.agcd                 =    a.agcd and
                                         cir_dbksup.dpcd                 =    a.dpcd and
                                         cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                         (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) second_sup
                             from cir_dbksup a,cir_taluka_mast b,cir_agmast c
                             where a.comp_code    =    pcomp_code and a.comp_code    =    c.comp_code and b.comp_code(+)    =    c.comp_code and
                                   a.unit_code=punit_code and a.unit_code=c.unit and
                                   (a.supdate = vfirstdate or a.supdate = vseconddate) and
                                   a.agcd=c.agcd and a.dpcd=c.dpcd 
                                   and (c.ag_type=pextra3 or pextra3 is null) and (c.ag_class=pextra4 or pextra4 is null) and 
                                   (c.tehsil_taluka=    ptaluka or ptaluka is null) and c.tehsil_taluka=b.talu_code(+))
                                   where nvl(second_sup,0)-nvl(first_sup,0)<>0
                                   group by comp_code ,unit_code,agcd,dpcd,ag_name,ag_name_oth_lang,city_code,tehsil_taluka,talu_name,talu_oname,station_code,branch_code
                                   order by comp_code,tehsil_taluka,ag_name;             
             end if;
        if upper(pextra1)='U' then
            open p_accounts1 for----taluka wise total
                 select comp_code "COMP CODE",tehsil_taluka "TALUKA CODE",nvl(talu_name,'(blank)') "TALUKA NAME",talu_oname "TALUKA NAME OTHER LANG",sum(first_sup) "FIRST SUPPLY",sum(second_sup) "SECOND SUPPLY",
                 decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),-1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "INCREASE SUPPLY",
                 decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "DECREASE SUPPLY",
                             decode(nvl(sum(first_sup),0),0,100,round(((nvl(sum(second_sup),0)-nvl(sum(first_sup),0))*100)/decode(sign(sum(second_sup)-sum(first_sup)),-1,sum(first_sup),sum(second_sup)),2)) "PERCENT_VARIANCE" from
                        (select distinct a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.tehsil_taluka,b.talu_name,b.talu_oname,
                              (select nvl(sum(sup_copy),0) from cir_supply
                                   where cir_supply.comp_code    =    pcomp_code and
                                         cir_supply.unit         =    punit_code and
                                         cir_supply.publ         =    ppublication and
                                         (cir_supply.edtn        =    pedtn or pedtn is null) and
                                         nvl(cir_supply.supply_flag,'N') =    'Y' and
                                         cir_supply.agcd =    a.agcd and
                                         cir_supply.dpcd =    a.dpcd and
                                         cir_supply.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                         (cir_supply.supply_type_code = pextra2 or pextra2 is null)) first_sup,
                              (select nvl(sum(sup_copy),0) from cir_dbksup
                                   where comp_code    =    pcomp_code and
                                         unit_code    =    punit_code and
                                         publ                =    ppublication and
                                         (edtn            =    pedtn or pedtn is null) and
                                         supdate        =    vseconddate and
                                         cir_dbksup.agcd                 =    a.agcd and
                                         cir_dbksup.dpcd                 =    a.dpcd and
                                         cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                         (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) second_sup
                             from cir_dbksup a,cir_taluka_mast b,cir_agmast c
                             where a.comp_code    =    pcomp_code and a.comp_code    =    c.comp_code and b.comp_code(+)    =    c.comp_code and
                                   a.unit_code=punit_code and a.unit_code=c.unit and
                                   (a.supdate = vfirstdate or a.supdate = vseconddate) and
                                   a.agcd=c.agcd and a.dpcd=c.dpcd 
                                   and (c.ag_type=pextra3 or pextra3 is null) and (c.ag_class=pextra4 or pextra4 is null) and 
                                   (c.tehsil_taluka=    ptaluka or ptaluka is null) and c.tehsil_taluka=b.talu_code(+))
                                   where nvl(second_sup,0)-nvl(first_sup,0)<>0
                                   group by comp_code ,tehsil_taluka,talu_name,talu_oname
                                   order by comp_code,tehsil_taluka;
              else
                open p_accounts1 for----taluka wise total
                     select comp_code "COMP CODE",tehsil_taluka "TALUKA CODE",nvl(talu_name,'(blank)') "TALUKA NAME",talu_oname "TALUKA NAME OTHER LANG",sum(first_sup) "FIRST SUPPLY",sum(second_sup) "SECOND SUPPLY",
                     decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),-1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "INCREASE SUPPLY",
                     decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "DECREASE SUPPLY",
                                 decode(nvl(sum(first_sup),0),0,100,round(((nvl(sum(second_sup),0)-nvl(sum(first_sup),0))*100)/decode(sign(sum(second_sup)-sum(first_sup)),-1,sum(first_sup),sum(second_sup)),2)) "PERCENT_VARIANCE" from
                            (select distinct a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.tehsil_taluka,b.talu_name,b.talu_oname,
                                  (select nvl(sum(sup_copy),0) from cir_dbksup
                                       where comp_code    =    pcomp_code and
                                             unit_code    =    punit_code and
                                             publ                =    ppublication and
                                             (edtn            =    pedtn or pedtn is null) and
                                             supdate        =    vfirstdate and
                                             cir_dbksup.agcd =    a.agcd and
                                             cir_dbksup.dpcd =    a.dpcd and
                                             cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                             (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) first_sup,
                                  (select nvl(sum(sup_copy),0) from cir_dbksup
                                       where comp_code    =    pcomp_code and
                                             unit_code    =    punit_code and
                                             publ                =    ppublication and
                                             (edtn            =    pedtn or pedtn is null) and
                                             supdate        =    vseconddate and
                                             cir_dbksup.agcd                 =    a.agcd and
                                             cir_dbksup.dpcd                 =    a.dpcd and
                                             cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                             (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) second_sup
                                 from cir_dbksup a,cir_taluka_mast b,cir_agmast c
                                 where a.comp_code    =    pcomp_code and a.comp_code    =    c.comp_code and b.comp_code(+)    =    c.comp_code and
                                       a.unit_code=punit_code and a.unit_code=c.unit and
                                       (a.supdate = vfirstdate or a.supdate = vseconddate) and
                                       a.agcd=c.agcd and a.dpcd=c.dpcd 
                                       and (c.ag_type=pextra3 or pextra3 is null) and (c.ag_class=pextra4 or pextra4 is null) and 
                                       (c.tehsil_taluka=    ptaluka or ptaluka is null) and c.tehsil_taluka=b.talu_code(+))
                                       where nvl(second_sup,0)-nvl(first_sup,0)<>0
                                       group by comp_code ,tehsil_taluka,talu_name,talu_oname
                                       order by comp_code,tehsil_taluka;
        end if;
        if upper(pextra1)='U' then
            open p_accounts2 for----comp wise total
                 select comp_code "COMP CODE",sum(first_sup) "FIRST SUPPLY",sum(second_sup) "SECOND SUPPLY",
                 decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),-1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "INCREASE SUPPLY",
                 decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "DECREASE SUPPLY",
                 decode(nvl(sum(first_sup),0),0,100,round(((nvl(sum(second_sup),0)-nvl(sum(first_sup),0))*100)/decode(sign(sum(second_sup)-sum(first_sup)),-1,sum(first_sup),sum(second_sup)),2)) "PERCENT_VARIANCE",
                (select nvl(sum(d.sup_copy),0) from cir_dbksup d,cir_agmast m  where d.comp_code = m.comp_code and d.comp_code = pcomp_code and d.unit_code = m.unit and d.unit_code = punit_code and
                    d.publ = ppublication and (d.edtn = pedtn or pedtn is null) and d.agcd=m.agcd and d.dpcd=m.dpcd and d.supdate = vfirstdate and
                    (m.tehsil_taluka = ptaluka or ptaluka is null) and d.edtn in(select distinct edtn from cir_edtn_mast
                    where comp_code=d.comp_code and edtn = d.edtn and (main_edtn=pmainedtn or pmainedtn is null)) and
                    (d.sup_type_code = pextra2 or pextra2 is null)) first_total_supply from
                        (select distinct a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.tehsil_taluka,b.talu_name,b.talu_oname,
                              (select nvl(sum(sup_copy),0) from cir_supply
                                   where cir_supply.comp_code    =    pcomp_code and
                                         cir_supply.unit        =    punit_code and
                                         cir_supply.publ         =    ppublication and
                                         (cir_supply.edtn         =    pedtn or pedtn is null) and
                                         nvl(cir_supply.supply_flag,'N')     =    'Y' and
                                             cir_supply.agcd =    a.agcd and
                                             cir_supply.dpcd =    a.dpcd and
                                             cir_supply.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                             (cir_supply.supply_type_code = pextra2 or pextra2 is null)) first_sup,
                              (select nvl(sum(sup_copy),0) from cir_dbksup
                                   where comp_code    =    pcomp_code and
                                         unit_code    =    punit_code and
                                         publ                =    ppublication and
                                         (edtn            =    pedtn or pedtn is null) and
                                         supdate        =    vseconddate and
                                         cir_dbksup.agcd                 =    a.agcd and
                                         cir_dbksup.dpcd                 =    a.dpcd and
                                         cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                         (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) second_sup
                             from cir_dbksup a,cir_taluka_mast b,cir_agmast c
                             where a.comp_code    =    pcomp_code and a.comp_code    =    c.comp_code and b.comp_code(+)    =    c.comp_code and
                                   a.unit_code=punit_code and a.unit_code=c.unit and
                                   (a.supdate = vfirstdate or a.supdate = vseconddate) and
                                   a.agcd=c.agcd and a.dpcd=c.dpcd 
                                   and (c.ag_type=pextra3 or pextra3 is null) and (c.ag_class=pextra4 or pextra4 is null) and 
                                   (c.tehsil_taluka=    ptaluka or ptaluka is null) and c.tehsil_taluka=b.talu_code(+))
                                   where nvl(second_sup,0)-nvl(first_sup,0)<>0
                                   group by comp_code
                                   order by comp_code;
        else
            open p_accounts2 for----comp wise total
             select comp_code "COMP CODE",sum(first_sup) "FIRST SUPPLY",sum(second_sup) "SECOND SUPPLY",
             decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),-1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "INCREASE SUPPLY",
             decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "DECREASE SUPPLY",
             decode(nvl(sum(first_sup),0),0,100,round(((nvl(sum(second_sup),0)-nvl(sum(first_sup),0))*100)/decode(sign(sum(second_sup)-sum(first_sup)),-1,sum(first_sup),sum(second_sup)),2)) "PERCENT_VARIANCE",
            (select nvl(sum(d.sup_copy),0) from cir_dbksup d,cir_agmast m  where d.comp_code = m.comp_code and d.comp_code = pcomp_code and d.unit_code = m.unit and d.unit_code = punit_code and
                    d.publ = ppublication and (d.edtn = pedtn or pedtn is null) and d.agcd=m.agcd and d.dpcd=m.dpcd and d.supdate = vfirstdate and
                    (m.tehsil_taluka = ptaluka or ptaluka is null) and d.edtn in(select distinct edtn from cir_edtn_mast
                    where comp_code=d.comp_code and edtn = d.edtn and (main_edtn=pmainedtn or pmainedtn is null)) and
                    (d.sup_type_code = pextra2 or pextra2 is null)) first_total_supply  from
                    (select distinct a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,c.tehsil_taluka,b.talu_name,b.talu_oname,
                          (select nvl(sum(sup_copy),0) from cir_dbksup
                               where comp_code    =    pcomp_code and
                                     unit_code    =    punit_code and
                                     publ    =    ppublication and
                                     (edtn   =    pedtn or pedtn is null) and
                                     supdate =    vfirstdate and
                             cir_dbksup.agcd =    a.agcd and
                             cir_dbksup.dpcd =    a.dpcd and
                             cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                             (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) first_sup,
                          (select nvl(sum(sup_copy),0) from cir_dbksup
                               where comp_code    =    pcomp_code and
                                     unit_code    =    punit_code and
                                     publ         =    ppublication and
                                     (edtn        =    pedtn or pedtn is null) and
                                     supdate      =    vseconddate and
                                     cir_dbksup.agcd                 =    a.agcd and
                                     cir_dbksup.dpcd                 =    a.dpcd and
                                     cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null)) and
                                     (cir_dbksup.sup_type_code = pextra2 or pextra2 is null)) second_sup
                         from cir_dbksup a,cir_taluka_mast b,cir_agmast c
                         where a.comp_code    =    pcomp_code and a.comp_code    =    c.comp_code and b.comp_code(+)    =    c.comp_code and
                               a.unit_code=punit_code and a.unit_code=c.unit and
                               (a.supdate = vfirstdate or a.supdate = vseconddate) and
                               a.agcd=c.agcd and a.dpcd=c.dpcd 
                               and (c.ag_type=pextra3 or pextra3 is null) and (c.ag_class=pextra4 or pextra4 is null) and 
                               (c.tehsil_taluka=    ptaluka or ptaluka is null) and c.tehsil_taluka=b.talu_code(+))
                               where nvl(second_sup,0)-nvl(first_sup,0)<>0
                               group by comp_code
                               order by comp_code;
        end if;
   End cir_taluka_supply_variance_p;
    procedure cir_edition_supply_variance_p(
    pcomp_code          in varchar2,
    punit_code          in varchar2,
    ppublication        in varchar2,
    pmainedtn           in varchar2,
    pedtn               in varchar2,
    pfirstdate          in varchar2,
    pseconddate         in varchar2,
    pdateformat         in varchar2,
    pextra1             in varchar2,
    pextra2             in varchar2,--it is used for supply type
    p_accounts          out t_accounts,
    p_accounts1         out t_accounts,
    p_accounts2         out t_accounts)
   As
     vfirstdate         date;
     vseconddate        date;
    Begin
        vfirstdate    :=to_date(pfirstdate,''''||pdateformat||'''');
        vseconddate   :=to_date(pseconddate,''''||pdateformat||'''');
        open p_accounts for
             select comp_code "COMP CODE",agcd "AGENCY CODE",dpcd "AGENCY SUB CODE",ag_name "AGENCY NAME",ag_name_oth_lang "AGENCY OTHER LANG",
             cir_get_city(comp_code,city_code) "CITY NAME",
             edtn "EDITION CODE",edtn_name "EDITION NAME",edtn_name_oth_lang "EDITION NAME OTHER LANG",sum(first_sup) "FIRST SUPPLY",sum(second_sup) "SECOND SUPPLY",
             decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),-1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "INCREASE SUPPLY",
             decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "DECREASE SUPPLY",
                         decode(nvl(sum(first_sup),0),0,100,round(((nvl(sum(second_sup),0)-nvl(sum(first_sup),0))*100)/decode(sign(sum(second_sup)-sum(first_sup)),-1,sum(first_sup),sum(second_sup)),2)) "PERCENT_VARIANCE",
                         cir_get_drop_point_name(comp_code,unit_code,station_code,1) "DROP POINT NAME",
                 cir_get_drop_point_name(comp_code,unit_code,station_code,2) "DROP POINT NAME OTHER LANG",branch_code "BRANCH NAME",unit_code "UNIT CODE" from
                    (select distinct a.comp_code comp_code,a.unit_code unit_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,a.edtn,b.edtn_name,b.edtn_name_oth_lang,
                     c.station_code station_code,c.branch_code branch_code,
                          (select nvl(sum(sup_copy),0) from cir_dbksup
                               where comp_code    =    pcomp_code and
                                     unit_code    =    punit_code and
                                     publ         =    ppublication and
                                     (edtn           =    pedtn or pedtn is null) and
                                     cir_dbksup.publ =    b.publ and
                                     cir_dbksup.edtn =    b.edtn and
                                     supdate         =    vfirstdate and
                                    cir_dbksup.agcd =  a.agcd and
                                    cir_dbksup.dpcd =  a.dpcd and
                                    cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and 
                                 (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null))) first_sup,
                          (select nvl(sum(sup_copy),0) from cir_dbksup
                               where comp_code    =    pcomp_code and
                                     unit_code    =    punit_code and
                                     publ         =    ppublication and
                                     (edtn           =    pedtn or pedtn is null) and
                                     cir_dbksup.publ =    b.publ and
                                     cir_dbksup.edtn =    b.edtn and
                                     supdate         =    vseconddate and
                                     cir_dbksup.agcd =  a.agcd and
                                     cir_dbksup.dpcd =  a.dpcd and
                                     cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and 
                                     (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null))) second_sup
                         from cir_dbksup a,cir_edtn_mast b,cir_agmast c
                         where a.comp_code    =    pcomp_code and a.comp_code    =    b.comp_code and a.comp_code    =    c.comp_code and
                               a.unit_code=punit_code and a.unit_code    =    c.unit and
                               (a.supdate = vfirstdate or a.supdate = vseconddate) and
                               (a.publ=    b.publ) and (a.publ=    ppublication or ppublication is null) and
                               a.edtn=b.edtn and (a.edtn=    pedtn or pedtn is null) and
                               a.agcd=c.agcd and a.dpcd=c.dpcd)
                               where nvl(second_sup,0)-nvl(first_sup,0)<>0
                               group by comp_code,unit_code,agcd,dpcd,ag_name,ag_name_oth_lang,city_code,edtn,edtn_name,edtn_name_oth_lang,station_code,branch_code
                               order by comp_code,unit_code,edtn_name,ag_name;
        open p_accounts1 for----Edition wise total
             select comp_code "COMP CODE",edtn "EDITION CODE",edtn_name "EDITION NAME",edtn_name_oth_lang "EDITION NAME OTHER LANG",sum(first_sup) "FIRST SUPPLY",sum(second_sup) "SECOND SUPPLY",
             decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),-1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "INCREASE SUPPLY",
             decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "DECREASE SUPPLY",
                         decode(nvl(sum(first_sup),0),0,100,round(((nvl(sum(second_sup),0)-nvl(sum(first_sup),0))*100)/decode(sign(sum(second_sup)-sum(first_sup)),-1,sum(first_sup),sum(second_sup)),2)) "PERCENT_VARIANCE" from
                    (select distinct a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,a.edtn,b.edtn_name,b.edtn_name_oth_lang,
                          (select nvl(sum(sup_copy),0) from cir_dbksup
                               where comp_code    =    pcomp_code and
                                     unit_code    =    punit_code and
                                     publ            =    ppublication and
                                     (edtn           =    pedtn or pedtn is null) and
                                     cir_dbksup.publ =    b.publ and
                                     cir_dbksup.edtn =    b.edtn and
                                     supdate         =    vfirstdate and
                                     cir_dbksup.agcd =  a.agcd and
                                     cir_dbksup.dpcd =  a.dpcd and
                                     cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and 
                                     (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null))) first_sup,
                          (select nvl(sum(sup_copy),0) from cir_dbksup
                               where comp_code    =    pcomp_code and
                                     unit_code    =    punit_code and
                                     publ         =    ppublication and
                                     (edtn           =    pedtn or pedtn is null) and
                                     cir_dbksup.publ =    b.publ and
                                     cir_dbksup.edtn =    b.edtn and
                                     supdate         =    vseconddate and
                                     cir_dbksup.agcd =  a.agcd and
                                     cir_dbksup.dpcd =  a.dpcd and
                                     cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and 
                                     (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null))) second_sup
                         from cir_dbksup a,cir_edtn_mast b,cir_agmast c
                         where a.comp_code    =    pcomp_code and a.comp_code    =    b.comp_code and a.comp_code    =    c.comp_code and
                               a.unit_code=punit_code and a.unit_code    =    c.unit and
                               (a.supdate = vfirstdate or a.supdate = vseconddate) and
                               (a.publ=    b.publ) and (a.publ=    ppublication or ppublication is null) and
                               a.edtn=b.edtn and (a.edtn=    pedtn or pedtn is null) and
                               a.agcd=c.agcd and a.dpcd=c.dpcd)
                               where nvl(second_sup,0)-nvl(first_sup,0)<>0
                               group by comp_code,edtn,edtn_name,edtn_name_oth_lang
                               order by comp_code,edtn_name;
        open p_accounts2 for----comp wise total
             select comp_code "COMP CODE",sum(first_sup) "FIRST SUPPLY",sum(second_sup) "SECOND SUPPLY",
             decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),-1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "INCREASE SUPPLY",
             decode(sign(nvl(sum(second_sup),0)-nvl(sum(first_sup),0)),1,0,(nvl(sum(second_sup),0)-nvl(sum(first_sup),0))) "DECREASE SUPPLY",
                         decode(nvl(sum(first_sup),0),0,100,round(((nvl(sum(second_sup),0)-nvl(sum(first_sup),0))*100)/decode(sign(sum(second_sup)-sum(first_sup)),-1,sum(first_sup),sum(second_sup)),2)) "PERCENT_VARIANCE",
                    (select nvl(sum(d.sup_copy),0) from cir_dbksup d,cir_agmast m  where d.comp_code = m.comp_code and d.comp_code = pcomp_code and d.unit_code = m.unit and d.unit_code = punit_code and
                    d.publ = ppublication and (d.edtn = pedtn or pedtn is null) and d.agcd=m.agcd and d.dpcd=m.dpcd and d.supdate = vfirstdate and
                    d.edtn in(select distinct edtn from cir_edtn_mast where comp_code=d.comp_code and edtn = d.edtn and (main_edtn=pmainedtn or pmainedtn is null)) and
                    (d.sup_type_code = pextra2 or pextra2 is null)) first_total_supply from
                    (select distinct a.comp_code comp_code,a.agcd,a.dpcd,c.ag_name,c.ag_name_oth_lang,c.city_code,a.edtn,b.edtn_name,b.edtn_name_oth_lang,
                          (select nvl(sum(sup_copy),0) from cir_dbksup
                               where comp_code    =    pcomp_code and
                                     unit_code    =    punit_code and
                                     publ            =    ppublication and
                                     (edtn           =    pedtn or pedtn is null) and
                                     cir_dbksup.publ =    b.publ and
                                     cir_dbksup.edtn =    b.edtn and
                                     supdate         =    vfirstdate and
                                     cir_dbksup.agcd =  a.agcd and
                                     cir_dbksup.dpcd =  a.dpcd and
                                     cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and 
                                     (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null))) first_sup,
                          (select nvl(sum(sup_copy),0) from cir_dbksup
                               where comp_code    =    pcomp_code and
                                     unit_code    =    punit_code and
                                     publ         =    ppublication and
                                     (edtn           =    pedtn or pedtn is null) and
                                     cir_dbksup.publ =    b.publ and
                                     cir_dbksup.edtn =    b.edtn and
                                     supdate         =    vseconddate and
                                     cir_dbksup.agcd =  a.agcd and
                                     cir_dbksup.dpcd =  a.dpcd and
                                     cir_dbksup.edtn in(select distinct edtn from cir_edtn_mast where comp_code=pcomp_code and 
                                     (edtn = pedtn or pedtn is null) and (main_edtn=pmainedtn or pmainedtn is null))) second_sup
                         from cir_dbksup a,cir_edtn_mast b,cir_agmast c
                         where a.comp_code    =    pcomp_code and a.comp_code    =    b.comp_code and a.comp_code    =    c.comp_code and
                               a.unit_code=punit_code and a.unit_code    =    c.unit and
                               (a.supdate = vfirstdate or a.supdate = vseconddate) and
                               (a.publ=    b.publ) and (a.publ=    ppublication or ppublication is null) and
                               a.edtn=b.edtn and (a.edtn=    pedtn or pedtn is null) and
                               a.agcd=c.agcd and a.dpcd=c.dpcd)
                               where nvl(second_sup,0)-nvl(first_sup,0)<>0
                               group by comp_code
                               order by comp_code;
   End cir_edition_supply_variance_p;
   procedure cir_rep_supply_unit(
     pcomp_code         in varchar2,
     punit_code         in varchar2,
     ppubl              in varchar2,
     pfrom_supdate      in varchar2,
     ptill_supdate      in varchar2,
     pdateformat        in varchar2,
     pextra1            in varchar2,
     pextra2            in varchar2,
     p_accounts         out t_accounts,
     p_accounts1        out t_accounts)
    as
     vfrom_supdate      date;
     vtill_supdate      date;
     cursor cur_sup_type is
         select distinct 'sum(decode(sup_type_code,'||''''||s.sup_ty_code||''''||',sup_copy,0)) "'||s.sup_ty_name||'",' vty,
        'sum(decode(sup_type_code,'||''''||s.sup_ty_code||''''||',sup_copy,0)) +' vty_sum,s.sup_seq_no sup_seq_no
        from cir_supply_type_mast s,cir_dbksup d
        where s.comp_code=d.comp_code and s.comp_code=pcomp_code and d.unit_code=nvl(punit_code,d.unit_code) and
            d.publ=nvl(ppubl,d.publ) and d.supdate between vfrom_supdate and vtill_supdate and
            s.sup_ty_code=d.sup_type_code
            order by sup_seq_no;
     rec_sup_type cur_sup_type%rowtype;
     vvar           varchar2(4000);
     vvar_sum       varchar2(4000);
     vquery         varchar2(4000);
     vquery1        varchar2(4000);
     Begin
       vfrom_supdate:=to_date(pfrom_supdate,''''||pdateformat||'''');
       vtill_supdate:=to_date(ptill_supdate,''''||pdateformat||'''');
    open cur_sup_type;
    loop
        fetch cur_sup_type into rec_sup_type;
      exit when cur_sup_type%notfound;
          vvar        :=vvar||rec_sup_type.vty;
          vvar_sum:=vvar_sum||rec_sup_type.vty_sum;
    end loop;
    close cur_sup_type;
    vvar        :=substr(vvar,1,length(vvar)-1);
    vvar_sum    :=substr(vvar_sum,1,length(vvar_sum)-1);
    --insert into test1(vstring) values (vquery);
    If vvar is null then
        vquery:=' select comp_code AS "COMP_CODE",(select distinct "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=unit_code) AS "UNIT_CODE",publ AS "PUBL",cir_get_publ_name(comp_code,publ)AS "PUBL_NAME",sup_rate as "SUP_RATE", supdate AS "SUPDATE",sum(sup_copy) AS "TOTAL" from cir_dbksup where comp_code='||
                ''''||pcomp_code||''''||' and ((unit_code='||''''||punit_code||''''||') or ('||''''||punit_code||''''||' is null)) and
                ((publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and
                supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') and
                to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||')
                group by comp_code,unit_code,sup_rate,supdate,publ order by comp_code,unit_code,publ_name,supdate,sup_rate';
    Else
        vquery:=' select comp_code AS "COMP_CODE",(select distinct "Pub_Cent_name" from pub_cent_mast where "Pub_cent_Code"=unit_code) AS "UNIT_CODE",publ AS "PUBL",cir_get_publ_name(comp_code,publ)AS "PUBL_NAME",sup_rate as "SUP_RATE", supdate AS "SUPDATE",'||vvar||','||vvar_sum||' AS "TOTAL" from cir_dbksup where comp_code='||
                ''''||pcomp_code||''''||' and ((unit_code='||''''||punit_code||''''||') or ('||''''||punit_code||''''||' is null)) and
                ((publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and
                supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') and
                to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||')
                group by comp_code,unit_code,sup_rate,supdate,publ order by comp_code,unit_code,publ_name,supdate,sup_rate';
    End if;                                    
      --          insert into test1(vstring) values ('11'||vquery);commit;
    open p_accounts for vquery;
    If vvar is null then
        vquery1:=' select comp_code AS "COMP_CODE",sup_rate as "SUP_RATE",sum(sup_copy) AS "TOTAL" from cir_dbksup where comp_code='||
                ''''||pcomp_code||''''||' and
                ((unit_code='||''''||punit_code||''''||') or ('||''''||punit_code||''''||' is null)) and
                ((publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and
                supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||')
                and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||')
                group by comp_code,sup_rate order by comp_code,sup_rate';
    else
        vquery1:=' select comp_code AS "COMP_CODE",sup_rate as "SUP_RATE",'||vvar||','||vvar_sum||' AS "TOTAL" from cir_dbksup where comp_code='||
                ''''||pcomp_code||''''||' and
                ((unit_code='||''''||punit_code||''''||') or ('||''''||punit_code||''''||' is null)) and
                ((publ='||''''||ppubl||''''||') or ('||''''||ppubl||''''||' is null)) and
                supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||')
                and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||')
                group by comp_code,sup_rate order by comp_code,sup_rate';
    end if;
    --insert into test1(vstring) values ('22'||vquery1);commit;
    open p_accounts1 for vquery1;
  End cir_rep_supply_unit;
procedure cir_dist_taluka_publ_wise(
     pcompcode      in varchar2,
     punitcode      in varchar2,
     pbrancode      in varchar2,
     ppublcode      in varchar2,
     pmainedtn      in varchar2,
     pedtncode      in varchar2,
     pdistcode      in varchar2,
     ptalukacode    in varchar2,
     pagtypecode    in varchar2,
     pagclasscode   in varchar2,
     pagcd          in varchar2,
     pdpcd          in varchar2,
     pfrom_supdate  in varchar2,
     ptill_supdate  in varchar2,
     plangtype      in varchar2,
     pdateformat    in varchar2,
     pextra1        in varchar2,--it is used for agency supply type
     pextra2        in varchar2,--it is used for break on district/taluka wise or datewise(1/2)
     p_accounts     out t_accounts)
     as
     vsupdate   date;
     vsupdate1  date;
     v_query    varchar2(32000);
      v_query1    varchar2(32000);
     cursor cur_edtn is
        select distinct d.publ publ,p.publ_seqno publ_seqno,e. edtn edtn,e.EDTN_SEQ_NO edtn_seqno,
        substr(e.edition_nick,1,15) edtn_name,d.sup_rate sup_rate,e.main_edtn main_edtn
        from cir_agmast m,cir_dbksup d ,cir_publ_mast p,cir_edtn_mast e
        where m.comp_code=pcompcode and m.comp_code=d.comp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and m.unit=d.unit_code and d.unit_code = e.unit_code and d.unit_code = punitcode and
              d.supdate between vsupdate and vsupdate1 and
              m.agcd=d.agcd and m.dpcd=d.dpcd and (m.agcd=pagcd or pagcd is null) and (m.dpcd=pdpcd or pdpcd is null) and (d.publ=ppublcode or ppublcode is null) and
              d.publ=p.publ and d.edtn=e.edtn and (d.edtn=pedtncode or pedtncode is null) and (e.main_edtn=pmainedtn or pmainedtn is null) and  
              (m.dist_code=pdistcode or pdistcode is null) and (m.tehsil_taluka=ptalukacode or ptalukacode is null) and
              (m.ag_type=pagtypecode or pagtypecode is null) and (m.ag_class=pagclasscode or pagclasscode is null) and
              (m.branch_code=pbrancode or pbrancode is null) and pextra1='S' and nvl(sup_rate,0)>0
        union
        select p.publ publ,p.publ_seqno publ_seqno,e. edtn edtn,e.EDTN_SEQ_NO edtn_seqno,
        substr(e.edition_nick,1,15) edtn_name,d.sup_rate sup_rate,e.main_edtn main_edtn
        from cir_agmast m,cir_dbksup d ,cir_publ_mast p,cir_edtn_mast e
        where m.comp_code=pcompcode and m.comp_code=d.comp_code and d.comp_code=p.comp_code and d.comp_code=e.comp_code and m.unit=d.unit_code and d.unit_code = e.unit_code and d.unit_code = punitcode and
              d.supdate between vsupdate and vsupdate1 and
              m.agcd=d.agcd and m.dpcd=d.dpcd and (d.billagcd=pagcd or pagcd is null) and (d.billdpcd=pdpcd or pdpcd is null) and (d.publ=ppublcode or ppublcode is null) and
              d.publ=p.publ and d.edtn=e.edtn and (d.edtn=pedtncode or pedtncode is null) and (e.main_edtn=pmainedtn or pmainedtn is null) and 
              (m.dist_code=pdistcode or pdistcode is null) and (m.tehsil_taluka=ptalukacode or ptalukacode is null) and
               (m.ag_type=pagtypecode or pagtypecode is null) and (m.ag_class=pagclasscode or pagclasscode is null) and
              (m.branch_code=pbrancode or pbrancode is null) and pextra1='B' and nvl(sup_rate,0)>0
        order by publ_seqno,publ,edtn_seqno,edtn;
     rec_edtn cur_edtn%rowtype;
     vvar       varchar2(8000);
     vvar_sum   varchar2(4000);
     vvar_sum1  varchar2(4000);
    Begin
        vsupdate :=to_date(pfrom_supdate,''''||pdateformat||'''');
        vsupdate1:=to_date(ptill_supdate,''''||pdateformat||'''');
        --delete test1;insert into test1(vstring,vstring2)
        --values('1111 '||vvar,' vsupdate '||vsupdate||' pdateformat '||pdateformat||' psupdate1 '||vsupdate1||' PEXTRA1 '||pextra1||' pagcd '||pagcd||' pdpcd '||pdpcd);commit;
        open cur_edtn;
        loop
          fetch cur_edtn into rec_edtn;
          exit when cur_edtn%notfound;
            if vvar is null then
                --vvar        :='sum(decode(d.edtn||d.sup_rate,'||''''||rec_edtn.edtn||rec_edtn.sup_rate||''''||',d.sup_copy,0))"'||rec_edtn.edtn_name||'_'||rec_edtn.sup_rate||'"';
                vvar        :='case when d.edtn||d.sup_rate='||''''||rec_edtn.edtn||rec_edtn.sup_rate||''''||' then sum(d.sup_copy) else 0 end "'||rec_edtn.edtn_name||'_'||rec_edtn.sup_rate||'"';
                vvar_sum    :='sum('||'"'||rec_edtn.edtn_name||'_'||rec_edtn.sup_rate||'") "'||rec_edtn.edtn_name||'_'||rec_edtn.sup_rate||'"';
                vvar_sum1   :='sum('||'"'||rec_edtn.edtn_name||'_'||rec_edtn.sup_rate||'"';
            else
                vvar        :=vvar||','||'case when d.edtn||d.sup_rate='||''''||rec_edtn.edtn||rec_edtn.sup_rate||''''||' then sum(d.sup_copy) else 0 end"'||rec_edtn.edtn_name||'_'||rec_edtn.sup_rate||'"';
                vvar_sum    :=vvar_sum||','||'sum('||'"'||rec_edtn.edtn_name||'_'||rec_edtn.sup_rate||'") "'||rec_edtn.edtn_name||'_'||rec_edtn.sup_rate||'"';
                vvar_sum1   :=vvar_sum1||'+"'||rec_edtn.edtn_name||'_'||rec_edtn.sup_rate||'"';
            end if;
        end loop;
        close cur_edtn;
        if vvar_sum1 is not null then
            vvar_sum1:=vvar_sum1||') Total';
        end if;
        --insert into test1(vstring,vstring2) values('cir_dist_taluka_publ_wise ',vvar||' , '||vvar_sum1);commit;
        if pextra2='2' then--for datewise
            if vvar is null then
                if upper(pextra1)='S' then
                    v_query:='select comp_code,unit_code,supdate,
                    station_code,cir_get_name.cir_drop_point(comp_code,unit_code,station_code,''1'','||''''||pdateformat||''''||','''','''') drop_point,
                    agcd,dpcd,agency_name from(select d.comp_code,d.unit_code,d.supdate,m.dist_code,m.tehsil_taluka,m.station_code,d.agcd agcd,d.dpcd dpcd,
                    case when '||''''||plangtype||''''||'=''1'' then
                        substr(m.ag_name,1,25)
                    else
                        substr(m.ag_name_oth_lang,1,25)
                    end agency_name from cir_dbksup d,cir_agmast m,cir_edtn_mast e
                    where d.comp_code = m.comp_code and d.comp_code = e.comp_code and d.comp_code = '||''''||pcompcode||''''||' and d.unit_code = m.unit and   
                    d.unit_code = '||''''||punitcode||''''||' and (d.publ = '||''''||ppublcode||''''||' or '||''''||ppublcode||''''||' is null) and
                    d.edtn=e.edtn and (d.edtn = '||''''||pedtncode||''''||' or '||''''||pedtncode||''''||' is null) and (e.main_edtn = '||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null) and
                    d.agcd = m.agcd and d.dpcd = m.dpcd and d.agcd=nvl('||''''||pagcd||''''||',d.agcd) and d.dpcd=nvl('||''''||pdpcd||''''||',d.dpcd) and '||''''||pextra1||''''||'=''S'' and
                    (m.dist_code = '||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and (m.tehsil_taluka = '||''''||ptalukacode||''''||' or '||''''||ptalukacode||''''||' is null) and
                    (m.ag_type='||''''||pagtypecode||''''||' or '||''''||pagtypecode||''''||' is null) and (m.ag_class='||''''||pagclasscode||''''||' or '||''''||pagclasscode||''''||' is null) and
                    (m.branch_code='||''''||pbrancode||''''||' or '||''''||pbrancode||''''||' is null) and d.supdate >= '||''''||vsupdate||''''||' and d.supdate <='||''''||vsupdate1||''''||' 
                    and nvl(d.sup_rate,0)>0
                    group by d.comp_code,d.unit_code,m.dist_code,d.supdate,m.tehsil_taluka,m.station_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,d.edtn,d.sup_rate)
                    group by comp_code,unit_code,supdate,station_code,agcd,dpcd,agency_name
                    order by comp_code,unit_code,supdate,agcd,dpcd,agency_name';
                else
                    v_query:='select comp_code,unit_code,supdate,
                    station_code,cir_get_name.cir_drop_point(comp_code,unit_code,station_code,''1'','||''''||pdateformat||''''||','''','''') drop_point,
                    agcd,dpcd,agency_name from(select d.comp_code,d.unit_code,d.supdate,m.station_code,d.agcd agcd,d.dpcd dpcd,
                    case when '||''''||plangtype||''''||'=''1'' then
                        substr(m.ag_name,1,25)
                    else
                        substr(m.ag_name_oth_lang,1,25)
                    end agency_name from cir_dbksup d,cir_agmast m,cir_edtn_mast e
                    where d.comp_code = m.comp_code and d.comp_code = e.comp_code and d.unit_code = m.unit and d.comp_code = '||''''||pcompcode||''''||' and
                    d.unit_code = '||''''||punitcode||''''||' and (d.publ = '||''''||ppublcode||''''||' or '||''''||ppublcode||''''||' is null) and
                    d.edtn=e.edtn and (d.edtn = '||''''||pedtncode||''''||' or '||''''||pedtncode||''''||' is null) and (e.main_edtn = '||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null) and
                    d.agcd = m.agcd and d.dpcd = m.dpcd and d.billagcd=nvl('||''''||pagcd||''''||',d.billagcd) and d.billdpcd=nvl('||''''||pdpcd||''''||',d.billdpcd) and '||''''||pextra1||''''||'=''B'' and 
                    (m.dist_code = '||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and (m.tehsil_taluka = '||''''||ptalukacode||''''||' or '||''''||ptalukacode||''''||' is null) and
                    (m.ag_type='||''''||pagtypecode||''''||' or '||''''||pagtypecode||''''||' is null) and (m.ag_class='||''''||pagclasscode||''''||' or '||''''||pagclasscode||''''||' is null) and
                    (m.branch_code='||''''||pbrancode||''''||' or '||''''||pbrancode||''''||' is null) and d.supdate >= '||''''||vsupdate||''''||' and d.supdate <= '||''''||vsupdate1||''''||' 
                    and nvl(d.sup_rate,0)>0
                    group by d.comp_code,d.unit_code,d.supdate,m.station_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang)
                    group by comp_code,unit_code,supdate,station_code,agcd,dpcd,agency_name
                    order by comp_code,unit_code,supdate,agcd,dpcd,agency_name';
                end if;    
            else
                if upper(pextra1)='S' then
                    v_query:='select comp_code,unit_code,supdate,
                    station_code,cir_get_name.cir_drop_point(comp_code,unit_code,station_code,''1'','||''''||pdateformat||''''||','''','''') drop_point,
                    agcd,dpcd,agency_name,'||vvar_sum||','||vvar_sum1||' from(select d.comp_code,d.unit_code,d.supdate,station_code,d.agcd agcd,d.dpcd dpcd,
                    case when '||''''||plangtype||''''||'=''1'' then
                        substr(m.ag_name,1,25)
                    else
                        substr(m.ag_name_oth_lang,1,25)
                    end agency_name,'||vvar||' from cir_dbksup d,cir_agmast m,cir_edtn_mast e
                    where d.comp_code = m.comp_code and d.comp_code = e.comp_code and d.unit_code = m.unit and d.comp_code = '||''''||pcompcode||''''||' and
                    d.unit_code = '||''''||punitcode||''''||' and (d.publ = '||''''||ppublcode||''''||' or '||''''||ppublcode||''''||' is null) and
                    d.edtn=e.edtn and (d.edtn = '||''''||pedtncode||''''||' or '||''''||pedtncode||''''||' is null) and (e.main_edtn = '||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null) and
                    d.agcd = m.agcd and d.dpcd = m.dpcd and d.agcd=nvl('||''''||pagcd||''''||',d.agcd) and d.dpcd=nvl('||''''||pdpcd||''''||',d.dpcd) and '||''''||pextra1||''''||'=''S'' and
                    (m.dist_code = '||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and (m.tehsil_taluka = '||''''||ptalukacode||''''||' or '||''''||ptalukacode||''''||' is null) and
                    (m.ag_type='||''''||pagtypecode||''''||' or '||''''||pagtypecode||''''||' is null) and (m.ag_class='||''''||pagclasscode||''''||' or '||''''||pagclasscode||''''||' is null) and
                    (m.branch_code='||''''||pbrancode||''''||' or '||''''||pbrancode||''''||' is null) and d.supdate >= '||''''||vsupdate||''''||' and d.supdate <= '||''''||vsupdate1||''''||' 
                    and nvl(d.sup_rate,0)>0
                    group by d.comp_code,d.unit_code,d.supdate,m.station_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,d.edtn,d.sup_rate)
                    group by comp_code,unit_code,supdate,station_code,agcd,dpcd,agency_name
                    order by comp_code,unit_code,supdate,agency_name';
                 else   
                    v_query:='select comp_code,unit_code,supdate,
                    station_code,cir_get_name.cir_drop_point(comp_code,unit_code,station_code,''1'','||''''||pdateformat||''''||','''','''') drop_point,
                    agcd,dpcd,agency_name,'||vvar_sum||','||vvar_sum1||' from(select d.comp_code,d.unit_code,d.supdate,m.station_code,d.agcd agcd,d.dpcd dpcd,
                    case when '||''''||plangtype||''''||'=''1'' then
                        substr(m.ag_name,1,25)
                    else
                        substr(m.ag_name_oth_lang,1,25)
                    end agency_name,'||vvar||' from cir_dbksup d,cir_agmast m,cir_edtn_mast e
                    where d.comp_code = m.comp_code and d.comp_code = e.comp_code and d.unit_code = m.unit and d.comp_code = '||''''||pcompcode||''''||' and
                    d.unit_code = '||''''||punitcode||''''||' and (d.publ = '||''''||ppublcode||''''||' or '||''''||ppublcode||''''||' is null) and
                    d.edtn=e.edtn and (d.edtn = '||''''||pedtncode||''''||' or '||''''||pedtncode||''''||' is null) and (e.main_edtn = '||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null) and
                    d.agcd = m.agcd and d.dpcd = m.dpcd and d.billagcd=nvl('||''''||pagcd||''''||',d.billagcd) and d.billdpcd=nvl('||''''||pdpcd||''''||',d.billdpcd) and '||''''||pextra1||''''||'=''B'' and
                    (m.dist_code = '||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and (m.tehsil_taluka = '||''''||ptalukacode||''''||' or '||''''||ptalukacode||''''||' is null) and
                    (m.ag_type='||''''||pagtypecode||''''||' or '||''''||pagtypecode||''''||' is null) and (m.ag_class='||''''||pagclasscode||''''||' or '||''''||pagclasscode||''''||' is null) and
                    (m.branch_code='||''''||pbrancode||''''||' or '||''''||pbrancode||''''||' is null) and d.supdate >= '||''''||vsupdate||''''||' and d.supdate <= '||''''||vsupdate1||''''||'
                    and nvl(d.sup_rate,0)>0 
                    group by d.comp_code,d.unit_code,d.supdate,m.station_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,d.edtn,d.sup_rate)
                    group by comp_code,unit_code,supdate,station_code,agcd,dpcd,agency_name
                    order by comp_code,unit_code,supdate,agency_name';
                 end if;
            end if;
        else--- for district/taluka wise
            if vvar is null then
                if upper(pextra1)='S' then
                    v_query:='select comp_code,unit_code,dist_code,cir_get_name.cir_district(comp_code,dist_code,''1'','||''''||pdateformat||''''||','''','''') dist_name,
                    tehsil_taluka,cir_get_name.cir_taluka(comp_code,tehsil_taluka,''1'','||''''||pdateformat||''''||','''','''') taluka_name,station_code,cir_get_name.cir_drop_point(comp_code,unit_code,station_code,''1'','||''''||pdateformat||''''||','''','''') drop_point,
                    agcd,dpcd,agency_name from(select d.comp_code,d.unit_code,m.dist_code,m.tehsil_taluka,m.station_code,d.agcd agcd,d.dpcd dpcd,
                    case when '||''''||plangtype||''''||'=''1'' then
                        substr(m.ag_name,1,25)
                    else
                        substr(m.ag_name_oth_lang,1,25)
                    end agency_name from cir_dbksup d,cir_agmast m,cir_edtn_mast e
                    where d.comp_code = m.comp_code and d.comp_code = e.comp_code and d.unit_code = m.unit and d.comp_code = '||''''||pcompcode||''''||' and
                    d.unit_code = '||''''||punitcode||''''||' and (d.publ = '||''''||ppublcode||''''||' or '||''''||ppublcode||''''||' is null) and
                    d.edtn=e.edtn and (d.edtn = '||''''||pedtncode||''''||' or '||''''||pedtncode||''''||' is null) and (e.main_edtn = '||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null) and
                    d.agcd = m.agcd and d.dpcd = m.dpcd and d.agcd=nvl('||''''||pagcd||''''||',d.agcd) and d.dpcd=nvl('||''''||pdpcd||''''||',d.dpcd) and '||''''||pextra1||''''||'=''S'' and
                    (m.dist_code = '||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and (m.tehsil_taluka = '||''''||ptalukacode||''''||' or '||''''||ptalukacode||''''||' is null) and
                    (m.ag_type='||''''||pagtypecode||''''||' or '||''''||pagtypecode||''''||' is null) and (m.ag_class='||''''||pagclasscode||''''||' or '||''''||pagclasscode||''''||' is null) and
                    (m.branch_code='||''''||pbrancode||''''||' or '||''''||pbrancode||''''||' is null) and d.supdate >= '||''''||vsupdate||''''||' and d.supdate <='||''''||vsupdate1||''''||' 
                    and nvl(d.sup_rate,0)>0
                    group by d.comp_code,d.unit_code,m.dist_code,m.tehsil_taluka,m.station_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,d.edtn,d.sup_rate)
                    group by comp_code,unit_code,dist_code,tehsil_taluka,station_code,agcd,dpcd,agency_name
                    order by comp_code,unit_code,dist_name,taluka_name,agcd,dpcd,agency_name';
                else    
                    v_query:='select comp_code,unit_code,dist_code,cir_get_name.cir_district(comp_code,dist_code,''1'','||''''||pdateformat||''''||','''','''') dist_name,
                    tehsil_taluka,cir_get_name.cir_taluka(comp_code,tehsil_taluka,''1'','||''''||pdateformat||''''||','''','''') taluka_name,station_code,cir_get_name.cir_drop_point(comp_code,unit_code,station_code,''1'','||''''||pdateformat||''''||','''','''') drop_point,
                    agcd,dpcd,agency_name from(select d.comp_code,d.unit_code,d.supdate,m.dist_code,m.tehsil_taluka,m.station_code,d.agcd agcd,d.dpcd dpcd,
                    case when '||''''||plangtype||''''||'=''1'' then
                        substr(m.ag_name,1,25)
                    else
                        substr(m.ag_name_oth_lang,1,25)
                    end agency_name from cir_dbksup d,cir_agmast m,cir_edtn_mast e
                    where d.comp_code = m.comp_code and d.comp_code = e.comp_code and d.unit_code = m.unit and d.comp_code = '||''''||pcompcode||''''||' and
                    d.unit_code = '||''''||punitcode||''''||' and (d.publ = '||''''||ppublcode||''''||' or '||''''||ppublcode||''''||' is null) and
                    d.edtn=e.edtn and (d.edtn = '||''''||pedtncode||''''||' or '||''''||pedtncode||''''||' is null) and (e.main_edtn = '||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null) and
                    d.agcd = m.agcd and d.dpcd = m.dpcd and d.billagcd=nvl('||''''||pagcd||''''||',d.billagcd) and d.billdpcd=nvl('||''''||pdpcd||''''||',d.billdpcd) and '||''''||pextra1||''''||'=''B'' and 
                    (m.dist_code = '||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and (m.tehsil_taluka = '||''''||ptalukacode||''''||' or '||''''||ptalukacode||''''||' is null) and
                    (m.ag_type='||''''||pagtypecode||''''||' or '||''''||pagtypecode||''''||' is null) and (m.ag_class='||''''||pagclasscode||''''||' or '||''''||pagclasscode||''''||' is null) and
                    (m.branch_code='||''''||pbrancode||''''||' or '||''''||pbrancode||''''||' is null) and d.supdate >= '||''''||vsupdate||''''||' and d.supdate <= '||''''||vsupdate1||''''||' 
                    and nvl(d.sup_rate,0)>0
                    group by d.comp_code,d.unit_code,d.supdate,m.dist_code,m.tehsil_taluka,m.station_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,d.edtn,d.sup_rate)
                    group by comp_code,unit_code,dist_code,tehsil_taluka,station_code,agcd,dpcd,agency_name
                    order by comp_code,unit_code,dist_name,taluka_name,agcd,dpcd,agency_name';
                 end if;   
            else
                if upper(pextra1)='S' then
                    v_query:='select comp_code,unit_code,dist_code,cir_get_name.cir_district(comp_code,dist_code,''1'','||''''||pdateformat||''''||','''','''') dist_name,
                    tehsil_taluka,cir_get_name.cir_taluka(comp_code,tehsil_taluka,''1'','||''''||pdateformat||''''||','''','''') taluka_name,station_code,cir_get_name.cir_drop_point(comp_code,unit_code,station_code,''1'','||''''||pdateformat||''''||','''','''') drop_point,
                    agcd,dpcd,agency_name,'||vvar_sum||','||vvar_sum1||' from(select d.comp_code,d.unit_code,m.dist_code,m.tehsil_taluka,station_code,d.agcd agcd,d.dpcd dpcd,
                    case when '||''''||plangtype||''''||'=''1'' then
                        substr(m.ag_name,1,25)
                    else
                        substr(m.ag_name_oth_lang,1,25)
                    end agency_name,'||vvar||' from cir_dbksup d,cir_agmast m,cir_edtn_mast e
                    where d.comp_code = m.comp_code and d.comp_code = e.comp_code and d.unit_code = m.unit and d.comp_code = '||''''||pcompcode||''''||' and
                    d.unit_code = '||''''||punitcode||''''||' and (d.publ = '||''''||ppublcode||''''||' or '||''''||ppublcode||''''||' is null) and
                    d.edtn=e.edtn and (d.edtn = '||''''||pedtncode||''''||' or '||''''||pedtncode||''''||' is null) and (e.main_edtn = '||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null) and
                    d.agcd = m.agcd and d.dpcd = m.dpcd and d.agcd=nvl('||''''||pagcd||''''||',d.agcd) and d.dpcd=nvl('||''''||pdpcd||''''||',d.dpcd) and '||''''||pextra1||''''||'=''S'' and
                    (m.dist_code = '||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and (m.tehsil_taluka = '||''''||ptalukacode||''''||' or '||''''||ptalukacode||''''||' is null) and
                    (m.ag_type='||''''||pagtypecode||''''||' or '||''''||pagtypecode||''''||' is null) and (m.ag_class='||''''||pagclasscode||''''||' or '||''''||pagclasscode||''''||' is null) and
                    (m.branch_code='||''''||pbrancode||''''||' or '||''''||pbrancode||''''||' is null) and d.supdate >= '||''''||vsupdate||''''||' and d.supdate <= '||''''||vsupdate1||''''||' 
                    and nvl(d.sup_rate,0)>0
                    group by d.comp_code,d.unit_code,m.dist_code,m.tehsil_taluka,m.station_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,d.edtn,d.sup_rate)
                    group by comp_code,unit_code,dist_code,tehsil_taluka,station_code,agcd,dpcd,agency_name
                    order by comp_code,unit_code,dist_name,taluka_name,agency_name';
                else    
                    v_query:='select comp_code,unit_code,dist_code,cir_get_name.cir_district(comp_code,dist_code,''1'','||''''||pdateformat||''''||','''','''') dist_name,
                    tehsil_taluka,cir_get_name.cir_taluka(comp_code,tehsil_taluka,''1'','||''''||pdateformat||''''||','''','''') taluka_name,station_code,cir_get_name.cir_drop_point(comp_code,unit_code,station_code,''1'','||''''||pdateformat||''''||','''','''') drop_point,
                    agcd,dpcd,agency_name,'||vvar_sum||','||vvar_sum1||' from(select d.comp_code,d.unit_code,m.dist_code,m.tehsil_taluka,m.station_code,d.agcd agcd,d.dpcd dpcd,
                    case when '||''''||plangtype||''''||'=''1'' then
                        substr(m.ag_name,1,25)
                    else
                        substr(m.ag_name_oth_lang,1,25)
                    end agency_name,'||vvar||' from cir_dbksup d,cir_agmast m,cir_edtn_mast e
                    where d.comp_code = m.comp_code and d.comp_code = e.comp_code and d.unit_code = m.unit and d.comp_code = '||''''||pcompcode||''''||' and
                    d.unit_code = '||''''||punitcode||''''||' and (d.publ = '||''''||ppublcode||''''||' or '||''''||ppublcode||''''||' is null) and
                    d.edtn=e.edtn and (d.edtn = '||''''||pedtncode||''''||' or '||''''||pedtncode||''''||' is null) and (e.main_edtn = '||''''||pmainedtn||''''||' or '||''''||pmainedtn||''''||' is null) and
                    d.agcd = m.agcd and d.dpcd = m.dpcd and d.billagcd=nvl('||''''||pagcd||''''||',d.billagcd) and d.billdpcd=nvl('||''''||pdpcd||''''||',d.billdpcd) and '||''''||pextra1||''''||'=''B'' and
                    (m.dist_code = '||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and (m.tehsil_taluka = '||''''||ptalukacode||''''||' or '||''''||ptalukacode||''''||' is null) and
                    (m.ag_type='||''''||pagtypecode||''''||' or '||''''||pagtypecode||''''||' is null) and (m.ag_class='||''''||pagclasscode||''''||' or '||''''||pagclasscode||''''||' is null) and
                    (m.branch_code='||''''||pbrancode||''''||' or '||''''||pbrancode||''''||' is null) and d.supdate >= '||''''||vsupdate||''''||' and d.supdate <= '||''''||vsupdate1||''''||' 
                    and nvl(d.sup_rate,0)>0
                    group by d.comp_code,d.unit_code,m.dist_code,m.tehsil_taluka,m.station_code,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,d.edtn,d.sup_rate)
                    group by comp_code,unit_code,dist_code,tehsil_taluka,station_code,agcd,dpcd,agency_name
                    order by comp_code,unit_code,dist_name,taluka_name,agency_name';
                end if;    
            end if;
        end if;
        --insert into test1(vstring,vstring2) values('cir_dist_taluka_publ_wise v_query',v_query||v_query1);commit;
        open p_accounts for v_query;
    End cir_dist_taluka_publ_wise;
    procedure cir_datewise_resale(
        pcompcode      in varchar2,
        punitcode      in varchar2,
        pbrancode      in varchar2,
        ppublcode      in varchar2,
        pmainedtn      in varchar2,
        pedtncode      in varchar2,
        pdistcode      in varchar2,
        ptalukacode    in varchar2,
        pagtypecode    in varchar2,
        pagclasscode   in varchar2,
        pagcd          in varchar2,
        pdpcd          in varchar2,
        pfrom_supdate  in varchar2,
        ptill_supdate  in varchar2,
        plangtype      in varchar2,
        pdateformat    in varchar2,
        pextra1        in varchar2,
        pextra2        in varchar2,
        p_accounts     out t_accounts)
     as
     vsupdate   date;
     vsupdate1  date;
     v_query    varchar2(8000);
     cursor cur_edtn is
        select distinct d.publ publ,d.edtn edtn,p.edtn_seq_no edtn_seqno,
         case when plangtype='1' then
          substr(p.edition_nick,1,15)
         else
          substr(p.edtn_name_oth_lang,1,20)
         end edtn_name,d.sup_rate sup_rate,p.main_edtn main_edtn
        from cir_agmast m,cir_dbksup_resale d ,cir_edtn_mast p
        where m.comp_code=pcompcode and m.comp_code=d.comp_code and d.comp_code=p.comp_code and m.unit=d.unit_code and 
              m.unit=p.unit_code and d.unit_code = punitcode and
              d.supdate >= vsupdate and d.supdate <=vsupdate1 and
              m.agcd=d.agcd and m.dpcd=d.dpcd and m.agcd=nvl(pagcd,m.agcd) and m.dpcd=nvl(pdpcd,m.dpcd) and d.publ=nvl(ppublcode,d.publ) and
              d.publ=p.publ and d.edtn=p.edtn and (m.dist_code=pdistcode or pdistcode is null) and (m.tehsil_taluka=ptalukacode or ptalukacode is null) and
              (m.ag_type=pagtypecode or pagtypecode is null) and (m.ag_class=pagclasscode or pagclasscode is null) and
              (d.resale_branch=pbrancode or pbrancode is null)
        order by publ,main_edtn,edtn_seqno,edtn,sup_rate;
     rec_edtn cur_edtn%rowtype;
     vvar       varchar2(4000);
     vvar_sum   varchar2(4000);
     vvar_sum1  varchar2(4000);
     vquery     varchar2(8000);
    Begin
        vsupdate :=to_date(pfrom_supdate,''''||pdateformat||'''');
        vsupdate1:=to_date(ptill_supdate,''''||pdateformat||'''');
        --delete test1;insert into test1(vstring,vstring2)
        --values('1111 '||vvar,' vsupdate '||vsupdate||' pdateformat '||pdateformat||' psupdate1 '||vsupdate1||' PEXTRA1 '||pextra1||' pagcd '||pagcd||' pdpcd '||pdpcd);commit;
        open cur_edtn;
        loop
          fetch cur_edtn into rec_edtn;
          exit when cur_edtn%notfound;
            if vvar is null then
                --vvar    :='decode(u.edtn||u.copy_rate,'||''''||rec_edtn.edtn||rec_edtn.copy_rate||''''||',sum(u.return_copy))"'||rec_edtn.edtn||'_'||rec_edtn.copy_rate||'"';
                --tot_vvar:=',sum("'||rec_edtn.edtn||'_'||rec_edtn.copy_rate||'") "'||rec_edtn.edtn||'_'||rec_edtn.copy_rate||'"';
                vvar        :='sum(decode(edtn||sup_rate,'||''''||rec_edtn.edtn||rec_edtn.sup_rate||''''||',sup_copy,0))"'||rec_edtn.edtn_name||'_'||rec_edtn.sup_rate||'"';
                vvar_sum    :='sum('||'"'||rec_edtn.edtn_name||'_'||rec_edtn.sup_rate||'") "'||rec_edtn.edtn_name||'_'||rec_edtn.sup_rate||'"';
                vvar_sum1   :='sum('||'"'||rec_edtn.edtn_name||'_'||rec_edtn.sup_rate||'"';
            else
                vvar        :=vvar||','||'sum(decode(edtn||sup_rate,'||''''||rec_edtn.edtn||rec_edtn.sup_rate||''''||',sup_copy,0))"'||rec_edtn.edtn_name||'_'||rec_edtn.sup_rate||'"';
                vvar_sum    :=vvar_sum||','||'sum('||'"'||rec_edtn.edtn_name||'_'||rec_edtn.sup_rate||'") "'||rec_edtn.edtn_name||'_'||rec_edtn.sup_rate||'"';
                vvar_sum1   :=vvar_sum1||'+"'||rec_edtn.edtn_name||'_'||rec_edtn.sup_rate||'"';
            end if;
        end loop;
        close cur_edtn;
        if vvar_sum1 is not null then
            vvar_sum1:=vvar_sum1||') Total';
        end if;
        --insert into test1(vstring,vstring2) values('cir_datewise_resale ',vvar||' , '||vvar_sum1);commit;
        if vvar is null then
            v_query:='select comp_code,unit_code,supdate,
            agcd,dpcd,agency_name from(select d.comp_code,d.unit_code,d.agcd agcd,d.dpcd dpcd,d.supdate supdate,
            case when '||''''||plangtype||''''||'=''1'' then
                substr(m.ag_name,1,25)
            else
                substr(m.ag_name_oth_lang,1,25)
            end agency_name from cir_dbksup_resale d,cir_agmast m
            where d.comp_code = m.comp_code and d.unit_code = m.unit and d.comp_code = '||''''||pcompcode||''''||' and
            d.unit_code = '||''''||punitcode||''''||' and d.publ = nvl('||''''||ppublcode||''''||',d.publ) and
            d.agcd = m.agcd and d.dpcd = m.dpcd and d.agcd=nvl('||''''||pagcd||''''||',d.agcd) and d.dpcd=nvl('||''''||pdpcd||''''||',d.dpcd) and 
            (m.dist_code = '||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and (m.tehsil_taluka = '||''''||ptalukacode||''''||' or '||''''||ptalukacode||''''||' is null) and
            (m.ag_type='||''''||pagtypecode||''''||' or '||''''||pagtypecode||''''||' is null) and (m.ag_class='||''''||pagclasscode||''''||' or '||''''||pagclasscode||''''||' is null) and
            (d.resale_branch='||''''||pbrancode||''''||' or '||''''||pbrancode||''''||' is null) and d.supdate >= '||''''||vsupdate||''''||' and d.supdate <='||''''||vsupdate1||''''||' 
            group by d.comp_code,d.unit_code,d.supdate,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang)
            group by comp_code,unit_code,supdate,agcd,dpcd,agency_name
            order by comp_code,unit_code,supdate,agcd,dpcd,agency_name';
        else
            v_query:='select comp_code,unit_code,supdate,
            agcd,dpcd,agency_name,'||vvar_sum||','||vvar_sum1||' from(select d.comp_code,d.unit_code,d.supdate supdate,d.agcd agcd,d.dpcd dpcd,
            case when '||''''||plangtype||''''||'=''1'' then
                substr(m.ag_name,1,25)
            else
                substr(m.ag_name_oth_lang,1,25)
            end agency_name,'||vvar||' from cir_dbksup_resale d,cir_agmast m
            where d.comp_code = m.comp_code and d.unit_code = m.unit and d.comp_code = '||''''||pcompcode||''''||' and
            d.unit_code = '||''''||punitcode||''''||' and d.publ = nvl('||''''||ppublcode||''''||',d.publ) and
            d.agcd = m.agcd and d.dpcd = m.dpcd and d.agcd=nvl('||''''||pagcd||''''||',d.agcd) and d.dpcd=nvl('||''''||pdpcd||''''||',d.dpcd) and 
            (m.dist_code = '||''''||pdistcode||''''||' or '||''''||pdistcode||''''||' is null) and (m.tehsil_taluka = '||''''||ptalukacode||''''||' or '||''''||ptalukacode||''''||' is null) and
            (m.ag_type='||''''||pagtypecode||''''||' or '||''''||pagtypecode||''''||' is null) and (m.ag_class='||''''||pagclasscode||''''||' or '||''''||pagclasscode||''''||' is null) and
            (d.resale_branch='||''''||pbrancode||''''||' or '||''''||pbrancode||''''||' is null) and d.supdate >= '||''''||vsupdate||''''||' and d.supdate <= '||''''||vsupdate1||''''||' 
            group by d.comp_code,d.unit_code,d.supdate,d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang)
            group by comp_code,unit_code,supdate,agcd,dpcd,agency_name
            order by comp_code,unit_code,supdate,agency_name';
        end if;
        --insert into test1(vstring,vstring2) values('cir_datewise_resale v_query',v_query);commit;
        open p_accounts for v_query;
    End cir_datewise_resale;
    ---branch  wise
     procedure cir_branch_wise_supply(
        pcomp_code     in varchar2,
        punit_code     in varchar2,
        ppubl          in varchar2,
        pmainedtn      in varchar2,
        pedtn          in varchar2,
        proute         in varchar2,
        pfrom_supdate  in varchar2,
        ptill_supdate  in varchar2,
        pdateformat    in varchar2,
        pextra1        in varchar2,--for login user id
        pextra2        in varchar2,----supply type
        pextra3        in varchar2,------fro ag_type
        pextra4        in varchar2,------ for ,ag_class
        p_accounts     out t_accounts,
        p_accounts1    out t_accounts,
        p_accounts2    out t_accounts,
        p_accounts3    out t_accounts)
     As
        vfrom_supdate    date;
        vtill_supdate    date;
     Begin
       vfrom_supdate:=to_date(pfrom_supdate,''''||pdateformat||'''');
       vtill_supdate:=to_date(ptill_supdate,''''||pdateformat||'''');
       open p_accounts for
       select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",m.branch_code, cir_get_branch(d.comp_code,m.branch_code) branch_name ,
               d.agcd AS "AGCD",d.dpcd AS "DPCD",m.ag_name AS "AG_NAME",m.ag_name_oth_lang AS "AG_NAME_OTH_LANG",sum(d.sup_copy) AS "SUP_COPY",
               cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",
               cir_get_name.cir_city(d.comp_code,m.city_code,2,null,null,null) as "CITY_ONAME",
               cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) as "DROP_POINT_NAME",
               cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,2) as "DROP_POINT_ONAME"
               from cir_dbksup d,cir_agmast m,cir_edtn_mast e
               where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
                     d.unit_code    = m.unit and
                     d.agcd         = m.agcd and
                     d.dpcd         = m.dpcd and
                     d.comp_code    = pcomp_code and
                     d.unit_code    = punit_code and
                     d.publ         = e.publ and d.publ         = ppubl and
                     d.edtn=e.edtn and (d.edtn       = pedtn or pedtn is null) and
                     (d.route_code = proute or proute is null) and
                     d.supdate between vfrom_supdate and vtill_supdate and
                     (e.main_edtn=pmainedtn or pmainedtn is null) and 
                     (d.sup_type_code=pextra2 or pextra2 is null) and 
                     (m.ag_type=pextra3 or pextra3 is null) and 
                     (m.ag_class=pextra4 or pextra4 is null)
                  group by d.comp_code,d.unit_code,m.branch_code,
                           d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code
                  order by d.comp_code,d.unit_code,d.agcd,d.dpcd;
       open p_accounts1 for
        select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",m.branch_code, cir_get_branch(d.comp_code,m.branch_code) branch_name ,
               sum(d.sup_copy) AS "SUP_COPY"
               from cir_dbksup d,cir_agmast m,cir_edtn_mast e
               where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
                     d.unit_code    = m.unit and
                     d.agcd         = m.agcd and
                     d.dpcd         = m.dpcd and
                     d.comp_code    = pcomp_code and
                     d.unit_code    = punit_code and
                     d.publ         = e.publ and d.publ         = ppubl and
                     d.edtn=e.edtn and (d.edtn       = pedtn or pedtn is null) and
                     (d.route_code = proute or proute is null) and
                     d.supdate between vfrom_supdate and vtill_supdate and
                     (e.main_edtn=pmainedtn or pmainedtn is null) and 
                     (d.sup_type_code=pextra2 or pextra2 is null) and 
                     (m.ag_type=pextra3 or pextra3 is null) and 
                     (m.ag_class=pextra4 or pextra4 is null)
                  group by d.comp_code,d.unit_code,m.branch_code
                  order by d.comp_code,d.unit_code,m.branch_code;
       open p_accounts2 for
        select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",m.branch_code, cir_get_branch(d.comp_code,m.branch_code) branch_name ,
               sum(d.sup_copy) AS "SUP_COPY"
               from cir_dbksup d,cir_agmast m,cir_edtn_mast e
               where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
                     d.unit_code    = m.unit and
                     d.agcd         = m.agcd and
                     d.dpcd         = m.dpcd and
                     d.comp_code    = pcomp_code and
                     d.unit_code    = punit_code and
                     d.publ         = e.publ and d.publ         = ppubl and
                     d.edtn=e.edtn and (d.edtn       = pedtn or pedtn is null) and
                     (d.route_code = proute or proute is null) and
                     d.supdate between vfrom_supdate and vtill_supdate and
                     (e.main_edtn=pmainedtn or pmainedtn is null) and 
                      (d.sup_type_code=pextra2 or pextra2 is null) and 
                     (m.ag_type=pextra3 or pextra3 is null) and 
                     (m.ag_class=pextra4 or pextra4 is null)
                  group by d.comp_code,d.unit_code,m.branch_code
                  order by d.comp_code,d.unit_code,m.branch_code;
       open p_accounts3 for
       select d.comp_code as "COMP_CODE",m.branch_code, cir_get_branch(d.comp_code,m.branch_code) branch_name ,
       sum(d.sup_copy) AS "SUP_COPY",max(sup_rate) as "COPY_RATE"
               from cir_dbksup d,cir_agmast m,cir_edtn_mast e
               where d.comp_code    = m.comp_code and d.comp_code    = e.comp_code and
                     d.unit_code    = m.unit and
                     d.agcd         = m.agcd and
                     d.dpcd         = m.dpcd and
                     d.comp_code    = pcomp_code and
                     d.unit_code    = punit_code and
                     d.publ         = e.publ and d.publ         = ppubl and
                     d.edtn=e.edtn and (d.edtn       = pedtn or pedtn is null) and
                     (d.route_code = proute or proute is null) and
                     d.supdate between vfrom_supdate and vtill_supdate and
                     (e.main_edtn=pmainedtn or pmainedtn is null) and 
                     (d.sup_type_code=pextra2 or pextra2 is null) and 
                     (m.ag_type=pextra3 or pextra3 is null) and 
                     (m.ag_class=pextra4 or pextra4 is null)
                  group by d.comp_code,m.branch_code
                  order by d.comp_code,m.branch_code;
    End cir_branch_wise_supply;
END cir_rep_supply;
/
********************************
CREATE OR REPLACE PACKAGE BODY HT18JULY.cir_rep_supply_temp IS
procedure cir_rep_supply_summ_new_p1(
    pcomp_code      in varchar2,
    punit_code      in varchar2,
    ppubl           in varchar2,
    pmainedtn       in varchar2,
    pedtn           in varchar2,
    proute          in varchar2,
    pfrom_supdate   in varchar2,
    ptill_supdate   in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,--for branch
    pextra2         in varchar2,--for State
    pextra3         in varchar2,--this is use to final and unfinal po
    pextra4         in varchar2,--for zone,
    pextra5         in varchar2,--for region
    pextra6         in varchar2,--for district
    pextra7         in varchar2,--for taluka
    pextra8         in varchar2,--report type filter 1 for routewise,2 for branchwise,3 for zonewise,4 for regionwise,5 for district,6 for talukaiwse,other than statewise
    pextra9         in varchar2,
    pextra10        in varchar2,
    p_accounts      out t_accounts)
As
    vfrom_supdate    date;
    vtill_supdate    date;
    cursor cur_sup_type is
     select distinct ' sum(case sup_type_code when '||''''||sup_ty_code||''''||' then sup_copy else 0 end ) "'||sup_ty_name||'",' vty,
     'sum(case sup_type_code when '||''''||sup_ty_code||''''||' then sup_copy else 0 end ) +' vty_sum, 
     --'sum(decode(sup_type_code,'||''''||sup_ty_code||''''||',sup_copy,0)) "'||sup_ty_name||'",' vty,
     --'sum(decode(sup_type_code,'||''''||sup_ty_code||''''||',sup_copy,0)) +' vty_sum,
     sup_seq_no
    from cir_supply_type_mast s, cir_dbksup d,cir_edtn_mast e
    where s.comp_code=pcomp_code and s.comp_code=d.comp_code and s.comp_code=e.comp_code and s.sup_ty_code =d.sup_type_code and
    d.unit_code=nvl(punit_code,d.unit_code) and d.publ=e.publ and d.publ=nvl(ppubl,d.publ) and d.edtn=e.edtn and 
    d.edtn=nvl(pedtn,d.edtn) and
    d.supdate between vfrom_supdate and vtill_supdate and
    e.main_edtn=nvl(pmainedtn,e.main_edtn)
    order by sup_seq_no;
    
    rec_sup_type cur_sup_type%rowtype; 
    vvar         varchar2(4000);
    vvar_sum    varchar2(4000);
    vquery     varchar2(4000);
    vquery1     varchar2(4000);
    vquery2     varchar2(4000);
    vquery3     varchar2(4000);
    vquery4     varchar2(4000);
Begin
    vfrom_supdate:=to_date(pfrom_supdate,''''||pdateformat||'''');
    vtill_supdate:=to_date(ptill_supdate,''''||pdateformat||'''');

    open cur_sup_type;
    loop
        fetch cur_sup_type into rec_sup_type;
        exit when cur_sup_type%notfound;
        
        vvar        :=vvar||rec_sup_type.vty;
        vvar_sum    :=vvar_sum||rec_sup_type.vty_sum;
    
    end loop;
    close cur_sup_type;

    vvar    :=substr(vvar,1,length(vvar)-1);
    vvar_sum:=substr(vvar_sum,1,length(vvar_sum)-1);

    insert into test1(vstring) values (vquery);commit;
    --
if pextra8='1' then--for route         
    vquery:=' select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,cir_get_publ_name(d.comp_code,d.publ) publ_name,
        d.route_code route_code,cir_get_route_name(d.comp_code,d.unit_code,d.route_code) route_name,cir_get_name.cir_route(d.comp_code,d.unit_code,d.route_code,''2'',null,null,null) route_oname,  '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c ,cir_publ_mast p
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.publ=p.publ and d.comp_code='''||pcomp_code||''' and 
            m.unit=d.unit_code and d.unit_code='''||punit_code||''' 
            and d.publ=e.publ and (d.publ='''||ppubl||''' or '''||ppubl||''' is null) 
            and d.edtn=e.edtn and (d.edtn='''||pedtn||''' or '''||pedtn||''' is null) 
            and m.agcd=d.agcd and m.dpcd=d.dpcd 
            and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') 
            and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
            and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
            and (d.route_code='''||proute||''' or '''||proute||''' is null) 
            and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
            and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
            and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
            and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
            and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
            and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
            and m.city_code=c.city_code 
            and (e.main_edtn='''||pmainedtn||''' or '''||pmainedtn||''' is null)
            and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
            and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)  
            group by d.comp_code,d.unit_code,d.publ,d.route_code
            order by d.comp_code,d.unit_code,d.publ,route_name';

elsif pextra8='2' then----for  branch
    vquery:=' select d.comp_code comp_code,d.unit_code unit_code,m.branch_code branch_code,cir_get_branch(d.comp_code,m.branch_code) branch_name
    , '||vvar||','||vvar_sum||' TOTAL 
    from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p
    where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.publ=p.publ and d.comp_code='''||pcomp_code||''' and 
            m.unit=d.unit_code and d.unit_code='''||punit_code||''' 
            and d.publ=e.publ and (d.publ='''||ppubl||''' or '''||ppubl||''' is null) 
            and d.edtn=e.edtn and (d.edtn='''||pedtn||''' or '''||pedtn||''' is null) 
            and m.agcd=d.agcd and m.dpcd=d.dpcd 
            and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') 
            and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
            and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
            and (d.route_code='''||proute||''' or '''||proute||''' is null) 
            and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
            and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
            and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
            and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
            and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
            and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
            and m.city_code=c.city_code 
            and (e.main_edtn='''||pmainedtn||''' or '''||pmainedtn||''' is null)
            and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
            and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
        group by d.comp_code,d.unit_code,m.branch_code
        order by d.comp_code,d.unit_code,branch_name';
        
elsif pextra8='3' then----for  zone
        vquery:='select d.comp_code comp_code,d.unit_code unit_code,c.zone_code,
        cir_get_zone_name(d.comp_code,c.zone_code) zone_name
        , '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p 
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.publ=p.publ and d.comp_code='''||pcomp_code||''' and 
            m.unit=d.unit_code and d.unit_code='''||punit_code||''' 
            and d.publ=e.publ and (d.publ='''||ppubl||''' or '''||ppubl||''' is null) 
            and d.edtn=e.edtn and (d.edtn='''||pedtn||''' or '''||pedtn||''' is null) 
            and m.agcd=d.agcd and m.dpcd=d.dpcd 
            and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') 
            and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
            and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
            and (d.route_code='''||proute||''' or '''||proute||''' is null) 
            and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
            and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
            and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
            and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
            and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
            and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
            and m.city_code=c.city_code 
            and (e.main_edtn='''||pmainedtn||''' or '''||pmainedtn||''' is null)
            and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
            and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
        group by d.comp_code,d.unit_code,c.zone_code
        order by d.comp_code,d.unit_code,zone_name';

elsif pextra8='4' then----for  region
    vquery:=' select d.comp_code comp_code,d.unit_code unit_code,  c.region_code region_code,cir_get_region_name(d.comp_code,c.region_code) region_name
        , '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p 
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.publ=p.publ and d.comp_code='''||pcomp_code||''' and 
            m.unit=d.unit_code and d.unit_code='''||punit_code||''' 
            and d.publ=e.publ and (d.publ='''||ppubl||''' or '''||ppubl||''' is null) 
            and d.edtn=e.edtn and (d.edtn='''||pedtn||''' or '''||pedtn||''' is null) 
            and m.agcd=d.agcd and m.dpcd=d.dpcd 
            and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') 
            and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
            and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
            and (d.route_code='''||proute||''' or '''||proute||''' is null) 
            and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
            and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
            and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
            and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
            and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
            and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
            and m.city_code=c.city_code 
            and (e.main_edtn='''||pmainedtn||''' or '''||pmainedtn||''' is null)
            and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
            and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
                group by d.comp_code,d.unit_code,c.region_code
                order by d.comp_code,d.unit_code,region_name';

elsif pextra8='5' then----for  district
    vquery:=' select d.comp_code comp_code,d.unit_code unit_code,m.dist_code dist_code,
    cir_get_dist(d.comp_code,m.state_code,m.dist_code) district_name,
    cir_get_name.cir_district(d.comp_code,m.dist_code,''2'',null,null,null) district_oname
    , '||vvar||','||vvar_sum||' TOTAL 
    from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p 
    where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.publ=p.publ and d.comp_code='''||pcomp_code||''' and 
            m.unit=d.unit_code and d.unit_code='''||punit_code||''' 
            and d.publ=e.publ and (d.publ='''||ppubl||''' or '''||ppubl||''' is null) 
            and d.edtn=e.edtn and (d.edtn='''||pedtn||''' or '''||pedtn||''' is null) 
            and m.agcd=d.agcd and m.dpcd=d.dpcd 
            and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') 
            and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
            and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
            and (d.route_code='''||proute||''' or '''||proute||''' is null) 
            and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
            and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
            and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
            and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
            and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
            and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
            and m.city_code=c.city_code 
            and (e.main_edtn='''||pmainedtn||''' or '''||pmainedtn||''' is null)
            and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
            and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
                group by d.comp_code,d.unit_code,m.state_code,m.dist_code
                order by d.comp_code,d.unit_code,m.state_code,district_name';

elsif pextra8='6' then----for  tehsil_taluka
        vquery:=' select d.comp_code comp_code,d.unit_code unit_code,m.tehsil_taluka tehsil_taluka,
        cir_get_taluka(d.comp_code,m.tehsil_taluka) taluka_name,
        cir_get_name.cir_taluka(d.comp_code,m.tehsil_taluka,''2'',null,null,null) taluka_oname
        , '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p 
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.publ=p.publ and d.comp_code='''||pcomp_code||''' and 
            m.unit=d.unit_code and d.unit_code='''||punit_code||''' 
            and d.publ=e.publ and (d.publ='''||ppubl||''' or '''||ppubl||''' is null) 
            and d.edtn=e.edtn and (d.edtn='''||pedtn||''' or '''||pedtn||''' is null) 
            and m.agcd=d.agcd and m.dpcd=d.dpcd 
            and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') 
            and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
            and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
            and (d.route_code='''||proute||''' or '''||proute||''' is null) 
            and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
            and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
            and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
            and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
            and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
            and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
            and m.city_code=c.city_code 
            and (e.main_edtn='''||pmainedtn||''' or '''||pmainedtn||''' is null)
            and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
            and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
            group by d.comp_code,d.unit_code,m.tehsil_taluka
            order by d.comp_code,d.unit_code,taluka_name';

elsif pextra8='7' then----for  state wise 
        vquery:=' select d.comp_code comp_code,d.unit_code unit_code,m.country_code country_code,m.state_code state_code,cir_get_state(d.comp_code,m.country_code,m.state_code) state_name
        , '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p 
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.publ=p.publ and d.comp_code='''||pcomp_code||''' and 
            m.unit=d.unit_code and d.unit_code='''||punit_code||''' 
            and d.publ=e.publ and (d.publ='''||ppubl||''' or '''||ppubl||''' is null) 
            and d.edtn=e.edtn and (d.edtn='''||pedtn||''' or '''||pedtn||''' is null) 
            and m.agcd=d.agcd and m.dpcd=d.dpcd 
            and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') 
            and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
            and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
            and (d.route_code='''||proute||''' or '''||proute||''' is null) 
            and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
            and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
            and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
            and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
            and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
            and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
            and m.city_code=c.city_code 
            and (e.main_edtn='''||pmainedtn||''' or '''||pmainedtn||''' is null)
            and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
            and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
                group by d.comp_code,d.unit_code,m.country_code,m.state_code
                order by d.comp_code,d.unit_code,m.country_code,state_name';
                
  elsif pextra8='8' then----for  executive
        vquery:=' select d.comp_code comp_code,d.unit_code unit_code,m.country_code country_code,m.executive_code executive_code,cir_get_executive(d.comp_code,m.executive_code) executive_name
        , '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p 
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.publ=p.publ and d.comp_code='''||pcomp_code||''' and 
            m.unit=d.unit_code and d.unit_code='''||punit_code||''' 
            and d.publ=e.publ and (d.publ='''||ppubl||''' or '''||ppubl||''' is null) 
            and d.edtn=e.edtn and (d.edtn='''||pedtn||''' or '''||pedtn||''' is null) 
            and m.agcd=d.agcd and m.dpcd=d.dpcd 
            and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') 
            and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
            and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
            and (d.route_code='''||proute||''' or '''||proute||''' is null) 
            and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
            and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
            and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
            and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
            and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
            and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
            and m.city_code=c.city_code 
            and (e.main_edtn='''||pmainedtn||''' or '''||pmainedtn||''' is null)
            and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
            and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
                group by d.comp_code,d.unit_code,m.country_code,m.executive_code
                order by d.comp_code,d.unit_code,m.country_code,executive_name'; 
                         
else----for  Executive wise 
        vquery:=' select d.comp_code comp_code,d.unit_code unit_code,m.country_code country_code,m.executive_code executive_code,cir_get_executive(d.comp_code,m.executive_code) executive_name
        , '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c,cir_publ_mast p 
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and m.comp_code=p.comp_code and d.publ=p.publ and d.comp_code='''||pcomp_code||''' and 
            m.unit=d.unit_code and d.unit_code='''||punit_code||''' 
            and d.publ=e.publ and (d.publ='''||ppubl||''' or '''||ppubl||''' is null) 
            and d.edtn=e.edtn and (d.edtn='''||pedtn||''' or '''||pedtn||''' is null) 
            and m.agcd=d.agcd and m.dpcd=d.dpcd 
            and d.supdate between '||'to_date('||''''||pfrom_supdate||''''||','||''''||pdateformat||''''||') 
            and to_date('||''''||ptill_supdate||''''||','||''''||pdateformat||''''||') 
            and (d.final_supply_flag='''||pextra3||''' or '''||pextra3||''' is null)
            and (d.route_code='''||proute||''' or '''||proute||''' is null) 
            and (m.branch_code='''||pextra1||''' or '''||pextra1||''' is null)
            and (m.state_code='''||pextra2||''' or '''||pextra2||''' is null)
            and (c.zone_code='''||pextra4||''' or '''||pextra4||''' is null)
            and (c.region_code='''||pextra5||''' or '''||pextra5||''' is null)
            and (m.dist_code='''||pextra6||''' or '''||pextra6||''' is null)
            and (m.tehsil_taluka='''||pextra7||''' or '''||pextra7||''' is null)
            and m.city_code=c.city_code 
            and (e.main_edtn='''||pmainedtn||''' or '''||pmainedtn||''' is null)
            and (p.pro_type='''||pextra9||''' or '''||pextra9||''' is null)
            and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
                group by d.comp_code,d.unit_code,m.country_code,m.executive_code
                order by d.comp_code,d.unit_code,m.country_code,executive_name';
end if;         

    insert into test1(vstring) values ('1'||vquery);commit;
    open p_accounts for vquery;             
    

end cir_rep_supply_summ_new_p1;
End cir_rep_supply_temp;
/

**************end of Body**************
********************end of issue7885*****************************************



///////////////////////////////add by Deepika 06/07/2012///////////////////////////////////////


CREATE OR REPLACE procedure cir_rep_lbl_prn_infomedia_p(
     pcomp_code     in varchar2,
     punit_code     in varchar2,
     ppubl          in varchar2,
     pmainedtn      in varchar2,
     pedtn          in varchar2,
     proute         in varchar2,
     pagcd          in varchar2,
     pdpcd          in varchar2,
     plbldt         in varchar2,
     pdateformat    in varchar2,
     pextra1        in varchar2,
     pextra2        in varchar2,
     /*pextra3        in varchar2,
     pextra4        in varchar2,
     pextra5        in varchar2,
     pextra6        in varchar2,
     pextra7        in varchar2,
     pextra8        in varchar2,
     pextra9        in varchar2,
     pextra10       in varchar2,*/
    p_accounts     OUT Cur_Type_New1.cursor_type,
    p_accounts1 OUT Cur_Type_New1.cursor_type)
As
    vlbldt date;
Begin
    vlbldt:=to_date(plbldt,''''||pdateformat||'''');

       open p_accounts for
          select a.*,cir_get_mode_name(comp_code,unit_code||route) mode_name,

          SUBSTR(cir_get_name.cir_edtn(comp_code,unit_code,edtn  ,'1',''''||pdateformat||'''','',''),1,30) edtn_name,

          (select distinct reg_no from cir_edtn_mast where comp_code = pcomp_code and edtn=a.edtn_1) AS "REG_NO",
		  case when a.lbl_tno=1 then nvl(supply_1,0) else
          (((a.lbl_tno-1)*pkt_size)+nvl(supply_1,0)) end as "TOTAL_SUPPLY_COPY",(select station_code from cir_agmast where cir_agmast.comp_code=a.comp_code and

          cir_agmast.unit=a.unit_code and cir_agmast.agcd=a.agcd  and cir_agmast.dpcd=a.dpcd) as "STATION_CODE",
          cir_get_drop_point_name(comp_code,unit_code,(select station_code from cir_agmast where cir_agmast.comp_code=a.comp_code and
          cir_agmast.unit=a.unit_code and cir_agmast.agcd=a.agcd  and cir_agmast.dpcd=a.dpcd),'') as "ST_NAME",
          cir_get_publ_name(comp_code,publ) PUB_NAME,
		 
		  (select  SUM(nvl(b.supply_1,0)) from cir_lblmast b where a.comp_code=b.comp_code and
		a.unit_code=b.unit_code and a.publ=b.publ and a.edtn=b.edtn and a.lbl_dt=b.lbl_dt
		and a.agcd=b.agcd and a.dpcd=b.dpcd and a.lbl_dt    = vlbldt
		 )as "TOTAL_SUPPLY"
           from cir_lblMAST a
             where comp_code = pcomp_code and
                   unit_code = punit_code and
                   lbl_dt    = vlbldt and
                   ((publ    = ppubl) or (ppubl is null)) and
                   ((nvl(edtn,edtn_1)    = pedtn) or (pedtn is null)) and
                   nvl(edtn,edtn_1) in(select edtn from cir_edtn_mast where comp_code=pcomp_code and
                   (unit_code=punit_code or punit_code is null) and ((edtn = pedtn) or (pedtn is null)) and (main_edtn=pmainedtn or pmainedtn is null)) and
                   ((route   = proute) or (proute is null)) and
                   ((agcd    = pagcd) or (pagcd is null)) and
                   ((dpcd    = pdpcd) or (pdpcd is null));

				   open  p_accounts1 for

				    select
		 sum( nvl(supply_1,0) )as "TOTAL_SUPPLY",COMP_CODE,UNIT_CODE,AGCD,DPCD,PUBL,edtn_1
           from cir_lblMAST
             where comp_code = pcomp_code and
                   unit_code = punit_code and
                   lbl_dt    = vlbldt and
                   ((publ    = ppubl) or (ppubl is null)) and
                   ((nvl(edtn,edtn_1)    = pedtn) or (pedtn is null)) and
                   nvl(edtn,edtn_1) in(select edtn from cir_edtn_mast where comp_code=pcomp_code and
                   (unit_code=punit_code or punit_code is null) and ((edtn = pedtn) or (pedtn is null)) and (main_edtn=pmainedtn or pmainedtn is null)) and
                   ((route   = proute) or (proute is null)) and
                   ((agcd    = pagcd) or (pagcd is null)) and
                   ((dpcd    = pdpcd) or (pdpcd is null))
GROUP BY COMP_CODE,UNIT_CODE,AGCD,DPCD,PUBL,edtn_1;

End cir_rep_lbl_prn_infomedia_p;
/


/////////////////////////////////////////////end///////////////////////////////////////////////////////

