************************ADD BY DEEPIKA 07/01/2013********************

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
P_WEIGHT_CAL IN VARCHAR2:=null,
P_misdata IN VARCHAR2:=null,
P_allowpremium IN VARCHAR2:=null,
p_financecode in varchar2:=null,
p_exepub in varchar2:=null,
p_executivecreditlimit in varchar2:=null,
--new add
P_postdis in  varchar2:=null,
P_suppdecreselimit in  varchar2:=null,
P_allowvat in  varchar2:=null,
P_alterroute in  varchar2:=null,
P_showrecptag in  varchar2:=null,
P_allowhoSUN in  varchar2:=null,
P_allowhoMON in  varchar2:=null,
P_allowhoTUE in  varchar2:=null,
P_allowhoWED in  varchar2:=null,
P_allowhoTHU in  varchar2:=null,
P_allowhoFRI in  varchar2:=null,
P_allowhoSAT in  varchar2:=null,
--new add
p_autoinfo  in  varchar2:=null,
p_sapid     in  varchar2 :=null,
p_mrv in varchar2:=null,
p_tradediscount in varchar2:=null,


p_fixedtransamt in float :=null,
p_schhr in varchar2:=null,
p_ret_after_bank IN varchar2:=null,
P_commedi_forunit  IN varchar2:=null,
P_min_max_validate_correction IN varchar2:=null,
P_basesupply_enablealteration  IN varchar2:=null,
P_UCN_PROCESS IN varchar2:=null,
P_update_estimation IN varchar2:=null,
P_email_sms_approval IN varchar2:=null
);
END      Wesp_Updatedate;
/


//////////////////////////////



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
P_WEIGHT_CAL IN VARCHAR2:=null,
P_misdata IN VARCHAR2:=null,
P_allowpremium IN VARCHAR2:=null,
p_financecode in varchar2:=null,
p_exepub in varchar2:=null,
p_executivecreditlimit in varchar2:=null,
--new add
P_postdis in  varchar2:=null,
P_suppdecreselimit in  varchar2:=null,
P_allowvat in  varchar2:=null,
P_alterroute in  varchar2:=null,
P_showrecptag in  varchar2:=null,
P_allowhoSUN in  varchar2:=null,
P_allowhoMON in  varchar2:=null,
P_allowhoTUE in  varchar2:=null,
P_allowhoWED in  varchar2:=null,
P_allowhoTHU in  varchar2:=null,
P_allowhoFRI in  varchar2:=null,
P_allowhoSAT in  varchar2:=null,
--new add
p_autoinfo  in  varchar2:=null,
p_sapid     in  varchar2 :=null,
p_mrv in varchar2:=null,
p_tradediscount in varchar2:=null,


p_fixedtransamt in float :=null,
p_schhr in varchar2:=null,
p_ret_after_bank IN varchar2:=null,
P_commedi_forunit  IN varchar2:=null,
P_min_max_validate_correction IN varchar2:=null,
P_basesupply_enablealteration  IN varchar2:=null,
P_UCN_PROCESS IN varchar2:=null,
P_update_estimation IN varchar2:=null,
P_email_sms_approval IN varchar2:=null


)AS
BEGIN
UPDATE LOGIN SET "date_format"=dateformat,
"Autogenerate"=code,"curr_code"=curr WHERE "COM_CODE"=compcode;
COMMIT;
       UPDATE PREFERRENCES SET  "autogenerated"=code,
"currency_code"=curr ,
"rate_gr_code"=RATECODE11,
"date_format"=dateformat,"solo"=solo,"breakup"=breakup,
"blackwhitecode"=bwcode,"rostatus"=rostatus,"File_name"=filename,"Tfn"=tfn,
"Insert_breakup"=insertbreak,"Premium_type"=prem,"Deal_type"=dealtype  ,
 "prefix"=pre, "suffix"=suff, "financestatus"=financestatus ,
"voucherst"=voucherst,
 "Ad_category"=adcode ,"Ro_datetime"=rodatetime
,"Space_area"=spacearea,"Vat"=vat,
 "Booking_status"=bookstat,"Cio_id"=cio_id,"Receipt_no"=receipt_no,"uom_code"=uom,
 "Bgcolor_publication"=bgcolor ,"chkfor_valid_pubdates"=validdate,
"Agency_ratecode"=agencyratecode,
 "audit"=AUDIT1,"book_insert_date"=book_insert_date,"agencycomm"=agencycomm,
 "rate_audit"=rateaudit,"bill_audit"=billaudit,"billtype"=bill_type,"invoice_no"=invoice_no1,
 "copy_booking"=copybooking,"RATE_COMPANY_AGENCY"=ratecompany,
"ADDITIONAL_AGENCY_COMM"=addagenycomm ,
 "AGENCY_RETAINER_COMM"=agencycommlinkretainer,"SUBEDITIONRATE"=subeditionr,
 "CLS_BILLTYPE"=classifiedbilltype,"DIS_BILLTYPE"=displaybilltype,"BILLING_FORMAT"=billformat,
 "RATE_CHECK"=ratechk,"ALL_PACKAGE"=allpkg,"DAYRATE"=dayrate1,"SCHEME_TYPE"=schemetype,"DISP_CLSBILL"=PIncludeclassi
 ,
 "CASH_RECEIPT_BILL"=v_cash_receipt,
"BILL_ORDERWSLAST"=v_bill_orderwiselast, "FLOOR_CHK"=v_floor_chk ,
 "UNSOLD_ENTRY_FLAG"=Unsoldflag
,"SUPPLY_STOP_PERCENTAGE"=Supplystopper,"ROKEYCHECK"=drpRokeychk ,
 "AGENCYCOMM_SEQ_COM"=Agencycomm_seq
,"CREDIT_RECIPT"=creditreciept,"DISP_CASHBILL"=cashindisplay,
 "CLA_CASHBILL"=cashinclassified,"RATE_AUDIT_PREF"=v_rate_audit_pref,"BARCODING_ALLOWED"=v_barcoding_allow_pref,
 "FMG_BILL_DIS" =v_fmgbills, "BILL_DISP_CASHBILL"=v_billed_cashdis ,
"BILL_CLA_CASHBILL"=v_billed_cashcls,"BACKDATERECEIPT"=v_drpbackdate,"DOCKIT_BOOKING"=dockitbooking,"Allowed_old_date"=allowprevbooking,"ROWISE_CASHBOOKING"=ro_wisecashbill,"CUTOFFTIME"=chkval,"APPROVAL"=approval1,"BACK_DAYS"=pckstatus
,CASH_DISCOUNT=cash_amt,CASH_DISCOUNTTYPE=cash_disc,SEPRATE_CASHIER=seperate_cashier1,
  CIR_MANY_TIME_POSTING=mantimepost, CIR_BACKDAYS_POSTING=bkdaypost,
CIR_MAX_RETURN_ALLOW=maxterutn, CIR_RETURN_LIMIT_ALLOW=cir_return,
CIR_NO_OF_CHQBOUNCE=noofchkbounc, CIR_DAYS_CHQBOUNCE=noofdaychkrec,
CIR_RETURN_DAYS=retday, CIR_SUP_ORDER_LIMIT=chngsuppord,
DISP_BILLING_CRITERIA=disp_bill,
CLSD_BILLING_CRITERIA=clas_bill,MAX_PUBLISHDAYS=max_publishday,BILLNO_PERIODICITY=p_billno_period,
  SPECIALDISC_TRANS_EDIT=spl_trans_edit,
SHARING_TRANS=spl_dis_trans_editable,
MULTIPACKAGE_SEL_TRANS=mul_pac_sel_trans,SCHEME_MINWORD=shmon_minword,
TRADE_SPLCHARGE=tradon_spcrg,RATE_AUTHORIZATION=rateauth
 ,F2_RECORD=f2day,PUBLISHAD_EDIT_RATEAUDIT=rateauditmodify,BINDREVENUE_CENTER=bindrevenuecenter,
 FA_LEDGER_ALLOW=p_led_allow
,CLEARANCE_TYPE_ALLOW=p_clear_allow,REPEAT_DAY_TYPE=repeatday,PREMIUM_EDIT=premiumedit,
BILL_GENERATION_PRIOR=P_BILL_GENERATION,PUBLICATION_HO=P_PUBLICATION_CENTER,SPLDISC_ALLOWPREM=P_allow_discount_prem,

BILL_SCHEME=P_SCHEME_BILLING,ALLOWED_PDC_DAYS_RECEIPT=P_ALLOW_PDC
,AD_TYPE_MANUL_BILL=PAD_TYPE_FOR_MANUL_BILL,OUTSTANDING_AMT_CRITERIA=RO_OUTSTAND_P,GENRATE_CIR_AGCD=genrate_agency_code,DISP_AUDITBKG=p_dispauditbk,CIR_DIS_AUTO_POSTING=p_aotosupply,RELAUTHREQON=p_Authorization,
CIR_AUTO_APPROVAL_UNSOLD=p_CIR_AUTO_APPROVAL_UNSOLD,CIR_AUTO_PHYSICAL_UNSOLD=p_CIR_AUTO_PHYSICAL_UNSOLD,CIR_UNSOLD_INCLUDE_INCT=p_CIR_UNSOLD_INCLUDE_INCT,
CIR_UNSOLD_INCLUDE_INSFEE=p_CIR_UNSOLD_INCLUDE_INSFEE,CIR_UNSOLD_ON_RECEIVED_DT=p_CIR_UNSOLD_ON_RECEIVED_DT,
AGENCY_UNBLOCK_APPROVAL=p_AGENCY_UNBLOCK_APROV,UNBLOCK_APPROVAL_OUTSIDE_LIMIT=p_UNBLOCK_APROV_OUT_LMT,CIR_BILL_PUBLWISE=p_CIR_BILL_PUBLWISE,
RECORDS_ON_PAGE = p_paging,RECORDS_ON_PRINT = p_print,HEADER_ON_PAGE =
p_allowpage,AGENCY_REQUIRED = p_agency_req,REGION_REQUIRED =
p_region_req,
ALLOW_FOLLOW_DT_BOOOK=p_ALLOW_FOLLOW_DT_BOOOK,CRM_SUPPLY_TYPE_PAID=p_CRM_SUPPLY_TYPE_PAID,CRM_SUPPLY_TYPE_FREE=p_CRM_SUPPLY_TYPE_FREE,
CURRENCY_MEASUREMENT=p_CURRENCY_MEASUREMENT,EDITABLE_AGENCY_COMM=p_EDITABLE_AGENCY_COMM,CANCELLATION_CHARGE=p_CANCELLATION_CHARGE,taxi_entry_type=P_taxi_entry_type,APPROVAL_WITH
=P_ApprovalWith , TDS_AUTO_CN=p_Auto_TDS_Credit_Note,
TDS_AUTO_REASON=p_TDS_Reason
,TDS_DB_CDP=p_Debit_Account_Head,TDS_CR_CDP=p_credit_Account_Head,SER_TAX_AUTO_CN=p_service_tax_credit_note,SER_TAX_AUTO_REASON=p_Tax_Reason,SER_TAX_DB_CDP=p_Debit_Account_Service_Tax,SER_TAX_CR_CDP=p_Credit_Account_Service_Tax,PKK_AUTO_CN=p_Auto_Patrakar_Credit_Note,PKK_AUTO_REASON=p_Patrakar_Reason
,PKK_DB_CDP=p_Debit_Account_Patrakar,PKK_CR_CDP=p_Credit_Account_Patrakar
,BANK_CHG_AUTO_CN=p_Auto_Bank_Credit_Note ,
BANK_CHG_AUTO_REASON=p_Bank_Reason
,BANK_CHG_DB_CDP=p_Debit_Account_Bank
,BANK_CHG_CR_CDP=p_Credit_Account_Bank ,


CIR_BARCODE=P_BAR_CODE, CIR_WIEGHT_CALC_REQ =P_WEIGHT_CAL, GEN_RCT_TYP
=P_GEN_RCT_TYP,PRODUCT_BRAND_REQ=P_misdata,ALLOWPREM_CARD_DISC_RATE=P_allowpremium,FINANCE_CADE=p_financecode,EXECUTIVE_PUBLICATION_VISE=p_exepub,
EXECUTIVECREDITLIMIT=p_executivecreditlimit,
FIXED_TRANSACTION_AMT=p_fixedtransamt,
TRADE_DIS_BASED_ON=p_tradediscount,


--NEW ADD
 CIR_POST_DIS=P_postdis,
 CIR_VAT_ALLOW=P_allowvat,
 CIR_SUP_ALT_ROUTE=P_alterroute,
 SHOW_REC_ALL_AGENCY=P_showrecptag,
 CIR_SUP_ORDER_DEC_LIMIT=P_suppdecreselimit,
 CIR_ALLOW_HOLIDAY_SUN=P_allowhoSUN,
 CIR_ALLOW_HOLIDAY_MON=P_allowhoMON,       
 CIR_ALLOW_HOLIDAY_TUE=P_allowhoTUE,
 CIR_ALLOW_HOLIDAY_WED=P_allowhoWED,
 CIR_ALLOW_HOLIDAY_THU=P_allowhoTHU,
 CIR_ALLOW_HOLIDAY_FRI=P_allowhoFRI,
 CIR_ALLOW_HOLIDAY_SAT=P_allowhoSAT,


CRM_AUTOINFO=p_autoinfo,
SAP_ID=p_sapid,
MRV_BASED_ON=p_mrv,
SCHEDULING_HOURS=p_schhr,ALLOW_RET_AFTER_BANK=p_ret_after_bank,
COMMON_EDITION_FOR_UNIT=P_commedi_forunit,
MIN_MAX_VALIDATE_IN_CORRECTION=P_min_max_validate_correction,
CIR_BASE_SUP_ENBL_SUPALTER=P_basesupply_enablealteration,
CIR_UCN_POCESS_IN_GROUP=P_UCN_PROCESS,
CIR_UPDATE_ESTIMATION=P_update_estimation,
CIR_EMAIL_SMS_IN_APPROVAL=P_email_sms_approval
 
  WHERE "comp_code"=compcode;
COMMIT;
END      Wesp_Updatedate_p;
END      Wesp_Updatedate;
/


///////////////////////////////////////////

CREATE OR REPLACE PACKAGE Currbindpreferpgld
IS
   TYPE t_account_cursor IS REF CURSOR;

   PROCEDURE currbindpreferpgld_p (
      compcode     IN       VARCHAR2,
      p_accounts   OUT      t_account_cursor
   );
END Currbindpreferpgld;
/


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
                cir_wieght_calc_req, gen_rct_typ, product_brand_req, ALLOWPREM_CARD_DISC_RATE,FINANCE_CADE,EXECUTIVE_PUBLICATION_VISE,EXECUTIVECREDITLIMIT,MRV_BASED_ON ,FIXED_TRANSACTION_AMT,TRADE_DIS_BASED_ON,
                CIR_POST_DIS,
    CIR_VAT_ALLOW,
    CIR_SUP_ALT_ROUTE,
    SHOW_REC_ALL_AGENCY,
    CIR_SUP_ORDER_DEC_LIMIT,
    CIR_ALLOW_HOLIDAY_SUN,
    CIR_ALLOW_HOLIDAY_MON,
    CIR_ALLOW_HOLIDAY_TUE,
    CIR_ALLOW_HOLIDAY_WED,
    CIR_ALLOW_HOLIDAY_THU,
    CIR_ALLOW_HOLIDAY_FRI,
    CIR_ALLOW_HOLIDAY_SAT,
    CRM_AUTOINFO,
    SAP_ID,
    SCHEDULING_HOURS,
    COMMON_EDITION_FOR_UNIT,
    MIN_MAX_VALIDATE_IN_CORRECTION,
	CIR_BASE_SUP_ENBL_SUPALTER,
    CIR_UCN_POCESS_IN_GROUP,
    CIR_UPDATE_ESTIMATION,
	CIR_EMAIL_SMS_IN_APPROVAL 
    
    
           FROM preferrences
          WHERE "comp_code" = compcode;
   END currbindpreferpgld_p;
END currbindpreferpgld;
/

////////////////////////////////////END//////////////////////////////////////





/***agency ledger**/
CREATE OR REPLACE PACKAGE cir_rep_agency_ledger IS
TYPE T_Accounts_Cursor is Ref Cursor;
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
    pextra1         in varchar2,
    pextra2         in varchar2,
    P_Accounts      out T_Accounts_Cursor,
    P_Accounts1     out T_Accounts_Cursor);    
END cir_rep_agency_ledger;
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
        case when cir_rcphdr.doctype='RCR' then (select "Payment_Mode_Name" from payment_mode_mast p1 where "Pay_Mode_Code"=cir_rcphdr.reason and cir_rcphdr.comp_code=p1."Comp_Code" and rownum=1)
        else (select reason_name from cir_reason_mst r where comp_code=cir_rcphdr.comp_code and reason_code=cir_rcphdr.reason and cir_rcphdr.comp_code=r."COMP_CODE" and rownum=1) end as reason,
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
    comp_code,unit_code,branch_code,(select "Branch_Name" from branch_mst b where "Branch_Code"=branch_code) branch_name,
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



/////////////////////////////////////////////////add by deepika 18/02/2013 sent by gaurav sir//////////////////////





CREATE GLOBAL TEMPORARY TABLE cir_branch_bill_dn_summary
(
    comp_code varchar2(20),
    unit_code varchar2(20),
    PUBL_code varchar2(20),
    PUBL_TYPE varchar2(20),
    BRANCH_CODE varchar2(20),
    INV_AMT  number(14,2),
    COM_AMT  number(14,2),        
    NET_AMT number(14,2),
    REMARKS varchar2(200),
    DOCTYPE varchar2(200)
)
ON COMMIT PRESERVE ROWS
NOCACHE;

CREATE GLOBAL TEMPORARY TABLE cir_branch_unsold_summary
(
    comp_code varchar2(20),
    unit_code varchar2(20),
    PUBL_code varchar2(20),
    PUBL_TYPE varchar2(20),
    BRANCH_CODE varchar2(20),
    INV_AMT  number(14,2),
    COM_AMT  number(14,2),        
    NET_AMT number(14,2),
    REMARKS varchar2(200),
    DOCTYPE varchar2(200)
)
ON COMMIT PRESERVE ROWS
NOCACHE;

CREATE GLOBAL TEMPORARY TABLE cir_branch_payment_cn_summary
(
    comp_code varchar2(20),
    unit_code varchar2(20),
    PUBL_code varchar2(20),
    PUBL_TYPE varchar2(20),
    BRANCH_CODE varchar2(20),
    INV_AMT  number(14,2),
    COM_AMT  number(14,2),        
    NET_AMT number(14,2),
    REMARKS varchar2(200),
    DOCTYPE varchar2(200)
)
ON COMMIT PRESERVE ROWS
NOCACHE;



CREATE OR REPLACE PROCEDURE cir_branch_summary
(
pcomp_code         in varchar2,
punit_code         in varchar2,
pbranch_code     in varchar2,
pdate            in varchar2,
pdateformat         in varchar2,
puserid             in varchar2,
pextra1             in varchar2,
pextra2             in varchar2,
pextra3             in varchar2,
pextra4             in varchar2,
pextra5             in varchar2,
pextra6             in varchar2,
pextra7             in varchar2,
pextra8             in varchar2,
pextra9             in varchar2,
pextra10             in varchar2,
p_accounts          OUT Cur_Type_New1.cursor_type,
p_accounts1          OUT Cur_Type_New1.cursor_type,
p_accounts2          OUT Cur_Type_New1.cursor_type,
p_accounts3          OUT Cur_Type_New1.cursor_type,
p_accounts4          OUT Cur_Type_New1.cursor_type,
p_accounts5          OUT Cur_Type_New1.cursor_type

)
IS
    v_dt        date;                                  
    v_opdate date;    
    vfrdt date;              
    vtodt date; 
    v_cl number(14,2);  
    
    sum_branch_comp_code varchar2(20);          
    sum_branch_unit_code varchar2(20);
    sum_branch_branch_code varchar2(20);
    
    sum_publ_publ varchar2(200);
    sum_edtn     varchar2(200);
    sum_edtn_name varchar2(200);

    v_opbal  number(18,2);
    v_close_bal  number(18,2);
    v_billamt  number(14,2);
    v_dbcramt  number(14,2);
    v_INV_AMT  number(14,2);
    v_COM_AMT  number(14,2);
    v_NET_AMT  number(14,2);
    v_dn_amt  number(14,2);
    v_late_ins  number(14,2);
    sum_reason_pay_code  varchar2(200);
    sum_reason_pay_name  varchar2(200);
                  
    
    
    
    
     cursor sum_branch is
        select distinct "Comp_Code","pub_center" ,"Branch_Code"  from branch_mst  
            where "Comp_Code" = pcomp_code and ("pub_center"=punit_code or punit_code is null or punit_code ='') 
            and ("Branch_Code"=pbranch_code or pbranch_code is null or pbranch_code ='')             
            order by "Comp_Code","pub_center" ,"Branch_Code";

     rec_branch sum_branch%rowtype;
     
      cursor sum_publ is
       select distinct  publ,pro_type,publ_name from cir_publ_mast where comp_code = pcomp_code order by pro_type;

     rec_publ sum_publ%rowtype;
     
     cursor sum_reason is
       select distinct  "Pay_Mode_Code", "Payment_Mode_Name" from PAYMENT_MODE_MAST where "Comp_Code" = pcomp_code order by "Payment_Mode_Name";

     rec_reason sum_reason%rowtype;
     
     vvar       varchar2(4000);
     vvar_sum   varchar2(4000);
     vvar_sum1  varchar2(4000);
     vquery     varchar2(8000);
    
    Begin

        v_dt  := to_date(pdate,''''||pdateformat||'''');
        v_opdate :=cir_get_finandt(pcomp_code,v_dt,pdateformat,null,null);--for financial date
            
        vfrdt:=v_opdate;
        vtodt:=v_dt-1;
       

        open sum_branch;
        loop
          fetch sum_branch into rec_branch;
          exit when sum_branch%notfound;
           
            v_opbal:=0;
            v_close_bal:=0;
            v_opbal :=cir_accounts.cir_branch_opbal(pcomp_code, punit_code,null,null, null, v_opdate, 'NM',pdateformat,sum_branch_branch_code,null);        
            
            select sum(amount) into v_billamt from cir_outmast
            where comp_code = pcomp_code and unit_code=punit_code and 
                BRANCH_CODE=rec_branch."Branch_Code" and billdt >= v_opdate and billdt<v_dt and 
                achd='NM' and recptno is null;

            select sum(amount) into v_dbcramt from cir_rcpdet
                where comp_code=pcomp_code and unit_code=punit_code and 
                    BRANCH_CODE=rec_branch."Branch_Code" and recptdt>= v_opdate and recptdt<v_dt and 
                    achd='NM' and billno is null;

             v_opbal:=nvl(v_opbal,0)+nvl(v_billamt,0)+nvl(v_dbcramt,0);
            
            ------------------  insert BF ----------------
            insert into cir_branch_bill_dn_summary(comp_code,unit_code,PUBL_code,PUBL_TYPE,BRANCH_CODE
            ,INV_AMT,COM_AMT,NET_AMT,REMARKS,DOCTYPE)    
            values (pcomp_code,sum_branch_unit_code,null,'BBF',rec_branch."Branch_Code",
            null,null,v_opbal,'Balance B/F','BBF');
            ---------------------------------------------    
          
            open sum_publ;
            loop
              fetch sum_publ into rec_publ;
              exit when sum_publ%notfound;
                
                    select sum(nvl(GROSS_AMOUNT,0)), sum(nvl(GROSS_AMOUNT,0))-sum(nvl(BILL_AMOUNT,0)),sum(nvl(BILL_AMOUNT,0)) 
                    into v_INV_AMT,v_COM_AMT,v_NET_AMT                            
                    from cir_bill_det where COMP_CODE=pcomp_code
                    and UNIT_CODE=rec_branch."pub_center" 
                    and BRANCH_CODE=rec_branch."Branch_Code"
                    and BILLDT =v_dt and PUBL=rec_publ.publ ;
                                            
                    if nvl(v_INV_AMT,0) >0 and nvl(v_NET_AMT,0)>0
                    then
                        ------------------  insert BILL ----------------
                        insert into cir_branch_bill_dn_summary(comp_code,unit_code,PUBL_code,PUBL_TYPE,BRANCH_CODE
                        ,INV_AMT,COM_AMT,NET_AMT,REMARKS,DOCTYPE)    
                        values (pcomp_code,rec_branch."Branch_Code",rec_publ.publ,sum_edtn,rec_branch."Branch_Code",
                        v_INV_AMT,v_COM_AMT,v_NET_AMT,'Bill For '||rec_publ.publ ,'BIL');
                        ---------------------------------------------    
                    end if;
                                                
                     v_INV_AMT:=0;
                     v_COM_AMT:=0;
                     v_NET_AMT:=0;
                                                
                    select SUM(nvl(copy_amt,0))+SUM(nvl(COMM_AMT,0)) , SUM(nvl(COMM_AMT,0)), SUM(nvl(copy_amt,0)) into v_INV_AMT,v_COM_AMT,v_NET_AMT
                    from CIR_UNSOLD_DTL 
                    where COMP_CODE=pcomp_code and UNIT_CODE=rec_branch."pub_center" 
                    and BRANCH_CODE=rec_branch."Branch_Code"
                    and PUBL=rec_publ.publ 
                    and APP_DT = v_dt
                    and (PROCESS_CRNO is not null or PROCESS_CRNO!='')
                    and (PROCESS_CRDT is not null or PROCESS_CRDT!='');
                                                
                    if nvl(v_INV_AMT,0) >0 and nvl(v_NET_AMT,0)>0
                    then
                        ------------------  insert UCN ----------------
                        insert into cir_branch_bill_dn_summary(comp_code,unit_code,PUBL_code,PUBL_TYPE,BRANCH_CODE
                        ,INV_AMT,COM_AMT,NET_AMT,REMARKS,DOCTYPE)    
                        values (pcomp_code,rec_branch."pub_center",rec_publ.publ,sum_edtn,rec_branch."Branch_Code",
                        v_INV_AMT,v_COM_AMT,v_NET_AMT,'UCN For '||rec_publ.publ ,'UCN');
                        ---------------------------------------------    
                    end if;
                
            end loop;
            close sum_publ;
           
            v_dn_amt:=0;
            select SUM(nvl(abs(amount),0)) into v_dn_amt from CIR_RCPHDR 
            where COMP_CODE=rec_branch."Comp_Code" and UNIT_CODE=rec_branch."pub_center" 
            and BRANCH_CODE=rec_branch."Branch_Code" and DOCTYPE='DN'
            and RECPTDT =v_dt;
                
            ------------------  insert DN ----------------
            insert into cir_branch_bill_dn_summary(comp_code,unit_code,PUBL_code,PUBL_TYPE,BRANCH_CODE
            ,INV_AMT,COM_AMT,NET_AMT,REMARKS,DOCTYPE)    
            values (pcomp_code,rec_branch."pub_center",null,'DN',rec_branch."Branch_Code",
            null,null,nvl(v_dn_amt,0),'Debit Note','DN');
            ---------------------------------------------
                
            v_late_ins:=0;
            select SUM(nvl(abs(amount),0)) into v_late_ins  from CIR_RCPHDR 
            where COMP_CODE=rec_branch."Comp_Code" and UNIT_CODE=rec_branch."pub_center" 
            and BRANCH_CODE=rec_branch."Branch_Code" and DOCTYPE='CN' and achd='NM'  and REASON='IN0'
            and RECPTDT =v_dt;
                
            ------------------  insert CN FOR IN0 ----------------
            insert into cir_branch_bill_dn_summary(comp_code,unit_code,PUBL_code,PUBL_TYPE,BRANCH_CODE
            ,INV_AMT,COM_AMT,NET_AMT,REMARKS,DOCTYPE)    
            values (pcomp_code,rec_branch."pub_center",null,'IN0',rec_branch."Branch_Code",
            null,null,nvl(v_late_ins,0),'INSERTION FEE','CN');
            ---------------------------------------------
                
            v_late_ins:=0;
            select SUM(nvl(abs(amount),0)) into v_late_ins from CIR_RCPHDR 
            where COMP_CODE=rec_branch."Comp_Code" and UNIT_CODE=rec_branch."pub_center" 
            and BRANCH_CODE=rec_branch."Branch_Code" and DOCTYPE='CN' and achd='NM'  and REASON='LA0'
            and RECPTDT =v_dt;
                
            ------------------  insert CN FOR LA0 ----------------
            insert into cir_branch_bill_dn_summary(comp_code,unit_code,PUBL_code,PUBL_TYPE,BRANCH_CODE
            ,INV_AMT,COM_AMT,NET_AMT,REMARKS,DOCTYPE)    
            values (pcomp_code,rec_branch."pub_center",null,'LA0',rec_branch."Branch_Code",
            null,null,nvl(v_late_ins,0),'LATE FACTOR FEE','CN');
            ---------------------------------------------
                
            v_late_ins:=0;
            select SUM(nvl(abs(amount),0)) into v_late_ins from CIR_RCPHDR 
            where COMP_CODE=rec_branch."Comp_Code" and UNIT_CODE=rec_branch."pub_center" 
            and BRANCH_CODE=rec_branch."Branch_Code" and DOCTYPE='CN' and achd='NM'  and REASON='TR0'
            and RECPTDT =v_dt;
                
            ------------------  insert CN FOR TR0 ----------------
            insert into cir_branch_bill_dn_summary(comp_code,unit_code,PUBL_code,PUBL_TYPE,BRANCH_CODE
            ,INV_AMT,COM_AMT,NET_AMT,REMARKS,DOCTYPE)    
            values (pcomp_code,rec_branch."pub_center",null,'TR0',rec_branch."Branch_Code",
            null,null,nvl(v_late_ins,0),'TRANSPORT ALLOWANCE FEE','CN');
            ---------------------------------------------
            
            open sum_reason;
            loop
              fetch sum_reason into rec_reason;
              exit when sum_reason%notfound;
              
                    v_late_ins:=0;
                    select SUM(nvl(abs(amount),0)) into v_late_ins from CIR_RCPHDR 
                    where COMP_CODE=rec_branch."Comp_Code" and UNIT_CODE=rec_branch."pub_center" 
                    and BRANCH_CODE=rec_branch."Branch_Code" and DOCTYPE='RCR'  and ACHD='NM'  and REASON=rec_reason."Pay_Mode_Code"
                    and RECPTDT =v_dt;
                                
                    ------------------  insert CN FOR TR0 ----------------
                    insert into cir_branch_bill_dn_summary(comp_code,unit_code,PUBL_code,PUBL_TYPE,BRANCH_CODE
                    ,INV_AMT,COM_AMT,NET_AMT,REMARKS,DOCTYPE)    
                    values (pcomp_code,rec_branch."pub_center",null,rec_reason."Pay_Mode_Code",rec_branch."Branch_Code",
                    null,null,nvl(v_late_ins,0),'PAYMENT RECEIVED BY '||rec_reason."Payment_Mode_Name" ,'RCR');
                            ---------------------------------------------
              
              end loop;
            close sum_reason;
            
            v_late_ins:=0;
            select SUM(nvl(abs(amount),0)) into v_late_ins from CIR_RCPHDR 
            where COMP_CODE=rec_branch."Comp_Code" and UNIT_CODE=rec_branch."pub_center" 
            and BRANCH_CODE=rec_branch."Branch_Code" and DOCTYPE='CN' and achd='NM'  and REASON not in ('LA0','TR0','IN0')
            and RECPTDT =v_dt;
                
            ------------------  insert CN FOR CN ----------------
            insert into cir_branch_bill_dn_summary(comp_code,unit_code,PUBL_code,PUBL_TYPE,BRANCH_CODE
            ,INV_AMT,COM_AMT,NET_AMT,REMARKS,DOCTYPE)    
            values (pcomp_code,rec_branch."pub_center",null,'CN',rec_branch."Branch_Code",
            null,null,nvl(v_late_ins,0),'CREDIT NOTE ADJUSTMENT ','CN');
            ---------------------------------------------    
                        
        end loop;
        close sum_branch;
commit;
        
     open p_accounts  for
     select comp_code,cir_get_unit_name(comp_code,unit_code) as UNIT,cir_get_branch(comp_code,branch_code) as BRANCH ,'BALANCE BROUGHT FORWARD' as REMARK 
    ,INV_AMT,COM_AMT,NET_AMT from cir_branch_bill_dn_summary  where DOCTYPE='BBF';
    
    open p_accounts1  for
    select comp_code,cir_get_unit_name(comp_code,unit_code) as UNIT,cir_get_branch(comp_code,branch_code) as BRANCH 
    ,(SELECT "pubname" from pub_type_mast p where p."Comp_Code"= comp_code and p."pubtypecode"=PUBL_TYPE) as REMARK  
    ,DOCTYPE
    ,sum(nvl(INV_AMT,0)) INV_AMT,sum(nvl(COM_AMT,0)) COM_AMT,sum(nvl(NET_AMT,0)) NET_AMT
    from cir_branch_bill_dn_summary where DOCTYPE ='BIL'
    group by comp_code,unit_code,branch_code,PUBL_TYPE,DOCTYPE
    union all
    select comp_code,cir_get_unit_name(comp_code,unit_code) as UNIT,cir_get_branch(comp_code,branch_code) as BRANCH 
    ,'DEBIT NOTE ADJUSTMENT' as REMARK  
    ,DOCTYPE
    ,sum(nvl(INV_AMT,0)) INV_AMT,sum(nvl(COM_AMT,0)) COM_AMT,sum(nvl(NET_AMT,0)) NET_AMT
    from cir_branch_bill_dn_summary where DOCTYPE ='DN'
    group by comp_code,unit_code,branch_code,PUBL_TYPE,DOCTYPE;
    
    open p_accounts2  for
    select comp_code,cir_get_unit_name(comp_code,unit_code) as UNIT,cir_get_branch(comp_code,branch_code) as BRANCH
    ,(SELECT "pubname" from pub_type_mast p where p."Comp_Code"= comp_code and p."pubtypecode"=PUBL_TYPE)
    as REMARK  
    ,sum(nvl(INV_AMT,0)) INV_AMT,sum(nvl(COM_AMT,0)) COM_AMT,sum(nvl(NET_AMT,0)) NET_AMT
    ,DOCTYPE
    from cir_branch_bill_dn_summary where DOCTYPE ='UCN'  
    group by comp_code,unit_code,branch_code,PUBL_TYPE,DOCTYPE
    union all
    select comp_code,cir_get_unit_name(comp_code,unit_code) as UNIT,cir_get_branch(comp_code,branch_code) as BRANCH 
    ,(SELECT REASON_NAME from CIR_REASON_MST p where p.Comp_Code= comp_code and p.REASON_CODE=PUBL_TYPE) 
    as REMARK  
    ,sum(nvl(INV_AMT,0)) INV_AMT,sum(nvl(COM_AMT,0)) COM_AMT,sum(nvl(NET_AMT,0)) NET_AMT
    ,DOCTYPE
    from cir_branch_bill_dn_summary where DOCTYPE ='CN'  and PUBL_TYPE in ('LA0','TR0','IN0')
    group by comp_code,unit_code,branch_code,PUBL_TYPE,DOCTYPE ;
    
    
    open p_accounts3  for
    select comp_code,cir_get_unit_name(comp_code,unit_code) as UNIT,cir_get_branch(comp_code,branch_code) as BRANCH 
    ,    (SELECT "Payment_Mode_Name" from payment_mode_mast p where p."Comp_Code"= comp_code and p."Pay_Mode_Code"=PUBL_TYPE) 
    as REMARK  
    ,sum(nvl(INV_AMT,0)) INV_AMT,sum(nvl(COM_AMT,0)) COM_AMT,sum(nvl(NET_AMT,0)) NET_AMT
    ,DOCTYPE
    from cir_branch_bill_dn_summary where DOCTYPE in ('RCR') 
    group by comp_code,unit_code,branch_code,PUBL_TYPE,DOCTYPE
    union all
    select comp_code,cir_get_unit_name(comp_code,unit_code) as UNIT,cir_get_branch(comp_code,branch_code) as BRANCH 
    ,nvl(
    (SELECT REASON_NAME from CIR_REASON_MST p where p.Comp_Code= comp_code and p.REASON_CODE=PUBL_TYPE) 
    ,(SELECT "Payment_Mode_Name" from payment_mode_mast p where p."Comp_Code"= comp_code and p."Pay_Mode_Code"=PUBL_TYPE)
    ) 
    as REMARK  
    ,sum(nvl(INV_AMT,0)) INV_AMT,sum(nvl(COM_AMT,0)) COM_AMT,sum(nvl(NET_AMT,0)) NET_AMT
    ,DOCTYPE
    from cir_branch_bill_dn_summary where DOCTYPE in ('CN')  and PUBL_TYPE not in ('LA0','TR0','IN0')
    group by comp_code,unit_code,branch_code,PUBL_TYPE,DOCTYPE ;
    
    
    
    --open p_accounts4  for
    select SUM(nvl(NET_AMT,0)) into v_cl from cir_branch_bill_dn_summary where DOCTYPE='BBF'
    group by comp_code,unit_code,branch_code ;
    
    open p_accounts4  for
    select x.comp_code,cir_get_unit_name(x.comp_code,x.unit_code) as UNIT,cir_get_branch(x.comp_code,x.branch_code) as BRANCH ,'BALANCE CARRY FORWARD' as REMARK 
    ,sum(nvl(x.INV_AMT,0)) INV_AMT,sum(nvl(x.COM_AMT,0)) COM_AMT,nvl(v_cl,0) + sum(nvl(x.db_amt,0)) as NET_AMT from (    
    select comp_code,unit_code,branch_code,sum(nvl(INV_AMT,0)) INV_AMT ,sum(nvl(COM_AMT,0)) COM_AMT, sum(nvl(NET_AMT,0)) DB_AMT from cir_branch_bill_dn_summary 
    where DOCTYPE in ('BIL','DN') group by comp_code,unit_code,branch_code
    union all
    select comp_code,unit_code,branch_code,sum(nvl(INV_AMT,0)) INV_AMT ,sum(nvl(COM_AMT,0)) COM_AMT, sum(-1*nvl(NET_AMT,0)) DB_AMT from cir_branch_bill_dn_summary 
    where DOCTYPE in ('RCR','UCN','CN') group by comp_code,unit_code,branch_code ) x
    group by x.comp_code,x.unit_code,x.branch_code ;
    
    open p_accounts5  for
    select x.COMP_CODE,cir_get_unit_name(x.comp_code,x.unit_code) as UNIT,cir_get_branch(x.comp_code,x.branch_code) as BRANCH 
    ,'BALANCE CARRY FORWARD' as REMARK ,nvl(SUM(nvl(abs(amount),0)),0) as SC_AMT from CIR_RCPHDR x
    where COMP_CODE=pcomp_code and UNIT_CODE=punit_code and DOCTYPE='RCR' and ACHD='SC' and RECPTDT =v_dt
    group by x.comp_code,x.unit_code,x.branch_code ;

   
End cir_branch_summary;
/



CREATE OR REPLACE PACKAGE cir_accounts is
  type t_accounts is ref cursor;
  Function cir_agency_opbal(
      pcomp_code             in varchar2,
      punit_code             in varchar2,
      ppubl                  in varchar2,
      pagcd                                in varchar2,
      pdpcd                                in varchar2,
      popdate                            in date,
      pactype                            in varchar2,
      pdateformat             in varchar2,
      pextra1             in varchar2,
      pextra2             in varchar2) return number;
  Function cir_agency_ytodt(
      pcomp_code             in varchar2,
      punit_code             in varchar2,
      ppubl                  in varchar2,
      pagcd                                in varchar2,
      pdpcd                                in varchar2,
      pfromdate                        in date,
      ptilldate                        in date,
      pactype                            in varchar2,
      pdateformat             in varchar2,
      pextra1             in varchar2,
      pextra2             in varchar2) return number;
    Function cir_branch_opbal(
      pcomp_code             in varchar2,
      punit_code             in varchar2,
      ppubl                  in varchar2,
      pagcd                                in varchar2,
      pdpcd                                in varchar2,
      popdate                            in date,
      pactype                            in varchar2,
      pdateformat             in varchar2,
      pextra1             in varchar2,
      pextra2             in varchar2) return number;
End cir_accounts;
/




CREATE OR REPLACE PACKAGE BODY cir_accounts IS
  /* for opening on financial Date*/
  Function cir_agency_opbal(
    pcomp_code      in varchar2,
    punit_code      in varchar2,
    ppubl           in varchar2,
    pagcd           in varchar2,
    pdpcd           in varchar2,
    popdate         in date,
    pactype         in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2) return number is

    v_opbal     number:=0;
    v_findt     date;
 Begin
  --v_findt  :=cir_get_finandt(pcomp_code,popdate,pdateformat,'','');
  v_findt  :=popdate;
  if upper(pextra2)='D' then
      IF ppubl IS NULL THEN
        SELECT SUM(opbal)
          INTO v_opbal
          FROM (SELECT SUM (sec_opbal) AS opbal
                  FROM cir_agomast_dis
                 WHERE comp_code = pcomp_code
                   AND unit_code = punit_code
                   AND agcd = pagcd
                   AND dpcd = pdpcd
                   AND for_month = v_findt
                   AND pactype = 'SC'
                UNION
                SELECT SUM (opbal) AS opbal
                  FROM cir_agomast_dis
                 WHERE comp_code = pcomp_code
                   AND unit_code = punit_code
                   AND agcd = pagcd
                   AND dpcd = pdpcd
                   AND for_month = v_findt
                   AND pactype <> 'SC');
      Else
        SELECT SUM(opbal)
          INTO v_opbal
          FROM (SELECT SUM (sec_opbal) AS opbal
                  FROM cir_agomast_dis
                 WHERE comp_code = pcomp_code
                   AND unit_code = punit_code
                   AND publ = ppubl
                   AND agcd = pagcd
                   AND dpcd = pdpcd
                   AND for_month = v_findt
                   AND pactype = 'SC'
                UNION
                SELECT SUM (opbal) AS opbal
                  FROM cir_agomast_dis
                 WHERE comp_code = pcomp_code
                   AND unit_code = punit_code
                   AND publ = ppubl
                   AND agcd = pagcd
                   AND dpcd = pdpcd
                   AND for_month = v_findt
                   AND pactype <> 'SC');
      End if;
  else
      IF ppubl IS NULL THEN
        SELECT SUM(opbal)
          INTO v_opbal
          FROM (SELECT SUM (sec_opbal) AS opbal
                  FROM cir_agomast
                 WHERE comp_code = pcomp_code
                   AND unit_code = punit_code
                   AND agcd = pagcd
                   AND dpcd = pdpcd
                   AND for_month = v_findt
                   AND pactype = 'SC'
                UNION
                SELECT SUM (opbal) AS opbal
                  FROM cir_agomast
                 WHERE comp_code = pcomp_code
                   AND unit_code = punit_code
                   AND agcd = pagcd
                   AND dpcd = pdpcd
                   AND for_month = v_findt
                   AND pactype <> 'SC');
      Else
        SELECT SUM(opbal)
          INTO v_opbal
          FROM (SELECT SUM (sec_opbal) AS opbal
                  FROM cir_agomast
                 WHERE comp_code = pcomp_code
                   AND unit_code = punit_code
                   AND publ = ppubl
                   AND agcd = pagcd
                   AND dpcd = pdpcd
                   AND for_month = v_findt
                   AND pactype = 'SC'
                UNION
                SELECT SUM (opbal) AS opbal
                  FROM cir_agomast
                 WHERE comp_code = pcomp_code
                   AND unit_code = punit_code
                   AND publ = ppubl
                   AND agcd = pagcd
                   AND dpcd = pdpcd
                   AND for_month = v_findt
                   AND pactype <> 'SC');
      End if;  
  end if;
      RETURN NVL(v_opbal,0);
  End cir_agency_opbal;
 /* for from Date to till date*/
  Function cir_agency_ytodt(
    pcomp_code      in varchar2,
    punit_code      in varchar2,
    ppubl           in varchar2,
    pagcd           in varchar2,
    pdpcd           in varchar2,
    pfromdate       in date,
    ptilldate       in date,
    pactype         in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2) return number is

    v_amt       number:=0;
    v_billamt   number:=0;
    v_frdt      date;
    v_todt      date;
 Begin
    v_frdt :=pfromdate;--to_date(pfromdate,''''||pdateformat||'''');
    v_todt :=ptilldate;--to_date(ptilldate,''''||pdateformat||'''');
    if upper(pextra2)='D' then
        IF ppubl IS NULL THEN
            SELECT SUM (amt)
              INTO v_amt
              FROM (SELECT SUM (amount) AS amt
                      FROM cir_rcphdr_dis
                     WHERE comp_code = pcomp_code
                       AND unit_code = punit_code
                       AND agcd = pagcd
                       AND dpcd = pdpcd
                       AND recptdt >= v_frdt
                       AND recptdt < v_todt
                       AND achd = pactype
                    UNION ALL
                    SELECT SUM (amount) AS amt
                      FROM cir_outmast_dis
                     WHERE comp_code = pcomp_code
                       AND unit_code = punit_code
                       AND agcd = pagcd
                       AND dpcd = pdpcd
                       AND recptno IS NULL
                       AND recptdt IS NULL
                       AND achd = pactype
                       AND billdt >= v_frdt
                       AND billdt < v_todt);
        ELSE
            SELECT SUM (amt)
              INTO v_amt
              FROM (SELECT SUM (amount) AS amt
                      FROM cir_rcphdr_dis
                     WHERE comp_code = pcomp_code
                       AND unit_code = punit_code
                       AND agcd = pagcd
                       AND dpcd = pdpcd
                       AND recptdt >= v_frdt
                       AND recptdt < v_todt
                       AND achd = pactype
                       AND publ = ppubl
                    UNION ALL
                    SELECT SUM (amount) AS amt
                      FROM cir_outmast_dis
                     WHERE comp_code = pcomp_code
                       AND unit_code = punit_code
                       AND agcd = pagcd
                       AND dpcd = pdpcd
                       AND recptno IS NULL
                       AND recptdt IS NULL
                       AND achd = pactype
                       AND billdt >= v_frdt
                       AND billdt < v_todt
                       AND publ = ppubl);
        END IF;
    else
        IF ppubl IS NULL THEN
            SELECT SUM (amt)
              INTO v_amt
              FROM (SELECT SUM (amount) AS amt
                      FROM cir_rcphdr
                     WHERE comp_code = pcomp_code
                       AND unit_code = punit_code
                       AND agcd = pagcd
                       AND dpcd = pdpcd
                       AND recptdt >= v_frdt
                       AND recptdt < v_todt
                       AND achd = pactype
                    UNION ALL
                    SELECT SUM (amount) AS amt
                      FROM cir_outmast
                     WHERE comp_code = pcomp_code
                       AND unit_code = punit_code
                       AND agcd = pagcd
                       AND dpcd = pdpcd
                       AND recptno IS NULL
                       AND recptdt IS NULL
                       AND achd = pactype
                       AND billdt >= v_frdt
                       AND billdt < v_todt);
        ELSE
            SELECT SUM (amt)
              INTO v_amt
              FROM (SELECT SUM (amount) AS amt
                      FROM cir_rcphdr
                     WHERE comp_code = pcomp_code
                       AND unit_code = punit_code
                       AND agcd = pagcd
                       AND dpcd = pdpcd
                       AND recptdt >= v_frdt
                       AND recptdt < v_todt
                       AND achd = pactype
                       AND publ = ppubl
                    UNION ALL
                    SELECT SUM (amount) AS amt
                      FROM cir_outmast
                     WHERE comp_code = pcomp_code
                       AND unit_code = punit_code
                       AND agcd = pagcd
                       AND dpcd = pdpcd
                       AND recptno IS NULL
                       AND recptdt IS NULL
                       AND achd = pactype
                       AND billdt >= v_frdt
                       AND billdt < v_todt
                       AND publ = ppubl);
        END IF;
    end if;

   RETURN NVL(v_amt,0);
 End cir_agency_ytodt; 
 Function cir_branch_opbal(
    pcomp_code      in varchar2,
    punit_code      in varchar2,
    ppubl           in varchar2,
    pagcd           in varchar2,
    pdpcd           in varchar2,
    popdate         in date,
    pactype         in varchar2,
    pdateformat     in varchar2,
    pextra1         in varchar2,
    pextra2         in varchar2) return number is

    v_opbal     number:=0;
    v_findt     date;
 Begin
  --v_findt  :=cir_get_finandt(pcomp_code,popdate,pdateformat,'','');
  v_findt  :=popdate;
    IF pactype = 'SC' 
    then 
            begin
            
			SELECT sec_opbal into v_opbal FROM  cir_agomast  WHERE	 comp_code  = pcomp_code
			AND	(unit_code  = punit_code OR	punit_code  is null  OR	punit_code = '')
			AND	(publ  = ppubl OR	ppubl  is null OR	ppubl = '')
			AND	agcd+dpcd in( SELECt distinct AGCD+dpcd from cir_agmast where COMP_CODE=pcomp_code 
			and UNIT_CODE=punit_code and BRANCH_CODE=pextra1 )			
			AND	for_month  = v_findt;
            exception when no_data_found then
            v_opbal:=0;
            end;
            		
	
	ELSE
	        begin
			SELECT  opbal into v_opbal FROM  cir_agomast  WHERE	 comp_code  = pcomp_code
			AND	(unit_code  = punit_code  OR	punit_code  is null OR	punit_code = '')
			AND	(publ  = ppubl OR	ppubl  is null OR	ppubl = '')
			AND	agcd+dpcd in( SELECt distinct AGCD+dpcd from cir_agmast where COMP_CODE=pcomp_code 
			and UNIT_CODE=punit_code and BRANCH_CODE=pextra1 )
			AND	for_month  = v_findt;
            exception when no_data_found then
            v_opbal:=0;
            end;
            		
	END if;
      RETURN NVL(v_opbal,0);
  End cir_branch_opbal;
 
End cir_accounts;
/


////////////////////////////////////////////////////////////end//////////////////////////////////////////