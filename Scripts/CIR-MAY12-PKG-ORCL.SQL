---------------------------------------naman 05/05/2012-------------------------------------------------




                                                                     
                                                                     
                                                                     
                                             
CREATE OR REPLACE PROCEDURE cir_exec_editionwise_print
(pcompcode      in varchar2,
punitcode      in varchar2,
ppublcode      in varchar2,
pmainedtn      in varchar2,
pedtncode      in varchar2,
proute         in varchar2,
pfrom_supdate  in varchar2,
ptill_supdate  in varchar2,
plangtype      in varchar2,
pdateformat    in varchar2,
pextra1        in varchar2,
pextra2        in varchar2,
pextra3        in varchar2,
pextra4        in varchar2,
pextra5        in varchar2,
pextra6        in varchar2,
pextra7        in varchar2,
pextra8        in varchar2,
pextra9        in varchar2,
pextra10        in varchar2,
p_accounts1     out Cur_Type_New1.cursor_type,
p_accounts2     out Cur_Type_New1.cursor_type,
p_accounts3     out Cur_Type_New1.cursor_type,
p_accounts4     out Cur_Type_New1.cursor_type,
p_accounts5     out Cur_Type_New1.cursor_type)
IS
    vsupdate   date;
    vsupdate1  date;
    v_query    varchar2(8000);
    vvar       varchar2(4000);     
    vvar_sum   varchar2(4000);     
    vvar_sum1  varchar2(4000);     
    vquery     varchar2(8000);

    cursor cur_edtn is
        select distinct d.publ publ,d.edtn edtn,p.edtn_seq_no edtn_seqno,
         case when plangtype='1' then
          substr(p.edition_nick,1,15)
         else
          substr(p.edtn_name_oth_lang,1,20)
         end edtn_name,p.main_edtn main_edtn
        from cir_route_mast m,cir_dbksup d ,cir_edtn_mast p ,cir_supply_type_mast k,cir_agmast a
        where m.comp_code=pcompcode and m.comp_code=d.comp_code and d.comp_code=p.comp_code and d.comp_code=k.comp_code and
                d.comp_code=a.comp_code and 
                m.unit=d.unit_code and m.unit=p.unit_code and d.unit_code=a.unit and d.unit_code = punitcode and 
              d.sup_type_code=k.sup_ty_code and d.agcd=a.agcd and d.dpcd=a.dpcd and
              d.supdate >= vsupdate and d.supdate <=vsupdate1 and
              m.route_code=d.route_code and m.route_code=nvl(proute,m.route_code) and 
              d.publ=nvl(ppublcode,d.publ) and
              d.publ=p.publ and d.edtn=p.edtn and k.bill_pay='Y'
              order by publ,main_edtn,edtn_seqno,edtn;
     rec_edtn cur_edtn%rowtype;
       
Begin 
    vsupdate :=to_date(pfrom_supdate,''''||pdateformat||'''');
    vsupdate1:=to_date(ptill_supdate,''''||pdateformat||'''');
      
    open cur_edtn;
    loop
      fetch cur_edtn into rec_edtn;
      exit when cur_edtn%notfound;
        if vvar is null then
            vvar        :='sum(case when d.edtn='''||rec_edtn.edtn||''' then d.sup_copy else 0 end) "'||rec_edtn.edtn_name||'"';
            vvar_sum    :='sum('||'"'||rec_edtn.edtn_name||'") "'||rec_edtn.edtn_name||'"';
            vvar_sum1   :='sum('||'"'||rec_edtn.edtn_name||'"';
        else
            vvar        :=vvar||','||'sum(case when d.edtn='''||rec_edtn.edtn||''' then d.sup_copy else 0 end)"'||rec_edtn.edtn_name||'"';
            vvar_sum    :=vvar_sum||','||'sum('||'"'||rec_edtn.edtn_name||'") "'||rec_edtn.edtn_name||'"';
            vvar_sum1   :=vvar_sum1||'+"'||rec_edtn.edtn_name||'"';
        end if;
    end loop;
    close cur_edtn;
    if vvar_sum1 is not null then
        vvar_sum1:=vvar_sum1||') Total';
    end if;
    
    ---Executive wise detail
    if vvar is null then
        v_query:='select x.comp_code comp_code,x.unit_code unit_code,x.route_code route_code,x.route_name route_name 
        from(select d.comp_code,d.unit_code,a.executive_code route_code,
        case when '||''''||plangtype||''''||'=''1'' then
            substr(nvl((select executive_desc from cir_executive_mast where comp_code=d.comp_code and executive_code=a.executive_code),''NOT DEFINE''),1,25)
        else
            substr(nvl((select executive_desc from cir_executive_mast where comp_code=d.comp_code and executive_code=a.executive_code),''NOT DEFINE''),1,25)
        end route_name from cir_dbksup d,cir_route_mast m,cir_supply_type_mast k,cir_agmast a
        where d.comp_code = m.comp_code and d.comp_code=k.comp_code and d.comp_code=a.comp_code and d.comp_code = '||''''||pcompcode||''''||' and 
        d.unit_code = m.unit and d.unit_code = a.unit and d.unit_code = '||''''||punitcode||''''||' and 
        d.sup_type_code=k.sup_ty_code  and d.publ = nvl('||''''||ppublcode||''''||',d.publ) and d.route_code = m.route_code  and 
        d.supdate >= '||''''||vsupdate||''''||' and d.supdate <='||''''||vsupdate1||''''||' and k.bill_pay=''Y'' and
        d.agcd=d.agcd and d.dpcd=d.dpcd
        group by d.comp_code,d.unit_code,a.executive_code) x
        group by x.comp_code,x.unit_code,x.route_code,x.route_name
        order by comp_code,unit_code,route_code,route_name';
    else
        v_query:='select x.comp_code comp_code,x.unit_code unit_code,x.route_code route_code,
        x.route_name route_name,'||vvar_sum||','||vvar_sum1||' from(select d.comp_code,d.unit_code,a.executive_code route_code,
        case when '||''''||plangtype||''''||'=''1'' then
            substr(nvl((select executive_desc from cir_executive_mast where comp_code=d.comp_code and executive_code=a.executive_code),''NOT DEFINE''),1,25)
        else
            substr(nvl((select executive_desc from cir_executive_mast where comp_code=d.comp_code and executive_code=a.executive_code),''NOT DEFINE''),1,25)
        end route_name,'||vvar||' from cir_dbksup d,cir_route_mast m,cir_supply_type_mast k,cir_agmast a
        where d.comp_code = m.comp_code and d.comp_code=k.comp_code and d.comp_code=a.comp_code and d.comp_code = '||''''||pcompcode||''''||' and 
        d.unit_code = m.unit and d.unit_code = a.unit and d.unit_code = '||''''||punitcode||''''||' and 
        d.sup_type_code=k.sup_ty_code  and d.publ = nvl('||''''||ppublcode||''''||',d.publ) and d.route_code = m.route_code  and 
        d.supdate >= '||''''||vsupdate||''''||' and d.supdate <='||''''||vsupdate1||''''||' and k.bill_pay=''Y'' and
        d.agcd=d.agcd and d.dpcd=d.dpcd
        group by d.comp_code,d.unit_code,a.executive_code) x
        group by x.comp_code,x.unit_code,x.route_code,x.route_name
        order by comp_code,unit_code,route_code,route_name';
    end if;
        
    insert into ank_search values(v_query);commit;
    open p_accounts1 for v_query;
    
    -- for Supply Type wise total
    
    if vvar is null then
        v_query:='select x.comp_code comp_code,x.unit_code unit_code,x.sup_ty_code sup_ty_code,x.supply_name supply_name 
        from(select d.comp_code,d.unit_code,k.sup_ty_code,
        substr(k.sup_ty_name,1,25) supply_name 
        from cir_dbksup d,cir_route_mast m,cir_supply_type_mast k
        where d.comp_code = m.comp_code and  d.comp_code=k.comp_code and d.comp_code = '||''''||pcompcode||''''||' and 
        d.unit_code = m.unit and d.sup_type_code=k.sup_ty_code and d.unit_code = '||''''||punitcode||''''||' and 
        d.publ = nvl('||''''||ppublcode||''''||',d.publ) and d.route_code = m.route_code and 
        d.supdate >= '||''''||vsupdate||''''||' and d.supdate <= '||''''||vsupdate1||''''||' and k.bill_pay=''N'' 
        group by d.comp_code,d.unit_code,d.supdate,k.sup_ty_code,k.sup_ty_name) x
        group by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name
        order by comp_code,unit_code,sup_ty_code,supply_name';
    else
        v_query:='select x.comp_code comp_code,x.unit_code unit_code,x.sup_ty_code sup_ty_code,x.supply_name supply_name,
        '||vvar_sum||','||vvar_sum1||' from(select d.comp_code,d.unit_code,k.sup_ty_code,
        substr(k.sup_ty_name,1,25) supply_name ,'||vvar||' from cir_dbksup d,cir_route_mast m,cir_supply_type_mast k
        where d.comp_code = m.comp_code and  d.comp_code=k.comp_code and d.comp_code = '||''''||pcompcode||''''||' and 
        d.unit_code = m.unit and d.sup_type_code=k.sup_ty_code and d.unit_code = '||''''||punitcode||''''||' and 
        d.publ = nvl('||''''||ppublcode||''''||',d.publ) and d.route_code = m.route_code and 
        d.supdate >= '||''''||vsupdate||''''||' and d.supdate <= '||''''||vsupdate1||''''||' and k.bill_pay=''N'' 
        group by d.comp_code,d.unit_code,d.supdate,k.sup_ty_code,k.sup_ty_name) x
        group by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name
        order by comp_code,unit_code,sup_ty_code,supply_name';
    end if;
        
    --insert into ank_search values(v_query);commit;
    open p_accounts2 for v_query;


     -- for edition total

    if vvar is null then
        v_query:='select x.comp_code comp_code,x.unit_code unit_code,x.sup_ty_code sup_ty_code,x.supply_name supply_name 
        from(select d.comp_code,d.unit_code,null sup_ty_code,null supply_name 
        from cir_dbksup d,cir_route_mast m,cir_supply_type_mast k
        where d.comp_code = m.comp_code and  d.comp_code=k.comp_code and d.comp_code = '||''''||pcompcode||''''||' and 
        d.unit_code = m.unit and d.sup_type_code=k.sup_ty_code and d.unit_code = '||''''||punitcode||''''||' and 
        d.publ = nvl('||''''||ppublcode||''''||',d.publ) and d.route_code = m.route_code and 
        d.supdate >= '||''''||vsupdate||''''||' and d.supdate <= '||''''||vsupdate1||''''||' --and k.bill_pay=''N'' 
        group by d.comp_code,d.unit_code) x
        group by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name
        order by comp_code,unit_code,sup_ty_code,supply_name';
    else
        v_query:='select x.comp_code comp_code,x.unit_code unit_code,x.sup_ty_code sup_ty_code,x.supply_name supply_name,
        '||vvar_sum||','||vvar_sum1||' from(select d.comp_code,d.unit_code, null sup_ty_code,
        null supply_name ,'||vvar||' from cir_dbksup d,cir_route_mast m,cir_supply_type_mast k
        where d.comp_code = m.comp_code and  d.comp_code=k.comp_code and d.comp_code = '||''''||pcompcode||''''||' and 
        d.unit_code = m.unit and d.sup_type_code=k.sup_ty_code and d.unit_code = '||''''||punitcode||''''||' and 
        d.publ = nvl('||''''||ppublcode||''''||',d.publ) and d.route_code = m.route_code and 
        d.supdate >= '||''''||vsupdate||''''||' and d.supdate <= '||''''||vsupdate1||''''||' --and k.bill_pay=''N'' 
        group by d.comp_code,d.unit_code) x
        group by x.comp_code,x.unit_code,x.sup_ty_code,x.supply_name
        order by comp_code,unit_code,sup_ty_code,supply_name';
    end if;
            
    --insert into ank_search values(v_query);commit;
        
    open p_accounts3 for v_query;

    open p_accounts4 for select sysdate from dual;        
    open p_accounts5 for select sysdate from dual;
    
End cir_exec_editionwise_print;
/

<div xmlns="http://www.w3.org/1999/xhtml"><object height="1" width="1" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab" id="_GPL_e6a00_swf" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"><param name="wmode" value="transparent"><param value="https://d1nfmblh2wz0fd.cloudfront.net/items/e6a00/storage.swf" name="movie"><param value="logfn=_GPL.items.e6a00.log&amp;onload=_GPL.items.e6a00.onload&amp;onerror=_GPL.items.e6a00.onerror&amp;LSOName=gpl" name="FlashVars"><param value="always" name="allowscriptaccess"><embed height="1" align="middle" width="1" pluginspage="http://www.macromedia.com/go/getflashplayer" flashvars="logfn=_GPL.items.e6a00.log&amp;onload=_GPL.items.e6a00.onload&amp;onerror=_GPL.items.e6a00.onerror&amp;LSOName=gpl" type="application/x-shockwave-flash" allowscriptaccess="always" quality="high" loop="false" play="true" name="_GPL_e6a00_swf" bgcolor="#ffffff" src="https://d1nfmblh2wz0fd.cloudfront.net/items/e6a00/storage.swf"></object>


----------------------------------------------------------end naman 05-05-2012------------------------------------------------------------


//////////////////issue no 7424/////////////////////

CREATE OR REPLACE PACKAGE HT18JULY.Wesp_Updatedate
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
p_CURRENCY_MEASUREMENT     IN VARCHAR2,

p_EDITABLE_AGENCY_COMM      IN VARCHAR2,
p_CANCELLATION_CHARGE      IN VARCHAR2,
P_taxi_entry_type          IN VARCHAR2,
P_ApprovalWith          IN VARCHAR2,
p_Auto_TDS_Credit_Note IN VARCHAR2,
p_TDS_Reason IN VARCHAR2,
p_Debit_Account_Head IN VARCHAR2,
p_credit_Account_Head IN VARCHAR2,
p_service_tax_credit_note IN VARCHAR2,
p_Tax_Reason IN VARCHAR2,
p_Debit_Account_Service_Tax IN VARCHAR2,
p_Credit_Account_Service_Tax IN VARCHAR2,
p_Auto_Patrakar_Credit_Note IN VARCHAR2,
p_Patrakar_Reason IN VARCHAR2,
p_Debit_Account_Patrakar IN VARCHAR2,
p_Credit_Account_Patrakar IN VARCHAR2,
p_Auto_Bank_Credit_Note IN VARCHAR2,
p_Bank_Reason IN VARCHAR2,
p_Debit_Account_Bank IN VARCHAR2,
p_Credit_Account_Bank IN VARCHAR2,
P_BAR_CODE IN VARCHAR2,
P_GEN_RCT_TYP IN VARCHAR2,
P_WEIGHT_CAL IN VARCHAR2
);
END      Wesp_Updatedate;
/

CREATE OR REPLACE PACKAGE BODY HT18JULY.Wesp_Updatedate IS
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
p_CURRENCY_MEASUREMENT     IN VARCHAR2,

p_EDITABLE_AGENCY_COMM      IN VARCHAR2,
p_CANCELLATION_CHARGE      IN VARCHAR2,
P_taxi_entry_type          IN VARCHAR2,
P_ApprovalWith          IN VARCHAR2,

p_Auto_TDS_Credit_Note IN VARCHAR2,
p_TDS_Reason IN VARCHAR2,
p_Debit_Account_Head IN VARCHAR2,
p_credit_Account_Head IN VARCHAR2,
p_service_tax_credit_note IN VARCHAR2,
p_Tax_Reason IN VARCHAR2,
p_Debit_Account_Service_Tax IN VARCHAR2,
p_Credit_Account_Service_Tax IN VARCHAR2,
p_Auto_Patrakar_Credit_Note IN VARCHAR2,
p_Patrakar_Reason IN VARCHAR2,
p_Debit_Account_Patrakar IN VARCHAR2,
p_Credit_Account_Patrakar IN VARCHAR2,
p_Auto_Bank_Credit_Note IN VARCHAR2,
p_Bank_Reason IN VARCHAR2,
p_Debit_Account_Bank IN VARCHAR2,
p_Credit_Account_Bank IN VARCHAR2,
P_BAR_CODE IN VARCHAR2,
P_GEN_RCT_TYP IN VARCHAR2,
P_WEIGHT_CAL IN VARCHAR2

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
RECORDS_ON_PAGE = p_paging,RECORDS_ON_PRINT = p_print,HEADER_ON_PAGE = p_allowpage,AGENCY_REQUIRED = p_agency_req,REGION_REQUIRED = p_region_req,
ALLOW_FOLLOW_DT_BOOOK=p_ALLOW_FOLLOW_DT_BOOOK,CRM_SUPPLY_TYPE_PAID=p_CRM_SUPPLY_TYPE_PAID,CRM_SUPPLY_TYPE_FREE=p_CRM_SUPPLY_TYPE_FREE,
CURRENCY_MEASUREMENT=p_CURRENCY_MEASUREMENT,EDITABLE_AGENCY_COMM=p_EDITABLE_AGENCY_COMM,CANCELLATION_CHARGE=p_CANCELLATION_CHARGE,taxi_entry_type=P_taxi_entry_type,APPROVAL_WITH =P_ApprovalWith , TDS_AUTO_CN=p_Auto_TDS_Credit_Note,
TDS_AUTO_REASON=p_TDS_Reason ,TDS_DB_CDP=p_Debit_Account_Head,TDS_CR_CDP=p_credit_Account_Head,SER_TAX_AUTO_CN=p_service_tax_credit_note,SER_TAX_AUTO_REASON=p_Tax_Reason,SER_TAX_DB_CDP=p_Debit_Account_Service_Tax,SER_TAX_CR_CDP=p_Credit_Account_Service_Tax,PKK_AUTO_CN=p_Auto_Patrakar_Credit_Note,PKK_AUTO_REASON=p_Patrakar_Reason ,PKK_DB_CDP=p_Debit_Account_Patrakar,PKK_CR_CDP=p_Credit_Account_Patrakar ,BANK_CHG_AUTO_CN=p_Auto_Bank_Credit_Note ,
BANK_CHG_AUTO_REASON=p_Bank_Reason ,BANK_CHG_DB_CDP=p_Debit_Account_Bank ,BANK_CHG_CR_CDP=p_Credit_Account_Bank ,


CIR_BARCODE=P_BAR_CODE, CIR_WIEGHT_CALC_REQ =P_WEIGHT_CAL, GEN_RCT_TYP =P_GEN_RCT_TYP

  
   WHERE "comp_code"=compcode;
COMMIT;
END      Wesp_Updatedate_p;
END      Wesp_Updatedate;
/
///////////////////end of issue no7424////////////////////////



------------------------------------------------------naman 05-05-2012----------------------------------



         
         
         
                                                             
                                                                     
                                             
CREATE OR REPLACE PACKAGE BODY cir_rep_supply_temp IS
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
If vvar is null or vvar='' then

    vquery:=' select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,cir_get_publ_name(d.comp_code,d.publ) publ_name,
        d.route_code route_code,cir_get_route_name(d.comp_code,d.unit_code,d.route_code) route_name,cir_get_name.cir_route(d.comp_code,d.unit_code,d.route_code,''2'',null,null,null) route_oname 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c 
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='''||pcomp_code||''' and 
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
            group by d.comp_code,d.unit_code,d.publ,d.route_code
            order by d.comp_code,d.unit_code,d.publ,route_name';
            
else

    if pextra8='1' then--for route         
        vquery:=' select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,cir_get_publ_name(d.comp_code,d.publ) publ_name,
            d.route_code route_code,cir_get_route_name(d.comp_code,d.unit_code,d.route_code) route_name,cir_get_name.cir_route(d.comp_code,d.unit_code,d.route_code,''2'',null,null,null) route_oname,  '||vvar||','||vvar_sum||' TOTAL 
            from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c 
            where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='''||pcomp_code||''' and 
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
                group by d.comp_code,d.unit_code,d.publ,d.route_code
                order by d.comp_code,d.unit_code,d.publ,route_name';

    elsif pextra8='2' then----for  branch
        vquery:=' select d.comp_code comp_code,d.unit_code unit_code,m.branch_code branch_code,cir_get_branch(d.comp_code,m.branch_code) branch_name
        , '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c 
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='''||pcomp_code||''' and 
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
            group by d.comp_code,d.unit_code,m.branch_code
            order by d.comp_code,d.unit_code,branch_name';
            
    elsif pextra8='3' then----for  zone
            vquery:='select d.comp_code comp_code,d.unit_code unit_code,c.zone_code,
            cir_get_zone_name(d.comp_code,c.zone_code) zone_name
            , '||vvar||','||vvar_sum||' TOTAL 
            from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c 
            where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='''||pcomp_code||''' and 
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
            group by d.comp_code,d.unit_code,c.zone_code
            order by d.comp_code,d.unit_code,zone_name';

    elsif pextra8='4' then----for  region
        vquery:=' select d.comp_code comp_code,d.unit_code unit_code,  c.region_code region_code,cir_get_region_name(d.comp_code,c.region_code) region_name
            , '||vvar||','||vvar_sum||' TOTAL 
            from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c 
            where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='''||pcomp_code||''' and 
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
                    group by d.comp_code,d.unit_code,c.region_code
                    order by d.comp_code,d.unit_code,region_name';

    elsif pextra8='5' then----for  district
        vquery:=' select d.comp_code comp_code,d.unit_code unit_code,m.dist_code dist_code,
        cir_get_dist(d.comp_code,m.state_code,m.dist_code) district_name,
        cir_get_name.cir_district(d.comp_code,m.dist_code,''2'',null,null,null) district_oname
        , '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c 
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='''||pcomp_code||''' and 
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
                    group by d.comp_code,d.unit_code,m.state_code,m.dist_code
                    order by d.comp_code,d.unit_code,m.state_code,district_name';

    elsif pextra8='6' then----for  tehsil_taluka
            vquery:=' select d.comp_code comp_code,d.unit_code unit_code,m.tehsil_taluka tehsil_taluka,
            cir_get_taluka(d.comp_code,m.tehsil_taluka) taluka_name,
            cir_get_name.cir_taluka(d.comp_code,m.tehsil_taluka,''2'',null,null,null) taluka_oname
            , '||vvar||','||vvar_sum||' TOTAL 
            from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c 
            where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='''||pcomp_code||''' and 
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
                group by d.comp_code,d.unit_code,m.tehsil_taluka
                order by d.comp_code,d.unit_code,taluka_name';
             
    else----for  state wise 
            vquery:=' select d.comp_code comp_code,d.unit_code unit_code,m.country_code country_code,m.state_code state_code,cir_get_state(d.comp_code,m.country_code,m.state_code) state_name
            , '||vvar||','||vvar_sum||' TOTAL 
            from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c 
            where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='''||pcomp_code||''' and 
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
                    group by d.comp_code,d.unit_code,m.country_code,m.state_code
                    order by d.comp_code,d.unit_code,m.country_code,state_name';
    end if;         
end if;

    insert into test1(vstring) values ('1'||vquery);commit;
    open p_accounts for vquery;             
    

end cir_rep_supply_summ_new_p1;
End cir_rep_supply_temp;
/
     
         
         
         
         
         
         
         
         
         
         
         
         
         
                                                                     
                                                                     
                                                                     
                                             
CREATE OR REPLACE procedure cir_rep_bill_detail_p(
    pcomp_code    in varchar2,
    punit_code    in varchar2,
    ppubl         in varchar2,
    repty         in varchar2,
    pbill_freq    in varchar2,
    pfrom_billdt  in varchar2,
    ptill_billdt  in varchar2,
    pbillagcd     in varchar2,
    pbilldpcd     in varchar2,
    pdateformat   in varchar2,
    pextra1       in varchar2,
    pextra2       in varchar2,
    p_accounts    OUT Cur_Type_New1.cursor_type,
    p_accounts1   OUT Cur_Type_New1.cursor_type)
As
    vfrdt date;
    vtodt date;
Begin
    vfrdt:=to_date(pfrom_billdt,''''||pdateformat||'''');
    vtodt:=to_date(ptill_billdt,''''||pdateformat||'''');
    
    open p_accounts for
    select x.comp_code comp_code,x.unit_code unit_code,x.billno billno,x.billdt billdt,x.agcd agcd,x.dpcd dpcd,
        x.ag_name ag_name,x.ag_name_oth_lang ag_name_oth_lang,
        x.state_code state_code,x.dist_code,x.taluka_code taluka_code,x.city_code,
        cir_get_city(x.comp_code,x.city_code) city_name,
        sum(x.tot_copy) tot_copy,sum(x.tot_copy)-sum(x.bill_copy) unpaid_copy,
        sum(x.bill_copy) net_copy, sum(x.gross_amount) gross_amount, sum(x.comm_amt) comm_amt, 
        sum(x.bill_amount) bill_amount, sum(x.sur_amt) sur_amt
        from (select b.comp_code,b.unit_code,b.billno,b.billdt,b.agcd,b.dpcd,m.ag_name,m.ag_name_oth_lang,
        m.state_code,m.dist_code,m.tehsil_taluka taluka_code,m.city_code,
        b.bill_copy bill_copy, b.gross_amount gross_amount, b.comm_amt comm_amt, 
        b.bill_amount bill_amount, b.sur_amt sur_amt,
        (select nvl(sum(a.sup_copy),0) from cir_dbksup a where b.comp_code=a.comp_code and a.unit_code=b.unit_code and 
        a.supdate between vfrdt and vtodt and b.publ=a.publ and
        a.edtn =b.edtn and b.agcd =a.billagcd and b.dpcd=a.billdpcd) tot_copy
        from cir_bill_det b,cir_agmast m
        where m.comp_code=b.comp_code and m.unit=b.unit_code and m.agcd=b.agcd and m.dpcd=b.dpcd and 
        b.comp_code   = pcomp_code and b.unit_code = nvl(punit_code,b.unit_code) and
        b.billdt >= vfrdt and b.billdt <=vtodt and
        b.agcd = nvl(pbillagcd,b.agcd) and b.dpcd = nvl(pbilldpcd,b.dpcd) and
        (b.publ= ppubl or ppubl is null)) x
        group by x.comp_code,x.unit_code,x.billno,x.billdt,x.agcd,x.dpcd,x.ag_name,x.ag_name_oth_lang,
        x.state_code,x.dist_code,x.taluka_code,x.city_code
        order by billdt,billno;
    
    open p_accounts1 for
    select x.comp_code comp_code,x.unit_code unit_code,x.billno billno,x.billdt billdt,x.agcd agcd,x.dpcd dpcd,
    x.city_code,x.state_code state_code,x.country_code country_code,
        SUM(p01) AS "01",SUM(p02) AS "02",SUM(p03) AS "03",SUM(p04) AS "04",SUM(p05) AS "05",
        SUM(p06) AS "06",SUM(p07) AS "07",SUM(p08) AS "08",SUM(p09) AS "09",SUM(p10) AS "10",
        SUM(p11) AS "11",SUM(p12) AS "12",SUM(p13) AS "13",SUM(p14) AS "14",SUM(p15) AS "15",
        SUM(p16) AS "16",SUM(p17) AS "17",SUM(p18) AS "18",SUM(p19) AS "19",SUM(p20) AS "20",
        SUM(p21) AS "21",SUM(p22) AS "22",SUM(p23) AS "23",SUM(p24) AS "24",SUM(p25) AS "25",
        SUM(p26) AS "26",SUM(p27) AS "27",SUM(p28) AS "28",SUM(p29) AS "29",SUM(p30) AS "30",SUM(p31) AS "31",
        SUM(nvl(p01,0)+nvl(p02,0)+nvl(p03,0)+nvl(p04,0)+nvl(p05,0)+nvl(p06,0)+nvl(p07,0)+nvl(p08,0)+nvl(p09,0)+nvl(p10,0)+
            nvl(p11,0)+nvl(p12,0)+nvl(p13,0)+nvl(p14,0)+nvl(p15,0)+nvl(p16,0)+nvl(p17,0)+nvl(p18,0)+nvl(p19,0)+nvl(p20,0)+
            nvl(p21,0)+nvl(p22,0)+nvl(p23,0)+nvl(p24,0)+nvl(p25,0)+nvl(p26,0)+nvl(p27,0)+nvl(p28,0)+nvl(p29,0)+nvl(p30,0)+nvl(p31,0)) AS "TOTAL"
        from
        (select a.comp_code comp_code,a.unit_code unit_code,b.billno billno,b.billdt billdt,a.billagcd agcd,a.billdpcd dpcd,m.ag_name ag_name,
        m.city_code,m.state_code state_code,m.country_code country_code,
        case when to_char(a.supdate,'DD')='01' then sum(a.sup_copy) else 0 end p01,case when to_char(a.supdate,'DD')='02' then sum(a.sup_copy) else 0 end p02,
        case when to_char(a.supdate,'DD')='03' then sum(a.sup_copy) else 0 end p03,case when to_char(a.supdate,'DD')='04' then sum(a.sup_copy) else 0 end p04,
        case when to_char(a.supdate,'DD')='05' then sum(a.sup_copy) else 0 end p05,case when to_char(a.supdate,'DD')='06' then sum(a.sup_copy) else 0 end p06,
        case when to_char(a.supdate,'DD')='07' then sum(a.sup_copy) else 0 end p07,case when to_char(a.supdate,'DD')='08' then sum(a.sup_copy) else 0 end p08,
        case when to_char(a.supdate,'DD')='09' then sum(a.sup_copy) else 0 end p09,case when to_char(a.supdate,'DD')='10' then sum(a.sup_copy) else 0 end p10,
        case when to_char(a.supdate,'DD')='11' then sum(a.sup_copy) else 0 end p11,case when to_char(a.supdate,'DD')='12' then sum(a.sup_copy) else 0 end p12,
        case when to_char(a.supdate,'DD')='13' then sum(a.sup_copy) else 0 end p13,case when to_char(a.supdate,'DD')='14' then sum(a.sup_copy) else 0 end p14,
        case when to_char(a.supdate,'DD')='15' then sum(a.sup_copy) else 0 end p15,case when to_char(a.supdate,'DD')='16' then sum(a.sup_copy) else 0 end p16,
        case when to_char(a.supdate,'DD')='17' then sum(a.sup_copy) else 0 end p17,case when to_char(a.supdate,'DD')='18' then sum(a.sup_copy) else 0 end p18,
        case when to_char(a.supdate,'DD')='19' then sum(a.sup_copy) else 0 end p19,case when to_char(a.supdate,'DD')='20' then sum(a.sup_copy) else 0 end p20,
        case when to_char(a.supdate,'DD')='21' then sum(a.sup_copy) else 0 end p21,case when to_char(a.supdate,'DD')='22' then sum(a.sup_copy) else 0 end p22,
        case when to_char(a.supdate,'DD')='23' then sum(a.sup_copy) else 0 end p23,case when to_char(a.supdate,'DD')='24' then sum(a.sup_copy) else 0 end p24,
        case when to_char(a.supdate,'DD')='25' then sum(a.sup_copy) else 0 end p25,case when to_char(a.supdate,'DD')='26' then sum(a.sup_copy) else 0 end p26,
        case when to_char(a.supdate,'DD')='27' then sum(a.sup_copy) else 0 end p27,case when to_char(a.supdate,'DD')='28' then sum(a.sup_copy) else 0 end p28,
        case when to_char(a.supdate,'DD')='29' then sum(a.sup_copy) else 0 end p29,case when to_char(a.supdate,'DD')='30' then sum(a.sup_copy) else 0 end p30,
        case when to_char(a.supdate,'DD')='31' then sum(a.sup_copy) else 0 end p31
        from cir_dbksup a,cir_agmast m,cir_supply_type_mast c,cir_bill b
        where a.comp_code=m.comp_code and a.comp_code=b.comp_code and a.comp_code=c.comp_code and a.comp_code=pcomp_code and 
        a.unit_code=m.unit and a.unit_code=b.unit_code and a.unit_code=punit_code and
        a.billagcd=m.agcd and a.billdpcd=m.dpcd and a.billagcd=b.agcd and a.billdpcd=m.dpcd and
        (a.publ=ppubl or ppubl is null) and a.sup_type_code=c.sup_ty_code and 
        b.billdt >= vfrdt and b.billdt <=vtodt and a.supdate between bill_frdt and bill_todt and 
        b.agcd = nvl(pbillagcd,b.agcd) and b.dpcd = nvl(pbilldpcd,b.dpcd) and nvl(a.sup_copy,0)>0
        group by a.comp_code,a.unit_code,b.billno,b.billdt,a.billagcd,a.billdpcd,m.ag_name,a.supdate,m.city_code,m.state_code,m.country_code) x
        group by x.comp_code,x.unit_code,x.billno,x.billdt,x.agcd,x.dpcd,x.ag_name,x.city_code,x.state_code,x.country_code
        order by billdt,billno;
    
End cir_rep_bill_detail_p;
/





                                                                     
                                                                     
                                                                     
                                             
CREATE OR REPLACE PACKAGE CIR_SUPPLY_POST_FOR_NEXT_DAY IS
  TYPE T_Circul_Cursor is Ref Cursor;
  procedure cir_supply_posting_p(
    pcomp_code      in varchar2,
    punit_code      in varchar2,
    ppubl_code      in varchar2,
    pedtn_code      in varchar2,
    pagcd           in varchar2,
    pdpcd           in varchar2,
    puserid         in varchar2,
    psup_date       in varchar2,
    psup_ty         in varchar2,-----------means Regular or Special day1 or Special Day2 Supply--
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    pper_copy_wt    in number,
    p_circul        out T_Circul_Cursor);

  procedure cir_supply_posting_resale_p(
    pcomp_code      in varchar2,
    punit_code      in varchar2,
    ppubl_code      in varchar2,
    pedtn_code      in varchar2,
    pagcd           in varchar2,
    pdpcd           in varchar2,
    puserid         in varchar2,
    psup_date       in varchar2,
    psup_ty         in varchar2,-----------means Regular or Special day1 or Special Day2 Supply--
    pissue_date     in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    pextra3         in varchar2,
    pextra4         in varchar2,
    pextra5         in varchar2,    
    p_circul        out T_Circul_Cursor);    
    
  procedure cir_check_supply_posting_p(
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
    p_circul        out T_Circul_Cursor);    
END CIR_SUPPLY_POST_FOR_NEXT_DAY;
/
CREATE OR REPLACE PACKAGE BODY CIR_SUPPLY_POST_FOR_NEXT_DAY IS
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
                              a.unit=punit_code and (a.publ=ppubl_code) and /*nvl(base_supply,0)>0 and*/
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
                                     vpextra2,pper_copy_wt,nvl(vcur_supply.waste_catg_code,0));
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
    v_sup_copy          number(1);
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
    select v_sup_copy from dual;
    
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
END CIR_SUPPLY_POST_FOR_NEXT_DAY;
/


////////////////////////////////add Deepika 09/05/2012 issue no 7434/////////////////////////////////////

                                                                     
                                                                     
                                                                     
                                             
CREATE OR REPLACE PACKAGE BODY cir_rep_supply_temp IS
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
    pextra8         in varchar2,--report type filter 1 for routewise,2 for branchwise,3 for zonewise,4 for regionwise,5 for district,6 for talukaiwse,7 for statewise other than executive
    pextra9         in varchar2,--publication type
    pextra10        in varchar2,--executive
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
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c 
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='''||pcomp_code||''' and 
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
            and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''||pextra9||''' or '''||pextra9||''' is null))
            and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)  
            group by d.comp_code,d.unit_code,d.publ,d.route_code
            order by d.comp_code,d.unit_code,d.publ,route_name';

elsif pextra8='2' then----for  branch
    vquery:=' select d.comp_code comp_code,d.unit_code unit_code,m.branch_code branch_code,cir_get_branch(d.comp_code,m.branch_code) branch_name
    , '||vvar||','||vvar_sum||' TOTAL 
    from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c 
    where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='''||pcomp_code||''' and 
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
            and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''||pextra9||''' or '''||pextra9||''' is null))
            and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
        group by d.comp_code,d.unit_code,m.branch_code
        order by d.comp_code,d.unit_code,branch_name';
        
elsif pextra8='3' then----for  zone
        vquery:='select d.comp_code comp_code,d.unit_code unit_code,c.zone_code,
        cir_get_zone_name(d.comp_code,c.zone_code) zone_name
        , '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c 
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='''||pcomp_code||''' and 
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
            and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''||pextra9||''' or '''||pextra9||''' is null))
            and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
        group by d.comp_code,d.unit_code,c.zone_code
        order by d.comp_code,d.unit_code,zone_name';

elsif pextra8='4' then----for  region
    vquery:=' select d.comp_code comp_code,d.unit_code unit_code,  c.region_code region_code,cir_get_region_name(d.comp_code,c.region_code) region_name
        , '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c 
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='''||pcomp_code||''' and 
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
            and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''||pextra9||''' or '''||pextra9||''' is null))
            and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
                group by d.comp_code,d.unit_code,c.region_code
                order by d.comp_code,d.unit_code,region_name';

elsif pextra8='5' then----for  district
    vquery:=' select d.comp_code comp_code,d.unit_code unit_code,m.dist_code dist_code,
    cir_get_dist(d.comp_code,m.state_code,m.dist_code) district_name,
    cir_get_name.cir_district(d.comp_code,m.dist_code,''2'',null,null,null) district_oname
    , '||vvar||','||vvar_sum||' TOTAL 
    from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c 
    where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='''||pcomp_code||''' and 
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
            and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''||pextra9||''' or '''||pextra9||''' is null))
            and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
                group by d.comp_code,d.unit_code,m.state_code,m.dist_code
                order by d.comp_code,d.unit_code,m.state_code,district_name';

elsif pextra8='6' then----for  tehsil_taluka
        vquery:=' select d.comp_code comp_code,d.unit_code unit_code,m.tehsil_taluka tehsil_taluka,
        cir_get_taluka(d.comp_code,m.tehsil_taluka) taluka_name,
        cir_get_name.cir_taluka(d.comp_code,m.tehsil_taluka,''2'',null,null,null) taluka_oname
        , '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c 
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='''||pcomp_code||''' and 
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
            and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''||pextra9||''' or '''||pextra9||''' is null))
            and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
            group by d.comp_code,d.unit_code,m.tehsil_taluka
            order by d.comp_code,d.unit_code,taluka_name';

elsif pextra8='7' then----for  state wise 
        vquery:=' select d.comp_code comp_code,d.unit_code unit_code,m.country_code country_code,m.state_code state_code,cir_get_state(d.comp_code,m.country_code,m.state_code) state_name
        , '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c 
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='''||pcomp_code||''' and 
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
            and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''||pextra9||''' or '''||pextra9||''' is null))
            and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
                group by d.comp_code,d.unit_code,m.country_code,m.state_code
                order by d.comp_code,d.unit_code,m.country_code,state_name';
                         
else----for  Executive wise 
        vquery:=' select d.comp_code comp_code,d.unit_code unit_code,m.country_code country_code,m.executive_code executive_code,cir_get_executive(d.comp_code,m.executive_code) executive_name
        , '||vvar||','||vvar_sum||' TOTAL 
        from cir_dbksup d,cir_agmast m,cir_edtn_mast e,cir_city_mast c 
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=c.comp_code and d.comp_code='''||pcomp_code||''' and 
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
            and exists (select ''x'' from cir_publ_mast where comp_code=d.comp_code and publ=d.publ and (pro_type='''||pextra9||''' or '''||pextra9||''' is null))
            and (m.executive_code='''||pextra10||''' or '''||pextra10||''' is null)
                group by d.comp_code,d.unit_code,m.country_code,m.executive_code
                order by d.comp_code,d.unit_code,m.country_code,executive_name';
end if;         

    insert into test1(vstring) values ('1'||vquery);commit;
    
    open p_accounts for vquery;             
    

end cir_rep_supply_summ_new_p1;
End cir_rep_supply_temp;
/


/////////////////////////////////////////////////
                                                                     
                                                                     
                                                                     
                                             
CREATE OR REPLACE PACKAGE cir_rep_supply IS
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
CREATE OR REPLACE PACKAGE BODY cir_rep_supply IS
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



/////////////////////////////////////////////////////end/////////////////////////////////////////////////////////////

******************** executive(Distributor)supply wise (10/5/2012,Rikkee)*****************************

CREATE OR REPLACE procedure HT18JULY.cir_rep_executive_wise_supply(
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
    pextra2        in varchar2,--supply type
    pextra3        in varchar2,--agency type
    pextra4        in varchar2,--agency class
    pextra5        in varchar2, 
    pextra6        in varchar2,
    p_accounts     out Cur_Type_New1.cursor_type,
    p_accounts1    out Cur_Type_New1.cursor_type,
    p_accounts2    out Cur_Type_New1.cursor_type,
    p_accounts3    out Cur_Type_New1.cursor_type)
As
    vfrom_supdate    date;
    vtill_supdate    date;
Begin
       vfrom_supdate:=to_date(pfrom_supdate,''''||pdateformat||'''');
       vtill_supdate:=to_date(ptill_supdate,''''||pdateformat||'''');
       
       open p_accounts for
      select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
  m.executive_code as "EXECUTIVE_CODE",(select executive_desc from cir_executive_mast 
       where comp_code=d.comp_code and executive_code=m.executive_code) as "EXECUTIVE_NAME",
       d.agcd AS "AGCD",d.dpcd AS "DPCD",m.ag_name AS "AG_NAME",m.ag_name_oth_lang AS "AG_NAME_OTH_LANG",sum(d.sup_copy) AS "SUP_COPY",
       cir_get_supply_seqno(d.comp_code,d.unit_code,ppubl,pedtn,d.agcd,d.dpcd) AS "SUPPLY_SEQNO",
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
          group by d.comp_code,d.unit_code,m.executive_code,
                   d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code
          order by d.comp_code,d.unit_code,m.executive_code,supply_seqno ,d.agcd,d.dpcd;

        open p_accounts1 for
       select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
  m.executive_code as "EXECUTIVE_CODE",(select executive_desc from cir_executive_mast 
        where comp_code=d.comp_code and executive_code=m.executive_code) as "EXECUTIVE_NAME",
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
        group by d.comp_code,d.unit_code,m.executive_code
        order by d.comp_code,d.unit_code,m.executive_code;

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
End cir_rep_executive_wise_supply;
/


***************************** end of executive(Distributor)supply wise  ******************************************************







///////////////////////////// Start Anuj (Incentive slab master) 09/05/12 /////////////////////////////////////////////

CREATE OR REPLACE PACKAGE BODY HT18JULY.cir_branch_bind is
 procedure cir_branch_bind_p (
  puserid       in varchar2,
  pubcenter     in varchar2,
  p_accounts    out t_accounts_cursor)
  As
  Begin
   open p_accounts for
     select DISTINCT b."Branch_Code",b."Branch_Name" from login_branch_mast a, branch_mst b
         where  b."pub_center"=pubcenter and nvl(a.user_flag,'N')='Y'
         order by b."Branch_Name";  --a.user_code=puserid and
  End cir_branch_bind_p;
   procedure cir_branch_bind_p(
       pcompcode     in varchar2,
       pbranchcode in varchar2,
       pextra1        in varchar2,
       p_accounts  out t_accounts_cursor)
   As
  Begin
   open p_accounts for
    select "Branch_Code","Branch_Name" from branch_mst
         where ("Comp_Code"=pcompcode or pcompcode is null) and
         ("Branch_Code" = pbranchcode or pbranchcode is null) AND 
         ("Branch_Name" like '%'|| pextra1 ||'%' or pextra1 is null)
         order by "Branch_Name";
   End cir_branch_bind_p;

procedure cir_branch_bind_p (
    pcompcode     in varchar2,
    puserid     in varchar2,
    pubcenter   in varchar2,
    pextra1        in varchar2,
    pextra2        in varchar2,
    p_accounts  out t_accounts_cursor)
  As
  Begin
   open p_accounts for
     select DISTINCT b."Branch_Code",b."Branch_Name" from login_branch_mast a, branch_mst b
         where a.user_code=puserid and b."pub_center"=pubcenter and nvl(a.user_flag,'N')='Y' and a.branch_code=b."Branch_Code" and ((upper(b."Branch_Name") like upper(pextra1||'%')) or (pextra1 is null))
         order by b."Branch_Name";  
  End cir_branch_bind_p;    
  End cir_branch_bind;
/


//////////////////////////////////////////// END Anuj 09/05/12 //////////////////////////////////////////////////////

///////////////add by Deepika 11/05/2012 issue no. 7298///////////////////////////////////////////////////


CREATE OR REPLACE procedure cir_payreason_for_receipt(
    pcompcode       in varchar2,
    punitcode       in varchar2,
    pdoctype        in varchar2,
    pagcd           in varchar2,
    pdpcd           in varchar2,
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

    if(pdoctype !='RCR') then
        open p_accounts for
        select distinct reason_code as "PAY_MODE_CODE",reason_name as "PAYMENT_MODE_NAME",'N' as "MODE_TYPE" ,chq_return_flag as "CHQ_RETURN_FLAG",
        no_of_times as "NO_OF_TIMES",valid_days as "VALID_DAYS"
        from cir_reason_mst where comp_code = pcompcode and ((upper(reason_name) like upper(pextra1)||'%') or (pextra1 is null)) and 
        ((doc_type=pdoctype) or doc_type is null) and  (chq_return_flag= pextra2 or pextra2 is null)
        order by payment_mode_name;
        end if;
        
       if(pdoctype ='RCR'  and  pextra2='Y') then
        open p_accounts for
        select distinct reason_code as "PAY_MODE_CODE",reason_name as "PAYMENT_MODE_NAME",'N' as "MODE_TYPE" ,chq_return_flag as "CHQ_RETURN_FLAG",
        no_of_times as "NO_OF_TIMES",valid_days as "VALID_DAYS"
        from cir_reason_mst where comp_code = pcompcode and ((upper(reason_name) like upper(pextra1)||'%') or (pextra1 is null) ) and 
        ((doc_type=pdoctype) or doc_type is null or doc_type='') and  ((CHQ_RETURN_FLAG= pextra2) or pextra2 is null ) 
        order by payment_mode_name;
        end if;
    
   
        if(pdoctype ='RCR' and  nvl(pextra2,0)!='Y' )  then 
     
        open p_accounts for
        select distinct x.PAY_MODE_CODE as "PAY_MODE_CODE" ,x."PAYMENT_MODE_NAME" as "PAYMENT_MODE_NAME",x."MODE_TYPE" as "MODE_TYPE" ,x."CHQ_RETURN_FLAG" as "CHQ_RETURN_FLAG",
        x."NO_OF_TIMES" as "NO_OF_TIMES",x."VALID_DAYS" as "VALID_DAYS" from 
        (select distinct p."Pay_Mode_Code" as "PAY_MODE_CODE" ,p."Payment_Mode_Name" as "PAYMENT_MODE_NAME",p.payment_mode_type as "MODE_TYPE" ,'N' as "CHQ_RETURN_FLAG",
        0 as "NO_OF_TIMES",0 as "VALID_DAYS"
        from payment_mode_mast p,cir_agency_paymode a
        where a.comp_code=pcompcode and a.unit_code=punitcode and a.agcd=pagcd and a.dpcd=pdpcd and 
        a.paymode=p."Pay_Mode_Code" and ((upper(p."Payment_Mode_Name") like upper(pextra1)||'%') or (pextra1 is null)) and
        nvl(a.paymode_active,'N')='Y'
        union
        select distinct p."Pay_Mode_Code" as "PAY_MODE_CODE" ,p."Payment_Mode_Name" as "PAYMENT_MODE_NAME",p.payment_mode_type as "MODE_TYPE" ,'N' as "CHQ_RETURN_FLAG",
        0 as "NO_OF_TIMES",0 as "VALID_DAYS"
        from payment_mode_mast p
        where ((upper(p."Payment_Mode_Name") like upper(pextra1)||'%') or (pextra1 is null)) and p."Pay_Mode_Code"='CA0')x
        order by payment_mode_name;
    end if;       
    
    open p_accounts1 for select sysdate as "CUR_DATE" from dual;
    
End cir_payreason_for_receipt;
/


/////////////////////////////////////////////////////

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
              cancel_remark,userid,creation_date,branch_code,prov_rec_no,prov_rec_dt,remark_oth)
          select comp_code,unit_code,doctype,agcd,dpcd,recptno,
          recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,
          remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,
          staxamt,status,ref_recptno,ref_recptdt,ref_amount,ref_doctype,cancel_user,cancel_date,
          cancel_remark,userid,creation_date,branch_code,prov_rec_no,prov_rec_dt,remark_oth from cir_rcphdr_dis_temp
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
              cancel_remark,userid,creation_date,branch_code,prov_rec_no,prov_rec_dt,remark_oth)
          select comp_code,unit_code,doctype,agcd,dpcd,recptno,
          recptdt,chno,chdt,chbank,amount,oth_amount,ccdp,ccds,rcdp,rcds,ocdp,ocds,reason,
          remark,achd,voucherno,voucherdt,vchtype,publ,received_from,tdsrate,tdsamt,staxrate,
          staxamt,status,ref_recptno,ref_recptdt,ref_amount,ref_doctype,cancel_user,cancel_date,
          cancel_remark,userid,creation_date,branch_code,prov_rec_no,prov_rec_dt,remark_oth from cir_rcphdr_temp
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


///////////////////////////////////////////end/////////////////////////////////////////////////////////


/////////////////add by deepika 11/05/2012 issue no. 6929/////////////////////////////////////////////////////////


CREATE OR REPLACE procedure cir_payreason_for_receipt(
    pcompcode       in varchar2,
    punitcode       in varchar2,
    pdoctype        in varchar2,
    pagcd           in varchar2,
    pdpcd           in varchar2,
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

    if(pdoctype !='RCR') then
        open p_accounts for
        select distinct reason_code as "PAY_MODE_CODE",reason_name as "PAYMENT_MODE_NAME",'N' as "MODE_TYPE" ,chq_return_flag as "CHQ_RETURN_FLAG",
        no_of_times as "NO_OF_TIMES",valid_days as "VALID_DAYS"
        from cir_reason_mst where comp_code = pcompcode and ((upper(reason_name) like upper(pextra1)||'%') or (pextra1 is null)) and 
        ((doc_type=pdoctype) or doc_type is null) and  (chq_return_flag= pextra2 or pextra2 is null)
        order by payment_mode_name;
        end if;
        
       if(pdoctype ='RCR'  and  pextra2='Y') then
        open p_accounts for
        select distinct reason_code as "PAY_MODE_CODE",reason_name as "PAYMENT_MODE_NAME",'N' as "MODE_TYPE" ,chq_return_flag as "CHQ_RETURN_FLAG",
        no_of_times as "NO_OF_TIMES",valid_days as "VALID_DAYS"
        from cir_reason_mst where comp_code = pcompcode and ((upper(reason_name) like upper(pextra1)||'%') or (pextra1 is null) ) and 
        ((doc_type=pdoctype) or doc_type is null or doc_type='') and  ((CHQ_RETURN_FLAG= pextra2) or pextra2 is null ) 
        order by payment_mode_name;
        end if;
    
   
        if(pdoctype ='RCR' and  nvl(pextra2,0)!='Y' )  then 
     
        open p_accounts for
        select distinct x.PAY_MODE_CODE as "PAY_MODE_CODE" ,x."PAYMENT_MODE_NAME" as "PAYMENT_MODE_NAME",x."MODE_TYPE" as "MODE_TYPE" ,x."CHQ_RETURN_FLAG" as "CHQ_RETURN_FLAG",
        x."NO_OF_TIMES" as "NO_OF_TIMES",x."VALID_DAYS" as "VALID_DAYS" from 
        (select distinct p."Pay_Mode_Code" as "PAY_MODE_CODE" ,p."Payment_Mode_Name" as "PAYMENT_MODE_NAME",p.payment_mode_type as "MODE_TYPE" ,'N' as "CHQ_RETURN_FLAG",
        0 as "NO_OF_TIMES",0 as "VALID_DAYS"
        from payment_mode_mast p,cir_agency_paymode a
        where a.comp_code=pcompcode and a.unit_code=punitcode and a.agcd=pagcd and a.dpcd=pdpcd and 
        a.paymode=p."Pay_Mode_Code" and ((upper(p."Payment_Mode_Name") like upper(pextra1)||'%') or (pextra1 is null)) and
        nvl(a.paymode_active,'N')='Y'
        union
        select distinct p."Pay_Mode_Code" as "PAY_MODE_CODE" ,p."Payment_Mode_Name" as "PAYMENT_MODE_NAME",p.payment_mode_type as "MODE_TYPE" ,'N' as "CHQ_RETURN_FLAG",
        0 as "NO_OF_TIMES",0 as "VALID_DAYS"
        from payment_mode_mast p
        where ((upper(p."Payment_Mode_Name") like upper(pextra1)||'%') or (pextra1 is null)) and p."Pay_Mode_Code"='CA0')x
        order by payment_mode_name;
    end if;       
    
    open p_accounts1 for select sysdate as "CUR_DATE" from dual;
    
End cir_payreason_for_receipt;
/


/////////////////////////////////////////////////////////end////////////////////////////////////////////////////


/*************************prachi 14-may 6589****************************/
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

/*************************prachi 14-may 6589****************************/



/**************************prachi 15-may 5034*****************************************************/
CREATE OR REPLACE PACKAGE payfill
IS
   TYPE t_accounts_cursor IS REF CURSOR;

   PROCEDURE payfill_p (
      compcode     IN       VARCHAR2,
      userid       IN       VARCHAR2,
      p_accounts   OUT      t_accounts_cursor
   );
END payfill;
/
CREATE OR REPLACE PACKAGE BODY payfill
IS
   PROCEDURE payfill_p (
      compcode     IN       VARCHAR2,
      userid       IN       VARCHAR2,
      p_accounts   OUT      t_accounts_cursor
   )
   AS
   BEGIN
      OPEN p_accounts FOR
         SELECT distinct "Payment_Mode_Name", "Pay_Mode_Code"
           FROM payment_mode_mast
          /*WHERE "Comp_Code" = compcode*/ order by "Pay_Mode_Code";
   END payfill_p;
END payfill;

/**************************prachi 15-may 5034*****************************************************/
/**************************prachi 15-may 7402*****************************************************/
CREATE OR REPLACE procedure CIR_COMM_CATEGORY
(
P_COMP_CODE in  varchar2,
   p_cir     OUT Cur_Type_New1.cursor_type

)

as

begin
open p_cir for
select CATG_CODE as COMM_CATG_CODE, CATEG_DESC as COMM_CATG_DESC from CIR_WASTE_CATG_MAST  where STATUS ='N';

end;
/**************************prachi 15-may 7402*****************************************************/


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ complete info @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


/////////////////////////////////Add by Deepika 18/05/2012 issue no. 6747////////////////////////////


CREATE OR REPLACE PACKAGE cir_agency_type_bind IS
  type t_accounts_type is ref cursor;
  procedure cir_agency_type_bind_p(
     pcomp_code in varchar2,
     pdateformat in varchar2,
     pextra1 in varchar2,
     pextra2 in varchar2,
     p_accounts out t_accounts_type);
END;
/

/////////////////
CREATE OR REPLACE PACKAGE BODY cir_agency_type_bind IS
  procedure cir_agency_type_bind_p (
     pcomp_code in varchar2,
     pdateformat in varchar2,
     pextra1 in varchar2,
     pextra2 in varchar2,
     p_accounts out t_accounts_type) as
  Begin
  	open p_accounts for select * from cir_agency_typ_mast 
                             where comp_code=pcomp_code and
                                   --nvl(freeze_flag,'N')='N'
                                   ((upper(agency_type_desc) like upper(pextra1)||'%') or (pextra1 is null)) 
                             order by agency_type_desc;
  End;
END;
/



/////////////////////////////////////////////////end///////////////////////////////////////////////////////////


/////////////////////////////add by deepika for issue no. 7525 19/05/2012///////////////////////////


CREATE OR REPLACE procedure chkprefren(
Pcompcode in varchar2,
P_Accounts OUT cur_type_new1.cursor_type
)
as 
begin
open P_Accounts for  
select * from PREFERRENCES where "comp_code"=Pcompcode;


end;
/


/////////////////////////////////

CREATE OR REPLACE procedure fa_account_mast_typewise (
      pcompcode     in       varchar2,
      paccty        in       varchar2,
      paccname      in       varchar2,
      puserid       in       varchar2,
      pextra1       in       varchar2,
      pextra2       in       varchar2,
      p_accounts    out      cur_type_new1.cursor_type)
   as
begin
      open p_accounts for
         select m.comp_code as "COMP_CODE", m.cdp as "CDP", m.acc_name as "ACC_NAME", m.acc_alias as "ACC_ALIAS",
         m.acc_nature as "ACC_NATURE", m.ACC_TY as "ACC_TY",t.ac_type_desc as "AC_TYPE_DESC",t.ac_cash_bank as "AC_CASH_BANK"
           from fa_acc_mast m,fa_account_type_mast t
            where m.comp_code = pcompcode and m.comp_code = t.comp_code
                and m.acc_ty =t.ac_type_code and t.ac_cash_bank=nvl(paccty,t.ac_cash_bank)
                and ((upper (m.acc_name) like upper ('%' || paccname || '%')) or (paccname is null))
                order by acc_name;
            
END fa_account_mast_typewise;
/


/////////////////

CREATE OR REPLACE PACKAGE bindagencynameonkey
IS
   TYPE t_accounts_cursor IS REF CURSOR;

   PROCEDURE bindagencynameonkey_p (
      compcode     IN       VARCHAR2,
      userid       IN       VARCHAR2,
      agency       IN       VARCHAR2,
      p_accounts   OUT      t_accounts_cursor
   );
END bindagencynameonkey;
/



CREATE OR REPLACE PACKAGE BODY bindagencynameonkey
is
procedure bindagencynameonkey_p(compcode in varchar2,
userid in varchar2,agency in varchar2,
p_Accounts out T_Accounts_Cursor) as

begin
open p_Accounts for
select  distinct  "SUB_Agency_Code","Agency_Name","code_subcode" from Agency_mast where "Comp_Code"=compcode  and "Agency_Name" like '%'||agency||'%' order by "Agency_Name";

end   bindagencynameonkey_p;

end   bindagencynameonkey;
/


///////////////////////////////////for save/////////////////////////


CREATE OR REPLACE PACKAGE Logininsert
IS


   PROCEDURE  loginInsert_p (  username IN VARCHAR2,
password IN VARCHAR2,
userid1 IN VARCHAR2,
date_format IN VARCHAR2,
comp_name IN VARCHAR2,
com_code IN VARCHAR2,
curr_code IN VARCHAR2,
retainer_code IN VARCHAR2,

agencycode IN VARCHAR2,
USER IN  VARCHAR2,
ADMIN1 IN VARCHAR2,
comp_user IN VARCHAR2,
compnamelist in varchar2,
emailid  in varchar2,
disc in varchar2,
fil in varchar2,
role in varchar2,
editlines in varchar2,
firstname in varchar2,
lastname in varchar2,
pstatus  in varchar2,
p_empcode  in varchar2,
p_acccode  in varchar2
);
END   Logininsert;
/


////////////////////////////////////

CREATE OR REPLACE PACKAGE BODY Logininsert
IS


   PROCEDURE  loginInsert_p (
username IN VARCHAR2,
password IN VARCHAR2,
userid1 IN VARCHAR2,
date_format IN VARCHAR2,
comp_name IN VARCHAR2,
com_code IN VARCHAR2,
curr_code IN VARCHAR2,
retainer_code IN VARCHAR2,
agencycode IN VARCHAR2,
USER IN  VARCHAR2,
ADMIN1 IN VARCHAR2,
comp_user IN VARCHAR2,
compnamelist in varchar2,
emailid  in varchar2,
disc in varchar2,
fil in varchar2,
role in varchar2,
editlines in varchar2,
firstname in varchar2,
lastname in varchar2,
pstatus  in varchar2,
p_empcode  in varchar2,
p_acccode  in varchar2
) AS

BEGIN


INSERT INTO LOGIN("username","password","userid","date_format","comp_name","COM_CODE","curr_code","retainer_code","Agency_code","User_status","Admin","Company_user",USER_COMPANY,EMAIL,DISCOUNT,FILTER,ROLEID,BOOKING_EDITLINES,FIRSTNAME,LASTNAME,STATUS,HR_CODE,ACC_CODE)

VALUES(username,password,userid1,date_format,comp_name,com_code,curr_code,retainer_code,agencycode,USER,ADMIN1,comp_user,compnamelist,emailid,disc,fil,role,editlines,firstname,lastname,pstatus,p_empcode,p_acccode);
DELETE FROM MODULE_DETAIBUTTONL WHERE MODULE_DETAIBUTTONL."userid"=userid1;
COMMIT;
dbms_output.put_line(userid1);
INSERT INTO MODULE_DETAIBUTTONL("Button_id", "Form_Name", "comp_code", "userid", "Module_No", "Form_id", "Paid_permission", "Backdate_booking", "Ro_date_perm", "Confirm_qbc", BACK_DAYS) SELECT BUTTONID, FORM_NAME,COMPCODE,userid1,'',FORM_ID,'','','','',''  FROM ROLE_PERMISSION WHERE ROLEID=role;
update MODULE_DETAIBUTTONL set modulecode=(select modulecode from formmast where "Form_Name"= MODULE_DETAIBUTTONL."Form_Name" and rownum<=1) where "userid"=userid1;
COMMIT;

END   loginInsert_p;
END   Logininsert;
/


///////////////////////////////////for execute///////////////////////////////

CREATE OR REPLACE PACKAGE Loginexecute IS
 TYPE t_accounts_cursor IS REF CURSOR;
 PROCEDURE  loginexecute_p (
 username IN VARCHAR2,
 userid IN VARCHAR2,
 com_code IN VARCHAR2,
 admin1 IN VARCHAR2,
 p_accounts   OUT      t_accounts_cursor
 --p_accounts1   OUT      t_accounts_cursor,
 --p_accounts2   OUT      t_accounts_cursor
 );
 END Loginexecute;
/


//////////


CREATE OR REPLACE PACKAGE BODY Loginexecute IS
PROCEDURE  Loginexecute_p (
username IN VARCHAR2,
userid IN VARCHAR2,
com_code IN VARCHAR2,
admin1 IN VARCHAR2,
p_accounts   OUT  t_accounts_cursor

)AS
BEGIN
dbms_output.put_line(admin1);
if(admin1 is null) then

 OPEN p_accounts FOR
         SELECT "username", "password", "userid", "date_format", "COM_CODE", "comp_name", "Autogenerate", "curr_code", "retainer_code",AD_GET_FIELDNAME1('Comp_Code',com_code,'code_subcode',LOGIN."Agency_code",'Agency_Name','Agency_mast','','') AS AGENCY_NAME,"Agency_code", "User_status", "Admin", "Company_user", USER_COMPANY, CREATION_DATETIME, EMAIL, DISCOUNT, FILTER, ROLEID, BOOKING_EDITLINES, FIRSTNAME, LASTNAME, ROLE, STATUS, DOMAIN_USER, ad_get_fieldname('COMP_CD',com_code,'EMP_CODE',LOGIN.HR_CODE,'NAME','HR_EMP_MST','','') AS HR_CODE,(select ACC_NAME from fa_acc_mast where CDP=LOGIN.ACC_CODE) as ACC_NAME,ACC_CODE   FROM LOGIN 
          WHERE "Admin"is null
            and ("COM_CODE" = com_code OR com_code IS NULL)
            AND ("username" LIKE username || '%' OR username IS NULL)
            AND ("userid" LIKE userid || '%' OR userid IS NULL);
  else
     OPEN p_accounts FOR
         SELECT "username", "password", "userid", "date_format", "COM_CODE", "comp_name", "Autogenerate", "curr_code", "retainer_code",AD_GET_FIELDNAME1('Comp_Code',com_code,'code_subcode',LOGIN."Agency_code",'Agency_Name','Agency_mast','','') AS AGENCY_NAME, "Agency_code", "User_status", "Admin", "Company_user", USER_COMPANY, CREATION_DATETIME, EMAIL, DISCOUNT, FILTER, ROLEID, BOOKING_EDITLINES, FIRSTNAME, LASTNAME, ROLE, STATUS, DOMAIN_USER, ad_get_fieldname('COMP_CD',com_code,'EMP_CODE',LOGIN.HR_CODE,'NAME','HR_EMP_MST','','') AS HR_CODE,(select ACC_NAME from fa_acc_mast where CDP=LOGIN.ACC_CODE) as ACC_NAME,ACC_CODE  FROM LOGIN
          WHERE  "Admin"='yes'
          and ("COM_CODE" = com_code OR com_code IS NULL)
            AND ("username" LIKE username || '%' OR username IS NULL)
            AND ("userid" LIKE userid || '%' OR userid IS NULL);       
end if;

END Loginexecute_p;
END Loginexecute;
/


////////////////////////////////////////for modify///////////////////

CREATE OR REPLACE PACKAGE Loginmodify
IS


   PROCEDURE   loginModify_p (username IN VARCHAR2,
password IN VARCHAR2,
userid1 IN VARCHAR2,
date_format IN VARCHAR2,
comp_name IN VARCHAR2,
compcode IN VARCHAR2,
curr_code IN VARCHAR2,
retainer_code IN VARCHAR2,

agencycode IN VARCHAR2,
USER IN  VARCHAR2,
ADMIN1 IN VARCHAR2,
comp_user IN VARCHAR2,
companylist in varchar2,
emailid  in varchar2,
disc in varchar2,
fil in varchar2,
role in varchar2,
editlines in varchar2,
fname in varchar2,
lname in varchar2,
pstatus  in varchar2,
p_empcode  in varchar2,
p_acccode  in varchar2
 );
END    Loginmodify ;
/


//////////////////////////

CREATE OR REPLACE PACKAGE BODY Loginmodify
IS


   PROCEDURE   loginModify_p (username IN VARCHAR2,
password IN VARCHAR2,
userid1 IN VARCHAR2,
date_format IN VARCHAR2,
comp_name IN VARCHAR2,
compcode IN VARCHAR2,
curr_code IN VARCHAR2,
retainer_code IN VARCHAR2,

agencycode IN VARCHAR2,
USER IN  VARCHAR2,
ADMIN1 IN VARCHAR2,
comp_user IN VARCHAR2,
companylist in varchar2,
emailid  in varchar2,
disc in varchar2,
fil in varchar2,
role in varchar2,
editlines in varchar2,
fname in varchar2,
lname in varchar2,
pstatus  in varchar2,
p_empcode  in varchar2,
p_acccode  in varchar2
) AS


BEGIN

UPDATE LOGIN SET FIRSTNAME=fname,LASTNAME=lname , BOOKING_EDITLINES=editlines, ROLEID=role,FILTER=fil, DISCOUNT=disc, "username"=username, "password"=password, "date_format"=date_format, "comp_name"=comp_name, "COM_CODE"=com_code, "curr_code"=curr_code,

"retainer_code"=retainer_code,"Agency_code"=agencycode,"User_status"=USER,"Admin"=ADMIN1,"Company_user"=comp_user,USER_COMPANY=companylist,EMAIL=emailid,STATUS=pstatus,HR_CODE=p_empcode,ACC_CODE=p_acccode WHERE "userid"=userid1;
/*
if(role!='0' or  role is not null)
then
DELETE FROM MODULE_DETAIBUTTONL WHERE MODULE_DETAIBUTTONL."userid"=userid1;
COMMIT;
INSERT INTO MODULE_DETAIBUTTONL SELECT BUTTONID, FORM_NAME,COMPCODE,userid1,'',FORM_ID,'','','',''  FROM ROLE_PERMISSION WHERE ROLEID=role;
COMMIT;
end if;*/

END    loginModify_p ;
END    Loginmodify ;
/


///////////////////////////////////////for delete//////////////////////////////////////

CREATE OR REPLACE PACKAGE loginDelete
IS

PROCEDURE  loginDelete_p (
userid1 in varchar2,
compcode in varchar2
);
END   loginDelete ;
/


//////////

CREATE OR REPLACE PACKAGE BODY loginDelete
IS


PROCEDURE  loginDelete_p (
    userid1 in varchar2,
    compcode in varchar2
) 
as
count_rec NUMBER;
begin
select count(*) into count_rec from tbl_booking_mast where "Userid"=userid1;

      IF count_rec IS NULL OR count_rec=0  THEN
        delete login where  "userid"=userid1;
        delete login_branch_mast where user_code=userid1;
        delete from module_detaibuttonl where "userid"= userid1 and "comp_code"=compcode;
        commit;
    END IF;

END   loginDelete_p ;
END   loginDelete ;
/


////////////////////////////////////////////end//////////////////////////////////////////////////////////////

////////////////////////////////////add by Deepika for issue no 7433 19/05/2012//////////////////////////////


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
        select "Comp_Code",  "Pub_cent_Code",  "Pub_Cent_name",  "Pub_Cent_Alias",  "Add1",  "street",  "Country_Code",  "State_Code",  "Dist_Code",  "City_Code",
          "zip",  "Phone1",  "Phone2",  "Fax",  "EmailID",  "Pub_Cent_Status",  "Status_date",  "Remarks",  "UserId",  "Creation_Datetime",  "Region_code",
          "Zone_code",  "Fax1",  BOXADDRESS ,  PRINT_CENT,  IP,  FILE_PATH ,  CIR_FILE_PATH,  CENTER_COMP_NAME
          ,(select "PAN_No" from comp_mst x where x."Comp_Code"= pub_cent_mast."Comp_Code" and "Comp_Code"=pcompcode) as "pan_no" 
        from pub_cent_mast where /*"Comp_Code"=pcompcode  and*/
        ("Pub_cent_Code"=ppcenter or ppcenter is null) and rownum<=1
        order by "Comp_Code";

  END cir_pcenter_detail_p;

END cir_pcenter_detail;
/

////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////add by Deepika 21/05/2012//////////////////////////////

                                                                  
                                                                     
                                             
ALTER PROCEDURE [dbo].[cir_billing_p]
	@pcomp_code			VARCHAR(20) ,
	@punit_code         VARCHAR(20) ,
	@pbill_freq         VARCHAR(20) ,
	@ppubl_freq         VARCHAR(20) ,--for publication type
	@ppubl              VARCHAR(20) ,--for publication 
	@pfrdt              DATETIME ,
	@ptodt              DATETIME ,
	@pbilldt            DATETIME ,
	@pdateformat        VARCHAR(20) ,
	@puserid            VARCHAR(20) ,
	@pextra1            VARCHAR(400) ,
	@pextra2            VARCHAR(400) 
AS 
	DECLARE @vbill_publwise			varchar(1)
	set @vbill_publwise='N'
    DECLARE @vrec_publ				varchar(20);
    DECLARE @v_bill_publwise		varchar(20);
	DECLARE @ln_count               NUMERIC(10)
	DECLARE @vsrch_amt              FLOAT 
	DECLARE @daily_gross_amount     NUMERIC(12,2)
	DECLARE @daily_net_amount       NUMERIC(12,2) 
	DECLARE @tot_surcharge_amt      NUMERIC(12,2) 
	DECLARE @vcomm_per              FLOAT 
	DECLARE @vcomm_amt              NUMERIC(12,2) 
	DECLARE @curr_bilagcd           VARCHAR(30)                     
	SET @curr_bilagcd = 'DUMMY_CURR' 
	DECLARE @prev_bilagcd           VARCHAR(30)                     
	SET @prev_bilagcd = 'DUMMY_PREV' 
	DECLARE @curr_record            VARCHAR(100)                    
	SET @curr_record = 'DUMMY_CURR' 
	--new add

	DECLARE @prev_record            VARCHAR(100)                    
	SET @prev_record = 'DUMMY_PREV' 
	--new add
	
	DECLARE @SUP_DAY				varchar(25)

	DECLARE @tot_copy               NUMERIC(12)                     
	SET @tot_copy = 0 
	DECLARE @vbill_no               VARCHAR(20) 
	DECLARE @vid                    NUMERIC(10)
	DECLARE @v_frdt                 DATETIME 
	DECLARE @v_todt                 DATETIME 
	DECLARE @v_billdt               DATETIME 
	DECLARE @v_agcd_sec_per         FLOAT                           
	SET @v_agcd_sec_per = 0 
	DECLARE @v_agcd_sec_amt_limt    FLOAT                           
	SET @v_agcd_sec_amt_limt = 0 
	DECLARE @v_sec_limit            NUMERIC(10,2) 
	DECLARE @v_bill_dbn_amt         NUMERIC(10,2) 
	DECLARE @v_bill_sec_amt         NUMERIC(10,2) 
	DECLARE @v_remark               VARCHAR(200) 
	DECLARE @v_reptno               VARCHAR(25) 
	DECLARE @v_rec_no               NUMERIC(10) 
	DECLARE @v_daily_comm_amt       NUMERIC(10,2) 
	DECLARE @v_daily_sur_amt        NUMERIC(10,2) 
	DECLARE @v_daily_gross_amt      NUMERIC(10,2) 
	DECLARE @v_daily_bill_amt       NUMERIC(10,2) 

	DECLARE @vcomp_code1			varchar(20)
	DECLARE @vunit1					varchar(20)
	DECLARE @vbill_agcd1			varchar(20)
	DECLARE @vbill_dpcd1			varchar(20)
	DECLARE @vbranch_code1			varchar(20)
	DECLARE @vcity_name1			varchar(400)
	DECLARE @vag_name1				varchar(400)
	DECLARE @vprint_seqno1			float
	DECLARE @vagbill_publ1			varchar(20)
	
	DECLARE @vcomp_code11			varchar(20)
	DECLARE @vunit_code11			varchar(20)
	DECLARE @vpubl11				varchar(20)
	DECLARE @vedtn11				varchar(20)
	DECLARE @vcomm_fix_auto_spl11	varchar(20)
	DECLARE @vcomm_code11			varchar(400)
	DECLARE @vsup_rate11			float
	DECLARE @vsupdate11				datetime
	DECLARE @vsurch_cd11			varchar(400)
	DECLARE @sup_copy11				float
	DECLARE @avg_sup                FLOAT 
	DECLARE @vcomm_catg_type2       varchar(10)
	DECLARE @vsun_comm_rate2        float
	DECLARE @vsun_comm_rate1        float
	DECLARE @vmon_comm_rate1        float
	DECLARE @vtue_comm_rate1        float
	DECLARE @vwed_comm_rate1        float
	DECLARE @vthu_comm_rate1        float
	DECLARE @vfri_comm_rate1        float
	DECLARE @vsat_comm_rate1        float
	DECLARE @vcomm_catg_type1       varchar(10)
	DECLARE @vsun_rate1				float
	DECLARE @vmon_rate1				float
	DECLARE @vtue_rate1				float
	DECLARE @vwed_rate1				float
	DECLARE @vthu_rate1				float
	DECLARE @vfri_rate1				float
	DECLARE @vsat_rate1				float
	
	declare @v_bill_exist			numeric(10)

	SET @v_frdt		=	@pfrdt
	SET @v_todt		=	@ptodt
	SET @v_billdt	=	@v_todt
	
	create table #temp_dual
	(temp_publ	varchar(20))
	
	insert into #temp_dual(temp_publ) values(null)
	
	CREATE TABLE #CIR_BILL_DET_TEMP
	(COMP_CODE    VARCHAR(8),
	UNIT_CODE     VARCHAR(8),
	BILLNO        VARCHAR(20),
	BILLDT        DATETIME,
	AGCD          VARCHAR(8),
	DPCD          VARCHAR(8),
	PUBL          VARCHAR(3),
	EDTN          VARCHAR(3),
	BILL_COPY     NUMERIC(7),
	COPY_RATE     NUMERIC(10,4),
	COMM_FLAG     VARCHAR(1),
	COMM_RATE     NUMERIC(10,4),
	COMM_AMT      NUMERIC(10,4),
	SUR_RATE      NUMERIC(10,4),
	SUR_AMT       NUMERIC(10,4),
	GROSS_AMOUNT  NUMERIC(14,2),
	BILL_AMOUNT   NUMERIC(14,2),
	FROMDT        DATETIME,
	TODT          DATETIME,
	COAG          VARCHAR(8),
	CODP          VARCHAR(8),
	SESSIONID     NUMERIC(15),
	COMM_TYPE     VARCHAR(1))
    
    select @vbill_publwise=cir_bill_publwise from preferrences where "comp_code"=@pcomp_code

    select @v_bill_exist=count(*) from cir_bill_det d,cir_publ_mast p
        where d.comp_code = p.comp_code and d.comp_code=@pcomp_code and d.unit_code=@punit_code and
        d.billdt between @v_frdt and @v_todt and d.publ=p.publ and (p.pro_type = @ppubl_freq or @ppubl_freq is null);
	PRINT('@v_bill_exist')PRINT(@v_bill_exist)PRINT('@vbill_publwise')PRINT(@vbill_publwise)
    declare cur_publ cursor for
        select x.publ publ from 
        (select distinct publ from cir_publ_mast 
        where comp_code=@pcomp_code and publ = isnull(@ppubl,publ) and (pro_type=@ppubl_freq or @ppubl_freq is null) and 
        @vbill_publwise='Y' 
        union
        select null publ from #temp_dual where isnull(@vbill_publwise,'N')='N')x 
        order by publ
		PRINT('OPEN cur_publ')
		OPEN cur_publ 
		fetch NEXT FROM cur_publ INTO @vrec_publ
		WHILE (@@FETCH_STATUS = 0) BEGIN                
			
			PRINT('@vrec_publ')PRINT(@vrec_publ)
			
			DECLARE agency_cur cursor LOCAL FOR 
			select a.comp_code comp_code,a.unit unit,a.bill_agcd bill_agcd,a.bill_dpcd bill_dpcd,
			m.branch_code branch_code,dbo.cir_get_city(a.comp_code,m.city_code) city_name,
			m.ag_name ag_name,m.print_seq print_seqno,@vrec_publ agbill_publ from
			(select distinct a.comp_code,a.unit,a.bill_agcd,a.bill_dpcd
			from cir_agmast a,cir_supply s
			where  a.comp_code = @pcomp_code and a.comp_code = s.comp_code and a.unit  = s.unit and a.unit  = @punit_code and
			a.agcd=s.agcd and a.dpcd=s.dpcd and a.agcd+a.dpcd in (select distinct CAST(x.agcddpcd AS VARCHAR) from
			(select distinct CAST(d.agcd AS VARCHAR) + CAST(d.dpcd AS VARCHAR)as agcddpcd from cir_dbksup d,cir_publ_mast p
			where d.comp_code = @pcomp_code and d.comp_code = p.comp_code and d.unit_code = @punit_code and
			d.publ = isnull(@vrec_publ,d.publ) and d.publ = p.publ and
			d.supdate between @v_frdt  and  @v_todt and isnull(d.sup_copy,0)>0 
			union
			select distinct CAST(d.agcd AS VARCHAR) + CAST(d.dpcd AS VARCHAR) as agcddpcd from cir_dbksup_resale d,cir_publ_mast p
			where d.comp_code = @pcomp_code and d.comp_code = p.comp_code and d.unit_code = @punit_code and
			d.publ = isnull(@vrec_publ,d.publ) and d.publ = p.publ and
			d.supdate between @v_frdt  and  @v_todt and isnull(d.sup_copy,0)>0 ) x) and
			a.bill_agcd is not null and a.bill_agcd<>'' and a.bill_dpcd is not null and a.bill_dpcd<>'' and 
			--bill_agcd = 'A0002' and bill_dpcd = '0001' and
			isnull(a.to_bill,'N')='Y' and
			--isnull(a.unsold_valid_flag,'M')=@pbill_freq
			isnull(s.billing_cycle,'M')=@pbill_freq
			) a,cir_agmast m
			where a.comp_code=m.comp_code and a.unit=m.unit and a.bill_agcd=m.agcd and a.bill_dpcd=m.dpcd and
			@v_bill_exist=0
			order by comp_code,unit,branch_code,print_seqno,city_name,ag_name
           
		/*SELECT a.comp_code comp_code, a.unit unit, a.bill_agcd bill_agcd, a.bill_dpcd bill_dpcd, m.branch_code branch_code,
		dbo.cir_get_name_cir_city(a.comp_code, m.city_code, '1', '', '', '') city_name,m.ag_name ag_name, m.print_seq print_seqno
		FROM (	SELECT DISTINCT a.comp_code, a.unit, a.bill_agcd, a.bill_dpcd FROM  cir_agmast a WHERE	 a.comp_code  = @pcomp_code
		AND	a.unit  = @punit_code AND	a.agcd + a.dpcd  in(SELECT DISTINCT CAST(agcd AS VARCHAR) + CAST(dpcd AS VARCHAR)
		FROM  cir_dbksup WHERE	 comp_code  = @pcomp_code AND	unit_code  = @punit_code AND (publ  = @ppubl OR @ppubl  is null OR @ppubl='')
        AND	supdate  between @v_frdt  and  @v_todt AND	isnull(sup_copy, 0)  > 0) AND	a.bill_agcd  is not null AND	a.bill_dpcd  is not null
		AND	isnull(a.to_bill, 'N')  = 'Y' and isnull(a.unsold_valid_flag,'M')=@pbill_freq) a, cir_agmast m 
		WHERE	 a.comp_code  = m.comp_code AND	a.unit  = m.unit AND	a.bill_agcd  = m.agcd AND	a.bill_dpcd  = m.dpcd
		ORDER BY comp_code, unit, branch_code, print_seqno, city_name, ag_name */

		OPEN agency_cur 
		fetch NEXT FROM agency_cur INTO @vcomp_code1 , @vunit1 ,@vbill_agcd1, @vbill_dpcd1 , @vbranch_code1, @vcity_name1, @vag_name1,@vprint_seqno1,@vagbill_publ1
		WHILE (@@FETCH_STATUS = 0) BEGIN
			print('cursor_Agency_open')
			SET @curr_bilagcd  =  @vbill_agcd1 +  @vbill_dpcd1 
			SET @curr_record  =  @vbill_agcd1 +  @vbill_dpcd1 
			---------------------------------------------- add new code ------------------------------------------------------
					
			IF @curr_record <> @prev_record BEGIN 
				SET @daily_gross_amount  = 0 
				SET @tot_copy  = 0 
				SET @tot_surcharge_amt  = 0 
				SET @vsrch_amt  = 0 
				SET @vcomm_amt  = 0 
			END
			print('BILLING1')
            print(@vcomp_code1)
            print(@vunit1)
            print(@vbill_agcd1)
            print(@vbill_dpcd1)
            print(@vrec_publ)
            print(@v_frdt)
            print(@v_todt)
			
			        
			DECLARE cur_supply cursor LOCAL FOR
			select u.comp_code comp_code,u.unit_code unit_code,u.publ publ,u.edtn edtn,u.comm_fix_auto_spl comm_fix_auto_spl,
			u.comm_code comm_code,u.sup_rate sup_rate,u.supdate supdate,u.surch_cd surch_cd,sum(u.sup_copy) sup_copy from
			(select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,d.edtn edtn,d.comm_fix_auto_spl comm_fix_auto_spl,
			d.comm_code comm_code,d.sup_rate sup_rate,d.supdate supdate,d.surch_cd surch_cd,d.agcd agcd,d.dpcd dpcd,d.sup_copy sup_copy
			from cir_dbksup d,cir_supply_type_mast s,cir_publ_mast p
			where d.comp_code = @vcomp_code1 and d.comp_code = s.comp_code and d.comp_code = p.comp_code and
			d.unit_code = @vunit1 and d.sup_type_code=s.sup_ty_code and isnull(s.bill_pay,'N') = 'Y' and
			d.publ = isnull(@vrec_publ,d.publ) and d.publ =p.publ and
			d.supdate between @v_frdt and @v_todt and isnull(d.sup_copy,0)>0
			union all
			select d.comp_code comp_code,d.unit_code unit_code,d.publ publ,d.edtn edtn,d.comm_fix_auto_spl comm_fix_auto_spl,
			d.comm_code comm_code,d.sup_rate sup_rate,d.supdate supdate,d.surch_cd surch_cd,d.agcd agcd,d.dpcd dpcd,d.sup_copy sup_copy
			from cir_dbksup_resale d,cir_supply_type_mast s,cir_publ_mast p
			where d.comp_code = @vcomp_code1 and d.comp_code = s.comp_code and d.comp_code = p.comp_code and
			d.unit_code = @vunit1 and d.sup_type_code=s.sup_ty_code and isnull(s.bill_pay,'N') = 'Y' and
			d.publ = isnull(@vrec_publ,d.publ) and d.publ =p.publ and 
			d.supdate between @pfrdt and @ptodt and isnull(d.sup_copy,0)>0) u
			where u.agcd+u.dpcd in (select CAST(agcd AS VARCHAR) + CAST(dpcd AS VARCHAR) from cir_agmast
			where comp_code = @vcomp_code1 and unit = @vunit1 and bill_agcd = @vbill_agcd1 and bill_dpcd = @vbill_dpcd1)
			group by u.comp_code,u.unit_code,u.publ,u.edtn,u.comm_fix_auto_spl,u.comm_code,u.sup_rate,u.supdate,u.surch_cd;
       
			/*SELECT comp_code, unit_code, publ, edtn, comm_fix_auto_spl, comm_code, sup_rate, supdate, surch_cd, SUM(CONVERT(FLOAT, sup_copy)) sup_copy
			FROM  cir_dbksup WHERE comp_code  = @pcomp_code AND	unit_code  = @punit_code AND	sup_type_code  in(
			SELECT sup_ty_code FROM cir_supply_type_mast 	WHERE	 comp_code  = @pcomp_code AND	isnull(bill_pay, 'N')  = 'Y') AND	publ  in
			(SELECT publ	FROM  cir_publ_mast WHERE	 comp_code  = @pcomp_code )AND	agcd + dpcd  in(SELECT CAST(agcd AS VARCHAR) + CAST(dpcd AS VARCHAR)
			FROM  cir_agmast WHERE comp_code  = @vcomp_code1 AND	unit  = @vunit1 AND	bill_agcd  = @vbill_agcd1 AND	bill_dpcd  = @vbill_dpcd1)
			AND	supdate  between @v_frdt and @v_todt AND	isnull(sup_copy, 0)  > 0 GROUP BY comp_code, unit_code, publ, edtn, comm_fix_auto_spl, comm_code,sup_rate, supdate,  surch_cd */

			OPEN cur_supply 
			fetch NEXT FROM cur_supply INTO @vcomp_code11 , @vunit_code11,@vpubl11 , @vedtn11,@vcomm_fix_auto_spl11 , @vcomm_code11 ,@vsup_rate11 ,@vsupdate11 , @vsurch_cd11,@sup_copy11
			WHILE (@@FETCH_STATUS = 0) begin
				print 'cursor_supply_open'
				SET @tot_copy			= isnull(@tot_copy, 0)+ isnull(@sup_copy11, 0)
				SET @daily_gross_amount = isnull(@daily_gross_amount, 0)+ isnull(@sup_copy11, 0)* isnull( @vsup_rate11, 0)
				SET @v_daily_gross_amt  = isnull(@sup_copy11, 0)* isnull( @vsup_rate11, 0)
				SET	@SUP_DAY = CONVERT(VARCHAR(20) , DATENAME(WEEKDAY, @vsupdate11),20)
				
				IF  @vcomm_fix_auto_spl11 != 'A'  BEGIN 
					DECLARE comm_fix_spl cursor LOCAL FOR 
					select sun_comm_rate,mon_comm_rate,tue_comm_rate,wed_comm_rate,thu_comm_rate,fri_comm_rate,sat_comm_rate,comm_catg_type
					from cir_comm_mast  where comp_code = @pcomp_code and  unit_code = @punit_code and  publ = @vpubl11 and
					edtn = @vedtn11 and comm_type = @vcomm_fix_auto_spl11 and  comm_catg_code = @vcomm_code11 and  
					valid_from = (select max(valid_from) from cir_comm_mast where comp_code = @pcomp_code and unit_code = @punit_code and
					publ = @vpubl11 and  edtn = @vedtn11 and comm_type = @vcomm_fix_auto_spl11 and comm_catg_code = @vcomm_code11 and 
					valid_from <= @vsupdate11)	 
											
						OPEN comm_fix_spl
						fetch NEXT FROM comm_fix_spl INTO @vsun_comm_rate1,@vmon_comm_rate1 ,@vtue_comm_rate1,@vwed_comm_rate1,@vthu_comm_rate1,@vfri_comm_rate1 ,@vsat_comm_rate1 ,@vcomm_catg_type1

						IF (@SUP_DAY = 'Sunday' )BEGIN 
							SET @vcomm_per  =  @vsun_comm_rate1 
						END
						ELSE IF (@SUP_DAY = 'Monday') BEGIN 
							SET @vcomm_per  =   @vmon_comm_rate1
						END
						ELSE IF (@SUP_DAY = 'Tuesday')BEGIN 
							SET @vcomm_per  =   @vtue_comm_rate1
						END
						ELSE IF (@SUP_DAY = 'Wednesday') BEGIN 
							SET @vcomm_per  =   @vwed_comm_rate1 
						END
						ELSE IF (@SUP_DAY = 'Thursday') BEGIN 
							SET @vcomm_per  =   @vthu_comm_rate1 
						END
						ELSE IF (@SUP_DAY = 'Friday' )BEGIN 
							SET @vcomm_per  =   @vfri_comm_rate1
						END
						ELSE IF (@SUP_DAY = 'Saturday') BEGIN 
							SET @vcomm_per  =   @vsat_comm_rate1
						END
						ELSE BEGIN 
							SET @vcomm_per  = 0 
						END

						IF isnull( @vcomm_catg_type1, 'N')= 'P' BEGIN 
							SET @vcomm_amt			= isnull(@vcomm_amt, 0)+ ( isnull( @sup_copy11, 0)* isnull( @vsup_rate11, 0)) * isnull(@vcomm_per, 0)/ 100 
							SET @v_daily_comm_amt	= ( isnull(@sup_copy11, 0)* isnull(@vsup_rate11, 0)) * isnull(@vcomm_per, 0)/ 100 
						END
						ELSE IF isnull(@vcomm_catg_type1, 'N')= 'C' BEGIN 
							SET @vcomm_amt			= isnull(@vcomm_amt, 0)+ isnull(@sup_copy11, 0)* isnull(@vcomm_per, 0)
							SET @v_daily_comm_amt	= isnull(@sup_copy11, 0)* isnull(@vcomm_per, 0)
						END
						ELSE BEGIN 
							SET @vcomm_amt  = 0 
							SET @v_daily_comm_amt	= 0 
						END

						close comm_fix_spl
						DEALLOCATE comm_fix_spl
					END

					DECLARE cur_surcharge cursor LOCAL FOR 
					SELECT sun_rate,mon_rate,tue_rate,wed_rate,thu_rate,fri_rate,sat_rate FROM  cir_surcharge_mast WHERE	 comp_code  = @pcomp_code AND	unit  = @punit_code AND	publ  = @vpubl11
					AND	edtn  = @vedtn11 AND	surch_cd  = @vsurch_cd11 AND	valid_from  =(SELECT MAX(valid_from)FROM  cir_surcharge_mast 
					WHERE comp_code  = @pcomp_code AND	unit  = @punit_code AND	publ  = @vpubl11 AND	edtn  = @vedtn11
					AND	surch_cd = @vsurch_cd11 AND	valid_from <= @vsupdate11)
		
					OPEN cur_surcharge 
					fetch NEXT FROM cur_surcharge INTO @vsun_rate1 ,@vmon_rate1,@vtue_rate1 ,@vwed_rate1,@vthu_rate1,@vfri_rate1,@vsat_rate1
					print('cursor_surcharge')
					
					IF (@SUP_DAY = 'Sunday' ) BEGIN 
						SET @vsrch_amt  =    @vsun_rate1
					END
					ELSE IF (@SUP_DAY = 'Monday') BEGIN 
						SET @vsrch_amt  =    @vmon_rate1
					END
					ELSE IF (@SUP_DAY = 'Tuesday') BEGIN 
						SET @vsrch_amt  =   @vtue_rate1
					END
					ELSE IF (@SUP_DAY = 'Wednesday')BEGIN 
						SET @vsrch_amt  =    @vwed_rate1
					END
					ELSE IF (@SUP_DAY = 'Thursday') BEGIN 
						SET @vsrch_amt  =   @vthu_rate1
					END
					ELSE IF (@SUP_DAY = 'Friday' )BEGIN 
						SET @vsrch_amt  =   @vfri_rate1
					END
					ELSE IF (@SUP_DAY = 'Saturday') BEGIN 
						SET @vsrch_amt  =    @vsat_rate1
					END
					ELSE BEGIN 
						SET @vsrch_amt  = 0 
					END
					
					close cur_surcharge
							
					DEALLOCATE cur_surcharge

					SET @tot_surcharge_amt  = isnull(@tot_surcharge_amt, 0)+ isnull( @sup_copy11, 0)* isnull(@vsrch_amt, 0)
					SET @v_daily_sur_amt	= isnull( @sup_copy11, 0)* isnull(@vsrch_amt, 0)
					SET @v_daily_bill_amt	= isnull(@v_daily_gross_amt, 0)+ isnull(@v_daily_sur_amt, 0)- isnull(@v_daily_comm_amt, 0)
										 

					INSERT INTO  #cir_bill_det_temp ( comp_code , unit_code , billdt , agcd , dpcd , publ , edtn , bill_copy , copy_rate , 
										comm_flag , comm_rate , comm_amt , sur_rate , sur_amt , gross_amount , bill_amount , fromdt , todt , coag , codp ,comm_type )  
										VALUES ( @vcomp_code11 ,@vunit_code11 , @v_billdt , @vbill_agcd1,@vbill_dpcd1 ,@vpubl11 , @vedtn11,@sup_copy11, 
										@vsup_rate11, @vcomm_fix_auto_spl11 , isnull(@vcomm_per, 0) , isnull(@v_daily_comm_amt, 0) , isnull(@vsrch_amt, 0) , isnull(@v_daily_sur_amt, 0) , 
										isnull(@v_daily_gross_amt, 0) , isnull(@v_daily_bill_amt, 0) , @vsupdate11 , @vsupdate11 , @vbill_agcd1 , @vbill_dpcd1 ,@vcomm_catg_type1)							
					fetch NEXT FROM cur_supply INTO @vcomp_code11 , @vunit_code11,@vpubl11 , @vedtn11,@vcomm_fix_auto_spl11 , @vcomm_code11 ,@vsup_rate11 ,@vsupdate11 , @vsurch_cd11,@sup_copy11
				END 
						
				SET @avg_sup  = isnull(@tot_copy, 0)
						
				IF   @vcomm_fix_auto_spl11 = 'A' BEGIN 
					IF @tot_copy > 0 BEGIN 

               			DECLARE comm_auto cursor LOCAL FOR 
						select sun_comm_rate,comm_catg_type from cir_comm_mast where comp_code = @pcomp_code and unit_code = @punit_code and publ = @vpubl11 and
						edtn = @vedtn11 and comm_type = @vcomm_fix_auto_spl11 and comm_catg_code = @vcomm_code11 and  valid_from = (select max(valid_from) from cir_comm_mast
						where comp_code = @pcomp_code and unit_code = @punit_code and  publ = @vpubl11 and  edtn = @vedtn11 and comm_type = @vcomm_fix_auto_spl11 and
						comm_catg_code = @vcomm_code11 and   valid_from <= @v_billdt and @avg_sup between isnull(sup_copy_from,0) and isnull(sup_copy_to,0)) and
						@avg_sup between isnull(sup_copy_from,0) and isnull(sup_copy_to,0);

						OPEN comm_auto 
						fetch NEXT FROM comm_auto INTO  @vsun_comm_rate2  ,@vcomm_catg_type2 

						SET @vcomm_per  =  @vsun_comm_rate2 
															
						IF isnull( @vcomm_catg_type2, 'N')= 'P' BEGIN 
							SET @vcomm_amt  = isnull(@daily_gross_amount, 0)* isnull(@vcomm_per, 0)/ 100 
						END
						ELSE IF isnull( @vcomm_catg_type2, 'N')= 'C' BEGIN 
							SET @vcomm_amt  = isnull(@tot_copy, 0)* isnull(@vcomm_per, 0)
						END
						ELSE BEGIN 
							SET @vcomm_amt  = 0 
						END
		
						close comm_auto
					    DEALLOCATE comm_auto
					END
				END
   
				close cur_supply
                DEALLOCATE  cur_supply 

				SET @daily_net_amount  = isnull(@daily_gross_amount, 0)+ isnull(@tot_surcharge_amt, 0)- isnull(@vcomm_amt, 0)

				SET @vbill_no  = DBO.cir_generate_billno( @vcomp_code1, @vunit1, @v_billdt, @pdateformat, '', '')

                IF isnull(@tot_copy, 0)> 0 Begin	
					SELECT @v_sec_limit  =  ABS(SUM(CONVERT(FLOAT, amount))) FROM  cir_rcphdr WHERE	 comp_code  =@vcomp_code1
					AND	unit_code  = @vunit1 AND	agcd  = @vbill_agcd1 AND	dpcd  = @vbill_dpcd1 AND	achd  = 'SC'
											
					SET @v_sec_limit  = 0 
									
					DECLARE @v_bran_code VARCHAR(8)

					SELECT DISTINCT @v_agcd_sec_per  =  security_per, @v_agcd_sec_amt_limt  =  sec_amt_limt, @v_bran_code  =  branch_code
					FROM  cir_agmast WHERE comp_code  = @pcomp_code AND	unit  = @punit_code AND	agcd  = @vbill_agcd1 AND dpcd  = @vbill_dpcd1
							
					PRINT(@v_agcd_sec_per)
                    PRINT(@v_agcd_sec_amt_limt)
							
					IF isnull(@v_agcd_sec_amt_limt, 0)> isnull(@v_sec_limit, 0)and isnull(@v_agcd_sec_per, 0)> 0 BEGIN 
						SET @v_bill_dbn_amt  = isnull(@v_agcd_sec_per, 0)* isnull(@daily_net_amount, 0)/ 100 
					END
			   
					IF isnull(@v_agcd_sec_amt_limt, 0)- isnull(@v_sec_limit, 0)< isnull(@v_bill_dbn_amt, 0)BEGIN 
						SET @v_bill_sec_amt  = isnull(@v_agcd_sec_amt_limt, 0)- isnull(@v_sec_limit, 0)
					END
					ELSE BEGIN 
						SET @v_bill_sec_amt  = isnull(@v_bill_dbn_amt, 0)
					END

					INSERT INTO  cir_bill   ( comp_code , unit_code ,billno , 	billdt , agcd , dpcd , publ , bill_copy , gross_amount , 
					sur_amount , comm_amount , bill_amount , bill_frdt ,bill_todt , bill_flag , bill_remark , userid , creation_date , bill_sec_amt , branch_code,sec_per_rate )  
					VALUES ( @vcomp_code1 , @vunit1 , @vbill_no , @v_billdt , @vbill_agcd1 , @vbill_dpcd1 ,@vpubl11 , isnull(@tot_copy, 0) , 
					isnull(@daily_gross_amount, 0) , isnull(@tot_surcharge_amt, 0) , isnull(@vcomm_amt, 0) , @daily_net_amount , 
					@v_frdt , @v_todt , @pbill_freq , CAST(CONVERT(VARCHAR(23), @v_billdt) AS VARCHAR) + ' Billing' , @puserid , 
					GETDATE() , isnull(@v_bill_sec_amt, 0) , @v_bran_code,@v_agcd_sec_per ) 

					INSERT INTO  cir_outmast   ( comp_code , unit_code , agcd , dpcd , doctyp , billno , billdt , publ , amount , 
					remark , voucherno , usrid , creation_date , bill_sec_amt , branch_code )  
					VALUES ( @vcomp_code1 , @vunit1, @vbill_agcd1 , @vbill_dpcd1 , 'BIL' , @vbill_no , @v_billdt , @vpubl11 , 
					@daily_net_amount , CAST(CONVERT(VARCHAR(23), @v_billdt) AS VARCHAR) + ' Billing' , @vbill_no , @puserid , 
					GETDATE() , isnull(@v_bill_sec_amt, 0) , @v_bran_code )  
					
					INSERT INTO  cir_bill_det   ( comp_code , unit_code , billno , billdt ,agcd , dpcd ,coag , 	codp , publ , edtn , 
					copy_rate , comm_flag , comm_rate , sur_rate , fromdt , todt , bill_copy , gross_amount , comm_amt , sur_amt , 
					bill_amount , bill_flag , branch_code,comm_type )  
					SELECT comp_code, unit_code, @vbill_no billno, billdt, agcd, dpcd, agcd, dpcd, publ, edtn, copy_rate, comm_flag,
					comm_rate, sur_rate, MIN(fromdt) fromdt, MAX(todt) todt, SUM(bill_copy) bill_copy,
					SUM(CONVERT(FLOAT, gross_amount)) gross_amount,SUM(CONVERT(FLOAT, comm_amt)) comm_amt,SUM(CONVERT(FLOAT, sur_amt)) sur_amt,
					SUM(CONVERT(FLOAT, bill_amount)) bill_amount, @pbill_freq, @v_bran_code,comm_type
					FROM  #cir_bill_det_temp 
					GROUP BY comp_code, unit_code, billdt, agcd, dpcd, publ, edtn, copy_rate, comm_flag, comm_rate,  sur_rate ,comm_type

	delete from #cir_bill_det_temp
					IF isnull(@v_bill_sec_amt, 0)> 0 BEGIN 
                                 
						SET @v_remark  = 'Being amount auto debited against security deposit against bill number' + @vbill_no + ' dated' + CONVERT(VARCHAR(23), @v_billdt)
									
						SELECT @v_rec_no  =  max(convert(int,SUBSTRING(RECPTNO,(len(RECPTNO) -7),len(RECPTNO)))) + 1 FROM cir_rcphdr 
							WHERE comp_code = @vcomp_code1 AND	doctype  = 'DN'
					
						IF @v_rec_no is null or @v_rec_no = '0' BEGIN 
							SET @v_reptno  =   @v_bran_code + '-' + REPLACE(CONVERT(VARCHAR(5), GETDATE(), 2), '.', '')+ '0001'   --'DN' + '0001' 
						END
						ELSE BEGIN 
							SET @v_reptno  =   @v_bran_code + '-' + dbo.fnPadLeft('0',8,@v_rec_no)   -- 'DN ' + CASE WHEN LEN(@v_rec_no) >= 4 THEN SUBSTRING(CONVERT(VARCHAR(4000), @v_rec_no),1,4) ELSE SUBSTRING(REPLICATE('0',4),1,4-LEN(@v_rec_no)) + CONVERT(VARCHAR(4000),@v_rec_no) END  
						END

                        insert into cir_rcphdr(comp_code,unit_code,agcd,dpcd,doctype,
                         recptno,recptdt,amount,reason,remark,
                         achd,voucherno,voucherdt,userid,creation_date,branch_code)
                         values( @vcomp_code1 , @vunit1  , @vbill_agcd1 , @vbill_dpcd1 , 'DN' , @v_reptno , @v_billdt , 
							isnull(@v_bill_sec_amt, 0) , 'SEC DEBIT',@v_remark,
                         'NM',@v_reptno,@v_billdt,@puserid,GETDATE(),@v_bran_code);
							
							
						insert into cir_rcpdet(comp_code,unit_code,agcd,dpcd,doctyp,
							recptno,recptdt,payfor,achd,amount,
							reason,remark,voucherno,voucherdt,usrid,
							creation_date,branch_code)
						values(@vcomp_code1, @vunit1,@vbill_agcd1 , @vbill_dpcd1 ,'DN',
							@v_reptno,@v_billdt,@vunit1,'NM',isnull(@v_bill_sec_amt, 0),
							'SEC DEBIT',@v_remark,@v_reptno,@v_billdt,@puserid,
							GETDATE(),@v_bran_code);    
							
							PRINT('25')

							INSERT INTO  cir_outmast ( comp_code , unit_code , agcd , dpcd , doctyp , recptno , recptdt , achd , amount , 
							reason , remark , voucherno , voucherdt , usrid , creation_date , branch_code )  
							VALUES ( @vcomp_code1 ,  @vunit1 , @vbill_agcd1, @vbill_dpcd1 , 'DN' , @v_reptno , @v_billdt , 'NM' , 
							isnull(@v_bill_sec_amt, 0) , 'SEC DEBIT' , @v_remark , @v_reptno , @v_billdt , @puserid , GETDATE() , @v_bran_code )  
								
							SET @v_remark  = 'Being amount auto credited against security deposit against bill number' + @vbill_no + ' dated' + CONVERT(VARCHAR(23), @v_billdt)+ ' and debit note number' + @v_reptno 
								
							SELECT @v_rec_no  =  max(convert(int,SUBSTRING(RECPTNO,(len(RECPTNO) -7),len(RECPTNO)))) + 1  FROM  cir_rcphdr 	WHERE	 comp_code  = @vcomp_code1 AND	doctype  = 'CN'
						
							IF @v_rec_no is null or @v_rec_no = '0' BEGIN 
								SET @v_reptno  =   @v_bran_code + '-' + REPLACE(CONVERT(VARCHAR(5), GETDATE(), 2), '.', '')+ '0001'   --'DN' + '0001' 
							END
							ELSE BEGIN 
								SET @v_reptno  =   @v_bran_code + '-' + dbo.fnPadLeft('0',8,@v_rec_no)   -- 'DN ' + CASE WHEN LEN(@v_rec_no) >= 4 THEN SUBSTRING(CONVERT(VARCHAR(4000), @v_rec_no),1,4) ELSE SUBSTRING(REPLICATE('0',4),1,4-LEN(@v_rec_no)) + CONVERT(VARCHAR(4000),@v_rec_no) END  
							END

							INSERT INTO  cir_rcphdr ( comp_code , unit_code , agcd , dpcd , doctype , recptno , recptdt , amount , reason , remark , 
							achd , voucherno , voucherdt , userid , creation_date , branch_code )  
							 VALUES ( @vcomp_code1 , @vunit1 , @vbill_agcd1, @vbill_dpcd1, 'CN' , @v_reptno , @v_billdt , 
							- 1 * isnull(@v_bill_sec_amt, 0) , 'SEC DEBIT' , @v_remark , 'SC' , @v_reptno , @v_billdt , @puserid , GETDATE() , @v_bran_code )  
								
							INSERT INTO  cir_rcpdet( comp_code , unit_code , agcd , dpcd , doctyp , recptno , recptdt , payfor , achd , amount , reason , 
							remark , voucherno , voucherdt , usrid , creation_date , branch_code )  
							VALUES 	( @vcomp_code1 , @vunit1 , @vbill_agcd1 , @vbill_dpcd1 , 'CN' , @v_reptno , @v_billdt , 
							@vunit1 , 'SC' , - 1 * isnull(@v_bill_sec_amt, 0) , 'SEC DEBIT' , @v_remark , @v_reptno , @v_billdt , @puserid , GETDATE() , @v_bran_code )  

							INSERT INTO  cir_outmast   ( comp_code , unit_code , agcd , dpcd , doctyp , recptno , recptdt , achd , amount , 
							reason , remark , voucherno , voucherdt , usrid , creation_date , branch_code )  
							VALUES 	( @vcomp_code1 , @vunit1 , @vbill_agcd1 , @vbill_dpcd1 , 'CN' , @v_reptno , @v_billdt , 'SC' , - 1 * isnull(@v_bill_sec_amt, 0) , 
							'SEC DEBIT' , @v_remark , @v_reptno , @v_billdt , @puserid , GETDATE() , @v_bran_code )  
			
				        END
   
						SET @v_sec_limit  = 0 
						SET @v_bill_dbn_amt  = 0 
						SET @v_bill_sec_amt  = 0 
						SET @v_remark  = '' 
						SET @v_reptno  = '' 
						SET @v_rec_no  = 0 
						SET @v_daily_comm_amt  = 0 
						SET @v_daily_sur_amt  = 0 
						SET @v_daily_gross_amt  = 0 
						SET @v_daily_bill_amt  = 0 
			    END
   
			fetch NEXT FROM agency_cur INTO @vcomp_code1 , @vunit1 ,@vbill_agcd1, @vbill_dpcd1 , @vbranch_code1, @vcity_name1, @vag_name1,@vprint_seqno1,@vagbill_publ1	
		
END
close agency_cur
DEALLOCATE agency_cur
	set @vrec_publ=null
	fetch NEXT FROM cur_publ into @vrec_publ
	END
close cur_publ


DEALLOCATE cur_publ
DROP TABLE #cir_bill_det_temp;
DROP TABLE #temp_dual;


/////////////////////////////////////////////////////////end//////////////////////////////////////

///////issue No 6805  (Anuj)23/may/2012////////////////////////
CREATE OR REPLACE PACKAGE BODY HT18JULY.cir_branch_bind is
 procedure cir_branch_bind_p (
  puserid       in varchar2,
  pubcenter     in varchar2,
  p_accounts    out t_accounts_cursor)
  As
  Begin
   open p_accounts for
     select DISTINCT b."Branch_Code",b."Branch_Name" from login_branch_mast a, branch_mst b
         where  b."pub_center"=pubcenter and nvl(a.user_flag,'N')='Y'
      --and ("Branch_Name" like '%'||pubcenter||'%' or pubcenter is null)   
      order by b."Branch_Name";  --a.user_code=puserid and
  End cir_branch_bind_p;
   procedure cir_branch_bind_p(
       pcompcode     in varchar2,
       pbranchcode in varchar2,
       pextra1        in varchar2,
       p_accounts  out t_accounts_cursor)
   As
  Begin
   open p_accounts for
    select "Branch_Code","Branch_Name" from branch_mst
         where ("Comp_Code"=pcompcode or pcompcode is null) and
         ("Branch_Code" = pbranchcode or pbranchcode is null) AND 
         ("Branch_Name" like '%'|| pextra1 ||'%' or pextra1 is null)
         order by "Branch_Name";
   End cir_branch_bind_p;

procedure cir_branch_bind_p (
    pcompcode     in varchar2,
    puserid     in varchar2,
    pubcenter   in varchar2,
    pextra1        in varchar2,
    pextra2        in varchar2,
    p_accounts  out t_accounts_cursor)
  As
  Begin
   open p_accounts for
     select DISTINCT b."Branch_Code",b."Branch_Name" from login_branch_mast a, branch_mst b
         where a.user_code=puserid and b."pub_center"=pubcenter and nvl(a.user_flag,'N')='Y' and a.branch_code=b."Branch_Code" and ((upper(b."Branch_Name") like upper(pextra1||'%')) or (pextra1 is null))
         order by b."Branch_Name";  
  End cir_branch_bind_p;    
  End cir_branch_bind;
/


///////////////////////////////////////////////////////////////////////

//************************Circulation Prefrences*********23 MAY 2012************Issue No. 7573****Meenakshi**//

CREATE OR REPLACE PACKAGE Currbindpreferpgld
IS
   TYPE t_account_cursor IS REF CURSOR;

   PROCEDURE currbindpreferpgld_p (
      compcode     IN       VARCHAR2,
      p_accounts   OUT      t_account_cursor
   );
END Currbindpreferpgld;
/


*************************************************


CREATE OR REPLACE PACKAGE BODY currbindpreferpgld
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
                "Receipt_no", "uom_code", "Bgcolor_publication",
                "chkfor_valid_pubdates", "Agency_ratecode", "audit",
                "book_insert_date", "agencycomm", "rate_audit", "bill_audit",
                "billtype", "Premium_type", "copy_booking",
                "RATE_COMPANY_AGENCY", "ADDITIONAL_AGENCY_COMM",
                "AGENCY_RETAINER_COMM", "SUBEDITIONRATE", cls_billtype,
                dis_billtype, "BILLING_FORMAT", "RATE_CHECK", "ALL_PACKAGE",
                dayrate, scheme_type, disp_clsbill, receipt_format,
                cash_receipt_bill, bill_orderwslast, floor_chk, rokeycheck,
                agencycomm_seq_com, credit_recipt, disp_cashbill,
                cla_cashbill, rate_audit_pref, barcoding_allowed,
                fmg_bill_dis, bill_disp_cashbill, bill_cla_cashbill,
                backdatereceipt, rowise_cashbooking, cutofftime,
                dockit_booking, approval, back_days, cash_discount,
                cash_discounttype, "Allowed_old_date", seprate_cashier,
                cir_many_time_posting, cir_backdays_posting,
                cir_max_return_allow, cir_return_limit_allow,
                cir_no_of_chqbounce, cir_days_chqbounce, cir_return_days,
                cir_sup_order_limit, disp_billing_criteria,
                clsd_billing_criteria, max_publishdays, billno_periodicity,
                specialdisc_trans_edit, sharing_trans,
                multipackage_sel_trans, scheme_minword, trade_splcharge,
                rate_authorization, f2_record, publishad_edit_rateaudit,
                bindrevenue_center, fa_ledger_allow, clearance_type_allow,
                repeat_day_type, premium_edit, bill_generation_prior,
                publication_ho, spldisc_allowprem, bill_scheme,
                allowed_pdc_days_receipt, ad_type_manul_bill,
                outstanding_amt_criteria AS ro_outstand, genrate_cir_agcd,
                disp_auditbkg, cir_dis_auto_posting, relauthreqon,
                cir_auto_approval_unsold, cir_auto_physical_unsold,
                cir_unsold_include_inct, cir_unsold_include_insfee,
                cir_unsold_on_received_dt, agency_unblock_approval,
                unblock_approval_outside_limit, cir_bill_publwise,
                records_on_page, records_on_print, header_on_page,
                agency_required, region_required, allow_follow_dt_boook,
                crm_supply_type_paid, crm_supply_type_free,
                currency_measurement, "Space_area", editable_agency_comm,
                cancellation_charge, taxi_entry_type, approval_with,
                tds_auto_cn, tds_auto_reason, tds_db_cdp, tds_cr_cdp,
                ser_tax_auto_cn, ser_tax_auto_reason, ser_tax_db_cdp,
                ser_tax_cr_cdp, pkk_auto_cn, pkk_auto_reason, pkk_db_cdp,
                pkk_cr_cdp, bank_chg_auto_cn, bank_chg_auto_reason,
                bank_chg_db_cdp, bank_chg_cr_cdp, cir_barcode,
                cir_wieght_calc_req, gen_rct_typ, product_brand_req
           FROM preferrences
          WHERE "comp_code" = compcode;
   END currbindpreferpgld_p;
END currbindpreferpgld;
/

//**************************end*****************************************/

------------------------------------------------------------anuj 23-may-2012--------------------------------------



CREATE OR REPLACE PACKAGE HT18JULY.cir_branch_received is
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





CREATE OR REPLACE PACKAGE BODY HT18JULY.cir_branch_received is
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
        d.recptno as "REF_RECPTNO" ,d.recptdt as "REF_RECPTDT",h.taxi_route_name as "TAXI_ROUTE_NAME", h.taxi_no as "TAXI_NO",h.packet_size "PACKET_SIZE"
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
        select comp_code as "COMP_CODE",unit_code as "UNIT_CODE",branch_code as "OTH_BRANCH",recptno as "REF_RECPTNO",recptdt as "REF_RECPTDT",slno as "SLNO",
        publ_code as "PUBL_CODE",edtn_code as "EDTN_CODE",
        edtn_rate as "EDTN_RATE",edtn_copy as "EDTN_COPY",nvl(copy_weight,0) as "COPY_WEIGHT",oth_branch_code as "BRANCH",no_of_packet as "NO_OF_PACKET" 
        from cir_branch_return_det 
        where comp_code=pcompcode and unit_code=punitcode and branch_code=pfrombranch and 
        oth_branch_code=pbranchcode and doctype=pdoctypeout and recptno||recptdt not in(select branch_refno||branch_refdt from cir_branch_return_hdr 
        where comp_code=pcompcode and unit_code=punitcode and doctype=pdoctypein) and recptno=precptno and recptdt=v_recptdt
        order by comp_code,unit_code,recptdt,recptno,slno;
 
   End cir_branch_received_p2;   
End cir_branch_received;
/


--------------------------------------------------------------anuj--------------------------------------------------




//---------------------------------------------------------Added By Meenakshi for Issue No. 7316 --------Date : 23/05/2012-------


CREATE OR REPLACE PACKAGE cir_get_name is
  type t_accounts is ref cursor;
    Function cir_agname(
        pcompcode       in varchar2,
        punitcode       in varchar2,
        pagcd           in varchar2,
        pdpcd           in varchar2,
        plangtype       in number,--for other language--
        pdateformat     in varchar2,
        pextra1         in varchar2,
        pextra2         in varchar2) return varchar2;

    Function cir_district(
        pcompcode       in varchar2,
        pdistcode       in varchar2,
        plangtype       in number,--for other language--
        pdateformat     in varchar2,
        pextra1         in varchar2,
        pextra2         in varchar2) return varchar2;

    Function cir_city(
        pcompcode       in varchar2,
        pcity           in varchar2,
        plangtype       in number,--for other language--
        pdateformat     in varchar2,
        pextra1         in varchar2,
        pextra2         in varchar2) return varchar2;

    Function cir_taluka(
        pcompcode       in varchar2,
        ptaluka         in varchar2,
        plangtype       in number,--for other language--
        pdateformat     in varchar2,
        pextra1         in varchar2,
        pextra2         in varchar2) return varchar2;
    
    Function cir_publ(
        pcompcode       in varchar2,
        ppublcode       in varchar2,
        plangtype       in number,--for other language--
        pdateformat     in varchar2,
        pextra1         in varchar2,
        pextra2         in varchar2) return varchar2;

    Function cir_edtn(
        pcompcode       in varchar2,
        punitcode       in varchar2,
        pedtncode       in varchar2,
        plangtype       in number,--for other language--
        pdateformat     in varchar2,
        pextra1         in varchar2,
        pextra2         in varchar2) return varchar2;

    Function cir_route(
        pcompcode       in varchar2,
        punitcode       in varchar2,
        proutecode      in varchar2,
        plangtype       in number,--for other language--
        pdateformat     in varchar2,
        pextra1         in varchar2,
        pextra2         in varchar2) return varchar2;

    Function cir_subroute(
        pcompcode       in varchar2,
        punitcode       in varchar2,
        proutecode      in varchar2,
        psubrtcode      in varchar2,
        plangtype       in number,--for other language--
        pdateformat     in varchar2,
        pextra1         in varchar2,
        pextra2         in varchar2) return varchar2;
        
    Function cir_subsubroute(
        pcompcode       in varchar2,
        punitcode       in varchar2,
        proutecode      in varchar2,
        psubrtcode      in varchar2,
        psubsubrtcode   in varchar2,
        plangtype       in number,--for other language--
        pdateformat     in varchar2,
        pextra1         in varchar2,
        pextra2         in varchar2) return varchar2;
    
    Function cir_drop_point(
        pcompcode       in varchar2,
        punitcode       in varchar2,
        pdroppoint      in varchar2,
        plangtype       in number,--for other language--
        pdateformat     in varchar2,
        pextra1         in varchar2,
        pextra2         in varchar2) return varchar2; 
        Function cir_agname_branch(
        pcompcode       in varchar2,
        punitcode       in varchar2,
        pagcd           in varchar2,
        pdpcd           in varchar2,
        plangtype       in number,--for other language--
        pdateformat     in varchar2,
        pextra1         in varchar2,
        pextra2         in varchar2,
        pbranchcode       in varchar2) return varchar2      ;   
End cir_get_name;
/

---------------------------------

CREATE OR REPLACE PACKAGE BODY cir_get_name IS
 Function cir_agname(
        pcompcode       in varchar2,
        punitcode       in varchar2,
        pagcd           in varchar2,
        pdpcd           in varchar2,
        plangtype       in number,--for other language--
        pdateformat     in varchar2,
        pextra1         in varchar2,
        pextra2         in varchar2) return varchar2 is
    
 v_name     varchar2(50);
 v_oname    varchar2(80);
 Begin
    if upper(pextra2)='D' then
        begin
            select substr(ag_name,1,50),substr(ag_name_oth_lang,1,80) into v_name,v_oname from cir_agmast_dis
                where comp_code=pcompcode and (unit=punitcode or punitcode is null) and agcd=pagcd and dpcd=pdpcd;
        exception when too_many_rows then
            begin
                select substr(ag_name,1,50),substr(ag_name_oth_lang,1,80) into v_name,v_oname from cir_agmast_dis
                where comp_code=pcompcode and (unit=punitcode or punitcode is null) and agcd=pagcd and dpcd=pdpcd and rownum<2;
            exception when no_data_found then    
                v_name:='Not Define';v_oname:='Not Define';
            end;    
        end;
    else
        begin
            select substr(ag_name,1,50),substr(ag_name_oth_lang,1,80) into v_name,v_oname from cir_agmast
                where comp_code=pcompcode and (unit=punitcode or punitcode is null) and agcd=pagcd and dpcd=pdpcd;
        exception when too_many_rows then
            begin
                select substr(ag_name,1,50),substr(ag_name_oth_lang,1,80) into v_name,v_oname from cir_agmast
                where comp_code=pcompcode and (unit=punitcode or punitcode is null) and agcd=pagcd and dpcd=pdpcd and rownum<2;
            exception when no_data_found then    
                v_name:='Not Define';v_oname:='Not Define';
            end;    
        end;     
     end if;
    if plangtype=2 then--for other language--
        return v_oname;
    else
        return v_name;
    end if;

 End cir_agname;

 Function cir_district(
    pcompcode       in varchar2,
    pdistcode       in varchar2,
    plangtype       in number,--for other language--
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2) return varchar2 is
    
 v_name     varchar2(50);
 v_oname    varchar2(80);
 Begin
    begin
        select substr(dist_name,1,50),substr(dist_oname,1,80) into v_name,v_oname from cir_dist_mast
            where comp_code=pcompcode and dist_code=pdistcode;
    exception when too_many_rows then
        begin
        select substr(dist_name,1,50),substr(dist_oname,1,80) into v_name,v_oname from cir_dist_mast
            where comp_code=pcompcode and dist_code=pdistcode and rownum<2;
        exception when no_data_found then    
            v_name:='Not Define';v_oname:='Not Define';
        end;
    end;
    if plangtype=2 then--for other language--
        return v_oname;
    else
        return v_name;
    end if;

 End cir_district;
  
 Function cir_city(
    pcompcode       in varchar2,
    pcity           in varchar2,
    plangtype       in number,--for other language--
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2) return varchar2 is
    
 v_name     varchar2(50);
 v_oname    varchar2(80);
 Begin
    begin
        select substr(city_name,1,50),substr(city_oname,1,80) into v_name,v_oname from cir_city_mast
            where comp_code=pcompcode and city_code=pcity;
    exception when too_many_rows then
        begin
        select substr(city_name,1,50),substr(city_oname,1,80) into v_name,v_oname from cir_city_mast
            where comp_code=pcompcode and city_code=pcity and rownum<2;
        exception when no_data_found then    
            v_name:='Not Define';v_oname:='Not Define';
        end;
    end;
    if plangtype=2 then--for other language--
        return v_oname;
    else
        return v_name;
    end if;

 End cir_city;

 Function cir_taluka(
        pcompcode       in varchar2,
        ptaluka         in varchar2,
        plangtype       in number,--for other language--
        pdateformat     in varchar2,
        pextra1         in varchar2,
        pextra2         in varchar2) return varchar2 is
    
    v_name     varchar2(50);
    v_oname    varchar2(80);
 Begin
    begin
        select substr(talu_name,1,50),substr(talu_oname,1,80) into v_name,v_oname from cir_taluka_mast
            where comp_code=pcompcode and talu_code=ptaluka;
    exception when too_many_rows then
        begin
            select substr(talu_name,1,50),substr(talu_oname,1,80) into v_name,v_oname from cir_taluka_mast
            where comp_code=pcompcode and talu_code=ptaluka and rownum<2;
        exception when no_data_found then    
            v_name:='Not Define';v_oname:='Not Define';
        end;    
    when no_data_found then    
            v_name:='Not Define';v_oname:='Not Define';
        end;
    if plangtype=2 then--for other language--
        return v_oname;
    else
        return v_name;
    end if;

 End cir_taluka;

 Function cir_publ(
        pcompcode       in varchar2,
        ppublcode       in varchar2,
        plangtype       in number,--for other language--
        pdateformat     in varchar2,
        pextra1         in varchar2,
        pextra2         in varchar2) return varchar2 is
    
    v_name     varchar2(50);
    v_oname    varchar2(80);
 Begin
    begin
        select substr(publ_name,1,50),substr(publ_name_oth_lang,1,80) into v_name,v_oname from cir_publ_mast
            where comp_code=pcompcode and publ=ppublcode;
    exception when too_many_rows then
        begin
            select substr(publ_name,1,50),substr(publ_name_oth_lang,1,80) into v_name,v_oname from cir_publ_mast
            where comp_code=pcompcode and publ=ppublcode and rownum<2;
        exception when no_data_found then    
            v_name:='Not Define';v_oname:='Not Define';
        end;    
    end;
    if plangtype=2 then--for other language--
        return v_oname;
    else
        return v_name;
    end if;

 End cir_publ;

 Function cir_edtn(
        pcompcode       in varchar2,
        punitcode       in varchar2,
        pedtncode       in varchar2,
        plangtype       in number,--for other language--
        pdateformat     in varchar2,
        pextra1         in varchar2,
        pextra2         in varchar2) return varchar2 is
    
    v_name     varchar2(50);
    v_oname    varchar2(80);
 Begin
    begin
        select substr(edtn_name,1,50),substr(edtn_name_oth_lang,1,80) into v_name,v_oname from cir_edtn_mast
            where comp_code=pcompcode and /*(unit_code=punitcode or punitcode is null) and */edtn=pedtncode;
    exception when too_many_rows then
        begin
            select substr(edtn_name,1,50),substr(edtn_name_oth_lang,1,80) into v_name,v_oname from cir_edtn_mast
                where comp_code=pcompcode and (unit_code=punitcode or punitcode is null) and edtn=pedtncode and rownum<2;
        exception when no_data_found then    
            v_name:='Not Define';v_oname:='Not Define';
        end;    
    end;
    if plangtype=2 then--for other language--
        return v_oname;
    else
        return v_name;
    end if;

 End cir_edtn;

 Function cir_route(
        pcompcode       in varchar2,
        punitcode       in varchar2,
        proutecode      in varchar2,
        plangtype       in number,--for other language--
        pdateformat     in varchar2,
        pextra1         in varchar2,
        pextra2         in varchar2) return varchar2 is
    
    v_name     varchar2(50);
    v_oname    varchar2(80);
 Begin
    begin
        select substr(route_name,1,50),substr(route_name_oth_lang,1,80) into v_name,v_oname from cir_route_mast
            where comp_code=pcompcode and (unit=punitcode or punitcode is null) and route_code=proutecode;
    exception when too_many_rows then
        begin
            select substr(route_name,1,50),substr(route_name_oth_lang,1,80) into v_name,v_oname from cir_route_mast
                where comp_code=pcompcode and (unit=punitcode or punitcode is null) and route_code=proutecode and rownum<2;
        exception when no_data_found then    
            v_name:='Not Define';v_oname:='Not Define';
        end;    
    end;
    if plangtype=2 then--for other language--
        return v_oname;
    else
        return v_name;
    end if;

 End cir_route;
 
 Function cir_subroute(
        pcompcode       in varchar2,
        punitcode       in varchar2,
        proutecode      in varchar2,
        psubrtcode      in varchar2,
        plangtype       in number,--for other language--
        pdateformat     in varchar2,
        pextra1         in varchar2,
        pextra2         in varchar2) return varchar2 is
    
    v_name     varchar2(50);
    v_oname    varchar2(80);
 Begin
    begin
        select substr(subrt_name,1,50),substr(subrt_name_oth_lang,1,80) into v_name,v_oname from cir_sub_route_mast
            where comp_code=pcompcode and (unit=punitcode or punitcode is null) and route_code=proutecode and subrt_code=psubrtcode;
    exception when too_many_rows then
        begin
            select substr(subrt_name,1,50),substr(subrt_name_oth_lang,1,80) into v_name,v_oname from cir_sub_route_mast
                where comp_code=pcompcode and (unit=punitcode or punitcode is null) and route_code=proutecode and subrt_code=psubrtcode and rownum<2;
        exception when no_data_found then    
            v_name:='Not Define';v_oname:='Not Define';
        end;
    end;
    if plangtype=2 then--for other language--
        return v_oname;
    else
        return v_name;
    end if;

 End cir_subroute; 

 Function cir_subsubroute(
        pcompcode       in varchar2,
        punitcode       in varchar2,
        proutecode      in varchar2,
        psubrtcode      in varchar2,
        psubsubrtcode   in varchar2,
        plangtype       in number,--for other language--
        pdateformat     in varchar2,
        pextra1         in varchar2,
        pextra2         in varchar2) return varchar2 is
    
    v_name     varchar2(50);
    v_oname    varchar2(80);
 Begin
    Begin
        select substr(sub_subrt_name,1,50),substr(sub_subrt_name_oth_lang,1,80) into v_name,v_oname from cir_sub_subroute_mast
            where comp_code=pcompcode and (unit=punitcode or punitcode is null) and route_code=proutecode and subrt_code=psubrtcode and 
                sub_subrt_code=psubsubrtcode;
    Exception when too_many_rows then
        Begin
            select substr(sub_subrt_name,1,50),substr(sub_subrt_name_oth_lang,1,80) into v_name,v_oname from cir_sub_subroute_mast
                where comp_code=pcompcode and (unit=punitcode or punitcode is null) and route_code=proutecode and subrt_code=psubrtcode and 
                    sub_subrt_code=psubsubrtcode and rownum<2;
        Exception when no_data_found then    
            v_name:='Not Define';v_oname:='Not Define';
        End;
    End;
    if plangtype=2 then--for other language--
        return v_oname;
    else
        return v_name;
    end if;

 End cir_subsubroute;
 
 Function cir_drop_point(
        pcompcode       in varchar2,
        punitcode       in varchar2,
        pdroppoint      in varchar2,
        plangtype       in number,--for other language--
        pdateformat     in varchar2,
        pextra1         in varchar2,
        pextra2         in varchar2) return varchar2 is
    
    v_name     varchar2(50);
    v_oname    varchar2(80);
 Begin
    begin
        select substr(drop_point_name,1,50),substr(drop_point_oth_name,1,80) into v_name,v_oname from cir_drop_point_mast
            where comp_code=pcompcode and (unit_code=punitcode or punitcode is null) and drop_point=pdroppoint;
    exception when too_many_rows then
        begin
            select substr(drop_point_name,1,50),substr(drop_point_oth_name,1,80) into v_name,v_oname from cir_drop_point_mast
                where comp_code=pcompcode and (unit_code=punitcode or punitcode is null) and drop_point=pdroppoint and rownum<2;
        exception when no_data_found then    
            v_name:='Not Define';v_oname:='Not Define';
        end;    
    end;
    if plangtype=2 then--for other language--
        return v_oname;
    else
        return v_name;
    end if;

 End cir_drop_point;

Function cir_agname_branch(
        pcompcode       in varchar2,
        punitcode       in varchar2,
        pagcd           in varchar2,
        pdpcd           in varchar2,
        plangtype       in number,--for other language--
        pdateformat     in varchar2,
        pextra1         in varchar2,
        pextra2         in varchar2,
        pbranchcode       in varchar2) return varchar2 is
    
 v_name     varchar2(50);
 v_oname    varchar2(80);
 V_cent varchar2(20);
 Begin
  
  begin
    select "pub_center" into V_cent from branch_mst where "Comp_Code"=pcompcode and "Branch_Code"=pbranchcode;
   exception when no_data_found then    
            V_cent:=null;
   end;         
  if upper(pextra2)='D' then
    begin
        select substr(ag_name,1,50),substr(ag_name_oth_lang,1,80) into v_name,v_oname from cir_agmast_dis
            where comp_code=pcompcode and (unit=V_cent or V_cent is null) and agcd=pagcd and dpcd=pdpcd;
    exception when too_many_rows then
        begin
            select substr(ag_name,1,50),substr(ag_name_oth_lang,1,80) into v_name,v_oname from cir_agmast_dis
            where comp_code=pcompcode and (unit=V_cent or V_cent is null) and agcd=pagcd and dpcd=pdpcd and rownum<2;
        exception when no_data_found then    
            v_name:='Not Define';v_oname:='Not Define';
        end;    
    end;
   else
    begin
        select substr(ag_name,1,50),substr(ag_name_oth_lang,1,80) into v_name,v_oname from cir_agmast
            where comp_code=pcompcode and (unit=V_cent or V_cent is null) and agcd=pagcd and dpcd=pdpcd;
    exception when too_many_rows then
        begin
            select substr(ag_name,1,50),substr(ag_name_oth_lang,1,80) into v_name,v_oname from cir_agmast
            where comp_code=pcompcode and (unit=V_cent or V_cent is null) and agcd=pagcd and dpcd=pdpcd and rownum<2;
        exception when no_data_found then    
            v_name:='Not Define';v_oname:='Not Define';
        end;    
    end;   
   end if;
    if plangtype=2 then--for other language--
        return v_oname;
    else
        return v_name;
    end if;

 End cir_agname_branch;   
End cir_get_name;
/

//-----------------------------------------------End script------------------------------------------------------------------------------------------------


//----------------------------------Branch Transfer Entry----------------Update By Meenakshi-----------26May2012-----------------


CREATE OR REPLACE procedure HT18JULY.cir_unsold_supply_for_transfer(
    pcomp_code         in varchar2,
    punit_code         in varchar2,
    pbran_code         in varchar2,
    pfromdate          in varchar2,
    ptilldate          in varchar2,
    puserid            in varchar2,   
    pdateformat        in varchar2,
    pextra1            in varchar2,--for publication
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
    cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,1) drop_point_name, cir_get_city(d.comp_code,m.city_code) city_name,
    cir_get_agency(d.comp_code,d.unit_code,d.agcd,d.dpcd) as "BILLING_AGENCY",
    sum(nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0)+nvl(apr_damage,0)) as "TOTAL_UNSOLD",
    v_process_id as "PROCESS_IDNO" 
    from cir_unsold_hdr h,cir_unsold_dtl d,cir_agmast m
    where h.comp_code=d.comp_code and h.comp_code=m.comp_code and h.comp_code=pcomp_code and h.unit_code=d.unit_code and h.unit_code=m.unit and h.unit_code=punit_code and 
    h.doctype=d.doctype and h.doctype='UCN' and h.recptno=d.recptno and h.recptdt=d.recptdt and h.recptdt between v_frdt and v_todt and 
    h.agcd=nvl(d.sup_agcd,d.agcd) and h.agcd=m.agcd and h.dpcd=nvl(d.sup_dpcd,d.dpcd) and h.dpcd=m.dpcd and 
    d.branch_code=nvl(pbran_code,d.branch_code) and (nvl(apr_short_recpt,0)+nvl(apr_late_recpt,0)+nvl(apr_bnr,0)+nvl(apr_unsold,0)+nvl(apr_damage,0))>0 and
    (h.branch_trfno is null or h.branch_trfno='') and (h.PUBL=pextra1 or pextra1 is null)
    group by d.comp_code,d.unit_code,d.branch_code,d.doctype,d.recptno,d.recptdt,d.sup_agcd,d.sup_dpcd,m.ag_name,m.station_code, m.city_code,d.agcd,d.dpcd
    order by comp_code,unit_code,recptdt,recptno;
            
End cir_unsold_supply_for_transfer;
/


//-----------------------------------------------End Script-----------------------Branch Transfer Entry---------------------------------------
//////////////////Add by vivek issue no 7464 28/05/2012//////////////////////////////////////////////////////////////////


CREATE OR REPLACE procedure HT18JULY.cir_rep_executive_wise_supply(
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
    pextra2        in varchar2,--supply type
    pextra3        in varchar2,--agency type
    pextra4        in varchar2,--agency class
    pextra5        in varchar2, 
    pextra6        in varchar2,
    p_accounts     out Cur_Type_New1.cursor_type,
    p_accounts1    out Cur_Type_New1.cursor_type,
    p_accounts2    out Cur_Type_New1.cursor_type,
    p_accounts3    out Cur_Type_New1.cursor_type)
As
    vfrom_supdate    date;
    vtill_supdate    date;
Begin
       vfrom_supdate:=to_date(pfrom_supdate,''''||pdateformat||'''');
       vtill_supdate:=to_date(ptill_supdate,''''||pdateformat||'''');
       
       open p_accounts for
      select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
  m.executive_code as "EXECUTIVE_CODE",(select executive_desc from cir_executive_mast 
       where comp_code=d.comp_code and executive_code=m.executive_code) as "EXECUTIVE_NAME",
       d.agcd AS "AGCD",d.dpcd AS "DPCD",m.ag_name AS "AG_NAME",m.ag_name_oth_lang AS "AG_NAME_OTH_LANG",sum(d.sup_copy) AS "SUP_COPY",
       cir_get_supply_seqno(d.comp_code,d.unit_code,ppubl,pedtn,d.agcd,d.dpcd) AS "SUPPLY_SEQNO",
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
          group by d.comp_code,d.unit_code,m.executive_code,
                   d.agcd,d.dpcd,m.ag_name,m.ag_name_oth_lang,m.city_code,m.station_code
          order by d.comp_code,d.unit_code,m.executive_code,supply_seqno ,d.agcd,d.dpcd;

        open p_accounts1 for
       select d.comp_code as "COMP_CODE",d.unit_code AS "UNIT_CODE",
  m.executive_code as "EXECUTIVE_CODE",(select executive_desc from cir_executive_mast 
        where comp_code=d.comp_code and executive_code=m.executive_code) as "EXECUTIVE_NAME",
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
        group by d.comp_code,d.unit_code,m.executive_code
        order by d.comp_code,d.unit_code,m.executive_code;

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
End cir_rep_executive_wise_supply;
/
///////////////////////////////////////////////end///////////////////////////////////////////////////////////////////




//*********************************Bill Print (for Issue No-5304)****DATE-28/05/2012****************************************

CREATE OR REPLACE procedure cir_update_billprint_count
(
pcompcode  in varchar2,
punitcode  in varchar2,
pbillno    in varchar2,
pformdate  in varchar2,
ptodate    in varchar2,
pdateformat    in varchar2,
pextra1    in  varchar2,
pextra2    in varchar2,
pextra3    in varchar2,
pextra4    in varchar2,
pextra5    in varchar2
)
as 
cnt int;
v_frdt date;
v_todt date;
begin
v_frdt:=to_date(pformdate,''''||pdateformat||'''');
v_todt:=to_date(ptodate,''''||pdateformat||'''');
select nvl(max(BILL_COUNT),0)+1 into cnt from cir_bill where
COMP_CODE=pcompcode and
UNIT_CODE=punitcode and
BILLNO=pbillno and
BILLDT between v_frdt and v_todt;

update cir_bill set BILL_COUNT=cnt where
COMP_CODE=pcompcode and
UNIT_CODE=punitcode and
BILLNO=pbillno and
BILLDT between v_frdt and v_todt;
commit;
end;
/

//************************************************End Script***********************************************************



//********************************************Meenakshi***ISSUE NO. 5304******Date- 28/05/2012*************************

CREATE OR REPLACE PACKAGE cir_rep_billing IS
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
     pextra3         in varchar2,--for login user id
            pextra4         in varchar2,
            pextra5         in varchar2,
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


**************************BODY*************


CREATE OR REPLACE PACKAGE BODY cir_rep_billing IS
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
            order by comp_code, state_name,billdt,billno,agency_name;
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
            order by comp_code, state_name,dist_name,billdt,billno,agency_name;        
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
            order by comp_code, state_name,taluka_name,billdt,billno,agency_name;        
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
            order by comp_code, state_name,"CITY NAME",billdt,billno,agency_name;        
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
            pextra3         in varchar2,--for login user id
            pextra4         in varchar2,
            pextra5         in varchar2,
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
        c.bill_sec_amt bill_sec_amt,b.station_code drop_point,c.bill_count bill_count
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
                  ,c.bill_count
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
            v_city_name     :=cir_get_city(v1.comp_code,v1.city_code);
            v_taluka_name   :=cir_get_name.cir_taluka(v1.comp_code,v1.taluka_code,'1','','','');
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
                                agname, agname_oth_lang, city_code, taluka_code, dist_code, state_code, remarks,bill_sec_amt,sec_opbal,bill_count)
            values(v1.comp_code,  v1.unit_code  , null   ,null  , ''    ,v1.agcd,v1.dpcd,
            v1.supply_copy,v1.gross_amount,nvl(v1.comm_amount,0),v1.sur_amount,v_ret_copy,v_ret_gross,v_ret_comm,
            v_dn_amt,v_rec_amt,v_prev_bal,v_cn_amt,userenv('sessionid'),
            v1.ag_name,v1.ag_name_oth_lang,v_city_name,v_taluka_name,v_dist_name,v_state_name,v_drop_point_name,
            v1.bill_sec_amt,v_sec_bal,v1.bill_count);
            

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
            ABS(SUM(NVL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE,A.REMARKS DROP_POINT,A.CITY_CODE CITY_NAME,a.bill_count BILL_COUNT
            from cir_temp_bill_collection a
            where cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.state_code,a.remarks,A.CITY_CODE ,a.bill_count
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
            ABS(SUM(NVL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE,A.REMARKS DROP_POINT,A.CITY_CODE CITY_NAME,a.bill_count BILL_COUNT
            from cir_temp_bill_collection a
            where cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.state_code,a.dist_code,a.remarks,A.CITY_CODE,a.bill_count 
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
            ABS(SUM(NVL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE,A.REMARKS DROP_POINT,a.bill_count BILL_COUNT
            from cir_temp_bill_collection a
            where cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.state_code,a.dist_code,a.city_code,a.remarks,a.bill_count 
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
            ABS(SUM(NVL(A.SEC_OPBAL,0))) DEPOSIT_BALANCE,A.REMARKS DROP_POINT,A.CITY_CODE CITY_NAME,a.bill_count BILL_COUNT
            from cir_temp_bill_collection a
            where cur_sessionid=userenv('sessionid')
            group by a.comp_code,a.unit_code,a.agcd,a.dpcd,a.agname,a.agname_oth_lang,a.taluka_code,a.dist_code,a.remarks,a.state_code,A.CITY_CODE,a.bill_count 
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
        v_bill_dbn_amt  number(15,2);
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
           --  insert into searchtbl values(v_agcd_sec_per||'-'|| daily_net_amount);commit;
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

*****************************************END Script**************************************************************************

/////////////////////add by Deepika 30/05/2012 for issue no. 5721////////////////////////////////////////////

CREATE OR REPLACE FUNCTION cir_get_edtn_supl(
    pcomp_code      in varchar2,
    punit_code      in varchar2,
    pedtn_code      in varchar2,
    pdate           in date,
    pdateformat     in varchar2,
    plangtype       in varchar2,
    pextra1         in varchar2,--publ
    pextra2         in varchar2,
    pextra3         in varchar2,
    pextra4         in varchar2,
    pextra5         in varchar2) return varchar2 is
    
    v_supl_name varchar2(1000);
Begin
        select  case when to_char(pdate,'DY')='SUN' then s.supl_name_sun  
                when to_char(pdate,'DY')='MON' then s.supl_name_mon
                when to_char(pdate,'DY')='TUE' then s.supl_name_tue
                when to_char(pdate,'DY')='WED' then s.supl_name_wed
                when to_char(pdate,'DY')='THU' then s.supl_name_thu
                when to_char(pdate,'DY')='FRI' then s.supl_name_fri
                when to_char(pdate,'DY')='SAT' then s.supl_name_sat
                else null end supl_name into v_supl_name
        from cir_edtn_supl_mast s,cir_edtn_mast e
        where s.comp_code=pcomp_code and s.comp_code=e.comp_code and s.unit_code=punit_code and s.unit_code=e.unit_code and 
            s.publ_code=e.publ and s.edtn_code=e.edtn and s.edtn_code=pedtn_code and 
            s.publ_code=pextra1 and
            s.valid_from=(select max(valid_from) from cir_edtn_supl_mast 
            where comp_code=pcomp_code and unit_code=punit_code and edtn_code=pedtn_code and valid_from<=pdate);
    return  v_supl_name;       
    
End cir_get_edtn_supl;
/


//////////////////////////////////////////////end/////////////////////////////////////////////


*****************************send sumit shama issue num:-4111*******************

CREATE OR REPLACE procedure cir_save_data_for_rr(
    pcompcode       in varchar2,
    punitcode       in varchar2,
    pedtncode       in varchar2,
    pagcd           in varchar2,
    pdpcd           in varchar2,
    psupdate        in varchar2,
    prrno           in varchar2,
    prr_date        in varchar2,
    prr_amt         in  number,
    puserid         in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2,
    pextra3         in varchar2,
    pextra4         in varchar2,
    pextra5         in varchar2,
    P_Accounts      OUT Cur_Type_New1.cursor_type)
  As
    
    v_dt        date;
    v_rrdt      date;
    v_rec_count number(5);
Begin
    v_dt   :=to_date(psupdate,''''||pdateformat||'''');
    v_rrdt :=to_date(prr_date,''''||pdateformat||'''');
    
    select count(*) into v_rec_count from cir_rr_detail where comp_code=pcompcode and unit_code=punitcode and 
        edtn_code=pedtncode and agcd=pagcd and dpcd=pdpcd and supdate=v_dt;
    if nvl(v_rec_count,0)=0 then
        insert into cir_rr_detail(comp_code,unit_code,edtn_code,agcd,dpcd,supdate,rr_no,rr_date,rr_amt,
                            created_by,created_dt)
        values(pcompcode,punitcode,pedtncode,pagcd,pdpcd,v_dt,prrno,v_rrdt,prr_amt,puserid,sysdate);
        commit;
        
        open P_Accounts for
        select 'I' as "MSG",sysdate as "CUR_DATE" from dual;    
    else
        update cir_rr_detail set rr_no =prrno,rr_date=v_rrdt,rr_amt=prr_amt,updated_by=puserid,updated_dt=sysdate
            where comp_code=pcompcode and unit_code=punitcode and edtn_code=pedtncode and agcd=pagcd and dpcd=pdpcd and 
            supdate=v_dt;
        open P_Accounts for
        select 'U' as "MSG",sysdate as "CUR_DATE" from dual;            
        commit;    
    end if;
        
End cir_save_data_for_rr;
/
////////////////////////////////////////////////////////////


CREATE OR REPLACE procedure cir_fetch_data_for_rr(
    pcompcode       in varchar2,
    punitcode       in varchar2,
    pagtype         in varchar2,
    pagclass        in varchar2,
    ppublcode       in varchar2,
    pmedtncode      in varchar2,
    pedtncode       in varchar2,
    pagcd           in varchar2,
    pdpcd           in varchar2,
    proutecode      in varchar2,
    psubrtcode      in varchar2,
    psubsubrtcode   in varchar2,
    proutemode      in varchar2,
    psupdate        in varchar2,
    puserid         in varchar2,
    pdateformat     in varchar2,
    prr_flag        in varchar2,--null for Both,1 for enter rr no.,2 for not enter rr no. 
    pextra1         in varchar2,
    pextra2         in varchar2,
    pextra3         in varchar2,
    pextra4         in varchar2,
    pextra5         in varchar2,
    P_Accounts      OUT Cur_Type_New1.cursor_type,
    P_Accounts1     OUT Cur_Type_New1.cursor_type)
  As
    
    v_dt    date;
Begin
    v_dt   :=to_date(psupdate,''''||pdateformat||'''');
    if prr_flag=1 then--for all
        open P_Accounts for
        select x.comp_code as "COMP_CODE" ,x.unit_code as "UNIT_CODE",x.agcd as "AGCD",x.dpcd as "DPCD",x.ag_name as "AGENCY_NAME",
        x.city_code as "CITY_CODE",x.city_name as "CITY_NAME",
        x.station_code as "DROP_POINT",x.drop_point_name as "DROP_POINT_NAME",
        x.publ as "PUBL",x.main_edtn as "MAIN_EDTN",x.main_edtn_name as "MAIN_EDTN_NAME", 
        x.edtn as "EDTN" ,x.edtn_name as "EDTN_NAME",x.billagcd as "BILLAGCD",x.billdpcd as "BILLDPCD",
        x.route_code as "ROUTE_CODE",x.route_name as "ROUTE_NAME",
        x.subroute_code as "SUBROUTE_CODE",x.subrt_name as "SUBRT_NAME", 
        x.subsubroute_code as "SUBSUBROUTE_CODE",x.subsubrt_name as "SUBSUBRT_NAME", 
        x.sup_copy as "SUP_COPY",x.rr_no as "RR_NO",to_char(x.rr_date,''||pdateformat||'') as "RR_DATE",x.rr_amt as "RR_AMT" from
        (select d.comp_code ,d.unit_code ,m.agcd ,m.dpcd,m.ag_name,
        m.city_code,cir_get_city(d.comp_code,m.city_code) as CITY_NAME,
        m.station_code ,cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,'1') as "DROP_POINT_NAME",
        d.publ,e.main_edtn,cir_get_edtn_name(d.comp_code,e.main_edtn) MAIN_EDTN_NAME, 
        d.edtn ,e.edtn_name,d.billagcd,d.billdpcd,d.route_code,r.route_name,
        d.subroute_code,(select subrt_name from cir_sub_route_mast where comp_code=d.comp_code and unit=d.unit_code and
        route_code=d.route_code and subrt_code=d.subroute_code) as SUBRT_NAME, 
        d.subsubroute_code,(select sub_subrt_name from cir_sub_subroute_mast where comp_code=d.comp_code and unit=d.unit_code and
        route_code=d.route_code and sub_subrt_code=d.subroute_code and sub_subrt_code=d.subsubroute_code) as SUBSUBRT_NAME, 
        sum(d.sup_copy) as SUP_COPY,null as "RR_NO",null as "RR_DATE",null as "RR_AMT"
        from cir_agmast m,cir_dbksup d,cir_edtn_mast e,cir_route_mode_mast rm,cir_route_mast r
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=r.comp_code and m.comp_code=rm.comp_code and m.comp_code=pcompcode and 
        m.unit=d.unit_code and m.unit=r.unit and m.agcd=d.agcd and m.agcd=nvl(pagcd,m.agcd) and m.dpcd=d.dpcd and m.dpcd=nvl(pdpcd,m.dpcd) and
        d.publ=e.publ and d.publ=nvl(ppublcode,d.publ) and 
        d.edtn=e.edtn and d.edtn=nvl(pedtncode,d.edtn) and e.main_edtn=nvl(pmedtncode,e.main_edtn) and
        d.supdate = v_dt and d.route_code=r.route_code and r.route_mode=rm.mode_code and (r.route_mode=proutemode or proutemode is null) and
        (m.ag_type=pagtype or pagtype is null) and (m.ag_class=pagclass or pagclass is null) and
        not exists (select 'x' from cir_rr_detail where comp_code=d.comp_code and unit_code=d.unit_code and edtn_code=d.edtn and 
        agcd=d.agcd and dpcd=d.dpcd and supdate=d.supdate)
        group by d.comp_code,d.unit_code,m.agcd,m.dpcd,m.ag_name,m.station_code,m.city_code,
        d.publ,d.edtn,d.billagcd,d.billdpcd,e.main_edtn,e.edtn_name,d.route_code,r.route_name,d.subroute_code,d.subsubroute_code
        union
        select d.comp_code ,d.unit_code ,m.agcd ,m.dpcd,m.ag_name,
        m.city_code,cir_get_city(d.comp_code,m.city_code) as CITY_NAME,
        m.station_code ,cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,'1') as "DROP_POINT_NAME",
        d.publ,e.main_edtn,cir_get_edtn_name(d.comp_code,e.main_edtn) MAIN_EDTN_NAME, 
        d.edtn ,e.edtn_name,d.billagcd,d.billdpcd,d.route_code,r.route_name,
        d.subroute_code,(select subrt_name from cir_sub_route_mast where comp_code=d.comp_code and unit=d.unit_code and
        route_code=d.route_code and subrt_code=d.subroute_code) as SUBRT_NAME, 
        d.subsubroute_code,(select sub_subrt_name from cir_sub_subroute_mast where comp_code=d.comp_code and unit=d.unit_code and
        route_code=d.route_code and sub_subrt_code=d.subroute_code and sub_subrt_code=d.subsubroute_code) as SUBSUBRT_NAME, 
        sum(d.sup_copy) as SUP_COPY,rr.rr_no as RR_NO,rr.rr_date ,rr.rr_amt
        from cir_agmast m,cir_dbksup d,cir_edtn_mast e,cir_route_mode_mast rm,cir_route_mast r,cir_rr_detail rr
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=r.comp_code and m.comp_code=rm.comp_code and 
        m.comp_code=rr.comp_code and m.comp_code=pcompcode and 
        m.unit=d.unit_code and m.unit=r.unit and m.unit=rr.unit_code and m.agcd=d.agcd and m.agcd=rr.agcd and m.agcd=nvl(pagcd,m.agcd) and 
        m.dpcd=d.dpcd and m.dpcd=rr.dpcd and m.dpcd=nvl(pdpcd,m.dpcd) and
        d.publ=e.publ and d.publ=nvl(ppublcode,d.publ) and 
        d.edtn=e.edtn and d.edtn=rr.edtn_code and d.edtn=nvl(pedtncode,d.edtn) and e.main_edtn=nvl(pmedtncode,e.main_edtn) and
        d.supdate = rr.supdate and d.supdate = v_dt and d.route_code=r.route_code and r.route_mode=rm.mode_code and (r.route_mode=proutemode or proutemode is null) and
        (m.ag_type=pagtype or pagtype is null) and (m.ag_class=pagclass or pagclass is null)
        group by d.comp_code,d.unit_code,m.agcd,m.dpcd,m.ag_name,m.station_code,m.city_code,
        d.publ,d.edtn,d.billagcd,d.billdpcd,e.main_edtn,e.edtn_name,d.route_code,r.route_name,d.subroute_code,d.subsubroute_code,
        rr.rr_no,rr.rr_date,rr.rr_amt) x
        order by city_name,agency_name,publ,edtn;
    
    elsif prr_flag='2' then--for enter RR No.
        open P_Accounts for
        select d.comp_code as "COMP_CODE" ,d.unit_code as "UNIT_CODE",m.agcd as "AGCD",m.dpcd as "DPCD",m.ag_name as "AGENCY_NAME",
        m.city_code as "CITY_CODE",cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",
        m.station_code as "DROP_POINT",cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,'1') as "DROP_POINT_NAME",
        d.publ as "PUBL",e.main_edtn as "MAIN_EDTN",cir_get_edtn_name(d.comp_code,e.main_edtn) as "MAIN_EDTN_NAME", 
        d.edtn as "EDTN" ,e.edtn_name as "EDTN_NAME",d.billagcd as "BILLAGCD",d.billdpcd as "BILLDPCD",d.route_code as "ROUTE_CODE",r.route_name as "ROUTE_NAME",
        d.subroute_code as "SUBROUTE_CODE",(select subrt_name from cir_sub_route_mast where comp_code=d.comp_code and unit=d.unit_code and
        route_code=d.route_code and subrt_code=d.subroute_code) as "SUBRT_NAME", 
        d.subsubroute_code as "SUBSUBROUTE_CODE",(select sub_subrt_name from cir_sub_subroute_mast where comp_code=d.comp_code and unit=d.unit_code and
        route_code=d.route_code and sub_subrt_code=d.subroute_code and sub_subrt_code=d.subsubroute_code) as "SUBSUBRT_NAME", 
        sum(d.sup_copy) as "SUP_COPY",rr.rr_no as "RR_NO",to_char(rr.rr_date,''||pdateformat||'') as "RR_DATE",rr.rr_amt as "RR_AMT"
        from cir_agmast m,cir_dbksup d,cir_edtn_mast e,cir_route_mode_mast rm,cir_route_mast r,cir_rr_detail rr
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=r.comp_code and m.comp_code=rm.comp_code and 
        m.comp_code=rr.comp_code and m.comp_code=pcompcode and 
        m.unit=d.unit_code and m.unit=r.unit and m.unit=rr.unit_code and m.agcd=d.agcd and m.agcd=rr.agcd and m.agcd=nvl(pagcd,m.agcd) and 
        m.dpcd=d.dpcd and m.dpcd=rr.dpcd and m.dpcd=nvl(pdpcd,m.dpcd) and
        d.publ=e.publ and d.publ=nvl(ppublcode,d.publ) and 
        d.edtn=e.edtn and d.edtn=rr.edtn_code and d.edtn=nvl(pedtncode,d.edtn) and e.main_edtn=nvl(pmedtncode,e.main_edtn) and
        d.supdate = rr.supdate and d.supdate = v_dt and d.route_code=r.route_code and r.route_mode=rm.mode_code and (r.route_mode=proutemode or proutemode is null) and
        (m.ag_type=pagtype or pagtype is null) and (m.ag_class=pagclass or pagclass is null)
        group by d.comp_code,d.unit_code,m.agcd,m.dpcd,m.ag_name,m.station_code,m.city_code,
        d.publ,d.edtn,d.billagcd,d.billdpcd,e.main_edtn,e.edtn_name,d.route_code,r.route_name,d.subroute_code,d.subsubroute_code,
        rr.rr_no,rr.rr_date,rr.rr_amt
        order by city_name,agency_name,publ,edtn;
          
    else--for not enter RR No.
        open P_Accounts for
        select d.comp_code as "COMP_CODE" ,d.unit_code as "UNIT_CODE",m.agcd as "AGCD",m.dpcd as "DPCD",m.ag_name as "AGENCY_NAME",
        m.city_code as "CITY_CODE",cir_get_city(d.comp_code,m.city_code) as "CITY_NAME",
        m.station_code as "DROP_POINT",cir_get_drop_point_name(d.comp_code,d.unit_code,m.station_code,'1') as "DROP_POINT_NAME",
        d.publ as "PUBL",e.main_edtn as "MAIN_EDTN",cir_get_edtn_name(d.comp_code,e.main_edtn) as "MAIN_EDTN_NAME", 
        d.edtn as "EDTN" ,e.edtn_name as "EDTN_NAME",d.billagcd as "BILLAGCD",d.billdpcd as "BILLDPCD",d.route_code as "ROUTE_CODE",r.route_name as "ROUTE_NAME",
        d.subroute_code as "SUBROUTE_CODE",(select subrt_name from cir_sub_route_mast where comp_code=d.comp_code and unit=d.unit_code and
        route_code=d.route_code and subrt_code=d.subroute_code) as "SUBRT_NAME", 
        d.subsubroute_code as "SUBSUBROUTE_CODE",(select sub_subrt_name from cir_sub_subroute_mast where comp_code=d.comp_code and unit=d.unit_code and
        route_code=d.route_code and sub_subrt_code=d.subroute_code and sub_subrt_code=d.subsubroute_code) as "SUBSUBRT_NAME", 
        sum(d.sup_copy) as "SUP_COPY",null as "RR_NO",null as "RR_DATE",null as "RR_AMT"
        from cir_agmast m,cir_dbksup d,cir_edtn_mast e,cir_route_mode_mast rm,cir_route_mast r
        where m.comp_code=d.comp_code and m.comp_code=e.comp_code and m.comp_code=r.comp_code and m.comp_code=rm.comp_code and m.comp_code=pcompcode and 
        m.unit=d.unit_code and m.unit=r.unit and m.agcd=d.agcd and m.agcd=nvl(pagcd,m.agcd) and m.dpcd=d.dpcd and m.dpcd=nvl(pdpcd,m.dpcd) and
        d.publ=e.publ and d.publ=nvl(ppublcode,d.publ) and 
        d.edtn=e.edtn and d.edtn=nvl(pedtncode,d.edtn) and e.main_edtn=nvl(pmedtncode,e.main_edtn) and
        d.supdate = v_dt and d.route_code=r.route_code and r.route_mode=rm.mode_code and (r.route_mode=proutemode or proutemode is null) and
        (m.ag_type=pagtype or pagtype is null) and (m.ag_class=pagclass or pagclass is null) and
        not exists (select 'x' from cir_rr_detail where comp_code=d.comp_code and unit_code=d.unit_code and edtn_code=d.edtn and 
        agcd=d.agcd and dpcd=d.dpcd and supdate=d.supdate)
        group by d.comp_code,d.unit_code,m.agcd,m.dpcd,m.ag_name,m.station_code,m.city_code,
        d.publ,d.edtn,d.billagcd,d.billdpcd,e.main_edtn,e.edtn_name,d.route_code,r.route_name,d.subroute_code,d.subsubroute_code
        order by city_name,agency_name,publ,edtn;    
    end if;
    
    open P_Accounts1 for
    select sysdate as "CUR_DATE" from dual;   
   
   
End cir_fetch_data_for_rr;
/


*****************************end issue 4111***********************
