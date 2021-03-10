
//////////////////////////ADD BY DEEPIKA 16/MAY/2013 SENT BY SUSHIL SIR//////////////////////////

CREATE OR REPLACE procedure cir_interest_on_overdue_bill(
    pcomp_code          in varchar2,
    punit_code          in varchar2,
    pason_date          in varchar2,
    pagency_type        in varchar2,
    pagmain_code        in varchar2,
    pagsub_code         in varchar2,
    pint_rate           in number,
    poverdue_days       in int,
    pposting_req        in varchar2,--Y for Posting & N for no posting
    puserid             in varchar2,
    pdateformat         in varchar2,
    pextra1             in varchar2,
    pextra2             in varchar2,
    pextra3             in varchar2,
    pextra4             in varchar2,
    pextra5             in varchar2,
    p_accounts          out cur_type_new1.cursor_type)
As
    v_cnt             number:=0;
    v_ason_dt        date;
    v_userid          varchar2(10);
    v_days           number(10);
    cursor c_agency is
   select Comp_Code comp_code, agcd agency_code, dpcd agency_sub_code, ag_name agency_name, City_Code city_code,
                                       nvl((select City_Name from cir_city_mast 
                                                  where Comp_Code = cir_agmast.Comp_Code 
                                                     and City_Code=cir_agmast.City_Code),'Not Define') city_name,
                                       Credit_Days credit_days from cir_agmast
                                    where Comp_Code=pcomp_code 
                                        and ((agcd=pagmain_code) or (pagmain_code is null)) 
                                        and ((dpcd=pagsub_code) or (pagsub_code is null)) 
                                        and ((ag_type=pagency_type) or (pagency_type is null)); 
 v_agency c_agency%rowtype;


v_bill_comp_code    varchar2(100);
v_bill_billno       varchar2(100);
v_bill_billdt       date;
v_bill_bill_amt     number(18,2);
v_intt_amt          number(18,2);
v_bill_unit         varchar2(20);
 cursor c_bill is
                select distinct x.comp_code,x.billno,x.billdt as billdt,sum(x.bill_amt) bill_amt,b.unit_code from
                (select distinct comp_code,billno,billdt as billdt,sum(amount) bill_amt from cir_outmast
                where comp_code=pcomp_code and
                (unit_code=nvl(punit_code,unit_code) or punit_code='') and 
                agcd=v_agency.agency_code and
                dpcd=nvl(v_agency.agency_sub_code,agcd) and
                billdt <=v_ason_dt and nvl(recptdt,billdt) <= v_ason_dt
                group by comp_code,billno,billdt having sum(amount)>0
                union
                select distinct comp_code,recptno billno,recptdt billdt,sum(amount) bill_amt from cir_outmast
                where comp_code=pcomp_code and
                (unit_code=nvl(punit_code,unit_code) or punit_code='') and
                agcd=v_agency.agency_code and
                dpcd=nvl(v_agency.agency_sub_code,dpcd) and
                recptdt <=v_ason_dt and nvl(amount,0)>0 
                and (billno is null or billno='')
                group by comp_code,recptno,recptdt having sum(amount)>0) x,cir_bill b
                where x.comp_code=b.comp_code and x.billdt=b.billdt and x.billno=b.billno and
                not exists (select 'x' from cir_interest_bill_detail d where d.comp_code=b.comp_code and d.billdt=b.billdt and d.billno=b.billno)
                group by x.comp_code,x.billno,x.billdt,b.unit_code
                order by x.billdt,x.billno;

    cursor cur_intt is
        select d.comp_code , d.bran_code ,d.agcd ,d.dpcd ,d.intt_rate ,sum(d.intt_amt) amount
            from cir_interest_bill_detail d,cir_agmast m
            where d.comp_code=m.Comp_Code and d.agcd=m.agcd and d.agcd=m.dpcd and d.post_flag='N' 
            and int_doc_no is null 
            group by d.comp_code ,d.bran_code ,d.agcd ,d.dpcd ,d.intt_rate ;
rec_intt cur_intt%rowtype;

v_pub_center    varchar2(30);
v_recptno   varchar2(50):=1;
v_vchno     varchar2(50):=1;
v_doctype   varchar2(10);
v_remark    VARCHAR2 (500);
v_pprocessdt   DATE;
v_prefix    varchar2(30);
v_branchnm  varchar2(20);
v_reason    varchar2(20);
v_dr_cdp    varchar2(20);
v_cr_cdp        varchar2(20);
begin

    v_ason_dt   :=to_date(pason_date,''''||pdateformat||'''');

    select nvl(doctyp_for_intt_adbill,'DN') ,reason_for_intt_adbill into v_doctype ,v_reason from preferrences where "comp_code"=pcomp_code;
    
    v_pprocessdt:= trunc(sysdate);
    v_remark    := 'Interest Invoice ';
    
    if v_reason is null then
        v_reason    := 'ZZ0';-- reason for Interest Invoice
    end if;    
        
    open c_agency;
    loop
        fetch c_agency into v_agency;
        exit when c_agency%notfound;

        
        open c_bill;
        loop
            fetch c_bill into v_bill_comp_code,v_bill_billno,v_bill_billdt,v_bill_bill_amt,v_bill_unit;
            exit when c_bill%notfound; 
      
            v_days:=(v_ason_dt-last_day(v_bill_billdt))-nvl(v_agency.credit_days,0)+1;
  

        if v_days<0 then
          v_days:=0;
        end if;
        
        if v_days >=nvl(poverdue_days,0) then
        
            v_intt_amt  :=round((nvl(v_bill_bill_amt,0)*pint_rate*v_days)/(100*365),2);
        
            insert into cir_interest_bill_detail
                            (comp_code , bran_code ,agcd ,dpcd ,billno ,billdt ,bill_osamt ,
                                bill_ason ,intt_rate ,intt_amt ,intt_days,credit_days,overdue_days,post_flag ,created_by ,created_dt,
                                int_date ,  int_doc_type , int_doc_no)
                      values(v_agency.comp_code,v_bill_unit,v_agency.agency_code, v_agency.agency_sub_code,v_bill_billno,v_bill_billdt,v_bill_bill_amt,
                            v_ason_dt,pint_rate,v_intt_amt,v_days,v_agency.credit_days,poverdue_days,'N',puserid,sysdate,
                            v_pprocessdt,v_doctype,null);
        end if;
        
        v_days:=0;
        v_bill_bill_amt :=0;
        v_bill_comp_code:=null;
        v_bill_billno   :=null;
        v_bill_billdt   :=null;
        v_intt_amt      :=0;  
        end loop;
        close c_bill;


        
    end loop;
    close c_agency;


    begin
        select distinct dr_cdp,cr_cdp into v_dr_cdp,v_cr_cdp
            from fa_fin_link_mast
        where comp_code         = rec_intt.comp_code
            and unit_code      = 'ALL'
            and branch_code    = 'ALL'
            and modual_alias   = 'CRCOLL'
            and doctype        = v_doctype
            and reason_paymode = v_reason
            and v_pprocessdt between eff_fr_date and eff_to_date;
               
    exception when others then
        v_dr_cdp:=null;v_cr_cdp:=null;
    end;    
    
    open cur_intt;
    loop
        fetch cur_intt into rec_intt;
        exit when cur_intt%notfound;
          
          v_cnt:=nvl(v_cnt,0)+1;
          
          select distinct substr(nvl("Branch_Alias","Branch_Name"),1,3),"pub_center" into v_branchnm,v_pub_center from branch_mst 
            where "Comp_Code"=rec_intt.comp_code and "Branch_Code"=rec_intt.bran_code;
                      
            v_prefix  :=v_doctype||'/'||v_branchnm||'/'||to_char(v_pprocessdt,'yy-mm')||'/';
            v_recptno :=ad_genreceiptno(rec_intt.comp_code,v_prefix,'',v_doctype,to_char(v_pprocessdt,''''||pdateformat||''''),pdateformat,'F');
            --v_recptno :=ad_generate_intbillno(rec_intt.comp_code,  v_pub_center,v_doctype,to_char(v_pprocessdt,'dd-mon-yyyy') ,pdateformat,pextra1,pextra2);
            
            Begin
                select  max(substr(voucherno,-5)) into v_vchno from cir_rcphdr 
                where comp_code=rec_intt.comp_code and doctype=v_doctype and to_char(recptdt,'yymm')=to_char(v_pprocessdt,'yymm');
            Exception when others then
                v_vchno:=to_char(v_pprocessdt,'yymm')||'0001';
            End;
                 
            if v_vchno is null or v_vchno='0' then
                v_vchno:=to_char(v_pprocessdt,'yymm')||'0001';
            else
                v_vchno:=lpad(to_number(v_vchno)+1,8,'0');
            end if;
            
              
            insert into cir_rcphdr(comp_code, userid, branch_code, doctype, recptno, 
                                            recptdt, reason, amount, oth_amount, chno, 
                                            chdt, chbank, remark, received_from, voucherno, 
                                            voucherdt, agcd, dpcd, ccdp, rcdp, 
                                            unit_Code)
                            values(rec_intt.comp_code, puserid, rec_intt.bran_code, v_doctype, v_recptno,
                                   v_pprocessdt, v_reason, rec_intt.amount, null, null, 
                                    null , null , v_remark, null, v_vchno, 
                                   v_pprocessdt, rec_intt.agcd, rec_intt.dpcd, v_dr_cdp, v_cr_cdp, 
                                   v_pub_center);
                                   
            insert into cir_rcpdet(comp_code, usrid, branch_code, doctyp, recptno, 
                                    recptdt, reason, voucherno, voucherdt, amount, 
                                    chno, chdt, chbnk, remark, agcd, 
                                    dpcd, unit_code)
                    values(rec_intt.comp_code,puserid,rec_intt.bran_code,v_doctype,v_recptno,
                            v_pprocessdt,v_reason,v_vchno,v_pprocessdt,rec_intt.amount,
                            null ,null ,null,v_remark,rec_intt.agcd,
                            rec_intt.dpcd,v_pub_center);

            insert into cir_outmast(comp_code, usrid, branch_Code, doctyp, recptno,
                                    recptdt, reason, voucherno, voucherdt, amount,
                                    chno, chdt, chbnk, remark, agcd, 
                                    dpcd, unit_code)
                         values(rec_intt.comp_code,puserid,rec_intt.bran_code,v_doctype,v_recptno,
                                v_pprocessdt,v_reason,v_vchno,v_pprocessdt,0,
                                null ,null ,null,v_remark,rec_intt.agcd,
                                rec_intt.dpcd,v_pub_center);
        --------debit note as billno allocate
            insert into cir_outmast (comp_code, branch_code, doctyp, reason , billno, 
                                    billdt, recptno, recptdt, chno, chdt, 
                                    chbnk, voucherno, voucherdt, amount, usrid,
                                    agcd, dpcd, remark, unit_Code)
                              values(rec_intt.comp_code,rec_intt.bran_code,v_doctype,v_reason,v_recptno,
                                    v_pprocessdt,v_recptno,v_pprocessdt,null ,null ,
                                    null,v_vchno, v_pprocessdt , abs(rec_intt.amount),puserid,
                                    rec_intt.agcd,rec_intt.dpcd,v_remark,v_pub_center);
    
    
            update cir_interest_bill_detail set post_flag='Y', int_doc_no = v_recptno
                where comp_code=rec_intt.comp_code and bran_code=rec_intt.bran_code and agcd=rec_intt.agcd and dpcd=rec_intt.dpcd and
                    post_flag='N' and int_doc_no is null/* and trunc(created_dt)=trunc(sysdate)*/;
            
    end loop;
    commit;
    close cur_intt;
    
    open p_accounts for
    select sysdate as "CUR_DATE" from dual;
    

End cir_interest_on_overdue_bill;
/

//////////////////////////////////////////////////////////END/////////////////////////////////////